# Chapter 5: Designing Storage Systems

**Exam Objective Covered:**
- **2.2 Configuring individual storage systems**

---

Storage is an essential component of virtually any cloud-based system. Storage needs can range from long-term archival storage for rarely accessed data to highly volatile, frequently accessed data cached in memory. Google Cloud Platform (GCP) provides a full range of storage options:

- Object storage
- Persistent local and attached storage
- Relational and NoSQL databases

---

## Overview of Storage Services

Cloud architects often must select one or more storage systems when designing an application. Key factors influencing the choice include:

- Is the data structured or unstructured?
- How frequently will the data be accessed?
- What is the read/write pattern? What is the frequency of reads versus writes?
- What are the consistency requirements?
- Can Google managed keys be used for encryption, or do you need to deploy customer managed keys?
- What are the most common query patterns?
- Does your application require mobile support, such as synchronization?
- For structured data, is the workload analytic or transactional?
- Does your application require low latency writes?

---

## Object Storage with Google Cloud Storage

**Google Cloud Storage** is an object storage system designed for persisting unstructured data (data files, images, videos, backup files, etc.). Objects are treated as atomic — when you access a file in Cloud Storage, you access the entire file. You cannot read specific blocks as you would with a block storage device.

### Organizing Objects in a Namespace

- **Buckets** group objects and share access controls at the bucket level.
- Individual objects within buckets can also have their own access controls.
- Cloud Storage uses a **global namespace** for bucket names — all bucket names must be unique globally.
- Object names do not have to be unique.
- A bucket cannot be renamed; to simulate renaming, copy contents to a new bucket and delete the original.

**Best practices for bucket naming:**

- Do not use personally identifying information (names, email addresses, IP addresses) in bucket names.
- Follow DNS naming conventions (bucket names can appear in a CNAME record in DNS).
- Use GUIDs when creating many buckets.
- Do not use sequential names or timestamps if uploading files in parallel — sequentially close names will likely be assigned to the same server, creating a hotspot.
- Bucket names can also be subdomain names, such as `mybucket.example.com`.

> **Note:** To create a domain name bucket, you will have to verify that you are the owner of the domain.

![note](../images/note_24.png)

Cloud Storage does not provide a filesystem. However, objects can be named using `/`-delimited conventions that simulate a hierarchy. If a true filesystem interface is needed, **Cloud Storage FUSE** can be used.

### Cloud Storage FUSE

**Filesystem in Userspace (FUSE)** is a framework for exposing a filesystem to the Linux kernel. **Cloud Storage FUSE** is an open source adapter that allows users to mount Cloud Storage buckets as filesystems on Linux and macOS platforms.

- Cloud Storage FUSE is **not** a filesystem like NFS — it does not implement a hierarchical directory structure.
- It does interpret `/` characters in filenames as directory delimiters.
- Example: A user mounts a bucket to `/gcs`, then saves a file at `/gcs/myproject/mydirectory/mysubdirectory/mydata.csv`. Using `gsutil` or the Cloud Console, the object would appear as `myproject/mydirectory/mysubdirectory/mydata.csv`.
- Useful for moving files between Cloud Storage and Compute Engine VMs, local servers, or development devices using filesystem commands instead of `gsutil`.
- Google-developed and community-supported open source project under the Apache license.
- Available at: `github.com/GoogleCloudPlatform/gcsfuse`

### Storage Tiers

Cloud Storage offers **four tiers** (storage classes):

| Storage Class | Best Use Case | Access Frequency | Notes |
|---|---|---|---|
| **Standard** | Frequently accessed ("hot") data or briefly stored data | Anytime | Available in region, dual-region, and multiregion |
| **Nearline** | Infrequently accessed data | Less than once in 30 days | Lower at-rest cost, higher access cost |
| **Coldline** | Rarely accessed data | Less than once in 90 days | Lower at-rest cost, higher access cost |
| **Archive** | Long-term archival | Less than once per year | Lowest at-rest cost, highest access cost |

**Key durability and availability notes:**

- All Cloud Storage options provide **99.999999999% (eleven 9s) annual durability**.
- **Region** location type: stores multiple copies across multiple zones in one region.
- **Dual-region** and **Multiregion** (geo-redundant) storage: mitigates risk of regional outage by replicating objects across two or multiple regions, respectively. Also improves access latency for geographically dispersed users.
- Nearline, Coldline, and Archive have slightly lower availability than Standard, but lower at-rest costs.

