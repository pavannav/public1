# Session 16: API Gateway and Lambda Revision

## Table of Contents
- [Overview](#overview)
- [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
  - [API Gateway Basics Revision](#api-gateway-basics-revision)
  - [Function as a Service (Lambda)](#function-as-a-service-lambda)
  - [Invoke Concept](#invoke-concept)
  - [Ways to Pass Data](#ways-to-pass-data)
  - [Practical: Creating API Gateway and Lambda](#practical-creating-api-gateway-and-lambda)
  - [Deploying and Testing API](#deploying-and-testing-api)
  - [Postman Tool for API Testing](#postman-tool-for-api-testing)
  - [Extending with POST Method](#extending-with-post-method)
  - [Lambda Proxy and Data Handling](#lambda-proxy-and-data-handling)
  - [Serverless Use Cases and Integrations](#serverless-use-cases-and-integrations)
- [Summary](#summary)

## Overview

This session is a revision of API Gateway and Lambda concepts, focusing on their integration for serverless architectures. API Gateway acts as a reverse proxy for backend services, while AWS Lambda provides serverless compute for running functions in response to events. The session includes theoretical revisions, hands-on practical demos, and discussions on real-world applications like email automation and media transcription.

## Key Concepts and Deep Dive

### API Gateway Basics Revision

API Gateway is an API management tool that sits between clients and backend services, acting as a reverse proxy. It accepts API calls, routes them appropriately, and returns responses. Modern applications consist of multiple functionalities (apps), each containing functions that trigger based on events (function as a service).

```bash
# API Gateway acts as intermediary
Client Request → API Gateway → Backend Service → Response
```

### Function as a Service (Lambda)

Lambda enables running code (functions) in response to events without managing servers. Input events trigger algorithms, producing responses. This is also known as serverless computing, where AWS manages infrastructure.

### Invoke Concept

Integration of API Gateway with Lambda is called "invoke." API Gateway triggers Lambda functions based on API requests. This setup facilitates event-driven architectures.

```yaml
# Trigger flow
API Request → API Gateway → Invoke Lambda → Process → Response
```

### Ways to Pass Data

Several methods exist for passing data from clients to Lambda via API Gateway:

- **Query Strings (GET Method)**: Data passed in URL parameters (e.g., `/api?name=value`). Visible in URL but cached.
- **Embedding Data (POST Method)**: Data embedded in headers or body, not visible in URL. Uses HTTP headers.
- **Pass Through Setup (Lambda Proxy)**: Data flows directly from client to Lambda, storing information in query string parameters.

### Practical: Creating API Gateway and Lambda

#### Creating API Gateway
1. Navigate to AWS Management Console → API Gateway.
2. Choose "REST API" for complete control over requests/responses and integration with Lambda, HTTP, and AWS services.
3. Create a new API (e.g., name: "LW API").
4. Create a resource and method (e.g., GET method integrated with Lambda).

#### Creating Lambda Function
1. Go to AWS Lambda Console.
2. Create function with Python runtime.
3. Set permissions (use existing IAM role or create new with basic Lambda permissions).
4. Add code (sample handler returning "Welcome to revision session class of Lambda").

```python
def lambda_handler(event, context):
    return {
        'statusCode': 200,
        'body': json.dumps('Welcome to revision session class of Lambda and API Gateway')
    }
```

### Deploying and Testing API

1. Create a deployment stage (e.g., "test" or "revision").
2. Set integration for method (link Lambda function).
3. Test using API Gateway's built-in test tool or invoke URL.

**Invoke URL Format**: `https://<api-id>.execute-api.<region>.amazonaws.com/<stage>/`

> [!NOTE]
> Testing via invoke URL simulates production behavior better than built-in test tool.

### Postman Tool for API Testing

Postman is a tool for testing APIs, especially for methods like POST, PUT, DELETE that browsers don't support natively.

#### Postman Setup
1. Download Postman (free version available).
2. Sign up with account details.
3. Create a collection (folder for APIs, e.g., "Revision").
4. Enter invoke URL and select method.
5. Add parameters or body data as needed.

```bash
# Example GET request in Postman
GET: https://<invoke-url>/test
# Response: 200 OK with Lambda output
```

> [!WARNING]
> Browsers are primarily for GET requests; use tools like Postman for other methods to avoid errors.

### Extending with POST Method

1. Add POST resource and method to API Gateway.
2. Integrate with existing Lambda.
3. Modify Lambda code to handle HTTP methods:

```python
def lambda_handler(event, context):
    http_method = event.get('httpMethod', '')
    
    if http_method == 'GET':
        return {'statusCode': 200, 'body': json.dumps('I am a GET method')}
    elif http_method == 'POST':
        return {'statusCode': 200, 'body': json.dumps('I am a POST method')}
    else:
        return {'statusCode': 200, 'body': json.dumps("I don't know this method")}
```

4. Redeploy API after code changes.
5. Test POST requests via Postman by adding body data.

**Request Body in API Gateway**: Access via event for POST data (e.g., JSON payload).

### Lambda Proxy and Data Handling

Lambda Proxy enables direct data flow from client to Lambda, with all information stored in `queryStringParameters` or `body`.

- **Query String Parameters**: Key-value pairs passed in URL (e.g., `?name=Tom`).
- **Postman Testing**: Pass parameters in URL or body for dynamic responses.

> [!NOTE]
> Use CloudWatch Logs to monitor errors and executions during testing.

### Serverless Use Cases and Integrations

#### AWS Transcribe Integration Example
Serverless setups enable event-driven processing:
- Upload media to S3 → Triggers Lambda → Calls Transcribe → Outputs JSON to S3.

```python
# Sample Lambda code for Transcribe trigger
import boto3

s3 = boto3.client('s3')
transcribe = boto3.client('transcribe')

def lambda_handler(event, context):
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    
    # Start transcription job
    transcribe.start_transcription_job(
        TranscriptionJobName=f"{key.split('.')[0]}-{str(uuid.uuid4())}",
        Media={'MediaFileUri': f"s3://{bucket}/{key}"},
        MediaFormat='mp3',  # or mp4
        LanguageCode='hi-IN',  # Based on content
        OutputBucketName=bucket,
        OutputKey=f"transcripts/{key}.json"
    )
    
    return {'statusCode': 200}
```

**Permissions Required**: Attach IAM policies for S3 Full Access, Transcribe Access, CloudWatch Logs.

#### Email Automation Use Case
Replace EC2-based servers with Lambda for cost efficiency:

- Website form → API Gateway → Lambda → Send Email via SES.
- Lambda only runs on-demand, reducing costs.

```python
# Simple email sending code
import boto3

ses = boto3.client('ses')

def lambda_handler(event, context):
    user_email = event['body']['email']  # From request
    response = ses.send_email(
        Source='noreply@example.com',
        Destination={'ToAddresses': [user_email]},
        Message={'Subject': {'Data': 'Registration Successful'}, 'Body': {'Text': {'Data': f'Hi {event["body"]["name"]}, you are registered!'}}}
    )
    return {'statusCode': 200}
```

> [!IMPORTANT]
> Serverless abstracts infrastructure management; AWS handles scaling and maintenance.

## Summary

### Key Takeaways
```diff
+ API Gateway: Acts as reverse proxy for serverless backends, supporting REST APIs and multiple integrations.
+ Lambda: Event-driven compute for functions without server management (true serverless).
+ Invoke: Mechanism for API Gateway to trigger Lambda functions.
+ Data Passing: Query strings (GET), body data (POST), lambda proxy for direct flow.
+ Testing: Use Postman for comprehensive API testing beyond browser limitations.
+ Serverless Benefits: Cost-effective, auto-scaling, integrates with AWS services like S3, Transcribe, SES.
- Common Misunderstandings: Not a lack of servers, but servers not managed by users.
```

### Quick Reference
- **Invoke URL Structure**: `https://<api-id>.execute-api.<region>.amazonaws.com/<stage>/<resource>`
- **Postman Download**: https://www.postman.com/downloads/
- **Lambda Runtime Options**: Python, Node.js, Java, etc. (Python recommended for simplicity).
- **Methods Covered**: GET, POST (extendable to PUT, DELETE).
- **Permissions for Lambda**: AmazonS3FullAccess, AmazonTranscribeFullAccess, CloudWatchLogsFullAccess.

### Expert Insight
#### Real-world Application
In production, API Gateway + Lambda powers microservices architectures. For example:
- E-commerce products API: GET for product details, POST for adding to cart via Lambda.
- IoT data processing: Devices send data → API Gateway → Lambda processes/analytics → Store in DynamoDB.

#### Expert Path
1. Master IAM roles and policies for secure cross-service communication.
2. Implement custom authorizers in API Gateway for authentication.
3. Explore Lambda Layers for code reusability across functions.
4. Monitor with AWS X-Ray for performance insights.

#### Common Pitfalls
- **Redeployment Neglect**: Always redeploy after Lambda code changes; cached versions cause stale behavior.
- **HTTP Method Limitations**: Browsers can't send complex POST data; use dedicated tools.
- **Permissions Issues**: Misconfigured IAM roles lead to AccessDenied errors in CloudWatch.
- **Cold Starts**: Initial Lambda invocations may be slower; optimize with provisioned concurrency.

#### Lesser-Known Facts
- Lambda supports up to 3,200 CPU cores and 10,240 GB RAM per function region (auto-scaling).
- API Gateway can integrate with non-AWS backends via HTTP proxies.
- Serverless ≠ No Servers; AWS manages EC2 instances behind the scenes for Lambda. 

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>  
Model ID: KK-CS45-V3
