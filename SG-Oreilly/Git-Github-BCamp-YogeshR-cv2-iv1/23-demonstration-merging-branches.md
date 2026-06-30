# Section 23: Demonstration - Merging Branches

<details open>
<summary><b>Section 23: Demonstration - Merging Branches (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [Overview](#overview)
- [23-Demonstration-Merging-Branches](#23-demonstration-merging-branches)
  - [Setup and Initial Branch Review](#setup-and-initial-branch-review)
  - [Performing Fast-Forward Merge](#performing-fast-forward-merge)
  - [Performing Three-Way Merge](#performing-three-way-merge)
  - [Branch Cleanup](#branch-cleanup)
- [Summary](#summary)

## Overview

This demonstration provides hands-on experience with Git branch merging, showing both fast-forward and three-way merge operations in action. Students will observe how Git handles different merge scenarios and learn practical commands for branch management.

---

## 23-Demonstration-Merging-Branches

### Overview

This module demonstrates practical branch merging techniques in Git, covering fast-forward merges when branches haven't diverged and three-way merges when both branches have independent commits. The session includes live demonstrations of merge strategies and branch cleanup practices.

### Setup and Initial Branch Review

The demonstration begins by examining the current state of a Git repository with multiple branches:

```bash
git branch
```

This command displays three branches: `master`, `feature1`, and `feature2`. Both feature branches contain unmerged commits from previous demonstrations.

**Key observations:**
- Current working directory shows files present in the active branch (master)
- Switching to `feature1` branch reveals an additional file (`group.txt`) not present in master
- The question arises: how to merge this file back into master?

### Performing Fast-Forward Merge

#### Understanding Fast-Forward Conditions

A fast-forward merge occurs when the target branch (master) hasn't moved forward since the source branch (feature1) was created. The master branch pointer simply advances to include all commits from the feature branch.

#### Step-by-Step Fast-Forward Merge Process

1. **Switch to master branch:**
   ```bash
   git switch master
   ```

2. **Review commit history before merge:**
   ```bash
   git log --oneline
   ```
   Output shows only the "hello and welcome" commit - feature branch commits are not visible.

3. **Execute the merge:**
   ```bash
   git merge feature1
   ```
   Git reports: "Fast-forward" with file changes (R.txt added, 1 file changed, 1 insertion)

4. **Verify the merge result:**
   ```bash
   git log --oneline
   ```
   Now shows both "hello and welcome" and "R.txt file added" commits, with HEAD pointing to the feature branch tip.

#### Characteristics of Fast-Forward Merges

- ✅ Clean commit history without merge commits
- ✅ Ideal for small projects or solo development
- ✅ No conflicts to resolve
- ✅ Master branch pointer simply advances forward

### Performing Three-Way Merge

#### Setting Up a Three-Way Merge Scenario

To demonstrate when branches diverge:

1. **Create divergence in master:**
   ```bash
   echo "This is a new file for three way merge" > threeway.txt
   git add threeway.txt
   git commit -m "threeway.txt file"
   ```

2. **Observe independent branch evolution:**
   - Master now has `threeway.txt`
   - Feature2 has `nextx.txt` (different content)
   - Neither branch contains the other's new file

#### Executing a Three-Way Merge

1. **Attempt the merge:**
   ```bash
   git switch master
   git merge feature2
   ```

2. **Git's three-way merge response:**
   - Opens default editor for merge commit message
   - Cannot simply fast-forward due to divergent histories
   - Creates explicit merge commit tying both histories together

3. **Merge commit details:**
   - Uses ORT merge strategy (default since Git 2.33)
   - More memory efficient than older recursive strategy
   - Commit message: "Merge made by the 'ort' strategy"

4. **Review the merge commit:**
   ```bash
   git log --oneline
   ```
   Shows:
   - Original master commit (threeway.txt)
   - Feature2 commit (nextx.txt)
   - New merge commit with two parent commits

### Branch Cleanup

#### Best Practices for Merged Branches

After successful merges, clean up by deleting feature branches:

```bash
git branch -d feature1
git branch -d feature2
```

#### Important Safety Features

- ✅ **Deletion after merge**: Safe to delete merged branches - all commits preserved in master
- ⚠️ **Unmerged branch protection**: Git warns and requires confirmation when deleting unmerged branches
- 💡 **Data preservation**: Deleting branches doesn't delete work - commits remain in target branch

#### Verification

```bash
git branch
```
Only `master` remains, confirming successful cleanup.

---

## Summary

### Key Takeaways

```diff
+ Fast-forward merges are clean and occur when target branch hasn't advanced
+ Three-way merges create explicit merge commits to tie divergent histories
+ Git uses ORT strategy by default since version 2.33 for three-way merges
+ Always delete merged branches to maintain repository cleanliness
- Deleting unmerged branches triggers safety warnings to prevent data loss
```

### Quick Reference

| Command | Description |
|---------|-------------|
| `git branch` | List all branches |
| `git switch <branch>` | Switch to specified branch |
| `git merge <branch>` | Merge branch into current branch |
| `git log --oneline` | View compact commit history |
| `git branch -d <branch>` | Delete merged branch |
| `git branch -D <branch>` | Force delete unmerged branch |

### Expert Insight

**Real-world Application**:
Fast-forward merges are preferred in team environments when using feature branches that are kept up-to-date with master. Three-way merges become necessary in collaborative development where multiple developers work on parallel features, creating natural divergence that requires explicit merge commits for traceability.

**Expert Path**:
- Practice identifying merge scenarios before executing merges
- Understand when `--no-ff` flag might be preferred even for fast-forward situations
- Learn to read merge commit messages effectively for project history understanding
- Master branch management workflows to minimize merge complexity

**Common Pitfalls**:
- Not checking current branch before merging
- Forgetting to commit uncommitted changes before switching branches
- Accidentally force-deleting unmerged branches without reviewing changes
- Not understanding the difference between fast-forward and three-way merge implications for project history

**Lesser-Known Facts**:
- The ORT (Ostensibly Recursive's Twin) strategy replaced recursive as default in Git 2.33
- Merge commits always have two parent commits, making them easily identifiable in git log
- Fast-forward merges leave no trace of the merge operation in commit history
- Git's safety mechanisms prevent accidental deletion of unmerged work

</details>