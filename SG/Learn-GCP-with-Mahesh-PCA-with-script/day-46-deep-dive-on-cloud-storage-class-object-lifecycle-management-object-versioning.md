# Session 46: Deep Dive on Cloud Storage Class, Object Lifecycle Management, Object Versioning

## Table of Contents
- [Nearline, Coldline, and Archive Storage Classes](#nearline-coldline-and-archive-storage-classes)
- [Bucket Creation and Configuration](#bucket-creation-and-configuration)
- [Public Access Prevention and Access Control](#public-access-prevention-and-access-control)
- [Object Lifecycle Management Policies](#object-lifecycle-management-policies)
- [Object Versioning and Soft Delete](#object-versioning-and-soft-delete)

## Nearline, Coldline, and Archive Storage Classes

### Overview
Nearline, Coldline, and Archive are long-term storage classes in Google Cloud Storage (GCS) designed for data that is accessed infrequently. They offer lower storage costs compared to Standard or Regional classes but incur retrieval costs when accessing the data. These classes are ideal for backups, compliance data, or archival purposes where data availability is not critical in real-time scenarios.

### Key Concepts
These storage classes are optimized for cost efficiency in long-term storage, with trade-offs in retrieval speed and costs. Retrieval times are in milliseconds, differing from services like AWS Glacier that may involve longer waits. They can be deployed in multi-region, regional (single region), or dual-region configurations based on business needs, such as compliance or disaster recovery.

Nearline is suitable for data accessed once a month, Coldline for quarterly access, and Archive for annual or less frequent retrievals. All classes enforce a minimum storage period (e.g., 30 days for Nearline, 90 days for Coldline, 365 days for Archive), with early deletion penalties if removed prematurely.

#### Cost Implications
- **Storage Costs**: Lower than Standard classes (e.g., Nearline at ~1.5 cents per GB monthly).
- **Retrieval Costs**: Charged per GB retrieved (e.g., 1 cent per GB for Nearline from single regions).
- **Replication Costs**: Apply in multi-region setups.
- **Early Deletion**: Penalties for removing data before the minimum period.

| Storage Class | Min Period | Typical Use Case | Availability |
|---------------|------------|------------------|---------------|
| Nearline      | 30 days   | Backups (monthly access) | Multi-region/Single-region |
| Coldline      | 90 days   | CCTV footage, audits (quarterly) | Multi-region/Single-region |
| Archive       | 365 days  | Compliance, archival (annual) | Multi-region/Single-region |

Location configuration (multi-region, dual-region, single-region) impacts costs: single-region reduces replication fees but incurs retrieval costs from regional buckets. You cannot change location types after bucket creation; copy data to a new bucket if needed.

Demonstrate creation via UI or CLI:
```bash
# Create a Nearline bucket in Asia via CLI
gsutil mb -p PROJECT_ID -c nearline -l asia gs://BUCKET_NAME_NEARLINE

# Via gcloud (newer method)
gcloud storage buckets create BUCKET_NAME_NEARLINE --location=asia --storage-class=nearline
```

Buckets default to Standard class; specify class during creation. Use estimate tools in UI or calculate costs via pricing calculator.

## Bucket Creation and Configuration

### Overview
Creating GCS buckets involves specifying location, storage class, and access controls. Use UI for guided setups or CLI for automation. Commands shown for Nearline/Coldline/Archive creations, including multi-region vs. single-region options.

### Key Concepts
- **Location Impact**: Choose based on compliance (e.g., single-region for data locality, multi-region for high availability).
- **UI Creation**: Provides prompts for public access prevention; enforces uniform control by default.
- **CLI Differences**: UI enforces uniform access; CLI defaults to fine-grain (legacy); recommend overriding to uniform.
- **Commands**:
  - UI estimates costs real-time.
  - CLI: Use `gsutil` (older) or `gcloud storage` (newer) for transfers and retrievals.
  - Multi-threaded uploads/downloads: Append `-m` for efficiency.
  - Wildcards supported for pattern matching (e.g., `gs://prefix-*`).

Change default class post-creation using lifecycle policies or rewrite commands. For ad-hoc changes (e.g., due to project holds), use `gsutil rewrite` for immediate class changes without waiting 24 hours.

## Public Access Prevention and Access Control

### Overview
GCS emphasizes security; public access prevention blocks broad internet exposure. Use organizational policies for enforcement across projects. Balances data availability with security.

### Key Concepts
- **Uniform vs. Fine-Grain Access**: Uniform applies at bucket level (preferred; IAM-integrated). Fine-grain (legacy) allows object-level ACLs, leading to visibility issues and hidden exposures.
- **Recommendations**: Always use uniform; check defaults in UI (uniform), CLI (fine-grain—override), Terraform (fine-grain—specify), REST APIs (fine-grain—override).
- **Public Exposure**: For specific use cases, grant `storage.objectViewer` role to `allUsers` group.
- **Prevention Checks**: Buckets prompt for prevention; organization policies enforce it.
- **Command**: Make objects public using ACLs in fine-grain buckets (legacy):
  ```bash
  gsutil acl ch -u allUsers:R gs://BUCKET_NAME/OBJECT
  gsutil acl get gs://BUCKET_NAME/OBJECT  # Verify ACLs
  ```
  > [!IMPORTANT]  
  > Prefer uniform access for visibility and IAM integration. Avoid fine-grain for production.

## Object Lifecycle Management Policies

### Overview
Object Lifecycle Management automates class changes or deletions based on conditions (age, class match). Wait 24 hours post-application; prefer for planned scenarios over ad-hoc rewrites.

### Key Concepts
- **Rules**: Define actions (change class to colder, delete) with conditions (age, stored class, prefix/suffix).
- **Precedence**: Deletion overrides warmer class changes; colder classes override warmer ones.
- **Ad-Hoc Changes**: Use `gsutil rewrite -s NEW_CLASS gs://BUCKET/OBJECT` for immediate updates.
- **Default Commands**:
  ```bash
  # Get lifecycle
  gsutil lifecycle get gs://BUCKET_NAME
  
  # Set via JSON
  gsutil lifecycle set LIFECYCLE_JSON gs://BUCKET_NAME
  ```
- **Rules Structure**:
  - Age from creation/non-current time.
  - Supports prefix/suffix for filtering.
  - Actions: Set storage class (to colder), delete.

Example rule to delete objects >90 days:
```json
[
  {
    "action": {"type": "Delete"},
    "condition": {
      "age": 90
    }
  }
]
```

> [!NOTE]  
> 24-hour delay for policies; combine with versioning for non-current handling.

## Object Versioning and Soft Delete

### Overview
Versioning retains inactive versions upon updates; Soft Delete holds deleted objects for configurable periods (up to 90 days). Protects against accidental loss for backups, compliance data.

### Key Concepts
- **Versioning**: Enables via `gsutil versioning set on gs://BUCKET`. Uses generation numbers (epoch time) for versions.
- **Soft Delete**: Default 7-90 days retention; configurable in UI.
- **Restoration**:
  - UI: Use revision history to restore.
  - CLI: `gsutil cp gs://BUCKET/OBJECT#GENERATION gs://BUCKET/OBJECT` to restore.
- **Lifecycle Integration**: Manage non-current versions (e.g., keep last N versions, delete after days).
- **Commands**:
  ```bash
  # Enable versioning
  gsutil versioning set on gs://BUCKET_NAME
  
  # List all versions (including non-current)
  gsutil ls -a gs://BUCKET_NAME
  
  # Check if non-current (has "NoncurrentTime")
  gsutil stat gs://BUCKET_NAME/OBJECT#GENERATION
  ```
- **Best Practices**: Pair versioning with lifecycle rules; enabled by default in some UI bucket creations.

> [!IMPORTANT]  
> Versioning increases storage costs due to multiple versions; use lifecycle for cleanup.

## Summary

### Key Takeaways
```diff
+ Long-term storage classes (Nearline, Coldline, Archive) reduce storage costs but add retrieval fees—choose based on access frequency.
+ Always enforce uniform access control and versioning for security and recoverability.
+ Lifecycle policies automate class management; combine with versioning for version control.
! Prioritize data location and compliance needs; changes post-creation require copying data.
- Avoid early deletions to prevent penalties; use lifecycle rules for planned expunging.
```

### Expert Insight
**Real-World Application**: Implement lifecycle rules in archival buckets for regulated industries (e.g., finance audits). Use versioning for critical datasets where rollback is essential, ensuring IAM policies restrict access.

**Expert Path**: Master GCS pricing calculator for cost modeling; practice multi-region deployments for disaster recovery. Dive into gsutil vs. gcloud command differences through labs.

**Common Pitfalls**: 
- Overlooking retrieval costs in long-term classes—monitor via billing.
- Using fine-grain access leading to hidden exposures—enforce uniform via org policies.
- Not pairing versioning with lifecycle rules, causing unlimited versions and costs.

**Common Issues with Resolution**:
- Retrieval slowness misperception: GCS retrieval is sub-second; if delays, check networking.
- Bucket recreation for location changes: Copy data via `gsutil cp -r`; delete old bucket cautiously.
- Version overload: Implement lifecycle for non-current deletions; e.g., keep 2-3 versions max.

**Lesser-Known Things**:
- Soft delete's 90-day max retention differs from versioning (unlimited if unmanaged).
- UI additions like public access columns provide better visibility than CLI.
- Cache invalidation in public objects via query string extra chars; CDN offers better control. 

**Corrections Noted**:
- "Clazier" corrected to "Glacier" (AWS service mentioned).
- No other misspelling corrections needed (e.g., no "htp" to "http" or "cubectl" to "kubectl" instances). 
🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
