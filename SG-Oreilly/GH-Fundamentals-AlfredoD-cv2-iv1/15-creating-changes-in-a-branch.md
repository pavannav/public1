# Session 15: Creating Changes In A Branch

<details open>
<summary><b>Session 15: Creating Changes In A Branch (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [Creating Changes in a Branch](#creating-changes-in-a-branch)
- [Creating a New Branch with Checkout](#creating-a-new-branch-with-checkout)
- [Making Changes on a Branch](#making-changes-on-a-branch)
- [Viewing Branch-Specific Changes](#viewing-branch-specific-changes)
- [Creating Branches via GitHub UI](#creating-branches-via-github-ui)
- [Summary: Key Takeaways](#summary-key-takeaways)
- [Quick Reference](#quick-reference)
- [Expert Insights](#expert-insights)

## Creating Changes in a Branch

### Overview
This session demonstrates how to create and work with branches in Git, showing both command-line and GitHub UI approaches for making isolated changes without affecting the main codebase.

### Key Concepts

#### Branch Isolation Benefits
- **Separation of Concerns**: Each branch maintains its own set of changes
- **Clean Development**: Work on features without disturbing production/main environment
- **Safe Experimentation**: Test changes without risk to stable code
- **Clear Change Tracking**: Easy to see what changed for pull requests

#### Why Branch-Based Development Matters
```
Main Branch (Production) ←→ Feature Branches (Development)
     |                              |
   Stable                        Experimental
   Code                          Changes
```

## Creating a New Branch with Checkout

### Initial Setup
Starting on main branch, use interactive checkout to create a new branch:

```bash
# Interactive branch creation with -p flag
git checkout -p

# This prompts for branch creation and switches to it
# Creates and switches to "test-branch"
```

### Verifying Branch Creation
```bash
# List all branches and current branch
git branch --list

# Output shows:
# * main (current)
#   test-branch (newly created)
```

> [!NOTE]
> Terminal prompts often display current branch name as a feature of shell configuration.

## Making Changes on a Branch

### Editing Files on Active Branch
1. **Navigate to repository and view current state**:
   ```bash
   less README.md
   ```

2. **Make modifications**:
   ```bash
   # Append new content to README
   echo "changes in a new branch" >> README.md
   ```

3. **Stage and commit changes**:
   ```bash
   git status          # Shows modified files
   git add .           # Stage all changes
   git commit -m "changes in a branch"
   ```

### Branch-Specific File State
```bash
# On test-branch - shows new content
cat README.md
# Output includes: "changes in a new branch"

# Switch back to main
git checkout main

# On main - original content preserved
cat README.md
# "changes in a new branch" NOT present
```

## Viewing Branch-Specific Changes

### Demonstrating Branch Isolation
Create additional branch to show clear separation:

```bash
# Create new branch from current position
git checkout -b example-branch

# Make branch-specific changes
echo "week one" >> README.md
git add .
git commit -m "week one content"

# Verify on example-branch
cat README.md
# Shows: "week one"

# Switch to main - changes are isolated
git checkout main
cat README.md
# "week one" NOT visible
```

### Separation Benefits
- **Environment Protection**: Main branch remains untouched
- **Change Visibility**: Clear view of what each branch modified
- **Pull Request Ready**: Easy to identify changes for review
- **Clean Workflow**: Professional development practice

## Creating Branches via GitHub UI

### Visual Studio Code Integration
Modern IDEs provide GUI-based branch creation:

1. **Access Branch Creation**:
   - Open VS Code branch menu
   - Select "Create Branch" option

2. **Branch Configuration**:
   ```text
   Branch Name: other-remote-branch
   ```

3. **Post-Creation Workflow**:
   - VS Code confirms branch switch
   - UI indicates remote branch creation
   - Ready for local edits and remote push

### GitHub Platform Synchronization
```bash
# After local changes on new branch
git push origin other-remote-branch

# Changes appear on GitHub platform
# Enables web-based collaboration and review
```

## Summary: Key Takeaways

```diff
+ Branch isolation protects main/production code from development changes
+ Git checkout -p provides interactive branch creation workflow
+ Changes made on branches remain completely separate from main branch
+ Visual tools like VS Code simplify branch management for beginners
+ Push remote branches to enable GitHub platform collaboration
+ Clean workflows require systematic branch-based development practices
```

## Quick Reference

| Command | Purpose | Example |
|---------|---------|---------|
| `git checkout -p` | Interactive branch creation | `git checkout -p` |
| `git branch --list` | View all branches | `git branch --list` |
| `git checkout -b <name>` | Create and switch to branch | `git checkout -b feature-x` |
| `git checkout <branch>` | Switch between branches | `git checkout main` |

## Expert Insights

### Real-world Application
In production environments, never commit directly to main branch. Always create feature branches for:
- Bug fixes and patches
- New feature development
- Experimental code/prototypes
- Code refactoring tasks

### Expert Path
Master branch workflows by:
1. Establishing consistent naming conventions (feature/, bugfix/, hotfix/)
2. Using branch protection rules on GitHub
3. Setting up automated testing on branch pushes
4. Creating pull request templates for standardized reviews

### Common Pitfalls
- ❌ Forgetting which branch you're working on
- ❌ Accidentally committing to main branch
- ❌ Not pushing branches before switching machines
- ❌ Creating too many stale branches without cleanup

### Lesser-Known Facts
- Git branches are lightweight pointers to commits
- Branch names can include slashes for organization (feature/auth/login)
- You can create branches from any commit, not just the latest
- Branch switching automatically updates working directory files

</details>