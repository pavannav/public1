# Session 35: Project contd And Modifiers

## Table of Contents
- [Project Continuation (JAR Files, Manifest, Batch Files, Delivery)](#project-continuation-jarr-files-manifest-batch-files-delivery)
  - [Setting Classpath and Compiling Module](#setting-classpath-and-compiling-module)
  - [Running Calc Class](#running-calc-class)
  - [Creating Manifest File](#creating-manifest-file)
  - [Creating JAR File](#creating-jarr-file)
  - [Executing JAR File](#executing-jarr-file)
  - [Creating Batch File](#creating-batch-file)
  - [Preparing Project ZIP for Delivery](#preparing-project-zip-for-delivery)
  - [JAR File Concepts and Resources](#jar-file-concepts-and-resources)
- [Modifiers](#modifiers)
  - [What is a Modifier](#what-is-a-modifier)
  - [Why Modifier](#why-modifier)
  - [Types of Modifiers](#types-of-modifiers)
  - [Access Level Modifiers](#access-level-modifiers)
  - [Execution Level Modifiers](#execution-level-modifiers)
  - [File Level Modifiers](#file-level-modifiers)

## Project Continuation: JAR Files, Manifest, Batch Files, Delivery

### Setting Classpath and Compiling Module

To compile a module that uses external JAR files, navigate to the module directory and set the classpath including all required JAR files.

```bash
cd calci
set classpath=%classpath%;lib/addclasses.jar;lib/subclasses.jar;lib/mulclasses.jar;lib/divclasses.jar
javac calci/*.java
```

This adds the four JAR files to the classpath and compiles the classes in the calci module.

### Running Calc Class

After compilation, you can run the Calc class directly using the classpath.

```bash
java -cp %classpath% calci.Calc
```

This executes the Calc class using Java with the previously set classpath.

### Creating Manifest File

Create a manifest file to specify the main class and classpath for the JAR file.

1. Open Notepad.
2. Type the following content (including spaces after semicolons for JAR files):
   ```
   Manifest-Version: 1.0
   Class-Path: lib/addclasses.jar lib/subclasses.jar lib/mulclasses.jar lib/divclasses.jar
   Main-Class: calci.Calc

   ```
3. Save the file as `manifest.mf` in the calci module directory, ensuring there's an empty line at the end.

### Creating JAR File

Use the `jar` command to create the JAR file with the manifest.

```bash
jar cvfm calc.jar manifest.mf -C calci .
```

- `cvfm`: Create JAR, Verbose, File (manifest), Main
- `calc.jar`: Output JAR file name
- `manifest.mf`: Manifest file
- `-C calci .`: Change to calci directory and include all files

### Executing JAR File

After creating the JAR file, execute it directly:

```bash
java -jar calc.jar
```

This runs the JAR file using the specified main class from the manifest.

### Creating Batch File

Create a batch file for easy execution of the JAR file.

1. Open Notepad.
2. Type: `java -jar calc.jar`
3. Save as `run.bat` in the calci module directory.

Run the batch file:

```bash
run.bat
```

This executes the JAR file automatically.

### Preparing Project ZIP for Delivery

Create a ZIP file containing the project for client delivery:

1. Create a new folder named `calc` inside a `dist` folder in the calci module.
2. Copy the following from calci module to `dist/calc`:
   - `lib` folder (containing the four JAR files)
   - `calc.jar` (executable JAR file)
   - `run.bat` (batch file)
3. Right-click on the `calc` folder in `dist`, select "Add to Archive", choose ZIP format, and name it `calc.zip`.

Send this `calc.zip` file to the client for deployment.

### JAR File Concepts and Resources

JAR (Java Archive) files are used for packaging Java applications and libraries. Key concepts include:

- **Manifest File**: Defines main class, classpath, and other attributes.
- **Signing and Verifying JAR Files**: For security, using jarsigner.
- **JAR Class Loader**: Handles loading classes from JAR files.
- **Sealing Packages**: Prevents package extension in JAR.
- **JAR Runner**: Utility for running JAR files.

Resources:
- Oracle Java Tutorial: Packaging Programs in JAR Files
- Topics: Creating/modifying/viewing/extracting JAR files, Manifest files, Running packaged software, Class-path setting, Application entry points.

> [!NOTE]
> JAR files follow the same process on Windows, Linux, and macOS since Java is platform-independent.

## Modifiers

### What is a Modifier

A modifier is a keyword that changes the default behavior of a programming element (class, variable, method).

Example: By default, variables in a class have no memory until an object is created. Using `static` provides memory without creating an object:

```java
class Example {
    static int a = 10; // Memory allocated at class level
    public static void main(String[] args) {
        System.out.println(a); // Output: 10
    }
}
```

Without `static`, accessing `a` from a static context (like `main`) would throw an error.

### Why Modifier

Modifiers change the default functionality of programming elements. They are used for:
- Setting access levels (where to access)
- Setting execution levels (how to access, how to execute)

Modifiers are optional but crucial for real-world coding. Without modifiers, writing code is possible but difficult.

### Types of Modifiers

Java supports 13 modifiers, divided into three categories:

1. **Access Level Modifiers** (4): Control accessibility (private, default, protected, public)
2. **Execution Level Modifiers** (8): Control execution and access behavior (static, final, abstract, native, synchronized, transient, volatile, strictfp)
3. **File Level Modifiers** (1): Control file type (interface for creating interface files instead of class files)

### Access Level Modifiers

Access modifiers control where a programming element can be accessed from. There are four:

1. **Private**: Accessible only within the same class
   ```java
   private int b = 20; // Cannot access from another class
   ```

2. **Default** (Package-private): Accessible within the same package

3. **Protected**: Accessible within same package and subclasses

4. **Public**: Accessible everywhere

Order: private < default < protected < public (ascending accessibility)

### Execution Level Modifiers

These control how elements are accessed and executed. There are eight:

1. **Static**: Provides memory at class level, accesses without object
2. **Final**: Prevents modification of variable/method/class
3. **Abstract**: For abstract classes and methods (pure methods without body)
4. **Native**: Indicates method is implemented in native code (e.g., JNI)
5. **Synchronized**: For thread-safe methods
6. **Transient**: Excludes variables from serialization
7. **Volatile**: Ensures variable visibility in multithreaded environments
8. **Strictfp**: Ensures floating-point operations are platform-independent

### File Level Modifiers

Only one: **interface**. Used to create interface files instead of class files.

```java
interface MyInterface { // Creates an interface file
}
```

## Summary

### Key Takeaways
```diff
+ Modifiers are keywords that modify default behavior of programming elements
+ 13 modifiers categorized as access level, execution level, and file level
+ Access modifiers: private, default, protected, public
+ Critical for setting permissions and execution rules in Java
+ JAR files use manifest for classpath and main class specification
- Confusing JAR file creation commands can lead to errors
- Without modifiers, code becomes hard to manage in real projects
! Always include manifest version in JAR manifest files
! Use correct order: private < default < protected < public
```

### Expert Insight

#### Real-world Application
In enterprise applications, modifiers control encapsulation (private/protected), thread safety (synchronized), and performance (static/final). JAR files are used for microservices deployment, where manifest specifies entry points and dependencies ensure portable execution across servers.

#### Expert Path
Master modifiers by experimenting with all combinations in Eclipse/IntelliJ. Study JAR signing for secure deployments. Practice creating executable JARs for standalone apps, then move to multi-module Maven projects for advanced JAR management.

#### Common Pitfalls
- **Classpath issues**: Forgetting to set classpath when running JAR leads to "Class not found" errors. Always verify paths.
- **Manifest errors**: Missing empty line at end of manifest causes silent failures. Ensure proper syntax.
- **Modifier misuse**: Overusing static defeats OOP; ignoring final leads to unintended mutations.
- **Naming inconsistencies**: Directory name mismatches (e.g., "calci" vs "calc") in commands cause file not found errors.
- **Platform differences**: JAR content extraction varies slightly by tool; stick to Oracle's jar command.

Resolution: Always test JAR creation steps sequentially, validate manifest syntax, and use tools like WinRAR for archives. Practice environment path setup to avoid recurring classpath issues.

## Appendix

### Mistakes and Corrections in Transcript
- "ript" → "script" (likely beginning of transcript cut off)
- "caly" → "calci" (module name consistency, pronounced similarly)
- "manifestor" → "manifest" (typo in command output description)
- "promt" → "prompt" (notepad reference)
- "Edition not found" → "setclass not found" or similar (context suggests classpath not set)
- "Class PA" → "classpath" (incomplete word)
- "run bat" → "run.bat" (missing extension in command)
- General: "htp" not present, but ensured HTTP references are correct if any (none here)

### References
- Jerox Material 2: Page 125 - Modifiers and Access Modifiers
- Volume 1 Textbook: Page 177-194 - JAR Files and Working with Packages
- Volume 1B Textbook: Page 272 - JAR File Operations

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
