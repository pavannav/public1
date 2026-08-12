# Chapter 12: Deploying Storage in Google Cloud

## Exam Objectives Covered

- **3.4 Deploying and implementing data solutions**
- **4.4 Managing storage and database solutions**

---

## Introduction

This chapter covers practical deployment and management tasks for Google Cloud storage services:

- Cloud SQL
- Cloud Firestore (Datastore)
- BigQuery
- Cloud Spanner
- Cloud Pub/Sub
- Cloud Bigtable
- Cloud Dataproc
- Cloud Storage

**Key CLI tools used in this chapter:**

| Tool | Used For |
|---|---|
| `gcloud` | Most GCP services (SQL, Spanner, Dataproc, Pub/Sub, Firestore) |
| `gsutil` | Cloud Storage operations |
| `bq` | BigQuery operations |
| `cbt` | Bigtable operations |

---

## Deploying and Managing Cloud SQL

Cloud SQL is a managed relational database service. Cloud engineers manage: creating databases, loading data, querying, and backups. Google handles: OS patches, hardware, and infrastructure.

### Creating and Connecting to a MySQL Instance

Navigate to **Cloud SQL → Create Instance → Choose MySQL**.

![Creating a MySQL instance](../images/c12f001.png)

**Figure 12.1** Creating a MySQL instance

After a few minutes the instance is created and appears in the instance list.

![A listing of MySQL instances](../images/c12f002.png)

**Figure 12.2** A listing of MySQL instances

**Connect via Cloud Shell:**

```bash
gcloud sql connect ace-exam-mysql --user=root
```

- Do not specify the password on the command line — you will be prompted
- You may see a message about allowing your IP address (security measure for Cloud Shell access)

![Command-line prompt to work with MySQL after connecting using gcloud sql connect](../images/c12f003.png)

**Figure 12.3** Command-line prompt to work with MySQL after connecting using `gcloud sql connect`

---

### Creating a Database, Loading Data, and Querying Data

Inside the MySQL prompt, use standard **MySQL/SQL commands** (not `gcloud`):

**Create a database and set it as active:**

```sql
CREATE DATABASE ace_exam_book;
USE ace_exam_book;
```

**Create a table:**

```sql
CREATE TABLE books (
    title VARCHAR(255),
    num_chapters INT,
    entity_id INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (entity_id)
);
```

**Insert rows:**

```sql
INSERT INTO books (title, num_chapters) VALUES ('ACE Exam Study Guide', 18);
INSERT INTO books (title, num_chapters) VALUES ('Architecture Exam Study Guide', 18);
```

**Query the table:**

```sql
SELECT * FROM books;
```

![Listing the contents of a table in MySQL](../images/c12f004.png)

**Figure 12.4** Listing the contents of a table in MySQL

---

### Backing Up MySQL in Cloud SQL

Cloud SQL supports both **on-demand** and **automatic** backups.

#### On-Demand Backup (Console)

Navigate to **Cloud SQL → [Instance Name] → Backups → Create Backup**.

![Partial listing of MySQL Instance Details page with vertical menu displayed on the left](../images/c12f005.png)

**Figure 12.5** Partial listing of MySQL Instance Details page with vertical menu displayed on the left

![Create Backup button](../images/c12f006.png)

**Figure 12.6** Create Backup button

![Assign a description to a backup and create it](../images/c12f007.png)

**Figure 12.7** Assign a description to a backup and create it.

![Listing of backups available for this instance](../images/c12f008.png)

**Figure 12.8** Listing of backups available for this instance

#### On-Demand Backup (Command Line)

```bash
gcloud sql backups create --async --instance ace-exam-mysql
```

- `--async` — optional; returns immediately without waiting for backup to complete
- `--instance` — specifies the Cloud SQL instance name

#### Automatic Backups (Console)

Navigate to **Cloud SQL → [Instance] → Edit Instance → Enabled Auto Backups** → specify time window.

You can also enable **binary logging** here (required for point-in-time recovery).

