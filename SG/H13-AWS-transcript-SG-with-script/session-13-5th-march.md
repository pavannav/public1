# Session 13: API Gateway S3 Integration

## Table of Contents
- [Overview](#overview)
- [Key Concepts & Deep Dive](#key-concepts--deep-dive)
  - [API Gateway as a Management Tool](#api-gateway-as-a-management-tool)
  - [HTTP Methods and Data Transmission](#http-methods-and-data-transmission)
  - [Lambda Function Integration](#lambda-function-integration)
  - [S3 Integration Concepts](#s3-integration-concepts)
  - [Path Parameter Mapping](#path-parameter-mapping)
  - [Binary Data Handling](#binary-data-handling)
  - [Security with API Keys and Usage Plans](#security-with-api-keys-and-usage-plans)
- [Summary](#summary)
  - [Key Takeaways](#key-takeaways)
  - [Quick Reference](#quick-reference)
  - [Expert Insight](#expert-insight)

## Overview

This session advances serverless architecture concepts by demonstrating how to integrate API Gateway with Simple Storage Service (S3) to enable public file uploads without requiring AWS account access. The instructor covers HTTP methods in detail, path parameter mapping for dynamic bucket and file specifications, binary data processing, and API Gateway security features including usage plans and API keys for monetization and access control.

## Key Concepts & Deep Dive

### API Gateway as a Management Tool

API Gateway serves as a serverless proxy between client applications and backend services, supporting multiple HTTP verbs to handle different client requirements:

- **Proxy Functionality**: Routes requests between clients and services like Lambda or S3
- **Multi-method Support**: Handles GET (data retrieval), POST (data submission), PUT (file uploads), DELETE (removal)
- **Event-Driven Architecture**: Connects to backend services without managing servers

### HTTP Methods and Data Transmission

The session explains how different HTTP verbs handle various data transmission patterns:

#### GET Method with Query String Parameters
Query strings pass visible data directly in URLs:
- Data passes as URL parameters (e.g., `?key=value&key2=value2`)
- Used for data retrieval operations
- Data is client-visible but cached on networks

#### POST Method with Headers
Embeds data in HTTP headers for secure transmission:
- Data included in request headers alongside custom metadata
- Supports complex authentication schemes
- Data remains hidden from URLs and logs

#### PUT Method for Binary Payloads
Handles file uploads and network packet data:
- Carries binary content (images, videos, PDFs, audio)
- Network packets contain the actual data payload
- Essential for client-to-server file transfers

### Lambda Function Integration

Building on previous sessions, the instructor demonstrates Lambda creation and API Gateway integration:

#### Lambda Configuration
- **Function Name**: `lw-function-2` (example)
- **Runtime**: Python
- **IAM Role**: CloudWatch permissions via `AWSServiceRoleForLambda`
- **Code**: Returns welcome message response

#### API Gateway Setup
- **API Type**: REST API
- **Resource**: `/lw` (custom endpoint)
- **Method**: GET method attached to resource
- **Integration**: Direct Lambda function invocation
- **CORS**: Browser-supported for cross-origin requests

#### Testing with Development Tools
Postman provides comprehensive API testing:
- **Collection Creation**: Organize API endpoints
- **Request Setup**: GET method with API Gateway URL
- **Authentication Headers**: Future session preparation
- **Response Verification**: Confirms Lambda response

### S3 Integration Concepts

The advanced portion demonstrates file upload architecture allowing external clients to store files in private S3 buckets through API Gateway:

#### Use Case Scenarios
- Customer file submission systems
- Team document repositories
- Multi-agency data collection
- Content management platforms

#### Architectural Flow
```mermaid
graph LR
    A[Client] -->|PUT /upload/{bucket}/{file}| B[API Gateway]
    B -->|PUT| C[S3 Bucket]
    C -.->|Trigger| D[Lambda Function]
    D -->|Process| E[Transcribe/Analysis]
```

#### Prerequisites Setup
1. **S3 Bucket Creation**
   ```yaml
   bucket_name: linux-world-bucket-images
   region: us-east-1
   access: private
   block_public_access: true
   ```

2. **IAM Role Configuration** 
   ```yaml
   role_name: api-gateway-s3-access
   service: apigateway.amazonaws.com
   permissions:
     - AmazonS3FullAccess
     - CloudWatchLogsFullAccess
   ```

3. **API Gateway Resource Structure**
   - Resource Path: `/upload/{bucket}/{key}`
   - Integration Type: AWS Service (S3)
   - Integration Method: PUT

### Path Parameter Mapping

Dynamic routing through path parameters enables flexible file storage:

#### Client Request Format
```
PUT /upload/{bucket}/{key}
├── bucket: Target S3 bucket name
└── key: File identifier/name
```

#### Integration Request Mapping
Path overrides configure the S3 destination:
```yaml
integration_request:
  path_override: "/upload/{bucket}/{key}"
  credentials: "arn:aws:iam::account:role/api-gateway-role"
  request_parameters:
    action: PutObject
    bucket: method.request.path.bucket
    key: method.request.path.key
```

### Binary Data Handling

API Gateway requires specific configuration to process file uploads:

#### Binary Media Types Configuration
```yaml
api_gateway_settings:
  binary_media_types:
    - image/jpeg
    - image/png
    - application/pdf
```

#### File Upload Process
```bash
# Client uploads via POSTMAN or curl
Content-Type: image/jpeg
Body: [binary file data]

# API Gateway processes as:
- Bucket: {bucket}
- Key: {key}  
- Body: Binary content
```

#### S3 Storage Result
- Files stored with specified bucket/key paths
- Supports multi-part uploads through API Gateway
- Automatic metadata preservation

### Security with API Keys and Usage Plans

Enterprise-grade security prevents unauthorized access and enables monetization:

#### Usage Plan Structure
```yaml
usage_plan:
  name: basic-plan
  throttle:
    rate_limit: 100 # requests/second
    burst_limit: 15 # additional credits
  quota:
    limit: 10000 # requests/day
    period: DAY
  api_stages:
    - api_id: your-api-id
      stage: test
```

#### API Key Management
- **Key Generation**: Auto-generated unique identifiers
- **Plan Association**: Link keys to usage policies
- **Header Authentication**: `X-API-Key` header requirement
- **Tracking**: Monitor usage across subscribers

#### Implementation Steps
1. Create usage plan with throttling/quotas
2. Generate API keys for subscribers
3. Configure resources as API-key protected
4. Associate plans with deployment stages
5. Test authentication requirements

## Summary

### Key Takeaways
+ API Gateway enables secure, serverless connections between clients and backend services like S3, supporting multiple HTTP methods for diverse use cases
- Path parameters allow dynamic routing of file uploads to specific S3 buckets and keys, enabling flexible storage architectures
- Binary media type configuration in API Gateway unlocks file upload capabilities for images, documents, and multimedia
- API keys and usage plans provide enterprise-grade authentication, rate limiting, and billing integration for monetization
- S3 integration transforms private cloud storage into public-facing services through API Gateway proxying

### Quick Reference

**HTTP Methods Table:**

| Method | Purpose | Data Location | AWS Service Integration | Example |
|--------|---------|---------------|-------------------------|---------|
| GET | Data retrieval | Query parameters | Lambda function invoke | `/search?q=lambda` |
| POST | Data submission | Request headers/body | Lambda processing | User registration |
| PUT | File uploads | Binary payload | S3 object storage | Image/video uploads |

**API Gateway Configuration:**

```bash
# Enable binary media types
aws apigateway update-rest-api \
  --rest-api-id YOUR_API_ID \
  --patch-op add \
  --path /binaryMediaTypes \
  --value image/jpeg

# Create usage plan
aws apigateway create-usage-plan \
  --name basic-plan \
  --throttle rateLimit=100,burstLimit=15 \
  --quota limit=10000,offset=0,period=DAY

# Test with authentication
curl -X PUT https://api-gateway-url/test/upload/bucket/file.jpg \
     -H "X-API-Key: your-api-key" \
     --data-binary @image.jpg
```

### Expert Insight

#### Real-world Application
> **Serverless File Processing Pipelines**: API Gateway + S3 + Lambda forms the backbone of modern content processing systems. Files uploaded via public APIs trigger Lambda functions for format conversion, data extraction, and analysis - enabling automated workflows for document processing, media transcoding, and IoT data ingestion.

#### Expert Path
Build mastery through:
- **Request/Response Transformation**: Implement data mapping between client formats and backend expectations
- **Multi-Stage Deployments**: Configure separate development, staging, and production API Gateway environments
- **Cross-Region Architectures**: Design fault-tolerant multi-region setups for high availability
- **Advanced Authentication**: Integrate AWS Cognito User Pools and custom authorizers
- **Event-Driven Automation**: Chain S3 events to Lambda, Step Functions, and other services for comprehensive workflows

#### Common Pitfalls
- **Path Mapping Errors**: Misconfigured path overrides result in "Access Denied" when S3 bucket/key paths don't match integration requirements
- **Binary Type Oversights**: Forgetting to configure content types blocks file uploads, appearing as successful requests but corrupted data
- **Role Permission Gaps**: Insufficient IAM permissions cause integration failures despite correct API Gateway setup
- **Deployment Timing**: Configuration changes require redeployment; caching can mask updates for client testing
- **THeader Authentication**: Mixing authentication schemes without proper integration leads to inconsistent access control

#### Lesser-Known Facts
- S3 buckets maintain regional isolation despite global DNS resolution for content delivery
- API Gateway automatically manages CORS headers, enabling web applications to call APIs from different domains
- Binary data processing includes automatic base64 encoding/decoding between client and service integrations
- Versioning-enabled S3 buckets automatically retain file history without overriding during multiple uploads
- Directory-style paths like `/folder/subfolder/file.jpg` automatically create nested S3 prefixes during upload

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
