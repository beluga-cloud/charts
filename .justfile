default:
    @just --list

# (CI only) install required resources to run `ct` properly
[private]
[no-exit-message]
ct_pre_install:
  {{ if env_var_or_default("CI", "false") =~ '[Tt]rue' { "" } else { "exit 1 # reason: must only be performed within a CI environment" } }}
  pushd charts/cert-manager-issuers && just ct_pre_install && popd
