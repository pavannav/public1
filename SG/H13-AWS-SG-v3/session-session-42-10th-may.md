# Session 42: AWS Kinesis Data Streams

**Table of Contents**
- [Revisions and Foundations](#revisions-and-foundations)
- [Core Concepts](#core-concepts)
- [Data Stream Creation](#data-stream-creation)
- [Partitioning and Sharding](#partitioning-and-sharding)
- [Producers and Consumers](#producers-and-consumers)
- [Data Ingestion with Agent](#data-ingestion-with-agent)
- [Summary](#summary)

## Revisions and Foundations

### Overview
This session provides a comprehensive revision and deep dive into AWS Kinesis, focusing on data streaming concepts, Kinesis Data Streams architecture, and practical implementation using various methods for data ingestion.

### Key Concepts / Deep Dive

#### AWS Kinesis Overview
AWS Kinesis is a serverless streaming data service for real-time data processing and analysis. It captures, processes, and stores data streams at any scale. The service consists of four main components:
- **Kinesis Data Streams**: For real-time data streaming and processing
- **Kinesis Data Firehose**: For data delivery to destinations
- **Kinesis Data Analytics**: For real-time SQL processing and analytics
- **Kinesis Video Streams**: For video streaming applications

#### Batch vs Real-time Processing
**Batch Processing:**
- Analysis done on already stored data
- Processing historical data that's been stored
- Used for periodic analysis and reporting

```diff
- Batch Processing: Works with stored data that may not be time-sensitive
```

**Real-time Processing:**
- Analysis done on live, continuously generated data
- Processes data as it streams in
- Enables immediate insights and actions

```diff
+ Real-time Processing: Processes streaming data as it arrives for immediate analysis
```

#### Key Data Streaming Concepts
**Data Streams:**
- Continuously generated data from thousands of sources
- Data records sent simultaneously in small sizes
- Used when data analysis needs to be done on real-time data

**Big Data Characteristics (3V's):**
- **Volume**: Large amounts of data
- **Variety**: Different data types and formats
- **Velocity**: High speed of data generation and processing

**Scaling Data:**
- Ability of hardware/software systems to exploit increasing computing resources effectively for analyzing large datasets

**Serverless Architecture:**
- Cloud-native development model allowing build and running applications without managing servers

**Throughput:**
- Amount of data moved successfully from one place to another in a given period of time

Important corrections:
- "sereless" → "serverless"
- "cinsics" → "Kinesis"
- "Kynes's" → "Kinesis"

## Core Concepts

### Deep Dive into Shards and Throughput

Shards are the fundamental units of capacity in Kinesis:
- Base capacity: Each shard provides 1 MB/second write capacity and 2 MB/second read capacity
- Scaling: Multiple shards can be created for increased throughput
- Billing: Charged hourly based on shard count, plus data records written

### Data Retention
- Default retention: 24 hours
- Can be extended but with additional costs
- Data automatically deleted after retention period expires from shards

## Data Stream Creation

### Overview
Kinesis Data Streams can be created with two capacity modes:
- **Provisioned Mode**: Predefined shard capacity based on known data volumes
- **On-demand Mode**: Automatic scaling of shards based on usage patterns

### Lab Demo: Creating a Kinesis Data Stream

#### Provisioned Mode Configuration
```bash
# Create stream using AWS CLI
aws kinesis create-stream \
  --stream-name product-purchased \
  --shard-count 3 \
  --region us-east-1
```

**Capacity Planning:**
- Writing capacity: 1000 records/second per shard
- Reading capacity: 2 MB/second per shard
- Multiple shards can be added based on throughput requirements

#### On-demand Mode Configuration
```bash
# Create on-demand stream
aws kinesis create-stream \
  --stream-name autoscaling-stream \
  --stream-mode-details StreamModeSummaries=ON_DEMAND
```
> [!NOTE]
> On-demand mode automatically scales shards based on real-time traffic patterns without manual configuration.

### Billing Considerations
- Shard costs: Fixed hourly rate
- Data records: Cost per record written
- Retention extension: Additional costs for longer retention periods

## Partitioning and Sharding

### Overview
Partitioning distributes data across shards using partition keys to determine shard assignment.

### Partition Keys and Hashing
- Records require a partition key provided by the producer
- AWS Kinesis uses MD5 hash function to map partition keys to shards
- Hash range: 0 to 2^128 - 1 (128-bit integer space)

### Hash Key Ranges
```mermaid
graph TD
    A[Shard ID 0] --> B[Hash Key Range: 0 - (340282366920938463463374607431768211455/3)]
    C[Shard ID 1] --> D[Hash Key Range: (340282366920938463463374607431768211455/3)+1 - (2*340282366920938463463374607431768211455/3)]
    E[Shard ID 2] --> F[Hash Key Range: (2*340282366920938463463374607431768211455/3)+1 - 340282366920938463463374607431768211455]
```

### Sequence Numbers
- Every record receives a sequence number
- Maintains order within each shard
- Enables consumers to track processing position

## Producers and Consumers

### Overview
Kinesis Data Streams uses producer-consumer architecture.

#### Producers
- Applications/services that send data to the stream
- Provide payload data and partition key
- Can be applications, IoT devices, web services, or agents

#### Consumers
- Applications that read and process data from streams
- Can process same data multiple times
- Multiple concurrent consumers supported per shard

### Shard Iterator
Pointer specifying the shard position for reading data:
- **TRIM_HORIZON**: Starting from the oldest retained record
- **LATEST**: Starting from the most recent records

## Data Ingestion with Agent

### Overview
Kinesis Agent provides a pre-built solution for data collection on Linux systems.

### Lab Demo: Installing and Configuring Kinesis Agent

#### Installation
```bash
# Install Kinesis Agent on Amazon Linux
sudo yum install -y aws-kinesis-agent
```

#### Configuration Structure
The agent configuration file (`/etc/aws-kinesis/agent.json`) defines data flows:

```json
{
  "cloudwatch.emitMetrics": true,
  "kinesis.endpoint": "kinesis.us-east-1.amazonaws.com",
  "flows": [
    {
      "filePattern": "/var/log/web/nginx.log",
      "dataProcessingOptions": [
        {
          "optionName": "CONVERT_CSV_TO_JSON",
          "customFieldNames": ["timestamp", "level", "message"]
        }
      ],
      "kinesisStream": "web-access-stream",
      "partitionKeyOption": "RANDOM"
    }
  ]
}
```

#### File Monitoring
- **Tail Mechanism**: Monitors only new records appended to files
- **Real-time Streaming**: Captures data as it's written
- **Existing Data Limitation**: Only processes new file appends, not historical files

#### Data Processing Options
The agent can preprocess data before sending to Kinesis:

**CSV to JSON Conversion:**
```json
{
  "dataProcessingOptions": [
    {
      "optionName": "CSV_TO_JSON",
      "delimiter": ",",
      "customFieldNames": ["customer_id", "name", "phone", "city"]
    }
  ]
}
```

### IAM Role Configuration
Required IAM policy for data ingestion:
```json
{
  "Version": "2012-10-17",
  "Type": "AWS::IAM::Role",
  "Properties": {
    "RoleName": "KinesisAgentRole",
    "AssumeRolePolicyDocument": {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "ec2.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
        }
      ]
    },
    "Policies": [
      {
        "PolicyName": "KinesisWritePolicy",
        "PolicyDocument": {
          "Version": "2012-10-17",
          "Statement": [
            {
              "Effect": "Allow",
              "Action": [
                "kinesis:PutRecord",
                "kinesis:PutRecords"
              ],
              "Resource": "arn:aws:kinesis:*:*:stream/*"
            }
          ]
        }
      },
      {
        "PolicyName": "CloudWatchMetricsPolicy",
        "PolicyDocument": {
          "Version": "2012-10-17",
          "Statement": [
            {
              "Effect": "Allow",
              "Action": [
                "cloudwatch:PutMetricData"
              ],
              "Resource": "*"
            }
          ]
        }
      }
    ]
  }
}
```

### Starting the Agent Service
```bash
# Start the Kinesis Agent service
sudo service aws-kinesis-agent start

# Check service status
sudo service aws-kinesis-agent status

# View logs
tail -f /var/log/aws-kinesis-agent/aws-kinesis-agent.log
```

### ETL Processing
Agent performs Extract-Transform-Load (ETL) operations:
- **Extract**: Reads new records from monitored files
- **Transform**: Converts formats, adds metadata
- **Load**: Sends processed data to Kinesis

### CloudWatch Metrics
Agent automatically sends metrics to CloudWatch:
- Records processed
- Records sent successfully
- Errors encountered

## Summary

### Key Takeaways
```diff
+ Kinesis Data Streams enables real-time data streaming with automatic scaling
+ Shards provide capacity units with 1 MB write/2 MB read per shard
+ Partition keys determine data distribution across shards using MD5 hashing
+ Kinesis Agent simplifies data ingestion from files with ETL capabilities
+ Serverless architecture eliminates infrastructure management overhead
+ Data streams support multiple consumers reading same data simultaneously
+ Retention periods can be configured with additional costs
+ On-demand mode provides automatic scaling without manual shard management
+ Partition keys are mandatory for every record
+ Agent works on trail-based monitoring for real-time incremental data
```

### Quick Reference

**Common Commands:**
```bash
# Create stream
aws kinesis create-stream --stream-name my-stream --shard-count 2

# Describe stream
aws kinesis describe-stream --stream-name my-stream

# Put record
aws kinesis put-record --stream-name my-stream --data "test data" --partition-key "key1"

# Get records
aws kinesis get-records --shard-iterator iterator-value

# List streams
aws kinesis list-streams
```

**Common Issues:**
- **Metrics not appearing**: Ensure CloudWatch permissions are attached to EC2 role
- **Historical data not ingested**: Agent only processes new file appends, not existing data
- **Partition key missing**: Every record requires a partition key

### Expert Insight

#### Real-world Application
Kinesis Data Streams powers real-time analytics for:
- **E-commerce**: Real-time inventory tracking and personalized recommendations
- **IoT**: Device telemetry data collection from millions of sensors
- **Log Analytics**: Centralized logging and monitoring systems
- **Social Media**: Real-time sentiment analysis and trending topics
- **Financial Services**: Fraud detection and market data analysis

#### Expert Path
**Master Kinesis by:**
1. Practicing with different data sources (web logs, IoT data, application metrics)
2. Understanding producer libraries (SDK vs KPL) for high-throughput scenarios
3. Implementing consumer applications with different processing strategies
4. Monitoring performance with CloudWatch metrics and alarms
5. Designing fault-tolerant architectures with on-demand scaling
6. Exploring integration patterns with Lambda, Firehose, and analytics tools

#### Common Pitfalls
- **Overprovisioning**: Using on-demand mode instead of provisioned for predictable loads
- **Hot shard issues**: Poor partition key selection causing uneven data distribution
- **Retention period neglect**: Not configuring longer retention for consumer lag scenarios
- **Agent file monitoring**: Assuming historical data will be ingested automatically
- **IAM permission mistakes**: Insufficient permissions causing silent failures

#### Lesser-Known Facts
- Kinesis creates hash values in 128-bit space for shard assignment precision
- Agent's tail-based monitoring provides millisecond-level latency for new data
- On-demand mode can scale to thousands of shards automatically
- Partition key rotation techniques can optimize shard utilization
- Cross-shard ordering isn't guaranteed - order is maintained only within individual shards

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
KK-CS45-V3
