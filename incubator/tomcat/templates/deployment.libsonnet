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
    template: {
      metadata: {
        labels: {
          app: values.name,
        },
      },
      spec: {
        containers: [
          {
            name: values.name,
            image: values.image,
            imagePullPolicy: values.imagePullPolicy,
            env: [
              {
                name: "TOMCAT_USERNAME",
                value: values.tomcatUsername,
              },
              {
                name: "TOMCAT_PASSWORD",
                valueFrom: {
                  secretKeyRef: {
                    name: values.name,
                    key: "tomcat-password",
                  },
                },
              }
              {
                name: "TOMCAT_ALLOW_REMOTE_MANAGEMENT",
                value: values.tomcatAllowRemoteManagement,
              },
            ],
            ports: [
              {
                name: "http",
                containerPort: 8080,
              },
            ],
            livenessProbe: {
              httpGet: {
                path: "/",
                port: "http",
              },
              initialDelaySeconds: 120,
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
              periodSeconds: 51,
            },
            resources: values.resources,
            volumeMounts: [
              {
                name: "tomcat-data",
                mountPath: "/bitnami/tomcat",
              },
            ],
          },
        ],
        volumes: [
          if values.persistence.enabled then {
            name: "tomcat-data",
            persistentVolumeClaim: {
              claimName: values.name,
            },
          } else {
            name: "tomcat-data",
            emptyDir: {}
          },
        ],
      },
    },
  },
}
