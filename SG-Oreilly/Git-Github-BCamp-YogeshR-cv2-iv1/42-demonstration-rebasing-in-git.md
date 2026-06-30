# Session 42: Demonstration - Rebasing in Git

<details open>
<summary><b>Session 42: Demonstration - Rebasing in Git (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents

- [Overview](#overview)
- [Demo Setup: Repository Cleanup](#demo-setup-repository-cleanup)
- [Understanding Current Branch Structure](#understanding-current-branch-structure)
- [Creating the Rebase Branch](#creating-the-rebase-branch)
- [Making Commits on Rebase Branch](#making-commits-on-rebase-branch)
- [Switching Back to Main Branch](#switching-back-to-main-branch)
- [Performing the Rebase Operation](#performing-the-rebase-operation)
- [Understanding the Rebase Result](#understanding-the-rebase-result)
- [Pushing Rebased Changes](#pushing-rebased-changes)
- [Summary Section](#summary-section)

## Overview

This demonstration session provides a hands-on walkthrough of Git rebasing, showcasing how to maintain a clean, linear commit history instead of creating merge commits. The session progresses from initial repository preparation through creating a feature branch with commits, switching between branches, and executing the rebase operation to achieve a streamlined history.

## Demo Setup: Repository Cleanup

The demonstration begins by organizing the working directory and preparing a clean starting point for the rebase operation.

### Initial State
- Working in the `git-demo` directory
- Contains existing files from previous demonstrations
- TXT files are scattered in the root directory

### Organizing TXT Files
```bash
# Move all TXT files to a dedicated folder
git mv *.txt TXT/

# Commit the organizational change
git commit -m "move TXT files to TXT folder"
```

### Visualizing Commit History
```bash
# View commit history with visual representation
git log --oneline --graph
```

This command displays:
- Latest commit at the top
- Multiple earlier commits below
- Visual branching and merging patterns
- Commit hashes and messages

## Understanding Current Branch Structure

Before beginning the rebase demonstration, it's essential to understand the existing branch structure and commit history.

### Branch Analysis
```bash
# Check available branches
git branch
```

Current branches include:
- `main` - Primary development branch
- `feature` - Previously created feature branch

### Commit History Patterns
The existing commit graph shows:
- **Line divergence**: History splits into branches at certain points
- **Independent commits**: Work done separately on different branches
- **Merge points**: Branches coming back together after independent development
- **Previous merges**: Evidence of merge operations from earlier demonstrations

### Merge Pattern Description
```
- Typical merge workflow:
  ├── Branches diverge for independent work
  ├── Commits made on separate branches
  └── Merge back together (may require conflict resolution)
```

## Creating the Rebase Branch

The demonstration proceeds by creating a new branch specifically for showcasing the rebase operation.

### Branch Creation Command
```bash
# Create and switch to new branch
git checkout -b rebase-branch
```

### Branch Verification
```bash
# Confirm current branch
git branch

# View commit history on new branch
git log --oneline --graph
```

### Initial Branch State
- The new `rebase-branch` is an exact copy of `main`
- Commit history matches the main branch exactly
- Ready for new commits to demonstrate rebasing

## Making Commits on Rebase Branch

With the new branch active, the demonstration creates commits that will later be rebased onto main.

### Creating First Commit
```bash
# Create new file
touch rebase.txt

# Stage and commit
git add rebase.txt
git commit -m "rebase file added"
```

### Creating Second Commit
```bash
# Create another file
touch rebase2.txt

# Stage and commit
git add rebase2.txt
git commit -m "rebase2 file added"
```

### Verifying Branch Commits
```bash
# Check commit history
git log --oneline --graph
```

Current state shows:
- HEAD pointing to `rebase-branch`
- Two new commits visible on the branch
- Commits are built on top of the base branch

## Switching Back to Main Branch

The demonstration continues by returning to the main branch to prepare for the rebase operation.

### Switching Branches
```bash
# Switch to main branch
git checkout main
```

### Handling Branch Status Message
When switching, Git may display a message indicating the branch is "one commit ahead" - this can be safely ignored as it relates to previous operations.

### Verifying Main Branch State
```bash
# Clear terminal and check commits
git log --oneline --graph
```

Main branch state:
- Does not contain the two new commits from `rebase-branch`
- Latest commit is the organizational commit from demo setup
- Provides a baseline for the rebase operation

## Comparing Merge vs Rebase Approaches

The demonstration explains the difference between merging and rebasing approaches.

### Merge Approach Visualization
If merging `rebase-branch` into `main`:
```
main ────────●────────● (merge commit)
            /        \
rebase-branch ●────────●
```

### Rebase Approach Visualization
Alternative rebase approach:
```
main ────────●──●──● (linear history)
```

### Benefits of Rebase
- **Clean history**: Straight, linear commit sequence
- **No merge commits**: Eliminates extra branching in history
- **Easier tracking**: Simplified commit chronology

## Performing the Rebase Operation

The core demonstration shows how to execute the rebase command and its effects on commit history.

### Rebase Command
```bash
# Rebase main onto rebase-branch
git rebase rebase-branch
```

### Understanding the Operation
The `git rebase rebase-branch` command:
- Takes commits from the specified branch
- "Replays" them on top of the current branch
- Creates a new commit history with linear structure

### Rebase Success Indication
Git confirms successful rebase operation with appropriate output message.

## Understanding the Rebase Result

After the rebase completes, the demonstration verifies the new commit structure.

### Visualizing New History
```bash
# View rebased commit history
git log --oneline --graph
```

Rebased commit structure shows:
- Clean, straight line of commits
- Sequential order:
  1. TXT files moved to folder
  2. rebase.txt added
  3. rebase2.txt added
- No extra branching or merge commits

### Status Verification
```bash
# Check branch status
git status
```

Shows the main branch is now three commits ahead of its previous state.

## Pushing Rebased Changes

The demonstration concludes by pushing the rebased changes to the remote repository.

### Push Command
```bash
# Push rebased commits
git push
```

### Authentication Process
- Uses HTTPS remote configuration
- Prompts for username and password credentials
- Credentials entered to complete the push operation

### Completion Confirmation
After successful push, the demonstration concludes with the rebased history now available in the remote repository.

## Summary Section

### Key Takeaways

```diff
! Rebase creates linear commit history vs merge commit approach
+ git rebase [branch] replays commits on top of current branch
+ Results in clean, straight-line commit chronology
- Avoids creating merge commits that complicate history visualization
! Requires careful consideration when working with shared branches
```

### Quick Reference

| Command | Purpose |
|---------|---------|
| `git checkout -b <branch>` | Create and switch to new branch |
| `git rebase <branch>` | Rebase current branch onto specified branch |
| `git log --oneline --graph` | View visual commit history |
| `git push` | Push rebased changes to remote |

### Expert Insight

**Real-world Application**: Rebase is particularly valuable in feature development workflows where maintaining clean history helps with code review, debugging, and understanding project evolution. Teams often use rebase to keep feature branches updated with main branch changes without creating unnecessary merge commits.

**Expert Path**: Master the distinction between `git rebase` and `git merge` by practicing both approaches on experimental branches. Learn to use interactive rebasing (`git rebase -i`) for commit squashing and reordering. Understand the implications of rebasing shared branches and develop workflows that leverage rebase for maintaining clean project history.

**Common Pitfalls**:
- Rebasing shared branches that others have based work on, causing confusion
- Forgetting that rebase creates new commits (different hashes) requiring force push in some cases
- Not understanding that rebase can potentially cause conflicts that need resolution

**Lesser-Known Facts**:
- Rebase literally "replays" each commit as if the work was done sequentially on the target branch
- The operation changes commit hashes because the parent commits are different
- Rebase can be used to "move" a branch to point to a different base commit entirely

</details>