{{- /* Template to use for ingress load balancer  */ -}}
{{- define "templates.ingress" -}}
{{- if (.service.host) and (ne .global.environment "development") -}}
- apiVersion: networking.k8s.io/v1beta1
  kind: Ingress
  metadata:
    name: {{ .service.name }}
    annotations:
      nginx.ingress.kubernetes.io/proxy-buffer-size: "16k"
      nginx.ingress.kubernetes.io/configuration-snippet: |
        more_clear_headers "Server";
  spec:
    rules:
    - host: {{ .service.host }}
      http:
        paths:
        - backend:
            serviceName: {{ .service.name }}
            servicePort: {{ .service.ports.external }}
{{end -}}
{{end -}}

{{- /* Template to use for services  */ -}}
{{- define "templates.service" -}}
- apiVersion: v1
  kind: Service
  metadata:
    name: {{ .service.name }}
  spec:
    clusterIP: None
    ports:
    - name: http
      port: {{ .service.ports.internal }}
    selector:
      app: {{ .service.name }}
{{end -}}

{{- /* Template to use for NodePorts  */ -}}
{{- define "templates.nodeport" -}}
{{- if eq .global.environment "development" -}}
- apiVersion: v1
  kind: Service
  metadata:
    name: {{ .service.name }}-nodeport
  spec:
    ports:
    - port: {{ .service.ports.internal }}
      targetPort: {{ .service.ports.external }}
      nodePort: {{ .service.ports.node }}
    selector:
      app: {{ .service.name }}
    type: NodePort
{{end -}}
{{end -}}

{{- /* Template to use for deployments  */ -}}
{{- define "templates.deployment" -}}
- apiVersion: apps/v1
  kind: Deployment
  metadata:
    labels:
      app: {{ .service.name }}
    name: {{ .service.name }}
  spec:
    replicas: 1
    selector:
      matchLabels:
        app: {{ .service.name }}
    strategy:
      rollingUpdate:
        maxSurge: 1
        maxUnavailable: 1
      type: RollingUpdate
    template:
      metadata:
        labels:
          app: {{ .service.name }}
      spec:
        containers:
        ## TODO: Replace below with variables
        - image: {{ .service.image }}:{{ .service.version }}
          imagePullPolicy: {{ .global.pullPolicy }}
          name: {{ .service.name }}
          args: {{ .service.args }}
          env:
          {{- range .service.env }}
          - name: {{ .name }}
            value: "{{ .value }}"
          {{- end }}
          # livenessProbe:
          #   httpGet:
          #     path: /health
          #     port: 8080
          #   failureThreshold: 5
          #   initialDelaySeconds: 30
          #   periodSeconds: 30
          #   successThreshold: 1
          #   timeoutSeconds: 10
          # readinessProbe:
          #   httpGet:
          #     path: /health
          #     port: 8080
          #   failureThreshold: 5
          #   initialDelaySeconds: 10
          #   periodSeconds: 30
          #   successThreshold: 1
          #   timeoutSeconds: 10
          ports:
          - containerPort: {{ .service.ports.internal }}
          resources:
            requests:
              cpu: {{ .service.resources.cpu.request }}
              memory: {{ .service.resources.mem.request }}
            limits:
              cpu: {{ .service.resources.cpu.limit }}
              memory: {{ .service.resources.mem.limit }}
        imagePullSecrets:
        - name: {{ .global.pullSecret }}
{{end -}}
