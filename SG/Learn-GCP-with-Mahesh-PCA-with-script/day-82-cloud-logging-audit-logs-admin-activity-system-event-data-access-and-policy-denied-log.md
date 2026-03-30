# Session 82: Cloud Logging, Audit Logs

## Table of Contents
- [Overview](#overview)
- [Admin Activity Logs](#admin-activity-logs)
- [System Event Logs](#system-event-logs)
- [Data Access Logs](#data-access-logs)
- [Policy Denied Logs](#policy-denied-logs)
- [Summary](#summary)

## Overview
Cloud Logging is a service in Google Cloud Platform (GCP) that centralizes logs from various services, allowing centralized monitoring and auditing. It supports structured logging and integration with other GCP services. Audit logs are a specific type within Cloud Logging focused on security and compliance, capturing who did what and when for administrative actions. These include:

- **Admin Activity Logs**: Capture creation, deletion, and modification of resources.
- **System Event Logs**: Capture actions performed by Google Cloud services (e.g., maintenance, auto-scaling).
- **Data Access Logs**: Capture access to data (e.g., BigQuery table reads/writes).
- **Policy Denied Logs**: Capture denied access attempts due to insufficient permissions.

Audit logs are enabled by default, free for admin activity (up to 400 days retention), and essential for compliance and security audits.

## Admin Activity Logs
Admin Activity Logs record all administrative actions on GCP resources, such as creating or deleting VMs, setting IAM policies, and modifying configurations. They are always enabled, free, and retained for 400 days.

### Key Concepts
- **Purpose**: Track changes to GCP resources for auditing and debugging.
- **Retention**: 400 days (13 months), after which logs rotate out.
- **Source**: Stored in the `_Required` Cloud Logging bucket.
- **Querying**: Use Cloud Logging Explorer with filters like `logName="projects/[PROJECT_ID]/logs/cloudaudit.googleapis.com%2Factivity"`.

### Examples
- Creating a VPC: Logged with user email and timestamp.
- Setting IAM policies: Captures role grants/revokes.

> [!IMPORTANT]
> Admin Activity Logs cannot be disabled or modified.

### Lab Demo: Querying Admin Activity Logs
To query logs for the last 10 minutes of admin activity:

```bash
# In GCP Console, go to Cloud Logging > Logs Explorer
# Create a filter:
logName="projects/[PROJECT_ID]/logs/cloudaudit.googleapis.com%2Factivity"
- Look for events like VPC creation or VM deletion in the results.
```

For deeper insight, use the "Explain this log entry" feature (requires Cloud AI Companion API enabled).

## System Event Logs
System Event Logs capture actions performed by GCP itself, not users or services. Examples include VM preemptions, subnet additions in default VPC, and scheduled backups.

### Key Concepts
- **Purpose**: Monitor automated GCP processes for operational visibility.
- **Retention**: Same 400 days as admin activity logs.
- **Source**: Also in the `_Required` bucket.
- **Querying**: Filter for `logName="projects/[PROJECT_ID]/logs/cloudaudit.googleapis.com%2Fsystem_event"`.

### Examples
- VM live migration due to maintenance.
- Cloud Run service deployment updates.
- Automatic backup creations (e.g., Cloud SQL).

> [!NOTE]
> These logs help identify why a resource behaved unexpectedly, like a preemption or repair.

### Lab Demo: Filtering System Event Logs
1. In Logs Explorer, apply filter:
   ```
   logName="projects/[PROJECT_ID]/logs/cloudaudit.googleapis.com%2Fsystem_event"
   ```
2. Exclude noise: Click on unwanted lines (e.g., Cloud Run deployment logs) and select "Hide matching entries."
3. Drill down to key events like VM preemptions or maintenance migrations.

Example log structure (JSON excerpt):
```json
{
  "logName": "projects/myproject/logs/cloudaudit.googleapis.com%2Fsystem_event",
  "resource": {"type": "gce_instance", "labels": {"instance_id": "123456"}},
  "protoPayload": {
    "methodName": "v1.compute.instances.preempted",
    "serviceName": "compute.googleapis.com"
  }
}
```

## Data Access Logs
Data Access Logs capture reads, writes, and modifications to sensitive data, such as BigQuery queries or Cloud Storage operations. They are disabled by default due to volume and cost.

### Key Concepts
- **Purpose**: Audit data access for compliance (e.g., GDPR, HIPAA).
- **Retention**: Same 400 days, but can be extended to custom logging buckets.
- **Enabling**: Must be explicitly turned on; they generate high volume.
- **Source**: In the same `_Required` bucket if enabled.

### Examples
- BigQuery table scans.
- Cloud Storage object downloads.

> [!WARNING]
> Enabling these can incur costs exceeding 50 GB/month free tier.

## Policy Denied Logs
Policy Denied Logs capture IAM policy violations, such as access denials due to insufficient permissions.

### Key Concepts
- **Purpose**: Identify failed access attempts for security hardening.
- **Retention**: 400 days.
- **Source**: Same as other audit logs.

### Examples
- A user attempting to create a resource without proper roles.

> [!IMPORTANT]
> These logs do not prevent access but help diagnose IAM issues.

## Summary

### Key Takeaways
+ Cloud Logging centralizes all GCP logs, with audit logs focusing on security and admin actions.
- Admin Activity Logs: Free, always enabled, 400-day retention for resource changes.
- System Event Logs: GCP-performed actions, helps with issues like preemptions.
- Data Access and Policy Denied Logs: Optional, high-volume, for data security.
- Use Cloud Logging Explorer with filters and AI explanations for analysis.

### Expert Insight
**Real-world Application**: In production, use these logs for compliance audits or incident response. For example, if a VM is deleted unexpectedly, query admin activity logs to see who deleted it within the 400-day window.

**Expert Path**: Master querying with advanced filters and export to BigQuery for analytics. Enable data access logs selectively on sensitive datasets.

**Common Pitfalls**: 
- Assuming all logs are always retained; remember 400-day limit.
- Overlooking API enablement for features like log explanations.
- Ignoring costs for data access logs if enabled broadly.

Issues with resolution:
- High log volume: Use filters or export to storage/BigQuery.
- Retention needs: Create custom logging buckets with up to 10-year retention.

Lesser known: Logs can be routed to pub/sub for real-time alerting on specific events.
