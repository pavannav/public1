# Session 08: API Gateway

| Section | Description |
|---------|-------------|
| [Overview](#overview) | Introduction to API Gateway as a serverless service and its role in connecting clients to AWS backends. |
| [What is an API?](#what-is-an-api) | Explanation of APIs, interfaces, and communication protocols. |
| [REST API Basics](#rest-api-basics) | Concepts of HTTP methods, requests, responses, status codes, and URL structure. |
| [Creating API Gateway](#creating-api-gateway) | Step-by-step guide to setting up a REST API Gateway in AWS. |
| [Integrating with Lambda](#integrating-with-lambda) | How to connect API Gateway to Lambda functions with GET methods. |
| [Lambda Proxy Integration](#lambda-proxy-integration) | Deep dive into proxy vs. non-proxy integration, capturing client information. |
| [Deploying API](#deploying-api) | Deployment strategies, stages, and public access. |
| [Security and Filtering](#security-and-filtering) | API keys, user plans, and data filtering mechanisms. |
| [Real-World Use Cases](#real-world-use-cases) | Practical applications like S3 uploads and public Lambda execution. |
| [Summary](#summary) | Key takeaways, quick reference, and expert insights. |

## Overview

This session focuses on AWS API Gateway, a fully managed serverless service that acts as an interface between clients (such as web browsers or mobile apps) and AWS backend services like Lambda or S3. API Gateway enables secure, scalable communication using RESTful APIs, allowing public internet users to interact with AWS resources without needing an AWS account. It supports features like method-based routing (e.g., GET, POST), authentication, throttling, and data transformation, making it ideal for building serverless applications.

### Key Purpose of API Gateway
API Gateway serves as a "gateway" or proxy that:
- Connects external clients to internal AWS services.
- Handles request routing, authentication, and response formatting.
- Scales automatically to manage traffic spikes.
- Reduces latency through optimized integrations.

> [!NOTE]
> API Gateway is part of AWS's serverless offerings, requiring no server management and supporting up to 1 million requests per month in the free tier.

## What is an API?

An **API (Application Programming Interface)** is an interface that allows different software systems to communicate. It defines how one application can request services or data from another, enabling integration without exposing internal details.

### Core Concepts
- **Function as an Application**: Think of a Lambda function as a small app performing a task (e.g., returning "Hello World"). APIs enable remote invocation of such apps.
- **Interface Analogy**: Without a network API, you'll need direct access (e.g., AWS console login). An API provides a secure "doorway" for external communication.
- **Communication Protocol**: Primarily uses **HTTP/HTTPS** for web-based APIs, as it's ubiquitous across devices and browsers.
- **Request-Response Model**: Clients send **requests** (e.g., "run this function"), and servers respond with **outputs** (e.g., data or status).

### How API Gateway Fits In
API Gateway is the AWS service implementing this interface. It:
- Acts as a proxy between the internet and AWS backends.
- Translates HTTP requests into service-specific calls (e.g., invoking Lambda).
- Ensures responses are sent back via HTTP.

```mermaid
graph LR
A[Client (Browser)] --> B[API Gateway]
B --> C[AWS Backend (Lambda/S3)]
C --> B
B --> D[Response to Client]
```

**Real-World Analogies**:
- **S3 without API Gateway**: Only AWS users can upload; public clients are blocked.
- **Lambda without API Gateway**: Requires account login; no public execution.

**API Gateway as Proxy**:
- **Proxy Role**: On behalf of clients, it invokes backends and relays responses.
- **Firewall/Gateway**: Acts as a gateway, routing traffic securely.

## REST API Basics

**REST (REpresentational State Transfer)** APIs are a standard for web services, using HTTP methods to perform operations on resources. API Gateway enables building RESTful APIs by handling HTTP requests/responses.

### HTTP Methods
HTTP methods define the action a client wants to perform:
- **GET**: Retrieve data (e.g., view a website, download content). Most common; browsers default to GET.
- **POST**: Send/create data (e.g., upload files, submit forms like posting on Facebook).
- **PUT**: Update/replace entire resources.
- **PATCH**: Partially update resources.
- **DELETE**: Remove resources.

| Method | Typical Use Case |
|--------|------------------|
| GET | Reading data, displaying web pages |
| POST | Uploading data, form submissions |
| PUT | Full updates, replacing resources |
| PATCH | Partial updates |
| DELETE | Deleting resources |

### Request and Response Structure
- **Request**: Sent from client to server.
  - **Headers**: Metadata (e.g., content type, user agent).
  - **Body** (optional): Data for methods like POST.
  - **Method + URL**: Defines action and target.
- **Response**: Sent from server to client.
  - **Status Code**: Indicates success/failure (e.g., 200 = OK, 404 = Not Found).
  - **Headers**: Response metadata.
  - **Body**: Actual data/content.

**Common Status Codes**:
- **200 OK**: Request successful; content delivered.
- **400 Bad Request**: Invalid input.
- **404 Not Found**: Resource missing.
- **500 Internal Server Error**: Server-side error.

### URL Structure
URLs are key for routing:
- **Base URL**: Root address (e.g., `api.example.com`).
- **Path/Route/Endpoint**: Specific resource (e.g., `/search`, `/mail`).
- **Example**: `https://api.example.com/search` routes to "search" functionality.
- **Parameters**: Query strings (`?key=value`) or path parameters (`/users/123`).

**Browser Interaction**:
- Browsers send GET by default (e.g., entering a URL).
- Developer Tools (Network tab) show requests/responses.
- Use tools like curl for testing non-GET methods:
  ```bash
  curl -X POST https://api.example.com/submit
  ```

> [!IMPORTANT]
> APIs must match client-supported methods (e.g., POST for uploads); mismatches cause errors.

## Creating API Gateway

API Gateway setup involves creating a REST API, defining resources, and deploying it.

### Steps to Create API Gateway
1. **Navigate to API Gateway**: In AWS console, search for "API Gateway" and create a new REST API.
2. **Configure Settings**:
   - **Type**: Choose "REST API" for request-response (vs. WebSocket for real-time).
   - **Name**: Descriptive, e.g., "MyAPITest".
   - **Endpoint Type**: Regional for general use.
3. **Create Resources**:
   - Add "Resources" (paths like `/search`, `/mail`) under the root `/`.
   - Each resource acts as a route/endpoint.
4. **Add Methods**:
   - For each resource, add methods (e.g., GET).
   - This defines allowed client actions.

> [!NOTE]
> Free tier: 1 million requests/month for REST APIs.

### Testing in Console
- Use API Gateway's "Test" feature to simulate requests before deployment.
- Integrations link to backends (e.g., Lambda).

## Integrating with Lambda

API Gateway integrates with Lambda to invoke functions via HTTP requests.

### Basic Integration (Non-Proxy)
- **Setup**:
  1. Create Lambda functions (e.g., return `{"message": "I am Search"}`).
  2. In API Gateway, add method (e.g., GET) to a resource.
  3. Integrate with Lambda: Select function and region.
- **Behavior**:
  - API Gateway invokes Lambda but doesn't pass full client details.
  - Returns Lambda output with 200 status.
- **Code Example** (Python Lambda for GET):
  ```python
  def lambda_handler(event, context):
      return {"statusCode": 200, "body": "I am Search"}
  ```

### Testing Integration
- Use API Gateway's "Test" to validate.
- Check Lambda logs via CloudWatch for invocations.

> [!WARNING]
> Enable "Use Lambda Proxy Integration" for advanced scenarios requiring client data access; otherwise, keep basic for simple responses.

## Lambda Proxy Integration

Proxy integration passes full client details to Lambda, enabling custom logic based on requests.

### Proxy vs. Non-Proxy
| Aspect | Non-Proxy | Proxy |
|--------|------------|--------|
| Client Data Access | Limited; API Gateway handles response | Full client info via `event` |
| Response Handling | API Gateway manages status/code | Lambda must return statusCode and body |
| Use Case | Simple static responses | Dynamic responses based on headers/IP |

### Enabling Lambda Proxy
1. In API Gateway method integration:
   - Enable "Use Lambda Proxy Integration".
   - This bypasses API Gateway's response logic.
2. **Lambda Code**: Return both status and body:
   ```python
   def lambda_handler(event, context):
       return {
           "statusCode": 200,
           "body": json.dumps({"message": "Custom Response", "clientIP": event["requestContext"]["identity"]["sourceIp"]})
       }
   ```
3. **Accessing Client Data**:
   - `event`: Contains headers, IP, path, etc.
   - Example: Extract IP:
     ```python
     client_ip = event["headers"]["X-Forwarded-For"]
     return {"statusCode": 200, "body": f"Your IP: {client_ip}"}
     ```
   - Log details or use for logic (e.g., IP-based access).

### Benefits
- **Client Awareness**: Lambda knows browser, IP, etc., for analytics/blocking.
- **Direct Communication**: Pass-through reduces processing overhead.
- **Security**: Implement auth via headers.

> [!IMPORTANT]
> Proxy requires Lambda to handle HTTP responses correctly; non-proxy is simpler for basics.

## Deploying API

After setup, deploy to make publicly accessible.

### Deployment Steps
1. **Stages**: Create a stage (e.g., "test") for versioning.
2. **Deploy**: Use "Deploy API" for the stage; AWS assigns a public URL.
3. **URL Format**: Auto-generated (e.g., `https://abc123.execute-api.us-west-2.amazonaws.com/test`).
4. **Access**: Append paths (e.g., `/test/search` for GET).

### Testing Post-Deployment
- Use browser/curl on the public URL.
- Monitor via CloudWatch for invocations/errors.

> [!WARNING]
> Without security, APIs are public; use keys or IAM for protection.

## Security and Filtering

API Gateway supports security layers.

### API Keys and Usage Plans
- **API Keys**: Act like passwords; required for access.
  - Enable in method settings.
  - Clients include `X-API-Key` header.
- **Usage Plans**: Rate limiting/throttling (e.g., 1000 requests/month).
- **User Plans**: Create plans (Basic, Premium) with different limits.

### Data Filtering
- **Before Backend**: Filter malicious content in API Gateway.
- **Auth/Authorization**: Integrate Cognito or custom Lambda for user auth.
- **WAF Integration**: Block threats via Web Application Firewall.

> [!NOTE]
> Secures public APIs without exposing AWS accounts.

## Real-World Use Cases

- **S3 Public Uploads**: API Gateway allows unauthenticated uploads to secure S3 buckets, triggering Lambda for processing.
- **Public Lambda Execution**: Run functions via URLs for demos or tools.
- **Data Processing**: POST data for serverless workflows (e.g., transcoding with Transcribe).
- **Microservices**: Route to different Lambdas based on paths.

**Diagram: Public Lambda Access**
```mermaid
graph TD
A[Public User] --> B[API Gateway]
B --> C[Lambda Function]
C --> D[Response (e.g., Transcribe Text)]
```

> [!TIP]
> Combine with S3 events for automated pipelines.

## Summary

### Key Takeaways
```diff
+ API Gateway is a serverless proxy enabling public interaction with AWS services via REST APIs.
+ HTTP methods (GET/POST) define client actions; responses include status codes and data.
+ Lambda integration allows function invocation; proxy mode exposes full client details.
+ Deployment creates public URLs; secure with keys and plans to prevent misuse.
+ Use cases include S3 uploads, public Lambdas, and data filtering for malicious inputs.
```

### Quick Reference
- **Create API Gateway**: Console > API Gateway > REST API > Resources > Methods > Integrate with Lambda.
- **Lambda for GET Response**: Return `{"statusCode": 200, "body": "Data"}`.
- **Proxy Integration**: Enable for client data access; return statusCode + body.
- **Deploy**: Actions > Deploy API > Create Stage > Use public URL.
- **Test**: `curl https://url/test/path`.
- **Free Tier**: 1M requests/month.

#### Expert Insight
**Real-World Application**
API Gateway is essential for serverless apps needing public APIs, like mobile backends or IoT data ingestion. For example, a travel app uses GET for flight searches and POST for bookings, integrated with Lambda for processing.

**Expert Path**
Master REST principles, then explore WebSocket APIs for real-time apps. Practice integrating Cognito for auth and WAF for security. Study latency optimization via Edge APIs or CloudFront.

**Common Pitfalls**
- Forgetting proxy mode for client data leads to incomplete integrations.
- Ignoring status codes causes client errors (e.g., browser issues with missing 200).
- Public APIs without keys risk abuse; always enable throttling.
- Mismatched methods (e.g., POST to GET-only) result in errors.

**Lesser-Known Facts**
- API Gateway supports CORS for browser security.
- Binary data (e.g., images) can be handled via Lambda proxy.
- Integrates with on-premises via private APIs (VPC link).
- Auto-scaling handles traffic spikes without configuration.

**Advantages**: Zero management, scalable, secure integrations out-of-the-box.

**Disadvantages**: Complex for beginners; vendor lock-in; costs per request beyond free tier. Alternatives like Kong or HAProxy offer more flexibility but require server management.
