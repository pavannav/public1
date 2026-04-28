# Session 10: Advanced Docker Coding Interview Questions & Answers

## Table of Contents
- [Creating a Docker Network and Connecting Multiple Containers](#creating-a-docker-network-and-connecting-multiple-containers)
- [Writing a Dockerfile that Installs a Specific Version of Node.js and Sets an Environment Variable](#writing-a-dockerfile-that-installs-a-specific-version-of-nodejs-and-sets-an-environment-variable)
- [Building Images Using a Remote Git Repository](#building-images-using-a-remote-git-repository)
- [Writing a Docker Compose File that Uses Environment Variables from a .env File](#writing-a-docker-compose-file-that-uses-environment-variables-from-a-env-file)
- [Caching Docker Layers for Faster Builds in a Dockerfile](#caching-docker-layers-for-faster-builds-in-a-dockerfile)
- [Troubleshooting and Debugging a Docker Container that is Not Starting](#troubleshooting-and-debugging-a-docker-container-that-is-not-starting)
- [Writing a Dockerfile that Uses ARG and ENV Instructions to Pass Build-Time and Runtime Variables](#writing-a-dockerfile-that-uses-arg-and-env-instructions-to-pass-build-time-and-runtime-variables)
- [Removing All Dangling Images in Docker](#removing-all-dangling-images-in-docker)
- [Writing a Docker Command to Restart a Container Automatically if it Fails](#writing-a-docker-command-to-restart-a-container-automatically-if-it-fails)
- [Setting Up a Docker Container to Run as a Non-Root User](#setting-up-a-docker-container-to-run-as-a-non-root-user)
- [Summary](#summary)

## Creating a Docker Network and Connecting Multiple Containers

### Overview
Docker networks enable communication between containers, replacing hardcoded IP addresses with dynamic service discovery. Bridge networks (default) allow containers on the same network to communicate while isolating them from other containers on different networks.

### Key Concepts / Deep Dive
- **Docker Networks**: Logical entities handling container communication, routing traffic, and load balancing.
- **Bridge Network**: Default driver creating isolated network space for containers.
- **Service Discovery**: Automatic hostname resolution between containers on same network.

#### Lab Demo Steps
1. **Prerequisites**: Install Docker and start Docker daemon.
   ```bash
   # Install Docker (if not installed)
   curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh
   
   # Start Docker service
   sudo systemctl start docker
   ```

2. **Create Custom Bridge Network**:
   ```bash
   docker network create customNetwork
   docker network ls  # Verify network creation
   ```

3. **Launch Containers on Custom Network**:
   ```bash
   docker run --detach -it --name alpine1 --network customNetwork alpine /bin/sh
   docker run --detach -it --name alpine2 --network customNetwork alpine /bin/sh
   ```

4. **Verify Container Communication**:
   - Inspect network to confirm containers:
     ```bash
     docker network inspect customNetwork
     ```
   - Test connectivity using ping between containers:
     ```bash
     # Get IP of alpine1
     docker exec alpine1 ifconfig  # Note IP (e.g., 172.22.0.2)
     
     # Ping from alpine2 to alpine1 IP
     docker exec alpine2 ping 172.22.0.2
     ```

By default, bridge networks enable seamless inter-container communication at Layer 3 (IP) and Layer 4 (TCP/UDP).

## Writing a Dockerfile that Installs a Specific Version of Node.js and Sets an Environment Variable

### Overview
A Dockerfile defines instructions to build a Docker image. The `FROM` instruction specifies base images with specific versions, while `ENV` sets runtime environment variables that persist in containers and child images.

### Key Concepts / Deep Dive
- **FROM Instruction**: Specifies base image, critical for setting Node.js version.
- **ENV Instruction**: Sets environment variables accessible during build and runtime.
- **Layers**: Each RUN instruction creates new layer; subsequent commands depend on previous layers.

#### Example Dockerfile for Node.js 14 with Environment Variable
```dockerfile
FROM node:14-alpine

ENV APP_ENV=production

WORKDIR /app
COPY package.json .
RUN npm install
COPY . .

CMD ["node", "app.js"]
```

Key Points:
- Use `node:14-alpine` for Node.js v14 on minimal Alpine Linux base
- `ENV APP_ENV=production` sets environment variable
- `WORKDIR /app` sets working directory for subsequent instructions
- `COPY package.json .` and `RUN npm install` cache dependencies
- `COPY . .` copies application code
- `CMD ["node", "app.js"]` specifies startup command

## Building Images Using a Remote Git Repository

### Overview
Docker can build images directly from Git repositories without local Dockerfile copies, enabling CI/CD pipelines and distributed development workflows.

### Key Concepts / Deep Dive
- **Remote Builds**: `docker build` accepts Git URLs as context
- **Git Access**: Requires local Git installation for cloning
- **Branch Support**: Default branch used unless specified

#### Commands to Build from Remote Repository
```bash
# Build image from GitHub repository
docker build -t gitImage https://github.com/user/repo.git
```

Example remote Dockerfile (https://github.com/user/repo.git#Dockerfile):
```dockerfile
FROM ubuntu
RUN apt-get update
RUN apt-get install -y apache2
CMD ["apache2ctl", "-D", "FOREGROUND"]
```

This clones specified repository, builds image following remote Dockerfile instructions, creating executable Apache container.

## Writing a Docker Compose File that Uses Environment Variables from a .env File

### Overview
Docker Compose orchestrates multi-container applications. Environment variables externalize configuration, stored in `.env` files read automatically by `docker-compose up`.

### Key Concepts / Deep Dive
- **docker-compose.yaml**: Defines services, networks, and volumes
- **Environment Variables**: Define configuration outside container runtime
- **.env File**: Local environment configurations excluded from version control

#### Example Docker Compose with .env
**docker-compose.yaml**:
```yaml
version: '3.8'
services:
  app:
    image: node:alpine
    environment:
      - DB_PASSWORD=${DB_PASSWORD}
    ports:
      - "3000:3000"
```

**.env** (create in same directory):
```
DB_PASSWORD=securePassword123
```

Run application:
```bash
docker-compose up
```

> [!WARNING]
> Never commit .env files containing secrets to version control. Use .env.example for templates.

## Caching Docker Layers for Faster Builds in a Dockerfile

### Overview
Docker uses layer caching to accelerate builds by reusing unchanged instructions. Proper instruction ordering maximizes cache utilization.

### Key Concepts / Deep Dive
- **Build Cache**: Reuses previous build layers for unchanged instructions
- **Dependency Caching**: Cache `npm install` by copying package files first
- **Invalidation**: Cache busts on any change before cache-dependent instructions

#### Optimized Dockerfile Layer Ordering
```dockerfile
FROM node:14-alpine

ENV NODE_ENV=production

WORKDIR /app
COPY package*.json ./
RUN npm install

COPY . .
EXPOSE 3000

CMD ["npm", "start"]
```

**Layer Cache Strategy**:
- Steps rarely changing (base image, ENV, WORKDIR) → cached first
- Dependence installation (package*.json + npm install) → cached after dependency changes
- Source code copying → invalidates least cached layer

Result: Semantically similar builds complete faster by reusing cached dependency installations.

## Troubleshooting and Debugging a Docker Container that is Not Starting

### Overview
Container failures stem from application errors, misconfigurations, or missing dependencies. Systematic debugging identifies root causes quickly.

### Key Concepts / Deep Dive
- **Container Lifecycle**: Failures prevent completion, container exits immediately
- **Logs**: Primary debugging source revealing application errors
- **Interactive Debugging**: Shell access enables manual troubleshooting

#### Troubleshooting Steps
1. **Check Logs**:
   ```bash
   docker logs container_name
   # Example error: "Error: Cannot find module './app.js'"
   ```

2. **Interactive Shell (if running)**:
   ```bash
   docker exec -it container_name /bin/sh
   # Diagnose inside container
   ```

3. **For non-running containers, debug image in shell**:
   ```bash
   docker run -it --entrypoint /bin/sh image_name
   # Troubleshoot startup issues
   ```

4. **Inspect Container Configuration**:
   ```bash
   docker inspect container_name
   # Validate environment variables, mounts, and networking
   ```

Common debugging commands inside container:
- `ls -la` - check files
- `env` - view environment variables  
- `ps aux` - running processes
- Application-specific commands (e.g., `node app.js`)

## Writing a Dockerfile that Uses ARG and ENV Instructions to Pass Build-Time and Runtime Variables

### Overview
ARG and ENV provide different variable scoping. ARG enables build-time parameterization, ENV sets runtime variables visible to applications.

### Key Concepts / Deep Dive
- **ARG**: Build-time variables, overridable via `--build-arg`, discarded post-build
- **ENV**: Runtime variables, embedded in image, accessible to running containers

#### Comparison Table

| Feature | ARG | ENV |
|---------|-----|-----|
| When Set | Build time | Build time |
| When Used | Dockerfile only | Dockerfile and running container |
| Persistence | Not in final image | Embedded in image |
| Override | Via `--build-arg` | Cannot override |
| Scope | Build process | Container runtime |

#### Example Dockerfile Using Both
```dockerfile
FROM ubuntu

ARG VERSION=1.0
ENV BUILD_DATE=2023-01-01
ENV APP_VERSION=${VERSION}

RUN echo "Building version: ${VERSION}" > /version.txt
```

**Building with ARG Override**:
```bash
docker build --build-arg VERSION=2.0 -t myapp .
```

Final image contains `APP_VERSION=2.0` (from ARG) and `BUILD_DATE=2023-01-01`, but not `VERSION` variable.

## Removing All Dangling Images in Docker

### Overview
Dangling images are incomplete or unnamed intermediate builds consuming disk space. Docker `image prune` removes these automatically.

### Key Concepts / Deep Dive
- **Dangling Images**: Result from interrupted builds or untagged intermediates
- **Space Reclamation**: Critical for maintaining disk space

#### Command Usage
```bash
docker image prune -f
```

Output example:
```
Deleted Images:
untagged: ubuntu@sha256:abc123...
Deleted: sha256:def456...

Total reclaimed space: 1.2GB
```

> [!NOTE]
> `-f` forces deletion without confirmation. Safe as dangling images aren't used.

## Writing a Docker Command to Restart a Container Automatically if it Fails

### Overview
Docker's restart policies ensure container resilience by automatically restarting failed containers, maintaining service availability.

### Key Concepts / Deep Dive
- **Restart Policies**: Define automatic restart behavior on container exits
- **Failure Handling**: Especially valuable for production services

#### Restart Policy Options

| Policy | Behavior |
|--------|----------|
| no | Never restart (default) |
| always | Always restart |
| on-failure | Restart only on non-zero exit codes |
| unless-stopped | Same as always, but don't restart if manually stopped |

#### Automatic Restart Command
```bash
docker run --restart on-failure:5 -d nginx
```

This restarts container up to 5 times on failure, invaluable for handling transient issues in production,the command liau automatically handles container failures by attempting restarts,ensuring service reliability without manual intervention.

## Setting Up a Docker Container to Run as a Non-Root User

### Overview
Containers execute as root by default, posing security risks. Running as non-root user follows principle of least privilege, reducing attack surface.

### Key Concepts / Deep Dive
- **Security Best Practice**: Non-root minimizes lateral movement capabilities
- **USER Instruction**: Switches subsequent Dockerfile commands' execution context
- **Multi-stage Builds**: Allows separate privileged and user contexts

#### Dockerfile for Non-Root User
```dockerfile
FROM node:14-alpine

# Create non-root user and group
RUN addgroup -S nodeapp && adduser -S nodeuser -G nodeapp

# Set working directory and permissions before switching user
WORKDIR /app
COPY --chown=nodeuser:nodeapp package*.json ./

# Switch to non-root user
USER nodeuser

# Subsequent commands run as non-root
RUN npm ci --only=production
COPY --chown=nodeuser:nodeapp . .

CMD ["node", "app.js"]
```

**Key Security Points**:
- Create user/group before switching
- Change ownership of files to non-root user
- Set restrictive permissions where possible
- Avoid USER in base stages requiring privileges

> [!WARNING]
> USER affects ALL subsequent instructions. If privileged operations needed later, structure Dockerfile accordingly or use separate stages.

## Summary

### Key Takeaways
```diff
+ Docker networks enable secure, isolated container communication
+ Dockerfiles optimize build speed through strategic layer ordering
+ Environment variables externalize configuration in Docker Compose
+ ARG for build-time, ENV for runtime variables
+ Non-root execution enhances container security
+ Restart policies ensure service resilience
+ Systematically debug containers using logs, exec, and inspect
```

### Quick Reference
**Network Commands:**
```bash
docker network create mynetwork
docker run --network mynetwork --name container1 alpine
```

**Dockerfile Template:**
```dockerfile
FROM node:14-alpine
ENV NODE_ENV=production
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
CMD ["node", "app.js"]
```

**Docker Compose with .env:**
```yaml
version: '3.8'
services:
  app:
    image: node:alpine
    environment:
      - DB_URL=${DB_URL}
```

### Expert Insight

#### Real-world Application
Production containerized applications leverage custom networks for microservices communication, ensuring secure service discovery. Node.js applications commonly specify versions (e.g., Alpine-based `node:14-alpine`) for minimal attack surfaces. Non-root containers prevent privilege escalation exploits, while automated restart policies maintain uptime during transient failures.

#### Expert Path
Master Docker build optimization by understanding cache invalidation patterns and adopting multi-stage builds. Deepen networking knowledge with Docker swarm overlays and Kubernetes networking. Practice advanced troubleshooting with `docker debug` and logging aggregators. Pursue Docker Certified Associate certification to validate expertise.

#### Common Pitfalls
- **Root Privileges**: Default root execution increases security risks - always specify USER in Dockerfiles.
- **Cache Invalidation**: Improper Dockerfile ordering causes unnecessary rebuilds - place rarely changing commands first.
- **Environment Exposure**: Hardcoded secrets in images or Layer 2 exposure - use build ARGs and runtime environment variables.
- **Network Isolation**: Running containers on default bridge without custom networks leads to unintended communication paths.
- **Log Loss**: Failing containers lose logs on restart - implement persistent logging or external aggregation.

#### Lesser-Known Facts
- **BuildKit**: Enable with `DOCKER_BUILDKIT=1` for parallel layer building, significantly reducing build times.
- **Squashing**: `--squash` flag consolidates layers, reducing image size but losing intermediate layer cachability.
- **Healthchecks**: Container readiness signals via `HEALTHCHECK` directive guide restart policies and load balancer routing.
- **Secrets**: `ARG` values can accidentally leak into image history - avoid using for sensitive data.
