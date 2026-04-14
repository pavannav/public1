# Session 39: Data Types

## Table of Contents

- [Need of this Chapter](#need-of-this-chapter)
- [What is a Data Type and Why Data Type](#what-is-a-data-type-and-why-data-type)
- [Types of Data Types](#types-of-data-types)
- [Data Types Hierarchy Chart](#data-types-hierarchy-chart)
- [Explanation on Each Data Type](#explanation-on-each-data-type)
- [Summary](#summary)

## Need of this Chapter

### Overview
This chapter, Data Types, Literals, Type Conversions, introduces fundamental concepts for storing values in Java programs. We learn how to allocate memory for variables and objects to store single or multiple values. The chapter covers four main sections: Data Types and Variables, Arrays and Objects; Literals and Types of Literals; Type Conversions, Casting, and Promotion; and Character Sets (ASCII and Unicode).

### Key Concepts
The chapter explains why data types are essential for memory allocation and value storage. Data types provide information to the JVM about memory type, size, value range, allowed operators, and expression result types. This enables efficient program execution.

## What is a Data Type and Why Data Type

### Overview
A data type is a keyword that communicates to the compiler and JVM details about memory allocation for variables or objects, including memory type, size, allowed values, range, operations, and result types in expressions.

### Key Concepts/Deep Dive
Data types are crucial because Java is a statically typed language, requiring explicit type declarations for variables. Without specifying types, compilation fails. For example, attempting to assign incompatible types (e.g., a floating-point to an integer variable) results in errors like "incompatible types: possible lossy conversion."

Primitive data types like `int` specify integer memory of 4 bytes with a range of -2,147,483,648 to 2,147,483,647. Literals have implicit types: integers default to `int`, floating-points to `double`.

Operators like arithmetic (`+`, `-`) work on certain types, and type mismatches lead to compilation errors.

### Code/Config Blocks
Example program demonstrating data type basics:

```java
public class Test01 {
    public static void main(String[] args) {
        int a = 10;  // Integer literal
        double b = 10.5;  // Floating-point literal
        char c = 'A';  // Character literal
        boolean d = true;  // Boolean literal
    }
}
```

Compiling and running shows successful storage of appropriately typed values.

### Tables
| Data Type Group | Purpose | Example |
|-----------------|---------|---------|
| Integer | Whole numbers | `int`, `long` |
| Floating-point | Decimal numbers | `double` |
| Character | Single characters | `char` |
| Boolean | True/false values | `boolean` |

### Lab Demos
#### Test01 Demo
1. Create a file `Test01.java` with the above code.
2. Compile using `javac Test01.java`.
3. Run with `java Test01`.
4. Correct any type mismatch errors, e.g., assigning `10.5` to `int` causes "incompatible types: possible lossy conversion from double to int."
5. Experiment by assigning out-of-range values, like `300` to `byte`, to see range errors.

## Types of Data Types

### Overview
Java supports two main data type categories: primitive (for single mathematical values) and reference (for multiple values or objects). Primitive types include byte, short, int, long, float, double, char, and boolean. Reference types include arrays, classes, interfaces, enums, and annotations.

### Key Concepts/Deep Dive
Primitive types create variables for one value, while reference types create objects for groups of values. For same-type groups, use arrays; for different types, use classes.

## Data Types Hierarchy Chart

### Overview
Data types are divided into primitive (base types) and reference (derived types). Primitives split into numeric (integral or floating-point) and non-numeric (boolean). Integrals include integers (byte, short, int, long) and characters (char). Numeric types have float and double; boolean stands alone.

### Key Concepts/Deep Dive
The hierarchy shows dependencies: reference types rely on primitives. Sizes vary for memory efficiency:
- `byte`: 1 byte (-128 to 127)
- `short`: 2 bytes (-32,768 to 32,767)
- `int`: 4 bytes (default for integers)
- `long`: 8 bytes (for large numbers)
- `float`: 4 bytes (explicit for small floats)
- `double`: 8 bytes (default for floats)
- `char`: 2 bytes (for Unicode, 0-65,535)
- `boolean`: JVM-dependent

### Code/Config Blocks
Example `Test02.java` demonstrating types:

```java
public class Test02 {
    public static void main(String[] args) {
        int i1 = 10;          // Primitive for single int
        double d1 = 10.5;     // Primitive for single double
        char ch = 'A';        // Primitive for single char
        boolean b = true;     // Primitive for single boolean
        String s = "Hello";   // Reference for string of chars
        int[] arr = {10, 20, 30};  // Reference for array of ints
        // Class example would be more complex
    }
}
```

### Lab Demos
#### Test02 Demo
1. Compile `Test02.java`.
2. Run and observe memory for each type.
3. Replace types (e.g., `int i1` with `byte i1`) and check implicitly reduced storage via compiler optimization.

## Explanation on Each Data Type

### Overview
Eight primitives based on value types and ranges. Four core types (int, double, char, boolean) with additional for range/memory efficiency.

### Key Concepts/Deep Dive
- **Integer Types**: `byte`, `short`, `int`, `long` for whole numbers.
- **Floating-Point**: `float` (4 bytes), `double` (8 bytes) for decimals.
- **Character**: `char` for Unicode characters.
- **Boolean**: `boolean` for true/false.

Choose based on range; use `int` for general, `long` for large numbers.

### Tables
| Data Type | Size (Bytes) | Range | Default |
|-----------|--------------|-------|---------|
| byte | 1 | -128 to 127 | No |
| short | 2 | -32,768 to 32,767 | No |
| int | 4 | -2,147,483,648 to 2,147,483,647 | Yes for int |
| long | 8 | Large range | No |
| float | 4 | Wide floating range | No |
| double | 8 | Wider floating range | Yes for float |
| char | 2 | 0 to 65,535 (Unicode) | No |
| boolean | Variable (JVM) | true/false | No |

### Lab Demos
#### Assignment Demo
1. Modify `Addition.java` and `Calculator.java` with logic: throw `IllegalArgumentException` for values outside 10-20.
2. Test with values 12,15 (success) and 21,5 (exception).
3. Practice packages and JAR creation as per Hitech City Style.

## Summary

### Key Takeaways
```diff
+ Data types allocate memory for variables (single values) or objects (multiple values).
+ Primitive types (8): byte, short, int, long, float, double, char, boolean.
+ Reference types: array (same types), class (different types), interface, enum, annotation.
+ Always specify types; compiler enforces compatibility.
+ Use int and double for general programming; others for specific ranges/memory needs.
+ Literals have implicit types (e.g., 10 is int, 10.5 is double).
```

### Expert Insight
#### Real-world Application
In production, choose data types based on data scale (e.g., `long` for IDs, `double` for financial calculations). Use arrays for lists like user IDs; classes for entities like `User`.
#### Expert Path
Master type casting and promotion; practice with large datasets to optimize memory. Experiment with Unicode in internationalization features.
#### Common Pitfalls
Mistake: Using `int` for large numbers, causing overflow (e.g., store mobile numbers in `long`). Resolution: Check ranges and use appropriate types; test edge values.
Issue: Assigning incompatible types (e.g., `double` to `int`) leads to lossy conversion errors. Resolution: Use casting: `int x = (int) 10.5;`, aware of data loss.
Lesser Known: `boolean` size is JVM-dependent (often 1 byte in arrays, but not fixed); use with care in memory-critical apps. Avoid assuming `float` for precision; prefer `BigDecimal` for accurate monetary calculations. Note: Java evolves (e.g., Java 7 literals features), so stay updated for newer optimizations.
