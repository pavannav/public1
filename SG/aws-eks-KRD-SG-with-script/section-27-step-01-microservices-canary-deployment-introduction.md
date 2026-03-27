# Section 27: Microservices Canary Deployment

<details open>
<summary><b>Section 27: Microservices Canary Deployment (G3PCS46)</b></summary>

## Table of Contents
- [27.1 Introduction to Microservices Canary Deployments](#271-introduction-to-microservices-canary-deployments)
- [27.2 Pre-requisites Check](#272-pre-requisites-check)
- [27.3 Review Kubernetes Manifests - Notification Microservice V2](#273-review-kubernetes-manifests---notification-microservice-v2)
- [27.4 Deploy & Test Kubernetes Manifests for Microservices Canary Deployments](#274-deploy--test-kubernetes-manifests-for-microservices-canary-deployments)
- [27.5 Downside & Best Approaches](#275-downside--best-approaches)
- [Summary](#summary)

## 27.1 Introduction to Microservices Canary Deployments

### Overview
Canary deployments enable incremental rollouts of new application versions in microservices architectures, directing a small portion of live traffic to the new version while the majority continues using the stable version. This approach minimizes risk by allowing early detection of deployment issues, affecting only a subset of users. In this section, we'll demonstrate canary deployment using user management and notification microservices in Amazon EKS, splitting traffic between V1 (stable) and V2 (canary) versions without external service mesh tools.

### Key Concepts
- **Canary Deployment Basics**: A subset of users interacts with the new version while most traffic remains on the stable release. For example, 75% of traffic to V1 notification microservice and 25% to V2 notification microservice.
- **Traffic Routing Strategy**: Uses Kubernetes replica manipulation to control traffic distribution proportionally to pod counts.
- **Benefits**:
  - Early issue detection with minimal user impact
  - Quick rollback capability to stable version
  - Gradual rollout testing in production environment
- **Microservices Example**: User management microservice calls notification microservice, with V2 introduced as the canary version.

### Lab Demos
> [!NOTE]
> This section sets up the conceptual foundation. Practical deployment begins in subsequent steps.

## 27.2 Pre-requisites Check

### Overview
Before implementing canary deployments, verify that all supporting infrastructure is operational. This includes database connectivity, ingress controllers for external access, and observability tools for monitoring traffic distribution. These components ensure the canary setup functions correctly in a production-like environment.

### Key Concepts
- **AWS RDS Database**: Required for persistent data storage; alternative in-memory database (4.0.0-xray-h2db) available for testing (data not persisted).
- **ALB Ingress Controller**: Manages external traffic routing and load balancing into the cluster.
- **External DNS**: Automatically registers domain names (e.g., canarydemo.kubecloud.com) in Route 53.
- **X-Ray Daemon**: Provides distributed tracing to visualize traffic flow between microservices versions.

### Verification Steps
- ✅ Confirm ALB Ingress Controller running in `kube-system` namespace
- ✅ Confirm External DNS running in `default` namespace  
- ✅ Confirm X-Ray Daemon running in `default` namespace
- ✅ Optionally verify RDS connectivity or switch to H2 database image

## 27.3 Review Kubernetes Manifests - Notification Microservice V2

### Overview
Examine the Kubernetes manifests for deploying both V1 and V2 notification microservices with balanced traffic distribution. Manifests include deployments with replica configuration, environment variables for tracing, and ingress configuration for external access. Ensure proper labeling for service discovery and load balancing.

### Key Concepts
- **Deployment Configuration**:
  - V1 Notification: 2 replicas, image `3.0.0-aws-xray`
  - V2 Notification: 2 replicas, image `4.0.0-aws-xray`
  - Traffic split: 50% to V1, 50% to V2 based on replica counts
- **Environment Variables for X-Ray Tracing**:
  ```yaml
  - name: AWS_XRAY_CONTEXT_MISSING
    value: "RUNTIME_ERROR"
  - name: AWS_XRAY_DAEMON_ADDRESS
    value: "xray-daemon.default:2000"
  - name: AWS_XRAY_TRACING_NAME
    value: "v2-notification-microservice"  # V2-specific naming
  ```
- **Labels and Selectors**:
  - Deployment label: `app: notification-rest-app`
  - Service selector matches this label for traffic distribution
- **Ingress Configuration**:
  - Update SSL certificate references
  - Configure external DNS domain (e.g., canarydemo.kubecloud.com)
  - Optional: Rename ingress resource to indicate canary functionality

### Lab Demos
**Review Manifest Structure**:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: v2-notification-microservice-deploy
spec:
  replicas: 2
  selector:
    matchLabels:
      app: notification-rest-app
  template:
    metadata:
      labels:
        app: notification-rest-app
    spec:
      containers:
      - name: notification-microservice
        image: stack simplifying/aws-xray-app:4.0.0-aws-xray
        env:
        # X-Ray env vars here
```

## 27.4 Deploy & Test Kubernetes Manifests for Microservices Canary Deployments

### Overview
Deploy the canary configuration to EKS and validate that traffic distributes correctly between V1 and V2 notification microservices. Use browser testing and X-Ray service maps to confirm the split, then observe the underlying Kubernetes service behavior.

### Key Concepts
- **Traffic Distribution Mechanism**: ClusterIP service with `app: notification-rest-app` selector routes to pods from both deployments
- **Load Balancing**: Kubernetes service evenly distributes requests across all matching pods (4 total: 2 V1 + 2 V2)
- **X-Ray Visualization**: Service map shows separate nodes for V1 and V2 notification microservices

### Lab Demos
**Deploy Manifests**:
```bash
kubectl apply -f kube-manifests/
```

**Verify DNS Resolution**:
```bash
nslookup canarydemo.kubecloud.com
# Expected: A record pointing to ALB
```

**Test Traffic Distribution**:
1. Access app via browser: `https://canarydemo.kubecloud.com/notification-xray`
2. Refresh page multiple times - observe alternating V1/V2 version responses
3. Expected result: ~50% traffic to each version

**Validate X-Ray Service Map**:
- Generate traffic load
- Check X-Ray console: Service map shows user-management → (V1-notification-microservice, V2-notification-microservice)

**Background Explanation**:
```diff
! Traffic Flow: Client → ALB → User Management Service → Notification ClusterIP → V1/V2 Notification Pods
+ Service Selector: app=notification-rest-app matches pods from both deployments
+ Distribution: Proportional to replica counts (2:2 = 50:50 split)
```

**Cleanup**:
```bash
kubectl delete -f kube-manifests/
```

## 27.5 Downside & Best Approaches

### Overview
While basic canary deployments using replica manipulation work for simple scenarios, they become inefficient at scale. Explore limitations and professional alternatives for production-grade traffic management in microservices architectures.

### Key Concepts
- **Basic Approach Limitations**:
  - Replica-based traffic control requires pod count adjustments for precise percentages
  - Example: 75% prod/25% canary needs 3 prod pods + 1 canary pod (4 total pods)
  - 90% prod/10% canary needs 9 prod pods + 1 canary pod (10 total pods)
  - Leads to resource waste and uneven load distribution
- **Service Mesh Benefits**:
  - Maintain constant pod counts regardless of traffic percentages
  - Fine-grained traffic control (e.g., 95% prod/5% canary with minimal pod changes)
  - Load balancing handled by sidecar proxies, not pod ratios
- **Recommended Solutions**:
  - **Istio**: Open-source service mesh with advanced traffic management
  - **AWS App Mesh**: AWS-native service mesh tightly integrated with EKS and other AWS services

### Comparison: Basic vs Service Mesh

| Aspect | Basic Replica Approach | Service Mesh (Istio/AWS App Mesh) |
|--------|------------------------|-----------------------------------|
| Pod Scaling | Adjust replicas for each % change | Constant pod count |
| Traffic Control | Pod-based rough approximation | Precise percentage routing |
| Complexity | Simple, built-in | Higher setup complexity |
| Scalability | Poor with fine-grained control | Excellent, independent of pod count |
| Resource Efficiency | Lower (unnecessary pods) | Higher (optimized pod utilization) |

## Summary

### Key Takeaways
```diff
+ Canary deployments enable safe incremental rollouts by routing small traffic portions to new versions
+ Basic canary in Kubernetes uses replica manipulation for traffic distribution via shared service selectors
+ Service meshes like Istio or AWS App Mesh provide superior traffic control without pod scaling limitations
+ X-Ray integration provides visibility into version-specific traffic flows and performance metrics
! Always validate prerequisites (ALB ingress, external DNS, X-Ray) before deployment
- Avoid replica-based canary for complex traffic distributions requiring many pods
```

### Quick Reference
**Traffic Distribution Setup**:
```bash
# Deploy with 50/50 split
kubectl apply -f notification-v1-deploy.yaml  # 2 replicas
kubectl apply -f notification-v2-deploy.yaml  # 2 replicas
```

**Service Selector Configuration**:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: notification-service
spec:
  selector:
    app: notification-rest-app  # Matches both deployments
  ports:
  - port: 80
    targetPort: 8080
```

**X-Ray Environment Variables** (V2 Deployment):
```yaml
env:
- name: AWS_XRAY_TRACING_NAME
  value: "v2-notification-microservice"
```

### Expert Insights
**Real-world Application**:
In production microservices, canary deployments typically start with 5-10% traffic to the new version, gradually increasing after monitoring for errors, latency, and resource usage. Use metrics from X-Ray, CloudWatch, and application logs to inform promotion decisions.

**Expert Path**:
- Master label selectors and service matching for zero-downtime deployments
- Learn Istio virtual services and destination rules for advanced traffic splitting
- Combine canary with blue-green patterns using ingress rewrites
- Implement automated canary analysis using Prometheus metrics and alerting

**Common Pitfalls**:
- ❌ Forgetting to update X-Ray tracing names for proper observability
- ❌ Using mismatched labels between deployments and services
- ❌ Underestimating ALB warmup time after deployment
- ❌ Not monitoring resource utilization across uneven pod distributions

</details>
