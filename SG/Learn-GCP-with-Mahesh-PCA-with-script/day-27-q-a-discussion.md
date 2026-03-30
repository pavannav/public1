Session 27: Q & A Discussion

## Table of Contents
- [Accessing Kubernetes Services](#accessing-kubernetes-services)
- [Service Types and Port Explanations](#service-types-and-port-explanations)
- [Ingress Configuration and Networking](#ingress-configuration-and-networking)
- [Cluster Scaling and Firewall Rules](#cluster-scaling-and-firewall-rules)

## Accessing Kubernetes Services

### Overview
This Q&A session addresses common questions about accessing Kubernetes services, particularly the differences between cluster IP and node port services, and what ports to use for external access.

### Key Concepts/Deep Dive

#### Cluster IP vs Node Port Access
- Cluster IP is internal only and cannot be accessed from outside the cluster
- Even if cluster IP appears to use external IP ranges (like 34.xxx series), it's not accessible externally
- Cluster IPs typically use RFC 1918 private ranges (10.x.x.x series)

#### Node Port Service Access
- Node Port services must be accessed via the VM's external IP address
- The port used is the node port assigned by Kubernetes (default range 30000-32767)
- Example: If node port is 30000, access via `VM_EXTERNAL_IP:30000`

```bash
# Correct way to access node port service
curl http://VM_EXTERNAL_IP:30000

# This will NOT work - cluster IP from external browser
curl http://CLUSTER_IP:3000
```

> [!IMPORTANT]
> Always use the VM's external IP address when accessing node port services, not the cluster IP.

> [!NOTE]
> If creating a private cluster for production, you can assign custom private IP ranges for services during cluster creation.

### Resolved Questions
- Question: Can I access cluster IP directly from browser?
- Answer: No, cluster IP is internal only. Use node port with VM external IP.

## Service Types and Port Explanations

### Overview
Kubernetes services use three types of ports: target port (container port), service port, and node port for different service types.

### Key Concepts/Deep Dive

#### Port Types in Services

| Port Type | Purpose | Accessible By |
|-----------|---------|---------------|
| Target Port | Container port inside pod | Other services in cluster |
| Port | Service port | Cluster IP service type |
| Node Port | VM port (30000-32767 range) | External access via VM IP |

- **Target Port**: Always points to the container port (e.g., 8080)
- **Port**: The port used for service-to-service communication within cluster (e.g., 3000)
- **Node Port**: Random high-numbered port assigned to VMs for external access

#### Service Port Relationships
- Load Balancer services use the "Port" value
- Cluster IP services use the "Port" value
- Node Port services use "Node Port" value for external access

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  type: NodePort
  ports:
  - port: 3000          # Service port
    targetPort: 8080   # Container port
    nodePort: 31234    # VM port for external access
```

> [!NOTE]
> The "Port" field can be any value you choose (even privileged ports like 80, 443), but node ports are always in the 30000-32767 range.

## Ingress Configuration and Networking

### Overview
Ingress acts as an entry point for external traffic to cluster services, with specific networking configurations including firewall rules.

### Key Concepts/Deep Dive

#### Ingress Deployment
- Only Cluster IP service type is required for Ingress
- Node Port services are optional and used mainly for demonstration
- Ingress creates network tags and firewall rules automatically

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-ingress
spec:
  rules:
  - host: myapp.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: my-service
            port:
              number: 3000
```

#### Firewall Rules Created by Ingress
- Ingress creates one firewall rule named "k8s-fw-l7" (Layer 7)
- Rule applies network tags to all cluster nodes
- Tags enable traffic routing through ingress controller

> [!IMPORTANT]
> Ingress firewall rules apply network tags to all VMs in the node pool, enabling proper traffic distribution.

### Resolved Questions
- Question: Do I need to keep node port and cluster IP objects with ingress?
- Answer: No, only cluster IP service is required for ingress functionality.

## Cluster Scaling and Firewall Rules

### Overview
When cluster autoscaling adds new nodes, networking configurations including firewall rules are automatically applied via managed instance groups.

### Key Concepts/Deep Dive

#### Autoscaling and Networking Tags
- New nodes created during scaling get same network tags automatically
- Managed Instance Groups (MIG) ensure consistent configuration
- Firewall rules remain in effect for scaled nodes

```bash
# Resize node pool to 3 nodes
gcloud container clusters resize CLUSTER_NAME --node-pool POOL_NAME --num-nodes 3
```

#### Instance Group Behavior
- Instance templates include network tag configurations
- New VMs inherit tags from template
- No manual firewall rule updates needed for scaled nodes

> [!NOTE]
> The managed instance group template ensures all nodes (current and future) have consistent networking setup.

### Resolved Questions
- Question: Are firewall rules applied to only one node or all nodes?
- Answer: Network tags are applied to all VMs in the node pool via managed instance groups.

## Summary

### Key Takeaways
```diff
+ Always use VM external IP with node port for external service access
+ Cluster IP services are strictly internal to the cluster
+ Target Port = container port, Port = service port, Node Port = VM port for external access
+ Ingress requires only Cluster IP service type
+ Firewall rules created by ingress apply network tags to all cluster nodes
+ Cluster scaling automatically includes networking configuration via MIG
```

### Expert Insight

#### Real-world Application
In production environments, use Cluster IP services with Ingress for secure external access. Load Balancers provide additional features like SSL termination and global distribution. For private clusters, define custom IP ranges during cluster creation to maintain network isolation.

#### Expert Path
Master service networking by understanding Kubenet vs VPC-native networking modes. Study ingress controllers (NGINX, Traefik) and service mesh options like Istio. Practice with Network Policies for traffic segmentation within clusters.

#### Common Pitfalls
- Attempting to access cluster IP from external networks
- Misunderstanding port relationships leading to connectivity issues
- Not planning for autoscaling network tag requirements
- Over-complicating deployments with unnecessary node port services

#### Lesser Known Things
- Cluster IP ranges can appear external-looking (34.xxx) but remain internal only
- Ingress firewall rules use network tags rather than direct VM references
- Managed instance group templates propagate all configurations including custom metadata and startup scripts
- Secondary IP ranges for pods/services provide full network control during cluster creation

---

**Corrections Made to Transcript:**
- "ript" at start → likely "This conference" or similar recording header
- "IP call" → "API call" (context suggests API calls, but transcript says "IP call")
- "notep" → "node port"
- "GK" → "GKE" (Google Kubernetes Engine)
- "faral rule" → "firewall rule"  
- "ingra" → "ingress"
- "Eng" → "ingress"
- "note code" → "node port"
- "cubectl" not present; "htp" not present (these are mentioned in instructions but not in this transcript)
- "VM Port" clarified as "node port"
- Various garbled timestamp interruptions removed for clarity
- "fence" → "conference"
- "reced" → "recorded"
- "EML file" → "YAML file" (context suggests YAML manifest)
- "inra" → "ingress" 
- "mang group" → "managed instance group"
- General cleanup of disconnected/stuttered phrases

The transcript contained significant transcription errors and audio artifacts, which were corrected for clarity while preserving the original meaning and technical accuracy. Compose key: CL-KK-Terminal
