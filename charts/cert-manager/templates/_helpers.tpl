{{/* vim: set filetype=mustache: */}}

{{/*
Labels that should be added on each issuers.
*/}}
{{- define "issuer.labels" -}}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/*
Generates a specific credential name depending on the issuer name
*/}}
{{- define "issuer.crendentials.name" -}}
issuer-{{ .name }}-{{ .type }}-credentials
{{- end -}}

{{/*
Define in which namespace the credential secret is created
*/}}
{{- define "issuer.crendentials.namespace" -}}
{{- if or .clusterIssuer (not .namespace) -}}
{{ .Release.Namespace }}
{{- else -}}
{{ .namespace }}
{{- end -}}
{{- end -}}

{{/*
Render the .spec of all issuers
*/}}
{{- define "issuer.spec.render" -}}
{{- $credsName := (include "issuer.crendentials.name" .) -}}
{{- $credsNamespace := (include "issuer.crendentials.namespace" .) -}}
{{ tpl (.spec | toYaml) (dict "Template" .Template "credentials" (dict "name" $credsName "namespace" $credsNamespace)) }}
{{- end -}}
