<details open>
<summary><b> Session 16: Demonstration Understanding .gitignore File</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Exercise 1.1: Create and Initialize a .gitignore File
**Objective**: Learn to create and commit a .gitignore file to the repository
**Tasks**:
1. Create a new Git repository
2. Create an empty .gitignore file
3. Verify it's initially shown as untracked
4. Stage and commit the .gitignore file
**Commands**:
```bash
mkdir gitignore-demo && cd gitignore-demo
git init
touch .gitignore
git status
git add .gitignore
git commit -m "Added .gitignore file"
git log --oneline
```
**Deliverable**: Repository with committed .gitignore file visible in commit history

## Exercise 1.2: Ignore a Specific File Using .gitignore
**Objective**: Learn to add rules to ignore specific files
**Tasks**:
1. Create a debug.log file with content
2. Observe it's shown as untracked by git status
3. Add `debug.log` rule to .gitignore
4. Verify the file is now ignored
**Commands**:
```bash
echo "$(date): debug logs" > debug.log
cat debug.log
git status
echo "debug.log" >> .gitignore
git status  # debug.log no longer appears
```
**Deliverable**: debug.log file ignored by Git despite existing in working directory

## Exercise 1.3: Commit Changes to .gitignore
**Objective**: Update and commit modifications to .gitignore
**Tasks**:
1. After modifying .gitignore, check git status
2. Stage the .gitignore changes
3. Commit with appropriate message
4. Verify clean working tree
**Commands**:
```bash
git status  # Shows .gitignore as modified
git add .gitignore
git commit -m "Modified .gitignore to ignore debug.log"
git status  # Should show clean working tree
```
**Deliverable**: Updated .gitignore committed to repository

## Exercise 2.1: Use Wildcard Patterns in .gitignore
**Objective**: Master wildcard patterns for ignoring multiple files
**Tasks**:
1. Create error.log and system.log files
2. Add `*.log` pattern to .gitignore
3. Verify all .log files are ignored
4. Create a new .log file and confirm it's also ignored
**Commands**:
```bash
echo "error logs" > error.log
echo "system logs" > system.log
git status  # Shows error.log but not debug.log
echo "*.log" >> .gitignore
git status  # Neither log file appears
echo "new log entry" > new.log
git status  # new.log also ignored
```
**Deliverable**: All .log files ignored using single wildcard pattern

## Exercise 2.2: Ignore Entire Directories
**Objective**: Learn to ignore folders/directories in .gitignore
**Tasks**:
1. Create a node_modules directory with files
2. Create a temp directory
3. Add directory ignore rules to .gitignore
4. Verify directories and their contents are ignored
**Commands**:
```bash
mkdir -p node_modules temp
echo "node content" > node_modules/package.json
echo "temp file" > temp/cache.tmp
echo "node_modules/" >> .gitignore
echo "temp/" >> .gitignore
git status  # Directories not shown as untracked
```
**Deliverable**: Entire directories ignored by Git

## Exercise 2.3: Ignore OS-Specific Files
**Objective**: Learn common patterns for ignoring system-specific files
**Tasks**:
1. Understand OS-specific files like .DS_Store (macOS) and Thumbs.db (Windows)
2. Add OS-specific ignore rules to .gitignore
3. Create simulated system files
4. Verify they are ignored
**Commands**:
```bash
echo ".DS_Store" >> .gitignore
echo "Thumbs.db" >> .gitignore
echo "temp files" > .DS_Store
echo "windows cache" > Thumbs.db
git status  # System files not tracked
```
**Deliverable**: OS-specific files properly ignored

## Exercise 3.1: Use Exception Rules in .gitignore
**Objective**: Learn to use exclamation marks for exceptions
**Tasks**:
1. Add a rule to ignore all .log files
2. Create an exception to track important.log
3. Verify the exception works correctly
**Commands**:
```bash
echo "*.log" >> .gitignore
echo "!important.log" >> .gitignore
echo "normal log" > normal.log
echo "important information" > important.log
git status  # Shows important.log but not normal.log
```
**Deliverable**: Exception rule allowing specific file to be tracked despite pattern

## Exercise 3.2: Create Comprehensive .gitignore for a Project
**Objective**: Build a practical .gitignore file for a typical project
**Tasks**:
1. Create rules for: logs, build directories, dependencies, IDE files, OS files
2. Test each rule with sample files/directories
3. Commit the comprehensive .gitignore
**Commands**:
```bash
cat > .gitignore << EOF
# Logs
*.log
logs/

# Build directories
dist/
build/
target/

# Dependencies
node_modules/
vendor/

# IDE
.vscode/
.idea/
*.swp

# OS
.DS_Store
Thumbs.db
EOF
git add .gitignore
git commit -m "Added comprehensive .gitignore for project"
```
**Deliverable**: Professional .gitignore file with categorized rules

## Exercise 3.3: Verify .gitignore Location and Best Practices
**Objective**: Understand proper .gitignore placement and maintenance
**Tasks**:
1. Confirm .gitignore is in repository root
2. Create nested directories and test inheritance
3. Document best practices for .gitignore
**Commands**:
```bash
ls -la  # Confirm .gitignore in root
mkdir -p src/components
echo "test.log" > src/components/test.log
git status  # Should be ignored in subdirectory too
git log --oneline -5  # View .gitignore commit history
```
**Deliverable**: Understanding of .gitignore placement and pattern inheritance

</details>

</details>