# Session 1: Docker Multi-Stage Build - Optimize Your Java Spring Boot Application

- [What are Multi-Stage Builds in Docker?](#what-are-multi-stage-builds-in-docker)
- [Example: Multi-Stage Dockerfile for Java Spring Boot](#example-multi-stage-dockerfile-for-java-spring-boot)
- [Lab Demo: Building and Running the Multi-Stage Image](#lab-demo-building-and-running-the-multi-stage-image)
- [Summary](#summary)
- [Transcript Corrections](#transcript-corrections)

## What are Multi-Stage Builds in Docker?

### Overview
Multi-stage builds in Docker are a feature that allows you to create efficient and minimal Docker images by separating the build process into multiple stages within a single Dockerfile. This approach is particularly useful for reducing image size, complexity, and eliminating unnecessary dependencies or intermediate files from the final production image. Each stage can perform specific tasks, such as installing dependencies, running tests, building the application, and then copying only the essential artifacts to a clean runtime environment. This results in smaller, more secure images that are optimized for production deployment.

### Key Concepts
Multi-stage builds address common Docker image inefficiencies by allowing structured, sequential processing:

- **Multiple FROM Instructions**: A single Dockerfile can contain multiple `FROM` statements, each defining a separate stage. Stages are labeled or referenced by index (0-based).
  
- **Artifact Copying Between Stages**: Use the `COPY --from=<stage>` instruction to transfer built artifacts (e.g., JAR files, binaries) from one stage to another, leaving behind build tools and intermediate files.

- **Final Image Optimization**: Only the last stage produces the final image, ensuring it contains only runtime dependencies and the application artifacts.

- **Use Cases**:
  - Building compiled applications where source code, compilers, and dependencies are needed only during build time.
  - Running tests in an isolated stage before packaging.
  - Creating minimal base images (e.g., using lightweight runtimes like OpenJDK for Java apps) instead of heavy development images.

- **Benefits**:
  - Reduced image size: Eliminates build-time dependencies from the final image.
  - Improved security: Fewer components mean fewer potential vulnerabilities.
  - Better performance: Smaller images download and start faster.
  - Maintainability: Cleaner separation of concerns across stages.

Common pitfall: Forgetting to skip redundant steps (like re-running tests in build stages if already done earlier) or including unnecessary files in the final copy.

### Example: Multi-Stage Dockerfile for Java Spring Boot
A typical multi-stage Dockerfile for a Java Spring Boot application might include three stages:

1. **Development Stage**: Install dependencies, copy source code, and run tests.
2. **Build Stage**: Compile and package the application into a JAR, skipping tests if already run.
3. **Production Stage**: Use a minimal runtime image, copy the JAR from the build stage, and define the startup command.

Here's an example Dockerfile demonstrating this pattern:

```dockerfile
# Stage 1: Development - Maven image for testing
FROM maven:3.8.4-openjdk-17 AS development
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn test

# Stage 2: Build - Maven image for packaging
FROM maven:3.8.4-openjdk-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 3: Production - Lightweight OpenJDK runtime image
FROM openjdk:17-jre-slim
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
```

- Stage 1 pulls the Maven image, sets the working directory, copies the `pom.xml` and source code, and runs tests.
- Stage 2 also uses Maven, copies files again, and runs `mvn clean package` with tests skipped.
- Stage 3 uses a slim OpenJDK image, copies only the built JAR from the build stage, exposes port 8080, and defines the startup command.

## Lab Demo: Building and Running the Multi-Stage Image

### Prerequisites
- An EC2 instance running Linux.
- Docker installed and running.
- Source code for a Java Spring Boot application (available in the GitHub repo linked in the transcript description).
- Security group allowing access to port 8080 (or the exposed port).

### Steps
1. **Connect to EC2 Instance**:
   Log in to your EC2 instance via SSH. Ensure Docker is running.

2. **Navigate to the Project Directory**:
   ```
   cd /path/to/multi-stage-build-project
   ```
   The directory should contain:
   - `src/` (main and test Java code)
   - `pom.xml` (Maven project file)
   - `Dockerfile` (the multi-stage build file)

3. **Review the Dockerfile**:
   The Dockerfile matches the example above:
   ```dockerfile
   # Stage 1: Development
   FROM maven:3.8.4-openjdk-17 AS development
   WORKDIR /app
   COPY pom.xml .
   COPY src ./src
   RUN mvn test

   # Stage 2: Build
   FROM maven:3.8.4-openjdk-17 AS build
   WORKDIR /app
   COPY pom.xml .
   COPY src ./src
   RUN mvn clean package -DskipTests

   # Stage 3: Production
   FROM openjdk:17-jre-slim
   WORKDIR /app
   COPY --from=build /app/target/*.jar app.jar
   EXPOSE 8080
   CMD ["java", "-jar", "app.jar"]
   ```

   - Explanation:
     - Stage 1 installs dependencies and runs tests (output shows: "Tests run: 1, Failures: 0, Errors: 0").
     - Stage 2 builds the JAR package without re-running tests.
     - Stage 3 copies the JAR and runs the app.

4. **Build the Docker Image**:
   Run the build command to create the multi-stage image:
   ```bash
   docker build -t multistage-image .
   ```
   - Monitor the output: You'll see each stage executed sequentially (pulling Maven images, setting directories, copying files, running tests, building packages).
   - Download time for plugins may be long on first build.
   - Upon completion, the build outputs show success for tests and package creation.
   - Intermediate containers are automatically removed after each stage.

5. **Verify Images Created**:
   List Docker images to see the stages created during build:
   ```bash
   docker images
   ```
   - Expected output includes intermediary stages (e.g., for Maven images) and the final image (e.g., `multistage-image` based on OpenJDK slim).
   - Note the smaller size of the final production image compared to full development images.

6. **Run the Container**:
   Start a container from the built image with port mapping:
   ```bash
   docker run -d -it --name multistage-container -p 8080:8080 multistage-image
   ```
   - `-d` runs in detached mode, `-it` allocates a pseudo-TTY, `--name` assigns a container name, `-p` maps host port 8080 to container port 8080.

7. **Test the Application**:
   - Access the app via your browser: `http://<EC2-public-IP>:8080`
   - Expected response: The Spring Boot app returns a message (e.g., based on `src/main/java/.../Application.java`).
   - Ensure port 8080 is open in your EC2 security group.

8. **Clean Up (Optional)**:
   - Stop and remove the container: `docker stop multistage-container && docker rm multistage-container`
   - Remove intermediate images if needed: `docker image prune`

### Expected Results
- The build creates efficient layers, with only the final stage image retained as the deployable artifact.
- Image size is significantly reduced (e.g., final image much smaller than Maven-based images).
- The app runs successfully in the container.

## Summary

### Key Takeaways
```diff
+ Multi-stage builds create efficient, minimal Docker images by separating build and runtime environments.
+ Use multiple FROM stages to handle testing, building, and production in sequence.
+ COPY --from=stage transfers only necessary artifacts, reducing size and security risks.
+ Final images contain only runtime components, eliminating build dependencies.
- Avoid including intermediate files in final images; use dedicated stages for isolation.
- Skip redundant operations (e.g., re-running tests) between stages to optimize build time.
! This is a common interview topic—explain stages, benefits, and provide a real example.
```

### Quick Reference
- **Dockerfile Stages**:
  ```dockerfile
  FROM maven:3.8.4-openjdk-17 AS development  # Test stage
  FROM maven:3.8.4-openjdk-17 AS build       # Build stage
  FROM openjdk:17-jre-slim                  # Minimal production stage
  ```

- **Build Command**: `docker build -t <image-name> .`
- **Run Command**: `docker run -d -it --name <container-name> -p <host-port>:<container-port> <image-name>`
- **Common Maven Commands in Stages**:
  - Run tests: `mvn test`
  - Build JAR: `mvn clean package -DskipTests`

### Expert Insight

#### Real-World Application
In production environments, multi-stage builds are essential for containerized microservices on platforms like Kubernetes or AWS ECS. For instance, in a CI/CD pipeline using Jenkins or GitHub Actions, you can automate multi-stage builds to ensure only tested, compiled artifacts are deployed. This reduces attack surfaces and optimizes resource usage on container orchestration systems, where smaller images mean faster rollouts and lower storage costs.

#### Expert Path
Master multi-stage builds by experimenting with more stages for complex apps (e.g., separate stages for unit tests, integration tests, and security scans). Integrate with Docker BuildKit for advanced features like parallel builds. Study Dockerfile best practices from Docker's official docs, and measure image sizes using tools like `docker history` or `dive` to quantify optimizations.

#### Common Pitfalls
- **Forgetting --from in COPY**: Always specify `COPY --from=<stage>`; otherwise, it defaults to the build context file system, potentially including unintended files.
- **Including Sensitive Data**: Build-time secrets (e.g., API keys) can leak if cached layers aren't managed—use `.dockerignore` and multi-stage isolation to prevent this.
- **Large Intermediate Images**: Don't tag intermediate stages unless needed; Docker cleans them up automatically, but manual builds can accumulate.
- **Port Exposure Issues**: Ensure EXPOSE and runtime port mapping align with app configs and security rules.
- **Build Cache Inefficiencies**: Order Dockerfile commands from least to most frequently changing to leverage Docker's layer caching effectively.

#### Lesser-Known Facts
- Docker multi-stage builds were introduced in Docker 17.05; they revolutionized Dockerfile patterns by eliminating tricks like shell hacks for slim images.
- You can reference stages by name (e.g., `AS build`) or index (e.g., `--from=1`), and even use external images as stages for extreme minimization.
- Advanced setups include conditional copying or using ARG for dynamic base images across stages, enabling flexible CI environments.

## Transcript Corrections
- "mavan" → "maven" (multiple instances, e.g., base image and command references).
- "May one" → "Maven" (contextual reference to the tool).
- "e to instance" → "EC2 instance" (refers to AWS EC2).
- "hyph T" → "-t" (command line flag for tag).
- "dit" → "-d -it" (likely combined flags for detached interactive run).
- "hyp h" → "hyphen" (general reference to command flags).
- Missing timestamps and minor typos in command explanations (e.g., "hyphen dit" clarified as "-d -it").
- "0o errors" → "0 errors" (typo in test output).
