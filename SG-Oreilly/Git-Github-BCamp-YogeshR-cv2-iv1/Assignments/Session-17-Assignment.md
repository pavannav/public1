<details open>
<summary><b> Session 17: Demonstration Working with Files git rm, git mv, git diff</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Exercise 1.1: Remove Files Using git rm
**Objective**: Learn to remove files from both working directory and Git tracking
**Tasks**:
1. Create a repository with multiple text files
2. Use git rm to remove a file completely
3. Commit the deletion
4. Verify the file is removed from both places
**Commands**:
```bash
mkdir file-ops-demo && cd file-ops-demo
git init
echo "content" > notes1.txt
echo "content" > notes2.txt
git add . && git commit -m "Initial files"
git rm notes2.txt
git status  # Shows notes2.txt as deleted
git commit -m "Removed notes2.txt"
ls  # notes2.txt no longer exists
```
**Deliverable**: File removed from both filesystem and Git repository

## Exercise 1.2: Remove Files from Index Only Using --cached
**Objective**: Stop tracking files while keeping them locally
**Tasks**:
1. Create a file that's currently tracked
2. Use git rm --cached to untrack it
3. Verify file remains locally but is untracked
4. Understand difference from .gitignore
**Commands**:
```bash
echo "keep locally" > config.txt
git add config.txt && git commit -m "Add config"
git rm --cached config.txt
git status  # Shows as deleted from index
ls  # File still exists locally
git status  # Shows as untracked now
```
**Deliverable**: File untracked by Git but preserved in working directory

## Exercise 1.3: Explore git rm Help and Options
**Objective**: Understand various flags available with git rm
**Tasks**:
1. View help documentation for git rm
2. Test different flags: -f, -n, --cached
3. Document the purpose of each flag
**Commands**:
```bash
git rm --help
git rm -n notes1.txt  # Dry run, shows what would happen
git rm -f notes1.txt  # Force removal
```
**Deliverable**: Understanding of git rm command options and their use cases

## Exercise 2.1: Rename Files Using git mv
**Objective**: Learn to rename files while preserving history
**Tasks**:
1. Create a tracked file
2. Rename it using git mv
3. Check git status to see rename operation
4. Commit the rename
**Commands**:
```bash
echo "original content" > oldname.txt
git add oldname.txt && git commit -m "Add file to rename"
git mv oldname.txt newname.txt
git status  # Shows rename operation
git commit -m "Renamed oldname.txt to newname.txt"
git log --follow --oneline newname.txt  # Shows complete history
```
**Deliverable**: File renamed with history preserved through the rename

## Exercise 2.2: Move Files to Directories Using git mv
**Objective**: Organize files into directories using git mv
**Tasks**:
1. Create multiple log files in root directory
2. Create a logs directory
3. Move all .log files into the directory using git mv
4. Commit the organization changes
**Commands**:
```bash
echo "log1" > debug.log
echo "log2" > error.log
echo "log3" > system.log
git add *.log && git commit -m "Add log files"
mkdir logs
git mv *.log logs/
ls logs/  # All log files moved
git status  # Shows all files moved
git commit -m "Organized log files into logs directory"
```
**Deliverable**: Multiple files moved to directory with history tracked

## Exercise 2.3: Compare Manual vs git mv Rename
**Objective**: Understand why git mv is preferred over manual operations
**Tasks**:
1. Manually rename a file (mv command)
2. Check what git status shows
3. Manually stage the changes (git add + git rm)
4. Compare with using git mv directly
**Commands**:
```bash
echo "test" > manual.txt
git add manual.txt && git commit -m "Add for comparison"
mv manual.txt renamed.txt  # Manual rename
git status  # Shows as deleted + untracked
git add renamed.txt  # Git tracks as new file
git rm manual.txt
# Now compare with:
git mv renamed.txt proper.txt  # Single command
```
**Deliverable**: Understanding that git mv preserves file history vs manual operations

## Exercise 3.1: View Working Directory Changes with git diff
**Objective**: See uncommitted changes in working directory
**Tasks**:
1. Modify a tracked file
2. Run git diff to see changes
3. Understand the output format (+/- indicators)
4. Stage changes and run git diff again
**Commands**:
```bash
echo "Line 1" > changes.txt
git add changes.txt && git commit -m "Initial"
echo "Line 2" >> changes.txt
git diff  # Shows unstaged changes
git add changes.txt
git diff  # No output (staged)
git diff --staged  # Shows staged changes
```
**Deliverable**: Understanding of git diff output for working directory changes

## Exercise 3.2: Compare Between Commits Using git diff
**Objective**: Learn to compare changes across different commits
**Tasks**:
1. Create multiple commits with changes
2. View commit history with git log --oneline
3. Use git diff to compare two specific commits
4. Document the differences shown
**Commands**:
```bash
echo "v1" > version.txt
git add version.txt && git commit -m "Version 1"
echo "v2" >> version.txt
git commit -am "Version 2"
echo "v3" >> version.txt
git commit -am "Version 3"
git log --oneline
git diff HEAD~2 HEAD  # Compare current with 2 commits ago
git diff <commit1> <commit2>  # Compare any two commits
```
**Deliverable**: Comparison of changes between two historical commits

## Exercise 3.3: Complete File Management Workflow
**Objective**: Combine git rm, git mv, and git diff in practical scenarios
**Tasks**:
1. Create a project structure with various files
2. Rename important files using git mv
3. Remove unnecessary files using git rm
4. Review all changes with git diff before committing
5. Organize remaining files into directories
**Commands**:
```bash
# Setup
mkdir project && cd project
git init
for i in 1 2 3; do echo "file$i" > file$i.txt; done
git add . && git commit -m "Initial project files"

# Workflow
git mv file1.txt main.txt
git rm file2.txt
echo "updated" >> main.txt
git diff  # Review changes
git status
git add main.txt
git commit -m "Renamed file1 to main, removed file2, updated main"
mkdir src && git mv main.txt src/
git status
git commit -m "Moved main.txt to src directory"
```
**Deliverable**: Complete demonstration of all three commands in a realistic workflow

</details>

</details>