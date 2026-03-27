<details open>
<summary><b>Section 19: Ingress Target Type IP Mode (G3PCS46)</b></summary>

# Section 19: Ingress Target Type IP Mode

## Table of Contents
- [19.1 Step-01- Introduction to Ingress Target Type IP Mode](#191-step-01--introduction-to-ingress-target-type-ip-mode)
- [19.2 Step-02- Implement Ingress Target Type IP Mode](#192-step-02--implement-ingress-target-type-ip-mode)
- [Summary](#summary)

## 19.1 Step-01- Introduction to Ingress Target Type IP Mode

### Overview
Kubernetes Ingress using AWS Application Load Balancer (ALB) supports two target types for routing traffic: instance mode and IP mode. Instance mode routes traffic to all EC2 instances in the cluster via NodePort services, while IP mode routes traffic directly to pods, enabling features like sticky sessions and supporting AWS Fargate environments. This section introduces the concepts and differences between these modes.

### Key Concepts/Deep Dive

#### ALB Ingress Target Type Annotation
The `alb.ingress.kubernetes.io/target-type` annotation specifies how traffic is routed from the Application Load Balancer to Kubernetes services.
- **Instance Mode (Default)**: Routes traffic to all EC2 worker nodes on the NodePort opened for the service. The service must be of type `NodePort` or `LoadBalancer`. This mode was used in previous examples with NodePort services.
- **IP Mode**: Routes traffic directly to pods, bypassing any intermediate services like NodePort. This mode is required for sticky sessions and is the only option for AWS Fargate.

#### Instance Mode vs IP Mode Comparison

| Feature | Instance Mode | IP Mode |
|---------|---------------|---------|
| Routing Target | Worker node IPs + NodePort | Pod IPs directly |
| Service Type | NodePort or LoadBalancer | Any type (NodePort, ClusterIP, LoadBalancer) |
| Sticky Sessions | Not supported | Supported |
| Fargate Compatibility | ❌ (Not applicable) | ✅ (Required) |
| Default Behavior | Yes (no annotation needed) | No (explicit annotation required) |

#### Why Use IP Mode?
- **Sticky Sessions**: IP mode enables session persistence in the ALB.
- **Fargate Requirements**: AWS Fargate worker nodes require IP mode.
- **Direct Pod Access**: Eliminates intermediary NodePort traffic routing.

> [!NOTE]
  In transcript, there was a minor typo: "ALB IngressKubernetes" should be "ALB Ingress Kubernetes". This has been corrected in the study guide.

### Lab Demos
No practical demos in this introductory section; concepts are covered theoretically for context before implementation.

## 19.2 Step-02- Implement Ingress Target Type IP Mode

### Overview
This section demonstrates implementing ALB Ingress with target type IP mode, using ClusterIP services instead of NodePort to route traffic directly from the load balancer to pods. The setup involves creating deployments, services, and an Ingress resource, followed by verifying target groups and testing accessibility.

### Key Concepts/Deep Dive

#### Manifests Overview
The implementation uses ClusterIP services for app1, app2, and app3, along with an Ingress that defines routing rules based on URL paths. Key annotations include `alb.ingress.kubernetes.io/target-type: ip` to enable direct pod routing.

- **Services**: Type `ClusterIP` (no NodePorts needed).
- **Ingress**: Defines path-based routing (`/app1`, `/app2`, default) with TLS support.
- **Certificate**: Uses domain-based discovery for `*.stacksimplify.com` (optional; can fall back to ARN-based certificates).

#### Why ClusterIP Over NodePort?
- IP mode routes directly to pod IPs, making NodePorts unnecessary.
- ClusterIP services still required for Ingress controller to create ALB target groups.
- Both service types support IP mode; ClusterIP is simpler for this demonstration.

#### Target Group Registration
In IP mode, ALB target groups automatically register pod IPs as targets, not service IPs or node ports.

#### Deployment and Verification Steps
1. Deploy manifests: App1, app2, app3 deployments (ClusterIP services) and Ingress.
2. Verify resources: Check pods (for IP addresses), services, and Ingress creation.
3. Inspect ALB target groups: Each target group should contain healthy pod IPs (e.g., 192.168.xx.xx) matching pod addresses.
4. Test DNS and browser access: Verify path-based routing works (`/app1` → app1, `/app2` → app2, `/` → app3).

### Code/Config Blocks

#### Sample ClusterIP Service Manifest (e.g., app1-clusterip-service.yaml)
```yaml
apiVersion: v1
kind: Service
metadata:
  name: app1-nginx-clusterip-service
  labels:
    app: app1-nginx
spec:
  type: ClusterIP
  ports:
  - port: 80
    targetPort: 80
  selector:
    app: app1-nginx
```

#### Ingress Manifest with IP Target Type
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-target-type-ip-demo
  annotations:
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip  # Key annotation for IP mode
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS":443}]'
    alb.ingress.kubernetes.io/ssl-redirect: '443'
    # Optional: Certificate discovery or ARN
    # alb.ingress.kubernetes.io/certificate-arn: arn:aws:acm:region:account:certificate/id
    alb.ingress.kubernetes.io/subnets: subnet-12345,subnet-67890
spec:
  ingressClassName: alb
  rules:
  - host: target-type-ip.stacksimplify.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app3-nginx-clusterip-service
            port:
              number: 80
      - path: /app1
        pathType: Prefix
        backend:
          service:
            name: app1-nginx-clusterip-service
            port:
              number: 80
      - path: /app2
        pathType: Prefix
        backend:
          service:
            name: app2-nginx-clusterip-service
            port:
              number: 80
---
```

#### Deployment Example (Simplified)
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app1-nginx-deployment
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
```

### Lab Demos

#### Step-by-Step Implementation
1. **Navigate to Directory**:
   ```bash
   cd /path/to/08-ELB-Application-LoadBalancers/08-13-Ingress-Target-Type-IP/kube-manifests
   ```

2. **Deploy Resources**:
   ```bash
   kubectl apply -f .
   ```

3. **Verify Deployments**:
   ```bash
   kubectl get pods -o wide  # Note pod IPs (e.g., app1: 192.168.92.27)
   kubectl get svc           # Confirm ClusterIP services
   kubectl get ingress       # Check Ingress creation
   ```

4. **Inspect ALB Targets (AWS Console)**:
   - Navigate to EC2 > Load Balancers > Target Groups.
   - For each app's target group, verify:
     - Targets registered are pod IPs directly (no NodePorts).
     - Health status: Healthy.

5. **Test URL Access**:
   - Resolve DNS: `nslookup target-type-ip.stacksimplify.com`
   - Browser tests:
     - `https://target-type-ip.stacksimplify.com/app1` → App1 response
     - `https://target-type-ip.stacksimplify.com/app2` → App2 response
     - `https://target-type-ip.stacksimplify.com/` → App3 response

6. **Cleanup**:
   ```bash
   kubectl delete -f .
   ```

> [!IMPORTANT]
  Ensure ALB target groups accurately reflect pod IPs, not intermediate services or NodePorts.

## Summary

### Key Takeaways
```diff
+ IP mode routes ALB traffic directly to pod IPs, enabling sticky sessions and Fargate support
+ ClusterIP services suffice for IP mode (NodePorts optional/unnecessary)
+ Target groups register pod IPs automatically in IP mode
! Explicit annotation required: alb.ingress.kubernetes.io/target-type: ip
- Avoid NodePort services for IP mode unless specifically needed
```

### Quick Reference
- **Target Type Annotation**: `alb.ingress.kubernetes.io/target-type: ip`
- **Commands**:
  - Deploy: `kubectl apply -f .`
  - Check pods/services: `kubectl get pods,svc -o wide`
  - DNS test: `nslookup <domain>`
- **AWS Verification**: ALB > Target Groups (check IPs match pods)

### Expert Insight
- **Real-World Application**: Use IP mode for microservices with session persistence or AWS Fargate-based clusters. Ideal for e-commerce apps requiring sticky sessions or stateless workloads needing direct pod access.
- **Expert Path**: Deepen knowledge by integrating IP mode with health checks (use pod probes). Experiment with scaling deployments and observe dynamic target group updates.
- **Common Pitfalls**: Forgetting the `target-type: ip` annotation (defaults to instance). Using NodePort unnecessarily increases complexity and ports. Ensure SSL cert ARNs match domains to avoid routing failures.

</details>
