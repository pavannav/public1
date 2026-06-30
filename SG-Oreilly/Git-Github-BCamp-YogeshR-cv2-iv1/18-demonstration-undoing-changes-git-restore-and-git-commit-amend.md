# 18: Demonstration - Undoing Changes: git restore and git commit --amend

<details open>
<summary><b>18: Demonstration - Undoing Changes: git restore and git commit --amend (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Module 18.1: Understanding Git Restore for Unstaging Files](#module-181-understanding-git-restore-for-unstaging-files)
- [Module 18.2: Discarding Local Changes with Git Restore](#module-182-discarding-local-changes-with-git-restore)
- [Module 18.3: Amending Commits with Git Commit --amend](#module-183-amending-commits-with-git-commit---amend)
- [Summary](#summary)

## Overview

This demonstration covers essential Git commands for undoing changes and fixing mistakes in your workflow. You'll learn how to unstage files, discard unwanted modifications, and amend previous commits without creating unnecessary new commits. These skills are crucial for maintaining a clean and accurate commit history.

## Module 18.1: Understanding Git Restore for Unstaging Files

### Overview

This module demonstrates how to use `git restore --staged` to move files back out of the staging area when you need to make additional changes before committing.

### Key Concepts/Deep Dive

When working with files in Git, there are times when you stage changes but then realize you need to make more modifications before committing. Rather than committing incomplete work, you can unstage the file while preserving your changes.

**Workflow demonstration:**
1. Modify a file and check its status:
   ```bash
   echo "Hello from Thin Crook" >> mynotes.txt
   git status
   # Shows: modified: mynotes.txt
   ```

2. Stage the file:
   ```bash
   git add mynotes.txt
   git status
   # Shows: Changes to be committed: mynotes.txt
   ```

3. Unstage the file using git restore:
   ```bash
   git restore --staged mynotes.txt
   git status
   # Shows: modified: mynotes.txt (not staged)
   ```

### Important Notes

> [!NOTE]
> The `git restore --staged` command only unstages the file but keeps all your changes intact in the working directory. You can continue editing the file before staging it again.

## Module 18.2: Discarding Local Changes with Git Restore

### Overview

This module shows how to completely discard unwanted changes from your working directory using `git restore` without any flags, reverting files to their last committed state.

### Key Concepts/Deep Dive

**Scenario: Removing accidental changes**

When you add unwanted content to a file and want to remove those changes entirely:

```bash
# Add unwanted content
echo "This is extra content" >> mynotes.txt

# Check status
git status
# Shows: modified: mynotes.txt

# Discard all changes and restore to last committed state
git restore mynotes.txt

# Verify - file returns to previous state
git status
# Shows: nothing to commit, working tree clean
```

### ⚠️ Critical Warning

> [!IMPORTANT]
> `git restore` without flags permanently discards changes from your working directory. This action cannot be undone. Always double-check before using this command, or consider using `git stash` if you might need the changes later.

### Command Summary

| Command | Purpose | Effect |
|---------|---------|---------|
| `git restore --staged <file>` | Unstage a file | Moves file out of staging area but keeps changes |
| `git restore <file>` | Discard changes | Removes all modifications, restores to last commit |

## Module 18.3: Amending Commits with Git Commit --amend

### Overview

This module explains how to use `git commit --amend` to fix mistakes in the most recent commit, such as incorrect commit messages or forgotten files, without creating additional commits.

### Key Concepts/Deep Dive

**Scenario 1: Adding forgotten files to the last commit**

```bash
# Create and commit initial file
echo "Hello from Thin Crook" > hello.txt
git add hello.txt
git commit -m "Added hello file"

# Create another file that should have been included
echo "Welcome to Thin Crook" > welcome.txt
git add welcome.txt

# Amend the previous commit instead of creating a new one
git commit --amend
# Opens editor - save to include both files in the commit
```

**Scenario 2: Fixing commit message only**

```bash
# Amend only the commit message without adding new files
git commit --amend -m "Added hello and welcome files"
```

### Verification Steps

After amending:
- Run `git status` to confirm working tree is clean
- Run `git log --oneline` to see the updated commit message
- The commit SHA will change as the commit content has been modified

## Summary

### Key Takeaways

```diff
+ git restore --staged: Unstage files while keeping changes for further editing
+ git restore: Discard unwanted changes and revert to last committed state
+ git commit --amend: Fix the last commit by adding files or correcting messages
- Be extremely careful with git restore as it permanently discards changes
- git commit --amend creates a new commit object with a different SHA
```

### Quick Reference

```bash
# Unstaging files
git restore --staged <filename>

# Discarding changes
git restore <filename>

# Amending commits
git commit --amend                    # Opens editor for message
git commit --amend -m "new message"   # Provides new message directly
```

### Expert Insights

**Real-world Application:**
In production environments, these commands are essential for maintaining clean commit histories. Teams often use `git commit --amend` when reviewing commits before pushing, ensuring commit messages are clear and all related changes are grouped together. This helps with code review processes and makes git bisect operations more reliable.

**Expert Path:**
- Master the difference between `git restore`, `git checkout`, and `git reset` for different undo scenarios
- Practice with `git reflog` to recover from accidental `git restore` operations
- Learn about `git commit --amend --no-edit` to amend without changing the message
- Understand the implications of amending commits that have been pushed to shared repositories

**Common Pitfalls:**
- Using `git restore` without checking what will be discarded
- Amending commits that have already been pushed to remote repositories (requires force push)
- Not realizing that amending changes the commit hash, which can cause issues for collaborators

**Lesser-Known Facts:**
- `git restore` was introduced in Git 2.23 as a more intuitive replacement for certain `git checkout` use cases
- You can use `git restore --source=HEAD~1 <file>` to restore a file from a specific commit
- `git commit --amend` can be combined with `--author` to change commit authorship

</details>