{{/*
Return the proper image name
{{ include "common.images.image" ( dict "imageRoot" .Values.path.to.the.image "global" $) }}
*/}}
{{- define "blib.images.image" }}
{{- $ := .global -}}

{{- $registryName := $.Values.global.imageRegistry | default .image.registry | default (regexSplit "/" .image.repository 2 | first) }}
{{- $repositoryName := .image.repository | trimPrefix (printf "%s/" $registryName) }}
{{- $termination := printf ":%s" (.image.tag | default $.Chart.AppVersion) }}
{{- with .image.digest }}
  {{- $termination := printf "@%s" (. | toString) }}
{{- end }}
{{- printf "%s/%s%s" $registryName $repositoryName $termination }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "helm-dashboard.serviceAccountName" -}}
{{- if .Values.rbac.serviceAccount.create }}
{{- default (include "common.names.fullname" .) .Values.rbac.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.rbac.serviceAccount.name }}
{{- end }}
{{- end }}
