local values = import "../values.libsonnet";

{
  apiVersion: "v1",
  kind: "Secret",
  metadata: {
    name: values.mongodb.fullname,
    labels: {
      app: values.mongodb.fullname
    },
  },
  type: "Opaque",
  data: {
    "mongodb-root-password": std.base64(values.mongodbRootPassword),
    "mongodb-password": std.base64(values.mongodbPassword)
  },
}
