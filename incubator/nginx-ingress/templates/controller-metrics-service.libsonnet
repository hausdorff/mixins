local values = import "../values.libsonnet";

if values.controller.stats.enabled then {
  apiVersion: "v1",
  kind: "Service",
  metadata: {
    annotations: values.statsExporter.service.annotations,
    labels: {
      app: values.name,
      component: values.controller.name,
    },
    name: "%s-metrics" % values.controller.fullname,
  },
  spec: {
    clusterIP: values.statsExporter.service.clusterIP,
    externalIPs: values.statsExporter.service.externalIPs,
    loadBalancerIP: values.statsExporter.service.loadBalancerIP,
    loadBalancerSourceRanges: values.statsExporter.service.loadBalancerSourceRanges,
    ports: [
      {
        name: "metrics",
        port: values.statsExporter.service.servicePort,
        targetPort: 9913,
      }
    ],
    selector: {
      app: values.name,
      component: values.controller.name,
      release: values.releaseName,
    },
    type: values.statsExporter.service.type,
  },
} else {}
