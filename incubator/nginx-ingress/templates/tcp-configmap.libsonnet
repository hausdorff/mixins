local values = import "../values.libsonnet";

if "tcp" in values then {
  apiVersion: "v1",
  kind: "ConfigMap",
  metadata: {
    labels: {
      app: values.name,
      component: values.controller.name
    },
    name: "%s-tcp" % values.fullname,
  },
  data: values.tcp,
} else {}
