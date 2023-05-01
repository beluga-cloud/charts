<!-- markdownlint-disable MD033 -->
<h1 align="center">
  <a href="https://github.com/beluga-cloud">
    <img src="https://github.com/beluga-cloud/.github/raw/main/assets/logo_400px.png" alt="Logo" width="150" height="150">
  </a>
</h1>

<h4 align="center">:whale: Beluga Cloud - Personal Helm Charts repository</h4>

<div align="center">
  <br/>

[
![License](https://img.shields.io/github/license/beluga-cloud/charts?logo=git&logoColor=white&logoWidth=20)
](LICENSE)
[
![Pending dependencies](https://img.shields.io/github/issues-pr/beluga-cloud/charts/type:%20dependencies?label=dependencies&logo=renovatebot&logoWidth=20&style=flat)
](https://github.com/beluga-cloud/charts/pulls?q=is%3Apr+is%3Aopen+label%3A%22type%3A+dependencies%22)
<br/>
[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/beluga-cloud)](https://artifacthub.io/packages/search?repo=beluga-cloud)


</div>

---

## Description

This repository contains all Helm charts that I use personally and that I maintain.  
_Why maintaining these charts_ will you ask?
There are several reasons:

- Some charts made by the community are not what I expect of the usage of Helm.
    - For example, I don't want to have a sort of "generic engine" where every chart must use a common Helm library
      that could handle everything, and we just need to configure the `values.yaml` (
      like [TrueCharts](https://github.com/truecharts/charts) or [k8s-at-home](https://github.com/k8s-at-home)).  
      I can understand this choice with the number of charts that they maintain, but I found that really hard to edit,
      to audit and to create a new chart.
- I would use this repository as a sandbox to test new features or to try new things, like signing the Helm charts,
  adding some security checks or json-schema.
- I want to have a repository that I can trust, and that I can audit easily.
- I want to improve myself in write and exploiting Helm charts.
- Finally, it's fun for me to spend time trying to do my best to make the best charts possible _(best... for me 😅)_.

## Usage

```shell
helm repo add beluga-cloud https://beluga-cloud.github.io/charts
helm install my-release beluga-cloud/<chart>
```

> All charts documentation is available in the `charts/<chart>/README.md` file or
> on [artifacthub.io](https://artifacthub.io/packages/search?page=1&ts_query_web=beluga-cloud).

## List of planned and available charts

- [x] [`actual`](https://github.com/actualbudget/actual) - [/charts/actual](https://github.com/beluga-cloud/charts/tree/main/charts/actual)
    - Actual is a local-first personal finance tool.
      It is 100% free and open-source, written in NodeJS,
      it has a synchronization element so that all your changes can move between devices without any heavy lifting.
- [x] [`cert-manager-issuers`](https://cert-manager.io/) - [/charts/cert-manager-issuers](https://github.com/beluga-cloud/charts/tree/main/charts/cert-manager-issuers)
    - This chart is used to deploy the `ClusterIssuer` and `Issuer` resources used by the `cert-manager` to generate certificates.
- [x] [`help-dashboard`](https://github.com/komodorio/helm-dashboard) - [/charts/help-dashboard](https://github.com/beluga-cloud/charts/tree/main/charts/help-dashboard)
   - Helm Dashboard is an open-source project which offers a UI-driven way to view the installed Helm charts, see their revision history and corresponding k8s resources.
- [x] [`jellyfin`](https://jellyfin.org/) - [/charts/jellyfin](https://github.com/beluga-cloud/charts/tree/main/charts/jellyfin)
    - Jellyfin is a free software media system that puts you in control of managing and streaming your media.

## Contributing

Even if this repository is a personal repository, I am open to any suggestions, improvements or new ideas.
So, if you want to contribute to this repository:
- Start by reading the [Contributing guide](https://github.com/beluga-cloud/.github/blob/main/docs/CONTRIBUTING.md).
- Learn how to set up your environment with the [Development guide]() ... that I never wrote 😅.
- Feel free to open an issue or a pull request.

## Security

Beluga Cloud charts follow good practices of security, but 100% security cannot be assured.
Charts are provided "as is" without any warranty.
Use at your own risk.

For more information and to report security issues,
please refer to [our security documentation](https://github.com/beluga-cloud/.github/blob/main/docs/SECURITY.md).

### Signatures and attestations

In order to ensure the integrity of the charts, all charts are signed with a GPG key.
The public key is available at [https://raw.githubusercontent.com/beluga-cloud/charts/main/charts/beluga-cloud.asc](charts/beluga-cloud.asc).

For example, if you want to verify the integrity of the `beluga-cloud/jellyfin` chart during the installation:

```shell
curl --silent https://raw.githubusercontent.com/beluga-cloud/charts/main/charts/beluga-cloud.asc | gpg --import
helm repo add beluga-cloud https://beluga-cloud.github.io/charts
helm install jellyfin beluga-cloud/jellyfin --verify
```

Like Helm charts, all images are signed using [`cosign`](https://github.com/sigstore/cosign), 
and a SBOM and a vulnerability list are attached to each image as attestation.

```shell
# Verify the image signature (e.g. for the jellyfin image)
cosign verify --certificate-identity-regexp '^https://github.com/beluga-cloud/charts/.github/workflows/.+?.yaml@refs/heads/main$' --certificate-oidc-issuer 'https://token.actions.githubusercontent.com' ghcr.io/beluga-cloud/jellyfin/jellyfin:v10.8.10

# Fetch the SBOM and the vulnerability list of the image
cosign verify-attestation --certificate-identity-regexp '^https://github.com/beluga-cloud/charts/.github/workflows/.+?.yaml@refs/heads/main$' --certificate-oidc-issuer 'https://token.actions.githubusercontent.com' ghcr.io/beluga-cloud/jellyfin/jellyfin:v10.8.10-amd64-linux --type cyclonedx | jq '.payload | @base64d | fromjson'
cosign verify-attestation --certificate-identity-regexp '^https://github.com/beluga-cloud/charts/.github/workflows/.+?.yaml@refs/heads/main$' --certificate-oidc-issuer 'https://token.actions.githubusercontent.com' ghcr.io/beluga-cloud/jellyfin/jellyfin:v10.8.10-amd64-linux --type vuln | jq '.payload | @base64d | fromjson'
```

> _NOTE: the vulnerability attestations are updated and pushed each Sunday and Wednesday at 09:32 UTC._

### Vulnerability scanning

All images are scanned using [Trivy](https://github.com/aquasecurity/trivy)
and published on the [GitHub vulnerability dashboard](https://github.com/beluga-cloud/charts/security/code-scanning?query=is%3Aopen+branch%3Amain+severity%3Acritical%2Chigh%2Cmedium).

When possible, I will try to open an issue and/or a pull request to fix it.
However, I cannot fix all issues on dependencies myself,
so I will try to update the dependencies as soon as possible when a fix is published.

## License

This repository is distributed under the [Apache License 2.0](LICENSE).
