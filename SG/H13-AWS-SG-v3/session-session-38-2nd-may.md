# Session 38: Lambda@Edge and A/B Testing Implementation

## Table of Contents
1. [Session Overview](#session-overview)
2. [Edge Computing Fundamentals](#edge-computing-fundamentals)
3. [CloudFront Functions vs Lambda@Edge](#cloudfront-functions-vs-lambdaedge)
4. [Lambda@Edge Use Cases](#lambdaedge-use-cases)
5. [A/B Testing Implementation](#ab-testing-implementation)
6. [S3 Static Website Hosting](#s3-static-website-hosting)
7. [Lambda Function Deployment and Configuration](#lambda-function-deployment-and-configuration)
8. [CloudFront Distribution Setup](#cloudfront-distribution-setup)
9. [Cookie-Based Redirection](#cookie-based-redirection)
10. [Testing and Validation](#testing-and-validation)

## Session Overview

This session focuses on edge computing concepts and practical implementation of AWS Lambda@Edge for advanced use cases like A/B testing. The session covers the differences between CloudFront Functions and Lambda@Edge, deployment procedures, and how to implement dynamic content routing based on client requests without disturbing existing architectures.

## Edge Computing Fundamentals

Edge computing brings computation and data storage closer to the location where it's needed, rather than relying on centralized cloud locations. This approach reduces latency and improves performance by processing data at network edge locations.

Key characteristics:
- Distributed data centers worldwide (edge locations)
- Reduces round-trip time for data processing
- Enables real-time processing of client requests
- Supports serverless functions at edge locations

> [!IMPORTANT]
> Edge computing is particularly valuable for content delivery networks (CDNs) where CloudFront provides the edge infrastructure.

## CloudFront Functions vs Lambda@Edge

The session covers two primary methods for running code at edge locations:

### CloudFront Functions
- **Language Support**: JavaScript only
- **Runtime**: < 1 millisecond execution time
- **Memory**: Limited resources
- **Trigger Events**: Viewer Request and Viewer Response only
- **Use Cases**: Performance optimization, simple request/response modifications
- **Cost**: Lower cost, faster execution
- **Features**: Cannot modify origin interactions

### Lambda@Edge
- **Language Support**: JavaScript (Node.js), Python
- **Runtime**: Up to seconds execution time
- **Memory**: 128 MB to 10 GB allocation
- **Trigger Events**: Viewer Request, Viewer Response, Origin Request, Origin Response
- **Use Cases**: Complex processing, database interactions, advanced routing logic
- **Cost**: Higher cost than CloudFront Functions
- **Features**: Can redirect requests, modify request/response bodies, interact with origins

```diff
+ CloudFront Functions: Fast, simple transformations
- Lambda@Edge: Powerful but slower execution
! Choose based on computational complexity and latency requirements
```

## Lambda@Edge Use Cases

Beyond basic edge processing, Lambda@Edge enables several advanced scenarios:

### Real-time Image Transformation
- Process images on-demand at edge locations
- Reduce storage costs by generating variants dynamically
- Deliver optimized images based on client device capabilities

### Dynamic Application Routing
- Route requests to different backends based on logic
- Implement API versioning at edge
- Load balancing across multiple origin servers

### Authentication and Security
- Insert authentication tokens before reaching origin
- Implement custom authentication logic at edge
- Add security headers to responses

### A/B Testing (Main Demo Topic)
- Switch between different versions of applications
- Route traffic based on cookies or request parameters
- Test new features without modifying existing architecture

> [!NOTE]
> The key advantage of Lambda@Edge is its ability to make routing decisions before requests reach your origin infrastructure.

## A/B Testing Implementation

The session demonstrates A/B testing using Lambda@Edge to seamlessly switch between old and new website versions without changing client URLs.

### Architecture Overview

```mermaid
graph TD
    A[Client] --> B[CloudFront Distribution]
    B --> C{Origin Request Trigger}
    C --> D[Lambda@Edge Function]
    D --> E{Check Cookies}
    E -->|Old/Default| F[Old Website S3]
    E -->|New| G[New Website S3]
    F --> H[Response to Client]
    G --> H
```

### Implementation Steps

1. **Deploy Two Website Versions**
   - Old version: Existing user interface
   - New version: Enhanced UI with new features
   - Both hosted as static S3 websites

2. **Lambda Function Logic**
   - Intercept requests at origin level
   - Read client cookies to determine version preference
   - Redirect request to appropriate S3 origin

3. **Cookie Management**
   - Client sets cookie (`version=new` or `version=old`)
   - Cookies persist across browser sessions
   - Lambda reads cookies in each request

### User Experience
- Single CloudFront URL for all users
- Seamless switching between versions
- No URL changes required
- Response time remains fast due to edge execution

```diff
! Client Request → CloudFront → Lambda@Edge → Appropriate Origin → Response
+ No architecture changes required
+ Cookie-based state management
- Increased complexity in Lambda function
```

## S3 Static Website Hosting

### Bucket Configuration
- Enable static website hosting in S3 bucket properties
- Set default index.html page
- Configure public access policies

### Security Considerations
- Grant public read access via bucket policy
- Enable versioning for deployment rollback
- Use CloudFront Origin Access Control (OAC) for production

### Bucket Policy Example
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::bucket-name/*"
    }
  ]
}
```

> [!WARNING]
> Public bucket policies should be used cautiously and only when necessary. Consider implementing proper access controls in production environments.

## Lambda Function Deployment and Configuration

### Function Creation
- Location: Must be created in US East (N. Virginia) region
- Runtime: Node.js 18.x or Python 3.x
- Memory allocation: 128 MB - 10 GB based on requirements
- Execution timeout: Configure based on processing needs

### Code Structure
```javascript
exports.handler = async (event) => {
    const request = event.Records[0].cf.request;
    const headers = request.headers;

    // Check for cookies
    const cookies = headers.cookie || [];
    let redirectDomain = 'old-website.com'; // Default

    // Parse cookies and determine redirection
    cookies.forEach(cookie => {
        if (cookie.value.includes('version=new')) {
            redirectDomain = 'new-website.com';
        }
    });

    // Modify origin and return
    request.origin = {
        custom: {
            domainName: redirectDomain,
            port: 80,
            protocol: 'http',
            path: '',
            sslProtocols: ['TLSv1', 'TLSv1.1', 'TLSv1.2']
        }
    };

    return request;
};
```

> [!NOTE]
> Lambda@Edge functions are deployed to all edge locations globally. Changes require CloudFront distribution invalidation for immediate effect.

## CloudFront Distribution Setup

### Origin Configuration
- Define custom origins for S3 buckets
- Configure origin domain names
- Set origins as HTTP (port 80)
- Disable SSL certificate validation for non-HTTPS origins

### Behavior Settings
- Default behavior routes all requests through Lambda
- Origin Request trigger enabled
- Cookie whitelisting configured in cache policies

### Cache Policy Configuration
- Include specific cookies in forwarding policy
- Enable cookie filtering for security
- Configure header forwarding as needed

```diff
+ Security Best Practice: Only forward necessary cookies to Lambda@Edge
- Avoid forwarding sensitive authentication cookies
! Whitelist specific cookies required for logic processing
```

## Cookie-Based Redirection

### Cookie Implementation in Client JavaScript
```javascript
function switchToNewVersion() {
    document.cookie = "version=new; path=/; max-age=31536000";
    location.reload();
}

function switchToOldVersion() {
    document.cookie = "version=old; path=/; max-age=31536000";
    location.reload();
}
```

### Lambda Cookie Parsing
- Extract cookies from CloudFront request headers
- Parse cookie values to determine routing logic
- Default to old version if no valid cookie found
- Update routing based on cookie state

### State Persistence
- Cookies remain valid across browser sessions
- Users maintain their version preference
- Version switching happens client-side via UI buttons

> [!IMPORTANT]
> Cookies are sent in every request to CloudFront, enabling Lambda functions to maintain state between requests.

## Testing and Validation

### Monitoring Lambda Execution
- CloudWatch logs capture Lambda@Edge executions
- Monitor invocation counts and error rates
- Verify function behavior through CloudFront logs

### Validation Steps
1. Test default routing (no cookies)
2. Test cookie-based switching
3. Verify seamless version transitions
4. Check performance impact on response times
5. Validate that both versions remain functional

### Debugging Challenges
- Lambda@Edge logs may have delays
- Function updates require distribution deployment time
- Cross-region replication adds complexity
- Cookie security considerations for production

## Summary

### Key Takeaways
```diff
+ Lambda@Edge enables advanced serverless processing at CloudFront edge locations
+ Supports complex routing logic including A/B testing and authentication
+ Integrates seamlessly with existing CloudFront distributions
- Requires functions to be deployed in US East (N. Virginia) region only
+ Cookie-based state management enables persistent user preferences
+ Can handle both simple transformations and complex business logic
```

### Quick Reference

**Key Commands:**
- `podman run` - Deploy containers (from previous context)
- CloudFront CLI operations for distribution management
- Lambda deployment commands (region-specific)
- S3 bucket policy configuration

**Important Configurations:**
- Cookie whitelisting in CloudFront cache policies
- Origin request triggers for Lambda@Edge
- S3 static website hosting setup
- Lambda function memory allocation (128MB-10GB)

### Expert Insight

**Real-world Application:**
Lambda@Edge excels in scenarios requiring intelligent traffic routing, authentication, and content personalization at the network edge. Major websites use similar techniques for gradual feature rollouts and performance optimization.

**Expert Path:**
- Master CloudFront edge computing patterns
- Understand cookie security and state management
- Learn Serverless architecture design at scale
- Explore Lambda@Edge integration with CloudWatch and monitoring tools

**Common Pitfalls:**
- ✅ Not configuring cookie forwarding properly in CloudFront
- ✅ Deploying Lambda functions in incorrect regions
- ✅ Overlooking security implications of cookie sharing
- ✅ Not accounting for edge location deployment delays

**Lesser-Known Facts:**
- Lambda@Edge functions run in a sandboxed environment at edge locations
- Functions automatically scale based on CloudFront request volume
- Edge locations maintain function code in memory for faster execution
- Cross-regions calls are impossible - all edge processing must be stateless and self-contained

---

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
