# Session 38: Lambda@Edge and A/B Testing Implementation

## Table of Contents
- [Overview](#overview)
- [Key Concepts](#key-concepts)
- [Deep Dive: A/B Testing Implementation](#deep-dive-ab-testing-implementation)
- [Lambda Function Code](#lambda-function-code)
- [Summary](#summary)

## Overview

This session continues the exploration of edge computing by demonstrating Lambda@Edge, a powerful AWS service that runs Lambda functions at CloudFront edge locations. The instructor implements a real-world A/B testing use case, showing how to seamlessly redirect users between old and new website versions based on browser cookies while maintaining a single CloudFront distribution URL.

## Key Concepts

### Lambda@Edge vs CloudFront Functions

| Aspect | CloudFront Functions | Lambda@Edge |
|--------|---------------------|-------------|
| Execution Time | < 1 millisecond | > 1 millisecond |
| Language Support | JavaScript only | Node.js, Python, Java |
| Memory | Limited | Up to 10 GB |
| Triggers | Viewer Request, Viewer Response | Origin Request, Origin Response, Viewer Request, Viewer Response |
| Use Cases | Fast, lightweight modifications | Complex processing, large payloads |

### Lambda@Edge Use Cases

- **A/B Testing**: Redirect users between different website versions based on cookies or headers
- **Dynamic Content Modification**: Transform requests/responses at edge locations
- **Web Security**: Add authentication headers, tokens, or security measures
- **Real-time Image Processing**: Transform images before caching or delivery
- **Geographic Redirection**: Route users based on location data

### Edge Location Benefits

- **Latency Reduction**: Functions execute closer to users
- **Global Scale**: Code runs across AWS's edge network
- **CloudFront Integration**: Seamless interaction with CDN caching

## Deep Dive: A/B Testing Implementation

### 1. S3 Setup for Dual Website Hosting

Create two S3 buckets for hosting static websites:

```bash
# Create buckets (replace with your bucket names)
aws s3 mb s3://my-old-website-bucket
aws s3 mb s3://my-new-website-bucket
```

Enable static website hosting on both buckets:
- Navigate to bucket → Properties → Static website hosting
- Enable hosting, set index document to `index.html`

### 2. Bucket Permissions for Public Access

Apply bucket policies to allow public read access:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::your-bucket-name/*"
        }
    ]
}
```

> [!WARNING]
> Public bucket policies should only be used for read access. For production environments, consider CloudFront Origin Access Identity (OAI) for secure S3 access.

### 3. Upload Website Content

Upload HTML/JavaScript files to respective buckets:

- **Old Website (`index.html`)**: Contains button to switch to "new experience"
- **New Website (`index.html`)**: Contains content, button to switch back to "old"

HTML structure includes JavaScript event handlers that set cookies:

```javascript
// On button click to switch to new
document.cookie = "version=new";

// On button click to switch to old  
document.cookie = "version=old";
```

### 4. CloudFront Distribution Creation

Create a CloudFront distribution pointing to the old website:

- **Origin Domain**: S3 bucket website endpoint
- **Default Root Object**: `index.html`
- **Cache Policy**: Allow cookies (specifically `version`)

### 5. Lambda@Edge Function Development

Create Lambda function in Node.js runtime with edge location deployment:

```javascript
exports.handler = async (event) => {
    const request = event.Records[0].cf.request;
    
    // Extract cookies from request
    const cookies = request.headers.cookie || [];
    let version = 'old'; // Default
    
    // Parse cookies to find version
    cookies.forEach(cookie => {
        if (cookie.value.includes('version=new')) {
            version = 'new';
        }
    });
    
    // Redirect logic
    if (version === 'new') {
        request.origin.custom.domainName = 'new-website-bucket.s3-website-us-east-1.amazonaws.com';
    } else {
        request.origin.custom.domainName = 'old-website-bucket.s3-website-us-east-1.amazonaws.com';
    }
    
    return request;
};
```

### 6. CloudFront-Lambda@Edge Integration

- Deploy Lambda function to edge locations via CloudFront trigger
- Configure CloudFront behavior:
  - **Event Type**: Origin Request (triggers before cache or origin)
  - **Include Cookies**: Yes (whitelist specific cookies like `version`)

### 7. Testing and Verification

1. **Access CloudFront URL** → Should load old website by default
2. **Click "New Experience" button** → Sets `version=new` cookie
3. **Refresh page** → Lambda@Edge redirects to new website S3 bucket
4. **Click "Switch to Old" button** → Sets `version=old` cookie
5. **Refresh page** → Redirects back to old website

> [!NOTE]
> Lambda@Edge functions run in US East (N. Virginia) region only. Current support may have expanded, so check AWS documentation.

### Lambda Function Code

**Complete Lambda@Edge function for A/B testing**:

```javascript
'use strict';

exports.handler = (event, context, callback) => {
    const request = event.Records[0].cf.request;
    
    // Default to old website
    let domainName = 'old-website-bucket.s3-website-us-east-1.amazonaws.com';
    
    if (request.headers.cookie) {
        const cookies = request.headers.cookie;
        
        cookies.forEach(cookie => {
            if (cookie.value.indexOf('version=new') !== -1) {
                domainName = 'new-website-bucket.s3-website-us-east-1.amazonaws.com';
            }
        });
    }
    
    request.origin.custom.domainName = domainName;
    
    return callback(null, request);
};
```

## Summary

### Key Takeaways

```diff
+ Lambda@Edge enables serverless function execution at CloudFront edge locations
+ CloudFront Functions: Fast (<1ms), lightweight operations
- Lambda@Edge: More powerful, longer execution time, supports complex logic
+ Cookies and headers can trigger edge-based redirection for A/B testing
+ Single CloudFront URL serves multiple backend origins dynamically
+ Edge processing reduces latency by executing code closer to users
```

### Quick Reference

**Lambda@Edge Triggers:**
- `Viewer Request`: When CloudFront receives request from client
- `Viewer Response`: Before CloudFront returns response to client  
- `Origin Request`: Before CloudFront forwards request to origin
- `Origin Response`: After origin responds, before caching

**Cookie-Based Redirection Commands:**
```javascript
// Set cookie to switch versions
document.cookie = "version=new";

// Check current version in Lambda@Edge
const cookies = request.headers.cookie;
cookies.forEach(cookie => {
    if (cookie.value.includes('version=new')) {
        // Redirect to new website
    }
});
```

**CloudFront Distribution Configuration:**
- Origin: S3 static website endpoint
- Cache Policy: Whitelist cookies and headers needed for logic
- Lambda@Edge Association: Origin Request trigger

### Expert Insight

#### Real-World Application
Lambda@Edge powers modern web applications by enabling dynamic content routing, security enhancements, and personalized experiences. Companies use it for geo-based content delivery, A/B testing complex UI changes, and implementing zero-trust security models at the edge.

#### Expert Path
Master Lambda@Edge by:
1. Understanding CloudFront caching behaviors and invalidation patterns
2. Learning Node.js/Python for edge function development
3. Designing cookie/header-based routing logic
4. Monitoring Lambda@Edge performance with CloudWatch
5. Implementing edge security headers and origin shield protection

#### Common Pitfalls
- **Cookie Forwarding**: By default, CloudFront doesn't forward cookies to Lambda@Edge for security. Must configure cache policies to include relevant cookies.
- **Regional Limitations**: Lambda@Edge functions must be created in US East (N. Virginia) region only.
- **Execution Limits**: Functions have cold start delays and execution time limits. Design for sub-second performance.
- **Testing Complexity**: Edge functions deploy globally, making local testing challenging. Use CloudWatch logs and staging distributions for validation.

#### Lesser-Known Facts
- Lambda@Edge supports up to 256 KB of environment variables
- Functions can be versioned and deployed to specific edge locations
- CloudFront Origin Access Control (OAC) is recommended over public S3 bucket policies for secure static website delivery
- Edge functions can modify response headers but not request bodies by default (requires special handling)
