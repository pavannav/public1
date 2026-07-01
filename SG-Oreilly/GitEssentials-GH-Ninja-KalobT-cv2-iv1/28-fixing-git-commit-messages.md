# Section 28: Fixing Git Commit Messages

<details open>
<summary><b>28-Fixing-Git-Commit-Messages (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Creating a Commit with Intentional Typo](#creating-a-commit-with-intentional-typo)
- [Using git commit --amend to Fix Commit Messages](#using-git-commit---amend-to-fix-commit-messages)
- [Pushing Amended Commits](#pushing-amended-commits)
- [Summary](#summary)

## Overview
This session demonstrates how to fix typos or mistakes in Git commit messages using the `git commit --amend` command. The instructor shows a practical scenario where a commit message contains a typo, then walks through the process of amending it before pushing to GitHub. This is an essential skill for maintaining clean commit history.

## Creating a Commit with Intentional Typo

### Setting Up the Example
The instructor creates a practical demonstration by intentionally creating a commit with a typo in the message:

```bash
# Create a new file to commit
touch bad_commit_message.txt

# Check git status to see the new file
git status

# Stage and commit the file with a typo
git add bad_commit_message.txt
git commit -m "This is a tpyo in the commit message"
```

### Verifying the Commit
After creating the problematic commit:

```bash
# View recent commits to see the typo
git log --oneline

# Output shows the typo in the commit message
abc1234 This is a tpyo in the commit message
```

**Important Note**: Since this commit hasn't been pushed to GitHub yet, it can still be modified.

## Using git commit --amend to Fix Commit Messages

### The Amendment Command
The key command for fixing the most recent commit message:

```bash
git commit --amend
```

### What Happens When Running the Command
1. Opens the commit message in the default text editor (Vim, Nano, or configured editor)
2. Displays the current commit message for editing
3. Allows modification of the message
4. Preserves the commit timestamp and other metadata

### Editing the Message
Example of fixing the typo:

**Before:**
```
This is a tpyo in the commit message
```

**After:**
```
This is a typo in the commit message was fixed
```

### Saving the Changes
- **Vim**: `:wq` or `Esc` then `:x`
- **Nano**: `Ctrl+O` (save), press Enter, `Ctrl+X` (exit)
- After saving, the commit is updated with the new message

### Verifying the Fix
```bash
git log --oneline

# Shows the corrected commit message
abc1234 This is a typo in the commit message was fixed
```

## Pushing Amended Commits

### The Push Command
After amending the commit message:

```bash
git push origin master
```

### Pre-Push Verification Tip
**Best Practice**: Always check your commit messages before pushing:

```bash
git log --oneline -5
```

This helps catch typos that might slip through during the commit process.

## Summary

### Key Takeaways
```diff
+ git commit --amend modifies the most recent commit
+ Can fix typos, spelling errors, or improve commit message clarity
+ Only works on commits that haven't been pushed yet
+ Opens the default text editor for message modification
+ The commit SHA changes when amending messages
```

### Quick Reference
| Command | Purpose |
|---------|---------|
| `git commit --amend` | Edit the most recent commit message |
| `git log --oneline` | View recent commits to check messages |
| `git push origin master` | Push amended commit to remote |

### Expert Insight

#### Real-world Application
In professional development, maintaining clear and accurate commit messages is crucial for:
- Code review processes
- Understanding project history
- Debugging and troubleshooting
- Generating release notes

#### Expert Path
To further improve commit message quality:
1. Set up a commit message template
2. Configure your preferred editor for commit messages
3. Use conventional commit standards
4. Consider implementing commit message hooks for validation

#### Common Pitfalls
- ⚠️ Attempting to amend already-pushed commits (requires force push, which can cause issues for collaborators)
- ⚠️ Not checking commit messages before pushing
- ⚠️ Making commits too quickly without reviewing the message

#### Lesser-Known Facts
- The `--amend` flag can also be used to add forgotten files to the last commit using `git commit --amend --no-edit`
- Amending a commit creates a new commit object entirely, just with similar content
- Git's default commit message template can be customized in `.gitmessage` file

</details>