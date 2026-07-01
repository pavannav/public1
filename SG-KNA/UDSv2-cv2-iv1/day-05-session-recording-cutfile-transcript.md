# Session 5: Python Input/Output, Control Flow Advanced & Loops

<details open>
<summary><b>Day 5: Input/Output, Control Flow Advanced & Loops (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [Overview](#overview)
- [1. Input/Output Deep Dive](#1-inputoutput-deep-dive)
  - [Print Function Arguments](#print-function-arguments)
  - [Separator (sep) Parameter](#separator-sep-parameter)
  - [End Parameter](#end-parameter)
- [2. Taking User Input](#2-taking-user-input)
- [3. Control Flow Advanced](#3-control-flow-advanced)
  - [Nested If-Else](#nested-if-else)
  - [Real-World Application: Role-Based Access](#real-world-application-role-based-access)
- [4. Introduction to Loops](#4-introduction-to-loops)
  - [Understanding Iterables](#understanding-iterables)
  - [For Loop Fundamentals](#for-loop-fundamentals)
  - [The Range Function](#the-range-function)
  - [String as Iterable](#string-as-iterable)
- [5. Practical Problem Solving](#5-practical-problem-solving)
- [Summary](#summary)
  - [Key Takeaways](#key-takeaways)
  - [Quick Reference](#quick-reference)
  - [Expert Insight](#expert-insight)

## Overview

Session 5 builds upon previous concepts to introduce input/output operations, advanced control flow patterns, and the fundamentals of loops. The session emphasizes practical problem-solving through interactive code demonstrations, helping students understand how to create dynamic applications that respond to user input.

**Key Topics Covered:**
- Print function customization with `sep` and `end` parameters
- Taking and processing user input with type conversion
- Nested conditional statements for complex decision-making
- Loop iteration concepts with real-world analogies
- Range function for generating number sequences

## 1. Input/Output Deep Dive

### Print Function Arguments

The `print()` function in Python is more powerful than its basic usage suggests. Think of it like a camera - while its main function is to "take photos" (display output), it has various attributes that control how it performs this task.

```python
# Basic print usage
print("Hello")  # Output: Hello

# Store value in variable and print
where1 = "Hello"
print(where1)  # Output: Hello (not "where1")
```

Python's `print()` function uses default values for formatting that aren't immediately visible. By default, when you use print, Python internally uses `\n` (newline character) at the end of each statement.

### Separator (sep) Parameter

When printing multiple values, Python inserts a space between them by default. The `sep` parameter allows customization of this behavior:

```python
# Default behavior - space separator
print("Hello", "World")  # Output: Hello World

# Custom separator
print("Hello", "World", sep="#")      # Output: Hello#World
print("Hello", "World", sep="---")    # Output: Hello---World
print("Hello", "World", sep=", ")     # Output: Hello, World
print("Hello", "World", sep="")       # Output: HelloWorld (no separator)
```

### End Parameter

The `end` parameter controls what happens after the print statement completes. By default, it adds a newline (`\n`), moving the cursor to the next line.

```python
# Default end behavior
print("Hello World")  # Output: Hello World (then newline)
print("Hello World")  # Output: Hello World (on new line)

# Custom end parameter
print("Hello", end="")      # Output: Hello (no newline)
print("World")              # Output: World (continues from previous line)

print("Hello", end=" ")     # Output: Hello (with space at end)
print("World")              # Output: World (continues after space)

print("Hello", end="--")    # Output: Hello-- (with dashes)
print("World")              # Output: World
```

## 2. Taking User Input

The `input()` function allows programs to accept user input dynamically, making applications interactive rather than static.

```python
# Basic input usage
user_input = input()  # Opens a box for user to type
print(user_input)     # Displays what user typed

# With prompt message
name = input("Enter your name: ")
print(name)
```

**Important:** The `input()` function always returns a string, regardless of what the user types:

```python
# input() always returns string
age = input("Enter your age: ")  # Returns "25" as string, not integer 25
print(type(age))  # Output: <class 'str'>
```

**Creating Polished Input Prompts:**
```python
# Different visualization styles
name1 = input("Enter your name")      # No space
name2 = input("Enter your name ")     # Space at end
name3 = input("Enter your name:")     # Colon, no space
name4 = input("Enter your name: ")    # Colon with space (recommended)
```

## 3. Control Flow Advanced

### Nested If-Else

Nested conditional statements allow creating hierarchical decision trees where conditions are checked within other conditions.

```python
# Nested if-else structure
if is_user_authenticated:  # First level check
    user_role = input("Enter your role (admin/editor/viewer): ")

    if user_role == "admin":  # Nested inside authentication check
        print("Full access granted: delete, edit, and view")
    elif user_role == "editor":
        print("Limited access: edit and view")
    else:
        print("Restricted access: view only")
else:
    print("Please log in first")
```

### Real-World Application: Role-Based Access

This example demonstrates implementing a Google Sheets-style permission system:

```python
# Simulating role-based access control
is_user_authenticated = True  # Boolean: True or False

if is_user_authenticated:
    user_role = input("""Enter your role:
    - admin (full access)
    - editor (edit & view)
    - viewer (view only)
    Your role: """)

    if user_role == "admin":
        print("You have access to: Added, View, And, delete")
    elif user_role == "editor":
        print("You have access to: View and edit")
    else:
        print("You have only view access")
else:
    print("Please Log in first")
```

## 4. Introduction to Loops

### Understanding Iterables

An iterable is any object that can be counted or processed one item at a time. Think of it like a grocery bag - you can only count items one by one if you have multiple items in a bag, not if you have just a single item.

```python
# Iterable examples
c = [1, 2, 3, 4, 5]  # List with multiple items - IS iterable
b = "Hello"          # String with multiple characters - IS iterable
a = 42               # Single value - NOT iterable
```

### For Loop Fundamentals

A `for` loop automates repetitive tasks by iterating over each item in an iterable:

```python
# Basic for loop structure
numbers = [1, 2, 3, 4, 5]
for i in numbers:
    print(i)
# Output: 1, 2, 3, 4, 5 (each on new line)
```

**How for loops work step-by-step:**
1. Python grabs the first item from the iterable
2. Assigns it to the loop variable
3. Executes the code block
4. Returns to grab the next item
5. Repeats until all items are processed

### The Range Function

The `range()` function generates sequences of numbers programmatically, eliminating the need to manually create long lists:

```python
# Range with start and end+1
for i in range(1, 11):  # Numbers 1-10
    print(i)

# Range for multiplication table
table_of = 2
for i in range(1, 11):
    print(table_of, "x", i, "=", table_of * i)
# Output: 2 x 1 = 2, 2 x 2 = 4, ... 2 x 10 = 20

# Range with custom step size
for i in range(1, 10, 2):  # Odd numbers: 1, 3, 5, 7, 9
    print(i)
```

**Range Syntax:** `range(start, end+1, step)`
- `start`: Where to begin (default: 0)
- `end+1`: Where to stop (exclusive)
- `step`: Increment between numbers (default: 1)

### String as Iterable

Strings are iterables because they're composed of individual characters:

```python
text = "Data Science"
for char in text:
    print(char)
# Output: D, a, t, a, (space), S, c, i, e, n, c, e
```

## 5. Practical Problem Solving

**Weekday Email Automation Example:**
```python
days_of_week = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

for day in days_of_week:
    if day == "Wednesday":
        print("Send booster class email")
    else:
        print("Don't send mail")
```

## Summary

### Key Takeaways
```diff
+ Print function supports sep and end parameters for formatting control
+ input() always returns strings - type conversion needed for numeric operations
+ Nested if-else enables complex hierarchical decision making
+ Loops automate repetitive tasks by iterating over iterables
+ Lists, strings, and range() all provide iterable sequences
+ Range function generates number sequences with configurable step sizes
```

### Quick Reference
```python
# Print customization
print("Hello", "World", sep="-", end="!")  # Hello-World!

# User input with conversion
age = int(input("Enter age: "))  # Convert to integer

# Nested conditionals
if authenticated:
    if role == "admin":
        # admin actions
    elif role == "editor":
        # editor actions

# For loops
for item in iterable:
    # process item

# Range variations
range(10)        # 0-9
range(1, 11)     # 1-10
range(0, 10, 2)  # Even numbers: 0, 2, 4, 6, 8
```

### Expert Insight

**Real-world Application:** Input/output and loops form the foundation of all interactive applications, from simple calculators to complex data processing systems. The concepts learned here directly apply to building user interfaces, processing batches of data, and automating repetitive business tasks.

**Expert Path:**
- Master list comprehensions as a more Pythonic way to create loops
- Learn while loops for condition-based iteration
- Practice with file handling to process multiple records
- Explore libraries like pandas that build on these iteration concepts

**Common Pitfalls:**
- Forgetting that `input()` returns strings, leading to type errors in comparisons
- Missing proper indentation with nested conditionals and loops
- Not understanding that range() end value is exclusive
- Overcomplicating problems instead of using simple iteration patterns

</details>