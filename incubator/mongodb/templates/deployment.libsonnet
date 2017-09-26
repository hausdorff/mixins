local values = import "../values.libsonnet";

{
  apiVersion: "extensions/v1beta1",
  kind: "Deployment",
  metadata: {
    name: values.mongodb.fullname,
    labels: {
      app: values.mongodb.fullname,
    },
  },
  spec: {
    template: {
      metadata: {
        labels: {
          app: values.mongodb.fullname,
        },
      },
      spec: {
        containers: [
          {
            name: values.mongodb.fullname,
            image: values.image,
            [if "imagePullPolicy" in values then "imagePullPolicy"]: values.imagePullPolicy,
            env: [
              {
                name: "MONGODB_ROOT_PASSWORD",
                valueFrom: {
                  secretKeyRef: {
                    name: values.mongodb.fullname,
                    key: "mongodb-root-password",
                  },
                },
              },
              {
                name: "MONGODB_USERNAME",
                value: if "mongodbUsername" in values then values.mongodbUsername else "",
              },
              {
                name: "MONGODB_PASSWORD",
                valueFrom: {
                  secretKeyRef: {
                    name: values.mongodb.fullname,
                    key: "mongodb-password",
                  },
                },
              },
              {
                name: "MONGODB_DATABASE",
                value: if "mongodbDatabase" in values then values.mongodbDatabase else "",
              },
            ],
            ports: [
              {
                name: "mongodb",
                containerPort: 27017,
              },
            ],
            livenessProbe: {
              exec: {
                command: [
                  "mongo",
                  "--eval",
                  "db.adminCommand('ping')",
                ],
              },
              initialDelaySeconds: 30,
              timeoutSeconds: 5,
            },
            readinessProbe: {
              exec: {
                command: [
                  "mongo",
                  "--eval",
                  "db.adminCommand('ping')",
                ],
              },
              initialDelaySeconds: 5,
              timeoutSeconds: 1,
            },
            volumeMounts: [
              {
                name: "data",
                mountPath: "/bitnami/mongodb",
              },
            ],
            resources: values.resources,
          },
        ],
        volumes: [
          if values.persistence.enabled then {
            name: "data",
            persistentVolumeClaim: {
              claimName: values.mongodb.fullname,
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
