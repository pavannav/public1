# Section 35: Resolving Merge and Rebase Conflicts

<details open>
<summary><b>Section 35: Resolving Merge and Rebase Conflicts (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [Overview](#overview)
- [35.1 Understanding Git Conflicts](#351-understanding-git-conflicts)
- [35.2 Setting Up a Merge Conflict Scenario](#352-setting-up-a-merge-conflict-scenario)
- [35.3 Resolving a Merge Conflict](#353-resolving-a-merge-conflict)
- [35.4 Setting Up a Rebase Conflict Scenario](#354-setting-up-a-rebase-conflict-scenario)
- [35.5 Resolving a Rebase Conflict](#355-resolving-a-rebase-conflict)
- [35.6 Key Differences Between Merge and Rebase Conflict Resolution](#356-key-differences-between-merge-and-rebase-conflict-resolution)
- [Summary](#summary)

## Overview
This session provides comprehensive, hands-on demonstrations of how to identify, understand, and resolve both merge and rebase conflicts in Git. The instructor walks through practical scenarios where conflicts occur during `git pull` operations and `git rebase` commands, showing students exactly how Git marks conflicts, how to interpret conflict markers, and the step-by-step process for resolving them. Both types of conflicts are covered to prepare students for real-world collaborative development workflows.

## 35.1 Understanding Git Conflicts

### What is a Git Conflict?
A conflict occurs when:
- Two changes exist in the same file at the same location
- Multiple contributors modify the same line of code
- Git cannot automatically determine which version to keep

```diff
! Conflict triggers: git pull, pull request merges, git rebase
```

### The Nature of Git Conflicts
Git is not artificial intelligence — it's version control software. When a conflict arises:

> [!IMPORTANT]
> Git requires you to make a decision about a particular line of code

The three options when resolving conflicts:
1. Keep version A
2. Keep version B
3. Create a hybrid by editing the code manually

### Types of Conflicts Covered
This session demonstrates two conflict types:
1. **Merge conflicts** — via `git pull` operations
2. **Rebase conflicts** — via `git rebase` commands

## 35.2 Setting Up a Merge Conflict Scenario

### Creating the Remote File on GitHub
The instructor creates a test file directly on GitHub:

1. Creates file: `merge-conflict.txt`
2. Content: Five lines numbered 1-5
   ```
   line 1 by github
   line 2 by github
   line 3 by github
   line 4 by github
   line 5 by github
   ```
3. Commits directly to master branch

### Replicating the File Locally
```bash
# Create identical file locally with modification
vim merge-conflict.txt
```

Content created locally:
```
line 1 by github
line 2 by github
line 3 edited locally
line 4 by github
line 5 by github
```

### Attempting to Push Creates the Conflict
```bash
git status
git add merge-conflict.txt
git commit -m "merge conflict file added locally"
git pull origin master  # Triggers the conflict
```

### Git's Conflict Response
```
Auto-merging merge-conflict.txt
CONFLICT (content): Merge conflict in merge-conflict.txt
Automatic merge failed; fix conflicts and then commit the result.
```

## 35.3 Resolving a Merge Conflict

### Identifying Conflicted Files
```bash
git status
# Shows files with conflicts that need resolution
```

### Understanding Conflict Markers
Git inserts special markers to show conflicting sections:

```diff
<<<<<<< HEAD
line 3 edited locally
=======
line 3 by github
>>>>>>> <commit-hash>
```

The markers indicate:
- `<<<<<<< HEAD`: Your local changes start here
- `=======`: Divider between versions
- `>>>>>>> <commit-hash>`: Remote/original version ends here

### Resolution Process
```bash
# Open the file in any text editor
vim merge-conflict.txt    # or VS Code, Sublime, nano
```

Resolution steps:
1. Remove all conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`)
2. Choose which content to keep OR create a hybrid
3. Save the file

Example resolved version:
```
line 1 by github
line 2 by github
line 3 edited locally
line 4 by github
line 5 by github
```

### Completing the Merge
```bash
git status  # Verify conflict markers are removed
git add merge-conflict.txt
git commit  # Git creates merge commit automatically
git log --oneline  # View the merge commit
git push origin master  # Push resolved changes
```

## 35.4 Setting Up a Rebase Conflict Scenario

### Creating a Branch Point
```bash
# Ensure on master branch
git checkout master

# Create and commit file on master
vim rebase-conflict.txt
# Content with 5 lines + extra line
git add rebase-conflict.txt
git commit -m "rebase conflict example file"
```

### Creating a Divergent Branch
```bash
# Go back to earlier commit
git checkout <commit-hash>
git checkout -b rebase-conflict-branch

# Create same file with different content
vim rebase-conflict.txt
# Modify lines 3 and 5 differently
git add rebase-conflict.txt
git commit -m "rebase conflict file from a branch"
```

### Initiating the Rebase
```bash
git checkout master
git rebase rebase-conflict-branch
# Triggers conflict during rebase
```

## 35.5 Resolving a Rebase Conflict

### Git's Rebase Conflict Response
```
CONFLICT (content): Merge conflict in rebase-conflict.txt
Patch failed at 0001 rebase conflict example
Use 'git am --show-current-patch' to see the failed patch

Resolve all conflicts manually, mark as resolved with
'git add/rm <conflicted_files>', then run 'git rebase --continue'.
```

### Alternative Rebase Commands
- `git rebase --continue`: Proceed after resolving conflicts
- `git rebase --skip`: Skip current patch if no conflict exists
- `git rebase --abort`: Cancel the entire rebase operation

### Resolution Process
```bash
git status  # Shows conflicted files
git diff    # View the differences

# Edit the conflicted file
vim rebase-conflict.txt

# Remove conflict markers and choose/combine content
# Save the file
```

Example hybrid resolution:
```
line 1 by github
line 2 by github
line 3 by github (from master)
line 4 by github
line 5 by github
line 6 Not from github, this is from local (from rebase branch)
```

### Completing the Rebase
```bash
git add rebase-conflict.txt
git rebase --continue

# Verify clean history
git log --oneline
git lg  # Shows straight-line history (rebase benefit)
```

## 35.6 Key Differences Between Merge and Rebase Conflict Resolution

### Merge Conflict Resolution Workflow
```
git pull → conflict occurs → edit file → git add → git commit
```

### Rebase Conflict Resolution Workflow
```
git rebase → conflict occurs → edit file → git add → git rebase --continue
```

### The Critical Difference
> [!NOTE]
> The only difference is the final command:
> - Merge: `git commit` (creates a merge commit)
> - Rebase: `git rebase --continue` (applies changes linearly)

### Common Resolution Elements
Both approaches require:
1. Removing conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`)
2. Deciding which content to keep
3. Staging resolved files with `git add`
4. Following Git's guidance in error messages

## Summary

### Key Takeaways
```diff
+ Conflicts occur when the same line is changed in two places
+ Git requires manual intervention to resolve conflicts
+ Conflict markers (<<<<<<< ======= >>>>>>>) show the conflicting versions
+ Both merge and rebase conflicts are resolved by editing files
+ The key difference is the command after staging: commit vs rebase --continue
+ Rebase creates cleaner, linear history after conflict resolution
```

### Quick Reference

| Scenario | Trigger Command | Resolution Steps | Final Command |
|----------|----------------|------------------|---------------|
| Merge Conflict | `git pull` | Edit → `git add` | `git commit` |
| Rebase Conflict | `git rebase` | Edit → `git add` | `git rebase --continue` |
| View conflicts | `git diff` | - | - |
| Abort rebase | - | - | `git rebase --abort` |
| Skip patch | - | - | `git rebase --skip` |

### Expert Insight

#### Real-world Application
In production workflows, conflict resolution is essential when:
- Multiple developers work on the same feature branch
- Long-running feature branches are rebased onto updated main branches
- Pull request reviews require incorporating upstream changes

#### Expert Path
- Practice resolving conflicts in a test repository until comfortable
- Use IDE conflict resolution tools (VS Code, IntelliJ) for visual assistance
- Establish team conventions for handling frequent conflict scenarios
- Learn `git rerere` (reuse recorded resolution) for recurring conflicts

#### Common Pitfalls
- ❌ Accidentally committing conflict markers to the repository
- ❌ Not communicating with team members about conflicting changes
- ❌ Using `git rebase --skip` without understanding the skipped changes
- ❌ Forgetting to stage all resolved files before continuing

#### Lesser-Known Facts
- Git's three-way merge algorithm can sometimes resolve conflicts automatically
- The conflict marker format is configurable via `merge.conflictStyle`
- IDEs can be configured as the default merge tool with `git mergetool`
- Conflict resolution skills transfer between different Git hosting platforms

</details>