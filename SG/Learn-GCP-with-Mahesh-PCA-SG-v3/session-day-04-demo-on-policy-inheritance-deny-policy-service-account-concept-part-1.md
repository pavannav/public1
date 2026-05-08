# Session 4: Demo on Policy Inheritance, Deny Policy, Service Account Concept - Part 1

**TOC**
- [Demo on Policy Inheritance, Deny Policy, Service Account Concept](#demo-on-policy-inheritance-deny-policy-service-account-concept)
  - [Overview](#overview)
  - [Key Concepts](#key-concepts)
    - [Policy Inheritance](#policy-inheritance)
    - [Creating Users and Assigning Roles](#creating-users-and-assigning-roles)
    - [Deny Policy Introduction](#deny-policy-introduction)
    - [Service Account Concepts](#service-account-concepts)
    - [Service Account Types and Best Practices](#service-account-types-and-best-practices)
  - [Lab Demos](#lab-demos)
    - [Scenario 1: High Privilege at Org Level](#scenario-1-high-privilege-at-org-level)
    - [Scenario 2: Low Privilege at Org Level with Higher at Folder/Project](#scenario-2-low-privilege-at-org-level-with-higher-at-folderproject)
    - [Deny Policy Demo](#deny-policy-demo)
    - [Service Account Demo: VM and Storage Interaction](#service-account-demo-vm-and-storage-interaction)

## Demo on Policy Inheritance, Deny Policy, Service Account Concept

### Overview

This session demonstrates IAM policy inheritance, deny policies, and service account concepts in Google Cloud. We'll explore how permissions flow from org to folder to project, the impact of role assignments at different levels, and how deny policies can override even high-level privileges. Service accounts are covered with practical examples showing authentication, authorization, and best practices for virtual machines interacting with Google Cloud resources.

### Key Concepts

#### Policy Inheritance

Policy inheritance in Google Cloud IAM means permissions granted at higher levels (org > folder > project) flow down to child resources. This is an OR (union) operation - roles at multiple levels combine. Higher-level roles can be overridden by explicit deny policies or lower-level restrictions, but not easily for restrictive purposes.

- **Inheritance Flow**: Org node → Folders → Projects → Resources
- **Inheritance Propagation**: Changes can take 2-24 minutes, especially for new users or cross-resource grants.
- **Union Operation**: Roles from multiple levels combine; granting "viewer" at project level doesn't restrict an org-level "editor" role.

```diff
! Org Level (Editor) → Folder Level → Project Level (Viewer)
- Effective Role: Editor (Union, not intersection)
```

> [!NOTE]
> Users cannot see roles granted at other levels unless they have appropriate permissions to view IAM policies.

#### Creating Users and Assigning Roles

Users are created in Cloud Identity (or Google Workspace). Domain-verified orgs grant automatic roles to all users. Key steps:

1. Create user in Cloud Identity.
2. Verify email if needed.
3. Grant roles at org, folder, or project level.
4. Monitor inheritance via "View by role" or "View by principal".

- **Domain-Wide Roles**: Project Creator and Billing Account Creator are auto-granted at org level.
- **Recommended Actions**: Remove default domain roles for security.
- **Propagation**: Use project IDs manually if org association delays.

```bash
# Check project list (post-grant)
gcloud projects list
```

#### Deny Policy Introduction

Deny policies override IAM allow policies, preventing actions even with granted roles. Introduced ~1-2 years ago, they're applied at org, folder, or project levels (not resources).

- **Scope**: Applicable to org/folder/project only.
- **Permissions Covered**: Specific denied permissions negate grantings.
- **Limitations**: Not usable via UI; requires CLI/gcloud commands, Terraform, or REST API.
- **Use Cases**: Block high-privilege users from sensitive operations (e.g., role creation).

> [!WARNING]
> Deny policies apply even across inheritance - a project-level deny overrides org-level editor.

Format using v2 principals for federation support:

```json
{
  "name": "deny-policy-name",
  "rules": [
    {
      "deniedPrincipals": [
        "principalSet://goog/public:all"
      ],
      "deniedPermissions": [
        "iam.googleapis.com/roles.create"
      ]
    }
  ]
}
```

Apply via:

```bash
gcloud iam policies create deny-policy-name --attachment-point projects/project-id --kind denyPoliciesV3 --policy-file deny-policy.json
```

#### Service Account Concepts

Service accounts are Google-managed identities for non-human entities (VMs, apps). They use email addresses for authentication, unlike user logins.

- **Authentication**: Via keys (not recommended) or metadata server (best practice).
- **Authorization**: Controlled by IAM roles on resources.
- **Multiple VMs**: One service account can be used by multiple VMs (e.g., autoscaling groups).
- **Keys**: JSON keys (avoid creation; use Workload Identity Federation for external auth).

```bash
# Check active service account on VM
gcloud auth list
```

#### Service Account Types and Best Practices

1. **Google-Managed Service Accounts**:
   - Built-in (e.g., Compute Engine default: editor role).
   - Touch-me-not; remove roles if needed, but don't modify.

2. **User-Created Service Accounts**:
   - Custom accounts for apps/VMs.
   - Max 100 per project (soft limit increasable).
   - Follow least privilege; grant minimal roles.

```diff
+ Best Practice: Create custom service accounts
- Avoid: Using default service accounts with editor role
! Never: Create keys unnecessarily
```

- **Access Scopes** (Legacy): Limit API access on VMs. Use "Allow full access" and control via IAM for simplicity.
- **VM Assignment**: VMs can have only one service account; changeable only on stop/edit.

### Lab Demos

#### Scenario 1: High Privilege at Org Level

**Objective**: Grant editor at org level; observe inheritance and restrictions.

**Steps**:
1. Create user in Cloud Identity: highprivilegeuser.com.
2. Grant "Editor" role at org level.
3. Log in as user; note access to all projects.
4. Attempt to restrict via project-level "Viewer" role - fails due to union.
5. Grant browser role for hierarchy visibility; note roles shown only at project level.
6. Verify VM creation across projects succeeds.

**Key Observations**:
- Inheritance grants org-level access to all resources.
- Union prevents restrictions at lower levels.
- Propagation delays (use manual project ID access for immediate use).

> [!WARNING]
> High-level editor roles enable creation/deletion across entire org - risky.

#### Scenario 2: Low Privilege at Org Level with Higher at Folder/Project

**Objective**: Low privilege (browser) at org; targeted access via folder/project IAM.

**Steps**:
1. Create "lowprivilegeuser.com".
2. Grant "Browser" at org level.
3. Grant "Viewer" at visualization folder level.
4. Grant "Storage Admin" at "website" project.
5. Switch and verify access: only assigned projects/folders visible.
6. Create VM in "website" project - succeeds.
7. Attempt access to other projects - fails.

**Key Observations**:
- Scalable secure access.
- No inheritance union issues for low-to-high privilege flow.
- Easy to audit/manage via targeted grants.

#### Deny Policy Demo

**Objective**: Override org-level editor using deny policy to prevent role creation.

**Steps**:
1. Use highprivilegeuser (org editor).
2. Create deny policy JSON:

```json
{
  "name": "deny-role-creation",
  "rules": [
    {
      "deniedPrincipals": [
        "principal://iam.googleapis.com/projects/-/serviceAccounts/highprivilegeuser.com"
      ],
      "deniedPermissions": [
        "iam.googleapis.com/roles.create"
      ]
    }
  ]
}
```

3. Apply policy: `gcloud iam policies create deny-role-creation --attachment-point projects/website --policy-file deny.json --kind denyPoliciesV3`.
4. After propagation, role creation fails at "website" project.
5. Remove policy; regain access.

**Key Observations**:
- Overrides inheritance.
- Not UI-available; use CLI.
- Propagation similar to IAM (immediate effect post-command).

#### Service Account Demo: VM and Storage Interaction

**Objective**: Demonstrate service account in VM-bucket interaction; compare default vs. custom SA with scopes.

**VM Creation Options**:
- **Default SA + Default Scopes**: Compute default SA (editor) + read-only scopes.
  - Restricted access despite editor role.
- **Custom SA + Full Scopes**: User-created SA + full API access.
  - Controlled by IAM/SDK metadata.

**Steps**:
1. Create VMs:
   - VM1: Compute default SA, default scopes.
   - VM2: Custom SA (no role), full scopes.
   - VM3: Compute default SA, full scopes (dangerous).
2. Assign roles:
   - Storage admin to VM2 SA at project level.
3. On VMs, test:
   - `gcloud auth list`: Check active SA.
   - `gsutil ls gs://bucket`: Upload/copy data.
   - Access scopes via metadata/UI.
4. Mitigate issues:
   - Remove cached creds: `rm -rf ~/.gsutil ~/.config/gcloud`.
   - Use `gcloud auth login` (temporary user auth - not recommended).
   - Upload SA key (worst-case; avoid).
5. Cross-Project: SA grants at bucket level.
   - VM in Project A, bucket in Project B.
   - Grant SA storage admin on specific bucket.

**Key Commands**:
- SSH VM: `gcloud compute ssh vm-name`.
- Generate data: `echo "data" > file.txt`.
- Upload: `gsutil cp file.txt gs://bucket/folder/`.
- List buckets: `gsutil ls`.
- List VMs: `gcloud compute instances list` (requires appropriate IAM).
- Cache removal forcing re-auth: `rm -rf ~/.gsutil ~/.config/gcloud`.

**Annotations**:
- **Dangerous Config**: Default SA + Full Scopes = Full GC access - self-destruct possible.
- **Best Config**: Custom SA + IAM/control via roles.
- **Scopes vs. IAM**: Scopes are VM-configured metadata restrictions; IAM is resource-level grants.

```diff
+ Recommended: Custom SA + IAM roles
- Problematic: Default SA + editor role + full scopes
! Avoid: Downloading SA keys
```

> [!IMPORTANT]
> VMs can have only one SA; scopes limit but are legacy - prefer IAM for modern setups.

### Summary

#### Key Takeaways
```diff
+ Policy inheritance uses union - combine privileges
- Deny policies override inheritance with no restrictions
! Service accounts authenticate apps/VMs, authorization via IAM
- High org-level roles risk entire org access
+ Use custom SAs for precise, auditable access
- Avoid default SAs with broad scopes
+ Less privilege at higher levels, targeted at lower
```

#### Quick Reference
- **Grant Role**: Org/folder/project IAM > Permissions > Grant Access.
- **Deny Policy**: CLI-only; JSON format with denied permissions/principals.
- **VM SA Setup**: Stop VM > Edit > Service Account/Deny Edit > Start.
- **Check SA**: `gcloud auth list`
- **Force Reauth**: `rm -rf ~/.gsutil ~/.config/gcloud`
- **Propagation Hack**: Manual project ID access or temporary user login.

#### Expert Insight

**Real-world Application**:  
In enterprise orgs, use deny policies for compliance (e.g., block role changes by CTO on prod projects). Service accounts enable secure VM-to-service workflows (e.g., data pipelines across projects without user creds).

**Expert Path**:  
Master IAM design: Map roles to personas, automate via Terraform (e.g., `google_iam_policy`), monitor with Cloud Audit Logs. For advanced scenarios, integrate SA with Workload Identity for external Kubernetes.

**Common Pitfalls**:  
- Ignoring propagation delays (solution: test with project IDs).  
- Over-relying on scopes instead of IAM (scopes are deprecated for new setups).  
- Creating SA keys for "ease" (increases security risk; use metadata auth).  
- Granting high privileges pre-deny policy for overrides.

**Lesser-Known Facts**:  
- Domains get auto-roles upon verification; removal is a security hardening step.  
- SA keys never expire; rotation is manual or scripted.  
- Editor role implies 7,000+ permissions; always break into specifics.  
- Deny policies support principal sets for group denies.

**Advantages and Disadvantages**:  
**Policy Inheritance**: + Scalable org-wide access; - Hard to restrict (deny policies needed).  
**Deny Policies**: + Override-based security; - No UI, CLI-only, propagation delays.  
**Service Accounts**: + No password fatigue, fine-grained; - Key management risk, single SA per VM.  
**Access Scopes**: + VM-level restrictions; - Legacy, less flexible than IAM.
