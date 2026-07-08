<details open>
<summary><b> Session 31: How to Open a Pull Request</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Exercise 1.1: Understanding Pull Requests as Code Integration
**Objective**: Grasp the fundamental concept of pull requests as a code contribution mechanism

**Tasks**:
1. Document the bidirectional nature of pull requests:
   - Incorporating others' code into your project
   - Contributing your code to others' projects
2. Explain how PRs solve the write-access problem
3. Compare PR workflow with direct pushing to master
4. Create a decision tree for when to use PRs vs direct commits

**Documentation**:
```markdown
# Pull Request Fundamentals

## Core Concept
A pull request is a request to merge changes from one branch into another, typically used for code review and integration.

## Bidirectional Flow
### Contributing TO a Project
- You have code → Want to add to someone else's repo
- Solution: Fork → Branch → PR → Merge

### Receiving Contributions
- Others have code → Want to add to your repo
- Solution: Review PR → Approve/Merge → Changes integrated

## The Write-Access Problem
Without PRs:
- Cannot push to others' repositories
- Security: Prevents unauthorized modifications
- Solution: Fork creates your own copy with full rights

## PR vs Direct Commit Decision Tree
```
Do you have write access to target repo?
├── Yes → Can you commit directly?
│   ├── Yes, and change is simple → Direct commit
│   └── No, or prefer review → Create PR
└── No → Must use PR workflow
    ├── Fork repo
    ├── Create branch
    ├── Make changes
    └── Open PR
```
```

**Deliverable**: Comprehensive documentation explaining PR concepts and use cases

## Exercise 1.2: Branch-Based PR Workflow
**Objective**: Master the complete workflow of creating a branch for a pull request

**Tasks**:
1. Create a new branch specifically for PR practice:
   ```bash
   git checkout master
   git checkout -b pr-practice
   ```
2. Make meaningful changes to a file (e.g., README.md)
3. Follow the session's change process:
   - Update content meaningfully
   - Use `git diff` to review changes
   - Stage and commit with descriptive message
4. Document each step with command outputs

**Commands**:
```bash
# Create feature branch
git checkout -b pr-practice-branch

# Make changes
vim README.md
# Edit content meaningfully

# Review changes
git status
git diff README.md

# Commit changes
git add README.md
git commit -m "Improve README clarity and add course description"

# Verify commit
git log --oneline -3
```

**Deliverable**: Complete branch creation with documented changes and commit

## Exercise 1.3: Pushing Branch and Preparing for PR
**Objective**: Successfully push a feature branch to enable PR creation

**Tasks**:
1. Push your practice branch to origin:
   ```bash
   git push origin pr-practice-branch
   ```
2. Document the push process and any output
3. Verify the branch appears on GitHub
4. Note the difference between pushing to feature branch vs master

**Commands**:
```bash
# Push the feature branch (not master!)
git push origin pr-practice-branch

# Verify remote branches
git branch -r

# Check GitHub to confirm branch exists
```

**Deliverable**: Evidence of successful branch push with remote verification

## Exercise 2.1: Creating a Pull Request
**Objective**: Navigate the GitHub PR creation interface effectively

**Tasks**:
1. Access the Pull Requests tab in your repository
2. Document the two methods to initiate a PR:
   - Using "Compare & pull request" button for recent branches
   - Manual "New pull request" button
3. Configure the PR correctly:
   - Source branch: Your feature branch
   - Target branch: master
4. Verify merge capability (no conflicts)
5. Create the PR with appropriate title and description

**PR Creation Process**:
```markdown
# Pull Request Creation Guide

## Method 1: Quick Create
1. Navigate to Pull requests tab
2. Look for "Compare & pull request" for recent branches
3. Click to initiate

## Method 2: Manual Create
1. Click "New pull request" button
2. Select base branch (target): master
3. Select compare branch (source): pr-practice-branch
4. Review the diff preview

## PR Configuration
### Required Elements
- Title: Clear description of changes
- Description: Detailed explanation

### Optional Elements
- Reviewers: Team members to review
- Assignees: Responsible parties
- Labels: Categorization tags
- Milestones: Project phase association
- Projects: Board placement

## Verification Steps
- [ ] No merge conflicts shown
- [ ] Correct branches selected
- [ ] All intended changes visible
- [ ] Title is descriptive
```

