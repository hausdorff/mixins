local values = import "../values.libsonnet";

{
  apiVersion: "extensions/v1beta1",
  kind: "Deployment",
  metadata: {
    name: values.name,
    labels: {
      app: values.name,
    },
  },
  spec: {
    replicas: 1,
    template: {
      metadata: {
        labels: {
          app: values.name,
        },
        annotations: {
          "pod.beta.kubernetes.io/init-containers": '[
            {
              "name": "git-clone-app",
              "image": "{{ .Values.image }}",
              "imagePullPolicy": "{{ .Values.imagePullPolicy }}",
              "command": [ "/bin/sh", "-c" , "git clone {{ .Values.repository }} /app && git checkout {{ .Values.revision }}" ],
              "volumeMounts": [
                {
                  "name": "app",
                  "mountPath": "/app"
                }
              ]
            },
            {
              "name": "npm-install",
              "image": "{{ .Values.image }}",
              "imagePullPolicy": "{{ .Values.imagePullPolicy }}",
              "command": [ "npm", "install" ],
              "volumeMounts": [
                {
                  "name": "app",
                  "mountPath": "/app"
                }
              ]
            }
          ]'
        },
      },
      spec: {
        containers: [
          {
            name: values.name,
            securityContext: {
              readOnlyRootFilesystem: true,
            },
            image: values.image,
            imagePullPolicy: values.imagePullPolicy,
            env: [
              {
                name: "GIT_REPO",
                value: values.repository,
              },
            ],
            command: [ "npm", "start" ],
            ports: [
              {
                name: "http",
                containerPort: 3000,
              }
            ],
            livenessProbe: {
              httpGet: {
                path: "/",
                port: "http",
              },
              initialDelaySeconds: 180,
              timeoutSeconds: 5,
              failureThreshold: 6,
            },
            readinessProbe: {
              httpGet: {
                path: "/",
                port: "http",
              },
              initialDelaySeconds: 30,
              timeoutSeconds: 3,
              periodSeconds: 5,
            },
            resources: values.resources,
            volumeMounts: [
              {
                name: "app",
                mountPath: "/app",
              },
              {
                name: "data",
                mountPath: values.persistence.path,
              }
            ],
          }
        ],
        volumes: [
          {
            name: "app",
            emptyDir: {},
          },
          if values.persistence.enabled
          then {
            name: "data",
            persistentVolumeClaim: {
              claimName: values.name,
            },
          } else {
            name: "data",
            emptyDir: {},
          },
          {
          },
        ],
      },
    },
  }
}
