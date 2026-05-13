# Session 005: How to Create a Bucket in GCP

<details open>
<summary><b>How to Create a Bucket in GCP (KK-CS45-script-v2)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts/Deep Dive](#key-conceptsdeep-dive)
  - [Cloud Storage Overview](#cloud-storage-overview)
  - [Bucket Naming](#bucket-naming)
  - [Storage Classes](#storage-classes)
  - [Permissions Model](#permissions-model)
  - [Object Versioning](#object-versioning)
  - [Retention Policies](#retention-policies)
  - [Data Protection](#data-protection)
- [Lab Demo: Creating a Cloud Storage Bucket](#lab-demo-creating-a-cloud-storage-bucket)
- [Summary](#summary)

## Overview
This session demonstrates how to create and configure a Cloud Storage bucket in Google Cloud Platform. Cloud Storage buckets are used to store unstructured data (objects) globally with different storage classes, permissions, and protection mechanisms. The tutorial covers bucket creation basics, storage classes, security settings, versioning, retention policies, and lifecycle management.

## Key Concepts/Deep Dive

### Cloud Storage Overview
Google Cloud Storage is Google's object storage service built for developers and enterprises. It allows you to:
- Store and retrieve any amount of data
- Access data instantly from anywhere in the world via HTTP/HTTPS
- Scale storage as needed without worrying about performance or reliability

### Bucket Naming
- Bucket names must be **globally unique** across all Google Cloud projects
- Names are case-insensitive and can contain lowercase letters, digits, and hyphens
- Must be between 3-63 characters long
- Cannot contain underscores or uppercase letters
- Best practice: Use project name prefixes or domains for uniqueness (e.g., `myproject-bucket-123`)

> [!IMPORTANT]
> Bucket names cannot be changed after creation. Choose a descriptive, unique name carefully.

### Storage Classes
Cloud Storage offers different storage classes based on data access patterns and cost optimization:

| Storage Class | Retrieval Cost | Storage Cost | Best For |
|---------------|----------------|--------------|----------|
| **Standard** | Lowest | Standard | Frequently accessed data (daily usage) |
| **Nearline** | Moderate | Lower | Data accessed less than once per month |
| **Coldline** | Higher | Lowest | Data accessed less than once per quarter |
| **Archive** | Highest | Lowest | Long-term storage (rarely accessed) |

### Permissions Model
Cloud Storage supports two permission models:

#### Uniform Access Control
- Bucket-level permissions apply to all objects within the bucket
- IAM roles control access (e.g., `roles/storage.objectViewer`)
- Consistent permissions across all bucket contents

#### Fine-Grained Access Control
- Object-level permissions can differ
- Access Control Lists (ACLs) per object
- More flexible but complex to manage

> [!NOTE]
> Fine-grained access control introduces additional complexity. Use uniform access control unless specific object-level permissions are required.

### Object Versioning
Object versioning maintains multiple versions of the same file:
- Previous versions are preserved when objects are overwritten
- Versions are stored in the background automatically
- No performance or storage impact on live operations
- Versions can be restored or deleted individually

```diff
+ When enabled: Each file upload creates a new version instead of overwriting
+ Previous versions remain accessible and can be listed or downloaded
- Storage costs increase as versions accumulate over time
! Important: Deletion of an object marks it as "soft deleted" but doesn't free storage immediately
```

### Retention Policies
Retention policies prevent data deletion or modification:
- Set retention periods (e.g., 1 year, 5 years)
- Data cannot be deleted or modified during retention period
- Applied at bucket level
- Helps meet compliance requirements

### Data Protection
Multiple layers of protection:

#### Object Retention
```yaml
# Example retention policy configuration
retentionPeriod: 31536000  # 1 year in seconds
mode: Compliance           # or Governance
```

#### Data Encryption
- Google manages encryption keys by default (Google-managed)
- Customer-managed encryption keys (CMEK) for advanced control
- Customer-supplied encryption keys (CSEK) for external key management

#### Requester Pays
- Bucket owner can enable "Requester Pays"
- Data access costs are billed to the requester instead of bucket owner
- Useful for publicly shared datasets

## Lab Demo: Creating a Cloud Storage Bucket

### Prerequisites
- Active Google Cloud Platform account
- Project created in Google Cloud Console

### Steps to Create a Bucket

1. **Access Cloud Storage Console**
   ```
   Navigate to Google Cloud Console → Cloud Storage → Buckets
   ```

2. **Click Create Bucket**
   - Click the "Create Bucket" button

3. **Configure Bucket Name**
   ```
   Bucket Name: [Enter a globally unique name]
   Example: my-test-bucket-2024
   ```
   - Use the "Check availability" feature to verify uniqueness

4. **Select Location Type**
   ```
   Choose: Region
   ```

5. **Choose Location**
   ```
   Region: asia-south1 (Mumbai)
   ```
   - Select region closest to your users for better performance
   - Consider data sovereignty requirements

6. **Choose Storage Class**
   ```
   Default Storage Class: Standard
   ```
   - Choose based on access patterns:
     - Standard: Frequent access
     - Nearline: Monthly access
     - Coldline: Quarterly access

7. **Access Control**
   ```
   Choose: Uniform
   ```
   - Uniform: Consistent permissions across all objects
   - Fine-grained: Object-level permissions

8. **Protection Tools**
   ```
   Retention: Disabled
   Object versioning: Disabled
   Encryption: Google-managed encryption key
   ```

9. **Advanced Options**
   ```
   Requester pays: Disabled
   ```

10. **Create Bucket**
    ```
    Click "Create"
    ```

### Post-Creation Configuration

#### Uploading Data
```bash
# Via gsutil (Google Cloud Storage CLI)
gsutil cp my-local-file.txt gs://my-bucket-name/
```

#### Managing Lifecycle Rules
```
Bucket Settings → Lifecycle → Add Rule:
- Action: Delete
- Conditions: Age > 365 days
```

#### Setting Retention Policy
```bash
# Via gsutil
gsutil retention set 365d gs://my-bucket-name/
```

## Summary

### Key Takeaways
```diff
+ Bucket names must be globally unique across Google Cloud
+ Choose storage classes based on access frequency for cost optimization
+ Uniform access control simplifies permission management
+ Object versioning protects against accidental overwrites
+ Retention policies ensure data compliance and protection
+ Encryption is managed automatically by Google by default
- Fine-grained permissions can lead to management complexity
- Versioning increases storage costs if not monitored
! Always choose regions strategically for performance and compliance
```

### Quick Reference
```bash
# Check bucket availability
# Via Console: Use "Check availability" in bucket creation wizard

# Create bucket via gsutil
gsutil mb gs://my-unique-bucket-name/

# List buckets
gsutil ls

# Upload file
gsutil cp file.txt gs://bucket-name/

# Enable versioning
gsutil versioning set on gs://bucket-name/

# Set lifecycle policy (delete after 365 days)
gsutil lifecycle set lifecycle.json gs://bucket-name/
```

### Expert Insight

#### Real-world Application
In production environments:
- Use consistent naming conventions (e.g., `prod-backend-static-assets`)
- Implement Public Access Prevention for sensitive buckets
- Set retention policies for compliance (e.g., financial data)
- Use Nearline/Coldline for backups to reduce costs
- Implement lifecycle rules to automatically move data to cheaper storage classes

#### Expert Path
- Master gsutil CLI for automation scripts
- Learn Cloud Storage APIs for integration
- Understand signed URLs for secure temporary access
- Explore BigQuery integration for analytics on object metadata

#### Common Pitfalls
- **Non-unique bucket names**: Verify availability before creation
- **Wrong region selection**: Consider latency and data residency laws
- **Overlooking storage classes**: May lead to unexpected costs
- **Incorrect permissions**: Leaving buckets publicly accessible
- **Not enabling versioning**: Permanent loss of overwritten data
- **Missing retention policies**: Inability to meet compliance requirements

</details>