<details open>
<summary><b> Session 12: How to Push to Your GitHub Repository</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Exercise 1.1: Understanding the Push Workflow
**Objective**: Document the four-step process for pushing changes to GitHub

**Tasks**:
1. List and explain the four steps: unstaged → staged → committed → pushed
2. Explain why each step is necessary
3. Create a diagram showing the workflow progression

**Deliverable**: Written explanation with diagram of the Git push workflow stages

---

## Exercise 1.2: Create New Files Using Command Line
**Objective**: Practice creating new files directly from the terminal

**Tasks**:
1. Navigate to your test repository
2. Create a new file using `echo` command
3. Create another file using a text editor (vim, nano, or other)
4. Verify both files exist with `ls -la`

**Commands**:
```bash
echo "This is content" > newfile.txt
vim another-file.txt
ls -la
```

**Deliverable**: Screenshot showing created files and their contents

---

## Exercise 1.3: Master Git Status Command
**Objective**: Develop the habit of checking repository status

**Tasks**:
1. Run `git status` before making changes
2. Create/modify a file
3. Run `git status` again to observe changes
4. Document the different status messages

**Commands**:
```bash
git status
# Make changes
git status
```

**Deliverable**: Screenshots showing before/after status outputs with explanations

---

## Exercise 2.1: Staging Files with Git Add
**Objective**: Practice the staging process for new and modified files

**Tasks**:
1. Create 3 new files with different extensions (.txt, .md, .json)
2. Check status to see them as untracked
3. Stage one file at a time using `git add filename`
4. Stage multiple files using `git add file1 file2 file3`
5. Use tab completion for filenames

**Commands**:
```bash
git add filename.txt
git add file1.txt file2.md file3.json
git status
```

**Deliverable**: Demonstration of staging individual and multiple files

---

## Exercise 2.2: Creating Meaningful Commit Messages
**Objective**: Write clear and descriptive commit messages

**Tasks**:
1. Create commits with various message styles:
   - Too brief: "update"
   - Descriptive: "Add user authentication feature"
   - Detailed: "Fix login bug where users couldn't reset passwords"
2. View commit history to compare message clarity
3. Practice the conventional commit format if desired

**Commands**:
```bash
git commit -m "Add user profile page with avatar upload"
git log --oneline
```

**Deliverable**: Commit history showing well-written messages

---

## Exercise 2.3: Complete Push Workflow
**Objective**: Execute a complete push cycle from changes to remote

**Tasks**:
1. Make changes to existing files
2. Create new files
3. Stage all changes appropriately
4. Commit with clear message
5. Push to remote with `git push -u origin master`
6. Verify changes appear on GitHub

**Commands**:
```bash
git add .
git commit -m "Complete workflow test"
git push -u origin master
```

**Deliverable**: GitHub repository showing newly pushed commits and files

---

## Exercise 3.1: Understanding Origins and Branches
**Objective**: Explore remote configuration and branch concepts

**Tasks**:
1. Use `git remote -v` to view configured remotes
2. Explain what "origin" represents
3. Understand the "master" branch concept
4. Document the relationship between local and remote branches

**Commands**:
```bash
git remote -v
git branch
git branch -a
```

**Deliverable**: Documentation explaining origins, remotes, and the master branch

---

## Exercise 3.2: Commit Size Best Practices
**Objective**: Practice creating appropriately sized commits

**Tasks**:
1. Make multiple related changes across 3-5 files
2. Create one commit with all changes together
3. Compare with splitting into smaller commits
4. Analyze commit history for clarity and reviewability

**Deliverable**: Comparison of large vs small commit approaches with recommendations

---

## Exercise 3.3: Navigating Commit History
**Objective**: Use Git history features to explore repository changes

**Tasks**:
1. Use `git log` with various options:
   - `git log --oneline`
   - `git log --graph`
   - `git log -p` (with patches)
2. Browse repository at different commit points
3. Understand how to view historical file versions

**Commands**:
```bash
git log --oneline
git log --graph --oneline --decorate
git show <commit-hash>
```

**Deliverable**: Screenshots demonstrating various log viewing options

</details>

</details>