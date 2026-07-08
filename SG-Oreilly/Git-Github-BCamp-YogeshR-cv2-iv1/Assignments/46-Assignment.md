<details open>
<summary><b> Session 46: Demonstration - Forking in GitHub</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

### Exercise 1.1: Understanding Forking Prerequisites
**Objective**: Set up the environment and understand the scenarios where forking is necessary.

**Tasks**:
1. Identify two different GitHub accounts (personal vs demonstration account)
2. Locate an existing public repository that you don't have write access to
3. Document the scenario: contributing to someone else's project without direct push permissions
4. Verify that you can view but not modify the original repository

**Deliverable**: Documented scenario setup explaining why forking is needed for external contributions.

---

### Exercise 1.2: Repository URL Collection and Analysis
**Objective**: Practice identifying and collecting repository information needed for forking.

**Tasks**:
1. Copy the repository URL from a public GitHub repository
2. Analyze the repository structure (owner, name, description, branches)
3. Document the key repository metadata visible before forking
4. Understand the relationship between original and future forked repository

**Commands**:
```bash
# Repository URL example:
https://github.com/original-owner/think-crook-website
```

**Deliverable**: Repository metadata analysis document with URL and structural information.

---

### Exercise 1.3: Fork Creation Process
**Objective**: Execute the forking process and understand the fork creation interface.

**Tasks**:
1. Navigate to a public repository you want to contribute to
2. Locate and click the "Fork" button in the top right corner
3. Configure fork options: select destination account, repository name, description
4. Choose branch options (main branch only vs all branches)
5. Execute the fork creation and verify successful fork

**Deliverable**: Successfully created fork with documented configuration choices and verification.

---

### Exercise 2.1: Fork Verification and Owner Analysis
**Objective**: Verify the fork creation and understand ownership differences.

**Tasks**:
1. Compare the original repository vs forked repository ownership
2. Document the key differences: same name, different owners, same content
3. Verify that the fork appears under your GitHub account
4. Confirm you now have full control over the forked repository

**Deliverable**: Ownership comparison document showing original vs fork relationship.

---

### Exercise 2.2: SSH Cloning of Forked Repository
**Objective**: Clone the forked repository to local machine using SSH.

**Tasks**:
1. Click the green "Code" button on the forked repository
2. Select SSH option and copy the SSH URL
3. Execute `git clone` command with the forked repository URL
4. Verify local clone contains all repository files (HTML, images, README)

**Commands**:
```bash
git clone git@github.com:demo-account/think-crook-website.git
ls -la
cd think-crook-website
ls
```

**Deliverable**: Successfully cloned forked repository with verified file contents.

---

### Exercise 2.3: Making Independent Changes to Fork
**Objective**: Practice making modifications to the forked repository safely.

**Tasks**:
1. Open the README.md file in the cloned fork
2. Make meaningful changes (remove test content, add CSS and JavaScript to technologies section)
3. Verify changes with `git status` showing modified state
4. Document that changes affect only the fork, not the original project

**Commands**:
```bash
git status
git add .
git commit -m "readme file updated"
git push origin main
git status
```

**Deliverable**: Documented changes made to fork with commit and push verification.

---

### Exercise 3.1: Fork Status Monitoring and Divergence
**Objective**: Monitor fork status relative to the original repository.

**Tasks**:
1. Refresh GitHub page to verify changes are reflected in the fork
2. Analyze the "1 commit ahead" indicator showing fork divergence
3. Document how GitHub tracks the relationship between fork and upstream
4. Understand the concept that forks can have updates the source doesn't have

**Deliverable**: Fork status analysis showing divergence tracking and relationship monitoring.

---

### Exercise 3.2: Upstream Synchronization Understanding
**Objective**: Understand how forks can be synchronized with upstream changes.

**Tasks**:
1. Research the "Sync fork" button functionality on GitHub
2. Document scenarios where upstream synchronization would be needed
3. Explain the relationship between keeping a fork up to date and contributing changes
4. Create a workflow diagram showing fork updates from both directions

**Deliverable**: Upstream synchronization workflow document with timing and purpose explanations.

---

### Exercise 3.3: Fork Contribution Strategy Planning
**Objective**: Plan a complete contribution workflow using forking methodology.

**Tasks**:
1. Design a contribution strategy: Fork → Clone → Modify → Contribute
2. Document the safety benefits of working in a personal fork vs direct access
3. Create guidelines for when to use forking vs when direct collaboration is possible
4. Plan the next steps for proposing changes back to the original project

**Deliverable**: Comprehensive forking contribution strategy with safety protocols and workflow planning.

</details>
</details>