# Github Actions workflows

This project uses GitHub Actions workflows to automate everything; building,
testing, deploying, managing labels, ...

## Reusable workflows

> To reduce the amount of code duplication, we use reusable workflows that are
> prefixed with `_.` and are located in the `.github/workflows` directory.

### `_.helm.lint.yaml`

Lint the given Helm chart.

<details>
<summary> More info </summary>

#### Workflow usage

```yaml
---
steps:
  lint:
    uses: ./.github/workflows/_.helm.lint.yaml
    with:
      chart: # Path to the Helm chart to lint.
```

</details>

### `_.helm.list-changed.yaml`

Returns the list of Helm charts that have changed from base branch.

<details>
<summary> More info </summary>

#### Workflow usage

```yaml
---
steps:
  list-changed:
    uses: ./.github/workflows/_.helm.list-changed.yaml
```

#### Outputs

##### `charts`

JSON list of changed Helm charts.

</details>

### `_.helm.test.yaml`

Test the given Helm chart.

<details>
<summary> More info </summary>

#### Workflow usage

```yaml
---
steps:
  test:
    uses: ./.github/workflows/_.helm.test.yaml
    with:
      chart: # Path to the Helm chart to test.
```

</details>

### `_.images.build.yaml`

Builds container images based on the given Containerfile and a list of platforms
to build for.

<details>
<summary> More info </summary>

#### Workflow usage

```yaml
---
steps:
  build:
    permissions:
      contents: read # required to access to the Containerfile.
      id-token: write # required to sign the image.
      packages: write # required to push the image to the registry.
    uses: ./.github/workflows/_.images.build.yaml
    with:
      containerfile: # Path to the Containerfile to build.
      platforms: # List of platforms to build for (coma separated list of `os/arch`).
      dry-run: # If set to `true`, the workflow will build all images, but will
      # not push them to the registry. Instead, they will be saved as
      # artifacts.
```

#### Outputs

##### `artifacts`

JSON containing the list of generated artifacts.

```json
[
  {
    "artifact": "<artifact-reference>",
    "digest": "<image-digest>",
    "name": "<image-name>",
    "name-slug": "<image-name-slug>",
    "platform": {
      "arch": "<arch>",
      "os": "<os>"
    },
    "version": "<image-version>"
  }
]
```

> **NOTE**: The `artifact` field depends on the `dry-run` input. If `dry-run` is
> set to `true`, the `artifact` field will contain the path to the artifact. Otherwise,
> it will contain the path to the image in the registry.

</details>

### `_.images.lint.yaml`

Check syntax and vulnerability of the given Containerfile.

<details>
<summary> More info </summary>

#### Workflow usage

```yaml
---
steps:
  lint:
    uses: ./.github/workflows/_.images.lint.yaml
    with:
      containerfile: # Path to the Containerfile to lint.
```

</details>

### `_.images.list-changed.yaml`

Returns the list of container images that have changed from base branch.

<details>
<summary> More info </summary>

#### Workflow usage

```yaml
---
steps:
  list-changed:
    uses: ./.github/workflows/_.images.list-changed.yaml
```

#### Outputs

##### `containerfiles`

JSON list of changed containerfiles.

</details>

### `_.images.supply-chain.for-artifacts.yaml`

Adds supply chain metadata to the given artifacts.

**NOTE**: This workflow requires the artifacts available on the workflow. If
you want to use this workflow for artifacts pushed to the registry, you need to
use the [`_.images.supply-chain.for-registry.yaml`]() workflow.

<details>
<summary> More info </summary>

#### Workflow usage

```yaml
---
steps:
  supply-chain:
    uses: ./.github/workflows/_.images.supply-chain.for-artifacts.yaml
    with:
      artifact-ref: # Github artifact reference to add supply chain metadata to
      name: # String used to name the metadata artifact that will be generated
```

</details>

### `_.images.supply-chain.for-registry.yaml`

Adds supply chain attestation to the given image.

<details>
<summary> More info </summary>

#### Workflow usage

```yaml
---
steps:
  supply-chain:
    uses: ./.github/workflows/_.images.supply-chain.for-artifacts.yaml
    with:
      image-ref: # Image reference to add supply chain metadata to
```

</details>


