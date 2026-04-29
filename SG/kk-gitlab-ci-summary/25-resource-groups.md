# Session 25: Resource Groups

## Key Concepts

### Job Timeout

While working with jobs, script errors or dependency issues can sometimes cause job executions to run indefinitely, leading to stalled pipelines and resource consumption. 💡

Implementing timeouts automatically terminates such jobs, optimizing resource utilization and improving pipeline execution speeds. ✅

#### How to Configure Timeout for a Specific Job

You can configure a timeout for a specific job in your GitLab CI/CD pipeline. The job will fail if it runs longer than the specified timeout duration.

- Refer to the CI/CD YAML syntax reference and search for "timeout".
- Add the `timeout` keyword to your job configuration with a natural language time expression:
  - Examples: "3600 seconds", "1 hour", "3H30M" (3 hours and 30 minutes)

⚠️ Choose a meaningful timeout value based on your job's typical execution time.

#### Lab Demo

This demonstration shows how to apply a timeout to a job that normally takes more than 5 minutes to complete (due to a sleep command). We'll set a 10-second timeout to demonstrate the functionality.

**Steps:**

1. Add the following to your job's YAML configuration:
   ```yaml
   job_name:
     script:
       - # your job commands here
     timeout: 10
   ```

2. Commit the changes to trigger the pipeline.

3. View the pipeline in GitLab:
   - Click "View pipeline"
   - A new job will start
   - The job will only run for 10 seconds
   - If the job exceeds 10 seconds, it will terminate and fail

**Expected Behavior:**
- The job attempts to run but fails within 10 seconds
- Error message: "context deadline exceeded" (when trying to pull Docker image for Ruby 3.1)
- Job runtime shows approximately 10 seconds of execution
- Termination occurs on the 11th second
- Pipeline reports: "runner system failure. Please try again."

```diff
+ Timeout correctly terminates long-running jobs
- Job runs indefinitely without timeout, consuming resources
```

> [!IMPORTANT]
> Timeouts prevent resource waste and stalled pipelines. Always set realistic timeout values based on your job's expected duration to avoid premature failures.

> [!WARNING]
> Avoid setting timeouts too aggressively, as legitimate jobs may fail due to temporary network issues or load. Monitor and adjust timeout values based on actual job performance.

This demonstrates how job timeouts optimize GitLab CI/CD pipeline reliability and resource usage. 📝
