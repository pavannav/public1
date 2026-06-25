# Section 12: CLI-Based and Version Control Workflows Using Terraform Cloud

<details open>
<summary><b>Section 12: CLI-Based and Version Control Workflows Using Terraform Cloud (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
1. [12.1 CLI-Based Workflow Using Terraform Cloud - Part 1](#121-cli-based-workflow-using-the-terraform-cloud--part-1)
2. [12.2 CLI-Based Workflow Using Terraform Cloud - Part 2](#122-cli-based-workflow-using-the-terraform-cloud--part-2)
3. [12.3 Variables in Terraform Cloud](#123-variables-in-terraform-cloud)
4. [12.4 Version Control-Based Workflow - Part 1](#124-version-control-based-workflow--part-1)
5. [12.5 Version Control-Based Workflow - Part 2](#125-version-control-based-workflow--part-2)
6. [12.6 Version Control-Based Workflow - Part 3](#126-version-control-based-workflow--part-3)
7. [12.7 Quiz](#127-quiz)
8. [Summary](#summary)

---

## 12.1 CLI-Based Workflow Using Terraform Cloud - Part 1

### Overview
This module introduces the CLI-driven workflow with HCP Terraform (formerly Terraform Cloud), demonstrating how to configure workspaces for CLI-based operations and authenticate using API tokens.

### Key Concepts

#### Workspace Configuration for CLI Workflow
When setting up a workspace in HCP Terraform for CLI-driven workflows:

1. **Organization Setup**: Requires a valid HCP Terraform organization
2. **Project Selection**: Workspaces are organized within projects (default project used in lab)
3. **Workspace Creation**: Must explicitly select "CLI-driven workflow" during creation
4. **Workspace Status**: Shows as "waiting for configuration" until initial runs are performed

#### Terraform Cloud Block Configuration

The `terraform` block requires a `cloud` sub-block to connect to HCP Terraform:

```hcl
terraform {
  cloud {
    organization = "your-organization-name"
    workspaces {
      name = "your-workspace-name"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
```

**Important**: The cloud block must be placed inside the terraform block, and delimiter matching is critical for proper syntax.

#### Authentication Process

##### Terraform Login Command
The `terraform login` command initiates browser-based authentication:

```bash
terraform login
```

**Process Flow**:
1. Command opens default browser to app.terraform.io
2. User must be pre-authenticated to HCP Terraform in browser
3. Token generation with configurable expiration (default: 30 days)
4. Token copied and pasted into CLI
5. Credentials stored in `~/.terraform.d/credentials.tfrc.json`

##### Credentials Storage Location
```bash
~/.terraform.d/credentials.tfrc.json
```

**Security Warning**: This file contains sensitive API tokens and should never be committed to version control or shared.

#### Credential Management Best Practices

The transcript emphasizes multiple approaches for handling AWS credentials:

| Method | Security Level | Recommendation |
|--------|---------------|----------------|
| Hard-coding in provider block | ❌ Very Poor | Never use in production |
| terraform.tfvars with .gitignore | ⚠️ Moderate | Acceptable for labs only |
| Local environment variables | ⚠️ Moderate | Requires careful management |
| HCP Terraform Environment Variables | ✅ Good | Recommended approach |
| HashiCorp Vault | ✅✅ Excellent | Most secure option |

#### Variables Configuration

For CLI-driven workflows with local credential storage:

**main.tf**:
```hcl
provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {}
```

**terraform.tfvars**:
```hcl
aws_access_key = "AKIAIOSFODNN7EXAMPLE"
aws_secret_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
aws_region     = "us-east-2"
```

**Important**: Always add `terraform.tfvars` to `.gitignore` when using this approach.

---

## 12.2 CLI-Based Workflow Using Terraform Cloud - Part 2

### Overview
This module demonstrates running Terraform operations through the CLI against HCP Terraform, showing the complete workflow from initialization through resource lifecycle management.

### Key Concepts

#### Initialization Process
After successful authentication:

```bash
terraform init
```

**Expected Behavior**:
- Initializes HCP Terraform backend
- Downloads provider plugins (e.g., AWS v6.28)
- Creates `.terraform.lock.hcl` file
- No local state file is created

#### Validation and Formatting
```bash
terraform fmt      # Formats configuration files
terraform validate # Validates syntax and variable references
```

#### Remote Execution Flow

When running `terraform apply`:
1. Command executes against HCP Terraform (not locally)
2. Real-time output streams to CLI
3. Provides direct link to run in web UI
4. Plan and apply phases execute remotely

**Sample Output**:
```
Running apply in HCP Terraform

[link to specific run in workspace]

Plan: 1 to add, 0 to change, 0 to destroy.
```

#### State File Management

**Critical Difference from Local Backends**:
- ✅ No `terraform.tfstate` file in working directory
- ✅ All state stored remotely in HCP Terraform
- ✅ Complete state history maintained (not just last backup)
- ✅ State accessible via web UI with filtering capabilities

**Accessing State Files**:
1. Navigate to workspace → States
2. View individual state versions
3. Filter by resource type or attribute
4. Download state data if needed

#### Run Tracking and Metadata

Each run includes:
- **Run ID**: Unique identifier for tracking
- **Trigger Source**: "Triggered via CLI"
- **Plan Details**: Resources to be created/modified/destroyed
- **Apply Details**: Resources created with cloud provider IDs
- **State Version**: Link to associated state file

#### Resource Lifecycle Commands
```bash
terraform destroy  # Removes all managed resources
terraform logout   # Removes stored credentials from local system
```

**Logout Verification**:
After logout, `~/.terraform.d/credentials.tfrc.json` becomes empty JSON `{}`, preventing unauthorized runs.

---

## 12.3 Variables in Terraform Cloud

### Overview
This module demonstrates using HCP Terraform's variable management system, covering both Terraform variables and Environment variables for secure credential handling.

### Key Concepts

#### Variable Types in HCP Terraform

| Type | Use Case | Example | Sensitive Option |
|------|----------|---------|------------------|
| Terraform Variables | Non-sensitive configuration | region, instance_type, tags | Optional |
| Environment Variables | Credentials and secrets | AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY | Recommended |

#### Configuring Variables in main.tf

**Using Variable References**:
```hcl
provider "aws" {
  region = var.region
  # Credentials provided via environment variables
}

variable "region" {}
```

**Best Practice**: Use variable references for all configurable values to avoid modifying main.tf for different environments.

#### Adding Variables via Web UI

##### Terraform Variables
1. Navigate to workspace → Variables
2. Click "Add variable"
3. Select "Terraform variable"
4. Enter key (must match variable name in code)
5. Enter value
6. Optionally mark as sensitive
7. Add description (optional)

##### Environment Variables
1. Click "Add variable"
2. Select "Environment variable"
3. Use proper AWS naming conventions:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
4. Enter values
5. **Always** mark as sensitive
6. Add variable

#### AWS Credential Naming Conventions

**Correct Format** (all uppercase):
```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```

**Incorrect Format** (will not work):
```
aws_access_key
aws_secret_key
```

Reference: AWS Provider documentation specifies these exact environment variable names.

#### Variable Storage Architecture

**Local Environment Variables**:
```bash
export AWS_ACCESS_KEY_ID="your-key"
export AWS_SECRET_ACCESS_KEY="your-secret"
```
- Stored in local shell session
- Only available on that system
- Lost when session ends

**HCP Terraform Environment Variables**:
- Stored in workspace configuration
- Available to remote execution workers
- Shared across team members
- Persist across runs

#### Execution Environment

When using HCP Terraform variables:
- Variables injected into remote Linux worker
- No local credential storage required
- Team members can run terraform without local credentials
- All sensitive values marked with "sensitive information, write only"

#### Workflow Summary

1. Configure main.tf with variable references
2. Add Terraform variables for configuration values
3. Add Environment variables for credentials (marked sensitive)
4. Run `terraform login` if not authenticated
5. Execute `terraform init` and `terraform apply`
6. Verify resources created in cloud provider console

---

## 12.4 Version Control-Based Workflow - Part 1

### Overview
This module begins the VCS-driven workflow lab, covering repository setup, Git configuration, and initial code synchronization with GitHub.

### Key Concepts

#### Lab 17 Overview
**VCS-Based Workflow Components**:
1. Create GitHub repository for Terraform code
2. Configure local Git repository with proper ignores
3. Connect HCP Terraform workspace to VCS
4. Configure workspace variables
5. Trigger runs via UI and Git pushes

#### Repository Synchronization Steps

##### Step 1: Copy Terraform Files
```bash
# Copy from Lab 16 to Lab 17
cp lab16/main.tf lab17/
cp lab16/terraform.tfvars lab17/
```

##### Step 2: Create GitHub Repository
- Use descriptive name (e.g., "TF-Test")
- Set visibility (public/private as needed)
- No auto-generated README or .gitignore
- Note the repository URL for later use

##### Step 3: Create .gitignore File

```gitignore
# Ignore Terraform directory (plugins and modules)
.terraform/

# Ignore sensitive variable files
terraform.tfvars
```

**Why These Ignores Matter**:
- `.terraform/` can exceed 500MB with provider plugins
- `terraform.tfvars` contains sensitive credentials
- Prevents accidental credential exposure

##### Step 4: Initialize Local Git Repository
```bash
git init
git branch -M main          # Rename from master to main
git add .
git commit -m "commit-1"
```

**Important**: Run `git init` AFTER creating `.gitignore` to ensure ignored files are never tracked.

##### Step 5: Connect to Remote Repository
```bash
git remote add origin https://github.com/username/TF-Test.git
git push -u origin main
```

**Authentication Requirements**:
- Browser-based OAuth for GitHub
- May require VS Code authorization
- Credentials stored in Git credential manager

#### File Tracking Verification

After successful push:
- ✅ main.tf visible in GitHub
- ✅ .gitignore visible in GitHub
- ❌ terraform.tfvars NOT visible (properly ignored)
- ❌ .terraform/ NOT visible (properly ignored)

---

## 12.5 Version Control-Based Workflow - Part 2

### Overview
This module covers connecting HCP Terraform workspaces to version control systems and triggering runs through the web UI.

### Key Concepts

#### VCS Workspace Creation

##### Workspace Configuration
1. Select "Version control workflow" (VCS)
2. Choose VCS provider (GitHub, GitLab, Bitbucket)
3. Select GitHub App integration
4. Choose organization and specific repository
5. Grant appropriate permissions:
   - Read access for configuration
   - Write access for commits/status updates

##### Workspace Naming
- Use repository name as workspace name for clarity
- Add description for team reference
- Advanced options available for working directory and triggers

#### Variable Configuration for VCS Workspaces

**Terraform Variables**:
- Auto-detected from code (e.g., `var.region`)
- Values set directly in web UI
- No need for terraform.tfvars file

**Environment Variables**:
- Required for AWS credentials
- Use proper uppercase naming convention
- Always mark as sensitive

#### Run Trigger Methods

##### Method 1: Web UI Trigger
1. Navigate to workspace Overview
2. Click "New run"
3. Configure run options:
   - Run name (auto-generated or custom)
   - Run type: Plan and apply, Plan only, Refresh only
4. Start run and monitor progress

**Run Lifecycle**:
1. **Planning Phase**: Analyzes configuration changes
2. **Confirmation**: Manual approval required (configurable)
3. **Apply Phase**: Implements changes in target environment

##### UI Run Characteristics
- Visible in run history with "Triggered via UI"
- Shows plan details before apply
- Requires explicit confirmation for safety
- Links to state files and resource details

#### Run Details and State Management

**Plan Output Includes**:
- Resources to create/modify/destroy
- Configuration drift detection
- Detailed change summaries

**Apply Output Includes**:
- Resource IDs from cloud provider
- State file generation
- Timing information

**State File Access**:
- View current and historical state
- JSON format for programmatic access
- Resource filtering capabilities

---

## 12.6 Version Control-Based Workflow - Part 3

### Overview
This final module demonstrates Git-triggered runs, auto-apply configuration, and infrastructure-as-code best practices for resource lifecycle management.

### Key Concepts

#### Infrastructure as Code Workflow

**Making Code Changes**:
```hcl
# Adding new resource
resource "aws_iam_user" "test_user_99" {
  name = "test-user-99"
}
```

**Git Workflow**:
```bash
git add .
git commit -m "commit-2"
git push -u origin main
```

**Automatic Triggers**:
- Git push automatically initiates Terraform run
- Run named after commit message
- Plan executes based on code differences

#### Auto-Apply Configuration

**Enabling Auto-Apply**:
1. Navigate to workspace Settings
2. Enable "Auto apply"
3. Select trigger types:
   - API-driven runs
   - UI-driven runs
   - VCS-triggered runs
   - Run triggers

**Warning**: Auto-apply removes safety confirmation step. Use with caution.

#### Resource Destruction via Code

**Method: Comment Out Resources**
```hcl
# resource "aws_instance" "example" {
#   ami           = "ami-12345"
#   instance_type = "t2.micro"
# }
```

**Git Commit Process**:
```bash
git add .
git commit -m "commit-3"  # Shows 12 insertions, 12 deletions
git push -u origin main
```

**Destruction Indicators**:
- Commit shows deletions in diff
- Plan indicates "2 to destroy"
- Resources terminated after apply

**Alternative Destruction Methods**:
- Run `terraform destroy` from CLI (CLI-driven workspaces)
- Trigger destroy run from UI
- Code-based approach preferred for IaC consistency

#### VCS Workflow Benefits

| Feature | CLI-Driven | VCS-Driven |
|---------|------------|------------|
| Code Storage | Local filesystem | Git repository |
| State Storage | HCP Terraform | HCP Terraform |
| Trigger Method | CLI commands | Git pushes |
| Team Collaboration | Limited | Full version control |
| Audit Trail | Run history | Commits + runs |
| Rollback | State versions | Git history |

#### Best Practices Summary

1. **Always use version control** for production Terraform code
2. **Configure auto-apply** only after thorough testing
3. **Use meaningful commit messages** for run identification
4. **Review plans** before enabling auto-apply
5. **Maintain .gitignore** properly to protect sensitive data
6. **Document workspace settings** for team knowledge transfer

---

## 12.7 Quiz

### Overview
This module reviews key concepts from Section 12 through quiz questions covering CLI authentication, Git integration, and sensitive data handling.

### Key Concepts

#### Question 1: CLI Authentication Command
**Question**: Which command connects to Terraform Cloud with a token?

**Answer**: `terraform login`

**Explanation**:
- Opens browser for token generation
- Requires prior web authentication
- Stores token in `~/.terraform.d/credentials.tfrc.json`
- Incorrect options: `terraform init` (initializes directory), AWS credentials (for AWS access), environment variables (storage method, not command)

#### Question 2: Git Ignore Requirements
**Question**: Which files should be added to .gitignore? (Select two)

**Answers**:
- `terraform.tfvars`
- `.terraform/`

**Reasoning**:
- `terraform.tfvars`: Contains sensitive credentials
- `.terraform/`: Contains large binary plugins (500MB+)
- `main.tf`: Must be pushed (core configuration)
- `.txt` files: Not relevant to Terraform operations

**Additional Context**: Even when using HCP Terraform (which includes provider plugins), maintain `.gitignore` for compatibility with other environments.

#### Question 3: Sensitive Values and State Files
**Question**: True or False - A terraform output using `sensitive = true` will not store the value in the state file.

**Answer**: False

**Explanation**:
- Sensitive values ARE stored in state file (plain text)
- Sensitive flag only prevents CLI display during plan/apply
- Applies to both variables and outputs
- Use environment variables in HCP Terraform for true credential protection

#### Exam Alert: Credential Management
**Key Takeaway**: HCP Terraform provides secure credential injection:
1. Set variable values in web UI
2. Mark as sensitive with checkbox
3. Use environment variables for AWS credentials
4. Always enable sensitive flag for secrets

---

## Summary

### Key Takeaways

```diff
+ CLI-driven workflows enable local development with remote state storage
+ VCS-driven workflows provide full automation through Git integration
+ HCP Terraform variables offer team-shared configuration management
+ Environment variables in HCP Terraform provide secure credential handling
+ Always use .gitignore to protect sensitive files and large binaries
+ Auto-apply removes manual confirmation for faster deployments
+ State history is preserved in HCP Terraform unlike local backends
```

### Quick Reference

| Command/Action | Purpose |
|----------------|---------|
| `terraform login` | Authenticate CLI to HCP Terraform |
| `terraform logout` | Remove stored credentials |
| Git push to connected repo | Trigger VCS run |
| Workspace → Variables | Manage Terraform and Environment variables |
| Workspace → States | View historical state files |
| Workspace → Runs | Monitor execution history |

### Expert Insight

#### Real-world Application
In production environments, VCS-driven workflows with HCP Terraform provide:
- Automated testing through Git workflows
- Peer review via pull requests
- Compliance auditing through commit history
- Zero-downtime deployments with proper state management

#### Expert Path
1. Master CLI-driven workflows for development
2. Progress to VCS-driven for team collaboration
3. Implement GitHub Actions for advanced automation
4. Explore run triggers for complex workflows
5. Consider HCP Terraform Agents for private infrastructure

#### Common Pitfalls
- ❌ Forgetting to mark credentials as sensitive
- ❌ Not configuring .gitignore properly
- ❌ Hard-coding credentials in main.tf
- ❌ Using incorrect AWS environment variable names
- ❌ Enabling auto-apply without understanding risks

#### Lesser-Known Facts
- HCP Terraform can automatically detect required variables from code
- Provider plugins may not need to be downloaded if already in HCP Terraform
- Run IDs provide unique tracking across all workspace operations
- State filtering supports complex queries for large infrastructures
- GitHub Actions integration enables pre-plan validation hooks

</details>