![Enabling automatic backups in Cloud Console](../images/c12f009.png)

**Figure 12.9** Enabling automatic backups in Cloud Console

#### Automatic Backups (Command Line)

```bash
gcloud sql instances patch ace-exam-mysql --backup-start-time 01:00
```

Format: `HH:MM` in 24-hour time.

---

## Deploying and Managing Firestore

Cloud Firestore is the successor to Cloud Datastore. It has two modes:

| Mode | Best For | Key Feature |
|---|---|---|
| **Native mode** | Mobile/web apps | Real-time updates, mobile/web client libraries, scales to millions of clients |
| **Datastore mode** | High-write workloads | Scales to millions of writes/second; supports **GQL** (SQL-like query language) |

Both modes support **strong consistency** and a **document data model**.

### Adding Data to a Firestore Database

In **Native mode**, data is organized into **Collections** (analogous to schemas) containing **Documents** (key-value pairs).

Navigate to **Firestore → Start Collection** → provide a **Collection ID** → add documents with key-value pairs and data types.

![Adding data to a Firestore collection](../images/c12f010.png)

**Figure 12.10** Adding data to a Firestore collection

![Viewing data in Firestore, Native mode](../images/c12f011.png)

**Figure 12.11** Viewing data in Firestore, Native mode

---

### Backing Up Firestore

**Step 1:** Create a Cloud Storage bucket for the backup:

```bash
gsutil mb gs://ace_exam_backups/
```

**Step 2:** Required IAM permissions:
- `datastore.databases.export` — for backups
- `datastore.databases.import` — for restores
- **Cloud Datastore Import Export Admin** role — grants both

**Step 3:** Export (backup):

```bash
gcloud firestore export gs://ace_exam_backups
```

**Step 4:** Import (restore):

```bash
gcloud firestore import gs://ace_exam_backups
```

---

## Deploying and Managing BigQuery

BigQuery is **fully managed** — Google handles backups and administration. Cloud engineer tasks focus on **cost estimation** and **job monitoring**.

### Estimating the Cost of Queries in BigQuery

Navigate to **BigQuery** in Cloud Console and enter a query in the Query Editor. BigQuery displays an estimate of **data scanned** in the upper-right corner.

![The BigQuery console](../images/c12f012.png)

**Figure 12.12** The BigQuery console

![Example query with estimated amount of data scanned](../images/c12f013.png)

**Figure 12.13** Example query with estimated amount of data scanned

**Estimate data scanned from the command line (dry run):**

```bash
bq --location=[LOCATION] query --use_legacy_sql=false --dry_run [SQL_QUERY]
```

**Estimate cost using the Pricing Calculator:**

1. Go to the **GCP Pricing Calculator**
2. Select **BigQuery → On-Demand tab**
3. Enter the table name, set storage to **0**, enter query size in Queries section
4. Click **Add To Estimate**

![Using the Pricing Calculator to estimate the cost of a query](../images/c12f014.png)

**Figure 12.14** Using the Pricing Calculator to estimate the cost of a query

---

### Viewing Jobs in BigQuery

BigQuery **jobs** are automatically created for: load, export, copy, and query operations.

**View jobs in Console:** Navigate to **BigQuery → Personal History** or **Project History**.

- ✓ Check mark = job completed successfully
- ⚠ Exclamation icon = job failed

![A listing of job statuses in BigQuery](../images/c12f015.png)

**Figure 12.15** A listing of job statuses in BigQuery

**View job status from command line:**

```bash
bq --location=US show -j gcpace-project:US.bquijob_119adae7_167c373d5c3
```

---

## Deploying and Managing Cloud Spanner

Cloud Spanner is a managed global relational database. Engineers focus on designing tables and queries — no patching, backups, or OS maintenance required.

### Creating a Spanner Instance and Database

Navigate to **Cloud Spanner → Create Instance**.

![Creating a Cloud Spanner instance](../images/c12f016.png)

