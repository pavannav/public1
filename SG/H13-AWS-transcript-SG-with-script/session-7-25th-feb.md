# Session 7: AWS Serverless Introduction

## Table of Contents
- [Overview](#overview)
- [Serverless Fundamentals](#serverless-fundamentals)
- [AWS Lambda Basics](#aws-lambda-basics)
- [Events and Triggers](#events-and-triggers)
- [Lab Demo: Lambda Setup and Testing](#lab-demo-lambda-setup-and-testing)
- [Lab Demo: S3 Trigger Integration](#lab-demo-s3-trigger-integration)
- [Serverless Project: Automatic Audio Transcription](#serverless-project-automatic-audio-transcription)
- [Permissions and IAM Roles](#permissions-and-iam-roles)
- [Troubleshooting and Best Practices](#troubleshooting-and-best-practices)
- [Summary](#summary)

## Overview
This session provides a comprehensive introduction to AWS Serverless computing, focusing on the shift from traditional server-based architectures to fully managed serverless services. We'll explore why serverless is critical in modern cloud computing, its benefits, and practical implementations using AWS services like Lambda, S3, and Transcribe. The instructor guides participants from basics to building a real-world project that mimics Netflix's use case for automatic audio transcription.

## Serverless Fundamentals

### What is Traditional Server-Based Architecture?
- **Server Management**: Everything starts with required hardware resources (CPU, RAM).
  - CPU and RAM form the foundation for running an operating system (e.g., Amazon Linux, Windows).
  - Operating system hosts applications/programs.
- **Use Cases**: Applications or programs need servers to run functions/features continuously.
- **Challenges**:
  - **Cost**: Pay hourly/daily even when not in use.
  - **Manual Scaling**: Monitor metrics via CloudWatch, scale up/down manually or via Auto Scaling Groups.
  - **Management Overhead**: Setup OS, runtime (Python interpreter, Node.js runtime), deploy applications, monitoring, logging, security.

**Example Flow**:
```
Client → Server (EC2 instance) → OS → Application → Functions
```

### Understanding Functions in Applications
- Applications consist of multiple functions, each handling specific features (e.g., play, stop, search in media player).
- Even large applications like Facebook have specific functions that users utilize selectively.
- Clients rarely use entire applications simultaneously.

**Key Insight**: Why run all functions constantly when only a few are needed?

### Shift to Serverless: Fully Managed Services
- **Definition**: Serverless ≠ no servers, but servers are hidden and fully managed by AWS.
- **Core Concept**: Don't manage infrastructure; AWS handles everything.
- **Benefits**:
  - **Zero Warming Costs**: Pay only when functions run (per invocation + duration).
  - **Automatic Scaling**: Scale infinitely based on demand.
  - **Built-in Monitoring/Logging**: Integrated with CloudWatch metrics and logs.
- **Pricing Model Example**:
  - Per-request pricing (e.g., $0.0000002 per request up to 1M free requests).
  - Per-millisecond duration pricing for compute time.
  - Free tier: 1M invocations/month.

**Shift Diagram**:
```diff
! On-Premises/Server World → Cloud Server Management → Serverless (Zero Management)
```

### Real-World Serverless Examples
- **S3 (Object Storage)**: Upload/download data without managing storage servers.
- **Lambda (Function as a Service - FaaS)**: Run code/functions on-demand without managing compute servers.

## AWS Lambda Basics

### What is AWS Lambda?
- **Service Name**: AWS Lambda
- **Tagline**: Run code/programs without managing servers.
- **Function as a Service (FaaS)**: Deploy and run individual functions.
- **Supported Runtimes**: Python, Java, Node.js, .NET, Ruby, Go, etc.
- **No Runtime Management**: AWS provides pre-installed runtimes and libraries.

**Key Features**:
- **Event-Driven**: Functions run in response to events (e.g., S3 actions, API calls).
- **Pay-Per-Use**: Charged only when running (per invocation + GB-seconds).
- **Automatic Scaling**: Handles thousands of concurrent executions.

### Lambda Handler and Code Structure
- **Handler Function**: Entry point to the code (e.g., `my_hello` in Python file `hello.py`).
- **Function Requirements**:
  - Take two parameters: `event` (input data) and `context` (metadata).
  - Return output (response).
- **Example Python Code**:
  ```python
  def my_hello(event, context):
      return 'I am Vimel Daga'
  ```

**Default Structure**:
```json
{
  "event": {
    "name": "Vimel Daga"
  },
  "context": {
    "function_name": "my-function",
    "version": "$LATEST"
  }
}
```

### Deployment and Runtime
- **Deployment**: Upload code zip or write directly in console IDE.
- **Re-Deploy**: Update code requires re-upload ("deploy" button).
- **Execution Flow**:
  ```
  Deploy Code → Runtime Available → Run on Trigger
  ```

### Monitoring and Logging
- **CloudWatch Integration**:
  - **Metrics**: Invocations, duration, errors, throttles.
  - **Logs**: Detailed execution logs per function.
- **Duration Calculation**: Rounded to nearest millisecond.

**Example Log Output**:
```
START RequestId: ...
INFO: I am Vimel Daga  # Print statement
END RequestId: ...
REPORT RequestId: ... Duration: 1.20 ms Billed Duration: 2 ms ...
```

> [!NOTE]
> CloudWatch automatically integrates; no manual setup needed for basic monitoring.

## Events and Triggers

### Understanding AWS Events
- **Event Definition**: Any user/service action in AWS generates events (e.g., create bucket, upload object).
- **Event Types**:
  - PutObject (upload object)
  - ObjectRemoved (delete object)
  - PermissionsChanged
- **Event Structure**: JSON format with details like bucket name, object key, timestamp, IP address.

**Example S3 PutObject Event**:
```json
{
  "Records": [
    {
      "eventSource": "aws:s3",
      "eventName": "ObjectCreated:Put",
      "s3": {
        "bucket": {
          "name": "my-bucket"
        },
        "object": {
          "key": "file.mp3"
        }
      }
    }
  ]
}
```

### Event Flow
```
AWS Service → Generate Event → Notify/Trigger Lambda
```

- **Trigger**: AWS service notifies Lambda to run function with event data.

**Supported Triggers**: S3, API Gateway, SNS, DynamoDB, CloudWatch Events, etc.

### Practical Use Cases
- **S3 Upload → Send Email/SMS**: Notify on new file upload.
- **Automatic Processing**: Resize images, transcribe audio, filter data.

## Lab Demo: Lambda Setup and Testing

### Creating a Lambda Function
1. Navigate to AWS Lambda Console → Create Function.
2. Choose "Author from scratch".
3. Configure:
   - Function Name: `my-function-test`
   - Runtime: Python 3.9
   - Architecture: x64
4. Set Execution Role (security policy).
5. Create the function.

### Writing Code
- In the console IDE, replace default code:
  ```python
  def lambda_handler(event, context):
      return {
          'statusCode': 200,
          'body': 'Hello from Lambda!'
      }
  ```
- **Test Event**: Create custom event (e.g., JSON with name).
- **Deploy**: Click "Deploy" to update code.
- **Invoke**: Use "Test" button or manual trigger.

**Output Example**:
```json
{
  "statusCode": 200,
  "body": "Hello from Lambda!"
}
```

### Adding Print Statements for Debugging
- Use `print()` for logs (appears in CloudWatch).
- Access event data: `print(event)`.

## Lab Demo: S3 Trigger Integration

### Setting Up S3
1. Create S3 bucket (e.g., `my-test-bucket`).
2. Enable Event Notifications (Properties → Event Notifications).
3. Configure:
   - Event Type: Object Created (Put)
   - Destination: Lambda
   - Specify Lambda Function ARN

### Connecting S3 to Lambda
- S3 Console → Bucket → Properties → Event Bridge Notifications.
- S3 Console → Bucket → Properties → Create Event Notification.
- Name: S3 Lambda Notification
- Event Types: All object create events (or filter by prefix/suffix, e.g., `.mp3`).
- Send to: Lambda function → Select function.

**Filtered Event Example** (`.mp3` files only):
- Prefix: (optional)
- Suffix: `.mp3`

### Testing the Trigger
1. Upload a file to S3 bucket.
2. Check Lambda CloudWatch logs.
3. Confirm function runs and logs event data.

**Log Example**:
```
PUT 2024-02-25 12:34:56 Events:
{
  "Records": [
    {
      "s3": {
        "bucket": {"name": "my-bucket"},
        "object": {"key": "file.mp3"}
      }
    }
  ]
}
```

## Serverless Project: Automatic Audio Transcription

### Project Overview
Build a Netflix-inspired project: Automatically transcribe uploaded audio files using S3 + Lambda + Transcribe.

**Architecture**:
```
S3 Bucket → Event (Upload MP3) → Trigger Lambda → Start Transcribe Job → Store Output in S3
```

### Components
- **S3**: Storage for audio input and text output.
- **Lambda**: Process event, start Transcribe job, provide S3 URLs.
- **Transcribe**: AWS Elasticsearch-to-text service (managed AI/ML).

### Using Amazon Transcribe
- **Service Purpose**: Convert speech in audio/video to text.
- **Batch Jobs**: Upload audio → Create job → Get text output.
- **Realtime**: For live streams (not covered here).
- **Supported Formats**: MP3, MP4, WAV, etc.
- **Languages**: English, Hindi, etc.

**Transcribe Job Setup**:
1. Navigate to Transcribe Console → Transcription Jobs.
2. Create Job:
   - Input Location: S3://bucket/audio.mp3
   - Output: S3://bucket/transcripts/
   - Language: English
   - Job Name: Auto-generated.

### Lambda Code (Python with Boto3)
```python
import boto3
import json

def lambda_handler(event, context):
    transcribe = boto3.client('transcribe')
    
    # Parse event for S3 details
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    s3Uri = f"s3://{bucket}/{key}"
    
    jobName = f"transcribe-{key.replace('/', '-')}"
    
    # Start Transcribe job
    response = transcribe.start_transcription_job(
        TranscriptionJobName=jobName,
        LanguageCode='en-US',
        Media={'MediaFileUri': s3Uri},
        OutputBucketName=bucket,
        OutputKey='transcripts/'
    )
    
    return {'statusCode': 200}
```

- **Boto3**: Python SDK for AWS services.
- **Event Parsing**: Extract bucket/object from S3 event.
- **Job Configuration**: Specify input S3 URI, output location.

### Full Demo Steps
1. **Setup S3**:
   - Bucket: `audio-transcribe-demo`
   - Event Notification: Trigger on `.mp3` uploads.

2. **Configure Lambda**:
   - Function: `audio-transcribe-function`
   - Runtime: Python 3.9
   - Code: As above.
   - Permissions: IAM role with Transcribe and S3 access.

3. **Test**:
   - Upload MP3 file (e.g., sample audio).
   - Monitor CloudWatch logs.
   - Check Transcribe jobs.
   - Download output transcript.

**Output Example (Transcript)**:
```
Today we will accomplish important business.
```

### Transcribe Service Details
- **Job Status**: Queued → In Progress → Completed.
- **Output**: JSON/Text files in S3 with transcription data.

## Permissions and IAM Roles

### Why IAM Roles?
- **Service Isolation**: Lambda cannot directly access S3/Transcribe without explicit permissions.
- **Execution Role**: Attached to Lambda function with allowed actions.

### Common Issues
- **Access Denied Errors**: Lambda lacks permission to call transcribe:start_transcription_job or s3:PutObject.
- **Automatic Roles**: Basic CloudWatch/S3 permissions added on function creation.

### Adding Permissions
1. **Via Console**:
   - Lambda → Configuration → Permissions → Add Permissions.
   - Service: Transcribe → Action: All/full access.
2. **Custom Role**:
   - IAM Console → Create Role → AWS Service → Lambda.
   - Attach policies: TranscribeFullAccess, S3FullAccess, CloudWatchLogsFullAccess.

**Role JSON Policy Example**:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "transcribe:*",
        "s3:*",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
```

> [!IMPORTANT]
> Least privilege: Grant only necessary permissions. Avoid wildcard resources in production.

## Troubleshooting and Best Practices

### Common Issues
- **Handler Errors**: Incorrect function name/path in handler setting.
- **Event Parsing Errors**: Wrong JSON structure or special characters in keys.
- **Role Permissions**: Access denied for cross-service calls.
- **Log Delays**: CloudWatch logging may have slight delays.

### Debugging Tips
- **Print Event/Context**: `print(event)` in code for inspection.
- **CatalogWatch Logs**: Real-time error checking.
- **Test Events**: Use custom events in Lambda console for manual testing.

### Security Best Practices
- **VPC/Layers**: Use VPC for Lambda if accessing private resources.
- **Environment Variables**: Store secrets securely.
- **Monitoring**: Set CloudWatch alarms on errors/metrics.

## Summary

### Key Takeaways
```diff
+ Serverless reduces management overhead by shifting infrastructure responsibility to AWS
- Traditional server management involves high costs for idle resources and manual scaling
! Event-driven architecture enables automated workflows without human intervention
+ Lambda supports multiple runtimes and scales automatically based on invocations
- IAM roles are crucial for secure cross-service communication
+ Real-world projects like audio transcription demonstrate serverless power
```

### Quick Reference
- **Lambda Pricing**: Free: 1M requests/month; Paid: $0.20/1M requests + $0.00001667/GB-sec.
- **Common Commands/Scripts**:
  - Create function: AWS Console or CLI (`aws lambda create-function`).
- **Configuration Snippets**:
  ```json
  {
    "handler": "hello.my_hello",
    "runtime": "python3.9",
    "memorySize": 128
  }
  ```

### Expert Insight
- **Real-world Application**: Serverless is ideal for microservices, IoT data processing, chatbots, and ETL pipelines. Netflix uses similar setups for real-time captioning and content transcoding.
- **Expert Path**: Master Boto3 for Python-based integrations, explore Step Functions for complex workflows, and integrate with EventBridge for advanced event routing.
- **Common Pitfalls**: Overusing Lambda for long-running tasks (>15 min); forgetting cost monitoring; ignoring cold starts in latency-sensitive apps. Mitigate by optimizing code size, using provisioned concurrency, and implementing proper error handling.

### Transcript Corrections Made
- "ript" → likely "Transcript" (removed as it's not content).
- "serless" → "serverless" throughout.
- "25th Feb" → "25th February" for session title.
- "u" and random multipliers like "lot of thing" → corrected for clarity as "lots of things".
- "transcar" → "transcribe".
- "IM" → "IAM" for AWS services.
- Various typos like "autogenerate" → "auto-generate", "trouble you shoot" → "troubleshoot".
- Removed extraneous "--" and formatting inconsistencies.
