chart_name := file_name(justfile_directory())

default:
    @just --list

# build out the charts/ directory from the Chart.lock file and rebuild all depending files (values.yaml, README.md, ...)
[no-exit-message]
build_dependency: && build_validation
    helm dependency build

# rebuild the validation/manifests.yaml file that is used to see any changes after an update
[no-exit-message]
build_validation:
    helm template {{ chart_name }} . --create-namespace --namespace {{ chart_name }}-validation --output-dir validation/default
    find ci -name '*-values.yaml' -printf '%f\n' | cut -d'-' -f1 | xargs -I{} helm template {{ chart_name }} . --create-namespace --namespace {{ chart_name }}-validation --values ci/{}-values.yaml --output-dir validation/{}

# (CI only) install required resources to run `ct` properly
[private]
[no-exit-message]
ct_pre_install:
  {{ if env_var_or_default("CI", "false") =~ '[Tt]rue' { "" } else { "exit 1 # reason: must only be performed within a CI environment" } }}
  HELM_CONFIG_HOME=../../.ct helm repo update
  HELM_CONFIG_HOME=../../.ct helm upgrade --install cert-manager jetstack/cert-manager --create-namespace --namespace cert-manager-system --set installCRDs=true
