# Section 11: Introduction to Terraform Cloud

<details open>
<summary><b>Section 11: Introduction to Terraform Cloud (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [11.1 Introduction to Terraform Cloud](#111-introduction-to-terraform-cloud)
- [11.2 Creating a Terraform Cloud Account](#112-creating-a-terraform-cloud-account)
- [11.3 Types of Workflows](#113-types-of-workflows)
- [Summary](#summary)

---

## 11.1 Introduction to Terraform Cloud

### Overview
This module introduces Terraform Cloud as a platform for managing Terraform operations beyond the local CLI. It addresses the challenges of infrastructure as code sprawl and demonstrates how Terraform Cloud provides remote state storage and organized Terraform execution.

### Key Concepts/Deep Dive

#### Infrastructure as Code (IaC) Sprawl
When multiple team members work exclusively with the Terraform CLI on their individual terminals and systems, several problems arise:

- **Configuration Files Scattered**: Code becomes distributed across multiple locations without centralized organization
- **Directory Disorganization**: Files and directories lack proper structure and governance
- **Lost Configurations**: Terraform configurations can easily become misplaced or duplicated
- **State File Chaos**: Local state files become difficult to manage across team members
- **Lack of Consistency**: Different team members may have varying Terraform versions and configurations

#### Remote Backend Solutions
Previously discussed remote backend options include:
- AWS S3 buckets
- Azure Storage
- Google Cloud Storage

**Terraform Cloud** emerges as an additional remote backend solution offering:
- Reliable Terraform execution
- Consistent infrastructure deployments
- Organized workspace management
- Enhanced security features

#### Terraform Run Trigger Options
Terraform Cloud provides multiple methods for executing Terraform runs:

1. **CLI Triggering**: Initiate runs directly from the command line interface
2. **UI Triggering**: Execute runs through the web-based user interface
3. **Version Control Integration**: Automatically trigger runs based on repository changes
4. **API Integration**: Programmatically trigger runs via the Terraform Cloud API

### Exam Alert
> [!IMPORTANT]
> **Know the difference between local and remote backends:**
> - **Local Backend**: State file stored in your working directory on your local machine
> - **Remote Backend**: State file stored externally (AWS S3, Azure, Google Cloud, or Terraform Cloud)

### Key Features of Terraform Cloud
- **Remote State Storage**: Centralized state management eliminating local state file issues
- **Web-Based UI**: Browser-based interface for managing Terraform operations
- **Private Module Registry**: Store and share Terraform modules privately within your organization

---

## 11.2 Creating a Terraform Cloud Account

### Overview
This module provides a step-by-step guide for creating a Terraform Cloud account, setting up an organization, and configuring workspaces as preparation for subsequent labs involving Terraform runs.

### Key Concepts/Deep Dive

#### Account Creation Prerequisites
- **Valid Email Address**: Required for account verification
- **Strong Password**: Use complex, lengthy passwords stored in a password manager
- **Recommended Password Managers**:
  - KeePass (locally stored)
  - Bitwarden (cross-platform)

#### Registration Process
1. Access Terraform Cloud via the direct link or at `app.terraform.io`
2. Select a unique username
3. Enter a valid email address
4. Create a strong password
5. Acknowledge privacy policy
6. Agree to terms of use
7. Create the account

#### Free Tier Capabilities
> [!NOTE]
> All labs in this course can be completed using the free tier of Terraform Cloud.

#### Post-Registration Configuration

**Step 1: Organization Creation**
- Create a unique, memorable organization name
- Example: "Prowsetech"

**Step 2: Workspace Setup**
Workspaces in Terraform Cloud are analogous to working directories in local Terraform CLI operations. When creating a workspace:

1. Navigate to your organization
2. Select "New Workspace"
3. Choose a project (default project available)
4. Select workflow type: **CLI-Driven Workflow**
5. Provide a workspace name (e.g., "Workspace 1")
6. Add optional description
7. Create the workspace

#### Available Terraform Cloud Features
After setup, explore these UI sections:
- **Projects**: Organize workspaces into logical groupings
- **Stacks**: Manage related infrastructure deployments
- **Workspaces**: Individual Terraform configuration environments
- **Registry**: Private module storage and sharing

### Lab Demo: Account Setup Summary
```bash
# Pre-work checklist:
✅ Create Terraform Cloud account at app.terraform.io
✅ Verify email address
✅ Create organization (unique and memorable name)
✅ Create workspace with CLI-Driven Workflow selected
✅ Explore UI: Projects, Stacks, Workspaces, Registry
```

---

## 11.3 Types of Workflows

### Overview
This module examines the three distinct workflow types supported by Terraform Cloud for executing Terraform operations: CLI-driven, Version Control System (VCS)-driven, and API-driven workflows.

### Key Concepts/Deep Dive

#### Workspace Architecture
In Terraform Cloud:
- Resources are organized by workspaces
- Each workspace contains:
  - Resource definitions
  - Environment variables
  - Input variables
  - State files
- Terraform operations execute within the workspace context
- Infrastructure modifications occur in the cloud, not locally

#### Workflow Types in Terraform Cloud

| Workflow Type | Description | Trigger Method | Use Case |
|--------------|-------------|----------------|----------|
| **CLI-Driven** | Uses standard Terraform CLI to execute runs in Terraform Cloud | Local `terraform` commands | Development and testing |
| **VCS-Driven** | Changes pushed to version control trigger workspace runs | Git commits/pushes | Production deployments |
| **API-Driven** | Programmatic interaction with Terraform Cloud API | Custom tooling/scripts | Advanced automation |

#### CLI-Driven Workflow
- Work with standard Terraform CLI tools
- Store `.tf` files locally
- Execute commands from local CLI
- All execution occurs in Terraform Cloud
- State stored remotely in Terraform Cloud
- Ideal for: Development workflows and testing

#### Version Control System (VCS)-Driven Workflow
Also referred to as UI/Version Control workflow:

```diff
! Local Code Changes → Git Commit → Push to Repository → Automatic Run Trigger → Terraform Cloud Execution
```

**Supported Platforms**:
- GitHub
- GitLab
- Bitbucket

**Workflow Process**:
1. Maintain code in a VCS repository
2. Make changes to Terraform configuration
3. Push changes to repository
4. Automatic run triggered in associated workspace
5. Infrastructure updates applied to target cloud provider

> [!IMPORTANT]
> VCS-driven workflow is recommended for production environments due to its automation and audit trail capabilities.

#### API-Driven Workflow
- Enables programmatic interaction with Terraform Cloud API
- Supports custom tooling development
- Advanced Terraform usage
- Not covered on the Terraform Associate examination
- Not included in these course lessons

#### User Interface (UI) Triggering
- Direct run triggering from Terraform Cloud web interface
- Useful for manual interventions
- Provides visual oversight of Terraform operations

### Comparison: Local vs. Terraform Cloud Execution

```diff
! Local CLI Execution:
- Working directory as workspace
- Local state file storage
- All execution on local machine

! Terraform Cloud Execution:
- Named workspace in cloud
- Remote state file storage
- Execution in Terraform Cloud
- Multiple trigger options available
```

---

## Summary

### Key Takeaways
```diff
+ Terraform Cloud addresses IaC sprawl by providing centralized management
+ Remote state storage eliminates local state file conflicts
+ Three workflow types: CLI, VCS, and API driven
+ VCS-driven workflows enable automated deployments from version control
+ Free tier sufficient for all course labs and basic usage
+ Workspaces in Terraform Cloud equivalent to local working directories
```

### Quick Reference
| Task | Command/Action |
|------|---------------|
| Create account | Visit `app.terraform.io` |
| Login | `app.terraform.io` login |
| New workspace | Organization → New → Workspace |
| Recommended workflow | CLI-Driven for initial labs |
| State storage | Automatic in Terraform Cloud (remote) |

### Expert Insight

#### Real-world Application
Terraform Cloud is essential for team environments where multiple engineers work on the same infrastructure. It prevents state conflicts, provides audit trails, and enables GitOps-style deployments where infrastructure changes follow the same review processes as application code.

#### Expert Path
1. Master CLI-driven workflows for local development
2. Implement VCS-driven workflows for production
3. Explore API-driven workflows for custom automation
4. Utilize private module registry for code reuse
5. Implement variable sets and policy as code

#### Common Pitfalls
- **Storing state locally**: Always configure remote backend
- **Weak passwords**: Use password managers for Terraform Cloud accounts
- **Skipping MFA**: Enable multi-factor authentication for all accounts
- **Not exploring UI**: Familiarize yourself with all Terraform Cloud features before production use

#### Lesser-Known Facts
- Terraform Cloud workspaces can belong to multiple projects
- You can trigger runs directly from the UI even with VCS workflows configured
- Private module registry in Terraform Cloud requires separate configuration
- HCP (HashiCorp Cloud Platform) accounts can also be used with Terraform

</details>