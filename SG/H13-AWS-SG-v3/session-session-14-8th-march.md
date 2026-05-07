# Session 14: AWS CLI Deep Dive

## Table of Contents
- [Overview](#overview)
- [Key Concepts](#key-concepts)
  - [Why Use AWS CLI?](#why-use-aws-cli)
  - [Installing AWS CLI](#installing-aws-cli)
  - [AWS Configure and Profiles](#aws-configure-and-profiles)
  - [Managing Multiple Accounts](#managing-multiple-accounts)
  - [Creating Key Pairs](#creating-key-pairs)
  - [Creating Security Groups](#creating-security-groups)
  - [Launching EC2 Instances with CLI](#launching-ec2-instances-with-cli)
  - [User Data in CLI](#user-data-in-cli)
  - [General Approach to Learning CLI](#general-approach-to-learning-cli)
- [Lab Demos](#lab-demos)
  - [Creating a Key Pair](#creating-a-key-pair)
  - [Creating Security Group with HTTP Rule](#creating-security-group-with-http-rule)
  - [Launching an EC2 Instance](#launching-an-ec2-instance)
- [Summary](#summary)
  - [Key Takeaways](#key-takeaways)
  - [Quick Reference](#quick-reference)
  - [Expert Insight](#expert-insight)

## Overview
This session provides a deep dive into AWS Command Line Interface (CLI), building on basic introductions to demonstrate real-world DevOps and automation scenarios. The instructor explains how CLI enables faster, scriptable operations compared to the graphical console, emphasizing its role in productive workflows. Key topics include profile management for multi-account setups, security configurations like key pairs and security groups, and EC2 instance provisioning via CLI commands. The session follows a systematic approach: learn AWS services graphically first, then translate configurations to CLI using built-in help functions. Demos illustrate creating resources (key pairs, security groups) and launching instances with automation scripts in user data, showcasing production-ready deployment techniques.

## Key Concepts

### Why Use AWS CLI?
AWS CLI serves as a textual interface to manage AWS cloud resources, offering alternatives to the graphical console and APIs.

- **Console Limitations**: Better for basic, one-off tasks like quick checks or minor changes. Inefficient for repetitive actions due to mouse-based navigation.
- **CLI Advantages**: Enables automation, scripting (e.g., in Python with Boto3 for API integration, or shell scripts), and batch operations. Ideal for DevOps engineers handling infrastructure at scale.
- **API Role**: Complements CLI for custom applications (mobile/web apps) needing programmatic AWS access. Boto3 library is highlighted for developer tracks.
- **Three Access Methods Overview**:
  - Web Console: Visual, user-friendly for beginners.
  - CLI: Scripting-friendly, faster for technical users.
  - API: Programmatic integration for app development.

CLI installation is straightforward: Download from AWS website for Windows, macOS, or Linux, then run the installer.

### Installing AWS CLI
AWS CLI is available for major operating systems.

1. Visit the AWS CLI download page.
2. Select your OS (Windows/Mac/Linux).
3. Download the installer and execute it.
4. Restart your command prompt/terminal; `aws` command becomes available.

After installation, verify with `aws --version`. No tedious setup required—minimal friction for quick starts.

### AWS Configure and Profiles
AWS CLI requires authentication via keys (access key/secret key) instead of console login passwords.

- **aws configure**: Initializes CLI login. Prompts for:
  - Access Key ID (unique identifier, internally linking to account/project/permissions).
  - Secret Access Key (confidential, validates access key ownership).
  - Default Region (e.g., ap-south-1 for Mumbai; affects all commands if not overridden).
  - Output Format (text/JSON/table; e.g., JSON for structured data).

Credentials are profile-based for flexibility.

- **Profiles**: Stored locally (e.g., `~/.aws/credentials` on Unix/Mac, or Windows AWS folder).
  - Contain account details, keys, and permissions.
  - Allow switching between accounts/projects without re-entering credentials.
  - Syntax: `aws <command> --profile <profile-name>`
  - Default profile used if none specified.

Profiles enable managing multiple AWS accounts/workspaces from one machine, proving essential for multi-environment (dev/test/prod) ops.

### Managing Multiple Accounts
Profiles handle diverse account needs.

- **Use Cases**: Separate profiles for personal accounts, company environments (e.g., Linux World company, XYZ company), or internal vs. external projects.
- **Key Differentiation**: Access keys encode account/permissions. One key per unique account/permission set.
- **Profile Creation**: Run `aws configure --profile <name>`, then enter keys/region/output.
- **Storage Security**: Credentials stored in plaintext locally—highly sensitive. Never share; physical machine security critical.
- **Switching**: Append `--profile <name>` to any command for targeted account execution.

This architecture supports cloud admins spanning multiple accounts without separate workstations.

### Creating Key Pairs
Key pairs enable secure SSH login to EC2 instances (replaces passwords).

- **Formats**: PEM (SSH-compatible) or PPK (PuTTY-compatible for Windows users).
- **CLI Command**: `aws ec2 create-key-pair --key-name <name> --query 'KeyMaterial' --output text > <filename.pem>`
  - Downloads private key locally for SSH access.
  - If creating for PuTTY, specify `--key-format ppk`.

Pre-create keys before launching instances; select existing ones in console or run `aws ec2 describe-key-pairs` to list.

### Creating Security Groups
Security groups act as firewalls for inbound/outbound traffic.

- **Concepts**: Virtual firewalls—deny by default; rules allow specific traffic.
  - **Inbound Rules**: Control access to instances (e.g., allow HTTP from internet).
  - **Port/Protocol**: HTTP uses TCP on port 80.
  - **Sources**: `0.0.0.0/0` (all internet) for public web servers.

- **CLI Workflow**:
  1. Create group: `aws ec2 create-security-group --group-name <name> --description "<desc>"`
  2. Add rules: `aws ec2 authorize-security-group-ingress --group-id <id> --protocol tcp --port 80 --cidr 0.0.0.0/0`

Always create security groups before launching instances. Use `aws ec2 describe-security-groups` to list IDs/names.

### Launching EC2 Instances with CLI
EC2 instance creation via CLI mirrors console steps.

- **Key Parameters** (mapped from console config):
  - **Image ID (AMI)**: Unique ID for OS (e.g., ami-0abcdef123456789). Use `aws ec2 describe-images` or console IDs.
  - **Instance Type**: e.g., t2.micro.
  - **Key Name**: Pre-created key pair name.
  - **Security Group**: ID or name of pre-created group.
  - **Subnet ID**: For specific AZ (e.g., ap-south-1b).
  - **Count**: Number of instances (e.g., 1).
  - **User Data**: Script file for boot-time automation (e.g., web server setup).

Command: `aws ec2 run-instances --image-id <ami> --instance-type <type> --key-name <key> --security-group-ids <id> --subnet-id <subnet> --user-data file://<script.sh> --count 1`

Outputs instance details (e.g., IDs, IPs) immediately post-launch.

### User Data in CLI
Automates instance boot-time configurations.

- **Purpose**: Run scripts (e.g., Bash) immediately after launch for software installation, service starts, or content placement.
- **Example Script**: Install web server, create HTML content, enable/start services.
- **CLI Integration**: Pass via `--user-data file://<path/to/script>` (local file reference).

Matches console user data uploads for reproducible, automated deployments.

### General Approach to Learning CLI
To effectively use CLI:

1. **Master Concepts Graphically**: Perform tasks in AWS Console first. Collect settings (e.g., AMI, instance type, keys, rules).
2. **Translate to CLI**:
   - Start with `aws <service> <subcommand> help` for available commands (e.g., `aws ec2 run-instances help`).
   - Map console steps to CLI options/parameters.
3. **Use Profiles**: Manage regions/accounts/permissions consistently.
4. **Scripting Benefits**: Combine commands for automation/multi-account deployments.

This method avoids memorization, focusing on understanding AWS services.

## Lab Demos

### Creating a Key Pair
```bash
aws ec2 create-key-pair --key-name aws-cli-test-key --query 'KeyMaterial' --output text --profile my-lw > aws-cli-test-key.pem
```
- Creates key in Myanmar region (via profile).
- Private key saved locally for SSH.
- Verify in Console under EC2 > Key Pairs.

### Creating Security Group with HTTP Rule
```bash
# Create group
aws ec2 create-security-group --group-name linux-world-http-allow --description "Allow HTTP for web server" --profile my-lw

# Add HTTP ingress rule
aws ec2 authorize-security-group-ingress --group-id sg-1234567890abcdef0 --protocol tcp --port 80 --cidr 0.0.0.0/0 --profile my-lw
```
- Group ID output from create command.
- Allows public HTTP access; instance traffic filtered by group.
- Check in Console: EC2 > Security Groups > Rules tab.

### Launching an EC2 Instance
Create `user-data-script.sh` locally:
```bash
#!/bin/bash
yum update -y
yum install -y httpd
echo "<h1>Welcome to Linux World Web Server</h1>" > /var/www/html/index.html
systemctl start httpd
systemctl enable httpd
```

Then run:
```bash
aws ec2 run-instances --image-id ami-0abcdef1234567890 --instance-type t2.micro --key-name aws-cli-test-key --security-group-ids sg-1234567890abcdef0 --subnet-id subnet-12345678 --user-data file://user-data-script.sh --count 1 --profile my-lw
```
- Launches instance with web server auto-setup.
- Access via public IP (from instance details) on port 80.
- Verifies in Console: EC2 > Instances (check state, security group, key, AMI, subnet).

## Summary

### Key Takeaways

> [!IMPORTANT]  
> CLI complements Console/API by enabling scripted, automated AWS management—essential for DevOps scaling repetitive tasks across accounts/environments.

```diff
+ CLI excels for automation: Combine commands into scripts for multi-account deployments (change --profile).
- Console for quick visual checks: Not ideal for batch/production ops.
! Profiles manage complexity: Security-critical (local credential storage)—lock workstations.
+ User data automates boot: Production-ready for consistent setups (e.g., web servers).
```

### Quick Reference
- **Install CLI**: Download from aws.amazon.com/cli, install per OS.
- **Configure Profile**: `aws configure --profile <name>`
- **Create Key Pair**: `aws ec2 create-key-pair --key-name <name> --query 'KeyMaterial' --output text > <file.pem>`
- **Create Security Group**: `aws ec2 create-security-group --group-name <name> --description "<desc>"`
- **Add SG Rule**: `aws ec2 authorize-security-group-ingress --group-id <id> --protocol tcp --port 80 --cidr 0.0.0.0/0`
- **List Resources**: `aws ec2 describe-key-pairs`, `aws ec2 describe-security-groups`, `aws ec2 describe-images`
- **Launch Instance**: `aws ec2 run-instances --image-id <ami> --instance-type t2.micro --key-name <key> --security-group-ids <sg-id> --subnet-id <subnet> --user-data file://<script.sh> --count 1 --profile <profile>`

### Expert Insight

#### Real-World Application
Automate multi-environment deployments: E.g., script CLI commands to provision identical infra in dev/test/prod accounts by switching profiles. Integrate with CI/CD (e.g., Jenkins) for serverless/Lambda triggers or EC2 scaling—replacing manual console clicks with reliable, version-controlled scripts.

#### Expert Path
Master Boto3 (Python SDK) for advanced CLI automation/scripting. Dive into awless (third-party tool) for simpler syntax. Practice CLI equivalents for all learned services (S3, IAM, Lambda)—treat Console as concept-learning tool, CLI as production interface. Learn Bash/Python scripting for error handling/loops in CLI pipelines.

#### Common Pitfalls
- **Profile Overload**: Forgetting --profile leads to wrong account/region—always specify for multi-env setups.
- **Plaintext Credentials**: Local storage risks theft; use IAM roles/EC2 instance profiles for server-based CLI to avoid key exposure.
- **ID vs. Name Mixing**: CLI often requires IDs (e.g., AMI, Subnet) over names—fetch via describe commands to avoid mismatches.
- **User Data Paths**: Absolute paths needed (file:// for local files); script failures silent—log outputs for debugging.

#### Lesser-Known Facts
CLI caches responses briefly (~15m), improving repeated query speeds. JSON output supports piping to tools like jq for parsing (e.g., filter instance IPs). AWS CLI v2 adds auto-prompts/interactive modes—experiment with --cli-auto-prompt for guided commands. Behind scenes, CLI calls AWS APIs—with appropriate creds, it's as secure/powerful as console, but programmable for infra-as-code.
