<details open>
<summary><b> Session 15: Undeleting a File</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Exercise 1.1: Understanding File Recovery
**Objective**: Learn how Git can recover accidentally deleted files

**Tasks**:
1. Document the difference between regular file deletion and Git-aware deletion
2. Explain why files deleted with `rm` from command line don't go to trash
3. Understand that Git stores file history in commits
4. List scenarios where file recovery would be necessary

**Deliverable**: Written explanation of Git's file recovery capabilities

---

## Exercise 1.2: Basic File Recovery with Git Checkout
**Objective**: Practice recovering a deleted file using Git

**Tasks**:
1. Create a file with important content
2. Stage and commit the file
3. Delete the file using `rm`
4. Verify the file is deleted with `ls -la`
5. Recover the file using `git checkout -- filename`
6. Verify the file has been restored

**Commands**:
```bash
echo "Important content" > important.txt
git add important.txt
git commit -m "Add important file"
rm important.txt
ls -la
git checkout -- important.txt
ls -la
cat important.txt
```

**Deliverable**: Step-by-step demonstration of file recovery

---

## Exercise 1.3: The Checkout Syntax
**Objective**: Master the `git checkout -- filename` syntax

**Tasks**:
1. Practice the double-dash syntax: `git checkout -- filename`
2. Understand what the `--` represents
3. Try variations with multiple files
4. Document any errors and their resolutions

**Commands**:
```bash
git checkout -- file1.txt file2.txt file3.txt
git checkout -- *.txt
```

**Deliverable**: Documentation of checkout syntax with examples

---

## Exercise 2.1: Recovery from Different Commit States
**Objective**: Recover files from various commit histories

**Tasks**:
1. Create a file and make multiple commits modifying it
2. Delete the file
3. Recover the file and verify which version is restored
4. Understand that recovery restores the last committed version

**Commands**:
```bash
# Create version history
echo "Version 1" > versioned.txt
git add versioned.txt && git commit -m "v1"
echo "Version 2" >> versioned.txt
git add versioned.txt && git commit -m "v2"
rm versioned.txt
git checkout -- versioned.txt
cat versioned.txt  # Should show Version 2
```

**Deliverable**: Demonstration showing recovery restores last committed state

---

## Exercise 2.2: Local Repository Without Remote
**Objective**: Use Git locally without GitHub/GitLab/Bitbucket

**Tasks**:
1. Initialize a new Git repository locally: `git init`
2. Create and modify files with commits
3. Practice deleting and recovering files
4. Document that Git works independently of remote services

**Commands**:
```bash
mkdir local-test
cd local-test
git init
# Create, delete, and recover files
```

**Deliverable**: Working local Git repository demonstrating file recovery

---

## Exercise 2.3: Selective File Recovery
**Objective**: Recover specific files while leaving others deleted

**Tasks**:
1. Create multiple files and commit them
2. Delete several files
3. Selectively recover only some of the deleted files
4. Verify that other files remain deleted

**Commands**:
```bash
# Create files
touch file1.txt file2.txt file3.txt
git add . && git commit -m "Add files"
# Delete all
rm *.txt
# Recover only file1 and file2
git checkout -- file1.txt file2.txt
ls -la  # Should show file1.txt and file2.txt only
```

**Deliverable**: Demonstration of selective file recovery

---

## Exercise 3.1: Understanding Checkout's Multiple Uses
**Objective**: Learn about checkout's various functions

**Tasks**:
1. Document that checkout has multiple purposes
2. Current use: discarding changes/recovering files
3. Note that other uses will be covered later
4. Create a mental note about checkout's versatility

**Deliverable**: Documentation about checkout command versatility

---

## Exercise 3.2: Recovery Workflow Documentation
**Objective**: Create a personal recovery procedure guide

**Tasks**:
1. Document the complete recovery workflow:
   - Identify deleted file
   - Check if it was previously committed
   - Use `git checkout -- filename`
   - Verify recovery
2. Create quick-reference card for recovery commands
3. Practice the workflow until automatic

**Deliverable**: Personal recovery procedure guide and quick-reference

---

## Exercise 3.3: Edge Cases and Limitations
**Objective**: Understand when file recovery won't work

**Tasks**:
1. Try to recover a file that was never committed
2. Document the error message
3. Test recovery of files deleted before any commits
4. Create guidelines for when recovery is/isn't possible

**Commands**:
```bash
echo "never committed" > untracked.txt
rm untracked.txt
git checkout -- untracked.txt
# Should show error: did not match any file(s) known to git
```

**Deliverable**: Documentation of recovery limitations and error handling

</details>

</details>