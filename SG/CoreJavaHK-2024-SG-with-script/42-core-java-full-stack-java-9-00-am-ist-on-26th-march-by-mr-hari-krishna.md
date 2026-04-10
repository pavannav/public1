# Session 42: Branching Statements (Break, Continue, Return)

### Table of Contents
- [Overview](#overview)
- [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
  - [Branching Statements](#branching-statements)
  - [Break Statement](#break-statement)
  - [Continue Statement](#continue-statement)
  - [Return Statement](#return-statement)
  - [Rules on Break, Continue, Return](#rules-on-break-continue-return)
- [Lab Demos](#lab-demos)
- [Summary](#summary)

## Overview
Branching statements in Java control the flow of execution by terminating loops, switch cases, or methods. The three main branching statements are:
- **Break**: Terminates the execution of loops or switch statements.
- **Continue**: Terminates the current iteration of a loop and moves to the next one.
- **Return**: Terminates a method and returns control to the calling method.

These statements are essential for managing program logic, handling special conditions, and optimizing code execution.

## Key Concepts and Deep Dive

### Branching Statements
Java supports three branching statements: break, continue, and return. These are designed to alter the normal flow of control in programs.

- Break and continue are primarily used within loops and switch statements.
- Return is used within methods and constructors.

### Break Statement
The break statement is used to terminate a loop (for, while, do-while) or a switch case prematurely. When executed, it immediately exits the current loop or switch block and transfers control to the next statement outside.

#### Syntax:
```java
if (condition) {
    break;
}
```

#### How it works:
- In a loop: Terminates all remaining iterations and moves control to the statement after the loop.
- In a switch: Jumps to the end of the switch block.

#### Example:
```java
for (int i = 1; i <= 5; i++) {
    if (i == 3) {
        break; // Exits the loop when i is 3
    }
    System.out.println(i); // Prints 1, 2
}
// Execution continues here
```

**Output:**
- Prints 1 and 2.
- Loop terminates at i = 3, and control exits to after the loop.

### Continue Statement
The continue statement terminates the current iteration of a loop and skips to the next iteration. Unlike break, it does not exit the loop entirely.

#### Syntax:
```java
if (condition) {
    continue; // Skips remaining statements in current iteration
}
// Loop continues here
```

#### How it works:
- Terminates only the current loop iteration.
- Increments the loop variable and checks the condition again.
- Proceeds to the beginning of the next iteration.

#### Example:
```java
for (int i = 1; i <= 5; i++) {
    if (i == 3) {
        continue; // Skips iteration when i is 3
    }
    System.out.println(i); // Prints 1, 2, 4, 5
}
```

**Output:**
- Prints 1, 2, 4, 5.
- Iteration i = 3 is skipped, but loop continues.

### Return Statement
The return statement terminates the execution of a method and returns control to the calling method. It may or may not return a value.

#### Syntax:
- `return;` (no value)
- `return value;` (with value, where value must be compatible with the method's return type)

#### How it works:
- Terminates the current method execution immediately.
- Returns to the calling method.
- If the method has a return type, it must return a compatible value; otherwise, it's optional in void methods but automatic for non-void.

#### Example (return without value):
```java
static void m1(int p) {
    if (p == 5) {
        return; // Terminates method if p is 5
    }
    System.out.println("M1 end");
}
```

**Output when called with m1(5):**
- Method terminates at return, no "M1 end" printed.

#### Example (return with value):
```java
static int m2(int p) {
    if (p == 5) {
        return p + 10; // Terminates and returns value
    }
    return p + 20;
}
```

**Output when called with System.out.println(m2(5)):**
- Prints 15.

### Rules on Break, Continue, Return
#### Rule 1: Placement Restrictions
- **Break**: Can only be placed inside loops or switch statements. If placed directly in a method, compiler throws "break outside switch or loop" error.
- **Continue**: Can only be placed inside loops. If placed elsewhere, compiler throws "continue outside of loop" error.
- **Return**: Allowed inside methods or constructors. Not allowed in static blocks or instance blocks; compiler throws "return outside method" error.

#### Rule 2: Unreachable Statements
- After break, continue, or return, no statements can be placed directly afterward, as they become unreachable, leading to compile-time error "unreachable statement".
- Exception: If break/continue/return is inside conditional blocks, statements after the conditional may execute.

#### Rule 3: Infinite Loop Considerations
- Writing `break` inside an infinite loop (e.g., `while (true) { break; }`) allows termination.
- Writing `continue` in an infinite loop may cause infinite execution if conditions aren't met.
- Compiler recognizes infinite loops only with direct literals like `while (true)`, not variable-based conditions.

## Lab Demos

### Demo 1: Break and Continue in For Loop
```java
class TestBreakContinue {
    public static void main(String[] args) {
        for (int i = 1; i <= 5; i++) {
            System.out.println("Iteration " + i + " start");
            if (i == 3) {
                break; // Demonstrates break terminating the loop
            }
            System.out.println("Iteration " + i + " end");
        }
        System.out.println("Main End");
    }
}
```

**Execution Flow (Break):**
- Executes iterations 1-3, printing start/end for 1 and 2.
- At i=3, break executes, exits loop.
- Control jumps to "Main End".

**Output:**
- Iteration 1 start, Iteration 1 end, Iteration 2 start, Iteration 2 end, Iteration 3 start, Main End.

Replace `break` with `continue`:
```java
if (i == 3) {
    continue; // Demonstrates continue terminating current iteration
}
```

**Execution Flow (Continue):**
- Iterations 1, 2, 4, 5 execute fully; i=3 skipped ("end" not printed, but loop continues).

**Output:**
- Iteration 1 start, Iteration 1 end, Iteration 2 start, Iteration 2 end, Iteration 3 start, Iteration 4 start, Iteration 4 end, Iteration 5 start, Iteration 5 end, Main End.

### Demo 2: Return Statement in Method Call
```java
class TestReturn {
    static void m1(int p) {
        System.out.println("M1 start");
        if (p == 5) {
            return; // Terminates method
        }
        System.out.println("M1 end");
    }

    static int m2(int p) {
        System.out.println("M2 start");
        if (p == 5) {
            return p + 10; // Returns value
        }
        return p + 20;
    }

    public static void main(String[] args) {
        System.out.println("Main Start");
        m1(5);  // Only "M1 start" printed
        m1(7);  // "M1 start", "M1 end" printed
        m2(5);  // "M2 start" printed, value replaced at call site
        m2(7);  // "M2 start" printed, value +20 returned
        System.out.println("Main End");
    }
}
```

**Output:**
- Main Start
- M1 start
- M1 start
- M1 end
- M2 start (first call)
- 15 (returned value)
- M2 start (second call)
- 27 (returned value)
- Main End

### Demo 3: Break/Continue/Return in Conditional Contexts
```java
public class TestRules {
    public static void main(String[] args) {
        // Example 1: Break inside while loop
        int count = 1;
        while (count <= 5) {
            if (count == 3) {
                break; // Exits loop
            }
            System.out.println(count);
            count++;
        }
        // Example 2: Continue for skipping iterations
        for (int i = 1; i <= 5; i++) {
            if (i == 3) {
                continue;
            }
            System.out.println(i);
        }
        // Example 3: Return terminating method
        m3(3); // Terminates early if p == 3
    }

    static void m3(int p) {
        System.out.println("M3 start");
        if (p == 3) {
            return;
        }
        System.out.println("M3 end");
    }
}
```

## Summary

### Key Takeaways
```diff
+ Break terminates loops or switches and sends control to the next statement outside.
+ Continue terminates the current loop iteration and proceeds to the next.
+ Return terminates the method and returns control to the caller, optionally with a value.
- Avoid placing break/continue outside loops/switches to prevent "outside switch or loop" errors.
- Avoid unreachable statements after break/continue/return in unconditional contexts.
! Compiler detects unreachable statements only when termination is guaranteed (e.g., after literal true/false).
```

### Expert Insight

#### Real-world Application
Branching statements are crucial in real-world scenarios like processing data streams or handling user inputs:
- **Break** in search algorithms: Exit early when a target is found to improve performance.
- **Continue** in validation: Skip invalid data entries in batch processing without halting the whole operation.
- **Return** in web services: Terminate API methods early for error handling or authentication failures, returning appropriate status codes.

```nginx
# Example: Break in error handling
while (processingData) {
    if (errorDetected) {
        break;  # Stop processing on error
    }
    processRecord();
}
# Continue in file parsing
foreach (line in file) {
    if (line.startsWith("#")) {
        continue;  # Skip comments
    }
    parseLine(line);
}
```

#### Expert Path
To master branching statements, follow these steps:
- Analyze brain teasers with loops and conditionals to understand control flow.
- Profile code performance; use break for efficiency in large datasets.
- Experiment with nested loops/switches to see how break/continue interact with scopes.
- Dive into JVM bytecode (e.g., via javap) to see how returns map to bytecode instructions like `areturn`.

#### Common Pitfalls
- **Infinite loops with continue**: If conditions aren't met, continue can cause endless execution—always increment variables in conditional loops.
- **Unintended unreachable code**: We see "URS?" in transcripts, but actually it's "unreachable statement"—correct spelling is key. Placing code after unconditional break/continue/return triggers this.
- **Return type mismatches**: Returning incompatible types (e.g., string from int method) causes compile errors—ensure type compatibility.
- **Misusing break in if-conditions**: Break terminated the enclosing loop, not the if-statement—always check nesting to avoid unexpected exits.
- **Lesser-known issue**: Compiler doesn't detect infinite loops via variables; use tools like debuggers or profilers from day one. Also, in Java, return in static/instance blocks throws errors—remember blocks aren't methods.
