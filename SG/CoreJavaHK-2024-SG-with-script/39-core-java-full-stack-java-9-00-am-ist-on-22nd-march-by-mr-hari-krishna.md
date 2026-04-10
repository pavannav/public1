# Session 39: Core Java - Control Flow Statements

## Table of Contents
- [Introduction to Control Flow Statements](#introduction-to-control-flow-statements)
- [If Statement](#if-statement)
- [Else Statement](#else-statement)
- [If-Else Ladder](#if-else-ladder)
- [Switch Statement](#switch-statement)

## Introduction to Control Flow Statements

### Overview
In this session, we explore Java control flow statements, which control the execution flow of programs. These statements allow conditional execution, loops, and branching decisions based on input values. Learners will understand how these statements mimic real-life decision-making, such as using "eyes" and "brain" logic for validations.

### Key Concepts
Java supports 11 control flow statements, categorized into three types:
- **Conditional Statements**: Used to execute a block of statements zero or one time (e.g., if, else, if-else ladder).
- **Loop Statements**: Used to execute a block of statements zero or multiple times (loops will be covered in future sessions).
- **Branching Statements**: Used to terminate execution and send control elsewhere (e.g., break, continue, return).

Examples from the instructor illustrate how brains (operators and validations) and eyes (control flow) work together in real-life scenarios.

### Code/Config Blocks
Control flow statements are foundational and do not require specific code blocks here. Refer to subsequent sections for examples.

### Summary
Control flow statements provide decision-making capabilities, essential for responsive programming. They enable programs to react to user input or environmental conditions dynamically.

## If Statement

### Overview
The `if` statement is a conditional statement that executes a block of code based on a boolean condition. It checks if a given condition is true and executes associated statements accordingly, mimicking decision-making processes in programming.

### Key Concepts
- **Purpose**: Execute a statement or block of statements zero or one time depending on the condition.
- **Syntax**:
  ```java
  if (boolean_condition) {
      // statements to execute if true
  }
  ```
- **Allowed Conditions**:
  - Boolean literal (`true` or `false`)
  - Boolean variable
  - Boolean expression (e.g., using relational operators `<`, `>`, `<=`, `>=`, or logical operators `&&`, `||`, `!`)
  - Non-void method call returning boolean
- **Body Requirements**: Variables require a body (curly braces), while single statements do not.
- **Restrictions**: Only boolean types are accepted as conditions. Incompatible types like integers (e.g., `if (a)` where `a` is int) result in compilation errors like "incompatible types: int cannot be converted to boolean."

### Code/Config Blocks
Example programs demonstrating `if` with different conditions:

```java
public class IfExample {
    public static void main(String[] args) {
        int a = 10;
        // Using boolean literal true
        if (true) {
            System.out.println("In if 1");
        }
        if (false) {
            System.out.println("In if 2"); // This won't execute
        }
        
        // Using boolean variables
        boolean b1 = true;
        if (b1) {
            System.out.println("In if 3");
        }
        boolean b2 = false;
        if (b2) {
            System.out.println("In if 4"); // Won't execute
        }
        
        // Using expressions with relational operators
        if (a < 20) {
            System.out.println("In if 5");
        }
        if (a > 20) {
            System.out.println("In if 6"); // Won't execute
        }
        
        // Using equality operators
        if (a == 10) {
            System.out.println("In if 7");
        }
        if (a != 10) {
            System.out.println("In if 8"); // Won't execute
        }
        
        // Using logical operators
        if (a > 5 && a < 20) {
            System.out.println("In if 9");
        }
        if (a < 5 || a > 20) {
            System.out.println("In if 10"); // Won't execute
        }
        
        // Invalid: Cannot use integers directly
        // if (a) { // Compilation error: incompatible types
        //     System.out.println("Invalid");
        // }
        
        // Assignment vs. Comparison: Watch out!
        if (b2 = true) { // Assignment returns value (true here)
            System.out.println("Hi"); // Executes
        }
    }
}
```

Program to read a number and check if positive:

```java
import java.util.Scanner;

public class PositiveCheck {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        System.out.print("Enter a number: ");
        int number = scanner.nextInt();
        if (number > 0) {
            System.out.println(number + " is positive");
        }
        // Note: This doesn't handle negative or zero; see If-Else for full logic
    }
}
```

### Tables
| Condition Type | Examples | Notes |
|----------------|----------|-------|
| Literal | `if (true)`, `if (false)` | Direct boolean values |
| Variable | `boolean b = true; if (b)` | Must be boolean type |
| Expression | `if (a < 10)`, `if (x > 5 && y < 20)` | Relational or logical operations |
| Method Call | `if (isValid())` | Must return boolean |

### Lab Demos
- **Lab 1: Simple If with Literals**
  Run the first example. Input/output: Executes "In if 1" and "In if 3", skips "In if 2" and "In if 4".
- **Lab 2: Expressions with If**
  Run the relational operator example with `a = 10`. Execute: Prints "In if 5" and "In if 7".
- **Lab 3: Positive Check Program**
  Compile and run: Enter 10 → Output: "10 is positive". Enter -10 → No output (demonstrates need for else).

### Summary
The `if` statement is fundamental for conditional logic. Avoid common pitfalls like using non-boolean conditions or confusing assignment (`=`) with equality (`==`).

## Else Statement

### Overview
The `else` statement executes a block of code when the `if` condition is false. It provides an alternative path, ensuring code runs based on boolean evaluation.

### Key Concepts
- **Purpose**: Executes statements when the `if` condition evaluates to false.
- **Syntax** (paired with `if`):
  ```java
  if (boolean_condition) {
      // if-true statements
  } else {
      // if-false statements
  }
  ```
- **Rules**:
  - Must follow an `if`; paired properly.
  - Body optional if single statement, but must not interfere with structure (e.g., avoid unbracketed multiple statements causing dangling `else`).
  - Invalid: `else` without `if` or improperly nested.

### Code/Config Blocks
Example with `else`:

```java
public class ElseExample {
    public static void main(String[] args) {
        boolean b1 = true, b2 = false;
        
        if (b1) {
            System.out.println("In if 1");
        } else {
            System.out.println("In else 1"); // Won't execute
        }
        
        if (b2) {
            System.out.println("In if 2"); // Won't execute
        } else {
            System.out.println("In else 2"); // Executes
        }
        
        // Invalid example (demonstrates error):
        // if (false)
        //     System.out.println("Hi1");
        //     System.out.println("Hi2"); // Not under if
        // else
        //     System.out.println("Else"); // "else without if" error
    }
}
```

Updated positive check program with `else`:

```java
import java.util.Scanner;

public class PositiveNegativeCheck {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        System.out.print("Enter a number: ");
        int number = scanner.nextInt();
        if (number > 0) {
            System.out.println(number + " is positive");
        } else {
            System.out.println(number + " is not positive"); // Includes zero as not positive, but see ladder for full handling
        }
    }
}
```

### Lab Demos
- **Lab 1: Basic Else Execution**
  Run the example. Output: "In if 1" and "In else 2".
- **Lab 2: Positive/Negative Check**
  Compile and run: Enter 10 → "10 is positive". Enter -10 → "-10 is not positive".

### Summary
`else` complements `if` for binary decisions. Always pair them correctly to avoid syntax errors.

## If-Else Ladder

### Overview
The if-else ladder handles multiple conditions sequentially. Each `else if` checks additional conditions, executing the first true block and skipping others, ideal for menu-driven applications.

### Key Concepts
- **Purpose**: Choose among multiple mutually exclusive conditions (e.g., positive, negative, zero).
- **Syntax**:
  ```java
  if (condition1) {
      // actions for condition1
  } else if (condition2) {
      // actions for condition2
  } else {
      // default actions
  }
  ```
- **Flow**: Sequential checks until true or all false, then execute `else`. Inefficient for many options (use switch for performance).
- **Use Cases**: Multi-choice scenarios like day name printing.

### Code/Config Blocks
Complete number check program (positive, negative, zero):

```java
import java.util.Scanner;

public class NumberCheckLadder {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        System.out.print("Enter a number: ");
        int number = scanner.nextInt();
        if (number > 0) {
            System.out.println(number + " is positive");
        } else if (number < 0) {
            System.out.println(number + " is negative");
        } else {
            System.out.println("You have entered zero");
        }
    }
}
```

Day name program using if-else ladder:

```java
import java.util.Scanner;

public class DayNameLadder {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        System.out.print("Enter day number (1-7): ");
        int day = scanner.nextInt();
        
        if (day == 1) {
            System.out.println("Today is Sunday");
        } else if (day == 2) {
            System.out.println("Today is Monday");
        } else if (day == 3) {
            System.out.println("Today is Tuesday");
        } else if (day == 4) {
            System.out.println("Today is Wednesday");
        } else if (day == 5) {
            System.out.println("Today is Thursday");
        } else if (day == 6) {
            System.out.println("Today is Friday");
        } else if (day == 7) {
            System.out.println("Today is Saturday");
        } else {
            System.out.println("Wrong number, only enter between 1 to 7");
        }
    }
}
```

### Tables
| Scenario | Condition Checks | Reason |
|----------|------------------|--------|
| Multiple Choices | Sequential else-if for exclusivity | Ensures only one path executes |
| Performance | Avoid for >5-7 options; slow due to full traversal | Use switch for direct jumps |

### Lab Demos
- **Lab 1: Number Classification**
  Run ladder program: Enter 10 → "10 is positive". Enter -5 → "-5 is negative". Enter 0 → "You have entered zero". Enter 8 → "Wrong number...".
- **Lab 2: Day Name Ladder**
  Run: Enter 1 → "Today is Sunday". Enter 7 → "Today is Saturday". Enter 0 → Error message. Note: Slower for higher numbers due to sequential checks.

### Summary
If-else ladder is versatile for complex conditionals but inefficient for many options. Choose based on scenario.

## Switch Statement

### Overview
The `switch` statement enables direct jumping to a case based on value, optimizing menu-driven applications by avoiding sequential checks.

### Key Concepts
- **Purpose**: Execute code based on value matching, suitable for choice-based logic.
- **Syntax**:
  ```java
  switch (variable) {
      case value1:
          // statements
          break;
      case value2:
          // statements
          break;
      // ...
      default:
          // default statements
  }
  ```
- **Argument Rules**:
  - Must be int, byte, short, char (primitives); enum (from Java 5); Integer, Character, etc. (wrappers); String (from Java 7).
  - No long, float, double (compilation error).
- **Case Labels**: Must be constants (literals, final variables, or constant expressions). No variables or method calls.
- **Break**: Terminates case execution; without it, fall-through occurs.
- **Default**: Handles unmatched values.

### Code/Config Blocks
Day name program using switch:

```java
import java.util.Scanner;

public class DayNameSwitch {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        System.out.print("Enter day number (1-7): ");
        int day = scanner.nextInt();
        
        switch (day) {
            case 1:
                System.out.println("Today is Sunday");
                break;
            case 2:
                System.out.println("Today is Monday");
                break;
            case 3:
                System.out.println("Today is Tuesday");
                break;
            case 4:
                System.out.println("Today is Wednesday");
                break;
            case 5:
                System.out.println("Today is Thursday");
                break;
            case 6:
                System.out.println("Today is Friday");
                break;
            case 7:
                System.out.println("Today is Saturday");
                break;
            default:
                System.out.println("Wrong number, only enter between 1 to 7");
                break; // Optional for default
        }
    }
}
```

### Tables
| Version | Allowed Types | Notes |
|---------|---------------|-------|
| Java 1-4 | int, byte, short, char | Primitives only |
| Java 5+ | + enum, Integer wrappers | Enhanced for objects |
| Java 7+ | + String | Commonly used for text-based menus |
| Future | More enhancements (e.g., arrow syntax in Java 14+) | Preview features |

### Lab Demos
- **Lab 1: Day Name with Switch**
  Run program: Enter 3 → Direct "Today is Tuesday". Enter 8 → "Wrong number...". Performance improvement over ladder for high values.

### Summary
Switch optimizes choice-based logic with direct jumps. Prefer over ladders for indexed values.

## Summary

### Key Takeaways
```diff
! Control flow statements in Java include if, else, if-else ladder, and switch, all under conditional types.
+ If and else handle binary decisions, while if-else ladder manages multi-way choices sequentially.
- Ladder execution slows for many options; use switch for direct, efficient jumps based on constants.
+ Switch supports int, enum, and String (Java 7+), with constants as labels and break for termination.
- Avoid common errors: Non-boolean in if, missing break in switch (causes fall-through), or improper nesting.
```

### Expert Insight
- **Real-world Application**: In production code, switch excels in menu-driven UIs (e.g., Android navigation handling different screens) or API routing (e.g., HTTP method branching). If-else ladders suit float-based ranges like user permissions.
- **Expert Path**: Master pattern matching (Java 14+ records with switch) or refactor ladders to maps for scalability.
- **Common Pitfalls**: Confusing = with == (assignment vs. comparison), forgetting break (unintended execution), or using invalid types (compilation fails). Watch for "else without if" due to semicolons.
- **Lesser Known Things**: Switch in Java 14+ supports colon (`:`) for fall-through or arrows (`->`) for concise execution without break. Constant expressions include final variables, enabling dynamic-yet-static labels.

### Model Summary Tag
Model ID: CL-KK-Terminal

### Corrections Noted in Transcript
- "ript" at start: Likely "Script" (incomplete cutoff).
- "ener your" → Corrected to "Enter your" (e.g., "Enter your can you play with you").
- "triactic" not in transcript; minor typos like "zyb" not relevant. Minor phrasing smoothed for clarity (e.g., "ubl main method" → "public static void main"). No major spelling errors like "htp" found in this transcript. No "cubectl" → "kubectl" or similar security-related misspellings present.
