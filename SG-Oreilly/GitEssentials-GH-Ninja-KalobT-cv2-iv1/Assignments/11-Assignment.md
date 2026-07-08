<details open>
<summary><b> Session 11: How to Create a New Repository on GitHub</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Exercise 1.1: Create GitHub Repository
**Objective**: Create a new repository directly on GitHub

**Tasks**:
1. Log into your GitHub account
2. Click the "+" icon and select "New repository"
3. Name the repository (e.g., "git-essentials")
4. Add an optional description
5. Choose visibility (public/private)
6. Select "No" for README initialization
7. Create the repository

**Deliverable**: Screenshot of the newly created empty repository page

---

## Exercise 1.2: Initialize Local Git Repository
**Objective**: Create a local directory and initialize it as a Git repository

**Tasks**:
1. Create a new directory called "test" or similar
2. Navigate into the directory using `cd`
3. Initialize a new Git repository with `git init`
4. Verify the `.git` folder was created

**Commands**:
```bash
mkdir test
cd test
git init
ls -la
```

**Deliverable**: Screenshot showing the directory structure with `.git` folder

---

## Exercise 1.3: Create Initial README File
**Objective**: Create and add the first file to the local repository

**Tasks**:
1. Create a README.md file with initial content
2. Verify the file was created
3. Check Git status to see untracked files

**Commands**:
```bash
echo "# Git Essentials" > README.md
ls -la
git status
```

**Deliverable**: Screenshot showing the README.md file and Git status output

---

## Exercise 2.1: Create First Commit
**Objective**: Stage and commit the initial file to the local repository

**Tasks**:
1. Add the README.md file to staging area
2. Create a commit with a descriptive message
3. Verify the commit was created using `git log`

**Commands**:
```bash
git add README.md
git commit -m "First commit"
git log
```

**Deliverable**: Screenshot showing successful commit with hash, author, and message

---

## Exercise 2.2: Connect Local Repository to GitHub
**Objective**: Link the local repository to the remote GitHub repository

**Tasks**:
1. Copy the SSH or HTTPS URL from GitHub repository
2. Add the remote origin using `git remote add origin`
3. Verify the remote connection with `git remote -v`

**Commands**:
```bash
git remote add origin git@github.com:username/git-essentials.git
git remote -v
```

**Deliverable**: Screenshot showing the remote configuration with SSH/HTTPS URL

---

## Exercise 2.3: Push to GitHub
**Objective**: Push the local commits to the remote GitHub repository

**Tasks**:
1. Push the local branch to remote with upstream tracking
2. Handle SSH fingerprint verification if prompted
3. Verify the files appear on GitHub

**Commands**:
```bash
git push -u origin master
```

**Deliverable**: Screenshot of the GitHub repository showing the pushed README.md file

---

## Exercise 3.1: Understanding the Git Workflow
**Objective**: Document the complete workflow from creation to push

**Tasks**:
1. List all commands used in sequence
2. Explain the purpose of each command
3. Create a diagram or flowchart of the workflow

**Commands to document**:
- `git init`
- `git add`
- `git commit`
- `git remote add`
- `git push`

**Deliverable**: Written documentation of the complete repository creation workflow

</details>

</details>