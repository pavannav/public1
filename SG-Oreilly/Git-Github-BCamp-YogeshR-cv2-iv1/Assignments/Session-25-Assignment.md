<details open>
<summary><b> Session 25: Demonstration: Undoing Changes - git reset and git revert</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

### Exercise 1.1: Understanding Git Reset Modes
**Objective**: Understand the differences between git reset modes (soft, mixed, hard)

**Tasks**:
1. Create a new Git repository and initialize it
2. Create a file called `test.txt` with content "Initial content"
3. Commit this file as "Commit 1"
4. Append "Second line" to the file and commit as "Commit 2"
5. Append "Third line" to the file and commit as "Commit 3"
6. View the git log to confirm all commits

**Commands**:
```bash
git init undo-demo
cd undo-demo
echo "Initial content" > test.txt
git add test.txt && git commit -m "Commit 1"
echo "Second line" >> test.txt
git add test.txt && git commit -m "Commit 2"
echo "Third line" >> test.txt
git add test.txt && git commit -m "Commit 3"
git log --oneline
```

**Deliverable**: Document the commit hash IDs and explain what each reset mode does

---

### Exercise 1.2: Practicing git reset --soft
**Objective**: Learn how to use soft reset to preserve staged changes

**Tasks**:
1. Using the repository from Exercise 1.1, reset back to "Commit 1" using `--soft`
2. Check git status to see the changes are staged
3. View the content of `test.txt` to confirm changes are preserved
4. Create a new commit combining "Commit 2" and "Commit 3"

**Commands**:
```bash
git reset --soft <commit-1-hash>
git status
cat test.txt
git commit -m "Combined Commit 2 and 3"
git log --oneline
```

**Deliverable**: Screenshot showing staged changes after soft reset and the new commit history

---

### Exercise 1.3: Practicing git reset --mixed (default)
**Objective**: Understand the default mixed reset behavior

**Tasks**:
1. Reset back to "Commit 1" using `--mixed` or without specifying a mode
2. Check git status to observe unstaged changes
3. Compare the behavior with `--soft` reset
4. Stage and commit the changes

**Commands**:
```bash
git reset <commit-1-hash>
git status
git add test.txt && git commit -m "Commit with mixed reset"
```

**Deliverable**: Comparison document between soft and mixed reset behaviors

---

### Exercise 2.1: Practicing git reset --hard
**Objective**: Understand the destructive nature of hard reset

**Tasks**:
1. Create commits 1, 2, and 3 again (similar to Exercise 1.1)
2. Use `git reset --hard` to go back to "Commit 1"
3. Verify that commits 2 and 3 are completely gone
4. Check file content to confirm changes are lost

**Commands**:
```bash
git reset --hard <commit-1-hash>
git log --oneline
cat test.txt
```

**Deliverable**: Documentation of the irreversible nature of hard reset with warnings

---

### Exercise 2.2: Introduction to git revert
**Objective**: Learn the safer approach of undoing changes with revert

**Tasks**:
1. Create a new sequence of commits A, B, and C
2. Use `git revert` on commits B and C together
3. Observe that history is preserved with a new revert commit
4. Compare the repository state with the original state

**Commands**:
```bash
# Create commits A, B, C
echo "This is commit A" > commits.txt
git add commits.txt && git commit -m "Commit A"
echo "This is commit B" >> commits.txt
git add commits.txt && git commit -m "Commit B"
echo "This is commit C" >> commits.txt
git add commits.txt && git commit -m "Commit C"

# Revert commits B and C
git revert <commit-B-hash>..<commit-C-hash>
# Or revert individually if needed
git log --oneline
```

**Deliverable**: Git log showing the revert commit preserving full history

---

### Exercise 2.3: Comparing Reset vs Revert
**Objective**: Understand when to use each command appropriately

**Tasks**:
1. Document scenarios where reset would be appropriate (local work, mistakes)
2. Document scenarios where revert would be appropriate (shared repositories, team collaboration)
3. Create a decision tree for choosing between reset and revert

**Deliverable**: Decision matrix document for choosing between git reset and git revert

---

### Exercise 3.1: Advanced Revert Scenarios
**Objective**: Handle complex revert situations

**Tasks**:
1. Create a branch with multiple feature commits
2. Merge the branch into main
3. Revert the merge commit
4. Practice reverting individual commits in a linear history

**Commands**:
```bash
git checkout -b feature-branch
# Make multiple commits
git checkout main
git merge feature-branch
git revert -m 1 <merge-commit-hash>
```

**Deliverable**: Branch history showing successful merge revert

---

### Exercise 3.2: Recovery from Mistakes
**Objective**: Practice recovering from accidental resets

**Tasks**:
1. Perform a hard reset that removes commits
2. Use `git reflog` to find the lost commits
3. Recover the commits using reset to the reflog entry
4. Document the recovery process

**Commands**:
```bash
git reflog
git reset --hard <reflog-entry-hash>
```

**Deliverable**: Recovery documentation with reflog usage examples

---

### Exercise 3.3: Safe Undo Workflow
**Objective**: Develop a safe workflow for undoing changes in team environments

**Tasks**:
1. Create a script that safely undoes changes using revert instead of reset
2. The script should:
   - Check if the branch is ahead of remote
   - Use revert for shared branches
   - Use reset only for local unshared commits
3. Test the workflow in a simulated team scenario

**Deliverable**: Bash script for safe undo operations with documentation

</details>

</details>