# Session 10: GitLab CI/CD Architecture - SaaS

## GitLab CI/CD Architecture - SaaS

### Key Concepts: Shared Runners in GitLab SaaS

💡 GitLab SaaS provides shared runners for automated testing and deployment on different platforms.

- **Available Runners**:
  - Linux runners
  - GPU runners  
  - Windows runners (currently in beta)
  - macOS runners (currently in beta)

📝 Runners use Google Container-Optimized OS virtual machines with specific executors.

| Runner Type    | Status   | Executor     | Key Specs                                  |
|----------------|----------|--------------|--------------------------------------------|
| Linux Medium   | Stable   | Docker       | CPU/Memory/Storage limits, regional variants |
| GPU            | Stable   | Docker       | Includes GPU hardware                      |
| Windows        | Beta     | Virtual Machine | Windows Server OS, slower startup          |
| macOS          | Beta     | Virtual Machine | M1 chip, premium/ultimate plan required    |

✅ Use `tags` keyword in `.gitlab-ci.yml` to select specific runners from available ones.

### Key Concepts: Runner Selection with Tags

💡 Tags allow routing jobs to specific runners based on platform requirements.

> [!NOTE]  
> Available runners and their tags are visible in project CI/CD settings under the "Runners" section.

> [!WARNING]  
> Beta runners like macOS and Windows may have limited availability and longer queue times.

### Lab Demo: Configuring Jobs on Different Shared Runners

📝 This demo shows how to configure a pipeline with jobs running on Windows, Linux, and macOS shared runners.

**Step 1**: Access CI/CD settings to view available runners
- Navigate to Project Settings → CI/CD → Runners
- Verify shared runners are enabled
- Note available tags (e.g., "shared-windows", "saas-linux-medium", "saas-macos-medium-m1")

**Step 2**: Edit `.gitlab-ci.yml` in Pipeline Editor

```yaml
windows_job:
  tags:
    - shared-windows
  script:
    - echo "Running on Windows shared runner"
    - systeminfo

linux_job:
  tags:
    - saas-linux-medium
  script:
    - echo "Running on Linux shared runner"
    - cat /etc/os-release

macos_job:
  tags:
    - saas-macos-medium-m1
  script:
    - echo "Running on macOS shared runner"
    - sw_vers
```

**Step 3**: Commit changes and trigger pipeline

- Commit the `.gitlab-ci.yml` changes to main branch
- Pipeline runs automatically when changes are detected

**Step 4**: Monitor pipeline execution

- Access Pipelines → Click running pipeline → View job details
- Jobs execute in parallel by default

> [!IMPORTANT]  
> Linux jobs typically complete faster using Docker executor, while Windows and macOS jobs take longer due to virtual machine setup (4+ minutes for VM creation).

**Expected Results**:

- **Linux Job**: 
  - Uses Docker executor on Linux medium runner
  - Output shows Debian OS details from `/etc/os-release`
  - ⚠️ Completes in seconds (image pull + script execution)

```diff
! Linux Job Flow: Runner Assignment → Docker Setup → Checkout Repo → Execute Script → OS Info Display
```

- **Windows Job**: 
  - Uses Virtual Machine executor on Windows shared runner
  - Output shows Windows Server 2019 Datacenters on Google Compute Engine
  - ⚠️ Takes ~5-6 minutes total (VM creation + system info)

```diff
! Windows Job Flow: VM Creation (4min) → Checkout Repo → Execute Script → System Info Display
```

- **macOS Job**: 
  - Stays in pending state due to beta restrictions (requires premium/ultimate plan)
  - ❌ Manual cancellation required if using trial account

```diff
+ Success: Jobs run on specified platforms using tag selection
- Warning: Beta runners may not be available on free accounts
! Alert: Use first-defined tags when multiple runners match
```
