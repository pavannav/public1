# Section 18: ELB Overview

<details open>
<summary><b>Section 18: ELB Overview (KK-CS45-script-v2)</b></summary>

## Table of Contents
- [18.1 ELB Overview](#181-elb-overview)
- [18.2 Classic Load Balancer](#182-classic-load-balancer)
- [18.3 Application Load Balancer](#183-application-load-balancer)
- [18.4 Network Load Balancer](#184-network-load-balancer)
- [18.5 Connection Idle Timeout](#185-connection-idle-timeout)
- [18.6 Request Routing Algorithm](#186-request-routing-algorithm)
- [18.7 Sticky Sessions (Session Affinity)](#187-sticky-sessions-session-affinity)
- [18.8 Cross-Zone Load Balancing](#188-cross-zone-load-balancing)
- [18.9 ELB SSL-TLS](#189-elb-ssl-tls)
- [18.10 Connection Draining](#1810-connection-draining)
- [18.11 X-Forwarded Headers](#1811-x-forwarded-headers)
- [18.12 Hands On- ALB X-Forwarded Headers](#1812-hands-on--alb-x-forwarded-headers)
- [18.13 Proxy Protocol](#1813-proxy-protocol)
- [18.14 Hands On- NLB Proxy Protocol](#1814-hands-on--nlb-proxy-protocol)
- [18.15 gRPC & ALB](#1815-grpc--alb)
- [18.16 Hybrid Connectivity](#1816-hybrid-connectivity)
- [18.17 Security Groups Outbound Rules & Managed Prefixes](#1817-security-groups-outbound-rules--managed-prefixes)

## 18.1 ELB Overview

### Overview
This lecture introduces Elastic Load Balancing (ELB) concepts, explaining what load balancers are, why they're needed, their managed service nature in AWS, and provides an overview of different ELB types available on AWS.

### Key Concepts

A **load balancer** is a server or set of servers that forward traffic to multiple backend EC2 instances commonly called downstream instances. Load balancers distribute incoming client requests across multiple servers to improve application availability, scalability, and fault tolerance.

#### Why Use Load Balancers?

Load balancers provide:
- **Single point of access** for applications without exposing individual backend instance details to clients
- **Fault tolerance** through health checks that route traffic away from unhealthy instances
- **SSL termination** for HTTPS traffic encryption/decryption
- **Sticky sessions** for session persistence using application cookies
- **High availability** across multiple Availability Zones
- **Traffic segregation** between public-facing and private internal traffic

#### AWS ELB Managed Service Benefits
✅ **No-brainer choice** - Cost-effective compared to building custom load balancers
✅ **Comprehensive scaling** - Handles massive request volumes automatically
✅ **Integrated ecosystem** - Works seamlessly with EC2 Auto Scaling Groups, ECS, Certificate Manager, CloudWatch, Route 53, WAF, Global Accelerator, and more
✅ **AWS-managed maintenance** - Automatic upgrades and high availability guarantees

#### ELB Types Overview

AWS provides four managed load balancer types:

1. **Classic Load Balancer (CLB)** - V1 generation from 2009
   - Supports: HTTP, HTTPS, TCP, SSL (TLS)
   - Layer 4/7 capable, legacy option

2. **Application Load Balancer (ALB)** - V2 generation from 2016
   - Supports: HTTP, HTTPS, WebSocket, HTTP/2, gRPC
   - Layer 7 only, advanced routing capabilities

3. **Network Load Balancer (NLB)** - V2 generation from 2017
   - Supports: TCP, TLS, UDP, Secure TCP
   - Layer 4 only, ultra-high performance (millions RPS)

4. **Gateway Load Balancer (GLB)** - V2 generation from 2020
   - Operates at network layer (Layer 3)
   - Supports IP protocols

**Recommendation:** Use newer generation load balancers (ALB/NLB/GLB) for enhanced features and performance.

#### Load Balancer Configuration Options
- **Internal vs External**: Private access within VPC or internet-facing public access
- **Protocols**: Choose based on application needs (HTTP for web apps, TCP for databases)

#### Health Checks
Critical ELB feature for traffic routing:
- Uses port and route combination (e.g., `:4567/health`)
- Load balancer sends requests and expects 200 status code responses
- Unhealthy instances are automatically removed from traffic routing
- Configurable health check intervals, timeouts, and thresholds

#### Security Architecture

```
diff
+ Client → ELB (Security Group allows 0.0.0.0/0:80,443) → EC2 instances (Security Group allows only ELB Security Group)
- Never allow 0.0.0.0/0 directly to EC2 instances for public applications
```

**Best Practice:** EC2 instances should only accept traffic from ELB security groups, creating a secure, layered access pattern.

## 18.2 Classic Load Balancer

### Overview
This lecture covers the Classic Load Balancer (CLB) architecture, protocols, supported connections, health checks, and specific use cases, including important exam scenarios like backend authentication and mutual SSL.

### Key Concepts

#### CLB Architecture
- **Multi-AZ deployment**: CLB spans across multiple Availability Zones
- **Target registration**: EC2 instances registered directly (no target groups concept)
- **Health monitoring**: Continuous health checks to route traffic away from unhealthy instances

#### Supported Protocols & Layers
- **Layer 4/7 operation**: Works at both network and application layers
- **Protocol support**: HTTP, HTTPS, TCP, SSL (TLS)
- **EC2-Classic compatibility**: Limited support for legacy network mode

```
diff
! IMPORTANT: CLB is deprecated - prefer ALB/NLB for new deployments
```

#### Listener-to-Target Communication Matrix

| Listener Protocol | Target Protocol | Use Case Notes |
|-------------------|-----------------|---------------|
| HTTP | HTTP | Basic web traffic, no encryption |
| HTTP | HTTPS | Backend authentication required on EC2 instances |
| HTTPS | HTTP | SSL termination at CLB |
| HTTPS | HTTPS | SSL termination at CLB + backend authentication |
| TCP | TCP | Pass-through (no termination) |
| TCP | SSL | Backend SSL authentication on EC2 |
| SSL | TCP | SSL termination at CLB |
| SSL | SSL | SSL termination + backend authentication |

#### Backend Authentication
When HTTPS/SSL configured on EC2 instances:
- **Public certificate** uploaded to CLB
- **Private key** stored on EC2 instances
- Enables server authentication of backend instances

#### Mutual SSL (Two-Way Authentication)
Unique CLB capability for highest security:
- **TCP-to-TCP connections**: No termination at CLB level
- **Client ↔ EC2 mutual authentication**: Both parties verify each other
- **SSL termination at EC2**: Full connection encrypted end-to-end
- **Certificate exchange**: Client certificates + server certificates

```
diff
+ EXAM TIP: TCP-to-TCP with mutual SSL is the ONLY way for two-way authentication on CLB
```

#### Health Checks
- **Supported protocols**: HTTP, HTTPS, TCP
- **Configuration**: Route-based (e.g., `/health`) and port-based

## 18.3 Application Load Balancer

### Overview
This comprehensive lecture covers Application Load Balancer (ALB) capabilities including advanced Layer 7 features, target groups, routing rules, authentication integration, SSL handling, and practical configuration examples.

### Key Concepts

#### ALB Architecture
ALBs operate at Layer 7 (Application layer) with sophisticated routing capabilities:
- **Listeners**: Accept client connections (HTTP/HTTPS)
- **Rules**: Define routing logic (conditions → actions)
- **Target Groups**: Collections of backend resources
- **Targets**: EC2 instances, containers, Lambda functions, or IP addresses

#### Supported Protocols & Features
- **Protocol support**: HTTP, HTTPS, WebSocket, HTTP/2, gRPC
- **Content-based routing**: Path, host header, query strings, HTTP headers, source IP
- **Dynamic port mapping**: Essential for ECS containerized applications
- **Custom HTTP responses**: Return static content without backend involvement
- **URL redirects**: Automatically redirect HTTP → HTTPS or other paths

#### Target Groups Deep Dive

Target Groups contain registered targets and health checks:

| Target Type | Description | Health Check Support |
|-------------|-------------|---------------------|
| EC2 Instances | Individual or Auto Scaling Group managed | HTTP/HTTPS (WebSocket unsupported) |
| ECS Tasks | Containerized applications | HTTP/HTTPS |
| Lambda Functions | Serverless compute | HTTP request → JSON event conversion |
| IP Addresses | Private IPs (peered VPCs, on-premises) | HTTP/HTTPS |

#### ALB-Specific Capabilities

1. **Dynamic Port Mapping**
   - Enables ALB to route to specific containers on ECS instances
   - Impossible with CLB (no target group concept)
   - Each container gets unique port mapping

2. **Authentication Integration**
   - Offloads user authentication from applications to ALB
   - Cognito integration: Login verification before request routing
   - Supports SAML, OIDC, LDAP, Active Directory, social providers (Amazon, Google, Facebook)

#### Routing Examples

**Path-based Routing:**
```
/search → search-target-group (Lambda)
/api/v1/* → api-target-group (ECS)
/users → users-target-group (EC2)
```

**Query String Routing:**
```
GET /app?action=login → auth-target-group
GET /app?action=dashboard → app-target-group
```

**Host-based Routing (SNI Alternative):**
```
api.example.com → api-target-group
web.example.com → web-target-group
```

#### Listener Rules
- **Default rule**: Catch-all for unmatched requests
- **Rule priority**: 1 (highest) to last (default)
- **Multiple conditions**: AND logic between conditions
- **Actions**: Forward to target groups, redirect, fixed response

```yaml
Listener Rules Example:
- Rule 1: IF Path starts with /api/* → Forward to api-target-group
- Rule 2: IF Host equals api.domain.com → Forward to api-target-group
- Default: Forward to web-target-group
```

#### Weighted Target Group Routing
Enables advanced deployment strategies:
- **Single rule → Multiple target groups** with weights
- **Blue-green deployments**: Gradual traffic shifting (80% blue, 20% green)
- **A/B testing**: Route percentage of traffic to new features
- **Canary deployments**: Small percentage to new versions

Example: 90% production, 10% canary testing

#### HTTPS & SSL Configuration
- **Certificate management**: AWS Certificate Manager (ACM) integration
- **Default certificate**: Required for HTTPS listeners
- **Optional certificates**: For multiple domains (SNI)
- **Backend encryption**: Optional HTTPS to targets (requires target certificates)

```yaml
SSL Termination Flow:
Client (HTTPS) → ALB (decrypt) → Target Group (HTTP/HTTPS)
```

#### ALB Limitations & Requirements
```diff
+ REQUIREMENT: Subnets must be minimum /27 CIDR (8+ free IPs)
+ REQUIREMENT: Maximum 100 IPs per ALB across all subnets
- LIMITATION: Cannot register EC2 instances by ID in peered VPCs
- LIMITATION: Must use IP addresses for inter-region peered targets
```

## 18.4 Network Load Balancer

### Overview
This lecture covers Network Load Balancer (NLB) architecture, ultra-high performance capabilities, target types, health checking, client IP preservation, availability zone behaviors, and DNS naming for optimal networking configurations.

### Key Concepts

#### NLB Core Architecture
- **Layer 4 operation**: TCP, UDP, TLS protocols
- **Fixed IP addresses**: Static IPs per Availability Zone (EIPs optional)
- **Ultra-high performance**: Millions of requests per second
- **Sub-second latency**: ~100ms vs ~400ms for ALB
- **Use cases**: Extreme performance, custom TCP/UDP, AWS PrivateLink

```
ELB Performance Comparison:
Network Load Balancer (NLB): >>> Millions RPS, 100ms latency
Application Load Balancer (ALB): Millions RPS, 400ms latency
```

#### Target Group Types
Similar to ALB but with networking focus:

| Target Type | Description | Notes |
|-------------|-------------|-------|
| EC2 Instances | Standard instances or ASG | Auto Scaling supported |
| ECS Tasks | Containerized tasks | Dynamic port support |
| IP Addresses | Private IPs only | On-premises via Direct Connect/VPN, peered VPCs |

```diff
+ CONSTRAINT: Cannot register EC2 instances by ID in peered VPCs - must use IP addresses
```

#### Client IP Address Preservation
Critical networking concept for NLB behavior:

| Registration Method | TCP/TLS | UDP/TCP-UDP |
|---------------------|---------|-------------|
| Instance ID/ECS Task | ✅ Always preserved | ✅ Always preserved |
| IP Address | ❌ Not preserved by default | ✅ Always preserved |

**Proxy Protocol v2** enables IP preservation for TCP/TLS when using IP address registration.

#### Health Check Types
1. **Active Health Checks**: Periodic requests to registered targets
2. **Passive Health Checks**: Monitor real connection behavior
   - Cannot be disabled (always enabled)
   - Detects unhealthy targets faster than active checks

#### Availability Zone Management
```diff
+ REQUIREMENT: Must explicitly enable AZs in NLB configuration
+ CONSTRAINT: Cannot disable/remove enabled AZs (requires full NLB recreation)
+ NETWORKING RULE: Traffic only routes to explicitly enabled AZs
```

#### Cross-Zone Load Balancing
- **Disabled by default** on NLB (enabled by default on ALB)
- **Charges apply** when enabled (inter-AZ data transfer costs)
- Only routes to enabled AZs in target group

#### DNS Naming & Resolution

1. **Regional DNS Name**: Returns IPs from ALL enabled AZ nodes
2. **Zonal DNS Name**: Returns IP from specific AZ node only

**Use Case Examples:**
- **Regional**: Standard load balancing across AZs
- **Zonal**: Minimize data transfer costs by preferring local AZ node

```
NLB DNS Query Example:
Regional: nlbdemo.elb.region.amazonaws.com → Returns 3 IPs (one per AZ)
Zonal: us-east-1a.nlbdemo.elb.region.amazonaws.com → Returns 1 IP (AZ-specific)
```

#### Subnet Requirements
```diff
+ INTERNET-FACING NLB: /28 minimum subnet CIDR (8+ free IPs)
+ INTERNAL NLB: /28 minimum (8+ free IPs) or AWS selects private IPs
```

#### Advanced Limits & Behaviors
- **440,000 concurrent connections/minute** per target before port allocation errors
- **Static networking**: Cannot modify ENIs, EIPs, or private IPs after creation
- **Elastic IP assignment**: Only for internet-facing NLBs

## 18.5 Connection Idle Timeout

### Overview
This lecture explains connection idle timeout configuration for AWS load balancers, which determines how long connections remain open when no data is transmitted, affecting both client-to-ELB and ELB-to-target connections.

### Key Concepts

#### Timeout Application
- **Client ↔ ELB timeout**: Closes connection after 60 seconds of inactivity
- **ELB ↔ Target timeout**: Closes connection after 60 seconds of inactivity
- **Data transmission reset**: Single byte transmission resets timers

```diff
+ RECOMMENDATION: Enable HTTP keep-alive on web servers for efficient connection reuse
```

#### Timeout Configuration by Load Balancer Type

| Load Balancer | Client ↔ ELB | ELB ↔ Target | Notes |
|---------------|-------------|-------------|-------|
| Classic Load Balancer (CLB) | ⚙️ Configurable | ⚙️ Configurable | 60 seconds default |
| Application Load Balancer (ALB) | ⚙️ Configurable | ⚙️ Configurable | 60 seconds default |
| Network Load Balancer (NLB) | ❌ Fixed | ❌ Fixed | TCP: 350s, UDP: 120s |

#### Configuration Use Cases
```diff
+ FILE UPLOADS: Increase timeout to prevent premature disconnection during large transfers
- SHORT REQUESTS: Reduce timeout for faster cleanup and resource efficiency
```

#### HTTP Keep-Alive Benefits
- **Connection reuse**: Prevents repeated TCP handshake overhead
- **Performance boost**: Reduces latency for subsequent requests
- **Resource efficiency**: Fewer connection establishments/teardowns

## 18.6 Request Routing Algorithm

### Overview
This lecture covers the three request routing algorithms used by AWS Elastic Load Balancers: Least Outstanding Requests (ALB/CLB), Round Robin (ALB/CLB), and Flow Hash (NLB), explaining their mechanics and appropriate use cases.

### Key Concepts

#### 1. Least Outstanding Requests (LOR)
- **Algorithm**: Routes to instance with fewest pending unfinished requests
- **Load balancer types**: ALB and CLB (HTTP/HTTPS only)
- **Intelligence**: Considers actual backend workload, not just connection count
- **Benefits**: Optimal load distribution based on processing capacity

```
LOR Example:
Instance A: 2 pending requests
Instance B: 0 pending requests
Instance C: 1 pending request
→ New request routes to Instance B (lowest outstanding load)
```

#### 2. Round Robin
- **Algorithm**: Cycles through targets sequentially (1→2→3→1→2→3...)
- **Load balancer types**: ALB and CLB (TCP mode)
- **Simplicity**: Equal distribution regardless of load
- **Use cases**: Basic load balancing without load-based routing needs

```
Round Robin Example:
Request 1: Instance A
Request 2: Instance B
Request 3: Instance C
Request 4: Instance A
```

#### 3. Flow Hash
- **Algorithm**: Hashes TCP/UDP connection parameters to target mapping
- **Load balancer types**: Network Load Balancer (NLB) exclusively
- **Hash inputs**: Protocol + Source IP + Destination IP + Source Port + Destination Port + TCP Sequence Number
- **Guarantee**: All packets in same flow → same target for connection lifetime

```yaml
Flow Hash Inputs:
protocol: TCP
source_ip: 192.168.1.1
source_port: 443
dest_ip: 10.0.0.1
dest_port: 80
tcp_seq: 12345
→ Hashes to Target Instance #2 (consistent for this flow)
```

#### Algorithm Selection Matrix

| Scenario | Recommended Algorithm |
|----------|----------------------|
| HTTP/HTTPS load balancing | Least Outstanding Requests |
| TCP load balancing | Round Robin |
| TCP/UDP session persistence | Flow Hash (NLB) |

## 18.7 Sticky Sessions (Session Affinity)

### Overview
This lecture demonstrates sticky sessions (session affinity) configuration on AWS load balancers, enabling clients to consistently connect to the same backend instance. Includes practical hands-on demonstration with cookie-based affinity.

### Key Concepts

#### Sticky Sessions Mechanism
- **Purpose**: Same client requests → same backend instance
- **Cookie-based**: Load balancer sets affinity cookie on client
- **Expiration**: Cookie-controlled session duration (1 second to 7 days)
- **Load balancer support**: All ELB types (CLB, ALB, NLB)

#### Potential Drawbacks
```diff
- LOAD IMBALANCE RISK: High-traffic "sticky" users may overload specific instances
- TRADE-OFF ANALYSIS: Session consistency vs. optimal load distribution
```

#### Cookie Types

1. **Application-Based Cookies**
   - **Generation**: Target application creates custom cookies
   - **Customization**: Full control over cookie attributes
   - **Names**: Must specify at target group level
   - **Reserved names prohibited**: AWSALB, AWSALBAPP, AWSALBTG

2. **Duration-Based Cookies**
   - **Generation**: Load balancer creates standard cookies
   - **Names**:
     - ALB: `AWSALB` (classic) or `AWSALBAPP` (newer)
     - CLB: `AWSELB`
   - **Expiration**: Load balancer-controlled duration

#### Hands-On Configuration Example

**Target Group Configuration:**
1. Navigate to Target Group → Attributes → Edit
2. Enable "Stickiness"
3. Choose cookie type: Load balancer generated OR Application-based
4. Set duration (1 second → 7 days) or specify custom cookie name
5. Apply changes

**Cookie Behavior Demonstration:**
```
Initial Request: Client receives AWSALBAPP cookie with session ID
Subsequent Requests: Client sends cookie → routes to same instance
Cookie Expiration: After duration → new instance assignment possible
```

#### Debugging Sticky Sessions
Use browser Developer Tools:
1. Open Network tab during requests
2. Observe response cookies (affinity data)
3. Verify request cookies (session persistence)

```diff
+ VERIFICATION: Refreshing page should show consistent instance responses when sticky
```

## 18.8 Cross-Zone Load Balancing

### Overview
This lecture explains cross-zone load balancing across AWS load balancers, demonstrating how it enables traffic distribution across multiple Availability Zones and the cost implications of different configurations.

### Key Concepts

#### Cross-Zone Load Balancing Mechanics

**Without Cross-Zone Balancing:**
- Traffic stays within originating AZ's load balancer instances
- Imbalanced AZs create uneven load distribution
- No inter-AZ data charges

**With Cross-Zone Balancing:**
- Traffic flows between AZs at load balancer level
- Even distribution across all healthy targets
- Potential inter-AZ data transfer costs

```
Example: 2 AZs (2 vs 8 instances)

WITHOUT Cross-Zone:
AZ1 LB (2 instances): handles 50% total traffic → 25% load per instance
AZ2 LB (8 instances): handles 50% total traffic → 6.25% load per instance
Result: Uneven distribution, AZ1 overloaded

WITH Cross-Zone:
Combined pool (10 instances): 50% traffic from each LB
Result: 10% load per instance across all AZs
```

#### Load Balancer Cross-Zone Defaults & Costs

| Load Balancer | Cross-Zone Default | Inter-AZ Costs |
|---------------|-------------------|----------------|
| Application Load Balancer (ALB) | ✅ Enabled | ❌ No charges |
| Network Load Balancer (NLB) | ❌ Disabled | ✅ Charges apply |
| Gateway Load Balancer (GLB) | ❌ Disabled | ✅ Charges apply |
| Classic Load Balancer (CLB) | ❌ Disabled | ❌ No charges |

#### ALB Cross-Zone Implementation
- **Always enabled** at load balancer level
- **Target group override**: Can disable per target group
- **No cost optimization**: Use target group settings for cost control

```yaml
ALB Cross-Zone Control:
Load Balancer Level: Always "on"
Target Group Level: Can set to "Use load balancer setting" or "Off"
```

#### NLB Cross-Zone Hands-On
**Configuration:**
1. NLB Attributes → Cross-zone load balancing → Edit → Enable
2. Warning: "May include regional charges"

**Networking Impact:**
- Only routes to explicitly enabled AZs
- Cross-zone applies only within enabled AZ scope
- Disabling removes AZ from routing (permanent until recreation)

```diff
+ NETWORKING TIP: Enable all target group AZs in NLB for full cross-zone benefits
```

## 18.9 ELB SSL-TLS

### Overview
This lecture covers SSL/TLS encryption for AWS load balancers, including certificate management, SSL termination, Server Name Indication (SNI) for multiple domains, security policies, and SSL offloading benefits.

### Key Concepts

#### SSL/TLS Termination Architecture

```
Client (HTTPS) → ELB (SSL Termination) → EC2 Instance (HTTP)
```

**Benefits:**
- **Certificate management**: Centralized at load balancer level
- **Backend simplification**: EC2 instances handle unencrypted traffic
- **Performance**: SSL processing offloaded from application servers

#### Certificate Management
- **AWS Certificate Manager (ACM)**: Required for ELB certificate storage
- **Certificate types**:
  - Default certificate (required for HTTPS)
  - Optional additional certificates for multi-domain support
- **Self-signed certificates**: Allowed but not recommended for production

#### Server Name Indication (SNI)

**Problem Solved:** Single server hosting multiple SSL-enabled websites with different certificates.

**How SNI Works:**
1. **Initial handshake**: Client indicates target hostname during SSL negotiation
2. **Certificate selection**: Load balancer uses hostname to select correct certificate
3. **Multi-domain support**: Single IP address supports multiple SSL certificates

```yaml
SNI Example:
Client: www.example.com, api.example.com
ALB: Returns appropriate certificate per hostname
```

**Load Balancer SNI Support:**
- **ALB & NLB**: Full SNI support with multiple certificates via ACM
- **CLB**: Limited - requires Subject Alternative Names (SANs) for multiple domains
  - Certificate changes require reissuance with new SANs

```diff
+ RECOMMENDATION: Use ALB over CLB for better multi-domain SSL certificate management
```

#### ALB vs CLB SSL Comparison

| Feature | ALB | CLB |
|---------|-----|-----|
| Certificate Management | Easy (SNI) | Complex (SAN certificates) |
| Multi-domain Support | Excellent | Requires SAN manipulation |
| Certificate Updates | Instant | Certificate reissuance required |

#### Security Policies

**SSL Security Policy Components:**
- **SSL Protocols**: TLS versions, cipher suites
- **Server Order Preference**: Cipher negotiation priorities
- **Compliance focus**: Security standards adherence

**Predefined Security Policies:**

| Policy Category | Use Case | Example Policies |
|----------------|----------|------------------|
| ELBSecurityPolicy-* (Default) | General compatibility | ELBSecurityPolicy-2016-08 |
| ELBSecurityPolicy-TLS-* | TLS version requirements | Force specific TLS versions |
| ELBSecurityPolicy-FS-* | Forward Secrecy | Unique session keys for eavesdropping protection |

```diff
+ FORWARD SECRECY: Use ELBSecurityPolicy-FS-* policies for enhanced encryption security
```

## 18.10 Connection Draining

### Overview
This lecture covers connection draining (deregistration delay on newer load balancers), which provides graceful handling of in-flight requests when instances are being removed from service, preventing dropped connections and data loss.

### Key Concepts

#### Connection Draining Purpose
- **Graceful shutdown**: Allows completion of active requests during instance deregistration
- **Connection preservation**: Keeps existing connections open during drain period
- **New connection blocking**: Prevents new connections to draining instances

```diff
+ TIMING CONSIDERATION: Balance quick removal vs. request completion time
```

#### Connection Draining Process

1. **Drain initiation**: Instance marked unhealthy or manually deregistered
2. **Grace period start**: ELB stops sending new connections to instance
3. **Active connection handling**: Existing connections remain until:
   - Request completion (natural end)
   - Timeout reached (configured duration)
4. **Cleanup**: Instance fully removed from target group

#### Configuration Parameters

| Load Balancer | Feature Name | Default Duration | Range |
|---------------|--------------|------------------|-------|
| Classic Load Balancer | Connection Draining | 300 seconds (5 min) | 1-3600 seconds |
| ALB/NLB | Deregistration Delay | 300 seconds (5 min) | 1-3600 seconds |

```diff
+ SHORT DRAIN: Use 30 seconds for fast application restarts
+ LONG DRAIN: Use maximum for long-running uploads/downloads
```

#### Drain Time Optimization Guidelines

**Fast Drain Scenarios:**
- High-frequency, short-duration requests (<1 second)
- Stateless applications
- Frequent scaling events

**Extended Drain Scenarios:**
- Large file uploads/downloads
- Long-running transactions
- Stateful applications with critical session data

## 18.11 X-Forwarded Headers

### Overview
This lecture explains X-Forwarded HTTP headers used by Application Load Balancers and Classic Load Balancers to preserve client connection information when SSL termination occurs at the load balancer level.

### Key Concepts

#### Problem Solved by X-Forwarded Headers

**Network Flow:**
```
Client (Public IP: 203.0.113.1) → ALB (Public IP) → EC2 Instance (Private IP: 10.0.0.25)
```

**Issue:** EC2 instance sees traffic from ALB's private IP (`10.0.0.25`), losing client identity.

**Solution:** ALB injects X-Forwarded headers revealing original client details.

#### X-Forwarded Header Types

| Header | Purpose | Example Value |
|--------|---------|---------------|
| `X-Forwarded-For` | **Client IP Address** | `203.0.113.1` |
| `X-Forwarded-Proto` | **Protocol Used** | `https` |
| `X-Forwarded-Port` | **Client Port** | `443` |

**Use Cases:**
- Client IP logging for analytics
- Security filtering based on source IP
- Protocol-aware application behavior

#### Load Balancer Support
- **ALB**: Always enabled, adds all three headers
- **CLB**: HTTP/HTTPS modes only (not TCP)
- **NLB**: Not applicable (different preservation methods)

#### Header Implementation Example
```yaml
ALB Request Transformation:
Original: GET /api/users HTTP/1.1
Enhanced: GET /api/users HTTP/1.1
          X-Forwarded-For: 203.0.113.1
          X-Forwarded-Proto: https
          X-Forwarded-Port: 443
```

## 18.12 Hands On- ALB X-Forwarded Headers

### Overview
This practical hands-on demonstration shows how to configure Apache web server to log and interpret X-Forwarded headers from ALB, enabling backend servers to identify original client information despite load balancer termination.

### Key Concepts

#### Configuration Steps for X-Forwarded Headers

1. **Web Server Deployment:**
   - Launch EC2 instance with Amazon Linux 2023
   - Install Apache httpd during bootstrap
   - Create custom HTTP 200 health check endpoint

2. **Load Balancer Setup:**
   - Create Application Load Balancer (internet-facing)
   - Configure HTTP:80 listener
   - Register EC2 instance in target group with HTTP health checks

3. **Security Group Configuration:**
   ```diff
   + ALB Security Group: Allow 0.0.0.0/0 on ports 80/443
   + EC2 Security Group: Allow only ALB security group (not 0.0.0.0/0)
   ```

4. **Apache Logging Modifications:**
   - Edit `/etc/httpd/conf/httpd.conf`
   - Add custom LogFormat directive to capture X-Forwarded headers:
   ```
   LogFormat "%{X-Forwarded-For}i %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\" %{X-Forwarded-Proto}i %{X-Forwarded-Port}i"
   ```
   - Use `sudo systemctl reload httpd` for configuration activation

#### Hands-On Verification

**Direct EC2 Access:**
```bash
curl http://ec2-public-ip
# Logs: [EMPTY X-Forwarded fields] - direct connection bypasses ALB
```

**Through ALB Access:**
```bash
curl http://alb-dns-name
# Logs: [CLIENT_IP] [PROTOCOL] [PORT] - ALB headers populated
```

**Expected Output Format:**
```
203.0.113.1 - - [timestamp] "GET / HTTP/1.1" 200 ... https 80
```

#### Configuration Cleanup
- Terminate EC2 instance
- Delete ALB resources

## 18.13 Proxy Protocol

### Overview
This lecture covers the Proxy Protocol, a TCP-based mechanism for preserving client connection information when load balancers cannot maintain original IP addresses due to connection termination.

### Key Concepts

#### Proxy Protocol Purpose
**Solves IP Preservation Problem:**
- Network Load Balancer (NLB) or Classic Load Balancer (CLB) terminates TCP connections
- Backend EC2 instances lose original client IP information
- Proxy Protocol prepends client metadata to TCP data stream

```yaml
Proxy Protocol Flow:
Client → NLB → [PROXY PROTOCOL HEADER + ORIGINAL DATA] → EC2 Instance
```

#### Proxy Protocol Versions
- **Version 1 (Human-readable)**: Text-based header format
- **Version 2 (Binary)**: More efficient, NLB-preferred

**Load Balancer Support:**
- **NLB**: Version 2 (recommended)
- **CLB**: Version 1

#### When Proxy Protocol is Required

| Registration Method | TCP/TLS Traffic | UDP Traffic | IP Preservation |
|---------------------|-----------------|-------------|-----------------|
| Instance ID/ECS Task | ✅ Automatic | ✅ Automatic | Always preserved |
| IP Address | ❌ Needs enabling | ✅ Automatic | Use Proxy Protocol v2 |

```diff
+ REQUIREMENT: IP address registration with TCP/TLS requires Proxy Protocol v2
- PROXY CHAINS: Avoid multiple proxies (causes header duplication)
```

#### Backend Configuration Impact
- **Application awareness**: EC2 instances must parse Proxy Protocol headers
- **Connection handling**: Applications need header extraction logic
- **Load testing**: Ensure compatibility before production deployment

## 18.14 Hands On- NLB Proxy Protocol

### Overview
This hands-on demonstration configures Network Load Balancer with Proxy Protocol to preserve client IP addresses on EC2 instances registered by IP address, including Apache server modifications and verification steps.

### Key Concepts

#### NLB with IP Address Registration Setup

1. **Web Server Configuration:**
   - Amazon Linux 2023 EC2 instance
   - Apache httpd installation via user data
   - HTTP service on port 80

2. **Network Load Balancer Deployment:**
   - **Type**: Network Load Balancer (Layer 4)
   - **Target Group**: IP addresses (not instances)
     - **Protocol**: TCP (port 80)
     - **Health Check**: TCP-based
   - Register EC2 private IPv4 address explicitly

3. **Expected Initial Behavior:**
   ```diff
   - DIRECT ACCESS: Logs show client public IP
   - NLB ACCESS: Logs show NLB internal IP (172.31.x.x) - client IP lost
   ```

#### Proxy Protocol Enablement

**NLB Target Group Configuration:**
1. Navigate: Target Group → Attributes → Edit
2. Enable: "Proxy protocol v2"
3. Enable: "Preserve client IP addresses" (if available)

**Apache Proxy Protocol Support:**
1. **Module verification:**
   ```bash
   httpd -M | grep remoteip
   # Expected: remoteip_module (shared)
   ```

2. **Configuration update in `httpd.conf`:**
   ```
   RemoteIPProxyProtocol On
   ```

3. **Service reload:**
   ```bash
   sudo systemctl reload httpd
   ```

#### Hands-On Verification Results

**Post-Configuration Testing:**

| Access Method | Logged IP Address | Status |
|---------------|-------------------|--------|
| Direct to EC2 | Client Public IP | ✅ Working |
| Through NLB | Client Public IP | ✅ Working (Proxy Protocol active) |

**Before/After Comparison:**
```diff
- BEFORE: NLB logs show 172.31.x.x (NLB private IP)
+ AFTER: NLB logs show 203.0.113.1 (actual client IP)
```

#### Configuration Validation
- **Apache error log checking**: Confirm proxy protocol parsing
- **Security groups**: NLB uses separate SG from direct EC2 access
- **Resource cleanup**: Terminate EC2 instance and delete NLB

## 18.15 gRPC & ALB

### Overview
This lecture explores gRPC support on Application Load Balancers, comparing it to Network Load Balancer usage and highlighting ALB-specific advantages for microservices architectures using HTTP/2.

### Key Concepts

#### gRPC Fundamentals
- **Protocol**: Modern API communication framework
- **Transport**: HTTP/2 as foundation
- **Benefits**: Bidirectional streaming, efficient serialization
- **Use case**: Microservices communication

#### ALB gRPC Capabilities

**Full Protocol Support:**
- Native gRPC request/response handling
- HTTP/2 transport layer support
- Bidirectional streaming capabilities
- Microservices target group routing

**Deployment Architecture:**
```
gRPC Clients → ALB (HTTPS) → ECS Target Groups → Containerized gRPC Services
```

#### ALB vs NLB for gRPC

| Feature | ALB + gRPC | NLB + gRPC |
|---------|------------|------------|
| **Health Checks** | ✅ HTTP/2 gRPC aware | ✅ Basic TCP/HTTP |
| **Content-Based Routing** | ✅ Path, headers, metadata | ❌ Layer 4 only |
| **Service Discovery** | ✅ Target groups per service | ❌ Manual configuration |
| **Streaming Support** | ✅ Bidirectional HTTP/2 | ✅ Basic TCP streaming |
| **Protocol Awareness** | ✅ Full gRPC understanding | ❌ Generic TCP handling |

```diff
+ ALB ADVANTAGE: Protocol-aware features (routing, health checks) make it superior for gRPC
```

#### ALB gRPC Implementation

**Listener Requirements:**
- **Protocol**: HTTPS (mandatory for gRPC)
- **Features**: HTTP/2, bidirectional streaming, content-type routing

**Target Group Configuration:**
- **Protocol**: HTTP/2
- **Health Checks**: gRPC-aware status code validation
- **Routing**: Path-based (gRPC service method routing)

#### Real-World Example
```yaml
ALB gRPC Routing:
- /UserService/CreateUser → user-service-target-group
- /OrderService/ProcessOrder → order-service-target-group
- /NotificationService/Send → notification-target-group
```

## 18.16 Hybrid Connectivity

### Overview
This lecture covers load balancing strategies for hybrid cloud environments, including on-premises connectivity via Direct Connect/VPN, VPC peering, and multi-region architectures with AWS load balancers.

### Key Concepts

#### On-Premises Load Balancing (Direct Connect/VPN)

**Architecture Setup:**
```
On-Premises Servers ← Direct Connect/VPN → VPC ALB → ALB Target Group (IP Addresses)
```

**Key Requirements:**
- **Private IP addresses**: Target group must use IP registration
- **Network connectivity**: Established VPN tunnel or Direct Connect
- **Security groups**: Allow cross-network traffic

**ALB Configuration:**
- Create target group with private IP addresses
- Register on-premises server IPs
- Enable appropriate health checks (HTTP/HTTPS)

#### VPC Peering Load Balancing

**Same-Region VPC Peering:**
```
VPC A (ALB) ← VPC Peering → VPC B (EC2 instances)
```

- **IP address registration**: Must use for peered VPC targets
- **No data charges**: Within same region peering
- **ALB subnet consideration**: Ensure proper routing

**Cross-Region VPC Peering:**
```
ALB (us-east-1) ← Inter-Region Peering → EC2 Instances (us-west-2)
```

- **IP address mandatory**: Required for cross-region targets
- **Data transfer costs**: Apply for inter-region traffic
- **DNS resolution**: Consider latency implications

```diff
+ CONSTRAINT: Cannot register EC2 instances "by ID" in peered VPCs - must use IP addresses
```

#### Load Balancer Types by Use Case

| Scenario | Recommended Load Balancer |
|----------|---------------------------|
| On-premises integration | ALB (with IP target groups) |
| Cross-region applications | ALB or NLB with cross-zone |
| High-performance TCP | NLB with EIPs |
| Web applications | ALB with content routing |

#### Dual-Stack IPv4/IPv6 Support

**Domain Name Structure:**
- **IPv4**: `alb-name.region.elb.amazonaws.com`
- **IPv6**: `ipv6.alb-name.region.elb.amazonaws.com`
- **Dual-stack**: Intelligent IPv4/IPv6 routing based on client capability

```yaml
Dual-Stack DNS Resolution:
Client (IPv6 capable) → ipv6.domain → IPv6 ALB endpoint
Client (IPv4 only) → standard domain → IPv4 ALB endpoint
```

**Traffic Flow:**
- **IPv6 clients**: Connect via IPv6, terminate at ALB
- **IPv4 clients**: Connect via IPv4, traffic becomes IPv4 to EC2 instances

```diff
+ EXCEPTION: Internal ALBs support IPv4 only (no IPv6 clients)
```

## 18.17 Security Groups Outbound Rules & Managed Prefixes

### Overview
This lecture covers security group outbound rules configuration and AWS managed prefix lists for controlling outbound traffic from EC2 instances, including customer-managed and AWS-managed prefix variations.

### Key Concepts

#### Default Security Group Behavior
```diff
- DEFAULT: Allow all outbound traffic (0.0.0.0/0)
+ RECOMMENDATION: Restrict outbound to specific services/destinations
```

#### Managed Prefix Lists Overview

**Purpose:**
- Simplify security group maintenance
- Group CIDR blocks for common AWS services
- Centralized management with automatic updates

**Types:**

1. **Customer-Managed Prefix Lists**
   - User-created CIDR collections
   - Reference across accounts (with sharing)
   - Manual maintenance required

```yaml
Customer Prefix List Example:
Name: corporate-networks
CIDR Blocks:
- 192.168.1.0/24 (Office network)
- 10.0.0.0/16 (Branch offices)
- 172.16.0.0/16 (VPN subnets)
```

2. **AWS-Managed Prefix Lists**
   - Pre-defined by AWS for major services
   - Automatically maintained and updated
   - No modification/sharing capability

**Common AWS Managed Prefix Lists:**
- **com.amazon.aws.s3** - Amazon S3
- **com.amazon.aws.dynamodb** - DynamoDB
- **com.amazon.aws.cloudfront** - CloudFront

#### Security Group Outbound Rule Examples

```yaml
Outbound Rule: HTTPS to S3
Type: HTTPS
Destination: com.amazon.aws.s3 (managed prefix)
Port Range: 443
Description: S3 secure access for backups
```

#### Cross-Account Prefix List Sharing

**Customer Prefix List Sharing:**
- Share prefix list with other AWS accounts
- Receiver accounts can reference shared lists
- Centralized IP management for partner/external access

**Example Use Case:**
```diff
+ SCENARIO: Company shares approved IP ranges with vendor accounts for secure access
```

</details>

## Summary

### Key Takeaways
```diff
+ APPLICATION LB: Layer 7 routing with advanced features for HTTP/HTTPS applications
+ NETWORK LB: Layer 4 ultra-high performance for TCP/TLS/UDP with static IPs
+ CLASSIC LB: Legacy Layer 4/7 balancer (deprecated - avoid for new deployments)
+ HEALTH CHECKS: Critical for routing away from unhealthy instances
+ CROSS-ZONE BALANCING: Enabled by default on ALB, must be enabled on NLB with costs
+ SSL TERMINATION: Managed at ELB level with ACM certificates and SNI support
+ CONNECTION DRAINING: Graceful handling with configurable timeouts (1-3600s)
+ STICKY SESSIONS: Session affinity with application or duration-based cookies
+ X-FORWARDED HEADERS: Client IP preservation for ALB/CLB connections
+ PROXY PROTOCOL: TCP header prepending for NLB client IP preservation
+ HYBRID CONNECTIVITY: IP address target groups for on-premises/peered VPC integration
```

### Quick Reference

**Load Balancer Selection Guide:**
- **Web applications**: ALB (content routing, authentication)
- **Containerized apps**: ALB with ECS dynamic ports
- **High-performance TCP**: NLB (millions RPS, low latency)
- **UDP applications**: NLB only (unique Layer 4 capability)
- **Legacy applications**: CLB (only when absolutely necessary)

**Connection Preservation:**
- **ALB**: X-Forwarded headers automatically
- **NLB TCP/IP**: Proxy Protocol v2 required
- **NLB TCP/ID**: Automatic preservation

**Health Check Protocols:**
- **ALB/NLB**: HTTP, HTTPS, TCP
- **ALB target types**: IP addresses, containers, Lambda, EC2
- **NLB target types**: IP addresses, EC2, ECS (no Lambda)

### Expert Insight

**Real-world Application:**
Load balancers are essential for production AWS deployments, enabling scalable, fault-tolerant architectures. Choose ALB for modern web applications requiring routing flexibility, NLB for high-throughput TCP/UDP services, and avoid CLB for new implementations due to feature limitations.

**Expert Path:**
Master load balancer selection by workload analysis - HTTP routing needs → ALB, TCP performance requirements → NLB, UDP support → NLB exclusively, legacy migration → gradual ALB transition. Understand IP preservation mechanisms deeply for troubleshooting connectivity issues.

**Common Pitfalls:**
Configuration mistakes include subnet sizing issues (NLB requires /28 minimum), cross-zone balancing cost surprises (enabled by default on ALB but charged on NLB), incorrect target registration methods in hybrid setups, and failing to configure proper health checks leading to traffic routing to unhealthy targets.

**Lesser-Known Facts:**
ALB supports gRPC over HTTP/2 with full protocol awareness exceeding NLB capabilities, managed prefix lists enable elegant outbound security without CIDR maintenance overhead, and zonal DNS names on NLB provide cost optimization through data transfer minimization within AZs.