#!/usr/bin/env bash

#
#    Copyright 2023 Intergral GmbH
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#

# This is a general build for the protoc files

PROJECT_ROOT=${PROJECT_ROOT}
PROTOC=${PROTOC:="docker run --rm -u 1000 -v${PROJECT_ROOT}:${PROJECT_ROOT} -w${PROJECT_ROOT} otel/build-protobuf:latest"}
OUT_DIR=${OUT_DIR:="-"}
PROTOC_ARGS=${PROTOC_ARGS:="-"}
GRPC_PROTOC_ARGS=${GRPC_PROTOC_ARGS:="-"}

if [[ ${OUT_DIR} == "-" ]]; then
  echo "Must specify OUT_DIR"
  exit 1
else
  echo "Building into ${OUT_DIR}"
fi

if [[ ${PROTOC_ARGS} == "-" ]]; then
  echo "Must specify PROTOC_ARGS"
  exit 1
fi

if [[ ${GRPC_PROTOC_ARGS} == "-" ]]; then
  echo "Must specify GRPC_PROTOC_ARGS"
  exit 1
fi

echo "Building using args ${PROTOC_ARGS} ${GRPC_PROTOC_ARGS} ${PROJECT_ROOT}"

rm -Rf ${OUT_DIR}

mkdir -p ${OUT_DIR}

# All proto files need to be processed as proto
for f in $(find ${PROJECT_ROOT}/deepproto -name '*.proto'); do ${PROTOC} --proto_path ${PROJECT_ROOT} ${PROTOC_ARGS} $f; done

# only proto files with services need to be generated with grpc
eval "${PROTOC} --proto_path ${PROJECT_ROOT} ${PROTOC_ARGS} ${GRPC_PROTOC_ARGS} ${PROJECT_ROOT}/deepproto/proto/poll/v1/poll.proto"
eval "${PROTOC} --proto_path ${PROJECT_ROOT} ${PROTOC_ARGS} ${GRPC_PROTOC_ARGS} ${PROJECT_ROOT}/deepproto/proto/tracepoint/v1/tracepoint.proto"
