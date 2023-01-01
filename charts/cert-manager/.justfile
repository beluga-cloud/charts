chart_name := file_name(justfile_directory())

default:
    @just --list

# update the on-disk dependencies to mirror Chart.yaml and rebuild all depending files (values.yaml, README.md, ...) 
[no-exit-message]
update_dependencies:
    helm dependency update
    helm show readme charts/{{ chart_name }}-*.tgz > README.md
    helm show values charts/{{ chart_name }}-*.tgz | yq eval-all --inplace --from-file values.overrides.yq values.yaml -

# update the validation/manifests.yaml file that is used to see any changes after an update
[no-exit-message]
validate:
    helm template cert-manager . --namespace cert-manager --create-namespace > validation/manifests.yaml
