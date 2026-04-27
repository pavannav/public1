# Session 42: AWS Kinesis Data Streams Deep Dive and Agent Demo

## Table of Contents

- [AWS Kinesis Revision](#aws-kinesis-revision)
- [Kinesis Services Overview](#kinesis-services-overview)
- [Batch vs Real-time Processing](#batch-vs-real-time-processing)
- [Kinesis Data Streams Details](#kinesis-data-streams-details)
- [Practical Demo: Creating a Data Stream](#practical-demo-creating-a-data-stream)
- [Producer and Consumer Concepts](#producer-and-consumer-concepts)
- [Using CloudShell for Commands](#using-cloudshell-for-commands)
- [Partition Keys and Hash Functions](#partition-keys-and-hash-functions)
- [Putting and Consuming Records](#putting-and-consuming-records)
- [Detailed Demo: Kinesis Agent Installation](#detailed-demo-kinesis-agent-installation)
- [Agent Configuration and Data Processing](#agent-configuration-and-data-processing)
- [Troubleshooting and Metrics](#troubleshooting-and-metrics)
- [Summary](#summary)
  - [Key Takeaways](#key-takeaways)
  - [Quick Reference](#quick-reference)
  - [Expert Insight](#expert-insight)

## AWS Kinesis Revision

### Overview
This session revisits AWS Kinesis from previous classes, focusing on Kinesis Data Streams (KDS). Kinesis is a serverless streaming data service for collecting, processing, and storing large streams of data records in real time.

### Key Concepts
Kinesis enables real-time data analytics on streaming data. It supports applications that process data streams at scale, with auto-scaling capabilities. Key use cases include analyzing customer purchase data, server logs, or app clickstreams.

- **Big Data Characteristics**: Data with greater volume, velocity, and variety (3Vs).
- **Scaling Data**: Exploiting parallel computing resources for large datasets.
- **Data Streaming**: Continuously generated data in small record sizes from multiple sources simultaneously.

## Kinesis Services Overview

### Overview
Kinesis is a large family of services under Amazon Kinesis, consisting of four main components: Kinesis Data Streams, Kinesis Data Firehose, Kinesis Video Streams, and Kinesis Data Analytics.

### Key Concepts
- **Kinesis Data Streams**: Core service for real-time capture and storage of data streams.
- **Kinesis Data Firehose**: For loading streaming data into data lakes or analytics services.
- **Kinesis Data Analytics**: For analyzing streaming data using SQL.
- **Kinesis Video Streams**: Specialized for video data processing.

Each service addresses different aspects of the data pipeline: collection, storage, processing, and analysis.

## Batch vs Real-time Processing

### Overview
Distinguishing between batch and real-time processing is fundamental for data handling strategies.

### Key Concepts
- **Batch Processing**: Analyzes stored data, suitable for historical insights.
- **Real-time Processing**: Analyzes live-generated data, enabling immediate responses.

### Comparisons
| Aspect              | Batch Processing                  | Real-time Processing             |
|---------------------|-----------------------------------|----------------------------------|
| Data Source         | Stored data                       | Live data streams                |
| Timing              | Scheduled or periodic             | Continuous and instantaneous     |
| Use Cases           | Historical reports, trends       | Fraud detection, alerts         |
| Scale               | High volume, lower velocity      | High velocity, real-time action  |

Batch processing handles already-collected data, while real-time focuses on streaming data like customer purchases or server logs.

## Kinesis Data Streams Details

### Overview
Kinesis Data Streams (KDS) is used for real-time data analysis, collecting and processing large data streams at scale.

### Key Concepts
- **Serverless**: No server management required; AWS handles scaling.
- **Throughput**: Highest throughput among streaming services, capable of handling massive data volumes.
- **Data Retention**: Configurable retention period, defaulting to 1 day, extendable for analysis needs.

KDS simplifies the collection and storage of data streams, with auto-scaling based on data volume.

## Practical Demo: Creating a Data Stream

### Overview
Demonstrates creating a Kinesis data stream via the AWS console and CLI, including capacity modes.

### Key Concepts
- **Capacity Modes**:
  - **Provisioned**: Specify exact shard count based on known data volume.
  - **On-demand**: Auto-scaling shards, ideal for variable traffic.
- **Shards**: Units of capacity providing 1 MB/s write and 2 MB/s read throughput.
- **Billing**: Charged per shard-hour for storage and records written.
- **Data Retention Period**: Configurable, e.g., 1 day, after which data is deleted.

### Lab Demo: Creating Product Purchase Data Stream
1. Access AWS Console > Kinesis > Create Stream.
2. Name: "product-purchased".
3. Select mode: Provisioned, add shards (e.g., 3) for scaling.
4. Configure retention.

Or via CLI:
```bash
aws kinesis create-stream --stream-name product-purchased --shard-count 3
```

Status becomes "Active" upon creation.

## Producer and Consumer Concepts

### Overview
Producers send records to KDS, while consumers retrieve and analyze them.

### Key Concepts
- **Producer**: Generates and puts records (data and partition key) into shards.
- **Consumer**: Reads records for processing; can be multiple consumers per shard.
- **Record Order**: Maintained via sequence numbers in shards.

Unlike queues (FIFO), shards allow multiple consumers and random access to records.

## Using CloudShell for Commands

### Overview
AWS CloudShell provides a browser-based shell for running AWS commands without local setup.

### Key Concepts
- Pre-installed Linux with AWS CLI.
- IM role attachment for authentication.
- Commands like AWS Kinesis describe-stream for stream details.

Example Commands:
```bash
aws kinesis describe-stream --stream-name product-purchased
```

Convert data formats using base64 encoding for uploads.

## Partition Keys and Hash Functions

### Overview
Partition keys route records to specific shards using hashing.

### Key Concepts
- **Partition Key**: User-defined key for categorization, specified by producers.
- **MD5 Hash Function**: Converts partition key to 128-bit integer, mapping to shards.
- **Hash Range**: Shards have assigned hash ranges (e.g., 0 to max value).
- **Sharding**: Distributes data across multiple shards for parallel processing.

## Putting and Consuming Records

### Overview
Demonstrates putting records into streams and consuming them via CLI.

### Key Concepts
- **Putting Records**: Use `put-record` to insert data with partition keys.
- **Shard Iterator**: Pointer for reading data from shards (e.g., TRIM_HORIZON for start).
- **Consuming**: Get records using shard iterators, decode base64 for original data.

Example Flow:
```bash
aws kinesis put-record --stream-name product-purchased --data "record-data-base64" --partition-key "key"
aws kinesis get-shard-iterator --stream-name product-purchased --shard-id shardId-000000000001 --shard-iterator-type TRIM_HORIZON
aws kinesis get-records --shard-iterator iterator-id
```

### Sequence Flows
! Producer → Put Record → Shard (with Partition Key)  
! Consumer → Get Shard Iterator → Read Records

## Detailed Demo: Kinesis Agent Installation

### Overview
Kinesis Agent collects data from sources like log files and sends to KDS, especially useful on-premises.

### Key Concepts
- **Agent Program**: Java-based, monitors file tails for new data.
- **Installation**: Via Yum on Linux systems.
- **Configuration**: In `/etc/aws-kinesis/agent.json`, specifying file patterns and stream names.
- **IM Roles**: Attach roles for EC2 authentication; use access keys for on-premises.

Installation Commands:
```bash
sudo yum install aws-kinesis-agent
```

Service Management:
```bash
sudo service aws-kinesis-agent start
sudo service aws-kinesis-agent status
```

Key Points: Agent does not send historical data, only tail-end new data. Ideal for real-time use cases like web server logs.

## Agent Configuration and Data Processing

### Overview
Configuring agent for specific files, including data format conversions.

### Key Concepts
- **File Pattern**: List of files to monitor.
- **Data Processing Options**: Pre-process data at agent, e.g., convert CSV to JSON.
- **Field Mappings**: Define column names for structured data.

Example `agent.json`:
```json
{
  "cloudwatch.endpoint": "",
  "cloudwatch.emitMetrics": false,
  "firehose.endpoint": "",
  "flows": [
    {
      "filePattern": "/path/to/customer-data.csv",
      "deliveryStream": "",
      "initialPosition": "START_OF_FILE",
      "kinesisStream": "product-purchased",
      "dataProcessingOptions": [
        {
          "optionName": "CSVTOJSON",
          "customFieldNames": ["customer_id", "name", "phone", "city"],
          "delimiter": ","
        }
      ]
    }
  ]
}
```

Agent appends new lines to files, processes them (e.g., CSV → JSON), and sends to KDS.

## Troubleshooting and Metrics

### Overview
Handling common issues and monitoring via CloudWatch.

### Key Concepts
- **Logs**: Agent logs in `/var/log/aws-kinesis-agent/aws-kinesis-agent.log`.
- **Errors**: Common issues with IM permissions, data formats, or CloudWatch metrics.
- **Metrics in CloudWatch**: Tracks records sent, errors; attach `CloudWatchFullAccess` policy.

Common Issues:
- Data not appearing: Agent only reads file tails; historical data ignored.
- Delays: Agent polling intervals.

## Summary

### Key Takeaways
```diff
+ Kinesis Data Streams provides scalable, real-time data ingestion and processing
+ Agents simplify data collection from files without code changes
+ Shards and partition keys enable parallel processing and data distribution
- Batch processing suits historical data, while real-time handles streaming
+ Producers define partition keys for record routing
+ Consumers can read data multiple times, unlike traditional queues
```

### Quick Reference
- **Create Stream (Provisioned)**: `aws kinesis create-stream --stream-name my-stream --shard-count 1`
- **Put Record**: `aws kinesis put-record --stream-name my-stream --data "data" --partition-key "key"`
- **Install Agent**: `sudo yum install aws-kinesis-agent`
- **Agent Config Path**: `/etc/aws-kinesis/agent.json`
- **Data Format Conversion**: Use "CSVTOJSON" option in `dataProcessingOptions`

### Expert Insight
#### Real-world Application
In e-commerce, use Kinesis for analyzing purchase streams: Count transactions by region, detect anomalies, or trigger notifications. Integrate with Lambda for serverless processing or S3 for archival.

#### Expert Path
Master partition key strategies for even data distribution; explore Kinesis Producer Library (KPL) for optimized Java/Python apps; compare with alternatives like Kinesis Firehose for ETL simplicity. Practice scaling shards dynamically via on-demand mode.

#### Common Pitfalls
- **Over-provisioning Shards**: Leads to unnecessary costs; monitor throughput vs. capacity.
- **Ignoring Retention**: Lose data if not consumed within retention period; extend strategically.
- **File Monitoring Gaps**: Agent skips historical data; pre-populate if needed.
- **IM Permission Issues**: Ensure EC2 roles include Kinesis write and CloudWatch access.

#### Lesser-Known Facts
Partition keys support regex-like categorization via hashing; Kinesis supports both text and binary data (e.g., images via base64); agent can be customized for multi-stream outputs, enabling complex pipelines without additional infrastructure.
