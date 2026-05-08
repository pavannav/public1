# Session 05: Service Account Deep Dive Concept

## Table of Contents
- [Overview](#service-account-concepts)
- [CLI vs UI for Service Accounts](#cli-vs-ui-for-service-accounts)
- [Creating Service Accounts](#creating-service-accounts)
- [Granting Roles to Service Accounts](#granting-roles-to-service-accounts)
- [Creating Virtual Machines with Service Accounts](#creating-virtual-machines-with-service-accounts)
- [Attaching Service Accounts to Existing VMs](#attaching-service-accounts-to-existing-vms)
- [Service Account Scopes](#service-account-scopes)
- [SSH and Access Control](#ssh-and-access-control)
- [VMs Without Service Accounts](#vms-without-service-accounts)
- [IAM Roles for Service Accounts](#iam-roles-for-service-accounts)
- [Impersonation Concepts](#impersonation-concepts)
- [Tokens and Credentials](#tokens-and-credentials)
- [IAM Conditions](#iam-conditions)
- [Best Practices and Security Considerations](#best-practices-and-security-considerations)

## Service Account Concepts

### Overview
Service accounts in Google Cloud Platform (GCP) are special accounts designed for applications, VMs, or services to authenticate and authorize access to GCP resources without human intervention. Unlike user accounts, service accounts do not have passwords but use keys for authentication. They play a crucial role in maintaining the principle of least privilege, enabling secure and automated interactions with GCP services like Compute Engine, Cloud Storage, and Big Data tools.

Key points include understanding how to create, manage, and secure service accounts across different GCP projects, ensuring proper role assignments, and managing impersonation for controlled access.

### Key Concepts / Deep Dive
Service accounts differ from user accounts by:

- **Authentication Mechanism**: Use JSON keys or service account tokens instead of passwords.
- **Purpose**: Primarily for non-interactive tasks such as API calls from applications or VM operations.
- **Lifecycle Management**: Can be created, disabled, deleted, and managed via IAM policies.
- **Resource Attachments**: Can be attached to VMs or used via impersonation for specific operations.

The core workflow involves:
1. Creating a service account in the appropriate project.
2. Granting specific IAM roles to control permissions.
3. Attaching the service account to resources or using impersonation for access.
4. Managing scopes and conditions for granular control.

### Code/Config Blocks
Example service account creation via CLI:

```bash
gcloud iam service-accounts create [SERVICE_ACCOUNT_NAME] \
    --description="[DESCRIPTION]" \
    --display-name="[DISPLAY_NAME]"
```

### Tables
| Aspect | User Account | Service Account |
|--------|--------------|-----------------|
| Authentication | Password/2FA | Keys/Tokens |
| Purpose | Human Interaction | Automated Tasks |
| Lifetime | User-dependent | Project-independent |
| Attachable to Resources | No | Yes |

### Lab Demos
1. Create a service account in a GCP project:
   ```bash
   gcloud iam service-accounts create my-service-account \
       --description="Demo service account" \
       --display-name="My Service Account"
   ```
   ✅ Creates a service account with email format: `[NAME]@[PROJECT].iam.gserviceaccount.com`.

2. List all service accounts:
   ```bash
   gcloud iam service-accounts list
   ```

## CLI vs UI for Service Accounts

### Overview
Google Cloud provides both CLI (via `gcloud` commands) and UI (console) interfaces for managing service accounts. CLI offers automation potential and is essential for scripts, while UI provides visual feedback and ease for manual operations. The session emphasized CLI for exam preparation and real-world automation.

### Key Concepts / Deep Dive
- **CLI Advantages**: Supports bulk operations, scripting, and precise control. Useful for repeated tasks like creating multiple service accounts.
- **UI Limitations**: May not support all granular permissions (e.g., attaching scopes) withoutreferring to equivalent CLI commands. UI excels in quick visualizations but can fail for complex role assignments if the user lacks project-level permissions.
- **Exam Relevance**: Exams may describe scenarios requiring CLI commands, making familiarity crucial even if UI is preferred.

### Code/Config Blocks
Equivalent gcloud command for UI service account creation:
```bash
gcloud iam service-accounts create [NAME] \
    --display-name="Display Name"
```

### Lab Demos
1. Create a service account via CLI and verify in UI:
   ```bash
   gcloud iam service-accounts create sa-cli-test
   ```
   Then refresh the IAM service accounts page in the console to confirm creation.

## Creating Service Accounts

### Overview
Service accounts are created with a unique email address and can include display names for identification. They are managed at the project level and can be used across projects with proper permissions.

### Key Concepts / Deep Dive
- **Email Format**: Automatically generated as `[NAME]@[PROJECT_ID].iam.gserviceaccount.com`.
- **Display Name**: Optional but recommended for clarity; editable post-creation.
- **Project Limitations**: Most operations are project-bound, but cross-project access requires explicit grants.
- **Best Practice**: Use descriptive names (e.g., `sa-vm-gcs-access`) to indicate purpose.

### Code/Config Blocks
Create and update display name:
```bash
# Create service account
gcloud iam service-accounts create sa-cli-demo --display-name="Demo SA"

# Update display name if not set initially
gcloud iam service-accounts update [EMAIL] --display-name="Updated Name"
```

### Lab Demos
1. Create a service account without display name, then update it:
   ```bash
   gcloud iam service-accounts create sa-no-name
   gcloud iam service-accounts list  # Verify no display name
   gcloud iam service-accounts update sa-no-name@[PROJECT].iam.gserviceaccount.com --display-name="Named SA"
   ```

## Granting Roles to Service Accounts

### Overview
Roles define permissions for service accounts. Roles like `roles/storage.admin` grant specific resource access. Grants can be project-level or resource-specific for minimal privilege.

### Key Concepts / Deep Dive
- **Types of Roles**: Predefined (e.g., Storage Admin) or custom. Predefined roles are safer for beginners.
- **Inheritance**: Project-level grants apply to all resources unless overridden.
- **Cross-Project Grants**: Use resource-specific grants (e.g., bucket-level for GCS) to avoid over-permissions.

### Code/Config Blocks
Grant role at bucket level:
```bash
gsutil iam ch serviceAccount:[EMAIL]:roles/storage.admin gs://[BUCKET_NAME]
```

### Tables
| Role | Description | Use Case |
|------|-------------|----------|
| roles/storage.admin | Full Cloud Storage control | GCS bucket management |
| roles/compute.instanceAdmin | VM lifecycle management | Creating VMs with SA |

### Lab Demos
1. Create a bucket and grant storage admin to a service account:
   ```bash
   gsutil mb gs://cross-project-bucket
   gsutil iam ch serviceAccount:sa-cli-demo@[PROJECT].iam.gserviceaccount.com:roles/storage.admin gs://cross-project-bucket
   ```

## Creating Virtual Machines with Service Accounts

### Overview
When provisioning VMs, attach a service account for the VM's applications to authenticate against GCP APIs. The default compute engine service account is editor-level, but custom accounts enable principle of least privilege.

### Key Concepts / Deep Dive
- **Attachment Benefits**: VM applications automatically use attached SA credentials for API calls.
- **Scope Configuration**: Controls API access level (e.g., full API access via `cloud-platform` scope).
- **VM Metadata**: Service account info is stored in VM metadata, accessible to authorized users.

### Code/Config Blocks
Create VM with service account:
```bash
gcloud compute instances create vm-sa-demo \
    --zone=us-central1-a \
    --service-account=sa-cli-demo@[PROJECT].iam.gserviceaccount.com \
    --scopes=https://www.googleapis.com/auth/cloud-platform
```

### Lab Demos
1. Create a VM with a custom service account:
   ```bash
   gcloud compute instances create vm-demo \
       --zone=us-central1-a \
       --service-account=sa-cli-demo@[PROJECT].iam.gserviceaccount.com \
       --scopes=https://www.googleapis.com/auth/cloud-platform
   ```
   Verify via `gcloud compute instances describe vm-demo --zone=us-central1-a`.

## Attaching Service Accounts to Existing VMs

### Overview
Existing VMs can have service accounts attached via metadata updates, allowing dynamic role changes without recreation.

### Key Concepts / Deep Dive
- **Use Cases**: Fix access issues or change permissions post-provisioning.
- **Limitations**: Existing VM sessions may not immediately reflect changes; reboot might be needed.

### Code/Config Blocks
Attach SA to existing VM (using API-level command if direct attach isn't available):
- Use gcloud to update metadata, but primary method is during creation or via console.

### Lab Demos
Via UI: Edit VM > Identity and API access > Update service account.

## Service Account Scopes

### Overview
Scopes limit API access for service accounts on VMs. Default scopes are broad, but custom scopes enforce granular access.

### Key Concepts / Deep Dive
- **`cloud-platform` Scope**: Equivalent to full access, enables all APIs.
- **Granular Scopes**: Restrict to specific APIs (e.g., `devstorage.read_write` for GCS).
- **Security**: Use restrictive scopes to prevent privilege escalation.

### Code/Config Blocks
Set scope during VM creation:
```yaml
# In equivalent REST or Terraform
scopes:
  - https://www.googleapis.com/auth/cloud-platform
```

### Tables
| Scope URL | Description |
|-----------|-------------|
| https://www.googleapis.com/auth/cloud-platform | Full access to all GCP APIs |
| https://www.googleapis.com/auth/devstorage.read_write | Read/write GCS access only |

## SSH and Access Control

### Overview
SSH into VMs requires IAM permissions like `roles/compute.instanceAdmin` and, if service accounts are attached, `roles/iam.serviceAccountUser` for impersonation.

### Key Concepts / Deep Dive
- **Standard SSH**: `gcloud compute ssh` handles key exchange automatically.
- **Impersonation Impact**: Users with `serviceAccountUser` role can SSH into VMs with attached SAs; others cannot.
- **Troubleshooting**: Check IAM policies and service account attachments.

### Code/Config Blocks
SSH into VM:
```bash
gcloud compute ssh vm-demo --zone=us-central1-a
```

Inside VM, check SA: `curl "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/email" -H "Metadata-Flavor: Google"`

### Lab Demos
1. Try SSH with insufficient permissions: Expect "Permission denied" error.
2. Grant `roles/iam.serviceAccountUser` at project level (⚠️ Caution: Broad permission), then SSH successfully.

## VMs Without Service Accounts

### Overview
VMs can operate without attached service accounts, relying on external APIs or user accounts for authentication. This creates isolated environments.

### Key Concepts / Deep Dive
- **Use Cases**: Sandboxes, student VMs, or environments needing only compute resources.
- **Access Limitations**: Cannot authenticate against GCP APIs directly; requires manual auth (e.g., `gcloud auth login`).

### Code/Config Blocks
Create VM without SA:
```bash
gcloud compute instances create vm-no-sa \
    --zone=us-central1-a \
    --no-service-account \
    --no-scopes
```

Inside VM: Attempt `gsutil ls` → Error; use `gcloud auth login` for access.

### Tables
| VM Type | Capabilities | Security |
|---------|--------------|----------|
| With SA | Direct API access | Detached from owner actions |
| Without SA | Manual auth required | Isolated, no API risks |

## IAM Roles for Service Accounts

### Overview
Specific IAM roles control how principals interact with service accounts, enabling impersonation and token creation.

### Key Concepts / Deep Dive
- **serviceAccountUser**: Allows impersonation for attaching to VMs or API calls.
- **serviceAccountTokenCreator**: Enables generating short-lived tokens for secure access.
- **Security Levels**: `serviceAccountUser` is broad; prefer resource-specific grants.

### Code/Config Blocks
Grant at service account level:
```bash
gcloud iam service-accounts add-iam-policy-binding [SA_EMAIL] \
    --member=user:[USER_EMAIL] \
    --role=roles/iam.serviceAccountTokenCreator
```

Set impersonation config:
```bash
gcloud config set auth/impersonate-service-account [SA_EMAIL]
```

### Tables
| Role | Permissions | Use Case |
|------|-------------|----------|
| roles/iam.serviceAccountUser | Impersonate, attach to resources | VM access |
| roles/iam.serviceAccountTokenCreator | Create tokens | API access without attachment |

## Impersonation Concepts

### Overview
Impersonation allows users to act as service accounts without permanent keys, using short-lived credentials.

### Key Concepts / Deep Dive
- **Mechanisms**: Via `gcloud` flag or config set.
- **Security**: Credentials expire (1 hour), improving auditability.
- **Vs. Attachment**: Impersonation doesn't attach SA to VM; temporary for operations.

> [!IMPORTANT]
> Impersonation logs actions under the service account, not the user.

### Code/Config Blocks
Impersonate for command:
```bash
gcloud storage buckets list --impersonate-service-account=[SA_EMAIL]
```

## Tokens and Credentials

### Overview
Service accounts use access tokens (for auth) and ID tokens (for identity) across applications.

### Key Concepts / Deep Dive
- **Access Tokens**: Opaque, 1-hour validity, used for API authorization.
- **ID Tokens**: JWT format, verifiable, used for user identity in applications.
- **Generation**: Via `serviceAccountTokenCreator` role permissions.

### Code/Config Blocks
Generate tokens:
```bash
# Access token
gcloud auth print-access-token --impersonate-service-account=[SA_EMAIL]

# ID token
gcloud auth print-identity-token --impersonate-service-account=[SA_EMAIL]
```

### Lab Demos
Inspect tokens using online decoders (e.g., jwt.io for ID tokens, Google Token Info for access tokens).

## IAM Conditions

### Overview
IAM conditions add restrictions like time-based or IP-based access for enhanced security.

### Key Concepts / Deep Dive
- **Examples**: Expire access after date or restrict to business hours.
- **Syntax**: Adds conditions to role bindings.

### Code/Config Blocks
Add expiry condition (conceptual):
- Use UI or gcloud IAM policies with conditions (e.g., `request.time < timestamp(...)`).

### Lab Demos
1. Grant temporary access expiring in minutes:
   - UI: Add condition on role binding.
   - Verify expiration by attempting denied actions post-expiry.

## Best Practices and Security Considerations

### Overview
Secure service account usage involves minimal roles, avoiding defaults, and regular audits.

## Summary

### Key Takeaways
```diff
+ Service accounts enable automated API access with fine-grained permissions
+ CLI provides automation and is exam-critical alongside UI
+ Impersonation offers temporary access via short-lived tokens
+ Attach SAs to VMs for seamless auth, or use impersonation for external ops
+ IAM conditions add temporal or contextual restrictions for security
- Avoid granting broad roles like editor or service account user at project level
- Never share SA keys; use impersonation instead
! Always verify role grants and audit logs for compliance
```

### Quick Reference
- Create SA: `gcloud iam service-accounts create [NAME]`
- Grant role: `gsutil iam ch serviceAccount:[EMAIL]:roles/[ROLE] gs://[BUCKET]`
- Create VM with SA: `gcloud compute instances create [VM] --service-account=[EMAIL] --scopes=https://www.googleapis.com/auth/cloud-platform`
- Impersonate: `gcloud [COMMAND] --impersonate-service-account=[EMAIL]`
- SSH: `gcloud compute ssh [VM] --zone=[ZONE]`

### Expert Insight
**Real-world Application**: In CI/CD pipelines, service accounts handle deployments to GCS or BigQuery, ensuring production code runs without human credentials.

**Expert Path**: Master custom roles for precise permissions, dive into OAuth flows for external app integrations, and use Workload Identity Federation for cross-cloud scenarios.

**Common Pitfalls**: Overusing default compute engine SA leads to privilege escalation; neglecting token expiry risks long-term access from compromised sessions; ignoring IAM conditions exposes to weekend abuse.

**Lesser-Known Facts**: ID tokens can be used with Google's Authentication libraries for zero-trust architectures; service accounts can self-rotated keys programmatically.

**Advantages**: Secure automation, auditable actions, cross-project flexibility. **Disadvantages**: Key management complexity, risk of misconfiguration leading to breaches. 

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
