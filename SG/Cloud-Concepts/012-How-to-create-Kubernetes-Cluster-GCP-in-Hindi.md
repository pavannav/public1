# Session 012: How to Create Kubernetes Cluster in GCP

<details open>
<summary><b>Session 012: How to Create Kubernetes Cluster in GCP (Claude Opus 4)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts](#key-concepts)
- [Lab Demo: Creating a GKE Cluster](#lab-demo-creating-a-gke-cluster)
- [GKE Cluster Configuration Options](#gke-cluster-configuration-options)
- [Node Pool Configuration](#node-pool-configuration)
- [Cost Optimization Options](#cost-optimization-options)
- [Summary](#summary)

## Overview
This session covers creating a Google Kubernetes Engine (GKE) cluster in Google Cloud Platform, including cluster creation modes (Autopilot vs Standard), node pool configuration, networking options, and cost optimization strategies.

## Key Concepts

### Google Kubernetes Engine (GKE)
GKE is Google's managed Kubernetes service that automates the deployment, scaling, and management of containerized applications using Kubernetes.

### Cluster Types

#### Autopilot Mode
- **Fully Managed**: Google manages the entire cluster including nodes
- **Pay Per Pod**: Charged only for resources used by pods
- **Simplified Operations**: Minimal configuration required
- **Best For**: Teams wanting managed Kubernetes without operational overhead

#### Standard Mode
- **Full Control**: User manages node configuration and maintenance
- **Pay Per Node**: Charged for the entire node regardless of utilization
- **Custom Configuration**: Fine-grained control over cluster settings
- **Best For**: Teams requiring specific configurations or workloads

### Control Plane
The control plane manages the Kubernetes cluster and includes:
- API Server
- Scheduler
- Controller Manager
- etcd (cluster state storage)
- **Note**: Control plane is managed by Google and not directly accessible

### Release Channels
Control plane version management options:
- **Rapid**: Latest features, frequent updates
- **Regular**: Balanced stability and features
- **Stable**: Maximum stability, fewer updates

## Lab Demo: Creating a GKE Cluster

### Step 1: Access GKE Console
```
GCP Console → Kubernetes Engine → Clusters → Create
```

### Step 2: Choose Cluster Type
```
Options:
1. Autopilot: Fully managed, pay-per-pod
2. Standard: User-managed nodes, pay-per-node
```

### Step 3: Configure Basic Settings (Standard Mode)
```
Cluster Basics:
- Name: [cluster-name]
- Location Type:
  - Zonal: Single zone deployment
  - Regional: Multi-zone for higher availability
- Zone/Region: Select appropriate location
- Version: Choose from available Kubernetes versions
```

### Step 4: Configure Node Pool Settings
```
Default Node Pool:
- Number of nodes: 3 (or desired count)
- Machine type: e2-medium (4GB RAM, 2 vCPU)
- Image type: Container-Optimized OS
- Boot disk size: Default or custom

Autoscaling:
- Enable cluster autoscaler
- Set minimum and maximum node counts
- Configure based on workload requirements
```

### Step 5: Configure Networking
```
Network Configuration:
- Network: VPC network selection
- Subnet: Specific subnet for cluster
- Maximum pods per node: Default 110

Private Cluster (Optional):
- Enable private nodes
- Configure master authorized networks
- Set up Cloud NAT for outbound access
```

### Step 6: Security and Access
```
Security Options:
- Service Account: Default or custom
- Access Scopes: API access configuration
- Shielded Nodes: Enhanced security features
- Workload Identity: IAM integration for pods
```

### Step 7: Create Cluster
```
Review configuration
Click "Create"
Cluster creation takes approximately 5 minutes
```

## GKE Cluster Configuration Options

### Location Types

#### Zonal Cluster
- Single zone deployment
- Lower latency within zone
- Risk of zone-wide outages

#### Regional Cluster
- Spans multiple zones in a region
- Higher availability
- Automatic failover capabilities

### Node Configuration

#### Machine Types
```
General Purpose:
- e2 series: Cost-effective
- n2 series: Latest generation

Memory Optimized:
- High memory-to-CPU ratio
- Suitable for memory-intensive workloads

Compute Optimized:
- High CPU-to-memory ratio
- Suitable for compute-intensive workloads
```

#### Node Images
- **Container-Optimized OS**: Default, minimal attack surface
- **Ubuntu**: Familiar Linux environment
- **Windows Server**: For Windows containers

### Networking Configuration

#### IP Allocation
```
Node IP Range: Primary network for nodes
Pod IP Range: Secondary range for pods
Service IP Range: ClusterIP services

Maximum Pods per Node:
- Default: 110
- Configurable based on workload density
```

#### Network Policies
- Enable for pod-to-pod communication control
- Implement micro-segmentation
- Kubernetes NetworkPolicy support

## Node Pool Configuration

### Default Node Pool
Created automatically with cluster creation:
- Inherits cluster configuration
- Can be modified post-creation
- Serves as initial compute capacity

### Additional Node Pools
```yaml
Purpose: Heterogeneous workloads
Configuration:
  - Different machine types
  - Specialized hardware (GPUs, TPUs)
  - Separate scaling policies
  - Node taints and labels
```

### Autoscaling Configuration
```
Minimum Nodes: 1 (or based on requirements)
Maximum Nodes: Based on expected load
Scaling Triggers:
  - CPU utilization
  - Memory utilization
  - Custom metrics
  - Scheduled scaling
```

## Cost Optimization Options

### Preemptible/Spot VMs
```diff
+ Significant cost savings (up to 80% discount)
+ Suitable for fault-tolerant workloads
- VMs can be terminated with 30-second notice
- Not suitable for critical/production workloads
```

### Committed Use Discounts
- 1-year or 3-year commitments
- Up to 57% discount on machine types
- Predictable workloads benefit most

### Cluster Autoscaler
- Automatically adjusts node count
- Prevents over-provisioning
- Cost-effective resource utilization

## Verifying Cluster Creation

### Console Verification
```
GCP Console → Kubernetes Engine → Clusters
- View cluster status
- Check node count and health
- Monitor resource utilization
```

### gcloud Commands
```bash
# List clusters
gcloud container clusters list

# Describe cluster
gcloud container clusters describe CLUSTER_NAME --zone ZONE

# Get credentials
gcloud container clusters get-credentials CLUSTER_NAME --zone ZONE

# List nodes
kubectl get nodes
```

## GKE Architecture Components

### Control Plane Components (Managed by Google)
- Kubernetes API Server
- Scheduler
- Controller Manager
- etcd Database
- **Access**: Via kubectl and GCP Console only

### Worker Node Components
- kubelet (node agent)
- kube-proxy (networking)
- Container runtime (containerd)
- Node Problem Detector

### Google-Specific Components
- GKE metadata server
- Google Cloud logging agent
- Monitoring agents
- Network plugins (CNI)

## Summary

### Key Takeaways
```diff
+ GKE provides managed Kubernetes with two deployment modes
+ Autopilot mode charges per pod with minimal management overhead
+ Standard mode provides full control with node-level pricing
+ Regional clusters provide higher availability across zones
+ Node pools enable heterogeneous workload support
+ Cluster autoscaler optimizes costs through dynamic scaling
+ Preemptible VMs offer significant cost savings for appropriate workloads
- Control plane is fully managed and not directly accessible
- Maximum 110 pods per node by default
- Preemptible VMs can be terminated unexpectedly
```

### Quick Reference
```bash
# Create cluster with gcloud
gcloud container clusters create CLUSTER_NAME \
    --zone ZONE \
    --num-nodes 3 \
    --machine-type e2-medium \
    --enable-autoscaling \
    --min-nodes 1 \
    --max-nodes 5

# Create Autopilot cluster
gcloud container clusters create-auto CLUSTER_NAME \
    --region REGION

# Get cluster credentials
gcloud container clusters get-credentials CLUSTER_NAME --zone ZONE

# Delete cluster
gcloud container clusters delete CLUSTER_NAME --zone ZONE

# List available zones
gcloud container zones list
```

### Expert Insight

#### Real-world Application
- Deploy containerized microservices with automatic scaling
- Implement CI/CD pipelines with GKE for application deployments
- Create development/staging environments with cost-effective configurations

#### Expert Path
- Master advanced features like Workload Identity and Binary Authorization
- Implement multi-cluster architectures with Anthos
- Optimize costs with committed use discounts and preemptible nodes
- Design production-grade clusters with proper security and networking

#### Common Pitfalls
- Not enabling autoscaling for variable workloads
- Using preemptible VMs for critical production workloads
- Ignoring regional deployment for high availability requirements
- Not configuring proper resource requests/limits for pods
- Overlooking network security policies for pod communication

</details>