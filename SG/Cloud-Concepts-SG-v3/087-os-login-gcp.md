<details open>
<summary><b>Session 87: OS Login in GCP (KK-CS45-script-v3)</b></summary>

# Session 87: OS Login in GCP

## Table of Contents

- [Overview](#overview)
- [Key Concepts/Deep Dive](#key-conceptsdeep-dive)
- [IAM Roles for OS Login](#iam-roles-for-os-login)
- [Enabling OS Login](#enabling-os-login)
- [Connecting to VMs with OS Login](#connecting-to-vms-with-os-login)
- [OS Login with Third-Party Tools](#os-login-with-third-party-tools)
- [External Users and Organization-Level Policies](#external-users-and-organization-level-policies)
- [Limitations](#limitations)
- [Summary](#summary)

## Overview

OS Login is a Google Cloud feature that allows you to manage SSH access to Linux VMs on Compute Engine without managing individual SSH keys. It leverages Google Cloud Identity and Access Management (IAM) roles to control access, ensuring consistent user identities across VM instances. Unlike traditional SSH key management, OS Login automatically handles user account lifecycle, authorization, and integration with two-step verification. This session covers the benefits, setup, IAM roles, connectivity methods, and practical demonstrations for enabling and using OS Login in a secure manner.

## Key Concepts/Deep Dive

### Introduction to OS Login
OS Login enables centralized SSH access management for Linux VMs in Google Cloud. It ties user accounts to Google identities, maintaining a consistent Linux username across all project or organization VMs. Key benefits include:

- **Automatic Linux Account Lifecycle Management**: User accounts are created, updated, or removed based on IAM permissions without manual intervention.
- **Fine-Grained Authorization via IAM**: SSH access is controlled using IAM roles, allowing project-level or instance-level permissions without granting broader privileges.
- **Secure Key Management**: Eliminates the need to manage SSH keys manually; connections are authorized through Google Cloud credentials.
- **Integration Features**: Supports two-factor authentication (2FA), import of existing Linux accounts, and connectivity via Cloud Shell or third-party tools.

OS Login ensures that accessing a VM requires appropriate IAM roles, reducing security risks associated with key distribution.

### IAM Roles and Permissions
OS Login uses specific IAM roles to control access levels:

| Role | Description | Scope |
|------|-------------|-------|
| `roles/compute.osLogin` | Grants non-privileged SSH access to VMs (e.g., read-only or basic commands). | Project/Instance |
| `roles/compute.osAdminLogin` | Grants elevated SSH access (e.g., sudo/root access). | Project/Instance |
| `roles/compute.osLoginExternalUser` | Allows external users from other organizations to SSH into VMs. | Organization |

Users must also have `roles/iap.tunnelResourceAccessor` for IAP-based connections and `roles/compute.instanceServiceAccountUser` if the VM uses a service account.

### Enabling OS Login
OS Login can be enabled per VM or project using metadata:

- **Project-Level**: Set metadata key `enable-oslogin` to `true` in Compute Engine settings. This applies to all VMs in the project.
- **VM-Level**: Override project settings by setting `enable-oslogin` to `false` on specific instances.
- **Two-Factor Authentication**: Enable with `enable-oslogin-2fa` for added security.

> [!WARNING]
> Enabling OS Login deletes existing SSH keys from VM authorized_keys files. Existing SSH sessions may drop; ensure IAM roles are configured first.

To enable project-level OS Login via gcloud:

```bash
gcloud compute project-info set-metadata --metadata enable-oslogin=true
```

### Connectivity Methods
- **Cloud Console IAP Tunnel**: Requires IAP roles; uses Google identity for authentication.
- **Cloud Shell**: Generates temporary SSH keys for connections; supports multiple VMs with the same key pair.
- **Third-Party Clients (e.g., PuTTY, OpenSSH)**: Users generate SSH key pairs and associate public keys with their Google account. Command example:
  ```bash
  ssh-keygen -t rsa -f ~/.ssh/os-login-key
  gcloud compute os-login ssh-keys add --key-file ~/.ssh/os-login-key.pub --project my-project
  ```
  Then connect with:
  ```bash
  ssh -i ~/.ssh/os-login-key [USERNAME]@[VM_EXTERNAL_IP]
  ```

### External Users
To allow users from other organizations:
1. Assign `roles/compute.osLoginExternalUser` at the organization level.
2. Disable `Domain Restricted Sharing` policy:
   - Navigate to Organization Policies > Restrict Resource Service Usage.
   - Allow all or specific domains.

External users get usernames prefixed with domain mappings (e.g., external_user_domain_cloud).

### Limitations
- Does not support GKE private clusters, Google Kubernetes Engine nodes, Windows Server VMs, or certain legacy OS versions.
- Username length limits may truncate long email addresses.
- Existing SSH keys in metadata are ignored when OS Login is enabled.

## Lab Demos

### Enabling OS Login Project-Level
1. Go to Compute Engine > Metadata > Add metadata.
2. Key: `enable-oslogin`, Value: `true`.
3. Save changes.
   - This enables OS Login for all VMs in the project.

### Granting IAM Roles
1. Navigate to IAM & Admin > IAM.
2. Select user, click Add another role.
3. Assign: `roles/compute.osLogin`, `roles/iap.tunnelResourceAccessor`, `roles/compute.instanceServiceAccountUser`.
4. For admin access, add `roles/compute.osAdminLogin`.

### Connecting via Cloud Console
1. In Cloud Console, go to Compute Engine > VM instances.
2. Click SSH on a VM.
3. If OS Login is enabled, it authenticates via Google identity without keys.

### Connecting via Cloud Shell
1. Open Cloud Shell.
2. Run: `gcloud compute ssh [VM_NAME] --zone [ZONE]`.
3. It generates temporary keys for the connection.

### External User Demo
1. Grant `roles/compute.osLoginExternalUser` at organization level.
2. Disable domain sharing restrictions.
3. External user accesses VMs if assigned project-level roles.

## Summary

### Key Takeaways

```diff
+ OS Login centralizes SSH access using IAM, eliminating manual key management.
+ Enables consistent user identities and fine-grained permissions across VMs.
+ Supports secure connections via various clients, including 2FA integration.
+ External users require organization-level roles for cross-domain access.
- Existing SSH sessions drop when enabling OS Login; configure IAM first.
- Not compatible with all VM types (e.g., Windows, certain GKE configurations).
! Be cautious with domain sharing policies for external user access.
```

### Quick Reference

- **Enable Project OS Login**: Set metadata `enable-oslogin=true`.
- **Assign Basic Access**: `roles/compute.osLogin`.
- **Assign Admin Access**: `roles/compute.osAdminLogin`.
- **Add SSH Key via gcloud**:
  ```bash
  gcloud compute os-login ssh-keys add --key-file ~/.ssh/os-login-key.pub --project [PROJECT]
  ```
- **Connect via SSH**: `ssh -i ~/.ssh/os-login-key [USERNAME]@[VM_IP]`.

### Expert Insight

**Real-world Application**: In enterprise environments, OS Login integrates with Active Directory or Google Workspace for seamless, auditable SSH access to cloud infrastructure, reducing security overhead in hybrid cloud setups.

**Expert Path**: Master IAM policies, audit logs, and automation scripts for provisioning OS Login-enabled VMs. Experiment with custom roles for specialized access and explore Directory API for programmatic key management.

**Common Pitfalls**: Forgetting IAP tunnel roles causes connection failures; sharing private keys bypasses individual accountability—use Directory API for managed credentials instead. Username conflicts may occur with existing accounts; back up home directories before enabling OS Login globally.

</details>
