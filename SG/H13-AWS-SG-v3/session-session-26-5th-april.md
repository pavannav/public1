# Session 26: CloudWatch Metrics and Alarms

## Table of Contents

- [Revision of Previous Sessions](#revision-of-previous-sessions)
- [CloudWatch Metrics Overview](#cloudwatch-metrics-overview)
- [Key Concepts of Metrics](#key-concepts-of-metrics)
- [Demonstration: Lambda Function Metrics](#demonstration-lambda-function-metrics)
- [CloudWatch Alarms](#cloudwatch-alarms)
- [Alarm Configuration and Thresholds](#alarm-configuration-and-thresholds)
- [Practical Demonstration: Error Alarm for Lambda](#practical-demonstration-error-alarm-for-lambda)
- [Demonstration: CPU Utilization Alarm for EC2](#demonstration-cpu-utilization-alarm-for-ec2)
- [Alarm Actions and Integrations](#alarm-actions-and-integrations)
- [Summary](#summary)

## Revision of Previous Sessions

### Overview
This session revisits CloudTrail and CloudWatch concepts covered in previous classes, including API event tracking, metrics collection, and the differences between CloudWatch and CloudTrail services.

### Key Concepts / Deep Dive
- **API Events**: Every AWS service generates API calls that can be monitored as events.
- **CloudTrail**: Records API activity across services, enabling operational auditing and compliance.
  - Key features: API event logging, multi-region trails, S3 storage, logging status.
- **CloudWatch**: Comprehensive monitoring service that collects real-time logs and metrics.
  - Difference from CloudTrail: CloudWatch focuses on metrics and logs for performance monitoring, while CloudTrail tracks API events for security and auditing.
- **Event Management**: Enabled by default in AWS, allowing record-keeping of all API activities.

### Lab Demos
1. **CloudTrail Setup**:
   - Trail name: `my-wimble-management-events`
   - Applied to all regions.
2. **Event History Check**: Verified root user events after trail creation.

> [!IMPORTANT]  
> CloudTrail operates at the account level and records API calls, while CloudWatch monitors resource performance metrics.

| Service | Primary Purpose | Data Stored | Integration |
|---------|-----------------|-------------|-------------|
| CloudTrail | API event recording | API calls, timestamps, users | Security auditing |
| CloudWatch | Performance monitoring | Metrics, logs, events | Operational alerts |

## CloudWatch Metrics Overview

### Overview
CloudWatch Metrics is a sub-service of CloudWatch that captures and stores data points representing resource performance over time, enabling trend analysis and proactive monitoring.

### Key Concepts / Deep Dive
- **Metrics Definition**: Quantitative measurements of resources, such as CPU utilization or error rates.
- **Data Points**: Individual measurements captured at specific timestamps (e.g., "5% CPU at 11 AM").
- **Time-Series Database**: Internal AWS storage mechanism for historical metric data.
- **Statistical Functions**: Used to analyze metrics:
  - **Average**: Commonly used for CPU utilization.
  - **Sum**: Appropriate for error counts.
  - **Mean/Median**: Advanced statistical analysis for trends.
- **Metric Types**:
  - **Predefined Metrics**: Automatically captured (e.g., EC2 CPU utilization every 5 minutes).
  - **Custom Metrics**: User-configurable for application-specific data.
- **Namespace**: Organizational grouping (e.g., "AWS/EC2", "AWS/Lambda").

> [!NOTE]  
> Statistical function selection depends on data type; average is unsuitable for discrete counts like errors.

```diff
+ Predefined Metric Example: CPU utilization (continuous, use average)
- Inappropriate Use: Average on error counts (discrete, use sum instead)
! Best Practice: Choose statistics based on data meaning
```

### Demonstration: Lambda Function Metrics

#### Overview
Demonstration using AWS Lambda to show how metrics are captured and visualized.

#### Key Concepts / Deep Dive
- **Lambda Metrics**: Includes invocation count, error count, duration, memory usage.
- **Invocation**: Each function execution triggers metric capture.

#### Lab Demo: Creating and Monitoring Lambda Function
1. **Create Lambda Function**:
   - Function name: `fun-test-one`
   - Runtime: Python 3.x
   - Handler: Default
2. **Invoke Function**: Manually test the function.
3. **Monitor Metrics**:
   - Navigate to CloudWatch → Metrics.
   - Select Lambda → By Function Name.
   - View metrics: Invocations, Errors, Duration.
4. **Graph Configuration**:
   - Period: 5 minutes (default).
   - Statistical function: Sum for errors.
5. **Enable Detailed Monitoring**: For more frequent data points (optional, incurs charges).

> [!WARNING]  
> Detailed monitoring increases costs; enable only when necessary for finer granularity.

## CloudWatch Alarms

### Overview
CloudWatch Alarms automate responses to metric changes by defining thresholds and triggering actions like notifications or scaling operations.

### Key Concepts / Deep Dive
- **Alarm States**: OK (within threshold), ALARM (breached), INSUFFICIENT_DATA (initial state).
- **Rule-Based Monitoring**: Compares metrics against user-defined conditions.
- **Threshold Types**:
  - **Static**: Fixed value (e.g., CPU > 80%).
  - **Anomaly Detection**: Dynamic thresholds (advanced feature, not covered in CS level).
- **Evaluation Period**: Number of data points to evaluate (e.g., 3 out of 5).
- **Integration Capabilities**: Triggers SNS notifications, autoscaling, SSM automation.

> [!IMPORTANT]  
> Alarms enable automation, transforming monitoring into actionable operations.

### Alarm Configuration and Thresholds

| Configuration Element | Description | Example |
|----------------------|-------------|---------|
| Metric | Source data (e.g., CPU utilization) | EC2 CPUUtilization |
| Threshold | Breach condition | Greater than 80% |
| Evaluation Period | Data points required | 5 consecutive points |
| Statistical Function | Analysis method | Average |
| Actions | Response mechanisms | SNS notification, autoscaling |

## Practical Demonstration: Error Alarm for Lambda

### Overview
Creating an alarm to monitor Lambda function errors and trigger notifications.

### Lab Demo: Error Alarm Creation
1. **Navigate to CloudWatch Alarms** → Create Alarm.
2. **Select Metric**:
   - Service: Lambda
   - Metric: Errors (FunctionName: fun-test-one)
   - Statistic: Sum
3. **Configure Conditions**:
   - Threshold type: Static
   - Condition: Greater than or equal to 3
   - Evaluation period: 5 data points
   - Period: 1 minute
4. **Add Notification**:
   - Create SNS Topic for notifications.
   - Confirm email subscription for alerts.
5. **Test Alarm**: Intentionally fail the Lambda function multiple times to trigger alert.

```diff
+ Successful Setup: Alarm state moves to ALARM on breach
! Trigger Example: 6 errors exceed 3-error threshold
```

### Demonstration: CPU Utilization Alarm for EC2

### Overview
Setting up an alarm for EC2 CPU utilization to demonstrate resource-based monitoring.

### Lab Demo: CPU Alarm Creation
1. **Enable Detailed Monitoring**: In EC2 instance → Monitoring tab → Enable.
2. **Create Alarm**:
   - Metric: CPUUtilization
   - Threshold: Greater than 10%
   - Evaluation period: 7 data points
   - Period: 1 minute
3. **Configure Actions**:
   - Stop instance on alarm trigger.
4. **Test Alarm**: Simulate high CPU load using stress testing tools.

```bash
# Example stress testing command (Linux)
stress --cpu 4 --timeout 300
```

> [!WARNING]  
> High CPU alarms can trigger costly actions like stopping production instances; test carefully.

## Alarm Actions and Integrations

### Overview
Alarms integrate with AWS services for automated responses.

### Key Concepts / Deep Dive
- **SNS Integration**: Sends emails/SMS notifications.
- **AutoScaling Groups**: Scales EC2 instances automatically.
- **SSM Automation**: Runs predefined scripts for remediation.
- **Action Types**: Start/Stop instances, send notifications, execute scripts.

## Summary

### Key Takeaways
```diff
+ CloudWatch Metrics: Captures performance data points for trend analysis
+ Alarms Enable Automation: Threshold-based triggers for proactive responses
+ Statistical Functions Matter: Choose average/sum based on metric type
+ Integrations Enhance Operations: SNS, autoscaling, SSM extend alarm capabilities
- Avoid Over-Alarming: Fine-tune thresholds to prevent excessive notifications
! Real-Time Monitoring: Enables quick detection of performance issues
```

### Quick Reference
- **CloudWatch Metrics Path**: CloudWatch → Metrics → Select service → Choose metric
- **Create Alarm**: CloudWatch → Alarms → Create Alarm → Select metric → Set conditions
- **Statistical Functions**: Average (CPU), Sum (errors, invocations)
- **Evaluation Example**: 3 out of 5 data points > 80% CPU triggers alarm
- **Load Testing Tools**: Linux: `stress`, `yes`; for CPU simulation

### Expert Insight

#### Real-world Application
In production, CloudWatch metrics and alarms are crucial for maintaining system reliability. For example, e-commerce platforms monitor Lambda error rates to prevent customer impact, while EC2 CPU alarms scale resources during traffic spikes. Integrations with autoscaling prevent manual intervention during peak loads.

#### Expert Path
Master CloudWatch by studying advanced features like anomaly detection and custom metrics in the SysOps training program. Practice creating alarms across different services (EBS, RDS, Lambda) to build comprehensive monitoring strategies.

#### Common Pitfalls
- **Wrong Statistical Functions**: Leads to inaccurate alarms (e.g., averaging error counts).
- **Overly Sensitive Thresholds**: Causes alert fatigue without real issues.
- **Missing Detailed Monitoring**: Limited resolution for quick detection in production.
- **Unverified Email Confirmations**: SNS fails to send notifications without confirmation.

#### Lesser-Known Facts
- CloudWatch uses internal time-series databases optimized for massive scale.
- Alarms can trigger cross-region responses through multi-region CloudWatch configurations.
- Custom metrics support application-level monitoring beyond AWS services.

#### Advantages and Disadvantages
**Advantages**:
- Real-time visibility into system health.
- Automated responses reduce manual intervention.
- Scalable monitoring for multi-service architectures.

**Disadvantages**:
- Detailed monitoring increases AWS costs.
- Complex alarm configurations require understanding of metrics.
- Cross-region monitoring may have latency for data propagation.
