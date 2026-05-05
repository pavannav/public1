# Section 9: Capstone Project 1 - Resilient and Scalable Web Application Deployment on AWS

<details open>
<summary><b>Section 9: Capstone Project 1 - Resilient and Scalable Web Application Deployment on AWS (CL-KK-Terminal)</b></summary>

## Table of Contents

- [Introduction of Project](#introduction-of-project)
- [Session - 2 Implementation of VPC Design](#session--2-implementation-of-vpc-design)
- [Session- 3 Configure EFS & Setup Custom AMI for Auto Scaling](#session--3-configure-efs--setup-custom-ami-for-auto-scaling)
- [Session - 4 Set up And Test Auto Scaling & Deploy ALB](#session--4-set-up-and-test-auto-scaling--deploy-alb)
- [Session - 5 Setting Up Security Group](#session--5-setting-up-security-group)
- [Session - 6 Integrate Route 53 For Domain Management](#session--6-integrate-route-53-for-domain-management)
- [Session - 7 Testing and Optimization](#session--7-testing-and-optimization)
- [Session - 8 Project Documentation & Deliverables](#session--8-project-documentation--deliverables)

## Introduction of Project

### Overview
This section introduces the AWS Capstone Project, a hands-on implementation of a resilient and scalable web application deployment on AWS. The project demonstrates real-world AWS best practices for high availability, scalability, and security using multiple AWS services. It emphasizes practical deployment over theory, culminating in a complete web application accessible via a custom domain.

### Key Concepts and Deep Dive

#### Project Description
- **Objectives**: Achieve high availability through multiple Availability Zones, enable scalability with Auto Scaling, ensure security via VPC and security groups, and maintain resilience against failures.
- **Key Metrics**: Fault tolerance, load balancing, and automated resource management without manual intervention.

#### Core AWS Services Utilized
- **VPC**: Custom VPC with public/private subnets across multiple AZs for network isolation and security.
- **EFS**: Shared file storage for centralized application hosting, enabling easy updates across multiple instances.
- **EC2**: Compute resources running the web application in private subnets for security.
- **Auto Scaling**: Dynamic adjustment of EC2 instances based on traffic demands.
- **Application Load Balancer (ALB)**: Distributes traffic across instances in different AZs.
- **Route 53**: Domain name system for custom DNS resolution.

#### Project Phases
1. **Design Phase**: Architect the solution focusing on security, scalability, and availability.
2. **Implementation Phase**: 
   - Create VPC, subnets, and security groups.
   - Configure EFS and custom AMI.
   - Deploy Auto Scaling and ALB.
   - Integrate Route 53.
3. **Testing and Optimization Phase**: Functional/load testing to ensure performance and scalability.
4. **Documentation Phase**: Produce detailed architecture and implementation guides.

#### Expected Outcomes
- Complete documentation provided to learners.
- Guarantees improved AWS knowledge and interview readiness.
- Foundation for advanced projects with additional services like HTTPS and databases.

## Session - 2 Implementation of VPC Design

### Overview
This session covers the implementation of a secure VPC design for the capstone project, emphasizing multi-AZ deployment for high availability and security through public/private subnet separation.

### Key Concepts and Deep Dive

#### VPC Design Principles
- **Security Focus**: EC2 instances in private subnets prevent direct internet access, reducing exposure.
- **Availability**: Resources across two AZs (AP South 1A and 1B) ensure fault tolerance.

#### Subnet Configuration
- **Public Subnets**: ALB placement with inbound/outbound internet access.
- **Private Subnets**: EC2 instances with outbound-only internet via NAT Gateway for updates and data retrieval.

#### Key Components Created
- **VPC**: CIDR block 192.168.0.0/24 for isolation.
- **Subnets**:
  - Public Subnet 1A: 192.168.0.0/26
  - Public Subnet 1B: 192.168.0.64/26
  - Private Subnet 1A: 192.168.0.128/26
  - Private Subnet 1B: 192.168.0.192/26
- **Internet Gateway**: Enables internet access for public subnets.
- **NAT Gateway**: Provides outbound internet for private subnets.
- **Route Tables**:
  - Main Route Table: For private subnets with NAT Gateway route (0.0.0.0/0).
  - Public Route Table: Associates public subnets with Internet Gateway.

### Lab Demos
- Delete default VPC for clean setup.
- Create custom VPC with specified CIDR and enable DNS hostname.
- Create four subnets across two AZs with proper CIDR allocation.
- Attach Internet Gateway to VPC.
- Create and associate public route table.
- Add 0.0.0.0/0 route to Internet Gateway for public access.
- Set up NAT Gateway in public subnet and update main route table for private subnets.
- Verify NAT Gateway availability (pending to available state).

## Session- 3 Configure EFS & Setup Custom AMI for Auto Scaling

### Overview
This session configures Elastic File System (EFS) for shared storage and creates a custom AMI to enable automated EC2 deployment through Auto Scaling, ensuring centralized application management.

### Key Concepts and Deep Dive

#### Elastic File System (EFS) Benefits
- **Shared Storage**: Eliminates need for application copying across instances; updates affect all servers centrally.
- **Comparison**: EFS chosen over FSX for simplicity and Linux compatibility.

#### EFS Setup Requirements
- **Security Groups**: Temporary "allow all" rule for initial setup (hardened later per best practices).
- **VPC Permissions**: Enable DNS hostnames for proper mounting.
- **Regional EFS**: Preferred for high availability across AZs.

#### Custom AMI Creation Process
- **Purpose**: Automate identical instance deployment with pre-configured settings.
- **Instance Setup**: EC2 in public subnet with public IP for EFS mounting and AMI creation.
- **File System Mounting**: Mount EFS to /var/www/html for web application storage.
- **Persistent Mounting**: Update /etc/fstab for auto-mounting across reboots.

#### Web Application Deployment
- **HTTPD Installation**: Apache server setup with auto-start.
- **Sample Application**: HTML file created via VI editor for testing.
- **Verification**: Website accessibility after setup and reboot.

### Lab Demos
1. **EFS Configuration**:
   ```bash
   # Update VPC settings for DNS resolution
   terraform apply  # (Conceptual - enable DNS hostname)
   
   # Create EFS via AWS Console
   # Name: shared-storage-web-app-project-one
   # Regional setup
   # Mount targets in private subnets with custom security group
   ```

2. **EC2 Setup for AMI**:
   ```bash
   # Launch EC2 in public subnet
   # Install Apache
   sudo yum install httpd -y
   sudo systemctl start httpd
   sudo systemctl enable httpd
   
   # Mount EFS
   sudo yum install amazon-efs-utils -y
   sudo mkdir /var/www
   sudo mount -t efs fs-xxxxx:/ /var/www/html
   
   # Create sample HTML
   sudo vi /var/www/html/index.html
   # (Insert HTML content: Welcome message)
   
   # Persistent mount
   sudo vi /etc/fstab
   # Add: fs-xxxxx:/ /var/www/html efs defaults 0 0
   ```

3. **AMI Creation**:
   ```bash
   # Enable encryption if required for production
   # Create image: ami-image-web-server-project-one
   # Terminate EC2 after AMI availability
   ```

## Session - 4 Set up And Test Auto Scaling & Deploy ALB

### Overview
This session establishes Auto Scaling for dynamic instance management and deploys Application Load Balancer for traffic distribution, enabling self-healing and scalable infrastructure.

### Key Concepts and Deep Dive

#### Auto Scaling Configuration
- **Launch Template**: Defines AMI, instance type, security groups, and User Data for test application.
- **Scaling Policies**: Manual scaling (0-5 instances) with planned dynamic CPU-based scaling.
- **Integration**: Templates reside in private subnets without public IPs for security.

#### Application Load Balancer (ALB) Setup
- **Placement**: Public subnets for internet-facing access.
- **Target Groups**: Separate groups for main app (port 80) and test app (port 8080).
- **Listeners**: Forward traffic based on port to appropriate target groups.
- **Auto-Registration**: Instances added/removed automatically via Auto Scaling.

#### Traffic Management
- **Load Balancing**: Distributes requests across healthy instances.
- **Monitoring**: Instance health checks prevent serving failed resources.

#### Testing Strategies
- **Main App**: Standard website access verification.
- **Test App**: Hostname display for traffic distribution confirmation.

### Lab Demos
1. **Launch Template Creation**:
   ```bash
   # Template: my-project-launched
   # AMI: ami-image-web-server-project-one
   # Instance Type: t2.micro
   # Key Pair: existing
   # Security Group: web-server-sg
   # User Data Script (for test app):
   #!/bin/bash
   ## Insert test app setup code ##
   ```

2. **Auto Scaling Group**:
   ```bash
   # Group: project-one
   # Launch Template attachment
   # VPC and private subnets selection
   # 0 desired instances initially
   # Max 5, Min 0
   # No initial health checks
   ```

3. **ALB and Target Groups**:
   ```bash
   # ALB: alb-project-one (internet-facing, IPv4)
   # Subnets: Both public subnets
   # Security Group: alb-sg-project-one
   # Target Groups:
   - web-app-target-group (port 80, instance targets)
   - test-app-target-group (port 8080, instance targets)
   # Listeners: HTTP 80 → web-app; HTTP 8080 → test-app
   ```

4. **Integration and Testing**:
   ```bash
   # Attach target groups to Auto Scaling Group
   # Manual scaling to 2 instances
   # Verify instances in target groups
   # Access ALB URLs for main app and test app
   # Confirm hostname rotation via refreshes
   ```

## Session - 5 Setting Up Security Group

### Overview
This session configures security groups per AWS best practices, shifting from temporary "allow all" rules to restrictive policies that ensure secure communication between services.

### Key Concepts and Deep Dive

#### Security Group Best Practices
- **Principle of Least Privilege**: Allow only necessary traffic.
- **Layered Security**: ALB handles external access; restricts internal communications.
- **Temporary vs. Production**: Initial setup uses permissive rules; hardened post-development.

#### ALB Security Group Rules
- **Inbound**: HTTP (80) from anywhere; test port (8080) from specific IPs.
- **Outbound**: Allow all traffic (standard).

#### EC2 (Web Server) Security Group Rules
- **Inbound**: HTTP/HTTPS only from ALB security group (user source reference).
- **Outbound**: Allow all traffic for package updates and service calls.

#### EFS Security Group Rules
- **Inbound**: NFS (2049) only from web server security group.

#### Verification Process
- **Post-Configuration Testing**: Confirm website accessibility and security restrictions.
- **Best Practice Compliance**: Eliminates unnecessary exposure while maintaining functionality.

### Lab Demos
1. **ALB Security Group**:
   ```bash
   # Security Group: alb-sg-project-one
   # Inbound Rules:
   - Type: HTTP, Protocol: TCP, Port: 80, Source: Anywhere (0.0.0.0/0)
   - Type: Custom TCP, Protocol: TCP, Port: 8080, Source: Your IP
   ```

2. **Web Server Security Group**:
   ```bash
   # Security Group: web-server-sg-project-one
   # Inbound Rules:
   - Type: HTTP, Protocol: TCP, Port: 80, Source: alb-sg-project-one
   - Type: Custom TCP, Protocol: TCP, Port: 8080, Source: alb-sg-project-one
   ```

3. **EFS Security Group**:
   ```bash
   # Security Group: efs-sg-project-one
   # Inbound Rules:
   - Type: NFS, Protocol: TCP, Port: 2049, Source: web-server-sg-project-one
   ```

4. **Testing**:
   ```bash
   # Access ALB URLs
   # Verify restrictions (e.g., port 8080 only from allowed IP)
   # Confirm load balancing integrity
   ```

## Session - 6 Integrate Route 53 For Domain Management

### Overview
This session integrates Route 53 for custom domain management, replacing ALB URLs with user-friendly DNS names for production-ready application access.

### Key Concepts and Deep Dive

#### Route 53 Fundamentals
- **Domain Registration**: Can be done via AWS or third-party providers (e.g., GoDaddy).
- **Hosted Zones**: Public hosted zones for DNS resolution; NS record delegation.
- **Record Types**: Alias records for seamless ALB integration.

#### DNS Configuration Steps
- **NS Record Update**: Replace provider's name servers with Route 53's for DNS control.
- **ALIAS Records**: Point subdomains to ALB without IP management overhead.
- **Propagation**: DNS changes take time (5-15 minutes); flush local DNS caches if needed.

#### Benefits of Route 53
- **Integration**: Native AWS service compatibility.
- **Reliability**: Global DNS resolution with high uptime.
- **Management**: Centralized control for domain and subdomains.

### Lab Demos
1. **Hosted Zone Creation**:
   ```bash
   # Hosted Zone: cloudfolk.in
   # Type: Public
   # Note NS records for delegation
   ```

2. **Domain Delegation**:
   ```bash
   # Update GoDaddy name servers with Route 53 NS records
   # Example NS: ns-xxx.awsdns-xx.com, etc.
   ```

3. **ALIAS Record Setup**:
   ```bash
   # Record Name: learn.cloudfolk.in
   # Type: A (Alias)
   # Alias Target: alb-project-one ALB
   ```

4. **Verification**:
   ```bash
   # DNS propagation: Wait 5-15 minutes
   # Access: https://learn.cloudfolk.in
   # Flush DNS: ipconfig /flushdns (Windows)
   ```

## Session - 7 Testing and Optimization

### Overview
This session conducts comprehensive functional and load testing to validate high availability, scalability, and resilience, ensuring the application meets project objectives under various conditions.

### Key Concepts and Deep Dive

#### Testing Objectives
- **High Availability**: Verify multi-AZ fault tolerance.
- **Scalability**: Test scale-out (CPU >60%) and scale-in (CPU reduction).
- **Resilience**: Automatic recovery from instance failures.
- **Load Balancing**: Confirm even traffic distribution via test app.

#### Dynamic Scaling Policies
- **Scale-Out**: CPU utilization >60% triggers additional instances (up to 5).
- **Scale-In**: CPU < threshold removes excess instances.
- **Cooldown Periods**: Prevent rapid scaling fluctuations.

#### Monitoring and Verification
- **Instance Health**: Healthy/unhealthy status in target groups.
- **Activity Logs**: Track scaling events in Auto Scaling Group.
- **Traffic Distribution**: Hostname changes confirm load balancing.

### Lab Demos
1. **High Availability Testing**:
   ```bash
   # Terminate one instance
   # Verify continued access (minimum 2 instances policy)
   # Auto Scaling launches replacement
   # Confirm target group re-registration
   ```

2. **Scalability Testing**:
   ```bash
   # Scale policy: Target tracking - Average CPU >60%
   # Generate load via test app (CPU stress)
   # Monitor scale-out to 3-5 instances
   # Confirm traffic distribution via hostname rotation
   ```

3. **Scale-In Verification**:
   ```bash
   # Remove load
   # Monitor automatic termination
   # Verify return to baseline (2 instances)
   # Check activity logs for scale-in events
   ```

4. **Load Balancing Confirmation**:
   ```bash
   # Access test app: ALB-URL:8080
   # Refresh for hostname changes
   # Map to instance DNS names
   ```

## Session - 8 Project Documentation & Deliverables

### Overview
This final session emphasizes professional documentation as a critical project component, providing templates and guides for architectural diagrams, implementation details, and presentations.

### Key Concepts and Deep Dive

#### Documentation Importance
- **First Impression**: Well-structured docs demonstrate expertise.
- **Deliverables**: Support project presentations and future reference.

#### Key Deliverable Components
- **Architectural Diagram**: Visual VPC design and data flow.
- **Design Document**: Detailed rationale for service selections.
- **Implementation Guide**: Step-by-step configuration instructions.
- **Performance Report**: Test results, baselines, and optimizations.
- **Project Presentation**: PowerPoint template with agenda, findings, and challenges.

#### Template Usage
- **Provided Assets**: Google Drive links with sample docs and diagrams.
- **Customization**: Fill in project-specific details (metrics, timings).
- **Templates**: Ready-to-use but require understanding for interviews.

### Lab Demos
- **Download Deliverables**: Access Google Drive for all templates.
- **Populate Implementation Guide**:
  ```yaml
  # Example Section
  4.1 VPC Design
  - Create VPC: CIDR 192.168.0.0/24
  - Enable DNS hostnames
  # Continue for each service
  ```
- **Performance Report Structure**:
  ```yaml
  Baseline Performance:
  - Response Time: Average X ms
  Load Test Results:
  - Scale Events: Time to provision instances
  ```
- **Presentation Setup**: Import PowerPoint template and add project data.

## Summary

### Key Takeaways
```diff
+ Comprehensive AWS project demonstrating full infrastructure lifecycle
+ Multi-AZ deployment ensures 99.9% availability and fault tolerance
+ Centralized storage via EFS simplifies application management across scaling events
+ Security-first approach with least-privilege access and HTTPS readiness
+ Automation through Auto Scaling and ALB enables zero-downtime scaling
+ Route 53 integration provides production-ready domain management
+ Thorough testing validates resilience and performance objectives
+ Professional documentation templates ensure easy knowledge transfer
```

### Quick Reference
- **Project URL**: https://learn.cloudfolk.in
- **Test URL**: https://learn.cloudfolk.in:8080
- **Core Commands**:
  ```bash
  # Mount EFS
  mount -t efs fs-id:/ /var/www/html
  
  # Update fstab for persistence
  echo "fs-id:/ /var/www/html efs defaults 0 0" >> /etc/fstab
  
  # Launch Auto Scaling instances
  aws autoscaling set-desired-capacity --auto-scaling-group-name project-one --desired-capacity 2
  ```

### Expert Insight

#### Real-world Application
The implemented architecture serves as a foundation for production web applications, handling variable traffic loads in e-commerce or content delivery scenarios with minimal manual intervention.

```diff
! Route 53 provides low-latency DNS resolution globally, reducing access times compared to generic subdomains.
+ Consider adding WAF for advanced security and CloudFront for CDN capabilities in high-traffic applications.
- Avoid over-provisioning; start with 2 instances and rely on dynamic scaling to avoid unnecessary costs.
```

#### Expert Path
Master advanced Auto Scaling policies using CloudWatch custom metrics, implement CI/CD pipelines for seamless deployments, and integrate with AWS X-Ray for detailed performance monitoring. Progress to multi-region deployments for disaster recovery.

#### Common Pitfalls
- Forgetting persistent EFS mounts leads to application unavailability after reboots.
- Permissive security groups increase attack surfaces; always harden post-testing.
- DNS propagation delays cause temporary outages; communicate changes beforehand.
- Inadequate scaling policies result in either over-costing or performance bottlenecks.

</details>
