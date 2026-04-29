# Session 22: Raise a Merge Request & Use Rules at Workflow Level

## Overview

In this session, we build upon the previous session where rules were defined at the job level to include or exclude jobs. Here, we focus on implementing rules at the workflow level to control whether an entire pipeline executes based on multiple conditions, and demonstrate creating a merge request to trigger pipelines.

## Key Concepts

### Rules at Workflow Level

- **Workflow Rules vs. Job Rules**: Job-level rules control individual job execution (include/exclude jobs), while workflow-level rules determine if the entire pipeline is created and runs.
- **Variables with Rules**: You can associate variables with workflow rules. If the condition matches, the defined variables are applied globally to the pipeline.
- **Rule Conditions**: Use conditional statements (if, changes, etc.) to evaluate branch names, merge request events, file changes, and more.

### Merge Request Integration

- **Merge Request Variables**: Utilize predefined CI/CD variables like `$CI_MERGE_REQUEST_SOURCE_BRANCH_NAME` and `$CI_MERGE_REQUEST_TARGET_BRANCH_NAME` for conditional logic.
- **Pipeline Triggering**: Pipelines can be triggered based on merge request events when conditions match (e.g., source branch pattern and file changes).

### Common Operators and Patterns

- **Comparison Operators**: Use `==` for exact matches.
- **Regex Matching**: Employ `=~` operator for pattern matching (e.g., `=~ /^feature/`).
- **Logical Operators**: Combine conditions with AND/OR logic within rules.
- **Changes Keyword**: Specify files/directories that must be modified to trigger the pipeline.

## Lab Demo: Creating Workflow Rules and Merge Request

### Step 1: Create a New Project

1. Create a new public project named "Generic Project" in the "demos" group.
2. Include a README file.
3. Configure CI/CD by setting up a `.gitlab-ci.yml` file.

### Step 2: Initial Pipeline Configuration

Add the following basic workflow to `.gitlab-ci.yml`:

```yaml
workflow:
  name: exploring GitLab CI concepts

stages:
  - deploy

deploy_job:
  stage: deploy
  script:
    - echo "Deploying application"
    - echo "Application successfully deployed to ${DEPLOY_ENV} environment"
```

### Step 3: Add Workflow-Level Rule for Main Branch

Update `.gitlab-ci.yml` to include workflow rules:

```yaml
workflow:
  name: exploring GitLab CI concepts
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
      variables:
        DEPLOY_ENV: production

stages:
  - deploy

deploy_job:
  stage: deploy
  script:
    - echo "Deploying application"
    - echo "Application successfully deployed to ${DEPLOY_ENV} environment"
```

### Step 4: Commit and Trigger Pipeline on Main Branch

1. Commit the changes to the `main` branch.
2. Verify the pipeline triggers and runs; the job should output "Application successfully deployed to production environment" because `DEPLOY_ENV` is set to "production".
3. Wait for the job to complete.

### Step 5: Add Additional Workflow Rule for Feature Branches via Merge Requests

Expand the workflow rules to include conditions for merge requests:

```yaml
workflow:
  name: exploring GitLab CI concepts
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
      variables:
        DEPLOY_ENV: production
    - if: '$CI_MERGE_REQUEST_SOURCE_BRANCH_NAME =~ /^feature/'
      if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
      changes:
        - README.md
      variables:
        DEPLOY_ENV: testing

stages:
  - deploy

deploy_job:
  stage: deploy
  script:
    - echo "Deploying application"
    - echo "Application successfully deployed to ${DEPLOY_ENV} environment"
```

### Step 6: Push Changes to a Feature Branch

1. Create or switch to a new branch (e.g., `feature-branch`).
2. Push the updated `.gitlab-ci.yml` to this branch.
3. Commit the changes. **Note**: No pipeline triggers yet, as the rule requires a merge request event.

### Step 7: Create a Merge Request

1. From the feature branch, create a new merge request targeting `main`.
2. Initially, no pipeline is triggered because the `changes` condition (README.md) isn't met.
3. Edit the README.md file in the feature branch (e.g., change content to "Testing runs").
4. Commit the README.md change.
5. Refresh the merge request; the pipeline now triggers for the merge request event.
6. Verify the job runs and outputs "Application successfully deployed to testing environment" using the `testing` value for `DEPLOY_ENV`.

## Important Notes

> [!IMPORTANT] 
> Workflow rules control pipeline creation, not individual job execution. Use variables at the workflow rule level for global pipeline configuration. Always test merge request pipelines with the correct conditions (branch pattern, pipeline source, file changes).

> [!WARNING] 
> Pipelines will only trigger if ALL specified conditions (e.g., source branch regex, merge request event, file changes) are met. Incorrect file paths in the `changes` keyword can prevent pipeline execution.

> [!NOTE] 
> The `changes` keyword is powerful for triggering pipelines only when specific files or directories are modified, helping optimize CI/CD runs in large projects.

This session demonstrates practical workflow-level rules for controlling pipeline execution in merge request scenarios, building directly on job-level rules from the previous session. 💡
