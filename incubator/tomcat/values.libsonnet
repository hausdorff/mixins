{
  name: "tomcat-app",

  ## Bitnami Tomcat image version
  ## ref: https://hub.docker.com/r/bitnami/tomcat/tags/
  ##
  image: "bitnami/tomcat:8.0.46-r0",

  ## Specify a imagePullPolicy
  ## ref: http://kubernetes.io/docs/user-guide/images/#pre-pulling-images
  ##
  imagePullPolicy: "IfNotPresent",

  ## Admin user
  ## ref: https://github.com/bitnami/bitnami-docker-tomcat#creating-a-custom-user
  ##
  tomcatUsername: "user",

  ## Admin password
  ## ref: https://github.com/bitnami/bitnami-docker-tomcat#creating-a-custom-user
  ##
  tomcatPassword: "boots",

  ## Expose management services
  ## ref: https://github.com/bitnami/charts/tree/master/incubator/tomcat#configuration
  ##
  tomcatAllowRemoteManagement: 0,

  ## Kubernetes configuration
  ## For minikube, set this to NodePort, elsewhere use LoadBalancer
  ##
  serviceType: "LoadBalancer",

  ## Enable persistence using Persistent Volume Claims
  ## ref: http://kubernetes.io/docs/user-guide/persistent-volumes/
  ##
  persistence: {
    enabled: true,
    ## If defined, volume.beta.kubernetes.io/storage-class: <storageClass>
    ## Default: volume.alpha.kubernetes.io/storage-class: default
    ##
    # storageClass:
    accessMode: "ReadWriteOnce",
    size: "8Gi",
  },

  ## Configure resource requests and limits
  ## ref: http://kubernetes.io/docs/user-guide/compute-resources/
  ##
  resources: {
    requests: {
      memory: "512Mi",
      cpu: "300m",
    },
  },
}
