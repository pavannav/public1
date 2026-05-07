# Session 29: AWS CloudFront CDN Implementation

## Table of Contents
- [Overview](#overview)
- [Key Concepts](#key-concepts)
- [Global Accelerator vs CloudFront](#global-accelerator-vs-cloudfront)
- [CloudFront Distribution Setup](#cloudfront-distribution-setup)
- [Practical Implementation: EC2 + S3 + PHP](#practical-implementation-ec2--s3--php)
- [Caching Mechanics](#caching-mechanics)
- [Pricing Classes](#pricing-classes)
- [Performance Monitoring](#performance-monitoring)
- [Cache Invalidation](#cache-invalidation)
- [Geographic Restrictions](#geographic-restrictions)
- [Advanced Integration](#advanced-integration)
- [Summary](#summary)

## Overview

This session covers AWS CloudFront, Amazon's Content Delivery Network (CDN) service that delivers content with low latency and high transfer speeds. The instructor demonstrates full web application setup combining dynamic EC2 content with cached S3 static assets, including practical implementation, pricing strategies, and advanced configuration.

## Key Concepts

### Content Delivery Network (CDN) Fundamentals
- **CDN**: Global network of servers that distribute content closer to users
- **Edge Locations**: AWS data centers worldwide (400+) hosting cached content
- **Distribution**: CloudFront configuration unit for content delivery
- **Origin**: Content source (S3, EC2, API Gateway, Load Balancers, custom HTTP/HTTPS)

### Cache Mechanisms
```diff
+ Cache Hit: Content served from edge location (fast)
- Cache Miss: First request requires origin fetch (slower)
! TTL: Content expiry time in cache
```

**Common static content for CDN:**
- Images, Videos, PDFs
- CSS, JavaScript files
- Media files
- Download packages

**When NOT to cache:**
- Dynamic content (real-time data)
- User-specific content
- Sensitive data

## Global Accelerator vs CloudFront

| Aspect | Global Accelerator | CloudFront |
|--------|-------------------|------------|
| **Purpose** | Route traffic to optimal endpoint | Content delivery with caching |
| **Protocol Support** | TCP/UDP | HTTP/HTTPS/WebSocket |
| **Use Cases** | App performance, failover | Content distribution, static assets |
| **Architecture** | AnyCast IP + edge network | Edge locations with origins |
| **Pricing Model** | Traffic-based | Data transfer + requests |

```diff
+ Global Accelerator: Always routes to final endpoint
- CloudFront: Uses intermediate caching
! Both leverage AWS global network infrastructure
```

## CloudFront Distribution Setup

### Step-by-Step Distribution Creation

1. **Navigate to CloudFront Console**
   - US East (N. Virginia) region (global service, region-independent)

2. **Create Distribution**
   - Origin Type: Web (delivery)
   - Origin Settings:
     - Origin Domain: Select S3 bucket (auto-detected)
     - Protocol Policy: HTTPS Only (recommended)
     - Origin Path: Subfolder (optional)
     - Origin ID: Descriptive name

3. **Default Cache Behavior**
   - Viewer Protocol Policy: Redirect HTTP to HTTPS
   - Allowed HTTP Methods: GET, HEAD, OPTIONS
   - TTL Settings: Use default (24 hours)
   - Forward Headers: None (caching friendly)

4. **Distribution Settings**
   - Price Class: All edge locations (recommended for global)
   - Default Root Object: `index.html` or specific object

5. **Deploy Distribution** (5-15 minutes propagation)

### Distribution URL Format
```
https://d<distribution-id>.cloudfront.net/
Example: https://d123456789abc.cloudfront.net/
```

## Practical Implementation: EC2 + S3 + PHP

### Architecture Overview
```
User → CloudFront → Edge Location (Cache) 
                    ↘ Origin (Fallback)
                S3 Static
              ↗
           EC2 Dynamic
```

### Step 1: EC2 Web Server Setup

```bash
# Launch EC2 instance (Windows/Linux, instructor used Windows)
Region: us-east-1 (North Virginia)
Name: webOS123
Key Pair: Proceed without (for demo)
Security Group: RDP + HTTP access from 0.0.0.0/0

# Install web server
yum install httpd php -y
systemctl enable httpd
systemctl start httpd
```

### Step 2: Create PHP Application

File: `/var/www/html/index.php`

```php
<?php
echo "Hi PHP<br>";
echo "Current Date/Time: " . date('Y-m-d H:i:s');
?>

<img src="https://webcts-lw.s3.amazonaws.com/mypng.jpg" alt="Static Image" />
```

### Step 3: S3 Bucket Configuration

```bash
# Create bucket
Bucket Name: webcts-lw (must be globally unique)
Region: us-east-1
ACLs: Enabled
Bucket Key: Enabled

# Upload static content
Upload image.jpg (or mypng.jpg)
Permissions: Make public using ACL
Copy object URL for PHP integration
```

### Step 4: CloudFront Distribution Integration

**Replace S3 URL with CloudFront URL:**

```php
# Before (direct S3)
<img src="https://webcts-lw.s3.amazonaws.com/mypng.jpg" />

# After (CloudFront)
<img src="https://d123.cloudfront.net/mypng.jpg" />
```

**Performance Comparison:**
- Direct S3: Cross-ocean latency (200-500ms)
- CloudFront: Local edge access (<50ms)

## Caching Mechanics

### Cache Hit vs Miss Process

**Cache Miss (First Request):**
```bash
User → CloudFront URL
     ↓
Edge Location (Cache Check: MISS)
     ↓
Origin (S3/EC2) Fetch Content
     ↓
Edge Location Create Cache
     ↓
Serve Content to User
```

**Cache Hit (Subsequent Requests):**
```bash
User → CloudFront URL
     ↓
Edge Location (Cache Check: HIT)
     ↓
Serve Cached Content (Instant)
```

### TTL Management
- Default: 24 hours
- Custom TTL: Minutes/Hours/Days
- Zero TTL: No caching (dynamic content)

### Real-World Optimization
```diff
+ Static Files: Long TTL (7+ days)
- API Responses: Short TTL or no caching
! Media Assets: Infinite TTL + versioning
```

## Pricing Classes

### Geographic Coverage Options

| Price Class | Edge Locations | Coverage | Cost |
|-------------|----------------|----------|------|
| **Price Class All** | 400+ | Global (all continents) | Highest |
| **Price Class 200** | ~200 | US, Europe, Asia | Medium |
| **Price Class 100** | ~100 | US, Europe | Lowest |

### Strategic Selection

**Global E-commerce**: Price Class All
**US/EU focused**: Price Class 100 (cost savings)
**Asia Pacific** business: Price Class 200 (local coverage)

**Cost Consideration Example:**
- India users with Price Class 100: High latency (>200ms)
- India users with Price Class 200: Low latency (<50ms)

**Pricing Model:**
- Free tier: 1TB data transfer/month
- Additional: $0.085-$0.12 per GB (depends on region)

## Performance Monitoring

### Cache Statistics Dashboard

**Key Metrics:**
```bash
Total Requests: 254
Origin Requests: 48 (cache misses)
CloudFront Requests: 254
Error Rate: 11 errors (4.3%)
Hit Rate: ~38/48 (70.4%)  <- Calculated from hits/misses
```

### Request Analysis
- **Device Types**: Desktop (57%), Mobile (43%)
- **Popular Objects**: Top accessed files
- **Request Sources**: Geographic distribution

### Performance Indicators
```diff
+ Good Health:
+ Cache Hit Rate >95%
+ Low origin request ratio
+ Fast average response time

- Concerns:
+ High miss rate (>20%)
+ Excessive origin traffic
+ High error percentages
```

## Cache Invalidation

### When Required
Anytime origin content changes but edge caches serve old version.

### Implementation

**Create Invalidation Request:**

```bash
# Navigate: CloudFront → Distribution → Invalidations → Create
Object paths to invalidate:
  /mypng.jpg     # Specific file
  /folder/*      # Folder contents
  /*             # Entire cache (avoid for large distributions)
```

**Process:**
- CloudFront broadcasts invalidation to all edge locations
- Affected caches cleared instantly
- New requests create fresh cache

### Best Practices
```diff
+ Selective invalidation (only changed content)
- Full cache flush (performance impact)
! For media: Use versioning, not invalidation
```

### Impact Assessment
- Temporary spike in cache misses
- Increased origin load during cache rebuild
- Latency spike for first requests post-invalidation

## Geographic Restrictions

### Use Cases
- Regional compliance (GDPR, local laws)
- Content licensing restrictions
- Geographic blocking for security

### Configuration Types

**Allowlist (Whitelist):**
- Only specified countries can access
- Example: Allow only US, Canada
- Everyone else: Forbidden

**Blocklist (Blacklist):**
- Specified countries blocked
- Everyone else: Access granted
- Example: Block CN, KP, IR

**Implementation:**
1. Distribution Settings → Geographic restrictions
2. Select countries
3. Update and redeploy (global propagation)

### Example Restriction
**Allowlist Configuration:**
```bash
Allowed Countries: US, CA, IN
```

**Result:** Only users from US, Canada, India can access distribution.

## Advanced Integration

### Origin Access Control (OAC)
Replacement for older OAI (Origin Access Identity).

**Benefits:**
- IAM resource policies
- Scoped permissions
- Better security model

**Use Case Scenario:**
Private S3 bucket integration - upcoming session demo.

### Integration with Other Services
- **API Gateway Origin**: Dynamic API responses
- **Load Balancer Origin**: High-availability applications
- **EC2 Origin**: Full web application caching

### Hybrid Architecture Recommendation
```bash
Dynamic Content: EC2 origin (no caching)
Static Assets: S3 origin + CloudFront caching
```

## Summary

### Key Takeaways
```diff
+ CloudFront accelerates global web applications
+ Combines dynamic EC2 content with cached S3 assets
+ Pricing classes balance cost vs. performance
+ Invalidation essential for content updates
+ Geographic controls for compliance
+ OAC enables secure private bucket access
```

### Quick Reference

**Basic Commands:**
```bash
# Create distribution
CloudFront Console → Create Distribution

# Invalidate cache
Distribution → Invalidations → Create (/path/file.jpg)

# Update geographic restrictions
Distribution → Settings → Geographic restrictions
```

**PHP Integration Example:**
```php
<?php
echo "Hello World!<br>";
echo "Server Time: " . date('Y-m-d H:i:s');
?>
<img src="https://your-distribution.cloudfront.net/image.jpg" />
```

### Expert Insight

**Real-world Application:**
- E-commerce sites: Product images + dynamic cart
- Streaming platforms: Video caching + live metadata
- SaaS applications: Global user experience optimization

**Expert Path:**
- Master Lambda@Edge for event-driven compute
- Implement custom error pages and redirects
- Optimize with advanced cache behaviors

**Common Pitfalls:**
- Public S3 buckets allow direct bypass of CloudFront
- Wrong pricing class causing unnecessary costs
- Over-invalidating reducing overall performance

**Lesser-Known Facts:**
- CloudFront uses Route 53 for intelligent DNS routing
- Supports WebSocket connections for real-time apps
- Integrates with AWS WAF for security

**Advantages:**
- Massive performance improvement (10-100x faster)
- Cost-effective data transfer pricing
- Global edge network reliability

**Disadvantages:**
- Complex configuration for multiple origins
- Cold start latency for rarely accessed content
- Propagation delays for configuration changes

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
