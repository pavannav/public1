# Section 13: Terraform Enterprise and Sentinel

## Table of Contents

- [13.1 Terraform Enterprise and Sentinel](#131-terraform-enterprise-and-sentinel)
- [13.2 Collaboration and Governance](#132-collaboration-and-governance)
- [13.3 Quiz](#133-quiz)
- [Summary](#summary)

---

## 13.1 Terraform Enterprise and Sentinel

### Overview
Terraform Enterprise is the self-hosted version of Terraform Cloud that allows organizations to run Terraform Cloud capabilities on their own infrastructure with custom security requirements. Sentinel is HashiCorp's policy-as-code framework that enforces compliance policies on Terraform configurations by running between the plan and apply phases.

### Terraform Enterprise

Terraform Enterprise is the self-hosted version of Terraform Cloud that provides all Terraform Cloud capabilities on-premises. Key characteristics:

- **Deployment Options**: Can be installed on Linux systems either on-premises or in customer cloud instances
- **System Requirements**:
  - Minimum 10GB disk space in root volume
  - Minimum 40GB disk space in data directory
  - Minimum 8GB system memory
  - Minimum 4 CPU cores
- **Default Deployment**: Runs within Docker containers on Linux systems
- **Additional Features**: Includes audit logging and single sign-on (SSO) services
- **Pricing Models**: Pay-as-you-go Flex and Enterprise self-managed options available
- **Initial Credit**: New users receive $500 credit for HashiCorp Cloud

**Important**: While Terraform Enterprise has specific requirements, the Terraform Associate exam only requires basic knowledge of what Terraform Enterprise is and its relationship to Terraform Cloud.

### Terraform Sentinel

Sentinel is HashiCorp's policy-as-code framework that works across multiple HashiCorp products including Terraform Cloud (HCP Terraform) and Terraform Enterprise.

**Key Characteristics**:
- Executes policies after `terraform plan` and before `terraform apply`
- Enforces compliance rules on infrastructure configurations
- Can be used for cost control and security compliance

**Sentinel Policy Enforcement**:
- Imports Terraform plan files for analysis
- Creates rules to check configuration compliance
- Prevents apply operations when policies are not met

**Example Use Cases**:
- Ensuring all AWS instances have required tags
- Restricting instance sizes to approved configurations (e.g., only allowing `n1-standard-1`, `n1-standard-2`, `n1-standard-4`, `n1-standard-8`)
- Cost control by preventing expensive resource provisioning

### Terraform Cloud Naming

> [!NOTE]
> Terraform Cloud is being renamed to **HCP Terraform** (HashiCorp Cloud Platform Terraform). Both names may appear in documentation and exam content.

---

## 13.2 Collaboration and Governance

### Overview
Collaboration and governance features in Terraform Cloud (HCP Terraform) work together to enable teams to provision infrastructure safely and compliantly. Collaboration features facilitate team coordination while governance features provide guardrails to ensure secure, compliant operations.

### Collaboration Features

**Remote State Storage**:
- Centralized state file storage with locking mechanisms
- State storage is workspace-specific in HCP Terraform

**VCS Integration**:
- Automatic runs triggered by commits to Git repositories
- Speculative plans run automatically on pull requests
- Integration support for GitHub and other Git-based VCS platforms

**Linked Workspaces and Stacks**:
- Supports running speculative plans with code changes
- Results posted as pull request checks
- Stacks provide advanced workspace management (covered later in course)

**Team-Based Permissions**:
- Granular access control for workspaces and projects
- Follow principle of least privilege for permission assignments

**Private Module Registry**:
- Store internal, reusable modules with version control
- Modules remain private to the organization

**CLI Integration**:
- Execute remote runs directly from local terminals
- Supports both CLI-driven and VCS-driven workflows

**Run Triggers and Automation**:
- Automate downstream workspace operations
- Configure webhooks and notifications

**Notifications and Webhooks**:
- Send workspace run notifications to external systems
- Integration support for Slack, Discord, and other webhook-enabled services

### Governance Features

**Policy as Code**:
- Sentinel and Open Policy Agent (OPA) frameworks
- Enforce compliance rules automatically
- Policies execute between plan and apply phases

**Cost Estimation**:
- Preview infrastructure costs before deployment
- Built-in cost estimation feature
- Can trigger Sentinel policy warnings for major price increases

**Role-Based Access Control (RBAC)**:
- Granular permission management
- Detailed control over user capabilities

**Run Approvals**:
- Require review before infrastructure changes
- Additional safety check for sensitive deployments

**Drift Detection**:
- Identify manual changes made outside of Terraform
- Continuous checks for configuration drift
- Preemptively detect AWS console changes and other manual modifications

**Audit Logs**:
- Monitor security-related events
- Track admin console access
- Record system API endpoint calls
- Available in premium tiers (Business/Enterprise)

### Exam Alert

> [!IMPORTANT]
> **Key Exam Concept**: Collaboration enables teams to work together on infrastructure provisioning, while governance provides guardrails to ensure safe, compliant operations. Both features complement each other in the Terraform Cloud workflow.

---

## 13.3 Quiz

### Question 1: Collaboration and Governance Relationship

**Question**: Which statement best describes the relationship between collaboration and governance features in Terraform Cloud?

**Options**:
- A) Collaboration features are only available in paid tiers, while governance features are available in the free tier
- B) Governance features enforce policies and controls on collaborative workflows to ensure safe, compliant infrastructure changes
- C) Collaboration features replace the need for governance features when using VCS integration
- D) Governance features are required before any collaboration features can be enabled

