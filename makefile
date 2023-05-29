#     Copyright (C) 2023  Intergral GmbH
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as
#    published by the Free Software Foundation, either version 3 of the
#    License, or (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.

.DEFAULT_GOAL := gen-all

PROJECT_ROOT:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

.PHONY: check-proto
check-proto:
ifndef OUT_DIR
	$(error OUT_DIR variable was not defined)
endif
ifndef PROTOC_ARGS
	$(error PROTOC_ARGS variable was not defined)
endif
ifndef GRPC_PROTOC_ARGS
	$(error GRPC_PROTOC_ARGS variable was not defined)
endif

DOCKER_PROTOBUF_IMAGE ?= otel/build-protobuf:latest
PROTOC = docker run --rm -u ${shell id -u} -v${PWD}:${PWD} -w${PWD} ${DOCKER_PROTOBUF_IMAGE} --proto_path=${PWD}
ROOT_DIR=$(shell pwd)

.PHONY: gen-proto
gen-proto: check-proto
	rm -Rf $(OUT_DIR)
	mkdir -p $(OUT_DIR)

	# All proto files need to be processed as proto
	$(foreach file, $(shell find $(ROOT_DIR)/deepproto -name '*.proto'), ${PROTOC} ${PROTOC_ARGS} $(file);)

	# only proto files with services need to be generated with grpc
	$(PROTOC) $(PROTOC_ARGS) $(GRPC_PROTOC_ARGS) $(ROOT_DIR)/deepproto/proto/poll/v1/poll.proto
	$(PROTOC) $(PROTOC_ARGS) $(GRPC_PROTOC_ARGS) $(ROOT_DIR)/deepproto/proto/tracepoint/v1/tracepoint.proto

.PHONY: gen-python
gen-python:
	OUT_DIR=$(ROOT_DIR)/build/python PROTOC_ARGS=--python_out=$(ROOT_DIR)/build/python GRPC_PROTOC_ARGS=--grpc-python_out=$(ROOT_DIR)/build/python $(MAKE) gen-proto
	cp $(ROOT_DIR)/pyproject.toml $(ROOT_DIR)/build/python

.PHONY: gen-go
gen-go:
	OUT_DIR=$(ROOT_DIR)/build/go PROTOC_ARGS=--go_out=$(ROOT_DIR)/build/go GRPC_PROTOC_ARGS=--go-grpc_out=$(ROOT_DIR)/build/go $(MAKE) gen-proto

.PHONY: gen-java
gen-java:
	OUT_DIR=$(ROOT_DIR)/build/java/src/main/java PROTOC_ARGS=--java_out=$(ROOT_DIR)/build/java/src/main/java GRPC_PROTOC_ARGS=--grpc-java_out=$(ROOT_DIR)/build/java/src/main/java $(MAKE) gen-proto
	cp $(ROOT_DIR)/pom.xml $(ROOT_DIR)/build/java/pom.xml
	mvn -U -B -f $(ROOT_DIR)/build/java/pom.xml clean package

.PHONY: gen-all
gen-all:
	$(MAKE) gen-go
	$(MAKE) gen-python
	$(MAKE) gen-java

.PHONY: gen-docs
gen-docs:
	docker run --rm -u ${shell id -u}  -v $(ROOT_DIR)/docs:/out -v $(ROOT_DIR):/protos pseudomuto/protoc-gen-doc --doc_opt=markdown,tracepoint.md deepproto/proto/tracepoint/v1/tracepoint.proto
	docker run --rm -u ${shell id -u}  -v $(ROOT_DIR)/docs:/out -v $(ROOT_DIR):/protos pseudomuto/protoc-gen-doc --doc_opt=markdown,poll.md deepproto/proto/poll/v1/poll.proto
	docker run --rm -u ${shell id -u}  -v $(ROOT_DIR)/docs:/out -v $(ROOT_DIR):/protos pseudomuto/protoc-gen-doc --doc_opt=markdown,common.md deepproto/proto/common/v1/common.proto
	docker run --rm -u ${shell id -u}  -v $(ROOT_DIR)/docs:/out -v $(ROOT_DIR):/protos pseudomuto/protoc-gen-doc --doc_opt=markdown,resource.md deepproto/proto/resource/v1/resource.proto

.PHONY: gen-mvn-site
gen-mvn-site: gen-java
	mkdir -p $(ROOT_DIR)/build/java/src/site/markdown
	cp $(ROOT_DIR)/java/site.xml $(ROOT_DIR)/build/java/src/site/site.xml
	cp $(ROOT_DIR)/README_JAVA.md $(ROOT_DIR)/build/java/src/site/markdown/README.md
	mvn -U -B -f $(ROOT_DIR)/build/java/pom.xml site

.PHONY: check-version
check-version:
ifdef v
VERSION=$(v)
endif
ifdef V
VERSION=$(V)
endif
ifndef VERSION
	$(error VERSION argument must be defined. (make rel-python VERSION=0.0.2))
endif

.PHONY: check-python-vars
check-python-vars:
ifndef TWINE_USER
	$(error TWINE_USER argument must be defined.)
endif
ifndef TWINE_PASSWORD
	$(error TWINE_PASSWORD argument must be defined.)
endif

.PHONY: rel-python
rel-python: check-version check-python-vars gen-python
	sed -i "s/VERSION/$(VERSION)/" $(ROOT_DIR)/build/python/pyproject.toml

	python -m build $(PROJECT_ROOT)/build/python

	python -m twine upload -u $(TWINE_USER) -p $(TWINE_PASSWORD) $(PROJECT_ROOT)/build/python/dist/*


.PHONY: rel-go
rel-go: check-version gen-go
	rm -Rf $(PROJECT_ROOT)/go-deep-proto

	git submodule update --init

	cd $(PROJECT_ROOT)/go-deep-proto; git pull origin master

	cp -r $(ROOT_DIR)/build/go/github.com/intergral/go-deep-proto/* $(ROOT_DIR)/go-deep-proto

	cd $(PROJECT_ROOT)/go-deep-proto; git config user.name github-actions

	cd $(PROJECT_ROOT)/go-deep-proto; git config user.email github-actions@github.com

	cd $(PROJECT_ROOT)/go-deep-proto; git add .

	cd $(PROJECT_ROOT)/go-deep-proto; git commit -m "Published new api version from $(VERSION)" || echo "No changes, nothing to commit!"

	cd $(PROJECT_ROOT)/go-deep-proto; git push -u origin HEAD:master

	cd $(PROJECT_ROOT)/go-deep-proto; git tag v$(VERSION)

	cd $(PROJECT_ROOT)/go-deep-proto; git push -u origin v$(VERSION)


check-java-env:
ifndef OSS_PASSWORD
	$(error OSS_PASSWORD must be defined)
endif
ifndef OSS_USERNAME
	$(error OSS_USERNAME must be defined)
endif
ifndef GPG_PASSPHRASE
	$(error GPG_PASSPHRASE must be defined)
endif

.PHONY: rel-java
rel-java: check-version check-java-env gen-java
	mvn -f $(ROOT_DIR)/build/java/pom.xml versions:set -DnewVersion=$(VERSION) -B -U
	mvn -f $(ROOT_DIR)/build/java/pom.xml -s .ci-settings.xml clean deploy -P release-ossrh -B -U


.PHONY: clean
clean:
	rm -Rf site _site build