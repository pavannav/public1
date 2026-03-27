# Section 29: Vertical Pod Autoscaler 

<details open>
<summary><b>Section 29: Vertical Pod Autoscaler (G3PCS46)</b></summary>

## Table of Contents
- [29.1 Vertical Pod Autoscaler - Introduction](#291-vertical-pod-autoscaler---introduction)
- [29.2 Install VPA Components & Sample Demo Application](#292-install-vpa-components--sample-demo-application)
- [29.3 Create VPA Manifest, Deploy, Load Test, Analyze and Clean-Up](#293-create-vpa-manifest-deploy-load-test-analyze-and-clean-up)
- [Summary](#summary)

## 29.1 Vertical Pod Autoscaler - Introduction

### Overview
Vertical Pod Autoscaler (VPA) is an auto-scaling component in Kubernetes that automatically adjusts CPU and memory reservations for pods to optimize resource utilization. It helps ensure pods use exactly the resources they need, improving cluster efficiency without manual benchmarking. Unlike Horizontal Pod Autoscaler (HPA), VPA is not a built-in Kubernetes resource and requires additional installation.

### Key Concepts/Deep Dive
VPA addresses the challenge of right-sizing applications by dynamically adjusting resource requests and limits based on observed usage patterns. This reduces maintenance overhead and prevents over-provisioning of resources.

#### Main Benefits
- **Efficient Resource Utilization**: Clusters use nodes more effectively as pods receive only necessary resources.
- **Automatic Scheduling**: Pods are scheduled on nodes with appropriate resources available.
- **Reduced Maintenance**: Eliminates the need for time-consuming benchmarking to determine optimal CPU and memory values.
- **Continuous Adjustment**: Resource allocations adapt over time without manual intervention.

#### VPA Components
VPA consists of three core components that must be installed separately:

1. **VPA Admission Controller**: A webhook that intercepts pod creation requests. It checks if the pod is referenced by a Vertical Pod Autoscaler object and applies resource adjustments before the pod starts.

2. **VPA Recommender**: Connects to the metrics server in the Kubernetes cluster to fetch historical and current CPU and memory usage data for VPA-enabled pods. It generates recommendations for scaling up or down resource requests and limits.

3. **VPA Updater**: Runs periodically (every minute by default) and evicts pods that are not running within the recommended resource range. This triggers pod recreation through the VPA Admission Controller with updated resources.

#### How VPA Works
- When a pod is submitted, the admission controller checks for VPA references.
- The recommender analyzes usage metrics and provides scaling recommendations.
- The updater evicts and recreates pods to apply recommended resources.
- This process ensures pods are always sized appropriately based on workload demands.

> [!NOTE]
> VPA focuses on vertical scaling (increasing resources per pod) rather than horizontal scaling (adding more pods).

## 29.2 Install VPA Components & Sample Demo Application

### Overview
This section covers installing the necessary components for VPA and deploying a sample demo application to test its functionality. We start with verifying the metrics server installation, then clone and deploy VPA components, and finally set up a basic Nginx deployment with intentionally low resource requests to demonstrate auto-scaling.

### Key Concepts/Deep Dive
Successful VPA implementation requires proper component installation and a metrics source for resource monitoring.

#### Prerequisites Check
```bash
kubectl get pods -n kube-system
```
Verify that the metrics-server pod is running, as it's required for VPA to collect resource usage data.

#### VPA Installation
1. Clone the autoscaler repository:
   ```bash
   git clone https://github.com/kubernetes/autoscaler.git
   cd autoscaler/vertical-pod-autoscaler
   ```

2. Install VPA components:
   ```bash
   ./hack/vpa-up.sh
   ```

3. Verify installation:
   ```bash
   kubectl get pods -n kube-system
   ```
   Expected pods: vpa-admission-controller, vpa-recommender, and vpa-updater.

#### Demo Application Deployment
The sample application is a basic Nginx deployment designed to demonstrate VPA's resource adjustment capabilities.

**Deployment Manifest (vpa-demo-app.yaml)**:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: vpa-demo-deployment
spec:
  replicas: 4
  selector:
    matchLabels:
      app: vpa-demo
  template:
    metadata:
      labels:
        app: vpa-demo
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "5Mi"
            cpu: "0.005"
          limits:
            memory: "5Mi"
            cpu: "0.005"
---
apiVersion: v1
kind: Service
metadata:
  name: vpa-demo-service
spec:
  selector:
    app: vpa-demo
  ports:
  - port: 80
    targetPort: 80
  type: NodePort
```

Key points:
- **Intentionally Low Resources**: Initial requests are set very low (5Mi memory, 0.005 CPU) to simulate under-provisioning.
- **Replica Count**: 4 replicas to demonstrate rolling updates during scaling.
- **Service Configuration**: NodePort for external access (if cluster supports public subnets).

#### Deployment Steps
1. Apply the manifest:
   ```bash
   kubectl apply -f vpa-demo-app.yaml
   ```

2. Verify deployment:
   ```bash
   kubectl get pods,svc,deployments
   kubectl describe pod <pod-name>
   ```
   Note the initial resource allocations in the pod description.

> [!IMPORTANT]
> Access to the application externally depends on cluster networking. For private subnets, generate load internally using tools like Apache Bench within the cluster.

## 29.3 Create VPA Manifest, Deploy, Load Test, Analyze and Clean-Up

### Overview
This section demonstrates creating and deploying a VPA manifest, generating load to trigger auto-scaling, analyzing the results, and performing cleanup. We'll observe how VPA automatically adjusts pod resources based on workload demands without manual intervention.

### Key Concepts/Deep Dive
VPA manifests define scaling policies that govern how resources are adjusted for specific workloads.

#### VPA Manifest Configuration
Create a manifest to define VPA targets and resource policies.

**VPA Manifest (vpa-manifest.yaml)**:
```yaml
apiVersion: autoscaling.k8s.io/v1beta1
kind: VerticalPodAutoscaler
metadata:
  name: vpa-demo
spec:
  targetRef:
    apiVersion: "apps/v1"
    kind: Deployment
    name: vpa-demo-deployment
  resourcePolicy:
    containerPolicies:
    - containerName: nginx
      controlledResources: ["cpu", "memory"]
      minAllowed:
        cpu: 5m
        memory: 5Mi
      maxAllowed:
        cpu: 1000m
        memory: 500Mi
```

Key configuration elements:
- **targetRef**: References the target deployment (vpa-demo-deployment).
- **resourcePolicy**: Defines scaling rules per container.
  - **controlledResources**: Specifies which resources VPA manages (CPU and memory).
  - **minAllowed**: Minimum resource bounds (matches deployment requests).
  - **maxAllowed**: Maximum resource limits to prevent over-scaling.

#### Lab Demo: Deploy VPA and Generate Load
1. **Deploy VPA Manifest**:
   ```bash
   kubectl apply -f vpa-manifest.yaml
   kubectl get vpa
   kubectl describe vpa vpa-demo
   ```
   Verify VPA creation and configuration details.

2. **Monitor Initial State**:
   ```bash
   kubectl get pods -w
   kubectl describe pod <pod-name>
   ```
   Observe initial resource allocations (5Mi memory, 5m CPU).

3. **Generate Load**:
   Use Apache Bench containers to simulate traffic. Run multiple instances for increased load:
   ```bash
   # Terminal 1
   kubectl run apache-bench-1 --image=httpd:2.4-alpine --restart=Never -- sleep infinity
   kubectl exec -it apache-bench-1 -- ab -n 100000 -c 10 http://vpa-demo-service/

   # Terminal 2
   kubectl run apache-bench-2 --image=httpd:2.4-alpine --restart=Never -- sleep infinity
   kubectl exec -it apache-bench-2 -- ab -n 100000 -c 10 http://vpa-demo-service/

   # Additional terminals as needed
   ```

4. **Observe Auto-Scaling**:
   Monitor pod recreation and resource adjustments:
   ```bash
   kubectl get pods -w
   kubectl describe pod <new-pod-name>
   ```
   Watch for pod evictions and new pods with updated resources (e.g., 25Mi memory, 264m CPU).

#### Analysis and Key Behaviors
- **Rolling Updates**: VPA updater performs scaling in batches to maintain availability.
  - With multiple replicas (4), it scales pods incrementally.
  - Evicts and recreates pods with new resource allocations.
- **Load-Driven Adjustments**: Resources increase based on actual usage patterns.
- **Minimum Pod Count Consideration**: 
  - For deployments with ≥2 replicas: Automatic eviction and recreation.
  - For single-pod deployments: Manual intervention required to avoid downtime.
- **Eviction Process**:
  - First batch: ~2 pods evicted and recreated.
  - Wait period: VPA respects rollout timing.
  - Second batch: Remaining pods updated.

### Troubleshooting Notes
- Ensure metrics server is running for accurate recommendations.
- VPA requires time to collect usage data before generating recommendations.
- Load testing should simulate realistic application usage.

#### Clean-Up
Remove all resources to avoid cluster resource consumption:
```bash
kubectl delete -f vpa-manifest.yaml
kubectl delete -f vpa-demo-app.yaml
```

## Summary

### Key Takeaways
```diff
+ VPA automatically adjusts CPU and memory requests/limits for optimal resource utilization
+ Reduces manual benchmarking and maintenance overhead
+ Components: Admission Controller (applies changes), Recommender (analyzes metrics), Updater (evicts pods)
+ Works in rolling update fashion to maintain application availability
- Requires separate installation (not built-in like HPA)
- Single-pod deployments need manual intervention for scaling
! Use metrics server as data source for recommendations
```

### Quick Reference
- **Check VPA Status**: `kubectl get vpa && kubectl describe vpa <name>`
- **Monitor Pod Resources**: `kubectl describe pod <name> | grep -A 10 "Containers:"`
- **Generate Load**: `kubectl exec -it <bench-pod> -- ab -n 100000 -c 10 http://<service>/`
- **Install VPA**: `./hack/vpa-up.sh` (from cloned autoscaler repo)
- **Typical VPA Policy Bounds**: Min 5m CPU/5Mi memory, Max 1000m CPU/500Mi memory

### Expert Insight
**Real-world Application**: In production, VPA is ideal for microservices with variable workloads. Use alongside HPA for comprehensive auto-scaling (horizontal + vertical). Monitor resource usage graphs to validate VPA effectiveness in cost optimization.

**Expert Path**: Master VPA by experimenting with resource policies across different workload types. Study metrics server integration and consider custom collecters for specialized applications. Learn to tune VPA update frequencies for different environments.

**Common Pitfalls**: 
- ❌ Forgetting metrics server dependency leads to failed recommendations
- ❌ Setting max limits too high causes resource waste
- ❌ Applying VPA to single-pod deployments without manual pod restarts
- ❌ Ignoring rolling update behavior may cause temporary performance impacts during scaling

</details>
