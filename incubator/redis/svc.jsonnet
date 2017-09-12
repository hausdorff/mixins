local values = import "values.libsonnet";
local redis = import "redis.libsonnet";
local util = import "../util.libsonnet";

{
  apiVersion: "v1",
  kind: "Service",
  metadata: {
    name: redis.fullname,
    namespace: values.namespace,
    labels: {
      app: redis.fullname,
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
      app: redis.fullname,
    },
  }
}