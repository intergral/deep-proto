
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

DOCKER_PROTOBUF_IMAGE ?= otel/build-protobuf:0.14.0
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

.PHONY: rel-python
rel-python: check-version gen-python
	sed -i "s/VERSION/$(VERSION)/" $(ROOT_DIR)/build/python/pyproject.toml

	python -m build $(PROJECT_ROOT)/build/python

	python -m twine upload $(PROJECT_ROOT)/build/python/dist/*



.PHONY: rel-go
rel-go: check-version gen-go
	git submodule sync --recursive
	git submodule update --remote --recursive

	cp -r $(ROOT_DIR)/build/go/github.com/intergral/go-deep-proto/* $(ROOT_DIR)/go-deep-proto

	cd $(PROJECT_ROOT)/go-deep-proto

	git add .

	git commit -m "Published new api version from $VERSION" || echo "No changes, nothing to commit!"

	git push -u origin master

	git tag v${VERSION}

	git push -u origin v${VERSION} HEAD:master