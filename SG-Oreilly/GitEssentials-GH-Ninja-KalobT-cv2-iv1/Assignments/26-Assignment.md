<details open>
<summary><b> Session 26: How to Ignore Files</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Exercise 1.1: Understand the Problem with Unwanted Files
**Objective**: Recognize why certain files should not be committed to repositories

**Tasks**:
1. Create example scenarios of unwanted files:
   - System files (.DS_Store on Mac, Thumbs.db on Windows)
   - Editor/IDE files (.idea/, .vscode/, *.swp)
   - Personal notes (.todo, NOTES.txt)
   - Build artifacts (*.log, /dist/, /build/)
   - Temporary files (*.tmp, *.bak)
2. Document why each type should be ignored
3. Explain the problem with `git add .` when these files exist

**Documentation**:
```markdown
# Files That Should Be Ignored

## System Files
- .DS_Store: [Explanation]
- Thumbs.db: [Explanation]

## Personal Files
- .todo: [Why personal todos shouldn't be shared]

## Build Artifacts
- /dist/: [Generated files shouldn't be versioned]

## The Problem
Using `git add .` would add all these unwanted files...
```

**Deliverable**: Comprehensive documentation of file types that should be ignored

## Exercise 1.2: Create Your First .gitignore File
**Objective**: Create and understand the basic structure of a .gitignore file

**Tasks**:
1. Create a `.gitignore` file in your repository root
2. Add ignore patterns for:
   - `.todo` files (personal task lists)
   - `.DS_Store` files (Mac system files)
   - `*.jpg` and `*.jpeg` files (specific image types)
3. Ensure the syntax is correct (no extra spaces, proper wildcards)
4. Document each pattern with comments

**Commands**:
```bash
cat > .gitignore << 'EOF'
# Personal todo files
*.todo

# Mac system files
.DS_Store

# Ignore specific image formats
*.jpg
*.jpeg
EOF
```

**Deliverable**: Properly formatted .gitignore file with documented patterns

## Exercise 1.3: Test .gitignore Effectiveness
**Objective**: Verify that .gitignore is working correctly

**Tasks**:
1. Create test files that should be ignored:
   - `my-tasks.todo`
   - `.DS_Store`
   - `screenshot.jpg`
   - `photo.jpeg`
2. Create a control file that should NOT be ignored:
   - `important.png`
   - `document.pdf`
3. Run `git status` and verify:
   - Ignored files do NOT appear
   - Control files DO appear
4. Document the results

**Commands**:
```bash
# Create test files
touch my-tasks.todo .DS_Store screenshot.jpg photo.jpeg
touch important.png document.pdf

# Check status
git status

# Verify ignored files are hidden
ls -la  # Should show all files
git status  # Should not show ignored files
```

**Deliverable**: Test results showing .gitignore correctly filtering files

## Exercise 2.1: Common .gitignore Patterns
**Objective**: Learn standard patterns used in professional .gitignore files

**Tasks**:
1. Create a comprehensive .gitignore with common patterns:
   ```gitignore
   # Dependencies
   node_modules/
   vendor/

   # Build outputs
   dist/
   build/
   *.min.js

   # IDE/Editor files
   .idea/
   .vscode/
   *.swp
   *~

   # OS generated files
   .DS_Store
   Thumbs.db

   # Logs
   *.log
   logs/

   # Environment files
   .env
   .env.local
   ```
2. Group patterns logically with comments
3. Test each pattern category

**Deliverable**: Professional-grade .gitignore with organized pattern categories

## Exercise 2.2: Pattern Syntax Mastery
**Objective**: Master advanced .gitignore pattern syntax

**Tasks**:
1. Create test cases for different pattern types:
   - Exact filenames: `config.local`
   - Wildcards: `*.tmp`
   - Directory patterns: `cache/`
   - Negation patterns: `!important.tmp`
   - Path-specific: `src/temp/`
   - Root-specific: `/README.md`