**Network Tiers:**

- **Standard network tier**: routes data over public internet infrastructure.
- **Premium network tier**: routes data over Google's global high-speed network — expect lower latencies.

> Cloud Storage also has three legacy classes: Multi-Regional, Regional, and Durable Reduced Availability (DRA). Google recommends using Standard storage instead unless already using one of these.

### Cloud Storage Use Cases

1. **Shared storage among multiple instances** — e.g., log files stored in Cloud Storage and analyzed by Cloud Dataproc Spark clusters.
2. **Backup and archival storage** — e.g., persistent disk snapshots, backups of on-premises systems, compliance data.
3. **Staging area for uploaded data** — e.g., mobile app uploads images to a Cloud Storage bucket, triggering a Cloud Function to initiate further processing.

---

## Network-Attached Storage with Google Cloud Filestore

**Cloud Filestore** is a network-attached storage service that provides a filesystem accessible from Compute Engine and Kubernetes Engine. It is designed for **low latency and high IOPS**, suitable for databases and performance-sensitive services.

To use Cloud Filestore, you create a **Filestore instance** with:
- Name
- Service tier
- Storage type (HDD or SSD)
- Capacity

You can create:
- **Backups**: regional resources that preserve copies of all files and metadata.
- **Snapshots**: copies of the filesystem state at a point in time; stored within the Filestore instance.

### Cloud Filestore Service Tiers

Cloud Filestore is especially useful when lifting and shifting applications that require a filesystem and cannot use object storage.

| Tier | Use Case | Scope |
|---|---|---|
| **Filestore Basic** | File sharing, software, GKE workloads | Zonal |
| **Filestore High Scale** | High-performance computing (genome analysis, financial services, low-latency file ops) | Zonal |
| **Filestore Enterprise** | Mission-critical apps and GKE workloads; 99.99% regional availability via multiple NFS shares across multiple zones | Regional |

- Snapshots can be taken periodically; recovery from a snapshot is available within 10 minutes.

### Cloud Filestore Networking

Cloud Filestore connects to VPC networks using either:
- **VPC Network Peering** — used when creating an instance with a stand-alone VPC, within the host project of a Shared VPC, or when accessing from on-premises via Cloud VPN or Cloud Interconnect.
- **Private services access** — used when creating an instance on a Shared VPC from a service project (not the host project), or when using centralized IP range management for multiple Google Cloud services.

> **Note:** Cloud Filestore does not support transitive peering.

### Cloud Filestore Access Controls

Access controls are managed with a combination of **IAM roles** and **POSIX file permissions**.

| IAM Role | Permissions |
|---|---|
| `roles/file.viewer` | See details about instance, location, backups, snapshots, and operational status |
| `roles/file.editor` | All viewer permissions + create/delete instances, backups, and snapshots |

> Neither role provides access to the files within the Filestore instance.

- Default POSIX permissions: `rwxr-xr-x`, changed using OS commands such as `chmod`.
- Access control lists are also supported using OS commands such as `setfacl`.

---

## Databases

Google Cloud provides relational, analytical, and NoSQL databases. A key skill for the Professional Cloud Architect exam is choosing the appropriate database given a set of requirements.

### Relational Database Overview

**Relational databases** are highly structured data stores designed to:
- Minimize the risk of data anomalies (e.g., referential integrity constraints).
- Support a comprehensive query language (SQL).
- Support **ACID transactions**.

#### Atomicity

**Atomic operations** ensure that all steps in a transaction complete, or no steps take effect.  
Example: A sales transaction reduces inventory AND charges a credit card — if inventory is insufficient, neither action occurs.

#### Consistency

**Consistency** guarantees that when a transaction executes, the database is left in a valid state complying with all constraints (uniqueness, referential integrity, etc.).

In distributed databases, **eventual consistency** occurs when replicas are updated asynchronously — in the time between the first and last copy being updated, different servers may return different results. Eventually all replicas converge.

#### Isolation

**Isolation** ensures that concurrent transactions leave the database in the same state as if they had run sequentially.

Example:

**Transaction 1:**

