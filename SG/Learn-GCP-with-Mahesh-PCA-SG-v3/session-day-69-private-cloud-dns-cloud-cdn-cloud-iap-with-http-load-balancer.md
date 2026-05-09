# Session 69: Private Cloud DNS, Cloud CDN, Cloud IAP with HTTP Load Balancer

## Overview

This session focuses on advanced GCP networking concepts including private DNS zones, content delivery networks (CDN), and Identity-Aware Proxy (IAP) integration with HTTP Load Balancers. Students learn how to implement private cloud DNS for internal service discovery, configure Cloud CDN for optimal content delivery, and secure applications using Cloud IAP. The session includes extensive demonstrations and troubleshooting scenarios.

## Private Cloud DNS

### Core Concepts

Google Cloud DNS provides 100% service level agreement (SLA) for uptime and supports both public and private zones. Private zones contain DNS records visible only within your Google Cloud network, allowing you to use any domain names (including famous brands like google.com) for internal IP addresses.

**Key Benefits:**
- Internal service discovery without remembering IP addresses
- Domain-based naming for load balancers and VMs
- Isolated from public internet while allowing full control within VPC

> [!IMPORTANT]
> Private zones enable organizations to use familiar domain naming internally without conflicting with public DNS.

### Private Zone vs. Public Zone

Public zones are created with nameservers that must be configured at domain registrars (like GoDaddy), while private zones are associated directly with VPC networks in Google Cloud.

**Use Cases:**
1. VM-to-VM communication using domain names instead of IPs
2. Internal load balancer naming (covered in future sessions)
3. Consistent naming conventions across projects

### Private Zone Creation and Configuration

Private zones should be created in centralized networking projects or shared VPC host projects.

**Zone Configuration:**
- Zone name: Use hyphen-separated format (e.g., `google-dns.com`)
- Network selection: Choose shared VPC or specific networks
- Visibility: Private within Google Cloud network

**DNS Record Types:**
- A records: Map domain names to IP addresses
- CNAME records: Alias one domain to another

```bash
# Equivalent gcloud command:
gcloud dns managed-zones create private-zone \
  --description="Private DNS zone" \
  --dns-name=google.com \
  --networks=shared-vpc \
  --visibility=private
```

### VM Communication Using Private DNS

#### Fully Qualified Domain Names (FQDN)

Google Cloud provides automatic FQDN generation for VMs:
```
[hostname].[zone-name].c.[project-id].internal
```
- Example: `microservice-01.us-central1-c.learning-gcp-123.internal`

#### Private Zone A Records

Create custom domain names for IP addresses:

```bash
# Add A record to private zone
gcloud dns record-sets create microservice01.google.com \
  --zone=private-zone \
  --type=A \
  --ttl=300 \
  --rrdatas=10.10.10.10
```

> [!NOTE]
> Private zones allow using any domain name internally, including popular domains like google.com or yahoo.com, since they remain isolated from public DNS.

### Demo: Private DNS Setup

#### Prerequisites
- Two VMs in same region (microservice-01, microservice-02)
- Shared VPC configuration
- Appropriate firewall rules for ping

#### FQDN Communication

```bash
# Connect to VM and test FQDN resolution
ssh microservice-01
ping microsrevice-02.us-central1-c.learning-gcp-123.internal
```

#### Private Zone Domain Communication

```bash
# Ping using custom private domain
ping microservice02.google.com
```

### Architecture Benefits

The private DNS enables microservices communication through human-readable names rather than IP addresses, improving maintainability and reducing configuration errors.

## Cloud CDN

### Content Delivery Fundamentals

CDN (Content Delivery Network) serves static content from geographically distributed points of presence (PoPs) to reduce latency and improve user experience.

**Static vs Dynamic Content:**
- **Static Content**: Images, videos, CSS, JavaScript (Netflix movies, website assets)
- **Dynamic Content**: Personalized user data, transaction processing (banking logins, shopping carts)

Static content remains consistent across users, making it ideal for caching. Dynamic content requires real-time backend processing.

### CDN Point of Presence (PoPs)

Google Cloud CDN leverages global edge infrastructure:
- **CDN PoPs**: Media optimization, more locations worldwide
- **Standard PoPs**: ~100 locations, cost-effective for general use

India has 3 CDN PoPs (Chennai, Mumbai, Delhi) serving different regions.

### Request Routing Logic

