# Section 12: Ingress Basics 

<details open>
<summary><b>Section 12: Ingress Basics (G3PCS46)</b></summary>

## Table of Contents

- [12.1 Introduction to Ingress Basics](#121-introduction-to-ingress-basics)
- [12.2 Review Kubernetes Deployment and NodePort Service Manifest](#122-review-kubernetes-deployment-and-nodeport-service-manifest)
- [12.3 Create Ingress k8s Manifest with Default Backend](#123-create-ingress-k8s-manifest-with-default-backend)
- [12.4 Deploy Ingress Default Backend and Verify and Clean-up](#124-deploy-ingress-default-backend-and-verify-and-clean-up)
- [12.5 Create, Deploy Ingress Rules and Verify and Clean-up](#125-create-deploy-ingress-rules-and-verify-and-clean-up)

## 12.1 Introduction to Ingress Basics

### Overview
Ingress is a Kubernetes resource that manages external access to services within a cluster, typically through HTTP or HTTPS routing. This section introduces the fundamental components of Ingress manifests, including annotations for load balancer settings, Ingress class names for controller association, and routing rules or default backends. The network design demonstrates how user requests flow from a DNS URL through the Application Load Balancer (ALB) to Kubernetes pods via NodePort services.

### Key Concepts

#### Ingress Manifest Components
- **Ingress Annotations**: Load balancer configuration settings specific to the AWS ALB Ingress controller
- **Ingress Class Name**: Associates the Ingress with a specific controller (e.g., AWS ALB Ingress controller)
- **Ingress Spec**: Contains routing rules (HTTP paths) or a default backend configuration

#### Ingress Annotations Reference
Ingress annotations enable customization of load balancer behavior with approximately 30+ available settings covering:

| Annotation | Description |
|------------|-------------|
| Load Balancer Name | Custom name for the ALB (max 32 characters) |
| Group Name | Logical grouping of Ingress resources |
| Tags | AWS resource tagging |
| IP Address Mode | Disable/enable cross-zone load balancing |
| Load Balancer Type | Internal or internet-facing |
| Security Groups | Custom security group associations |
| Subnets | Specific subnet placement |
| Health Check Settings | Protocol, path, interval, timeout, thresholds |

#### Network Design for Default Backend
- EKS cluster with public/private subnets and NAT Gateway
- Worker nodes deployed in private subnets
- NGINX application deployed as a Deployment with 3 replicas
- Application fronted by a NodePort service
- Ingress resource with default backend pointing to NodePort service
- User request flow: DNS URL (/app1/index.html) → ALB → Default Backend (NodePort service) → Pod

#### AWS ALB Ingress Controller Workflow
The controller monitors the Kubernetes API server for Ingress resources and creates/manages ALBs with appropriate configurations.

```
Kubernetes API Server → ALB Ingress Controller
     ↓
Ingress Resources Detected
     ↓
ALB Created with:
- HTTP/HTTPS listeners
- Target Groups for services
- Routing rules
```

#### Traffic Modes
Two primary traffic routing modes supported by AWS ALB Ingress controller:

- **Instance Mode** (Default): Routes traffic to all EC2 instances (nodes) with the NodePort service port open
  - Target group registers all nodes in the cluster
  - Service must be type NodePort
  - Used with managed node groups
- **IP Mode**: Routes traffic directly to pod IPs
  - Target group registers pod IPs directly  
  - Primarily used for Fargate workloads
  - No NodePort service required

### Code/Config Blocks

Example default backend configuration in Ingress spec:
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-nginxapp1
spec:
  ingressClassName: my-aws-ingress-class
  defaultBackend:
    service:
      name: app1-nginx-nodeport-service
      port:
        number: 80
```

### Tables

#### HTTP Methods Supported
| Method | Description |
|--------|-------------|
| GET | Retrieve resources |
| POST | Create resources |
| PUT | Replace resources |
| DELETE | Remove resources |
| PATCH | Partial updates |

#### Protocol Versions
| Version | Description |
|---------|-------------|
| HTTP/1.1 | Standard HTTP protocol |
| HTTP/2 | Multiplexed protocol with better performance |

### Summary

```diff
+ Key Takeaways:
+ - Ingress manages external access to cluster services via HTTP/HTTPS routing
+ - Annotations control ALB behavior with 30+ configuration options
+ - Traffic can be routed to nodes (instance mode) or pods (IP mode)  
+ - Default backend handles requests that don't match specific routing rules

! Quick Reference:
! - Ingress Class: `ingressClassName: my-aws-ingress-class`
! - Default Backend: References NodePort service name and port
! - Traffic Mode: `alb.ingress.kubernetes.io/target-type: instance/ip`
```

**Expert Insight**  
**Real-world Application**: Use Ingress to implement context-path based routing for microservices, enabling a single ALB to serve multiple applications via different URL paths while maintaining service isolation.  
**Expert Path**: Master traffic modes by understanding when to use IP mode for Fargate (serverless) vs instance mode for managed node groups; implement advanced health checks and SSL termination.  
**Common Pitfalls**: Forgetting to configure proper security groups, subnet placement, or health check paths; mixing traffic modes incorrectly; not setting Ingress class as default to avoid explicit declarations.

## 12.2 Review Kubernetes Deployment and NodePort Service Manifest

### Overview
This section reviews the standard Kubernetes manifests for deploying an NGINX application, including a Deployment and NodePort service. The manifests follow Kubernetes best practices for resource definition and service exposure.

### Key Concepts

#### Deployment Manifest Structure
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app1-nginx-deployment
  labels:
    app: app1-nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: app1-nginx
  template:
    metadata:
      labels:
        app: app1-nginx
    spec:
      containers:
      - name: app1-nginx
        image: stacksimplify/kube-nginx-app1:1.0.0
        ports:
        - containerPort: 80
```

#### NodePort Service Manifest Structure
```yaml
apiVersion: v1
kind: Service
metadata:
  name: app1-nginx-nodeport-service
  labels:
    app: app1-nginx
spec:
  type: NodePort
  selector:
    matchLabels:
      app: app1-nginx
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP
```

### Lab Demo: Review Manifests

**Steps:**
1. Locate manifests in `01-kube-manifest-default-backend/` folder
2. Examine `app1-nginx-deployment.yaml` for API version, kind, metadata, spec structure
3. Verify replica count, selector labels, container image, and ports
4. Review `app1-nginx-nodeport-service.yaml` for service type, selector, ports
5. Confirm label matching between deployment and service

### Summary

```diff
+ Key Takeaways:
+ - Deployments manage pod replicas with rolling updates
+ - NodePort services expose pods on static ports across all nodes (30000-32767)
+ - Service selectors must match deployment pod template labels
+ - APIs (apps/v1 for deployments, v1 for services) follow Kubernetes standards

! Quick Reference:
! - Deployment replicas: `spec.replicas: 1`
! - Service selector: `selector.matchLabels.app: app1-nginx`
! - Container port: `ports.containerPort: 80`
! - Service port: `ports.port: 80`
```

**Expert Insight**  
**Real-world Application**: Use Deployments for stateless applications with rolling updates; NodePort for direct node-level access during development/testing.  
**Expert Path**: Understand pod affinity/anti-affinity for workload placement; implement resource requests/limits; use service meshes for advanced traffic management.  
**Common Pitfalls**: Mismatched labels between deployments and services; exposing sensitive ports (80/443) unnecessarily; forgetting to set appropriate resource constraints.

## 12.3 Create Ingress k8s Manifest with Default Backend

### Overview
This section demonstrates creating an Ingress manifest with default backend configuration, focusing on proper annotation setup for ALB customization. The Ingress connects external traffic to the NGINX application via NodePort service, with detailed health check and load balancer settings.

### Key Concepts

#### Ingress Annotations for ALB Configuration
Core annotation categories include load balancer settings, health checks, and traffic routing:

**Load Balancer Settings:**
- `alb.ingress.kubernetes.io/load-balancer-name`: Custom ALB name
- `alb.ingress.kubernetes.io/scheme`: `internet-facing` or `internal`
- `alb.ingress.kubernetes.io/target-type`: `instance` (default) or `ip`

**Health Check Settings:**
```yaml
annotations:
  alb.ingress.kubernetes.io/healthcheck-protocol: HTTP
  alb.ingress.kubernetes.io/healthcheck-port: traffic-port
  alb.ingress.kubernetes.io/healthcheck-path: /app1/index.html
  alb.ingress.kubernetes.io/healthcheck-interval-seconds: "15"
  alb.ingress.kubernetes.io/healthcheck-timeout-seconds: "5"
  alb.ingress.kubernetes.io/healthcheck-success-codes: "200-299"
  alb.ingress.kubernetes.io/healthcheck-healthy-threshold-count: "3"
  alb.ingress.kubernetes.io/healthcheck-unhealthy-threshold-count: "3"
```

#### Ingress Spec Configuration
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-nginxapp1
  annotations:
    # ALB annotations here
spec:
  ingressClassName: my-aws-ingress-class
  defaultBackend:
    service:
      name: app1-nginx-nodeport-service
      port:
        number: 80
```

#### Ingress Class vs Deprecated Annotations
- **Current approach**: Use `ingressClassName` field referencing IngressClass resource
- **Deprecated approach**: `kubernetes.io/ingress.class` annotation
- IngressClass (Kubernetes 1.18+) provides better configuration management

### Lab Demo: Create Ingress Manifest

**Steps:**
1. Create file `02-alb-ingress-basic.yaml` in ingress basics folder
2. Define API version as `networking.k8s.io/v1` for latest Ingress support
3. Configure complete annotation block with load balancer and health check settings
4. Set `ingressClassName` to reference AWS ALB IngressClass
5. Configure `defaultBackend` with NodePort service details
6. Save manifest and proceed to deployment

### Tables

#### Health Check Protocols
| Protocol | Description |
|----------|-------------|
| HTTP | Standard HTTP health checks |
| HTTPS | HTTPS-based health checks |
| TCP | Basic TCP connectivity checks |

#### Load Balancer Schemes
| Scheme | Description |
|--------|-------------|
| internet-facing | Accessible from internet |
| internal | Accessible only within VPC |

### Code/Config Blocks
Complete Ingress manifest with default backend:
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-nginxapp1
  annotations:
    alb.ingress.kubernetes.io/load-balancer-name: app1-ingress
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/healthcheck-protocol: HTTP
    alb.ingress.kubernetes.io/healthcheck-port: traffic-port
    alb.ingress.kubernetes.io/healthcheck-path: /app1/index.html
    alb.ingress.kubernetes.io/healthcheck-interval-seconds: "15"
    alb.ingress.kubernetes.io/healthcheck-timeout-seconds: "5"
    alb.ingress.kubernetes.io/healthcheck-success-codes: "200-299"
    alb.ingress.kubernetes.io/healthcheck-healthy-threshold-count: "3"
    alb.ingress.kubernetes.io/healthcheck-unhealthy-threshold-count: "3"
spec:
  ingressClassName: my-aws-ingress-class
  defaultBackend:
    service:
      name: app1-nginx-nodeport-service
      port:
        number: 80
```

### Summary

```diff
+ Key Takeaways:
+ - Default backend routes unmatched traffic to specified service
+ - Annotations control ALB creation and behavior details
+ - Health checks ensure traffic goes to healthy targets only
+ - Ingress class association enables controller-specific features

! Quick Reference:
! - ALB Name: `alb.ingress.kubernetes.io/load-balancer-name: app1-ingress`
! - Scheme: `alb.ingress.kubernetes.io/scheme: internet-facing`
! - Health Check Path: `alb.ingress.kubernetes.io/healthcheck-path: /app1/index.html`
! - Ingress Class: `ingressClassName: my-aws-ingress-class`
! - Default Backend: `defaultBackend.service.name: app1-nginx-nodeport-service`
```

**Expert Insight**  
**Real-world Application**: Use default backends for fallback routing in blue-green deployments; implement comprehensive health checks to prevent traffic to failed services.  
**Expert Path**: Optimize health check intervals based on application startup times; implement custom success codes for complex application readiness checks.  
**Common Pitfalls**: Overly aggressive health check settings causing unnecessary pod restarts; forgetting to update health check paths after application changes; incorrect load balancer schemes leading to accessibility issues.

## 12.4 Deploy Ingress Default Backend and Verify and Clean-up

### Overview
This section demonstrates deployment of the default backend Ingress configuration, including verification of Kubernetes resources, ALB creation, target group setup, and testing access. The focus is on understanding the complete lifecycle from manifest application to service cleanup.

### Key Concepts

#### Deployment Verification Steps
1. Apply Kubernetes manifests: `kubectl apply -f 01-kube-manifest-default-backend/`
2. Verify deployment status: `kubectl get deployments`
3. Check pod readiness: `kubectl get pods`
4. Confirm service creation: `kubectl get svc`
5. Validate Ingress resource: `kubectl get ingress`

#### ALB and Target Group Analysis
- ALB automatically created with HTTP listener (port 80)
- Target group named `k8s-default-app1nginx-<suffix>`
- Target type defaults to `instance` mode
- All cluster nodes registered as targets with NodePort
- Health checks configured based on Ingress annotations

#### Traffic Flow Verification
```
User Request (ALB DNS) → ALB Listener → Target Group → NodePort Service → Pods
```

### Lab Demo: Deploy, Verify, and Test

**Steps:**
1. Deploy manifests: Run `kubectl apply -f 01-kube-manifest-default-backend/`
2. Verify resources: Check deployments, pods, services, and ingress status
3. Examine ALB: Locate load balancer in AWS console by name
4. Review target groups: Confirm node registration and health status
5. Test access: Use ALB DNS URL with `/app1/index.html` path
6. Clean up: `kubectl delete -f 01-kube-manifest-default-backend/`
7. Verify cleanup: Ensure ALB is deleted to prevent charges

### Code/Config Blocks
Verification commands:
```bash
# Check all resources
kubectl get all

# Verify ingress details
kubectl get ingress
kubectl describe ingress ingress-nginxapp1

# Check ALB Ingress controller logs if needed
kubectl get pods -n kube-system
kubectl logs -f <alb-controller-pod> -n kube-system
```

### Tables

#### Target Group Health States
| State | Description | Action |
|-------|-------------|--------|
| healthy | Target responding successfully | Traffic routed normally |
| unhealthy | Target failing health checks | Traffic stopped to target |
| draining | Target being removed | Traffic drained gradually |

#### Ingress Resource Status
| Status | Description |
|--------|-------------|
| Active | ALB created and configured |
| Provisioning | ALB being created |
| Failed | ALB creation failed - check events |

### Summary

```diff
+ Key Takeaways:
+ - Kubernetes apply creates ALB automatically via Ingress controller
+ - Target groups register nodes with service NodePorts by default
+ - Health checks must pass before traffic is routed
+ - Cleanup removes ALB to prevent cost accumulation

! Quick Reference:
! - Deploy: `kubectl apply -f <folder>/`
! - Verify ALB: Check EC2 → Load Balancers console
! - Test URL: `<alb-dns-name>/app1/index.html`
! - Cleanup: `kubectl delete -f <folder>/`
! - Check logs: `kubectl logs -f <alb-controller-pod> -n kube-system`
```

**Expert Insight**  
**Real-world Application**: Use this pattern for canary deployments; monitor target group health in CloudWatch for proactive issue detection.  
**Expert Path**: Implement custom CloudWatch alarms for ALB metrics; use target group stickiness for session affinity when needed.  
**Common Pitfalls**: Forgetting to verify ALB deletion after cleanup; health check failures due to incorrect paths causing service downtime; resource name conflicts from previous failed deployments.

## 12.5 Create, Deploy Ingress Rules and Verify and Clean-up

### Overview
This section covers Ingress routing rules implementation, focusing on HTTP path-based routing with different path types. It demonstrates how to configure specific routing rules instead of relying on default backends, enabling more granular traffic control.

### Key Concepts

#### Ingress Path Types
Three path matching types available for routing rules:

**Implementation-Specific** (Default)
- Matching behavior depends on Ingress controller implementation
- AWS ALB treats as prefix or exact based on internal logic

**Exact Path Type**
- Requires exact case-sensitive URL path match
- No partial matching or trailing slash flexibility

**Prefix Path Type** (Recommended)
- Matches URL path prefix, split by forward slashes
- Case-sensitive element-by-element path matching

#### Path Type Examples
```yaml
spec:
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app1-nginx-nodeport-service
            port:
              number: 80
      - path: /app1
        pathType: Exact
        backend:
          service:
            name: app1-nginx-nodeport-service
            port:
              number: 80
```

### Lab Demo: Deploy Ingress with Rules

**Steps:**
1. Create `02-kube-manifest-rules/` folder and manifests
2. Configure Ingress with `rules` instead of `defaultBackend`
3. Set HTTP paths with `/` path and `Prefix` pathType
4. Deploy: `kubectl apply -f 02-kube-manifest-rules/`
5. Verify: Check ingress, ALB, target groups creation
6. Test routing: Access ALB URL with and without paths
7. Modify path to `/app1` to demonstrate prefix behavior
8. Re-deploy and test path restrictions
9. Clean up: `kubectl delete -f 02-kube-manifest-rules/`

### Code/Config Blocks
Complete Ingress manifest with rules:
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-nginxapp1
  annotations:
    alb.ingress.kubernetes.io/load-balancer-name: app1-ingress-rules
spec:
  ingressClassName: my-aws-ingress-class
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app1-nginx-nodeport-service
            port:
              number: 80
```

### Tables

#### Path Type Comparison
| Path Type | Match Behavior | Use Case |
|-----------|----------------|----------|
| Implementation-Specific | Controller-dependent | Legacy configs |
| Exact | Exact path match only | API version endpoints |
| Prefix | Path prefix matching | Context-path routing |

#### Path Matching Examples
| Defined Path | Path Type | Request Path | Match Result |
|--------------|-----------|--------------|--------------|
| / | Prefix | /app1/index.html | ✅ Match |
| / | Prefix | / | ✅ Match |
| /app1 | Exact | /app1 | ✅ Match |
| /app1 | Exact | /app1/ | ❌ No Match |
| /app1 | Exact | /app1/index.html | ❌ No Match |
| /app1 | Prefix | /app1/index.html | ✅ Match |

### Summary

```diff
+ Key Takeaways:
+ - Rules enable context-path routing vs default backend blanket routing
+ - Prefix path type provides flexible matching for hierarchical paths
+ - ALB creates listeners and target groups based on defined rules
+ - Exact matching is strict while prefix allows sub-path access

! Quick Reference:
! - Rules structure: `spec.rules[].http.paths[]`
! - Path types: `Exact`, `Prefix`, `ImplementationSpecific`
! - Path definition: `path: "/"`
! - Path type: `pathType: Prefix`
! - Backend service: `backend.service.name: <service-name>`
! - Backend port: `backend.service.port.number: 80`
```

**Expert Insight**  
**Real-world Application**: Use rules for microservice routing where different services need different URL prefixes; implement API versioning with exact path matching.  
**Expert Path**: Combine rules with external-dns for automatic DNS record management; implement weighted routing for canary releases using ALB target group weights.  
**Common Pitfalls**: Choosing exact when prefix is needed (causing access failures); missing trailing slashes in path definitions; not updating rules during application deployments; resource cleanup failures leaving orphaned ALBs.

</details>
