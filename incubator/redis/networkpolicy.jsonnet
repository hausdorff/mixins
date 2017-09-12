local values = import "values.libsonnet";
local redis = import "redis.libsonnet";
local util = import "../util.libsonnet";

if values.networkPolicy.enabled
then {
  kind: "NetworkPolicy",
  apiVersion: "networking.k8s.io/v1",
  metadata: {
    name: redis.fullname,
    namespace: values.namespace,
    labels: {
      app: redis.fullname,
    },
  },
  spec: {
    podSelector: {
      matchLabels: {
        app: redis.fullname,
      }
    },
    ingress:
      util.concatIf(
        values.metrics.enabled,
        [
          {
            # Allow inbound connections
            ports: [
              {port: 6379}
            ],
            [if !values.networkPolicy.allowExternal then "from"]: [
              {
                podSelector: {
                  matchLabels: {
                    [redis.fullname + "-client"]: "true"
                  }
                }
              },
            ],
          }
        ],
        [
          {
            # Allow prometheus scrapes for metrics
            ports: [
              {port: 9121},
            ]
          }
        ]
      )
  },
} else {}
