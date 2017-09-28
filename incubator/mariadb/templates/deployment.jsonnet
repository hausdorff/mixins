local values = import "../values.libsonnet";

local mariadbUser = if "mariadbUser" in values then [
  {
    name: "MARIADB_PASSWORD",
    valueFrom: {
      secretKeyRef: {
        name: values.fullname,
        key: "mariadb-password",
      },
    },
  },
] else [];

local mariadbPassword =
  if values.usePassword then ([
    {
      name: "MARIADB_ROOT_PASSWORD",
      valueFrom: {
        secretKeyRef: {
          name: values.fullname,
          key: "mariadb-root-password",
        },
      },
    },
  ] + mariadbUser)
  else [
    {
      name: "ALLOW_EMPTY_PASSWORD",
      value: "yes",
    },
  ];

{
  apiVersion: "extensions/v1beta1",
  kind: "Deployment",
  metadata: {
    name: values.fullname,
    labels: {
      app: values.fullname,
    },
  },
  spec: {
    template: {
      metadata: {
        labels: {
          app: values.fullname,
        },
      },
      spec: {
        containers: [
          {
            name: "mariadb",
            image: values.image,
            imagePullPolicy: values.imagePullPolicy,
            env:
              mariadbPassword + [
                {
                  name: "MARIADB_USER",
                  value:
                    if "mariadbUser" in values
                    then values.mariadbUser
                    else "",
                },
                {
                  name: "MARIADB_DATABASE",
                  value:
                    if "mariadbDatabase" in values
                    then values.mariadbDatabase
                    else "",
                },
              ],
            ports: [
              {
                name: "mysql",
                containerPort: 3306,
              },
            ],
            livenessProbe: {
              exec: {
                command: [
                  "mysqladmin",
                  "ping",
                ],
              },
              initialDelaySeconds: 30,
              timeoutSeconds: 5,
            },
            readinessProbe: {
              exec: {
                command: [
                  "mysqladmin",
                  "ping",
                ],
              },
              initialDelaySeconds: 5,
              timeoutSeconds: 1,
            },
            resources: values.resources,
            volumeMounts: [
              {
                name: "config",
                mountPath: "/bitnami/mariadb/conf/my_custom.cnf",
                subPath: "my.cnf",
              },
              {
                name: "data",
                mountPath: "/bitnami/mariadb",
              },
            ],
          },
        ] + if values.metrics.enabled then [
          {
            name: "metrics",
            image: "%s:%s" % [values.metrics.image, values.metrics.imageTag],
            imagePullPolicy: values.metrics.imagePullPolicy,
            env:
              if values.usePassword then [
                {
                  name: "MARIADB_ROOT_PASSWORD",
                  valueFrom: {
                    secretKeyRef: {
                      name: values.fullname,
                      key: "mariadb-root-password",
                    },
                  },
                },
              ],
            command: [ 'sh', '-c', 'DATA_SOURCE_NAME="root:$MARIADB_ROOT_PASSWORD@(localhost:3306)/" /bin/mysqld_exporter' ],
            ports: [
              {
                name: "metrics",
                containerPort: 9104,
              },
            ],
            livenessProbe: {
              httpGet: {
                path: "/metrics",
                port: "metrics",
              },
              initialDelaySeconds: 15,
              timeoutSeconds: 5,
            },
            readinessProbe: {
              httpGet: {
                path: "/metrics",
                port: "metrics",
              },
              initialDelaySeconds: 5,
              timeoutSeconds: 1,
            },
            resources: values.metrics.resources,
          },
        ] else [],
        volumes: [
          {
            name: "config",
            configMap: {
              name: values.fullname,
            },
          },
          if values.persistence.enabled then {
            name: "data",
            persistentVolumeClaim: {
              claimName:
                if "existingClaim" in values.persistence
                then values.persistence.existingClaim
                else values.fullname,
            },
          } else {
            name: "data",
            emptyDir: {},
          },
        ],
      },
    },
  },
}
