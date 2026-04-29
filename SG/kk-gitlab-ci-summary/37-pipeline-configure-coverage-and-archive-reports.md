# Session 37: Configure Coverage and Archive Reports

## Ignoring Job Failures with `allow_failure`

### Key Concepts
This section explains how to allow job failures to continue pipeline execution without halting dependent jobs.

- The `allow_failure` keyword determines if the pipeline should proceed when a job fails.
- Default value: `allow_failure: false` (pipeline stops on failure).
- Setting `allow_failure: true`: Pipeline continues running subsequent jobs, marks the pipeline as successful with a warning.
- Customization: Allow failure only for specific exit codes using:
  - Single exit code: `allow_failure: 137` (allowed only if exit code is 137).
  - Array of exit codes: `allow_failure: [1, 137]` (allowed if exit code matches any in the array).

> [!NOTE]
> When `allow_failure: true` is used, failed jobs display a warning icon, and the overall pipeline shows a warning sign while marking as successful.

### Lab Demo: Adding `allow_failure` to Code Coverage Job

1. Open the CI/CD YAML file for the pipeline.
2. Locate the `code_coverage` job definition.
3. Add the following line within the job block:
   ```yaml
   allow_failure: true
   ```
4. Commit the changes to the feature branch:
   ```bash
   git add .
   git commit -m "Add allow_failure to code coverage job"
   git push origin feature-branch
   ```
5. Trigger a new pipeline.
6. Observe the pipeline execution:
   - The `code_coverage` job fails (exit code 1) but shows a warning sign.
   - Dependent jobs (e.g., `sample` job) still execute successfully.
   - Overall pipeline status: Successful with warning icon.

### Results
- Failed jobs are ignored, preventing pipeline halt.
- Pipeline succeeds despite failures, useful for non-critical jobs like monitoring or optional checks.

## Archiving and Accessing Coverage Reports

### Key Concepts
The `reports` keyword in jobs archives artifacts like code coverage reports for retrieval.

- Advantages: Enables downloading and analyzingreports (e.g., XML coverage files) from the GitLab UI.
- Retention: Artifacts valid for 3 days by default.
- Access: In the GitLab repository > Builds > Artifacts > Select job > Download files.

> [!TIP]
> Other benefits of coverage reports (e.g., visualization, integration) will be covered in the next session.

### Lab Demo: Accessing Archived Coverage Report

1. Navigate to the repository in GitLab.
2. Go to Builds (CI/CD > Pipelines tab).
3. Select the completed pipeline.
4. Click on "Artifacts" in the left sidebar.
5. For the `code_coverage` job, view available artifacts:
   - `coverage.xml`: The coverage report.
   - Job log.
6. Download `coverage.xml` to your local machine or another location for analysis.

This demonstrates how archived reports provide accountability and debugging capabilities for pipeline jobs. 

> [!IMPORTANT]
> Remember to configure `reports` in job definitions to archive outputs, enabling easy access to test results, logs, or coverage data. 

That's the summary for handling job failures and report archiving in GitLab CI/CD pipelines. Prepared with Claude Code.

<summary>CL-KK-Terminal</summary>
