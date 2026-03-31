# Session 102: Spot VMs in GKE GCP

## Table of Contents
- [Overview of Spot VMs in Compute Engine](#overview-of-spot-vms-in-compute-engine)
- [How Spot VMs Work in GKE](#how-spot-vms-work-in-gke)
- [Termination Flow in GKE](#termination-flow-in-gke)
- [Scheduling Workloads on Spot VMs](#scheduling-workloads-on-spot-vms)
- [Node Auto Provisioning (NAP) with Spot VMs](#node-auto-provisioning-nap-with-spot-vms)
- [Best Practices for Spot VMs in GKE](#best-practices-for-spot-vms-in-gke)
- [Demo: Creating and Managing Spot VM Node Pools](#demo-creating-and-managing-spot-vm-node-pools)
- [Summary](#summary)

## Overview of Spot VMs in Compute Engine

Spot VMs are virtual machines that utilize the spot provisioning model, enabling access to Google Cloud resources at significantly reduced prices compared to standard VMs. This model can offer up to 91% cost savings, depending on market demand and supply for resources like CPU, memory, GPU, and TPU.

Compute Engine can preempt (terminate or stop) spot VMs at any time to reclaim resources for standard VMs, making spot VMs ideal for fault-tolerant workloads that can handle interruptions. Spot VMs are not covered under SLAs, and preemption provides about 30 seconds' notice before shutdown.

> [!IMPORTANT]
> Spot VMs offer cost savings but lack availability guarantees. Use them only for workloads that can tolerate disruptions.

Key differences between on-demand and spot VMs are summarized in the following table:

| Aspect              | On-Demand VMs              | Spot VMs                  |
|---------------------|----------------------------|---------------------------|
| Pricing            | Standard rates             | Up to 91% discount        |
| Availability       | Guaranteed (SLA-backed)    | Preemptible, no SLAs      |
| Preemption         | Rare                       | Common, with 30s notice   |
| Use Cases          | Critical workloads         | Batch, fault-tolerant jobs|

💡 Spot VMs are best for workloads like batch processing, data analysis, or non-critical tasks where interruptions are acceptable.

## How Spot VMs Work in GKE

In Google Kubernetes Engine (GKE), spot VMs are created as underlying Compute Engine spot instances managed via a Managed Instance Group (MIG). When a node pool is configured with spot VMs, GKE ensures the MIG maintains the desired number of instances. If Compute Engine pre-emits a spot VM, GKE attempts to recreate it once capacity becomes available.

Spot VMs in GKE behave like standard GKE nodes with the same configurations (CPU, memory, etc.), but without availability guarantees. They can be preempted to allocate resources to standard VMs when demand exceeds supply.

### Code Example: Creating a Spot VM Node Pool
Use the following gcloud command to create a node pool with spot VMs:

```bash
gcloud container node-pools create spot-pool \
  --cluster=my-cluster \
  --machine-type=n1-standard-1 \
  --num-nodes=3 \
  --spot
```

This creates a node pool where instances are spot VMs managed by GKE.

## Termination Flow in GKE

When Compute Engine pre-emits spot VMs for standard VMs, it sends a preemption notice (usually 30 seconds). GKE's graceful node shutdown is enabled by default, allowing:
- 15 seconds for non-system pods to terminate gracefully.
- 15 seconds for system-critical pods (e.g., kube-dns, kubelet).

Pods are marked with `kubectl.kubernetes.io/terminated` status, and workload controllers (e.g., Deployment controllers) reschedule pods on available nodes. If no nodes are available, pods remain in a pending state.

> [!NOTE]
> Spot VMs in GKE cannot be migrated during host maintenance events; instead, they are stopped and recreated, potentially changing internal/external IPs. Node names remain stable, but avoid relying on IPs—use Kubernetes Services for stable endpoints.

## Scheduling Workloads on Spot VMs

GKE automatically labels spot VM nodes with:
- `cloud.google.com/gke-spot=true`
- `cloud.kubernetes.io/instance-type` (specific to the VM type)

Optional taints can also be applied for scheduling control.

### Using Node Selectors
Add a node selector to pod specs to ensure pods run only on spot nodes:

```yaml
apiVersion: apps/v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: my-container
    image: nginx
  nodeSelector:
    cloud.google.com/gke-spot: "true"
```

### Using Node Affinity
For more advanced targeting:

```yaml
apiVersion: apps/v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: my-container
    image: nginx
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: cloud.google.com/gke-spot
            operator: In
            values:
            - "true"
```

### Using Tolerations for Taints
Taints prevent pods from scheduling unless they have matching tolerations. Spot VM node pools created via Node Auto Provisioning (NAP) are auto-tainted with `cloud.google.com/gke-spot=true:NoSchedule`.

Add tolerations to pod specs:

```yaml
apiVersion: apps/v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: my-container
    image: nginx
  tolerations:
  - key: "cloud.google.com/gke-spot"
    operator: "Equal"
    value: "true"
    effect: "NoSchedule"
```

## Node Auto Provisioning (NAP) with Spot VMs

Node Auto Provisioning (NAP) dynamically creates or scales node pools based on workload demands. When pods request spot VMs via node selectors/affinities, NAP creates spot VM node pools auto-tainted with `cloud.google.com/gke-spot=true:NoSchedule`.

### Enabling NAP for Spot VMs
In the GCP Console or via gcloud:

```bash
gcloud container clusters update my-cluster \
  --enable-autoprovisioning \
  --autoprovisioning-scopes=https://www.googleapis.com/auth/cloud-platform \
  --autoprovisioning-service-account=autoprovisioning-sa@project.iam.gserviceaccount.com \
  --autoprovisioning-network-tags=spot-tag \
  --autoprovisioning-max-nodes=10 \
  --autoprovisioning-spot
```

NAP scales node pools up/down automatically, deleting unused pools to optimize costs.

## Best Practices for Spot VMs in GKE

- **Assume Zero Availability Guarantees**: Workloads must tolerate disruptions; pods can be evicted at any time.
- **Use Mixed Node Pools**: Maintain at least one standard VM node pool for critical workloads (e.g., kube-dns, kube-proxy) and system components.
- **Deploy Fault-Tolerant Workloads**: Suitable for batch jobs, data processing, or CI/CD that can resume after interruptions.
- **GPU Considerations**: Use spot GPU node pools but ensure a non-GPU standard pool to prevent system pods from occupying expensive GPU resources.
- **Stable Design**: Node names are stable, but IPs change on recreation—use Services, not IPs, for networking.
- **Apply Taints/Tolerations**: Prevent critical pods from scheduling on spot nodes; only tolerant workloads should use them.
- **Data Persistence**: Data on spot nodes (including local SSD) is ephemeral and deleted on preemption—store stateful data in persistent volumes or external services.

> [!WARNING]
> Avoid running critical operations (e.g., databases, control plane add-ons) on spot VMs to prevent service disruptions and data loss.

## Demo: Creating and Managing Spot VM Node Pools

### Step 1: Create a GKE Cluster with Standard Node Pool
1. Open GCP Console > Kubernetes Engine > Clusters.
2. Create a new cluster (e.g., regional for cost savings).
3. Add a standard node pool (2 nodes, 2vCPU, 4GB RAM, 70GB disk) to avoid running system pods on spot VMs.

### Step 2: Create Spot VM Node Pool
1. Navigate to the cluster > Nodes tab.
2. Create a new node pool:
   - Name: `spot-vms`
   - Number of nodes: 2
   - Enable Spot VMs.
3. Verify in Compute Engine: Instances are created with spot pricing (e.g., reduced from $176/month to ~$132).

### Step 3: Deploy Pods with Node Selector
1. Create a deployment YAML (`spot-deployment.yaml`):

   ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: spot-app
   spec:
     replicas: 2
     selector:
       matchLabels:
         app: spot-app
     template:
       metadata:
         labels:
           app: spot-app
       spec:
         containers:
         - name: nginx
           image: nginx
           resources:
             requests:
               cpu: 200m
               memory: 128Mi
         nodeSelector:
           cloud.google.com/gke-spot: "true"
   ```

2. Apply the deployment:

   ```bash
   kubectl apply -f spot-deployment.yaml
   ```

3. Check pod status: Pods may be pending if no spot nodes exist. After adding the node pool, they schedule.

### Step 4: Demonstrate Taints and Tolerations
1. Taint spot nodes to restrict scheduling:

   ```bash
   kubectl taint nodes -l cloud.google.com/gke-spot=true cloud.google.com/gke-spot=true:NoSchedule
   ```

2. Deploy a pod without tolerations—it remains pending.
3. Update YAML with tolerations (as above) and redeploy.
4. Simulate preemption: Use `gcloud compute instances simulate-maintenance-event` on instance IDs.

   - Observe nodes go NotReady, pods pending.
   - GKE recreates instances (IPs change); pods reschedule once nodes are available.

### Step 5: Enable Node Auto Provisioning
1. Cluster > Automation > Enable Node Autoprovisioning.
2. Set limits (e.g., max 10 nodes).
3. Deploy a pod requesting spot VMs; NAP creates a spot node pool dynamically.
4. After deletion, NAP scales down the pool.

> [!NOTE]
> Deletes unused spot node pools after inactivity to optimize costs.

Errors during demo (e.g., incorrect capitalization in terminal):
- Correct: "kubectl" (not "cubecutl" or "cubectl")
- Correct: "pods" (not "ports")
- Correct: "taint" (not "t")
- Correct: "node pool" (not "notepool")

These appear to be transcription errors; actual commands use correct spellings.

## Summary

### Key Takeaways
```diff
+ Spot VMs in GKE provide up to 91% cost savings by using preemptible Compute Engine instances.
- Lack SLA coverage and can be terminated anytime with 30 seconds' notice for standard VM allocation.
! Use for fault-tolerant workloads only; mix with standard node pools for critical components.
+ GKE auto-labels spot nodes as cloud.google.com/gke-spot=true for scheduling control.
- Node IPs change on recreation; rely on Kubernetes Services instead.
+ NAP dynamically provisions spot node pools based on pod requests and auto-taints them.
! Apply taints/tolerations to isolate critical workloads from spot nodes.
```

### Expert Insight

**Real-world Application**: Spot VMs excel in environments like ML training jobs, data processing pipelines, or CI/CD runners where interruptions can be handled via retries or checkpoints. E.g., a company running non-real-time analytics can save costs by deploying on spot pools, using persistent volumes for state.

**Expert Path**: Master spot VMs by:
- Experimenting with auto-scaling and NAP for dynamic environments.
- Monitoring preemption events via GCP Logging/Cloud Monitoring to optimize workload design.
- Combining with preemptible pricing in Compute Engine for hybrid use cases.
- Studying GCP's spot instance availability trends to plan workloads around demand.

**Common Pitfalls**:
- **Issue**: Pods failing to schedule on spot nodes. **Resolution**: Ensure exact label matching (e.g., `cloud.google.com/gke-spot: "true"`), check node pool status, and verify taints/tolerations are correctly applied.
- **Issue**: Data loss on preemption due to ephemeral storage. **Resolution**: Configure persistent volumes or external databases; avoid relying on local SSD or node disks.
- **Issue**: System pods accidentally scheduled on spot nodes causing outages. **Resolution**: Always maintain a standard node pool and apply strong taints to spot pools; monitor with `kubectl get pods -o wide`.
- **Issue**: Inconsistent node IPs causing connectivity issues. **Resolution**: Use Kubernetes Services (e.g., ClusterIP, LoadBalancer) or Ingress for stable endpoints; avoid hard-coding IPs in configurations.
- **Lesser-known Things**: Spot VMs cannot be live-migrated during maintenance—they are hard-terminated and rebuilt, unlike standard VMs. Additionally, GPU spot VMs require separate non-GPU pools to avoid wasting resources on system overhead. NAP can create pools across multiple zones but respects regional quotas.
