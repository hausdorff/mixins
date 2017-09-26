local values = import "../values.libsonnet";

{
  apiVersion: "apps/v1beta1",
  kind: "StatefulSet",
  metadata: {
    name: values.fullname,
    labels: {
      app: values.fullname,
    },
  },
  spec: {
    serviceName: values.fullname,
    replicas: values.replicaCount,
    template: {
      metadata: {
        labels: {
          app: values.fullname,
        },
      },
      spec: {
        affinity: {
          podAntiAffinity:
            if values.antiAffinity == "hard"
            then {
              requiredDuringSchedulingIgnoredDuringExecution: [
                {
                  topologyKey: "kubernetes.io/hostname",
                  labelSelector: {
                    matchLabels: {
                      app:  values.fullname,
                    },
                  },
                },
              ],
            } else if values.antiAffinity == "soft" then {
              preferredDuringSchedulingIgnoredDuringExecution: [
                {
                  weight: 5,
                  podAffinityTerm: [
                    {
                      topologyKey: "kubernetes.io/hostname",
                      labelSelector: {
                        matchLabels: {
                          app:  values.fullname
                        },
                      },
                    },
                  ],
                },
              ],
            } else {},
        },
        containers: [
          {
            name: values.fullname,
            image: values.image,
            [if "imagePullPolicy" in values then "imagePullPolicy"]: values.imagePullPolicy,
            command: [
              "memcached",
              "-m " + values.memcached.maxItemMemory,
            ] + if "extendedOptions" in values.memcached then [
              "-o",
              values.memcached.extendedOptions,
            ] else [] + if "verbosity" in values.memcached then [
              values.memcached.verbosity
            ] else [],
            ports: [
              {
                name: "memcache",
                containerPort: "11211",
              }
            ],
            livenessProbe: {
              tcpSocket: {
                port: "memcache",
              },
              initialDelaySeconds: 30,
              timeoutSeconds: 5,
            },
            readinessProbe: {
              tcpSocket: {
                port: "memcache",
              },
              initialDelaySeconds: 5,
              timeoutSeconds: 1,
            },
            resources: values.resources,
          },
        ],
      },
    },
  },
}
