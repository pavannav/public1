# Session 34: How to Rebase

<details open>
<summary><b>34-How-to-Rebase (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents

1. [Overview](#overview)
2. [Understanding Git Branch Visualization](#understanding-git-branch-visualization)
3. [The Problem with Merge Commits](#the-problem-with-merge-commits)
4. [Introduction to Rebasing](#introduction-to-rebasing)
5. [Rebase vs Merge: Key Differences](#rebase-vs-merge-key-differences)
6. [Lab Demo: Performing a Rebase](#lab-demo-performing-a-rebase)
7. [When to Use Rebase vs Merge](#when-to-use-rebase-vs-merge)
8. [Summary](#summary)

## Overview

This session introduces git rebasing as an alternative to merging that creates cleaner, more linear commit histories. You'll learn how rebasing differs from merging, when to use each approach, and gain hands-on experience performing a rebase operation.

## Understanding Git Branch Visualization

### Visualizing Branch History

Git provides visual tools to understand branch relationships and commit history:

- **`git lg`** (custom alias for git log with visual formatting) displays branch history as a tree
- Visual tools show branches as separate lines that converge at merge points
- The ideal structure maintains a clean, straight line of commits

### The Ideal Git History

```
✅ Desired Structure: A straight, linear commit history
```

```
❌ Problematic Structure: Multiple parallel lines that become hard to navigate
```

When working with many branches, the visual complexity increases significantly, making it difficult to:
- Track relationships between branches
- Perform git operations that require understanding commit ancestry
- Debug issues that require navigating through merge commits

## The Problem with Merge Commits

### How Merges Create History

When you merge branches, Git creates a special merge commit that:
- Records the exact moment two branches were combined
- Preserves the complete history of how branches evolved
- Creates a new commit hash (merge commit) specifically for this event

### Merge Commit Visualization

```
master ─────●────────●─────●
             \              /
time-warp ────●────────────
```

The merge commit serves as a historical marker showing:
- When branches diverged
- When they were merged back together
- What commits were included in each branch

### Drawbacks of Merge-Based History

1. **Visual Complexity**: Multiple parallel lines make the history harder to read
2. **Navigation Difficulty**: Finding specific commits requires following complex branch patterns
3. **Git Surgery Challenges**: Operations like cherry-picking or reverting become more complex
4. **Historical Overhead**: Extra commits that may not add practical value

## Introduction to Rebasing

### What Rebasing Does

Rebasing takes your commits and replays them directly on top of another branch:

```
Before Rebase:
master ─────●─────●
             \
rebase-branch ──● (your commit)

After Rebase:
master ─────●─────●─────● (your commit moved here)
```

Instead of creating a merge commit, rebasing:
- "Rewinds" your branch to the common ancestor
- Applies your changes on top of the target branch
- Creates a linear history without merge commits

### Rebase Process

1. Git first rewinds the HEAD to the point where branches diverged
2. It then replays your commits on the target branch
3. The result is your work "plopped" directly on top of the target

## Rebase vs Merge: Key Differences

| Aspect | Merge | Rebase |
|--------|-------|--------|
| **History Preservation** | Preserves complete merge history | Rewrites history to be linear |
| **Commit Graph** | Creates branching patterns | Maintains straight line |
| **Merge Commits** | Creates merge commits | No merge commits |
| **Timeline Readability** | Easier to see branch evolution | Cleaner, simpler view |
| **Undo Complexity** | Easy to identify merge points | Requires knowing specific commits |

### Key Conceptual Differences

```
diff
! Merge: Creates a timeline you can visually navigate
! Rebase: Creates a clean slate with linear progression
```

### Benefits of Rebase

- **Cleanliness**: Maintains a straight, easy-to-read commit graph
- **Simplicity**: No merge commits cluttering the history
- **Easier Navigation**: Linear structure simplifies understanding changes over time

### Benefits of Merge

- **Historical Accuracy**: Preserves exactly when and how branches were combined
- **Easier Debugging**: Can identify merge points quickly for troubleshooting
- **Context Preservation**: Shows the complete evolution of feature development

## Lab Demo: Performing a Rebase

### Setup

```bash
# Create and switch to a new branch
git checkout -b rebase-branch

# Create a new file and commit it
touch rebase-file.txt
git status
git add rebase-file.txt
git commit -m "Sample rebase commit"

# Verify position relative to master
git log --oneline -1
git lg  # Shows rebase-branch is one commit ahead of master
```

### Executing the Rebase

```bash
# Switch to master
git checkout master

# Rebase the feature branch onto master
git rebase rebase-branch
```

### Understanding the Output

```
First, rewinding head to replay your work on top of it...
```

This indicates Git is:
1. Moving back to the divergence point
2. Replaying your commits on the new base
3. Updating branch references

### Verification

```bash
git lg
```

After rebasing:
- Master advances to include your commit
- No merge commit appears in history
- The commit graph shows a clean, linear progression
- Both branches now point to the same commit

## When to Use Rebase vs Merge

### Use Rebase When:

- Working on smaller projects or teams
- You want to maintain a clean, linear history
- Historical merge information isn't critical
- You're working on feature branches that will be integrated soon
- Visual simplicity is preferred

### Use Merge When:

- Working on larger teams or projects
- Participating in pull request workflows
- You need to preserve the complete merge history
- Debugging might require identifying exact merge points
- The team requires historical context of branch integrations

### The Author's Recommendation

> **Smaller Projects/Teams**: Prefer rebasing for cleanliness and simplicity
> **Larger Teams/PRs**: Prefer merging for its historical preservation and ease of understanding branch relationships

## Summary

### Key Takeaways

```diff
+ Rebase creates linear history by replaying commits on target branch
+ Merge preserves history with explicit merge commits
+ Choose based on team size and historical requirements
- Avoid mixing rebase and merge strategies inconsistently
! Understand that rebasing rewrites commit history
```

### Quick Reference

```bash
# Basic rebase workflow
git checkout feature-branch     # Work on your branch
git checkout master            # Switch to target
git rebase feature-branch      # Rebase feature onto master

# Visualization commands
git lg                         # Visual branch history
git log --oneline             # Compact commit view
git branch -a                 # List all branches
```

### Expert Insight

**Real-world Application**: In professional environments, many teams prefer rebasing for feature branches before merging into main, creating a "rebase then merge" workflow that maintains clean history while preserving the final merge commit for integration tracking.

**Expert Path**: Master both operations and understand their impact on shared repositories. Practice rebasing in personal projects to become comfortable with history rewriting before applying it in team environments.

**Common Pitfalls**:
- Rebasing shared branches that others have pulled (causes confusion)
- Using rebase when merge history is important for compliance or debugging
- Not understanding that rebasing changes commit SHAs

**Lesser-Known Facts**: Rebasing can be interactive (`git rebase -i`) allowing you to squash, edit, or reorder commits, making it a powerful tool for cleaning up commit history before sharing with others.

</details>