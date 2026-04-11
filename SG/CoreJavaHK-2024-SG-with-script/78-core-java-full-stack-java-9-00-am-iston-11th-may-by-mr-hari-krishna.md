# Session 78: Types of Inheritance and Garbage Collection in Java

## Table of Contents

- [Types of Inheritance](#types-of-inheritance)
  - [Overview](#overview)
  - [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
  - [Important Points and Test Cases](#important-points-and-test-cases)
  - [Lab Demos](#lab-demos)
- [Garbage Collection](#garbage-collection)
  - [Overview](#overview-1)
  - [Key Concepts and Deep Dive](#key-concepts-and-deep-dive-1)
  - [Lab Demos](#lab-demos-1)
- [Summary](#summary)
  - [Key Takeaways](#key-takeaways)
  - [Expert Insight](#expert-insight)

> [!IMPORTANT]
> Corrected typos from transcript: "inheritances" should be "inheritances"; "subass" corrected to "subclass"; "superass" to "superclass"; "multi-level" consistently formatted; "unreferenced" standardized; "elig" corrected to "eligible"; "demon thread" to "daemon thread".

## Types of Inheritance

### Overview

Inheritance is a fundamental Object-Oriented Programming (OOP) concept in Java that allows a class to inherit properties and behaviors from another class or interface. Java supports various types of inheritance, which can be categorized based on the relationships between classes and interfaces. This overview explores the five main types: Single-level, Multi-level, Hierarchical, Multiple, and Hybrid inheritance. While Java fully supports all five types with interfaces, it only supports three types (Single-level, Multi-level, and Hierarchical) with classes due to the Diamond Problem or ambiguous error in multiple inheritance scenarios involving classes. Inheritance promotes reusability, forcing behavior in subclasses, and enables dynamic method dispatch.

### Key Concepts and Deep Dive

- **Single-Level Inheritance**:
  - **Definition**: A subclass derives from exactly one superclass. This is the default inheritance in Java, as all classes implicitly extend from `Object` class.
  - **Points**:
    - A class can derive from a class using `extends` or from an interface using `implements`.
    - An interface can only derive from interfaces via `extends`.
    - Every class extends `Object` unless explicitly specified, making it a subclass of `Object`.
  - **Example**:
    ```java
    class A { // Implicitly extends Object
        // Members
    }
    class B extends A { // Single-level from A
        // Inherits A and Object
    }
    ```
  - **Terminology**: Even standalone classes like `class A {}` exhibit single-level inheritance by extending `Object`.

- **Multi-Level Inheritance**:
  - **Definition**: More than two classes or interfaces participate vertically, forming a chain where each subclass is a superclass for the next.
  - **Points**:
    - Direct superclass: The immediate parent (e.g., `B` for `C`).
    - Indirect superclass: A parent further up (e.g., `A` for `C` if `C extends B` and `B extends A`).
    - The `super` keyword refers to the direct superclass. To access indirect superclass members, chain `super.super` (invalid syntax); access is limited to one level up unless overridden.
    - `super` may refer to multiple indirect superclasses, but searches start from the direct one.
    - If a member (variable or method) is overridden, `super` accesses the direct superclass's version; indirect access requires the hierarchy to be non-overridden.
  - **Diagram** (Mermaid):
    ```mermaid
    flowchart TD
        A[Class A] --> B[Class B]
        B --> C[Class C]
    ```
  - **Key Insight**: `super` keyword prioritizes the direct superclass. For vertical relationships, ensure no conflicts in overridden members.

- **Hierarchical Inheritance**:
  - **Definition**: Multiple subclasses derive from a single superclass or interface, creating a tree-like structure where siblings share common parent properties.
  - **Analogy**: Family system with one parent and multiple children (e.g., in older generations simulating multiple child families).
  - **Points**:
    - Common properties/behaviors in the superclass are shared across all subclasses.
    - Specific logic per subclass is unique.
    - Variables/Methods in Superclass:
      - `static`: Common and modifiable (affects all subclasses).
      - Non-static: Unique per object instance (modifications isolated).
    - Interfaces in Hierarchical Context:
      - Variables are constants (`public static final` implicitly).
      - Ensure specifications are type-focused, not implementation-heavy.
  - **Table Comparison** (Common vs. Specific Members):

    | Member Type | Common to Subclasses? | Modifiable Effect | Usage |
    |-------------|------------------------|-------------------|-------|
    | Static Variable | Yes | Affects all | Shared data like family assets |
    | Non-Static Variable | No | Local to object | Specific data like inheritance-specific attributes |
    | Static Method | Shared behavior | Class-level | Categorize common logic |
    | Non-Static Method | Instance-specific | This instance | Differentiated logic per subclass |

  - **Diagram** (Mermaid):
    ```mermaid
    flowchart TD
        A[Superclass A] --> B[Subclass B]
        A --> C[Subclass C]
        A --> D[Subclass D]
    ```

- **Multiple Inheritance**:
  - **Definition**: A class or interface derives from multiple superclasses or interfaces.
  - **Support in Java**: Not supported for classes due to Diamond Problem (ambiguous constructor calls, fields, or methods). Supported for interfaces, but called "Multiple Type Interface Inheritance" since interfaces provide types, not properties or full implementations.
  - **Why Not in Classes**: Diamond Problem leads to ambiguity in invoking superclass constructors or accessing members.
  - **Table Operation** (Multiple Inheritance Scenarios):

    | Scenario | Keyword | Example | Supported? | Notes |
    |----------|---------|---------|------------|-------|
    | Class extends Class | `extends` | `class C extends A, B` | ❌ | Compile error due to Diamond Problem |
    | Interface extends Interface | `extends` | `interface C extends A, B` | ✅ | Multiple type inheritance |
    | Class implements Interface | `implements` | `class C implements A` | ✅ | Reusability/Forcibility |
    | Class extends Class and implements Interface | `extends` → `implements` | `class C extends A implements I` | ✅ | Reusability first, then forcibility |
  - **Syntax Priority**: `extends` before `implements`; compile error otherwise.
  - **Extends vs. Implements**:
    - `extends`: Provides reusability.
    - `implements`: Provides forcibility.
    - Order reflects precedence: reusability over constraint.

- **Hybrid Inheritance**:
  - **Definition**: Combination of multiple inheritance types (e.g., hierarchical with multi-level). Often visualized as complex family trees.
  - **Support**: Same as above; fully supported with interfaces, partially with classes.

- **Class vs. Interface Inheritance**:
  - Classes: Support 3 types (Single-level, Multi-level, Hierarchical); issue with Multiple due to Diamond Problem.
  - Interfaces: Support all 5 types, as they focus on types/geometries.

### Important Points and Test Cases

- **Inheritance with Constructors**:
  - Parameterized constructors in superclass require explicit `super()` calls in subclasses with matching arguments.
- **Override vs. Overload in Inheritance**:
  - Override: Same signature, different implementation.
  - In multi-level, `super` accesses overridden members in direct superclass.

- **Test Cases for Multiple Inheritance**:
  - Case 1: Class extends A (with method M1), implements I1 (with M1); implement M1 once if signatures match.
  - Case 2: Conflicts handled by overriding.
  - Multiple test cases involve various combinations of classes/interfaces with method signatures; document behavior via implementation.

### Lab Demos

- **Demo 1: Single-Level Inheritance**
  1. Define class `Animal` with method `walk()`.
  2. Create `Dog extends Animal`; call `super.walk()`.
  3. Run: `Dog d = new Dog(); d.walk();` // Inherits and overrides behavior.

- **Demo 2: Multi-Level with Super Keyword**
  1. Class `A { void m1() {} }`
  2. Class `B extends A { void m1() {} }`
  3. Class `C extends B { void m1() { super.m1(); } }`
  4. Run: `new C().m1();` // Accesses B's m1 via super.

- **Demo 3: Hierarchical Inheritance**
  1. Class `Person { String name; }`
  2. Classes `Employee extends Person`, `Student extends Person`.
  3. Set shared `name` in both; observe isolated non-static changes.

## Garbage Collection

### Overview

Garbage Collection (GC) is an automatic memory management mechanism in Java that deallocates unused objects from the Heap area, preventing memory exhaustion and runtime errors like `OutOfMemoryError`. Unlike languages like C++, Java does not rely on manual destruction; instead, the JVM uses a daemon thread called Garbage Collector to detect and clean unreferenced objects. The process involves marking objects as "eligible for GC" (similar to a recycle bin) rather than immediate deletion, and destruction occurs when memory is low. Key triggers include unreferencing objects via new assignments, null assignments, or island of isolation; GC can be requested manually via `System.gc()` or `Runtime.getRuntime().gc()`. This ensures efficient resource usage without developer intervention.

### Key Concepts and Deep Dive

- **Heap Area and Objects**:
  - Objects created via `new` are stored in Heap; references in Stack.
  - Unreferenced objects (no variables pointing) are eligible for GC, not immediately destroyed.

- **Ways to Unreference Objects**:
  - **Assign new object**: Removes old reference; old object to eligible list.
  - **Assign null**: Cuts reference; object eligible.
  - **Island of Isolation**: Objects mutually referencing but no external strong reference; considered eligible (weak references).

- **GC Process**:
  - Garbage Collector: Daemon thread in JVM.
  - **Eligible for GC**: Objects in "recycle bin"; `finalize()` method called before destruction.
  - `finalize()`: Override in subclass; runs once per object before potential destruction; can reclaim object.
  - Destruction: When Heap is near full; manual request via `System.gc()` (may be ignored).

- **Strong vs. Weak References**:
  - Strong: External variable references; GC avoids.
  - Weak: Internal mutual; GC treats as unreferenced without strong external link.

- **GC Timing and Control**:
  - Cannot force; request via `System.gc()` (implicit `Runtime.getRuntime().gc()`).
  - `Thread.sleep()` pauses main thread to allow GC execution.
  - Analyze eligibility by drawing diagrams and tracking references.

- **Heap Structure Diagram** (Mermaid):
  ```mermaid
  flowchart TD
      JVM[Java Virtual Machine] --> Heap[Heap Area]
      Heap --> Ob1[Object 1]
      Heap --> Ob2[Object 2 (Eligible)]
      JVM --> Stack[Java Stack Area]
      Stack --> Thread[Main Thread]
      Thread --> Ref[References]
      Ob2 --> GC[Garbage Collector]
  ```

### Lab Demos

- **Demo 1: Basic GC Eligibility**
  1. Class `Example { int x; Example(int x) { this.x = x; System.out.println("Created: " + x); } protected void finalize() { System.out.println("Destroyed: " + x); } }`
  2. In `main`: `Example e1 = new Example(10); e1 = new Example(20); e1 = null; System.gc(); Thread.sleep(100);`
  3. Output: Objects 10 and 20 eligible; finalize calls confirm destruction.

- **Demo 2: Island of Isolation**
  1. Classes: `class Example { Sample s1; int x; } class Sample { Example e1; int y; }`
  2. Create mutual: `Example e = new Example(); Sample s = new Sample(); e.s1 = s; s.e1 = e; e = null; s = null;`
  3. Call `System.gc()`; no external refs, both eligible.

- **Demo 3: Requesting GC**
  1. Similar setup as Demo 1.
  2. Add try-catch for `Thread.sleep(1000)` after `System.gc();`
  3. Observe: May destroy objects; warnings ignored in Java 9+ (deprecated `finalize()`).

## Summary

### Key Takeaways

```diff
+ Inheritance enables code reusability and polymorphism in Java; supports single-level, multi-level, hierarchical with classes; all five with interfaces.
- Multiple inheritance with classes causes Diamond Problem; avoided for ambiguity.
+ Garbage Collection automatically manages memory; unreference objects via new/null/isolations; GC daemon destroys when needed.
- Overriding finalize() is deprecated since Java 9; manual GC requests not guaranteed.
+ Super keyword accesses direct superclass; indirect needs hierarchy checks.
+ Strong references prevent GC; weak ones (mutual) lead to eligibility without external ties.
```

### Expert Insight

- **Real-World Application**: In production JVM applications (e.g., web servers), GC tuning (via JVM flags like `-Xmx`, `-Xms`) optimizes performance by minimizing memory leaks in long-running processes. Use profilers like VisualVM to monitor Heap usage and adjust GC algorithms (e.g., G1 for large Heaps).
- **Expert Path**: Master by analyzing GC logs (`-Xlog:gc`), implement custom reference types (WeakReference), and benchmark inheritance hierarchies for performance. Practice with JMH microbenchmarks for deep-dive efficiency.
- **Common Pitfalls**: Misusing `super` in multi-level chains; assuming GC is immediate (use strong refs for critical objects); Diamond Problem avoidance.
  - **Issue**: Compile errors in multiple inheritance with classes; Resolution: Use interfaces or composition.
  - **Issue**: Memory leaks from unreleased refs in cycles; Resolution: Nullify refs explicitly; Avoid weak referencing for persistent data.
  - **Issue**: `finalize()` blocking GC; Resolution: Avoid overriding; Use try-with-resources.
  - **Lesser Known**: GC pauses can cause application hiccups (GC Pause); mitigated with concurrent collectors. Interfaces allow multiple type inheritance without conflicts. vbNet
