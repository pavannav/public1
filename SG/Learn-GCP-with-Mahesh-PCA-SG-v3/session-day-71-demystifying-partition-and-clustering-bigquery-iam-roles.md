# Session 071: Demystifying Partition and Clustering, BigQuery IAM Roles

## Table of Contents
- [Introduction to Partitioning](#introduction-to-partitioning)
- [Partitioning Demo on Smaller Dataset](#partitioning-demo-on-smaller-dataset)
- [Partitioning on Larger Dataset](#partitioning-on-larger-dataset)
- [Clustering Concept](#clustering-concept)
- [Clustering Demo](#clustering-demo)
- [Partition Expiry](#partition-expiry)
- [BigQuery IAM Roles](#bigquery-iam-roles)

## Introduction to Partitioning

### Overview
Partitioning in BigQuery is a technique to optimize data storage and querying by dividing large tables into smaller, manageable segments based on specific criteria. This allows for faster queries and cost reduction by avoiding full table scans, especially important for architects to enforce in design documents to prevent issues later.

### Key Concepts
- **Analogy**: Imagine organizing books in a shelf. Without organization (unorganized table), searching for a specific book requires scanning the entire shelf. With organization by genre (tech, philosophical, fiction novels), you directly access the relevant section, saving time and effort. In BigQuery, partitioning groups data similarly to enable efficient access.

- **Partitioning Mechanics**: Partitioning divides a table into segments based on a partitioning key. BigQuery supports partitioning by:
  - Timestamp-based (e.g., day, hour, month) for fields like `creation_date`.
  - Integer-based for numerical fields.
  - Date-based for date fields.

- **Partition Filter Requirement**: Always set `require_partition_filter = true` to enforce queries to include the partitioning column in the WHERE clause. This prevents accidental full table scans, similar to wearing a helmet with a locked strap for safety.

- **Why Partitioning Matters**:
  ```diff
  + Positive/Key Point: Reduces query costs by limiting data scanned to relevant partitions.
  - Negative/Warning: Without filters, partitioning offers no performance benefit and may still incur full scan costs.
  ! Alert: Architects must mandate partitioning in design documents to avoid downstream optimization requests.
  ```

### Code/Config Blocks
- **Creating a Partitioned Table with Injection Time**:
  ```bash
  # Command to create a dataset multi-region (if needed for cross-region data)
  bq mk --dataset --location=US dataset_3

  # Then in BigQuery UI, load data with partitioning settings
  # Load from bucket or local file
  # Set Partition by: Ingestion Time
  # Type: Day or Hour
  # Require partition filter: Yes
  ```

## Partitioning Demo on Smaller Dataset

### Overview
This section demonstrates partitioning using a smaller employee dataset, showing how to create partitioned tables and query them efficiently.

### Key Concepts and Demo Steps
1. **Dataset Creation with Expiration**:
   - Create a multi-region dataset for demonstration, as it allows data copying from public BigQuery datasets.
   - Set table expiration to avoid costs for transient data.
   ```bash
   bq mk --dataset --location=US --default_table_expiration=3600 dataset_3  # 1 hour expiration
   ```

2. **Loading Partitioned Data**:
   - Use the employee CSV file.
   - Set partitioning to "Partition by ingestion time" by hour, and require partition filter.
   - Query partitions using system views.

3. **Querying Partitions**:
   - Use INFORMATION_SCHEMA to inspect partitions.
   ```sql
   SELECT * FROM `project.dataset_3.employee` LIMIT 1000;
   # With partition filter (required):
   SELECT first_name FROM `project.dataset_3.employee` WHERE _PARTITIONTIME >= TIMESTAMP('2025-06-01') AND first_name = 'some_value';
   ```

4. **Visual Differences**:
   - Partitioned tables show a "bread sandwich" icon in BigQuery UI, indicating layered partitions.
   - Unpartitioned tables appear as a simple calculator icon.

5. **Advantages in Small Data**:
   - Even with small datasets, partitioning enforces good practices, though performance gains are minimal.

```diff
+ Positive/Key Point: Query costs drop significantly as partitions allow targeted scanning.
- Negative/Warning: Skipping partition filters negates benefits, leading to full scans.
```

### Code/Config Blocks
- **Partition Inspection**:
  ```sql
  SELECT * FROM `project.INFORMATION_SCHEMA.PARTITIONS` WHERE table_name = 'employee';
  # Lists partitions with details like partition_id, creation_time, etc.
  ```

## Partitioning on Larger Dataset

### Overview
Applying partitioning to larger datasets (e.g., Stack Overflow posts) demonstrates substantial cost savings by reducing bytes processed from GB to MB levels.

### Key Concepts and Comparison
- **Unpartitioned Query Example**:
  ```sql
  SELECT title, creation_date FROM `bigquery-public-data.stackoverflow.posts_questions` 
  WHERE creation_date BETWEEN '2015-01-01' AND '2015-12-31' 
  LIMIT 1000;
  # Bytes processed: ~840 MB (costly full scan)
  ```

- **Partitioned Query Example**:
  ```sql
  SELECT title FROM `project.stack_overflow.partition_demo` 
  WHERE creation_date BETWEEN '2015-01-01' AND '2015-12-31';
  # Bytes processed: ~167 MB (significant reduction due to partitioning)
  ```

- **Without Partition Filter**:
  ```diff
  - Negative/Warning: Removing filter allows full scan: ~614 MB, wasting partitioning benefits.
  ```

### Demonstration and Results
- Create a partitioned copy of public data:
  ```sql
  CREATE TABLE `project.stack_overflow.partition_demo`
  PARTITION BY DATE_TRUNC(creation_date, DAY)
  CLUSTER BY (tags)
  OPTIONS (
    description = "Partitioned demo table",
    require_partition_filter = true
  )
  AS SELECT * FROM `bigquery-public-data.stackoverflow.posts_questions`;
  # Note: This processes full data (~30 GB initially) but enables optimized future queries.
  ```

- **Bytes Processed Reduction**:
  | Scenario | Bytes Processed |
  |----------|-----------------|
  | Unpartitioned | 841 MB |
  | Partitioned (with filter required) | 167 MB |

```diff
+ Positive/Key Point: Partitioning can reduce costs by ~80% on large datasets.
! Alert: Mandatory partition filters prevent accidental overruns.
```

## Clustering Concept

### Overview
Clustering complements partitioning by sorting data within partitions based on clustering keys, further reducing data scanned for queries without full partition scans.

### Key Concepts
- **Partitions vs. Clusters**:
  ```mermaid
  flowchart TD
      A[Partition 1] --> B1[Cluster 1: Android]
      A --> B2[Cluster 2: Linux]
      A --> B3[Cluster 3: SQL]
      C[Partition 2] --> C1[Similar Clusters]
  ```
  Partitioning divides the table into "shelves" (partitions). Clustering organizes books on each shelf alphabetically for quick location.

- **Clustering Mechanics**:
  - Supported on up to 4 columns of any data type (string, int, etc.).
  - No restrictions like partitioning; can be applied to existing tables.
  - Within partitions, data is sorted by cluster keys, enabling range scans.

- **When to Use**:
  - For non-partitionable fields or to enhance partitioned queries.
  - Rule of thumb: Use for tables >50 GB; else, clustering alone suffices.

```diff
+ Positive/Key Point: Clustering reduces scan size within partitions efficiently.
- Negative/Warning: Not suitable for small tables where partitioning alone isn't needed.
```

## Clustering Demo

### Overview
Demonstrate clustering on Stack Overflow data, showing query optimizations when combining partitioning and clustering.

### Key Concepts and Steps
1. **Creating a Clustered-Partitioned Table**:
   ```sql
   CREATE TABLE `project.stack_overflow.partition_clustering_demo`
   PARTITION BY DATE_TRUNC(creation_date, DAY)
   CLUSTER BY (tags, score)  -- Up to 4 fields
   OPTIONS (
     require_partition_filter = true
   )
   AS SELECT * FROM `bigquery-public-data.stackoverflow.posts_questions`;
   ```

2. **Query Performance**:
   - Unlogged (separate demos): Partitioning only ~222 MB; Clustering only ~222 MB (minimum 10 MB billing).
   - Combined query for "android" tags: Significant reduction due to pre-sorted clusters.

3. **Results**:
   - Bytes processed: From 1.15 GB (unoptimized) to 10 MB (minimum with clustering).
   - Allows skipping full partition scans for tag-based queries.

### Code/Config Blocks
- **Info Schema for Clusters**:
  ```sql
  SELECT * FROM `project.INFORMATION_SCHEMA.COLUMNS` WHERE table_name = 'partition_clustering_demo';
  # Shows cluster fields in details.
  ```

## Partition Expiry

### Overview
Partition expiry allows automatic deletion of old data to reduce storage costs and comply with regulations (e.g., GDPR).

### Key Concepts and Demo
1. **Setting Expiry**:
   - At table level (e.g., 1 day) or partition level for specific deletions.
   ```bash
   bq load --source_format=CSV --skip_leading_rows=1 --time_partitioning_expiration=86400 dataset.table gs://bucket/data.csv
   # 86400 seconds = 1 day
   ```

2. **Partition-Level Expiry**:
   - Update existing partitioned tables to set expiry on specific partitions.
   ```bash
   bq update --time_partitioning_expiration=86400 project:dataset.table
   ```

3. **Demonstration**:
   - Load data; partitions expire automatically.
   - Insert new data matching future dates to retain it.

```diff
+ Positive/Key Point: Saves costs by auto-deleting unused data.
! Alert: Useful for ad-hoc analyses or compliance, but irreversible.
```

### Advantages, Disadvantages, and Common Pitfalls
- **Advantages**: Cost savings, automated cleanup, regulatory compliance.
- **Disadvantages**: Data loss if misconfigured; no recovery.
- **Common Pitfalls**: Setting short expiries on production data; forgetting to back up before expiry.

## BigQuery IAM Roles

### Overview
BigQuery IAM roles control access to operations, from data viewing to admin privileges, enforcing least privilege for security.

### Key Concepts and Roles
- **Role Hierarchy and Permissions**:
  | Role | Permissions | Use Case |
  |------|-------------|----------|
  | BigQuery Admin | Full control (195 permissions, e.g., CRUD, job creation) | Rare; full access for admins in dev environments. |
  | BigQuery Data Owner | Create/delete datasets/tables; load/query (no query without job user). | High-level data management; requires job user for queries. |
  | BigQuery Data Editor | Create/delete own datasets; edit data. | Data engineering; can manage own resources. |
  | BigQuery Data Viewer | View/preview data (no modify/query without job user). | Read-only access for analysts/managers. |
  | BigQuery Job User | Create jobs (query, load, etc.); requires data roles. | Combined with viewer/editor for full querying; dangerous if given alone (can query public datasets, incurring costs). |
  | BigQuery User | Sandbox: Create own datasets/tables; query own data; no production access. | Ideal for learners/new hires; prevents production damage. |
  | BigQuery Read Session User (new) | Stream data; limited scope. | Specialized streaming. |
  | BigQuery Metadata Viewer | View schemas/metadata (no data). | Auditors needing structure without content. |

- **Principle of Least Privilege**: Grant minimal roles; e.g., viewer + job user for BI tools.
- **Demos**:
  - Data Owner: Can create tables but not query without job user.
  - Editor: Can delete own datasets but not others'.
  - User: Full sandbox control; no production visibility.
  - Job User Alone: Risky; enables cost-incurring queries on public data.

```diff
+ Positive/Key Point: Proper roles prevent unauthorized access and cost overruns.
- Negative/Warning: Overbroad roles (e.g., admin) violate security; job user alone can be misused.
! Alert: Assign job user at project level; verify data access for queries.
```

### Common Pitfalls, Expert Insight
- **Common Pitfalls**: Giving admin in production; ignoring inherited ownership; not removing old roles.
- **Real-World Application**: Use in financial data for compliance; sandbox for training.
- **Expert Path**: Audit roles quarterly; automate via Terraform; use custom roles for fine-tuning.
- **Lesser-Known Facts**: Job user allows public dataset queries, splitting billing to your project; roles apply at project/dataset levels.

## Summary

### Key Takeaways
```diff
+ Partitioning and clustering optimize queries, reducing costs via targeted scans.
- Skipping partition filters or over-partitioning negates benefits.
! IAM roles must balance access with security, using least privilege.
+ Expiry features automate cost savings and compliance.
- Misconfigured expiries lead to data loss; roles without data access render users ineffective.
```

### Quick Reference
- **Partition Query**: `SELECT * FROM table WHERE partition_key BETWEEN 'start' AND 'end';`
- **Cluster Table**: `CREATE TABLE ... CLUSTER BY (col1, col2);`
- **IAM Roles**: Data Viewer + Job User for read-only analysts; User for sandbox learning.
- **Partition Expiry**: Set via `OPTIONS (partition_expiration_days = 30);`

### Expert Insight

#### Real-World Application
In production, architects mandate partitioned tables for log data (e.g., by timestamp) and clustered on user IDs or categories to support fast analytics in dashboards, reducing query costs by 70-90% while ensuring GDPR compliance through expiries.

#### Expert Path
Master advanced sampling queries, monitor metrics via Stackdriver, and integrate with Terraform for automated IAM. Pursue GCP Professional Cloud Architect certification, focusing on BigQuery optimizations.

#### Common Pitfalls
Full scans on partitioned tables without filters; granting admin roles in shared projects; forgetting to remove dataset-level permissions after role downgrades; underestimating public dataset query costs with job user role.

#### Lesser-Known Facts
Clustering alone can yield minimum billing (10 MB) for large tables; partition pseudo-columns (_PARTITIONTIME) are system-generated; IAM roles at dataset level override project roles; expiries prevent backups, so use for transient data only.

#### Advantages and Disadvantages
- **Advantages**: Cost-effective at scale; enables fast, compliant queries; granular access control.
- **Disadvantages**: Design-time configuration needed; expiries are irreversible; complex IAM hierarchies.
