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

VERSION=${1:-$CI_COMMIT_TAG}

echo "Building version ${VERSION} for python"

eval $(${SCRIPT_DIR}/python_build.sh)

sed -i "s/VERSION/${VERSION}/" ${PROJECT_ROOT}/build/python/pyproject.toml

python -m build ${PROJECT_ROOT}/build/python

python -m twine upload ${PROJECT_ROOT}/build/python/dist/*
