<details open>
<summary><b> Section 06: Branching and Merging in Git</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

### Exercise 1.1: Creating and Switching Branches
**Objective**: Learn to create branches and understand the HEAD pointer

**Tasks**:
1. Create a new directory `branching-demo` and initialize Git
2. Create and commit an initial file
3. Create a new branch called `feature-branch`
4. Verify you're on the new branch using `git branch`
5. Switch between branches and observe HEAD movement

**Commands**:
```bash
mkdir branching-demo && cd branching-demo
git init
echo "# Main Project" > README.md
git add README.md && git commit -m "Initial commit"
git branch
git branch feature-branch
git branch
git checkout feature-branch
git branch
```

**Deliverable**: Screenshot showing branch creation and switching with `git branch` output

### Exercise 1.2: Working on Separate Branches
**Objective**: Make changes on different branches without interference

**Tasks**:
1. Continue from Exercise 1.1
2. On `feature-branch`, create `feature.txt` with content "New feature implementation"
3. Commit the changes on feature branch
4. Switch back to master/main branch
5. Verify feature.txt doesn't exist on main branch
6. Create `main-update.txt` on main branch and commit

**Commands**:
```bash
echo "New feature implementation" > feature.txt
git add feature.txt && git commit -m "Add feature implementation"
git checkout master
ls  # Verify feature.txt is not here
echo "Main branch update" > main-update.txt
git add main-update.txt && git commit -m "Update on main branch"
```

**Deliverable**: Evidence of isolated work on separate branches

### Exercise 1.3: Viewing Branch Commits
**Objective**: Visualize branch structure and commit history

**Tasks**:
1. Continue from Exercise 1.2
2. Use `git log --oneline --all --graph` to visualize branches
3. Identify which commits belong to which branch
4. Document the branch structure

**Commands**:
```bash
git log --oneline --all --graph
git log --oneline master
git log --oneline feature-branch
```

**Deliverable**: Graph visualization showing branch divergence

### Exercise 2.1: Basic Merging
**Objective**: Merge a feature branch into main

**Tasks**:
1. Create a new repository `merge-demo`
2. Initialize and create files on main branch
3. Create a `bugfix` branch and fix a simulated bug
4. Merge the bugfix branch back into main
5. Verify merge commit is created

**Commands**:
```bash
mkdir merge-demo && cd merge-demo
git init
echo "Version 1.0" > version.txt
git add version.txt && git commit -m "Initial version"
git branch bugfix
git checkout bugfix
echo "Bug fixed" >> version.txt
git add version.txt && git commit -m "Fix critical bug"
git checkout master
git merge bugfix
git log --oneline
```

**Deliverable**: Successful merge with merge commit in history

### Exercise 2.2: Fast-Forward vs Merge Commits
**Objective**: Understand different merge scenarios

**Tasks**:
1. Continue in `merge-demo`
2. Create `hotfix` branch from current position
3. Make a quick fix and commit
4. Merge with fast-forward (default behavior)
5. Create `feature` branch, make changes, and merge with --no-ff

**Commands**:
```bash
git branch hotfix
git checkout hotfix
echo "Hotfix applied" > hotfix.txt
git add hotfix.txt && git commit -m "Apply hotfix"
git checkout master
git merge hotfix  # This will be fast-forward
git branch feature
git checkout feature
echo "New feature" > feature.md
git add feature.md && git commit -m "Add new feature"
git checkout master
git merge --no-ff feature
git log --oneline --graph
```

**Deliverable**: Comparison of fast-forward and merge commit scenarios

### Exercise 2.3: Deleting Branches
**Objective**: Clean up merged branches properly

**Tasks**:
1. Continue from previous exercises
2. Delete the merged `bugfix` branch using `-d`
3. Attempt to delete unmerged branch and observe error
4. Force delete unmerged branch if needed
5. Verify branch list after cleanup

**Commands**:
```bash
git branch -d bugfix
git branch -d feature  # This might fail if unmerged
git branch -D feature  # Force delete
git branch
```

**Deliverable**: Clean branch list after proper cleanup

### Exercise 3.1: Simulating and Resolving Merge Conflicts
**Objective**: Handle merge conflicts when the same file is modified on both branches

**Tasks**:
1. Create `conflict-demo` repository
2. Create `data.txt` on main with initial content
3. Create `conflict-branch` and modify `data.txt`
4. Switch to main and modify `data.txt` differently
5. Attempt merge and resolve the conflict
6. Complete the merge after resolution

**Commands**:
```bash
mkdir conflict-demo && cd conflict-demo
git init
echo "Original content" > data.txt
git add data.txt && git commit -m "Initial data"
git branch conflict-branch
git checkout conflict-branch
echo "Branch modification" >> data.txt
git add data.txt && git commit -m "Modify on conflict branch"
git checkout master
echo "Main modification" >> data.txt
git add data.txt && git commit -m "Modify on main branch"
git merge conflict-branch
# Resolve conflict manually, then:
git add data.txt
git commit -m "Resolve merge conflict"
```

**Deliverable**: Successfully resolved merge conflict with final merged file

### Exercise 3.2: Using git reset for Undo Operations
**Objective**: Practice different reset modes (soft, mixed, hard)

**Tasks**:
1. Create `reset-demo` repository with multiple commits
2. Use `git reset --soft` to undo last commit (keep changes staged)
3. Use `git reset --mixed` (default) to unstage changes
4. Use `git reset --hard` to completely undo changes
5. Document the effects of each reset mode

**Commands**:
```bash
mkdir reset-demo && cd reset-demo
git init
echo "Commit 1" > file1.txt
git add file1.txt && git commit -m "First commit"
echo "Commit 2" > file2.txt
git add file2.txt && git commit -m "Second commit"
echo "Commit 3" > file3.txt
git add file3.txt && git commit -m "Third commit"
git log --oneline
git reset --soft HEAD~1
git status
git reset --hard HEAD~1
git log --oneline
```

**Deliverable**: Demonstration of all three reset modes with before/after states

### Exercise 3.3: Using git revert for Safe Undoing
**Objective**: Undo commits safely without losing history

**Tasks**:
1. Continue from `reset-demo` or create new repository
2. Make several commits with identifiable changes
3. Use `git revert` to undo a specific commit
4. Observe that history is preserved
5. Compare `revert` vs `reset` approaches

**Commands**:
```bash
echo "Important feature" > important.txt
git add important.txt && git commit -m "Add important feature"
echo "Temporary work" > temp.txt
git add temp.txt && git commit -m "Add temporary work"
git log --oneline
git revert HEAD  # Revert the last commit
git log --oneline
cat temp.txt  # Verify file was removed
```

**Deliverable**: Revert commit showing preserved history with undo operation

</details>
</details>