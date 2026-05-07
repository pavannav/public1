# Session 16: API Gateway and Lambda

| Section | Description |
|---------|-------------|
| [Overview](#overview) | Introduction to API Gateway and Lambda concepts |
| [API Gateway Fundamentals](#api-gateway-fundamentals) | Core principles and components |
| [Function as a Service (Lambda)](#function-as-a-service-lambda) | Event-driven serverless computing |
| [Integration and Invoke](#integration-and-invoke) | Connecting API Gateway with Lambda |
| [Data Passing Mechanisms](#data-passing-mechanisms) | Methods for injecting data into functions |
| [HTTP Methods and Data Types](#http-methods-and-data-types) | GET, POST, PUT and binary data handling |
| [Lambda Proxy Setup](#lambda-proxy-setup) | Pass-through integration with AWS services |
| [Practical Lab: Creating API Gateway and Lambda](#practical-lab-creating-api-gateway-and-lambda) | Step-by-step setup of REST API |
| [Lab Demo: Lambda Function Creation](#lab-demo-lambda-function-creation) | Python-based function with basic response |
| [API Gateway Configuration](#api-gateway-configuration) | Resources, methods, and deployment stages |
| [Testing with Postman](#testing-with-postman) | Using Postman for API testing |
| [Advanced Lab Demos](#advanced-lab-demos) | Query parameters, CloudWatch logs, and method variations |
| [Practical Projects Overview](#practical-projects-overview) | Real-world applications and integrations |
| [Additional Integrations](#additional-integrations) | Lambda with S3 and AWS Transcribe |
| [Email Automation Example](#email-automation-example) | Serverless email sending via Lambda |
| [Summary](#summary) | Key takeaways and expert insights |

## Overview

In this revision session, we revisit API Gateway and Lambda services in AWS. API Gateway serves as a reverse proxy managing API calls between clients and backend services, while Lambda enables serverless function execution on demand. Together, they form a powerful serverless architecture for building scalable applications without managing underlying infrastructure.

## API Gateway Fundamentals

API Gateway acts as an API management tool positioned between client applications and backend services. It functions as a reverse proxy, accepting application programming interface (API) calls, routing them to appropriate backends, and returning responses. This session focuses on REST APIs, which offer complete control over HTTP requests and responses, supporting integration with Lambda, HTTP backends, and other AWS services.

The key advantage is centralized API management, where multiple backend functionalities exist within a single application, each accessible via dedicated API endpoints.

## Function as a Service (Lambda)

Serverless computing revolves around Function as a Service (FaaS), where code executes only when triggered by events. Unlike traditional servers that run continuously (incurring costs even during idle periods), Lambda functions run on-demand. 

A typical Lambda flow involves:
1. An event trigger (e.g., API call, file upload)
2. Function execution with input processing
3. Algorithm execution
4. Response generation

This model is ideal for variable workloads, scaling automatically while charging only for compute time used.

## Integration and Invoke

The integration of API Gateway with Lambda is termed "invoke." When a client makes an API request through API Gateway, it triggers the Lambda function using a predefined integration. This seamless connectivity enables event-driven architecture where API calls directly execute serverless functions.

## Data Passing Mechanisms

To inject data into Lambda functions, several methods exist:

1. **Query String Parameters**: Used with GET method for visible URL-based data passing.
2. **Header Embedding**: Transmits data via HTTP headers for security; uses POST method.
3. **Request Body (Raw Data)**: Sends binary data (e.g., images, videos, PDFs) via POST/PUT methods.

Data types include:
- Simple values (e.g., variables like `x = "hello"`)
- Binary data (multimedia files)

## HTTP Methods and Data Types

HTTP methods serve specific purposes for data transmission:

| Method | Purpose | Example Use Case |
|--------|---------|------------------|
| GET    | Retrieving data; uses query strings | Fetch user profile information |
| POST   | Creating/sending data; uses headers/request body | Submit form data |
| PUT    | Uploading binary data | File uploads (images, videos) |

The method selection depends on data type and security requirements, with POST/PUT preferred for sensitive or large payloads.

## Lambda Proxy Setup

Lambda Proxy enables direct data passage from clients to Lambda via API Gateway without intermediary processing. All request information, including headers, path parameters, query string parameters, and body, stores in Lambda's event parameter as JSON. This simplifies integration and supports complex API interactions.

## Practical Lab: Creating API Gateway and Lambda

Follow these steps to set up a basic API Gateway and Lambda integration:

1. Navigate to AWS Console > API Gateway.
2. Select "Create API" > Choose REST API (developer's REST API for full control).
3. Create new API with descriptive name (e.g., "LW API").
4. Skip additional settings and create the API.
5. Switch to Lambda service to create the backend function.
6. Create new function with custom runtime (Python 3.x).
7. Configure basic execution role with Lambda permissions (use existing role if preferred).
8. Write sample code (see next section).
9. Deploy function to create initial version.
10. Return to API Gateway for method configuration.

```python
def lambda_handler(event, context):
    return {
        'statusCode': 200,
        'body': json.dumps('Welcome to revision session class of Lambda and API Gateway')
    }
```

## Lab Demo: Lambda Function Creation

This lab demonstrates Python Lambda function setup:

```python
# Basic Lambda handler
def lambda_handler(event, context):
    return {
        'statusCode': 200,
        'body': json.dumps("Welcome to revision session class of Lambda")
    }
```

### Steps:
1. Create function named "test" with Python runtime.
2. Configure new IAM role with basic Lambda permissions.
3. Replace default code with above handler.
4. Deploy function via "Deploy" button.
5. Verify successful deployment in function details.

## API Gateway Configuration

After creating the Lambda function:

1. In API Gateway, under your API, create a new resource (e.g., "LW").
2. Add a method (e.g., GET) by selecting "Actions" > "Create Method".
3. Choose GET method and select Lambda function integration.
4. Enter function name (e.g., "test").
5. Save the method.

To enable client access:
1. Create deployment stage (e.g., "test" or "revision").
2. Provide optional descriptions.
3. Deploy the API to generate Invoke URL (e.g., API Gateway domain endpoint).

Test the integration:
1. In API Gateway, select test option for GET method.
2. Execute test to verify 200 status code and response body.
3. Copy Invoke URL for client testing.

## Testing with Postman

Postman enables testing APIs that browsers cannot handle (limited to GET method).

### Setup:
1. Download and install Postman (free version).
2. Create account with personal details (name, role for API testing).
3. Create collection (folder) named "revision" for organizing requests.

### Testing Process:
1. Create new request in collection.
2. Set method to GET.
3. Paste Invoke URL from API Gateway deployment.
4. Click "Send" to receive 200 status with expected body.
5. Verify integration success.

Postman supports all HTTP methods and parameter passing, making it essential for comprehensive API testing.

## Advanced Lab Demos

### Query String Parameters
Modify Lambda code to handle GET requests with query parameters stored in `event['queryStringParameters']`.

```python
def lambda_handler(event, context):
    if event['httpMethod'] == 'GET':
        city = event['queryStringParameters']['city']
        return {
            'statusCode': 200,
            'body': json.dumps(f"Welcome to {city} from Lambda")
        }
```

**Steps:**
1. Update code and redeploy Lambda.
2. Recreate API Gateway stage.
3. Test with query string (e.g., append `?city=Jaipur` to URL).

### CloudWatch Logs
Monitor execution via CloudWatch to troubleshoot errors or verify data flow stored in structured JSON format.

**Viewing Logs:**
1. Navigate to CloudWatch > Logs.
2. Filter by Lambda function logs.
3. Examine event details including query parameters.

### Method Variations
Support multiple HTTP methods with conditional logic:

```python
def lambda_handler(event, context):
    http_method = event['httpMethod']
    if http_method == 'GET':
        # Handle GET requests
        return {'statusCode': 200, 'body': 'I am a GET method'}
    elif http_method == 'POST':
        # Handle POST input from request body
        return {'statusCode': 200, 'body': 'I am a POST method'}
    else:
        return {'statusCode': 200, 'body': 'Unknown method'}
```

**Steps:**
1. Add POST method to API Gateway resource.
2. Integrate with same Lambda function.
3. Reconvergate and redeploy.
4. Test POST via Postman with JSON body (e.g., `{"name": "Tom"}`).

Pass POST data through API Gateway request body configuration accessible via `event['body']`.

## Practical Projects Overview

Build applications using Lambda + API Gateway:

1. **User Registration System**: Handle form submissions via POST, validate input, store in database or send confirmation emails.
2. **Media Processing**: Upload files (S3), trigger Lambda for transcoding, return results via API.
3. **Real-time Data Processing**: Process streaming data with API triggers.

These projects require minimal infrastructure compared to traditional EC2 deployments.

## Additional Integrations

### S3 and Transcribe Integration
Demo: Audio/video transcription using Lambda triggered by S3 uploads.

```python
import boto3
import json
import uuid

def lambda_handler(event, context):
    s3_client = boto3.client('s3')
    transcribe_client = boto3.client('transcribe')
    
    record = event['Records'][0]
    bucket = record['s3']['bucket']['name']
    object_key = record['s3']['object']['key']
    job_name = f"{object_key.split('.')[0]}-{str(uuid.uuid4())[:8]}"
    
    # Start transcribe job
    transcribe_client.start_transcription_job(
        TranscriptionJobName=job_name,
        LanguageCode='hi-IN',  # Hindi
        Media={'MediaFileUri': f's3://{bucket}/{object_key}'},
        OutputBucketName=bucket,
        OutputKey=f'transcripts/{object_key}.json'
    )
    
    return {'statusCode': 200, 'body': json.dumps('Transcription started')}
```

**Steps:**
1. Create Lambda function with roles for S3 read/write, Transcribe access, and CloudWatch logs.
2. Add S3 bucket trigger for object creation.
3. Upload audio/video file to trigger transcription.
4. Generated JSON file with transcription results stores in S3.

## Email Automation Example

Serverless email sending application:

```python
import boto3
import json

def lambda_handler(event, context):
    ses_client = boto3.client('ses')
    user_data = json.loads(event['body'])
    
    # Send customized email
    ses_client.send_email(
        Source='noreply@example.com',
        Destination={'ToAddresses': [user_data['email']]},
        Message={
            'Subject': {'Data': 'Registration Confirmed'},
            'Body': {'Text': {'Data': f"Hi {user_data['name']}, you are registered!"}
        }
    })
    
    return {'statusCode': 200, 'body': json.dumps('Email sent successfully')}
```

Replace EC2-based email servers with on-demand Lambda execution for cost savings and scalability.

## Summary

### Key Takeaways
```diff
+ API Gateway provides centralized API management with reverse proxy functionality
- Avoid over-provisioning infrastructure when serverless options exist
+ Lambda enables event-driven, scalable function execution without server management
- Browsers limit testing; use Postman for full HTTP method coverage
+ Data passing supports query strings, headers, and request bodies
- Query strings are insecure; use headers for sensitive data
+ Lambda Proxy simplifies integrations by passing all request data through events
- Test integrations through CloudWatch for troubleshooting
+ Real-world applications include email automation and media transcoding
```

### Quick Reference

**Core Commands and Code Snippets:**

- **Lambda Function Template:**
  ```python
  def lambda_handler(event, context):
      return {'statusCode': 200, 'body': json.dumps('Response')}
  ```

- **HTTP Method Checking:**
  ```python
  http_method = event['httpMethod']
  if http_method == 'GET':
      # Handle GET logic
  ```

- **API Invocation URLs:**
  - Postman: `https://<api-gateway-id>.execute-api.<region>.amazonaws.com/<stage>`

- **IAM Permissions Setup:**
  - Attach policies: AmazonAPIGatewayInvokeFullAccess, AWSLambdaExecute

- **Postman Collection Structure:**
  - Create folders for organizing test requests by API endpoint

### Expert Insight

#### Real-world Application
Serverless architectures excel in microservices and event-driven applications. For example, e-commerce APIs use Lambda + API Gateway for order processing, automatically scaling during traffic spikes while minimizing idle costs. Media companies leverage S3/Lambda/Transcribe for real-time captioning without dedicated transcoding servers.

#### Expert Path
Master AWS serverless by:
- Practicing multi-service integrations (e.g., Lambda + DynamoDB + API Gateway)
- Learning advanced triggers (EventBridge, SQS)
- Implementing monitoring with CloudWatch and X-Ray
- Exploring container-based Lambda (AWS Fargate) for complex applications

#### Common Pitfalls
- Neglecting IAM permissions causing 403 Forbidden errors
- Forgetting to redeploy API Gateway after Lambda code changes
- Exceeding Lambda timeout limits (default 3 seconds) for long-running tasks
- Not handling binary data properly in Lambda event payloads
- Hardcoding secrets instead of using environment variables or AWS Secrets Manager

#### Lesser-Known Facts
- Lambda functions can run up to 15 minutes max per invocation
- API Gateway supports caching and throttling to prevent abuse
- Serverless applications save up to 70% operational costs compared to traditional servers during low-usage periods
- Python's boto3 library simplifies AWS service integration programmatically
- Multiple Lambda versions enable safe rollbacks during deployment

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
