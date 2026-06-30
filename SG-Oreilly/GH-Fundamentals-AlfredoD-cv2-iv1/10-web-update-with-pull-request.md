# Section 10: Web Update With Pull Request

<details open>
<summary><b>Section 10: Web Update With Pull Request (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents

- [Overview](#overview)
- [10.1 Making Web-Based Changes to Repositories](#101-making-web-based-changes-to-repositories)
- [10.2 Creating a Branch and Pull Request](#102-creating-a-branch-and-pull-request)
- [10.3 Making Additional Changes to the Same Branch](#103-making-additional-changes-to-the-same-branch)
- [10.4 Providing Feedback on Pull Requests](#104-providing-feedback-on-pull-requests)
- [Summary](#summary)

## Overview

This section demonstrates how to make straightforward changes to repositories using GitHub's web interface and create pull requests. Web-based edits are ideal for simple modifications that don't require local development environments, making the contribution process accessible to beginners and occasional contributors.

## 10.1 Making Web-Based Changes to Repositories

Web-based changes provide a simple way to contribute to repositories without setting up a local development environment.

### When to Use Web-Based Edits

✅ **Appropriate for:**
- Straightforward, simple changes
- Text or documentation edits
- Minor fixes that don't require testing

❌ **Not recommended for:**
- Complex code changes
- Changes requiring local testing
- Multi-file refactoring

### Starting the Web Edit Process

1. Navigate to the file you want to edit in the repository
2. Click the edit icon (pencil icon) in the file view
3. Make your changes directly in the web editor
4. GitHub automatically tracks your modifications

## 10.2 Creating a Branch and Pull Request

When making changes via the web interface, GitHub guides you through the proper workflow of creating a branch and opening a pull request.

### The Commit and PR Creation Process

1. **Make your edits** in the web editor
2. **Scroll to the commit section** at the bottom of the edit page
3. **Choose the branch option**: Select "Create a new branch for this commit and start a pull request"
   - ⚠️ **Important**: Never commit directly to the main branch unless:
     - The repository is extremely simple
     - You're the only contributor
     - There's no active codebase
4. **Review the auto-generated branch name** (GitHub creates descriptive names)
5. **Write a commit message** describing the change
6. **Click "Propose changes"** to proceed

### Opening the Pull Request

After proposing changes, you'll be presented with:
- A comparison view showing your modifications
- The option to open the pull request immediately
- Ability to update the PR title and description

Example PR title: "some updates to the README.md file, testing out changes via the web"

## 10.3 Making Additional Changes to the Same Branch

After creating a pull request, you can continue making changes to the same branch without creating a new PR.

### Switching Between Branches

1. Open a new tab to the repository
2. Navigate to the "Code" tab
3. Click on the branch dropdown to see available branches
4. Select the newly created branch
5. Make additional edits following the same process

### Committing Additional Changes

When making subsequent changes on an existing PR branch:

1. Edit the next file as needed
2. GitHub will detect you're working on an existing branch
3. You'll see two options:
   - Commit directly to the branch (recommended for related changes)
   - Create a new branch (not needed if changes are related)
4. Choose "Commit directly to [branch-name]" for connected changes

### Multi-File Pull Requests

A single pull request can contain changes to multiple files:
- All changes from the same branch appear together
- Reviewers can see the complete set of modifications
- Related changes are logically grouped

## 10.4 Providing Feedback on Pull Requests

GitHub's PR interface enables effective collaboration through comments and reviews.

### Types of Feedback

**Single Comment:**
- Quick, informal feedback on specific lines
- Click on a line number and add a comment
- Suitable for simple observations or questions

**Formal Review:**
- Structured feedback with multiple comments
- Click "Start a review" to begin
- Collect multiple comments before submitting
- Provides comprehensive feedback in one package

### Review Process

1. Navigate to the pull request
2. Review the changes file by file
3. Add inline comments on specific lines
4. Choose between:
   - Single comment submission
   - Full review with multiple comments
5. Submit feedback for the contributor to address

## Summary

```diff
! Web Edit → Create Branch → Make Changes → Open PR → Review & Feedback
```

### Key Takeaways

```diff
+ Web-based edits are suitable for straightforward, simple changes
+ Always create branches instead of committing directly to main
+ Multiple file changes can be grouped in a single pull request
+ GitHub provides both informal comments and formal review processes
- Never skip the branch creation step for production repositories
```

### Quick Reference

| Action | Web Interface Location | Key Points |
|--------|----------------------|------------|
| Edit file | File view → Edit icon | Direct browser editing |
| Create branch | Commit section | Auto-generated names available |
| Open PR | After proposing changes | Update title/description as needed |
| Add to existing PR | Switch to branch first | Commit directly to existing branch |
| Provide feedback | PR view → line comments | Single comments or full reviews |

### Expert Insight

**Real-world Application:**
Web-based edits are invaluable for documentation fixes, typo corrections, and minor improvements by community members who may not have development environments set up. Many open source projects receive significant contributions through web edits.

**Expert Path:**
- Learn to use GitHub's web editor efficiently
- Understand the difference between committing directly vs. creating PRs
- Master the review process for providing constructive feedback
- Practice making multi-file coordinated changes

**Common Pitfalls:**
- Accidentally committing directly to main branch
- Creating separate PRs for related changes that should be together
- Not providing clear commit messages
- Forgetting to switch branches before making additional edits

**Lesser-Known Facts:**
- GitHub auto-generates branch names based on your commit message
- You can continue editing files in a PR indefinitely until it's merged
- Reviewers can request changes that appear as pending review comments
- Web edits create real git commits that appear in the repository history

</details>