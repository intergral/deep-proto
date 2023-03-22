#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

PROJECT_ROOT="$(dirname "SCRIPT_DIR")"

OUT_DIR="${PROJECT_ROOT}/build"

PYTHON_OUT="${OUT_DIR}/python"

rm -Rf ${PYTHON_OUT}

mkdir -p ${PYTHON_OUT}/src

for f in $(find ${PROJECT_ROOT}/deep -name '*.proto'); do python -m grpc_tools.protoc  -I ${PROJECT_ROOT} --python_out=${PYTHON_OUT}/src $f; done

python -m grpc_tools.protoc -I ${PROJECT_ROOT} --python_out=${PYTHON_OUT}/src --grpc_python_out=${PYTHON_OUT}/src ${PROJECT_ROOT}/deep/proto/poll/v1/poll.proto

cp pyproject.toml ${PYTHON_OUT}
