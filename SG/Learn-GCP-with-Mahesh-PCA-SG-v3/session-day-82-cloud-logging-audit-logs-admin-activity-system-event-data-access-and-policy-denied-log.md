`Session 82: Cloud Logging, Audit Logs - Admin Activity, System Event, Data Access and Policy Denied Log`

## Table of Contents
- [Kota-Based Alerting for Resource Quotas](#kota-based-alerting-for-resource-quotas)
- [Admin Activity Logs](#admin-activity-logs)
- [System Event Logs](#system-event-logs)
- [Audit Logs Types Comparison](#audit-logs-types-comparison)
- [Log Storage and Retention](#log-storage-and-retention)
- [Log Querying and Analysis](#log-querying-and-analysis)
- [Google Cloud AI Companion for Log Analysis](#google-cloud-ai-companion-for-log-analysis)

## Kota-Based Alerting for Resource Quotas

### Overview
Cloud Monitoring enables philosophically automated alerting for resource quota exceedances. This provides proactive notification before reaching critical limits, allowing for timely intervention through programmatic quota increases via automation frameworks.

### Key Concepts / Deep Dive
Quota-based alerting uses Prometheus Query Language (PromQL) to monitor resource utilization percentages. The monitoring system triggers notifications when thresholds are breached, integrating seamlessly with existing alerting infrastructure.

#### Alerting Configuration for Resource Quotas
Organizations can create customized alerts for specific resources:
- Configure percentage-based thresholds (e.g., 80% of quota as warning)
- Use notification channels including email, Slack, SMS, and Pub/Sub
- Integrate automated quota expansion scripts

#### Use Cases and Automations
> [!IMPORTANT]
> Kota alerting provides programmatic control through Pub/Sub notifications, enabling automated infrastructure scaling and operational efficiency.

#### Lab Demos

1. **Create Kota-Based Alert Policy**:
   - Navigate to IAM & Admin → Quotas
   - Select specific resource (e.g., VPC networks)
   - Click "⋮ → Create Usage Alert"
   - Configure notification channels including Pub/Sub topics

   ```bash
   # Example quota alert creation (via GCP Console)
   # Resource: Compute Engine networks (VPCs)
   # Threshold: 80% of 5 VPC quota = Alert when 4 VPCs used
   ```

2. **Pub/Sub Integration for Automation**:
   - Configure alerting policy with Pub/Sub as notification channel
   - Implement Cloud Functions or Cloud Run services to process alerts
   - Automate quota increases using Cloud Billing APIs

   ```yaml
   # Example Pub/Sub triggered function
   main:
     runtime: python310
     source: src/

   # Function logic pseudocode:
   # 1. Parse Pub/Sub message for quota details
   # 2. Verify quota thresholds
   # 3. Programmatically increase quota limits
   # 4. Handle errors and retry logic
   ```

3. **Verification and Monitoring**:
   - Monitor incident creation in Cloud Monitoring
   - Verify email/Slack notifications
   - Check auto-recovery after quota increase

   ```diff
   + Successful alert trigger: Email received at 80% quota utilization
   - Common issue: 7-minute delay between quota breach and alert
   ! Expected behavior: Some monitoring lag in quota detection
   ```

## Admin Activity Logs

### Overview
Admin Activity logs capture all administrative operations performed on Google Cloud resources. These logs record who performed what actions when, providing complete audit trails for security, compliance, and troubleshooting purposes.

### Key Concepts / Deep Dive

#### Log Content and Information
Admin Activity logs include:
- **Creation/Deletion/Modification** of all Google Cloud resources
- **IAM Policy Changes** (grants, revokes, role assignments)
- **Service Account Operations** (key rotations, permission changes)
- **Network Configuration Changes** (VPC, firewall rules)

#### Key Characteristics
```diff
+ Completely free and enabled by default
+ 400 days retention period (approximately 13 months)
+ Cannot be disabled or modified
+ Multicloud monitoring support (GCP + AWS)
! Single source of truth for administrative actions
```

### Lab Demos

1. **Query Admin Activity Logs in Logs Explorer**:
   ```bash
   # Query for recent administrative activities
   resource.type="gce_instance"
   protoPayload.methodName:("compute.instances.insert" OR "compute.instances.delete")
   timestamp >= "2024-06-01T00:00:00Z"
   ```

2. **Filter by User Actions**:
   ```bash
   # Find activities by specific user
   protoPayload.authenticationInfo.principalEmail="user@domain.com"
   resource.type="gce_instance"
   timestamp >= "2024-06-01T00:00:00Z"
   ```

3. **Service Account Key Operations**:
   ```bash
   # Monitor service account key creations
   protoPayload.methodName="google.iam.admin.v1.CreateServiceAccountKey"
   protoPayload.authenticationInfo.principalEmail!=""
   ```

4. **Retention Period Verification**:
   - Query logs from 400+ days ago (should return no results)
   - Verify 13-month maximum retention

   ```diff
   + Verification: Admin Activity logs older than 400 days not accessible
   - Issue: Cannot retrieve historical data beyond retention period
   ```

## System Event Logs

### Overview
System Event logs capture automated actions performed by Google Cloud infrastructure itself. Unlike Admin Activity logs that record user/service account actions, these logs document system-level operations for resource management and maintenance.

### Key Concepts / Deep Dive

#### System Event Types
Common system operations logged:
- **VM Preemption**: Spot instances terminated for resource reclamation
- **Live Migration**: VMs moved between physical hosts during maintenance
- **Auto-scaling Events**: Instance group scaling operations
- **Automatic Backups**: Scheduled backup operations
- **Resource Repairs**: Failed instance recreation attempts

#### Log Characteristics
```diff
- Free and automatically enabled
- Less frequent than Admin Activity logs
- Primarily informational for operational visibility
- Limited to Google Cloud resources (excludes third-party)
```

### Lab Demos

1. **Query System Event Logs**:
   ```bash
   # Search for system events
   logName="projects/PROJECT_ID/logs/cloudaudit.googleapis.com%2Fsystem_event"
   protoPayload.methodName:("compute.instances.preempted" OR "compute.instances.migrateOnHostMaintenance")
   ```

2. **VM Preemption Monitoring**:
   ```bash
   # Monitor spot instance preemptions
   resource.type="gce_instance"
   protoPayload.methodName="compute.instances.preempted"
   labels.instance_name:"spot-instance-*"
   ```

3. **Maintenance Migration Tracking**:
   ```bash
   # Track live migrations during host maintenance
   resource.type="gce_instance"
   protoPayload.methodName="compute.instances.migrateOnHostMaintenance"
   timestamp >= "2024-06-01T00:00:00Z"
   ```

4. **Log Filtering and Exclusion**:
   - Exclude noisy logs (Cloud Run deployments, BigQuery cache expiry)
   - Focus on critical system events
   - Use log exclusion filters for cleaner views

   ```bash
   # Exclude Cloud Run deployment logs
   NOT resource.labels.service_name:"*"
   logName="projects/PROJECT_ID/logs/cloudaudit.googleapis.com%2Fsystem_event"
   ```

## Audit Logs Types Comparison

### Overview
Google Cloud provides four types of audit logs serving different monitoring and compliance needs. Understanding the distinctions helps organizations implement appropriate security monitoring strategies.

### Key Concepts / Deep Dive

| Log Type | Content | Free | Retention | Use Case |
|----------|---------|------|-----------|----------|
| Admin Activity | User/Service Account Actions | ✅ Yes | 400 days | Security Audit, Compliance |
| System Event | Google Infrastructure Actions | ✅ Yes | 400 days | Operational Monitoring |
| Data Access | API Calls and Data Operations | ❌ No (part of Logging quota) | Configurable (up to 10 years) | Security Investigation, Forensics |
| Policy Denied | Access Denials | ❌ No (part of Logging quota) | Configurable (up to 10 years) | Security Monitoring, Troubleshooting |

### Data Access Logs
```diff
+ Captures successful API operations
+ Enables detailed security investigation
+ Separately enabled (disabled by default)
- Not free (counts toward Logging quota)
! Critical for PCI DSS, HIPAA compliance
```

### Policy Denied Logs
```diff
+ Records access denial events
+ Helps identify authorization issues
+ Separately enabled (disabled by default)
- Not free (counts toward Logging quota)
! Essential for security incident response
```

## Log Storage and Retention

### Overview
Cloud Logging provides flexible storage options with different retention policies. Organizations can choose between free system-managed buckets and custom logging buckets with extended retention.

### Key Concepts / Deep Dive

#### Default Log Buckets
- **`_Default`**: Catch-all bucket for logs not routed elsewhere
- **`_Required`**: Stores Admin Activity and System Event logs
  - Free storage
  - 400 days retention (fixed)
  - Cannot be modified or disabled

#### Custom Log Buckets
```yaml
# Custom logging bucket configuration
name: "custom-audit-logs"
description: "Extended retention for compliance logs"
retentionDays: 3650  # 10 years maximum
location: "global"  # or regional
```

#### Retention Comparison
```diff
+ Free buckets: 400 days (Admin Activity, System Event)
- Custom buckets: Up to 10 years (Data Access, Policy Denied)
! Google Cloud Storage: Unlimited retention possible
```

## Log Querying and Analysis

### Overview
Cloud Logging provides powerful querying capabilities through the Logs Explorer interface. Advanced filtering, time-based queries, and exclusion techniques enable efficient log analysis.

### Key Concepts / Deep Dive

#### Query Techniques
- **Time-based Filtering**: Use relative timestamps (`10m`, `24h`, `30d`)
- **Resource Filtering**: Target specific resource types
- **Exclusion Filters**: Remove noisy log entries
- **Advanced Queries**: Combine multiple conditions

#### Log Analysis Workflow
1. Start with broad queries to understand log volume
2. Apply exclusions to reduce noise
3. Refine queries for specific investigations
4. Save frequently used queries for reuse
5. Export large result sets to BigQuery or Cloud Storage

### Lab Demos

1. **Basic Log Queries**:
   ```bash
   # Find all VM-related activities in last hour
   resource.type="gce_instance"
   timestamp >= "2024-12-01T00:00:00Z"
   ```

2. **Exclusion Patterns**:
   ```bash
   # Exclude BigQuery cache expiry logs
   NOT protoPayload.methodName="google.cloud.bigquery.v2.JobService.InsertJob"
   NOT textPayload:"Query results cache"
   ```

3. **Saved Query Management**:
   - Create saved queries for common investigations
   - Use query library for team sharing
   - Leverage recent query history

4. **Log Export Options**:
   ```bash
   # Export to BigQuery for analysis
   gcloud logging sinks create my-export-sink \
     bigquery.googleapis.com/projects/PROJECT_ID/datasets/LOG_DATASET \
     --log-filter='resource.type="gce_instance"'
   ```

## Google Cloud AI Companion for Log Analysis

### Overview
Google Cloud AI Companion (Gemini) provides natural language log analysis capabilities. This AI-powered feature explains complex log entries in plain English, reducing troubleshooting time.

### Key Concepts / Deep Dive

#### AI Companion Features
- **Log Explanation**: Contextual analysis of log entries
- **Multi-step Analysis**: Follow-up questions for deeper investigation
- **Security Focus**: Maintains data privacy while providing insights

#### Prerequisites
```yaml
# Required API activation
api: cloudaicompanion.googleapis.com
status: ENABLED
authentication: OAuth 2.0
```

#### Usage Examples
> [!NOTE]
> "Explain this log entry" analysis reveals Kota exceeded errors, access denial patterns, and operational insights in human-readable format.

### Lab Demos

1. **Enable AI Companion**:
   ```bash
   gcloud services enable cloudaicompanion.googleapis.com
   ```

2. **Log Analysis Workflow**:
   - Locate suspicious log entry
   - Click "Explain this log entry"
   - Follow up with specific questions about the event

3. **Advanced Queries**:
   ```bash
   # Ask context-specific questions
   "Who initiated this API call?"
   "What caused this error?"
   "Is this part of normal operation?"
   ```

## Summary

### Key Takeaways
```diff
+ Admin Activity logs provide free, 400-day audit trails of user actions
- System Event logs are automatically generated but less comprehensive than Admin Activity logs
! Data Access and Policy Denied logs require separate activation and incur charges
+ Custom log buckets support up to 10 years retention for compliance needs
- Multicloud monitoring includes AWS resources but logging is GCP-only for AWS
+ AI Companion enables natural language log analysis
- 7-minute delay observed in quota-based alerts
```

### Quick Reference
```bash
# Admin Activity logs query
logName="projects/PROJECT/logs/cloudaudit.googleapis.com%2Factivity"

# System Event logs query
logName="projects/PROJECT/logs/cloudaudit.googleapis.com%2Fsystem_event"

# Data Access logs (when enabled)
logName="projects/PROJECT/logs/cloudaudit.googleapis.com%2Fdata_access"

# Enable AI Companion API
gcloud services enable cloudaicompanion.googleapis.com
```

### Expert Insight
#### Real-world Application
Kota-based alerting with Pub/Sub integration enables fully automated infrastructure scaling, reducing manual intervention in production environments. Organizations use this pattern for auto-scaling quotas during peak business hours and automated remediation of access issues.

#### Expert Path
Master Cloud Logging by combining multiple log types in sophisticated monitoring dashboards. Implement custom log-based metrics for proactive issue detection, and leverage BigQuery for large-scale log analysis with SQL queries across months of historical data.

#### Common Pitfalls
- Assuming Admin Activity covers all audit needs (missing Data Access logs)
- Not accounting for the 7-minute alert delay in quota monitoring
- Overlooking service account acting-as permissions for Cloud Run deployments
- Ignoring noisy system logs without proper exclusion filters

#### Lesser-Known Facts
- Live VM migrations during host maintenance are logged as system events
- Service account key operations appear in Admin Activity logs
- AI Companion uses the same Gemini technology as other Google AI products
- Preemptible instance terminations generate distinct log patterns from regular VM deletions

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
KK-CS45-V3
