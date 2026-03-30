# Session 45: Cloud Storage Concepts, Deep Dive on Standard, Nearline, Coldline, Archive Storage Class

## Table of Contents
- [Overview of Data Categories](#overview-of-data-categories)
- [Benefits of Google Cloud Storage Over Persistent Disks](#benefits-of-google-cloud-storage-over-persistent-disks)
- [Google Cloud Storage Fundamentals](#google-cloud-storage-fundamentals)
- [Storage Classes Deep Dive](#storage-classes-deep-dive)
- [Demos and Configurations](#demos-and-configurations)

## Overview of Data Categories
Data is the core fuel of modern computing and analytics. This section categorizes data into three primary types based on structure and usage: structured, semi-structured, and unstructured data. Understanding these categories helps determine the most appropriate storage and database solutions, with Google Cloud offering tailored products for each type—SQL databases for structured, no-SQL for semi-structured, and Cloud Storage for unstructured data.

## Key Concepts of Data Categories
### Structured Data
- **Definition**: Data with a fixed schema, often in tabular form (e.g., CSV files, databases).
- **Examples**: Employee records in a spreadsheet or Oracle/MySQL databases.
- **Querying**: Easy to query using standard SQL due to clean, predefined columns.
- **Usage**: Ideal for transactional systems where row structures remain consistent.

### Semi-Structured Data
- **Definition**: Data with flexible schemas, common in logs and event-driven data where fields vary per entry.
- **Examples**: Application logs from Cloud Run or Cloud Functions, including fields like timestamp, severity, and payload, which may differ across entries.
- **Querying**: Better suited for no-SQL databases (e.g., BigQuery or Firestore) that handle variable columns without predefined schemas.
- **Rationale**: Traditional RDBMS would require dynamic table alterations, making no-SQL more efficient.

### Unstructured Data
- **Definition**: Data without a predefined structure, such as multimedia or human-generated content.
- **Examples**: Images, videos, audio files, PDFs, social media posts, and voice notes.
- **Usage**: Cannot be stored efficiently in databases; blob storage like Google Cloud Storage is essential.
- **Statistics**: Estimates show 80-90% of world's data is unstructured, emphasizing the need for scalable storage solutions.

| Data Category    | Example                  | Suitable Storage             | Query Capability |
|------------------|--------------------------|------------------------------|------------------|
| Structured      | CSV, Database Tables    | SQL Databases (Cloud SQL)   | High (SQL)      |
| Semi-Structured | Logs, JSON Events       | No-SQL (Bigtable, Firestore)| Medium (Flexible)|
| Unstructured    | Videos, Images          | Cloud Storage (Bucket)      | Low (Binary)    |

## Benefits of Google Cloud Storage Over Persistent Disks
Persistent disks offer processing power via attached VMs but fail for long-term, large-scale data storage due to high costs and capacity limits. Google Cloud Storage provides a serverless, cost-effective alternative for unstructured data, enabling infinite scalability and easier access without VM attachments.

## Key Concepts of Cloud Storage Benefits
### Cost Efficiency
- **Persistent Disk Example**: 1 TB zonal persistent disk costs ~$36/month; regional adds replication but similar costs.
- **Cloud Storage Example**: 1 TB multi-regional storage costs ~$18/month with free retrieval.
- **Pay-as-You-Go**: No upfront capacity planning; scale from 0 to exabytes without over-provisioning.

### Accessibility and Use Cases
- **Access via APIs**: Use tools like gsutil or gcloud for uploads/downloads without attaching VMs (unlike block storage).
- **Real-World Application**: Store survey data or logs long-term in Cloud Storage, then process with AI/ML tools for insights, avoiding compute costs until needed.
- **Unstructured Data Focus**: Handles 90% of global data (images, videos) better than databases.

### Drawbacks of Persistent Disks
- **Limited Capacity**: Cannot store petabytes efficiently; external drives are costly.
- **VM Dependency**: Access requires running VMs, adding compute costs.
- **Persistence**: Data retains but retrieval complexity increases.

## Overview of Google Cloud Storage Fundamentals
Google Cloud Storage is a scalable, serverless object storage service equivalent to Amazon S3 or Azure Blob Storage. It emphasizes immutable binary large objects, with no OS requirements and built-in encryption, making it suitable for serving multimedia or backing up files.

## Key Concepts of Google Cloud Storage Fundamentals
### Immutable Blob Storage
- **Definition**: File contents are immutable once uploaded; edits require re-uploading.
- **Example**: Block storage (persistent disks) allows file edits via VI; blob storage (GCS) does not.
- **Workaround**: Use GCS Fuse for file-system-like access, though with latency trade-offs for Kubernetes mounts.

### No Capacity Planning or OS Requirements
- **Scalability**: Store exabytes without limits; pay only for used storage.
- **Serverless**: No VM or OS needed; access via APIs, aligned with microservices architectures.

### Encryption and Security
- **At Rest/Transit**: Default Google-managed encryption using TLS for transfers; data in buckets is encrypted.
- **Advanced Options**: Choose customer-managed or supplied encryption keys for higher control.
- **Object Size Limit**: Max 5 TB per object; split larger files (e.g., 8 TB video into <5 TB segments).

### Single API Across Classes
- **API Uniformity**: Use `storage.googleapis.com` for all storage classes (standard, nearline, etc.), unlike AWS where different products (S3, Glacier) use separate APIs.
- **Advantage**: Learn one API for hot/cold data; single product for all use cases.

## Overview of Storage Classes Deep Dive
Google Cloud Storage uses storage classes (e.g., standard, nearline, coldline, archive) to optimize costs based on access frequency. Classes dictate storage costs, retrieval fees, and minimum retention periods, ensuring efficient data lifecycle management.

## Key Concepts of Storage Classes
### Standard Class (formerly Multi-Regional/Regional)
- **Availability/SLA**: Multi-regional: 99.95% (21.7 minutes downtime/month); Dual-regional: 99.95%; Regional: 99.9% (43.8 minutes downtime/month).
- **Durability**: 11-9s (expected data loss: <1 in 10^9 objects/year).
- **Use Cases**: Public content like videos/images served via CDN; private data in single region for analytics/compliance.
- **Cost**: ~$0.026/GB storage; free retrieval; replication cost for multi-regional.
- **Retention**: None; delete anytime without penalties.

### Multi-Regional vs. Regional
- **Multi-Regional**: Replicates across 3+ regions for high availability/public content.
- **Regional**: Single region for low latency/private data (e.g., within one country).
- **Dual-Regional (TURBO)**: Two specific regions for balance; ~$0.08-$0.11/GB with faster replication.

| Class Aspect | Multi-Regional | Dual-Regional | Regional |
|--------------|----------------|---------------|----------|
| Replicas    | 3+ Regions    | 2 Regions     | 3 Zones  |
| SLA         | 99.95%         | 99.95%        | 99.9%    |
| Use Case    | Public CDN     | Private Dual  | Private Single |

### Nearline Class
- **Availability/SLA**: ~99.9% for regional; multi-regional at ~99.95% (varies).
- **Use Cases**: Data accessed ~once/month (e.g., backups, disaster recovery drills).
- **Minimum Retention**: 30 days; early deletion incurs penalties.
- **Cost**: ~$0.01/GB storage; $0.01/GB retrieval.

### Coldline Class
- **Availability/SLA**: Similar to nearline (~99.9%).
- **Use Cases**: Data accessed ~once/quarter (e.g., CCTV footage for 90-180 day compliance).
- **Minimum Retention**: 90 days; penalties for early deletion.
- **Cost**: ~$0.004/GB storage; $0.02/GB retrieval.

### Archive Class
- **Availability/SLA**: Lowest (~99%).
- **Use Cases**: Data accessed ~once/year (e.g., legal/compliance archives for years).
- **Minimum Retention**: 365 days; major penalties for early deletion.
- **Cost**: ~$0.0012/GB storage; $0.05/GB retrieval.

### Class Migration
- **Flexibility**: Change classes (e.g., nearline to standard) if access patterns change.
- **Penalties**: May incur early deletion fees when moving from longer retention classes.

> [!IMPORTANT]
> For sensitive/private data, prefer regional classes to ensure data stays within specified regions/countries, avoiding cross-border replication risks.

## Demos and Configurations
### Bucket Creation Demos
#### Multi-Regional Bucket (UI)
- **Steps**:
  1. Go to Cloud Storage > Buckets > Create.
  2. Enter unique name (e.g., `pca-multi-regional`), ideally with UID for security.
  3. Select "Multi-region" (e.g., "asia") as location type.
  4. Choose "asia" as location; set storage class to "Standard".
  5. Add labels (optional); create.
- **Verification**: Upload file; check storage cost and free retrieval in bucket details.

#### Regional Bucket (UI)
- **Steps**: Similar to above, select "Region" (e.g., "asia-southeast1") as location type.
- **Command Line (gsutil)**:
  ```
  gsutil mb -p <project_id> -c regional -l asia-southeast1 gs://pca-regional
  ```
- **Benefit**: Data confined to region; lower latency for regional workloads.

#### Nearline Bucket
- **Command Example**:
  ```
  gsutil mb -p <project_id> -c nearline -l asia-southeast1 gs://pca-nearline
  ```
- **Note**: Apply minimum 30-day retention; monitor for early deletion costs in billing.

> [!NOTE]
> Bucket names must be globally unique; avoid sensitive or easily guessable names to prevent hijacking (e.g., from AWS S3 incidents). Use UIDs or project prefixes for security.

## Summary
### Key Takeaways
```diff
+ Unstructured data dominates (80-90% of world's data), suitable for Cloud Storage
+ Storage classes optimize cost: Standard for frequent access, Archive for rare access
+ Single API for all classes simplifies learning over multi-product alternatives
- Early deletion penalties for Nearline/Coldline/Archive enforce minimum retention
! Always assess access frequency and data sensitivity to choose the right class
```

### Expert Insight
**Real-world Application**: In production, use Google Cloud Storage for media assets in a streaming service—store videos in Multi-regional for global access, migrate old episodes to Nearline/Archive for cost savings while maintaining quick or eventual retrieval.

**Expert Path**: Master gsutil/gcloud commands and lifecycle policies in Cloud Storage to automate class transitions (e.g., via BigQuery). Understand SLAs deeply to balance reliability and cost; practice with large datasets to see actual retrieval latencies.

**Common Pitfalls**: Choosing wrong class leads to high costs (frequent retrieval on Archive) or penalties (early deletion). Ignoring regional choices risks data sovereignty breaches in regulated industries.

**Common Issues and Resolution**:
- **High Retrieval Costs**: Monitor usage; switch to lower-cost classes if needed; use lifecycle policies for automatic migration.
- **Bucket Name Conflicts**: Use random UIDs; avoid reuse after deletion to prevent hijacking.
- **Data Sovereignty**: Always select regional for private/sensitive data; verify regions post-creation. Larger known things: Cloud Storage scales to exabytes; less known: latencies via Fuse can spike, so prefer API access for performance-critical apps.
