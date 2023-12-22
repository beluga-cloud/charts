{{- define "authelia.configuration_secrets.environments" -}}
  {{- $object := (index . 0) -}}
  {{- $keys := (index . 1) -}}
  {{- range $key, $value := $object -}}
    {{- if (kindIs "map" $value) -}}
      {{- if and (dig "secretKeyRef" false $value) (dig "secretKeyRef" "name" false $value) (dig "secretKeyRef" "key" false $value) }}
- name: AUTHELIA_{{ append $keys $key | join "_" | upper }}_FILE
  value: /run/secrets/authelia.com/{{ append $keys $key | join "_" | lower }}
      {{- else -}}
        {{- include "authelia.configuration_secrets.environments" (list $value (append $keys $key)) -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "authelia.configuration_secrets.volumeMounts" }}
  {{- $object := (index . 0) }}
  {{- $keys := (index . 1) }}
  {{- range $key, $value := $object }}
    {{- if (kindIs "map" $value) }}
      {{- if and (dig "secretKeyRef" false $value) (dig "secretKeyRef" "name" false $value) (dig "secretKeyRef" "key" false $value) }}
- name: {{ append $keys $key | join "-" | replace "_" "" | lower }}
  mountPath: /run/secrets/authelia.com/{{ append $keys $key | join "_" | lower }}
  subPath: {{ append $keys $key | join "_" | lower }}
      {{- else }}
        {{- include "authelia.configuration_secrets.volumeMounts" (list $value (append $keys $key)) }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}


{{- define "authelia.configuration_secrets.volumes" }}
  {{- $object := (index . 0) }}
  {{- $keys := (index . 1) }}
  {{- range $key, $value := $object }}
    {{- if (kindIs "map" $value) }}
      {{- if and (dig "secretKeyRef" false $value) (dig "secretKeyRef" "name" false $value) (dig "secretKeyRef" "key" false $value) }}
- secret:
    name: {{ dig "secretKeyRef" "name" nil $value }}
    items:
      - key: {{ dig "secretKeyRef" "key" nil $value }}
        path: {{ append $keys $key | join "_" | lower }}
      {{- else }}
        {{- include "authelia.configuration_secrets.volumes" (list $value (append $keys $key)) }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}

{{- define "authelia.configuration_secrets.omit" }}
  {{- $configuration := (index . 0) }}
  {{- $secret := (index . 1)}}
  {{- range $key, $value := $configuration }}
    {{- if hasKey $secret $key }}
      {{- if dig $key "secretKeyRef" false $secret }}
# !! `{{ $key }}` is already a secret... ignored
      {{- else if and (kindIs "map" $value) (kindIs "map" $secret) }}
{{ $key }}: {{ include "authelia.configuration_secrets.omit" (list $value (index $secret $key)) | indent 2 }}
      {{- else if or (kindIs "map" $value) (kindIs "slice" $value) }}
{{ $key }}: {{ $value | toYaml | nindent 2 }}
      {{- else if $value }}
{{ $key }}: {{ $value | toYaml }}
      {{- end }}
    {{- else if or (kindIs "map" $value) (kindIs "slice" $value) }}
{{ $key }}: {{ $value | toYaml | nindent 2 }}
    {{- else if $value }}
{{ $key }}: {{ $value | toYaml }}
    {{- end }}
  {{- end }}
{{- end }}