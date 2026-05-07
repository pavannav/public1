# Session 26: CloudWatch Metrics and Alarms

## Table of Contents
- [CloudWatch Overview](#cloudwatch-overview)
- [CloudWatch Metrics](#cloudwatch-metrics)
  - [Key Concepts](#key-concepts)
  - [Metrics in Practice](#metrics-in-practice)
  - [Graph Visualization](#graph-visualization)
  - [Lab Demo: Lambda Function Metrics](#lab-demo-lambda-function-metrics)
  - [Lab Demo: EC2 Instance Metrics](#lab-demo-ec2-instance-metrics)
- [CloudWatch Alarms](#cloudwatch-alarms)
  - [Why Alarms Matter](#why-alarms-matter)
  - [Creating Alarms](#creating-alarms)
  - [Lab Demo: Lambda Error Alarm](#lab-demo-lambda-error-alarm)
  - [Lab Demo: EC2 CPU Alarm](#lab-demo-ec2-cpu-alarm)
- [Summary](#summary)

## CloudWatch Overview
CloudWatch is a monitoring and observability service in AWS designed to collect, visualize, and analyze metrics, logs, and events from AWS resources and applications. It enables real-time monitoring of infrastructure and applications, helping to maintain performance, troubleshoot issues, and trigger automated responses.

## CloudWatch Metrics

### Key Concepts
- **Metrics**: Quantitative data points captured by CloudWatch for various AWS services. Each metric represents performance aspects like CPU utilization, request counts, or error rates.
- **Data Points**: Individual measurements captured at specific timestamps. For example, CPU utilization at 11:00 AM showing 5% usage.
- **Matrix Name**: Descriptive labels for metrics, such as "CPU Utilization" or "Error Count."
- **Statistical Functions**: Used to analyze metrics:
  - **Average**: Mean value over time (e.g., average CPU over 5 minutes).
  - **Sum**: Total accumulation (e.g., total errors in a period).
  - **Minimum/Maximum**: Extremes in data.
  - **Median/Percentile**: Advanced aggregation not applicable to all metrics (e.g., count-based metrics like errors don't use average sensibly).
  - Custom metrics can be created for application-specific needs.

Metrics are automatically captured for most AWS services but can be customized. Detailed monitoring provides data every 1 minute, while basic monitoring uses 5-minute intervals.

### Metrics in Practice
- **Time Series Databases**: CloudWatch uses internal time series databases to store historical metrics data for retrieval and analysis.
- **Service Integration**: Metrics are pre-configured for services like EC2, Lambda, EBS, and NAT Gateway.
- **Namespace and Dimensions**: Metrics are organized by namespace (e.g., AWS/EC2) and dimensions (e.g., InstanceId, FunctionName) for filtering.
- **Predefined vs. Custom Metrics**:
  - Predefined metrics are captured automatically.
  - Custom metrics require manual emission from applications using CloudWatch APIs.

### Graph Visualization
- Default graphs display metrics with X-axis (time) and Y-axis (value).
- Bar charts are unsuitable for random or continuous data like error counts (better left for categories like HTTP status codes).
- Line graphs suit trend tracking (e.g., increasing error rates over time).
- Period adjustments change data point frequency (e.g., from 5 minutes to 1 minute).

### Lab Demo: Lambda Function Metrics
1. Create a Lambda function (e.g., `fun-test-one` with Python runtime).
2. Invoke the function manually to generate metrics.
3. Navigate to CloudWatch > Metrics > Lambda > By Function Name.
4. View metrics like Invocations, Errors, Duration, and Memory Usage.
5. Note: Metrics appear after a few minutes; enable detailed monitoring for sub-minute granularity if supported.

```bash
# Example of invoking Lambda via CLI (simulated)
aws lambda invoke --function-name fun-test-one --payload '{}' output.json
```

### Lab Demo: EC2 Instance Metrics
1. Go to EC2 Dashboard > Instances > Select an instance > Monitoring tab.
2. Enable Detailed Monitoring (charges apply for <1 minute granularity).
3. Navigate to CloudWatch > Metrics > EC2 > Per-Instance Metrics.
4. View CPU Utilization graph; adjust period and statistics (e.g., Average over 5 minutes).

```bash
# Enable detailed monitoring via CLI
aws ec2 monitor-instances --instance-ids i-1234567890abcdef0 --monitoring STATE=enabled
```

## CloudWatch Alarms

### Why Alarms Matter
Alarms automate responses to metric thresholds. They prevent manual monitoring by triggering notifications, scaling, or scripts based on rules evaluated against historical or real-time data.

### Creating Alarms
- **Conditions**: Set static thresholds or anomaly detection (thresholds are simpler for beginners).
- **Threshholds**: Define breaches (e.g., CPU > 80% for 5 consecutive data points).
- ** Evaluations**: Period (e.g., 5 minutes) and datapoint count (e.g., 5 out of 5).
- **Actions**: Integrate with services:
  - SNS for notifications.
  - Autoscaling Groups for scaling.
  - Systems Manager for scripts.
  - EC2 actions (stop, terminate, reboot).

```diff
+ Positive: Automates scaling during traffic spikes
- Warning: Inappropriate statistical functions (e.g., averaging error counts) can mislead
! Alert: Alarm misconfiguration may lead to false positives/negatives
```

### Lab Demo: Lambda Error Alarm
1. In CloudWatch, go to Alarms > Create Alarm.
2. Select Lambda > Errors metric.
3. Set condition: Greater than or equal to 3 errors, evaluated over 5 minutes (5 datapoints).
4. Configure action: Send notification via SNS (create topic if needed, e.g., email to user@domain.com).
5. Name alarm (e.g., "My Lambda Error Alarm") and create.
6. Test by invoking function multiple times to trigger errors.

```bash
# Create SNS topic (one-time setup)
aws sns create-topic --name lambda-error-topic
aws sns subscribe --topic-arn arn:aws:sns:region:account:lambda-error-topic --protocol email --notification-endpoint user@domain.com
```

### Lab Demo: EC2 CPU Alarm
1. Select EC2 > CPU Utilization metric.
2. Set condition: Greater than 10% average over 7 minutes (7 datapoints).
3. Configure EC2 action: Stop instance when threshold breached.
4. Name alarm and create.
5. Simulate load using tools like `yes` or `stress` to exceed threshold.

```bash
# Simulate CPU load (example with stress, assume installed)
stress --cpu 1 --timeout 300 &
```

## Summary

### Key Takeaways
```diff
+ CloudWatch is essential for monitoring metrics, logs, and events across AWS services
+ Metrics provide historical data points analyzed via graphs and statistics
+ Alarms enable automation: notifications, scaling, and actions based on thresholds
+ Integrates seamlessly with services like EC2, Lambda, and SNS for proactive management
- Over-reliance on basic statistics without understanding data can lead to incorrect conclusions
! Proper threshold setting is critical to avoid unnecessary alerts or missed issues
```

### Quick Reference
- **Enable Detailed Monitoring**: For EC2, use CLI `aws ec2 monitor-instances --monitoring STATE=enabled`.
- **Create Alarm**: CloudWatch Console > Alarms > Select metric > Define condition > Add actions.
- **Common Commands**:
  - Invoke Lambda: `aws lambda invoke --function-name <name> --payload '{}' <file>`
  - Check Alarms: `aws cloudwatch describe-alarms`
- **Key Metrics**: CPU Utilization (Average), Errors (Sum), Invocations (Sum)

### Expert Insight

#### Real-World Application
In production, CloudWatch Alarms scale autoscaling groups during traffic surges (e.g., e-commerce spikes) or notify DevOps teams via PagerDuty integrations for error spikes. They automate remediation scripts to clean cache or restart services on threshold breaches.

#### Expert Path
Master statistical modeling in CloudWatch; explore anomaly detection for dynamic thresholds. Advance to CloudWatch Logs Insights for query-based alerts and integrate with X-Ray for traces. Deep dive into custom metrics via CloudWatch APIs and participate in AWS DevOps or SysOps training.

#### Common Pitfalls
Misapplying statistics (e.g., averaging discrete counts) causes faulty alarms. Ignoring metric lag (e.g., 5-minute delays) leads to delayed responses. Over-notification fatigues teams; set precise thresholds. Neglecting costs from detailed monitoring overheads budgets.

#### Lesser-Known Facts
CloudWatch supports cross-region metrics via replicas, enabling global monitoring without data transfer costs. Webhooks in SNS allow integrations with tools like Slack or Jira beyond email/SMS. Metrics can trigger Lambda functions directly for serverless automation. Bảo

#### Advantages and Disadvantages
**Advantages**: Comprehensive, cost-effective monitoring at scale; no infrastructure management; rich integrations for automation.
**Disadvantages**: Steep learning curve for complex queries; potential costs for high-frequency metrics; reliance on AWS ecosystem limits portability.

---
🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>

<!-- Transcription Corrections: "ript" (likely "Script") at start removed; "cloudatch" corrected to "CloudWatch" throughout; "WLA" corrected to "will"; "htp" not present; "cubectl" not present. -->
