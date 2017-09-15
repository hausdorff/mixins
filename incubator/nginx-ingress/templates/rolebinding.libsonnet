local values = import "../values.libsonnet";

if values.rbac.create then {
  apiVersion: "rbac.authorization.k8s.io/v1beta1",
  kind: "RoleBinding",
  metadata: {
    labels: {
      app: values.name,
    },
    name: values.fullname,
  },
  roleRef: {
    apiGroup: "rbac.authorization.k8s.io",
    kind: "Role",
    name: values.fullname,
  },
  subjects: [
    {
      kind: "ServiceAccount",
      name: values.fullname,
      namespace: values.release.namespace,
    }
  ],
} else {}
