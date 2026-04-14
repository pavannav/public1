# Session 96: OOP Principles 6

## Table of Contents
- [Review of Previous Sessions](#review-of-previous-sessions)
- [Static Members Execution Flow with Inheritance](#static-members-execution-flow-with-inheritance)
- [Test Cases and Analysis](#test-cases-and-analysis)
- [Class Loading and Memory Allocation](#class-loading-and-memory-allocation)
- [Inheritance Relations and Member Access](#inheritance-relations-and-member-access)
- [Real-World Applications](#real-world-applications)

## Review of Previous Sessions

### Overview
This session reviews inheritance, compiler and JVM activities, and static members execution flow. The instructor discusses the four steps of execution flow for static members in inheritance scenarios, emphasizing memory allocation as the first step.

### Key Concepts/Deep Dive

Static members execution flow follows a specific order:
1. Static variable memory allocation (always first, with default values)
2. Static variable assignment and static block execution (from root superclass to current subclass, top to bottom in defined order)
3. Main method execution

**Critical Point**: Memory allocation happens first for all static variables in the inheritance hierarchy, providing default values before any assignments or blocks execute.

> [!IMPORTANT]
> The four steps must be memorized and applied correctly. Memory allocation (step 1) occurs before any execution, with default values assigned initially.

## Static Members Execution Flow with Inheritance

### Overview
The session explores how static members execute when inheritance is involved, including cases with main methods in different classes and forward reference errors.

### Key Concepts/Deep Dive

**Execution Sequence:**
- Static variables memory allocated first (from root superclass to subclass)
- Static blocks and assignments execute from top to bottom in definition order
- Main method executes from current subclass if available, otherwise from superclass

**Forward Reference Error Example:**
```java
class A {
    static int a = 10;
    static {
        System.out.println("A SB");
    }
}

class B extends A {
    static {
        System.out.println("B SB");
        System.out.println(B.a);  // Error: illegal forward reference
    }
}
```

> [!NOTE]
> Access to variables occurs in this sequence: first search in current class, then superclass using extends relation or has-a relation with explicit reference.

**Corrections Made:**
- "staty" corrected to "static"
- "subass" corrected to "subclass"

## Test Cases and Analysis

### Overview
The instructor presents multiple test cases to demonstrate static member execution flow, highlighting differences between has-a and is-a relationships.

### Key Concepts/Deep Dive

**Test Case 1: Static Block After Static Variable**
```java
class A {
    static int a = 10;
    static {
        System.out.println("A SB");
    }
    public static void main(String[] args) {
        System.out.println("A main");
    }
}

class B extends A {
    static int b = 20;
    static {
        System.out.println("B SB");
    }
}
```

**Output (Java A):** A SB, 10, A main
**Output (Java B):** A SB, B SB, 20, B main

**Key Insight:** Static members execute only when the class is accessed for its own members, not for superclass member access.

**Test Case 2: Has-a Relationship**
```java
class A {
    static int a = 10;
    static {
        System.out.println("A SB");
    }
    static void m1() {
        System.out.println("A m1");
    }
}

class B {
    static int b = 20;
    static {
        System.out.println("B SB");
    }
}

class Test {
    public static void main(String[] args) {
        B.a = 10;  // Has-a: only A executes
    }
}
```

**Output:** A SB, 10

**Real-World Example:** Mobile manufacturer (superclass behavior) vs. customer choosing SIM card type (subclass specificity).

> [!IMPORTANT]
> Using subclass reference to access superclass members only executes superclass members. Subclass members remain inactive until explicitly accessed.

## Class Loading and Memory Allocation

### Overview
When classes are loaded, JVM verifies member access intent. Static variables and blocks execute based on which class members are being accessed.

### Key Concepts/Deep Dive

**Memory Allocation Rules:**
1. Class loads when members accessed (either directly or through inheritance)
2. Static variables always allocate memory first with default values
3. Static blocks/variable assignments execute only for classes whose members are invoked
4. Subclass members don't execute if only superclass is accessed (memory optimization)

**Example:**
```java
class Test {
    public static void main(String[] args) {
        B.a = 10;  // Only A class executes (B loaded but not executed)
        B.b = 20;  // Both A and B execute (B now accessed)
    }
}
```

**Memory Waste Prevention:** JVM optimizes by not executing unused class members to save memory and improve performance.

**Corrections Made:**
- "staty block" corrected to "static block"
- "zbol" corrected to "zero"

## Inheritance Relations and Member Access

### Overview
The session distinguishes between is-a (inheritance) and has-a (composition) relationships, showing how they affect execution flow.

### Key Concepts/Deep Dive

**Is-a vs Has-a:**
- **Is-a (extends):** Both classes can be loaded; execution depends on access patterns
- **Has-a (reference):** Only referenced class executes; referenced class members activate through explicit access

**Access Patterns:**
```java
// Is-a relationship
class B extends A {
    // A members available via inheritance
}

// Has-a relationship  
class Test {
    A obj = new A();  // Explicit reference needed
}
```

> [!NOTE]
> Parent-child relations in inheritance: Parent to child is "has-a", child to parent is "is-a" through extends.

## Real-World Applications

### Overview
The concepts apply to scenarios like user types (Mobile vs. Customer), factory patterns, and any hierarchical system where memory optimization matters.

### Key Concepts/Deep Dive

**Memory-Efficient Design:**
- Avoid unnecessary class member execution
- Use proper access patterns to prevent memory waste
- Optimize for performance in large inheritance hierarchies

**Practice Recommendation:** Create memory diagrams for all 10 test cases mentioned to master execution flow.

## Summary

### Key Takeaways
```diff
+ Static variable memory allocation happens first with default values in inheritance hierarchy
+ Static blocks/variable assignments execute top-to-bottom from superclass to subclass
+ Class loading triggers execution only for accessed members (memory optimization)
+ Has-a relationships require explicit references; is-a provides inheritance access
+ Main method executes from subclass if available, otherwise superclass
```

### Expert Insight

**Real-world Application:**
In enterprise applications, understanding static execution flow prevents memory leaks and improves startup performance. For example, in Spring Boot applications, static blocks often initialize database connections or configurations - incorrect inheritance usage can cause slow startups or memory waste.

**Expert Path:**
- Master memory diagrams for all inheritance scenarios
- Study JVM class loading mechanisms deeply
- Practice with real frameworks' initialization patterns (Spring, Hibernate)

**Common Pitfalls:**
- **Memory Confusion:** Not recognizing that static variables initialize with defaults before blocks execute
- **Access Misuse:** Attempting direct subclass access from superclass without explicit references
- **Practice Deficiency:** Not creating memory diagrams leads to fundamental misunderstandings
- **Performance Issues:** Improper inheritance can cause unnecessary static member execution in large codebases

**Lesser Known Things:**
- JVM verifies access intent before executing static members
- Forward reference errors only occur within same class boundaries
- Subclass static blocks may not execute even if class loads when only superclass accessed
- Java 8+ optimizes static loading more aggressively than earlier versions

Five key execution principles learned today provide foundation for advanced OOP concepts like polymorphism and design patterns. Practice the 10 test cases thoroughly for mastery.
