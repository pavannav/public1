<details open>
<summary><b> Session 12: Understanding .git Folder git init Command</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Exercise 1.1: Create and Initialize a New Git Repository
**Objective**: Learn to create a directory and initialize it as a Git repository
**Tasks**:
1. Create a new directory named `my-first-repo`
2. Navigate into the directory
3. Initialize it as a Git repository
4. Verify the repository was created successfully
**Commands**:
```bash
mkdir my-first-repo
cd my-first-repo
git init
ls -la
```
**Deliverable**: A directory containing a `.git` folder confirming successful initialization

## Exercise 1.2: Explore the .git Directory Structure
**Objective**: Understand the components of the .git folder
**Tasks**:
1. After initializing a repository, explore the .git directory
2. List all contents including hidden files
3. Identify key folders: hooks, objects, refs, info
4. Examine initial files: HEAD, config, description
**Commands**:
```bash
ls -la .git/
ls -la .git/hooks/
cat .git/HEAD
cat .git/config
cat .git/description
```
**Deliverable**: Documentation of the .git folder structure and initial file contents

## Exercise 1.3: Understand Repository State Before First Commit
**Objective**: Observe how Git tracks repository state before any commits
**Tasks**:
1. Create a new repository
2. Check the current branch status
3. Run the tree command to see directory structure
4. Note which directories are empty vs. populated
**Commands**:
```bash
git branch
tree .git
git status
```
**Deliverable**: Understanding that most directories are empty until commits are made

## Exercise 2.1: Configure Repository-Specific Settings
**Objective**: Learn to configure user settings at the repository level
**Tasks**:
1. Set a local user name and email for the repository
2. Verify the configuration was stored in .git/config
3. Understand the difference between local and global config
**Commands**:
```bash
git config user.name "Your Name"
git config user.email "your.email@example.com"
git config --list --local
cat .git/config
```
**Deliverable**: Repository with local configuration settings stored in .git/config

## Exercise 2.2: Examine Git Hooks Directory
**Objective**: Understand the purpose and contents of Git hooks
**Tasks**:
1. List all available hook scripts in .git/hooks/
2. Identify pre-commit, post-commit, and other hook types
3. View the content of a sample hook file
4. Understand when hooks are triggered
**Commands**:
```bash
ls -la .git/hooks/
cat .git/hooks/pre-commit.sample
cat .git/hooks/commit-msg.sample
```
**Deliverable**: Knowledge of available hooks and their trigger events

## Exercise 2.3: Understand HEAD and Refs Structure
**Objective**: Learn how Git tracks the current position using HEAD and refs
**Tasks**:
1. Examine the HEAD file content
2. Check the refs directory structure
3. Understand the relationship between HEAD and branch refs
4. Create notes about how refs/heads/ stores branch information
**Commands**:
```bash
cat .git/HEAD
ls -la .git/refs/
ls -la .git/refs/heads/
ls -la .git/refs/tags/
```
**Deliverable**: Documentation explaining HEAD pointer and refs structure

## Exercise 3.1: Repository Lifecycle Demonstration
**Objective**: Demonstrate the complete lifecycle from normal folder to Git repository
**Tasks**:
1. Create a directory with some files
2. Show it's not a Git repository (no .git folder)
3. Initialize Git and confirm .git creation
4. Demonstrate that deleting .git removes version control
**Commands**:
```bash
mkdir lifecycle-demo && cd lifecycle-demo
echo "test" > file.txt
ls -la  # No .git folder
git init
ls -la  # .git folder appears
rm -rf .git
ls -la  # Back to normal folder, no version control
```
**Deliverable**: Understanding that .git folder is essential for version control

## Exercise 3.2: Multiple Repository Creation and Comparison
**Objective**: Create multiple repositories and compare their .git structures
**Tasks**:
1. Create 3 different repositories with different names
2. Configure each with different user settings
3. Compare their .git/config files
4. Document the differences and similarities
**Commands**:
```bash
for repo in repo1 repo2 repo3; do
  mkdir $repo && cd $repo
  git init
  git config user.name "User $repo"
  git config user.email "$repo@example.com"
  cd ..
done
diff repo1/.git/config repo2/.git/config
```
**Deliverable**: Multiple repositories with documented configuration differences

## Exercise 3.3: Analyze Git Objects Directory After Initialization
**Objective**: Understand what gets stored in the objects directory
**Tasks**:
1. Initialize a new repository
2. Check the objects directory structure before any commits
3. Create and commit a file
4. Observe what changes in the objects directory
**Commands**:
```bash
mkdir objects-demo && cd objects-demo
git init
ls .git/objects/
echo "Hello Git" > test.txt
git add test.txt
git commit -m "Initial commit"
find .git/objects -type f | head -5
```
**Deliverable**: Understanding that objects directory stores compressed file contents after commits

</details>

</details>