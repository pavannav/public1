<details open>
<summary><b> Session 19: Merging Branch into Master</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Exercise 1.1: Prepare Target Branch for Merge
**Objective**: Understand the importance of updating the target branch before merging

**Tasks**:
1. Create a feature branch called `merge-practice` from master
2. Create file `merge-test.txt` with content "Testing merge workflow"
3. Commit and push this branch to origin
4. Switch back to master branch
5. Practice pulling latest changes before any merge operation

**Commands**:
```bash
git checkout master
git checkout -b merge-practice
echo "Testing merge workflow" > merge-test.txt
git add merge-test.txt
git commit -m "Add merge test file"
git push origin merge-practice
git checkout master
git pull origin master
```

**Deliverable**: Confirmation that master branch is up to date before attempting merge

## Exercise 1.2: Perform Local Merge Operation
**Objective**: Execute a successful merge of a feature branch into master

**Tasks**:
1. Ensure you are on the master branch
2. Merge the `merge-practice` branch into master
3. Observe the "fast-forward" message
4. Verify the merged file now exists in master branch
5. Check git status shows clean working directory

**Commands**:
```bash
git checkout master
git merge merge-practice
git status
ls -la merge-test.txt
```

**Deliverable**: Output showing successful merge with "1 file changed, 1 insertion" confirmation

## Exercise 1.3: Verify Merge Results
**Objective**: Confirm merge was successful at multiple levels

**Tasks**:
1. View the content of the merged file
2. Check git log to see merge history
3. Verify current branch is still master
4. List all files to confirm merged file is present

**Commands**:
```bash
cat merge-test.txt
git log --oneline -5
git branch
ls -la
```

**Deliverable**: Evidence showing the file content and commit history including the merge

## Exercise 2.1: Push Merged Changes to Remote
**Objective**: Synchronize local merge with GitHub repository

**Tasks**:
1. After successful local merge, prepare to push to remote
2. Push master branch to origin
3. Verify the merge appears on GitHub
4. Confirm the file is now visible on master branch in GitHub

**Commands**:
```bash
git push origin master
```

**Deliverable**: GitHub screenshot showing the merged file now exists on the master branch

## Exercise 2.2: Understand Merge Flow Documentation
**Objective**: Document the complete merge workflow process

**Tasks**:
1. Create a branch called `workflow-docs`
2. Create file `merge-process.md` documenting:
   - Why pull before merge is critical
   - The merge command structure
   - What fast-forward means
   - When to push after merging
3. Commit and push this documentation branch

**Commands**:
```bash
git checkout master
git checkout -b workflow-docs
cat > merge-process.md << 'EOF'
# Git Merge Process

## Pre-Merge Steps
1. Checkout target branch (master)
2. Pull latest changes: git pull origin master
3. Verify you're on correct branch

## Merge Command
git merge <source-branch>

## Post-Merge Steps
1. Verify merge success
2. Push to remote: git push origin master

## Key Concepts
- Fast-forward: No conflicts, simple pointer move
- Always update target before merging
EOF
git add merge-process.md
git commit -m "Add merge process documentation"
git push origin workflow-docs
```

**Deliverable**: Documentation branch pushed to GitHub with merge process guide

## Exercise 2.3: Multiple Branch Merge Simulation
**Objective**: Practice merging multiple feature branches sequentially

**Tasks**:
1. Create branch `feature-a` with file `feature-a.txt`
2. Create branch `feature-b` with file `feature-b.txt`
3. Merge `feature-a` into master and push
4. Merge `feature-b` into master and push
5. Verify both files exist on master

**Commands**:
```bash
git checkout master
git checkout -b feature-a
echo "Feature A implementation" > feature-a.txt
git add feature-a.txt
git commit -m "Add feature A"
git push origin feature-a
git checkout master
git pull origin master
git merge feature-a
git push origin master

git checkout -b feature-b
echo "Feature B implementation" > feature-b.txt
git add feature-b.txt
git commit -m "Add feature B"
git push origin feature-b
git checkout master
git pull origin master
git merge feature-b
git push origin master

ls feature-a.txt feature-b.txt
```

**Deliverable**: Master branch containing both feature files after sequential merges

## Exercise 3.1: Merge Conflict Prevention Strategy
**Objective**: Demonstrate best practices to avoid merge conflicts

**Tasks**:
1. Create a scenario where multiple developers work on different branches
2. Document the strategy of always pulling before merging
3. Create a checklist for safe merging practices
4. Commit this as a reference guide

**Commands**:
```bash
git checkout master
git checkout -b merge-safety
cat > merge-safety-checklist.md << 'EOF'
# Merge Safety Checklist

## Before Every Merge
- [ ] Checkout target branch
- [ ] Run: git pull origin <target-branch>
- [ ] Verify no uncommitted changes
- [ ] Confirm correct source branch name

## Merge Process
- [ ] Execute: git merge <source-branch>
- [ ] Review merge results
- [ ] Check: git status shows clean
- [ ] Verify files appear as expected

## After Merge
- [ ] Run: git push origin <target-branch>
- [ ] Verify remote updated correctly
- [ ] Delete merged branch (optional): git branch -d <branch-name>
EOF
git add merge-safety-checklist.md
git commit -m "Add merge safety checklist"
git push origin merge-safety
```

**Deliverable**: Comprehensive safety checklist committed to a documentation branch

## Exercise 3.2: Branch Cleanup After Merge
**Objective**: Practice proper branch management post-merge

**Tasks**:
1. After successful merge of a feature branch
2. Delete the local feature branch (now merged)
3. Attempt to delete the remote feature branch
4. Verify branch cleanup was successful

**Commands**:
```bash
git branch -d merge-practice
git push origin --delete merge-practice
git branch -a | grep merge-practice
```

**Deliverable**: Confirmation that merged branches have been cleaned up

## Exercise 3.3: Complete Merge Workflow Project
**Objective**: Execute a full project workflow using merge concepts

**Tasks**:
1. Create project structure with multiple feature branches
2. Implement different components on separate branches
3. Merge them systematically into master
4. Create final documentation of the complete process
5. Push everything to GitHub

**Project Structure**:
```
project/
├── README.md (master)
├── auth/ (auth-feature branch)
│   └── auth.js
├── database/ (db-feature branch)
│   └── db.js
└── ui/ (ui-feature branch)
    └── ui.js
```

**Deliverable**: Complete project demonstrating professional merge workflow with all branches merged into master

</details>
</details>