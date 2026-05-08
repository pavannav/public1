# Session 43: Amazon Kinesis Data Streams - Advanced Ingestion Methods and SDK Implementation

## Table of Contents

- [Sharding and Core Concepts](#sharding-and-core-concepts)
- [S3 Service Overview](#s3-service-overview)
- [Data Ingestion Methods to Kinesis](#data-ingestion-methods-to-kinesis)
- [Kinesis Data Streams Practical Implementation](#kinesis-data-streams-practical-implementation)
- [Real-time Web Server Log Streaming](#real-time-web-server-log-streaming)
- [ETL Operations with Kinesis Agent](#etl-operations-with-kinesis-agent)
- [SDK Implementation - Producer and Consumer](#sdk-implementation---producer-and-consumer)
- [Event-Driven Architecture with Lambda and S3](#event-driven-architecture-with-lambda-and-s3)
- [Summary](#summary)

## Sharding and Core Concepts

### Overview
Amazon Kinesis Data Streams is a middleware solution that enables real-time data streaming by providing an intermediate medium for data storage and distribution. This session builds on core concepts of sharding, producers, and consumers, focusing on advanced ingestion methods including AWS SDK, Kinesis Producer Library, and Kinesis Agent implementation.

### Key Concepts

#### Sharding Fundamentals
- **Shard Definition**: A shard represents dividing large data into smaller, more manageable parts
- **Benefits**: Smaller shards provide faster processing and better scalability
- **Data Distribution**: Distributes data across shards for parallel processing

```diff
+ Shards enable parallel data processing across multiple consumers
- Single large datasets become bottlenecks in real-time processing
```

#### Producer-Consumer Model
- **Producer**: Application that puts data records into Kinesis Data Streams (e.g., applications, agents, SDKs)
- **Consumer**: Application that processes data from the stream
  - **Standard Consumers**: Process data from shards
  - **Enhanced Fan-Out Consumers**: Get dedicated throughput (2 MB/second read capacity) without competing with other consumers

```diff
+ Producers → Send data to stream → Consumers read in parallel
- Single-threaded processing limits scalability
! Middleware pattern: Kinesis acts as intermediary for data flow
```

#### Consumer Throughput
- **Standard Consumers**: Share 2 MB/second read capacity per shard
- **Enhanced Consumers**: Each gets dedicated 2 MB/second capacity for isolated processing

### Code/Config Examples

#### Creating a Kinesis Data Stream via CLI
```bash
aws kinesis create-stream --stream-name web-stream --shard-count 3 --region us-east-1
```

#### Listing Available Shards
```bash
aws kinesis describe-stream --stream-name web-stream --region us-east-1
```

### Lab Demo: Basic Stream Operations
1. Create a stream with 3 shards
2. Verify stream creation via AWS CLI
3. Monitor shard distribution and capacity

## S3 Service Overview

### Overview
Amazon S3 (Simple Storage Service) is AWS's object storage solution designed for data availability, security, and scalability. It's commonly used for storing large volumes of data including backups, analytics datasets, and application data.

### Key Concepts

#### S3 Core Capabilities
- **Scalability**: Handles virtually unlimited data volumes (petabytes to exabytes)
- **Data Availability**: Industrial-leading durability and availability
- **Security Features**: Encryption, access controls, compliance capabilities
- **Use Cases**: Cloud-native applications, mobile apps, data lakes, backup storage
- **Storage Classes**: Cost-optimized options for different access patterns

```diff
+ Cost-effective storage with fine-grained access controls
- Traditional storage lacks native analytics integration
! S3 enables advanced analytics through data lake architectures
```

#### Management Features
- **Access Controls**: Bucket policies, IAM roles, fine-grained permissions
- **Data Organization**: Cost optimization through storage classes
- **Compliance**: Meets business, organizational, and regulatory requirements

### Tables: S3 Storage Classes Comparison

| Storage Class | Use Case | Retrieval Fee | Minimum Duration |
|---------------|----------|---------------|------------------|
| S3 Standard | Frequent access | None | None |
| S3 IA | Less frequent access | Per GB | 30 days |
| S3 Glacier | Archive/backup | Per GB | 90 days |
| S3 Deep Archive | Long-term retention | Highest | 180 days |

### Lab Demo: S3 Bucket Creation
1. Navigate to S3 console
2. Create bucket with unique name
3. Configure access permissions and encryption
4. Enable versioning for data protection

## Data Ingestion Methods to Kinesis

### Overview
Multiple approaches exist for ingesting data into Amazon Kinesis Data Streams, each suited for different use cases and requirements. This session covers four primary methods: SDK, Kinesis Producer Library (KPL), Kinesis Agent, and API Gateway.

### Key Concepts

#### Ingestion Method Comparison

| Method | Ease of Use | Throughput | Real-time Capability | Use Case |
|--------|-------------|------------|---------------------|----------|
| AWS SDK | Programmatic control | Variable | Highest (immediate) | Custom applications |
| Kinesis Producer Library (KPL) | Simplified development | High | Near real-time | High-volume producers |
| Kinesis Agent | No code required | Moderate | Real-time with delay | Log files, streaming data |
| API Gateway | HTTP interface | Variable | API-dependent | Web/mobile applications |

#### AWS SDK Method
- **Language Support**: JavaScript, Python, Java, .NET, etc.
- **Features**: 
  - Consistent APIs across AWS services
  - Built-in credential management, retries, serialization
  - Higher-level abstractions for simplified development

```javascript
// SDK usage example
const AWS = require('aws-sdk');
const kinesis = new AWS.Kinesis();

await kinesis.putRecord({
  StreamName: 'web-stream',
  Data: JSON.stringify({message: 'Hello Kinesis'}),
  PartitionKey: 'partition-1'
}).promise();
```

#### Kinesis Producer Library (KPL)
- **Purpose**: High-throughput data ingestion
- **Benefits**: Batch processing, compression, error handling
- **Language Support**: Primarily Java-based with cross-language support

#### Kinesis Agent
- **Functionality**: Standalone Java application for data collection
- **Features**:
  - Monitors file directories continuously
  - Handles file rotation and checkpointing
  - Delivers data reliably via HTTP protocol
  - Emits CloudWatch metrics for monitoring
- **Data Transformation**: Supports CSV-to-JSON conversion, custom processing

```yaml
# Agent configuration file (agent.json)
{
  "kinesis.endpoint": "kinesis.us-east-1.amazonaws.com",
  "flows": [
    {
      "filePattern": "/var/log/application/*.log",
      "kinesisStream": "web-stream",
      "partitionKeyOption": "RANDOM"
    }
  ]
}
```

#### API Gateway Integration
- **Function**: Provides HTTP interface to Kinesis streams
- **Benefits**: 
  - Fully managed API service
  - Scales automatically
  - Enables cross-origin access

### Lab Demo: Agent Configuration
1. Install Kinesis Agent on EC2 instance
2. Configure JSON file with stream settings
3. Test file monitoring and data transmission
4. Validate CloudWatch metric emission

## Kinesis Data Streams Practical Implementation

### Overview
This practical implementation demonstrates creating a Kinesis data stream, installing and configuring the Kinesis Agent, and establishing data flow from local files to the stream using IAM permissions and data transformation.

### Key Concepts

#### Stream Creation Process
```bash
# Create Kinesis stream with specified shards and region
aws kinesis create-stream --stream-name web-stream --shard-count 3 --region us-east-1

# Verify stream creation
aws kinesis describe-stream --stream-name web-stream
```

#### Agent Installation and Configuration
```bash
# Install Kinesis Agent
sudo yum install -y aws-kinesis-agent

# Verify installation
rpm -ql aws-kinesis-agent

# Check configuration directory
ls -la /etc/aws-kinesis/
```

#### IAM Role Configuration
**Required Permissions for EC2 Instance:**
- `AmazonKinesisFullAccess` - Full access to Kinesis services
- `CloudWatchLogsFullAccess` - Metric emission capabilities

**Role Attachment Process:**
1. Navigate to IAM console
2. Create new role for EC2 service
3. Attach required policies
4. Attach role to running EC2 instance

#### Data Processing Configuration
```json
{
  "kinesis.endpoint": "kinesis.us-east-1.amazonaws.com",
  "flows": [
    {
      "filePattern": "/app/data/*.csv",
      "kinesisStream": "web-stream",
      "partitionKeyOption": "RANDOM",
      "dataProcessingOptions": [
        {
          "optionName": "CSVTOJSON",
          "customFieldNames": ["id", "name", "mobile", "city"]
        }
      ]
    }
  ]
}
```

### Lab Demo: Complete Data Flow Setup
1. **Create Output Directory**: `mkdir /app/data && cd /app/data`
2. **Generate CSV Data**: Create sample CSV file with records
3. **Start Agent Service**: `sudo service aws-kinesis-agent start`
4. **Monitor Agent Logs**: `sudo service aws-kinesis-agent status && tail -f /var/log/aws-kinesis-agent/aws-kinesis-agent.log`
5. **Ingest Data**: Add new records to CSV file
6. **Verify Stream Data**: Check Kinesis console for ingested records

## Real-time Web Server Log Streaming

### Overview
This demonstration shows how to collect Apache web server access logs in real-time using the Kinesis Agent, with ETL processing to transform log data into structured JSON format for analytics and monitoring.

### Key Concepts

#### Web Server Log Integration
- **Log Source**: Apache access logs (`/var/log/httpd/access_log`)
- **Real-time Processing**: Agent monitors log files continuously
- **Data Flow**: Web requests → Apache logs → Kinesis Agent → Kinesis Stream → Consumers

#### ETL in Agent Configuration
```json
{
  "flows": [
    {
      "filePattern": "/var/log/httpd/access_log*",
      "kinesisStream": "web-log-stream",
      "logFormat": "COMMONAPACHELOG",
      "customFieldNames": [
        "client_ip",
        "client_ident",
        "auth_user",
        "timestamp",
        "request_method",
        "request_uri",
        "http_version",
        "status_code",
        "bytes_transferred",
        "referrer",
        "user_agent"
      ]
    }
  ]
}
```

### Tables: Apache Log Field Mapping

| Log Field | Description | Custom Field Name |
|-----------|-------------|-------------------|
| Client IP | IP address of requesting client | client_ip |
| Ident | RFC 1413 identity | client_ident |
| User | Authenticated username | auth_user |
| Timestamp | Request timestamp | timestamp |
| Request | HTTP request line | request_method, request_uri |
| Status | HTTP status code | status_code |
| Bytes | Response size in bytes | bytes_transferred |

### Lab Demo: Web Server Log Streaming
1. **Install Apache Web Server**:
   ```bash
   sudo yum install -y httpd
   sudo systemctl start httpd
   sudo systemctl enable httpd
   ```

2. **Create Test Web Pages**:
   ```bash
   sudo mkdir -p /var/www/html
   echo "Welcome to our web app" | sudo tee /var/www/html/index.html
   ```

3. **Configure Security Group**: Allow HTTP (port 80) traffic

4. **Update Agent Configuration**:
   - Modify `agent.json` for Apache log format
   - Restart agent service

5. **Generate Traffic**: Access web server via browser or curl

6. **Monitor Data Ingestion**: View records in Kinesis Data Viewer

## ETL Operations with Kinesis Agent

### Overview
ETL (Extract, Transform, Load) operations demonstrate the Kinesis Agent's capability to extract data from log files, transform it from various formats (CSV, log files) to JSON, and load it into Kinesis Data Streams for downstream processing.

### Key Concepts

#### Data Processing Options
```json
{
  "dataProcessingOptions": [
    {
      "optionName": "LOGTOJSON",
      "logFormat": "COMMONAPACHELOG"
    }
  ]
}
```

#### Supported Data Transformations

| Input Format | Processing Option | Output |
|--------------|-------------------|---------|
| CSV | CSVTOJSON | JSON with field mappings |
| Apache Logs | LOGTOJSON | JSON with parsed fields |
| Custom Logs | PATTERNTOJSON | JSON with regex patterns |

#### Log Format Recognition
- **Automatic Parsing**: Kinesis Agent recognizes common log formats
- **Field Extraction**: Extracts individual components from log entries
- **JSON Conversion**: Transforms unstructured logs into structured JSON

### Code/Config Examples

#### Custom Pattern Matching
```json
{
  "dataProcessingOptions": [
    {
      "optionName": "CSVTOJSON",
      "customFieldNames": ["timestamp", "level", "message"],
      "delimiter": "|"
    }
  ]
}
```

#### Error Handling and Reliability
- **Checkpointing**: Tracks processed data to prevent duplicates
- **File Rotation Handling**: Manages log file rollover scenarios
- **Retry Logic**: Automatic retry on transmission failures

### Lab Demo: ETL Processing
1. **Configure Data Processing Options in Agent JSON**
2. **Test with Sample Data**: Create log entries and monitor conversion
3. **Verify JSON Output**: Check Kinesis Data Viewer for structured data
4. **Handle File Rotation**: Test behavior with logrotate operations

## SDK Implementation - Producer and Consumer

### Overview
AWS SDK provides programmatic access to Kinesis Data Streams, enabling real-time data ingestion and consumption with immediate processing capabilities, eliminating batching delays present in other methods.

### Key Concepts

#### SDK vs Agent Comparison

```diff
+ SDK: Immediate data transmission (milliseconds)
- Agent: Batched processing (seconds delay)
+ SDK: Full programmatic control
- Agent: Configuration-driven processing
```

#### SDK Implementation Flow
1. **Import SDK Library**: Load AWS SDK for target language
2. **Initialize Service Client**: Create Kinesis client with credentials
3. **Send Data**: Use `putRecord` or `putRecords` operations
4. **Handle Responses**: Manage success/error responses

#### JavaScript/Node.js SDK Example
```javascript
const AWS = require('aws-sdk');
const kinesis = new AWS.Kinesis();

async function sendToKinesis(data, streamName) {
  const params = {
    StreamName: streamName,
    Data: JSON.stringify(data),
    PartitionKey: data.id || 'default-key'
  };
  
  try {
    const result = await kinesis.putRecord(params).promise();
    console.log('Record sent:', result.SequenceNumber);
  } catch (error) {
    console.error('Error sending record:', error);
  }
}
```

### Lab Demo: Basic SDK Producer
1. **Initialize AWS SDK in Node.js**
2. **Create Kinesis Client**: `const kinesis = new AWS.Kinesis();`
3. **Send Sample Records**: Use `putRecord` API
4. **Monitor CloudWatch Logs**: View execution traces
5. **Handle Errors**: Implement retry logic for failed operations

## Event-Driven Architecture with Lambda and S3

### Overview
This advanced use case demonstrates serverless ETL processing where S3 object uploads trigger Lambda functions to extract file data, transform it, and load into Kinesis Data Streams, creating an end-to-end event-driven analytics pipeline.

### Key Concepts

#### Event-Driven ETL Architecture
```
S3 Upload Event → Lambda Trigger → Extract Data → Transform → Load to Kinesis → Consumer Processing
```

#### Lambda Function Architecture
- **Event Source**: S3 PUT object events
- **Processing Steps**:
  1. Parse S3 event data to identify uploaded file
  2. Extract file content using S3 GetObject API
  3. Transform data (optional filtering, enrichment)
  4. Send to Kinesis using SDK

#### IAM Permissions Required
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "kinesis:PutRecord",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
```

### Code/Config Examples

#### S3 Event Notification Setup
```json
{
  "LambdaConfigurations": [
    {
      "Id": "S3EventTrigger",
      "LambdaFunctionArn": "arn:aws:lambda:region:account:function:ETLFunction",
      "Events": ["s3:ObjectCreated:*"],
      "Filter": {
        "Key": {
          "FilterRules": [
            {
              "Name": "Suffix",
              "Value": ".csv"
            }
          ]
        }
      }
    }
  ]
}
```

#### Serverless Benefits
- **Zero Management**: No servers to configure or maintain
- **Auto-scaling**: Lambda scales automatically with event volume
- **Cost-effective**: Pay only for execution time
- **Event-driven**: Processes data immediately upon upload

### Lab Demo: Serverless ETL Pipeline
1. **Create Lambda Function**: Set up Node.js runtime with required permissions
2. **Configure S3 Trigger**: Enable event notifications in S3 bucket
3. **Implement Data Extraction**: Use S3 SDK to read uploaded files
4. **Send to Kinesis**: Use Kinesis SDK to stream processed data
5. **Test End-to-End Flow**: Upload file and monitor Kinesis ingestion

## Summary

### Key Takeaways

```diff
+ Kinesis Data Streams provides scalable, real-time data streaming capabilities
+ Multiple ingestion methods (SDK, Agent, CLI) offer flexibility for different use cases
+ SDK provides immediate, programmatic data transmission without batching delays  
+ Agent excels at log file monitoring with built-in ETL transformation features
+ Serverless architectures (S3 + Lambda) enable event-driven data processing
+ Sharding enables parallel processing and consumer isolation
+ Enhanced fan-out consumers get dedicated throughput for high-performance needs
```

### Quick Reference

#### Common CLI Commands
```bash
# Create stream
aws kinesis create-stream --stream-name my-stream --shard-count 2

# Install agent
sudo yum install -y aws-kinesis-agent

# Start agent
sudo service aws-kinesis-agent start

# Check agent logs
tail -f /var/log/aws-kinesis-agent/aws-kinesis-agent.log
```

#### Agent Configuration Structure
```json
{
  "flows": [
    {
      "filePattern": "/app/data/*.csv",
      "kinesisStream": "my-stream",
      "dataProcessingOptions": [
        {
          "optionName": "CSVTOJSON"
        }
      ]
    }
  ]
}
```

#### SDK Basic Usage (JavaScript)
```javascript
const AWS = require('aws-sdk');
const kinesis = new AWS.Kinesis();

await kinesis.putRecord({
  StreamName: 'my-stream',
  Data: 'record data',
  PartitionKey: 'partition-key'
}).promise();
```

### Expert Insight

#### Real-world Application
Kinesis Data Streams powers real-time analytics for streaming data from IoT devices, clickstream analysis, and log aggregation. In production environments, combine with Kinesis Analytics for real-time SQL processing or Lambda for event-driven transformations. Use enhanced fan-out for mission-critical consumer applications requiring guaranteed throughput.

#### Expert Path
Master Kinesis by understanding shard management, partition key strategies, and consumer scaling. Learn to implement custom consumers using KCL (Kinesis Client Library) for advanced processing logic. Study CloudWatch metrics for performance monitoring and automated scaling based on throughput patterns.

#### Common Pitfalls
- **Partition Key Selection**: Poor partition keys cause uneven shard utilization
- **Shard Limit Awareness**: Monitor shard capacity (1 MB/s write, 2 MB/s read) 
- **Data Retention**: Default 24-hour retention may require configuration for longer storage
- **Consumer Iterator Management**: TRIM_HORIZON vs LATEST affects data resumption after consumer restarts

#### Lesser-Known Facts
- Enhanced fan-out uses HTTP/2 push for 65% better performance than standard polling
- Kinesis can handle up to 500 shards per stream by default (quotas can be increased)
- Agent supports custom preprocessing scripts for complex data transformations
- SDK operations can be batched using putRecords for cost optimization

🛠 Generated with [Claude Code](https://claude.com/claude-code)
🤖 KK-CS45-V3

Co-Authored-By: Claude <noreply@anthropic.com>
