local values = import "values.libsonnet";
local redis = import "redis.libsonnet";
local util = import "../util.libsonnet";

if values.usePassword
then {
  apiVersion: "v1",
  kind: "Secret",
  metadata: {
    name: redis.fullname,
    namespace: values.namespace,
    labels: {
      app: redis.fullname
    },
  },
  type: "Opaque",
  data: {
    "redis-password":
      if "redisPassword" in values
      then std.base64(values.redisPassword)
      else error "Password is required"
  }
} else {}
