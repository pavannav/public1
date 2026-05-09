# Session 39: Google App Engine Overview

## Table of Contents
- [Overview](#overview)
- [Introduction to Serverless Computing](#introduction-to-serverless-computing)
- [App Engine Fundamentals](#app-engine-fundamentals)
- [Standard Environment](#standard-environment)
- [Flexible Environment](#flexible-environment)
- [Scaling and Cost Management](#scaling-and-cost-management)
- [Traffic Management](#traffic-management)
- [Deploying Applications](#deploying-applications)
- [Multi-service Architecture](#multi-service-architecture)
- [Demonstration: Node.js Deployment](#demonstration-nodejs-deployment)

## Overview

Google App Engine (GAE) is Google's original Platform as a Service (PaaS) offering, launched in 2008 as their first cloud product. It represents Google's pioneering entry into serverless computing, allowing developers to deploy web applications without managing underlying infrastructure. While deprecated for new applications in favor of Cloud Run, App Engine remains relevant for maintaining legacy deployments and understanding serverless evolution.

### Key Characteristics
- **Managed Platform**: Handles all infrastructure operations automatically
- **Source Code Focus**: Deploy code directly; Google manages scaling, patching, and maintenance
- **Two Environments**: Standard (constrained but highly scalable) and Flexible (more flexible but less optimized)

## Introduction to Serverless Computing

Serverless is a cloud computing model where the cloud provider fully manages infrastructure. This allows developers to focus entirely on application code rather than system administration.

> [!IMPORTANT]
> Serverless != No Servers
> Servers exist but are abstracted away from developers. The term "serverless" is primarily a marketing concept meaning "don't manage servers."

### Advantages of Serverless
- **Reduced Operational Burden**: No patching, upgrading, or monitoring infrastructure
- **Focus on Business Logic**: 100% focus on application development
- **Automatic Scalability**: Scaling handled automatically by platform
- **Cost Efficiency**: Platform scales to zero when idle, driving costs to zero

### Disadvantages of Serverless
- **Vendor Lock-in**: Cloud native solutions tied to specific providers
- **Black Box Nature**: Less control over underlying infrastructure
- **Learning Curve**: Requires understanding platform-specific deployment patterns

### Serverless Options in Google Cloud

| Service | Use Case | Infrastructure Visibility |
|---------|----------|---------------------------|
| App Engine | Web applications/microservices | Invisible |
| Cloud Run | Containerized applications | Invisible |
| Cloud Functions | Event-driven functions | Invisible |
| Cloud Storage | Object storage | Invisible |
| BigQuery | Data warehousing | Invisible |
| Cloud SQL | Relational databases | Managed instance level |

## App Engine Fundamentals

App Engine serves as the counterpart to AWS Elastic Beanstalk and Azure App Service. It's designed for stateless web applications and microservices that can trigger via HTTP endpoints.

### When to Use App Engine
- Small to medium web applications
- Microservices architectures
- Applications with variable traffic patterns
- Rapid prototyping and development
- Legacy applications requiring migration

### When NOT to Use App Engine
- **Stateful Applications**: Databases, message queues, or data processing pipelines
- **Custom Infrastructure Requirements**: Need for specific VM types or network configurations
- **High Performance Computing**: GPU-intensive applications requiring specialized hardware

### Core Architecture Hierarchy

```
App Engine App
├── Service/Microservice 1
│   ├── Version 1 (Active)
│   ├── Version 2 (Beta)
│   └── Version 3 (Development)
├── Service/Microservice 2
│   └── Version 1 (Active)
└── Service/Microservice 3
    └── Version 1 (Active)
```

## Standard Environment

The Standard Environment provides Google's most optimized serverless experience with strict controls for maximum scalability and cost efficiency.

### Key Features
- **Zero to Hero Scaling**: Can scale from 0 to thousands of instances in seconds
- **Automatic Shutdown**: Scales to zero when idle, incurring zero costs
- **Instance Classes**: Predefined configurations optimized for specific workloads

### Supported Runtimes and Constraints

| Language/Runtime | Supported Versions | Notes |
|------------------|-------------------|-------|
| Python | Specific versions only | No custom runtimes |
| Node.js | LTS versions | No .NET support |
| Go | Specific versions | Ruby, Java, PHP also supported |
| Java | LTS versions | Custom frameworks allowed |
| .NET | ❌ Not supported | Must use Flexible Environment |

### Instance Classes

| Class | CPU | Memory | Use Case |
|-------|-----|--------|----------|
| F1 | 0.6 GHz | 128 MB | Low traffic apps |
| F2 | 1.2 GHz | 256 MB | Medium traffic apps |
| F4 | 2.4 GHz | 512 MB | High traffic apps |
| B1 | Variable | Variable | Background processing |

! Client Request → Load Balancer → App Engine Standard → Auto-scaled Instances

```
graph TD
    A[HTTP Request] --> B[Global Load Balancer]
    B --> C[App Engine Standard Environment]
    C --> D[Instance Pool]
    D --> E[Scale to Zero]
    D --> F[Scale to N Instances]
```

## Flexible Environment

The Flexible Environment provides more control while still maintaining serverless benefits. It runs applications in Docker containers within managed Compute Engine VMs.

### Key Features
- **Docker Container Support**: Runs any containerized application
- **VM Visibility**: Access to underlying Compute Engine instances via SSH
- **Network Integration**: Requires VPC configuration
- **Persistent Storage**: Can attach persistent disks

### Runtime Flexibility

| Capability | Standard | Flexible |
|------------|----------|----------|
| Runtime Versions | Fixed LTS versions | Any version |
| Languages | Limited set | Any language/framework |
| Scaling to Zero | ✅ Yes | ❌ Minimum 1 instance |
| Deployment Time | ~90 seconds | ~10 minutes |
| Custom Dependencies | ❌ Limited | ✅ Full support |
| Networking | ✅ Serverless VPC | ✅ Standard VPC |

> [!WARNING]
> Flexible Environment deployments can take significantly longer than Standard Environment deployments. Use Standard Environment whenever runtime constraints allow.

### Use Cases for Flexible Environment
- Applications requiring custom runtime versions
- Legacy applications written in unsupported languages
- Applications needing persistent file systems
- Applications requiring SSH access for debugging
- Containerized workloads (though Cloud Run is preferred)

## Scaling and Cost Management

### Automatic Scaling in Standard Environment

```
graph LR
    A[No Traffic] --> B[0 Instances = $0.00]
    A --> C[Traffic Detected]
    C --> D[1 Instance Spins Up]
    D --> E[Horizontal Pod Autoscaling Equivalent]
    E --> F[N Instances Based on Load]
    F --> G[Limited by Max Instances Setting]
```

### Key Scaling Concepts
- **Minimum Instances**: Can be set to 0 in Standard Environment
- **Maximum Instances**: Configurable to prevent cost overruns
- **Idle Timeout**: Configurable scaling-down behavior

### Firewall Rules
App Engine provides built-in firewall capabilities for access control:

```bash
# Deny specific IP ranges
gcloud app firewall-rules create RULE_NAME \
  --action deny \
  --source-range 192.168.1.0/24 \
  --description "Block development subnet"

# Allow with priority (lower number = higher priority)
gcloud app firewall-rules create allow-admin \
  --action allow \
  --source-range ADMIN_IP \
  --priority 100
```

## Traffic Management

### Version Management
Each deployment creates a new version with unique URL patterns:

```
Format: https://{service}-{version}-dot-{project-id}.appspot.com
Example: https://default-v2-dot-myproject.appspot.com
```

### Traffic Splitting Strategies

#### A/B Testing
```bash
# Route 50% traffic to version-a, 50% to version-b randomly
gcloud app services set-traffic default \
  --splits version-a=0.5,version-b=0.5 \
  --split-by random
```

#### Canary Deployments
```bash
# Send 10% traffic to new version, 90% to stable version
gcloud app services set-traffic default \
  --splits v1=0.9,v2=0.1 \
  --split-by random
```

#### IP-Based Splitting
```bash
# Route traffic based on client IP for regional testing
gcloud app services set-traffic default \
  --splits stable=0.95,beta=0.05 \
  --split-by ip
```

### Traffic Migration
```bash
# Gradually migrate all traffic to new version
gcloud app services set-traffic default --splits v2=1.0

# Rollback if issues detected
gcloud app services set-traffic default --splits v1=1.0
```

## Deploying Applications

### Deployment Prerequisites
1. **Service Account**: App Engine default service account or custom
2. **IAM Roles**: Appropriate permissions for Cloud Build and Storage
3. **Network**: Flexible Environment requires VPC
4. **App.yaml**: Configuration file specifying runtime and settings

### Basic Deployment Commands

```bash
# Standard Environment deployment
gcloud app deploy --no-promote  # Deploy without serving traffic
gcloud app deploy               # Deploy and promote to serving traffic

# Version-specific deployment
gcloud app deploy --version v1

# Service-specific deployment (multi-service apps)
gcloud app deploy --service frontend
```

### Required Files

#### app.yaml (Standard Environment)
```yaml
runtime: nodejs20
env: standard

# Optional scaling configuration
automatic_scaling:
  min_instances: 0
  max_instances: 10
  
# Environment variables
env_variables:
  NODE_ENV: production
```

#### app.yaml (Flexible Environment)
```yaml
runtime: nodejs
env: flex

# Network configuration (required)
network:
  name: default

# Manual scaling for cost control
manual_scaling:
  instances: 1

# Optional: custom runtime version
runtime_config:
  nodejs_version: 20
```

#### package.json (Node.js example)
```json
{
  "name": "my-app",
  "version": "1.0.0",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.18.0"
  },
  "engines": {
    "node": ">=20.0.0"
  }
}
```

## Multi-service Architecture

### Service Communication
```javascript
// Frontend service calling backend service
const backendUrl = `https://${process.env.BACKEND_SERVICE}-dot-${process.env.PROJECT_ID}.appspot.com`

fetch(`${backendUrl}/api/data`)
  .then(response => response.json())
  .then(data => console.log(data))
```

### Service Configuration
```yaml
# app.yaml for frontend service (default)
runtime: nodejs20
service: default  # Optional: service defaults to 'default'

# app.yaml for backend service
runtime: nodejs20
service: backend
```

### Environment Variable Setup
```yaml
env_variables:
  BACKEND_SERVICE: backend
  PROJECT_ID: my-gcp-project
```

## Demonstration: Node.js Deployment

### Step 1: Environment Setup
```bash
# Enable App Engine API
gcloud services enable appengine.googleapis.com

# Configure region (permanent decision)
gcloud app create --region=us-east4

# Create custom service account
gcloud iam service-accounts create gae-deployer \
  --description="App Engine Deployment Service Account"

# Grant necessary roles
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="serviceAccount:gae-deployer@PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/appengine.deployer"

gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="serviceAccount:gae-deployer@PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/storage.admin"
```

### Step 2: Application Code

#### server.js
```javascript
const express = require('express');
const app = express();

app.get('/', (req, res) => {
  res.json({
    message: 'Hello from App Engine!',
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || 'development'
  });
});

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
```

#### app.yaml
```yaml
runtime: nodejs20
env: standard
service: default

automatic_scaling:
  min_instances: 0
  max_instances: 10
  
handlers:
- url: /.*
  script: auto
```

#### package.json
```json
{
  "name": "gae-demo",
  "version": "1.0.0",
  "description": "App Engine Standard Demo",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.18.0"
  },
  "engines": {
    "node": ">=20.0.0"
  }
}
```

### Step 3: Deployment
```bash
# Deploy application
gcloud app deploy

# Check deployment status
gcloud app instances list

# View application URL
gcloud app describe | grep defaultHostname

# Access application
curl https://PROJECT_ID.appspot.com
```

### Step 4: Version Management
```bash
# Deploy new version without promoting
gcloud app deploy --version v2 --no-promote

# Split traffic (80/20 canary deployment)
gcloud app services set-traffic default \
  --splits v1=0.8,v2=0.2 \
  --split-by random

# Monitor traffic distribution
gcloud app services describe default

# Full migration to new version
gcloud app services set-traffic default --splits v2=1.0
```

### Step 5: Scaling Verification
```bash
# Generate load to trigger autoscaling
for i in {1..100}; do
  curl https://PROJECT_ID.appspot.com &
done

# Monitor instance count
watch gcloud app instances list

# Observe automatic scaling behavior
gcloud app logs read
```

## Summary

### Key Takeaways
```diff
+ App Engine pioneered serverless computing in GCP
+ Two environments: Standard (optimized) vs Flexible (flexible)
+ Standard Environment scales to zero; Flexible requires minimum 1 instance
+ Traffic splitting enables canary deployments and A/B testing
+ Multi-service architecture supports microservices patterns
+ Region selection is permanent and cannot be changed later
+ Firewall rules provide basic access control
+ Deployment focuses on code, not infrastructure management
```

### Quick Reference

#### Important Commands
```bash
# Basic deployment
gcloud app deploy

# Version management
gcloud app versions list
gcloud app services set-traffic SERVICE --splits VERSION1=0.5,VERSION2=0.5

# Instance monitoring
gcloud app instances list

# Logs and debugging
gcloud app logs read
gcloud app firewall-rules list
```

#### URL Patterns
- Default app: `https://PROJECT-ID.appspot.com`
- Specific version: `https://SERVICE-VERSION-dot-PROJECT-ID.appspot.com`
- Logs viewer: `https://console.cloud.google.com/appengine/logs`

### Expert Insight

#### Real-world Application
App Engine remains valuable for:
- **Legacy Application Migrations**: Migrating from on-premises to cloud
- **Rapid Prototyping**: Quick deployment of proof-of-concepts
- **Microservices Backends**: API endpoints for mobile/web applications  
- **Traffic Pattern Analysis**: Using traffic splitting for feature testing

#### Expert Path
Master App Engine by:
1. Understanding YAML configuration options deeply
2. Learning traffic management patterns for deployment strategies
3. Exploring integration with other GCP services via serverless VPC access
4. Migrating Standard Environment apps to Cloud Run for modern deployments

#### Common Pitfalls
```diff
- Choosing Flexible Environment unnecessarily (slower deployments, higher costs)
- Selecting wrong region (permanent decision)
- Insufficient service account permissions during deployment
- Missing VPC configuration for Flexible Environment
- Not implementing traffic splitting for production deployments
```

#### Lesser-Known Facts
- App Engine URLs ending in `.appspot.com` indicate managed deployments
- Standard Environment uses Google-managed containers (invisible to users)
- Flexible Environment VMs are actually Compute Engine instances with SSH access
- The original App Engine (2008) predates Cloud Run by over a decade
- Traffic splitting can use IP-based routing for geographic testing

### Advantages
- **Zero Infrastructure Management**: Complete abstraction of servers
- **Instant Global Scaling**: Worldwide distribution without configuration
- **Automatic Load Balancing**: Built-in global load balancing
- **Cost Efficiency**: Scales to zero when idle
- **Version Management**: Easy rollback and testing capabilities

### Disadvantages
- **Vendor Lock-in**: Difficult migration to other cloud providers  
- **Limited Runtime Choice**: Standard Environment restricts language versions
- **Permanent Region Selection**: Cannot change region after initial deployment
- **Debugging Challenges**: Less visibility into underlying infrastructure
- **Deployment Time**: Flexible Environment deployments can take 10+ minutes
