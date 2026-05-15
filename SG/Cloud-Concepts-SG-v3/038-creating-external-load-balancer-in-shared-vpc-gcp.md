# Session 38: Creating External Load Balancer in Shared VPC GCP

<details open>
<summary><b>038-Creating-External-Load-Balancer-in-Shared-VPC-GCP- (KK-CS45-script-v3)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Shared VPC Architecture](#shared-vpc-architecture)
- [External Load Balancer Fundamentals](#external-load-balancer-fundamentals)
- [Scenario 1: Load Balancer in Service Project](#scenario-1-load-balancer-in-service-project)
- [Scenario 2: Cross-Project Backend Services](#scenario-2-cross-project-backend-services)
- [Required IAM Permissions](#required-iam-permissions)
- [Lab Demo: Basic Shared VPC Load Balancer](#lab-demo-basic-shared-vpc-load-balancer)
- [Lab Demo: Cross-Project Implementation](#lab-demo-cross-project-implementation)
- [Summary](#summary)

## Overview

This session demonstrates how to create external load balancers in Google Cloud Platform (GCP) shared Virtual Private Cloud (VPC) environments. A shared VPC allows centralized network management across multiple projects, enabling efficient resource sharing while maintaining security boundaries.

The session covers two primary scenarios:
1. Creating a load balancer entirely within a single service project
2. Implementing cross-project backend services where load balancer components are distributed across different projects

## Shared VPC Architecture

### Key Concepts

**Shared VPC** is a centralized networking model in GCP that allows multiple projects to share a common VPC network. This architecture consists of:

- **Host Project**: Contains the main VPC network and all core networking infrastructure
- **Service Projects**: Utilize the shared VPC network from the host project without managing their own VPCs

#### Benefits of Shared VPC
- **Centralized Network Management**: Network administration is handled in one location
- **Cost Optimization**: Eliminates redundant VPC creation across projects
- **Resource Sharing**: Subnets, routes, and firewall rules can be shared
- **Security Control**: Network policies can be consistently applied

#### Attachment Process
Service projects must be explicitly attached to the host project before they can access shared VPC resources. This is done through the VPC Network Peering settings in the GCP Console or via CLI commands.

## External Load Balancer Fundamentals

External load balancers in GCP distribute traffic from external sources (typically the internet) across multiple backend instances or services. Key components include:

### Core Components
- **Frontend Configuration**: Defines how traffic enters the load balancer (IP address, ports, SSL certificates)
- **Backend Services**: Define how traffic is distributed to backend resources (instance groups, Cloud Run services, etc.)
- **Health Checks**: Monitor backend health and remove unhealthy instances from load balancing rotation
- **URL Maps**: Route traffic based on host/path rules for advanced load balancing scenarios

### Load Balancer Types
- **Global External HTTP(S) Load Balancer**: Distributes HTTP/HTTPS traffic globally using Google Cloud's global network
- **Regional External Load Balancer**: Handles TCP/UDP traffic within a specific region

## Scenario 1: Load Balancer in Service Project

In this scenario, all load balancer components (frontend configuration, backend services, forwarding rules) are created within a single service project that shares the VPC network from the host project.

### Architecture Overview

```
Host Project (Networking)
├── VPC Network (lb-network)
├── Subnets (shared with service projects)
└── Firewall Rules

Service Project A
├── Backend Services
├── Instance Groups
├── Load Balancer (External)
├── Forwarding Rules
└── Health Checks
```

### Key Characteristics
- **Simplified Permissions**: All resources in one project
- **Standard Configuration**: Uses GCP Console or standard gcloud commands
- **Local Backends Only**: Can only reference backends within the same project

## Scenario 2: Cross-Project Backend Services

This advanced scenario (currently in beta/preview) allows load balancer frontend components to be created in one project while backends reside in another project within the same shared VPC.

> [!NOTE]
> Cross-project backend services are currently in beta. Consider this experimental and not recommended for production environments until it reaches General Availability (GA).

### Architecture Overview

```
Host Project (Networking)
├── VPC Network (lb-network)
├── Subnets (shared)

Service Project A
├── Backend Services A
├── Instance Groups A
└── URL Maps (references backends from other projects)

Service Project B
└── Backend Services B
```

### Use Cases
- **Microservices Architecture**: Different teams manage their own services while sharing load balancing infrastructure
- **Application Teams vs Network Teams**: Network administrators handle load balancer configuration while application teams manage backends
- **Multi-Project Deployments**: Distribute application components across projects for better organization

## Required IAM Permissions

Cross-project backend services require specific IAM permissions beyond standard GCP roles.

### Key Role
**Compute Load Balancer Service User** (`roles/compute.loadBalancerServiceUser`)

This role provides permission to reference backend services from other projects. It must be assigned to:
- The user creating the frontend components (URL maps, target proxies, forwarding rules)
- Can be assigned at project level or individual backend service level

### Permission Assignment Options
- **Project Level**: User can reference all backend services in the project
- **Backend Service Level**: User can only reference specific backend services

## Lab Demo: Basic Shared VPC Load Balancer

### Prerequisites
- Host project with shared VPC configured
- Service project attached to shared VPC  
- Instance template created
- Instance group configured
- SSL certificate ready (for HTTPS)
- Reserved external IP address

### Step-by-Step Configuration

1. **Create Backend Service**
   ```
   # In GCP Console: Network Services → Load Balancing
   # Create load balancer → Start configuration
   Name: share-load-balancer-lb
   Select: Global external Application Load Balancer
   ```

2. **Configure Frontend**
   ```
   Protocol: HTTPS
   IP Address: [Select reserved external IP]
   Port: 443
   Certificate: [Select created SSL certificate]
   ```

3. **Create Backend Service**
   ```
   Name: lb-backend
   Backend type: Instance group
   Instance group: [Select created instance group]
   Port numbers: 80
   Balancing mode: Rate
   ```

4. **Health Check Configuration**
   ```
   Name: [Auto-generated or create new]
   Protocol: HTTP
   Port: 80
   Request path: /
   Healthy threshold: Default
   Unhealthy threshold: Default
   ```

5. **Firewall Rules**
   Ensure health checks can reach backends:
   ```
   Name: allow-health-checks
   Targets: Specified service account or network tags
   Source filters: Source IP ranges [GCP health check IPs]
   Protocols/Ports: tcp:80
   ```

6. **Routing Rules**
   ```
   Mode: Simple host and path rule
   Path: /*
   Backend: lb-backend
   ```

7. **Create Load Balancer**
   ```
   Review configuration and click "Create"
   ```

### Verification
- Access load balancer IP address
- Observe traffic distribution across instance group members
- Monitor health check status in console

## Lab Demo: Cross-Project Implementation

### Prerequisites
- Multiple service projects in shared VPC
- Backend services created in different projects
- Compute Load Balancer Service User role assigned
- Reserved external IP address in frontend project

### Step-by-Step Configuration

1. **Assign IAM Permissions**
   ```
   # From backend service project:
   Go to Instance Groups → lb-backend → Permissions
   Uncheck "Inherit permissions from parent"
   Add principal: [User creating frontend]
   Roles: Compute Load Balancer Service User
   ```

2. **Create URL Map (via Cloud Shell)**
   ```
   gcloud beta compute url-maps create cross-reference-url-map \
     --default-service=projects/[SERVICE-PROJECT-1]/global/backendServices/lb-backend \
     --global \
     --project=[FRONTEND-PROJECT]
   ```

3. **Create Target HTTPS Proxy**
   ```
   gcloud beta compute target-https-proxies create cross-reference-target-proxy \
     --url-map=cross-reference-url-map \
     --ssl-certificates=cross-reference-certificate \
     --global \
     --project=[FRONTEND-PROJECT]
   ```

4. **Create Forwarding Rule**
   ```
   gcloud beta compute forwarding-rules create cross-reference-forwarding-rule \
     --load-balancing-scheme=EXTERNAL_MANAGED \
     --target-https-proxy=cross-reference-target-proxy \
     --address=[RESERVED-IP] \
     --ports=443 \
     --global \
     --project=[FRONTEND-PROJECT]
   ```

### Advanced Routing (Export/Import Method)

1. **Export URL Map Configuration**
   ```
   gcloud beta compute url-maps export cross-reference-url-map \
     --destination=config.yaml \
     --project=[FRONTEND-PROJECT]
   ```

2. **Edit Configuration File**
   ```yaml
   defaultService: projects/[SERVICE-PROJECT-1]/global/backendServices/lb-backend
   hostRules:
   - hosts:
     - '*'
     pathMatcher: matcher1
   pathMatchers:
   - defaultService: projects/[SERVICE-PROJECT-1]/global/backendServices/lb-backend
     name: matcher1
     routeRules:
     - matchRules:
       - prefixMatch: /hello
       routeAction:
         weightedBackendServices:
         - backendService: projects/[MAIN-PROJECT]/global/backendServices/cloud-run-backend
           weight: 100
       - prefixMatch: /hello2
       routeAction:
         weightedBackendServices:
         - backendService: projects/[SERVICE-PROJECT-2]/global/backendServices/lb-backend-2
           weight: 100
   ```

3. **Validate Configuration**
   ```
   gcloud compute url-maps validate \
     --source=config.yaml \
     --load-balancing-scheme=EXTERNAL_MANAGED \
     --global
   ```

4. **Import Updated Configuration**
   ```
   gcloud beta compute url-maps import cross-reference-url-map \
     --source=config.yaml \
     --global \
     --project=[FRONTEND-PROJECT]
   ```

### Verification
- Test different paths:
  - `https://[LOADBALANCER-IP]/` → Routes to default service
  - `https://[LOADBALANCER-IP]/hello` → Routes to Cloud Run service
  - `https://[LOADBALANCER-IP]/hello2` → Routes to service project 2 backend

## Summary

### Key Takeaways

> [!IMPORTANT]
> External load balancers in shared VPC environments enable centralized network management while distributing traffic across multiple projects. Cross-project backend services offer architectural flexibility but require careful IAM permission management and are currently in beta.

```diff
+ Shared VPC centralizes network management across projects
+ Cross-project backends allow distributed application architectures
+ HTTPS load balancers require SSL certificates and reserved IPs
+ Health checks are critical for load balancer functionality
+ Beta features should be tested thoroughly before production use
```

### Quick Reference

| Component | GCP Console Path | CLI Command |
|-----------|------------------|-------------|
| Load Balancer | Network Services → Load Balancing | `gcloud compute forwarding-rules create` |
| Backend Service | Load Balancing → Backend Services | `gcloud compute backend-services create` |
| URL Map | Load Balancing → URL Maps | `gcloud compute url-maps create` |
| SSL Certificate | Security → Certificate Manager | `gcloud certificate-manager certificates create` |

**Key Commands:**
```bash
# Create URL Map (Beta)
gcloud beta compute url-maps create [NAME] --default-service=[BACKEND-SERVICE] --global --project=[PROJECT]

# Export URL Map Configuration  
gcloud beta compute url-maps export [NAME] --destination=config.yaml --project=[PROJECT]

# Import Updated URL Map
gcloud beta compute url-maps import [NAME] --source=config.yaml --global --project=[PROJECT]
```

### Expert Insight

#### Real-world Application
Production deployments often use shared VPC architectures where network teams manage infrastructure while application teams deploy services. Cross-project backends enable seamless integration across team boundaries, supporting microservices architectures and regulatory compliance requirements.

#### Expert Path
- Master gcloud CLI commands for automation and CI/CD integration
- Understand GCP load balancer pricing models and optimization techniques
- Learn advanced routing with URL maps for microservices traffic management
- Implement monitoring and alerting for load balancer health and performance

#### Common Pitfalls
- **Missing Health Check Firewall Rules**: Load balancers fail when health checks cannot reach backends
- **IAM Permission Gaps**: Cross-project configurations fail without proper role assignments
- **Certificate Management**: HTTPS load balancers require valid certificates matching domain names
- **Beta Feature Risks**: Avoid production use of experimental features until GA release
- **IP Address Reservation**: Dynamic IPs can cause service disruption if changed

</details>
