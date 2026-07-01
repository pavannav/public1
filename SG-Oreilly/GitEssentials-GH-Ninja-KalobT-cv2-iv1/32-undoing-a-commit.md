# Section 32: Undoing a Commit

<details open>
<summary><b>Section 32: Undoing a Commit (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents

- [Overview](#overview)
- [Understanding Git Reset](#understanding-git-reset)
- [Soft Reset](#soft-reset)
- [Hard Reset](#hard-reset)
- [Lab Demo: Hard Reset](#lab-demo-hard-reset)
- [Lab Demo: Soft Reset](#lab-demo-soft-reset)
- [Key Takeaways](#key-takeaways)
- [Quick Reference](#quick-reference)
- [Expert Insight](#expert-insight)

## Overview

This module covers the critical skill of undoing commits in Git using two primary methods: soft reset and hard reset. Understanding the difference between these approaches is essential for safely managing your local repository and recovering from mistakes like merging the wrong branch.

## Understanding Git Reset

Git provides two fundamental ways to undo local work through the `git reset` command:

1. **Soft Reset** (`--soft`): Undoes commits but preserves changes in the staging area
2. **Hard Reset** (`--hard`): Completely removes commits and all associated changes

> [!IMPORTANT]
> Always ensure you have a backup or are certain about your actions before performing resets, especially hard resets.

## Soft Reset

A soft reset allows you to undo commits while keeping your changes staged and ready for recommitment.

### Key Characteristics:
- Removes commit(s) from history
- Keeps all file changes in the staging area
- Allows you to review and recommit changes if needed
- Safe option when you want to preserve your work

### Syntax:
```bash
git reset --soft <commit-hash>
git reset --soft origin/master
```

### Use Case:
Perfect for scenarios where you've committed changes prematurely or want to restructure your commits without losing work.

## Hard Reset

A hard reset is more destructive, completely removing commits and all associated changes from your repository.

### Key Characteristics:
- Removes commit(s) from history
- Deletes all file changes associated with those commits
- Cannot be easily recovered (data loss)
- Use with extreme caution

### Syntax:
```bash
git reset --hard <commit-hash>
git reset --hard origin/master
```

### Use Case:
Appropriate when you want to completely discard mistaken work, such as when you've merged the wrong branch.

## Lab Demo: Hard Reset

### Scenario Setup:
1. Create a new file and commit it:
   ```bash
   touch sample.txt
   git status
   git add sample.txt
   git commit -m "undo this commit to please"
   git log --oneline
   ```

2. Verify you're ahead of origin:
   ```bash
   # Head and master show one commit ahead of origin/master
   ```

3. Perform hard reset:
   ```bash
   git reset --hard origin/master
   # Output: HEAD is now at [commit ID]
   ```

4. Verify results:
   ```bash
   git log --oneline    # Commit is gone
   git status           # No uncommitted changes
   ls -la               # sample.txt is completely gone
   ```

> [!CAUTION]
> The sample.txt file has been permanently deleted from your working directory.

## Lab Demo: Soft Reset

### Scenario Setup:
1. Create another file and commit:
   ```bash
   touch sample.txt
   git status
   git add .
   git commit -m "undo this commit but keep the file"
   git log --oneline
   ```

2. Perform soft reset:
   ```bash
   git reset --soft origin/master
   ```

3. Verify results:
   ```bash
   git log --oneline    # Back to origin/master
   git status           # sample.txt is staged and ready
   ```

4. Optional: Unstage the file:
   ```bash
   git reset sample.txt
   git status           # File is now unstaged
   ```

5. Optional: Remove the file completely:
   ```bash
   rm sample.txt
   git status           # Working directory is clean
   ```

## Key Takeaways

```diff
+ Soft reset preserves your changes while undoing commits
+ Hard reset completely removes commits and changes (data loss)
+ Use origin/master as a safe reference point to reset to
+ Always check git status and git log before resetting
- Hard reset cannot be undone easily - use with caution
- Never reset commits that have been pushed to shared repositories
```

## Quick Reference

| Command | Description | Data Preservation |
|---------|-------------|-------------------|
| `git reset --soft <commit>` | Undo commits, keep changes staged | ✅ All changes preserved |
| `git reset --hard <commit>` | Undo commits, delete all changes | ❌ Data deleted |
| `git reset <file>` | Unstage specific file | ✅ Changes preserved |
| `git log --oneline` | View commit history compactly | N/A |
| `git status` | Check current state | N/A |

## Expert Insight

### Real-world Application
In production environments, soft resets are frequently used for:
- Restructuring commit history before pushing
- Fixing commit messages or combining related changes
- Recovering from accidental commits during feature development

Hard resets should only be used:
- For local work that hasn't been shared
- When completely discarding experimental branches
- As a last resort for recovering from merge errors

### Expert Path
To master Git resets:
1. Practice both reset types in a test repository
2. Learn to use `git reflog` for recovery scenarios
3. Understand the reflog's retention period (usually 30 days)
4. Master the `git stash` command as an alternative to preserving changes

### Common Pitfalls
- Using hard reset on shared branches causes conflicts for team members
- Forgetting to check current status before resetting
- Not having a backup strategy for important work
- Confusing reset with revert (revert creates a new commit to undo changes)

### Lesser-Known Facts
- `git reset --soft` is essentially what interactive rebasing does under the hood
- You can reset to any commit in your history, not just the immediate parent
- The reflog (`git reflog`) records all HEAD movements, allowing recovery from "lost" commits
- `origin/master` serves as a dynamic reference that updates when you fetch/pull

</details>