```
User Request → Load Balancer → CDN Check → Cache Hit (Serve) or Cache Miss (Backend Call)
```

**Cache Miss Process:**
1. CDN checks local cache
2. If miss, forwards to origin (GCS bucket/backend service)
3. Origin serves content, CDN caches for future requests

### Cache Key Configuration

Cache keys determine what gets cached. The default includes the full URL, but custom keys improve cache hit ratios.

**Cache Key Components:**
- Host (domain)
- Path
- Query parameters (optional)

**Best Practice:** Use custom cache keys excluding unnecessary query parameters to increase cache hit ratios.

```diff
- Include query strings (low hit ratio)
+ Exclude query strings (high hit ratio)
```

### CDN with Backend Services vs. GCS Buckets

**Backend Service CDN:**
- For dynamic content (VMs, MIGs)
- Custom cache keys recommended
- Lower TTL values (seconds/minutes)

**GCS Bucket CDN:**
- For static content
- Default cache keys sufficient
- Higher TTL values (hours/days)

### Load Balancer Integration

CDN requires global external HTTP(S) Load Balancers. External TCP/UDP load balancers cannot use CDN.

```yaml
# Backend service with CDN
apiVersion: compute.v1
kind: BackendService
metadata:
  name: backend-service-with-cdn
spec:
  backends:
    - group: zones/us-central1-a/instanceGroups/my-instance-group
  enableCDN: true
  cdnPolicy:
    cacheMode: CACHE_ALL_STATIC
    cacheKeyPolicy:
      includeHost: true
      includeProtocol: true
      includeQueryString: false  # Improves hit ratio
```

### Demo: CDN Configuration

#### Backend Bucket Setup

```bash
# Create backend bucket
gcloud compute backend-buckets create backend-bucket \
  --gcs-bucket-name=my-static-bucket

# Enable CDN with custom policy
gcloud compute backend-buckets update backend-bucket \
  --enable-cdn \
  --cache-mode=CACHE_ALL_STATIC \
  --client-ttl=3600 \
  --default-ttl=86400 \
  --max-ttl=604800 \
  --cache-key-include-host=true \
  --cache-key-include-protocol=true \
  --cache-key-include-query-string=false
```

#### CDN Monitoring

Monitor cache hit ratios through Cloud Logging:

```sql
resource.type="http_load_balancer"
jsonPayload.cacheDecision="HIT"
```

### Cache Invalidation

Invalidation purges cached content immediately:

```bash
# Invalidate specific objects
gcloud compute url-maps invalidate-cdn-cache LOAD_BALANCER_NAME \
  --path="/images/logo.png"

# Invalidate all content
gcloud compute url-maps invalidate-cdn-cache LOAD_BALANCER_NAME \
  --path="/*"
```

### Performance Optimization

**TTL Settings:**
- Client TTL: Browser cache (0-86400 seconds)
- Default TTL: CDN cache default (0-86400 seconds)  
- Max TTL: CDN cache maximum (0-31536000 seconds)

**Cache Modes:**
- Cache static content automatically (recommended)
- Cache all content (use cautiously)
- No caching (dynamic-only backends)

### Troubleshooting Cache Issues

**Common Problems:**
- VPC Service Control blocking CDN requests
- Incorrect cache key policies
- Firewall rules blocking traffic

**Debugging Steps:**
1. Check Cloud Logging for cache decisions
2. Verify load balancer backend configuration
3. Test cache key policies
4. Monitor hit/miss ratios

## Cloud IAP (Identity-Aware Proxy)

### IAP Fundamentals

Cloud IAP provides authentication and authorization for web applications without managing user accounts. It integrates with Google Identity and external identity providers.

**Key Features:**
- SSO (Single Sign-On) integration
- OAuth 2.0/OIDC support
- Zero-trust security model
- Context-aware access

### IAP with Load Balancers

IAP works with HTTP(S) Load Balancers and backend services (not buckets).

**Requirements:**
- HTTPS enabled (mandatory for security)
- Backend services only (VMs, MIGs, serverless)
- User roles assigned for access

### Demo: IAP Configuration

#### Enable IAP on Backend Service

```bash
# Enable IAP for load balancer backend
gcloud compute backend-services update my-backend-service \
  --iap=enabled,oauth2-client-id=CLIENT_ID,oauth2-client-secret=CLIENT_SECRET
```

