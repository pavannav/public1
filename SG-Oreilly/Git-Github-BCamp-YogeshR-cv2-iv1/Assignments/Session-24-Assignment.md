<details open>
<summary><b> Session 24: Demonstration Resolving Merge Conflicts</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Exercise 1.1: Set Up Conflict Scenario Repository
**Objective**: Create a repository structure primed for merge conflicts
**Tasks**:
1. Create a new directory and initialize Git
2. Create a merge.txt file with initial content
3. Make initial commit on master branch
4. Organize any existing files into folders if desired
**Commands**:
```bash
mkdir conflict-demo && cd conflict-demo
git init
echo "This is the first merge" > merge.txt
git add merge.txt && git commit -m "Merge txt file added"
git branch
```
**Deliverable**: Repository ready for merge conflict demonstration

## Exercise 1.2: Create Feature Branch with Divergent Changes
**Objective**: Create a feature branch and make changes to the same file
**Tasks**:
1. Create feature branch using git checkout -b
2. Modify merge.txt to add feature-specific content
3. Commit changes using -am flag combination
4. Verify branch and changes
**Commands**:
```bash
git checkout -b feature
echo "This content is added via the feature branch" >> merge.txt
git commit -am "Merge txt file modified"
cat merge.txt
git branch
```
**Deliverable**: Feature branch with unique changes to merge.txt

## Exercise 1.3: Create Conflicting Changes on Master
**Objective**: Make different changes to the same file on master branch
**Tasks**:
1. Switch back to master branch
2. Make different modifications to merge.txt
3. Commit the master branch changes
4. Compare histories of both branches
**Commands**:
```bash
git switch master
echo "This change is done via the master branch" >> merge.txt
git commit -am "Merge txt file modified via master branch"
git log --oneline
git switch feature
git log --oneline
```
**Deliverable**: Both branches have different modifications to merge.txt

## Exercise 2.1: Trigger and Analyze Merge Conflict
**Objective**: Attempt merge and examine the conflict markers
**Tasks**:
1. Switch to master and attempt to merge feature
2. Observe the conflict message from Git
3. Examine conflict markers in the file
4. Understand HEAD vs feature sections
**Commands**:
```bash
git switch master
git merge feature
# Git shows: "CONFLICT (content): Merge conflict in merge.txt"
cat merge.txt
# Shows markers: <<<<<<< HEAD, =======, >>>>>>> feature
```
**Deliverable**: Active merge conflict with clear markers visible

## Exercise 2.2: Manually Resolve Merge Conflict
**Objective**: Edit the conflicted file to resolve the merge
**Tasks**:
1. Open merge.txt and decide on resolution strategy
2. Remove conflict markers while keeping desired content
3. Choose to keep both changes, one branch's changes, or combine
4. Save the resolved file
**Commands**:
```bash
# Edit merge.txt to resolve conflict
# Example resolution - keeping both changes:
cat > merge.txt << EOF
This is the first merge
This content is added via the feature branch
This change is done via the master branch
EOF
cat merge.txt
```
**Deliverable**: Conflict markers removed, file contains resolved content

## Exercise 2.3: Complete Merge Resolution
**Objective**: Stage resolved file and complete the merge
**Tasks**:
1. Check git status to see resolution state
2. Add and commit the resolved merge
3. Verify clean working tree
4. Examine final commit history
**Commands**:
```bash
git status  # Shows merge.txt as modified
git commit -am "Merge conflict resolved"
git status  # Working tree clean
git log --oneline -5
```
**Deliverable**: Merge successfully completed with conflict resolved

## Exercise 3.1: Practice Different Conflict Resolution Strategies
**Objective**: Resolve conflicts using different approaches
**Tasks**:
1. Create a new scenario with multiple conflicts
2. Resolve by keeping only master changes
3. Create another scenario and resolve by keeping only feature changes
4. Document each resolution strategy
**Commands**:
```bash
# Scenario 1: Keep only master
git checkout -b test-master
# Make changes, switch to master, make different changes
git merge test-master
# Resolve by keeping only HEAD section

# Scenario 2: Keep only feature
git checkout -b test-feature
# Similar process, keep only feature section
```
**Deliverable**: Experience with multiple resolution approaches

## Exercise 3.2: Use git merge --abort for Emergency Recovery
**Objective**: Learn to safely abort a problematic merge
**Tasks**:
1. Start a merge that creates conflicts
2. Decide the merge is too complex to resolve
3. Use git merge --abort to cancel
4. Verify repository returns to pre-merge state
**Commands**:
```bash
git merge feature
# After seeing complex conflicts:
git merge --abort
git status  # Should show clean state
git log --oneline  # No merge commit created
```
**Deliverable**: Understanding of merge abort functionality

## Exercise 3.3: Advanced Conflict Resolution Workflow
**Objective**: Handle complex merge scenarios with multiple files
**Tasks**:
1. Create multiple files with potential conflicts
2. Make changes on both branches to different files
3. Create conflicts in multiple files simultaneously
4. Resolve all conflicts and complete merge
**Commands**:
```bash
# Create additional conflict scenarios
echo "config1" > config.txt
git add config.txt && git commit -m "Add config"
git checkout -b multi-conflict
echo "feature config" >> config.txt
git commit -am "Modify config on feature"
git switch master
echo "master config" >> config.txt
git commit -am "Modify config on master"
git merge multi-conflict
# Resolve conflicts in merge.txt and config.txt
```
**Deliverable**: Complex merge with multiple file conflicts successfully resolved

</details>

</details>