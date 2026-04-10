# Session 18: Core Java Full Stack Java

## Table of Contents
- [Introduction to Language Fundamentals](introduction-to-language-fundamentals)
  - [Recap of Last Class](recap-of-last-class)
  - [What is a Language?](what-is-a-language)
  - [Communication in Programming](communication-in-programming)
  - [What is a Program?](what-is-a-program)
  - [Logic in Programming](logic-in-programming)
  - [Manual vs. Automation](manual-vs-automation)
  - [Activities in a Program](activities-in-a-program)
  - [Language Fundamentals](language-fundamentals)
- [Data Types Chapter Introduction](data-types-chapter-introduction)
  - [Chapter Overview](chapter-overview)
  - [Need of the Chapter](need-of-the-chapter)
  - [Program Demonstration: Need for Data Types](program-demonstration-need-for-data-types)
  - [What is a Data Type?](what-is-a-data-type)
  - [Why Data Types?](why-data-types)
  - [Memory Information Provided by Data Types](memory-information-provided-by-data-types)
  - [Program Examples: Incompatible Types](program-examples-incompatible-types)
- [Types of Data Types](types-of-data-types)
  - [Primitive vs. Reference Data Types](primitive-vs-reference-data-types)
  - [Purpose of Data Types](purpose-of-data-types)
  - [Variable and Object Definitions](variable-and-object-definitions)
  - [Variables vs. Objects Visualization](variables-vs-objects-visualization)
- [Data Type Hierarchy](data-type-hierarchy)
  - [Hierarchical Structure](hierarchical-structure)
  - [Memory Sizes](memory-sizes)
  - [Primitive Data Types Sizes](primitive-data-types-sizes)
  - [Variable Creation Rules](variable-creation-rules)

## Introduction to Language Fundamentals

### Recap of Last Class
- Last class covered language fundamentals.
- Lecturer emphasized understanding concepts (data types, operators, control flow statements) over memorizing large programs.
- Importance of building logic for operations.
- Advice: Avoid distractions, don't compare with other batches, focus on current session.

### What is a Language?
- A language is a communication medium.
- Examples: Spoken language between humans.
- Defines communication between two parties.

### Communication in Programming
- Programming language: Communication medium between human and computer.
- Direct communication with computer impossible without programs.

### What is a Program?
- A program is a set of instructions to the computer.
- These instructions are grouped into smaller and larger groups.
- Purpose: Make instructions manageable and organized.

### Logic in Programming
- One logic = one operation.
- Example: Calculator program has multiple logics (addition, subtraction, multiplication, division).
- Program = multiple logics for multiple operations.

### Manual vs. Automation
- Manual: Human performs calculations, risk of errors, time-consuming.
- Automation: Computer performs operations using written programs.
- Operation: Can be done manually or programmatically.

### Benefits of Automation
- Business runs 24/7, 365 days.
- Better customer relations.
- Fast, secure, accurate operations.
- Examples: PhonePe payments, departmental store payments.

### Activities in a Program
Four main activities:
1. **Storing data**
2. **Performing validations and calculations**
3. **Controlling flow of execution**
4. **Handling errors**

### Language Fundamentals
- Set of concepts available in every language to perform the four activities.
- Fundamentals:
  - Data types (for storing data)
  - Operators (for validations and calculations)
  - Control flow statements (for controlling execution)
  - Exception handling statements (for error handling)

## Data Types Chapter Introduction

### Chapter Overview
- Chapter 5: Data Types, Literals, Type Conversion, Casting, Promotion.
- Big chapter including variables, objects, single/multiple value storage.
- Emphasizes practical programs over theory.

### Need of the Chapter
Learning objectives:
- Different data types available in Java.
- Creating variables and objects.
- Storing single values and multiple values.

Three key points:
1. Different data types in Java.
2. Variable and object creation.
3. Single/multiple value storage.

### Program Demonstration: Need for Data Types
Demonstrates why data types are required.
- Creating folder structure: Week 4 → Language Fundamentals → Data Types → Types of Data Types.
- Program shows direct value storage fails without variables.

```java
class Test01 {
    public static void main(String[] args) {
        10;  // Not a statement - compile time error
        "Hello";  // Not a statement - compile time error
    }
}
```

- Explanation: Compiler needs context for storage.
- Cannot store value directly; requires memory allocation.
- Compilation errors: Semicolon expected, not a statement.

