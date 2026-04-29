# Session 38: Ignoring Job Failure

## Reports in GitLab CI/CD and Merge Requests

### Key Concepts

- The `reports` keyword in GitLab CI/CD allows artifacting job reports for download and visual inspection in the GitLab UI.
- Benefits extend to displaying reports within Merge Requests (MRs), enabling reviewers to assess test results, coverage, and failures without leaving the MR page.
- For failed jobs, reports provide detailed error insights, including assertion details.
- Coverage reports highlight untested lines in the code diff view of an MR, with color coding (e.g., orange for uncovered lines, green for covered).

> [!NOTE]
> Using `allow_failure: true` in job configuration lets jobs fail without failing the entire pipeline, useful for non-critical jobs like code coverage.

### Reports Types Overview

| Report Type | Purpose | Display in MR |
|-------------|---------|---------------|
| JUnit | Unit test results (pass/fail, details) | Shows failed tests, success rates, and detailed error messages. |
| Coverage | Code coverage percentages and line details | Visualizes coverage in diff view; uncovered lines highlighted in orange. |
| Other | General artifacts | Can be downloaded or viewed in pipeline jobs. |

### Lab Demo: Demonstrating Reports in an MR with Job Failures

Following the instructor's steps, here's the complete lab walkthrough for setting up and observing the reports feature in GitLab CI/CD:

1. **Access the Repository**:
   - Switch to the `feature` branch in the GitLab web IDE.

2. **Edit Files to Simulate Scenarios**:
   - **GitLab CI.yml**: Remove the extra sample job.
   - **app.test.js**: Modify a test case to fail by changing expected value. For example, append text to make the assertion fail (e.g., expect "Mercury" but get "Planet Mercury").
   - **app.js**: Add an uncovered line (e.g., `console.log("DB connection error");` on line 22).

3. **Commit Changes**:
   - Commit all files with message: "modified multiple files to test reports".
   - This triggers a new pipeline.

4. **Monitor Pipeline**:
   - The pipeline fails due to the unit test failure (code coverage job fails but is allowed with `allow_failure: true`).
   - Review the failed job:
     - In the "Test" tab, view failed tests (1 failure out of total tests).
     - Click "View details" to see assertion errors (e.g., expected "Mercury", actual "Planet Mercury").

5. **Create Merge Request**:
   - From the repository, click "Create merge request" for the branch.
   - Set title: "exploring GitLab CI/CD".
   - Description: Use the same as title.
   - Assignee/Reviewers: As available (demo uses same user).
   - Create MR → This triggers another pipeline (matches workflow rules for MR source).

6. **Observe Reports in MR**:
   - **Pipeline Status**: Shows failure with reason (unit test fail).
   - **Coverage Percentage**: Displayed (reflected from coverage job using `coverage` keyword).
   - **Test Summary**: Indicates failed tests (e.g., 1 out of 11 failed).
     - Click "View details" for same error breakdown as in pipeline.
   - **Changes Tab**: View diffs for modified files (e.g., app.test.js shows value change, app.js shows new line).
   - **Coverage Visualization**:
     - In diff view, uncovered lines (e.g., new `console.log`) highlighted in orange.
     - Covered lines shown in green with hit count (e.g., 1 hit).

```diff
! MR Workflow: Push Changes → Create MR → Trigger Pipeline → Review Reports in MR (Tests + Coverage) → Approve/Reject
```

> [!WARNING]
> Ensure `allow_failure: true` is set for jobs like coverage where failure doesn't block merges, but critical jobs (e.g., unit tests) should fail the pipeline if needed.

> [!IMPORTANT]
> Reports integration in MRs streamlines code reviews by surfacing test and coverage data directly, reducing context-switching and improving efficiency for teams.
