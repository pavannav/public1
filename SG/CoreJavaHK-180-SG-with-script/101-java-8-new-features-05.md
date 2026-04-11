# Session 05: Java 8 Lambda Expressions

## Table of Contents

- [Need of Lambda Expression](#need-of-lambda-expression)
- [What is Lambda Expression](#what-is-lambda-expression)
- [Lambda Expression Syntax and Rules](#lambda-expression-syntax-and-rules)
- [Steps to Create Lambda Expression](#steps-to-create-lambda-expression)
- [Compiler Linking Rules](#compiler-linking-rules)
- [Different Places to Use Lambda Expression](#different-places-to-use-lambda-expression)
- [Lambda Expression Characteristics](#lambda-expression-characteristics)
- [Lambda Expression vs Anonymous Inner Class](#lambda-expression-vs-anonymous-inner-class)
- [Conclusion Points on Lambda Expression](#conclusion-points-on-lambda-expression)

## Need of Lambda Expression

**Overview**: This chapter enables functional programming in Java and allows passing functions as arguments without creating explicit implementation classes. Lambda expressions serve as alternatives to anonymous inner classes, simplifying interface implementations and reducing code verbosity.

**Key Concepts**:

Lambda expressions provide several key benefits:
- **Enable functional programming**: Pass functions directly as arguments to other functions
- **Alternative to anonymous inner classes**: Simplify interface implementation
- **Concise code development**: Reduce number of lines of code
- **Improved code readability**: Make code more understandable and maintainable

> [!NOTE]
> Lambda expressions represent a significant paradigm shift in Java programming, moving towards functional programming principles while maintaining object-oriented nature.

## What is Lambda Expression

**Overview**: Lambda expressions are anonymous functions that serve as implementations of functional interfaces, essentially objects representing concise method implementations.

**Key Concepts**:

- **Definition**: Anonymous function implementation of functional interfaces
- **Object nature**: Instances of functional interface implementations
- **Conceptual classification**: Alternative concept to anonymous inner classes (not completely new)

**Lambda Expression Creation Syntax**:

```java
// Basic syntax: parameters -> body
(parameters) -> {
    // body logic
    return result;
}
```

**Lambda Operator**: Connects parameters to body using arrow (`->`) symbol

```java
// Example with functional interface
@FunctionalInterface
interface Addition {
    int add(int a, int b);
}

// Lambda implementation
Addition sum = (a, b) -> a + b;
```

## Lambda Expression Syntax and Rules

**Overview**: Lambda expressions follow specific syntax rules for creation, including parameter handling, parentheses usage, bracket requirements, and return statements.

**Key Concepts**:

Complete list of rules includes 20 detailed syntax specifications covering:
- Parameter type inference and handling
- Parentheses optional/mandatory conditions
- Flower brackets (curly braces) usage rules
- Return keyword requirements
- Exception throwing guidelines

**Parentheses Rules**:

| Scenario | Parentheses Required |
|----------|---------------------|
| Single parameter with inferred type | Optional |
| Multiple parameters | Mandatory |
| Zero parameters | Mandatory |
| Explicit parameter types | Required with types |

**Flower Brackets (Curly Braces) Rules**:

```java
// Single statement - no braces needed
Predicate<String> isEmpty = s -> s.isEmpty();

// Multiple statements - braces and semicolon required
Predicate<String> startsWithA = s -> {
    System.out.println("Checking: " + s);
    return s.startsWith("A");
};
```

**Exception Handling in Lambda Expressions**:

```java
// Checked exceptions permitted if declared in functional interface
@FunctionalInterface
interface FileProcessor {
    void process() throws IOException;
}

FileProcessor processor = () -> {
    // Can throw checked exceptions
    throw new IOException("File processing error");
};
```

## Steps to Create Lambda Expression

**Overview**: Creating lambda expressions follows a systematic 4-step process to ensure proper compilation and execution.

**Key Concepts**:

1. **Create functional interface**: Define or identify the target functional interface
2. **Declare reference variable**: Create variable of functional interface type
3. **Assign lambda expression**: Implement using lambda syntax
4. **Invoke interface method**: Call the functional interface method to execute

```java
// Step 1: Functional interface
@FunctionalInterface
interface Calculator {
    int compute(int a, int b);
}

// Step 2-3: Lambda assignment
Calculator addition = (a, b) -> a + b;

// Step 4: Method invocation
int result = addition.compute(5, 3); // Returns 8
```

> [!IMPORTANT]
> Lambda expressions are only executed when their corresponding functional interface method is invoked. Assignment alone does not trigger execution.

## Compiler Linking Rules

**Overview**: The Java compiler links lambda expressions to functional interfaces by comparing parameter counts, types, and return values.

**Key Concepts**:

**Syntax Rules Applied**:
- Parameter count and types must match functional interface
- Return type compatibility required
- Parentheses, brackets, and semicolon rules enforced

```java
// Compiler validation example
@FunctionalInterface
interface Processor {
    void process(String input);
}

// Valid lambda: parameter types inferred
Processor p1 = input -> System.out.println(input);

// Valid lambda: explicit parameter types
Processor p2 = (String input) -> System.out.println(input);

// Invalid lambda: return type mismatch (would cause compilation error)
// Processor p3 = input -> "processed"; // void method cannot return String
```

## Different Places to Use Lambda Expression

**Overview**: Lambda expressions can be utilized in three primary contexts: variable assignment, method arguments, and method return values.

**Key Concepts**:

1. **Variable Assignment**: Store lambda expressions in functional interface variables
2. **Method Arguments**: Pass lambda expressions directly as parameters
3. **Method Return Values**: Return lambda expressions from methods

```java
// Variable assignment
Comparator<String> byLength = (s1, s2) -> s1.length() - s2.length();

// Method argument
Collections.sort(names, (s1, s2) -> s1.compareTo(s2));

// Method return value
public Comparator<String> getComparator(boolean ascending) {
    return ascending ?
        (s1, s2) -> s1.compareTo(s2) :
        (s1, s2) -> s2.compareTo(s1);
}
```

## Lambda Expression Characteristics

**Overview**: Lambda expressions possess specific characteristics regarding parameters, body content, and execution context.

**Key Concepts**:

**Parameter Characteristics**:
- Support 0 to n parameters
- Flexible parameter type handling (inferred or explicit)

**Body Characteristics**:
- Can contain any valid method statements
- Exception handling same as regular methods
- Local variables accessible within body scope

**Execution Rules**:
- Local variables from enclosing scope: accessible (read-only)
- `this` keyword: refers to enclosing class instance
- `super` keyword: refers to enclosing class superclass

```java
public class LambdaExample {
    private String instanceVar = "instance";

    public void demonstrateLambda() {
        String localVar = "local";

        Consumer<String> processor = (param) -> {
            // Access instance variable
            System.out.println(this.instanceVar);

            // Access local variable (read-only)
            System.out.println(localVar);

            // Access parameter
            System.out.println(param);

            try {
                // Can throw exceptions like regular methods
                throw new RuntimeException("demo");
            } catch (Exception e) {
                System.out.println("Exception caught: " + e.getMessage());
            }
        };
    }
}
```

## Lambda Expression vs Anonymous Inner Class

**Overview**: Lambda expressions represent an evolution from anonymous inner classes, providing more concise syntax while maintaining similar functionality for functional interfaces.

**Key Concepts**:

**Differences Analysis**:

1. **Class and Method Names**
   - Anonymous inner class: No explicit class name, but has method names
   - Lambda expression: No explicit class name AND no method name

2. **File Generation**
   - Anonymous inner class: No explicit .java file, but generates separate .class files
   - Lambda expression: No explicit .java file AND no separate .class files

3. **Bytecode Implementation**
   - Anonymous inner class: Traditional bytecode generation
   - Lambda expression: Uses `invokedynamic` bytecode for dynamic invocation

4. **Derivation Capability**
   - Anonymous inner class: Can extend classes or implement any interface
   - Lambda expression: Only implements functional interfaces

5. **Internal Structure**
   - Anonymous inner class: Can contain non-static fields, methods, blocks
   - Lambda expression: Cannot contain additional fields, methods, or blocks

6. **Variable Scope Behavior**
   - Anonymous inner class: Separate scope allows same-named variables as enclosing context
   - Lambda expression: Same scope as enclosing method, cannot shadow local variables

7. **Syntax Requirements**
   - Anonymous inner class: Explicit parameter types, mandatory body, explicit return keyword
   - Lambda expression: Parameter types inferred, optional body for single statements, implicit return

8. **Method Resolution**
   - Anonymous inner class: Overloaded methods resolved by implemented interface type
   - Lambda expression: Overloaded methods resolved by parameter/return type signatures

**Code Comparison**:

```java
// Functional interface
@FunctionalInterface
interface Calculator {
    int compute(int a, int b);
}

// Anonymous inner class implementation
Calculator calc1 = new Calculator() {
    @Override
    public int compute(int a, int b) {
        return a + b;
    }
};

// Lambda expression implementation
Calculator calc2 = (a, b) -> a + b;
```

## Conclusion Points on Lambda Expression

**Overview**: Lambda expressions bring significant improvements to Java programming with enhanced readability, reduced boilerplate code, and support for modern programming paradigms.

**Key Concepts**:

**Advantages**:
- ✅ Enables functional programming paradigm
- ✅ Provides concise, readable code
- ✅ Reduces boilerplate syntax
- ✅ Decreases JAR file sizes (no separate .class files)
- ✅ Supports enhanced iterative syntax
- ✅ Enables parallel processing capabilities
- ✅ Provides high performance through Stream API integration

**Final Notes**:
- Lambda expressions are also known as **closures**
- Default methods in interfaces are called **defender methods**
- Lambda expressions serve as function objects in functional programming
- Support for multi-threading and collections processing

**Preparation for Advanced Topics**:
Lambda expressions form the foundation for:
- Stream API operations
- Functional interfaces utilization
- Parallel processing implementations
- Enhanced collection manipulations

## Summary

### Key Takeaways

```diff
! Lambda expressions are anonymous functions implementing functional interfaces

+ Primary benefits: concise code, functional programming, improved readability

+ Enables passing functions as arguments without explicit class creation

+ Alternative to anonymous inner classes with simpler syntax

+ Supports Stream API for parallel processing and enhanced performance

+ Uses invokedynamic bytecode for efficient runtime implementation

+ Must be assigned to functional interface variables for execution

- Cannot be executed directly without functional interface assignment

- Cannot declare additional fields, methods, or constructors internally

- Restricted to functional interfaces only (unlike anonymous inner classes)
```

### Expert Insight

**Real-world Application**:
Lambda expressions excel in collection processing, event handling, and reactive programming patterns. They enable declarative-style programming, making code more maintainable in large-scale applications processing large datasets.

**Expert Path**:
Master lambda expressions by understanding functional programming principles, practicing with Java's built-in functional interfaces (Predicate, Function, Consumer, Supplier), and combining them with Stream API for data transformations. Study bytecode generation differences to appreciate performance implications.

**Common Pitfalls**:
Avoid using lambda expressions for non-functional interfaces, prevent variable capture issues in multi-threaded environments, and carefully handle checked exceptions in lambda bodies. Watch for method overloading ambiguities when passing lambdas as arguments.

**Lesser Known Things**:
Lambda expressions don't create separate .class files, using invokedynamic for dynamic method dispatch. The `this` keyword behavior differs between lambdas and anonymous inner classes, with lambdas capturing the enclosing instance rather than creating their own scope.
