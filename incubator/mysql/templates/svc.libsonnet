local values = import "../values.libsonnet";

{
  apiVersion: "v1",
  kind: "Service",
  metadata: {
    name: values.fullname,
    labels: {
      app: values.fullname
    },
  },
  spec: {
    ports: [
      {
        name: "mysql",
        port: 3306,
        targetPort: "mysql",
      },
    ],
    selector: {
      app: values.fullname,
    },
  },
}
