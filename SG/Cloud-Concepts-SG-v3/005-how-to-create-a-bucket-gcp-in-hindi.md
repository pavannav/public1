# How to Create a Bucket in GCP

<details open>
<summary><b>How to Create a Bucket in GCP (KK-CS45-script-v3)</b></summary>

# Session 5: How to Create a Bucket in GCP

## Table of Contents
- [Overview](#overview)
- [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
  - [Bucket Fundamentals](#bucket-fundamentals)
  - [Storage Classes](#storage-classes)
  - [Access Control and Permissions](#access-control-and-permissions)
  - [Object Versioning](#object-versioning)
  - [Retention Policies](#retention-policies)
  - [Lifecycle Rules](#lifecycle-rules)
- [Lab Demo: Creating a Bucket in GCP](#lab-demo-creating-a-bucket-in-gcp)
- [Summary](#summary)
  - [Key Takeaways](#key-takeaways)
  - [Quick Reference](#quick-reference)
  - [Expert Insight](#expert-insight)

## Overview
This session covers the process of creating a bucket in Google Cloud Storage (GCS), a foundational service for storing objects in Google Cloud Platform. You'll learn about bucket naming requirements, regional selection, storage classes, access control options, and advanced features like versioning and lifecycle management.

## Key Concepts and Deep Dive

### Bucket Fundamentals
- **Bucket Name**: Must be globally unique across all Google Cloud projects
- **Region/Location**: Geographic location where data is stored (e.g., Mumbai, Delhi)
- **Purpose**: Object storage for any type of data (files, images, etc.)

### Storage Classes
Choose based on data access frequency and retention needs:

| Storage Class | Use Case | Retrieval Cost |
|---------------|----------|----------------|
| Standard | Frequently accessed data, daily operations | Lowest |
| Nearline | Weekly/monthly access | Medium |
| Coldline | Quarterly access, long-term backup | Higher |
| Archive | Long-term archival (years), rarely accessed | Highest |

### Access Control and Permissions
- **Uniform (Bucket-level)**: Consistent permissions across all objects in bucket
- **Fine-grained (Object-level)**: Individual permissions per object
- **Public Access Prevention**: Controls external visibility

### Object Versioning
- Enables multiple versions of the same object
- Deleted objects move to versions list, not permanently removed
- Full restoration capability

### Retention Policies
- **Minimum Retention Period**: Data cannot be deleted before specified time
- **Audit/Compliance Data**: Prevent accidental deletion

### Lifecycle Rules
- Automatically move data between storage classes based on age
- Schedule deletion after defined periods
- Examples: Standard → Coldline after 1 year, delete after 2 years

## Lab Demo: Creating a Bucket in GCP

Follow these steps to create a GCS bucket via Google Cloud Console:

1. Navigate to **Cloud Storage** in GCP Console
2. Click **Create bucket**
3. Configure bucket settings:
   - **Name**: Choose globally unique name (e.g., your-project-test-bucket)
   - **Region**: Select appropriate location (e.g., asia-south1-mumbai)
   - **Storage Class**: Default to Standard, adjust based on access patterns
   - **Access Control**: Choose Uniform or Fine-grained
   - **Public Access**: Enable/disable based on security requirements
4. Advanced options:
   - **Versioning**: Enable for version control
   - **Retention Policy**: Set minimum retention periods
   - **Encryption**: Use Google-managed keys
   - **Lifecycle Rules**: Configure automatic transitions
5. Click **Create**

After creation:
- Upload files/folders via drag-and-drop or browse
- Create sub-folders for organization
- Configure requester pays for access billing

### Example Bucket Configuration

```yaml
bucket_name: my-unique-bucket-name
region: asia-south1 (Mumbai)
storage_class: STANDARD
access_control: uniform
public_access: prevented
versioning: enabled
retention_period: 365 days
lifecycle_rules:
  - condition: age > 365 days
    action: set_storage_class=COLDLINE
  - condition: age > 730 days
    action: delete
```

## Summary

### Key Takeaways
```diff
+ Bucket names must be globally unique
+ Choose region based on data access patterns and compliance
+ Storage classes balance cost and access speed
+ Fine-grained control offers more flexibility than uniform access
+ Versioning provides backup and restoration capabilities
+ Lifecycle rules automate cost optimization
+ Public access prevention enhances security
- Avoid overly complex lifecycle rules without testing
- Don't use Archive for frequently needed data due to high retrieval costs
! Always enable versioning for critical data
```

### Quick Reference
**GCS Console Navigation**: Cloud Storage → Buckets → Create bucket

**Common Storage Classes**:
- Standard: Frequent access
- Nearline: Monthly access
- Coldline: Quarterly access
- Archive: Annual access

**Best Practices**:
- Use descriptive, unique bucket names
- Match storage class to data lifecycle
- Enable versioning for important data
- Configure retention for compliance needs
- Use lifecycle rules for cost management

### Expert Insight

#### Real-world Application
In production environments, GCS buckets serve as the foundation for data lakes, static website hosting, backups, and microservice storage. Combine with other GCP services like Cloud Functions for automated processing or BigQuery for analytics.

#### Expert Path
Master bucket architecture by:
- Studying multi-region vs single-region deployment patterns
- Implementing Cloud Storage Uniform Access Control (UAC) for complex permissions
- Creating bucket templates using Google Cloud Deployment Manager
- Integrating with VPC Service Controls for enhanced security
- Optimizing costs through storage class transitions and lifecycle policies

#### Common Pitfalls
- **Global Uniqueness**: Forgotten bucket name reuse leading to conflicts
- **Region Selection**: Choosing far regions increasing latency unnecessarily
- **Access Misconfiguration**: Overly permissive settings exposing sensitive data
- **Storage Class Errors**: Selecting Archive for frequently accessed data causing high costs
- **Versioning Storage**: Enabled versioning without monitoring version count growth
- **Retention Overkill**: Setting overly long retention periods on temporary data

</details>