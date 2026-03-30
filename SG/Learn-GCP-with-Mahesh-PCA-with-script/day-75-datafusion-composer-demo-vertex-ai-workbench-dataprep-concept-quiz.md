# Session 75: Data Fusion and Composer Demo, Vertex AI Workbench, Dataprep Concept, Quiz

| Section | Topic |
|---------|-------|
| [Cloud Data Fusion](#cloud-data-fusion) | [Overview](#overview-broken-off-introdu) <br> [Data Fusion Instance Creation](#data-fusion-instance-creation) <br> [Wrangler Tool Demo](#wrangler-tool-demo) <br> [Pipeline Creation](#pipeline-creation) <br> [Run-time Configuration](#run-time-configuration) <br> [Deployment and Execution](#deployment-and-execution) |
| [Cloud Composer](#cloud-composer) | [Overview](#overview-1) <br> [Provisioning](#provisioning) <br> [Airflow Interface Demo](#airflow-interface-demo) |
| [Vertex AI Workbench](#vertex-ai-workbench) | [Overview](#overview-2) <br> [Instance Creation](#instance-creation) <br> [Jupyter Notebook Usage](#jupyter-notebook-usage) <br> [Code Execution Examples](#code-execution-examples) |
| [DataPrep and Dataplex Concepts](#dataprep-and-dataplex-concepts) | [DataPrep Overview](#dataprep-overview) <br> [Comparison/Table](#comparison-table) <br> [Dataplex Introduction](#dataplex-introduction) |
| [Additional Concepts](#additional-concepts) | [Data Catalog](#data-catalog) <br> [Looker Studio Demo](#looker-studio-demo) |
| [Quiz](#quiz) | [Question 1](#question-1) <br> [Question 2](#question-2) <br> [Question 3](#question-3) <br> [Question 4](#question-4) |

## Cloud Data Fusion

### Overview
Cloud Data Fusion is a fully managed, cloud-native data integration service that enables users to build and manage data pipelines for batch and real-time processing. It serves as a no-code/low-code alternative to Apache Nifi, allowing drag-and-drop orchestration of data workflows. Powered by Cask Data Application Platform (CDAP), it supports ELT/ETL processes by integrating with various sources and sinks, including GCP services like BigQuery, Cloud Storage, and Pub/Sub, as well as third-party systems like Oracle or AWS resources.

### Data Fusion Instance Creation
Creating a Data Fusion instance involves UI-based provisioning, unlike other GCP services that can be managed via CLI. Cloud Data Fusion instances are not available in gcloud CLI beta commands, as Google emphasizes UI-driven management for resource provisioning. Instance creation takes approximately 18 minutes and costs about $10/hour. For regional data processing, ensure the instance is in the same region as your data sources/sinks (e.g., us-west1 for west1 processing).

- **Tip**: Use single-region setups for data processing to optimize performance.
- **Cost Consideration**: Data Fusion instances auto-delete after 10 minutes of inactivity by default; monitor logs for any stuck states (e.g., deleting), as they can incur charges.
- **Ergonomics**: Interface is browser-based and thin-client, requiring authentication similar to identity proxy.

### Wrangler Tool Demo
The Wrangler tool in Data Fusion is a no-code environment for data exploration, cleansing, and enrichment. It connects to data sources (e.g., GCS buckets) in auto-discovered regions and parses formats like CSV or TSV. Key features include:

- **Input Parsing**: Handles tab-separated values (TSVs) by specifying tab delimiters and header rows.
- **Data Type Validation**: Provides column-wise completeness metrics (e.g., 99.8% for user_id). Incomplete columns require transformations.
- **Transformations Applied**:
  1. Parse CSV with tab delimiter and header.
  2. Remove unnecessary columns (e.g., drop body_0).
  3. Filter null rows on key columns (e.g., user_id).
  4. Rename columns (e.g., "dÉpartement" to "department" for normalization).
  5. Fill null/empty cells with defaults (e.g., "1000" for empty department).
- **Sample Data Insights**: Built-in analytics show distributions (e.g., most common department "13", birth dates aggregated by month).
- **Completeness Achievement**: After transformations, all columns reach 100% completeness via row filtering and null filling.

Code blocks or configs can be exported as JSON for reuse.

### Pipeline Creation
Pipelines in Data Fusion are built via drag-and-drop canvas, supporting batch (using Dataflow underneath) and real-time (using Pub/Sub) modes. For the demo:

- **Source**: GCS bucket with TSV data (parsed and wrangled).
- **Sinks**: BigQuery (managed tables) and GCS (raw files preserved as Parquet).
- **Wrangler Integration**: Wranglings are embedded as pipeline nodes.
- **Data Flow**: Source → Wrangler → BigQuery Sink & GCS Sink.

Attach temporary storage buckets as needed.

### Run-time Configuration
For cost-effective demos or trials, customize profiles to override defaults:

- **Pods**: Autoscaling and Data Proc modes available.
- **Compute**: Use e2-standard series (8 vCPUs), reduce storage (e.g., 100GB magnetic/standard SSD) to avoid quota issues.
- **Security**: Service accounts default to Compute Engine default unless custom specified.

Pre-submit validations ensure syntactic correctness (e.g., errors logged for unsupported partitioning fields like strings on timestamp columns).

### Deployment and Execution
- **Deployment**: Locks canvas, preventing edits; creates non-editable views.
- **Execution**:
  - Leverages Data Proc clusters auto-provisioned (3 VMs: 1 master, 2 workers).
  - Monitoring via logs (advanced over basic); jobs shown in Data Proc UI as Hadoop jobs.
  - Completion triggers auto-deletion (inactivity timeout: 10 minutes).
- **Preview Mode**: Dry-run allows verifying transformations without execution.
- **Partitioning/Clustering**: BigQuery sink supports pseudo-partitioning by ingestion time; clustering by fields like department.
- **Sizing Notes**: Demo ran 3 minutes profiling + 7 minutes job execution (~$0.50 cost total in e2 tiers).
- **Post-Execution**: Data available in BigQuery/external GCS tables; pipelines can be duplicated for versions.

> [!NOTE]  
> Architecturally similar to on-prem NiFi, deployed on GCP Kubernetes/Pub/Sub.

> [!IMPORTANT]  
> Data Fusion uses Data Proc for compute; ensure quotas for VMs/disks.

## Cloud Composer

### Overview
Cloud Composer (managed Apache Airflow on GCP) orchestrates complex pipelines, scheduling jobs across services like Dataflow, Data Proc, and databases. It ensures fault-tolerant execution, retries, and cron-like scheduling. Backend: Autopilot-mode GKE clusters (Composer 3) running Airflow 2. Tasks defined as DAGs (Python scripts uploaded to GCS). Ideal for multi-step ETL where sequencers or dependencies exist.

Real-time pipelines use Pub/Sub; batch uses Data Proc/Dataflow engines.

### Provisioning
- **Versions**: Composer 1 (legacy GKE), Composer 2/3 (autopilot GKE).
- **Region Selection**: Match data regions (us-central1 desired, but demo in default).
- **Creation Time**: ~20 minutes.
- **Web Server**: Hosted on App Engine Flexible Environment.
- **Tenant Limitation**: Runs on shared tenant projects, restricting direct GKE/BigIP access.

First login prompts SSO-like authentication.

### Airflow Interface Demo
- **DAGs**: Define jobs as Python DAGs with tasks (Bash/Python operators).
- **Example DAG Structure** (code-free UI references):
  ```python
  from airflow import DAG
  from airflow.decorators import task
  from datetime import datetime

  @task
  def echo_test():
      print("Test message")

  @task
  def ping_check():
      import subprocess
      result = subprocess.run(["ping", "-c", "3", "google.com"], capture_output=True, text=True)
      print(result.stdout)

  with DAG('ping_dag', start_date=datetime(2023, 10, 1), schedule_interval='@hourly') as dag:
      echo_task >> ping_check()
  ```
- **Execution**: Upload DAGs to `/dags` (GCS bucket); UI schedules/runs manually or via cron.
- **Operators**: Bash for CLI commands; supports retries/scheduling.
- **Logs/Graphs**: Track task dependencies, executions, and failures.
- **Demo Issue**: Version conflict/misconfig prevented full run; re-uploaded and scheduled successfully.

Orchestrates: Source ingestion → Transform → Sink.

> [!IMPORTANT]  
> DAG uploads to GCS; Airflow handles multi-step retries.

## Vertex AI Workbench

### Overview
Vertex AI Workbench (formerly Datalab/AI Platform Notebooks) provides managed Jupyter notebooks on pre-configured VMs for data science/ML experimentation. Eliminates local setups; offers Python/IPyTorch/TensorFlow kernels, terminal access, and GCS integration. Idle timeout (30min default) stops costs; supports GPU attachments. Analogous to Colab but enterprise-grade with persistent storage (separate boot/data disks).

### Instance Creation
- **Type**: Legacy noted discrepancies; prefer "new instance" for modern UI.
- **Configurations**:
  - OS: Debian/Ubuntu.
  - Machine: e2-standard (2vCPUs) or higher; idle time: 10-30min.
  - Disks: Boot (persistent), data (separate for analysis).
  - Access: External IP enabled; proxy for security.
  - Permissions: Service accounts for broader GCP access.
- **Provisioning**: ~10-15 minutes; appears under AI > Vertex AI > Workbench.

Creates VM/cluster compute costs primarily.

### Jupyter Notebook Usage
- **Interface**: Browser-based; open via "OPEN JUPYTERLAB" post-creation.
- **Kernels**: Python 3, PyTorch, TensorFlow (service accounts inherit access).
- **Features**:
  - Cell execution (line-by-line debugging).
  - Markdown docs; export as `.ipynb`.
  - Terminal access for gcloud/Linux commands.
  - Auto-shutdown on inactivity.
- **Security**: Managed auth; no direct VM login.

Ideal for EDA (Exploratory Data Analysis) without code heavy-lifting.

### Code Execution Examples
- **Basic Python**:
  ```python
  concept = "Vertex AI Workbench"
  print(concept)
  ```
- **GCP Integration**:
  ```bash
  # Via terminal or magic
  %system gcloud projects list
  ```
  Or bash cell: `!ping -c 3 google.com`
- **BigQuery Access** (pip install google-cloud-bigquery pre-installed):
  ```python
  from google.cloud import bigquery
  client = bigquery.Client()
  query = "SELECT * FROM dataset.table LIMIT 10"
  results = client.query(query).to_dataframe()
  print(results)
  ```
- **Export/Share**: JSON download; hosted gists for collaboration.

Triggers VM start on access; sustainable for dev teams.

> [!NOTE]  
> Formerly Datalab; auto-migrates to Workbench.

## DataPrep and Dataplex Concepts

### DataPrep Overview
Cloud Dataprep (now Altrix Designer Cloud post-acquisition) is a third-party SaaS for no-code data profiling, cleansing, and anomaly detection. Wrangles data via recipes, generates transformation code. Strengths: Outlier detection, missing values flagging, unique/mismatch analysis. Weaknesses: Data residency concerns (US-cent dep.); requires legal vetting for compliance. Acquired by Alteryx; not native GCP (shares data broadly).

- **Use Case**: Quick anomaly detection without pipelines.
- **Comparison**: Faster for prototyping but compliance risks.

### Comparison/Table

| Aspect | Cloud Data Fusion | Cloud Dataprep/Alteryx |
|--------|-------------------|--------------------------|
| **Ownership** | GCP Native | Third-party (Alteryx) |
| **Code Level** | Low/No-code | No-code |
| **Anomalies** | Basic insights | Advanced (outliers, mismatches) |
| **Costs** | Infra (VMs/Data Proc) | SaaS-based (lower?); auto-scaling |
| **Data Residency** | Regional control | US-centric; export risks |
| **Ease for Teams** | Architects/Engineers | Analysts (SQL optional) |
| **Integration** | Full GCP ecosystem | Limited; consents required |

Prefer Data Fusion for GCP-native, cost-effective, compliance-safe pipelines; Dataprep for rapid anomaly detection in non-sensitive data.

### Dataplex Introduction
Dataplex (new GCP service) supersedes Data Catalog for unified data governance/lifecycle management. Enables metadata-based search, governance policies (owners, policies), and data quality checks. Bridges analytics/storage.

- **Features**: Metadata discovery (technical/business); lineage tracking.
- **Enhancement**: Adds governance (Plex = complex) over Catalog's search focus.

> [!WARNING]  
> Dataprep requires consents; avoid for regulated data.

## Additional Concepts

### Data Catalog
Old service for metadata-powered data discovery across BigQuery, Bigtable, GCS, etc. Stores technical (schemas) and business (descriptions) metadata for search (e.g., "taxi tables"). Integrated into Dataplex.

- **Demo**: Search public COVID data; local tables by keywords/descriptions.
- **Limits**: No governance; relegated to Dataplex.

### Looker Studio Demo
Free BI tool (formerly Data Studio) for visualizations from BigQuery/GCS. Creates charts (e.g., passenger count histograms) via drag-and-drop. Pro version (Looker) adds scheduling/alerts. Alternative for non-engineers.

- **Config**: Connect BigQuery; add queries/tables; build reports/dashboard visualizations.

> [!IMPORTANT]  
> Visualizations unlock value from raw data pipelines.

## Quiz

### Question 1: BigQuery Query Cost Estimation
You need to estimate annual cost of nightly-querying BigQuery.  
Solutions:  
- Run `bq query --dry_run` to get bytes processed; input into calculator x365.  
Correct: B (`bq query --dry_run`).  
(No gcloud estimate commands exist for BigQuery.)

### Question 2: Data Pipeline Architecture
Design storage for CSV files, interactive Spark transforms, SQL queries for complex aggregations, reusing existing code.  
Correct: B (BigQuery for storage/queries + Data Proc for Spark transforms).  
(Supports SQL + code reuse; GCS lacks SQL; others don't fit.)

### Question 3: Cost-Optimize Data Proc for Non-Critical Spark
Set up cluster for large-data Spark transforms cost-effectively.  
Correct: C (Standard mode, high-memory machines + preemptible VMs).  
(Preemptibles lower costs; avoid unnecessary HA/SSDs for non-critical.)

### Question 4: Migrate Multitetabyte Data for 24/7 SQL Analysis
Store for business analysts using SQL only.  
Correct: A (Load into BigQuery).  
(Handles petabytes; SQL-native; others lack SQL or scale.)

## Summary

### Key Takeaways
```diff
+ Cloud Data Fusion: No-code ELT/ETL on Data Proc; drag-and-drop pipelines with Wrangler for cleansing.
+ Cloud Composer: Managed Airflow for pipeline orchestration; DAGs handle retries/scheduling.
+ Vertex AI Workbench: Jupyter on managed VMs for data science; supports kernels, terminals, auto-shutdown.
+ DataPrep: SaaS anomaly detection; compliance caveats; Alteryx-owned.
+ Dataplex: Evolves Data Catalog with governance/search.
+ Looker Studio: Free BI for GCP data visualizations.
- Avoid stuck resources (e.g., Data Fusion delete failures) to prevent costs.
- Prefer native GCP for compliance/security; use preemptibles for cost-savings.
- BigQuery drives most analytics; integrates with all demoed services.
```

### Expert Insight

**Real-world Application**: GCP data stacks (Data Fusion → BigQuery → Dashboards) power real-time analytics for retail (e.g., inventory optimization via Cloud Composer scheduling). Vertex Workbench enables rapid ML prototyping on big data.

**Expert Path**: Master BigQuery SQL/partitioning; explore Datafusion APIs for custom plugins; practice Airflow DAGs for complex workflows.

**Common Pitfalls**: Ignoring data residency in Dataprep (legal vet first); over-provisioning via defaults (customize for costs); forgetting BigQuery dry-runs (leads to unexpected bills).

**Common Issues and Resolutions**:  
- Data Fusion jobs stuck: Check Data Proc cluster logs; restart via API or re-deploy pipeline.  
- Composer DAG fails: Validate GCS permissions; ensure Airflow versions match.  
- Workbench kernel errors: Reboot VM or resize disk.  
- Dataprep exports fail: Review Alteryx docs for region-specific bugs.  

**Lesser Known Things**: GCP data services auto-provision ephemeral infra (e.g., Data Proc VMs delete post-job); Data Catalog metadata auto-indexes phylogeny; Looker Studio embeds real-time BigQuery queries without code.  
model_id: CL-KK-Terminal