![equation](../images/c05-disp-0001.png)

![equation](../images/c05-disp-0002.png)

![equation](../images/c05-disp-0003.png)

**Transaction 2:**

![equation](../images/c05-disp-0004.png)

![equation](../images/c05-disp-0005.png)

![equation](../images/c05-disp-0006.png)

With high isolation, the value of C will be either 5 or 15 — the result of executing one full transaction before the other.

The following interleaved sequence **cannot occur** with isolation:

![equation](../images/c05-disp-0007.png)

![equation](../images/c05-disp-0008.png)

![equation](../images/c05-disp-0009.png)

This would incorrectly leave C with a value of 7.

#### Durability

The **durability property** ensures that once a transaction is executed, its effects are permanently reflected in the database — typically by writing data to persistent storage even when also stored in memory.

---

### Cloud SQL

**Cloud SQL** is a managed service providing **MySQL, SQL Server, and PostgreSQL** databases.

**Key features:**

- All data is encrypted at rest and in transit.
- Data is replicated across multiple zones for high availability.
- GCP manages failover to replicas.
- Support for standard database connectors and tools.
- Integrated monitoring and logging.

> Cloud SQL is appropriate for regional databases up to **30 TB** (maximum database size may change in the future).

![note](../images/note_24.png)

**High Availability:**

- By default, Cloud SQL creates an instance in a single zone.
- Optionally maintain a **failover replica** of the primary instance — changes are mirrored, and Cloud SQL will automatically promote the replica if the primary fails.

**Read Replicas:**

- Copies of the primary instance data stored in the same or different region.
- **Cross-region replicas** support disaster recovery and data migration between regions.

**Database Migration Service:**

- Managed service for migrating MySQL and PostgreSQL databases to Cloud SQL (SQL Server support coming soon).
- Uses change data capture (CDC) mechanisms for initial snapshot and ongoing replication.
- Useful for lift-and-shift migrations and multicloud continuous replication.

**Limitation:** Cloud SQL can only scale **vertically** (moving to a larger machine). For horizontal scalability or global access, use Cloud Spanner.

---

### Cloud Spanner

**Cloud Spanner** is a managed database service supporting **horizontal scalability across regions**.

**Key features:**

- Supports structured data with schemas and SQL (Google Standard SQL — ANSI 2011 with extensions — and PostgreSQL dialect).
- **Strongly consistent** — no risk of data anomalies from eventual consistency.
- Manages replication automatically.
- **99.999% availability** — less than 5 minutes of downtime per year.
- GCP manages all patching, backing up, and failover.
- Data encrypted at rest and in transit.
- Integrated with Cloud Identity and Cloud IAM.
- Encryption options: Google-managed keys (default), Cloud KMS symmetric key, Cloud HSM key, or Cloud External Key Manager key.
- Supports **secondary indexes** in addition to primary key indexes.

**Use cases:**

- Financial trading systems requiring globally consistent market views.
- Logistics applications managing a global fleet of vehicles.
- Global inventory tracking.

**Hotspot avoidance:** Do not use monotonically increasing values (timestamps, incremented integers) as the first part of a primary key — this directs writes to a single server instead of distributing them evenly.

---

### Analytical Database: BigQuery

**BigQuery** is a managed, serverless data warehouse and analytics database solution. Users do not choose machine instance types or storage systems.

#### Analytics Features

BigQuery is built on several Google technologies:

| Technology | Role |
|---|---|
| **Dremel** | Query execution engine — maps SQL into execution trees; leaves (slots) read data and compute; branches aggregate |
| **Colossus** | Google's distributed filesystem — provides persistent storage, replication, and encryption at rest |
| **Borg** | Cluster management system — routes jobs to nodes and handles failed nodes |
| **Jupiter** | 1 petabit/second networking — eliminates rack-aware placement concerns |

- Data is stored in **columnar format (Capacitor)** — values from a single column are stored together, optimized for analytics queries that filter/group by a small number of columns.
- Capacitor supports nested and repeated fields.
- BigQuery uses the concept of **jobs** for executing tasks (loading, exporting, running queries, copying data). Batch and streaming jobs are both supported.
- **Dataset**: organizes tables and views within a project. Datasets can be regional (single region, e.g., `us-west2`) or multiregional (US or Europe).

