local values = import "../values.libsonnet";

{
  apiVersion: "v1",
  kind: "Secret",
  metadata: {
    name: values.fullname,
    labels: {
      app: values.fullname
    },
  },
  type: "Opaque",
  data: {
    "mysql-root-password": std.base64(values.mysqlRootPassword),
    "mysql-password":  std.base64(values.mysqlPassword),
  },
}
