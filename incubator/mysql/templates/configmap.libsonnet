local values = import "../values.libsonnet";

if "configurationFiles" in values then {
  apiVersion: "v1",
  kind: "ConfigMap",
  metadata: {
    name: values.fullname,
  },
  data: values.configurationFiles,
} else {}