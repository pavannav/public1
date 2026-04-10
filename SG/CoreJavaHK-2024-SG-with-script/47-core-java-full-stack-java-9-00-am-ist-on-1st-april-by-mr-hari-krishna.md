# Session 47: Variables in Java

## Table of Contents
- [Need of Variable](#need-of-variable)
- [What is a Variable](#what-is-a-variable)
- [Syntax to Create a Variable](#syntax-to-create-a-variable)
- [Primitive vs Reference Data Type Variables](#primitive-vs-reference-data-type-variables)
- [Variable Limitation](#variable-limitation)
- [Variable Terminology](#variable-terminology)
- [When to Create Variable](#when-to-create-variable)
- [Where to Create Variable](#where-to-create-variable)
- [Types of Variables](#types-of-variables)
- [Static Variables](#static-variables)
- [Static Variable Access](#static-variable-access)

## Need of Variable

### Overview
In this chapter, we learn how to store data in a program by using variables. Specifically, we cover storing data of an object and data of an operation. Variables are declared using data types and are essential for reusing values across a program without repeating calculations or object creation.

### Key Concepts/Deep Dive
- **Storing Data of an Object**: Use reference variables to hold objects created with `new` keyword.
- **Storing Data of an Operation**: Use primitive or reference variables to store results of method calls or operations.
- **Reuse Principle**: Create variables only when you need to reuse a value or object multiple times to avoid unnecessary memory usage and performance overhead.

### Code/Config Blocks
```java
// Example: Storing value in primitive variable
int p = 50;  // Direct value assignment
// Example: Storing method call result
int q = m1();  // Non-void method returns value
// Example: Storing object reference
Example e1 = new Example();  // Reference variable pointing to object
```

### Tables
| Variable Type | Stores | Example |
|---------------|--------|---------|
| Primitive | Mathematical Value | `int age = 25;` |
| Reference | Object Reference | `String name = "John";` |

⚠️ **Tip**: Always visualize memory allocation as JVM does—analyze, realize, and visualize each statement.

## What is a Variable

### Overview
A variable is a named memory location used for temporarily storing a value or an object reference during program execution. It provides a way to manage and manipulate data dynamically.

### Key Concepts/Deep Dive
- **Named Memory Location**: Variables act as identifiers for memory spots allocated by the JVM.
- **Temporary Storage**: Data is held only during execution; lost when the program ends.
- **Value or Reference**: Can store direct values (primitive) or pointers to objects (reference).

### Code/Config Blocks
```java
// Primitive variable creation
int x = 10;  // Stores value directly
// Reference variable creation
String s = new String("Hello");  // Stores reference to object
```

## Syntax to Create a Variable

### Overview
The basic syntax for creating a variable is: `data_type variable_name = value;`. This declares the type, name, and optionally initializes it.

### Key Concepts/Deep Dive
- **Data Type**: Specifies what kind of data (e.g., `int`, `String`).
- **Variable Name**: Follows identifier rules.
- **Value**: Optional; can be literal, method call, or object reference.
- **Compiler Check**: Verifies syntax, memory allocation, and type compatibility.

### Code/Config Blocks
```java
int num = 100;  // Primitive with value
String text;   // Reference without value (empty reference)
```

## Primitive vs Reference Data Type Variables

### Overview
Primitive variables store direct values; reference variables store memory addresses pointing to objects. Primitive types are efficient for calculations, while references handle complex data.

### Key Concepts/Deep Dive
- **Primitive Variables**: Use primitive types like `int`, `char`. Store data directly in memory.
- **Reference Variables**: Use class types like `String`. Store object references; actual data is in heap.
- **Key Differences**:
  - **Value Storage**: Primitive holds data; reference holds address.
  - **Memory Management**: Primitives are stack-based; references point to heap objects.
  - **Object Creation**: Primitives don't need `new`; references often do, but `String` allows direct literals.

### Code/Config Blocks
```java
// Primitive
int age = 30;  // Direct value
// Reference (String allows both)
String name1 = "Alice";  // Special case: no new
String name2 = new String("Alice");  // Using new
```

### Tables
| Aspect | Primitive Variable | Reference Variable |
|--------|-------------------|--------------------|
| Stores | Direct value | Object reference |
| Memory | Stack | Stack (ref), Heap (object) |
| Example | `int x = 5;` | `String s = new String("Hi");` |
| Special Cases | None | String allows `String s = "Hi";` |

## Variable Limitation

### Overview
Variables can store only one value or object reference at a time. Attempting to store another replaces the previous, potentially leading to garbage collection for discarded objects.

### Key Concepts/Deep Dive
- **Single Slot Storage**: Memory slot holds one item; replacement overwrites.
- **Garbage Collection**: Old objects become eligible when replaced, unless referenced elsewhere.
- **Object Reuse**: Excessive object creation without reuse wastes memory.

### Code/Config Blocks
```java
Example obj = new Example();  // Initial reference
obj = new Example();  // Old object eligible for GC; new reference stored
```

## Variable Terminology

### Overview
Variable terminology includes five operations: declare, define, initialize, assign, and access (or read). These terms describe lifecycle stages performed on variables.

### Key Concepts/Deep Dive
- **Declare**: Create a new variable without value (empty memory).
- **Define**: Create and assign initial value at once.
- **Initialize**: Store first value in an existing empty variable.
- **Assign**: Replace existing value in a declared variable (second time onward).
- **Access/Read**: Retrieve and use the stored value.

### Code/Config Blocks
```java
int x;           // Declare: empty variable
int y = 10;      // Define: variable with value
x = 5;           // Initialize: first value to x
x = 20;          // Assign: replace value in x
System.out.println(x);  // Access/Read: retrieve value
```

## When to Create Variable

### Overview
Create variables when you need to reuse values or objects multiple times. Otherwise, use values directly to save memory and avoid performance overhead.

### Key Concepts/Deep Dive
- **Reuse Criteria**: If value/object used once, direct usage; multiple times, store in variable.
- **Performance Impact**: Unnecessary variables consume extra memory and CPU cycles.
- **Object Creation**: For objects, prefer variables only if accessing multiple members.

### Code/Config Blocks
```java
// Bad: Unnecessary variable
int temp = getTemp();
print(temp);  // Single use; direct call better
// Good: Reuse
int score = calculateScore();
updateScore(score);
displayScore(score);
```

## Where to Create Variable

### Overview
Variables can only be declared inside classes or methods, not at file level (leads to compilation error). Class-level variables (fields) are shared, while method-level are scoped locally.

### Key Concepts/Deep Dive
- **Scope Restriction**: Only inside class body or method body.
- **File Level**: Attempts cause "class, interface, or enum expected" error.
- **Class vs. Method**: Class-level for sharing across methods; method-level for operation-specific data.

### Code/Config Blocks
```java
class Example {
    int classVar;  // Class-level (instance variable)
    
    void method() {
        int methodVar;  // Method-level (local variable)
    }
}
// Invalid: int globalVar;  // File level - error
```

## Types of Variables

### Overview
Variables are categorized as class-level (static/non-static, instance-level) or method-level (parameters/local). Based on data type, they are primitive or reference.

### Key Concepts/Deep Dive
- **Based on Place**:
  - Class-level: Static (common memory) and non-static (per object).
  - Method-level: Parameters (passed to methods) and local variables (inside methods).
- **Based on Data Type**:
  - Primitive: Direct value storage.
  - Reference: Object pointer storage.
- **Purpose**:
  - Static: Common values to all objects/methods.
  - Non-Static: Instance-specific values.
  - Parameters: Input to methods.
  - Local: Temporary method data.

### Tables
| Type | Location | Memory Copy | Example |
|------|----------|-------------|---------|
| Static | Class | One (common to all) | `static int count;` |
| Non-Static | Class | Per object | `int id;` |
| Parameter | Method Signature | Per call | `void method(int param)` |
| Local | Inside Method | Per execution | `int temp;` |

## Static Variables

### Overview
Static variables are declared with the `static` keyword inside a class, outside methods. They provide one shared memory copy, common to all objects and methods.

### Key Concepts/Deep Dive
- **Declaration**: `static data_type var_name;`
- **Memory Allocation**: One copy when class loads into JVM; no need for object creation.
- **Lifetime**: Exists from class loading until JVM shutdown.
- **Purpose**: Store common values shared across objects/orders.
- **Default Value**: Same as non-static (e.g., 0 for int, null for reference).
- **Access**: Before object creation, method calls irrevocable.
- **Static Context Rule**: Static members can access other static members directly.

### Code/Config Blocks
```java
class BankAccount {
    static String branch = "Main Branch";  // One copy for all accounts
}
```

## Static Variable Access

### Overview
Static variables are accessible in four ways: directly by name, class name, object reference, or null reference, since memory is always available.

### Key Concepts/Deep Dive
- **Direct Access**: `branch` (if in same class).
- **Class Name**: `BankAccount.branch`.
- **Object Reference**: `account.branch` (searches class first).
- **Null Reference**: `nullVar.branch` (as type allows class access).
- **Visualization**: Reference variables point to class memory (static) and instance memory (non-static via object).

### Code/Config Blocks
```java
class Example {
    static int a = 10;
    int b = 20;

    public static void main(String[] args) {
        Example e1 = new Example();
        Example e2 = null;
        
        System.out.println(a);       // Direct: 10
        System.out.println(Example.a); // Class name: 10
        System.out.println(e1.a);    // Object ref: 10
        System.out.println(e2.a);    // Null ref: 10
    }
}
```

## Summary

### Key Takeaways

```diff
+ Variables are named memory for temporary data storage.
+ Primitive variables store values; references store object pointers.
+ Static variables: one copy, shared across all.
+ Create variables only for reuse to optimize performance.
- Avoid unnecessary variables; they waste memory.
- File-level declarations cause compilation errors.
! Declare static variables for common data, not instance-specific.
! Always visualize JVM memory flow for understanding.
+ Access static variables via direct name, class, object, or null reference.
```

### Expert Insight

#### Real-world Application
In enterprise applications like banking systems, static variables store shared constants (e.g., `static double INTEREST_RATE = 4.5;`) across all account objects, ensuring consistency and memory efficiency. For example, in a multi-user web app, use static maps for cached data accessible by all instances.

#### Expert Path
Master variable scoping by practicing heap/stack diagrams in diagramming tools like Draw.io. Advance to concurrency: understand how static variables can lead to race conditions in multi-threaded apps, and use `volatile` or locks. Study Java 10+ local variable type inference (`var`) for cleaner code. Aim for certifications like OCP; focus on JVM internals via tools like VisualVM.

#### Common Pitfalls
- **Misplacing Declarations**: Attempting file-level variables causes "class expected" errors; always inside class/method.
- **Static Misuse**: Using static for per-object data leads to bugs, as all objects share the same value; use instance variables instead.
- **Garbage Collection Oversights**: Replacing references without saving old ones can cause unexpected memory leaks if indirect references exist.
- **Performance Overheads**: Creating variables for single-use values slows execution; profile with JMH to identify bottlenecks.
- **Typo in Access**: Wrong access (e.g., non-static via static context) results in "non-static variable cannot be referenced from a static context".

#### Lesser Known Things About This Topic
- **String Interning**: `String` literals are pooled, so `String s1 = "Hi"; String s2 = "Hi";` share the same reference, unlike `new String("Hi")`.
- **Anonymous Objects**: Unreferenced objects like `new Example().method();` are created but garbage-collected immediately after use.
- **Static Blocks**: Static variables can be initialized in static blocks for complex logic: `static { count = initValue(); }`.
- **Reference Equality vs. Value Equality**: For references, `==` checks address; use `.equals()` for content comparison.
- **JVM Loading Order**: Static variables initialize before `main()`, ensuring availability; error if accessing uninitialized static in other static contexts.
