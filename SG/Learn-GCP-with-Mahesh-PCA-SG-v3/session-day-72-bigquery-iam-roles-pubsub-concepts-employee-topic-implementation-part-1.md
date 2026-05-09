# Session 72: BigQuery IAM Roles, PubSub Concepts, Employee Topic Implementation Part 1

## Overview

This session explores advanced BigQuery IAM roles for modern data workflows, introduces Pub/Sub messaging concepts with fan-in/fan-out patterns, and demonstrates an employee topic implementation using various subscription mechanisms and delivery modes.

## BigQuery IAM Roles

### Key Concepts
BigQuery IAM roles have expanded significantly:

#### Connection Admin Role
- Purpose: Manage connections to external data sources for federated queries
- Use cases: Query data in Cloud SQL, Spanner, or BigTable without moving data
- Supported databases: Cloud SQL (MySQL, Postgres), Spanner, AlloyDB
- Complementary: Connection User role for viewing connections

#### Resource Admin Role  
- Permissions: `bigquery.jobs.listAll` to view all executed queries/jobs
- Critical for: Auditing, cost tracking, identifying rogue queries
- Access methods: 
  - UI: Job History section (bottom left)
  - CLI: `bq ls -j -a`, `bq show --format=prettyjson <job_id>`

#### Session Reader Role
- Enables BigQuery Storage Read API for high-performance data access
- Performance benefits: Lower latency than legacy query API  
- Typical combination: Session User + Data Viewer roles
- Guarantees: At-least-once delivery (may include duplicates)

#### Additional Roles
- **Data Policy Roles**: Admin/Viewer for data masking, row-level access policies
- **Filtered Data Viewer**: Row-level filtering (e.g., `WHERE department_id = 1`)
- **Studio Admin**: Combines BigQuery, Dataflow, Notebook admin roles (use cautiously)
- **Legacy Roles**: Editor, Owner, Metadata Viewer, Data Viewer, etc.

#### Real-World Exam Concept: Shared Billing vs Data Access
```
User with BigQuery Job User (Billing Project) + Data Viewer (Data Projects)
→ Can query data but costs charged to Billing Project
→ Data security maintained across separate projects
```

### Lab Demos
#### Partition Expiry Verification
```bash
# Check expired partitions (no data retained)
SELECT * FROM <dataset>.<table> WHERE partition_id IS NULL;
```

#### Query Auditing Commands
```bash
# List all jobs with full details
bq ls -j -a

# Show specific job details  
bq show --format=prettyjson <project>:<region>.<job_id>
```

#### Role Demonstration
1. Grant BigQuery Resource Viewer to simple GCP user
2. User can view all project job histories in UI
3. Cost visibility via bytes processed metrics

## PubSub Concepts

### Key Concepts

#### Core Architecture
- **Global, Serverless**: Handles millions of messages/second with 99.99% availability
- **Component Roles**: Producers publish to topics, consumers subscribe and process
- **Message Format**: Up to 10MB textual data + attributes (key-value metadata)
- **Decoupling Benefit**: Producers unaware of consumers, and vice versa

#### Delivery Patterns
- **Fan-In**: Multiple producers → single topic → aggregated processing
- **Fan-Out**: Single topic → multiple subscriptions → parallel processing  
- **Filtering**: Attribute-based routing (e.g., `employee_type=F`)

#### Delivery Modes
- **Pull**: Subscribers manually poll/consume (good for batch processes)
- **Push**: Instant delivery via HTTP webhook (real-time, but can overload)

#### Practical Value
Example: CoWIN crash scenario
```
Traditional: Users → Direct App → Crash at 100x loads
Pub/Sub: Users → Queue → Backend processes in controlled batches → No crash
```

### Code/Code Config Blocks
#### Message Types Examples
```javascript
// JSON payload
{
  "employee_name": "User 1", 
  "department": 1,
  "start_date": "2025-06-08"
}
```

```csv
// CSV payload
User 2,2,2025-06-08
```

```bash
# Base64 image payload (encoded file content)
data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQ...
```

## Employee Topic Implementation Part 1

### Key Concepts

#### Topic Creation
- Global resource (no region selection needed)
- Messages retained: 7-31 days (configurable)
- Attributes for routing/filtering

