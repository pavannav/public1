# Session 50: Methods

- [Overview of Methods](#overview-of-methods)
- [Need for Methods](#need-for-methods)
- [What is a Method?](#what-is-a-method)
- [Why Methods?](#why-methods)
- [How to Create a Method?](#how-to-create-a-method)
- [Method Terminology](#method-terminology)
- [Method Declaration and Definition](#method-declaration-and-definition)
- [Method Invocation](#method-invocation)
- [Lab Demos](#lab-demos)
- [Summary](#summary)

## Overview of Methods

Methods in Java are fundamental building blocks for developing reusable logic to perform operations. A method encapsulates a sequence of statements that can be executed repeatedly without rewriting code. They support both mathematical and business object operations, enabling modular programming and solving the limitations of the main method, such as lack of reusability and parameterized execution.

## Need for Methods

The main method in Java has limitations: it cannot create reusable logic, must handle fixed parameters (String[] args), cannot return values directly for user-defined needs, and does not support object-oriented programming fully as it is static. Problems include:

- Repeated logic for each object or value.
- Inability to control execution (all code runs automatically).
- Logic duplication across classes for similar operations like deposit/withdraw.

Methods address these by providing reusable, parameterized logic that can be called on-demand.

## What is a Method?

A method is a **sequence of statements** placed as one block with a proper name and return type. It serves as a named sub-block of a class (often called a "code block") used to develop reusable logic for performing one operation.

Real-time examples:
- Mathematical operations: Adding two numbers, finding palindromes.
- Business object operations: Depositing money (involves addition on an object), booking a ticket, buying/selling products.

A method includes:
- Input parameters for operation data.
- Logic to perform the operation.
- Output/result (or void if no result).
- Exception handling for invalid inputs.

## Why Methods?

Methods solve the problem of repetitive code by enabling reusable logic. Unlike variables which must be reassigned for each use, methods are defined once and called multiple times. This supports the object-oriented paradigm and allows logic to be reused across objects and classes.

The main method cannot be reused, returns void, has fixed parameters, and uses a fixed name. Our own methods customize:
- Name and operations.
- Return type and values.
- Parameters and exceptions.
- Access (static/non-static).

## How to Create a Method?

To create a method, answer six questions:
1. What operation? (Method name)
2. What inputs? (Parameters)
3. What logic? (Body statements)
4. What result type? (Return type)
5. What exceptions? (Throws clause)
6. What permissions? (Accessibility and execution modifiers)

### Full Syntax

```java
accessibility_modifier execution_level_modifier return_type method_name(parameters) throws exception_list {
    // logic body
}
```

- **Accessibility modifers**: public, private, protected, default. Control where the method can be accessed.
- **Execution level modifiers**: static (access without object), non-static (access with object), abstract (declare without body), etc. Modifiers are keywords that change default behavior of programming elements.
- **Return type**: Data type of result (void if none).
- **Method name**: Identifier representing the operation.
- **Parameters**: Variables to receive inputs, e.g., `(int a, String b)`.
- **Throws exception list**: Exceptions that may occur, e.g., throws IOException.
- **Body**: Open/close brackets with logic statements.

Mandatory parts: return_type, method_name, parentheses.

### Example Program: Full Syntax Method

```java
class Test01 {
    public static void m1(int a, String str) {
        System.out.println(a + " " + str);
    }
}
```

## Method Terminology

### Core Parts
- **Prototype**: Head portion containing modifiers, return_type, method_name, parameters, throws list. E.g., `public static void m1(int a, String str)`.
- **Body**: Region between `{}`.
- **Logic**: Statements inside the body.
- **Signature**: Method name + parameter list, e.g., `add(int a, int b)`.

### Parameters and Arguments
- **Parameter**: Variable declared in method parentheses, e.g., `int a`.
- **Argument**: Value passed during method call, e.g., `5`, `"hello"`.

### Other Terminology
- **Method Name**: Identifier for the operation, e.g., `add`.
- **Return Type**: Data type of result or void.
- **Modifiers**: Accessibility (public) and execution_level (static).

## Method Declaration and Definition

### Declaration
Creating a method without body (prototype + semicolon), using `abstract` modifier.

```java
public abstract void m3();
```

### Definition (Concrete Method)
Creating with body (prototype + logic).

```java
public static void m1() {
    System.out.println("Hi");
}
```

### Initializing/Calling Methods
Methods execute only when called; not automatically by JVM (except main).

## Method Invocation

- **Syntax**: `method_name(arguments);`
- **Process**: Control passes from calling method to called method. Called method's logic executes, then control returns to caller.
- **Arguments**: Required if method has parameters, e.g., `m1(5, "hello");`.

Calling a method suspends the current method's execution and resumes after called method completes.

## Lab Demos

### Demo 1: Create Method with Full Syntax (Concat Soa and Print)

```java
class Test01 {
    public static void m1(int n, String s) throws RuntimeException {
        System.out.println(n + " " + s);
    }

    public static void main(String[] args) {
        Test01.m1(10, "Hello");
    }
}
```

Steps:
1. Define class `Test01`.
2. Declare method with full syntax: modifiers, return type, name, parameters, throws.
3. Write logic to concat and print.
4. Call method from main.

### Demo 2: Create Method with Mandatory Syntax Only

```java
class Test02 {
    void m2() {
        System.out.println("Mandatory parts only");
    }
}
```

Steps:
1. Define class `Test02`.
2. Use only mandatory syntax (default modifiers, void return type, name, parentheses, body).
3. Implement minimal logic.

### Demo 3: Create Abstract Method (Declaration)

```java
class Test03 {
    public abstract void m3();
}
```

Note: Without abstract, this fails compilation as body is required unless declared abstract.

### Demo 4: Define and Invoke Methods

```java
class Example {
    public static void m1() {
        System.out.println("Hi, how are you?");
    }

    public static void main(String[] args) {
        Example.m1();  // Method invocation
        Example.m1();
    }
}
```

Steps:
1. Define method with body.
2. Call method from main using class name (static).
3. Observe output: Method executes only when called.

### Main Method Breakdown
- Prototype: `public static void main(String[] args)`.
- Arguments: String[] object passed by JVM, e.g., `new String[0]`.

## Summary

### Key Takeaways

```diff
+ Methods enable reusable logic, overcoming main method limitations.
+ Syntax includes modifiers, return type, name, parameters, throws, and body.
+ Parameters receive inputs; arguments are passed during calls.
+ Method invocation transfers control; defined methods execute only when called.
+ Abstract methods declare without body; concrete methods define with logic.
- Methods are not executed automatically; explicit invocation is required.
- Variables and methods share operations (declare, define, access), but methods must be invoked.
```

### Expert Insight

**Real-world Application**

In production Java applications, methods modularize code for scalability. For instance, in banking, deposit/withdraw methods encapsulate validation, calculation, and logging. This prevents code duplication across UIs (web, mobile, API) and ensures consistency in operations like balance updates, even across services via microservices.

**Expert Path**

To master methods, practice overloading (same name, different parameters) for flexible operations and overriding in inheritance hierarchies. Study polymorphic behavior for advanced reusability. Implement unit tests for method logic using JUnit, focusing on edge cases and exception handling. Build projects with layered architecture: UI calls service methods, which call DAO methods, enforcing separation of concerns.

**Common Pitfalls**

| Pitfall | Resolution | Avoidance |
|---------|------------|-----------|
| Forgetting method invocation | Methods don't execute; always call explicitly | Habituate to writing calls post-definition. |
| Mismatched parameters/arguments | Compilation error; JVM mismatch | Use IDEs for type checking; test with various inputs. |
| Returning from non-void methods | Missing return statement | Always include return; exceptions for unreachable code. |
| Static/non-static confusion | NullPointerException or compilation issues | Use static for class-level, non-static for object-level. |

Lesser known things: Methods can return objects (e.g., Arrays, custom classes). JVM uses stack for method calls, so deep recursion risks StackOverflowError. Inner methods possible via lambdas, but Java 8+.

Note: Mistakes corrected - "Main" to "main" in context of method names; transcript had no other notable typos. Overlooked sub-topic: Exceptions not detailed in demo, but mentioned as throws clause.
