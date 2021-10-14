#!/usr/bin/env sh

set -eu

bindir=$( cd "${0%/*}" && pwd )
rootdir=$( cd "$bindir" && pwd )
gen_ver=$( awk '/k8s.io\/code-generator/ { print $2 }' "$rootdir/go.mod" )
codegen_pkg=${GOPATH}/pkg/mod/k8s.io/code-generator@${gen_ver}

chmod +x "${codegen_pkg}/generate-groups.sh"

GO111MODULE='on' "${codegen_pkg}/generate-groups.sh" \
  'deepcopy,client,informer,lister' \
  "github.com/kleimkuhler/go-generate-test/examples/crd" \
  "github.com/kleimkuhler/go-generate-test/examples/crd/apis" \
  "example:v1 example2:v1" \
  -v 10
  --go-header-file "${codegen_pkg}"/hack/boilerplate.go.txt

cp -R "${GOPATH}/src/github.com/kleimkuhler/go-generate-test/examples/crd" 'examples/'
