# Session 13: Core Java - Setting Path Environment Variable

## Table of Contents
- [Why Set Path Variable](#why-set-path-variable)
- [Reading Existing Path Variable](#reading-existing-path-variable)
- [Temporarily Setting Path Variable](#temporarily-setting-path-variable)
- [Path Variable Algorithm in Command Prompt](#path-variable-algorithm-in-command-prompt)
- [Multiple JDK Versions in Path](#multiple-jdk-versions-in-path)
- [Permanent Path Settings](#permanent-path-settings)
- [Binary Files vs Library Files](#binary-files-vs-library-files)
- [Path vs Class Path Variables](#path-vs-class-path-variables)
- [Path Settings in Different Operating Systems](#path-settings-in-different-operating-systems)
- [Lab Demo: Temporary Path Setup](#lab-demo-temporary-path-setup)
- [Lab Demo: Permanent Path Setup](#lab-demo-permanent-path-setup)

## Why Set Path Variable

### Overview
The Path environment variable is crucial for accessing executable (binary) files of installed software from any directory in the command prompt. It's a predefined variable created by the operating system during installation, containing paths to system binaries. Without proper Path configuration, commands like `java`, `javac`, or even system commands like `tree` may not be found when executed from locations outside their installation directories.

### Key Concepts

Path is universal across all operating systems and software, not limited to Java. It includes:
- Operating system binary locations (e.g., C:\Windows\System32)
- User-installed software binaries

**Key points:**
- Command prompt searches current directory first for commands
- If not found, it searches Path variable sequentially
- Each path is separated by semicolons in Windows

### Code/Config Blocks

**Windows Path Example:**
```
C:\Windows\System32;C:\Program Files\Java\jdk1.8.0_261\bin
```

### Lab Demos

#### Demo 1: Understanding Path Search Priority
1. Open command prompt in current directory (e.g., D:\01Java\CoreJava)
2. Run `tree /f` - Works because tree.exe is in C:\Windows\System32 (in Path)
3. Create a file named `tree.bat` in current directory with content `echo Custom tree command`
4. Run `tree /f` - Now shows custom message because current directory takes priority

#### Demo 2: Path Variable Demonstration
1. Check current directory: `cd`
2. Run `tree /f` - Displays tree of current directory contents
3. Command prompt finds `tree.com` in System32 folder via Path

Expected output shows folders and files in tree structure.

---

## Reading Existing Path Variable

### Overview
The Path variable contains pre-configured paths set by the operating system during installation. You can read this existing value using specific commands to verify current configurations before making changes.

### Key Concepts

**Reading methods in Windows:**
- `set path` - Shows Path= followed by value
- `echo %path%` - Shows raw path value
- `path` - Shows Path= with value (includes extensions)

**Key differences:**
- `set path` and `path` show extensions (.exe, .bat, etc.)
- `echo %path%` shows clean path string

### Tables

| Command | Output Shows | Example Usage |
|---------|-------------|---------------|
| `set path` | PATH= followed by value | Display path with extensions |
| `echo %path%` | Raw path string | Retrieve for manipulation |
| `path` | PATH= with value | Windows-specific display |

### Lab Demos

#### Demo: Reading Path Values
1. Open command prompt
2. Type `set path` - observe PATH= with current paths
3. Type `echo %path%` - observe clean path string
4. Type `path` - observe PATH= with extensions listed

Output varies by system but shows Windows system paths.

---

## Temporarily Setting Path Variable

### Overview
Temporary Path setting modifies the variable for the current command prompt session only. It reverts to original values when the window closes. Use this for testing different software versions without permanent system changes.

### Key Concepts

**Key syntax elements:**
- `set path=` - Assigns new value (overwrites existing)
- `;` - Separates multiple paths  
- `%path%` - Retrieves existing path value for appending

**Critical syntax:** `set path=NewPath;%path%`

**Path appending order:**
- JDK path first (recommended)
- Oracle/SQL paths next
- Keep Windows system paths intact

### Code/Config Blocks

**Basic temporary set:**
```bash
set path=C:\jdk1.8.0_261\bin;%path%
```

**Multiple software paths:**
```bash
set path=C:\Program Files\Java\jdk1.8.0_261\bin;C:\app\HK\product\12.1.0\dbhome_1\bin;%path%
```

**With quotes for spaces:**
```bash
set path="C:\Program Files\Java\jdk1.8.0_261\bin";%path%
```

### Lab Demos

#### Demo: Basic Temporary Setup
1. Open new command prompt
2. Test: `javac` (should fail)
3. Set: `set path="C:\jdk1.8.0_261\bin";%path%`
4. Test: `javac` (should work now)
5. Close command prompt window
6. Open new command prompt
7. Test: `javac` (fails - temporary change lost)

#### Demo: Multiple Software Paths
1. Set JDK path as above
2. Add VLC: `set path=%path%;"C:\Program Files\VideoLAN\VLC"`
3. Test `vlc` command
4. Add editplus: `set path=%path%;"C:\Program Files\EditPlus"`
5. Test all commands work

---

## Path Variable Algorithm in Command Prompt

### Overview
When you execute a command, Windows command prompt follows a specific search algorithm. Understanding this helps troubleshoot "command not recognized" errors.

### Key Concepts

The algorithm searches in this order:
1. Current directory
2. Path variable paths (left to right)
3. Stops at first match found

**Algorithm flow:**
```diff
+ 1. Enter command (e.g., javac)
- 2. Search current directory
- 3. If not found, search first Path folder
- 4. If not found, search second Path folder  
- 5. Continue until found or error thrown
! Note: Stops immediately when first match found
```

### Lab Demos

#### Demo: Algorithm Demonstration
1. Create file `javac.txt` in current directory
2. Run `javac` - May show different error (not executable)
3. Set path to include JDK bin
4. Run `javac` again - Now uses real javac.exe
5. Shows algorithm prioritizes current directory, then Path

---

## Multiple JDK Versions in Path

### Overview
Systems can have multiple JDK versions installed. The Path determines which version's tools get executed. First JDK in Path takes precedence.

### Key Concepts

**Version selection:**
- Modify Path to prioritize desired JDK
- Each command prompt session can use different JDK versions  
- Permanent settings have one default; temporary override per session

**Use cases:**
- Legacy code requiring specific JDK
- Testing compatibility across versions

### Lab Demos

#### Demo: Switching JDK Versions
1. Install multiple JDKs (e.g., 1.7, 1.8, 14)
2. Temporary: `set path=C:\jdk1.7\bin;%path%`
3. Check: `java -version` (shows 1.7)
4. Change: `set path=C:\jdk1.8\bin;%path%` 
5. Check: `java -version` (shows 1.8)

---

## Permanent Path Settings

### Overview
Permanent settings modify system environment variables, persisting across sessions and user logins. These changes affect all command prompt windows and user accounts (if set in system variables).

### Key Concepts

**Access Path:**
1. Right-click This PC → Properties
2. Advanced system settings
3. Environment Variables
4. Select Path (System or User variables)
5. Edit

**Windows versions differences:**
- Older: Single text field
- Windows 10+: Multi-line interface with New/Browse options

### Tables

| Windows Version | Edit Method | Append Method |
|----------------|-------------|---------------|
| XP/7/8 | Single text field | Manual semicolon + paste |
| 10+ | Multi-line GUI | New button + Browse |

### Code/Config Blocks

**Permanent Path example:**
```
C:\Program Files\Java\jdk1.8.0_261\bin
C:\Windows\System32
C:\app\HK\product\12.1.0\dbhome_1\bin
```

### Lab Demos

#### Demo: Windows 10 Style Setup
1. Open Environment Variables
2. Select Path under System variables
3. Click Edit
4. Click New
5. Paste or browse to JDK bin folder
6. Move up to make first entry
7. Add other software paths similarly
8. OK all dialogs
9. Open new command prompt
10. Test `javac`, `java`, `sqlplus`

#### Demo: Older Windows Style Setup
1. Environment Variables → Edit Path
2. Place cursor at beginning
3. Paste JDK path + semicolon
4. Avoid overwriting existing paths
5. OK and test

---

## Binary Files vs Library Files

### Overview
Binary files are executable commands; library files are reusable code. Path enables binary execution; class path enables library access by Java compiler/JVM.

### Key Concepts

**Binary files:**
- Extensions: .exe, .bat, .com, .dll (Windows)
- Stored in `bin` folders
- Executed by command prompt

**Library files:**  
- Extensions: .class, .jar (Java)
- Stored in `lib` folders
- Used by compiler/jvm for code dependencies

### Tables

| Aspect | Binary Files | Library Files |
|--------|-------------|---------------|
| Purpose | Command execution | Code reuse |
| Location | `bin/` folder | `lib/` folder or JAR files |
| Access via | Path variable | Class Path variable |
| User | Command prompt | JVM/Compiler |

### Code/Config Blocks

**Binary file identification:**
```bash
# Extensions requiring Path
.exe .com .bat .cmd .scr .vbe .js .jse .wsf .wsh .msc
```

**Library path:**
```
# JAR files contain compiled .class files
rt.jar - core Java classes
tools.jar - JDK tools
```

---

## Path vs Class Path Variables

### Overview
Path locates executables for command prompt; class path locates libraries for Java tools. Path is mandatory for Java toolchain; class path optional for JDK libraries.

### Key Concepts

**Fundamental differences:**
- Path: Mandatory, system-wide, binary executables
- Class Path: Optional, Java-specific, library files

**When each is used:**
- Path: When getting "'command' is not recognized"
- Class Path: When getting "class not found" or "symbol not found"

### Diff Blocks

```diff
+ Path: Mandatory - enables commands like java, javac
- Class Path: Optional - for accessing external JARs/libraries
! Rule: Set Path before Class Path in session
```

---

## Path Settings in Different Operating Systems

### Overview
Path syntax varies by OS but serves the same purpose. Use colon instead of semicolon on Unix-like systems.

### Tables

| OS | Command | Separator | Retrieve Existing |
|----|---------|-----------|-------------------|
| Windows | `set path=...;%path%` | `;` | `%path%` |
| Linux/Unix | `export PATH=...:PATH` | `:` | `$PATH` |

### Code/Config Blocks  

**Linux temporary:**
```bash
export PATH=/usr/java/jdk1.8.0_261/bin:$PATH
echo $PATH
```

**Solaris:**
```bash
export PATH=/opt/java/bin:$PATH
```

---

## Lab Demo: Temporary Path Setup

**Step-by-step setup:**

1. Open command prompt
2. Copy JDK bin path: `C:\jdk1.8.0_261\bin`
3. Execute: `set path="C:\jdk1.8.0_261\bin";%path%`
4. Test: `javac -version` (should work)
5. Add Oracle: `set path=%path%;"C:\app\HK\product\12.1.0\dbhome_1\bin"`
6. Test: `sqlplus` (should work)
7. Add EditPlus: `set path=%path%;"C:\Program Files\EditPlus"`
8. Test: `editplus` (should launch)
9. Close window - all settings lost

---

## Lab Demo: Permanent Path Setup

**Windows 10+ method:**

1. Right-click This PC → Properties → Advanced system settings
2. Environment Variables → System variables
3. Select Path → Edit
4. Click New → Browse to JDK bin folder → OK
5. Move JDK path to top using Move Up
6. Click New → Browse to Oracle bin folder
7. Repeat for other software paths
8. OK all dialogs
9. Open new command prompt window  
10. Test all commands persist across sessions

---

## Summary

### Key Takeaways
```diff
+ Path variable stores binary executable locations for command prompt access
+ Temporary: set path=NewPath;%path% (lost when window closes)  
+ Permanent: System Environment Variables (persists across sessions)
+ Syntax: JDK path first, semicolon separators, no overwrite existing paths
- Do not modify production server Paths without testing
+ Always use quotes around paths containing spaces
+ Test in new command prompt after permanent changes
! Algorithm: Current directory → Path folders (left-to-right) → Stop at first match
```

### Expert Insight

#### Real-world Application
In enterprise environments, Path variables are configured in:
- CI/CD pipeline scripts
- Docker containers for Java applications
- Development team laptops via Group Policy
- Cloud instances using automation tools like Ansible

#### Expert Path
- Master multiple JDK versions by maintaining separate command prompt sessions
- Use `where java` command to verify which JDK is active
- Document Path configurations in team wikis for consistency
- Adopt version managers like SDKMAN (Linux) or jabba (cross-platform)

#### Common Pitfalls
- Forgetting `%path%` when appending temporarily (overwrites all paths)
- Using Browse directory in Windows 10+ (replaces instead of appends)
- Setting in User variables instead of System (doesn't affect other users)
- Installing JDK in paths with spaces without quotes
- Mixing Windows (semicolon) and Unix (colon) path separators

#### Lesser known things
- Path limit in older Windows: 2047 characters (Windows XP-7)
- System variables > User variables in precedence
- `PATH` is case-sensitive on Unix but not on Windows
- Some software installers automatically modify Path
- Java applications often bundle JRE to avoid Path dependencies
- Windows recognizes both `/` and `\` in Path (but `\` preferred)
