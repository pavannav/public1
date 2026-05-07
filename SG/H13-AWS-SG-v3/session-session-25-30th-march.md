# Session 25: AWS EBS Snapshots, AMIs, and CloudWatch Monitoring

## Table of Contents

- [EBS Snapshots and Storage Tiers](#ebs-snapshots-and-storage-tiers)
- [Archiving and Restoring EBS Snapshots](#archiving-and-restoring-ebs-snapshots)
- [Data Lifecycle Management (DLM)](#data-lifecycle-management-dlm)
- [AWS Backup Service](#aws-backup-service)
- [EC2 Instance Configuration Methods](#ec2-instance-configuration-methods)
- [Creating Custom AMIs](#creating-custom-amis)
- [Sharing and Managing AMIs](#sharing-and-managing-amis)
- [Introduction to CloudWatch](#introduction-to-cloudwatch)
- [CloudWatch Metrics and Monitoring](#cloudwatch-metrics-and-monitoring)
- [Next Steps and Conclusion](#next-steps-and-conclusion)
- [Summary](#summary)

## EBS Snapshots and Storage Tiers

### Overview
AWS Elastic Block Store (EBS) snapshots are point-in-time backups of EBS volumes, stored in Amazon S3. They enable recovery, replication, and cost-efficient archival of data. AWS offers two storage tiers for snapshots: standard (default) and archive.

### Key Concepts
- **Standard Storage Tier**: Used for most workloads, provides low-latency access and fast performance for data retrieval.
- **Archive Storage Tier**: A lower-cost option for long-term storage, suitable for rarely accessed snapshots; retrieval takes several hours.

### Lab Demo: Creating snapshots and managing tiers
1. Select the EBS volume or snapshot in the AWS EC2 console.
2. Click "Actions" > "Create snapshot" to create a backup.
3. Access snapshots via the EC2 console under "Snapshots".

> [!NOTE]
> Snapshots differ from backups created via AWS Backup; EBS snapshots are specifically for EBS volumes.

## Archiving and Restoring EBS Snapshots

### Overview
Archiving EBS snapshots moves them to a lower-cost, long-term storage tier. Archived snapshots can be restored to standard tier when needed, enabling efficient cost management for infrequently accessed data.

### Key Concepts
- **Archiving Process**: Select a snapshot > Actions > Archive snapshot > Confirm archive.
- **Restoration Options**: Temporary restore (for short-term access) or permanent restore to standard tier.
- **Limitations**: Cannot directly create volumes from archived snapshots; must restore first.

### Lab Demo: Archive and Restore Steps
1. **Archive a Snapshot**: Select snapshot > Actions > Archive snapshot > Confirm; status changes to "Archived (Storage state: Archived)".
2. **Restore a Snapshot**: Select archived snapshot > Actions > Restore snapshot from archive > Choose restoration type (e.g., Temporary) > Restore; translates to standard snapshot.

| Feature | Temporary Restore | Permanent Restore |
|---------|------------------|-------------------|
| Duration | Short-term (specify hours/days) | Permanent |
| Cost | Lower for temporary access | Higher for ongoing standard storage |
| Use Case | Occasional access | Frequent future use |

## Data Lifecycle Management (DLM)

### Overview
AWS Data Lifecycle Management (DLM) automates the creation, retention, and deletion of EBS snapshots based on policies. This ensures compliance, cost optimization, and data availability without manual intervention.

### Key Concepts
- **Policy Creation**: Define schedules for snapshot creation, retention rules (e.g., by count or age), and cleanup policies.
- **Target Resources**: Volumes or instances tagged appropriately (e.g., env=prod).
- **Schedules**: Daily, weekly, monthly, or yearly schedules with custom start times.

### Lab Demo: Creating a DLM Policy
1. Go to DLM in AWS console > Create policy > Select EBS snapshot policy.
2. Choose target resource type (Volume) and tag (e.g., env).
3. Configure schedule: Frequency (e.g., daily, every 12 hours), retention (e.g., keep 4 snapshots), starting time.
4. Once created, policy auto-applies to matching resources.

## AWS Backup Service

### Overview
AWS Backup is a managed service for centralizing backup operations across AWS resources like EBS, EFS, and RDS. It simplifies backup scheduling, retention, and restoration with multi-account and multi-region support.

### Key Concepts
- **Backup Vaults**: Stores backups securely.
- **Backup Plans**: Define schedules, retention, and resources (e.g., EBS volumes).
- **Integration**: Works with EBS snapshots but provides broader coverage.

### Differences from EBS Snapshots
```diff
- EBS Snapshots: Volume-specific, manual or via DLM
+ AWS Backup: Multi-service, automated centralized management
```

> [!WARNING]
> Ensure resources are tagged for policy application; mismanaged backups can lead to high costs.

## EC2 Instance Configuration Methods

### Overview
Configuring EC2 instances post-launch can be time-consuming. AWS provides methods like user data, System Manager, and AMIs for automated customization.

### Key Concepts
- **Manual Configuration**: Direct instance updates; slowest for large deployments.
- **AWS Systems Manager**: Run commands and patches remotely.
- **User Data**: Scripts executed on launch for software installation.
- **AMI**: Pre-configured images for instant deployment.

| Method | Pros | Cons |
|--------|------|------|
| Manual | Flexible | Time-intensive, error-prone |
| Systems Manager | Remote management | Requires agent |
| User Data | Auto-configures on launch | Limited to startup |
| AMI | Fast launching | Requires AMI creation |

## Creating Custom AMIs

### Overview
Amazon Machine Images (AMIs) are pre-built virtual machine templates for launching EC2 instances. Custom AMIs include specific configurations, software, and settings.

### Key Concepts
- **AMI Benefits**: Reusable, standardized environment; faster launches than manual config.
- **Types**: Public, shared, custom; created from running instances or snapshots.

### Lab Demo: Create a Custom AMI
1. Launch an EC2 instance (e.g., from existing AMI).
2. Install/configure required software.
3. Instance > Actions > Image and templates > Create image.
4. Provide name, description; enable/disable reboot (e.g., "No Reboot" for consistency).
5. Create; appears in "My AMIs" section.

### Creating AMIs from Snapshots
- Select EBS snapshot > Actions > Create image > Add details.

> [!IMPORTANT]
> Use "No Reboot" to maintain instance state during AMI creation.

## Sharing and Managing AMIs

### Overview
Share custom AMIs across accounts or regions for collaboration and deployment scalability. This supports multi-account setups and global distribution.

### Key Concepts
- **Sharing AMIs**: Add AWS account IDs for permission.
- **Copying AMIs**: Replicate between regions for latency reduction.
- **Ownership**: Shared AMIs require account acceptance.

### Lab Demo: Share and Copy AMI
1. Select AMI > Actions > Modify permissions > Add account IDs > Save.
2. For copying: Select AMI > Actions > Copy AMI > Choose destination region > Copy.

| Action | Steps | Notes |
|--------|-------|-------|
| Share | Modifications > Permissions > Add IDs | Requires acceptance in target account |
| Copy | Actions > Copy AMI | Independent copies, not linked |

## Introduction to CloudWatch

### Overview
AWS CloudWatch is a comprehensive monitoring service for AWS resources, applications, and infrastructure. It collects metrics, logs, and events to provide insights, automation, and troubleshooting capabilities.

### Key Concepts
- **Core Capabilities**:
  - **Events**: Track API calls and resource changes; automate responses.
  - **Metrics**: Performance data (e.g., CPU utilization); visualized in graphs.
  - **Logs**: Application and system logs for analysis.
- **Difference from CloudTrail**:
  - CloudTrail: User activity and account auditing (e.g., login times).
  - CloudWatch: Resource monitoring and automation (e.g., instance performance).

### Diff Between Services
```diff
- CloudTrail: Focuses on "who did what" for security auditing
+ CloudWatch: Focuses on "what is the state" for performance monitoring and automation
```

## CloudWatch Metrics and Monitoring

### Overview
Metrics are time-series data points (e.g., CPU usage) collected from resources. CloudWatch generates visualizations and enables automation via alarms.

### Key Concepts
- **Default Metrics**: CPU, network, disk IO (captured every 5 minutes).
- **Detailed Monitoring**: Per-minute metrics for real-time visibility (extra cost).
- **Graphs and Dashboards**: Auto-generated time-series charts; customizable periods (e.g., 1 hour to 1 week).

### Lab Demo: Viewing Metrics
1. Go to CloudWatch > Metrics > EC2 > Per-Instance Metrics.
2. Select metric (e.g., CPUUtilization) > View graph.
3. Customize: Change time range, set auto-refresh, or create alarms.

> [!NOTE]
> Memory metrics not included by default; requires custom setup for monitoring RAM.

### Free Tier and Costs
- Basic monitoring: Free (5-minute intervals).
- Detailed monitoring: Charged per resource.

## Next Steps and Conclusion

### Overview
This session covered storage management, instance configuration, and monitoring essentials. Future sessions will delve deeper into custom metrics, alarms, and logs.

### Key Concepts
- **Motivations**: Continue revising concepts, motivate others, and prepare for advanced topics like custom monitoring.
- **Program Conclusion**: This session concludes the AWS Enablement Program; certificates and next phases (e.g., cloud creation in future workshops) forthcoming.

> [!TIP]
> Revise EBS, AMIs, and CloudWatch; practice hands-on in AWS console.

## Summary

### Key Takeaways
```diff
+ EBS Snapshots stored in S3; use standard for frequent access, archive for long-term cost savings.
+ DLM automates snapshot lifecycle; AWS Backup centralizes multi-service backups for scalability.
- AMI creation saves time on instance configuration; share/copy for collaboration, but protect sensitive AMIs.
! CloudWatch enables proactive monitoring via metrics/alarms; differentiate from CloudTrail for auditing.
```

### Quick Reference
- **Archive Snapshot**: Actions > Archive snapshot > Restore via temporary/permanent type.
- **DLM Policy**: Create policy > Set schedule/retention > Tag targets.
- **AMI Creation**: Instance > Actions > Image and templates > Create image.
- **CloudWatch Metrics**: EC2 console tab or CloudWatch service for detailed graphs.
- **Certificate Process**: Follow team updates in respective groups.

### Expert Insight
**Real-world Application**: Use AMI versioning for DevOps pipelines; integrate CloudWatch alarms with Auto Scaling for auto-healing infrastructure—critical for production uptime.

**Expert Path**: Master CloudWatch alarms and logs; combine with CloudTrail for full-stack security monitoring. Experiment with custom metrics for application-specific KPIs.

**Common Pitfalls**: Forgetting to archive old snapshots leads to rising costs; not enabling detailed monitoring misses real-time issues. Avoid sharing AMIs without permissions checks.

**Lesser-Known Facts**: Snapshots support incremental backups, reducing storage costs; CloudWatch can integrate with custom applications via SDKs for bespoke dashboards.
