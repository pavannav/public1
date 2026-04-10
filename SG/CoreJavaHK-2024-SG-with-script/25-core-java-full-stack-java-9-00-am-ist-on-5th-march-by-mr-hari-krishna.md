# Session 25: Core Java Full Stack Java 9 00 AM IST on 5th March by Mr Hari Krishna

## Table of Contents
- [Previous Assignment Review](#previous-assignment-review)
- [Coding Standards and Best Practices](#coding-standards-and-best-practices)
- [Primitive Data Types in Projects](#primitive-data-types-in-projects)
- [Introduction to Reading Runtime Values](#introduction-to-reading-runtime-values)
- [Command Line Arguments](#command-line-arguments)
- [Wrapper Classes and Parsing](#wrapper-classes-and-parsing)

## Previous Assignment Review

### Overview
The session begins with a review of the previous day's assignment where trainees were tasked with creating a real-world bank account object. The instructor emphasizes that program names should follow common sense and naming conventions, using nouns for classes (e.g., "BankAccount" instead of arbitrary names like "account" or "bank").

### Key Concepts
- Class naming should use PascalCase (title case, no spaces, noun-based).
- Variable naming should use camelCase (first word lowercase, subsequent word capitals).
- Avoid using arbitrary names; apply common sense based on requirements.

### Lab Demos
- **Incorrect Examples**: Classes named as plain "account" or "bank", violating naming conventions.
- **Corrections**:
  - Class: `BankAccount`
  - Variables: `bankName`, `branchName`, `accountNumber`, `accountHolderName`, `balance`
  - Data Types: `String bankName`, `String branchName`, `long accountNumber`, `String accountHolderName`, `double balance`

### Common Mistakes
- Using lowercase or inconsistent casing for class and variable names.
- Choosing names like "acc" instead of "accountNumber".
- Not following title case for variables (e.g., `bankName` not `bankname`).

## Coding Standards and Best Practices

### Overview
The instructor stresses the importance of following Java coding standards to be recognized as a professional developer. Poor standards lead to rejection in job interviews.

### Key Concepts
- Variables: CamelCase, starting with lowercase.
- Classes: PascalCase, starting with uppercase.
- Use nouns for class names, verbs for methods.
- Avoid spaces in identifiers.
- Prefix pricing for currencies (not discussed).
- Most primitive data types used: `int`, `long`, `double`, `boolean`, and `char`.
- Prefer `double` over `float`.
- Seven data types commonly used: primitives + `String` + wrapper classes/user-defined classes.

### Expert Insight
- **Real-world Application**: In professional teams, consistent naming and data types ensure maintainability in large codebases.
- **Expert Path**: Study enterprise coding guidelines (e.g., Google Java Style Guide) to master conventions.
- **Common Pitfalls**: Ignoring standards leads to code that looks unprofessional and harder to debug.
- Innocent details: Many trainees use all lowercase, which is a beginner habit.

## Primitive Data Types in Projects

### Overview
Projects typically use a limited set of primitive data types for numeric operations, booleans for flags, and references for objects/strings.

### Key Concepts
- Core primitives: `int` (`long` for 12-digit numbers), `double`, `boolean`.
- Maximum usage: `int`, `long`, `double`, `boolean` (7 total with references).
- Use `String` for alpha-numeric/alphabet-only data.

| Data Type | Usage Example |
|-----------|----------------|
| `int`     | Counters, integers |
| `long`    | Large numbers (e.g., account numbers) with 'L' suffix |
| `double`  | Balances, decimals (prefer over `float`) |
| `boolean` | Flags, yes/no logic |
| `String`  | Names, alphanumeric data |

### Expert Insight
- **Real-world Application**: In banking apps, `long` for account numbers prevents overflow.
- **Expert Path**: Learn type inference and auto-boxing for advanced usage.
- **Common Pitfalls**: Using `float` for money calculations causes precision errors.
- Lesser known: `char` for single characters, rarely used in full app logic.

## Introduction to Reading Runtime Values

### Overview
Chapter 6 introduces reading runtime values, contrasting hardcoded (static) programs with dynamic ones that read user input at execution time. Hardcoded programs (e.g., ATM that only works for one account) are unsuitable for real-world applications.

### Key Concepts
- **Hardcoded Application**: Values typed directly in code, cannot change at runtime (static/tumor programs).
- **Runtime Values Application**: Values read from user input, allowing variability (e.g., ATM reading different accounts).
- Problems with hardcoded: Code changes required, only works for specific values.
- Advantages of runtime: Dynamic, user-driven execution.
- Applications like ATM, Amazon require runtime input.

### Code/Config Blocks
```java
// Hardcoded example (static)
class Addition {
    public static void main(String[] args) {
        int a = 10;
        int b = 20;
        int c = a + b;
        System.out.println("Result: " + c);  // Always 30
    }
}
```

### Lab Demos
- Static program: Only adds 10 and 20.
- Runtime expectation: Ask for user input and compute dynamically.

### Common Pitfalls
- Developing static programs without understanding user requirements.
- Assuming fixed values in logic without run-in reading.

## Command Line Arguments

### Overview
Command line arguments allow reading runtime values from the console when running the program. JVM passes these as a `String` array to `main(String[] args)`.

### Key Concepts
- **Command Line**: The Windows command prompt line where commands are executed (e.g., `java Addition 10 20`).
- **Command Line Arguments**: Input values passed after the class name (e.g., `10 20`).
- **Application**: Program that reads runtime values from command line.
- JVM creates `String[]` array, passes it to `main` (e.g., `args[0] = "10"`, `args[1] = "20"`).

### Code/Config Blocks
```java
// Command line execution
java Addition 10 20
```

```java
// Reading args in main
class Addition {
    public static void main(String[] args) {
        // args[0] = "10", args[1] = "20"
        int a = Integer.parseInt(args[0]);  // Convert string to int
        int b = Integer.parseInt(args[1]);
        int c = a + b;
        System.out.println("Result: " + c);
    }
}
```

### Lab Demos
- Compile: `javac Addition.java`
- Run: `java Addition 10 20` → Output: `Result: 30`
- Change to `java Addition 30 70` → Output: `Result: 100`

> [!IMPORTANT]
> Command line arguments come as strings; direct assignment to primitives causes compile errors.

> [!NOTE]
> All keyboard input starts as strings internally (OS converts).

## Wrapper Classes and Parsing

### Overview
Wrapper classes provide static `parseXXX` methods to convert string inputs to primitive types. All wrappers except `Character` have these methods.

### Key Concepts
- **Wrapper Classes**: Classes like `Integer`, `Long`, `Double` to handle primitives as objects and perform conversions.
- Parsing methods: `Integer.parseInt(string)` → `int`, `Double.parseDouble(string)` → `double`, etc.
- Exceptions: `NumberFormatException` for invalid values (e.g., `Integer.parseInt("abc")`).

### Tables

| Wrapper Class | Parse Method              | Returns | Example |
|---------------|---------------------------|---------|---------|
| Integer      | `parseInt(String s)`     | int     | `10`    |
| Long         | `parseLong(String s)`     | long    | `20L`   |
| Double       | `parseDouble(String s)`   | double  | `10.5`  |
| Float        | `parseFloat(String s)`    | float   | `5.5f`  |
| Boolean      | `parseBoolean(String s)`  | boolean | `true`  |
| Byte         | `parseByte(String s)`     | byte    | `5`     |
| Short        | `parseShort(String s)`    | short   | `10`    |
| Character    | N/A                       | N/A     | N/A     |

### Code/Config Blocks
```java
// Corrected program with parsing
class Addition {
    public static void main(String[] args) {
        int a = Integer.parseInt(args[0]);
        int b = Integer.parseInt(args[1]);
        int c = a + b;
        System.out.println("Result: " + c);
    }
}

/*
Compile errors without parsing:
int a = args[0];  // String cannot be converted to int
*/
```

> [!WARNING]
> Direct assignment of `args[0]` to `int` causes compile-time error: incompatible types.

## Summary

### Key Takeaways

```diff
+ Runtime programs read dynamic user input via command line or other methods.
+ Command line arguments pass as String[] to main method.
+ Wrapper classes enable parsing strings to primitives using parseXXX methods.
- Hardcoded programs are static and unsuitable for real-world applications.
! Always follow naming conventions to avoid rejection in interviews.
```

### Expert Insight
**Real-world Application**: In CLI tools like Maven (`mvn compile`), arguments customize builds dynamically.  
**Expert Path**: Explore advanced input methods like Scanner for interactive apps; master exception handling for invalid inputs.  
**Common Pitfalls**: Forgetting parsing leads to runtime errors; using wrong data types (e.g., int for decimal balances).  
**Common Issues**: Overflow with wrong types; resolution: Use `long` for large numbers, validate inputs.  
**Lesser Known**: All CLI inputs are strings by OS design, requiring conversion in nearly all languages.
