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
