{{- define "hello-world.matchlabels" -}}
app: {{ .values.metadata.labels.app }}
tier: {{ .Values.metadata.labels.tier }}
env: {{ .Values.metadata.labels.env }}
{{- end -}}