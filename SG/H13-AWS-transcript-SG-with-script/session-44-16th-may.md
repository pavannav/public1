# Session 44: Ingesting Data Using SDK in Kinesis Data Streams

## Table of Contents
- [Ingestion with SDK and Kinesis Data Streams](#ingestion-with-sdk-and-kinesis-data-streams)
  - [Overview](#overview)
  - [Key Concepts](#key-concepts)
  - [Producer and Consumer Workflow](#producer-and-consumer-workflow)
  - [Lab Demo: S3-to-Kinesis Producer with Lambda](#lab-demo-s3-to-kinesis-producer-with-lambda)
  - [Using Kinesis Agent for Logs](#using-kinesis-agent-for-logs)
  - [Lab Demo: Consumer Lambda Triggered by Kinesis](#lab-demo-consumer-lambda-triggered-by-kinesis)
- [Summary](#summary)
  - [Key Takeaways](#key-takeaways)
  - [Quick Reference](#quick-reference)
  - [Expert Insight](#expert-insight)

## Ingestion with SDK and Kinesis Data Streams

### Overview
This session explores ingesting data into Amazon Kinesis Data Streams (KDS) using AWS SDKs. It covers setting up producers to send data from sources like web server logs via S3 and Lambda, and consumers to process records in real-time. The focus is on real-time data streaming, shard management, partition keys, and integration with services like S3, Lambda, and CloudWatch, emphasizing SDK-based approaches for low-latency processing.

### Key Concepts
- **Kinesis Data Streams (KDS)**: A persistent, ordered collection of data records partitioned by shards. Producers ingest data, and consumers retrieve it based on shard management and partition hashes.
- **Producer with SDK**: SDK enables producers to send records directly to KDS with data and partition keys. Partition keys determine shard placement for categorization.
- **Consumer with SDK**: Consumers can poll KDS for records, processing data on arrival. Event-driven consumers use triggers for automation.
- **Partition Key**: User-defined key for data grouping; affects shard distribution to balance load.
- **Shards**: Units of KDS throughput; managed via provisioned mode with read/write capacity.
- **Lambda Integration**: Serverless function for ETL operations, triggered by events (e.g., S3 uploads or KDS records).
- **Event-Driven Architecture**: Services trigger Lambdas on events, enabling real-time processing without manual polling.
- **JSON Standard for Data**: Converted data into JSON format for interoperability across AWS services.

> [!IMPORTANT]
> SDK-based ingestion provides real-time capabilities, contrasting with agent-based methods that introduce delays.

### Producer and Consumer Workflow

```mermaid
flowchart TD
    A[Client Uploads Data to S3] --> B[S3 Triggers Lambda Producer]
    B --> C[Lambda Retrieves Data from S3]
    C --> D[Lambda Converts Data to JSON]
    D --> E[Lambda Sends Records to KDS with Partition Key]
    E --> F[KDS Stores Records in Shards]
    F --> G[KDS Triggers Consumer Lambda]
    G --> H[Consumer Lambda Processes Records]
    H --> I[Store/Send Data (e.g., Mail, DB)]
```

### Lab Demo: S3-to-Kinesis Producer with Lambda
In this demo, web server logs are uploaded to S3, triggering a Lambda producer to ingest into KDS.

- Create S3 bucket and Lambda function with Node.js, IAM roles for S3, KDS, and CloudWatch access.
- Configure S3 event trigger for Lambda (put object events).
- Lambda code (JavaScript example):
  ```javascript
  const AWS = require('aws-sdk');
  const S3 = new AWS.S3();
  const Kinesis = new AWS.Kinesis();

  exports.handler = async (event) => {
      const bucketName = event.Records[0].s3.bucket.name;
      const keyName = event.Records[0].s3.object.key;
      
      const paramsGet = { Bucket: bucketName, Key: keyName };
      const data = await S3.getObject(paramsGet).promise();
      const dataString = data.Body.toString();
      
      const payload = { data: JSON.stringify(dataString) };
      const partitionKey = "session44-may2023";
      const paramsPut = { StreamName: "linux-world-kds", Data: JSON.stringify(payload), PartitionKey: partitionKey };
      const response = await Kinesis.putRecord(paramsPut).promise();
      
      console.log("Partition Key:", partitionKey);
      console.log("Data:", dataString);
      console.log("Kinesis Response:", response);
      return response;
  };
  ```
- Upload a test file (e.g., `customer_data.csv`) to S3; Lambda auto-sends JSON to KDS.
- Verify in Kinesis Data Viewer: Records appear with partition key, sequence number, and shard ID.

> [!NOTE]
> Use Node.js 14/16 over 18 for compatibility in batch processing.

### Using Kinesis Agent for Logs
- Configure agent to ingest web server logs from EC2 (e.g., Apache logs at `/var/log/httpd/access_log`).
- Agent configuration (JSON):
  ```json
  {
    "flows": [
      {
        "filePattern": "/var/log/httpd/access_log",
        "kinesisStream": "my-log-stream",
        "format": "log",
        "transform": ["convert_to_json"]
      }
    ]
  }
  ```
- Transform logs to JSON; ensure file permissions with `chmod o+rx`.
- Restart agent; monitor logs.

### Lab Demo: Consumer Lambda Triggered by Kinesis
- Create consumer Lambda with Node.js, add KDS trigger (latest iterator).
- Lambda code (JavaScript example):
  ```javascript
  const AWS = require('aws-sdk');
  const Kinesis = new AWS.Kinesis();

  exports.handler = async (event) => {
      for (const record of event.Records) {
          const dataPayload = JSON.parse(Buffer.from(record.kinesis.data, 'base64').toString());
          console.log("Consumed Data:", dataPayload.data);
          console.log("Partition Key:", record.kinesis.partitionKey);
          console.log("Sequence Number:", record.kinesis.sequenceNumber);
          // Additional actions: Send to mail, DB, etc.
      }
  };
  ```
- Upload data to S3; view consumer logs in CloudWatch, showing decoded JSON data, partition keys, and sequence numbers.

| Aspect | Producer Lambda | Consumer Lambda |
|--------|-----------------|-----------------|
| Trigger | S3 Event | KDS Event |
| Role | ETL (Transform to JSON, Send to KDS) | Process Records |
| SDK | PutRecord | Event Handling |
| Example | Data Ingestion | Mail/SMS/DB Storage |

## Summary

### Key Takeaways
```diff
+ Real-time SDK-based ingestion eliminates agent delays for instant data flow.
- Avoid random partition keys if uniform shard distribution isn't needed.
! Event-driven Lambdas automate producer-consumer pipelines using AWS services.
```

### Quick Reference
- **Commands**: `npm install aws-sdk`, `chmod o+rx /path/to/file`, `aws kinesis put-record --stream-name <name>`
- **SDK APIs**: `putRecord` (producer), `getObject` (S3), event parsing (consumer)
- **IAM Policies**: Attach S3ReadWrite, KinesisStreams, CloudWatchLogs for Lambdas
- **Node.js Version**: Use 14/16 for performance in frequent executions

### Expert Insight
#### Real-world Application
SDK-powered pipelines enable instant alert systems (e.g., ingesting sensor data from IoT devices into KDS for anomaly detection). In production, scale shards dynamically and optimize partition keys for balanced throughput.

#### Expert Path
Master shard management with `describe-stream` API for monitoring capacity. Experiment with KCL (Kinesis Client Library) for advanced consumer load balancing—greater efficiency than manual polling.

#### Common Pitfalls
- **Delayed Agent Ingestion**: Use SDK for real-time; agents batch-process with 10-20s lag.
- **Partition Key Misdesign**: Leads to uneven shards—test hashes beforehand.
- **Lambda Cold Starts**: In high-frequency setups, avoid Python for faster JavaScript runtime.
- **Permission Issues**: Ensure EC2 IM roles for agent; verify S3/KDS access logs.

#### Lesser-Known Facts
Kinesis uses MD5 hashing for partition key mapping to shards; sequence numbers enable exact record retrieval without full scans. Also, base64-encoded data in KDS events supports binary payloads beyond JSON.
