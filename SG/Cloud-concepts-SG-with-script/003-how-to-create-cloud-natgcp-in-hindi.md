# Session 3: How to Create Cloud NAT GCP

## Table of Contents
- [What is Cloud NAT?](#what-is-cloud-nat)
- [Creating a VM without External IP](#creating-a-vm-without-external-ip)
- [Setting Up Cloud NAT](#setting-up-cloud-nat)
  - [Router Creation](#router-creation)
  - [NAT Configuration Options](#nat-configuration-options)
  - [Advanced Options](#advanced-options)
  - [Log Configuration](#log-configuration)
- [Testing and Verification](#testing-and-verification)
- [Assigning Cloud NAT to Subnet](#assigning-cloud-nat-to-subnet)

## What is Cloud NAT?

### Overview
Cloud NAT (Network Address Translation) is a service provided by Google Cloud Platform (GCP) that enables Virtual Machines (VMs) to access the internet without requiring individual public IP addresses. Unlike traditional NAT, which allows two-way communication, Cloud NAT implements one-way NAT only, meaning VMs can initiate outbound connections to the internet, but inbound connections from the internet cannot directly reach the VMs. This enhances security by not exposing VMs publicly while still allowing necessary outbound traffic.

### Key Concepts/Deep Dive
- **Purpose**: Cloud NAT solves the problem where VMs on a private network (no external IP) need to reach internet resources without assigning public IPs, which could be costly and pose security risks.
- **Security Benefits**: 
  - VMs remain private; no direct external access.
  - Outbound traffic is routed through a single public IP managed by GCP.
- **Limitations**:
  - Cannot receive unsolicited inbound traffic from the internet.
  - Suitable for scenarios like software updates, API calls, or accessing external services, but not for hosting public-facing applications.
- **How It Works**: Traffic from the VM flows to the Cloud NAT service, which translates the private IP to its public IP and forwards the request. Responses return through the same path.

```diff
+ Advantages: Cost-effective, secure outbound access
- Limitations: No inbound connections
! Security Note: Always pair with VPC firewalls for additional ingress control
```

## Creating a VM without External IP

### Overview
Before setting up Cloud NAT, create a VM instance without an external (public) IP address. This ensures the VM can only communicate internally or through NAT.

### Key Concepts/Deep Dive
- **VM Configuration**: Disable external IP assignment during VM creation.
- **Network Isolation**: The VM will be accessible only within the VPC network.

### Lab Demo
1. Navigate to the GCP Console.
2. Go to Compute Engine > VM instances.
3. Click "Create instance".
4. In the Networking section, under Network interfaces:
   - Ensure no external IP is assigned (leave it as "None").
5. Create the VM without additional external IP configurations.

```bash
# Example gcloud command to create a VM without external IP
gcloud compute instances create my-nat-vm \
  --network=my-vpc \
  --subnet=my-subnet \
  --zone=us-central1-a \
  --no-address  # Disables external IP assignment
```

> [!IMPORTANT]
> Without Cloud NAT configured, the VM cannot access the internet externally.

## Setting Up Cloud NAT

### Overview
Cloud NAT is created as part of a Cloud Router in GCP. The router manages routing and NAT functionality within a VPC network.

### Router Creation
1. Go to GCP Console > Network Services > Cloud Routers.
2. Click "Create router".
3. Provide:
   - Router ID.
   - Network (select your VPC).
   - Region (same as your subnet/VMs).
4. Click "Create".

### NAT Configuration Options
After creating the router, configure NAT settings:
- **IP Address Management**:
  - **Manual**: Specify custom external IP addresses for NAT.
  - **Automatic**: GCP assigns IPs dynamically. This scales better for multiple VMs but may lead to IP exhaustion if not monitored.
    - ⚠ Monitor for timeouts if many VMs attempt internet access simultaneously.

#### Translation Options
- Define which subnets or VMs use this NAT gateway by selecting ranges or specific subnetworks.

#### Advanced Options
- **Minimum/Maximum Ports per VM**:
  - Minimum: 64 ports.
  - Maximum: Configure higher ports for systems with many connections.
  - Adjust based on expected traffic volume to prevent port exhaustion.

```yaml
# Example NAT configuration in Terraform (for reference)
resource "google_compute_router_nat" "nat" {
  name   = "cloud-nat"
  router = google_compute_router.router.name
  region = "us-central1"

  nat_ip_allocate_option = "AUTO_ONLY"  # Or "MANUAL_ONLY"

  subnetwork {
    name = "my-subnet"
  }

  min_ports_per_vm  = 64
  max_ports_per_vm  = 64000
}
```

### Log Configuration
- Enable logging to track NAT operations.
- Options include:
  - Translation info.
  - Dropped packets.

```diff
+ Best Practice: Enable NAT logging for monitoring and debugging
! Alert: High port usage may indicate scaling issues
```

## Testing and Verification

### Overview
After configuration, verify that VMs can access the internet outbound but cannot be reached inbound.

### Lab Demo
1. Connect to your VM via SSH (internal access).
2. Test outbound connectivity:
   ```bash
   curl ifconfig.me  # Should return the NAT's public IP
   ```
3. Attempt inbound connection from external source (should fail).
4. Check logs in Cloud Router > NAT section if enabled.

> [!NOTE]
> If connectivity fails, verify subnet association and firewall rules.

## Assigning Cloud NAT to Subnet

### Overview
To restrict access, associate Cloud NAT with specific subnets, allowing only designated VMs or subnetworks to use it.

### Key Concepts/Deep Dive
- **Network Tags**: Use tags to control which VMs can route through NAT.
- **Subnet Selection**: Choose primary or secondary subnetworks.

### Lab Demo
1. In Cloud Router NAT settings, select subnetworks.
2. Choose between:
   - Primary ranges only.
   - Primary and secondary ranges.
   - Custom ranges.

```bash
# Apply network tags for granularity
gcloud compute instances add-tags my-vm --tags=nat-allowed --zone=us-central1-a
```

> [!IMPORTANT]
> Properly tag resources to avoid unauthorized internet access.

## Summary

### Key Takeaways
```diff
+ Cloud NAT enables secure, outbound-only internet access for private VMs in GCP
+ Create a router first, then configure NAT with IP allocation options
+ Monitor port usage and enable logging for reliable operations
- Does not support inbound connections; use load balancers for that need
! Security: Combine with VPC firewalls to control traffic effectively
```

### Expert Insight
- **Real-world Application**: Ideal for backend services in microservices architectures where outbound API calls are needed, but public exposure isn't required. For example, fetching data from external APIs or updating software repositories.
- **Expert Path**: Master VPC networking fundamentals, including firewall rules, routes, and peering. Experiment with different NAT configurations in test environments to understand scaling limits. Use tools like VPC Flow Logs for advanced monitoring.
- **Common Pitfalls**: 
  - Exhausting NAT IPs during high-traffic periods—mitigate by switching to manual allocation and adding more IPs as needed.
  - Misconfiguring subnet associations leading to no internet access—double-check region and network settings.
  - Assuming NAT provides inbound security without firewalls—always layer additional protections.
  - Ignoring port configurations for connection-heavy applications, causing timeouts—set minimum/maximum ports accurately based on load.
- Lesser known things: Cloud NAT can share IPs across multiple VMs efficiently using port translation, saving on static IP costs. It also integrates seamlessly with Identity-Aware Proxy (IAP) for secure VM access without public IPs.
- Common issues with resolution:
  - **Issue: No outbound connectivity** - Resolution: Ensure NAT is attached to the correct subnet and router is in the right region. Restart the VM if necessary.
  - **Issue: Inbound connections blocked** - Resolution: This is expected; use Google Cloud Load Balancer for inbound traffic.
  - **Issue: IP timeout errors** - Resolution: Add more external IPs manually if on auto mode, or increase port allocations.

**Corrections Made**:  
- "बम" → "VM" (Virtual Machine)  
- "काउंट" → "account"  
- "ग्रेस" → "necessary" (context implied as "only necessary")  
- "जस्ट चैनल आईपीएस" → "just channel IPs" → Rewrote as "disable automatic IP assignment" based on context  
- Various Hindi misspellings and transliterations corrected for clarity (e.g., "गेम क्लाउड" → "GCP Cloud", "बीजेपी" → unclear, omitted as "BGP", but context suggests routing)  
- Removed non-sentential fragments for coherence. If full Hindi transcript was intended, corrections maintain technical accuracy.
