kubernetes_version := "v1.26.1"

[private]
default:
    @just --list

# import Kubernetes schema based on OpenAPI specs
[no-exit-message]
import_kubernetes_schema REVISION=kubernetes_version:
  rm --force --recursive kubernetes/{{ REVISION }}
  openapi2jsonschema --kubernetes --output kubernetes/{{ REVISION }} \
    https://raw.githubusercontent.com/kubernetes/kubernetes/v1.26.1/api/openapi-spec/swagger.json
  find kubernetes/ -type f ! -name "_definitions.json" ! -name "all.json" -delete

# build common schema definitions from the YAML file
[no-exit-message]
build_common_schema:
  yq common/_definitions.yaml --output-format json | jq --sort-keys > common/_definitions.json
