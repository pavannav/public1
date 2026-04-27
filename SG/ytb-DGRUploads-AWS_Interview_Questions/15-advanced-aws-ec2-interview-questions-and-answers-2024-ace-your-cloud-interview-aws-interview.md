# 15 Advanced AWS EC2 Interview Questions and Answers (2024)

## 1. What is EC2 Autoscaling and How Does It Work?

**Answer:** EC2 Auto Scaling helps you ensure that you have the correct number of EC2 instances available to handle the load for your application. It can automatically increase the number of instances (scale out) when demand increases, and decrease the number (scale in) when demand decreases, based on scaling policies and CloudWatch metrics.

**Key Components:**
- **Auto Scaling Groups (ASG)**: Groups of EC2 instances that can grow or shrink automatically
- **Launch Templates/Configurations**: Define how new instances are configured
- **Scaling Policies**: Rules for when to scale (target tracking, step scaling, simple scaling)

**Types of Scaling Policies:**
- **Target Tracking**: Maintains a target metric (e.g., CPU utilization at 50%)
- **Step Scaling**: Scales by specific amounts based on alarm triggers
- **Simple Scaling**: Direct scaling actions without alarms
- **Scheduled Scaling**: Time-based scaling for predictable patterns

**How It Works:**
1. Set up an Auto Scaling Group with min/max instance limits
2. Define scaling policies based on CloudWatch metrics
3. When metrics exceed thresholds, Auto Scaling launches additional instances
4. Instances are automatically configured using launch templates
5. Load balancer distributes traffic to all instances

**Benefits:**
- **Availability**: Ensures optimal instance count for current demand
- **Cost Optimization**: Only pay for resources you need
- **Fault Tolerance**: Automatically replaces unhealthy instances

## 2. What is an EC2 Placement Group?

**Answer:** EC2 placement groups help control where instances are placed on AWS infrastructure within an Availability Zone. They determine whether instances are placed close together for low latency, far apart for fault tolerance, or in logical groupings.

**Types of Placement Groups:**

### Cluster Placement Group
- Groups instances in the same AZ for low latency and high throughput
- All instances in a cluster placement group benefit from improved network performance
- **Use Cases**: High-performance computing (HPC), big data workloads, scientific computing
- **Limitation**: Higher risk of simultaneous failure if there's hardware failure

### Spread Placement Group
- Places instances on different underlying hardware (racks)
- Reduces risk of simultaneous failures due to hardware issues
- **Use Cases**: Critical applications requiring high availability
- **Limitations**: Max 7 instances per AZ, cannot span AZs

### Partition Placement Group
- Spreads instances across logical partitions (each with its own set of racks)
- Each partition acts as failure domain
- **Use Cases**: Large distributed systems (Hadoop, Cassandra), when you need more than 7 instances
- **Benefits**: Greater number of instances than spread placement groups

**Important Notes:**
- Placement groups cannot span multiple Availability Zones
- You cannot change placement group of a running instance
- Merging placement groups is not allowed

**Note:** The transcript accurately describes the three types, but could mention that cluster placement groups are best for low latency applications, while spread/partition are better for fault tolerance.

## 3. Troubleshoot an EC2 Instance That Is Not Accessible via SSH

**Answer:** SSH connectivity issues with EC2 instances can be caused by several factors. Here's a systematic troubleshooting approach:

**Step 1: Check Security Groups**
- Verify that SSH (port 22) is allowed in the instance's security group
- Ensure the inbound rule allows traffic from your IP address or CIDR block
- Check that the security group is attached to the correct network interface

**Step 2: Verify Network Configuration**
- Confirm the instance has a public IPv4 address
- Ensure the instance is in a public subnet with an Internet Gateway
- Check route table configurations
- Verify Network ACLs allow inbound SSH traffic

**Step 3: Check Key Pair and Permissions**
- Verify you're using the correct key pair that was associated with the instance
- Ensure the private key file has proper permissions (chmod 400)
- Check that the key file format is correct (.pem not .ppk)

**Step 4: Instance and System Status**
- Check instance status checks in AWS console (system and instance status)
- Verify instance state is "running"
- Look for any AWS-side issues (maintenance, hardware problems)

**Step 5: Host-Level Issues**
- Check system logs for errors
- Verify SSH service is running on the instance
- Ensure sufficient CPU/memory for SSH to respond

**Common Commands:**
```bash
# Test connectivity
telnet instance-ip 22

# Check with timeout
ssh -i key.pem -o ConnectTimeout=10 ec2-user@instance-ip

# Describe security groups
aws ec2 describe-security-groups --group-ids sg-xxxxx
```

