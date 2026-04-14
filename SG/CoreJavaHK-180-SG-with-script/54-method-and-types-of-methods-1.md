# Session 54: Methods and Types of Methods

## Table of Contents
- [Overview of Methods and Types of Methods](#overview-of-methods-and-types-of-methods)
- [Need of User-Defined Methods](#need-of-user-defined-methods)
- [Problems with Using Only the Main Method](#problems-with-using-only-the-main-method)
- [Execution Types: Static vs Non-Static Methods](#execution-types-static-vs-non-static-methods)
- [Declaration Types: Abstract vs Concrete Methods](#declaration-types-abstract-vs-concrete-methods)
- [Definition of a Method](#definition-of-a-method)
- [Real-World Analogy for Methods](#real-world-analogy-for-methods)
- [Method Creation Process](#method-creation-process)
- [Method Syntax: Mandatory vs Optional Parts](#method-syntax-mandatory-vs-optional-parts)
- [Sample Method Examples](#sample-method-examples)
- [Summary](#summary)

## Overview of Methods and Types of Methods
👋 Welcome to Session 54, where we dive into methods in Java. This session covers the fundamental concept of methods, their necessity in programming, and the different types: static/non-static for execution scope and abstract/concrete for definition style. We'll explore why we need methods beyond the main method, how to create them, and follow the instructor's structured progression from need to syntax. Key focus areas include reusability, object-oriented principles, and proper method design for mathematical and business operations. Remember, methods enable reusable logic for performing specific operations, making code modular and efficient for large-scale applications.

## Need of User-Defined Methods
In Java, methods are essential for developing reusable operations beyond the predefined main method. The main method's fixed signature (parameters as String[] args, return type as void) limits flexibility:
- It cannot accept different input types or return results, making logic non-reusable.
- Multiple operations in one method lead to poor design, as calling the method executes all operations unnecessarily.
- User-defined methods allow custom parameters and return types for tailored operations.

This chapter focuses on creating methods for mathematical operations (e.g., addition/subtraction on values) or business object operations (e.g., depositing into a BankAccount object). We'll learn to implement logic common to all objects (static methods) or specific to individual objects (non-static methods), forcing subtypes to implement operations (abstract methods) or providing full implementations (concrete methods).

> [!IMPORTANT]
> Mastering methods is crucial for object-oriented programming, as they transform reusable code blocks for both procedural and object-based logic.

## Problems with Using Only the Main Method
The main method's prototype is predefined with specific parameters (String[] args) and return type (void), making it unsuitable for business applications:
- **Lack of Reusability**: Logic cannot be reused outside the main method due to fixed signatures.
- **Rigid Input/Output**: Cannot pass varied inputs or return results.
- **Code Organization Issues**: Combining multiple operations in main violates separation of concerns, leading to execution of unwanted logic.
- **Unsuitability for Operations**: Main handles program entry, not specific computations or object manipulations.

Solution: Create user-defined methods with custom signatures, called from main or other methods/classes. For example, define an add method in class AO with parameters and return type for reusability.

```java
class AO {
    static int add(int a, int b) {
        return a + b;
    }
}

public class Main {
    public static void main(String[] args) {
        AO ao = new AO();
        int result = ao.add(10, 20);  // Reusable with different values
        System.out.println(result);
    }
}
```
This enables flexible execution for both mathematical (value-based) and business (object-based) operations.

## Execution Types: Static vs Non-Static Methods
Java supports two execution scopes for methods, based on whether logic applies to all class instances (common) or specific objects (instance-specific):

| Aspect          | Static Method                 | Non-Static Method             |
|-----------------|-------------------------------|-------------------------------|
| **Scope**      | Logic shared across all objects | Logic unique to each object  |
| **Example**    | Math calculations, utilities | Object-specific actions (e.g., account deposit) |
| **Invocation** | ClassName.method()            | objectName.method()           |
| **Use Case**   | Common operations (e.g., add)  | Instance-based (e.g., deposit for account1) |

Static methods execute logic globally, while non-static methods operate on individual objects, akin to class-level vs. instance-level behavior.

## Declaration Types: Abstract vs Concrete Methods
Methods are also categorized by declaration style:
- **Concrete Method**: Has a body { } with implementation logic.
- **Abstract Method**: Declared without body (ends with ;), forcing subclasses to implement.

In business analogies, owners declare operations (abstract), and workers implement (concrete). Abstract methods use the `abstract` modifier in interfaces or abstract classes.

Example:
```java
abstract class Mother {
    abstract void buyVegetables();  // Abstract: operation declared
}

class Child extends Mother {
    void buyVegetables() {  // Concrete: logic implemented
        // Sequence of steps: take money, go to market, bargain, etc.
    }
}
```

## Definition of a Method
A method is a sequence of statements grouped as a named block with a return type, used to perform one operation. Key differences from C:
- Java requires encapsulation in a class.
- Must specify return type (e.g., void or int).
- Distinct from constructors (no return type).

Real-world examples include buying vegetables (step-by-step process) or scolding in software teams (mindset building, not literal anger).

## Real-World Analogy for Methods
Drawing from daily life, a "method" is a sequence of steps for an operation, like buying vegetables:
1. Take money from mother.
2. Take vehicle and drive to market.
3. Find a shop, ask prices, bargain.
4. Select, weigh, purchase.
5. Return home (possibly getting scolded for bad choices).

Scolding is part of "training" in Indian culture/software workplaces—builds resilience. Methods bring real-world processes into code.

## Method Creation Process
To create a method, ask six questions:
1. **Method Name** (operation name, e.g., add).
2. **Parameters** (inputs, e.g., int a, int b).
3. **Logic** (sequence of statements).
4. **Return Type** (result type, e.g., int).
5. **Throws Exceptions** (error handling, optional).
6. **Modifiers** (accessibility/execution, e.g., public static).

Arrange in syntax: [modifiers] [returnType] methodName([params]) [throws] { logic }

This process applies to both mathematical (pure calculations) and business operations (object manipulations).

```java
// Example: Static concrete method
public static void buyVegetables() {
    // Logic steps...
}

// Example: Non-static abstract method
abstract void deposit(double amount);
```

> [!NOTE]
> Order: Modifiers → Return Type → Name → Params → Throws → Body.

## Method Syntax: Mandatory vs Optional Parts
Method syntax has six parts; not all are required:
- **Mandatory**: Return type, method name, parentheses (method body { }).
- **Optional**: Accessibility modifiers (public), execution modifiers (static), parameters, throws exceptions, logic (can be empty).

Examples highlight flexibility:
- Full: public static void m1(int a, int b) throws IllegalArgumentException { logic; }
- Minimal: public void m2() { }  // Optional params/logic

## Sample Method Examples
```java
// Concrete static method (common to all objects)
public static void m1(int a, int b) {
    System.out.println(a + b);
}

// Concrete non-static method (instance-specific)
public void m2() {
    // Instance logic
}

// Abstract method (requires subclass implementation)
abstract void m3();
```
These cover static/non-static and abstract/concrete combinations.

## Summary

### Key Takeaways
```diff
+ Methods enable reusable logic for operations, overcoming main method limitations (fixed params, no returns).
- Avoid mixing multiple operations in one method; maintain single responsibility.
+ Static methods for class-wide logic; non-static for object-specific.
+ Abstract methods declare operations; concrete methods implement them.
+ Creation involves 6 questions: name, params, logic, return type, exceptions, modifiers.
- Concrete = has body {}; abstract = ends with ;.
+ Mandatory: return type, name, (), {}; optional: modifiers, params, throws, logic.
! Reuse logic via methods for mathematical/business operations; always encapsulate in classes.
```

### Expert Insight

#### "Real-world Application"
In production, methods are foundational for modular code—e.g., Static utility methods in libraries for common calculations, non-static methods in business classes for object state changes (e.g., banking deposits). Abstract methods enforce contracts in frameworks like Spring, ensuring subclasses implement required logic for scalability.

#### "Expert Path"
Master method design by practicing SOLID principles: Focus on single responsibility, avoid overusing static (can hinder testing), and use abstract for polymorphism. Profile code to optimize recursive methods and understand JVM method invocation costs.

#### "Common Pitfalls"
- Forgetting return types: Always specify, even for void.
- Mixing access modifiers incorrectly: Public for APIs, private for internal.
- Empty logic bugs: Abstract checking—overlook implementations in subclasses.
- Exception handling: Underusing throws can lead to runtime errors; common issues include NullPointerException in non-static calls on null objects or IllegalArgumentException for invalid inputs—resolve by validating params early.

#### Lesser-Known Things
- Method overloading is just signature variation; overriding is subclass redefinition.
- Varargs ([parameter]...) allow flexible arguments without arrays.
- Bridge methods (generated by compiler) handle generics in inheritance silently.

*Transcript Corrections*: Fixed typos like "meod" → "method", "wi" → "void", "cubectl" not present, "ript" at start likely "script/text", "written type" → "return type", "accessibility modifiers" → "modifiers" for clarity, removed redundant repetitions. No major misspellings like HTTP/HTTPS equivalents noted. If discrepancies found, they were standardized against Java conventions.*
