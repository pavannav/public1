# Session 24: Pipeline Schedules

## Resource Groups

**Key Concepts**

GitLab CI/CD allows multiple pipelines to run concurrently, but for critical operations like deployments, you need sequential execution to avoid conflicts. Resource groups solve this by ensuring mutual exclusivity for jobs across pipelines.

### Why Use Resource Groups?
- Prevent concurrent execution of jobs that could interfere with each other
- Ideal for deployment scenarios where runtime conflicts could cause issues
- Ensures serialization of critical operations

### Basic Functionality
- Create a resource group using the `resource_group` keyword in CI/CD YAML
- Jobs with the same resource group cannot run simultaneously
- When multiple jobs are queued for the same resource group, only one runs at a time
- Others wait until the resource becomes available

📝 Reference: GitLab CI/CD YAML syntax reference under "Resource Groups"

### Process Modes
Resource groups support three process modes to control job execution order:

| Mode | Description | Execution Order |
|------|-------------|-----------------|
| `unordered` | Default mode - no guaranteed order, any queued job can start first | Random/available |
| `oldest_first` | Executes jobs in order of creation, oldest first | FIFO (First In, First Out) |
| `newest_first` | Executes jobs starting with the most recently created | LIFO (Last In, First Out) |

### Process Mode Examples
Consider three deployment commits creating separate pipelines, each with build and deploy jobs:

#### Unordered Mode
- Three deployments (Deploy 1, Deploy 2, Deploy 3) are queued
- No guarantee about which deployment runs first
- Any deployment can execute first, others wait

#### Oldest First Mode
- Deploy 1 → Deploy 2 → Deploy 3 (sequential by creation time)

#### Newest First Mode  
- Deploy 3 → Deploy 2 → Deploy 1 (sequential, newest first)

> [!IMPORTANT]
> The default process mode is `unordered`. To change modes, use the GitLab CI REST API.

### Changing Process Modes
⚠️ Process mode changes require GitLab CI REST API calls, not YAML configuration.

```diff
+ Default: unordered mode
- To change: Use GitLab CI REST API
```

## Lab Demo: Implementing Resource Groups

### Step 1: Configure Resource Group in YAML
Add the `resource_group` keyword to your deployment job:

```yaml
deploy:
  script:
    - echo "Deploying to production"
    - sleep 300  # 5 minutes for demo
  resource_group: production
```

### Step 2: Trigger Initial Pipeline
1. Commit the changes to `main` branch
2. Navigate to **CI/CD → Pipelines** in GitLab UI
3. Verify the pipeline triggers and the deploy job starts running

### Step 3: Schedule Additional Pipeline
1. Go to **CI/CD → Pipeline Schedules**
2. Manually run a scheduled pipeline for the same `main` branch
3. Observe the second pipeline status

### Step 4: Observe Job Waiting Behavior
- Two pipelines will appear in the Pipelines view
- The second pipeline's deploy job shows "waiting" status
- First pipeline's deploy job (with resource group) prevents concurrent execution
- Waiting job displays: "Waiting for resource production"

### Step 5: Cancel First Pipeline
- Click "Cancel running pipeline" on the first pipeline
- Or cancel the specific deploy job within the pipeline
- The waiting job in the second pipeline automatically starts

### Results
The resource group ensures deployment serialization:

```diff
! Pipeline 1: Deploy job running → Pipeline 2: Deploy job waiting
! After canceling Pipeline 1 → Pipeline 2: Deploy job running
```

> [!WARNING]
> Canceling pipelines during deployment may leave systems in inconsistent states. Use with caution in production.

### Benefits of Resource Groups
- ✅ Prevents deployment conflicts
- ✅ Enforces sequential execution for critical operations  
- ✅ Supports strategic concurrency control
- ✅ Configurable process modes for different needs

> [!NOTE]
> Resource groups are particularly valuable for production deployments, database migrations, and other operations requiring exclusive access.
