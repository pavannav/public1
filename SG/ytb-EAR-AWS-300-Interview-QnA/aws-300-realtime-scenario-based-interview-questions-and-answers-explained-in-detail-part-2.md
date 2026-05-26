<details open>
<summary><b>AWS 300+ Real-time Scenario Based Interview Questions and Answers Explained in Detail - Part - 2 (KK-CS45-script-v2-Interview)</b></summary>

# AWS 300+ Real-time Scenario Based Interview Questions and Answers - Part 2

## Questions 11-20: EC2 Fundamentals and Cloud Services

---

## Question 11: What are the different types of cloud computing as per services?

### Answer:

There are three primary service models in cloud computing:

**1. Infrastructure as a Service (IaaS)**
- You manage: Application, runtime, security, integration, database
- Cloud provider manages: Servers, virtualization, hardware storage, networking
- Analogy: You build and maintain the house but rent the land and utilities
- Example: AWS EC2, Azure VMs, Google Compute Engine

**2. Platform as a Service (PaaS)**
- You manage: Only application and data
- Cloud provider manages: Runtime, security, integration, database, servers, virtualization, hardware, storage, networking
- Analogy: You just paint the house; everything else is managed
- Example: AWS Elastic Beanstalk, Google App Engine, Heroku

**3. Software as a Service (SaaS)**
- You manage: Only usage and data
- Cloud provider manages: Everything
- Analogy: You just live in the fully-furnished house
- Example: Gmail, Salesforce, Dropbox, Office 365

### Evolution from Traditional IT:
- **Traditional (On-premises)**: Everything managed internally by the organization
- **Now**: Organizations leverage cloud services based on their specific requirements

### Organization Choice Factors:
- Most companies use IaaS or PaaS for flexibility and control
- SaaS for applications where no customization is needed

---

## Question 12: Explain Regions and Availability Zones in EC2

### Answer:

**Regions:**
- Physical locations where AWS hosts data centers
- Free tier accounts get access to 17 regions
- Each region is isolated from others for fault tolerance
- Payment required for access to additional regions (11 more regions)

**Availability Zones (AZs):**
- Each region contains multiple isolated locations called AZs
- AZ naming: Region code + letter (e.g., ap-south-1a, ap-south-1b, ap-south-1c)
- AZs are physically separated within the same region
- Provide fault tolerance and high availability

### Practical Demonstration:
1. Navigate to AWS Dashboard → Account name → Regions list
2. Create instances with the same configuration in different AZs
3. If instance in AZ 'b' fails, traffic routes to AZ 'a' or 'c'
4. Ensures application remains available

### Fault Tolerance Architecture:
- Identical bridges analogy: Multiple bridges across same river
- If one bridge collapses, others maintain traffic flow
- Same principle applies to AZs - redundant infrastructure

### VPC and Subnet Relationship:
- One VPC spans across one region
- Multiple subnets can be created within a VPC
- Each subnet associates with specific AZ
- Example: Subnet A → AZ-a, Subnet B → AZ-b, Subnet C → AZ-c

---

## Question 13: What is an AMI (Amazon Machine Image)?

### Answer:

**AMI Definition:**
- Template containing pre-configured software for launching EC2 instances
- Contains: Operating system, application server, applications, configurations
- Pre-packaged environment ready for immediate use

**Comparison to Traditional Approach:**
- Traditional: Install OS → Install applications → Configure → Connect database
- AMI approach: Launch template → Instance ready in seconds

**Analogy - Biryani Model:**
- Just like biryani contains everything in one place (rice, spices, vegetables)
- AMI contains everything needed for your application in one template

### Docker Comparison:
- Similar to Docker images where containers are created from images
- AMI instances are created from the template
- Everything pre-configured and ready to run

**Creating an Instance with AMI:**
1. Go to EC2 Dashboard → Launch Instance
2. Select AMI from available options:
   - Amazon Linux
   - Red Hat Enterprise Linux
   - Ubuntu
   - SUSE Linux
   - macOS
   - Debian
3. Choose instance type (t2.micro, t2.nano, etc.)
4. Configure key pair for secure access
5. Set security group rules (HTTP, HTTPS, SSH)
6. Add storage (Elastic Block Store)
7. Launch instance

