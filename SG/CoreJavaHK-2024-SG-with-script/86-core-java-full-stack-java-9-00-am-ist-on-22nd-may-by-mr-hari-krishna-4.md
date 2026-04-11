# Session 4: Java 7 New Features in Exception Handling

## Table of Contents
- [Exception Handling Review](#exception-handling-review)
- [Language Fundamentals](#language-fundamentals)
- [Building Logic Steps](#building-logic-steps)
- [Java 7 New Features: Try with Resources](#java-7-new-features-try-with-resources)
- [Resource Management Demonstration](#resource-management-demonstration)
- [Multi-Catch Exception Handling](#multi-catch-exception-handling)
- [Exception Handling Rules and Templates](#exception-handling-rules-and-templates)

## Exception Handling Review

### Overview
💡 This section reviews the fundamentals of exception handling in Java, focusing on the `try-catch-finally` blocks, `throws` keyword, and how to handle checked and unchecked exceptions. The instructor emphasizes understanding when to use `try-catch` for stopping abnormal termination and `throws` for propagating exceptions to calling methods.

### Key Concepts/Deep Dive
Exception handling in Java involves three main keywords: `try`, `catch`, and `finally`, along with the `throws` keyword for declaration.

- **When to use try-catch**: Use `try-catch` blocks to catch and handle exceptions locally, preventing abnormal program termination. This wraps risky code that might throw exceptions.

- **When to throw exceptions**: Throw exceptions manually using the `throw` keyword when input values are invalid or logical errors are detected. This is often checked within `if` conditions after reading values from input sources like keyboard or files.

- **Throws keyword**: Used in method signatures to declare that a method can throw specific exceptions. It shifts exception handling responsibility to the calling method. For checked exceptions, `throws` is mandatory; for unchecked exceptions, it's optional.

- **Control flow during exceptions**: When an exception is thrown, method execution terminates abnormally, and control returns to the calling method. If the calling method doesn't handle it with `try-catch`, the program will terminate.

- **Finally block**: Executes regardless of whether an exception occurs, commonly used for resource cleanup. Code in `finally` ensures connections (like files or databases) are closed.

- **Program template structure**: A standard exception handling program includes classes for business logic and main execution. The business logic class uses parameters, validation with `if`, exception throwing, and declares exceptions with `throws`. The main class calls this method inside a `try-catch-finally` block.

> [!NOTE]
> For beginners, always pair exception throwing with proper catching or declaration using `throws` to avoid compile-time errors.

### Code/Config Blocks
```java
// Example program template for exception handling
public class BusinessLogic {
    public static void add(int a, int b) throws NegativeNumberException {  // Custom exception
        if (a < 0 || b < 0) {
            throw new IllegalArgumentException("Numbers cannot be negative");
        }
        System.out.println("Result: " + (a + b));
    }
}

public class MainClass {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        try {
            System.out.println("Enter two numbers:");
            int a = sc.nextInt();
            int b = sc.nextInt();
            BusinessLogic.add(a, b);
        } catch (IllegalArgumentException e) {
            System.out.println("Error: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            sc.close();
            System.out.println("Scanner closed.");
        }
    }
}
```

### Tables
| Exception Type | Description | Handling Required |
|----------------|-------------|-------------------|
| Checked Exception | Occurs when code deals with external resources (e.g., `IOException`) | Must be handled with `try-catch` or declared with `throws` |
| Unchecked Exception | Runtime exceptions (e.g., `IllegalArgumentException`) | Optional handling, but recommended for robustness |

## Language Fundamentals

### Overview
📝 Language fundamentals are the core building blocks of Java programs: data types, operators, control flow statements, and exception handling statements. These concepts work together to create logic for reading inputs, validating data, performing operations, and handling errors.

### Key Concepts/Deep Dive
Java's language fundamentals include four key pillars that form the foundation for writing robust programs:

- **Data Types**: Used for declaring variables that store values, method return types, parameters, and local variables. Primitive types (int, double) and reference types (classes like Scanner) are essential for temporary data storage.

- **Operators**: Perform validations, calculations, and assignments. Examples include arithmetic operators for computations and comparison operators for condition checking.

- **Control Flow Statements**: Direct program execution flow using `if-else`, `switch`, loops, etc. These statements control when certain code blocks execute based on conditions.

- **Exception Handling Statements**: Manage error scenarios using `try-catch`, `throw`, and `throws`. These ensure programs can recover from or gracefully handle unexpected situations.

> [!TIP]
> These fundamentals are interconnected: data types store values read via operators, control flow decides execution paths, and exceptions handle failures in these processes.

### Code/Config Blocks
```java
// Example illustrating language fundamentals
public class Sample {
    public static void main(String[] args) {
        // Data types for storage
        int result = 0;  // Variable for result
        
        // Operator for calculation (implies validation logic elsewhere)
        result = 5 + 10;  // Arithmetic operation
        
        // Control flow
        if (result > 0) {
            System.out.println("Positive result: " + result);
        } else {
            throw new RuntimeException("Negative result");  // Exception handling
        }
    }
}
```

## Building Logic Steps

### Overview
⚠ Building logic in Java follows a systematic four-step process: read inputs, validate them, perform calculations, and handle errors. This ensures programs are reliable and can respond to invalid inputs by throwing exceptions.

### Key Concepts/Deep Dive
The standardized approach to building logic includes:

1. **Read Values from Input Sources**: Values come from keyboard (using Scanner), command-line arguments, or external sources. Store them in variables for processing.

2. **Validate Values**: Check if inputs are correct using conditional statements (`if`). Invalid values trigger exceptions to prevent further processing.

3. **Perform Calculations/Logic**: If validation passes, execute the core business logic to generate results.

4. **Throw Exceptions for Invalid Data**: For wrong inputs, throw exceptions with error messages. Use `throws` to declare potential exceptions in method signatures.

This four-step process integrates with the language fundamentals, using data types for storage, operators for checks, control flow for decisions, and exception handling for errors.

- **Example Scenario**: Reconstruct a program to add two numbers. Read inputs, validate for negativity, perform addition if valid, or throw exception with error message if invalid.

> [!IMPORTANT]
> Skipping any step leads to incomplete programs. Always validate inputs before processing to ensure data integrity.

### Code/Config Blocks
```java
// Complete example of building logic with exception handling
import java.util.Scanner;

public class Adder {
    public static void add(int a, int b) throws IllegalArgumentException {
        if (a < 0 || b < 0) {
            throw new IllegalArgumentException("Negative numbers not allowed");
        }
        System.out.println("Sum: " + (a + b));
    }
    
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        try {
            System.out.println("Enter a and b:");
            int a = sc.nextInt();
            int b = sc.nextInt();
            add(a, b);
        } catch (IllegalArgumentException e) {
            System.out.println("Error: " + e.getMessage());
        } finally {
            sc.close();
        }
    }
}
```

## Java 7 New Features: Try with Resources

### Overview
📝 Java 7 introduced "try with resources" to automatically manage resource cleanup, eliminating the need for manual `finally` blocks. This feature targets resource-based objects (like file connections) that implement the `AutoCloseable` interface, ensuring connections close safely even if exceptions occur.

### Key Concepts/Deep Dive
Try with resources simplifies exception handling for resources, reducing boilerplate code and preventing resource leaks.

- **Resource Objects**: Objects with connections to external sources (files, databases, networks). These must implement `AutoCloseable` for automatic closing.

- **Syntax**: Declare resources in parentheses after `try`: `try (ResourceType var = new ResourceType(...)) { ... }`. Multiple resources can be separated by semicolons.

- **Automatic Closing**: Compiler automatically generates a `finally` block with `close()` calls. Null checks are handled internally.

- **Old vs. New Approach**: Previously, variables were declared outside, initialized inside `try`, and closed manually in `finally` with null checks. Now, declare and initialize in `try()` for automatic management.

- **Java Version Progressions**:
  - Java 6: Manual `finally` with null checks.
  - Java 7: `try()` syntax for automatic closing.
  - Java 9+: Can reference existing variables in `try()` for resources declared outside.

- **Benefits**: Reduces errors from forgotten `close()` calls, improves code readability, handles exceptions during closing.

> [!NOTE]
> Only `AutoCloseable` objects (like `FileWriter`) qualify as resources. Regular objects cannot be used in this syntax.

### Code/Config Blocks
```java
// Java 6 style (manual resource management)
FileWriter fw = null;
try {
    fw = new FileWriter("abc.txt");
    fw.write("Hello");
    fw.flush();
} catch (IOException e) {
    e.printStackTrace();
} finally {
    if (fw != null) {
        try {
            fw.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

// Java 7+ style (try with resources)
try (FileWriter fw = new FileWriter("abc.txt")) {
    fw.write("Hello");
} catch (IOException e) {
    e.printStackTrace();
}  // fw.close() called automatically
```

### Lab Demos
1. Create a file named "demo.txt" and write text using `PrintStream` with try with resources.
   
   ```java
   try (PrintStream ps = new PrintStream("demo.txt")) {
       ps.println("Demo text");
   }  // Connection closed automatically
   ```

   Expected result: Content written to demo.txt without manual closing. If you use `System.out.print` after, it may not work if `ps.close()` is implied.

2. Demonstrate multi-resource handling in a JDBC-like scenario (conceptual).

   ```java
   try (
       Connection conn = DriverManager.getConnection(url);
       Statement stmt = conn.createStatement();
       ResultSet rs = stmt.executeQuery(sql)
   ) {
       while (rs.next()) {
           System.out.println(rs.getString(1));
       }
   }  // All closed automatically in reverse order
   ```
   
   Step-by-step: Declare resources in try(), execute SQL inside block, and observe automatic cleanup.

### Tables
| Version | Resource Management Approach | Key Syntax |
|---------|------------------------------|------------|
| Java 6 | Manual try-catch-finally with null checks | `finally { if (res != null) res.close(); }` |
| Java 7+ | Automatic via try with resources | `try (ResourceType res = new ResourceType()) { ... }` |

## Multi-Catch Exception Handling

### Overview
💡 Java 7's multi-catch feature allows a single `catch` block to handle multiple exception types, reducing code duplication when different exceptions require the same handling logic.

### Key Concepts/Deep Dive
Multi-catch catches multiple unrelated exceptions in one block, treating them as alternatives rather than simultaneous occurrences.

- **Syntax**: `catch (ExceptionType1 | ExceptionType2 e) { ... }`. Use the OR operator to separate exception types.

- **Rules**:
  - Only one parameter variable (e.g., `e`).
  - Exceptions must be at the same hierarchy level; no parent-child relationships allowed (e.g., `Exception` and `IOException` are invalid together).
  - Separated by pipe (`|`), not comma.

- **Usage**: Ideal when multiple exceptions trigger identical error handling, eliminating repetitive `catch` blocks.

- **Limitation**: If exception-specific logic is needed, use separate `catch` blocks.

### Code/Config Blocks
```java
// Multi-catch example
try {
    // Code that might throw ArrayIndexOutOfBoundsException or NumberFormatException
} catch (ArrayIndexOutOfBoundsException | NumberFormatException e) {
    System.out.println("Invalid operation: " + e.getMessage());
}  // Single block handles both exceptions

// Invalid (parent-child relationship)
catch (Exception | IOException e) { }  // Compiler error
```

## Exception Handling Rules and Templates

### Overview
📝 This section consolidates the 10 rules for effective exception handling, focusing on rules for multi-catch, resource management, and program templates.

### Key Concepts/Deep Dive
The instructor provides 10 rules for mastering exception handling:

1. **Rule 1**: Declare variables outside `try` if accessing in other blocks, but initialize inside to avoid compiler errors.

2. **Rule 2**: Use null checks in `finally` to prevent `NullPointerException` during closing.

3. **Rule 3**: For multiple resources, nest `try-catch` for each `close()` to ensure all connections close even if one fails.

4. **Rule 4**: In multi-catch, ensure exception types are siblings, not superclasses/subclasses.

5. **Rule 5**: Separate exceptions in multi-catch with `|`, not `,`.

6. **Rule 6**: Multi-catch allows only one parameter variable.

7. **Rule 7**: Try with resources eliminates manual `finally` for `AutoCloseable` objects.

8. **Rule 8**: Ensure backward compatibility when mixing Java versions in resource handling.

9. **Rule 9**: Prefer try with resources for new code to avoid leaks.

10. **Rule 10**: Practice program templates for consistent error handling across projects.

### Code/Config Blocks
```java
// Program template for exception handling
public class Template {
    // Business logic method
    public static void processData(int value) throws IllegalArgumentException {
        if (value < 0) throw new IllegalArgumentException("Invalid value");
        // Processing logic
    }
    
    public static void main(String[] args) {
        try {
            // Read input
            int v = Integer.parseInt(args[0]);
            processData(v);
        } catch (IllegalArgumentException | NumberFormatException e) {  // Multi-catch
            System.out.println("Error: " + e.getMessage());
        }
    }
}
```

## Summary

### Key Takeaways
```diff
+ Exception handling basics (try-catch-throws) prevent abnormal termination and handle errors gracefully.
+ Language fundamentals integrate data types, operators, control flow, and exceptions for robust logic building.
+ Four-step logic process: read, validate, calculate, throw/handle exceptions ensures quality programs.
+ Java 7's try with resources automates resource cleanup for AutoCloseable objects, reducing boilerplate code.
+ Multi-catch handles multiple sibling exceptions in one block, eliminating redundancy.
+ Always follow the program template: business logic with throws, main with try-catch-finally.
- Avoid manual finally blocks for resources; use try with resources to prevent leaks.
+ Practice the 10 rules diligently for advanced exception handling mastery.
! Resource objects must implement AutoCloseable for try with resources compatibility.
```

### Expert Insight

#### Real-world Application
In enterprise applications like web servers or database systems, try with resources is crucial for managing connections (e.g., JDBC connections, file streams). For instance, in a banking app, multi-catch can consolidate error handling for various validation failures, ensuring consistent user feedback while logging specific errors for monitoring. Proper exception chaining helps trace root causes in production logs, critical for debugging distributed systems.

#### Expert Path
- Start with mastering the 4-step logic process by implementing small validation programs. Gradually incorporate Java 7 features in all I/O operations.
- Explore advanced patterns like exception chaining (`initCause`) and custom exceptions extending `RuntimeException` for unchecked scenarios.
- Benchmark resource leakage by comparing old vs. new handling; use tools like VisualVM to monitor memory in resource-heavy apps.
- Study Java 8+ lambdas with try with resources, and integrate with frameworks like Spring for automatic rollback on exceptions.

#### Common Pitfalls
- **Forgetting null checks**: Omitting `!= null` in manual closing leads to `NullPointerException` during failures, potentially masking original errors.
- **Improper resource nesting**: Not using nested try-catch for multiple closes causes partial cleanup; always separate close operations.
- **Multi-catch with inheritance**: Mixing super/subclasses causes compile errors; verify hierarchy with Eclipse/IntelliJ tools.
- **Assuming try with resources handles all cases**: It only works for AutoCloseable; for non-compliant objects (e.g., custom resources), implement the interface or use manual finally.
- **Version incompatibility**: Using Java 9+ syntax in pre-Java 9 projects fails compilation; check `javac -version` and specify source/target flags if needed.

**Common issues with resolution and how to avoid them**:
- **Compile-time "Unhandled Exception"**: Always declare checked exceptions with `throws` or wrap in try-catch.
- **Resource leaks in loops**: Ensure try with resources scopes correctly; avoid declaring resources at method level.
- **Multi-catch inefficiency**: Use only when handling logic is identical; separate blocks for unique behaviors to avoid generic error messages.

**Lesser known things about this topic**:
- Finalizers (`finalize()` method) were deprecated in favor of try with resources; they're non-deterministic and slow.
- Exception suppression: When multiple exceptions occur during auto-closing, only the main exception is propagated, but suppressed ones are accessible via `getSuppressed()`.
- Performance impact: Auto-closing adds minimal overhead but saves significant debugging time compared to manual management.
