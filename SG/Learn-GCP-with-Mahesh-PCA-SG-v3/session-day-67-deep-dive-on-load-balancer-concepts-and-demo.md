# Session 67: Deep Dive on Load Balancer Concepts and Demo

## Table of Contents
- [Overview](#overview)
- [Load Balancer Fundamentals](#load-balancer-fundamentals)
- [Backends Supported](#backends-supported)
- [Internal vs External Load Balancers](#internal-vs-external-load-balancers)
- [Application Load Balancer vs Network Load Balancer](#application-load-balancer-vs-network-load-balancer)
- [Proxy vs Pass-Through Load Balancers](#proxy-vs-pass-through-load-balancers)
- [Global vs Regional Load Balancers](#global-vs-regional-load-balancers)
- [Internal Application Load Balancer](#internal-application-load-balancer)
- [Health Checks](#health-checks)
- [SSL and Encryption](#ssl-and-encryption)
- [Lab Demo: Creating Load Balancers](#lab-demo-creating-load-balancers)
- [Advanced Topics: VPC Service Controls](#advanced-topics-vpc-service-controls)
- [Command Line Creation](#command-line-creation)

## Overview
Load balancers are essential Google Cloud components that distribute traffic across multiple backend services, ensuring high availability, scalability, and reliability. They act as intelligent managers that route requests based on health, location, and capacity. This session explores the deep concepts of load balancing in GCP, covering all load balancer types, their architectures, and practical demonstrations with Cloud Run, Cloud Storage, and command-line implementations.

## Load Balancer Fundamentals
Load balancers are like good managers in an organization, routing tasks to the right employees based on their skills and availability. They ensure requests are served by the healthiest, closest backend instances.

### Key Concepts
- **Manager Analogy**: Load balancers route requests to "employees" (backends) based on proximity, health, and capacity. Morning requests from India route to Indian teams; evening requests route to US teams.
- **Backend Dependency**: Load balancers serve no purpose without backends. Applications can exist without load balancers but lack scalability and routing optimization.
- **Backend Types**: Compute Engine, Kubernetes Engine, Cloud Run, Cloud Functions, App Engine, Cloud Storage, External services.
- **External Backends**: Supported for multi-cloud scenarios (e.g., routing to AWS S3 or Azure Blob Storage).

### Historical Context
Previously explored layer 7 load balancers in compute options (VM, GKE, Cloud Run) and layer 4 in Kubernetes services. Now expanding to HTTPS and deeper conceptual understanding.

### What Load Balancers Solve
- **Scalability**: Handle large traffic without backend overload.
- **Reliability**: Route to healthy backends if others fail.
- **Geographic Routing**: Serve requests from closest regions (low latency).
- **Routing Logic**: Based on URL paths, health checks, and session affinity.

```diff
+ Positive: Load balancers enable horizontal scaling and fault tolerance
- Warning: Without load balancers, applications lack intelligent routing and risk single points of failure
```

## Backends Supported

Load balancers route traffic to various "employees" (backends). GCP supports diverse backends for different use cases.

### Supported Backends
- **Compute Engine**: VM instances in managed instance groups.
- **Kubernetes Engine**: Pods exposed via GKE services or ingress.
- **Cloud Run/Functions**: Serverless containers/functions.
- **App Engine**: Standard and flexible App Engine applications.
- **Cloud Storage**: Static content delivery.
- **External**: AWS S3, Azure Blob Storage via network endpoint groups.

### External Backend Use Case
Helicopter Racing League (from GCP PCA case study): Route /archive to old Azure Blob Storage on-premise; /live to new GCP Cloud Storage.

### Diagram: Traffic Flow
```mermaid
graph TD
A[Client Request] --> B[ISP Point of Presence]
B --> C[Cloud CDN (Optional)]
C --> D[Load Balancer]
D --> E[Network Endpoint Group]
E --> F{Zonal NEG}
F --> G[Instance Group]
E --> H[Regional Load Balancer to External Backend]
D --> I[Cloud Storage Bucket]
```
*The diagram shows how requests traverse through Google network to various backends, prioritizing proximity.*

### Key Insight
Network Endpoint Groups (NEGs) group backends for efficient load balancing:
- **Serverless NEG**: For Cloud Run, Functions, App Engine.
- **Zonal NEG**: For Compute Engine, GKE.
- **Internet NEG**: External backends.

```diff
+ Benefit: Multi-cloud support enables hybrid migrations
- Limitation: Not all backends support health checks (e.g., Cloud Storage)
```

## Internal vs External Load Balancers
Load balancers differ based on request origin: from internet (external) or GCP network (internal).

### External Load Balancer
- **Clients**: Public internet users (e.g., customers accessing web app).
- **Use Case**: Public-facing applications like e-commerce sites.
- **Diagram**: Client from California routes through global ALB to US-WEST1 MIG, then to middleware/database.

```mermaid
graph LR
A[User in California] --> B[Global External ALB]
B --> C[US-WEST1 MIG]
C --> D{Routing Logic}
D --> E[Middleware (ALB)]
E --> F[Database (NLB)]
```
*Diagram showing multi-tier routing with internal load balancers between tiers.*

### Internal Load Balancer
- **Clients**: Internal GCP resources (e.g., VM to database).
- **Use Case**: Microservice communication, security compliance.
- **Routing**: Regional or cross-region; uses RFC 1918 IPs.

### Key Concepts
- **Internal HTTP Load Balancer**: For microservice-to-microservice.
- **Internal TCP/UDP Load Balancer**: For database access (e.g., MySQL 3306).

```diff
+ Security: Internal restricts access to authorized GCP resources
- Complexity: Requires careful IP planning (RFC 1918 standard)
```

## Application Load Balancer vs Network Load Balancer
Application Load Balancers (ALB) handle layer 7 (HTTP/HTTPS); Network Load Balancers (NLB) handle layer 4 (TCP/UDP).

### ALB Characteristics
- **Protocol**: HTTP, HTTPS.
- **Routing**: Based on headers, cookies, URL paths.
- **Features**: SSL offloading, content-based routing.
- **Backends**: All types except databases.

### NLB Characteristics
- **Protocol**: TCP, UDP.
- **Routing**: Based on ports, IP.
- **Features**: Pass-through IP preservation.
- **Backends**: Limited (Compute Engine, GKE, external).

| Feature | ALB | NLB |
|---------|-----|-----|
| Layer | 7 | 4 |
| SSL Offload | Yes | Yes (SSL Proxy) / No (TCP) |
| Backends | All GCP services + external | Limited to compute + external |
| IP Preservation | No (proxy) | Yes (pass-through) |

```diff
+ ALB: Rich features for web applications
- NLB: Better for non-HTTP protocols (e.g., gaming, databases)
```

### Proxy vs Pass-Through
- **Proxy Load Balancer**: Terminates connection, changes IP address, enables encryption management.
- **Pass-Through Load Balancer**: Preserves client IP, no termination, required for IP-based logic.

## Global vs Regional Load Balancers
Global spans regions for worldwide distribution; Regional confines to one region.

### Global ALB
- **Benefits**: Low latency, multiple regions, automatic failover.
- **Pre-requisites**: Multiple regional backends.
- **Network Tier**: Premium by default.
- **Example**: Routes from Mumbai to nearest region (Mumbai if available, else Frankfurt).

### Regional ALB
- **Use Case**: Single-region applications, internal intra-region comms.
- **Internal Variant**: Cross-region possible but rare.

| Type | Scope | Backends |
|------|-------|----------|
| Global External ALB | Worldwide | Multi-region |
| Regional External ALB | One region | Single region |
| Regional Internal ALB | One region/cross-region | Single region/multiple regions |
| Regional Internal NLB | One region | Single region |

```diff
+ Global: Best for worldwide users with low latency requirements
- Regional: Sufficient for localized applications, simpler configuration
```

## Internal Application Load Balancer
Used for internal traffic (e.g., frontend to middleware).

### Configuration
- **Protocol**: HTTP (internal variant).
- **Backends**: Regional (e.g., US-WEST1 to other US-WEST1 resources).
- **Example**: Front-end MIG routes to middleware MIG via regional internal ALB.

### Advanced: Cross-Region Internal
Recently added; enables routing across regions for compliance.

## Health Checks
Ensure traffic routes only to healthy backends.

### When Needed
- **Instance Groups, Zooal NEGs, Private NEGs**
- **Not Needed**: Serverless NEGs, Internet NEGs, Backend Buckets.

### Configuration
- **Port**: Application port (e.g., 8080).
- **Path**: "/", "/health".
- **Protocol**: HTTP/S for ALB; TCP for NLB.

```diff
+ Purpose: Prevents routing to failing instances
- Warning: Health checks add overhead; avoid unnecessary ones
```

## SSL and Encryption
Load balancers handle encryption for security.

### SSL Offload
- **Concept**: Load balancer decrypts encrypted client requests, sends unencrypted to backends.
- **Benefits**: Reduces backend compute load.
- **Load Balancer Role**: Terminates SSL, enables end-to-end encryption if configured.

### End-to-End Encryption
- **Configuration**: Backend encryption enabled; load balancer adds overhead but secures internal traffic.

```diff
+ SSL Offload: Improves performance; security managed at edge
- Overhead: Encryption/decryption without offload burdens load balancer
```

## Lab Demo: Creating Load Balancers
Demonstrates creating global external ALB with Cloud Run backends and backend buckets.

### Step 1: Create Cloud Run Services
```bash
gcloud run deploy zone-printer --source . --platform managed --region us-central1 --allow-unauthenticated --set-env-vars ZONE=us-central1
gcloud run deploy zone-printer-london --source . --platform managed --region europe-west2 --allow-unauthenticated --set-env-vars ZONE=LONDON
```

### Step 2: Create Static Buckets for Multi-Region Routing (Lab Variation)
```bash
gsutil mb -c multi_regional gs://us-load-balancer-bucket
gsutil mb -c multi_regional gs://europe-load-balancer-bucket
gsutil mb -c multi_regional gs://asia-load-balancer-bucket
```

### Step 3: Upload and Organize Content
```bash
# Upload images to each bucket
gsutil cp served_from_us.png gs://us-load-balancer-bucket/static/
gsutil cp served_from_europe.png gs://europe-load-balancer-bucket/static/
```

### Step 4: Create Load Balancer via GCP Console
```bash
# Choose Application Load Balancer > Global > Public facing
# Backend: Serverless NEG (select Cloud Run services)
# Front-end: HTTP on port 80
# Routing: Basic (/* goes to backend service)
```

### Step 5: Test Proximity-Based Routing
- Access LB IP from different regions.
- Verify routing to closest backend.

### Step 6: Demonstrate Components
Use GCP Console > Load Balancing > Advanced Menu:
- **Forwarding Rules**: Show external IP and protocol.
- **Target Proxies**: HTTP proxy handling traffic.
- **URL Maps**: Routing rules.
- **Backend Services**: NEGs attached.
- **Certificates**: None (HTTPS variant uses certificates).

```diff
Demo: Created three Cloud Run zones and one load balancer; curl showed proximity routing
```

### Potential Issues
- Backend bucket routing requires VPC service control removal for demo (re-enable for production).
- Certificate creation for HTTPS requires managed certificates via GCP Certificate Manager.

```bash
# Create managed certificate
gcloud certificate-manager certificates create demo-cert --domains=myapp.example.com
```

## Advanced Topics: VPC Service Controls
Limits access to specified locations/regions for compliance.

### Configuration
- **Service Perimeter**: Define resources in perimeter.
- **Access Levels**: Geofencing (e.g., India only).
- **VPC Access Level**: Allow specific VPCs.

### Load Balancer Interaction
- Block requests from non-permitted regions.
- Example: Helicopter Racing League case study—restrict archive access to specific countries.

### Demo
Disabled VPC service controls for bucket routing demo; re-enabled with India/Geography restrictions.

```diff
+ Compliance: Enforces data residency
- Complexity: Requires perimeter planning; blocks cross-region access
```

## Command Line Creation
Create individual components for deeper understanding.

### Step 1: Create NEG
```bash
gcloud compute network-endpoint-groups create serverless-neg \
    --region=us-central1 \
    --network-endpoint-type=serverless \
    --cloud-run-service=zone-printer
```

### Step 2: Create Backend Service
```bash
gcloud compute backend-services create backend-service-cli \
    --global \
    --load-balancing-scheme=external-managed
```

### Step 3: Add NEG to Backend
```bash
gcloud compute backend-services add-backend backend-service-cli \
    --global \
    --network-endpoint-group=serverless-neg \
    --network-endpoint-group-region=us-central1
```

### Errors Encountered
- Global backend expects global NEG; use regional for serverless NEGs.
- Backend service region must match NEG region.

```diff
+ Learning: Component-by-component creation reveals dependencies
- Complexity: UI wizards hide individual steps; CLI exposes them
```

## Summary

### Key Takeaways
```diff
+ Load balancers are intelligent traffic managers routing based on health, proximity, and capacity
- Require multiple backends for global load balancing to be effective
! Global ALBs use premium network tier by default for edge routing
+ Internal ALBs route between GCP resources using RFC 1918 IPs
- SSL offload reduces backend load but adds LB overhead without dedicated systems
+ Proxy LBs change client IP; pass-through preserve it for logging/applications
+ Health checks crucial for ALBs with instance group backends but not for serverless
```

### Quick Reference
| Component | Purpose | Command |
|-----------|---------|---------|
| NEG | Groups backends | `gcloud compute network-endpoint-groups create` |
| Backend Service | Load balancing logic | `gcloud compute backend-services create` |
| Target Proxy | Traffic routing | `gcloud compute target-https-proxies create` |
| Forwarding Rule | External access | `gcloud compute forwarding-rules create` |

### Expert Insight
#### Real-World Application
In production, use global ALBs for web applications serving worldwide users, combining with CDN for static assets. Internal ALBs enable secure microservice communication in multi-tier apps, ensuring data stays within GCP network perimeter.
#### Expert Path
Master networking fundamentals (RFC 1918, BGP) before advanced load balancing. Practice TerraForm automation for component creation in production environments.
#### Common Pitfalls
- **Over-provisioning Regional LBs**: Use regional for cost savings unless global reach needed.
- **Forgetting Health Checks**: Unhealthy backends cause 5xx errors without proper checks.
- **SSL Misconfiguration**: Lack of end-to-end encryption exposes internal traffic.
#### Lesser-Known Facts
- Load balancer IPs are static by nature; "ephemeral" just means GCP assigns them.
- NLB pass-through mode is ideal for logging client IPs in applications requiring geo-based decisions.
#### Advantages and Disadvantages
+ **Advantages**: High availability, auto-scaling integration, global distribution without custom code.
- **Disadvantages**: Adds latency hop, premium tier requirements increase costs, complex debugging with multiple components.
