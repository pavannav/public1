# Git Essentials Lab Guide
## From Beginner to Expert - Command Line Approach

---

## Session 1: Course Introduction

### Welcome to Git Essentials

This course teaches Git from the ground up using only the command line, which is essential for developer careers and open source collaboration.

### Learning Objectives
- Master Git command-line fundamentals
- Understand Git's importance in modern development
- Build foundation for working with development teams

### What You'll Gain
- Complete Git fluency for professional development
- Skills applicable to GitHub, GitLab, and Bitbucket
- Essential competency for developer job applications

### Observations
- Git is the most frequently used tool in web development
- Every developer must know Git for team collaboration
- This course covers daily practical usage plus advanced concepts

---

## Session 2: Why Command Line?

### Understanding the Command Line Advantage

While visual Git tools exist and seem easier initially, command-line proficiency is crucial for real-world development scenarios.

### Key Concepts

#### The Server Reality
- Servers operate exclusively via command line
- No GUI available when deploying to production
- Visual tools become limiting when working on remote systems

#### Universal Availability
- Command line Git works everywhere: servers, any OS, any computer
- No special programs required - just Git itself
- Essential for moving code between machines globally

#### Learning Path Benefits
1. Learn command line first (builds stronger foundation)
2. Visual tools can be added later if desired
3. Much harder to learn visual tools first, then command line

### Practice Commands
```bash
# Navigate directories
cd foldername        # Change to specific directory
cd ..               # Move up one directory level
pwd                 # Print working directory (current location)
ls -la              # List all files with details (including hidden)
dir                 # Windows equivalent of ls -la
```

### Observations
- You can successfully navigate using `cd`, `pwd`, and `ls -la`
- Server environments lack graphical interfaces entirely
- Command line skills transfer across all computing environments

---

## Session 3: Installing Git - Windows

### Windows Git Installation

For Windows users, Git for Windows provides the optimal command-line experience.

### Installation Steps

