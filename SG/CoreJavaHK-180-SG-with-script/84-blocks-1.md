# Session 84: Blocks

## Table of Contents
- [What is a Block?](#what-is-a-block)
- [Types of Blocks](#types-of-blocks)
- [Static Initializer Blocks](#static-initializer-blocks)
- [Instance Initializer Blocks](#instance-initializer-blocks)
- [Execution Order and Flow](#execution-order-and-flow)
- [Common Problems and Solutions](#common-problems-and-solutions)
- [Lab Demos](#lab-demos)
- [Summary](#summary)

<a id="what-is-a-block"></a>
## What is a Block?

### Overview
A block in Java is a group of statements enclosed within curly braces `{ }`. Blocks define scope and are fundamental to organizing code. They can be class-level (static or instance) or method-level (local). Class-level blocks are used for initialization purposes, while local blocks reduce variable scope.

### Key Concepts
Blocks are declared using open and close braces: `{ ... }`. They support conditional statements, loops, and declarations.

- **Class-Level Blocks**: Executed during class loading or object creation.
- **Local Blocks**: Defined inside methods to limit variable accessibility and improve code organization.

Here is a basic example of a local block:
```java
public class Example {
    public void method() {
        {
            int localVar = 10;
            System.out.println(localVar);  // Accessible only within this block
        }
        // localVar is not accessible here
    }
}
```

<a id="types-of-blocks"></a>
## Types of Blocks

### Overview
Java supports three types of blocks: static initializer blocks, instance initializer blocks, and local blocks. Class-level blocks handle initialization, while local blocks manage variable scoping within methods.

### Key Concepts
- **Static Blocks**: Execute once when the class is loaded.
- **Instance Blocks**: Execute each time an object is created, common to all constructors.
- **Local Blocks**: Reduce scope of variables inside methods.

Static blocks use the `static` keyword, instance blocks are just `{ }`, and local blocks are any `{ }` within a method.

```java
public class BlocksExample {
    static {  // Static initializer block
        System.out.println("Static block");
    }
    
    {  // Instance initializer block
        System.out.println("Instance block");
    }
    
    public void method() {
        {  // Local block
            int x = 5;
        }
    }
}
```

<a id="static-initializer-blocks"></a>
## Static Initializer Blocks

### Overview
Static initializer blocks are executed once when the class is loaded into JVM memory. They are ideal for initializing static variables or performing one-time setup logic.

### Key Concepts
Use the syntax `static { ... }`. Cannot contain return statements and must complete normally.

- **Execution**: Triggered during class loading, before main method or any instance creation.
- **Purpose**: Initialize static variables or run static logic.
- **Rules**: No return, handles exceptions normally.

Example:
```java
public class StaticBlockExample {
    static int value;
    
    static {
        value = 100;
        System.out.println("Static block: Initialized value to " + value);
    }
    
    public static void main(String[] args) {
        System.out.println("Main method");
    }
}
```
Output: Static block: Initialized value to 100\nMain method

Multiple static blocks execute in definition order.

<a id="instance-initializer-blocks"></a>
## Instance Initializer Blocks

### Overview
Instance initializer blocks (also called non-static blocks) execute during object creation, before the constructor. They ensure common logic runs for all constructors without code duplication.

### Key Concepts
Declared as `{ }` (no keyword). Automatically called before constructor logic.

- **Execution**: For each object, after new keyword, before constructor body.
- **Purpose**: Initialize instance variables or run object-specific logic.
- **Rules**: Cannot have return, complete normally. Treat nested blocks as local.

> [!NOTE]  
> Prefer "instance initializer block" over "non-static block" for clarity, as it initializes instance variables.

Compiler decompiles and inserts instance block code into each constructor after super call.

<a id="execution-order-and-flow"></a>
## Execution Order and Flow

### Overview
Execution order is critical: static blocks run at class load, instance blocks at object creation.

### Key Concepts
1. Static variables initialization.
2. Static blocks (top to bottom).
3. Main method.
4. Instance variables initialization.
5. Instance blocks (top to bottom).
6. Constructor.

For objects: new → instance blocks → constructor.

```diff
- Static blocks: Executed once at class load
+ Instance blocks: Executed per object, before constructor
```

Variable shadowing possible but not recommended.

Multiple blocks execute in definition order. Nesting creates local blocks.

<a id="common-problems-and-solutions"></a>
## Common Problems and Solutions

### Overview
Common issues include code redundancy and accidental multiple executions.

### Key Concepts
- **Code Redundancy**: Solved by instance blocks instead of duplicating logic in constructors.
- **Multiple Executions**: Use private methods with Boolean flags to prevent re-calling.

Example with Boolean flag:
```java
public class Example {
    private boolean wished = false;
    
    private void wish() {
        if (wished) {
            throw new IllegalStateException("Already wished");
        }
        System.out.println("Hello");
        wished = true;
    }
    
    public Example() {
        wish();  // Ensure called here
    }
    
    // Process method, check if wished before using object
    public void process() {
        if (!wished) {
            throw new IllegalStateException("Call wish() first in constructor");
        }
        // Process logic
    }
}
```

Instance blocks limit: Only execute before constructor; use methods for middle/end logic.

<a id="lab-demos"></a>
## Lab Demos

### Demo 1: Output Analysis
Create Example class with constructors and observe output order.

```java
public class Example {
    static {
        System.out.println("SIB");  // Static initializer block
    }
    
    {
        System.out.println("IIB");  // Instance initializer block
    }
    
    public Example() {
        System.out.println("NPC");  // No parameter constructor
    }
    
    public Example(int i) {
        System.out.println("IPC");  // In parameter constructor
    }
    
    public static void main(String[] args) {
        Example e1 = new Example();  // Output: SIB (once), IIB, NPC
        Example e2 = new Example(10);  // Output: IIB, IPC
    }
}
```

### Demo 2: Object Counter
Use static variable and instance block to count objects.

```java
public class Example {
    private static int count = 0;
    
    {
        count++;
    }
    
    public Example() {}
    public Example(int i) {}
    
    public static void main(String[] args) {
        new Example();
        new Example();
        new Example(10);
        System.out.println("Objects created: " + count);  // Output: 3
    }
}
```

### Demo 3: Initialization with Different Values
Initialize instance variable differently per object using Scanner in instance block.

```java
import java.util.Scanner;

public class Example {
    int x;
    
    {
        Scanner s = new Scanner(System.in);
        System.out.print("Enter value: ");
        x = s.nextInt();
        System.out.println("Hi");
    }
    
    public Example() { System.out.println("NPC"); }
    public Example(int i) { System.out.println("IPC"); }
    
    public static void main(String[] args) {
        Example e1 = new Example();  // Prompt for input, set x=10, NPC
        Example e2 = new Example(5);  // Prompt for input, set x=20, IPC
        // Each object has unique x value
    }
}
```

### Demo 4: Multiple Instance Blocks
```java
public class Example {
    {
        System.out.println("IIB1");
    }
    
    public Example() {
        System.out.println("Constructor");
    }
    
    {
        System.out.println("IIB2");
    }
    
    public static void main(String[] args) {
        new Example();  // Output: IIB1, IIB2, Constructor
    }
}
```

<a id="summary"></a>
## Summary

```diff
! Key Takeaways:
+ Blocks are { } groups; static blocks run once at class load, instance blocks run before constructors on object creation.
+ Use static blocks for static initialization, instance blocks to avoid constructor code duplication.
+ Syntax: static { ... } for static, { ... } for instance; local blocks { ... } in methods.
+ Execution: Static → Main → Instance → Constructor.
+ Multiple blocks execute top-to-bottom; nesting makes local blocks.
+ Limitations: Instance blocks only pre-constructor; use methods + Boolean flags for post/mid logic.
```

### Expert Insight
**Real-world Application**: Instance blocks initialize shared instance setup (e.g., connecting to databases on object creation). Static blocks load properties files once per class.

**Expert Path**: Master execution flow to optimize startup. Experiment with multiple blocks for modularity. Learn compiler internals (decompiling shows instance code in constructors).

**Common Pitfalls**: Forgetting instance blocks execute pre-constructor; not handling exceptions; re-calling logic via methods without protection. Data loss if logic depends on constructor order. Expect compiler to merge blocks silently – test thoroughly.
