
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

.PHONY: gen-proto
gen-proto: check-proto
	./scripts/proto_build.sh

.PHONY: gen-python
gen-python:
	$(PROJECT_ROOT)/scripts/python_build.sh

.PHONY: gen-go
gen-go:
	$(PROJECT_ROOT)/scripts/go_build.sh
