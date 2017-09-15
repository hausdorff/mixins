local values = import "../values.libsonnet";

if values.controller.kind == "Deployment" then {
  apiVersion: "extensions/v1beta1",
  kind: "Deployment",
  metadata: {
    labels: {
      app: values.name,
      component: values.controller.name,
    },
    name: values.controller.fullname,
  },
  spec: {
    replicas: values.controller.replicaCount,
    template: {
      metadata: {
        annotations: {
          // checksum/config: {{ include (print $.Template.BasePath "/controller-configmap.yaml") . | sha256sum }}
        } + values.controller.podAnnotations,
        labels: {
          app: values.name,
          component: values.controller.name,
        },
      },
      spec: {
        containers: [
          {
            name: "%s-%s" % [values.name, values.controller.name],
            image: "%s:%s" % [values.controller.image.repository, values.controller.image.tag],
            imagePullPolicy: values.controller.image.pullPolicy,
            args: [
              "/nginx-ingress-controller",
              // - --default-backend-service={{ if .Values.defaultBackend.enabled }}{{ .Release.Namespace }}/{{ template "defaultBackend.fullname" . }}{{ else }}{{ .Values.controller.defaultBackendService }}{{ end }}
            // {{- if and (contains "0.9" .Values.controller.image.tag) .Values.controller.publishService.enabled }}
            //   - --publish-service={{ template "controller.publishServicePath" . }}
            // {{- end }}
            // {{- if (contains "0.9" .Values.controller.image.tag) }}
            //   - --election-id={{ .Values.controller.electionID }}
            // {{- end }}
            // {{- if (contains "0.9" .Values.controller.image.tag) }}
            //   - --ingress-class={{ .Values.controller.ingressClass }}
            // {{- end }}
            // {{- if (contains "0.9" .Values.controller.image.tag) }}
            //   - --configmap={{ .Release.Namespace }}/{{ template "controller.fullname" . }}
            // {{- else }}
            //   - --nginx-configmap={{ .Release.Namespace }}/{{ template "controller.fullname" . }}
            // {{- end }}
            // {{- if .Values.tcp }}
            //   - --tcp-services-configmap={{ .Release.Namespace }}/{{ template "fullname" . }}-tcp
            // {{- end }}
            // {{- if .Values.udp }}
            //   - --udp-services-configmap={{ .Release.Namespace }}/{{ template "fullname" . }}-udp
            // {{- end }}
            // {{- if .Values.controller.scope.enabled }}
            //   - --watch-namespace={{ default .Release.Namespace .Values.controller.scope.namespace }}
            // {{- end }}
            // {{- range $key, $value := .Values.controller.extraArgs }}
            //   - --{{ $key }}={{ $value }}
            // {{- end }}
            ],
            env: [
              {
                name: "POD_NAME",
                valueFrom: {
                  fieldRef: {
                    fieldPath: "metadata.name"
                  },
                },
              },
              {
                name: "POD_NAMESPACE",
                valueFrom: {
                  fieldRef: {
                    fieldPath: "metadata.namespace",
                  }
                },
              },
            ],
            livenessProbe: {
              httpGet: {
                path: "/healthz",
                port: 10254,
                scheme: "HTTP",
              },
              initialDelaySeconds: 10,
              timeoutSeconds: 1,
            },
            ports: [
              {
                name: "http",
                containerPort: 80,
                protocol: "TCP",
              },
              {
                name: "https",
                containerPort: 443,
                protocol: "TCP",
              },
            // {{- if .Values.controller.stats.enabled }}
            //   - name: stats
            //     containerPort: 18080
            //     protocol: TCP
            // {{- end }}
            // {{- range $key, $value := .Values.tcp }}
            //   - name: "{{ $key }}-tcp"
            //     containerPort: {{ $key }}
            //     protocol: TCP
            // {{- end }}
            // {{- range $key, $value := .Values.udp }}
            //   - name: "{{ $key }}-udp"
            //     containerPort: {{ $key }}
            //     protocol: UDP
            // {{- end }}
            ],
            readinessProbe: {
              httpGet: {
                path: "/healthz",
                port: 10254,
                scheme: "HTTP",
              },
            },
            resources: values.controller.resources,
          },
        ],
  //       {{- if .Values.controller.stats.enabled }}
  //         - name: {{ template "name" . }}-{{ .Values.statsExporter.name }}
  //           image: "{{ .Values.statsExporter.image.repository }}:{{ .Values.statsExporter.image.tag }}"
  //           imagePullPolicy: "{{ .Values.statsExporter.image.pullPolicy }}"
  //           env:
  //             - name: METRICS_ADDR
  //               value: ":9913"
  //             - name: METRICS_ENDPOINT
  //               value: "{{ .Values.statsExporter.endpoint }}"
  //             - name: METRICS_NS
  //               value: "{{ .Values.statsExporter.metricsNamespace }}"
  //             - name: NGINX_STATUS
  //               value: "{{ .Values.statsExporter.statusPage }}"
  //           ports:
  //             - name: metrics
  //               containerPort: 9913
  //               protocol: TCP
  //           resources:
  // {{ toYaml .Values.statsExporter.resources | indent 12 }}
  //       {{- end }}
        hostNetwork: values.controller.hostNetwork,
        nodeSelector: values.controller.nodeSelector,
        tolerations: values.controller.tolerations,
        serviceAccountName:
          if values.rbac.create
          then values.fullname
          else  values.rbac.serviceAccountName,
        terminationGracePeriodSeconds: 60,
      },
    },
  },
}