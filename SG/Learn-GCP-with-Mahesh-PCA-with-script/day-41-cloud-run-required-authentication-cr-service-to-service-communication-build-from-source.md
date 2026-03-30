# Session 41: Cloud Run Required Authentication, Service to Service Communication, Build from Source

## Overview

This session covers advanced Cloud Run features including authentication controls, secure microservice communication, global load balancing deployments, and source-based builds without Docker files.

## Required Authentication in Cloud Run

### Authentication Options

Cloud Run supports two authentication modes:

**Allow Unauthenticated Invocation**:
- Public services accessible to everyone
- External IP and clickable endpoints in GCP console
- Suitable for public-facing services

**Require Authentication**:
- Private services requiring authorized access
- No clickable endpoints; return 403 Forbidden without proper authentication
- Required for internal services and microservice communication

### Configuring Required Authentication

1. Set "Require authentication" during Cloud Run deployment
2. Service account assignment is mandatory (cannot be skipped)
3. Deploy with private access controls

Key differences from unauthenticated services:
- No clickable `run.app` domain links
- Must use authentication tokens or proper IAM roles

### Invoking Protected Cloud Run Services

#### Method 1: Authorization Bearer Tokens
```bash
curl -H "Authorization: Bearer $(gcloud auth print-identity-token)" \
     https://service-url.run.app
```

#### Method 2: Cloud Run Invoker IAM Role
**Required Role**: `roles/run.invoker`

**Assignment Levels**:
- Project-wide (invoke any Cloud Run service in project) 
- Service-specific (invoke only specified services)
- Granted to users or service accounts

> [!IMPORTANT]
> Unlike some GCP services, Cloud Run always requires a service account assignment for deployments.

### VM-to-Cloud Run Communication Example

**Scenario**: Compute Engine VM invoking a Cloud Run service

**Steps**:
1. Deploy Cloud Run service with required authentication
2. Create dedicated service account for VM
3. Grant service account `Cloud Run Invoker` role on target service
4. Create VM with dedicated service account
5. Test authenticated invocation

**Key Notes**:
- VM service account needs invoker permissions
- IAM role propagation takes several minutes
- Cross-project scenarios supported

## Microservice-to-Microservice Communication

### Architecture Patterns

Modern applications use layered microservice designs:
- **Public Services**: Frontends allowing unauthenticated access
- **Private Services**: Backends requiring authentication
- **Inter-Service Communication**: Secure API calls between services

### Communication Approaches

#### Frontend to Backend Pattern
Public frontend calls private backend using identity tokens.

**Implementation**:
```python
import requests
from google.auth.transport.requests import Request
from google.oauth2.id_token import fetch_id_token

def call_backend_service(service_url):
    # Generate authentication token
    token = fetch_id_token(Request(), service_url)

    # Make authenticated request
    headers = {'Authorization': f'Bearer {token}'}
    response = requests.get(service_url, headers=headers)
    return response.json()
```

#### Backend-to-Backend Pattern

Direct communication between internal services.

**Requirements**:
- Calling service needs `Cloud Run Invoker` role
- Target service must require authentication
- Communication stays within GCP network

**Real-world Scenarios**:
- Data processing pipelines calling Cloud Run APIs
- Dataproc clusters invoking Cloud Run services
- Cross-service data synchronization

## Global Load Balancing with Cloud Run

### Multi-Region Architecture

```
Global Load Balancer (L7)
├── Cloud Run Service (Asia South 1 - Mumbai)
├── Cloud Run Service (Europe West 2 - London)  
├── Cloud Run Service (Asia Southeast 1 - Singapore)
└── Cloud Run Service (US Central 1 - Iowa)
```

### Implementation Process

1. **Deploy Regional Services**:
   - Create identical Cloud Run services in target regions
   - Use consistent container images
   - Apply appropriate authentication settings

2. **Create Serverless NEGs**:
   - Backend type: "Serverless Network Endpoint Group"
   - Region-specific configuration
   - Select Cloud Run service for each NEG

3. **Configure Global Load Balancer**:
   - Layer 7 external load balancer
   - Add serverless NEG backends
   - Global external IP configuration

### Routing Logic

**Routing Decision Factors**:
- Geographic proximity and network latency
- Backend service availability
- Regional capacity utilization
- Latency-optimized path selection

**Regional Routing Observations**:
- Bangalore users → Mumbai (closest region)
- Singapore users → Singapore (regional colocation)
- US users → US Central (local region)
- Doha users → Variable based on network path optimizations

### Recommended Practices

- Monitor regional performance metrics
- Account for network topology in architecture
- Implement multi-region deployments for global apps
- Apply appropriate security controls (critical for network services)

## Build from Source with Cloud Build Packs

### Functionality Description

Cloud Build Packs enable Cloud Run deployments from source code without requiring containerization steps.

**Benefits**:
- Automated container generation
- Simplified deployment workflow
- Background Cloud Build integration

### Supported Language Versions

Cloud Build Packs support specific runtimes:

| Language | Versions |
|----------|----------|
| Python | 3.8, 3.9, 3.10, 3.11 |
| Node.js | 14, 16, 18, 20 |
| Java | 8, 11, 17 |
| Go | 1.16, 1.17, 1.18, 1.19, 1.20 |
| Ruby | 2.7, 3.0, 3.1 |
| PHP | 8.0, 8.1, 8.2 |
| .NET Core | 3.1, 6.0 |

