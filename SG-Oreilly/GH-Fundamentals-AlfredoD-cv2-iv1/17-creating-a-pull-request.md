# Section 17: Creating A Pull Request

<details open>
<summary><b>Section 17: Creating A Pull Request (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Creating a Pull Request via GitHub CLI Message](#creating-a-pull-request-via-github-cli-message)
- [Creating a Pull Request via GitHub Web Interface](#creating-a-pull-request-via-github-web-interface)
- [Using IDE Integration (VS Code)](#using-ide-integration-vs-code)
- [Summary](#summary)

## Overview
This section demonstrates two primary methods for creating pull requests on GitHub: using the command-line interface with automatic detection, and using the GitHub web interface directly. The instructor walks through the complete workflow from creating a branch, making changes, pushing to the remote, and initiating a pull request.

## Creating a Pull Request via GitHub CLI Message

### The Automatic Detection Mechanism
When you push a new branch to a remote repository on GitHub, the GitHub platform automatically detects this action and provides a direct link to create a pull request:

```bash
# Create and switch to a new branch
git checkout -b test-branch

# Make changes to files
# (using text editor to modify README.md)

# Stage and commit changes
git status
git add README.md
git commit -m "delete the video link"

# Push to remote (first time requires upstream specification)
git push
# Git suggests: git push --set-upstream origin test-branch

# Complete the push with upstream
git push --set-upstream origin test-branch
```

### GitHub's Response Message
After successfully pushing a new branch, GitHub's remote server sends a special message through the command line:

```
remote: Create a pull request for 'test-branch' on GitHub by visiting:
remote:      https://github.com/[username]/[repo]/pull/new/test-branch
```

This message contains a direct URL that opens the pull request creation interface with all changes pre-populated.

### Benefits of CLI Method
- ✅ Seamless workflow without leaving the terminal
- ✅ Automatic change detection
- ✅ Direct link generation
- ✅ Works with any Git client that supports remote messaging

## Creating a Pull Request via GitHub Web Interface

### Method 1: Compare & Pull Request Button
1. Navigate to your repository on GitHub
2. GitHub automatically displays a yellow banner when it detects a recently pushed branch
3. Click the **"Compare & pull request"** button
4. Review the changes in the pull request interface
5. Add title and description
6. Create the pull request

### Method 2: Using the Direct URL
1. Copy the URL provided in the git push response
2. Open the URL in a browser
3. The pull request interface opens with:
   - Source branch pre-selected
   - All commits and changes displayed
   - Ready to add description and create

### Visual Confirmation
The pull request interface shows:
- Branch comparison (base ← compare)
- All file changes with diff view
- Commit history
- Option to add reviewers, labels, and projects

## Using IDE Integration (VS Code)

### Similar Behavior in Modern IDEs
When using GitHub-integrated development environments like Visual Studio Code:

1. **Push Action**: Initiate a push of new changes to the remote
2. **Automatic Prompt**: VS Code detects the new branch and offers to create a pull request
3. **One-Click Access**: Similar to the CLI method, provides direct access to the pull request creation
4. **Integrated Experience**: No need to switch between terminal and browser

### Workflow Consistency
The key principle remains consistent across all methods:
- Push new branch → Platform detects → Offer to create PR
- Whether through CLI messages, web interface buttons, or IDE notifications

## Summary

### Key Takeaways
```diff
+ GitHub automatically detects new branch pushes and suggests pull request creation
+ Two main methods: CLI-provided URL or web interface "Compare & pull request" button
+ Both methods result in the same pull request creation interface
+ IDE integrations like VS Code provide similar automated workflows
+ The process requires first pushing changes to trigger the GitHub platform response
```

### Quick Reference
| Method | Steps | Best For |
|--------|-------|----------|
| **CLI + URL** | `git push` → Copy URL → Create PR | Terminal workflows, automation |
| **Web Interface** | Navigate → Click "Compare & pull request" | Visual review, adding metadata |
| **IDE Integration** | Push from IDE → Click notification | Integrated development experience |

### Expert Insight

**Real-world Application**: In professional environments, teams often standardize on one method (usually CLI for speed) while ensuring all team members understand the web interface for complex reviews and metadata management.

**Expert Path**: Master the CLI method for rapid iteration, then learn to enhance pull requests with the web interface by adding:
- Detailed descriptions with screenshots
- Linking related issues
- Assigning reviewers
- Adding appropriate labels

**Common Pitfalls**:
- ❌ Forgetting to push before looking for the pull request option
- ❌ Not setting upstream on first push, which prevents GitHub from detecting the new branch
- ❌ Creating pull requests without reviewing changes first

**Lesser-Known Facts**:
- The automatic PR suggestion message only appears on `git push` output, not on subsequent pushes to the same branch
- GitHub's detection works with any Git hosting that implements the same remote messaging protocol, not just GitHub
- The "Compare & pull request" button only appears for branches that haven't had pull requests created yet

</details>