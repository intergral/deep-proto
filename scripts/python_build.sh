#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

PROJECT_ROOT="$(realpath $(dirname "SCRIPT_DIR"))"

OUT_DIR="${PROJECT_ROOT}/build"

PYTHON_OUT="${OUT_DIR}/python"

PROTOC=${PROTOC:="docker run --rm -u 1000 -v${PROJECT_ROOT}:${PROJECT_ROOT} -w${PROJECT_ROOT} otel/build-protobuf:latest"}

rm -Rf ${PYTHON_OUT}

mkdir -p ${PYTHON_OUT}/src

for f in $(find ${PROJECT_ROOT}/deepproto -name '*.proto'); do ${PROTOC} --proto_path ${PROJECT_ROOT} --python_out=${PYTHON_OUT}/src $f; done

eval "${PROTOC} --proto_path ${PROJECT_ROOT} --python_out=${PYTHON_OUT}/src --grpc-python_out=${PYTHON_OUT}/src ${PROJECT_ROOT}/deepproto/proto/poll/v1/poll.proto"

cp pyproject.toml ${PYTHON_OUT}
