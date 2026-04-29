# Session 18: Working with Variables at Different Levels

## Working with Variables at Different Levels

### 📝 Key Concepts

- **Masking Variables**: Protect sensitive values like passwords by using masked CI/CD variables to prevent them from appearing in job logs.
- **Variable Levels**: Variables can be defined at project or group level, accessible across all jobs in the pipeline.
- **Variable Attributes**:
  - Type: Key-value pair or file-based.
  - Environment association: Link variables to specific environments (covered later).
  - Protected: Only usable on protected branches.
  - Masked: Hides the value in job logs.
  - Expanded: Allows Shell expansion of the value.
- **Hidden Jobs**: Jobs prefixed with a dot (e.g., `.job_name`) are not executed by default, useful for testing or skipping parts of the pipeline.
- **Security Note**: Users with access to CI/CD settings can still view and edit variable values in the settings page.

### ⚠️ Important Points

> [!WARNING]
> Variables defined in CI/CD settings are accessible to anyone with access to those settings. While masking hides values in logs, the actual values remain visible in the settings UI.

> [!NOTE]
> A project can have up to 8000 variables defined in CI/CD settings.

### 💡 Lab Demo: Creating and Using Masked Variables

1. **Navigate to CI/CD Settings**:
   - Go to the Pipeline Editor in GitLab.
   - Access CI/CD settings from the project menu (Settings > CI/CD).
   - Expand the "Variables" section (initially empty).

2. **Create a Variable**:
   - Click "Add variable".
   - Set the following attributes:
     - Type: Variable (key-value pair).
     - Key: `docker_password` (or your preferred name).
     - Value: `secure_password` (replace with actual password).
     - Environment scope: All (unrestricted).
     - Protected: Unchecked (since no protected branches are used).
     - Masked: Checked (to hide value in job logs).
     - Expanded: Unchecked (not needed for this demo).
   - Add description if desired (optional).
   - Click "Add variable".

3. **Update Pipeline (.gitlab-ci.yml)**:
   - In the job requiring the password (e.g., Docker push job), use the variable with `$DOCKER_PASSWORD` syntax.
   - Example job snippet:
     ```yaml
     docker_push:
       script:
         - docker login -u username -p $docker_password
         - docker push myimage
     ```
   - This variable is now accessible across all jobs in the pipeline as a global variable.

4. **Handle Job Dependencies**:
   - To avoid running unrelated jobs in demo, prefix unnecessary job names with a dot to make them hidden:
     ```diff
     ! Original job names → Hidden job names
     + jobs:
     +   .test_job:
     +     script: echo "Tests skipped"
     +   .build_job:
     +     script: echo "Build skipped"
     +   docker_push:
     +     script: docker login -u $USER -p $docker_password
     +   deploy:
     +     script: echo "Deploy successful"
     ```
   - Hidden jobs appear in the pipeline editor but are not executed.
   - Comment out dependency references if needed (e.g., `needs: .dependent_job`).

5. **Commit and Run Pipeline**:
   - Commit the changes.
   - Run the pipeline via Pipelines tab.
   - In job logs, the masked variable value appears as `[MASKED]`.
   - Verify: Covered jobs succeed if dependencies are met; masked variables hide sensitive data.

### 🔍 Verification

- **Successful Masking**: In Docker push job logs, password appears as `[MASKED]`.
- **Failure Reasons**: Deploy job may fail if dependent artifacts (e.g., files from hidden jobs) are missing.

> [!IMPORTANT]
> Masked variables secure logs but do not encrypt storage. Always limit CI/CD settings access to trusted users. Group-level variables extend scope beyond individual projects.
