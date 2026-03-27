# Section 28: Horizontal Pod Autoscaler

<details open>
<summary><b>Section 28: Horizontal Pod Autoscaler (G3PCS46)</b></summary>

## Table of Contents
- [28.1 Horizontal Pod Autoscaler - Introduction](#281-horizontal-pod-autoscaler---introduction)
- [28.2 Deploy Metrics Server and Sample Application](#282-deploy-metrics-server-and-sample-application)
- [28.3 Enable HPA, Load Test, Verify and Clean-Up](#283-enable-hpa-load-test-verify-and-clean-up)

## 28.1 Horizontal Pod Autoscaler - Introduction
### Overview
Horizontal Pod Autoscaler (HPA) is a Kubernetes feature that automatically adjusts the number of pods in a deployment, replica set, replication controller, or StatefulSet based on resource utilization metrics like CPU or custom metrics. It enables applications to scale out to handle increased demand or scale in to free up resources during low usage periods. This out-of-the-box Kubernetes API resource ensures optimal resource allocation by maintaining target utilization levels, such as a desired CPU percentage, without manual intervention.

### Key Concepts/Deep Dive
HPA operates through a control loop executed every 15 seconds, collecting metrics from pods via the Metrics Server and calculating the required number of replicas.
- **Scaling Logic**:
  - Monitors CPU utilization (or other metrics).
  - Compares current utilization to a target value (e.g., 50% CPU).
  - Uses `kubectl scale` internally to adjust pod counts.
- **Configuration Parameters**:
  - **Minimum Replicas**: The lowest number of pods allowed (e.g., 1 or 2).
  - **Maximum Replicas**: The highest number of pods allowed (e.g., 10).
  - **Target Metric**: Often CPU utilization percentage; can be expanded to custom metrics.
- **How It Works**:
  ```mermaid
  flowchart TD
    A[Application Pods] --> B[Metrics Server]
    B --> C[Horizontal Pod Autoscaler]
    C --> D{Utilization > Target?}
    D -->|Yes| E[Scale Out: Increase Pods]
    D -->|No| F[Scale In: Decrease Pods]
    E --> G[New Pods Deployed]
    F --> H[Extra Pods Terminated]
    G --> B
    H --> B
  ```
- **Benefits**:
  - Automatically handles traffic spikes without manual scaling.
  - Optimizes cluster resource usage across applications.
- **Prerequisites**: Requires Kubernetes Metrics Server for CPU and resource metrics collection.

### Code/Config Blocks
- **Imperative HPA Creation** (Example for a deployment named "demo-deployment"):
  ```
  kubectl autoscale deployment demo-deployment --cpu-percent=50 --min=2 --max=10
  ```
  - Sets target CPU utilization to 50%, scales between 2-10 pods.

## 28.2 Deploy Metrics Server and Sample Application
### Overview
To enable HPA functionality, the Kubernetes Metrics Server must be deployed first, as it collects pod resource metrics like CPU and memory. This section details the deployment of Metrics Server v0.3.6 and a sample Nginx application configured with resource limits, ensuring metrics are available for autoscaling decisions. The application uses a standard deployment with a NodePort service for internal access, and resource requests/limits are defined to allow HPA to monitor utilization effectively.

### Key Concepts/Deep Dive
Metrics Server is essential for HPA, as it provides real-time pod metrics not natively available in Kubernetes.
- **Metrics Server Deployment**:
  - Install via YAML manifests from official releases.
  - Creates cluster roles, bindings, and a deployment in the `kube-system` namespace.
  - Verifies installation with: `kubectl get pods -n kube-system`.
- **Sample Application Setup**:
  - **Deployment**: Uses Nginx image with resource constraints (e.g., CPU request: not specified in transcript, memory request/limit: up to 200Mi).
  - **Service**: NodePort type on port 31231 for internal cluster access.
  - Ensures pods report metrics to the Metrics Server for HPA calculation.
- **Verification Steps**:
  - Check pods: `kubectl get pods`.
  - Check services: `kubectl get svc`.
  - Note: Application is in private subnets; external access may require LoadBalancer service.

### Code/Config Blocks
- **Deploy Metrics Server** (v0.3.6):
  ```
  kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.6/components.yaml
  ```
- **Sample Application Manifest** (`hpa-demo.yml`):
  ```yaml
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: hpa-demo-deployment
  spec:
    replicas: 1
    selector:
      matchLabels:
        app: hpa-demo
    template:
      metadata:
        labels:
          app: hpa-demo
      spec:
        containers:
        - name: nginx
          image: nginx
          ports:
          - containerPort: 80
          resources:
            requests:
              memory: "64Mi"  # Assume default, not specified
            limits:
              memory: "200Mi"
  ---
  apiVersion: v1
  kind: Service
  metadata:
    name: hpa-demo-service
  spec:
    type: NodePort
    ports:
    - port: 80
      targetPort: 80
      nodePort: 31231
    selector:
      app: hpa-demo
  ```
- **Verification Commands**:
  ```
  kubectl get pods -n kube-system | grep metrics-server
  kubectl get deployment hpa-demo-deployment
  kubectl get svc hpa-demo-service
  ```

## 28.3 Enable HPA, Load Test, Verify and Clean-Up
### Overview
This section demonstrates enabling HPA on the sample deployment, generating load with Apache Bench to trigger scaling, and observing the automatic adjustments. It covers imperative HPA creation, monitoring with describe/list commands, load testing, and cooldown behavior after load removal. Cleanup includes deleting HPA resources and manifests, with notes on future declarative YAML support in Kubernetes 1.18+.

### Key Concepts/Deep Dive
HPA dynamically scales pods based on CPU utilization, with a control loop running every 15 seconds.
- **Enabling HPA**:
  - Create HPA imperatively targeting 50% CPU utilization.
  - Monitors and adjusts replicas between min (1) and max (10).
- **Monitoring HPA**:
  - List HPAs: `kubectl get hpa`.
  - Describe HPA: `kubectl describe hpa hpa-demo-deployment` (shows utilization, events, and scaling decisions).
- **Load Testing with Apache Bench** (inside cluster):
  ```
  ab -n 50000 -c 10 http://hpa-demo-service.default.svc.cluster.local/
  ```
  - Simulates 50,000 requests with 10 concurrent connections.
  - Observe scaling up from 1 pod to 10 as CPU exceeds 50% (e.g., 92% → 2 pods; 191% → 8 pods; max at 10).
- **Cooldown and Scale-Down**:
  - Default cooldown period: 5 minutes after utilization falls below target.
  - Automatically reduces pods to minimum (1) when metrics stabilize.
  - Events in describe show "All metrics below target" triggering scale-in.
- **Scaling Scenarios** (from demo):
  - 0% CPU: 1 pod (min steady state).
  - 92% CPU: Scale to 2 pods.
  - 191% CPU: Scale to 8, then 10 pods.
  - Post-load: Cooldown → 1 pod.
- **Cleanup**:
  - Delete HPA: `kubectl delete hpa hpa-demo-deployment`.
  - Delete manifests: `kubectl delete -f ./kube-manifests/15-EKS-HPA-Horizontal-Pod-AutoScaler/hpa-demo.yml`.
- **Future Improvements**: Kubernetes 1.18+ supports declarative HPA YAML (beta feature for declarative definitions instead of imperative commands).

### Code/Config Blocks
- **Enable HPA Imperatively**:
  ```
  kubectl autoscale deployment hpa-demo-deployment --cpu-percent=50 --min=1 --max=10
  ```
- **Monitor HPA**:
  ```
  kubectl get hpa hpa-demo-deployment
  kubectl describe hpa hpa-demo-deployment
  ```
- **Load Test (Run inside pod; assumes ab installed)**:
  ```
  kubectl run load-test --image=httpd:alpine --command -- sh -c 'while true; do wget -qO- http://hpa-demo-service.default.svc.cluster.local/; done'
  # Or use ab: kubectl run ab-test --image=busybox -- ab -n 50000 -c 10 http://hpa-demo-service.default.svc.cluster.local/
  ```
- **Cleanup**:
  ```
  kubectl delete hpa hpa-demo-deployment
  kubectl delete -f hpa-demo.yml
  ```
- **Sample HPA Events Output** (from describe):
  ```
  Events:
    Type    Reason             From                       Message
    ----    ------             ----                       -------
    Normal  SuccessfulRescale TooManyReplicas            New size: 1 (reason: All metrics are below target)
    Normal  SuccessfulRescale AbovaAllMetrics            New size: 2 (reason: cpu resource utilization (percentage of request) above target)
  ```

## Summary
### Key Takeaways
```diff
+ Horizontal Pod Autoscaler (HPA) scales pods based on metrics like CPU utilization to maintain target levels.
+ Metrics Server is required for collecting pod metrics; install it from official releases.
+ Configure HPA imperatively with kubectl autoscale or declaratively in newer Kubernetes versions.
+ Scaling control loop runs every 15 seconds; includes a 5-minute cooldown for scale-down.
- Avoid misconfigurations like setting unrealistic min/max replicas that could lead to resource exhaustion.
! Always verify HPA events and current metrics with describe commands during testing.
```

### Quick Reference
- **Install Metrics Server**: `kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.6/components.yaml`
- **Enable HPA**: `kubectl autoscale deployment <name> --cpu-percent=50 --min=1 --max=10`
- **Monitor HPA**: `kubectl get hpa` / `kubectl describe hpa <name>`
- **Load Test**: Use Apache Bench or custom pods to simulate traffic: `ab -n 50000 -c 10 <service-url>`
- **Cleanup**: `kubectl delete hpa <name>` and delete manifests.

### Expert Insight
- **Real-World Application**: In production, use HPA with CPU and custom metrics (e.g., via Prometheus adapter) for microservices like e-commerce APIs, ensuring high availability during traffic spikes without over-provisioning resources—integrate with cluster autoscaling for node level adjustments.
- **Expert Path**: Master HPA by experimenting with external metrics (e.g., request queue length), combining with VPA (Vertical Pod Autoscaler) for memory-based scaling, and monitoring with tools like Grafana. Dive into Kubernetes API extensions for custom metric APIs.
- **Common Pitfalls**: Sizing min/max incorrectly can cause thrashing (frequent scale-up/down); ignore transient spikes with stabilization windows. Ensure Metrics Server is securely configured, as it exposes resource data—avoid exposing it externally without RBAC. Test scale-down thoroughly to prevent service disruptions during cooldown.

</details>
