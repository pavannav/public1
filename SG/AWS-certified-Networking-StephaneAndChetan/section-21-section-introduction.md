# Section 21: Amazon EKS Networking

<details open>
<summary><b>Section 21: Amazon EKS Networking (KK-CS45-script-v2)</b></summary>

## Table of Contents

- [Section Introduction](#21.1 Section Introduction)
- [Kubernetes Architecture](#21.2 Kubernetes Architecture)
- [Amazon EKS Architecture](#21.3 Amazon EKS Architecture)
- [EKS Cluster Networking](#21.4 EKS Cluster Networking)
- [EKS Pod Networking - Part 1](#21.5 EKS Pod Networking - Part 1)
- [EKS Pod Networking - Part 2](#21.6 EKS Pod Networking - Part 2)
- [Security Group in EKS - Node and Pod level](#21.7 Security Group in EKS - Node and Pod level)
- [Exposing services using ClusterIP, NodePort, LoadBalancer and Ingress](#21.8 Exposing services using ClusterIP, NodePort, LoadBalancer and Ingress)
- [EKS Custom Networking - Extending IPv4 address space](#21.9 EKS Custom Networking - Extending IPv4 address space)
- [EKS Networking Summary](#21.10 EKS Networking Summary)
- [Summary](#summary)

## 21.1 Section Introduction

### Overview

This lecture introduces the Amazon EKS Networking section, covering EKS cluster and pod networking architecture, security groups, service exposure methods, and custom networking features. The section focuses on AWS-specific implementations while assuming familiarity with containers, microservices, and Kubernetes fundamentals.

### Key Concepts/Deep Dive

**Section Scope and Prerequisites:**
- Comprehensive coverage of Amazon EKS networking
- Assumes knowledge of containers, microservices, and Kubernetes
- Supplementary video provided for those without Kubernetes background

**Main Topics Covered:**
- Kubernetes open source architecture
- Amazon EKS architecture and components
- EKS cluster networking fundamentals
- Pod networking implementation in EKS
- Security group usage at node and pod levels
- Service exposure mechanisms (ClusterIP, NodePort, LoadBalancer, Ingress)
- Advanced EKS custom networking features
- EKS networking summary for exam preparation

**Exam Relevance:**
- Expect several questions related to EKS networking
- Critical understanding of pod networking and service exposure

## 21.2 Kubernetes Architecture

### Overview

This lecture covers the fundamental components of Kubernetes architecture, focusing on the control plane and data plane components essential for understanding EKS networking implementations.

### Key Concepts/Deep Dive

**Kubernetes Components Overview:**

1. **Control Plane Components:**
   - **kube-apiserver**: Central management interface for Kubernetes cluster
   - **etcd**: Distributed key-value store for cluster data
   - **kube-controller-manager**: Runs controller processes
   - **kube-scheduler**: Assigns pods to nodes

2. **Data Plane Components:**
   - **kubelet**: Agent running on each node that communicates with control plane
   - **kube-proxy**: Network proxy maintaining network rules on nodes
   - **Container Runtime**: Software for running containers (Docker, containerd, CRI-O)

**Kubernetes Networking Fundamentals:**
- Pods as basic deployment units containing containers
- Services providing load balancing and service discovery
- Ingress controllers managing external access to services
- Network plugins (CNI) implementing pod networking

**Architecture Responsibilities:**
- Control plane: Manages cluster state and decisions
- Data plane: Executes workloads and networking

## 21.3 Amazon EKS Architecture

### Overview

This lecture explains how Amazon EKS manages the Kubernetes control plane responsibilities while customers handle data plane infrastructure, including node management options.

### Key Concepts/Deep Dive

**EKS Architecture Overview:**

```
Control Plane (AWS Managed)
├── API Server
├── etcd
├── Controller Manager
└── Scheduler

Data Plane (Customer Managed)
├── EC2 Instances
├── AWS Fargate
└── Networking Components
```

**Control Plane Management:**
- AWS fully manages the control plane components
- High availability across multiple availability zones
- No customer responsibility for control plane operations

**Data Plane Options:**

1. **Self-Managed Nodes:**
   - Customer provisions and manages EC2 instances
   - Manual registration of nodes to EKS cluster
   - Full control over instance types and AMIs

2. **Managed Node Groups:**
   - AWS handles EC2 provisioning and lifecycle
   - Automatic node registration and draining
   - Simplified operations compared to self-managed

3. **AWS Fargate:**
   - Serverless compute for EKS
   - No underlying infrastructure management
   - Pay-per-pod pricing model

**Node Types Comparison:**

| Node Type | Management | Infrastructure | Scaling |
|-----------|------------|----------------|---------|
| Self-Managed | Customer | Customer | Manual |
| Managed | AWS | Customer | Automatic |
| Fargate | AWS | AWS | Automatic |

**EKS Networking Context:**
- Data plane nodes deployed in customer VPC
- Control plane enables network communication
- Foundation for understanding EKS networking

## 21.4 EKS Cluster Networking

### Overview

This lecture explains how EKS manages networking between the AWS-managed control plane and customer-managed data plane, including endpoint access controls and security group configurations.

### Key Concepts/Deep Dive

**EKS Architecture Networking:**

```
AWS Managed VPC (Control Plane)
├── Kubernetes API Server
└── Control Plane Components

Customer VPC (Data Plane)
├── Worker Nodes (EC2/Fargate)
├── EKS-Owned ENIs (2-4 per AZ)
└── Subnets for Control Plane Communication
```

**Control Plane Communication:**
- EKS provisions ENIs in customer VPC (requester-managed ENIs)
- ENIs enable secure communication between control plane and data plane
- Typically 2-4 ENIs deployed across availability zones
- Isolated subnet recommended (minimum /28 for 16 IP addresses)

**Security Group Configuration:**
- EKS creates default security groups for cluster communication
- Default rules:
  - Inbound: Self-referencing (all protocols/ports within SG)
  - Outbound: All IPv4/IPv6 addresses
- Customer can provide custom security groups during cluster creation
- Security groups attached to EKS-owned ENIs and managed node groups

**Cluster Endpoint Access Patterns:**

1. **Public Access Enabled (Default):**
   ```
   Workstation → Internet → EKS API Server
   Worker Nodes → ENIs → Control Plane (via private IP)
   ```

2. **Public + Private Access:**
   ```
   Workstation → Internet → EKS API Server
   Worker Nodes → Private Subnet → ENIs → Control Plane
   ```

3. **Private Access Only:**
   ```
   Workstation → VPN/Direct Connect → Customer VPC → ENIs → Control Plane
   ```

**Endpoint Access Controls:**
- CIDR-based IP whitelisting for public access
- Private access requires layer 4 connectivity (VPN/Direct Connect)
- No endpoint access needed for EKS service API calls

**VPC Interface Endpoints:**
- Enables private access to AWS EKS service APIs
- Created in customer VPC for creating/managing clusters
- Allows tools like eksctl to operate from private networks

**VPC Networking Best Practices:**
- Public subnets for ALBs/NLBs
- NAT gateways for outbound internet access from private subnets
- VPC endpoints for AWS service access
- Full VPC networking capabilities available

## 21.5 EKS Pod Networking - Part 1

### Overview

This lecture explains how Amazon VPC CNI plugin assigns IP addresses to pods in EKS, enabling pods to become first-class citizens in the VPC network while covering pod density considerations and IPv6 support.

### Key Concepts/Deep Dive

**Kubernetes Networking Principles (CNCF Standards):**
- Every pod gets its own IP address
- Containers in same pod share network namespace/use localhost
- Pods communicate directly without NAT within cluster
- All nodes communicate with all pods without NAT
- Pods see their actual IP addresses (no destination NAT)

**Amazon VPC CNI Plugin Implementation:**

```
VPC Subnet: 10.0.0.0/16
├── Worker Node
│   ├── Primary ENI (10.0.0.15) + Secondary IPs (10.0.0.20, 10.0.0.21, ...)
│   ├── Secondary ENI (10.0.0.30) + Secondary IPs (10.0.0.31, 10.0.0.32, ...)
│   └── Pods with VPC IP addresses
```

**IP Address Assignment:**
- CNI attaches ENIs to worker nodes
- Primary ENI retains its primary IP for node communication
- Secondary IPs from all ENIs assigned to pods
- Pods become VPC citizens with routable IP addresses

**Pod Density Calculations:**
- Formula: `(Network Interfaces × IPs per Interface) - 1 (primary) + 2 (kube-proxy + host-networking pods)`
- Example m5.large: `3 ENIs × 10 IPs = 29 pods`
- Limits depend on instance type (refer AWS documentation)

**Prefix Delegation (Nitro-based instances only):**
- Assigns CIDR blocks instead of individual IPs
- IPv4: /28 prefix (16 IPs) vs 1 IP (16x increase)
- IPv6: /80 prefix (massive address space)
- Example: m5.large can support 434 pods vs 29 with /28 prefixes

**IPv6 Support in EKS:**
- IPv6 addresses are public and globally unique
- Supported on Nitro-based instances and Fargate
- Dual-stack not supported (IPv4 OR IPv6, not both)
- Requires IPv4 VPC range for operational functionality
- Pods need /80 prefix assignment (prefix delegation mandatory)
- Windows pods/services not supported
- Auto-assign IPv6 enabled on subnets

**Pod Communication:**
- Same VPC pods communicate directly via IP addresses
- No NAT required for pod-to-pod communication
- Follows CNCF networking specifications

**CNI Alternatives:**
- AWS VPC CNI is official EKS plugin
- Third-party options like Calico available
- Calico provides advanced network policies

## 21.6 EKS Pod Networking - Part 2

### Overview

This lecture details how pods communicate with external networks, covering source NAT behavior, NAT gateway integration, and advanced networking features like multi-home pods.

### Key Concepts/Deep Dive

**External Pod Communication Flow:**

1. **Within VPC:**
   ```
   Pod A (10.0.0.20) → Pod B (10.0.1.50) → Direct VPC routing
   ```

2. **Outside VPC (Default Source NAT Enabled):**
   ```
   Pod (10.0.0.20) → Primary ENI (10.0.0.15) → Source NAT → External Network
   ```

**Source NAT Behavior:**
- When pods communicate with non-VPC CIDR destinations
- AWS VPC CNI translates pod IP to primary ENI IP
- EXTERNAL-SNAT=false (Kubernetes setting)
- Applies only to IPv4 (IPv6 doesn't need NAT)

**Network Scenarios:**

1. **Public Subnet Nodes with Source NAT:**
   ```
   Pod → ENI Source NAT → Internet Gateway → Public IP NAT → Internet
   Traffic Source: public IP of primary ENI
   ```

2. **Internet Access with NAT Gateway (Source NAT Disabled):**
   ```
   Pod → NAT Gateway → Internet Gateway → Public IP NAT → Internet
   Traffic Source: pod IP visible to NAT Gateway
   Settings: EXTERNAL-SNAT=true
   ```

**Source NAT Impact:**
- **Enabled:** Pod IPs hidden, outbound traffic works, inbound direct access impossible
- **Disabled:** Pod IPs visible externally, enables direct inbound access

**Multi-Home Pods (Multus CNI):**
- Single pod with multiple network interfaces
- Each interface from different subnets
- Enables complex networking topologies
- Supported by AWS VPC CNI

## 21.7 Security Group in EKS - Node and Pod level

### Overview

This lecture covers security group implementation in EKS, addressing the limitation of shared security groups across pods on the same ENI and presenting solutions for pod-level security group control.

### Key Concepts/Deep Dive

**Default EKS Security Groups:**
- Created during cluster creation
- Rules:
  - Inbound: Self-referencing (all traffic between attached resources)
  - Outbound: All IPv4/IPv6 addresses

**EKS-Owned ENIs Security Groups:**
- Default SG attached to EKS ENIs
- Customer can provide custom SGs during cluster creation
- Minimum required outbound rules:
  - 443: Kubernetes API server
  - 10250: kubelet APIs
  - 53: DNS queries
- Optional: 80/443 for internet access, S3/VPC endpoints

**Security Group Limitation:**
```
Worker Node ENI
├── SG Rules
│   ├── Pod A (Web Server)
│   ├── Pod B (Database)
│   └── Pod C (Application)
```
All pods share same security group rules despite different requirements.

**Solution 1: Third-Party Network Policies (Calico):**
- Install Calico CNI plugin
- Implement Kubernetes network policies
- Granular pod-level firewall rules using iptables
- More flexible than AWS native security groups

**Solution 2: Trunk and Branch ENIs (EKS Native):**
- Add-on: amazon-vpc-resource-controller-k8s
- Creates trunk ENI attached to node
- Generates branch ENIs for individual pods
- Each pod gets dedicated ENI with custom security group

**Trunk and Branch Architecture:**
```
Worker Node
├── Primary ENI
├── Trunk ENI
│   ├── Branch ENI 1 (Pod A SG)
│   ├── Branch ENI 2 (Pod B SG)
│   └── Branch ENI 3 (Pod C SG)
```

**Compatibility Information:**
- Supported on Nitro-based instances only
- Fargate support for IPv6 only
- Windows nodes not supported
- Some instance families excluded (t-series)
- Reference: GitHub limits.go file for supported instances

## 21.8 Exposing services using ClusterIP, NodePort, LoadBalancer and Ingress

### Overview

This lecture covers the four main methods for exposing Kubernetes services externally, focusing on AWS EKS implementations with LoadBalancer services and Ingress controllers.

### Key Concepts/Deep Dive

**Kubernetes Service Types:**

1. **ClusterIP (Default):**
   - Internal cluster access only
   - Load balances across pods in deployment
   - No external access

2. **NodePort:**
   - Opens port on all nodes
   - Access via `NodeIP:NodePort`
   - Not recommended for production (security/scalability issues)

3. **LoadBalancer:**
   - Creates AWS load balancer
   - External access via load balancer DNS
   - Layer 4 load balancing

4. **Ingress:**
   - Layer 7 load balancing
   - Single entry point for multiple services
   - Advanced routing (path/host-based)

**AWS Load Balancer Controller (Recommended):**
- Successor to older AWS ALB Ingress Controller
- Supports Network Load Balancer (NLB) and Application Load Balancer (ALB)

**Load Balancer Types:**

1. **Network Load Balancer (NLB):**
   - Layer 4 load balancing
   - IP mode and instance mode support
   - Ultra-low latency
   - Static IP support

2. **Application Load Balancer (ALB):**
   - Layer 7 load balancing
   - Advanced features: path-based routing, host-based routing
   - WebSocket support, sticky sessions
   - Integration with AWS services

**NLB Target Types:**
- **IP Mode:** Direct pod IP targeting (preserves client IP, better performance)
- **Instance Mode:** Node targeting with health checks

**External Traffic Policy:**
- **Cluster (Default):** Client IP not preserved, traffic routed through other nodes
- **Local:** Client IP preserved, requires local node routing (potential load imbalance)

**Controller Differences:**
- **Old Controller:** Supports Classic Load Balancer (CLB) and Network Load Balancer (NLP)
- **New Controller:** Supports NLB (IP/instance mode) and ALB with full feature set

## 21.9 EKS Custom Networking - Extending IPv4 address space

### Overview

This lecture explains EKS custom networking feature for extending IPv4 address space when primary VPC CIDR becomes exhausted, enabling efficient pod IP allocation from secondary CIDR ranges.

### Key Concepts/Deep Dive

**Custom Networking Use Case:**
- Primary VPC CIDR exhausted for pod IPs
- Need to extend available IP space
- Solution: Allocate secondary CIDR using Custom Networking

**Custom Networking Implementation:**

1. **Associate Secondary CIDR:**
   ```
   Primary VPC: 10.0.0.0/16
   Secondary CIDR: 100.64.0.0/16 (CGNAT range)
   ```

2. **Create Secondary ENI:**
   - ENI configured in custom networking subnet
   - Connected to secondary ENI from secondary CIDR

3. **Enable Custom Networking Add-on:**
   - Configure VPC CNI to use secondary CIDR
   - Pods receive IPs from 100.64.0.0/16 range

**SNAT Feature:**
- Source NAT enabled for secondary ENI traffic
- Hides private IP range from external networks
- Ensures compliance with RFC 1918 (private IP standards)

**Architecture:**
```
EKS Cluster
├── Primary ENI (Primary Subnet: 10.0.0.0/16)
├── Secondary ENI (Custom Subnet: 100.64.0.0/16)
│   ├── Pod IPs: 100.64.x.x (internal only)
│   └── SNAT: External traffic appears as primary ENI IP
```

**Benefits:**
- Extends pod IP space significantly
- Uses RFC 1918 compliant secondary ranges
- Maintains security through SNAT
- No reconfiguration of existing workloads

**When to Use:**
- VPC CIDR exhausted
- Need more pod IPs than primary CIDR provides
- Want to avoid VPC resizing complications

## 21.10 EKS Networking Summary

### Overview

This lecture provides a comprehensive summary of all EKS networking concepts covered in the section, highlighting key configurations and best practices for exam preparation.

### Key Concepts/Deep Dive

**Core Architecture:**
- EKS control plane in AWS-managed VPC
- Data plane in customer VPC
- Communication via EKS-owned ENIs in customer VPC

**Cluster Endpoint Access:**
- Default: Public access enabled
- Options: Public-only, Public+Private, Private-only
- Private access requires CIDR whitelisting
- VPC interface endpoints for EKS service APIs

**Pod Networking (VPC CNI):**
- Pods get secondary IPs from ENI
- Maximum pods per node: ENI count × IPs per ENI
- Prefix delegation increases capacity (Nitro instances)
- IPv4/IPv6 support (no dual-stack)

**External Communication:**
- Source NAT enabled by default (EXTERNAL-SNAT=false)
- Disabled for direct pod IP visibility (EXTERNAL-SNAT=true)
- NAT Gateway for private subnet internet access

**Security Groups:**
- Default: Attached to ENIs, shared across pods
- Pod-level: Trunk/Branch ENIs or third-party CNIs (Calico)
- Nitro-based instances required for trunk/branch

**Service Exposure:**
- ClusterIP: Internal cluster access
- NodePort: Node IP access (not recommended)
- LoadBalancer: AWS NLB/ALB via AWS Load Balancer Controller
- Ingress: Layer 7 routing with ALB features
- External Traffic Policy: Local vs Cluster (client IP preservation)

**Custom Networking:**
- Secondary CIDR (100.64.0.0/16) for additional IPs
- SNAT hides private range from external networks
- Extends available pod IP space

**Key Limitations and Best Practices:**
- IPv6 no dual-stack support
- Prefix delegation required for IPv6 pods
- Nitro-based instances for advanced features
- Recommended: AWS Load Balancer Controller
- Monitor outbound SG rules (443, 10250, 53 minimum)

## Summary

### Key Takeaways

```diff
+ EKS control plane managed by AWS, data plane by customer
+ VPC CNI assigns secondary ENI IPs to pods, making them VPC citizens
+ Pod communication: direct within VPC, NAT configurable for external
+ Security groups shared by default; Trunk/Branch ENIs enable per-pod SGs
+ Four service exposure methods: ClusterIP, NodePort, LoadBalancer, Ingress
+ Custom networking extends IP space with secondary CIDR and SNAT
+ Private cluster endpoint access requires proper networking setup
+ AWS Load Balancer Controller preferred over legacy controller
```

### Quick Reference

**Pod Density Formula:**
`(Network Interfaces × IPs per Interface) - 1 + 2 = Max Pods`

**Minimum SG Outbound Rules:**
- 443: Kubernetes API
- 10250: Kubelet APIs
- 53: DNS queries

**Service Types:**
- ClusterIP: Internal only
- NodePort: Node IP access
- LoadBalancer: AWS NLB/ALB
- Ingress: Layer 7 routing

**Network Plugins:**
- AWS VPC CNI: Official, basic networking
- Calico: Advanced policies
- Multus: Multi-home pods

### Expert Insight

**Real-world Application:**
In production EKS clusters, implement security groups per pod using Trunk/Branch ENIs for microservices requiring different firewall rules. Use custom networking to maximize pod density when running large-scale applications across multiple teams.

**Expert Path:**
Master VPC CNI configurations, understand prefix delegation for optimal pod density, and learn Kubernetes network policies as complementary to AWS security groups. Focus on ALB ingress configurations for complex routing requirements.

**Common Pitfalls:**
- Assuming pods can be accessed directly from internet without proper service exposure
- Misconfiguring source NAT leading to connectivity issues
- Exceeding recommended pod density (110 pods/node)
- Using NodePort in production environments
- Ignoring IPv6 prefix delegation requirements

**Lesser-Known Facts:**
- EKS-owned ENIs use requester-managed ENI pattern similar to RDS/Aurora
- Custom networking uses CGNAT range (100.64.0.0/16) specifically for this purpose
- Windows pods cannot use IPv6 addresses in EKS
- Trunk ENI feature enables pod-level network attachments, similar to EC2 multi-NIC capabilities

</details>