local values = import "values.libsonnet";
local postgresql = import "postgresql.libsonnet";
local util = import "../util.libsonnet";

{
  apiVersion: "v1",
  kind: "Service",
  metadata: {
    name: postgresql.fullname,
    namespace: values.namespace,
    labels: {
      app: postgresql.fullname,
    },
    [if values.metrics.enabled then "annotations"]: {
      "prometheus.io/scrape": "true",
      "prometheus.io/port": "9187"
    },
  },
  spec: {
    type: values.service.type,
    ports: [
      {
        name: "postgresql",
        port: values.service.port,
        targetPort: "postgresql",
      }
    ],
    [if "externalIPs" in values.service then "externalIPs"]:
      values.service.externalIPs,
    selector: {
      app: postgresql.fullname
    }
  },
}