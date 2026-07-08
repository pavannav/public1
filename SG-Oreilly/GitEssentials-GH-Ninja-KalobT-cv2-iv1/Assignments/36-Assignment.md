<details open>
<summary><b> Session 36: How to Stash Code</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Exercise 1.1: Understanding Git Stash Concept
**Objective**: Learn the fundamental purpose and use cases for git stash

**Tasks**:
1. Identify scenarios where stashing is most useful
2. Understand the difference between stashing and committing
3. Recognize when stashing vs committing is appropriate

**Deliverable**: Document explaining stash use cases and decision criteria for stash vs commit

---

## Exercise 1.2: Creating a Stash Branch and Making Changes
**Objective**: Set up a working scenario for practicing stash operations

**Tasks**:
1. Create a new feature branch using `git branch` command
2. Make uncommitted changes to files on the feature branch
3. Document the current state before stashing

**Commands**:
```bash
git branch stash-practice
git checkout stash-practice
# Edit README.md or any file with changes
git status
git diff
```

**Deliverable**: Screenshot showing modified files on feature branch before stashing

---

## Exercise 1.3: Executing Git Stash
**Objective**: Learn the basic stash command and its immediate effects

**Tasks**:
1. Execute `git stash` to save working directory changes
2. Verify that working directory is clean after stashing
3. List available stashes using `git stash list`

**Commands**:
```bash
git stash
git status
git stash list
```

**Deliverable**: Confirmation that working directory is clean and stash appears in stash list

---

## Exercise 2.1: Working with Stashes During Branch Switching
**Objective**: Practice the primary use case of stashing for branch switching

**Tasks**:
1. Switch to another branch after stashing
2. Make different changes on the other branch
3. Commit those changes to demonstrate clean branch switching

**Commands**:
```bash
git checkout master
# Make different changes to same file
git add README.md
git commit -m "Work on rush task"
git lg
```

**Deliverable**: Documented workflow showing successful branch switching with stashed work preserved

---

## Exercise 2.2: Applying Stashed Changes
**Objective**: Learn how to retrieve and apply stashed work

**Tasks**:
1. Switch back to the original feature branch
2. Apply the stashed changes using `git stash apply`
3. Verify the stashed changes are restored correctly

**Commands**:
```bash
git checkout stash-practice
git stash apply
git diff
git status
```

**Deliverable**: Successfully applied stashed changes with original modifications restored

---

## Exercise 2.3: Managing Stash Lifecycle
**Objective**: Practice stash management and cleanup operations

**Tasks**:
1. Understand that stashes persist after applying
2. Practice `git stash drop` to remove specific stashes
3. Verify stash list cleanup after dropping

**Commands**:
```bash
git stash list
git stash drop
git stash list
```

**Deliverable**: Clean stash list after dropping applied stashes

---

## Exercise 3.1: Multiple Stash Management
**Objective**: Work with multiple stashes and understand stash indexing

**Tasks**:
1. Create multiple stashes from different working states
2. Practice applying specific stashes by index
3. Document stash list management with multiple entries

**Commands**:
```bash
git stash  # Creates stash@{0}
# Make more changes
git stash  # Creates stash@{1}
git stash list
git stash apply stash@{1}  # Apply specific stash
```

**Deliverable**: Workflow showing management of multiple stashes with selective application

---

## Exercise 3.2: Stashing in Detached HEAD State
**Objective**: Practice stashing during exploration of historical commits

**Tasks**:
1. Checkout an earlier commit to enter detached HEAD state
2. Make experimental changes that might need preservation
3. Stash changes before returning to normal branch

**Commands**:
```bash
git checkout [earlier-commit-hash]
# Make experimental changes
git stash
git checkout stash-practice
git stash apply
```

**Deliverable**: Successfully preserved experimental changes made during detached HEAD exploration

---

## Exercise 3.3: Advanced Stash Operations and Safety
**Objective**: Master advanced stash features and safety practices

**Tasks**:
1. Research additional stash options like `git stash pop`
2. Practice stashing with untracked files using `git stash -u`
3. Document safety practices and recovery strategies for stash operations

**Commands**:
```bash
git stash pop          # Apply and drop in one command
git stash -u           # Include untracked files
git stash show         # View stash contents without applying
git stash branch       # Create new branch from stash
```

**Deliverable**: Comprehensive guide covering advanced stash operations and safety best practices

</details>
</details>