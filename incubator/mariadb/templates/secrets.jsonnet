local values = import "../values.libsonnet";

if values.usePassword then {
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
    "mariadb-root-password":
      if "mariadbRootPassword" in values
      then std.base64(values.mariadbRootPassword)
      else error "Please add a root password",
    "mariadb-password":
      if "mariadbPassword" in values
      then std.base64(values.mariadbPassword)
      else error "Please add a password",
  },
}
