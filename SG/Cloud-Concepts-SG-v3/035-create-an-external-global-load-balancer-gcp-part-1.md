# Session 035: Creating an External Global Load Balancer in GCP - Part 1

<details open>
<summary><b>Creating an External Global Load Balancer in GCP - Part 1 (KK-CS45-script-v3)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts](#key-concepts)
  - [Introduction to Load Balancers](#introduction-to-load-balancers)
  - [Types of Load Balancers in GCP](#types-of-load-balancers-in-gcp)
  - [External vs Internal Load Balancers](#external-vs-internal-load-balancers)
  - [Global vs Regional Load Balancers](#global-vs-regional-load-balancers)
  - [Features of External Global Load Balancer](#features-of-external-global-load-balancer)
  - [Load Balancer Architecture](#load-balancer-architecture)
- [Lab Demo: Creating an External Global Load Balancer](#lab-demo-creating-an-external-global-load-balancer)
- [Summary](#summary)

## Overview
This session focuses on creating an External Global Load Balancer in Google Cloud Platform (GCP). It covers the fundamental concepts of load balancing, different types available in GCP, and provides hands-on demonstration for setting up an external global load balancer including SSL certificates, backend services, health checks, and routing configuration.

## Key Concepts

### Introduction to Load Balancers
A load balancer distributes incoming network traffic across multiple servers (backends) to ensure efficient resource utilization and high availability. It prevents any single server from becoming overwhelmed by requests.

```diff
+ Key Purpose: Distribute traffic across multiple backend instances to ensure:
  - High availability
  - Scalability 
  - Fault tolerance
  - Optimal resource utilization
```

### Types of Load Balancers in GCP
GCP provides different types of load balancers based on:
- Layer (Layer 7 vs Layer 4)
- Scope (Global vs Regional)
- Traffic type (External vs Internal)

**Supported Load Balancers:**
- **External HTTP(S) Load Balancer** (Global)
- **External TCP/UDP Network Load Balancer** (Global/Regional)
- **Internal TCP/UDP Load Balancer** (Regional)
- **Internal HTTP(S) Load Balancer** (Regional)

### External vs Internal Load Balancers
External load balancers handle traffic coming from the internet, while internal load balancers manage traffic within a VPC network.

> [!IMPORTANT]
> External load balancers route internet traffic to your applications. Internal load balancers are used for traffic routing within your organization's VPC.

### Global vs Regional Load Balancers
Global load balancers distribute traffic across regions worldwide, providing global reach with a single IP address.

**Regional Load Balancers:**
- Operates within a specific region
- Supports regional VPC traffic
- Lower latency for local traffic

```diff
+ Global Load Balancer Benefits:
  - Single Anycast IP address worldwide
  - Automatic failover across regions  
  - Intelligent traffic routing based on proximity
  - Handles worldwide internet traffic efficiently
```

### Features of External Global Load Balancer
The External Global Load Balancer provides enterprise-grade features:

- **Single Anycast IP**: One IP address globally reachable
- **Software-Defined**: No physical hardware management required
- **HTTP/HTTPS Support**: Layer 7 load balancing with advanced routing
- **SSL/TLS Termination**: Managed SSL certificates
- **CDN Integration**: Optional integration with Cloud CDN
- **Health Checks**: Automatic backend health monitoring
- **URL Maps and Routing Rules**: Advanced routing based on paths/hosts

### Load Balancer Architecture
The architecture consists of several components working together:

```
graph TD
    A[Global Forwarding Rule] --> B{SSL Certificate}
    B --> C[URL Map]
    C --> D[Backend Service]
    D --> E[Backend Instances/Groups]
    D --> F[Health Checks]
    
    H[User Traffic] --> A
```

**Key Components:**
1. **Global Forwarding Rule**: Defines the IP and protocol
2. **Target Proxy**: Handles SSL termination (for HTTPS)
3. **URL Map**: Routes requests to appropriate backend services
4. **Backend Service**: Defines how to distribute traffic across backends
5. **Health Checks**: Monitor backend instance health

## Lab Demo: Creating an External Global Load Balancer

### Prerequisites
- GCP Project with billing enabled
- VM instances with serving application (Apache/NGINX)
- Instance groups configured (unmanaged instance groups in this demo)

### Step-by-Step Creation Process

#### Step 1: Access Load Balancer Configuration
1. Navigate to **Network Services > Load balancing**
2. Click **Create load balancer**
3. Select **HTTP(S) Load Balancing** (Global external)
4. Choose **Global external Application Load Balancer**

#### Step 2: Configure Frontend
```bash
# Frontend Configuration
Name: external-global-lb-demo
Network Tier: Premium (required for global)
IP Version: IPv4
IP Address: Create new static IP
Protocol: HTTPS (recommended)
Port: 443
```
- **SSL Certificate**: Provide managed certificate or upload custom
- **Security Policy**: Apply optional security configurations

> [!NOTE]
> Use managed SSL certificates for automatic renewal or upload custom certificates for full control.

#### Step 3: Configure Backend Services
1. Create Backend Service:
   ```bash
   # Backend Service Settings  
   Name: web-backend-service
   Protocol: HTTP (terminate SSL at load balancer)
   Named Port: http (ensure VMs use port 80)
   ```

2. **Health Checks Configuration**:
   ```bash
   # Health Check Parameters
   Protocol: HTTP
   Port: 80
   Request Path: /health (create simple health check endpoint)
   Healthy Threshold: 2 consecutive successes
   Unhealthy Threshold: 2 consecutive failures  
   Check Interval: 5 seconds
   Timeout: 5 seconds
   ```

   > [!TIP]
   > Always create and attach health checks to ensure traffic is only sent to healthy backends.

3. **Backend Configuration**:
   - Select instance groups or serverless backends
   - Set balancing mode (CPU utilization or request-based)
   - Configure session affinity if needed

#### Step 4: Configure URL Map and Routing
1. Create URL Map:
   ```bash
   # Host and Path Rules
   Host: example.com
   Path: /video/* -> backend-service-a
   Path: /blog/* -> backend-service-b
   Default Route: web-backend-service
   ```

#### Step 5: Create Firewall Rules
```bash
# Firewall Rules for Health Checks
# Allow health check traffic from GCP
gcloud compute firewall-rules create allow-health-check \
  --allow tcp:80 \
  --source-ranges 130.211.0.0/22,35.191.0.0/16 \
  --description "Allow GCP health checks"
```

#### Step 6: SSL Certificate Setup  
```bash
# Managed SSL Certificate
gcloud compute ssl-certificates create example-com \
  --certificate example-com.crt \
  --private-key example-com.key \
  --global
```

#### Step 7: Test Load Balancer
1. Update DNS to point to load balancer IP
2. Test health checks and traffic distribution
3. Verify SSL certificate validity

### Common Backend Types
- **Instance Groups**: Managed/unmanaged VM groups
- **Cloud Storage Buckets**: Static content hosting
- **Serverless Backends**: Cloud Functions, Cloud Run
- **Private Services**: Using VPC Service Controls

## Summary

> [!WARNING]
> Without health checks, the load balancer cannot verify backend instance health and may route traffic to unhealthy servers.

### Key Takeaways
```diff
+ External Global Load Balancers ensure global reach with a single IP address
+ HTTPS with SSL termination provides secure traffic handling  
+ URL-based routing enables advanced traffic management
+ Health checks are critical for maintaining service availability
+ Premium network tier is required for global load balancing
- Always create comprehensive firewall rules allowing health check traffic
- Configure proper backend timeouts and session handling
- Plan DNS updates before completing load balancer setup
```

### Quick Reference

**Common Configuration Commands:**
```bash
# Create health check
gcloud compute health-checks create http hc-web \
  --port 80 \
  --request-path="/health"

# Create backend service  
gcloud compute backend-services create web-backend \
  --protocol HTTP \
  --health-checks hc-web \
  --global

# Create URL map
gcloud compute url-maps create web-url-map \
  --default-service web-backend

# Create target proxy
gcloud compute target-http-proxies create web-proxy \
  --url-map web-url-map
```

**Frontend Configuration Table:**

| Component | Setting | Purpose |
|-----------|---------|---------|
| IP Address | Static Global IP | Single point of access worldwide |
| Protocol | HTTPS | Secure traffic encryption |
| Network Tier | Premium | Global routing capability |
| SSL Certificate | Managed | Automatic certificate renewal |

### Expert Insight

**Real-world Application**: In production environments, external global load balancers are essential for serving worldwide customers with minimal latency. They're commonly used for:
- Web applications serving global traffic
- API gateways requiring advanced routing
- Content delivery with CDN integration
- Multi-region disaster recovery scenarios

**Expert Path**: Master certificate management, advanced routing rules, and integration with Cloud Monitoring for comprehensive observability. Learn to optimize costs through proper capacity planning and understand cross-region failover behavior.

**Common Pitfalls**: 
- Forgetting to allow health check IPs in firewall rules
- Incorrect SSL certificate domain validation
- Not configuring proper timeouts for long-running requests  
- Ignoring network tier requirements for global load balancers

</details>
