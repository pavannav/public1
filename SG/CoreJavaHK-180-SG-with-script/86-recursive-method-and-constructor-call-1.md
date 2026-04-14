# Session 86: Recursive Method and Constructor Call

| Section | Overview |
|---------|---------|
| [Overview](#overview) | Introduction to recursive methods and constructor calls in Java. |
| [Recursive Method Call](#recursive-method-call) | Understanding stack frames and StackOverflowError in recursive methods. |
| [Recursive Constructor Call](#recursive-constructor-call) | How constructors create heap objects vs. stack frames, leading to errors. |
| [Object Creation Scenarios](#object-creation-scenarios) | Analysis of object creation in static blocks, non-static blocks, and class levels. |
| [Execution Flow and Test Cases](#execution-flow-and-test-cases) | Different ways to load classes into JVM and execute static/non-static members. |
| [Summary](#summary) | Key takeaways, expert insights, and homework. |

## Overview

In this session, we explore recursive method calls and recursive constructor calls in Java. These occur when a method calls itself or a constructor creates an instance that triggers the same constructor again. Both scenarios lead to `java.lang.StackOverflowError` due to continuous stack frame creation without proper destruction. The focus is on understanding memory allocation, execution flow, and avoiding common pitfalls like infinite recursion.

> [!IMPORTANT]  
> Recursive calls are terminated with `StackOverflowError` unless there's a proper base case or exit condition.

> [!NOTE]  
> Practice drawing memory diagrams to visualize stack and heap interactions.

## Recursive Method Call

When a method calls itself directly or indirectly, it creates recursive method calls. Each call pushes a new stack frame onto the Java Stack Area.

### Key Concepts

- **Definition**: Calling a method from within the same method is recursive.
- **Stack Behavior**: Stack frames accumulate without being popped, exhausting memory.
- **Error Condition**: JVM throws `java.lang.StackOverflowError` when stack space is insufficient.
- **Heap vs. Stack**: Methods use stack frames, but objects created within them use the heap.

### Code Example: Basic Recursive Method

```java
class Example {
    static void m1() {
        System.out.println("M1 start");
        m1(); // Recursive call
        System.out.println("M1 end"); // Unreachable
    }

    public static void main(String[] args) {
        System.out.println("Main start");
        m1(); // Triggers recursion
        System.out.println("Main end"); // Unreachable due to error
    }
}
```

- **Execution**: `Main start` → `M1 start` → Recursive `M1` calls repeat until stack overflow.
- **Output**: Infinite "M1 start" or `java.lang.StackOverflowError`.
- **Lab Demo Steps**:
  1. Compile: `javac Example.java`.
  2. Run: `java Example`.
  3. Observe: Program terminates with `StackOverflowError`.
  4. Modify: Add a base case like `if (counter > 10) return;` to prevent overflow.

> [!NOTE]  
> Stack frames are destroyed only after recursion unwinds properly.

### Comparison: Recursion Types

| Feature | Method Recursion | Constructor Recursion |
|---------|------------------|-----------------------|
| Memory | Stack frames only | Stack frames + heap objects |
| Trigger | Self-call in method body | `new` keyword in constructor |
| Error | StackOverflowError | StackOverflowError + potential OutOfMemoryError (heap fill) |

## Recursive Constructor Call

Constructor recursion happens when a constructor creates an object of its own class, either directly or via blocks that the compiler moves into constructors.

### Key Concepts

- **Definition**: Calling the same constructor or creating objects that invoke it recursively.
- **Heap Impact**: Each `new` creates heap objects; recursion can exhaust heap space.
- **Compiler Behavior**: Non-static blocks and object creations are embedded into constructors.
- **Error**: `StackOverflowError` precedes or accompanies `OutOfMemoryError` due to heap fill.

### Code Example: Constructor Recursion

```java
class Example {
    Example() {
        System.out.println("Constructor start");
        // Compiler moves object creation here, causing recursion
        // new Example(); // Uncomment to see recursion
        System.out.println("Constructor end");
    }

    public static void main(String[] args) {
        System.out.println("Main start");
        new Example(); // Triggers recursion if uncommented
        System.out.println("Main end");
    }
}
```

- **Execution**: `Main start` → Constructor call → If `new Example()` inside, infinite heap/stack growth.
- **Output Without Recursion**: `Main start`, `Constructor start`, `Constructor end`, `Main end`.
- **Output With Recursion**: `Main start`, repeated `Constructor start`, eventually `StackOverflowError` or `OutOfMemoryError`.

```java
class Example {
    {
        System.out.println("NSB start"); // Non-static block
        new Example(); // Constructor recursion via block
    }

    Example() {
        System.out.println("Constructor start");
        // Non-static block code moved here implicitly
    }
}
```

- **Lab Demo Steps**:
  1. Create file: `Example.java` with constructor recursion.
  2. Compile and run, observe infinite output until error.
  3. Remove `new Example()` to prevent recursion.
  4. Test variations: Object in static block (no recursion), vs. non-static block (recursion).

## Object Creation Scenarios

Object creation in blocks varies: static blocks load once, non-static blocks move to constructors.

### Static Block Object Creation

```java
class Example {
    static {
        System.out.println("SB start");
        // new Example(); // No recursion: static block doesn't embed into constructor
        System.out.println("SB end");
    }
}
```

- **Execution**: `SB start`, object creation, constructor calls once.
- **Output**: `SB start`, constructor messages, `SB end` — no recursion.
- **Reason**: Static blocks execute during class loading, separate from constructors.

### Non-Static Block Object Creation

```java
class Example {
    {
        System.out.println("NSB start");
        new Example(); // Recursion: Compiler moves to constructor
        System.out.println("NSB end");
    }
}
```

- **Execution**: Object creation triggers non-static block, which calls constructor recursively.
- **Output**: Infinite `NSB start`, `StackOverflowError`.
- **Reason**: Non-static blocks embed into constructors, causing self-call.

### Class-Level Variables

Creating objects using instance variables at class level causes recursion for non-static references.

```java
class Example {
    Example e = new Example(); // Non-static var: recursion
    static Example se = new Example(); // Static var: no recursion

    Example() {
        System.out.println("Constructor start");
    }
}
```

- **Lab Demo Steps**:
  1. Define class-level variables.
  2. Run program: Observe recursion from non-static `e = new Example()`.
  3. Change to `static Example e = new Example();` to avoid recursion.
  4. Test parameterized vs. no-parameter constructors: Recursion only if same constructor type invoked.

## Execution Flow and Test Cases

Classes load into JVM via 8 ways: Java command, static access, method calls, object creation, `Class.forName`, `.class` syntax, subclasses, deserialization. Static variables and blocks execute on load; non-static only on instantiation.

### Ways to Load Class

| Method | Members Executed | Trigger Example |
|--------|-------------------|----------------|
| Java command | Static vars/blocks, main | `java Example` |
| Static var access | Static vars/blocks | `Example.a` |
| Static method call | Static vars/blocks, method | `Example.m1()` |
| Object creation | All: static + non-static | `new Example()` |
| `Class.forName` | Static vars/blocks | `Class.forName("Example")` |
| `.class` syntax | None | `Example.class` |
| Subclass extend | Parent static first | `class Sub extends Example` |
| Deserialization | Static vars/blocks | From I/O streams |

### Code Test Case

```java
class Example {
    static {
        System.out.println("Static block");
    }
    
    {
        System.out.println("Non-static block");
    }
    
    Example() {
        System.out.println("Constructor");
    }
    
    public static void main(String[] args) {
        System.out.println("Main");
        // Test various loads
    }
}

class Loader {
    public static void main(String[] args) {
        // Case 1: Java Loader.class (executes all minus NSB if no object)
        // Case 2: Access Example.staticVar
        // Case 3: Example.staticMethod()
        // Case 4: new Example()
        // Case 5: Class.forName("Example")
        // Case 6: Example.class
        // Case 7: Subclass direct usage
    }
}
```

- **Lab Demo Steps**:
  1. Create `Example.java` with full members.
  2. Create `Loader.java` for each load case.
  3. Run with `java -verbose:class Loader` to see JRE class loads.
  4. Observe: Static members always on class load; non-static only on object creation.

## Summary

### Key Takeaways

```diff
+ Recursive method calls use only stack frames, leading to StackOverflowError.
+ Recursive constructor calls create heap objects + stack frames, potentially causing OutOfMemoryError too.
- Avoid object creation in constructors or non-static blocks for the same class.
+ Static artifacts are determined at compile time and fixed at runtime.
- Instance variables and blocks are per-object and can cause recursion if misplaced.
+ Classes load via 8 mechanisms, always triggering static initialization.
- Reference variables alone don't load classes; member access is required.
```

### Expert Insight

**Real-world Application**: Recursive constructors aren't practical; use factories or builders instead. For recursion, apply in algorithms like binary trees or sorting with base cases. In production, monitor stack/heap via JVM flags (`-Xss`, `-Xmx`) or profilers like VisualVM to detect overflows.

**Expert Path**: Master JVM internals by diagramming stack frames (using tools like IntelliJ debugger). Study bytecode with `javap -c` to see compiler-injected code. Advance to advanced patterns: tail recursion optimization (JVM may support), or functional alternatives in Java 8+.

**Common Pitfalls**: 
- Confusing stack/heap: Methods only affect stack; constructors create objects.
- Implicit Recursion: Non-static blocks auto-embed into constructors—always audit.
- Heap Fill: Long-running recursion can exhaust heap before stack in low-RAM scenarios.
- Lesser Known: `StackOverflowError` can throw from recursive static blocks; prevent by avoiding `new` in static contexts.

Homework: Revise OOP basics via provided videos (object-oriented principles, language types). Complete mini-project on bike object prototype. Practice all test cases in material; review recursive method/constructor slides till end of non-static members chapter. Prepare for Monday's 9-10:30 AM class on design models.
