<details open>
<summary><b>24-Demonstration-Resolving-Merge-Conflicts (KK-CS45-script-v2-Inst-v1)</b></summary>

# 24-Demonstration-Resolving-Merge-Conflicts

## Table of Contents
- [Overview](#overview)
- [Demonstration: Resolving Merge Conflicts](#demonstration-resolving-merge-conflicts)
  - [Setup and Preparation](#setup-and-preparation)
  - [Creating Branches with Conflicting Changes](#creating-branches-with-conflicting-changes)
  - [Triggering the Merge Conflict](#triggering-the-merge-conflict)
  - [Resolving the Conflict](#resolving-the-conflict)
  - [Committing the Resolution](#committing-the-resolution)
- [Summary](#summary)
  - [Key Takeaways](#key-takeaways)
  - [Quick Reference](#quick-reference)
  - [Expert Insight](#expert-insight)

## Overview
This demonstration provides a hands-on walkthrough of resolving merge conflicts in Git. You'll learn why merge conflicts occur, how to identify conflict markers, and the step-by-step process to resolve them while preserving changes from both branches.

## Demonstration: Resolving Merge Conflicts

### Setup and Preparation
The demonstration begins with organizing the workspace and creating the necessary files for demonstrating merge conflicts.

**Organizing TXT Files:**
```bash
ls -l
git mv *.txt txt/
git status
git commit -m "TXT files moved"
```

**Creating the Merge File:**
```bash
echo "This is the first merge" > merge.txt
cat merge.txt
git add .
git commit -m "merge.txt file added"
git status
```

At this point, the working tree is clean with only the master branch containing the initial merge.txt file.

### Creating Branches with Conflicting Changes
To demonstrate a conflict, changes are made to the same file in two different branches.

**Creating and Modifying the Feature Branch:**
```bash
git checkout -b feature
# Add to merge.txt: "This content is added via the feature branch"
git status
git commit -am "merge.txt file modified"
```

The `-am` flag combines staging all changes (`-a`) and committing with a message (`-m`) in one step.

**Switching Back to Master:**
```bash
git switch master
# Add to merge.txt: "This change is done via the master branch"
git status
git commit -am "merge.txt file modified via master branch"
git log --oneline
```

Now both branches have modified the same file differently, setting up the conditions for a merge conflict.

### Triggering the Merge Conflict
Attempting to merge the feature branch into master triggers the conflict:

```bash
git merge feature
```

Git reports:
```
Auto-merging merge.txt
CONFLICT (content): Merge conflict in merge.txt
Automatic merge failed; fix conflicts and then commit the result.
```

### Resolving the Conflict
When a conflict occurs, Git inserts conflict markers into the affected file:

```
<<<<<<< HEAD
This change is done via the master branch
=======
This content is added via the feature branch
>>>>>>> feature
```

**Understanding Conflict Markers:**
- `<<<<<<< HEAD`: Marks the beginning of changes from the current branch (master)
- `=======`: Divider between conflicting versions
- `>>>>>>> feature`: Marks the end of changes from the merging branch (feature)

**Resolution Process:**
1. Open the file with a text editor
2. Decide which content to keep (master's changes, feature's changes, or both)
3. Remove all conflict markers
4. Save the file

In this demonstration, both lines are kept:
```
This change is done via the master branch
This content is added via the feature branch
```

### Committing the Resolution
```bash
git status
git commit -am "merge conflict resolved"
git status
git log --oneline
```

The merge commit appears in the history, showing the successful resolution of the conflict.

## Summary

### Key Takeaways
```diff
+ Merge conflicts occur when Git cannot automatically merge changes from different branches
+ Conflict markers (<<<<<<<, =======, >>>>>>>) clearly delineate the conflicting versions
+ Manual resolution requires choosing content from master, feature, or combining both
+ The -am flag provides an efficient way to stage and commit changes in one command
+ Git provides helpful guidance including the git merge --abort option if needed
```

### Quick Reference
| Command | Purpose |
|---------|---------|
| `git checkout -b <branch>` | Create and switch to a new branch |
| `git commit -am "<message>" | Stage all changes and commit with message |
| `git merge <branch>` | Merge specified branch into current branch |
| `git merge --abort` | Abort ongoing merge and revert to pre-merge state |
| `git log --oneline` | View commit history in compact format |

### Expert Insight

**Real-world Application:**
Merge conflicts are a regular occurrence in collaborative development environments. Understanding how to resolve them efficiently is crucial for maintaining smooth team workflows and preventing blocked development cycles.

**Expert Path:**
- Practice resolving different types of conflicts (content, filename, delete/modify)
- Learn to use merge tools like `git mergetool` for visual conflict resolution
- Understand when to use `git rebase` vs `git merge` to minimize conflicts
- Develop habits for frequent pulling and small commits to reduce conflict likelihood

**Common Pitfalls:**
- Accidentally committing conflict markers along with the resolved file
- Not understanding which branch's changes (HEAD vs merging branch) each section represents
- Forgetting to test after resolving conflicts, especially when keeping changes from both branches
- Using `git merge --abort` without understanding it will lose merge progress

**Lesser-Known Facts:**
- The conflict marker format is customizable via `merge.conflictStyle` configuration
- Git can be configured with custom merge drivers for specific file types
- The `.git/MERGE_MSG` file contains the default merge commit message during conflict resolution
- Using `git log --merge -p <file>` shows commits that touched a file between merge bases

</details>