### Creating Variables
Steps:
1. Open editor, create Java class.
2. Use `Test01.java` for naming pattern.
3. Resource concepts via test programs.

Key insight:
- Writing direct values like `10;` causes errors.
- Must create memory (variable) first.

### What is a Data Type?
- Keyword or class name used for allocating memory.
- Specifically for storing values in programs.
- Provides memory specifications.

| Aspect | Description |
|--------|-------------|
| Memory allocation | Allocates space for storage |
| Type specificity | Defines what type of values can be stored |
| Variable/object creation | Enables creation of storage containers |

### Why Data Types?
- Memory allocation required for value storage.
- Data types provide essential information:
  - Type of memory
  - Size of memory
  - Type and range of storable values
- Without data types, compiler can't determine memory requirements.

```java
class Demo {
    public static void main(String[] args) {
        int a = 10;  // Valid: specifies type, allocates memory
        
        a = 20;        // Accessing existing memory
        boolean b = true;  // Different memory type
        
        // Invalid attempts
        int x = true;  // Incompatible types: boolean cannot be converted to int (type mismatch)
        int y = 10.5;  // Incompatible types: possible lossy conversion from double to int (range issue)
        byte z = 500;  // Incompatible types: possible lossy conversion from int to byte (range issue)
    }
}
```

### Memory Information Provided by Data Types
Data types inform compiler/JVM about:
- **Type of memory**: Integer, floating-point, character, boolean.
- **Size of memory (range)**: How many bytes needed.
- **Type of storable data**: Value categories allowed.
- **Range of values**: Acceptable value boundaries.

Example table of data type information:

| Data Type | Memory Type | Size (Bytes) | Type of Data | Value Range |
|-----------|-------------|--------------|--------------|-------------|
| byte | Integer | 1 | Integer | -128 to 127 |
| short | Integer | 2 | Integer | -32,768 to 32,767 |
| int | Integer | 4 | Integer | -2,147,483,648 to 2,147,483,647 |
| long | Integer | 8 | Integer | -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807 |
| float | Floating-point | 4 | Decimal | Approximately ±3.4028235E+38 |
| double | Floating-point | 8 | Decimal | Approximately ±1.7976931348623157E+308 |
| char | Character | 2 | Character/Numeric | 0 to 65,535 (\u0000 to \uffff) |
| boolean | Boolean | 1 | True/False | true, false |

### Program Examples: Incompatible Types
Compilation errors demonstrate data type restrictions:

```java
int i1 = 10;    // Valid: 10 (int) fits int type
int i2 = true;  // ERROR: boolean cannot be converted to int (type mismatch)
int i3 = 10.5;  // ERROR: possible lossy conversion from double to int (range/type)
byte b1 = 500;  // ERROR: possible lossy conversion from int to byte (range)
byte b2 = 110;  // Valid: 110 fits byte range
```

- Assignment `a = value` stores in existing variable.
- Declaration `type name = value` creates new memory.
- Data types prevent incompatible value assignments.

## Types of Data Types

### Primitive vs. Reference Data Types
Java supports two main data type categories:

1. **Primitive Data Types (PDT)**: For single-value storage (variables).
2. **Reference Data Types (RDT)**: For multiple-value storage (objects).

### Purpose of Data Types
- **Primitive Data Types**: Create variables for single values.
  - Example: Storing one number, one character, one boolean.
- **Reference Data Types**: Create objects for grouped values.
  - Example: Storing related data as collections.

### Variable and Object Definitions
- **Variable**: Single-value memory location.
  - Memory representation: Rectangle/square box.
- **Object**: Multiple-value memory location.
  - Memory representation: Circle (group of boxes).
  - Variables within object each hold separate values.

### Variables vs. Objects Visualization
Variable (single value):
```
[ value ]
```

Object (multiple values):
```
     [value3]
[ value1 ]    [value2 ]
     [value4]
```
Illustration: Circle containing interconnected boxes, each representing separate memory.

## Data Type Hierarchy

### Hierarchical Structure
Java data types organized in levels:

- **Level 1**: Primitive Types vs. Reference Types
- **Level 2**: Numeric vs. Non-numeric
- **Level 3**: Integral, Floating-point vs. Boolean
- **Level 4**: Integer, Character vs. Floating-point (numeric)
- **Reference Types**: Array (capital A), Class, Interface, Abstract Class, Final Class, Enum, Annotation, Record

