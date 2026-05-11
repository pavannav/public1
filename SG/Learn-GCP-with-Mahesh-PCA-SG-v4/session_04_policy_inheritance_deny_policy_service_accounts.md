# Session 4: Policy Inheritance, Deny Policy, and Service Accounts (Part 1)

## Table of Contents

1. Policy Inheritance Fundamentals
2. Deny Policy Implementation
3. Service Account Concepts
4. Resource Hierarchy and Policy Flow
5. Summary

## Policy Inheritance Fundamentals

### Overview

Google Cloud IAM policies operate within a hierarchical resource structure where policies cascade downward from higher-level resources to lower-level resources. This inheritance mechanism enables centralized policy management while allowing granular overrides at specific hierarchy levels.

### Key Concepts / Deep Dive

#### Hierarchical Resource Structure

Google Cloud resources follow a top-down organizational hierarchy:

```
Organization
├── Folders (Department, Environment, Region)
│   └── Projects
│       └── Resources (VMs, Buckets, Databases)
```

**Hierarchy Levels:**
- **Organization**: Top-level container for entire cloud estate
- **Folders**: Optional grouping containers for logical organization
- **Projects**: Primary containers for resources and services
- **Resources**: Individual cloud assets (compute instances, storage buckets, etc.)

#### Policy Inheritance Direction

IAM policies flow from higher to lower levels in the hierarchy:

**Organization Level → Folder Level → Project Level → Resource Level**

**Inheritance Rules:**
- Policies automatically inherit from parent resources
- Lower-level policies can override parent policies
- Deny policies take precedence over allow policies
- Most restrictive policies apply

#### Policy Evaluation Process

When determining access, Google Cloud evaluates policies in this order:
1. **Check Deny Policies**: Deny always takes priority
2. **Evaluate Allow Policies**: Apply from organization to resource level
3. **Resolve Conflicts**: Most restrictive policies win

### Lab Demo

#### Basic Policy Inheritance Demonstration

**Setup Requirements:**
- Organization node created
- Folder structure established
- Multiple projects under different folders

**Grant Organization-Level Access:**
```bash
# Grant viewer role at organization level
gcloud organizations add-iam-policy-binding ORGANIZATION_ID \
  --member="user:user@example.com" \
  --role="roles/viewer"
```

**Verify Inheritance:**
1. **Access Box 1 Project** (under folder): User should have viewer access
2. **Access Box 2 Project** (under different folder): User should have viewer access due to inheritance
3. **Check Resource Access**: All resources across projects should be visible

**Remove Organization Access:**
```bash
# Revoke organization-level role
gcloud organizations remove-iam-policy-binding ORGANIZATION_ID \
  --member="user:user@example.com" \
  --role="roles/viewer"
```

**Inheritance Impact:**
- Box 1 and Box 2 projects immediately lose inherited viewer access
- Any direct grants at lower levels remain unaffected

## Deny Policy Implementation

### Overview

Deny policies represent a specialized IAM mechanism that can block specific actions regardless of allowed permissions. Unlike traditional "allow" policies, deny policies create absolute restrictions that cannot be overridden by role assignments at lower hierarchy levels.

### Key Concepts / Deep Dive

#### Deny Policy Characteristics

**Absolute Restriction Mechanisms:**
- Take precedence over all allow policies
- Cannot be overridden by role assignments
- Applied at organization, folder, or project levels
- Effective immediately without propagation delays

**Use Cases:**
- Security compliance requirements
- Regulatory restriction enforcement
- Risk mitigation for sensitive operations
- Organizational governance policies

#### Deny Policy Structure

Deny policies contain:
- **Denied Permissions**: Specific actions to block
- **Denied Principals**: Users/service accounts affected by the policy
- **Condition**: Optional IAM conditions for context-based restrictions

#### Deny vs Allow Policies

| Aspect | Deny Policies | Allow Policies |
|--------|---------------|----------------|
| Precedence | Highest priority | Lower priority |
| Inheritance | Can be inherited | Can be inherited |
| Overrides | Cannot be overridden | Can be overridden |
| Scope | Restrictive only | Additive only |

### Code/Config Blocks

#### Deny Policy Examples

**Block External IP Assignment:**
```yaml
name: constraints/compute.vmExternalIpAccess
listPolicy:
  deniedValues:
  - projects/PROJECT_ID/zones/ZONE/instances/*
```

**Prevent Storage Public Access:**
```yaml
name: constraints/storage.publicAccessPrevention
booleanPolicy:
  enforced: true
```

#### Deny Policy CLI Commands

