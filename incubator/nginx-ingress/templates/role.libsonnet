local values = import "../values.libsonnet";

if values.rbac.create then {
  apiVersion: "rbac.authorization.k8s.io/v1beta1",
  kind: "Role",
  metadata: {
    labels: {
      app: values.name,
    },
    name: values.fullname,
  },
  rules: [
    {
      apiGroups: [""],
      resources: ["configmaps", "namespaces", "pods", "secrets"],
      verbs: ["get"],
    },
    {
      apiGroups: [""],
      resources: ["configmaps"],
      resourceNames: ["%s-%s" % [values.controller.electionID, values.controller.ingressClass]],
      verbs: ["get", "update"]
    },
    {
      apiGroups: [""],
      resources: ["configmaps"],
      verbs: ["create"],
    },
    {
      apiGroups: [""],
      resources: ["endpoints"],
      verbs: ["create", "get", "update"],
    },
  ],
}
