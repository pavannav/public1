# Chapter 13: Loading Data into Storage

## Exam Objective Covered

- **3.4 Deploying and implementing data solutions**

---

## Introduction

This chapter covers loading, moving, importing, and exporting data across Google Cloud storage and processing services:

- **Cloud Storage** — create buckets, upload files, move objects
- **Cloud SQL** — import/export via console and CLI
- **Cloud Firestore** — export/import (Native and Datastore modes)
- **BigQuery** — export/import with multiple formats; cost estimation
- **Cloud Spanner** — export/import via console (uses Dataflow)
- **Cloud Bigtable** — export via console
- **Cloud Dataproc** — export/import cluster configuration
- **Cloud Pub/Sub** — create topics, publish and pull messages

> **Note:** Google Cloud recently introduced the `gcloud storage` command as an alternative to `gsutil`. It has similar functionality but is generally **faster** for uploads and downloads.

---

## Loading and Moving Data to Cloud Storage

Cloud Storage is used for long-term storage, archiving, file transfers, and data sharing.

### Loading and Moving Data to Cloud Storage Using the Console

Navigate to **Cloud Storage** in Cloud Console.

![The first step in loading data into Cloud Storage is to create a bucket](../images/c13f001.png)

**Figure 13.1** The first step in loading data into Cloud Storage is to create a bucket.

**Step 1: Create a bucket**

Specify a **globally unique** bucket name and a location:

![Defining a regional bucket in us-west1](../images/c13f002.png)

**Figure 13.2** Defining a regional bucket in us-west1

| Location Type | Availability | Cost | Use Case |
|---|---|---|---|
| **Multi-Region** | Highest | Highest | Global access (US, EU, Asia Pacific) |
| **Dual-Region** | High | Medium | Low latency across two regions |
| **Region** | Standard | Lowest | Lowest latency within one region |

> **Note:** Buckets are regional resources and are replicated across zones within their region.

**Step 2: Choose a storage class and access control**

![Choosing a storage class and access control method](../images/c13f003.png)

**Figure 13.3** Choosing a storage class and access control method

**Storage class options:** Standard, Nearline (<once/30 days), Coldline (<once/90 days), Archive (<once/year).

**Access control options:**

| Option | Description |
|---|---|
| **Enforce Public Access Prevention** | Prevents anyone with just a URL from accessing bucket contents |
| **Uniform access** (default, recommended) | Access controlled by bucket-level IAM permissions |
| **Fine-grained access** | Legacy ACL-based; allows per-object access controls |

> **Best practice:** Use **uniform access control** (IAM-based) instead of fine-grained (ACL-based). This is a Google-recommended practice that may be tested on the exam.

**Step 3: View bucket details and upload files**

![The Bucket Details page shows information on Objects, Configuration, Permissions, Protection, and Lifecycle](../images/c13f004.png)

**Figure 13.4** The Bucket Details page shows information on Objects, Configuration, Permissions, Protection, and Lifecycle.

Click **Upload Files** to upload from your local filesystem, or **Upload Folder** to upload an entire folder.

