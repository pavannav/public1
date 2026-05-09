# Session 27: Q & A Discussion

## Table of Contents
- [Overview](#overview)
- [Key Concepts / Deep Dive](#key-concepts--deep-dive)
  - [Cluster IP vs NodePort Access](#cluster-ip-vs-nodeport-access)
  - [Internal vs External IP Addresses](/cluster-ip-vs-nodeport-access)
  - [Secondary IP Ranges in GKE](#secondary-ip-ranges-in-gke)
  - [Service Ports Explained](#service-ports-explained)
  - [Firewall Rules and Ingress](#firewall-rules-and-ingress)
  - [Autoscaling and Network Tags](#autoscaling-and-network-tags)

## Overview
This session covers a Question and Answer discussion focused on Kubernetes service exposition, IP address behaviors in Google Kubernetes Engine (GKE), and networking considerations. Participants explore practical challenges with Cluster IPs, NodePorts, firewall rules, and architecture decisions for production environments. The discussion emphasizes understanding internal networking, access patterns, and best practices for exposing applications in cloud-native setups.

## Key Concepts / Deep Dive

### Cluster IP vs NodePort Access
Kubernetes services provide different exposure mechanisms:
- **Cluster IP**: Internal service accessible only within the cluster. Attempts to access via browser from outside fail, even if the IP appears external-like.
- **NodePort**: Exposes service on each node's IP at a static port (range 30000-32767). Access requires using the node's external IP and the assigned NodePort.
- **Access Requirement**: NodePort mandates the virtual machine's (VM) external IP, not cluster IP.

```diff
- Cluster IP: 10.x.x.x or 34.x.x.x series - Internal only, not browser-accessible
+ NodePort: VM External IP + Port (e.g., 192.168.x.x:30001) - Accessible externally
```

> [!WARNING]
> Using Cluster IP for external access will result in connection failures. Always route NodePort requests through the node's external IP.

### Internal vs External IP Addresses
IP address ranges in GKE can mislead:
- Cluster IPs in the 34.x.x.x range (formerly reserved for external) are now internal to the cluster.
- Prior to six months ago, GKE assigned 10.x.x.x (clearly internal) ranges, but now defaults to 34.x.x.x, causing confusion.
- **Key Distinction**: Appearance as "external IP" does not equate to external accessibility.

```diff
! Misleading External-Looking IPs: 34.x.x.x Cluster IPs - Internal Usage Only
- Do not use for browser access
+ Prefix indicates range: 10.0.0.0/8 (internal) or custom ranges if configured
```

### Secondary IP Ranges in GKE
For fine-grained control in production:
- GKE allows defining secondary IP ranges for pods and services separately.
- Default: GKE auto-assigns, potentially mixing internal/external-appearing IPs.
- **Custom Configuration**:
  - Create secondary ranges via networking class.
  - Assign one range for pods, another for services during cluster creation.
- **Benefits**: Prevents IP range conflicts and provides predictable allocations.

### Service Ports Explained
Kubernetes services define three key ports:

| Port Type | Description | Typical Range | Usage |
|-----------|-------------|---------------|--------|
| Target Port | Port where the container listens inside the pod | Usually container's port (e.g., 8080) | Internal routing to container |
| Port | Abstracted port for the service | Arbitary (e.g., 80, 443, 3000+) | Service-level exposure |
| NodePort | Randomly assigned high port on each node | 30000-32767 | External access via node IP |

```diff
+ Port Flexibility: Service 'Port' can be privileged if needed (e.g., 80/443)
- NodePort Range: Fixed high ports only, cannot be custom low ports
```

- **Routing Flow**: All service types ultimately forward to the container's Target Port.
- Load Balancer services use the Port, Cluster IP uses Port, NodePort adds the NodePort overlay.

### Firewall Rules and Ingress
Ingress creates specific firewall rules:
- Creates exactly one firewall rule named "k8s-gl7-xxxx" (e.g., L7 for layer 7).
- Rule applies network tags to allow traffic.
- **Scope**: Tags are automatically applied to all nodes in the cluster for uniform access.

> [!NOTE]
> Multiple kubernetes-cluster firewall rules exist by default, but Ingress-specific rules are singular and targeted.

### Autoscaling and Network Tags
Network behavior during scaling:
- Firewall tags are applied cluster-wide via managed instance groups (MIG).
- When autoscaling adds nodes (e.g., resizing node pool from 2 to 3), new nodes automatically receive the same network tags.
- **Instance Template Benefit**: Ensures all current and future nodes share identical networking configurations.

```diff
+ Autoscaling Compatibility: Tags propagate automatically
- Manual Tag Management: Unnecessary due to MIG templates
```

## Summary

### Key Takeaways
```diff
+ Cluster IPs are internal despite potentially external-looking ranges
+ NodePort requires VM external IP for access
+ Define secondary IP ranges for production control
+ Understanding service ports (Target, Port, NodePort) is crucial for routing
+ Ingress creates one L7 firewall rule with cluster-wide tags
+ Autoscaling maintains consistent network tags via MIG
```

### Quick Reference
- **Access Patterns**:
  - Cluster IP: Internal (e.g., `10.0.0.1:3000`) - Not external
  - NodePort: External (e.g., `VM-IP:30000-32767`) - Browser-accessible
- **Default Firewall Rule**: `k8s-gl7-xxxx` (L7 targeting)
- **Port Types**: Target (container), Port (service), NodePort (node-level)

### Expert Insight
- **Real-world Application**: In production GKE clusters, always implement load balancer services with Ingress for external exposure. Use NodePort sparingly for development/testing to avoid port conflicts.
- **Expert Path**: Master GCP networking by experimenting with VPC subnets, secondary ranges, and firewall configurations to build secure, scalable applications.
- **Common Pitfalls**: Avoid assuming 34.x.x.x ranges are external (they're not). Resolution: Always verify cluster accessibility via NodePort or LoadBalancer. Prevention: Document IP ranges in infrastructure-as-code.
- **Lesser-Known Facts**: GKE's IP range changes (post-COVID) improved internal networking but introduced UI confusion. Pure secondary ranges allow IPv6 readiness if needed.
- **Advantages and Disadvantages**: Cluster IP is secure (internal-only) but limits direct external access. NodePort enables quick testing but exposes high ports with manual IP management risk. Load Balancers balance ease and cost but require additional GCP resources.
