<details open>
<summary><b> Session 23: Checkout Code Time Travel</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Exercise 1.1: Navigate Git History Using Commit Hashes
**Objective**: Master checking out specific commits using commit hash IDs

**Tasks**:
1. View commit history and identify commit hashes
2. Check GitHub commits page to find hash IDs
3. Copy a commit hash from an older commit
4. Use `git checkout <hash>` to travel to that point in time
5. Document the "detached HEAD state" warning message

**Commands**:
```bash
git log --oneline
# Copy a commit hash (first 7+ characters)
git checkout abc1234
```

**Deliverable**: Screenshot showing checkout to specific commit with detached HEAD warning

## Exercise 1.2: Explore Repository at Different Points in Time
**Objective**: Understand how files and history change at different commits

**Tasks**:
1. Checkout the initial commit of your repository
2. List files with `ls -la` to see original state
3. Check `git log` to see limited history
4. Note the detached HEAD state
5. Checkout another intermediate commit
6. Compare files present at different points in time

**Commands**:
```bash
git checkout <initial-commit-hash>
ls -la
git log --oneline
git checkout <another-hash>
ls -la
git status
```

**Deliverable**: Documentation showing file differences between commits visited

## Exercise 1.3: Return from Detached HEAD State
**Objective**: Safely exit detached HEAD state without losing work

**Tasks**:
1. While in detached HEAD state, attempt to understand limitations
2. Try to checkout master branch to return
3. Verify HEAD is now attached to master
4. Document the process of returning to current time

**Commands**:
```bash
git checkout master
git log --oneline -3
git status
```

**Deliverable**: Confirmation of successful return to attached HEAD state

## Exercise 2.1: Create Branch from Historical Commit
**Objective**: Branch off from any point in repository history

**Tasks**:
1. Checkout a commit from early in your repository history
2. Create a new branch from this commit using `git checkout -b`
3. Name it something descriptive like `historical-exploration`
4. Make a new file on this branch
5. Commit the changes

**Commands**:
```bash
git checkout <old-commit-hash>
git checkout -b time-travel-branch
touch historical-file.txt
echo "Created from historical commit" > historical-file.txt
git add historical-file.txt
git commit -m "Add file from historical exploration"
```

**Deliverable**: New branch created from historical commit with unique files

## Exercise 2.2: Push Historical Branch to Remote
**Objective**: Share time-travel branches with the remote repository

**Tasks**:
1. Attempt to push the historical branch (avoid typing master by mistake)
2. Push to the correct branch name
3. Verify the branch appears on GitHub with limited files
4. Check that the branch only contains files from that historical point

**Commands**:
```bash
git push origin time-travel-branch
```

**Deliverable**: GitHub showing the new historical branch with corresponding files

## Exercise 2.3: Merge Time-Travel Branch into Master
**Objective**: Bring historical changes forward to current time

**Tasks**:
1. Checkout master branch
2. Merge the time-travel branch into master
3. Handle merge commit message if prompted
4. Verify merge was successful
5. Push master to remote

**Commands**:
```bash
git checkout master
git merge time-travel-branch
# Handle merge message if using nano: Ctrl+O, Enter, Ctrl+X
git log --oneline -5
git push origin master
```

**Deliverable**: Master branch now containing the merged historical changes

## Exercise 3.1: Practical Time Travel Use Case
**Objective**: Demonstrate real-world application of checking out historical commits

**Tasks**:
1. Identify a commit where a significant change was made
2. Checkout that commit to explore the previous implementation
3. Document what the code looked like before the change
4. Return to master without making any changes
5. Write a summary of what you learned from the exploration

**Commands**:
```bash
git log --oneline --all
git checkout <significant-commit>
# Explore the codebase at this point
git checkout master
```

**Deliverable**: Written analysis of code changes discovered through time travel

## Exercise 3.2: Multiple Time Travel Explorations
**Objective**: Practice visiting multiple points in history systematically

**Tasks**:
1. Create a script to checkout and explore multiple commits
2. Document findings from each commit explored
3. Visit at least 5 different commits in your history
4. Compare file structures and content across time
5. Compile findings into a historical analysis document

**Commands**:
```bash
#!/bin/bash
for commit in $(git log --oneline | head -5 | cut -d' ' -f1); do
  echo "=== Exploring commit: $commit ==="
  git checkout $commit
  ls -la
  echo ""
done
git checkout master
```

**Deliverable**: Historical analysis document with findings from multiple commits

## Exercise 3.3: Create Alternative History Scenario
**Objective**: Demonstrate how to create parallel development from historical points

**Tasks**:
1. Choose a commit from your history as a "fork point"
2. Create a branch from this commit called `alternative-history`
3. Make substantial changes representing "what if" scenarios
4. Document the divergence from current master
5. Push this branch showing an alternative development path

**Scenario Ideas**:
- What if a different approach was taken for a feature?
- What if certain files were structured differently?
- What would an older version look like with modern practices?

**Deliverable**: Alternative history branch demonstrating parallel development possibilities

</details>
</details>