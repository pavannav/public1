<details open>
<summary><b>Alias IP Ranges in GCP (KK-CS45-script-v3)</b></summary>

# Session 79: Alias IP Ranges in Google Cloud

## Table of Contents
- [Overview](#overview)
- [Key Concepts/Deep Dive](#key-conceptsdeep-dive)
- [Lab Demo](#lab-demo)
- [Summary](#summary)

## Overview
This session explores Google Cloud's alias IP ranges feature, which allows assigning multiple internal IP addresses to a single virtual machine (VM) network interface within the same Virtual Private Cloud (VPC). Alias IP ranges are particularly useful for scenarios like running containers or multiple services on a single VM, each with its own IP address, without requiring additional network interfaces or separate subnets. The session demonstrates creating alias IP ranges, their benefits and limitations, and practical implementation with Docker containers.

## Key Concepts/Deep Dive
### What are Alias IP Ranges?
Alias IP ranges enable assigning multiple internal IP addresses from the same subnet to a VM's network interface (NIC 0). This allows hosting multiple services or applications on a single VM, each accessible via different IP addresses within the same VPC.

**Key Characteristics:**
- **Internal networking only**: Alias IP ranges work exclusively with internal (RFC 1918) IP addresses
- **Same subnet**: All alias IPs must belong to the same subnet as the primary VM IP
- **Single NIC**: Multiple IPs on one network interface, not requiring separate NICs
- **GKE integration**: Can be used to assign IP addresses to GKE pods

### Primary vs Secondary IP Ranges
**Primary Range:**
The main IP address range of a subnet where the VM's primary IP is allocated.

**Secondary Range:**
Additional IP ranges added to a subnet for specific purposes like alias IP allocation.

### Allocation Methods
1. **From Primary Range**: Allocate specific IPs from the primary subnet range
2. **From Secondary Range**: Allocate entire ranges or specific IPs from a secondary range
   - **Full range**: Use the entire secondary range
   - **Subnetting**: Divide secondary range into smaller /24 or /32 blocks

### Benefits
- **Automatic routing**: Google Cloud automatically configures VPC routes for alias IPs
- **No additional NICs**: Multiple IPs without creating separate network interfaces
- **Container support**: Each container/pod can receive its own IP address
- **Hybrid connectivity**: Alias IPs can be announced to Cloud Router for on-premises reachability
- **Conflict avoidance**: Google Cloud ensures no IP conflicts between VMs and containers

**Network Interface Routing:**
- NIC 0: Automatic route installation by Google Cloud
- NIC 1-N: Manual route configuration required

### Use Cases
- Running multiple websites on different IPs
- Container orchestration (Docker, GKE pods)
- Load balancing preparation
- Network segmentation within a single VM

## Lab Demo
### Step 1: Create Secondary IP Range in Subnet
1. Navigate to **VPC Network** > **Subnets**
2. Select an existing subnet or create a new one
3. Click **Edit subnet**
4. Under **Secondary IP ranges for this subnet**:
   - Click **Add secondary IP range**
   - Enter name: `secondary-range`
   - Enter IP range: `192.168.33.0/24`
   - Click **Save**

### Step 2: Create VM with Alias IP Ranges
1. Go to **Compute Engine** > **VM instances**
2. Click **Create instance**
3. Configure basic settings:
   - Name: `alias-vm`
   - Region/Zone: Select zone matching the subnet (e.g., asia-south1)
4. Under **Networking**:
   - Expand **Network interfaces**
   - Click **+ Add alias IP range**
   - First alias: Select **Primary** range, allocate `/32` specific IP (e.g., `10.160.0.32/32`)
   - Second alias: Select **Secondary** range, allocate full range (e.g., `192.168.33.0/24`)
   - Click **Done**
5. Click **Create**

### Step 3: Verify Alias IP Functionality
1. SSH into the VM
2. Install Docker:
   ```bash
   sudo apt update && sudo apt install -y docker.io
   ```

3. Run nginx container on first alias IP:
   ```bash
   docker run -d --name web1 -p 192.168.33.1:80:80 nginx
   ```

4. Run another nginx container on a different IP in the range:
   ```bash
   docker run -d --name web2 -p 192.168.33.254:80:80 nginx
   ```

### Step 4: Test Connectivity
From another VM in the same VPC:
```bash
# Test single IP alias
curl http://10.160.0.32:80

# Test range aliases
curl http://192.168.33.1:80
curl http://192.168.33.254:80
```

**Expected Results:**
- Single IP alias responds when nginx is running on port 80
- Range aliases respond for IPs hosting containers
- ICMP ping should work for all alias IPs in the range

## Summary
### Key Takeaways
```diff
+ Alias IP ranges enable multiple internal IPs on single NIC without additional interfaces
- Manual routing required for NICs beyond NIC 0 (nic0, nic1, nic2, etc.)
+ Google recommends using secondary ranges for alias IPs to separate infrastructure
- Alias IPs work only with internal networking and same VPC/subnet
+ Automatic conflict prevention and routing for primary NIC
- Hybrid connectivity requires Cloud Router announcement for on-premises access
+ Perfect for containerization scenarios and multi-service VMs
```

### Quick Reference
**Create Secondary Range (gcloud):**
```bash
gcloud compute networks subnets update SUBNET_NAME \
  --region=REGION \
  --add-secondary-ranges=secondary-range=192.168.33.0/24
```

**Create VM with Alias IPs (gcloud):**
```bash
gcloud compute instances create alias-vm \
  --network-interface=network=NETWORK,subnet=SUBNET,aliases=RANGE1:RANGE2 \
  --zone=ZONE
```

**Docker Container with Specific IP:**
```bash
docker run -d --name container-name -p ALIAS_IP:80:80 nginx
```

### Expert Insight
**Real-world Application:**
Alias IP ranges are commonly used in microservices architectures where each containerized service needs its own IP for DNS resolution, load balancing, or network policies. They're essential for GKE pod networking and blue-green deployments on shared VMs.

**Expert Path:**
- Master subnetting calculations for efficient secondary range allocation
- Learn advanced routing configurations for multi-NIC scenarios
- Integrate with Google Cloud Router for hybrid network announcements
- Combine with VPC peering for cross-network alias IP reachability

**Common Pitfalls:**
- Forgetting that alias IPs only work with *nic0* automatically; additional NICs require custom routes via VPC Network Routes section
- Attempting to use alias IPs as primary/external facing IPs - they're internal only
- Not allocating sufficient secondary range capacity for container scaling
- Mixing primary and secondary ranges confusedly without clear IP management strategy
- Configuration errors in Docker networking (--network configuration) leading to IP unavailability
</details>
