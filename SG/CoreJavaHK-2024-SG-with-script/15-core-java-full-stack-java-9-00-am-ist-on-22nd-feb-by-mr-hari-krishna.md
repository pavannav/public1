# Session 15: Core Java & Full Stack Java

## Table of Contents
- [Overview](#overview)
- [Introduction to Keywords](#introduction-to-keywords)
- [Purpose of Keywords](#purpose-of-keywords)
- [Rules for Using Keywords](#rules-for-using-keywords)
- [10 Operations in Java Programs](#10-operations-in-java-programs)
- [Evolution and History of Keywords](#evolution-and-history-of-keywords)
- [Summary](#summary)

## Overview
This session focuses on deepening the understanding of keywords in Java, building on previous discussions about identifiers. The instructor provides an overview of Java programming concepts, emphasizing that mastering 10 core operations performed by keywords is essential for core Java competence. The lesson transitions from keyword fundamentals to a holistic view of Java as performing 10 distinct operations, positioning Java as a vast yet structured ocean that developers must learn to navigate.

> [!NOTE]
> The instructor stresses that core Java consists of learning these 10 operations, achieved by comprehending keyword functionality rather than memorizing endless details.

## Introduction to Keywords
A keyword is a predefined identifier reserved in the Java language with special meaning that performs a unique operation in a Java program.

### Distinction from Reserved Words
- **Keyword**: Predefined identifier, reserved, performs a unique operation (e.g., `class`, `public`, `static`).
- **Reserved Word**: Reserved but does not perform a unique operation (e.g., `null` is reserved but not a keyword).

### Examples
- `String` is a predefined identifier (class name), not a keyword.
- Keywords: `class`, `public`, `static`, etc.

## Purpose of Keywords
Keywords communicate to the compiler and JVM to perform specific operations in a Java program. The developer uses keywords to instruct the compiler/JVM to create structures, allocate resources, and manage program flow.

- **Key Insight**: Keywords enable developers to build Java programs by directing the compiler and JVM. For instance:
  - `class`: Instructs compiler to create a class.
  - `public`: Allows class access from other folders/packages.
  - `static`: Modifies method/variable behavior for shared access without object instantiation.

### Communicating with Compiler/JVM
- Unidirectional communication: Developer instructs compiler/JVM (no direct response).
- Purpose: Perform one of 10 core operations in Java.

## Rules for Using Keywords
### Rule 1: Cannot use keywords as user-defined identifiers
- Keywords are reserved and cannot be used as class names, variable names, or method names.
- Violation results in compile-time errors.
- Example: `int class = 10;` → Compile error.

### Rule 2: Must use keywords in all lowercase letters
- Keywords are predefined in lowercase.
- Java is case-sensitive; changing case (e.g., `Class`, `PUBLIC`) makes it invalid.
- Example: `Class sample = new Class();` is invalid; must be `class Sample = new Sample()` (class names follow PascalCase).

> [!IMPORTANT]
> Adhere to these rules to avoid compilation failures. The instructor corrected any potential misspellings in the transcript, such as ensuring consistent terminology for reserved vs. keywords.

## 10 Operations in Java Programs
Java programs perform exactly 10 operations using keywords, forming the foundation of core Java. Understanding these operations provides a mental framework for programming, making Java manageable rather than overwhelming.

### 1. Package Creation and Usage
- **Operation**: Create and use packages for organizing classes.
- **Keywords**: `package`, `import`.
- **Example**:
  ```java
  package com.example;  // Package creation
  import java.util.List;  // Package usage
  ```

### 2. Class Creation
- **Operation**: Define classes.
- **Keywords**: `class`, `public`, `private`, etc. (for access).
- **Example**:
  ```java
  public class Sample {
      // Class body
  }
  ```

### 3. Variables and Methods Creation
- **Operation**: Define fields and methods within classes.
- **Keywords**: `int`, `void`, etc. (data types); access modifiers like `private`.
- **Example**:
  ```java
  private int variable;
  public void method() {
      // Method logic
  }
  ```

### 4. Memory Allocation
- **Operation**: Allocate memory for variables/methods.
- **Keywords**: `new` (for objects), implicitly for primitives.variables without `new`.
- **Example**:
  ```java
  int number = 10;  // Primitive allocation
  List<String> list = new ArrayList<>();  // Object allocation with new
  ```

### 5. Controlling Flow of Execution
- **Operation**: Direct program flow based on conditions or repetitions.
- **Keywords**: `if`, `else`, `for`, `while`, `switch`, etc.
- **Example**:
  ```java
  if (number > 0) {
      System.out.println("Positive");
  } else if (number < 0) {
      System.out.println("Negative");
  } else {
      System.out.println("Zero");
  }
  
  for (int i = 0; i < 10; i++) {
      System.out.println(i);
  }
  ```
- **Lab Demo/Steps**: Include control flow in method logic to validate values (e.g., positive/negative numbers) and prevent execution errors.

### 6. Setting Access Level Permissions
- **Operation**: Control class/variable/method accessibility.
- **Keywords**: `public`, `private`, `protected`, `default` (package-private).
- **Example**:
  ```java
  public class BankAccount {  // Accessible everywhere
      private double balance;  // Accessible only within class
      protected void deposit(double amount) {}  // Accessible in subclass/package
  }
  ```

### 7. Setting Execution Level Permissions
- **Operation**: Control method execution (e.g., preventing simultaneous access).
- **Keywords**: `synchronized` for thread safety.
- **Example**:
  ```java
  public synchronized void withdraw(double amount) {
      // Only one thread can execute at a time
  }
  ```

### 8. Establishing Inheritance Relation
- **Operation**: Create parent-child relationships between classes.
- **Keywords**: `extends`, `implements`.
- **Example**:
  ```java
  public class Lion extends Animal implements Mammal {}
  ```

### 9. Representing Object and Its Members
- **Operation**: Access object-specific members; differentiate parent/child attributes.
- **Keywords**: `this`, `super`.
- **Example**:
  ```java
  public class Child extends Parent {
      public Child() {
          super();  // Access parent constructor
          this.variable = 10;  // Access child variable
      }
  }
  ```

### 10. Handling User Mistakes (Exception Handling)
- **Operation**: Manage runtime errors gracefully.
- **Keywords**: `try`, `catch`, `throw`, `finally`.
- **Example**:
  ```java
  try {
      int result = divide(a, b);
  } catch (ArithmeticException e) {
      System.out.println("Cannot divide by zero");
  } finally {
      System.out.println("Execution completed");
  }
  ```
- **Lab Demo/Steps**:
  1. Create a method with control flow.
  2. Use try-catch to handle potential errors (e.g., invalid inputs).
  3. Test with valid/invalid inputs to demonstrate error handling.
  4. Include throw for custom exceptions if necessary.

> [!NOTE]
> These 10 operations cover logical programming (operations 3-5), object-oriented programming (6-10), Java API utilization (beyond), and project development. Mastery here completes core Java fundamentals.

## Evolution and History of Keywords
Java keywords have evolved across versions. Key details:

- **Total Keywords in Java 11/17**: 51 (commonly referred).
- **Breakdown**:
  - **Reserved Keywords**: 51 (perform unique operations everywhere; cannot be identifiers).
  - **Contextual Keywords**: 16 (act as keywords in specific contexts; can be used as identifiers elsewhere).
  - **Reserved Literals**: 3 (e.g., `null`, literals with special meaning).
- **History**:
  - **Java 1.0**: 47 keywords.
  - **Java 1.2**: Added `strictfp` (48 total).
  - **Java 1.4**: Added `assert` (49 total).
  - **Java 5**: Added `enum` (50 total).
  - **Java 8**: No new keywords (still 50 valid back to 11).
  - **Java 9**: Added single underscore (`_`) as keyword (51 total).
  - **Java 10+**: Added words like `var`, etc., as restricted keywords/identifiers to avoid breaking existing code. Not full keywords to prevent compilation errors in legacy projects.

```diff
+ Evolution ensures backward compatibility but complicates terminology.
- Avoid upgrading projects without checking for new reserved words.
! Restricted/contextual keywords can be used as identifiers in non-contextual areas, unlike full reserved keywords.
```

> [!CAUTION]
> From Java 10, new words (e.g., `var`) are added as restricted identifiers to prevent compile-time errors in existing codebases, unlike the disruptive addition of `enum` in Java 5.

## Summary

### Key Takeaways
```diff
+ Keywords are predefined reserved identifiers performing unique operations in Java.
+ Java programs involve 10 core operations: package management, class creation, variable/method definition, memory allocation, flow control, permissions, inheritance, object representation, and error handling.
+ Rules: Cannot use as identifiers, must be lowercase.
- Common mistake: Confusing keywords with reserved words (e.g., null is reserved but not a keyword).
! Mastery of 10 operations simplifies learning Java as an "ocean" by breaking it into manageable tasks.
```

### Expert Insight

**Real-world Application**:  
In enterprise development (e.g., building applications like Amazon or PhonePay), these 10 operations are applied daily. For instance, exception handling ensures user apps don't crash on invalid inputs, while inheritance enables scalable class hierarchies (e.g., UPI as parent for payment apps). Developers use keywords to enforce access controls and thread safety in concurrent systems.

**Expert Path**:  
Deepen understanding by practicing each operation in projects: Start with flow control in algorithmic coding challenges, then advance to inheritance in Spring Boot applications. Study multithreading for synchronization keywords. Experiment with Java versions to observe keyword evolution's impact on legacy code.

**Common Pitfalls**:  
- Using keywords as identifiers causes immediate compile errors—always lint code.  
- Overlooking restricted/contextual keywords when upgrading Java versions can lead to runtime issues (e.g., using `var` incorrectly in pre-Java 10 contexts).  
- Forgetting case sensitivity: `Public` vs. `public` triggers errors.  
- Ignoring exception handling delays error resolution; practice try-catch in all I/O operations to prevent crashes.  
- Platform Dependency Misunderstanding: Java bytecode is platform-independent, but JVM installations are platform-dependent; ensure correct JVM for deployment.  

Remember, core Java mastery comes from visualizing operations in code, not rote memorization. Practice daily to build awareness, differing from mere code-writing skills.