**Figure 12.16** Creating a Cloud Spanner instance

After creating the instance, click **Create Database** on the Instance Details page.

![Create a database within a Cloud Spanner instance](../images/c12f017.png)

**Figure 12.17** Create a database within a Cloud Spanner instance.

### Defining Schema with SQL DDL

Use **SQL Data Definition Language (DDL)** to create tables and indexes:

**Table 12.1** SQL Data Definition Commands

| Command | Description |
|---|---|
| `CREATE TABLE` | Creates a table with columns and data types |
| `CREATE INDEX` | Creates an index on specified column(s) |
| `ALTER TABLE` | Changes table structure |
| `DROP TABLE` | Removes a table from the schema |
| `DROP INDEX` | Removes an index from the schema |

Cloud Console provides **DDL templates** to assist with creating tables and other objects.

![Creating a table using a DDL template](../images/c12f018.png)

**Figure 12.18** Creating a table using a DDL template

![DDL templates available to help you create database objects in Spanner](../images/c12f019.png)

**Figure 12.19** DDL templates available to help you create database objects in Spanner

After creating a table, you can view its structure and properties:

![Details of the table created in Spanner](../images/c12f020.png)

**Figure 12.20** Details of the table created in Spanner

From the table schema view, you can navigate to **Cloud Logging** to see the history of schema changes:

![Log of changes to Spanner table](../images/c12f021.png)

**Figure 12.21** Log of changes to Spanner table

Spanner-related IAM roles can be managed from the **Show Info panel** on the instance list:

![From the Show Info panel, you can view and manage Spanner-related roles](../images/c12f022.png)

**Figure 12.22** From the Show Info panel, you can view and manage Spanner-related roles.

---

## Deploying and Managing Cloud Pub/Sub

Pub/Sub is a **message queue** service. Two resources are required:

| Resource | Description |
|---|---|
| **Topic** | Structure where applications publish (send) messages |
| **Subscription** | How applications read messages from a topic |

### Creating a Topic and Subscription (Console)

Navigate to **Pub/Sub → Create A Topic**.

![Creating a Pub/Sub topic](../images/c12f023.png)

**Figure 12.23** Creating a Pub/Sub topic

![List of subscriptions](../images/c12f024.png)

**Figure 12.24** List of subscriptions

After creating a topic, view the topic list:

![Subscription details](../images/c12f025.png)

**Figure 12.25** Subscription details

To create a subscription, click the ellipsis (⋮) icon on the topic → **Create Subscription**:

![Creating a subscription to a topic](../images/c12f026.png)

**Figure 12.26** Creating a subscription to a topic

**Subscription configuration options:**

| Parameter | Description |
|---|---|
| Subscription name | Name for this subscription |
| Delivery type | **Pull** (app reads from topic) or **Push** (Pub/Sub writes to an endpoint URL) |
| Acknowledgment Deadline | Time to wait for acknowledgment after delivery: **10–600 seconds** |
| Retention period | How long to keep undelivered messages before deleting |

![The options for creating a subscription](../images/c12f027.png)

**Figure 12.27** The options for creating a subscription

![A list of subscriptions](../images/c12f028.png)

**Figure 12.28** A list of subscriptions

### Creating Topics and Subscriptions (Command Line)

```bash
gcloud pubsub topics create [TOPIC-NAME]
gcloud pubsub subscriptions create [SUBSCRIPTION-NAME] --topic [TOPIC-NAME]
```

---

## Deploying and Managing Cloud Bigtable

Bigtable is managed via the **`cbt`** command-line tool (not `gcloud` or SQL).

### Creating a Bigtable Instance

Navigate to **Bigtable → Create Instance**.

![Creating a Bigtable instance](../images/c12f029.png)

**Figure 12.29** Creating a Bigtable instance

After creation, view performance summary in the Instance Details page:

![Instance details, including performance data](../images/c12f030.png)

**Figure 12.30** Instance details, including performance data

### Installing and Configuring cbt

