# Session 82: Exception Handling

## Table of Contents
- [Overview](#overview)
- [Real-Time Example of Exception Issues](#real-time-example-of-exception-issues)
- [What is an Exception?](#what-is-an-exception)
- [Need for Exception Handling](#need-for-exception-handling)
- [Exception Handling Process](#exception-handling-process)
- [Try-Catch Syntax and Execution Flow](#try-catch-syntax-and-execution-flow)
- [Practical Example Program](#practical-example-program)
- [Real-World Application: User Input Handling](#real-world-application-user-input-handling)
- [Multiple Catch Blocks](#multiple-catch-blocks)
- [Order of Catch Blocks](#order-of-catch-blocks)
- [Single Catch Block for All Exceptions](#single-catch-block-for-all-exceptions)

## Overview
Exception handling is a crucial chapter where we learn to manage runtime errors, also termed exceptions, to ensure programs run smoothly without abnormal termination. Unlike other Java topics, this focuses on handling errors from user inputs or logical mistakes, not on creating new classes or methods.

## Key Concepts/Deep Dive

### Real-Time Example of Exception Issues
Consider a mobile recharge scenario: You deduct money from your account, but a network issue fails the transaction. Money is lost, damaging the app's reputation. Exception handling provides an alternative logic to refund funds, preventing loss and ensuring user trust.

### What is an Exception?
- **Runtime Error**: Occurs during program execution due to wrong values or logic.
- **Object**: An instance of `java.lang.Throwable` or its subclasses (e.g., `ArithmeticException`, `NullPointerException`).
- **Exception Types**:
  - Errors: JVM-level issues (out of memory, stack overflow).
  - Exceptions: Program-level issues (arithmetic, array index out of bounds, etc.).
- **When Exception Occurs**:
  - Program terminates abnormally.
  - Subsequent statements aren't executed.
  - Values are lost (e.g., previous inputs in a batch process).
  - JVM prints a non-English, non-user-friendly message.

### Need for Exception Handling
- **Purpose**: Stop abnormal termination, execute alternative logic, and print user-friendly messages.
- **Without Handling**: Money/transaction losses; user frustration; program insecurity.
- **With Handling**: Refund logic (e.g., mobile recharge); maintain data integrity.

| Concept | Description | Example |
|---------|-------------|---------|
| Compile-time Errors | Syntax mistakes; resolved by correcting code. | Missing semicolon. |
| Runtime Errors (Exceptions) | Wrong values/logic; JVM throws exception. | Division by zero. |
| Exception Handling | `try-catch` or `throws`; prevents termination. | Alternative flow for errors. |

### Exception Handling Process
Exception handling involves two main processes:
- **Catching Exceptions**: Using `try-catch` to catch and handle exceptions locally.
- **Reporting Exceptions**: Using `throws` to report exceptions to the caller method.

> [!IMPORTANT]
> Exception handling should always be implemented to make programs user-friendly and robust.

### Try-Catch Syntax and Execution Flow
- **Syntax**:
  ```java
  try {
      // Business logic that may throw exception
  } catch (ExceptionType e) {
      // Handle exception logic
  }
  ```
- **Execution Flow**:
  - Control enters `try` block always.
  - If exception occurs, control jumps to matching `catch` block.
  - After `catch`, control proceeds to statements after `try-catch`.
  - Without `catch`, JVM terminates abnormally.

```diff
+ Normal Flow: Statements execute sequentially.
- Exception Flow: Stop at exception-causing statement; jump to catch.
! Alternative Logic: Execute catch block for recovery.
```

### Practical Example Program
Here's a program demonstrating exception handling for division:

```java
public class TestException {
    public static void main(String[] args) {
        try {
            int a = 10;
            int b = 0;
            int c = a / b;  // Exception-causing statement
            System.out.println("Result: " + c);
        } catch (ArithmeticException e) {
            System.out.println("Don't divide the number by zero.");
        }
        System.out.println("Main end");
    }
}
```

Lab Demo: Read values from command line and handle exceptions.

```java
public class TestReadValues {
    public static void main(String[] args) {
        try {
            int a = Integer.parseInt(args[0]);
            int b = Integer.parseInt(args[1]);
            int c = a / b;
            System.out.println("Result: " + c);
        } catch (ArrayIndexOutOfBoundsException e) {
            System.out.println("Please enter two integers as: java TestReadValues 10 5");
        } catch (NumberFormatException e) {
            System.out.println("Please enter only integers.");
        } catch (ArithmeticException e) {
            System.out.println("Don't enter zero as second value.");
        }
    }
}
```

Execute: `java TestReadValues 10 2` → Normal output: Result: 5  
Execute: `java TestReadValues` → Output: Please enter two integers as: java TestReadValues 10 5  
Execute: `java TestReadValues a b` → Output: Please enter only integers.  
Execute: `java TestReadValues 10 0` → Output: Don't enter zero as second value.

### Real-World Application: User Input Handling
In e-commerce (e.g., Amazon sign-in), wrong inputs (empty fields, invalid emails, wrong passwords) raise exceptions. Handled via `try-catch` to show user-friendly messages without terminating the program.

- Empty field → Display: "Mobile number: How can you leave it empty?"
- Invalid email → Display: "We cannot find an account with this email address."
- Wrong password → Display: "Your password is incorrect."

### Multiple Catch Blocks
A `try` block can have multiple `catch` blocks for different exception types. Each handles a specific error.

Example:
```java
try {
    // Code with potential multiple exceptions
} catch (ArithmeticException e) {
    // Handle division by zero
} catch (ArrayIndexOutOfBoundsException e) {
    // Handle missing arguments
} catch (NumberFormatException e) {
    // Handle invalid number input
}
```

### Order of Catch Blocks
- Catch blocks can be in any order initially, but rules apply:
  - No duplicate exception types.
  - Parent class (`Exception`) cannot precede child classes (`ArithmeticException`), as it makes child catches unreachable; compiler error: "Exception ArithmeticException has already been caught."

### Single Catch Block for All Exceptions
Use `catch (Exception e)` to catch all exceptions, as `Exception` is the superclass. However, specific catches for targeted handling are preferred.

Example:
```java
catch (Exception e) {
    System.out.println("Some exception raised.");
}
```

## Summary

### Key Takeaways
```diff
+ Exception: Runtime error as an object (Throwable subclass).
+ Need: Prevents abnormal termination and data loss.
+ Handling: Try-catch for catching; throws for reporting.
+ Execution: Try always runs; catch on match; proceeds after.
+ Multiple Catches: Order matters; parent after child.
! Always handle to make programs user-friendly.
```

### Expert Insight

#### Real-world Application
In production, exception handling ensures app reliability (e.g., banking apps refund on transaction fails). Use try-catch in input validation, database operations, and API calls to log errors and show meaningful messages.

#### Expert Path
Master by practicing scenarios: I/O operations, threading, and custom exceptions. Study JDBC for database exceptions and Spring for global handlers. Aim for defensive programming with detailed logging.

#### Common Pitfalls
- Forgetting to handle unchecked exceptions (runtime).
- Placing parent catch before child, causing unreachable code.
- Ignoring exceptions, leading to hidden bugs.
- Not using finally for cleanup (files/objects).
- Slow performance due to deep try-catch nesting.

#### Lesser Known Things
- Exceptions are "expensive" (create stack trace); avoid for control flow.
- Use `try-with-resources` for auto-close (files, connections).
- Library exceptions: `IllegalArgumentException` for invalid args; `NoSuchElementException` for missing data.
