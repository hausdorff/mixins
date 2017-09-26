local values = import "../values.libsonnet";

if values.persistence.enabled then {
  kind: "PersistentVolumeClaim",
  apiVersion: "v1",
  metadata: {
    name: values.mongodb.fullname,
  },
  spec: {
    accessModes: [
      values.persistence.accessMode,
    ],
    resources: {
      requests: {
        storage: values.persistence.size,
      },
    },
    [if "storageClass" in values.persistence then "storageClassName"]:
      if values.persistence.storageClass == "-"
      then ""
      else values.persistence.storageClass,
  },
} else {}
