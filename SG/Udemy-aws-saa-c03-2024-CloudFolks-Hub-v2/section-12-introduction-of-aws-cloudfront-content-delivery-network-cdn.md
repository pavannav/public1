<details open>
<summary><b>Section 12: AWS CloudFront Content Delivery Network (CDN) (CL-KK-Terminal)</b></summary>

# Section 12: AWS CloudFront Content Delivery Network (CDN)

## Table of Contents
- [12.1 Introduction of AWS CloudFront Content Delivery Network (CDN)](#121-introduction-of-aws-cloudfront-content-delivery-network-cdn)
- [12.2 AWS CloudFront Hands-On Lab 1](#122-aws-cloudfront-hands-on-lab-1)
- [12.3 AWS CloudFront Origin Setting](#123-aws-cloudfront-origin-setting)
- [12.4 AWS CloudFront Default Cache Behavior Option](#124-aws-cloudfront-default-cache-behavior-option)
- [12.5 CloudFront Custom HTTPS](#125-cloudfront-custom-https)
- [12.6 CloudFront Origin Access](#126-cloudfront-origin-access)
- [12.7 CloudFront Allowed HTTP Method](#127-cloudfront-allowed-http-method)
- [12.8 AWS CloudFront Default Cache Behavior- Restrict Viewer Access](#128-aws-cloudfront-default-cache-behavior--restrict-viewer-access)
- [12.9 AWS CloudFront Default Cache Behavior- Cache Key And Origin Requests](#129-aws-cloudfront-default-cache-behavior--cache-key-and-origin-requests)
- [12.10 AWS CloudFront Default Cache Behavior- Response Header Policy](#1210-aws-cloudfront-default-cache-behavior--response-header-policy)
- [12.11 AWS CloudFront Function Associations](#1211-aws-cloudfront-function-associations)
- [12.12 AWS CloudFront Setting Options -- Supported HTTP Versions & Default Root Object](#1212-aws-cloudfront-setting-options----supported-http-versions--default-root-object)
- [12.13 AWS CloudFront Setting Options Part 2](#1213-aws-cloudfront-setting-options-part-2)
- [12.14 AWS CloudFront Geographic Restrictions](#1214-aws-cloudfront-geographic-restrictions)
- [12.15 AWS CloudFront Origin Group Lab 1 EC2 & S3 Failover](#1215-aws-cloudfront-origin-group-lab-1-ec2--s3-failover)
- [12.16 AWS CloudFront Origin Group Lab 2 Geographical Failover with Load Balancer](#1216-aws-cloudfront-origin-group-lab-2-geographical-failover-with-load-balancer)
- [12.17 AWS CloudFront Tutorial -- AWS CloudFront Error Pages](#1217-aws-cloudfront-tutorial----aws-cloudfront-error-pages)
- [12.18 AWS CloudFront Cache Invalidation](#1218-aws-cloudfront-cache-invalidation)

## 12.1 Introduction of AWS CloudFront Content Delivery Network (CDN)

### Overview
This module introduces CloudFront as AWS's Content Delivery Network (CDN) service, explaining how it accelerates content delivery globally. It compares scenarios with and without CloudFront to demonstrate latency reduction and improved performance for global users.

### Key Concepts/Deep Dive

#### What is CloudFront?
- CloudFront is AWS's CDN technology designed to deliver data, videos, applications, and APIs quickly and securely to global users.
- It uses caching mechanisms at edge locations to reduce latency and improve transfer speeds.
- Key benefits include low latency access for global OTT platforms like Netflix, Amazon Prime, and Disney Hotstar.

#### Scenario Without CloudFront
- In a scenario where a website (e.g., LMS) is hosted in Mumbai, India:
  - Indian users experience low latency due to local fiber optic connections and domestic bandwidth.
  - Users from distant locations (e.g., USA) face high latency (over 17,000 km distance) and international bandwidth limitations, leading to poor performance.
  - Single server handles all global traffic, risking downtime if overwhelmed by requests.
- Problems: Latency, international bandwidth constraints, and single-point-of-failure server overload.

#### Scenario With CloudFront
- CloudFront integrates over 400 edge locations worldwide for caching content near users.
- Content from the origin server (e.g., Mumbai) is replicated to nearby edge locations.
  - Users fetch content from closest edges, achieving domestic-like latency and bandwidth.
  - Origin server sees reduced load as most requests are served from caches.
- Advantages: Global performance improvement, reduced origin load, and high availability.

#### CloudFront Edge Locations
- AWS maintains extensive global infrastructure for fast content delivery.
- Benefits: Caches static and dynamic content, supports secure protocols, and integrates with other AWS services.

### Lab Demos
- No hands-on labs in this transcript; focuses on conceptual understanding.

## 12.2 AWS CloudFront Hands-On Lab 1

### Overview
This practical lab demonstrates CloudFront setup with S3 as origin, comparing performance with and without CDN. It covers static website hosting on S3 and creating a CloudFront distribution for global delivery.

### Key Concepts/Deep Dive

#### Mission and Objectives
- Set up CloudFront distribution for S3 static website.
- Verify performance differences before and after CloudFront integration.
- Understand S3 static website hosting and CloudFront benefits.

#### Steps for S3 Static Website Setup
1. **Create S3 Bucket**: Choose Virginia region for testing; enable public access by editing bucket policy.
2. **Upload Files**: Upload video (e.g., intro.mp4), image (wallpaper.png), and index.html. Edit index.html to reference S3 object URLs.
   - Code Example (index.html excerpt):
     ```html
     <video src="https://cloudfox-web.s3.amazonaws.com/intro.mp4" controls></video>
     <img src="https://cloudfox-web.s3.amazonaws.com/wallpaper.png" alt="Wallpaper">
     ```
3. **Enable Static Web Hosting**: From bucket properties, enable hosting and specify index.html as index document.
4. **Configure Policies**: Update bucket policy for public read access (example ARN: arn:aws:s3:::cloudfox-web/*).
5. **Test Website**: Use static website endpoint URL to verify content loads.

#### Testing Performance Without CloudFront
- Use tools like GeoPicker or WebPageTest to measure latency:
  - Virginia: ~0 ms (local).
  - Brazil: ~113 ms.
  - California: ~62 ms.
  - Ireland: ~72 ms.
  - Australia: ~200 ms.
- Demonstrates poor global performance due to distance and bandwidth.

#### CloudFront Distribution Creation
1. **Select Origin**: Choose S3 bucket for static website endpoint.
2. **Cache Settings**: Keep defaults; explain options like price class (all edge locations for maximum coverage).
3. **Enable Distribution**: Creates CloudFront URL after deployment.

#### Testing Performance With CloudFront
- Post-deployment: Latencies reduce significantly worldwide (e.g., Brazil/Ireland/Australia ~0-1 ms).
- Explain caching: Edge locations store and serve content locally.
- Cleanup: Disable distribution before deletion to avoid errors; wait for deployment changes.

#### Key Benefits Observed
- Faster global access via edge caching.
- Seamless integration with S3 origins.

### Lab Demos
1. **Create S3 Bucket and Enable Hosting**.
2. **Upload and Configure Files**.
3. **Test Without CloudFront** using performance tools.
4. **Create CloudFront Distribution**.
5. **Test With CloudFront** and compare results.
6. **Clean Up Resources**: Delete distribution and bucket.

## 12.3 AWS CloudFront Origin Setting

### Overview
This module details CloudFront origin settings, including domain, path, custom headers, and Origin Shield for enhancing security and performance in distribution configurations.

### Key Concepts/Deep Dive

#### Origin Domain
- Specifies DNS name/endpoint from which CloudFront fetches content (e.g., S3 buckets, EC2, Load Balancers, API Gateway).
- Origin availability determines dropdown visibility in console.

#### Origin Path
- Optional; specifies subtree/directory within origin for content retrieval (e.g., for subdirectory hosting).
- Example: If website is in /web/, set path to /web/; otherwise, leave blank for root access.

#### Add Custom Header
- Attaches additional HTTP headers to requests sent to origin for authentication, versioning, etc.
- Use cases:
  - API key authentication (e.g., X-API-Key).
  - Versioning headers.
  - Debugging/security information.
- Supports multiple headers with name-value pairs.
- Example: Send authorization token or custom logic data to origin.

#### Origin Shield
- Adds centralized caching layer to reduce origin load; routes requests via regional edge caches to Origin Shield before origin.
- Without Origin Shield: User requests bypass layers, potentially overloading origin.
- With Origin Shield: Actively reduces direct origin hits, enabling horizontal scaling.
- Benefits: Minimizes origin overload, improves performance (chargeable feature).
- Visualization:
  - **Without Origin Shield**: Direct requests to origin from edges.
  - **With Origin Shield**: Extra layer buffers traffic.

### Lab Demos
- Creating distributions with various origins to explore settings.
- Configuring headers for security.

## 12.4 AWS CloudFront Default Cache Behavior Option

### Overview
Covers default cache behavior in CloudFront, focusing on path patterns, compression, viewer protocols for optimizing delivery and security.

### Key Concepts/Deep Dive

#### Path Pattern
- Defines which content CloudFront caches (e.g., * for all, /images/* for specific folders).
- Use cases: Exclude/include directories for caching; saves costs by not caching non-essentials.

#### Compress Objects Automatically
- Enables CloudFront to compress files (e.g., CSS from 100KB to 30KB via GZip).
- Applicable to compressible content like text-based files; improves transfer speeds.

#### Viewer Protocol Policy
- Manages HTTP/HTTPS handling:
  - Allow HTTP and HTTPS.
  - Redirect HTTP to HTTPS (enforced HTTPS).
  - HTTPS only (blocks HTTP fully).
- Interaction with Custom Domains: AWS CloudFront URLs support HTTPS natively; custom domains require SSL certificates.
- Certificate Management: Generate SSL/TLS via AWS Certificate Manager (ACM) for custom domains (must be in us-east-1).

### Lab Demos
- Setting up compression and protocols in distributions.

## 12.5 CloudFront Custom HTTPS

### Overview
Demonstrates setting up custom HTTPS domains with CloudFront, integrating SSL certificates for secure delivery from S3 origins.

### Key Concepts/Deep Dive

#### Prerequisites
- S3 static website (HTTP-only) as origin.
- Custom domain registered via Route53.
- SSL/TLS certificate via ACM for domain.

#### Steps for HTTPS Setup
1. **Claim Custom Domain**: Via Route53; wait for DNS propagation.
2. **Generate SSL Certificate**:
   - Use ACM (us-east-1 required for CloudFront).
   - Request public certificate; add FQDN (e.g., *.cloudfox.in for wildcard).
   - Validate via DNS (preferred); ACM provides CNAME for Route53 integration.
   - Automatically validates/subdomain-supporting certificates.
3. **Link Certificate in CloudFront**:
   - Specify alternate domain names (CNAMES).
   - Attach ACM certificate.
   - Enable SSL protocols (e.g., TLS 1.2).

#### Creation Process
1. **Origin**: S3 static website endpoint.
2. **Settings**: Enable HTTPS-only; select certificate.
3. **CNAME Configuration**: Add domains; verify via Route53 alias records.
4. **Cleanup Note**: Custom domain exposure if S3 URLs remain public without Origin Access Control (OAC).

### Lab Demos
1. **Generate and Validate Certificate**.
2. **Create CloudFront Distribution with Custom Domain and HTTPS**.
3. **Route53 Configuration for CNAME**.
4. **Test Secure Access**.

## 12.6 CloudFront Origin Access

### Overview
Explains Origin Access Control (OAC) and legacy Origin Access Identifiers (OAI) for securing S3 origins, ensuring CloudFront-only access.

### Key Concepts/Deep Dive

#### Access Types
- **Public**: Origin accessible to anyone; suitable for non-sensitive content.
- **OAC (Origin Access Control)**: Modern, secures S3; requires policy attachment; CloudFront-only access.
- **OAI (Legacy)**: Older method for existing setups.

#### OAC Setup
1. **Create OAC Policy**: Attaches to S3 bucket.
2. **Bucket Policy Update**: Generated by CloudFront; allows OAC principal.
3. **Benefits**: Prevents direct S3 access; uses bucket URLs not website endpoints.

#### Default Route Object Setting
- For bucket origins: Specify root file (e.g., index.html) to avoid access denied errors.
- Only applies to bucket URLs; not needed for website endpoints.

#### Use Cases
- Secure private S3 buckets as origins.
- Replace public bucket policies with CloudFront-specific access.

### Lab Demos
1. **Create Private S3 Bucket with Files**.
2. **Set Up OAC in CloudFront**.
3. **Apply Bucket Policy**.
4. **Test Restricted Access**.

## 12.7 CloudFront Allowed HTTP Method

### Overview
Details HTTP methods CloudFront accepts/forwards (GET, HEAD, OPTIONS, PUT, POST, PATCH, DELETE) for content interaction levels.

### Key Concepts/Deep Dive

#### Method Types
- **GET, HEAD**: Read-only; cached by default.
- **GET, HEAD, OPTIONS**: Adds CORS preflight support with OPTIONS caching toggle.
- **All Methods**: Full CRUD; no caching for write operations (PUT, POST, PATCH, DELETE).

#### Caching Implications
- GET/HEAD: Always cached unless disabled.
- OPTIONS: Optional caching to reduce origin load.
- Mutating methods: Forwarded without caching.

#### Use Cases
- Static websites: GET/HEAD.
- CORS-enabled sites: Include OPTIONS.
- Dynamic apps: All methods.

### Lab Demos
- Configuring behaviors for different applications.

## 12.8 AWS CloudFront Default Cache Behavior- Restrict Viewer Access

### Overview
Covers restricting viewer access via Signed URLs/Cookies to limit content to authorized users, securing paid or private content.

### Key Concepts/Deep Dive

#### Signed URLs
- Time-limited links for single resources (e.g., PDF downloads).
- Suitable for time-sensitive access (e.g., video rentals).

#### Signed Cookies
- Session-based access for multiple resources (e.g., full platform subscriptions).
- Enables seamless navigation without per-URL signing.

#### Setup Process
- **Trusted Key Groups**: Collections of public keys for signature verification.
  - Create public/private key pairs (e.g., via OpenSSL).
  - Sign URLs/cookies with private keys; verify with public keys in CloudFront.
- **Trusted Signers**: AWS accounts allowed to generate signatures.
- Trade-offs: Sign URLs for simplicity; cookies for session persistence.

#### Practical Steps
1. Create key groups in CloudFront Distributions settings.
2. Generate/upload public keys to groups.
3. Attach to distributions for access restrictions.

### Lab Demos
- Not performed due to complexity; focuses on conceptual setup.

## 12.9 AWS CloudFront Default Cache Behavior- Cache Key And Origin Requests

### Overview
Explains cache keys for efficient caching and origin request policies for tailored origin queries in multi-variant content scenarios.

### Key Concepts/Deep Dive

#### Cache Hit Scenario
- Uses cache key (e.g., headers, query strings) to check cached content.
- Policies define what to cache (TTL, compression); forward matched requests from edges.

#### Cache Miss Scenario
- Origin request policies specify details sent to origin (e.g., headers for language variants).
- Reduces origin load by omitting irrelevant data.

#### Example: Netflix
- Content variants (HD/SD, language).
- Cache policies: Match viewer preferences (resolution, locale).
- Origin request policies: Provide only needed metadata for retrieval.

#### Policy Management
- Create reusable policies in CloudFront console.
- Attach to behaviors for caching/origin interactions.
- Example Mermaid Diagram (Caching Flow):
  ```mermaid
  flowchart LR
      User --> Cache[Edge Cache]
      Cache -->|Hit| Deliver[Deliver Content]
      Cache -->|Miss| Origin[Origin Server]
      Origin --> Update[Update Cache]
      Update --> Deliver
  ```
  (Note: Save this as images/caching-flow.png for reference)

### Lab Demos
- Conceptual demonstrations with policy creation.

## 12.10 AWS CloudFront Default Cache Behavior- Response Header Policy

### Overview
Introduces response header policies to customize HTTP headers for security, performance, and compliance in CloudFront responses.

### Key Concepts/Deep Dive

#### Purpose
- Adds/removes/modifies headers from origin responses to enhance security and user experience.
- Crucial for sites served via CloudFront (e.g., origin requests avoided).

#### Key Headers
- **Security Headers** (e.g., Content Security Policy, Strict Transport Security, X-Frame-Options) mitigate XSS, clickjacking.
- **CORS**: Configure policies for cross-origin sharing.
- **Custom Headers**: Add proprietary or tracking info.
- **Server Timing**: Expose server metrics to browser.
- **Remove Headers**: Strip sensitive origin data.

#### Configuration
- Predefined policies for security/CSP/CORS.
- Create custom for tailored needs.

#### Use Cases
- Enforce HTTPS, prevent hotlinking, enable CORS for modern web apps.
- Example: Add CSP to block malicious scripts from unauthorized sources.

### Lab Demos
- Not directly performed; examples of header weights shown.

## 12.11 AWS CloudFront Function Associations

### Overview
Details function associations for executing code at viewer/request/response stages using CloudFront Functions or Lambda@Edge for personalization and adjustments.

### Key Concepts/Deep Dive

#### Association Points
- **Viewer Request**: Pre-viewer request; e.g., URL rewrites, redirects, validations.
- **Origin Request**: Pre-origin request; e.g., add auth tokens, route to variant origins.
- **Origin Response**: Post-origin; e.g., modify cache logic, headers.
- **Viewer Response**: Post-edge; e.g., add security headers, customize responses.

#### Function Types
- **CloudFront Functions**: Lightweight (JavaScript only); fast execution (sub-ms); for simple tasks (e.g., header manipulation).
- **Lambda@Edge**: Powerful (Node.js, Python, etc.); for complex processing (auth, content generation); slower but capable.
- Trade-offs: Speed vs. complexity; CloudFront Functions for high-scale edges.

#### Example Use Cases
- Geographic routing (viewer request based on IP).
- Authentication token injection (origin request).
- Dynamic caching rules (origin response).

### Lab Demos
- Deferred to Lambda series; conceptual only.

## 12.12 AWS CloudFront Setting Options -- Supported HTTP Versions & Default Root Object

### Overview
Covers supported HTTP versions (e.g., HTTP/2 for better performance) and default root objects for seamless bucket origins in distributions.

### Key Concepts/Deep Dive

#### Supported HTTP Versions
- Default: HTTP/1.0-1.1; add HTTP/2-3 for multiplexing, compression, reduced latency.
- CloudFront auto-adopts best supported client version for compatibility.
- Recommendation: Enable HTTP/2+ for modern apps.

#### Default Root Object
- For bucket origins: Defines root file (e.g., index.html) served at base path (/) instead of requiring /index.html.
- Avoids 403 errors by specifying file; not needed for website endpoints.
- Example: Root URL serves index.html directly.

### Lab Demos
1. **Configure Versions**: Enable advanced HTTP versions.
2. **Set Root Object**: For bucket origins, observe error and resolution.

## 12.13 AWS CloudFront Setting Options Part 2

### Overview
[No transcript available; references additional settings like TTL, origins continued from prior modules.]

- Assumes continuation of settings like price classes, logging, etc., from creation flow.
- Focus on logging distributions or integrated monitoring.

## 12.14 AWS CloudFront Geographic Restrictions

### Overview
Explains geographic restrictions (allowlists/blocklists) to control content access by country/IP, useful for compliance or region-specific content.

### Key Concepts/Deep Dive

#### Types
- **Allowlist**: Permit specific countries only.
- **Blocklist**: Block specified countries.

#### Use Cases
- Legal compliance (e.g., content restrictions).
- Paid content regionalization.
- Reducing unauthorized access.

#### Setup
- In Security > CloudFront Geographic Restrictions.
- Select type; add ISO country codes (e.g., IN, BR).
- Immediate effect post-update; reverts on removal.

#### Testing
- Use GeoPicker tools; observe 403 errors for blocked regions.
- Affects all distribution traffic.

### Lab Demos
1. **Set Restrictions**: Block/allow countries.
2. **Test Access**: Verify denials and allowances.

## 12.15 AWS CloudFront Origin Group Lab 1 EC2 & S3 Failover

### Overview
Lab on origin groups for automatic failover from EC2 primary to S3 secondary, ensuring availability during outages.

### Key Concepts/Deep Dive

#### Origin Groups and Failover
- Primary (EC2) fails over to secondary (S3) on errors (e.g., 5xx).
- Automatic switching maintains uptime; back to primary when available.

#### Lab Scenarios
- **Basic Failover**: EC2 main, S3 backup for static maintenance page.
- Business continuity for downtime minimization.
- Costs: Lower than multi-region setups.

#### Steps
1. **Setup EC2 Web Server**: Install Apache, host index.html.
2. **Setup S3 Backup**: Public static website for error page.
3. **CloudFront**:
   - Add origins.
   - Create origin groups (primary failover).
   - Attach group via behaviors > edit > origin groups.

#### Testing
- Normal: EC2 serves traffic.
- Fail: Block EC2 port; switch to S3.
- Recover: Re-enable port; revert to primary.

### Lab Demos
1. **Configure EC2/S3 Origins**.
2. **Create Origin Group**.
3. **Simulate Failures** via security groups.
4. **Verify Automatic Switching**.

## 12.16 AWS CloudFront Origin Group Lab 2 Geographical Failover with Load Balancer

### Overview
Advanced lab for regional failover using load balancers in multi-regions, ensuring global reliability.

### Key Concepts/Deep Dive

#### Scenario
- Primary: India Load Balancer.
- Secondary: US (Virginia) Load Balancer.
- Failover triggers on regional outages (e.g., ALB down).

#### Setup
1. **Multi-Region Resources**: EC2 instances, ALBs in separate regions/Zones.
2. **CloudFront**: Add ALB origins; create groups for failover.
3. Behaviors attach groups.

#### Testing
- Health checks auto-switch groups.
- Simulate via security group blocks.
- Verify seamless global traffic shift.

### Lab Demos
1. **Multi-Region Infrastructure Setup**.
2. **CloudFront Group Configuration**.
3. **Induce Failures and Monitor Recovery**.

## 12.17 AWS CloudFront Tutorial -- AWS CloudFront Error Pages

### Overview
Customizes error responses (e.g., 504 Gateway Timeout) with user-friendly pages from S3 origins for better UX during issues.

### Key Concepts/Deep Dive

#### Problem
- Origin errors (e.g., 504) propagate to users without CloudFront intervention, harming trust.
- Failover expensive; custom pages cheaper alternative.

#### Solution: Custom Error Responses
1. **Host Error Page**: In S3 static site (e.g., /error/index.html).
2. **CloudFront Configuration**:
   - Add S3 as additional origin.
   - Create cache behavior for error path (e.g., /error/* to S3).
   - In Error Pages: For 504, redirect to S3 custom page.
3. **Response Modes**: Serve from origin or redirect.

#### Benefits
- Professional error handling without complex setups.
- Applicable to various HTTP errors (4xx/5xx).

### Lab Demos
1. **Create S3 Error Page Origin**.
2. **Configure Error Responses in CloudFront**.
3. **Simulate Errors and Verify Custom Pages**.

## 12.18 AWS CloudFront Cache Invalidation

### Overview
Demonstrates manual cache invalidation to force updates at edge locations, ensuring content freshness without waiting for TTL expiration.

### Key Concepts/Deep Dive

#### Cache Mechanics
- CloudFront caches content at edges; updates delay for distant users due to TTL.
- Manual invalidation clears specific/universal caches instantly.

#### Process
- In Distributions > Invalidations: Create invalidation.
- Specify paths (e.g., /* for all; /image.jpg for specific).
- Costs apply; use judiciously.

#### Use Cases
- Urgent content updates (e.g., breaking news).
- Development testing with frequent changes.

#### Example Scenario
- Update S3 origin file; local access reflects changes.
- Remote users see old cached version.
- Invalidate path; distributes new content globally.

### Lab Demos
1. **Update Origin Content**.
2. **Verify Cache Lag**.
3. **Invalidate and Confirm Updates**.

## Summary Section

### Key Takeaways
```diff
+ CloudFront is AWS's CDN for low-latency global content delivery via edge caching, integrating S3, EC2, ALBs seamlessly.
+ Origin settings (domain, path, headers, shield) optimize security and performance without origin changes.
- Without HTTPS and restrictions, content risks exposure; always enable secure protocols and access controls.
+ Custom features like origin groups, error pages, restrictions ensure high availability and compliance.
+ Cache management (invalidation, policies) balances freshness and efficiency.
```

### Quick Reference
- **Basic Distribution Creation**:
  ```bash
  # Via Console: Create Distribution > Select Origin (S3/EC2/ALB) > Attach SSL (ACM) > Enable Optional Features
  ```
- **Inactivate Cache**:
  ```bash
  # Distributions > Invalidate > Path: /*
  ```
- **Origin Access Control Setup**:
  ```json
  {
    "Version": "2008-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {"AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity <OAI>"},
        "Action": "s3:GetObject",
        "Resource": "arn:aws:s3:::bucket-name/*"
      }
    ]
  }
  ```

### Expert Insight
#### Real-world Application
CloudFront serves Netflix/Prime for global streaming, caching media near users, reducing latency. Retail sites like Amazon use it for product images/APIs, improving conversion rates.

#### Expert Path
Master CloudFront by: Studying AWS exams (SAA-C03) scenarios; implementing multi-origin failovers; integrating Lambda@Edge for custom logic; monitoring via CloudWatch for optimization.

#### Common Pitfalls
Overlooking TTL/short expirations increases invalidation costs; not enabling OAC exposes S3 buckets; ignoring HTTP versions reduces performance; forgetting geo-restrictions for compliance issues.

#### Lesser-Known Facts
CloudFront supports WebSockets via origins; real-time metrics via logs; serverless deployments via Function Associations; content pre-warming via signed URLs for peak events.

</details>
