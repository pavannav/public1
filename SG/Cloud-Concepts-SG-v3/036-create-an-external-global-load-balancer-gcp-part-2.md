# Session 036: Create an External Global Load Balancer in Google Cloud (GCP) Part 2

<details open>
<summary><b>Create an External Global Load Balancer in Google Cloud (GCP) Part 2 (KK-CS45-script-v3)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts](#key-concepts)
  - [Cloud CDN Integration with Load Balancer](#cloud-cdn-integration-with-load-balancer)
  - [Security Policies for Load Balancing](#security-policies-for-load-balancing)
  - [Custom SSL Certificate Management](#custom-ssl-certificate-management)
  - [Load Balancing Monitoring and Logging](#load-balancing-monitoring-and-logging)
  - [Global Load Balancer Performance Optimization](#global-load-balancer-performance-optimization)
- [Lab Demo: Advanced Load Balancer Configuration](#lab-demo-advanced-load-balancer-configuration)
- [Summary](#summary)

## Overview
This session continues from Part 1, diving into advanced features of External Global Load Balancers in Google Cloud Platform (GCP). It covers Cloud CDN integration, security policies, custom SSL certificates, monitoring best practices, and performance optimization techniques to create production-ready, enterprise-grade load balancing solutions.

## Key Concepts

### Cloud CDN Integration with Load Balancer
Cloud CDN (Content Delivery Network) can be seamlessly integrated with external global load balancers to accelerate content delivery worldwide and reduce backend load.

**CDN Key Benefits:**
- **Edge Caching**: Content is cached at Google's 100+ edge locations worldwide
- **DDoS Protection**: Distributed mitigation through CDN infrastructure  
- **Reduced Latency**: Serve static content from closest edge locations
- **Cost Optimization**: Decreased egress costs and backend compute usage

```diff
+ CDN Integration Advantages:
  - Static content served from edges (~90% closer to users)
  - Automatic compression of responses
  - Intelligent caching based on cache-control headers
  - Overlapping with load balancer's global IP management
```

### Security Policies for Load Balancing
Enhance security through advanced load balancer features and external security policies.

**Web Application Firewall (WAF) Features:**
- **OWASP Top 10 Protection**: Common web security vulnerabilities
- **Rate Limiting**: Prevent floods, bots, and malicious traffic patterns
- **Custom Rules**: Domain-specific security requirements
- **Geo-blocking**: Restrict access by geographic locations
- **TLS Policies**: Minimum TLS version enforcement

> [!IMPORTANT]
> Security policies apply at the edge, providing protection before traffic reaches your backends and reducing infrastructure costs.

### Custom SSL Certificate Management
Beyond managed certificates, custom SSL and advanced certificate features for specific requirements.

**Advanced SSL Features:**
- **Custom Certificates**: Upload and manage your certificates
- **Certificate Authority Service**: Use GCP's CA service for internal certificates
- **Mutual TLS (mTLS)**: Client certificate authentication
- **SSL Policies**: Enforce strong cipher suites and protocols

### Load Balancing Monitoring and Logging
Comprehensive observability tools for troubleshooting and performance analysis.

**Monitoring Stack:**
- **Cloud Monitoring**: Real-time metrics and alerting
- **Cloud Logging**: Access and application logs aggregation
- **Request/Error Logs**: Detailed request tracking with latency data
- **Custom Dashboards**: Tailored views for your specific needs

**Key Metrics to Monitor:**
1. **Backend Health**: Healthy/unhealthy backend instances
2. **Response Times**: P50, P95, P99 latencies
3. **Error Rates**: 5xx, 4xx error percentages
4. **Throughput**: Requests per second (RPS)
5. **Cache Hit Rates**: For CDN-integrated load balancers

> [!NOTE]
> Load balancer metrics are collected automatically and available within minutes of setup, providing immediate visibility into system performance.

### Global Load Balancer Performance Optimization
Techniques to maximize performance and minimize costs across global deployments.

**Performance Strategies:**
- **Connection Pooling**: Keep-alive connections reduce overhead
- **Health Check Optimization**: Balance thoroughness with performance impact
- **Backend Selection**: Routing algorithms and session affinity
- **CDN Tuning**: Cache effectiveness and invalidation strategies

## Lab Demo: Advanced Load Balancer Configuration

### Prerequisites
- Existing external global load balancer from Part 1
- Cloud CDN enabled project
- Custom domain and SSL certificates
- Monitoring workspace configured

### Step-by-Step Advanced Configuration

#### Step 1: Enable Cloud CDN Integration
```bash
# Enable CDN on existing backend bucket
gcloud compute backend-buckets update static-content \
  --enable-cdn \
  --cache-mode USE_ORIGIN_HEADERS

# Create backend bucket for static content
gcloud compute backend-buckets create static-backend \
  --gcs-bucket-name my-static-bucket \
  --enable-cdn
```

**CDN Configuration Parameters:**
- Cache mode (USE_ORIGIN_HEADERS, FORCE_CACHE_ALL, CACHE_ALL_STATIC)
- TTL settings (default, minimum, maximum)
- Cache key policy (customize caching behavior)
- Negative caching (for 404 errors)

> [!TIP]
> Use `CACHE_ALL_STATIC` for static assets and `USE_ORIGIN_HEADERS` for dynamic content with custom cache-control headers.

#### Step 2: Implement Security Policies
```bash
# Create custom security policy
gcloud compute security-policies create my-waf-policy \
  --description "Custom WAF rules for protection"

# Add rate limiting rule
gcloud compute security-policies rules create 1000 \
  --security-policy my-waf-policy \
  --expression "rateLimit(100, 60)" \
  --action "rate_based_ban" \
  --rate-limit-options enforce-on-key=ip \
  --ban-duration-sec 300 \
  --ban-threshold count=200,interval-sec=60

# Attach security policy to load balancer targetHTTPSProxy  
gcloud compute target-https-proxies update my-https-proxy \
  --security-policy my-waf-policy
```

**Common Security Rules:**
- Rate limiting based on IP or user agent
- Geo-blocking by country codes
- Block known malicious IPs with IP reputation lists
- Header-based filtering (e.g., block missing user-agent)

#### Step 3: Advanced SSL Certificate Management
```bash
# Upload custom SSL certificate
gcloud compute ssl-certificates create custom-cert \
  --certificate /path/to/certificate.crt \
  --private-key /path/to/private-key.key \
  --global

# Create managed certificate for multiple domains
gcloud compute ssl-certificates create managed-cert \
  --domains example.com,www.example.com,api.example.com \
  --global

# Implement SSL policies for security
gcloud compute ssl-policies create custom-ssl-policy \
  --profile COMPATIBLE \
  --min-tls-version 1.2 \
  --custom-features TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
```

> [!WARNING]
> Private keys are sensitive data. Store them securely and rotate regularly. GCP encrypts certificates at rest.

#### Step 4: Monitor and Alert Configuration
```bash
# Create uptime check
gcloud monitoring uptime-check-configs create my-check \
  --display-name="External LB Health Check" \
  --http-check-path="/" \
  --http-check-port=443 \
  --use-ssl \
  --selected-regions=usa,asia-eur \
  --host=example.com

# Set up alerting policy for high error rates
gcloud monitoring policies create high-error-rate \
  --display-name="High Error Rate Alert" \
  --condition-filter="metric.type=\"loadbalancing.googleapis.com/https/request_count\" AND metric.labels.response_code_class=\"500\" resource.type=\"https_lb_rule\"" \
  --condition-threshold=0.05 \
  --duration=300s \
  --trigger-count=1 \
  --notification-channels=my-channel
```

#### Step 5: Performance Optimization
```bash
# Configure advanced backend service settings
gcloud compute backend-services update web-backend-service \
  --connection-draining-timeout=300 \
  --session-affinity=GENERATED_COOKIE \
  --affinity-cookie-ttl-sec=86400 \
  --load-balancing-scheme=INTERNAL_SELF_MANAGED

# Optimize health check settings
gcloud compute health-checks update http hc-web \
  --healthy-threshold=2 \
  --unhealthy-threshold=3 \
  --check-interval=30 \
  --timeout=10 \
  --host=example.com \
  --proxy-header=NONE
```

**Backend Optimization Tips:**
- Use connection draining for graceful shutdowns
- Implement session affinity for stateful applications
- Balance across zones for high availability
- Use HTTP/2 for better performance

#### Step 6: CDN and Load Balancer Combined Demo
```bash
# Create combined URL map with CDN backends
# Static content -> CDN backend bucket
# Dynamic content -> Instance group backends

gcloud compute url-maps add-path-matcher web-url-map \
  --default-service web-backend-service \
  --new-path-matcher \
  --path-matcher-name=cdn-paths \
  --path-rules="/static/*=gs://my-static-bucket,/images/*=gs://my-static-bucket" \
  --backend-bucket-path-rules="/media/*=media-bucket-backend"

# Test CDN performance
curl -H "Cache-Control: no-cache" -v https://example.com/static/image.jpg
# Check response headers for cache status
```

### Troubleshooting Common Issues

**SSL Certificate Problems:**
- Domain validation failures
- Certificate authority trust issues
- Mixed content warnings

**CDN Cache Issues:**
- Stale content serving
- Cache invalidation not working
- Bypass mechanisms needed for dynamic content

**Performance Bottlenecks:**
- Backend overload
- Regional capacity limits
- SSL handshake delays

## Summary

> [!IMPORTANT]
> Advanced load balancer configurations require careful planning, especially when combining CDN, security policies, and monitoring to achieve optimal performance and security.

### Key Takeaways
```diff
+ Cloud CDN reduces latency by ~40% for global users and decreases backend load by 60-70%
+ Security policies provide edge-level protection against common web attacks
+ Custom SSL certificates offer flexibility for enterprise certificate management requirements
+ Comprehensive monitoring enables proactive issue detection and resolution
+ Performance optimization requires balancing features with operational complexity
- Always test failover scenarios during implementation
- Monitor certificate expiration dates proactively
- Implement gradual rollouts for major configuration changes
```

### Quick Reference

**CDN Cache Modes:**
| Mode | Use Case | Behavior |
|------|----------|----------|
| USE_ORIGIN_HEADERS | Dynamic content | Respects origin cache-control headers |
| CACHE_ALL_STATIC | Static assets | Aggressive caching, ignores cache headers |
| FORCE_CACHE_ALL | CDN control | Cache everything regardless of headers |

**Security Policy Rules:**
```bash
# Block suspicious user agents
gcloud compute security-policies rules create 2000 \
  --expression "request.headers['User-Agent'].contains('bad-bot')" \
  --action deny-403

# Allow only specific countries
gcloud compute security-policies rules create 100 \
  --match-config src-ip-ranges=allowlist \
  --action allow \
  --src-ip-ranges 192.0.0.0/8,198.18.0.0/15
```

**Common Monitoring Queries:**
```bash
# Check error rate by backend
gcloud logging read "resource.type=https_lb_rule 
  AND jsonPayload.statusDetails != \"rate_limited\" 
  AND jsonPayload.response_code >= 500" --limit=10

# CDN cache hit ratio
gcloud monitoring query "fetch loadbalancing.googleapis.com/CdnCacheHitRatio 
  | align rate(5m) 
  | every 5m" --within 1h
```

### Expert Insight

**Real-world Application**: Enterprise applications use these advanced features to serve millions of users globally with sub-second response times. Netflix-style video streaming platforms combine load balancers with CDN for 99.9% uptime, while financial institutions implement stringent security policies for compliance.

**Expert Path**: Focus on mastering Cloud Armor integration, custom WAF rules, automated certificate rotation, and advanced monitoring with custom metrics. Learn to optimize costs through intelligent caching strategies and understand the trade-offs between security, performance, and complexity.

**Common Pitfalls**: 
- Over-configuring security policies causing false positives
- Ignoring CDN cache invalidation leading to stale content issues
- Not testing IPv6 compatibility in global deployments
- Underestimating logging costs for high-traffic applications
- Forgetting to update DNS TTL when implementing CDN changes

</details>
