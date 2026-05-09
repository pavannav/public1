# Session 74: Batch & Stream Processing using Dataflow Demo Dataproc Concept and Demo Datafusion Composer

## Table of Contents
- [Introduction to Complex Data Processing](#introduction-to-complex-data-processing)
- [Pub/Sub to BigQuery via Dataflow](#pubsub-to-bigquery-via-dataflow)
- [Dataflow Pricing and Architecture](#dataflow-pricing-and-architecture)
- [Data Proc Introduction and Use Cases](#data-proc-introduction-and-use-cases)
- [Data Proc Cluster Creation and Management](#data-proc-cluster-creation-and-management)
- [Datafusion ETL Tool](#datafusion-etl-tool)
- [Cloud Composer Orchestration](#cloud-composer-orchestration)
- [Summary](#summary)

## Introduction to Complex Data Processing

### Overview
This session covers advanced data processing concepts in Google Cloud, focusing on ETL tools for handling both batch and streaming data. The main topics include Apache Beam/Dataflow for serverless processing, Data Proc for managed Hadoop/Spark clusters, Data Fusion for no-code pipelines, and Cloud Composer for workflow orchestration.

### Key Concepts
**Apache Beam Pipeline Flow:**
- Real-time data comes from Pub/Sub topic
- Dataflow processes data using templates without custom coding
- Output is written to BigQuery in proper schema format

**Common Data Processing Patterns:**
```diff
- Batch Processing: Large volumes of data processed in scheduled intervals
+ Stream Processing: Real-time data processing with low latency requirements
```

**Data Type Considerations:**
- Correct data types crucial for successful processing (e.g., float vs numeric in BigQuery)
- Use AI tools (ChatGPT) to generate BigQuery schemas from JSON payloads
- Float data types required for latitude/longitude, meter readings

### Code/Config Blocks
**JSON Payload Sample:**
```json
{
  "passenger_count": 1,
  "trip_distance": 3.34,
  "fare_amount": 14.16,
  "total_amount": 16.31,
  "pickup_longitude": -73.93766,
  "pickup_latitude": 40.75808,
  "dropoff_longitude": -73.98541,
  "dropoff_latitude": 40.76323,
  "payment_type": 1,
  "pickup_datetime": "2011-01-01T00:04:00.0000000Z"
}
```

**BigQuery Schema Generated:**
```sql
[
  {"name": "passenger_count", "type": "INTEGER", "mode": "NULLABLE"},
  {"name": "trip_distance", "type": "FLOAT", "mode": "NULLABLE"},
  {"name": "fare_amount", "type": "FLOAT", "mode": "NULLABLE"},
  {"name": "pickup_longitude", "type": "FLOAT", "mode": "NULLABLE"},
  {"name": "pickup_latitude", "type": "FLOAT", "mode": "NULLABLE"}
]
```

### Lab Demos
To access JSON payload for schema generation:
1. Create subscription to public Pub/Sub topic
2. Pull messages using `gcloud pubsub subscriptions pull taxi_subscription`
3. Use JSON validators online or VS Code format document feature
4. Never use production/critical data payloads for online formatting tools

## Pub/Sub to BigQuery via Dataflow

### Overview
Demonstrates real-time data streaming from Pub/Sub to BigQuery using Dataflow templates with proper cost management.

### Key Concepts
**Dataflow Solution Architecture:**
- Pub/Sub subscription as data source
- Dataflow template converts JSON to tabular format
- BigQuery table as destination with partitioning enabled
- Service accounts with minimal required roles

**Service Account Configuration:**
```diff
+ Required IAM Roles for Dataflow Service Account:
  - Pub/Sub Subscriber (consume messages)
  - BigQuery Data Editor (write data)
  - BigQuery Job User (run BigQuery jobs)
  - Storage Object User (write temporary files)
  - Dataflow Worker (execute pipeline)
```

### Lab Demos
**Creating BigQuery Table:**
1. Create empty BigQuery table with proper schema
2. Enable table partitioning using timestamp field
3. Enable partition filter requirements for cost optimization
4. Validate schema compatibility (float vs numeric)

**Dataflow Pipeline Execution:**
1. Use Pub/Sub to BigQuery template
2. Configure source subscription and destination table
3. Set regional endpoint (Mumbai/US-Central) with proper networking
4. Enable private IP with Private Google Access
5. Monitor pipeline DAG and message processing metrics

**Troubleshooting Pattern:**
```diff
- Incorrect region/network combination causes failures
- Missing Private Google Access prevents VM connectivity
- Schema data type mismatches cause data processing failures
- Service account permissions determine pipeline capabilities
```

## Dataflow Pricing and Architecture

### Overview
Dataflow provides serverless data processing with fully managed infrastructure, making it unique among cloud ETL tools.

### Key Concepts
**Dataflow Uniqueness:**
- Fully serverless solution using virtual machines
- Compute resources provisioned automatically
- Infrastructure abstracted from users (unlike other serverless products)
- Templates written in Java/Python with Apache Beam

**Cost Optimization:**
```diff
+ Dataflow Costs Include:
  - Compute Engine instances (VMs)
  - Storage for temporary files
  - Dataflow service charges (minimal)
  - Network egress costs

- Batch vs Streaming Processing:
  + Batch jobs: Compute resources de-provisioned after completion
  + Streaming jobs: Long-running, resource costs continue until manually stopped
```

**VM Visibility:**
- Dataflow provisions actual VMs (unlike purely serverless services)
- VMs use Container-Optimized OS with Java Beam pipelines
- Service account controls access to Pub/Sub, BigQuery, Cloud Storage
- Internal IP addresses for secure communication

### Expert Insight
**Real-world Application:**
Dataflow templates enable rapid deployment of complex pipelines without coding expertise.

**Expert Path:**
- Learn Apache Beam programming model for custom pipelines
- Understand windowing and triggers for complex event processing
- Master pipeline monitoring and optimization patterns

**Common Pitfalls:**
- Forgetting regional networking requirements for private IPs
- Underestimating streaming job long-term costs
- Ignoring service account privilege boundaries

**Lesser-Known Facts:**
Dataflow uses Kubernetes-like pod structures internally for Java pipelines.

## Data Proc Introduction and Use Cases

### Overview
Managed Apache Hadoop/Spark clusters for lift-and-shift migrations from on-premise big data environments.

### Key Concepts
**Hadoop Ecosystem Evolution:**
```diff
+ MapReduce Programming Model:
  - Split large tasks across commodity hardware
  - Process 10KB chunks on individual nodes
  - Aggregate results across distributed workers
  - Fault-tolerant architecture with Hadoop YARN
```

**Greenfield vs Brownfield Use Cases:**
- Greenfield: Modern applications built in cloud (prefer Dataflow)
- Brownfield: Existing Hadoop/Spark workloads migrated to cloud (prefer Data Proc)

**Cost Optimization Strategies:**
```diff
+ Spot/Preemptable VMs for reduced costs:
  - Up to 90% discount on compute costs
  - Risk of VM termination during processing
  - Fault-tolerant architecture handles VM failures
  - Suitable for batch processing workloads
```

### Tables

| Feature | Dataflow | Data Proc | Data Fusion | Cloud Composer |
|---------|----------|-----------|-------------|----------------|
| Use Case | Modern ETL | Hadoop Migration | No-code Pipelines | Orchestration |
| Infrastructure | Serverless VMs | Managed Cluster | Serverless DAGs | Managed Airflow |
| Programming | Apache Beam | Hadoop/Spark | Drag & Drop | Python DAGs |
| Cost | Moderate | Variable | High | Moderate |

### Lab Demos
**Word Count Demo Pattern:**
- Read text data from Cloud Storage
- Count word frequencies using MapReduce
- Write results back to Cloud Storage
- Compare execution time vs. Dataflow templates

**Cost Analysis Example:**
- 4 VMs (2 regular + 2 spot) with 90% spot discount
- 5 hours vs. 2 regular VMs for 10 hours
- Spot instances provide better cost efficiency

## Data Proc Cluster Creation and Management

### Overview
Demonstrates managed Hadoop cluster provisioning with optimized virtual machine configurations.

### Key Concepts
**Cluster Architecture Types:**
- Standard: 1 Master + N Workers (production ready)
- High Availability: 3 Masters + N Workers (enterprise HA mode)
- Single Node: 1 Master only (development/testing)

**Service Account Security:**
```diff
+ Data Proc Worker Role Capabilities:
  - Manage VM instances in cluster
  - Access Cloud Storage buckets
  - Submit jobs to resource manager
  - Handle cluster autoscaling/deletion
```

### Lab Demos
**Cluster Provisioning:**
1. Select standard cluster type for HA setup
2. Configure master node (e.g., N2-highmem-4 with custom storage)
3. Configure worker nodes with preemptable VMs for cost savings
4. Enable component gateway for web UI access

**Role Separation:**
- Use dedicated service account per cluster
- Grant minimal required roles (Data Proc Worker provides most capabilities)
- Enable private IPs with VPC networking
- Configure automatic cluster deletion for cost control

**Job Submission:**
```bash
gcloud dataproc jobs submit hadoop \
  --cluster=my-cluster \
  --class=org.apache.hadoop.examples.WordCount \
  -- /input/path /output/path
```

## Datafusion ETL Tool

### Overview
No-code ETL platform using drag-and-drop interface for data integration pipelines.

### Key Concepts
**Data Fusion Value Proposition:**
- Eliminates coding requirements for ETL pipelines
- Uses open-source CDE (Cloud Data Exchange) platform
- Enterprise-grade with Google support and SLA
- Creation time: 15-20 minutes

**Architecture Components:**
- Canvas for pipeline design
- Wrangler plugin for data transformations
- Managed execution environment with Data Proc integration
- Support for 80+ connectors and transformations

## Cloud Composer Orchestration

### Overview
Managed Apache Airflow service for complex workflow orchestration and scheduling.

### Key Concepts
**Airflow Components:**
- Directed Acyclic Graphs (DAGs) define workflows
- Scheduler triggers DAG executions
- Workers execute tasks in parallel
- Web UI for monitoring and debugging

**Multi-Project Architecture:**
- Customer Project: Kubernetes cluster running Airflow pods
- Tenant Project: Cloud SQL database, Redis cache, Storage buckets
- VPC peering connects customer and tenant resources
- Cloud SQL proxy enables secure database connectivity

### Tables

| Component | Customer Project | Tenant Project |
|-----------|------------------|----------------|
| Kubernetes Cluster | ✅ | ❌ |
| Cloud SQL Database | ❌ | ✅ |
| Redis Cache | ❌ | ✅ |
| App Engine Flex | ✅ | ❌ |
| GCP Services | Both | Both |

### Expert Insight
**Real-world Application:**
Use Cloud Composer to orchestrate data pipelines across multiple services (GCS → Dataflow → BigQuery → Looker).

**Expert Path:**
- Master Python DAG development with Airflow operators
- Design fault-tolerant workflows with retries and SLAs
- Implement complex branching and conditional logic

**Common Pitfalls:**
- Underestimating resource costs (GKE cluster + Cloud SQL + storage)
- Ignoring cross-region networking requirements
- Over-spending by leaving instances running

**Lesser-Known Facts:**
Cloud Composer internally uses most GCP services, making it an excellent architectural showcase.

## Summary

### Key Takeaways
```diff
+ ETL Tools Comparison:
  - Dataflow: Serverless Apache Beam pipelines for modern development
  - Data Proc: Managed Hadoop/Spark clusters for legacy migrations
  - Data Fusion: No-code pipelines for business users
  - Cloud Composer: Workflow orchestration for complex data operations

+ Cost Optimization Patterns:
  - Use spot/preemptable VMs in Data Proc for batch workloads
  - Configure auto-deletion policies for idle resources
  - Choose regional architectures matching data locations
  - Implement service account least-privilege patterns

- Infrastructure Management:
  ! Dataflow abstracts infrastructure but shows actual VMs
  ! Data Proc provides full cluster control with manual management
  ! Data Fusion provides no-code abstraction over Data Proc
  ! Cloud Composer orchestrates all ETL tools seamlessly
```

### Quick Reference
**Dataflow Templates:**
- Pub/Sub → BigQuery: JSON to Tabular conversion
- Cloud Storage → BigQuery: File ingestion
- Processing time batch: Hourly aggregations

**Service Account Roles:**
- Dataflow Worker: Core pipeline execution
- Data Proc Worker: Cluster management
- Storage Object Admin: File operations
- BigQuery Data Editor: Data manipulation

**Common Commands:**
```bash
# Format JSON in Cloud Shell
cat payload.json | python -m json.tool

# Pull Pub/Sub messages for inspection
gcloud pubsub subscriptions pull my-subscription --limit=5

# Submit Hadoop job to Data Proc
gcloud dataproc jobs submit hadoop --cluster=my-cluster --class=WordCount -- input output
```

### Expert Insight
**Real-world Application:**
Choose ETL tools based on team skills and migration strategy rather than pure technical superiority.

**Expert Path:**
- Master cost optimization patterns across pipeline types
- Learn Kubernetes for Data Proc and Composer architectures
- Understand networking patterns for private IP deployments
- Focus on observability integration for production deployments

**Common Pitfalls:**
- Assuming all ETL tools are interchangeable
- Underestimating Data Fusion licensing costs
- Ignoring regional networking requirements
- Over-provisioning Data Proc clusters without auto-scaling

**Lesser-Known Facts:**
- Data Proc serverless exists but lacks Hadoop ecosystem support
- Dataflow can access containerized VMs via SSH for debugging
- Cloud Composer uses over 10 GCP services internally
- All tools support different levels of customization vs. abstraction

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
