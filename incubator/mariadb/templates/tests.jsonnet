local values = import "../values.libsonnet";

{
  apiVersion: "v1",
  kind: "ConfigMap",
  metadata: {
    name: "%s-tests" % values.fullname,
  },
  data: {
    "run.sh": |||
      @test "Testing MariaDB is accessible" {
        mysql -h {{ template "fullname" . }} {{- if .Values.usePassword }} -p$MARIADB_ROOT_PASSWORD{{ end }} -e 'show databases;'
      }
|||
  },
}
