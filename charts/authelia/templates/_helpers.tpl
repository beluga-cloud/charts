{{- define "authelia.configuration_secrets.environments" -}}
  {{-  $object := (index . 0) -}}
  {{-  $keys := (index . 1) -}}
  {{- range $key, $value := $object -}}
    {{- if (kindIs "map" $value) -}}
      {{- if and (dig "secretKeyRef" "name" false $value) (dig "secretKeyRef" "key" false $value) }}
- name: AUTHELIA_{{ append $keys $key | join "_" | upper }}_FILE
  value: /run/secrets/authelia.com/{{ append $keys $key | join "_" | lower }}
      {{- else -}}
        {{- template "authelia.configuration_secrets.environments" (list $value (append $keys $key)) -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "authelia.configuration_secrets.volumeMounts" }}
    {{-  $object := (index . 0) }}
    {{-  $keys := (index . 1) }}
    {{- range $key, $value := $object }}
      {{- if (kindIs "map" $value) }}
        {{- if and (dig "secretKeyRef" "name" false $value) (dig "secretKeyRef" "key" false $value) }}
- name: {{ append $keys $key | join "-" | replace "_" "" | lower }}
  mountPath: /run/secrets/authelia.com/{{ append $keys $key | join "_" | lower }}
  subPath: {{ append $keys $key | join "_" | lower }}
        {{- else }}
          {{- template "authelia.configuration_secrets.volumeMounts" (list $value (append $keys $key)) }}
        {{- end }}
      {{- end }}
    {{- end }}
{{- end }}


{{- define "authelia.configuration_secrets.volumes" }}
    {{-  $object := (index . 0) }}
    {{-  $keys := (index . 1) }}
    {{- range $key, $value := $object }}
      {{- if (kindIs "map" $value) }}
        {{- if and (dig "secretKeyRef" "name" false $value) (dig "secretKeyRef" "key" false $value) }}
- name: {{ append $keys $key | join "-" | replace "_" "" | lower }}
  secret:
    secretName: {{ dig "secretKeyRef" "name" nil $value }}
    defaultMode: 0600
    items:
      - key: {{ dig "secretKeyRef" "key" nil $value }}
        path: {{ append $keys $key | join "_" | lower }}
        {{- else }}
          {{- template "authelia.configuration_secrets.volumes" (list $value (append $keys $key)) }}
        {{- end }}
      {{- end }}
    {{- end }}
{{- end }}