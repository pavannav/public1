# Section 13: Introduction to AWS Client VPN

<details open>
<summary><b>Section 13: Introduction to AWS Client VPN (KK-CS45-script-v2)</b></summary>

## Table of Contents
- [13.1 Introduction to AWS Client VPN](#131-introduction-to-aws-client-vpn)
- [13.2 Hands On- Setup the AWS Client VPN](#132-hands-on-setup-the-aws-client-vpn)
- [13.3 Hands On- Accessing VPC internet gateway over the Client VPN connection](#133-hands-on-accessing-vpc-internet-gateway-over-the-client-vpn-connection)
- [13.4 Hands On- Client VPN Split Tunnel](#134-hands-on-client-vpn-split-tunnel)
- [13.5 Hands On- Accessing VPC peering connection over a Client VPN](#135-hands-on-accessing-vpc-peering-connection-over-a-client-vpn)

## 13.1 Introduction to AWS Client VPN

### Overview
This lecture introduces AWS Client VPN, a managed service launched in late 2019 that enables client-to-site connections to AWS VPCs. Unlike site-to-site VPNs that connect networks directly, Client VPN allows individual clients (e.g., laptops) to securely access VPC resources over the internet using a VPN endpoint.

### Key Concepts & Deep Dive
AWS Client VPN provides a centralized solution for remote access to corporate networks in the cloud. Before 2019, users typically deployed EC2 instances with VPN software to achieve this functionality.

#### Client-to-Site VPN Overview
- **Traditional Use Case**: Remote workers accessing company intranets from home during events like COVID-19
- **How it Works**: Users connect their client machine to a VPN server, enabling access to internal websites and servers
- **Distinction from Site-to-Site**: Site-to-site connects two networks (e.g., on-premises to AWS VPC); client-to-site connects a single client device to a network

![Client VPN High-Level Architecture](images/client-vpn-architecture.png)

#### AWS Client VPN Benefits
- Connect to VPC resources over private IP addresses (no public internet exposure)
- Access peered VPCs once connected
- Reach VPC endpoints like S3 and DynamoDB
- Route to on-premises networks if the VPC is already connected
- Enable internet access through attached Internet Gateway (IGW)

#### Prerequisites and Components
1. **VPC**: Target VPC for VPN connectivity
2. **Subnet**: Dedicated "VPN target subnet" for the interface created during connection
3. **Client CIDR Range**: Non-overlapping IP range for client connections (assigns IP to connecting clients)
4. **Authentication**: Supports multiple methods:
   - **Mutual Authentication**: PKI-based with certificates stored in AWS Certificate Manager (ACM)
   - Active Directory integration
   - SAML federation
5. **Client Software**: OpenVPN-compatible client on the endpoint device
6. **AWS Client VPN Endpoint**: DNS endpoint for connections
7. **Network Interface**: Auto-created ENI associated with default security group
8. **Route Management**:
   - VPC route tables control traffic
   - Client VPN managed route table defines target networks
   - Authorization rules for access control

#### Security and Networking Concepts
- **Client CIDR Selection**: Must not overlap with VPC CIDR; cannot be changed after creation
- **Route Authorization**: Defines which users (if using AD/SAML) can reach which networks
- **Traffic Flow**: Once connected, clients operate within the VPC security model

#### Limitations and Considerations
- Client CIDR boundaries (limited ranges)
- Maximum concurrent connections
- Association restrictions (one subnet per region in a given account)

#### Pricing Model
Based on North Virginia region (varies by region):
- **Connection Fee**: $0.10/hour per associated subnet (regardless of active connections)
- **Connection Fee**: $0.05/hour per active user connection

### Lab Demos
No hands-on labs in this introductory lecture.

## 13.2 Hands On- Setup the AWS Client VPN

### Overview
This practical lecture demonstrates step-by-step setup of AWS Client VPN, including certificate generation, VPC configuration, endpoint creation, and client connection testing.

### Key Concepts & Deep Dive
The setup involves generating certificates, configuring VPC infrastructure, creating the Client VPN endpoint, and establishing connections from client devices.

#### Certificate Generation Process
Using Easy-RSA for PKI infrastructure:
```bash
# Clone Easy-RSA repository
git clone https://github.com/OpenVPN/easy-rsa.git
cd easy-rsa/easyrsa3

# Initialize PKI
./easyrsa init-pki

# Build Certificate Authority (CA)
./easyrsa build-ca nopass

# Build server certificate
./easyrsa build-server-full server nopass

# Build client certificate
./easyrsa build-client-full client1 nopass

# Files generated:
# - ca.crt (CA certificate)
# - issued/server.crt, private/server.key
# - issued/client1.crt, private/client1.key
```

#### Certificate Import to ACM
```bash
# Import server certificate
aws acm import-certificate --certificate fileb://pki/issued/server.crt \
                         --private-key fileb://pki/private/server.key \
                         --certificate-chain fileb://pki/ca.crt \
                         --region ap-south-1

# Import client certificate (if different signer)
aws acm import-certificate --certificate fileb://pki/issued/client1.crt \
                         --certificate-chain fileb://pki/ca.crt \
                         --region ap-south-1
```

#### VPC and Subnet Configuration
Create VPC with dedicated route tables:
- **VPC CIDR**: 192.168.0.0/16
- **Application Subnet**: 192.168.0.0/24 (for EC2 instances)
- **VPN Target Subnet**: 192.168.100.0/24 (for VPN ENI)

#### Security Group Configuration
- **Client VPN Security Group**: No inbound rules, all outbound traffic allowed
- **Application Instance SG**: Allow all traffic from Client VPN SG (cross-reference)

#### EC2 Instance Setup
Launch test instance in application subnet with security group allowing VPN traffic:
- Use cross-referenced security group for inbound access
- No public IP (accessible only via VPN)

#### Client VPN Endpoint Configuration
```yaml
VPN Endpoint Settings:
- Name: demo-client-vpn-endpoint
- Client CIDR: 10.10.0.0/16
- Server Certificate ARN: arn:aws:acm:region:account:certificate/server-cert-id
- Authentication: Mutual Authentication
- Client Certificate ARN: arn:aws:acm:region:account:certificate/client-cert-id
- VPC ID: vpc-demo-id
- Security Group: sg-vpn-sg-id
- Enable Connection Logging: false
- Transport Protocol: UDP
```

#### Association and Authorization
- Associate VPN endpoint with target subnet (creates ENI)
- Create authorization rule allowing access to VPC CIDR (192.168.0.0/16)
- Client VPN route table auto-populates with VPC route

#### Client Configuration File
Download and modify client configuration:
```
# Original file contents
remote cvpn-endpoint-[id].prod.clientvpn.region.amazonaws.com 443 udp
cert client1.crt
key client1.key

# Modifications needed:
1. Add random prefix to remote endpoint: randomstring.cvpn-endpoint-[id].prod.clientvpn.region.amazonaws.com
2. Ensure cert and key paths are absolute/local paths
```

#### Connection Verification
```bash
# Check assigned IP
ipconfig  # Windows
# Look for IP in 10.10.0.0/16 range

# Test connectivity to VPC instance
ping 192.168.0.10  # Private IP of test instance
```

### Lab Demos
**Complete AWS Client VPN Setup and Connection Test**
1. Generate PKI certificates using Easy-RSA
2. Import certificates to ACM
3. Create VPC with application and VPN target subnets
4. Configure security groups
5. Launch EC2 test instance
6. Create Client VPN endpoint with mutual authentication
7. Associate endpoint with target subnet
8. Configure authorization rules
9. Download and modify client configuration file
10. Install OpenVPN client and import configuration
11. Establish VPN connection
12. Verify connectivity to VPC resources

## 13.3 Hands On- Accessing VPC internet gateway over the Client VPN connection

### Overview
This lecture demonstrates enabling internet access for Client VPN connections by routing all traffic through the VPC's Internet Gateway, allowing clients secure access to internet resources via AWS infrastructure.

### Key Concepts & Deep Dive

#### Two Approaches for Internet Access
1. **Full Routing**: All client traffic routes through VPC IGW
2. **Split Tunnel** (covered in next lecture): Only VPC traffic routes through VPN

#### Full Routing Configuration Steps
1. **Attach IGW to VPC**
2. **Modify Route Tables**:
   - VPN target subnet: Add route 0.0.0.0/0 → IGW
   - NAT Gateway route (alternative to IGW for private subnets)
3. **Update Authorization Rules**: Allow access to 0.0.0.0/0
4. **Modify Client VPN Route Table**: Add route for 0.0.0.0/0 via target subnet

#### Security Considerations
- All traffic traverses AWS network (more bandwidth costs)
- Subject to VPC security groups and Network ACLs
- Requires proper IGW and route configuration

#### Traffic Flow Verification
```bash
# With VPN connected
ping 192.168.0.10  # VPC private IP
ping 8.8.8.8       # Internet IP
curl google.com    # Web access
```

### Lab Demos
**Enable Internet Access via VPC IGW**
1. Attach Internet Gateway to VPC
2. Configure route table for VPN target subnet: 0.0.0.0/0 → IGW
3. Add authorization rule for 0.0.0.0/0 destination
4. Add route to Client VPN route table: 0.0.0.0/0 → target subnet
5. Disconnect and reconnect VPN
6. Test connectivity to VPC resources and internet

## 13.4 Hands On- Client VPN Split Tunnel

### Overview
This lecture covers split tunnel functionality, which routes only VPC-specific traffic through the Client VPN, while allowing internet traffic to use the client's local connection.

### Key Concepts & Deep Dive

#### Split Tunnel Mechanism
- **Purpose**: Optimize bandwidth and performance
- **Functionality**: VPC traffic → VPN tunnel; Internet traffic → local connection
- **Client-Side Handling**: Split tunnel logic implemented in OpenVPN client

#### Configuration Process
1. **Enable Split Tunnel**: Edit Client VPN endpoint settings
2. **Reconnect with Updated Config**: Client handles traffic splitting
3. **DNS Modification**: Required for split tunnel (random prefix prepended to endpoint)

#### Trade-offs and Considerations
- **Advantages**:
  - Direct internet access (faster, lower latency)
  - Reduced AWS bandwidth costs
  - Local internet services work normally
- **Disadvantages**:
  - VPC endpoint services may not work (S3, DynamoDB private endpoints require routing)
  - May need proxy configuration for endpoint services

#### Client Configuration Requirements
```openvpn
# client.ovpn
remote randomprefix.cvpn-endpoint-xxx.prod.clientvpn.region.amazonaws.com 443 udp
cert /path/to/client.crt
key /path/to/client.key
# Client software automatically handles traffic splitting
```

### Lab Demos
**Configure and Test Split Tunnel**
1. Edit Client VPN endpoint to enable split tunnel
2. Download new configuration file
3. Add random string prefix to DNS endpoint
4. Disconnect existing VPN connection
5. Import modified configuration to OpenVPN client
6. Establish new connection
7. Verify VPC resource access (ping private IP)
8. Verify internet access (ping/curl external sites)
9. Note: Endpoint services may require additional configuration

## 13.5 Hands On- Accessing VPC peering connection over a Client VPN

### Overview
This lecture demonstrates accessing resources in peered VPCs through Client VPN connections, extending the access scope beyond a single VPC.

### Key Concepts & Deep Dive

#### VPC Peering Requirements
- Establish VPC peering connection between base and peered VPCs
- Peered VPC must use non-overlapping CIDR (e.g., 10.100.0.0/16)
- Configure route tables for cross-VPC communication

#### Security Group Configuration
- **Cross-Reference Security Groups**: Reference Client VPN SG across VPC peering
- **Peered Instance SG**: Allow all traffic from Client VPN security group

#### Route Table Modifications
**Base VPC Route Table** (if needed):
- Route to peered VPC: 10.100.0.0/16 → Peering connection

**Peered VPC Route Table**:
- Route to base VPC: 192.168.0.0/16 → Peering connection

**Client VPN Route Table**:
- Route to peered VPC: 10.100.0.0/16 → Peering connection

#### Authorization Rules
- Add authorization for peered VPC CIDR: 10.100.0.0/16
- Grant access to "all users" (for certificate auth) or specific user groups

#### Traffic Flow Architecture
```
Client (VPN IP) → Client VPN Endpoint → Base VPC → VPC Peering → Peered VPC Instance
```

### Lab Demos
**Access Peered VPC Resources via Client VPN**
1. Create peered VPC with private subnet (10.100.0.0/24)
2. Launch EC2 instance in peered VPC with security group allowing Client VPN traffic
3. Create VPC peering connection and accept peering
4. Update route tables for VPC-to-VPC communication
5. Add Client VPN route for peered VPC CIDR
6. Configure authorization rule for peered VPC access
7. Test connectivity from client: ping peered VPC instance private IP

## Summary

### Key Takeaways
```diff
+ AWS Client VPN enables secure remote access to VPC resources using OpenVPN-compatible clients
+ Supports mutual TLS authentication using certificates stored in ACM
+ Can access VPC resources, peered VPCs, internet (via IGW), and endpoint services
+ Split tunnel option optimizes performance by routing only VPC traffic through VPN
- Currently supports only one concurrent zone per AWS region per account
- Client CIDR range cannot be modified after endpoint creation
- Full routing through IGW increases AWS bandwidth costs
```

### Quick Reference

**Core Components**:
- VPC with dedicated target subnet
- Client VPN endpoint with DNS
- Mutual authentication certificates (ACM)
- OpenVPN client software

**Key Commands**:
```bash
# Certificate generation
./easyrsa init-pki
./easyrsa build-ca nopass
./easyrsa build-server-full server nopass
./easyrsa build-client-full client1 nopass

# ACM import
aws acm import-certificate --certificate fileb://server.crt \
                         --private-key fileb://server.key \
                         --certificate-chain fileb://ca.crt

# Connection verification
ping <private-ip>    # Test VPC connectivity
tracert <ip>         # Trace routing paths
```

**Pricing Structure** ($0.10/hour + $0.05/hour per connection, N. Virginia region).

**Limitations**:
- 1 subnet per region per account
- Fixed client CIDR after creation
- UDP/TCP transport options

### Expert Insight

#### Real-World Application
In enterprise environments, AWS Client VPN replaces traditional remote access solutions (like Citrix, OpenVPN servers) by providing a fully managed, scalable service. Organizations can provision Client VPN endpoints alongside existing AWS workloads, giving employees secure access to development environments, internal applications, and hybrid cloud resources without exposing services directly to the internet.

#### Expert Path
**Mastery checkpoints**:
1. **PKI Fundamentals**: Understand certificate chain validation and CRL handling
2. **Network Segmentation**: Design VPC architectures that leverage Client VPN with peering and transit gateways
3. **Security Best Practices**: Implement least-privilege authorization rules and monitor connection logs
4. **Performance Optimization**: Choose between full routing vs. split tunnel based on use case requirements
5. **Multi-Region Scenarios**: Handle certificate distribution and endpoint management across regions

#### Common Pitfalls
- **Overlapping CIDRs**: Ensure client CIDR, VPC CIDR, and peered VPC CIDRs don't conflict
- **Security Group References**: When peering VPCs, security groups can be cross-referenced, but must be done after peering establishment
- **DNS Resolution**: Split tunnel requires client-side handling of DNS queries and endpoint services
- **Route Updates**: Client VPN route table changes require reconnection for split tunnel configurations
- **Connection Limits**: Monitor concurrent connections especially with certificate-based auth (no granular user control)

#### Lesser-Known Facts
- **Automatic Failover**: Client VPN can automatically failover to another availability zone if the primary target subnet becomes unavailable (with proper multi-subnet setup)
- **Endpoint Services Integration**: VPC endpoint policies can control which S3/DynamoDB resources are accessible via Client VPN
- **Bandwidth Optimization**: Split tunnel reduces costs but may break applications relying on source IP-based security policies
- **Certificate Validity**: Expired certificates cause immediate disconnection with no grace period
- **ENI Characteristics**: The auto-created ENI behaves like any other VPC ENI and can be monitored via VPC Flow Logs

</details>