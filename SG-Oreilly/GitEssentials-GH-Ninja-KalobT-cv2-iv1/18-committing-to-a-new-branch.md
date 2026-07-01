# Session 18: Committing to a New Branch

<details open>
<summary><b>Session 18: Committing to a New Branch (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Committing to a New Branch](#committing-to-a-new-branch)
- [Branch Awareness When Pushing](#branch-awareness-when-pushing)
- [Branch-Specific Files in GitHub](#branch-specific-files-in-github)
- [Use Cases for Branching](#use-cases-for-branching)
- [Summary](#summary)

## Overview

This session demonstrates how to commit and push changes to a newly created branch. Key concepts include understanding the importance of pushing to the correct branch, recognizing when changes fail to appear due to branch mismatches, and understanding that files created on one branch only exist on that branch until merged.

## Committing to a New Branch

### Current Branch Context
- Previous lesson created a new branch using `git checkout -b new-branch`
- Running `git branch` shows both existing branches
- Attempting to recreate the branch fails with "fatal: branch named 'new-branch' already exists"
- Can switch between branches using `git checkout master` and `git checkout new-branch`

### Creating a Branch-Specific File
```bash
# Create a new file on the new-branch
touch new-branch-file

# Verify the file exists
ls -la
# Shows: new-branch-file

# Check git status
git status
# Shows: new file: new-branch-file
```

### Staging and Committing Changes
```bash
# Stage the new file
git add new-branch-file

# Commit the file
git commit -m "new branch file"

# Verify clean working directory
git status
# Shows: nothing to commit, working tree clean
```

## Branch Awareness When Pushing

### The Wrong Branch Push Problem
```bash
# Attempting to push to master while on new-branch
git push origin master
# Output: "Everything is up to date"

# This is misleading - the commit exists but wasn't pushed
```

**Important**: If you see "Everything is up to date" but your code isn't appearing on GitHub, you're likely pushing to the wrong branch.

### Pushing to the Correct Branch
```bash
# Push to the correct branch
git push origin new-branch
# Successfully pushes the new commit
```

## Branch-Specific Files in GitHub

### Viewing Branch Files on GitHub
1. Navigate to the repository on GitHub
2. Use the branch dropdown to switch to "new-branch"
3. The `new-branch-file` is visible
4. Switch back to master branch - the file shows 404 (doesn't exist)

### Visual Confirmation
- GitHub creates a second branch option called "new-branch"
- Files are isolated per branch until merged
- Viewing a branch-specific file from the wrong branch results in a missing page error

## Use Cases for Branching

### Perfect for Isolated Development
- When the codebase is stable and trusted
- For testing new features without affecting production code
- Writing experimental code that won't touch master until intentional merge

### Key Benefits Demonstrated
```
Current Workflow:
Master Branch (stable) → Create Branch → Add Features → Test → Merge to Master
```

### Safety of Branching
- Changes on a branch never affect master until:
  - Creating a pull request
  - Purposefully merging back into master
- Next lesson will cover merging via command line

## Summary

### Key Takeaways
```diff
+ Always verify current branch before pushing: git branch
+ Push to the correct branch: git push origin <branch-name>
+ Files are branch-specific until merged or pulled
+ "Everything is up to date" may indicate wrong branch target
+ Branching provides safe isolation for new development
```

### Quick Reference
| Command | Purpose |
|---------|---------|
| `git branch` | List all branches and show current |
| `git checkout <branch>` | Switch to specified branch |
| `git add <file>` | Stage file for commit |
| `git commit -m "message"` | Commit staged changes |
| `git push origin <branch>` | Push to specific remote branch |

### Expert Insight

**Real-world Application**: Branching is essential for team development, allowing multiple developers to work simultaneously without conflicts. Feature branches keep experimental code isolated until ready for review and integration.

**Expert Path**: Master the workflow of creating descriptive branch names, regularly pushing to remote branches for backup, and using pull requests for code review before merging to main branches.

**Common Pitfalls**:
- Assuming "Everything is up to date" means changes are live
- Forgetting which branch you're on when pushing
- Not verifying file existence across branches after creation

**Lesser-Known Facts**: Git's branch system is incredibly lightweight - creating a branch only creates a new pointer to a commit. The actual file storage is optimized through Git's content-addressable storage, making branches nearly instantaneous to create regardless of repository size.

</details>