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
        }
      },
      spec: {
        containers: [
          {
            name: values.name,
            image: "bitnami/apache:%s" % values.imageTag,
            imagePullPolicy: values.imagePullPolicy,
            ports: [
              {
                name: "http",
                containerPort: 80,
              },
              {
                name: "https",
                containerPort: 443,
              }
            ],
            livenessProbe: {
              httpGet: {
                path: "/",
                port: "http",
              },
              initialDelaySeconds: 30,
              timeoutSeconds: 5,
              failureThreshold: 6,
            },
            readinessProbe: {
              httpGet: {
                path: "/",
                port: "http",
              },
              initialDelaySeconds: 5,
              timeoutSeconds: 3,
              periodSeconds: 5,
            },
            volumeMounts: [
              {
                name: "apache-data",
                mountPath: "/bitnami/apache",
              }
            ],
          }
        ],
        volumes: [
          {
            name: "apache-data",
            emptyDir: {},
          }
        ]
      }
    }
  }
}