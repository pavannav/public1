# Session 48: Demonstration - Creating & Managing Pull Requests

<details open>
<summary><b>Session 48: Demonstration - Creating & Managing Pull Requests (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents

- [Overview](#overview)
- [Session Content](#session-content)
- [Creating a Pull Request](#creating-a-pull-request)
- [Reviewing and Merging Pull Requests](#reviewing-and-merging-pull-requests)
- [Closing Related Issues](#closing-related-issues)
- [Summary and Key Takeaways](#summary-and-key-takeaways)

## Overview

This demonstration session walks through the complete pull request workflow in GitHub, showing how to propose changes from a fork to the main repository, review those changes as a maintainer, and merge them. It's a critical hands-on session that demonstrates the heart of open source collaboration.

## Session Content

### 1. Understanding Pull Requests

**Overview**: Pull requests (PRs) are fundamental to contributing to GitHub repositories and open source projects. They serve as the mechanism for proposing changes from a fork or branch to the main project.

**Key Concepts**:
- Pull requests allow maintainers to review proposed changes
- They enable feedback and discussion before merging
- PRs act as the gateway for contributions to become part of the project
- GitHub automatically detects when a branch is ahead of the main branch

> [!IMPORTANT]
> PRs are the cornerstone of open source collaboration - they're about communication, review, and building quality together, not just moving code.

### 2. Creating a Pull Request

**Overview**: The process of creating a pull request starts when changes have been pushed to a fork and GitHub detects commits ahead of the main branch.

**Prerequisites**:
- Changes must be committed and pushed to a fork
- GitHub shows "This branch is X commits ahead of main"

**Step-by-Step Process**:

1. **Navigate to Contribute Button**
   - Click on the "Contribute" button on the repository page
   - GitHub displays the message about commits ahead

2. **Choose Pull Request Creation Method**
   - Option 1: Click "Open pull request" directly from the contribute message
   - Option 2: Go to the Pull requests tab and click "New pull request"

3. **Review the Comparison View**
   - Base repository: The main/original project
   - Head repository: Your fork with the changes
   - GitHub shows commit count and files changed
   - Preview the exact differences (diff view)

4. **Configure the Pull Request**
   - Add a clear, descriptive title (e.g., "README file: Typo fixed")
   - Write a detailed description explaining the changes
   - Example: "Fixed all the typos and added CSS and JavaScript under technologies used"

5. **Create Options**
   - Standard pull request (default)
   - Draft pull request (for work in progress)
   - Click "Create pull request" to finalize

**GitHub Checks**:
- After creation, GitHub runs automatic checks
- Confirms no merge conflicts exist
- Shows "No conflicts" status when ready

### 3. Reviewing and Merging Pull Requests

**Overview**: As a maintainer, reviewing and merging pull requests is crucial for maintaining code quality and managing contributions.

**Review Process**:
- Navigate to the Pull requests tab in the main repository
- View all open pull requests
- Review the PR description and proposed changes
- Maintainers can request changes, ask questions, or approve

**Merging Process**:

```bash
# When acting as maintainer:
1. Click on "Merge pull request"
2. Review commit message and description
3. Click "Confirm merge"
```

**Post-Merge Information**:
- Shows who merged the PR
- Displays the merge commit ID
- Updates the main repository with the changes

### 4. Closing Related Issues

**Overview**: When a pull request resolves an issue, the related issue can be closed after the PR is merged.

**Process**:
- Navigate to the Issues tab
- Find the related issue
- Click "Close" on the issue
- The issue status changes to closed

**Best Practice**: Link PRs to issues using keywords like "Fixes #issue_number" in the PR description.

### 5. Verifying Changes

**Overview**: After merging, verify that all changes have been correctly integrated into the main repository.

**Verification Steps**:
- Navigate back to the repository
- Confirm the README has been updated
- Check that test content has been removed
- Verify the technologies list is correct

## Summary and Key Takeaways

```diff
+ Pull requests propose changes from forks/branches to the main project
+ Always provide clear titles and descriptions for PRs
+ Maintainers review, discuss, and decide to merge or close
- Related issues should be closed when resolved by a merged PR
! Pull requests are the heart of open source collaboration
```

### Quick Reference

```bash
# Pull Request Workflow Summary
Fork → Make Changes → Commit & Push → Create PR → Review → Merge → Close Issues
```

### Expert Insights

**Real-world Application**:
- Always create PRs for any changes to shared repositories
- Use descriptive commit messages and PR descriptions
- Link PRs to relevant issues for traceability
- Enable GitHub Actions for automated CI checks on PRs

**Expert Path**:
- Learn about draft PRs for work-in-progress features
- Explore PR templates for consistency
- Master branch protection rules and required reviews
- Understand auto-merge features for approved PRs

**Common Pitfalls**:
- Creating PRs without clear descriptions
- Not checking for merge conflicts before creating PRs
- Forgetting to close related issues
- Not reviewing the diff carefully before merging

**Lesser-Known Facts**:
- You can convert a regular PR to a draft at any time
- PRs can be used for code review even without intending to merge
- GitHub can automatically close issues when PRs with specific keywords are merged
- The merge commit ID helps trace exactly when changes were integrated

</details>