**Install `cbt` in Cloud Shell:**

```bash
gcloud components update
gcloud components install cbt
```

**Configure the instance in `.cbtrc`:**

```bash
echo instance = ace-exam-bigtable >> ~/.cbtrc
```

This sets the default Bigtable instance for all `cbt` commands.

### cbt Commands

**Table 12.2** `cbt` Commands

| Command | Description |
|---|---|
| `createtable` | Creates a table |
| `createfamily` | Creates a column family |
| `read` | Reads and displays rows |
| `ls` | Lists tables and columns |

**Create a table:**

```bash
cbt createtable ace-exam-bt-table
```

**List tables:**

```bash
cbt ls
```

**Create a column family:**

```bash
cbt createfamily ace-exam-bt-table colfam1
```

**Insert a value:**

```bash
cbt set ace-exam-bt-table row1 colfam1:col1=ace-exam-value
```

**Read the table:**

```bash
cbt read ace-exam-bt-table
```

> **Note:** Bigtable is a wide-column NoSQL database. It uses **column families** to group related columns. Not all rows need values for all columns.

---

## Deploying and Managing Cloud Dataproc

**Cloud Dataproc** is Google's managed **Apache Spark** and **Apache Hadoop** service.

| Platform | Best For |
|---|---|
| **Spark** | Analysis, machine learning (includes MLlib) |
| **Hadoop** | Batch processing, large-scale ETL |

### Creating a Dataproc Cluster

Navigate to **Dataproc → Create Cluster** → choose infrastructure:

| Infrastructure Option | When to Use |
|---|---|
| **Compute Engine** | Default; no existing GKE cluster needed |
| **Google Kubernetes Engine** | If you have an existing GKE cluster |

![Choose an infrastructure for your cluster, either Compute Engine or Google Kubernetes Engine](../images/c12f031.png)

**Figure 12.31** Choose an infrastructure for your cluster, either Compute Engine or Google Kubernetes Engine.

**Cluster mode options:**

| Mode | Masters | Use Case |
|---|---|---|
| **Single Node** | 1 (master = worker) | Development only |
| **Standard** | 1 master | Production (single point of failure) |
| **High Availability** | 3 masters | Production with resilience |

Additional configuration: machine type (CPUs, memory, disk) for master and worker nodes. Optional: **preemptible VMs** for worker nodes (lower cost).

![Creating a Dataproc cluster on Compute Engine](../images/c12f032.png)

**Figure 12.32** Creating a Dataproc cluster on Compute Engine

![Creating a Dataproc cluster on Google Kubernetes Engine](../images/c12f033.png)

**Figure 12.33** Creating a Dataproc cluster on Google Kubernetes Engine

### Submitting Jobs

Navigate to **Dataproc → Jobs → Submit A Job**.

![Submitting a job and choosing a job type](../images/c12f034.png)

**Figure 12.34** Submitting a job and choosing a job type

**Job types:**

| Job Type | Language/Format |
|---|---|
| **Spark** | Java JAR files |
| **PySpark** | Python program |
| **SparkR** | R program |
| **Hive** | Query files |
| **Spark SQL** | Query files |
| **Pig** | Pig script |
| **Hadoop** | Java JAR files |

### Workflow Templates

Navigate to **Dataproc → Workflow Templates**.

![Creating a workflow template](../images/c12f035.png)

**Figure 12.35** Creating a workflow template

Workflow templates define **directed graphs of jobs**. Options:
- **Managed cluster** — creates cluster, runs jobs, shuts down cluster automatically
- **Existing cluster** — runs jobs on a cluster you specify

### Serverless Spark

Navigate to **Dataproc → Serverless → Batches** to run Spark batch jobs without configuring or managing clusters.

![Serverless options allow you to run jobs without configuring clusters](../images/c12f036.png)

**Figure 12.36** Serverless options allow you to run jobs without configuring clusters.

### Dataproc Command Line

**Create a cluster:**

