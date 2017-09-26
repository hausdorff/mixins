{
  mongodb: {
    name: "mongo",
    fullname: "mongo",
  },

  ## Bitnami MongoDB image version
  ## ref: https://hub.docker.com/r/bitnami/mongodb/tags/
  ##
  image: "bitnami/mongodb:3.4.7-r0",

  ## Specify a imagePullPolicy
  ## 'Always' if imageTag is 'latest', else set to 'IfNotPresent'
  ## ref: http://kubernetes.io/docs/user-guide/images/#pre-pulling-images
  ##
  # imagePullPolicy:

  ## MongoDB admin password
  ## ref: https://github.com/bitnami/bitnami-docker-mongodb/blob/master/README.md#setting-the-root-password-on-first-run
  ##
  mongodbRootPassword: "foobar",

  ## MongoDB custom user and database
  ## ref: https://github.com/bitnami/bitnami-docker-mongodb/blob/master/README.md#creating-a-user-and-database-on-first-run
  ##
  # mongodbUsername: "foo",
  mongodbPassword: "bar",
  # mongodbDatabase:

  ## Kubernetes service type
  serviceType: "ClusterIP",

  ## Enable persistence using Persistent Volume Claims
  ## ref: http://kubernetes.io/docs/user-guide/persistent-volumes/
  ##
  persistence: {
    enabled: true,
    ## mongodb data Persistent Volume Storage Class
    ## If defined, storageClassName: <storageClass>
    ## If set to "-", storageClassName: "", which disables dynamic provisioning
    ## If undefined (the default) or set to null, no storageClassName spec is
    ##   set, choosing the default provisioner.  (gp2 on AWS, standard on
    ##   GKE, AWS & OpenStack)
    ##
    # storageClass: "-"
    accessMode: "ReadWriteOnce",
    size: "8Gi",
  },

  ## Configure resource requests and limits
  ## ref: http://kubernetes.io/docs/user-guide/compute-resources/
  ##
  resources: {
    requests: {
      memory: "256Mi",
      cpu: "100m",
    },
  },
}
