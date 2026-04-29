# Session 39: Exploring Reports through Merge Request

## Why Caching Dependencies is Important

Caching dependencies is crucial for optimizing GitLab CI pipelines, especially in applications with numerous dependencies. In Node.js applications, dependencies are defined in `package.json`, and installations create `package-lock.json` for version locking and security.

💡 **Key Points**:
- Dependencies install once per job on each runner.
- Complex apps may have hundreds of dependencies, increasing install times from seconds to minutes.
- Multiple jobs running on different runners repeat installations, wasting time and resources.

### Current Pipeline Issues
The pipeline includes unit testing and code coverage jobs that run `npm install` before executing tasks. Each job downloads and installs the same 364 packages:
-.Unit testing job: ~7 seconds
- Code coverage job: ~6 seconds

This redundancy is inefficient for pipelines with multiple jobs or frequent runs.

✅ **Benefits of Caching**:
- Shares downloaded dependencies across jobs and pipelines.
- Reduces install time to near-instant verification (~1 second).
- Stores cache on runners or cloud storage (e.g., AWS S3 or GCP).

## Cache vs. Artifacts

Caching and artifacts serve different purposes in GitLab CI/CD.

| Aspect          | Cache                           | Artifacts                    |
|-----------------|---------------------------------|-------------------------------|
| Purpose         | Store downloaded dependencies for reuse | Store files generated during job execution |
| Usage Scope     | Same job across runs, or between jobs/pipelines | Intermediate jobs within a single pipeline |
| Storage         | Runner or cloud (e.g., S3)     | GitLab instance               |

⚠️ **Common Confusion**:
- Use cache for external packages (e.g., npm, Ruby gems).
- Use artifacts for build outputs shared within a pipeline.

## Configuring Cache in GitLab CI

Cache is configured per job using the `cache` keyword. Key options include:

- **paths**: Files/directories to cache (e.g., `node_modules/`).
- **key**: Unique identifier for cache sharing. Options:
  - String or CI/CD variable.
  - File-based: Generates key from file SHA (e.g., `package-lock.json`). Changes to files invalidate cache.
  - Prefix: Adds meaningful name to key.
- **policy**: Defines download/upload behavior.
  - `pull-push` (default): Download existing cache, upload new/changed cache.
  - `pull`: Only download, no upload.
  - `push`: Only upload, no download.

> [!IMPORTANT]
> Cache keys tied to files like `package-lock.json` auto-update when dependencies change.

### Example Configuration

For Node.js, add cache before the `script` stage:

```yaml
cache:
  paths:
    - node_modules/
  key:
    files:
      - package-lock.json
    prefix: node_modules
  policy: pull-push
  when: on_success
```

Apply the same config to multiple jobs for consistency.

> [!NOTE]
> For dependent jobs, use `policy: pull` after an upstream job pushes cache. For parallel jobs, use `pull-push` to ensure availability.

## Lab Demo: Adding Cache to Jobs

### Step 1: Modify the CI/CD Pipeline YAML

Add cache configuration to both unit testing and code coverage jobs:

```yaml
# Unit Testing Job
cache:
  paths:
    - node_modules/
  key:
    files:
      - package-lock.json
    prefix: node_modules
  policy: pull-push
  when: on_success
script:
  - npm ci  # Use npm ci for faster, more reliable restores

before_script:
  - npm ci

# Code Coverage Job (similar config)
cache:
  paths:
    - node_modules/
  key:
    files:
      - package-lock.json
    prefix: node_modules
  policy: pull-push
  when: on_success
before_script:
  - npm ci
```

📝 **Tips**:
- Use `npm ci` for cache compatibility (faster than `npm install` in cached scenarios).
- Both jobs use `pull-push` for parallel execution to handle first-run scenarios.

### Step 2: Commit and Push Changes

1. Commit changes: `git commit -m "Add caching for Node.js dependencies"`
2. Push to feature branch: `git push origin feature-branch`

### Step 3: Observe Pipeline Execution

**First Run (No Cache)**:
- Jobs attempt to restore cache → Fails ("failed to extract cache").
- Proceeds to `npm ci`, installing dependencies (~7 seconds).
- Saves cache to storage (e.g., GCP) after success: ~5,735 artifacts uploaded.

**Subsequent Runs**:
- Restores cache from storage using SHA-based key.
- `npm ci` completes instantly ("up to date" in ~1 second).
- Uploads updated cache if dependencies changed.

> [!WARNING]
> If cache is invalid (e.g., dependency changes), jobs fall back to fresh installs.

## Clearing Cache

Cache persists across runs but may need clearing:

### Manual Clearing
1. Go to Pipelines > Runners.
2. Select "Clear runner cache" to remove from all runners.

### Automatic Clearing on Dependency Changes
- File-based keys (e.g., `package-lock.json`) auto-invalidate cache on changes.
- This ensures new dependencies install fresh, preventing stale cache issues.

> [!TIP]
> Monitor cache hit rates in CI/CD logs to optimize configuration.

<summaries>
CL-KK-Terminal
0: Why caching dependencies matters for CI/CD efficiency
39: Exploring caching in GitLab CI/CD (dependencies, configuration, demos)
40: Session 40: [Next topic, corrected dependency clearing strategies]
</summaries>
