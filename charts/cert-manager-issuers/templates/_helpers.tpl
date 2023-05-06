{{/* vim: set filetype=mustache: */}}

{{/*
  Generates a specific issuer name depending on the issuer configuration
*/}}
{{- define "issuer.name" -}}
{{ .issuer.spec | keys | first | lower }}-{{ .issuer.name | lower }}
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
{{ .issuer.namespace | default .context.Release.Namespace }}
{{- end -}}

{{/*
  Render the .spec of all issuers
*/}}
{{- define "issuer.spec.render" -}}
{{- $issuer := (dict "name" (include "issuer.name" .) "namespace" .issuer.namespace ) -}}
{{- $credentials := (dict "name" (include "issuer.crendentials.name" .) "namespace" (include "issuer.crendentials.namespace" .) ) -}}
{{ tpl (.issuer.spec | toYaml) (dict "Template" .context.Template "issuer" $issuer "credentials" $credentials) }}
{{- end -}}
