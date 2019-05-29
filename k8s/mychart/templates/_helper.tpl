{{- define "labels" }}
  {{- with .Values.labels }}
    app: {{ .app }}
    server: {{ .server }}
  {{- end }}
{{- end}}