kubernetes_version := "v1.26.1"
tools := "just --justfile " + `git rev-parse --show-toplevel` / "tools/dsl2jsonschema/.justfile"

[private]
default:
    @just --list

# import Kubernetes schema based on OpenAPI specs
[no-exit-message]
import_kubernetes_schema KUBERNETES_VERSION=kubernetes_version:
  [ -d kubernetes/{{ KUBERNETES_VERSION }} ] || ( \
    openapi2jsonschema --kubernetes --output kubernetes/{{ KUBERNETES_VERSION }} \
      https://raw.githubusercontent.com/kubernetes/kubernetes/{{ KUBERNETES_VERSION }}/api/openapi-spec/swagger.json && \
    find kubernetes/ -type f ! -name "_definitions.json" ! -name "all.json" -delete \
  )

# build common schema definitions from the YAML file
[no-exit-message]
build_helm-values_schema: import_kubernetes_schema
  {{ tools }} --working-directory {{ justfile_directory() }} dsl2jsonschema helm-values/_definitions.yaml > helm-values/_definitions.json
