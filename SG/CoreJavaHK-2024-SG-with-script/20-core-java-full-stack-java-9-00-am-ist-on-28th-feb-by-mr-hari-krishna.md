# Session 20: Variables and Arrays Introduction

## Table of Contents
- [Overview](#overview)
- [Primitive Variables](#primitive-variables)
- [(Key Concepts/Deep Dive)](#key-concepts-deep-dive)
  - [Variable Basics](#variable-basics)
  - [Data Types and Assignment](#data-types-and-assignment)
  - [(Integer Data Types and Assignment)](#integer-data-types-and-assignment)
  - [(Floating Point Data Types and Assignment)](#floating-point-data-types-and-assignment)
  - [(Character Data Type and Assignment)](#character-data-type-and-assignment)
  - [(Boolean Data Type and Assignment)](#boolean-data-type-and-assignment)
  - [Problems with Variables](#problems-with-variables)
  - [Storing Multiple Values](#storing-multiple-values)
- [Arrays Introduction](#arrays-introduction)
- [Summary](#summary)

## Overview
This session reviews core concepts of variables, arrays, and class objects in Java, focusing on storing data effectively. We explored variables as named memory locations for holding single values or objects, primitive types for mathematical values, and reference types for objects. The session delves into data type assignments, potential errors in variable usage, the limitations of single variables for multiple values, and introduces arrays as a solution for dynamic storage of multiple similar-type values.

## Primitive Variables(Key Concepts/Deep Dive)
### Variable Basics
A variable is a named memory location used to store a single mathematical value or reference to a single object. Memory allocation for variables depends on the context:

- Variables declared inside methods automatically allocate memory by the JVM without requiring explicit keywords like `static` or `new`.
- Variables declared inside classes (as instance or static variables) require explicit memory allocation using `static` or `new` keywords; `static` does not create objects, while `new` does.
- Reference variables store object references, created using the `new` keyword, as objects cannot be directly instantiated.

Syntax for creating a variable:
```java
data_type variable_name;          // Declaration, not initialized
data_type variable_name = value;  // Declaration with initialization
```

Primitive variables handle mathematical values using primitive data types (e.g., int, float), while reference variables handle objects using reference data types (e.g., class types like String or arrays).

### Data Types and Assignment
Based on the value type, choose the appropriate primitive data type. The example program demonstrates creating primitive variables for different value types:

```java
public class PrimitiveVariableDemo {
    public static void main(String[] args) {
        // Integer assignments
        int i1 = 10;         // Allowed: 10 is int type, in int range
        long l1 = 10;        // Allowed: small int can be stored in long
        long l2 = 10L;       // Allowed: suffix L designates long type
        
        // Floating-point assignments
        double d1 = 10.5;    // Default to double
        float f1 = 10.5f;    // Must use 'f' or 'F' suffix for float
        
        // Character assignments
        char c1 = 'a';       // Use single quotes for characters
        char c2 = 98;        // Assigns number 98, converts to ASCII 'b'
        
        // Boolean assignments
        boolean b1 = true;
        boolean b2 = false;
        
        // Print all variables
        System.out.println("i1: " + i1);
        System.out.println("l1: " + l1);
        System.out.println("l2: " + l2);
        System.out.println("d1: " + d1);
        System.out.println("f1: " + f1);
        System.out.println("c1: " + c1);
        System.out.println("c2: " + c2);
        System.out.println("b1: " + b1);
        System.out.println("b2: " + b2);
    }
}
```

Compile-time errors (ICT) occur if assignments are incompatible:
- `float f = 10.5;` → ICT: Possible lossy conversion from double to float.
- `boolean b = 1;` → ICT: Incompatible types: int cannot be converted to boolean.
- Assigning values outside data type range (e.g., large integers without 'L' suffix to int).

All Java data types have default memory sizes and ranges:

| Data Type | Size (Bytes) | Range |
|-----------|--------------|-------|
| byte     | 1            | -128 to 127 |
| short    | 2            | -32,768 to 32,767 |
| int      | 4            | -2,147,483,648 to 2,147,483,647 |
| long     | 8            | -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807 |
| float    | 4            | ~1.4e-045 to ~3.4e+038 |
| double   | 8            | ~4.9e-324 to ~1.8e+308 |
| char     | 2            | 0 to 65,535 (Unicode) |
| boolean  | 1 (varies)   | true or false |

#### Integer Data Types and Assignment
- Integers are int type by default.
- Can store in byte, short, int, long if within range. Smaller types can store in larger types without issues.
- Exceeding int range requires 'L' or 'l' suffix for long type.
- Examples:
  - `long l = 10;` Allowed, stores int in long.
  - `long l = 123456789012L;` Required for large numbers.
  - `int i = 123456789012;` ICT: Integer number too large.

#### Floating Point Data Types and Assignment
- Double is default for floating points.
- Must suffix with 'f' or 'F' for float assignment.
- Examples:
  - `double d = 10.5;` → Ok.
  - `float f = 10.5;` → ICT: Lossy conversion double to float.

#### Character Data Type and Assignment
- Stores single characters (letters, digits, symbols) or ASCII equivalents.
- Use single quotes for characters, direct numbers convert to ASCII.
- Examples:
  - `char c = 'a';` → Stores 'a'.
  - `char c = 98;` → Stores 'b' (ASCII 98).
  - Invalid: `char c = 'ab';` (only one char), `char c = 98;`.

#### Boolean Data Type and Assignment
- Only accepts `true` or `false`.
- Not compatible with integers (1/0).
- Example: `boolean b = true;`

### Problems with Variables
Variables store only one value/object at a time. Assigning a new value replaces the old one. Program example:

```java
public class VariableProblem {
    public static void main(String[] args) {
        int x = 5;
        System.out.println("Initial value of x: " + x); // Prints 5
        x = 7;
        System.out.println("New value of x: " + x);     // Prints 7 (5 replaced)
    }
}
```

Buffers the new value without retaining old; no dynamic expansion.

### Storing Multiple Values
- Requires multiple separate variables (static approach).
- Example: Multiple ints for student IDs.
- Problem: On-demand changes require code modification/recompilation.
- Solution: Arrays for dynamic, grouped storage.

## Arrays Introduction
An array is a collection of variables of the same type for storing multiple values as one group under a single name. Enables dynamic creation at runtime based on size.

- Syntax: `data_type[] array_name = new data_type[size];`
- Example: `int[] numbers = new int[5];` Creates 5 int variables grouped as `numbers`.
- Size can be read from user input for dynamic programs.
- Arrays are objects, created with `new`.

> [!NOTE]  
> Arrays unify related data without static limits, improving flexibility over manual variables.

## Summary

### Key Takeaways
```diff
+ Variables are named memory locations for single values/objects, using primitive (e.g., int) or reference types.
+ Primitive variables store mathematical values directly; reference variables store object references.
+ Memory allocation differs: method variables auto-allocated, class variables need static/new.
+ Data type assignment follows strict ranges/rules (e.g., suffix 'L' for long, 'f' for float).
+ Compile-time errors occur for incompatible types, range exceedances, or invalid assignments.
+ Variables hold only one value; new assignments replace old ones.
+ Multiple values need multiple variables (static) or arrays (dynamic + grouped).
+ Arrays are objects created with new, storing same-type values dynamically at runtime.
```

### Expert Insight

#### Real-world Application
In production Java apps, variables manage single config values (e.g., user age as int), while arrays store collections like user IDs (long[]) or menus (String[]). For dynamic data (e.g., sensor readings varying by device count), arrays enable scalable storage without hard-coded variables, reducing maintenance in systems like IoT monitors or e-commerce inventories.

#### Expert Path
Master data types through practice: Experiment with range limits (e.g., test long assignments beyond 9e18), debug ICT errors using IDEs, and transition to Lists/ArrayLists for advanced collections. Study JVM memory model (heap/stack) to understand allocation. Aim for projects using arrays for data processing, then generics.

#### Common Pitfalls
- Assigning floating points without 'f' suffix or integers (0/1) to booleans → ICT.
- Ignoring ranges (e.g., saving large numbers as int without 'L') → Compile failure, underflow/overflow runtime.
- Over-relying on separate variables for multiples → Brittle, static code; switch to arrays early.
- Misusing characters (direct numbers vs. single quotes) → Unexpected ASCII conversions.
- Skipping range checks → Errors in ports/IDs exceeding types. Ensure profiling for larger datasets to detect memory inefficiencies. Always test edge cases (min/max values) to avoid unexpected replacements or overflows.
