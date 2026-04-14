## Session 77: Non Static Members and Execution Flow 4

### Table of Contents
- [Types of Objects Based on Reference](#types-of-objects-based-on-reference)
- [Non-Static Method](#non-static-method)
- [Why Non-Static Method](#why-non-static-method)
- [How to Create Non-Static Method](#how-to-create-non-static-method)
- [Does JVM Execute Non-Static Method Automatically?](#does-jvm-execute-non-static-method-automatically)
- [Can Developer Execute Non-Static Method?](#can-developer-execute-non-static-method)
- [Rules in Calling Non-Static Method](#rules-in-calling-non-static-method)
- [Non-Static Method Execution Flow with JVM Architecture](#non-static-method-execution-flow-with-jvm-architecture)
- [Accessing Non-Static Variable from Non-Static Method](#accessing-non-static-variable-from-non-static-method)
- [This Keyword](#this-keyword)
- [JVM Memory Diagrams for Non-Static Members](#jvm-memory-diagrams-for-non-static-members)

## Types of Objects Based on Reference

### Overview
Based on reference variables, objects can be classified into two types: referenced objects and unreferenced (or anonymous) objects. A referenced object is one where its address is stored in a reference variable, allowing access to its members. An unreferenced object exists in memory but has no reference pointing to it, making it inaccessible for direct operations.

### Key Concepts/Deep Dive
- **Referenced Object**: Created by assigning a `new` instance to a variable (e.g., `Example e1 = new Example();`). The reference variable holds the heap address, enabling method calls and property access.
- **Unreferenced (Anonymous) Object**: Created directly with `new` without assignment (e.g., `new Example();`). The object exists in heap but can't be accessed as its reference is lost.
- Anonymous objects are useful for one-time operations, like passing to methods, but heap remains occupied until garbage collection.
- **Memory Impact**: Referenced objects persist as long as references exist; unreferenced ones are eligible for GC after creation.
- **Empty Objects**: If a class lacks non-static variables, creating an object still allocates minimal heap space for the instance, termed an "empty object" or "dummy object".

```bash
# Example: Anonymous object creation (one-time use)
new Example().someMethod();  // Method executed, reference lost
```

## Non-Static Method

### Overview
A non-static method is an instance method defined without the `static` keyword, designed to operate on object-specific data. It encapsulates business or initialization logic that interacts with non-static (instance) variables.

### Key Concepts/Deep Dive
- **Definition**: Methods declared without `static` are non-static and are associated with individual objects.
- **Purpose**: To execute logic that depends on per-object state, unlike static methods which are class-level.
- Non-static methods can access both static and non-static members but are invoked on instances.
- In bytecode, these methods are called instance methods and include implicit `this` reference.

```java:Example.java
class Example {
    void nonStaticMethod() {
        // Instance logic here
    }
}
```

## Why Non-Static Method

### Overview
Non-static methods are essential for implementing object-specific behavior, allowing code to manipulate unique instance data. This promotes object-oriented principles by ensuring methods work with the data of the specific object they're called on.

### Key Concepts/Deep Dive
- **Business/Initialization Logic**: Used for core application logic (e.g., processing user data) that varies per object, or initializing object state post-creation.
- **Object Data Dependency**: Designed to access and modify non-static variables, which are object-specific.
- **Versus Static Methods**: Static methods handle class-level tasks (e.g., utility functions); non-static methods for instance-level operations like `calculateTotalForUser()`.
- **Design Principle**: If logic needs to interact with instance variables (e.g., `this.x`), use non-static methods to ensure the right object's data is used.
- **Interview Perspective**: For logic tied to a single object's data or for developing object-specific business flows.

## How to Create Non-Static Method

### Overview
Creating a non-static method involves omitting the `static` keyword in the method declaration. The method becomes part of the class blueprint but requires an object for execution.

### Key Concepts/Deep Dive
- **Syntax**: Declare methods without `static`, e.g., `public void myMethod() {}`.
- **Access Modifiers**: Can use `public`, `private`, `protected`, or package-private.
- **Parameters and Return Types**: Support all Java types, enabling flexible APIs.
- **Method Body**: Contains logic that can reference `this` implicitly for instance members.
- **Compilation**: Compiler generates bytecode with method stored in method area, but execution requires object instantiation.

## Does JVM Execute Non-Static Method Automatically?

### Overview
The JVM does not automatically execute non-static methods upon program startup. Non-static methods must be explicitly invoked via object references, unlike static methods (e.g., `main`) which can run directly.

### Key Concepts/Deep Dive
- **JVM Startup Behavior**: JVM loads classes into method area but only executes static methods like `main` or blocks automatically.
- **Non-Static Exclusion**: No implicit execution for non-static methods; they wait for developer calls.
- **Memory Allocation**: Even after object creation, JVM doesn't trigger method execution—only setup occurs.
- **Reason**: Non-static methods depend on object state, so auto-execution would be contextually invalid.
- **Proof**: Attempting a class run without object-based calls (e.g., `java Example`) skips non-static methods entirely.

```bash
# Example: JVM output shows only static content
java Example
# Output: main  (static method executed; non-static ignored)
```

## Can Developer Execute Non-Static Method?

### Overview
Yes, developers can and must execute non-static methods using object references. The JVM delegates control to developers for non-static method invocation during program flow.

### Key Concepts/Deep Dive
- **Invocation Requirement**: Developers create objects and use dot notation (e.g., `obj.method()`) to call non-static methods.
- **Control Flow**: Programmer-initiated, not JVM-managed, allowing custom execution based on logic needs.
- **Validation**: Direct calls (e.g., `method()`) fail at compile-time; only object-based calls succeed.
- **Execution Context**: Methods run in the context of the calling object's heap data.

## Rules in Calling Non-Static Method

### Overview
Calling non-static methods mandates object reference usage. Direct method names without objects lead to compilation errors, enforcing object-oriented encapsulation.

### Key Concepts/Deep Dive
- **Rule 1: Object Reference Required**: Always invoke via `reference.method()` (e.g., `e1.m1()`); no standalone calls.
- **Compiler Enforcement**: Attempts like `m1()` yield "cannot be referenced from static context" or similar errors.
- **Reason**: Methods depend on object state; references ensure the correct heap data is targeted.
- **Memory Guarantee**: Object creation provides non-static variable memory, enabling method execution.
- **Exception**: Overrides occur for static calls on objects, but the object reference is ignored (dummy reference).

```java:Example.java
class Example {
    void m1() { }
    public static void main(String[] args) {
        // e1.m1();  // Valid call
        // m1();     // Invalid: Compile error
    }
}
```

## Non-Static Method Execution Flow with JVM Architecture

### Overview
Non-static method execution involves JVM thread management, stack frame creation, and heap object interactions. The process allocates stack space, loads method/instruction pointers, and operates on object-specific data.

### Key Concepts/Deep Dive
- **JVM Areas Involved**: Method area (stores logic), heap (objects), Java stack (execution frames per thread).
- **Execution Steps**:
  1. Object instantiation creates heap instance.
  2. Method call triggers separate stack frame in main thread.
  3. Frame loads logic from method area via instruction pointer.
  4. Parameters/locals allocated in frame; `this` points to current heap object.
  5. Instructions execute sequentially, accessing heap via `this`.
  6. Frame destruction returns control; invalidated locals/parameters destroyed.
- **Stack Frame Contents**: Method logic, local variables, parameters (implicit `this`), operand stack, and reference frame pointers.
- **Multi-Object Behavior**: Same method logic executes per object; `this` dynamically points to caller object.
- **Threading**: Each thread maintains its stack; concurrent calls result in parallel frames.

```diff
- Client Request → Node → Kube Proxy → [Routing Logic] → Correct Pod
```

### Lab Demo: Non-Static Method Execution
1. Create `Example.java` with int x = 10 and void m1() { System.out.println("M1"); }.
2. Compile with `javac Example.java`.
3. Run `java Example` → Executes main; outputs "main" (static method executed).
4. Modify main to add `Example e1 = new Example(); e1.m1();`.
5. Recompile and run → Outputs "main" followed by "M1" (non-static method executed).
6. Observe stack traces or debuggers for frame visualization.

## Accessing Non-Static Variable from Non-Static Method

### Overview
Non-static methods can directly access non-static variables via `this` reference, reading/writing object-specific state without explicit object notation within the method scope.

### Key Concepts/Deep Dive
- **Direct Access**: Variables named directly (e.g., `x`) resolve to `this.x` in non-static contexts.
- **Implicit `this` Usage**: Compiler prepends `this.` to instance variable references.
- **Memory Semantics**: Accesses heap-stored variables via `this`; changes persist across method calls.
- **Dynamic Binding**: `this` ensures the correct object's variables are manipulated based on caller.
- **Contrast to Static**: Static methods cannot access non-static variables directly; require explicit object references.
- **Guarantee of Memory**: Object creation ensures variable existence during method execution.

```java:Example.java
class Example {
    int x = 10;
    void m1() {
        System.out.println("x value: " + x);  // Accessing x (implicit this.x)
    }
    public static void main(String[] args) {
        Example e1 = new Example();
        e1.m1();  // Outputs: x value: 10
    }
}
```

## This Keyword

### Overview
`this` is a reserved keyword referencing the current object within non-static methods or constructors. It enables explicit access to instance variables/methods and resolves ambiguity in variable shadowing.

### Key Concepts/Deep Dive
- **Definition**: A final reference parameter implicitly added by compiler to non-static methods/constructors, storing the current object reference.
- **Usage**:
  - Access instance members: `this.x` or `this.method()`.
  - Disambiguate shadowed variables: When local/parameters name-clash with fields.
  - Pass current object: As method arguments or return values.
- **Type**: Current class type (e.g., `Example this`).
- **Immutability**: Final reference; cannot reassign to null/other objects.
- **Availability**: Restricted to non-static contexts (methods, constructors, blocks); inaccessible in static or class-level scopes.
- **Compiler Changes**: Adds `final Example this` as first parameter; prepends `this.` to unqualified instance accesses.
- **JVM Execution**: Passes caller object reference as first argument; `this` points to executor object's heap location.

```java:Example.java
class Example {
    int x = 10;
    void m1(int x) {
        this.x = x;  // Assigns parameter to instance variable
    }
}
```

### Lab Demo: This Keyword and Variable Access
1. Define class with int x = 10; void m1() { System.out.println(x); }.
2. Create multiple objects; modify x values independently.
3. Call m1() on each; outputs reflect per-object x values.
4. Introduce local x in m1(); observe shadowing; use this.x to access instance.
5. Compile and run; verify heap modifications via this persist post-method.

## JVM Memory Diagrams for Non-Static Members

### Overview
JVM allocates memory hierarchically: method area for class-level data, heap for objects, stacks for executions. Non-static variables get per-object heap space; methods share method area copies.

### Key Concepts/Deep Dive
- **Method Area**: Stores class metadata, static variables/methods, shared non-static method skeletons.
- **Heap Area**: Per-object allocation: instance variables only (non-static; no separate method copies).
- **Java Stack**: Per-thread; each invocation creates frames with locals, `this`, and instruction pointers.
- **Multi-Object Scenario**: Shared method area code; unique heap variables per object; `this` in frames points to calling object.
- **Creation Flow**: Class load → Method area placement → Object instantiation → Heap variable allocation → Method calls → Stack frame setup.
- **Key Insight**: Methods/common logic not duplicated per-object; `this` enables object-specific execution.
- **Diagram Representation**: Visualize main thread stack, heap objects, method area linkages.

```mermaid
flowchart TD
    A[Method Area: Example class<br>Static vars/methods<br>Non-static method bytecode] --> B[Heap Area<br>Object1: x=15<br>Object2: x=16]
    B --> C[Java Stack<br>Main Thread Frame: locals e1, e2]
    C --> D[Non-Static Call: e1.m1()<br>Sub-frame: this -> Object1, locals]
    D --> E[Execution: sysout(x via this)<br>Return, frame destroy]
```

---

## Summary

### Key Takeaways
```diff
+ Non-static methods require object references for invocation and operate on per-object data.
+ `this` keyword enables dynamic access to current object's members within non-static contexts.
+ JVM manages execution via stack frames, ensuring thread-safe, object-specific logic flow.
+ Memory allocation separates class-level (method area) and instance-level (heap) resources.
- Direct non-static method calls outside objects result in compile errors.
- Static methods cannot directly access non-static variables without object references.
```

### Expert Insight

#### Real-world Application
In enterprise Java applications (e.g., Spring Boot services), non-static methods implement controller endpoints accessing user-session scoped data via instance variables. `this` ensures thread-local behavior, allowing concurrent user requests to manipulate individual object states without interference.

#### Expert Path
Master method invocations and override semantics by experimenting with polymorphism: create subclasses overriding non-static methods, observe `this` pointing to actual (runtime) object types. Utilize debuggers like IntelliJ IDEA to visualize stack frames and heap states during execution. Dive into bytecode with `javap -c ClassName` to confirm compiler-added `this` parameters.

#### Common Pitfalls
- **Attempting Direct Calls**: Forgetting object requirement leads to "non-static method cannot be referenced from static context" errors—always use `e1.method()`.
- **Variable Shadowing Confusion**: Local variables hiding fields; explicit `this.field` prevents bugs— practice with name collisions.
- **Incorrect Memory Assumptions**: Believing non-static methods copy per-object; analyze heap/method area via profilers to confirm shared bytecode.
- **Resolving Common Issues**:
  - NullPointerException in non-static calls: Ensure object instantiation pre-call; debug uninitialized references.
  - Heap exhaustion: Anonymous objects accumulate without references—employ GC monitoring (e.g., VisualVM) and avoid long-lived unreferenced instances.
  - Lesser Known: `this` escape during construction can cause visibility issues in multi-threaded code—pass `this` only post-object initialization to prevent immature state access.

**Mistakes and Corrections in Transcript**:
- "meod" corrected to "method" throughout.
- "refferenced" corrected to "referenced".
- "authomatic" corrected to "automatic".
- "me memoriry" corrected to "method memory".
- "final referenced variable of current class type" clarified as "parameter final referenced variable" in material correction.
