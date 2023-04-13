<!-- markdownlint-disable MD033 -->
<h1 align="center">
  <a href="https://github.com/belug-apps">
    <img src="https://github.com/belug-apps/.github/raw/main/assets/logo_400px.png" alt="Logo" width="150" height="150">
  </a>
</h1>

<h4 align="center">Belug-Apps - Self-hosted application catalog</h4>

<div align="center">
  <br/>

[
![License](https://img.shields.io/github/license/belug-apps/belug-apps?logo=git&logoColor=white&logoWidth=20)
](LICENSE)

</div>

---

# Application list

This document lists all the applications managed by this project as well as those that will not be voluntarily managed.

## Managed applications

-[X] [`actual`](https://github.com/actualbudget/actual) - [/charts/actual](https://github.com/belug-apps/catalog/tree/main/charts/actual)
    - Actual is a local-first personal finance tool. It is 100% free and open-source, written in NodeJS, it has a
      synchronization element so that all your changes can move between devices without any heavy lifting.
-[X] [`cert-manager-issuers`](https://cert-manager.io/) - [/charts/cert-manager-issuers](https://github.com/belug-apps/catalog/tree/main/charts/cert-manager-issuers)
    - This chart is used to deploy the `ClusterIssuer` and `Issuer` resources used by the `cert-manager` to generate
      certificates.
-[X] [`help-dashboard`](https://github.com/komodorio/helm-dashboard) - [/charts/help-dashboard](https://github.com/belug-apps/catalog/tree/main/charts/help-dashboard)
    - Helm Dashboard is an open-source project which offers a UI-driven way to view the installed Helm charts, see their
      revision history and corresponding k8s resources.
-[X] [`jellyfin`](https://jellyfin.org/) - [/charts/jellyfin](https://github.com/belug-apps/catalog/tree/main/charts/jellyfin)
    - Jellyfin is a free software media system that puts you in control of managing and streaming your media.

## Unmanaged applications

-[X] [`cert-manager`](https://cert-manager.io/)
    - `jetstack` follows a good guideline for handling the `cert-manager` deployment in a more secure and reliable way
      than I can do.  
      I recommend you to use their charts: https://cert-manager.io/docs/installation/helm/#installing-with-helm
      ```shell
      helm repo add jetstack https://charts.jetstack.io
      helm install cert-manager jetstack/cert-manager ...
      ```
