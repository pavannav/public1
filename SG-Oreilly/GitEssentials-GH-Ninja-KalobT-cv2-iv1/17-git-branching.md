# Section 17: Git Branching

<details open>
<summary><b>17-Git-Branching (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Understanding Git Branches](#understanding-git-branches)
- [Why Use Branches](#why-use-branches)
- [Creating a New Branch](#creating-a-new-branch)
- [Navigating Between Branches](#navigating-between-branches)
- [The Tree Metaphor](#the-tree-metaphor)
- [Branching Best Practices](#branching-best-practices)
- [Summary](#summary)

## Overview
This session introduces Git branching, a fundamental concept that allows developers to work on different versions of code simultaneously without conflicts. You'll learn what branches are, why they're essential for collaborative development, and how to create and navigate between them using simple Git commands.

## Understanding Git Branches

### What is a Branch?
A branch in Git is essentially a copy of the original work that allows parallel development. However, rather than duplicating all files, Git efficiently stores only the differences (deltas) between branches.

### Local vs Remote Branches
- **Local branches**: Exist only on your computer until pushed to a remote
- **Remote branches**: Stored on GitHub/GitLab (the "origin")
- When you first create a branch locally with Git commands, it doesn't automatically appear on GitHub
- The `git push` command is required to sync local branches with the remote repository

## Why Use Branches

### The Problem with Working on Master
Working directly on the master branch can cause conflicts when multiple developers make changes to the same files:

```diff
- Problem: Git doesn't know whose code is "right"
- Problem: Potential code overwrites and lost work
- Problem: No way to test changes before merging
```

### The Branch Solution
```diff
+ Solution: Create separate branches for different features
+ Solution: Work independently without affecting master
+ Solution: Review and merge changes when ready
```

## Creating a New Branch

### The git checkout -b Command
```bash
git checkout -b new-branch-name
```

This command:
1. Creates a new branch
2. Switches (checks out) to the new branch immediately
3. Shows confirmation: "Switched to a new branch"

### Verifying Your Branches
```bash
git branch
```

This displays all local branches with:
- An asterisk (*) indicating your current branch
- The current branch highlighted

### Example Workflow
```bash
# Create and switch to a new branch
git checkout -b feature-login

# Check current branch status
git branch

# Output will show:
#   master
# * feature-login
```

## Navigating Between Branches

### Switching Branches
```bash
# Switch to master branch
git checkout master

# Switch back to your feature branch
git checkout feature-login

# Check status to confirm location
git status
```

### Important Notes
- At this point in the lesson, switching branches shows no visible changes because no modifications have been made yet
- Branch switching becomes powerful when you've made commits on different branches
- The next lesson will demonstrate committing changes on a new branch without affecting master

## The Tree Metaphor

### Visualizing Branches
Think of your repository as a tree:
- **Master branch** = The trunk (main, stable codebase)
- **Feature branches** = Small branches growing from the trunk
- **Development process** = Create small branches, add code, merge back into trunk

### The Ideal Workflow
```
Master (Trunk)
    |
    +-- Create small branch
    |       |
    |       +-- Write code
    |       |
    |       +-- Merge back to master
    |
    +-- Master grows with merged changes
```

## Branching Best Practices

### Keep Branches Small
- Create branches for small, focused changes
- Avoid making massive changes on a single branch
- Merge frequently to keep branches current

### Merge Often
- Regular merging keeps your master branch growing
- Each merge adds valuable features or fixes
- Commit history remains intact for future reference

### Benefits of Frequent Merging
- Master codebase becomes significantly larger and more feature-rich
- Changes are integrated incrementally
- Easier to track what was changed and when

## Summary

### Key Takeaways
```diff
+ Branches allow parallel development without conflicts
+ git checkout -b creates and switches to a new branch
+ Local branches must be pushed to appear on GitHub
+ Master is the main trunk; branches are temporary workspaces
+ Merge small branches frequently for best results
```

### Quick Reference
| Command | Description |
|---------|-------------|
| `git checkout -b <name>` | Create and switch to new branch |
| `git branch` | List all branches (current shown with *) |
| `git checkout <name>` | Switch to existing branch |
| `git status` | Show current branch and status |

### Expert Insight

#### Real-world Application
In production environments, branching enables teams to work on multiple features simultaneously. Each developer or team can work on their feature branch, test changes thoroughly, and only merge when the feature is complete and reviewed.

#### Expert Path
- Master the branching workflow before moving to advanced topics
- Practice creating branches, making changes, and switching between them
- Learn about merging in upcoming lessons to complete the branching cycle

#### Common Pitfalls
- Creating overly large branches that are hard to merge
- Forgetting to push branches to share with the team
- Working directly on master instead of creating feature branches
- Not keeping branches updated with master changes

#### Lesser-Known Facts
- Git branches are lightweight pointers to commits, not copies of files
- The commit history provides a complete audit trail of all branch activity
- Branch names are case-sensitive on Linux/Mac but not on Windows
- You can create branches from any commit, not just the latest one

</details>