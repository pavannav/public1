# Session 32: AWS CloudWatch Logs and Event Bridge Introduction

## Table of Contents
- [Overview](#overview)
- [Section 1: CloudWatch Metrics Refresher](#section-1-cloudwatch-metrics-refresher)
- [Section 2: Detailed Monitoring](#section-2-detailed-monitoring)
- [Section 3: Custom Metrics](#section-3-custom-metrics)
- [Section 4: Publishing Custom Metrics](#section-4-publishing-custom-metrics)
- [Section 5: CloudWatch Agent and Unified Agent](#section-5-cloudwatch-agent-and-unified-agent)
- [Section 6: Log Collection and Management](#section-6-log-collection-and-management)
- [Section 7: Centralized Configuration with SSM Parameter Store](#section-7-centralized-configuration-with-ssm-parameter-store)
- [Section 8: IAM Roles and Agent Setup](#section-8-iam-roles-and-agent-setup)
- [Section 9: Event Bridge Introduction](#section-9-event-bridge-introduction)
- [Section 10: Practical Demo](#section-10-practical-demo)

## Overview {#overview}
This session continues from the previous CloudWatch metrics discussion, transitioning into CloudWatch Logs. It covers the limitations of basic metrics, detailed monitoring, custom metrics, log collection agents, and introduces Event Bridge as the next topic.

## Section 1: CloudWatch Metrics Refresher {#section-1-cloudwatch-metrics-refresher}
### Overview
Basic CloudWatch metrics are collected at 5-minute frequency, which may not provide real-time visibility into resource performance and health. This can cause latency in detecting spikes in metrics like CPU utilization.

### Key Concepts
Standard CloudWatch metrics use basic resolution by default. For real-time monitoring:
- **Custom metrics** allow granular data (e.g., sub-second granularity)
- **Detailed monitoring** enables 1-minute period data collection
- **Namespaces** organize metrics (AWS vs. custom)
- **Dimensions** provide unique identification and filtering

### Limitations of Default Monitoring
Basic monitoring collects data every 5 minutes, causing potential visibility gaps during sudden load changes.

> [!WARNING]
> 5-minute collection may delay detection of performance issues.

## Section 2: Detailed Monitoring {#section-2-detailed-monitoring}
### Enabling Detailed Monitoring
To enable detailed monitoring for EC2 instances:
1. Navigate to EC2 instance → Monitoring tab
2. Click "Manage detailed monitoring"
3. Enable detailed monitoring
4. Confirm the change

This changes metric collection to 1-minute intervals and displays data in 1-minute periods.

## Section 3: Custom Metrics {#section-3-custom-metrics}
### Overview
Custom metrics enable monitoring of application behavior and performance not covered by standard AWS metrics. They provide flexibility in defining resolution and data points.

### Key Features
- **Flexible Resolution**: Define metrics as standard or higher resolution (up to 1-second)
- **Namespace Organization**: Store in custom namespaces vs. AWS namespaces
- **Dimensions**: Name-value pairs for unique metric identification
- **Push Mechanism**: Direct publishing to CloudWatch via API

### Use Cases
Monitor processes running inside operating systems, RAM usage, and custom application metrics.

> [!NOTE]
> Default CloudWatch does not capture metrics for RAM and root volume usage.

## Section 4: Publishing Custom Metrics {#section-4-publishing-custom-metrics}
### Using PutMetricsData API
The PutMetricsData API allows publishing custom metric data points to CloudWatch.

### CLI Command Structure
```bash
aws cloudwatch put-metric-data \
  --metric-name "MetricName" \
  --namespace "CustomNamespace" \
  --unit "Unit" \
  --value "Value" \
  --dimensions "Name=Environment,Value=Production|Name=Location,Value=InstanceID"
```

### Example
Publishing a metric with dimensions:
```bash
aws cloudwatch put-metric-data \
  --metric-name "DiskUtilization" \
  --namespace "CustomNamespace" \
  --unit "Bytes" \
  --value "10000" \
  --dimensions "Name=Environment,Value=Prod|Name=Location,Value=home|Name=InstanceID,Value=i-123456|Name=InstanceType,Value=m1.small"
```

## Section 5: CloudWatch Agent and Unified Agent {#section-5-cloudwatch-agent-and-unified-agent}
### CloudWatch Agent
The CloudWatch agent:
- Automates metric and log collection from servers
- Collects system-level metrics (CPU, memory, disk)
- Supports custom metrics
- Runs on EC2 instances (and on-premises servers)

### Unified Agent
Combines functionality of metrics and logs agents into one software package.

### Installation
```bash
sudo yum install amazon-cloudwatch-agent
```

### Verification
```bash
sudo rpm -q amazon-cloudwatch-agent
```

### Configuration with Wizard
Run the configuration wizard:
```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
```

Wizard options include:
- Running as root
- StatsD demon port
- Metrics collection (CPU per core, aggregate)
- Higher resolution settings
- Enabling detailed monitoring

### Starting the Agent
```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -c file:/location/of/config.json \
  -s
```

## Section 6: Log Collection and Management {#section-6-log-collection-and-management}
### Log Fundamentals
Logs are historical records of application/service activities:
- **Real-time**: Logs generate during client requests
- **Historical**: Stored for analysis (troubleshooting, security, analytics)
- **Structure**: Often stored in files (log files), collected into log streams

### CloudWatch Logs Architecture
- **Log Groups**: Containers for log streams (equivalent to folders)
- **Log Streams**: Individual log file equivalents
- **Push Model**: Applications/services push logs to CloudWatch
- **Centralized Storage**: Aggregates logs across multiple instances

### Log Collection Methods
#### Without Code Changes (Recommended)
Use agents to collect existing logs from local files.

#### With Code Changes
Modify applications to push logs directly via APIs (not recommended for running systems).

### Unified Approach Benefits
- **Modular**: Enable/disable log and/or metric collection independently
- **Scalable**: One agent handles multiple monitoring needs
- **Centralized**: Decode behavior from SSM Parameter Store

> [!IMPORTANT]
> Agents are installed on source systems (EC2, on-premises) and push data to CloudWatch.

## Section 7: Centralized Configuration with SSM Parameter Store {#section-7-centralized-configuration-with-ssm-parameter-store}
### Problem with Local Config Files
Managing separate config files across thousands of instances becomes complex. Changes require updating each instance individually.

### SSM Parameter Store Solution
- **Centralized Config Management**: Store agent config files centrally
- **Agent Fetches Config**: Agents read instructions from SSM instead of local files
- **Scalability**: Change config once for all instances

### Parameter Store Setup
- **Service**: SSM Parameter Store
- **Data Types**: String (for JSON configs)
- **Encryption**: Supports encryption options
- **Integration**: EC2 instances need IAM permissions to access SSM

### Benefits
- **Refactoring**: Move from local to centralized config without downtime
- **Scalability**: Easy to scale to thousands of instances
- **Maintenance**: Single place to update configurations

## Section 8: IAM Roles and Agent Setup {#section-8-iam-roles-and-agent-setup}
### Creating IAM Role for EC2
1. Go to IAM service
2. Create role for EC2 service
3. Attach CloudWatch agent server policies:
   - `CloudWatchAgentServerPolicy` (for metrics/logs)
   - `AmazonSSMFullAccess` (for parameter store access)
4. Assign role to EC2 instance via Actions → Security → Modify IAM role

### Agent Startup with SSM
Instead of local config file:
```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -c ssm:parameter-store-name \
  -s
```

### Automation
- **User Data**: Include installation/startup commands in user data for auto-launch
- **Custom AMI**: Pre-install agents and configs in custom AMIs
- **Scalability**: New instances automatically connect to centralized config

## Section 9: Event Bridge Introduction {#section-9-event-bridge-introduction}
Event Bridge enables integration and automation across AWS services. It's powerful for creating event-driven architectures and solving complex use cases.

### Key Concepts (Teased)
- **Event-Driven Architecture**: React to AWS service changes
- **Decoupling**: Connect services without tight coupling
- **Multiple Integration Patterns**: Server-to-server communications

> [!NOTE]
> Event Bridge will be covered in detail in the next session.

## Section 10: Practical Demo {#section-10-practical-demo}
### Demo Summary
The instructor demonstrated:
1. Launching EC2 instances with Apache web server
2. Installing and configuring unified CloudWatch agent
3. Uploading config to SSM Parameter Store
4. Attaching IAM role for SSM access
5. Starting agent to collect both metrics and logs
6. Verifying log streams in CloudWatch Logs console
7. Real-time log viewing with auto-refresh

### Key Commands Used
```bash
# Launch EC2 instance
# Install Apache
systemctl enable httpd
sudo yum install amazon-cloudwatch-agent

# Run config wizard
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard

# Start agent with SSM config
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c ssm:parameter-store-name -s

# Check log files
tail -f /var/log/httpd/access_log
curl http://your-instance-ip/
```

### Observed Results
- Log groups created automatically
- Log streams per instance ID
- Real-time log ingestion from client requests
- Error logs captured and stored

## Summary

### Key Takeaways
```diff
+ CloudWatch Logs provides centralized log management and real-time streaming
+ Unified CloudWatch agent handles both metrics and logs collection
+ SSM Parameter Store enables scalable, centralized configuration management
+ IAM roles control permissions for agent-to-service communication
+ Event Bridge introduces serverless event-driven architectures
- Local config files don't scale well for large deployments
- Agent troubleshooting requires proper directory/file permissions
- Basic monitoring limitations can be addressed with detailed/custom metrics
```

### Quick Reference
**Command to install agent:**
```bash
sudo yum install amazon-cloudwatch-agent
```

**Start agent with SSM config:**
```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -c ssm:AmazonCloudWatch-linux -s
```

**Check agent status:**
```bash
sudo systemctl status amazon-cloudwatch-agent
```

**Log file locations:**
- Access logs: `/var/log/httpd/access_log`
- Error logs: `/var/log/httpd/error_log`

**Parameter Store name pattern:**
- Default for unified agent: `AmazonCloudWatch-linux`

### Expert Insight

#### Real-world Application
In production environments, CloudWatch Logs combined with Event Bridge enables automated incident response. For example, log pattern analysis can trigger Event Bridge rules that automatically scale EC2 instances, send alerts, or invoke Lambda functions for remediation. The SSM Parameter Store approach scales this to enterprise environments with thousands of instances.

#### Expert Path
Master CloudWatch Logs by learning:
1. Log Insights queries for advanced analytics
2. Event Bridge integration patterns (schedule rules, cross-account events)
3. Custom metric math expressions
4. Log group retention and archiving strategies

#### Common Pitfalls
- **Permission Mismatches**: IAM role policies must exactly match parameter store paths
- **Config File Conflicts**: Unified agent requires proper directory structure
- **Log Rotation Handling**: Large log files may require regex patterns in configurations
- **Real-time vs. Historical**: Understanding log streaming vs. stored log differences

#### Lesser-Known Facts
- CloudWatch agent can monitor on-premises servers, enabling hybrid cloud monitoring
- Parameter Store can encrypt sensitive config data using KMS
- Log groups support cross-region replication for disaster recovery scenarios
- Event Bridge can trigger on log pattern matches via CloudWatch alarms rules
