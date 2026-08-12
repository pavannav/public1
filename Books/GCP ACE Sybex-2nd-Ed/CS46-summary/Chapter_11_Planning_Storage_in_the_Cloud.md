# Chapter 11: Planning Storage in the Cloud

## Exam Objective Covered

- **2.3 Planning and configuring data storage options**

---

## Introduction

This chapter focuses on **storage concepts** for choosing the right GCP storage solution. Key dimensions for comparing storage solutions:

- **Time to access data** (latency)
- **Data model** (object, relational, analytical, NoSQL)
- **Other features**: consistency, availability, transaction support

---

## Types of Storage Systems

### Time and Latency Units

| Unit | Value | Example |
|---|---|---|
| Nanosecond (ns) | 10⁻⁹ second | L1 CPU cache: 0.5 ns |
| Microsecond (μs) | 10⁻⁶ second | L2/L3 cache |
| Millisecond (ms) | 10⁻³ second | Disk / network access |

**Persistence vs. latency trade-off:**
- **Caches** — lowest latency; volatile (data lost on power off)
- **Persistent disks** — durable; higher latency than cache; can fail (mitigated by redundancy)
- **Object storage** — exabyte-scale; highest latency among storage tiers

---

### Cache

A **cache** is an in-memory data store providing **submillisecond** access to data.

**Limitations:** limited to available memory; volatile (data lost if server shuts down).

**Use case:** Reduce database read latency. Store recently retrieved data in cache; subsequent reads come from cache rather than disk.

> Reading from an HDD can take ~80× longer than reading from an in-memory cache.

#### Memorystore

Google's managed cache service — compatible with **Redis** and **Memcached** (open source protocols).

| Feature | Redis | Memcached |
|---|---|---|
| Max memory per instance | 300 GB | Up to 5 TB (up to 20 nodes × 256 GB each) |
| High availability | Standard tier (failover replicas) | Cluster of nodes |
| Lower cost option | Basic tier (no replica) | Single node |

**Works with:** Compute Engine, App Engine, Kubernetes Engine.

#### Configuring Memorystore

Navigate to **Memorystore → Create Redis Instance** in Cloud Console.

![Configuration parameters for a Memorystore Redis cache](../images/c11f001.png)

**Figure 11.1** Configuration parameters for a Memorystore Redis cache

**Required parameters:**
- Instance ID and display name
- Redis version
- Tier: **Standard** (with failover replica) or **Basic** (no replica, lower cost)
- Region and zone
- Memory: **1 GB to 300 GB**
- Network (defaults to default VPC)

**Advanced options:** Labels, IP range assignment.

---

### Persistent Storage

**Persistent disks** provide durable **block storage** for VMs in Compute Engine (GCE) and GKE.

**Key characteristics:**
- Network-accessible (not directly attached to physical servers)
- Data persists after VM shutdown/termination
- Can be **resized while mounted** (OS commands may be needed to use new space)
- Automatically **encrypt data at rest**
- Can be mounted on **multiple VMs** in read-only mode (multireader storage)
- Snapshots can be created and distributed to other VMs

**Contrast with Local SSDs:**

| Feature | Persistent Disk | Local SSD |
|---|---|---|
| Durability | Data persists after VM stop | **Lost when VM terminates** |
| Max capacity | 64 TB | Fixed 375 GB |
| Redundancy | Yes | No |
| Attachment | Network | Direct (local) |

#### Persistent Disk Types

| Type | Storage Medium | Scope | Notes |
|---|---|---|---|
| Zonal standard PD | HDD | Single zone | Efficient and reliable block storage |
| Regional standard PD | HDD | 2 zones (sync replication) | Higher availability |
| Zonal balanced PD | SSD | Single zone | Cost-effective SSD |
| Regional balanced PD | SSD | 2 zones (sync replication) | Higher availability |
| Zonal SSD PD | SSD | Single zone | Fast and reliable |
| Regional SSD PD | SSD | 2 zones (sync replication) | Higher availability |
| Zonal extreme PD | SSD | Single zone | **Highest performance** |