**Correct Answer**: B

**Explanation**: Governance features enforce policies and controls on collaborative workflows to ensure safe, compliant infrastructure changes. They work hand-in-hand to enable team collaboration while maintaining security and compliance standards.

**Why Other Options Are Incorrect**:
- Option A: Features are distributed across both free and paid tiers
- Option C: Collaboration and governance work together, not as replacements
- Option D: Governance features are optional, not required prerequisites

### Question 2: Sentinel Policy Enforcement

**Question**: When using Sentinel Policy Enforcement in Terraform Enterprise, at which point in the workflow are policies evaluated and what are the available enforcement levels?

**Options**:
- A) Policies run before Terraform Plan. Enforcement levels are warning, block and critical
- B) Policies run after Terraform Apply. Enforcement levels are advisory, mandatory and required
- C) Policies run between Terraform Plan and Terraform Apply. Enforcement levels are advisory, soft mandatory and hard mandatory
- D) Policies run during Terraform init. Enforcement levels are optional, recommended and enforced

**Correct Answer**: C

**Explanation**: Sentinel policies run between Terraform Plan and Terraform Apply phases. The enforcement levels are advisory, soft mandatory, and hard mandatory.

**Why Other Options Are Incorrect**:
- Option A: Policies run after plan, not before
- Option B: Policies run before apply, not after
- Option D: Init phase occurs much earlier in the workflow

---

## Summary

### Key Takeaways

```diff
+ Terraform Enterprise is the self-hosted version of Terraform Cloud requiring specific hardware requirements
+ Sentinel enforces policies between terraform plan and terraform apply phases
+ Collaboration features enable team coordination while governance provides compliance guardrails
+ Both collaboration and governance features work together in HCP Terraform workflows
+ Audit logs and advanced governance features require premium tier subscriptions
```

### Quick Reference

| Feature Category | Key Components |
|-----------------|----------------|
| **Collaboration** | Remote state, VCS integration, team permissions, private registry, CLI integration |
| **Governance** | Sentinel/OPA policies, cost estimation, RBAC, run approvals, drift detection, audit logs |
| **Policy Timing** | After plan, before apply |
| **Sentinel Enforcement** | Advisory, soft mandatory, hard mandatory |

### Expert Insight

**Real-world Application**:
- Use Terraform Enterprise when organizations require on-premises deployment with custom security policies
- Implement Sentinel policies to enforce tagging standards, instance size restrictions, and cost controls
- Leverage drift detection to maintain infrastructure compliance across large teams

**Expert Path**:
- Master Sentinel policy writing for complex compliance scenarios
- Learn to configure notifications and webhooks for DevOps pipeline integration
- Understand cost optimization through Sentinel policy warnings

**Common Pitfalls**:
- Assuming all features require paid tiers - some governance features work in free tier
- Running policies at wrong workflow stages
- Over-restricting permissions without following least privilege principle

**Lesser-Known Facts**:
- New HashiCorp Cloud users receive $500 credit for initial exploration
- Cost estimation can feed into Sentinel policies for automatic budget warnings
- Drift detection works continuously, not just during plan/apply operations
- Stacks feature provides advanced multi-workspace orchestration (examined in later sections)