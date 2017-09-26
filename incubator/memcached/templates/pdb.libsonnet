local values = import "../values.libsonnet";

{
  apiVersion: "policy/v1beta1",
  kind: "PodDisruptionBudget",
  metadata: {
    name: values.fullname,
  },
  spec: {
    selector: {
      matchLabels: {
        app: values.fullname
      },
    },
    minAvailable: values.pdbMinAvailable,
  },
}
