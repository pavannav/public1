# Session 74: Non Static Members and Execution Flow 3

- [Overview of Non-Static Members and Execution Flow](#overview-of-non-static-members-and-execution-flow)
- [Special Functionality of Non-Static Members](#special-functionality-of-non-static-members)
- [Memory Allocation and JV Architecture for Non-Static Members](#memory-allocation-and-jv-architecture-for-non-static-members)
- [Reading and Modifying Non-Static Variables](#reading-and-modifying-non-static-variables)
- [Reference Variables and Types](#reference-variables-and-types)

## Overview of Non-Static Members and Execution Flow

Non-static members in Java, including variables and methods (excluding constructors and blocks), represent instance-specific attributes and behaviors that are tied to individual objects rather than the class itself. Unlike static members that exist once per class, non-static members enable the creation of unique data and functionality for each instantiated object, forms pillar of object-oriented programming by allowing encapsulation of data and operations at the instance level. Execution flow involves object creation via the `new` keyword, initialization through constructors, and access via reference variables, with the JVM managing memory allocation in the heap to support dynamic object instantiation.

## Special Functionality of Non-Static Members

Non-static members provide multiple copies of memory for a single declaration, allowing each object to maintain its own set of values. This is a key feature that supports encapsulation and instance-specific data.

### Key Concepts/Deep Dive

- **Multiple Memory Copies**: Declaring a non-static variable once allows the JVM to allocate separate memory for it in each object created, enabling objects to hold distinct values (e.g., different account numbers for bank account objects).
- **Dynamic Nature of Java**: Java's dynamism stems from runtime memory allocation based on object creation, rather than compile-time decisions. For example, a single variable declaration can result in 'n' copies in memory if 'n' objects are created, contrasting with static members that maintain only one copy.
- **JVM Behavior**: The JVM does not pre-allocate memory for non-static variables during class loading, as it cannot predict the number of objects. Instead, it waits for the `new` keyword to trigger allocation.

```java
// Demonstration: Single declaration, multiple memories
class BankAccount {
    int accountNumber; // Non-static variable declaration

    // Constructor
    BankAccount(int accNum) {
        this.accountNumber = accNum; // Initialize each object differently
    }
    
    public static void main(String[] args) {
        // Loop to create multiple objects dynamically
        for (int i = 1; i <= 3; i++) { // Assume user inputs x=3
            BankAccount acc = new BankAccount(100 + i); // New memory per object
            System.out.println("Account " + i + ": " + acc.accountNumber);
        }
    }
}
```

### Lab Demos

1. Execute the code above and verify that `accountNumber` holds unique values (e.g., 101, 102, 103) for each object, despite one declaration.
2. Modify the loop to use user input for 'x' (via `Scanner`), demonstrating runtime dynamic allocation.

## Memory Allocation and JV Architecture for Non-Static Members

Non-static variables are allocated in the heap area during object creation, with JVM architecture segregating method area (for class-level info), heap (for objects), and stack (for method execution).

### Key Concepts/Deep Dive

- **Class Loading**: When a class is loaded, non-static declarations are stored in the method area, but no memory is allocated yet.
- **Object Creation Steps**: 
  1. Reference variable created in stack (e.g., main thread stack frame).
  2. `new` keyword allocates object memory in heap with default values.
  3. Constructor initializes with provided values via `this`.
- **Memory Diagram Example**:
  - Method Area: Contains class information (e.g., variable declarations).
  - Heap: Object instances (e.g., `Example obj = new Example();` creates object at 0x1010 with X=10, Y=20).
  - Stack: Reference variables point to heap objects.

```java
// Representation of JV Architecture Flow
class Example {
    int x, y;
    
    Example(int x, int y) {
        this.x = x;
        this.y = y;
    }
    
    public static void main(String[] args) {
        Example e1 = new Example(10, 20); // Creates object in heap, reference in stack
        System.out.println(e1.x + " " + e1.y); // Accesses heap values via reference
    }
}
// Output: 10 20
```

### Tables

| Aspect                  | Method Area               | Heap Area                 | Java Stack Area           |
|-------------------------|---------------------------|---------------------------|---------------------------|
| Non-Static Declarations| Stored (no allocation)    | N/A                       | N/A                       |
| Object Instances       | N/A                       | Allocated at runtime     | N/A (but references live here)|
| Reference Variables    | N/A                       | Referenced from stack    | Point to heap objects     |

## Reading and Modifying Non-Static Variables

Non-static variables are accessed via object references (e.g., `obj.variable`), allowing instance-specific reads and updates. Modifications only affect the specific object unless multiple references point to the same object.

### Key Concepts/Deep Dive

- **Access Syntax**: Use dot notation (e.g., `e1.x`) to read/modify values stored in the heap object.
- **Modification Scope**: Changes to one object's variables do not impact others, unless aliases exist (multiple references to the same object).
- **Compiler vs. JVM**: Compiler checks declarations at compile-time (all `obj.variable` resolve to class declarations); JVM resolves to specific heap instances at runtime.

```java
// Demonstration: Independent Objects
Example e1 = new Example(10, 20);
Example e2 = new Example(10, 20);

// Modification: Affects only e1
e1.x = 15;
e1.y = 16;

// Output verification
System.out.println("e1: " + e1.x + " " + e1.y); // 15 16
System.out.println("e2: " + e2.x + " " + e2.y); // 10 20 (unchanged)
```

```java
// Alias Example: Shared Object
Example e1 = new Example(10, 20);
Example e3 = e1; // Aliases same object

e1.x = 18; // Affects e1 and e3
System.out.println("e3: " + e3.x); // 18 (shared)
```

### Lab Demos

1. Run the standalone example, modify values, and observe isolation between objects.
2. Create aliases and demonstrate shared modifications.
3. Print separators (e.g., dots) for readability: `System.out.println(e1.x + "." + e1.y);`.

## Reference Variables and Types

Reference variables store object references, enabling access to non-static members. There are four types based on declaration location and memory timing.

### Key Concepts/Deep Dive

- **Types**:
  1. **Static Reference Variables**: Memory in method area during class loading; objects in heap.
  2. **Non-Static Reference Variables**: Memory in heap at enclosing object creation; objects also in heap.
  3. **Parameter Reference Variables**: Memory in stack at method call; objects in heap.
  4. **Local Reference Variables**: Memory in stack at declaration execution; objects in heap.
- **Lifetime and Scope**: Depends on variable type (e.g., static persists with class, local with method).
- **Differences**: Static enables class-wide sharing; non-static for instance-specific; parameters for method input; locals for temporary use.

```java
// Example with Types
class Example {
    static A a1 = new A(10); // Static: Method Area
    A a2 = new A(10);       // Non-Static: Heap at object creation
    
    void m1(A a3) {         // Parameter: Stack at call
        A a4 = new A(10);   // Local: Stack at execution
        // All reference heap objects, but variables in different areas
    }
    
    class A { int x; A(int val) { x = val; } }
}
```

### Lab Demos

1. Compile and analyze memory for each type in JV architecture diagrams.
2. Simulate calls to `m1` with objects, tracking references.

## Summary

### Key Takeaways
```diff
+ Non-static members enable instance-specific data with multiple memory copies per declaration.
- Static members have one copy; non-static adapt dynamically at runtime.
+ JVM allocates non-static memory in heap via 'new'; references live in stack or method area.
+ Reference variables (4 types) differ by lifetime, scope, and memory location.
```

### Expert Insight

**Real-world Application**: In web apps like e-commerce, non-static variables track user carts individually (e.g., each User's cart object holds unique items), supporting scalability without static concurrency issues.

**Expert Path**: Master JV architecture visualizations; practice complex object hierarchies and garbage collection scenarios. Study JVM specs for deep memory optimization.

**Common Pitfalls**: Assuming modifications propagate across objects—always test independently. Confusion between object and reference equality (use `==` cautiously).
Common issues: `NullPointerException` when accessing uninitialized references; memory leaks from retained local variables. Resolve by ensuring proper initialization and using profilers for heap analysis.

Lesser known things: Reference variables can invoke methods from interfaces/enums without casting; JVM inlines small objects for performance, affecting heap usage patterns.
