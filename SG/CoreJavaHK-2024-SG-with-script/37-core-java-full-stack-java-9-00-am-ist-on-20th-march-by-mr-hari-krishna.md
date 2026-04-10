# Session 37: Java Operators

## Table of Contents
- [Logical Operators](#logical-operators)
- [Bitwise Operators](#bitwise-operators)
- [Operator Precedence](#operator-precedence)
- [Shift Operators](#shift-operators)
- [Ternary Operator](#ternary-operator)
- [Nested Ternary Operator](#nested-ternary-operator)
- [Summary](#summary)

## Logical Operators

### Overview
Logical operators are used to perform logical operations on boolean values, allowing for short-circuiting based on the truth value of operands. They are essential for conditional statements and validation in Java programming. The primary logical operators include NOT, AND, and OR.

### Key Concepts/Deep Dive
Logical operators can only be applied to boolean data types. Unlike bitwise operators, logical operators may not execute the second operand if not necessary (short-circuiting), which can improve performance.

- **NOT Operator (`!`)**: Unary operator that inverts a boolean value. For example, `!true` results in `false`, and `!false` results in `true`.
- **AND Operator (`&&`)**: Binary operator that returns `true` only if both operands are `true`. Uses short-circuit evaluation, meaning if the first operand is `false`, the second is not evaluated.
- **OR Operator (`||`)**: Binary operator that returns `true` if at least one operand is `true`. Also uses short-circuiting; if the first operand is `true`, the second is skipped.

Truth table for logical operators:

| A     | B     | A && B | A \|\| B | !A    |
|-------|-------|--------|----------|-------|
| true  | true  | true   | true     | false |
| true  | false | false  | true     | false |
| false | true  | false  | true     | true  |
| false | false | false  | false    | true  |

### Code/Config Blocks
```java
public class LogicalOpsDemo {
    public static void main(String[] args) {
        boolean a = true;
        boolean b = false;
        
        System.out.println("a && b: " + (a && b));  // false
        System.out.println("a || b: " + (a || b));  // true
        System.out.println("!a: " + (!a));          // false
        System.out.println("!b: " + (!b));          // true
    }
}
```

### Tables
Logical operators differ from bitwise operators as follows:

| Feature          | Logical Operators | Bitwise Operators |
|------------------|-------------------|-------------------|
| Operands        | Boolean           | Integers/Boolean  |
| Short-circuiting| Yes               | No                |
| Result Type     | Boolean           | Boolean/Integer   |
| Purpose         | Condition checks  | Bit manipulations|

> [!NOTE]
> Logical operators are commonly used in control flow statements like `if` conditions.

## Bitwise Operators

### Overview
Bitwise operators work directly on the binary representations of numbers, performing operations bit by bit. They are called "bitwise" because they manipulate individual bits (0s and 1s) using mathematical and logical operations. Useful for low-level programming, such as optimizing space or performing fast calculations.

### Key Concepts/Deep Dive
Bitwise operators convert operands to their binary form before operations. They always execute both operands, unlike logical operators. Applicable to `int`, `char`, `boolean`, but not to floating-point numbers, strings, or arrays.

Conversion from decimal to binary involves dividing by 2 repeatedly until the quotient is 1, then collecting remainders from bottom to top (with leading zeros for 4-bit minimum).

- **AND (`&`)**: Performs bitwise AND, resulting in 1 only where both bits are 1.
- **OR (`|`)**: Performs bitwise OR, resulting in 1 if either bit is 1.
- **XOR (`^`)**: Results in 1 if bits differ.
- **Complement (`~`)**: Unary operator that flips bits and adjusts sign/value.

Truth table for bitwise operators:

| A | B | A & B | A \| B | A ^ B | ~A    |
|---|----|-------|--------|-------|-------|
| 0 | 0 | 0     | 0      | 0     | 1     |
| 0 | 1 | 0     | 1      | 1     | N/A   |
| 1 | 0 | 0     | 1      | 1     | N/A   |
| 1 | 1 | 1     | 1      | 0     | N/A   |

Complement formula: For positive `n`, result is `-(n+1)`; for negative `n`, result is `-(n-1)` after flipping.

### Code/Config Blocks
```java
public class BitwiseDemo {
    public static void main(String[] args) {
        int a = 5; // Binary: 101
        int b = 3; // Binary: 011
        
        System.out.println("a & b: " + (a & b));  // 1
        System.out.println("a | b: " + (a | b));  // 7
        System.out.println("a ^ b: " + (a ^ b));  // 6
        System.out.println("~a: " + (~a));       // -6
    }
}
```

### Lab Demos
**Demonstration: Converting Decimal to Binary**
1. Take decimal number, e.g., 5.
2. Divide by 2 repeatedly:
   - 5 / 2 = 2 remainder 1
   - 2 / 2 = 1 remainder 0
   - Stop (quotient 1), collect from bottom: 1 0 1
3. Pad to 4 bits: 0101

**Calculate 5 & 6:**
- 5 in binary: 0101
- 6 in binary: 0110
- Bitwise AND: 0100 (decimal: 4)

## Operator Precedence

### Overview
Operator precedence determines the order of evaluation in expressions. Higher precedence operators execute first. Bitwise operators generally have lower priority than arithmetic but higher than logical, except for bitwise complement (highest among bitwise).

### Key Concepts/Deep Dive
Precedence order for bitwise:
- Bitwise complement (~)
- Shift operators
- Relational/logical before arithmetic
- Arithmetic (multiplicative > additive)
- Bitwise (AND, XOR, OR)
- Logical operators last

Examples:
- `5 + 2 * 3 == 5 + (2 * 3)` due to `*` precedence.
- Bitwise executes after arithmetic but before logical.

### Code/Config Blocks
```java
public class PrecedenceDemo {
    public static void main(String[] args) {
        int result1 = 5 + 2 * 3;  // 11 (multiplication first)
        boolean result2 = 5 == 7 && true;  // false (== before &&, short-circuit)
        System.out.println("Precedence example: " + result1);
    }
}
```

> [!IMPORTANT]
> Always use parentheses for clarity if precedence is unclear.

## Shift Operators

### Overview
Shift operators move bits left or right in a number's binary representation. Used for efficient multiplication/division or bit manipulation.

### Key Concepts/Deep Dive
- **Left Shift (`<<`)**: Moves bits left, fills right with zeros. Equivalent to multiplication by 2^n.
- **Right Shift (`>>`)**: Moves bits right, preserves sign bit (arithmetic right shift).
- **Unsigned Right Shift (`>>>`)**: Moves right, fills left with zeros (logical).

Assignment: Research and practice left shift, right shift, and unsigned right shift using online resources or by writing code.

## Ternary Operator

### Overview
The ternary operator (`? :`) is a shortcut for simple if-else statements, working with three operands. It evaluates a condition and returns one of two expressions based on the boolean result.

### Key Concepts/Deep Dive
Syntax: `booleanExpression ? expression1 : expression2`
- If `booleanExpression` is `true`, `expression1` executes; else `expression2`.
- Can return values or print directly; variable type must match operand types.

Used for concise conditional assignments.

### Code/Config Blocks
```java
public class TernaryDemo {
    public static void main(String[] args) {
        int num = 10;
        String result = (num % 2 == 0) ? "even" : "odd";
        System.out.println(num + " is " + result);
        
        // Equivalent if-else
        if (num % 2 == 0) {
            System.out.println(num + " is even");
        } else {
            System.out.println(num + " is odd");
        }
    }
}
```

## Nested Ternary Operator

### Overview
Ternary operators can be nested within one another for more complex conditions. Care must be taken with parentheses to avoid syntax errors.

### Key Concepts/Deep Dive
Nesting allows conditional logic within expressions. Ensure proper pairing of `?` and `:`.

Example: `(condition1) ? (condition2 ? expr1 : expr2) : expr3`

### Code/Config Blocks
```java
public class NestedTernaryDemo {
    public static void main(String[] args) {
        int score = 85;
        String grade = (score >= 90) ? "A" : 
                      ((score >= 80) ? "B" : 
                      ((score >= 70) ? "C" : "Fail"));
        System.out.println("Grade: " + grade);
    }
}
```

### Lab Demos
**Example Outputs to Identify Errors**
Assignment: Write and test nested ternary statements. Identify compile-time errors and expected outputs.

## Summary

### Key Takeaways
+ Logical operators enable boolean evaluations with short-circuiting for efficiency in control flow.
- Bitwise operators manipulate binary representations, requiring decimal-to-binary conversions like dividing by 2 repeatedly, collecting remainders bottom-to-top.
! Unlike logical operators, bitwise always execute both operands for precise bit calculations.
+ Ternary operators simplify if-else with a compact syntax, nesting possible but error-prone if unmatched.
+ Operator precedence follows arithmetic > bitwise > relational > logical for safe expression evaluation.
! Double and (`&&`) and double OR (`||`) are logical; single and/OR (`&|`) are bitwise for different data types.

### Expert Insight

#### Real-World Application
In production code, bitwise operators optimize memory usage in embedded systems or graphics libraries for pixel manipulations. Logical operators are crucial in user validation, e.g., checking multiple conditions in authentication. Ternary operators enhance readability in reactive programming, like UI updates based on state.

#### Expert Path
Master bitwise with practice on HackerRank or LeetCode problems. Focus on debugging nested ternary with unit tests. Compare performances: use logical operators for flags, bitwise for encryption algorithms.

#### Common Pitfalls
Avoid applying bitwise to floats/strings—compilation errors occur. Over-reliant on logical short-circuiting can hide bugs if second operand has side effects. Unmatched parentheses in nested ternary cause syntax errors; test iteratively.

#### Common Issues and Resolutions
- **Bitwise on Booleans**: Results differ from logical; e.g., `true & false` is `false` (boolean), but explicit checks needed.
- **Precedence Confusion**: Use parentheses; `5 + 3 == 8 ? "yes" : "no"` evaluates incorrectly without them.
- **Nested Ternary Errors**: Trace `? :` pairs; "missing colon" signals unmatched nests.
- **Performance**: Logical skips evaluation; bitwise ensures full execution, ideal for constants.

#### Lesser Known Things
Bitwise odd-even check: `num & 1` for quick parity without modulo. Complement flips bits for two's complement representation. Ternary in streams: `Optional.ofNullable(value).map(v -> v > 5 ? "high" : "low").orElse("none")` for fluent conditionals. Shift operators can overflow silently—monitor for large integers.
