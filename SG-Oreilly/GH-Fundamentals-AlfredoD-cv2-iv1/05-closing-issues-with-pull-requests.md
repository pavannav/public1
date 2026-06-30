# Session 5: Closing Issues with Pull Requests

<details open>
<summary><b>Session 5: Closing Issues with Pull Requests (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Closing Issues Automatically via Pull Requests](#closing-issues-automatically-via-pull-requests)
- [The Special GitHub Syntax](#the-special-github-syntax)
- [Demo: Resolving Issues Through PR Merges](#demo-resolving-issues-through-pr-merges)
- [Benefits of This Approach](#benefits-of-this-approach)
- [Summary](#summary)

## Overview
This session demonstrates how to automatically close GitHub issues when merging a pull request using special syntax keywords in commit messages or PR descriptions. This integration creates useful side effects that streamline the issue resolution workflow.

## Closing Issues Automatically via Pull Requests

GitHub provides automatic integration between pull requests and issues that enables cross-referencing and automatic closure of issues when specific conditions are met. This feature eliminates the manual step of closing issues after merging related pull requests.

The core concept revolves around creating "side effects" when dealing with pull requests - specifically, the ability to automatically transition issues to a closed state without manual intervention.

## The Special GitHub Syntax

GitHub recognizes specific keywords in pull request descriptions and commit messages that trigger automatic issue closure upon merge:

- **fixes #N**
- **closes #N**
- **resolves #N**

Where N represents the issue number. These keywords create a binding relationship between the pull request and the referenced issue.

When any of these keywords appear in a pull request description or commit message, GitHub automatically:
1. Creates a reference link between the PR and issue
2. Displays a visual indicator that the PR will close the issue upon merge
3. Automatically closes the issue when the PR is merged

## Demo: Resolving Issues Through PR Merges

The demonstration shows the complete workflow:

1. **Starting State**: An open issue (Issue #2) exists alongside an open pull request (PR #1)

2. **Modifying the PR Description**:
   - Change from generic reference: "This should update number 2"
   - To closing keyword: "fixes number 2"

3. **Automatic Detection**: GitHub immediately highlights the relationship with a callout stating "This pull request closes issue number 2"

4. **Merging the Pull Request**: After confirming the merge, GitHub processes the special syntax

5. **Automatic Issue Closure**: The issue disappears from the open issues list

6. **Verification**: Refreshing the issues page confirms zero open issues

7. **Audit Trail**: The closed issue details page shows:
   - Status changed to "closed as completed"
   - Reference to the closing pull request ID
   - Bidirectional linking between the issue and PR

## Benefits of This Approach

- **Workflow Efficiency**: Eliminates manual steps to close issues after merging
- **Consistency**: Ensures issues are closed exactly when the related code changes are merged
- **Traceability**: Creates automatic audit trails linking issues to their resolutions
- **Reduced Context Switching**: Developers stay focused on code rather than issue management tasks

## Summary

This session reveals how minor syntax changes in pull request descriptions can automate issue resolution, creating a more efficient development workflow with better traceability between code changes and issue resolutions.

**Key Takeaways**
```diff
+ Use "fixes #N", "closes #N", or "resolves #N" syntax in PR descriptions
+ GitHub automatically detects these keywords and creates issue/PR links
+ Issues close automatically upon PR merge without manual intervention
+ Creates bidirectional navigation between resolved issues and their resolving PRs
- Issues remain open if merge is not completed or keywords are missing
```

**Quick Reference**
- **Keywords**: `fixes`, `closes`, `resolves` + issue number (e.g., `#2`)
- **Placement**: PR description or commit messages
- **Result**: Automatic issue closure on successful merge

**Expert Insight**

- **Real-world Application**: Use this in production repositories to maintain accurate project tracking without additional overhead. Perfect for agile workflows where issue closure timing matters for sprint reporting.

- **Expert Path**: Combine with branch naming conventions (e.g., `fix/123-bug-description`) and commit message templates to create fully automated issue lifecycle management from branch creation to closure.

- **Common Pitfalls**:
  - Using non-standard keywords that GitHub doesn't recognize
  - Forgetting the `#` symbol before the issue number
  - Not verifying the PR/issue relationship before merging

- **Lesser-Known Facts**: GitHub also recognizes variations like `fix`, `close`, and `resolve` (singular forms), and these keywords work in commit messages that land in the merged PR, not just the PR description itself.

</details>