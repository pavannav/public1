<details open>
<summary><b> Session 45: Demonstration - Project Walkthrough with Git & GitHub</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

### Exercise 1.1: Project Environment Setup
**Objective**: Set up a development environment matching the demonstration requirements.

**Tasks**:
1. Install VS Code (or preferred IDE) with Git integration
2. Create a simple HTML/CSS landing page project structure
3. Include logo placeholder, navigation bar (Home, Courses, About, Contact), and basic content sections
4. Verify the project is not yet a git repository using `git status`

**Deliverable**: Working directory with untracked HTML/CSS files ready for git initialization.

---

### Exercise 1.2: Git Repository Initialization
**Objective**: Initialize git tracking and understand the initial state.

**Tasks**:
1. Run `git init` to initialize git in the project folder
2. Verify the creation of hidden `.git` directory
3. Check `git status` to confirm untracked files and master branch
4. Observe VS Code git integration showing green files with "U" indicator

**Commands**:
```bash
git init
git status
ls -la  # verify .git directory
```

**Deliverable**: Initialized git repository with documented initial status output.

---

### Exercise 1.3: Initial File Staging and Commit
**Objective**: Practice staging all project files and creating the first commit.

**Tasks**:
1. Stage all files using `git add .`
2. Verify staging with `git status` showing ready-to-commit state
3. Create initial commit with descriptive message
4. View commit history using `git log --oneline`

**Commands**:
```bash
git add .
git status
git commit -m "initial commit"
git log --oneline
```

**Deliverable**: First commit created with complete history log showing initial commit.

---

### Exercise 2.1: GitHub Repository Creation and Connection
**Objective**: Create a remote GitHub repository and establish connection.

**Tasks**:
1. Create a new GitHub repository named following the pattern (e.g., "yourname-website")
2. Add description and keep repository public without README, .gitignore, or license
3. Add remote origin using the repository URL provided by GitHub
4. Verify remote configuration with `git remote -v`

**Commands**:
```bash
git remote add origin https://github.com/username/repo-name.git
git remote -v
```

**Deliverable**: Connected remote repository with verified origin configuration.

---

### Exercise 2.2: Branch Naming Convention Update
**Objective**: Update default branch naming to match modern GitHub conventions.

**Tasks**:
1. Rename master branch to main using `git branch -M main`
2. Verify branch name change with `git branch`
3. Understand why GitHub now defaults to 'main' instead of 'master'

**Commands**:
```bash
git branch -M main
git branch
```

**Deliverable**: Repository configured with 'main' as the default branch matching GitHub standards.

---

### Exercise 2.3: Initial Push to GitHub
**Objective**: Push local commits to remote repository and verify synchronization.

**Tasks**:
1. Push to remote with upstream tracking using `git push -u origin main`
2. Verify successful upload and clean working tree with `git status`
3. Refresh GitHub page to confirm all project files are visible
4. Document the complete workflow from local initialization to remote hosting

**Commands**:
```bash
git push -u origin main
git status
```

**Deliverable**: Project successfully hosted on GitHub with documented push verification.

---

### Exercise 3.1: Feature Branch Development Workflow
**Objective**: Create and manage a feature branch for adding project documentation.

**Tasks**:
1. Create a dedicated branch for README development using `git checkout -b readme-branch`
2. Verify branch creation and switching with `git branch`
3. Create a comprehensive README.md file with project sections (About, Usage, Technologies, Contributions)
4. Stage, commit and push the new branch to GitHub

**Commands**:
```bash
git checkout -b readme-branch
git branch
# Create README.md with project documentation
git add README.md
git commit -m "added readme file"
git push origin readme-branch
```

**Deliverable**: README feature branch created, committed, and pushed to GitHub.

---

### Exercise 3.2: Branch Merging and Synchronization
**Objective**: Merge feature branch changes into main and push updates to remote.

**Tasks**:
1. Switch back to main branch using `git checkout main`
2. Merge the readme-branch using `git merge readme-branch`
3. Check status to confirm branch is ahead by one commit
4. Push the updated main branch and verify changes appear on GitHub

**Commands**:
```bash
git checkout main
git merge readme-branch
git status
git push
```

**Deliverable**: Successfully merged README into main branch with GitHub verification.

---

### Exercise 3.3: Complete Workflow Documentation and Review
**Objective**: Document the entire end-to-end workflow and create a reusable project template.

**Tasks**:
1. Document each step of the complete workflow with command explanations
2. Compare the demonstration steps with the theoretical workflow from Session 44
3. Create a checklist template for future projects following this pattern
4. Identify any variations or alternative approaches for different project types

**Deliverable**: Comprehensive workflow documentation with reusable project setup checklist.

</details>
</details>