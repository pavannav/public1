# Session 012: How to Create Kubernetes Cluster on GCP

<details open>
<summary><b>How to Create Kubernetes Cluster on GCP (KK-CS45-script-v3)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
  - [GKE Cluster Types](#gke-cluster-types)
  - [Control Plane Versions](#control-plane-versions)
  - [Node Pools](#node-pools)
  - [Auto-scaling](#auto-scaling)
  - [Machine Types](#machine-types)
  - [Spot Instances](#spot-instances)
  - [Networking Considerations](#networking-considerations)
  - [Service Accounts](#service-accounts)
- [Lab Demo: Creating a Kubernetes Cluster](#lab-demo-creating-a-kubernetes-cluster)
- [Summary](#summary)

## Overview

This session covers the fundamental steps for creating a Kubernetes cluster on Google Cloud Platform (GCP) using Google Kubernetes Engine (GKE). The tutorial demonstrates the creation process through the GCP Console, explaining various configuration options and best practices for production deployments.

> [!NOTE]
> This session is presented in Hindi but focuses on practical GKE cluster creation steps that apply universally.

## Key Concepts and Deep Dive

### GKE Cluster Types
GKE offers two primary cluster modes:

- **Standard Mode**: Traditional Kubernetes control plane where you pay for control plane management
- **Autopilot Mode**: Fully managed Kubernetes where you pay only for the resources your containers actually use

### Control Plane Versions
The control plane version determines the Kubernetes API version and features:

- **Static Channel**: Specific version you choose and maintain manually
- **Regular Channel**: Regular updates with new features
- **Rapid Channel**: Fast-paced updates with latest features (higher risk)
- **Stable Channel**: Slow, carefully tested updates (most stable)

### Node Pools
Node pools are groups of worker nodes with similar configurations:

- Can have multiple node pools per cluster
- Each pool has its own machine type configuration
- Supports different scaling policies per pool

### Auto-scaling
Automatic node scaling based on workload demands:

- **Minimum Nodes**: Base number of nodes always running
- **Maximum Nodes**: Upper limit for nodes (prevents cost overruns)

### Machine Types
Various compute instance types available:

| Type | Use Case | Characteristics |
|------|----------|----------------|
| e2-medium | General purpose | 2 vCPUs, 4GB RAM |
| n1-standard | Balanced compute | Various CPU/memory ratios |
| n1-highmem | Memory intensive | High memory, moderate CPU |
| n1-highcpu | CPU intensive | High CPU, moderate memory |
| Custom machines | Specialized | User-defined specifications |

### Spot Instances

```diff
+ Cost-effective compute option (up to 70% cheaper than regular instances)
- Can be preempted by Google with 30-second warning
! Best for fault-tolerant workloads, not for critical applications
```

Key characteristics:
- Preemptible VMs that can be terminated by Google
- No guarantee of runtime duration
- Ideal for batch processing, CI/CD, testing environments

### Networking Considerations
Critical networking limits and configurations:

- **Pod Limit per Node**: Maximum 110 pods per node
- Influences cluster architecture decisions
- Affects service account assignments

### Service Accounts
Authentication mechanism for cluster operations:

- **Default Service Account**: Used when no specific account specified
- **Custom Service Accounts**: For fine-grained access control
- Determines permissions for cluster management and resource access

## Lab Demo: Creating a Kubernetes Cluster

### Step 1: Access GCP Console
1. Navigate to Google Cloud Console
2. Search for "Kubernetes Engine" or "GKE"
3. Click on "Create" option

### Step 2: Choose Cluster Mode
```bash
# Choose between:
- Standard: Full control, pay for control plane
- Autopilot: Managed, pay-per-use
```

### Step 3: Configure Basic Settings
- **Name**: Choose descriptive cluster name
- **Region**: Select geographic region (e.g., us-central1)
- **Zones**: Select specific zones within region for high availability

### Step 4: Control Plane Configuration
- **Version Channel**: Select update frequency:
  - Static (manual updates)
  - Regular (balanced updates)
  - Rapid (latest features)
- **Auto-upgrades**: Enable/disable automatic version updates

### Step 5: Node Pool Configuration
```yaml
nodePools:
- name: default-pool
  initialNodeCount: 2
  config:
    machineType: e2-medium
```

- **Node Count**: Set initial number of worker nodes
- **Machine Type**: Select appropriate compute instances
- **Spot/Preemptible**: Enable for cost savings (if acceptable for workload)

### Step 6: Enable Auto-scaling
```yaml
autoscaling:
  enabled: true
  minNodeCount: 1
  maxNodeCount: 10
```

- **Minimum Nodes**: Base capacity (recommended: 1-3)
- **Maximum Nodes**: Upper scaling limit (based on budget/quota)

### Step 7: Networking Options
```yaml
networking:
  podRange: default
  serviceRange: default
  podLimitPerNode: 110
```

### Step 8: Service Account
- Use default service account or specify custom account
- Ensure proper permissions for cluster operations

### Step 9: Create Cluster
1. Click "Create"
2. Wait approximately 5 minutes for provisioning
3. Verify cluster status in GKE dashboard

### Verification Steps
```bash
# After cluster creation, verify:
- 3 nodes active (2 worker + 1 control plane proxy)
- Machine type: e2-medium (2vCPU, 4GB RAM default)
- Region and zones match selection
```

## Summary

### Key Takeaways
```diff
+ GKE offers two modes: Standard (full control) vs Autopilot (managed)
+ Region and zone selection impacts performance and compliance
+ Control plane versions determine update frequency and stability
+ Node pools allow heterogeneous machine configurations
+ Auto-scaling prevents over/under-provisioning costs
+ Spot instances provide significant cost savings for fault-tolerant workloads
+ Pod limits (110 per node) affect cluster architecture
+ Default configuration suitable for basic use cases
! Advanced options covered in subsequent videos
```

### Quick Reference

#### Basic Cluster Creation Commands
```bash
# CLI equivalent (alternative to console):
gcloud container clusters create my-cluster \
  --region us-central1 \
  --num-nodes 2 \
  --machine-type e2-medium
```

#### Key Configuration Values
| Parameter | Default | Typical Range | Notes |
|-----------|---------|---------------|-------|
| Node Count | 2 | 1-1000+ | Scale as needed |
| Machine Type | e2-medium | e2-medium to high-end | Balance cost/performance |
| Region | varies | global | Consider data locality |
| Max Pods/Node | 110 | fixed | Design accordingly |

### Expert Insight

#### Real-world Application
In production environments, start with Standard mode for full control over cluster behavior. Use multiple node pools for different workload types (web servers on e2-medium, data processing on high-memory instances). Implement auto-scaling with appropriate min/max bounds to handle traffic spikes while controlling costs.

#### Expert Path
Master GKE cluster creation by understanding:
1. Cost optimization through spot instances and auto-scaling
2. High availability through multi-zone deployment
3. Security through custom service accounts and network policies
4. Performance monitoring and right-sizing strategies

#### Common Pitfalls
- Over-provisioning without auto-scaling leads to wasted costs
- Using Autopilot without understanding the "pay per pod" model
- Ignoring regional compliance requirements
- Forgetting pod limit constraints when designing microservices
- Using spot instances for stateful or critical workloads

</details>