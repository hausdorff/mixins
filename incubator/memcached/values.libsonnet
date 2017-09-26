{
  fullname: "memcached",

  ## Memcached image and tag
  ## ref: https://hub.docker.com/r/library/memcached/tags/
  ##
  image: "memcached:1.4.36-alpine",

  ## Specify a imagePullPolicy
  ## 'Always' if imageTag is 'latest', else set to 'IfNotPresent'
  ## ref: http://kubernetes.io/docs/user-guide/images/#pre-pulling-images
  ##
  # imagePullPolicy:
  #

  ##Replica count
  replicaCount: 3,

  ##Pod disruption budget minAvailable count
  pdbMinAvailable: 3,

  ## Select AnitAffinity as either hard or soft, default is hard
  antiAffinity: "hard",

  memcached: {
    ## Various values that get set as command-line flags.
    ## ref: https://github.com/memcached/memcached/wiki/ConfiguringServer#commandline-arguments
    ##
    maxItemMemory: 64,
    verbosity: "v",
    extendedOptions: "modern",
  },

  ## Configure resource requests and limits
  ## ref: http://kubernetes.io/docs/user-guide/compute-resources/
  ##
  resources: {
    requests: {
      memory: "64Mi",
      cpu: "50m",
    },
  },
}
