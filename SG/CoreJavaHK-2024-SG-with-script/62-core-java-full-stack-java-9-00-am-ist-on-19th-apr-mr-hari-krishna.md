# Session 62: Static and Non-Static Members Execution Flow in Java

## Table of Contents

- [Introduction to Class Members in Java](#introduction-to-class-members-in-java)
- [Recommended Class Structure](#recommended-class-structure)
- [Static vs Non-Static Members Usage](#static-vs-non-static-members-usage)
- [Automatic Execution of Class Members](#automatic-execution-of-class-members)
- [Java Program Execution Steps](#java-program-execution-steps)
- [Static Members Execution Flow](#static-members-execution-flow)
- [Compiler Optimizations for Static Members](#compiler-optimizations-for-static-members)
- [Non-Static Members Execution Flow](#non-static-members-execution-flow)
- [Object Creation and Member Initialization](#object-creation-and-member-initialization)
- [Multi-Class Execution Flow](#multi-class-execution-flow)

## Introduction to Class Members in Java

### Overview
Java classes can contain up to 10 different types of members that define the behavior and data storage. Understanding these members and their execution order is crucial for writing correct and efficient Java programs. This session builds on previous discussions of static and non-static members, providing detailed execution flow and interview-level insights.

### Key Concepts/Deep Dive
A class in Java typically contains the following 10 types of members:

1. **Static Variables** - Class-level variables that belong to the class itself, shared across all instances.
2. **Non-Static Variables** - Instance-level variables that belong to individual objects.
3. **Static Blocks** - Code blocks that execute once when the class is loaded, used for static variable initialization.
4. **Non-Static Blocks** - Code blocks that execute during object creation, before the constructor.
5. **Constructors** - Special methods for object initialization, called when creating new instances.
6. **Static Methods** - Methods that belong to the class, can be called without creating instances.
7. **Non-Static Methods** - Methods that operate on object instances.
8. **Main Method** - The entry point for Java applications, a special static method.
9. **Static Classes** - Nested classes that can be instantiated without an outer class instance.
10. **Non-Static Classes** - Regular nested classes that require an outer class instance to create.

All these members can be static or non-static, with static members belonging to the class and non-static members belonging to individual objects.

| Member Type | Static Example | Non-Static Example |
|-------------|----------------|-------------------|
| Variable | `static int count` | `int value` |
| Block | `static { ... }` | `{ ... }` |
| Method | `static void print()` | `void print()` |

### Code/Config Blocks
Here's a complete example showing all 10 types of members:

```java
public class ExampleClass {
    // 1. Static variables
    static int staticVar = 10;
    
    // 2. Non-static variables
    int nonStaticVar = 20;
    
    // 3. Static blocks
    static {
        System.out.println("Static block executed");
    }
    
    // 4. Non-static blocks
    {
        System.out.println("Non-static block executed");
    }
    
    // 5. Constructors
    public ExampleClass() {
        System.out.println("Constructor executed");
    }
    
    // 6. Static methods
    static void staticMethod() {
        System.out.println("Static method called");
    }
    
    // 7. Non-static methods
    void nonStaticMethod() {
        System.out.println("Non-static method called");
    }
    
    // 8. Main method
    public static void main(String[] args) {
        System.out.println("Main method executed");
    }
    
    // 9. Static class
    static class StaticInnerClass {
        void method() {
            System.out.println("Static inner class method");
        }
    }
    
    // 10. Non-static class
    class NonStaticInnerClass {
        void method() {
            System.out.println("Non-static inner class method");
        }
    }
}
```

## Recommended Class Structure

### Overview
While Java allows flexible placement of class members, following a recommended structure improves code readability and maintenance. The structure follows a logical sequence from data allocation to business logic.

### Key Concepts/Deep Dive
The recommended structure for placing members in a Java class, ordered from top to bottom:

1. **Static Variables** - Declare all static fields first.
2. **Non-Static Variables** - Declare all instance fields.
3. **Static Blocks** - Static initialization blocks.
4. **Non-Static Blocks** - Instance initialization blocks.
5. **Constructors** - Object initialization methods.
6. **Static Methods** - Class-level methods (including setters/getters for static fields).
7. **Non-Static Methods** - Instance methods, including:
   - Setter methods (for modifying instance data)
   - Getter methods (for accessing instance data)
   - Business logic methods
8. **Main Method** - Program entry point.
9. **Static Inner Classes** - Nested classes.
10. **Non-Static Inner Classes** - Inner classes.

This order ensures proper memory allocation and initialization sequence during runtime.

### Code/Config Blocks
```java
public class BankAccount {
    // Static variables - fields
    static int totalAccounts;
    
    // Non-static variables - fields
    String accountHolder;
    double balance;
    
    // Static blocks
    static {
        totalAccounts = 0;
    }
    
    // Non-static blocks
    {
        balance = 0.0;
    }
    
    // Constructors
    public BankAccount(String accountHolder) {
        this.accountHolder = accountHolder;
        totalAccounts++;
    }
    
    // Static methods
    static int getTotalAccounts() {
        return totalAccounts;
    }
    
    // Non-static methods
    // Setter methods
    public void deposit(double amount) {
        balance += amount;
    }
    
    // Getter methods
    public double getBalance() {
        return balance;
    }
    
    // Business logic methods
    public void processMonthlyInterest() {
        balance *= 1.01;
    }
    
    // Main method
    public static void main(String[] args) {
        // Program logic here
    }
    
    // Static inner class
    static class AccountHelper {
        // Helper methods
    }
    
    // Non-static inner class
    class TransactionHistory {
        // Instance-specific methods
    }
}
```

## Static vs Non-Static Members Usage

### Overview
The choice between static and non-static members depends on whether the data or behavior should be shared across all instances or belong to individual objects. Static members are loaded once per class, while non-static members exist per instance.

### Key Concepts/Deep Dive
**When to use Static Members:**
- When data needs to be shared across all instances (e.g., counters, constants)
- When methods perform operations that don't depend on instance state
- For utility methods that work on static data
- When maintaining class-level state

**When to use Non-Static Members:**
- When data is unique to each instance (e.g., object-specific attributes)
- When methods operate on individual object state
- For instance-specific behavior and data encapsulation

Key differences:
- Static members are executed once per class lifetime
- Non-static members are executed for every object creation
- Static members can be accessed without object creation
- Non-static members require object instances

## Automatic Execution of Class Members

### Overview
Certain class members execute automatically during JVM lifecycle events without explicit method calls. Understanding which members run automatically is essential for program flow analysis.

### Key Concepts/Deep Dive
**Members executed automatically by JVM:**

- **Static Variables** - Memory allocated and initialized during class loading
- **Static Blocks** - Executed during class loading
- **Main Method** - Executed when the Java command is run with the class name
- **Non-Static Variables** - Memory allocated during object creation
- **Non-Static Blocks** - Executed during object creation
- **Constructors** - Executed during object creation

**Members that require explicit calls:**
- Static Methods
- Non-Static Methods  
- Static Inner Classes
- Non-Static Inner Classes

The execution pattern follows:
- Class loading: Static members → Main method
- Object creation: Non-static members → Constructor logic

## Java Program Execution Steps

### Overview
When running a Java program with the `java` command, a specific sequence of steps occurs involving class loading, memory allocation, and method execution.

### Key Concepts/Deep Dive
Steps when running `java ClassName`:

1. **Step 1**: JVM started
2. **Step 2**: Class is loaded into JVM
3. **Step 3**: Static variables memory allocated with default values
4. **Step 4**: Static variable assignments and static blocks executed in declaration order
5. **Step 5**: Main method executed
6. **Step 6+**: Remaining members executed based on program logic (method calls, object creation)

Static members are executed automatically before main, while non-static members execute only during object creation.

## Static Members Execution Flow

### Overview
Static members follow a precise execution order during class loading. Understanding this flow is critical for analyzing program output and passing technical interviews.

### Key Concepts/Deep Dive
The flow occurs in 4 main steps during class loading:

1. **Memory Allocation**: JVM allocates memory for all static variables from top to bottom with default values
2. **Initialization**: Static variable assignments and static blocks execute in the order they appear from top to bottom
3. **Main Method**: Main method executes after initialization
4. **On-Demand Execution**: Static methods and static inner classes execute only when called

Multiple static variables are initialized in their declaration order. Static blocks have the same priority as variable assignments and execute based on source code order.

### Code/Config Blocks
Example program demonstrating static member execution:

```java
public class Example {
    static int a = m1();
    
    static {
        System.out.println("SB1");
        b = 20;
    }
    
    static int b = 10;
    
    static {
        System.out.println("SB2");
    }
    
    static int m1() {
        System.out.println("SV: a");
        return 30;
    }
    
    public static void main(String[] args) {
        System.out.println("main: a=" + a + ", b=" + b);
    }
}
```

Output flow:
1. Class loaded
2. Static variables `a` and `b` memory allocated (0, 0)
3. `a = m1()` executed: prints "SV: a", returns 30, `a` becomes 30
4. Static block SB1 executed: prints "SB1"
5. `b = 10` executed: `b` becomes 10  
6. Static block SB2 executed: prints "SB2"
7. Main method executed: prints "main: a=30, b=10"

## Compiler Optimizations for Static Members

### Overview
Java compilers perform optimizations to improve runtime performance by rearranging class members in the bytecode. Understanding these changes is crucial for predicting execution flow in interviews.

### Key Concepts/Deep Dive
The compiler performs two main optimizations:

1. **Declarations First**: Moves all static variable declarations to the beginning of the class
2. **Single Static Block**: Consolidates all static variable assignments and static blocks into a single static block at the end of the class

Original source code order is preserved in initialization execution, but the bytecode is rearranged for efficiency. This prevents multiple passes through the class during execution.

For example:
- Original: `static int a = 10; static { a = 20; }`
- Compiler rearranges to bytecode equivalent of: `static int a; static { a = 10; a = 20; }`

This ensures fast execution without multiple top-to-bottom traversals.

### Code/Config Blocks
Compiler transformation example:

Original code:
```java
public class Optimized {
    static int a = m1();
    static int b;
    
    static {
        b = m2();
    }
    
    static int c = 30;
    
    static {
        System.out.println("Final SB");
    }
    
    static int m1() { return 10; }
    static int m2() { return 20; }
    
    public static void main(String[] args) {
        System.out.println("main");
    }
}
```

Equivalent execution after compilation:
```java
public class Optimized {
    static int a;
    static int b; 
    static int c;
    
    static {
        a = m1();     // 10
        b = m2();     // 20  
        c = 30;
        System.out.println("Final SB");
    }
    
    // Main method here
}
```

## Non-Static Members Execution Flow

### Overview
Non-static members execute during object creation, following a similar but per-instance pattern to static members. Key differences include constructor involvement and execution timing.

### Key Concepts/Deep Dive
Non-static execution occurs in 4 steps during object creation:

1. **Memory Allocation**: JVM allocates memory for all non-static variables with default values
2. **Initialization Sequence**: 
   - Constructor called
   - Non-static variable assignments and non-static blocks execute in declaration order
   - Constructor logic completes
3. **On-Demand Execution**: Non-static methods and inner classes execute when called

Unlike static members (executed once per class), non-static members execute once per object instantiation.

Priority during initialization:
1. Constructor called first
2. Non-static variable assignments
3. Non-static blocks
4. Remaining constructor logic

## Object Creation and Member Initialization

### Overview
Object creation involves multiple steps beyond the `new` keyword, including memory allocation, initialization, and constructor execution. Understanding this process is essential for debugging and performance analysis.

### Key Concepts/Deep Dive
When executing `Example e1 = new Example();`:

1. **Memory Allocation**: `new` keyword allocates memory for non-static variables in heap
2. **Constructor Invocation**: `new` calls the appropriate constructor
3. **Object Reference**: `this` keyword references the current object
4. **Initialization Order**:
   - Super class initialization (if extends)
   - Non-static variable assignments
   - Non-static blocks
   - Constructor body execution

Complex example with multiple constructors and blocks:

```java
public class ComplexExample {
    int x = 10;
    
    {
        System.out.println("NSB1: x = " + x);
        x = 15;
    }
    
    int y;
    
    {
        System.out.println("NSB2: y = " + y);
        y = 25;
    }
    
    public ComplexExample() {
        System.out.println("Constructor: x = " + x + ", y = " + y);
        x = 30;
        y = 35;
    }
    
    public static void main(String[] args) {
        ComplexExample obj = new ComplexExample();
    }
}
```

Output: NSB1: x = 10, NSB2: y = 0, Constructor: x = 15, y = 25
Final: x = 30, y = 35

### Code/Config Blocks
Complete object creation example:

```java
public class Demo {
    int x = 10;
    
    {
        System.out.println("NSB1");
        x = 20;
    }
    
    int y;
    
    {
        System.out.println("NSB2"); 
        y = 30;
    }
    
    public Demo() {
        System.out.println("Constructor");
        x = 40;
        y = 50;
    }
    
    public static void main(String[] args) {
        System.out.println("main method");
        Demo d = new Demo();
        System.out.println("d.x = " + d.x + ", d.y = " + d.y);
    }
}
```

Execution flow:
1. Class loaded
2. Main method starts
3. Object creation begins
4. Non-static variables memory allocated
5. Constructor called
6. Non-static initialization executed
7. Constructor body executed
8. Object reference assigned

## Multi-Class Execution Flow

### Overview
Programs often span multiple classes, requiring understanding of how execution flows between classes. Static members of other classes execute during first access, while object creation follows familiar patterns.

### Key Concepts/Deep Dive
When accessing static members from other classes:

```java
public class ClassA {
    static int value = 10;
    static {
        System.out.println("ClassA static block");
    }
}

public class ClassB {
    public static void main(String[] args) {
        System.out.println(ClassA.value); // Triggers ClassA loading
    }
}
```

Loading sequence:
1. JVM loads ClassB
2. ClassB static initialization
3. ClassB main method
4. First access to ClassA triggers its loading
5. ClassA static initialization occurs
6. ClassA static members become available

This ensures classes are loaded on-demand, improving startup performance.

## Summary

### Key Takeaways
```diff
+ Static members execute during class loading: memory allocation → initialization → main method
+ Non-static members execute during object creation: memory allocation → initialization → constructor
+ Compiler optimizes static member arrangement for performance
+ Static blocks and variable assignments execute in source code declaration order
+ Constructors initialize non-static members and complete setup logic
- Avoid confusing static and non-static execution flow in interviews
+ Master execution order to predict program output accurately
- Common mistake: expecting static variable access to re-execute variable assignment
```

### Expert Insight

**Real-world Application**: Understanding member execution flow is crucial for debugging initialization issues in frameworks like Spring, where static blocks configure application-wide resources and constructors handle dependency injection.

**Expert Path**: Practice with complex class hierarchies involving inheritance, where super class initialization must complete before subclass members. Study JVM bytecode using `javap` to verify compiler optimizations. Master all execution scenarios for SDE interviews.

**Common Pitfalls**: 
- Mistaking memory allocation for initialization, causing NullPointerExceptions
- Forgetting super() calls in constructors affect initialization order
- Assuming static blocks execute after main method, leading to incorrect execution expectations
- Not accounting for compiler rearrangements when analyzing bytecode flow

**Lesser Known Things**: 
- Static final variables are compile-time constants that skip runtime initialization
- Anonymous static blocks can exist in interfaces from Java 8+
- JVM class initialization is thread-safe per the Java Language Specification
- HotSpot JVM performs additional runtime optimizations beyond compiler changes, potentially reordering field initialization for better performance