```bash
# Get current deny policies at organization level
gcloud organizations get-iam-policy ORGANIZATION_ID --filter="policy.deny"

# Add deny policy at project level
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="user:restricted-user@example.com" \
  --role="roles/deniedPermissions"

# View effective deny policies for a resource
gcloud organizations get-effective-iam-policy RESOURCE_NAME
```

### Lab Demo

#### Deny Policy Creation and Testing

**Create Organization-Level Deny Policy:**
1. **Navigate to Organization**: Go to IAM → Organization Policies
2. **Find VM External IP Policy**: Search for "VM External IP Access"
3. **Set Deny Configuration**:
   - Choose "Deny"
   - Apply to all VMs by default
   - Exceptions for specific VMs if needed

**Policy Enforcement:**
```yaml
constraint: constraints/compute.vmExternalIpAccess
listPolicy:
  deniedValues:
  - '*'
```

**Test Policy Effectiveness:**
1. **Attempt VM Creation with External IP**: Should be blocked
2. **Create VM without External IP**: Should succeed
3. **Verify Override Capabilities**: Project-level exceptions should work

**Remove Deny Policy:**
```yaml
constraint: constraints/compute.vmExternalIpAccess
listPolicy:
  allValues: ALLOWED  # Reset to allow mode
```

**Verification Process:**
- VMs previously denied should now allow external IP assignment
- New VM creation should succeed with external IPs

## Service Account Concepts

### Overview

Service accounts represent non-human identities used by applications, automated processes, and cloud resources to authenticate and authorize access to Google Cloud services. Unlike user accounts that represent individual people, service accounts enable programmatic access and machine-to-machine interactions.

### Key Concepts / Deep Dive

#### Service Account Characteristics

**Identity Type:**
- Email-based identity format
- Domain: `@PROJECT_ID.iam.gserviceaccount.com`
- Non-interactive access tokens
- Managed keys and credentials

**Purposes:**
- **Application Authentication**: Web apps accessing cloud services
- **Automation**: CI/CD pipelines and scheduled processes
- **Resource-to-Resource Communication**: VMs accessing other cloud resources
- **API Access**: Programmatic cloud service interactions

#### Service Account Types

**System-Managed Service Accounts:**
- **Compute Engine Default SA**: `@PROJECT_NUMBER-compute@developer.gserviceaccount.com`
- **App Engine Default SA**: `@PROJECT_ID.iam.gserviceaccount.com`
- **Cloud Build Default SA**: `@PROJECT_NUMBER@cloudbuild.gserviceaccount.com`

**User-Managed Service Accounts:**
- Created and configured by users
- Custom permissions and roles
- Key management responsibilities
- Lifecycle controlled by administrators

#### Service Account Keys

**Key Management Options:**
- **Google-Managed Keys**: Platform handles key rotation and security
- **User-Managed Keys**: JSON key files downloaded by users
- **Workload Identity Federation**: External identity sources without keys

**Key Security Best Practices:**
- Regular key rotation (90 days maximum)
- Use short-lived tokens when possible
- Avoid committing keys to version control
- Implement key usage monitoring

### Code/Config Blocks

#### Service Account CLI Commands

```bash
# List all service accounts
gcloud iam service-accounts list

# Create user-managed service account
gcloud iam service-accounts create SERVICE_ACCOUNT_NAME \
  --description="Service account description" \
  --display-name="Display Name"

# Grant role to service account
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="serviceAccount:SERVICE_ACCOUNT@PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/storage.admin"

# Create service account key
gcloud iam service-accounts keys create KEY_FILE.json \
  --iam-account=SERVICE_ACCOUNT@PROJECT_ID.iam.gserviceaccount.com

# List service account keys
gcloud iam service-accounts keys list \
  --iam-account=SERVICE_ACCOUNT@PROJECT_ID.iam.gserviceaccount.com
```

#### Service Account Authentication

```python
# Python client library authentication
from google.oauth2 import service_account

credentials = service_account.Credentials.from_service_account_file(
    'path/to/key.json'
)

# Use credentials with client
from google.cloud import storage
client = storage.Client(credentials=credentials)
```

### Lab Demo

#### VM Service Account Configuration

**Attach Service Account to VM:**
1. **VM Creation Process**: During VM creation, select service account
2. **Choose Appropriate SA**: Use compute default or custom service account
3. **Scope Assignment**: Configure API access scopes

**Service Account Scopes:**
- `https://www.googleapis.com/auth/devstorage.read_only` - Read storage only
- `https://www.googleapis.com/auth/compute.readonly` - Read compute resources
- `https://www.googleapis.com/auth/cloud-platform` - Full platform access