1. Visit [gitforwindows.org](https://gitforwindows.org)
2. Click the download button (redirects to GitHub releases)
3. Select appropriate version:
   - **64-bit**: For computers less than 4 years old (recommended)
   - **32-bit**: For older Windows systems
4. Download and install the `.exe` file
5. Launch "Git for Windows" terminal

### Terminal Basics (Windows)
```bash
dir                 # List directory contents
cd foldername       # Change directory
pwd                 # Show current path
```

### Setup Recommendation
Create a temporary practice folder (Desktop/Downloads) for Git exercises.

### Observations
- Git Bash terminal opens with command prompt
- Visual customizations may vary but core functionality remains
- Directory navigation works as expected with provided commands

---

## Session 4: Installing Git - macOS & Linux

### macOS Installation Options

#### Option 1: Homebrew (Recommended)
```bash
brew install git
```
- Requires Homebrew package manager
- Enables easy future updates
- Useful for other development packages

#### Option 2: Official Installer
1. Visit: `sourceforge.net/projects/git-osx-installer/files`
2. Download latest version (e.g., 2.23.0.0)
3. Install the package

### Linux Installation

#### Ubuntu/Debian
```bash
# For Ubuntu 18.04 and earlier
sudo apt install git

# For Ubuntu 12.04/16.04
sudo apt-get install git
```

#### Other Distributions
```bash
# Fedora/RHEL/CentOS
sudo yum install git

# Arch Linux
sudo pacman -S git
```

### Terminal Access
- **macOS**: Use built-in "Terminal" application
- **Linux**: Use "bash" or your distribution's terminal

### Verification
```bash
git --version    # Confirm Git installation and version
```

### Observations
- Git version displays successfully
- Package manager installation completed without errors
- Terminal application opens and accepts commands

---

## Session 5: Getting Started with GitHub

### Setting Up Your GitHub Account

GitHub serves as the primary platform for open source collaboration and portfolio building.

### Account Creation/Setup
1. Visit [github.com](https://github.com)
2. Create free account or sign in to existing
3. Provide username, email, and password
4. Complete verification (CAPTCHA)
5. Select **Free plan** (no payment required)

### Alternative Platforms
All concepts transfer to:
- **GitLab** (gitlab.com) - Popular for private/business use
- **Bitbucket** (bitbucket.org) - Lesser-known but capable

### Portfolio Importance
- GitHub activity visible to potential employers
- Contribution graphs show coding consistency
- Code visibility matters more than portfolio websites
- Employers prioritize GitHub profiles during hiring

### Observations
- Successfully logged into GitHub/GitLab/Bitbucket
- Account shows activity feed (may be empty for new accounts)
- Profile displays contribution graph with commit history

---

## Session 6: Configuring Git on Your Computer

### Initial Git Configuration

Configure Git with your identity for proper commit attribution.

### Required Configuration
```bash
# Set your name (as you want it to appear in commits)
git config --global user.name "Your Name"

# Set your email (must match GitHub account email)
git config --global user.email "your.email@example.com"

# Verify configuration
git config --list
```

### Observations
- Git configuration saves successfully
- `user.name` and `user.email` appear in configuration list
- Settings persist across Git sessions

---

## Session 7: Creating and Adding an SSH Key

### SSH Key Authentication Setup

SSH keys provide secure authentication without password entry.

### Generate SSH Key
```bash
# Generate new SSH key pair
ssh-keygen -t ed25519 -C "your.email@example.com"

# Or for older systems
ssh-keygen -t rsa -b 4096 -C "your.email@example.com"

# Accept default file location (press Enter)
# Set a secure passphrase (recommended)
```

### Add SSH Key to ssh-agent
```bash
# Start ssh-agent in background
eval "$(ssh-agent -s)"

# Add private key to agent
ssh-add ~/.ssh/id_ed25519
```

### Add Public Key to GitHub
1. Copy public key content:
   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```
2. Go to GitHub → Settings → SSH and GPG keys
3. Click "New SSH key"
4. Paste public key content
5. Save with descriptive title

### Test Connection
```bash
ssh -T git@github.com
# Expected: "Hi username! You've successfully authenticated..."
```

### Observations
- SSH key pair generated (private and public keys exist)
- Public key successfully added to GitHub account
- SSH authentication test succeeds without password prompt

---

## Session 8: How to Clone a Repository

### Understanding Repository Cloning

Cloning creates a local copy of a remote repository on your machine.

### Basic Clone Command
```bash
# Clone repository to current directory
git clone https://github.com/username/repository.git

# Clone to specific directory name
git clone https://github.com/username/repository.git my-folder-name

# Clone with SSH (after setting up keys)
git clone git@github.com:username/repository.git
```

### Understanding the Process
- Downloads entire repository history
- Creates remote connection automatically
- Sets up tracking branches
- Initializes local Git repository

### Verification Steps
```bash
# Enter cloned directory
cd repository-name

# Check remote origin
git remote -v

# View current branch
git branch

# Check status
git status
```

### Observations
- Repository folder created with all files
- `.git` directory exists (hidden folder)
- Remote origin configured correctly
- Files match repository contents on GitHub

---

## Session 9: What is Cloning?

### Deep Dive into Git Cloning

Understanding what happens when you clone a repository.

### Key Concepts

#### Complete Repository Copy
- All files and folders downloaded
- Complete commit history included
- All branches preserved
- Remote tracking information configured

#### Local Repository Initialization
- `.git` directory created
- Git configuration initialized
- Working directory set up
- Staging area prepared

#### Remote Connection
- Origin remote automatically configured
- Points to original repository URL
- Enables future synchronization
- Supports push/pull operations

### Clone vs Download
- **Clone**: Full Git functionality, history, collaboration capability
- **Download**: Simple file copy, no Git features

### Observations
- Local repository matches remote exactly
- All branches accessible locally
- Git commands work immediately after cloning
- Remote connection established for future operations

---

## Session 10: How to Create a New Repository on GitHub

### Creating Your First GitHub Repository

Learn to create and initialize new repositories on GitHub.

### GitHub Web Interface Steps
1. Click "+" icon → "New repository"
2. Repository name: Choose descriptive name
3. Description: Add optional description
4. **Important Settings**:
   - ✅ **Add README.md** (recommended for new repos)
   - Choose license (optional but recommended)
   - Select `.gitignore` template (if applicable)
5. Click "Create repository"

### Initialize with README
```markdown
# Repository Name

Description of your project.

## Installation
Steps to install...

## Usage
How to use...

## License
Specify license information
```

### Observations
- Repository appears in your GitHub profile
- README.md displays on repository landing page
- Repository URL available for cloning
- Initial commit created with README

---

## Session 11: How to Push to Your GitHub Repository

### Pushing Local Changes to GitHub

Learn to upload your local Git repository to GitHub.

### Initial Push Process
```bash
# After creating local repository
git init

# Add files to staging
git add .

# Create initial commit
git commit -m "Initial commit"

# Add remote origin (if not already added)
git remote add origin https://github.com/username/repo-name.git

# Push to GitHub (first time)
git push -u origin main

# Or for master branch
git push -u origin master
```

### Subsequent Pushes
```bash
# After making changes
git add .
git commit -m "Descriptive commit message"
git push
```

### Handling Authentication
- HTTPS: Username and password/token required
- SSH: Key-based authentication (no password needed)

### Branch Naming Note
Modern repositories use `main` as default branch, older ones use `master`.

### Observations
- Changes appear on GitHub after push
- Commit history visible in repository
- Branch tracking established (`-u` flag)
- Remote repository synchronized with local

---

## Session 12: Git Status

### Understanding Git Status Command

The `git status` command provides essential information about your repository state.

### Basic Status Command
```bash
git status
```

### Status Information Categories

#### Working Directory Clean
```
On branch main
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean
```

#### Modified Files
```
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
        modified:   filename.txt
```

#### Staged Files
```
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        modified:   filename.txt
```

#### Untracked Files
```
Untracked files:
  (use "git add <file>..." to include in what will be committed)
        newfile.txt
```

### Color Coding
- **Red**: Modified but unstaged files
- **Green**: Staged and ready to commit
- **No color**: Untracked/new files

### Observations
- Repository state clearly displayed
- Files categorized by their Git status
- Action suggestions provided for each state
- Branch and remote information included

---

## Session 13: Unstaging a File

### Removing Files from Staging Area

Learn to unstage files that were accidentally added or shouldn't be committed yet.

### Unstaging Methods

#### Modern Git (2.23+)
```bash
# Unstage specific file
git restore --staged filename.txt

# Unstage all files
git restore --staged .
```

#### Legacy Method (works on all versions)
```bash
# Unstage specific file
git reset HEAD filename.txt

# Unstage all files
git reset HEAD
```

### Understanding the Process
- Files move from staged back to modified state
- Content remains unchanged
- Working directory files unaffected
- Ready for selective staging

### Workflow Example
```bash
# Mistakenly staged unwanted changes
git add .

# Check what was staged
git status

# Unstage specific file
git restore --staged unwanted-file.txt

# Verify unstaging
git status
```

### Observations
- File appears as "modified" rather than "staged"
- File content remains intact
- No data loss occurs during unstaging
- Status reflects new state correctly

---

## Session 14: Undeleting a File

### Recovering Deleted Files with Git

Learn to restore files that were deleted from your working directory.

### Git-Based File Recovery

#### Restore Single Deleted File
```bash
# Restore from last commit
git checkout -- deleted-filename.txt

# Modern alternative
git restore deleted-filename.txt
```

#### Restore All Deleted Files
```bash
# Restore all deleted files
git checkout -- .

# Modern approach
git restore .
```

### Important Distinctions
- **Deleted from working directory only**: Can be restored from Git
- **Deleted and committed**: Requires more advanced recovery
- **Git must be tracking the file**: Only works for previously committed files

### Recovery Process
```bash
# Verify file is deleted
ls -la

# Check Git knows about the deletion
git status

# Restore the file
git checkout -- deleted-file.txt

# Verify restoration
ls -la
cat deleted-file.txt
```

### Limitations
- Cannot recover untracked files
- Cannot recover files never committed to Git
- Resets file to last committed version

### Observations
- File reappears in working directory
- File content matches last committed version
- Git status shows clean working directory
- No data loss from the deletion

---

## Session 15: Git Origins and Remotes

### Understanding Git Remotes and Origins

Master the concept of remote repositories and how they connect to local repos.

### Remote Repository Concepts

#### What is a Remote?
- Link between local and remote repository
- Enables collaboration and backup
- Supports distributed version control
- Can have multiple remotes per repository

#### Origin Remote
- Default name for primary remote
- Points to original repository location
- Automatically created during clone
- Convention but not required

### Managing Remotes

#### View Current Remotes
```bash
# List all remotes with URLs
git remote -v

# List remote names only
git remote
```

#### Add New Remote
```bash
# Add remote with custom name
git remote add upstream https://github.com/original/repo.git

# Add origin (if not present)
git remote add origin https://github.com/username/repo.git
```

#### Modify Existing Remote
```bash
# Change remote URL
git remote set-url origin https://github.com/new-username/repo.git

# Rename remote
git remote rename origin upstream
```

#### Remove Remote
```bash
# Remove specific remote
git remote remove upstream
```

### Remote URL Types
- **HTTPS**: `https://github.com/username/repo.git`
- **SSH**: `git@github.com:username/repo.git`

### Observations
- Remote connections listed with fetch/push URLs
- Multiple remotes can coexist
- Remote operations (fetch/push) use configured URLs
- Remote configuration persists in `.git/config`

---

## Session 16: Git Branching

### Understanding Git Branching Fundamentals

Learn to create and manage branches for parallel development.

### Branch Concepts
- Branches enable parallel development streams
- Each branch maintains separate commit history
- Default branch typically named `main` or `master`
- Enables feature development without affecting stable code

### Basic Branch Operations

#### Create New Branch
```bash
# Create branch (stays on current branch)
git branch feature-name

# Create and switch to branch
git checkout -b feature-name

# Modern approach
git switch -c feature-name
```

#### List Branches
```bash
# Local branches only
git branch

# All branches (local and remote)
git branch -a

# Verbose branch information
git branch -v
```

#### Switch Between Branches
```bash
# Switch to existing branch
git checkout branch-name

# Modern command
git switch branch-name
```

#### Delete Branch
```bash
# Delete merged branch
git branch -d branch-name

# Force delete unmerged branch
git branch -D branch-name
```

### Current Branch Indicator
```bash
# Asterisk (*) marks current branch
git branch
# Output example:
#   main
# * feature-login
#   hotfix-header
```

### Observations
- New branch appears in branch list
- Current branch marked with asterisk
- File changes isolated to current branch
- Branch switching updates working directory

---

## Session 17: Committing to a New Branch

### Working with Feature Branches

Practice creating branches and making commits within them.

### Complete Workflow

#### 1. Create Feature Branch
```bash
# From main/master branch
git checkout main

# Create and switch to feature branch
git checkout -b feature/new-functionality
```

#### 2. Make Changes and Commit
```bash
# Create or modify files
echo "New feature code" > feature.js

# Stage changes
git add feature.js

# Commit with descriptive message
git commit -m "Add new feature implementation

- Implement core functionality
- Add unit tests
- Update documentation"
```

#### 3. Verify Branch State
```bash
# Check current branch
git branch

# View commit history
git log --oneline

# Check working directory status
git status
```

#### 4. Push Branch to Remote
```bash
# Push new branch to remote
git push -u origin feature/new-functionality
```

### Branch Isolation
- Changes on feature branch don't affect main
- Commits are branch-specific
- Can switch branches without losing work
- Enables safe experimentation

### Observations
- Commits appear only on feature branch
- Main branch remains unchanged
- Branch commit history shows linear progression
- Remote tracking established with `-u` flag

---

## Session 18: Merging Branch into Master

### Integrating Feature Branches

Learn to merge completed feature branches back into the main branch.

### Merge Process

#### 1. Switch to Target Branch
```bash
# Switch to main/master branch
git checkout main

# Ensure main is up to date
git pull origin main
```

#### 2. Perform Merge
```bash
# Merge feature branch into current branch
git merge feature/new-functionality

# Or merge with explicit branch reference
git merge feature/new-functionality --no-ff
```

#### 3. Resolve or Complete Merge
```bash
# If no conflicts, merge completes automatically
# If conflicts exist, resolve them manually, then:
git add resolved-file.txt
git commit -m "Resolve merge conflicts"
```

#### 4. Clean Up
```bash
# Delete merged branch (optional)
git branch -d feature/new-functionality

# Push updated main
git push origin main
```

### Merge Strategies

#### Fast-Forward Merge
```
A---B---C (main)
         \
          D---E (feature)
               ↓
A---B---C---D---E (main after merge)
```

#### Three-Way Merge (with --no-ff)
```
A---B---C (main)
     \
      D---E (feature)
           ↓
A---B---C---F--- (main after merge)
           /
      D---E
```

### Observations
- Feature commits integrated into main branch
- Main branch history updated appropriately
- Merge commit created (if not fast-forward)
- Feature branch can be safely deleted

---

## Session 19: Seeing Your Git History

### Exploring Git Commit History

Master viewing and navigating through your repository's commit history.

### Basic History Commands

#### View Commit Log
```bash
# Standard log view
git log

# Compact one-line view
git log --oneline

# Last N commits
git log --oneline -10

# All branches history
git log --all --oneline
```

#### Detailed Information
```bash
# Include file changes summary
git log --stat

# Show actual code changes
git log -p

# Search commit messages
git log --grep="feature"

# Search code changes
git log -S"function_name"
```

#### Visual Representations
```bash
# ASCII graph of branches
git log --graph --oneline --all

# Color-coded graph
git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
```

### Advanced Filtering
```bash
# Commits by author
git log --author="John Doe"

# Commits after date
git log --since="2023-01-01"

# Commits before date
git log --until="2023-12-31"

# Commits touching specific file
git log -- filename.txt
```

### Observations
- Complete commit history displayed chronologically
- Commit hashes, messages, authors, and dates visible
- Branch relationships shown in graph view
- Filtering options narrow results effectively

---

## Session 20: Downloading Updates from GitHub

### Fetching Remote Changes

Learn to download updates from remote repositories without merging.

### Fetch Operations

#### Basic Fetch
```bash
# Fetch from default remote (origin)
git fetch

# Fetch from specific remote
git fetch origin

# Fetch all remotes
git fetch --all
```

#### What Fetch Does
- Downloads new commits from remote
- Updates remote tracking branches
- Does NOT modify working directory
- Creates safe preview of remote changes

#### View Remote Updates
```bash
# Check what fetch retrieved
git log --oneline origin/main

# Compare local vs remote
git log --oneline main..origin/main

# View all remote branches
git branch -r
```

### Pull vs Fetch
- **Fetch**: Downloads only, safe preview
- **Pull**: Downloads and merges automatically

### Safe Update Workflow
```bash
# 1. Fetch to see what's new
git fetch origin

# 2. Review changes
git log --oneline main..origin/main

# 3. Decide to merge or not
git merge origin/main
```

### Observations
- New commits downloaded from remote
- Remote tracking branches updated
- Working directory unchanged
- Can review changes before integrating

---

## Session 21: How to Get Updates from GitHub

### Pulling Remote Changes

Master the `git pull` command for integrating remote updates.

### Pull Command Variations

#### Standard Pull
```bash
# Pull and merge from current branch's upstream
git pull

# Explicit pull from origin
git pull origin main
```

#### Pull Strategies

#### Pull with Merge (Default)
```bash
git pull origin main
# Creates merge commit if divergent history
```

#### Pull with Rebase
```bash
git pull --rebase origin main
# Replays local commits on top of remote commits
```

#### Force Pull (Discard Local Changes)
```bash
# WARNING: Destroys local changes
git fetch origin
git reset --hard origin/main
```

### Handling Conflicts During Pull
```bash
# If conflicts occur:
# 1. Edit conflicted files
# 2. Mark as resolved
git add conflicted-file.txt

# 3. Complete merge
git commit -m "Resolve pull conflicts"
```

### Upstream Configuration
```bash
# Set upstream for future pulls
git push -u origin main

# After upstream set, simple pull works
git pull
```

### Observations
- Local branch updated with remote changes
- Merge commit created if necessary
- Working directory reflects remote state
- Conflicts resolved through manual intervention

---

## Session 22: Checkout Code - Time Travel

### Using Git Checkout for Historical Access

Learn to view your code at any point in history using checkout.

### Checkout Fundamentals

#### View Previous Commits
```bash
# Checkout specific commit (detached HEAD)
git checkout commit-hash

# Checkout by relative reference
git checkout HEAD~3          # Three commits ago
git checkout HEAD~1          # One commit ago
```

#### View Branch States
```bash
# Checkout specific branch
git checkout feature-branch

# Checkout remote branch
git checkout origin/main
```

#### File-Level Checkout
```bash
# Restore file from specific commit
git checkout commit-hash -- filename.txt

# Restore file from previous commit
git checkout HEAD~1 -- filename.txt
```

### Detached HEAD State
- Occurs when checking out specific commits
- Warning message indicates detached state
- Can make experimental commits
- Must create branch to save work

#### Working in Detached State
```bash
# You're in detached HEAD state
git checkout a1b2c3d

# Make experimental changes
echo "experimental" > test.txt
git add test.txt
git commit -m "Experimental commit"

# Create branch to save work
git branch experiment-branch
git checkout experiment-branch
```

### Return to Normal State
```bash
# Return to latest commit on branch
git checkout main
```

### Observations
- Code state matches historical commit
- Can browse files as they existed then
- Detached HEAD warning may appear
- All Git operations still available

---

## Session 23: README.md Files

### Creating Effective Documentation

Master the art of writing comprehensive README files for your projects.

### README Structure

#### Essential Sections
```markdown
# Project Title

Brief description of what your project does.

## Features
- Feature 1
- Feature 2
- Feature 3

## Installation
\`\`\`bash
git clone https://github.com/username/repo.git
cd repo
npm install
\`\`\`

## Usage
\`\`\`bash
npm start
\`\`\`

## Configuration
Environment variables and settings...

## Contributing
Guidelines for contributors...

## License
MIT License - see LICENSE file
```

### Markdown Formatting
- Use `#` for headers (H1-H6)
- Code blocks with triple backticks
- Lists with `-` or numbers
- Links with `[text](url)`
- Images with `![alt](image-url)`

### Best Practices
- Keep installation simple and tested
- Include example usage
- Mention prerequisites
- Provide troubleshooting tips
- Update README with project changes

### GitHub Rendering
- README.md displays on repository landing page
- Automatic formatting and syntax highlighting
- Supports relative and absolute links
- Images render when using correct paths

### Observations
- README displays prominently on GitHub
- Formatting renders correctly
- Installation instructions are clear and accurate
- All project information easily accessible

---

## Session 24: Viewing File Differences

### Comparing File Changes with Git Diff

Learn to view exact changes between different versions of files.

### Diff Command Options

#### Working Directory Changes
```bash
# View unstaged changes
git diff

# View changes for specific file
git diff filename.txt

# View staged changes
git diff --staged

# View all changes (staged and unstaged)
git diff HEAD
```

#### Historical Comparisons
```bash
# Compare with previous commit
git diff HEAD~1

# Compare between commits
git diff commit1 commit2

# Compare branches
git diff main feature-branch
```

#### File-Specific Diffs
```bash
# Show changes for one file across commits
git diff commit1 commit2 -- filename.txt

# View diff with context lines
git diff -U3 filename.txt
```

### Understanding Diff Output

#### Color Coding
- **Red/Green**: Lines removed/added
- **@@**: Hunk headers showing line numbers
- **+/-**: Indicators for line changes

#### Sample Diff Output
```diff
diff --git a/file.txt b/file.txt
index 1234567..abcdefg 100644
--- a/file.txt
+++ b/file.txt
@@ -1,3 +1,4 @@
 line 1
-line 2 (removed)
+line 2 (modified)
 line 3
+new line 4
```

### Advanced Options
```bash
# Ignore whitespace changes
git diff -w

# Show statistics only
git diff --stat

# Word-level diff
git diff --word-diff
```

### Observations
- Exact line-by-line changes visible
- Additions highlighted in green
- Deletions highlighted in red
- Context provided around changes

---

## Session 25: How to Ignore Files

### Excluding Files from Git Tracking

Master the `.gitignore` file to exclude unnecessary files from version control.

### Creating .gitignore

#### Basic .gitignore File
```gitignore
# Dependencies
node_modules/
vendor/

# Build outputs
dist/
build/
*.min.js

# IDE files
.vscode/
.idea/
*.swp
*.swo

# OS files
.DS_Store
Thumbs.db

# Environment files
.env
.env.local
config/secrets.yml

# Log files
*.log
logs/
```

#### Language-Specific Patterns
```gitignore
# Python
__pycache__/
*.py[cod]
*.so
.Python
env/
venv/

# Java
*.class
*.jar
target/

# C/C++
*.o
*.exe
*.dll
```

### .gitignore Best Practices

#### Patterns and Wildcards
- `*` - Matches anything
- `?` - Matches single character
- `**/` - Matches in all directories
- `!` - Negate pattern (include file)

#### Directory vs File
- `folder/` - Ignore entire directory
- `file.txt` - Ignore specific file
- `*.log` - Ignore all log files

### Managing .gitignore

#### Apply to Existing Repository
```bash
# Create .gitignore file
echo "node_modules/" >> .gitignore

# Remove already tracked files
git rm -r --cached .
git add .
git commit -m "Add .gitignore and remove cached files"
```

#### Check Ignored Files
```bash
# List all ignored files
git status --ignored

# Check if file is ignored
git check-ignore -v filename.txt
```

### Observations
- Specified files no longer tracked by Git
- `.gitignore` file itself is tracked
- Build artifacts excluded from repository
- Repository remains clean of temporary files

---

## Session 26: Create a Custom Git Alias

### Streamlining Git Commands

Create shortcuts for frequently used Git commands to improve workflow efficiency.

### Creating Git Aliases

#### Basic Alias Creation
```bash
# Create simple aliases
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit

# Create aliases with parameters
git config --global alias.last 'log -1 HEAD'
git config --global alias.visual '!gitk'
```

#### Useful Development Aliases
```bash
# Quick status and log
git config --global alias.s 'status -s'
git config --global alias.l 'log --oneline -10'

# Branch management
git config --global alias.nb '!git checkout -b'
git config --global alias.dbr '!git branch -d'

# Advanced log views
git config --global alias.hist "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short"
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
```

#### Function Aliases
```bash
# Complex alias with parameters
git config --global alias.pushall '!f() { git push origin --all; git push origin --tags; }; f'

# Delete remote branch
git config --global alias.drb '!f() { git push origin --delete $1; }; f'
```

### Managing Aliases

#### View All Aliases
```bash
git config --list | grep alias
```

#### Remove Alias
```bash
git config --global --unset alias.st
```

#### Use Aliases
```bash
# Instead of: git status
git st

# Instead of: git checkout -b feature
git nb feature

# Instead of: git log --oneline -10
git l
```

### Observations
- Short aliases execute longer commands
- Workflow speed significantly improved
- Complex operations simplified
- Custom aliases adapt to personal workflow

---

## Session 27: Fixing Git Commit Messages

### Correcting Commit Message Mistakes

Learn techniques to fix commit messages after they've been created.

### Local Commit Message Fixes

#### Fix Last Commit Message
```bash
# Amend the most recent commit message
git commit --amend -m "Corrected commit message"

# Open editor to fix message
git commit --amend
```

#### Fix Specific Commit Message
```bash
# Interactive rebase to fix older commits
git rebase -i HEAD~3

# Change 'pick' to 'reword' for commit to fix
# Save and enter new message when prompted
```

### Remote Commit Fixes

#### Force Push After Local Fix
```bash
# WARNING: Changes commit history
git commit --amend -m "Fixed message"
git push --force-with-lease origin branch-name
```

#### Safe Remote Fix (Create New Commit)
```bash
# Preferred: Create new commit with correction
git commit --allow-empty -m "fix: correct previous commit message

This commit fixes the message in commit abc1234"
```

### Best Practices
- Fix messages before pushing when possible
- Use `--force-with-lease` instead of `--force`
- Communicate with team before force pushing
- Consider new commit for shared branches

### Observations
- Commit message updated successfully
- Commit hash may change (amend creates new commit)
- Remote repository updated after force push
- Team members may need to fetch updated history

---

## Session 28: How to Fork a Repo

### Creating Personal Copies of Repositories

Master the fork workflow for contributing to open source projects.

### Forking Process

#### GitHub Web Interface
1. Navigate to target repository
2. Click "Fork" button (top-right)
3. Select your account as destination
4. Choose to copy only main branch or all branches
5. Click "Create fork"

#### Understanding Forks
- Creates personal copy under your account
- Independent from original repository
- Can make changes without affecting original
- Enables contribution workflow

### Post-Fork Workflow

#### Clone Your Fork
```bash
# Clone your fork to local machine
git clone https://github.com/yourusername/original-repo.git
cd original-repo

# Add original as upstream remote
git remote add upstream https://github.com/originalowner/original-repo.git

# Verify remotes
git remote -v
```

#### Keep Fork Updated
```bash
# Fetch upstream changes
git fetch upstream

# Merge upstream changes into your fork
git checkout main
git merge upstream/main

# Push updates to your fork
git push origin main
```

### Contribution Workflow
1. Fork original repository
2. Clone your fork locally
3. Create feature branch
4. Make changes and commit
5. Push to your fork
6. Create pull request from fork to original

### Observations
- Fork appears under your GitHub account
- Original repository remains unchanged
- Upstream remote provides connection to original
- Can contribute to projects without direct access

---

## Session 29: Git Issues

### Using GitHub Issues for Project Management

Learn to create, manage, and utilize GitHub Issues effectively.

### Creating Issues

#### GitHub Web Interface
1. Navigate to repository
2. Click "Issues" tab
3. Click "New issue" button
4. Fill in title and description
5. Add labels, assignees, milestones
6. Submit issue

#### Issue Description Best Practices
```markdown
## Description
Clear explanation of the issue or feature request.

## Steps to Reproduce (for bugs)
1. Step one
2. Step two
3. Expected vs actual behavior

## Additional Context
Screenshots, error messages, environment details.
```

### Issue Management

#### Labels and Organization
- Create custom labels for categorization
- Use color coding for visual organization
- Apply multiple labels per issue
- Common categories: bug, feature, documentation, help wanted

#### Assignees and Milestones
- Assign issues to team members
- Group issues into project milestones
- Track progress toward releases
- Set due dates for deliverables

### Issue References in Commits
```bash
# Reference issue in commit
git commit -m "Fix login validation

Closes #42"

# Reference without closing
git commit -m "Work on authentication

Refs #42"
```

### Issue Templates
Create `.github/ISSUE_TEMPLATE.md`:
```markdown
---
name: Bug report
about: Report a bug in the application
---

**Describe the bug**
A clear description of the bug.

**To Reproduce**
Steps to reproduce the behavior.

**Expected behavior**
What you expected to happen.

**Screenshots**
Add screenshots if applicable.
```

### Observations
- Issues track project tasks and bugs
- Labels provide visual organization
- Issue references connect commits to tasks
- Templates ensure consistent issue reporting

---

## Session 30: How to Open a Pull Request

### Creating Pull Requests for Code Review

Master the pull request workflow for proposing code changes.

### Pull Request Creation

#### GitHub Web Interface
1. Navigate to your fork or branch
2. Click "Compare & pull request" button
3. Or go to "Pull requests" → "New pull request"
4. Select base branch (destination)
5. Select compare branch (source)
6. Review changes and create PR

#### Pull Request Best Practices

#### Descriptive Titles
- Use action verbs: "Add", "Fix", "Update", "Remove"
- Include issue references: "Fix login bug (#42)"
- Be specific about the change scope

#### Comprehensive Descriptions
```markdown
## Summary
Brief description of changes made.

## Changes
- Change 1: description
- Change 2: description
- Change 3: description

## Testing
- [ ] Unit tests added/updated
- [ ] Manual testing completed
- [ ] All tests pass

## Related Issues
Closes #42
Refs #43

## Screenshots
Before/after images if UI changes
```

### Pull Request Workflow

#### Local Preparation
```bash
# Ensure branch is up to date
git checkout feature-branch
git fetch upstream
git rebase upstream/main

# Push updates
git push origin feature-branch
```

#### Review Process
- Request specific reviewers
- Add appropriate labels
- Link related issues
- Address review feedback
- Update branch as needed

#### Merging Strategies
- **Merge commit**: Preserves complete history
- **Squash and merge**: Combines into single commit
- **Rebase and merge**: Maintains linear history

### Observations
- Pull request shows all commits and changes
- Reviewers can comment on specific lines
- CI/CD checks run automatically
- Merge blocked until requirements met

---

## Session 31: Undoing a Commit

### Reversing Commit Mistakes

Learn various methods to undo commits at different stages.

### Local Commit Undo Options

#### Amend Last Commit
```bash
# Add changes to last commit
git add forgotten-file.txt
git commit --amend --no-edit

# Or update commit message too
git commit --amend -m "Updated commit message"
```

#### Reset Commits (Destructive)

#### Soft Reset (Keep Changes)
```bash
# Move HEAD back, keep changes staged
git reset --soft HEAD~1

# Move back multiple commits
git reset --soft HEAD~3
```

#### Mixed Reset (Default)
```bash
# Move HEAD back, unstage changes but keep files
git reset HEAD~1
```

#### Hard Reset (Destroy Changes)
```bash
# WARNING: Destroys all changes
git reset --hard HEAD~1

# Reset to specific commit
git reset --hard a1b2c3d
```

### Remote Commit Undo

#### Revert Commit (Safe)
```bash
# Create new commit that undoes changes
git revert HEAD

# Revert specific commit
git revert a1b2c3d

# Revert without opening editor
git revert --no-edit HEAD
```

#### Force Push After Reset
```bash
# WARNING: Rewrites remote history
git reset --hard HEAD~1
git push --force-with-lease origin branch-name
```

### Choosing the Right Method

#### Use Amend When:
- Last commit not pushed
- Adding forgotten changes
- Fixing commit message

#### Use Revert When:
- Commit already pushed
- Want to preserve history
- Working with shared branches

#### Use Reset When:
- Commit not pushed
- Want to completely remove commit
- Comfortable with destructive operation

### Observations
- Appropriate undo method selected for situation
- Working directory state matches expectations
- Remote repository updated correctly
- No unintended data loss occurred

---

## Session 32: Force Pushing

### Understanding Force Push Operations

Master safe force pushing techniques for repository maintenance.

### Force Push Commands

#### Safe Force Push
```bash
# Recommended: Checks for new commits first
git push --force-with-lease origin branch-name

# Alternative syntax
git push --force-with-lease
```

#### Destructive Force Push
```bash
# WARNING: Overwrites remote without checking
git push --force origin branch-name
```

### Safe Force Push Workflow

#### Scenario: Fixing Recent Commit
```bash
# 1. Make correction locally
git commit --amend -m "Corrected commit message"

# 2. Check remote state
git fetch origin

# 3. Safe force push
git push --force-with-lease origin main

# 4. Verify remote updated
git log --oneline origin/main
```

#### Using Force Push with Lease
- Compares local and remote commit history
- Prevents accidental overwrite of others' work
- More specific error messages
- Recommended for all force push operations

### Common Force Push Scenarios

#### Fixing Commit Messages
```bash
git commit --amend -m "Fixed typo in message"
git push --force-with-lease
```

#### Removing Sensitive Data
```bash
# After removing secrets from files
git add .
git commit --amend --no-edit
git push --force-with-lease
```

#### Cleaning Up Local History
```bash
# Interactive rebase to clean history
git rebase -i HEAD~5
# Edit as needed, then:
git push --force-with-lease
```

### Safety Considerations
- Always communicate with team before force pushing
- Use `--force-with-lease` instead of `--force`
- Consider impact on other developers
- Document force push reasons in commit messages

### Observations
- Remote history updated to match local
- No conflicts with other developers' work
- Repository state consistent across clones
- Team workflow not disrupted unexpectedly

---

## Session 33: How to Rebase

### Streamlining Commit History with Rebase

Master interactive rebasing for clean, professional commit histories.

### Basic Rebase Operations

#### Standard Rebase
```bash
# Rebase current branch onto another
git rebase main

# Rebase onto specific commit
git rebase a1b2c3d
```

#### Handling Conflicts
```bash
# Resolve conflicts in each file
# Edit files to resolve merge markers
git add resolved-file.txt

# Continue rebase
git rebase --continue

# Skip problematic commit
git rebase --skip

# Abort entire rebase
git rebase --abort
```

### Interactive Rebase

#### Start Interactive Rebase
```bash
# Rebase last N commits
git rebase -i HEAD~3

# Rebase since specific commit
git rebase -i a1b2c3d
```

#### Interactive Rebase Commands
```
pick a1b2c3d Add user authentication
pick b2c3d4e Fix login validation
pick c3d4e5f Update user interface

# Commands:
# p, pick = use commit
# r, reword = use commit, edit message
# e, edit = use commit, stop for amending
# s, squash = use commit, meld into previous
# f, fixup = like squash, discard message
# d, drop = remove commit
```

### Practical Rebase Examples

#### Clean Up Commit Messages
```
pick a1b2c3d Add authentication system
reword b2c3d4e Typo fix          # Change to 'fixup'
pick c3d4e5f Add user dashboard

# Results in cleaner history
```

#### Combine Related Commits
```
pick a1b2c3d Add user model
squash b2c3d4e Add user tests
squash c3d4e5f Fix user validation

# Results in single "Add user model" commit
```

### Rebase vs Merge

#### Rebase Advantages
- Cleaner, linear history
- Easier to follow commit progression
- Professional appearance
- Eliminates merge commit noise

#### Merge Advantages
- Preserves complete development history
- Shows parallel development clearly
- Safer for shared branches
- Maintains context of feature development

### Best Rebase Practices
- Rebase only local/unpushed commits
- Avoid rebasing shared/pushed commits
- Communicate with team about rebase operations
- Use merge for integrating shared branches

### Observations
- Commit history appears cleaner and more organized
- Related commits consolidated appropriately
- No functional changes to code
- History tells clearer development story

---

## Session 34: Resolving Merge and Rebase Conflicts

### Mastering Conflict Resolution

Develop expertise in handling merge conflicts professionally and efficiently.

### Understanding Conflicts

#### When Conflicts Occur
- Same lines modified in different branches
- Files deleted in one branch, modified in another
- Binary files with conflicting changes
- Complex refactoring across branches

#### Conflict Markers
```text
<<<<<<< HEAD
Your changes (current branch)
=======
Incoming changes (branch being merged)
>>>>>>> branch-name
```

### Conflict Resolution Workflow

#### 1. Identify Conflicts
```bash
# During merge/rebase, conflicts are marked
git status
# Shows "both modified" files
```

#### 2. Resolve Each Conflict

#### Manual Resolution
```text
<<<<<<< HEAD
function calculateTotal(items) {
    return items.reduce((sum, item) => sum + item.price, 0);
}
=======
function calculateTotal(items) {
    let total = 0;
    for (let item of items) {
        total += item.price;
    }
    return total;
}
>>>>>>> feature-branch
```

#### Choose Resolution
```text
# Keep current branch version
function calculateTotal(items) {
    return items.reduce((sum, item) => sum + item.price, 0);
}
```

#### 3. Mark as Resolved
```bash
# After editing conflicts
git add resolved-file.js

# Verify no remaining conflicts
git status
```

#### 4. Complete Operation
```bash
# For merge
git commit -m "Resolve merge conflicts"

# For rebase
git rebase --continue
```

### Advanced Conflict Resolution

#### Using Mergetool
```bash
# Configure mergetool
git config --global merge.tool vscode

# Launch mergetool for conflicts
git mergetool
```

#### Abort Operations
```bash
# Cancel merge in progress
git merge --abort

# Cancel rebase in progress
git rebase --abort
```

### Conflict Prevention Strategies

#### Frequent Integration
```bash
# Regularly merge main into feature branches
git checkout feature-branch
git merge main
```

#### Clear Communication
- Coordinate with team on file ownership
- Use feature flags for experimental code
- Establish coding standards and patterns

#### Smaller, Focused Commits
- Limit scope of each commit
- Reduce conflict probability
- Easier conflict identification

### Observations
- All conflicts resolved without data loss
- Resolution strategy appropriate for changes
- Clean merge/rebase completion achieved
- Repository state consistent and functional

---

## Session 35: How to Stash Code

### Temporary Storage with Git Stash

Master stashing for managing work-in-progress across branches and contexts.

### Basic Stash Operations

#### Create Stash
```bash
# Stash all changes (tracked files only)
git stash

# Stash with descriptive message
git stash push -m "Work in progress on login feature"

# Stash including untracked files
git stash -u
git stash push -u -m "Complete work state"
```

#### List Stashes
```bash
# View all stashes
git stash list

# Output example:
# stash@{0}: WIP on feature-login: a1b2c3d Add authentication
# stash@{1}: On main: b2c3d4e Fix header styling
```

#### Apply Stashes
```bash
# Apply most recent stash (keeps in stash list)
git stash apply

# Apply specific stash
git stash apply stash@{1}

# Apply and remove from stash list
git stash pop

# Apply specific stash and remove
git stash pop stash@{0}
```

### Advanced Stash Management

#### Stash Specific Files
```bash
# Stash only certain files
git stash push -m "Database config" config/database.yml

# Stash specific file patterns
git stash push *.js -m "JavaScript changes"
```

#### View Stash Contents
```bash
# Show what a stash contains
git stash show

# Show changes in specific stash
git stash show stash@{1}

# Show detailed diff of stash
git stash show -p stash@{0}
```

#### Manage Stash List
```bash
# Remove specific stash
git stash drop stash@{1}

# Clear entire stash list
git stash clear

# Create branch from stash
git stash branch new-feature-branch stash@{0}
```

### Practical Stash Workflows

#### Quick Context Switch
```bash
# Current branch work needs to pause
git stash push -m "Paused login feature work"

# Switch to urgent fix branch
git checkout hotfix-branch

# Complete hotfix work...

# Return to original branch
git checkout feature-login
git stash pop
```

#### Experiment Safely
```bash
# Stash current work
git stash push -m "Before experimental changes"

# Try experimental approach
git add .
git commit -m "Experimental feature implementation"

# If experiment fails, return to stashed state
git reset --hard HEAD~1
git stash pop
```

### Stash Best Practices
- Use descriptive messages for clarity
- Don't accumulate too many stashes
- Apply stashes promptly to avoid conflicts
- Consider creating branches for complex stashed work

### Observations
- Working directory cleaned after stashing
- Changes preserved and recoverable
- Can switch contexts without losing work
- Stash contents match original working state

---

## Session 36: Adding Tags to Your Commits

### Version Control with Git Tags

Master tagging for marking releases, versions, and significant milestones.

### Tag Types and Creation

#### Lightweight Tags
```bash
# Create simple tag pointing to commit
git tag v1.0.0

# Tag specific commit
git tag v1.0.1 a1b2c3d4

# Create tag with message
git tag -a v1.0.2 -m "Release version 1.0.2"
```

#### Annotated Tags
```bash
# Create annotated tag (recommended)
git tag -a v2.0.0 -m "Major release with new API"

# Create annotated tag for specific commit
git tag -a v1.5.0 a1b2c3d4 -m "Bug fix release"
```

### Viewing and Managing Tags

#### List Tags
```bash
# List all tags
git tag

# List tags with messages
git tag -n

# Search tags by pattern
git tag -l "v1.*"
git tag -l "*beta*"
```

#### View Tag Details
```bash
# Show tag information
git show v1.0.0

# Show tag commit only
git rev-parse v1.0.0
```

### Working with Remote Tags

#### Push Tags
```bash
# Push specific tag
git push origin v1.0.0

# Push all tags
git push origin --tags

# Push annotated tag
git push origin v2.0.0
```

#### Delete Tags
```bash
# Delete local tag
git tag -d v1.0.0

# Delete remote tag
git push origin --delete v1.0.0

# Delete multiple tags
git tag -d v1.0.0 v1.0.1 v1.0.2
git push origin --delete v1.0.0 v1.0.1 v1.0.2
```

### Release Tagging Workflow

#### Pre-Release Process
```bash
# Ensure on correct branch
git checkout main

# Verify clean working directory
git status

# Create release tag
git tag -a v3.0.0 -m "Release v3.0.0: Major UI overhaul

Features:
- New dashboard design
- Improved performance
- Enhanced security

Bug Fixes:
- Fixed login redirect issue
- Resolved mobile display problems"
```

#### Post-Release
```bash
# Push tag to remote
git push origin v3.0.0

# Create release branch if needed
git checkout -b release/v3.0.0
```

### Tag Best Practices
- Use semantic versioning (MAJOR.MINOR.PATCH)
- Create annotated tags for releases
- Tag at stable, tested points
- Document tag purpose in messages
- Consider tag naming conventions

### Observations
- Tags created at specific commit points
- Release versions clearly marked
- Tags available for checkout and reference
- Remote repository synchronized with local tags

---

## Session 37: Project Summary

### Course Completion Overview

Consolidate your Git expertise with a comprehensive project summary and review.

### Skills Mastered

#### Fundamentals
- Command line Git proficiency over GUI tools
- Complete understanding of version control concepts
- Professional workflow establishment

#### Core Operations
- Repository initialization and cloning
- Branching, merging, and rebasing workflows
- Commit management and history navigation
- Remote repository synchronization

#### Advanced Techniques
- Conflict resolution strategies
- Stashing and context switching
- Tagging and release management
- Pull request workflows

#### Professional Practices
- SSH key authentication
- Code review participation
- Issue tracking integration
- Documentation standards

### Key Commands Reference
```bash
# Essential daily commands
git status              # Check repository state
git add .              # Stage changes
git commit -m "msg"    # Create commit
git push               # Upload to remote
git pull               # Download and merge
git branch             # Manage branches
git checkout branch    # Switch branches
git merge branch       # Integrate branches
git log --oneline      # View history
```

### Professional Readiness Indicators

#### Portfolio Development
- Active GitHub presence with consistent contributions
- Clean commit history and professional practices
- Open source contribution experience
- Documentation and collaboration skills

#### Team Collaboration
- Pull request workflow mastery
- Code review participation
- Branch management strategies
- Conflict resolution capabilities

#### Deployment Readiness
- SSH authentication configured
- Remote repository management
- Release tagging practices
- Production deployment workflows

### Observations
- Comprehensive Git skill set achieved
- Ready for professional development roles
- Foundation for advanced Git topics
- Prepared for open source contribution

---

## Session 38: Final Lesson

### Course Conclusion and Next Steps

Complete your Git journey with final insights and pathways for continued growth.

### Course Achievement Summary

#### Technical Proficiency
- Command-line Git mastery for any environment
- Complete understanding of distributed version control
- Professional workflow implementation skills

#### Career Readiness
- Essential developer tool competency achieved
- GitHub portfolio development capabilities
- Team collaboration and code review expertise
- Open source contribution preparation

### Continued Learning Paths

#### Advanced Git Topics
- Git hooks and automation
- Submodules and subtrees
- Advanced rebasing strategies
- Repository maintenance and cleanup

#### Related Technologies
- Continuous Integration/Deployment workflows
- GitOps practices and tooling
- Alternative Git hosting platforms
- Git-based project management

#### Professional Development
- Contributing to major open source projects
- Mentoring other developers in Git workflows
- Establishing team Git standards and practices
- Advanced troubleshooting and repository recovery

### Final Recommendations

#### Daily Practice
- Use Git for all projects, personal and professional
- Maintain clean, descriptive commit histories
- Participate actively in code reviews
- Document processes and share knowledge

#### Community Engagement
- Contribute to open source projects regularly
- Share Git tips and workflows with colleagues
- Stay updated with Git best practices
- Build professional network through contributions

### Observations
- Complete Git competency achieved for professional development
- Strong foundation for career advancement in software development
- Prepared to contribute effectively to any development team
- Ready to tackle complex version control challenges confidently

---

## Tips and Tricks

### Command Line Efficiency
- Use `git status -s` for compact status view during active development
- Configure useful aliases: `git config --global alias.st "status -s"`
- Use `git add -p` for interactive staging of specific changes
- Leverage `git diff --stat` for quick overview of change scope

### Branch Management
- Use descriptive branch names: `feature/user-authentication` not `feature1`
- Delete local branches after merging: `git branch -d feature-name`
- Regularly prune remote tracking branches: `git remote prune origin`
- Use `git branch -vv` to see tracking relationships

### History Navigation
- Use `git log --follow filename` to track file renames
- Leverage `git log --all --source --remotes --source` for complete history
- Use `git show :/search-term` to find commits by message content
- Bookmark important commits with tags for easy reference

### Conflict Resolution
- Set up a good merge tool: `git config --global merge.tool vscode`
- Use `git diff --name-only --diff-filter=U` to list conflicted files
- Add conflict marker patterns to `.gitignore` for generated files
- Consider `git rerere` for repeated conflict resolutions

### Remote Repository Management
- Use SSH keys for seamless authentication without passwords
- Regularly fetch to stay updated: `git fetch --all --prune`
- Leverage `git remote show origin` for detailed remote information
- Use `git push --force-with-lease` instead of `--force` for safety

### Workflow Optimization
- Implement meaningful commit messages following conventional format
- Use interactive rebase (`git rebase -i`) before creating pull requests
- Create `.gitmessage` template for consistent commit formatting
- Set up shell autocompletion for Git commands

### Repository Health
- Regularly run `git fsck` to check repository integrity
- Use `git count-objects -vH` to monitor repository size
- Implement `.gitignore` comprehensively from project start
- Consider `git gc` periodically for repository optimization

### Professional Practices
- Never force push to shared branches without team communication
- Use draft pull requests for work-in-progress code sharing
- Implement branch protection rules for production branches
- Document team Git workflows in repository wiki or README

### Cross-Platform Considerations
- Use forward slashes in paths for cross-platform compatibility
- Configure line ending handling: `git config --global core.autocrlf input`
- Use relative paths in scripts for portability
- Test Git workflows on all target platforms

### Security Best Practices
- Never commit sensitive data (API keys, passwords, certificates)
- Use `.gitignore` to exclude environment files
- Regularly audit repository history for accidentally committed secrets
- Implement git-secrets or similar tools for proactive secret detection

---

*This lab guide provides comprehensive coverage of Git essentials based on practical, command-line focused training. Each session builds upon previous knowledge to develop professional-grade version control skills essential for modern software development careers.*