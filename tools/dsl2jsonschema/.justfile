kubernetes_version := "v1.26.1"


# ----------------------------------------------------------------------------------------------------------------------
# ----------- DSL2JSONSCHEMA -----------
dsl2jsonschema_bin := justfile_directory() / "dsl2jsonschema"

# compile dsl2jsonschema.go if not already built
[private]
[no-exit-message]
@compile_dsl2jsonschema:
  [ -f {{ dsl2jsonschema_bin }} ] || (cd {{ justfile_directory() / "cmd/dsl2jsonschema" }} && go build -o {{ dsl2jsonschema_bin }})

# build JSON schema based on the given DSL file.
[no-exit-message]
dsl2jsonschema PATH +OPTS="": compile_dsl2jsonschema
  {{ dsl2jsonschema_bin }} \
    --dsl.path {{ PATH }} \
    --dsl.external-reference "kubernetes=https://raw.githubusercontent.com/belug-apps/catalog/main/tools/jsonschema/kubernetes/{{ kubernetes_version }}/_definitions.json" \
    {{ OPTS }}} \
  | jq --sort-keys