## 4. What is the Difference Between Spot Instances, Reserved Instances, and On-Demand Instances?

**Answer:** 

### On-Demand Instances
- Pay per hour/second with no commitment
- Flexible pricing for unpredictable workloads
- Good for development/testing or applications with variable usage
- Highest flexibility, no upfront costs

### Reserved Instances (RI)
- Commitment to use instances for 1 or 3 years
- Significant discounts (up to 75% off On-Demand)
- **Two types:**
  - Standard RI: Highest discount, less flexible
  - Convertible RI: Lower discount but can change instance family
- **Payment options:** All upfront, partial upfront, no upfront

### Spot Instances
- Put unused EC2 capacity up for auction
- Up to 90% discount off On-Demand pricing
- No guarantee - can be terminated with 2-minute warning
- Requires fault-tolerant, stateless applications

**Cost Comparison (approximate):**
- On-Demand: 100% of list price
- Reserved: 20-50% of On-Demand (discount)
- Spot: 10-90% of On-Demand (discount)

**Reliability Ranking:**
- On-Demand: Highest (always available)
- Reserved: High (pay upfront for guaranteed capacity) 
- Spot: Lowest (can be interrupted)

**Best Use Cases:**
- Development/Test: On-Demand
- Production with steady usage: Reserved
- HPC/Batch processing: Spot (fault-tolerant apps)

## 5. How Can You Ensure High Availability for Applications Running on EC2 Instances?

**Answer:** High availability means ensuring your application remains accessible during failures. Here's the EC2-specific approach:

**Multi-AZ Deployment:**
- Launch instances across multiple Availability Zones
- Automatic failover if one AZ becomes unavailable
- Minimum 2 instances in different AZs

**Load Balancing:**
- Use Elastic Load Balancer (ALB/NLB) to distribute traffic
- Health checks automatically remove unhealthy instances
- Provides single point of access

**Auto Scaling:**
- Configure Auto Scaling Groups for automatic scaling
- Maintain minimum instance count
- Handle traffic spikes and failures automatically

**Database Layer:**
- Use RDS Multi-AZ for database high availability
- Read replicas for improved performance and failover
- Aurora Global Database for cross-region protection

**DNS and Traffic Management:**
- Route 53 with health checks and failover routing
- Geo-dns for global distribution
- Weighted routing for gradual changes

**Architecture Pattern:**
```
Internet
    ↓
Route 53 (DNS Health Checks)
    ↓
Application Load Balancer
    ↓
Auto Scaling Group (Multi-AZ)
    ↓
RDS Multi-AZ Database
```

**Additional Best Practices:**
- Implement proper monitoring (CloudWatch)
- Use CloudFormation for infrastructure as code
- Regular backups and testing
- Proper security group and NACL configuration

## 6. What is EC2 Hibernate?

**Answer:** EC2 hibernation saves the current state of your instance memory (RAM) to the root EBS volume and then stops the instance. When you restart the hibernated instance, the contents of RAM are restored, allowing your application to resume from where it left off.

**Key Differences:**

| Feature | Hibernate | Stop Instance | Terminate Instance |
|---------|-----------|---------------|-------------------|
| RAM State | Saved | Lost | Lost |
| EBS Data | Preserved | Preserved | Lost |
| Boot Time | Fast (~minutes) | Normal boot | N/A |
| Charges | EBS storage only | EBS storage only | No charges |

**Requirements:**
- Supported instance types: C3, C4, C5, M3, M4, M5, R3, R4, R5
- EBS-backed root volume only
- Maximum 150GB RAM
- Must be enabled at launch time
- AMI must support hibernation

**Process:**
1. Instance RAM contents encrypted and written to EBS
2. Instance transitions to "stopped" state
3. Upon restart, AWS decrypts and loads RAM contents
4. Application resumes from exact point of hibernation

**Use Cases:**
- Applications requiring long startup times
- Desktop instances
- Development environments
- Time-sensitive processes that can't wait for full boot

**Note:** The maximum RAM size for hibernation has been increased from 150GB to 256GB for newer instance types as of certain AWS updates, though the transcript mentions the older limit.

## 7. What is Enhanced Networking?

**Answer:** Enhanced networking provides higher performance networking capabilities for EC2 instances, including increased bandwidth, higher packet-per-second rates, and lower latency.

**Technologies:**
- **Elastic Network Adapter (ENA)**: Latest generation, provides up to 100 Gbps bandwidth
- **Intel 82599 VF**: Older technology, provides up to 10 Gbps

