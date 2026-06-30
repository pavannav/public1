# Session 25: Demonstration - Undoing Changes: git reset and git revert

## Table of Contents
- [Overview](#overview)
- [25-Demonstration-Undoing-Changes-git-reset-and-git-revert](#25-demonstration-undoing-changes-git-reset-and-git-revert)
- [Summary](#summary)

## Overview

This session provides a comprehensive demonstration of two essential Git commands for undoing changes: `git reset` and `git revert`. Students will learn the fundamental differences between these commands, understand when to use each one appropriately, and observe step-by-step demonstrations of their behavior in different scenarios, with special emphasis on safety considerations in collaborative environments.

<details open>
<summary><b>25-Demonstration-Undoing-Changes-git-reset-and-git-revert (KK-CS45-script-v2-Inst-v1)</b></summary>

## Understanding the Need for Undoing Changes

When working on projects, developers occasionally need to undo changes due to errors, bugs, or simply wanting to return to an earlier state. Git provides two primary commands for this purpose: `git reset` and `git revert`. Understanding the distinction between these commands is crucial for effective version control management.

## Git Reset: Rewinding History

### Core Concept
`git reset` moves the current branch pointer backwards in time, effectively telling Git to "forget" about recent commits. This is analogous to rewinding a movie to an earlier point.

### Example Scenario
Consider a repository with commits A, B, and C:
- If you reset back to commit A, commits B and C will no longer be part of your branch
- The unique hash ID of each commit is used to specify the target reset point

### Three Modes of Git Reset

#### 1. Soft Reset (`--soft`)
- **Behavior**: Moves the branch pointer back while keeping all changes staged
- **Use Case**: Ideal for rewriting history while preserving work for recommitting
- **Result**: Changes remain in the staging area, ready for a new commit

#### 2. Mixed Reset (`--mixed`) - Default Mode
- **Behavior**: Moves the pointer back and keeps changes in the working directory but unstaged
- **Details**: Files remain present but must be added again to commit
- **Default**: This mode is used when no option is specified

#### 3. Hard Reset (`--hard`)
- **Behavior**: Most dangerous option - moves pointer back and deletes all changes
- **Warning**: Permanently removes changes from both staging area and working directory
- **Result**: Commits are completely lost as if they never existed

## Git Revert: Preserving History Safely

### Core Concept
Unlike `git reset`, `git revert` creates a brand new commit that undoes the changes of a previous commit without deleting or rewriting history.

### How It Works
- When you commit something that breaks your project, `git revert` doesn't delete that commit
- Instead, it adds a new commit on top that cancels out the problematic changes
- History remains preserved for the entire team to see

### Safety Advantages
- **Collaboration-Friendly**: Everyone can see what happened and nothing is lost
- **History Intact**: All previous commits remain visible in the log
- **Preferred for Teams**: Recommended for shared repositories where maintaining history is important

## Direct Comparison: Reset vs Revert

| Aspect | Git Reset | Git Revert |
|--------|-----------|------------|
| **History** | Rewrites/modifies history | Preserves history |
| **Safety** | Can permanently lose changes | Safe - never loses data |
| **Team Work** | Best for individual work | Preferred for collaboration |
| **Result** | Commits may disappear | New commit added to cancel changes |

## Step-by-Step Demonstration

### Initial Setup
1. Open the gitdemo repository
2. Create a sequence of commits A, B, and C
3. Verify commit history with `git log --oneline`

### Demonstrating Hard Reset
1. Create commits.txt with "This is commit A"
2. Stage and commit as "commit A"
3. Append "This is commit B" and commit as "commit B"
4. Append "This is commit C" and commit as "commit C"
5. Execute: `git reset --hard [hash of commit A]`
6. Result: Commits B and C are completely removed

### Demonstrating Soft Reset
1. Recreate commits B and C
2. Execute: `git reset --soft [hash of commit A]`
3. Result: Commits removed from history but changes remain staged

### Demonstrating Mixed Reset
1. Create commits B and C together in one commit
2. Execute: `git reset --mixed [hash of commit A]` (default)
3. Result: Commits removed from history, changes remain unstaged

### Demonstrating Git Revert
1. Set up commits B and C that introduced a bug
2. Execute: `git revert [hash of commit B and C]`
3. Open editor to confirm commit message
4. Result: New revert commit added, history preserved

## Key Differences Summary

- **Git Reset**: Moves branch pointer, potentially erasing commits (use with caution)
- **Git Revert**: Creates new commit to undo changes while maintaining complete history

</details>

## Summary

### Key Takeaways
```diff
+ Git reset rewinds history with three modes: soft (keeps staged), mixed (default, unstaged), hard (deletes everything)
+ Git revert safely undoes changes by creating a new commit without modifying history
+ Use reset for individual work when you want to clean up commits
+ Use revert for collaborative projects to preserve team visibility of all changes
+ Hard reset is dangerous and can permanently lose work
```

### Quick Reference
```bash
# Reset modes
git reset --soft <commit-hash>    # Keep changes staged
git reset --mixed <commit-hash>   # Default: keep changes unstaged
git reset --hard <commit-hash>    # Delete all changes permanently

# Revert (safer for teams)
git revert <commit-hash>          # Create new commit to undo changes
```

### Expert Insight

**Real-world Application**: In production environments, use `git revert` for any changes that have been pushed to shared repositories. Reserve `git reset` for local cleanup before pushing, and always use `--soft` or `--mixed` unless you're absolutely certain you want to discard changes permanently.

**Expert Path**: Master the visualization of Git's commit graph to intuitively understand how reset moves pointers versus how revert adds new nodes. Practice both commands in isolated test repositories until the differences become second nature.

**Common Pitfalls**:
- Using `--hard` reset on shared branches without team coordination
- Assuming reset and revert are interchangeable
- Not checking the current state with `git status` before choosing a reset mode

**Lesser-Known Facts**:
- `git reset --mixed` is actually the default behavior when no flag is specified
- Git revert opens your default editor for the commit message, just like a regular commit
- The "reflog" (`git reflog`) can sometimes recover from accidental hard resets if garbage collection hasn't run yet

</details>