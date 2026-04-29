# Session 42: GitLab CI/CD Image and Service Options

## GitLab CI/CD Image and Service Options

### Key Concepts

#### GitLab Hosted Runners and Pre-installed Software
✅ GitLab provides hosted runners for pipeline execution
✅ These runners include pre-installed software: language runtimes, package managers, CLI utilities, web browsers, test suites, Docker images
✅ For jobs, you can use Docker images directly in runners
💡 Example: Ubuntu latest runner with extensive pre-installed tools

#### Default Container Images
- GitLab hosted Linux-based SAST runner defaults to Ruby 3.1 container
- Simplifies setup for Ruby projects by providing pre-configured environment
- Focuses on code instead of configuration management

#### Considerations for Non-Default Environments
⚠️ Using Ruby container for non-Ruby applications can cause confusion and errors
📝 May need different runtime versions or packages not available by default
💡 Solution: Install required runtimes/packages using before_script

#### Example: Installing Node.js Runtime
```yaml
unit_testing:
  before_script:
    - # Commands to install NodeJS Runtime version 20
  script:
    - # Unit testing steps
```

#### Impact on CI/CD Costs
🚨 Installing specific runtimes/packages increases pipeline execution time
🚨 Increased time leads to higher GitLab CI/CD billing costs
✅ Use pre-built image containers as cost optimization strategy

### Image Containers in GitLab CI/CD

#### Purpose and Benefits
✅ **Definition**: Pre-built sandboxes for code execution with specific tools and environments
✅ **Isolation**: Each job runs in its own container, preventing dependency conflicts
✅ **Reproducibility**: Jobs run consistently across different runner machines
✅ **Control**: Choose exact tools and versions for efficiency and security

#### Configuration
- Use `image` keyword to specify Docker image for the job
- Additional options: pull policies, entry point, etc.

#### Example: Node.js Image Container
```yaml
unit_testing:
  image: node:20
  script:
    - npm install
    - npm test
```

#### Execution Process
1. GitLab provisions Linux hosted runner
2. Runner creates and runs specified Docker container
3. All job steps execute within the container
4. No need to install runtime separately

### Service Containers

#### Overview
✅ **Definition**: Docker containers providing additional resources/services for jobs
✅ **Purpose**: Host specialized services like databases for testing
✅ Act as expandable tools/workbench for jobs

#### Examples of Services
- MySQL instance for database testing
- Docker-in-Docker for container building
- Custom services tailored to specific needs

#### Key Characteristics
- Run in separate containers from main job
- Isolated environment preventing interference
- Provide specific resources and capabilities

#### Configuration
- Use `services` keyword to specify additional containers
- Service containers accessible by main job container
- Both containers run in same bridge network

#### Example: MongoDB Service Container
```yaml
unit_testing:
  image: node:20
  services:
    - image: mongo:latest
      alias: mongo
  script:
    - git checkout
    - npm install
    - npm test -- --db=mongo:27017
```

#### Execution Process
1. Pipeline runs two containers: job container (Node.js) and service container (MongoDB)
2. MongoDB container populates test data
3. Job container performs: checkout, dependency install, unit tests
4. Tests connect to MongoDB via alias: mongo:27017

### Network Communication
✅ **Bridge Network**: Job and service containers share user-defined bridge network
✅ **Port Exposure**: All ports exposed between containers
✅ **Service Access**: Use configured alias as hostname (e.g., `mongo:27017`)

### Best Practices

> [!IMPORTANT]
> For unit testing and code coverage, use dedicated test databases or services - never connect to production databases as it can impact performance.

> [!NOTE]
> Image containers eliminate the need for runtime installation, reducing setup time and costs.

> [!WARNING]
> Installing runtimes in before_script increases pipeline execution time and billing costs - prefer image containers when possible.

#### Implementation Lab Demo

##### Step 1: Configure Job with Node.js Image
- Add `image: node:20` to your job definition
- This eliminates need for before_script runtime installation

##### Step 2: Add Service Container
- Under job, add `services:` block
- Specify MongoDB image with `alias: mongo`

##### Step 3: Update Test Commands
- Modify unit test scripts to connect to `mongo:27017` instead of production DB
- Ensure tests use test data populated in MongoDB service container

##### Step 4: Pipeline Execution
- GitLab provisions hosted runner with Linux OS
- Runner creates Node.js Docker container
- Simultaneously creates MongoDB Docker container
- Both containers communicate via bridge network
- Job executes all steps: repo checkout, dependency install, unit tests with MongoDB connection

> [!NOTE]
> No transcript corrections were necessary - all content was accurate. The discussion focused on evolving strategies for selecting runtime containers in CI/CD pipelines to support diverse project stacks and workload requirements.

<summary>
CL-KK-Terminal: Session 42 study guide created, covering GitLab CI/CD image and service containers with examples, benefits, and implementation steps.
</summary>
