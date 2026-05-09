# Session 40: Custom Runtime App Engine Flex & Cloud Run Concepts

## Table of Contents
- [App Engine Flexible Environment Concepts](#app-engine-flexible-environment-concepts)
  - [Minimum Instance Configuration](#minimum-instance-configuration)
  - [Custom Runtime with Docker](#custom-runtime-with-docker)
  - [Scaling Behavior](#scaling-behavior)
  - [Real-world Application Insights](#real-world-application-insights)
- [Introduction to Cloud Run](#introduction-to-cloud-run)
  - [Merging Flex and Standard Concepts](#merging-flex-and-standard-concepts)
  - [Core Characteristics](#core-characteristics)
- [Getting Started with Cloud Run Deployments](#getting-started-with-cloud-run-deployments)
  - [Deploying Existing Container Images](#deploying-existing-container-images)
  - [Traffic Splitting](#traffic-splitting)
  - [Command Line Traffic Management](#command-line-traffic-management)
- [Environment Variables and Secrets Management](#environment-variables-and-secrets-management)
  - [Plain Text Environment Variables](#plain-text-environment-variables)
  - [Integrating Secret Manager](#integrating-secret-manager)
- [Two-Tier Application with Cloud Run and Cloud SQL](#two-tier-application-with-cloud-run-and-cloud-sql)
  - [Building and Deploying Custom Images](#building-and-deploying-custom-images)
  - [Connecting to Cloud SQL](#connecting-to-cloud-sql)

## App Engine Flexible Environment Concepts

### Minimum Instance Configuration
The App Engine Flexible Environment supports a minimum of one instance to prevent cold starts, unlike the Standard Environment which can scale to zero. This ensures consistent performance for applications needing constant availability.

Key points:
- Default setup includes two instances, leading to potential unnecessary costs if traffic is low.
- Users can configure it to one minimum instance to balance cost and availability.
- Scaling down to zero is not possible, increasing operational costs for idle applications.

### Custom Runtime with Docker
Unlike the Standard Environment with fixed runtimes (e.g., Node.js, Python), Flexible allows custom runtimes using Docker containers. This enables support for technologies like Perl, offering flexibility but requiring more setup.

Process for deploying a custom runtime:
1. Create a `Dockerfile` to containerize the application.
2. Build and deploy via `gcloud app deploy`.
3. Example with Perl:
   ```
   # Example Dockerfile for Perl app
   FROM perl:latest
   COPY . /app/
   WORKDIR /app/
   EXPOSE 8080
   CMD ["perl", "app.pl"]
   ```

### Scaling Behavior
Scaling in Flexible Environment:
- Auto-scaling based on CPU usage, request rate, etc.
- Slower scaling compared to Standard due to container provisioning (5+ minutes for initial deployment).
- Manual scaling options available.
- Scaling up/down to zero is not supported, unlike Standard.

Pros/Cons of minimum instance requirement:
```diff
+ No cold starts, ensuring always-on availability
- forbids scaling to zero, incurring costs during idle periods
```

### Real-world Application Insights
Flexible is suitable for web applications requiring reliability over cost, such as quiet websites with burst traffic. Standard is better for low-traffic scenarios. Demonstrations showed deployment latency (5+ minutes) and scaling delays.

## Introduction to Cloud Run

### Merging Flex and Standard Concepts
Cloud Run combines the best of App Engine Standard (scale-to-zero, instant scaling) and Flex (flexible runtimes via containers) while improving speed and regional flexibility. It addresses weaknesses like slow deployments and limited runtimes.

Comparison:
| Feature | Standard | Flex | Cloud Run |
|---------|----------|------|-----------|
| Scale to zero | ✅ | ❌ | ✅ |
| Flexible runtimes | ❌ | ✅ | ✅ |
| Regional choice | ❌ (us-central1) | ❌ (us-central1) | ✅ |
| Deployment speed | ~90s | ~5min | ~30-70s |

### Core Characteristics
- Serverless, containerized web applications.
- Stateless workloads preferred; stateful data (e.g., carts) should use external storage like Cloud SQL.
- Supports any containerized app running on HTTP/HTTPS.
- Based on Knative (open-source) for portability.

## Getting Started with Cloud Run Deployments

### Deploying Existing Container Images
Leverage container images from Artifact Registry for quick deployment. Steps:
1. Select image from registry.
2. Create service specifying region and auth settings.
3. Works instantly with same artifacts from App Engine demos.

Demo with Node.js image from Standard Environment:
- Image source: `us.gcr.io/project/nodejs-app:latest`
- Command: `gcloud run deploy --image=us.gcr.io/project/nodejs-app:latest --region=us-central1 --allow-unauthenticated`
- Endpoint: `https://service-name-uid-uc.run.app`

> [!NOTE]
> Cloud Run endpoints differ from App Engine (run.app vs. appspot.com).

### Traffic Splitting
Enable A/B testing or canary deployments by splitting traffic between revisions.

UI Method:
1. Create multiple revisions.
2. Use "Traffic" tab to assign percentages (e.g., 80% v2, 20% v3).
3. Random distribution (not cookie/IP-based).

Command Line via `gcloud run services update-traffic`:
```bash
gcloud run services update-traffic service-name --to-traffic=v2=80%,v3=20% --region=us-central1
```

Demo: Split traffic for Node.js versions (15 vs 23), observing random toggling.

### Command Line Traffic Management
Advanced splitting in CLI:
- Export traffic percentage as environment variable.
- Update traffic to simulate 50% split.

Example:
```bash
export TRAFFIC_PERCENTAGE=50
gcloud run services update-traffic hello-nodejs --to-traffic v2=50% --region=us-central1
```

> [!WARNING]
> Traffic splitting in Cloud Run is always random, unlike App Engine's options.

## Environment Variables and Secrets Management

### Plain Text Environment Variables
UI supports direct environment variables:
- Non-sensitive values (e.g., DB name, port) via "Variables" tab.
- Exposed as runtime environment vars.

Example for 2-tier app:
```yaml
env:
- name: DB_HOST
  value: db-instance-ip
- name: DB_USER
  value: root
```

### Integrating Secret Manager
For sensitive data (passwords), use Secret Manager over plain text env vars.

Steps:
1. Store secrets in Secret Manager (e.g., DB password as key-value).
2. Reference in Cloud Run under "Secrets exposed as env variables".
3. Use compute service account with Secret Accessor role (`roles/secretmanager.secretAccessor`).

Example:
- Create secret: `my-db-password` with value.
- Reference: Secret="my-db-password", Version="latest".
- Service account: Custom SA (not compute default) with necessary IAM roles.

Benefits:
- Secrets not visible in UI/deployment history.
- Rotate secrets: Update Secret Manager version; new containers reflect automatically.

> [!IMPORTANT]
> Always use custom service accounts for production folks; default compute SA lacks permissions.

## Two-Tier Application with Cloud Run and Cloud SQL

### Building and Deploying Custom Images
For PHP + MySQL app:
1. Clone repo and build container: `docker build -t us-central1-docker.pkg.dev/project/cloud-run-php/php-app:v1 .`
2. Push: `docker push us-central1-docker.pkg.dev/project/cloud-run-php/php-app:v1`
3. Deploy: `gcloud run deploy --image=us-central1-docker.pkg.dev/project/cloud-run-php/php-app:v1 --set-env-vars DB_HOST=sql-ip,DB_USER=root,DB_PASS=secret --region=us-central1 --allow-unauthenticated`

Handle ports: Apache/MariaDB on 80, expose 8080 for Cloud Run.

### Connecting to Cloud SQL
- Public IP: Whitelist ranges (e.g., 34.0.0.0/8, 35.192.0.0/14 for learning).
- Better: Private IP (covered in networking module).
- View connections via `select * from information_schema.processlist` in MySQL.

Demo: Deployed app connected successfully via whitelisted IPs and secrets.

## Summary

### Key Takeaways
```diff
+ Cloud Run merges App Engine Standard and Flex strengths for serverless, fast, flexible deployments
- Flexible Environment tradeoff: Reliability vs. cost due to no scale-to-zero
! Custom runtimes require Docker; plan for slower scaling/deployment in Flex
```

### Quick Reference
- Flexible min instances: `gcloud app instances delete <instance-id>` to release costs.
- Custom runtime deploy: `gcloud app deploy --image=<container>` with Dockerfile.
- Cloud Run deploy: `gcloud run deploy --image=<gcr-image> --region=<region> --allow-unauthenticated`
- Traffic split: `gcloud run services update-traffic --to-traffic=v1=80%,v2=20%`
- Secret Manager: Create secrets, reference in Cloud Run with custom SA for access.

### Expert Insight

#### Real-world Application
Use Cloud Run for event-driven web apps (e.g., APIs, frontends) needing instant scale. Combine with Cloud SQL for stateful backends, leveraging secrets for security. App Engine Flex suits complex, containerized apps with steady traffic.

#### Expert Path
Master Knative/Kubernetes service meshes for advanced Cloud Run integrations. Study IAM for secrets and CORS for multi-service architectures. Experiment with Cloud Build for CI/CD pipelines integrating container builds/deployments.

#### Common Pitfalls
- Using Flex with low traffic: Costs accrue from min instances—switch to Standard or Cloud Run.
- Exposing secrets as plain env vars: Always use Secret Manager; default SA lacks access.
- Ignoring regional constraints: Cloud Run enables global deployments; App Engine is limited.
- Database connections: Public IPs risky; aim for private VPC connections.

#### Lesser-Known Facts
Cloud Run services map to internal Kubernetes deployments via Knative, enabling portability to other K8s platforms. Traffic splitting defaults to random for simplicity, but advanced routing needs external load balancers.

#### Advantages and disadvantages
Advantages:
- Fast scaling (milliseconds) and deployments (seconds).
- Runtime flexibility via containers, regional options.
- Built-in HTTP handling, IAM auth.

Disadvantages:
- Stateless only; externalize state.
- Scaling delays in heavy loads vs. pre-warmed instances.
- Limited to web-focused, containerized apps.
