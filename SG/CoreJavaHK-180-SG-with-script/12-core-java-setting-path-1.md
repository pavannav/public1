```markdown
# Session 12: Setting Path in Core Java

## Table of Contents
- [JDK Installation Differences](#jdk-installation-differences)
- [Why We Need to Set Environment Variables](#why-we-need-to-set-environment-variables)
- [Understanding Environment Variables](#understanding-environment-variables)
- [JAVA_HOME Environment Variable](#java_home-environment-variable)
- [PATH Environment Variable](#path-environment-variable)
- [CLASSPATH Environment Variable](#classpath-environment-variable)
- [Temporary vs Permanent Settings](#temporary-vs-permanent-settings)
- [Practical Demonstration](#practical-demonstration)

## JDK Installation Differences

### Overview
Understanding the evolution of JDK versions is crucial for setting up development environments. Each version introduced significant changes that affect how Java applications are developed, compiled, and executed.

### Key Concepts

#### JDK 8 Features
- Contains `tools.jar` in `lib` folder for compiler tools
- Includes `rt.jar` in JRE's `lib` folder containing runtime classes
- Full JRE environment available within JDK

#### JDK 9 Changes
- **Removal of Private JRE**: Private JRE concept was removed
- Introduction of **modular system** via Project Jigsaw
- JDK became more lightweight and modular

#### JDK 11 Changes
- **Public JRE Removal**: Public JRE download was officially discontinued
- **Applets Officially Discontinued**: Applet programming was officially deprecated
- Oracle discontinued public JRE support, moving to OpenJDK distributions

### Tables: JDK Version Comparison

| Feature | JDK 8 | JDK 9 | JDK 11 |
|---------|-------|-------|--------|
| Private JRE | Available | Removed | Removed |
| Modular System | No | Introduced | Enhanced |
| Public JRE | Available | Available | Discontinued |
| Applets | Supported | Deprecated | Officially discontinued |

## Why We Need to Set Environment Variables

### Overview
Java programs require access to JDK's binary files (like `javac`, `java`) and library files (like `rt.jar`, `tools.jar`) during compilation and execution. These files are stored in specific JDK directories, but our Java programs are typically created in separate project directories.

### Key Concepts
Without environment variables, the system cannot locate JDK resources from our working directories. This creates the fundamental challenge:

### Illustration: Directory Access Problem

```mermaid
graph TD
    A[JDK Folder: C:\jdk-14.0.2\bin] --> B[Contains: javac.exe, java.exe]
    A --> C[\lib folder containing JAR files]
    D[Project Folder: D:\CoreJava\Basics] --> E[Contains: Example.java]
    B -.->|Cannot access| D
    E -.->|Cannot access| A
```

**Problem**: JDK files are in one location, our Java programs in another. System needs "address information" to bridge this gap.

**Solution**: Environment variables provide the necessary path information for the operating system to locate JDK resources.

### Code Example: Failed Compilation without PATH

```bash
# In command prompt from user directory
C:\Users\HK>javac Example.java
'javac' is not recognized as an internal or external command operable program or batch file.
```

## Understanding Environment Variables

### Overview
Environment variables are placeholders created within the operating system that store information needed to locate software components. They enable cross-directory access to software resources.

### Key Concepts

#### Definition and Purpose
An **environment variable** is a dynamic named value stored within the operating system that can be referenced by running processes to locate:
- Software installation directories
- Binary/executable files
- Library/archive files

#### Why Environment Variables Are Essential
- Allow access to software resources from any directory
- Enable separation of development tools and project code
- Provide centralized configuration management
- Support multiple software versions coexistence

#### Storage Mechanism
Environment variables follow assignment syntax similar to programming variables:
```
VARIABLE_NAME = value
```

#### Key Characteristics
- **Variable Name**: Case-sensitive identifiers (though Windows treats them case-insensitively)
- **Value Storage**: Stores directory paths, file locations, or configuration data
- **Scope**: Affects the operating system's behavior system-wide
- **Persistence**: Can be temporary (session-based) or permanent (system-wide)

## JAVA_HOME Environment Variable

### Overview
JAVA_HOME specifically points to the JDK installation directory, serving as the base reference for all Java-related path operations.

### Key Concepts

#### Purpose
- Identifies the JDK installation location
- Serves as foundation for other Java-related environment variables
- Enables tools and scripts to locate JDK components

#### Value Assignment
```bash
JAVA_HOME = C:\jdk-14.0.2
# Or for specific installations:
JAVA_HOME = C:\jdk-1.8.0_261
```

#### What JAVA_HOME Enables
- Tools can reference `$JAVA_HOME` (Unix) or `%JAVA_HOME%` (Windows)
- Points to root JDK directory containing bin, lib, and other folders
- Foundation for IDE and build tool configurations

### Code Block: JAVA_HOME Usage

```bash
# Windows example
JAVA_HOME = C:\jdk-14.0.2

