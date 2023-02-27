{{/* vim: set filetype=mustache: */}}

{{/*
Generates a specific issuer name depending on the issuer configuration
*/}}
{{- define "issuer.name" -}}
{{- if .issuer.namespace -}}
{{ .issuer.spec | keys | first | lower }}-{{ .issuer.name | lower }}
{{- else -}}
{{ .issuer.spec | keys | first | lower }}-{{ .issuer.name | lower }}
{{- end -}}
{{- end -}}

{{/*
Generates a specific credential name depending on the issuer name
*/}}
{{- define "issuer.crendentials.name" -}}
{{- if .issuer.namespace -}}
issuer-{{ include "issuer.name" . }}-credentials
{{- else -}}
clusterissuer-{{ include "issuer.name" . }}-credentials
{{- end -}}
{{- end -}}

{{/*
Define in which namespace the credential secret is created
*/}}
{{- define "issuer.crendentials.namespace" -}}
{{ .issuer.namespace | default .root.Release.Namespace }}
{{- end -}}

{{/*
Render the .spec of all issuers
*/}}
{{- define "issuer.spec.render" -}}
{{- $issuerName := (include "issuer.name" .) }}
{{- $issuerNamespace := .issuer.namespace }}
{{- $credsName := (include "issuer.crendentials.name" .) -}}
{{- $credsNamespace := (include "issuer.crendentials.namespace" .) -}}
{{ tpl (.issuer.spec | toYaml) (dict "Template" .root.Template "credentials" (dict "name" $credsName "namespace" $credsNamespace) "issuer" (dict "name" $issuerName "namespace" $issuerNamespace)) }}
{{- end -}}
