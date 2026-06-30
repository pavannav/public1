# 10: The Git Command-Line Tool

<details open>
<summary><b>10: The Git Command-Line Tool (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents

- [Overview](#overview)
- [10.1 Git Command Line Installation and Verification](#101-git-command-line-installation-and-verification)
- [10.2 Using Git Help](#102-using-git-help)
- [10.3 Initializing a Git Repository](#103-initializing-a-git-repository)
- [10.4 Checking Repository Status](#104-checking-repository-status)
- [10.5 The Two-Step Process: Add and Commit](#105-the-two-step-process-add-and-commit)
- [10.6 Staging Multiple Files](#106-staging-multiple-files)
- [10.7 Modifying Files and Viewing Changes](#107-modifying-files-and-viewing-changes)
- [Summary](#summary)

## Overview

This session introduces the Git command-line tool as the primary interface for interacting with Git repositories. The instructor demonstrates essential commands including installation verification, repository initialization, file staging, committing changes, and monitoring repository status through practical terminal examples.

## 10.1 Git Command Line Installation and Verification

### Overview
Before using Git, it's essential to verify that the tool is properly installed on your system. The Git command-line tool serves as the fundamental interface for Git operations, though graphical interfaces are also available.

### Key Concepts

**Verifying Git Installation**
- Use `git --version` to check if Git is installed and view the version number
- Example output shows version 2.39.3 from Apple on macOS systems

**Platform-Specific Considerations**
- **macOS**: Git typically comes pre-installed from Apple
- **Windows**: Recommended to use Windows Subsystem for Linux (WSL) for terminal access
- **Linux**: Most distributions have Git pre-installed

### Code Examples

```bash
# Check Git installation and version
git --version
# Output: git version 2.39.3 (Apple Git-146)
```

## 10.2 Using Git Help

### Overview
Git provides comprehensive help documentation through its command-line interface, allowing users to explore available commands, options, and sub-commands.

### Key Concepts

**Accessing Git Documentation**
- Use `git help` to access the main help menu
- The help system provides information about:
  - Available commands
  - Command-specific options
  - Sub-commands for complex operations

**Important Initial Commands**
- `git init`: Primary command for creating new repositories
- Essential for users who have never created a repository before

## 10.3 Initializing a Git Repository

### Overview
Creating a local Git repository is the first step in version control. A GitHub repository on the platform contains files and history that mirror your local repository.

### Key Concepts

**Repository Concepts**
- **Local Repository**: Created on your machine using `git init`
- **Remote Repository**: Exists on GitHub platform containing files and commit history
- Local and remote repositories can be synchronized

**Directory Preparation**
- Start with an empty directory
- The directory will be transformed into a Git repository after initialization

### Code Examples

```bash
# Create and navigate to a new directory
mkdir my-repo
cd my-repo

# Initialize a Git repository
git init
# Output: Initialized empty Git repository in /path/to/my-repo/.git/
```

### Lab Demo: Creating Your First Repository
1. Create a new directory: `mkdir my-repo`
2. Navigate into it: `cd my-repo`
3. Initialize Git: `git init`
4. Verify the `.git` directory was created (hidden directory containing repository metadata)

## 10.4 Checking Repository Status

### Overview
The `git status` command is fundamental for understanding the current state of your repository, showing which files are tracked, modified, or staged for commit.

### Key Concepts

**Status Indicators**
- **Clean State**: "nothing to commit, working tree clean"
- **Untracked Files**: New files not yet added to version control
- **Modified Files**: Changes to existing tracked files
- **Staged Files**: Files ready for commit (shown in green)

**Terminal Integration**
- Some terminals display a visual indicator when inside a Git repository
- This varies by terminal configuration and shell

### Code Examples

```bash
# Check repository status
git status
# Output when empty:
# On branch main
#
# No commits yet
#
# nothing to commit (create/copy files and "git add" to track)
```

## 10.5 The Two-Step Process: Add and Commit

### Overview
Git uses a two-step process for saving changes: first staging files with `git add`, then committing them with `git commit`. This design allows for precise control over what gets saved.

### Key Concepts

**Staging Area**
- Acts as a preparation zone before committing
- Allows selective inclusion of changes
- Files appear in green when staged (ready to commit)

**Commit Process**
- Creates a permanent snapshot of staged changes
- Requires a commit message (`-m` flag)
- Each commit represents a point-in-time state of the repository

### Code Examples

```bash
# Create a new file
touch sample.txt

# Check status - file appears as untracked
git status
# Shows: Untracked files: sample.txt

# Stage the file
git add sample.txt

# Check status - file is now staged (green)
git status
# Shows: Changes to be committed: new file: sample.txt

# Commit with message
git commit -m "Add sample.txt"
# Output: [main (root-commit) abc1234] Add sample.txt
#         1 file changed, 0 insertions(+), 0 deletions(-)
#         create mode 100644 sample.txt
```

## 10.6 Staging Multiple Files

### Overview
Git supports staging multiple files simultaneously, allowing efficient batch operations when working with several changes.

### Key Concepts

**Batch Staging**
- Multiple files can be staged together
- Each newly added file follows the same untracked → staged → committed workflow
- Status command shows both staged and unstaged files simultaneously

**Unstaging Files**
- Staged files can be unstaged using `git restore --staged <filename>`
- This removes files from the staging area without deleting them

### Code Examples

```bash
# Create multiple files
touch sample.txt other.txt

# Stage first file
git add sample.txt

# Status shows one staged, one untracked
git status

# Stage second file
git add other.txt

# Both files now staged
git status

# Commit both files
git commit -m "Initial files"
# Output: [main  def5678] Initial files
#         2 files changed, 0 insertions(+), 0 deletions(-)
#         create mode 100644 other.txt
#         create mode 100644 sample.txt
```

## 10.7 Modifying Files and Viewing Changes

### Overview
After committing files, any subsequent modifications are tracked by Git, allowing users to see exactly what changed before staging new versions.

### Key Concepts

**Change Detection**
- Git tracks modifications to committed files
- Modified files appear in red until staged
- The `+` symbol in diff output indicates additions

**Workflow Cycle**
1. Modify files
2. Check status to see changes
3. Stage modified files
4. Review staged changes
5. Commit the changes

### Code Examples

```bash
# Modify a committed file
echo "New content" >> other.txt

# Check status - shows modification
git status
# Output: modified: other.txt (not staged)

# View the actual changes
git diff other.txt
# Shows: +New content (the addition)

# Stage the modified file
git add other.txt

# Commit the change
git commit -m "Update other.txt with new content"
```

## Summary

### Key Takeaways

```diff
+ Git command-line is the primary interface for version control operations
+ Repository initialization uses 'git init' to create local repositories
+ Status command provides real-time visibility into repository state
+ Two-step process (add then commit) provides granular control over changes
+ Staging area allows selective preparation of commits
+ All changes are tracked with complete history preservation
```

### Quick Reference

| Command | Purpose | Example |
|---------|---------|---------|
| `git --version` | Check installation | `git --version` |
| `git init` | Initialize repository | `git init` |
| `git status` | Check repository state | `git status` |
| `git add <file>` | Stage file for commit | `git add sample.txt` |
| `git commit -m "msg"` | Create commit | `git commit -m "Initial commit"` |
| `git diff <file>` | View changes | `git diff other.txt` |

### Expert Insight

**Real-world Application**
- Use `git status` frequently to maintain awareness of your working state
- Stage related changes together for coherent, logical commits
- Write descriptive commit messages that explain the "why" behind changes

**Expert Path**
- Explore `git help <command>` for detailed command documentation
- Learn Git aliases to speed up common workflows
- Master the staging area to create atomic, meaningful commits

**Common Pitfalls**
- Forgetting to add files before committing (empty commits)
- Writing vague commit messages that don't explain changes
- Not checking status before making assumptions about repository state

**Lesser-Known Facts**
- The staging area was originally designed for preparing partial commits from complex changes
- Git's two-step process enables powerful workflows like interactive staging (`git add -p`)
- Terminal Git indicators are shell customizations, not built-in Git features

</details>