# Day-03 Assignments: Python Environment Setup and Tool Configuration

## Learning Objectives
- Master UV for Python version management
- Navigate file systems using command line
- Configure development environments properly
- Understand project structure best practices
- Use Python interpreter and basic commands

---

## Beginner Level

### Exercise 1: Command Line Navigation Basics
**Objective:** Master basic terminal commands
1. Create the following folder structure:
   ```
   MyDataScience/
   ├── Level1/
   │   ├── practice/
   │   └── exercises/
   └── Level2/
       └── projects/
   ```
2. Using only command line commands:
   - Navigate from root to Level1/exercises
   - Go back to Level1
   - Move to MyDataScience root
   - List all contents at each level

### Exercise 2: UV Python Installation
**Objective:** Install and verify Python versions
1. Check if UV is installed: `uv --version`
2. Install Python 3.11 using UV
3. Verify installation: `uv run python --version`
4. List all installed Python versions
5. Document the output of each command

### Exercise 3: Python Interpreter Basics
**Objective:** Understand Python interpreter interaction
1. Start Python interpreter using `uv run python`
2. Perform these operations in the interpreter:
   ```python
   2 + 2
   print("Hello, Data Science!")
   10 / 3
   10 // 3
   ```
3. Exit using `exit()`
4. Screenshot your session

---

## Intermediate Level

### Exercise 4: Environment Pinning Strategy
**Objective:** Master Python version pinning
1. Create three separate projects:
   - Project A: Pin Python 3.10
   - Project B: Pin Python 3.11
   - Project C: Pin Python 3.12
2. For each project:
   - Create folder structure
   - Pin appropriate Python version
   - Verify the pinned version
   - Create a requirements.txt with: `uv pip freeze > requirements.txt`

### Exercise 5: Terminal Power User
**Objective:** Efficient command line usage
Complete these tasks using only terminal:
1. Create a project folder with current date (YYYY-MM-DD format)
2. Inside it, create 5 subfolders named Day1 through Day5
3. Navigate between folders using relative and absolute paths
4. Use `cls`/`clear` appropriately
5. Create an empty file named `notes.txt` in each folder
6. List files with different sorting options

### Exercise 6: VS Code Integration
**Objective:** Optimize VS Code for Python development
1. Configure VS Code settings:
   - Set default terminal to Command Prompt (Windows) / appropriate shell
   - Enable line numbers
   - Set Python interpreter path
2. Create a workspace with:
   - Multiple folders open
   - Custom settings.json
   - Terminal split view
3. Document your configuration

---

## Advanced Level

### Exercise 7: Multi-Version Management
**Objective:** Handle multiple Python versions efficiently
1. Install Python versions: 3.9, 3.10, 3.11, 3.12
2. Create a comparison table:
   | Version | Installation Time | Size | Key Features |
   |---------|------------------|------|--------------|
   | 3.9     | ?                | ?    | ?            |
   | ...     | ...              | ...  | ...          |
3. Test running different versions:
   ```bash
   uv run --python 3.9 python -c "import sys; print(sys.version)"
   uv run --python 3.12 python -c "import sys; print(sys.version)"
   ```
4. Handle version conflicts scenario

### Exercise 8: Project Structure Design
**Objective:** Design professional project layouts
Create a template structure for data science projects:
```
project_name/
├── .venv/                 # Virtual environment
├── data/
│   ├── raw/
│   ├── processed/
│   └── external/
├── notebooks/
├── src/
│   └── project_name/
├── tests/
├── docs/
├── config/
├── scripts/
├── requirements/
│   ├── base.txt
│   ├── dev.txt
│   └── prod.txt
├── .gitignore
├── README.md
└── pyproject.toml
```
1. Create this structure using commands
2. Add appropriate .gitignore entries
3. Document why each folder exists

### Exercise 9: Automation Scripts
**Objective:** Create setup automation
Write a batch/shell script that:
1. Creates a new project with given name
2. Sets up proper folder structure
3. Installs and pins Python version
4. Creates virtual environment
5. Initializes git repository
6. Creates basic README

---

## Expert Level

### Exercise 10: Environment Troubleshooting
**Objective:** Diagnose and fix environment issues
Given scenarios, provide solutions:
1. "UV command not found after installation"
2. "Python version not switching after pin"
3. "Module not found in new environment"
4. "Path issues on Windows vs Mac"
5. "Conflicting Python installations"
Create troubleshooting guides with commands and explanations.

### Exercise 11: Performance Optimization
**Objective:** Optimize environment for data science workloads
1. Benchmark different Python versions for:
   - Simple calculations (1M iterations)
   - File I/O operations
   - Memory usage patterns
2. Compare UV vs traditional pip performance
3. Document findings with metrics
4. Recommend optimal setup based on results

### Exercise 12: CI/CD Environment Setup
**Objective:** Prepare environments for production
Design an environment configuration system:
1. Create environment templates for:
   - Development (with debug tools)
   - Testing (minimal dependencies)
   - Production (optimized, secure)
2. Version control your configurations
3. Create documentation for team onboarding
4. Design rollback procedures

---

## Practical Challenges

### Challenge A: "Lost in Directories"
Start from any location, reach target using only:
- `cd` with relative paths
- `cd` with absolute paths
- `pwd` to verify location
Document your path choices.

### Challenge B: "Version Detective"
Given output from `uv python list`, identify:
- Which versions are installed vs available
- How to switch between versions
- Best practices for version selection

### Challenge C: "Clean Slate"
Your system has conflicting Python installations. Create a plan to:
1. Identify all Python installations
2. Choose primary version
3. Configure UV to manage everything
4. Ensure VS Code uses correct version
5. Document the entire process

---

## Quick Reference Commands

### UV Commands
```bash
uv python install <version>    # Install Python version
uv python pin <version>        # Pin version for project
uv python list                 # List all versions
uv run python                  # Run Python with pinned version
uv pip install <package>       # Install package
uv pip freeze > requirements.txt  # Export dependencies
```

### Navigation Commands
```bash
cd <folder>        # Change directory
cd ..              # Go up one level
cd /               # Go to root (Unix) or C:\ (Windows)
pwd                # Print working directory
ls / dir           # List contents
cls / clear        # Clear screen
```

### VS Code Terminal
- `Ctrl+`` - Toggle terminal
- `Ctrl+Shift+5` - Split terminal
- Select shell from dropdown

## Success Criteria
- [ ] Can navigate any directory structure
- [ ] Successfully manage multiple Python versions
- [ ] Create and maintain project structures
- [ ] Understand environment isolation
- [ ] Configure tools for efficient workflow

## Notes
- Always verify commands before execution
- Keep notes of encountered errors and solutions
- Practice commands until they become muscle memory
- Understand the "why" behind each command