```bash
gcloud dataproc clusters create cluster-bc3d --zone us-west2-a
```

**Submit a Spark job:**

```bash
gcloud dataproc jobs submit spark --cluster cluster-bc3d \
    --jar ace_exam_jar.jar
```

---

> ### Real World Scenario: Spark for Machine Learning
>
> Retailers collect large volumes of purchase data in transaction processing systems, which are not designed for large-scale analysis. Using **Cloud Dataproc with Spark**:
>
> 1. Export transaction data from the OLTP system
> 2. Load into Spark
> 3. Apply ML algorithms from **Spark MLlib** (e.g., clustering, collaborative filtering)
> 4. Generate product recommendations tailored to individual customers
>
> This pattern drives adoption of Spark and analytics platforms — enabling use cases not possible with traditional transaction databases.

---

## Managing Cloud Storage

### Changing Storage Class

Use `gsutil rewrite` with the `-s` flag to manually change the storage class of an object:

```bash
gsutil rewrite -s [STORAGE_CLASS] gs://[PATH_TO_OBJECT]
```

Example — change to Coldline:

```bash
gsutil rewrite -s coldline gs://my-bucket/my-object.csv
```

> **Note:** `gcloud storage` is a newer alternative to `gsutil` with similar functionality and generally **faster** upload/download performance.

### Moving and Renaming Objects

**Move an object between buckets:**

```bash
gsutil mv gs://[SOURCE_BUCKET]/[SOURCE_OBJECT] \
           gs://[DESTINATION_BUCKET]/[DESTINATION_OBJECT]
```

**Rename an object (within the same bucket):**

```bash
gsutil mv gs://[BUCKET_NAME]/[OLD_OBJECT_NAME] \
           gs://[BUCKET_NAME]/[NEW_OBJECT_NAME]
```

### Cloud Storage Console Operations

From the Cloud Storage Browser console, you can perform:

- Edit access (IAM/ACL)
- Edit labels
- Delete a bucket
- Export to Cloud Pub/Sub
- Process with Cloud Functions
- Scan with Cloud Data Loss Prevention (DLP) service

![Operations you can perform on buckets in Cloud Storage](../images/c12f037.png)

**Figure 12.37** Operations you can perform on buckets in Cloud Storage

---

## Summary

### Command-Line Tool Reference

| Service | CLI Tool | Key Commands |
|---|---|---|
| Cloud SQL | `gcloud` | `gcloud sql connect`, `gcloud sql backups create`, `gcloud sql instances patch` |
| Firestore | `gcloud` | `gcloud firestore export`, `gcloud firestore import` |
| BigQuery | `bq` | `bq query --dry_run`, `bq show -j` |
| Cloud Spanner | `gcloud` | Console DDL for schema; managed service |
| Pub/Sub | `gcloud` | `gcloud pubsub topics create`, `gcloud pubsub subscriptions create` |
| Bigtable | `cbt` | `cbt createtable`, `cbt createfamily`, `cbt set`, `cbt read`, `cbt ls` |
| Dataproc | `gcloud` | `gcloud dataproc clusters create`, `gcloud dataproc jobs submit` |
| Cloud Storage | `gsutil` / `gcloud storage` | `gsutil mb`, `gsutil mv`, `gsutil rewrite` |

---

## Exam Essentials

- **Understand Cloud SQL and Cloud Spanner initialization.** Cloud SQL: create instance, connect with `gcloud sql connect`, use SQL commands. Cloud Spanner: create instance, create database, define schema with DDL. Both are managed — no OS maintenance needed.

- **Understand Cloud Firestore and Cloud Bigtable.** Firestore: document database; add data via console (Native mode) or GQL queries (Datastore mode); backup/restore via `gcloud firestore export/import`. Bigtable: wide-column; managed via `cbt` command; uses column families.

- **Know BigQuery cost estimation and job monitoring.** Estimate data scanned: BigQuery console UI or `bq --dry_run`. Estimate cost: GCP Pricing Calculator. View jobs: Personal History / Project History in console or `bq show -j`.

