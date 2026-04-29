# Session 15: Using stage vs stages Keyword

## Key Concepts

💡 **Artifacts Overview**: Artifacts in GitLab CI/CD allow storing and sharing data generated during job execution. Files or directories can be saved as artifacts and automatically downloaded to subsequent jobs unless controlled by dependencies or needs keywords. Artifacts are also available for download in the GitLab UI if under the max size limit.

📝 **Key Points on Artifacts**:
- Artifacts are attached to jobs based on success, failure, or always.
- By default, artifacts from successful jobs are downloaded to all later jobs.
- Use `dependencies` or `needs` keywords to control artifact sharing between jobs.
- Artifacts are stored in GitLab or external storage (e.g., GCP) and have a default 30-day expiry.

### Artifact Configuration Options

Artifacts offer various configuration options to customize behavior:

| Option | Description | Examples |
|--------|-------------|----------|
| `paths` | List of files/directories to save as artifacts | `paths: [dragon.txt, build/libs/*]` |
| `expire_in` | Time period before artifacts are deleted | `30 days`, `3 hours`, `never` (subscription-dependent) |
| `expose_as` | Name for artifact in Merge Request UI | `expose_as: 'Build Artifacts'` |
| `name` | Unique identifier for the artifact | `name: 'dragon.txt'` |
| `when` | Condition for creating artifacts (job status) | `on_success`, `on_failure`, `always` |

```diff
+ Positive: Artifacts enable seamless data transfer between jobs across different pipeline stages.
+ Positive: Automatic download saves manual file sharing efforts.
+ Positive: UI access allows easy inspection and download post-job completion.
```

```diff
- Negative/Warning: Large artifacts may impact pipeline performance and storage costs.
- Negative/Warning: Expiry times should be set based on retention policies to avoid clutter.
```

> [!IMPORTANT]
> Artifacts bridge the gap between jobs, especially when jobs belong to different stages defined by the global `stages` keyword, while the per-job `stage` keyword assigns individual jobs to those stages.

## Lab Demos

### Configuring Artifacts for a Job

In this demo, we'll configure artifacts for the `build` job to store the generated `dragon.txt` file, making it accessible to `test` and `deploy` jobs in later stages.

**Steps**:

1. **Navigate to the Build Job Configuration**:
   - Open `.gitlab-ci.yml` file.
   - Locate the `build` job definition.

2. **Add Artifact Section**:
   - Inside the `build` job, add an `artifacts` keyword.
   - Select options like:
     - `when: on_success` (create artifact only on job success).
     - `expire_in: 30 days` (use default or customize, e.g., `3 days`).
     - `name: dragon.txt` (unique name for identification).
     - `paths: [dragon.txt]` (path of the file/commit directory).

   Example YAML snippet:
   ```yaml
   build:
     script:
       - echo "Creating dragon.txt"
       - echo "Flying dragon!" > dragon.txt
     artifacts:
       when: on_success
       expire_in: 30 days
       name: dragon.txt
       paths:
         - dragon.txt
   ```

3. **Commit Changes**:
   - Commit the updated `.gitlab-ci.yml` to trigger a new pipeline.

4. **Run and Monitor Pipeline**:
   - Navigate to CI/CD > Pipelines.
   - Wait for jobs to complete.
   - Observe logs for artifacts upload/download.

### Observing Artifacts in Pipeline Logs

- **Build Job**:
  - New step: "Uploading artifacts for successful jobs".
  - Log shows: Finding file `dragon.txt` and uploading with expiry time.
  - Response code: `201 Created` (artifact archived successfully).

- **Download in Subsequent Jobs**:
  - **Test Job**:
    - Step: "Downloading artifacts".
    - Downloads from `build` job (default behavior).
    - Source: External storage (e.g., `storage.googleapis.com`).
    - Status: `200 OK`.
    - Artifacts available for use (e.g., `cat dragon.txt`).

  - **Deploy Job**:
    - Similar download step.
    - Can read and use the artifact file.

### Accessing Artifacts via GitLab UI

1. **From Pipeline View**:
   - Click "Download" button to see build job artifacts.
   - Or, under build job tab, select "Artifacts" to list available items (e.g., `dragon.txt.zip`, job logs).

2. **Browse Artifacts**:
   - Click "Browse" > Redirects to a URL for quick file check or download.
   - Implicit artifacts like job logs are available without configuration.

```diff
! Artifact Flow: Build Job → Upload Artifacts → Test/Deploy Jobs → Download Artifacts → Use in Scripts
```

> [!NOTE]
> Artifacts are automatically available across stages, demonstrating how `stages` (global phases) and `stage` (job assignment) work together for pipeline execution.

> [!WARNING]
> Artifact size limits and subscription plans may prevent `never` expiry; monitor for security compliance.
