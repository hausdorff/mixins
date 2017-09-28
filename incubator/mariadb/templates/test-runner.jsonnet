local values = import "../values.libsonnet";

{
  apiVersion: "v1",
  kind: "Pod",
  metadata: {
    name: "%s-test-%s" % [values.fullname, "randomNumber"],
    annotations: {
      "helm.sh/hook": "test-success",
    },
  },
  spec: {
    initContainers: [
      {
        name: "test-framework",
        image: "dduportal/bats:0.4.0",
        command: [
          "bash",
          "-c",
          |||
          set -ex
          # copy bats to tools dir
          cp -R /usr/local/libexec/ /tools/bats/
|||
        ],
        volumeMounts: [
          {
            mountPath: "/tools",
            name: "tools",
          },
        ],
      },
    ],
    containers: [
      {
        name: "mariadb-test",
        image: values.image,
        command: ["/tools/bats/bats", "-t", "/tests/run.sh"],
        [if values.usePassword then "env"]: [
          {
            name: "MARIADB_ROOT_PASSWORD",
            valueFrom: {
              secretKeyRef: {
                name: values.fullname,
                key: "mariadb-s-password",
              },
            },
          },
        ],
        volumeMounts: [
          {
            mountPath: "/tests",
            name: "tests",
            readOnly: true,
          },
          {
            mountPath: "/tools",
            name: "tools",
          },
        ],
      },
    ],
    volumes: [
      {
        name: "tests",
        configMap: {
          name: "%s-tests" % values.fullname,
        },
      },
      {
        name: "tools",
        emptyDir: {},
      },
    ],
    restartPolicy: "Never",
  },
}
