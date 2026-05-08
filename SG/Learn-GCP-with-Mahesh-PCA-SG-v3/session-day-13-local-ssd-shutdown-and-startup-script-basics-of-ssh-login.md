# Session 13: Local SSD Shutdown and Startup Script, Basics of SSH Login

## Table of Contents
- [Overview](#overview)
- [Local SSD Concepts and Interfaces](#local-ssd-concepts-and-interfaces)
- [Creating a VM with Local SSD](#creating-a-vm-with-local-ssd)
- [Data Persistence in Local SSD](#data-persistence-in-local-ssd)
- [Mounting and Formatting Local SSD](#mounting-and-formatting-local-ssd)
- [Testing Data Retention](#testing-data-retention)
- [Automating Data Persistence with Scripts](#automating-data-persistence-with-scripts)
- [Shutdown Scripts for Backup](#shutdown-scripts-for-backup)
- [SSH Key Management](#ssh-key-management)
- [Manual SSH Key Generation and Sharing](#manual-ssh-key-generation-and-sharing)
- [Drawbacks of Manual SSH Key Sharing](#drawbacks-of-manual-ssh-key-sharing)
- [Introduction to OS Login](#introduction-to-os-login)

## Overview
This session covers Local Solid State Drives (SSDs) in Google Cloud Platform (GCP), focusing on their attachment, data persistence, mounting, and script-based management for backup and restoration. It explores the differences between reboot and termination scenarios, interfaces like SCSI and NVMe, and their performance implications. Additionally, it delves into SSH key management, including expiration, manual generation, access sharing, and the superiority of OS Login as a more secure alternative.

## Local SSD Concepts and Interfaces

### Local SSD Overview
Local SSDs are physically attached to the host machine and provide superior I/O operations per second (IOPS) with low latency compared to network-attached persistent disks. They are ideal for workloads requiring high performance, such as caching, transient data processing, or analytics. However, they are designed for temporary storage and do not guarantee data persistence across VM terminations.

- **Use Cases**: Scratch storage for low-value or transient data, processing in-memory analytics, temporary caches.
- **Limitations**: Data loss on termination, fixed size from 375GB to 9TB (up to 24 disks), best for compute series like N1, N2 with specific vCPU requirements.

### Interfaces: SCSI vs NVMe
Google Cloud offers two interfaces for Local SSDs:

| Interface | Read IOPS (max) | Write IOPS (max) | Recommended? | Notes |
|-----------|-----------------|-------------------|--------------|-------|
| SCSI (Small Computer System Interface) | 170K | 90K | No | Older, slower; backward-compatible but not optimal |
| NVMe (Non-Volatile Memory Express) | 170K-300K (varies) | 90K-200K (varies) | Yes | Faster, preferred for high-performance workloads |

> [!NOTE]
> Choose NVMe for best performance. Support depends on OS versions; Ubuntu LTS (22.04+) supports NVMe, while older versions may not.

### Key Takeaways on Local SSD
- Non-replicated, suitable for temporary data only.
- Always encrypted at rest (customer-managed or Google-managed keys).
- Cannot take snapshots, images, or clones.
- Data may be lost if VM stops abnormally.

## Creating a VM with Local SSD

When provisioning a VM with Local SSD:
- Supported series: N1, N2, C2, etc., with minimum 2-4 vCPUs.
- Attach during creation (post-creation addition is impossible).
- Configuration options in disk section: Select Local SSD, choose interface (NVMe preferred), and set count (1-24).

Example gcloud command:
```bash
gcloud compute instances create my-vm \
  --machine-type=n2-standard-4 \
  --local-ssd=interface=NVME \
  --zone=us-central1-a
```

> [!WARNING]
> Local SSDs are not attached separately like persistent disks; they form part of VM creation.

## Data Persistence in Local SSD

### Scenarios and Persistence
Compute Engine provides data persistence in specific cases:

| Action | Data Persisted? | Reason/Notes |
|--------|-----------------|--------------|
| VM Reboot (OS or forced) | Yes | Same host allocation |
| Live Migration on Host Maintenance | Yes | Migration to another host with SSD |
| Stop/Resume | Yes (preview feature) | Preview only; charges additional storage |
| Termination | No | Host resources released; new host allocation wipes data |
| Preemption | No | Spot/Preemptible VMs do not persist data |

> [!IMPORTANT]
> Always back up data to durable storage like GCS or persistent disks before termination. Use scripts for automation.

## Mounting and Formatting Local SSD

### Initial Setup
Local SSDs appear as raw devices post-VM creation. Must format and mount manually.

Check devices:
```bash
lsblk
```
Output shows NVMe devices (e.g., nvme0n1).

Format with ext4:
```bash
sudo mkfs.ext4 /dev/nvme0n1
```

Create mount point and mount:
```bash
sudo mkdir -p /mnt/local-ssd
sudo mount /dev/nvme0n1 /mnt/local-ssd
sudo chmod 777 /mnt/local-ssd
```

Verify:
```bash
df -h
```

> [!NOTE]
> By default, not formatted/mounted. Post-termination, re-allocation requires re-formatting.

## Testing Data Retention

### Reboot Scenario
- Data persists after OS reboot.
- Test by writing files, rebooting (`sudo reboot`), and remounting (if not automated).

### Termination Scenario
- Data lost; new allocation is raw.
- Terminate VM, start anew, observe loss.
- Persistent disks retain data via snapshots/clones, but not compatible.

> [!ALERT]
> `shutdown -h now` → Data lost.
In reboot: Data retained via host persistence.

## Automating Data Persistence with Scripts

### Startup Scripts
Run on VM boot to remount Local SSD automatically.
- Add as metadata: `--metadata startup-script="script-content"`
- Use gcloud for updates.

Mutually exclusive with startup-script-url.

### Example Startup Script
```bash
#!/bin/bash
mount /dev/nvme0n1 /mnt/local-ssd
chmod 777 /mnt/local-ssd
```

> [!TIP]
> Startup scripts run as root; no `sudo` needed.

## Shutdown Scripts for Backup

Trigger on VM shutdown/termination; copy data to GCS.

### Requirements
- VM service account with `roles/storage.objectCreator` on bucket.
- Script copies to bucket then bucket accessed post-deletion.

### Setup
Add shutdown script via metadata:
```bash
gcloud compute instances add-metadata INSTANCE --metadata shutdown-script="script-content" --zone=ZONE
```

Example shutdown script:
```bash
#!/bin/bash
gsutil cp -r /mnt/local-ssd/* gs://backup-bucket/
```

### Testing Backup
- Create data, terminate VM (via UI/CLI: `gcloud compute instances stop --discard-local-ssds=false INSTANCE`).
- Verify via GCS.

> [!WARNING]
> Preview feature; not GA. For production, prefer persistent disks.

## SSH Key Management

### Basics
GCP generates ECDSA/RSA keys for browser SSH; keys expire (4-5 minutes).

- Viewed: VM > SSH Keys or `/home/user/.ssh/authorized_keys`.
- Expires: Based on UTC timestamp.

Verify SSD type:
```bash
cat /sys/block/nvme0n1/queue/rotational  # 0 = SSD
```

### Manual Key Generation
Prefer Elliptic Curve Digital Signature Algorithm (ECDSA) over RSA.

- Generation: Use PuTTYgen (Windows) or OpenSSH.
- Format: Private (for user), Public (for authorized_keys).

Add to VM:
- VM > Edit > SSH Keys > Add public key.

## Manual SSH Key Generation and Sharing

### Generation Example (PuTTYgen)
1. Generate ECDSA key.
2. Public key: Add user@key (extracts username).
3. Private key: Save/base64 encode.

Share private key securely (e.g., GCS with IAM).

### Login Process
1. Download private key.
2. Set permissions: `chmod 600 key`.
3. SSH: `ssh -i key user@vm-ip`.

Demo: Shared key allowed multiple logins; `who` shows connections.

## Drawbacks of Manual SSH Key Sharing
- No expiration; high risk if shared.
- Root access by default; no 2FA.
- Tracking difficult (history not segregated).
- Ideal for single-user; avoid for teams.

Use Secrets Manager for secure key distribution.

## Introduction to OS Login

OS Login provides IAM-based SSH; no manual keys.

- Features: Automatic key management, metadata-based access, per-user permissions.
- Enables at project/VM level.
- Better security: IAM roles, 2FA support, auditability.

> [!IMPORTANT]
> Prefer OS Login for production; avoids manual key pitfalls.

## Summary

### Key Takeaways
> [!IMPORTANT]
> Local SSDs offer high performance but temporary storage; automate data persistence via scripts. SSH keys should expire; OS Login is superior for security.

### Quick Reference
**Commands:**
- Format Local SSD: `sudo mkfs.ext4 /dev/nvme0n1`
- Mount: `sudo mount /dev/nvme0n1 /mnt/local-ssd`
- Add Startup Script: `gcloud compute instances add-metadata INSTANCE --metadata startup-script="..." --zone=ZONE`
- Check SSD Type: `cat /sys/block/nvme0n1/queue/rotational`
- SSH with Key: `ssh -i private_key user@vm-ip`

**Interfaces Summary:**
```diff
+ NVMe: Preferred; higher IOPS (300K read)
- SCSI: Legacy; lower IOPS (170K read)
```

### Expert Insight
#### Real-world Application
In analytics workloads, attach Local SSD for intermediate results; automate backup to GCS on shutdown. Used in batch processing where data isn't needed post-run.

#### Expert Path
Master interfaces (NVMe for performance); integrate with scripts and IAM. Learn Secrets Manager for key management. Practice OS Login for GCP-native security.

#### Common Pitfalls
- Assuming data persists after termination—always back up.
- Using preview features in production (discard-local-ssds flag).
- Sharing SSH keys publicly; leads to security breaches.
- Skipping IAM roles; causes access failures in scripts.

#### Lesser-Known Facts
- Older OS versions (< Ubuntu 20.04) lack NVMe support.
- Local SSD encryption always Google-managed; customer keys not supported.
- `discard-local-ssds=false` in CLI enables preview persistence (charges apply until restart).

**Advantages and Disadvantages:**
- Advantages: High IOPS, low latency, easy attachment.
- Disadvantages: No data persistence on termination, fixed sizes, no snapshots.
