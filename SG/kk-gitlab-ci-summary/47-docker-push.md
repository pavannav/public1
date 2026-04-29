# Session 47: Docker Push to GitLab Container Registry

## ✅ Pushing Images to Alternative Container Registries

### 💡 Overview
In addition to Docker Hub, you can push container images to other registries like Google Container Registry or GitHub Container Registry. Importantly, GitLab also provides its own built-in container registry for each project, enabling seamless storage and management of container images within the GitLab ecosystem.

### 📝 Key Authentication Methods for GitLab Container Registry
GitLab supports multiple authentication methods for accessing the container registry:

1. **Personal Access Tokens**
   - User-specific tokens for individual access
   - Scoped permissions based on token configuration

2. **Deploy Tokens**
   - Project-specific tokens for automated deployments
   - Limited scope to specific project actions

3. **Project or Group Access Tokens**
   - Organization-level tokens for team access
   - Configurable permissions across projects/groups

### 🔧 Using Predefined CI/CD Variables for Authentication
GitLab CI/CD provides ready-to-use variables for seamless registry authentication:

| Variable | Description | Example Value |
|----------|-------------|---------------|
| `$CI_REGISTRY` | Container registry URL | `registry.gitlab.com` |
| `$CI_REGISTRY_USER` | Registry username | `gitlab-ci-token` |
| `$CI_REGISTRY_PASSWORD` | Authentication token | `[MASKED_TOKEN]` |
| `$CI_REGISTRY_IMAGE` | Full image path | `registry.gitlab.com/group/project` |

### ⚠️ Security Note
The `$CI_REGISTRY_PASSWORD` is automatically masked for security and contains the necessary authentication credentials for CI/CD operations.

## 🏗️ Building and Pushing Images Process

### 💡 Building Images for GitLab Registry
The build process follows standard Docker commands with registry-specific naming:

```bash
# Build command with registry naming convention
docker build -t $CI_REGISTRY/group/project/imagename:tag .
```

Where:
- `$CI_REGISTRY`: Registry domain (e.g., `registry.gitlab.com`)
- `group/project`: GitLab group and project path
- `imagename`: Custom image name you choose
- `tag`: Version identifier for the image

### 🔄 Authentication and Push Workflow
```diff
! Authenticate → Load Artifact → Tag Image → Push Image
```

## 📋 Lab Demo: Configuring GitLab Container Registry Push Job

### 🎯 Job Configuration Setup
Add a new job in your `.gitlab-ci.yml` file:

```yaml
stages:
  - containerization

publish_to_gitlab_container_registry:
  stage: containerization
  image: docker:24.0.5
  services:
    - docker:24.0.5-dind
  dependencies:
    - docker_build  # Depends on build job
    - docker_test   # Depends on test job
  script:
    # Download and load built image from artifacts
    - docker load -i docker-image.tar

    # Display registry variables for verification
    - echo "CI_REGISTRY: $CI_REGISTRY"
    - echo "CI_REGISTRY_USER: $CI_REGISTRY_USER"
    - echo "CI_REGISTRY_PASSWORD: $CI_REGISTRY_PASSWORD"
    - echo "CI_REGISTRY_IMAGE: $CI_REGISTRY_IMAGE"

    # Authenticate with GitLab Container Registry
    - docker login $CI_REGISTRY -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD

    # Tag the image for GitLab registry
    - docker tag ss-image $CI_REGISTRY_IMAGE/ss-image:$CI_PIPELINE_IID

    # Push the image to GitLab Container Registry
    - docker push $CI_REGISTRY_IMAGE/ss-image:$CI_PIPELINE_IID
```

### 📝 Step-by-Step Script Analysis

1. **Load Built Image**
   ```bash
   docker load -i docker-image.tar
   ```
   Downloads and loads the Docker image artifact from the `docker_build` job.

2. **Verify Registry Variables**
   ```bash
   echo "CI_REGISTRY: $CI_REGISTRY"
   echo "CI_REGISTRY_USER: $CI_REGISTRY_USER"
   echo "CI_REGISTRY_PASSWORD: $CI_REGISTRY_PASSWORD"
   echo "CI_REGISTRY_IMAGE: $CI_REGISTRY_IMAGE"
   ```
   Displays the predefined CI/CD variables for transparency.

3. **Authenticate with Registry**
   ```bash
   docker login $CI_REGISTRY -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD
   ```
   Logs into the GitLab Container Registry using CI/CD credentials.

4. **Tag Image for Registry**
   ```bash
   docker tag ss-image $CI_REGISTRY_IMAGE/ss-image:$CI_PIPELINE_IID
   ```
   Renames the image using the full registry path and pipeline ID as version tag.

5. **Push Image**
   ```bash
   docker push $CI_REGISTRY_IMAGE/ss-image:$CI_PIPELINE_IID
   ```
   Uploads the tagged image to the GitLab Container Registry.

### 🚨 Troubleshooting Login Syntax Error
Initially, the login command failed due to syntax issues with password passing:

```diff
- docker login $CI_REGISTRY -u $CI_REGISTRY_USER < $CI_REGISTRY_PASSWORD  # FAILED
+ docker login $CI_REGISTRY -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD  # SUCCESS
```

> [!IMPORTANT]
> Always use the `-p` flag to pass the password parameter explicitly to avoid standard input parsing errors in CI/CD environments.

### 📊 Pipeline Execution Results

After job configuration, the pipeline shows successful execution:

```diff
+ Docker Build → Docker Test → Docker Push → GitLab Registry Push
```

The "Publish to GitLab Container Registry" job runs in parallel with "Docker Push" but both depend on successful completion of build and test jobs.

## 🔍 Accessing Container Images in GitLab

### 📍 Location within Project
Navigate to your GitLab project → **Deploy** → **Container Registry**

### 📋 Image Details Available
- **Registry Path**: `registry.gitlab.com/group/project`
- **Image Name**: Custom name (e.g., `ss-image`)
- **Tags/Versions**: Pipeline IDs for versioning
- **Metadata**: Size, creation time, manifest/config digests

### 💡 Image Usage in Other Jobs
Pushed images can now be used in subsequent jobs:

```yaml
deploy_job:
  script:
    - docker pull $CI_REGISTRY_IMAGE/ss-image:$CI_PIPELINE_IID
    - # Deployment commands...
```

---

**Transcript Corrections Made:**
- None identified - transcript was accurate and well-formed.

MODEL ID: CL-KK-Terminal

### End of Session 47 📚

This session demonstrated how to extend your CI/CD pipeline to push Docker images to GitLab's built-in container registry, enabling seamless container management within the GitLab ecosystem. The process leverages predefined CI/CD variables for secure authentication and follows similar patterns to external registry pushes but with native GitLab integration benefits.
