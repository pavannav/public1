<details open>
<summary><b> Session 13: Git Status</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Exercise 1.1: Mastering Git Status
**Objective**: Understand and practice the most frequently used Git command

**Tasks**:
1. Document all information that `git status` provides
2. Run `git status` at various stages of the workflow
3. Explain why it's recommended to run it frequently
4. Create a habit of checking status before any Git action

**Commands**:
```bash
git status
```

**Deliverable**: Written documentation of what `git status` reveals at different workflow stages

---

## Exercise 1.2: Tracking File Modifications
**Objective**: Observe how Git status reflects file changes

**Tasks**:
1. Create a new file and check status (untracked)
2. Modify an existing file and check status (modified)
3. Delete a file and check status (deleted)
4. Document the different status messages for each action

**Commands**:
```bash
# Create new file
echo "content" > new.txt
git status

# Modify existing file
echo "more content" >> existing.txt
git status

# Delete file
rm file.txt
git status
```

**Deliverable**: Screenshots showing status for new, modified, and deleted files

---

## Exercise 1.3: Understanding Status Messages
**Objective**: Interpret the detailed information in Git status output

**Tasks**:
1. Read through a complete `git status` output carefully
2. Identify and explain each section:
   - Branch status
   - Changes not staged
   - Changes to be committed
3. Document what each color/code means (green, red, etc.)

**Deliverable**: Annotated `git status` output with explanations of each section

---

## Exercise 2.1: Staging Single and Multiple Files
**Objective**: Practice different methods of staging files

**Tasks**:
1. Create 5 files with different extensions
2. Stage files one at a time using `git add filename`
3. Create 5 more files
4. Stage all at once using `git add file1 file2 file3`
5. Use `git add .` to stage remaining unstaged files

**Commands**:
```bash
git add single-file.txt
git add file1.txt file2.md file3.js
git add .
git status
```

**Deliverable**: Demonstration of various staging methods with status outputs

---

## Exercise 2.2: File Lifecycle Tracking
**Objective**: Follow a file through its entire lifecycle in Git

**Tasks**:
1. Create a file → check status (untracked)
2. Stage the file → check status (staged/new)
3. Commit the file → check status (clean)
4. Modify the file → check status (modified)
5. Stage the modification → check status (staged/modified)
6. Commit the change → check status (clean)

**Deliverable**: Complete workflow documentation with status at each stage

---

## Exercise 2.3: Status After Various Git Operations
**Objective**: Observe status changes after commits and pushes

**Tasks**:
1. Make changes and commit them
2. Check status after commit (should be clean)
3. Push changes to remote
4. Check status after push
5. Document any differences between local and remote

**Commands**:
```bash
git commit -m "Test commit"
git status
git push origin master
git status
```

**Deliverable**: Status outputs showing post-commit and post-push states

---

## Exercise 3.1: Interpreting Colors in Git Status
**Objective**: Understand the color coding in Git status output

**Tasks**:
1. Observe red text (unstaged changes)
2. Observe green text (staged changes)
3. Create scenarios that produce each color
4. Explain what each color indicates about file state

**Deliverable**: Color-coded status examples with explanations

---

## Exercise 3.2: Status with Complex Changes
**Objective**: Handle multiple file states simultaneously

**Tasks**:
1. Create scenario with:
   - New untracked files
   - Modified unstaged files
   - Modified staged files
   - Deleted files
2. Run `git status` and document all sections
3. Stage some but not all changes
4. Observe updated status

**Deliverable**: Complex status scenario documentation

---

## Exercise 3.3: Status Best Practices
**Objective**: Develop professional Git status habits

**Tasks**:
1. Create a checklist for when to run `git status`:
   - Before starting work
   - After creating/modifying files
   - Before committing
   - After committing
   - Before pushing
2. Practice following the checklist on a project
3. Document how this habit improves workflow

**Deliverable**: Personal Git status workflow checklist and usage log

</details>

</details>