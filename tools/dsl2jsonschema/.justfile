# How to use this justfile externally:
#   1. Add the following lines to your Justfile:
#     jsonschemalib := `git rev-parse --show-toplevel` / "tools/dsl2jsonschema/.justfile"
#     jsonschema := "just --justfile " + jsonschemalib
#   2. Use it by calling '{{ jsonschema }}' following by the action you want to use
#     {{ jsonschema }} dsl2jsonschema --dsl.path ./path/to/dsl/file
#
# ------------------------------------------------------------------------------
dsl2jsonschema_bin := justfile_directory() / "dsl2jsonschema"

# compile dsl2jsonschema.go if not already built
[private]
@compile_dsl2jsonschema:
  [ -f {{ dsl2jsonschema_bin }} ] || (cd "cmd/dsl2jsonschema" }} && go build -o {{ dsl2jsonschema_bin }})

# build JSON schema based on the given DSL file.
[no-cd]
dsl2jsonschema PATH +OPTS="": compile_dsl2jsonschema
  {{ dsl2jsonschema_bin }} \
    --dsl.path {{ PATH }} \
    {{ OPTS }} \
  | jq --sort-keys


normalize_bin := justfile_directory() / "normalize"

# compile normalize.go if not already built
[private]
@compile_normalize:
  [ -f {{ normalize_bin }} ] || (cd {{ "cmd/normalize" }} && go build -o {{ normalize_bin }})

# normalize JSON schema provided from stdin.
[no-cd]
normalize: compile_normalize
  {{ normalize_bin }} | jq --sort-keys
