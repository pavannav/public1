# Session 106: Cluster AutoScaler in GKE GCP

> [!NOTE]
> This study guide covers Cluster Autoscaler in Google Kubernetes Engine (GKE). Corrections made: "GK" to "GKE", "node poolool" to "node pool", "cubectl" to "kubectl", "clust" to "cluster".

## Table of Contents
- [What is Cluster Autoscaler](#what-is-cluster-autoscaler)
- [How Cluster Autoscaler Works](#how-cluster-autoscaler-works)
- [Operating Criteria for CA](#operating-criteria-for-ca)
- [Autoscaling Limits and Policies](#autoscaling-limits-and-policies)
- [Autoscaling Profiles](#autoscaling-profiles)
- [Key Rules for Using CA](#key-rules-for-using-ca)
- [Lab Demo: Configuring CA in Console](#lab-demo-configuring-ca-in-console)
- [Lab Demo: Testing Scaling Behaviors](#lab-demo-testing-scaling-behaviors)
- [Summary](#summary)

## What is Cluster Autoscaler

### Overview
Cluster Autoscaler in Google Kubernetes Engine (GKE) automatically adjusts the number of nodes in a node pool based on workload demands. It scales up when resources are insufficient for pod scheduling and scales down when nodes are underutilized, helping control costs by reducing node count during low demand periods. It operates per node pool, meaning you enable autoscaling individually for each pool. Decisions are based on resource requests (not limits or actual utilization).

### Key Features
- **Scaling Up**: Adds nodes when pods cannot be scheduled due to insufficient CPU or memory.
- **Scaling Down**: Removes nodes if pods can fit on fewer nodes, after draining and rescheduling pods.
- **Cost Control**: Automatically reduces node count during off-peak hours without manual intervention.
- **Disruption Handling**: Workloads should tolerate transient disruption using controllers like Deployments or ReplicaSets.

### Benefits
- Increases workload availability during high demand.
- Prevents overprovisioning and manual scaling efforts.

> [!WARNING]
> Autoscaling can cause pod rescheduling to different nodes, potentially leading to brief downtime. Ensure workloads are disruption-tolerant.

## How Cluster Autoscaler Works

### Enabling Autoscaling
- Enabled per node pool, not cluster-wide.
- Define minimum and maximum node counts per pool.
- Works on GKE Standard clusters; Autopilot has different behaviors.

### Scaling Mechanisms
- **Scale Up**: Checks if unschedulable pods exist due to resource constraints. Adds nodes based only on CPU and memory requests.
- **Scale Down**: Drains the node, reschedules pods to others, then deletes the node.

### Node Pool Constraints
- Node pool stays within min/max limits.
- Never scales below minimum or above maximum.
- On Standard clusters, doesn't auto-scale to zero; Autopilot can.

```diff
Sun: Pod unable to schedule → CA detects → Adds nodes
- Nodes underutilized → CA drains node → Reschedules pods → Deletes node
```

## Operating Criteria for CA

### Pod Disruption Tolerance
- Replicated pods (e.g., via Deployment/ReplicaSet) reschedule during node deletion.
- Controllers handle disruptions; no manual node management assumed.

### Uniform Labels and Manual Changes
- All nodes in a pool have identical labels for consistent node creation.
- Manual node additions must not override CA; CA may adjust.

### Cost-Aware Scaling
- Prefers least expensive node pools (e.g., spot VMs) for scaling.
- Falls back to standard pools if spot capacity unavailable.

## Autoscaling Limits and Policies

### Limits Types
| Type | Description | Example |
|------|-------------|---------|
| Per Zone | Min/max nodes per zone (balanced across zones) | Min 1, Max 4 per zone across 3 zones → Initial 3 nodes (1 each), Max 12 nodes (4 each) |
| Total (Cluster-Wide) | Min/max total nodes across zones (flexible distribution, e.g., all in one zone) | Min 3, Max 12 total → Nodes can pile up in available zones |

- Default is per zone; available in GKE 1.24+ for total limits.
- Per zone ensures HA; total is more flexible but risky for zone failures.

### Location Policies
- **Balanced**: Spreads nodes equally across zones (e.g., 2 per zone for 6 total).
- **Any**: Unequal distribution based on capacity/reservations.

## Autoscaling Profiles

### Profiles Overview
- Applied cluster-wide, affects all node pools.
- Controls aggression in removing underutilized nodes.

### Profile Types
| Profile | Behavior | Use Case |
|---------|----------|----------|
| Balance | Keeps buffer capacity; scales down after 15-20 minutes | Latency-sensitive workloads, Standard clusters |
| Optimize Utilization | Aggressive scale-down for cost savings; packs pods tightly | Batch jobs, cost-sensitive workloads |

- Balance: Fast scale-up (1-2 minutes), safer for spikes.
- Optimize Utilization: Slower scale-up, focuses on efficiency.

```diff
+ Balance: Keeps resources available → Faster pod startup → Safe for critical apps
- Optimize Utilization: Immediate dense packing → Cost savings → Slower for new pods
```

### Decision Matrix
- **Latency-Sensitive**: Per zone + Balance.
- **Batch Jobs**: Total + Optimize Utilization.
- **Mixed Workloads**: Use multiple node pools with different settings.

## Key Rules for Using CA

### Node Deletion Prevention
CA won't delete nodes if:
- Pods have affinity/anti-affinity preventing rescheduling.
- Pods unmanaged by controllers (e.g., not Deployment/ReplicaSet).
- Pods use local storage.
- Pods have annotation `cluster-autoscaler.kubernetes.io/safe-to-evict: "false"`.
- Deleting violates Pod Disruption Budget.

### Spot VMs Considerations
- CA prefers spot VMs but considers availability and preemption risk (15s window).
- Use custom compute classes for advanced handling.

> [!IMPORTANT]
> Manual changes or unmanaged pods can block scaling; monitor for unexpected costs.

## Lab Demo: Configuring CA in Console

### Steps to Enable CA
1. Go to GKE Console → Create Kubernetes Cluster (Standard).
2. Select regional cluster.
3. In Node Pool Settings:
   - Enable Cluster Autoscaler.
   - Choose Location Policy: Balanced or Any.
   - Set Limits: e.g., Per Zone (Min 1-2, Max 1-2 per zone).
   - Machine Type: e.g., 2 vCPUs, 4GB RAM, Standard Disk 70GB.

```yaml
# Example Node Pool Config
apiVersion: v1
kind: NodePool
metadata:
  name: default-pool
spec:
  autoscaling:
    enabled: true
    locationPolicy: BALANCED
    minNodeCount: 1
    maxNodeCount: 2
  nodeConfig:
    machineType: e2-standard-2
    diskSizeGb: 70
    diskType: pd-standard
```

3. Create cluster; verify in Node Pools section.

### Verification
- Nodes: Min 3 nodes (1 per zone).
- Cluster Details: Shows autoscaling enabled, limits applied.

## Lab Demo: Testing Scaling Behaviors

### Scaling Up Demo
1. Deploy app: `kubectl apply -f deploy.yaml` (requests 100m CPU, 300Mi memory, 2 replicas).
2. Scale replicas: `kubectl scale deployment nginx --replicas=17`.
3. Observe: Pods pending → CA adds nodes (balanced: 1 per zone).
4. Verify: `kubectl get nodes` shows extra nodes; pods running.

```bash
kubectl get pods
# Output: All pods running after node addition
```

### Scaling Down Demo
1. Scale back: `kubectl scale deployment nginx --replicas=10`.
2. Wait 15-20 min (Balance) or ~10 min (Optimize Utilization).
3. Observe: Nodes drained, pods rescheduled, nodes deleted.

### Profile Switching
1. Edit Cluster → Autoscaling Profile: Optimize Utilization.
2. Re-test: Faster scale-down (e.g., 5-6 min vs. 20 min).

```diff
- Balance Profile: Nodes removed after 20+ min
+ Optimize Profile: Nodes removed in ~5-10 min with some potential pod wait
```

### Regional vs. Total Limits Demo
1. Create new node pool with Total limits (Min 3, Max 6).
2. Test: Scaling may create uneven zone distribution if capacity allows.
3. Note: Initial creation still balances for instance groups.

> [!NOTE]
> Low-priority pods (e.g., PriorityClass -100) don't trigger scale-up.
> Pod Disruption Budgets or eviction annotations prevent node deletion.

## Summary

### Key Takeaways
```diff
+ Cluster Autoscaler (CA) auto-scales GKE node pools based on pod resource requests
+ Works per node pool; defines min/max limits; profiles (Balance/Optimize) control behavior
+ Balances cost vs. availability; chooses cheapest pools first (e.g., Spot VMs)
+ Prevents disruptions with replicated controllers; avoids manual overrides
- Can cause transient pod moves; never scales to zero on Standard
+ Per zone: HA-focused; Total: Flexible but unbalanced risk
! Always test disruption tolerance; monitor for blocked scaling
```

### Expert Insight

#### Real-World Application
In production, use CA for elastic workloads like web apps with traffic spikes. Pair with Helm charts managing Deployments for auto-healing. For multi-tenant clusters, isolate node pools per team with custom limits to prevent resource hogging.

#### Expert Path
Master CA by monitoring GKE metrics (e.g., CPU/memory utilization via Stackdriver). Experiment with profiles in dev envs; integrate with GKE Workload Identity for cost optimization. Advanced: Combine with Vertical Pod Autoscaler (VPA) for per-pod scaling.

#### Common Pitfalls
- **Unmanaged Pods**: Scale-down blocked; use controllers always.
- **Misconfigured Limits**: Over-provision (too low max) or zone imbalances (per zone vs. total).
- **Spot VM Over-Reliance**: High preemption risk; balance with on-demand via multiple pools.
- **Annotation Oversight**: Missing `safe-to-evict` blocks CA; audit pod specs regularly.
- **Profile Mismatch**: Balance for latency, but switch to Optimize for batch to avoid inflated costs.

(Lesser Known: CA simulator tool in closed-source GKE; use `kubectl debug` for node inspection during scaling.)
