<details open>
<summary><b>Session 4: Python 2 - String Properties & Operators (KK-CS45-script-v2-Inst-v1)</b></summary>

# Session 4: Python 2 - String Properties & Operators

## Table of Contents
- [Overview](#overview)
- [Key Concepts](#key-concepts)
  - [Methods vs Functions](#methods-vs-functions)
  - [String Properties - strip, lstrip, rstrip](#string-properties)
  - [Relational Operators](#relational-operators)
- [Code Examples](#code-examples)
- [Lab Demonstrations](#lab-demonstrations)
- [Use Cases](#use-cases)
- [Summary](#summary)

## Overview
This session covers advanced Python concepts including string manipulation methods (strip, lstrip, rstrip), understanding the difference between methods and functions, and relational/comparison operators. The session builds on Day 3's Python fundamentals by introducing properties/methods that belong to specific data types, particularly strings.

## Key Concepts

### Methods vs Functions

**Functions** are standalone code blocks that perform specific tasks. They are not tied to any particular data type and can be called independently.

```python
# Functions - Standalone operations
type(42)        # Returns the data type
print("Hello")  # Displays output
id(variable)    # Returns memory address
int("27")       # Type conversion
```

**Methods** are properties that belong to specific classes/data types. They can only be called using dot notation on their associated data type.

```python
# Methods - Properties of specific data types
name = "  Monal S  "
name.strip()    # String method - removes whitespace
name.lstrip()   # String method - removes left whitespace
name.rstrip()   # String method - removes right whitespace
```

> [!IMPORTANT]
> Methods are tightly coupled with their class - a string has strip method, but an integer does not.

### String Properties

String class comes with several useful methods for whitespace manipulation:

| Method | Description | Example |
|--------|-------------|---------|
| `strip()` | Removes whitespace from both ends | `"  hello  ".strip()` → `"hello"` |
| `lstrip()` | Removes whitespace from left side only | `"  hello  ".lstrip()` → `"hello  "` |
| `rstrip()` | Removes whitespace from right side only | `"  hello  ".rstrip()` → `"  hello"` |

### Relational Operators

Relational operators (also called comparison operators) are used to compare two values and return a boolean (True/False):

| Operator | Description | Example | Result |
|----------|-------------|---------|--------|
| `>` | Greater than | `12 > 3` | `True` |
| `<` | Less than | `3 < 12` | `True` |
| `==` | Equal to | `12 == 12` | `True` |
| `>=` | Greater than or equal to | `12 >= 12` | `True` |
| `<=` | Less than or equal to | `12 <= 3` | `False` |
| `!=` | Not equal to | `12 != 3` | `True` |

> [!NOTE]
> Use `==` (double equals) for comparison, not `=` (single equals) which is assignment.

## Code Examples

### String Methods Demonstration

```python
# Creating a string with whitespace
name = "  Monal S  "

# Using strip methods
clean_name = name.strip()      # Removes both sides
left_clean = name.lstrip()     # Removes left side only
right_clean = name.rstrip()    # Removes right side only

# Combining methods
combined = name.lstrip().rstrip()  # Same as strip()
```

### Relational Operators in Action

```python
# Basic comparisons
12 > 3      # True - 12 is greater than 3
12 < 3      # False - 12 is not less than 3
12 == 12    # True - they are equal
3 != 12     # True - they are not equal

# Combined operators
12 >= 12    # True - either greater or equal
12 <= 3     # False - neither less nor equal
```

## Lab Demonstrations

### Removing Whitespace Without Using strip()

```python
# Method 1: Step by step
name = "  data  "
name = name.lstrip()    # Remove left spaces first
name = name.rstrip()    # Then remove right spaces

# Method 2: Chained approach
name = "  data  "
name = name.lstrip().rstrip()  # Chain the methods
```

### Execution Order Explanation

When Python executes chained methods like `name.lstrip().rstrip()`:

1. First evaluates the variable `name`
2. Applies `lstrip()` to get intermediate result
3. Applies `rstrip()` to the intermediate result
4. Returns final cleaned string

## Use Cases

### Data Cleaning from Forms

When collecting data from Google Forms, users might enter values with extra spaces:

```python
# User inputs from forms
age_input = "27 "      # Has trailing space
age_clean = age_input.strip()  # Remove whitespace
age = int(age_clean)   # Now safely convert to integer
```

Without strip(), `int("27 ")` would fail because the space prevents conversion.

## Summary

### Key Takeaways
```diff
+ Methods belong to specific classes and use dot notation
+ strip(), lstrip(), rstrip() are string methods for whitespace removal
+ Functions are standalone and don't use dot notation
+ Relational operators compare values and return True/False
+ == is for comparison, = is for assignment
+ != is "not equals" (opposite of ==)
```

### Quick Reference

```python
# String methods
text.strip()    # Remove whitespace both ends
text.lstrip()   # Remove whitespace left only
text.rstrip()   # Remove whitespace right only

# Relational operators
a > b   # Greater than
a < b   # Less than
a == b  # Equal to
a >= b  # Greater than or equal
a <= b  # Less than or equal
a != b  # Not equal to
```

### Expert Insight

**Real-world Application**: String cleaning methods are essential when processing user input, parsing CSV files, or cleaning API responses where whitespace can cause data inconsistencies.

**Expert Path**: Master these fundamentals before moving to more complex string methods like `split()`, `replace()`, `upper()`, `lower()`, and regex operations.

**Common Pitfalls**:
- Confusing `=` (assignment) with `==` (comparison)
- Trying to use string methods on non-string types
- Forgetting that methods return new values and need to be assigned back or chained

</details>