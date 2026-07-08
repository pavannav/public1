<details open>
<summary><b> Session 34: How to Rebase</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Exercise 1.1: Understanding Git Tree Visualization
**Objective**: Learn to visualize and interpret git commit history

**Tasks**:
1. Install and configure a git log alias for better visualization
2. Compare `git log --oneline` with a custom formatted log view
3. Identify merge commits vs regular commits in the git tree

**Commands**:
```bash
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
git log --oneline
git lg
```

**Deliverable**: Document the differences between merge commits and regular commits in your repository's history

---

## Exercise 1.2: Creating a Feature Branch
**Objective**: Practice creating and working on feature branches for rebase scenarios

**Tasks**:
1. Create a new feature branch from master
2. Make a simple commit on the feature branch
3. Verify the branch is ahead of master

**Commands**:
```bash
git checkout -b feature-rebase-test
touch feature.txt
git add feature.txt
git commit -m "Add feature file for rebase practice"
git log --oneline
```

**Deliverable**: Screenshot showing your feature branch with one commit ahead of master

---

## Exercise 1.3: Understanding Rebase Basics
**Objective**: Learn the fundamental concept of rebasing

**Tasks**:
1. Switch to master branch
2. Execute a rebase operation to bring feature branch commits onto master
3. Observe how the commit tree changes

**Commands**:
```bash
git checkout master
git rebase feature-rebase-test
git lg
```

**Deliverable**: Before and after comparison of your git tree showing the linear history created by rebase

---

## Exercise 2.1: Comparing Merge vs Rebase
**Objective**: Understand the differences between merge and rebase operations

**Tasks**:
1. Create two scenarios: one using merge, one using rebase
2. Document the resulting git tree structures
3. Identify when each strategy is most appropriate

**Commands**:
```bash
# Merge scenario
git checkout -b merge-test
# ... make commits ...
git checkout master
git merge merge-test

# Rebase scenario
git checkout -b rebase-test
# ... make commits ...
git checkout master
git rebase rebase-test
```

**Deliverable**: Comparison document showing merge commit creation vs linear rebase history

---

## Exercise 2.2: Rebase Workflow in Practice
**Objective**: Practice a realistic rebase workflow with multiple commits

**Tasks**:
1. Create a feature branch with 3+ commits
2. Make additional commits on master branch
3. Rebase the feature branch onto updated master
4. Verify clean linear history

**Deliverable**: Documented workflow showing successful rebase with multiple feature commits

---

## Exercise 2.3: Rebase Safety Considerations
**Objective**: Learn safe practices when using rebase

**Tasks**:
1. Practice the "golden rule" of rebasing (never rebase shared branches)
2. Document scenarios where rebase should be avoided
3. Create a decision matrix for choosing between merge and rebase

**Deliverable**: Decision matrix document for when to use merge vs rebase

---

## Exercise 3.1: Advanced Rebase Scenarios
**Objective**: Handle complex rebase situations with multiple branches

**Tasks**:
1. Create a branching strategy with feature branches from other feature branches
2. Practice rebasing feature branches in the correct order
3. Resolve any potential conflicts during rebase

**Deliverable**: Documented advanced branching workflow with successful rebases

---

## Exercise 3.2: Rebase Interactive Mode Exploration
**Objective**: Understand interactive rebase capabilities for history cleanup

**Tasks**:
1. Research `git rebase -i` options for squashing, rewording, and reordering commits
2. Practice safely rewriting local commit history
3. Document safe use cases for interactive rebase

**Commands**:
```bash
git rebase -i HEAD~3
# Explore: pick, reword, edit, squash, fixup, exec options
```

**Deliverable**: Documentation of interactive rebase use cases and safety considerations

---

## Exercise 3.3: Team Collaboration with Rebase
**Objective**: Apply rebase strategies in team development scenarios

**Tasks**:
1. Simulate a team environment with multiple developers
2. Practice feature branch workflow with regular rebasing onto master
3. Document best practices for maintaining clean project history

**Deliverable**: Team workflow guide recommending rebase strategies for different project sizes

</details>
</details>