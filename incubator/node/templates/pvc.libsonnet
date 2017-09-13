local values = import "../values.libsonnet";

if values.persistence.enabled
then {
  kind: "PersistentVolumeClaim",
  apiVersion: "v1",
  metadata: {
    name: values.name,
    labels: {
      app: values.name,
    },
    annotations:
      if values.persistence.storageClass
      then {
        "volume.beta.kubernetes.io/storage-class": values.persistence.storageClass
      } else {
        "volume.alpha.kubernetes.io/storage-class": "default",
      },
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
  },
} else {}
