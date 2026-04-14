Session 34: Working with JAR Files and Packages - Interview Questions and Project

## Table of Contents
1. [Overview](#overview)
2. [Clarifying Types of Packages](#key-conceptsdeep-dive)
3. [Working with JAR Files](#working-with-jar-files)
4. [Types of JAR Files](#types-of-jar-files)
5. [Manifest File and Properties](#manifest-file-and-properties)
6. [Executing JAR Files](#executing-jar-files)
7. [Sharing Projects to Clients](#sharing-projects-to-clients)
8. [Working with Batch Files](#working-with-batch-files)
9. [Lab Demo: Modular Calculator Project](#lab-demo-modular-calculator-project)

## Overview
This session focuses on advanced Java concepts related to JAR files, packages, and modular project development. Building on previous discussions about compiling and packaging Java applications, the instructor clarifies misconceptions about package types and demonstrates practical project packaging and deployment techniques. The session emphasizes real-world software development practices, including modular architecture and automated execution via batch files.

## Key Concepts/Deep Dive

### Clarifying Types of Packages
JAR (Java Archive) files are essential for packaging Java applications and libraries. They contain compiled class files, resources, and metadata in a compressed format. JAR files enable easy distribution, execution, and reuse of Java code.

#### Common Options Used with the jar Command
- `-c`: Create a new JAR file
- `-v`: Verbose output during creation/listing
- `-f`: Specify JAR file name explicitly
- `-t`: List contents of JAR file
- `-x`: Extract files from JAR
- `-m`: Include manifest information from a specified manifest file
- `-M`: Do not create a manifest file (use with -c)
- `-C`: Change to specified directory when adding files

#### New Options in Java 9
- No direct equivalents listed in transcript, but demonstrates creation commands

#### Differences Between JAR and ZIP Files
JAR files are essentially ZIP files with a `.jar` extension and specific structures for Java applications. Both use ZIP compression, but JARs include Java-specific metadata and can be executed directly with the Java runtime.

#### META-INF Folder and Manifest File
The META-INF folder contains metadata about the JAR:
- `MANIFEST.MF`: A text properties file with KEY:VALUE pairs
- Properties must be separated by a colon (:)
- Each property on a new line
- An empty line must follow the last property

#### Important Properties in Manifest File
- `Main-Class`: Specifies the entry point class for executable JARs (e.g., com.nit.hk.b.logic.calc)
- `Class-Path`: Defines additional JARs/paths for the JVM to find classes (e.g., lib/addclasses.jar sub.jar mul.jar div.jar calc.jar)

### Overview of JAR File Types
```markdown
| JAR Type | Purpose | Manifest Required | Execution Method |
|----------|---------|-------------------|------------------|
| API JAR | Reuse code across projects | No | Not executable directly |
| Executable JAR | Run standalone applications | Yes (Main-Class) | java -jar filename.jar |
```

### Creating JAR Files
- **API JAR**: Contains reusable classes/libraries
  ```bash
  jar cvf classes.jar -C bin .
  ```
- **Executable JAR**: Requires manifest with Main-Class
  ```bash
  jar cvfm classes.jar manifest.mf -C bin .
  ```

### Accessing Classes from JAR Files
To access classes from another JAR:
- Use Class-Path in manifest file (not system classpath)
- Separate multiple JARs with spaces
- JAR files must be in a lib folder or specified path

### Executing a JAR File
```bash
java -jar executablejarfile.jar
```
- Executable JARs ignore system classpath and use manifest Class-Path
- For non-executable JARs, set CLASSPATH environment variable

## Working with JAR Files

### Options and Commands
#### Core jar Command Syntax
```bash
jar [options] [jarfile] [manifest] [-C dir files]
```

#### Key Options Explained
- `-cvf`: Create JAR with verbose output and specify filename
- Includes META-INF/manifest automatically unless `-M` specified
- Use `-C` to change directory for file inclusion

#### Compiling with Dependencies
- Compile to separate bin directory: `javac -d bin src/**/*.java`
- Include dependent JARs in classpath: `javac -cp lib/*.jar -d bin src/**/*.java`

## Types of JAR Files

### API JAR vs Executable JAR
- **API JAR**: Pure library code, no main method, for distribution to other developers
- **Executable JAR**: Complete application with main class, can run independently

### Examples
- Create API JAR: `jar cvf mylib.jar -C bin .`
- Create executable JAR: Use manifest file with Main-Class entry

## Manifest File and Properties

### Structure and Rules
- Located in `META-INF/MANIFEST.MF`
- Format: `Property-Name: Value`
- Each property on separate line
- Empty line after last property

### Correcting Spelling Error
Transcript contained "prit F" (likely print F for printf format specifiers) - corrected to `printf` for proper Java output.

### Setting Classpath in JAR
- Cannot use system classpath for executable JARs
- Must set in manifest:
  ```
  Class-Path: lib/jar1.jar lib/jar2.jar
  ```
- JARs must exist in lib folder relative to JAR location

## Executing JAR Files

### Command Line Execution
```bash
java -jar myapp.jar
```

### With Classpath Dependencies
- Only works for executable JARs using internal manifest classpath
- For testing non-executable code: `java -cp lib/*.jar:bin com.package.MainClass`

## Sharing Projects to Clients

### Standard Deliverable Package
- Include executable JAR
- Include batch file for easy execution
- Include all dependent JARs in lib folder
- Client runs batch file to start application

### Batch File Creation
- Text file with `.bat` extension
- Contains commands to execute JAR
- Example: `java -jar myapp.jar`

## Working with Batch Files

### Definition and Purpose
A batch file is a text file (`.bat` extension) containing multiple DOS commands executed sequentially. Used for repetitive tasks and automating JAR execution.

### Rules for Command Placement
- One command per line
- Commands execute in order
- Example batch file content:
  ```batch
  echo Starting application...
  java -jar myapp.jar
  pause
  ```

### Execution Location
- Run from command prompt in project directory
- Path should point to batch file
- Commands must reference correct relative paths

## Lab Demo: Modular Calculator Project

### Project Requirements
Develop a modular calculator performing addition, subtraction, multiplication, and division operations.

### Moduler Architecture
- **5 Modules**: Represented as separate folders with individual JARs
- **5 Packages**: com.nit.hk.b.logic.add, sub, mul, div, calc
- **5 Developers**: Simulated separate development teams
- **Final Assembly**: Calculator module combines all JARs into executable

### Project Structure
```
project-calc/
├── add-module/
│   ├── src/
│   │   └── com/nit/hk/b/logic/add/
│   │       └── Addition.java
│   └── lib/
├── sub-module/
│   ├── src/
│   │   └── com/nit/hk/b/logic/sub/
│   │       └── Subtraction.java
│   └── lib/
├── mul-module/
│   ├── src/
│   │   └── com/nit/hk/b/logic/mul/
│   │       └── Multiplication.java
│   └── lib/
├── div-module/
│   ├── src/
│   │   └── com/nit/hk/b/logic/div/
│   │       └── Division.java
│   └── lib/
└── calc-module/
    ├── src/
    │       └── com/nit/hk/b/logic/calc/
    │           └── Calculator.java
    ├── lib/
    └── manifest.mf
```

### Development Steps for Each Module (Repeat 5x)

1. **Create Module Folder Structure**
```
mkdir add-module
cd add-module
mkdir src
mkdir lib
```

2. **Create Package Structure**
```
mkdir -p src/com/nit/hk/b/logic/add
```

3. **Develop Java Class**
Example Addition.java:
```java
package com.nit.hk.b.logic.add;

public class Addition {
    public static void add(double a, double b) {
        double c = a + b;
        System.out.printf("The addition of %.2f + %.2f is %.2f%n", a, b, c);
    }
}
```

4. **Compile Class**
```bash
cd [module-folder]
javac -d bin src/com/nit/hk/b/logic/[package]/*.java
```

5. **Create JAR File**
```bash
# For API JARs (non-executable)
jar cvf [packagename]classes.jar -C bin .

# For executable JAR (final calculator)
jar cvfm calcclasses.jar manifest.mf -C bin .
```

6. **Share JARs to Calculator Module**
```
Copy [package]classes.jar to calc-module/lib/
```

### Calculator Module Assembly

1. **Create Manifest File**
```
Main-Class: com.nit.hk.b.logic.calc.Calculator
Class-Path: lib/addclasses.jar lib/subclasses.jar lib/mulclasses.jar lib/divclasses.jar
```

2. **Develop Calculator.java**
```java
package com.nit.hk.b.logic.calc;
import java.util.Scanner;
import com.nit.hk.b.logic.add.Addition;
import com.nit.hk.b.logic.sub.Subtraction;
import com.nit.hk.b.logic.mul.Multiplication;
import com.nit.hk.b.logic.div.Division;

public class Calculator {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        System.out.println("Enter operation (+, -, *, /): ");
        char op = scanner.next().charAt(0);
        System.out.println("Enter two numbers: ");
        double a = scanner.nextDouble();
        double b = scanner.nextDouble();
        
        switch(op) {
            case '+': Addition.add(a, b); break;
            case '-': Subtraction.subtract(a, b); break;
            case '*': Multiplication.multiply(a, b); break;
            case '/': Division.divide(a, b); break;
            default: System.out.println("Invalid operation");
        }
    }
}
```

3. **Compile with Dependencies**
```bash
cd calc-module
javac -cp lib/*.jar -d bin src/com/nit/hk/b/logic/calc/*.java
```

4. **Create Executable JAR**
```bash
jar cvfm calculator.jar manifest.mf -C bin .
```

5. **Create Batch File for Distribution**
```
java -jar calculator.jar
pause
```

### Corrected Spelling/Grammar Errors from Transcript
- "ript" → "Transcript" (document start)
- "prit F" → "printf" (formatting method)
- "command prom" → "command prompt" (multiple occurrences)
- "part" → "version" (in context)
- "hyund" → "hyphen" (command option prefixes)
- "page number any" → "page number 105" (referenced material)
- "Hob HOC hoc hypho H ḥ eligible" → "javac -d bin -cp lib/*.jar src/**/*.java" (compiled compilation commands)

## Summary

### Key Takeaways
```diff
+ Working with JAR files requires understanding manifest properties and classpath configuration
+ Packages are classified as parent packages and subpackages, not predefined vs user-defined
+ Modular development separates concerns and enables team collaboration
+ Batch files automate repetitive command execution tasks
+ Executable JARs include Main-Class in manifest and use internal Class-Path settings
- Mistaking package precedence as predefined/user-defined leads to confusion
- Omitting META-INF/MANIFEST.MF empty line breaks properties parsing
- Failing to compile to separate bin directory causes classpath issues
```

### Expert Insight

#### Real-world Application
This modular JAR approach is crucial for microservices development, where each service can be packaged as separate JARs with well-defined APIs. Enterprise applications use similar reflection for building scalable systems, where dependency management prevents "JAR hell" scenarios.

#### Expert Path
Master manifest manipulation for complex classpath dependencies. Learn to use tools like Maven/Gradle (not covered here but mentioned in material) for automated JAR management. Study JVM classpath resolution order for troubleshooting dependency conflicts.

#### Common Pitfalls
- **Departing JAR placement**: External JARs must be accessible via manifest Class-Path; placing inside another JAR fails.
- **Permace Path removal**: Removing permanent Java path from system variables breaks command-prompt compilation.
- **Forgotten empty line in manifest**: Last property won't be read without trailing empty line.
- **Mixed JAR types**: Using API JAR where executable JAR is needed, or vice versa.

#### Lesser Known Aspects
- JARs are ZIP-compatible; you can rename .jar to .zip to inspect contents with standard tools.
- META-INF folder can contain additional metadata like services configurations for SPI (Service Provider Interface).
- Java 8+ supports multi-release JARs with versioned class directories.
- The jar command's verbose (-v) option shows compression ratios and helps identify packaging errors.
