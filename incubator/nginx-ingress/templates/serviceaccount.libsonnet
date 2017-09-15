local values = import "../values.libsonnet";

if values.rbac.create then {
  apiVersion: "v1",
  kind: "ServiceAccount",
  metadata: {
    labels: {
      app: values.name,
    },
    name: values.fullname,
  },
} else {}
