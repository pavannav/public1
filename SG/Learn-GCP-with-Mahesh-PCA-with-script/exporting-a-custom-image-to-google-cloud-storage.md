# Session 1: Exporting a Custom Image to Google Cloud Storage

## Table of Contents
- [Overview](#overview)
- [Why Export a Custom Image to Google Cloud Storage](#why-export-a-custom-image-to-google-cloud-storage)
- [Preparing the Virtual Machine](#preparing-the-virtual-machine)
- [Creating a Custom Image](#creating-a-custom-image)
- [Exporting the Image to Google Cloud Storage](#exporting-the-image-to-google-cloud-storage)
- [Verifying the Export](#verifying-the-export)
- [Cleaning Up Resources](#cleaning-up-resources)
- [Restoring the Image](#restoring-the-image)
- [Cost Benefits and Drawbacks](#cost-benefits-and-drawbacks)
- [Summary](#summary)

## Overview
In this session, we explore the process of exporting a custom image from a Google Compute Engine virtual machine (VM) to Google Cloud Storage (GCS). This technique allows developers to preserve VM configurations, installed software, and data while minimizing costs during periods of inactivity. We'll cover the rationale, step-by-step process, and restoration procedure, including cost comparisons and best practices.

## Why Export a Custom Image to Google Cloud Storage
### Scenario and Rationale
Imagine you are a seasoned developer with a VM containing installed software such as Node.js, some DCP tips, confidential data, and nginx. You need to go on vacation for 45 days but want to retain the VM's contents without incurring unnecessary costs.

### Cost Comparison
#### Stopping a VM
- Default approach: Stop the VM to avoid compute costs.
- Example: A Prashant micro VM costs $6.64/month plus $0.005 for 10 GB persistent disk, totaling ~$7.09/month.
- When stopped: Compute cost reduced to $0, paying only ~$0.005 for storage.

#### Exporting to GCS
- Benefits: Even lower storage costs in GCS compared to Persistent Disk.
- Pricing example (Mumbai region):
  - Persistent Disk (10 GB): $0.048/month.
  - Exported to GCS: $0.023/month (nearly half the cost).
- This approach minimizes costs further by eliminating the need to retain the VM or persistent disk in Compute Engine.

> [!NOTE]
> Exporting allows cost reduction from $0.005 (stopped VM storage) to $0.023/month while preserving all data.

## Preparing the Virtual Machine
### Retaining the Boot Disk
- **Rationale**: Before deleting the VM, ensure the boot disk is retained to prevent data loss. (Note: Best practice is to install software on additional disks, not boot disk.)
- **Steps**:
  1. Navigate to the VM in Google Cloud Console.
  2. Click "Edit" under the VM settings.
  3. Enable "Retain boot disk" when deleting the VM.
  4. Save changes.

### Deleting the VM
- **Steps**:
  1. Return to the VM page.
  2. Delete the VM (it retains the boot disk).
- **Verification**: After deletion, check under "Compute Engine" > "Disks" to confirm the persistent disk is "Ready" and "In use".

💡 **Best Practice**: This ensures software and data are preserved without VM compute costs.

## Creating a Custom Image
### From the Retained Disk
- **Steps**:
  1. Go to "Compute Engine" > "Images".
  2. Click "Create Image".
  3. Name: e.g., `image-export`.
  4. Source: Select "Disk".
  5. Choose the retained persistent disk.
  6. Click "Create".
- **Result**: Custom image created (e.g., 10 GB size).

> [!IMPORTANT]
> The custom image encapsulates the OS, software, and data from the VM.

## Exporting the Image to Google Cloud Storage
### Prerequisites
- Ensure a GCS bucket exists (e.g., via Cloud Storage console).
- **Format Requirement**: Images must be tarred and gzipped.

### Export Command
Use the Google Cloud CLI command in your local environment (or a provisioned VM):

```bash
gcloud compute images export \
  --destination-uri gs://[BUCKET_NAME]/[IMAGE_NAME].tar.gz \
  --image [IMAGE_NAME] \
  --project [PROJECT_ID] \
  --zone [ZONE]
```

- **`--destination-uri`**: GCS URI, e.g., `gs://my-bucket/image-export.tar.gz`.
- **`--image`**: Name of custom image (e.g., `image-export`).
- **`--zone`**: VM's zone (e.g., `us-central1-a`).

### Process Details
- **Execution**: Command triggers a Cloud Build process (serverless CI/CD).
- **Progress**: View in "Tools" > "Cloud Build" (opens in new tab).
- **Duration**: Depends on image size (e.g., 10 GB may take minutes; show progress reading data).

⚠ **Note**: Behind the scenes, Cloud Build handles the export seamlessly.

## Verifying the Export
- **Check GCS Bucket**: Refresh the bucket to confirm the exported file (e.g., `image-export.tar.gz`) appears.
- **Size**: Exported file may be smaller (e.g., 600 MB) as it only includes used data, not allocated disk space.

## Cleaning Up Resources
### Delete Temporary Resources
- **Persistent Disk**: Under "Compute Engine" > "Disks", delete the retained disk.
- **Custom Image**: Under "Images", delete the custom image.

### Avoid Accidental Double Billing
- **Temporary Bucket Issue**: Export may create a temporary GCS bucket with the same image, leading to duplicate storage costs ($0.046 instead of $0.023).
- **Actions**:
  1. Identify temporary buckets (named similarly to your export bucket).
  2. Delete them manually to prevent extra charges.

> [!WARNING]
> Forgetting to delete temporary buckets causes unintended costs.

## Restoring the Image
### From GCS to Custom Image
- **Steps**:
  1. Go to "Compute Engine" > "Images".
  2. Click "Create Image".
  3. Source: Select "Cloud Storage file".
  4. Browse and select the exported `.tar.gz` file.
  5. Name: e.g., `image-demo`.
  6. Click "Create".

### Creating a VM from Custom Image
- **Steps**:
  1. Go to "Compute Engine" > VM instances.
  2. Click "Create instance".
  3. Under "Boot disk", click "Change".
  4. Select "Custom images" and choose the restored image.
  5. Enable HTTP (for nginx restoration).
  6. Create the VM.

### Verification
- SSH into the restored VM.
- Confirm software restoration:
  - Nginx: Accessible via HTTP.
  - Node.js: Check with `node --version`.
  - DCP tips and confidential data: Manually verify.

✅ **Benefit**: Full restoration in minutes, paying only ~$0.023/month during storage.

## Cost Benefits and Drawbacks
### Advantages
- Cost reduction: From $0.005 (stopped VM) to $0.023/month.
- Data preservation: All software and configurations intact.

### Drawbacks
- **OS Limitation**: Only supports Linux distributions; Windows VMs cannot be exported this way.
- **Potential Cost Pitfall**: Temporary GCS buckets may lead to double billing if not deleted.
- **Future Updates**: May support Windows in upcoming GCP releases.

💡 **Common Issue**: Double billing from temporary buckets. Resolution: Monitor Cloud Storage for duplicates and delete promptly.

## Summary
### Key Takeaways
```diff
+ Exporting custom images to GCS reduces storage costs by nearly half compared to persistent disks.
+ Process involves retaining boot disk, creating a custom image, and using gcloud export command.
+ Restoration reverses the process: Import from GCS to create image, then VM.
+ Enables cost-effective preservation during extended inactivity (e.g., vacations).
- Avoid forgetting to delete temporary GCS buckets to prevent double billing.
- Currently Linux-only; Windows support not available.
! Always enable "Retain boot disk" before VM deletion to prevent data loss.
```

### Expert Insight
#### Real-World Application
In production, use this for disaster recovery, scaling, or seasonal workloads. For instance, export development VMs to GCS during off-peak periods, then restore branches for testing. Integrate with CI/CD pipelines (via Cloud Build) for automated image exports.

#### Expert Path
- Master GCP CLI commands for automation (e.g., scripting exports in bash).
- Explore advanced options: Image versioning, IAM roles for access control.
- Integrate with Terraform/Pulumi for infrastructure as code (IaC).

#### Common Pitfalls
- Failing to set `--zone` correctly leads to command failures.
- Not tar.gzipping properly causes import errors.
- Overlooking temporary buckets results in unexpected costs (common issue: $0.046/month instead of $0.023).

#### Lesser-Known Things
- Export uses Cloud Build under the hood, allowing custom build steps if needed.
- Exported images retain metadata; useful for compliance audits.
- Cross-project exports require project IAM permissions.

**Mistakes and Corrections in Transcript**:
- "Machel environment" → Corrected to "Machine environment".
- "flowered bed" → Corrected to "Cloud Build" (likely "Cloud Build" misspoken).
- "tips on DCP" → Retained as is; assuming "DCP" is a specific term or acronym.