# Unix/Linux example
EXPORT JAVA_HOME=/usr/lib/jvm/jdk-14.0.2
```

## PATH Environment Variable

### Overview
PATH is a critical environment variable that tells the operating system where to find executable programs and commands.

### Key Concepts

#### Purpose
- Contains list of directories containing executable files
- Operating system searches these directories for commands
- Essential for running Java compiler and runtime tools

#### Directory Contents for Java
Typical JDK bin folder contains:
- `javac.exe` - Java compiler
- `java.exe` - Java runtime
- `jar.exe` - JAR file creation tool
- Other development tools

#### Value Assignment
```bash
# Append JDK bin directory to existing PATH
PATH = %PATH%;C:\jdk-14.0.2\bin

# Or full path specification
PATH = C:\jdk-14.0.2\bin
```

#### Search Algorithm
When executing a command like `javac`:
1. **Current Directory Priority**: System first checks present working directory
2. **PATH Variable Search**: If not found locally, searches directories in PATH sequentially
3. **Execution**: Upon finding the executable, runs the command

### Code Block: PATH Setting Command

```bash
# Temporary PATH setting in Windows
set PATH = C:\jdk-14.0.2\bin

# Permanent PATH setting (through System Properties)
# 1. Right-click This PC → Properties
# 2. Advanced system settings
# 3. Environment Variables
# 4. Edit PATH variable
```

### Alert: Path Separator Importance

> [!IMPORTANT]
> Use appropriate path separators:
> - Windows: Semicolon `;` to separate multiple paths
> - Unix/Linux: Colon `:` to separate multiple paths

## CLASSPATH Environment Variable

### Overview
CLASSPATH points to Java class libraries and JAR files needed for compilation and execution of Java applications.

### Key Concepts

#### Purpose
- Locates Java libraries and class files
- Supports external dependencies and JAR files
- Enables access to predefined Java classes

#### What CLASSPATH Contains
- JDK library files (`rt.jar`, `tools.jar`)
- User-created JAR files
- Third-party libraries
- Custom classpath entries

#### Value Assignment Examples

For JDK 8:
```bash
CLASSPATH = C:\jdk-1.8.0_261\lib\tools.jar;C:\jdk-1.8.0_261\jre\lib\rt.jar
```

For JDK 11+ (no rt.jar):
```bash
CLASSPATH = C:\jdk-14.0.2\lib\tools.jar;.
```

> [!NOTE]
> Modern JDK versions (9+) have different classpath requirements due to modular system changes.

#### Path Separation Logic
Unlike JAVA_HOME (single path), CLASSPATH supports multiple entries:
```bash
# Multiple JAR files (Windows)
CLASSPATH = C:\project\lib\custom.jar;C:\external\libraries\dependency.jar;.

# Include current directory with period
CLASSPATH = .;C:\myclasses\;C:\mylib\utilities.jar
```

### Code Block: CLASSPATH Setting

```bash
# Temporary CLASSPATH setting
set CLASSPATH = C:\jdk-14.0.2\lib\tools.jar;.

# Permanent setting through System Properties
# Similar to PATH setting process
```

## Temporary vs Permanent Settings

### Overview
Environment variables can be set either temporarily (session-based) or permanently (system-wide), each with specific use cases and implications.

### Key Concepts

#### Temporary Settings
**Method**: Use `set` command in command prompt window
```bash
set PATH = C:\jdk-14.0.2\bin
set CLASSPATH = C:\jdk-14.0.2\lib\tools.jar
```

**Duration**: Available only for current command prompt session
**Scope**: Affects only the specific command window

#### Permanent Settings
**Method**: Through Windows System Properties → Environment Variables
- **System Variables**: Affect all users on the system
- **User Variables**: Affect only current user account

**Duration**: Persist across system restarts and user sessions
**Scope**: System-wide or user-specific impact

### Differences Table

| Aspect | Temporary Settings | Permanent Settings |
|--------|-------------------|-------------------|
| **Command** | `set VARIABLE=value` | System Properties GUI |
| **Scope** | Current CMD window only | Entire system/user |
| **Persistence** | Lost on window close | Survives system restart |
| **Inheritance** | Child CMD windows inherit | All new processes inherit |
| **Best For** | Testing, development | Production deployment |

### Code Block: Temporary Setting Steps

```bash
# 1. Open Command Prompt
# 2. Check current PATH
echo %PATH%

