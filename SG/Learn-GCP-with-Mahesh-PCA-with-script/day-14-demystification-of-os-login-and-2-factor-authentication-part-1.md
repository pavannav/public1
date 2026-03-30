# Session 14: Demystification of OS Login and 2 Factor Authentication - Part 1

## Table of Contents
- [Overview](#overview)
- [Spot VM Behavior and Preemption](#spot-vm-behavior-and-preemption)
- [SSH Key Management Challenges](#ssh-key-management-challenges)
- [Project-Level SSH Keys for Contractor Access](#project-level-ssh-keys-for-contractor-access)
- [Blocking Project-Wide SSH Keys](#blocking-project-wide-ssh-keys)
- [GCloud SSH Command and Security Risks](#gcloud-ssh-command-and-security-risks)
- [IAM-Based Access Control](#iam-based-access-control)
- [OS Login Introduction](#os-login-introduction)
- [OS Login Permissions and Demos](#os-login-permissions-and-demos)
- [Two-Factor Authentication](#two-factor-authentication)
- [Service Account with OS Login](#service-account-with-os-login)
- [Summary](#summary)

## Overview
This session demystifies OS Login and two-factor authentication in Google Cloud Platform (GCP), focusing on secure alternatives to traditional SSH key management. It builds on previous SSH concepts by addressing scalability issues with VM access and introduces IAM-integrated authentication methods.

## Spot VM Behavior and Preemption
### Key Concepts
Spot VMs offer cost-effective compute resources but can be preempted by Google at any time. Preemption signals provide warnings, allowing graceful shutdowns.

- Preemptions vary: some VMs run for days uninterrupted, while others face multiple preempt signals before shutdown.
- Logs reveal preemption patterns; check `compute.googleapis.com/v1/operations` for details.
- Not all preempt signals result in immediate termination—sometimes they fail, allowing extended runtime.

> [!IMPORTANT]  
> Always monitor Spot VM logs and implement fault-tolerant applications.

### Code/Config Block
```bash
# Check Spot VM logs in Cloud Logging
gcloud logging read "resource.type=gce_instance" --limit=10 --filter="labels.spot=true"
```

## SSH Key Management Challenges
### Key Concepts
Traditional SSH key sharing for contractor access creates security risks:
- Passwordless access via shared private keys lacks auditability.
- Tracking user actions is difficult without IAM integration.
- Scalability issues: adding keys manually to multiple VMs is inefficient.

> [!NOTE]  
> For single-VM access, SSH keys may suffice, but for multiple VMs, consider IAM-based alternatives.

### Lab Demos
- Created three VMs with external IPs for contractor testing.
- Demonstrated manual key addition to each VM's metadata, highlighting the pain for 5+ VMs.
- Comparison: static IPs enable easy access, but dynamic IPs complicate sharing.

```bash
# Range creation for multiple VMs
gcloud compute instances create vm-{1..3} --zone=us-central1-a --machine-type=e2-micro
```

## Project-Level SSH Keys for Contractor Access
### Deep Dive
Project-wide SSH keys propagate to all instances without owning SSH keys, enabling unified access for contractors.

- **Propagation Logic**: Keys inherit to VMs lacking their own keys.
- **Use Case**: Ideal for freelancers needing access across VMs without IAM changes.
- **Inheritance**: Managed via project metadata, not VM-specific.

### Key Concepts
- Contractors receive shared private key (e.g., via PPK) and public IP lists.
- Access persists until keys expire or are removed.
- Demo: Shared contractor PPK allowed login to all three VMs; pseudo group membership granted sudo rights.

### Code/Config Block
```bash
# Add project-level SSH key
gcloud compute project-info add-metadata --metadata=ssh-keys="contractor:$(cat contractor.pub)"
```

### Lab Demos
- Enabled project-wide keys: Contractor (from PPK) accessed all VMs, became sudo user, installed packages.
- Limitation: Trackability poor; no IAM logs for actions.

## Blocking Project-Wide SSH Keys
### Deep Dive
For sensitive VMs, block inheritance of project-level SSH keys while allowing specific overrides.

### Key Concepts
- **VM-Level Override**: Toggle "Block project-wide SSH keys" in VM settings.
- **Inheritance Behavior**: Blocked VMs ignore project keys but can have own keys.
- **Demo Result**: PPK failed on blocked VM (sensitive-vm2); worked on others.

### Code/Config Block
```bash
# Block via gcloud (if supported; else UI toggle)
gcloud compute instances add-metadata INSTANCE --metadata=block-project-ssh-keys=true
```

> [!WARNING]  
> ⚠ Blocking prevents unauthorized access via shared keys but requires careful key management per VM.

## GCloud SSH Command and Security Risks
### Key Concepts
- `gcloud compute ssh` generates keys on-the-fly and adds to VM metadata.
- **Risk**: Inadvertently adds keys to project level if run outside browser.
- **Browser vs. SDK**: Browser adds VM-level (temporary); SDK adds project-level (persistent).

### Lab Demos
- Browser SSH: Keys expired after ~4 minutes.
- SDK SSH: Keys added project-wide permanently—security loophole if account compromised.
- Demo: Reclaimed ownership access via orphaned project keys.

### Code/Config Block
```bash
# Command that risks project-level key addition
gcloud compute ssh INSTANCE --zone=ZONE
```

> [!DANGER]  
> Avoid `gcloud compute ssh` with privileged accounts; prefer browser or managed keys.

## IAM-Based Access Control
### Deep Dive
Uses custom IAM roles for granular SSH permissions instead of keys.

- **Required Permissions**: `compute.instances.list`, `compute.instances.get`, `compute.instances.setMetadata`.
- **Custom Role**: Enables SSH without sudo rights.
- **Trackability**: Logs capture SSH access via IAM principal.

### Lab Demos
- Created custom role with four permissions: VM access without sudo.
- Granted to user; tracked via IAM logs (e.g., `setMetadata` events).
- For VMs with service accounts, added `iam.serviceAccountUser` role.

### Code/Config Block
```bash
# Custom IAM role YAML
title: SSH Access
permissions:
  - compute.instances.list
  - compute.instances.get
  - compute.instances.setMetadata
  - iam.serviceAccountUser
```

## OS Login Introduction
### Key Concepts
OS Login provides IAM-integrated SSH via Google accounts or service accounts, eliminating key management.

- **Benefits**: Consistent identity, automatic audits, sudo control, no manual keys.
- **Supported**: Linux VMs; Windows not supported.
- **Setup**: Enable via VM metadata (`enable-oslogin=true`) or project/org policies.

### Deep Dive
- **Components**: PAM modules, NSS overrides for user management.
- **Permissions**:
  - `roles/compute.osLogin`: Non-admin access.
  - `roles/compute.osAdminLogin`: Admin (sudo) access.
- **Evidence**: No `.ssh/authorized_keys` file; managed internally.

### Code/Config Block
```bash
# Enable OS Login on VM
gcloud compute instances add-metadata INSTANCE --metadata=enable-oslogin=true
# Project-level enable
gcloud compute project-info add-metadata --metadata=enable-oslogin=TRUE
```

> [!IMPORTANT]  
> OS Login replaces SSH keys with IAM; enforce via org policy for consistency.

## OS Login Permissions and Demos
### Key Concepts
- **User Mapping**: Google email becomes Linux user (e.g., `user@[domain]_com`).
- **Sudo Control**: `osAdminLogin` role enables sudo; denied without it.
- **Inheritance**: Project policies dictate defaults.

### Lab Demos
- Owner SSH (sudo enabled); user without `osAdminLogin` denied sudo.
- Query metadata server for keys:
  ```bash
  curl -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/oslogin/authorize?project=VMS_PROJECT
  ```
- Returned JSON shows SSH keys, expiration (none if persistent).

### Code/Config Block
```bash
# Grant OS Login role
gcloud projects add-iam-policy-binding PROJECT --member=user:EMAIL --role=roles/compute.osLogin
```

### Tables
| Permission | Role | Access Level |
|------------|------|--------------|
| Compute OS Login | Allows SSH | Non-admin |
| Compute OS Admin Login | Allows SSH + sudo | Admin |

## Two-Factor Authentication
### Key Concepts
OS Login supports 2FA via registered devices (phone authenticator, SMS, Google prompt).

- **Setup**: Add `enable-oslogin-2fa=true` to metadata.
- **Flow**: After username/password, prompt sent to registered device.
- **Overrides**: Service accounts bypass 2FA; humans require it if enrolled.

### Lab Demos
- Enabled 2FA; owner prompted on Google app.
- User without device registration fails.
- Project-level 2FA inherits to VMs.

### Code/Config Block
```bash
# Enable 2FA
gcloud compute project-info add-metadata --metadata=enable-oslogin-2fa=TRUE
```

> [!NOTE]  
> Enroll devices at https://myaccount.google.com for seamless 2FA.

## Service Account with OS Login
### Key Concepts
Service accounts can use OS Login without 2FA prompts if granted IAM roles.

- **Permission**: Service account acts as itself (e.g., for GCS access).
- **No Human Intervention**: Bypasses 2FA since no device association.

### Lab Demos
- Granted service account `osLogin` role; SSH auto-succeeds.
- Demonstrated privilege escalation via service account (e.g., bucket creation tracked).

### Code/Config Block
```bash
# Bind OS Login to service account
gcloud iam service-accounts add-iam-policy-binding SERVICE_ACCOUNT --member=user:USER --role=roles/iam.serviceAccountUser
```

## Summary

### Key Takeaways
```diff
! Demystify OS Login as IAM-integrated SSH without manual key management
+ Use project/org policies to enforce OS Login for consistent security
- Avoid sharing SSH keys; prefer IAM roles for trackability
! Browser SSH (temporary) vs. SDK (persistent) key behavior
+ OS Admin Login provides sudo control; OS Login enables access only
- Blocking project keys prevents inheritance but requires per-VM keys
! Enable 2FA for human users; service accounts bypass it
+ Metadata server reveals hidden SSH keys despite OS Login abstraction
- GCP logging (e.g., setMetadata) improves auditability over key-based access
```

### Expert Insight
#### Real-world Application
In enterprise environments, enforce OS Login via org policies for hundreds of VMs. Use it for contractor onboarding: grant temporary IAM roles (e.g., via time-restricted policies) instead of sharing keys. Integrate with Active Directory for seamless identity mapping in hybrid clouds, ensuring consistent access across on-premises and GCP Linux servers.

#### Expert Path
Master IAM policies, custom roles, and PAM modules for OS Login. Explore integration with Identity-Aware Proxy (IAP) for browser-less access. Deep-dive into Cloud Audit Logs for forensic analysis. Participate in GCP security assessments, focusing on minimizing attack surfaces by eliminating SSH keys.

#### Common Pitfalls
- Over-relying on SSH keys leads to theft and untracked access—mitigate by denying browser SSH and implementing OS Login.
- Forgetting to block project keys on sensitive VMs allows inheritance of shared keys.
- Assuming Windows support: OS Login is Linux-only, prompting fallbacks to RDP.
- Not enrolling devices: Users get locked out during 2FA enforcement.
- Misusing `gcloud compute ssh`: Leads to permanent project-level keys—ban via org policy.
- Tracking history erasure: Although challenging, malicious actors can obscure logs; design fail-safe backups.

Nick: "ript" corrected to "transcript" boundary, "loging" to "logging", "proamps" to "preempts". No "htp" or "cubectl" instances.
