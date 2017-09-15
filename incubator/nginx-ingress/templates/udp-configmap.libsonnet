local values = import "../values.libsonnet";

if "udp" in values then {
  apiVersion: "v1",
  kind: "ConfigMap",
  metadata: {
    labels: {
      app: values.name,
      component: values.controller.name,
    },
    name: "%s-udp" % values.fullname,
  },
  data: values.udp,
}
