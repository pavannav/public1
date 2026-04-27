# Session 28: CloudWatch Monitoring

## Table of Contents
- [CloudWatch Metrics Overview](#cloudwatch-metrics-overview)
- [AWS Provided vs Custom Metrics](#aws-provided-vs-custom-metrics)
- [Metrics Resolution and Frequency](#metrics-resolution-and-frequency)
- [Use Cases for Custom Metrics](#use-cases-for-custom-metrics)
- [PutMetricData API](#putmetricdata-api)
- [CloudWatch Unified Agent](#cloudwatch-unified-agent)
- [IAM Role Configuration](#iam-role-configuration)
- [Practical Demonstration](#practical-demonstration)

## CloudWatch Metrics Overview

### Overview
CloudWatch is AWS's primary monitoring service that collects and tracks metrics, logs, and events from AWS resources and applications. Metrics are time-series data points representing measurements of resources' performance and health over time.

### Key Concepts

#### Metrics as Time Series Data
CloudWatch uses a **time series database** internally to store metrics. Each metric consists of:
- **Time stamps**: When measurements were taken
- **Values**: The actual measurement data (e.g., CPU utilization percentage)
- **Metric name**: Identifier for the measurement type (e.g., "CPUUtilization")
- **Dimensions**: Key-value pairs providing metadata about the metric
- **Unit**: Measurement unit (percentage, bytes, count, etc.)

#### Data Flow
```diff
+ AWS Services → CloudWatch → Time Series Database → Visualization (graphs/charts)
```

Unlike traditional pull-based monitoring systems, CloudWatch operates on a **push mechanism**:
- AWS services automatically publish metrics to CloudWatch
- Custom applications can also publish metrics using APIs
- No need for CloudWatch to "pull" data from services

## AWS Provided vs Custom Metrics

### Name Spaces
CloudWatch organizes metrics into **name spaces**:

#### AWS Name Space
- Contains metrics automatically provided by AWS services
- Organized by service (EC2, RDS, Lambda, etc.)
- Examples: `AWS/EC2`, `AWS/RDS`, `AWS/Lambda`

#### Custom Name Space
- User-defined name spaces for custom metrics
- Examples: `MyApp/Metrics`, `Prod/Monitoring`, `CWAgent`

### Default AWS Metrics for EC2
EC2 instances automatically generate several metrics:
- **CPUUtilization**: Overall CPU usage
- **NetworkIn/NetworkOut**: Network traffic
- **DiskReadOps/DiskWriteOps**: Disk I/O operations

> [!NOTE]
> By default, AWS does NOT capture:
> - RAM/Memory utilization
> - Root volume disk I/O (only EBS volumes)
> - Per-process statistics
> - User login counts
> - Custom application metrics

## Metrics Resolution and Frequency

### Standard Resolution
- **Frequency**: 5 minutes (300 seconds)
- **Free tier**: Included with EC2 instances
- **Retention**: 15 months (long-term historical data)

### Detailed Monitoring
- **Frequency**: 1 minute (60 seconds)
- **Cost**: Additional charges apply
- **Enabled per instance** via EC2 console or API

### High Resolution Custom Metrics
- **Frequency**: Down to 1 second (minimum)
- **Use case**: Real-time monitoring for critical systems
- **Chargeable**: Higher cost for increased frequency

```diff
! Example Use Case: Live cricket match streaming
+ Need sub-second monitoring for immediate issue detection
- 1-minute delay could cause significant user disruption
```

## Use Cases for Custom Metrics

### High-Resolution Monitoring
Real-time applications requiring immediate response:
- Live streaming services
- Financial trading platforms
- Critical healthcare systems
- Gaming servers during peak tournaments

### Memory and RAM Monitoring
Track system memory utilization:
- **Use case**: Memory leaks, application crashes
- **Command**: `free` command output can be captured
- **Custom metric name**: `MemoryUtilization`

### Process-Level Monitoring
Monitor specific processes:
- **Apache web server**: CPU/memory usage
- **Database processes**: Performance metrics
- **Custom application processes**: Resource consumption

### Network and Disk I/O
Beyond basic AWS metrics:
- **Root volume I/O**: Not captured by default
- **Per-interface network stats**: Detailed network analysis
- **Custom application network usage**: API call volumes

### Application-Specific Metrics
Custom business logic monitoring:
- **User login counts**: `SELECT COUNT(*) FROM active_sessions`
- **Error rates**: Custom application error tracking
- **Queue depths**: Message queue monitoring
- **Business KPIs**: Revenue metrics, transaction rates

## PutMetricData API

### API Overview
CloudWatch provides a programmatic interface for publishing custom metrics:

```bash
aws cloudwatch put-metric-data \
  --metric-name "CustomMetricName" \
  --namespace "CustomNamespace" \
  --value 30 \
  --unit "Percent" \
  --dimensions "InstanceId=i-1234567890abcdef0,Environment=Production" \
  --timestamp "2024-01-15T10:30:00Z"
```

### Key Parameters
- **--metric-name**: Name of the metric (e.g., "MemoryUtilization")
- **--namespace**: Custom name space container
- **--value**: Numeric value of the metric
- **--unit**: Unit of measurement (Percent, Bytes, Count, etc.)
- **--dimensions**: Key-value pairs for categorization
- **--timestamp**: When the measurement was taken

### Command Line Implementation
```bash
# Manual metric publishing
aws cloudwatch put-metric-data \
  --metric-name "CurrentTemperature" \
  --namespace "IoT/Monitoring" \
  --value "30" \
  --unit "None" \
  --dimensions "Location=Home,InstanceType=t2.micro"

# Automated script example
#!/bin/bash
while true; do
  CPU_USAGE=$(ps aux --no-headers -o pcpu | awk '{cpu += $1} END {print cpu}')
  aws cloudwatch put-metric-data \
    --metric-name "TotalCPUUsage" \
    --namespace "System/Metrics" \
    --value "$CPU_USAGE" \
    --unit "Percent"
  sleep 60
done
```

## CloudWatch Unified Agent

### Overview
The CloudWatch Unified Agent is a single software package that can collect metrics, logs, and traces from EC2 instances and on-premises servers.

### Installation
```bash
# Download and install the agent
wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
sudo rpm -U amazon-cloudwatch-agent.rpm

# Start the agent service
sudo systemctl start amazon-cloudwatch-agent
sudo systemctl enable amazon-cloudwatch-agent
```

### Agent Features
- **Unified collection**: Both metrics and logs
- **Cross-platform**: Linux and Windows support
- **Built-in metrics**: Pre-configured system metrics
- **Custom metrics**: User-defined metric collection
- **Configuration-driven**: JSON/YAML configuration files

### Agent Configuration Wizard
```bash
# Run the configuration wizard
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
```

Interactive prompts for:
- Linux/Windows selection
- On EC2 or on-premises
- StatsD integration
- Monitoring host metrics
- Per-core CPU monitoring
- High-resolution collection
- Permission settings

### Sample Configuration File (JSON)
```json
{
  "agent": {
    "metrics_collection_interval": 60,
    "run_as_user": "root"
  },
  "metrics": {
    "namespace": "CWAgent",
    "metrics_collected": {
      "cpu": {
        "measurement": [
          "cpu_usage_idle",
          "cpu_usage_iowait",
          "cpu_usage_user",
          "cpu_usage_system"
        ],
        "metrics_collection_interval": 1,
        "totalcpu": false
      },
      "disk": {
        "measurement": [
          "used_percent"
        ],
        "metrics_collection_interval": 60
      },
      "mem": {
        "measurement": [
          "mem_used_percent"
        ],
        "metrics_collection_interval": 1
      }
    }
  }
}
```

## IAM Role Configuration

### Role Creation Steps
1. Navigate to IAM → Roles → Create role
2. Select "AWS service" → "EC2"
3. Attach policy: `CloudWatchAgentServerPolicy`
4. Role name: `EC2-CloudWatch-Agent-Role`
5. Attach role to EC2 instance via EC2 console

### Required Permissions
The `CloudWatchAgentServerPolicy` includes:
- `cloudwatch:PutMetricData`
- `cloudwatch:PutMetricStream`
- `ec2:DescribeTags`
- `logs:CreateLogGroup`
- `logs:CreateLogStream`
- `logs:DescribeLogStreams`
- `logs:PutLogEvents`

### Alternative: SSM Integration
For centralized management, use:
- Policy: `CloudWatchAgentServerPolicy` + SSM permissions
- Tools: Parameter Store for configuration files
- Benefit: Manage agent configs across multiple instances

## Practical Demonstration

### Lab Demos

#### 1. Manual Metric Publishing
```bash
# Create a custom metric for room temperature
aws cloudwatch put-metric-data \
  --metric-name "RoomTemperature" \
  --namespace "IoT/Environment" \
  --value 30 \
  --unit "None" \
  --dimensions "SensorID=LivingRoom001,Location=Home"

# Verify in CloudWatch console
# Navigate: CloudWatch → Metrics → All metrics → Custom namespaces
```

#### 2. Unified Agent Installation and Configuration
```bash
# Install the agent
sudo yum install -y amazon-cloudwatch-agent

# Run configuration wizard
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard

# Start the agent
sudo systemctl start amazon-cloudwatch-agent

# Check logs
tail -f /opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log
```

#### 3. IAM Role Attachment
```bash
# Create role (via console or CLI)
aws iam create-role \
  --role-name EC2-CloudWatch-Agent-Role \
  --assume-role-policy-document file://ec2-trust-policy.json

aws iam attach-role-policy \
  --role-name EC2-CloudWatch-Agent-Role \
  --policy-arn arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy

# Attach to EC2 instance (via console)
# EC2 → Instances → Security → Modify IAM role
```

#### 4. Verifying Metrics Collection
Navigate to CloudWatch console:
- **All metrics** → **CWAgent** namespace
- Verify metrics like:
  - `mem_used_percent`
  - `disk_used_percent`
  - `cpu_usage_idle`
  - `cpu_usage_system`

## Summary

### Key Takeaways
```diff
+ CloudWatch provides both AWS-managed and custom metrics for comprehensive monitoring
+ Custom metrics enable high-resolution monitoring down to 1-second granularity
+ Push-based architecture allows publishing metrics from any source via API
+ Unified Agent simplifies metric collection from EC2 and on-premises systems
+ Name spaces organize metrics into logical groups for better management
+ Dimensions provide metadata for advanced analytics and filtering
```

### Quick Reference

#### Important Commands
```bash
# Install CloudWatch agent
sudo yum install amazon-cloudwatch-agent

# Configure agent
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard

# Start agent
sudo systemctl start amazon-cloudwatch-agent

# Publish custom metric
aws cloudwatch put-metric-data \
  --metric-name "MetricName" \
  --namespace "CustomNamespace" \
  --value 100 \
  --unit "Percent"
```

#### Metric Collection Periods
- **Standard**: 5 minutes (free)
- **Detailed**: 1 minute (chargeable)
- **High Resolution**: 1 second+ (custom metrics only)

### Expert Insight

#### Real-world Application
In enterprise environments, CloudWatch custom metrics enable:
- **Auto-scaling triggers** based on application performance
- **Cost optimization** by monitoring resource utilization patterns
- **Compliance monitoring** for security and regulatory requirements
- **Application performance monitoring** (APM) integration
- **Infrastructure as Code** (IaC) deployments with automated monitoring

#### Expert Path
To master CloudWatch monitoring:
1. **Understand metric math** for complex calculations and aggregations
2. **Implement composite alarms** combining multiple metrics
3. **Create automated dashboards** for different stakeholder views
4. **Integrate with Container Insights** for microservices monitoring
5. **Set up cross-account monitoring** for multi-account AWS organizations
6. **Implement anomaly detection** using machine learning features

#### Common Pitfalls
```diff
- Forgetting IAM permissions when deploying agents
! Not testing metric collection after configuration changes
- Overusing high-resolution metrics increasing costs
- Neglecting to configure log rotation for agent logs
- Failing to monitor the monitoring system itself
```

#### Lesser-Known Facts
- CloudWatch can monitor **on-premises infrastructure** using the unified agent
- **StatsD protocol** integration allows application-level custom metrics
- CloudWatch supports **cross-region metric aggregation** for global applications
- **Metric streams** enable real-time export to external monitoring systems
- **Embedded Metric Format (EMF)** allows logging custom metrics as part of application logs

---

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
