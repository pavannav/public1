# Section 20: AWS Monitoring and Management Tools

<details open>
<summary><b>Section 20: AWS Monitoring and Management Tools (CL-KK-Terminal)</b></summary>

## Table of Contents
- [20.1 AWS Config (Hands-On)](#201-aws-config-hands-on)
- [20.2 AWS CloudTrail (Hands-On)](#202-aws-cloudtrail-hands-on)
- [20.3 AWS CloudWatch Part-1 (Hands-On)](#203-aws-cloudwatch-part-1-hands-on)
- [20.4 AWS CloudWatch Part-2 (Hands-On)](#204-aws-cloudwatch-part-2-hands-on)
- [20.5 AWS CloudWatch Part-3 (Hands-On)](#205-aws-cloudwatch-part-3-hands-on)
- [20.6 Config Vs CloudTrail](#206-config-vs-cloudtrail)
- [20.7 CloudTrail vs CloudWatch](#207-cloudtrail-vs-cloudwatch)
- [20.8 Amazon Inspector Part-1 (Hands-On)](#208-amazon-inspector-part-1-hands-on)
- [20.9 Amazon Inspector Part-2 (Hands-On)](#209-amazon-inspector-part-2-hands-on)
- [20.10 AWS Trusted Advisor](#2010-aws-trusted-advisor)
- [20.11 Amazon Inspector VS AWS Trusted Advisor](#2011-amazon-inspector-vs-aws-trusted-advisor)

## 20.1 AWS Config (Hands-On)

### Overview
AWS Config provides a detailed view of the configuration of AWS resources in your account, enabling auditing, compliance checks, and troubleshooting of configuration changes. It records the state of resources and tracks modifications over time, helping identify non-compliant setups such as unencrypted EBS volumes or unused elastic IPs.

### Key Concepts/Deep Dive
AWS Config continuously records resource configurations and lets you assess compliance against defined rules. It supports over 35 managed rules for automated checks, like ensuring EBS volumes are encrypted or elastic IPs are attached. Custom rules can be created for specific needs, and conformance packs deploy rules across multiple accounts in AWS Organizations.

Resources are stored in an S3 bucket for long-term access. Config integrates with CloudTrail for additional event insights and supports relationship mapping between resources, such as EC2 instances and their security groups.

#### Use Cases:
- **Resource Inventory**: Snapshot and track all resources, aiding in account cleanup.
- **Compliance Auditing**: Flag deviations from best practices, like missing encryption.
- **Change Management**: Troubleshoot issues by viewing historical configurations (e.g., instance type changes from T2.micro to T2.large).

#### Assessment Template Targets:
By default, records all resources but can be customized to specific resource types or tagged instances.

### Lab Demo: Setting Up AWS Config
1. Navigate to AWS Config console.
2. Click "Get Started" to enable recording.
3. Select "Record all resources supported in this region" and choose/create an S3 bucket for logs.
4. Enable SNS notifications by creating a topic (e.g., "config-topic") and subscribe via email.
5. Confirm subscription in your email.
6. View resources in the dashboard to see inventory.

### Lab Demo: Viewing Configurations and Relationships
1. In Config console, select a resource (e.g., EC2 instance).
2. Review configuration details and timeline for changes.
3. Modify a security group and refresh to see new field changes.
4. Configure rules: Go to "Rules" → "Add Rule" → Select "Check EBS Encryption" or "IP Address Check".
5. Re-evaluate rules by selecting and clicking "Re-evaluate".
6. View non-compliant resources in the dashboard.

### Lab Demo: Conformance Packs
Conformance packs bundle AWS Config rules for cross-account deployment, useful in AWS Organizations. Select from templates like "Operational Best Practices for S3" in the redesigned console.

## 20.2 AWS CloudTrail (Hands-On)

### Overview
AWS CloudTrail records API calls and account activity for governance, compliance, and risk auditing. It logs actions taken via the AWS console, CLI, SDKs, or APIs, focusing on what was done, by whom, when, and from where, making it essential for security and troubleshooting.

### Key Concepts/Deep Dive
CloudTrail is enabled by default on account creation and stores events in the CloudTrail console for the past 90 days. For archiving, create a trail to deliver encrypted logs to an S3 bucket.

#### Key Features:
- **Event History**: Free access to recent events; search and download.
- **Trails**: Configuration for ongoing log delivery; includes validation to detect log tampering using SHA-256 and RSA algorithms.
- **Encryption**: Server-side encryption by default (SSE-S3); optional KMS for higher security.
- **Integration**: Deliver to CloudWatch Logs and EventBridge for further processing.

Events include who performed the action (e.g., IAM user), the action (e.g., terminate instance), and API details. Integrates with Config for resource-centric views.

#### Assessment Template Targets:
Applies to all account activities; can filter by attributes.

### Lab Demo: Viewing Event History
1. Access CloudTrail console → "Event History".
2. Filter by event name, time range, or resource.
3. Search for API calls like "StartInstances" or "TerminateInstances" to track activity.

### Lab Demo: Creating a Trail
1. Go to CloudTrail console → "Trails" → "Create Trail".
2. Name it (e.g., "Trail-1") and create/select S3 bucket.
3. Enable log file validation and optional SNS notifications.
4. Choose read/write events or specific attributes; set to all regions.
5. Create trail; logs will deliver in about 15 minutes.

### Lab Demo: Demonstrating IAM User Tracking
1. Create a new IAM user with limited permissions (e.g., EC2 access).
2. Log in as the user and perform an action (e.g., terminate an instance whose termination you know was denied).
3. Switch back to root view → CloudTrail → Check Event History for the denied action, noting the identity and details.

## 20.3 AWS CloudWatch Part-1 (Hands-On)

### Overview
AWS CloudWatch monitors AWS resources and applications in real-time, providing metrics for optimization, alerting, and performance insights. It helps scale resources appropriately, distinguishing between over-provisioning (waste) and under-provisioning (poor performance).

### Key Concepts/Deep Dive
CloudWatch collects metrics from AWS services and custom applications. Key components: Metrics, Alarms, and Events (via CloudWatch Events, now EventBridge).

#### Metrics:
- Repository of data points (e.g., CPU utilization).
- Basic monitoring: 5-minute intervals (free for EC2).
- Detailed monitoring: 1-minute intervals (paid).
- Custom metrics via CloudWatch Agent for OS-level data (e.g., memory, disk usage on Linux/Windows/Mac).

#### Dashboards:
- Visualize metrics; create custom widgets (lines, bars, numbers).
- Periods: Statistically aggregated data (e.g., average over 5 minutes).

CloudWatch Agent installs via Systems Manager for detailed OS metrics on EC2 or on-premises.

### Lab Demo: Creating a Dashboard and Viewing Metrics
1. Go to CloudWatch console → "Dashboards" → "Create Dashboard".
2. Add widget → Line chart → Metric → EC2 → Per-Instance Metrics → CPUUtilization.
3. Select instance and view average/min/max utilization.

### Lab Demo: Enabling Detail Monitoring
1. Select EC2 instance → Actions → Monitor and Troubleshoot → Manage Detailed Monitoring → Enable (paid feature).

### Lab Demo: Running Stress Test
1. Create VB script to simulate 100% CPU load:
   ```
   While True
   Wend
   ```
2. Save as "cpubusy.vbs"; run it to stress test.
3. Monitor CPU in CloudWatch; note changes over 1-hour periods.

## 20.4 AWS CloudWatch Part-2 (Hands-On)

### Overview
CloudWatch alarms automate responses based on metric thresholds, enabling proactive monitoring without constant oversight. They trigger notifications or actions like stopping instances when metrics breach limits.

### Key Concepts/Deep Dive
Alarms monitor single metrics or math expressions. States: OK, Alarm, Insufficient Data. Actions include EC2 auto-stop/start, SNS emails, or EventBridge rules.

#### Static vs. Dynamic Thresholds:
Generally use static; percentage for scaling.

#### Best Practices:
Set thresholds (e.g., 80% CPU utilization) and periods (e.g., 5 minutes).

### Lab Demo: Creating an Alarm
1. CloudWatch → "Alarms" → "Create Alarm".
2. Select Metric → EC2 → Per-Instance → CPUUtilization.
3. Set Statistic: Average, Period: 5 minutes, Threshold: >80%.
4. Configure Actions: Send SNS notification; create/select topic and subscribe via email.
5. Confirm subscription; name alarm "AL1".
6. Run CPU stress script from Part-1; wait for breach and check email/alert.

## 20.5 AWS CloudWatch Part-3 (Hands-On)

### Overview
Amazon EventBridge (formerly CloudWatch Events) routes system events to targets for automation, responding to changes across AWS resources without manual intervention.

### Key Concepts/Deep Dive
Events indicate AWS resource state changes (e.g., EC2 started/stopped). Patterns match events; rules route to targets like Lambda, SNS, or CloudWatch Logs.

#### Features:
- **Event Patterns**: Define triggers (e.g., S3 object puts).
- **Schedules**: Cron expressions for periodic tasks (e.g., daily EC2 start).
- **Rules**: Multiple targets per rule; process in parallel.

### Lab Demo: Creating Rules for S3 Events
1. CloudWatch → "Events" → "Create Rule" (via EventBridge).
2. Name "S3 Rule"; select "Event Pattern" → Service: S3, Event Type: Object Level → Operations: PutObject and DeleteObject.
3. Specific bucket (e.g., "NewZero1").
4. Add Targets: CloudWatch Logs group.
5. Create Rule.
6. Upload/Delete files in S3; check logs in CloudWatch.

## 20.6 Config Vs CloudTrail

### Overview
Both AWS Config and CloudTrail audit AWS resources, but Config reports on configuration changes (what), while CloudTrail focuses on actions taken (who/what/when/where). Commonalities include governance support, but they complement each other for comprehensive auditing.

### Key Concepts/Deep Dive
- **Config**: Configuration-focused; snapshots and timelines of resource states (e.g., instance upgrades).
- **CloudTrail**: Event-focused; logs API calls, identities, and sources, including failed attempts.
- **Distinction**: Config for "what changed?"; CloudTrail for "why/how?"

## 20.7 CloudTrail vs CloudWatch

### Overview
CloudTrail monitors account activity and API calls, emphasizing security audits (who did what), while CloudWatch observes performance and health (system metrics for optimization).

### Key Concepts/Deep Dive
- **CloudTrail**: Logs events; integrated with Config for context.
- **CloudWatch**: Metrics, alarms, events; proactive alerts and dashboards.
- **Key Diff**: Audit actions vs. monitor resource health.

## 20.8 Amazon Inspector Part-1 (Hands-On)

### Overview
Amazon Inspector automates security assessments for EC2 instances, identifying vulnerabilities, deviations from best practices, and exposer via network scans or host-based checks.

### Key Concepts/Deep Dive
Two types:
- **Network Assessment**: Checks port reachability from VPC exterior (no agent needed).
- **Host Assessment**: Analyzes OS for vulnerabilities (requires agent).

Provides findings with severity levels; integrates EC2 best practices.

#### Use Cases:
Security audits; compliance verification (e.g., CIS benchmarks via host rules).

### Lab Demo: Network Assessment
1. Inspector console → "Get Started" → "Network Assessment".
2. Run assessment; targets all instances by default.
3. View findings: High (e.g., open FTP port), Medium (e.g., RDP open), Low (e.g., HTTP open).

## 20.9 Amazon Inspector Part-2 (Hands-On)

### Overview
Host assessment dives into OS-level issues, requiring agent installation for checks like software vulnerabilities and configuration compliance.

### Key Concepts/Deep Dive
Agent installs via commands or manual downloads. Assessments run for set durations; report downloadable PDFs.

#### Findings Severity:
High/Medium/Low/Informational; focus on remediation.

### Lab Demo: Installing Agent and Running Host Assessment
1. Targets → Install agent via Run Command or download EXE.
2. Verify status in Inspector.
3. Create Assessment Template → Duration: 15 minutes; Packages: Common Vulnerabilities, Security Best Practices.
4. Run assessment; review findings after completion.

## 20.10 AWS Trusted Advisor

### Overview
AWS Trusted Advisor analyzes accounts for cost optimization, performance, security, fault tolerance, and service limits, offering recommendations to improve efficiency and reduce risks.

### Key Concepts/Deep Dive
Categories:
- **Cost Optimization**: Identify unused resources.
- **Performance**: Boost responsiveness.
- **Security**: Check MFA, security groups.
- **Fault Tolerance**: Ensure redundancy.
- **Service Limits**: Monitor usage vs. quotas.

Free basic checks; full access requires Business/Enterprise support.

### Lab Demo: Reviewing Checks
1. Trusted Advisor console.
2. Review categories (e.g., Security checks show MFA/root enabled).
3. Download reports for detailed actions.

## 20.11 Amazon Inspector VS AWS Trusted Advisor

### Overview
Inspector focuses on EC2-specific security/vulnerability scans with agents, while Trusted Advisor provides broader account-wide recommendations for all AWS aspects.

### Key Concepts/Deep Dive
- **Inspector**: Agent-based; EC2-focused; performance-neutral.
- **Advisor**: No agent; account-wide; requires paid support for full features; includes cost/performance insights.

| Aspect | Inspector | Trusted Advisor |
|--------|-----------|-----------------|
| Scope | EC2 instances only | All AWS resources/accounts |
| Agent Required | Yes for host | No |
| Pricing | Free with limits | Requires support plan |
| Focus | Security vulnerabilities | Cost, performance, security, etc. |

## Summary

### Key Takeaways
```diff
+ AWS Config provides configuration auditing and timeline views for compliance troubleshooting.
- CloudTrail tracks API calls and identities for security investigations, complementing Config.
+ CloudWatch enables real-time monitoring, alarms, and events for performance optimization and automation.
- Inspector automates EC2 vulnerability scans, but requires agents for deep OS checks.
+ Trusted Advisor offers holistic account recommendations, especially with paid support.
! Choose tools based on scope: Config/CloudTrail for auditing, CloudWatch for monitoring, Inspector for EC2 security, Advisor for broader business metrics.
```

### Quick Reference
- **AWS Config Setup**: Enable in console, configure S3/SNS, add rules like encryption checks.
- **CloudTrail Trail**: Create trail with SSE/KMS, validate logs, check event history.
- **CloudWatch Alarm**: Select metric → Threshold → SNS action; monitor periods.
- **Inspector Assessment**: Network (agentless); Host (agent-based); review severity findings.
- **Trusted Advisor**: Access core checks free; categories: Cost, Performance, Security, Fault Tolerance, Service Limits.

### Expert Insight
#### Real-World Application
In production AWS environments, pair Config with CloudTrail for full audit trails to meet compliance standards like PCI-DSS. Use CloudWatch for auto-scaling triggers, Inspector for periodic security sweeps, and Trusted Advisor for ongoing cost control—delegating checks to automated workflows prevents human error and reduces downtime.

#### Expert Path
Master these by setting up end-to-end scenarios: Configure a stack with alarms terminating unhealthy instances, rules triggering Config reports on changes, and Inspector scans for vulnerabilities. Integrate with EventBridge for automated responses, treating logs as forensic data.

#### Common Pitfalls
- Forgetting to delete unused trails/rules, leading to unexpected charges.
- Relying on basic monitoring without detailed CloudWatch setups, missing granular insights.
- Skipping agent uninstalls in Inspector after assessments, affecting instance performance.
- Assuming Trusted Advisor checks everything without upgrading support plans.

#### Lesser-Known Facts
Config rules can trigger automated Lambda functions for remediation, turning compliance into real-time enforcement. CloudTrail's multi-region trails ensure global AWS account transparency, while EventBridge's scheduled rules enable cron-job like automations without EC2 instances.

</details>
