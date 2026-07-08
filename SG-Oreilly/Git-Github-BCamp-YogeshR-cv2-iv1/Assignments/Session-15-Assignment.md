<details open>
<summary><b> Session 15: Demonstration Tracking Untracking Files git status, add, commit, log</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Exercise 1.1: Initialize Repository and Check Initial Status
**Objective**: Create a Git repository and understand the initial state
**Tasks**:
1. Create a new directory called `tracking-demo`
2. Initialize it as a Git repository
3. Run git status to see the initial state
4. Note the branch name and commit status
**Commands**:
```bash
mkdir tracking-demo && cd tracking-demo
git init
git status
```
**Deliverable**: Repository showing "On branch master, No commits yet" message

## Exercise 1.2: Create Files and Observe Untracked State
**Objective**: Create files and observe how Git identifies untracked files
**Tasks**:
1. Create a file called `notes.txt` with content
2. Run git status to see untracked files
3. Create two more files: `notes1.txt` and `notes2.txt`
4. Run git status to see all untracked files listed together
**Commands**:
```bash
echo "$(date): Today" > notes.txt
git status
echo "This is file one" > notes1.txt
echo "This is file two" > notes2.txt
git status
```
**Deliverable**: Git status showing all three files as "Untracked files"

## Exercise 1.3: Stage Individual Files Using git add
**Objective**: Learn to stage files individually using git add
**Tasks**:
1. Stage only `notes.txt` using git add
2. Run git status to see the staged file
3. Stage `notes1.txt` and `notes2.txt` together
4. Confirm all files are now staged
**Commands**:
```bash
git add notes.txt
git status
git add notes1.txt notes2.txt
git status
```
**Deliverable**: Git status showing all files under "Changes to be committed"

## Exercise 2.1: Use git add with Different Flags
**Objective**: Master the different flags for git add command
**Tasks**:
1. Create a new directory with multiple file types
2. Use `git add -A` to stage all changes
3. Create new files and use `git add .` to stage them
4. Modify existing files and use `git add -u` to stage modifications
**Commands**:
```bash
mkdir add-flags-demo && cd add-flags-demo
git init
echo "initial" > existing.txt
git add -A && git commit -m "Initial commit"
echo "modified" >> existing.txt
echo "new file" > new.txt
git add -u  # Stages only modifications
git status
git add .   # Stages new files and modifications
git status
```
**Deliverable**: Understanding of -A, -u, and . flags for different staging scenarios

## Exercise 2.2: Create Commits with Messages
**Objective**: Learn to commit staged changes with descriptive messages
**Tasks**:
1. Stage multiple files and commit with a message
2. Create a commit using the -m flag with proper message
3. Verify the commit was recorded
**Commands**:
```bash
git commit -m "Added notes files with project documentation"
git log --oneline
```
**Deliverable**: Commit created with message "Added notes files with project documentation"

## Exercise 2.3: Explore Repository Structure After Commits
**Objective**: Understand how commits populate the .git directory
**Tasks**:
1. Navigate to the .git directory
2. Run tree command to see the structure
3. Note the contents of objects, refs, and logs directories
4. Compare with pre-commit state
**Commands**:
```bash
cd .git
tree
ls -la objects/
ls -la refs/heads/
cat logs/HEAD
```
**Deliverable**: Documentation showing populated objects, refs, and logs after commits

## Exercise 3.1: View and Analyze Commit History
**Objective**: Use git log to examine commit details
**Tasks**:
1. Run git log to see full commit history
2. Identify commit hash, author, date, and message
3. Use git log --oneline for concise view
4. Create multiple commits and observe the history grow
**Commands**:
```bash
git log
git log --oneline
echo "More content" >> notes.txt
git add notes.txt
git commit -m "Updated notes with additional content"
git log --oneline
```
**Deliverable**: Commit history showing multiple commits with their details

## Exercise 3.2: Complete Git Workflow Simulation
**Objective**: Execute the complete workflow: status → add → commit → log
**Tasks**:
1. Check status of working directory
2. Create and modify several files
3. Stage all changes appropriately
4. Commit with descriptive message
5. View the commit in history
**Commands**:
```bash
git status
echo "New feature implementation" > feature.txt
echo "Bug fix notes" > bugfix.txt
git add feature.txt bugfix.txt
git status
git commit -m "Implemented new feature and documented bug fixes"
git log --oneline -3
```
**Deliverable**: Complete workflow executed with files tracked through all Git states

## Exercise 3.3: File Lifecycle State Transitions
**Objective**: Demonstrate all four file states in Git lifecycle
**Tasks**:
1. Create a new file (untracked state)
2. Stage the file (staged state)
3. Commit the file (committed state)
4. Modify the committed file (modified state)
5. Document each state transition with git status
**Commands**:
```bash
# Untracked state
echo "test content" > lifecycle.txt
git status  # Shows as untracked

# Staged state
git add lifecycle.txt
git status  # Shows as new file to be committed

# Committed state
git commit -m "Add lifecycle demo file"
git status  # Shows clean working tree

# Modified state
echo "modified content" >> lifecycle.txt
git status  # Shows as modified
```
**Deliverable**: Clear demonstration of untracked → staged → committed → modified state transitions

</details>

</details>