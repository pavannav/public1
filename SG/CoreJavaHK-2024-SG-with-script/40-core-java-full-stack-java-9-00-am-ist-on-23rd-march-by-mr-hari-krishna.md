# Session 40: Control Flow Statements - Switch with Strings, If/Switch Rules, and Loops

**Table of Contents**

- [Overview](#overview)
- [Switch Statements with Strings](#switch-statements-with-strings)
- [Reading Characters and Vowel/Consonant Check](#reading-characters-and-vowelconsonant-check)
- [If-Else Ladder Rules](#if-else-ladder-rules)
- [Switch Rules](#switch-rules)
- [Introduction to Loops](#introduction-to-loops)
- [While Loop](#while-loop)
- [Do-While Loop](#do-while-loop)
- [For Loop](#for-loop)
- [Summary](#summary)

## Overview

This session continues the discussion on control flow statements in Java, building upon previous classes. The instructor explains how switch statements work with strings (available since Java 7), demonstrates practical programs for reading input and validating characters, and provides detailed rules for if-else and switch constructs. The session marks a transition from basic control flow to object-oriented programming concepts starting Monday. Key emphasis is placed on why control flow statements are crucial foundations for Java development, particularly for logical programming, while noting that Java projects focus more on object-oriented principles.

## Switch Statements with Strings

### Key Concepts
- Strings are supported as arguments in switch statements starting from Java version 7.
- Switch labels must use literals that match the string values exactly.
- Case sensitivity matters; the input string should be converted to match the expected case.
- Use `toUpperCase()` or `toLowerCase()` methods from the String class to handle user case variations.
- Default case handles invalid inputs.

### Program: Read Week Day Name and Print Day Number

Develop a program to read a week day name from keyboard and print the corresponding day number. If an invalid name is provided, display "Wrong day name".

**Steps to implement:**
1. Import necessary packages if using Scanner: `import java.util.Scanner;`
2. Create a Scanner object: `Scanner sn = new Scanner(System.in);`
3. Declare variables:
   - `String dayName;`
   - `Scanner sn;`
4. Prompt the user: `System.out.print("Enter day name: ");`
5. Read the input as a whole line since day names may vary: `dayName = sn.next();` (but ensure case handling)
6. Convert to uppercase for consistent matching: `dayName = dayName.toUpperCase();`
7. Implement switch statement:
   ```java
   switch (dayName) {
       case "SUNDAY":
           System.out.println("Sunday is day 1");
           break;
       case "MONDAY":
           System.out.println("Monday is day 2");
           break;
       // Add other cases for TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY
       default:
           System.out.println("Wrong day name");
   }
   ```

### Lab Demo Steps
1. Write the class file with your name (e.g., `DayNameSwitcher.java`).
2. Compile using `javac DayNameSwitcher.java`.
3. Run with `java DayNameSwitcher`.
4. Test inputs:
   - "Sunday" → "Sunday is day 1"
   - "monday" → "Monday is day 2" (after case conversion)
   - "HK" → "Wrong day name"

### Key Points
- `break` is essential to prevent fall-through execution.
- Without `break`, subsequent cases execute even if they don't match.

## Reading Characters and Vowel/Consonant Check

### Key Concepts
- Reading characters from keyboard uses `Scanner.next().charAt(0)`.
- Vowels are: A, E, I, O, U (case-sensitive).
- Use `toLowerCase()` or `toUpperCase()` for case-insensitive checks, then compare against upper/lower case labels.
- For control flow, use either if-else or switch based on readability.

### Program: Read Character and Check if Vowel or Consonant

Write a program to read a character from keyboard and check if it's a vowel or consonant. Print appropriate message. Assume input is a letter; handle case insensitivity.

**Steps to implement:**
1. Import Scanner.
2. Create Scanner instance.
3. Declare `String letter`, `char ch`.
4. Read input: `letter = sn.next();`
5. Convert to lower case: `ch = letter.toLowerCase().charAt(0);`
6. Use switch:
   ```java
   switch (ch) {
       case 'a':
       case 'e':
       case 'i':
       case 'o':
       case 'u':
           System.out.println(letter + " is a vowel");
           break;
       default:
           if (Character.isLetter(ch)) {
               System.out.println(letter + " is a consonant");
           } else {
               // Handle digits/special chars if needed
           }
   }
   ```

### Lab Demo: Using Switch for Vowel Check
1. Create a file `VowelChecker.java`.
2. Compile and run.
3. Input "a" → "A is a vowel" (preserves original case in output).
4. Input "P" → "P is a consonant".

### Comparison: If-Else vs Switch
- For multiple conditions, switch is efficient for vowels.
- If-else is more flexible for complex logic.

## If-Else Ladder Rules

### Key Concepts
- If-else ladders evaluate conditions sequentially.
- Only one allowed argument: boolean type.
- Abort condition check when true is found.
- Nested ifs allowed for hierarchical checks.
- Short-circuiting: use logical operators correctly.

### Detailed Rules Document
> [!NOTE]
> Mandatory rules for if-else constructs:
> - Semicolon issues: Prevents execution of intended statements.
> - Boolean strictness: Only boolean allowed (no int, no 1/0).
> - Expression support: Variables, expressions, method calls.
> - Optional bodies: Can omit braces for single statements, but risky.
> - Empty ifs possible.
> - Nesting: Supports nested if-else for character classification.

### Examples
- Valid: `if (a == 10)`
- Invalid: `if (a = 10)`
- Short-circuit: `if (a > 5 && a < 10)`

> [!WARNING]
> Avoid deep nesting; affects readability.

## Switch Rules

### Key Concepts
- Switch accepts int, wrapper types, enum, String (since Java 7+).
- Invalid types: long, float, etc.
- Case values must be compile-time constants.
- Default optional, can be anywhere.
- Fall-through without `break`.
- No variable declarations in switch expression.

### Comprehensive Rules (26 Points)
1. Switch argument supports literals, variables, expressions, method calls.
2. Case labels: constants only.
3. No body allowed empty switch.
4. Statements under case/default required.
5. Break for flow control.
6. Default positioning flexible.
7. Duplicate cases not allowed (compile error).
8. Nesting supported.
9. Yield (Java 14+) for returning values.

### Common Patterns
```java
switch (x) {
    case 1: System.out.println("One"); break;
    case 2: System.out.println("Two"); break;
    default: System.out.println("Other");
}
```

> [!IMPORTANT]
> Switch is recommended for multiple discrete values over long if-else chains.

## Introduction to Loops

### Key Concepts
- Loops execute blocks repeatedly: 0, 1, or n times.
- Java supports: while, do-while, for (including enhanced for-each).
- While/do-while: condition-based.
- For: range-based.
- Avoid infinite loops by ensuring termination.

### Loop Types Overview
- **While**: Entry-controlled (0+ executions).
- **Do-While**: Exit-controlled (1+ executions).
- **For**: Structured, all control in header.

## While Loop

### Key Concepts
- Checks condition before execution.
- Risk of infinite loops if increment forgotten.
- Variable management scattered.

### Syntax
```java
while (boolean_condition) {
    // statements
    // increment/decrement
}
```

### Lab Demo: Print Name 5 Times
1. Declare `int a = 1;`
2. While loop: `while (a <= 5)` 
3. Inside: `System.out.println("Hurry"); a++;`
4. Output: Prints "Hurry" 5 times.

### Flow Explanation
- Start: a=1
- Check: 1 <= 5 (true)
- Execute: print, a=2
- Iterate back, repeat until a=6 (false)

### Problems
- Logic executes only if condition true initially.
- Variables spread: declaration, condition, increment.

## Do-While Loop

### Key Concepts
- Executes block first, then checks condition.
- Guaranteed at least one execution.
- Semicolon mandatory after while.

### Syntax
```java
do {
    // statements
    // increment/decrement
} while (boolean_condition);
```

### Lab Demo: Same Program
- Output: "Hurry" printed 6 times (initial + 5 iterations) if increment inside, but corrected to 5.

### Analogy
- Bar visit: Enter first, then decide to continue drinking.
- Opposite of classroom entry (checked first).

## For Loop

### Key Concepts
- All loop control in header: initialization, condition, increment.
- Prevents common mistakes.
- Preferred for range-based iterations.
- Enhanced for-each for collections.

### Syntax
```java
for (initialization; condition; increment) {
    // statements
}
```

### Problems Solved
- Single location for all loop mechanics.
- Compiler enforces structure.

### Lab Demo: Rewrite Using For
```java
for (int a = 1; a <= 5; a++) {
    System.out.println("Hurry");
}
```
- Output: "Hurry" x5.

### When to Use
- **While**: Variable-based condition, you manage increment.
- **Do-While**: Must execute at least once.
- **For**: Known iterations, range-based.

## Summary

### Key Takeaways
```diff
+ Switch with strings requires case conversion (toUpperCase/toLowerCase).
- Without break in switch, fall-through occurs, executing all cases.
+ Loops: while (0+), do-while (1+), for (structured).
- Infinite loops common if increment forgotten in while/do-while.
+ If-else: strict boolean, support expressions.
- Deep nesting in if-else harms readability; prefer switch.
+ For loops consolidate initialization, condition, increment.
- No break in do-while semicolon leads to syntax errors.
```

### Expert Insight
#### Real-world Application
Control flow statements form the backbone of Java logic. In production, switch is used for state machines (e.g., HTTP status codes), while loops for polling operations (e.g., checking database connections), and do-while for validation retries. Proper case handling prevents user input errors in web forms.

#### Expert Path
Master by practicing pattern printing and sorting algorithms. Study Java compiler optimizations for loops. Use tools like SonarQube to detect loop pitfalls.

#### Common Pitfalls
- Infinite loops due to missed increment; always add logging or counters.
- Switch fall-through: explicit break prevents unexpected behavior.
- Ignoring case sensitivity: always normalize strings.
- Deeply nested ifs: refactor to methods or use polymorphism in OOP.

#### Lesser Known Things
- Java's for-each loop optimizes iteration for collections, avoiding index errors.
- Switch expressions (Java 14+) can return values without fall-throughfuss.
- While loops can model event-driven systems, but for is preferred for performance in tight loops.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
