# Section 23: VPC Sharing

<details open>
<summary><b>Section 23: VPC Sharing (KK-CS45-script-v2)</b></summary>

## Table of Contents
- [23.1 VPC Sharing](#231-vpc-sharing)
- [23.2 AWS Private NAT Gateway](#232-aws-private-nat-gateway)
- [23.3 AWS Network Architecture for Amazon Workspaces-Appstream 2.0](#233-aws-network-architecture-for-amazon-workspaces-appstream-20)
- [23.4 AWS WaveLength](#234-aws-wavelength)
- [23.5 AWS Local Zones](#235-aws-local-zones)
- [Summary](#summary)

## 23.1 VPC Sharing

### Overview
VPC Sharing is an AWS feature that allows sharing a single VPC across multiple AWS accounts within the same AWS Organization. This eliminates the need for duplicate VPCs and subnets in each account, enabling cost savings and resource reuse while maintaining centralized network management.

### Key Concepts/Deep Dive

#### What is VPC Sharing?
VPC Sharing enables multiple AWS accounts in the same AWS Organization to launch resources into a shared VPC. The account that owns the VPC is called the "owner," while other accounts are "participant accounts."

#### Prerequisites
- VPC Sharing can only be enabled for AWS accounts within the same AWS Organization
- Cannot share default VPCs (must use custom VPCs)
- Feature must be enabled at the AWS Organization level through the management account

#### How to Enable VPC Sharing
1. In AWS Organization Management account, go to Resource Access Manager (RAM)
2. Enable sharing with AWS Organizations
3. In owner account, create or select custom VPC and subnets
4. Use RAM to create a resource share for the subnet(s)
5. Specify which accounts, organizational units, or entire organization can share the resource

#### Architecture Patterns

##### Pattern 1: SharedSubnet Approach
- Create one subnet in owner VPC
- Share this subnet with all participant accounts
- **Pros:**
  - Efficient IP address utilization
- **Cons:**
  - Noisy neighbor problem (one account could exhaust IP addresses)
  - Higher blast radius (route table issues affect all accounts)

##### Pattern 2: DedicatedSubnet Approach
- Create dedicated subnet for each participant account
- **Pros:**
  - No noisy neighbor issues
  - Better isolation and control
- **Cons:**
  - Lower IP address utilization
  - Requires more subnet management

#### Benefits of VPC Sharing
- **Simplified Design:** Fewer VPCs and subnets to manage
- **Cost Savings:**
  - Reuse NAT Gateways across accounts
  - Reuse VPC Endpoints
  - Avoid cross-AZ data transfer costs (when using same AZ IDs)
- **Segregation of Duties:** Network team controls architecture, application teams use shared resources
- **IP Address Efficiency:** Better utilization of CIDR ranges
- **Security:** Centralized security group and network ACL management

#### Availability Zone Considerations
- Use AZ IDs (not AZ names) when sharing subnets
- AZ IDs are consistent across accounts (e.g., use1-az1)
- AZ names may differ between accounts for load distribution
- Ensures resources are in the same physical AZ, avoiding cross-AZ data transfer costs

#### Permissions and Billing

##### Permissions Model
**Owner Account Permissions:**
- Full control over VPC, subnets, route tables, security groups
- Can modify sharing settings
- Can revoke access

**Participant Account Permissions:**
- Can launch resources in shared subnets
- Limited networking control (security groups allowed)
- Cannot modify shared networking components
- Can create their own ENIs, EIPs in shared subnets

##### Billing Considerations
- NAT Gateway hourly costs paid by owner account
- VPC Endpoint costs paid by owner account
- Cross-AZ data transfer costs paid by participant accounts (if using different AZs)
- Shared resource costs generally paid by participants

#### Best Practices and Security
- Use AWS Organization Service Control Policies (SCPs) to control sharing
- Limit sharing to specific accounts/OUs via RAM
- Use descriptive resource share names
- Monitor cross-account resource usage
- Implement proper security group rules for shared resources

#### Comparison with Transit Gateway
VPC Sharing ≠ VPC Peering/Transit Gateway
- VPC Sharing: Multiple accounts use same VPC/subnets
- Transit Gateway: Connects separate VPCs for inter-VPC communication
- Can use both together:
  - Use VPC Sharing within business units
  - Use Transit Gateway between business units
  - Extend TGW to on-premises via Direct Connect/VPN

### Lab Demo: Enabling VPC Sharing
1. Navigate to AWS Organizations Management account
2. Go to Resource Access Manager (RAM)
3. Enable sharing with your AWS Organization
```bash
# Enable sharing via CLI
aws ram enable-sharing-with-aws-organization
```

4. Switch to owner account
5. Create or select custom VPC and subnet
6. Go to RAM → Create resource share
   - Select subnet(s) to share
   - Choose principals (accounts/OUs)
   - Set permissions

7. Switch to participant account
8. VPC Console will show "Shared" VPCs
9. Launch EC2 instances in shared subnets

## 23.2 AWS Private NAT Gateway

### Overview
AWS Private NAT Gateway enables communication between private networks with overlapping CIDR ranges by performing Network Address Translation (NAT) between private IP addresses, without internet access. This solves the challenge of connecting microservice-based architectures or multiple business units within organizations that have exhausted or overlapping private IP spaces.

### Key Concepts/Deep Dive

#### Why Private NAT Gateway?
**Problem with Private IPs:**
- RFC1918 ranges (192.168.x.x, 172.16-31.x.x, 10.x.x.x) are standard but limited
- Organizations grow and may have overlapping private IP ranges
- Microservices architectures require more private IPs
- Connecting business units with same CIDR ranges is challenging

**Existing Solutions Limitations:**
- AWS PrivateLink: AWS-specific, doesn't solve overlapping CIDRs universally
- IPv6: Globally public, wastes addresses for internal use
- Self-managed NAT appliances: Operational overhead

#### Private NAT Gateway Functionality
- Performs **private-to-private NAT** (not private-to-public)
- Enables communication between VPCs or VPC-to-on-premises with overlapping CIDRs
- Connected via Virtual Private Gateway (VPN) or Transit Gateway
- Supports one-way traffic (initiator to destination); bidirectional requires dual deployment

#### Architecture for Overlapping CIDRs

##### Step 1: Divide Address Space
- **Non-routable CIDRs:** Overlapping private ranges (same RFC1918 ranges)
- **Routable CIDRs:** Add secondary VPC CIDRs that are unique/non-overlapping
- Extend VPCs with additional CIDR blocks for dedicated transit subnets

##### Step 2: Network Connection
- Use Transit Gateway to connect VPCs (or VPN for simpler setups)
- Create transit gateway attachments in "routable" subnets
- Configure attachment route tables for VPC-to-VPC communication

##### Step 3: Private NAT Gateway Deployment
- Deploy Private NAT Gateway in routable subnet
- Modify route tables for non-routable subnets:
  - Routing traffic to remote routable subnets → Private NAT Gateway
- Destination side routes traffic to routable subnets → Transit Gateway → Target

##### Step 4: Load Balancer Integration
- Deploy Application Load Balancer (ALB) in destination routable subnet
- Register destination instances as targets
- Initiating instances communicate via ALB API calls, not direct IP access

#### Traffic Flow Example
```
Business Unit A (192.168.0.10) → Private NAT Gateway (10.0.1.15) →
Transit Gateway → Target ALB (10.0.2.10) → Instance B (192.168.0.11)
```

**Route Table Configuration:**
```yaml
# Source VPC Non-routable Subnet (192.168.0.0/24)
routes:
  - destination: 192.168.0.0/24  # Local
    target: local
  - destination: 10.0.1.0/24    # Local routable
    target: local
  - destination: 10.0.2.0/24    # Remote routable
    target: Private NAT Gateway

# Destination VPC Non-routable Subnet (192.168.0.0/24)
routes:
  - destination: 10.0.2.0/24    # Local routable
    target: Transit Gateway Attachment
```

#### Bidirectional Communication
- Requires Private NAT Gateway + ALB in BOTH VPCs
- Initiator → Source NAT → Transit → Destination ALB → Target
- For reverse traffic: Target → Source NAT → Transit → Initiator ALB → Source

#### Limitations and Considerations
- **Unidirectional by default:** Return traffic setup required
- **Application Load Balancer dependency:** Microservices must expose APIs
- **Route table complexity:** Careful routing configuration required
- **Performance overhead:** Additional hop through NAT Gateway and ALB
- **Cost considerations:** Additional infrastructure and cross-zone traffic fees

#### Use Cases
- **Microservices architectures** with overlapping IP ranges
- **Mergers and acquisitions** with conflicting network addressing
- **Multi-cloud connectivity** extending to other clouds
- **Legacy application integration** with constrained addressing

#### Deployment Steps
1. Add secondary routable CIDRs to VPCs (ensure non-overlapping)
2. Create Transit Gateway and attachments in routable subnets
3. Deploy Private NAT Gateway in source routable subnet
4. Configure route tables for NAT routing
5. Deploy ALBs in destination routable subnets
6. Register application endpoints with ALBs
7. Test connectivity using ALB DNS endpoints

## 23.3 AWS Network Architecture for Amazon Workspaces-Appstream 2.0

### Overview
AWS WorkSpaces and AppStream 2.0 are fully managed End User Computing (EUC) services that run in AWS-managed VPCs, but require access to customer resources. AWS creates requester-managed ENIs in the customer's VPC to enable secure private connectivity between managed services and customer workloads.

### Key Concepts/Deep Dive

#### AWS Managed Services Network Model
**WorkSpaces:** Desktop-as-a-Service (DaaS) - Full remote desktop access
**AppStream 2.0:** Application-as-a-Service - Remote application streaming
- Both services run in **AWS-managed VPCs** (invisible to customers)
- Customers cannot access or modify managed VPCs/security groups
- Network isolation maintained for AWS service management

#### Requester-Managed ENIs
AWS automatically creates **Elastic Network Interfaces (ENIs)** in customer's VPCs:
- Allow managed services to access customer resources privately
- Customer controls security groups attached to ENIs
- ENIs appear as "managed by AWS" in EC2 console
- **No additional cost** for requester-managed ENIs

#### ENI Types for WorkSpaces
**Two ENIs per WorkSpace instance:**
1. **Streaming ENI:** Public-facing (AWS-managed VPC) for user access
2. **VPC ENI:** Customer VPC/subnet for accessing corporate resources

**Additional ENIs for Streaming Gateway:**
- Separate ENI in customer VPC for managing streaming sessions
- Enables low-latency, secure desktop/app streaming to end users

#### Network Architecture

##### Hybrid Network Setup
```
[End User] --Internet--> [AWS Auth/Session Gateway] --(ENI)--> [Customer VPC]
                                 ↓
[Active Directory Connector] --VPN/DX--> [On-premises AD]
```

**Traffic Flows:**
1. **Authentication:** User → AWS Session Gateway → AD Connector → VPN/DX → On-premises AD
2. **Streaming:** User → Streaming Gateway → WorkSpace/AppStream instance
3. **Resource Access:** WorkSpace/AppStream → VPC ENI → Customer resources (RDS, EC2, etc.)

#### Active Directory Integration
**Options:**
- **On-premises AD:** Requires VPN/Direct Connect for authentication
- **AWS-managed AD:** Simple integration within same region
- **AD Connector:** Bridging service for on-premises authentication

#### Security Considerations
- **ENI Security Groups:** Customer-managed, controls access to VPC resources
- **Network ACLs:** Apply at subnet level for additional segmentation
- **Private Subnet Deployment:** ENIs placed in private subnets by default
- **Encryption:** PCoIP (UDP/TCP port 4172) or newer protocols for streaming

#### Configuration Steps
1. **Prepare VPC and Subnets:**
   - Create VPC with private subnets
   - Configure VPN/Direct Connect for hybrid access
   - Set up AD DS (Cloud or on-premises)

2. **Deploy Managed Service:**
   ```bash
   # WorkSpaces Directory Registration
   aws workspaces register-workspace-directory --directory-id d-1234567890 --subnet-ids subnet-abc123 subnet-def456
   ```

3. **Configure Security Groups:**
   - Allow necessary ports for streaming and resource access
   - Restrict access based on least-privilege principles

4. **Verify ENI Creation:**
   - Check EC2 console for "managed by AWS" ENIs
   - Confirm proper subnet and security group assignment

#### Monitoring and Troubleshooting
- **CloudWatch Logs:** Enable logging for WorkSpaces/AppStream instances
- **VPC Flow Logs:** Monitor traffic through ENIs
- **ENI Health Checks:** AWS automatically manages ENI availability
- **Security Group Rules:** Audit for proper access controls

#### Cost Optimization
- **ENI Costs:** No charges (requester-managed)
- **Data Transfer:** Within VPC = free, cross-AZ = charged
- **Bandwidth:** Streaming compresses data to optimize costs

## 23.4 AWS WaveLength

### Overview
AWS WaveLength Zones provide ultra-low latency AWS computing infrastructure deployed directly within telecommunications providers' datacenters at the edge of 5G networks, enabling applications that require single-digit millisecond response times.

### Key Concepts/Deep Dive

#### WaveLength Zone Architecture
```
[5G Mobile Device] --> [Telecommunications Provider Network] --> [WaveLength Zone]
                                                                        ↓
                                                            [Carrier Gateway] <--> [Parent AWS Region]
```

**Key Components:**
- **WaveLength Zones:** AWS infrastructure embedded in telecom datacenters
- **Carrier Gateway:** Secure connection between WaveLength Zone and parent region
- **Parent Region:** Standard AWS region for data processing and storage

#### Supported AWS Services
- **Compute:** EC2 instances, EBS volumes, VPCs
- **Network:** Private connectivity, security groups, network ACLs
- **Connection:** Secure backhaul to parent region (no additional charges)

#### Low Latency Advantage
- **Traffic Path:** User data never leaves telecom network
- **Latency:** Sub-10ms response times
- **Use Cases:** Real-time applications requiring immediate processing

#### Deployment Model
1. **Location:** Deployed at telecommunications provider edge
2. **Management:** Standard AWS tools and APIs for resource provisioning
3. **Connectivity:** Automatic secure connection to parent region via carrier gateway
4. **Isolation:** Code and data remain within telecom provider's infrastructure

#### Available Services
```yaml
Supported Services:
  - Amazon EC2 (various instance types)
  - Amazon EBS (GP3, io1, etc.)
  - Amazon VPC (standard networking features)
  - Elastic Load Balancers
  - AWS PrivateLink
  - AWS Systems Manager
  - Amazon CloudWatch
```

#### Security and Compliance
- **Data Residency:** Applications and data remain in telecom provider's network
- **Encryption:** End-to-end encryption within the carrier network
- **Compliance:** Inherits parent region certifications
- **Access Control:** Standard AWS IAM permissions apply

#### Use Cases
- **Smart Cities:** IoT sensor data processing
- **Connected Vehicles:** Real-time vehicle-to-infrastructure communication
- **AR/VR:** Immersive experiences with extremely low latency
- **Interactive Gaming:** Multiplayer gaming with ultra-fast response
- **ML-assisted Diagnostics:** Real-time medical image analysis
- **Live Video Streaming:** Ultra-low latency interactive streaming

#### Billing Model
- **Standard AWS Pricing:** Pay for compute, storage, data transfer
- **No Additional Fees:** No charges for WaveLength usage or carrier gateway
- **Data Transfer:** Charged only when crossing from WaveLength to parent region

#### Limitations
- **Service Availability:** Regional availability depending on telecom provider partnerships
- **Resource Constraints:** Limited instance types and services compared to full regions
- **Latency Distance:** Benefit depends on proximity to 5G infrastructure

## 23.5 AWS Local Zones

### Overview
AWS Local Zones extend AWS infrastructure to more locations, bringing compute, storage, and other services closer to end users for applications requiring single-digit millisecond latencies.

> [!NOTE]
> The transcript provided is extremely brief and doesn't contain detailed technical information about AWS Local Zones. Based on industry knowledge, Local Zones provide AWS services at the edge, similar to WaveLength Zones but in standard datacenters rather than telecom provider facilities.

### Key Concepts/Deep Dive

#### Local Zones Architecture
AWS Local Zones are extensions of parent regions that are geographically closer to end users, enabling lower latency and improved performance for latency-sensitive applications.

**Key Characteristics:**
- **Parent Region Integration:** Fully integrated with standard AWS regions
- **Service Selection:** Supporting select AWS services at edge locations
- **Network Connectivity:** Low-latency connectivity to parent regions

#### Supported Services
AWS Local Zones typically support:
- Amazon EC2 instances
- Amazon EBS storage
- Amazon VPC networking
- Amazon ELB load balancers
- AWS Direct Connect points-of-presence

#### Use Cases Similar to WaveLength
- **Edge Computing Applications**
- **Real-time Analytics**
- **Gaming Workloads**
- **Video Processing and Streaming**

#### Deployment Considerations
- **Region Availability:** Local Zones are available in specific geographic areas
- **Resource Types:** Limited selection of instance types and storage options
- **Networking:** VPCs can span Local Zones for unified networking

#### Comparison: Local Zones vs. WaveLength
| Feature | Local Zones | WaveLength |
|---------|-------------|------------|
| Location | Standard datacenters | Telecom provider facilities |
| Connectivity | Via parent region | Via carrier gateway |
| Services | Full AWS service range | Select services |
| Network Integration | Seamless VPC extension | Carrier network integration |
| Latency Target | Low latency to region | Ultra-low 5G edge latency |

> [!IMPORTANT]
> Local Zones differ from WaveLength Zones primarily in their location within standard datacenter infrastructure rather than telecommunications provider networks, though both aim to reduce latency through geographic proximity.

## Summary

### Key Takeaways
```diff
! VPC Sharing enables cost-effective resource sharing across AWS Organization accounts
+ Private NAT Gateway solves overlapping CIDR challenges in hybrid and multi-account architectures
- WorkSpaces/AppStream use requester-managed ENIs for secure customer VPC access
! WaveLength provides ultra-low latency via 5G network integration
+ Local Zones bring AWS services closer to users in standard datacenters
- Always use AZ IDs (not names) for cross-account resource sharing
+ Centralized network management with VPC Sharing reduces complexity
- Private NAT requires ALB integration for proper routing in overlapping CIDR scenarios
```

### Quick Reference

**VPC Sharing Commands:**
```bash
# Check if sharing is enabled
aws ram get-resource-shares --resource-owner OTHER-ACCOUNTS

# Create resource share
aws ram create-resource-share \
  --name "subnet-share" \
  --resources arn:aws:ec2:region:account:subnet/subnet-12345 \
  --principals arn:aws:organizations::org/org-id/ou/ou-id
```

**Private NAT Gateway Setup:**
```yaml
# Example route table configuration
Routes:
  - DestinationCidrBlock: 10.0.2.0/24
    NatGatewayId: nat-12345
  - DestinationCidrBlock: 0.0.0.0/0
    TransitGatewayId: tgw-12345
```

**WorkSpaces ENI Configuration:**
```bash
# Directory registration with subnets
aws workspaces register-workspace-directory \
  --directory-id d-1234567890 \
  --subnet-ids subnet-private-1 subnet-private-2 \
  --enable-self-service-portal
```

### Expert Insight

#### Real-world Application
- **Enterprise Cost Optimization:** Use VPC Sharing to consolidate networking infrastructure across development, staging, and production environments while maintaining account isolation
- **Multi-region Migration:** Implement Private NAT Gateways during cloud migration projects where legacy applications have overlapping IP ranges
- **Secure Remote Access:** Leverage WorkSpaces ENIs to provide secure, private access to corporate resources without exposing internal networks to the internet

#### Expert Path
- Master cross-account networking patterns and understand when to choose VPC Sharing over Transit Gateway connections
- Deep dive into hybrid networking architectures, especially Private NAT Gateway deployment for complex enterprise scenarios
- Focus on understanding requester-managed ENI patterns for all AWS managed services requiring VPC integration

#### Common Pitfalls
- **AZ Mapping Errors:** Using AZ names instead of AZ IDs when sharing subnets, leading to unexpected data transfer charges
- **Route Table Misconfiguration:** Incorrect routing in Private NAT Gateway setups causing asymmetric traffic flow
- **Security Group Oversights:** Overly permissive security groups on requester-managed ENIs allowing unintended access
- **Resource Sharing Scope:** Sharing subnets too broadly without proper organization unit restrictions

#### Lesser-Known Facts
- VPC Sharing requires AWS Organizations, can't be used with standalone accounts
- Private NAT Gateway traffic is one-way by default; bidirectional requires symmetrical deployments
- WorkSpaces creates multiple ENIs per instance (3-4 total) for different networking purposes
- WaveLength Zones are available only where AWS has partnerships with telecommunications providers
- Local Zones use the same parent region AZ IDs for consistent networking

</details>