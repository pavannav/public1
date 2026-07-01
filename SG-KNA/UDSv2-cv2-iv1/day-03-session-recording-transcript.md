<details open>
<summary><b>Day-03-Session_Recording (KK-CS45-script-v2-Inst-v1)</b></summary>

# Session 3: Python Fundamentals - Variables, Data Types, and Environment Setup

## Table of Contents
- [Overview](#overview)
- [Environment Setup and Tools Walkthrough](#environment-setup-and-tools-walkthrough)
- [Python Installation with UV](#python-installation-with-uv)
- [Project and Environment Management](#project-and-environment-management)
- [Variables and Memory Concepts](#variables-and-memory-concepts)
- [Data Types in Python](#data-types-in-python)
- [Functions: print() and type()](#functions-print-and-type)
- [Summary](#summary)

## Overview
This session covers the foundational elements of Python programming, beginning with comprehensive environment setup using UV for Python version management, progressing through the creation of isolated Python environments, and establishing the fundamental concepts of variables, memory allocation, and data types. The session emphasizes proper tooling setup with VS Code extensions and introduces the critical distinction between Python scripts (.py) and Jupyter Notebooks (.ipynb) for different use cases in data science workflows.

## Environment Setup and Tools Walkthrough

### VS Code Terminal Configuration
For Windows users, the default PowerShell terminal must be changed to Command Prompt (CMD) for compatibility:
- Click on the dropdown arrow next to the terminal type
- Select "Command Prompt" instead of PowerShell
- Delete the PowerShell instance using the delete option on hover

### UV Installation Verification
UV serves as a comprehensive Python and project management tool:
```bash
# Verify UV installation
uv

# Clear terminal (Windows)
cls

# Clear terminal (macOS/Linux)
clear
```

### Folder Structure Best Practices
Create organized project structures for maintainability:
```
PracticalLive/
├── Level1/
│   ├── Lectures/
│   │   └── 17012026/
│   │       └── 17012026.ipynb
│   └── Level1ENV/ (Python environment)
```

## Python Installation with UV

### Installing Python Versions
UV enables seamless management of multiple Python versions:
```bash
# Install Python 3.12 (stable version recommended)
uv python install 3.12

# Install additional versions if needed
uv python install 3.10
uv python install 3.14
```

### Pinning Python Version
Pin a specific Python version for consistent project behavior:
```bash
# Pin Python 3.12 for the project
uv python pin 3.12

# Verify pinned version
uv python
```

### Running Python with UV
```bash
# Run Python interpreter
uv run python

# Python interpreter prompt appears (>>>)
# Exit Python interpreter
exit()
```

## Project and Environment Management

### Creating Isolated Python Environments
Python environments isolate project dependencies:
```bash
# Create environment with custom name
uv venv Level1ENV

# The environment creates its own file structure:
# - bin/ (executables)
# - lib/ (libraries)
# - pyvenv.cfg (configuration)
```

### VS Code Extensions for Python Development
Essential extensions for enhanced Python development experience:

1. **Python Extension** (by Microsoft):
   - Provides syntax highlighting
   - Enables IntelliSense
   - Supports debugging capabilities

2. **Jupyter Extension**:
   - Required for .ipynb file support
   - Enables interactive computing

### Kernel Selection in Jupyter Notebooks
After creating a notebook file (.ipynb):
1. Click "Select Kernel" in the top-right
2. Choose "Python Environments"
3. Select the created environment (Level1ENV)
4. Verify Python version appears correctly

## Variables and Memory Concepts

### Understanding RAM and Storage
- Applications run in RAM (Random Access Memory)
- Installed applications reside on HDD/SSD
- Python allocates memory blocks when storing values

### Variables as Memory Addresses
Variables function as named references to memory locations:
```python
# Variable assignment stores value in memory
a = 12
b = 3.10
c = 3

# Print variable values
print(a)  # Output: 12
print(b)  # Output: 3.10
print(c)  # Output: 3
```

### Memory Allocation Visualization
```
RAM Structure:
┌─────┬─────┬─────┬─────┐
│ R1C1│ R1C2│ R1C3│ R1C4│
├─────┼─────┼─────┼─────┤
│ R2C1│12(a)│ R2C3│ R2C4│
├─────┼─────┼─────┼─────┤
│ R3C1│ R3C2│R3C3 │ R3C4│
└─────┴─────┴─────┴─────┘
```

## Data Types in Python

### Primary Data Types

| Type | Description | Examples |
|------|-------------|----------|
| `int` | Whole numbers without decimal points | 0, 1, 2, -5, 100 |
| `float` | Numbers with decimal points | 1.0, 3.14, -0.5, 2.718 |
| `str` | Text/characters enclosed in quotes | "Hello", 'Python', "Data Science" |

### Checking Data Types
```python
# Integer type
a = 12
print(type(a))  # Output: <class 'int'>

# Float type
b = 3.10
print(type(b))  # Output: <class 'float'>

# String type
name = "Python"
print(type(name))  # Output: <class 'str'>
```

## Functions: print() and type()

### The print() Function
- Displays output to the console
- Essential for debugging and viewing results
- Syntax: `print(value)`

### The type() Function
- Returns the data type of a value/variable
- Critical for understanding variable contents
- Syntax: `type(value)`

### Combined Usage
```python
# Store and inspect values
x = 42
print(type(x))  # Shows: <class 'int'>

y = 3.14159
print(type(y))  # Shows: <class 'float'>

z = "Hello World"
print(type(z))  # Shows: <class 'str'>
```

## File Types in Python Development

### Python Scripts (.py)
- Sequential execution of all code
- Suitable for production code
- Single execution flow
- No built-in cell structure

### Jupyter Notebooks (.ipynb)
- Interactive development environment
- Cell-based execution
- Supports markdown for documentation
- Ideal for experimentation and data analysis
- Can attach images and multiple content types

## Summary

### Key Takeaways
```diff
+ Variables store data in memory and act as named references to memory addresses
+ Python uses RAM for runtime storage while HDD/SSD holds installed applications
+ Three fundamental data types: int (whole numbers), float (decimals), str (text)
+ UV provides comprehensive Python version and environment management
+ Jupyter Notebooks enable interactive development with cell-based execution
+ Always pin a stable Python version (3.12 recommended) for consistency
+ Use meaningful environment names for better project organization
- Never modify files inside the environment directory (venv, Level1ENV)
- Avoid running the same installation command multiple times unnecessarily
```

### Quick Reference Commands

| Task | Command |
|------|---------|
| Install Python | `uv python install 3.12` |
| Pin Python version | `uv python pin 3.12` |
| Create environment | `uv venv EnvironmentName` |
| Run Python | `uv run python` |
| Clear terminal (Windows) | `cls` |
| Clear terminal (macOS/Linux) | `clear` |
| Check variable type | `type(variable)` |
| Print output | `print(value)` |

### Expert Insight

> [!IMPORTANT]
> **Real-world Application**: Proper environment setup prevents dependency conflicts between projects. Using UV for environment management ensures reproducibility across development machines and deployment environments. Jupyter Notebooks excel in exploratory data analysis, while .py scripts suit production deployments.

> [!NOTE]
> **Expert Path**: Master the distinction between development experimentation (notebooks) and production code (scripts). Understand memory management concepts to write efficient code. Practice creating isolated environments for each project to maintain clean dependency trees.

> [!CAUTION]
> **Common Pitfalls**:
> - Opening the wrong folder level in VS Code can cause UV to fail finding environments
> - Forgetting to select the correct kernel prevents code execution
> - Mixing PowerShell and CMD commands on Windows leads to confusion
> - Not pinning Python versions can cause compatibility issues across team members

</details>