> [!NOTE]
> Runtime support is limited to listed languages and versions. Manual Docker files required for unsupported technologies.

### Deployment Methods

#### Traditional Container Approach
```bash
# Manual process
docker build -t app:v1 .
docker push gcr.io/project/app:v1
gcloud run deploy service-name --image=gcr.io/project/app:v1
```

#### Cloud Build Packs Approach
```bash
# Single command deployment
gcloud run deploy service-name \
  --source . \
  --platform managed \
  --region us-central1
```

**Automated Workflow**:
1. Detect language/runtime from source code
2. Generate Dockerfile using Cloud Build Packs
3. Build container image
4. Push to Artifact Registry
5. Deploy to Cloud Run

### Permissions and Prerequisites

**Required Permissions**:
- Cloud Run deployment access
- Cloud Build Editor role
- Cloud Storage access for artifacts

**Generated Resources**:
- `cloud-run-source-build-[region]` repository
- Container images with version mapping
- Cloud Build execution history

### Usage Example

```bash
# Deploy Python application
gcloud run deploy my-python-app \
  --source . \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated
```

### Constraints and Restrictions

**Unsupported Technologies**:
- Perl, other languages outside support matrix
- Custom runtimes without Cloud Build Pack support
- Older language versions not listed

**Common Failure Causes**:
- Language detection issues in build packs
- Unsupported dependency configurations
- Build timeout limits

### Implementation Best Practices

1. **Code Preparation**:
   - Ensure runtime version compatibility
   - Include proper dependency files (`requirements.txt`, `package.json`)
   - Structure code for Cloud Build Pack expectations

2. **Permissions Setup**:
   - Configure Cloud Build service account permissions
   - Enable required APIs (Artifact Registry)
   - Assign appropriate IAM roles

3. **Operational Management**:
   - Monitor Cloud Build logs for issues
   - Track Artifact Registry storage usage
   - Validate build outputs pre-production

4. **Migration Approach**:
   - Test with simple applications first
   - Verify outputs before production deployment
   - Use manual Docker files for complex requirements

## Cloud Run Limitations

### Core Constraints

> [!IMPORTANT]
> **Stateless Workloads Only**: Cloud Run supports only stateless applications without persistent storage capabilities.

### Unsupported Use Cases

**Data Persistence Requirements**:
- Relational databases (MySQL, PostgreSQL)
- NoSQL databases (MongoDB)
- Stateful applications needing mutable data

**Service Comparison**:

| Service | Stateful Workloads | Cold Start Issues | Scaling Behavior |
|---------|-------------------|-------------------|-----------------|
| Cloud Run | ❌ (Stateless) | Yes (with min instances config) | Auto (0-max) |
| Compute Engine | ✅ (Persistent disks) | No | Manual autoscaling |
| Kubernetes Engine | ✅ (Multiple storage types) | No | HPA configured |

### Real-World Business Impact

**Migration Example: IVR System**
Business moved from Cloud Run to Compute Engine for:
- Critical data persistence needs (customer input capture)
- Eliminating cold start delays on user interactions
- Guaranteeing service availability for business operations

### Stateless Architecture Solutions

**External Data Management**:
- **Cloud SQL**: Relational database layer
- **Cloud Storage**: Object and file persistence
- **Memorystore**: In-memory data caching
- **Event-Driven Design**: Stateless processing with external state

## Summary

### Key Takeaways

```diff
+ Cloud Run supports public (unauthenticated) and private (authenticated) services
+ Secure service-to-service communication via proper IAM roles and authentication
+ Multi-region deployments with smart latency-based load balancing routing
+ Cloud Build Packs automate deployment for supported runtimes
- Cloud Run limited to stateless workloads without persistent data support
- Cloud Build Packs have restricted language/runtime support matrix
! Service account assignment mandatory for all Cloud Run deployments
! Geographic routing follows network infrastructure, not straight-line distance
```

### Expert Insights

**Real-World Application**:
Cloud Run with required authentication is perfect for microservice architectures needing:
- Public frontend services with external access
- Private backend services with controlled access
- Secure inter-service communication protocols
- Global deployment with low-latency regional routing

**Expert Path**:
- Master Cloud Run IAM roles (Invoker, Developer, Admin permissions)
- Advanced service account impersonation techniques
- Cloud Build advanced configuration and optimization
- Multi-region deployment and load balancing design patterns
- Cloud Run Jobs exploration (different from services)

**Common Pitfalls**:
1. **Missing Service Accounts**: Silent deployment failures without proper identity configuration
2. **IAM Propagation Delays**: 5-10 minute delays for new role activation
3. **Unsupported Runtimes**: Deployment failures with languages outside Cloud Build Pack support
4. **Cold Start Problems**: Default zero minimum instances causing response delays
5. **Network Topology Misunderstandings**: Geographic routing following fiber paths rather than physical distance

**Lesser-Known Facts**:
- Cloud Run services support direct custom domain assignment
- Identity tokens require periodic refresh handling
- Inter-service calls bypass external network security constraints
- Load balancer health checks support custom configurations
- Environment variable integration with Secret Manager supported

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
