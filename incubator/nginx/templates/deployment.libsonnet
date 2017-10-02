local values = import "../values.libsonnet";

{
  apiVersion: "extensions/v1beta1",
  kind: "Deployment",
  metadata: {
    name: values.fullname,
    labels: {
      app: values.fullname
    },
  },
  spec: {
    replicas: 1,
    template: {
      metadata: {
        labels: {
          app: values.fullname
        },
      },
      spec: {
        containers: [
          {
            name: values.fullname,
            image: "bitnami/nginx:" + values.imageTag,
            imagePullPolicy: values.imagePullPolicy,
            ports: [
              {
                name: "http",
                containerPort: 80,
              },
              {
                name: "https",
                containerPort: 443,
              },
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
                name: "nginx-data",
                mountPath: "/bitnami/nginx",
              },
            ] + if "vhost" in values then [
              {
                name: "nginx-vhost",
                mountPath: "/bitnami/nginx/conf/vhosts",
              }
            ] else [],
          },
        ],
        volumes: [
          {
            name: "nginx-data",
            emptyDir: {},
          }
        ] + if "vhost" in values then [
          {
            name: "nginx-vhost",
            configMap: {
              name: values.fullname,
            },
          }
        ],
      },
    },
  },
}
