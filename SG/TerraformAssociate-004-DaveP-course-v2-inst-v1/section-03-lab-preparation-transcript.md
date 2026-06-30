# Section 3: Lab Preparation

<details open>
<summary><b>Section 3: Lab Preparation (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents

- [3.1 Lab Preparation](#31-lab-preparation)
- [3.2 Creating a main.tf File](#32-creating-a-maintf-file)
- [3.3 Formatting Terraform Code](#33-formatting-terraform-code)
- [3.4 Initializing the Working Directory](#34-initializing-the-working-directory)
- [3.5 Validating Terraform Code](#35-validating-terraform-code)
- [3.6 Viewing the Terraform Plan](#36-viewing-the-terraform-plan)
- [3.7 Applying the Infrastructure to AWS](#37-applying-the-infrastructure-to-aws)
- [3.8 Analyzing the State File](#38-analyzing-the-state-file)
- [3.9 Destroying the Infrastructure](#39-destroying-the-infrastructure)

---

## 3.1 Lab Preparation

### Overview
This module provides essential pre-lab guidance for executing Terraform infrastructure deployment exercises, covering cost considerations, AWS pricing information, and important warnings about resource billing.

### Key Concepts

#### Lab Objectives
This lab demonstrates the complete Terraform workflow:
- **Write**: Creating Terraform configuration files
- **Plan**: Previewing infrastructure changes before execution
- **Apply**: Deploying infrastructure to AWS
- **Analyze**: Examining the generated state file
- **Destroy**: Cleaning up resources to avoid ongoing charges

#### Cost Considerations ⚠️

> [!IMPORTANT]
> Creating infrastructure on AWS or other cloud providers **can incur costs**. Always destroy infrastructure when finished to minimize billing.

**T2.micro Instance Pricing (US-East-2):**
- Approximately $0.0116 per hour (~1 cent/hour)
- All labs use T2.micro instances for minimal cost
- Infrastructure stops billing once terminated/destroyed

#### AWS Free Tier Information

**Free Tier Eligible AMIs:**
- Amazon Linux images are free tier eligible
- Debian, Ubuntu, and many others qualify
- New AWS accounts receive ~200 free tier hours
- Free tier eligibility expires after initial signup period

**Cost Management Tools:**
- **Amazon EC2 On-Demand Pricing**: Search by region, OS, and instance type
- **AMI Catalog**: Browse available machine images with free tier filter
- **AWS Pricing Calculator**: Estimate exact costs for your usage patterns
- **Free Tier Facts**: Additional program documentation

#### Important Reminders
```diff
! Always verify you want to incur charges before running terraform apply
! Always run terraform destroy when labs are complete
! Check AWS console to confirm resources are terminated
```

---

## 3.2 Creating a main.tf File

### Overview
This module walks through creating the primary Terraform configuration file (main.tf) that defines infrastructure using the standard three-block structure: terraform, provider, and resource blocks.

### Key Concepts

#### File Creation Process
1. Right-click working directory (lab-03) → New File
2. Name file: `main.tf`
3. VS Code automatically recognizes .tf extension and applies Terraform icon
4. Copy/paste provided code or type directly

#### Terraform Configuration Structure

**Three Essential Blocks:**
```hcl
# 1. Terraform Block - Provider Requirements
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.26"
    }
  }
  required_version = ">= 1.14.2"
}

# 2. Provider Block - AWS Configuration
provider "aws" {
  region = "us-east-2"
}

# 3. Resource Block - Infrastructure Definition
resource "aws_instance" "lab_03" {
  # Debian 13 instance
  ami           = "ami-[debian13-us-east2-id]"
  instance_type = "t2.micro"

  tags = {
    Name = "Lab 03"
  }
}
```

#### Provider Configuration Details

**Required Providers Section:**
- `source`: Identifies provider location in Terraform Registry (hashicorp/aws)
- `version`: Uses pessimistic constraint operator (~>)
  - `~> 6.26` means: major version locked at 6, minor version 26+
  - Allows 6.26 through 6.99, excludes version 7

**Provider Arguments:**
- `region`: Must match AMI region (us-east-2 recommended for labs)
- AMIs are region-specific; changing regions requires AMI change

#### Resource Naming Conventions

**Block Label Structure:**
```
resource "<provider>_<resource_type>" "<terraform_id>" {
```

**Best Practices:**
- Use underscores (`_`) not dashes (`-`) in Terraform IDs
- Example: `aws_instance.lab_03` (correct) vs `aws_instance.lab-03` (avoid)
- Terraform ID (`lab_03`) is arbitrary but descriptive

#### Code Comments
```hcl
# This is a comment using the hash/pound sign
```

---

## 3.3 Formatting Terraform Code

### Overview
This module covers the terraform fmt command for automatic code formatting and discusses HCL vs JSON file support in Terraform.

### Key Concepts

#### Indentation Standards
- **Terraform Standard**: 2 spaces (not 4)
- Consistent indentation improves readability
- Each nested block adds 2 additional spaces

**Proper Formatting Example:**
```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.26"
    }
  }
}
```

#### Using terraform fmt

**Command Execution:**
```bash
terraform fmt
```

**What terraform fmt fixes:**
- ✅ Incorrect indentation
- ✅ Spacing around equal signs
- ✅ Overall code structure

**What terraform fmt does NOT fix:**
- ❌ JSON syntax errors (commas at line ends)
- ❌ HCL syntax mistakes
- ❌ Missing quotes or braces

> [!NOTE]
> Commas are JSON syntax - they don't belong in HCL files

#### File Format Support

**Terraform Supports:**
| Format | Support | Notes |
|--------|---------|-------|
| `.tf` (HCL) | ✅ Full | Recommended format |
| `.tf.json` (JSON) | ✅ Full | More complex to write |
| `.txt` (Plain text) | ❌ Ignored | Terraform skips these files |

**Exam Alert:** Terraform supports HCL (HashiCorp Configuration Language) and JSON files only.

#### VS Code Terminal Configuration
- Disabling terminal suggestions: Settings → Terminal Suggest → Disable
- Use keyboard shortcuts (Ctrl+,) to access settings

---

## 3.4 Initializing the Working Directory

### Overview
This module demonstrates the terraform init command that prepares a working directory for Terraform operations by downloading providers and creating necessary files.

### Key Concepts

#### terraform init Process

**Initialization Stages:**
```bash
terraform init
```

**What terraform init does:**
1. **Initializes Backends**: Configures state storage (local by default)
2. **Downloads Provider Plugins**: Fetches from Terraform Registry
3. **Creates Lock File**: Records provider versions and hashes
4. **Verifies Dependencies**: Ensures all requirements are met

#### Provider Plugin Management

**Download Location:**
```
.terraform/providers/registry.terraform.io/hashicorp/aws/6.27/linux_amd64/
```

**Provider Binary Details:**
- AWS provider can exceed 500MB
- Signed by HashiCorp for authenticity
- Platform-specific (linux_amd64, darwin_amd64, etc.)

#### Terraform Lock File (.terraform.lock.hcl)

**Purpose:**
- Locks provider versions to prevent unexpected updates
- Contains cryptographic hashes for security
- Auto-generated and maintained by terraform init

**Key Sections:**
```hcl
provider "registry.terraform.io/hashicorp/aws" {
  version     = "6.27.0"
  constraints = "~> 6.26"
  hashes = [
    "h1:[linux_amd64_hash]",
    # Additional platform hashes...
  ]
}
```

**Critical Warning:** Never manually edit the lock file.

#### Backend Configuration
- **Local Backend** (default): State stored in working directory
- Creates `.terraform` hidden directory
- Suitable for development and learning

#### Initialization Output
```diff
+ Terraform has been successfully initialized!
+ You may now begin working with Terraform
+ Run "terraform plan" to see any changes
```

---

## 3.5 Validating Terraform Code

### Overview
This module covers the terraform validate command for catching syntax errors and configuration issues before planning or applying changes.

### Key Concepts

#### Running terraform validate

**Command:**
```bash
terraform validate
```

**Successful Output:**
```
Success! The configuration is valid.
```

#### Error Detection

**Common Issues Caught:**
- Unexpected commas in argument definitions
- Missing required arguments
- Invalid resource references
- Configuration syntax errors

**Example Error:**
```
Error: Unexpected comma after argument

  on main.tf line 9:
   9:   required_version = ">= 1.14.2",
```

**Error Indicators in VS Code:**
- 🔴 Red underlines under problematic code
- 🔴 Red highlighting in file explorer
- Hover tooltips with detailed explanations

#### Validation Best Practices

> [!IMPORTANT]
> Always validate before planning or applying to catch errors early

**Error Handling Flow:**
1. Write/Edit code
2. Run `terraform validate`
3. Fix any errors reported
4. Re-validate until success
5. Proceed to `terraform plan`

#### Benefits Over Plan/Apply
- Faster feedback than plan or apply
- No cloud API calls required
- Catches issues before any infrastructure changes
- Prevents failed apply operations

---

## 3.6 Viewing the Terraform Plan

### Overview
This module explores the terraform plan command that provides a preview of infrastructure changes without making any modifications.

### Key Concepts

#### terraform plan Execution

**Command:**
```bash
terraform plan
```

**Purpose:** Dry run that shows what will be created, modified, or destroyed

#### Plan Output Analysis

**Resource Naming in Plans:**
```
# aws_instance.lab_03 will be created
```

**Naming Convention:**
- Format: `<resource_type>.<terraform_id>`
- Example: `aws_instance.lab_03`
- Combines block label with Terraform ID using dot notation

**Color Coding:**
- 🟢 Green (+): Resources to be created
- 🟡 Yellow (~): Resources to be modified
- 🔴 Red (-): Resources to be destroyed

#### Known vs Unknown Values

**At Plan Time:**
```hcl
# Known from configuration
ami           = "ami-xxxxx"
instance_type = "t2.micro"
region        = "us-east-2"

# Unknown until apply
public_ip     = (known after apply)
private_ip    = (known after apply)
instance_id   = (known after apply)
```

#### Plan Summary
```
Plan: 1 to add, 0 to change, 0 to destroy
```

#### Saving Plans for Later
```bash
terraform plan -out=plan.tfplan
```
- Saves plan to file for later execution
- Useful for approval workflows
- Covered in detail later in course

#### Key Reminders
- Plan does NOT create infrastructure
- Always review plans before applying
- Provides last opportunity to verify changes

---

## 3.7 Applying the Infrastructure to AWS

### Overview
This module covers the terraform apply command that actually creates infrastructure on AWS, including console verification and troubleshooting tips.

### Key Concepts

#### terraform apply Process

**Command:**
```bash
terraform apply
```

**Execution Flow:**
1. Shows execution plan (same as terraform plan)
2. Prompts for confirmation: "Do you want to perform these actions?"
3. Requires typing `yes` (not just pressing Enter)
4. Creates resources via AWS API
5. Updates state file with results

#### Creation Monitoring

**Progress Indicators:**
```
aws_instance.lab_03: Creating...
aws_instance.lab_03: Still creating... [10s elapsed]
aws_instance.lab_03: Creation complete after 22s
```

**Typical Creation Time:** 10 seconds to 1 minute

#### AWS Console Verification

**Navigation Path:**
EC2 → Instances → [View instance details]

**Key Information to Verify:**
- Instance name matches tag
- Instance state: Running
- Instance type: t2.micro
- AMI matches configuration
- Region is correct

#### Troubleshooting Common Issues

**Instance Not Visible:**
```diff
- Most likely cause: Wrong AWS region selected
- Solution: Switch to us-east-2 in AWS console
```

**Missing VPC/Subnet:**
- Default VPC and subnet created automatically with new AWS account
- If missing, instructions available in repository
- Required for any EC2 instance deployment

#### Instance Details Viewable Post-Creation
- **Instance ID**: AWS-assigned unique identifier
- **Public IP**: Internet-facing address
- **Private IP**: Internal VPC address
- **DNS Names**: Public and private DNS entries
- **Availability Zone**: Specific AZ within region
- **Storage**: Root volume details (dev/xvda, 8GB)
- **Tags**: Key-value pairs including Name

#### Cost Reminder
```diff
! Monitor costs - t2.micro ≈ $0.01/hour
! Always verify instance is running as expected
! Destroy when lab complete to stop billing
```

---

## 3.8 Analyzing the State File

### Overview
This module examines the terraform.tfstate file that serves as the source of truth for all provisioned resources and their current attributes.

### Key Concepts

#### State File Fundamentals

**Exam Alert:** The state file represents a **source of truth** for resources provisioned with Terraform.

**File Location:** Working directory as `terraform.tfstate`
**Format:** JSON
**Purpose:** Tracks real-world resource attributes post-creation

#### State File Contents

**Metadata:**
- Terraform version used
- Provider configurations and versions
- Serialization format version

**Resource Information:**
```json
{
  "resources": [{
    "type": "aws_instance",
    "name": "lab_03",
    "provider": "provider[\"registry.terraform.io/hashicorp/aws\"]",
    "instances": [{
      "attributes": {
        "ami": "ami-xxxxx",
        "instance_type": "t2.micro",
        "id": "i-xxxxxxxxxxxxxxxxx",
        "public_ip": "X.X.X.X",
        "private_ip": "X.X.X.X",
        "availability_zone": "us-east-2a",
        "tags": {
          "Name": "Lab 03"
        }
      }
    }]
  }]
}
```

#### Information Captured Post-Apply

**AWS-Assigned Attributes:**
- Instance ID from AWS
- Availability Zone selection
- Public and private IP addresses
- DNS names
- Volume IDs and configurations
- Subnet assignments

#### State Storage Options

**Local Storage (Current):**
- Default behavior for CLI operations
- File: `terraform.tfstate`
- Single backup maintained: `terraform.tfstate.backup`

**Remote Storage (Production):**
- Terraform Cloud/Enterprise
- AWS S3, Azure Blob Storage
- On-premises servers with HashiCorp tools
- Enables team collaboration and state locking

#### State File Importance
- Tracks drift between configuration and reality
- Enables Terraform to manage existing resources
- Critical for planning and applying changes
- Should never be manually edited

---

## 3.9 Destroying the Infrastructure

### Overview
This module covers the terraform destroy command for safely removing all managed infrastructure and explains state file backup mechanisms.

### Key Concepts

#### terraform destroy Command

**Commands:**
```bash
terraform destroy
# OR
terraform apply -destroy
```

**Process:**
1. Refreshes state (compares state vs actual infrastructure)
2. Generates destruction plan
3. Requires explicit `yes` confirmation
4. Destroys all managed resources
5. Updates state to reflect destruction

#### State Refresh Mechanism

**What refresh does:**
- Compares state file against cloud resources
- Detects any drift or manual changes
- Ensures state accurately reflects reality
- Happens automatically before plan, apply, or destroy

#### When to Use terraform destroy

**Appropriate Uses:**
- Lab environments (to avoid charges)
- Temporary/testing infrastructure
- Complete environment teardown

**When NOT to Use:**
- Production environments with persistent resources
- Selective resource removal (remove from code instead)
- Long-term infrastructure

**Alternative for Selective Removal:**
1. Remove resource blocks from configuration
2. Run `terraform apply`
3. Only specified resources are destroyed

#### Destruction Output

**Plan Summary:**
```
Plan: 0 to add, 0 to change, 1 to destroy
```

**Progress:**
```
aws_instance.lab_03: Destroying... [id=i-xxxxx]
aws_instance.lab_03: Destruction complete after 30s
Destroy complete! Resources: 1 destroyed.
```

#### Post-Destruction Verification

**AWS Console:**
- Instance state changes to "terminated"
- Instance removed from list after short period
- No further billing occurs after termination

**State File Changes:**
```json
{
  "resources": []  // Empty - all resources destroyed
}
```

#### State File Backup System

**Files Maintained:**
- `terraform.tfstate`: Current state (empty after destroy)
- `terraform.tfstate.backup`: Last known good state

**Important Notes:**
- CLI maintains only ONE backup file
- Backup contains pre-destroy configuration
- For multiple backups, use remote state storage

#### Best Practices Summary
```diff
+ Always destroy lab infrastructure when complete
+ Verify destruction in AWS console
+ Keep backup file for reference if needed
- Never run destroy on production without careful planning
```

#### VS Code Configuration Tips

**Disabling Sticky Scroll:**
- Right-click sticky code area → Deselect "Sticky Scroll"
- Or: Settings → Search "Sticky Scroll" → Toggle off

**Path Trimming (bash):**
```bash
# Add to ~/.bashrc
PROMPT_DIRTRIM=1  # Shows only last directory in path

# Apply changes
source ~/.bashrc
```

---

## Summary

### Key Takeaways
```diff
+ Terraform workflow: write → plan → apply → analyze → destroy
+ Always use terraform validate before planning or applying
+ terraform plan shows changes without execution
+ State file is the source of truth for managed resources
+ Always destroy lab infrastructure to avoid charges
+ terraform fmt ensures consistent code formatting
+ Provider plugins are downloaded during terraform init
+ Use underscores in Terraform resource IDs
```

### Quick Reference

**Essential Commands:**
```bash
terraform init          # Initialize working directory
terraform fmt           # Format code
terraform validate      # Check for syntax errors
terraform plan          # Preview changes
terraform apply         # Create infrastructure
terraform destroy       # Remove all resources
```

**File Structure:**
```
lab-03/
├── main.tf              # Configuration file
├── terraform.tfstate    # Current state
├── terraform.lock.hcl   # Provider lock file
└── .terraform/          # Hidden provider directory
```

### Expert Insight

**Real-world Application:**
In production environments, you'll typically work with remote state storage, use workspaces for multiple environments, and implement CI/CD pipelines for Terraform execution. The destroy command is rarely used on production infrastructure.

**Expert Path:**
- Master state management and remote backends
- Learn about workspaces for environment isolation
- Explore Terraform Cloud/Enterprise features
- Implement state locking for team collaboration

**Common Pitfalls:**
- Forgetting to destroy lab resources (unexpected charges)
- Manually editing state files
- Using terraform destroy on production systems
- Not validating code before applying
- Ignoring region-specific AMI requirements

**Lesser-Known Facts:**
- The AWS provider binary can exceed 500MB
- Terraform supports both HCL and JSON configurations
- State refresh happens automatically before most operations
- Plan files can be saved and applied separately for approval workflows

</details>