**Benefits:**
- Higher bandwidth capabilities
- Higher packet-per-second (PPS) performance
- Lower network latency and jitter
- Improved overall network performance

**Supported Instance Types:**
- Most current generation instances (C5, M5, R5, etc.)
- Previous generation instances use Intel VF
- Always check AWS documentation for specific support

**When to Use:**
- High-performance computing applications
- Big data processing (Apache Hadoop, Spark)
- Scientific computing
- Applications requiring high network throughput
- Real-time analytics

**Implementation:**
- Enable during instance launch
- Supported in Linux AMIs (Amazon Linux, Ubuntu, RHEL)
- Requires VNIC driver or ENA module

## 8. What is Elastic Fabric Adapter (EFA)?

**Answer:** Elastic Fabric Adapter (EFA) is a network interface for Amazon EC2 instances that enables low-latency, high-bandwidth networking for applications requiring high-performance inter-instance communication.

**Key Features:**
- Sub-microsecond latency
- Up to 400 Gbps bandwidth
- OS-bypass for direct hardware access
- Optimized for MPI (Message Passing Interface) applications

**Requirements:**
- Specific instance types: C5n, C6gn, C6i, P3dn, etc.
- EFA-enabled AMIs
- Instances must be in same Availability Zone
- Security groups must allow all traffic within the group

**Supported Operating Systems:**
- Amazon Linux 2
- Ubuntu
- RHEL
- CentOS

**Use Cases:**
- Machine learning training at scale
- High-performance computing (HPC)
- Computational fluid dynamics
- Weather forecasting and climate modeling
- Genomic sequencing
- Financial risk modeling

**Difference from Enhanced Networking:**
- Enhanced networking: General high-performance networking
- EFA: Specifically for tightly-coupled HPC applications requiring MPI

**Configuration:**
```bash
# Install EFA software
sudo yum install -y efa-installer

# Enable EFA on instance
efa-configure -y
```

## 9. Can You Resize an EC2 Instance?

**Answer:** Yes, you can change the instance type of a running EC2 instance, subject to certain limitations and processes.

**Supported Changes:**
- Change within same instance family (t2.micro → t2.large)
- Cross-instance family changes (m5.large → c5.large)
- Architecture must be compatible (x86_64 ↔ x86_64, or ARM64 ↔ ARM64)

**Process:**
1. **Stop the instance** (required for most changes)
   ```bash
   aws ec2 stop-instances --instance-ids i-xxxxxxxxxxxxxxxxx
   ```
   
2. **Change instance type**:
   - Go to EC2 Console → Actions → Instance Settings → Change Instance Type
   - Or use CLI:
   ```bash
   aws ec2 modify-instance-attribute \
     --instance-id i-xxxxxxxxxxxxxxxxx \
     --instance-type '{"Value": "m5.large"}'
   ```

3. **Start the instance**
   ```bash
   aws ec2 start-instances --instance-ids i-xxxxxxxxxxxxxxxxx
   ```

**Limitations:**
- Instance must be EBS-backed
- Cannot change from 32-bit to 64-bit architecture
- Must have sufficient limits in the region
- Storage type compatibility (EBS optimization, etc.)

**Cost Considerations:**
- Free to change instance type
- Pay for new instance type on restart
- EBS storage continues to be charged

**Note:** The transcript correctly outlines the basic process but could add more detail about cross-family compatibility and that some instance types may not be directly convertible.

## 10. What Are the Differences Between EBS-Backed and Instance Store-Backed Instances?

**Answer:**

### EBS-Backed Instances
- Root device stored on Elastic Block Store (EBS)
- **Data persistence:** Preserved during stop/termination
- Can be stopped and restarted
- Slightly longer boot time (EBS volume attachment)
- EBS storage continues to be billed when stopped
- Easy backup with EBS snapshots

### Instance Store-Backed Instances
- Root device stored on instance's local SSD
- **Data persistence:** Lost when stopped or terminated
- Cannot be "stopped" (only terminated and relaunched)
- Faster boot time (local storage)
- Only billed for instance running time
- Manual backup required
- Higher I/O performance for temp data

**When to Use Each:**

**EBS-Backed:**
- Production workloads requiring persistence
- Long-running applications
- Need to stop/start instances
- Easy backup and recovery

**Instance Store-Backed:**
- Quick deployments without EBS setup
- Temporary processing workloads
- Maximum I/O performance required
- Can tolerate data loss on failure

**Hybrid Approach:**
- Use EBS-backed instances with additional instance store volumes for temp data

