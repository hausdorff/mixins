local values = import "values.libsonnet";
local postgresql = import "postgresql.libsonnet";
local util = import "../util.libsonnet";

if values.persistence.enabled && !("existingClaim" in values.persistence)
then {
  kind: "PersistentVolumeClaim",
  apiVersion: "v1",
  metadata: {
    name: postgresql.fullname,
    namespace: values.namespace,
    labels: {
      app: postgresql.fullname
    },
  },
  spec: {
    accessModes: [
      values.persistence.accessMode
    ],
    resources: {
      requests: {
        storage: values.persistence.size,
      },
      [if "storageClass" in values.persistence then "storageClassName"]:
        if values.persistence.storageClass == "-"
        then ""
        else values.persistence.storageClass,
    }
  }
} else {}
