{{/*
Expand the name of the chart.
*/}}
{{- define "tgc-common.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "tgc-common.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "tgc-common.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "tgc-common.labels" -}}
helm.sh/chart: {{ include "tgc-common.chart" . }}
{{ include "tgc-common.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "tgc-common.selectorLabels" -}}
app.kubernetes.io/name: {{ include "tgc-common.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "tgc-common.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "tgc-common.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Service Host and Path Matching
*/}}
{{- define "tgc-common.ingressRouteMatch" -}}
{{- printf "Host(`%s`) && PathPrefix(`%s`)" .Values.ingressRoute.host .Values.ingressRoute.route | quote -}}
{{- end }}

{{/*
Service Host and Path Matching for Private route
*/}}
{{- define "tgc-common.ingressRouteMatchPrivate" -}}
{{- printf "Host(`%s`) && PathPrefix(`%s`)" .Values.ingressRoute.privateHost .Values.ingressRoute.route | quote -}}
{{- end }}

{{/*
Service Host and Path Matching for Private route
*/}}
{{- define "tgc-common.ingressRouteMatchPublicInternal" -}}
{{- printf "Host(`%s`) && PathPrefix(`%s`)" .Values.ingressRoute.publicInternalHost .Values.ingressRoute.route | quote -}}
{{- end }}

{{/*
Linkerd Destination Override Header
$service_name.$namespace.svc.cluster.local:$service_port
*/}}
{{- define "tgc-common.l5dDstOverrideHeader" -}}
{{- printf "%s.%s.svc.cluster.local:%v" (include "tgc-common.fullname" . ) (.Release.Namespace) .Values.service.port.http -}}
{{- end }}