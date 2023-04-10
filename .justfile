# load all the just libraries
justlib := `git rev-parse --show-toplevel` / "tools/justlib"
develop := "just --justfile " + justlib / "develop.justlib"
e2e := "just --justfile " + justlib / "e2e.justlib"
helm := "just --justfile " + justlib / "helm.justlib"
image := "just --justfile " + justlib / "image.justlib"
renovate := "just --justfile " + justlib / "renovate.justlib"
security := "just --justfile " + justlib / "security.justlib"
tools := "just --justfile " + justlib / "tools.justlib"

# shortcut to execute some commands in bash verbosely and compatible with Github Actions
exec := tools + " xtrace"

container_registry := "ghcr.io"

[private]
default:
    @just --list


# install and test the current application into a local cluster
e2e-run: e2e-setup e2e-prepare && e2e-teardown
  {{ e2e }} run_all "e2e-belug-apps"

# prepare the local environment to run e2e tests locally
[private]
e2e-setup:
  {{ e2e }} setup "e2e-belug-apps"

# install all required resources to install and run the application properly
[private]
e2e-prepare:
  #!/usr/bin/env bash
  set -euo pipefail

  for chart in charts/*; do
    {{ exec }} just --justfile "${chart}/.justfile" e2e-prepare "e2e-belug-apps"
  done

# remove the local environment to run e2e tests locally
[private]
@e2e-teardown:
  {{ e2e }} teardown "e2e-belug-apps"


# bootstrap a new charts interactively
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
@tools-chart-uid APP:
  echo "UID to use for {{ APP }}: 64$(echo {{ APP }} | sha1hmac | tr --delete '[:alpha:][:space:]-' | head --bytes=3)"
