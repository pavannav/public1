# Session 81: JAR Files

## Table of Contents
- [Overview](#overview)
- [What is a JAR File?](#what-is-a-jar-file-)
- [Why JAR File?](#why-jar-file-)
- [JAR Tool](#jar-tool)
  - [JAR Command Syntax](#jar-command-syntax)
  - [JAR Tool Options](#jar-tool-options)
- [Creating a JAR File](#creating-a-jar-file)
  - [Project Structure](#project-structure)
  - [Compilation Process](#compilation-process)
  - [JAR Creation Commands](#jar-creation-commands)
- [Lab Demo: Creating a JAR File](#lab-demo-creating-a-jar-file)
- [Library vs Executable JAR Files](#library-vs-executable-jar-files)
- [Executable JAR Files](#executable-jar-files)
  - [Manifest File](#manifest-file)
  - [Creating Executable JAR](#creating-executable-jar)
  - [Running Executable JAR](#running-executable-jar)
- [Project Distribution](#project-distribution)

## Overview
This session covers JAR (Java Archive) files, which are fundamental to Java development for packaging, distribution, and deployment of Java applications. JAR files ensure platform independence, compress multiple files into one transferable unit, and facilitate sharing of Java libraries across developers and organizations.

## What is a JAR File?

### Definition
- A JAR file is a **compressed file** similar to ZIP, containing **collection of packages and classes**
- It stands for **Java Archive** and serves as a **platform-independent** transferable folder
- JAR files store Java bytecode (.class files) along with other resources like images, configuration files, etc.

### Purpose
- Used for **sharing** collection of packages and classes as one file to other developers across the world
- Enables **distribution** of Java libraries (e.g., JDBC drivers like ojdbc.jar from Oracle)
- Provides **compressible** storage for Java projects, compressing multiple files into one manageable unit

### Structure
```
com/
  nit/
    hk/
      blogic/
        Addition.class
        Subtraction.class
        Multiplication.class
        Division.class
```

### Key Characteristics
✅ **Platform Independent** - Works across different operating systems  
✅ **Compressed** - Reduces file size for transfer  
✅ **Single Unit** - Packages multiple files together  
✅ **Library Distribution** - Enables sharing reusable components  

## Why JAR File?

### Problem with Folders
- **Folders cannot be emailed directly** (only as compressed ZIP files)
- Individual file sharing creates **management overhead** and **version tracking issues**
- **Windows-specific** ZIP files may not be universally compatible

### Solution with JAR
- **Java's alternative to ZIP** - Platform-independent compression
- **Enables sharing** of complete Java libraries as single files
- **Standard format** for distributing Java components like:
  - **RT.jar** - Java runtime library
  - **ojdbc.jar** - Oracle JDBC driver
  - **Custom libraries** - Business logic components

### Real-World Examples
- **Oracle JDBC**: `ojdbc.jar` contains database connectivity classes
- **Java Library**: `rt.jar` contains standard Java classes
- **Third-party APIs**: Spring, Hibernate, etc. distributed as JAR files

> [!IMPORTANT]
> JAR files are the **standard distribution mechanism** for Java libraries, replacing old-fashioned ZIP file sharing that was platform-dependent and inconvenient.

## JAR Tool

### Introduction
- **jar** is a Java binary tool used for **creating** and **manipulating** JAR files
- Located in **JDK/bin/** directory (e.g., `C:/JDK/bin/jar.exe`)
- **Not a physical jar/pickle jar** - it's a command-line utility

### Usage Context
- **Creation**: `jar [options] [jar-file] [manifest-file] [entry-point] [-C dir] files...`
- **Manipulation**: List, extract, update JAR contents
- **Execution**: Some JAR files can be executed directly

### Setting JAR Path
- Requires **PATH** environment variable set to `C:/JDK/bin/`
- Without path: `jar is not recognized` error

## JAR Tool

### JAR Command Syntax

#### Basic Syntax
```
jar [option] [jar-file-name] [directory/files...]
```

#### Common Syntax Variations
1. **Create JAR with content**: `jar cvf archive.jar file1 file2`
2. **List JAR contents**: `jar tvf archive.jar`
3. **Extract JAR**: `jar xvf archive.jar`
4. **Update JAR**: `jar uvf archive.jar newfile`

#### Advanced Syntax
- `jar cvf jarfilename.jar -C directory/ classfiles`
- `jar cvfm jarfilename.jar manifest.txt -C bin/ *`

### JAR Tool Options

#### Main Options
| Option | Long Form | Description | Example |
|--------|-----------|-------------|---------|
| `c` | `-create` | Create new JAR file | `jar cf archive.jar *` |
| `t` | `-list` | List JAR contents | `jar tf archive.jar` |
| `x` | `-extract` | Extract JAR contents | `jar xf archive.jar` |
| `u` | `-update` | Update JAR contents | `jar uf archive.jar new.class` |

#### Modifier Options
| Option | Long Form | Description | Example |
|--------|-----------|-------------|---------|
| `v` | `-verbose` | Display detailed output | `jar cvf archive.jar *` |
| `f` | `-file` | Specify JAR filename | `jar cfm manifest.jar` |
| `m` | `-manifest` | Include manifest file | `jar cvfm app.jar man.txt -C src/ .` |
| `M` | `-no-manifest` | Don't create manifest | `jar cMf no-manifest.jar` |
| `0` | `-no-compress` | Store without compression | `jar c0f uncompressed.jar` |
| `C` | `-directory` | Change to directory | `jar cf jarfile.jar -C bin/ .` |

#### Help Command
- `jar -help` or `jar -?` - displays all available options
- Shows current JDK version compatibility

> [!NOTE]
> Options can be combined (e.g., `cvf`, `tvf`, `xvf`, `uvf`)

## Creating a JAR File

### Project Structure

#### Recommended Directory Structure
```
project-folder/
├── src/           # Source Java files (.java)
│   └── com/
│       └── nit/
│           └── hk/
│               └── blogic/
│                   ├── Addition.java
│                   ├── Subtraction.java
│                   ├── Multiplication.java
│                   └── Division.java
├── bin/           # Compiled classes (.class)
│   └── com/
│       └── nit/
│           └── hk/
│               └── blogic/
│                   ├── Addition.class
│                   ├── Subtraction.class
│                   ├── Multiplication.class
│                   └── Division.class
└── lib/           # Library JAR files
    └── aclasses.jar
```

#### Why Two Folders?
- **src/**: Contains source code (`.java` files) only
- **bin/**: Contains compiled bytecode (`.class` files) only
- **lib/**: Contains third-party JAR dependencies
- Prevents accidental sharing of source code to other developers

### Compilation Process

#### Basic Compilation
```bash
# Navigate to root directory
cd project-folder

# Set path to JDK
set PATH=C:/JDK/bin;%PATH%

# Compile without explicit destination (classes go to src/)
javac src/com/nit/hk/blogic/*.java

# Compile with explicit destination (recommended)
javac -d bin/ src/com/nit/hk/blogic/*.java
```

#### Compilation with `-d` Option
- **`-d bin/`**: Copies compiled classes to `bin/` directory
- Creates package structure automatically in `bin/`
- `src/` contains only `.java` files
- `bin/` contains `.class` files in package structure

### JAR Creation Commands

#### Basic JAR Creation
```bash
# Create JAR with classes from current directory
jar cvf ArithmeticOperations.jar com/

# Create JAR with verbose output
jar cvf ArithmeticOperations.jar com/  # Shows compression details

# Create JAR with manifest info
jar cvfm ArithmeticOperations.jar -C bin/ .
```

#### JAR Creation with Package Inclusion
```bash
# Include specific directory contents
jar cvf mylibrary.jar -C bin/ .

# Create JAR from bin directory classes
jar cvf aclasses.jar -C bin/ com/
```

> [!IMPORTANT]
> Always include **only `.class` files** in JAR to protect source code. Never include `.java` files when sharing with other developers.

## Lab Demo: Creating a JAR File

### Step 1: Create Project Structure
```
D:\Projects\
└── ArithmeticOperations\
    ├── src\
    │   └── com\
    │       └── nit\
    │           └── hk\
    │               └── blogic\
    │                   ├── Addition.java
    │                   ├── Subtraction.java
    │                   ├── Multiplication.java
    │                   └── Division.java
    └── bin\
```

### Step 2: Create Arithmetic Operation Classes

#### Addition.java
```java
package com.nit.hk.blogic;

public class Addition {
    public static int add(int a, int b) {
        int c = a + b;
        System.out.println("Addition Result: " + c);
        return c;
    }
}
```

#### Subtraction.java
```java
package com.nit.hk.blogic;

public class Subtraction {
    public static int sub(int a, int b) {
        int c = a - b;
        System.out.println("Subtraction Result: " + c);
        return c;
    }
}
```

#### Multiplication.java
```java
package com.nit.hk.blogic;

public class Multiplication {
    public static int mult(int a, int b) {
        int c = a * b;
        return c;  // Return without print
    }
}
```

#### Division.java
```java
package com.nit.hk.blogic;

public class Division {
    public static int div(int a, int b) {
        int c = a / b;
        return c;  // Return without print
    }
}
```

### Step 3: Compile Classes
```bash
# Set environment variables
set PATH=C:/JDK/bin;%PATH%
set CLASSPATH=%CLASSPATH%;.

# Compile classes to bin directory
javac -d bin/ src/com/nit/hk/blogic/*.java
```

### Step 4: Create JAR File
```bash
# Create JAR from compiled classes
jar cvf aclasses.jar -C bin/ com/
```

### Step 5: Share JAR with Other Developer

#### Distributed Structure
```
Developer_A/
└── ArithmeticOperations/
    ├── classes.jar  # Contains compiled bytecode
    └── README.txt   # Usage instructions
```

## Library vs Executable JAR Files

### JAR File Types

| Type | Purpose | Main Method | Manifest | Execution |
|------|--------|-------------|----------|-----------|
| **Library JAR** | Reuse/share classes | No | Not required | Cannot execute directly |
| **Executable JAR** | Standalone application | Yes | Required | Can run with `java -jar` |

### Library JAR Characteristics
- Contains **business logic classes only**
- Cannot be executed directly
- Requires **external classpath** configuration
- Used as dependency by other applications

### Executable JAR Characteristics  
- Contains **main method class**
- Can be executed with `java -jar` command
- **Self-contained** classpath configuration
- Ready for end-user deployment

## Executable JAR Files

### Why Executable JAR?
- **End-user delivery**: Customers don't need to install JDK or know Java commands
- **Convenient execution**: Single command to run application
- **Embedded dependencies**: No external JAR setup required

### Requirements for Executable JAR
1. **Main method class** present in JAR
2. **Manifest file** with Main-Class attribute
3. **Classpath** configured in manifest (optional)

## Executable JAR Files

### Manifest File

#### Purpose
- Configuration file inside JAR
- Located in `META-INF/MANIFEST.MF`
- Contains attributes describing the JAR

#### Default Manifest Content
```
Manifest-Version: 1.0
Created-By: 21 (Oracle Corporation)
```

#### Required for Executable JAR
```
Main-Class: com.nit.hk.main.Calc
Class-Path: . lib/aclasses.jar
```

#### Creating Custom Manifest
1. Create `manifest.mf` text file:
```
Main-Class: com.nit.hk.main.Calc
Class-Path: . lib/aclasses.jar
<empty line required>
```

2. Include in JAR creation: `jar cvfm main.jar manifest.mf -C bin/ .`

### Creating Executable JAR

#### Step 1: Create Main Class (Client/User Class)

##### Calc.java
```java
package com.nit.hk.main;

import com.nit.hk.blogic.Addition;
import com.nit.hk.blogic.Subtraction;
import com.nit.hk.blogic.Multiplication;
import com.nit.hk.blogic.Division;

public class Calc {
    public static void main(String[] args) {
        Addition.add(10, 20);
        Subtraction.sub(10, 5);
        System.out.println("Multiplication: " + Multiplication.mult(10, 20));
        System.out.println("Division: " + Division.div(20, 5));
    }
}
```

#### Step 2: Compile All Classes
```bash
# Compile business logic classes
javac -d bin/ src/com/nit/hk/blogic/*.java

# Compile main class
javac -d bin/ -cp bin/ src/com/nit/hk/main/*.java
```

#### Step 3: Create Executable JAR
```bash
# Method 1: Using -e option (only sets Main-Class)
jar cvfe main.jar com.nit.hk.main.Calc -C bin/ .

# Method 2: Using custom manifest file
jar cvfm main.jar manifest.mf -C bin/ .
```

#### Step 4: Place Dependencies
```
Calculator/
├── main.jar
└── lib/
    └── aclasses.jar
```

### Running Executable JAR

#### Basic Execution
```bash
java -jar main.jar
```

#### What Happens Internally
1. JVM checks `META-INF/MANIFEST.MF`
2. Reads `Main-Class` attribute
3. Loads the specified main class
4. Executes its `main()` method

#### Classpath Resolution
- JAR uses its **internal classpath** from manifest
- Does **not** depend on system CLASSPATH
- Dependencies referenced in manifest are resolved automatically

### Batch File for Easy Execution

#### run.bat (Windows)
```batch
java -jar main.jar
pause
```

#### Purpose of Batch File
- **End-user friendly**: Double-click to run
- **No command-line knowledge required**
- **Pause** keeps console window open to see output

## Project Distribution

### Complete Project Structure
```
Calculator/
├── main.jar          # Executable JAR
├── lib/              # Dependencies
│   └── aclasses.jar
├── run.bat          # Batch file for execution
└── README.txt       # Instructions
```

### Distribution Process
1. **Zip the project folder**
2. **Upload to distribution server**
3. **Customer downloads and extracts**
4. **Double-click run.bat to execute**

### Real-World Application
- **Software delivery**: Applications distributed as executable JARs
- **Library sharing**: JAR files uploaded to Maven repositories
- **Enterprise deployment**: JARs included in enterprise application archives

## Summary

### Key Takeaways
```diff
+ JAR files are compressed, platform-independent containers for Java classes and resources
+ Use JAR tool (jar.exe) for creating, listing, extracting, and updating JAR files
+ Separate src/ and bin/ directories to protect source code during compilation and packaging
+ Manifest file is crucial for executable JARs, containing Main-Class and Class-Path attributes
+ Executable JARs allow end-users to run applications without Java development knowledge
+ Batch files (.bat) provide user-friendly execution interface for Windows environments
+ JAR files enable efficient sharing and distribution of Java libraries across organizations
```

### Expert Insight

#### Real-world Application
- **Microservices deployment**: JAR files used to package and deploy individual services
- **Dependency management**: Tools like Maven/Gradle automatically manage JAR dependencies
- **Embedded applications**: JARs contain everything needed for standalone execution
- **Plugin systems**: JARs used for extending application functionality

#### Expert Path
- **Gradle/Maven**: Learn build automation tools that handle JAR creation automatically
- **Spring Boot fat JARs**: Study how frameworks create self-contained executable JARs
- **OSGi bundles**: Advanced modularization using JAR-based component architecture
- **Docker containers**: Understand how JARs are containerized for cloud deployment

#### Common Pitfalls
- ❌ **Including source files**: Never include .java files in distribution JARs
- ❌ **Missing manifest**: Executable JARs require proper manifest configuration
- ❌ **Classpath confusion**: Remember JAR uses manifest classpath, not system CLASSPATH
- ❌ **Missing dependencies**: Ensure all required JARs are included in lib/ directory

#### Lesser Known Things
- **JAR signing**: JARs can be digitally signed for security
- **Nested JAR reading**: Learn native JAR filesystem APIs (NIO.2) for resource access
- **Multi-release JARs**: Support different bytecode versions for Java versions
- **JLink/JMod**: Newer Java tools for creating custom runtime images beyond JARs

---  
🤖 Generated with [Claude Code](https://claude.com/claude-code)  
Co-Authored-By: Claude <noreply@anthropic.com>  
MODEL-ID: CL-KK-Terminal
