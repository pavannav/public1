# Session 44: Run Unit Testing & Code Coverage Jobs using Services

## Building Docker Images Using GitLab CI/CD Pipeline

### Key Concepts ✅

1. **Review of Previous Jobs**:
   - Unit testing and code coverage jobs have been created in prior sessions.
   - These jobs utilize services for execution, enabling container-based testing environments within GitLab CI/CD pipelines.
   - After successful completion of these jobs, the next step is to build and push a Docker image using the CI/CD pipeline.

2. **Pipeline Stage Creation**:
   - Create a new stage called **containerization** to group Docker-related jobs.
   - This stage will run after the test and coverage stages.

3. **Docker Build Job Configuration**:
   - Job Name: `Docker build`
   - **stage**: `containerization`
   - **image**: `docker:24.0.5` (uses Docker image to enable Docker CLI commands)
   - **script**: 
     ```bash
     docker build -t $docker_username/solar-system:$CI_PIPELINE_ID .
     docker images
     ```
     > [!NOTE]  
     > The Docker build command leverages a `Dockerfile` at the repository root. It uses pre-configured environment variables for dynamic tagging.

### Lab Demo: Creating the Docker Build Job 📝

**Steps to Add the Job in `.gitlab-ci.yml`**:

1. Add a new job under the `containerization` stage:
   ```yaml
   docker build:
     stage: containerization
     image: docker:24.0.5
     script:
       - docker build -t $docker_username/solar-system:$CI_PIPELINE_IID .
       - docker images
   ```

2. Define required variables in the GitLab CI/CD file:
   - `docker_username`: Your Docker Hub username (e.g., `your-username`)
   - `CI_PIPELINE_IID`: GitLab predefined variable for dynamic pipeline-based versioning

3. Associate the job with the Docker-in-Docker (DinD) service:
   ```yaml
   services:
     - docker:dind
   ```

   > [!IMPORTANT]  
   > Services are essential for running Docker commands within a GitLab CI container, as Docker cannot execute inside containers by default.

4. Configure dependencies to skip artifact downloads:
   ```yaml
   dependencies: []
   ```
   > [!NOTE]  
   > This specifies that the job does not require artifacts from previous jobs (e.g., unit testing or code coverage outputs).

5. Commit the changes to trigger a new pipeline.

**Pipeline Execution Flow**:
```diff
+ Pipeline Stages: test → build (covers coverage) → containerization
```

### Docker in Docker (DinD) Service Explanation 💡

- **Definition**: Docker-in-Docker (DinD) is a service that runs a Docker container containing its own Docker daemon, enabling nested Docker environments.
- **Purpose in GitLab CI**: Allows jobs to execute Docker commands (e.g., build, push) regardless of the runner's configuration or privileges.
- **Benefits**:
  - Enables building Docker images directly within pipelines.
  - Supports testing applications that depend on Docker.
  - Bypasses potential restrictions on host Docker daemons.

> [!WARNING]  
> Running Docker in Docker requires proper service configuration to avoid security issues or conflicts with the host Docker environment.

### Dockerfile Reference 📝

- The repository includes a `Dockerfile` at the root level with the following key instructions:
  - **Base Image**: `node:18-alpine`
  - Sets working directory and installs NPM dependencies.
  - Configures environment variables (e.g., database URIs) to be injected via Kubernetes secrets.
  - Exposes required ports and defines the application startup command.

### Pipeline Job Logs and Execution ⚠️

- **Preparation Steps**:
  - Starts the DinD service container.
  - Launches the job container using the `docker:24.0.5` image.
- **Script Execution**:
  - Executes `docker build` command, pulling the base image (`node:18-alpine`), setting up the working directory, copying packages, running `npm install`, and finalizing the image.
  - Dynamically tags the image as `docker.io/[username]/solar-system:[pipeline-id]`.
- **Output**:
  - Displays built image details (name, tag, ID, size).
- **Success Indicators**:
  - Job completes successfully if all steps (preparation, service start, script execution) finish without errors.

> [!NOTE]  
> Pipeline visualization confirms sequential execution: `test` stage → `coverage` stage → `containerization` stage.

### Next Session Preview 🚀

- Create an additional job to test the built Docker image before pushing to Docker Hub registry.

---

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