| Feature | EBS-Backed | Instance Store-Backed |
|---------|------------|----------------------|
| Persistence | Yes | No |
| Stop/Start | Yes | No |
| Cost | Higher | Lower |
| Performance | Good | Excellent |
| Use Case | Production | Temporary |

## 11. How Do You Attach Multiple Elastic Network Interfaces (ENIs)?

**Answer:** Elastic Network Interfaces (ENIs) can be attached to EC2 instances to provide additional networking capabilities, including multiple private IP addresses, separate security policies, and network isolation.

**Why Multiple ENIs:**
- **Traffic Separation:** Isolate management traffic from application data
- **High Availability:** Multiple IP addresses for failover
- **Network Appliances:** Router/firewall configurations
- **Multi-IP Applications:** Services requiring multiple IPs

**Process:**

1. **Create Additional ENI**
   ```bash
   aws ec2 create-network-interface \
     --subnet-id subnet-xxxxxxxx \
     --description "Secondary ENI" \
     --groups sg-xxxxx sg-xxxxx
   ```

2. **Attach to Instance**
   ```bash
   aws ec2 attach-network-interface \
     --network-interface-id eni-xxxxxxxxxxx \
     --instance-id i-xxxxxxxxxxxxxxxxx \
     --device-index 1
   ```

3. **Configure OS-level networking**
   - Primary ENI: Automatically configured as eth0
   - Secondary ENIs: Manual configuration required
   - Set IP addresses, routes, and DNS

**Linux Configuration Example:**
```bash
# Enable secondary interface
sudo ip link set dev eth1 up

# Configure IP
sudo ip addr add 10.0.1.10/24 dev eth1

# Add default route if needed
sudo ip route add default via 10.0.1.1 dev eth1 table 1000
```

**Per-Interface Security Groups:**
- Each ENI can have different security groups
- Fine-grained traffic control
- Separate policies for different interfaces

**Important Notes:**
- Instance type limits ENI count (max 15 per instance)
- Must be in same subnet unless routing configured
- Hot attach/detach supported on most instance types

**Use Cases Examples:**
- Web servers: Public web traffic on one ENI, admin traffic on another
- Database servers: Application traffic vs. backup/management traffic
- HA Clusters: Active/passive configurations with multiple IPs

## 12. What Are EC2 Burstable Performance Instances?

**Answer:** Burstable performance instances provide baseline CPU performance with the ability to burst above baseline when needed, using a credit system. These are ideal for workloads that don't need sustained high CPU performance.

**Instance Families:**
- **T2/T3/T3a family** (latest generation)
- T2: Older generation, credits can be exhausted completely
- T3/T3a: Newer, includes "unlimited" bursting capability

**CPU Credit System:**
- **Earn Credits:** When CPU usage below baseline, accumulate credits
- **Spend Credits:** When bursting above baseline, consume credits
- **Credit Balance:** Maximum varies by instance size
- **Launch Credits:** Bonus credits provided on launch

**T3 Unlimited Mode:**
- No credit balance management
- Pay small hourly charge for sustained bursting
- Suitable for unpredictable workloads requiring sustained high CPU

**Baseline vs Burst Performance:**
- t3.micro: Baseline 10% of vCPU (2% of physical core), bursts to 100%
- t3.small: Baseline 20% of vCPU (4% of physical core), bursts to 100%
- Scales proportionally with instance size

**Monitoring:**
- **CPUCreditUsage:** Credits spent per hour
- **CPUCreditBalance:** Available credits
- **CPUSurplusCreditBalance:** Excess credits (T3 only)

**Use Cases:**
- Web servers with variable traffic
- Development and testing environments  
- Microservices and APIs
- Applications requiring occasional performance spikes

## 13. How Do You Monitor and Troubleshoot EC2 Instance Performance?

**Answer:** Monitoring EC2 instances involves using Amazon CloudWatch to collect, monitor, and analyze metrics, logs, and events. Troubleshooting requires systematic investigation of performance bottlenecks.

**Monitoring Setup:**

### Basic Monitoring (Default, Free)
- CPU Utilization, Network In/Out, Disk Read/Write
- Instance status checks (system and instance)
- Auto Scaling group metrics

### Detailed Monitoring (Paid)
- Per-instance metrics every minute vs. 5-minute averages
- Additional metrics when CloudWatch agent installed

### CloudWatch Agent Installation
```bash
# Amazon Linux 2
sudo yum install amazon-cloudwatch-agent

# Ubuntu
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i amazon-cloudwatch-agent.deb

# Configure and start
sudo systemctl enable amazon-cloudwatch-agent
sudo systemctl start amazon-cloudwatch-agent
```