- **SSD** — high throughput; consistent performance for random and sequential access
- **HDD** — lower cost; higher latency; suited for large datasets with batch operations

#### Configuring Persistent Disks

Navigate to **Compute Engine → Disks → Create A Disk**.

![Form to create a persistent disk](../images/c11f002.png)

**Figure 11.2** Form to create a persistent disk

**Configuration options:**
- Name (required), description (optional)
- Disk type: standard or SSD
- Replica within region (for higher availability)
- Region and zone
- Labels
- Source: blank, image, or snapshot
- **Encryption:** Google-managed (default), CMEK (Cloud KMS), or CSEK (customer-supplied key)

> Use an **image** to create a boot disk. Use a **snapshot** to create a replica of an existing disk.

---

### Object Storage

**Cloud Storage** — Google's object storage for sharing and long-term storage of **up to exabytes** of data.

#### Features of Cloud Storage

- Files stored as **atomic objects** — cannot read partial files or overwrite sections
- No filesystem — buckets organize objects, but are not true directories
- **No concurrency/locking** — last writer wins
- **Bucket names are globally unique** (shared global namespace)
- **Cloud Storage Fuse** — open source project that mounts a bucket as a Linux/Mac filesystem (for convenience only; inherits Cloud Storage limitations)

#### Storage Classes

| Class | Access Frequency | Min Duration | Retrieval Charge | Availability (multi-region) |
|---|---|---|---|---|
| **Standard** | Frequent ("hot data") | None | No | 99.95% |
| **Nearline** | < once/month | 30 days | Yes | 99.95% |
| **Coldline** | < once/90 days | 90 days | Yes | 99.95% |
| **Archive** | < once/year | 365 days | Yes | 99.9% |

> Nearline, Coldline, and Archive incur **data retrieval charges** in addition to storage costs.

#### Regional, Dual-Regional, and Multi-Regional Storage

| Location Type | Redundancy | Availability SLA | Use Case |
|---|---|---|---|
| **Region** | Multiple zones in one region | 99.9% | Single-region access |
| **Dual-region** | 2 specific regions | 99.95% | Higher availability |
| **Multi-region** | Large geographic area (US, EU, Asia) | 99.95% | Global access, lower latency across regions |

> **Georedundant** = data stored in ≥2 locations ≥100 miles apart. Multi-region storage is georedundant.

#### Versioning and Object Life Cycle Management

**Versioning:** When enabled on a bucket, each overwrite or delete creates an archived copy. The current copy is the **live version**.

- Useful for: change history, accidental deletion recovery

**Life Cycle Management:** Rules applied to buckets that automatically act on objects.

- **Condition types:** Age, Creation Date, Storage Class, Newer Versions, Live State
- **Actions:** Delete object or change storage class

**Allowed storage class transitions:**

| From | Can Transition To |
|---|---|
| **Standard** | Nearline, Coldline, Archive |
| **Nearline** | Coldline, Archive |
| **Coldline** | Archive |
| **Archive** | *(none — cannot transition out)* |

> Deleting the **live version** of a versioned object archives it rather than permanently deleting it. Deleting an **archived version** permanently deletes it.

#### Configuring Cloud Storage

Navigate to **Storage → Create Bucket**.

![Form to create a storage bucket from the console](../images/c11f003.png)

**Figure 11.3** Form to create a storage bucket from the console. Advanced options are displayed.

**Required:** bucket name, storage class. **Optional:** labels, encryption keys, retention policy.

**Define a life cycle policy** via the **Lifecycle** tab of the bucket list:

![The list of buckets includes a link to define or modify life cycle policies](../images/c11f004.png)

**Figure 11.4** The list of buckets includes a link to define or modify life cycle policies.

