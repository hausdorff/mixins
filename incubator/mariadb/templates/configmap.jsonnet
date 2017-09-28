local values = import "../values.libsonnet";

{
  apiVersion: "v1",
  kind: "ConfigMap",
  metadata: {
    name: values.fullname,
    labels: {
      app: values.fullname,
    },
  },
  data: {
    "my.cnf": values.config,
  },
}
