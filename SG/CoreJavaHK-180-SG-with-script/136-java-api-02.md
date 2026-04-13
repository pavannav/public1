# Session 136: Java API 02

**Table of Contents**
- [API and Documentation Overview](#api-and-documentation-overview)
- [Creating a Reusable Class as API](#creating-a-reusable-class-as-api)
- [Compiling the API Class](#compiling-the-api-class)
- [Generating API Documentation](#generating-api-documentation)
- [Understanding API Documentation Content](#understanding-api-documentation-content)
- [Providing Descriptions with Javadoc Comments](#providing-descriptions-with-javadoc-comments)
- [Developer Responsibilities and Folder Structure](#developer-responsibilities-and-folder-structure)
- [Creating JAR Files for Distribution](#creating-jar-files-for-distribution)
- [User Programmer Responsibilities](#user-programmer-responsibilities)
- [Demonstrating API Usage in Command Line](#demonstrating-api-usage-in-command-line)
- [Working with Eclipse](#working-with-eclipse)
- [Summary](#summary)

## API and Documentation Overview

### Why Documentation is Needed
When developing classes for other programmers, simply providing the compiled `.class` file isn't sufficient. While `javap` can show method signatures and constructors, it lacks details on:
- What values to pass as parameters (e.g., only positive numbers or no restrictions).
- What the method returns and how to use it.
- The purpose of the class and methods.

### Introduction to API
- **API Definition**: Application Programming Interface - a set of predefined classes used for developing new applications.
- **Reusable Class Criteria**:
  - Packaged public class.
  - Contains parameterized methods that take inputs and return results (never print directly).
- **Comparison with Libraries**:
  - In C/C++, called a "library".
  - In Java, called an "API".
- **Purpose**: Provides functionality for application development without exposing implementation details.

### Generating API Documentation
- Use the `javadoc` command to create HTML files providing descriptions.
- Syntax: `javadoc [options] <Java file>`
- This generates organized HTML documentation better than plain `javap` output.

## Creating a Reusable Class as API

### Example Class Creation
1. Create a package structure: `com.nit.hk.api`
2. Define a public class `Addition` with:
   - A static method: `public static int add(int a, int b)`
   - An overloaded non-static method: `public double add(double d1, double d2)`

Sample code:
```java
package com.nit.hk.api;
/**
 * This class is used for performing addition operation.
 */
public class Addition {
    /**
     * This method is used for performing addition operation for two integers.
     * This method takes two integers, adds those integers, and returns the result.
     */
    public static int add(int a, int b) {
        return a + b;
    }
    /**
     * This method is used for performing addition operation for two double values.
     * This method takes two double numbers, adds those numbers, and returns the result.
     */
    public double add(double d1, double d2) {
        return d1 + d2;
    }
}
```

### Compilation Process
- Compile with `javac`: `javac -d bin src/com/nit/hk/api/Addition.java`
- This places the `.class` file in the `bin` directory under the package structure.

## Generating API Documentation

### Using Javadoc Command
- Run: `javadoc -d docs src/com/nit/hk/api/Addition.java`
- Output: Generates HTML files in the `docs` folder.
- Warnings indicate missing documentation comments; add them to eliminate.

### Providing Javadoc Comments
- Use `/** ... */` for documentation comments (not `//` or `/* */`).
- Place before class and method declarations.
- Include `@param` and `@return` tags for parameters and return values.
- Example for method:
```java
/**
 * This method is used for performing addition operation for two integers.
 * @param a first integer
 * @param b second integer
 * @return sum of the two integers
 */
public static int add(int a, int b) {
    return a + b;
}
```

Without proper comments, HTML files generate with warnings and no descriptions.

## Understanding API Documentation Content

### HTML Structure
- Opened via `index.html` in `docs` folder.
- Shows:
  - Class declaration (e.g., `public class Addition extends Object`).
  - Constructors and methods.
  - Inherited methods from `java.lang.Object`.
- Provides better organization than `javap` output.

### Content Analysis
- For the example class:
  - One constructor (default).
  - Two custom methods: `add(int, int)` and `add(double, double)`.
  - Inherited methods listed separately.

This helps other programmers understand usage without source code access.

## Providing Descriptions with Javadoc Comments

### Step-by-Step Addition
1. Add comment before class.
2. Add comments before each method with details.
3. Regenerate documentation: Rerun `javadoc`.
4. Verify: HTML now includes descriptions and addresses warnings partially.

### Annotations Usage
- Use `@param` for each parameter.
- Use `@return` if return type is void is not applicable.

Running `javadoc` multiple times refines the documentation.

## Developer Responsibilities and Folder Structure

### Full Workflow
1. **Development**: Create source in `src` folder.
2. **Compilation**: Use `javac -d bin src/...` to place `.class` in `bin`.
3. **Documentation Generation**: Use `javadoc -d docs src/...`.
4. **Separation**: `src` for sources, `bin` for classes, `docs` for HTML docs.

### Best Practices
- Maintain organized folders to avoid mixing sources and binaries.
- Ensure classes are reusable.

## Creating JAR Files for Distribution

### JAR for Class Files
- Command: `jar cvf arithmetic-operations.jar -C bin com`
- Includes the entire package structure.
- This is an API JAR (not executable), no `META-INF` needed.

### ZIP for Documentation
- Compress the `docs` folder into `arithmetic-operations-docs.zip`.
- Provides user-friendly access.

### Distribution
- Share both files (JAR and ZIP) with other programmers.
- JAR used by JVM/compiler; ZIP contains HTML for reference.

## User Programmer Responsibilities

### Step-by-Step Usage
1. **Download**: Get JAR and ZIP from server/repository.
2. **Set Classpath**: Add JAR to classpath (temporary: `set CLASSPATH=%CLASSPATH%;path/to/arithmetic-operations.jar` or permanent).
3. **Extract Documentation**: Unzip the docs and open `index.html`.
4. **Develop New Code**: Reference docs to understand methods.

### Sample User Code
```java
import com.nit.hk.api.Addition;

public class Calculator {
    public static void main(String[] args) {
        int result = Addition.add(5, 6);
        System.out.println(result);
    }
}
```
- Compile: `javac Calculator.java` (with classpath set).
- Execute: `java Calculator`.
- Output: Uses logic from JAR file via documentation guidance.

## Demonstrating API Usage in Command Line

### Walkthrough
1. Create `developer` folder with `src`, `bin`, `docs` subfolders.
2. Develop `Addition.java` in `src/com/nit/hk/api/`.
3. Compile: `javac -d bin -cp src src/com/nit/hk/api/Addition.java`.
4. Generate Docs: `javadoc -d docs src/com/nit/hk/api/Addition.java`.
5. Create JAR: `jar cvf arithmetic-operations.jar -C bin .`.
6. Create ZIP for docs.
7. Simulate user: Download files, set classpath, extract docs, write and run `Calculator.java`.

This demonstrates the complete cycle from development to usage.

## Working with Eclipse

### Integrating into IDE
1. Create a new class with main method or another method.
2. Import API class based on package from docs.
3. Instantiate objects or call static methods as per documentation.
4. Ensure classpath includes JAR for compilation.

### Best Practice Advice
- Practice manually first before using Eclipse to understand the underlying process.
- Manual workflow builds strong foundations.

## Summary

### Key Takeaways
```diff
+ API is a reusable Java class with packages, parameterized methods that return results.
+ Documentation is generated using `javadoc` to create HTML guides for other programmers.
+ Developers package classes into JARs and docs into ZIPs for distribution.
+ Users reference docs to import and use APIs, setting classpath for `.class` access.
+ Comments must use `/** */` (Javadoc comments) with tags like `@param` and `@return`.
- Avoid printing directly in API methods; always return values for reusability.
- Separate source, class, and doc folders using `-d` options.
! Compilation requires `-d bin` and `-cp src`; documentation uses `-d docs`.
```

### Expert Insight

#### Real-world Application
In enterprise development, APIs like addition utilities are part of larger frameworks (e.g., Apache Commons Math for numerical operations). Teams create JAR artifacts published to Maven Central; developers reference Javadoc in IDEs for tooltips and offline docs.

#### Expert Path
- Master Javadoc: Study advanced tags like `@since`, `@deprecated`, and custom `@author`.
- Explore Maven/Gradle for automated JAR and doc generation.
- Learn about API versioning for backward compatibility.

#### Common Pitfalls
- Forgetting Javadoc comments leads to incomplete docs; always add descriptions before class/method.
- Incorrect classpath setup causes `ClassNotFoundException`; verify JAR paths.
- Mixing source and binary files complicates builds; enforce folder separation.

- Lesser Known: Javadoc can integrate with IDEs for live previews; use `-private` for internal docs.

> **Mistakes and Corrections Notified**: In the transcript, "htundy" is likely "hyundy" (typo for "hyfundy" or similar package reference), but contextually it's "hyfundy" - corrected to "hyfundy" assuming package name. "fany" might be "fany" (possibly "fandy"), but treated as "fany". "hyph" corrected to "hyphen". No major technical errors like "htp" for "http" or "cubectl" for "kubectl" noted. Potential misspell: "arithmetic operation classes. Java" should be "arithmetic-operations.jar". "Ao classes" assumed "arithmetic-operations". General transcript had minor stutter repetitions corrected for clarity.