- **Know how to change Cloud Storage storage classes.** Life cycle policies automate class changes. Manual changes: `gsutil rewrite -s [CLASS]`. Move/rename: `gsutil mv`.

- **Understand Pub/Sub as a message queue.** Publishers write to topics. Consumers read via subscriptions (pull or push). Acknowledgment deadline: 10–600 seconds. Unread messages deleted after retention period.

- **Understand Cloud Dataproc is managed Spark and Hadoop.** Cluster modes: Single Node, Standard, High Availability. Job types: Spark, PySpark, SparkR, Hive, Spark SQL, Pig, Hadoop. Serverless Spark available for batch jobs without cluster management.

- **Know the four command-line tools.** `gcloud` (most services), `gsutil` / `gcloud storage` (Cloud Storage), `bq` (BigQuery), `cbt` (Bigtable).

---

## Review Questions

1. Cloud SQL is fully managed, but cloud engineers still need to perform some tasks. Which of the following tasks do Cloud SQL users need to perform?
   - A. Applying security patches
   - B. Performing regularly scheduled backups
   - **C. Creating databases**
   - D. Tuning the operating system to optimize Cloud SQL performance

2. Which of the following commands is used to create a backup of a Cloud SQL database?
   - **A. `gcloud sql backups create`**
   - B. `gsutil sql backups create`
   - C. `gcloud sql create backups`
   - D. `gcloud sql backups export`

3. Which of the following commands will run an automatic backup at 3:00 a.m. on an instance called `ace-exam-mysql`?
   - **A. `gcloud sql instances patch ace-exam-mysql --backup-start-time 03:00`**
   - B. `gcloud sql databases patch ace-exam-mysql --backup-start-time 03:00`
   - C. `cbt sql instances patch ace-exam-mysql --backup-start-time 03:00`
   - D. `bq gcloud sql instances patch ace-exam-mysql --backup-start-time 03:00`

4. What is the query language used by Firestore in Datastore mode?
   - A. SQL
   - B. MDX
   - **C. GQL**
   - D. DataFrames

5. What is the correct command-line structure to export data from Firestore?
   - A. `gcloud firestore export collection gs://[BUCKET_NAME]`
   - B. `gcloud firestore dump collection gs://[BUCKET_NAME]`
   - **C. `gcloud firestore export gs://[BUCKET_NAME]`**
   - D. `gcloud firestore dump gs://[BUCKET_NAME]`

6. When you enter a query into the BigQuery query form, BigQuery analyzes the query and displays an estimate of what metric?
   - A. Time required to enter the query
   - B. Cost of the query
   - **C. Amount of data scanned**
   - D. Number of bytes passed between servers in the BigQuery cluster

7. You want to get an estimate of the volume of data scanned by BigQuery from the command line. Which option shows the command structure you should use?
   - A. `gcloud BigQuery query estimate [SQL_QUERY]`
   - **B. `bq --location=[LOCATION] query --use_legacy_sql=false --dry_run [SQL_QUERY]`**
   - C. `gsutil --location=[LOCATION] query --use_legacy_sql=false --dry_run [SQL_QUERY]`
   - D. `cbt BigQuery query estimate [SQL_QUERY]`

8. You are using Cloud Console and want to check on some jobs running in BigQuery. Which menu item would you click to view jobs?
   - **A. Personal History or Project History.**
   - B. Active Jobs.
   - C. My Jobs.
   - D. You can't view job status in the console; you have to use `bq` on the command line.

9. You want to estimate the cost of running a BigQuery query. What two services within Google Cloud will you need to use?
   - A. BigQuery and Billing
   - B. Billing and Pricing Calculator
   - **C. BigQuery and Pricing Calculator**
   - D. Billing and bq command

