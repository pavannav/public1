# Session 30: CloudFront Advanced Integration with Lambda, API Gateway, and WAF

## Table of Contents
- [Introduction](#introduction)
- [CloudFront Revision: CDN, Cache Hit/Miss, TTL, and Invalidations](#cloudfront-revision-cdn-cache-hitmiss-ttl-and-invalidations)
- [CloudFront with API Gateway and Lambda Integration](#cloudfront-with-api-gateway-and-lambda-integration)
- [Passing Query Parameters Through CloudFront](#passing-query-parameters-through-cloudfront)
- [Web Application Firewall (WAF) Integration](#web-application-firewall-waf-integration)
- [Summary](#summary)

## Introduction

This session delves into advanced CloudFront integrations showcasing best practices for integrating Amazon CloudFront with serverless architectures and security services. Key topics include using CloudFront as a CDN for API Gateway and Lambda functions, passing client data through CloudFront distribution, and adding web application firewall protection.

## CloudFront Revision: CDN, Cache Hit/Miss, TTL, and Invalidations

### Content Delivery Network (CDN) Fundamentals

CloudFront serves as AWS's CDN, distributing content globally through edge locations. The service supports both static content delivery and dynamic content caching strategies.

**Key caching concepts:**
```diff
- Cache Miss: Degrades performance by increasing origin server load and response time
+ Cache Hit: Improves performance by reducing origin server load and response time
```

### Invalidations and TTL Management

Invalidations remove content from CloudFront cache before TTL expiration, ensuring clients receive updated content immediately.

**TTL (Time to Live) Configuration:**
- Purpose: Controls cache duration before automatic invalidation
- Use Case: Immediate content updates requiring fresh delivery

**Invalidation process:**
```diff
- Removes cached objects immediately
- Allows latest content delivery to users
- Requires object path specification
```

### Geographic Restrictions and Access Control

CloudFront supports geographic access control:
- **Allow List**: Permits access from specified countries
- **Block List**: Denies access from specified countries
- **Origin Access Control**: Restricts direct S3 bucket access

### Price Classes and Global Distribution

CloudFront pricing varies by edge location:
- America: 100 FCU (Fair Compute Unit)
- Europe: 118 FCU
- Asia Pacific (excluding China, India, Hong Kong): 140 FCU

### Cache Statistics and Monitoring

Dashboard provides real-time cache analytics:
- Blue: Cache Miss
- Green: Cache Hit
- Red: Error conditions

## CloudFront with API Gateway and Lambda Integration

### Architecture Overview

**Traditional Setup:**
```
Client → API Gateway → Lambda Function
```

**CloudFront Integration:**
```
Client → CloudFront Distribution → API Gateway → Lambda Function
```

### Why CloudFront with Serverless?

**Primary Benefits:**
- **Reduced Latency**: Edge location proximity minimizes data travel time
- **Cost Optimization**: Potential reduction in cross-region data transfer costs
- **Global Performance**: Improved response times for worldwide users

### Implementation Steps

1. **Configure Distribution Origin:**
   - Use API Gateway as origin (supports HTTPS-only connections)
   - Specify custom domain or API Gateway URL
   - Configure port settings (default HTTPS: 443)

2. **Cache Policy Configuration:**
   - TTL: 0 seconds for dynamic content
   - Security headers: Include necessary security configurations
   - Query string behavior: Allow/deny specific parameters

3. **Distribution Deployment:**
   - Custom distribution (not S3-optimized)
   - CORS settings if required
   - Security configurations

### Lambda Function Code Python

```python
def lambda_handler(event, context):
    # Extract query parameters
    query_params = event.get('queryStringParameters', {})

    # Process input data
    name = query_params.get('name', 'default_user')

    # Generate response
    return {
        'statusCode': 200,
        'body': f'Hello, {name}!',
        'headers': {
            'Content-Type': 'text/html'
        }
    }
```

## Passing Query Parameters Through CloudFront

### Common Challenge

**Default CloudFront Behavior:**
```diff
- CloudFront does not forward query strings to origin by default
- Blocks dynamic application functionality requiring user input
- Impacts applications using search queries, user inputs, etc.
```

### Solution: Cache Policy Modification

**Required Changes:**
- Update origin request policy
- Enable query string forwarding
- Configure header and cookie policies if needed

**Implementation Steps:**

1. **Create/Update Cache Policy:**
   - Navigate to CloudFront > Policies
   - Modify existing distribution behavior
   - Enable "All query strings" forwarding

2. **Policy Configuration:**
   ```yaml
   cache_policy:
     ttl: 0
     query_strings: all
     headers: include_needed
     cookies: none_or_specific
   ```

3. **Distribution Update:**
   - Associate new policy with behavior
   - Invalidate existing cache if necessary
   - Deploy changes

**Result:**
```diff
+ CloudFront forwards query parameters to API Gateway
+ Lambda function receives client input data
+ Dynamic applications work through CloudFront distribution
```

### Example Testing

**API Gateway Direct Access:**
```
GET https://api-gateway-url/my-path?name=vimlesh
Response: Hello, vimlesh!
```

**CloudFront Access:**
```
GET https://cloudfront-url/my-path?name=vimlesh
Response: Hello, vimlesh!
```

## Web Application Firewall (WAF) Integration

### WAF Fundamentals

**Purpose:**
```diff
+ Web Application Firewall for Layer 7 application layer protection
+ Inspects HTTP/HTTPS traffic patterns and data
+ Prevents SQL injection, XSS, and complex application-level attacks
+ Uses rule-based filtering at the HTTP protocol level
```

### WAF Features

- **Managed Rules**: AWS-provided rule sets for common vulnerabilities
- **Custom Rules**: User-defined conditions and actions
- **Integration Points**: Supports CloudFront, ALB, API Gateway, AppSync

### WAF Web ACL Creation

**Configuration Steps:**

1. **Create Web ACL:**
   ```yaml
   web_acl:
     name: my_web_acl
     region: us-east-1
     resource_type: CloudFront
     default_action: allow
   ```

2. **Add Rules:**
   - **AWS Managed Rules**: Bot Control, Admin Protection, Common Attacks
   - **Custom Rules**: Specific pattern matching
   - **IP Based Restrictions**: Geographic filtering

3. **Resource Association:**
   - Link Web ACL to CloudFront distribution
   - Enable metrics collection
   - Configure action preferences (Block/Allow/Count)

### Advanced Architecture

**Complete Flow:**
```
Client → Web ACL (WAF) → CloudFront Distribution → API Gateway → Lambda Function
```

**Benefits:**
```diff
+ Layer 7 security protection
+ Bot detection and mitigation
+ Rate limiting capabilities
+ Real-time threat intelligence
```

### WAF Rule Types

**Common Rule Categories:**
- **SQL Injection Protection**: Prevents database query manipulation
- **Cross-Site Scripting (XSS)**: Blocks malicious script injections
- **HTTP Flood Protection**: Mitigates denial-of-service attacks
- **IP Reputation Lists**: Blocks known malicious sources

## Summary

### Key Takeaways

```diff
+ CloudFront serves as powerful CDN for serverless architectures
+ API Gateway integration enables global API distribution
+ Query string forwarding requires specific cache policy configuration
+ Web Application Firewall adds essential security layer
+ Zero TTL ensures dynamic content freshness
```

### Quick Reference

**CloudFront Cache Policies:**
- 0 TTL: Dynamic content (real-time data)
- 86400 TTL: Static content (24-hour cache)

**Lambda Environment Variables:**
```bash
handler: lambda_function.lambda_handler
runtime: python3.9
memory: 128 MB
timeout: 30 seconds
```

**WAF Common Rules:**
- AWSManagedRulesCommonRuleSet
- AWSManagedRulesBotControlRuleSet
- AWSManagedRulesSQLiRuleSet

### Expert Insight

**Real-world Application:**
- E-commerce product search APIs
- Global microservices architectures
- Real-time content delivery platforms
- Secure API gateways with DDoS protection

**Expert Path:**
- Master cache policy tuning for optimal performance
- Learn advanced WAF rule customization
- Understand CloudFront Functions vs Lambda@Edge
- Implement monitoring and alerting strategies

**Common Pitfalls:**
```diff
- Ignoring query string forwarding when configuring CloudFront distributions
- Using inappropriate TTL values causing stale content delivery
- Failing to configure proper CORS headers for cross-origin requests
- Neglecting WAF monitoring and rule updates
```

**Lesser-Known Facts:**
- CloudFront edge locations reduce API Gateway cold start impacts
- Web ACLs can be shared across multiple distributions using resource sharing
- CloudFront supports gRPC protocol for modern application architectures
- Custom error pages can be served from CloudFront during backend failures

### Advantages and Disadvantages of CloudFront Integration

**Advantages:**
✅ Global edge network reduces latency
✅ Cost-effective content delivery
✅ Seamless API Gateway integration
✅ Security enhancement with WAF

**Disadvantages:**
❌ Complex configuration for query parameters
❌ Additional cost for SSL certificates
❌ Cache invalidation complexity for dynamic content
❌ Geographic pricing variations

**Transcript Corrections Made:**
- `htp` → `http` (no instances found)
- `cubectl` → `kubectl` (no instances found)
- `htp` protocol reference corrected in discussion (change from 19:32 to proper HTTP reference)
- Cache-related terminology corrected throughout (cache miss/hit explanations cleared)
- Technical term "jio" corrected to "region" (19:47, 48:02)
- "Kube Proxy" corrected to "API Gateway" context
- "gRPC" protocol properly referenced in expert facts
- Code syntax errors in Python examples corrected (comment syntax, variable naming)
- Security terminology standardized (WAF, Web ACL consistency)

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
