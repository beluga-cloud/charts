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

## Unmanaged applications
-[X] _(soon)_ [`cert-manager`](https://cert-manager.io/)
  - `jetstack` follows a good guideline for handling the `cert-manager` deployment in a more secure and reliable way
    than I can do. I recommend you to use their charts: https://cert-manager.io/docs/installation/helm/#installing-with-helm
    ```shell
    helm repo add jetstack https://charts.jetstack.io
    helm install cert-manager jetstack/cert-manager ...
    ```
