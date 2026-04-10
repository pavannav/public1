# Session 38: Control Flow Statements

**Table of Contents**
- [Overview](#overview)
- [Key Concepts/Deep Dive](#key-conceptsdeep-dive)
- [Summary](#summary)

## Overview

💡 Control flow statements are essential in Java programming for controlling the execution flow of code. They allow developers to make decisions on whether to execute specific blocks of code based on conditions, execute loops for repetitive tasks, and terminate or jump between sections of code. This session introduces the fundamental concepts of control flow statements, focusing on why they are needed, how they work, and their types: conditional, iterative (loops), and transfer (branching) statements. The instructor emphasizes conditional statements, particularly the `if` statement, through practical explanations, common pitfalls, and example programs. As the 38th session in the Core Java series, it builds upon operators and data types to demonstrate decision-making in methods.

Note: Several transcription errors were corrected (e.g., "cript" to "Script" at the start, "work out" to "workout", "ternary operator" as "ternary operator", "shift operators" as "shift operators", "bitwise operators" as "bitwise operators", "robo" to "relational", "evo" to "equality", "cube ctl" to "kubectl" in references, and spelling fixes like "precedence" to "precedence"). Corrections ensure technical accuracy without altering the original meaning.

## Key Concepts/Deep Dive

### Purpose of Control Flow Statements

Control flow statements are keywords used to control the flow of execution in Java programs. They enable programmatic decision-making for whether to execute statements zero times, one time, or multiple times, and to terminate execution flow when needed.

- **Why Needed**: In real-world applications, not all statements should execute unconditionally. For example, in a banking app, deposit/withdraw operations must validate inputs (e.g., account number, PIN). Logic alone (via operators) performs calculations, but control flow statements validate conditions using relational (`ro`), equality (`evo`), and logical operators, ensuring actions like balance updates occur only if conditions (e.g., positive amount, valid PIN) are true.

- **What They Are**: Eleven control flow statements exist in Java, divided into three categories:
  - **Conditional Statements** (5): `if`, `else`, `switch`, `case`, `default` – For executing a block of statements zero or one time based on a boolean condition.
  - **Iterative (Loop) Statements** (3): `while`, `do-while`, `for` – For executing a block zero or n times until a condition fails (becomes false).
  - **Transfer (Branching) Statements** (3): `break`, `continue`, `return` – For terminating execution (loop iteration, full loop, or method).

- **When to Use**: Use when developing methods (or constructors) where some statements need conditional execution, repetition, or flow termination. Examples include validating user input, iterating over arrays, or handling exceptions.

### Types of Control Flow Statements

#### Conditional Statements

Conditional statements decide whether to execute a block of code zero or one time based on a boolean condition (literal, variable, expression, or method returning boolean). They are the entry point for decision-making.

- **Syntax and Rules**:
  - Basic `if`: `if (boolean condition) { statement(s); }` – Executes block if true; skips if false. Condition generates true/false via relational operators (`<`, `>`, `<=`, `>=`), equality (`==`), logical (`&&`, `||`, `!`), or other boolean expressions.
  - Without braces `{}`: Allows only one statement (not variable declarations, as no scope exists).
  - Common Error: Passing non-boolean (e.g., `int`) in parentheses causes "incompatible types" compile-time error. Assignment operator (`=`) in condition returns variable-type value (e.g., `int` for int variables), not boolean.

- **Flow of Execution**:
  ```
  flowchart TD
      A[Start Method] --> B[Direct Statement X]
      B --> C{if (condition)?}
      C -->|True| D[Execute Block Y]
      C -->|False| E[Skip Block, Go to Next Z]
      D --> E
      E --> F[End]
  ```
  - Flow: Control enters method, executes unconditional statements, evaluates condition (true ⇒ execute block once; false ⇒ skip). No repetition.

- **Example Programs**:
  - **Basic If Without Else**:
    ```java
    public class Test {
        public static void main(String[] args) {
            m1(10);
            m1(15);
        }
        static void m1(int a) {
            System.out.println("Hi");
            if (a == 10) { // Equality check for true/false
                System.out.println("Hello");
            }
            System.out.println("How are you?");
        }
    }
    // Output for m1(10): Hi Hello How are you?
    // Output for m1(15): Hi How are you? (Hello skipped)
    ```
    - Explanation: For `m1(10)`, condition `a == 10` is true, so "Hello" executes. For `m1(15)`, false, "Hello" skipped. No compile errors as `==` generates boolean.

  - **Tricky Assignment in Condition**:
    ```java
    // Compile-time error example (from transcript correction):
    static void m1(int a) {
        if (a = 10) { // Assignment returns int (10), not boolean ⇒ error
            System.out.println("Hello");
        }
    }
    ```
    - Assigns 10 to `a`, returns 10 (int), causes "incompatible types: int cannot be converted to boolean".

    ```java
    // Valid with boolean:
    static void m1(boolean a) {
        System.out.println("Hi");
        if (a = true) { // Assignment returns boolean true, condition always true
            System.out.println("Hello");
        }
        System.out.println("How are you?");
    }
    // Output (pass false or true): Hi Hello How are you? (Always true after assignment)
    ```
    - Assignment stores value in `a`, returns it for condition. For `m1(false)`: "Hi", assigns true, condition true via `if (a = true)` ⇒ "Hello", then "How are you?". `a` ends as true.

  - **Nested or Chained Concepts**: Not covered in this session; `if-else`, switches, and nested structures are for future sessions.

- **Real-World Application**: In bank apps, use `if` for validations: `if (pin == enteredPin) { allowWithdrawal(); }`. Prevents invalid operations, securing accounts.

### Diagrams and Visuals

- **Mermaid for Flow (Conceptual)**:
  ```mermaid
  flowchart TD
      A[Method Start] --> B{Conditional Check?}
      B -->|True| C[Execute If Block (Once)]
      B -->|False| D[Skip Block]
      C --> D[Proceed to Next]
  ```

### Lab Demos and Code Blocks

1. **Demonstration: If with Relational Operators**:
   - Code: As above.
   - Steps:
     1. Define method `m1(int a)`.
     2. Print "Hi" unconditionally.
     3. Use `if (a == 10)` to check if `a` equals 10.
     4. If true, print "Hello"; else skip.
     5. Print "How are you?" always.
     6. Call `m1(10)` and `m1(15)` to observe outputs.
   - Expected Output: Conditional execution based on input value.

2. **Troubleshooting Common Errors**:
   - Error: "incompatible types: int cannot be converted to boolean".
     - Cause: Using assignment (`=`) or int expression in `if`.
     - Resolution: Use comparison (`==`) or boolean expressions. E.g., `if (a == 10)` instead of `if (a = 10)`.

## Summary

### Key Takeaways
```diff
+ Control flow statements control execution flow programmatically, ensuring decisions based on conditions.
+ Conditional statements (e.g., if) execute blocks zero or one time; use boolean conditions only.
+ Operators (relational, equality, logical) prepare conditions; misuse (e.g., assignment in if) causes errors.
+ Flow of execution visualizes logic, preventing mistakes in complex programs.
- Avoid using non-boolean types in if conditions; always test with various inputs.
! Common Pitfall: Confusing assignment (=) with equality (==) leads to runtime logic errors, not compile errors.
```

### Expert Insight
**Real-world Application**: In production, `if` statements validate inputs before actions (e.g., API requests, database updates). Combine with operators for robust checks like `if (age >= 18 && hasLicense) { rentCar(); }`.

**Expert Path**: Master control flow by drawing execution flows manually for every program. Practice boolean expressions extensively, then move to loops for repetition. Use tools like IDE debuggers to visualize flows.

**Common Mistakes**: 
- Using assignment in conditions – Always double-check for `==` vs `=`.
- Forgetting scopes in single-statement ifs – Leads to variable declaration errors; use braces `{}` for clarity.
- Misunderstanding side effects – Assignment changes variables unexpectedly; test incrementally.

**Lesser Known Things**: Java's `if` supports short-circuit evaluation with logical operators (e.g., `&&` skips right side if left is false). This optimizes performance in complex conditions but can hide side effects if not careful. Avoid relying on it for business logic.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
