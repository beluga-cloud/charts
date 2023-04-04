container_registry := "ghcr.io"

exec := "just _xtrace"

[private]
default:
    @just --list

# ----------------------------------------------------------------------------------------------------------------------
# --------- E2E TESTS ---------

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


# ----------------------------------------------------------------------------------------------------------------------
# ------ TOOLS & LIBRARY ------

# bootstrap a new charts interactively
[no-exit-message]
bootstrap APP:
  #!/usr/bin/env bash

  ux_name="$(gum style --foreground 3 '`{{ APP }}`')"
  ux_dot_nok="$(gum style --bold '○')"
  ux_dot_ok="$(gum style --bold '•')"

  gum style \
    --foreground 4 --border-foreground 4 --border rounded \
    --align center --margin 2 --padding 2 \
    "Ready to bootstrap ${ux_name}?" "Lets go!"

  # Ask for project information
  for (( ; ; ))
  do
    # 1/4 - Project URL
    project_url=$(
      gum input \
        --prompt.margin "0 2" \
        --placeholder "{{ APP }} home page url" \
        --header.margin "0 2" \
        --header "${ux_dot_nok} $(gum style --italic --faint "First"), tell me what is the $(gum style --bold --underline "url") of the ${ux_name} $(gum style --bold --underline "home page")."
    )
    gum style --margin "0 2" "${ux_dot_ok} $(gum style --italic --faint "URL: ")${project_url}"

    # 2/4 - Project Description
    project_description=$(
      gum input \
        --prompt.margin "0 2" \
        --placeholder "{{ APP }} description" \
        --header.margin "0 2" \
        --header "${ux_dot_nok} $(gum style --italic --faint "Nice... Now"), $(gum style --bold --underline "describe") in a few words what ${ux_name} does."
    )
    gum style --margin "0 2" "${ux_dot_ok} $(gum style --italic --faint "Description: ")${project_description}"

    # 3/4 - Project Version
    project_version=$(
      gum input \
        --prompt.margin "0 2" \
        --placeholder "{{ APP }} version" \
        --header.margin "0 2" \
        --header "${ux_dot_nok} $(gum style --italic --faint "Great"), and what is the $(gum style --bold --underline "current version") of ${ux_name}?"
    )
    gum style --margin "0 2" "${ux_dot_ok} $(gum style --italic --faint "Version: ")${project_version}"

    # 4/4 - Project Icon
    project_icon_url=$(
      gum input \
        --prompt.margin "0 2" \
        --placeholder "{{ APP }} icon url" \
        --header.margin "0 2" \
        --header "${ux_dot_nok} $(gum style --italic --faint "We are almost there"). Give me the $(gum style --bold --underline "url") of the ${ux_name} $(gum style --bold --underline "icon")."
    )
    gum style --margin "0 2" "${ux_dot_ok} $(gum style --italic --faint "Icon URL: ")${project_icon_url}"

    echo; gum confirm \
      --prompt.margin "0 2" --selected.background 4 \
      "Is everything correct?" && break
    gum style --margin "0 2" --foreground 5 "Okay, let's try again..."
  done

  gum spin \
    --spinner.margin "0 0 0 2" --spinner.foreground 4 --spinner "points" \
    --title "Bootstrapping ${ux_name}..." \
    just bootstrap_app "{{ APP }}" "${project_description}" "${project_version}" "${project_url}" "${project_icon_url}"
  gum style --margin "0 2" "${ux_name} bootstrapped!"

  cd "charts/{{ APP }}" \
  && gum spin \
    --spinner.margin "0 0 0 2" --spinner.foreground 4 --spinner "points" \
    --title "Building ${ux_name}..." \
    just build-external
  gum style --margin "0 2" "${ux_name} built!"

  echo; gum confirm \
    --timeout 5s --default=false \
    --prompt.margin "0 2" --selected.background 4 \
    "Do you want to open the ${ux_name} $(gum style --italic "README.md")?" && glow --pager README.md

# bootstrap a new charts directly with all the required information
[private]
[no-exit-message]
bootstrap_app name description version url icon_url:
  cp -r docs/app_template "charts/{{ name }}"
  mv "charts/{{ name }}/images/image_template" "charts/{{ name }}/images/{{ name }}"
  ln -s "~develop/validation/values" "charts/{{ name }}/ci"
  find "charts/{{ name }}" -type f -exec sed -i "s/{{ "{{" }} name }}/{{ name }}/g" {} \;
  find "charts/{{ name }}" -type f -exec sed -i "s/{{ "{{" }} description }}/{{ description }}/g" {} \;
  find "charts/{{ name }}" -type f -exec sed -i "s/{{ "{{" }} version }}/{{ version }}/g" {} \;
  find "charts/{{ name }}" -type f -exec sed -i "s/{{ "{{" }} url }}/{{ url }}/g" {} \;
  find "charts/{{ name }}" -type f -exec sed -i "s/{{ "{{" }} icon_url }}/{{ icon_url }}/g" {} \;

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
