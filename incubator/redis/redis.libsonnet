local k = import "k.libsonnet";
local deployment = k.extensions.v1beta1.deployment;
local container = deployment.mixin.spec.template.spec.containersType;

{
  parts:: {
    deployment:: {
      local defaults = {
        name:: "redis",
        image:: "bitnami/redis:3.2.9-r2",
        imagePullPolicy:: "IfNotPresent",
        resources:: {
          requests: {
            memory: "256Mi",
            cpu: "100m",
          }
        },

        dataMount:: {
          name: "redis-data",
          mountPath: "/bitnami/redis",
        },
      },

      persistent(namespace, claimName=defaults.name)::
        local volume = {
          name: "redis-data",
          persistentVolumeClaim: {
            claimName: claimName,
          }
        };
        base(namespace) +
        deployment.mixin.spec.template.spec.volumes(volume) +
        deployment.mapContainersWithName(
          [defaults.name],
          function(c) c + container.volumeMounts(defaults.dataMount)
        ),

      nonPersistent(namespace)::
        local volume = {
          name: "redis-data",
          emptyDir: {}
        };
        base(namespace) +
        deployment.mixin.spec.template.spec.volumes(volume) +
        deployment.mapContainersWithName(
          [defaults.name],
          function(c) c + container.volumeMounts(defaults.dataMount)
        ),

      local base(namespace) = {
        apiVersion: "extensions/v1beta1",
        kind: "Deployment",
        metadata: {
          name: defaults.name,
          namespace: defaults.namespace,
          labels: {
            app: defaults.name,
          },
        },
        spec: {
          template: {
            metadata: {
              labels: {
                app: defaults.name,
              }
            },
            spec: {
              // nodeSelector: values.nodeSelector,
              // tolerations: values.tolerations,
              containers: [
                {
                  name: defaults.name,
                  image: defaults.image,
                  imagePullPolicy: defaults.imagePullPolicy,
                  // args: values.args,
                  // env: [
                  //   if values.usePassword then {
                  //     name: "REDIS_PASSWORD",
                  //     valueFrom: {
                  //       secretKeyRef: {
                  //         name: defaults.name,
                  //         key: "redis-password",
                  //       },
                  //     }
                  //   }
                  //   else {
                  //     name: "ALLOW_EMPTY_PASSWORD",
                  //     value: "yes",
                  //   },
                  // ],
                  ports: [
                    {
                      name: "redis",
                      containerPort: 6379,
                    },
                  ],
                  livenessProbe: {
                    exec: {
                      command: [
                        "redis-cli",
                        "ping",
                      ],
                    },
                    initialDelaySeconds: 30,
                    timeoutSeconds: 5,
                  },
                  readinessProbe: {
                    exec: {
                      command: [
                        "redis-cli",
                        "ping",
                      ],
                    },
                    initialDelaySeconds: 5,
                    timeoutSeconds: 1,
                  },
                  resources: defaults.resources,
                },
              ]
              // + if !values.metrics.enabled then []
              // else [
              //   {
              //     name: "metrics",
              //     image: values.metrics.image + ':' + values.metrics.imageTag,
              //     imagePullPolicy: values.metrics.imagePullPolicy,
              //     env: [
              //       {
              //         name: "REDIS_ALIAS",
              //         value: defaults.name,
              //       }
              //     ] + if !values.usePassword then []
              //     else [
              //       {
              //         name: "REDIS_PASSWORD",
              //         valueFrom: {
              //           secretKeyRef: {
              //             name: defaults.name,
              //             key: "redis-password",
              //           }
              //         },
              //       },
              //     ],
              //     ports: [
              //       {
              //         name: "metrics",
              //         containerPort: 9121,
              //       }
              //     ],
              //     resources: values.metrics.resources,
              //   }
              // ],
            }
          }
        }
      }
    }
  },
}
