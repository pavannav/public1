<details open>
<summary><b> Session 18: Committing to a New Branch</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Exercise 1.1: Create and Navigate Between Branches
**Objective**: Master branch creation and navigation commands

**Tasks**:
1. Create a new branch called `feature-test` using `git checkout -b`
2. Verify you are on the new branch using `git branch`
3. Switch back to the `master` branch
4. Create another branch called `bug-fix`
5. List all branches to confirm both exist locally

**Commands**:
```bash
git checkout -b feature-test
git branch
git checkout master
git checkout -b bug-fix
git branch
```

**Deliverable**: Screenshot showing all local branches with asterisks indicating current branch

## Exercise 1.2: Create and Stage Files on a Branch
**Objective**: Understand that files created on a branch are isolated from master

**Tasks**:
1. Checkout the `feature-test` branch
2. Create a new file `feature-notes.txt` with content describing a feature idea
3. Create another file `test-config.json` with sample JSON content
4. Run `git status` to see untracked files
5. Run `ls -la` to verify files exist locally

**Commands**:
```bash
git checkout feature-test
echo "New feature: Dark mode toggle" > feature-notes.txt
echo '{"feature": "dark-mode", "status": "in-progress"}' > test-config.json
git status
ls -la
```

**Deliverable**: Output of `git status` showing both new files as untracked

## Exercise 1.3: Commit Changes on a Branch
**Objective**: Practice the staging and committing workflow on a feature branch

**Tasks**:
1. Stage both new files using `git add`
2. Commit the changes with message "Add feature notes and test config"
3. Verify working directory is clean with `git status`
4. View commit history with `git log --oneline -3`

**Commands**:
```bash
git add feature-notes.txt test-config.json
git commit -m "Add feature notes and test config"
git status
git log --oneline -3
```

**Deliverable**: Commit hash and message showing successful commit on feature branch

## Exercise 2.1: Push Branch to Remote Repository
**Objective**: Push a local branch to GitHub and understand branch-specific pushes

**Tasks**:
1. Attempt to push to master branch (should show "everything up to date")
2. Push the `feature-test` branch to origin using correct branch name
3. Verify push was successful

**Commands**:
```bash
git push origin master
git push origin feature-test
```

**Deliverable**: GitHub repository showing the new `feature-test` branch

## Exercise 2.2: Verify Branch Isolation on GitHub
**Objective**: Confirm branch contents are separate on the remote repository

**Tasks**:
1. View the `master` branch on GitHub - verify `feature-notes.txt` is NOT present
2. Switch to `feature-test` branch on GitHub
3. Confirm both new files are visible in the branch
4. Note the 404 error when trying to access files on wrong branch

**Commands**:
```bash
git checkout master
ls  # feature-notes.txt should not exist
git checkout feature-test
ls  # Both files should be present
```

**Deliverable**: GitHub screenshots showing files exist only on correct branch

## Exercise 2.3: Create Multiple Feature Branches
**Objective**: Practice creating multiple independent branches for different features

**Tasks**:
1. Create branch `docs-update` from master
2. Create a file `CHANGELOG.md` documenting changes
3. Commit and push the `docs-update` branch
4. Create branch `ui-improvements`
5. Create file `styles.css` with basic CSS
6. Commit and push this branch

**Commands**:
```bash
git checkout master
git checkout -b docs-update
echo "# Changelog\n\n## v1.0.0\n- Initial release" > CHANGELOG.md
git add CHANGELOG.md
git commit -m "Add initial changelog"
git push origin docs-update
git checkout -b ui-improvements
echo "body { font-family: Arial; }" > styles.css
git add styles.css
git commit -m "Add base styles"
git push origin ui-improvements
```

**Deliverable**: GitHub showing 3 separate branches (master, feature-test, docs-update, ui-improvements) with unique files

## Exercise 3.1: Branch Workflow Simulation
**Objective**: Simulate a real development workflow with feature branches

**Tasks**:
1. Create branch `hotfix-security`
2. Create file `security-patch.md` with security update notes
3. Stage, commit, and push the branch
4. Demonstrate that master branch remains unaffected

**Commands**:
```bash
git checkout master
git checkout -b hotfix-security
echo "## Security Update\n\n- Fixed XSS vulnerability" > security-patch.md
git add security-patch.md
git commit -m "Add security hotfix documentation"
git push origin hotfix-security
git checkout master
ls security-patch.md  # Should not exist
```

**Deliverable**: Documentation showing feature development without affecting stable master branch

## Exercise 3.2: Branch Status Verification
**Objective**: Verify branch state and understand branch tracking

**Tasks**:
1. Switch between all created branches
2. Check `git status` on each branch
3. Use `git branch -a` to list all branches including remote
4. Create a summary of which files exist on which branches

**Commands**:
```bash
git branch -a
for branch in master feature-test docs-update ui-improvements hotfix-security; do
  git checkout $branch
  echo "=== Branch: $branch ==="
  ls *.txt *.json *.md *.css 2>/dev/null || echo "No tracked files"
done
```

**Deliverable**: Report showing file distribution across branches

## Exercise 3.3: Branch Best Practices Documentation
**Objective**: Document understanding of branching workflow

**Tasks**:
1. Create a file `branching-workflow.md` with:
   - When to create feature branches
   - Branch naming conventions
   - Commit message best practices for branches
   - Benefits of branch isolation
2. Commit this to a new branch called `docs-branching-guide`

**Content Structure**:
```markdown
# Git Branching Workflow Guide

## When to Branch
- [List scenarios from the lesson]

## Branch Naming
- [Recommended conventions]

## Key Commands Reference
- [All commands used in this session]

## Branch Isolation Benefits
- [Understanding from transcript]
```

**Deliverable**: Comprehensive documentation committed to a dedicated branch

</details>
</details>