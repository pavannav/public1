<details open>
<summary><b> Session 21: Downloading Updates from GitHub</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Exercise 1.1: Basic Git Pull Operation
**Objective**: Master the fundamental `git pull` command to sync local repository with remote

**Tasks**:
1. Ensure you're on the master branch
2. Run `git pull origin master` when repository is up to date
3. Note the "Already up to date" message
4. Document what this message indicates

**Commands**:
```bash
git checkout master
git pull origin master
```

**Deliverable**: Screenshot showing the "Already up to date" message with explanation

## Exercise 1.2: Simulate Remote Changes
**Objective**: Create a scenario where remote has changes not present locally

**Tasks**:
1. Edit the README.md file directly on GitHub
2. Add markdown content including:
   - An H1 heading
   - An H2 subheading
   - Regular paragraph text
3. Commit changes directly to master branch on GitHub
4. Verify the new commit appears in GitHub's commit history

**Deliverable**: GitHub screenshot showing the new commit "Updated README.md"

## Exercise 1.3: Pull Remote Changes
**Objective**: Successfully download and integrate remote changes into local repository

**Tasks**:
1. Before pulling, check current state:
   - Run `git log --oneline -3`
   - Run `cat README.md`
   - Note you're behind by 1 commit
2. Execute `git pull origin master`
3. Observe the pull process (unpacking objects, fast-forward)
4. Verify changes after pull:
   - Check updated README.md content
   - Confirm new commit appears in local log

**Commands**:
```bash
git log --oneline -3
cat README.md
git pull origin master
cat README.md
git log --oneline -3
```

**Deliverable**: Before/after comparison showing successful pull of remote changes

## Exercise 2.1: Create Push Conflict Scenario
**Objective**: Experience the error that occurs when trying to push without pulling first

**Tasks**:
1. Make an edit directly on GitHub to a different file
2. Create a new local commit without pulling first
3. Attempt to push and observe the rejection error
4. Read and understand the error message components

**Commands**:
```bash
# Edit file on GitHub first
# Then locally:
touch empty-file.txt
git add empty-file.txt
git commit -m "Add new empty file"
git push origin master
```

**Deliverable**: Screenshot of the push rejection error with key parts highlighted

## Exercise 2.2: Resolve Push/Pull Conflict with Merge
**Objective**: Successfully resolve divergent histories through merge commit

**Tasks**:
1. When facing push rejection, follow git's suggestion
2. Run `git pull origin master`
3. Create a merge commit when prompted:
   - Use default merge message or create custom
   - If using nano: Ctrl+O to save, Enter, Ctrl+X to exit
4. Verify merge commit was created
5. Now attempt push again - should succeed

**Commands**:
```bash
git pull origin master
# Resolve merge message
git log --oneline -5
git push origin master
```

**Deliverable**: Evidence of successful merge commit creation and push

## Exercise 2.3: Analyze Merge Commit Structure
**Objective**: Understand the structure of merge commits in git history

**Tasks**:
1. Examine the merge commit details
2. Identify all parent commits in the merge
3. Trace how changes from both sources were integrated
4. Document the commit graph showing the merge point

**Commands**:
```bash
git log --oneline -10 --graph --decorate
git show HEAD  # Show merge commit details
```

**Deliverable**: Annotated commit graph showing the merge commit with both parent branches

## Exercise 3.1: HEAD Pointer Investigation
**Objective**: Understand the HEAD pointer and its significance

**Tasks**:
1. Run `git log --oneline` and identify HEAD position
2. Note how HEAD points to master branch
3. Create a simple commit and observe HEAD movement
4. Document what HEAD represents in git terminology

**Commands**:
```bash
git log --oneline -5
git commit --allow-empty -m "Test HEAD movement"
git log --oneline -5
```

**Deliverable**: Explanation document describing HEAD pointer with visual examples

## Exercise 3.2: Multiple Pull Scenarios
**Objective**: Practice different pull scenarios and edge cases

**Tasks**:
1. Create scenario 1: Pull when behind by multiple commits
2. Create scenario 2: Pull creates merge commit (both sides changed)
3. Create scenario 3: Pull with no changes needed
4. Document the output and results of each scenario

**Commands**:
```bash
# Scenario 1: Multiple remote commits
# Edit README 3 times on GitHub, then pull locally

# Scenario 2: Divergent changes
# Edit same file on GitHub and locally, then pull

# Scenario 3: No changes
git pull origin master
```

**Deliverable**: Report documenting outputs and results from all three scenarios

## Exercise 3.3: Complete Sync Workflow Documentation
**Objective**: Create a comprehensive guide for repository synchronization

**Tasks**:
1. Document the complete workflow for:
   - Checking if you're behind remote
   - Pulling changes safely
   - Handling merge conflicts during pull
   - Pushing after successful merge
2. Include troubleshooting for common error messages
3. Create decision tree for when to pull vs push

**Documentation Structure**:
```markdown
# GitHub Sync Workflow Guide

## Checking Sync Status
- [Commands to verify local vs remote state]

## Safe Pull Process
1. [Step-by-step pull procedure]

## Handling Divergent Branches
- [Merge commit creation process]

## Error Resolution
- [Common errors and solutions]

## Decision Tree
[Visual or textual decision process]
```

**Deliverable**: Complete workflow documentation committed to a documentation branch

</details>
</details>