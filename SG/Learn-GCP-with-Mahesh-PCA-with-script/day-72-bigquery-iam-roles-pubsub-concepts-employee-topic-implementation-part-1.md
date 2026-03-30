## Session 72: BigQuery IAM Roles, PubSub Concepts, Employee Topic Implementation Part 1

### Table of Contents
- [BigQuery IAM Roles](#bigquery-iam-roles)
- [Partition Expiry and Query History](#partition-expiry-and-query-history)
- [Viewing Query Jobs and History](#viewing-query-jobs-and-history) 
- [PubSub Messaging Concepts](#pubsub-messaging-concepts)
- [Employee Topic Implementation](#employee-topic-implementation)
- [Summary](#summary)

### BigQuery IAM Roles

#### Overview
BigQuery provides predefined IAM roles with specific permissions for managing access to datasets, tables, and resources. These roles help control who can view metadata, execute queries, manage billing, and access audit information.

#### Key Concepts

##### Connection Admin Role
This role grants permissions to create and manage connections to external data sources like Cloud SQL, Spanner, or external data stores.

**Permissions required for:**
- Creating federated queries
- Connecting BigQuery to external systems
- Interacting with external data (MySQL, PostgreSQL, Cloud SQL for SQL Server - excluding SQL Server)

**Use cases:** Organizations needing to query data across multiple cloud services without data migration.

##### Connection User Role  
This companion role to connection admin allows viewing and using existing connections.

**Key permission:** `bigquery.connections.use`

##### Resource Admin Role
This advanced role provides visibility into resource usage and query execution across projects.

**Key permissions:**
- `bigquery.jobs.listAll` - View all queries executed by any user

**Authentication requirement:** Must be authenticated to access project resources

**Use case:** Cloud architects monitoring query patterns and optimization opportunities.

##### Session Reader Role
This role enables programmatic access to BigQuery data using BigQuery Storage Read API for improved performance over legacy API.

**Key permission:** `bigquery.readsessions.create`

**Performance benefit:** Faster data retrieval compared to standard query API

**Implementation:** Requires code using Storage Read API client libraries

##### Filtered Data Viewer Role
This specialized role allows selective data access using row-level security policies.

**Example use case:** 
```sql
-- Row access policy restriction
WHERE department_id = 1
```

Allows users to execute queries but only see data matching specific filter criteria.

##### Other Roles Mentioned
- **Data Editor (BigQuery Editor):** Full CRUD operations on datasets and tables
- **Data Owner:** Longer-term ownership and management permissions  
- **Metadata Viewer:** Read-only access to table schemas and dataset metadata
- **Job User:** Permission to execute queries and consume project billing
- **Data Policy Admin/Viewer:** Managing data policies and classifications

### Partition Expiry and Query History

#### Overview  
BigQuery supports data lifecycle management through table-level partitioning and expiration settings to automatically clean up old data.

#### Key Concepts

##### Partition Management
- Automatic partition removal when expiry time is reached
- Removes both data and partition metadata
- Verification queries on `INFORMATION_SCHEMA.PARTITIONS`

**Example verification SQL:**
```sql
SELECT *
FROM `project.dataset.table`@INFORMATION_SCHEMA.PARTITIONS
WHERE partition_id IS NOT NULL
```

##### Table-Level Expiry
- Deletes entire tables after specified retention period
- Applied during table creation or alteration
- Cleanup occurs automatically without manual intervention

##### Partition ID Format
- Follows pattern: `YYYYMMDD`
- Example: `20250608` for June 8, 2025

**Tables Used:**
| Metric | Description |
|--------|-------------|
| Partition ID | Date-based partition key |
| Bytes Process | Computational bytes billed |
| Bytes Billed | Storage bytes billed |

### Viewing Query Jobs and History

#### Overview
BigQuery provides comprehensive audit capabilities to track query execution, identify billing culprits, and optimize resource consumption.

#### Key Concepts

##### Personal vs. Project History
Access depends on assigned roles:
- **BigQuery Resource Viewer** role: Full project visibility
- Personal history: Only user's own queries

**Role Permissions Required:**
- `bigquery.jobs.listAll` (or `bigquery.jobs.list` for partial access)

##### Command Line Access

**Personal history:**
```bash
bq ls -j -a  # View all personal jobs
```

**Project history (requires Resource Viewer role):**
```bash
bq ls --jobs --all  # View all project jobs
```

**Job details retrieval:**
```bash
bq show --format=prettyjson project:region.job_id
```
> Required format for regional jobs
> Replace `region` with actual location (e.g., `asia-south1`)

##### Audit Metrics
| Metric | Importance | Use Case |
|--------|------------|----------|
| Bytes Processed | Billing calculation | Cost monitoring |
| Bytes Billed | Actual charges | Budget tracking |
| Job Type | Query classification | Resource management |
| User Identity | Accountability | Security auditing |

### PubSub Messaging Concepts

#### Overview
Cloud Pub/Sub is a fully managed, global messaging service that enables asynchronous communication between systems using a publisher-subscriber model. It acts as a decoupling layer that handles message ingestion, routing, and delivery.

#### Key Concepts

##### Core Components
**Topic:** Message storage and routing hub
**Subscription:** Consumer connection point for processing messages
**Publisher:** Producer application sending messages
**Subscriber:** Consumer application processing messages

##### Message Characteristics
- **Maximum size:** 10 MB per message
- **Supported content:** Text, JSON, CSV, base64-encoded data
- **Text-based requirement:** Must be representable in textual form

##### Messages and Attributes
Messages support up to 100 attributes (256 bytes each), enabling filtering and routing logic.

**Example message with attribute:**
```json
{
  "data": "user1,department1,20250101",
  "attributes": {
    "employee_type": "F"
  }
}
```

##### Delivery Patterns

###### Push Delivery
- Configurable endpoint (Cloud Functions, Cloud Run, App Engine)
- Real-time notification to subscriber
- Low latency (~1-2 seconds)
- Requires acknowledgment within specified timeframe

###### Pull Delivery  
- Manual message retrieval by subscriber
- Built-in dead-letter topic support for failed messages
- Configurable retry policies with exponential backoff
- Queue-like behavior

### Employee Topic Implementation

#### Overview
This demonstration implements a realistic employee onboarding system using Pub/Sub with multiple subscription patterns to route messages based on employee type (FTE vs. Contract).

#### Key Concepts

##### Fan-Out Pattern
Single topic with multiple subscriptions receiving copies of messages:

```diff
+ Employee Topic
+- Payroll Subscription (FTE filtering)
+- Shared Services Subscription (All employees)  
+- Contractors Union Subscription (Contractor filtering)
+- IT Services Push Subscription (Real-time processing)
```

##### Fan-In Pattern  
Multiple publishers sending different message types to centralized topic for systematic processing.

##### Subscription Configuration

| Subscription Type | Delivery Method | Filter Criteria | Acknowledgment | Use Case |
|------------------|-----------------|---------------|----------------|----------|
| Payroll | Pull | `employee_type = "F"` | 30 seconds | Salary processing |
| Shared Services | Pull | No filter | 30 seconds | Transportation, email |
| Contractors Union | Pull | `employee_type = "C"` | 30 seconds | Contractor management |
| IT Services | Push | No filter | N/A | Real-time account creation |

**Example message format:**
```json
{
  "employee_id": "user1",
  "department": "dept1", 
  "start_date": "20250101",
  "employee_type": "F"
}
```

##### Filter Implementation
```python
# Messages automatically routed based on attributes
if employee_type == "F":
    # Send to payroll subscription
elif employee_type == "C":  
    # Send to contractors union subscription
```

##### Broker Role Access
- **Publisher role:** Submit messages to topic
- **Subscriber role:** Retrieve messages from subscriptions
- **Admin role:** Modify topic and subscription configurations

### Summary

#### Key Takeaways
```diff
+ BigQuery roles control access granularity from basic viewer to full admin capabilities
+ Pub/Sub enables decoupling publisher and subscriber systems for scalability  
+ Multiple subscription patterns allow fan-out (single-to-many) and filtering based on attributes
+ Push delivery provides real-time processing while pull enables batch processing
+ IAM roles are critical for proper security and auditing capabilities
- Pub/Sub messages must be text-based and under 10MB limit
- Duplicate message handling is required in application code
! Always verify acknowledgments within specified timeframes to prevent message expiration
```

#### Real-world Application
**Enterprise Data Integration:** Pub/Sub serves as the foundation for event-driven architectures, connecting SaaS applications, IoT devices, and legacy systems without tight coupling. Companies use it for real-time analytics, notification systems, and processing pipelines.

#### Expert Path
Master BigQuery IAM roles by understanding the principle of least privilege - grant minimal permissions required for specific tasks. Learn Pub/Sub advanced features like exactly-once delivery, ordering keys, and attachment schemas for complex use cases.

#### Common Pitfalls
1. **Missing subscriptions:** Messages published without subscriptions get lost if retention periods aren't configured
2. **Long acknowledgment times:** Messages expire if processing takes longer than configured acknowledgment deadlines  
3. **Mixed delivery types:** Using push for batch scenarios or pull for real-time requirements reduces efficiency
4. **Race conditions:** Multiple subscribers processing same messages can cause data inconsistencies if not handled properly

Unexpected findings from the transcript analysis:
- **Role naming inconsistencies:** Some roles like "metadata viewer" provide actual data access despite name suggesting otherwise
- **Resource viewer limitations:** Requires authentication even for public dataset access in command-line usage
- **Regional command-line bugs:** Must specify full region paths when using BQ CLI compared to console interface
- **Service account complexities:** Push subscriptions require careful IAM setup between Pub/Sub and compute services

Try implementing a Pub/Sub pipeline in your cloud environment to solidify these concepts before exam preparation.
