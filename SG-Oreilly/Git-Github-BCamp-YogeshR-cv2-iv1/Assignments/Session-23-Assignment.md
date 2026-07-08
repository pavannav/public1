<details open>
<summary><b> Session 23: Demonstration Merging Branches</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Exercise 1.1: Prepare Repository with Feature Branches
**Objective**: Set up a repository with unmerged feature branches for merging practice
**Tasks**:
1. Create a repository with initial commits on master
2. Create feature-one branch with new file rook.txt
3. Create feature-two branch with new file next.txt
4. Verify branches exist using git branch
**Commands**:
```bash
mkdir merge-demo && cd merge-demo
git init
echo "initial" > hello.txt && git add hello.txt && git commit -m "Initial commit"
git branch feature-one && git switch feature-one
echo "rook content" > rook.txt && git add rook.txt && git commit -m "Rook file added"
git switch master
git branch feature-two && git switch feature-two
echo "next content" > next.txt && git add next.txt && git commit -m "Next file added"
git switch master
git branch
```
**Deliverable**: Repository with master, feature-one, and feature-two branches

## Exercise 1.2: Perform Fast-Forward Merge
**Objective**: Execute a fast-forward merge when main branch hasn't changed
**Tasks**:
1. Verify current commit history on master
2. Merge feature-one into master
3. Confirm fast-forward merge message
4. Check updated commit history
**Commands**:
```bash
git log --oneline
git merge feature-one
# Git responds: "Updating... Fast-forward"
git log --oneline  # Shows rook.txt commit now in master
ls  # rook.txt now exists on master
```
**Deliverable**: Successful fast-forward merge with linear commit history

## Exercise 1.3: Create Divergence for Three-Way Merge
**Objective**: Make changes on both branches to create divergence for three-way merge
**Tasks**:
1. Create and commit a new file on master (threeway.txt)
2. Switch to feature-two and verify it doesn't have the new file
3. Document the divergence between branches
**Commands**:
```bash
echo "three way content" > threeway.txt
git add threeway.txt && git commit -m "Added threeway.txt file"
git switch feature-two
ls  # threeway.txt not present, next.txt exists
git switch master
```
**Deliverable**: Both branches have unique commits showing divergence

## Exercise 2.1: Execute Three-Way Merge
**Objective**: Perform a three-way merge when branches have diverged
**Tasks**:
1. Attempt to merge feature-two into master
2. Provide merge commit message when editor opens
3. Verify merge commit creation
4. Analyze the merge commit structure
**Commands**:
```bash
git merge feature-two
# Editor opens - write: "Perform three way merge"
git log --oneline  # Shows merge commit with two parents
git log --oneline -3
```
**Deliverable**: Three-way merge completed with merge commit having two parents

## Exercise 2.2: Analyze Merge Commit Details
**Objective**: Understand the structure of merge commits
**Tasks**:
1. Examine merge commit using git log with parents
2. Identify the merge strategy used
3. Document parent commits of the merge
4. Verify files from both branches are present
**Commands**:
```bash
git log --oneline --parents -1
# Shows commit with two parent hashes
git show --stat HEAD  # Shows files merged
ls  # Should show: hello.txt, rook.txt, threeway.txt, next.txt
```
**Deliverable**: Understanding of merge commit structure and merged content

## Exercise 2.3: Verify Branch Contents After Merging
**Objective**: Confirm all changes are properly integrated after merge
**Tasks**:
1. Check that all files from both branches exist on master
2. Verify commit history includes all commits
3. Document the final state of the merged repository
**Commands**:
```bash
git switch master
ls -la  # All files present
git log --oneline  # Complete history with merge commit
cat rook.txt next.txt threeway.txt
```
**Deliverable**: Repository successfully merged with all content integrated

## Exercise 3.1: Delete Merged Branches
**Objective**: Learn proper cleanup after branch merging
**Tasks**:
1. List current branches
2. Delete feature-one using git branch -d
3. Delete feature-two using git branch -d
4. Verify only master branch remains
**Commands**:
```bash
git branch
git branch -d feature-one
git branch -d feature-two
git branch  # Only master remains
```
**Deliverable**: Merged branches deleted, repository cleaned up

## Exercise 3.2: Understand Branch Deletion Safety
**Objective**: Learn warnings when attempting to delete unmerged branches
**Tasks**:
1. Create a new unmerged branch
2. Attempt to delete it and observe warning
3. Document the safety mechanism
**Commands**:
```bash
git branch safety-test
echo "unmerged content" > safety.txt
git add safety.txt && git commit -m "Safety test commit"
git switch master
git branch -d safety-test
# Git warns: "The branch 'safety-test' is not fully merged"
```
**Deliverable**: Understanding of Git's safety mechanism for branch deletion

## Exercise 3.3: Complete Merge Workflow Documentation
**Objective**: Document the entire merge workflow from creation to cleanup
**Tasks**:
1. Create a summary document of the merge process
2. Note the differences between fast-forward and three-way merges
3. Document branch deletion best practices
4. Include commands used at each step
**Commands**:
```bash
git log --oneline --graph --all
# Shows visual merge history
echo "# Merge Workflow Summary" > MERGE_WORKFLOW.md
# Document the complete process
```
**Deliverable**: Comprehensive documentation of merge workflow and best practices

</details>

</details>