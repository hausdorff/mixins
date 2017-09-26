local values = import "../values.libsonnet";

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
        initContainers: [
          {
            name: "remove-lost-found",
            image: "busybox:1.25.0",
            imagePullPolicy: values.imagePullPolicy,
            command:  ["rm", "-fr", "/var/lib/mysql/lost+found"],
            volumeMounts: [
              {
                name: "data",
                mountPath: "/var/lib/mysql",
                [if "subPath" in values.persistence then "subPath"]: values.persistence.subPath
              },
            ]
          },
        ],
        containers: [
          {
            name: values.fullname,
            image: "%s:%s" % [values.image, values.imageTag],
            imagePullPolicy: values.imagePullPolicy,
            resources: values.resources,
            env:
              if "mysqlAllowEmptyPassword" in values then [
                {
                  name: "MYSQL_ALLOW_EMPTY_PASSWORD",
                  value: "true",
                },
              ] else [
                {
                  name: "MYSQL_ROOT_PASSWORD",
                  valueFrom: {
                    secretKeyRef: {
                      name: values.fullname,
                      key: "mysql-root-password",
                    }
                  },
                },
                {
                  name: "MYSQL_PASSWORD",
                  valueFrom: {
                    secretKeyRef: {
                      name: values.fullname,
                      key: "mysql-password",
                    },
                  },
                },
              ] + [
                {
                  name: "MYSQL_USER",
                  value: if "mysqlUser" in values then values.mysqlUser else "",
                },
                {
                  name: "MYSQL_DATABASE",
                  value: if "mysqlDatabase" in values then values.mysqlDatabase else "",
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
                command:
                  if "mysqlAllowEmptyPassword" in values then [
                    "mysqladmin",
                    "ping",
                  ] else [
                    "sh",
                    "-c",
                    "mysqladmin ping -u root -p${MYSQL_ROOT_PASSWORD}",
                  ],
              },
              initialDelaySeconds: 30,
              timeoutSeconds: 5,
            },
            readinessProbe: {
              exec: {
                command:
                  if "mysqlAllowEmptyPassword" in values then [
                    "mysqladmin",
                    "ping",
                  ] else [
                    "sh",
                    "-c",
                    "mysqladmin ping -u root -p${MYSQL_ROOT_PASSWORD}",
                  ],
              },
              initialDelaySeconds: 5,
              timeoutSeconds: 1,
            },
            volumeMounts: [
              {
                name: "data",
                mountPath: "/var/lib/mysql",
                [if "subPath" in values.persistence then "subPath"]: values.persistence.subPath,
              },
            ] + if "configurationFiles" in values then [
              {
                name: "configurations",
                mountPath: "/etc/mysql/conf.d",
              }
            ] else [],
          },
        ],
        volumes:
          if "configurationFiles" in values then [
            {
              name: "configurations",
              configMap: {
                name: values.fullname,
              },
            },
          ] else [] + [
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
            }
          ],
      },
    },
  },
}
