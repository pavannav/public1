# 37: Adding Tags to Your Commits

<details open>
<summary><b>37: Adding Tags to Your Commits (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents

- [Overview](#overview)
- [Understanding Git Tags](#understanding-git-tags)
- [Creating Tags](#creating-tags)
- [Viewing and Managing Tags](#viewing-and-managing-tags)
- [Pushing Tags to GitHub](#pushing-tags-to-github)
- [Pushing All Tags at Once](#pushing-all-tags-at-once)
- [Deleting Tags](#deleting-tags)
- [Checking Out Tags](#checking-out-tags)
- [Summary](#summary)

## Overview

This session covers Git tagging, a feature that allows you to mark important milestones or version points in your repository. Tags provide human-readable names instead of commit hashes, making it easier to reference specific points in your project's history, particularly for versioning releases.

## Understanding Git Tags

### What Are Tags?

Tags in Git serve as markers for important points in your repository's history:

- **Purpose**: Mark milestones, typically used for versioning
- **Real-world Example**: The Wagtail repository uses tags to mark different versions (e.g., version 2.7)
- **Key Benefit**: Provides a human-readable shortcut to specific commits instead of using long commit hashes

### Tags vs Branches

| Feature | Branches | Tags |
|---------|----------|------|
| Purpose | Active development | Marking release points |
| Movement | Can move with new commits | Static pointers to specific commits |
| Use Case | Ongoing work | Version snapshots |

## Creating Tags

### Basic Tag Creation

To create a tag, you need to be at the commit you want to tag:

```bash
# View recent commit to identify what to tag
git log --oneline

# Create a tag at current HEAD position
git tag v0.1

# Verify the tag appears in log
git log --oneline
```

After creating a tag, the log output will show the tag name alongside the commit:

```
a1b2c3d (HEAD -> master, tag: v0.1) Worked on rush task
```

### Creating Multiple Tags

You can create tags at any commit by checking out that commit first:

```bash
# Checkout a specific commit
git checkout <commit-hash>

# Create tag at this commit
git tag typo-tag

# Return to a different commit
git checkout <another-commit>

# Create another tag
git tag beta
```

## Viewing and Managing Tags

### Listing All Tags

```bash
# List all tags in alphabetical order
git tag
```

> [!NOTE]
> Tags are displayed in alphabetical order, not chronological order.

### Tag Information

Tags appear in your Git log output when using `--oneline`:

```bash
git log --oneline

# Output example:
# a1b2c3d (HEAD -> master, tag: v0.1) Worked on rush task
# e4f5g6h (tag: beta) README update
# i7j8k9l (tag: typo-tag) Typo fix
```

## Pushing Tags to GitHub

### Understanding Local vs Remote Tags

Tags created locally are not automatically pushed to GitHub. You must explicitly push tags to share them with others.

### Pushing Individual Tags

```bash
# Push a specific tag to GitHub
git push origin v0.1
```

After pushing, refreshing the GitHub page will show the new tag under the "Tags" section.

## Pushing All Tags at Once

### Batch Tag Push

To push all local tags to GitHub at once:

```bash
git push origin --tags
```

This command will push all tags that haven't been pushed yet, showing output like:
```
Total 0 (delta 0), reused 0 (delta 0)
To github.com:username/repo.git
 * [new tag]         v0.1 -> v0.1
 * [new tag]         beta -> beta
```

## Deleting Tags

### Local Tag Deletion

```bash
# Delete a tag locally
git tag -d typo-tag

# Verify deletion
git tag
```

### Remote Tag Deletion

Deleting a tag locally does not remove it from GitHub. You must explicitly delete it from the remote:

```bash
# Delete tag from GitHub
git push origin --delete typo-tag
```

> [!IMPORTANT]
> Simply running `git push origin --tags` after local deletion will NOT remove the tag from GitHub. You must use the `--delete` flag.

## Checking Out Tags

### Benefits of Using Tags for Navigation

Tags provide an easy way to navigate to specific points in history without memorizing commit hashes.

### Checking Out a Tag

```bash
# Checkout a specific tag
git checkout beta

# You're now in "detached HEAD" state
git lg  # Shows HEAD pointing to the tag, not a branch
```

### Understanding Detached HEAD State

When you checkout a tag, you enter a "detached HEAD" state:

- HEAD points directly to the tag/commit, not to a branch
- Any new commits made in this state would not be attached to any branch
- The visual representation shows:
  - Master branch pointer at current position
  - Origin/master at its position
  - Tag pointer at your current commit
  - HEAD floating without branch attachment

### Returning to Normal State

To return to normal branch-based workflow:

```bash
# Checkout the master branch to reattach HEAD
git checkout master

# Verify HEAD is attached to master
git lg
```

## Summary

### Key Takeaways

```diff
+ Tags provide human-readable markers for important commits
+ Tags are created with 'git tag <name>' at the current HEAD position
+ Tags must be explicitly pushed to GitHub with 'git push origin <tag>' or '--tags'
+ Use 'git tag -d <tag>' to delete locally and '--delete' to remove from remote
+ Checking out tags puts you in a detached HEAD state
+ Tags are listed alphabetically with 'git tag', not chronologically
```

### Quick Reference

| Command | Description |
|---------|-------------|
| `git tag <name>` | Create tag at current commit |
| `git tag` | List all tags (alphabetical order) |
| `git push origin <tag>` | Push specific tag to remote |
| `git push origin --tags` | Push all tags to remote |
| `git tag -d <tag>` | Delete tag locally |
| `git push origin --delete <tag>` | Delete tag from remote |
| `git checkout <tag>` | Checkout a tag (detached HEAD state) |

### Expert Insight

**Real-world Application**: Tags are essential for software releases. They mark stable versions that users can download, allowing teams to maintain multiple supported versions and clearly communicate release points.

**Expert Path**: Master tagging workflows by understanding lightweight vs annotated tags (not covered in this session), semantic versioning practices, and automated tagging in CI/CD pipelines.

**Common Pitfalls**:
- Forgetting that tags need to be pushed separately from branches
- Using `git push --tags` thinking it will delete tags from remote
- Not realizing you're in a detached HEAD state when working with tags

**Lesser-Known Facts**: Tags in Git can point to any object, not just commits, though pointing to commits is the most common use case. The alphabetical sorting of `git tag` output can be confusing when tags follow version numbers (v1, v10, v2).

</details>