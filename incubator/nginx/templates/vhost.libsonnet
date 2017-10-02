local values = import "../values.libsonnet";

if "vhost" in values then {
  apiVersion: "v1",
  kind: "ConfigMap",
  metadata: {
    name: values.fullname,
    labels: {
      app: values.fullname
    },
  },
  data: {
    "vhost.conf": values.vhost,
  },
} else {}
