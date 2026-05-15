<details open>
<summary><b>Session 041: Creating Regional Internal Application Load Balancer GCP (KK-CS45-script-v3)</b></summary>

# Session 041: Creating Regional Internal Application Load Balancer GCP

## Table of Contents
- [Overview](#overview)
- [Internal Application Load Balancer Fundamentals](#internal-application-load-balancer-fundamentals)
- [Regional vs Cross-Region Internal ALBs](#regional-vs-cross-region-internal-albs)
- [Architecture and Components](#architecture-and-components)
- [Proxy-Only Subnets](#proxy-only-subnets)
- [Firewall Configuration Requirements](#firewall-configuration-requirements)
- [Global Access Feature](#global-access-feature)
- [VPC Peering for Cross-Network Access](#vpc-peering-for-cross-network-access)
- [Load Balancer Creation Lab Demo](#load-balancer-creation-lab-demo)
- [Proxy Subnet Failover Lab Demo](#proxy-subnet-failover-lab-demo)
- [Summary](#summary)

## Overview

This session covers Google's Regional Internal Application Load Balancer (ALB), focusing on its proxy-based Layer 7 implementation that enables scaling and distributed access to internal services. The focus is solely on regional deployments accessible within a single GCP region, with detailed coverage of critical infrastructure components like proxy-only subnets and required firewall rules. The instructor demonstrates complete setup processes and explores advanced scenarios including global access and cross-network connectivity through VPC peering.

## Internal Application Load Balancer Fundamentals

### Key Characteristics
An internal application load balancer operates as a **proxy-based Layer 7 load balancing solution** that distributes traffic to backend services exclusively within internal networks. Unlike external load balancers, it maintains complete isolation from internet-facing connections, utilizing `10.128.0.0/20` style internal IP addresses rather than external public IPs.

### Core Use Cases and Requirements
The primary implementation scenarios require backends within a single region when IPv4 termination is necessary. The solution supports premium network service tier configurations and maintains compatibility with TCP ports 80 and 443. The infrastructure enables seamless service scaling behind a persistent internal IP address while enforcing strict security boundaries.

### Feature Limitations
The internal ALB imposes specific functional constraints including:
- Incompatibility with Cloud CDN and Cloud Armor services
- Exclusion of Cloud Storage backend bucket configurations
- Mandatory use of self-managed SSL certificates instead of Google's managed certificates
- Exclusive IPv4 support without IPv6 termination capabilities

## Regional vs Cross-Region Internal ALBs

### Regional Internal ALB Characteristics
Regional deployments confine traffic distribution and backend accessibility to a single GCP region. This architectural approach ensures compliance requirements specific to regional data sovereignty while maintaining lower latency through localized traffic flows. The deployment mode remains regional in scope, though global access features enable cross-regional client connectivity.

```
graph TD
    A[Client in Region A] --> B[Regional Internal ALB]
    B --> C[Backend Service in Region A]
    D[Client in Region B] --> E[Cross-Region Access Disabled]
    F[Backend Service in Region B] --> E
```

### Cross-Region ALB Preview Features
The preview cross-region variant distributes traffic to globally distributed backends, automatically routing requests to geographically proximate endpoints. This advanced configuration enables enhanced high availability and reduced latency through intelligent traffic distribution algorithms. The instructor specifically defers detailed coverage of this preview feature to subsequent sessions.

## Architecture and Components

### Traffic Flow Architecture

```
graph TD
    A[Client Request] --> B[Forwarding Rule<br/>Regional Internal IP]
    B --> C[TCP Proxy]
    C --> D[URL Map]
    D --> E[Backend Service]
    E --> F[Instance Groups<br/>Hybrid/Neg Endpoints]
    
    G[Global Firewall Rules] -.-> E
    H[Health Check] -.-> E
```

The architecture implements a sophisticated proxy mechanism where client connections terminate at the forwarding rule's internal IP address. The TCP proxy establishes new connections to backend services, leveraging URL mapping for intelligent request routing. Instance groups serve as primary backend targets, with hybrid and Network Endpoint Groups (NEGs) providing additional flexibility for diverse infrastructure deployments.

### Essential Infrastructure Components
Successful implementation requires comprehensive infrastructure setup including VPC networks, regional health checks, and mandatory proxy-only subnets. Global firewall rules ensure load balancer health monitoring capabilities, while backend services maintain connection pools and load distribution logic.

## Proxy-Only Subnets

### Purpose and Implementation
Proxy-only subnets represent dedicated Google-managed IP ranges that facilitate outbound connections from load balancer proxies to backend services. These specialized subnets serve as connection origination points, replacing direct client-to-backend traffic with mediated proxy connections.

### Regional Constraints and Management
Each proxy-only subnet exists within a specific region and VPC network combination. Multiple regional internal ALBs within the same region and VPC share a common proxy-only subnet pool, eliminating the need for individual subnet allocations. These subnets remain exclusively reserved for proxy operations and cannot accommodate VM or endpoint deployments.

### Active-Backup Configurations
The platform supports active-backup subnet hierarchies where primary subnets handle current traffic while secondary subnets maintain readiness for failover scenarios. Activation processes involve immediate traffic redirection to new subnets while existing connections undergo gradual drainage based on configured timeout parameters.

## Firewall Configuration Requirements

### Proxy-to-Backend Traffic Rules
Ingress firewall rules must explicitly permit traffic from proxy-only subnet ranges to backend services. These rules typically target the application's service port (commonly port 80 for HTTP services) and apply to all instances within the configured network scope.

### Health Check Traffic Rules  
Global firewall rules enable load balancer health monitoring capabilities, allowing the load balancer to conduct periodic backend health assessments. These rules must accommodate health check probe traffic across the specified protocol and port configurations.

### Configuration Criticality
The firewall configuration represents a fundamental operational requirement - improperly configured rules will prevent traffic flow despite correctly configured load balancers. The instructor emphasizes that firewall rule creation should precede any configuration changes to prevent service disruption.

## Global Access Feature

### Functionality Overview
Global access extends regional internal ALB accessibility beyond their native region, enabling client connections from geographically distributed locations. This feature maintains the internal load balancer's regional backend constraint while removing regional access restrictions.

### Implementation Process
Enabling global access requires recreating the frontend configuration - direct editing remains unavailable after initial deployment. The process involves:
1. Deleting existing frontend IP configurations
2. Recreating configurations with global access enabled
3. Retaining reserved internal IP addresses for consistency

### Security and Routing Implications
While global access broadens connectivity scope, it maintains the core internal security model. Traffic routing continues through the proxy infrastructure, ensuring backend isolation and security policy enforcement.

## VPC Peering for Cross-Network Access

### Network Interconnection Strategy
VPC peering enables cross-network connectivity within the same region, allowing clients in peered networks to access regional internal ALBs. This approach maintains traffic isolation while enabling necessary cross-network communication patterns.

### Implementation Requirements
Bidirectional peering connections must be established between connecting VPC networks. Peering enables network-level connectivity while preserving security boundaries and routing isolation between the interconnected networks.

```
graph TD
    subgraph "VPC Network A (LB Network)"
        A[Internal ALB] --> B[Proxy Subnet]
        B --> C[Backend Instances]
    end
    
    subgraph "VPC Network B (Client Network)"
        D[Client VM] --> E[VPC Peer Connection]
    end
    
    E --> F[VPC Peer Connection]
    F --> A
```

## Load Balancer Creation Lab Demo

### Prerequisites Setup
1. **Instance Group Configuration**: Create regional instance groups with backend VMs running target applications on configured ports

2. **Network Infrastructure**: Establish VPC networks with appropriate subnet configurations for load balancer and backend service isolation

3. **Proxy-Only Subnet Creation**:
   - Navigate to VPC network → Subnets → Add subnet
   - Configure regional proxy-only subnet with dedicated IP range
   - Set purpose to "Regional managed proxy"

### Backend Service Configuration
1. **Service Creation**: Initialize regional backend service with descriptive naming
2. **Backend Addition**: Select instance groups as backend targets
3. **Health Check Integration**: Attach or create regional health checks specifying appropriate protocols and ports

### Frontend Configuration Process
1. **Network Selection**: Choose target VPC network and regional proxy-only subnet
2. **IP Address Assignment**: Configure static internal IP addresses within selected subnet ranges
3. **Security Configuration**: Apply global access settings based on multi-region access requirements

### Validation and Testing
Conduct comprehensive connectivity testing across different network segments and regional boundaries. Verify both successful traffic routing and expected failure scenarios in unauthorized network zones.

## Proxy Subnet Failover Lab Demo

### Failover Scenario Configuration
1. **Secondary Subnet Creation**: Establish backup proxy-only subnets with distinct IP ranges
2. **Failover Process**: Activate secondary subnets while configuring drainage timeouts
3. **Traffic Transition**: Monitor automatic connection migration from active to backup subnets

### Operational Maintenance
1. **Firewall Rule Updates**: Modify ingress rules to accommodate new proxy subnet ranges
2. **Downtime Prevention**: Implement firewall changes before subnet activation to maintain service continuity
3. **Resource Cleanup**: Remove exhausted proxy subnets after successful migrations

## Summary

### Key Takeaways

```diff
+ Regional internal ALBs enable Layer 7 load balancing for internal services within single GCP regions
+ Proxy-only subnets are mandatory and must be created per-region with dedicated IP ranges
+ Firewall rules allowing proxy subnet traffic to backends are critical for functionality
+ Global access enables cross-region client connectivity while maintaining regional backends
+ VPC peering facilitates cross-network access within the same region
+ Active-backup proxy subnet configurations support zero-downtime subnet management
- Cannot use Cloud CDN, Cloud Armor, or Cloud Storage backend buckets with internal ALBs
- Must bring your own SSL certificates as managed certificates are not supported
- IPv6 termination is not available - IPv4 only deployment
```

### Quick Reference

**Proxy-Only Subnet Creation:**
```bash
# Via GCP Console: VPC Networks → Subnets → Add subnet
# Purpose: "Regional managed proxy"
# Regional scope: One subnet per region
```

**Firewall Rules Template:**
```bash
# Ingress rule for proxy-to-backend traffic
Source ranges: [proxy-only-subnet-range]
Target: Backend instance groups
Ports: [service-port]
Protocol: TCP
```

**Supported Backend Types:**
- Instance Groups (regional)
- Hybrid endpoints
- Network Endpoint Groups (NEGs)
- External backends (Azure/AWS) - future enhancement

### Expert Insight

**Real-world Application:**
Regional internal ALBs excel in enterprise microservices architectures where services require internal-only accessibility with sophisticated routing capabilities. Use cases include API gateways serving internal applications, containerized service meshes, and hybrid cloud deployments with strict compliance boundaries. The global access feature enables global client bases to connect to region-specific services without public internet exposure.

**Expert Path:**
Master proxy subnet management by implementing automated subnet rotation scripts that maintain active-backup configurations. Study health check configurations deeply, as they directly impact load distribution efficiency. Learn advanced URL mapping for complex routing scenarios, and familiarize yourself with backend service configuration options for optimal performance tuning.

**Common Pitfalls:**
Never deploy without proxy-to-backend firewall rules - this causes complete service unavailability. Avoid modifying proxy subnets without pre-configuring firewall rules for the new ranges, as this introduces downtime. Remember that instance groups and load balancers must reside in the same region for regional ALBs. Don't confuse global access with cross-region backends - the feature only affects client accessibility, not backend distribution.

</details>
