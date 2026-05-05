## Section 3: Elastic Compute Cloud (EC2)

<details open>
<summary><b>Section 3: Elastic Compute Cloud (EC2) (CL-KK-Terminal)</b></summary>

### Table of Contents
- [3.1 Introduction - Elastic Compute Cloud (EC2)](#31-introduction---elastic-compute-cloud-ec2)
- [3.10 Elastic IP](#310-elastic-ip)
- [3.11 Security Group Part 1](#311-security-group-part-1)
- [3.12 Security Group Part 2](#312-security-group-part-2)
- [3.13 Security Group Part 3](#313-security-group-part-3)
- [3.14 Security Group (Hands-On)](#314-security-group-hands-on)
- [3.15 User Data Script](#315-user-data-script)
- [3.16 Termination Protection](#316-termination-protection)
- [3.17 EC2 Instance Placement Group](#317-ec2-instance-placement-group)
- [3.18 AWS Tenancy](#318-aws-tenancy)
- [3.19 EC2 Instance Purchase Options Part 1](#319-ec2-instance-purchase-options-part-1)
- [3.20 EC2 Instance Purchase Options Part 2](#320-ec2-instance-purchase-options-part-2)
- [3.21 EC2 Instance Purchase Options Part 3](#321-ec2-instance-purchase-options-part-3)
- [3.22 AWS Pricing Calculator](#322-aws-pricing-calculator)
- [3.23 AWS Command Line Interface (CLI) (Hands-On)](#323-aws-command-line-interface-cli-hands-on)
- [Summary](#summary)

### 3.1 Introduction - Elastic Compute Cloud (EC2)
#### Overview
EC2 is a foundational AWS service that provides elastic compute resources in the cloud, allowing users to create and manage virtual machines without worrying about underlying hardware infrastructure. It abstracts the complexity of virtualization by handling hypervisors, CPUs, memory, and networking, enabling beginners to focus on deploying applications. This module introduces the concept of virtual machines, virtualization techniques like VMware and Hyper-V, and how EC2 simplifies VM management compared to physical servers.

#### Key Concepts/Deep Dive
- **Physical vs. Virtual Machines**: Physical servers require direct management of hardware, operating systems, and scaling limitations. Virtualization introduces hypervisors (e.g., ESXi, Hyper-V) to run multiple VMs on one host, sharing resources securely without interference.
- **VM Components**: 
  - **Host**: The physical server managed by AWS.
  - **Guest**: Virtual machines created on the host.
- **EC2 Platform Benefits**:
  - Eliminates need for virtualization knowledge.
  - Scales from small to large deployments.
  - Supports rack servers (blade technology) for high-density environments.
- **Rack Server Types**:
  - Towers for small setups.
  - Racks for scalability.
  - Blades for massive deployments (16-core CPUs, 128GB RAM).
- **Virtualization Evolution**: From IBM mainframe concepts to enterprise adoption, enabling resource sharing without dedicated hardware.

> [!IMPORTANT]
> EC2 manages infrastructure, allowing focus on applications and scaling.

### 3.10 Elastic IP
#### Overview
Elastic IPs provide static public IP addresses for EC2 instances, ensuring consistent addressing despite stop/start cycles, unlike dynamic public IPs that change. This addresses the challenge of static addressing for internet-facing services without the сразу associated costs. The module demonstrates practical allocation, association, and release of elastic IPs, highlighting chargeable aspects for AWS resource utilization.

#### Key Concepts/Deep Dive
- **Public IP vs. Elastic IP**:
  - Public IP: Automatically assigned, released when instances stop (available for other customers).
  - Elastic IP: Reserved static public IP, persists across stops, charged for non-usage.
- **Use Cases**: Hosted websites, databases requiring fixed endpoints; avoid DNS propagation issues.
- **Charging Logic**: AWS recoups costs for reserved IPs when instances are unused.
- **Practical Steps**:
  - Allocate elastic IP in the region.
  - Associate with running EC2 instance.
  - Observe persistence through stop/start cycles.
  - Dissociate and release when no longer needed to avoid charges.
- **Designing Insights**: Elastic IPs ensure seamless connectivity for production workloads.

> [!NOTE]
> Allocate and release elastic IPs appropriately to manage costs.

- **Lab Demo**:
  - Allocate elastic IP in console.
  - Associate with EC2 instance.
  - Stop/start instance; verify IP constancy.
  - Dissociate and release elastic IP.

### 3.11 Security Group Part 1
#### Overview
Security groups filter network traffic for EC2 instances, acting as virtual firewalls to control inbound and outbound connections. They integrate with networking fundamentals like TCP/UDP ports and protocols, ensuring servers like web or database services receive only intended traffic. This module differentiates server roles, port assignments, and the need for traffic isolation to prevent overload from unwanted requests.

#### Key Concepts/Deep Dive
- **Server Types and Ports**:
  - Web Servers: HTTP (80), HTTPS (443).
  - Email: SMTP (25), POP3 (110).
  - File Sharing: SMB (445), NFS (2049).
  - Databases: MySQL (3306), PostgreSQL (5432).
- **Port Ranges**:
  - Well-known (0-1023): Standardized (e.g., SSH 22, RDP 3389).
  - Registered (1024-49151): Assigned to vendors.
  - Dynamic/Private (49152-65535): Randomly assigned.
- **Communication Flow**:
  - Source IP/Port to Destination IP/Port.
  - Servers process requests on assigned ports (e.g., web traffic on 80).
- **Security Group Necessity**: Prevents denial-of-service from miscategorized traffic; allows targeted access.

> [!WARNING]
> Unfiltered traffic risks server overload and unauthorized access.

### 3.12 Security Group Part 2
#### Overview
Security groups operate at the instance level, attached to network interfaces, and enforce stateful filtering for inbound/outbound rules. Default configurations include no inbound rules and full outbound access. This module explores rule creation, attachment to multiple instances, and process flows, contrasting inbound (strict) and outbound (permissive) behaviors for comprehensive EC2 protection.

#### Key Concepts/Deep Dive
- **Attachment and Rules**:
  - Compulsory for EC2 instances; supports multiple groups per instance.
  - Inbound: Explicit allow rules; denies unlisted traffic.
  - Outbound: Default all-traffic allow; modifiable.
- **Rule Additions**:
  - Supports multiple rules (e.g., SSH 22 + HTTP 80).
  - Sources: IP ranges, security group references.
- **Default Security Group**: All traffic full-duplex allow in default VPC.
  - Non-deletable; apply conservatively.
- **Practical Defaults**:
  - Windows: RDP (3389) from anywhere.
  - Linux: SSH (22) from anywhere.
- **Flow Example**:
  - HTTP request: Verify inbound rule → Allow → Process.
  - Unlisted traffic: Dropped at security group.

> [!IMPORTANT]
> Security groups are instance-bound; outbound defaults to permissive for internet access.

### 3.13 Security Group Part 3
#### Overview
Security groups maintain session state, enabling dynamic responses to initiated connections without explicit outbound rules. This stateful behavior contrasts stateless firewalls, allowing reply traffic for established sessions. The module illustrates client-server interactions, highlighting how stateful rules simplify configuration compared to manual addressing of reverse flows.

#### Key Concepts/Deep Dive
- **Stateful vs. Stateless**:
  - **Stateful**: Tracks connections; allows replies.
  - **Stateless**: Requires explicit inbound/outbound rules for each direction.
- **Illustration**:
  - Client requests HTTP (outbound implicit allow → inbound allows reply).
  - Uninitiated inbound traffic (e.g., from server) requires inbound rules if not replying.
- **Rules of Thumb**:
  - Outbound defaults cover most needs.
  - Inbound: Strict for security.
- **Practical Implication**: Reduces rule complexity; essential for AWS networking.

> [!NOTE]
> Stateful design automates bidirectional flows for initiated connections.

### 3.14 Security Group (Hands-On)
#### Overview
Security groups are managed via console or CLI, with creation, rule editing, and attachment processes. Hands-on practice covers configuring rules for services like HTTP and ICMP, verifying stateful behavior through ping and traffic tests. Labs demonstrate sourcing from IPs or other security groups for inter-instance communication, emphasizing practical implementation.

#### Key Concepts/Deep Dive
- **Creation Methods**: Console or CLI; defaults to no inbound, all outbound.
- **Source Options**:
  - IP ranges (e.g., 0.0.0.0/0 for anywhere).
  - Security groups for cross-instance access.
- **Stateful Verification**:
  - Outbound requests (e.g., ping) return via existing state.
  - Inbound explicit rules required for unsolicited traffic.
- **Advanced Configurations**:
  - Reference security groups for dynamic membership.
  - Inter-VPC or cross-account access via group IDs.
- **Best Practices**: Minimize broad rules; use group-based sourcing.

> [!WARNING]
> Broad sources (e.g., 0.0.0.0/0) increase exposure; refine for production.

- **Lab Demo**:
  - Create security group via console or CLI.
  - Add HTTP (80) and ICMP rules.
  - Associate with EC2 instance.
  - Test web access and ping from instance.
  - Verify stateful returns without inbound ICMP rules.

### 3.15 User Data Script
#### Overview
User data scripts automate post-launch configurations, executing shell or PowerShell code for services like Apache installation. This enables consistent provisioning for scaling scenarios, bypassing manual setups. Labs cover manual vs. automated deployments, highlighting benefits for Auto Scaling groups where rapid, identical instance creation is critical.

#### Key Concepts/Deep Dive
- **Automation Benefits**:
  - Pre-installs apps, configs users.
  - Supports batch processing.
  - Eliminates repetitive tasks.
- **Script Execution**: Runs as root/system; executes once at launch.
- **Use Cases**: Standardized server builds, scaling without delays.
- **Formats**: Shell for Linux, PowerShell for Windows.
- **Integration**: Copied into console advanced settings.

> [!TIP]
> Use for immutable infrastructure; script failures halt launch.

- **Lab Demo**:
  - Manual: SSH into instance, install httpd via CLI.
  - Automated: Paste startup script in user data.
  - Launch new instance; verify auto-configuration.

### 3.16 Termination Protection
#### Overview
Termination protection prevents accidental EC2 deletions, adding a safety layer for critical instances. Enabled during launch or post-creation, it requires explicit disablement before termination. Labs demonstrate enablement workflows, stopping protection nuances, and override processes for controlled management.

#### Key Concepts/Deep Dive
- **Protection Types**:
  - **Termination**: Blocks deletes.
  - **Stop**: Prevents shutdowns (EBS-only).
- **Enablement**: Via console instance settings; mandatory disable for removal.
- **Use Cases**: Production servers, databases.
- **Instance States**: Applies to running/stopped; bypassed via API disable.

> [!NOTE]
> Essential for high-stakes environments; complements backups.

- **Lab Demo**:
  - Enable during launch via advanced details.
  - Attempt termination: Blocks.
  - Disable protection: Allows termination.

### 3.17 EC2 Instance Placement Group
#### Overview
Placement groups influence instance placement on underlying hardware for performance or resilience. Cluster mode optimizes for low-latency networking; spread enhances availability; partition balances both. Labs focus on theoretical applications, as practical effects dep(vertical)end on monitoring tools.

#### Key Concepts/Deep Dive
- **Types**:
  - **Cluster**: Racks for high-speed (e.g., HPC, big data).
  - **Spread**: Separate racks for fault tolerance (up to 7 per AZ).
  - **Partition**: Logical groups sharing hardware; scalable resilience.
- **Constraints**: Single AZ; no conversions/merge.
- **Advanced Exclusion**: Dedicated hosts; bare metal.
- **Mermaid Flow for Cluster**:
  ```mermaid
  graph LR
      A[User Request] --> B[Load Balancer]
      B --> C[Placement Group: Cluster]
      C --> D{EC2 Instances in Rack}
      D --> E[High-Speed Communication]
  ```

> [!WARNING]
> Cluster high-performance but single-point failure; spread resilient but latency-prone.

### 3.18 AWS Tenancy
#### Overview
Tenancy options control hardware sharing: shared (default, cost-effective) for public cloud economics; dedicated for isolation (instances/hosts). Dedicated hosts offer full hardware control, including license mobility. Labs emphasize console selection, balancing security and cost.

#### Key Concepts/Deep Dive
- **Options**:
  - **Shared**: Multi-tenant; lowest cost.
  - **Dedicated Instance**: Exclusive host per account.
  - **Dedicated Host**: Full control; visibility/allocated instances.
- **Pricing**: Shared free; dedicated charged.
- **Use Cases**: Compliance requiring isolation or license-to-host affinity.

> [!NOTE]
> Dedicated for regulated workloads; host for extreme control.

- **Lab Demo**:
  - Launch with dedicated tenancy.
  - Allocate dedicated host from console.
  - Associate instances to host.

### 3.19 EC2 Instance Purchase Options Part 1
#### Overview
EC2 offers On-Demand for flexible pay-as-you-go, Reserved for committed savings (standard/convertible), and Spot for bidding-based discounts. Convertible Reserved allows hardware changes; spotting suits unpredictable loads. Savings up to 90% via Spot, 75% via Reserved.

#### Key Concepts/Deep Dive
- **On-Demand**: Base pricing; no commitments.
- **Spot**: Bid below On-Demand; interrupts for capacity.
- **Reserved**: 1-3 year commitment; upfront/all/no upfront.
  - Standard: Fixed term.
  - Convertible: Flexibility in changes.
- **Scheduled Reserved**: Partial-day commitments.

> [!TIP]
> Reserved for predictable; Spot for fault-tolerant, variable workloads.

### 3.20 EC2 Instance Purchase Options Part 2
#### Overview
Purchase options compare on flexibility, interruptions, sizing changes, and application evolution. Savings Plans offer maximal adaptability, including cross-service commitments. Spot requires automation for reliability; Reserved suits stable workloads.

#### Key Concepts/Deep Dive
- **Comparisons**:
  - On-Demand: Full changeability.
  - Spot: 90% savings; interruptions possible.
  - Reserved/Savings: 72%+ savings; some interchangeability.
- **Savings Plans**: Hardware, OS, region, tenancy changes; compute spans services.
- **Migration Flexibility**: Convertible > Savings > Scheduled > Spot.

> [!IMPORTANT]
> Align options to workload predictability; test Spot reliability.

### 3.21 EC2 Instance Purchase Options Part 3
#### Overview
Practical selection via console: On-Demand default, Spot via custom bidding, Reserved/Scheduled via dedicated menus, Savings Plans via purchase flows. Pricing Calculator estimates costs across families/regions.

#### Key Concepts/Deep Dive
- **Activation**:
  - Spot: Set max price, duration.
  - Reserved: Specify terms, zones.
  - Compute Savings: Hourly commitment.
- **CLI/Console`: Advanced options for bidding/tenancy.
- **Migrations**: Track cross-options via console.

- **Lab Demo**:
  - Configure Spot: Custom bid/console.
  - Purchase Reserved: Select convertible.
  - Allocate Savings: Commit hourly rates.

### 3.22 AWS Pricing Calculator
#### Overview
AWS Pricing Calculator provides free estimates for services like EC2, factoring regions, OS, types, and purchase models. Generates shareable reports for budgeting comparisons.

#### Key Concepts/Deep Dive
- **Features**: Multi-service configs; detailed breakdowns.
- **Inputs**: Instances, storage; outputs costs per term.
- **Use Cases**: Pre-planning migrations; cost optimizations.

> [!NOTE]
> Essential for financial planning; real-time updates.

- **Lab Demo**: Estimate T2.micro On-Demand vs. Reserved costing.

```diff
+ On-Demand Flexible pay-as-you-go for experiments.
- Spot Interruptions require resilient apps.
! Reserved High savings for consistent loads.
```

### 3.23 AWS Command Line Interface (CLI) (Hands-On)
#### Overview
AWS CLI enables scalable, scriptable management of EC2 resources, surpassing console limitations. Installation, configuration, and commands for creation, termination demonstrate efficiency for automation.

#### Key Concepts/Deep Dive
- **Setup**: Download MSI; configure keys via `aws configure`.
- **Commands**: `aws ec2 run-instances`, `describe-instances`.
- **Benefits**: Batch operations, version control.

> [!WARNING]
> Secure keys; test commands in dev environments.

- **Lab Demo**:
  - Install/configure CLI.
  - Create SG/launch EC2 via `aws ec2`.
  - Terminate/stop via commands.

### Summary
#### Key Takeaways
```diff
+ EC2 abstracts virtualization for VM management.
- Elastic IPs ensure static addressing with costs.
! Security groups provide stateful traffic control.
+ User data scripts enable automated deployments.
- Placement groups balance performance/resilience.
! Purchase options (Reserved/Spot) optimize costs.
```

#### Quick Reference
- **Ports**: SSH 22, HTTP 80, RDP 3389.
- **Tenancy**: Shared (default), Dedicated (isolated).
- **CLI Basics**: `aws ec2 run-instances --image-id <ami>`.
- **Mermaid for Placement**:
  ```mermaid
  flowchart TD
      A[Cluster] --> B[High Performance]
      C[Spread] --> D[High Availability]
      E[Partition] --> F[Balanced Approach]
  ```

#### Expert Insight
**Real-world Application**: Use EC2 for scalable web apps; pair with ELBs for high availability and Spot instances for cost efficiencies.  
**Expert Path**: Master Auto Scaling + EC2 placement for advanced clustering; experiment with Nitro-based instances for optimizations.  
**Common Pitfalls**: Over-allocating public IPs without need; forgetting Spot termination risks; neglecting security group statefulness.  
**Lesser-Known Facts**: Nitro instances bypass hypervisors for direct hardware access; ARM processors reduce costs for compatible workloads; placement groups are AZ-specific.

</details>
