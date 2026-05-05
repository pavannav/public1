# Section 13: AWS Global Accelerator

<details open>
<summary><b>Section 13: AWS Global Accelerator (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Section 13.1 AWS Global Accelerator](#section-131-aws-global-accelerator)
- [Section 13.2 Introduction Of AWS Global Accelerator](#section-132-introduction-of-aws-global-accelerator)
- [Section 13.3 Key Features Of AWS Global Accelerator](#section-133-key-features-of-aws-global-accelerator)
- [Section 13.4 AWS Global Accelerator - Multi-Region EC2 Traffic Routing (Hads-On)](#section-134-aws-global-accelerator---multi-region-ec2-traffic-routing-hads-on)
- [Section 13.5 AWS Global Accelerator - Super Lab Introduction](#section-135-aws-global-accelerator---super-lab-introduction)
- [Section 13.6 AWS Global Accelerator- Super Lab Part 1](#section-136-aws-global-accelerator--super-lab-part-1)
- [Section 13.7 AWS Global Accelerator- Super Lab Part 2](#section-137-aws-global-accelerator--super-lab-part-2)
- [Section 13.8 AWS Global Accelerator- Super Lab Part 3](#section-138-aws-global-accelerator--super-lab-part-3)
- [Summary](#summary)

## Section 13.1 AWS Global Accelerator

### Overview
This introductory video outlines the syllabus for the AWS Global Accelerator training section, explaining the sequence of topics and why Global Accelerator is covered after CloudFront, despite potential viewer requests for other services. The instructor emphasizes a structured learning approach to ensure foundational understanding before moving to security and other advanced topics.

### Key Concepts/Deep Dive
- **Topic Sequencing Rationale**: The instructor explains that AWS services are covered in a logical progression:
  - Infrastructure setup first (EC2, VPC, S3, CloudFront, Global Accelerator)
  - Then security-related topics for each service
  - Followed by migration topics
  
  This approach ensures students understand service fundamentals before diving into security configurations or migrations.

- **Why Global Accelerator After CloudFront**: Global Accelerator is positioned as an extension of CDN concepts, focusing on multi-region traffic routing rather than content delivery caching.

- **Training Schedule**: The section covers:
  1. Introduction to AWS Global Accelerator
  2. Key features and use cases
  3. Comparison with CloudFront and Route53
  4. Real-world application scenarios
  5. Security considerations and cost factors
  6. Lab demonstrations

### Lab Demos
Two comprehensive labs are planned:
- **Lab 1**: Basic setup focusing on fundamental concepts
- **Lab 2**: Advanced real-world implementation covering VPC, load balancers, and Global Accelerator integration

### Code/Config Blocks
No code or configuration examples in this introductory video - focuses on syllabus overview.

### Tables
No comparison tables presented.

### Diagrams
No diagrams shown in this video, though the instructor mentions roadmaps and topic flowcharts for reference.

## Section 13.2 Introduction Of AWS Global Accelerator

### Overview
*Note: No transcript available or could not be accessed for this section. This is the core introduction video for AWS Global Accelerator concepts.*

### Key Concepts/Deep Dive
*Content not available from transcript - this section would typically cover:*
- What Global Accelerator is and its role in AWS networking
- How it differs from traditional load balancers and CDNs
- Basic architecture and benefits

### Lab Demos
*No lab content in transcript.*

### Code/Config Blocks
````
# Placeholder for typical Global Accelerator setup commands
aws globalaccelerator create-accelerator --name my-accelerator --ip-addresses
aws globalaccelerator create-listener --accelerator-arn arn:aws:globalaccelerator::123456789012:accelerator/12345678-1234-1234-1234-123456789012 --port-ranges FromPort=80,ToPort=80 --protocol TCP
````

### Tables

| Component | Purpose |
|-----------|---------|
| Accelerator | Main resource container |
| Listener | Protocol and port configuration |
| Endpoint Group | Regional traffic distribution |
| Endpoint | Target resources (ALBs, NLBs, EC2, etc.) |

## Section 13.3 Key Features Of AWS Global Accelerator

### Overview
*Note: No transcript available or could not be accessed for this section. This would cover the main features and capabilities of AWS Global Accelerator.*

### Key Concepts/Deep Dive
*Content not available from transcript - expected content includes:*

- **Traffic Routing Features**:
  - Static IP addresses (not tied to AWS infrastructure)
  - TCP/UDP traffic routing
  - Geographic-based routing
  - Latency-based routing

- **Architecture Features**:
  - Global service (no regional constraints)
  - Anycast routing capabilities
  - Integration with other AWS services

- **Benefits**:
  - Improved application performance
  - Reduced latency
  - Enhanced availability
  - Simplified multi-region architectures

### Lab Demos
*No lab content in transcript.*

### Code/Config Blocks
```bash
# Enable Global Accelerator with health checking
aws globalaccelerator update-accelerator --accelerator-arn arn:aws:globalaccelerator::account:accelerator/id --enabled

# Add endpoint group with traffic dial
aws globalaccelerator create-endpoint-group \
  --listener-arn arn:aws:globalaccelerator::account:accelerator/id/listener/id \
  --endpoint-group-region us-east-1 \
  --traffic-dial-percentage 100 \
  --endpoint-configurations Type=ALB,EndpointId=arn:aws:elasticloadbalancing:region:account:loadbalancer/app/name/id
```

### Tables

| Feature | CloudFront | Route53 | Global Accelerator |
|---------|------------|---------|-------------------|
| Primary Purpose | Content delivery | DNS routing | Network traffic routing |
| Geographic Routing | Yes | Limited | Yes |
| Latency Optimization | Yes | Yes | Yes |
| Static IPs | No | No | Yes |
| Protocol Support | HTTP/HTTPS | DNS | TCP/UDP |

## Section 13.4 AWS Global Accelerator - Multi-Region EC2 Traffic Routing (Hads-On)

### Overview
*Note: No transcript available or could not be accessed for this section. This was intended as a hands-on lab for Multi-Region EC2 traffic routing.*

### Key Concepts/Deep Dive
*Content not available from transcript - expected hands-on content would include:*

- Setting up EC2 instances across multiple regions
- Creating Global Accelerator resources
- Configuring routing policies
- Testing traffic distribution

### Lab Demos
*Hands-on steps would typically include:*
1. Launch EC2 instances in two regions
2. Create Global Accelerator
3. Configure listeners and endpoint groups
4. Add EC2 endpoints
5. Test routing from different global locations

### Code/Config Blocks
```yaml
# CloudFormation template for Multi-Region EC2 with Global Accelerator
Resources:
  GlobalAccelerator:
    Type: AWS::GlobalAccelerator::Accelerator
    Properties:
      Name: !Sub "${AWS::StackName}-accelerator"
      IpAddresses:
        - 1.2.3.4  # Static IP
      Enabled: true
  
  Listener:
    Type: AWS::GlobalAccelerator::Listener
    Properties:
      AcceleratorArn: !Ref GlobalAccelerator
      Protocol: TCP
      PortRanges:
        - FromPort: 80
          ToPort: 80
```

### Tables
No comparison tables in transcript.

## Section 13.5 AWS Global Accelerator - Super Lab Introduction

### Overview
This video introduces the comprehensive "Super Lab" for AWS Global Accelerator, featuring a multi-region web acceleration setup with high availability. The lab demonstrates practical implementation of Global Accelerator in a real-world scenario serving multiple regions.

### Key Concepts/Deep Dive

#### Lab Architecture Overview
- **Multi-Region Design**: Lab uses two AWS regions (India - Mumbai and USA - N. Virginia) to simulate multinational infrastructure
- **High Availability Focus**: Demonstrates failover capabilities when entire regions become unavailable
- **Traffic Routing Strategy**: Users access content from the nearest geographic region for optimal performance

#### Infrastructure Components Built
1. **VPC Setup**: Dual-region VPC configuration with public/private subnets
2. **Security Groups**: Application Load Balancer (ALB) and web server security groups with proper traffic isolation
3. **Load Balancing**: Regional ALBs behind Global Accelerator
4. **EC2 Web Servers**: Apache-based instances in private subnets with automated setup via user data scripts
5. **Global Accelerator**: Global traffic router with endpoint groups

#### High Availability Architecture
```
User (Any Region) → Global Accelerator → Nearest Regional ALB → Private Subnet Web Servers
                                    ↓
                            Auto-failover if region down
```

Key benefits:
- **Latency Reduction**: Routes users to closest region
- **Disaster Recovery**: Automatic traffic shift to healthy regions
- **Web Experience Customization**: Region-specific content delivery

### Lab Demos
- **Complete Infrastructure Setup**: Manual VPC/Load Balancer/EC2 configuration across two regions
- **Integration Testing**: Load balancer functionality verification with regional content
- **Global Routing Demonstration**: Web access testing from multiple geographic locations using geo-picker tools

### Code/Config Blocks
User data scripts for web server automation (simplified):

```bash
#!/bin/bash
# Install Apache and configure for India region
yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd

# Create regional content
echo "<html><body><h1>India Web Server</h1><p>Region: Asia Pacific Mumbai</p></body></html>" > /var/www/html/index.html
```

```bash
#!/bin/bash
# Install Apache and configure for USA region  
yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd

# Create regional content
echo "<html><body><h1>USA Web Server</h1><p>Region: US East N. Virginia</p></body></html>" > /var/www/html/index.html
```

### Tables

| Region | VPC IP Range | Subnet Configuration | Load Balancer |
|--------|--------------|----------------------|---------------|
| Asia Pacific (Mumbai) | 192.168.0.0/24 | 2 Public + 2 Private | ALB-India |
| US East (N. Virginia) | 192.168.20.0/24 | 2 Public + 2 Private | ALB-USA |

## Section 13.6 AWS Global Accelerator- Super Lab Part 1

### Overview
This section focuses on Part 1 of the Super Lab implementation: configuring network infrastructure (VPC, subnets, route tables, internet/NAT gateways) across two AWS regions (India and USA). The emphasis is on following AWS best practices for scalable, secure multi-region deployments.

### Key Concepts/Deep Dive

#### VPC Architecture Design
- **Best Practices Implementation**: Dual-region setup with proper network isolation
- **IP Range Planning**: Uses Class C private addressing (192.168.x.0/24 series) for simplicity and scalability
- **Subnet Strategy**: Four subnets per region (2 public, 2 private) for high availability across availability zones

#### Component Configuration Sequence
1. **VPC Creation**: Separate VPCs for each region with distinct IP ranges
2. **Subnet Configuration**: Division using subnet calculator for precise network segmentation
3. **Route Table Management**: Distinct routing for public vs. private subnets
4. **Internet Connectivity**: IGW for public subnets, NAT Gateway for private subnet outbound access
5. **Replication**: Identical infrastructure setup in both regions

#### Network Component Details

**Public Subnets**: 
- Contains ALBs and NAT Gateway
- Direct internet connectivity via Internet Gateway
- Route table routes 0.0.0.0/0 to IGW

**Private Subnets**:
- Houses EC2 web servers
- No public IP addresses
- Outbound internet access via NAT Gateway
- Route table routes outbound traffic to NAT GW, private traffic locally

### Lab Demos

#### VPC and Network Setup Steps
1. **Delete Default VPC**: Clean environment preparation (can be recreated post-lab)
2. **Create Custom VPC**: Named VPC-India/VPC-USA with dedicated IP ranges
3. **Subnet Calculator Usage**: Google "subnet calculator" for precise IP allocation
4. **Four-Subnet Configuration**: Public-subnet-1A, public-subnet-1B, private-subnet-1A, private-subnet-1B
5. **Route Table Creation**: RT-for-public and RT-for-private with appropriate routing rules
6. **Security Components**:
   - **Internet Gateway**: Attach to respective VPCs
   - **NAT Gateway**: Place in public subnet for outbound connectivity
   - **Elastic IP**: Allocate for NAT Gateway

#### Replication in Both Regions
- Identical configuration in US East-1
- IP range adjustment (192.168.20.0/24 for USA)
- Same subnet naming convention

### Code/Config Blocks

**VPC Creation Commands** (AWS CLI):
```bash
# Create VPC India
aws ec2 create-vpc --cidr-block 192.168.0.0/24 --region ap-south-1

# Create VPC USA  
aws ec2 create-vpc --cidr-block 192.168.20.0/24 --region us-east-1

# Create subnets (India example)
aws ec2 create-subnet --vpc-id vpc-id --cidr-block 192.168.0.0/26 --availability-zone ap-south-1a
aws ec2 create-subnet --vpc-id vpc-id --cidr-block 192.168.64/26 --availability-zone ap-south-1b
aws ec2 create-subnet --vpc-id vpc-id --cidr-block 192.168.128/26 --availability-zone ap-south-1a
aws ec2 create-subnet --vpc-id vpc-id --cidr-block 192.168.192/26 --availability-zone ap-south-1b
```

**Route Table Configuration**:
```bash
# Associate public subnets with RT-for-public
aws ec2 associate-route-table --route-table-id rt-public --subnet-id subnet-public-1a
aws ec2 associate-route-table --route-table-id rt-public --subnet-id subnet-public-1b

# Add IGW route to public RT
aws ec2 create-route --route-table-id rt-public --destination-cidr-block 0.0.0.0/0 --gateway-id igw-id

# Associate private subnets with RT-for-private  
aws ec2 associate-route-table --route-table-id rt-private --subnet-id subnet-private-1a
aws ec2 associate-route-table --route-table-id rt-private --subnet-id subnet-private-1b

# Add NAT GW route to private RT
aws ec2 create-route --route-table-id rt-private --destination-cidr-block 0.0.0.0/0 --nat-gateway-id nat-id
```

### Tables

| Component | India (ap-south-1) | USA (us-east-1) |
|-----------|-------------------|------------------|
| VPC | 192.168.0.0/24 | 192.168.20.0/24 |
| Public Subnet 1A | 192.168.0.0/26 | 192.168.20.0/26 |
| Public Subnet 1B | 192.168.64/26 | 192.168.84/26 |
| Private Subnet 1A | 192.168.128/26 | 192.168.148/26 |
| Private Subnet 1B | 192.168.192/26 | 192.168.212/26 |

### Diagrams
```
Internet ←→ IGW ←→ Public RT ←→ [ALB, NAT Gateway]
                                   ↓
Private RT ←→ [Web Servers]
```

## Section 13.7 AWS Global Accelerator- Super Lab Part 2

### Overview
Part 2 focuses on security groups, EC2 web server deployment, and Application Load Balancer setup across both regions. User data scripts automate web server configuration, and load balancers are configured to serve traffic from private subnets.

### Key Concepts/Deep Dive

#### Security Group Architecture
- **Application Load Balancer SG**: Allows HTTP traffic from anywhere (0.0.0.0/0) for public access
- **Web Server SG**: Restricts HTTP traffic to ALB security group only (source-based filtering)
- **SSH Access**: Additional SSH allow rule for instance management (temporary production access)

#### Web Server Deployment Strategy
- **Automation via User Data**: Dual-region specific content (India vs USA versions)
- **Private Subnet Placement**: Enhanced security (no direct internet exposure)
- **High Availability**: Two instances per region across different availability zones
- **Out-of-Box Configuration**: Apache installation and custom content creation

#### Load Balancer Configuration
- **Internet-Facing ALB**: Public access with IPv4 support
- **Multi-AZ Setup**: Spans public subnets for availability
- **Target Groups**: HTTP health checks with EC2 instance registration
- **Testing Verification**: DNS name access for functionality confirmation

### Lab Demos

#### Security Group Setup
1. **ALB Security Group**: HTTP/80 from 0.0.0.0/0
2. **Web Server Security Group**: HTTP/80 from ALB SG, SSH/22 from 0.0.0.0/0 (maintenance)
3. **Replication**: Same configuration in both regions

#### EC2 Web Server Deployment
1. **Instance Launch**: t2.micro in private subnets (no public IP)
2. **User Data Injection**: Automated Apache + regional content setup
3. **Instance Types**: Web-server-1 (AZ A), web-server-2 (AZ B)
4. **Verification**: Manual testing impossible (private subnet) - requires ALB setup

#### ALB Configuration Steps
1. **Target Group Creation**: HTTP health checks, instance registration
2. **ALB Creation**: Internet-facing, multi-AZ, security group assignment
3. **Listener Configuration**: HTTP:80 with target group routing
4. **DNS Testing**: ALB domain name verification in browser
5. **Regional Replication**: USA region mirror setup with appropriate naming

### Code/Config Blocks

**Security Group Creation**:
```bash
# ALB Security Group (India)
aws ec2 create-security-group \
  --group-name alb-sg \
  --description "ALB Security Group" \
  --vpc-id vpc-india-id \
  --region ap-south-1

aws ec2 authorize-security-group-ingress \
  --group-id alb-sg-id \
  --protocol tcp \
  --port 80 \
  --cidr 0.0.0.0/0

# Web Server Security Group (India)
aws ec2 create-security-group \
  --group-name web-server-sg \
  --description "Web Server SG" \
  --vpc-id vpc-india-id \
  --region ap-south-1

aws ec2 authorize-security-group-ingress \
  --group-id web-sg-id \
  --protocol tcp \
  --port 80 \
  --source-group alb-sg-id

aws ec2 authorize-security-group-ingress \
  --group-id web-sg-id \
  --protocol tcp \
  --port 22 \
  --cidr 0.0.0.0/0
```

**User Data Scripts** (India Region):
```bash
#!/bin/bash
yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd

# India regional content
cat > /var/www/html/index.html << 'EOF'
<!DOCTYPE html>
<html>
<body>
<h1>India Web Server</h1>
<p>Server Region: Asia Pacific (Mumbai)</p>
<p>Availability Zone: [availability-zone]</p>
</body>
</html>
EOF
```

**ALB Configuration**:
```bash
# Create Target Group
aws elbv2 create-target-group \
  --name india-target-group \
  --protocol HTTP \
  --port 80 \
  --vpc-id vpc-india-id \
  --target-type instance

# Register EC2 instances
aws elbv2 register-targets \
  --target-group-arn tg-arn \
  --targets Id=i-123456 Id=i-789012

# Create ALB
aws elbv2 create-load-balancer \
  --name india-alb \
  --subnets subnet-public-1a subnet-public-1b \
  --security-groups alb-sg-id \
  --scheme internet-facing

# Create Listener
aws elbv2 create-listener \
  --load-balancer-arn alb-arn \
  --protocol HTTP \
  --port 80 \
  --default-actions Type=forward,TargetGroupArn=tg-arn
```

### Tables

| Component | India Configuration | USA Configuration |
|-----------|-------------------|-------------------|
| ALB Security Group | HTTP from 0.0.0.0/0 | HTTP from 0.0.0.0/0 |
| Web Server SG | HTTP from ALB-SG, SSH from anywhere | HTTP from ALB-SG, SSH from anywhere |
| Target Group | india-target-group | usa-target-group |
| ALB Name | india-alb | usa-alb |
| Listener | HTTP:80 → TG | HTTP:80 → TG |

### Diagrams
```
Internet → ALB (Public Subnet) → Target Group → [Web Server 1, Web Server 2]
                                      ↑
                               Security Group Filtering
```

> [!NOTE]
> User data scripts must be correctly copied - any typos will result in unhealthy instances.

## Section 13.8 AWS Global Accelerator- Super Lab Part 3

### Overview
The final Super Lab section integrates Global Accelerator with regional load balancers to demonstrate global traffic routing and failover capabilities. This hands-on implementation shows live configuration of endpoint groups, geolocation-based routing, and disaster recovery testing.

### Key Concepts/Deep Dive

#### Global Accelerator Architecture
- **Global Service Nature**: No region-locked - spans all AWS regions
- **Static IP Foundation**: Two global anycast IPv4 addresses for consistent access
- **Three-Tier Structure**: Accelerator → Listeners → Endpoint Groups → Endpoints

#### Configuration Hierarchy
```
Accelerator (Global)
├── Listener (Port: 80, Protocol: TCP)
├── Endpoint Group 1 (Region: ap-south-1)
│   └── Endpoint: ALB (Weight: 100%)
└── Endpoint Group 2 (Region: us-east-1)
    └── Endpoint: ALB (Weight: 100%)
```

#### Routing Intelligence
- **Edged Location Distribution**: 100+ PoPs worldwide
- **Geographic Proximity**: Routes user traffic to nearest region automatically
- **Health-Based Failover**: Instant traffic shift when regional endpoints become unhealthy
- **Performance Optimization**: Uses AWS network backbone for ultra-low latency

### Lab Demos

#### Global Accelerator Setup Steps
1. **Accelerator Creation**: Standard type, IPv4 addresses, global deployment
2. **Listener Configuration**: TCP/80 for web traffic
3. **Endpoint Group Creation**: One per region (ap-south-1, us-east-1)
4. **ALB Endpoint Registration**: Regional ALBs as traffic targets
5. **Health Monitoring**: Default TCP health checks on port 80

#### Traffic Testing and Validation
- **Regional Content Verification**: India users see Indian content, US users see US content
- **Geo Picker Testing**: Browser-based global website access simulation from different countries
- **Failover Simulation**: Load balancer deletion to test automatic traffic rerouting
- **Disaster Recovery**: Verification that users experience no downtime during regional failures

#### Troubleshooting Scenarios
- **Unhealthy Endpoints**: Security group misalignment or EC2 configuration issues
- **Missing Endpoint Groups**: Incomplete regional setup leads to single-region routing
- **Health Check Configuration**: Adjust path/method for non-standard web applications

### Code/Config Blocks

**Global Accelerator Creation**:
```bash
# Create Accelerator
aws globalaccelerator create-accelerator \
  --name my-global-accelerator \
  --enabled

# Create Listener
aws globalaccelerator create-listener \
  --accelerator-arn arn:aws:globalaccelerator::account:accelerator/id \
  --protocol TCP \
  --port-ranges FromPort=80,ToPort=80

# Create Endpoint Groups
aws globalaccelerator create-endpoint-group \
  --listener-arn listener-arn \
  --endpoint-group-region ap-south-1 \
  --traffic-dial-percentage 100

aws globalaccelerator create-endpoint-group \
  --listener-arn listener-arn \
  --endpoint-group-region us-east-1 \
  --traffic-dial-percentage 100

# Add ALB Endpoints
aws globalaccelerator add-endpoints \
  --endpoint-group-arn eg-ap-south-arn \
  --endpoints [
    {
      "EndpointId": "arn:aws:elasticloadbalancing:ap-south-1:account:loadbalancer/app/india-alb/id",
      "Type": "ALB"
    }
  ]

aws globalaccelerator add-endpoints \
  --endpoint-group-arn eg-us-east-arn \
  --endpoints [
    {
      "EndpointId": "arn:aws:elasticloadbalancing:us-east-1:account:loadbalancer/app/usa-alb/id", 
      "Type": "ALB"
    }
  ]
```

**Health Check Configuration** (if customizing):
```bash
aws globalaccelerator update-endpoint-group \
  --endpoint-group-arn eg-arn \
  --health-check-protocol "HTTP" \
  --health-check-path "/" \
  --health-check-interval-seconds 10 \
  --threshold-count 2
```

### Tables

| Configuration | India Setup | USA Setup | Global Accelerator |
|---------------|-------------|-----------|-------------------|
| VPC CIDR | 192.168.0.0/24 | 192.168.20.0/24 | Global service |
| ALB Endpoint | india-alb | usa-alb | Static IPs provided |
| Health Status | Healthy (HTTP) | Healthy (HTTP) | Endpoint monitoring |
| Traffic Routing | Regional users | Regional users | Geographic proximity |

| Global Test Location | Expected Content | Routing Path |
|---------------------|------------------|--------------|
| Singapore | India servers | Global Accelerator → Mumbai ALB |
| Brazil | USA servers | Global Accelerator → N. Virginia ALB |
| Australia | India servers | Global Accelerator → Mumbai ALB |

### Diagrams
```
Global Accelerator (Anycast IPs)
├── Listener: TCP/80
├── Endpoint Group: ap-south-1 (100% dial)
│   └── ALB-India
│       ├── TG-India
│       └── [Web-Server-India-1A, Web-Server-India-1B]
└── Endpoint Group: us-east-1 (100% dial)
    └── ALB-USA
        ├── TG-USA
        └── [Web-Server-USA-1A, Web-Server-USA-1B]
```

> [!IMPORTANT]
> Global Accelerator DNS names take 5-10 minutes to propagate globally after configuration changes.

## Summary

### Key Takeaways
```diff
+ Global Accelerator provides static anycast IPs for geo-intelligent traffic distribution
+ Seamlessly integrates with regional load balancers and EC2 instances
+ Enables real-time failover and disaster recovery across AWS regions
+ Uses AWS's extensive edge network for improved global performance
- Requires careful endpoint group configuration for multi-region setups
- Health checks must align with application architecture
```

### Quick Reference
**Global Accelerator Commands:**
- Create: `aws globalaccelerator create-accelerator --name my-ga --enabled`
- Add listener: `aws globalaccelerator create-listener --accelerator-arn arn --port-ranges FromPort=80,ToPort=80 --protocol TCP`
- Endpoint group: `aws globalaccelerator create-endpoint-group --listener-arn arn --endpoint-group-region region --traffic-dial-percentage 100`

**Network Setup Sequence:**
1. VPC + 4 subnets per region
2. IGW + NAT Gateway
3. Route table configuration
4. Security groups (ALB + web servers)
5. EC2 instances with user data scripts
6. Regional ALBs with target groups
7. Global Accelerator with endpoint groups

### Expert Insight

#### Real-world Application
**E-commerce Global Deployment**: Use Global Accelerator to route customers to the nearest region, reducing latency by 40-60%. Backend systems sync via Aurora Global Database while frontend traffic is geographically optimized. **Example**: Amazon.com uses similar global edge routing for ultra-low latency shopping experiences.

#### Expert Path
1. **Start with Single Region**: Build confidence with regional ALB → GA migration
2. **Add Monitoring**: Integrate CloudWatch metrics for endpoint health trending
3. **Implement Weight Shifts**: Use traffic dials for blue-green deployments and A/B testing
4. **Customize Health Checks**: Implement application-specific health endpoints
5. **Global Database Integration**: Combine with RDS Global instances for complete geo-distribution

#### Common Pitfalls
- **Missing NAT Gateway**: Private subnet web servers can't download packages during user data execution
- **Security Group Loop**: Web servers can't receive ALB traffic without referencing ALB SG as source
- **Incomplete Endpoint Groups**: Partial regional setup leads to uneven global distribution
- **Ignoring Propagation Time**: Testing immediately after config changes causes false negative results

#### Lesser-Known Facts
- **Built-in DDoS Protection**: GA automatically inherits AWS Shield protection at the edge
- **IPv6 Support**: Standard accelerators support dual-stack configurations for modern networks
- **Custom Routing Accelerator**: Supports deterministic routing via /32 CIDR blocks for precise traffic engineering

</details>