10. You have just created a Cloud Spanner instance. What is the next step after creating the instance that you would perform to enable you to load data?
    - A. Run `gcloud spanner update-security-patches`.
    - **B. Create a database within the instance.**
    - C. Create tables to hold the data.
    - D. Use the Cloud Spanner console to import data into tables created with the instance.

11. You have created a Cloud Spanner instance and database. According to Google best practices, how often should you update VM packages using `apt-get`?
    - A. Every 24 hours.
    - B. Every 7 days.
    - C. Every 30 days.
    - **D. Never; Cloud Spanner is a managed service.**

12. Your software team wants to send messages from one application to another. Messages should be deleted after being read and remain available for at least three days before being discarded. Which Google Cloud service is best designed for this use case?
    - A. Bigtable
    - B. Dataproc
    - **C. Cloud Pub/Sub**
    - D. Cloud Spanner

13. Your manager asks you to set up a bare-bones Pub/Sub system as a sandbox for developers. What are the two resources within Pub/Sub you will need to create?
    - A. Topics and tables
    - B. Topics and databases
    - **C. Topics and subscriptions**
    - D. Tables and subscriptions

14. Your company is launching an IoT service and needs to store streaming data in Bigtable. What command would you run to ensure Bigtable command-line tools are installed?
    - A. `apt-get install bigtable-tools`
    - B. `apt-get install cbt`
    - **C. `gcloud components install cbt`**
    - D. `gcloud components install bigtable-tools`

15. You need to create a table called `iot-ingest-data` in Bigtable. What command would you use?
    - **A. `cbt createtable iot-ingest-data`**
    - B. `gcloud bigtable tables create ace-exam-bt-table`
    - C. `gcloud bigtable create tables ace-exam-bt-table`
    - D. `gcloud create ace-exam-bt-table`

16. Cloud Dataproc is a managed service for which two big data platforms?
    - A. Spark and Cassandra
    - **B. Spark and Hadoop**
    - C. Hadoop and Cassandra
    - D. Spark and TensorFlow

17. You decide to write a script to create a Dataproc cluster called `spark-nightly-analysis` every night at midnight in the `us-west2-a` zone. What command would you use?
    - A. `bq dataproc clusters create spark-nightly-analysis --zone us-west2-a`
    - **B. `gcloud dataproc clusters create spark-nightly-analysis --zone us-west2-a`**
    - C. `gcloud dataproc clusters spark-nightly-analysis --zone us-west2-a`
    - D. None of the above

18. You have buckets containing old data and want to change their storage class to Coldline. What is the command structure you would use?
    - A. `gcloud rewrite -s [STORAGE_CLASS] gs://[PATH_TO_OBJECT]`
    - **B. `gsutil rewrite -s [STORAGE_CLASS] gs://[PATH_TO_OBJECT]`**
    - C. `cbt rewrite -s [STORAGE_CLASS] gs://[PATH_TO_OBJECT]`
    - D. `bq rewrite -s [STORAGE_CLASS] gs://[PATH_TO_OBJECT]`

19. You want to rename an object stored in a bucket. What command structure would you use?
    - A. `gsutil cp gs://[BUCKET_NAME]/[OLD_OBJECT_NAME] gs://[BUCKET_NAME]/[NEW_OBJECT_NAME]`
    - **B. `gsutil mv gs://[BUCKET_NAME]/[OLD_OBJECT_NAME] gs://[BUCKET_NAME]/[NEW_OBJECT_NAME]`**
    - C. `gsutil mv gs://[OLD_OBJECT_NAME] gs://[NEW_OBJECT_NAME]`
    - D. `gcloud mv gs://[OLD_OBJECT_NAME] gs://[NEW_OBJECT_NAME]`

20. An executive asks about creating a recommendation system to help sell more products. What Google Cloud service would you recommend?
    - **A. Cloud Dataproc, especially Spark and its machine learning library**
    - B. Cloud Dataproc, especially Hadoop
    - C. Cloud Spanner, which is a global relational database that can hold a lot of data
    - D. Cloud SQL, because SQL is a powerful query language
