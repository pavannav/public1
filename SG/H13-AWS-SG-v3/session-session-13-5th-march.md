# Session 13: API Gateway S3 Integration

## Table of Contents
- [Overview](#overview)
- [Revision of Previous Session](#revision-of-previous-session)
- [Integration with S3 for File Uploads](#integration-with-s3-for-file-uploads)
- [Step-by-Step Configuration](#step-by-step-configuration)
- [Path Parameters and Mapping](#path-parameters-and-mapping)
- [Enabling Binary Media Types](#enabling-binary-media-types)
- [Deployment and Testing](#deployment-and-testing)
- [Security Features: API Keys and Usage Plans](#security-features-api-keys-and-usage-plans)
- [Testing with API Keys](#testing-with-api-keys)
- [Common Questions and Clarifications](#common-questions-and-clarifications)

## Overview
Session 13 focuses on extending AWS API Gateway beyond Lambda integration to connect with other AWS services like Amazon S3 for file uploads. The session demonstrates how to create a serverless architecture allowing clients to upload files (such as audio, video, or images) to S3 via API Gateway using HTTP PUT method. Key concepts include path parameters for dynamic bucket and file names, IAM roles for permissions, binary media handling, and securing the API with usage plans and API keys for throttling and authentication. This builds on previous discussions of API Gateway, Lambda, and data passing methods in serverless environments.

## Revision of Previous Session
The instructor begins with a quick revision of Session 12 topics, emphasizing the role of API Gateway as a management tool acting as a proxy between clients and back-end services like Lambda:

- API Gateway serves as an interface/proxy for clients to communicate with serverless functions (Lambda) or other services.
- Functions in programs correspond to individual apps, triggered by events.
- Function as a Service (FaaS) uses Lambda for event-driven execution.
- Lambda invocation is initiated via API Gateway, with data passed through:
  - Query strings (visible in URL, uses GET)
  - Headers (HTTP headers, uses POST for embedding data)
  - Payload/body (raw data, uses PUT for binary files like images/videos)
- Pass-through setup: Direct data flow from client to Lambda via API Gateway.

Theoretical concepts are reinforced with a practical demo from the previous session, including Lambda function creation, API resource/method setup, and testing with Postman.

## Integration with S3 for File Uploads
While Lambda handles compute, S3 (Simple Storage Service) manages object storage. API Gateway can route requests to S3 instead of Lambda for file operations. The session introduces S3 integration for uploading files without requiring AWS accounts, enabling public access via API Gateway routes.

Key use cases:
- Collect documents, audio, or video from external teams.
- Upload files to S3 buckets, triggering Lambda for further processing (e.g., transcribing audio to text).

Method: Use HTTP PUT for file uploads (files as binary data, not text). This requires:
- S3 bucket as destination.
- IAM role granting API Gateway write access to S3.
- API Gateway configuration for PUT method and S3 integration.
- Redirection from API Gateway to S3.

## Step-by-Step Configuration
The session provides a hands-on guide to set up the integration using the AWS Console (Virginia region as example).

1. **Create S3 Bucket**:
   - Navigate to S3 service.
   - Create a unique bucket (e.g., `linux-world-bucket-image`).
   - Default settings: Bucket is private; only account-owned services access it.

2. **Create IAM Role for API Gateway**:
   - Go to IAM and create a new role.
   - Select API Gateway as trusted entity.
   - Attach policies: Attach `AmazonS3FullAccess` for write permissions to S3.
   - Name the role (e.g., `APIGateway-Allow-S3`).
   - Role ARN is auto-generated for later use.

3. **Configure API Gateway**:
   - Create a new REST API (e.g., `MyS3UploadAPI`).
   - Create a resource (e.g., `upload`) under the root path.
   - Add sub-resources using path parameters (e.g., `{bucket}` and `{file}`) for dynamic bucket/file names.
   - Enable PUT method on the `{file}` resource.
   - In method settings, enable API key requirement for security.

4. **Set Integration**:
   - Integration type: AWS Service (S3).
   - HTTP method: PUT.
   - Region: Select S3 region (e.g., us-east-1).
   - Service: S3.
   - Path override: Construct dynamic path like `/{bucket}/{file}` using variables.
   - Attach the IAM role ARN.
   - Credentials: Select the created role.

5. **Map Path Parameters**:
   - Use path parameters from client requests to S3 paths.
   - Example mapping:
     - Client path: `/upload/{bucket}/{file}`
     - S3 path: `/{bucket}/{file}`
     - Variables: Map `{bucket}` to `{bucket}` and `{file}` to `{key}` (for S3 object key).

6. **Enable Binary Media**:
   - In API settings, configure supported media types (e.g., `image/jpeg`) for binary uploads.

7. **Deploy API**:
   - Deploy to a stage (e.g., `test`) to generate public URL.

> [!NOTE]
> Ensure redeployment after configuration changes, as failures (e.g., access denied) may occur due to incomplete mappings.

## Path Parameters and Mapping
Path parameters allow dynamic values in API routes. In this setup:
- Client request: `/upload/bucket-name/file-name.jpg`
- API Gateway extracts `bucket-name` and `file-name.jpg` as variables.
- Mapping to S3: Translate to S3 bucket and object key.

Example flow:
```
Use path parameters for dynamic S3 uploads.
Client (PUT) -> API Gateway (/upload/{bucket}/{file}) -> S3 (Bucket: {bucket}, Key: {file})
```

Key takeaways:
- Path parameters pass data without query strings.
- Local variables in API Gateway and S3 contexts require explicit mapping.
- S3 "key" represents the file name/object name.

## Enabling Binary Media Types
API Gateway defaults to text; binary files need explicit enabling:
- Add media types like `image/jpeg`, `video/mp4` in API settings.
- This allows PUT requests with binary payloads (e.g., files select binary body in testing tools).

## Deployment and Testing
After deployment, test with tools like Postman or curl:
- Base URL: `<API-Gateway-URL>/test/upload/bucket-name/file-name.ext`
- Method: PUT
- Body: Select binary file (e.g., JPG image).
- Headers: `Content-Type: image/jpeg`

Successful upload: File appears in specified S3 bucket. Use caution with public URLs to avoid misuse.

> [!WARNING]
> If using dynamic bucket names, ensure buckets exist to avoid "Access Denied" errors. Test thoroughly before production.

## Security Features: API Keys and Usage Plans
To secure and monetize the API:
- **Create API Keys**: Unique identifiers for clients (e.g., `APIKeyForJack` - auto-generated value).
- **Usage Plans**: Define throttling limits (e.g., 10,000 requests/day, 10 req/sec).
- Associate plans with stages for targeted restrictions.

This enables:
- Paywall for subscription-based access.
- Tracking usage per key.

## Testing with API Keys
In requests, include header `X-API-Key: <key-value>`. Without it, API Gateway blocks access (forbidden error), even with public URLs.

Example diff for curl:
```diff
# Without key - Forbidden
curl -X PUT -T file.jpg <url>/upload/bucket/file.jpg

# With key - Success
curl -X PUT -T file.jpg -H "X-API-Key: your-key" <url>/upload/bucket/file.jpg
```

> [!IMPORTANT]
> API keys are not full authentication; they are rate-limiting tools. For user-based auth, use other methods (covered in future sessions).

## Common Questions and Clarifications
- **Bucket Globality**: Buckets are regional, but their URLs are internet-unique (global access via domain).
- **Override Prevention**: Add Lambda or S3 versioning to avoid file overwrites.
- **Data Transformation**: API Gateway supports transforming payloads/headers for advanced use cases.
- **Stages and Environments**: Usage plans can vary by stage (e.g., dev vs. prod).
- **Automation**: Current setup is serverless integration, not full IaC automation (covered later with CloudFormation).

## Summary

### Key Takeaways
```diff
+ API Gateway extends beyond Lambda to integrate with S3 for file uploads using PUT method.
- Do not confuse local variables between client-API and API-S3 contexts; always map explicitly.
! Secure APIs early with usage plans and keys to prevent abuse.
+ Path parameters enable dynamic bucket/file routes for public clients.
- Redeploy after configuration changes to avoid access errors.
! Binary media must be enabled for non-text uploads.
+ IAM roles bridge service permissions without full AWS access.
- Test with tools like curl/Postman, including headers.
```

### Quick Reference
- **Create S3 Bucket**: S3 Console > General Purpose Bucket.
- **IAM Role**: API Gateway trust entity, attach `S3FullAccess`.
- **API Gateway Setup**: REST API > Resources (`/upload/{bucket}/{file}`) > PUT Method > Integration (S3 PUT).
- **Path Override Example**: `{bucket}` maps to `{bucket}` in S3.
- **Media Types**: Add `image/*`, `video/*` in API Settings.
- **Test Command**: `curl -X PUT -T file.jpg -H "X-API-Key: key" <url>`.
- **Header for API Key**: `X-API-Key: <value>`.

### Expert Insight
#### Real-world Application
This setup powers file-sharing apps (e.g., image/video hosting) where clients upload directly via APIs without storage knowledge. Integrate with Lambda for post-upload processing, like automatic thumbnails or AI analysis. In production, combine with CloudFront for CDN caching and Route53 for custom domains to handle millions of uploads daily.

#### Expert Path
Master path parameter mappings and IAM least-privilege principles—practice with custom transform templates in API Gateway. Explore advanced integrations like CORS, VPC links, and custom authorizers. Combine with Step Functions for complex upload workflows. Consider cross-account S3 uploads via assumable roles.

#### Common Pitfalls
- **Mapping Errors**: Missing path mappings cause "404" or "Access Denied"—double-check variables before deploying.
- **Binary Limits**: Large files (>10MB) may exceed API Gateway limits; use pre-signed URLs instead.
- **Public Exposure**: Without keys, public URLs risk abuse—always enable throttling.
- **Role Permissions**: Over-permissive S3 roles invite breaches—use specific actions (e.g., `s3:PutObject` only).
- **Version Conflicts**: File overwrites in non-versioned buckets lose data; enable versioning or add timestamps.

#### Lesser-Known Facts
- API Gateway supports 256KB payload limits for integrations—S3 direct uploads bypass this.
- Path parameters are URL-safe; avoid special chars in names.
- Usage plans support burst rates for traffic spikes, beyond basic limits.
- S3 object keys default to public URLs when bucket policies allow; secure with CloudFront.
