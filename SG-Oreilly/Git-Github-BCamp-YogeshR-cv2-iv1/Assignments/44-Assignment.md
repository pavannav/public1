<details open>
<summary><b> Session 44: Git GitHub Workflow</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

### Exercise 1.1: Git Workflow Area Identification
**Objective**: Understand and identify the four main areas in the git workflow.

**Tasks**:
1. Create a diagram showing the four main git areas: Working Directory, Staging Area, Local Repository, Remote Repository
2. Document which commands move files between each area
3. List the purpose of each area in the workflow
4. Explain the flow direction between areas

**Deliverable**: Visual workflow diagram with command mappings and area explanations.

---

### Exercise 1.2: Repository Setup Commands
**Objective**: Master the initial setup commands for starting git workflows.

**Tasks**:
1. Practice `git init` for new projects with detailed explanations
2. Practice `git clone` for existing GitHub projects
3. Document the differences between initializing vs cloning
4. Create examples showing when to use each command

**Commands**:
```bash
git init
git clone https://github.com/username/repo.git
```

**Deliverable**: Setup command reference guide with use case examples.

---

### Exercise 1.3: Working Directory File Operations
**Objective**: Practice all file manipulation commands in the working directory stage.

**Tasks**:
1. Use `git add filename` to stage specific files
2. Use `git add .` to stage all modified files
3. Use `git mv` to rename files within git tracking
4. Use `git rm` to remove files from tracking
5. Use `git restore filename` to discard unwanted changes

**Commands**:
```bash
git add specific-file.txt
git add .
git mv oldname.txt newname.txt
git rm unwanted-file.txt
git restore changed-file.txt
```

**Deliverable**: Command practice log showing each operation and its effect.

---

### Exercise 2.1: Staging Area Management
**Objective**: Master staging area operations and file state management.

**Tasks**:
1. Stage multiple files and verify staging status with `git status`
2. Practice unstaging files with `git reset filename`
3. Use `git commit -a -m "message"` to skip staging step
4. Compare the effects of different staging approaches

**Commands**:
```bash
git status
git reset filename
git commit -a -m "direct commit message"
```

**Deliverable**: Staging workflow comparison showing different approaches and outcomes.

---

### Exercise 2.2: Local Repository Operations
**Objective**: Practice local repository management and history navigation.

**Tasks**:
1. Create commits with clear, descriptive messages
2. Use `git reset commit` to roll back changes
3. Compare versions using `git diff` and `git diff HEAD`
4. Practice viewing commit history and understanding the timeline

**Commands**:
```bash
git commit -m "descriptive commit message"
git reset HEAD~1
git diff
git diff HEAD
git log --oneline
```

**Deliverable**: Local repository operation guide with rollback and comparison examples.

---

### Exercise 2.3: Remote Repository Synchronization
**Objective**: Master remote repository operations for collaboration.

**Tasks**:
1. Use `git push` to upload commits to GitHub
2. Practice `git fetch` to download remote changes
3. Use `git pull` to fetch and merge remote changes
4. Document the workflow for staying synchronized with team

**Commands**:
```bash
git push origin main
git fetch origin
git pull origin main
```

**Deliverable**: Remote synchronization workflow documented with command sequences.

---

### Exercise 3.1: Complete End-to-End Workflow Simulation
**Objective**: Execute a complete workflow from initialization to remote sharing.

**Tasks**:
1. Initialize a new repository with `git init`
2. Create and modify files through the complete workflow
3. Stage, commit, and push changes to a remote repository
4. Document each step with explanations of what happens at each stage

**Commands**:
```bash
git init new-project
cd new-project
# Create files and follow complete workflow
git add . && git commit -m "initial commit"
git remote add origin https://github.com/user/repo.git
git push -u origin main
```

**Deliverable**: Complete workflow simulation log with step-by-step documentation.

---

### Exercise 3.2: Workflow Troubleshooting Scenarios
**Objective**: Handle common workflow issues and recovery situations.

**Tasks**:
1. Create scenarios where files need to be unstaged after accidental staging
2. Practice recovering from unwanted commits using reset commands
3. Handle situations where remote and local histories diverge
4. Document recovery procedures for each scenario

**Commands**:
```bash
git reset HEAD filename  # unstage file
git reset --soft HEAD~1  # undo commit keep changes
git reset --hard HEAD~1  # undo commit and changes
git fetch && git status  # check remote status
```

**Deliverable**: Troubleshooting guide with recovery procedures for common workflow issues.

---

### Exercise 3.3: Team Collaboration Workflow Design
**Objective**: Design and document efficient team collaboration workflows.

**Tasks**:
1. Create a workflow diagram showing how multiple developers interact
2. Design branching strategies that work with the git workflow areas
3. Document best practices for commit messages and staging
4. Establish protocols for handling conflicts during pull/push operations

**Deliverable**: Team collaboration workflow design document with branching strategies and conflict resolution protocols.

</details>
</details>