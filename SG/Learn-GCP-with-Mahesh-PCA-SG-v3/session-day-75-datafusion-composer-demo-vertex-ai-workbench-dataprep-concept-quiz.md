# Session 75: Data Fusion and Composer Demo, Vertex AI Workbench, Data Prep Concept

## Table of Contents
- [Data Fusion Instance Setup](#data-fusion-instance-setup)
- [Google Cloud Storage Data Upload](#google-cloud-storage-data-upload)
- [Data Fusion Interface and Wrangler Tool](#data-fusion-interface-and-wrangler-tool)
- [Data Wrangling Demonstration](#data-wrangling-demonstration)
- [Pipeline Creation with Data Fusion](#pipeline-creation-with-data-fusion)
- [BigQuery Sink Configuration](#bigquery-sink-configuration)
- [Cloud Composer Overview](#cloud-composer-overview)
- [Vertex AI Workbench Overview](#vertex-ai-workbench-overview)
- [Data Prep Concept](#data-prep-concept)
- [Data Catalog and Data Plex](#data-catalog-and-data-plex)
- [Looker Studio Visualization](#looker-studio-visualization)
- [Big Data Products Recap](#big-data-products-recap)

## Data Fusion Instance Setup
### Overview
Data Fusion is Google's fully managed, serverless data integration service that allows users to build scalable data pipelines without writing code. It supports ETL and ELT processes through a visual interface, enabling data engineers and architects to design pipelines via drag-and-drop functionality.

### Key Concepts / Deep Dive
Data Fusion provides an enterprise edition of its user interface, which operates as a browser-based thin client, unlike thick clients such as desktop applications. The service is accessed through the Google Cloud console after enabling the API and creating an instance.

Creation of a Data Fusion instance involves provisioning a managed service that handles the infrastructure. In the demonstration, the instance took approximately 18 minutes to create, starting at 5:48 PM in the US West region.

**Code/Config Blocks**:
```bash
# Command to provision Data Fusion via Cloud Shell (beta)
gcloud beta datafusion instances create [INSTANCE_NAME] --region=us-west2
```

**Lab Demos**:
1. Navigate to the Data Analytics section in the Google Cloud console.
2. Select Data Fusion and create a new instance in the US West region (us-west2).
3. Wait for the instance to provision; monitor logs for any issues.
4. Access the instance via the provided URL after creation.

> [!NOTE]
> Data Fusion instances are region-specific and must align with data locations for compliance and performance.

## Google Cloud Storage Data Upload
### Overview
Google Cloud Storage (GCS) serves as a primary source for raw data in Data Fusion pipelines. Data can be uploaded from local systems and used directly in pipelines due to integrated authentication via service accounts.

### Key Concepts / Deep Dive
In the demo, a bucket named with a prefix like "df-" (Data Fusion) was created in the US West region. Raw data, a TSV file containing French transactional data for t-shirt sales, was uploaded to this bucket. The file included schemas with fields like user ID, department, date of birth, etc.

**Lab Demos**:
1. Create a GCS bucket in the desired region using the Cloud console or CLI.
2. Upload the raw data file (e.g., .tsv) via gsutil or the console.
3. Ensure bucket permissions allow access for Data Fusion service accounts.

**Code/Config Blocks**:
```bash
# Create bucket via gsutil
gsutil mb -p [PROJECT_ID] -c standard -l us-west2 gs://df-demo-bucket

# Upload file
gsutil cp /local/path/to/file.tsv gs://df-demo-bucket/data/
```

## Data Fusion Interface and Wrangler Tool
### Overview
The Data Fusion UI is a visual tool for data discovery, exploration, transformation, and enrichment. It includes plugins for various sources and sinks, supporting enterprise integrations.

### Key Concepts / Deep Dive
The interface allows connection to hubs for custom plugins, such as AWS S3, Kinesis, Azure Event Hubs, Kafka, Oracle, and IBM DB2. For initial exploration, use the Wrangler tool, which samples data (first 100 rows) and provides statistics like completeness.

**Lab Demos**:
1. Open the Data Fusion instance URL.
2. Select "Wrangler" for data exploration.
3. Connect to GCS as the source; the UI auto-detects buckets via service account permissions.
4. Select the uploaded file and specify parsing parameters.

## Data Wrangling Demonstration
### Overview
Data Wrangling in Data Fusion enables no-code data cleansing, including filtering, type conversion, column removal, and null filling using a visual workflow.

### Key Concepts / Deep Dive
In the demo, a TSV file was parsed as CSV with tab separators and headers. Transformations included:
- Parsing with options for delimiters and headers.
- Filtering rows with null values in key columns like user ID.
- Renaming columns (e.g., department to proper nomenclature).
- Filling null values with defaults (e.g., unknown department as "100").
- Dropping unnecessary columns.

Completeness statistics guided cleansing: low completeness indicated data issues.

**Tables**:

| Transformation | Description | Result |
|----------------|-------------|--------|
| Parse CSV      | Split tab-separated data into columns | 9 columns added |
| Filter Rows    | Remove rows with null user IDs | Improved data completeness |
| Rename Column  | Standardize column names | Better readability |
| Fill Nulls     | Assign defaults to incomplete fields | 100% completeness |

**Lab Demos**:
1. In Wrangler, apply parse transformation with tab delimiter and header option.
2. Use filter transformation to exclude null rows (e.g., WHERE user_id != null).
3. Rename columns using direct editing.
4. Apply fill transformation for empty cells with default values.
5. Drop unused columns by selecting and deleting them.

**Code/Config Blocks** (Generated Wrangler JSON):
```json
{
  "transformations": [
    {"type": "parse_csv", "delimiter": "\t", "has_header": true},
    {"type": "filter", "condition": "user_id IS NOT NULL"},
    {"type": "rename", "from": "departement", "to": "department"},
    {"type": "fill_null", "columns": ["department"], "value": "100"}
  ]
}
```

## Pipeline Creation with Data Fusion
### Overview
Pipelines in Data Fusion orchestrate source, transformation, and sink operations for batch or real-time processing, running on Data Proc clusters.

### Key Concepts / Deep Dive
Pipelines support batch and real-time modes. Wrangled data is converted into a pipeline with sources (GCS), transformations (wrangler plugins), and sinks (BigQuery, GCS).

Preview mode validates and dry-runs the pipeline. Deployed pipelines are editable until scheduled. Execution provisions ephemeral Data Proc clusters that delete post-run.

**Lab Demos**:
1. From Wrangler, select "Create Pipeline."
2. Add GCS source and BigQuery sink.
3. Configure transformations and validate.
4. Deploy the pipeline.
5. Run the pipeline with worker configurations for cost control.

> [!WARNING]
> Avoid exceeding quotas by customizing master/worker disk sizes (e.g., reduce from default 500GB to 200GB).

## BigQuery Sink Configuration
### Overview
BigQuery serves as a sink for transformed data, supporting schemas, partitioning, and clustering for optimized analytics.

### Key Concepts / Deep Dive
In the demo, a BigQuery dataset was created in the same region. The sink configured partitioning by injection time and clustering by department. Date of birth was excluded for cost and privacy reasons.

Table schema included 8 columns. Transformations reduced data volume for efficiency.

**Lab Demos**:
1. Create a BigQuery dataset in the matching region.
2. In Data Fusion, add BigQuery sink and select the dataset/table.
3. Configure partitioning and clustering options.
4. Adjust schemas to exclude sensitive fields.

**Code/Config Blocks**:
```sql
# Example sink query (auto-generated by Data Fusion)
CREATE TABLE `project.dataset.tshirts_sales` as
SELECT * FROM `transformed_data` ORDER BY department;
```

**Tables**:
| Configuration | Value | Rationale |
|----------------|-------|-----------|
| Partitioning   | Injection Time | Cost-effective partitioning |
| Clustering     | Department | Optimize queries by frequent filters |
| Schema         | Exclude Date of Birth | Reduce storage; privacy compliance |

## Cloud Composer Overview
### Overview
Cloud Composer is a fully managed workflow orchestration service for Apache Airflow, enabling scheduling of data pipelines and fault recovery.

### Key Concepts / Deep Dive
Composer provisions Kubernetes-based environments for Airflow DAGs (Directed Acyclic Graphs). It supports data pipeline orchestration with retries and dependencies.

In the demo, a composer environment took 15-20 minutes to create, using Airflow 2.x.

**Lab Demos**:
1. Enable Composer API and create an environment (version 3 preferred).
2. Configure Python packages, accounts, and security.
3. Access Airflow UI after provisioning.

**Code/Config Blocks**:
```python
# Example DAG structure
from airflow import DAG
from airflow.operators.bash_operator import BashOperator

dag = DAG('ping_dag', start_date=datetime.now())

task1 = BashOperator(
    task_id='echo_task',
    bash_command='echo "Test"',
    dag=dag
)

task2 = BashOperator(
    task_id='ping_task',
    bash_command='ping -c 3 google.com',
    dag=dag
)

task1 >> task2
```

> [!NOTE]
> Composer complements Data Flow/Data Proc by adding scheduling and monitoring layers.

## Vertex AI Workbench Overview
### Overview
Vertex AI Workbench provides Jupyter Notebook environments for interactive data analysis and ML experimentation, with pre-configured frameworks like TensorFlow and PyTorch.

### Key Concepts / Deep Dive
Jupyter Notebooks enable cell-by-cell Python execution. Workbench instances auto-shutdown after idle periods. Persistent storage includes boot and data disks.

Demonstration showed querying BigQuery from notebooks using pip-query.

**Lab Demos**:
1. Create a Workbench instance with required environment (e.g., Python 3).
2. Configure idle timeouts (e.g., 10 minutes).
3. Launch Jupyter Notebook and execute code cells.

**Code/Config Blocks**:
```python
# Example BigQuery query in Jupyter
from bigquery import Client
client = Client()
query = "SELECT * FROM `dataset.table` LIMIT 10"
results = client.query(query).to_dataframe()
print(results.head())
```

## Data Prep Concept
### Overview
Data Prep is a UI-based tool for data cleansing, anomalization detection, and preparation prior to analytics or ML, now rebranded as Alteryx Designer Cloud.

### Key Concepts / Deep Dive
Originally Trifacta's Data Prep, acquired by Alteryx. It identifies anomalies, missing values, and mismatched data types via visual means. Supports quick data profiling and transformations.

Data is processed in Alteryx's cloud, potentially relocating data centers, raising compliance concerns.

**Lab Demos** (Conceptual):
1. Connect data sources (GCS, BigQuery, Excel).
2. Profile data for completeness, outliers, duplicates.
3. Apply transformations and recipes.
4. Adjust consents for sharing data with third-party provider.

> [!WARNING]
> Data may be stored in third-party regions; verify compliance before use.

## Data Catalog and Data Plex
### Overview
Data Catalog enables metadata-driven data discovery, while Data Plex provides governance for multi-cloud data lakes.

### Key Concepts / Deep Dive
Data Catalog indexes BigQuery, GCS, etc., facilitating searches. Data Plex adds life-cycle management and access controls.

Example: Searching "COVID" returns public dataset previews. Business metadata enhances discoverability.

**Lab Demos**:
1. In Data Catalog, search for datasets or columns.
2. Create custom metadata tags for better indexing.

## Looker Studio Visualization
### Overview
Looker Studio (formerly Data Studio) is a free BI tool for creating dashboards from BigQuery data.

### Key Concepts / Deep Dive
Connects via BigQuery connectors for visually appealing reports like charts and maps.

**Lab Demos**:
1. Open BigQuery table and select "Explore with Looker Studio."
2. Create visualizations (charts, pie charts) from query results.

## Big Data Products Recap
### Overview
This session recaps Google's big data ecosystem, mapping on-premise tools to GCP equivalents.

### Key Concepts / Deep Dive
- Hadoop → Dataproc
- Hive/Spark → BigQuery/Dataproc
- Kafka → Pub/Sub
- etc.

**Tables**:
| On-Prem Tool | GCP Equivalent |
|--------------|----------------|
| Hadoop       | Dataproc       |
| Hive         | BigQuery       |
| Kafka        | Pub/Sub        |
| Spark        | Dataproc/Dataflow |

**Lab Demos**: Review architecture diagrams for pipeline components.

### Quiz Insights
Sample questions on costing (use bq dry-run), storage choices (BigQuery for petabytes), Dataproc configurations (standard mode with preemptible VMs).

## Summary
### Key Takeaways
```diff
+ Data Fusion enables no-code ETL pipelines with visual wrangling and drag-and-drop.
+ Cloud Composer orchestrates Airflow DAGs for scheduled, fault-tolerant workflows.
+ Vertex AI Workbench supports interactive Jupyter-based data science.
- Data Prep requires third-party consent and may relocate data, risking compliance.
+ Data Catalog and Looker Studio enhance discovery and visualization.
- Complex pipelining should use Composer for scheduling over manual runs.
! Choose GCP native tools (Data Fusion) over third-party (Data Prep) for compliance and cost.
```

### Quick Reference
- **Data Fusion Wrangling**: Parse CSV, filter, rename, fill nulls.
- **Composer DAG**: Use Bash/PyTorch operators for tasks.
- **Workbench Commands**: 
  ```python
  client = bigquery.Client()
  query_job = client.query("SELECT COUNT(*) FROM dataset.table")
  ```
- **Data Prep Anomalies**: Detect missing/outlier values visually.
- **Cost Estimation**: `bq query --dry_run` for bytes processed.

### Expert Insight
#### Real-world Application
Use Data Fusion for batch ETL in retail (e.g., transforming sales TSVs to BigQuery for analytics). Composer schedules daily reports; Workbench prototypes ML models; Data Catalog finds datasets in large orgs.

#### Expert Path
Master Airflow DAGs in Composer for complex dependencies. Learn custom transformations in Data Fusion. Explore Looker ML for advanced BI.

#### Common Pitfalls
- Exceeding Data Fusion quotas; use small-scale testing first.
- Ignoring data residency in Data Prep; opt for Data Fusion.
- Not partitioning BigQuery tables; impacts query costs.
- Oversetting Composer environments; monitor for cost.

#### Lesser-Known Facts
- Data Fusion UI is browser-based only; no API for creation unlike Dataproc.
- Compose runs on Google-managed Kubernetes; not customizable.
- Workbench instances can be ephemeral; persist data on disks.
- Data Plex is evolving to unify data governance across GCP.

### Transcript Corrections Made
- "ript" to "script" (likely "script").
- "con saw" to "conference will now be recorded".
- "McKenzie" to "instance" in "data fusion instance".
- "wear" to "query" in "BigQuery query".
- "payfiles" to "Parquet files".
- "pushub" to "Pub/Sub".
