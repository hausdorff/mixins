local values = import "../values.libsonnet";

{
  apiVersion: "v1",
  kind: "ConfigMap",
  metadata: {
    labels: {
      app: values.name,
    },
    name: values.fullname,
  },
  data: {
    "enable-vts-status": values.controller.stats.enabled,
  } + values.controller.config,
}