# 3. Set temporary PATH
set PATH = C:\jdk-14.0.2\bin

# 4. Verify setting worked
javac -version

# 5. Close command prompt - setting is lost
```

### Code Block: Permanent Setting Steps

```bash
# 1. Right-click This PC → Properties
# 2. Advanced system settings
# 3. Environment Variables button
# 4. Select PATH → Edit
# 5. Add new path: C:\jdk-14.0.2\bin
# 6. Apply changes
```

## Practical Demonstration

### Lab Demo: Setting Environment Variables

#### Step 1: Open Command Prompt and Test Current State

```bash
# Open CMD and check if javac works
javac
# Expected: Error - 'javac' is not recognized...
```

#### Step 2: Set Temporary PATH

```bash
# Set PATH to JDK bin directory
set PATH = C:\jdk-14.0.2\bin

# Test javac command
javac -version
# Expected: Java compiler version output
```

#### Step 3: Verify PATH Inheritance

```bash
# From same CMD window, open new CMD
start cmd

# In new CMD window, test javac
javac -version
# Expected: Works (inherited from parent)
```

#### Step 4: Test Cross-Directory Access

```bash
# Change to different drive/folder
D:

# Test javac availability
javac -version
# Expected: Still works due to PATH setting
```

#### Step 5: Demonstrate Temporary Nature

```bash
# Close all CMD windows
# Open new CMD from Start menu
javac
# Expected: Error - PATH not set in new clean session
```

### Common Issues and Resolutions

#### Issue 1: 'javac' not recognized after setting PATH
**Symptom**: PATH set but command still fails
**Resolution**:
```bash
# Check PATH contents
echo %PATH%

# Add semicolon separator correctly
set PATH = %PATH%;C:\jdk-14.0.2\bin
```

#### Issue 2: CLASSPATH conflicts
**Symptom**: Compilation succeeds but runtime errors occur
**Resolution**:
```bash
# Set CLASSPATH with current directory
set CLASSPATH = .;C:\jdk-14.0.2\lib\*
```

#### Issue 3: JDK version confusion
**Symptom**: Wrong compiler version reported
**Resolution**:
```bash
# Verify JDK installation
javac -version
java -version

# Check JAVA_HOME matches PATH
echo %JAVA_HOME%
```

## Summary

### Key Takeaways

```diff
+ Understand that JDK installation alone doesn't enable command-line Java development
+ Environment variables bridge the gap between JDK installation directories and project directories
+ Three essential environment variables: JAVA_HOME, PATH, and CLASSPATH
+ PATH enables binary file access (javac, java commands)
+ CLASSPATH manages library and class file locations
+ Distinguish between temporary (session-based) and permanent (system-wide) settings
+ Temporary settings lost on command prompt close; permanent settings require System Properties configuration
- Do not attempt to copy JDK files to project directories
- Avoid manually changing directories for each compilation
- Never store project files within JDK installation folders
```

### Expert Insight

#### Real-world Application
In enterprise environments, environment variables ensure consistent Java tooling across development teams. Tools like Maven and Gradle reference these variables, making proper configuration essential for collaborative development.

#### Expert Path
Master environment variable management through:
- Understanding Windows System Properties thoroughly
- Learning batch scripting for environment variable automation
- Exploring advanced JDK configurations across different environments

#### Common Pitfalls
- **Incorrect separators**: Using wrong path separators (commas instead of semicolons)
- **Missing current directory**: Forgetting to include `.` in CLASSPATH for current project files
- **Version mismatches**: JAVA_HOME pointing to different JDK version than PATH
- **Space in paths**: Not properly quoting paths containing spaces
- **Case sensitivity confusion**: Treating Windows environment variables as case-sensitive

#### Lesser Known Things
- **PATH search order**: Operating system searches PATH left-to-right, first match wins
- **Environment inheritance**: Child processes inherit parent environment variables
- **Startup scripts**: Windows uses autoexec.bat for permanent environment initialization
- **64-bit considerations**: Ensure matching JDK architecture (32/64-bit) with system
- **Modular JDK evolution**: JDK 9+ modules changed how CLASSPATH operates compared to traditional JAR-based approaches

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```
