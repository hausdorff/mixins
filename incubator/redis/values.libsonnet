{
  redisPassword: "foobar",
  namespace: "dev-alex",
  "image": "bitnami/redis:3.2.9-r2",
  "imagePullPolicy": "IfNotPresent",
  "usePassword": true,
  "args": null,
  "persistence": {
    // existingClaim: "someClaimNameHere",
    "enabled": true,
    "accessMode": "ReadWriteOnce",
    "size": "8Gi"
  },
  "metrics": {
    "enabled": true,
    "image": "oliver006/redis_exporter",
    "imageTag": "v0.11",
    "imagePullPolicy": "IfNotPresent",
    "resources": {
    },
    "annotations": {
      "prometheus.io/scrape": "true",
      "prometheus.io/port": "9121"
    }
  },
  "resources": {
    "requests": {
      "memory": "256Mi",
      "cpu": "100m"
    }
  },
  "nodeSelector": {
  },
  "tolerations": [
  ],
  "networkPolicy": {
    "enabled": true,
    "allowExternal": true
  }
}
