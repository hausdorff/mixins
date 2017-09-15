local values = import "../values.libsonnet";

if values.rbac.create then
  local controllerRbac =
    if values.controller.scope.enabled && ("namespace" in values.controller.scope) then [{
      apiGroups: [""],
      resources: ["namespaces"],
      resourceNames: [values.controller.scope.namespace],
      verbs: ["get"],
    }] else [];
  {
    apiVersion: "rbac.authorization.k8s.io/v1beta1",
    kind: "ClusterRole",
    metadata: {
      labels: {
        app: values.name,
      },
      name: values.fullname,
    },
    rules: [
      {
        apiGroups: [""],
        resources: ["configmaps", "endpoints", "nodes", "pods", "secrets"],
        verbs: ["list", "watch"],
      }
    ] + controllerRbac + [
      {
        apiGroups: [""],
        resources: ["nodes"],
        verbs: ["get"],
      },
      {
        apiGroups: [""],
        resources: ["services"],
        verbs: ["get", "list", "update", "watch"],
      },
      {
        apiGroups: ["extensions"],
        resources: ["ingresses"],
        verbs: ["get", "list", "watch"],
      },
      {
        apiGroups: [""],
        resources: ["events"],
        verbs: ["create", "patch"],
      },
      {
        apiGroups: "extensions",
        resources: ["ingresses/status"],
        verbs: ["update"],
      }
    ],
  } else {}