**Billing:** Based on amount of data stored and amount of data scanned by queries (or flat-rate query billing based on allocation).

**Best practices:**
- Craft queries that return only needed data with specific filter criteria.
- To view table structure or sample data, use the **Preview Option** in the console or `bq head` command — this avoids unnecessary data scanning.
- Use `--dry-run` option for command-line queries to estimate bytes returned without executing.

```bash
bq query --dry-run 'SELECT * FROM mydataset.mytable'
```

#### IAM Roles for BigQuery

Access can be granted at the organization, project, dataset, and table/view levels.

| Role | Permissions |
|---|---|
| `roles/bigquery.dataViewer` | List projects/tables, get table data and metadata |
| `roles/bigquery.dataEditor` | dataViewer permissions + create/modify tables and datasets |
| `roles/bigquery.dataOwner` | dataEditor permissions + create/modify/delete datasets |
| `roles/bigquery.metadataViewer` | List tables, projects, and datasets |
| `roles/bigquery.user` | List projects/tables, view metadata, create datasets, create jobs |
| `roles/bigquery.jobUser` | List projects, create jobs and queries |
| `roles/bigquery.admin` | All operations on BigQuery resources |

> Additional roles are available for BigQuery ML, BigQuery Data Transfer Service, and BigQuery BI Engine.

#### Loading Data into BigQuery

##### Batch Loading

Common patterns:
- **ETL (Extract, Transform, Load)** or increasingly **ELT (Extract, Load, Transform)**
- **Load jobs**: load data from Cloud Storage or local filesystems. Supported formats: **Avro, CSV, ORC, Parquet**.
- **BigQuery Data Transfer Service**: specialized for loading from other cloud services (Google Ads, Google Ad Manager, Google SaaS applications, third-party services).
- **BigQuery Storage Write API**: batch process and commit many records in one atomic operation.
- BigQuery can also load data from **Cloud Firestore exports**.

##### Streaming

Two options for streaming data into BigQuery:

| Option | Key Feature |
|---|---|
| **Storage Write API** | High-throughput ingestion with exactly-once delivery semantics |
| **Cloud Dataflow** | Implements Apache Beam runner; writes directly to BigQuery tables from a Dataflow job |

#### Choosing a Managed Relational or Analytical Database

| Service | Use Case | Scalability |
|---|---|---|
| **Cloud SQL** | Transaction processing within a region | Vertical only (single server, up to 30 TB) |
| **Cloud Spanner** | Transaction processing requiring horizontal scale or writable nodes in multiple regions | Horizontal, global |
| **BigQuery** | Data warehousing and analytic queries of large datasets | Serverless, auto-scales |

> BigQuery should **not** be used for transaction processing systems or frequently updated data.

---

### NoSQL Databases

GCP offers three NoSQL databases: **Bigtable**, **Datastore**, and **Cloud Firestore**.

- **Cloud Bigtable**: wide-column NoSQL database
- **Cloud Firestore** and **Cloud Datastore**: document NoSQL databases
- Cloud Firestore is the next generation of Cloud Datastore; existing Datastore databases will eventually be automatically upgraded to Firestore in Datastore mode.

#### Cloud Bigtable

**Cloud Bigtable** is a wide-column, sparsely populated multidimensional database designed for petabyte-scale databases.

**Key features:**

- Sub-10 ms latency
- Stores petabyte-scale data
- Regional replication
- Queried using the `cbt` command (Cloud Bigtable–specific)
- Supports Hadoop HBase API
- Runs on a cluster; data is stored in the **Colossus filesystem** (not on nodes); nodes store pointers to tablets in Colossus

**Data model:**
- Data organized in tables as key-value maps indexed by row keys.
- Multiple cells with different timestamps can exist at the intersection of a row and column.
- Columns grouped into **column families**.
- Tables partitioned into blocks of contiguous rows called **tablets**.

**Use cases:** Machine learning model data, streaming IoT data, time series, marketing data, financial data, graph data.

**Replication:**
- Supports creating multiple clusters in a single Bigtable instance.
- Data is automatically replicated between clusters (eventually consistent).
- Useful for separating read and write workloads across clusters.

**Migration:** Good option for migrating Hadoop HBase or Cassandra databases to a managed service.

