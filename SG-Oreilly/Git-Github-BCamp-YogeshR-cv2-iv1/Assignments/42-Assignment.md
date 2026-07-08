<details open>
<summary><b> Session 42: Demonstration - Rebasing in Git</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

### Exercise 1.1: Basic Rebase Demonstration Setup
**Objective**: Recreate the rebase demonstration environment and understand the setup process.

**Tasks**:
1. Set up a git repository with the same file structure as shown in the demo
2. Create initial commits including moving TXT files to a dedicated folder
3. Verify the initial commit history with `git log --oneline --graph`
4. Document the initial branched history pattern from previous merges

**Commands**:
```bash
git mv *.txt txt/
git commit -m "move TXT files to txt folder"
git log --oneline --graph
git branch
```

**Deliverable**: Screenshot of initial commit graph showing branched history from merges.

---

### Exercise 1.2: Creating Feature Branch for Rebasing
**Objective**: Create and populate a feature branch to prepare for rebasing.

**Tasks**:
1. Create a new branch called `rebase-branch` from main
2. Add two files (`rebase.txt` and `rebase-two.txt`) with commits on this branch
3. Verify the branch divergence in the commit graph
4. Document the commit messages and file additions

**Commands**:
```bash
git checkout -b rebase-branch
touch rebase.txt
git add rebase.txt && git commit -m "rebase file added"
touch rebase-two.txt
git add rebase-two.txt && git commit -m "rebase two file added"
git log --oneline --graph
```

**Deliverable**: Documented feature branch creation with commit details and graph visualization.

---

### Exercise 1.3: Rebase Operation Execution
**Objective**: Execute the actual rebase operation and observe the results.

**Tasks**:
1. Switch back to main branch
2. Execute `git rebase rebase-branch` command
3. Observe git's confirmation of successful rebase
4. Analyze the new linear commit history with `git log --oneline --graph`

**Commands**:
```bash
git checkout main
git rebase rebase-branch
git log --oneline --graph
git status
```

**Deliverable**: Before/after comparison of commit graphs showing the linear history result.

---

### Exercise 2.1: Branch Status Analysis
**Objective**: Understand and interpret branch status information during rebasing workflows.

**Tasks**:
1. Monitor branch status throughout the rebase process
2. Interpret what "3 commits ahead" means in the context of rebasing
3. Document the relationship between branches before and after rebasing
4. Practice checking branch divergence with various git commands

**Commands**:
```bash
git status
git branch -vv
git log --oneline main..rebase-branch
git log --oneline rebase-branch..main
```

**Deliverable**: Status analysis report showing branch relationships before/after rebase.

---

### Exercise 2.2: Remote Push After Rebase
**Objective**: Safely push rebased changes to a remote repository.

**Tasks**:
1. Configure HTTPS remote connection (as referenced in the demo)
2. Attempt to push changes after rebasing
3. Handle authentication when prompted
4. Document any force push requirements or considerations

**Commands**:
```bash
git remote -v
git push origin main
# Handle username/password authentication
```

**Deliverable**: Documented push process with authentication handling notes.

---

### Exercise 2.3: History Comparison Analysis
**Objective**: Analyze the differences between merge-based and rebase-based histories.

**Tasks**:
1. Create a scenario where you compare merge vs rebase outcomes
2. Document the visual differences in commit graphs
3. Identify the merge commits eliminated by rebasing
4. Analyze readability improvements in the linear history

**Commands**:
```bash
# Create merge scenario for comparison
git merge rebase-branch
git log --oneline --graph
# Reset and try rebase instead
git reset --hard HEAD~1
git rebase rebase-branch
git log --oneline --graph
```

**Deliverable**: Side-by-side comparison analysis of merge vs rebase history patterns.

---

### Exercise 3.1: Advanced Rebase Workflow Automation
**Objective**: Create scripts to automate safe rebasing workflows.

**Tasks**:
1. Write a script that creates a feature branch, makes changes, and rebases onto main
2. Include safety checks and status reporting
3. Add confirmation prompts before destructive operations
4. Test the script in a practice repository

**Commands**:
```bash
#!/bin/bash
# Example rebase workflow script
git checkout -b feature-auto
# Make changes...
git checkout main
git rebase feature-auto
git log --oneline --graph
```

**Deliverable**: Automated rebase workflow script with safety features.

---

### Exercise 3.2: Conflict Resolution During Rebase
**Objective**: Handle potential conflicts that may arise during rebase operations.

**Tasks**:
1. Create a scenario where rebase would cause conflicts
2. Practice resolving conflicts during the rebase process
3. Document the rebase conflict resolution workflow
4. Compare conflict handling between merge and rebase operations

**Commands**:
```bash
# During rebase conflict:
git status
# Edit conflicting files
git add resolved-file
git rebase --continue
# Or abort if needed:
git rebase --abort
```

**Deliverable**: Step-by-step conflict resolution guide specific to rebase operations.

---

### Exercise 3.3: Production Rebase Safety Protocol
**Objective**: Develop comprehensive safety protocols for rebasing in production environments.

**Tasks**:
1. Create a pre-rebase checklist including backup procedures
2. Document communication protocols for team members
3. Establish rollback procedures if rebase causes issues
4. Design monitoring for rebase-related problems in CI/CD pipelines

**Deliverable**: Production-ready rebase safety protocol document with checklists and procedures.

</details>
</details>