# Section 15: Terraform Advanced Features

<details open>
<summary><b>Section 15: Terraform Advanced Features (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [15.1 Locals](#151-locals)
- [15.2 Dynamic Blocks](#152-dynamic-blocks)
- [15.3 Data Blocks](#153-data-blocks)
- [15.4 Version Constraints](#154-version-constraints)
- [15.5 Credentials Best Practices](#155-credentials-best-practices)
- [15.7 Refactoring Terraform State](#157-refactoring-terraform-state)
- [15.8 Using Multiple Workspaces – Part 1](#158-using-multiple-workspaces--part-1)
- [15.9 Using Multiple Workspaces – Part 2](#159-using-multiple-workspaces--part-2)
- [15.10 More Terraform Environment Variables](#1510-more-terraform-environment-variables)
- [15.11 Quiz](#1511-quiz)
- [Summary](#summary)

---

## 15.1 Locals

### Overview
Local values assign names to expressions, allowing reuse throughout a module instead of repeating expressions. Locals are similar to variables but are designed for values that don't change, making configurations more readable and maintainable.

### Key Concepts

#### Creating Locals Blocks
Locals are defined using the `locals` block (plural) and referenced as `local` (singular):

```hcl
locals {
  accounts = toset([
    "alice",
    "bob",
    "charlie",
    "denise"
  ])

  common_tags = {
    department = "engineering"
    environment = "production"
    managedby = "terraform"
  }
}
```

#### Locals vs Variables

| Feature | Locals | Variables |
|---------|--------|-----------|
| Defined in | Main Terraform files | variables.tf |
| Change frequency | Rarely/Never | Frequently |
| Purpose | Internal expressions | External input |
| Modification method | Code changes required | TF vars, CLI, environment |

#### Using Locals with Resources

```hcl
resource "aws_iam_user" "team_members" {
  for_each = local.accounts
  name     = each.key

  tags = local.common_tags
}
```

### Important Notes
- Locals blocks can contain lists, maps, and references to variables
- Place locals blocks at the top of the file for clarity
- Use `local.` (singular) when referencing, not `locals.`
- Common use cases: port numbers, tags, usernames, and reusable expressions

---

## 15.2 Dynamic Blocks

### Overview
Dynamic blocks programmatically generate repeatable nested configuration blocks within resources, data sources, providers, or provisioners based on a collection of input data.

### Key Concepts

#### Structure of Dynamic Blocks
Dynamic blocks are nested within resources and typically work with locals:

```hcl
locals {
  inbound_ports = [80, 443]
  outbound_ports = [443, 1433]
}

resource "aws_security_group" "sg_web_server" {
  name = "web-server-sg"

  dynamic "ingress" {
    for_each = local.inbound_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {
    for_each = local.outbound_ports
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
```

### Use Cases
- Security group rules (ingress/egress)
- Any repeatable nested block configuration
- Reduces code duplication across multiple resources

### Best Practices
- Always pair with locals blocks for centralized port/configuration management
- Reference values using `.value` in content blocks
- Can be reused across multiple resources

---

## 15.3 Data Blocks

### Overview
Data blocks define data sources that fetch information about existing resources or compute data outside of Terraform's direct management. Data blocks are read-only and do not create, modify, or destroy resources.

### Key Concepts

#### Basic Data Block Structure

```hcl
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-24.04-amd64-server-*"]
  }

  owners = ["099720109477"]  # Canonical's owner ID
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
}
```

### Important Points
- Data blocks are separate from resource blocks
- Must specify owner ID for AMIs to ensure correct source
- Reference pattern: `data.<type>.<name>.<attribute>`
- Cannot modify data obtained through data sources

### Common Use Cases
- Fetching latest AMIs
- Retrieving information about existing infrastructure
- Getting data from external systems

---

## 15.4 Version Constraints

### Overview
Version constraints are configurable strings that manage software versions used with Terraform, including providers and Terraform itself. Based on semantic versioning (major.minor.patch).

### Version Constraint Operators

| Operator | Description | Example |
|----------|-------------|---------|
| `=` | Exact version only | `version = "1.4.6"` |
| `!=` | Exclude exact version | `version = "!=1.5.2"` |
| `>` | Greater than | `version = ">1.3"` |
| `<` | Less than | `version = "<2.0"` |
| `>=` | Greater than or equal | `version = ">=1.4.6"` |
| `<=` | Less than or equal | `version = "<=2.0"` |
| `~>` | Only rightmost number increments | `version = "~>5.01"` |

### Terraform Configuration Example

```hcl
terraform {
  required_version = ">= 1.4.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.26"
    }
  }
}
```

### Key Points
- `~>` allows minor version updates but not major (e.g., `~>5.01` goes up to 5.99)
- Use `>=` when you want to allow major version updates
- Provider versions often use major.minor only (e.g., 6.26)
- Specified in double quotes as strings

---

## 15.5 Credentials Best Practices

### Overview
Security best practices for handling credentials in Terraform configurations to prevent exposure of sensitive information.

### ❌ What NOT to Do

```hcl
provider "aws" {
  region     = "us-east-2"
  access_key = "AKIAIOSFODNN7EXAMPLE"      # BAD
  secret_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"  # BAD
}
```

### ✅ Secure Alternatives

#### 1. Provider CLI Tools
```bash
aws configure
```
Stores credentials in `~/.aws/credentials`

#### 2. Environment Variables
```hcl
# In provider block
provider "aws" {
  region     = "us-east-2"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
```

```bash
export TF_VAR_aws_access_key="your-access-key"
export TF_VAR_aws_secret_key="your-secret-key"
```

#### 3. Terraform Cloud/HCP Terraform
- Store as environment variables (not Terraform variables)
- Mark sensitive attributes

#### 4. Terraform tfvars Files
```hcl
# terraform.tfvars (add to .gitignore!)
aws_access_key = "your-access-key"
aws_secret_key = "your-secret-key"
```

#### 5. HashiCorp Vault
```hcl
provider "vault" {
  address = "https://vault.example.com"
  token   = var.vault_token
}

data "vault_generic_secret" "aws_creds" {
  path = "secret/aws/creds"
}
```

### Summary of Methods
1. Provider CLI tools (aws configure)
2. Environment variables with TF_VAR_
3. Terraform Cloud environment variables
4. tfvars files (never commit to git)
5. HashiCorp Vault integration

---

## 15.7 Refactoring Terraform State

### Overview
Refactoring allows renaming or restructuring resources without destroying and recreating them, preserving the underlying infrastructure while updating Terraform state.

### The Problem
Renaming resources in code causes Terraform to see this as deletion and creation:

```hcl
# Before
resource "aws_iam_user" "dev_user1" { ... }
resource "aws_iam_user" "dev_user2" { ... }

# After (without refactoring)
resource "aws_iam_user" "engineer_alice" { ... }
resource "aws_iam_user" "engineer_bob" { ... }
# Result: destroy + create operations
```

### The Solution: Moved Block

```hcl
moved {
  from = aws_iam_user.dev_user1
  to   = aws_iam_user.engineer_alice
}

moved {
  from = aws_iam_user.dev_user2
  to   = aws_iam_user.engineer_bob
}

resource "aws_iam_user" "engineer_alice" {
  name = "Developer Alice"
  tags = {
    team = "engineering"
  }
}

resource "aws_iam_user" "engineer_bob" {
  name = "Developer Bob"
  tags = {
    team = "engineering"
  }
}
```

### Manual Alternative: terraform state mv

```bash
terraform state mv aws_iam_user.engineer_alice aws_iam_user.developer_alice
```

### Comparison Table

| Method | Pros | Cons |
|--------|------|------|
| moved block | Documented, version controlled, team-friendly | Requires code changes |
| terraform state mv | Quick for one-off changes | Not documented, error-prone, manual |

### Common Use Cases
- Moving resources between modules
- Renaming Terraform IDs
- Restructuring resource paths
- Moving from flat structure to module-based structure

---

## 15.8 Using Multiple Workspaces – Part 1

### Overview
Terraform workspaces allow multiple environments with separate state files within a single working directory, enabling different configurations for the same infrastructure code.

### Key Concepts

#### Default Workspace
Every Terraform working directory starts with a single `default` workspace.

#### Workspace Commands

```bash
# List workspaces
terraform workspace list

# Create new workspace
terraform workspace new test1

# Switch workspaces
terraform workspace select test2

# Delete workspace
terraform workspace delete test1
```

### Workspace Structure
```
project/
├── main.tf
├── variables.tf
└── terraform.tfstate.d/
    ├── test1/
    │   └── terraform.tfstate
    └── test2/
        └── terraform.tfstate
```

#### Environment File
- Located in `.terraform/environment`
- Shows current workspace name
- Legacy name "environment" still used internally

### Best Practices for Part 1 Setup
- Create workspace definition files first
- Understand the workspace list and select commands
- Note the creation of `terraform.tfstate.d` directory

---

## 15.9 Using Multiple Workspaces – Part 2

### Overview
Demonstrates applying different configurations to separate workspaces and managing state files for each environment.

### Lab Implementation

#### Step 1: Initialize and Apply to First Workspace
```bash
terraform init
terraform workspace select test1
terraform apply
# Enter variable values:
# - Instance type: t3.micro
# - Name: test1-instance
# - Region: us-east-2
```

#### Step 2: Switch and Apply to Second Workspace
```bash
terraform workspace select test2
terraform apply
# Enter different variable values:
# - Instance type: t2.nano
# - Name: test2-instance
# - Region: us-east-2
```

### State File Management
Each workspace maintains its own state file:
- `.terraform/tfstate.d/test1/terraform.tfstate`
- `.terraform/tfstate.d/test2/terraform.tfstate`

### Workspace Cleanup Process

```bash
# 1. Destroy infrastructure in current workspace
terraform destroy

# 2. Switch to other workspace
terraform workspace select test1

# 3. Destroy infrastructure in test1
terraform destroy

# 4. Switch to default before deleting workspaces
terraform workspace select default

# 5. Delete workspaces
terraform workspace delete test1
terraform workspace delete test2
```

### ⚠️ Critical Notes
- Must destroy infrastructure before deleting workspaces
- Deleting workspaces removes their state files
- Always back up state files before workspace deletion if needed
- Use separate terminals for simultaneous operations if desired

### Use Cases
- Load testing different instance types
- Development/staging/production environments
- Blue/green deployment strategies
- Regional deployments

---

## 15.10 More Terraform Environment Variables

### Overview
Additional environment variables beyond TF_LOG and TF_LOG_PATH for controlling Terraform behavior, directory locations, and automation workflows.

### Key Environment Variables

#### TF_DATA_DIR
- Changes the working Terraform directory
- Useful when code is in a different location
- Set with: `export TF_DATA_DIR=./terraform-data`

#### TF_PLUGIN_CACHE_DIR
- Changes where provider plugins are downloaded
- Enables provider caching for faster operations
- Reduces disk space usage across projects

#### TF_IN_AUTOMATION
- Designed for CI/CD pipelines
- Setting to `1` produces cleaner output without interactive suggestions
- Prevents process hanging during automation

#### TF_INPUT
- Controls interactive prompts
- Set to `false` to prevent prompts during automation
- Equivalent to `-input=false` flag on CLI

#### TF_VAR_*
- Used for any variable, including secrets
- Format: `export TF_VAR_variable_name=value`
- Works across Linux and macOS

### Automation Best Practices

```bash
# For CI/CD pipelines
export TF_IN_AUTOMATION=1
export TF_INPUT=false

# Or use CLI flags
terraform apply -input=false -auto-approve
```

### Additional Variables
- **TF_WORKSPACE**: Supports multi-environment workflows
- **TF_CLI_ARGS**: Injects default arguments globally
- **TF_CLI_CONFIG_FILE**: Specifies CLI configuration file location

### Resource
Full list available at: https://developer.hashicorp.com/terraform/cli/config/environment-variables

---

## 15.11 Quiz

### Question 1: Data Source for Remote State
**True or False**: You need access to a particular Terraform state for organization "example" and workspace "prod". The following code block will work:

```hcl
data "terraform_remote_state" "example" {
  backend = "remote"
  config = {
    organization = "example"
    workspaces = {
      name = "prod"
    }
  }
}
```

**Answer**: True ✓
- Correct structure for connecting to remote state
- Requires `backend`, `config`, `organization`, and `workspace` arguments

### Question 2: Terraform Import Parameters
**Question**: Which parameters does the `terraform import` command require? (Select two)

**Options**:
- A) Path
- B) Resource address ✓
- C) Resource ID ✓
- D) Provider

**Answer**: B and C
- Required: Resource address and Resource ID
- Format: `terraform import aws_instance.instance1 i-1234567890abcdef0`

---

## Summary

### Key Takeaways
```diff
+ Locals provide reusable values that don't change, referenced as local.singular
+ Dynamic blocks generate repeatable nested configurations using for_each
+ Data blocks fetch external information without managing resources
+ Version constraints follow semantic versioning with various operators
+ Never hardcode credentials - use environment variables, vaults, or provider tools
+ Moved blocks enable safe refactoring without resource destruction
+ Workspaces provide separate state files for different environments
+ Environment variables enhance automation and configuration flexibility
```

### Quick Reference

| Feature | Syntax/Example |
|---------|----------------|
| Locals block | `locals { name = value }` |
| Reference local | `local.name` |
| Dynamic block | `dynamic "type" { for_each = local.list }` |
| Data source | `data "type" "name" { }` |
| Version constraint | `version = "~> 1.0"` |
| Moved block | `moved { from = old to = new }` |
| Workspace commands | `terraform workspace [list\|new\|select\|delete]` |

### Expert Insights

#### Real-world Application
- Use locals for centralized tag management across all resources
- Implement workspaces for dev/staging/prod isolation
- Leverage data sources for dynamic AMI selection in production
- Always use environment variables or secret management for credentials

#### Expert Path
1. Master locals for DRY (Don't Repeat Yourself) configurations
2. Implement dynamic blocks for scalable security groups
3. Build automated workflows using TF_IN_AUTOMATION
4. Create reusable modules with proper version constraints
5. Implement state refactoring for evolving infrastructure

#### Common Pitfalls
- Using `locals.` instead of `local.` when referencing
- Hardcoding credentials in main.tf files
- Forgetting to destroy infrastructure before deleting workspaces
- Not specifying owner IDs in AMI data sources
- Using `terraform state mv` instead of moved blocks for team environments

#### Lesser-Known Facts
- Terraform automatically detects providers without explicit terraform blocks
- The `environment` file in `.terraform/` maintains workspace state
- Deleting a workspace removes its state directory entirely
- TF_CLI_ARGS can inject global flags for all Terraform commands
- Version constraints can combine multiple operators: `">= 1.0, < 2.0"`

</details>