# Section 4: Lab 04: AWS Configuration with Security Groups

<details open>
<summary><b>Section 4: Lab 04: AWS Configuration with Security Groups (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [4.1 Coding a main.tf File in VS Code](#41-coding-a-maintf-file-in-vs-code)
- [4.2 The Terraform Registry](#42-the-terraform-registry)
- [4.3 Validating and Creating Infrastructure](#43-validating-and-creating-infrastructure)
- [4.4 Destroying Infrastructure and Analysis](#44-destroying-infrastructure-and-analysis)
- [4.5 Quiz](#45-quiz)
- [Summary](#summary)

---

## 4.1 Coding a main.tf File in VS Code

### Overview
This module introduces Lab 04, which focuses on creating AWS infrastructure with security groups to enable SSH and HTTPS inbound access. Students will write Terraform configuration code, utilize VS Code extensions for code completion, implement security group rules as separate resources, and identify a common configuration issue that prevents SSH access.

### Lab Introduction and Objectives

**Lab Scenario**: Creating a single Ubuntu 24.04 EC2 instance with security groups allowing:
- Inbound SSH (port 22)
- Inbound HTTPS/TLS (port 443)
- Full outbound connectivity

**Key Differences from Previous Labs**:
- Using Ubuntu instead of Debian (requires different AMI)
- Implementing security groups for controlled access
- Less specific instructions to reinforce Terraform workflow commands

**Lab Workflow**:
1. Write code in main.tf using VS Code
2. Explore Terraform Registry for AWS security group documentation
3. Execute terraform workflow (init → validate → apply)
4. Analyze infrastructure in AWS console and state file
5. Attempt SSH connection (will fail due to configuration issue)
6. Destroy infrastructure

### VS Code Setup and Color Coding

**Color Theme Selection**:
- Press F1 and type "peacock" to access color theme selector
- Choose "Node Green" for Lab 04 differentiation
- Previous lab used yellow for visual distinction

### Working Directory Setup

**Opening Lab Directory**:
```bash
# Right-click on lab-04 directory in VS Code
# Select "Open in Integrated Terminal"
# Working directory shows: lab-04
```

**Creating main.tf File**:
```bash
touch main.tf
```

### Terraform Block Configuration

**Using VS Code Terraform Extension**:

The Terraform extension provides intelligent code completion:

1. **Creating Terraform Block**:
   - Type `ter` → Extension suggests "terraform" block
   - Press Tab to auto-generate block structure

2. **Required Providers Configuration**:
   ```hcl
   terraform {
     required_providers {
       aws = {
         source  = "hashicorp/aws"
         version = "~> 6.26"
       }
     }
     required_version = ">= 1.14.2"
   }
   ```

3. **Extension Features Demonstrated**:
   - Auto-completion for `required_providers`
   - Auto-insertion of quotes and equals signs
   - Version constraint syntax: `~> 6.26` (latest minor release of major version 6)

### Provider Block Configuration

**AWS Provider Setup**:
```hcl
provider "aws" {
  region = "us-east-2"
}
```

**AI Assistant Behavior**:
- GitHub Copilot and similar AI tools may suggest additional resources
- AI suggestions can be disabled after this lab if desired
- Alternative AI tools: AWS Q/Amazon Q may also provide suggestions

### Resource Configuration

**EC2 Instance Resource** (Copied from code.txt):
```hcl
resource "aws_instance" "lab04" {
  ami                    = "ami-0c7217cdde317cfec"  # Ubuntu 24.04
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id, aws_security_group.allow_tls.id]

  tags = {
    Name = "Lab04-Ubuntu"
  }
}
```

**Security Group Resources**:

1. **SSH Security Group**:
   ```hcl
   resource "aws_security_group" "allow_ssh" {
     name        = "allow_ssh"
     description = "Allow SSH inbound traffic"

     tags = {
       Name = "allow_ssh"
     }
   }

   resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
     security_group_id = aws_security_group.allow_ssh.id
     cidr_ipv4         = "0.0.0.0/0"
     from_port         = 22
     ip_protocol       = "tcp"
     to_port           = 22
   }
   ```

2. **TLS/HTTPS Security Group**:
   ```hcl
   resource "aws_security_group" "allow_tls" {
     name        = "allow_tls"
     description = "Allow TLS inbound traffic"

     tags = {
       Name = "allow_tls"
     }
   }

   resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
     security_group_id = aws_security_group.allow_tls.id
     cidr_ipv4         = "0.0.0.0/0"
     from_port         = 443
     ip_protocol       = "tcp"
     to_port           = 443
   }
   ```

3. **Egress Security Group** (Outbound):
   ```hcl
   resource "aws_security_group" "egress" {
     name        = "egress"
     description = "Allow all outbound traffic"

     tags = {
       Name = "egress"
     }
   }

   resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
     security_group_id = aws_security_group.egress.id
     cidr_ipv4         = "0.0.0.0/0"
     ip_protocol       = "-1"  # -1 means all protocols
   }
   ```

### Important Configuration Concepts

**Security Group ID Reference Pattern**:
```hcl
vpc_security_group_ids = [
  aws_security_group.allow_ssh.id,
  aws_security_group.allow_tls.id
]
```

**List Syntax Requirements**:
- Square brackets `[]` denote a list
- Comma required after each item except the last
- Must reference complete resource address including `.id`

**Identified Configuration Issue**:
- Egress security group created but NOT referenced in instance
- This prevents outbound connectivity including SSH response packets
- Will be fixed in subsequent lab

### Key Takeaways from Module 4.1

> [!IMPORTANT]
> Security groups must be explicitly referenced in `vpc_security_group_ids` to be applied to an instance

> [!NOTE]
> Each security group and rule counts as a separate resource in Terraform

---

## 4.2 The Terraform Registry

### Overview
This module demonstrates how to navigate the Terraform Registry to find documentation for AWS provider resources, specifically security groups. It emphasizes the importance of avoiding hardcoded credentials and understanding provider documentation structure.

### Accessing the Terraform Registry

**Registry URL**: https://registry.terraform.io/providers/hashicorp/aws/latest/docs

**Provider Documentation Structure**:
- Example usage patterns
- Important warnings and notes
- Comprehensive resource listings
- Filtering capabilities for finding specific resources

### Security Awareness

**Critical Warning - Hardcoded Credentials**:
```hcl
# ❌ NEVER DO THIS - Security Risk!
provider "aws" {
  access_key = "AKIAIOSFODNN7EXAMPLE"
  secret_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
  region     = "us-east-2"
}
```

**Recommended Approach**:
- Use AWS CLI configuration (as done in this course)
- Environment variables
- IAM roles for EC2
- AWS Secrets Manager or similar services

### Finding Security Group Documentation

**Search Strategy**:
1. Type "aws" → 2,250 results
2. Add "_security" → 49 results
3. Add "_group" → 34 results
4. Navigate to Resources → VPC Resources

**Relevant Resources Found**:
- `aws_security_group` - Creates security groups
- `aws_security_group_rule` - Legacy rule management
- `aws_vpc_security_group_ingress_rule` - Modern ingress rules
- `aws_vpc_security_group_egress_rule` - Modern egress rules

### Documentation Analysis

**Key Documentation Notes**:
- Avoid using `ingress` and `egress` arguments directly in `aws_security_group`
- Use separate rule resources for better management
- Each approach has different implications for rule management

**Documentation Example** (from Registry):
```hcl
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}
```

### Best Practices for Using Registry

1. **Always Read Warnings**: Critical security and best practice information
2. **Filter Effectively**: Use search to narrow down relevant resources
3. **Check Examples**: Registry provides working code examples
4. **Understand Version Differences**: Documentation is version-specific

---

## 4.3 Validating and Creating Infrastructure

### Overview
This module walks through the complete Terraform workflow to initialize, validate, and create AWS infrastructure with security groups. It covers the execution order, state file analysis, and identifies why SSH access fails despite security group configuration.

### Terraform Workflow Execution

**Step 1: Initialization**
```bash
terraform init
```
- Downloads HashiCorp AWS provider v6.27
- Creates `.terraform.lock.hcl` file
- Success message: "Terraform has been successfully initialized"

**Step 2: Code Formatting**
```bash
terraform fmt
```
- Automatically formats code according to HCL standards
- Only reports files that were modified
- Run again to confirm: no output means formatting is complete

**Step 3: Validation**
```bash
terraform validate
```
- Checks for syntax errors
- Success message: "Success! The configuration is valid"
- Green output indicates valid configuration

**Step 4: Apply Infrastructure**
```bash
terraform apply
```

### Apply Process Analysis

**Resources Being Created** (6 total):
1. `aws_security_group.allow_ssh`
2. `aws_security_group.allow_tls`
3. `aws_security_group.egress`
4. `aws_vpc_security_group_ingress_rule.allow_ssh_ipv4`
5. `aws_vpc_security_group_ingress_rule.allow_tls_ipv4`
6. `aws_instance.lab04`

**Creation Order**:
1. Security groups created first
2. Ingress/egress rules created second
3. EC2 instance created last (requires security groups to exist)

**Terraform's Dependency Resolution**:
- Automatically determines correct creation order
- Security groups must exist before rules can reference them
- Instance must be created after firewall rules are in place

### AWS Console Verification

**EC2 Instance Details**:
- Instance ID assigned
- Public IP address allocated
- Security groups attached: allow_tls, allow_ssh

**Security Group Rules Verified**:
- Inbound: Port 443 (TLS) ✓
- Inbound: Port 22 (SSH) ✓
- Outbound: Not displayed initially

### State File Analysis

**State File Location**: `terraform.tfstate`

**Key Information Stored**:
- All 368 lines of JSON state data
- Complete resource attributes
- Security group IDs and configurations
- Instance details and network information

**State File Importance**:
> [!IMPORTANT]
> The state file is Terraform's source of truth for what exists in AWS

**State File Protection**:
- Never manually edit terraform.tfstate
- Prevent team members from modifying AWS resources outside Terraform
- Manual changes cause state drift and errors

### SSH Connection Attempt

**Connection Command**:
```bash
ssh ubuntu@<public-ip-address>
```

**Error Analysis**:
```
Permission denied (publickey)
```

**Two Reasons for SSH Failure**:
1. **Missing SSH Key Pair**: No public key configured for instance
2. **Missing Egress Rule Reference**: Instance doesn't reference egress security group

**Code Issue Identified**:
```hcl
# Current (missing egress)
vpc_security_group_ids = [
  aws_security_group.allow_ssh.id,
  aws_security_group.allow_tls.id
]

# Should include:
vpc_security_group_ids = [
  aws_security_group.allow_ssh.id,
  aws_security_group.allow_tls.id,
  aws_security_group.egress.id  # Missing!
]
```

> [!NOTE]
> Without egress rules, the instance cannot send response packets for SSH connections

---

## 4.4 Destroying Infrastructure and Analysis

### Overview
This module covers the infrastructure destruction process, demonstrates proper cleanup procedures, and shows how to disable AI assistance features in VS Code for future work.

### Disabling AI Suggestions

**GitHub Copilot Settings**:
1. Hover over Copilot icon in VS Code
2. Navigate to "Inline Suggestions"
3. Select "Don't Show" for all files
4. Alternative: Configure per file type (Terraform files only)

### Terraform Destroy Process

**Destruction Command**:
```bash
terraform destroy
```

**Destruction Order** (Reverse of Creation):
1. Ingress/Egress rules destroyed first
2. Security groups destroyed second
3. EC2 instance destroyed last

**Verification Steps**:
```bash
# Check AWS Console
# Refresh EC2 instances
# Status should show: terminated

# Check state file
cat terraform.tfstate
# Should show minimal/null state
```

**Backup State File**:
- `terraform.tfstate.backup` preserves last known good configuration
- Useful for recovery or reference purposes

### AWS Billing Considerations

**Cost Management**:
- Always destroy infrastructure when labs are complete
- Check both EC2 and VPC sections for lingering resources
- Security groups may persist in VPC console after EC2 termination

> [!WARNING]
> Remember to destroy all lab infrastructure to avoid unexpected AWS charges

---

## 4.5 Quiz

### Overview
This module tests understanding of Terraform validation commands and the importance of initialization before validation.

### Question 1: Syntax Validation

**Question**: You want to check the syntactical correctness of your Terraform code. Which command should you use?
- A) terraform fmt
- B) terraform show
- C) terraform validate ✓
- D) terraform check

**Answer**: C) terraform validate

**Explanation**:
- `terraform validate` checks for syntax errors before planning
- Alternative commands that also check syntax:
  - `terraform plan`
  - `terraform apply`
- `terraform fmt` handles formatting only
- `terraform show` displays state file contents
- No `terraform check` command exists

### Question 2: Provider Initialization

**Question**: You run `terraform validate` but receive "Error: missing required provider". What did you forget?
- A) terraform apply
- B) terraform get
- C) terraform init ✓
- D) terraform graph

