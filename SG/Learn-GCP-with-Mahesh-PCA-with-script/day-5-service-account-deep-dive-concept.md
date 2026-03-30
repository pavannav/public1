# Session 5: Service Account Deep Dive Concept

## Table of Contents
- [Overview](#overview)
- [CLI vs UI Demonstration Preparation](#cli-vs-ui-demonstration-preparation)
- [Creating a Service Account in CLI](#creating-a-service-account-in-cli)
- [Updating Service Account Display Name](#updating-service-account-display-name)
- [Granting Roles to Service Account in Cross Project](#granting-roles-to-service-account-in-cross-project)
- [Creating a Virtual Machine with Service Account](#creating-a-virtual-machine-with-service-account)
- [SSH and Testing Access](#ssh-and-testing-access)
- [Scenario: VM Without Service Account](#scenario-vm-without-service-account)
- [Use Cases for VMs Without Service Accounts](#use-cases-for-vms-without-service-accounts)
- [Roles for Service Account Authentication](#roles-for-service-account-authentication)
- [Impersonation Techniques](#impersonation-techniques)
- [Service Account Token Creator Role](#service-account-token-creator-role)
- [Token Generation and Validation](#token-generation-and-validation)

## Overview

Service accounts in Google Cloud Platform (GCP) are fundamental for enabling secure, programmatic access to resources. This session dives deep into service account concepts, including creation, role assignment, impersonation, and scenarios without service accounts. The focus is on CLI demonstrations to provide practical exposure, as UI workflows are familiar from previous sessions. Key emphasis is on roles like Service Account User and Token Creator, their permissions, and real-world applications for secure access management.

## CLI vs UI Demonstration Preparation

The session begins by setting up a demonstration environment using both CLI and UI. Key preparations include:
- Creating a service account in the owner's project (Cloud Architect PCA).
- Using a "cross project" for resource access simulations.
- Granting storage roles to enable bucket operations.
- Note: The CLI is preferred for this session to emphasize command-line proficiency, which is beneficial for automation and debugging in production environments.

### Key Points:
- CLI commands are documented in cheat sheets for reference.
- UI (GUI) serves as a fallback when CLI issues arise.
- Exposure to CLI builds troubleshooting skills for exam scenarios.

## Creating a Service Account in CLI

Service accounts can be created via CLI using `gcloud iam service-accounts create`. This command generates an email-based identity without a display name initially.

**Command Example:**
```bash
gcloud iam service-accounts create sa-cli-vm2-gcs \
  --display-name "SA CLI VM to GCS"
```
- Parameters: Service account ID (must be unique, e.g., `sa-cli-vm2-gcs`) and optional display name.
- Output: Confirms creation; list with `gcloud iam service-accounts list` to verify.

> **Note:** Typing `gcloud iam service-accounts create` followed by Tab enables auto-completion for faster CLI usage.

## Updating Service Account Display Name

Newly created service accounts lack a display name, showing only an email ID. Update using `gcloud iam service-accounts update` to improve readability.

**Command Example:**
```bash
gcloud iam service-accounts update sa-cli-vm2-gcs@PROJECT-ID.iam.gserviceaccount.com \
  --display-name "SA CLI VM to GCS"
```
- This adds a human-readable name without affecting functionality.
- Verification: Refresh the GCP Console or re-list in CLI.

> **Note:** Display names are cosmetic but enhance manageability in team environments.

## Granting Roles to Service Account in Cross Project

To simulate cross-project access, assign storage roles to the service account in a separate project. Use `gsutil iam ch` for bucket-level permissions.

**Command Example (in cross project):**
```bash
gsutil iam ch serviceAccount:sa-cli-vm2-gcs@PROJECT-ID.iam.gserviceaccount.com:roles/storage.admin gs://bucket-name
```
- This grants `storage.admin` role at the bucket level for granular control.
- Verification: Check via UI (`Permissions` tab on bucket) or CLI (`gsutil iam get`).

> **Note:** Bucket-level permissions override project defaults, ensuring least privilege.

### Corrected Transcript Errors:
- "Larn with Mahesh 2" corrected to "Learn with Mahesh".
- "mahes 2@gmail.com" interpreted as user's email; retained as in transcript but note potential context.

## Creating a Virtual Machine with Service Account

VMs can attach service accounts during creation via CLI. Specify the service account email and access scopes (e.g., full access equivalent).

**Command Example:**
```bash
gcloud compute instances create vm-sa-data-generator \
  --service-account sa-cli-vm2-gcs@PROJECT-ID.iam.gserviceaccount.com \
  --scopes https://www.googleapis.com/auth/cloud-platform \
  --zone us-central1-a
```
- `--scopes` sets access scope; `cloud-platform` mirrors full access.
- Use `--zones` to verify available zones: `gcloud compute zones list`.

> **Note:** Scopes define API access; improper scopes lead to permission issues.

### Verification:
Use `gcloud compute instances describe` to confirm attachment.
- Output includes service account details in YAML format.

## SSH and Testing Access

SSH into the VM and test service account access. Verify connectivity and bucket operations.

**SSH Command:**
```bash
gcloud compute ssh vm-sa-data-generator --zone us-central1-a
```
- Inside VM: Run `gsutil ls` to list accessible buckets (should succeed with attached service account).
- Without service account: Errors indicate isolation.

### Testing Commands:
- Create/Upload: `echo "test" | gsutil cp - gs://bucket/test.txt`
- List: `gsutil ls gs://bucket`
- Verification in UI: Confirm via GCP Console.

## Scenario: VM Without Service Account

Creating VMs without service accounts promotes isolation—akin to an air-gapped laptop.

**Command Example:**
```bash
gcloud compute instances create vm-no-sa \
  --no-service-account \
  --scopes none \
  --zone us-central1-a
```
- `--no-service-account` prevents attachment; VM operates with default IAM but no programmatic access.
- Access remains limited to internal resources (e.g., no GCP APIs, no bucket access).

### Testing Within VM:
- `gcloud auth list`: Returns no service accounts.
- `gsutil ls`: Fails with permission errors.
- Internet access persists for downloading tools (e.g., `wget GOOGLE_SITE` works).

## Use Cases for VMs Without Service Accounts

VMs without service accounts suit scenarios requiring compute without GCP resource access.

- **Sandbox Environments:** Enable new users/engineers to experiment without risking data/business logic.
- **Student/Offshore Development:** Provide isolated compute for coding/tasks without full cloud access.
- **Batch Processing:** Run computations needing only CPU/RAM/storage and internet, avoiding over-permissive defaults.

> **Analogy:** Like connecting to corporate VPN for work tools vs. public Wi-Fi for browsing.

## Roles for Service Account Authentication

Roles govern access to service accounts, split into impersonation and resource attachment.

### Service Account User Role
- Grants `iam.serviceAccounts.actAs` permission for impersonation.
- Used in VM troubleshooting to "act as" the attached service account.

**Command Example (Project-Level - Avoid in Production):**
```bash
gcloud projects add-iam-policy-binding PROJECT-ID \
  --member user:simple.gcp.user@gmail.com \
  --role roles/iam.serviceAccountUser
```
- Drawback: Inherits to all service accounts; use at specific service account level instead.

**Best Practice Command (At Service Account Level):**
```bash
gcloud iam service-accounts add-iam-policy-binding sa-cli-vm2-gcs@PROJECT-ID.iam.gserviceaccount.com \
  --member user:simple.gcp.user@gmail.com \
  --role roles/iam.serviceAccountUser
```

### Resources Attach Service Accounts To:
- Compute Engine instances.
- Cloud Functions, Cloud Run, App Engine.
- Workflows, Composer, Jupyter Notebooks.

> **Note:** Short-lived credentials (1 hour) enable safe access.

### IAM Conditions for Restrictions
Apply time-based or attribute filters (e.g., expiration, work hours).
- Example: Expire access at specific times for contractors.

**Table: Roles and Permissions Summary**
| Role                  | Key Permission                  | Use Case                          |
|-----------------------|---------------------------------|-----------------------------------|
| Service Account User | iam.serviceAccounts.actAs      | Impersonate for VM/App troubleshooting |
| Service Account Token Creator | iam.serviceAccounts.getAccessToken, etc. | Generate tokens for API calls   |

## Impersonation Techniques

Impersonation involves acting as a service account without attaching it to resources.

### Traditional Approach (Via VM):
Requires compute roles; logs credit the service account, masking human actions.

### Flag-Based Impersonation (Token Creator Role):
Use `--impersonate-service-account` for direct API calls.

**Command Example:**
```bash
gcloud storage buckets list --impersonate-service-account sa-cli-vm2-gcs@PROJECT-ID.iam.gserviceaccount.com
```
- Requires `iam.serviceAccountTokenCreator` role.
- Alternatively: `gsutil -i SERVICE_ACCOUNT ls gs://bucket`

### Setting Persistent Impersonation:
Configure globally to avoid per-command flags.

**Command Example:**
```bash
gcloud config set auth/impersonate_service_account sa-cli-vm2-gcs@PROJECT-ID.iam.gserviceaccount.com
```
- Applies to all `gcloud` and `gsutil` commands.

> **Note:** Enables principle of least privilege without over-granting roles.

### Logging and Debugging:
- Use `--verbosity debug` to trace token generation.
- Access tokens: Validate via `https://oauth2.googleapis.com/token` or GCP Console.

## Service Account Token Creator Role

This role allows token generation for impersonation without VMs.

**Permissions:**
- Generate access tokens (opaque, 1-hour expiry).
- Generate ID tokens (JWT for authentication).
- Sign blobs/JWTs for advanced integrations.

**Table: Token Types**
| Token Type    | Description                          | Validation URL                   |
|----------------|--------------------------------------|-----------------------------------|
| Access Token  | Proprietary; for authorization      | https://oauth2.googleapis.com/tokeninfo |
| ID Token      | JWT; for identity verification       | https://jwt.io (or GCP tools)    |

### Demonstration:
- Print tokens: `gcloud auth print-access-token`, `gcloud auth print-identity-token`.
- Validate: Tools like jwt.io for ID tokens; GCP endpoints for access tokens.

## Summary

### Key Takeaways
```diff
+ Service accounts enable secure, scoped access to GCP resources.
+ Impersonation allows humans to act as service accounts for troubleshooting/testing.
+ No-service-account VMs ensure isolation and reduce credential risks.
+ Token Creator role facilitates short-lived access without resource attachments.
+ IAM conditions enforce time/IP-based restrictions for enhanced security.
- Avoid project-level service account roles; use service account-specific bindings.
- Over-reliance on default scopes leads to excessive permissions.
- Ignoring audit logs masks unauthorized actions.
+ CLI proficiency aids automation and exam success.
```

### Expert Insight

#### Real-world Application
In production, service accounts power CI/CD pipelines (e.g., Terraform automation) and app-to-GCP integrations. For incident response, impersonation ensures ops teams can on-demand debug without permanent access, balancing security with efficiency in regulated environments like finance or healthcare.

#### Expert Path
Master advanced IAM by exploring Workload Identity Federation for external systems. Practice with Terraforms for infrastructure as service-account-driven code. Certify with Google Cloud Professional Cloud Architect to apply these in large-scale (500+ users) systems.

#### Common Pitfalls
- Granting roles project-wide enables privilege escalation (e.g., impersonating editor accounts).
- Tokens expire in 1 hour; plan for refresh in long-running scripts.
- UI-only reliance fails when clusters/networks restrict interfaces.
- Lesser-known issue: Service accounts can't initiate OS-level logins without `compute.osLogin` roles.
- Mistake: Assuming `--scopes none` blocks internet; VMs retain outbound connectivity.
- Mitigation: Regularly rotate service account keys; use short-lived tokens over long-lived credentials. Test impersonation in dev accounts before prod.
