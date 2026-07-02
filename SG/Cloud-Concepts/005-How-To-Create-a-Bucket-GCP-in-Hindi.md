# Session 005: How To Create a Bucket in GCP

<details open>
<summary><b>Session 005: How To Create a Bucket in GCP (Claude Opus 4)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts](#key-concepts)
- [Lab Demo: Creating a Cloud Storage Bucket](#lab-demo-creating-a-cloud-storage-bucket)
- [Storage Classes](#storage-classes)
- [Bucket Configuration Options](#bucket-configuration-options)
- [Object Lifecycle Management](#object-lifecycle-management)
- [Summary](#summary)

## Overview
This session covers creating and configuring Google Cloud Storage buckets, including bucket naming, regional selection, storage classes, access permissions, versioning, and lifecycle management policies.

## Key Concepts

### Cloud Storage Buckets
Cloud Storage buckets are the fundamental containers for storing data in Google Cloud Storage. They provide a flat namespace for objects and serve as the unit of aggregation for usage statistics.

### Bucket Naming Requirements
- **Global Uniqueness**: Bucket names must be globally unique across all Google Cloud projects
- **Naming Rules**: Lowercase letters, numbers, hyphens, and underscores allowed
- **Length Constraints**: 3-63 characters for most buckets
- **DNS Compliance**: Must be valid for DNS naming if using domain-named buckets

### Regional vs Multi-Regional
- **Regional**: Data stored in a specific geographic region
- **Multi-Regional**: Data replicated across multiple regions for higher availability
- **Location Selection**: Choose locations close to users or compute resources

## Lab Demo: Creating a Cloud Storage Bucket

### Step 1: Access Cloud Storage
```
GCP Console → Cloud Storage → Buckets → Create Bucket
```

### Step 2: Configure Bucket Basics
```
Bucket Name: [globally-unique-name]
Check Availability: Verify name is not already taken
Location Type: Region (recommended for cost optimization)
Specific Region: Asia South 1 (Mumbai) or nearest region
```

### Step 3: Select Storage Class
Storage classes determine pricing and availability characteristics.

## Storage Classes

### Standard Storage
- **Use Case**: Frequently accessed data
- **Access Pattern**: Daily access expected
- **Best For**: Active data, frequently read/written objects
- **Pricing**: Highest storage cost, lowest access costs

### Nearline Storage
- **Use Case**: Data accessed less than once per month
- **Minimum Duration**: 30 days
- **Best For**: Backup data, rarely accessed archives
- **Pricing**: Lower storage cost with access charges

### Coldline Storage
- **Use Case**: Data accessed less than once per quarter (3 months)
- **Minimum Duration**: 90 days
- **Best For**: Long-term archives, disaster recovery data
- **Pricing**: Even lower storage cost with higher access charges

### Archive Storage
- **Use Case**: Long-term data archival
- **Minimum Duration**: 365 days
- **Best For**: Compliance archives, regulatory data retention
- **Pricing**: Lowest storage cost, highest access charges

## Bucket Configuration Options

### Access Control Options

#### Uniform Bucket-Level Access
- **Scope**: Applies permissions at bucket level
- **Inheritance**: All objects inherit bucket permissions
- **Use Case**: Simple permission management for entire bucket
- **IAM Integration**: Uses Identity and Access Management (IAM)

#### Fine-Grained Access Control
- **Scope**: Per-object permissions possible
- **Flexibility**: Different permissions for individual objects
- **Use Case**: Complex scenarios requiring object-level granularity
- **ACL Support**: Access Control Lists for individual objects

### Public Access Prevention
```
Default: Enabled (recommended for security)
Prevents: Public read access to bucket contents
Override: Can be disabled for public websites/static content
```

### Protection Tools

#### Object Versioning
- **Purpose**: Maintain multiple versions of objects
- **Behavior**:
  - Uploading new version moves old version to "noncurrent"
  - Old versions remain accessible for recovery
  - No automatic deletion of old versions
- **Cost Impact**: Additional storage costs for versioned objects
- **Use Case**: Accidental deletion protection, audit trails

#### Retention Policies
- **Purpose**: Prevent deletion for specified time period
- **Configuration**: Set retention period (e.g., 1 year)
- **Enforcement**: Objects cannot be deleted until retention expires
- **Use Case**: Regulatory compliance, legal hold requirements

### Data Encryption Options
- **Google-Managed Keys**: Default encryption (no setup required)
- **Customer-Managed Keys**: Use Cloud KMS for key management
- **Customer-Supplied Keys**: Provide your own encryption keys

## Object Lifecycle Management

### Purpose
Automatically transition objects between storage classes or delete them based on defined rules.

### Common Lifecycle Rules

#### Storage Class Transitions
```
Rule Example:
- After 365 days: Move from Standard to Coldline
- After 730 days: Move from Coldline to Archive
- Configuration: Time-based triggers with target storage class
```

#### Object Deletion
```
Rule Example:
- After 365 days: Delete audit logs
- Condition: Based on object creation date
- Purpose: Automatic cleanup of temporary data
```

### Lifecycle Rule Configuration
```json
{
  "lifecycle": {
    "rule": [
      {
        "action": {"type": "SetStorageClass", "storageClass": "COLDLINE"},
        "condition": {"age": 365}
      },
      {
        "action": {"type": "Delete"},
        "condition": {"age": 730}
      }
    ]
  }
}
```

## Upload and Management Operations

### Data Upload Methods
- **Individual Files**: Upload single objects
- **Folders**: Bulk upload with folder structure preservation
- **Transfer Jobs**: Large-scale data migration services

### Object Management Features
- **Create Folders**: Organize objects hierarchically
- **Move/Copy**: Transfer objects between buckets or within bucket
- **Metadata Management**: Set custom metadata on objects

## Summary

### Key Takeaways
```diff
+ Bucket names must be globally unique across GCP
+ Storage classes optimize costs based on access patterns
+ Uniform bucket-level access simplifies permission management
+ Object versioning protects against accidental deletion
+ Lifecycle policies automate storage optimization
+ Retention policies ensure compliance requirements
- Choosing wrong storage class impacts costs significantly
- Versioning increases storage costs proportionally
```

### Quick Reference
```bash
# Create bucket
gsutil mb -l REGION gs://BUCKET_NAME

# Set storage class
gsutil defstorageclass set STORAGE_CLASS gs://BUCKET_NAME

# Enable versioning
gsutil versioning set on gs://BUCKET_NAME

# Configure lifecycle
gsutil lifecycle set lifecycle.json gs://BUCKET_NAME

# Upload files
gsutil cp FILE gs://BUCKET_NAME
```

### Expert Insight

#### Real-world Application
- Implement tiered storage strategy with lifecycle policies
- Use regional buckets for applications in specific regions
- Enable versioning for critical data with retention policies
- Design bucket structure aligned with organizational boundaries

#### Expert Path
- Master transfer services for large-scale data migration
- Understand cross-region replication strategies
- Implement comprehensive data governance with labels and metadata
- Design cost optimization strategies using multiple storage classes

#### Common Pitfalls
- Using Standard storage for infrequently accessed archival data
- Not enabling versioning for critical production data
- Creating buckets in distant regions impacting performance
- Ignoring lifecycle policies leading to unnecessary storage costs
- Over-permissive bucket access controls

</details>