**VM Service Account Authorization:**
1. **Service Account User Role**: Grant to user who creates VMs
2. **Impersonation Setup**: Allows user to act as service account
3. **Access Token Management**: Handle authentication tokens

#### Service Account Resource Access

**Storage Bucket Access Setup:**
1. **Grant Permissions**: Service account gets storage admin role
2. **VM Authentication**: VM uses attached service account credentials
3. **Cloud Storage Operations**: VM can create, read, write bucket objects

**Demonstration Commands:**
```bash
# On VM, authenticate with service account
gcloud auth activate-service-account --key-file=KEY_FILE.json

# Create storage bucket (if permitted by attached SA)
gsutil mb gs://test-bucket-with-sa/

# Verify authentication
gcloud auth list
```

## Resource Hierarchy and Policy Flow

### Overview

The resource hierarchy provides a framework for implementing consistent governance across complex cloud environments. This hierarchical structure enables policy inheritance, role management, and resource organization following enterprise requirements.

### Key Concepts / Deep Dive

#### Hierarchy Components

**Organization Node:**
- Root of resource hierarchy
- Requires domain ownership (Workspace/Cloud Identity)
- Enables centralized policy management
- Billing account association point

**Folders:**
- Optional grouping mechanism
- Support up to 10 nesting levels
- Enable departmental/functional segregation
- Policy inheritance and override capabilities

**Projects:**
- Fundamental resource containers
- Direct attachment to billing accounts
- API enablement and service configuration
- Resource quotas and limits

**Resources:**
- Individual services (VMs, buckets, databases)
- Subject to all inherited policies
- Direct role assignment capabilities
- Specific policy scoping points

#### Policy Flow Dynamics

**Inheritance Patterns:**
- **Cascading Effect**: Policies flow from org → folder → project → resource
- **Override Capability**: Lower-level policies override higher ones
- **Deny Precedence**: Deny policies block regardless of allow policies
- **Role Accumulation**: Multiple roles combine across hierarchy levels

**Policy Resolution Rules:**
- Most restrictive policy applies
- Explicit minus implicit permissions
- Resource-level policies override organization defaults
- Folder policies affect all child projects

#### Resource Management Patterns

**Multi-Project Architecture:**
- **Workload Separation**: Different projects for dev/test/prod
- **Team Isolation**: Project boundaries for different teams
- **Geographic Distribution**: Regional project organization
- **Regulatory Compliance**: Projects meeting specific compliance needs

**Cross-Project Resource Access:**
- Service accounts can access resources across projects
- VPC sharing capabilities
- Shared VPC architectures
- Organization-level service accounts

### Code/Config Blocks

#### Hierarchy Management Commands

```bash
# View organization details
gcloud organizations describe ORGANIZATION_ID

# List folders under organization
gcloud resource-manager folders list --organization=ORGANIZATION_ID

# Create new folder
gcloud resource-manager folders create \
  --display-name="Environment Folder" \
  --organization=ORGANIZATION_ID

# Move project under folder
gcloud resource-manager folders move PROJECT_ID --parent=FOLDER_ID

# View folder hierarchy
gcloud resource-manager folders get-iam-policy FOLDER_ID
```

#### Policy Administration

```bash
# Add organization-level policy
gcloud organizations add-iam-policy-binding ORGANIZATION_ID \
  --member="user:user@example.com" \
  --role="roles/viewer"

# Check inherited policies
gcloud organizations get-iam-policy ORGANIZATION_ID \
  --filter="member:user@example.com"

# Override at folder level
gcloud resource-manager folders add-iam-policy-binding FOLDER_ID \
  --member="user:user@example.com" \
  --role="roles/editor"
```

### Lab Demo

#### Hierarchical Policy Implementation

**Organization-Level Security:**
1. **Implement Security Viewer Role**: Grant at organization root
2. **Verify Inheritance**: Check access across all projects and folders
3. **Service Account Setup**: Configure organization-wide service accounts

**Folder-Level Segmentation:**
1. **Create Department Folders**: Separate folders for different teams/departments
2. **Apply Folder-Specific Policies**: Team-specific role assignments
3. **Resource Movement**: Move projects between folders

**Test Policy Isolation:**
1. **Grant Permissions Holiday**: Assign roles at specific hierarchy levels
2. **Verify Override Behavior**: Confirm lower-level policies take precedence
3. **Audit Access Patterns**: Review effective permissions across the hierarchy

## Summary

### Key Takeaways

