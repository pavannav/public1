# Course Summary/Tracker

**Course**: GitLab CI/CD Summary  
**Total Sessions**: 34  
**Sessions Completed**: 1  
**Last Updated**: 2026-04-28  

### Session Tracker

| Session | Title | Status | Summary |
|---------|-------|--------|---------|
| 01 | Introducing GitLab CI/CD | ⏸️ Pending | - |
| 02 | Exploring Predefined CI/CD Variables | ⏸️ Pending | - |
| 03 | Intro to Merge Requests | ⏸️ Pending | - |
| 04 | Raise a Merge Request & Use Rules at Job Level | ⏸️ Pending | - |
| 05 | Use Rules at Workflow Level | ⏸️ Pending | - |
| 06 | Pipeline Schedules | ⏸️ Pending | - |
| 07 | Resource Groups | ⏸️ Pending | - |
| 08 | Use Job Timeout | ⏸️ Pending | - |
| 09 | Use Job Images | ⏸️ Pending | - |
| 10 | Parallel & Matrix Builds | ⏸️ Pending | - |
| 11 | Skipping Pipeline Trigger | ⏸️ Pending | - |
| 12 | Project Status Meeting 1 | ⏸️ Pending | - |
| 13 | Node.js Application Overview | ⏸️ Pending | - |
| 14 | Run and Test Node.js App on Local Machine | ⏸️ Pending | - |
| 15 | Understanding XYZ Team DevOps Pipeline | ⏸️ Pending | - |
| 16 | - | ⏸️ Pending | - |
| 17 | - | ⏸️ Pending | - |
| 18 | - | ⏸️ Pending | - |
| 19 | - | ⏸️ Pending | - |
| 20 | Exploring Predefined CI/CD Variables | ⏸️ Pending | - |
| 21 | Intro to Merge Requests | ⏸️ Pending | - |
| 22 | Raise a Merge Request & Use Rules at Job Level | ⏸️ Pending | - |
| 23 | Use Rules at Workflow Level | ⏸️ Pending | - |
| 24 | Pipeline Schedules | ⏸️ Pending | - |
| 25 | Resource Groups | ⏸️ Pending | - |
| 26 | Use Job Timeout | ⏸️ Pending | - |
| 27 | Use Job Images | ⏸️ Pending | - |
| 28 | Parallel Matrix | ⏸️ Pending | - |
| 29 | Skipping Pipeline Trigger | ⏸️ Pending | - |
| 30 | Project Status Meeting 1 | ⏸️ Pending | - |
| 31 | Node.js Application Overview | ⏸️ Pending | - |
| 32 | Run and Test Node.js App on Local Machine | ⏸️ Pending | - |
| 33 | Understanding XYZ Team DevOps Pipeline | ⏸️ Pending | - |
| 34 | Import Git Repo | ✅ Completed | Topics: GitLab CI/CD Pipeline Setup, Workflow Rules, Stages & Jobs, Variables, CI/CD Variables, Troubleshooting Pipeline Failures. Key Concepts: Workflow triggers for branches and MRs, Node.js testing, MongoDB credentials handling. Notable Commands: npm install, npm test, Git commits. |

---

# Session 34: Import Git Repo

## Configuring GitLab CI/CD Pipeline for Solar System Project

### Key Concepts

GitLab CI/CD enables automated testing, building, and deployment of applications. For a Node.js-based solar system project, we'll set up a pipeline to run unit tests, addressing database connections and credential management.

#### Global Keywords in `.gitlab-ci.yml`

- **Workflow**: Defines when the pipeline triggers. Named "solar system Node.js pipeline".
  - **Rule 1 (OR condition)**: Triggers on commits to `main` branch or branches starting with `feature-` (using regex `^feature-.*`).
  - **Rule 2 (AND condition)**: Triggers only on merge request events where source branch starts with `feature-`.
- **Stages**: Defines sequential phases; here, only `test` stage included.

#### Unit Testing Job

- **Job Name**: `unit-testing`.
- **Stage Association**: `test`.
- **Image**: `node:latest` – Uses Node.js Docker image for compatibility.
- **Before Script**: `npm install` – Installs dependencies.
- **Script**: `npm test` – Executes unit tests (using Mocha).

> [!NOTE]
> No local Node.js installation needed due to Docker image usage.

### Lab Demos

#### Setting Up CI/CD Pipeline

1. **Navigate to Project**: Ensure you're in the solar system project without existing CI/CD setup.

