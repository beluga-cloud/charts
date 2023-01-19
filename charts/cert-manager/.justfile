chart_name := file_name(justfile_directory())

default:
    @just --list

# update the on-disk dependencies to mirror Chart.yaml and rebuild all depending files (values.yaml, README.md, ...) 
[no-exit-message]
update_dependencies: && update_readme update_values update_validation
    helm dependency update

# rebuild README.md using the one defined into the dependency chart
[no-exit-message]
update_readme:
    helm show readme charts/{{ chart_name }}-*.tgz > README.md

# rebuild values.yaml using the one defined into the dependency chart
[no-exit-message]
update_values:
    helm show values charts/{{ chart_name }}-*.tgz | yq eval-all --inplace --from-file values.overrides.yq values.yaml -

# rebuild the validation/manifests.yaml file that is used to see any changes after an update
[no-exit-message]
update_validation:
    helm template cert-manager . > validation/manifests.yaml
