# Session 32: Arithmetic Operators

## Table of Contents

- [Overview](#overview)
- [Key Concepts/Deep Dive](#key-concepts-deep-dive)
  - [Plus Operator Usage](#plus-operator-usage)
  - [Type Promotion in Expressions](#type-promotion-in-expressions)
  - [Compile Time Errors with Incompatible Types](#compile-time-errors-with-incompatible-types)
  - [Arithmetic Operators on Non-Numeric Types](#arithmetic-operators-on-non-numeric-types)
  - [Operator Evaluation and Precedence](#operator-evaluation-and-precedence)
  - [Division Operator Special Rules](#division-operator-special-rules)
  - [Modulo Operator](#modulo-operator)
  - [Object and Array Printing](#object-and-array-printing)
- [Code Examples](#code-examples)
- [Lab Demos](#lab-demos)
- [Summary](#summary)

## Overview

This session continues the exploration of fundamental operators in Java, focusing on arithmetic operators. We build on previous knowledge of assignment operators and dive deep into how +, -, *, /, and % behave with different data types, including rules for type promotion, precedence, and special cases like division by zero. The instructor emphasizes thinking like a compiler/JVM rather than just applying mathematical rules.

## Key Concepts/Deep Dive

### Plus Operator Usage

The `+` operator serves dual purposes based on operands:
- **Addition operator**: Used for numeric types (int, double, etc.) and char types
- **Concatenation operator**: Used when at least one operand is a String

Example behavior:
```java
int a = 10, b = 20;
System.out.println(a + b); // 30 (addition)
System.out.println("Hello" + a); // Hello10 (concatenation)
```

After a String appears in an expression, all subsequent `+` operations become concatenation.

### Type Promotion in Expressions

In arithmetic expressions:
- Lesser range data types are automatically promoted to the highest range type present
- Promotion order: `byte` → `short` → `int` → `long` → `float` → `double` (exception: `char` is treated as `int` in arithmetic)

Example:
```java
int a = 10;
double b = 5.7;
System.out.println(a + b); // Outputs 15.7 (a promoted to double)
```

### Compile Time Errors with Incompatible Types

Attempting arithmetic operations on incompatible types results in compilation errors:
- `bad operand types for binary operator`
- Examples:
  ```java
  // These will not compile
  System.out.println(20 + true); // Incompatible: boolean cannot promote to number
  System.out.println(new Object() + new Object()); // Objects cannot add
  System.out.println("array"[0] + new int[5]); // Arrays cannot add
  ```

### Arithmetic Operators on Non-Numeric Types

Arithmetic operators (`+`, `-`, `*`, `/`, `%`) cannot be applied to:
- `boolean` types
- Arrays
- Class objects

String concatenation is allowed only with `+` operator.

> [!IMPORTANT]
> Attempting these operations results in compile-time errors.

### Operator Evaluation and Precedence

**Evaluation Order:**
- Left to right associativity for all arithmetic operators

**Precedence Hierarchy:**
1. `*`, `/`, `%` (multiplication, division, modulo)
2. `+`, `-` (addition, subtraction)

Example evaluation:
```java
int result = 10 + 3 * 4 / 2 - 5;
// Steps: 3*4=12, 12/2=6, 10+6=16, 16-5=11
```

Override precedence using parentheses.

### Division Operator Special Rules

Three critical rules for division:

1. **Result Type**: Determined by operands (higher precision wins)
   - `int / int = int` (truncates decimal part)
   - `double / int = double`

2. **Division by Zero**:
   - Integer division by zero: `ArithmeticException` at runtime
   - Floating-point division by zero: Returns `Infinity` or `-Infinity`

3. **Zero divided by Zero**:
   - Integer: `ArithmeticException`
   - Floating-point: `NaN` (Not a Number)

```java
// Examples
System.out.println(22 / 7);     // 3 (int division)
System.out.println(22F / 7);    // 3.142857 (float)
System.out.println(2 / 0);      // ArithmeticException
System.out.println(2.0 / 0);    // Infinity
System.out.println(0.0 / 0.0);  // NaN
```

### Modulo Operator

Similar to division:
- Returns remainder of division
- Same type promotion and precedence rules as division
- Modulo by zero follows same rules (exception for integers, special values for floating-point)

### Object and Array Printing

Objects and arrays have string representations:
- Format: `ClassName@hashcode`
- Example:
  ```java
  Example obj = new Example();
  System.out.println(obj); // Example@1a2b3c
  int[] arr = new int[3];
  System.out.println(arr); // [I@4d5e6f
  ```

Concatenating objects/arrays with strings converts them to this format.

## Code Examples

```java
// Type promotion examples
int a = 20;
double b = 5.7;
System.out.println(a + b); // 25.7

// Incompatible types (will not compile)
// System.out.println(20 + true);

// String concatenation precedence
String s1 = "Hello";
int num = 10;
System.out.println(s1 + num * 2); // Hello20 (multiplication first)

// Division type effects
System.out.println(22 / 7);   // 3
System.out.println(22.0 / 7); // 3.142857142857143

// Division by zero
// System.out.println(10 / 0);    // ArithmeticException
System.out.println(10.0 / 0);   // Infinity

// Object to string
Object obj = new Object();
System.out.println("Object: " + obj); // Object: java.lang.Object@hashcode
```

## Lab Demos

### 1. Percentage Calculator (Hardcoded)

**Develop a program to find 20% of 500:**

```java
public class PercentageCalculator {
    public static void main(String[] args) {
        int number = 500;
        int percentage = 20;
        int result = number * percentage / 100;
        System.out.println(percentage + "% of " + number + " is " + result);
    }
}
```

**Output:** `20% of 500 is 100`

**Key Points:**
- Uses arithmetic operators with integer division
- Order of operations: multiplication before division due to same precedence
- No parentheses needed since `*` and `/` have same precedence

### 2. Dynamic Percentage Calculator (Reading from Keyboard)

**Modify the program to read values dynamically:**

```java
import java.util.Scanner;

public class DynamicPercentageCalculator {
    public static void main(String[] args) {
        Scanner s = new Scanner(System.in);
        
        System.out.print("Enter number: ");
        int number = s.nextInt();
        
        System.out.print("Enter percentage: ");
        int percentage = s.nextInt();
        
        int result = number * percentage / 100;
        System.out.println(percentage + "% of " + number + " is " + result);
        
        s.close();
    }
}
```

**Sample Input/Output:**
```
Enter number: 1000
Enter percentage: 100
100% of 1000 is 1000
```

### 3. Salary Increment Program

**Develop a program to increase employee salary by 20%:**

```java
public class SalaryIncrement {
    public static void main(String[] args) {
        double originalSalary = 10000;
        double incrementPercentage = 20;
        
        // Calculate increment amount
        double incrementAmount = originalSalary * incrementPercentage / 100;
        
        // Calculate new salary
        double newSalary = originalSalary + incrementAmount;
        
        System.out.println("Original Salary: " + originalSalary);
        System.out.println("Increment Amount (20%): " + incrementAmount);
        System.out.println("New Salary: " + newSalary);
    }
}
```

**Output:**
```
Original Salary: 10000.0
Increment Amount (20%): 2000.0
New Salary: 12000.0
```

## Summary

### Key Takeaways

```diff
+ Arithmetic operators (+, -, *, /, %) work primarily on primitive numeric types
+ Type promotion automatically converts lesser types to avoid data loss
+ String concatenation occurs when any operand is a String (after first String in expression)
+ Operator precedence: * / % > + -, evaluated left to right within same precedence
+ Division behaves differently than mathematics: result type matters
- Integer division by zero throws ArithmeticException (not infinity)
- Arithmetic operators cannot be applied to boolean, arrays, or objects
+ Parentheses override default precedence order
+ Think like JVM/compiler, not mathematician, for accurate predictions
```

### Expert Insight

#### Real-world Application
Arithmetic operators form the foundation of computational logic in Java applications. Understanding type promotion ensures accurate calculations in financial software, scientific computing, and game development. Division rules are crucial for implementing algorithms that handle edge cases like zero denominators in statistical analysis or geometric calculations.

#### Expert Path
Master these fundamentals by practicing type conversion scenarios and expression evaluations manually on paper before coding. Study JVM bytecode (`javap`) to understand implicit conversions. Progress to complex numeric libraries like `BigDecimal` for precision-critical applications.

#### Common Pitfalls
1. **Forgetting type promotion**: Byte/short operations result in int, not original type
2. **Integer vs floating-point division**: `5/2 = 2`, not 2.5; always cast or use floating-point
3. **NullPointerException with concatenation**: `String s = null; System.out.println(s + "text")` works, but avoid in practice  
4. **Division by zero assumptions**: Floating-point gives Infinity/NaN, not exception
5. **Operator precedence confusion**: BODMAS doesn't apply directly in Java due to precedence rules

Remember: Code compiles and runs following strict JVM rules, not mathematical intuition. Practice daily to build strong mental models. 

**Mistakes corrected in transcript:**
- "operin" corrected to "operand" (multiple instances)
- "arithmiec" corrected to "arithmetic" (in timestamp/line description)

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
