# Session 43: What are Services

## Key Concepts

Services in GitLab CI/CD are Docker containers that enable network-accessible services for testing or running applications within pipelines. 💡

### Purpose and Use Cases
- **Network-Accessible Services**: Services provide portable ways to host dependencies needed by pipeline jobs.
- **Common Examples**: Databases (e.g., MongoDB) or memory caches. Any image from Docker Hub or private registries can be used.
- **Limitations**: Not for programming language runtimes (e.g., PHP, NodeJS, Golang) to access CLI commands—define them as job images instead.

> [!WARNING]
> Distinguish job images from service images: Use services for network-accessible dependencies, job images for runtime environments with CLI access.

### Defining Services
Use the `services:` tag in your `.gitlab-ci.yml` file:

```yaml
services:
  - name: your-service:latest
    alias: myservice
    pull_policy: always
    variables:
      MY_VAR: value
```

### Connection and Hostnames
Jobs connect to services via hostnames. GitLab auto-generates hostnames by:
- Replacing `/` with `-` (recommended)
- Replacing `/` with `__` (deprecated, not RFC-compliant)

```diff
! Hostname Generation Example:
! wordpress:latest → wordpress-eng.latest (invalid characters stripped)
! Recommended: Use aliases for reliability
```

> [!IMPORTANT]
> Always use aliases to avoid connection issues with third-party applications. Aliases override auto-generated hostnames.

### Service Configuration Options
| Option | Description | Example |
|--------|-------------|---------|
| `name` | Full Docker image name (required) | `wordpress:latest` |
| `entrypoint` | Custom Docker entrypoint | `/usr/bin/my-script.sh` |
| `command` | Docker command override | `npm start` |
| `alias` | Custom hostname for access | `myservice` |
| `variables` | Environment variables for the service | `DB_PASSWORD: secret` |

Additional options via CI/CD YAML reference: platform, user, pull policies.

## Lab Demo: Configuring Services for Unit Testing and Code Coverage

Configure a MongoDB service for unit testing and code coverage jobs.

### Steps

1. **Add Service Definition**:
   - Open `.gitlab-ci.yml`
   - Add services under relevant jobs

```yaml
unit_test:
  image: node:17-alpine
  services:
    - name: your-docker-hub-account/mongodb-non-prod:latest
      alias: mongo
      pull_policy: always
  variables:
    MONGO_URI: mongodb://non-prod-user:password@mongo:27017/superdata
  script:
    - npm test

code_coverage:
  image: node:17-alpine
  services:
    - name: your-docker-hub-account/mongodb-non-prod:latest
      alias: mongo
      pull_policy: always
  variables:
    MONGO_URI: mongodb://non-prod-user:password@mongo:27017/superdata
  script:
    - npm run coverage
```

2. **Service Connection**:
   - Service runs in its own container alongside the job container.
   - Job accesses via alias/hostname: `mongodb://user:pass@alias:port/database`

```diff
+ Connection String Format: mongodb://non-prod-user:password@mongo:27017/superdata
- Insecure: Avoid hardcoding passwords—use CI/CD variables for masking
! Port: Default MongoDB port (27017); connect after service startup
```

3. **Commit and Trigger Pipeline**:
   - Commit: "Configured service container"
   - Pipeline auto-triggers; verify jobs succeed.

### Pipeline Execution Flow
Jobs start service container first, wait for readiness, then run scripts using the service.

```mermaid
flowchart TD
    A[Job Starts] --> B{Pull Service Image}
    B --> C[Start Service Container]
    C --> D[Wait for Service Ready]
    D --> E{Service Ready?}
    E -->|Yes| F[Start Job Container]
    E -->|No| G[Retry/Timeout]
    F --> H[Execute Script]
    H --> I[Run Tests/Coverage]
    I --> J[Job Complete]
```

> [!NOTE]
> Both containers run in the same runner executor. Services enable isolated, network-accessible dependencies without modifying job images.

```diff
+ Benefits: Easy database access for testing without external dependencies
- Drawbacks: Services add container startup time; limited to container networking
! Security: Use CI/CD variables for sensitive service configuration
```