### Memory Sizes
Memory allocation varies:
- Primitive data types: Fixed sizes (1-8 bytes).
- Reference data types: Variable sizes based on content.

### Primitive Data Types Sizes
| Data Type | Size (Bytes) | Purpose |
|-----------|--------------|---------|
| byte | 1 | Integer storage with small range |
| short | 2 | Integer storage with medium range |
| int | 4 | Standard integer storage |
| long | 8 | Large integer storage |
| float | 4 | Single-precision floating-point |
| double | 8 | Double-precision floating-point |
| char | 2 | Character storage (Unicode) |
| boolean | 1 | True/false values |

### Variable Creation Rules
- Always specify type and potentially initial value.
- Example: `int variableName = initialValue;`
- Cannot assign incompatible types or ranges.
- Primitive: Single value; Reference: Grouped values.

## Lab Demos
### Demo 1: Basic Variable Creation and Storage
```java
class TestVariables {
    public static void main(String[] args) {
        int i1 = 10;        // Creates integer variable with initial value
        System.out.println(i1); // Prints: 10
        
        // Attempting direct value storage (fails)
        // 10; // Compilation error: not a statement
        
        i1 = 20;           // Updates existing variable
        System.out.println(i1); // Prints: 20
    }
}
```

**Steps**:
1. Create Java class: `TestVariables.java`
2. Define main method
3. Declare integer variable with initial value
4. Attempt invalid operations to observe errors
5. Compile and run to verify behavior

### Demo 2: Data Type Range Validation
```java
class TypeValidation {
    public static void main(String[] args) {
        int validInteger = 100000;
        byte validByte = 100;
        
        // The following will cause compilation errors:
        // int booleanAssign = true;    // Type incompatibility
        // int decimalAssign = 10.5;    // Range incompatibility
        // byte largeValue = 500;       // Range exceeds 127
        
        System.out.println("Valid assignments work correctly");
    }
}
```

**Steps**:
1. Create class `TypeValidation.java`
2. Declare variables with compatible types/values
3. Uncomment error lines to see compilation failures
4. Run successful compilation for valid assignments

## Summary

### Key Takeaways
```diff
+ Data types are keywords that allocate specific memory for value storage
+ Primitive data types store single values; reference types store multiple values
+ Memory size and type restrictions prevent incompatible assignments
+ Variables (rectangular) hold single values; objects (circular groups) hold multiple values
+ Java supports 8 primitive data types: byte, short, int, long, float, double, char, boolean
+ Reference types include Array, Class, and other advanced types
```

### Expert Insight

#### Real-world Application
In enterprise Java applications, data type selection optimizes memory usage - using `byte` for small numeric ranges (like star ratings 1-5) saves memory compared to `int`. Reference types like objects enable complex data structures such as shopping carts storing multiple products, user profiles, or bank transaction records with related information grouped logically.

#### Expert Path
Master data type nuances: understand autoboxing between primitives and wrapper classes (`int` ↔ `Integer`), use `BigDecimal` for financial calculations where `float`/`double` precision fails, and leverage custom classes for domain-specific data modeling. Study JVM memory management to optimize garbage collection behavior.

#### Common Pitfalls
- **Implicit narrowing**: Assigning larger range values to smaller types without explicit casting causes compilation errors (`int` to `byte` needs `(byte)` cast).
- **Floating-point precision**: `0.1 + 0.2 != 0.3` in `float`/`double` due to binary representation - use `BigDecimal` for exact decimal arithmetic.
- **NullPointerException**: Treating primitive variables as objects; primitives cannot be null, only their wrapper objects can.
- **Overflow/underflow**: Silent wrapping in arithmetic operations (e.g., `byte`'s 127 + 1 = -128) without error indication.

#### Lesser Known Things About this Topic
Data types like `char` store Unicode values (Java's early adoption enabled international character support before ASCII became insufficient). Boolean implementation varies by JVM - some use 1 byte per boolean even in arrays for performance, not 1 bit as theoretically minimal. Reference types' variable size allows dynamic object composition, enabling Java's object-oriented polymorphism where a single variable can reference different concrete implementations at runtime. The type system prevents memory corruption seen in languages like C/C++ where weak typing leads to undefined behavior.
