Session 13: Local SSD Shutdown and Startup Script, Basics of SSH Login.

## Table of Contents
- [VM Status Check](#vm-status-check)
- [Local SSD Concepts](#local-ssd-concepts)
- [Provisioning VM with Local SSD](#provisioning-vm-with-local-ssd)
- [Attaching and Mounting Local SSD](#attaching-and-mounting-local-ssd)
- [Testing Data Persistence](#testing-data-persistence)
- [Startup Script for Data Retention on Reboot](#startup-script-for-data-retention-on-reboot)
- [Shutdown Script for Data Backup](#shutdown-script-for-data-backup)
- [Basics of SSH Login](#basics-of-ssh-login)
- [Generating and Using SSH Keys](#generating-and-using-ssh-keys)
- [Shared Access via SSH Keys](#shared-access-via-ssh-keys)

## VM Status Check
### Overview
This section covers checking the status of virtual machines (VMs), including preemptible and spot VMs, to observe their runtime and termination behavior based on predefined limits.

### Key Concepts/Deep Dive
- **Preemptible VM**: A low-cost option that can run for up to 24 hours, after which it may be preempted (terminated) by Google if resources are needed elsewhere.
- **Spot VM**: Similar to preemptible, with a maximum runtime of 24 hours, but emphasizes bidding for unused compute capacity. It may run longer, but preemption can occur for capacity reasons.
- **Tracking Runtime**: Use Google Cloud Logging to query VM events, such as preemption logs, with queries like filtering by compute instance name and event timestamps.
- **VM States**: VMs go through states like running, terminating, and terminated. Spot VMs often remain running beyond 24 hours but can be preempted unexpectedly.

### Lab Demos
1. Access the Google Cloud Console and navigate to **Compute Engine > VM instances**.
2. Check VM statuses (e.g., preemptible VM running beyond 24 hours due to low demand).
3. View logs in **Logging** by querying for events like `compute.instances.preempted` with filters on instance name.
4. Note uptime using commands like `uptime` in VM terminal to verify runtime post-start.

## Local SSD Concepts
### Overview
Local SSD provides high-performance, temporary storage attached directly to the VM host, offering low-latency, high IOPS, but with key limitations like data loss upon VM termination.

### Key Concepts/Deep Dive
- **Performance Advantages**: Physically attached to host, enabling superior I/O operations per second (IOPS) and low latency compared to persistent disks (e.g., standard, SSD, or balanced persistent).
- **Size Options**: Fixed sizes from 375 GB to 9 TB, in multiples of 375 GB, up to 24 disks per VM.
- **Encryption**: Always Google-managed encryption; customer-supplied keys not supported.
- **Interface Types**:
  - Small Computer System Interface (SCSI): Older, slower interface; not recommended.
  - Non-Volatile Memory Express (NVMe): Faster, preferred for maximum performance.
- **OS Support**: NVMe supported in modern OS like Ubuntu 20+, Rocky Linux; older versions like Ubuntu 16/14 lack support.
- **When to Use**: Ideal for cache, scratch storage, or transient data in analytics, compute-intensive workloads.
- **Limitations**: No snapshots, images, or backups; data lost if VM terminates. Replication not supported for redundancy.

| Disk Type              | Approximate Read IOPS | Approximate Write IOPS |
|------------------------|-----------------------|-------------------------|
| Local SSD (NVMe)       | 170K                  | 90K                     |
| Local SSD (SCSI)       | 170K                  | 70K                     |
| Persistent SSD         | Varies (lower than local) | Varies (lower than local) |

Local SSD excels in temporary storage scenarios but requires backups to durable storage like GCS or persistent disks.

### Lab Demos
1. Navigate to **Compute Engine > Disks** and review existing disks (none for local SSD, as they're VM-attached).
2. Examine OS compatibility via documentation links (e.g., Google Cloud local SSD performance docs).
3. Compare interfaces in VM creation: Prefer NVMe for higher write IOPS (90K vs. 70K for SCSI).

## Provisioning VM with Local SSD
### Overview
Creating a VM with local SSD attaches temporary high-performance storage, provisioned at creation time, unlike persistent disks.

### Key Concepts/Deep Dive
- **Creation Step**: Local SSD must be added during VM creation; cannot be added later.
- **Series Support**: N2 series required; E2 does not support.
- **Service Account**: Use a specific service account (e.g., with full access) for future IAM demos, rather than default.
- **Configuration**: Choose NVMe interface, Debian OS, no boot disk persistence (if local SSD is boot disk).

### Lab Demos
1. In Google Cloud Console, go to **Compute Engine > VM instances > Create Instance**.
2. Select N2 series, standard machine type.
3. Set service account to custom (e.g., with full scopes).
4. Under Disks > Advanced, add local SSD: Select NVMe interface, size (e.g., 375 GB).
5. Create VM; note it appears VM-attached, not as separate disk.

```bash
# Example gcloud command (for reference, adapt to UI steps)
gcloud compute instances create vm-with-local-ssd \
  --machine-type=n2-standard-1 \
  --zone=us-central1-a \
  --service-account=your-service@project.iam.gserviceaccount.com \
  --scopes=https://www.googleapis.com/auth/cloud-platform \
  --local-ssd=interface=nvme
```

Ensure VM emerges running; local SSD is ready for attachment.

## Attaching and Mounting Local SSD
### Overview
After VM creation, local SSDs appear as devices (e.g., via NVMe); format and mount them for use, noting they reset on termination.

### Key Concepts/Deep Dive
- **Device Names**: NVMe devices named like `nvme0n1`, `nvme0n2`. Use `lsblk` to list.
- **Formatting**: Use ext4 filesystem; mandatory on first attach.
- **Partitioning**: If full capacity, partition directly; use commands like `mkfs.ext4`.
- **Mounting**: Create directory, mount with `mount` command; persists only until VM termination.
- **Permissions**: Adjust ownership and privileges post-mount.

### Lab Demos
1. SSH into VM: `gcloud compute ssh <instance-name> --zone=<zone>`.
2. List disks: `lsblk` (shows NVMe devices, e.g., 375 GB capacity).
3. Format disk:
   ```bash
   sudo mkfs.ext4 /dev/nvme0n1
   ```
4. Mount disk:
   ```bash
   sudo mkdir /mnt/local-ssd
   sudo mount /dev/nvme0n1 /mnt/local-ssd
   sudo chmod 775 /mnt/local-ssd
   ```
5. Verify: `df -h` shows mounted directory with ~369 GB available (overhead).

Mounting enables high-speed data operations, with NVMe providing faster checks than SCSI.

## Testing Data Persistence
### Overview
Local SSD data persists through OS reboots but is lost on VM termination, emphasizing its temporary nature.

### Key Concepts/Deep Dive
- **Reboot Behavior**: Data retained due to same host allocation; no data loss.
- **Termination Behavior**: VM relocation resets disks to raw state; data irretrievable.
- **Live Migration**: Supports persistence for host maintenance.
- **Spot VM Limitation**: Preemption discards data due to sudden termination.

### Lab Demos
1. Create test files in mounted directory:
   ```bash
   cd /mnt/local-ssd
   touch demo1.txt demo2.txt
   echo "Test data" > demo3.txt
   ```
2. Reboot VM: `sudo reboot`.
3. Post-reboot, SSH back; remount if needed (mount command).
4. Verify data: `ls /mnt/local-ssd` (files present).
5. Terminate VM: In Console, stop instance.
6. Restart VM; check mount: Device raw; reformat to access (data lost).

```bash
# Check if needs remount
sudo mount /dev/nvme0n1 /mnt/local-ssd
ls /mnt/local-ssd  # Files missing post-termination
```

Persistence failure highlights need for automated scripts or backups.

## Startup Script for Data Retention on Reboot
### Overview
Startup scripts automatically mount local SSD post-reboot, ensuring data accessibility without manual intervention.

### Key Concepts/Deep Dive
- **Execution**: Runs as root; metadata-stored.
- **Use Case**: Facilitates automatic recovery for patches/restarts requiring reboots.
- **Metadata Storage**: At VM or project level; VM-level more common.

> [!NOTE]
> Startup scripts execute only on boot; not for manual logins.

### Lab Demos
1. In VM edit (post-creation or via Console), add startup script:
   - Contents:
     ```bash
     sudo mkdir -p /mnt/local-ssd
     sudo mount /dev/nvme0n1 /mnt/local-ssd
     sudo chmod 775 /mnt/local-ssd
     ```
2. Save; reboot VM: `sudo reboot`.
3. SSH post-reboot: Verify `df -h` shows mounted local SSD; data accessible.

Startup scripts prevent manual mount steps, aiding maintenance workflows.

## Shutdown Script for Data Backup
### Overview
Shutdown scripts archive local SSD data to Google Cloud Storage (GCS) before termination, mitigating data loss.

### Key Concepts/Deep Dive
- **Execution**: Triggers on shutdown/preemption; runs as root.
- **IAM Requirements**: Service account with storage object creator role on bucket.
- **Command Structure**: Uses `gsutil cp` to upload files recursively.
- **Preview Feature**: Optional in-preview discard local SSD flag for migration to persistent disk (charged temporarily).

### Lab Demos
1. Create GCS bucket: `gsutil mb gs://local-ssd-backup-pca`.
2. Grant IAM: Add service account as storage object creator (bucket-level or project).
3. Add shutdown script in VM metadata:
   - Key: `shutdown-script`
   - Value:
     ```bash
     gsutil cp /mnt/local-ssd/*.txt gs://local-ssd-backup-pca/
     ```
4. Test: Stop VM via Console; script uploads data.
5. Verify: In bucket, data files appear; use in-preview `gcloud beta compute instances stop <instance> --discard-local-ssd` for auto-migration.

```bash
# Stop with preview flag
gcloud beta compute instances stop vm-with-local-ssd --discard-local-ssd=false --zone=us-central1-a
```

Check post-restart: Persistent disk created temporarily; data migrates back.

## Basics of SSH Login
### Overview
SSH enables secure VM access via keys; Google auto-generates temporary keys with expiry, enhancing security.

### Key Concepts/Deep Dive
- **Key Types**: RSA (older, larger) vs. ECDSA (newer, smaller, faster).
- **Storage**: Private key in browser cache; public in VM (`/root/.ssh/authorized_keys`).
- **Expiry**: Keys valid ~4 minutes; auto-remove ensures limited exposure.
- **Browser-Based Access**: Temporary; fixes issues like lost keys by regenerating.

### Lab Demos
1. Click SSH in Console; note key transfer message.
2. In VM, check keys: `ls -la ~/.ssh/` (authorized_keys present).
3. Wait expiry; retry SSH regenerates keys.

Temporary keys prevent permanent SSH key sprawl.

## Generating and Using SSH Keys
### Overview
Custom SSH keys (e.g., via PuTTY) replace temporary ones, enabling extended access with custom expiry or none.

### Key Concepts/Deep Dive
- **Generation Tools**: Puttygen (for Windows); exports to OpenSSH format.
- **Formats**: Private key (PPK/ECDSA); public for VM metadata.
- **Private Key Security**: Store securely; loss blocks access.

### Lab Demos
1. In PuTTYgen: Generate key pair (ECDSA preferred).
2. Copy public key; add to VM metadata.
3. Use private key in putty/openSSH for login without browser.
4. Example OpenSSH private key usage:
   ```bash
   chmod 600 private-key.pem
   ssh -i private-key.pem user@vm-external-ip
   ```

> [!WARNING]
> Unlimited expiry increases risk if key compromised.

## Shared Access via SSH Keys
### Overview
Sharing private keys via GCS enables temporary access without IAM roles, but poses security risks.

### Key Concepts/Deep Dive
- **Distribution**: Host public key on GCS; share download link.
- **Permissions Lockdown**: Use secret manager for secured key distribution.
- **Risks**: Root access by default; no two-factor auth; track via `who` command.

### Lab Demos
1. Create GCS bucket; make object public (e.g., private key file).
2. Download in Cloud Shell:
   ```bash
   gsutil cp gs://bucket-name/private-key .
   chmod 600 private-key
   ```
3. SSH using private key:
   ```bash
   ssh -i private-key user@vm-ip
   ```
4. Post-login: `whoami` shows "user"; `sudo su` enables root.
5. Track access: `who` lists logins by IP.

> [!IMPORTANT]
> Avoid public keys for production; use IAM for controlled access.

## Summary
### Key Takeaways
```diff
+ Local SSD provides high-performance temporary storage with NVMe for fastest IOPS (up to 170K read, 90K write).
+ Data persists on reboot but is lost on termination; use startup/shutdown scripts for automation.
+ SSH temporary keys expire quickly; custom keys enable extended access but require security measures.
+ Shutdown scripts enable backups to GCS; in-preview options allow persistent disk migration.
+ IAM roles offer better access control than shared SSH keys, avoiding root privilege risks.
- Termination without backups results in data loss; no snapshots supported.
- Older SCSI interface limits write IOPS; avoid unsupported OS versions.
- Shared SSH keys lack trackability and two-factor auth, posing security threats.
```

### Expert Insight
#### Real-world Application
In high-compute scenarios like big data analytics, attach multiple local SSDs (up to 24) for scratch space, processing intermediate results at 170K IOPS. Use shutdown scripts to export processed data to GCS or BigQuery, ensuring no durable data remains on ephemeral storage. For AI model training, format and mount NVMe SSDs for dataset caching, with startup scripts ensuring seamless restarts post-maintenance.

#### Expert Path
To master, practice NVMe vs. SCSI benchmarks using tools like `fio` for I/O testing. Explore secret manager for secure SSH key distribution in multi-user setups. Study preemptible VM logs via Cloud Logging API to predict terminations. For production, integrate with persistent disks for hybrid storage: local for hot data, persistent for cold. Certify in Google Cloud Professional Cloud Architect to apply these in certified deployments.

#### Common Pitfalls
- Forgetting to provision local SSD at VM creation: Leads to inability to attach later, requiring VM recreation.
- Ignoring OS compatibility: Using Ubuntu 16.x without NVMe support drops performance to SCSI levels (70K write IOPS).
- Over-relying on in-preview termination options: SLA-excluded features like `--discard-local-ssd=false` may fail without support.
- Spoofing issues with `who` tracking: Cloud Shell IPs can mask users; implement SSH log aggregation via `journalctl`.
- Making private SSH keys public: Enables unauthorized root access; no audit trails, risking VM compromise.

<!---
Transcript Corrections Noted:
- "ript" → Assumed start of "Script" or cut off; treated as "Script".
- "hubun" → "Ubuntu" (multiple instances, e.g., "hubuntu 2", "Ubunto").
- "non otile" → "NVMe" (Non-Volatile Memory Express).
- "sent to S6" → "SATA" (Serial ATA).
- "pre pvm" → "preemptible VM" or "preempted VM".
- "拡" → Likely "expansion" or context cut; ignored as unclear.
- "povo" → "PAM" or "pudo" (likely "sudo").
- "puter" → "PuTTY".
- Various contractions e.g., "there's" corrected to standard; "folks" as-is.
All corrections applied silently in guide for clarity, while maintaining original meaning.-->
