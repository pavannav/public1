<details open>
<summary><b>15-Undeleting-a-File (KK-CS45-script-v2-Inst-v1)</b></summary>

# 15: Undeleting a File

## Table of Contents
- [Overview](#overview)
- [Undeleting a File](#undeleting-a-file)
- [Key Takeaways](#key-takeaways)
- [Quick Reference](#quick-reference)
- [Expert Insight](#expert-insight)

## Overview
This lesson demonstrates how to recover files that have been accidentally deleted using Git. Even if a file has been removed from the filesystem (and potentially not in the trash), Git can restore it from the last commit where it existed.

## Undeleting a File

### The Problem Scenario
When working with Git, you may accidentally delete a file that was previously tracked. Without Git, deleted files typically go to the trash folder, but command-line deletions (using `rm`) may permanently remove files. Git provides a safety net for recovering these files.

### The Solution: `git checkout`
Git's checkout command can restore deleted files from the last commit:

```bash
git checkout -- first_push.txt
git status
ls -la
```

This sequence:
1. Restores the deleted file from the last commit
2. Shows the working directory is clean (no changes)
3. Confirms the file exists again

### Practical Demonstration
```bash
# Delete the file
rm first_push.txt
git status  # Shows deletion
ls -la      # File no longer exists

# Restore the file
git checkout -- first_push.txt
git status  # Clean state
ls -la      # File restored!
```

### How Git Checkout Works for File Recovery
When you run `git checkout -- filename`, Git:
1. Recognizes you have commits in history
2. Locates the file's contents from the last commit
3. Restores the file exactly as it was in that commit
4. The file returns to its pre-deletion state

### Local Git Repository Benefits
Git's file recovery works even without a remote repository:
- Initialize a local repository: `git init`
- Commit files regularly
- Use `git checkout` to recover any committed file
- No need for GitHub, GitLab, or Bitbucket

> [!IMPORTANT]
> Git checkout has multiple uses beyond file recovery. We'll explore additional checkout functionality in later lessons.

> [!NOTE]
> You can only recover files that existed in a previous commit. Untracked files that were never committed cannot be recovered using this method.

## Key Takeaways

```diff
+ Git provides built-in file recovery through checkout
+ Files can be restored even after permanent deletion (rm command)
+ Recovery works from local commits without remote repositories
+ git checkout -- filename restores from last commit
- Cannot recover untracked files that were never committed
- Only restores to the state of the last commit
```

## Quick Reference

| Command | Description |
|---------|-------------|
| `git checkout -- filename` | Restore deleted file from last commit |
| `git status` | Check working directory state |
| `git init` | Initialize local repository for file tracking |

## Expert Insight

### Real-world Application
In production environments, developers regularly use `git checkout` to recover files during active development. This is especially valuable when:
- Experimenting with code changes that need to be reverted
- Accidentally deleting important configuration files
- Testing destructive operations safely

### Expert Path
To master file recovery:
1. Practice regularly with `git checkout` on test repositories
2. Understand the distinction between tracked and untracked files
3. Learn when to use `--` to explicitly separate options from filenames
4. Combine with `git stash` for more advanced recovery scenarios

### Common Pitfalls
- **Confusion with branch checkout**: Remember `git checkout -- file` differs from `git checkout branchname`
- **Untracked files**: Files never added to Git cannot be recovered
- **Multiple commits**: Checkout always uses the last commit; use `git log` to find specific versions

### Lesser-Known Facts
- Git keeps a reflog that can help recover even more complex scenarios
- The double dash (`--`) is optional but recommended for clarity
- Git's recovery works across all operating systems consistently

</details>