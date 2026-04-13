# Session 165: Exception Handling 03

**Exception Handling 03**

## Table of Contents
- [Exception Handling with User Input](#exception-handling-with-user-input)
- [Looping to Reprompt on Errors](#looping-to-reprompt-on-errors)
- [Handling Input Mismatch Exception](#handling-input-mismatch-exception)
- [Separating Try-Catch for Each Input](#separating-try-catch-for-each-input)
- [Lab Demo: Division Programra with Error Handling](#lab-demo-division-program-with-error-handling)
- [Real-Life Application](#real-life-application)
- [Arithmetic Exception Handling](#arithmetic-exception-handling)
- [BufferedReader Instead of Scanner](#bufferedreader-instead-of-scanner)
- [Nested (Inner) Try-Catch](#nested-inner-try-catch)
- [Rules for Nested Try-Catch](#rules-for-nested-try-catch)
- [Exception Propagation](#exception-propagation)
- [Test Cases and Outputs](#test-cases-and-outputs)
- [Project Development](#project-development)

## Exception Handling with User Input

### Overview
Building on previous lessons, this session focuses on practical exception handling for user inputs in Java programs, particularly when reading values from the keyboard. The goal is to handle exceptions gracefully without terminating the program abnormally, ensuring the application continues to prompt users for valid inputs.

### Key Concepts/Deep Dive
- **Input Validation and Exceptions**: When reading integer inputs using methods like `Scanner.nextInt()`, exceptions such as `ArithmeticException` (for division by zero) or `InputMismatchException` (for non-integer inputs) can occur.
- **Program Flow Without Handling**:
  - If an exception arises (e.g., dividing by zero), the program terminates abnormally after displaying an error message.
  - The user is not reprompted, leading to a poor user experience, similar to incorrect password entries in Gmail where the form doesn't reset.
- **Desired Behavior**:
  - Catch exceptions, display error messages, and reprompt the user for the same input without restarting the entire input sequence.
  - Use loops combined with try-catch blocks to achieve continuous execution and user-friendly error handling.

## Looping to Reprompt on Errors

### Overview
To prevent abnormal program termination on exceptions, integrate try-catch blocks within loops. This brings control back to the try block for re-execution of statements, allowing users to retry invalid inputs.

### Key Concepts/Deep Dive
- **Why Loops?**: Exceptions in try blocks cause control to jump to the catch block; without loops, the program continues to the next unrelated statements or terminates.
- **Break Statement**: Place `break;` at the end of the try block (after successful input) to exit the loop once inputs are valid.
- **Infinite Loop Prevention**: Use `while(true)` as the loop condition, ensuring repeated attempts until success.
- **Common Misconception**: Control does not automatically return to the try block after catch; loops must be explicitly used.
- **Example Structure**:
  ```java
  while (true) {
      try {
          // Read inputs and perform operations
          break; // On success
      } catch (ArithmeticException e) {
          System.out.println("Error message");
      }
  }
  ```

## Handling Input Mismatch Exception

### Overview
When users enter non-integer values (e.g., letters), `Scanner.nextInt()` throws `InputMismatchException`, causing abnormal termination and potentially infinite loops if the invalid input remains in the scanner buffer.

### Key Concepts/Deep Dive
- **Cause of Exception**: Non-integer inputs like "a" are stored in the Scanner buffer, and `nextInt()` fails repeatedly if the buffer isn't cleared.
- **Solution**: Catch `InputMismatchException` and use `scanner.nextLine()` to consume and discard the invalid input from the buffer.
- **Impact Without Handling**: Results in an infinite loop as the same invalid data is read repeatedly.
- **Code Example**:
  ```java
  catch (InputMismatchException e) {
      scanner.nextLine(); // Clear buffer
      System.out.println("Please enter only integers");
  }
  ```

## Separating Try-Catch for Each Input

### Overview
Using a single try-catch for multiple inputs is inefficient; it forces re-entry of all values if one is invalid. Separate try-catch loops for each input value ensure only the erroneous input is reprompted.

### Key Concepts/Deep Dive
- **Single Try-Catch Issue**: If the second number is invalid, the user must re-enter both numbers, which is user-unfriendly, especially for large input sets (e.g., 100 values).
- **Best Practice**: Implement individual while(true) try-catch loops for each variable.
  ```java
  // For first number
  while (true) {
      try {
          a = scanner.nextInt();
          break;
      } catch (InputMismatchException e) {
          scanner.nextLine();
          System.out.println("Please enter only integers for first number");
      }
  }
  // Similar for second number
  ```
- **Declaration Scope**: Declare variables outside the loops to avoid redeclaration errors (e.g., move `int a;` outside while loops).
- **Output Method**: Use `System.err.println()` for error messages to display in red in Eclipse, differentiating from standard output.

## Lab Demo: Division Program with Error Handling

### Overview
Develop a Java program that reads two integers from the user, divides them, and handles exceptions by prompting for re-entry of invalid values.

### Steps for Lab Demo
1. **Setup Scanner**: Import `java.util.Scanner;` and create `Scanner sn = new Scanner(System.in);`.
2. **Declare Variables**: Define `int a = 0, b = 0, result = 0;` outside loops.
3. **First Number Input Loop**:
   - While loop with try-catch for `InputMismatchException`.
   - Prompt: `System.out.println("Enter first number:");`
   - Read: `a = sn.nextInt();`
   - Catch: Clear buffer with `sn.nextLine();`, print error, continue loop.
   - Add `ArithmeticException` catch if needed, though it applies later.
   - Break on success.
4. **Second Number Input Loop**:
   - Similar structure: While loop, prompt, read `b`, catch `InputMismatchException` and clear buffer.
   - Additional catch for `ArithmeticException`: If `b == 0`, display "Don't enter zero as second argument", continue loop.
   - Break on valid input.
5. **Division and Output**:
   - Compute `result = a / b;`
   - Print result.
6. **Close Scanner**: `sn.close();`
7. **Run Test 1**: Input `10` for first, `0` for second → Error message, reprompt for second only.
8. **Run Test 2**: Input non-integer (e.g., "a") → "Please enter only integer" for first, reprompt first.
9. **Run Test 3**: Valid inputs `10` and `2` → Result `5`, program ends normally.
10. **Potential Infinite Loop Fix**: Ensure `nextLine()` is called only in catch blocks for `InputMismatchException`.

```java
import java.util.Scanner;

public class DivisionProgram {
    public static void main(String[] args) {
        Scanner sn = new Scanner(System.in);
        int a = 0, b = 0, result = 0;
        
        // First number loop
        while (true) {
            try {
                System.out.println("Enter first number:");
                a = sn.nextInt();
                break;
            } catch (java.util.InputMismatchException e) {
                sn.nextLine();
                System.out.println("Please enter only integers");
            }
        }
        
        // Second number loop
        while (true) {
            try {
                System.out.println("Enter second number:");
                b = sn.nextInt();
                if (b == 0) {
                    throw new ArithmeticException("Division by zero");
                }
                result = a / b;
                break;
            } catch (ArithmeticException e) {
                System.out.println("Don't enter zero as second argument");
            } catch (java.util.InputMismatchException e) {
                sn.nextLine();
                System.out.println("Please enter only integers");
            }
        }
        
        System.out.println("Result: " + result);
        sn.close();
    }
}
```

## Real-Life Application

- **Production Use**: Exception handling ensures applications like login forms or data entry systems remain usable even on errors, improving user retention.
- **GUI vs. Console**: In GUI applications (AWT, Swing, JavaFX), built-in error handling makes this easier; console apps require manual implementation.
- **Impact**: Enhances logical thinking; direct parallels to web applications (e.g., HTML forms) where invalid inputs are handled without page reloads.
- **Efficiency**: Programs reading 100 values use 100 try-catch loops; modern frameworks abstract this.

## Arithmetic Exception Handling

### Overview
Focus on `ArithmeticException`, commonly from division by zero.

### Key Concepts/Deep Dive
- **Exception Source**: `a / b` when `b == 0`.
- **Handling Steps**: Catch with message, often combined with input validation.
- **Eclipse Output Note**: `System.err` and `System.out` may interleave due to concurrent threads; not an issue in plain command-line.
- **Test Run**: Enter `10` and `0` → Exception handled, reprompt.

## BufferedReader Instead of Scanner

### Overview
Replace Scanner with BufferedReader for input reading, using `br.readLine()` and `Integer.parseInt()` for conversion.

### Key Concepts/Deep Dive
- **Setup**: `BufferedReader br = new BufferedReader(new InputStreamReader(System.in));`
- **Differences**:
  - `br.readLine()` returns String; parse to int with `Integer.parseInt(br.readLine())`.
  - Exceptions: `NumberFormatException` instead of `InputMismatchException`.
  - `IOException` from `readLine()` due to potential I/O issues (e.g., lost connection).
- **No More Input Mismatch**: But `IOException` must be handled, as `readLine()` can declare it.
- **Code Switch**: Remove `sn.nextLine();` for clearing; instead, catch `IOException` and print stack trace.
- **Compilation Errors**: Handle `IOException` in try-catch.

```java
import java.io.*;

public class BufferedReaderProgram {
    public static void main(String[] args) {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        int a = 0, b = 0, result = 0;
        
        // Similar loops, but parse and catch IOException
        while (true) {
            try {
                System.out.println("Enter first number:");
                a = Integer.parseInt(br.readLine());
                break;
            } catch (NumberFormatException e) {
                System.out.println("Please enter only integers");
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        
        // Second number with ArithmeticException
        while (true) {
            try {
                System.out.println("Enter second number:");
                b = Integer.parseInt(br.readLine());
                if (b == 0) throw new ArithmeticException();
                result = a / b;
                break;
            } catch (ArithmeticException e) {
                System.out.println("Don't enter zero");
            } catch (NumberFormatException e) {
                System.out.println("Please enter only integers");
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        
        System.out.println("Result: " + result);
    }
}
```

## Nested (Inner) Try-Catch

### Overview
Nested try-catch involves placing try-catch blocks inside others (outer vs. inner) to handle exceptions at different levels: outer for major issues, inner for specific problems within the try block.

### Key Concepts/Deep Dive
- **Outer Try-Catch**: Handles main exceptions to terminate the method or provide overarching error details.
- **Inner Try-Catch**: Handles exceptions within the outer try to continue logic or provide targeted fixes.
- **Example**: BufferedReader scenario where `IOException` is outer (terminate), `NumberFormatException` is inner (reprompt).
- **Structure**:
  ```java
  try { // Outer
      // Statements, potentially raising main exceptions
      try { // Inner
          // Critical statements needing immediate handling
      } catch (SpecificException e) {
          // Handle here
      }
  } catch (MainException e) {
      // Outer handler
  }
  ```
- **When IOException Occurs**: Display stack trace, terminate outer try.

## Rules for Nested Try-Catch

### Overview
Exceptions in inner try are caught by inner catch first; if unmatched, propagate to outer, then to JVM.

### Key Concepts/Deep Dive
- **Propagation Rule**: Inner exception → Inner catch → Outer catch → JVM default handler.
- **Variable Naming**: Avoid same variable names in outer/inner catch to prevent scope conflicts.
- **Exception in Catch Block**: If exception rises in catch, it propagates outward (not caught by same catch).
- **Placement**: Try-catch can be inside try, catch, or finally anywhere in the method.

## Exception Propagation

- Exceptions from inner try go to outer if not caught locally.
- Ends with JVM handling if unmatched anywhere.

## Test Cases and Outputs

### Overview
Examples of programs with nested try-catch and their flows.

### Key Concepts/Deep Dive
- **Program 1**: Inner exception caught by inner, outer catch not executed.
- **Program 2**: Array exception in inner, propagate if not caught.
- **Outputs**:
  - Case with ArithmeticException: -> Inner catch -> Continue.
  - Case with uncaught exception: -> Outer -> Normal termination.
- **Trick Questions**:
  - Can exception rise in catch? Yes, handle with nested try in catch.
  - JVM default handler terminates if uncaught.

### Table: Exception Handling Scenarios

| Scenario | Exception Type | Handling | Output Behavior |
|----------|----------------|----------|-----------------|
| Division by zero | ArithmeticException | Inner Catch, Reprompt | Continue Program |
| Invalid input (e.g., "a") | InputMismatchException / NumberFormatException | Inner Catch, Clear Buffer, Reprompt | Continue for that input |
| I/O failure (BufferedReader) | IOException | Outer Catch, Print Stack Trace | Terminate Method |
| Multiple exceptions | Mixed | Nested Handling | Continue or Terminate Based on Level |

## Project Development

- **Full Program**: Combine separation for each input, nested try-catch as needed.
- **Material Reference**: Pages 141-142 in the course material.
- **Practice**: Complete exercises and test cases.
- **Tomorrow Topic**: Finally block.

## Summary

### Key Takeaways
```diff
+ Use loops with try-catch to reprompt users on exceptions without abnormal termination.
+ Separate try-catch for each input to avoid re-entering all values.
+ Handle InputMismatchException with buffer clearing using nextLine().
+ Nested try-catch: Inner for specific handlers, outer for major exceptions.
+ BufferedReader requires IOException handling in addition to NumberFormatException.
+ Exceptions propagate from inner to outer if unmatched.
- Single try-catch for multiple inputs forces full re-entry.
- Forgetting buffer clearing leads to infinite loops.
! Exception handling concepts are universal across OOP languages, adapting syntax.
```

### Expert Insight

#### Real-world Application
In production systems like e-commerce platforms or user authentication APIs, robust error handling prevents crashes during user interactions. For instance, API endpoints use try-catch with logging to retry operations or provide user-friendly error responses, ensuring high availability and better CX, much like Gmail's incremental validation.

#### Expert Path
Master exception handling by diving into advanced Java features like custom exceptions and AOP (Aspect-Oriented Programming) for cross-cutting concerns. Practice with frameworks like Spring, where @ExceptionHandler annotations simplify nested handling. Focus on "fail-fast" strategies: log, retry, or degrade gracefully to build resilient apps.

#### Common Pitfalls
- **Infinite Loops**: Forget to clear Scanner buffer on InputMismatchException; always use nextLine() in catch.
- **Scope Conflicts**: Reuse exception variables in nested catch – prefix like e_inner to avoid redeclaration errors.
- **Unchecked Propagation**: Unhandled IOExceptions in BufferedReader cause compilation errors; wrap in try-catch or declare in method signature.
- **Misconceptions**: Assuming control returns to try after catch without loops leads to incomplete programs.
- **Platform Differences**: Eclipse mixes err/out streams due to threading; test in console environments.

#### Lesser-Known Things
- BufferedReader vs. Scanner: Scanner's nextInt() throws InputMismatch silently, while parseInt() with readLine() throws NumberFormat for better separation of concerns.
- Propagation Depth: Exception in inner finally propagates to outer cancel, bypassing local handlers.
- Historical Note: Exception handling concepts predate Java, originating from languages like Ada and C++, with JVM default handler as the final safety net.
