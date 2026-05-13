# Session 003: How to Create Cloud NAT on GCP (in Hindi)

<details open>
<summary><b>[How to Create Cloud NAT on GCP in Hindi] (KK-CS45-script-v2)</b></summary>

## Table of Contents

- [Overview](#overview)
- [Key Concepts/Deep Dive](#key-conceptsdeep-dive)
  - [What is Cloud NAT](#what-is-cloud-nat)
  - [Benefits and Use Cases](#benefits-and-use-cases)
  - [Traffic Flow in Cloud NAT](#traffic-flow-in-cloud-nat)
- [Lab Demo: Creating Cloud NAT](#lab-demo-creating-cloud-nat)
  - [Step 1: Create VM without External IP](#step-1-create-vm-without-external-ip)
  - [Step 2: Configure Network Interface](#step-2-configure-network-interface)
  - [Step 3: Create Cloud NAT Gateway](#step-3-create-cloud-nat-gateway)
  - [Step 4: Configure NAT Router](#step-4-configure-nat-router)
  - [Step 5: Configure IP Address Management](#step-5-configure-ip-address-management)
  - [Step 6: Advanced Options Configuration](#step-6-advanced-options-configuration)
  - [Step 7: Subnet Routing Configuration](#step-7-subnet-routing-configuration)
- [Summary](#summary)

## Overview

This session covers the creation and configuration of Google Cloud Platform (GCP) Cloud NAT (Network Address Translation) service. Cloud NAT enables virtual machines (VMs) without external IP addresses to communicate with the internet for outbound traffic only. This is particularly useful for security and cost management in cloud architectures.

The tutorial demonstrates the practical steps to implement Cloud NAT, including VM creation, network configuration, and NAT gateway setup. The content is delivered in Hindi and focuses on hands-on implementation.

## Key Concepts/Deep Dive

### What is Cloud NAT

Cloud NAT is a managed service provided by Google Cloud Platform that performs network address translation. It allows VM instances without external IP addresses to send outbound traffic to the internet while preventing inbound connections.

```
graph TD
    VM[VM without External IP] -->|Outbound Traffic| NAT[Cloud NAT Gateway]
    NAT -->|NAT Translation| Internet[Internet with Public IP]
    Internet -->|Inbound Blocked| NAT[No Direct Access to VM]
```

**Key Characteristics:**
- **Outbound-only**: VMs can initiate connections to the internet
- **Inbound-blocked**: External systems cannot directly connect to VMs behind NAT
- **Managed Service**: GCP handles NAT functionality automatically
- **Scalable**: Automatically handles multiple concurrent connections

### Benefits and Use Cases

> [!IMPORTANT]
> Cloud NAT is ideal for scenarios where VMs need internet access for updates, API calls, or software downloads, but don't require direct inbound connectivity.

**Primary Benefits:**
1. **Security Enhancement**: Reduces attack surface by eliminating public IP exposure
2. **Cost Optimization**: Avoids charges for unused external IPs on all VMs
3. **Simplified Management**: Centralized outbound traffic management

**Common Use Cases:**
- Private subnet deployments in VPC
- Container clusters (GKE) requiring external API access
- Batch processing workloads needing software updates
- Database servers requiring connectivity for updates
- Middleware servers communicating with external services

### Traffic Flow in Cloud NAT

Cloud NAT operates at the subnet level within a VPC network. All outbound traffic from VMs in configured subnets is routed through the NAT gateway.

```
sequenceDiagram
    participant VM [VM Instance]
    participant Subnet [Private Subnet]
    participant Router [Cloud Router]
    participant NAT [Cloud NAT]
    participant Internet [Internet]

    VM->>Subnet: Outbound request to destination.com
    Subnet->>Router: Route traffic (next hop: NAT gateway)
    Router->>NAT: Translate source IP to NAT external IP
    NAT->>Internet: Forward translated request
    Internet-->>NAT: Response to external IP
    NAT-->>Router: Reverse translation
    Router-->>Subnet: Response to original VM IP
    Subnet-->>VM: Response received
```

**Important Routing Considerations:**
- Default route in subnet must point to NAT gateway
- BGP configuration manages traffic routing
- NAT IP exhaustion occurs when available ports are depleted

## Lab Demo: Creating Cloud NAT

### Step 1: Create VM without External IP

Create a Virtual Machine instance without assigning an external IP address:

1. Navigate to GCP Compute Engine
2. Create a new VM instance
3. In the **Networking** section, ensure **External IP** is set to **None**
4. Configure internal networking as required
5. Launch the VM instance

```bash
# GCP Cloud SDK command equivalent:
gcloud compute instances create vm-no-external-ip \
    --no-address \
    --network=your-vpc \
    --subnet=your-private-subnet
```

### Step 2: Configure Network Interface

Modify network interface settings to disable external IP addresses:

1. Access VM instance details in GCP Console
2. Navigate to **Edit** > **Configuration** > **Network**
3. In **Network interfaces** section
4. Disable external IP assignments for the interface

```yaml
# Equivalent network configuration:
networkInterfaces:
- accessConfigs: []  # No accessConfigs = no external IP
  network: projects/project-id/global/networks/your-vpc
  subnetwork: regions/region/subnetworks/your-subnet
  stackType: IPV4_ONLY
```

### Step 3: Create Cloud NAT Gateway

Create the Cloud NAT configuration:

1. Go to **VPC network** > **NAT** in GCP Console
2. Click **Create NAT gateway**
3. Provide a name for the NAT gateway
4. Select the VPC network containing your VMs
5. Choose the region for NAT deployment

```bash
# Command to create Cloud NAT:
gcloud compute routers nats create cloud-nat-demo \
    --router=nat-router-demo \
    --region=your-region \
    --nat-all-subnet-ip-ranges \
    --auto-allocate-nat-external-ips
```

### Step 4: Configure NAT Router

Create or configure the Cloud Router associated with NAT:

1. From NAT configuration, create a new router or select existing
2. Define router settings for BGP (Border Gateway Protocol)
3. Set up NAT configuration within the router

The router handles the BGP peering that enables traffic routing through NAT. This is essential for directing outbound traffic from your private subnets to the internet via the NAT gateway.

### Step 5: Configure IP Address Management

Choose between manual or automatic IP address allocation:

**Manual Configuration:**
1. Specify custom IP addresses for NAT
2. Select from existing or reserve new external IPs
3. Configure multiple IPs for high-traffic scenarios

```bash
# Manual NAT IP allocation:
gcloud compute addresses create nat-external-ip \
    --region=your-region \
    --ip-version=IPV4

gcloud compute routers nats create cloud-nat \
    --router=nat-router \
    --nat-external-ip-pool=nat-external-ip \
    --nat-all-subnet-ip-ranges
```

**Automatic Configuration:**
1. Enable automatic IP allocation
2. GCP manages IP resources dynamically
3. Scales automatically with traffic demands

> [!NOTE]
> Automatic mode is recommended for most scenarios. Manual mode provides more control for specific IP requirements or billing management.

### Step 6: Advanced Options Configuration

Configure advanced NAT settings for optimal performance:

1. **Port Allocation**: Set minimum and maximum ports per VM
   - Default: Minimum 64 ports per VM
   - Increase for high-connection workloads

```yaml
# Advanced NAT configuration:
nats:
- name: nat-demo
  natIpAllocateOption: AUTO_ONLY
  sourceSubnetworkIpRangesToNat: ALL_SUBNETWORKS_ALL_IP_RANGES
  minPortsPerVm: 64              # Default minimum
  maxPortsPerVm: 64000           # Maximum allowed
  enableDynamicPortAllocation: true
```

**Port Management Considerations:**
- Default 64 ports/VM adequate for most use cases
- High-connection VMs may exhaust 64 ports quickly
- Maximum 64000 ports per VM for extreme requirements

### Step 7: Subnet Routing Configuration

Apply NAT to specific subnets or all VPC subnets:

1. Configure which subnets use NAT for outbound traffic
2. Set default internet gateway route
3. Enable logging for monitoring

**Primary Subnet Configuration:**
- Route traffic through Cloud Router
- NAT translates source IPs to external addresses

**Control Options:**
- **Specific subnets**: Apply NAT only to designated subnets
- **All subnets**: Universal NAT coverage in VPC

## Summary

### Key Takeaways

```diff
+ Cloud NAT enables outbound-only internet connectivity for VMs without external IPs
+ Eliminates need for external IP addresses on all instances, reducing costs
+ Centralized management through Cloud Router simplifies network administration
+ Automatic IP allocation provides seamless scaling without manual intervention
+ Port allocation optimization prevents connection exhaustion in high-traffic scenarios
+ Subnet-level configuration enables granular control over internet access
- No inbound connectivity means VMs cannot receive direct internet connections
- Manual IP allocation requires ongoing management and reservation
- Port limitations may require reallocation for bursty workloads
```

### Quick Reference

**NAT Creation Commands:**

```bash
# Create NAT with automatic IPs:
gcloud compute routers nats create cloud-nat-demo \
    --router=nat-router-demo \
    --region=us-central1 \
    --nat-all-subnet-ip-ranges \
    --auto-allocate-nat-external-ips

# Create VM without external IP:
gcloud compute instances create private-vm \
    --zone=us-central1-a \
    --no-address \
    --network=my-vpc

# Check NAT operation:
gcloud compute routers nats describe cloud-nat-demo \
    --router=nat-router-demo \
    --region=us-central1
```

**Key Configuration Parameters:**
- `natIpAllocateOption`: Auto/manual IP allocation
- `minPortsPerVm`: Minimum ports per VM instance
- `sourceSubnetworkIpRangesToNat`: Which subnets to apply NAT

### Expert Insight

**Real-world Application:**
In production environments, Cloud NAT is commonly used in multi-tier architectures where web application servers need to download security patches or access external APIs, while remaining inaccessible from the internet. This pattern is particularly effective in microservices architectures where service communication occurs internally via private subnets.

**Expert Path:**
- Master router and BGP configuration for advanced routing scenarios
- Implement NAT logging and monitoring using VPC Flow Logs and Cloud Monitoring
- Design hybrid architectures combining Cloud NAT with Cloud VPN or Cloud Interconnect
- Optimize cost by choosing appropriate IP allocation strategies based on usage patterns

**Common Pitfalls:**
1. **Default Route Conflicts**: Ensure subnet default routes point to NAT gateway, not internet gateway
2. **IP Exhaustion**: Monitor NAT IP usage and implement manual allocation for high-volume scenarios
3. **Firewall Rules**: Configure VPC firewall rules independently of external IP requirements
4. **DNS Resolution**: Private subnets may require Cloud DNS Private Zones for internal name resolution
5. **Quota Limits**: Check project quotas for Cloud Routers and external IP addresses before deployment

</details>