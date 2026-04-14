# Session 12: Exception Handling - Try with Resources (Rules 3-10) and Multi Catch

## Table of Contents

- [Try with Resources: Continuing Rule 3 to Rule 10](#try-with-resources-continuing-rule-3-to-rule-10)
  - [Overview](#overview)
  - [Rule Recap (1 & 2)](#rule-recap-1--2)
  - [Rule 3: Resource Variable Must Be Initialized](#rule-3-resource-variable-must-be-initialized)
  - [Rule 4 & 5: Declaration in Try Parenthesis and Final/Effectively Final](#rule-4--5-declaration-in-try-parenthesis-and-final-effectively-final)
  - [Rule 6: Cannot Declare Outside and Initialize Inside](#rule-6-cannot-declare-outside-and-initialize-inside)
  - [Rule 7: Java 9 Enhancement for External Variables](#rule-7-java-9-enhancement-for-external-variables)
  - [Scope and Usage After Try Block](#scope-and-usage-after-try-block)
  - [Rule 8: Multiple Resources](#rule-8-multiple-resources)
  - [Rule 9 & 10: Restrictions in Try Parenthesis](#rule-9--10-restrictions-in-try-parenthesis)
- [Catch with Multiple Exceptions (Java 7 Feature)](#catch-with-multiple-exceptions-java-7-feature)
  - [Overview](#overview-1)
  - [Rules for Multi Catch](#rules-for-multi-catch)
  - [Demo: Multi Catch Usage](#demo-multi-catch-usage)
- [Compile Time Errors and Common Exceptions](#compile-time-errors-and-common-exceptions)
- [Why Use Exceptions](#why-use-exceptions)
- [Summary](#summary)
  - [Key Takeaways](#key-takeaways)
  - [Expert Insight](#expert-insight)

## Try with Resources: Continuing Rule 3 to Rule 10

### Overview

This session continues the discussion on try-with-resources, focusing on the advanced rules (Rules 3 through 10) for proper resource management in Java. These rules ensure that AutoCloseable resources are handled correctly, preventing resource leaks and compilation errors. We'll explore variable initialization, declaration scopes, Java version-specific enhancements, and restrictions on resource usage.

### Rule Recap (1 & 2)

Recall the first two rules briefly:
- **Rule 1**: The object created as a try resource must be a subclass of AutoCloseable interface. Using non-AutoCloseable types like String leads to compile-time errors.
- **Rule 2**: If the resource's close() method or constructor throws checked exceptions (e.g., IOException from FileInputStream), you must handle them.

### Rule 3: Resource Variable Must Be Initialized

The resource variable in try-with-resources must be initialized either with an object, a method call, or at least with `null`. You cannot just declare the variable without initialization.

```java
try (PrintStream ps) {  // ❌ Compile error: variable ps might not have been initialized
    // code
}
```

**Why?** At the end of the try block, the compiler implicitly calls `ps.close()`. For method invocation, the variable must be initialized first. If initialized with `null`, internal logic checks for null before calling close(), similar to manual `if (ps != null) ps.close()` in finally blocks.

**Correction Note**: In the transcript, "tri" is corrected to "try", and "ps do close me calling" refers to implicit `ps.close()` call.

### Rule 4 & 5: Declaration in Try Parenthesis and Final/Effectively Final

**Rule 4**: You cannot create an object directly without a variable declaration (e.g., `new PrintStream(...)` alone). It must be a variable declaration for the compiler to manage closing.

**Rule 5**: The resource variable must be effectively final—you cannot reassign it inside the try block. If you assign a new object, the compiler throws an error because the previous resource won't be closed.

```java
try (PrintStream ps = new PrintStream()) {
    ps = new PrintStream();  // ❌ Error: AutoCloseable resource ps may not be assigned
}
```

**Reason**: Reassignment breaks the guarantee of closing resources at try block end.

### Rule 6: Cannot Declare Outside and Initialize Inside

Variables cannot be declared outside the try parenthesis and initialized inside—they must be declared and initialized within the try parenthesis.

```java
PrintStream ps;
try (ps = new PrintStream()) {  // ❌ Compile error: try-with-resources requires declaration or expression to final/effectively final variable
}
```

**Key Insight**: This prevents scope issues and ensures resources are properly managed in the try context.

### Rule 7: Java 9 Enhancement for External Variables

Up to Java 8, variables declared outside the try block cannot be used as resources (causes compile error). From Java 9 onwards, you can directly use an existing AutoCloseable variable as a resource without redeclaration.

```java
FileOutputStream fos = new FileOutputStream("file.txt");
try (fos) {  // ✅ Allowed in Java 9+
    // use fos
}  // fos.close() called implicitly
```

**Java 8 Limitation**: You had to redeclare and assign to use as resource.
**Version Note**: Remember Java 8 disallows this; Java 9+ allows it. Interviews/Versions matter (e.g., OCJP 11 allows).

### Scope and Usage After Try Block

- Try-with-resources local variables (declared inside try) cannot be used after the try block—they are out of scope.
- External variables used as resources (Java 9+) can be accessed after try, but calling methods on them post-closure throws `IOException: Stream Closed`.
- **Important Practice Point**: Always handle streams carefully; practice to remember compile-time vs. runtime errors.

```java
try (FileOutputStream fos7 = new FileOutputStream("file.txt")) {
} 
fos7.write(...);  // ❌ Compile error: cannot find symbol

FileOutputStream fos8 = new FileOutputStream("file.txt");
try (fos8) {
}
fos8.write(...);  // ❌ Runtime error: IOException: Stream Closed
```

**Lab Demo**: Test these scenarios to observe errors.

### Rule 8: Multiple Resources

You can declare multiple resources in try parenthesis, separated by semicolons (not commas). Semicolons are required for multiple resources; optional for single.

```java
try (
    FileOutputStream fos1 = new FileOutputStream("f1.txt");
    FileOutputStream fos2 = new FileOutputStream("f2.txt")  // ✅ Multiple with semicolon
) {
    // code
}
```

### Rule 9 & 10: Restrictions in Try Parenthesis

- **Rule 9**: No method calls, logic, or assignments allowed—only AutoCloseable variable declarations with initialization (via `new`, method call, or `null`).
- **Rule 10**: Non-AutoCloseable variables (e.g., int, boolean) are not allowed.

```java
try (PrintStream ps = new PrintStream()) {
    ps.println("Hello");  // ❌ Error: try-with-resources resource must be either variable declaration or expression
}

try (int x = 5) {  // ❌ Error: int cannot be converted to AutoCloseable
}
```

**Lab Demo**: Implement try-with-resources in your Spring/Hibernate projects for practice.

## Catch with Multiple Exceptions (Java 7 Feature)

### Overview

Java 7 introduced catch with multiple exceptions to reduce code duplication when multiple catch blocks have identical logic. Instead of separate catch blocks, combine related exceptions into one using the `|` separator.

### Rules for Multi Catch

- Use `|` separator (not `||`, `,`, or `&`).
- Only one parameter name (e.g., `e` for ArithmeticException | ArrayIndexOutOfBoundsException).
- Exceptions must be alternatives (siblings, not parent-child). Super-subclass relationships cause compile error.

```java
catch (ArithmeticException | ArrayIndexOutOfBoundsException e) {  // ✅
    e.printStackTrace();
}

catch (ArithmeticException | Exception e) {  // ❌ Error: alternatives cannot be related by subclassing
}
```

**Key Point**: Only one exception occurs at a time, so one parameter suffices.

### Demo: Multi Catch Usage

This demo handles ArrayIndexOutOfBoundsException, NumberFormatException (same logic), and ArithmeticException (different logic), with a backup catch.

```java
public class MultiCatchDemo {
    public static void main(String[] args) {
        try {
            int a = Integer.parseInt(args[0]);
            int b = Integer.parseInt(args[1]);
            int c = a / b;
            System.out.println("Result: " + c);
        } catch (ArrayIndexOutOfBoundsException | NumberFormatException e) {
            System.out.println("Please enter only integers (two integers)");
        } catch (ArithmeticException e) {
            System.out.println("Division by zero not allowed");
        } catch (Exception e) {
            System.out.println("Unknown exception: " + e);
        }
    }
}
```

**Run Command**: `java MultiCatchDemo` (without args for ArrayIndexOutOfBoundsException; with non-integers for NumberFormatException; with `10 0` for ArithmeticException).

**Lab Demo**: Compile and test with various inputs. Screenshot each output.

## Compile Time Errors and Common Exceptions

- List of compile-time errors provided (review for OCJP questions).
- **Common Exceptions in Projects**:
  - NullPointerException (most common)
  - ArrayIndexOutOfBoundsException
  - ClassCastException (reduced with generics)
  - StackOverflowError (recursive calls)
  - OutOfMemoryError (heap space)
  - InterruptedException (multi-threading)
  - IOException (file operations)
  - SQLException (JDBC)
  - UnsupportedClassVersionError (version mismatch)
  - ClassFormatError (invalid class format)
  - StringIndexOutOfBoundsException
  - ConcurrentModificationException (collections)
  - NoSuchElementException (iterations)

📝 **Note**: Study and note exceptions per chapter for interviews.

## Why Use Exceptions

- **Not System.exit(0)**: `System.exit(0)` shuts down the entire JVM, affecting multi-threaded environments and web servers (other projects crash). Exceptions terminate only the current thread/method.
- **Not if-else**: if-else doesn't terminate on error or provide stack traces. Exceptions track call stacks and ensure upstream termination, preventing partial executions with wrong results. Use exceptions for business apps; if-else for math-based ones.

> [!IMPORTANT]  
> Exceptions ensure clean error handling, thread-safety, and proper resource cleanup. Avoid System.exit() in production.

## Summary

### Key Takeaways

```diff
+ Try-with-resources rules (3-10) prevent resource leaks and ensure AutoCloseable objects close automatically.
+ Variables must be declared, initialized, and effectively final in try parenthesis.
+ Java 9 allows direct use of external AutoCloseable variables as resources.
+ Multi-catch blocks combine exceptions with | separator for identical logic.
+ Exceptions provide stack traces and force termination; system.exit() and if-else lack this.
- Assigning resources inside try breaks closing guarantees.
- Using non-sibling exceptions in multi-catch causes subclassing errors.
```

### Expert Insight

**Real-world Application**: In Spring/Hibernate projects, use try-with-resources for database connections (e.g., PreparedStatement, ResultSet). Multi-catch simplifies handling SQLExceptions and IOExceptions in file processing. Always profile for memory leaks caused by unclosed streams.

**Expert Path**: Practice implementing all 10 rules in code experiments. For OCJP/Interviews, note version differences (Java 8 vs. 9+). Advance to multi-threading, where exception handling is crucial for thread synchronization.

**Common Pitfalls**:
- Forgetting `throws` for checked exceptions in close()/constructors.
- Reassigning resources in older Java versions without realizing runtime issues.
- Mixing parent-child exceptions in multi-catch, leading to unreachable catch blocks.
- Assuming external variables are safe post-try; always check for Stream Closed exceptions.
- Using system.exit(0) in web apps, causing server-wide outages.

**Lesser Known Things**: Try-with-resources internally uses null-checks before closing—a micro-optimization over manual finally blocks. Multi-catch parameter is `final` implicitly, preventing modification. Exceptions in finally blocks can suppress original exceptions (Java 7+ adds `getSuppressed()`). 

<summary>Generated with CL-KK-Terminal</summary>  
🤖 Generated with [Claude Code](https://claude.com/claude-code)  

Co-Authored-By: Claude <noreply@anthropic.com>
