<details open>
<summary><b> Session 47: Ignoring Files</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Beginner Level

### Exercise 1.1: Understanding .gitignore
**Objective**: Learn the purpose and basic syntax of .gitignore files

**Tasks**:
1. Create a new directory called `gitignore-practice`
2. Initialize it as a Git repository
3. Create a `.gitignore` file that ignores:
   - `.DS_Store` files (Mac)
   - `Thumbs.db` files (Windows)
   - `*.log` files
4. Create sample files of each type and verify they are ignored

**Commands**:
```bash
mkdir gitignore-practice && cd gitignore-practice
git init
touch .gitignore
echo ".DS_Store" >> .gitignore
echo "Thumbs.db" >> .gitignore
echo "*.log" >> .gitignore
touch test.log .DS_Store Thumbs.db
git status
```

**Deliverable**: Screenshot showing ignored files not appearing in git status

### Exercise 1.2: Ignoring Folders
**Objective**: Practice ignoring entire directories and their contents

**Tasks**:
1. In the same repository, add rules to ignore:
   - `node_modules/` directory
   - `__pycache__/` directory
   - `.vscode/` directory
2. Create these directories with sample files inside
3. Verify the directories and their contents are ignored

**Commands**:
```bash
mkdir -p node_modules/__pycache__ .vscode
touch node_modules/package.json __pycache__/cache.pyc .vscode/settings.json
echo "node_modules/" >> .gitignore
echo "__pycache__/" >> .gitignore
echo ".vscode/" >> .gitignore
git status
```

**Deliverable**: .gitignore file showing proper folder ignore syntax with trailing slashes

### Exercise 1.3: Commit .gitignore File
**Objective**: Learn to commit the .gitignore file itself while ignoring specified files

**Tasks**:
1. Add only the `.gitignore` file to staging
2. Commit with message "Add .gitignore file"
3. Push to remote repository
4. Verify on GitHub that `.gitignore` is present but ignored files are not

**Commands**:
```bash
git add .gitignore
git status
git commit -m "Add .gitignore file"
git push origin master
```

**Deliverable**: GitHub repository showing `.gitignore` file in the root directory

## Intermediate Level

### Exercise 2.1: Language-Specific Gitignore Patterns
**Objective**: Create comprehensive .gitignore rules for a specific programming language

**Tasks**:
1. Create a new Python project directory
2. Create a `.gitignore` file with comprehensive Python ignore patterns:
   - Byte-compiled files (`*.py[cod]`, `*$py.class`)
   - Distribution directories
   - Virtual environments
   - IDE files
   - Test coverage files
3. Create sample files matching each pattern

**Commands**:
```bash
mkdir python-project && cd python-project
git init
cat > .gitignore << EOF
# Byte-compiled files
__pycache__/
*.py[cod]
*$py.class

# Distribution
dist/
build/
*.egg-info/

# Virtual environments
venv/
env/
.venv/

# IDE
.idea/
.vscode/
*.swp

# Testing
.coverage
htmlcov/
.pytest_cache/
EOF
```

**Deliverable**: Comprehensive Python `.gitignore` file with categorized sections

### Exercise 2.2: Selective File Ignoring with Negation
**Objective**: Use negation patterns to include specific files within ignored directories

**Tasks**:
1. Create a repository with logs directory structure
2. Ignore all `.log` files but keep specific important logs
3. Test the patterns with various log files

**Commands**:
```bash
mkdir -p logs/archive
touch logs/app.log logs/error.log logs/archive/old.log logs/important.log
cat > .gitignore << EOF
*.log
!logs/important.log
!logs/archive/*.log
EOF
git status
```

**Deliverable**: .gitignore demonstrating negation patterns with `!` prefix

### Exercise 2.3: Global Gitignore Configuration
**Objective**: Set up system-wide gitignore rules for personal preferences

**Tasks**:
1. Create a global `.gitignore_global` file in your home directory
2. Configure Git to use this global file
3. Add common patterns you want ignored across all projects
4. Test that both local and global patterns work together

**Commands**:
```bash
touch ~/.gitignore_global
git config --global core.excludesfile ~/.gitignore_global
echo ".DS_Store" >> ~/.gitignore_global
echo "*.swp" >> ~/.gitignore_global
echo "Thumbs.db" >> ~/.gitignore_global
git config --global core.excludesfile
```

**Deliverable**: Global gitignore configuration verified with `git config` command

## Advanced Level

### Exercise 3.1: Managing Multiple .gitignore Files
**Objective**: Work with nested .gitignore files in a complex project structure

**Tasks**:
1. Create a monorepo structure with multiple projects
2. Set up `.gitignore` files at different levels:
   - Root level for general ignores
   - Frontend subdirectory for frontend-specific ignores
   - Backend subdirectory for backend-specific ignores
3. Verify ignore patterns cascade properly

**Commands**:
```bash
mkdir -p my-monorepo/frontend/src my-monorepo/backend/src
cd my-monorepo
git init
echo "node_modules/" > .gitignore
echo "dist/" >> .gitignore
echo "*.log" >> .gitignore
echo "build/" > frontend/.gitignore
echo "*.map" >> frontend/.gitignore
echo "__pycache__/" > backend/.gitignore
echo "*.pyc" >> backend/.gitignore
git status
```

**Deliverable**: Repository structure with multiple `.gitignore` files and verification of proper ignoring

### Exercise 3.2: Creating Reusable Gitignore Templates
**Objective**: Build a template system for quickly setting up .gitignore files

**Tasks**:
1. Create a templates directory with language-specific gitignore snippets
2. Write a script that combines templates based on project type
3. Test the script with different project combinations

**Commands**:
```bash
mkdir -p gitignore-templates/{python,node,react}
# Create template files in each directory
cat > create-gitignore.sh << 'EOF'
#!/bin/bash
# Usage: ./create-gitignore.sh python node
touch .gitignore
for template in "$@"; do
    cat "gitignore-templates/$template/.gitignore" >> .gitignore
done
EOF
chmod +x create-gitignore.sh
```

**Deliverable**: Working script that generates `.gitignore` from templates

### Exercise 3.3: Troubleshooting Gitignore Issues
**Objective**: Diagnose and fix common .gitignore problems

**Tasks**:
1. Create a scenario where files are already tracked but should be ignored
2. Use Git commands to identify why files aren't being ignored
3. Remove files from tracking while keeping them locally
4. Verify the fix works correctly

**Commands**:
```bash
# Simulate tracked file that should be ignored
echo "debug.log" > .gitignore
touch debug.log
git add debug.log
git commit -m "Accidentally tracked log file"
# Now fix it
git rm --cached debug.log
git status
git commit -m "Remove debug.log from tracking"
# Verify
git check-ignore -v debug.log
```

**Deliverable**: Step-by-step documentation of fixing a tracked file that should be ignored

</details>
</details>