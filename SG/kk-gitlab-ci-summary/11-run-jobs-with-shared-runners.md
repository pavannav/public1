# Session 11: Run Jobs with Shared Runners

## Running Jobs with Shared Runners in GitLab CI

### Key Concepts

This session covers how to prepare and run jobs on GitLab's shared runners, focusing on environment setup using `before_script` and `after_script` in CI/CD pipelines. Shared runners are cloud-based virtual machines that execute jobs in isolated environments, often using Docker containers like Ruby for scripting tasks.

#### Pipeline Structure and Job Execution
GitLab CI pipelines are defined in `.gitlab-ci.yml` files and consist of workflows, jobs, and scripts. Each job runs on a shared runner (e.g., Linux small with Ruby Docker container), cloning the repository and executing defined steps in sequence.

- **Workflow**: Assigns a unique name to the pipeline (e.g., for generating ASCII art).
- **Job**: Contains the main logic, such as running commands to generate output.
- **Script Execution Order**:
  1. Repository cloning.
  2. Environment setup (via `before_script`).
  3. Main job script.
  4. Cleanup (via `after_script`).

### Handling Library Dependencies ⚠️
Shared runners provide base environments but may lack specific libraries (e.g., Ruby gems). Installing them directly in the job script can work but is inefficient. Instead, use `before_script` to prepare the environment before job execution, ensuring dependencies are ready without cluttering the main script.

- **Problem Example**: A job fails because the `cowsay` command (for generating ASCII art) is missing in the Ruby container.
- **Solution**: Pre-install required libraries using `before_script`.

### Before and After Scripts
- **`before_script`**: Executes commands before the main job script, ideal for setup tasks like installing dependencies.
- **`after_script`**: Runs after the job script completes, useful for cleanup (e.g., removing temp files or logging).

> [!IMPORTANT]
> Use `before_script` for idempotent setup operations. Avoid long-running tasks here, as they can increase pipeline time. `after_script` should be lightweight and non-blocking.

### Lab Demo: Installing Cowsay Library and Generating ASCII Art

This demo shows creating a pipeline that generates ASCII art using the `cowsay` (corrected from transcript's "kause"/"Kausai") program. Start by defining a basic job without dependencies, observe the failure, then fix it with `before_script`.

#### Initial Pipeline Setup (Fails Due to Missing Dependency)
1. Create or update `.gitlab-ci.yml` in your repository root:
   ```yaml
   workflow:
     name: "Generate ASCII Artwork"

   stages:
     - build

   ascii_job:
     stage: build
     script:
       - cowsay -f dragon "GitLab CI Pipeline" > dragon.txt
       - ls -la dragon.txt | grep dragon
       - cat dragon.txt
   ```
2. Commit and push to trigger the pipeline:
   ```bash
   git add .
   git commit -m "Add ASCII generation job"
   git push origin main
   ```
3. Check pipeline status: The job will fail with an error like "cowsay: command not found" because the Ruby Docker container lacks the cowsay library.

#### Fixing with Before Script
1. Update `.gitlab-ci.yml` to add `before_script` for dependency installation:
   ```yaml
   workflow:
     name: "Generate ASCII Artwork"

   stages:
     - build

   ascii_job:
     stage: build
     before_script:
       - gem install cowsay  # Install cowsay library via RubyGems
     script:
       - cowsay -f dragon "GitLab CI Pipeline" > dragon.txt
       - ls -la dragon.txt | grep dragon
       - cat dragon.txt
     after_script:
       - echo "Job completed successfully"
   ```
2. Commit and push again:
   ```bash
   git add .
   git commit -m "Add before_script to install cowsay"
   git push origin main
   ```
3. Observe in pipeline logs:
   - Runner provisions a Linux small VM with Ruby container.
   - `before_script` executes: `gem install cowsay` installs the CLI tool.
   - Main script runs successfully:
     - Generates ASCII art (e.g., a dragon figure with the message).
     - Verifies file creation.
     - Outputs the content to logs.
   - `after_script` runs: Prints "Job completed successfully".
   - Job status: ✅ Passed.

> [!NOTE]
> The ASCII output (e.g., dragon.txt) will appear in the job logs. This demonstrates how shared runners handle temporary file generation.

### Execution Flow Visualization
```mermaid
flowchart TD
    A[Commit to Repository] --> B[Pipeline Triggered]
    B --> C[Shared Runner Provisioned: Linux + Ruby Docker]
    C --> D[Clone Repository]
    D --> E{Execute before_script?}
    E --> F[Install cowsay with gem]
    F --> G[Run Main Script]
    G --> H[Generate ASCII Art > Save to dragon.txt]
    H --> I[Check File with ls | grep]
    I --> J[Output with cat]
    J --> K{Execute after_script?}
    K --> L[echo 'Job completed']
    L --> M[Job Succeeded ✅]
```

### Linear Process Notation
```diff
! Pipeline Trigger → Shared Runner Starts (Linux Small + Ruby) → Repository Clone → before_script: gem install cowsay → Main Script Execution (cowsay command succeeds) → after_script: Cleanup/Echo → Job Completion
```

### Common Pitfalls and Best Practices
- **Dependency Errors**: Always test libraries in the runner environment. Use Docker images that include common tools when possible.
- **Runner Types**: Shared runners are free but limited. For large jobs, consider GitLab-hosted runners or self-managed ones.
- **Security**: Avoid installing untrusted packages; verify gem sources if custom.

> [!WARNING]
> Shared runners reset after each job, so installed libraries don't persist between runs. Use `before_script` for every job needing custom dependencies.

This session emphasizes practical CI/CD scripting, ensuring jobs run reliably on shared infrastructure by managing environments effectively. Practice by varying commands and monitoring logs for debugging.

**Transcript Corrections Made**:
- Corrected "K8sgpt", "kause", "Kausai" to "cowsay" (referring to the cowsay program for ASCII art generation).
- Corrected "gem install Kausai" to "gem install cowsay" (RubyGems command). No other mistakes identified.