**Deliverable**: Successfully created PR with documentation of the process

## Exercise 2.2: Draft vs Ready Pull Requests
**Objective**: Understand and practice the draft PR workflow

**Tasks**:
1. Create a draft pull request first:
   - Click "Create draft pull request"
   - Document when draft PRs are useful
2. Convert draft to ready:
   - Click "Ready for review"
   - Understand the implications
3. Document the differences between draft and ready PRs

**Draft PR Documentation**:
```markdown
# Draft Pull Requests

## When to Use Draft PRs
- Work in progress (WIP)
- Seeking early feedback
- Not ready for formal review
- Testing CI/CD pipeline

## Draft PR Characteristics
- Clearly marked as "Draft"
- Cannot be merged
- Reviewers cannot be requested
- Still visible and accessible

## Converting to Ready
1. Complete the work
2. Click "Ready for review"
3. PR becomes mergeable
4. Reviewers can be assigned

## Workflow Example
```
Start Feature → Create Draft PR → Continue Work →
Seek Early Feedback → Complete Feature →
Mark Ready → Request Reviews → Merge
```
```

**Deliverable**: Experience with both draft and ready PR states

## Exercise 2.3: PR Review Interface Exploration
**Objective**: Master the tools available for reviewing pull requests

**Tasks**:
1. Explore all tabs in the PR interface:
   - **Conversation**: Comments and discussion
   - **Commits**: List of commits in the PR
   - **Files changed**: Diff view with review tools
2. Practice using review features:
   - Leave line comments
   - Start a review
   - View file changes
3. Document each review capability

**Review Interface Guide**:
```markdown
# PR Review Interface Components

## Tabs Overview

### Conversation Tab
- Overall PR discussion
- Status updates
- General comments
- Review summaries

### Commits Tab
- Chronological commit list
- Commit messages and hashes
- Ability to view individual commits
- Compare across commits

### Files Changed Tab
- Complete diff view
- File-by-file breakdown
- Line-by-line changes
- Review tools per line

## Review Actions
1. **Comment**: Leave feedback without formal review
2. **Approve**: Official approval of changes
3. **Request Changes**: Formal feedback requiring updates

## Code Review Features
- Line-specific comments
- Suggestion blocks
- Threaded discussions
- "Viewed" status tracking
- Rich text vs code view

## Important Notes
- Authors cannot approve their own PRs
- Reviews can be dismissed
- Comments can be marked as resolved
```

**Deliverable**: Documentation of PR review interface with practical usage notes

## Exercise 3.1: Merge Strategies Exploration
**Objective**: Understand and compare different merge strategies in GitHub

**Tasks**:
1. Document the three merge options:
   - **Create a merge commit**: Preserves complete history
   - **Squash and merge**: Combines all commits into one
   - **Rebase and merge**: Replays commits without merge commit
2. Analyze when to use each strategy:
   - Commit volume considerations
   - History preservation needs
   - Team preferences
3. Create a decision matrix for merge strategy selection

**Merge Strategy Analysis**:
```markdown
# Pull Request Merge Strategies

## Strategy 1: Create Merge Commit
### Characteristics
- Preserves all original commits
- Creates merge commit showing branch integration
- Maintains complete development history
- Shows when feature was integrated

### Best For
- Complex features with multiple commits
- When commit history provides valuable context
- Teams that value complete audit trails
- Understanding development timeline

### Command Equivalent
```bash
git merge feature-branch
# Creates merge commit
```

## Strategy 2: Squash and Merge
### Characteristics
- Combines all PR commits into single commit
- Cleaner git history
- Loses intermediate commit details
- Commit message can be customized

### Best For
- PRs with many small commits
- "Work in progress" commits
- When intermediate steps aren't valuable
- Maintaining linear history

### Command Equivalent
```bash
git merge --squash feature-branch
git commit -m "Feature: Complete description"
```

## Strategy 3: Rebase and Merge
### Characteristics
- Replays commits on top of target branch
- No merge commit created
- Maintains individual commits
- Linear history without branches

### Best For
- Small, atomic commits
- When preserving commit sequence matters
- Avoiding merge commit clutter
- Clean, linear project history

### Command Equivalent
```bash
git rebase master
git checkout master
git merge feature-branch
# Fast-forward merge
```

## Decision Matrix

| Scenario | Recommended Strategy | Reason |
|----------|---------------------|---------|
| Single commit PR | Create merge commit | Simple and clear |
| Many WIP commits | Squash and merge | Clean history |
| Complex feature | Create merge commit | Preserve development path |
| Linear history preference | Rebase and merge | Maintains sequence |
| Audit requirements | Create merge commit | Complete history |
```

