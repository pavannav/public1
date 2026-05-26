<details open>
<summary><b>Creating Multi-Regional External Load Balancer GCP (KK-CS45-script-v3)</b></summary>

# Creating Multi-Regional External Load Balancer GCP

## Table of Contents
- [Overview](#overview)
- [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
- [Lab Demo: Creating Multi-Regional Load Balancer](#lab-demo-creating-multi-regional-load-balancer)
- [GCP Resources Configuration](#gcp-resources-configuration)
- [Summary](#summary)

## Overview
This session demonstrates how to create a Google Cloud Platform (GCP) Application Load Balancer that provides multi-regional traffic distribution with path-based routing. The load balancer directs traffic based on URL paths and distributes requests across multiple regions (US Central and Europe West), ensuring users connect to the nearest instance group for optimal performance. The setup includes IPv4 and IPv6 support, with automatic failover capabilities when regions become unavailable.

## Key Concepts and Deep Dive

### Multi-Regional Load Balancing Architecture
Load balancing across multiple geographic regions provides high availability and improved performance by routing users to the closest data center. This reduces latency and provides automatic failover when a region experiences issues.

**Key Benefits:**
- Geographic proximity routing (users from Europe hit European instances, US users hit US instances)
- Automatic region failover when backends become unhealthy
- Path-based routing for different application services
- Support for both IPv4 and IPv6 traffic

### GCP Application Load Balancer Components

#### Target HTTPS Proxy
The target HTTPS proxy sits at the edge of GCP's network and performs the initial SSL/TLS termination. It forwards requests to URL maps for routing decisions.

#### URL Map
The URL map defines routing rules that direct traffic based on the request URL pattern:
- **Path matching**: Routes based on URL path (e.g., `/video/*`)
- **Host matching**: Routes based on domain name
- **Default routing**: Catches all unmatched traffic

#### Backend Services
Backend services define how traffic is distributed to instance groups:
- **Instance groups**: Collections of VM instances across regions
- **Health checks**: Automatic monitoring of backend health
- **Load balancing algorithm**: Round-robin distribution within healthy backends

#### Instance Groups
Managed instance groups provide:
- **Regional distribution**: Instances deployed across multiple zones within a region
- **Auto-scaling**: Automatic scaling based on demand
- **Rolling updates**: Zero-downtime updates during configuration changes

### Health Checks
Health checks ensure only healthy instances receive traffic:

```yaml
Protocol: HTTP
Port: 80
Request Path: /
Health Criteria:
  Check Interval: 5 seconds
  Timeout: 5 seconds
  Healthy Threshold: 2 consecutive successes
  Unhealthy Threshold: 2 consecutive failures
```

### IPv6 Support in GCP
GCP supports dual-stack (IPv4/IPv6) load balancing:

- **IPv6 subnet creation**: External IP range subnets for IPv6 traffic
- **Dual forwarding rules**: Separate rules for IPv4 and IPv6
- **DNS configuration**: AAAA records for IPv6 alongside A records for IPv4

> [!NOTE]
> IPv6 subnets can only have external IP ranges, not internal IP ranges. You cannot create both types simultaneously.

## Lab Demo: Creating Multi-Regional Load Balancer

### Prerequisites and Network Setup
1. **Create VPC Network and Subnets:**
   - Network name: `lb-network`
   - IPv4 subnets: `us-subnet` (US Central), `eu-subnet` (Europe West)
   - IPv6 subnet: `ipv6-test-subnet` with external IP range

2. **Configure Firewall Rules:**
   - Allow ingress traffic from GCP's load balancing IP ranges (130.211.0.0/22 and 35.191.0.0/16)
   - Protocol: TCP, Port: 80
   - Apply to all instances or use network tags

### Creating VM Infrastructure

#### Instance Template Configuration
```bash
# E2-small machine type for demo
gcloud compute instance-templates create video-eu-template \
  --machine-type=e2-small \
  --network=lb-network \
  --subnet=eu-subnet \
  --boot-disk-size=10GB \
  --image=debian-10-buster-v20210817 \
  --tags=http-server \
  --metadata=startup-script='#!/bin/bash
    apt-get update
    apt-get install -y apache2
    echo "Page served from $(hostname)" > /var/www/html/index.html
    systemctl start apache2'
```

#### Instance Groups Creation
```bash
# Create instance groups in both regions
gcloud compute instance-groups managed create ig-video-eu \
  --template=video-eu-template \
  --region=europe-west1 \
  --size=1

gcloud compute instance-groups managed create ig-video-us \
  --template=video-us-template \
  --region=us-central1 \
  --size=1
```

### Load Balancer Configuration

#### Step 1: Create Backend Services
```bash
# Create backend service for /video path
gcloud compute backend-services create video-backend-service \
  --load-balancing-scheme=EXTERNAL_MANAGED \
  --protocol=HTTP \
  --port-name=http \
  --health-checks=http-health-check \
  --global

# Add backend instance groups
gcloud compute backend-services add-backend video-backend-service \
  --instance-group=ig-video-us \
  --instance-group-region=us-central1 \
  --balancing-mode=UTILIZATION \
  --global

gcloud compute backend-services add-backend video-backend-service \
  --instance-group=ig-video-eu \
  --instance-group-region=europe-west1 \
  --balancing-mode=UTILIZATION \
  --global
```

#### Step 2: Create URL Map with Path-Based Routing
```bash
# Create URL map
gcloud compute url-maps create multi-regional-load-balancer \
  --default-service=www-backend-service \
  --global

# Add path matcher for /video/*
gcloud compute url-maps add-path-matcher multi-regional-load-balancer \
  --path-matcher-name=video-paths \
  --path-rules="/video=video-backend-service" \
  --default-service=www-backend-service \
  --global
```

#### Step 3: Configure Frontend (IPv4)
```bash
# Reserve static IPv4 address
gcloud compute addresses create lb-ipv4-address \
  --global \
  --ip-version=IPV4

# Create target HTTPS proxy
gcloud compute target-https-proxies create multi-regional-proxy \
  --url-map=multi-regional-load-balancer \
  --ssl-certificates=your-ssl-certificate \
  --global

# Create forwarding rule for IPv4
gcloud compute forwarding-rules create ipv4-forwarding-rule \
  --load-balancing-scheme=EXTERNAL_MANAGED \
  --target-https-proxy=multi-regional-proxy \
  --address=lb-ipv4-address \
  --ports=443 \
  --global
```

#### Step 4: Configure Frontend (IPv6)
```bash
# Reserve static IPv6 address
gcloud compute addresses create lb-ipv6-address \
  --global \
  --ip-version=IPV6

# Create forwarding rule for IPv6
gcloud compute forwarding-rules create ipv6-forwarding-rule \
  --load-balancing-scheme=EXTERNAL_MANAGED \
  --target-https-proxy=multi-regional-proxy \
  --address=lb-ipv6-address \
  --ports=443 \
  --global
```

### Testing Multi-Regional Functionality

#### Regional Traffic Routing
```bash
# Test from US-based VM (routes to US instance group)
curl -k https://your-domain.com/

# Test from EU-based VM (routes to EU instance group)  
curl -k https://your-domain.com/

# Test path-based routing
curl -k https://your-domain.com/video
```

#### Failover Testing
```bash
# Stop web server on one instance
sudo systemctl stop apache2

# Verify traffic routes to other region
curl -k https://your-domain.com/

# Restart service and verify traffic returns
sudo systemctl start apache2
```

## GCP Resources Configuration

| Component | Configuration | Purpose |
|-----------|---------------|---------|
| Instance Groups | US Central & Europe West | Regional distribution |
| Backend Services | HTTP on port 80 | Health checking and load balancing |
| Health Checks | 5s interval, 2 healthy/unhealthy threshold | Backend monitoring |
| URL Map | Path-based routing (/video, /*) | Traffic direction |
| Forwarding Rules | IPv4/IPv6 on port 443 | Protocol handling |
| SSL Certificates | Google-managed or self-managed | HTTPS encryption |

## Summary

### Key Takeaways
```diff
+ Multi-regional load balancers automatically route traffic to the nearest healthy region, reducing latency
+ Path-based routing enables different services within the same domain (e.g., /video for video content, / for web content)
+ GCP Application Load Balancers support both IPv4 and IPv6 simultaneously
+ Health checks ensure automatic failover when backends become unavailable
! Instance groups allow regional distribution but health checks must pass for traffic routing
- Instance groups must have valid firewall rules allowing health check traffic from GCP's IP ranges
- SSL certificates require proper domain verification with A and AAAA records for IPv4/IPv6 support
```

### Quick Reference
- **Load Balancer Type**: Application Load Balancer (HTTP/HTTPS)
- **Balancing Scheme**: EXTERNAL_MANAGED
- **Health Check IP Ranges**: 130.211.0.0/22, 35.191.0.0/16 (TCP port 80)
- **Path Routing**: URL maps with path matchers (`/video/*`)
- **IPv6 Setup**: Requires separate IPv6 subnet with external IP range

### Expert Insight

#### Real-world Application
Multi-regional load balancers excel in global applications requiring low latency and high availability. Consider implementing them for:
- Global e-commerce platforms serving content from regional data centers
- CDN-like architectures for static asset delivery
- Multi-cloud deployments spanning GCP regions and other providers
- Real-time applications needing sub-100ms response times

#### Expert Path
Master advanced configurations through:
- **CDN Integration**: Combine with Cloud CDN for edge caching
- **Security Policies**: Implement Cloud Armor for DDoS protection and WAF rules
- **Monitoring**: Set up Cloud Monitoring dashboards for traffic patterns and performance
- **Auto-scaling**: Configure managed instance group autoscaling based on CPU/memory metrics
- **Custom Routing**: Use URL redirects and rewrites for complex path transformations

#### Common Pitfalls
- **Firewall Configuration**: Health checks will fail without proper ingress rules from GCP's IP ranges
- **IPv6 DNS**: Load balancers fail to provision SSL certificates without AAAA records configured for IPv6 addresses
- **Instance Group Zones**: Ensure instance groups span multiple zones within each region for resilience
- **Startup Scripts**: Test startup scripts thoroughly as failures prevent instances from becoming healthy
- **Certificate Validation**: Use valid domain names for SSL certificates; self-signed certificates cause browser warnings</details>
