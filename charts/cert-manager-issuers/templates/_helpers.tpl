{{/* vim: set filetype=mustache: */}}

{{/*
Generates a specific credential name depending on the issuer name
*/}}
{{- define "issuer.crendentials.name" -}}
{{- if .issuer.namespace -}}
issuer-{{ .issuer.spec | keys | first }}-{{ .issuer.name }}-credentials
{{- else -}}
clusterissuer-{{ .issuer.spec | keys | first }}-{{ .issuer.name }}-credentials
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
{{- $credsName := (include "issuer.crendentials.name" .) -}}
{{- $credsNamespace := (include "issuer.crendentials.namespace" .) -}}
{{ tpl (.issuer.spec | toYaml) (dict "Template" .root.Template "credentials" (dict "name" $credsName "namespace" $credsNamespace) "issuer" (dict "name" .issuer.name "namespace" .issuer.namespace)) }}
{{- end -}}
