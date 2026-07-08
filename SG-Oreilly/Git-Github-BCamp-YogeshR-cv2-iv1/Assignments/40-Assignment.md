<details open>
<summary><b> Session 40: Stashing Changes - Temporarily Saving Work</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

### Exercise 1.1: Basic Stashing - Understanding the Concept
**Objective**: Understand what git stash does and practice basic stash operations.

**Tasks**:
1. Navigate to a git repository and check the current status
2. Modify a file without committing the changes
3. Use `git stash` to temporarily save the changes
4. Verify the working directory is clean after stashing
5. View the stashed changes using `git stash list`

**Commands**:
```bash
git status
# Modify a file
git stash
git status
git stash list
```

**Deliverable**: Document the stash entry details shown by `git stash list`.

---

### Exercise 1.2: Restoring Stashed Changes
**Objective**: Learn the difference between `git stash apply` and `git stash pop`.

**Tasks**:
1. Start with a clean working directory
2. Make changes to a file and stash them
3. Apply the stash using `git stash apply`
4. Verify the changes are restored and the stash still exists
5. Stash again, then use `git stash pop`
6. Verify the changes are restored and the stash is removed

**Commands**:
```bash
git stash apply
git stash list
git stash
git stash pop
git stash list
```

**Deliverable**: Explain the difference between `apply` and `pop` in a brief note.

---

### Exercise 1.3: Working with Multiple Stashes
**Objective**: Practice managing multiple stashed changes and selecting specific ones.

**Tasks**:
1. Make different changes to files and create multiple stashes
2. Use `git stash list` to see all stashes with their IDs
3. Apply a specific stash using its ID (e.g., `stash@{1}`)
4. Pop a specific stash using its ID
5. Verify the correct stashes remain after operations

**Commands**:
```bash
git stash list
git stash apply stash@{1}
git stash pop stash@{0}
git stash list
```

**Deliverable**: Document the stash IDs before and after selective operations.

---

### Exercise 2.1: Stashing in a Real Development Scenario
**Objective**: Apply stashing to a practical development workflow situation.

**Tasks**:
1. Start working on a feature in your main branch
2. Make several uncommitted changes across multiple files
3. Receive a request to fix an urgent bug on another branch
4. Stash your feature work, switch branches, and fix the bug
5. Commit the bug fix
6. Switch back to your feature branch
7. Restore your stashed work and continue development

**Commands**:
```bash
git stash
git checkout bug-fix-branch
# Fix the bug and commit
git checkout feature-branch
git stash pop
```

**Deliverable**: Write a workflow summary showing when stashing was useful.

---

### Exercise 2.2: Selective File Stashing (Advanced)
**Objective**: Understand that stash operates on the entire working directory state.

**Tasks**:
1. Modify multiple files with unrelated changes
2. Stash all changes together
3. Analyze what gets stored in a single stash entry
4. Practice restoring all changes at once
5. Understand the limitations of selective stashing in git

**Commands**:
```bash
git status
git stash
git stash show
git stash pop
```

**Deliverable**: Document what `git stash show` displays for a multi-file stash.

---

### Exercise 2.3: Stash Best Practices Documentation
**Objective**: Create documentation about git stash best practices.

**Tasks**:
1. Research and test different stash scenarios
2. Document when stashing is appropriate vs. when to commit
3. Note the local-only nature of stashes
4. Create examples of good vs. poor stash usage
5. Write tips for naming and organizing stashes

**Deliverable**: Create a personal reference guide for git stash usage.

---

### Exercise 3.1: Stash Workflow Automation
**Objective**: Create scripts to streamline common stash operations.

**Tasks**:
1. Write a script that stashes changes with a descriptive message
2. Create a script that shows detailed information about all stashes
3. Develop a script that safely pops the most recent stash with confirmation
4. Test your scripts in a practice repository

**Commands**:
```bash
#!/bin/bash
# Example: stash with timestamp
git stash push -m "WIP $(date)"
# List with details
git stash list --oneline
```

**Deliverable**: Working bash scripts for stash management automation.

---

### Exercise 3.2: Troubleshooting Stash Conflicts
**Objective**: Handle conflicts that may arise when applying stashes.

**Tasks**:
1. Create a stash with changes to a file
2. Make conflicting changes to the same file after stashing
3. Attempt to apply the stash and handle the resulting conflict
4. Practice resolving stash-related merge conflicts
5. Document the resolution process

**Commands**:
```bash
git stash
# Make conflicting changes
git stash apply
# Resolve conflicts manually
git add resolved-file
git stash drop  # if needed
```

**Deliverable**: Step-by-step guide for resolving stash conflicts.

---

### Exercise 3.3: Stash vs. Commit Decision Framework
**Objective**: Develop criteria for choosing between stashing and committing incomplete work.

**Tasks**:
1. Analyze different development scenarios
2. Create decision trees for stash vs. commit choices
3. Consider team collaboration implications
4. Evaluate the impact on git history cleanliness
5. Document your decision framework with examples

**Deliverable**: Comprehensive guide for stash vs. commit decision-making in team environments.

</details>
</details>