#### Cloud Datastore

**Cloud Datastore** is a managed document database (flexible JSON-like data structure).

**Terminology comparison:**

| Relational Database | Cloud Datastore |
|---|---|
| Table | Kind |
| Row | Entity |
| Column | Property |
| Primary Key | Key |

- Fully managed — GCP handles all data management operations including distributing data for performance.
- Good for applications with flexible schemas: product catalogs, user profiles.

#### Cloud Firestore

**Cloud Firestore** is the next generation of GCP's managed document database.

**Key features:**

- Strongly consistent
- Supports document and collection data models
- Supports real-time updates
- Provides mobile and web client libraries

**Modes:**

| Mode | Use Case | Notes |
|---|---|---|
| **Datastore mode** | New server-based projects | Backward compatible with Cloud Datastore; strongly consistent transactions; supports millions of writes per second |
| **Native (Firestore) mode** | New web and mobile applications | Provides client libraries; supports millions of concurrent connections |

> Best practice: Use Cloud Firestore in **Datastore mode** for new server-based projects, and **native mode** for new web and mobile apps.

---

### Caching with Cloud Memorystore

**Cloud Memorystore** is a managed cache service supporting both **Redis** and **Memcached**. Caches store data in non-persistent memory for low-latency access. Common use cases: stream processing and database caching.

#### Cloud Memorystore for Redis

**Redis** is an open source, in-memory data store with sub-millisecond data access.

**Supported data types:** strings, lists, sets, sorted sets, bitmaps, hyperloglogs.

| Feature | Details |
|---|---|
| Max instance size | 300 GB |
| Network throughput | 12 Gbps |
| Availability (replicated across 2 zones) | 99.9% |

**Service tiers:**

| Tier | Description |
|---|---|
| **Basic** | Simple Redis cache on a single server, no replication |
| **Standard** | Highly available with cross-zone replication and automatic failover |

GCP manages patching, replication, and failover.

#### Cloud Memorystore for Memcached

**Memcached** is an open source project for caching database queries, reference data, and session state. It stores string values indexed by key strings (no rich data types like Redis).

**Instance configuration:**

| Parameter | Range |
|---|---|
| Nodes per instance | 1 to 20 |
| vCPUs per node | 1 to 32 |
| Memory per node | 1 GB to 256 GB |
| Max combined instance memory | 5 TB |

Memcached (and Redis) can be accessed from:
- Compute Engine
- Google Kubernetes Engine
- Cloud Functions
- App Engine Flexible
- App Engine Standard (requires **Serverless VPC Access**)

---

## Data Retention and Lifecycle Management

Data moves through several lifecycle stages: creation → active use → infrequent access (online) → archived → deleted. Not all data goes through all stages.

**Choosing storage based on access patterns:**

| Access Pattern | Recommended Storage |
|---|---|
| Sub-millisecond access needed | Cloud Memorystore (cache) |
| Frequently accessed, may be updated, needs persistent storage | Database (relational or NoSQL based on structure) |
| Older data less likely to be accessed | Time-partitioned tables in BigQuery or Bigtable |
| Infrequently accessed, no query language needed | Cloud Storage (export from DB if needed) |
| Must be stored but unlikely to be accessed | Cloud Storage Archive class |

**Cloud Storage object lifecycle management policies:**

- Assigned to buckets; rules apply to objects in those buckets.
- **Lifecycle actions:** delete an object or set the storage class.
- **Rule triggers:** age of object, creation date, number of newer versions, current storage class.

**Retention policies:**

- Uses the **Bucket Lock** feature to enforce object retention.
- Ensures objects in the bucket are not deleted until they reach the specified age.
- Particularly useful for compliance with government or industry regulations.
- **Once a retention policy is locked, it cannot be revoked.**

---

## Networking and Latency

**Network latency** is a key consideration when data is transmitted between GCP regions or to globally distributed devices.

**Reference latencies:**

| Route | Typical Latency |
|---|---|
| Within Europe or Japan | 12–15 ms |
| Within North America | 30–32 ms |
| Trans-Atlantic | ~70 ms |
| Trans-Pacific | ~100 ms |
| EMEA to Asia Pacific | ~120 ms |

**Three ways to address network latency:**