**Deliverable**: Comprehensive merge strategy guide with decision framework

## Exercise 3.2: Complete PR Lifecycle Management
**Objective**: Execute the full pull request workflow from creation to cleanup

**Tasks**:
1. Complete the PR merge process:
   - Review changes one final time
   - Select appropriate merge strategy
   - Add merge commit message
   - Confirm the merge
2. Handle post-merge cleanup:
   - Delete the remote branch when prompted
   - Delete the local branch manually
   - Pull the merged changes to local master
3. Verify the complete workflow

**Complete Workflow Commands**:
```bash
# Before merging
git checkout master
git pull origin master  # Ensure up to date

# After PR merge on GitHub
# Delete remote branch (via GitHub or command)
git push origin --delete pr-practice-branch

# Delete local branch
git branch -d pr-practice-branch

# Update local master
git pull origin master

# Verify changes
cat README.md  # Should show PR changes
git log --oneline -5
```

**Cleanup Verification**:
```bash
# Confirm branch deletion
git branch  # Should not show deleted branch
git branch -a  # Remote branches shouldn't show deleted branch

# Confirm merge in history
git log --oneline --graph -10
```

**Deliverable**: Complete PR lifecycle execution with all cleanup steps

## Exercise 3.3: Hands-On Assignment - Fork and PR to Original Repository
**Objective**: Complete the practical assignment to contribute to someone else's repository via PR

**Tasks**:
1. **Fork the Repository**:
   - Navigate to: `github.com/calebtalbot/git-essentials`
   - Click the "Fork" button
   - Select your personal account as destination

2. **Clone Your Fork**:
   - Copy the clone URL from YOUR fork (not original)
   - Clone using SSH or HTTPS:
     ```bash
     git clone [your-fork-url]
     cd git-essentials
     ```

3. **Make Meaningful Changes**:
   - Create a feature branch:
     ```bash
     git checkout -b my-improvement
     ```
   - Make a substantive improvement (examples below)
   - Commit your changes:
     ```bash
     git add .
     git commit -m "Improve [specific aspect] of the repository"
     ```

4. **Push and Create PR**:
   - Push to your fork:
     ```bash
     git push origin my-improvement
     ```
   - Navigate to ORIGINAL repository
   - Click "Pull request" or "New pull request"
   - Select your fork as source, original as target
   - Create the pull request

5. **Improvement Suggestions** (Choose One):
   - Enhance README.md with clearer explanations
   - Add a CONTRIBUTING.md file
   - Fix any typos or formatting issues
   - Add a license file if missing
   - Improve code comments in any file
   - Add a .gitignore if needed

**Assignment Checklist**:
```markdown
# PR Assignment Checklist

## Pre-Work
- [ ] Forked the calebtalbot/git-essentials repository
- [ ] Cloned YOUR fork locally
- [ ] Verified remote origin points to your fork

## Development
- [ ] Created feature branch (not working on master)
- [ ] Made meaningful improvement to the repository
- [ ] Reviewed changes with git diff
- [ ] Committed with clear, descriptive message

## Submission
- [ ] Pushed branch to your fork
- [ ] Navigated to ORIGINAL repository
- [ ] Opened pull request from your fork
- [ ] Provided clear PR title and description
- [ ] Verified PR shows intended changes

## Quality Checks
- [ ] Changes are substantive (not trivial)
- [ ] Commit message follows best practices
- [ ] PR description explains the improvement
- [ ] No unintended files changed

## Example Improvements
1. **README Enhancement**:
   - Add installation prerequisites
   - Include usage examples
   - Add table of contents

2. **Documentation Addition**:
   - Create CONTRIBUTING.md
   - Add CODE_OF_CONDUCT.md
   - Document project structure

3. **Code Quality**:
   - Add .editorconfig file
   - Improve existing documentation
   - Fix any broken links
```

**Deliverable**: Successfully submitted pull request to the original repository with meaningful improvements

</details>
</details>