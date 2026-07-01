# Section 22: How to Get Updates from GitHub

<details open>
<summary><b>Section 22: How to Get Updates from GitHub (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Context: Understanding Git Pull Limitations](#context-understanding-git-pull-limitations)
- [The Problem: Selective Update Viewing](#the-problem-selective-update-viewing)
- [Introducing Git Fetch](#introducing-git-fetch)
- [Git Fetch Demonstration](#git-fetch-demonstration)
- [Git Fetch Mechanics](#git-fetch-mechanics)
- [Visualizing with Git LG](#visualizing-with-git-lg)
- [Fast Forward with Git Pull](#fast-forward-with-git-pull)
- [Git Fetch vs Git Pull: Key Differences](#git-fetch-vs-git-pull-key-differences)
- [When to Use Git Fetch](#when-to-use-git-fetch)
- [Key Takeaways](#key-takeaways)
- [Quick Reference](#quick-reference)
- [Expert Insight](#expert-insight)

## Overview

This section explores the difference between `git pull` and `git fetch`, introducing `git fetch` as a tool for downloading remote changes without automatically applying them to your local repository. The lesson demonstrates scenarios where viewing remote changes before integrating them is valuable.

## Context: Understanding Git Pull Limitations

- **Previous Learning**: Lesson covered `git pull origin master` and handling conflicts when GitHub code differs from local code
- **Git Pull Behavior**: Downloads all code from GitHub, stores it in memory, writes commits to local Git, then moves HEAD to the latest commit
- **Key Question**: What if we want to see GitHub's work without necessarily applying it to our local repository?

## The Problem: Selective Update Viewing

**Scenario Setup:**
- A commit exists on GitHub that is not present locally
- We want to examine the remote changes without applying them
- Current local state: Has an "empty file"
- GitHub state: Has "not empty file.md" with lorem ipsum content

**Local vs Remote State:**
```diff
+ GitHub has: not empty file.md (with content)
- Local has: empty file (original)
```

## Introducing Git Fetch

**Definition**: `git fetch` downloads remote changes to your local repository without applying or merging them.

**Command**:
```bash
git fetch origin master
```

**Purpose**: Allows inspection of remote changes before deciding to integrate them.

## Git Fetch Demonstration

**Before Fetch:**
```bash
ls -la
# Shows: empty file (original file still present)

git log
# Shows commits up to merge point, but not the GitHub commit
```

**After Fetch:**
```bash
git fetch origin master
# Downloads the commit information

ls -la
# Still shows: empty file (no changes applied)

git log
# Still doesn't show the new commit directly
```

## Git Fetch Mechanics

**What Git Fetch Does:**
1. Downloads all commits from the specified remote branch
2. Stores them in your local repository's object database
3. Updates remote tracking branches (origin/master)
4. Does NOT modify your working directory or current branch

**What Git Fetch Does NOT Do:**
- Apply changes to working directory
- Update your current branch HEAD
- Merge or rebase any commits

## Visualizing with Git LG

**Git LG** (custom alias for enhanced log viewing):
```bash
git lg
```

**Visual Representation:**
```
* [origin/master] updated the empty file not to be empty anymore
|
* [HEAD -> master] merge branch 'master' of github.com...
```

This shows that `origin/master` is ahead of local `master` by one commit.

## Fast Forward with Git Pull

**After Inspection, Apply Changes:**
```bash
git pull origin master
```

**Fast Forward Process:**
- No new download needed (already fetched)
- Simply moves local HEAD to match remote branch
- Working directory updated with remote changes

**Result:**
- Local repository now matches GitHub state
- "empty file" replaced with "not empty file.md"

## Git Fetch vs Git Pull: Key Differences

```diff
! git pull origin master = git fetch origin master + git merge origin master
```

| Aspect | git fetch | git pull |
|--------|-----------|----------|
| Downloads changes | ✅ Yes | ✅ Yes |
| Applies changes | ❌ No | ✅ Yes |
| Updates working dir | ❌ No | ✅ Yes |
| Moves HEAD | ❌ No | ✅ Yes |
| Safe to inspect | ✅ Yes | ⚠️ Applies immediately |

## When to Use Git Fetch

**Use Cases:**
- Preview changes before integrating
- Check for updates that might affect planned work
- Verify what a collaborator has pushed
- Prepare for potential merge conflicts
- Audit remote changes without modifying local state

**Workflow Pattern:**
```bash
# 1. Check for updates
git fetch origin master

# 2. Review changes using git lg or git log
git lg

# 3. Decide: merge, rebase, or ignore
git pull origin master  # If ready to integrate
```

## Key Takeaways

```diff
+ git fetch downloads remote changes without applying them
+ Use git fetch to inspect updates before integrating
+ git pull = git fetch + git merge (combined operation)
+ Fast-forward occurs when no local commits exist after the common ancestor
+ Remote tracking branches (origin/master) are updated by fetch
- Never assume you need all remote changes immediately
```

## Quick Reference

```bash
# Fetch updates from remote without applying
git fetch origin master

# View the commit tree (if git-lg alias is configured)
git lg

# Standard log to see commit history
git log --oneline

# After inspection, pull and merge changes
git pull origin master

# Check current branch status
git status
```

## Expert Insight

**Real-world Application:**
- Essential for collaborative development where you need to review team changes
- Useful in CI/CD pipelines to check for updates before deployment
- Critical when working on features that might conflict with others' work

**Expert Path:**
- Master `git fetch` options like `--all`, `--prune`, and `--depth`
- Learn about fetch configurations in `.git/config`
- Practice with multiple remotes and tracking branches

**Common Pitfalls:**
- Forgetting that `git fetch` updates remote tracking branches, not your working directory
- Confusing `git fetch` with `git pull` and expecting working directory changes
- Not using `git fetch --prune` to remove stale remote references

**Lesser-Known Facts:**
- `git fetch` can fetch from specific refs and store them as FETCH_HEAD
- The fetched commits are stored in `.git/objects` just like local commits
- You can checkout fetched commits directly using `git checkout FETCH_HEAD`

</details>