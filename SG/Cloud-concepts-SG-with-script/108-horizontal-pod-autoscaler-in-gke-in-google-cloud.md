# Session 108: Horizontal Pod Autoscaler in GKE on Google Cloud

## Table of Contents
- [Introduction to Horizontal Pod Autoscaler (HPA) in GKE](#introduction-to-horizontal-pod-autoscaler-hpa-in-gke)
- [Why Use Horizontal Pod Autoscaling?](#why-use-horizontal-pod-autoscaling)
- [How HPA Works](#how-hpa-works)
- [Best Practices for HPA](#best-practices-for-hpa)
- [HPA API Versions](#hpa-api-versions)
- [Limitations of HPA](#limitations-of-hpa)
- [Lab Demo: Enabling HPA with CPU Metrics](#lab-demo-enabling-hpa-with-cpu-metrics)
- [Lab Demo: HPA with Multiple Metrics](#lab-demo-hpa-with-multiple-metrics)
- [Lab Demo: Container-Specific Metrics in HPA](#lab-demo-container-specific-metrics-in-hpa)
- [Summary](#summary)

## Introduction to Horizontal Pod Autoscaler (HPA) in GKE

### Overview
The Horizontal Pod Autoscaler (HPA) is a Kubernetes feature that automatically adjusts the number of pod replicas in a deployment, replica set, or stateful set based on observed CPU utilization or other custom metrics. In Google Kubernetes Engine (GKE), HPA integrates with cluster autoscaling to dynamically manage resources. When CPU or memory consumption increases, HPA scales up by adding more pods, and when demand decreases, it scales down by removing excess pods. This ensures efficient resource utilization and cost savings in cloud environments. HPA works well for stateless applications such as web frontends, APIs, and microservices that can scale horizontally.

HPA can trigger node autoprovisioning in GKE, automatically adding new nodes or node pools when existing cluster capacity is insufficient to schedule the additional pods. This feature is particularly useful for handling unpredictable or varying traffic patterns.

### Key Concepts/Deep Dive
- **Automatic Scaling**: HPA monitors resource metrics and adjusts the replica count without manual intervention.
- **Resource-Based Metrics**: Primarily uses CPU and memory utilization thresholds to decide scaling actions.
- **Integration with Cluster Autoscaling**: Ensures new nodes are available when pods need to scale up.
- **Stateless Workload Focus**: Ideal for applications that can be replicated easily across multiple pods.

## Why Use Horizontal Pod Autoscaling?

### Overview
Horizontal Pod Autoscaling is essential for managing uncertain workloads where traffic patterns fluctuate. Instead of manually sizing replicas, HPA dynamically adjusts the number of pods based on actual demand, optimizing performance and cost.

### Key Concepts/Deep Dive
- **Cost Efficiency**: Pay only for resources when needed; scale down during low-traffic periods to avoid overprovisioning.
- **Reliability**: Prevents underprovisioning (e.g., by ensuring a minimum number of replicas) and overprovisioning (e.g., running too many pods during off-peak times).
- **Flexibility**: Supports resource-based metrics (CPU, memory), custom metrics (e.g., requests per second), and extended metrics (e.g., Pub/Sub backlog or queue size).
- **Dynamic Adaptation**: Adapts to changing demands without prior knowledge of exact resource needs at different traffic levels.

## How HPA Works

### Overview
HPA operates as a control loop in Kubernetes that continuously monitors metrics, evaluates them against predefined thresholds, and adjusts the replica count accordingly. It fetches metrics from the Kubernetes Metrics Server or custom/external sources and computes a recommended replica count. If the current metrics exceed or fall below thresholds, it scales the deployment up or down.

### Key Concepts/Deep Dive
- **Metrics Fetching and Evaluation**: Retrieves CPU, memory, custom, or external metrics and compares them to target thresholds (e.g., 70% CPU utilization).
- **Replica Count Computation**: Based on the evaluation, decides whether to scale up, scale down, or maintain the current state.
- **Scaling Action**: Updates the `.spec.replicas` field in the deployment or related resource.
- **Control Loop Process**: Measure → Evaluate → Compute → Act.

> [!NOTE]
> Scaling decisions are based on averages, such as average CPU utilization across all pods in the deployment.

## Best Practices for HPA

### Overview
To effectively implement HPA, follow these best practices for configuration, monitoring, and integration to ensure stable and efficient autoscaling.

### Key Concepts/Deep Dive
- **Define Resource Requests and Limits**: HPA calculates CPU percentages based on these; always set `requests.cpu` and `limits.cpu/memory` in pod specifications.
- **Use Cluster Autoscaler**: Enables automatic node addition when pods scale up, preventing scheduling failures.
- **Start with CPU-Based Scaling**: Gradually introduce custom metrics after understanding CPU-based behavior.
- **Set Appropriate Min/Max Replicas**: Define sensible bounds (e.g., min: 1, max: 10) to prevent over-scaling or under-scaling.
- **Monitor Thresholds**: Carefully observe metrics and adjust thresholds based on workload patterns.
- **Combine with Node Autoprovisioning**: Automatically provisions new node pools if needed for pod scheduling.

## HPA API Versions

### Overview
HPA has evolved through API versions, with `autoscaling/v2` being the latest and recommended for new deployments due to enhanced metric support.

### Key Concepts/Deep Dive
- **Autoscaling/v1**: Legacy version supporting only CPU utilization-based autoscaling; still supported but limited.
- **Autoscaling/v2 (and v2beta2)**: Supports CPU, memory, multiple metrics (e.g., combinations), custom metrics, and external metrics (e.g., Pub/Sub).

| API Version      | Supported Metrics          | Recommendations |
|------------------|----------------------------|-----------------|
| autoscaling/v1  | CPU utilization only      | Use for simple CPU-based scaling |
| autoscaling/v2  | CPU, memory, custom, external | Recommended for all new HPA implementations |

## Limitations of HPA

### Overview
While powerful, HPA has constraints that must be considered to avoid conflicts, misconfigurations, or unexpected behavior in production.

### Key Concepts/Deep Dive
- **Do Not Combine with Vertical Pod Autoscaler (VPA)**: HPA scales pod count horizontally, while VPA adjusts pod resources vertically; they can conflict (e.g., HPA adding pods while VPA increases resource limits).
- **Apply to Deployments, Not ReplicaSets**: Use on deployments to ensure scaling persists; ReplicaSets may be replaced dynamically.
- **Cannot Scale DaemonSets**: Fixed at one pod per node.
- **Metric Naming Rules**: Kubernetes source metrics cannot include uppercase letters or forward slashes (`/`).
- **Unavailable Metrics Behavior**: If a configured metric becomes unavailable, HPA does not scale down (to avoid disruption) but can still scale up.
- **Multi-Container Pods**: Metrics are averaged across all containers; specify container-specific metrics to avoid averaging issues.

## Lab Demo: Enabling HPA with CPU Metrics

### Overview
This demo creates a basic deployment, applies HPA based on CPU utilization, and demonstrates scaling by simulating traffic.

### Lab Demo Steps
1. **Create a Deployment**: Use a YAML file with resource requests.
   ```yaml:deploy.yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: cpu-demo
   spec:
     replicas: 1
     selector:
       matchLabels:
         app: cpu-demo
     template:
       metadata:
         labels:
           app: cpu-demo
       spec:
         containers:
         - name: cpu-demo
           image: k8s.gcr.io/hpa-example  # Public image for demo
           resources:
             requests:
               cpu: 200m
               memory: 512Mi
             limits:
               cpu: 1000m
               memory: 1Gi
   ```

2. **Create a Service**: Expose the deployment for traffic.
   ```yaml:service.yaml
   apiVersion: v1
   kind: Service
   metadata:
     name: cpu-demo-service
   spec:
     selector:
       app: cpu-demo
     ports:
     - port: 80
       targetPort: 8080
     type: ClusterIP
   ```

3. **Apply Resources**:
   ```bash
   kubectl apply -f deploy.yaml
   kubectl apply -f service.yaml
   kubectl get pods  # Verify one pod is running
   ```

4. **Enable HPA via YAML**:
   ```yaml:hpa.yaml
   apiVersion: autoscaling/v2
   kind: HorizontalPodAutoscaler
   metadata:
     name: cpu-demo-hpa
   spec:
     scaleTargetRef:
       apiVersion: apps/v1
       kind: Deployment
       name: cpu-demo
     minReplicas: 1
     maxReplicas: 10
     metrics:
     - type: Resource
       resource:
         name: cpu
         target:
           type: Utilization
           averageUtilization: 50
   ```

5. **Apply HPA and Verify**:
   ```bash
   kubectl apply -f hpa.yaml
   kubectl get hpa  # Check initial state (CPU unknown, replicas may show as 0 initially but updates to 1)
   ```

6. **Simulate Traffic**:
   - Create a busybox pod for load testing:
     ```bash
     kubectl run load-test --image=busybox --command -- while true; do curl http://cpu-demo-service; done
     kubectl exec -it load-test -- sh  # Enter pod and run the loop
     ```
   - Monitor scaling:
     ```bash
     kubectl get hpa --watch  # Observe CPU >50% triggering scale-up to multiple replicas (e.g., up to 10)
     ```

7. **Observe Scaling Behavior**: CPU utilization >50% increases replicas; once <50%, stops scaling up. Scaling down takes ~5 minutes after traffic stops.

8. **Cleanup**:
   ```bash
   kubectl delete -f deploy.yaml -f service.yaml -f hpa.yaml
   kubectl delete pod load-test
   ```

## Lab Demo: HPA with Multiple Metrics

### Overview
This demo configures HPA to scale based on both CPU and memory utilization, using a deployment that self-generates load.

### Lab Demo Steps
1. **Create a Deployment with Self-Generating Load**:
   ```yaml:deploy2.yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: dual-metric-demo
   spec:
     replicas: 1
     selector:
       matchLabels:
         app: dual-metric-demo
     template:
       metadata:
         labels:
           app: dual-metric-demo
       spec:
         containers:
         - name: stress-ng
           image: polinux/stress-ng  # Image that runs stress-ng on startup
           command: ["stress-ng", "--cpu", "2", "--vm", "1", "--vm-bytes", "200M", "--timeout", "300s"]
           resources:
             requests:
               cpu: 200m
               memory: 256Mi
             limits:
               cpu: 1000m
               memory: 512Mi
   ```

2. **Apply and Enable HPA in Console or YAML**:
   - In GKE Console: Navigate to Workloads > dual-metric-demo > Actions > Autoscale > Horizontal Pod Scaling > Configure (min:1, max:5, CPU:70%, Memory:60%).
   - Or use YAML:
     ```yaml:hpa-multi.yaml
     apiVersion: autoscaling/v2
     kind: HorizontalPodAutoscaler
     metadata:
       name: dual-metric-demo-hpa
     spec:
       scaleTargetRef:
         apiVersion: apps/v1
         kind: Deployment
         name: dual-metric-demo
       minReplicas: 1
       maxReplicas: 5
       metrics:
       - type: Resource
         resource:
           name: cpu
           target:
             type: Utilization
             averageUtilization: 70
       - type: Resource
         resource:
           name: memory
           target:
             type: Utilization
             averageUtilization: 60
     ```
     ```bash
     kubectl apply -f deploy2.yaml
     kubectl apply -f hpa-multi.yaml
     kubectl get hpa  # Monitor CPU ~159%, Memory ~22%, replicas scale to 5
     ```

3. **Adjust Replicas Dynamically**: Edit maxReplicas or metrics to see live scaling.

4. **Cleanup**:
   ```bash
   kubectl delete -f deploy2.yaml -f hpa-multi.yaml
   ```

## Lab Demo: Container-Specific Metrics in HPA

### Overview
This demo targets a specific container in a multi-container pod for HPA scaling, avoiding metric averaging issues.

### Lab Demo Steps
1. **Create a Multi-Container Deployment**:
   ```yaml:deploy-sidecar.yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: sidecar-demo
   spec:
     replicas: 1
     selector:
       matchLabels:
         app: sidecar-demo
     template:
       metadata:
         labels:
           app: sidecar-demo
       spec:
         containers:
         - name: worker
           image: ubuntu:latest
           command: ["sh", "-c", "while true; do sleep 30; done"]
           resources:
             requests:
               cpu: 100m
               memory: 100Mi
             limits:
               cpu: 1000m
               memory: 1Gi
         - name: sidecar
           image: busybox
           command: ["sh", "-c", "while true; do curl http://example.com; done"]  # Simulates load
           resources:
             requests:
               cpu: 100m
               memory: 128Mi
             limits:
               cpu: 500m
               memory: 256Mi
   ```

2. **Apply and Enable Container-Specific HPA**:
   ```yaml:hpa-sidecar.yaml
   apiVersion: autoscaling/v2
   kind: HorizontalPodAutoscaler
   metadata:
     name: sidecar-demo-hpa
   spec:
     scaleTargetRef:
       apiVersion: apps/v1
       kind: Deployment
       name: sidecar-demo
     minReplicas: 1
     maxReplicas: 3
     metrics:
     - type: Resource
       resource:
         name: cpu
         target:
           type: Utilization
           averageUtilization: 50
   ```

   - In GKE Console: Workloads > sidecar-demo > Horizontal Pod Scaling > Select "Container CPU" > Choose "sidecar" container > Set utilization 50%.

3. **Apply and Verify**:
   ```bash
   kubectl apply -f deploy-sidecar.yaml
   kubectl apply -f hpa-sidecar.yaml
   kubectl get hpa  # Monitor scaling based on sidecar container metrics
   kubectl get pods  # Verify pods scale with 2 containers each
   ```

4. **Explore Custom/External Metrics**: In Console, add Kubernetes pod/node metrics or external sources like Pub/Sub.

5. **Cleanup**:
   ```bash
   kubectl delete -f deploy-sidecar.yaml -f hpa-sidecar.yaml
   ```

## Summary

### Key Takeaways
```diff
+ HPA dynamically scales pod replicas based on CPU/memory/custom metrics in GKE.
+ Integrates with node autoprovisioning for seamless scaling.
+ Best for stateless applications like web services and microservices.
+ Set resource requests/limits for accurate metric calculation.
+ Use autoscaling/v2 for advanced features like multiple metrics.
- Avoid combining HPA with VPA to prevent conflicts.
- Metric names must follow lowercase, no special characters.
- Scaling down delays prevent flapping during transient loads.
```

### Expert Insight
**Real-world Application**: In production, use HPA for e-commerce APIs during peak shopping hours, where traffic surges can be handled by adding pods automatically, reducing costs during off-peak times and preventing downtime. Combine with GKE autoscaling for full automation.

**Expert Path**: Start with CPU metrics, then layer on custom metrics from monitoring tools. Experiment with thresholds in staging environments using load testing. Master kubectl hpa describe for debugging scaling issues.

**Common Pitfalls**: Misconfigurations occur from unset requests/limits, causing inaccurate scaling. Averages in multi-container pods lead to delayed scaling—always specify container targets.

Lesser-known facts: HPA stabilizes after initial scaling; external metrics enable integration with Prometheus or Cloud Monitoring for event-driven scaling. HPA doesn't scale beyond cluster node limits without autoscaling enabled. 

Regarding mistakes in the transcript: "port" appears multiple times where "pod" is meant (e.g., "horizontal port autoscaler" should be "pod autoscaler", "adjust the number of ports" should be "pods"). "cubectl" appears instead of "kubectl". "matrix" should be "metrics". "hben" may be "hpa". "popsub" is "Pub/Sub". "parts" likely "pods". "vybox" may be "busybox". "np" might be "and". These have been corrected in the guide.
