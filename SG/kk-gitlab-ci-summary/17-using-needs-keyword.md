# Session 17: Using needs Keyword

## Using Variables in GitLab CI/CD Pipelines

### Key Concepts

Variables in GitLab CI/CD pipelines can be defined at two levels: **global** and **job** level. When variables are defined at both levels, job-level variables take precedence over global variables. This allows for flexible reuse of values across jobs while allowing job-specific overrides.

> [!IMPORTANT]
> Global variables are available to **all jobs** in the pipeline, while job-level variables are scoped only to the specific job.

- **Defining Variables**: Use the `variables` keyword followed by key-value pairs. Variables are referenced using the `$` syntax (e.g., `$variable_name`).

- **Nested Dependencies**: Variables can reference other variables, even at the same level, creating dependencies within definitions.

- **Scope and Reuse**: To avoid repetition, define commonly used variables at the global level. Job-specific variables (like passwords) should remain at the job level for security and isolation.

### Defining Variables

Variables are defined using a simple YAML structure. Here's an example of global variable definition:

```yaml
variables:
  USERNAME: "myuser"
  REGISTRY: "docker.io"
  IMAGE: "myapp"
  VERSION: "latest"
```

Within jobs, variables are accessed using the dollar sign prefix: `$USERNAME`, `$REGISTRY`, etc.

### Job-Level Variable Example

In the Docker build job, variables can be defined locally and referenced in scripts:

```yaml
docker_build:
  variables:
    USERNAME: "myuser"
    REGISTRY: "docker.io"
    IMAGE: "myapp"
    VERSION: "1.0"
  script:
    - echo "Building image $USERNAME/$IMAGE:$VERSION"
    - docker build -t $REGISTRY/$USERNAME/$IMAGE:$VERSION .
```

```diff
+ Benefits: Job-level variables allow customization per job without affecting others.
- Drawbacks: Repeating the same variables across multiple jobs leads to duplication and maintenance issues.
```

### Global-Level Variable Advantages

Define shared variables globally to reuse across jobs:

```yaml
variables:
  USERNAME: "myuser"
  REGISTRY: "docker.io"
  IMAGE: "myapp"
  VERSION: "1.0"

docker_build:
  script:
    - docker build -t $REGISTRY/$USERNAME/$IMAGE:$VERSION .

docker_test:
  script:
    - docker run --rm $REGISTRY/$USERNAME/$IMAGE:$VERSION test

docker_push:
  variables:
    PASSWORD: "secret_password"  # Job-specific variable
  script:
    - echo "$PASSWORD" | docker login -u $USERNAME --password-stdin $REGISTRY
    - docker push $REGISTRY/$USERNAME/$IMAGE:$VERSION
```

> [!WARNING]
> Avoid hardcoding sensitive information like passwords in plain text. GitLab CI/CD supports masked variables for security, which will be covered in future sessions.

### Using Predefined CI/CD Variables

GitLab provides built-in predefined variables for dynamic values. For example, use `$CI_PIPELINE_ID` to set a dynamic version:

```yaml
variables:
  VERSION: "$CI_PIPELINE_ID"  # Automatically uses the current pipeline ID
```

This creates unique image versions based on each pipeline execution.

> [!NOTE]
> Predefined variables like `$CI_PIPELINE_ID` provide context from the GitLab environment without manual configuration.

### Variable Scope Demo

In the deploy job example, global variables (`$USERNAME`) are accessible, but job-level variables from other jobs (`$PASSWORD` from docker_push) are not:

```yaml
deploy:
  script:
    - echo "Username: $USERNAME"  # Accessible (global)
    - echo "Password: $PASSWORD"  # Not accessible (job-scoped)
```

### Lab Demo: Implementing Variables in Pipeline

#### Step-by-Step Implementation

1. **Initial Setup**: Start with a pipeline using hardcoded values in multiple jobs.

2. **Add Job-Level Variables**:
   - Modify the `docker_build` job:
     ```yaml
     docker_build:
       variables:
         USERNAME: "myuser"
         REGISTRY: "docker.io"
         IMAGE: "myapp"
         VERSION: "1.0"
       script:
         - docker build -t $REGISTRY/$USERNAME/$IMAGE:$VERSION .
     ```
   - Apply similar changes to `docker_test` and `docker_push` jobs.

3. **Move to Global Variables**:
   - Define shared variables at the top level:
     ```yaml
     variables:
       USERNAME: "myuser"
       REGISTRY: "docker.io"
       IMAGE: "myapp"
       VERSION: "$CI_PIPELINE_ID"  # Use predefined variable
     ```
   - Remove duplicate variable definitions from `docker_build`, `docker_test`, and `docker_push` jobs.
   - Keep `PASSWORD` in `docker_push` as job-specific:
     ```yaml
     docker_push:
       variables:
         PASSWORD: "secret_password"  # Temporary - will be masked later
       script:
         - echo "$PASSWORD" | docker login -u $USERNAME --password-stdin $REGISTRY
         - docker push $REGISTRY/$USERNAME/$IMAGE:$VERSION
     ```

4. **Test in Deploy Job**:
   - Add a deploy job to verify variable access:
     ```yaml
     deploy:
       script:
         - echo "Username: $USERNAME"
         - echo "Password: $PASSWORD"  # Will be empty/null
     ```

5. **Commit and Run Pipeline**:
   - Save changes in `.gitlab-ci.yml`.
   - Commit with message: "Add variable usage at global and job levels".
   - Trigger pipeline execution.

6. **Verify Execution**:
   - Monitor job logs to confirm variable substitution (e.g., `docker login -u myuser`).
   - Note that `$PASSWORD` appears in plain text (to be fixed in next session).
   - Check that `$CI_PIPELINE_ID` generates a unique numeric version (e.g., `499`).

```diff
! Pipeline Flow: Client Commit → GitLab → Parse .gitlab-ci.yml → Execute Jobs with Variable Substitution → Dynamic Image Versioning
```

> [!WARNING]
> Password variables are visible in logs and committed in plain text, posing a security risk. Implement masking and secure storage in the next session.

This implementation demonstrates efficient variable management, reducing duplication and enabling dynamic configuration for scalable CI/CD pipelines.
