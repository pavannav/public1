# Session 172: Exception Handling 07

## Table of Contents
- [Compiler Thinking with Respect to Try-Catch Blocks](#compiler-thinking-with-respect-to-try-catch-blocks)
- [Variable Scope and Initialization in Try-Catch-Finally](#variable-scope-and-initialization-in-try-catch-finally)
- [Returning Values from Methods with Exceptions](#returning-values-from-methods-with-exceptions)
- [Throwable Class Methods](#throwable-class-methods)
- [How to Solve Exceptions](#how-to-solve-exceptions)
- [Throw and Throws Keywords](#throw-and-throws-keywords)
- [Difference Between Throw and Throws](#difference-between-throw-and-throws)
- [Sample Project: Combining Throw, Throws, Try, Catch](#sample-project-combining-throw-throws-try-catch)
- [Rules for Throw Keyword](#rules-for-throw-keyword)

## Compiler Thinking with Respect to Try-Catch Blocks

### Overview
Exception handling in Java involves try-catch blocks to manage runtime errors. The compiler assumes execution paths that may raise exceptions, ensuring that code handles potential failures gracefully. This section explores how the compiler processes variables and control flow within try-catch-finally structures.

### Key Concepts/Deep Dive
- **Uninitialized Variables**: If a variable is declared outside a try block but initialized inside, the compiler cannot guarantee its value in the catch block if an exception occurs. This leads to compilation errors.
- **Scope Restrictions**: Variables initialized inside a try block are only accessible within that block and not in catch or finally blocks.
- **Compiler Assumptions**: The compiler makes assumptions about possible exception scenarios based on code path analysis. For instance, in arithmetic operations like `10/0`, it anticipates `ArithmeticException`.
- **Error Mitigation**: Using strategies like initializing variables outside the try block or employing dummy initializations helps satisfy compiler assumptions.

### Code/Config Blocks
```java
public class Example {
    public static void main(String[] args) {
        // Uninitialized variable example causing error
        int x;  // Compiler sees x not initialized
        try {
            x = 10 / 0;  // ArithmeticException, but x not visible outside
        } catch (ArithmeticException e) {
            // System.out.println(x); // Error: x might not be initialized
        }
    }
}
```

### Lab Demos
1. Declaration and Initialization:
   - Declare variable outside try block.
   - Initialize inside try; observe scope.
   - Attempt access in catch: Compiler error.

2. Exception Path Simulation:
   - Write code that divides by zero.
   - Compiler assumes ArithmeticException won't initialize variable.
   - Fix by initializing outside or using dummy value.

## Variable Scope and Initialization in Try-Catch-Finally

### Overview
Variables in try-catch-finally blocks have strict scoping rules. Understanding these rules prevents compilation errors and ensures reliable exception handling.

### Key Concepts/Deep Dive
- **Scope of Initialization**: Initializing a variable inside try makes it unavailable in catch or finally. Always declare and potentially initialize outside.
- **Compiler Visibility**: The compiler checks variable value possibilities at error points. Uninitialized variables cause errors due to implicit assumptions.
- **Practical Approach**: Declare variables at method level for broad accessibility across exception blocks.

## Returning Values from Methods with Exceptions

### Overview
Methods with non-void return types must return values on all execution paths, including exception scenarios. Exception handling complicates this, requiring careful placement of return statements.

### Key Concepts/Deep Dive
- **Void Methods**: No return requirement; returning is optional.
- **Non-Void Methods**: Mandatory return value at method end or in all possible paths.
- **Compiler Rule 13**: For non-void methods returning from try blocks, must return at method end to satisfy assumptions.
- **Exception Scenarios**: Each exception case (try, catch) must handle return logic to avoid compilation errors.
- **Best Practices**: Use a local variable for results, initialized in try/catch, and return at the end. Avoid return statements in loops or unreachable code after try-catch-finally.
- **Finally Block Usage**: For compulsory post-exception execution, place statements in finally, as it's always executed unless System.exit().

### Code/Config Blocks
```java
static void m8() {  // Void method - return optional
    try {
        int result = 10;  // Logic in try
        return;  // Optional
    } catch (ArithmeticException e) {
        // Handle
    } finally {
        // Always executes
    }
}

static int m9() {  // Non-void method
    try {
        int result = 10 / 0;  // Logic; no return here
    } catch (ArithmeticException e) {
        // Handle; must return or initialize
    }
    return 0;  // Mandatory at end
}

// Recommended pattern
static int calculate() {
    int result = 0;  // Declare outside
    try {
        // Perform logic
        result = performCalculation();
    } catch (Exception e) {
        // Error handling
    }
    return result;
}
```

### Lab Demos
1. Void Method with Try-Catch:
   - Implement m8 with return in try and catch.
   - Compile with/without return at end.

2. Non-Void Method Requirements:
   - Create m9 with logic in try.
   - Place return in catch blocks.
   - Ensure return at method end.

3. Finally Block Placement:
   - Write code executing statements after try-catch.
   - Unreachable code error when placed outside finally.

## Throwable Class Methods

### Overview
The Throwable class provides methods to inspect and display exception details. These are essential for debugging and user feedback.

### Key Concepts/Deep Dive
- **printStackTrace()**: Prints exception name, message, and stack trace to System.err.
- **toString()**: Returns exception name followed by colon and message.
- **getMessage()**: Returns the detailed message string.
- **Usage Contexts**: Employ in backup catch blocks where specific exceptions are unknown.

### Code/Config Blocks
```java
try {
    int result = 10 / 0;
} catch (Exception e) {
    e.printStackTrace();        // Full details
    System.out.println(e.toString());  // Class: message
    System.out.println(e.getMessage()); // Message only
}
```

### Lab Demos
1. Display Exception Information:
   - Raise ArithmeticException.
   - Use each method to print details.
   - Output example: java.lang.ArithmeticException: / by zero

2. Backup Catch Block:
   - Use catch (Exception e) for unknown exceptions.
   - Apply above methods for error reporting.

## How to Solve Exceptions

### Overview
Solving exceptions involves displaying proper error messages and accepting correct user inputs. This requires catching exceptions in user interaction code.

### Key Concepts/Deep Dive
- **Display Messages**: Catch exceptions and show user-friendly errors.
- **Correct Inputs**: Re-prompt user for valid data after showing errors.
- **Approach**: Combine try-catch with user input loops for validation.

### Code/Config Blocks
```java
Scanner sc = new Scanner(System.in);
int value;
while (true) {
    try {
        System.out.print("Enter positive number: ");
        value = sc.nextInt();
        if (value < 0) throw new IllegalArgumentException("Negative not allowed");
        break;  // Valid input
    } catch (Exception e) {
        System.out.println("Error: " + e.getMessage());
    }
}
```

## Throw and Throws Keywords

### Overview
While JVM throws exceptions automatically, developers can manually throw exceptions using `throw` and report them with `throws`.

### Key Concepts/Deep Dive
- **Throw Keyword**: Throws an exception object manually when conditions are invalid.
- **Throws Keyword**: Declares exceptions a method might throw, informing callers to handle them.
- **Syntax**: `throw new ExceptionType("message");` and `public void method() throws ExceptionType`
- **Manual Throwing**: Contrast to JVM-thrown exceptions; used in validation logic.
- **Reporting**: Ensures abnormal terminations are avoided by alerting callers.

### Code/Config Blocks
```java
class Validator {
    static void validate(int a) throws IllegalArgumentException {
        if (a < 0) {
            throw new IllegalArgumentException("Negative not allowed");
        }
        // Valid case
    }

    public static void main(String[] args) {
        try {
            validate(-1);
        } catch (IllegalArgumentException e) {
            System.err.println(e.getMessage());
        }
    }
}
```

### Lab Demos
1. Manual Exception Throwing:
   - Implement validator that throws IllegalArgumentException for invalid inputs.

2. Rethrowing Exceptions:
   - Catch in one method and re-throw with throws.

## Difference Between Throw and Throws

### Overview
`throw` launches an exception, while `throws` declares it for caller handling.

| Aspect | Throw | Throws |
|--------|-------|--------|
| Purpose | Throw exception object | Declare exceptions method throws |
| Usage | Inside method body | In method signature |
| Syntax | throw exceptionObject; | throws ExceptionType1, ExceptionType2 |
| Multiple | One at a time | Multiple exceptions |

### Key Concepts/Deep Dive
- **Runtime vs Declaration**: `throw` is runtime action; `throws` is compile-time declaration.
- **Plural Nature**: `throws` supports multiple exceptions (plural form).

### Code/Config Blocks
```java
// Throw multiple based on conditions
public void validate(int a) throws IllegalArgumentException, ArithmeticException {
    if (a < 0) throw new IllegalArgumentException("Invalid");
    if (a == 0) throw new ArithmeticException("Zero error");
}
```

## Sample Project: Combining Throw, Throws, Try, Catch

### Overview
This project demonstrates a calculator accepting two numbers, validating them (no negatives), and returning sum. Throws exceptions for invalid inputs; caller catches and re-prompts.

### Key Concepts/Deep Dive
- **Business Logic**: Use throw/throws for validation.
- **User Code**: Use try-catch for input/output.
- **Loop Re-prompting**: Continue accepting inputs until valid.

### Code/Config Blocks
```java
class Calculator {
    static int add(int a, int b) throws IllegalArgumentException {
        if (a < 0 || b < 0) {
            throw new IllegalArgumentException("Do not pass negative numbers");
        }
        return a + b;
    }
}

class User {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int result;
        while (true) {
            try {
                System.out.print("First number: ");
                int a = sc.nextInt();
                System.out.print("Second number: ");
                int b = sc.nextInt();
                result = Calculator.add(a, b);
                System.out.println("Result: " + result);
                break;
            } catch (IllegalArgumentException e) {
                System.out.println(e.getMessage() + ". Enter correct values.");
            }
        }
        sc.close();
    }
}
```

### Lab Demos
1. Run with Valid Inputs: 10 + 20 = 30.
2. Run with Invalid: -1 + 2 → Error message → Re-prompt → 1 + 2 = 3.

## Rules for Throw Keyword

### Overview
The `throw` keyword has specific placement and usage rules to ensure code correctness.

### Key Concepts/Deep Dive
- **Placement**: Only inside methods or constructors; not at class level, static/instance initializer blocks.
- **Declaration Limitation**: Cannot be in method signature (use `throws` instead).
- **Throwable Objects**: Must be Throwable type; only one per `throw`.
- **Post-Throw Statements**: Unreachable if directly after; use conditions or finally.
- **Multiple Throws**: Use multiple `if` conditions for different exceptions.

### Code/Config Blocks
```java
// Valid: Inside method
public void method() {
    throw new RuntimeException("Error");
}

// Invalid: Outside method
throw new RuntimeException();  // No!

// Valid: Multiple with conditions
if (condition1) throw new Exception1();
if (condition2) throw new Exception2();
```

## Summary

### Key Takeaways
```diff
+ Properly declare variables outside try blocks to avoid initialization errors.
+ Use throws in method signatures to inform callers of potential exceptions.
+ Leverage Throwable methods for detailed exception information.
+ Combine throw/throwns in business logic and try/catch in user-facing code.
- Avoid unreachable statements after throw without proper control flow.
- Never return values from only part of exception paths in non-void methods.
! Exception handling requires satisfying compiler assumptions for safe execution.
```

### Expert Insight

**Real-world Application**: In production systems like e-commerce platforms, use custom exceptions via `throw` for input validation (e.g., invalid credit card details), with `throws` in service layers. User interfaces employ try-catch with loops for graceful error recovery, preventing app crashes during data submissions.

**Expert Path**: Master checked vs unchecked exceptions and custom exception hierarchies. Study JUnit testing for exception scenarios and Spring Boot's exception handling with `@ExceptionHandler`. Build projects integrating logging frameworks (e.g., Logback) for exception traces.

**Common Pitfalls**:
- **Ignoring throws**: Failing to declare exceptions leads to unhandled runtime errors; always document with `throws`.
- **Overcatching**: Using catch (Exception e) everywhere hides specific errors; prefer specific exception types.
- **Resource Leaks**: Forgetting to close resources despite `finally`; use try-with-resources for automatic handling.
- **Misused throw**: Throwing in constructors without informing can cause issues in inheritance; ensure proper propagation.
- Less-known tip: Exceptions can impact performance due to stack trace creation; use for genuine errors, not control flow. Avoid infinite recursion in finally blocks, as it can lead to stack overflows.
