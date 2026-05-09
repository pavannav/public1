# Session 29: Gateway API Advanced Features

## Table of Contents
- [Gateway API Weighted Routing](#gateway-api-weighted-routing)
- [Node Affinity and Anti-Affinity](#node-affinity-and-anti-affinity)
- [ConfigMap and Secret](#configmap-and-secret)

## Gateway API Weighted Routing

### Overview
The Gateway API provides advanced traffic management capabilities beyond basic Ingress functionality. Weighted routing allows you to distribute traffic across different versions or services based on customizable percentages. This enables seamless implementation of deployment strategies like canary deployments and A/B testing in Kubernetes environments.

### Key Concepts & Deep Dive

#### Enabling Gateway API in GKE
Gateway API support is not enabled by default in GKE clusters. You must explicitly enable it during cluster creation or update existing clusters:

```bash
# Enable during creation
gcloud container clusters create CLUSTER_NAME \
  --enable-addons Gateway

# Enable on existing cluster
gcloud container clusters update CLUSTER_NAME \
  --enable-addons Gateway
```

Verify Gateway API installation:
```bash
kubectl get gateway
kubectl get httproutes
```

#### Gateway Class Selection
For external load balancing with GKE, use the `gke-l7-global-external-managed` GatewayClass:

```yaml
apiVersion: gateway.networking.k8s.io/v1beta1
kind: Gateway
metadata:
  name: my-gateway
spec:
  gatewayClassName: gke-l7-global-external-managed
  listeners:
  - name: http
    hostname: "*.example.com"
    port: 80
    protocol: HTTP
```

This creates a Layer 7 global external load balancer automatically provisioned by GKE.

#### HTTP Route with Weighted Backends
Weighted routing distributes traffic across multiple services using weight percentages:

```yaml
apiVersion: gateway.networking.k8s.io/v1beta1
kind: HTTPRoute
metadata:
  name: http-route-weighted
spec:
  parentRefs:
  - kind: Gateway
    name: my-gateway
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /hello
    backendRefs:
    - name: hello-service-v1
      port: 8080
      weight: 70
    - name: hello-service-v2
      port: 8080
      weight: 30
  - matches:
    - path:
        type: PathPrefix
        value: /zone-printer
    backendRefs:
    - name: zone-printer-service
      port: 8080
      weight: 100
```

Weights represent percentage distribution (must sum to 100) and enable traffic splitting between versions.

#### Deployment Strategies

##### Canary Deployment
Route small percentage of traffic to new version for testing:

```yaml
backendRefs:
- name: stable-service
  port: 8080
  weight: 99
- name: canary-service
  port: 8080
  weight: 1
```

##### A/B Testing
Equal distribution for comparative analysis:

```yaml
backendRefs:
- name: version-a
  port: 8080
  weight: 50
- name: version-b
  port: 8080
  weight: 50
```

#### Monitoring Traffic Distribution
Track routing behavior using curl with timing:

```bash
# Continuous monitoring
watch -n1 'curl -s http://LOAD_BALANCER_IP/hello'

# Or in loop
for i in {1..10}; do curl -s http://LOAD_BALANCER_IP/hello; echo; done
```

#### Internal Load Balancing
For internal-only access, use the `gke-l7-global-internal-managed` GatewayClass, which requires a proxy-only subnet configuration:

```yaml
apiVersion: gateway.networking.k8s.io/v1beta1
kind: Gateway
metadata:
  name: internal-gateway
spec:
  gatewayClassName: gke-l7-global-internal-managed
  # Additional subnet configuration required
```

#### Comparison: Gateway API vs Ingress

| Feature | Gateway API | Ingress |
|---------|-------------|---------|
| Weighted routing | Native support | Requires multiple Ingress objects |
| Multiple services per route | Easy with weights | Complex annotations |
| Traffic splitting | Built-in | Manual configuration |
| Setup complexity | Simple YAML | Canary requires detailed config |

> [!IMPORTANT]
> Gateway API weighted routing provides native support for modern deployment patterns like canary and A/B testing, making it simpler than traditional Ingress approaches.

> [!NOTE]
> The Gateway API takes approximately 5 minutes to provision in GKE due to load balancer creation.

## Node Affinity and Anti-Affinity

### Overview
Kubernetes scheduling decisions are typically automated, but node affinity provides explicit control over pod placement. Unlike basic node selectors, affinity offers more sophisticated matching criteria including preferences, ranges, and anti-affinity rules to avoid specific nodes or configurations.

### Key Concepts & Deep Dive

#### Understanding Default Scheduling
By default, Kubernetes distributes pods across available nodes for high availability. However, production environments often require specific scheduling constraints for:

- Workload isolation (separating high-CPU from low-CPU workloads)
- Hardware requirements (GPU-only nodes)
- Business logic (multi-tenant environments)
- Cost optimization (placing workloads on appropriate instance types)

#### Node Selector
The most basic approach uses labels for exact matching:

```yaml
# Select nodes with specific label
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      nodeSelector:
        node-type: high-memory
      containers:
      - name: app-container
        image: nginx
```

> [!WARNING]
> Hard-coded node names create inflexible deployments. Avoid using `nodeSelector` with specific node names as they break with node replacement or autoscaling.

#### Node Affinity
Provides sophisticated scheduling control with operators and preference levels:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: affinity-example
spec:
  template:
    spec:
      affinity:
        nodeAffinity:
          # Required rules (hard requirements)
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: node-type
                operator: In
                values:
                - "high-cpu"
                - "gpu-enabled"
              - key: zone
                operator: NotIn
                values:
                - "us-central1-f"
          # Preferred rules (soft preferences)
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 80
            preference:
              matchExpressions:
              - key: instance-type
                operator: In
                values:
                - "n2-standard-4"
```

Operators include: `In`, `NotIn`, `Exists`, `DoesNotExist`, `Gt`, `Lt`.

> [!NOTE]
> Anti-affinity uses `NotIn` or `DoesNotExist` operators to prevent scheduling on specific nodes or node types.

#### Taints and Tolerations
Create repellent node constraints requiring special permissions:

```bash
# Taint a node
kubectl taint nodes NODE_NAME key=value:effect

# Effects:
# NoSchedule: New pods cannot schedule, existing pods remain
# NoExecute: Evicts existing pods, prevents new scheduling
# PreferNoSchedule: Soft preference to avoid scheduling
```

Matching toleration in pod spec:

```yaml
spec:
  tolerations:
  - key: "key"
    operator: "Equal"
    value: "value"
    effect: "NoSchedule"
```

#### Combination Example
Reserve high-performance nodes for ML workloads:

```yaml
# Taint high-performance nodes
kubectl taint nodes high-perf-node dedicated=ml:NoSchedule

# Pod with affinity and toleration
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ml-workload
spec:
  template:
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: machine-type
                operator: In
                values:
              - n2-standard-8
      tolerations:
      - key: dedicated
        operator: Equal
        value: ml
        effect: NoSchedule
      containers:
      - name: ml-container
        image: tensorflow/tensorflow
        resources:
          limits:
            nvidia.com/gpu: 1
```

#### Label Management
Create meaningful node labels for effective affinity:

```bash
# Label nodes
kubectl label nodes node-1 instance-type=compute-optimized
kubectl label nodes node-1 team=ml-team

# View labels
kubectl get nodes --show-labels
```

#### Pod Anti-Affinity
Prevent co-location of pods on same node:

```yaml
spec:
  affinity:
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchLabels:
            app: web-server
        topologyKey: kubernetes.io/hostname
```

## ConfigMap and Secret

### Overview
Kubernetes ConfigMaps and Secrets enable secure configuration management for applications running in pods. ConfigMaps store non-sensitive configuration data, while Secrets handle sensitive information like passwords and tokens. These resources can be consumed as environment variables or mounted volumes.

### Key Concepts & Deep Dive

#### ConfigMap
Stores non-confidential configuration data:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  log-level: "ERROR"
  app-color: "blue"
  database-url: "mysql://db-service:3306/myapp"
```

##### Imperative Creation
```bash
kubectl create configmap my-config \
  --from-literal=key1=value1 \
  --from-literal=key2=value2 \
  --from-file=config.properties
```

##### Declarative Creation
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  config.json: |
    {
      "database": {
        "host": "mysql-service",
        "port": 3306
      }
    }
```

#### Environment Variable Consumption

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: php-app
spec:
  template:
    spec:
      containers:
      - name: php
        image: php:8.1-apache
        env:
        - name: LOG_LEVEL
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: log-level
        - name: DB_HOST
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: database-url
```

#### Secrets
Securely store sensitive data using base64 encoding:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-secret
type: Opaque
data:
  password: bXlzcWxfcGFzcw==  # base64 encoded "mysql_pass"
  username: cm9vdA==          # base64 encoded "root"
```

##### Base64 Encoding
Always encode sensitive values:
```bash
echo -n "sensitive-data" | base64
echo -n "bXlzcWxfcGFzcw==" | base64 -d
```

> [!WARNING]
> Use base64 encoding for secrets. Never use `stringData` in production as it stores plaintext values.

##### Secret Types
- **Opaque**: Generic secrets (default)
- **kubernetes.io/dockerconfigjson**: Docker registry authentication
- **kubernetes.io/tls**: TLS certificates

##### Docker Registry Secret
```yaml
kubectl create secret docker-registry my-registry-secret \
  --docker-server=https://index.docker.io/v1/ \
  --docker-username=myuser \
  --docker-password=mypass \
  --docker-email=myemail@example.com
```

#### Volume Mounting
Mount ConfigMaps/Secrets as files:

```yaml
apiVersion: apps/v1
kind: Pod
metadata:
  name: config-pod
spec:
  containers:
  - name: app
    image: nginx
    volumeMounts:
    - name: config-volume
      mountPath: /etc/config
      readOnly: true
  volumes:
  - name: config-volume
    configMap:
      name: app-config
  - name: secret-volume
    secret:
      secretName: db-secret
```

#### Real-world Application Example

```yaml
# ConfigMap for non-sensitive config
apiVersion: v1
kind: ConfigMap
metadata:
  name: php-app-config
data:
  app_env: "production"
  max_connections: "100"

---
# Secret for sensitive data
apiVersion: v1
kind: Secret
metadata:
  name: php-db-secret
type: Opaque
data:
  db_password: cGFzc3dvcmQ=  # base64 encoded
  db_username: dXNlcg==      # base64 encoded

---
# Deployment using both
apiVersion: apps/v1
kind: Deployment
metadata:
  name: php-app
spec:
  template:
    spec:
      containers:
      - name: php
        image: php:8.1-fpm
        env:
        - name: APP_ENV
          valueFrom:
            configMapKeyRef:
              name: php-app-config
              key: app_env
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: php-db-secret
              key: db_password
```

#### Best Practices

> [!IMPORTANT]
> Use Secrets for sensitive data and ConfigMaps for non-sensitive configuration to maintain security boundaries.

> [!WARNING]
> Secrets are base64 encoded, not encrypted. Use additional security measures like encryption at rest and proper RBAC.

## Summary

### Key Takeaways
```diff
+ Gateway API provides native weighted routing for canary deployments and A/B testing
+ Node affinity enables sophisticated pod scheduling based on labels and operators
+ Taints and tolerations create exclusive node reservations for specialized workloads
+ ConfigMaps handle non-sensitive configuration as environment variables or mounted files
+ Secrets store sensitive data using base64 encoding with volume mounting support
+ Use requiredDuringSchedulingIgnoredDuringExecution for hard constraints and preferredDuringSchedulingIgnoredDuringExecution for soft preferences
```

### Quick Reference
**Gateway API Commands:**
```bash
gcloud container clusters update CLUSTER_NAME --enable-addons Gateway
kubectl create -f gateway.yaml -f httproute.yaml
watch -n1 'curl http://LOAD_BALANCER_IP/endpoint'
```

**Node Affinity Operators:**
| Operator | Description | Example |
|----------|-------------|---------|
| `In` | Match any value in list | `node-type In (high-cpu, gpu)` |
| `NotIn` | Exclude values in list | `zone NotIn (us-central1-f)` |
| `Exists` | Key must exist | `node-label Exists` |
| `DoesNotExist` | Key must not exist | `temporary-label DoesNotExist` |

**ConfigMap/Secret Creation:**
```bash
kubectl create configmap my-config --from-literal=key=value
kubectl create secret generic my-secret --from-literal=key=base64value
echo -n "sensitive" | base64  # Manual encoding
```

### Expert Insight

#### Real-world Application
In production microservices, Gateway API weighted routing enables zero-downtime deployments by gradually shifting traffic from v1 to v2 services. Node affinity ensures GPU-intensive ML workloads run on appropriate hardware while preventing resource contention. ConfigMaps and Secrets allow dynamic application configuration without container rebuilds, supporting multi-environment deployments.

#### Expert Path
Master advanced scheduling by combining affinity rules with resource requests and limits. Learn ResourceQuota and LimitRange objects to prevent resource starvation. Study workload identity federation for secure secret-less authentication to cloud services.

#### Common Pitfalls
```diff
- Hard-coding node names in nodeSelector breaks with autoscaling
- Using stringData for secrets exposes plaintext in YAML
- Not using -n flag with base64 encoding adds unwanted newlines
- Over-reliance on NoExecute taints without proper toleration management
```

#### Lesser-Known Facts
Gateway API supports HTTP/2 and gRPC routing natively, while node affinity can use custom labels for complex business logic like tenant isolation. Secrets support atomic updates, but ConfigMaps require pod restart for changes to take effect when used as environment variables. Taint effects include a fourth "PreferNoSchedule" level for softer constraints.
