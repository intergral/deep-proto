
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

if [[ "${VERSION}-" == "-" ]]; then
  echo "Must specify version."
  exit 1
fi

echo "Building version ${VERSION} for Go"

source ${SCRIPT_DIR}/go_build.sh

cp -r ${OUT_DIR}/github.com/intergral/go-deep-proto/* ${PROJECT_ROOT}/go-deep-proto

cd ${PROJECT_ROOT}/go-deep-proto

git add .

git commit -m "Published new api version from $VERSION" || echo "No changes, nothing to commit!"

git push -u origin master

git tag v${VERSION}

git push -u origin v${VERSION} HEAD:master