# Session 19: Masking Variables using Project Settings

## Predefined Variables
📝 **Key Concepts**:
Predefined CI/CD variables are automatically provided by GitLab in every pipeline. They contain information about jobs, pipelines, and other values, enabling flexible and dynamic scripts without hardcoding sensitive data. Availability varies: some are accessible as soon as the pipeline is created (for pipeline config or job scripts), while others only during job execution on runners. Additional variables are specific to merge requests or external pull requests.

These variables allow dynamic configuration and avoid embedding secrets directly in GitLab CI/CD YAML files. There are hundreds available; refer to GitLab's dedicated documentation for examples.

💡 To view accessible variables during job execution, use the `export` command in scripts, which lists all available variables.

## Lab Demo: Exploring Predefined Variables in GitLab
This demo creates a new project and configures a pipeline to demonstrate predefined variables.

### Step 1: Create a New Project
1. Navigate to your GitLab instance.
2. Click "New project" > "Create blank project."
3. Name the project: `predefined variables`.
4. Set the project slug to `predefined-variables`.
5. Place it in the `demos` group.
6. Set visibility to `Public`.
7. Enable "Initialize with a README file."
8. Click "Create project."

The project will contain only a README file initially.

### Step 2: Configure the CI/CD Pipeline
Remove the default `.gitlab-ci.yml` content and add the following YAML:

```yaml
workflow:
  name: "exploring predefined variables pipeline"

jobs:
  export_variables_job:
    script:
      - export

  generic_predefined_variables:
    script:
      - echo "User Login: $GITLAB_USER_LOGIN"
      - echo "User Email: $GITLAB_USER_EMAIL"
      - echo "Commit Author: $CI_COMMIT_AUTHOR"
      - echo "Commit Branch: $CI_COMMIT_BRANCH"
      - echo "Project Name: $CI_PROJECT_NAME"
      - echo "Project URL: $CI_PROJECT_URL"
      - echo "Job Stage: $CI_JOB_STAGE"
      - echo "Workflow Name: $CI_PIPELINE_NAME"  # Only available if workflow name is defined
      - echo "Pipeline ID: $CI_PIPELINE_ID"
      - echo "Pipeline Source: $CI_PIPELINE_SOURCE"

  merge_request_predefined_variables:
    script:
      - echo "MR Labels: $CI_MERGE_REQUEST_LABELS"
      - echo "MR Target Branch: $CI_MERGE_REQUEST_TARGET_BRANCH_NAME"
      - echo "MR Assignees: $CI_MERGE_REQUEST_ASSIGNEES"
      - echo "MR Source Branch: $CI_MERGE_REQUEST_SOURCE_BRANCH_NAME"
      - echo "MR Title: $CI_MERGE_REQUEST_TITLE"
```

⚠️ The merge request variables (in the third job) are only populated during merge request pipelines. They will not display values in regular commits to the main branch.

### Step 3: Commit and Run the Pipeline
1. Commit the `.gitlab-ci.yml` changes to the `main` branch.
2. Pipeline triggers automatically.

The pipeline includes three parallel jobs:
- `export_variables_job`: Lists all available variables via `export` (typically ~130+ variables, including CI details, job info, project data, runner details, and more).
- `generic_predefined_variables`: Echoes specific variables like user details, project info, and pipeline metadata.
- `merge_request_predefined_variables`: Attempts to access MR-specific variables (values absent in non-MR contexts).

✅ **Expected Output**:
- First job outputs numerous variables (e.g., commit author, branch, message, job/pipeline IDs, server details).
- Second job prints the echoed values, demonstrating access via `$VARIABLE_NAME`.
- Third job succeeds but shows empty/null values for MR variables, as no merge request exists.

> [!NOTE]
> Merge request variables require an active merge request (equivalent to a GitHub pull request). These will be explored further in the next session.

> [!IMPORTANT]
> Use these variables dynamically in scripts to access context-specific data without hardcoding, enhancing pipeline flexibility and security.