**Key Metrics to Monitor:**
- CPU Utilization (< 70% target)
- Memory Utilization (requires agent)
- Disk I/O and throughput
- Network traffic patterns
- Status checks
- Disk space usage
- SWAP usage

**Log Monitoring:**
- Push system logs to CloudWatch Logs
- Application-specific log groups
- Filter and search capabilities

**VPC Flow Logs:**
- Monitor network traffic patterns
- Identify anomalous traffic
- Troubleshoot connectivity issues

**Troubleshooting Steps:**
1. **Review CloudWatch Metrics** for resource bottlenecks
2. **Check Status Checks** for AWS-side issues
3. **Examine Instance Logs** for errors or warnings  
4. **Verify Auto Scaling** configurations
5. **Monitor Network** using VPC Flow Logs
6. **Check Application** performance (custom metrics)

**Advanced Tools:**
- **AWS X-Ray:** Distributed tracing
- **CloudTrail:** API call auditing  
- **Systems Manager:** Run commands, patch management

## 14. What Happens to the Data on Ephemeral/Instance Store If You Stop or Terminate an Instance?

**Answer:** Data on ephemeral storage (instance store volumes) is lost when the instance is stopped or terminated. This is temporary storage that persists only while the instance is running.

**Key Characteristics:**
- **Storage Type:** Local SSD attached to the host
- **Block Device Names:** `/dev/sd[b-e]` or `/dev/xvd[b-e]`
- **Included Cost:** No additional charge (part of instance cost)
- **Performance:** Very high I/O performance

**Data Behavior Matrix:**

| Action | Instance Store Data | 
|--------|---------------------|
| Reboot Instance | ✅ **Preserved** | 
| Stop Instance | ❌ **Lost** |
| Terminate Instance | ❌ **Lost** |
| Host Hardware Failure | ❌ **Lost** |

**Recovery Options:**
- **None Automatic**: No built-in backup mechanism
- **Manual Scripts**: Copy important temp data to EBS/S3 before stop
- **Instance Lifecycle Hooks**: Trigger backups using Auto Scaling

**Appropriate Use Cases:**
- Application caches and temporary data
- Swap space for OS
- Scratch space for processing
- Buffer files that can be recreated

**Best Practices:**
- Only store truly temporary data
- Cache should be rebuildable
- Use for performance-critical temporary operations
- Implement backup scripts for critical temp data
- Consider EBS volumes for persistent temporary data

**Note:** Always use EBS volumes for data that needs to persist across instance stops or terminations.

## 15. How Can You Encrypt Data on an EC2 Instance?

**Answer:** Encryption in EC2 spans multiple layers: data at rest, data in transit, and during processing. Use AWS native tools and third-party solutions for comprehensive protection.

**Data at Rest Encryption:**

### EBS Volume Encryption
- **AWS Managed Keys:** Enable during volume creation
- **Customer Managed Keys (CMEK):** Use your own KMS keys
- **Default Encryption:** Enable at account level for automatic encryption

### Instance Store Encryption  
- **No Native Encryption:** Instance store cannot be encrypted directly
- **Application-Level:** Use dm-crypt, LUKS, or eCryptfs for encryption
- **File-Level Tools:** OpenSSL, GPG for individual file encryption

### S3 Integration
- Store encrypted data in S3 with SSE-S3, SSE-KMS, or SSE-C

**Data in Transit Encryption:**

### Network Transmission
- **SSL/TLS Certificates:** Use AWS Certificate Manager for applications
- **VPN:** AWS Site-to-Site VPN or Direct Connect for secure connections
- **SSH/RDP:** Encrypted sessions (default for SSH)

### API Communication
- Use HTTPS endpoints for all AWS API calls
- CloudFront distributions with security headers

**Key Management:**

### AWS KMS
- Centralized key management and rotation
- Integration with EBS, S3, RDS
- Generate data keys for envelope encryption

### CloudHSM
- Hardware security modules in AWS Cloud
- FIPS-compliant key management
- Customizable key hierarchies

**Common Encryption Scenarios:**

**Full Disk Encryption (Linux):**
```bash
# Encrypt additional volume
sudo cryptsetup luksFormat /dev/xvdf
sudo cryptsetup luksOpen /dev/xvdf encrypted_volume
sudo mkfs.ext4 /dev/mapper/encrypted_volume
```

**Windows Encryption:**
- BitLocker can be used on Windows instances
- Encrypt volumes and files

**Security Best Practices:**
- Use latest encryption standards (AES-256 minimum)
- Implement key rotation policies
- Least privilege access to encryption keys
- Monitor encryption status with AWS Config
- Regular security assessments

---

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