![When creating a life cycle policy, click the Add Rule option](../images/c11f005.png)

**Figure 11.5** When creating a life cycle policy, click the Add Rule option, which is in the lower horizontal menu, to define a rule.

![Listing of buckets in Cloud Storage Browser](../images/c11f006.png)

**Figure 11.6** Listing of buckets in Cloud Storage Browser

---

### Storage Types Summary for Planning

| Storage Type | Access Speed | Capacity | Durability | Best For |
|---|---|---|---|---|
| **Cache (Memorystore)** | Submillisecond | Limited by memory | Volatile | Reduce DB latency |
| **Persistent Disk (SSD)** | Low ms | Up to 64 TB | High | High-throughput VM storage |
| **Persistent Disk (HDD)** | Higher ms | Up to 64 TB | High | Large volumes, batch workloads |
| **Object Storage (Cloud Storage)** | Higher | Up to exabytes | Very high | Shared files, archival, ML data |

---

## Storage Data Models

Four broad categories of data models in Google Cloud:

| Model | Service(s) | Best For |
|---|---|---|
| **Object** | Cloud Storage | Large files, atomic access |
| **Relational** | Cloud SQL, Cloud Spanner | Transactions, structured data, SQL |
| **Analytical** | BigQuery | Data warehousing, petabyte-scale queries |
| **NoSQL** | Cloud Firestore, Bigtable | Unstructured/semi-structured, high-scale |

---

### Object: Cloud Storage

Files are atomic — read/written in entirety. No fine-grained access inside an object while in storage.

**Best for:** Archived data, ML training data, old IoT data retained for compliance.

---

### Relational: Cloud SQL and Cloud Spanner

Relational databases provide:
- **Transactions** — atomic sets of operations (all succeed or all fail; partial failures roll back)
- **Strong consistency** — all users see the same data at the same time
- **SQL** query language

| Service | Scale | Use Case |
|---|---|---|
| **Cloud SQL** | Vertical (bigger VMs) | Web apps, e-commerce; MySQL, PostgreSQL, SQL Server |
| **Cloud Spanner** | Horizontal (global clusters) | Global supply chains, financial services; petabyte-scale, globally consistent |

#### Configuring Cloud SQL

Navigate to **Cloud SQL → Create Instance** → choose database engine.

![Cloud SQL provides MySQL, PostgreSQL, and SQL Server instances](../images/c11f007.png)

**Figure 11.7** Cloud SQL provides MySQL, PostgreSQL, and SQL Server instances.

**MySQL configuration parameters:**

| Parameter | Details |
|---|---|
| MySQL version | Selectable |
| Connectivity | Public or private IP |
| Machine type | Default: db-n1-standard-1 (1 vCPU, 3.75 GB RAM) |
| Automatic backups | Configurable |
| Failover replicas | Optional |
| Database flags | Read-only flag, query cache size, etc. |
| Maintenance window | Specify preferred time |
| Labels | Optional |

![Configuration form for a MySQL instance](../images/c11f008.png)

**Figure 11.8** Configuration form for a MySQL instance

![Configuration form for a SQL Server instance](../images/c11f009.png)

**Figure 11.9** Configuration form for a SQL Server instance

![Configuration form for a PostgreSQL instance](../images/c11f010.png)

**Figure 11.10** Configuration form for a PostgreSQL instance

#### Configuring Cloud Spanner

Navigate to **Cloud Spanner → Create Instance**.

![The Cloud Spanner configuration form in Cloud Console](../images/c11f011.png)

**Figure 11.11** The Cloud Spanner configuration form in Cloud Console

**Required parameters:** instance name, instance ID, number of nodes, regional or multiregional configuration.

> Higher cost configurations: **multiregional** (e.g., `nam-eur-asia1`) cost more than regional (e.g., `us-central1`).

---

### Analytical: BigQuery

**BigQuery** is a **serverless** data warehouse and analytics service.