![Upload Files prompts you for a folder using the client device's filesystem tools](../images/c13f005.png)

**Figure 13.5** Upload Files prompts you for a folder using the client device's filesystem tools.

**Moving objects between buckets:**

Click the ellipsis (⋮) at the end of an object's line → **Move**.

![Objects can be moved by using the move command in the Operations menu](../images/c13f006.png)

**Figure 13.6** Objects can be moved by using the move command in the Operations menu.

![When moving an object in the console, you will be prompted for a destination bucket and folder](../images/c13f007.png)

**Figure 13.7** When moving an object in the console, you will be prompted for a destination bucket and folder.

---

### Loading and Moving Data to Cloud Storage Using the Command Line

**Create a bucket:**

```bash
gsutil mb gs://[BUCKET_NAME]/
gsutil mb gs://ace-exam-bucket1/
```

**Upload a file from local device or VM to Cloud Storage:**

```bash
gsutil cp [LOCAL_OBJECT_LOCATION] gs://[DESTINATION_BUCKET_NAME]/

# Example: upload README.txt to bucket
gsutil cp /home/mydir/README.txt gs://ace-exam-bucket1/
```

**Download a file from Cloud Storage to a VM:**

```bash
gsutil cp gs://ace-exam-bucket1/README.txt /home/mydir/
```

**Move an object between buckets:**

```bash
gsutil mv gs://[SOURCE_BUCKET]/[SOURCE_OBJECT] \
           gs://[DESTINATION_BUCKET]/[DESTINATION_OBJECT]

# Example: move README.txt from bucket1 to bucket2
gsutil mv gs://ace-exam-bucket1/README.txt gs://ace-exam-bucket2/
```

---

## Importing and Exporting Data

### Importing and Exporting Data: Cloud SQL

#### Export (Console)

Navigate to **Cloud SQL → [Instance Name] → Export tab**.

![Listing of database instances on the Cloud SQL page of the console](../images/c13f008.png)

**Figure 13.8** Listing of database instances on the Cloud SQL page of the console

![The Instance Details page has Import and Export tabs](../images/c13f009.png)

**Figure 13.9** The Instance Details page has Import and Export tabs.

Specify a destination **Cloud Storage bucket** and **file format**:

![Exporting a database requires you to specify a bucket for storing the export file and a file format](../images/c13f010.png)

**Figure 13.10** Exporting a database requires you to specify a bucket for storing the export file and a file format.

| Export Format | Best For |
|---|---|
| **SQL** | Importing into another relational database (includes schema) |
| **CSV** | Importing into non-relational databases or other tools |

#### Import (Console)

Choose the **Import** option from Instance Details. Specify source file, file format, and target database within the instance.

![Importing a database requires you to specify a path to the bucket and object storing the export file, a file format, and a target database](../images/c13f011.png)

**Figure 13.11** Importing a database requires you to specify a path to the bucket and object storing the export file, a file format, and a target database within the instance.

#### Export/Import (Command Line)

**Get service account name (needed for bucket write permission):**

```bash
gcloud sql instances describe ace-exam-mysql1
```

![Details about a database instance generated by the gcloud sql instances describe command](../images/c13f012.png)

**Figure 13.12** Details about a database instance generated by the `gcloud sql instances describe` command

**Export to SQL format:**

```bash
gcloud sql export sql [INSTANCE_NAME] \
    gs://[BUCKET_NAME]/[FILE_NAME] \
    --database=[DATABASE_NAME]

# Example:
gcloud sql export sql ace-exam-mysql1 \
    gs://ace-exam-buckete1/ace-exam-mysqlexport.sql \
    --database=mysql
```

**Export to CSV format:**

```bash
gcloud sql export csv ace-exam-mysql1 \
    gs://ace-exam-buckete1/ace-exam-mysql-export.csv \
    --database=mysql
```

**Import from SQL format:**

```bash
gcloud sql import sql [INSTANCE_NAME] \
    gs://[BUCKET_NAME]/[IMPORT_FILE_NAME] \
    --database=[DATABASE_NAME]

# Example:
gcloud sql import sql ace-exam-mysql1 \
    gs://ace-exam-buckete1/ace-exam-mysql-export.sql \
    --database=mysql
```

---

### Importing and Exporting Data: Cloud Firestore

#### Native Mode Export/Import

```bash
# Export
gcloud firestore export gs://${BUCKET}

# Import
gcloud firestore import gs://${BUCKET}/[PATH]/[FILE].overall_export_metadata
```

#### Datastore Mode Export/Import

Datastore mode uses **namespaces** to group entities for export. The default namespace is `(default)`.

**Export:**

```bash
gcloud datastore export --namespaces="(default)" gs://${BUCKET}

# Example:
gcloud datastore export --namespaces="(default)" gs://ace-exam-datastore1
```

The export creates a timestamped folder containing:
- A metadata file (`.overall_export_metadata`)
- A data subfolder named after the namespace

**Import:**

```bash
gcloud datastore import gs://[BUCKET]/[TIMESTAMP_FOLDER]/[TIMESTAMP].overall_export_metadata

# Example:
gcloud datastore import gs://ace-exam-datastore1/2018-12-20T19:13:55_64324/2018-12-20T19:13:55_64324.overall_export_metadata
```

---

### Importing and Exporting Data: BigQuery

> **Note:** The command-line tool for BigQuery is `bq`, not `gcloud`.

#### Export (Console)

Navigate to **BigQuery → [Dataset] → [Table] → Export**.

![Detailed list of a BigQuery table](../images/c13f013.png)

**Figure 13.13** Detailed list of a BigQuery table

**Export destination options:**

![Choosing a target location for a BigQuery export](../images/c13f014.png)

**Figure 13.14** Choosing a target location for a BigQuery export

| Export Destination | Description |
|---|---|
| **Google Sheets** | Spreadsheet format |
| **Google Cloud Storage** | File export (CSV, Avro, JSON) |
| **Looker Studio** | Analytics and visualization tool (formerly Data Studio) |
| **Data Loss Prevention** | Scan for sensitive data |

**Export to Cloud Storage — file format and compression options:**

![Specifying the output parameters for a BigQuery export operation](../images/c13f015.png)

**Figure 13.15** Specifying the output parameters for a BigQuery export operation

| Format | Compression Options | Notes |
|---|---|---|
| **CSV** | None, Gzip | Human-readable; not optimal for large data |
| **JSON** | None, Gzip | Human-readable; includes schema per record |
| **Avro** | Deflate, Snappy | Binary; compact; includes schema; best for large data |

> **Avro compression trade-offs:** Deflate produces smaller files; Snappy is faster.

#### Export File Format Notes

| Format | Characteristics |
|---|---|
| **CSV** | Human-readable; small datasets; no built-in schema |
| **JSON** | Human-readable; schema included per record |
| **Gzip** | Widely used lossless compression |
| **Avro** | Compact binary; schema embedded in JSON; supports complex structures; compatible with Spark/Dataproc |

#### Export (Command Line)

```bash
bq extract \
    --destination_format [FORMAT] \
    --compression [COMPRESSION_TYPE] \
    --field_delimiter [DELIMITER] \
    --print_header [BOOLEAN] \
    [PROJECT_ID]:[DATASET].[TABLE] \
    gs://[BUCKET]/[FILENAME]

# Example:
bq extract --destination_format CSV --compression GZIP \
    'mydataset.mytable' gs://example-bucket/myfile.zip
```

#### Import (Console)

Navigate to **BigQuery → [Dataset] → Create Table**.

![When viewing a data set, you have the option to create a table](../images/c13f016.png)

**Figure 13.16** When viewing a data set, you have the option to create a table.

![Creating a table in BigQuery](../images/c13f017.png)

**Figure 13.17** Creating a table in BigQuery

**Source data locations:**

![Data can be imported from multiple kinds of locations](../images/c13f018.png)

**Figure 13.18** Data can be imported from multiple kinds of locations.

**Import file format options:**

![File format options for importing](../images/c13f019.png)

**Figure 13.19** File format options for importing

| Import Format | Notes |
|---|---|
| **CSV** | Comma-separated values |
| **JSONL** | Newline-delimited JSON |
| **Avro** | Binary columnar format |
| **Parquet** | Columnar storage format |
| **ORC** | Optimized Row Columnar |
| **Cloud Datastore Backup** | Firestore/Datastore export files |

**Table type options:**

| Type | Description |
|---|---|
| **Native** | Data loaded into BigQuery storage |
| **External** | Data kept in source location; only metadata stored in BigQuery (used for very large datasets) |

#### Import (Command Line)

```bash
bq load --autodetect --source_format=[FORMAT] \
    [DATASET].[TABLE] [PATH_TO_SOURCE]

# Example:
bq load --autodetect --source_format=CSV \
    mydataset.mytable gs://ace-exam-bigquery/mydata.csv
```

- `--autodetect` — automatically detects the table schema from the source file

---

### Importing and Exporting Data: Cloud Spanner

Cloud Spanner import/export uses the console and runs via **Cloud Dataflow** (not a direct `gcloud` command).

> **Important:** Cloud Spanner export incurs **Cloud Dataflow charges** and potentially **data egress charges** if data moves between regions.

Navigate to **Cloud Spanner → [Instance] → Export**.

![Listing of Spanner instances](../images/c13f020.png)

**Figure 13.20** Listing of Spanner instances

![Import/Export page](../images/c13f021.png)

**Figure 13.21** Import/Export page

**Export options:** destination bucket, database to export, region to run the job.

![Export options for Cloud Spanner](../images/c13f022.png)

**Figure 13.22** Export options for Cloud Spanner

**Import options:** source bucket, destination database, region to run the job.

![Import options for Cloud Spanner](../images/c13f023.png)

**Figure 13.23** Import options for Cloud Spanner

---

### Exporting Data from Cloud Bigtable

Navigate to **Bigtable → Tables → Export**.

![Export page for Cloud Bigtable](../images/c13f024.png)

**Figure 13.24** Export page for Cloud Bigtable

**Bigtable export formats** (stored in Cloud Storage):

| Format | Notes |
|---|---|
| **SequenceFile** | Hadoop binary format |
| **Avro** | Compact binary; widely supported |
| **Parquet** | Columnar storage format |

---

### Importing and Exporting Data: Cloud Dataproc

Cloud Dataproc is a **data analysis platform**, not a persistent data store. Import/export commands save and restore **cluster configuration data** (not data files).

> Use **Cloud Storage** or **persistent disks** to store data files you want to analyze in Dataproc.

**Export cluster configuration:**

```bash
gcloud dataproc clusters export [CLUSTER_NAME] \
    --destination=[PATH_TO_EXPORT_FILE]

# Example:
gcloud dataproc clusters export ace-exam-dataproc-cluster \
    --destination=gs://ace-exam-bucket1/mydataproc.yaml
```

**Import cluster configuration:**

```bash
gcloud dataproc clusters import [SOURCE_FILE]

# Example:
gcloud dataproc clusters import gs://ace-exam-bucket1/mydataproc.yaml
```

---

## Streaming Data to Cloud Pub/Sub

Cloud Pub/Sub is a **message queue** for decoupling services. Cloud engineers create and test topics and subscriptions.

### Creating Topics and Subscriptions

**Create a topic:**

```bash
gcloud pubsub topics create [TOPIC_NAME]
gcloud pubsub topics create ace-exam-topic1
```

**Create a subscription:**

```bash
gcloud pubsub subscriptions create --topic [TOPIC_NAME] [SUBSCRIPTION_NAME]
gcloud pubsub subscriptions create --topic=ace-exam-topic1 ace-exam-sub1
```

### Publishing and Pulling Messages

**Publish a message to a topic:**

```bash
gcloud pubsub topics publish [TOPIC_NAME] --message [MESSAGE]
gcloud pubsub topics publish ace-exam-topic1 --message "first ace exam message"
```

**Pull (read) a message from a subscription:**

```bash
gcloud pubsub subscriptions pull --auto-ack [SUBSCRIPTION_NAME]
gcloud pubsub subscriptions pull --auto-ack ace-exam-sub1
```

- `--auto-ack` — reads the message and **acknowledges** receipt in a single command (preventing re-delivery)

### Full Pub/Sub Test Workflow

```bash
# 1. Create topic
gcloud pubsub topics create ace-exam-topic1

# 2. Create subscription
gcloud pubsub subscriptions create --topic=ace-exam-topic1 ace-exam-sub1

# 3. Publish a test message
gcloud pubsub topics publish ace-exam-topic1 --message "first ace exam message"

# 4. Pull and acknowledge the message
gcloud pubsub subscriptions pull --auto-ack ace-exam-sub1
```

---

> ### Real World Scenario: Decoupling Services Using Message Queues
>
> In distributed systems, synchronous communication between services creates fragility under load. Example:
>
> - A retail site has a spike in traffic → high load on an **inventory tracking service**
> - The user interface is **waiting synchronously** for the inventory service → UI slows down too
>
> **Better approach using Pub/Sub:**
> - UI writes a message to a **Pub/Sub topic** each time an item is added/removed from a cart
> - The inventory service **subscribes** and processes messages as capacity allows
> - If the inventory service slows down, messages **accumulate in the queue** — the UI is unaffected
> - Pub/Sub **scales with the load** generated by the UI
>
> This pattern is called **decoupling** — it improves resilience to load spikes and prevents one slow service from cascading delays to others.

---

## Summary

### Import/Export Command Reference

| Service | Tool | Export Command | Import Command |
|---|---|---|---|
| **Cloud Storage** | `gsutil` | `gsutil cp` (download) | `gsutil cp` (upload), `gsutil mb` |
| **Cloud SQL** | `gcloud` | `gcloud sql export sql/csv` | `gcloud sql import sql` |
| **Firestore (Native)** | `gcloud` | `gcloud firestore export` | `gcloud firestore import` |
| **Firestore (Datastore)** | `gcloud` | `gcloud datastore export` | `gcloud datastore import` |
| **BigQuery** | `bq` | `bq extract` | `bq load` |
| **Cloud Spanner** | Console (Dataflow) | Console Export | Console Import |
| **Bigtable** | Console | Console Export | N/A (use Java tool) |
| **Dataproc** | `gcloud` | `gcloud dataproc clusters export` | `gcloud dataproc clusters import` |
| **Pub/Sub** | `gcloud` | `gcloud pubsub topics publish` | `gcloud pubsub subscriptions pull` |

---

## Exam Essentials

- **Know how to load and move data in Cloud Storage.** `gsutil mb` creates buckets. `gsutil cp` copies files to/from Cloud Storage and VMs. `gsutil mv` moves objects between buckets. Use uniform access control (IAM) over fine-grained (ACL) — Google best practice.

- **Understand Cloud SQL import/export.** Console: Export/Import tabs on Instance Details. CLI: `gcloud sql export sql/csv` and `gcloud sql import sql`. Service account needs write permission on the destination bucket.

- **Know Cloud Firestore export/import.** Native mode: `gcloud firestore export/import`. Datastore mode: `gcloud datastore export --namespaces` / `gcloud datastore import`. Exports go to Cloud Storage.

- **Understand BigQuery export and import.** Export formats: CSV, JSON, Avro. Import formats: CSV, JSONL, Avro, Parquet, ORC, Cloud Datastore Backup. CLI tool is `bq` (not `gcloud`). Use `bq extract` to export, `bq load` to import. `--autodetect` automatically detects schema.

- **Know that Pub/Sub is used to send messages between services.** Pub/Sub decouples services and improves resilience to load fluctuations. `gcloud pubsub topics publish` sends messages. `gcloud pubsub subscriptions pull --auto-ack` reads and acknowledges.

---

## Review Questions

1. Which of the following commands is used to create buckets in Cloud Storage?
   - A. `gcloud storage create buckets`
   - B. `gsutil storage buckets create`
   - **C. `gsutil mb`**
   - D. `gcloud mb`

2. You need to copy files from your local device to a bucket in Cloud Storage. What command would you use?
   - A. `gsutil copy`
   - **B. `gsutil cp`**
   - C. `gcloud cp`
   - D. `gcloud storage objects copy`

3. You are migrating files to Cloud Storage and want to use Cloud Console. Which Cloud Storage operations can you perform in the console?
   - A. Upload files only
   - B. Upload folders only
   - **C. Upload files and folders**
   - D. Compare local files with files in the bucket using the `diff` command

4. A developer asks for help exporting data from Cloud SQL. What are the options for the export file format?
   - A. CSV and XML
   - B. CSV and JSON
   - C. JSON and SQL
   - **D. CSV and SQL**

5. A database administrator will load exported MySQL data into another relational database without defining a schema manually. What file format would you recommend?
   - **A. SQL**
   - B. CSV
   - C. XML
   - D. JSON

6. Which command will export a MySQL database called `ace-exam-mysql1` to a file called `ace-exam-mysql-export.sql` in a bucket named `ace-exam-buckete1`?
   - A. `gcloud storage export sql ace-exam-mysql1 gs://ace-exam-buckete1/ace-exam-mysql-export.sql --database=mysql`
   - B. `gcloud sql export ace-exam-mysql1 gs://ace-exam-buckete1/ace-exam-mysql-export.sql --database=mysql`
   - **C. `gcloud sql export sql ace-exam-mysql1 gs://ace-exam-buckete1/ace-exam-mysql-export.sql --database=mysql`**
   - D. `gcloud sql export sql ace-exam-mysql1 gs://ace-exam-mysql-export.sql/ace-exam-buckete1/ --database=mysql`

7. Which of the following file formats is not an option for an export file when exporting from BigQuery?
   - A. CSV
   - **B. XML**
   - C. Avro
   - D. JSON

8. Which of the following file formats is not supported when importing data into BigQuery?
   - A. CSV
   - B. Parquet
   - C. Avro
   - **D. YAML**

9. You have received a large IoT data set and want to use BigQuery to analyze it. What command-line command would you use to load the data?
   - **A. `bq load --autodetect --source_format=[FORMAT] [DATASET].[TABLE] [PATH_TO_SOURCE]`**
   - B. `bq import --autodetect --source_format=[FORMAT] [DATASET].[TABLE] [PATH_TO_SOURCE]`
   - C. `gcloud BigQuery load --autodetect --source_format=[FORMAT] [DATASET].[TABLE] [PATH_TO_SOURCE]`
   - D. `gcloud BigQuery load --autodetect --source_format=[FORMAT] [DATASET].[TABLE] [PATH_TO_SOURCE]`

10. You notice Cloud Spanner exports incur charges from another Google Cloud service. What other service is likely incurring charges?
    - A. Dataproc
    - **B. Dataflow**
    - C. Firestore
    - D. `bq`

11. As a developer on a Bigtable IoT project, you need to export data for analysis with another tool and want to minimize effort. What would you use?
    - A. A Java program designed for importing and exporting data from Bigtable
    - B. `gcloud bigtable table export`
    - C. `bq bigtable table export`
    - **D. An import tool provided by the analysis tool**

    > **Note:** The book answer is A (Java program). Bigtable export via the console is the easiest approach; if a third-party tool has its own import from Bigtable, that is also valid. The book intends **A** as the "minimize effort" path using Bigtable's native Java-based export utilities.

12. You have just exported from a Dataproc cluster. What have you exported?
    - A. Data in Spark DataFrames
    - B. All tables in the Spark database
    - **C. Configuration data about the cluster**
    - D. All tables in the Hadoop database

13. A team of data scientists needs to train ML models using data stored in Bigtable. Which Google Cloud service are they most likely to use?
    - A. Firestore
    - B. Dataflow
    - **C. Dataproc**
    - D. DataAnalyze

14. Which of the following is the correct command to create a Pub/Sub topic?
    - **A. `gcloud pubsub topics create`**
    - B. `gcloud pubsub create topics`
    - C. `bq pubsub create topics`
    - D. `cbt pubsub topics create`

15. Which of the following commands will create a subscription on the topic `ace-exam-topic1`?
    - A. `gcloud pubsub create --topic=ace-exam-topic1 ace-exam-sub1`
    - B. `gcloud pubsub subscriptions create --topic=ace-exam-topic1`
    - **C. `gcloud pubsub subscriptions create --topic=ace-exam-topic1 ace-exam-sub1`**
    - D. `gsutil pubsub subscriptions create --topic=ace-exam-topic1 ace-exam-sub1`

16. What is one of the direct advantages of using a message queue in distributed systems?
    - A. It increases security.
    - **B. It decouples services, so if one lags, it does not cause other services to lag.**
    - C. It supports more programming languages.
    - D. It stores messages until they are read by default.

17. To ensure you have installed beta `gcloud` commands, which command should you run?
    - A. `gcloud components beta install`
    - **B. `gcloud components install beta`**
    - C. `gcloud commands install beta`
    - D. `gcloud commands beta install`

18. What parameter is used to tell BigQuery to automatically detect the schema of a file on import?
    - **A. `autodetect`**
    - B. `autoschema`
    - C. `detectschema`
    - D. `dry_run`

19. The compression options Deflate and Snappy are available for what file types when exporting from BigQuery?
    - **A. Avro**
    - B. CSV
    - C. XML
    - D. Thrift

20. You want to read a message from a Pub/Sub topic and acknowledge reading that message in the same command. Which of the following would you use?
    - **A. `gcloud pubsub subscriptions pull --auto-ack`**
    - B. `gcloud pubsub topic pull --auto-ack`
    - C. `gsutil pubsub topic pull --with-acknowledgement`
    - D. `gcloud pubsub subscription pull --with-acknowledgement`
