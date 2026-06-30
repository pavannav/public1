# 41: Rebasing in Git

<details open>
<summary><b>41: Rebasing in Git (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [Overview](#overview)
- [What is Rebasing?](#what-is-rebasing)
- [Why Use Rebasing?](#why-use-rebasing)
- [Rebasing vs Merging](#rebasing-vs-merging)
- [Practical Example](#practical-example)
- [Important Caution](#important-caution)
- [Summary](#summary)

## Overview
This session introduces Git rebasing as a powerful technique for maintaining clean project history. The lecture explains what rebasing is, why it's useful, how it differs from merging, and provides important cautions about its proper use in collaborative environments.

## What is Rebasing?

### Definition and Concept
Rebasing is a way of moving or combining a series of commits onto a new base commit. Think of it as rewriting the history of your project so that your work appears to have started from a different point in time.

### Common Scenario
- You and a teammate working on the same project
- Teammate making changes on the main branch
- You developing on a feature branch
- Over time, main branch progresses with new commits
- Your feature branch falls behind

### How Rebasing Solves This
Rebasing allows you to take your commits and place them on top of the latest main branch as if you had started working after those new changes were already in place.

## Why Use Rebasing?

### Cleaner, Linear Project History
When you rebase, it looks like your feature branch was always built on top of the most recent changes. This approach:
- Avoids unnecessary branching paths
- Eliminates extra merge commits
- Creates a neat, straight line of commits
- Makes history easier to read and understand

### Smoother Collaboration
When you rebase before merging your feature branch:
- Teammates don't have to deal with extra merge commits
- Your changes appear as if they were developed in direct sequence
- Integration with the rest of the project appears seamless

## Rebasing vs Merging

### Key Differences

| Aspect | Merging | Rebasing |
|--------|---------|----------|
| **History** | Retains complete history of both branches | Rewrites history |
| **Merge Commits** | Creates merge commits | No extra merge commits |
| **Visual Result** | Shows branching history with merge points | Shows smooth linear sequence |
| **Approach** | Combines two branches together | Moves commits to new base |

### Visual Comparison
When merging:
- History shows commits A, B, C followed by a merge commit, then commits X, Y

When rebasing:
- History shows commits A, B, C followed directly by commits X, Y
- Work appears to have started after commit C

### Which to Choose?

**Use Merging When:**
- You want to preserve the complete history of development
- Including all merge points and decision points
- Working with shared branches like main or master

**Use Rebasing When:**
- You prefer a simpler, cleaner history
- You want to avoid the noise of merge commits
- Working on personal feature branches

## Practical Example

### Scenario Setup
- **Main branch commits:** A, B, C
- **Feature branch commits:** X, Y

### After Merge
```
A → B → C → [Merge Commit] → X → Y
```

### After Rebase
```
A → B → C → X → Y
```

### Key Point
Both methods preserve all the changes made in the commits. The difference lies only in how the history is represented.

## Important Caution

### History Rewriting Concern
Rebasing rewrites history, which can cause issues when:
- You rebase a branch that other people are already working with
- It can cause confusion among team members
- It may lead to merge conflicts for others

### Rule of Thumb
> [!IMPORTANT]
> Only rebase branches that you haven't shared with others yet.

### Safe Practice
- **Feature branches (unshared):** Safe to rebase
- **Shared branches (main/master):** Use merging instead

## Summary

### Key Takeaways

```diff
+ Rebasing rewrites commit history to create a cleaner, linear project timeline
+ It makes work appear as if it started from the latest base commit
+ Cleaner than merging for personal feature branches
- Never rebase shared branches that others are working on
- Merging preserves complete development history including all merge points
```

### Commands (Anticipated for Next Session)
Based on the lecture preview, the demonstration will cover practical rebasing commands to:
- Execute a rebase operation
- Handle potential conflicts during rebasing
- Complete the rebase process successfully

</details>