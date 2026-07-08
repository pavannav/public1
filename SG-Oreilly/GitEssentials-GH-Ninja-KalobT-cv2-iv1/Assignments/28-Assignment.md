<details open>
<summary><b> Session 28: Fixing Git Commit Messages</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Exercise 1.1: Create a Commit with Intentional Error
**Objective**: Practice creating commits while understanding the amend workflow

**Tasks**:
1. Create a new file with content
2. Stage the file
3. Commit with a deliberate typo in the message
4. Verify the commit appears in history with the error
5. Document the scenario setup

**Commands**:
```bash
touch bad-commit-msg.txt
echo "Test content for amend exercise" > bad-commit-msg.txt
git add bad-commit-msg.txt
git commit -m "Addd new test fil"  # Intentional typos
git log --oneline -3
```

**Deliverable**: Commit with visible typos ready for amendment demonstration

## Exercise 1.2: Use Git Amend to Fix Commit Message
**Objective**: Master the `git commit --amend` command to correct commit messages

**Tasks**:
1. Identify the commit that needs correction
2. Execute `git commit --amend`
3. Edit the commit message to fix the typos
4. Save and exit the editor
5. Verify the corrected message appears in git log

**Commands**:
```bash
git commit --amend
# In editor: Fix the message to "Add new test file"
# Save and exit (Ctrl+O, Enter, Ctrl+X for nano)
git log --oneline -3
```

**Deliverable**: Evidence of successful commit message correction using amend

## Exercise 1.3: Amend Workflow Documentation
**Objective**: Document the complete amend process for future reference

**Tasks**:
1. Create a step-by-step guide for amending commits
2. Include screenshots or command outputs at each step
3. Document editor-specific instructions (vim, nano, VS Code)
4. Note any prerequisites or warnings

**Documentation Template**:
```markdown
# Git Commit Amend Workflow

## When to Use
- Fix typos in commit messages
- Update commit before pushing
- Add forgotten files to last commit

## Prerequisites
- Commit must not be pushed to remote yet

## Step-by-Step Process
1. [Initial state]
2. [Run amend command]
3. [Edit message]
4. [Verify changes]

## Editor Configuration
- Nano: [Key combinations]
- Vim: [Key combinations]
- VS Code: [Setup instructions]
```

**Deliverable**: Comprehensive workflow documentation with all steps

## Exercise 2.1: Test Amend Timing Constraints
**Objective**: Understand when amend can and cannot be used

**Tasks**:
1. Create multiple commits in sequence
2. Attempt to amend the latest commit (should work)
3. Document what happens if you try to amend an older commit
4. Test the boundary: amend before vs after push
5. Create a decision matrix for when amend is appropriate

**Commands**:
```bash
# Create test commits
echo "content1" > test1.txt && git add test1.txt && git commit -m "First commit"
echo "content2" > test2.txt && git add test2.txt && git commit -m "Second commit"
echo "content3" > test3.txt && git add test3.txt && git commit -m "Third commit"

# Test amend on latest (works)
git commit --amend

# Attempt on older commit (won't work directly)
git log --oneline
```

**Deliverable**: Decision matrix showing appropriate use cases for amend

## Exercise 2.2: Amend with Additional File Changes
**Objective**: Use amend to include forgotten changes in the last commit

**Tasks**:
1. Create and commit a file
2. Create another file that should have been included
3. Realize the mistake before pushing
4. Use amend to include the forgotten file
5. Document the complete scenario and resolution

**Commands**:
```bash
# Original commit
echo "main feature" > feature.txt
git add feature.txt
git commit -m "Add main feature"

# Forgot a related file
echo "feature tests" > feature.test.js

# Amend to include forgotten file
git add feature.test.js
git commit --amend --no-edit  # Keep same message
# OR
git commit --amend  # Edit message if needed

git log --stat -1  # Verify both files in commit
```

**Deliverable**: Evidence of combining multiple changes into single commit using amend

## Exercise 2.3: Safe Amend Practices
**Objective**: Establish best practices for using amend safely

**Tasks**:
1. Create safety checklist before using amend:
   - [ ] Commit has not been pushed
   - [ ] Working directory is clean
   - [ ] No other branches depend on this commit
   - [ ] Team members haven't pulled this commit
2. Document recovery procedures if amend causes issues
3. Create guidelines for team collaboration with amend

**Safety Documentation**:
```markdown
# Safe Amend Practices

## Pre-Amend Checklist
- [ ] Verify commit not pushed: `git log origin/master..HEAD`
- [ ] Check working directory is clean
- [ ] Confirm no shared branches reference this commit

## Red Flags - Do NOT Amend
- Commit already pushed to shared branch
- Other developers have based work on this commit
- Commit is part of a shared feature branch

## Recovery Procedures
If wrong amend occurs:
1. [Use reflog to find previous state]
2. [Reset to previous commit if needed]
3. [Recreate changes if lost]
```

**Deliverable**: Safety guidelines document with checklists and recovery procedures

## Exercise 3.1: Amend in Realistic Workflow
**Objective**: Integrate amend into a realistic development workflow

**Tasks**:
1. Simulate a development session:
   - Make changes related to a feature
   - Commit with placeholder message
   - Review commit message and realize it needs improvement
   - Amend with proper descriptive message
2. Document the thought process for message improvement
3. Show before/after commit messages

**Scenario**:
```bash
# Development work
# ... coding ...

# Initial commit with placeholder
git commit -m "fix stuff"

# Realize message is inadequate
git log --oneline -1

# Amend with proper message
git commit --amend
# New message: "Fix authentication timeout issue in login handler"
```

**Deliverable**: Complete workflow example with message evolution documentation

## Exercise 3.2: Editor Configuration for Amend
**Objective**: Configure preferred editor for amend operations

**Tasks**:
1. Configure git to use your preferred editor for commit messages:
   ```bash
   # For VS Code
   git config --global core.editor "code --wait"

   # For Sublime
   git config --global core.editor "subl -n -w"

   # For Vim (default on many systems)
   git config --global core.editor vim

   # For Nano
   git config --global core.editor nano
   ```
2. Test amend with your configured editor
3. Document editor-specific workflows
4. Create editor configuration guide for team

**Commands**:
```bash
# Configure preferred editor
git config --global core.editor "your-editor --wait"

# Test the configuration
git commit --amend
# Editor should open automatically
```

**Deliverable**: Editor configuration with testing evidence and team guide

## Exercise 3.3: Advanced Commit Message Best Practices
**Objective**: Develop expertise in writing effective commit messages

**Tasks**:
1. Research and document commit message best practices:
   - Subject line (50 chars or less)
   - Body formatting (72 char wrap)
   - Imperative mood usage
   - Reference to issues/tickets
2. Create examples of good vs bad commit messages
3. Practice amending poor messages to follow best practices
4. Create a commit message template

**Message Standards Document**:
```markdown
# Commit Message Standards

## Structure
```
<type>(<scope>): <subject>

<body>

<footer>
```

## Types
- feat: A new feature
- fix: A bug fix
- docs: Documentation changes
- style: Formatting changes
- refactor: Code restructuring
- test: Adding missing tests

## Examples

### Good
```
fix(auth): resolve session timeout after 30 minutes

The authentication middleware was not properly
refreshing the session token, causing users to be
logged out unexpectedly.

Fixes #123
```

### Bad (to be amended)
```
fixed the thing that was broken
```

## Template
[Create reusable message template]
```

**Deliverable**: Comprehensive commit message standards with examples and templates

</details>
</details>