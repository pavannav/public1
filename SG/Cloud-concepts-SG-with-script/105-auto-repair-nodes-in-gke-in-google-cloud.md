# Session 105: Auto Repair Nodes in GKE in Google Cloud

### Table of Contents
- [Introduction to Auto Repair Nodes in GKE](#introduction-to-auto-repair-nodes-in-gke)
- [Enabling and Disabling Auto Repair](#enabling-and-disabling-auto-repair)
- [Repair Criteria](#repair-criteria)
- [Node Repair Process](#node-repair-process)
- [Console Options and Configuration](#console-options-and-configuration)
- [Lab Demo: Testing Auto Repair](#lab-demo-testing-auto-repair)

## Introduction to Auto Repair Nodes in GKE

### Overview
Node auto repair in Google Kubernetes Engine (GKE) is a feature designed to maintain the health and availability of nodes within a cluster. When enabled, GKE performs periodic health checks on each node. If a node becomes unhealthy or fails to meet predefined criteria, GKE automatically initiates a repair process, which may involve draining workloads from the affected node and recreating it. This ensures that the cluster remains in a stable, operational state without manual intervention.

Auto repair is particularly valuable in production environments where downtime can impact application availability and user experience. It helps prevent scenarios where a single faulty node could bring down services hosted on the cluster.

### Key Concepts/Deep Dive
- **Purpose**: Auto repair keeps nodes healthy by detecting failures and initiating repairs. This includes shifting pods to other nodes and recreating failed nodes if necessary.
- **Benefits**:
  - Reduces manual maintenance overhead.
  - Ensures high availability for workloads.
  - Supports continuous operation of Kubernetes clusters.
- **Cluster Types**:
  - **Autopilot Clusters**: Auto repair is always enabled and cannot be disabled.
  - **Standard Clusters**: Auto repair is enabled by default for new node pools but can be customized.

```diff
+ Key Point: Auto repair proactively maintains node health, preventing extended downtime.
- Warning: Disabling auto repair in standard clusters can lead to prolonged node failures.
```

## Enabling and Disabling Auto Repair

### Overview
Auto repair can be configured during cluster and node pool creation, or modified afterward. In autopilot clusters, it's mandatory and non-configurable. For standard clusters, it's enabled by default when using a release channel, but can be disabled if no release channel is selected.

### Key Concepts/Deep Dive
- **Default Behavior**:
  - Enabled for new node pools in standard clusters.
  - Cannot be disabled if a release channel is in use.
- **Configurations**:
  - During cluster creation: Use the Google Cloud Console to select options.
  - For existing node pools: 
    - Not modifiable via console for standard clusters.
    - Use commands to disable if necessary (not recommended for production).
- **Recommendations**:
  - Keep default settings to ensure reliability.
  - Only disable for specific testing scenarios or organizational requirements.

```diff
! Alert: Disabling auto repair may result in nodes remaining unavailable indefinitely.
```

> [!IMPORTANT]
> Always use release channels in production to enforce auto repair for optimal cluster health.

## Repair Criteria

### Overview
GKE determines if a node needs repair based on specific health indicators. A node is considered healthy if it reports a "Ready" status. Repair is triggered if the node fails consecutive checks over defined time thresholds.

### Key Concepts/Deep Dive
GKE initiates repairs when any of the following conditions occur:
1. **Not Ready Status**: Node reports "NotReady" consecutively.
2. **No Status Report**: Node stops reporting status for over 10 minutes.
3. **Boot Disk Full**: Node's boot disk is out of space for over 30 minutes.
4. **Cordoned in Autopilot**: Node remains cordoned for more than 10 minutes.

| Criterion | Description | Threshold |
|-----------|-------------|-----------|
| Not Ready Status | Node unhealthy signals | Consecutive checks |
| No Status | Lack of communication | 10 minutes |
| Disk Space | Boot disk exhausted | 30 minutes |
| Cordoned State | Stuck cordoned (autopilot) | 10 minutes |

> [!NOTE]
> These criteria help GKE distinguish between temporary issues and persistent failures.

## Node Repair Process

### Overview
When a node fails repair criteria, GKE drains the node (moves pods to healthy nodes), then recreates it. The process preserves the node's original name but assigns a new IP address.

### Key Concepts/Deep Dive
- **Steps in Repair**:
  1. **Detection**: GKE identifies the unhealthy node.
  2. **Draining**: Pods are evicted gracefully (up to 1 hour wait).
     - If draining doesn't complete, the node is shut down and recreated.
  3. **Recreation**: New node is provisioned with the same specifications.
- **Parallel Repairs**: For multiple failing nodes, repairs happen concurrently, balanced by cluster size.
- **Interruptions**: Disabling auto repair mid-process doesn't cancel ongoing repairs.
- **Pod Handling**: Pods are rescheduled automatically to available nodes.

```diff
+ Positive: Preserves node identity (name) for consistency in configurations and references.
- Negative: IP address change may require updates in load balancers or external configurations.
```

💡 **Expert Tip**: Monitor logs for repair events to track cluster health operations.

## Console Options and Configuration

### Overview
GKE Console provides interfaces for configuring auto repair during cluster and node pool setup. Options vary based on cluster type and release channels.

### Key Concepts/Deep Dive
- **Standard Clusters**: 
  - During creation: Check "Enable auto repair" (required if release channel is used).
  - For existing pools: Viewing automation settings shows status, but modifications require CLI.
- **Commands for Disabling**:
  - Use Google Cloud CLI to update node pools.
  - Example command (not recommended):
    ```bash
    gcloud container node-pools update [NODE_POOL_NAME] \
      --cluster=[CLUSTER_NAME] \
      --location=[LOCATION] \
      --no-enable-auto-repair
    ```
- **Viewing Status**:
  - Go to Clusters > Node Pools > Automation tab.

> [!IMPORTANT]
> Consult Google documentation before disabling auto repair, as it can impact cluster stability.

## Lab Demo: Testing Auto Repair

### Overview
This demo illustrates auto repair by simulating node failure in a standard GKE cluster and observing the repair process.

### Steps and Code

1. **Create a Standard Cluster**:
   - In Google Cloud Console, create a standard cluster.
   - Configure:
     - Release channel: Regular.
     - Default node pool: 2 nodes, 70GB disk.
     - Additional node pool: 1 node.
   - Enable auto repair (default).

2. **Verify Nodes**:
   ```bash
   kubectl get nodes
   ```
   - Output should show nodes in "Ready" status.

3. **Simulate Node Failure**:
   - SSH into a node via Compute Engine > VM Instances.
   ```bash
   sudo systemctl stop kubelet
   ```
   - Verify status:
   ```bash
   sudo systemctl status kubelet
   ```

4. **Observe Repair**:
   - Run `kubectl get nodes` periodically.
   - Node changes to "NotReady" after a few minutes.
   - Wait 10-12 minutes; GKE recreates the node, preserving name.

5. **Test Deployment**:
   - Apply a deployment (e.g., `nginx-deployment.yaml`):
     ```yaml
     apiVersion: apps/v1
     kind: Deployment
     metadata:
       name: nginx-deployment
     spec:
       replicas: 11
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
             image: nginx
             resources:
               requests:
                 cpu: 100m
                 memory: 300Mi
     ```
     ```bash
     kubectl apply -f nginx-deployment.yaml
     ```

   - Scale deployment:
     ```bash
     kubectl scale deployment nginx-deployment --replicas=11
     ```
   - Check pods:
     ```bash
     kubectl get pods -o wide
     ```

6. **Disable Auto Repair**:
   - Update node pool:
     ```bash
     gcloud container node-pools update [NODE_POOL_NAME] \
       --cluster=[CLUSTER_NAME] \
       --location=[LOCATION] \
       --no-enable-auto-repair
     ```

7. **Simulate Failure Without Auto Repair**:
   - Stop kubelet again on a node.
   - Observe pods remain pending; no automatic repair.
   - Manually add nodes: Resize node pool to increase count, then delete faulty nodes.

8. **Monitor Pod Scheduling**:
   - New nodes allow pods to schedule correctly.
   - GKE drains pods from failed nodes over time.

✅ **Key Observation**: With auto repair enabled, nodes recover automatically; disabled, manual intervention is required.

## Summary

### Key Takeaways
```diff
+ Auto repair ensures node health in GKE, automatically repairing failed nodes by draining and recreating them.
+ Enabled by default in autopilot clusters and new standard node pools using release channels.
+ Repair triggers on specific criteria: not ready status, no status reports (>10min), disk full (>30min), or cordoned state (>10min in autopilot).
+ Process preserves node names but changes IPs, with up to 1-hour drain timeout.
- Disabling auto repair can lead to prolonged outages, pod scheduling failures, and requires manual node management.
! Avoid disabling in production; use only for controlled testing.
```

### Expert Insight

#### Real-world Application
In production GKE clusters, auto repair minimizes downtime for applications like e-commerce platforms or real-time services. For example, if a node fails due to hardware issues, GKE drains running pods (e.g., web servers or databases) to healthy nodes and provisions a new one, ensuring continuity. This is critical in high-availability scenarios where even brief outages can impact revenue.

#### Expert Path
- **Monitoring**: Integrate with Google Cloud Monitoring to alert on repair events and node health metrics.
- **Load Balancing**: Ensure load balancers and ingress controllers handle node IP changes post-repair.
- **Resource Planning**: Design node pools with adequate capacity to absorb pod evictions during repairs.
- **Automation Scripts**: Write scripts using `gcloud` and Kubernetes APIs to customize repair behaviors if needed.

#### Common Pitfalls
- **Disabling in Production**: Leads to nodes staying down, affecting scalability. Avoid unless absolutely necessary (e.g., during OS updates).
- **IP Dependency**: Applications relying on static IPs may break; use service discovery instead.
- **Resource Exhaustion**: Over-subscribed nodes delay repairs; monitor CPU/memory usage.
- **Boot Disk Issues**: Persistent disk space problems can cause repeated repairs; implement disk monitoring alerts.
- **Parallel Repairs**: Large clusters with multiple simultaneous failures may strain resources; balance cluster size appropriately.

#### Lesser Known Things
- Repairs can take 10-20 minutes due to health check thresholds, allowing time for transient issues to resolve.
- In autopilot, cordoning thresholds (10 minutes) are stricter than standard clusters for faster recovery.
- Node names are preserved, but pod affinities or node selectors may need updates if relying on specific node identities.
- Repair events log in Kubernetes events; query with `kubectl get events --sort-by=.metadata.creationTimestamp` for troubleshooting.

**Corrections Made**: Fixed spelling and typos from transcript, including "no router repair" to "node auto repair", "GK" to "GKE", "cubctl" to "kubectl", "porta" to "pods", "i" to "if", "gk" to "GKE", "poolool" to "pool", and minor grammatical inconsistencies like "it will be held in a running state" to clarify as "it will be kept in a running state". These were standardized for technical accuracy while preserving the original meaning. If additional context is needed, refer back to the raw transcript.
