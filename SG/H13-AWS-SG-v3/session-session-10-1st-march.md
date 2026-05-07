# Session 10: AWS EC2, IAM Roles, and System Manager

## Table of Contents
- [EC2 Instance Launch and Configuration](#ec2-instance-launch-and-configuration)
- [Centralized Management and Automation Needs](#centralized-management-and-automation-needs)
- [Introduction to IAM Roles](#introduction-to-iam-roles)
- [Understanding System Manager (SSM)](#understanding-system-manager-ssm)
- [Setting Up SSM Agent and Roles](#setting-up-ssm-agent-and-roles)
- [Remote Execution with SSM](#remote-execution-with-ssm)
- [Practical Demos](#practical-demos)
- [Summary](#summary)

## EC2 Instance Launch and Configuration
### Overview
Amazon Elastic Compute Cloud (EC2) is a fundamental AWS service that provides virtual servers in the cloud, allowing users to launch and manage instances without worrying about underlying hardware. This session begins with the basics of launching EC2 instances, focusing on practical setup including regions, instance types, key pairs, and security configurations. Attendees from AWS CSA, Developer, Enablement tracks participated, highlighting common concepts.

### Key Concepts / Deep Dive
- **EC2 Responsibilities**: AWS provides the compute instances, while users manage the operating system configuration.
- **Instance Launch Process**:
  - Select region (e.g., Virginia for U.S., Hyderabad for Asia-Pacific).
  - Choose AMI (e.g., Amazon Linux 2 for free tier).
  - Instance Types: T3 Micro (recommended free tier, 1 vCPU, 1 GB RAM); note regional differences (T2 Micro not available in all regions).
  - Key Pairs: Asymmetric cryptography for SSH access; region-specific, generated per region.
  - Security Groups: Firewall rules; allow HTTP/HTTPS for web servers (e.g., inbound rules for web traffic).
- **Post-Launch Management**: Access via EC2 Connect or SSH; run commands like `date`, `ls`, `mkdir` for OS management.
- **Real-World Application**: Launch instances for development servers, web hosting, or application testing.

### Code/Config Blocks
- Launch command simulation (EC2 Console steps):
  ```bash
  # Not executable, but steps include:
  # 1. Search EC2 in AWS Console
  # 2. Launch Instances > Name: "LinuxWorldOS1"
  # 3. AMI: Amazon Linux 2
  # 4. Instance Type: t3.micro
  # 5. Key Pair: Create "key_aws_hyderabad"
  # 6. Security Groups: Allow HTTP (port 80) from anywhere
  # 7. Launch Instances (multiple: OS1, OS2)
  ```
- SSH Login (if enabled):
  ```bash
  ssh -i key_aws_hyderabad.pem ec2-user@<public-ip>
  ```

### Lab Demos
- Demonstrated launching EC2 instances in Hyderabad and Virginia regions.
- Showed key pair creation and instance initialization.

## Centralized Management and Automation Needs
### Overview
Manual OS management via individual SSH logins becomes inefficient at scale; automation and centralized management are essential for backups, patching, updates, and configurations across hundreds of instances.

### Key Concepts / Deep Dive
- **Manual vs. Automation**:
  - Manual: SSH into each instance, run commands (e.g., `apt update`, `yum install httpd`).
  - Automation: Use scripts or tools for bulk operations.
- **Challenges**: Passwords, private keys, RDP vs. SSH differences, no management without access.
- **Tools Mentioned**: Third-party like Ansible (push mechanism) vs. AWS native System Manager (pull mechanism).

### Code/Config Blocks
- Manual Directory Creation:
  ```bash
  mkdir /women_react
  ```

### Lab Demos
- Simulated managing multiple instances (impossible manually for 100+ servers); introduced need for tools like Ansible or AWS System Manager.

## Introduction to IAM Roles
### Overview
AWS Identity and Access Management (IAM) handles permissions securely. When services need to interact (e.g., EC2 accessing S3), use roles instead of access keys for secure, delegated access.

📝 **Correction Note**: Transcript references "AM service" – corrected to "IAM service" (Identity and Access Management).

### Key Concepts / Deep Dive
- **Authentication vs. Authorization**:
  - Authentication: Login/password (users from outside); access/secret keys (programs/APIs).
  - Authorization: Policies granting permissions (e.g., S3 full access).
- **IAM Components**: Users, groups, roles, policies.
- **Roles for Services**: Pod (provider, agent) to grant permissions to other services without credentials.
- **EC2-S3 Role Example**: Attach role to EC2 instance allowing S3 access; no keys needed inside the instance.

### Code/Config Blocks
- IAM Role Creation Steps:
  ```json
  // Example Policy for EC2 to S3 Full Access
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "s3:*"
        ],
        "Resource": "*"
      }
    ]
  }
  ```
- Attach Role to EC2:
  ```bash
  # Actions > Security > Modify IAM Role > Select Role > Update IAM Role
  ```
- Test Inside Instance:
  ```bash
  aws s3 ls  # Should list buckets if role is attached
  ```

### Lab Demos
- Created role "EC2_Allow_S3_All" for EC2 to access S3.
- Attached role to instance; verified `aws s3 ls` works inside EC2 without keys.
- Explained pull vs. push mechanisms (roles allow internal access).

> [!IMPORTANT]
> Always use roles for cross-service access to maintain security without exposing credentials.

## Understanding System Manager (SSM)
### Overview
AWS Systems Manager (SSM) provides centralized management for EC2 instances (and on-premises), enabling remote execution, patching, and automation via a pull mechanism.

### Key Concepts / Deep Dive
- **SSM Subservices**: Run Command, Patch Manager, etc.
- **Architecture**:
  - Push: Manager sends commands to instances (e.g., Ansible).
  - Pull: Instances check SSM database for tasks; download and execute locally.
- **Benefits**: Manage without SSH/RDP; supports Linux/Windows/Mac; no credentials needed post-setup.

### Code/Config Blocks
- SSM Run Command:
  ```bash
  # Not direct, but via Console: Systems Manager > Run Command > Run Shell Script
  # Command: mkdir /demo_folder
  # Targets: Select Instances (must be registered)
  ```

### Lab Demos
- Attempted Run Command; failed due to no role/EC2 not registered.
- Introduced need for SSM Agent and role attachment.

## Setting Up SSM Agent and Roles
### Overview
SSM requires (1) SSM Agent on instances and (2) IAM role for access. Agent enables pull mechanism; role allows secure communication.

### Key Concepts / Deep Dive
- **SSM Agent**: Pre-installed on many AMIs; software that checks SSM for tasks.
- **Registration**: Agent contacts SSM to register instance for management.
- **Role Creation**: EC2 instance attaches role allowing SSM service access.
- **Troubleshooting**: If not working, restart agent (`sudo systemctl restart amazon-ssm-agent`); check logs (`/var/log/amazon/ssm/amazon-ssm-agent.log`).

### Code/Config Blocks
- IAM Role for SSM:
  ```json
  // Example: Full SSM Access
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ssm:*"
        ],
        "Resource": "*"
      }
    ]
  }
  ```
- Attach Role:
  ```bash
  # As above for EC2 instance
  ```
- Restart SSM Agent (if needed):
  ```bash
  sudo systemctl restart amazon-ssm-agent
  ```

### Lab Demos
- Attached SSM role to instances.
- Restarted SSM Agent; verified instances appear in SSM Run Command.
- Showed pull mechanism: Instances register and pull tasks.

## Remote Execution with SSM
### Overview
Use SSM Run Command for executing scripts remotely on registered instances.

### Key Concepts / Deep Dive
- **Run Command**: Select document (pre-built or custom); choose targets; execute.
- **Documents**: Automation scripts for common tasks (e.g., install software, create folders).
- **Parallel Execution**: Targets multiple instances simultaneously.

### Code/Config Blocks
- Create Folder Remotely:
  ```bash
  # Document: AWS-RunShellScript
  # Commands: mkdir /remote_folder
  # Targets: Registered EC2 Instances
  ```
- Install Apache Web Server:
  ```bash
  yum install -y httpd
  echo "Welcome to AWS" > /var/www/html/index.html
  systemctl start httpd
  systemctl enable httpd
  ```

### Lab Demos
- Ran `mkdir /tech_world` remotely on two instances.
- Installed Apache and created web page; verified via browser (requires open security groups).
- Demonstrated management without SSH logins.

## Practical Demos
### Overview
Hands-on demos reinforced concepts, including web server setup and lockout recovery.

### Key Concepts / Deep Dive
- **Web Server Setup**: Install Apache, create HTML file, start service.
- **SSH Lockout Recovery**: Stop SSH service (`sudo systemctl stop sshd`) but recover via SSM.
- **Real-World Use Cases**: Public-facing servers with SSH disabled for security; use SSM for maintenance.

### Lab Demos
- Configured web servers on two instances via SSM.
- Stopped SSH on instance; accessed and managed via SSM (e.g., create files, start SSH back).
- Showed pull mechanism advantages over Ansible's push.

> [!WARNING]
> Disabling SSH on public instances improves security but requires reliable alternatives like SSM for recovery.

## Summary
### Key Takeaways
```diff
+ Centralized Management: SSM enables secure, automated OS management without direct access.
+ IAM Roles: Secure cross-service access via roles, not credentials.
+ Pull Mechanism: Instances pull tasks from SSM, enhancing security and scalability.
- Manual Limitations: Inefficient for large-scale operations; prone to errors.
! Hybrid Support: SSM works on AWS EC2 and on-premises servers.
- SSH Reliance: Can be bypassed with SSM for hardened environments.
```

### Quick Reference
- **Launch EC2**: Minimal steps with AMI, instance type, key pair, security groups.
- **Create IAM Role**: Identify source service (e.g., EC2); attach policy for target (e.g., SSM/S3).
- **Setup SSM**: Attach role to instances; ensure SSM Agent runs; register via pull.
- **Run Command**: Systems Manager > Run Command > Select document > Choose targets > Execute.
- **Common Commands**:
  ```bash
  aws s3 ls                    # List S3 buckets (with role)
  systemctl status amazon-ssm-agent  # Check SSM Agent
  yum install -y httpd         # Install Apache
  ```

### Expert Insight
#### Real-World Application
- **Production Scaling**: Use SSM for patch management across 1000+ instances nightly, ensuring compliance without downtime.
- **Hybrid Environments**: Manage on-premises servers via SSM endpoints for unified IT operations.

#### Expert Path
- **Deepen IAM**: Master policies, conditions, and least-privilege; learn advancedroles like service-linked roles.
- **SSM Mastery**: Explore Patch Manager, Inventory, and integrations with Lambda/CloudWatch for automated workflows.
- **CLI Integration**: Combine AWS CLI with SSM for scripting complex automations.

#### Common Pitfalls
- **Missing Agent/Role**: Instances won't register – always verify SSM Agent logs and role attachments.
- **Security Gaps**: Over-permissive roles lead to breaches; use minimal policies (e.g., limit S3 buckets).
- **Region Misalignment**: Key pairs and roles are region-specific; ensure consistency.

#### Lesser-Known Facts
- **SSM Hybrid Mode**: Connect on-premises via VPN/Direct Connect; SSM acts as centralized ops for multi-cloud setups.
- **Agentless Alternatives**: For basic commands, use AWS Command Runner via EC2 Serial Console, but SSM offers richer automation.
- **Pull vs. Push**: SSM's pull prevents agent exposure; tools like Ansible require agent-side access, making SSM preferable for AWS-centric environments.
Advantages: Cost-effective (free tier), scalable, secure; supports diverse OS.
Disadvantages: Initial setup complexity; limited to AWS-compatible tasks; debugging requires logs from instances.
