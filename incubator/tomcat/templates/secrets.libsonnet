local values = import "../values.libsonnet";

{
  apiVersion: "v1",
  kind: "Secret",
  metadata: {
    name: values.name,
    labels: {
      app: values.name
    },
  },
  type: "Opaque",
  data:
    if "tomcatPassword" in values then {
      "tomcat-password": std.base64(values.tomcatPassword)
    } else error "Please set password"
}
