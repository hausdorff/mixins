local values = import "values.libsonnet";
local util = import "../util.libsonnet";

{
  apiVersion: "v1",
  kind: "Service",
  metadata: {
    name: values.fullname,
    namespace: values.namespace,
    labels: {
      app: values.fullname,
    },
  },
  [if values.metrics.enabled then "annotations"]: values.metrics.annotations,
  spec: {
    ports: [
      {
        name: "redis",
        port: 6379,
        targetPort: "redis",
      }
    ],
    selector: {
      app: values.fullname,
    },
  }
}