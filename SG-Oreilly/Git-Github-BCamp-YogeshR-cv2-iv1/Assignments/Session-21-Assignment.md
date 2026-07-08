<details open>
<summary><b> Session 21: Demonstration Branch Operations</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Exercise 1.1: View and Understand Current Branch Status
**Objective**: Learn to check existing branches and identify the current branch
**Tasks**:
1. Initialize a new repository
2. Create initial files and make commits
3. Use git branch to list all branches
4. Identify the current branch using asterisk notation
**Commands**:
```bash
mkdir branch-demo && cd branch-demo
git init
echo "initial content" > hello.txt
git add hello.txt && git commit -m "Initial commit"
git branch  # Shows: * master
```
**Deliverable**: Understanding of git branch output showing current branch with asterisk

## Exercise 1.2: Create New Branches Using git branch
**Objective**: Learn to create branches without switching to them
**Tasks**:
1. Create a branch called `feature-one`
2. Create another branch called `feature-two`
3. List all branches to confirm creation
4. Note that you're still on the original branch
**Commands**:
```bash
git branch feature-one
git branch feature-two
git branch  # Shows: feature-one, feature-two, * master
```
**Deliverable**: Multiple branches created with current branch remaining unchanged

## Exercise 1.3: Switch Between Branches Using git checkout and git switch
**Objective**: Master branch switching commands
**Tasks**:
1. Switch to feature-one using git checkout
2. Switch to feature-two using git switch
3. Return to master branch
4. Document the difference between the two commands
**Commands**:
```bash
git checkout feature-one  # Traditional way
git switch feature-two    # New beginner-friendly way
git switch master         # Return to master
```
**Deliverable**: Successful branch switching with both methods demonstrated

## Exercise 2.1: Create and Commit Files on Feature Branches
**Objective**: Understand that changes are isolated to specific branches
**Tasks**:
1. Create a file on feature-one branch
2. Commit the file on feature-one
3. Switch to master and verify file doesn't exist
4. Switch to feature-two and verify file doesn't exist
**Commands**:
```bash
git switch feature-one
echo "rook content" > rook.txt
git add rook.txt && git commit -m "Rook file added"
git switch master
ls  # rook.txt not present
git switch feature-two
ls  # rook.txt not present
```
**Deliverable**: File exists only on the branch where it was created

## Exercise 2.2: Work with Multiple Parallel Branches
**Objective**: Create different files on separate branches to demonstrate isolation
**Tasks**:
1. Create different content on feature-one and feature-two
2. Switch between branches and observe file differences
3. List all branches to see the complete picture
4. Document the independent nature of each branch
**Commands**:
```bash
git switch feature-one
echo "rook" > rook.txt && git add rook.txt && git commit -m "Added rook file"
git switch feature-two
echo "next" > next.txt && git add next.txt && git commit -m "Added next file"
git switch master
ls  # Only original files
git branch  # Shows all three branches
```
**Deliverable**: Three branches with completely different file contents

## Exercise 2.3: Understand Branch Inheritance
**Objective**: Learn that new branches start as copies of the current branch
**Tasks**:
1. Make changes on master branch
2. Create a new branch from master
3. Verify the new branch inherits the changes
4. Document the parent-child relationship
**Commands**:
```bash
echo "master update" >> hello.txt
git add hello.txt && git commit -m "Update on master"
git branch feature-three
git switch feature-three
cat hello.txt  # Shows master update
git switch master
```
**Deliverable**: New branches inherit all commits from parent branch at creation time

## Exercise 3.1: Practice Descriptive Branch Naming
**Objective**: Create branches with clear, descriptive names
**Tasks**:
1. Create branches with purpose-driven names
2. Create a home-page feature branch
3. Create an about-page feature branch
4. Document naming conventions and their benefits
**Commands**:
```bash
git branch home-page
git branch about-page
git branch user-authentication
git branch  # Shows descriptive branch names
```
**Deliverable**: Branches with clear names indicating their purpose

## Exercise 3.2: Complete Branch Workflow Simulation
**Objective**: Execute full workflow of creating, working on, and managing branches
**Tasks**:
1. Set up initial repository structure
2. Create feature branches for different tasks
3. Make unique changes on each branch
4. Switch between branches and verify isolation
5. Return to master with clean state
**Commands**:
```bash
# Setup
mkdir project && cd project
git init
echo "# Project" > README.md
git add README.md && git commit -m "Initial project"

# Feature development simulation
git branch login-feature && git switch login-feature
echo "login functionality" > login.js
git add login.js && git commit -m "Added login feature"

git switch master
git branch dashboard-feature && git switch dashboard-feature
echo "dashboard UI" > dashboard.html
git add dashboard.html && git commit -m "Added dashboard feature"

git switch master
git branch  # Shows all branches
git status  # Clean working tree on master
```
**Deliverable**: Complete demonstration of parallel feature development using branches

## Exercise 3.3: Branch Status Verification and Documentation
**Objective**: Systematically verify branch states and document findings
**Tasks**:
1. Check branch status after each major operation
2. Document which files exist on each branch
3. Verify working tree cleanliness across branches
4. Create a summary of branch isolation benefits
**Commands**:
```bash
for branch in master feature-one feature-two; do
  git switch $branch
  echo "=== Branch: $branch ==="
  git branch
  git status
  ls -la
  echo
done
git switch master
```
**Deliverable**: Comprehensive documentation of branch states and file isolation

</details>

</details>