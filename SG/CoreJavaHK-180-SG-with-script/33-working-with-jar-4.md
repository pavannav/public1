# Session 33: Working With Jar 4

## Table of Contents
- [Working With Jar Files](#working-with-jar-files)
- [Summary](#summary)

## Working With Jar Files

## Overview
This session covers advanced concepts of working with JAR (Java Archive) files in a project environment, including creating executable JAR files, handling manifest files for classpath dependencies, team development workflows across multiple developers, and complete project packaging and distribution processes. The focus is on practical implementation scenarios that mirror real-world software development practices.

## Key Concepts/Deep Dive

### Types of JAR Files (Review)
The session begins with a review of different types of JAR files discussed in previous sessions, setting the foundation for advanced JAR manipulation techniques.

### Executable JAR File Creation

#### Manual Manifest Creation Approach
The instructor demonstrates the traditional approach to creating manifest files manually, though notes limitations for complex projects.

**Steps for Manual Manifest Creation:**
1. Open text editor/notepad
2. Type manifest properties with specific syntax
3. Save as manifest.mf
4. Use JAR command to include the manifest

```bash
# Example manifest.mf content
Main-Class: com.nit.hk.user.Test
Class-Path: lib/pojo.jar lib/blogic.jar

```

**Critical Manifest Rule:** Always include one empty new line at end of manifest file - without this, properties won't be copied to the JAR.

#### Programmatic JAR Creation with Manifest

The recommended approach using JAR command with manifest inclusion:

```bash
jar --create --file main.jar --manifest mymanifest.mf -C bin .
```

**Command Breakout:**
- `jar`: Command
- `--create` or `-c`: Create archive
- `--file [filename]`: Specify output JAR name  
- `--manifest [manifestfile]`: Include existing manifest file
- `-C [directory]`: Change to specified directory

### Project Structure and Developer Roles

The session introduces a multi-developer project structure mimicking company workflows:

```
WorkingWithJar/
├── Developer1/
│   ├── src/
│   ├── bin/
│   ├── lib/
│   └── distribute/
├── Developer2/
│   ├── src/
│   ├── bin/
│   ├── lib/
│   └── distribute/
└── User/
    ├── src/
    ├── bin/
    ├── lib/
    └── distribute/
```

#### Developer 1 Role: POJO Classes
```java
// Developer1/src/com/nit/hk/pojo/A.java
package com.nit.hk.pojo;

public class A {
    public void m1() {
        System.out.println("A M1");
    }
}
```

**Compilation and JAR Creation:**
```bash
# In Developer1/
javac -d bin src/com/nit/hk/pojo/A.java
jar --create --file distribute/pojo-classes.jar -C bin .
```

#### Developer 2 Role: Business Logic Classes
```java
// Developer2/src/com/nit/hk/blogic/B.java  
package com.nit.hk.blogic;

import com.nit.hk.pojo.A;

public class B {
    public void m2() {
        System.out.println("B M2 start");
        A a1 = new A();
        a1.m1();
        System.out.println("B M2 end");
    }
}
```

**Dependency Handling:**
```bash
# In Developer2/
set CLASSPATH=lib/pojo-classes.jar
javac -d bin src/com/nit/hk/blogic/B.java
```

**B-logic JAR Creation with Classpath:**
```bash
# Create manifest for b-logic.jar
echo "Class-Path: lib/pojo-classes.jar" > distribute/b-logic-manifest.mf
# Note: Don't forget empty line at end!

jar --create --file distribute/b-logic-classes.jar --manifest distribute/b-logic-manifest.mf -C bin .
```

#### User/Developer 3 Role: Main Application

```java
// User/src/com/nit/hk/user/Test.java
package com.nit.hk.user;

import com.nit.hk.pojo.A;
import com.nit.hk.blogic.B;

public class Test {
    public static void main(String[] args) {
        System.out.println("Project execution start");
        
        A a1 = new A();
        a1.m1();
        
        B b1 = new B(); 
        b1.m2();
        
        System.out.println("Project execution end");
    }
}
```

### Classpath Management: Two Levels

**1. Compilation-time Classpath:**
```bash
# User compilation with dependencies
set CLASSPATH=lib/pojo-classes.jar;lib/b-logic-classes.jar
javac -d bin src/com/nit/hk/user/Test.java
```

**2. Runtime Classpath in Manifest:**
```bash
# For executable JAR
Main-Class: com.nit.hk.user.Test
Class-Path: lib/pojo-classes.jar lib/b-logic-classes.jar
```

**Key Difference:** Manifest classpath uses spaces as separators (not semicolons) and paths are relative to JAR file location.

### Complete Project Packaging

#### Creating Executable JAR
```bash
# User/distribute/ - Final packaging location

# Create main manifest with classpath and main class
# Save as distribute/user-manifest.mf:
Main-Class: com.nit.hk.user.Test
Class-Path: lib/pojo-classes.jar lib/b-logic-classes.jar

jar cvfm main.jar distribute/user-manifest.mf -C ../bin .
```

#### Distribution Bundle Creation

**Files to Include:**
- main.jar (executable JAR)
- lib/pojo-classes.jar
- lib/b-logic-classes.jar
- run.bat (batch file for easy execution)

**Batch File Creation:**
```batch
# run.bat content
java -jar main.jar
pause
```

**Final Project Archiving:**
```bash
# Create project bundle (like JDK distribution)
# Copy all distribution files to Sims/ folder
# Zip Sims/ folder as Sims.zip for distribution
```

### Client Distribution and Execution

**Client Process:**
1. Download Sims.zip project bundle
2. Extract to C:\ drive (creates Sims/ folder)
3. Open command prompt
4. Navigate to Sims folder: `cd Sims`
5. Execute: `run.bat` or `java -jar main.jar`

**JDK Parallels:** Same process Oracle uses for JDK distribution - download ZIP, extract, execute batch/command files.

### Lab Demos

#### Complete Project Workflow Demo

**Step 1: Developer 1 - POJO Class Creation**
1. Create folder structure: `Developer1/src/com/nit/hk/pojo/`
2. Create A.java as shown above
3. Compile: `javac -d bin src/com/nit/hk/pojo/A.java`
4. Create JAR: `jar cvf distribute/pojo.jar -C bin .`
5. Share `distribute/pojo.jar` to other developers

**Step 2: Developer 2 - Business Logic with Dependencies**
1. Copy `pojo.jar` to `Developer2/lib/`
2. Create folder structure: `Developer2/src/com/nit/hk/blogic/`
3. Create B.java with import and usage of A class
4. Set classpath: `set CLASSPATH=lib/pojo.jar`
5. Compile: `javac -d bin src/com/nit/hk/blogic/B.java`
6. Create manifest: `echo Class-Path: lib/pojo.jar > distribute/b-manifest.mf` (add empty line!)
7. Create JAR: `jar cvfm distribute/blogic.jar distribute/b-manifest.mf -C bin .`
8. Share `distribute/blogic.jar` to User developer

**Step 3: User Developer - Main Application Integration**
1. Copy both JARs to `User/lib/`
2. Create main class Test.java as shown
3. Compile with dependencies: `set CLASSPATH=lib/pojo.jar;lib/blogic.jar` then `javac ...`
4. Test locally: `java -cp bin;lib/pojo.jar;lib/blogic.jar com.nit.hk.user.Test`
5. Create executable JAR:
   - Create manifest with main class and classpath
   - Run: `jar cvfm main.jar manifest.mf -C bin .`
6. Test executable JAR: `java -jar main.jar`
7. Create run.bat for client convenience
8. Bundle all files (main.jar, lib/ folder, run.bat) into ZIP for distribution

**Step 4: Client Execution Demo**
1. Extract ZIP to C:\Sims\
2. Double-click run.bat (opens CMD, executes automatically)
3. Program runs successfully with all dependencies resolved

#### Common Error Resolving Demos

**Error: Main class not executable**
- **Cause:** Main-Class entry missing in manifest or JAR created without -m flag
- **Solution:** Add Main-Class: fully.qualified.class.name to manifest, use -m flag

**Error: ClassNotFoundException**
- **Cause:** Dependent classes not in classpath or JAR paths in manifest incorrect
- **Solution:** Verify manifest classpath entries use correct relative paths from JAR location

**Error: JAR cannot access JARs inside itself**
- **Cause:** Including dependent JAR files inside main JAR (fat JAR anti-pattern)
- **Solution:** Keep dependent JARs in separate lib/ folder, reference via classpath in manifest

#### JAR File Inspection Demo
```bash
java -jar main.jar  # Execute
# Use WinRAR/7-Zip to inspect contents
# Verify META-INF/MANIFEST.MF has correct entries
```

### Diploma Creation Tables

| Aspect | Developer 1 | Developer 2 | User/Developer 3 | Client |
|--------|-------------|-------------|------------------|--------|
| Role | POJO Creation | Business Logic | Main Application | Software User |
| Output | pojo.jar | blogic.jar | main.jar + bundle | Execution |
| Dependencies | None | pojo.jar | pojo.jar + blogic.jar | None (bundled) |
| Tools | javac, jar | javac, jar | javac, jar, zip | run.bat |

| JAR Type | Purpose | Manifest Required | Classpath Handling |
|----------|---------|-------------------|-------------------|
| Library JAR | Code reuse | No | Set externally |
| Executable JAR | Standalone app | Yes (Main-Class) | Via manifest |
| Dependency JAR | Referenced | Sometimes | Manifest or external |

## Summary

### Key Takeaways
```diff
+ Executable JAR files require Main-Class entry in MANIFEST.MF and empty newline at file end
+ Classpath in manifest uses space separators and relative paths to JAR file location
+ Multi-developer projects distribute JAR files through lib/ folders, not embedded in other JARs
+ Project distribution mirrors JDK approach: ZIP bundle with JARs, batch files, and documentation
+ Batch files (.bat) provide one-click execution for end users without command line knowledge
- Common mistake: Including dependent JARs inside main JAR breaks class resolution
- Manifest files must use Class-Path (hyphenated) not ClassPath
- WinRAR/7-Zip should never be used for JAR creation due to proper manifest copying issues
- Developer roles must be practiced individually to understand complete workflow
! JAR files cannot access other JAR files when embedded - use external lib/ folder structure
! Batch files require .bat extension and proper Java command paths for client execution
```

### Expert Insight
#### Real-world Application
Enterprise Java applications use this exact JAR packaging approach: Spring Boot creates executable JARs with embedded dependencies, Maven/Gradle automate manifest generation, Docker containers bundle JAR applications for cloud deployment, and software vendors distribute through downloadable ZIP archives with setup scripts.

#### Expert Path
Master JAR manipulation through: understanding Maven Shade/Fat JAR plugins for true bundling, creating modular JARs with Java 9+ module system, implementing proper versioning in manifest files, using Gradle for complex multi-module builds, and learning Spring Boot executable JAR internals for microservices architecture.

#### Common Pitfalls
Manifest file creation errors - forgetting empty newline causes classpath to not copy; JAR embedding JARs - dependentONJARs must stay external for access; classpath path syntax errors - spaces not semicolons in manifest, relative paths critical, WinRAR copy corruption; execution permission issues - batch files need proper Java path handling; development siloed thinking - each developer role must be practiced to understand integration points.

#### Lesser Known Things About This Topic
JAR files evolved from ZIP format with META-INF/MANIFEST.MF as entry point; Oracle's JDK distribution ZIP contains jmods for modular system; executable JARs use URLClassLoader internally for dependency resolution; Gradle wrapper (gradlew) is essentially a JAR-based execution mechanism; Java agents modify runtime through manifest entries extending capabilities beyond basic execution.
