# Session 25: Viewing File Differences

<details open>
<summary><b>Session 25: Viewing File Differences (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Understanding Git Diff](#understanding-git-diff)
- [The Git Diff Workflow](#the-git-diff-workflow)
- [Color Coding in Diff Output](#color-coding-in-diff-output)
- [Practical Example Walkthrough](#practical-example-walkthrough)
- [Best Practices for Reviewing Changes](#best-practices-for-reviewing-changes)
- [Key Takeaways](#key-takeaways)
- [Quick Reference](#quick-reference)
- [Expert Insights](#expert-insights)

## Overview
Git diff is a powerful command that allows you to preview changes in your working directory before committing them. This session demonstrates how to use `git diff` to review modifications, understand the visual output format, and incorporate this step into a professional Git workflow.

## Understanding Git Diff
Git diff shows the difference between the last committed version of a file and your current working version. This is essential for:
- Reviewing changes before staging
- Verifying that only intended modifications will be committed
- Catching accidental deletions or unwanted additions
- Maintaining code quality through careful review

## The Git Diff Workflow
A recommended professional workflow includes these steps:

```bash
# 1. Check current status
git status

# 2. View differences in specific file
git diff filename.ext

# 3. Review changes line by line
# (Examine all red and green highlighted sections)

# 4. If changes look good, stage the file
git add filename.ext

# 5. If not satisfied, continue editing
# Then repeat steps 1-4

# 6. Commit when ready
git commit -m "Your commit message"

# 7. Push to remote
git push origin branch-name
```

## Color Coding in Diff Output
Git uses a simple but effective color system:

| Color | Meaning | Action |
|-------|---------|--------|
| 🔴 Red | Deleted content | Lines removed from the file |
| 🟢 Green | Added content | New lines inserted into the file |
| (No color) | Unchanged content | Lines that remain the same |

> [!NOTE]
> Git is intelligent enough to detect when content hasn't actually changed. If you delete text and paste identical content, Git recognizes this and won't mark it as a change.

## Practical Example Walkthrough

### Initial Setup
1. Modify a file (e.g., `README.md`) using any text editor
2. Check status to confirm modification:
   ```bash
   git status
   # Shows: modified: README.md
   ```

### Running Git Diff
```bash
git diff README.md
```

### Interpreting the Output
The diff output will display:
- Lines prefixed with `-` (minus) in red showing deleted content
- Lines prefixed with `+` (plus) in green showing added content
- Context lines for reference

### Common Workflow Review Process
```bash
# Review the diff
git diff README.md

# Mental checklist while reviewing:
# ❌ Don't want this change
# ❌ Don't need this addition
# ✅ Looks good, ready to commit
```

## Best Practices for Reviewing Changes
- Always run `git diff` before committing modified files
- Review changes line by line, not just glancing
- Check for unintended modifications
- Verify that TODO comments or temporary notes are removed if necessary
- Use `git status` before and after `git diff` to maintain awareness of repository state

## Key Takeaways
```diff
+ Always review changes with git diff before committing
+ Red indicates deletions, green indicates additions
+ Git intelligently detects unchanged content
+ Make git diff part of your standard workflow
- Never commit without reviewing your changes first
```

## Quick Reference
```bash
# View differences for a specific file
git diff <filename>

# Common workflow sequence
git status → git diff <file> → git add <file> → git commit → git push
```

## Expert Insights

### Real-world Application
In production environments, using `git diff` consistently prevents accidental commits of debug code, temporary changes, or sensitive information. It's especially valuable when working with configuration files or when multiple developers are collaborating on the same codebase.

### Expert Path
- Practice using `git diff` with different file types
- Learn about `git diff --staged` to compare staged changes with the last commit
- Explore `git difftool` for visual diff comparison tools
- Understand how to configure your preferred diff viewer

### Common Pitfalls
- **Skipping the review**: Committing without reviewing changes can introduce bugs or unwanted code
- **Ignoring large diffs**: Even small projects can generate large diffs that deserve careful attention
- **Not understanding color coding**: Misinterpreting what red and green mean can lead to confusion

### Lesser-Known Facts
- Git's diff algorithm can sometimes be "too smart" - it may not show changes if identical content is moved
- The diff output format follows the unified diff standard, making it compatible with patch files
- You can use `git diff HEAD` to compare your working directory against the last commit on the current branch

</details>