<details open>
<summary><b> Section 05: Working with Files - git status, add, commit, log</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

### Exercise 1.1: Understanding File States
**Objective**: Learn the four file states in Git (untracked, modified, staged, committed)

**Tasks**:
1. Create a new directory called `git-practice`
2. Initialize it as a Git repository
3. Create three new files: `readme.md`, `notes.txt`, and `todo.md`
4. Check the status of files and identify their state
5. Document which state each file is in

**Commands**:
```bash
mkdir git-practice && cd git-practice
git init
echo "Hello" > readme.md
echo "Notes" > notes.txt
echo "TODO" > todo.md
git status
```

**Deliverable**: Screenshot of `git status` output showing untracked files

### Exercise 1.2: Staging Individual Files
**Objective**: Practice using `git add` to stage specific files

**Tasks**:
1. Continue from Exercise 1.1
2. Stage only `readme.md` using `git add`
3. Verify the staging status with `git status`
4. Stage `notes.txt` and `todo.md` individually
5. Verify all files are staged

**Commands**:
```bash
git add readme.md
git status
git add notes.txt todo.md
git status
```

**Deliverable**: Screenshot showing staged files ready for commit

### Exercise 1.3: Making Your First Commit
**Objective**: Create a commit with a descriptive message

**Tasks**:
1. Continue from Exercise 1.2
2. Commit the staged files with message "Initial commit: Add project files"
3. View the commit history using `git log`
4. Note the commit hash and details

**Commands**:
```bash
git commit -m "Initial commit: Add project files"
git log
```

**Deliverable**: Screenshot of commit history showing the first commit

### Exercise 2.1: Working with Multiple Files
**Objective**: Use `git add` flags for bulk operations

**Tasks**:
1. Create a new directory `bulk-practice`
2. Initialize Git and create 5+ text files
3. Use `git add -A` to stage all files at once
4. Commit with appropriate message
5. Create 3 more files and practice `git add .`

**Commands**:
```bash
mkdir bulk-practice && cd bulk-practice
git init
touch file1.txt file2.txt file3.txt file4.txt file5.txt
git add -A
git status
git commit -m "Add initial files"
touch file6.txt file7.txt file8.txt
git add .
git status
```

**Deliverable**: Sequence of commands demonstrating bulk staging

### Exercise 2.2: Modifying and Re-staging Files
**Objective**: Understand the cycle of modify → stage → commit

**Tasks**:
1. Continue from previous exercise
2. Modify an existing committed file
3. Check status to see modified state
4. Stage the modification
5. Commit the change

**Commands**:
```bash
echo "Updated content" >> file1.txt
git status
git add file1.txt
git commit -m "Update file1.txt with new content"
git log --oneline
```

**Deliverable**: Log showing multiple commits

### Exercise 2.3: Exploring Commit Details
**Objective**: Use `git log` options to view commit information

**Tasks**:
1. Continue from previous exercises
2. Use `git log --oneline` for compact view
3. Use `git log -p` to see changes in each commit
4. Use `git log --stat` to see file statistics
5. Document the differences in output formats

**Commands**:
```bash
git log --oneline
git log -p
git log --stat
```

**Deliverable**: Comparison of different `git log` output formats

### Exercise 3.1: Complete Workflow Practice
**Objective**: Execute the full Git workflow from scratch

**Tasks**:
1. Create a new project directory
2. Initialize Git
3. Create and populate multiple files
4. Stage, commit, modify, re-stage, and commit again
5. View complete history

**Commands**:
```bash
mkdir workflow-demo && cd workflow-demo
git init
echo "# Project" > README.md
echo "1. Task one" > tasks.md
git add -A && git commit -m "Initial project setup"
echo "2. Task two" >> tasks.md
git add tasks.md && git commit -m "Add second task"
git log --oneline
```

**Deliverable**: Complete workflow demonstration with commit history

</details>
</details>