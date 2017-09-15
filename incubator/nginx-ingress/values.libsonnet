{
  name: "nginx-app",
  fullname: "nginx-fullname-app",
  release: {
    namespace: "dev-alex",
    name: "nginx-app",
  },

  ## nginx configuration
  ## Ref: https://github.com/kubernetes/ingress/blob/master/controllers/nginx/configuration.md
  ##
  controller: {
    name: "controller",
    fullname: "controller",
    image: {
      repository: "gcr.io/google_containers/nginx-ingress-controller",
      tag: "0.9.0-beta.12",
      pullPolicy: "IfNotPresent",
    },

    config: {},

    # Required for use with CNI based kubernetes installations (such as ones set up by kubeadm),
    # since CNI and hostport don't mix yet. Can be deprecated once https://github.com/kubernetes/kubernetes/issues/23920
    # is merged
    hostNetwork: false,

    ## Required only if defaultBackend.enabled = false
    ## Must be <namespace>/<service_name>
    ##
    defaultBackendService: "",

    ## Optionally specify the secret name for default SSL certificate
    ## Must be <namespace>/<secret_name>
    ##
    defaultSSLCertificate: "",

    ## Election ID to use for status update
    ##
    electionID: "ingress-controller-leader",

    ## Name of the ingress class to route through this controller
    ##
    ingressClass: "nginx",

    ## Allows customization of the external service
    ## the ingress will be bound to via DNS
    publishService: {
      enabled: false,
      ## Allows overriding of the publish service to bind to
      ## Must be <namespace>/<service_name>
      ##
      pathOverride: "",
    },

    ## Limit the scope of the controller
    ##
    scope: {
      enabled: false,
      namespace: "" # defaults to .Release.Namespace
    },

    extraArgs: {},

    ## DaemonSet or Deployment
    ##
    kind: "Deployment",

    ## Node tolerations for server scheduling to nodes with taints
    ## Ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/
    ##
    tolerations: [],
    #- key: "key"
    #  operator: "Equal|Exists"
    #  value: "value"
    #  effect: "NoSchedule|PreferNoSchedule|NoExecute(1.6 only)"

    ## Node labels for controller pod assignment
    ## Ref: https://kubernetes.io/docs/user-guide/node-selection/
    ##
    nodeSelector: {},

    ## Annotations to be added to controller pods
    ##
    podAnnotations: {},

    replicaCount: 1,

    resources: {},
      # limits:
      #   cpu: 100m
      #   memory: 64Mi
      # requests:
      #   cpu: 100m
      #   memory: 64Mi

    service: {
      annotations: {},
      clusterIP: "",

      ## List of IP addresses at which the controller services are available
      ## Ref: https://kubernetes.io/docs/user-guide/services/#external-ips
      ##
      externalIPs: [],

      loadBalancerIP: "",
      loadBalancerSourceRanges: [],

      ## Set external traffic policy to: "Local" to preserve source IP on
      ## providers supporting it
      ## Ref: https://kubernetes.io/docs/tutorials/services/source-ip/#source-ip-for-services-with-typeloadbalancer
      externalTrafficPolicy: "",

      healthCheckNodePort: 0,

      targetPorts: {
        http: 80,
        https: 443,
      },

      type: "LoadBalancer",

      # type: NodePort
      # nodePorts:
      #   http: 32080
      #   https: 32443
      nodePorts: {
        http: "",
        https: "",
      },
    },

    stats: {
      enabled: false,

      service: {
        annotations: {},
        clusterIP: "",

        ## List of IP addresses at which the stats service is available
        ## Ref: https://kubernetes.io/docs/user-guide/services/#external-ips
        ##
        externalIPs: [],

        loadBalancerIP: "",
        loadBalancerSourceRanges: [],
        servicePort: 18080,
        type: "ClusterIP",
      },
    },
  },

  ## Default 404 backend
  ##
  defaultBackend: {
    fullname: "nginx-app-backend",

    ## If false, controller.defaultBackendService must be provided
    ##
    enabled: true,

    name: "default-backend",
    image: {
      repository: "gcr.io/google_containers/defaultbackend",
      tag: "1.3",
      pullPolicy: "IfNotPresent",
    },

    extraArgs: {},

    ## Node tolerations for server scheduling to nodes with taints
    ## Ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/
    ##
    tolerations: [],
    #- key: "key"
    #  operator: "Equal|Exists"
    #  value: "value"
    #  effect: "NoSchedule|PreferNoSchedule|NoExecute(1.6 only)"

    ## Node labels for default backend pod assignment
    ## Ref: https://kubernetes.io/docs/user-guide/node-selection/
    ##
    nodeSelector: {},

    ## Annotations to be added to default backend pods
    ##
    podAnnotations: {},

    replicaCount: 1,

    resources: {},
      # limits:
      #   cpu: 10m
      #   memory: 20Mi
      # requests:
      #   cpu: 10m
      #   memory: 20Mi

    service: {
      annotations: {},
      clusterIP: "",

      ## List of IP addresses at which the default backend service is available
      ## Ref: https://kubernetes.io/docs/user-guide/services/#external-ips
      ##
      externalIPs: [],

      loadBalancerIP: "",
      loadBalancerSourceRanges: [],
      servicePort: 80,
      type: "ClusterIP",
    },
  },

  ## Enable RBAC as per https://github.com/kubernetes/ingress/tree/master/examples/rbac/nginx and https://github.com/kubernetes/ingress/issues/266
  rbac: {
    create: false,
    serviceAccountName: "default",
  },

  ## If controller.stats.enabled = true, Prometheus metrics will be exported
  ## Ref: https://github.com/hnlq715/nginx-vts-exporter
  ##
  statsExporter: {
    name: "stats-exporter",
    image: {
      repository: "quay.io/cy-play/vts-nginx-exporter",
      tag: "v0.0.3",
      pullPolicy: "IfNotPresent",
    },

    endpoint: "/metrics",
    extraArgs: {},
    metricsNamespace: "nginx",
    statusPage: "http://localhost:18080/nginx_status/format/json",

    resources: {},
      # limits:
      #   cpu: 10m
      #   memory: 20Mi
      # requests:
      #   cpu: 10m
      #   memory: 20Mi

    service: {
      annotations: {},
      clusterIP: "",

      ## List of IP addresses at which the stats-exporter service is available
      ## Ref: https://kubernetes.io/docs/user-guide/services/#external-ips
      ##
      externalIPs: [],

      loadBalancerIP: "",
      loadBalancerSourceRanges: [],
      servicePort: 9913,
      type: "ClusterIP",
    }
  },

  # TCP service key:value pairs
  # Ref: https://github.com/kubernetes/contrib/tree/master/ingress/controllers/nginx/examples/tcp
  ##
  // tcp: {},
    # 8080: "default/example-tcp-svc:9000"

  # UDP service key:value pairs
  # Ref: https://github.com/kubernetes/contrib/tree/master/ingress/controllers/nginx/examples/udp
  ##
  // udp: {},
    # 53: "kube-system/kube-dns:53"
}
