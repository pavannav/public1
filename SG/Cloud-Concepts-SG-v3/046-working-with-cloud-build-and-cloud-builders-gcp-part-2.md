# Session 46: Working with Cloud Build and Cloud Builders GCP Part 2

<details open>
<summary><b>Working with Cloud Build and Cloud Builders GCP Part 2 (KK-CS45-script-v3)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Cloud Builders Overview](#cloud-builders-overview)
  - [Types of Cloud Builders](#types-of-cloud-builders)
  - [Pre-built Cloud Builders](#pre-built-cloud-builders)
  - [Community Contributed Builders](#community-contributed-builders)
  - [Custom Builders](#custom-builders)
- [Using Community Contributed Builders](#using-community-contributed-builders)
  - [Building Images from Source](#building-images-from-source)
  - [Example: GitHub Builder](#example-github-builder)
- [Docker Image Authentication and Registry Integration](#docker-image-authentication-and-registry-integration)
  - [Storing Credentials in Secret Manager](#storing-credentials-in-secret-manager)
  - [Granting Permissions to Cloud Build Service Account](#granting-permissions-to-cloud-build-service-account)
  - [Pulling and Pushing Images from External Registries](#pulling-and-pushing-images-from-external-registries)
- [Lab Demo: Pushing Image to Docker Hub](#lab-demo-pushing-image-to-docker-hub)
  - [Creating Cloud Build Configuration](#creating-cloud-build-configuration)
  - [Dockerfile Creation](#dockerfile-creation)
  - [Executing the Build](#executing-the-build)
- [Summary](#summary)
  - [Key Takeaways](#key-takeaways)
  - [Quick Reference](#quick-reference)
  - [Expert Insight](#expert-insight)

## Overview
This session provides an in-depth exploration of Cloud Builders in Google Cloud Build, focusing on extending the platform's capabilities beyond pre-built options. The session covers community-contributed builders, custom image creation, and integration with external container registries like Docker Hub. Practical demonstrations show how to authenticate with external services using Secret Manager and execute builds that interact with Docker registries.

## Cloud Builders Overview

### Types of Cloud Builders
Cloud Builders are containerized tools that extend Cloud Build's functionality for specialized tasks. They provide pre-configured environments with specific tooling installed, enabling complex build, deployment, and automation processes.

### Pre-built Cloud Builders
Google maintains an official set of pre-built Cloud Builders that cover common use cases:
- `bzl`: Bazel build tool
- `docker`: Docker CLI operations
- `gcloud`: Google Cloud SDK
- `git`: Version control operations
- `kubectl`: Kubernetes cluster management
- `gradle`, `maven`: Java build tools
- Additional specialized builders for various development workflows

These pre-built builders are readily available and cover most standard CI/CD requirements.

### Community Contributed Builders
Beyond Google's official builders, the developer community contributes open-source builders hosted on GitHub. These builders provide solutions for specific tools and frameworks not covered by pre-built options, such as:
- `docker-compose`: Multi-container application orchestration
- `packer`: Machine image creation
- `helm`: Kubernetes package management
- `github-actions`: Integration with GitHub's CI/CD platform
- Additional specialized builders for niche technologies

Community builders exist as source code repositories containing Docker configurations and Cloud Build YAML files, requiring users to build the container images before use.

### Custom Builders
For scenarios where neither pre-built nor community builders meet specific requirements, custom builders offer complete flexibility. Custom builders involve:
- Creating proprietary container images with specialized tooling
- Building images containing custom scripts, dependencies, or configurations
- Storing images in supported registries (Google Container Registry, Artifact Registry, or external registries)
- Referencing images in Cloud Build configurations for task execution

## Using Community Contributed Builders

### Building Images from Source
Community contributed builders require a multi-step process to become usable:

1. Clone the builder's source repository from GitHub
2. Navigate to the specific builder's directory
3. Review the included `cloudbuild.yaml` and `Dockerfile`
4. Execute `gcloud builds submit` to build and push the image
5. Store the resulting image in a container registry
6. Reference the custom image in subsequent Cloud Build configurations

### Example: GitHub Builder
The GitHub community builder demonstrates the typical structure:

```yaml
# cloudbuild.yaml content
steps:
- name: 'gcr.io/cloud-builders/docker'
  args: ['build', '-t', 'gcr.io/$PROJECT_ID/github:tag', '.']
- name: 'gcr.io/cloud-builders/docker'
  args: ['push', 'gcr.io/$PROJECT_ID/github:tag']
```

This configuration builds a Docker image using the provided Dockerfile, then pushes the image to Google Container Registry with a specific tag.

The Dockerfile typically uses a base image (like Ubuntu) and installs required CLI tools or runtime environments, configuring entrypoints and executable permissions for the builder's functionality.

## Docker Image Authentication and Registry Integration

### Storing Credentials in Secret Manager
External registry authentication requires secure credential management. The process involves:

1. Creating dedicated secrets in Google Cloud Secret Manager for:
   - Username/registry identifier
   - Password/access token

2. Enabling multiple secret versions for credential rotation and management

3. Implementing proper secret naming conventions for organizational clarity

### Granting Permissions to Cloud Build Service Account
Cloud Build requires specific permissions to access secrets:

1. Identify the Cloud Build service account (format: `[PROJECT_NUM]@cloudbuild.gserviceaccount.com`)
2. Add the service account as a principal to each required secret
3. Assign the `Secret Manager Secret Accessor` role for read-only access
4. Scope permissions to specific secrets rather than granting blanket access to all secrets

This approach follows the principle of least privilege, limiting access to only the required credentials.

> [!IMPORTANT]
> Service account permissions can be configured either globally through Cloud Build settings or individually per secret in Secret Manager. Per-secret configuration provides finer-grained access control.

### Pulling and Pushing Images from External Registries
Cloud Build can interact with external container registries through authenticated operations:

**Authentication Process:**
```bash
docker login --username $USERNAME --password $PASSWORD
```

**Image Operations:**
- **Building Images:** `docker build -t username/repository:tag .`
- **Pushing Images:** `docker push username/repository:tag`
- **Pulling Images:** `docker pull username/repository:tag`

The authentication step typically occurs in the initial build step, with subsequent steps using the same authenticated session.

## Lab Demo: Pushing Image to Docker Hub

### Creating Cloud Build Configuration
The demonstration uses environment variables for secure credential injection:

```yaml
secrets:
- secret: projects/[PROJECT_ID]/secrets/docker-username/versions/1
  env: 'DOCKER_USERNAME'
- secret: projects/[PROJECT_ID]/secrets/docker-password/versions/1
  env: 'DOCKER_PASSWORD'

steps:
- name: 'docker'  # Docker-in-Docker (DinD) image
  entrypoint: 'bash'
  args: ['-c', 'docker login --username $DOCKER_USERNAME --password $DOCKER_PASSWORD']
  
- name: 'docker'
  args: ['build', '-t', '$DOCKER_USERNAME/secret:v1', '.']

- name: 'docker'
  args: ['push', '$DOCKER_USERNAME/secret:v1']
```

This configuration demonstrates:
- Secure secret injection from Secret Manager
- Multi-step authentication and image operations
- Environment variable usage for credential abstraction

### Dockerfile Creation
A minimal Dockerfile for demonstration purposes:

```dockerfile
FROM alpine:latest
COPY ./script.sh /script.sh
RUN chmod +x /script.sh
CMD ["/bin/sh", "/script.sh"]
```

This Dockerfile creates a lightweight container based on Alpine Linux, copies a script, makes it executable, and sets it as the default command.

### Executing the Build
The build execution follows a standard Cloud Build workflow:

```bash
gcloud builds submit --region us-central1 --config cloudbuild.yaml
```

The build process produces detailed logs showing:
1. Authentication success confirmation
2. Image build progress with Dockerfile layer creation
3. Push operation status to Docker Hub
4. Final image availability in the registry

## Summary

### Key Takeaways
```diff
+ Cloud Builders provide containerized tools for specialized Cloud Build tasks
+ Three builder types: Pre-built (Google), Community Contributed (Open Source), Custom (Proprietary)
+ Community builders require source code download and image building before use
+ External registry integration requires Secret Manager for credential storage
+ Cloud Build service accounts need specific permissions for secret access
- Always scope secret permissions to individual secrets rather than granting blanket access
- Pre-built builders cover most standard CI/CD requirements
! Custom builders offer maximum flexibility but require additional maintenance overhead
```

### Quick Reference
**Building Community Builders:**
```bash
git clone [builder-repo-url]
cd [builder-directory]
gcloud builds submit --region us-central1 --tag gcr.io/$PROJECT_ID/[builder]:v1
```

**Cloud Build with Docker Auth:**
```yaml
secrets:
- secret: projects/$PROJECT_ID/secrets/username/versions/1
  env: 'DOCKER_USERNAME'

steps:
- name: 'docker'
  entrypoint: 'bash'
  args: ['-c', 'docker login --username $DOCKER_USERNAME --password $DOCKER_PASSWORD']
- name: 'docker'
  args: ['push', '$DOCKER_USERNAME/repo:tag']
```

**Secret Manager Permissions:**
- Service Account: `[PROJECT_NUM]@cloudbuild.gserviceaccount.com`
- Role: `roles/secretmanager.secretAccessor`

### Expert Insight

#### Real-world Application
In enterprise environments, Cloud Builders enable sophisticated multi-stage pipelines. For instance, organizations might use custom builders containing proprietary tooling for code quality checks, security scanning, or deployment orchestration across hybrid cloud environments.

#### Expert Path
Advanced practitioners leverage builder composition, chaining multiple specialized builders in complex workflows. Mastery involves understanding image optimization, dependency caching, and integrating with external CI/CD tools through webhook triggers and API integrations.

#### Common Pitfalls
- **Secret Management:** Failing to rotate credentials regularly or over-scoping permissions can lead to security compromises
- **Image Size:** Building unnecessarily large Docker images results in slower builds and increased costs
- **Registry Limitations:** Not accounting for rate limits in external registries (like Docker Hub) can cause build failures during peak usage
- **Version Pinning:** Not specifying exact builder versions can lead to unexpected behavior when Google updates pre-built images
- **Network Restrictions:** Enterprise environments with restricted internet access may prevent community builder downloads or external registry communication

</details>
