<details open>
<summary><b>[Session/Section Name] (KK-CS45-script-v3)</b></summary>

# Session 080: Cloud NAT - Public NAT in Google Cloud Platform (Part 1)

## Table of Contents
- [Overview](#overview)
- [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
  - [What is Cloud NAT?](#what-is-cloud-nat)
  - [Public NAT vs Private NAT](#public-nat-vs-private-nat)
  - [Supported Services](#supported-services)
  - [Regional Service Architecture](#regional-service-architecture)
  - [Traffic Flow and Security](#traffic-flow-and-security)
  - [Route Requirements](#route-requirements)
  - [Google APIs and Private Google Access](#google-apis-and-private-google-access)
  - [Shared VPC Considerations](#shared-vpc-considerations)
  - [VPC Peering Limitations](#vpc-peering-limitations)
- [IP Address Management](#ip-address-management)
  - [Automatic IP Allocation](#automatic-ip-allocation)
  - [Manual IP Allocation](#manual-ip-allocation)
  - [Network Tier Options](#network-tier-options)
- [Port Allocation Strategies](#port-allocation-strategies)
  - [Static Port Allocation](#static-port-allocation)
  - [Dynamic Port Allocation](#dynamic-port-allocation)
  - [TCP/UDP Port Ranges](#tcpudp-port-ranges)
- [Configuration Options](#configuration-options)
  - [Timeout Settings](#timeout-settings)
  - [Logging Configuration](#logging-configuration)
  - [Endpoint Independent Mapping](#endpoint-independent-mapping)
- [Lab Demonstrations](#lab-demonstrations)
  - [Demo 1: Creating a Cloud NAT Gateway](#demo-1-creating-a-cloud-nat-gateway)
  - [Demo 2: Testing Connectivity and Route Dependencies](#demo-2-testing-connectivity-and-route-dependencies)
  - [Demo 3: Selective NAT with Instance Tags](#demo-3-selective-nat-with-instance-tags)
  - [Demo 4: Port Limits and Connection Testing](#demo-4-port-limits-and-connection-testing)
  - [Demo 5: Dynamic Port Allocation](#demo-5-dynamic-port-allocation)
  - [Demo 6: Manual IP Configuration](#demo-6-manual-ip-configuration)
  - [Demo 7: Firewall Rules Integration](#demo-7-firewall-rules-integration)

## Overview

This session provides a comprehensive introduction to **Cloud NAT (Network Address Translation)** in Google Cloud Platform, specifically focusing on **Public NAT**. Cloud NAT enables Google Cloud resources without public IP addresses to securely communicate outbound to the internet and other networks. The session covers Public NAT configuration, IP and port management, practical demonstrations, and integration with other GCP services like firewalls and routes.

## Key Concepts and Deep Dive

### What is Cloud NAT?

Cloud NAT provides **network address translation services** for outbound traffic from Google Cloud resources. It allows VMs and other services without external IP addresses to initiate connections to the internet or external networks.

**Key characteristics:**
- **Outbound-only service**: Traffic can only flow from inside Google Cloud to outside networks
- **Shared IP model**: Multiple VMs share allocated external IP addresses
- **Port-based allocation**: Each VM receives a portion of available ports from the shared IP pool
- **Regional service**: Cloud NAT gateways operate at the regional level

### Public NAT vs Private NAT

Google Cloud offers two types of Cloud NAT:

| Feature | Public NAT | Private NAT |
|---------|------------|-------------|
| **Purpose** | Internet outbound access | Private network connectivity |
| **Traffic Destination** | Public internet | Private VPC networks, on-premises |
| **IP Address Usage** | Public external IPs | Private RFC 1918 IPs |
| **Use Case** | VM to internet communication | Hybrid cloud connectivity |
| **Introduction Timeline** | Original offering | Recently introduced |

This session focuses exclusively on Public NAT for internet outbound traffic.

### Supported Services

Cloud NAT integrates with various Google Cloud compute services:

- **Compute Engine VMs**: Primary use case
- **Google Kubernetes Engine (GKE)**: For cluster outbound traffic
- **Cloud Run services**: Via Serverless VPC Access
- **App Engine Standard Environment**: Via Serverless VPC Access
- **Cloud Run functions**: Via Serverless VPC Access
- **Internal Network Endpoint Groups**: Regional endpoints

### Regional Service Architecture

Cloud NAT operates as a **regional service**, requiring:

- **Separate gateway per region**: Each GCP region needs its own Cloud NAT configuration
- **Cloud Router dependency**: Requires a Cloud Router (used for BGP configuration, though not actively used for NAT)
- **Subnet-specific configuration**: Apply to specific subnets or IP ranges within a region

```
graph TD
    A[VM without external IP] --> B[Cloud NAT Gateway]
    B --> C[Shared External IP Pool]
    C --> D[Internet/External Networks]
    
    E[VM2] --> B
    F[VM3] --> B
```

### Traffic Flow and Security

**Outbound-only security model:**
- **No inbound connections**: External sources cannot initiate connections to Cloud NAT
- **Stateful NAT**: Maintains connection state for return traffic
- **Port multiplexing**: Multiple VMs share external IPs through port allocation

**Security considerations:**
- **Defense in depth**: Complements but doesn't replace firewall rules
- **Traffic inspection**: All outbound traffic passes through NAT gateway
- **Logging capabilities**: Enable for monitoring and security analysis

### Route Requirements

Cloud NAT has strict routing requirements:

**Mandatory route configuration:**
- **Next hop**: Must be `default-internet-gateway` (0.0.0.0/0)
- **Route priority**: Standard routing rules apply
- **No custom routes**: Custom routes with different next hops won't work with Cloud NAT

> [!IMPORTANT]
> If you delete the default internet gateway route, Cloud NAT will stop functioning, and all outbound traffic will be blocked.

### Google APIs and Private Google Access

**Special handling for Google Cloud APIs:**
- **Traffic interception**: Cloud NAT automatically intercepts traffic to Google APIs
- **Private Google Access**: Enables internal routing for GCP services
- **Cost optimization**: Avoids internet charges for Google service communication
- **Subnet-wide effect**: Applies to entire subnet when Cloud NAT is configured

**Automatic enabling:**
- When you create Public NAT on a subnet, private Google access is automatically enabled
- Traffic to Google APIs (BigQuery, Cloud Storage, etc.) routes internally
- No manual configuration required

### Shared VPC Considerations

**Host project configuration:**
- Create Cloud NAT gateways in the **host project**
- Share NAT configuration with **service projects**
- Centralized IP and port management

### VPC Peering Limitations

**Important restrictions:**
- **No cross-network NAT**: Cloud NAT cannot provide NAT for VMs in peered VPC networks
- **Same region requirement**: Peered networks in same region still cannot share NAT
- **Separate gateways needed**: Each VPC network requires its own Cloud NAT configuration

## IP Address Management

### Automatic IP Allocation

**Google-managed IP allocation:**
- **Dynamic scaling**: Automatically adds/removes IPs based on VM count and traffic
- **Network tier consideration**: Considers premium vs standard tier requirements
- **Quota management**: Managed within regional IP quotas
- **Predictability limitations**: Cannot predict which IPs Google will allocate

**Advantages:**
- **Zero management**: No manual IP management required
- **Auto-scaling**: Adapts to changing VM and traffic patterns
- **Cost efficiency**: Only uses IPs when needed

### Manual IP Allocation

**User-controlled IP management:**
- **Pre-reserved IPs**: Reserve external IPs before Cloud NAT creation
- **Predictable addresses**: Known IP addresses for compliance/security requirements
- **Granular control**: Add/remove specific IPs as needed
- **Different quotas**: Separate from automatic allocation quotas

**Use cases:**
- **Firewall whitelisting**: When external services require specific IP ranges
- **Compliance requirements**: Regulatory requirements for known IP addresses
- **IP draining**: Graceful transition when changing IP addresses

### Network Tier Options

**Premium Tier:**
- **Google backbone routing**: Traffic stays within Google network longer
- **Lower latency**: Fewer network hops to internet
- **Higher cost**: Premium pricing
- **Global connectivity**: Optimized for worldwide destinations

**Standard Tier:**
- **Direct internet egress**: Traffic exits Google network sooner
- **Cost optimization**: Lower pricing than premium
- **Variable latency**: Dependent on ISP routing
- **Regional focus**: Better for nearby destinations

## Port Allocation Strategies

### Static Port Allocation

**Fixed port assignment:**
- **Per-VM allocation**: Each VM receives exactly the same number of ports
- **Predictable limits**: Known connection capacity per VM
- **Default behavior**: Enabled by default with 64 ports per VM
- **Manual configuration**: Specify minimum ports (no maximum setting)

**Configuration example:**
```
Minimum ports per VM: 64
Maximum ports per VM: N/A (fixed allocation)
```

**Use cases:**
- **Uniform workloads**: All VMs have similar traffic patterns
- **Capacity planning**: Predictable resource requirements
- **Cost control**: No dynamic scaling overhead

### Dynamic Port Allocation

**Flexible port scaling:**
- **Range specification**: Define minimum and maximum ports per VM
- **Auto-scaling**: Ports allocated based on actual usage
- **Traffic adaptation**: Responds to varying connection demands
- **Mutual exclusivity**: Cannot be used with endpoint independent mapping

**Configuration example:**
```
Minimum ports per VM: 64
Maximum ports per VM: 128
```

**Benefits:**
- **Efficiency**: Only allocate ports when needed
- **Cost optimization**: Reduce over-provisioning
- **Peak handling**: Accommodate traffic spikes

### TCP/UDP Port Ranges

**Available ports:**
- **Total ports**: 65,536 (full TCP/UDP range)
- **Usable ports**: 65,500 (excludes first 1,024 well-known ports)
- **Protocol support**: Both TCP and UDP connections
- **Connection multiplexing**: Single external IP supports thousands of internal connections

## Configuration Options

### Timeout Settings

**Critical timing configurations:**
- **UDP timeout**: Default 30 seconds for idle UDP connections
- **TCP established timeout**: Default 20 minutes for established connections
- **TCP transitory timeout**: Default 30 seconds for connection establishment
- **FIN timeout**: 30 seconds after receiving RST/FIN packets

**Customization benefits:**
- **Application optimization**: Match connection patterns of your applications
- **Resource efficiency**: Free ports faster for highly active services
- **Connection management**: Handle broken connections appropriately

### Logging Configuration

**Available log types:**
- **Translation logs**: Track NAT operations (successful/failed)
- **Errors only**: Log only failed translations
- **Traffic insights**: Understand connection patterns and issues

**Log destination:**
- **Cloud Logging**: Standard GCP logging infrastructure
- **Analysis options**: Use BigQuery or other tools for log analysis
- **Security monitoring**: Detect anomalous outbound traffic patterns

### Endpoint Independent Mapping

**Advanced NAT feature:**
- **Connection consistency**: All connections from same internal endpoint use same external port
- **Mutual exclusivity**: Cannot be used with dynamic port allocation
- **Traffic optimization**: Better for certain application architectures

## Lab Demonstrations

### Demo 1: Creating a Cloud NAT Gateway

**Prerequisites:**
- GCP project with VPC network
- VMs without external IPs
- Appropriate IAM permissions

**Steps:**

1. **Navigate to Cloud NAT:**
   ```
   Google Cloud Console → VPC Network → Cloud NAT
   ```

2. **Create Cloud NAT Gateway:**
   - Gateway name: `test-nat`
   - VPC network: Select your VPC
   - Region: `asia-south1` (matching VM region)
   - Cloud Router: Create new or select existing

3. **Configure subnets:**
   - Option: Custom
   - Select specific subnets or IP ranges
   - Choose between primary/secondary ranges

4. **IP address allocation:**
   - Choose: Automatic (recommended)
   - Network tier: Premium or Standard

5. **Port allocation:**
   - Minimum ports per VM: 64 (default)
   - Dynamic allocation: Disabled (for now)

6. **Additional settings:**
   - UDP timeout: 30s
   - TCP established timeout: 20m
   - TCP transitory timeout: 30s
   - Logging: Translation and errors

**Expected output:**
```
Cloud NAT gateway created successfully
Status: Ready
```

### Demo 2: Testing Connectivity and Route Dependencies

**Testing outbound connectivity:**

```bash
# Test internet connectivity from VM
ping 8.8.8.8

# Expected: Successful ping responses
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=114 time=4.12 ms
```

**Testing route dependency:**

```bash
# Delete default route (simulate failure)
gcloud compute routes delete default-route-to-internet

# Test connectivity again
ping 8.8.8.8

# Expected: Connection timeout (no response)
```

**Restore connectivity:**

```bash
# Recreate the default route
gcloud compute routes create default-route-to-internet \
  --network=my-network \
  --destination-range=0.0.0.0/0 \
  --next-hop-gateway=default-internet-gateway
```

### Demo 3: Selective NAT with Instance Tags

**Implement selective NAT access:**

1. **Tag VMs requiring NAT:**
   ```bash
   gcloud compute instances add-tags vm-with-nat \
     --tags=nat-enabled \
     --zone=asia-south1-a
   ```

2. **Create NAT-specific route:**
   ```bash
   gcloud compute routes create nat-route \
     --network=my-network \
     --destination-range=0.0.0.0/0 \
     --next-hop-gateway=default-internet-gateway \
     --tags=nat-enabled
   ```

3. **Test selective access:**
   ```bash
   # Tagged VM: Should have internet access
   # Untagged VM: Should not have internet access
   ```

### Demo 4: Port Limits and Connection Testing

**Create test script for connection limits:**

```bash
# test-connections.sh
#!/bin/bash
MAX_CONNECTIONS=70
TARGET="example.com"

for ((i=1; i<=MAX_CONNECTIONS; i++)); do
  curl -s --connect-timeout 5 "$TARGET" &
done

wait
echo "Test completed"
```

**Execute and analyze:**
```bash
chmod +x test-connections.sh
./test-connections.sh

# Expected: ~6 connection failures with 64-port limit
# Success rate: ~91% (64/70)
```

### Demo 5: Dynamic Port Allocation

**Configure dynamic ports:**

1. **Edit Cloud NAT Gateway:**
   - Enable: Dynamic port allocation
   - Minimum ports per VM: 64
   - Maximum ports per VM: 128

2. **Create script with retry logic:**
   ```bash
   # test-dynamic.sh
   #!/bin/bash
   MAX_CONNECTIONS=130
   TARGET="example.com"
   MAX_RETRIES=5

   for ((i=1; i<=MAX_CONNECTIONS; i++)); do
     attempt=0
     while [ $attempt -lt $MAX_RETRIES ]; do
       if curl -s --connect-timeout 5 "$TARGET" > /dev/null; then
         echo "Connection $i: SUCCESS"
         break
       else
         echo "Connection $i: RETRY $attempt"
         sleep 1
         ((attempt++))
       fi
     done
     if [ $attempt -eq $MAX_RETRIES ]; then
       echo "Connection $i: FAILED"
     fi
   done
   ```

3. **Monitor dynamic scaling:**
   ```bash
   # Check port allocation in Cloud Console
   # Observe automatic port increases based on demand
   ```

### Demo 6: Manual IP Configuration

**Reserve and configure manual IPs:**

1. **Reserve external IP:**
   ```bash
   gcloud compute addresses create cloud-nat-manual-ip \
     --region=asia-south1 \
     --network-tier=PREMIUM
   ```

2. **Configure Cloud NAT with manual IP:**
   - IP address allocation: Manual
   - Select reserved IP address
   - Enable: IP draining (for graceful transitions)
   - Port allocation: Static (120 ports per VM)

3. **Test manual configuration:**
   ```bash
   # Verify IP is used for outbound traffic
   curl ifconfig.me
   # Should return the manual IP address
   ```

### Demo 7: Firewall Rules Integration

**Block specific destinations:**

1. **Create egress firewall rule:**
   ```bash
   gcloud compute firewall-rules create block-dns \
     --network=my-network \
     --action=DENY \
     --direction=EGRESS \
     --rules=icmp \
     --destination-ranges=8.8.8.8 \
     --priority=1000 \
     --target-tags=nat-enabled
   ```

2. **Test firewall blocking:**
   ```bash
   # Test blocked destination
   ping 8.8.8.8
   # Expected: No response (blocked)
   
   # Test allowed destination
   ping 8.8.4.4
   # Expected: Successful ping
   ```

## Summary Section

### Key Takeaways

```diff
+ Cloud NAT enables outbound internet access for VMs without external IPs
+ Public NAT is outbound-only with shared IP and port multiplexing
+ Regional service requiring Cloud Router (for configuration only)
+ Automatic IP allocation is recommended for most use cases
+ Dynamic port allocation adapts to varying traffic patterns
+ Google APIs traffic automatically routes via Private Google Access
+ Strict route requirements: must use default-internet-gateway
+ VPC peering does not share NAT gateways between networks
+ Firewall rules can control outbound traffic even with NAT
- No inbound connections possible through Public NAT
- Cannot predict automatic IP allocations for compliance needs
- Dynamic port allocation incompatible with endpoint independent mapping
- Port exhaustion can cause connection failures if limits exceeded
- Route deletion breaks all outbound connectivity immediately
```

### Quick Reference

**Basic Cloud NAT Creation:**
```bash
gcloud compute routers nats create nat-name \
  --router=nat-router \
  --region=region-name \
  --nat-external-ip-pool-option=AUTO \
  --nat-custom-subnet-ip-ranges=subnet-name
```

**Check NAT status:**
```bash
gcloud compute routers nats list --router=nat-router --region=region-name
```

**Test connectivity:**
```bash
# From VM without external IP
curl -s https://ifconfig.me  # Returns NAT IP
ping 8.8.8.8                 # Test internet connectivity
```

**Port configuration ranges:**
- **Minimum per VM**: 32-65,536 (static) / 32-32,768 (dynamic minimum)
- **Maximum per VM**: N/A (static) / 64-65,536 (dynamic maximum)
- **Total usable ports**: 65,500 (excludes first 1,024)

**Timeout defaults:**
- **UDP**: 30 seconds
- **TCP Established**: 1,200 seconds (20 minutes)
- **TCP Transitory**: 30 seconds
- **FIN**: 30 seconds

### Expert Insight

#### Real-world Application
- **Secure outbound access**: Enable internet access for private VMs in production without exposing them
- **Cost optimization**: Reduce external IP costs by sharing IPs across multiple VMs
- **Compliance management**: Use manual IP allocation when external services require whitelisted IP ranges
- **Multi-region deployments**: Implement consistent NAT configuration across global deployments
- **Hybrid connectivity**: Combine with VPN/Cloud Interconnect for comprehensive network architecture

#### Expert Path
1. **Master IP and port planning**: Calculate required capacity based on application connection patterns
2. **Implement monitoring**: Set up Cloud Logging and monitoring for NAT gateway performance
3. **Design for scale**: Plan for dynamic port allocation in variable-traffic environments
4. **Network tier optimization**: Choose premium/standard based on latency vs cost requirements  
5. **Integration testing**: Validate NAT behavior with your specific application stack
6. **Disaster recovery**: Design NAT failover strategies for high-availability requirements
7. **Security integration**: Combine NAT with VPC Service Controls and firewall policies

#### Common Pitfalls
- **Route dependency oversight**: Forgetting that default internet gateway route is mandatory
- **Port exhaustion**: Underestimating connection requirements leading to dropped traffic
- **Network tier confusion**: Not understanding premium vs standard tier implications
- **VPC peering assumptions**: Expecting NAT to work across peered networks
- **Timeout misconfiguration**: Setting timeouts too aggressively for long-lived connections
- **IP draining neglect**: Changing manual IPs without proper draining, breaking active connections
- **Subnet selection errors**: Applying NAT to wrong subnets, leaving VMs without access
- **Google APIs traffic assumptions**: Expecting external routing for Google services when NAT is enabled

</details>
