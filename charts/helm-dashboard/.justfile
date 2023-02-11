chart_name := file_name(justfile_directory())
container_registry := "ghcr.io"

exec := "just _xtrace"

[private]
default:
    @just --list

# build out all "runtime" resources related to the current application (images, charts)
[no-exit-message]
build: build-images build-chart

# build out all "external" resources related to the current application (charts, README, ...)
[no-exit-message]
build-external: build-chart build-validation-files build-readme

# build one or multiple images (use relative path from current directory)
[no-exit-message]
build-images +IMAGES="all":
  #!/usr/bin/env bash
  for image in {{ if IMAGES == "all" { `echo images/*` } else { IMAGES } }}; do
    image_name="{{ container_registry }}/belug-apps/{{ chart_name }}/$(basename "${image}")"
    image_version="$(grep appVersion Chart.yaml | awk '{print $2}')"
    {{exec}} docker build --quiet "${image}" --tag "${image_name}:${image_version}"
  done

# build out the charts/ directory from the Chart.lock file
[no-exit-message]
@build-chart:
  {{exec}} helm dependency build

# generates all resources managed by this chart application to quickly see any changes
[no-exit-message]
@build-validation-files:
  {{exec}} rm --recursive validation/compiled
  {{exec}} helm template {{ chart_name }} . --create-namespace --namespace {{ chart_name }}-validation --output-dir validation/compiled/default
  for value in `find validation/values -name '*-values.yaml' -printf '%f\n' | cut -d'-' -f1`; do \
    {{exec}} helm template {{ chart_name }} . --create-namespace --namespace {{ chart_name }}-validation --values validation/values/${value}-values.yaml --output-dir validation/compiled/${value}; \
  done

# generates markdown documentation from requirements and values files
[no-exit-message]
@build-readme:
  {{exec}} helm-docs --badge-style flat

# lint all "runtime" resources related to the current application (images, charts)
[no-exit-message]
lint: lint-images lint-chart

# lint one or multiple images (use relative path from current directory)
[no-exit-message]
lint-images +IMAGES="all":
  #!/usr/bin/env bash
  for image in {{ if IMAGES == "all" { `echo images/*` } else { IMAGES } }}; do
    {{exec}} hadolint "${image}/Dockerfile" && echo "No issue found"
  done

# runs a series of tests to verify that the chart is well-formed
[no-exit-message]
@lint-chart:
  {{exec}} ct lint --charts "${PWD}"

# install and test the current application into a local cluster
[no-exit-message]
e2e-run: e2e-setup e2e-prepare && e2e-teardown
  ct install --charts ${PWD} --target-branch main --upgrade --helm-extra-args '--timeout 120s' --helm-extra-set-args '--set "global.imageRegistry={{ container_registry }}"' --debug

# prepare the local environment to run e2e tests locally
[private]
[no-exit-message]
e2e-setup: build-images
  #!/usr/bin/env bash
  if ! (kind get clusters 2> /dev/null | grep "^{{ chart_name }}$" &> /dev/null); then
    {{exec}} kind create cluster --name {{ chart_name }}
  fi

# install all required resources to install and run the application properly
[private]
[no-exit-message]
e2e-prepare CLUSTER_NAME=chart_name:
  #!/usr/bin/env bash
  for image in images/*; do
    image_name="{{ container_registry }}/belug-apps/{{ chart_name }}/$(basename "${image}")"
    image_version="$(grep appVersion Chart.yaml | awk '{print $2}')"
    {{exec}} kind load docker-image --name {{ CLUSTER_NAME }} "${image_name}:${image_version}"
  done

# remove the local environment to run e2e tests locally
[private]
[no-exit-message]
@e2e-teardown:
  {{exec}} kind delete cluster --name {{ chart_name }}

# (lib only) print a trace of simple commands then run it. If it runs inside
#            Github Actions, it will also group all outputs inside a block to
#            simplify CI logs.
[private]
[no-exit-message]
@_xtrace +CMD:
  {{ if env_var_or_default("GITHUB_ACTIONS", "false") =~ '[Tt]rue' { "just _xtrace_github_action " + CMD } else { "just _xtrace_default " + CMD } }}

[private]
[no-exit-message]
@_xtrace_default +CMD:
  @{{CMD}}

[private]
[no-exit-message]
@_xtrace_github_action +CMD:
  echo '::group::{{CMD}}'
  {{CMD}}
  echo '::endgroup::'