**Answer**: C) terraform init

**Explanation**:
- `terraform init` downloads provider plugins
- Without initialization, no providers exist in workspace
- `terraform get` downloads modules only
- `terraform graph` creates dependency visualizations
- Error message will suggest running `terraform init`

### Command Reference Summary

| Command | Purpose | When to Use |
|---------|---------|-------------|
| `terraform init` | Initialize workspace, download providers | First step, after adding providers |
| `terraform fmt` | Format code | After writing/editing code |
| `terraform validate` | Check syntax | Before plan/apply |
| `terraform plan` | Preview changes | Review before applying |
| `terraform apply` | Create/modify infrastructure | When ready to deploy |
| `terraform destroy` | Remove all resources | Lab cleanup, environment teardown |

---

## Summary

### Key Takeaways

```diff
+ Security groups and rules are separate resources in Terraform
+ Always use terraform init before validate when adding new providers
+ State file is the source of truth - protect it from manual edits
+ Egress rules are required for instances to send outbound traffic
+ terraform validate checks syntax; terraform fmt handles formatting only
- Never hardcode AWS credentials in Terraform configuration
- Don't skip terraform destroy after completing labs
- Reference ALL required security groups in vpc_security_group_ids
```

### Quick Reference

**Essential Workflow Commands**:
```bash
terraform init      # Initialize and download providers
terraform fmt       # Format code
terraform validate  # Check syntax
terraform apply     # Create infrastructure
terraform destroy   # Remove infrastructure
```

**Security Group Pattern**:
```hcl
# 1. Create security group
resource "aws_security_group" "example" { ... }

# 2. Create ingress/egress rules
resource "aws_vpc_security_group_ingress_rule" "example" { ... }

# 3. Reference in instance
resource "aws_instance" "example" {
  vpc_security_group_ids = [aws_security_group.example.id]
}
```

### Expert Insights

**Real-world Application**:
- Separate security group rules improve manageability in large infrastructures
- Always implement least-privilege access (specific ports/sources)
- Use data sources to reference existing security groups in production
- Implement state file encryption and remote backends for team collaboration

**Expert Path**:
- Master security group rule ordering and dependencies
- Learn about security group rule descriptions and tags
- Explore VPC endpoints and private connectivity patterns
- Practice with dynamic blocks for complex rule sets

**Common Pitfalls**:
- Forgetting to reference security groups in instance configuration
- Creating circular dependencies between security groups
- Not accounting for ephemeral ports in egress rules
- Hardcoding sensitive values instead of using variables

**Lesser-Known Facts**:
- Security group rules have soft limits (60 rules per group by default)
- Egress rules default to allow-all if none specified
- Security group IDs are unique per VPC, not per account
- Rule descriptions were added in newer provider versions

</details>