---

## Question 14: What is the Difference Between Stopping and Terminating an Instance?

### Answer:

**Stopping an Instance:**
- Instance is shut down but not deleted
- Root EBS volume remains attached
- All data on EBS volumes is preserved
- Instance can be started again with same configuration
- Billing stops for the instance but EBS storage continues

**Terminating an Instance:**
- Instance is permanently deleted
- By default, root EBS volume is also deleted
- All data on local instance store is lost
- Cannot be recovered once terminated
- Resource cleanup is permanent

### EBS Volume Behavior:
- **Stop action**: EBS volumes remain attached to instance
- **Terminate action**: Default behavior deletes root EBS volumes
- Device naming: Shows as `/dev/xvda` for EBS volumes (not SCSI disks)

### Best Practice:
- Always stop instances when not in use, never terminate
- Prevents accidental data loss
- Allows resuming work without reconfiguration

---

## Question 15: What are the Two Types of Load Balancers?

### Answer:

**Note**: While AWS offers three types under Elastic Load Balancing, fundamentally there are two categories:

**1. Application Load Balancer (ALB)**
- Operates at Layer 7 (Application Layer) of OSI model
- Routes HTTP and HTTPS traffic
- Supports path-based routing
- Can route requests to one or more targets (instances, containers)
- Ideal for web applications and microservices

**2. Network Load Balancer (NLB)**
- Operates at Layer 4 (Transport Layer) of OSI model
- Routes TCP and UDP traffic
- Handles millions of requests per second
- Low latency, high throughput
- Ideal for performance-critical applications and TCP/UDP workloads

**Classic Load Balancer:**
- Legacy load balancer (not recommended for new applications)
- Distributes traffic across EC2 instances, containers, and IP addresses
- Monitors health of registered targets
- Routes traffic only to healthy targets
- No layer-specific routing decisions

### Use Case Examples:
- **ALB**: Web apps, REST APIs, container-based apps
- **NLB**: Gaming servers, IoT applications, high-performance computing
- **Classic LB**: Legacy applications requiring basic load distribution

### Production Implementation:
- Usually configured using NGINX servers
- 24/7 uptime monitoring
- Health checks on backend instances

---

## Question 16: Can an AMI be Shared?

### Answer:

**Yes, AMIs can be shared** across accounts and developers.

**Benefits:**
- Reusability: Pre-configured environments shared across teams
- Standardization: Ensure consistent configurations across deployments
- Flexibility: Recipients can customize shared AMI as needed

**Considerations and Risks:**
- Similar to buying a used car - risk factors unknown
- Cannot verify complete history or potential issues
- Must verify AMI source and contents before use
- Security scanning recommended before deployment

**Sharing Process:**
1. Developer creates customized AMI with all configurations
2. AMI shared with specific AWS accounts or made public
3. Recipients launch instances from shared AMI
4. Customizations can be made after launch

**Best Practices:**
- Only share with trusted parties
- Document all configurations in the AMI
- Regular security updates on shared AMIs
- Version control for different configurations

---

## Question 17: How to Ensure EC2 Instance Launches in Specific Availability Zone?

### Answer:

**Method: Select Appropriate Subnet During Launch**

**Step-by-Step Process:**
1. Navigate to EC2 Dashboard → Launch Instance
2. Configure instance details (name, AMI, instance type)
3. In Network Settings → Edit
4. Select desired VPC
5. Choose specific subnet (each subnet maps to an AZ):
   - Subnet in AZ-a launches instance in AZ-a
   - Subnet in AZ-b launches instance in AZ-b
   - Subnet in AZ-c launches instance in AZ-c

**Subnet-AZ Mapping:**
- Each subnet belongs to exactly one AZ
- AZ 'a': ap-south-1a
- AZ 'b': ap-south-1b
- AZ 'c': ap-south-1c

**Important Considerations:**
- Cannot change AZ after instance launch
- Plan AZ placement based on:
  - Proximity to users
  - Compliance requirements
  - Cost optimization
  - Disaster recovery strategy

---

