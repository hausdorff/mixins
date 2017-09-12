local values = import "values.libsonnet";
local redis = import "redis.libsonnet";

{
  apiVersion: "extensions/v1beta1",
  kind: "Deployment",
  metadata: {
    name: redis.fullname,
    namespace: values.namespace,
    labels: {
      app: redis.fullname,
    },
  },
  spec: {
    template: {
      metadata: {
        labels: {
          app: redis.fullname,
        }
      },
      spec: {
        nodeSelector: values.nodeSelector,
        tolerations: values.tolerations,
        containers: [
          {
            name: redis.fullname,
            image: values.image,
            imagePullPolicy: values.imagePullPolicy,
            args: values.args,
            env: [
              if values.usePassword then {
                name: "REDIS_PASSWORD",
                valueFrom: {
                  secretKeyRef: {
                    name: redis.fullname,
                    key: "redis-password",
                  },
                }
              }
              else {
                name: "ALLOW_EMPTY_PASSWORD",
                value: "yes",
              },
            ],
            ports: [
              {
                name: "redis",
                containerPort: 6379,
              },
            ],
            livenessProbe: {
              exec: {
                command: [
                  "redis-cli",
                  "ping",
                ],
              },
              initialDelaySeconds: 30,
              timeoutSeconds: 5,
            },
            readinessProbe: {
              exec: {
                command: [
                  "redis-cli",
                  "ping",
                ],
              },
              initialDelaySeconds: 5,
              timeoutSeconds: 1,
            },
            resources: values.resources,
            volumeMounts: [
              {
                name: "redis-data",
                mountPath: "/bitnami/redis",
              },
            ]
          },
        ] +
        if !values.metrics.enabled then []
        else [
          {
            name: "metrics",
            image: values.metrics.image + ':' + values.metrics.imageTag,
            imagePullPolicy: values.metrics.imagePullPolicy,
            env: [
              {
                name: "REDIS_ALIAS",
                value: redis.fullname,
              }
            ] + if !values.usePassword then []
            else [
              {
                name: "REDIS_PASSWORD",
                valueFrom: {
                  secretKeyRef: {
                    name: redis.fullname,
                    key: "redis-password",
                  }
                },
              },
            ],
            ports: [
              {
                name: "metrics",
                containerPort: 9121,
              }
            ],
            resources: values.metrics.resources,
          }
        ],
        volumes: [
          if values.persistence.enabled then {
            name: "redis-data",
            persistentVolumeClaim: {
              claimName:
                if "existingClaim" in values.persistence
                then values.persistence.existingClaim
                else redis.fullname,
            }
          } else {
            name: "redis-data",
            emptyDir: {}
          },
        ]
      }
    }
  }
}
