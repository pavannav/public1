# Session 15: EC2 + RDS Project - Multi-Tier Application

- [Overview](#overview)
- [Key Concepts / Deep Dive](#key-concepts--deep-dive)
- [Lab Demos](#lab-demos)
- [Summary](#summary)

## Overview

This session builds on previous CLI and AWS configuration knowledge by implementing a complete multi-tier application project. It covers the concepts of multi-tier architecture (3-tier applications), introduces Amazon RDS as a managed database service, and demonstrates deploying a WordPress blogging app on EC2 connected to a MySQL database on RDS. Learners gain hands-on experience in setting up scalable, real-world cloud infrastructures using AWS services.

## Key Concepts / Deep Dive

### Revision of Previous Session

- **CLI for AWS Access**: Web UI, CLI (command-line interface) for easy scripting, and API for mobile applications.
- **Commands Covered**:
  - `aws --version`: Checks AWS version.
  - `aws configure`: Sets up AWS credentials (access key, secret key, region, profile).
  - User creation via IAM for CLI access.
  - Regions (e.g., AP-south-1).
- **AWS Help and Subcommands**: `aws help` lists services; `aws ec2 help` provides subcommands for EC2.
- **Key Pair Creation**: `aws ec2 create-key-pair --key-name mykey --query 'KeyMaterial' --output text > mykey.pem` saves SSH keys.
- **Security Groups**: Firewalls allowing specific traffic (e.g., HTTP on port 80, SSH on port 22, MySQL on port 3306).
- **AMI ID**: Unique IDs for OS images; EC2 uses them for instances.
- **Inbound/Ingress Rules**: Traffic from internet to instance (e.g., source 0.0.0.0/0 for any IP).
- **CIDR Notation**: Classless Inter-Domain Routing for ranges (e.g., 0.0.0.0/0 for all IPs).
- **Application Setup**: Launching instances, installing LAMP stack (Linux, Apache, MySQL, PHP), deploying web apps.

### Multi-Tier Applications (3-Tier Architecture)

- **What is Multi-Tier App?**: Applications with multiple layers/tiers. Common example: Facebook (user interface, backend processing in PHP, database storage).
- **Three Main Tiers**:
  1. **End User/Client Layer**: User interface (browsers, mobile apps).
  2. **Business Logic/App Layer**: Backend apps (e.g., PHP code) processing requests.
  3. **Data Layer**: Databases storing data (e.g., MySQL).
- **Example**: User → Facebook (PHP app) → MySQL database.
- **Connectivity**: Apps connect to databases via drivers (e.g., PHP-MySQL connector). Requires: IP address (URI/URL), username, password, database name.
- **Database Connectivity**: Developers write connection strings; PHP programs talk to remote databases over networks.
- **Real-World**: Most apps (Facebook, Instagram) are multi-tier; complex systems add more layers (microservices, caching).
- **Project Goal**: Set up a 3-tier blogging app using WordPress (app layer) on EC2 and MySQL (data layer) on RDS.

### Introduction to RDS (Relational Database Service)

- **What is RDS?**: AWS-managed database service. Handles hardware, OS installation, database setup, security, backups, performance tuning.
- **Key Benefits**:
  - Managed service: No manual OS/DB management (unlike EC2 where you install everything yourself).
  - Responsibility model: AWS manages infrastructure; you use the database.
  - Supports SQL databases (e.g., MySQL, PostgreSQL) and NoSQL.
- **Comparison to Self-Managed Databases**:
  | Aspect | Self-Managed (EC2) | Managed (RDS) |
  |--------|-------------------|---------------|
  | Management | You handle everything | AWS handles |
  | Responsibility | Security, backups, updates | Service usage |
  | Cost/Scalability | Manual; harder to scale | Integrated features |
- **2-Tier vs. 3-Tier**: 2-tier (client directly to DB) rarely used for security; 3-tier preferred.
- **Serverless Databases**: Future topic; RDS is serverless-like for MySQL (AWS launches instances internally).
- **Free Tier**: Available for 12 months on select configurations.

### AWS EKS Brief Mention

- **What is EKS?**: Kubernetes service on AWS (Elastic Kubernetes Service); huge for containerized apps.
- **Market Demand**: High in companies (e.g., Amazon, HSBC); jobs in migration, scaling.
- **Overview**: Managed Kubernetes; handles orchestration. Not detailed here; separate training recommended.
- **Advantages**: Scales apps, used by giants; cross-platform.

### WordPress as a Multi-Tier Example

- **WordPress Overview**: Free, open-source blogging platform written in PHP.
- **Why WordPress for Project?**: Easy to set up; represents real app.
- **Requirements**: 
  - Web server (Apache HTTPD).
  - PHP interpreter + MySQL driver.
  - MySQL database.
- **Flow**: User → WordPress (PHP app) → MySQL database.
- **Deployment**: Code downloaded, extracted to web root, configured.

### AWS Responsibility Model

- **EC2**: You manage OS/database fully.
- **RDS**: AWS manages OS/database; you configure and use.
- **Tiers**: Client (unmanaged), App (via EC2), Database (via RDS).

## Lab Demos

### Creating RDS MySQL Instance

1. Navigate to AWS RDS service.
2. Click **Create Database**.
3. Select **Standard Create** for full options.
4. Choose **Engine**: MySQL, Version 8.0.x (latest).
5. Select **Template**: Free tier (for practice).
6. **Settings**:
   - DB instance identifier: `mywordpressdb`.
   - Master username: `admin`.
   - Auto-generated password: `redhat123` (example; use strong password).
7. **Instance Configuration**: Burstable classes (T3.micro or T2.micro).
8. **Storage**: General Purpose SSD, 20 GB (free tier).
9. **Connectivity**:
   - VPC: Default.
   - Public access: Enable (for demo; insecure in production).
   - Security Group: Create new or select existing (allow MySQL port 3306 from anywhere).
   - Availability Zone: Select one (e.g., ap-south-1a).
10. **Database Authentication**: Password authentication.
11. **Additional Configuration**:
    - Initial database name: `myblog`.
    - Logs: Enable minimal.
12. Click **Create Database**. Wait 10-15 minutes for setup.
13. Once ready, note **Endpoint** (URL) and credentials.

> [!WARNING]
> Public access is for demo only; use private subnets and specific IP ranges in production to prevent security risks.

### Launching EC2 Instance for WordPress

1. Go to EC2 Console.
2. Click **Launch Instance**.
3. **AMI**: Amazon Linux 2 (free tier).
4. **Instance Type**: T2.micro.
5. **Security Group**:
   - Allow SSH (port 22) from your IP.
   - Allow HTTP (port 80) from anywhere (0.0.0.0/0).
   - Allow HTTPS (port 443) from anywhere.
6. **Key Pair**: Use existing (e.g., from previous session).
7. Launch instance.

### Installing LAMP Stack and WordPress on EC2

1. SSH into EC2 instance: `ssh -i yourkey.pem ec2-user@<public-ip>`.
2. Update system: `sudo yum update -y`.
3. Install Apache: `sudo yum install httpd -y`.
4. Install PHP and MySQL driver:
   ```
   sudo amazon-linux-extras install php7.2 -y
   sudo yum install php-mysqli -y  # MySQL driver for PHP
   ```
5. Enable and start services:
   ```
   sudo systemctl enable httpd
   sudo systemctl start httpd
   sudo systemctl restart httpd  # After PHP install
   ```
6. Download WordPress: `wget https://wordpress.org/latest.tar.gz`.
7. Extract: `tar -xzf latest.tar.gz`.
8. Copy to web root: `sudo cp -r wordpress/* /var/www/html/`.
9. Set permissions: `sudo chown -R apache:apache /var/www/html/`.
10. Restart Apache: `sudo systemctl restart httpd`.

### Connecting WordPress to RDS Database

1. Open EC2 public IP in browser; WordPress setup page loads.
2. Enter RDS details:
   - Database Name: `myblog`
   - Username: `admin`
   - Password: `redhat123`
   - Database Host: RDS Endpoint (e.g., `mywordpressdb.xxxxxx.rds.amazonaws.com`)
3. Submit; WordPress creates tables in RDS.
4. Create admin account for WordPress dashboard.

### Verifying Setup and Data Flow

1. Connect to RDS via MySQL Workbench (external tool):
   - Host: RDS Endpoint
   - Username: `admin`
   - Password: `redhat123`
   - After login: `USE myblog; SHOW TABLES;` (see WordPress tables like `wp_posts`).
2. Access WordPress site: `<EC2-IP>/admin` to log in and create posts.

## Summary

### Key Takeaways

```diff
+ Multi-tier architecture separates user interface, business logic, and data layers for better scalability and maintenance.
+ RDS simplifies database management compared to self-managed EC2 instances.
+ WordPress project demonstrates real AWS service integration (EC2 + RDS).
- Always secure RDS with private access; public access is educational only.
! Live URL access confirms end-to-end app functionality.
```

### Quick Reference

- **RDS Model ID**: KK-CS45-V3 (for tracking; model-powered assistance).
- **Commands**:
  - `aws configure`: Set up CLI access.
  - `aws ec2 run-instances --image-id ami-xxxxx --count 1`: CLI instance launch.
  - `sudo yum install httpd php-mysqli`: Install stack.
  - `mysql -h endpoint -u admin -p`: Connect to RDS MySQL.
- **Ports**: HTTP (80), HTTPS (443), SSH (22), MySQL (3306).
- **Files**: `/var/www/html/wp-config.php` (WordPress config).
- **Security Groups**: Inbound rules for app access.

### Expert Insight

**Real-world Application**: WordPress on EC2 + RDS suits small blogs; scale to EKS for high-traffic sites like Medium. Use in e-commerce for user data storage.

**Expert Path**: Master VPC networking, Lambda for serverless WordPress, and Aurora for advanced MySQL features. Practice migrations from self-hosted DBs to RDS.

**Common Pitfalls**: 
- Public RDS access leads to breaches; always use VPN or private subnets.
- Permission issues in `/var/www/html`; change ownership to `apache`.
- Version mismatches (PHP/MySQL); verify compatibility.
- Forget to update security groups; causes connectivity failures.

**Lesser-Known Facts**: RDS auto-gets SSL certificates; WordPress scales with plugins but watch RDS costs; non-relational DBs (e.g., DynamoDB) handle docs differently.

**Advantages**: Managed RDS reduces admin overhead; multi-tier scales better than monolithic apps.

**Disadvantages**: RDS vendor lock-in; higher costs for reserved instances; initial setup time longer than vertical stacks.
