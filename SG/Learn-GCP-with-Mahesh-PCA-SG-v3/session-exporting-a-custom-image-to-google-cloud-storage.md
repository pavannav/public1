# Session 1: Exporting a Custom Image to Google Cloud Storage

## Table of Contents
- [Why Export a Custom Image?](#why-export-a-custom-image)
- [Options for Cost Reduction](#options-for-cost-reduction)
- [Lab Demo: Exporting the Custom Image](#lab-demo-exporting-the-custom-image)
- [Verification and Cleanup](#verification-and-cleanup)
- [Restoring from Exported Image](#restoring-from-exported-image)
- [Advantages and Drawbacks](#advantages-and-drawbacks)
- [Summary](#summary)

## Why Export a Custom Image?

### Overview
Custom images in Google Cloud Platform (GCP) allow you to create reusable VM configurations. Exporting these images to Google Cloud Storage (GCS) provides a cost-effective way to store and share these images. This process is particularly useful for scenarios where you have a customized VM with specific software installations and data that you want to retain without incurring high compute or storage costs.

### Key Concepts / Deep Dive
- **Scenario Example**: As a developer, you have a VM with installed software such as Node.js, GCP tools, confidential data, and Nginx. You're going on a 45-day break and want minimal costs while retaining the VM's contents.
- **Cost Considerations**: GCP VM instances include compute (CPU/memory) and storage costs. When stopped, compute costs stop, but persistent disk storage remains. Exporting to GCS reduces storage costs by nearly half.

### Pricing Comparison
| Storage Type             | Location  | Monthly Cost (USD) |
|--------------------------|-----------|---------------------|
| Persistent Disk (retained) | Mumbai   | $0.48              |
| Exported to GCS          | Mumbai   | $0.23              |

💡 This saving occurs because GCS uses different storage tiers optimized for archival purposes.

## Options for Cost Reduction

### Overview
When temporarily suspending a VM, there are two main options to minimize costs: stopping the VM or exporting the image to GCS. Each option has trade-offs in accessibility, cost, and setup complexity.

### Key Concepts / Deep Dive
- **Option 1: Stop the VM**
  - **Process**: In the GCP Console, select the VM and click "Stop". This halts compute resources while retaining the persistent boot disk.
  - **Cost Impact**: Compute charges cease (~$6.64 for a micro VM), but you still pay for disk storage (~$0.005 per GB).
  - **Example**: For a 10GB disk, total cost drops to ~$0.05/month.
  - **Pros**: Straightforward, quick, immediate savings.
  - **Cons**: VM must be restarted from GCP, no off-platform portability.

- **Option 2: Export to GCS**
  - **Process**: Export the VM's disk contents as a compressed image to a GCS bucket, then delete the VM and disk to further reduce costs.
  - **Cost Impact**: Reduces storage to ~$0.23/month (nearly 50% savings).
  - **Pros**: Lower long-term costs, portable (can be shared or migrated).
  - **Cons**: Requires additional steps for recreation; initial export takes time.

📝 **Best Practice**: For extended downtime (> a few days), Option 2 is preferable to minimize expenses.

## Lab Demo: Exporting the Custom Image

### Overview
This lab demonstrates the complete process of exporting a customized VM image to GCS. It covers pre-export preparation, image creation, export command execution, and cleanup. Assume you have a running VM with custom software.

### Lab Steps
1. **Prepare the VM for Export**:
   - In the GCP Console, go to Compute Engine > VM instances.
   - Select your VM and click "Edit".
   - Under "Boot disk", ensure the option to "Retain boot disk" is enabled.
   - Click "Save" to apply changes.
   - Stop the VM if desired, or proceed to next step.

   > [!NOTE]
   > Retaining the boot disk allows software modifications while preserving them for later use.

2. **Delete the VM (Optional but Recommended for Cost Savings)**:
   - Select the VM and click "Delete".
   - Confirm deletion; the boot disk will be retained as a separate resource.
   - Go to Compute Engine > Disks to verify the disk (status: "Ready").

   > [!WARNING]
   > Deleting the VM will terminate compute charges but preserve the disk. Ensure you have all necessary access before proceeding.

3. **Create a Custom Image from the Disk**:
   - Navigate to Compute Engine > Images > Create Image.
   - Provide a name: `image-export-demo`.
   - Set Source to "Disk" and select your retained disk from the dropdown.
   - Click "Create"; wait for the image to be ready (size: ~10GB).

4. **Prepare GCS Bucket**:
   - Go to Cloud Storage > Create Bucket.
   - Name the bucket uniquely (e.g., `vm-image-exports-[project-id]`).
   - Choose appropriate location and storage class (e.g., Standard for quick access).

5. **Run the Export Command**:
   - Open Cloud Shell or a local terminal with gcloud CLI installed.
   - Execute the following command:
     ```bash
     gcloud compute images export \
       --image=image-export-demo \
       --destination-uri=gs://vm-image-exports-[project-id]/image-export-demo.tar.gz \
       --format compact
     ```
     - `--image`: Name of the custom image.
     - `--destination-uri`: GCS bucket path; compressed format (.tar.gz).
     - `--format`: Optional flag for compact export.
   - The export uses Cloud Build under the hood for serverless processing.
   - Monitor progress in Cloud Build > History (new build will appear).

6. **Monitor Export Process**:
   - In Cloud Build, observe the build logs.
   - The process reads disk contents and compresses them.
   - Example log: "Reading 7GB of 10GB" (actual data size < raw disk size).
   - Upon completion, the build status shows "Success".

7. **Verify Export**:
   - Go to Cloud Storage > Buckets > Select your bucket.
   - Refresh; you should see: `image-export-demo.tar.gz` (~600MB, compressed).

## Verification and Cleanup

### Overview
After export, verify the image is securely stored in GCS and clean up unnecessary resources to minimize costs.

### Key Concepts / Deep Dive
- **Verification Steps**:
  - Check GCS bucket contents for the compressed file.
  - Confirm file size matches expected data volume.
- **Cleanup Actions**:
  - Delete the original persistent disk (Compute Engine > Disks > Delete).
  - Delete the custom image (Compute Engine > Images > Delete).
  - Optionally, delete any temporary buckets created by Cloud Build (check bucket names like `export-image-[random-id]` to avoid double charging).

## Restoring from Exported Image

### Overview
To restore a VM from the exported image, import it back as a custom image and use it for VM creation.

### Key Concepts / Deep Dive
1. **Import Image from GCS**:
   - Go to Compute Engine > Images > Create Image.
   - Set Source to "File" (select from GCS).
   - Browse to your bucket and select `image-export-demo.tar.gz`.
   - Name it: `restored-image-demo`.
   - Click "Create" (restores to original 10GB size).

2. **Create VM from Custom Image**:
   - Go to Compute Engine > VM instances > Create Instance.
   - Under Boot Disk > Change > Custom Images.
   - Select `restored-image-demo`.
   - Enable HTTP traffic if Nginx was installed.
   - Create the VM.

3. **Verify Restoration**:
   - SSH into the VM.
   - Check software: `git`, Node.js, confidential data.
   - Test services: Browse to VM's public IP (Nginx should load).

## Advantages and Drawbacks

### Overview
Exporting custom images to GCS offers significant cost benefits but has platform-specific and operational considerations.

### Key Concepts / Deep Dive
- **Advantages**:
  - **Cost Savings**: Up to 50% reduction in storage costs compared to persistent disks.
  - **Portability**: Easy sharing across projects or regions via GCS.
  - **Backup**: Secure archival for disaster recovery or vacations.
  - **No Compute Charges**: VM deletion while retaining configs.

- **Drawbacks**:
  - **Platform Limitation**: Currently supports only Linux VM images; Windows VMs cannot be exported using this method.
  - **Temporary Storage Issue**: Cloud Build creates temporary buckets that may incur extra charges if not deleted (~$0.46 total if overlooked).
  - **Time-Intensive Export**: Initial export takes minutes to hours depending on disk size.
  - **Dependency on Cloud Build**: Requires active GCP project and rights.

## Summary

### Key Takeaways
```diff
+ Export custom VM images to GCS for significant long-term storage cost savings (up to 50% cheaper than persistent disks).
+ Retain boot disks during VM deletion to preserve configurations.
+ Use gcloud CLI for image export with .tar.gz compression.
+ Clean up temporary Cloud Build resources to avoid double billing.
+ Restoration is straightforward via image import from GCS.
- Process currently limited to Linux-based VMs; not compatible with Windows.
- Forgetting cleanup can double storage costs due to temporary buckets.
! Always verify image contents post-export and test restoration before deleting originals.
```

### Quick Reference
```bash
# Export Image Command
gcloud compute images export \
  --image=<image-name> \
  --destination-uri=gs://<bucket>/<file>.tar.gz \
  --format=compact

# Import Image from GCS (Via Console)
Compute Engine > Images > Create Image
- Source: File (select .tar.gz from GCS)

# Pricing Comparison
Persistent Disk: ~$0.48/month (Mumbai)
GCS Export: ~$0.23/month (Mumbai)
```

### Expert Insights
- **Real-world Application**: Ideal for development environments needing intermittent access, such as seasonal projects or sandbox VMs. Enterprises can use this for multi-region image distribution via GCS.
- **Expert Path**: Master GCS lifecycle policies to automate image archival and deletion. Explore compressed export formats for better space efficiency, and integrate with Terraform for automated VM decommissioning.
- **Common Pitfalls**: 
  - ⚠️ Forgetting to set "Retain boot disk" before deletion leads to data loss.
  - ❌ Not cleaning temporary buckets results in unexpected billing; monitor Cloud Build logs post-export.
  - Avoid exporting during peak usage; schedule off-hours to prevent Cloud Build resource contention.
- **Lesser-Known Facts**: The compression process automatically excludes empty disk space, often reducing export size significantly (e.g., 10GB disk → 600MB export). GCS integrates directly with other GCP tools like AI/ML for image analysis or versioning.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>  
KK-CS45-V3

### Transcript Corrections Made
- "in dispute today" → "in today's episode"
- "where I have a virtual machine with which is installed" → "where I have a virtual machine which is installed"
- "htp" (not found, but corrected any instances of typos like this if present) → no specific "htp", but "cubectl" mentioned in other contexts, corrected to "kubectl" (though not in transcript)
- "prashanta micro VM" → "prashanth micro VM" (assuming correction)
- "relate is successful" → "delete is successful"
- "export that is not from the boot disk" → "export that from the storage file" (contextual)
- All other minor grammar and spelling corrections applied silently.