2. **Create `.gitlab-ci.yml`**:
   ```yaml
   workflow:
     name: "solar system NodeJS pipeline"
     rules:
       - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
       - if: $CI_COMMIT_BRANCH =~ /^feature-.*/
       - if: $CI_PIPELINE_SOURCE == "merge_request_event" && $CI_MERGE_REQUEST_SOURCE_BRANCH_NAME =~ /^feature-.*/

   stages:
     - test

   unit_testing:
     stage: test
     image: node:latest
     before_script:
       - npm install
     script:
       - npm test
   ```

3. **Commit Changes**: Create feature branch `feature/setup-gitlab-cicd`, commit file.

   ```bash
   git checkout -b feature/setup-gitlab-cicd
   git add .gitlab-ci.yml
   git commit -m "Add GitLab CI/CD pipeline with unit testing job"
   git push origin feature/setup-gitlab-cicd
   ```

4. **Pipeline Trigger**: Automatically triggers due to `feature-` branch rule.

#### Troubleshooting: Handling MongoDB Connection Failure

**Issue**: Pipeline failed with Mongoose error – "not able to find URL parameter" for MongoDB connection.

**Cause**: Application (`app.js`) requires MongoDB credentials (URI, username, password) not available in pipeline.

**Solution**: Add global variables for database credentials.

```yaml
workflow:
  name: "solar system NodeJS pipeline"
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
    - if: $CI_COMMIT_BRANCH =~ /^feature-.*/
    - if: $CI_PIPELINE_SOURCE == "merge_request_event" && $CI_MERGE_REQUEST_SOURCE_BRANCH_NAME =~ /^feature-.*/

stages:
  - test

variables:
  MONGO_URI: "YOUR_MONGO_URI"
  MONGO_USERNAME: "YOUR_MONGO_USERNAME"
  MONGO_PASSWORD: $M_DB_PASSWORD  # From CI/CD variables

unit_testing:
  stage: test
  image: node:latest
  before_script:
    - npm install
  script:
    - npm test
```

> [!IMPORTANT]
> Credentials like URI and username can be hard-coded if non-sensitive. Passwords must use secure CI/CD variables to avoid exposure.

**Create CI/CD Variable**:

1. Go to **Settings > CI/CD > Variables**.
2. Add new variable:
   - **Key**: `M_DB_PASSWORD`
   - **Value**: `superpassword`
   - **Type**: Variable
   - **Environment Scope**: All (protected)
   - **Protect Variable**: Checked
   - **Mask Variable**: Checked
3. Reference in YAML with `$M_DB_PASSWORD`.

3. **Test Pipeline**:
   - Commit updates: `git add .gitlab-ci.yml; git commit -m "Add MongoDB variables"; git push`
   - Pipeline now succeeds: Dependencies install, tests run successfully (logs show "server successfully running on port 3000", no errors).

#### Pipeline Execution Details

| Step | Description | Outcome |
|------|-------------|---------|
| Runner Setup | Uses Linux small machine | ✅ Success |
| Image Pull | Node.js Docker image | ✅ Success |
| Source Clone | Retrieves repository code | ✅ Success |
| Before Script | `npm install` (adds ~364 packages) | ✅ Success |
| Script | `npm test` (connects to MongoDB, runs tests) | ❌ Failed initially (credentials missing) → ✅ Fixed |

```diff
! Initial Pipeline → npm install SUCCESS → npm test FAILED (MongoDB connection error: Mongoose error, missing URL parameter)
+ Updated Pipeline → Added variables MONGO_URI, MONGO_USERNAME, MONGO_PASSWORD → npm test SUCCESS (no errors found in tests)
```

### Key Takeaways

- **Workflow Rules**: Control pipeline triggers logically with branches and MR conditions.
- **Environment Variables**: Secure sensitive data; hard-code non-sensitive values.
- **CI/CD Variables**: Masked for security; protected in GitLab settings.
- **Debugging**: Check job logs for failures; validate dependencies and connections.
- **Future Enhancement**: Add artifacts for test reports to visualize test results.

> [!WARNING]
> Avoid committing sensitive credentials to repository. Always use CI/CD variables for passwords and restrict variable scopes.

**Transcript Corrections**: None identified; all terms (e.g., "Node.js", "Mongoose", "MongoDB") appear correct. No typographical errors noted. 

--- 

**🤖 Generated with [Claude Code](https://claude.com/claude-code)**

Co-Authored-By: Claude <noreply@anthropic.com>
