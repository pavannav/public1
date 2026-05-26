<details open>
<summary><b>063-Deny-Policies-in-IAM-GCP (KK-CS45-script-v3)</b></summary>

# Session 63: Deny Policies in IAM GCP

## Table of Contents
- [Overview](#overview)
- [What are Deny Policies?](#what-are-deny-policies)
- [Structure of Deny Policies](#structure-of-deny-policies)
- [Common Use Cases](#common-use-cases)
- [Attachment Points](#attachment-points)
- [Required Roles](#required-roles)
- [Commands for Managing Deny Policies](#commands-for-managing-deny-policies)
- [Lab Demo: Creating a Deny Policy](#lab-demo-creating-a-deny-policy)
- [Lab Demo: Group-based Deny Rules](#lab-demo-group-based-deny-rules)
- [Lab Demo: Exceptions and Etag Updating](#lab-demo-exceptions-and-etag-updating)
- [Lab Demo: Conditional Deny Policies](#lab-demo-conditional-deny-policies)
- [Summary](#summary)

## Overview
This session covers Google Cloud IAM (Identity and Access Management) deny policies, which provide a powerful mechanism to explicitly prevent access to specific permissions regardless of any allow policies granted. Deny policies act as an additional layer of access control, checked before allow policies, and can be attached at organization, folder, or project levels with inheritance.

## What are Deny Policies?
Deny policies are IAM rules that explicitly prevent certain principals from using specific permissions, overriding any allow policies that might have been granted. Unlike allow policies, deny policies create absolute blocks on certain actions.

### Key Characteristics
- **Priority**: IAM always checks deny policies before allow policies
- **Inheritance**: Deny policies apply to child resources in the resource hierarchy
- **Absoluteness**: A denied permission cannot be granted back through allow policies at lower levels

### When to Use Deny Policies
- Prevent specific users from dangerous operations even with admin roles
- Centralize security controls at organization level
- Create exceptions to broad permissions
- Block inherited permissions at lower organizational levels

## Structure of Deny Policies

```json
{
  "name": "deny-policy-name",
  "uid": "unique-identifier",
  "etag": "version-identifier-for-updates",
  "rules": [
    {
      "denyRules": [
        {
          "deniedPrincipals": [
            "user:test-user@testdomain.com",
            "group:test-group@example.com"
          ],
          "deniedPermissions": [
            "compute.instances.create",
            "compute.instances.delete",
            "compute.disks.create"
          ],
          "denialCondition": {
            "title": "Only for non-test projects",
            "expression": "!resource.matchTag('environment','test')"
          }
        },
        {
          "deniedPrincipals": [
            "principal://iam.googleapis.com/groups/all"
          ],
          "exceptionPrincipals": [
            "user:admin@domain.com"
          ],
          "deniedPermissions": [
            "resourcemanager.projects.delete"
          ],
          "denialCondition": {
            "title": "Block deletion of non-test resources",
            "expression": "!resource.matchTag('environment','test')"
          }
        }
      ]
    }
  ]
}
```

### Components Breakdown

**Denied Principals**: Specify which users, groups, or service accounts cannot use the permissions
- Individual users: `"user:email@domain.com"`
- Groups: `"group:group-name@domain.com"`
- All principals: `"principal://iam.googleapis.com/groups/all"`

**Exception Principals**: Allow specific principals to bypass the deny rule while others in the group remain denied

**Denied Permissions**: Specific Google Cloud API permissions to block
- Must reference exact permission strings from GCP documentation
- Common examples: `compute.instances.create`, `storage.buckets.delete`

**Denial Conditions**: Optional IAM conditions that must be true for the deny rule to apply
- Uses Common Expression Language (CEL)
- Can reference resource tags, attributes, request metadata
- Example: Only deny when resource tag `environment != "test"`

## Common Use Cases

1. **Centralized Administrative Control**
   - Restrict critical administrative activities to specific principals
   - Delegate limited admin access while maintaining core security controls

2. **Exception to Allow Grants**
   - Grant broad permissions at organization level
   - Use deny policies to create targeted restrictions on specific users or groups

3. **Inheriting Permissions Control**
   - Grant permissions at higher organizational levels
   - Override inherited permissions at project or folder level with deny policies

4. **Resource-Based Blocking**
   - Use conditions based on resource tags
   - Block access to production resources while allowing development access

## Attachment Points
Deny policies can be attached at three levels in the GCP resource hierarchy:

- **Organization Level**: Policies inherit to all folders, projects, and resources
- **Folder Level**: Policies inherit to child folders and their projects/resources  
- **Project Level**: Policies apply only to the specific project and its resources

> [!NOTE] 
> Attachment level determines the scope of inheritance - organization-level deny policies have the broadest impact.

## Required Roles

### To View Deny Policies
- `roles/iam.denyAdmin` OR
- `roles/iam.securityReviewer`

### To Create/Update/Delete Deny Policies  
- `roles/iam.denyAdmin`

The `roles/iam.denyAdmin` role provides full lifecycle management of deny policies.

> [!IMPORTANT]
> Deny policies require careful management as they can create access issues when misconfigured. Always test policy changes in development environments first.

## Commands for Managing Deny Policies

### Create a Deny Policy
```bash
gcloud iam policies create POLICY_ID \
  --attachment-point=organizations/ORG_ID_OR_folders/FOLDER_ID_OR_projects/PROJECT_ID \
  --kind=denypolicy \
  --policy-file=POLICY_FILE.json
```

### List Deny Policies
```bash
gcloud iam policies list \
  --attachment-point=organizations/ORG_ID_OR_folders/FOLDER_ID_OR_projects/PROJECT_ID
```

### View a Deny Policy
```bash
gcloud iam policies get POLICY_ID \
  --attachment-point=organizations/ORG_ID_OR_folders/FOLDER_ID_OR_projects/PROJECT_ID \
  --format=json
```

### Update a Deny Policy
```bash
gcloud iam policies update POLICY_ID \
  --attachment-point=organizations/ORG_ID_OR_folders/FOLDER_ID_OR_projects/PROJECT_ID \
  --kind=denypolicy \
  --policy-file=POLICY_FILE.json \
  --etag=ETAG_FROM_POLICY
```

### Delete a Deny Policy
```bash
gcloud iam policies delete POLICY_ID \
  --attachment-point=organizations/ORG_ID_OR_folders/FOLDER_ID_OR_projects/PROJECT_ID \
  --kind=denypolicy \
  --etag=ETAG_FROM_POLICY
```

> [!WARNING]
> Always capture the current ETag before updating policies to avoid conflicts with concurrent modifications.

## Lab Demo: Creating a Deny Policy

### Scenario
Create a deny policy that prevents a test user with Compute Engine Admin role from creating or deleting VM instances.

### Steps

1. **Grant Required Permissions**
   - Assign `roles/compute.admin` to test user (normally allows full VM management)

2. **Create Policy File**
```json
{
  "name": "deny-compute-admin",
  "rules": [
    {
      "denyRules": [
        {
          "deniedPrincipals": [
            "user:test-user@testdomain.com"
          ],
          "deniedPermissions": [
            "compute.instances.create",
            "compute.instances.delete", 
            "compute.disks.create"
          ]
        }
      ]
    }
  ]
}
```

3. **Create the Policy**
```bash
gcloud iam policies create compute-ops \
  --attachment-point=projects/YOUR_PROJECT_ID \
  --kind=denypolicy \
  --policy-file=deny-compute.json
```

4. **Verify Effect**
   - Test user can no longer create new VM instances
   - Test user can no longer delete existing instances
   - Test user retains other compute admin permissions (start, stop, metadata changes)

## Lab Demo: Group-based Deny Rules

### Scenario
Deny network creation and deletion permissions from all members of a specific Google Group.

### Steps

1. **Identify Target Group**
   - Located in GCP IAM at Organization → Groups
   - Format: `group:group-name@domain.com`

2. **Create Policy File for Group denial**
```json
{
  "name": "deny-network-operations",
  "rules": [
    {
      "denyRules": [
        {
          "deniedPrincipals": [
            "group:test-users@domain.com"
          ],
          "deniedPermissions": [
            "compute.networks.create",
            "compute.networks.delete"
          ]
        }
      ]
    }
  ]
}
```

3. **Apply Policy**
```bash
gcloud iam policies create deny-network-ops \
  --attachment-point=projects/YOUR_PROJECT_ID \
  --kind=denypolicy \
  --policy-file=deny-network.json
```

4. **Verify Group Denial**
   - All group members lose VPC network creation/deletion permissions
   - Even users with Network Admin role are blocked

## Lab Demo: Exceptions and Etag Updating

### Scenario
Add an exception to allow a critical administrator to bypass group-level deny rules.

### Steps

1. **Update Policy File with Exception**
```json
{
  "name": "deny-network-operations", 
  "rules": [
    {
      "denyRules": [
        {
          "deniedPrincipals": [
            "group:test-users@domain.com"
          ],
          "exceptionPrincipals": [
            "user:admin@domain.com"
          ],
          "deniedPermissions": [
            "compute.networks.create",
            "compute.networks.delete"
          ]
        }
      ]
    }
  ]
}
```

2. **Capture Current ETag**
```bash
gcloud iam policies get deny-network-ops \
  --attachment-point=projects/YOUR_PROJECT_ID \
  --format="value(etag)"
```

3. **Update Policy with ETag**
```bash
gcloud iam policies update deny-network-ops \
  --attachment-point=projects/YOUR_PROJECT_ID \
  --kind=denypolicy \
  --policy-file=deny-network.json \
  --etag="captured-etag-here"
```

4. **Verify Exception**
   - Admin user can now create/delete networks
   - Other group members remain denied

## Lab Demo: Conditional Deny Policies

### Scenario
Apply deny rules only to resources with specific tags, demonstrating resource-based access control.

### Steps

1. **Setup Resource Tags**
   - Create tag key: `externalIP`
   - Create tag values: `yes`, `no`
   - Apply to projects/resources as needed

2. **Create Conditional Policy**
```json
{
  "name": "deny-network-operations",
  "rules": [
    {
      "denyRules": [
        {
          "deniedPrincipals": [
            "group:test-users@domain.com"
          ],
          "exceptionPrincipals": [
            "user:admin@domain.com"
          ],
          "deniedPermissions": [
            "compute.networks.create",
            "compute.networks.delete"
          ],
          "denialCondition": {
            "title": "Only when external IP allowed",
            "expression": "resource.matchTag('externalIP','yes')"
          }
        }
      ]
    }
  ]
}
```

3. **Update Policy**
   - Capture new ETag and update policy

4. **Test Conditions**
   - When tag `externalIP=yes`: Deny policy active
   - When tag `externalIP=no`: Deny policy inactive

### Tag Management
Update resource tags through IAM → Resources section to control policy activation.

## Summary

### Key Takeaways
```diff
+ Deny policies provide absolute restrictions on specific permissions
+ IAM evaluates deny policies before allow policies  
+ Deny policies inherit down the resource hierarchy
+ ETag management prevents concurrent modification conflicts
+ Conditions enable context-aware access control
- Deny policies cannot be shortcut by grant policies at any level
- Misconfigured deny policies can lock out critical users
- Always test deny policies in non-production environments first
```

### Quick Reference

| Command | Purpose | Required |
|---------|---------|----------|
| `gcloud iam policies create` | Create new deny policy | denyAdmin role |
| `gcloud iam policies get` | View policy details and ETag | denyAdmin/securityReviewer |
| `gcloud iam policies update --etag=ETAG` | Modify existing policy | denyAdmin role + correct ETag |
| `gcloud iam policies delete` | Remove deny policy | denyAdmin role + correct ETag |

### Deny Policy JSON Structure Template
```json
{
  "name": "policy-name",
  "rules": [{
    "denyRules": [{
      "deniedPrincipals": ["user:email@domain.com"],
      "exceptionPrincipals": ["user:admin@domain.com"], // optional
      "deniedPermissions": ["service.permission"],
      "denialCondition": {                           // optional
        "expression": "resource.matchTag('tag-key','tag-value')"
      }
    }]
  }]
}
```

### Expert Insights

**Real-world Application**: Deny policies excel in enterprise environments where you need ironclad guarantees against accidental data deletion or system modifications. They're particularly valuable for compliance scenarios where certain privileged operations must be absolutely restricted, regardless of role assignments.

**Expert Path**: Learn to combine deny policies with IAM Conditions for dynamic access control based on resource attributes, request context, and time-based restrictions. Study Google's well-architected framework for hierarchical access control patterns.

**Common Pitfalls**: 
- Forgetting to update the ETag during policy modifications
- Creating overly broad deny principals that impact unintended users
- Not testing conditional expressions thoroughly across different resource types
- Assuming deny policies can be overridden by allow policies (they cannot)

</details>
