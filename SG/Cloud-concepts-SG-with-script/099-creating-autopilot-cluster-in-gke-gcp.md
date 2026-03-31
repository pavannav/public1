# Session 99: Creating Autopilot Cluster in GKE GCP

## Table of Contents

- [Overview of Autopilot Cluster](#overview-of-autopilot-cluster)
- [Benefits of Using Autopilot](#benefits-of-using-autopilot)
- [Pricing Models](#pricing-models)
- [Scaling and Resource Management](#scaling-and-resource-management)
- [Differences from Standard Clusters](#differences-from-standard-clusters)
- [Creating an Autopilot Cluster](#creating-an-autopilot-cluster)
- [Connecting and Managing the Cluster](#connecting-and-managing-the-cluster)
- [Deploying Workloads](#deploying-workloads)
- [Scaling and Troubleshooting](#scaling-and-troubleshooting)

## Overview of Autopilot Cluster

### What is Autopilot?

Autopilot is a mode of operation in Google Kubernetes Engine (GKE) where Google fully manages the infrastructure configuration, including nodes, scaling, security, and preconfigured settings. This allows users to focus solely on deploying and managing their applications without handling the underlying cluster operations.

### Key Concepts/Deep Dive

- **Infrastructure Management**: Google handles:
  - Node creation and scaling
  - Security patches and upgrades
  - Maintenance scheduling and exclusions
  - Automatic scaling based on workload demands
  
- **Resource Provisioning**: 
  - Compute resources are provisioned automatically from Kubernetes manifests.
  - Users define CPU, memory, and ports in the pod specification.
  - No need to specify node details; nodes are created and resized dynamically.

- **Production Optimization**:
  - Autopilot is optimized for most production workloads.
  - Nodes are not visible in Compute Engine; everything is abstracted.

## Benefits of Using Autopilot

### Focus on Applications

Since Google manages infrastructure, developers can concentrate on building, deploying, and iterating on applications.

### No Node Management

- Google handles worker nodes, including provisioning, upgrades, repairs, and scaling.
- Eliminates the need to manually create nodes or configure autoscaling.

### Built-in Security and Best Practices

- **Hardened Configuration**: Default security settings are enabled, including patch management.
- **Automatic Security Patches**: Applied to nodes based on maintenance schedules or configured exclusions.

### Automatic Scaling and Bin Packing

- **Horizontal Pod Autoscaling**: Automatically provisions nodes when workloads increase.
- **Bin Packing**: Efficiently manages pod placement; users can control placement using Kubernetes mechanisms like affinity, anti-affinity, and pod spread topology keys.

### Reduced Operational Complexity

- Removes the overhead of monitoring node scaling and scheduling operations.
- Default production-ready configuration reduces the need for manual tuning.

✅ **Pro Tip**: Autopilot significantly simplifies cluster management for teams that want to offload infrastructure concerns.

## Pricing Models

### General Purpose Autopilot Pods

- **Pod-Based Billing**: Charged per pod.
  - Applies to pods running on container-optimized platforms in Autopilot or Standard clusters.
  - Includes pods using balanced or scale-out compute classes.
- **Example**: Running 10 pods costs for 10 pods, regardless of underlying nodes.

### Specific Hardware Workloads

- **Node-Based Billing**: Charged for underlying hardware and node management premium.
  - Used for pods requiring GPU, TPU, or other specialized accelerators.
- **Recommendation**: Use pod-based for simple workloads; node-based for specialized hardware needs.

💡 Real-World Scenario: For a web app without GPU requirements, pod-based billing keeps costs low as you scale pods.

## Scaling and Resource Management

### Automatic Scaling

- GKE automatically scales nodes based on pod count.
- If existing nodes can't accommodate new pods (e.g., due to Horizontal Pod Autoscaler), new nodes are provisioned.

### Scaling to Zero

- Clusters with no running workloads scale down to zero nodes.
- System pods (e.g., kube-proxy, coredns) remain in an unschedulable (pending) state until a workload is deployed.

### New Cluster Behavior

- New Autopilot clusters start with zero usable nodes.
- First workloads take longer to schedule as nodes are provisioned on-demand.
- **Command Example**:
  ```bash
  kubectl get nodes
  ```
  Initially shows no nodes; nodes appear after deploying workloads.

⚠️ **Warning**: Do not assume a cluster is faulty if `kubectl get nodes` shows no nodes; it's normal for Autopilot.

## Differences from Standard Clusters

| Aspect | Autopilot | Standard |
|--------|-----------|----------|
| Node Management | Fully managed by Google | User-managed node pools |
| Regional Clusters | Always regional (multi-zone) | Can be zonal or regional |
| Node Visibility | Nodes hidden in Compute Engine | Visible in Compute Engine |
| Flexibility | Limited; no access to nodes | Full control over nodes |
| Use Case | Simplified, secure for most workloads | Custom configurations required |

> [!NOTE]
> Autopilot abstracts nodes completely, making it unsuitable for workloads needing direct node access (e.g., custom kernel modules).

## Creating an Autopilot Cluster

### Steps in GCP Console

1. Navigate to GKE > Clusters > Create Cluster.
2. Select Autopilot (recommended).
3. Configure basics:
   - Name
   - Region (regional only)
4. Networking: Define VPC, enable private nodes if needed.
5. Advanced Settings:
   - Release Channel: Regular (recommended), Rapid, Stable.
   - Automation: Maintenance windows, exclusions.
   - Security: Service accounts, features like Binary Authorization, Secret Manager.
   - Metadata: Optional labels.
6. Review and Create.

### Key Restrictions

- No zonal clusters.
- Always uses multiple zones (e.g., four by default).
- No node pool options; all managed.

## Connecting and Managing the Cluster

### Connecting via Cloud Shell

Run the provided gcloud command to connect:

```bash
gcloud container clusters get-credentials <cluster-name> --region=<region>
```

### Initial State

- `kubectl get pods -A`: Some system pods running/pending.
- `kubectl get nodes`: May show zero nodes initially.

### Workload Deployment Triggers Node Provisioning

- After deploying a workload, e.g.:
  ```yaml
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: nginx-deployment
  spec:
    replicas: 2
    selector:
      matchLabels:
        app: nginx
    template:
      metadata:
        labels:
          app: nginx
      spec:
        containers:
        - name: nginx
          image: nginx:latest
          ports:
          - containerPort: 80
  ```

- Apply with:
  ```bash
  kubectl apply -f deploy.yaml
  ```

- Nodes provision in 5-10 minutes for the first deployment.

## Deploying Workloads

### Resource Requests/Warnings

- Without specified CPU/memory, defaults are used.
- Warning: `Warning: the deployment does not specify CPU resources; using defaults.`

### Pod Status

- Initially pending until nodes are ready.
- `kubectl get pods`: Transitions from Pending to Running.

## Scaling and Troubleshooting

### Scaling Pods

- Use `kubectl scale` or edit via UI.
- Example: Scale to 6 replicas.

### Quota Issues

- **Error**: `GCE quota exceeded`.
- Symptom: Pods remain pending; `kubectl describe pod` shows scheduling failures.
- **Resolution**:
  - Check node resource usage: `kubectl describe nodes`.
  - Edit resource requests: Reduce CPU/memory (e.g., to 100m/200Mi).
  - Delete excess pods if needed.
- Free Trial Limitation: Limited to SSD quota (e.g., 250 GB ≈ 2-3 nodes).

### Troubleshooting Commands

- `kubectl describe pod <pod-name>`: Check events for scheduling issues.
- `kubectl get events`: View cluster events.

⚠️ **Caution**: In Autopilot, you can't access nodes directly; use Kubernetes tools for debugging.

```diff
+ Key Takeaways:
+ - Autopilot simplifies GKE management by handling nodes, scaling, and security.
+ - Ideal for production workloads needing minimal overhead.
+ - Pod-based pricing for general use; node-based for specialized hardware.
+ - Clusters start at zero nodes; scale on-demand.
+ - Regional clusters only; no node visibility in Compute Engine.
+ - Troubleshoot with kubectl commands; monitor quotas and resources.
- Limitations: Quotas restrict scaling in free trials; no direct node access.
! Security Focus: Default hardened configs reduce attack surface.
```

## Summary

### Expert Insight

#### Real-world Application
Autopilot is excellent for startups and teams running microservices or containerized apps in GKE without DevOps overhead. For example, in CI/CD pipelines, deploy workloads that scale automatically without manual node management, ensuring cost-efficiency and focus on business logic.

#### Expert Path
Master Autopilot by:
1. Understanding compute classes (e.g., scale-out for bursty workloads).
2. Implementing HPA triggers based on metrics.
3. Monitoring with Cloud Monitoring for performance insights.
4. Learning advanced Kubernetes features like affinities for pod placement.

#### Common Pitfalls
- Assuming node access: Autopilot hides nodes; test workloads requiring direct access in Standard mode.
- Ignoring quotas: In free trials or limited accounts, scale issues arise; monitor with `kubectl describe`.
- Under-specified resources: Define CPU/memory requests to avoid scheduling conflicts.
- Never amend nodes: All changes go through manifests.

#### Lesser Known Things
- System pods stay in pending state when idle, which is normal and saves costs.
- Autopilot optimizes for bin packing, potentially improving utilization vs. manual setups.
- Future-proofing: Release channels ensure automatic minor updates without downtime.

> [!IMPORTANT]
> Autopilot is evolution of GKE for simplicity; use Standard for advanced control.

### Transcript Corrections Made
During processing, the following common misspellings from the transcript were corrected for accuracy:
- "GK" → "GKE" (GKE is Google Kubernetes Engine).
- "cubectl" → "kubectl".
- "unsuitable" → "unschedulable" (correct Kubernetes term for pod scheduling state).
- "add er" → "adder" (likely "adder" for context).
- "anduling" → "and tuning" (likely "scaling and tuning").
- "accelerators" corrected to "accelerators" (typo in original).
- "umbrella" → removed extraneous words; "autopilot" was mistakenly transcribed as "autobio".
These corrections ensure technical precision without altering the intended meaning. If specific context was unclear, assumptions were based on standard GKE terminology. <model-id>CL-KK-Terminal</model-id>