- Stores **petabytes** of data
- SQL query language
- Suited for large numbers of rows/columns
- **Not suited** for transaction-oriented applications (e-commerce, interactive web apps)
- Includes storage + query + statistical + ML analysis tools
- No VM instance configuration required

#### Configuring BigQuery

Navigate to **BigQuery** from the console menu.

![BigQuery user interface for creating and querying data](../images/c11f012.png)

**Figure 11.12** BigQuery user interface for creating and querying data

First step: **Create a dataset** (the container for tables).

![Form to create a dataset in BigQuery](../images/c11f013.png)

**Figure 11.13** Form to create a dataset in BigQuery

**Required:** dataset name, region. (Not all regions support BigQuery.)

---

### NoSQL: Cloud Firestore and Bigtable

NoSQL databases have **no fixed schema** — different records can have different attributes.

#### Firestore Features

**Firestore** is a **document database** — data is organized into documents (sets of key-value pairs).

**Example document (entity):**

```json
{
  "book": "ACE Study Guide",
  "chapter": 11,
  "length": 20,
  "topic": "storage"
}
```

- **Entity** — a document (set of key-value pairs)
- **Kind** — analogous to a table in a relational database
- **Namespace** — groups entities, analogous to a schema

**Features:**
- Serverless (no server management)
- Auto-partitions and scales
- Supports **transactions** and **indexes**
- Does **not** support: fixed schemas, joins, aggregates (SUM, COUNT)

**Firestore modes:**

| Mode | Best For |
|---|---|
| **Native mode** | Scales to millions of clients; document/collection model |
| **Datastore mode** | Scales to millions of writes/second; entity/kind model |

> Cloud Firestore is the successor to Cloud Datastore.

**Best for:** Product catalogs (varying attributes per product), user profiles, mobile app back-ends.

#### Configuring Firestore

Navigate to **Firestore** in Cloud Console — choose **Native mode** or **Datastore mode**, then select storage location (regional or multiregional).

![The Firestore user interface allows you to choose between Native and Datastore modes](../images/c11f014.png)

**Figure 11.14** The Firestore user interface allows you to choose between Native and Datastore modes.

![Choosing a storage location](../images/c11f015.png)

**Figure 11.15** Choosing a storage location

---

#### Bigtable Features

**Bigtable** is a **wide-column** NoSQL database — tables with a very large number of columns; not all rows need all columns.

| Feature | Details |
|---|---|
| Scale | Petabyte-scale |
| Latency | Consistent, low-millisecond |
| Scalability | Horizontal (clusters) |
| Workload types | Operational (IoT data storage) AND analytical (data science) |

**Best for:** Time series data, IoT applications, financial data — high volume + high-velocity ingestion.

#### Configuring Bigtable

Navigate to **Bigtable → Create Instance**.

![Configuration form for Bigtable](../images/c11f016.png)

**Figure 11.16** Configuration form for Bigtable

**Configuration options:**

| Parameter | Details |
|---|---|
| Instance name and ID | Required |
| Mode | **Production** (min 3 nodes, high availability) or **Development** (low-cost, no replication) |
| Disk type | SSD or HDD |
| Cluster ID | Per cluster |
| Region and zone | Per cluster |
| Number of nodes | Per cluster |
| Replication | Optional (for improved availability) |

---

> ### Real World Scenario: The Need for Multiple Databases
>
> Healthcare organizations need multiple database types:
>
> - **Cloud SQL** (relational) — patient demographics, diagnoses, treatments, prescriptions: highly structured, requires transaction support and strong consistency
> - **BigQuery** (analytical) — data warehouse built from extracted/transformed relational data, enabling data scientists to identify patterns (e.g., hospital readmission predictors) that transactional databases are not suited for
>
> This is a common enterprise pattern: **OLTP** (Online Transaction Processing) → **ETL** → **OLAP** (Online Analytical Processing / Data Warehouse).

