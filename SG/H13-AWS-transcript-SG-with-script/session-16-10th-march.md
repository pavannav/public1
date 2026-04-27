# Session 16: API Gateway and Lambda

## Table of Contents
- [Overview](#overview)
- [Key Concepts](#key-concepts)
  - [API Gateway Fundamentals](#api-gateway-fundamentals)
  - [Function as a Service (Lambda)](#function-as-a-service-lambda)
  - [Integration Concepts](#integration-concepts)
  - [Data Passing Methods](#data-passing-methods)
  - [Lambda Proxy Integration](#lambda-proxy-integration)
- [Lab Demos](#lab-demos)
  - [Creating API Gateway and Lambda Function](#creating-api-gateway-and-lambda-function)
  - [Adding HTTP Methods](#adding-http-methods)
  - [Testing with Postman](#testing-with-postman)
  - [Practical: S3 Lambda Transcribe Integration](#practical-s3-lambda-transcribe-integration)
- [Summary](#summary)

## Overview
This session focuses on API Gateway and Lambda, two fundamental AWS serverless services. API Gateway acts as a reverse proxy for routing API calls to backend services, while Lambda enables event-driven computing without managing servers. The session covers theoretical concepts, practical implementation, and integration patterns for building scalable serverless architectures.

## Key Concepts

### API Gateway Fundamentals
API Gateway is an API management tool that sits between clients and backend services. It provides:

- **Reverse Proxy Functionality**: Accepts API calls and returns appropriate responses
- **Multi-Service Support**: Works with Lambda, AWS services, and HTTP endpoints
- **Complete Control**: Offers full request/response management capabilities

```bash
# Basic API Gateway workflow
Client → API Gateway → Backend Service → Response
```

### Function as a Service (Lambda)
Lambda enables serverless computing where functions run in response to events:

- **Event-Driven Execution**: Functions trigger based on specific events or requests
- **Pay-Per-Use Billing**: Charges only for actual compute time used
- **Automatic Scaling**: Handles variable workloads without manual intervention

### Integration Concepts
The session demonstrates integration between API Gateway and Lambda:

- **Invoke Concept**: API Gateway triggers Lambda functions
- **Seamless Communication**: Direct routing of requests to Lambda for processing
- **Stateless Processing**: Each invocation is independent

### Data Passing Methods

#### Query String Parameters (GET Method)
Pass data via URL parameters:
```bash
GET /resource?name=value&city=location
```

#### Embedding Data (POST Method)
Include data in HTTP headers for secure transmission:
```bash
POST /resource
Headers: {
  "Content-Type": "application/json",
  "Authorization": "Bearer token"
}
Body: {
  "data": "payload"
}
```

#### Binary Data (PUT Method)
Used for file uploads and binary content:
```bash
PUT /resource
Content-Type: application/octet-stream
Body: [binary data]
```

### Lambda Proxy Integration
Pass-through setup for direct communication:

- **Full Request Access**: Lambda receives complete request information
- **Flexible Processing**: Handle headers, body, and query parameters
- **JSON-Based Communication**: Structured data exchange

> [!NOTE]
> Lambda proxy integration stores all request data in the Lambda event object, making it accessible for processing.

---

## Lab Demos

### Creating API Gateway and Lambda Function

#### Step 1: Create REST API
```bash
# In AWS Console > API Gateway
1. Click "Create API"
2. Choose "REST API" (REST API for dev edition)
3. Enter API name (e.g., "LW API")
4. Select appropriate region
5. Click "Create API"
```

#### Step 2: Create Lambda Function
```python
# Basic Lambda function code
def lambda_handler(event, context):
    return {
        'statusCode': 200,
        'body': 'Welcome to revision session class of Lambda and API Gateway'
    }
```

**Configuration Options:**
```bash
# Runtime: Python 3.x
# Permissions: Create new role with Lambda permissions
# Execution role: AWSLambdaBasicExecutionRole
```

#### Step 3: Integration Setup
```bash
# Add Resource
1. Click "Actions" > "Create Resource"
2. Resource Name: "LW" or custom name
3. Create Resource

# Add Method
1. Click resource
2. Actions > Create Method
3. Choose GET/push method
4. Integration type: Lambda Function
5. Lambda Function: Select created function (e.g., "test")
6. Save
```

### Adding HTTP Methods

#### GET Method Implementation
```python
# Lambda code for GET with query string
def lambda_handler(event, context):
    query_params = event.get('queryStringParameters', {})
    city = query_params.get('city', 'Unknown')
    
    return {
        'statusCode': 200,
        'body': f'Welcome to {city}'
    }
```

#### POST Method with Conditional Logic
```python
# Lambda code supporting multiple methods
def lambda_handler(event, context):
    http_method = event['httpMethod']
    
    if http_method == 'GET':
        query_params = event.get('queryStringParameters', {})
        city = query_params.get('city', 'Unknown')
        body = f'I am a GET method. City: {city}'
    elif http_method == 'POST':
        body = 'I am a POST method'
    else:
        body = 'Unknown method'
    
    return {
        'statusCode': 200,
        'body': body
    }
```

> [!IMPORTANT]
> After code changes, redeploy the API stage to apply updates.

#### Request Body Handling
```bash
# API Gateway Configuration for POST data
1. Select resource > Integration Request
2. Click "Mapping Templates"
3. Content-Type: application/json
4. Template: 
   {
     "body": "$input.json('$')",
     "headers": "$input.params().header",
     "method": "$context.httpMethod"
   }
```

### Testing with Postman

#### Setup Postman
```bash
# Download Postman (free version)
1. Visit https://www.postman.com/downloads/
2. Create account with basic details

# Create Collection
1. New Collection > Enter name (e.g., "Revision")
2. Create Request
3. Choose method (GET/POST/PUT)
4. Enter Invoke URL from API Gateway stage
```

#### Testing Examples
```bash
# GET Request
Method: GET
URL: https://your-api-id.execute-api.region.amazonaws.com/stage/resource

# POST Request with body
Method: POST
URL: https://your-api-id.execute-api.region.amazonaws.com/stage/resource
Headers: Content-Type: application/json
Body: {
  "name": "Tom",
  "city": "Jaipur"
}
```

! Lambda → API Gateway Invoke → Response Processing

### Practical: S3 Lambda Transcribe Integration

#### Lambda Function Setup
```python
import boto3
import json
import uuid

def lambda_handler(event, context):
    # Extract S3 information from event
    s3_bucket = event['Records'][0]['s3']['bucket']['name']
    s3_object = event['Records'][0]['s3']['object']['key']
    
    # Create transcribe job
    transcribe = boto3.client('transcribe')
    
    job_name = f"{s3_object}-{str(uuid.uuid4())[:8]}"
    
    transcribe.start_transcription_job(
        TranscriptionJobName=job_name,
        LanguageCode='hi-IN',  # Hindi Indian
        MediaFormat='mp3',    # or appropriate format
        Media={
            'MediaFileUri': f"s3://{s3_bucket}/{s3_object}"
        },
        OutputBucketName=s3_bucket,
        OutputKey='transcripts/'
    )
    
    return {
        'statusCode': 200,
        'body': 'Transcription job started'
    }
```

#### S3 Trigger Configuration
```bash
# Required IAM Permissions for Lambda Role
- AmazonS3FullAccess
- AmazonTranscribeFullAccess
- CloudWatchLogsFullAccess

# S3 Bucket Configuration
1. Create S3 bucket (e.g., "transcribe-bucket")
2. Upload audio/video files
3. Configure Lambda trigger on S3 PUT events
```

#### Workflow Explanation
! S3 Upload → Lambda Trigger → Transcribe Job → JSON Output to S3

---

## Summary

### Key Takeaways
```diff
+ API Gateway is a reverse proxy that routes API calls to backend services
+ Lambda enables serverless computing with pay-per-use billing
+ Multiple HTTP methods (GET, POST, PUT) handle different data types
+ Lambda proxy integration provides full request information access
+ Postman is essential for testing APIs that aren't browser-friendly
+ Serverless reduces infrastructure management overhead
```

### Quick Reference

**Common API Gateway URLs:**
- Invoke URL: `https://api-id.execute-api.region.amazonaws.com/stage`
- CloudWatch Logs: Monitor function execution and errors

**Lambda IAM Permissions:**
```yaml
Policies:
  - AWSLambdaBasicExecutionRole
  - AmazonS3FullAccess (for S3 integrations)
  - AmazonTranscribeFullAccess (for transcribe)
```

**Postman Test Scenarios:**
- GET: Query string parameters (`?name=value`)
- POST: JSON body with headers
- PUT: Binary data uploads

**Use Cases:**
- User registration with automated email notifications
- File processing (audio/video transcription)
- API-based data processing workflows

### Expert Insight

**Real-world Application**: Serverless architectures excel in event-driven scenarios like real-time data processing, API backends, and IoT data ingestion. Netflix's subtitle generation demonstrates Lambda's capability for media processing at scale.

**Expert Path**: Master Lambda deployment packages, custom runtimes, and CloudFormation for infrastructure as code. Learn API Gateway throttling, request/response mapping, and API versioning strategies.

**Common Pitfalls**: 
- Redeploy API Gateway after Lambda code changes
- Ensure proper IAM permissions across services
- Monitor Lambda cold start latency for performance-critical applications
- Secure API endpoints with proper authentication and rate limiting

**Lesser-Known Facts**: Lambda functions can run for up to 15 minutes and support custom runtimes beyond Node.js, Python, Java, etc. API Gateway supports WebSocket protocols for real-time applications beyond traditional REST APIs.
