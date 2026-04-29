# Session 26: Using Custom Docker Images in GitLab CI Jobs

## Understanding Docker Images in GitLab CI Jobs

### Key Concepts

💡 **Problem with Default Images**: GitLab CI jobs run in Docker containers using the default Ruby image. Commands specific to other technologies (like Node.js) will fail if not installed.

```diff
- Default Ruby image: Limited to Ruby commands only
- Node.js commands: Failed with "command not found" error
```

💡 **Manual Installation Approach**: Manually install required software in `before_script` (hacky and time-consuming).

✅ **Better Solution**: Use the `image` keyword to specify a custom Docker image for the job.

⚠️ **Performance Impact**: Manual installation can add 30+ seconds vs. direct image usage taking ~13 seconds.

### Image Specification in GitLab CI

You can specify Docker images at two levels:

- **Global (default section)**: Applies to all jobs
- **Job level**: Specific to individual jobs

Available options:
- `image`: Docker image name/tag
- `image:entrypoint`: Override container entrypoint
- `image:pull_policy`: Control when image is pulled (always, if-not-present, never)

```yaml
job_name:
  image: node:20-alpine3.18
  script:
    - node --version
    - npm --version
```

### Node.js Version Checking Example

> [!NOTE]
> This session demonstrates Node.js deployment preparation using a custom Node.js image instead of the default Ruby image.

### Lab Demos

#### Demo 1: Failing with Default Ruby Image

**Workflow Changes**:
- Added `node --version` and `npm --version` commands
- Removed/comment out timeout configuration

**Expected Result**: Job fails with:
```
/bin/bash: node: command not found
```

```diff
! Client Request → GitLab CI → Default Ruby Container → Node Command → Command Not Found Error
```

#### Demo 2: Manual Node.js Installation (Hacky Approach)

**Steps**:
1. Add `before_script` section
2. Use YAML multi-line literal syntax (`|` ) for complex commands
3. Install Node.js manually using NodeSource repository

**YAML Configuration**:
```yaml
job_name:
  script:
    - node --version
    - npm --version
  before_script:
    |
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt-get install -y nodejs
```

**Issues Encountered**:
- Multi-line commands need proper YAML formatting
- `sudo` commands not available (remove them)
- Time-consuming installation (~30 seconds)

**Result**: Successful but slow execution

#### Demo 3: Using Custom Node.js Image (Recommended)

**Steps**:
1. Remove `before_script` (no longer needed)
2. Add `image` specification with Docker Hub tag

**YAML Configuration**:
```yaml
job_name:
  image: node:20-alpine3.18
  script:
    - node --version
    - npm --version
```

**Result**: Fast execution (~13 seconds)
- Container uses Node.js image directly
- No manual installation required
- Native Node.js and npm commands available

> [!IMPORTANT]
> Always prefer official Docker images for dependencies to avoid manual installation overhead and maintain reproducibility.

> [!TIP]
> Use Alpine-based images (e.g., `node:20-alpine3.18`) for smaller image size and faster startup times.

## Summary

✅ **Key Takeaways**:
- Default Ruby image limited to Ruby commands
- Manual installation in `before_script` works but is inefficient
- Specify custom images with `image` keyword for optimal performance
- Node.js applications should use Node.js-based Docker images

📝 **Next Steps**: Explore image pull policies and advanced Docker options in GitLab CI.