2. Document how each pattern works
3. Create examples showing pattern scope

**Pattern Documentation**:
```markdown
# .gitignore Pattern Types

## Exact Match
config.local - Ignores only files named exactly "config.local"

## Wildcard
*.tmp - Ignores all files ending in .tmp anywhere in repo

## Directory
cache/ - Ignores the cache directory and everything in it

## Negation
!important.tmp - Even though *.tmp is ignored, this file will be included

## Path Specific
src/temp/ - Only ignores temp directory under src/

## Root Only
/README.md - Only ignores README.md in root, not in subdirectories
```

**Deliverable**: Comprehensive pattern syntax guide with examples

## Exercise 2.3: Multiple .gitignore Files
**Objective**: Understand how .gitignore works in subdirectories

**Tasks**:
1. Create a project structure with multiple directories
2. Create .gitignore files at different levels:
   - Root .gitignore for general ignores
   - Subdirectory .gitignore for specific needs
3. Test how patterns cascade and combine
4. Document the hierarchy behavior

**Commands**:
```bash
mkdir -p project/{frontend,backend,docs}
# Root .gitignore
echo "*.log" > .gitignore
# Frontend specific
echo "node_modules/" > project/frontend/.gitignore
# Backend specific
echo "__pycache__/" > project/backend/.gitignore
# Test the hierarchy
git check-ignore -v project/frontend/node_modules/test.js
```

**Deliverable**: Multi-level .gitignore structure with documentation of pattern inheritance

## Exercise 3.1: Share .gitignore with Repository
**Objective**: Commit and share .gitignore rules with team members

**Tasks**:
1. Add your .gitignore to version control
2. Commit the .gitignore file
3. Push to remote repository
4. Verify that clone operations respect the ignore rules
5. Document the process for team onboarding

**Commands**:
```bash
git add .gitignore
git status  # Should show .gitignore, not ignored files
git commit -m "Add .gitignore to exclude unwanted files"
git push origin master
```

**Deliverable**: .gitignore committed and pushed, with evidence it will work for clones

## Exercise 3.2: Create Project-Specific .gitignore Templates
**Objective**: Build reusable .gitignore templates for different project types

**Tasks**:
1. Create .gitignore templates for various project types:
   - **Node.js project**:
     ```gitignore
     node_modules/
     npm-debug.log
     .env
     dist/
     ```
   - **Python project**:
     ```gitignore
     __pycache__/
     *.py[cod]
     .env
     venv/
     ```
   - **Java/Maven project**:
     ```gitignore
     target/
     *.class
     .idea/
     *.iml
     ```
2. Document when to use each template
3. Create a selection guide

**Deliverable**: Collection of project-type-specific .gitignore templates

## Exercise 3.3: Troubleshooting .gitignore Issues
**Objective**: Learn to diagnose and fix common .gitignore problems

**Tasks**:
1. Create scenarios for common issues:
   - File already tracked when .gitignore is added
   - Pattern not working as expected
   - Case sensitivity issues
   - Whitespace problems in .gitignore
2. Document solutions for each:
   - `git rm --cached <file>` for already tracked files
   - Pattern debugging techniques
   - Verification commands
3. Create a troubleshooting guide

**Troubleshooting Guide**:
```markdown
# .gitignore Troubleshooting

## File Already Tracked
Problem: File was committed before adding to .gitignore
Solution:
git rm --cached <filename>
git commit -m "Stop tracking <filename>"

## Pattern Not Working
Debug commands:
git check-ignore -v <filename>
git check-ignore --no-index <filename>

## Case Sensitivity
Note: .gitignore patterns are case-sensitive on Linux/Mac
Solution: Include both cases if needed
*.log
*.LOG

## Whitespace Issues
Problem: Trailing spaces break patterns
Solution: Use visible character mode in editor
```

**Deliverable**: Comprehensive troubleshooting guide with solutions for common .gitignore issues

</details>
</details>