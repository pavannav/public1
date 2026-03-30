# Session 71: Demystifying Partition and Clustering, BigQuery IAM Roles

## Table of Contents
- [Partitioning Basics](#partitioning-basics)
- [BigQuery Data Set Creation](#bigquery-data-set-creation)
- [Table Partitioning Demonstrations](#table-partitioning-demonstrations)
- [Clustering Concepts](#clustering-concepts)
- [Partitioning vs Clustering Comparisons](#partitioning-vs-clustering-comparisons)
- [Table Expiration](#table-expiration)
- [Partition-Level Expiration](#partition-level-expiration)
- [BigQuery IAM Roles](#bigquery-iam-roles)
- [IAM Roles in Detail](#iam-roles-in-detail)
- [Summary](#summary)

## Partitioning Basics

### Overview
Partitioning in BigQuery is a data organization technique that divides large tables into smaller, manageable segments based on specific criteria. Similar to organizing books in a bookshelf by topic or genre, partitioning helps avoid full table scans by allowing queries to target only relevant data segments, dramatically reducing processing costs and improving performance.

### Key Concepts/Deep Dive
Partitioning groups data into logical segments for efficient querying. The analogy used is organizing books by genre (technical, philosophical, fiction novels) to quickly locate desired books without scanning the entire collection.

**Partition Types:**
- **Partition by Injection Time**: Uses the timestamp when data is loaded into BigQuery as the partitioning key
- **Partition by Field**: Uses a specific column (integer, date, timestamp) as the partitioning key

**Key Requirements:**
- Require partition filter must be enabled on partitioned tables to enforce query optimization
- Only specific data types support partitioning: INTEGER, DATE, TIME, TIMESTAMP

**Benefits:**
- Reduces bytes processed in queries
- Improves query performance
- Enables cost-effective storage management

### Lab Demos
#### Book Organization Analogy
Imagine organizing books by genre:
```
| Technical Books | Philosophical Books | Fiction Novels |
|-----------------|---------------------|----------------|
| GCP Books       | Mahabharata         | Suspense novels|
| AWS Books       | Ramayana            | Thrillers      |
```

This avoids full shelf scans by directly accessing relevant sections.

## BigQuery Data Set Creation

### Overview
BigQuery data sets serve as containers for tables and act as compliance boundaries. Proper configuration includes setting correct regions and implementing appropriate naming conventions and features like table expiration for cost management.

### Key Concepts/Deep Dive
Data sets determine storage location and are critical for compliance. Key considerations include:

**Naming Conventions:**
- Only letters, numbers, and underscores allowed
- No hyphens (inconsistent with other GCP services like VMs, Kubernetes clusters)
- Underscore-only for BigQuery, unlike other services that prefer hyphens

**Region Management:**
- Data set location defines where data resides
- Multi-region should be specified if needed for compliance

**Advanced Options:**
- Encryption settings (Google-managed, customer-managed, customer-supplied)
- Table expiration for automatic cleanup of temporary data
- Minimum expiration: 60 seconds via API, 1 day via UI

**Cost Considerations:**
- Data sets are free (no storage cost for metadata)
- Only table data incurs charges
- Table expiration helps with cost control for ad-hoc analyses

### Lab Demos
#### Creating a Data Set with Expiration
```bash
bq mk --dataset_id dataset_03 --location multi --default_table_expiration 86400
```

This command creates a multi-region data set with 1-day table expiration.

## Table Partitioning Demonstrations

### Overview
These demonstrations show practical implementation of partitioning using both injection time and field-based approaches, demonstrating cost reductions and performance improvements.

### Key Concepts/Deep Dive
**Partition Columns:**
- **Pseudo Columns**: System-generated columns not visible in schema (e.g., _PARTITIONTIME)
- **Actual Columns**: User-defined columns like dates that drive partitioning logic

**Partitioning by Injection Time:**
- Uses UTC timestamp of data ingestion
- Granularity: hour, day, month, year
- Automatically adds partition filtering when queries execute

**Schema Definition:**
- Avoid auto-detect for full partitioning control
- Manually define columns with appropriate data types
- Partition fields require specific types (date/timestamp/integer)

### Lab Demos
#### Creating Partitioned Table with Schema
```sql
CREATE TABLE dataset_3.employee
(
  last_name STRING,
  dep_id INT64,  
  start_date DATE
)
PARTITION BY DATE(start_date)
CLUSTER BY dep_id
OPTIONS (
  require_partition_filter = true
)
```

#### Partition Time Query Example
```sql
SELECT 
  first_name,
  start_date
FROM dataset_3.employee
WHERE _PARTITIONTIME >= "2024-06-01 00:00:00"
  AND _PARTITIONTIME < "2024-06-02 00:00:00"
```

#### Real Cost Reduction Demo
```sql
-- Unpartitioned query: 840 MB processed
SELECT title, creation_date 
FROM stack_overflow.stackoverflow_posts
WHERE creation_date BETWEEN '2015-01-01' AND '2015-12-31'

-- Partitioned query: 167 MB processed (5x cost reduction)
SELECT title, creation_date 
FROM stack_overflow.partition_demo
WHERE creation_date BETWEEN '2015-01-01' AND '2015-12-31'
```

## Clustering Concepts

### Overview
Clustering complements partitioning by organizing data within partitions. While partitioning divides data horizontally, clustering sorts data within each partition for even more efficient queries, especially for non-partition columns.

### Key Concepts/Deep Dive
**Clustering vs Partitioning:**
- Partitioning: Divides data across separate physical storage units
- Clustering: Sorts data within partitions for faster scans

**Visual Concept:**
```
Partition: 2024-06 (Books joined in June)
┌─────────────────────────────────────┐
│ Clustered by lastname:             │
│ - Abacus, John                     │
│ - Bennet, Anna                     │  
│ - Carter, Lisa                     │
│ - Davis, Mark                      │
└─────────────────────────────────────┘
```

**Benefits:**
- Additional 3-5x cost reduction beyond partitioning
- Up to 4 columns for clustering
- Works with any data types
- Can be modified on existing tables

### Lab Demos
#### Creating Clustered Table
```sql
CREATE TABLE stack_overflow.partition_clustering_demo
PARTITION BY DATE_TRUNC(creation_date, DAY)
CLUSTER BY tags
OPTIONS (
  require_partition_filter = true
)
AS SELECT * FROM bigquery-public-data.stackoverflow.posts_answers;
```

#### Performance Comparison (Same dataset)
| Configuration | Bytes Processed | Cost Reduction |
|---------------|-----------------|----------------|
| No partition/cluster | 1.15 GB | Baseline |
| Partition only | 235 MB | 4.9x reduction |
| Partition + Clustering | 10 MB | 115x reduction |

## Partitioning vs Clustering Comparisons

### Overview
Both techniques optimize BigQuery performance, but they serve different purposes and have different constraints.

### Key Concepts/Deep Dive
**When to Use Each:**
- **Partitioning Required For:**
  - Tables >50GB
  - Time-series data
  - Data with date/timestamp/integer keys
  
- **Clustering Use Cases:**
  - Additional optimization on string columns
  - Any data type support
  - Smaller tables (<50GB)

**Key Differences:**

| Aspect | Partitioning | Clustering |
|--------|-------------|------------|
| Column Types | INTEGER, DATE, TIME, TIMESTAMP | Any type |
| Performance Gain | 4-5x typical | Additional 2-3x |
| Schema Requirement | Must be set at table creation | Can be added later |
| Maximum Columns | 1 | 4 |
| Mandatory Filtering | Recommended (require_partition_filter) | None |

### Lab Demos
#### Unified Table Creation
```sql
CREATE TABLE optimized_table
(
  id INT64,
  created_date DATE,
  category STRING,
  value FLOAT64
)
PARTITION BY created_date
CLUSTER BY category
OPTIONS (
  require_partition_filter = true
)
```

## Table Expiration

### Overview
Table expiration automatically removes tables after specified durations, preventing accumulation of temporary or ad-hoc analysis data that could incur ongoing storage costs.

### Key Concepts/Deep Dive
**Expiration Types:**
- Dataset-level: All tables inherit expiration
- Table-level: Override dataset defaults

**Practical Applications:**
- Ad-hoc analysis workspaces
- Temporary data exploration
- GDPR compliance for old customer data

**Cost Impact:**
- Eliminates storage costs for unused data
- Prevents surprise charges from forgotten tables

### Lab Demos
#### Dataset with Default Expiration
```bash
bq mk --dataset_id temp_analysis \
  --default_table_expiration 86400 \
  --location US
```

#### GCP Cost Analysis
Grouped billing analysis shows BigQuery costs typically consist of:
- Processing: 99.7% of costs
- Storage: Minimal for unused data

## Partition-Level Expiration

### Overview
Fine-grained expiration controls allow specific partitions to be removed while preserving table structure and other partitions, enabling sophisticated data lifecycle management.

### Key Concepts/Deep Dive
**Partition Expiry Implementation:**
- Minimum granularity: 1 day
- Command-line only (not UI supported)
- Preserves table schema

**Command Structure:**
```bash
bq load --source_format=CSV \
  --time_partitioning_expiration=86400 \
  --time_partitioning_field=start_date \
  dataset.expire_demo \
  gs://bucket/employee.csv \
  schema_definition
```

**Compliance Benefits:**
- Automatic removal of old customer data (GDPR)
- Retention policies for historical data
- Cost optimization for time-series data

### Lab Demos
#### Partition-Level Expiration Demo
```bash
# Old data (pre-2024) loads but expires immediately
bq load --source_format=CSV \
  --skip_leading_rows=1 \
  --time_partitioning_expiration=86400 \
  expire_soon.expire_demo \
  gs://bucket/old_employee_data.csv \
  last_name:STRING,dep_id:INTEGER,start_date:DATE

# Result: Data loads, partition expires, storage freed
```

## BigQuery IAM Roles

### Overview
BigQuery uses granular IAM roles to control access to datasets, tables, and operations. Understanding these roles is crucial for secure and efficient data access management.

### Key Concepts/Deep Dive
**Principle of Least Privilege:**
- Grant minimum required permissions
- Avoid over-privileging in development environments
- Balance security with operational needs

**Role Categories:**
- Administrative roles (creation/deletion)
- Data access roles (read/write/query)
- Specialized roles (metadata, jobs)

### Lab Demos
#### Role Comparison Table
| Role | Permissions | Data Operations | Management Operations | Job Operations |
|------|-------------|-----------------|----------------------|----------------|
| BigQuery Admin | All (195) | Full CRUD + Query | Full admin | Yes |
| BigQuery Data Owner | 74 | Full CRUD | Create/delete datasets | No |
| BigQuery Data Editor | Limited | Full CRUD | Create datasets only | Yes* |
| BigQuery Data Viewer | Limited | Read only | None | Yes* |
| BigQuery User | Limited | CRUD in owned resources | Limited | Yes |

\* Requires BigQuery Job User role for queries.

## IAM Roles in Detail

### Overview
Each IAM role serves specific operational needs, with combinations required for complete functionality. Understanding role interdependencies is key to proper access management.

### Key Concepts/Deep Dive
**Role Dependencies:**
- **Job Execution**: BigQuery Job User role enables all query operations
- **Data Access**: Viewer/Editor/Owner roles provide data permissions
- **Federated Roles**: Metadata Viewer for schema-only access

**Best Practices:**
- Use BigQuery User + Job User for sandbox environments
- Reserve Admin role for production administrators only
- Combine roles appropriately for business needs

### Lab Demos
#### Common Role Combinations
```yaml
# Data Analyst (BI Tool Access)
roles:
  - bigquery.dataViewer
  - bigquery.jobUser

# Data Engineer (Development)
roles:  
  - bigquery.user
  - bigquery.jobUser

# Administrator (Production)
roles:
  - bigquery.admin

# Manager/Auditor (Metadata Only)
roles:
  - bigquery.metadataViewer
```

#### Permission Security Demo
Setting BigQuery Job User role alone allows costly queries on public datasets:
```sql
-- Dangerous: Processes 30GB on BigQuery Public Data
SELECT * FROM bigquery-public-data.stackoverflow.posts_questions
```
> [!WARNING]
> Public datasets + Job User role = Unlimited cost potential

## Summary

### Key Takeaways
+ Partitioning divides tables by date/integer columns to avoid full scans
+ Clustering sorts data within partitions for additional performance gains  
+ Require partition filter prevents wasteful queries
+ IAM roles follow least privilege with BigQuery Job User as foundation
+ Table/partition expiration prevents storage cost accumulation

### Expert Insight

**Real-world Application**: Partitioning and clustering are mandatory in production BigQuery architectures for cost control. For 100TB+ warehouses, these techniques reduce query costs by 10-50x. Always implement them during table design phase.

**Expert Path**: Master BigQuery partitioning by understanding partition pseudo-columns and implementing proper clustering for string-based queries. Study IAM role combinations for secure multi-tenant environments.

**Common Pitfalls**: 
- Forgetting require_partition_filter leads to accidental full table scans
- Over-privileging with BigQuery Admin in development environments  
- Ignoring partition skew that creates imbalanced data distribution
- Not setting table expiration for temporary datasets
- Granting only BigQuery Job User role without data access permissions

Common issues with resolution:
- **Partition filter errors**: Enable cluster or partition filtering, ensure WHERE clauses target partition columns
- **High costs on public datasets**: Restrict BigQuery Job User to specific data viewing roles
- **Slow queries**: Verify partition and cluster strategies match query patterns
- **Storage creep**: Implement appropriate expiration policies at dataset/table level

Lesser known things: Partition expiration supports GDPR compliance through automatic data removal, and clustering can be modified on existing tables without recreation. BigQuery metadata viewer role provides schema access without data viewing permissions for auditors.