## Question 18: What Happens When You Delete a VPC Peering Connection?

### Answer:

**When a VPC peering connection is deleted:**

- The peering connection terminates on **both sides**
- No more traffic flow between the peered VPCs
- Connection must be re-established if needed

**Analogy - Video Platform Example:**
- Like a YouTube channel and its subscribers
- If channel is deleted, subscribers lose access
- Similarly, deleting peering from one VPC ends connection for both

**Technical Details:**
- VPC peering is bidirectional
- One VPC connects to another via peering connection
- Deletion removes the connection completely
- Each VPC returns to isolated state

**Impact on Applications:**
- Applications relying on cross-VPC communication will fail
- DNS resolution for peered VPCs stops working
- Security group rules referencing peered VPC become ineffective

**Best Practices:**
- Verify no critical traffic before deletion
- Document all peered connections
- Plan for connection recreation if needed

---

## Question 19: Which Statement is NOT True Regarding EC2 Instance Addressing?

### Answer:

**Question Analysis**: A user has launched an EC2 instance. Which statement is NOT true?

**Given Statements:**
1. Private IP addresses are not reachable from the internet → **TRUE**
2. User can communicate using private IP across regions → **FALSE** ← **This statement is NOT true**
3. Private and Public IP addresses are mapped using NAT → **TRUE**
4. Private IP address assigned using DHCP → **TRUE**

**Explanation of False Statement:**
- Private IPs cannot be used for cross-region communication
- Private IPs are only routable within the VPC
- Even within the same region, private IPs are not directly accessible
- Public IP required for any external communication

**Key Concepts:**
- **Public IP**: Internet-facing, accessible globally
- **Private IP**: Internal communication only, requires NAT for external access
- **NAT Mapping**: AWS automatically handles public-to-private IP translation
- **DHCP Assignment**: Dynamic IP assignment within subnet CIDR range

**Security Implications:**
- Private IPs enhance security by hiding internal infrastructure
- Direct internet access only through public IPs
- NAT provides additional security layer

---

## Question 20: What Connection Issues Can Occur When Connecting to EC2 Instances?

### Answer:

**Common Connection Issues and Causes:**

**1. Connection Timeout**
- **Cause**: Security group doesn't allow SSH traffic (port 22)
- **Solution**: Add inbound rule allowing SSH from your IP

**2. Server Refused Our Key**
- **Cause**: Using incorrect or corrupted private key
- **Solution**: Verify correct key pair is being used
- **Note**: Key must match the one associated with instance

**3. No Supported Authentication Method Available**
- **Cause**: Key format issues or permission problems
- **Solution**:
  - Ensure `.pem` file has correct permissions (chmod 400)
  - Convert `.pem` to `.ppk` for PuTTY users
  - Verify key file is not corrupted

**Prevention and Best Practices:**
- Always download and securely store private keys
- Configure security groups before launching instances
- Test connectivity immediately after instance launch
- Document key pairs and their associated instances

**Tools for Connection:**
- Linux/Mac: SSH client with `.pem` key
- Windows: PuTTY with `.ppk` key format
- AWS Systems Manager Session Manager (alternative)
- EC2 Instance Connect (browser-based)

---

## Summary Table

| Q# | Topic | Key Points |
|----|-------|------------|
| 11 | Cloud Service Models | IaaS, PaaS, SaaS with clear management boundaries |
| 12 | Regions & AZs | Physical isolation, fault tolerance, VPC spanning |
| 13 | AMI | Pre-configured templates, multi-OS support |
| 14 | Stop vs Terminate | Data persistence vs permanent deletion |
| 15 | Load Balancers | ALB (L7), NLB (L4), Classic LB comparison |
| 16 | AMI Sharing | Reusability with security considerations |
| 17 | AZ Selection | Subnet-based placement at launch time |
| 18 | VPC Peering | Bidirectional termination on deletion |
| 19 | Instance Addressing | Private IPs not cross-region accessible |
| 20 | Connection Issues | Security groups, key problems, authentication |

---

*Study Guide Generated: AWS EC2 Interview Preparation - Part 2*
*Total Questions Covered: 10 (Questions 11-20)*

</details>