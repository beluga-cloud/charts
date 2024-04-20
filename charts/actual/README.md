<!-- markdownlint-disable MD033 -->

<h1 align="center">
  <a href="https://actualbudget.com/">
    <img src="https://github.com/actualbudget/docs/raw/master/static/img/actual.png" alt="Logo" style="max-height: 150px">
  </a>
</h1>

<h4 align="center">Actual - Enjoy managing your finances</h4>

<div align="center">
  <br/>

  [
    ![License](https://img.shields.io/github/license/beluga-cloud/charts?logo=git&logoColor=white&logoWidth=20)
  ](LICENSE)
  <br/>
  ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat)
  ![Version: 2.1.0](https://img.shields.io/badge/Version-2.1.0-informational?style=flat)
  ![AppVersion: 24.4.0](https://img.shields.io/badge/AppVersion-24.4.0-informational?style=flat)

</div>

---

## [Actual](https://actualbudget.com/)

> _Disclaimer: This application has been developed by the [Actual](https://actualbudget.com/) community._

_Actual_ is a super fast privacy-focused app for managing your finances. You own your data, and we will sync it
across all devices with optional end-to-end encryption.

Some features of Actual:

- **Be involved in your financial decisions**: Automated finance tools are great, except when they aren’t. We provide
    you with tools that are quick to use, but ultimately you are in control. We help you learn, instead of dictating.
- **Meticulously designed for speed**: A beautifully designed interface is fine-tuned to get out of your way and make it
    as fast as possible to explore your finances.
- **Unabashedly local-first software**: Actual is a local app, plain and simple. Your data is synced in the background
    so all devices have access, but the app totally works regardless of your network connection. This also allows
    end-to-end encryption to keep your data private.
- **Powerful budgeting made simple**: Save hundreds of dollars a year (at least!) by tracking your spending. Based on
    tried and true methods, our budgeting system is based off of your real income instead of made up numbers. This makes
    you face your real spending, and clearly shows how much you are saving each month. We make this process as simple as
    possible. Learn more
- **The fastest way to manage transactions**: Breeze through your transactions and update them easily with a
    streamlined, minimal interface. Categorizing your transactions correctly is important and we’ve optimized this
    process. Manage split transactions and transfers all in the same editor.
- **Oh my, the reports**: Intuitive reports give you a quick way to learn about your finances. By default, we include
    net worth and cash flow reports, but soon you’ll be able to create any report that you like. You’ll even be able to
    download custom reports from others.

[> More about Actual](https://actualbudget.com/)

---

## TL;DR

```shell
helm repo add beluga-cloud https://beluga-cloud.github.io/charts
helm install my-release beluga-cloud/actual
```

## Introduction

This chart bootstraps a Actual deployment on a [Kubernetes](kubernetes.io) cluster using the [Helm](helm.sh) package manager.

## Prerequisites

- Kubernetes >=1.20
- Helm 3+

## Installing the Chart

To install the chart with the release name `my-release`:

```shell
helm repo add beluga-cloud https://beluga-cloud.github.io/charts
helm install my-release beluga-cloud/actual
```

These commands deploy actual on the Kubernetes cluster in the default configuration.
The Parameters section lists the parameters that can be configured during installation.

> **Tip:** List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```shell
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Key | Description | Default |
|-----|-------------|---------|
| `global.commonLabels` |  Labels to apply to all resources. | `{}` |
| `global.debug` |  Enable global debug mode | `false` |
| `global.imagePullSecrets` |  Reference to one or more secrets to be used when pulling images    ([kubernetes.io/docs](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/)) | `[]` |
| `global.imageRegistry` |  Global Docker image registry | `""` |

### Common parameters

| Key | Description | Default |
|-----|-------------|---------|
| `fullnameOverride` | String to fully override `common.names.fullname` template | `""` |
| `nameOverride` | String to partially override `common.names.fullname` template (will maintain the release name) | `""` |

### Actual parameters

| Key | Description | Default |
|-----|-------------|---------|
| `images.actualserver.digest` | actualserver image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""` |
| `images.actualserver.pullPolicy` | actualserver image pull policy | `"IfNotPresent"` |
| `images.actualserver.registry` | actualserver image registry (optional) | `""` |
| `images.actualserver.repository` | actualserver image repository | `"ghcr.io/beluga-cloud/actual/actualserver"` |
| `images.actualserver.tag` | actualserver image tag (immutable tags are recommended) | `""` |

### Security parameters

| Key | Description | Default |
|-----|-------------|---------|
| `containerSecurityContext` | Security context for the actualserver container    ([kubernetes.io/docs](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)) | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsGroup":64087,"runAsNonRoot":true,"runAsUser":64087}` |
| `podSecurityContext` | Security context for the pod ([kubernetes.io/docs](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)) | `{"runAsGroup":64087,"runAsNonRoot":true,"runAsUser":64087,"seccompProfile":{"type":"RuntimeDefault"}}` |

### Deployment/Statefulset parameters

| Key | Description | Default |
|-----|-------------|---------|
| `affinity` | Affinity for pod assignment ([kubernetes.io/docs](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.26/#affinity-v1-core)) | `{}` |
| `nodeSelector` | Node labels for pod assignment | `{"kubernetes.io/os":"linux"}` |
| `podAnnotations` | Additional annotations to apply to the pod. | `{}` |
| `podLabels` | Additional labels to be added to pods. | `{}` |
| `resources.actualserver.limits` | The resources limits for the container | `{"cpu":"100m","memory":"100Mi"}` |
| `resources.actualserver.requests` | The requested resources for the container | `{"cpu":"10m","memory":"100Mi"}` |
| `strategy` | Set up update strategy for actualserver installation. Set to `Recreate` if you use persistent volume    that cannot be mounted by more than one pods to make sure the pods is destroyed first.    ([kubernetes.io/docs](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy)) | `{}` |
| `tolerations` | Tolerations for pod assignment ([kubernetes.io/docs](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.26/#toleration-v1-core)) | `[]` |
| `topologySpreadConstraints` | Topology Spread Constraints for pod assignment    ([kubernetes.io/docs](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.24/#topologyspreadconstraint-v1-core)) | `[]` |

### Network parameters

| Key | Description | Default |
|-----|-------------|---------|
| `ingress.annotations` | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}` |
| `ingress.enabled` | Enable ingress resource | `false` |
| `ingress.extraHosts` | The list of additional hostnames to be covered with this ingress record. | `[]` |
| `ingress.extraPaths` | Any additional paths that may need to be added to the ingress under the main host | `[]` |
| `ingress.extraRules` | Additional rules to be covered with this ingress record | `[]` |
| `ingress.extraTls` | The tls configuration for additional hostnames to be covered with this ingress record. | `[]` |
| `ingress.hostname` | Default host for the ingress resource | `"actualserver.local"` |
| `ingress.ingressClassName` | IngressClass that will be used to implement the Ingress | `""` |
| `ingress.path` | The Path to actualserver. You may need to set this to '/*' in order to use this with ALB ingress controllers. | `"/"` |
| `ingress.pathType` | Ingress path type | `"ImplementationSpecific"` |
| `ingress.tls` | Enable TLS configuration for the hostname defined at apiIngress.hostname parameter | `true` |
| `networkPolicy.allowAllOutbound` | Whether to allow all outbound traffic by default. | `true` |
| `networkPolicy.allowExternal` | Don't require client label for connections | `true` |
| `networkPolicy.egress` | Sets egress policy block. See NetworkPolicies documentation ([kubernetes.io/docs](https://kubernetes.io/docs/concepts/services-networking/network-policies/).) | `[]` |
| `networkPolicy.enabled` | Enable the default NetworkPolicy policy | `false` |
| `networkPolicy.ingress` | Sets ingress policy block. See NetworkPolicies documentation ([kubernetes.io/docs](https://kubernetes.io/docs/concepts/services-networking/network-policies/).) | `[]` |
| `service.annotations` | Additional annotations for the Service | `{}` |
| `service.clusterIP` | Service Cluster IP | `""` |
| `service.externalTrafficPolicy` | Enable client source IP preservation | `"Cluster"` |
| `service.loadBalancerSourceRanges` | Addresses that are allowed when service is `LoadBalancer` | `[]` |
| `service.type` | Service type | `"ClusterIP"` |
| `service.web.nodePort` | Specify the nodePort value for the `LoadBalancer` and `NodePort` service types | `0` |
| `service.web.port` | `web` service port | `5006` |

### Persistence parameters

| Key | Description | Default |
|-----|-------------|---------|
| `persistence.data.enabled` | Enable configuration persistence using `PVC`. If false, use emptyDir | `true` |
| `persistence.data.volumeClaimSpec` | Claims that pods are allowed to reference (see    [kubernetes.io/docs](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.26/#persistentvolumeclaim-v1-core)    for structural reference) | `{"accessModes":["ReadWriteOnce"],"resources":{"requests":{"storage":"2Gi"}}}` |

### RBAC parameters

| Key | Description | Default |
|-----|-------------|---------|

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```shell
helm install my-release --set fullnameOverride=my-actual beluga-cloud/actual
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```shell
helm install my-release -f values.yaml my-repo/actual
```

> **Tip:** You can use the default values.yaml

## License

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with
the License. You may obtain a copy of the License at

```
http://www.apache.org/licenses/LICENSE-2.0
```

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
language governing permissions and limitations under the License.

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.3](https://github.com/norwoodj/helm-docs/releases/v1.11.3)
