

<!-- markdownlint-disable MD033 -->

<h1 align="center">
  <a href="https://github.com/komodorio/helm-dashboard">
    <img src="https://raw.githubusercontent.com/komodorio/helm-dashboard/main/pkg/dashboard/static/logo.svg" alt="Logo" style="max-height: 150px">
  </a>
</h1>

<h4 align="center">Helm Dashboard - A GUI Dashboard for Helm by Komodor</h4>

<div align="center">
  <br/>

  [
    ![License](https://img.shields.io/github/license/beluga-cloud/charts?logo=git&logoColor=white&logoWidth=20)
  ](LICENSE)
  <br/>
  ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat)
  ![Version: 2.3.1](https://img.shields.io/badge/Version-2.3.1-informational?style=flat)
  ![AppVersion: 1.3.1](https://img.shields.io/badge/AppVersion-1.3.1-informational?style=flat)

</div>

---

## [Helm Dashboard](https://github.com/komodorio/helm-dashboard)

> _Disclaimer: This application has been developed by the [Komodor](https://komodor.com/) team._

_Helm Dashboard_ is an **open-source project** which offers a UI-driven way to view the installed Helm charts, see their revision history and
corresponding k8s resources. Also, you can perform simple actions like roll back to a revision or upgrade to newer
version.
This project is part of [Komodor's](https://komodor.com/?utm_campaign=Helm-Dash&utm_source=helm-dash-gh) vision of
helping Kubernetes users to navigate and troubleshoot their clusters, the project is **NOT** an offical project by the [helm team](https://helm.sh/).

Some of the key capabilities of the tool:

- See all installed charts and their revision history
- See manifest diff of the past revisions
- Browse k8s resources resulting from the chart
- Easy rollback or upgrade version with a clear and easy manifest diff
- Integration with popular problem scanners
- Easy switch between multiple clusters

[Overview of helm-dashboard](https://github.com/komodorio/helm-dashboard)

## TL;DR

```shell
helm repo add beluga-cloud https://beluga-cloud.github.io/charts
helm install my-release beluga-cloud/helm-dashboard
```

## Introduction

This chart bootstraps a Helm Dashboard deployment on a [Kubernetes](kubernetes.io) cluster using the [Helm](helm.sh) package manager.

## Prerequisites

- Kubernetes >=1.20
- Helm 3+

## Installing the Chart

To install the chart with the release name `my-release`:

```shell
helm repo add beluga-cloud https://beluga-cloud.github.io/charts
helm install my-release beluga-cloud/helm-dashboard
```

These commands deploy helm-dashboard on the Kubernetes cluster in the default configuration.
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
| `global.imagePullSecrets` |  Reference to one or more secrets to be used when pulling images    ([kubernetes.io/docs]([kubernetes.io/docs](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/))) | `[]` |
| `global.imageRegistry` |  Global Docker image registry | `""` |

### Common parameters

| Key | Description | Default |
|-----|-------------|---------|
| `fullnameOverride` | String to fully override `common.names.fullname` template | `""` |
| `nameOverride` | String to partially override `common.names.fullname` template (will maintain the release name) | `""` |

### Helm Dashboard parameters

| Key | Description | Default |
|-----|-------------|---------|
| `helmDashboard.repositories` | Default helm registries loaded with helm-dashboard | `[]` |
| `images.dashboard.digest` | helm-dashboard image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""` |
| `images.dashboard.pullPolicy` | helm-dashboard image pull policy | `"IfNotPresent"` |
| `images.dashboard.registry` | helm-dashboard image registry (optional) | `""` |
| `images.dashboard.repository` | helm-dashboard image repository | `"ghcr.io/beluga-cloud/helm-dashboard/dashboard"` |
| `images.dashboard.tag` | helm-dashboard image tag (immutable tags are recommended) | `""` |

### Security parameters

| Key | Description | Default |
|-----|-------------|---------|
| `containerSecurityContext` | Security context for the helm-dashboard container    ([kubernetes.io/docs]([kubernetes.io/docs](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/))) | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsGroup":65463,"runAsNonRoot":true,"runAsUser":65463}` |
| `podSecurityContext` | Security context for the pod ([kubernetes.io/docs]([kubernetes.io/docs](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/))) | `{"fsGroup":65463,"runAsGroup":65463,"runAsNonRoot":true,"runAsUser":65463,"seccompProfile":{"type":"RuntimeDefault"}}` |

### Deployment/Statefulset parameters

| Key | Description | Default |
|-----|-------------|---------|
| `affinity` | Affinity for pod assignment ([kubernetes.io/docs]([kubernetes.io/docs](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.26/#affinity-v1-core))) | `{}` |
| `nodeSelector` | Node labels for pod assignment | `{"kubernetes.io/os":"linux"}` |
| `podAnnotations` | Additional annotations to apply to the pod. | `{}` |
| `podLabels` | Additional labels to be added to pods | `{}` |
| `replicaCount` | Number of pods per zone. (_**It's not recommended to add more instance of helm-dashboard**_) | `1` |
| `resources.limits` | The resources limits for the container | `{"cpu":1,"memory":"1Gi"}` |
| `resources.requests` | The requested resources for the container | `{"cpu":"200m","memory":"256Mi"}` |
| `strategy` | Set up update strategy for helm-dashboard installation. Set to `Recreate` if you use persistent volume    that cannot be mounted by more than one pods to make sure the pods is destroyed first.    ([kubernetes.io/docs]([kubernetes.io/docs](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy))) | `{}` |
| `tolerations` | Tolerations for pod assignment ([kubernetes.io/docs]([kubernetes.io/docs](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.26/#toleration-v1-core))) | `[]` |
| `topologySpreadConstraints` | Topology Spread Constraints for pod assignment    ([kubernetes.io/docs]([kubernetes.io/docs](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.24/#topologyspreadconstraint-v1-core))) | `[]` |

### Network parameters

| Key | Description | Default |
|-----|-------------|---------|
| `ingress.annotations` | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}` |
| `ingress.enabled` | Enable ingress resource | `false` |
| `ingress.extraHosts` | The list of additional hostnames to be covered with this ingress record. | `[]` |
| `ingress.extraPaths` | Any additional paths that may need to be added to the ingress under the main host | `[]` |
| `ingress.extraRules` | Additional rules to be covered with this ingress record | `[]` |
| `ingress.extraTls` | The tls configuration for additional hostnames to be covered with this ingress record. | `[]` |
| `ingress.hostname` | Default host for the ingress resource | `"helm-dashboard.local"` |
| `ingress.ingressClassName` | IngressClass that will be used to implement the Ingress | `""` |
| `ingress.path` | The Path to helm-dashboard. You may need to set this to '/*' in order to use this with ALB ingress controllers. | `"/"` |
| `ingress.pathType` | Ingress path type | `"ImplementationSpecific"` |
| `ingress.tls` | Enable TLS configuration for the hostname defined at apiIngress.hostname parameter | `false` |
| `networkPolicy.allowAllOutbound` | Whether to allow all outbound traffic by default. | `true` |
| `networkPolicy.allowExternal` | Don't require client label for connections | `true` |
| `networkPolicy.egress` | Sets egress policy block. See [NetworkPolicy]([kubernetes.io/docs](https://kubernetes.io/docs/concepts/services-networking/network-policies/)) documentation. | `[]` |
| `networkPolicy.enabled` | Enable the default NetworkPolicy policy | `false` |
| `networkPolicy.ingress` | Sets ingress policy block. See [NetworkPolicy]([kubernetes.io/docs](https://kubernetes.io/docs/concepts/services-networking/network-policies/)) documentation. | `[]` |
| `service.annotations` | Additional annotations for the Service | `{}` |
| `service.clusterIP` | Service Cluster IP | `""` |
| `service.externalTrafficPolicy` | Enable client source IP preservation | `"Cluster"` |
| `service.loadBalancerIP` | LoadBalancer IP if service type is `LoadBalancer` (optional, cloud specific) | `""` |
| `service.loadBalancerSourceRanges` | Addresses that are allowed when service is `LoadBalancer` | `[]` |
| `service.type` | Service type | `"ClusterIP"` |
| `service.web.nodePort` | Specify the nodePort value for the `LoadBalancer` and `NodePort` service types | `0` |
| `service.web.port` | `web` service port | `8080` |

### Persistence parameters

| Key | Description | Default |
|-----|-------------|---------|
| `persistence.data.enabled` | Enable data persistence using `PVC`. If false, use emptyDir | `true` |
| `persistence.data.volumeClaimSpec` | Claims that pods are allowed to reference (see    [kubernetes.io/docs](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.26/#persistentvolumeclaim-v1-core)    for structural reference) | `{"accessModes":["ReadWriteOnce"],"resources":{"requests":{"storage":"100M"}}}` |

### RBAC parameters

| Key | Description | Default |
|-----|-------------|---------|
| `rbac.allowWriteActions` | Allow helm-dashboard to create/edit/delete Kubernetes resources | `false` |
| `rbac.create` | Specifies whether RBAC resources should be created | `true` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```shell
helm install my-release --set fullnameOverride=my-helm-dashboard beluga-cloud/helm-dashboard
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```shell
helm install my-release -f values.yaml my-repo/helm-dashboard
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
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
