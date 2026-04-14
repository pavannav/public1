# Session 95: Java 8 New Features - Lambda Expressions

## Table of Contents
- [Introduction to Functional Interfaces](#introduction-to-functional-interfaces)
- [Types of Interfaces in Java](#types-of-interfaces-in-java)
- [Creating Functional Interfaces](#creating-functional-interfaces)
- [Lambda Expressions Overview](#lambda-expressions-overview)
- [Lambda Expression Syntax](#lambda-expression-syntax)
- [Target Type and Implementation](#target-type-and-implementation)
- [Lambda Expressions as Objects](#lambda-expressions-as-objects)
- [Execution and Invocation](#execution-and-invocation)
- [Compiler Linking and Verification](#compiler-linking-and-verification)
- [Rules and Restrictions](#rules-and-restrictions)

## Introduction to Functional Interfaces

### Overview
Functional programming concepts including functional interfaces and Lambda expressions are core additions to Java 8. From Java 5 onwards, Java introduced three main types of interfaces: business interfaces (normal interfaces), marker interfaces, and functional interfaces. This session focuses on understanding functional interfaces as the foundation for Lambda expressions, enabling pass-by-logic functionality that replaces traditional object-oriented approaches.

### Types of Interfaces in Java

#### Normal/Business Interfaces
Normal interfaces (also called business interfaces) contain more than one abstract method and are used for:
- Providing types to subclasses
- Defining main object types in the system
- Representing core business type hierarchies

Example:
```java
interface BusinessService {
    void processPayment(Payment payment);
    boolean validateTransaction(Transaction tx);
    Report generateReport(Date start, Date end);
}
```

#### Marker Interfaces
Marker interfaces have no abstract methods (empty interfaces) and are used to:
- Provide compile-time type information to subclasses
- Enable special runtime logic execution based on object types
- Communicate developer intent about object classification

Example:
```java
interface Serializable {
    // No methods - compile-time marker only
}
```

#### Functional Interfaces
Functional interfaces contain exactly one abstract method and may include:
- Default methods (any number)
- Static methods (any number) 
- Private methods (any number)
- java.lang.Object class methods (considered abstract)

Functional interfaces are used for:
- Defining Lambda expressions or method references
- Passing logic/functionality directly as method arguments
- Enabling functional programming patterns in Java

Example:
```java
@FunctionalInterface  // Optional explicit declaration
interface Predicate<T> {
    boolean test(T t);  // Single abstract method
    
    default Predicate<T> and(Predicate<? super T> other) { ... }
    default Predicate<T> or(Predicate<? super T> other) { ... }
    default Predicate<T> negate() { ... }
    static <T> Predicate<T> isEqual(Object targetRef) { ...)
}
```

### Creating Functional Interfaces

#### Explicit Declaration
Functional interfaces can be explicitly marked with the `@FunctionalInterface` annotation to guarantee:
- Only one abstract method remains in the interface
- Compiler enforces single abstract method constraint
- Future code changes cannot accidentally add more abstract methods

```java
@FunctionalInterface
interface Calculator {
    int compute(int a, int b);  // Only one abstract method allowed
}
```

#### Implicit Declaration  
Functional interfaces can be created without annotation by simply defining exactly one abstract method. This provides flexibility while still maintaining the functional interface contract.

```java
interface Processor {
    void process(String input);  // Single abstract - implicitly functional
}
```

## Lambda Expressions Overview

### Definition and Purpose
Lambda expressions enable functional programming in Java by allowing functions to be passed as arguments directly, eliminating the need for explicit class and object creation.

#### Key Differences: OOP vs Functional Programming
In object-oriented programming approach:
1. Create an interface
2. Create a subclass implementing the interface
3. Override abstract methods
4. Create objects to pass as arguments

In functional programming with Lambda expressions:
1. Define a functional interface
2. Create Lambda expression implementing the single abstract method
3. Pass Lambda expression directly as argument

### Core Concept
A Lambda expression is an anonymous function (method without name, return type, modifiers, or exception declarations) that serves as an implementation of a functional interface.

> [!IMPORTANT]  
> Lambda expressions in Java are NOT just anonymous functions - they are objects that implement functional interfaces implicitly created by the compiler.

## Lambda Expression Syntax

### Basic Structure
Lambda expressions use the following syntax pattern:
```
(parameters) -> { body/statements }
```

#### Parameter Rules
```java
// No parameters
() -> System.out.println("Hello")

// Single parameter (parentheses optional)
x -> x * x
(int x) -> x * x  

// Multiple parameters
(x, y) -> x + y
(int x, int y) -> x + y
```

#### Body Rules
```java
// Single statement (curly braces optional)
x -> System.out.println(x)

// Multiple statements (curly braces required)
x -> {
    System.out.println("Input: " + x);
    return x * 2;
}
```

### Complete Example
```java
@FunctionalInterface
interface MathOperation {
    int operate(int a, int b);
}

// Lambda expression implementation
MathOperation addition = (a, b) -> a + b;
MathOperation multiplication = (a, b) -> a * b;
```

## Target Type and Implementation

### Target Type Requirement
Lambda expressions require a **target type** (functional interface) because they are expressions that must be either:
- Assigned to a variable
- Passed as a method parameter
- Returned from a method

```java
// ❌ Not allowed - no target type
(a, b) -> a + b;

// ✅ Allowed - functional interface as target type  
MathOperation add = (a, b) -> a + b;
someMethod((a, b) -> a + b);
```

### Compiler Implementation Details
When assigning a Lambda expression to a functional interface:
1. Compiler validates parameter types and order match the abstract method
2. Compiler validates return types are compatible
3. Compiler implicitly creates an anonymous inner class implementation
4. Lambda expression becomes an instance of this compiler-generated class

## Lambda Expressions as Objects

### Object Nature Proof
Lambda expressions in Java are objects - specifically, instances of compiler-generated anonymous inner classes that implement the target functional interface.

```java
// Lambda expression creates an object
Predicate<String> isEmpty = s -> s.isEmpty();

// The variable 'isEmpty' holds a reference to this object
System.out.println(isEmpty);  // Prints class name: Test$$Lambda$1/0x0000000800bb0438
```

#### Object Verification Lab Demo
```java
@FunctionalInterface
interface Calculator {
    int compute(int value);
}

public class LambdaDemo {
    public static void main(String[] args) {
        // Lambda creates an object
        Calculator square = x -> x * x;
        
        // Display object reference
        System.out.println(square);  
        // Output: LambdaDemo$$Lambda$1/0x0000000800bb0438@1a2b3c4
        
        // Invoke like any object method
        int result = square.compute(5);  // Returns 25
    }
}
```

### Class Generation
Compiler generates anonymous inner classes with names like:
- `OuterClass$$Lambda$1`
- `OuterClass$$Lambda$2`

These classes implement the functional interface contract.

> [!NOTE]  
> Unlike Python where Lambda expressions create true anonymous functions, Java Lambda expressions are syntactic sugar over anonymous inner classes implementing functional interfaces.

## Execution and Invocation

### Invocation Process
Lambda expressions execute through the functional interface method calls:

```java
@FunctionalInterface
interface Processor {
    void process(int value);
}

public class ExecutionDemo {
    public static void main(String[] args) {
        // Create Lambda (creates object, doesn't execute)
        Processor display = value -> System.out.println("Input: " + value);
        
        // Execute Lambda via interface method
        display.process(42);  // Output: Input: 42
    }
}
```

### Execution Flow
1. Method call on interface reference (e.g., `processor.process(42)`)
2. JVM finds implementation in Lambda object
3. Parameter values assigned to Lambda parameters
4. Lambda body executes with provided values

## Compiler Linking and Verification

### Parameter Matching Rules
Compiler links Lambda expressions to functional interfaces when:
- **Type Compatibility**: Lambda parameter types match or are assignable to interface method parameter types
- **Order Compatibility**: Parameter order is identical
- **Return Type Compatibility**: Lambda return value type matches or is assignable to interface method return type

### Type Rules
#### ✅ Allowed (Same Types)
```java
interface Calculator {
    int compute(int x);
}

Calculator square = x -> x * x;  // int -> int ✓
```

#### ❌ Not Allowed (Type Mismatch)
```java
interface Calculator {
    int compute(int x);
}

Calculator square = (byte x) -> x * x;  // byte -> int ✗ (incompatible)
Calculator square = x -> (long)(x * x); // int -> long ✗ (incompatible)
```

#### Value Compatibility
- **Widening**: Lambda return values can be automatically widened to match interface return type
- **Narrowing**: Not allowed - must be same type or compatible widening

### Order Requirements
Parameter lists must match exactly in order and type:
```java
interface Processor {
    void process(int a, float b, String c);
}

// ✅ Correct order
Processor proc1 = (a, b, c) -> System.out.println(a + ", " + b + ", " + c);

// ❌ Wrong order  
Processor proc2 = (b, a, c) -> System.out.println(a + ", " + b + ", " + c); // Error

// ❌ Extra/wrong parameters
Processor proc3 = (a, b, c, d) -> System.out.println(a + ", " + b + ", " + c); // Error
```

## Rules and Restrictions

### Mandatory Compliance Rules
> [!WARNING]  
> Lambda expressions cannot be created arbitrarily like in languages such as Python. They must strictly follow the target functional interface contract.

#### Key Restrictions
1. **Parameter Types**: Must exactly match functional interface method parameters (same types, same order, same count)
2. **Return Types**: Must be same as or assignable to functional interface method return type via widening
3. **Auto-boxing**: Not automatic between primitive and wrapper types at Lambda level
4. **Method Signature**: Cannot modify method name, accessibility, or exception declarations

#### Example Validation
```java
@FunctionalInterface
interface Processor {
    void execute(int value);
}

// ✅ Valid Lambda expressions
Processor p1 = value -> System.out.println(value);
Processor p2 = (int value) -> System.out.println(value);

// ❌ Invalid attempts
Processor p3 = (byte value) -> System.out.println(value);    // Type mismatch
Processor p4 = (value, extra) -> System.out.println(value);   // Wrong parameter count
Processor p5 = value -> "Result: " + value;                   // Wrong return type
```

### Compilation Error Examples
```java
// Error: incompatible parameter types in lambda expression
Processor invalid1 = (String value) -> System.out.println(value);

// Error: bad return type in lambda expression  
Processor invalid2 = value -> "text";  // void expected, String provided
```

## Summary

### Key Takeaways
```diff
+ Lambda expressions are anonymous functions implementing functional interfaces
+ Target type (functional interface) required for Lambda creation
+ Compiler generates anonymous inner classes for Lambda objects
+ Parameter and return types must strictly match interface method signature
+ Enables functional programming by passing logic directly as arguments
+ Java Lambda expressions are objects, unlike true anonymous functions in other languages
```

### Expert Insight

**Real-world Application**: Lambda expressions are fundamental in modern Java for stream processing, reactive programming, and functional interfaces like `Predicate`, `Function`, `Consumer`, and `Supplier`. They're used extensively in frameworks like Spring for configuration, Java Streams for data processing, and RxJava for reactive operations.

**Expert Path**: Master Lambda expressions by studying the built-in functional interfaces in `java.util.function` package. Practice converting anonymous inner classes to Lambda expressions. Focus on method references (`::`) as advanced Lambda syntax and understand how Lambda capture works with local variables.

**Common Pitfalls**: 
- Forgetting that Lambda expressions require a target functional interface type
- Type mismatches between Lambda parameters/return types and interface method signature
- Attempting to modify captured local variables (effectively final requirement)
- Confusion between parameter names in Lambda vs. interface method (names don't matter, only types/order)
- Not handling checked exceptions properly in Lambda bodies

**Lesser Known Things**: Lambda expressions have deterministic serialization behavior with `@Stable` annotation internally used by JVM. The compiler may implement Lambda expressions via `invokedynamic` bytecode instruction for better performance in some Java versions. Static method references can sometimes provide better performance than instance method references due to direct invocation bypassing interface dispatch.
