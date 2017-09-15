local values = import "../values.libsonnet";

if values.rbac.create then {
  apiVersion: "rbac.authorization.k8s.io/v1beta1",
  kind: "ClusterRoleBinding",
  metadata: {
    labels: {
      app: values.name,
    },
    name: values.fullname,
  },
  roleRef: {
    apiGroup: "rbac.authorization.k8s.io",
    kind: "ClusterRole",
    name: values.fullNname,
  },
  subjects: [
    {
      kind: "ServiceAccount",
      name: values.fullname,
      namespace: values.releaseNamespace,
    },
  ],
}
