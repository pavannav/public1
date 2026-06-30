# 21: Demonstration: Branch Operations

<details open>
<summary><b>21: Demonstration: Branch Operations (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [Overview](#overview)
- [21.1 Branch Demonstration Setup](#211-branch-demonstration-setup)
- [21.2 Creating and Switching Branches](#212-creating-and-switching-branches)
- [21.3 Working with Isolated Changes](#213-working-with-isolated-changes)
- [21.4 Multiple Parallel Branches](#214-multiple-parallel-branches)
- [Summary](#summary)

## Overview
This demonstration session provides hands-on experience with Git branch operations, showing how to create, switch between, and work with multiple branches in parallel. The session demonstrates the practical implementation of the branching concepts covered in previous lectures.

## 21.1 Branch Demonstration Setup
**Environment and Initial State**

The demonstration begins in an existing Git repository called `git-demo`:
```bash
ls -l
# Shows files: hello.txt, my-notes, welcome
```

**Current Branch Status:**
```bash
git branch
# Output shows only master branch with green highlight and asterisk
```

The asterisk (`*`) indicates the currently active branch. The `master` branch is the default branch created when initializing a new Git repository.

## 21.2 Creating and Switching Branches
**Branch Creation Process**

Creating a new branch uses simple syntax:
```bash
git branch feature-one
```

**Important Note:** Creating a branch does NOT automatically switch to it. The user remains on the original branch until explicitly switching.

**Branch Verification:**
```bash
git branch
# Now shows both master and feature-one
# Asterisk still next to master
```

**Switching Between Branches**

Two methods available:
1. Traditional: `git checkout feature-one`
2. Modern (beginner-friendly): `git switch feature-one`

**Confirmation Message:** "Switched to branch 'feature-one'"

```bash
git branch
# Asterisk now shows next to feature-one
```

## 21.3 Working with Isolated Changes
**Branch Independence Demonstration**

When a new branch is created, it starts as an exact copy of its parent branch:
- All files from `master` are present in `feature-one`
- Changes made in `feature-one` remain isolated until merged

**Creating Branch-Specific Content:**
```bash
echo "name: think rook" > rook.txt
ls -l
# Now shows rook.txt in feature-one

git add rook.txt
git commit -m "Rook file added"
```

**Demonstrating Isolation:**
```bash
git switch master
ls -l
# rook.txt is NOT present
```

This clearly illustrates how branches allow independent work without affecting the main branch.

## 21.4 Multiple Parallel Branches
**Creating Additional Branches**

Branch naming best practices:
- Use descriptive names (e.g., `homepage`, `about-page`)
- Avoid generic names
- Make purpose immediately clear

**Creating `feature-two`:**
```bash
git branch feature-two
git switch feature-two
echo "name: think next" > next.txt
git add next.txt
git commit -m "Next file added"
```

**Branch State Summary:**
- `master`: Contains original files only
- `feature-one`: Contains `rook.txt`
- `feature-two`: Contains `next.txt`

## Summary

### Key Takeaways
```diff
+ Branches enable parallel development without interference
+ Each branch maintains isolated changes until merged
+ git switch provides clearer branch navigation than checkout
+ Descriptive branch names improve project organization
+ Changes in branches don't affect other branches until explicitly merged
```

### Quick Reference
```bash
# Create branch
git branch <branch-name>

# Switch branches
git switch <branch-name>
git checkout <branch-name>  # Traditional method

# List all branches
git branch

# Branch status indicators
# * = Current branch (green highlight)
```

### Expert Insight

**Real-world Application:**
- Feature branches for new functionality development
- Bug fix branches for isolated debugging
- Experiment branches for testing new ideas
- Release branches for version management

**Expert Path:**
- Master the `git switch` command for modern workflows
- Develop naming conventions for team consistency
- Learn branch protection rules in GitHub/GitLab
- Practice branch cleanup after merging

**Common Pitfalls:**
- Forgetting you're on the wrong branch when making changes
- Not using descriptive branch names
- Creating unnecessary branches for minor changes
- Neglecting to switch back to the correct branch

**Lesser-Known Facts:**
- Branches in Git are lightweight pointers to commits
- Creating a branch takes milliseconds regardless of repository size
- The master/main branch naming convention varies by organization
- Branch names can include forward slashes for hierarchy (e.g., `feature/login`)

</details>