1. **Replicating data in multiple regions and across continents** — using GCP services that manage multiregional/global distribution (Cloud Storage multiregional, Cloud Spanner, Cloud Firestore) is preferred over managing replication at the application level.

2. **Distributing data using Cloud CDN** — particularly effective for relatively static content distributed globally. Cloud CDN maintains globally distributed **points of presence** (where Google Cloud connects to the internet); frequently accessed static content can be cached at edge nodes near users.

3. **Using Google Cloud Premium Network Tier** — all data is routed over Google's global high-speed network to a point of presence near the destination device.

| Network Tier | Routing | Best Use |
|---|---|---|
| **Standard** | Public internet between regions | General use |
| **Premium** | Google's global network to nearest PoP | High-performance, low-latency, multi-region |

---

## Summary

GCP provides four types of storage systems:

| Type | Service | Best Use |
|---|---|---|
| **Object storage** | Cloud Storage | Unstructured data at object level; broad use cases from user uploads to long-term archives |
| **Network-attached storage** | Cloud Filestore | Actively processed file-structured data shared across multiple servers |
| **Relational databases** | Cloud SQL, Cloud Spanner | Structured transactional data; Cloud SQL for regional scale, Cloud Spanner for global scale |
| **Analytical database** | BigQuery | Data warehousing and analytic queries |
| **NoSQL databases** | Bigtable, Datastore, Firestore | Flexible schemas; Bigtable for low-latency petabyte writes; Datastore/Firestore for document data |
| **Caching** | Cloud Memorystore | Sub-millisecond in-memory access (Redis or Memcached) |

When designing storage systems, consider data lifecycle management and network latency. GCP provides services to implement data lifecycle management policies and offers access to the Google global network through the Premium Tier network service.

---

## Exam Essentials

- **Understand the major types of storage systems available in GCP.** Object storage (unstructured, atomic), persistent local/attached storage (VMs), relational databases (structured data), and NoSQL databases (flexible schemas).

- **Cloud Storage has multiple classes: Standard, Nearline, Coldline, and Archive.** Standard is available in regional, dual-regional, and multiregional options. Nearline: accessed less than once in 30 days. Coldline: less than once in 90 days. Archive: not more than once per year.

- **Cloud Filestore is a network-attached storage service accessible from Compute Engine and Kubernetes Engine.** Designed for low latency and high IOPS; useful for performance-sensitive services.

- **Cloud SQL is a managed relational database that runs on a single server.** Supports MySQL, SQL Server, and PostgreSQL. GCP manages patching, backups, and failover.

- **Cloud Spanner is a managed database service that supports horizontal scalability across regions.** Provides strong consistency at global scale. 99.999% availability (less than 5 minutes downtime per year). GCP manages patching, backup, and failover.

- **BigQuery is a managed data warehouse and analytical database solution.** Organized by datasets within projects. Uses its own command-line program `bq` (not `gcloud`). Billed based on data stored and data scanned per query.

- **Cloud Bigtable is designed to support petabyte-scale databases for analytic and operational use cases.** Sub-10 ms latency; used for ML model data, IoT streaming, time series, marketing, financial, and graph data.

- **Cloud Firestore and Cloud Datastore are managed document databases using a flexible JSON-like data structure.** Query response time is a function of the size of data returned, not the size of the full dataset. Good for product catalogs and user profiles. Cloud Firestore is the next generation.

- **Cloud Memorystore is a managed cache service** supporting Redis (up to 300 GB, 12 Gbps, 99.9% availability with cross-zone replication) and Memcached (1–20 nodes, 1–32 vCPUs, 1 GB–256 GB memory per node, up to 5 TB combined).

- **Cloud Storage provides object lifecycle management policies** to automatically change how objects are stored. Retention policies use the Bucket Lock feature to enforce object retention (useful for compliance). Once locked, a retention policy cannot be revoked.

- **Network latency is a key design consideration.** Three mitigation strategies: replicate data across multiple regions/continents, distribute static data using Cloud CDN, and use the Google Cloud Premium Network Tier.

---

## Review Questions

1. You need to store a set of files for an extended period. Anytime the data in the files needs to be accessed, it will be copied to a server first, and then the data will be accessed. Files will not be accessed more than once a year. The set of files will all have the same access controls. What storage solution would you use to store these files?
   - A. Cloud Storage Archive
   - B. Cloud Storage Nearline
   - C. Cloud Filestore
   - D. Bigtable

   **Answer: A.** Cloud Storage Archive is optimized for data accessed less than once per year and is the most cost-effective option for long-term storage.

