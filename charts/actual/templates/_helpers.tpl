{{/*
Return the proper image name
{{ include "belugapps.images.image" ( dict "imageRoot" .Values.path.to.the.image "global" $) }}
*/}}
{{- define "common.images.image" }}
{{- $image := index . 0 }}
{{- $overrideRegistry := index . 1 }}
{{- $defaultTag := index . 2 -}}

{{- $registryName := $overrideRegistry | default $image.registry | default (index (regexSplit "/" (trim $image.repository) 2) 0) }}
{{- $repositoryName := $image.repository | trimPrefix (printf "%s/" $registryName) }}
{{- $termination := printf ":%s" ($image.tag | default $defaultTag) }}
{{- with $image.digest }}
  {{- $termination := printf "@%s" (. | toString) }}
{{- end }}
{{- printf "%s/%s%s" $registryName $repositoryName $termination }}
{{- end }}
