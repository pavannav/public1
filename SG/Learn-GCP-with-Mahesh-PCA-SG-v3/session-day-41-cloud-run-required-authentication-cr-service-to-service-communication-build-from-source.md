# Session 41: Cloud Run Required Authentication, CR Service to Service Communication, Build from Source

## Table of Contents
- [Cloud Run Two-Tier Application Refresh](#cloud-run-two-tier-application-refresh)
- [Required Authentication vs Allow Unauthenticated Invocation](#required-authentication-vs-allow-unauthenticated-invocation)
- [Service to Service Authentication](#service-to-service-authentication)
- [Inter-Cloud Run Service Communication](#inter-cloud-run-service-communication)
- [Global Load Balancing with Cloud Run](#global-load-balancing-with-cloud-run)
- [Build from Source (No Docker File Required)](#build-from-source-no-docker-file-required)
- [Cloud Run Drawbacks](#cloud-run-drawbacks)

## Cloud Run Two-Tier Application Refresh

### Architecture Overview
Discusses a two-tier application with:
- Frontend in Cloud Run
- Docker image deployment
- Environment variables configuration
- Connection to Cloud SQL instance
- **Dedicate service account principle** for Cloud Run services
- Use of Secret Manager instead of Kubernetes secrets

> [!IMPORTANT]
> Unlike Compute Engine and GKE (which default to Compute Engine default service account), Cloud Run also defaults to Compute Engine default service account but recommends dedicated service accounts for security.

## Required Authentication vs Allow Unauthenticated Invocation

### Authentication Concepts
- **Allow Unauthenticated Invocation**: External endpoints accessible to public (200 OK response)
- **Required Authentication**: Internal services requiring IAM authorization (403 Forbidden without token)

### Setting Required Authentication
```
# In Cloud Run UI: Security > Require Authentication
# IAM Rule Required: Cloud Run Invoker
# Permissions: run.routes.invoke
```

### Accessing Required Authentication Services
**Method 1: Bearer Token (from Cloud Shell/Browser)**
```bash
curl -H "Authorization: Bearer $(gcloud auth print-identity-token)" [SERVICE_URL]
```

**Method 2: Service Account Impersonation**
- Generate identity token via `gcloud auth print-identity-token`
- Pass as Authorization header
- Works for both humans and service accounts

> [!WARNING]
> Without proper authentication: HTTP 403 (Forbidden)
> With authentication: HTTP 200 (Success)

### Practical Demo Flow
1. Deploy Cloud Run service with **Required Authentication**
2. Attempt access without auth → 403 Forbidden
3. Generate bearer token → 200 Success
4. Role tested: Cloud Run Invoker at project/service level

## Service to Service Authentication

### Scenario: Compute Engine → Cloud Run
**Requirements:**
- Compute Engine VM with dedicated service account
- Service account granted Cloud Run Invoker role
- VM can access Cloud Run service via curl with identity token

**Key Points:**
- VMs and service accounts follow same authentication pattern
- Cross-project communication supported
- No VPC requirements from Cloud Run perspective

### Case Study: IVR System
- Cloud Run Functions used for IVR processing
- Cold start issues with minimum 0 instances
- Data loss during cold starts (prior to minimum instance feature)
- **Solution**: Migration from Cloud Run Functions to Cloud Run with minimum 1 instance

> [!NOTE]
> Cloud Run Functions: min=0 only (cold start issues)
> Cloud Run Services: min=0 to N (configurable)

## Inter-Cloud Run Service Communication

### Architecture Pattern
**Frontend Cloud Run Service:**
- Allow unauthenticated invocation (public access)
- Internal logic calls backend services
- Requires Cloud Run Invoker role for backend access

**Backend Cloud Run Services:**
- Required authentication (internal only)
- Dedicated service accounts for additional permissions

### Implementation Approaches

#### Approach 1: Manual Code Writing
```python
# main.py - Using requests and Google Auth
from flask import Flask
from google.auth import default
from google.oauth2 import service_account
from requests.auth import BearerTokenAuth
import requests

app = Flask(__name__)

BACKEND_URL = "https://backend-service-url"

@app.route('/')
def call_backend():
    creds, project = default()
    auth = BearerTokenAuth(creds.token)
    response = requests.get(BACKEND_URL, auth=auth)
    return f"Backend Response: {response.text}"
```

#### Approach 2: LLM-Assisted Generation
- Use ChatGPT, DeepSeek, or Gemini for code generation
- Prompt: Generate Python/Flask code to invoke Cloud Run service
- Iterate on generated code, test locally first
- Containerize and deploy

### Deployment Process
```bash
# 1. Write code (Python/Node.js with requirements.txt)
# 2. Create Dockerfile (EXPOSE 8080, use Gunicorn)
# 3. Build and push: docker build -t [IMG] && docker push [IMG]
# 4. Deploy: gcloud run deploy --image=[IMG] --service-account=[SA]
# 5. Grant invoker roles as needed
```

## Global Load Balancing with Cloud Run

### Implementation Steps
1. Deploy Cloud Run services in multiple regions (Mumbai, Singapore, London, US-Central)
2. Create Serverless Network Endpoint Groups for each region
3. Configure Load Balancer with global external IP
4. Test geo-routing from different locations

### Geo-Routing Behavior
**Expected:** Requests routed to nearest region based on latency
**Challenges Observed:**
- Load balancer may not failover to other regions if service down
- Routing logic considers network paths and peering agreements
- Submarine cable geography affects routing decisions

### Limitations Discovered
- Unlike MIG or GKE Multi-Cluster Ingress, Cloud Run load balancing may not automatically failover
- Requires further investigation for production reliability

## Build from Source (No Docker File Required)

### cloud-buildpacks Integration
**Cloud Run Deploy with Source:**
```bash
gcloud run deploy [SERVICE_NAME] --source=. --region=[REGION]
```

**How it Works:**
1. Detects language using buildpack detectors
2. Auto-generates Dockerfile
3. Builds container image using Cloud Build
4. Pushes to Artifact Registry
5. Deploys to Cloud Run

### Supported Languages/Versions
- Python: 3.7, 3.8, 3.9, 3.10, 3.11
- Node.js: 12, 14, 16, 18, 20
- Java: 8, 11, 17, 21
- Go: 1.16, 1.17, 1.18, 1.19, 1.20
- Ruby: 2.7, 3.0, 3.1, 3.2
- PHP: 7.4, 8.0, 8.1, 8.2
- .NET Core: 3.1, 6.0, 7.0

### Build Requirements
- `requirements.txt` (Python), `package.json` (Node.js), etc.
- Main application file (app.py, server.js, etc.)
- Exposed port 8080 (Cloud Run default)

### Limitations
- **Not all languages supported** (e.g., Perl unsupported)
- Detects based on file presence and structure
- Cloud Build service account permissions required
- Repository created automatically in specified region

### Demo Results
- Python/Flask app built and deployed in ~3 minutes
- No manual Docker image creation/push required
- Equivalent to: `docker build && docker push && gcloud run deploy`

## Cloud Run Drawbacks

### Stateless Workloads Only
> [!WARNING]
> Cannot run stateful workloads (e.g., cannot deploy MySQL databases)

### Cold Start Considerations
- Minimum instances = 0 → Cold starts occur
- Real-world impact: Customer data processing interruptions
- **Mitigation**: Set minimum instances = 1 (avoids cold starts, but increases cost)

### Service Account Requirements
- Mandatory service account assignment
- Unlike VMs requiring explicit service account usage
- Compute Engine default service account used by default

## Summary

### Key Takeaways
```diff
+ Professional microservice authentication using IAM
+ Cloud Run Invoker role enables secure service-to-service communication
+ Load balancing with serverless NEGs provides global distribution
+ Buildpacks enable source-to-deployment without Docker expertise
+ Dedicated service accounts prevent privilege escalation
+ Cold start mitigation via minimum instance configuration
- Load balancer failover behavior needs validation
- Supported languages limited to buildpack-compatible runtimes
```

### Quick Reference
**Authentication Commands:**
```bash
# Generate bearer token
curl -H "Authorization: Bearer $(gcloud auth print-identity-token)" [URL]

# Grant Cloud Run Invoker role
gcloud projects add-iam-policy-binding [PROJECT] \
  --member=serviceAccount:[SA]@[PROJECT].iam.gserviceaccount.com \
  --role=roles/run.invoker
```

**Deployment Commands:**
```bash
# Deploy from container image
gcloud run deploy [SERVICE] --image=[IMG] --service-account=[SA]

# Deploy from source (with buildpacks)
gcloud run deploy [SERVICE] --source=. --region=[REGION]
```

**Required IAM Permissions:**
- Cloud Run Invoker: `run.routes.invoke`
- Project-level for multi-service access

### Expert Insight

#### Real-World Application
- **Banking/Finance**: Multi-region deployments with geo-routing for compliance and latency optimization
- **E-commerce**: Frontend-backend separation with secure API communication
- **IVR Systems**: Stateful conversation handling with database integration
- **Data Processing**: Service chaining where one Cloud Run transforms data for another

#### Expert Path
Master Cloud IAM integration with Cloud Run for zero-trust architectures, implement tenant isolation using service accounts, and design observability patterns for distributed Cloud Run services using Cloud Monitoring and Cloud Logging.

#### Common Pitfalls
- **Default Service Account Usage**: Always use dedicated service accounts instead of Compute Engine default
- **Minimum Instance Configuration**: Balance cold start avoidance with cost containment
- **Distroless Base Images**: Leverage Google-provided base images for smaller attack surface
- **Secrets Management**: Use Secret Manager over environment variables for sensitive data

#### Lesser-Known Facts
- Cloud Run functions existed before Cloud Run services, with fewer features
- Buildpacks support enables "serverless software delivery" without container expertise
- Serverless NEGs don't perform automatic failover like zonal NEGs
- Cross-project service communication works seamlessly with IAM
- Cloud Run uses Google's global network for optimal routing decisions
