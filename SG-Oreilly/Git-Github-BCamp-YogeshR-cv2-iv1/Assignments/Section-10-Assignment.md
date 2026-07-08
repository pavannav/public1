<details open>
<summary><b> Section 10: Working with Remotes and Repositories</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

### Exercise 1.1: Viewing and Understanding Remotes
**Objective**: Learn to view remote repositories and understand their configuration

**Tasks**:
1. Navigate to an existing local Git repository
2. Use `git remote -v` to view all configured remotes
3. Document the remote name, fetch URL, and push URL
4. Explain the purpose of the `-v` (verbose) flag

**Commands**:
```bash
git remote -v
git remote
```

**Deliverable**: List of configured remotes with their URLs and explanation of verbose output

### Exercise 1.2: Adding a Remote Repository
**Objective**: Add a new remote repository to a local project

**Tasks**:
1. Create a new GitHub repository (don't initialize with README)
2. In your local repository, add this new repository as a remote named `backup`
3. Verify the remote was added correctly
4. Add another remote with a different name (e.g., `mirror`)

**Commands**:
```bash
git remote add backup https://github.com/username/backup-repo.git
git remote -v
git remote add mirror https://github.com/username/mirror-repo.git
```

**Deliverable**: Screenshot showing multiple remotes configured

### Exercise 1.3: Renaming and Removing Remotes
**Objective**: Manage remote configurations by renaming and removing them

**Tasks**:
1. Continue from Exercise 1.2
2. Rename the `mirror` remote to `secondary-backup`
3. Verify the rename was successful
4. Remove the `secondary-backup` remote
5. Confirm it's been removed from the list

**Commands**:
```bash
git remote rename mirror secondary-backup
git remote -v
git remote remove secondary-backup
git remote -v
```

**Deliverable**: Commands demonstrating remote management operations

### Exercise 2.1: Pushing Changes to Remote
**Objective**: Push local commits to a remote repository

**Tasks**:
1. Make changes to your local repository (add/modify files)
2. Stage and commit the changes locally
3. Push the changes to the `origin` remote on the `main` branch
4. Verify the changes appear on GitHub

**Commands**:
```bash
echo "New content" > newfile.txt
git add newfile.txt
git commit -m "Add new file for remote demo"
git push origin main
```

**Deliverable**: Confirmation of successful push and remote repository update

### Exercise 2.2: Pulling Changes from Remote
**Objective**: Pull updates from remote repository to local

**Tasks**:
1. Make a change directly on GitHub (edit a file)
2. Commit the change on GitHub
3. In your local repository, pull the latest changes
4. Verify the changes are now in your local files

**Commands**:
```bash
git pull origin main
git status
cat [modified-file]
```

**Deliverable**: Evidence of pulled changes reflected locally

### Exercise 2.3: Handling Divergent Branches
**Objective**: Practice the workflow of pull before push

**Tasks**:
1. Create a scenario where both local and remote have changes
2. Attempt to push (it should fail or warn)
3. Pull the remote changes first
4. Resolve any conflicts if they occur
5. Push successfully after pulling

**Commands**:
```bash
# Local changes
echo "Local change" >> file.txt
git add file.txt && git commit -m "Local update"

# Attempt push (may need pull first)
git push origin main

# Pull remote changes
git pull origin main

# Resolve conflicts if any, then push
git push origin main
```

**Deliverable**: Demonstration of proper pull-before-push workflow

### Exercise 3.1: Understanding git fetch vs git pull
**Objective**: Differentiate between fetch and pull operations

**Tasks**:
1. Make changes on GitHub without pulling them
2. Use `git fetch origin` to download changes without merging
3. Check what fetch downloaded using `git log` comparisons
4. Manually merge the fetched changes
5. Compare this to using `git pull` directly

**Commands**:
```bash
git fetch origin
git log --oneline main..origin/main  # See fetched commits
git merge origin/main
# vs
git pull origin main  # Combines fetch + merge
```

**Deliverable**: Comparison of fetch workflow vs pull workflow

### Exercise 3.2: Cloning with HTTPS
**Objective**: Clone a repository using HTTPS authentication

**Tasks**:
1. Find a public repository on GitHub
2. Clone it using the HTTPS URL
3. Specify a custom directory name during cloning
4. Verify the clone was successful
5. Check the remote configuration of the cloned repository

**Commands**:
```bash
git clone https://github.com/username/repo.git custom-name
ls custom-name
cd custom-name
git remote -v
```

**Deliverable**: Successfully cloned repository with custom name

### Exercise 3.3: Cloning with SSH and Making Changes
**Objective**: Clone using SSH and demonstrate the complete workflow

**Tasks**:
1. Ensure SSH keys are configured with GitHub
2. Clone a repository using the SSH URL
3. Navigate into the cloned directory
4. Create a new file, stage, commit, and push
5. Verify the changes appear on GitHub

**Commands**:
```bash
git clone git@github.com:username/repo.git ssh-clone
cd ssh-clone
echo "SSH clone test" > ssh-test.txt
git add ssh-test.txt
git commit -m "Test SSH clone workflow"
git push origin main
```

**Deliverable**: Complete SSH clone workflow with successful push without credentials

</details>
</details>