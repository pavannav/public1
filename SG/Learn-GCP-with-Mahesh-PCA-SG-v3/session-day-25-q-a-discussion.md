# Session 25: Q & A Discussion

## Table of Contents
- [Planning Node and Pod Capacity](#planning-node-and-pod-capacity)
- [Autopilot vs Standard Kubernetes Clusters](#autopilot-vs-standard-kubernetes-clusters)
- [IAM Access Control for GCP Resources](#iam-access-control-for-gcp-resources)
- [Use Cases for Multiple Node Pools in GKE](#use-cases-for-multiple-node-pools-in-gke)

## Planning Node and Pod Capacity

### Overview
Planning node and pod capacity in Kubernetes clusters involves determining the resource requirements for workloads, including CPU and memory needs, and scaling the infrastructure accordingly. This is critical for cost control, performance, and resource optimization, especially in GCP's GKE.

### Key Concepts

#### Workload Resource Requirements
- **Pod Resource Estimation**: Each pod requires a minimum amount of vCPU and RAM to operate. For example, a machine learning workload for emotion detection from videos might need 4 vCPU and 16 GB RAM per pod.
- **Trial-and-Error Approach**: Developers may not provide accurate resource information. Start with low configurations and increase based on failures (e.g., pod failing to start indicates insufficient resources).
- **Minimum Node Size**: Nodes should be at least 1.5x the pod's maximum resource requirements to accommodate system overhead. For instance, with a 4 vCPU/16 GB pod, aim for nodes with at least 8 vCPU and 24 GB RAM.

#### Cluster Scaling Factors
- **Node Configuration**: Based on pod needs, select appropriate machine types. Consider predefined or custom instances.
- **Quota Considerations**: GCP has limits on quotas per region (e.g., number of nodes). Budget and quotas dictate how many nodes you can afford.
- **Workload Types**: Light workloads (e.g., simple apps) vs. heavy workloads (e.g., ML) determine sizing. Always baseline on highest-demand pods.

> [!IMPORTANT]  
> Accurate resource planning prevents over-provisioning (wasteful) or under-provisioning (application failures).

> [!NOTE]  
> In autopilot mode (GKE Autopilot), resource provisioning is automatic based on metrics, but requires understanding to avoid surprises.

## Autopilot vs Standard Kubernetes Clusters

### Overview
GKE offers two cluster modes: Autopilot for automated management and Standard for manual control. Autopilot simplifies scaling and operations, while Standard provides flexibility for expert users. Understanding when to use each is key for cloud architects.

### Key Concepts

#### Autopilot Mode
- **Automatic Provisioning**: Provisions nodes and pods based on traffic load without manual intervention.
- **Advantages**: Easier deployment, automatic scaling, and resource adjustment.
- **Limitations**: Some features are controlled by Google and cannot be customized. May not suit advanced use cases.

#### Standard Mode
- **Manual Control**: Architects have full control over node configurations, scaling policies, and customizations.
- **Use Cases**: Preferred when Kubernetes experts need fine-tuning, like in migrations from other clouds.
- **Comparison Analogy**: Like manual transmission vs. automatic in a car – experts prefer control for complex scenarios.

```diff
! Autopilot: Automatic node/pod provisioning based on metrics
! Standard: Manual control for expert-driven configurations
- Limitations in Autopilot: Reduced customization
+ Advantages of Standard: Full control for complex architectures
```

> [!WARNING]  
> Customers migrating from AWS may choose Standard due to uncontrollable parameters in Autopilot.

> [!NOTE]  
> Autopilot hides complexities, making it ideal for non-expert teams, but Standard allows "manual transmission" adjustments.

## IAM Access Control for GCP Resources

### Overview
IAM (Identity and Access Management) controls access to GCP resources like projects, clusters, and workloads. Granting appropriate roles ensures visibility without excessive permissions, following the principle of least privilege.

### Key Concepts

#### Role-Based Access
- **Viewer Role**: Grants read-only access to projects, clusters, workloads, IAM policies, and Kubernetes resources.
- **Project-Level Access**: Allows viewing project details; use browser role for dropdown visibility.
- **Kubernetes Predefined Roles**: Roles like `roles/container.viewer` for cluster access; discussed in detail in upcoming sessions.

#### Troubleshooting Access Issues
- **Common Problem**: Users can't see projects or clusters despite logins.
- **Solution**: Add roles at project or organization level. For example, binding viewer role allows viewing workloads, IAMPolicies, etc.

```bash
# Example: Grant viewer access to a user
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member=user:USER_EMAIL \
  --role=roles/viewer
```

> [!IMPORTANT]  
> Viewer roles provide necessary visibility for monitoring without edit permissions.

> [!NOTE]  
> Predefined Kubernetes roles are based on earlier IAM concepts and will be covered in backup sessions.

## Use Cases for Multiple Node Pools in GKE

### Overview
Node pools group nodes with similar configurations, enabling workload isolation and optimization. In GKE, multiple node pools support diverse applications on the same cluster, improving efficiency for migrations and multi-tenancy.

### Key Concepts

#### Workload-Specific Node Pools
- **Example Setup**: One pool for GPU workloads (e.g., ML apps) and another for CPU-based web apps.
- **Taint/Toleration and Affinity**: Control pod scheduling to specific pools for resource matching.

```bash
# Example: Create a GPU node pool
gcloud container node-pools create gpu-pool \
  --cluster CLUSTER_NAME \
  --accelerator type=nvidia-tesla-k80,count=1 \
  --machine-type n1-highmem-4 \
  --num-nodes 1
```

#### Migration and Isolation
- **Use Case 1**: Run existing workloads on original pool, add new pool for migrated apps to prevent impact.
- **Benefits**: Easy rollback by deleting the new pool if issues arise.
- **Analogy**: Like apartment blocks – each block is isolated for different tenants or uses.

#### Multi-Tenant SaaS Applications
- **Per-Customer Pools**: Create dedicated pools for each SaaS customer for security and resource isolation.
- **Lifecycle Management**: Add pools on onboarding, remove on unsubscribing.
- **Example**: Customer-specific pools in a multi-tenant GKE cluster.

```bash
# Example: Scale a node pool
gcloud container clusters update CLUSTER_NAME \
  --enable-autoscale \
  --min-nodes 1 \
  --max-nodes 10 \
  --node-pool cpu-pool
```

#### Running Multiple Apps in One Cluster
- **Feasibility**: Possible; use multiple node pools for different apps to avoid interference.
- **Isolation Strategy**: Dedicate pools per app or tenant for scaling and security.

> [!IMPORTANT]  
> Node pools enable workload separation, reducing risks in large clusters.

> [!NOTE]  
> Additional use cases include cross-project migrations and custom configurations for node types.

## Summary

### Key Takeaways
```diff
+ Planning: Start with pod resource needs (vCPU/RAM), then node sizing (1.5x minimum), and consider GCP quotas for cluster scale
+ Mode Choice: Autopilot for ease, Standard for control – choose based on team expertise
+ IAM Access: Use viewer roles for project/cluster visibility; troubleshoot by adding bindings
+ Node Pools: Essential for workload isolation, migrations, and multi-tenancy in GKE
! No sub-topics skipped: All questions covered, including capacity planning, mode differences, access control, and pool use cases
```

### Quick Reference
- **Pod Minimum Resources**: 4 vCPU / 16 GB RAM (example ML workload)
- **Node Sizing Formula**: At least 1.5x pod max (e.g., 4 vCPU pod → 8 vCPU node)
- **Add IAM Role**: `gcloud projects add-iam-policy-binding --role=roles/viewer`
- **Create Node Pool**: `gcloud container node-pools create gpu-pool --accelerator type=nvidia-tesla-k80,count=1`
- **Autopilot Feature**: Auto-scales nodes/pods based on metrics
- **Standard Mode**: Full manual control over nodes and scaling

### Expert Insight

#### Real-World Application
In production, architects use node pools for blue-green deployments via separate pools, ensuring zero-downtime migrations. For example, Netflix or similar platforms leverage GKE's multi-pool setup to handle diverse workloads (e.g., streaming vs. analytics) with isolated resources, allowing automatic scaling while tying back to IAM for access governance.

#### Expert Path
Master GKE Autopilot by practicing auto-scaling metrics via Cloud Monitoring. Dive into taint/toleration for advanced node pool scheduling. As an architect, simulate AWS-to-GCP migrations using Standard mode to control costs and configurations.

#### Common Pitfalls
- **Underestimating Resources**: Failing to account for system overhead leads to pod evictions; always use 1.5x sizing.
- **Over-Provisioning Nodes**: Ignoring quotas causes creation failures; monitor GCP limits per region.
- **IAM Gaps in Autopilot**: Reduced visibility due to Google-managed features can surprise experts; test access with viewer roles first.

#### Lesser-Known Facts
- Node pools in GKE can optimize Sustained Use Discounts by grouping similar workloads, reducing costs over time.
- Autopilot internally uses GKE optimization algorithms based on historical metrics, pre-tuning for common workloads like web apps.
- Multi-tenancy with node pools can simulate virtual private clouds within a shared cluster, enhancing security without VPC overhead.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
