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
    type: "LoadBalancer",
    ports: [
      {
        name: "http",
        port: 80,
        targetPort: "http",
      },
      {
        name: "https",
        port: "443",
        targetPort: "https",
      },
    ],
    selector: {
      app: values.name
    }
  },
}
