# Session 29: Reading Runtime Values and Java Operators

## Table of Contents
- [Overview](#overview)
- [Reading Runtime Values](#reading-runtime-values)
- [Project on Previous Six Chapters](#project-on-previous-six-chapters)
- [Revision Advice](#revision-advice)
- [Java Operators Overview](#java-operators-overview)
- [Need of Chapter 7](#need-of-chapter-7)
- [Key Concepts in Operators](#key-concepts-in-operators)
- [Types of Operators](#types-of-operators)
- [List of Operators](#list-of-operators)
- [Sample Programs and Interview Questions](#sample-programs-and-interview-questions)
- [Summary](#summary)

## Overview
This session covers two main topics from Core Java & Full Stack Java training. First, it revisits and deepens understanding of reading runtime values from the keyboard, building on previous chapters. This includes exploring 10 different approaches for reading values, converting string inputs to primitive types, and comparing methods like command-line arguments, buffered reader, and scanner. Second, it introduces Chapter 7: Java Operators, explaining why they are essential for performing validations and calculations in programs. The chapter covers operator definitions, operands, expressions, types based on functionality and operands, all 40 operators with their groups, precedence, associativity, and practical applications through sample programs.

## Reading Runtime Values
### Overview
This section explains reading values at runtime (program execution time) instead of using hardcoded values, which ensures programs remain dynamic. Values are read from the console, files, or command lines.

### Key Concepts/Deep Dive
#### Hardcoded Values and Problems
- **Hardcoded Application**: Programs with fixed values (e.g., `result = 30` always output 30). Problems include:
  - Repetitive output (e.g., always "Student HK").
  - Not user-interactive; inflexible for changing inputs.
- **Solution**: Runtime values read dynamically from the end user.

#### Runtime Values
- **Definition**: Value read at program execution time.
- **Advantages**: Makes applications interactive, adaptable, and user-customizable without code changes.
- **Approaches**: Java provides 10 different approaches to read values from the keyboard.

#### Reading Values from Keyboard
- **Process Steps**:
  1. Connect to keyboard.
  2. Read values as strings (keyboard input is always string type).
  3. Convert strings to required types using wrapper classes.
- **Why String as Default**: Strings can represent all data types uniformly without changing original types.
- **Conversion Methods**: Use wrapper classes (e.g., `Integer.parseInt()` for int, `Double.parseDouble()` for double). Exceptions like `NumberFormatException` occur on invalid conversions.
- **Reading Characters**: Use `String.charAt(0)` after reading line, since no direct `parseChar()`.

#### 10 Approaches to Read Values
The instructor mentions 10 ways but details 3 major ones in the transcript.

1. **Command-Line Arguments**:
   - **Definition**: Values passed via terminal (e.g., `java MyClass arg1 arg2`).
   - **Process**:
     - Accessed as string array `String[] args` in `main` method.
     - Values are strings, so convert using wrapper classes (e.g., `int a = Integer.parseInt(args[0]);`).
     - Programmer handles conversion; no compiler error for direct assignment.
     - Flow: Command line → JVM → `main()` method → `args` array.
   - **Diagram/Explanation**: Command-line calls like `java Hello 10 20 HK` pass arguments as strings. Pass multiple types but convert manually.
   - **Problems**: Limited to command-line execution; no interactive input during runtime.
   - **Code Example**:
     ```java
     public class CommandLineArgsDemo {
         public static void main(String[] args) {
             int a = Integer.parseInt(args[0]);
             int b = Integer.parseInt(args[1]);
             String name = args[2];
             System.out.println(a + b + " " + name);
         }
     }
     ```
   - **Execution**: `java CommandLineArgsDemo 10 20 HK`

2. **Buffered Reader**:
   - **Why Buffered Reader?**: Solves command-line arguments' limitations for interactive input.
   - **Process**:
     - Use `BufferedReader br = new BufferedReader(new InputStreamReader(System.in));`.
     - Read lines: `String input = br.readLine();`.
     - Close resource with `br.close();`.
     - Convert strings as needed.
   - **Differences from Command-Line Arguments**:
     | Aspect | Command-Line Arguments | Buffered Reader |
     |--------|-------------------------|-----------------|
     | Input Source | Terminal arguments | Standard input (keyboard) |
     | Interactivity | Static | Dynamic, interactive |
     | Conversion | Manual parsing required | Manual parsing required |
     | Exception Handling | None for args array access | IOException for input |
   - **Advantage**: Allows runtime input in console applications.
   - **Code Example**:
     ```java
     import java.io.*;
     public class BufferedReaderDemo {
         public static void main(String[] args) throws IOException {
             BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
             System.out.println("Enter number:");
             int a = Integer.parseInt(br.readLine());
             System.out.println("Enter name:");
             String name = br.readLine();
             br.close();
             System.out.println("Number: " + a + ", Name: " + name);
         }
     }
     ```
   - **Problems**: Lengthy code; requires try-catch or throws.

3. **Scanner**:
   - **Why Scanner?**: Simplifies input; prebuilt methods for different types.
   - **Features**:
     - Automatically scans and parses types.
     - Methods: `nextByte()`, `nextShort()`, `nextInt()`, `nextLong()`, `nextFloat()`, `nextDouble()`, `next()` for string, `nextLine()` for full line.
     - `next()` reads one word; `nextLine()` reads until newline.
      - No direct `nextChar()`; use `next().charAt(0)`.
   - **Scanner Object Creation**: `Scanner sc = new Scanner(System.in);`.
   - **Key Behavior**:
     - Program pauses if data not available in buffer.
     - `nextLine()` consumes newline characters; avoid mixing `next()` and `nextLine()` incorrectly.
     - Example: After `int num = sc.nextInt();`, `nextLine()` reads remaining newline; call extra `nextLine()` if needed.
   - **Code Example**:
     ```java
     import java.util.Scanner;
     public class ScannerDemo {
         public static void main(String[] args) {
             Scanner sc = new Scanner(System.in);
             System.out.println("Enter number and name:");
             int num = sc.nextInt();
             String name = sc.nextLine(); // May not pause if newline leftover
             System.out.println("Number: " + num + ", Name: " + name);
             sc.close();
         }
     }
     ```
   - **Issue with `nextLine()`**: After primitive reads, newline remains; affects subsequent reads.

#### Small Realtime Project
- **Objective**: Read values from keyboard and store in `Student` object.
- **Steps**:
  1. Create `Student.java` with variables.
  2. Use scanner to read inputs.
  3. Validate and assign values.
  4. Print details.

#### Storing Values in Objects
- After reading strings, convert and assign to object fields.
- Wrap in try-catch for exceptions.

## Project on Previous Six Chapters
### Overview
Recap of building a complete application using Chapters 1-6.

### Key Concepts/Deep Dive
#### Chapters Covered
- **Chapter 1**: Data Types
- **Chapter 2**: Variables
- **Chapter 3**: User-Defined Data Types
- **Chapter 4**: Classes
- **Chapter 5**: Objects
- **Chapter 6**: Reading Runtime Values

#### Project Structure
- **Main Class**: `Student.java`
- **Features**: Create student object, read inputs, store, validate, display.
- **Memory Diagram**: End-to-end flow from input to output.

#### Lab Demo
- Create scanner object and user-defined class.
- Read values and handle conversions.
- Execute and verify output.

## Revision Advice
- Review Chapters 1-7 before next class.
- Practice examples to avoid forgetting concepts.

## Java Operators Overview

## Need of Chapter 7
- **Purpose**: Learn operators for validations (e.g., comparisons) and calculations (e.g., arithmetic) in logic development.
- **Context**: Building on storing values, now perform checks and computations.
- **Four Activities in Logic**: Reading/storing → Validations/calculations → Flow control → Exception handling.

> [!NOTE]
> Operators enable dynamic program behavior by evaluating conditions and performing math.

## Key Concepts in Operators
### Definitions
- **Operator**: Symbol or word performing one operation (e.g., validation, calculation, assignment). Examples: `+`, `-`, `new`, `instanceof`.
- **Operand**: Value or variable passed as input to an operator (e.g., variables, literals, method calls).
- **Expression**: Combination of operators and operands performing one operation. Examples: `a > 0`, `a + 10`.

### Uses
- **Operator**: Executes validation, calculation, or assignment.
- **Operand**: Provides inputs for operator execution.
- **Expression**: Handles entire operations like assignments, validations, or calculations.

### Operands Can Be
- Variables
- Literals
- Method calls
- Objects (for `instanceof`)

## Types of Operators
### Based on Functionality
- **Assignment**: One operator (`=`) for storing values.
- **Validation**: Check conditions (e.g., relational, logical).
- **Calculation**: Perform computations (e.g., arithmetic).

### Based on Operands
- **Unary**: One operand (e.g., `++`, `--`).
- **Binary**: Two operands (e.g., `+`, `>`).
- **Ternary**: Three operands (e.g., `? :`).

### Java 8 Operators
- **Lambda**: `->` for anonymous functions combining assignments, validations, calculations.

## List of Operators
Java supports 40 operators:
- **Assignment**: 1 (`=`)
- **Arithmetic**: 5 (`+`, `-`, `*`, `/`, `%`)
- **Increment/Decrement**: 2 (`++`, `--`)
- **Relational**: 5 (`<`, `>`, `<=`, `>=`, `instanceof`)
- **Equality**: 2 (`==`, `!=`)
- **Logical**: 3 (`&&`, `||`, `!`)
- **Bitwise**: 4 (`&`, `|`, `^`, `~`)
- **Shift**: 3 (`<<`, `>>`, `>>>`)
- **Compound Assignment**: 11 (`+=`, `-=`, `*=`, `/=`, `%=`, `&=`, `|=`, `^=`, `<<=`, `>>=`, `>>>=`)
- **Object Creation**: 1 (`new`)
- **Ternary**: 2 (`?`, `:`)
- **Lambda**: 1 (`->`)

## Sample Programs and Interview Questions
- Add positives using validation and calculation operators.
- Use `-1` for negatives in logic.
- Precedence/associativity table for complex expressions.
- OCP/OCA questions on operator behavior.

## Summary
### Key Takeaways
```diff
+ Operators enable dynamic logic: assignment for storage, calculations for computations, validations for checks
+ Runtime values make apps interactive; use Scanner for simplicity
+ Java has 40 operators grouped by functionality (assignment/validation/calculation) and operands (unary/binary/ternary)
+ Expressions combine operators/operands for operations; lambda combines all in functions
- Hardcoded values lead to inflexible code; always prefer runtime inputs
- Scanner issues with nextLine() after primitives; handle newlines explicitly
! Mixing next() and nextLine() causes bugs; buffer management is crucial
```

### Expert Insight
#### Real-world Application
In web apps or console tools, operators validate user inputs (e.g., age > 0) and calculate metrics (e.g., total price). Runtime reading powers forms, configs, and CLI tools for dynamic behavior.

#### Expert Path
Master precedence rules for expressions; practice bitwise for low-level ops; use compound assignments for concise code. Deep-dive into lambda for functional programming transitions.

#### Common Pitfalls
- Confusion between `==` (comparison) and `=` (assignment); causes logic errors.
- Buffer leftovers in Scanner skip inputs; clear buffer with `nextLine()`.
- Invalid conversions throw `NumberFormatException`; wrap in try-catch.
- Lesser known: Bitwise ops also validate binary flags; `~x` is not `!x` for signed ints.
- Expression evaluation left-to-right; use parentheses for clarity.
