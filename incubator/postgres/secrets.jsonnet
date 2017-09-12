local values = import "values.libsonnet";
local postgresql = import "postgresql.libsonnet";
local util = import "../util.libsonnet";

{
  apiVersion: "v1",
  kind: "Secret",
  metadata: {
    name: postgresql.fullname,
    namespace: values.namespace,
    labels: {
      app: postgresql.fullname
    },
  },
  type: "Opaque",
  data: {
    "postgres-password":
      if "postgresPassword" in values
      then std.base64(values.postgresPassword)
      else error "Password is required",
    [if "customMetrics" in values.metrics then "custom-metrics.yaml"]:
      std.base64(values.metrics.customMetrics),
  }
}