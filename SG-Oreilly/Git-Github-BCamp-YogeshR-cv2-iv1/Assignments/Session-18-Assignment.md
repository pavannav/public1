<details open>
<summary><b> Session 18: Demonstration Undoing Changes git restore and git commit amend</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Exercise 1.1: Unstage Files Using git restore --staged
**Objective**: Learn to move files back from staging area without losing changes
**Tasks**:
1. Create and modify a file, then stage it
2. Use git restore --staged to unstage the file
3. Verify changes remain in working directory
4. Confirm file shows as modified but not staged
**Commands**:
```bash
mkdir undo-demo && cd undo-demo
git init
echo "initial content" > mynotes.txt
git add mynotes.txt && git commit -m "Initial commit"
echo "Hello from Thin Crook" >> mynotes.txt
git status  # Shows modified
git add mynotes.txt
git status  # Shows staged
git restore --staged mynotes.txt
git status  # Shows modified but not staged
cat mynotes.txt  # Changes still present
```
**Deliverable**: File unstaged but changes preserved in working directory

## Exercise 1.2: Discard Local Changes Using git restore
**Objective**: Learn to completely discard unwanted modifications
**Tasks**:
1. Modify a tracked file with unwanted content
2. Use git restore to discard all changes
3. Verify file returns to last committed state
4. Understand the permanent nature of this operation
**Commands**:
```bash
echo "This is extra content" >> mynotes.txt
git status  # Shows modifications
git restore mynotes.txt
git status  # Clean working tree
cat mynotes.txt  # Back to committed state only
```
**Deliverable**: File restored to last commit state, changes permanently discarded

## Exercise 1.3: Understand git restore Warning and Safety
**Objective**: Recognize when git restore permanently discards changes
**Tasks**:
1. Stage a file then make additional modifications
2. Execute git restore without flags
3. Document that both staged and unstaged changes are lost
4. Practice caution with this command
**Commands**:
```bash
echo "line 1" > test.txt
git add test.txt && git commit -m "Initial"
echo "line 2" >> test.txt
git add test.txt
echo "line 3" >> test.txt
git status  # Shows staged and unstaged changes
git restore test.txt  # Discards everything
cat test.txt  # Only shows committed state
```
**Deliverable**: Understanding that git restore without --staged discards all local changes

## Exercise 2.1: Amend Commits to Add Forgotton Files
**Objective**: Add files to the last commit using amend
**Tasks**:
1. Create and commit a single file
2. Create another file that should have been included
3. Use git commit --amend to include the forgotten file
4. Verify both files are in the same commit
**Commands**:
```bash
echo "Hello from Thin Crook" > hello.txt
git add hello.txt && git commit -m "Added hello file"
echo "Welcome to Thin Crook" > welcome.txt
git add welcome.txt
git commit --amend
# Save the commit message editor
git status  # Clean working tree
git log --oneline  # Single commit with both files
```
**Deliverable**: Single commit containing both originally intended and forgotten files

## Exercise 2.2: Amend Commits to Fix Commit Messages
**Objective**: Update commit messages without creating new commits
**Tasks**:
1. Create a commit with an incomplete message
2. Use git commit --amend -m to provide better message
3. Verify the message is updated in history
4. Confirm no new commit was created
**Commands**:
```bash
echo "content" > files.txt
git add files.txt && git commit -m "added files"
git log --oneline  # Shows poor message
git commit --amend -m "Added hello and welcome files with proper descriptions"
git log --oneline  # Message updated, same commit hash changed
```
**Deliverable**: Commit message improved without additional commit in history

## Exercise 2.3: Amend with Interactive Message Editor
**Objective**: Use the default editor when amending commits
**Tasks**:
1. Make a commit that needs both file additions and message changes
2. Run git commit --amend without -m flag
3. Edit the commit message in the opened editor
4. Save and verify the changes
**Commands**:
```bash
echo "data" > data.txt
git add data.txt && git commit -m "add data"
echo "more data" > more.txt
git add more.txt
git commit --amend
# Editor opens - modify message and save
git log --oneline -1  # Shows updated commit
```
**Deliverable**: Successfully amended commit using interactive editor

## Exercise 3.1: Complete Undo Workflow Simulation
**Objective**: Practice all undo operations in sequence
**Tasks**:
1. Create multiple files and make various changes
2. Stage some files, modify others
3. Use appropriate undo commands to fix the state
4. End with clean working tree
**Commands**:
```bash
# Setup various states
echo "file1" > file1.txt
echo "file2" > file2.txt
git add file1.txt
echo "modified" >> file1.txt
echo "extra" >> file2.txt

# Undo operations
git restore --staged file1.txt  # Unstage file1
git restore file2.txt  # Discard extra changes
git add file1.txt && git commit -m "Add file1"
git status  # Should show file2 as untracked
```
**Deliverable**: Systematic correction of various file states using appropriate commands

## Exercise 3.2: Safe Amend vs Risky Restore Decision Making
**Objective**: Choose between amend and restore based on scenario
**Tasks**:
1. Create scenarios where amend is appropriate
2. Create scenarios where restore is needed
3. Document decision criteria for each command
4. Practice both approaches correctly
**Commands**:
```bash
# Amend scenario - wrong commit message
echo "code" > code.py
git add code.py && git commit -m "temp"
git commit --amend -m "Added Python implementation"

# Restore scenario - unwanted file modification
echo "bad content" >> code.py
git restore code.py  # Discard bad changes
git status  # Clean state
```
**Deliverable**: Understanding when to use each undo mechanism appropriately

## Exercise 3.3: Git History Cleanup Best Practices
**Objective**: Maintain clean commit history using amend and restore
**Tasks**:
1. Simulate a realistic development workflow with mistakes
2. Use amend to fix immediate issues before pushing
3. Use restore to discard experimental changes
4. Document clean history result
**Commands**:
```bash
# Realistic workflow with corrections
echo "feature" > feature.txt
git add feature.txt && git commit -m "WIP"
echo "more work" >> feature.txt
git commit --amend -m "Implemented user authentication feature"

echo "debug.log" > debug.log
git restore debug.log  # Don't commit debug files

git log --oneline  # Clean, meaningful history
git status  # Clean working tree
```
**Deliverable**: Professional commit history with corrections applied before final state

</details>

</details>