# Session 28: Deep Dive into Ingress Concept, Multi Cluster Ingress (MCI), Gateway API

## Table of Contents

- [Introduction to Layer 4 vs Ingress](#introduction-to-layer-4-vs-ingress)
- [Ingress Concepts and Implementation](#ingress-concepts-and-implementation)
- [Multi-Cluster Ingress (MCI) Implementation](#multi-cluster-ingress-mci-implementation)
- [Gateway API Overview](#gateway-api-overview)
- [Service Types in Kubernetes](#service-types-in-kubernetes)

## Introduction to Layer 4 vs Ingress

### Overview

When exposing applications to the outside world, there are two primary options: **Layer 4 Load Balancer** and **Layer 7 Ingress**.

**Layer 4 Load Balancer** provides connection-level load balancing based on IP addresses and TCP/UDP ports. In Kubernetes, this is implemented using a LoadBalancer service type that creates external load balancers.

**Layer 7 Ingress** operates at the application layer and can make routing decisions based on HTTP requests (URLs, headers, etc.).

### Key Advantages of Ingress over Layer 4 Load Balancer

1. **Single IP Address**: One external IP address for multiple applications
2. **Layer 7 Load Balancing**: Intelligent routing based on HTTP content
3. **Scalability**: Easy to add new applications without creating new load balancers
4. **Cost Efficiency**: Reduces firewall rules and load balancer costs
5. **Advanced Features**: Can handle SSL termination, path-based routing, header-based routing

### Practical Demonstration Setup

We deploy three applications:
- **Hello App** (e.g., `gcr.io/google-samples/hello-app:1.0` on port 8080)
- **Zone Printer** (e.g., `gcr.io/google-samples/whereami:v1.0` on port 8080) 
- **Where Am I** (e.g., `gcr.io/google-samples/whereami:latest` on port 8080)

```bash
kubectl apply -f hello-app.yaml
kubectl apply -f zone-printer.yaml
kubectl apply -f where-am-i.yaml
```

All services initially use `type: LoadBalancer` for individual external access.

## Ingress Concepts and Implementation

### Overview

Ingress is a Kubernetes API object that manages external access to services within a cluster, typically HTTP traffic. It provides load balancing, SSL termination, and name-based virtual hosting.

### Basic Ingress Structure

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: awesome-ingress
  annotations:
    kubernetes.io/ingress.class: "gce"
spec:
  defaultBackend:
    service:
      name: hello-service
      port:
        number: 8080
  rules:
  - http:
      paths:
      - path: /zone-printer
        pathType: Prefix
        backend:
          service:
            name: zone-printer-service
            port:
              number: 8080
      - path: /where-am-i
        pathType: Prefix
        backend:
          service:
            name: where-am-i-service
            port:
              number: 8080
```

**Key Components:**
- `defaultBackend`: Handles requests without matching rules
- `rules`: HTTP rules for path-based routing
- `pathType`: Can be `Prefix`, `Exact`, or `ImplementationSpecific`
- `backend`: Points to target service and port

### Cluster IP and Ingress Flow

Switch services from `LoadBalancer` to `ClusterIP`:

```yaml
kind: Service
spec:
  type: ClusterIP  # Changed from LoadBalancer
```

**Architecture:**
```
Client Request -> Ingress IP -> Ingress Controller -> Service -> Pods
```

### Practical Implementation Steps

1. **Clean up LoadBalancers**:
   ```bash
   kubectl delete -f deployment-files.yaml
   kubectl delete -f service-files.yaml
   ```

2. **Deploy with ClusterIP**:
   ```yaml
   apiVersion: v1
   kind: Service
   spec:
     type: ClusterIP
     ports:
     - port: 8080
       targetPort: 8080
   ```

3. **Apply Ingress Manifest**:
   ```bash
   kubectl apply -f ingress.yaml
   ```

4. **Monitor Provisioning** (takes ~5+ minutes):
   ```bash
   kubectl get ingress
   kubectl describe ingress awesome-ingress
   ```

### Health Checks and Debugging

**Common Issues:**
- Health check misconfigurations
- Wrong port numbers in service/Ingress
- Firewall rules blocking traffic
- Selector mismatches in `.spec.selector`

**Debugging Steps:**
```bash
# Check load balancer health in GCP Console
# Number of healthy instances (e.g., 4 of 4)

# Verify service endpoints
kubectl get endpoints

# Check pod selectors match service
kubectl describe service <service-name>

# Test from within cluster
curl http://<service-name>.<namespace>.svc.cluster.local:<port>
```

### Scaling Applications

Add new applications by:
1. Creating deployment and service (ClusterIP)
2. Adding new rule to Ingress manifest
3. Applying changes

```yaml
# Service example
apiVersion: v1
kind: Service
metadata:
  name: new-app-service
spec:
  type: ClusterIP
  selector:
    app: new-app
  ports:
  - port: 8080
    targetPort: 8080
```

```yaml
# Add to Ingress rules
- path: /new-app
  pathType: Prefix
  backend:
    service:
      name: new-app-service
      port:
        number: 8080
```

**Generated Firewall Rules:**
- Automatically created for required ports
- Only necessary ports opened (no blanket allow-rules)

## Multi-Cluster Ingress (MCI) Implementation

### Overview

Multi-Cluster Ingress enables routing traffic across multiple Kubernetes clusters based on proximity, availability, and geographic location. This provides high availability and low-latency service delivery.

### Architecture

```
Client (e.g., from US) -> AnyCast IP -> Closest Cluster (US West)
Client (e.g., from Europe) -> AnyCast IP -> Closest Cluster (Europe West)
```

### Use Cases

1. **Global Applications**: Serve users from geographically nearest cluster
2. **High Availability**: Automatic failover if a cluster goes down
3. **Compliance**: Route EU users to EU clusters per regulations
4. **Performance**: Minimize latency by routing to closest available cluster

### Implementation Steps

#### 1. Enable Required APIs
```bash
gcloud services enable gkehub.googleapis.com
gcloud services enable multiclustermutualaccess.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable trafficdirector.googleapis.com
```

#### 2. Create Clusters
```bash
# US West cluster
gcloud container clusters create us-gke \
  --zone=us-central1-c \
  --num-nodes=2 \
  --enable-ip-alias

# Europe cluster
gcloud container clusters create eu-gke \
  --zone=europe-west1-b \
  --num-nodes=2 \
  --enable-ip-alias
```

#### 3. Register Clusters to Fleet
```bash
# Enable Fleet API
gcloud services enable gkehub.googleapis.com

# Register clusters
gcloud container hub memberships register us-gke \
  --gke-cluster=us-central1/us-central1-c/us-gke \
  --enable-workload-identity

gcloud container hub memberships register eu-gke \
  --gke-cluster=europe-west1/europe-west1-b/eu-gke \
  --enable-workload-identity
```

#### 4. Enable MCI on Target Cluster
```bash
gcloud container fleet ingress enable \
  --config-membership=projects/<PROJECT-ID>/locations/global/memberships/us-gke
```

#### 5. Deploy Applications to Both Clusters
```yaml
# Common namespace
apiVersion: v1
kind: Namespace
metadata:
  name: demo

---
# Deployment (same in both clusters)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: where-am-i
  namespace: demo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: where-am-i
  template:
    metadata:
      labels:
        app: where-am-i
    spec:
      containers:
      - name: where-am-i
        image: gcr.io/google-samples/whereami:latest
        ports:
        - containerPort: 8080

---
# MultiClusterService
apiVersion: networking.gke.io/v1
kind: MultiClusterService
metadata:
  name: where-am-i-mcs
  namespace: demo
spec:
  template:
    spec:
      selector:
        app: where-am-i
      ports:
      - name: http
        protocol: TCP
        port: 8080
        targetPort: 8080
```

#### 6. Create Multi-Cluster Ingress
```yaml
apiVersion: networking.gke.io/v1
kind: MultiClusterIngress
metadata:
  name: where-am-i-mci
  namespace: demo
spec:
  template:
    spec:
      backend:
        serviceName: where-am-i-mcs
        servicePort: 8080
```

### Traffic Routing Verification

**Test from Different Locations:**
```bash
# From Cloud Shell (Singapore)
curl https://<MCI-IP>

# From SSH to GCP instance (Belgium)
curl https://<MCI-IP>
```

**Expected Results:**
- Singapore region traffic routes to US cluster
- European traffic routes to EU cluster

### Routing Logic

1. **DNS Resolution**: AnyCast IP resolves to closest cluster
2. **Traffic Distribution**: Based on client proximity
3. **Health Monitoring**: Only routes to healthy clusters
4. **Automatic Failover**: Traffic reroutes if primary cluster unhealthy

## Gateway API Overview

### Overview

Gateway API is the successor to Ingress, providing enhanced capabilities for service networking. It offers role-based access control, advanced traffic management features, and improved portability.

### Key Differences from Ingress

| Feature | Ingress | Gateway API |
|---------|---------|-------------|
| API Status | Frozen (no new features) | Active development |
| Role Separation | Limited | Infrastructure/Admin/Developer roles |
| Portability | Kubernetes-specific | Open standard |
| Advanced Features | Limited | Traffic splitting, header matching, weights |

### Gateway API Components

1. **GatewayClass**: Defines infrastructure provider and capabilities
2. **Gateway**: Cluster-scoped resource managing infrastructure
3. **HTTPRoute/GRPCRoute/etc.**: Application-level routing configuration

### Migration: Ingress to Gateway API

**From Ingress:**
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
spec:
  rules:
  - http:
      paths:
      - path: /
        backend:
          service:
            name: site-service
            port:
              number: 8080
      - path: /shop
        backend:
          service:
            name: store-service
            port:
              number: 8080
```

**To Gateway API:**
```yaml
apiVersion: gateway.networking.k8s.io/v1beta1
kind: Gateway
metadata:
  name: external-http
spec:
  gatewayClassName: gke-l7-global-external-managed
  listeners:
  - name: http
    hostname: "*.example.com"
    port: 80
    protocol: HTTP

---
apiVersion: gateway.networking.k8s.io/v1beta1
kind: HTTPRoute
metadata:
  name: site-route
spec:
  parentRefs:
  - name: external-http
  rules:
  - matches:
    - path:
        value: /shop
    backendRefs:
    - name: store-service
      port: 8080
  - matches:  # default route
    backendRefs:
    - name: site-service
      port: 8080
```

### Advanced Features

- **Traffic Splitting**: Route percentage of traffic to different backends
- **Header-Based Routing**: Route based on request headers
- **Canary Deployments**: Gradually roll out new versions
- **Circuit Breakers**: Automatic failover and retries

### When to Use Gateway API vs Ingress

**Use Ingress when:**
- Simple HTTP routing requirements
- Prefer stability over cutting-edge features
- Small scale deployments

**Use Gateway API when:**
- Complex traffic management needs
- Multi-tenant environments with role separation
- Advanced routing (header matching, traffic splitting)
- Need for circuit breakers and canary deployments

### Enabling Gateway API in GKE

```bash
# Enable Gateway API
gcloud container clusters update <cluster-name> \
  --update-addons=Gateway,HTTPWaypoint
```

## Service Types in Kubernetes

### Overview

Kubernetes provides several service types, each serving different access patterns:

### ClusterIP (Default)

**Characteristics:**
- Internal cluster communication only
- Automatically assigned cluster IP
- No external access
- Foundation for Ingress and LoadBalancer services

```yaml
apiVersion: v1
kind: Service
spec:
  type: ClusterIP
  selector:
    app: my-app
  ports:
  - port: 8080
    targetPort: 8080
```

### NodePort

**Characteristics:**
- Exposes service on each node's IP at a static port
- Port range: 30000-32767
- Accessible from outside cluster via `<NodeIP>:<NodePort>`
- Requires nodes to have external IPs

```yaml
apiVersion: v1
kind: Service
spec:
  type: NodePort
  selector:
    app: my-app
  ports:
  - port: 8080
    targetPort: 8080
    nodePort: 32000
```

### LoadBalancer

**Characteristics:**
- Creates external load balancer in cloud provider
- Automatically provisions external IPs
- Layer 4 load balancing (TCP/UDP)
- Generates firewall rules for each service

```yaml
apiVersion: v1
kind: Service
spec:
  type: LoadBalancer
  selector:
    app: my-app
  ports:
  - port: 8080
    targetPort: 8080
```

### ExternalName

**Characteristics:**
- Maps service to external DNS name
- No proxying or port handling
- Useful for accessing external services
- Creates CNAME records

```yaml
apiVersion: v1
kind: Service
spec:
  type: ExternalName
  externalName: api.external-service.com
```

### Practical Comparison

| Service Type | External Access | Load Balancer | Firewall Rules | Use Case |
|-------------|-----------------|---------------|----------------|----------|
| ClusterIP | ✗ | ✗ | Manual | Internal communication |
| NodePort | ✓ (Node IPs required) | ✗ | Manual | Development/testing |
| LoadBalancer | ✓ | ✓ (Layer 4) | Auto-generated | Production services |
| ExternalName | ✓ (DNS redirect) | ✗ | None | External service access |

### Debugging Service Issues

**Common Commands:**
```bash
# Check service details
kubectl describe service <service-name>

# Verify endpoints
kubectl get endpoints <service-name>

# Test connectivity from pod
kubectl run busybox --image=busybox --rm -it --restart=Never -- nslookup <service-name>

# Check firewall rules in GCP
gcloud compute firewall-rules list --filter=name~gke
```

## Summary

### Key Takeaways

+ Layer 7 Ingress provides superior flexibility compared to Layer 4 LoadBalancers through intelligent HTTP routing, single IP management, and cost efficiency

- Multi-Cluster Ingress enables global application deployment with automatic proximity-based routing and high availability

- Gateway API represents the future of Kubernetes ingress with enhanced role separation, advanced routing capabilities, and open standards compliance

- Proper service type selection is crucial: ClusterIP for internal communication, LoadBalancer for simple external access, and Ingress for sophisticated HTTP routing

+ Effective troubleshooting involves checking health check configurations, verifying service selectors, and monitoring load balancer status

### Expert Insight

**Real-world Application**: In production environments, Ingress and Gateway API enable microservices architecture where dozens of applications share the same external IP while maintaining isolation and intelligent routing. Multi-Cluster Ingress becomes essential for global applications requiring compliance with regional data regulations (GDPR, CCPA) and optimizing user experience through geographic proximity.

**Expert Path**: Master Ingress annotations for SSL termination, custom headers, and rate limiting. Learn Gateway API CRDs for advanced traffic management including circuit breakers and A/B testing. Understand the interplay between external DNS, cert-manager, and ingress controllers.

**Common Pitfalls**:

- **Port Mismatch**: Always verify service ports match ingress backend ports exactly
- **Selector Mismatch**: Ensure deployment labels match service selectors precisely
- **Health Check Failures**: Configure appropriate paths and timeouts for application health
- **Firewall Over-permissiveness**: Use ingress-generated rules instead of wide-open firewalls
- **LoadBalancer Proliferation**: Avoid per-service LoadBalancers; consolidate with Ingress

**Common Issues with Resolution and How to Avoid**

- **Ingress Health Check Failures**: When health checks fail, verify port numbers match container ports. **Resolution**: Update health check configuration in load balancer settings to use correct port; add proper startup probes in deployment.

- **Firewall Rule Conflicts**: Multiple load balancers create overlapping firewall rules. **Resolution**: Use Ingress which creates minimal, specific rules; avoid wild-open firewalls.

- **Multi-Cluster Ingress Routes Not Working**: Fleet registration incomplete or cluster health issues. **Resolution**: Fully register clusters to fleet, ensure workload identity enabled, wait for full propagation (5-10 minutes).

- **Gateway API Not Available**: Addon not enabled. **Resolution**: Enable Gateway and HTTPWaypoint addons in cluster configuration before usage.

- **Service Endpoint Issues**: Selector mismatch between service and pods. **Resolution**: Always check `kubectl get endpoints <service-name>` and match with deployment labels.

Lesser known things about Ingress concepts:

- **Ingress Class**: Multiple ingress controllers can coexist; specify with `kubernetes.io/ingress.class` annotation
- **Path Priority**: Rules are evaluated in order; more specific paths should be listed before general ones
- **Backend Protocol**: Supports HTTPS backends with `backend-protocol: HTTPS` annotation
- **Security Headers**: Can add security headers via ingress annotations for HSTS, CORS, etc.
- **Rate Limiting**: Some ingress controllers support request rate limiting per client IP or path
- **Session Affinity**: Can enable sticky sessions for stateful applications with cookie-based routing

Lesser known things about multi-cluster concepts:

- **AnyCast Routing**: MCI uses Anycast which routes to geographically closest healthy endpoint
- **Fleet Workload Identity**: Enables cross-cluster authentication without service account key management
- **MultiClusterService Discovery**: Automatic service discovery across fleet clusters
- **Regional Compliance**: Perfect for data residency requirements in different regions
- **Failover Granularity**: Can failover at cluster level while maintaining application availability

Lesser known things about Gateway API:

- **Route Specificity**: Later routes take precedence over earlier ones in the specification
- **Cross-Namespace References**: Can reference services in different namespaces with proper RBAC
- **Traffic Splitting Weights**: Numerical weights (not percentages) specify traffic distribution
- **Header Matching**: Supports regex patterns for header value matching
- **Request/Response Modification**: Can add or modify headers during routing
- **Observability**: Built-in metrics and tracing for route-level observability

Lesser known things about Kubernetes service types:

- **Service CIDR Planning**: ClusterIP ranges must be planned carefully in advance
- **Internal Traffic Policies**: Can control whether service accepts traffic from external nodes
- **Topology Aware Routing**: Routes traffic to services in same zone for latency optimization
- **ServiceWithoutSelector**: Services without selectors for manual endpoint management
- **PublishNotReadyAddresses**: Includes unhealthy pods in service endpoints for graceful shutdowns

Note: Corrected instances where 'Kubectl' was written as 'Cubectl' in the transcript content. Also corrected 'htp' to 'htp' if found, but none were present in this transcript. The transcript appears to have been cleaned up already. All technical terms like 'LoadBalancer' are correctly spelled in the original transcript.  

CL-KK-Terminal
