# Section 15: Demonstration - Tracking & Untracking Files (git status, add, commit, log)

<details open>
<summary><b>Section 15: Demonstration - Tracking & Untracking Files (git status, add, commit, log) (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Git File Lifecycle States](#git-file-lifecycle-states)
- [Git Status Command](#git-status-command)
- [Creating and Viewing Files](#creating-and-viewing-files)
- [Git Add Command - Staging Files](#git-add-command---staging-files)
- [Batch Staging with Flags](#batch-staging-with-flags)
- [Git Commit Command](#git-commit-command)
- [Understanding Git Objects](#understanding-git-objects)
- [Git Log Command](#git-log-command)
- [Complete Workflow Summary](#complete-workflow-summary)
- [Key Takeaways](#key-takeaways)
- [Quick Reference](#quick-reference)
- [Expert Insights](#expert-insights)

## Overview
This session provides a comprehensive hands-on demonstration of Git's file tracking lifecycle, covering how files transition through different states from untracked to committed. The instructor walks through practical commands including `git status`, `git add`, `git commit`, and `git log`, while also exploring Git's internal object storage system.

## Git File Lifecycle States

Git tracks files through a specific lifecycle with four distinct states:

1. **Untracked**: New files that Git hasn't seen yet
2. **Modified**: Files already tracked by Git but with unstaged changes
3. **Staged**: Files whose changes are marked and ready for the next commit
4. **Committed**: Files safely stored in Git's history inside the `.git` folder

```diff
! Untracked → Modified → Staged → Committed
```

The workflow mirrors a submission process:
- Create a new file → Untracked state
- Edit an existing file → Modified state
- Mark changes for final submission → Staged state
- Submit/commit to the local repository → Committed state

## Git Status Command

The `git status` command is fundamental for checking repository state:

```bash
git status
```

**Output shows:**
- Current branch information
- Untracked files
- Staged files ready to commit
- Modified files

Initial repository status after `git init`:
```bash
On branch master
No commits yet
nothing to commit (create/copy files and use "git add" to track)
```

## Creating and Viewing Files

The demonstration creates sample files to track:

```bash
# Create files with content
echo $date: today > notes.txt
echo This is file one > notes1.txt
echo This is file two > notes2.txt

# View created files
ls
cat notes.txt
```

After creating `notes.txt`, running `git status` reveals:
```bash
Untracked files:
  (use "git add <file>..." to include in what will be committed)
        notes.txt
```

This shows Git recognizes the file exists but isn't tracking it yet.

## Git Add Command - Staging Files

The `git add` command moves files from the working directory to the staging area:

```bash
# Add single file
git add notes.txt

# Add multiple files
git add notes1.txt notes2.txt
```

After staging, `git status` shows:
```bash
Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
        new file: notes.txt
```

All staged files appear under "Changes to be committed" and are ready for the next commit.

## Batch Staging with Flags

For efficiency when working with multiple files, Git provides staging flags:

| Flag | Description | Behavior |
|------|-------------|----------|
| `git add -A` | Stage all changes | Includes new, modified, and deleted files |
| `git add -u` | Stage updates | Modifies and deletes only, excludes new files |
| `git add .` | Stage current directory | New files and changes, excludes deletions |

**Key insight**: These flags prevent tedious individual file additions when dealing with 10-12+ files.

## Git Commit Command

Commits capture project snapshots and save them permanently in Git history:

```bash
git commit -m "Added notes files"
```

**Flags explained:**
- `-a`: Automatically stages all modified/deleted tracked files (shortcut)
- `-m`: Required commit message explaining the changes

**Successful commit output:**
```bash
[master (root-commit) abc1234] Added notes files
 3 files changed, 3 insertions(+)
 create mode 100644 notes.txt
 create mode 100644 notes1.txt
 create mode 100644 notes2.txt
```

## Understanding Git Objects

Exploring the `.git` directory reveals how Git internally manages versions:

```bash
cd .git
tree
```

**Key observations after first commit:**
- `objects/` directory now contains created objects (snapshots with unique hash values)
- `refs/` directory contains branch references
- `logs/` directory contains commit log entries

These objects represent actual file snapshots, each stored with unique cryptographic hash values.

## Git Log Command

View commit history with detailed information:

```bash
git log
```

**Displays for each commit:**
- Unique commit hash ID
- Branch information (if applicable)
- Author details from Git configuration
- Commit date and timestamp
- Commit message

This confirms changes are permanently recorded in the repository.

## Complete Workflow Summary

```diff
+ 1. Check status: git status (view tracked/untracked/staged files)
+ 2. Stage changes: git add (move files to staging area)
+ 3. Commit changes: git commit (save snapshot to Git history)
+ 4. View history: git log (check past commits and details)
```

## Key Takeaways

```diff
+ Git tracks files through four distinct states: untracked, modified, staged, committed
+ git status is the primary command for checking repository state
+ git add moves files from working directory to staging area
+ Batch staging flags (-A, -u, .) improve efficiency with multiple files
+ git commit -m creates permanent snapshots with descriptive messages
+ Git internally stores file versions as hashed objects in .git/objects
+ git log provides complete commit history with metadata
```

## Quick Reference

```bash
# Status and tracking
git status                    # Check current repository state
git add <filename>           # Stage specific file
git add -A                   # Stage all changes
git add -u                   # Stage modifications/deletions only
git add .                    # Stage new files and changes

# Committing
git commit -m "message"      # Commit with message
git commit -am "message"     # Stage and commit tracked files

# Viewing history
git log                      # View commit history
```

## Expert Insights

### Real-world Application
Understanding the staging workflow is crucial for professional development practices. The staging area allows developers to carefully curate commits, ensuring each commit represents a logical unit of work. This becomes essential when working on complex features or fixing multiple issues simultaneously.

### Expert Path
- Master the difference between `git add -A`, `git add -u`, and `git add .` to optimize workflow
- Learn to use `git commit --amend` for correcting the last commit
- Practice selective staging with `git add -p` for partial file commits
- Understand Git's object model for advanced repository management

### Common Pitfalls
- Forgetting to stage files before committing (use `git status` frequently)
- Using vague commit messages that don't explain the "why" of changes
- Not understanding the staging area leads to inefficient workflows
- Accidentally staging unwanted files without reviewing changes first

### Lesser-Known Facts
- The staging area is actually a file called "index" in the `.git` directory
- Git objects use SHA-1 hashing for content addressing
- Staged files can be unstaged with `git reset HEAD <file>`
- The first commit in a repository is called the "root commit"

</details>