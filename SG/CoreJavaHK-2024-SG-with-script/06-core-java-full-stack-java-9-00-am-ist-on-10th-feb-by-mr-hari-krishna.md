## Session 6: Essential Statements and First Java Program

> [!NOTE]
> This session focuses on the fundamental building blocks of Java programs, including essential statements and steps for development, compilation, and execution. Based on the transcript from the 6th class on February 10th, 2025, covering Core Java basics within the Fullstack Java curriculum.

### Table of Contents
- [Fullstack Java Curriculum Overview](#fullstack-java-curriculum-overview)
- [Core Java Syllabus and Details](#core-java-syllabus-and-details)
- [Java as Multi-Paradigm Programming Language](#java-as-multi-paradigm-programming-language)
- [Platform Independence](#platform-independence)
- [JDK Software Installation](#jdk-software-installation)
- [Essential Statements for Java Programs](#essential-statements-for-java-programs)
- [Steps to Develop, Compile, and Execute Java Programs](#steps-to-develop-compile-and-execute-java-programs)
- [First Java Program Example](#first-java-program-example)

### Fullstack Java Curriculum Overview

#### Overview
Fullstack Java is a comprehensive course covering complete project development skills, divided into 5 modules: Core Java, Database, UI, DevOps, and Cloud Computing. By the end, students acquire expertise to handle entire project layers without depending on others.

#### Key Concepts/Deep Dive
Fullstack Java consists of:
1. **Java Module** (Core Java) - Currently being taught
2. **Database Module** - For data storage and management
3. **UI Module** - For user interfaces
4. **DevOps Module** - For deployment and operations
5. **Cloud Computing Module** - For cloud-based applications

The curriculum emphasizes discussion-style learning with active student participation to ensure deep understanding and confidence in next topics.

- **Learning Style**: Discussion-focused, requiring responses to questions for fast comprehension and confidence building
- **Importance**: Enables handling various application types including desktop, web, enterprise, distributed, and interoperable applications
- **Discussion vs. Listening**: Active participation leads to faster learning and better grasp of complex topics
- **Recording Policy**: Recordings available only via extra payment; encourages active attendance over passive viewing

### Core Java Syllabus and Details

#### Overview
Core Java is the first and foundational module, focusing on basic Java programming concepts, divided into 5 units spanning several weeks with daily classes.

#### Key Concepts/Deep Dive
- **Duration**: 5 units, approximately 5-6 months
- **Weekly Classes**: 5-7 days per week
- **Daily Hours**: Around 2-3 hours per session
- **Start Date**: 2 weeks after course start
- **Focus**: Covers object-oriented programming, functional programming, and more advanced features

#### Lab Demos
- Daily practice sessions with code writing and execution
- Emphasis on hands-on development rather than theory-only learning

### Java as Multi-Paradigm Programming Language

#### Overview
Java supports multiple programming paradigms, making it versatile for different application types, from large enterprise systems to data processing and modern frameworks.

#### Key Concepts/Deep Dive
Java supports four/five programming styles:
- **Object-oriented Programming** (since Java 1.0): Classes, objects, inheritance, polymorphism
- **Functional Programming** (since Java 8): Lambda expressions, streams
- **Modular Programming** (since Java 9): Modular system for better code organization
- **Data-oriented Programming** (since Java 21): Record classes and data manipulation

> [!IMPORTANT]
> Java's multi-paradigm nature makes it ideal for complex applications requiring different programming approaches.

#### Tables

| Programming Paradigm | Introduced Version | Key Features |
|---------------------|--------------------|--------------|
| Object-oriented | Java 1.0 | Classes, inheritance, encapsulation |
| Functional | Java 8 | Lambdas, streams |
| Modular | Java 9 | Module system (JPMS) |
| Data-oriented | Java 21 | Records, immutable data |

### Platform Independence

#### Overview
Platform independence allows Java programs to run on any operating system with a JVM, crucial for internet applications that need global accessibility.

#### Key Concepts/Deep Dive
- **Platform Definition**: Environment of OS where programs execute
- **Platform Dependency**: Programs executable only on specific OS (e.g., C++, C)
- **Platform Independence**: Programs executable across different OS (Java, Python, PHP)
- **Internet Application Need**: Must run on Windows, Linux, macOS, etc.
- **Why Required**: Global distribution via internet necessitates cross-platform compatibility

#### Tables

| Programming Language | Platform Type | Example Applications |
|---------------------|---------------|----------------------|
| Java | Independent | Web applications, enterprise systems |
| C++ | Dependent | System software, games |
| Python | Independent | Data science, web apps |
| C | Dependent | Operating systems, embedded |

### JDK Software Installation

#### Overview
JDK provides essential tools (compiler, JVM) for Java development, available for free from Oracle's website.

#### Key Concepts/Deep Dive
- **Components**: JDK includes compiler (javac), JVM, library classes, documentation
- **Installation Path**: Recommended to install in custom path (e.g., C:\JDK21) instead of default Program Files due to potential issues
- **Download Source**: oracle.com or search for "JDK download"
- **Verification**: Use `java -c` command in command prompt to confirm successful installation

#### Lab Demos
1. Open browser and navigate to oracle.com
2. Click "Java downloads" or search "JDK download"
3. Select appropriate version (recommend Java 21 or latest LTS)
4. Choose OS (Windows/MAC) and download .exe/.dmg file
5. Run installation file
6. Click "Next" and "Change" to set custom path like C:\JDK21
7. Click "OK", "Next", and finish installation
8. Open command prompt and run `java -c` to verify installation
9. If successful, command prompt shows Java compiler options

> [!NOTE]
> Avoid installing in Program Files folder to prevent path issues.

### Essential Statements for Java Programs

#### Overview
Three essential statements form the foundation of every Java program: class declaration, main method, and print statement.

#### Key Concepts/Deep Dive
Every Java program requires:
1. **Class Declaration**: Starting point as Java is object-oriented
2. **Main Method**: Entry point for program execution
3. **Print Statement**: For outputting results to console

#### Code/Config Blocks
```java
class MyFirstProgram {
    public static void main(String[] args) {
        System.out.println("Hello, HK Programming World!");
    }
}
```

- **Class**: Essential for compilation; defines program structure
- **Main Method**: Essential for execution; JVM starts here
- **System.out.println():** Essential for displaying output
- **Case Sensitivity**: Java is case-sensitive; keywords must be lowercase
- **Method Syntax**: Fixed syntax for main method with `public static void main(String[] args)`

> [!IMPORTANT]
> Without main method, compilation succeeds but execution fails. Without class, both compilation and execution fail.

### Steps to Develop, Compile, and Execute Java Programs

#### Overview
Java program development involves 7 systematic steps from creation to execution, ensuring proper file organization and command-line operations.

#### Key Concepts/Deep Dive
**7-Step Process**:
1. Open notepad/text editor
2. Type Java program code
3. Save with .java extension in organized folder structure
4. Open command prompt
5. Change drive and directory to project folder
6. Compile using `javac` command
7. Execute using `java` command

#### Code/Config Blocks
```bash
# Step 5: Change to appropriate directory
D:\
cd D:\FSJD\01-CJ\01-JB

# Step 6: Compile
javac FirstProgram.java

# Step 7: Execute
java FirstProgram
```

#### Tables

| Step | Action | Command Example |
|------|--------|-----------------|
| 1 | Open editor | notepad |
| 2 | Type program | class, main method, print statement |
| 3 | Save file | FirstProgram.java |
| 4 | Open CMD | cmd |
| 5 | Change directory | cd D:\FSJD\01-CJ\01-JB |
| 6 | Compile | javac FirstProgram.java |
| 7 | Execute | java FirstProgram |

- **Folder Organization**: Use structured folders like D:\FSJD\01-CJ\01-Java-Basics to separate programs by course and topic
- **Drive Selection**: Save in D: drive (or E:); keep C: drive for OS and software only
- **Path Issues**: Never save programs in JDK bin folder; use custom project directories
- **Class File Generation**: Compilation creates .class files with bytecode for JVM execution

#### Lab Demos
1. Create folder: D:\FSJD\01-CJ\01-JB
2. Open notepad, type program, save as FirstProgram.java in the folder
3. Open command prompt
4. Type `D:` to change drive
5. Type `cd D:\FSJD\01-CJ\01-JB` to change directory
6. Type `javac FirstProgram.java` to compile
7. Type `java FirstProgram` to execute and see output

> [!NOTE]
> File name can differ from class name; .class file uses class name, but execution uses class name without .class extension.

### First Java Program Example

#### Overview
The first Java program demonstrates the essential statements by printing a custom message to the console, serving as a foundation for all future programs.

#### Key Concepts/Deep Dive
- Program displays "HK Programming World" message
- Demonstrates proper indentation for V-shaped program structure
- File can be saved with any name (e.g., example.java); class name determines .class file
- No compilation errors if class/main method/SOP are present

#### Code/Config Blocks
```java
class FirstProgram {
    public static void main(String[] args) {
        System.out.println("HK Programming World");
    }
}
```

#### Lab Demos
1. Open notepad
2. Type the three essential statements with proper indentation
3. Save as example.java in D:\FSJD\01-CJ\01-JB
4. Open command prompt
5. Execute: `D:`
6. Execute: `cd D:\FSJD\01-CJ\01-JB`
7. Execute: `javac example.java`
8. Execute: `java FirstProgram` (note: use class name for execution)
9. Expected output: HK Programming World

### Summary

#### Key Takeaways
```diff
! Java programs require three essential statements: class, main method, and print statement
+ Platform independence makes Java ideal for internet applications running across different operating systems
+ Multi-paradigm support (OOP, functional, modular, data-oriented) enables versatile programming approaches
+ Save .java files in organized project directories, never in JDK bin folder
+ Compilation creates .class bytecode files; execution requires class name without extension
! 7-step development process ensures systematic program creation and execution
+ Case sensitivity, proper indentation, and V-shaped structure are critical for readable code
- Skip main method and programs compile but won't execute
```

#### Expert Insight

**Real-world Application**: 
In enterprise environments, understanding these essentials allows developers to create cross-platform applications that run not just locally but across global server infrastructures (AWS, Azure, GCP). The 7-step process becomes muscle memory for continuous integration pipelines in CI/CD workflows.

**Expert Path**: 
Begin with notepad for raw understanding, then transition to IDEs like Eclipse for complex projects. Focus on mastering compilation/execution from command line before IDE shortcuts. Practice daily program variations to build confidence, targeting 5-10 small programs per session.

**Common Pitfalls**: 
- **Walkthrough issues**: Rushing through steps leads to path errors; verify directory changes after each command. Typing mistakes in main method syntax cause runtime failures; always check bracket pairs and semicolons. 
- **JDK path problems**: Installing in Program Files causes Windows permission issues; use custom paths like C:\JDK21. 
- **File naming confusion**: Using different java file/class names works but confuses execution; develop habit of matching names for clarity. 
- **Indentation neglect**: Poor formatting reduces code readability and maintainability; always follow V-shaped structure. 
- **Directory saving**: Desktop saves prevent compilation; use structured D:\FSJD\[batch]\[course]\[chapter] folders.
- **Platform dependency misunderstanding**: Java runs anywhere with JVM, but forgetting JDK installation or path setup on new machines causes "command not found" errors.
