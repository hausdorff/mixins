{
  name:: "apache-app",

  // Bitnami Apache image version
  // ref: https://hub.docker.com/r/bitnami/apache/tags/
  //
  imageTag:: "2.4.23-r12",

  // Specify a imagePullPolicy
  // ref: http://kubernetes.io/docs/user-guide/images/#pre-pulling-images
  //
  imagePullPolicy:: "IfNotPresent",
}