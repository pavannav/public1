# Session 36: Artifacts - Unit Test Reports

## Configuring Code Coverage Job

### Key Concepts

Code coverage measures how many lines of application code have been tested, providing a percentage of test coverage. In GitLab CI/CD, you can configure dedicated jobs to run code coverage and collect reports as artifacts.

💡 **Parallel Job Execution**: Multiple jobs in the same stage can run simultaneously, improving pipeline efficiency.

```diff
! Unit Testing Job → Code Coverage Job → Sample Job (with dependency)
```

### Lab Demo: Setting Up Code Coverage Job

1. **Copy and Modify Unit Testing Job**:
   - Duplicate the existing unit testing job configuration
   - Change job name to `code_coverage` (jobs cannot have duplicate names)

2. **Job Configuration**:
   - **Stage**: test (same as unit testing for parallel execution)
   - **Image**: node:latest
   - **Before Script**: 
     ```bash
     npm install
     ```
   - **Script**:
     ```bash
     npm run coverage
     ```

3. **Artifacts Configuration**:
   ```yaml
   artifacts:
     expire_in: 3 days
     when: always
     name: code_coverage_result
     reports:
       coverage_report:
         coverage_format: cobertura
         path: coverage/cobertura-coverage.xml
   ```

💡 **Artifacts Keywords**:
- `expire_in`: How long to retain artifacts (e.g., 3 days)
- `when: always`: Upload artifacts regardless of job success/failure
- `name`: Optional naming for downloading artifacts
- `reports`: Specifies report types and formats

## Code Coverage Reports

### Key Concepts

GitLab CI/CD supports various report formats for different types of reports. Code coverage reports use the Cobertura XML format, typically stored in the coverage directory.

📝 **Coverage Report Path**: Default location is `coverage/cobertura-coverage.xml` - adjust based on your application's output directory.

### Coverage Percentage Extraction

The `coverage` keyword extracts the code coverage percentage from job logs using regular expressions and displays it in the GitLab UI.

```yaml
coverage: '/All lines: (\d+\.\d+)%/'
```

💡 **Regex Patterns**: GitLab provides pre-built patterns for different tools in CI/CD documentation. For NYC tool, use the specific regex pattern that matches your tool's output format.

### Job Dependencies

Use the `needs` keyword to create dependencies between jobs, ensuring certain jobs run only after others complete.

> [!NOTE]
> The `needs` keyword takes an array of job names that must complete before the current job starts.

### Lab Demo: Adding Job Dependencies

1. **Create Sample Job**:
   ```yaml
   sample_job:
     image: alpine:latest
     needs:
       - code_coverage
     script:
       - echo "Testing sample job"
   ```

2. **Dependency Behavior**:
   - If a needed job fails, the dependent job is skipped
   - Pipeline continues with successful jobs; failed jobs don't block parallel jobs

```diff
! Pipeline Execution Flow:
+ Unit Testing: ✔ Running
+ Code Coverage: ✔ Running (Parallel)
+ Sample Job: ⏳ Waiting → Runs after Code Coverage completes
```

### Coverage Thresholds and Job Failures

Code coverage jobs can fail if configured thresholds aren't met.

⚠️ **Common Issue**: Coverage below threshold causes job failure
- Example: Threshold set to 90%, actual coverage at 88.88%
- Job fails even if tests pass, due to coverage requirements

```diff
+ Job Success: Tests pass with coverage 95%
- Job Failure: Tests pass but coverage=88.88% < threshold=90%
```

### Pipeline Visualization

Jobs display coverage percentages in multiple locations:

| Location | Display |
|----------|---------|
| Job Details | Coverage: 88.88% |
| Pipeline Jobs Tab | Code Coverage percentage |
| Job Logs | Percentage from output |

> [!TIP]
> Coverage percentages are extracted using the regex pattern from job logs and automatically displayed in the GitLab UI.

> [!WARNING]
> If a job with dependencies fails, dependent jobs are skipped entirely, not failed with an error code.

> [!IMPORTANT]
> Artifacts expire based on the `expire_in` setting - plan accordingly for report retention needs.
