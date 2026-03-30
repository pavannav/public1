# Session 15: OS Login Part 2, Sole Tenant Concept, VM Lifecycle, Custom Images, and Snapshots

## Table of Contents
- [OS Login Continuation: Two-Factor Authentication and Service Accounts](#os-login-continuation-two-factor-authentication-and-service-accounts)
- [OS Login: Group and User Scenarios](#os-login-group-and-user-scenarios)
- [OS Login: Service Account SSH Access](#os-login-service-account-ssh-access)
- [OS Login: Custom Roles for Minimal Permissions](#os-login-custom-roles-for-minimal-permissions)
- [Sole Tenant Concept Overview](#sole-tenant-concept-overview)
- [Multi-Tenant vs. Sole Tenant](#multi-tenant-vs-sole-tenant)
- [Sole Tenant Use Cases and Creation](#sole-tenant-use-cases-and-creation)
- [Sole Tenant Pricing and Comparison](#sole-tenant-pricing-and-comparison)
- [VM Lifecycle: Provisioning and Staging](#vm-lifecycle-provisioning-and-staging)
- [VM Lifecycle: Running State Operations](#vm-lifecycle-running-state-operations)
- [VM Lifecycle: Suspending and Terminating](#vm-lifecycle-suspending-and-terminating)
- [VM Lifecycle: Suspend vs. Terminate](#vm-lifecycle-suspend-vs-terminate)
- [VM Lifecycle: Instance Schedules](#vm-lifecycle-instance-schedules)
- [VM Lifecycle: Reset and Serial Console](#vm-lifecycle-reset-and-serial-console)
- [Custom Images vs. Snapshots](#custom-images-vs-snapshots)

## OS Login Continuation: Two-Factor Authentication and Service Accounts
### Overview
This section continues the exploration of OS Login, focusing on two-factor authentication (2FA) scenarios involving human users and service accounts. OS Login provides a secure way to manage SSH access to virtual machines (VMs) without traditional SSH keys, relying on user identities and optional 2FA. Human users enroll phone numbers or accounts for 2FA prompts, while service accounts automatically suppress 2FA due to their programmatic nature.

### Key Concepts
- **Two-Factor Authentication for Humans**: Enabled at the project or VM level via metadata. Requires users to enroll a phone number or Google account for authentication. If unenrolled, access fails with errors in command-line or UI attempts.
- **Service Accounts in OS Login**: Service accounts log in without 2FA prompts. They function like users, generating unique IDs but without human attributes like phone numbers.
- **Authentication Flow Differences**: Humans use identity-aware prompts (enrolling phone required); service accounts bypass 2FA entirely.

Enable via metadata:
```
enable-os-login: TRUE
enable-os-login-2fa: TRUE
```
Or via UI by checking "Turn on OS Login" and "Enable two-step verification."

### Group and User Scenarios
In group-based access, only users with enrolled phone numbers succeed in 2FA; others fail.
- Table of User Authentication Outcomes:

| User Type | Phone Enrolled? | Outcome |
|-----------|-----------------|---------|
| User 1 | Yes (e.g., +91...) | Success with 2FA prompt |
| User 2 | Yes (Indian number) | Success with 2FA prompt |
| User 3 (Simple GCP user) | No | Failure with obscure error (no SSH tunneling hints) |

> [!NOTE]
> Command-line errors for unenrolled users do not provide clear troubleshooting info; verify phone enrollment first.

## OS Login: Service Account SSH Access
### Overview
Service accounts can SSH into VMs when granted OS Login roles and act as other service accounts. This allows programmatic access without human intervention, with logs capturing the service account identity.

### Key Concepts
- **Role Requirements**:
  - Compute OS Login at project level.
  - Service Account User role at the target VM's service account.
- **Authentication Suppression**: 2FA is automatically disabled for service accounts.
- **Unique ID**: Service accounts display a unique ID (e.g., 614...\*) appended to username (sa-*unique-id*).
- **Logging**: Activity logs show service account actions, enabling audit trails.

### Lab Demos: Service Account SSH
Create and configure a service account for SSH access:

1. **Create Service Account**:
```
gcloud iam service-accounts create ssh-sa \
  --description="Service account for SSH" \
  --display-name="SSH SA"
```

2. **Generate Key**:
```
gcloud iam service-accounts keys create key.json \
  --iam-account=ssh-sa@project.iam.gserviceaccount.com
```

3. **Activate Service Account**:
```
gcloud auth activate-service-account --key-file=key.json
```

4. **Grant Roles**:
```
gcloud projects add-iam-policy-binding project \
  --member="serviceAccount:ssh-sa@project.iam.gserviceaccount.com" \
  --role="roles/compute.osLogin"

gcloud iam service-accounts add-iam-policy-binding gce-sa@project.iam.gserviceaccount.com \
  --member="serviceAccount:ssh-sa@project.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountUser"
```

5. **SSH via Service Account**:
```
gcloud compute ssh vm-name --zone=zone
```
Output shows username as `sa-<unique-id>`, no sudo access unless OS Admin Login granted.

## OS Login: Custom Roles for Minimal Permissions
### Overview
Standard OS Login roles provide broad access; custom roles limit to essentials for secure, least-privilege setup.

### Key Concepts
- Custom roles combine permissions like compute.instances.osLogin, iam.serviceAccounts.actAs, compute.instances.get for minimal access.
- Minimum Permissions:
  - compute.instances.osLogin: Enter VM.
  - iam.serviceAccounts.actAs: Impersonate other service accounts.
  - compute.instances.get: Fetch VM details.
  - compute.instances.start/stop (verb org removed, add permissions added): Handle start/stop.
- Benefits: Avoid broad roles like Compute OS Admin Login, reducing OS privileges.

### Lab Demos: Custom Role Creation
1. **Create Custom Role**:
```
gcloud iam roles create ssh-custom-role \
  --project=project \
  --file=role.yaml
```
Where `role.yaml` includes:
```yaml
title: "SSH Custom Role"
description: "Minimal permissions for SSH and service account acting"
stage: "GA"
includedPermissions:
  - compute.instances.get
  - compute.instances.osLogin
  - iam.serviceAccounts.actAs
  - compute.instances.list
  - compute.instances.start
  - compute.instances.stop
```

2. **Assign Custom Role** and test SSH.

## Sole Tenant Concept Overview
### Overview
Sole Tenant, also known as Single Tenant, allocates entire physical servers (nodes) to a single project for enhanced isolation, security, and compliance. Standard GCP VMs operate in multi-tenant environments where resources are shared.

### Key Concepts
- **Multi-Tenant**: Shared hardware (host) with multiple projects/VMs; hypervisor (KVM for GCP) ensures isolation.
- **Sole Tenant**: Dedicated server to one organization; high performance, compliance, licensing control.
- **Resources**: Matches node's max config (e.g., N1: 96 vCPU, 624 GB RAM at peak).

> [!IMPORTANT]
> Not all series support Sole Tenant (exclude E2, include N1/N2). Local SSD and GPUs attach at node level.

## Multi-Tenant vs. Sole Tenant
### Overview
Multitenant suits cost-effective, general workloads; Sole Tenant for regulated or high-isolation needs.

### Key Concepts
- **Multi-Tenant Pros/Cons**: Shared; potential noise/interference; cheaper.
- **Sole Tenant Pros/Cons**: Dedicated; secure; expensive; good for licensing (BYOL).

| Aspect | Multi-Tenant | Sole Tenant |
|--------|--------------|-------------|
| Cost | Lower | Higher (4559 USD/month N1 example) |
| Security | Shared hardware, dependent on hypervisor | Dedicated hardware, near-zero shared risk |
| Performance | Contention possible | Guaranteed resources |
| Licensing | Harder for volume licenses | Supports bring-your-own-license |
| Use Cases | General apps | Medical, financial compliance |

## Sole Tenant Use Cases and Creation
### Overview
Sole Tenant ideal for compliance (e.g., healthcare data), extra security, or software licensing. Create via node groups with templates defining server specs.

### Key Concepts
- **Node Types**: Templates specify series (e.g., N1), vCPU/RAM. Max configs: N1 high memory 96vCPU/624GB.
- **Node Affinity**: Labels (e.g., sector=medical) ensure VMs land on specific nodes.
- **Auto-scaling**: Optional; set min/max nodes (start at 1+ for demos).
- **Maintenance**: Migrate within group or follow VM settings.
- **Sharing**: Limit to project or org; default no sharing.

### Lab Demos: Creating Sole Tenant Node Group
1. **Create Node Template**:
```
gcloud compute sole-tenant node-templates create template-n1-highmem \
  --node-type=n1-highmem-96-624-ext
```

2. **Create Node Group**:
```
gcloud compute sole-tenant node-groups create group-n1 \
  --node-template=template-n1-highmem \
  --target-size=0
```

3. **Create VM on Node**:
   - Use UI: Select Sole Tenant group under "VM Provisioning" > "Advanced Options" > "Sole Tenant".
   - Or Affinity labels in VM creation.

Zone-specific; fails if zone mismatches (e.g., error: change to us-central1-a).

## Sole Tenant Pricing and Comparison
### Overview
Sole Tenant costs more due to dedicated hardware; compare with on-demand VMs for same specs.

### Key Concepts
- **Direct Sole Tenant**: ~4559 USD/month for N1 high memory (includes storage).
- **Indirect Sole Tenant**: Provision high-config VM (e.g., 96vCPU); GCP allocates dedicated node implicitly; costs ~4012 USD/month.
- **Savings**: ~500 USD/month switching indirect vs. direct Sole Tenant.
- **Multi-Tenant Baseline**: Cheaper than both.

GCP recommends on-demand high-config VMs for indirect Sole Tenant unless explicit needs (e.g., licensing).

> [!NOTE]
> Quota limits high-config VMs; request increases if needed.

## VM Lifecycle: Provisioning and Staging
### Overview
VM lifecycle spans states from creation to deletion, each handling specific setup. Provisioning allocates resources without IPs/disks; staging assigns IPs, OS, disks.

### Key Concepts
- **Provisioning**: Initial; no external IP, status "PROVISIONING".
- **Staging**: Network/OS setup; IPs assigned, status "STAGING".
- **Running**: Fully operational; status "RUNNING".

Tricks for visibility: Fast zones/regions; soul tenant demos for slower provisioning.

> [!IMPORTANT]
> Internal IP assigned in staging; external in staging (ephemeral or static).

## VM Lifecycle: Running State Operations
### Overview
From running state, VMs suspend (preserve state) or terminate (wipe memory). Suspend differs from terminate for state/memory handling.

### Key Concepts
- **Suspend**: Saves memory to storage (GB-cost); VM paused; CPUs not charged; max 60 days (auto-delete).
- **Terminate (Stop)**: Memory lost; storage persists; no extra charges.
- **Restart**: Go back to provisioning/staging/running.
- **Delete**: Removes VM; static IPs remain chargeable; storage optional keep/delete.

Operations:
- Suspend: `gcloud compute instances suspend vm-name`
- Terminate: `gcloud compute instances stop vm-name` (transitions to TERMINATED)
- Resume: `gcloud compute instances resume vm-name` (for suspended)
//Resume after suspend; start after stop.

## VM Lifecycle: Suspending and Terminating
### Overview
Suspend hibernates VM to disk (~17 cents/GB/month); terminate ends process. Both save costs but differently.

### Key Concepts
- **Suspend Pros**: Preserve exact state (open apps/tabs); resume in seconds.
- **Terminate Pros**: Cheaper; restart fresh (uptime resets).
- **Costs**:
  - Suspended: Storage for memory + static IP.
  - Terminated: Only static IP + persistent disks.
- **Resume vs. Start**: Resume for suspended; start for terminated.

### Lab Demos: Suspend/Terminate
1. **Suspend VM**:
```
gcloud compute instances suspend vm-name --zone=zone
```
   - Status to "SUSPENDED"; uptime increases on resume.

2. **Terminate VM**:
```
gcloud compute instances stop vm-name --zone=zone
```
   - Status to "TERMINATED"; uptime resets.

Resume/Start: `resume` or `start` commands.

## VM Lifecycle: Suspend vs. Terminate
### Overview
Suspend preserves state/memory (e.g., running apps); terminate wipes memory but retains disks.

### Key Concepts
- **Suspend**: Hiber sleep; memory to disk; charged for memory storage; resume continues.
- **Terminate**: Power off; memory gone; charged only for static IPs/disks; restart fresh.
- **Windows/Linux Example**: Suspend keeps browser tabs; terminate loses (requires save/close).

> [!NOTE]
> IP retention: Suspended loses ephemeral IPs; terminated loses ephemeral but retains static.

## VM Lifecycle: Instance Schedules
### Overview
Automate start/stop via Instance Schedules for cost optimization (e.g., business-hours-only access).

### Key Concepts
- **Schedule Creation**: Regional; support daily/weekly; start/end times (e.g., start 9:00, stop 17:00).
- **Permissions**: Requires custom role with compute.instances.start/stop on service account.
- **Use Cases**: Dev environments (e.g., Mexico developer usage); avoids manual scripts.
- **Features**: Not UI-based; matches external-to-GCP schedules.

### Lab Demos: Instance Schedule
1. **Create Schedule**:
```
gcloud compute instances create-schedule schedule-name \
  --region=region \
  --start-time=09:00 \
  --stop-time=17:00 \
  --schedule-type=daily
```

2. **Assign to VM**:
Add service account role to schedule's IAM or attach to VM groups.

Monitor via logs (service account actions logged).

## VM Lifecycle: Reset and Serial Console
### Overview
Reset reboots VM without full termination, applying metadata changes (e.g., startup scripts). Serial console shows boot logs for troubleshooting.

### Key Concepts
- **Reset**: Hard reboot; risks file corruption; preserves disks/IPs; no state wipe like terminate.
- **Serial Console**: Real-time boot; enables for debugging (metadata changes, network issues).
- **Use Cases**: Apply new startup scripts without SSH (e.g., install Git/Nginx).
- **Difference from Reboot**: Requires reboot access; reset works without login.

> [!WARNING]
> Reset can corrupt disks; use cautiously. For code corruption, restore from snapshots.

### Lab Demos: Reset and Script Application
1. **Update Metadata**:
   - Add startup script: `sudo apt-get update && sudo apt-get install -y git nginx`

2. **Reset VM**:
```
gcloud compute instances reset vm-name --zone=zone
```

3. **Verify**: SSH; check uptime (~1 min); verify installs (e.g., `git --version`).

Serial console: Enable "Connect to serial port"; logs install process during reset/boot.

## Custom Images vs. Snapshots
### Overview
Images capture full OS/applications for creating new VMs; snapshots back up incremental changes for restoration.

### Key Concepts
- **Images**: Static bundles (OS, software); for new VMs or golden copies.
  - Types: Public (Ubuntu), custom (user-made with add-ons).
  - Use for identical setups; includes licensing costs.
- **Snapshots**: Incremental backups of disks; compress deltas; free tier available.
  - Use for point-in-time recovery (e.g., post-patch corruption).

| Feature | Images | Snapshots |
|---------|--------|-----------|
| Purpose | New VM creation | Existing VM restore |
| Scope | Full disk/application | Changes since last snap |
| Cost | Based on OS (free/premium) | Low (compressed deltas) |
| Example | Ubuntu ISO golden copy | Daily backup of running VM |

### Lab Demos: Create Custom Image
1. **From Disk**:
```
gcloud compute images create my-custom-image --source-disk=disk-name --source-disk-zone=zone
```

2. **Create VM from Image**: Select in boot disk options.

Snapshots: `gcloud compute disks snapshot disk-name --snapshot-names=my-snapshot`.

> [!NOTE]
> For corruption recovery, delete failing VM, recreate from snapshot.

## Summary
### Key Takeaways
```diff
+ OS Login secures SSH via identities; enable 2FA for humans, auto-suppress for service accounts.
+ Sole Tenant dedicates nodes for compliance; indirect via high-config VMs cheaper.
+ VM states: provisioning (allocating), staging (IP/OS), running (active), suspended (paused with state), terminated (stopped).
+ Lifecycle ops: suspend preserves state/memory; terminate wipes memory.
+ Instance schedules automate cost; reset applies changes without login.
+ Images for new VMs; snapshots for backups/restoration.
- Avoid unenrolled users in 2FA groups; errors unclear.
- Sole Tenant quota limits; request increases.
- Reset risks corruption; prefer reboots if possible.
- Delete VMs promptly; charges for idle/suspended beyond 60 days.
- Don't overuse custom roles; balance security with simplicity.
```

### Expert Insight
- **Real-world Application**: Use OS Login for compliant SSH in regulated environments (e.g., HIPAA); Sole Tenant for financial firms' dedicated hardware; snapshots for critical prod VMs' weekly backups.
- **Expert Path**: Master IAM policies for OS Login; practice node group affinity; automate schedules with Terraform/Ansible; explore snapshot chains for incremental recovery.
- **Common Pitfalls**: 
  - Mismatched zones in Sole Tenant fail creations; always verify regions.
  - Forgotten static IPs on deleted VMs incur costs; clean up.
  - Phone enrollment issues in UI; verify via Gmail account settings.
  - File corruption after reset; mitigate with snapshots; avoid on prod without tests.
  - Lesser known: Sole Tenant auto-quota bypasses quotas sometimes; monitor carefully.
  - Service account unique IDs are project-specific; collisions rare but possible across orgs.
