<details open>
<summary><b>36-How-to-Stash-Code (KK-CS45-script-v2-Inst-v1)</b></summary>

# 36: How to Stash Code

## Table of Contents
- [Overview](#overview)
- [Understanding Git Stash](#understanding-git-stash)
- [Why Use Stash](#why-use-stash)
- [Creating a Stash](#creating-a-stash)
- [Viewing Stashes](#viewing-stashes)
- [Applying a Stash](#applying-a-stash)
- [Managing Stashes](#managing-stashes)
- [Advanced Stash Usage](#advanced-stash-usage)
- [Summary](#summary)

## Overview

Git stash provides a mechanism to temporarily save uncommitted changes, allowing you to switch contexts without losing work-in-progress. This session demonstrates how to use stash to handle interruptions, work on urgent tasks, and seamlessly return to previous work.

## Understanding Git Stash

### What is Stashing?

Stashing in Git allows you to save modifications to your working directory and staging area for later use. Think of it as a "treasure chest" of code that:
- Saves changes behind the scenes
- Hides uncommitted work without committing it
- Preserves your changes for later retrieval
- Creates a save point without affecting Git history

```bash
git stash
```

### The Problem Stash Solves

When you need to switch branches but have uncommitted work:
- ❌ Cannot commit incomplete work
- ❌ Cannot lose changes by switching branches
- ❌ Cannot continue on different branches with conflicting changes
- ✅ Stash provides a temporary storage solution

## Why Use Stash

### Common Scenarios

1. **Urgent Production Fixes**: Being pulled from feature development to fix a production bug
2. **Branch Conflicts**: Need to work on the same file in multiple branches with different changes
3. **Context Switching**: Frequent task changes requiring different branches
4. **Code Review**: Need to examine other commits while preserving current work

### Key Benefits

- **Non-Destructive**: Changes are preserved, not lost
- **Flexible**: Apply stashes to any branch
- **Multiple Stashes**: Store multiple sets of changes
- **Global Storage**: Stashes are not branch-specific

## Creating a Stash

### Step-by-Step Example

1. **Create and switch to a feature branch**:
```bash
git branch stash-example
git checkout stash-example
```

2. **Make uncommitted changes**:
```bash
# Edit README file
vim README.md
```

3. **Check current status**:
```bash
git status
git diff
```

4. **Attempt to switch branches** (problem occurs):
```bash
git checkout master
# Changes follow to master branch - potential conflicts!
```

5. **Create the stash** (solution):
```bash
git checkout stash-example
git stash
```

**Output example**:
```
Saved working directory and index state WIP on stash-example: abc1234 initial commit
```

## Viewing Stashes

### List All Stashes

```bash
git stash list
```

**Output**:
```
stash@{0}: WIP on stash-example: abc1234 initial commit
```

### Visual Branch History

```bash
git lg
```

This shows stash references in the branch visualization, making it easy to track where stashes exist.

## Applying a Stash

### Retrieve Stashed Changes

After completing urgent work on another branch:

```bash
git checkout stash-example
git stash apply
```

**Verify the changes**:
```bash
git diff
# Shows changes from the stash
```

### Important Notes

- ✅ Stashed changes are re-applied to your working directory
- ✅ Original work remains intact
- ✅ You can continue exactly where you left off
- ❌ Stash reference remains after applying

## Managing Stashes

### Removing Applied Stashes

After successfully applying a stash:

```bash
git stash drop
```

This removes the latest stash (stash@{0}).

### Complete Workflow Example

```bash
# 1. Create stash
git stash
git stash list  # Shows stash@{0}

# 2. Do other work
git checkout master
# ... make changes and commit ...

# 3. Return and apply stash
git checkout stash-example
git stash apply
git diff  # Verify changes restored

# 4. Clean up
git stash drop
git stash list  # Empty
```

## Advanced Stash Usage

### Working with Detached HEAD

Stash works even when checking out specific commits:

```bash
# Checkout an old commit
git checkout <commit-hash>
# Results in detached HEAD state

# Work with the old code
# Make experimental changes

# Return to your branch
git checkout stash-example

# Reapply any stashes created
git stash apply
```

### Multiple Stashes

You can create multiple stashes:
```bash
git stash        # Creates stash@{0}
git stash        # Creates stash@{1}
# ... and so on
```

Apply specific stashes by reference:
```bash
git stash apply stash@{1}
```

## Summary

### Key Takeaways

```diff
+ Stash saves uncommitted changes without creating commits
+ Use stash when switching contexts or handling urgent tasks
+ Stashes are global and can be applied to any branch
+ Always drop stashes after applying to keep clean
+ Git log shows stash references for tracking
```

### Quick Reference

| Command | Description |
|---------|-------------|
| `git stash` | Save current changes to stash |
| `git stash list` | View all stashes |
| `git stash apply` | Apply latest stash (keeps in list) |
| `git stash drop` | Remove latest stash |
| `git stash apply stash@{N}` | Apply specific stash |

### Expert Insight

**Real-world Application**: In professional development, developers often juggle multiple tasks. Stash enables seamless context switching between production fixes, feature development, and code reviews without risking lost work or creating messy commit histories.

**Expert Path**: Master advanced stash options like `git stash push -m "message"` for named stashes, `git stash pop` to apply and remove in one step, and `git stash branch <name>` to create a new branch from a stash.

**Common Pitfalls**:
- Forgetting to drop applied stashes, leading to confusion
- Not verifying which stash is being applied
- Assuming stashes are branch-specific (they're global)

**Lesser-Known Facts**: Git stash actually creates commits behind the scenes - it creates two commits (one for the index, one for working directory) and stores them in a special ref `refs/stash`.

</details>