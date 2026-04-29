# Session 12: Install Third Party Libraries using before_script

## 📝 Key Concepts

### Executing Shell Scripts in GitLab CI Jobs

GitLab CI allows you to organize commands into dedicated shell scripts instead of listing them directly in the `gitlab-ci.yaml` file.

- **Benefits**:
  - Better organization and readability
  - Reusability across jobs
  - Easier maintenance

- **Implementation Steps**:
  1. Create a shell script in your repository (typically at root level)
  2. Reference the script in the job's `script` section using `./script_name.sh`
  3. Ensure executable permissions are set

💡 **Example**: Create `ascii-script.sh` with installation commands for figlet (ASCII art library).

### Handling Permissions with before_script

Shell scripts often fail due to insufficient permissions. Use the `before_script` section to set up the environment before the main job execution.

- **before_script Purpose**:
  - Executes setup commands before the main script
  - Ideal for installing dependencies, setting permissions, or environment preparation
  - Runs even if the main job fails

```diff
+ Best Practice: Use before_script for consistency across job configurations
```

> [! IMPORTANT]
> Always set proper permissions for scripts using `chmod +x` in before_script to avoid "permission denied" errors.

### Pipeline Workflow and Best Practices

GitLab pipelines automate the execution flow, but require careful commit message management.

- **Editing Environment**:
  - Use GitLab Web IDE for quick file creation and editing
  - Commit changes trigger new pipeline runs automatically

- **Commit Messages**:
  - Use descriptive messages to identify pipeline triggers
  - Helps track what changes caused specific pipeline executions

```diff
+ Positive: Clear commit messages improve pipeline traceability
- Negative: Vague messages like "updated" reduce debugging effectiveness
```

## 🔧 Lab Demo: Installing Figlet Library and Executing Script

Follow these steps to create a shell script for installing figlet, execute it in a GitLab CI job, and resolve permission issues using `before_script`.

### Step 1: Create Shell Script via Web IDE

1. Navigate to your GitLab repository
2. Click **Edit in Web IDE** (opens Visual Studio Code interface)
3. Create new file: `ascii-script.sh` at root level

4. Add the following content to `ascii-script.sh`:

   ```bash
   #!/bin/bash
   apt-get update
   apt-get install -y figlet
   ls -la
   ```

   - `#!/bin/bash`: Shebang header for bash execution
   - `apt-get update`: Updates package index
   - `apt-get install -y figlet`: Installs figlet library for ASCII art generation
   - `ls -la`: Lists all files including hidden ones for verification

### Step 2: Configure Job to Execute Script

Update your `.gitlab-ci.yaml` file in the Web IDE:

1. Locate the job configuration
2. Replace existing script commands with script execution:

   ```yaml
   # Existing script block (replace this)
   script:
     - apt-get update
     - apt-get install -y figlet

   # Replace with script execution
   script:
     - ./ascii-script.sh
   ```

### Step 3: Commit Changes

1. Add descriptive commit message: `"Execute library installation via shell script"`
2. Commit to main branch
3. Pipeline will trigger automatically

### Step 4: Monitor Initial Pipeline Failure

1. Check pipeline status - expect failure
2. Navigate to the job logs
3. Observe error: `"./ascii-script.sh: permission denied"` with exit code 1

> [!WARNING]
> Missing executable permissions is common when scripts are added without setting them correctly.

### Step 5: Fix Permissions with before_script

Update `.gitlab-ci.yaml` again in Web IDE:

1. Add `before_script` section before the `script` section:

   ```yaml
   job_name:
     image: ruby:latest
     before_script:
       - chmod +x ascii-script.sh
     script:
       - ./ascii-script.sh
   ```

   - `chmod +x ascii-script.sh`: Grants execute permissions to the script

### Step 6: Commit Permissions Fix

1. Use commit message: `"Add executable permissions for shell script"`
2. Commit changes
3. New pipeline will run

### Step 7: Verify Successful Execution

1. Monitor pipeline status - should succeed
2. Check job logs in the "execute script" stage:

   ```
   $ chmod +x ascii-script.sh
   $ ./ascii-script.sh
   [...package installation logs...]
   Get:1 http://deb.debian.org/debian bullseye/main amd64 figlet amd64 2.2.5-3 [946 kB]
   [...listing contents...]
   .git/
   .gitlab-ci.yml
   README
   ascii-script.sh
   ```

✅ **Success Indicators**:
- Figlet library installed
- Script executed successfully
- `ls -la` shows repository files including hidden ones

## ⚠️ Common Pitfalls and Solutions

| Issue | Symptom | Solution |
|-------|---------|----------|
| Permission Denied | Job fails with exit code 1 | Add `chmod +x script.sh` in `before_script` |
| Missing Dependencies | Library install fails | Ensure `apt-get update` before `apt-get install` |
| Incorrect Path | Script not found | Use `./` prefix for root-level scripts |

> [!NOTE]
> The `ascii-script.sh` creates ASCII art capabilities, but these patterns apply to any third-party library installation via shell scripts in GitLab CI.

## 📋 Key Takeaways

This session demonstrates efficient CI/CD practices for library management:

1. **Script Organization**: Encapsulate installation commands in dedicated scripts for better maintainability
2. **Permission Management**: Use `before_script` for environment setup tasks like setting executable permissions
3. **Pipeline Monitoring**: Log reviews reveal execution flow and potential issues
4. **Iterative Improvement**: Address failures through targeted pipeline updates and recompilations

```diff
! Workflow: Script Creation → Execute → Permission Fix → Success
```
