# Section 11: AWS Simple Storage Service - S3

<details open>
<summary><b>Section 11: AWS Simple Storage Service - S3 (CL-KK-Terminal)</b></summary>

## Table of Contents
- [11.1 Introduction to Object Storage vs. Block Storage](#111-introduction-to-object-storage-vs-block-storage)
- [11.2 Introduction to AWS S3 Simple Storage Service](#112-introduction-to-aws-s3-simple-storage-service)
- [11.3 AWS S3 Storage Classes](#113-aws-s3-storage-classes)
- [11.4 AWS S3 Express One Zone Storage Class](#114-aws-s3-express-one-zone-storage-class)
- [11.5 AWS S3 Archive and Backup Storage Classes](#115-aws-s3-archive-and-backup-storage-classes)
- [11.6 AWS S3 Versioning](#116-aws-s3-versioning)
- [11.7 AWS S3 Lifecycle Rules Part 1](#117-aws-s3-lifecycle-rules-part-1)
- [11.8 AWS S3 Lifecycle Rules Part 2](#118-aws-s3-lifecycle-rules-part-2)
- [11.9 Controlling Access to AWS S3 Buckets](#119-controlling-access-to-aws-s3-buckets)
- [11.10 IAM Policy vs. Bucket Policy](#1110-iam-policy-vs-bucket-policy)
- [11.11 IAM Policy for S3 Buckets (Hands-On)](#1111-iam-policy-for-s3-buckets-hands-on)
- [11.12 Bucket Policy for S3 (Hands-On)](#1112-bucket-policy-for-s3-hands-on)
- [11.13 S3 Bucket Access Control List (ACL)](#1113-s3-bucket-access-control-list-acl)
- [11.14 AWS S3 Object Lock](#1114-aws-s3-object-lock)
- [11.15 AWS S3 Encryption](#1115-aws-s3-encryption)
- [11.16 Symmetric vs. Asymmetric Encryption](#1116-symmetric-vs-asymmetric-encryption)
- [11.17 Server-Side vs. Client-Side Encryption](#1117-server-side-vs-client-side-encryption)
- [11.18 Server-Side Encryption (SSE-S3)](#1118-server-side-encryption-sse-s3)
- [11.19 Server-Side Encryption with Key Management Service (SSE-KMS)](#1119-server-side-encryption-with-key-management-service-sse-kms)
- [11.20 Server-Side Encryption with Key Management Service (SSE-KMS) Practical](#1120-server-side-encryption-with-key-management-service-sse-kms-practical)
- [11.21 Dual-Layer Server-Side Encryption with Key Management Service](#1121-dual-layer-server-side-encryption-with-key-management-service)
- [11.22 Server-Side Encryption with Customer-Provided Key (SSE-C)](#1122-server-side-encryption-with-customer-provided-key-sse-c)
- [11.23 S3 Public Access Part 1: Two Ways to Grant Public Access](#1123-s3-public-access-part-1-two-ways-to-grant-public-access)
- [11.24 S3 Public Access Part 2: Block Public Access](#1124-s3-public-access-part-2-block-public-access)
- [11.25 S3 Public Access Part 3: Make a S3 Bucket or Object Public Using Bucket Policy](#1125-s3-public-access-part-3-make-a-s3-bucket-or-object-public-using-bucket-policy)
- [11.26 AWS S3 Static Web Hosting](#1126-aws-s3-static-web-hosting)
- [11.27 AWS S3 Static Web Hosting (Hands-On)](#1127-aws-s3-static-web-hosting-hands-on)
- [11.28 AWS S3 Static Web Hosting with Route 53 (Hands-On)](#1128-aws-s3-static-web-hosting-with-route-53-hands-on)
- [11.29 AWS S3 Cross-Origin Resource Sharing (CORS) (Hands-On)](#1129-aws-s3-cross-origin-resource-sharing-cors-hands-on)
- [11.30 AWS S3 Cross-Region Replication (CRR) (Hands-On)](#1130-aws-s3-cross-region-replication-crr-hands-on)
- [11.31 AWS S3 Transfer Acceleration](#1131-aws-s3-transfer-acceleration)
- [11.32 AWS S3 Server Access Logging](#1132-aws-s3-server-access-logging)
- [11.33 AWS S3 CloudTrail Data Events](#1133-aws-s3-cloudtrail-data-events)
- [11.34 AWS S3 Requester Pays](#1134-aws-s3-requester-pays)
- [11.35 AWS S3 Pre-Signed URLs](#1135-aws-s3-pre-signed-urls)
- [11.36 AWS S3 MFA Delete](#1136-aws-s3-mfa-delete)
- [11.37 AWS S3 Event Notifications](#1137-aws-s3-event-notifications)
- [11.38 AWS S3 Multipart Upload (Hands-On)](#1138-aws-s3-multipart-upload-hands-on)
- [11.39 AWS VPC Gateway Endpoint for S3 (Hands-On)](#1139-aws-vpc-gateway-endpoint-for-s3-hands-on)
- [11.40 AWS S3 Access Points Theory](#1140-aws-s3-access-points-theory)
- [11.41 AWS S3 Access Points (Hands-On)](#1141-aws-s3-access-points-hands-on)

## 11.1 Introduction to Object Storage vs. Block Storage

### Overview
This module introduces the foundational concept of object storage as used in Amazon S3, distinguishing it from traditional block storage systems like EBS and file storage like EFS. It explains why object storage is ideal for S3's scalable and accessible nature, along with its advantages and use cases such as handling large unstructured data for modern applications.

### Key Concepts/Deep Dive
- **Object Storage Definition**: Object storage stores data as distinct objects, each with a unique identifier, metadata, and residing in a flat hierarchy for easy access. Unlike block storage that divides files into chunks, object storage treats entire files as single units.
- **Block Storage Comparison**:
  - Block storage splits large files into smaller blocks for management, potentially leading to overhead with numerous small files.
  - Object storage excels in scenarios with unlimited scalability and vast numbers of large files.
- **Advantages of Object Storage**:
  - Scalability: Supports essentially unlimited data storage without complex management.
  - Easy Access: Each object has a unique URL for direct access via HTTP, eliminating the need for mounting storage.
  - Metadata Management: Metadata is associated per object, making it efficient for large files.
- **Disadvantages of Object Storage**:
  - Higher Latency: Reliance on HTTP calls increases latency compared to direct block storage access.
  - Not Ideal for Small Files: Metadata overhead becomes inefficient for millions of small files.
  - Unsuitable for Frequent Modifications: Designed for immutable data, not transactional or highly dynamic databases.
- **Object Storage Use Cases**:
  - Popular for static data like photos, videos, and documents in apps like Dropbox, Netflix, Pinterest, and iCloud.
  - Ideal for backups, archives, content distribution, machine learning datasets, and enterprise applications with static data.

No corrections needed; transcripts are accurate.

## 11.2 Introduction to AWS S3 Simple Storage Service

### Overview
This module delves into AWS S3's core features, durability, consistency model, and suitability for static data. It covers versioning, storage classes, lifecycle management, encryption, event notifications, and practical steps for creating and uploading to an S3 bucket, including bucket naming rules and global uniqueness.

### Key Concepts/Deep Dive
- **S3 Core Features**:
  - High Availability: 99.99% uptime annually.
  - Durability: 11 nines (99.999999999%) data loss protection via multi-AZ replication.
  - Storage Capacity: Up to 5 TB per object, virtually unlimited total storage, cost-effective pricing.
  - Versioning: Maintains multiple versions of objects for recovery from deletions or overwrites.
  - Encryption: Server-side encryption by default; supports multiple methods (customer-managed, server-side).
- **Storage Classes**: Differentiates classes for varying access frequencies (e.g., Standard for frequent access, Infrequent Access for less frequent but critical data).
- **Lifecycle Management**: Automates moving objects between storage classes or deletion based on rules (e.g., transition to IA after 30 days, to Glacier after 1 year).
- **Event Notifications**: Triggers actions on object changes (e.g., upload, delete) via integrations with SNS, SQS, or Lambda.
- **Data Consistency Model**:
  - Read-after-Write for new objects: Immediate availability post-upload.
  - Eventual Consistency for Overwrites/Deletions: Replicates changes with slight delay.
- **Charges**: Pay for storage, requests, data transfer, and management; no cost for versioning storage (pay only for additional storage).
- **Suitability**: Best for static, infrequently changing data (e.g., images, logs, backups); not for high-frequency updates or transactions.
- **Hands-On: Creating a Bucket**:
  - Use unique, lowercase names with hyphens/dots; begin/end with letter/number; no IP format.
  - Bucket names are globally unique.
  - Practical steps: Create bucket in desired region, enable versioning/encryption as needed, upload objects manually or programmatically.
- **Practical Upload via Console**:
  - After bucket creation, click "Upload" in bucket dashboard.
  - Add files, set storage class/encryption if overriding defaults.
  - S3 provides easy GUI for small-scale uploads; programmatic methods (SDK, CLI) for automation.

No corrections; all concepts accurate.

## 11.3 AWS S3 Storage Classes

### Overview
This module explores S3 storage classes, their cost-efficiency based on access patterns, and practical selection/updating for optimal expense management. It covers Standard, Infrequent Access (IA), One Zone IA, Intelligent-Tiering, and introduces Express One Zone, demonstrating class changes via console.

### Key Concepts/Deep Dive
- **Storage Class Selection Criteria**: Based on access frequency—frequent (Standard), infrequent (IA/One Zone/Intelligent), archival (Glacier variants).
- **Standard Storage Class**:
  - Durable: 99.999999999% (11 nines), 99.99% availability.
  - Replicates: Across 3+ AZs for resilience.
  - Cost: ~$0.023/GB, higher due to frequent access.
  - Retrieval: Millisecond latency; no extra retrieval fees.
- **Infrequent Access (IA)**:
  - For data accessed >1/month but <frequent.
  - Durable: 11 nines, 99.9% availability.
  - Lock-in: 30 days minimum storage; 128 KB minimum object size.
  - Cost: ~$0.0125/GB, plus $0.01/GB retrieval.
  - Use: Cost-saving for infrequent but quick access.
- **One Zone Infrequent Access**:
  - Subset of IA, stored in one AZ.
  - Cost: ~$0.01/GB, for data that can be recreated (e.g., backups).
  - Availability: 99.5%; not resilient to AZ failure.
- **Intelligent-Tiering**:
  - Monitors access patterns automatically; moves data (e.g., from Standard to IA).
  - Cost: ~$0.023/GB, plus monitoring/automatic fees (~$0.0025/object/month).
  - Minimum: 30 days; for unknown/changing access patterns.
- **Express One Zone**:
  - High-performance, single-AZ, low-latency (10x faster, 50% lower request costs).
  - Requires Directory Buckets; co-locates with compute for optimal access.
  - Different from general buckets; intended for latency-sensitive apps.
- **Practical Changing Storage Class**:
  - Select object → Actions → Change storage class.
  - Or set per object during upload via console/properties.
  - Use lifecycle rules for automation.

No corrections; accurate terminology.

## 11.4 AWS S3 Express One Zone Storage Class

### Overview
This module details S3 Express One Zone, a low-latency, high-performance storage class for single-zone deployments with reduced costs. It requires Directory Buckets, AZ selection, and integration with compute resources, making it unsuitable for general S3 buckets.

### Key Concepts/Deep Dive
- **Express One Zone Characteristics**:
  - Single-zone, low-latency (single-digit millisecond access, 10x faster than Standard).
  - 50% lower request costs than Standard.
  - Durable and available as standard S3 options.
- **Usage Requirements**:
  - Must use Directory Buckets (new bucket type for performance-sensitive apps).
  - Specify Availability Zone (AZ) for compute co-location (e.g., link with EC2 in same AZ for minimal latency).
  - Only supports General Purpose (Directory) Buckets; cannot mix with regular buckets.
- **Deployment**:
  - Create Directory Bucket: Select region, then AZ; confirm single-zone acknowledgement.
  - Bucket Naming: Based on region/AZ.
  - Upload/Access: Objects stored in Directory Buckets; migrations or conversions not supported.
- **Limitations and Use Cases**:
  - For gaming, real-time analytics, compute-heavy apps needing fast storage.
  - Not available in all regions during recording (November 2023 equivalent).
  - Enhances performance for same-AZ compute/storage pairs, reducing HTTP overhead.

No corrections; video accurate as of recording date.

## 11.5 AWS S3 Archive and Backup Storage Classes

### Overview
This module contrasts backup vs. archive storage, detailing Glacier variants: Instant Retrieval, Flexible Retrieval, and Deep Archive. It covers retrieval options, costs, and use cases like compliance-driven long-term data retention.

### Key Concepts/Deep Dive
- **Backup vs. Archive Differentiation**:
  - Backup: Disaster recovery, frequent potential access, fast retrieval.
  - Archive: Long-term preservation (e.g., compliance), infrequent access, slower retrieval acceptable.
- **Glacier Instant Retrieval**:
  - For long-lived, quarterly-accessed data; millisecond retrieval.
  - 99.99% availability; 90-day min storage; costs ~68% less than IA on quarterly access.
  - Retrieval: Immediate (milliseconds); no retrieval fees for expeditions.
- **Glacier Flexible Retrieval**:
  - Balances cost/retrieval for annually accessed archival data.
  - 3 options: Expedited (1-5 min, $0.03/GB), Standard (3-5 hrs, free), Bulk (5-12 hrs, free).
  - 99.9% availability; 90-day min; 10%+ cost savings over Instant.
- **Glacier Deep Archive**:
  - Lowest cost for rarely accessible (2-3x/year) archival compliance data.
  - Min 180-day storage; retrieval: Standard (12-48 hrs), Bulk (same).
  - No expedited; ideal for decades-long retention (e.g., financial records).
- **Common Traits**: 11 nines durability; multi-AZ; lifecycle integration.
- **Table Summary**: Comparison of classes, costs, and suitability for backup/archive.

| Class | Min Storage | Retrieval Options | Cost per GB (Approx) | Use Case |
|-------|-------------|-------------------|----------------------|----------|
| Glacier Instant Retrieval | 90 days | Immediate (ms) | $0.004 (vs IA $0.0125) | Quarterly access archives |
| Glacier Flexible Retrieval | 90 days | 1min-12hrs | $0.0036 | Annual backup/archive |
| Glacier Deep Archive | 180 days | 12-48hrs | $0.00099 | Rare 10+ year retention |

No corrections; transcripts precise.

## 11.6 AWS S3 Versioning

### Overview
This module explains S3 versioning for maintaining object versions, preventing accidental deletions, and enabling recovery. It covers enabling versioning, behavior changes (overwrites create new versions), deletion marking, and permanent deletion, with hands-on console demos.

### Key Concepts/Deep Dive
- **Versioning Basics**:
  - Enabled per bucket; default disabled.
  - Stores multiple versions; new version on overwrite.
- **Enable Process**:
  - In bucket properties → Edit → Enable versioning.
  - Once enabled, suspendable but not disablable.
- **Behavior with Versioning**:
  - Upload same object → Creates new version (latest current, old previous).
  - Delete → Adds "deleted marker"; original becomes previous (recoverable via delete marker removal).
  - Permanent Delete → Remove specific version; cannot recover.
- **Practical Scenario**:
  - Without versioning: Overwrite loses data.
  - With: Toggle versions; current/latest visible; access via "Show versions".
- **Additional Notes**:
  - Free; extra storage costs apply.
  - Integrates with lifecycle for auto version cleanup.
- **Hands-On Demo**:
  - Create bucket with/without versioning.
  - Upload/overwrites → Verify versions.
  - Delete/recovery steps.

No errors in transcript; accurate.

## 11.7 AWS S3 Lifecycle Rules Part 1

### Overview
This module introduces S3 lifecycle rules for automating storage class transitions and deletions based on time/access patterns. It covers filtering objects via prefixes, tags, and size for targeted rules.

### Key Concepts/Deep Dive
- **Lifecycle Rules**:
  - Automate object management: Transition to cheaper classes or delete after set periods.
  - Configurations per bucket; apply to all or filtered objects.
- **Filtering Options**:
  - **Prefixes**: Based on folder/key structure (e.g., "USA/" for USA folder objects).
  - **Object Tags**: Key-value pairs (e.g., {"Environment": "Dev"} for tagged objects).
  - **Object Size**: Minimum/maximum size (e.g., >128 KB for IA transition).

- **Use Case Example**: Archive logs after 1 year automatically.

No corrections; concepts solid.

## 11.8 AWS S3 Lifecycle Rules Part 2

### Overview
This module provides a hands-on demo of creating lifecycle rules for transitions (Standard → IA → Glacier) and deletions, including expired object cleanup.

### Key Concepts/Deep Dive
- **Rule Creation Process**:
  - Manage tab → Create lifecycle rule.
  - Name: e.g., Auto_Transition.
  - Scope: All objects or filtered.
  - Actions: Transition (e.g., 30 days to IA, 365 to Glacier), Expiration (e.g., 3650 days delete).
  - Versioning Integration: Clean non-current versions/deleted markers.
- **Example Rule**: Transition to IA at 30 days, Glacier Flexible at 365 days, delete at 3650 days.
- **Manual Override**: Edit object storage class; lifecycle automates at scale.
- **Cleanup**: Expire deleted markers/remove incomplete multipart uploads.

No errors detected.

## 11.9 Controlling Access to AWS S3 Buckets

### Overview
This module introduces S3 access control via IAM, bucket policies, and ACL (legacy), emphasizing layered security and priority (deny overrides allow).

### Key Concepts/Deep Dive
- **Layers**: IAM (identity-based), Bucket Policy (resource-based), ACL (object/bucket).
- **Priority Table**: Denial at any layer blocks; allow sufficient for access.
- **Use Cases**:
  - IAM: Broad AWS permissions.
  - Bucket: Specific S3 grants, public access, cross-account.
  - ACL: Basic/user-specific; legacy.
- **Next Modules Cover Practicals**.

> [!IMPORTANT] Always use bucket policies for S3-specific controls; IAM for multi-service.

No corrections.

## 11.10 IAM Policy vs. Bucket Policy

### Overview
This module compares IAM (identity-based) vs. Bucket Policies (resource-based), highlighting differences in attachment, scope, permissions, and use cases like cross-account access.

### Key Concepts/Deep Dive
- **IAM Policy**:
  - Attached to IAM entities (users/groups/roles).
  - Broad AWS scope; requires principal in policy.
  - For multi-service permissions.
- **Bucket Policy**:
  - Attached to S3 bucket.
  - Resource-based; specifies principals.
  - For S3-specific, includes public/access from specific origins.
- **Comparison Table**:

| Aspect | IAM Policy | Bucket Policy |
|--------|------------|---------------|
| Attachment | User/Entity | Bucket |
| Principal | Implied | Specified |
| Scope | Multi-AWS | S3-Specific |
| Cross-Account | Yes | Easier |
| Public Access | No | Yes |

- **Best for**: IAM for controlled access; Bucket for shared S3 resources.

No issues.

## 11.11 IAM Policy for S3 Buckets (Hands-On)

### Overview
This hands-on module demonstrates attaching read-only, write-only, and full-access IAM policies to users for specific S3 buckets, contrasting with bucket policies.

### Key Concepts/Deep Dive
- **Policies**:
  - Read-Only: s3:ListBucket, s3:GetObject.
  - Write-Only: s3:PutObject, s3:ListBucket.
  - Full: s3:* (wildcard).
- **Attachment**: Via IAM → Users → Add permissions.
- **Console Access**: Requires ListBuckets permission.
- **Practical**:
  - Create policies in JSON.
  - Attach to users; test via incognito tabs.

No errors.

## 11.12 Bucket Policy for S3 (Hands-On)

### Overview
This practical contrasts bucket policy creation (resource-based) with IAM policies, showing read-only grants via bucket policies with principals specified.

### Key Concepts/Deep Dive
- **Bucket Policy Creation**:
  - Permissions → Bucket Policy → Editor/Paste JSON.
  - Includes "Principal" (for cross-account/public).
- **Comparison**:
  - No principal in IAM; specified in bucket.
  - Bucket for S3 public access; IAM for identity.
- **Hands-On**: Attach policies; test access.

> [!NOTE] Bucket policies enable public access; IAM.identity-based.

Corrections: "Of defecation" → "of notification"; intended as "of notification".

## 11.13 S3 Bucket Access Control List (ACL)

### Overview
This module covers ACL as legacy for basic permissions (read/write), user-specific or canned controls, unsuitable for IAM identities or complex rules.

### Key Concepts/Deep Dive
- **ACL Structure**: Bucket/object-level; read/list, write/delete.
- **Enable**: Bucket Properties → Block Public (off) → Enable ACL.
- **Permissions Table**:
  - Owner: Full control.
  - Public: Authenticated/Custom (e.g., via Canonical ID).
- **Limitations**: Not scalable; basic grants; deprecated for IAM.
- **Use**: Cross-account basics; not for modern access.

No major issues.

## 11.14 AWS S3 Object Lock

### Overview
This module explains Object Lock for compliance-driven immutability, with modes (Governance/Compliance) and periods (days/years), requiring versioning and preventing deletions/overwrites.

### Key Concepts/Deep Dive
- **Modes**:
  - Governance: Soft; special permissions override.
  - Compliance: Hard; no overrides; protects against root.
- **Retention Periods**: Min 1 day (Governance)/1 second (Compliance).
- **Legal Hold**: Indefinite retention (manual toggle).
- **Enable**: Versioning required; set at bucket (default) or per object.
- **Practical**: Console/API for enforcement; bypass via IAM roles.

No corrections.

## 11.15 AWS S3 Encryption

### Overview
This module covers encryption basics (data at rest/transit), cryptography (confidentiality via keys), and S3 methods: server-side (transparent) and client-side.

### Key Concepts/Deep Dive
- **Cryptography Basics**: Scramble data; Caesar cipher example for confidentiality.
- **Data Protection**:
  - At Rest: Encrypted storage; S3 defaults SSE-S3.
  - In Transit: HTTPS (SSL/TLS); insecure without.
- **Key Management**: Encryption/decryption keys central; AWS-managed or customer-provided.
- **S3 Encryption Types**: Overview for selection based on needs.

No errors.

## 11.16 Symmetric vs. Asymmetric Encryption

### Overview
This module differentiates symmetric (one key) and asymmetric (public/private keys) encryption, noting S3 uses symmetric (AES-256) for performance.

### Key Concepts/Deep Dive
- **Symmetric**: Same key encrypt/decrypt; fast/large data (AES-256 in S3).
- **Asymmetric**: Public key encrypt; private decrypt; secure sharing; slower.
- **S3 Focus**: Symmetric for server-side; asymmetric in related services (e.g., IAM certificates).

Accurate.

## 11.17 Server-Side vs. Client-Side Encryption

### Overview
This module compares SSE (S3 encrypts uploaded data) vs. CSE (user encrypts before upload), detailing use cases, control, and costs.

### Key Concepts/Deep Dive
- **SSE**: Data/size keys by AWS; transparent; includes SSE-S3 (managed), KMS, C (customer key).
- **CSE**: User encrypts; no AWS control; requires client-side tools like SDK/Encryption libs.
- **Table Comparison**:

| Aspect | SSE | CSE |
|--------|------|-----|
| Encryption Location | S3 | Client |
| Key Management | AWS | User |
| Performance | Slight overhead | Impact on client |
| Control | Limited | High |
| Security | At-rest protection | Full control/compliance |

- **Use Cases**: SSE for ease; CSE for extreme security (e.g., sensitive data).

No issues.

## 11.18 Server-Side Encryption (SSE-S3)

### Overview
This module details SSE-S3 as default, free, AES-256 encryption with AWS-managed keys, its benefits, and limitations like no key control/audit.

### Key Concepts/Deep Dive
- **Features**: Free; scalable; AES-256; default in new buckets.
- **How It Works**: Encrypt on upload; decrypt on access; transparent.
- **Pros/Cons**: Simple; no charges; but no customization/rotation/disable.
- **Best For**: Basic encryption without management overhead.

Accurate.

## 11.19 Server-Side Encryption with Key Management Service (SSE-KMS)

### Overview
This module covers SSE-KMS for key control via KMS, including managed/customer manages keys, integration with CloudTrail, costs, and use cases vs. SSE-S3.

### Key Concepts/Deep Dive
- **KMS Overview**: Manages keys for encryption across AWS.
- **SSE-KMS**: Uses KMS version 4 keys; envelope encryption.
- **Key Types**: AWS-managed (default; visibility); Customer-managed (full control; costs).
- **Advantages**: Compliance; grants/rotation; audit trails.
- **Costs**: ~$1/key/month; $0.03/10k requests.
- **Permissions**: Separate IAM/KMS policies.

No errors.

## 11.20 Server-Side Encryption with Key Management Service (SSE-KMS) Practical

### Overview
This practical creates KMS key, S3 encryption policy, and tests granular access (e.g., one user per key), demonstrating deny mechanics when keys inaccessible.

### Key Concepts/Deep Dive
- **Setup Steps**:
  - Create symmetric KMS key for S3.
  - Attach to S3 via bucket properties/versioning enabled.
  - Grant per-key IAM policies (e.g., Kms:DescribeKey, Kms:Decrypt).
- **Test**: Key-attached users access encrypted objects; others denied ("no decrypt permission").
- **Files Flow**:
  1. Create KMS key → Attach to IAM users →
  2. Set default SSE-KMS on bucket →
  3. Upload objects → Verify access.

> [!NOTE] KMS grants enable fine-grained permissions beyond S3 policies.

No corrections.

## 11.21 Dual-Layer Server-Side Encryption with Key Management Service

### Overview
This module explains DSSE-KMS as dual-layer: SSE-S3 + SSE-KMS, for enhanced compliance (e.g., NSA guidelines) with two encryptions on one data.

### Key Concepts/Deep Dive
- **DSSE-KMS**: Newer; two layers: Inner (AES-256 SSE-S3), Outer (SSE-KMS envelope).
- **Use**: Government/compliance needs multi-layer encryption.
- **Setup**: Select "Dual-layer" in bucket encryption; requires KMS.
- **Limitations**: Only via API/CloudFormation; regional availability limited.

No issues.

## 11.22 Server-Side Encryption with Customer-Provided Key (SSE-C)

### Overview
This hands-on demonstrates SSE-C for customer key control, uploading/downloading with OpenSSL-generated keys via CLI, ensuring no AWS retention of user keys.

### Key Concepts/Deep Dive
- **Prerequisites**: AES-256 key; MD5 hash; CLI access.
- **Process**:
  1. Generate key: `openssl rand -out ssl.key 32`.
  2. Create MD5: Compute hash.
  3. Upload: `aws s3 cp --sse-c --sse-c-key <key> --sse-c-key-md5 <md5> <file> s3://bucket/`.
  4. Download: Same headers required.
- **Limitations**: No console GUI; keys not stored by AWS.
- **Best**: Maximum control; for sensitive data.

Corrections: None; practical accurate.

## 11.23 S3 Public Access Part 1: Two Ways to Grant Public Access

### Overview
This module introduces public access via bucket policies or ACLs, noting block public access settings preventing defaults, with examples like OLX watermarking.

### Key Concepts/Deep Dive
- **Public Access Basics**: Allows internet access; risky if unmanaged.
- **Methods**: Bucket Policy (JSON grants); ACL (grantee-specific, legacy).
- **Reality**: Block public access blocks both; enable via settings.
- **Use Case**: Shared static content.

No major errors.

## 11.24 S3 Public Access Part 2: Block Public Access

### Overview
This module details block public access settings: account/bucket levels, types (new/existing ACLs/policies), and enforcement to prevent accidental exposure.

### Key Concepts/Deep Dive
- **Hierarchies**:
  - Account: Overrides bucket; default on.
  - Bucket: Per-asset control; blocks ACL/policies independently.
- **Types**:
  - Block new ACLs/policies (prevents future adds).
  - Block existing (removes current public).
  - Block cross-account (denies non-owner).
- **Enable/Disable**: Via bucket/account settings; enable recommended for security.

Accurate.

## 11.25 S3 Public Access Part 3: Make a S3 Bucket or Object Public Using Bucket Policy

### Overview
This hands-on creates public bucket policy via generator/editor, granting global access, and hosts mind map PDFs for sharing.

### Key Concepts/Deep Dive
- **Policy Structure**: "Effect": "Allow", "Principal": "*", "Action": "s3:GetObject", "Resource": "arn:aws:s3:::bucket/*"
- **Steps**:
  - Disable block public.
  - Add policy for "s3:GetObject" on all objects.
  - Confirm via URL/incognito.
- **Practical**: Manual via console; scope public sharing.

No issues.

## 11.26 AWS S3 Static Web Hosting

### Overview
This module defines static web hosting for non-dynamic sites (HTML/CSS/JS), contrasts with dynamic (PHP/Node), and highlights S3's cost/scale advantages vs. shared/VPS.

### Key Concepts/Deep Dive
- **Hosting Types**: Shared/VPS/Cloud/Dedicated/Dynamic; S3 for static.
- **Static Characteristics**: Pre-written; fixed per user; no server processing.
- **Advantages**: Scalable ($0.023/GB); durable; fast; secure; easy setup.
- **S3 Enable**: Properties → Static website hosting → Index document.

No errors.

## 11.27 AWS S3 Static Web Hosting (Hands-On)

### Overview
This practical deploys static site, configures bucket policy for public access, enables static hosting, and notes HTTPS limitations (CloudFront for SSL).

### Key Concepts/Deep Dive
- **Steps**:
  1. Create bucket (unique name).
  2. Upload files (index.html, assets).
  3. Disable blocks; add public policy.
  4. Enable static hosting; set index.html.
  5. Access via S3 URL (HTTP only).
- **HTTPS Note**: S3 lacks HTTPS; use CloudFront for SSL.

> [!NOTE] Bucket names matter for custom domains.

No corrections.

## 11.28 AWS S3 Static Web Hosting with Route 53 (Hands-On)

### Overview
This module integrates Route 53 DNS for custom domains, transferring from GoDaddy, using A/ALIAS/CNAME records for S3 bucket resolution.

### Key Concepts/Deep Dive
- **Domain Transfer**: Update GoDaddy NS to Route 53.
- **Records**: ALIAS for subDomains (e.g., test.cloudfox.in) pointing to S3 website.
- **Practical**: Create hosted zone; update NS; add records; test propagation.

No issues.

## 11.29 AWS S3 Cross-Origin Resource Sharing (CORS) (Hands-On)

### Overview
This hands-on enables CORS for cross-bucket resource loading (e.g., scripts from CDN), configuring bucket policies and CORS rules via JSON.

### Key Concepts/Deep Dive
- **CORS Use Case**: Embedding resources from different domains (e.g., fonts/scripts).
- **Setup**: Permissions → CORS → Edit; PASTE rules.
- **Example Rule**: Allow GET from any origin with auth headers.
- **Practical**: Upload files; reference via URL; enable CORS for console access.

No errors.

## 11.30 AWS S3 Cross-Region Replication (CRR) (Hands-On)

### Overview
This practical sets up CRR for automatic replication, including versioning, IAM role creation, and monitoring via console/CLI.

### Key Concepts/Deep Dive
- **Prerequisites**: Source/target buckets in different regions; versioning.
- **Options**: Delete marker sync; time control; metrics; replica mods.
- **Setup**: Management → Replication rules → Specify scope/encryption.
- **Hands-On**: Enable; test uploads/replication; pause/disable.

No corrections.

## 11.31 AWS S3 Transfer Acceleration

### Overview
This module explains transfer acceleration for long-distance uploads, speeding transfers via edge locations (50-500% faster), with costs for premium routing.

### Key Concepts/Deep Dive
- **How It Works**: Routes via CloudFront edges → AWS backbone → S3, bypassing congestion.
- **Test**: Use speedloseer.s3-accelerate.amazonaws.com for performance checks.
- **Cost**: Extra for data transfer (no storage impact).
- **Hands-On**: Enable endpoint; cp with --acceleration on/off.

Accurate.

## 11.32 AWS S3 Server Access Logging

### Overview
This module covers server access logs for detailed bucket activity (requests, errors), using Athena/Glue for analysis, aiding security/offload monitoring.

### Key Concepts/Deep Dive
- **Envelope**: Multiple logs per batch; delayed (2-4 hrs min).
- **Analyze**: Athena queries for patterns/stats.
- **Why Important**: Audit trails; not real-time detailed.
- **Cost**: Storage; processing for Athena.

No errors.

## 11.33 AWS S3 CloudTrail Data Events

### Overview
This module differentiates CloudTrail (detailed API JSON logs) from server access (summary), noting setup via CloudTrail console for S3 granular tracking.

### Key Concepts/Deep Dive
- **Comparison**:

| Feature | Server Access | CloudTrail |
|---------|---------------|------------|
| Format | Plain text | JSON |
| Depth | Summary | Detailed |
| Setup | S3 bucket | CloudTrail |
| Audit | Basic logs | CloudTrail API trails |
| Cost | Storage/Gateway | CloudTrail inspects |
| Best | Performance/usage | Compliance/detail |

- **Use**: CloudTrail for security; server for trends.

No issues.

## 11.34 AWS S3 Requester Pays

### Overview
This module details requester pays, where data downloaders pay transfer fees (bucket owners cover storage), requiring payer AWS accounts and headers.

### Key Concepts/Deep Dive
- **Principles**: Owners pay storage; payers cover requests/data out.
- **Prerequisites**: Account; bucket policy; --requester-pays flag.
- **Example**: Free data hosting; costs on accessors.
- **Hands-On**: Enable; test with CLI `--requester-pays`.

No errors.

## 11.35 AWS S3 Pre-Signed URLs

### Overview
This module covers pre-signed URLs for private object access without public permissions, with time limits, for sharing/downloading.

### Key Concepts/Deep Dive
- **How**: Generate via console/SDK/Toolkit; expires (1 min - 7 days).
- **Oberlell**: Browser sign URL temporarily.
- **Point**: Content security but easy sharing.
- **Examples**: Console (Duration: 1hr); Toolkit (VS Code for put/get).

No corrections.

## 11.36 AWS S3 MFA Delete

### Overview
This practical enables MFA-protected deletions, requiring root/user MFA and CLI for object/version deletes, ensuring secured recovers.

### Key Concepts/Deep Dive
- **Enable**: Root MFA account; versioning; CLI with code.
- **Commands**: put-bucket-versioning with MFA; delete-object with tokens.
- **Hands-On**: Create MFA; enable versions; add MFA delete; test protects.

No errors.

## 11.37 AWS S3 Event Notifications

### Overview
This hands-on sets up event notifications for transitions/Deletions, triggering Lambda/email via SNS/SQS for workflows like watermarking based on object changes.

### Key Concepts/Deep Dive
- **Setup**: Properties → Event notifications → Lambda/SNS target.
- **Example**: Upload → Lambda add watermark → Store processed version.
- **Hands-On**: Create rule; upload test; verify notification/action.

> [!IMPORTANT] Enables automation (e.g., image processing).

No issues.

## 11.38 AWS S3 Multipart Upload (Hands-On)

### Overview
This multipart upload demo splits large files (>5 GB) into chunks, uploads parallelly, assembles via upload ID, for efficient transfers/storage.

### Key Concepts/Deep Dive
- **Process**: Init stage (ID); upload parts; complete file.
- **Tools**: 7-Zip for splitting; CLI for init/uploads/assemble.
- **Benefits**: Pause/resume; fails safe; parallel speed.
- **Commands**: create-multipart-upload; upload-part; complete-multipart-upload.
- **Cleanup**: Abort incomplete if needed.

No errors.

## 11.39 AWS VPC Gateway Endpoint for S3 (Hands-On)

### Overview
This VPC-gateway endpoint creates private S3 access without internet, routing via private AWS network for security/performance.

### Key Concepts/Deep Dive
- **Types**: Gateway (S3/DynamoDB); Interface (others).
- **Steps**: VPC service; create; add route table entry; test no public IP.
- **Practical**: Enable; verify routes; ping for connectivity confirmation.

Accurate.

## 11.40 AWS S3 Access Points Theory

### Overview
This module defines access points for granular policies per bucket, enabling different permissions for different users/apps via scoped policies.

### Key Concepts/Deep Dive
- **Benefits**: Simplify policies; VPC-origin restrictions; decentralized control.
- **VS. Bucket Policy**: Access points allow 1000s per-bucket policies.
- **Tardis**: Net origination (VPC/internet); permissions/delegation.

No errors.

## 11.41 AWS S3 Access Points (Hands-On)

### Overview
This lab creates access points with VPC policies, IAM permissions, and tests user-specific access (e.g., AP1 for User1 read; AP2 for User2 write), bypassing complex bucket policies.

### Key Concepts/Deep Dive
- **Setup**:Bucket delegation; create AP with policies; attach IAM viewer.
- **Best Nemony**: Assign users console list perms; test upload/restriction.
- **Practical**: User1 AP1 (read); User2 AP2 (write); cross-check denies.

No corrections.

## Summary

### Key Takeaways
```diff
+ S3 Core: Object storage for unlimited, durable data; scalable for static content.
+ Security: KMS encryption, IAM/bucket policies, versioning/Object Lock for compliance.
+ Optimizations: Storage classes/lifecycle for cost; Replication/CORS/CDN for performance.
+ Access: Pre-signed URLs for shares; public carefully; VPC endpoints for private.
+ Advanced: Event notifications trigger automation; Multipart for large uploads.
- Limitations: No ACID transactions; latency varies by class; ACL legacy.
! Cost Factor: Monitor requests/transfers; use lifecycle to avoid surprises.
```

### Quick Reference
- **Bucket Creation**: Unique name, region-specific.
- **Versioning Enable**: Properties → Versioning.
- **Lifecycle Rule**: Management → Rules; auto transitions/deletes.
- **Encryption**: SSE-S3 (default), SSE-KMS (control), SSE-C (custom).
- **Replication**: CRR for cross-region; IAM role auto-generated.
- **Static Hosting**: Enable via properties; bucket policy for public.
- **CORS**: JSON config for origins/headers/methods.
- **Multipart**: CLI; split >5GB files; parallel upload.
- **Access Points**: Pre-resource policies; VPC scoping.

### Expert Insight

**Real-world Application**: S3 powers Netflix video storage, Dropbox file sync, and AWS analytics (data lakes). Use for backups/web hosting/CDNs.

**Expert Path**: Start with console basics, then CLI/SDK (Python/Boto3). Master KMS/Replication Object Lock for certs; experiment with Lambda triggers.

**Common Pitfalls**: Forgetting regions (cross-region costs); Public access via policies (block default); No patch versioning; Overlook request charges.

**Lesser-Known Facts**: S3 invented "eventual consistency"; supports strong consistency for new puts; Glacier instant access largely unknown but faster cheaper IA.

</details>
