# Session 63: Deny Policies in IAM GCP

## Table of Contents
- [What are Deny Policies?](#what-are-deny-policies?)
- [Structure of Deny Policies](#structure-of-deny-policies)
- [Use Cases for Deny Policies](#use-cases-for-deny-policies)
- [Attachment Points and Inheritance](#attachment-points-and-inheritance)
- [Required Roles and Commands](#required-roles-and-commands)
- [Demo: Creating and Managing Deny Policies](#demo-creating-and-managing-deny-policies)
- [Summary](#summary)

## What are Deny Policies?

### Overview
Deny policies in Google Cloud Identity and Access Management (IAM) provide a way to explicitly restrict certain permissions for specific principals, even if those permissions have been granted through allow policies. Unlike allow policies that grant access, deny policies act as an override, ensuring that prohibited actions cannot be performed regardless of other role assignments.

> [!IMPORTANT]
> Deny policies take precedence over allow policies. IAM always evaluates deny rules before checking allow permissions, making them a powerful tool for enforcing security boundaries.

### Key Concepts/Deep Dive
Deny policies work by defining rules that specify:
- **Principals**: The users, groups, or service accounts to which the denial applies.
- **Permissions**: The specific permissions being denied (e.g., compute.instances.create).
- **Conditions** (optional): CEL expressions that determine when the denial should apply.

💡 **Key Point**: If a principal has been granted permissions through an allow policy but is listed in a deny policy, the deny policy wins. This is crucial for implementing least-privilege access and preventing privilege escalation.

Deny policies are particularly useful in scenarios where you need to:
- Centralize administrative controls
- Create exceptions to broad permission grants
- Deny inherited permissions at lower resource levels
- Apply restrictions based on resource tags or attributes

### Lab Demos
No lab demos are explicitly included in this section.

## Structure of Deny Policies

### Overview
A deny policy consists of several key components that define exactly what permissions are being restricted and under what conditions.

### Key Concepts/Deep Dive
The deny policy structure includes:
- **Name**: A user-defined identifier for the policy.
- **UID**: A unique identifier automatically assigned by Google Cloud.
- **ETag**: A version identifier used for concurrent modification control.
- **Deny Rules**: An array of rules defining the denials.

Each deny rule contains:
- **Denied Principals**: The principals being denied permissions.
- **Exception Principals** (optional): Principals that should be exempt from the denial.
- **Denied Permissions**: The list of permissions being restricted.
- **Condition** (optional): A CEL expression that must evaluate to true for the denial to apply.

### Code/Config Blocks
Here's an example deny policy structure in YAML:

```yaml
name: deny-compute-admin
uid: generated-by-google
etag: "version-id"
rules:
  - deniedPrincipals:
      - principals: ["principal://iam.googleapis.com/projects/my-project/serviceAccounts/test-user@test-project.iam.gserviceaccount.com"]
    exceptionPrincipals:
      - principals: ["principal://iam.googleapis.com/projects/my-project/serviceAccounts/admin-user@test-project.iam.gserviceaccount.com"]
    deniedPermissions:
      - compute.instances.create
      - compute.instances.delete
      - compute.disks.create
    condition:
      expression: resource.matchTag("environment", "production")
```

> [!NOTE]
> The `exceptionPrincipals` field allows you to create whitelist-style exceptions within a deny rule, useful for maintaining administrative access while broadly denying permissions to others.

## Use Cases for Deny Policies

### Overview
Deny policies provide granular control over permissions in complex organizational hierarchies.

### Key Concepts/Deep Dive

**Centralized Administrative Controls**: Restrict certain actions to a specific set of administrators, ensuring that even users with broad roles cannot perform sensitive operations.

```diff
+ Centralized admin restrictions prevent unauthorized privilege escalation
- Broad role grants without deny policies can lead to security vulnerabilities
```

**Exceptions to Access Grants**: Allow broad permissions at a high level (organization/folder) while denying specific actions for certain principals.

**Denying Inherited Permissions**: Grant roles at higher resource levels but deny specific permissions at lower levels.

**Access Blocking Based on Tags**: Use resource tags to selectively apply deny policies based on resource attributes.

### Lab Demos
No explicit lab demos in this section, but reference the full demo section for practical implementation.

## Attachment Points and Inheritance

### Overview
Deny policies can be attached at different levels in the Google Cloud resource hierarchy and are inherited by child resources.

### Key Concepts/Deep Dive
Attachment points for deny policies:
- **Organization**: Inherited by all folders and projects within the organization.
- **Folder**: Inherited by all projects within the folder.
- **Project**: Applies to resources within that specific project and its sub-resources.

⚠️ Inheritance follows the resource hierarchy:
```
Organization
├── Folder (inherits org Policy)
│   └── Project (inherits folder and org Policies)
│       └── Resources (inherit all Policies)
```

This allows for layered security controls where broad denials can be set at higher levels and exceptions managed at lower levels.

### Tables

| Attachment Point | Scope of Application | Use Case |
|------------------|----------------------|----------|
| Organization | All resources in organization and below | Enterprise-wide security policies |
| Folder | All resources in folder and projects below | Department-level restrictions |
| Project | Resources within specific project | Project-specific prohibitions |

## Required Roles and Commands

### Overview
Managing deny policies requires specific IAM roles, and the gcloud CLI provides comprehensive command-line tools for policy lifecycle management.

### Key Concepts/Deep Dive

**Required IAM Roles**:
- **IAM Deny Policy Viewer**: Allows viewing deny policies.
- **IAM Deny Policy Admin**: Allows creating, updating, and deleting deny policies.

### Code/Config Blocks

Key gcloud iam deny-policies commands:

```bash
# Create a deny policy
gcloud iam deny-policies create POLICY_ID \
  --attachment-point=organizations/ORG_ID \
  --policy-file=policy.yaml

# List deny policies
gcloud iam deny-policies list \
  --attachment-point=organizations/ORG_ID

# Get a specific deny policy
gcloud iam deny-policies get POLICY_ID \
  --attachment-point=organizations/ORG_ID

# Update a deny policy (requires matching etag)
gcloud iam deny-policies update POLICY_ID \
  --attachment-point=organizations/ORG_ID \
  --policy-file=updated-policy.yaml \
  --etag=VERSION_ID

# Delete a deny policy
gcloud iam deny-policies delete POLICY_ID \
  --attachment-point=organizations/ORG_ID
```

💡 **Tip**: The `--etag` parameter is crucial for updates to prevent concurrent modification conflicts.

### Lab Demos
See the full demo section for step-by-step command execution examples.

## Demo: Creating and Managing Deny Policies

### Overview
This demonstration shows creating deny policies to restrict compute and network permissions, applying them to users and groups, adding exceptions, and using conditions.

### Key Concepts/Deep Dive
The demo covers:
1. Creating a VM with compute admin permissions
2. Implementing deny policies for specific users and groups
3. Adding exception principals
4. Applying conditional denials based on resource tags

> [!IMPORTANT]
> Deny policies take effect within minutes of creation and immediately override any conflicting allow permissions.

### Lab Demos

#### Demo 1: Deny Compute Permissions for a User

**Step 1: Create a policy file (deny-compute.json)**

```json
{
  "displayName": "Deny Compute Admin",
  "rules": [
    {
      "deniedPrincipals": [
        "principal://iam.googleapis.com/projects/test-project/serviceAccounts/test-user@test-project.iam.gserviceaccount.com"
      ],
      "deniedPermissions": [
        "compute.instances.create",
        "compute.instances.delete",
        "compute.disks.create",
        "compute.disks.delete"
      ]
    }
  ]
}
```

**Step 2: Create the deny policy**

```bash
gcloud iam deny-policies create deny-compute-ops \
  --attachment-point=projects/test-project \
  --policy-file=deny-compute.json
```

**Step 3: Verify the policy creation**

```bash
gcloud iam deny-policies list --attachment-point=projects/test-project
gcloud iam deny-policies get deny-compute-ops --attachment-point=projects/test-project
```

**Expected Result**: The test user can no longer create/delete instances or disks, despite having compute admin role.

#### Demo 2: Deny Network Permissions for a Group with Exceptions

**Step 1: Create policy file with group denial and exception (deny-network.json)**

```json
{
  "displayName": "Deny Network Permissions",
  "rules": [
    {
      "deniedPrincipals": [
        "principal://googlegroups.com/groups/test-group"
      ],
      "exceptionPrincipals": [
        "principal://iam.googleapis.com/projects/test-project/serviceAccounts/admin-user@test-project.iam.gserviceaccount.com"
      ],
      "deniedPermissions": [
        "compute.networks.create",
        "compute.networks.delete"
      ]
    }
  ]
}
```

**Step 2: Create and apply the policy**

```bash
gcloud iam deny-policies create deny-network-ops \
  --attachment-point=projects/test-project \
  --policy-file=deny-network.json
```

**Step 3: Update the policy with conditions (optional)**

First, retrieve the updated etag:

```bash
gcloud iam deny-policies get deny-network-ops \
  --attachment-point=projects/test-project \
  --format="export" > deny-network-updated.json
```

Modify the JSON to add the condition:

```json
{
  "etag": "retrieved-etag-from-get-command",
  "displayName": "Deny Network Permissions",
  "rules": [
    {
      "deniedPrincipals": [
        "principal://googlegroups.com/groups/test-group"
      ],
      "exceptionPrincipals": [
        "principal://iam.googleapis.com/projects/test-project/serviceAccounts/admin-user@test-project.iam.gserviceaccount.com"
      ],
      "deniedPermissions": [
        "compute.networks.create",
        "compute.networks.delete"
      ],
      "condition": {
        "expression": "resource.matchTag(\"external-ip\", \"yes\")"
      }
    }
  ]
}
```

Update the policy:

```bash
gcloud iam deny-policies update deny-network-ops \
  --attachment-point=projects/test-project \
  --policy-file=deny-network-updated.json
```

**Step 4: Test condition-based behavior**
- Change the project tag "external-ip" from "yes" to "no"
- The deny policy becomes ineffective
- Restore the tag to "yes" to re-enable the denial

### Code/Config Blocks
The demo uses complete policy configurations as shown in the lab steps. No additional code blocks are needed beyond what's provided.

## Summary

### Key Takeaways
```diff
+ Deny policies always override allow policies, providing a security-first approach
+ Use exception principals to create whitelist-like exceptions within denial rules
+ Conditions enable dynamic denial based on resource tags and attributes
+ Policies inherit through the resource hierarchy from organization to project to resources
! ETag management is critical for updating policies to prevent concurrent modification conflicts
- Failing to test deny policies can lock out users unexpectedly
```

### Expert Insight

**Real-world Application**: In large enterprises, deny policies are essential for implementing compliance controls, such as preventing resource creation in non-production environments or blocking public IP assignments in sensitive projects. They're particularly valuable in scenarios requiring zero-trust security models where broad permissions are granted at high levels but carefully restricted at lower levels.

**Expert Path**: Master deny policies by focusing on condition expressions using CEL (Common Expression Language). Understand tag inheritance, resource hierarchies, and the order of evaluation (deny before allow). Practice creating layered policies with exceptions to handle complex organizational structures.

**Common Pitfalls**: 
- Forgetting etag management during updates, leading to policy modification failures.
- Applying deny policies too broadly without exceptions, causing operational disruptions.
- Using resource-level conditions incorrectly (conditions work at attachment level, not individual resources).
- Misunderstanding inheritance can lead to unexpected permission grants or denials.

- Issues with etag conflicts arise from concurrent modifications; always fetch the current etag before updating.
- Network and compute denials may be mistaken for role restrictions rather than explicit policy overrides.
- Fewer known aspects include deny policies supporting audit-only modes for testing without enforcement.

## Transcript Corrections
The following corrections were made to spellings, technical terms, and clarity based on standard Google Cloud IAM terminology and proper English:
- "principle" corrected to "principal" (IAM concept)
- "Deni" corrected to "deny"
- "IM" corrected to "IAM" (Identity and Access Management)
- "eag" corrected to "etag" 
- "mach t" corrected to "match"
- "PES" corrected to "policies" (context: "administrative policies")
- "PO" corrected to "policies"
- "Ro" corrected to "role" 
- "comput engine" corrected to "compute engine"
- "cr" corrected to "create" in command contexts
- "vh" corrected to "vpc" (Virtual Private Cloud)
- Various "uh" filler words removed for clarity
- "ad" corrected to "admin" (administrator)
- Minor grammatical fixes for readability while preserving original meaning

These corrections ensure technical accuracy and improve comprehension without altering the core content.
