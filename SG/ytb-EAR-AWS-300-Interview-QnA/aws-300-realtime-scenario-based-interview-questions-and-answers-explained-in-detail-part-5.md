<details open>
<summary><b>AWS 300+ Realtime Scenario Based Interview Questions and Answers - Part 5 (KK-CS45-script-v2-Interview)</b></summary>

# AWS 300+ Realtime Scenario Based Interview Questions and Answers - Part 5

## Table of Contents
- [Question 31: Key Pair Usage](#question-31-key-pair-usage)
- [Question 32: Elastic IP Limits](#question-32-elastic-ip-limits)
- [Question 33: Pinging Default Gateway](#question-33-pinging-default-gateway)
- [Question 34: VPC Across Availability Zones](#question-34-vpc-across-availability-zones)
- [Question 35: Monitoring VPC Network Traffic](#question-35-monitoring-vpc-network-traffic)

---

## Question 31: Key Pair Usage

**Q: What is a key pair and what are its uses?**

### Answer

A key pair in AWS consists of a public key and a private key used for secure SSH access to EC2 instances.

#### Key Components:
- **Public Key**: Stored on the EC2 instance
- **Private Key**: Held by the user for authentication

#### Key Uses:

1. **Secure SSH Access**
   - Primary method for connecting to Linux EC2 instances via SSH
   - Ensures only authorized users with the private key can access instances

2. **Secure Communication**
   - Data transmitted between user machine and EC2 instance is encrypted
   - SSH protocol provides encrypted communication channels

3. **Automation**
   - Used in automation scripts for unattended SSH login
   - Enables secure communication between instances without passwords
   - Essential for infrastructure automation tools

4. **Instance Authentication**
   - Required when launching new EC2 instances
   - AWS asks for existing or new key pair creation
   - Ensures only users with private keys can access instances

5. **CloudFormation Integration**
   - Used in infrastructure-as-code automation
   - Automatically configures secure access when provisioning EC2 resources

#### Implementation Example:
```
# Key pair generation process:
1. Create key pair with name (e.g., "demo")
2. Select algorithm (RSA for encryption)
3. Download .pem file (Linux) or .ppk file (Windows)
4. Import private key into SSH client (e.g., Termius)
5. Connect using ec2-user username and private key
```

**Note**: The default global username for Amazon Machine Images (AMI) is `ec2-user`. Other Linux distributions may use different usernames.

---

## Question 32: Elastic IP Limits

**Q: How many Elastic IPs can you create?**

### Answer

The number of Elastic IPs you can create depends on your AWS subscription model and account type.

#### Default Limits:
- **5 Elastic IPs per AWS account per region** (default soft limit)
- Limits may vary based on subscription type and account status

#### Limit Management:
- **Soft limits** can be increased by submitting a request to AWS Support
- Increase requests are evaluated based on account history and use case
- No hard upper limit exists, but increases require justification

#### Cost Considerations:
- Elastic IPs incur charges when not associated with running instances
- Consider cost implications before requesting limit increases
- Unused Elastic IPs in your account will be billed hourly

**Interview Tip**: Always mention that the default is 5 per account per region, and clarify that limits can be increased via AWS Support when needed.

---

## Question 33: Pinging Default Gateway

**Q: Can you ping the router or default gateway that connects your subnet?**

### Answer

**No, you cannot ping the router or default gateway that connects your subnet.**

#### What You CAN Ping:
- **EC2 instances within the same VPC** (provided security groups and NACLs allow ICMP traffic)
- Other instances connected through proper route table configurations

#### Network Architecture Context:
```
VPC (Virtual Private Cloud)
├── Subnet 01 (AZ-1) ─── EC2 Instance (can be pinged)
├── Subnet 02 (AZ-2) ─── EC2 Instance (can be pinged)
└── Subnet 03 (AZ-3) ─── EC2 Instance (can be pinged)
         │
    Route Table
         │
  Internet Gateway (public access)
```

#### Requirements for Instance Connectivity:
1. **Route Table Configuration**: Proper routing rules must allow traffic
2. **Security Groups**: Must permit ICMP (ping) traffic
3. **Network ACLs**: Should allow inbound/outbound ICMP traffic
4. **VPC Internal Communication**: Works within the same VPC/data center

#### What This Means:
- You can ping instances within your VPC
- The underlying AWS network infrastructure (routers/gateways) is not directly accessible for ping operations
- This is a security measure to protect AWS's network infrastructure

---

## Question 34: VPC Across Availability Zones

**Q: Can you make a VPC available in multiple availability zones?**

### Answer

**Yes, a VPC can span multiple availability zones within a single region.**

#### VPC and Subnet Relationship:

**VPC Level**:
- A VPC can span multiple Availability Zones (AZs) within one region
- Example: VPC in `us-east-1` can include subnets in:
  - `us-east-1a`
  - `us-east-1b`
  - `us-east-1c`

**Subnet Level**:
- **Individual subnets are restricted to a single AZ**
- Each subnet must be created in one specific AZ
- You cannot create a subnet that spans multiple AZs

#### Practical Example:
```
Region: ap-south-1 (Mumbai)
├── VPC: Production-VPC
│   ├── Subnet-01 (ap-south-1a)
│   ├── Subnet-02 (ap-south-1b)
│   └── Subnet-03 (ap-south-1c)
```

#### Minimum AZ Coverage:
- AWS regions typically have a minimum of 3 AZs
- You can create subnets across all available AZs in your region
- This provides high availability and fault tolerance

**Key Distinction**: VPC spans multiple AZs, but subnets are AZ-specific.

---

## Question 35: Monitoring VPC Network Traffic

**Q: How will you monitor the network traffic in a VPC?**

### Answer

Network traffic monitoring in a VPC requires a combination of AWS services working together.

#### Primary Service: VPC Flow Logs
- **Captures IP traffic information** for network interfaces in your VPC
- Provides packet-level details and connection monitoring
- Can monitor at network level (not application level)

#### Required AWS Services Integration:

1. **VPC Flow Logs**
   - Enable flow logs on VPC, subnet, or network interface level
   - Configure aggregation intervals (1-minute, 5-minute, or 10-minute)
   - Define destination for log delivery

2. **CloudWatch Integration**
   - Flow logs are sent to CloudWatch Logs for analysis
   - Configure CloudWatch to receive and store flow log data
   - Create CloudWatch dashboards for visualization

3. **IAM Role and Policy Configuration**
   - Create IAM role with appropriate permissions
   - Attach policies allowing VPC to write logs to CloudWatch
   - Ensure proper cross-service permissions

#### Implementation Steps:
```
1. Create IAM Role with CloudWatch Logs permissions
2. Enable VPC Flow Logs targeting CloudWatch Logs
3. Configure destination log group in CloudWatch
4. Set up CloudWatch metrics and alarms
5. Create dashboards for traffic visualization
```

#### Additional Monitoring Considerations:
- **Types of monitoring**: Network-level vs application-level
- **Log destinations**: CloudWatch Logs, S3, or Kinesis Data Firehose
- **Cost implications**: Consider log storage and processing costs
- **Security**: Ensure proper IAM permissions and access controls

#### Interview Follow-up Points:
- Be prepared to explain IAM role creation for log delivery
- Understand flow log format and fields
- Know how to filter and analyze flow log data
- Understand integration with other monitoring tools

---

</details>