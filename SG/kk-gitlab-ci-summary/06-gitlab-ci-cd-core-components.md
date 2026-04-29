# Session 6: GitLab CI/CD Core Components

## Introduction to GitLab CI/CD Pipelines

### Key Concepts
- **Groups and Projects**: GitLab organizes repositories under groups. Create public groups at `gitlab.com/[group-name]` for visibility. Projects are repositories within groups, initialized with a README.
- **Pipeline Setup**: Accessed via "Build > Pipelines" or "Setup CI/CD" button. Configuration stored in `.gitlab-ci.yml` (hidden file at root).
- **Pre-built Templates**: Available for various languages/frameworks (e.g., Android, Go, Gradle, .NET), but require understanding core concepts first.
- **Jobs**: Fundamental building blocks. Each job defines execution logic.
- **Scripts**: Commands executed in runner environment (e.g., echo, ls, cat).
- **Runners**: Virtual machines hosting jobs. Default to GitLab shared runners (small size).
- **Executors**: Environment type (e.g., Docker with container images like Ruby).
- **Stages**: Pipeline phases (default: "test" if unspecified). Jobs run in stages sequentially.
- **Pipeline Execution Flow**: Git checkout → Script execution → Logging → Cleanup.
- **Monitoring**: Pipeline status, duration, logs via UI.

### Comparisons
| Component | Description | Default Value |
|-----------|-------------|---------------|
| Runner | Execution environment VM | GitLab shared runner (small) |
| Executor | Runtime type | Docker |
| Image | Container base | Ruby (for default) |
| Stage | Pipeline phase | test (if not defined) |

### Lab Demo: Creating Your First Pipeline

#### Step 1: Create a New Group
- Navigate to GitLab dashboard.
- Click "Create group" (or equivalent UI element).
- Name: `demos`
- Visibility: Public
- URL: `gitlab.com/demos`
- Leave other settings default and create.

#### Step 2: Create a New Project
- Within the "demos" group, click "New project".
- Name: `Hello World`
- Associate with group: Select "demos".
- Visibility: Public
- Initialize with: README file
- Create project.

📝 **Project Structure**: Initially contains only `README.md` auto-populated with GitLab documentation.

#### Step 3: Set Up CI/CD Pipeline
- From project home, click "Setup CI/CD" (right-side suggestions).
- This leads to "Build > Pipelines > Pipeline editor".
- Click "Configure pipeline" to create `.gitlab-ci.yml`.

#### Step 4: Configure the YAML File
- Discard sample "Hello World" pipeline if present.
- Skip templates/CI/CD catalog for now.

```yaml
first_job:
  script:
    - echo "My first GitLab CI/CD pipeline"
    - echo "Welcome to DevOps training"
    - ls -la
    - cat README.md
```

#### Step 5: Commit the Configuration
- Commit message: Default (or custom, e.g., "Add basic CI/CD configuration").
- Branch: `main`
- Commit and push.

#### Step 6: Monitor the Pipeline
- Navigate to "Build > Pipelines".
- Verify pipeline status: Initially "running", then "passed".
- Click pipeline for details:
  - Stages: Default "test"
  - Job: "first_job"
  - Logs: Show runner details, OS, executor, checkout steps, script execution.

```diff
! Pipeline Flow: Commit → Runner Allocation → Docker Executor (Ruby Image) → Code Checkout → Script Execution → Success/Error
```

- **Log Breakdown**:
  - Preparation: Executor setup, image pull.
  - Environment: Repository checkout (latest commit).
  - Execution: Commands output in container.
  - Cleanup: Project directory removal.

> [!NOTE]
> Runners are shared by default (no cost for basic usage). Execution uses Docker containers for isolation.

> [!TIP] 💡
> Hidden files like `.gitlab-ci.yml` are not listed by `ls` unless `-a` flag is used.

#### Step 7: Review Results
- Duration, runner type, pipeline ID visible in UI.
- Symlink or setup issues resolve automatically in shared runners.

## Looking Ahead
Next sessions cover core components in detail: runners, executors, runner types, and stages.

 > [!IMPORTANT]
> No pre-commit hooks or configurations needed for basic pipelines. GitLab handles defaults.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>  
<summary>CL-KK-Terminal</summary>  5/1/2024

---

# 00_Course_Summary_Tracker.md

## Course Overview
**Title**: GitLab CI/CD Training Course  
**Last Updated**: 2026-04-28  
**Total Sessions**: 6  
**Completed Sessions**: 6  

## Progress Tracker
- [x] Session 1: [Topic Name 1] - Completed
- [x] Session 2: [Topic Name 2] - Completed
- [x] Session 3: [Topic Name 3] - Completed
- [x] Session 4: [Topic Name 4] - Completed
- [x] Session 5: [Topic Name 5] - Completed
- [x] Session 6: GitLab CI/CD Core Components - Completed

## Session Summaries

### Session 1: [Topic Name 1]
**Topics Covered**: [Brief overview]  
**Key Concepts**: [Summary]  
**Notable Commands**: [List]

### Session 2: [Topic Name 2]
**Topics Covered**: [Brief overview]  
**Key Concepts**: [Summary]  
**Notable Commands**: [List]

### Session 3: [Topic Name 3]
**Topics Covered**: [Brief overview]  
**Key Concepts**: [Summary]  
**Notable Commands**: [List]

### Session 4: [Topic Name 4]
**Topics Covered**: [Brief overview]  
**Key Concepts**: [Summary]  
**Notable Commands**: [List]

### Session 5: [Topic Name 5]
**Topics Covered**: [Brief overview]  
**Key Concepts**: [Summary]  
**Notable Commands**: [List]

### Session 6: GitLab CI/CD Core Components
**Topics Covered**: Creating groups, projects, basic pipelines; job configuration, runners, executors, stages, logs.  
**Key Concepts**: `.gitlab-ci.yml` structure with jobs and scripts; default shared runners and Docker executors; pipeline flow from commit to execution.  
**Notable Commands**: `echo`, `ls -la`, `cat README.md`; YAML structure for jobs and scripts.

🤖 Generated with [Claude Code](https://claude.com/claude-code)  
Co-Authored-By: Claude <noreply@anthropic.com>  
<summary>CL-KK-Terminal</summary>  5/1/2024 (Placeholder date; update as needed)
