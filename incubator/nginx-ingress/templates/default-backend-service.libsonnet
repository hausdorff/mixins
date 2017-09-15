local values = import "../values.libsonnet";

if values.defaultBackend.enabled then {
  apiVersion: "v1",
  kind: "Service",
  metadata: {
    annotations: values.defaultBackend.service.annotations,
    labels: {
      app: values.name,
      component: values.defaultBackend.name,
    },
    name: values.defaultBackend.fullname,
  },
  spec: {
    clusterIP: values.defaultBackend.service.clusterIP,
    externalIPs: values.defaultBackend.service.externalIPs,
    loadBalancerIP: values.defaultBackend.service.loadBalancerIP,
    loadBalancerSourceRanges: values.defaultBackend.service.loadBalancerSourceRanges,
    ports: [
      {
        port: values.defaultBackend.service.servicePort,
        targetPort: 8080,
      },
    ],
    selector: {
      app: values.name,
      component: values.defaultBackend.name,
      release: values.release.name,
    },
    type: values.defaultBackend.service.type,
  },
} else {}