Policy inheritance and service accounts form the backbone of scalable Google Cloud administration, enabling organizations to implement governance hierarchies that balance central control with operational flexibility:

- **Resource Hierarchy** enables centralized policy management through organization → folder → project → resource structure
- **Policy Inheritance** follows top-down cascading rules with override capabilities
- **Deny Policies** provide absolute restrictions that cannot be bypassed by role assignments
- **Service Accounts** enable programmatic access and resource-to-resource communications
- **Hierarchical Design** supports multi-project architectures with secure isolation
- **Policy Resolution** prioritizes deny rules and most restrictive permissions

### Quick Reference / Cheatsheet

#### Policy Inheritance Commands
```bash
# Add organization policy
gcloud organizations add-iam-policy-binding ORG_ID \
  --member="user:EMAIL" --role="roles/ROLE"

# Check effective policies
gcloud organizations get-effective-iam-policy RESOURCE_NAME

# Remove inherited policy
gcloud [organizations|folders|projects] remove-iam-policy-binding PARENT_ID \
  --member="user:EMAIL" --role="roles/ROLE"
```

#### Deny Policy Management
```bash
# List organization policies
gcloud organizations list-policies ORG_ID

# Set deny policy for external IPs
gcloud organizations set-policy POLICY_FILE --organization=ORG_ID

# Check policy constraints
gcloud resource-manager org-policies describe CONSTRAINT_NAME \
  --organization=ORG_ID
```

#### Service Account Operations
```bash
# Create service account
gcloud iam service-accounts create SA_NAME --display-name="Display Name"

# List service account keys
gcloud iam service-accounts keys list --iam-account=SA_EMAIL

# Disable service account key
gcloud iam service-accounts keys disable KEY_ID \
  --iam-account=SA_EMAIL
```

#### Hierarchy Navigation
```bash
# List projects under folder
gcloud projects list --filter="parent.id:FOLDER_ID"

# Move project to different folder
gcloud resource-manager folders move PROJECT_ID \
  --destination-parent=FOLDER_ID

# View complete hierarchy
gcloud organizations describe ORG_ID --format="export"
```

### Expert Insights

#### 🏭 **Real-world Application**
Enterprise cloud deployments typically:
- **Establish resource hierarchies** aligned with organizational structure
- **Implement deny policies** for compliance and security requirements
- **Use service accounts extensively** for automation and API access
- **Apply folder-level policies** for department-specific governance
- **Conduct regular policy audits** to maintain inheritance integrity
- **Design custom roles** at appropriate hierarchy levels

#### 🧭 **Expert Path**
Advanced hierarchy implementations include:
1. **Conditional policies** using IAM Conditions for contextual access
2. **VPC Service Controls** for data perimeter protection
3. **Organization policies** enforcing compliance across the estate
4. **Workload Identity Federation** replacing service account keys
5. **Cloud Asset Inventory** for comprehensive resource discovery
6. **Security Health Analytics** for proactive threat detection

#### 🪤 **Common Pitfalls**
- **Misconfiguring inheritance** leading to over-privileged access
- **Overusing service account keys** instead of managed identity
- **Ignoring deny policy precedence** in complex hierarchies
- **Creating too many folders** causing administrative overhead
- **Not planning project boundaries** early in migration
- **Mixing different access patterns** creating policy confusion

#### 🔍 **Lesser-Known Facts**
- **Service accounts consume project quota** even when inactive
- **Deny policies apply immediately** without 60-second propagation delay
- **Organization policies support conditional enforcement** through IAM Conditions
- **Folders can be nested up to 10 levels** for complex organizational structures
- **Service account keys cannot be recovered** once deleted or rotated
- **Inherited policies show as direct grants** in permission UI for clarity

#### ⚖️ **Advantages & Disadvantages**

| Feature | Advantages | Disadvantages |
|---------|------------|---------------|
| Policy Inheritance | Centralized management, consistent governance | Complex override logic, requires planning |
| Deny Policies | Absolute restrictions, compliance enforcement | No override capability, potential blocking |
| Service Accounts | Programmatic access, secure automation | Key management overhead, quota consumption |
| Resource Hierarchy | Scalable organization, flexible governance | Administrative complexity, learning curve |

**Implementation Decision Framework:**
1. **Start with organization-level baseline policies**
2. **Use folders for logical grouping and departmental isolation**
3. **Implement deny policies for security and compliance requirements**
4. **Create service accounts for programmatic access patterns**
5. **Test policy inheritance thoroughly before production rollout**
6. **Establish monitoring and auditing for ongoing governance**

📝 Transcript Corrections: None identified.