#### Configure User Access

```bash
# Grant IAP-secured Web App User role
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member=user:user@example.com \
  --role=roles/iap.httpsResourceAccessor
```

### IAP Limitations

**Current Constraints:**
- No IAP support for GCS backend buckets
- Requires backend services (VMs, serverless)
- Cannot protect static content directly

**Workaround:** Use backend services for all protected content.

### Authentication Flow

```
User Request → IAP Proxy → Authentication Challenge → Google OAuth → Access Granted → Application
```

## Architecture Overview

### Complete Networking Stack

```
[Users] → [Global External HTTP(S) Load Balancer]
                    ↓
           ┌─────────────────┐
           │     CDN PoPs    │ ← Cache static content
           └─────────────────┘
                    ↓
           ┌─────────────────┐
           │ IAP Proxy       │ ← Authentication/Authorization
           └─────────────────┘
                    ↓
        ┌───┬───┬───┬───┐
        │VMs│GCS│CR │GKE│ ← Backend services
        └───┴───┴───┴───┘
                    ↓
           ┌─────────────────┐
           │ Private DNS     │ ← Internal service discovery
           └─────────────────┘
```

### Project Organization

**Recommended Structure:**
- Shared VPC host project for networking
- Service projects for applications
- Centralized networking project for DNS and interconnect

## Summary

### Key Takeaways

```diff
+ Private DNS enables internal service discovery with custom domain names
+ Cloud CDN reduces latency through content caching at global PoPs
+ IAP provides authentication layer for web applications
+ Load balancers integrate all three components seamlessly
! Combine CDN + IAP for optimal performance and security
```

### Quick Reference

#### DNS Commands
```bash
# Create private zone
gcloud dns managed-zones create ZONE_NAME \
  --dns-name=DOMAIN \
  --networks=NETWORK \
  --visibility=private

# Add A record
gcloud dns record-sets create RECORD_NAME \
  --zone=ZONE_NAME \
  --type=A \
  --rrdatas=IP_ADDRESS
```

#### CDN Configuration
```bash
# Enable CDN for backend bucket
gcloud compute backend-buckets update BUCKET_NAME \
  --enable-cdn \
  --cache-mode=CACHE_ALL_STATIC

# Check cache hit ratio logs
gcloud logging read "resource.type=http_load_balancer AND jsonPayload.cacheDecision"
```

#### IAP Setup
```bash
# Enable IAP
gcloud compute backend-services update BACKEND_SERVICE \
  --iap=enabled

# Grant access
gcloud projects add-iam-policy-binding PROJECT \
  --member=user:USER \
  --role=roles/iap.httpsResourceAccessor
```

### Expert Insight

#### Real-world Application
- **Private DNS**: Enterprise internal service meshes
- **CDN**: Global media streaming platforms (Netflix, YouTube)
- **IAP**: Secure developer portals, internal admin consoles

#### Expert Path
- Master cache key policies for optimal hit ratios
- Implement comprehensive logging and monitoring
- Design hybrid architectures combining all three components

#### Common Pitfalls
- Forgetting to disable CDN for dynamic backend services
- Incorrect IAP role assignments causing access issues
- VPC Service Control conflicts with CDN operations
- Not configuring proper TTL values for cache management

#### Lesser-Known Facts
- Google's default DNS SLA guarantee is 100% uptime
- CDN point of presence locations change based on traffic patterns
- IAP silently integrates with existing OAuth flows
- Cache invalidation supports wildcard patterns for bulk operations

### Advantages and Disadvantages

**Private DNS:**
- ✅ Easy internal service discovery
- ✅ Custom domain naming
- ✅ No public DNS conflicts
- ❌ Requires careful network planning
- ❌ Additional management overhead

**Cloud CDN:**
- ✅ Dramatic latency reduction
- ✅ Cost-effective global delivery
- ✅ Automatic scaling
- ❌ Not suitable for dynamic content
- ❌ Cache invalidation can be complex

**Cloud IAP:**
- ✅ Zero-trust security model  
- ✅ SSO integration
- ✅ Context-aware access control
- ❌ Limited to backend services (not buckets)
- ❌ OAuth configuration complexity

### What's Next
- Internal Load Balancer (Layer 4 and Layer 7)
- Distributed Denial of Service (DDoS) protection with Cloud Armor
- Networking pricing and cost optimization
- Quiz and practical assessments
