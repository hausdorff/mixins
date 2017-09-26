local values = import "../values.libsonnet";

{
  apiVersion: "v1",
  kind: "Service",
  metadata: {
    name: values.fullname,
    labels: {
      app: values.fullname
    },
  },
  spec: {
    clusterIP: "None",
    ports: [
      {
        name: "memcache",
        port: 11211,
        targetPort: "memcache",
      },
    ],
    selector: {
      app: values.fullname,
    },
  },
}
