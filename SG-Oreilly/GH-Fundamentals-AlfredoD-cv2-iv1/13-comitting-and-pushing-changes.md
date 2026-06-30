# 13: Committing and Pushing Changes

<details open>
<summary><b>13: Committing and Pushing Changes (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Committing Changes](#committing-changes)
  - [Understand Commit vs Push](#understand-commit-vs-push)
  - [Web Interface Commit Process](#web-interface-commit-process)
  - [Command Line Commit Workflow](#command-line-commit-workflow)
- [Pushing Changes](#pushing-changes)
  - [The Push Process](#the-push-process)
  - [Authentication Methods](#authentication-methods)
  - [HTTPS vs SSH Authentication](#https-vs-ssh-authentication)
- [Visual Studio Code Integration](#visual-studio-code-integration)
- [Summary](#summary)

## Overview

This session covers the essential workflow of committing and pushing changes in Git. You'll learn how to save your local changes permanently through commits and synchronize them with remote repositories on GitHub through pushes. The session demonstrates multiple methods including web interface, command line, and IDE integration.

## Committing Changes

### Understand Commit vs Push

Git operations involve two distinct steps that work together to preserve and share your work:

```diff
+ Commit: Saves changes locally with a descriptive message
- Push: Uploads committed changes to a remote repository
```

**Key Distinction**:
- A commit creates a permanent snapshot of your changes in your local repository
- A push synchronizes those local commits with a remote repository (like GitHub)
- Changes must be committed before they can be pushed

### Web Interface Commit Process

When using GitHub's web interface, the commit process includes:

1. **Making Changes**: Edit files directly in the browser
2. **Commit Options**:
   - **Commit directly to the branch**: Immediately applies changes to the current branch (e.g., main)
   - **Create a new branch and start a pull request**: Creates a feature branch and initiates the PR workflow

> [!NOTE]
> The web interface's "commit directly" option actually performs both commit and push operations simultaneously.

### Command Line Commit Workflow

The standard command-line workflow follows three key steps:

```bash
# Step 1: Check status to see modified files
git status

# Step 2: Stage the changes (add to staging area)
git add README.md

# Step 3: Commit with a descriptive message
git commit -m "removing an extra line"
```

**Workflow Breakdown**:
1. **Modify**: Edit your files using any text editor
2. **Stage**: Use `git add` to move changes to the staging area
3. **Commit**: Create a permanent snapshot with `git commit -m`

## Pushing Changes

### The Push Process

After committing locally, pushing uploads your changes to the remote repository:

```bash
# Push committed changes to the remote repository
git push
```

The push command:
- Identifies the remote repository and branch
- Transmits your commits to GitHub
- Updates the remote branch to match your local state

### Authentication Methods

Git requires authentication when pushing to remote repositories:

**HTTPS Authentication**:
- Requires username and password/token
- Password authentication was deprecated on August 13, 2021
- Now requires Personal Access Tokens (PATs) instead of passwords

**SSH Authentication**:
- Uses SSH keys for authentication
- No password prompts required
- Requires initial SSH key setup

### HTTPS vs SSH Authentication

**Converting from HTTPS to SSH**:

You can modify the repository's remote URL in the config file:

```bash
# View current remote configuration
cat .git/config

# The URL line shows the current protocol:
# url = https://github.com/username/repo.git
# Change to:
# url = git@github.com:username/repo.git
```

**Cloning with SSH**:
When initially cloning, select the SSH option in GitHub's interface to avoid authentication issues later.

## Visual Studio Code Integration

VS Code provides integrated Git workflows:

1. **Make Changes**: Edit files in the editor
2. **Stage Changes**: Use the Source Control panel to stage modifications
3. **Commit**: Enter a commit message and click Commit
4. **Sync/Push**: VS Code prompts to sync (push) changes after committing

This provides a visual, streamlined approach to the commit and push workflow.

## Summary

### Key Takeaways

```diff
! Workflow: Modify → Stage → Commit → Push
+ Always commit locally before pushing to remote
- Authentication is required for remote operations
! Choose between HTTPS (with PAT) or SSH authentication
+ IDEs like VS Code integrate the entire workflow visually
```

### Quick Reference

| Command | Purpose |
|---------|---------|
| `git status` | View modified and staged files |
| `git add <file>` | Stage specific files for commit |
| `git commit -m "message"` | Create a commit with message |
| `git push` | Upload commits to remote repository |
| `git remote -v` | View remote repository URLs |

### Expert Insight

**Real-world Application**:
In production environments, commits serve as checkpoints in your development process, while pushes enable collaboration by sharing your work with teammates. Always write clear, descriptive commit messages that explain the "why" behind changes, not just the "what."

**Expert Path**:
- Master the distinction between staging, committing, and pushing
- Set up SSH keys for seamless authentication
- Use commit hooks to enforce commit message standards
- Practice the workflow until it becomes second nature

**Common Pitfalls**:
- Forgetting to stage changes before committing
- Pushing sensitive data that should remain local
- Using vague commit messages like "fixed stuff"
- Attempting to push without proper authentication setup

**Lesser-Known Facts**:
- You can commit without pushing indefinitely, creating a completely local history
- The staging area allows selective commits from multiple file changes
- Git's distributed nature means every clone is a full backup of the repository history

</details>