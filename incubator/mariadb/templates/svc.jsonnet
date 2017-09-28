local values = import "../values.libsonnet";

{
  apiVersion: "v1",
  kind: "Service",
  metadata: {
    name: values.fullname,
    labels: {
      app: values.fullname
    },
    [if "enabled" in values.metrics then "annotations"]: values.metrics.annotations,
  },
  spec: {
    type: values.serviceType,
    ports: [
      {
        name: "mysql",
        port: 3306,
        targetPort: "mysql",
      },
    ] + if "enabled" in values.metrics then [
      {
        name: "metrics",
        port: 9104,
        targetPort: "metrics",
      },
    ] else [],
    selector: {
      app: values.fullname,
    },
  },
}
