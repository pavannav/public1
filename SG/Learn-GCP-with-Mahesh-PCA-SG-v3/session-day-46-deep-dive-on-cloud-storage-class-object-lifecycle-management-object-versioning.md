# Session 46: Deep Dive on Cloud Storage Class, Object Lifecycle Management, Object Versioning

## Table of Contents
- [Deep Dive on Cloud Storage Class, Object Lifecycle Management, Object Versioning](#deep-dive-on-cloud-storage-class-object-lifecycle-management-object-versioning)
  - [Overview](#overview)
  - [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
    - [Cloud Storage Classes Overview](#cloud-storage-classes-overview)
    - [Creating Buckets with Different Storage Classes](#creating-buckets-with-different-storage-classes)
    - [Costs and Implications](#costs-and-implications)
    - [Object Lifecycle Management](#object-lifecycle-management)
    - [Object Versioning](#object-versioning)
    - [Soft Delete and Data Protection](#soft-delete-and-data-protection)
    - [Commands and Tools](#commands-and-tools)
- [Summary](#summary)
  - [Key Takeaways](#key-takeaways)
  - [Quick Reference](#quick-reference)
  - [Expert Insight](#expert-insight)

## Deep Dive on Cloud Storage Class, Object Lifecycle Management, Object Versioning

### Overview
This session explores Google's Cloud Storage classes, including standard multi-regional and regional options, as well as long-term storage like nearline, coldline, and archive. It covers their creation via UI and CLI, associated costs including retrieval fees, and advanced features such as object lifecycle management for automated actions (e.g., changing storage class or deletion), and object versioning for maintaining multiple versions of objects. Soft delete for temporary recovery and data protection options are also discussed, emphasizing cost optimization and data governance in Google Cloud Storage (GCS).

### Key Concepts and Deep Dive

#### Cloud Storage Classes Overview
Google Cloud Storage offers various storage classes to balance performance, availability, and cost:
- **Standard Storage Class**: Renamed from multi-regional and regional; used for frequently accessed data. No retrieval costs for multi-regional or regional usage.
- **Nearline Storage Class**: For backups or data accessed monthly; available in multi-regional or single-region configurations.
- **Coldline Storage Class**: Suitable for less frequent access, like archival data.
- **Archive Storage Class**: Lowest cost for long-term storage with access infrequently (e.g., years apart).

> [!IMPORTANT]  
> Long-term storage classes (nearline, coldline, archive) incur retrieval costs when data is accessed, differing from standard classes which have free retrieval.

#### Creating Buckets with Different Storage Classes
Buckets can be created in the Google Cloud Console UI or via CLI tools like GSUtil or gcloud storage. Key considerations include location type (multi-regional, dual-region, or single-region) and default access controls (uniform or fine-grained).

**Table: Storage Class Comparison**

| Storage Class | Retention Policy | Use Case | Multi-Regional/Single-Region | Retrieval Cost |
|---------------|------------------|-----------|------------------------------|----------------|
| Standard     | N/A              | Frequent access | Both                         | Free          |
| Nearline     | 30 days minimum | Monthly access | Both                         | Yes (per GB)   |
| Coldline     | 90 days minimum | Quarterly access | Both                      | Yes (per GB)   |
| Archive      | 365 days minimum | Annual access | Both                      | Yes (per GB)   |

- **UI Creation Example**: Choose bucket name (e.g., `pca-professional-cloud-architect-mr-nl`), set storage class (e.g., nearline), location (e.g., Asia for faster retrieval), and public access prevention. Default class is standard.
- **CLI Creation with GSUtil**:
  ```bash
  gsutil mb -c nearline -l asia-south1 gs://pcmca-mr-nl
  ```
  - `-c nearline`: Specifies storage class.
  - `-l asia-south1`: Specifies single-region location.
  - Default without `-c` is standard.
- **Cost Estimation**: UI and CLI provide estimates for storage and operations. Note: Locations affect costs; multi-regional adds replication fees.

> [!WARNING]  
> Region type (multi-regional vs. single-region) is immutable once set. Use single-region nearline for backups to minimize costs, while multi-regional suits data requiring high availability.

#### Costs and Implications
- **Storage Costs**: Increase from standard to archive; multi-regional adds replication costs.
- **Retrieval Costs**: Applicable only to nearline, coldline, and archive. Example: Nearline retrieval at ~1 cent per GB.
- **Operations Costs**: Class A (write/update operations) and Class B (read/metadata operations) are charged per 1,000 operations.
- **Early Deletion Penalties**: Deleting data before minimum retention (e.g., 30 days for nearline) incurs additional charges.
- **Pricing Changes**: Storage costs may fluctuate; always verify with official Google Cloud Pricing Calculator.

**Linear Flow: Cost Decision Process**
```
! Choose Use Case → Evaluate Access Frequency → Select Storage Class → Calculate Retrieval & Storage Costs → Implement Lifecycle Rules
```

> [!NOTE]  
> Nearline and coldline are ideal for backups; archive for compliance data. Multi-regional for global data resilience despite higher costs.

#### Object Lifecycle Management
Manages object storage automatically based on conditions like age, to optimize costs and compliance.

- **Key Conditions**: Age since creation or custom time, matching prefixes/suffixes, current storage class (e.g., only change if standard).
- **Actions**: Set to cooler class (e.g., coldline), delete, or manage multi-part uploads.
- **Rules Precedence**: Deletion overrides other changes; applied uniformly to current and future objects.
- **Ad-hoc Changes**: Use GSUtil `rewrite` for immediate class changes without 24-hour wait.
  ```bash
  gsutil rewrite -s coldline gs://bucket/object
  ```
- **Lifecycle Rules Setup**:
  - UI: Under bucket settings, add rules (e.g., age conditions and actions).
  - CLI: Use GSUtil or gcloud to set JSON-formatted rules.
  - Example: Change to nearline after 30 days, delete after 90 days.
- **Command Example**:
  ```bash
  gsutil lifecycle set lifecycle.json gs://bucket
  ```
  Where `lifecycle.json` defines rules like:
  ```json
  {
    "rule": [
      {
        "action": {"type": "SetStorageClass", "storageClass": "Nearline"},
        "condition": {"age": 30}
      }
    ]
  }
  ```

> [!WARNING]  
> Lifecycle rules enforce after 24 hours; for immediate ad-hoc changes (e.g., on project hold), use `rewrite` to avoid undue costs.

- **Prefix/Suffix Filters**: Apply rules to specific object patterns (e.g., images or videos).
- **Combination with Versioning**: Rules can target non-current versions.

#### Object Versioning
Maintains multiple versions of objects using generation numbers (epoch timestamps).

- **Enabling**: In UI (during bucket creation) or CLI:
  ```bash
  gsutil versioning set on gs://bucket
  ```
- **Behavior**: Uploads create new versions; originals become non-current.
- **Viewing Versions**: 
  - CLI: `gsutil ls -a gs://bucket` (shows all, including generation numbers).
  - UI: Revision history tab.
- **Restoration**: 
  ```bash
  gsutil cp gs://bucket/object#generation gs://bucket/object
  ```
  This creates a new current version.
- **Lifecycle Integration**: Define rules for non-current versions (e.g., delete after 7 days).
- **Utils**:
  - `gsutil stat`: Shows if an object is non-current via `Noncurrent-Time` field.
  - Epoch converter for generation numbers.

**Diff Example: Versioning Impact**
```diff
! Original Object (Live)
+ Version 2 (New Upload) → Original Becomes Non-Current
- Non-Current Versions Retained Based on Rules
```

> [!WARNING]  
> Without versioning, overwriting an object cannot be undone—lost data is permanent.

- **UI**: Turns on during bucket creation with auto-lifecycle (e.g., keep 2 versions, delete after 7 days).

#### Soft Delete and Data Protection
- **Soft Delete**: Default feature retaining deleted objects for 7-90 days for recovery.
- **Uniform vs. Fine-Grained Access**: Prefer uniform (bucket-level IAM) over fine-grained (object-level ACLs) for better visibility and management. Avoid fine-grained as it's legacy and deprecated.
- **Public Access Prevention**: Enforce at org or bucket level to prevent accidental exposure.
- **Mermaid Diagram: Access Control Flow**
  ```mermaid
  graph TD
    A[Bucket Creation] --> B{Fine-Grained or Uniform?}
    B --> C[Fine-Grained: Legacy, Object-Level ACLs]
    B --> D[Uniform: IAM-Controlled, Bucket-Level Security]
    C --> E[Hard to Track Public Objects]
    D --> F[Easy Visibility & Management]
  ```

- **Commands**:
  - Make object public (legacy): `gsutil acl ch -u allUsers:R gs://bucket/object`
  - Remove ACL: Adjust endings or rerun.

> [!IMPORTANT]  
> Always enable soft delete or versioning for data recovery. Avoid fine-grained access for modern GCS setups.

#### Commands and Tools
- **GSUtil vs. gCloud Storage**: GSUtil for legacy; gcloud for newer, parallel operations (use `-m` for multi-threading).
- **Wildcards**: Supports patterns (e.g., `gs://prefix*-suffix`) for bulk operations.
- **Helpful Commands**:
  - List objects: `gsutil ls gs://bucket`
  - Copy: `gsutil cp file gs://bucket/object`
  - Rewrite class: `gsutil rewrite -s newclass gs://bucket/object`
  - Lifecycle: `gsutil lifecycle set file.json gs://bucket`
  - Versioning: `gsutil versioning set on/off gs://bucket`
  - Stats: `gsutil stat gs://bucket/object`

### Summary

#### Key Takeaways
```diff
+ Standard storage classes have free retrieval; long-term classes (nearline/coldline/archive) charge per GB retrieval.
- Multi-regional storage offers high availability but adds replication costs; single-region is cost-effective for backups.
! Lifecycle management automates class transitions and deletions, applied after 24 hours—use rewrite for ad-hoc changes.
+ Versioning preserves object history using generation numbers; non-current versions can be auto-deleted via rules.
- Fine-grained access is deprecated; prefer uniform IAM for security and visibility.
+ Soft delete provides safety net for accidental deletions; enable versioning for ongoing protection.
```

#### Quick Reference
- **Storage Class Selection**: Frequent access → Standard; backups → Nearline/Coldline/Single-Region; archival → Archive.
- **Cost Agenda**: Use https://cloud.google.com/products/calculator for current pricing.
- **Rewrite Class Instantly**: `gsutil rewrite -s coldline gs://bucket/object`
- **Enable Versioning**: `gsutil versioning set on gs://bucket`
- **Check Lifecycle**: `gsutil lifecycle get gs://bucket`
- **Retrieve Version**: `gsutil cat gs://bucket/object#generation`

#### Expert Insight
**Real-world Application**: In data engineering, use nearline for ETL backups (accessed weekly) to control costs while ensuring 30-day retention minimizes penalties. Combine with BigQuery for analytics on live data, archiving cold datasets.

**Expert Path**: Master lifecycle rules by experimenting in sandbox projects; understand epoch timestamps for versioning backups. Pursue Google Cloud Architect certifications to integrate GCS deeply with compute services like App Engine.

**Common Pitfalls**: Ignoring soft delete leads to irreversible losses; mismatched locations cause migration complexity. Avoid fine-grained ACLs to prevent hidden exposures—audit buckets regularly.

**Lesser-Known Facts**: GCS auto-caches public objects for 1 hour, reducing costs on repeated access (not CDNs). Versioning uses microsecond-precision epochs for unique generations, enabling precise restores. Lifecycle rules can target custom metadata for advanced automation, e.g., expiring based on project end dates.

**Advantages and Disadvantages**
- **Advantages**: Scalable, durable storage with global replication (multi-regional); low-cost long-term options; automated management via lifecycles; versioning for version control without external tools.
- **Disadvantages**: Immutability can complicate direct edits; 24-hour lifecycle delay; retrieval costs add up for mistakenly archived data; regional limitations for compliance.
