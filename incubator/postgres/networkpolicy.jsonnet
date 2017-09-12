local values = import "values.libsonnet";
local postgresql = import "postgresql.libsonnet";
local util = import "../util.libsonnet";

if values.networkPolicy.enabled
then {
  kind: "NetworkPolicy",
  apiVersion: "networking.k8s.io/v1",
  metadata: {
    name: postgresql.fullname,
    namespace: values.namespace,
    labels: {
      app: postgresql.fullname,
    }
  },
  spec: {
    podSelector: {
      matchLabels: {
        app: postgresql.fullname
      }
    },
    ingress: [
      {
      # Allow inbound connections
        ports: [
          {port: 5432},
        ],
        [if values.networkPolicy.allowExternal then "from"]: [
          {
            podSelector: {
              matchLabels: {
                [postgresql.fullname + "-client"]: "true",
              },
            },
          },
        ],
      },
      {
      # Allow prometheus scrapes
        ports: [
          {port: 9187},
        ]
      }
    ],
  }
} else {}
