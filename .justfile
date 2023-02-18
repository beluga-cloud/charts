container_registry := "ghcr.io"

exec := "just _xtrace"

[private]
default:
    @just --list

# install and test the current application into a local cluster
[no-exit-message]
e2e-run: e2e-setup e2e-prepare && e2e-teardown
  ct install --all --target-branch main --upgrade --helm-extra-args '--timeout 120s' --helm-extra-set-args '--set "global.imageRegistry={{ container_registry }}"' --debug

# prepare the local environment to run e2e tests locally
[private]
[no-exit-message]
e2e-setup:
  #!/usr/bin/env bash
  if ! (kind get clusters 2> /dev/null | grep "^belug-apps$" &> /dev/null); then
    {{exec}} kind create cluster --name belug-apps
  fi

# install all required resources to install and run the application properly
[private]
[no-exit-message]
e2e-prepare CLUSTER_NAME="belug-apps":
  #!/usr/bin/env bash
  for chart in charts/*; do
    {{exec}} just --justfile ${chart}/.justfile --working-directory ${chart} e2e-prepare {{ CLUSTER_NAME }}
  done

# remove the local environment to run e2e tests locally
[private]
[no-exit-message]
@e2e-teardown:
  {{exec}} kind delete cluster --name belug-apps

# generate the UID to use for a specific application
[no-exit-message]
@tools-chart-uid APP:
  echo "UID to use for {{ APP }}: 64$(echo {{ APP }} | sha1hmac | tr --delete '[:alpha:][:space:]-' | head --bytes=3)"

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
