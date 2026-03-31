# Session 005: How to Create a Bucket in Google Cloud Platform

## Table of Contents
- [Overview](#overview)
- [Key Concepts/Deep Dive](#key-conceptsdeep-dive)
  - [Accessing Cloud Storage](#accessing-cloud-storage)
  - [Creating a Bucket](#creating-a-bucket)
  - [Storage Classes](#storage-classes)
  - [Permissions](#permissions)
  - [Protection Tools](#protection-tools)
  - [Retention and Locking](#retention-and-locking)
  - [Encryption](#encryption)
  - [Lifecycle Rules](#lifecycle-rules)
  - [Uploading Data](#uploading-data)

## Overview
This session covers the process of creating and configuring a bucket in Google Cloud Storage (GCS). GCS is a robust, scalable object storage service that allows you to store and retrieve data globally. Buckets serve as containers for your objects (files, images, etc.), and this guide walks through the creation process, configuration options, and best practices for managing storage efficiently and securely.

## Key Concepts/Deep Dive

### Accessing Cloud Storage
- Navigate to the GCP Console and select "Cloud Storage" from the menu.
- Click on "Create Bucket" to start the process.

### Creating a Bucket
- **Bucket Name**: Must be globally unique and follow GCP naming conventions (no spaces, 3-222 characters, lowercase letters, numbers, and hyphens only).
- **Location (Region)**: Choose a region close to your users for better performance and latency (e.g., Mumbai, Delhi, or other available regions).
- **Storage Class**: Select an appropriate class based on access patterns.
- Confirm creation to initialize the bucket.

```bash
# Example: Create bucket via CLI (not covered in transcript but recommended)
gcloud alpha storage buckets create gs://my-unique-bucket --region=mumbai
```

### Storage Classes
Storage classes determine cost and performance. GCP offers:

| Class | Use Case | Access Frequency | Retrieval Cost |
|-------|----------|------------------|----------------|
| Standard | Frequently accessed data (daily) | High | Lowest |
| Nearline | Monthly access | Medium | Moderate |
| Coldline | Quarterly access | Low | Higher |
| Archive | Long-term storage (years) | Very low | Highest |

- **Standard**: Ideal for hot data.
- **Nearline**: For weekly/monthly access.
- **Coldline**: For quarterly access.
- **Archive**: For archival data with long retention.

### Permissions
- **Bucket-Level Permissions**: Uses IAM to grant access to all objects in the bucket. Uniform access for consistent security.
- **Object-Level Permissions**: Allows fine-grained control per object (e.g., specific photo access).

### Protection Tools
- **Object Versioning**: Enables multiple versions of an object. When updating, old versions become backups and can be restored.
  - Enable: Click on bucket settings > Versioning.
  - Restore: Select previous version and set as primary.

> [!IMPORTANT]
> Versioning prevents accidental deletion but increases storage costs.

### Retention and Locking
- **Lock Data for Auditing**: Set a retention period (e.g., 1 year) where data cannot be deleted.
  - Useful for compliance and regulatory requirements.
- Prevents unauthorized data removal.

### Encryption
- GCP provides Google-managed encryption by default.
- For custom keys: Use Customer-Managed Encryption Keys (CMEK).
- Options include Cloud KMS for enhanced security.

### Lifecycle Rules
- Automate storage management:
  - Example: Move data from Standard to Coldline after 1 year, delete after 2 years.
- Set rules based on age, storage class, or other conditions.

```yaml
# Example lifecycle rule in YAML
lifecycle:
  rule:
  - action:
      type: SetStorageClass
      storageClass: CIVIC_DEERLINE
    condition:
      age: 365
  - action:
      type: Delete
    condition:
      age: 730
```

### Uploading Data
- Upload individual files or folders via the console.
- Use drag-and-drop or create folders for organization.
- Transfer tools for bulk uploads.

## Lab Demos
### Creating a Bucket Step-by-Step
1. Go to GCP Console > Cloud Storage > Buckets.
2. Click "Create Bucket".
3. Enter a globally unique name (e.g., `my-test-bucket-2024`).
4. Select region (e.g., Mumbai).
5. Choose storage class (e.g., Standard).
6. Enable options like versioning and encryption as needed.
7. Click "Create".
8. View the created bucket in the list.

### Configuring Permissions
1. In bucket details, go to "Permissions" tab.
2. Add IAM roles (e.g., Storage Object Viewer) to users/groups.
3. For public access: Disable "Public access prevention" if sharing, but set carefully.

### Setting Up Lifecycle Rules
1. Go to bucket > Lifecycle tab.
2. Click "Add rule".
3. Set conditions: Age > 365 days.
4. Action: Set to Coldline.
5. Add another rule: Age > 730 days, Action: Delete.
6. Click "Save".

## Summary Section

### Key Takeaways
```diff
+ Bucket names must be globally unique and lowercase.
+ Choose regions nearest to users for optimal performance.
+ Use appropriate storage classes to balance cost and access speed.
+ Enable versioning for data protection and easy restoration.
+ Implement lifecycle rules for automated cost management.
+ Always enable encryption; GCP manages it by default.
- Avoid enabling public access unless necessary to prevent data breaches.
- Do not skip encryption or retention settings for sensitive data.
! Retention locks prevent deletion, plan carefully to avoid enforcement issues.
```

### Expert Insight
- **Real-world Application**: In production, use GCS buckets for data lakes, backups, and static website hosting. Automate with Terraform for immutable infrastructure.
- **Expert Path**: Master GCP CLI and SDKs for scripting bucket operations. Study IAM policies deeply to secure multi-tenant environments.
- **Common Pitfalls**: Not verifying unique bucket names leads to creation failures. Overusing Public Access Prevention can lock out legitimate users—test permissions thoroughly.
- Common issues: Data not deleting due to retention locks (solution: Set policies in advance, use temporary locks for testing). Lesser known: Use Requester Pays to charge others for access, reducing your costs for shared data.

**Misspellings and corrections from transcript**:
- "ग्लोबल यूनिक" → "Global unique"
- "रीजन" → "Region"
- "क्लास" → "Class"
- "nearlin" → "Nearline"
- "फर्ज rimvardhini" → "Object versioning"
- "प्रोटेक्शन टूल्स" → "Protection Tools"
- "दल देते हैं" → "Lock kar dena"
- "लीवर" → "Lifecycle" (assumed)
- "लाइक" repeated as "Like"
- General: Transcript has mixed English/Hindi with transcription errors; cleaned for clarity while preserving intent.
