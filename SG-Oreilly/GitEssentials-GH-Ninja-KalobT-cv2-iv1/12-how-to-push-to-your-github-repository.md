# Section 12: How to Push to Your GitHub Repository

<details open>
<summary><b>Section 12: How to Push to Your GitHub Repository (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [Overview](#overview)
- [The Four-Step Push Workflow](#the-four-step-push-workflow)
- [Understanding File States in Git](#understanding-file-states-in-git)
- [Staging Files with git add](#staging-files-with-git-add)
- [Creating Commits](#creating-commits)
- [Pushing to Remote Repository](#pushing-to-remote-repository)
- [Commit Best Practices](#commit-best-practices)
- [Summary](#summary)

## Overview

This session demonstrates the complete workflow for pushing local changes to a GitHub repository, covering the four essential steps: creating or modifying files, staging them, committing the changes, and pushing to the remote repository. The instructor walks through practical examples using command-line tools to illustrate each stage of the process.

## The Four-Step Push Workflow

### The Push Process
Git follows a structured four-step process to move code from your local machine to GitHub:

1. **Create or Edit Files** - Generate unstaged work
2. **Stage Your Work** - Prepare files for commit using `git add`
3. **Commit Your Work** - Package changes with a descriptive message
4. **Push Your Work** - Send commits to the remote repository

```diff
! unstaged → staged → committed → pushed
```

### Understanding the Terminology
- **Push**: The process of getting code from your computer to GitHub
- **Origin**: The remote repository (GitHub, GitLab, Bitbucket, etc.)
- **Master**: The default primary branch (like index.html for web servers)

> [!NOTE]
> The term "origin" is Git's way of referring to wherever your remote repository is located. While this course uses GitHub, the same concept applies to any Git hosting service.

## Understanding File States in Git

### Checking Repository Status
The `git status` command is essential for understanding the current state of your repository:

```bash
git status
```

This command should become second nature - run it frequently to track what Git is tracking.

### File States Explained
Git tracks files in different states:

1. **Untracked Files**
   - New files Git doesn't know about yet
   - Appear in red in `git status` output
   - Cannot be pushed without staging first

2. **Staged Files (Changes to be Committed)**
   - Files prepared for the next commit
   - Appear in green in `git status` output
   - Ready to be packaged into a commit

3. **Committed Files**
   - Changes saved to the local repository
   - Not yet visible on GitHub until pushed

> [!IMPORTANT]
> Attempting `git push origin master` with unstaged files will result in no changes being sent to GitHub. The files must first be staged and committed.

## Staging Files with git add

### The Staging Process
Before committing, files must be added to the staging area:

```bash
git add first-push.txt
```

Or use tab completion for efficiency:

```bash
git add first[Tab]
```

### What Staging Accomplishes
- **Packages files**: Prepares files to be included in the next commit
- **Creates a snapshot**: Git takes note of the current version of the file
- **Enables selective commits**: You can choose which changes to include

After staging, `git status` will show the file in green with the message "new file: changes to be committed."

## Creating Commits

### The Commit Command
Create a commit with a descriptive message:

```bash
git commit -m "This is the first official push"
```

### What a Commit Contains
A commit is like a package with the following information:
- **Files changed**: What's being included in this package
- **Author information**: Who created the package
- **Timestamp**: When the commit was made
- **Commit message**: Description of what the commit accomplishes

### Viewing Commits on GitHub
After pushing, commits appear in the repository history showing:
- Commit messages
- Timestamps
- Author information
- Changed files

## Pushing to Remote Repository

### The Push Command
Send committed changes to GitHub:

```bash
git push origin master
```

### Command Breakdown
```
git        → The version control system
push       → The action being performed
origin     → The remote destination (GitHub)
master     → The target branch
```

### SSH Authentication
> [!NOTE]
> Using SSH keys eliminates the need to enter username and password repeatedly. Without SSH configuration, Git will prompt for credentials with every push operation.

### Push Process Output
When successful, Git displays:
- Compression statistics
- Thread usage information
- Confirmation of the branch update from local to remote

## Commit Best Practices

### Commit Frequently with Small Changes
**Recommended approach**: Create commits with 1-10 files each

**Rationale**:
- Easier code review process
- Simpler to identify specific changes
- Better debugging capabilities
- Clearer project history

### Example of Good vs Bad Commits

| Commit Size | Files Changed | Review Difficulty |
|-------------|---------------|-------------------|
| ✅ Good | 1-10 files | Easy to review each change |
| ❌ Bad | 170 files | Difficult to find specific issues |

### Benefits of Small Commits
1. **For Reviewers**: Can easily spot bugs or issues in small changes
2. **For Future Reference**: Simpler to understand project evolution
3. **For Debugging**: Easier to identify which commit introduced a problem

## Summary

### Key Takeaways
```diff
+ Always run git status to check current state
+ Follow the four steps: unstaged → staged → committed → pushed
+ Use descriptive commit messages
+ Commit frequently with small, focused changes
+ SSH keys streamline the authentication process
```

### Quick Reference Commands
| Command | Purpose |
|---------|---------|
| `git status` | Check current file states |
| `git add <file>` | Stage files for commit |
| `git commit -m "message"` | Create a commit with message |
| `git push origin master` | Push to GitHub master branch |

### Expert Insight

**Real-world Application**: The push workflow is fundamental to all Git operations in professional development. Understanding these states helps developers manage complex projects, collaborate effectively, and maintain clean project histories that are essential for team environments.

**Expert Path**: Master the workflow by practicing with multiple files and branches. Learn to use `git add -p` for partial staging and understand how to amend commits when needed. Eventually, incorporate this into automated CI/CD pipelines.

**Common Pitfalls**:
- Forgetting to stage files before committing
- Creating commits that are too large and difficult to review
- Not using descriptive commit messages
- Pushing sensitive data to public repositories

**Lesser-Known Facts**: The "master" branch naming convention comes from the concept of a primary or main branch, similar to how web servers look for index.html by default. While you can rename this branch, the default behavior ensures compatibility across all Git implementations.

</details>