local values = import "../values.libsonnet";

{
  apiVersion: "v1",
  kind: "Service",
  metadata: {
    name: values.name,
    labels: {
      app: values.name
    },
  },
  spec: {
    type: values.serviceType,
    ports: [
      {
        name: "http",
        port: 80,
        targetPort: "http",
      },
    ],
    selector: {
      app: values.name
    },
  },
}
