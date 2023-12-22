

<!-- markdownlint-disable MD033 -->

<h1 align="center">
  <a href="https://www.authelia.com/">
    <img src="https://www.authelia.com/images/authelia-title.png" alt="Logo" style="max-height: 150px">
  </a>
</h1>

<h4 align="center">Authelia - The Single Sign-On Multi-Factor portal for web apps</h4>

<div align="center">
  <br/>

  [
    ![License](https://img.shields.io/github/license/beluga-cloud/charts?logo=git&logoColor=white&logoWidth=20)
  ](LICENSE)
  <br/>
  ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat)
  ![Version: 0.0.0](https://img.shields.io/badge/Version-0.0.0-informational?style=flat)
  ![AppVersion: v4.38.0-beta3](https://img.shields.io/badge/AppVersion-v4.38.0--beta3-informational?style=flat)

</div>

---

## [Authelia](https://www.authelia.com/)

> _Disclaimer: This application has been developed by **[Authelia](www.authelia.com)**._

**Authelia** is an open-source authentication and authorization server providing two-factor authentication and single
sign-on (SSO) for your applications via a web portal. It acts as a companion for [reverse proxies](#proxy-support) by
allowing, denying, or redirecting requests.

Documentation is available at [https://www.authelia.com/](https://www.authelia.com/).

### Features summary

This is a list of the key features of Authelia:

* Several second factor methods:
  * **[Security Keys](https://www.authelia.com/overview/authentication/security-key/)** that support
    [FIDO2]&nbsp;[WebAuthn] with devices like a [YubiKey].
  * **[Time-based One-Time password](https://www.authelia.com/overview/authentication/one-time-password/)**
    with compatible authenticator applications.
  * **[Mobile Push Notifications](https://www.authelia.com/overview/authentication/push-notification/)**
    with [Duo](https://duo.com/).
* Password reset with identity verification using email confirmation.
* Access restriction after too many invalid authentication attempts.
* Fine-grained access control using rules which match criteria like subdomain, user, user group membership, request uri,
 request method, and network.
* Choice between one-factor and two-factor policies per-rule.
* Support of basic authentication for endpoints protected by the one-factor policy.
* Highly available using a remote database and Redis as a highly available KV store.
* Compatible with [Traefik](https://doc.traefik.io/traefik) out of the box using the
  [ForwardAuth](https://doc.traefik.io/traefik/middlewares/http/forwardauth/) middleware.
* Curated configuration from [LinuxServer](https://www.linuxserver.io/) via their
  [Swag](https://docs.linuxserver.io/general/swag) container as well as a
  [guide](https://blog.linuxserver.io/2020/08/26/setting-up-authelia/).
* Compatible with [Caddy] using the [forward_auth](https://caddyserver.com/docs/caddyfile/directives/forward_auth)
  directive.
* Kubernetes Support:
  * Compatible with several Kubernetes ingress controllers:
    * [ingress-nginx](https://www.authelia.com/integration/kubernetes/nginx-ingress/)
    * [Traefik Kubernetes CRD](https://www.authelia.com/integration/kubernetes/traefik-ingress/#ingressroute)
    * [Traefik Kubernetes Ingress](https://www.authelia.com/integration/kubernetes/traefik-ingress/#ingress)
    * [Istio](https://www.authelia.com/integration/kubernetes/istio/)
  * Beta support for installing via Helm using our [Charts](https://charts.authelia.com).
* Beta support for [OpenID Connect](https://www.authelia.com/roadmap/active/openid-connect/).

For more details take a look at the [Overview](https://www.authelia.com/overview/prologue/introduction/).

If you want to know more about the roadmap, follow [Roadmap](https://www.authelia.com/roadmap).

### Proxy support

Authelia works in combination with [nginx](https://www.authelia.com/integration/proxies/nginx/), [Traefik](https://www.authelia.com/integration/proxies/traefik/), [Caddy](https://www.authelia.com/integration/proxies/caddy/), [Skipper](https://www.authelia.com/integration/proxies/skipper/), [Envoy](https://www.authelia.com/integration/proxies/envoy/), or [HAProxy](https://www.authelia.com/integration/proxies/haproxy/).

<p align="center">
  <img src="https://www.authelia.com/images/logos/nginx.png" height="50"/>
  <img src="https://www.authelia.com/images/logos/traefik.png" height="50"/>
  <img src="https://www.authelia.com/images/logos/caddy.png" height="50"/>
  <img src="https://www.authelia.com/images/logos/envoy.png" height="50"/>
  <img src="https://www.authelia.com/images/logos/haproxy.png" height="50"/>
</p>

## TL;DR

```shell
helm repo add beluga-cloud https://beluga-cloud.github.io/charts
helm install my-release beluga-cloud/authelia
```

## Introduction

This chart bootstraps a Authelia deployment on a [Kubernetes](kubernetes.io) cluster using the [Helm](helm.sh) package manager.

## Prerequisites

- Kubernetes >=1.20
- Helm 3+

## Installing the Chart

To install the chart with the release name `my-release`:

```shell
helm repo add beluga-cloud https://beluga-cloud.github.io/charts
helm install my-release beluga-cloud/authelia
```

These commands deploy authelia on the Kubernetes cluster in the default configuration.
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

### Authelia parameters

| Key | Description | Default |
|-----|-------------|---------|
| `authelia.authentication_backend_file` | Configure the authentication backend file | `{"raw":{"users":{"alice":{"disabled":false,"displayname":"Alice Smith","email":"alice.smith@example.org","groups":["admins","dev"],"password":"$argon2id$v=19$m=65536,t=3,p=4$xAM+zWGTvdPOGaQiGTQypQ$LkRZAIped07dVIcNW0sNbnOnrcuxCd+3PBhpFC/Fmw8"}}},"secret":{"key":null,"name":null}}` |
| `authelia.authentication_backend_file.raw` | Configure the users database | `{"users":{"alice":{"disabled":false,"displayname":"Alice Smith","email":"alice.smith@example.org","groups":["admins","dev"],"password":"$argon2id$v=19$m=65536,t=3,p=4$xAM+zWGTvdPOGaQiGTQypQ$LkRZAIped07dVIcNW0sNbnOnrcuxCd+3PBhpFC/Fmw8"}}}` |
| `authelia.authentication_backend_file.secret` | Use an exting secret to store the users database | `{"key":null,"name":null}` |
| `authelia.authentication_backend_file.secret.key` | Key of the secret containing the users database | `nil` |
| `authelia.authentication_backend_file.secret.name` | Name of the secret containing the users database | `nil` |
| `authelia.configuration` | Configure the Authelia instance | `{"access_control":{"default_policy":"deny","rules":[{"domain":"public.example.com","policy":"bypass"},{"domain":"traefik.example.com","policy":"one_factor"},{"domain":"secure.example.com","policy":"two_factor"},{"domain":"nip.io","policy":"bypass"}]},"authentication_backend":{"file":{"path":"/opt/authelia/config/users_database.yaml"}},"jwt_secret":"a_very_important_secret","log":{"level":"debug"},"notifier":{"filesystem":{"filename":"/dev/stdout"}},"regulation":{"ban_time":300,"find_time":120,"max_retries":3},"server":{"address":"tcp://:9091"},"session":{"cookies":[{"authelia_url":"https://auth.example.com","default_redirection_url":"https://www.example.com","domain":"example.com","expiration":"1h","inactivity":"5m","name":"authelia_session","remember_me":"1d","same_site":"lax"},{"authelia_url":"https://authelia.1f000001.nip.io","default_redirection_url":"https://actual.1f000001.nip.io","domain":"nip.io","expiration":"1h","inactivity":"5m","name":"authelia_session","remember_me":"1d","same_site":"lax"}],"secret":"unsecure_session_secret"},"storage":{"encryption_key":"you_must_generate_a_random_string_of_more_than_twenty_chars_and_configure_this","local":{"path":"/var/lib/authelia/db.sqlite3"}},"totp":{"issuer":"authelia.com"}}` |
| `authelia.configuration_secrets` | Configure the Authelia instance using secrets (see [www.authelia.com/configuration](https://www.authelia.com/configuration/methods/secrets/) for more information) | `nil` |
| `images.authelia.digest` | Authelia image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""` |
| `images.authelia.pullPolicy` | Authelia image pull policy | `"IfNotPresent"` |
| `images.authelia.registry` | Authelia image registry (optional) | `""` |
| `images.authelia.repository` | Authelia image repository | `"ghcr.io/beluga-cloud/authelia/authelia"` |
| `images.authelia.tag` | Authelia image tag (immutable tags are recommended) | `""` |
| `images.redis.digest` | Authelia image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""` |
| `images.redis.pullPolicy` | Authelia image pull policy | `"IfNotPresent"` |
| `images.redis.registry` | Authelia image registry (optional) | `""` |
| `images.redis.repository` | Authelia image repository | `"ghcr.io/beluga-cloud/authelia/redis"` |
| `images.redis.tag` | Authelia image tag (immutable tags are recommended) | `""` |

### Security parameters

| Key | Description | Default |
|-----|-------------|---------|
| `containerSecurityContext` | Security context for the Authelia container    ([kubernetes.io/docs]([kubernetes.io/docs](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/))) | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsGroup":65463,"runAsNonRoot":true,"runAsUser":65463}` |
| `podSecurityContext` | Security context for the pod ([kubernetes.io/docs]([kubernetes.io/docs](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/))) | `{"fsGroup":65463,"runAsGroup":65463,"runAsNonRoot":true,"runAsUser":65463,"seccompProfile":{"type":"RuntimeDefault"}}` |

### Deployment/Statefulset parameters

| Key | Description | Default |
|-----|-------------|---------|
| `affinity` | Affinity for pod assignment ([kubernetes.io/docs]([kubernetes.io/docs](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.26/#affinity-v1-core))) | `{}` |
| `nodeSelector` | Node labels for pod assignment | `{"kubernetes.io/os":"linux"}` |
| `podAnnotations` | Additional annotations to apply to the pod. | `{}` |
| `podLabels` | Additional labels to be added to pods | `{}` |
| `replicaCount` | Number of pods per zone. (_**It's not recommended to add more instance of Authelia**_) | `1` |
| `resources.authelia.limits` | The resources limits for the Authelia container | `{"cpu":1,"memory":"1.25Gi"}` |
| `resources.authelia.requests` | The requested resources for the Authelia container | `{"cpu":"250m","memory":"1.25Gi"}` |
| `strategy` | Set up update strategy for Authelia installation. Set to `Recreate` if you use persistent volume    that cannot be mounted by more than one pods to make sure the pods is destroyed first.    ([kubernetes.io/docs]([kubernetes.io/docs](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy))) | `{}` |
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
| `ingress.hostname` | Default host for the ingress resource | `"authelia.local"` |
| `ingress.ingressClassName` | IngressClass that will be used to implement the Ingress | `""` |
| `ingress.path` | The Path to Authelia. You may need to set this to '/*' in order to use this with ALB ingress controllers. | `"/"` |
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
| `service.loadBalancerSourceRanges` | Addresses that are allowed when service is `LoadBalancer` | `[]` |
| `service.type` | Service type | `"ClusterIP"` |
| `service.web.nodePort` | Specify the nodePort value for the `LoadBalancer` and `NodePort` service types | `0` |
| `service.web.port` | `web` service port | `9091` |

### Persistence parameters

| Key | Description | Default |
|-----|-------------|---------|
| `persistence.authelia.enabled` | Enable data persistence using `PVC`. If false, use emptyDir | `true` |
| `persistence.authelia.volumeClaimSpec` | Claims that pods are allowed to reference (see    [kubernetes.io/docs](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.26/#persistentvolumeclaim-v1-core)    for structural reference) | `{"accessModes":["ReadWriteOnce"],"resources":{"requests":{"storage":"100M"}}}` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```shell
helm install my-release --set fullnameOverride=my-authelia beluga-cloud/authelia
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```shell
helm install my-release -f values.yaml my-repo/authelia
```

> **Tip:** You can use the default values.yaml

## Managing Authelia configuration secrets using this Helm Chart

Securing sensitive information, such as encryption keys, is critical for a robust Authelia deployment. Authelia provides
a dedicated method for managing secrets through their [`Secrets configuration layer`](https://www.authelia.com/configuration/methods/secrets/),
and this Helm charts offers a straightforward way to implement this through `authelia.configuration_secrets`.

Here's an example:

```yaml
authelia:
  configuration_secrets:
    storage:
      encryption_key:
        secretRefName:
          name: authelia-secret
          key: encryption_key
```

Explanation of the fields:
- `authelia.configuration_secrets`: The field where all secret configurations are defined
- `storage.encryption_key`: The Authelia configuration that need to configured with the secret
- `secretRefName`: The reference of the secret to mount inside Authelia

This configuration ensures that sensitive information is stored securely in a Kubernetes Secret named `authelia-secret`,
with the encryption key accessible under the key encryption_key.

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
