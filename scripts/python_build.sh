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

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

PROJECT_ROOT="$(realpath $(dirname "SCRIPT_DIR"))"

OUT_DIR="${PROJECT_ROOT}/build"

PYTHON_OUT="${OUT_DIR}/python"

PROTOC=${PROTOC:="docker run --rm -u 1000 -v${PROJECT_ROOT}:${PROJECT_ROOT} -w${PROJECT_ROOT} otel/build-protobuf:latest"}

rm -Rf ${PYTHON_OUT}

mkdir -p ${PYTHON_OUT}/src

# All proto files need to be processed as proto
for f in $(find ${PROJECT_ROOT}/deepproto -name '*.proto'); do ${PROTOC} --proto_path ${PROJECT_ROOT} --python_out=${PYTHON_OUT}/src $f; done

# only proto files with services need to be generated with grpc
eval "${PROTOC} --proto_path ${PROJECT_ROOT} --python_out=${PYTHON_OUT}/src --grpc-python_out=${PYTHON_OUT}/src ${PROJECT_ROOT}/deepproto/proto/poll/v1/poll.proto"
eval "${PROTOC} --proto_path ${PROJECT_ROOT} --python_out=${PYTHON_OUT}/src --grpc-python_out=${PYTHON_OUT}/src ${PROJECT_ROOT}/deepproto/proto/tracepoint/v1/tracepoint.proto"

cp pyproject.toml ${PYTHON_OUT}
