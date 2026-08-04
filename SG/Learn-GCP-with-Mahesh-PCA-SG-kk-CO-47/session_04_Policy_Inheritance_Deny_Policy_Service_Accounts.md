# Session 04: Policy Inheritance, Deny Policy, Service Account Concepts - Part 1

## Table of Contents

- [Overview](#overview)
- [Policy Inheritance Scenarios](#policy-inheritance-scenarios)
  - [High Privilege at Organization Level](#high-privilege-at-organization-level)
    - [Creating Test User via Cloud Identity](#creating-test-user-via-cloud-identity)
    - [Granting Editor Role at Organization Level](#granting-editor-role-at-organization-level)
    - [Testing Inherited Access](#testing-inherited-access)
    - [Attempting to Restrict with Viewer Role](#attempting-to-restrict-with-viewer-role)
    - [Union Operation Behavior](#union-operation-behavior)
  - [Browser Role for Hierarchy Visibility](#browser-role-for-hierarchy-visibility)
  - [Low Privilege at Organization Level (Recommended Approach)](#low-privilege-at-organization-level-recommended-approach)
    - [Granting Browser Role at Organization Level](#granting-browser-role-at-organization-level)
    - [Granting Higher Privileges at Folder/Project Level](#granting-higher-privileges-at-folderproject-level)
- [IAM Propagation Delays](#iam-propagation-delays)
- [Deny Policy - Override Mechanism](#deny-policy---override-mechanism)
  - [Use Case: Blocking Role Creation](#use-case-blocking-role-creation)
  - [Creating Deny Policy via gcloud](#creating-deny-policy-via-gcloud)
  - [Testing Deny Policy Effectiveness](#testing-deny-policy-effectiveness)
  - [Limitations and Scope](#limitations-and-scope)
- [Service Account Fundamentals](#service-account-fundamentals)
  - [Identity Concept](#identity-concept)
  - [Key Characteristics](#key-characteristics)
    - [Multiple VMs, Single Service Account](#multiple-vms-single-service-account)
    - [Authentication via Keys](#authentication-via-keys)
    - [Service Account Types](#service-account-types)
- [Service Account Demo: VM to GCS Data Transfer](#service-account-demo-vm-to-gcs-data-transfer)
  - [Architecture Requirements](#architecture-requirements)
  - [Three Implementation Approaches](#three-implementation-approaches)
    - [Approach 1: Compute Engine Default Service Account (Problematic)](#approach-1-compute-engine-default-service-account-problematic)
      - [Access Scopes Concept](#access-scopes-concept)
      - [Problems Encountered](#problems-encountered)
    - [Approach 2: User-Created Service Account (Recommended)](#approach-2-user-created-service-account-recommended)
      - [Creating Custom Service Account](#creating-custom-service-account)
      - [Granting Storage Admin Role](#granting-storage-admin-role)
      - [Handling Requirement Changes](#handling-requirement-changes)
    - [Approach 3: Dangerous Configuration](#approach-3-dangerous-configuration)
      - [Editor Role + Full Access Scope](#editor-role--full-access-scope)
      - [Demonstration of Risks](#demonstration-of-risks)
- [Cross-Project Service Account Access](#cross-project-service-account-access)
  - [UI Demonstration](#ui-demonstration)
  - [Best Practices for Cross-Project Access](#best-practices-for-cross-project-access)
- [Summary](#summary)

---

## Overview

This session builds upon the IAM concepts from Day 3 by demonstrating **policy inheritance behavior** through two contrasting scenarios: high privilege at the organization level versus low privilege at the organization level. We explore why granting broad permissions at the top of the hierarchy creates problems that cannot be easily overridden. The session introduces **Deny Policies** as a mechanism to block specific permissions even when granted by roles. Finally, we dive deep into **Service Accounts** through a practical VM-to-GCS data transfer demonstration, comparing three implementation approaches and their implications.

---

## Policy Inheritance Scenarios

### High Privilege at Organization Level

**Objective**: Demonstrate why granting high-privilege roles (Editor) at the organization level creates unmanageable access that cannot be effectively restricted at lower levels.

#### Creating Test User via Cloud Identity

**Process**:
```
1. Navigate to Organization → IAM & Admin → Users
2. Create user: high.privilege@learnwithmahesh.com
3. Set password (skip change requirement for demo)
4. User logs in via incognito → No organization visible initially
5. Propagation delay: 2-7 minutes (or longer for group-level changes)
```

**Why User Sees Organization Node**:
- When organization is created, entire verified domain receives:
  - `roles/billing.accountCreator`
  - `roles/resourcemanager.projectCreator`
- These provide `resourcemanager.organizations.get` permission
- Users can see organization but have no project access until explicitly granted

#### Granting Editor Role at Organization Level

**Grant Process**:
```
IAM → Grant Access at Organization Level
  Principal: high.privilege@learnwithmahesh.com
  Role: Basic → Editor
```

**Verification Methods**:
- **View by Principal**: Shows individual role assignments
- **View by Role**: Groups principals by role (recommended for audits)
  - Owner count should be 1-2
  - Prefer group-based ownership over individual

**Inheritance Effect**:
```diff
! Organization Level: high.privilege = Editor
!     ↓ (inherited to all projects)
! Project Level: high.privilege = Editor (cannot edit/remove)
!     ↓ (inherited to all resources)
! Resource Level: high.privilege = Editor
```

**Key Observation**: Inherited roles show "Roles cannot be edited as it is inherited from another resource."

#### Testing Inherited Access

**Direct Project Access**:
```
1. User has no projects listed initially
2. Use project ID directly: console.cloud.google.com → Enter project ID
3. Access granted via inheritance, not explicit project-level grant
```

**What User Cannot See**:
- IAM page shows only explicitly granted roles at that level
- Inherited roles from organization are invisible to the user
- Service accounts are not visible (requires `resourcemanager.projects.getIamPolicy`)

#### Attempting to Restrict with Viewer Role

**Attempt**:
```
Project Level (website project):
  Grant: high.privilege@learnwithmahesh.com → Viewer
```

**Result Analysis**:
| Role | Permissions | Combined Effect |
|------|-------------|-----------------|
| Editor (org level) | ~8,000 | Union operation |
| Viewer (project level) | ~4,000 | Results in Editor |
| **Total Unique** | **~8,011** | Editor + 11 extra permissions |

**Conclusion**: Union operation means higher privilege always wins. Viewer role at project level has **zero effect** when Editor role exists at organization level.

#### Union Operation Behavior

**Mathematical Representation**:
```
Editor Permissions ∪ Viewer Permissions = Editor Permissions
```

**Why This Matters**:
- Cannot "downgrade" inherited permissions at lower levels
- Must remove the high-privilege role at the source (organization level)
- Or use Deny Policy (covered later in this session)

### Browser Role for Hierarchy Visibility

**Problem**: Editor role does not include permissions to view the resource hierarchy (folders, organization structure).

**Browser Role Permissions**:
- `resourcemanager.projects.list`
- `resourcemanager.folders.get`
- `resourcemanager.folders.list`
- `resourcemanager.projects.getIamPolicy`
- `resourcemanager.organizations.get`

**Grant Process**:
```
Organization Level:
  Grant: high.privilege@learnwithmahesh.com → Browser
```

**Effect**:
- User can now see folder structure
- Projects grouped under their parent folders
- Without Browser: Only flat project list visible

**Recommendation**: Browser role is safe to grant broadly - it provides visibility without modification capabilities.

### Low Privilege at Organization Level (Recommended Approach)

**Principle**: Grant minimal permissions at the organization level, then selectively grant higher privileges at folder or project levels as needed.

#### Granting Browser Role at Organization Level

**Process**:
```
Organization Level:
  Principal: low.privilege@learnwithmahesh.com
  Role: Browser
```

**Result**: User can:
- See organization node
- Browse folder hierarchy
- View all projects
- Read IAM policies on projects
- **Cannot** create, modify, or delete any resources

#### Granting Higher Privileges at Folder/Project Level

**Scenario Setup**:
```
Folder: visualization
  ├── Project A: Viewer role
  └── Project B: Viewer role

Project: website
  └── Storage Admin role (bucket operations only)
```

**Grant Process**:
```bash
# At folder level
gcloud resource-manager folders add-iam-policy-binding FOLDER_ID \
  --member="user:low.privilege@learnwithmahesh.com" \
  --role="roles/viewer"

# At project level
gcloud projects add-iam-policy-binding website-project-id \
  --member="user:low.privilege@learnwithmahesh.com" \
  --role="roles/storage.admin"
```

**Verification**:
```
User can access:
  ✓ visualization folder projects (as Viewer)
  ✓ website project buckets (as Storage Admin)

User cannot access:
  ✗ Highly sensitive project (no role granted)
  ✗ Other projects outside granted scope
```

**Key Advantage**: Granular control without the union operation problem. Permissions can be adjusted at any level without affecting others.

---

## IAM Propagation Delays

**Official Documentation**:
> IAM access changes such as granting roles or denying permissions are eventually consistent. It takes time for access changes to propagate through the system.

**Timeline Expectations**:
| Change Type | Propagation Time |
|-------------|------------------|
| Individual role grants | 2-7 minutes |
| Group-level changes | Up to hours |
| Cross-organization | Up to 24 hours |

**Workarounds for Delays**:
1. **Wait**: Minimum 7 minutes, potentially longer
2. **Log off/Log in**: Forces credential refresh
3. **Direct project ID access**: Bypass project listing delays
4. **CLI verification**: `gcloud projects list` to check propagation

**Important**: Always inform users that access grants are not instantaneous.

---

## Deny Policy - Override Mechanism

### Use Case: Blocking Role Creation

**Scenario**: User granted Owner role at organization level (like a CTO). Need to prevent role creation in specific sensitive project (website) while maintaining Owner privileges elsewhere.

**Challenge**: Cannot remove Owner role, but need to block specific permission.

### Creating Deny Policy via gcloud

**Prerequisite**: User must have `roles/iam.denyAdmin` role.

**Policy JSON Structure** (deny.json):
```json
{
  "name": "projects/PROJECT_ID/denyPolicies/my-deny-policy",
  "displayName": "Block Role Creation in Website Project",
  "rules": [
    {
      "denyRule": {
        "deniedPrincipals": [
          "principal://iam.googleapis.com/projects/PROJECT_NUMBER/serviceAccounts/SERVICE_ACCOUNT_ID"
        ],
        "denialCondition": {
          "title": "Block iam.roles.create",
          "expression": "true"
        },
        "deniedPermissions": [
          "iam.roles.create"
        ]
      }
    }
  ]
}
```

**Apply Command**:
```bash
gcloud iam policies create my-deny-policy \
  --attachment-point=cloudresourcemanager.googleapis.com/projects/PROJECT_ID \
  --kind=denypolicy \
  --policy-file=deny.json
```

**List Policies**:
```bash
gcloud iam policies list \
  --attachment-point=cloudresourcemanager.googleapis.com/projects/PROJECT_ID \
  --kind=denypolicy
```

### Testing Deny Policy Effectiveness

**Before Deny Policy**:
```bash
# User can create roles in any project
Roles → Create Role → Success (all projects)
```

**After Deny Policy**:
```bash
# Website project: Create button grayed out
Roles → Create Role → Blocked

# Other projects: Create works normally
Roles → Create Role → Success (highly sensitive project)
```

### Limitations and Scope

**Where Deny Policies Can Be Attached**:
- ✅ Organization level
- ✅ Folder level
- ✅ Project level
- ❌ Individual resources (VMs, buckets)

**Important Notes**:
- Not available in Console UI (gcloud/Terraform only)
- Takes time to propagate
- Use as last resort when high-privilege roles cannot be removed
- Prefer proper role design over deny policies

---

## Service Account Fundamentals

### Identity Concept

**Core Principle**: Service accounts are **identities** for services/APIs, just as user accounts are identities for humans.

**Communication Flow**:
```
VM (compute.googleapis.com)
    ↓ "Who are you?"
    → "I'm a VM with identity: SERVICE_ACCOUNT@PROJECT.iam.gserviceaccount.com"
    ↓ "Do you have permission?"
    → Check IAM role on target resource (bucket)
    → Allow/Deny based on role permissions
```

### Key Characteristics

#### Multiple VMs, Single Service Account

**Use Case**: Autoscaling environments where identical VMs need identical permissions.

```
VM-1 ─┐
VM-2 ─┼──→ Same Service Account → Same Permissions
VM-3 ─┤
VM-N ─┘
```

**Analogy**: One person (service account) can own multiple houses (VMs), but each house has only one owner at any given time.

**Limitation**: Each VM can have only **one** service account attached at any time.

#### Authentication via Keys

**User Authentication**: Username + Password

**Service Account Authentication**: Service Account Key (JSON)

**Key Limits**:
- Maximum 10 keys per service account
- Keys do not expire automatically
- **Security Risk**: Compromised keys provide permanent access
- **Best Practice**: Rotate keys regularly (create new, delete old)

#### Service Account Types

| Type | Description | Recommendation |
|------|-------------|----------------|
| **Google-managed** | Created by Google for internal processes | ⚠️ Never modify or delete |
| **Built-in** | Compute Engine Default, App Engine Default | Can remove roles, but don't delete SA |
| **User-created (Custom)** | Created by users for specific purposes | ✅ Recommended approach |

**Google-Managed Service Accounts**:
- Hidden by default in Console (enable checkbox to view)
- Run critical Google processes
- May have Editor/Owner roles - **do not change**
- Visible via CLI even when hidden in Console

**Built-in Service Accounts**:
- Created automatically when enabling APIs
- Compute Engine Default: `PROJECT_NUMBER-compute@developer.gserviceaccount.com`
- App Engine Default: `PROJECT_ID@appspot.gserviceaccount.com`
- Typically have Editor role (can be removed)

**User-Created Service Accounts**:
- Maximum 100 per project (soft limit, can be increased)
- Recommended for all production workloads
- Full control over roles and permissions

---

## Service Account Demo: VM to GCS Data Transfer

### Architecture Requirements

**Business Requirement**:
- VM generates/processes data
- Data must be stored in Cloud Storage bucket
- Production VM - cannot restart frequently
- Future requirements may change

**Technical Architecture**:
```
VM (Data Generator)
    ↓ Process data
    ↓ Copy to bucket
GCS Bucket (Long-term storage)
```

**Initial Constraints**:
- VM and bucket in same project
- No VM restarts allowed after deployment

### Three Implementation Approaches

#### Approach 1: Compute Engine Default Service Account (Problematic)

**Configuration**:
```
VM Identity: Compute Engine Default Service Account
  Role: Editor (built-in)
Access Scope: Default (allow default access)
```

##### Access Scopes Concept

**Definition**: Legacy method of specifying authorization, applied as a secondary gate after IAM roles.

**Default Access Scope Permissions**:
- ✅ Storage: Read-only
- ✅ Monitoring: Write access
- ❌ Compute Engine: Disabled
- ❌ Most other APIs: Disabled

**Problem**: Even with Editor role on service account, access scopes can block operations.

```
Editor Role (can do anything)
    ↓ Passes through Access Scope gate
    ↓ Default scope restricts to read-only on storage
Result: Cannot write to bucket despite Editor role
```

##### Problems Encountered

1. **Initial Failure**: Cannot copy to bucket (read-only scope)
2. **VM Restart Required**: Must stop VM to change service account or access scope
3. **UI Bug**: Stop status sometimes shows incorrectly (running vs stopped)
4. **Credential Cache**: Must clear `~/.gsutil` and `~/.config/gcloud` after scope change
5. **Propagation Delays**: 2-7 minutes after role grants

**Cleanup Commands**:
```bash
rm -rf ~/.gsutil ~/.config/gcloud
gcloud auth list  # Verify new credentials loaded
```

**Conclusion**: Using Compute Engine Default Service Account creates cascading problems. Avoid for production workloads.

#### Approach 2: User-Created Service Account (Recommended)

**Configuration**:
```
VM Identity: Custom Service Account (vm2gcs-data-generator)
  Role: Storage Admin (granted after creation)
Access Scope: Full access (IAM controls permissions)
```

##### Creating Custom Service Account

```bash
# Via Console
IAM & Admin → Service Accounts → Create Service Account
  Name: vm2gcs-data-generator
  Description: Writes data from VM to GCS
  Create (no initial role)

# Via gcloud
gcloud iam service-accounts create vm2gcs-data-generator \
  --description="Writes data from VM to GCS" \
  --display-name="VM to GCS Data Generator"
```

**Key Point**: Create VM with service account even before granting roles. Roles can be added later without VM restart.

##### Granting Storage Admin Role

```bash
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="serviceAccount:vm2gcs-data-generator@PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/storage.admin"
```

**Verification**:
```bash
# On VM
gcloud auth list
# Shows: vm2gcs-data-generator@PROJECT_ID.iam.gserviceaccount.com

gsutil ls gs://bucket-name
# Success (can list buckets)

echo "test data" > data.txt
gsutil cp data.txt gs://bucket-name/
# Success (can create objects)
```

##### Handling Requirement Changes

**New Requirement**: VM must also list other VMs in project.

**Solution** (no restart needed):
```bash
# Identify minimal role
gcloud iam roles list --project=PROJECT_ID | grep compute

# Select: roles/compute.osLogin (19 permissions - minimal)
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="serviceAccount:vm2gcs-data-generator@PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/compute.osLogin"

# Verify immediately
gcloud compute instances list
# Success - lists all VMs
```

**Advantage**: User-created service accounts allow role modifications without VM restarts, enabling future requirement changes.

#### Approach 3: Dangerous Configuration

**Configuration**:
```
VM Identity: Compute Engine Default Service Account
  Role: Editor (built-in)
Access Scope: Full access (allow full access)
```

##### Editor Role + Full Access Scope

**Risk Assessment**:
| Capability | Access |
|------------|--------|
| Create/Delete VMs | ✅ Full |
| Create/Delete Buckets | ✅ Full |
| Create/Delete Service Accounts | ✅ Full |
| Modify IAM Policies | ✅ Full |
| Self-Destruction | ✅ Can delete itself |

##### Demonstration of Risks

```bash
# List all VMs
gcloud compute instances list

# Delete any VM (including production systems)
gcloud compute instances delete PRODUCTION-VM --zone=us-central1-a --quiet

# List and delete buckets
gsutil ls
gsutil rm -r gs://production-bucket

# Create malicious service accounts
gcloud iam service-accounts create backdoor-account

# Self-destruct
gcloud compute instances delete $(hostname) --zone=$(gcloud config get-value compute/zone) --quiet
# Connection terminated - VM deleted itself
```

**Key Takeaway**: This combination (Compute Engine Default SA + Editor + Full Access Scope) is **extremely dangerous** and should never be used in any environment.

---

## Cross-Project Service Account Access

### UI Demonstration

**Scenario**: VM in Project A needs to write to bucket in Project B.

**Steps**:

1. **Create VM in Project A**:
   ```
   Project: cloud-architect-pca
   VM: cross-project
   Service Account: vm2gcs-data-generator (no roles yet)
   Access Scope: Full access
   ```

2. **Create Bucket in Project B**:
   ```
   Project: ml-engineering
   Bucket: cloud-architect-cross-project
   ```

3. **Grant Service Account Access to Bucket**:
   ```
   Bucket Permissions → Grant Access
     Principal: vm2gcs-data-generator@cloud-architect-pca.iam.gserviceaccount.com
     Role: Storage Admin
   ```

4. **Test from VM**:
   ```bash
   gsutil ls gs://cloud-architect-cross-project
   # Success (zero objects)

   echo "cross-project-data" > cross.txt
   gsutil cp cross.txt gs://cloud-architect-cross-project/
   # Success

   gsutil ls gs://other-bucket-in-project-b
   # Permission denied (only granted for specific bucket)
   ```

### Best Practices for Cross-Project Access

1. **Create VM in "home" project**: The project where the service account lives
2. **Share service account email**: Provide to teams managing target resources
3. **Grant minimal roles on target resources**: Bucket-level, not project-level when possible
4. **Document service account purpose**: Clear naming and descriptions
5. **Avoid creating service accounts in target project**: VM must be created where service account exists

---

## Summary

### Key Takeaways

```diff
+ Grant minimal privileges at organization level (Browser recommended)
+ Higher privileges should be granted at folder/project level as needed
+ Union operation: Higher privilege roles always override lower ones
+ Inherited roles cannot be removed or downgraded at lower levels
+ Deny policies provide override mechanism when high-privilege roles cannot be removed
+ Service accounts are identities for APIs/services
+ User-created service accounts enable flexibility without VM restarts
+ Compute Engine Default Service Account + Editor + Full Access Scope = Dangerous
+ Access scopes are legacy and should be avoided (use IAM roles instead)
+ Service accounts can access resources across projects (Google identity)
+ Maximum 100 service accounts per project (soft limit)
+ Keys never expire - rotate regularly or avoid creating keys
- Never modify Google-managed service accounts
- Never use Compute Engine Default SA for production workloads
```

### Quick Reference

| Task | Console | gcloud Command |
|------|---------|----------------|
| Grant org-level role | IAM → Organization → Grant | `gcloud organizations add-iam-policy-binding` |
| Grant folder-level role | Resource Manager → Folder → IAM | `gcloud resource-manager folders add-iam-policy-binding` |
| Create service account | IAM → Service Accounts → Create | `gcloud iam service-accounts create` |
| Grant SA role on bucket | Bucket → Permissions → Grant | `gsutil iam ch` |
| Create deny policy | Not available in UI | `gcloud iam policies create` |
| Activate SA with key | Not applicable | `gcloud auth activate-service-account` |

### Expert Insight

**Real-world Application**:
In enterprise environments, establish a clear hierarchy: Browser at organization level for all employees, then specific roles at folder level for teams, and project-level roles for individual workloads. Use user-created service accounts for all automated workloads. Document service account purpose and ownership. Implement regular access reviews using "View by Role" to identify excessive permissions.

**Expert Path**:
1. Design organization/folder structure before creating projects
2. Create service account naming conventions (e.g., `{app}-{env}-{purpose}`)
3. Implement keyless authentication using Workload Identity Federation
4. Set up automated service account audits using Cloud Asset Inventory
5. Create reusable Terraform modules for common service account patterns

**Common Pitfalls**:
- Granting Editor at organization level "for convenience" - creates unmanageable access
- Using Compute Engine Default Service Account because "it's already there"
- Creating service accounts in every project instead of reusing across projects
- Not understanding that access scopes override IAM roles (legacy confusion)
- Forgetting that service account keys never expire
- Granting roles at project level when bucket/object-level would suffice

**Lesser-Known Facts**:
- Organization-level Editor role affects future projects created years later
- Deny policies were introduced ~1.5 years ago and still lack Console UI support
- Google-managed service accounts are visible via CLI even when hidden in Console
- A VM can authenticate as itself (service account) or as a human (gcloud auth login)
- Service account can be granted access to resources before the VM is created
- Access scope changes require VM stop/start, but IAM role changes do not
- The "dangerous VM" configuration can delete production resources across the entire project

---

*Session Duration: ~90 minutes | Focus: Policy inheritance behavior, deny policies, service account implementation patterns*