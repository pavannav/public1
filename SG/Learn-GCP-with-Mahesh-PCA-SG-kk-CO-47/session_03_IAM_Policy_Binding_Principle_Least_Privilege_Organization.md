# Session 03: IAM Policy Binding, Principle of Least Privilege, Organization Concepts

## Table of Contents

- [Overview](#overview)
- [Principle of Least Privilege Demo](#principle-of-least-privilege-demo)
  - [Use Case Requirements](#use-case-requirements)
  - [Testing Basic Roles](#testing-basic-roles)
    - [Editor Role - Over-Privileged](#editor-role---over-privileged)
    - [Viewer Role - Under-Privileged](#viewer-role---under-privileged)
  - [Testing Predefined Roles](#testing-predefined-roles)
    - [Compute Engine Admin + Storage Admin](#compute-engine-admin--storage-admin)
  - [Creating Custom Roles](#creating-custom-roles)
    - [Custom Compute Instance Admin](#custom-compute-instance-admin)
    - [Storage Object Creator Role](#storage-object-creator-role)
  - [Bucket-Level Access Granting](#bucket-level-access-granting)
- [IAM Policy Binding](#iam-policy-binding)
  - [Understanding the Concept](#understanding-the-concept)
  - [gcloud Commands](#gcloud-commands)
  - [gsutil Commands for Buckets](#gsutil-commands-for-buckets)
- [Project IAM Admin Role - Security Warning](#project-iam-admin-role---security-warning)
- [Resource Manager & Organization Hierarchy](#resource-manager--organization-hierarchy)
  - [Resource Hierarchy Structure](#resource-hierarchy-structure)
  - [Why Organization Node?](#why-organization-node)
  - [Policy Inheritance](#policy-inheritance)
- [Organization Policies](#organization-policies)
  - [External IP Restriction](#external-ip-restriction)
  - [Public Access Prevention](#public-access-prevention)
- [Custom Roles at Organization Level](#custom-roles-at-organization-level)
- [Summary](#summary)

---

## Overview

This session demonstrates the practical application of IAM roles using the **Principle of Least Privilege**. Through a real-world use case, we explore why basic roles fail, how predefined roles may still be over-privileged, and how to create custom roles that precisely match requirements. The session also covers IAM policy binding concepts and introduces the Organization resource hierarchy for enterprise-scale IAM management.

---

## Principle of Least Privilege Demo

### Use Case Requirements

**Scenario**: Mahesh joins as a new engineer with a Gmail account. Requirements:

| Requirement | Allowed | Not Allowed |
|-------------|---------|-------------|
| VM Operations | Create, Start, Stop, SSH | Delete VM |
| Storage Operations | Upload/Create objects | Create/Delete buckets, Delete objects |
| Scope | Specific bucket only | All buckets in project |

**Goal**: Find the minimal set of roles that fulfill these requirements exactly.

### Testing Basic Roles

#### Editor Role - Over-Privileged

**Grant Process**:
```bash
# Via Console: IAM → Grant Access → Select user → Basic → Editor
```

**Verification via Role Permissions**:
- Search `compute.instances.stop` → Found (8,693 total permissions)
- Search `compute.instances.delete` → Found ❌
- Search `storage.buckets.delete` → Found ❌

**Test Results**:
```diff
+ VM Creation: SUCCESS
+ SSH Access: SUCCESS
+ VM Start/Stop: SUCCESS
- VM Deletion: SUCCESS (should be blocked!)
- Bucket Creation: SUCCESS (should be blocked!)
- Object Deletion: SUCCESS (should be blocked!)
- Bucket Deletion: SUCCESS (should be blocked!)
```

**Conclusion**: Editor role has 8,693 permissions - far too broad for this use case.

#### Viewer Role - Under-Privileged

**Grant Process**:
```bash
# Via Console: IAM → Grant Access → Select user → Basic → Viewer
```

**Test Results**:
```diff
- VM Creation: BLOCKED (expected)
- VM Start/Stop/SSH: BLOCKED (expected)
- Object Upload: BLOCKED (expected)
```

**Conclusion**: Viewer role provides read-only access - insufficient for the requirements.

### Testing Predefined Roles

#### Compute Engine Admin + Storage Admin

**Grant Process**:
```bash
# Compute Engine Admin (868 permissions)
# Storage Admin (55 permissions)
```

**Test Results**:
```diff
+ VM Creation: SUCCESS
+ SSH: SUCCESS
- VM Deletion: SUCCESS (should be blocked!)
+ Bucket Creation: SUCCESS (should be blocked!)
- Object Deletion: SUCCESS (should be blocked!)
```

**Analysis**:
- Compute Engine Admin contains `compute.instances.delete`
- Storage Admin contains `storage.buckets.delete` and `storage.objects.delete`

**Conclusion**: Predefined roles are still over-privileged for this specific use case.

### Creating Custom Roles

#### Custom Compute Instance Admin

**Steps**:
1. Navigate to **Roles** → **Create Role**
2. Configure:
   - **Title**: `Custom Compute Instance Admin`
   - **Description**: `Created for VM start/stop without delete - [Date]`
   - **ID**: `custom.compute.instance.admin`
   - **Stage**: `General Availability`
3. Add permissions:
   - `compute.instances.start`
   - `compute.instances.stop`
4. **Remove**: `compute.instances.delete`
5. Click **Create**

**Result**: 404 permissions (down from 868 in Compute Engine Admin)

#### Storage Object Creator Role

**Analysis**:
| Role | Permissions | Buckets.create | Buckets.delete | Objects.create | Objects.delete |
|------|-------------|----------------|----------------|----------------|----------------|
| Storage Admin | 55 | ✅ | ✅ | ✅ | ✅ |
| Storage Object Creator | 8 | ❌ | ❌ | ✅ | ❌ |

**Selection**: `Storage Object Creator` role (8 permissions) perfectly matches requirements.

### Bucket-Level Access Granting

**When project-level access is too broad**:

**Console Method**:
```
1. Navigate to specific bucket
2. Click "Permissions" tab
3. "Add Principal" → Enter user email
4. Select "Storage Object Creator" role
5. Save
```

**Result**: User can only access the specific bucket, not list or access other buckets.

---

## IAM Policy Binding

### Understanding the Concept

**Definition**: IAM Policy Binding is the association between a **principal** (user, group, service account) and an **IAM role**.

```diff
! Principal (user/group/SA) + IAM Role = Policy Binding
```

**UI vs CLI Terminology**:
- Console shows "Grant Access" (hides the binding concept)
- CLI explicitly uses `add-iam-policy-binding`

### gcloud Commands

**Get Current Policy**:
```bash
# YAML format
gcloud projects get-iam-policy PROJECT_ID

# JSON format
gcloud projects get-iam-policy PROJECT_ID --format=json > iam.json
```

**Add Policy Binding**:
```bash
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="user:simplegcpuser@gmail.com" \
  --role="roles/viewer"
```

**Remove Policy Binding**:
```bash
gcloud projects remove-iam-policy-binding PROJECT_ID \
  --member="user:simplegcpuser@gmail.com" \
  --role="roles/viewer"
```

**Grant to Google Workspace Domain**:
```bash
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="domain:company.com" \
  --role="roles/viewer"
```

### gsutil Commands for Buckets

**Grant Bucket-Level Access**:
```bash
gsutil iam ch user:simplegcpuser@gmail.com:roles/storage.objectCreator \
  gs://bucket-name
```

**Verify Access**:
```bash
gsutil ls gs://bucket-name  # Permission denied (cannot list)
gsutil cp file.txt gs://bucket-name  # Success (can create objects)
gsutil rm gs://bucket-name/file.txt  # Permission denied (cannot delete)
```

---

## Project IAM Admin Role - Security Warning

**Role ID**: `roles/resourcemanager.projectIamAdmin`

**Permissions**: 9 permissions including:
- `resourcemanager.projects.setIamPolicy`
- `resourcemanager.projects.getIamPolicy`

**Critical Security Risk**:
```diff
! A user with Project IAM Admin can:
!   1. Grant themselves the Owner role
!   2. Remove the original project owner
!   3. Take complete control of the project
```

**Real-World Analogy**: Similar to historical colonization - "just give me this small role" leads to complete takeover.

**Recommendation**: ⚠️ Avoid granting this role unless absolutely necessary. If granted, monitor closely.

---

## Resource Manager & Organization Hierarchy

### Resource Hierarchy Structure

```
Organization Node (Top)
    ├── Folder
    │   └── Project
    │       └── Resources (VMs, Buckets, etc.)
    └── Project (Direct)
        └── Resources
```

**Key Points**:
- **Organization Node**: Topmost level, requires Google Workspace or Cloud Identity
- **Folders**: Logical grouping of projects (similar to organizing documents)
- **Projects**: Billing boundary, where resources are created
- **Resources**: Actual GCP services (VMs, buckets, databases)

### Why Organization Node?

| Benefit | Description |
|---------|-------------|
| **Centralized IAM Policies** | Apply policies at org level, inherit to all projects |
| **Organization Policies** | Enforce constraints across entire organization |
| **Custom Role Reusability** | Create once at org level, use across all projects |
| **Audit & Compliance** | Centralized security controls |

**Without Organization Node**: Each project is independent (like a freelancer with no employer policies).

### Policy Inheritance

**Flow Direction**: Top → Bottom (Organization → Folders → Projects → Resources)

**Transitive Nature**:
```
Organization Level: Bob = Editor
    ↓ (inherited)
Folder Level: Bob = Editor
    ↓ (inherited)
Project Level: Bob = Editor
    ↓ (inherited)
Resource Level (Pub/Sub): Bob = Editor
```

**Inheritance Rule**: Resources inherit policies from their parent project, which inherits from folders, which inherits from the organization.

---

## Organization Policies

### External IP Restriction

**Policy Constraint**: `constraints/compute.vmExternalIpAccess`

**Purpose**: Prevent VMs from having external IP addresses, reducing attack surface (DDoS, etc.).

**Configuration**:
```
At Organization Level:
  - Set to "Deny" (no external IPs allowed)

At Specific Project (Exception):
  - Override to "Allow" (this project can have external IPs)
```

**Result**: VMs in restricted projects only have internal IPs and cannot access the internet without Cloud NAT.

### Public Access Prevention

**Policy Constraint**: `constraints/storage.publicAccessPrevention`

**Purpose**: Prevent buckets from being exposed to the public internet.

**Enforcement**:
```
At Organization Level: Enforce prevention
At Project Level: Inherit from parent (cannot override)
```

**Effect**: Existing public buckets become private; new buckets cannot be made public.

---

## Custom Roles at Organization Level

**Problem with Project-Level Custom Roles**:
```
Dev Project: custom.compute.admin (404 permissions)
Test Project: Must recreate the same role
Prod Project: Must recreate the same role
```

**Solution - Organization-Level Custom Roles**:
```
Organization: custom.compute.admin (created once)
    ├── Dev Project: Can use custom.compute.admin
    ├── Test Project: Can use custom.compute.admin
    └── Prod Project: Can use custom.compute.admin
```

**Verification**:
- Organization-level: `organizations/ORGANIZATION_ID/roles/role_name`
- Project-level: `projects/PROJECT_ID/roles/role_name`

**Limitation**: Custom roles **cannot** be created at the folder level - only at organization or project level.

---

## Summary

### Key Takeaways

```diff
+ Principle of Least Privilege requires iterative testing of roles
+ Basic roles (Editor/Viewer) rarely match specific requirements
+ Predefined roles may still be over-privileged for custom use cases
+ Custom roles provide precise permission control (404 vs 868 permissions)
+ IAM Policy Binding = Principal + Role association
+ Organization hierarchy enables centralized policy management
+ Policy inheritance flows top-down and is transitive
+ Organization policies enforce security constraints at scale
+ Custom roles at org level are reusable across all projects
- Project IAM Admin role can lead to privilege escalation
- Never expose buckets publicly without business justification
```

### Quick Reference

| Task | Console Path | gcloud Command |
|------|--------------|----------------|
| Grant project access | IAM → Grant Access | `gcloud projects add-iam-policy-binding` |
| Grant bucket access | Bucket → Permissions | `gsutil iam ch` |
| Create custom role | Roles → Create Role | `gcloud iam roles create` |
| View current policy | IAM page | `gcloud projects get-iam-policy` |
| Create org node | IAM → Organization | Requires Workspace/Cloud Identity |
| Apply org policy | Organization → Policies | Via Console or gcloud |

### Expert Insight

**Real-world Application**:
In enterprise environments, start with predefined roles for standard use cases. When requirements are highly specific (like "start/stop VMs but never delete"), create custom roles. Always test with a non-production identity first. Use organization-level custom roles for consistency across environments (dev/test/prod).

**Expert Path**:
1. Master the gcloud/gsutil IAM commands for automation
2. Implement organization policies for security baselines
3. Create a library of custom roles for common patterns
4. Use policy simulator to test role combinations before granting
5. Implement regular IAM audits using `gcloud projects get-iam-policy`

**Common Pitfalls**:
- Granting Editor role "just to get started" - leads to security debt
- Creating project-level custom roles instead of org-level - causes maintenance overhead
- Not understanding that Project IAM Admin can escalate to Owner
- Exposing storage buckets publicly without realizing the security implications
- Assuming folder-level custom role creation is possible (it's not)

**Lesser-Known Facts**:
- Editor role has 8,693+ permissions and this number grows with new services
- Only 11 out of 1,600+ roles can grant IAM roles to others
- Organization policies apply retrospectively to existing resources
- Custom roles at org level show `organizations/ORG_ID/roles/name` format
- Resources can only be created at project level, never at folder or org level
- Google-managed service accounts are hidden in Console but visible via CLI

---

*Session Duration: ~90 minutes | Focus: Practical IAM role selection and organization hierarchy*