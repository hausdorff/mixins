local values = import "../values.libsonnet";

{
  apiVersion: "v1",
  kind: "Service",
  metadata: {
    annotations: values.controller.service.annotations,
    labels: {
      app: values.name,
      component: values.controller.name,
    },
    name: values.controller.fullname,
  },
  spec: {
    clusterIP: values.controller.service.clusterIP,
    externalIPs: values.controller.service.externalIPs,
    loadBalancerIP: values.controller.service.loadBalancerIP,
    loadBalancerSourceRanges: values.controller.service.loadBalancerSourceRanges,
  // {{- if and (ge .Capabilities.KubeVersion.Minor "7") (.Values.controller.service.externalTrafficPolicy) }}
  //   externalTrafficPolicy: "{{ .Values.controller.service.externalTrafficPolicy }}"
  // {{- end }}
  // {{- if and (ge .Capabilities.KubeVersion.Minor "7") (.Values.controller.service.healthCheckNodePort) }}
  //   healthCheckNodePort: {{ .Values.controller.service.healthCheckNodePort }}
  // {{- end }}
    ports: [
      {
        name: "http",
        port: 80,
        protocol: "TCP",
        targetPort: values.controller.service.targetPorts.http,
      } +
        if values.controller.service.type == "NodePort" && values.controller.service.nodePorts.http != ""
        then {nodePort: values.controller.service.nodePorts.http}
        else {},
      {
        name: "https",
        port: 443,
        protocol: "TCP",
        targetPort: values.controller.service.targetPorts.https,
      } +
        if values.controller.service.type == "NodePort" && values.controller.service.nodePorts.https != ""
        then {nodePort: values.controller.service.nodePorts.https}
        else {},
    // {{- range $key, $value := .Values.tcp }}
    //   - name: "{{ $key }}-tcp"
    //     port: {{ $key }}
    //     protocol: TCP
    //     targetPort: {{ $key }}
    // {{- end }}
    // {{- range $key, $value := .Values.udp }}
    //   - name: "{{ $key }}-udp"
    //     port: {{ $key }}
    //     protocol: UDP
    //     targetPort: {{ $key }}
    // {{- end }}
    ],
    selector: {
      app: values.name,
      component: values.controller.name,
      release: values.release.name,
    },
    type: values.controller.service.type,
  },
}
