{
  namespace: "dev-alex",
  "image": "postgres",
  "imageTag": "9.6.2",
  postgresPassword: "simplePassword",
  imagePullPolicy: "Always",
  "persistence": {
    "enabled": true,
    "accessMode": "ReadWriteOnce",
    "size": "8Gi",
    "subPath": "postgresql-db"
  },
  "metrics": {
    "enabled": false,
    "image": "wrouesnel/postgres_exporter",
    "imageTag": "v0.1.1",
    "imagePullPolicy": "IfNotPresent",
    "resources": {
      "requests": {
        "memory": "256Mi",
        "cpu": "100m"
      }
    }
  },
  "resources": {
    "requests": {
      "memory": "256Mi",
      "cpu": "100m"
    }
  },
  "service": {
    "type": "ClusterIP",
    "port": 5432,
    "externalIPs": [

    ]
  },
  "networkPolicy": {
    "enabled": false,
    "allowExternal": true
  },
  "nodeSelector": {
  },
  "tolerations": [

  ]
}