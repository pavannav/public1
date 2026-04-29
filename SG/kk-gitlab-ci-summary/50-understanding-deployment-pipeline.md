# Session 50: Understanding Deployment Pipeline

## Overview of Kubernetes

Kubernetes (K8s) is an open-source container orchestration platform originally developed by Google and now maintained by the Cloud Native Computing Foundation (CNCF). It automates the deployment, scaling, and management of containerized applications.

💡 **Key Benefits:**
- Automates container lifecycle management
- Provides self-healing capabilities
- Enables declarative configuration

## Core Components

### Nodes
Nodes are the individual machines (physical or virtual) that form a Kubernetes cluster.

| Node Type | Purpose | Key Features |
|-----------|---------|--------------|
| **Worker Nodes** | Host and run containerized applications | Run pods, managed by control plane |
| **Control Plane Nodes** | Manage the overall cluster | Include API server, scheduler, controller manager, etcd |

🔍 **Control Plane Components:**
- **API Server**: Entry point for cluster management and serves the Kubernetes API
- **Controller Manager**: Maintains desired cluster state
- **Scheduler**: Assigns pods to appropriate nodes
- **etcd**: Distributed key-value store for cluster data

## Pods and Workloads

### Pods
Pods are the smallest deployable unit in Kubernetes, representing a single instance of a running process.

📝 **Pod Characteristics:**
- Contains one or more containers that share network namespace, storage, and IP address
- Typically used to group containers that work together
- Example: Single container deployment (common pattern)

⚠️ **Pod Lifecycle Management:**
Pods do not automatically restart if they fail, requiring external management for resilience.

### Replication Controllers vs Deployments
To ensure pod availability, Kubernetes provides higher-level abstractions.

| Controller Type | Purpose | Key Features |
|----------------|---------|--------------|
| **Replication Controller** | Manages pod copies | Basic scaling and self-healing |
| **Deployment** (Recommended) | High-level abstraction for pods and ReplicaSets | Declarative updates, rolling updates, rollback |

💡 **Deployment Benefits:**
- Describes desired application state
- Kubernetes handles actual state transitions
- Provides rolling updates and version management

## Services and Network Access

### Service Fundamentals
Services provide stable network endpoints for accessing pods, enabling load balancing across multiple pod instances.

✅ **Service Capabilities:**
- Consistent access regardless of pod changes
- Traffic distribution across pods
- Seamless scaling without breaking external connections

### Service Types Comparison

| Service Type | External Access | Load Balancer | Use Case |
|--------------|-----------------|----------------|----------|
| **ClusterIP** | Internal only | Kubernetes native | Internal cluster communication |
| **NodePort** | Via node IP:port | None | Development environments |
| **LoadBalancer** | External load balancer | Cloud provider | Production external access |
| **ExternalName** | DNS redirect | None | External service integration |

### Special Considerations: LoadBalancer Service

💰 **Cost and Availability Factors:**
- Creates external load balancer (AWS ELB, GCP Load Balancer, etc.)
- Features vary by cloud provider or infrastructure
- Each exposed service typically requires a dedicated load balancer
- Additional costs for multiple exposed applications

```
Mermaid Diagram: Basic Service Flow
graph LR
    A[External Traffic] --> B[LoadBalancer]
    B --> C[Service]
    C --> D[Pod 1]
    C --> E[Pod 2]
    C --> F[Pod N]
```

## Ingress for Advanced Routing

### Ingress Overview
Ingress manages HTTP/HTTPS traffic routing into the cluster, providing sophisticated routing capabilities beyond basic load balancers.

🚀 **Ingress Advantages:**
- Flexible traffic routing rules
- Supports path-based and domain-based routing
- Handles multiple services under single domain
- Processes HTTP request attributes

### ClusterIP with Ingress Best Practice

When using Ingress, services are typically configured as **ClusterIP** type.

> [!IMPORTANT]
> ClusterIP services provide internal cluster access while maintaining granular control over external exposure. This prevents unintended service exposure and optimizes network architecture.

> [!NOTE]
> Service type and Ingress configuration should align with specific application requirements and infrastructure constraints.

> [!WARNING]
> Avoid overusing LoadBalancer services due to potential cost implications and resource overhead when exposing multiple applications.

## Final Architecture Flow

```
Client Request → Ingress Controller → Routing Rules → Service (ClusterIP) → Pod(s)
```

This deployment pipeline enables scalable, resilient containerized applications through orchestrated network access and workload management. Select service types based on exposure requirements and cost considerations.