#### Subscription Configurations
1. **Pull (Payroll)**: Filtered `employee_type=F`, exponential backoff
2. **Pull (Shared Services)**: No filter, manual processing
3. **Push (IT Services)**: Cloud Run function endpoint, instant processing

#### Deployment Flow
```
Producer (HR Portal) → Publish → Topic (employees) → 
Fan-Out → Payroll Sub (FTE only) + Shared Sub (all) + IT Sub (realtime)
```

### Code/Code Config Blocks
#### GCP CLI Commands
```bash
# Create topic
gcloud pubsub topics create employees --project=<project>

# Publish message with attributes
gcloud pubsub topics publish employees \
  --message='{"name":"John","dept":1}' \
  --attribute=employee_type=F

# Create filtered subscription  
gcloud pubsub subscriptions create payroll-sub \
  --topic=employees \
  --filter="attributes.employee_type:F"

# Pull messages
gcloud pubsub subscriptions pull payroll-sub --auto-ack

# Create push subscription (Cloud Run endpoint)
# 1. Create Cloud Run function with Pub/Sub trigger
# 2. Endpoint auto-configures HTTP webhook
# 3. IAM: Cloud Run Invoker role needed
```

#### Cloud Run Function Code
```python
def hello_pubsub(event, context):
    import base64
    
    pubsub_message = base64.b64decode(event['data']).decode('utf-8')
    print(f'Received: {pubsub_message}')
    
    # Process employee data, send ACK
    return 'Processed'
```

### Demo Flows
#### Pull Mechanism Demo
1. Publish employee messages (mixed FTE/contractor attributes)
2. Verify messages appear only in matching subscriptions
3. Acknowledge messages (removes from topic after all subscribers process)

#### Push Mechanism Demo  
1. Cloud Run function triggered instantly on publish
2. Logs show processing within ~100ms
3. Handles real-time employee onboarding (email/laptop allocation)

### Tables
#### Delivery Mode Comparison

| Feature | Pull Mode | Push Mode |
|---------|-----------|-----------|
| Latency | Seconds/minutes | Milliseconds |
| Control | Subscriber polled | Topic-driven |
| Scaling | Manual load balance | Auto-distributed |
| Use Case | Batch processing | Real-time alerts |
| Risk | Message backlog | Consumer overload |

#### IAM Roles Comparison  

| Scenario | Role Combination | Billing | Data Access |
|----------|------------------|---------|-------------|
| Isolated Projects | Job User (billing) + Data Viewer (data) | Centralized | Segmented |
| Public Dataset | Job User | User project | Public data |
| Admin Oversight | Resource Admin | Full visibility | Admin access |

## Summary

### Key Takeaways
```diff
+ IAM roles enable secure, granular BigQuery access for federated queries and auditing
+ Pub/Sub provides robust decoupling for high-throughput data processing
- Over-assigning broad roles risks security/cost issues  
! Push delivery offers low latency but requires scaled consumers
```

### Quick Reference
- **Key Commands**: `bq ls -j -a`, `gcloud pubsub topics publish`, `gcloud pubsub subscriptions pull`
- **Essential Roles**: Job User, Data Viewer, Resource Admin  
- **Pub/Sub Limits**: 10MB messages, 31 days retention, 1M+ msg/sec throughput

### Expert Insight
#### Real-world Application
Implement Pub/Sub in GCP ecosystems for real-time billing alerts, real-time analytics (via Dataflow → BigQuery), or decoupled microservice architectures. Use subscription filtering to route messages based on priority or region for sophisticated event-driven systems.

#### Expert Path
Build complete pipelines: producers (GCS triggers), topics (with retention), mixed pull/push subscriptions with filtering. Master advanced features like dead-letter queues and message ordering. Focus on architecture patterns for high-availability distributed systems.

#### Common Pitfalls
- Data size violations (10MB limit) - use compression/chunking
- IAM gaps - push endpoints need invoker roles
- Duplicate handling - implement deduplication logic for at-least-once delivery
- Push overload - test consumer scaling under load

#### Lesser-Known Facts
- Pub/Sub retains messages indefinitely if competing subscriptions exist
- Integrates natively with GCP monitoring for observable debugging
- Global replication handles datacenter failures transparently

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
