# Session 46: Pushing Docker Images to Docker Hub

## Pushing Docker Images to Docker Hub

### Key Concepts

✅ **Pipeline Context**: This session builds on previous work where a Docker image was built and tested. The final step is deploying the image to a container registry, specifically Docker Hub.

✅ **Job Configuration**: Added a new job called "Docker push" in the GitLab CI pipeline to handle pushing the built image. This job runs in the same `containerization` stage as the build and test jobs.

✅ **Dependencies**: The push job requires the `docker_build` job (to access the built image) and the `docker_test` job (to ensure tests pass before pushing). This enforces a safe deployment workflow.

✅ **Environment Setup**: Uses the same Docker image and Docker-in-Docker services as the test job to maintain consistency and avoid re-building the image.

### Lab Demo: Adding Docker Push Job in GitLab CI Pipeline

Follow these steps to add the push job to your pipeline:

1. Open the GitLab pipeline editor (`.gitlab-ci.yml`).

2. Add a fifth job with the following configuration:

   ```yaml
   docker_push:
     stage: containerization
     image: docker
     services:
       - docker:dind
     needs:
       - job: docker_build
       - job: docker_test
     artifacts:
       paths:
         - solar_system.tar  # Assuming this is the artifact from build job
       expire_in: 1 hour
     script:
       - docker load < solar_system.tar
       - docker login -u $docker_username -p $docker_password
       - docker push $docker_username/solar_system:latest
     variables:
       DOCKER_HOST: tcp://docker:2376
       DOCKER_TLS_CERTDIR: "/certs"
     tags:
       - docker
   ```

   > [!NOTE]
   > Replace `solar_system.tar` and the image name/tag (`$docker_username/solar_system:latest`) with your actual artifact filename and Docker Hub repository details.

   Key script steps:
   - **Load Image**: `docker load < solar_system.tar` - Loads the image from the artifact downloaded from the build job.
   - **Login to Docker Hub**: `docker login -u $docker_username -p $docker_password` - Authenticates with Docker Hub using variables.
   - **Push Image**: `docker push $docker_username/solar_system:latest` - Uploads the image to Docker Hub.

   > [!IMPORTANT]
   > Ensure CI/CD variables are set in GitLab Settings > CI/CD > Variables:
   > - `docker_username`: Your Docker Hub username
   > - `docker_password`: Your Docker Hub password (marked as protected/masked)

3. Commit the changes and trigger a new pipeline.

### Pipeline Execution and Verification

💡 **Job Dependencies Visualization**: The pipeline visualization shows the push job only runs after both build and test jobs complete successfully. Use GitLab's pipeline graph to verify dependencies.

⚠️ **Order of Execution**:
- Docker build job completes first
- Docker test job runs next (loads image, runs tests)
- Docker push job runs last (loads image, logs in, pushes)

📝 **Artiface Handling**: The push job downloads the image artifact from the build job automatically. The artifact is temporary with a 1-hour expiry.

✅ **Success Indicators**:
- All jobs in the pipeline complete without errors
- In the push job logs: "Login Succeeded" followed by successful push messages
- Verify in Docker Hub: The image appears in your repository with the correct tag and recent push timestamp

> [!WARNING]
> Passwords in logs are masked, but ensure sensitive variables are properly configured as CI/CD variables to avoid exposing credentials.

### Key Takeaway
This setup creates a complete CI/CD workflow for Docker containerization: build → test → push. The push job ensures only tested images reach production repositories, enhancing security and reliability.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
