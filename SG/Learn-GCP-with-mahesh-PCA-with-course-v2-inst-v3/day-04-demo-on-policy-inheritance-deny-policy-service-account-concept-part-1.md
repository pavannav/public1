<details open>
<summary><b>Day 04 - Demo on Policy Inheritance, Deny Policy, Service Account Concept - Part 1 (KK-CS45-script-v2-Inst-v3)</b></summary>

# Day 04: Demo on Policy Inheritance, Deny Policy, Service Account Concept - Part 1

## Overview

This session covers critical aspects of Google Cloud Identity and Access Management (IAM) including policy inheritance, the new deny policies feature, and service account fundamentals. You'll learn through practical demonstrations showing the impact of different access patterns on resource management and security.

### Key Concepts Covered:
- **Policy Inheritance**: How IAM policies flow from organization to folder to project level
- **Deny Policies**: Google's new feature to explicitly deny permissions regardless of granted access
- **Service Accounts**: Creating, managing, and securing service accounts for applications and VMs

> [!IMPORTANT]
> IAM is the foundation of GCP security. Understanding policy inheritance prevents common misconfigurations that can lead to security breaches or operational issues.

---

## Table of Contents
1. [Policy Inheritance Fundamentals](#policy-inheritance-fundamentals)
2. [Practical Scenarios: High vs Low Privilege Patterns](#practical-scenarios-high-vs-low-privilege-patterns)
3. [Browser Role and Hierarchy Visibility](#browser-role-and-hierarchy-visibility)
4. [Deny Policies: The Override Mechanism](#deny-policies-the-override-mechanism)
5. [Service Account Deep Dive](#service-account-deep-dive)
6. [VM Integration with Service Accounts](#vm-integration-with-service-accounts)

---

## Policy Inheritance Fundamentals

IAM policies are not just applied at individual resource levels - they **inherit** from higher levels in the organization hierarchy.

### Resource Hierarchy Order:
```
Organization (Root)
  └── Folder
      └── Project
          └── Resources (VMs, Buckets, etc.)
```

### Key Characteristics:

✅ **Inheritance Flows Downward**: Permissions granted at organization level apply to all projects and resources below
✅ **Union Operation**: Multiple roles on same principal combine permissions (not replace)
✅ **Cannot Override Higher-Level Grants**: You cannot restrict privileges granted at higher levels
✅ **Role Evaluation**: Most specific role applicable to the resource is used

> [!NOTE]
> Policy inheritance follows the principle: "You can give more access, but you cannot take away access granted at higher levels."

### IAM Policy Structure:
```yaml
bindings:
- role: "roles/editor"
  members:
  - "user:user@example.com"
```

Permissions are evaluated based on the **effective policy** which includes all inherited bindings.

---

## Practical Scenarios: High vs Low Privilege Patterns

The session demonstrates two contrasting access patterns with real-world implications.

### ❌ Scenario 1: High Privilege at Organization Level (NOT RECOMMENDED)

**Setup:**
- Grant Editor role at Organization level
- Attempt to restrict at Project/Folder level

**What Happens:**
- User can create resources in ANY project within organization
- Viewer role at project level → Union operation → Still Editor privileges
- Cannot effectively restrict access granted at higher level

**Risks:**
- Accidental resource creation across all projects
- Difficult to audit and control
- Security violations if user leaves organization

### ✅ Scenario 2: Low Privilege at Organization Level (RECOMMENDED)

**Setup:**
- Grant Browser role at Organization level (read-only access)
- Grant specific roles (Storage Admin, Compute Viewer) at Project/Folder level

**Benefits:**
- Clear separation of duties
- Minimal blast radius if compromised
- Easy to audit and manage

**Demonstration Results:**
```
High Privilege User (Editor @ Org):
├── Can create resources in ALL projects ✓
├── Cannot restrict at lower levels ✓
└── Inherits everywhere ✓

Low Privilege User (Browser @ Org + Storage Admin @ Project):
├── Can ONLY access specified resources ✓
├── Clear audit trail ✓
└── Controlled blast radius ✓
```

### Best Practice Rule:

> [!WARNING]
> **NEVER** grant high-privilege roles (Editor, Owner) at Organization level unless absolutely necessary and you have compensating controls.

### Policy Propagation Considerations:

- **Consistent Operations**: IAM changes are eventually consistent
- **Propagation Time**: Can take 2-7 minutes (or longer for group changes)
- **Testing Required**: Always verify policy changes have taken effect before proceeding

---

## Browser Role and Hierarchy Visibility

The Browser role provides read-only access to the resource hierarchy.

### Browser Role Permissions:
```bash
resourcemanager.organizations.get
resourcemanager.folders.get
resourcemanager.folders.list
resourcemanager.projects.get
resourcemanager.projects.list
resourcemanager.projects.getIamPolicy
resourcemanager.organizations.getIamPolicy
```

### Inheritance Column Visibility:
- **Requires Higher Privileges**: To see the "Inherited From" column in IAM pages
- **Organization Administrator/Policies Administrator/Owner**: Can view inheritance details
- **Browser Role**: Can see hierarchy but not inheritance sources

### Implementation Steps:
```bash
# Grant Browser role at organization level
gcloud organizations add-iam-policy-binding [ORG_ID] \
  --member="user:user@example.com" \
  --role="roles/browser"

# Verify hierarchy access
gcloud resource-manager folders list --organization=[ORG_ID]
gcloud projects list
```

---

## Deny Policies: The Override Mechanism

Deny policies are Google's recent addition (~1.5 years ago) that provide explicit permission denial regardless of granted access.

### Key Characteristics:

🔒 **Override Allow Policies**: Denies permissions even if explicitly granted
⏰ **Recently Introduced**: Not available in all interfaces yet
🛠️ **CLI/API Only**: Requires `gcloud` commands (not yet in Cloud Console)
📍 **Attachment Points**: Organization, Folder, Project (not individual resources)

### Deny Policy Structure:
```json
{
  "name": "deny-custom-role-creation",
  "rules": [
    {
      "denyRule": {
        "deniedPrincipals": [
          "user:high-privilege-user@example.com"
        ],
        "deniedPermissions": [
          "iam.googleapis.com/roles.create"
        ]
      }
    }
  ]
}
```

### Why Deny Policies Matter:

> [!IMPORTANT]
> Deny policies solve the problem: "How do you restrict access that was granted too broadly at a higher level?"

### Usage Scenarios:
- CTO has Editor role everywhere but should not create custom roles
- Service accounts have broad access but need specific restrictions
- Emergency lockdown during security incidents

### Implementation Commands:
```bash
# Create deny policy
gcloud iam policies create deny-role-creation \
  --attachment-point=projects/[PROJECT_ID] \
  --kind=deny \
  --policy-file=deny-policy.json

# List deny policies
gcloud iam policies list \
  --attachment-point=projects/[PROJECT_ID]

# Delete deny policy
gcloud iam policies delete deny-role-creation \
  --attachment-point=projects/[PROJECT_ID]
```

### Limitations:
- Cannot apply to individual resources (VMs, buckets)
- UI support not yet available
- Requires understanding of permission names

---

## Service Account Deep Dive

Service accounts are Google Cloud's solution for authenticating machine-to-machine communications.

### Identity Types Comparison:

| Aspect | User Account | Service Account |
|--------|-------------|----------------|
| Authentication | Username/Password | Keys or Metadata |
| Use Case | Interactive Users | Applications/VMs |
| Lifecycle | Manual Management | Programmatic Creation |
| Key Management | N/A | Up to 10 keys per account |

### Service Account Types:

#### 🛡️ Google-Managed Service Accounts
- Created automatically by GCP services
- **DO NOT TOUCH**: Never modify roles or delete
- Example: `service-[PROJECT_NUMBER]@compute-system.iam.gserviceaccount.com`

#### 🔧 Built-in Service Accounts
- Pre-created for convenience
- Compute Engine Default: `PROJECT_NUMBER-compute@developer.gserviceaccount.com`
- App Engine Default: Available when App Engine is enabled
- **Careful Usage**: Often too permissive (Editor role by default)

#### 🏗️ User-Created Service Accounts
- Custom accounts you create
- Recommended approach for production
- Limit: 100 per project (soft limit, can be increased)

### Service Account Creation:
```bash
# Create service account
gcloud iam service-accounts create [SA_NAME] \
  --description="Service account for data processing" \
  --display-name="Data Processing SA"

# Grant role to service account
gcloud projects add-iam-policy-binding [PROJECT_ID] \
  --member="serviceAccount:[SA_NAME]@[PROJECT_ID].iam.gserviceaccount.com" \
  --role="roles/storage.admin"

# Create service account key (NOT RECOMMENDED)
gcloud iam service-accounts keys create key.json \
  --iam-account="[SA_NAME]@[PROJECT_ID].iam.gserviceaccount.com"
```

### Authentication Methods:

#### ✅ Preferred: Service Account Impersonation
```python
from google.auth import impersonated_credentials
from google.cloud import storage

# Impersonate service account
credentials = impersonated_credentials.Credentials(
    source_credentials=your_credentials,
    target_principal='sa-name@project.iam.gserviceaccount.com'
)

# Use with client
storage_client = storage.Client(credentials=credentials)
```

#### ❌ Avoid: Service Account Keys
- Must be downloaded and stored securely
- No automatic rotation
- Security risk if compromised
- **Best Practice**: Use keys only when absolutely necessary and rotate regularly

### Service Account Permissions:
- Identified by email: `sa-name@project.iam.gserviceaccount.com`
- Can be granted IAM roles like any other principal
- Can impersonate other service accounts (with proper permissions)

---

## VM Integration with Service Accounts

Virtual machines authenticate to GCP services using their assigned service account.

### VM Service Account Assignment:

1. **Default Behavior**: If not specified, uses Compute Engine default service account
2. **Custom Assignment**: Specify service account during VM creation
3. **One Per VM**: Each VM can have only one service account (at creation time)

### Creating VM with Specific Service Account:
```bash
gcloud compute instances create my-vm \
  --service-account=my-sa@my-project.iam.gserviceaccount.com \
  --scopes=cloud-platform
```

### Access Scopes (Legacy - AVOID):

> [!WARNING]
> Access scopes are legacy and should not be used in new deployments. Use IAM roles on service accounts instead.

**Access Scope Issue**: Even with Editor role, default scope restricts to read-only storage access.

```bash
# Check VM's service account
gcloud auth list

# Check access token scopes (inside VM)
curl -s "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/scopes" \
  -H "Metadata-Flavor: Google"
```

### Demonstration Scenarios:

#### Scenario 1: Default Scope + Editor Role
```
VM Service Account: Editor role @ project
Access Scope: Default (read-only)
Result: Can list buckets but cannot create/upload objects
```

#### Scenario 2: Full Scope + Custom Service Account
```
VM Service Account: Storage Admin role @ project  
Access Scope: Full (legacy)
Result: Full storage access despite access scope
```

#### Scenario 3: No Scope + Specific Role
```
VM Service Account: Custom role with storage.object.create
Access Scope: None
Result: Can create objects, cannot access other services
```

### Key Takeaway:
Service accounts provide the identity, IAM roles provide the permissions. Access scopes are legacy restrictions that should be avoided.

---

## Summary

### Key Takeaways

```diff
+ Policy inheritance enables centralized access control but requires careful planning
+ Deny policies provide emergency override capabilities for security-critical restrictions
+ Service accounts are essential for secure machine-to-machine authentication
+ Always use custom service accounts instead of built-in defaults for production workloads
- Avoid granting high privileges at organization level without strong justification
- Never create service account keys unless absolutely necessary
- Avoid access scope configurations in favor of pure IAM roles
```

### Quick Reference

#### Common IAM Commands:
```bash
# List organization roles
gcloud organizations get-iam-policy [ORG_ID] --format=json

# Grant role at project level
gcloud projects add-iam-policy-binding [PROJECT_ID] \
  --member="user:user@example.com" \
  --role="roles/browser"

# Create service account
gcloud iam service-accounts create [SA_NAME]

# Check VM service account
gcloud auth list
```

#### Permission Hierarchy:
```
Organization Level (Broadest)
├── Browser: Read-only access to hierarchy
├── Viewer: Read-only access to resources
└── Editor: Full control within scope

Project Level (Most Common)
├── roles/storage.admin: Cloud Storage management
├── roles/compute.admin: Compute Engine management
└── roles/logging.viewer: Logging access

Resource Level (Most Specific)
└── Custom roles for fine-grained control
```

### Expert Insight

#### Real-world Application
Policy inheritance is crucial in enterprise environments where you need to grant baseline access to entire teams while maintaining project-level segregation. Start with minimal Organization-level roles (Browser) and grant specific elevations at Project/Folder level.

#### Expert Path
Master IAM by understanding the four identity types: users, groups, service accounts, and domain-wide delegation. Learn Cloud Asset Inventory for comprehensive policy auditing and use IAM recommender for unused roles cleanup.

#### Common Pitfalls
- **Excessive Org-level Permissions**: Leads to privilege creep and makes access revocation impossible
- **Service Account Key Overuse**: Creates security debt and compliance violations
- **Access Scope Confusion**: Legacy feature that complicates permission debugging

#### Lesser-Known Facts
- IAM policies are eventually consistent across Google's infrastructure
- Deny policies were introduced specifically to address the "cannot restrict" problem
- Service accounts can be granted domain-wide delegation for Workspace integration
- The term "service account" predates GCP and originates from traditional system administration

---

### Test Plan
1. ✅ Create users with different privilege levels
2. ✅ Verify policy inheritance behavior
3. ✅ Demonstrate deny policy creation and removal
4. ✅ Create VMs with different service account configurations
5. ✅ Test access scope vs IAM role precedence
6. ✅ Validate service account key management capabilities

Service account concepts continue in Part 2, where we'll explore advanced features like service account impersonation, Workload Identity Federation, and secure key management practices.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
</details>