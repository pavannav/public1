# Section 117: Arithmetic Operations in Shell Scripts

<details open>
<summary><b>Section 117: Arithmetic Operations in Shell Scripts (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Introduction](#introduction)
- [Basic Arithmetic Operations in Bash](#basic-arithmetic-operations-in-bash)
- [Performing Operations with Echo Command](#performing-operations-with-echo-command)
- [Taking User Input for Calculations](#taking-user-input-for-calculations)
- [Writing a Script for Multiple Arithmetic Operations](#writing-a-script-for-multiple-arithmetic-operations)
- [Different Methods for Arithmetic Operations](#different-methods-for-arithmetic-operations)
- [Limitations and Notes](#limitations-and-notes)
- [Demonstration](#demonstration)

## Introduction

This chapter covers performing mathematical calculations within bash shell scripts. The instructor explains how to use arithmetic operators for operations with integers, including addition, subtraction, multiplication, division, and modulus. The session emphasizes using bash expressions for calculations and demonstrates script examples.

## Basic Arithmetic Operations in Bash

Bash supports arithmetic operations using specific syntax. Key concepts include:
- Operators: `+` (addition), `-` (subtraction), `*` (multiplication), `/` (division), `%` (modulus)
- Variables are used to store numbers and expressions
- Arithmetic expressions must be properly enclosed to evaluate correctly

Example operators:
- Addition: `10 + 5` = 15
- Subtraction: `10 - 5` = 5
- Multiplication: `10 * 5` = 50
- Division: `10 / 5` = 2 (integer division)
- Modulus: `10 % 3` = 1 (remainder)

## Performing Operations with Echo Command

To print the result of an arithmetic operation, use the `echo` command with proper expression syntax. Direct use of operators without evaluation will not compute the result.

### Incorrect Ways:
- `echo 2 + 3` → Prints "2 + 3", not "5"
- Using single quotes or improper enclosing fails

### Correct Method:
Use double quotes and double parentheses: `echo "Result: $((expression))"`

Example:
```bash
echo "Sum: $((10 + 5))"  # Outputs: Sum: 15
echo "Difference: $((10 - 5))"  # Outputs: Difference: 5
```

## Taking User Input for Calculations

To make scripts interactive, use the `read` command to accept user input:
- Use `-p` flag for prompt on the same line
- Store inputs in variables

Example:
```bash
read -p "Please enter the first number: " num1
read -p "Please enter the second number: " num2
```

This reads integers from user input and stores them in `num1` and `num2` variables.

## Writing a Script for Multiple Arithmetic Operations

Combine user input with arithmetic expressions to create a comprehensive calculator script. The script should:
1. Prompt for two numbers
2. Perform various operations
3. Display results

```bash
#!/bin/bash

read -p "Please enter the first number: " num1
read -p "Please enter the second number: " num2

echo "Sum: $((num1 + num2))"
echo "Difference: $((num1 - num2))"
echo "Product: $((num1 * num2))"
echo "Division: $((num1 / num2))"
echo "Remainder: $((num1 % num2))"
```

Make the script executable: `chmod +x script.sh`

Run: `./script.sh`

> [!NOTE]
> Division produces integer results only; decimals require floating-point arithmetic (covered in next session).

## Different Methods for Arithmetic Operations

Two primary methods for arithmetic:

### Method 1: Double Parentheses (Recommended)
As shown above, use `$((expression))` within echo commands.

### Method 2: Using `expr` Command
Alternative syntax using `expr`:
```bash
#!/bin/bash

read -p "Please enter the first number: " num1
read -p "Please enter the second number: " num2

echo "Sum: $(expr $num1 + $num2)"
echo "Difference: $(expr $num1 - $num2)"
echo "Product: $(expr $num1 \* $num2)"  # Escape * for multiplication
echo "Division: $(expr $num1 / $num2)"
echo "Remainder: $(expr $num1 % $num2)"
```

Note: Multiplication operator `*` must be escaped as `\*` with `expr`.

## Limitations and Notes

- Both methods work with integers only
- Division truncates decimals (e.g., `10 / 3` = 3)
- For negative numbers, operations work correctly
- Division by zero not handled (may cause errors)
- Decimal numbers will cause errors; requires different approach (covered next session)

⚠ Floating-point arithmetic needs `bc` command or floating-point variables for decimals.

## Demonstration

The instructor demonstrates the script with various inputs:
- 10 and 5: Sum=15, Diff=5, Prod=50, Div=2, Mod=0
- 5 and 10: Sum=15, Diff=-5, Prod=50, Div=0, Mod=5
- 10 and 0: Division by zero error
- -10 and -2: Sum=-12, Diff=-8, Prod=20, Div=5, Mod=0
- Decimals (6 and 2.5): Causes error - not supported with these methods

> [!IMPORTANT]
> Test scripts thoroughly with different number types to ensure correct behavior.

## Summary

### Key Takeaways
```diff
+ Use $((expression)) for simple arithmetic in bash scripts
+ read -p allows interactive input with same-line prompts
+ Arithmetic expressions need proper enclosing to evaluate
+ Scripts can handle multiple operations on user inputs
+ Both double parentheses and expr command work for integers
- Decimal numbers require floating-point support (next session)
- Division by zero causes errors
! Remember to escape * when using expr
```

### Quick Reference

| Operation | Double Parentheses | Using expr |
|-----------|-------------------|------------|
| Addition | `$((a + b))` | `$(expr $a + $b)` |
| Subtraction | `$((a - b))` | `$(expr $a - $b)` |
| Multiplication | `$((a * b))` | `$(expr $a \* $b)` |
| Division | `$((a / b))` | `$(expr $a / $b)` |
| Modulus | `$((a % b))` | `$(expr $a % $b)` |

Example script execution:
```bash
$ ./calc.sh
Please enter the first number: 10
Please enter the second number: 3
Sum: 13
Difference: 7
Product: 30
Division: 3
Remainder: 1
```

### Expert Insight

**Real-world Application**: Arithmetic operations form the foundation for system administration scripts, such as calculating disk space, counting processes, or performing numerical validations in automation workflows.

**Expert Path**: Master integer arithmetic first, then move to floating-point with `bc` command. Practice writing functions for complex calculations and error handling for edge cases like division by zero.

**Common Pitfalls**: 
- Forgetting to enclose expressions in `$(( ))` results in literal text output
- Not escaping `*` in `expr` causes shell expansion issues  
- Using decimals without proper floating-point tools leads to evaluation errors

</details>
