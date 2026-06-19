{{- define "hello-world.labels" -}}
app: {{ .Values.metadata.labels.app }}
tier: {{ .Values.metadata.labels.tier }}
env: {{ .Values.metadata.labels.env }}
{{- end -}}