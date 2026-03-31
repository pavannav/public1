# Session 087: OS Login GCP

## Table of Contents
- [Introduction to OS Login in Google Cloud](#introduction-to-os-login-in-google-cloud)
  - [Overview](#overview)
  - [Benefits](#benefits)
  - [IAM Roles for OS Login](#iam-roles-for-os-login)
  - [Enabling OS Login](#enabling-os-login)
  - [Connecting from Third-Party Tools](#connecting-from-third-party-tools)
  - [Limitations](#limitations)
- [Lab Demo: Implementing OS Login](#lab-demo-implementing-os-login)
- [Summary](#summary)

## Introduction to OS Login in Google Cloud

### Overview
OS Login in Google Cloud provides a centralized authentication mechanism for managing SSH access to Linux virtual machines (VMs) without relying on traditional SSH keys stored in instance metadata. Instead, it leverages Google Cloud Identity and Access Management (IAM) roles to control access, ensuring consistent user identities across VMs. This approach enhances security by eliminating the need for manual key management and enabling fine-grained authorization at the user or organization level. Users authenticate using their Google accounts, and access is tied directly to IAM permissions, reducing the risk of unauthorized access while simplifying administration for large-scale environments.

### Benefits
OS Login offers several advantages for managing cloud infrastructure:

- **Automatic Linux Account Lifecycle Management**: User accounts are automatically created and managed based on IAM identities, eliminating manual provisioning and deprovisioning.
- **Fine-Grained Authorization Using IAM**: IAM roles allow precise control over who can access VMs and what actions they can perform, such as root-level commands.
- **Automatic Permission Updates**: Changes to IAM roles are instantly reflected in access permissions without requiring manual key distribution.
- **Import Existing Linux Accounts**: Existing accounts from systems like Active Directory or LDAP can be integrated.
- **Integration with Two-Step Verification**: Enforce additional security through Google's two-factor authentication for VM logins.

### IAM Roles for OS Login
OS Login utilizes specific IAM roles to define access levels:

| Role | Description |
|------|-------------|
| `compute.osLogin` | Grants basic access to log in as a non-administrator user on Compute Engine instances. |
| `compute.osAdminLogin` | Grants administrator (root) access, allowing privileged operations. |
| `roles/iam.serviceAccountUser` | Required if the VM uses a service account for authentication or operations. |
| `compute.osLoginExternalUser` | Allows users from external organizations to access VMs, managed at the organization level. |

These roles enable differentiated access, ensuring users can only perform actions permitted by their IAM assignments.

### Enabling OS Login
OS Login can be enabled at the project level or per instance via metadata:

- **Project-Level**: Set metadata `enable-oslogin` to `true` in the project's metadata page. This applies to all VMs in the project.
- **Instance-Level**: Add instance metadata `enable-oslogin=true` for specific VMs.

> [!WARNING]  
> Enabling OS Login deletes existing `authorized_keys` files in VMs and rejects connections using SSH keys stored in project or instance metadata. Existing connections may drop, so verify before activation.

To enable at the organization level, use organization policies to enforce OS Login across projects.

### Connecting from Third-Party Tools
Users can associate SSH public keys with their Google account to connect from external tools like PuTTY or OpenSSH:

1. Generate an SSH key pair locally: `ssh-keygen -t rsa`.
2. Associate the public key with your Google account via Cloud SDK:  
   ```bash
   gcloud compute os-login ssh-keys add --key-file=~/path/to/id_rsa.pub --project=my-project
   ```
3. Connect using the username returned by the command (e.g., `username@vm-external-ip`) with your private key.

This method integrates with Google identities, ensuring only authorized users can connect.

### Limitations
OS Login does not support certain VM types or environments, including:
- GKE public clusters
- Private clusters
- Windows Server instances
- SUSE or Fedora CoreOS distributions

For unsupported instances, refer to traditional SSH key management or alternative authentication methods.

## Lab Demo: Implementing OS Login

### Step 1: Enable OS Login at Project Level
1. Navigate to Google Cloud Console > Compute Engine > Settings > Metadata.
2. Click **Add item**.
3. Key: `enable-oslogin`, Value: `true`.
4. Save changes. This enables OS Login for all VMs in the project.

### Step 2: Assign IAM Roles to Users
1. Go to IAM & Admin > IAM.
2. Select the user and add the following roles as needed:
   - `compute.osLogin` for basic access.
   - `compute.osAdminLogin` for sudo privileges.
   - `roles/iap.tunnelResourceAccessor` or `roles/iap.securesTunnellingUser` for IAP-based connections.
   - `roles/iam.serviceAccountUser` if VMs use service accounts.
3. Save assignments. Permissions update automatically.

### Step 3: Connect via Google Cloud Console
1. Select a VM and click **SSH**.
2. If roles are assigned, connect directly. Without OS Login roles, authentication fails.
3. For admin access, ensure `compute.osAdminLogin`; test with `sudo su` to elevate privileges.

### Step 4: Connect via Cloud Shell
1. Run: `gcloud compute ssh vm-name --zone=zone --tunnel-through-iap`.
2. Cloud Shell generates ephemeral SSH keys (not stored) and connects using your account credentials.

### Step 5: Connect from External Tools
1. Generate SSH key: `ssh-keygen -t rsa -f oslogin_key`.
2. Associate key: `gcloud compute os-login ssh-keys add --key-file=oslogin_key.pub --project=my-project`.
3. From local machine: `ssh -i oslogin_key [username]@[vm-ip]`.
4. Update firewall to allow your public IP: Add rule with source IP and protocol 22.

### Step 6: Disable OS Login for Specific Instances
1. On the VM, edit instance metadata.
2. Add: Key: `enable-oslogin`, Value: `false`.
3. Save. This overrides project-level settings.

### Step 7: Integrate External Organization Users
1. Disable organization policy restricting domain sharing.
2. Grant `compute.osLoginExternalUser` at the organization level.
3. Assign required roles (e.g., viewer, IAP tunnel user, service account user) at project level.
4. External user connects via IAP or direct SSH after key association.

Monitor connections and ensure firewall rules restrict access appropriately.

## Summary

### Key Takeaways
```diff
+ OS Login centralizes SSH access management using IAM roles, eliminating manual key handling.
- Avoid enabling OS Login without checking existing SSH keys, as authorized_keys files are deleted.
! Fine-grained permissions via IAM allow controlled access without broader privileges.
+ Integration with Google identities ensures consistent Linux usernames across VMs.
- Unsupported for certain VM types (e.g., Windows, GKE private clusters); use alternative methods.
```

### Expert Insight

**Real-world Application**:  
OS Login excels in enterprise environments with hundreds of VMs, ensuring auditors can tie access logs to individual Google accounts. Use it for regulated industries requiring traceable authentication, integrating with two-factor verification for enhanced compliance.

**Expert Path**:  
Master IAM role hierarchies and organization policies for multi-project setups. Experiment with OS Login API for programmatic key management. Dive into GCE identity-based CLI tools and correlate OS Login with audit logs via Cloud Logging for advanced monitoring.

**Common Pitfalls**:  
- **Overlooking Role Dependencies**: Forgetting to assign `roles/iam.serviceAccountUser` causes authentication failures. *Resolution*: Always check attached service accounts and add the role; test connections post-assignment. *Avoidance*: Use IAM recommender tools to simulate policy changes before applying.  
- **Ignoring Username Normalization**: OS Login converts dots and hyphens in emails to underscores, potentially creating duplicate accounts violating the 32-character limit. *Resolution*: Manually clean up old accounts if enabling midway; use Directory API to manage custom usernames. *Avoidance*: Plan migrations carefully; document username mappings to prevent data loss.  
- **Firewall Misconfigurations**: External connections fail if public IPs aren't whitelisted. *Resolution*: Add IAP tunnel roles or update firewall rules dynamically. *Avoidance*: Implement baseline security groups and monitor with VPC firewalls.  
- **Policy Conflicts**: Organization-level enforcement prevents instance overrides. *Resolution*: Review constraints in Org Policies before enforcement. *Avoidance*: Test in staging projects and communicate changes organization-wide.  
- **Ephemeral Key Risks**: Cloud Shell keys aren't persistent; termination breaks connections. *Resolution*: Associate user-specific keys for reliability. *Avoidance*: Use bastion hosts with persistent key associations.  

**Lesser Known Things**:  
- OS Login supports POSIX attributes (UID, GID) imported from external directories, allowing seamless integration without recreating user configurations.  
- For air-gapped environments, OS Login respects Compute Engine's service perimeters, ensuring access logs are retained even without internet connectivity.  
- Automatic home directory creation includes SSH configs, which can be customized via metadata overrides for advanced use cases.  

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
