local values = import "../values.libsonnet";

{
  apiVersion: "v1",
  kind: "Service",
  metadata: {
    name: values.mongodb.fullname,
    labels: {
      app: values.mongodb.fullname,
    },
  },
  spec: {
    type: values.serviceType,
    ports: [
      {
        name: "mongodb",
        port: 27017,
        targetPort: "mongodb",
      },
    ],
    selector: {
      app: values.mongodb.fullname,
    },
  },
}