2. You are uploading files in parallel to Cloud Storage and want to optimize load performance. What could you do to avoid creating hotspots when writing files to Cloud Storage?
   - A. Use sequential names or time stamps for files.
   - B. Do not use sequential names or time stamps for files.
   - C. Configure retention policies to ensure that files are not deleted prematurely.
   - D. Configure lifecycle policies to ensure that files are always using the most appropriate storage class.

   **Answer: B.** Sequentially named files are likely assigned to the same server, creating a hotspot. Avoid sequential names and timestamps.

3. As a consultant on a cloud migration project, you have been asked to recommend a strategy for storing files that must be highly available even in the event of a regional failure. What would you recommend?
   - A. BigQuery
   - B. Cloud Datastore
   - C. Multiregional Cloud Storage
   - D. Regional Cloud Storage

   **Answer: C.** Multiregional Cloud Storage replicates data across multiple regions, ensuring high availability even if one region fails.

4. As part of a migration to Google Cloud Platform, your department will run a collaboration and document management application on Compute Engine virtual machines. The application requires a filesystem that can be mounted using operating system commands. All documents should be accessible from any instance. What storage solution would you recommend?
   - A. Cloud Storage
   - B. Cloud Filestore
   - C. A document database
   - D. A relational database

   **Answer: B.** Cloud Filestore provides a network-attached filesystem that can be mounted using OS commands and accessed from any Compute Engine instance.

5. Your team currently supports seven MySQL databases for transaction processing applications. Management wants to reduce the amount of staff time spent on database administration. What GCP service would you recommend to help reduce the database administration load on your teams?
   - A. Bigtable
   - B. BigQuery
   - C. Cloud SQL
   - D. Cloud Filestore

   **Answer: C.** Cloud SQL is a managed MySQL service where GCP handles patching, backups, and failover.

6. Your company is developing a new service that will have a global customer base. The service will generate large volumes of structured data and require the support of a transaction processing database. All users, regardless of where they are on the globe, must have a consistent view of data. What storage system will meet these requirements?
   - A. Cloud Spanner
   - B. Cloud SQL
   - C. Cloud Storage
   - D. BigQuery

   **Answer: A.** Cloud Spanner provides horizontal scalability across regions with strong consistency — all global users see the same consistent data.

7. Your company is required to comply with several government and industry regulations, which include encrypting data at rest. What GCP storage services can be used for applications subject to these regulations?
   - A. Bigtable and BigQuery only
   - B. Bigtable and Cloud Storage only
   - C. Any of the managed databases, but no other storage services
   - D. Any GCP storage service

   **Answer: D.** All GCP storage services encrypt data at rest by default.

8. As part of your role as a data warehouse administrator, you occasionally need to export data from the data warehouse, which is implemented in BigQuery. What command-line tool would you use for that task?
   - A. `gsutil`
   - B. `gcloud`
   - C. `bq`
   - D. `cbt`

   **Answer: C.** BigQuery provides its own command-line program `bq` for managing BigQuery resources and operations.

9. Another task that you perform as data warehouse administrator is granting authorizations to perform tasks with the BigQuery data warehouse. A user has requested permission to view table data but not change it. What role would you grant to this user to provide the needed permissions but nothing more?
   - A. dataViewer
   - B. admin
   - C. metadataViewer
   - D. dataOwner

   **Answer: A.** `roles/bigquery.dataViewer` allows listing projects/tables and getting table data and metadata — read-only access.

10. A developer is creating a set of reports and is trying to minimize the amount of data each query returns while still meeting all requirements. What `bq` command-line option will help you understand the amount of data returned by a query without actually executing the query?
    - A. `--no-data`
    - B. `--estimate-size`
    - C. `--dry-run`
    - D. `--size`

    **Answer: C.** The `--dry-run` option returns an estimate of the number of bytes that would be returned if the query were executed, without actually running it.

