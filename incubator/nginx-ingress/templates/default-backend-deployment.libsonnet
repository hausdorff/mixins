local values = import "../values.libsonnet";

if values.defaultBackend.enabled then {
  apiVersion: "extensions/v1beta1",
  kind: "Deployment",
  metadata: {
    labels: {
      app: values.name,
      component: values.defaultBackend.name,
    },
    name: values.defaultBackend.fullname,
  },
  spec: {
    replicas: values.defaultBackend.replicaCount,
    template: {
      metadata: {
        annotations: values.defaultBackend.podAnnotations,
        labels: {
          app: values.name,
          component: values.defaultBackend.name,
          release: values.release.name
        },
      },
      spec: {
        containers: [
          {
            name: "%s-%s" % [values.name, values.defaultBackend.name],
            image: "%s:%s" % [values.defaultBackend.image.repository, values.defaultBackend.image.tag],
            imagePullPolicy: values.defaultBackend.image.pullPolicy,
            args: [
            // {{- range $key, $value := .Values.defaultBackend.extraArgs }}
            //   - --{{ $key }}={{ $value }}
            // {{- end }}
            ],
            livenessProbe: {
              httpGet: {
                path: "/healthz",
                port: 8080,
                scheme: "HTTP",
              },
              initialDelaySeconds: 30,
              timeoutSeconds: 5,
            },
            ports: [
              {
                containerPort: 8080,
                protocol: "TCP",
              },
            ],
            resources: values.defaultBackend.resources,
          },
        ],
        nodeSelector: values.defaultBackend.nodeSelector,
        tolerations: values.defaultBackend.tolerations,
        terminationGracePeriodSeconds: 60,
      },
    },
  },
}
