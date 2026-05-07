# Session 28: CloudWatch Metrics and Logs

| Section | Description |
|---------|-------------|
| [Overview](#overview) | Introduction to CloudWatch as the core monitoring service in AWS |
| [Key Concepts and Deep Dive](#key-concepts-and-deep-dive) | Detailed explanation of metrics, custom metrics, and CloudWatch Agent |
| [Lab Demos](#lab-demos) | Step-by-step demonstrations of custom metrics and agent configuration |
| [Summary](#summary) | Key takeaways, quick reference, and expert insights |

## Overview

CloudWatch is AWS's primary monitoring service, collecting and tracking metrics, logs, and events from AWS resources and applications. It provides real-time visibility into infrastructure performance, enabling proactive issue detection and resolution. This session focuses on CloudWatch Metrics, including built-in (AWS-provided) metrics and Custom Metrics for capturing data not natively available, such as memory utilization or per-process metrics.

## Key Concepts and Deep Dive

### What is CloudWatch?

CloudWatch is a comprehensive monitoring solution that:
- **Captures Metrics**: Time-stamped data points representing resource performance over time
- **Stores Logs**: Centralized log aggregation from various AWS services
- **Provides Alarms**: Automated notifications based on metric thresholds
- **Offers Visualizations**: Dashboards for data interpretation
- **Integrates Events**: Event-driven automation via CloudWatch Events (now EventBridge)

It operates on a "pull" versus "push" model for metrics – AWS services send data to CloudWatch, which stores it for analysis.

### Basic Metrics and Concepts

#### Metrics Fundamentals
Metrics are data points captured at specific intervals, forming a time series for analysis, alarms, and graphing. Key components:
- **Metric Name**: What is being measured (e.g., CPUUtilization, NetworkIn)
- **Unit**: Measurement scale (e.g., Percent, Bytes)
- **Value**: Numerical data point
- **Timestamp**: When captured (defaults to current time if not specified)
- **Dimensions**: Key-value pairs for filtering and grouping (e.g., InstanceId, InstanceType)

#### Built-in vs. Custom Metrics
- **AWS-Provided Metrics**: Captured automatically by AWS services in the "AWS/" namespace. Examples include EC2 CPU, EBS I/O, RDS queries.
- **Custom Metrics**: User-defined metrics sent via API or agents, stored in custom namespaces.

| Aspect | AWS-Provided Metrics | Custom Metrics |
|--------|----------------------|----------------|
| Namespace | AWS/ | User-defined (e.g., MyApp/) |
| Data Source | AWS services (pull by CloudWatch) | Applications/services (push to CloudWatch) |
| Examples | CPUUtilization, NetworkIn | MemoryUtilization, Application Response Time |
| Cost | Included with service (free for standard resolution) | Charged per metric sent |

#### Resolution and Time Series
AWSS captures metrics at intervals (resolution):
- **Standard Resolution**: 5 minutes (free)
- **Detailed Monitoring** (EC2): 1 minute (charged)
- **High Resolution Custom**: Down to 1 second (highest cost, used for real-time monitoring)

> [!IMPORTANT]
> Low resolution can miss transient issues. High resolution enables fine-grained analysis but increases costs.

#### Use Cases for Custom Metrics
1. **High-Frequency Monitoring**: Capture metrics every 1-10 seconds for critical systems (e.g., live streaming, trading platforms) where 1-minute resolution is insufficient.
2. **Missing Metrics**: Capture RAM utilization, not available in default EC2 monitoring.
3. **Disk and Process Metrics**: Monitor per-process CPU/RAM or instance store I/O.
4. **On-Premises Monitoring**: Extend CloudWatch to non-AWS environments for unified monitoring.
5. **Application-Specific Data**: Track custom application KPIs beyond infrastructure.

### Custom Metrics Implementation

#### Publishing Custom Metrics
Custom metrics are published using the `PutMetricData` API. This is a push mechanism where data is sent to CloudWatch.

Key API parameters:
- `Namespace`: Custom group (e.g., LinuxWorld)
- `MetricName`: Identifier (e.g., CurrentTemperature)
- `Value`: Data point (e.g., 30)
- `Unit`: Measurement unit (e.g., Percent)
- `Dimensions`: Filtering keys (e.g., Environment=Production)
- `Timestamp`: Optional custom time

Example AWS CLI command:
```
aws cloudwatch put-metric-data --namespace LinuxWorld --metric-name CurrentTemperature --value 30 --dimensions Environment=Production,InstanceType=t2.micro --unit Degrees
```

This creates a time series under the custom namespace, viewable in the CloudWatch console.

#### CloudWatch Unified Agent
The CloudWatch Agent (formerly separate Metric and Log agents) is a software package for collecting and pushing metrics/logs. It simplifies custom metric collection without manual scripting.

**Supported Platforms**: Linux, Windows, on-premises, EC2.

**Key Capabilities**:
- **Preconfigured Metrics**: Uses predefined keywords for common metrics.
- **High Resolution**: Supports 1-second intervals.
- **Centralized Management**: Integrates with SSM for distributing configurations.

> [!NOTE]
> The agent uses StatsD internally for aggregation, but focuses on EC2 metrics in this session.

#### IAM Permissions for Custom Metrics
EC2 instances need permissions to publish to CloudWatch. Use an IAM Role with the `CloudWatchAgentServerPolicy`, allowing `PutMetricData`.

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "cloudwatch:PutMetricData",
      "Resource": "*"
    }
  ]
}
```

Attach this role to EC2 instances for seamless publishing.

## Lab Demos

### Demo 1: Publishing a Custom Metric via CLI

**Steps**:
1. Ensure AWS CLI is configured with proper credentials (Access Key/Secret Key or IAM role).
2. Run the `PutMetricData` command to publish a metric.
   ```
   aws cloudwatch put-metric-data --namespace TestNamespace --metric-name Temperature --value 25 --unit Degrees --dimensions Location=Home,Environment=Test
   ```
   - **Namespace**: `TestNamespace`
   - **MetricName**: `Temperature`
   - **Value**: `25`
   - **Unit**: `Degrees`
   - **Dimensions**: `Location=Home`, `Environment=Test`

3. Verify in CloudWatch Console:
   - Navigate to CloudWatch > Metrics > All Metrics.
   - Select custom namespace (e.g., TestNamespace).
   - View under Instance ID or other dimensions.

**Expected Output**: Metric appears in console; graph displays if timestamped.

### Demo 2: Installing and Configuring CloudWatch Unified Agent

**Prerequisites**: EC2 instance with Linux (e.g., Amazon Linux 2), IAM role with `CloudWatchAgentServerPolicy`.

**Steps**:
1. Install the CloudWatch Agent.
   ```
   wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
   sudo rpm -U amazon-cloudwatch-agent.rpm
   ```

2. Configure the Agent (Interactive Wizard).
   ```
   sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
   ```
   - Select: On EC2
   - Root privileges: Yes
   - Include StatsD: No
   - Host metrics: Yes (CPU, memory, disk)
   - Per-core metrics: Yes
   - Dimensions: Add InstanceId, InstanceType
   - Resolution: High resolution (e.g., 1 second)
   - Logs: Skip for now

3. Fetch and start configuration.
   ```
   sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/home/ec2-user/agent-config.json
   ```
   - This reads the config file and starts the agent.

4. Verify Agent Status.
   ```
   systemctl status amazon-cloudwatch-agent
   ```
   - Should show "active (running)".

5. Check Logs for errors.
   ```
   tail -f /opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log
   ```
   - Ensure no credential errors; IAM role should resolve this.

6. Verify Metrics in CloudWatch Console.
   - Navigate to Metrics > CWAgent namespace.
   - Confirm metrics like `mem_used_percent`, `disk_used_percent` populate.

**Troubleshooting**:
- If errors: Attach IAM role to EC2 instance.
- Config errors: Validate JSON syntax manually or via GitHub examples.

> [!WARNING]
> High-resolution monitoring (1s) can increase costs significantly. Monitor CloudWatch billing.

## Summary

### Key Takeaways
```diff
+ CloudWatch is essential for AWS monitoring, with metrics as time-series data for visualization and alerting.
- Built-in metrics cover basic AWS services, but custom metrics fill gaps like RAM or per-process monitoring.
! High-resolution custom metrics enable real-time reaction but incur higher costs.
+ Push model: Agents/APIs send data to CloudWatch; tools like CloudWatch Unified Agent simplify setup.
- IAM roles required for EC2 instances to publish custom metrics; attach CloudWatchAgentServerPolicy.
+ Use cases: Live applications needing 1-second resolution, extended monitoring to on-premises.
```

### Quick Reference
- **Publish Metric CLI**: `aws cloudwatch put-metric-data --namespace <NS> --metric-name <NAME> --value <VAL> --unit <UNIT>`
- **Agent Install**: `wget https://s3.amazonaws.com/amazoncloudwatch-agent/...; sudo rpm -U amazon-cloudwatch-agent.rpm`
- **Agent Config Wizard**: `sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard`
- **Common Metrics Keywords**: mem_used_percent, cpu_usage_active, disk_used_percent
- **Namespace**: AWS/ (built-in), Custom/ (user-defined)

### Expert Insight

#### Real-World Application
In production environments like live streaming or financial systems, implement custom metrics with 1-second resolution for proactive scaling. Use CloudWatch Alarms to trigger Auto Scaling based on RAM spikes, preventing outages.

#### Expert Path
Master advanced topics like CloudWatch Logs (ELK integration), EventBridge for automation, and X-Ray for application tracing. Experiment with StatsD aggregations in the CloudWatch Agent for complex microservice monitoring.

#### Common Pitfalls
- **Overlooking IAM Roles**: Agents fail without proper permissions; always attach roles early.
- **High Costs**: Default to 5-minute resolution unless critical; monitor usage.
- **Incomplete Config**: Use wizard or validate JSON; missing StatsD can break high-res setups.
- **Resolution Confusion**: 1-second != 1-minute feeds; ensure configuration aligns with needs.

#### Lesser-Known Facts
- CloudWatch stores on-premises metrics alongside AWS, enabling hybrid cloud monitoring.
- Dimensions beyond InstanceId (e.g., Environment) enable powerful aggregations for multi-instance analysis.
- Agent be customized beyond preconfigured metrics for proprietary applications.
