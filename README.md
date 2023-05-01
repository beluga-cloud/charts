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

</div>

---

## Description

This repository contains all Helm charts that I use personally and that I maintain.  
_Why maintaining these charts_ will you ask ? There is several reasons:

- Some charts made by the community are not what I expect of the usage of Helm.
    - For example, I don't want to have a sort of "generic engine" where every chart must use a common Helm library
      that could handle everything, and we just need to configure the `values.yaml` (
      like [TrueCharts](https://github.com/truecharts/charts) or [k8s-at-home](https://github.com/k8s-at-home)).  
      I can understand this choice with the number of charts that they maintain, but I found that really hard to edit
      and to create a new chart.
- I would use this repository as a sandbox to test new features or to try new things, like signing the Helm charts or
  adding some security checks.
- It's fun for me to spend time trying to do my best to make the best charts possible _(best... for me 😅)_.

## Usage

```shell
helm repo add beluga-cloud https://beluga-cloud.github.io/charts
helm install my-release beluga-cloud/<chart>
```

> All charts documentation are available in the `charts/<chart>/README.md` file or
> on [artifacthub.io](https://artifacthub.io/packages/search?page=1&ts_query_web=beluga-cloud).
