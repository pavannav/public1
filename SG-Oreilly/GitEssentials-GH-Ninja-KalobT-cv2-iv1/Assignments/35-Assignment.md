<details open>
<summary><b> Session 35: Resolving Merge and Rebase Conflicts</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Exercise 1.1: Understanding Git Conflicts
**Objective**: Learn the fundamental concepts of git conflicts

**Tasks**:
1. Identify scenarios that cause conflicts in git
2. Understand the difference between merge conflicts and rebase conflicts
3. Recognize conflict markers in files

**Deliverable**: Document explaining conflict scenarios and their visual indicators in git

---

## Exercise 1.2: Setting Up a Merge Conflict Scenario
**Objective**: Create a controlled environment to practice merge conflicts

**Tasks**:
1. Create a file on GitHub with multiple lines of content
2. Create the same file locally with different content on the same lines
3. Attempt to pull/push to trigger the conflict

**Commands**:
```bash
# On GitHub: Create merge-conflict.txt with line 1-5 by github
# Locally: Create merge-conflict.txt with modified line 3
git status
git add merge-conflict.txt
git commit -m "Add merge conflict file locally"
git pull origin master
```

**Deliverable**: Screenshot showing the conflict detection with "Auto-merging failed" message

---

## Exercise 1.3: Reading Conflict Markers
**Objective**: Learn to interpret git conflict markers

**Tasks**:
1. Analyze the conflict markers in a conflicted file
2. Identify HEAD content vs incoming content
3. Understand the structure: <<<<<<<, =======, >>>>>>>

**Commands**:
```bash
git diff merge-conflict.txt
cat merge-conflict.txt
```

**Deliverable**: Annotated conflict file explaining each section of the conflict markers

---

## Exercise 2.1: Resolving Merge Conflicts
**Objective**: Practice the complete merge conflict resolution workflow

**Tasks**:
1. Edit the conflicted file to resolve differences
2. Remove conflict markers and choose appropriate content
3. Stage and commit the resolved file

**Commands**:
```bash
vim merge-conflict.txt  # or your preferred editor
git add merge-conflict.txt
git status
git commit
```

**Deliverable**: Successfully resolved merge with commit message showing merge resolution

---

## Exercise 2.2: Setting Up a Rebase Conflict
**Objective**: Create a scenario that demonstrates rebase conflicts

**Tasks**:
1. Create a file on master branch
2. Create a branch from an earlier commit
3. Modify the same file on the branch with conflicting content
4. Attempt to rebase the branch onto master

**Commands**:
```bash
git checkout master
git checkout [earlier-commit-hash]
git checkout -b rebase-conflict-branch
# Create conflicting file
git add rebase-conflict.txt
git commit -m "Rebase conflict file from branch"
git checkout master
git rebase rebase-conflict-branch
```

**Deliverable**: Documentation of the rebase conflict setup and initial error message

---

## Exercise 2.3: Resolving Rebase Conflicts
**Objective**: Master the rebase conflict resolution process

**Tasks**:
1. Analyze the rebase conflict markers
2. Resolve conflicts by editing the file
3. Use git rebase --continue to proceed
4. Abort rebase if needed using git rebase --abort

**Commands**:
```bash
git diff
# Edit file to resolve conflicts
git add rebase-conflict.txt
git status
git rebase --continue
# If needed: git rebase --abort
```

**Deliverable**: Successfully rebased branch with linear commit history

---

## Exercise 3.1: Advanced Conflict Resolution Strategies
**Objective**: Handle complex conflict scenarios with multiple files

**Tasks**:
1. Create conflicts involving multiple files simultaneously
2. Practice using different editors for conflict resolution
3. Document strategies for choosing between conflicting changes

**Deliverable**: Workflow guide for resolving multi-file conflicts efficiently

---

## Exercise 3.2: Conflict Prevention Techniques
**Objective**: Learn strategies to minimize conflicts in team development

**Tasks**:
1. Research and document best practices for avoiding conflicts
2. Practice frequent pulling/rebase to stay current with remote
3. Create communication strategies for team conflict resolution

**Deliverable**: Best practices document for conflict prevention in collaborative development

---

## Exercise 3.3: Recovery and Safety Commands
**Objective**: Master safety commands for conflict resolution scenarios

**Tasks**:
1. Practice git rebase --abort to safely exit problematic rebases
2. Use git reset --hard and git reset --soft for recovery
3. Document when to use each safety command versus continuing

**Commands**:
```bash
git rebase --abort
git reset --hard
git reset --soft
git rebase --skip  # When no actual conflict exists
```

**Deliverable**: Decision tree for choosing appropriate recovery commands during conflict resolution

</details>
</details>