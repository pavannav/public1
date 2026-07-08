<details open>
<summary><b> Session 09: How to Clone a Repository</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Exercise 1.1: Repository Cloning Fundamentals
**Objective**: Understand the concept and purpose of cloning repositories

**Tasks**:
1. Define what a "repository" or "repo" means in Git context
2. Explain the three methods to obtain code from a remote repository
3. Describe the difference between cloning and downloading a ZIP file

**Deliverable**: Written explanation of repository cloning concepts

---

## Exercise 1.2: Clone via HTTPS
**Objective**: Practice cloning a repository using HTTPS authentication

**Tasks**:
1. Navigate to a public repository on GitHub (e.g., Wagtail or create a test repo)
2. Copy the HTTPS clone URL
3. Use `git clone` command with the HTTPS URL
4. Verify the repository was cloned successfully

**Commands**:
```bash
git clone https://github.com/username/repository.git
ls -la
cd repository-name
ls -la
```

**Deliverable**: Screenshot showing successful clone operation and directory structure

---

## Exercise 1.3: Explore Cloned Repository
**Objective**: Navigate and examine the contents of a cloned repository

**Tasks**:
1. Change directory into the cloned repository
2. List all files including hidden ones
3. View the README file to verify content
4. Explore the directory structure

**Commands**:
```bash
cd repository-name
ls -la
cat README.md
pwd
```

**Deliverable**: Documentation of the cloned repository structure and contents

---

## Exercise 2.1: Git History Exploration
**Objective**: Examine the complete Git history of a cloned repository

**Tasks**:
1. Use `git log` to view commit history
2. Identify commit hashes, authors, and messages
3. Understand that cloning includes complete history
4. Navigate through different commits if needed

**Commands**:
```bash
git log
git log --oneline
```

**Deliverable**: Screenshot or description of commit history from the cloned repository

---

## Exercise 2.2: Clone via SSH (if configured)
**Objective**: Practice cloning using SSH authentication

**Tasks**:
1. Copy the SSH clone URL from a repository
2. Use `git clone` with the SSH URL
3. Compare the process with HTTPS cloning
4. Note any authentication differences

**Commands**:
```bash
git clone git@github.com:username/repository.git
```

**Deliverable**: Confirmation of successful SSH cloning (if SSH is configured)

---

## Exercise 2.3: Multiple Repository Cloning
**Objective**: Clone multiple repositories to practice the process

**Tasks**:
1. Identify 2-3 different public repositories to clone
2. Clone each repository to separate directories
3. Verify each clone was successful
4. Practice navigating between different cloned repositories

**Deliverable**: List of cloned repositories with their purposes or sources

</details>

</details>