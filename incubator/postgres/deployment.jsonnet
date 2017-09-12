local values = import "values.libsonnet";
local postgresql = import "postgresql.libsonnet";
local util = import "../util.libsonnet";

{
  apiVersion: "extensions/v1beta1",
  kind: "Deployment",
  metadata: {
    name: postgresql.fullname,
    namespace: values.namespace,
    labels: {
      app: postgresql.fullname
    },
  },
  spec: {
    template: {
      metadata: {
        labels: {
          app: postgresql.fullname,
        }
      },
      spec: {
        [if "nodeSelector" in values then "nodeSelector"]: values.nodeSelector,
        [if "tolerations" in values then "tolerations"]: values.tolerations,
        containers:
          util.concatIf(
            values.metrics.enabled,
            [
              {
                name: postgresql.fullname,
                image: values.image + ":" + values.imageTag,
                imagePullPolicy: values.imagePullPolicy,
                env: [
                  {
                    name: "POSTGRES_USER",
                    value:
                      if "postgresUser" in values
                      then values.postgresUser
                      else "postgres"
                  },
                  {
                    # Required for pg_isready in the health probes.
                    name: "PGUSER",
                    value:
                      if "postgresUser" in values
                      then values.postgresUser
                      else "postgres"
                  },
                  {
                    name: "POSTGRES_DB",
                    value:
                      if "postgresDatabase" in values
                      then values.postgresDatabase
                      else ""
                  },
                  {
                    name: "POSTGRES_INITDB_ARGS",
                    value:
                      if "postgresInitdbArgs" in values
                      then values.postgresInitdbArgs
                      else ""
                  },
                  {
                    name: "PGDATA",
                    value: "/var/lib/postgresql/data/pgdata",
                  },
                  {
                    name: "POSTGRES_PASSWORD",
                    valueFrom: {
                      secretKeyRef: {
                        name: postgresql.fullname,
                        key: "postgres-password"
                      },
                    },
                  },
                  {
                    name: "POD_IP",
                    valueFrom: {
                      fieldRef: {
                        fieldPath: "status.podIP",
                      }
                    }
                  }
                ],
                ports: [
                  {
                    name: "postgresql",
                    containerPort: 5432,
                  },
                ],
                livenessProbe: {
                  exec: {
                    command: [
                      "sh",
                      "-c",
                      "exec pg_isready --host $POD_IP",
                    ],
                  },
                  initialDelaySeconds: 60,
                  timeoutSeconds: 5,
                  failureThreshold: 6,
                },
                readinessProbe: {
                  exec: {
                    command: [
                      "sh",
                      "-c",
                      "exec pg_isready --host $POD_IP",
                    ],
                  },
                  initialDelaySeconds: 5,
                  timeoutSeconds: 3,
                  periodSeconds: 5,
                },
                resources: values.resources,
                volumeMounts: [
                  {
                    name: "data",
                    mountPath: "/var/lib/postgresql/data/pgdata",
                    subPath: values.persistence.subPath
                  },
                ],
              },
            ],
            [
              {
                name: "metrics",
                image: values.metrics.image + ":" + values.metrics.imageTag,
                imagePullPolicy: values.metrics.imagePullPolicy,
                env: [
                  {
                    name: "DATA_SOURCE_NAME",
                    value: "postgresql://postgres@127.0.0.1:5432?sslmode=disable",
                  },
                ],
                ports: [
                  {
                    name: "metrics",
                    containerPort: 9187,
                  },
                ],
                resources: values.metrics.resources,
              } + if values.metrics.customMetrics then {
                args: ["-extend.query-path", "/conf/custom-metrics.yaml"],
                volumeMounts: [
                  {
                    name: "custom-metrics",
                    mountPath: "/conf",
                    readOnly: true,
                  },
                ],
              } else {},
            ]
          ),
        volumes:
          util.concatIf(
            values.metrics.enabled && "customMetrics" in values.metrics,
            [
              if values.persistence.enabled then {
                name: "data",
                persistentVolumeClaim: {
                  claimName:
                    if "existingClaim" in values.persistence
                    then values.persistence.existingClaim
                    else postgresql.fullname,
                },
              } else {
                name: "data",
                emptyDir: {}
              },
            ],
            [
              {
                name: "custom-metrics",
                secret: {
                  secretName: postgresql.fullname,
                  items: [
                    {
                      key: "custom-metrics.yaml",
                      path: "custom-metrics.yaml"
                    }
                  ],
                }
              }
            ]),
      }
    }
  }
}
