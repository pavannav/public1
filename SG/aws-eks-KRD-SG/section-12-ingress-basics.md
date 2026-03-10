# Section 12: Ingress Basics

<details open>
<summary><b>Section 12: Ingress Basics (Claude Code)</b></summary>

## Table of Contents

- [12.1 Step-01- Introduction to Ingress Basics](#121-step-01--introduction-to-ingress-basics)
- [12.2 Step-02- Review Kubernetes Deployment and NodePort Service manifest](#122-step-02--review-kubernetes-deployment-and-nodeport-service-manifest)
- [12.3 Step-03- Create Ingress k8s manifest with default backend](#123-step-03--create-ingress-k8s-manifest-with-default-backend)
- [12.4 Step-04- Deploy Ingress default backend and verify and clean-up](#124-step-04--deploy-ingress-default-backend-and-verify-and-clean-up)
- [12.5 Step-05- Create, Deploy Ingress Rules and verify and clean-up](#125-step-05--create-deploy-ingress-rules-and-verify-and-clean-up)

## 12.1 Step-01- Introduction to Ingress Basics

### Overview

Section 12 introduces Kubernetes Ingress fundamentals, explaining key components and practical implementation through default backend and ingress rules patterns.

### Key Concepts

**Ingress Resource Components:**
- **Ingress Class**: Links ingress to specific controller (`ingress.k8s.aws/alb`)
- **Annotations**: ALB-specific configuration (security groups, subnets, health checks)
- **Rules**: HTTP routing rules (host-based, path-based)
- **Default Backend**: Catch-all backend when no rules match

### Ingress Specification Structure

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-ingress
  annotations:
    # ALB configuration annotations
spec:
  ingressClassName: aws-load-balancer  # References IngressClass
  rules:                              # Host/path routing rules
  - host: example.com
    http:
      paths:
      - path: /api
        backend: {...}
  defaultBackend:                     # Optional default backend
    service:
      name: default-svc
      port:
        number: 80
```

### ALB Ingress Architecture

**Traffic Modes Explained:**
- **Instance Mode (Default)**: Registers EC2 instances in target groups
- **IP Mode**: Registers pod IPs directly in target groups
- **Traffic Flow**: Internet → ALB → Target Group → EC2 Instance → NodePort → Pod

### ALB Load Balancer Components

**What Gets Created:**
- **Application Load Balancer**: HTTP layer 7 load balancer
- **Listeners**: HTTP (80), HTTPS (443) with SSL termination
- **Target Groups**: Contains EC2 nodes or pod IPs registered as targets
- **Rules**: Listener rules for routing traffic to target groups

### Ingress Controller Behavior

**AWS Load Balancer Controller Actions:**
1. Monitors ingress resource creation
2. Validates ingress class matches controller
3. Creates ALB if one doesn't exist (or reuses existing)
4. Creates target groups for each service backend
5. Registers targets (nodes or pods) in target groups
6. Creates listener rules based on ingress rules
7. Updates DNS and provides ALB endpoint

### Traffic Mode Comparison

| Mode | Target Group Contains | Use Case | Pros | Cons |
|------|----------------------|----------|------|------|
| **Instance** | EC2 worker nodes | Most applications | Simple, reliable | Extra network hop |
| **IP** | Pod IPs directly | Service mesh, performance | Direct pod access | Requires pod security groups |

### Real-World Usage Patterns

**Two Demos Structure:**
1. **Default Backend Demo**: Simple ingress with single service catch-all
2. **Ingress Rules Demo**: Host/path-based routing with multiple services

Each demo demonstrates ALB creation process, target group setup, and cleanup procedures for learning the complete lifecycle.

## 12.2 Step-02- Review Kubernetes Deployment and NodePort Service manifest

### Overview

Reviewing core application manifests (Nginx deployment and NodePort service) that will be used as ingress backends for demonstrating ALB ingress functionality.

### Application Architecture

**NGINX Application Stack:**
- **Deployment**: Creates nginx pods with application content
- **Service**: NodePort exposes application to cluster nodes
- **Ingress**: ALB ingress routes external traffic to the service

### Manifest Components

```yaml
# 01-NginxApp1-Deployment.yml
---
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
        image: stacksimplify/kube-nginxapp1:1.0.0
        ports:
        - containerPort: 80
          protocol: TCP

---
# 02-NginxApp1-NodePort-Service.yml
---
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
    nodePort: 31231
```

### Key Manifest Details

**Deployment Features:**
- Single replica nginx application pod
- Custom image with application content (`stacksimplify/kube-nginxapp1:1.0.0`)
- Standard nginx configuration on port 80

**Service Features:**
- **Type: NodePort**: Exposes service on static port (31231) on all nodes
- **Selector**: Matches pods with `app: app1-nginx` label
- **Ports**: Maps service port 80 to container port 80

### Application URLs

**NodePort Access:**
- Direct node access: `http://<NODE-IP>:31231/`
- Application route: `http://<NODE-IP>:31231/app1/index.html`
- Expected content: NGINX application 1 with custom styling

### Infrastructure Placement

**EKS Integration:**
- Pods scheduled on private node group
- Service accessible across node group IPs
- ALB ingress will route external traffic to this NodePort service

## 12.3 Step-03- Create Ingress k8s manifest with default backend

### Overview

Creating basic ingress manifest with default backend configuration that routes all traffic to the NGINX application service, demonstrating ALB creation through ingress resources.

### Default Backend Ingress Pattern

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-default-backend
  annotations:
    alb.ingress.kubernetes.io/load-balancer-name: default-app1-lb
    alb.ingress.kubernetes.io/target-type: instance
    alb.ingress.kubernetes.io/scheme: internet-facing
spec:
  ingressClassName: aws-load-balancer
  defaultBackend:
    service:
      name: app1-nginx-nodeport-service
      port:
        number: 80
```

### Key Configuration Details

**ALB Annotations:**
- `load-balancer-name`: Custom ALB name for resource identification
- `target-type: instance`: Registers EC2 instances (nodes) in target group
- `scheme: internet-facing`: Creates internet-accessible ALB

**Service Integration:**
- **defaultBackend**: All unmatched traffic routes here
- **Service Name**: app1-nginx-nodeport-service (NodePort service)
- **Port**: 80 (matches service port)

### ALB Creation Process

**What Happens:**
1. Ingress controller detects new ingress resource
2. Validates ingress class matches AWS controller
3. Creates ALB named "default-app1-lb"
4. Creates target group for the service
5. Registers all worker nodes (instance mode) in target group
6. Configures HTTP listener on port 80
7. Creates default forwarding rule to target group

### Expected ALB Configuration

**Listener Configuration:**
```
Listener: HTTP:80
  Rule 1: Default (forward to target group)
```

**Target Group Configuration:**
- Type: instance (EC2 nodes)
- Protocol: HTTP:80
- Health check: HTTP health checks against registered nodes
- Targets: All worker node instances

### Access Pattern

**Default Backend Behavior:**
- URL: `http://<ALB-DNS>/` → routes to default backend
- URL: `http://<ALB-DNS>/anything` → routes to default backend
- ALB DNS: `default-app1-lb-xxxx.amazonaws.com`

No host-specific or path-specific rules - everything goes to default backend.

## 12.4 Step-04- Deploy Ingress default backend and verify and clean-up

### Overview

Deploying default backend ingress, verifying ALB creation and traffic routing, then cleaning up resources to demonstrate complete lifecycle management.

### Deployment Process

```bash
# Deploy application and ingress
kubectl apply -f 01-NginxApp1-Deployment.yml
kubectl apply -f 02-NginxApp1-NodePort-Service.yml
kubectl apply -f 03-Ingress-Default-Backend.yml

# Monitor ingress and ALB creation
kubectl get ingress ingress-default-backend -w
```

### ALB Verification Steps

**1. Check Ingress Status:**
```bash
kubectl describe ingress ingress-default-backend

# Expected output shows ALB ARN and DNS
Address: default-app1-lb-xxxx.amazonaws.com
```

**2. Verify ALB in AWS:**
```bash
# List ALBs
aws elbv2 describe-load-balancers \
  --query 'LoadBalancers[?contains(DNSName, `default-app1-lb`)].{Name:Name, DNS:DNSName, Type:Type}'

# Check target groups
aws elbv2 describe-target-groups \
  --query 'TargetGroups[?contains(TargetGroupName, `default-app1-lb`)]'

# Verify targets (EC2 instances)
aws elbv2 describe-target-health \
  --target-group-arn YOUR-TG-ARN
```

**3. Test Application Access:**
```bash
# Get ALB DNS
ALB_DNS=$(kubectl get ingress ingress-default-backend -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

# Test default backend
curl -I http://${ALB_DNS}/  # Should return 200 OK
curl http://${ALB_DNS}/app1/metadata.html  # Should serve app1 content
```

### Traffic Flow Verification

**Instance Mode Traffic Path:**
```
User → ALB (Port 80) → Target Group → EC2 Node (Port 31231)
  → NodePort Service → Pod (Port 80) → NGINX Application
```

**Target Group Analysis:**
- All EC2 worker nodes registered as targets
- Health checks performed against each node instance
- Traffic distributed across healthy targets using round-robin

### Cleanup Process

```bash
# Delete ingress (ALB auto-deleted by controller)
kubectl delete ingress ingress-default-backend

# Delete application resources
kubectl delete -f 02-NginxApp1-NodePort-Service.yml
kubectl delete -f 01-NginxApp1-Deployment.yml

# Verify ALB cleanup
aws elbv2 describe-load-balancers \
  --query 'LoadBalancers[?contains(DNSName, `default-app1-lb`)]'

# Should return empty - ALB deleted by controller
```

### Key Learning Points

- ALB creation through ingress resource declaration
- Automatic target group creation and node registration
- Default backend routing for simple applications
- Resource lifecycle management through controller
- AWS resource cleanup on ingress deletion

## 12.5 Step-05- Create, Deploy Ingress Rules and verify and clean-up

### Overview

Implementing ingress rules for host-based routing, demonstrating advanced ALB configuration with custom domain routing and multiple backend services.

### Ingress Rules Configuration

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-rules
  annotations:
    alb.ingress.kubernetes.io/load-balancer-name: ingress-rules-app1-lb
    alb.ingress.kubernetes.io/target-type: instance
    alb.ingress.kubernetes.io/scheme: internet-facing
spec:
  ingressClassName: aws-load-balancer
  rules:
  - host: ingress-rules-app1.tstadler-dev.com  # Must resolve to ALB
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app1-nginx-nodeport-service
            port:
              number: 80
      - path: /app1
        pathType: Prefix
        backend:
          service:
            name: app1-nginx-nodeport-service
            port:
              number: 80
```

### Host-Based Routing Configuration

**DNS Setup Requirements:**
- Domain must resolve to ALB DNS (Route53 alias record preferred)
- Certificate required for HTTPS (covered in later sections)
- Host header matching used for routing decisions

### ALB Listener Rules Creation

**Generated ALB Configuration:**
```
Listener: HTTP:80
  Rule 1: IF (Host Header == ingress-rules-app1.tstadler-dev.com)
    AND (Path == /*) THEN Forward to TargetGroup-App1

  Rule 2: IF (Host Header == ingress-rules-app1.tstadler-dev.com)
    AND (Path == /app1/*) THEN Forward to TargetGroup-App1-App1

  Default Rule: Return 404 (no default backend specified)
```

### Ingress Rules vs Default Backend

| Configuration | Rules | Default Backend | Use Case |
|---------------|--------|-----------------|----------|
| Basic Routing | ❌ | ✅ | Simple single-application ingress |
| Host-Based Routing | ✅ | ❌ | Multiple domains, specific hosts |
| Mixed Routing | ✅ | ✅ | Host-specific routes + catch-all |

### Path Matching Behavior

**pathType: Prefix Explained:**
- `/` matches: `/`, `/anything`, `/anything/else`
- `/app1` matches: `/app1`, `/app1/anything`, `/app1-else`
- **Case-sensitive**: `/App1` ≠ `/app1`
- **Exact behavior**: Prefix matching, not suffix matching

### Multi-Host Ingress Pattern

```yaml
rules:
- host: app1.example.com
  http:
    paths:
    - path: /
      backend: {service: app1-service}
- host: app2.example.com
  http:
    paths:
    - path: /
      backend: {service: app2-service}
- host: api.example.com
  http:
    paths:
    - path: /v1
      backend: {service: api-v1-service}
    - path: /v2
      backend: {service: api-v2-service}
```

### Testing Ingress Rules

**Domain Resolution Setup:**
```bash
# Update /etc/hosts or Route53 for testing
echo "ALB_DNS ingress-rules-app1.tstadler-dev.com" >> /etc/hosts
```

**Traffic Testing:**
```bash
ALB_DNS=$(kubectl get ingress ingress-rules --jsonpath='{.status.loadBalancer.ingress[0].hostname}')

# Test host-based routing (won't work without DNS)
curl http://ingress-rules-app1.tstadler-dev.com/ \
  -H "Host: ingress-rules-app1.tstadler-dev.com"

# Test ALB direct access (ALB ignores host header for rules)
curl http://${ALB_DNS}/
```

### ALB Behavior Analysis

**Without Proper DNS:**
- ALB receives request but host header doesn't match rules
- Traffic hits default behavior (404 without default backend)
- Demonstrates importance of proper DNS configuration

**With Proper DNS:**
- Host header matches rule condition
- Traffic forwarded to appropriate target group
- Application receives and processes request

### Complete Cleanup Process

```bash
# Delete ingress rules resource
kubectl delete ingress ingress-rules

# Delete application components
kubectl delete svc app1-nginx-nodeport-service
kubectl delete deployment app1-nginx-deployment

# Verify ALB cleanup
aws elbv2 describe-load-balancers \
  --query 'LoadBalancers[?contains(DNSName, `ingress-rules-app1-lb`)]'

# Confirm: Return value should be empty
```

## Summary

### Key Takeaways

```diff
+ Ingress resources declaratively create ALBs through AWS controller
+ Default backends provide catch-all routing for simple applications
+ Ingress rules enable host-based and path-based sophisticated routing
+ Target type affects how traffic reaches pods (instance vs IP mode)
+ Proper DNS configuration critical for host-based routing
+ Controller automatically manages ALB lifecycle with ingress resources
```

### Quick Reference

**Default Backend Ingress:**
```yaml
spec:
  ingressClassName: aws-load-balancer
  defaultBackend:
    service:
      name: my-service
      port:
        number: 80
```

**Ingress Rules Pattern:**
```yaml
spec:
  ingressClassName: aws-load-balancer
  rules:
  - host: app.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app-service
            port:
              number: 80
```

### Expert Insight

**ALB Ingress Architecture**: Ingress resources specify desired routing behavior while the AWS Load Balancer Controller translates these declarations into actual ALB infrastructure, including load balancers, listeners, rules, and target groups.

**Common Patterns:**
- Single application default backend for microservices
- Multi-tenant applications with host-based routing
- Path-based API versioning (v1, v2, v3)
- Mixed host and path routing for complex apps

**Common Pitfalls:**
- ❌ DNS resolution issues with host-based rules
- ❌ Missing ingress class causing fallback to default
- ❌ Incorrect pathType causing unexpected routing behavior
- ❌ ALB annotation syntax errors blocking deployment
- ❌ Target type mismatch with Service types