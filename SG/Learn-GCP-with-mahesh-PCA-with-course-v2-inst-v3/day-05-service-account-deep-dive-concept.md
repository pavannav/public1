<details open>
<summary><b>Session Day 05 - Service Account Deep Dive Concept (KK-CS45-script-v2-Inst-v3)</b></summary>

# Session Day 05: Service Account Deep Dive Concept

## Table of Contents
- [Overview](#overview)
- [Key Concepts](#key-concepts)
- [Creating Service Accounts](#creating-service-accounts)
- [Granting Roles to Service Accounts](#granting-roles-to-service-accounts)
- [Service Account Token Creator Role Deep Dive](#service-account-token-creator-role-deep-dive)
- [Creating VMs with Service Accounts](#creating-vms-with-service-accounts)
- [Service Account Impersonation](#service-account-impersonation)
- [IAM Conditions for Temporary Access](#iam-conditions-for-temporary-access)
- [Lab Demos](#lab-demos)
- [Summary](#summary)

## Overview

This session provides an in-depth exploration of Google Cloud service accounts, focusing on advanced concepts like impersonation, token creation, and best practices for managing access. We'll compare CLI and UI approaches while demonstrating how service accounts enable secure access to Google Cloud resources across different scenarios. The session emphasizes the importance of least privilege, temporary access, and proper role assignments to maintain security while enabling operational needs.

## Key Concepts

### Service Account Hierarchy and Purpose
Service accounts serve as identities for applications, VMs, and automated processes to interact with Google Cloud APIs. Unlike user accounts, service accounts don't have passwords and are designed for programmatic access. They exist at three levels:

1. **Project Level**: Service accounts created within specific projects
2. **Organization Level (if enabled)**: Organization-wide service accounts
3. **Google APIs Service Agent**: System-level accounts created automatically

### Principal vs. Identity
Throughout Google Cloud documentation:
- **Principal**: Refers to any entity that can authenticate and be granted roles (users, service accounts, groups, etc.)
- **Identity**: Represents who/what is performing actions

### Authentication Tokens
Service accounts use different types of tokens based on the role granted:

| Token Type | Purpose | Typical Lifetime | Use Case |
|------------|---------|------------------|----------|
| Access Token | Authorization for API calls | 1 hour | Immediate resource access |
| ID Token | Identity verification | Up to 12 hours | User authentication |
| Refresh Token | Obtaining new access tokens | Varies | Long-term access |

### Service Account Keys vs. Workload Identity Federation
Two primary methods for service account authentication:

1. **Service Account Keys**: JSON private keys (less secure, should be avoided when possible)
2. **Workload Identity Federation**: Secure authentication without keys using workload identity pools

## Creating Service Accounts

### CLI Approach
Create service accounts using `gcloud iam service-accounts` commands.

```bash
# List existing service accounts
gcloud iam service-accounts list

# Create a new service account with display name
gcloud iam service-accounts create sa-cli-vm-to-gcs \
    --display-name "SA CLI VM to GCS" \
    --description "Service account for VM to interact with GCS"
```

### UI Approach
Navigate to IAM → Service Accounts → Create Service Account

```yaml
# Equivalent Terraform
resource "google_service_account" "sa_cli_vm_to_gcs" {
  account_id   = "sa-cli-vm-to-gcs"
  display_name = "SA CLI VM to GCS"
  description  = "Service account for VM to interact with GCS"
}
```

### Best Practices for Service Accounts
- Always provide meaningful display names
- Use descriptive account IDs (lowercase, hyphens allowed)
- Follow naming convention: `[component]-[purpose]-[environment]`

## Granting Roles to Service Accounts

### Bucket-Level Access Grant
Grant specific roles to service accounts on individual Cloud Storage buckets.

```bash
# Method 1: Using gsutil (recommended for bucket operations)
gsutil iam ch serviceAccount:sa-cli-vm-to-gcs@learn-gcp-with-mahesh-pca.iam.gserviceaccount.com:roles/storage.admin \
    gs://cross-project-gcs-cli/

# Method 2: Using gcloud storage (newer alternative)
gcloud storage buckets add-iam-policy-binding gs://cross-project-gcs-cli/ \
    --member="serviceAccount:sa-cli-vm-to-gcs@learn-gcp-with-mahesh-pca.iam.gserviceaccount.com" \
    --role="roles/storage.admin"
```

### Verification Commands
Verify role grants using the following commands:

```bash
# Get IAM policy for the bucket
gsutil iam get gs://cross-project-gcs-cli/

# List buckets and verify access
gsutil ls gs://cross-project-gcs-cli/
```

### Common Storage Roles

| Role | Purpose | Permissions |
|------|---------|--------------|
| `roles/storage.admin` | Full control | Read/write/delete objects |
| `roles/storage.objectAdmin` | Object management | Read/write/delete (no bucket ops) |
| `roles/storage.objectViewer` | Read-only | Download/view objects |
| `roles/storage.objectCreator` | Create only | Upload objects |

> [!IMPORTANT]
> Always use least privilege principle. Grant only the minimum permissions required for the specific task.

## Service Account Token Creator Role Deep Dive

### Advanced Impersonation Capabilities
The `roles/iam.serviceAccountTokenCreator` role enables advanced authentication scenarios:

#### 1. Short-Lived Token Generation
Generate temporary access tokens for service accounts:

```bash
# Generate access token via impersonation
gcloud auth print-access-token --impersonate-service-account=sa-cli-vm-to-gcs@learn-gcp-with-mahesh-pca.iam.gserviceaccount.com

# Use in API calls
curl -H "Authorization: Bearer $(gcloud auth print-access-token --impersonate-service-account=sa-cli-vm-to-gcs@learn-gcp-with-mahesh-pca.iam.gserviceaccount.com)" \
     https://storage.googleapis.com/storage/v1/b/bucket-name/o
```

#### 2. Identity Token Generation
Create tokens for identity verification:

```bash
# Generate ID token
gcloud auth print-identity-token --impersonate-service-account=sa-cli-vm-to-gcs@learn-gcp-with-mahesh-pca.iam.gserviceaccount.com
```

#### 3. Persistent Impersonation Configuration
Set default impersonation service account:

```bash
# Configure persistent impersonation
gcloud config set auth/impersonate_service_account sa-cli-vm-to-gcs@project-id.iam.gserviceaccount.com

# All subsequent commands will use this service account
gcloud storage buckets list
```

### Use Cases for Token Creator Role

| Scenario | Benefit | Example |
|----------|---------|---------|
| **Temporary Access** | Allow contractors limited-time access | Knowledge transfer, emergency fixes |
| **API Automation** | Generate tokens for CI/CD pipelines | GitHub Actions, Jenkins |
| **Cross-Project Access** | Service accounts in different projects | Multi-tier architectures |
| **Security Audit** | Track actions under service account identity | Compliance requirements |

### API Call Tracing
When using impersonation, authenticate with IAM credentials API:

```bash
# REST API call to generate access token
curl -X POST \
  -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  -H "Content-Type: application/json" \
  https://iamcredentials.googleapis.com/v1/projects/-/serviceAccounts/SA_EMAIL:generateAccessToken
```

## Creating VMs with Service Accounts

### CLI Commands with Service Account Specification
Create compute instances with specific service accounts:

```bash
# Create VM with service account and full access scope
gcloud compute instances create vm-with-sa \
    --service-account sa-cli-vm-to-gcs@learn-gcp-with-mahesh-pca.iam.gserviceaccount.com \
    --scopes https://www.googleapis.com/auth/cloud-platform \
    --zone us-central1-a

# Create VM without service account (isolated instance)
gcloud compute instances create vm-no-sa \
    --no-service-account \
    --no-scopes \
    --zone us-central1-a
```

### Access Scope Options

| Scope URL | Description | Use Case |
|-----------|-------------|----------|
| `https://www.googleapis.com/auth/cloud-platform` | Full access | Development, testing |
| `https://www.googleapis.com/auth/devstorage.read_only` | Storage read-only | Analytics instances |
| `https://www.googleapis.com/auth/bigquery` | BigQuery access | Data warehouse VMs |
| `https://www.googleapis.com/auth/compute.readonly` | Compute API read-only | Monitoring tools |

### UI Configuration
In Cloud Console: Compute Engine → VM instances → Create Instance → Advanced Options → Service account

### SSH to VMs
Access VMs created with service accounts:

```bash
# SSH to VM (will use service account if attached)
gcloud compute ssh vm-with-sa --zone us-central1-a

# SSH to VM without service account (uses personal credentials)
gcloud compute ssh vm-no-sa --zone us-central1-a
```

## Service Account Impersonation

### Impersonation vs. Attachment

| Method | Description | When to Use |
|--------|-------------|-------------|
| **Attachment** | Service account baked into VM metadata | Always-on access for applications |
| **Impersonation** | Temporary token generation for humans/processes | On-demand access, temporary privileges |

### Security Implications

> [!WARNING]
> Improper use of Service Account User role can lead to privilege escalation:
> - Project-level grant allows impersonation of ALL service accounts
> - Service account-level grant limits scope to specific identity
> - Always prefer granular, time-limited access

### Principal of Least Privilege in Practice

```bash
# ❌ BAD: Project-level access (dangerous!)
gcloud projects add-iam-policy-binding learn-gcp-with-mahesh-pca \
    --member user:contractor@example.com \
    --role roles/iam.serviceAccountUser

# ✅ GOOD: Specific service account access
gcloud iam service-accounts add-iam-policy-binding sa-cli-vm-to-gcs@project-id.iam.gserviceaccount.com \
    --member user:contractor@example.com \
    --role roles/iam.serviceAccountTokenCreator
```

## IAM Conditions for Temporary Access

### Setting Expiring Access

```bash
# Grant role with expiration condition
gcloud iam service-accounts add-iam-policy-binding sa-cli-vm-to-gcs@project-id.iam.gserviceaccount.com \
    --member user:contractor@example.com \
    --role roles/iam.serviceAccountTokenCreator \
    --condition 'expression=request.time < timestamp("2024-12-31T23:59:59Z"),title=TempAccess'
```

### Time-Based Conditions
Common IAM conditions for service accounts:

- **Expiration**: `request.time < timestamp("2024-12-31T23:59:59Z")`
- **Weekday Access**: `request.time.getDayOfWeek() >= 1 && request.time.getDayOfWeek() <= 5`
- **Business Hours**: `request.time.getHours() >= 9 && request.time.getHours() <= 17`

### Real-World Applications

| Business Need | IAM Condition Use Case |
|----------------|----------------------|
| **Contractor Access** | Time-limited access for project handoff |
| **Emergency Fixes** | Temporary elevated privileges |
| **Work-Life Balance** | Time-of-day restrictions |
| **Geographic Lockdown** | Location-based access control |

## Lab Demos

### Demo 1: End-to-End Service Account Creation and Access
Complete workflow from service account creation to VM access:

```bash
# Step 1: Create service account
gcloud iam service-accounts create sa-cli-vm-to-gcs \
    --display-name "SA CLI VM to GCS"

# Step 2: Create bucket in different project
gsutil mb -p cross-project gs://cross-project-gcs-cli/

# Step 3: Grant storage admin role
gsutil iam ch serviceAccount:sa-cli-vm-to-gcs@learn-gcp-with-mahesh-pca.iam.gserviceaccount.com:roles/storage.admin \
    gs://cross-project-gcs-cli/

# Step 4: Create VM with service account
gcloud compute instances create vm-data-generator \
    --service-account sa-cli-vm-to-gcs@learn-gcp-with-mahesh-pca.iam.gserviceaccount.com \
    --scopes https://www.googleapis.com/auth/cloud-platform \
    --zone us-central1-a

# Step 5: SSH and test access
gcloud compute ssh vm-data-generator --zone us-central1-a
gsutil cp cross-project.txt gs://cross-project-gcs-cli/
```

### Demo 2: Service Account Impersonation Workflow

```bash
# Grant token creator role
gcloud iam service-accounts add-iam-policy-binding sa-cli-vm-to-gcs@project-id.iam.gserviceaccount.com \
    --member user:simple-gcp-user@example.com \
    --role roles/iam.serviceAccountTokenCreator

# Use impersonation for cloud storage operations
gcloud storage buckets list --impersonate-service-account=sa-cli-vm-to-gcs@project-id.iam.gserviceaccount.com

# Set permanent impersonation
gcloud config set auth/impersonate_service_account sa-cli-vm-to-gcs@project-id.iam.gserviceaccount.com
```

### Demo 3: Comparing VMs with and without Service Accounts

```bash
# Create isolated VM (sandbox environment)
gcloud compute instances create sandbox-vm \
    --no-service-account \
    --no-scopes

# Attempt to access Google Cloud resources
gcloud storage buckets list  # Returns empty/nothing accessible
gcloud compute instances list  # Returns permission denied
```

## Summary

### Key Takeaways
1. **Service accounts** are machine-to-machine identities designed for automated access to Google Cloud resources
2. **Impersonation** allows human users to temporarily "act as" a service account using the `roles/iam.serviceAccountTokenCreator` role
3. **Grant roles at the resource level** rather than project level following the principle of least privilege
4. **IAM conditions** enable time-based, location-based, or rule-based access restrictions
5. **CLI provides more granular control** over service account management compared to UI
6. **Audit logs** show service account activities, but responsibility tracking requires context from multiple log sources

### Quick Reference
#### Command Cheat Sheet

| Task | CLI Command |
|------|-------------|
| Create service account | `gcloud iam service-accounts create [NAME] --display-name "[DISPLAY_NAME]"` |
| List service accounts | `gcloud iam service-accounts list` |
| Grant bucket access | `gsutil iam ch serviceAccount:[EMAIL]:roles/storage.admin gs://[BUCKET]` |
| Create VM with SA | `gcloud compute instances create [VM_NAME] --service-account [EMAIL] --scopes [SCOPE]` |
| Impersonate SA | `--impersonate-service-account=[EMAIL]` |
| Generate access token | `gcloud auth print-access-token --impersonate-service-account=[EMAIL]` |

#### Common Service Account Roles
- `roles/iam.serviceAccountUser`: Basic service account management
- `roles/iam.serviceAccountTokenCreator`: Create short-term tokens for impersonation
- `roles/iam.serviceAccountKeyAdmin`: Manage service account keys (avoid if possible)
- `roles/iam.serviceAccountAdmin`: Full service account lifecycle management

### Expert Insight

#### Real-world Application
Service accounts are fundamental to secure cloud operations:
- **CI/CD Pipelines**: Service accounts provide automated deployment capabilities
- **Multi-tenant Applications**: Isolate tenant resources using dedicated service accounts
- **Federated Access**: Enable cross-organization access without exposing credentials
- **Temporary Elevations**: Contractors and consultants get time-limited access

#### Expert Path
Master service account security through:
1. **Workload Identity Federation** instead of service account keys
2. **Resource-level IAM permissions** over project-level grants
3. **IAM conditions** for just-in-time access
4. **Audit logging analysis** for compliance verification
5. **Service account rotation strategies** and key management

#### Common Pitfalls
- ❌ Granting roles at project level instead of resource level
- ❌ Using service account keys instead of workload identity federation
- ❌ Giving `iam.serviceAccountUser` to untrustworthy users
- ❌ Not monitoring service account usage logs
- ❌ Ignoring the principle of least privilege

#### Lesser-Known Facts
- Service account impersonation tokens are cached locally and share the standard 1-hour lifetime
- Compute Engine default service accounts are automatically created but can be disabled
- Service accounts can be granted roles ON service accounts themselves (meta-permission grants)
- IAM conditions support complex expressions combining time, location, and request attributes
- Service account access scope changes require VM restart to take effect

</details>