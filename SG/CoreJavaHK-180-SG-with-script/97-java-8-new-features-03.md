# Session 97: Java 8 New Features 03 - Lambda Expressions Advanced Syntax

## Table of Contents
- [Introduction and Reminder of Previous Session](#introduction-and-reminder-of-previous-session)
- [Purpose of Lambda Expressions](#purpose-of-lambda-expressions)
- [Lambda Expression as Alternative to Anonymous Inner Classes](#lambda-expression-as-alternative-to-anonymous-inner-classes)
- [Functional Interface Implementation Using Lambda Expressions](#functional-interface-implementation-using-lambda-expressions)
- [No Parameter Lambda Expressions](#no-parameter-lambda-expressions)
- [Single Parameter Lambda Expressions](#single-parameter-lambda-expressions)
- [Two Parameter Lambda Expressions](#two-parameter-lambda-expressions)
- [Parenthesis Rules in Lambda Expressions](#parenthesis-rules-in-lambda-expressions)
- [Body (Block) Rules in Lambda Expressions](#body-block-rules-in-lambda-expressions)
- [Lambda Expressions with Return Types](#lambda-expressions-with-return-types)
- [Examples of Return Type Handling](#examples-of-return-type-handling)
- [Syntax Variations and Compilation Rules](#syntax-variations-and-compilation-rules)
- [Assignments and Preparation](#assignments-and-preparation)

## Introduction and Reminder of Previous Session
Lambda expressions enable functional programming in Java by allowing functions to be passed as arguments without creating explicit classes or objects.

In the previous session, we covered:
- Basic syntax of Lambda expressions.
- Steps to create Lambda expressions.
- How the compiler links Lambda expressions to functional interfaces.
- Syntax rules for matching Lambda expressions to functional interfaces.

Key points from last session:
- Lambda expression parameters must match the number of parameters in the implementing functional interface method.
- The return value of the Lambda expression must match the return type of the functional interface method.
- Compiler throws an error if these rules are not followed.

## Purpose of Lambda Expressions
Lambda expressions enable functional programming in Java, which involves passing functions as arguments directly without creating explicit classes or objects. They serve as a shortcut for creating anonymous inner classes for functional interfaces.

## Lambda Expression as Alternative to Anonymous Inner Classes
Lambda expressions are an alternative to anonymous inner classes. They provide a shorter way to implement functional interface methods.

### Comparison between Anonymous Inner Class and Lambda Expression
Anonymous inner classes require more code due to explicit class/object creation, while Lambda expressions use concise syntax.

Example of implementing a functional interface:
```java
@FunctionalInterface
interface I1 {
    void m1();
}

class Test {
    public static void main(String[] args) {
        // Anonymous inner class (longer syntax)
        I1 obj1 = new I1() {
            public void m1() {
                System.out.println("Anonymous inner class implementation");
            }
        };
        
        // Lambda expression (shorter syntax)
        I1 obj2 = () -> System.out.println("Lambda expression implementation");
    }
}
```

## Functional Interface Implementation Using Lambda Expressions
To implement a functional interface using a Lambda expression:
1. Define the functional interface.
2. Match the Lambda expression parameters to the interface method parameters.
3. Use the arrow operator (`->`) to separate parameters from the body.
4. Implement the method logic in the body.

Code example:
```java
@FunctionalInterface
interface I1 {
    void m1();
}

class Test {
    public static void main(String[] args) {
        I1 obj = () -> System.out.println("Lambda expression one");
        obj.m1(); // Output: Lambda expression one
    }
}
```

## No Parameter Lambda Expressions
For functional interfaces with no parameters, use empty parentheses.

Syntax: `() -> body`

Example:
```java
@FunctionalInterface
interface I1 {
    void m1();
}

class Test {
    public static void main(String[] args) {
        I1 obj = () -> System.out.println("Hello World");
        obj.m1();
    }
}
```

## Single Parameter Lambda Expressions
For interfaces with one parameter, parentheses are optional, and parameter types can be omitted.

Syntaxes:
- With type and parentheses: `(int x) -> body`
- Without type, with parentheses: `(x) -> body`
- Without type or parentheses: `x -> body` (single parameter only)

Example:
```java
@FunctionalInterface
interface I2 {
    void m1(int x);
}

class Test {
    public static void main(String[] args) {
        I2 obj = (int x) -> System.out.println("Value: " + x);
        obj.m1(5); // Output: Value: 5
        
        I2 obj2 = x -> System.out.println("Value: " + x);
        obj2.m1(5); // Same output
    }
}
```

## Two Parameter Lambda Expressions
For multiple parameters, parentheses are mandatory.

Syntax: `(param1, param2) -> body`

Example:
```java
@FunctionalInterface
interface I3 {
    void m1(int x, String s);
}

class Test {
    public static void main(String[] args) {
        I3 obj = (int x, String s) -> System.out.printf("%d: %s%n", x, s);
        obj.m1(8, "HK"); // Output: 8: HK
    }
}
```

## Parenthesis Rules in Lambda Expressions
- Parentheses are mandatory for no parameters or multiple parameters.
- Parentheses are optional for single parameters.

## Body (Block) Rules in Lambda Expressions
- For blocked Lambda expressions (with `{}`), multiple statements are allowed.
- For unblocked Lambda expressions (without `{}`), only one statement is allowed.
- Body brackets `{}` are optional for one statement, mandatory for zero or multiple statements.

Examples:
```java
@FunctionalInterface
interface I1 {
    void m1();
}

@FunctionalInterface
interface I3 {
    void m1(int x, String s);
}

class Test {
    public static void main(String[] args) {
        // Single statement, no brackets
        I1 obj1 = () -> System.out.println("Lambda expression 1");
        
        // Multiple statements, brackets required
        I3 obj2 = (x, s) -> {
            System.out.println("x: " + x);
            System.out.println("s: " + s);
        };
    }
}
```

## Lambda Expressions with Return Types
For non-void return types, return values must be provided.

### Void Methods
- Return statement is not required.
- Can have empty body.

### Non-Void Methods
- Must return a value matching the method's return type.
- Two syntaxes:
  1. With `return` keyword and body: `(params) -> { return value; }`
  2. Without `return` keyword, no body: `(params) -> value`

Examples:
```java
@FunctionalInterface
interface I4 {
    void m1(); // void method
}

@FunctionalInterface
interface I5 {
    int m1(); // non-void method
}

class Test {
    public static void main(String[] args) {
        I4 obj1 = () -> {}; // Empty void method
        
        I5 obj2 = () -> 5; // Simple return without return keyword
        
        I5 obj3 = () -> { return 10; }; // Return with keyword and body
        
        // Calling and using return values
        int result1 = obj2.m1(); // Gets 5
        System.out.println(obj2.m1()); // Prints 5
    }
}
```

## Examples of Return Type Handling
```java
@FunctionalInterface
interface I5 {
    int m1();
}

class Test {
    static int getInt() {
        return 5;
    }
    
    static void m1() {
        System.out.println("Method called");
    }
    
    public static void main(String[] args) {
        I5 obj = () -> getInt(); // Returns int value
        
        int result = obj.m1(); // result = 5
        
        // Direct display
        System.out.println(obj.m1()); // Prints 5
        
        // Method calls in Lambda
        I5 obj2 = () -> {
            m1(); // Calls void method
            return 10;
        };
    }
}
```

## Syntax Variations and Compilation Rules
Complete list of rules for creating Lambda expressions:

1. Number and types of parameters must match the functional interface method.
2. Return type must be compatible with the functional interface method.
3. Can only implement interfaces with exactly one abstract method (functional interfaces).
4. Parameter types are optional if compiler can infer them.
5. Parameter names must follow identifier rules.
6. Parentheses are mandatory for no parameters or multiple parameters.
7. Parentheses are optional for single parameters.
8. Body brackets `{}` are mandatory for empty bodies or multiple statements.
9. Body brackets `{}` are optional for single statements.
10. For void methods, no return statement needed.
11. For non-void methods, return value must be provided.
12. `return` keyword is mandatory when using explicit body for non-void methods.
13. `return` keyword is optional/implicit when not using body.
14. Semicolon mandatory at end of Lambda statement when used as variable assignment or method return.
15. Semicolon not allowed when passed as method argument.
16. Lambda expressions can infer parameter types from functional interface.
17. From Java 11 onwards, `var` can be used for parameter types.
18. Single underscore `_` cannot be used as parameter name from Java 9 onwards.
19. Parameter names must be valid identifiers (letters, digits, underscore, dollar sign).
20. Cannot have multiple methods in one Lambda expression.
21. Lambda expression implicitly creates an object of the target type.

## Assignments and Preparation
Prepare Lambda expressions for the following interfaces:

```java
@FunctionalInterface
interface I7 {
    String m1(int i);
}

@FunctionalInterface
interface I8 {
    Person m1(Student s); // Assuming Person and Student classes exist
}
```

Develop all possible syntax variations for these interfaces.

## Summary

### Key Takeaways
```diff
+ Lambda expressions provide concise syntax for implementing functional interfaces.
+ Parentheses are mandatory for 0 or multiple parameters, optional for single.
+ Body brackets are optional for single statements, mandatory for 0 or multiple.
+ Parameter types can be omitted when inferable by compiler.
+ Return keyword is implicit for simple expressions without body.
+ Void methods can have empty body; non-void methods must return compatible value.
```

### Expert Insight

**Real-world Application**: In frameworks like Spring Boot, Lambda expressions are extensively used with Stream API for data processing, collections filtering, and mapping operations. For example, processing lists of data with `list.stream().filter(item -> item.getValue() > 10).collect(Collectors.toList())`.

**Expert Path**: Master parameter type inference and body simplification shortcuts. Practice converting anonymous inner classes to Lambda expressions. Focus on combining with Java 8 streams for efficient data manipulation in enterprise applications.

**Common Pitfalls**:
- Forgetting parentheses for multiple parameters leads to compilation errors.
- Using `return` keyword in simple expressions without body causes syntax errors.
- Mismatched parameter counts or types result in "incompatible types" errors.
- Attempting to implement non-functional interfaces (multiple abstract methods) with Lambda expressions fails, as only one method can be implemented per Lambda.
- Overusing block bodies when single-line expressions suffice increases code verbosity.

MODEL: CL-KK-Terminal