---

## Choosing a Storage Solution: Guidelines to Consider

| Factor | Considerations | Best Options |
|---|---|---|
| **Read/Write Patterns** | Frequent reads/writes with updates | Cloud SQL (structured), Cloud Spanner (global) |
| | High-velocity, high-volume writes | Bigtable |
| | Upload and download whole files | Cloud Storage |
| **Consistency** | Strong consistency always | Cloud SQL, Cloud Spanner |
| | Strong or tunable consistency | Firestore |
| | Eventual consistency acceptable | Bigtable, Cloud Storage |
| **Transaction Support** | Atomic multi-step operations required | Cloud SQL, Cloud Spanner, Firestore |
| **Cost** | Account for: storage size, data retrieval, scanned data, VM costs | Compare per-GB and access charges |
| **Latency** | Consistently low (millisecond) | Bigtable |
| | Low latency globally | Cloud Spanner (higher latency, globally consistent) |
| | Submillisecond | Memorystore (cache) |

> **Key insight:** Choosing a data store is about trade-offs. A low-cost, globally scalable, low-latency, strongly consistent database doesn't exist. You give up one or more characteristics.

---

## Summary

| Storage/Database | Type | Key Characteristic |
|---|---|---|
| **Memorystore** | Cache (Redis/Memcached) | Submillisecond; volatile |
| **Persistent Disk** | Block storage | Durable; attached to VMs |
| **Cloud Storage** | Object storage | Exabyte-scale; atomic files |
| **Cloud SQL** | Relational (OLTP) | MySQL, PostgreSQL, SQL Server; vertical scale |
| **Cloud Spanner** | Relational (OLTP, global) | Horizontal scale; global consistency |
| **BigQuery** | Analytical (OLAP) | Petabyte-scale; serverless; SQL |
| **Cloud Firestore** | NoSQL — Document | Schema-less; transactions; auto-scale |
| **Bigtable** | NoSQL — Wide-column | Petabyte; low-ms latency; IoT/time series |

---

## Exam Essentials

- **Know the major storage system types.** Caches (Memorystore) for submillisecond access; persistent disks for block storage on VMs; Cloud Storage for large-scale object/file sharing.

- **Know the major data models.** Relational (Cloud SQL, Cloud Spanner) for transactions and consistency; BigQuery for analytics/data warehousing; object model (Cloud Storage) for atomic file access; NoSQL: Firestore (document) and Bigtable (wide-column).

- **Know Cloud Storage classes.** Standard (frequent), Nearline (<once/month, 30-day min), Coldline (<once/90 days, 90-day min), Archive (<once/year, 365-day min). Nearline, Coldline, and Archive have retrieval charges.

- **Know that applications may need multiple data stores.** E.g., Memorystore cache + Cloud SQL + Cloud Storage + BigQuery for a single enterprise application.

- **Know life cycle configuration transitions.** Standard → Nearline/Coldline/Archive; Nearline → Coldline/Archive; Coldline → Archive. Archive cannot transition to any other class.

- **Know storage selection factors.** Read/write patterns, consistency requirements, transaction support, cost, and latency.

---

## Review Questions

1. You need to consider all possible life cycle transitions between storage classes. All of the following transitions are allowed except for which one?
   - A. Nearline to Coldline
   - B. Coldline to Archive
   - C. Standard to Nearline
   - **D. Archive to Standard**

2. Your manager wants to reduce Cloud Storage charges. Some files are rarely accessed more than once every 90 days. What kind of storage would you recommend?
   - A. Nearline
   - B. Standard
   - **C. Coldline**
   - D. Archive

3. You are working with a startup developing analytics software for IoT data. You need to ingest large volumes consistently, store for several months, and expect petabyte volumes. Which database should you use?
   - A. Cloud Spanner
   - **B. Bigtable**
   - C. BigQuery
   - D. Firestore