11. A team of developers is choosing between using NoSQL or a relational database. What is a feature of NoSQL databases that is not available in relational databases?
    - A. Fixed schemas
    - B. ACID transactions
    - C. Indexes
    - D. Flexible schemas

    **Answer: D.** NoSQL databases support flexible (schema-less) data structures, which is a key differentiator from relational databases that require fixed schemas.

12. A group of venture capital investors has hired you to review the technical design of a service that will collect data from sensors attached to vehicles. Thirty sensors per vehicle send up to 5 KB of data every second. The startup expects to reach 1 million vehicles globally within 18 months. The data will be used to develop machine learning models for predictive maintenance. The startup is considering a self-managed relational database for time-series data. What would you recommend?
    - A. Continue to plan to use a self-managed relational database.
    - B. Use Cloud SQL.
    - C. Use Cloud Spanner.
    - D. Use Bigtable.

    **Answer: D.** Bigtable is designed for petabyte-scale time-series IoT data with sub-10 ms latency — ideally suited for this volume and use case.

13. A Bigtable instance increasingly needs to support simultaneous read and write operations. You'd like to separate the workload so that some nodes respond to read requests and others respond to write requests. How would you implement this to minimize the workload on developers and database administrators?
    - A. Create two instances, and separate the workload at the application level.
    - B. Create multiple clusters in the Bigtable instance, and use Bigtable replication to keep the clusters synchronized.
    - C. Create multiple clusters in the Bigtable instance, and use your own replication program to keep the clusters synchronized.
    - D. It is not possible to accomplish the partitioning of the workload as described.

    **Answer: B.** Bigtable supports multiple clusters within an instance with automatic replication — minimizing developer/admin overhead while separating read and write workloads.

14. As a database architect, you've been asked to recommend a database service to support an application that will make extensive use of JSON documents. What would you recommend to minimize database administration overhead while minimizing the work required for developers to store JSON data in the database?
    - A. Cloud Storage
    - B. Cloud Firestore
    - C. Cloud Spanner
    - D. Cloud SQL

    **Answer: B.** Cloud Firestore is a fully managed document database natively supporting JSON-like documents with minimal administration overhead.

15. Your Cloud SQL database is experiencing high query latency. You could vertically scale the database to use a larger instance, but you do not need additional write capacity. What else could you try to reduce the number of reads performed by the database?
    - A. Switch to Cloud Spanner.
    - B. Use Cloud Bigtable instead.
    - C. Use Cloud Memorystore to create a database cache that stores the results of database queries. Before a query is sent to the database, the cache is checked for the answer to the query.
    - D. Add read replicas to the Cloud SQL database.

    **Answer: C.** Cloud Memorystore provides a managed cache (Redis/Memcached) that can cache query results and significantly reduce the read load on the database.

16. You would like to move objects stored in Cloud Storage automatically from regional storage to Nearline storage when the object is six months old. What feature of Cloud Storage would you use?
    - A. Retention policies
    - B. Lifecycle policies
    - C. Bucket locks
    - D. Multiregion replication

    **Answer: B.** Cloud Storage lifecycle policies allow you to define rules that automatically change the storage class (or delete objects) based on age or other criteria.

17. A customer has asked for help with a web application. Static data served from a data center in Chicago in the United States loads slowly for users located in Australia, South Africa, and Southeast Asia. What would you recommend to reduce latency?
    - A. Distribute data using Cloud CDN.
    - B. Use Premium Network from the server in Chicago to client devices.
    - C. Scale up the size of the web server.
    - D. Move the server to a location closer to those users.

    **Answer: A.** Cloud CDN caches static content at globally distributed edge nodes (points of presence), significantly reducing latency for geographically dispersed users.

18. A data pipeline ingests performance monitoring data about a fleet of vehicles using Cloud Pub/Sub. The data is written to Cloud Bigtable to enable queries about specific vehicles. The data will also be written to BigQuery, and BigQuery ML will be used to build predictive models about failures in vehicle components. You would like to provide high throughput ingestion and exactly-once delivery semantics when writing data to BigQuery. How would you load that data into BigQuery?
    - A. BigQuery Transfer Service
    - B. Cloud Storage Transfer Service
    - C. BigQuery Storage Write API
    - D. BigQuery Load Jobs

    **Answer: C.** The BigQuery Storage Write API provides high-throughput ingestion and exactly-once delivery semantics — the stated requirements.
