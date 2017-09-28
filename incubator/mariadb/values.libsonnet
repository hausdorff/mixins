{
  fullname: "mariadb-app",

  ## Bitnami MariaDB image version
  ## ref: https://hub.docker.com/r/bitnami/mariadb/tags/
  ##
  ## Default: none
  image: "bitnami/mariadb:10.1.26-r2",

  ## Specify an imagePullPolicy (Required)
  ## It's recommended to change this to 'Always' if the image tag is 'latest'
  ## ref: http://kubernetes.io/docs/user-guide/images/#updating-images
  imagePullPolicy: "IfNotPresent",

  ## Use password authentication
  usePassword: true,

  ## Specify password for root user
  ## Defaults to a random 10-character alphanumeric string if not set and usePassword is true
  ## ref: https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#setting-the-root-password-on-first-run
  ##
  mariadbRootPassword: "alsoboots",

  ## Create a database user
  ## Password defaults to a random 10-character alphanumeric string if not set and usePassword is true
  ## ref: https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#creating-a-database-user-on-first-run
  ##
  # mariadbUser:
  mariadbPassword: "boots",

  ## Create a database
  ## ref: https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#creating-a-database-on-first-run
  ##
  # mariadbDatabase:


  ## Kubernetes service type
  serviceType: "ClusterIP",

  ## Enable persistence using Persistent Volume Claims
  ## ref: http://kubernetes.io/docs/user-guide/persistent-volumes/
  ##
  persistence: {
    enabled: true,

    ## A manually managed Persistent Volume and Claim
    ## Requires persistence.enabled: true
    ## If defined, PVC must be created manually before volume will be bound
    # existingClaim:

    ## mariadb data Persistent Volume Storage Class
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

  ## Configure MariaDB with a custom my.cnf file
  ## ref: https://mariadb.com/kb/en/mariadb/configuring-mariadb-with-mycnf/#example-of-configuration-file
  ##
  config: |||
    [mysqld]
    innodb_buffer_pool_size=2G
|||,

  metrics: {
    enabled: false,
    image: "prom/mysqld-exporter",
    imageTag: "v0.10.0",
    imagePullPolicy: "IfNotPresent",
    resources: {},
    annotations: {
      "prometheus.io/scrape": "true",
      "prometheus.io/port": "9104",
    },
  },

  ## Configure resource requests and limits
  ## ref: http://kubernetes.io/docs/user-guide/compute-resources/
  ##
  resources: {
    requests: {
      memory: "256Mi",
      cpu: "250m",
    },
  },
}
