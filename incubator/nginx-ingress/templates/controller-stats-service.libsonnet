local values = import "../values.libsonnet";

if values.controller.stats.enabled
then {
  apiVersion: "v1",
  kind: "Service",
  metadata: {
    annotations: values.controller.stats.service.annotations,
    labels: {
      app: values.name,
      component: values.controller.name,
    },
    name: "%s-stats" % values.controller.fullname,
  },
  spec: {
    clusterIP: values.controller.stats.service.clusterIP,
    externalIPs: values.controller.stats.service.externalIPs,
    loadBalancerIP: values.controller.stats.service.loadBalancerIP,
    loadBalancerSourceRanges: values.controller.stats.service.loadBalancerSourceRanges,
    ports: [
      {
        name: "stats",
        port: values.controller.stats.service.servicePort,
        targetPort: 18080,
      },
    ],
    selector: {
      app: values.name,
      component: values.controller.name,
      release: values.release.name,
    },
    type: values.controller.stats.service.type,
  },
} else {}