4. A developer wants to improve query performance on a Cloud SQL MySQL database while continuing to use a relational database. Which options would you recommend?
   - **A. Memorystore and SSD persistent disks**
   - B. Memorystore and HDD persistent disks
   - C. Firestore and SSD persistent disks
   - D. Firestore and HDD persistent disks

5. You are creating persistent disks for exploratory data analysis. Analysts need cost-efficient storage (not peak performance) for a local relational database. Which type of storage would you recommend?
   - A. SSDs
   - **B. HDDs**
   - C. Firestore
   - D. Bigtable

6. Which of the following statements about Cloud Storage is not true?
   - A. Cloud Storage buckets can have retention periods.
   - **B. Lifecycle configurations can be used to change storage class from Archive to Standard.**
   - C. Cloud Storage does not provide block-level access to data within files stored in buckets.
   - D. Cloud Storage is designed for high durability.

7. When using versioning on a bucket, what is the latest version of the object called?
   - **A. Live version**
   - B. Top version
   - C. Active version
   - D. Safe version

8. A product manager needs transaction support and tabular data with common query tools. What databases would you recommend?
   - A. BigQuery and Spanner
   - **B. Cloud SQL and Spanner**
   - C. Cloud SQL and Bigtable
   - D. Bigtable and Spanner

9. What two types of databases are available in Cloud SQL?
   - A. Oracle and MySQL
   - B. Oracle and PostgreSQL
   - **C. PostgreSQL and MySQL**
   - D. MySQL and DB2

   > **Note:** Cloud SQL supports MySQL, PostgreSQL, and SQL Server. The question asks for two; the answer C (PostgreSQL and MySQL) is the best match among the options. SQL Server is also available.

10. Which of the following Cloud Spanner configurations would have the highest hourly cost?
    - A. Located in us-central1
    - B. Located in nam3
    - C. Located in us-west1-a
    - **D. Located in nam-eur-asia1**

    > Multi-region configurations spanning North America, Europe, and Asia cost the most.

11. Which of the following are database services that do not require you to specify configuration information for VMs?
    - A. BigQuery only
    - B. Firestore only
    - C. Bigtable only
    - **D. BigQuery and Firestore**

12. What kind of data model is used by Firestore?
    - A. Relational
    - **B. Document**
    - C. Wide-column
    - D. Graph

13. You need to create a data warehouse supporting tens of petabytes and using SQL. Which managed database service would you choose?
    - **A. BigQuery**
    - B. Bigtable
    - C. Cloud SQL
    - D. IBM DB2

14. A mobile development team needs to synchronize data between mobile devices and a back-end database. Which service would you recommend?
    - A. BigQuery
    - **B. Firestore**
    - C. Spanner
    - D. Bigtable

15. What features of storage should a product manager consider when planning new features requiring additional storage?
    - A. Read and write patterns only.
    - B. Cost only.
    - C. Consistency and cost only.
    - **D. They are all relevant considerations.**

16. What is the maximum size of a Memorystore cache when using Redis?
    - A. 100 GB
    - **B. 300 GB**
    - C. 400 GB
    - D. 50 GB

17. Once a bucket has its storage class set to Archive, what other storage classes can it transition to?
    - A. Standard
    - B. Nearline
    - C. Coldline
    - **D. None of the above**

18. Before you can start storing data in BigQuery, what must you create?
    - **A. A dataset**
    - B. A bucket
    - C. A persistent disk
    - D. An entity

19. What features can you configure when running a MySQL database in Cloud SQL?
    - A. Machine type
    - B. Maintenance windows
    - C. Failover replicas
    - **D. All of the above**

20. A colleague moved all storage to Nearline and Coldline to save costs, but charges increased. They access most objects daily. What is one possible reason costs are higher than expected?
    - **A. Nearline and Coldline incur access charges.**
    - B. Transfer charges are involved.
    - C. Egress charges are involved.
    - D. None of the above.
