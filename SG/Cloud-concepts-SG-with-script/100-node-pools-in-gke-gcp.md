# Session 100: Node Pools in GKE GCP

## Table of Contents
- [Introduction to Node Pools](#introduction-to-node-pools)
- [Creating a Node Pool in GKE](#creating-a-node-pool-in-gke)
- [Horizontal Scaling](#horizontal-scaling)
- [Vertical Scaling](#vertical-scaling)
- [Upgrade Strategies](#upgrade-strategies)
- [Lab Demonstration: Node Pool Operations](#lab-demonstration-node-pool-operations)
- [Summary](#summary)

## Introduction to Node Pools

### Overview
A node pool in Google Kubernetes Engine (GKE) is a group of nodes within a standard cluster that share the same configuration. When creating a GKE cluster in standard mode, you automatically create a node pool, which defines attributes like machine type, disk type, and size. Nodes within a pool are homogeneous, meaning any configuration changes apply to all nodes in the pool using the configured upgrade strategy (e.g., rolling updates or blue-green deployments).

Custom node pools are beneficial for resource-intensive workloads. For example, memory-heavy applications can use pools with higher memory instances, while CPU-intensive apps can leverage pools with more CPU cores. This segregation ensures efficient resource allocation and isolation for different application types.

Key characteristics include:
- All nodes in a pool have identical configurations (machine type, disk, networking, security settings).
- Individual nodes in a pool cannot be reconfigured; changes affect the entire pool.
- Node pools can be upgraded, resized, or deleted independently without impacting the entire cluster.

> [!NOTE]
> In GKE Autopilot mode, node pools are fully managed by Google and cannot be customized by users.

### Key Concepts and Deep Dive
- **Configuration Options**: During node pool creation, users select from various machine types (e.g., e2-micro, e2-medium, e2-standard), disk types (persistent standard, SSD, balanced), and sizes. Networking and security settings like service accounts, node labels, taints, and network tiers can also be specified.
- **Default Node Pool**: The first node pool created with the cluster serves as the default, containing the initial set of nodes based on cluster creation parameters.
- **Customization for Workloads**: Different pools address varied needs:
  - Memory-intensive workloads: Use instances with higher RAM (e.g., e2-highmem).
  - Disk-intensive workloads: Opt for local SSD reservations.
  - Network-specific: Choose specific network tiers or security policies.
- **Management Operations**:
  - Resize: Add or remove nodes horizontally.
  - Upgrade: Change machine type, disk type, or size vertically.
  - Isolation: Use node selectors or taints to schedule pods on specific pools.

### Common Pitfalls
- Over-provisioning resources leading to increased costs; monitor usage and scale down when possible.
- Misconfiguring upgrade strategies causing downtime during vertical scaling.
- Neglecting resource reservations by Kubernetes system components, which can prevent pod scheduling.
- Forgetting that configuration changes target all nodes in the pool, not individual ones.

## Creating a Node Pool in GKE

### Overview
Creating additional node pools allows for workload isolation and tailored resource allocation. Unlike the default node pool created during cluster setup, custom pools are added later and can have unique configurations.

### Key Concepts and Deep Dive
- **Steps to Create**:
  1. Navigate to the GKE Console.
  2. Select the cluster.
  3. Go to the "Nodes" tab.
  4. Click "Add Node Pool."
  5. Configure machine type, disk, networking, and security options.
  6. Specify node labels, taints, or node selectors for scheduling.
- **Integration with Clusters**: Node pools are part of managed instance groups, allowing seamless integration with GKE's scaling and upgrade mechanisms.
- **Metadata and Security**: Each pool can have custom metadata (key-value pairs) and service accounts with specific IAM roles, enabling fine-grained access control.

### Common Issues and Resolutions
- **Quota Limits**: Limited by regional quotas for VM instances or public IPs; resolve by requesting increases or resizing existing pools.
- **Scheduling Failures**: Pods may not schedule if node selectors don't match; ensure pool names/labels align with pod specifications.

## Horizontal Scaling

### Overview
Horizontal scaling increases or decreases the number of nodes in a pool to meet changing workload demands, optimizing performance and cost.

### Key Concepts and Deep Dive
- **Process**: Resize a node pool by adjusting the node count (e.g., from 2 to 3 nodes), adding/removing VMs from the underlying instance group.
- **Manual vs. Autoscaler**: Perform manually via console or CLI, or automate with the GKE Node Autoscaler.
- **Impact**: New nodes allow more pods to schedule; removing nodes drains and terminates existing pods.
- **Workflow**:
  ```
  1. Identify resource constraints (e.g., CPU/memory usage near capacity).
  2. Resize pool (e.g., increase from 2 to 3 nodes).
  3. Monitor kube-scheduler for pod placement.
  ```

### Tables
| Aspect | Description |
|--------|-------------|
| Direction | Scale Up (Add Nodes) or Scale Down (Remove Nodes) |
| Example | From 2 nodes to 3 nodes for higher pod capacity |
| Cost Impact | Proportional to node hours |

### Common Pitfalls
- Scaling down too aggressively, causing pod evictions; always check for unschedulable pods first.
- Ignoring cool-down periods; avoid rapid resizes to prevent thrashing.

## Vertical Scaling

### Overview
Vertical scaling modifies the machine type (e.g., CPU cores, RAM) or disk attributes of nodes in the pool, effectively upgrading individual node capacities.

### Key Concepts and Deep Dive
- **Process**: Change configuration using rolling updates or blue-green strategies; GKE replaces nodes one by one.
- **Attributes Modifiable**:
  - Machine type (e.g., from e2-medium to e2-standard-2).
  - Disk type/size (e.g., increase from 50GB to 100GB).
- **Strategies**:
  - **Max Surge**: Creates new nodes before deleting old ones (default, minimizes downtime).
  - **Max Unavailable**: Deletes old nodes before creating new ones (cost-effective but higher risk of downtime).
- **Workflow**:
  ```
  1. Identify resource bottlenecks (e.g., insufficient RAM for pods).
  2. Select new machine type (e.g., higher memory variant).
  3. Apply change; monitor upgrade progress.
  ```

```diff
- Old Node: e2-medium (2 CPU, 4GB RAM)
+ New Node: e2-standard-2 (2 CPU, 8GB RAM)
! Ensures pods meet resource requirements without horizontal scaling.
```

### Common Issues and Resolutions
- **Resource Shortages During Upgrade**: Use Max Surge to maintain capacity; avoid if budget-constrained.
- **Downtime**: Choose strategies wisely; Max Unavailable causes brief pod unscheduling.

## Upgrade Strategies

### Overview
Upgrade strategies control how GKE applies configuration changes during vertical scaling or version upgrades.

### Key Concepts and Deep Dive
- **Rolling Update (Default)**: Gradual replacement of nodes.
  - **Max Surge**: Number of extra nodes created during upgrade (e.g., +1 node for a 3-node pool).
  - **Max Unavailable**: Number of nodes that can be unavailable simultaneously (e.g., 0 for zero-downtime).
- **Blue-Green**: Creates a new pool, migrates workloads, then deletes the old pool (not covered in detail here).
- **Surge Principle**: Ensures capacity isn't lost; e.g., in a 10-node pool, Max Surge=2 allows 12 nodes temporarily.
- **Real-World Application**: Use Max Surge=1, Unavailable=0 for production to prevent disruptions.

```diff
+ Recommended for Production: Max Surge=1, Max Unavailable=0 (ensures capacity)
- Avoid Max Unavailable >0 if uptime is critical.
```

### Common Pitfalls
- Setting Max Unavailable too high, risking pod evictions during peak traffic.
- Not considering cluster size; very-large pools may require custom Max Surge values to avoid over-provisioning costs.

## Lab Demonstration: Node Pool Operations

This section includes step-by-step demos for creating, scaling, and managing node pools, based on the transcript's CLI and console examples.

### Creating a Cluster with Default Node Pool
1. Open GKE Console.
2. Click "Create Cluster" → Choose Zonal (regional clusters consume more resources).
3. Configure:
   - Name: e.g., `cluster-one`
   - Node Pool: Custom; Name: `first-pool`, Nodes: 2, Machine: e2-medium, Disk: 70GB Standard.
4. Create cluster (takes ~10-15 minutes).

### Connecting and Deploying Workloads
1. Run `gcloud container clusters get-credentials cluster-one --zone=us-central1-a`.
2. Check nodes: `kubectl get nodes` (expect 2 nodes).
3. Deploy sample app: `kubectl apply -f deploy.yaml` (specify CPU requests/limits to test scaling).

### Horizontal Scaling Demo
1. Simulate load: Scale deployment to 8 replicas with high CPU limits.
2. Verify pending pods: `kubectl get pods` (some in Pending due to resource limits).
3. Resize in Console: Nodes → Resize `first-pool` to 3 nodes.
4. Monitor: `kubectl get nodes` (new node added).

### Creating Custom Node Pool
1. Add Node Pool: Nodes → Add Pool; Name: `second-node-pool`, Nodes: 1, Machine: e2-medium, Labels: `name=second-node-pool`.
2. Deploy with selector: Apply YAML with `nodeSelector: name: second-node-pool`.
3. Verify: Pods schedule only on matching nodes.

### Vertical Scaling Demo
1. Change machine type via CLI: `gcloud container clusters update cluster-one --node-pool=second-node-pool --machine-type=e2-standard-2`.
2. Monitor: `kubectl get nodes` (old node cordoned, new node created, old deleted).
3. Test with resource-intensive pods.

### Upgrading Configuration
1. Edit Pool: Configure Max Surge/Unavailable (e.g., Surge=0, Unavailable=1).
2. Test: Scale up machine type; observe node deletion before creation.

```bash
# Horizontal scaling command
kubectl scale deployment my-deployment --replicas=6

# Vertical scaling
gcloud container clusters update cluster-one --node-pool=second-node-pool --machine-type=e2-standard-2 --disk-type=pd-ssd --disk-size=100
```

> [!IMPORTANT]
> Always back up configurations and test in non-production environments before applying to production clusters.

## Summary

### Key Takeaways
```diff
+ Node pools enable workload isolation and efficient resource management in GKE by grouping homogeneous nodes with shared configurations.
- Avoid scaling operations during peak traffic; monitor resource usage to prevent evictions.
! Configuration changes affect all nodes in a pool; use upgrade strategies like Max Surge for zero-downtime.
+ Horizontal scaling adjusts node count; vertical scaling changes machine attributes using rolling updates.
- Max Unavailable settings can cause downtime; prefer Max Surge for production workloads.
+ Use node selectors or taints to ensure pods target specific pools for security or resource needs.
! Test scaling behaviors in staging before applying to production to avoid cost overruns or outages.
```

### Expert Insight

#### Real-World Application
In production environments, combine node pools with GKE's Node Autoscaler for dynamic scaling based on pod resource requests. For example, use memory-optimized pools for big data workloads and CPU-optimized pools for compute tasks. Monitor metrics via Prometheus or Cloud Monitoring to trigger scaling, ensuring high availability while minimizing costs.

#### Expert Path
Master advanced configurations like taints/tolerations for advanced scheduling (e.g., reserve pools for privileged workloads). Experiment with custom images and preemption policies. Dive deeper into IAP (Identity-Aware Proxy) for secure access.

#### Common Pitfalls
- **Resource Overallocation**: Kubernetes reserves memory/CPU for system processes (~10-30% based on node size); account for this to avoid scheduling failures.
- **Upgrade Disruptions**: Always use Max Surge >0 for large clusters; blue-green deployments provide even safer transitions.
- Resource Constraints During Scaling: Drain nodes gradually; check for Running status before deleting.
- Cost Management: Resize down pools during off-peak hours; use preemptible VMs for non-critical pools.

| Lesser-Known Aspects | Details |
|----------------------|---------|
| Resource Reservations | Google reserves variable amounts (e.g., 25MB per GB of RAM); documented in GKE docs. |
| Pool Affinity | Advanced node affinities can pin workloads beyond basic selectors for complex multi-pool setups. |
| Version Compatibility | Ensure node pool versions align with cluster master for optimal stability. |
| Backup Strategies | Pool configurations aren't directly backed up; use Infrastructure as Code (e.g., Terraform) for reproducibility. |

**Mistakes and Corrections in Transcript:**
- "cubctl" corrected to `kubectl` (multiple occurrences; e.g., "cubctl get nodes" → `kubectl get nodes`).
- "node poolool" corrected to "node pool" (multiple occurrences; e.g., "second node poolool" → "second node pool").
- "GK" corrected to "GKE" (Google Kubernetes Engine) for accuracy (e.g., "GK standard mode" → "GKE standard mode").
- "deploy.ml" corrected to "deploy.yaml" (assuming YAML file; "second pool deploy" → "second-pool-deploy.yaml").
- "cod node autoscaler" → "GKE Node Autoscaler".
- Numerical inconsistencies (e.g., "950" → "940m" for CPU allocatable) aligned with transcript context but verified for clarity.
- Typos like "trieve" not present; transcript is mostly clear otherwise. All commands and concepts corrected to standard GKE/Kubernetes terminology for preciseness.
