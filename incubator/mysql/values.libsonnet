{
  fullname: "mysql",

  ## mysql image version
  ## ref: https://hub.docker.com/r/library/mysql/tags/
  ##
  image: "mysql",
  imageTag: "5.7.14",

  ## Specify password for root user
  ##
  ## Default: random 10 character string
  # mysqlRootPassword: testing

  ## Create a database user
  ##
  # mysqlUser:
  mysqlPassword: "foo",

  mysqlRootPassword: "bar",

  ## Allow unauthenticated access, uncomment to enable
  ##
  # mysqlAllowEmptyPassword: true

  ## Create a database
  ##
  # mysqlDatabase:

  ## Specify an imagePullPolicy (Required)
  ## It's recommended to change this to 'Always' if the image tag is 'latest'
  ## ref: http://kubernetes.io/docs/user-guide/images/#updating-images
  ##
  imagePullPolicy: "IfNotPresent",

  ## Persist data to a persitent volume
  persistence: {
    enabled: true,
    ## database data Persistent Volume Storage Class
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

  # Custom mysql configuration files used to override default mysql settings
  # configurationFiles:
  #   mysql.cnf: |-
  #     [mysqld]
  #     skip-name-resolve
}
