# Session 073: Constructor Overloading, Chaining, and Final Keyword

## Table of Contents
- [Overview](#overview)
- [Constructor Overloading](#constructor-overloading)
- [Constructor Chaining](#constructor-chaining)
- [Super Calls in Inheritance](#super-calls-in-inheritance)
- [Final Keyword](#final-keyword)

## Overview

In this session on Core Java Object-Oriented Programming, we explore advanced constructor concepts and immutability through the final keyword. Constructor overloading allows creating objects with different initialization parameters, while constructor chaining eliminates code duplication by linking constructors within the same class. We'll also examine how super calls ensure proper inheritance initialization and how the final keyword creates constants, prevents method overriding, and restricts class inheritance. These concepts form the foundation for robust, maintainable Java applications.

## Constructor Overloading

### Key Concepts/Deep Dive

Constructor overloading enables defining multiple constructors with different parameter lists in a single class, allowing flexible object initialization based on passed arguments.

- **Definition**: Having multiple constructors in a class with different parameters (type, number, or order) is called constructor overloading.
- **Execution Logic**: The JVM matches the constructor based on the argument types passed during object creation (e.g., `new Example(10)` calls the `int` param constructor).
- **Purpose**: Used for object initialization with varying parameter types or different initialization logic.
- **When to Use**: Ideal when objects need different initialization paths, such as accepting values as `int`, `String`, or other types.
- **Example Code**:
  ```java
  class Example {
      private int x;

      Example() {
          this.x = 5;  // Default hardcoded value
      }

      Example(int x) {
          if (x < 0) {
              throw new IllegalArgumentException("Negative values not allowed");
          }
          this.x = x;
      }

      Example(String value) {
          this.x = Integer.parseInt(value);
      }
  }
  ```
  Here, each constructor validates or converts data appropriately.

- **Common Issue**: Code duplication when similar logic (e.g., validation) repeats across constructors.

### Code/Config Blocks

For input/output validation, use this pattern:

```java
if (condition) {
    throw new Exception("Invalid input");
}
```

### Tables

| Overload Type | Parameters | Usage Example |
|---------------|------------|----------------|
| No Param      | None       | `new ClassName()` |
| Int Param     | `int x`    | `new ClassName(10)` |
| String Param  | `String s` | `new ClassName("value")` |

## Constructor Chaining

### Key Concepts/Deep Dive

Constructor chaining connects constructors to avoid redundant initialization code, using `this()` for same-class calls and `super()` for parent-class calls.

- **Definition**: Calling one constructor from another using `this()` or `super()`, executed in reverse order of the call chain (called constructors execute first).
- **Why Chain?**: Prevents code repetition when initializations are similar; write logic once and reuse.
- **Using `this()`**: Chains within the same class; must be the first statement, calls another overloaded constructor with current object reference.
- **Using `super()`**: Chains to parent class; mandatory (added automatically by compiler if missing), must be first statement, initializes parent before child.
- **Execution Order**:
  ```diff
  ! Chained Constructor Call → Executed Constructor Logic
  - Reverse of call order: this(int) → this() → Original Logic
  ```
- **Example Code**:
  ```java
  class Sample {
      private int x;

      Sample() {
          System.out.println("Default executed");
      }

      Sample(int x) {
          this();  // Chains to no-param constructor
          if (x < 0) {
              throw new IllegalArgumentException("Negative not allowed");
          }
          this.x = x;
          System.out.println("Int param processed: " + x);
      }

      Sample(String value) {
          this(Integer.parseInt(value));  // Chains to int param constructor
          System.out.println("String param processed");
      }
  }
  ```

- **Rules**:
  - `this()` or `super()` must be first statement.
  - Multiple calls not allowed in one constructor.
  - `this()` and `super()` together forbidden.
  - Mutual/recursive calls prohibited.

### Code/Config Blocks

Validation logic should be centralized:

```java
if (value < 0) {
    throw new IllegalArgumentException("Invalid: " + value);
}
```

### Tables

| Call Type | Purpose | Syntax Example | Execution |
|-----------|---------|----------------|-----------|
| `this()`  | Chain in same class | `this(10);` | Before current logic |
| `super()` | Chain to parent | `super(5);` | Before subclass logic |

## Super Calls in Inheritance

### Key Concepts/Deep Dive

In inheritance, super calls ensure parent constructors initialize properly, as subclasses inherit parent state.

- **Automatic Addition**: Compiler adds `super();` if not provided, calling parent's no-param constructor.
- **When to Specify**: Use `super(args);` for parameterized parent constructors; essential for inheritance.
- **Initialization Sequence**:
  ```diff
  + Parent Constructor → Child Members Initialize
  - Child Logic Executes After Parent Completes
  ```
- **Example Code**:
  ```java
  class Parent {
      Parent() {
          System.out.println("Parent no-param");
      }
      Parent(int x) {
          System.out.println("Parent int-param: " + x);
      }
  }

  class Child extends Parent {
      Child() {
          super(10);  // Explicitly calls Parent(int x)
          System.out.println("Child no-param");
      }
  }
  ```

### Code/Config Blocks

Inheritance setup requires:

```java
class Child extends Parent {
    Child() {
        super(args);  // Mandatory for param init
    }
}
```

### Tables

| Scenario | Compiler Action | Output Example |
|----------|----------------|-----------------|
| No `super()` in child | Adds `super();` | Parent no-param → Child logic |
| `super(int)` | Calls matched parent | Parent int-param → Child logic |

## Final Keyword

### Key Concepts/Deep Dive

The final keyword creates immutability at variable, method, and class levels, preventing changes to ensure consistency.

- **Variable**: Cannot reassign; for constants (use all caps: `MIN_BALANCE`).
  - **Initialization Rules**:
    - Class-level (`static`/`non-static`): Mandatory, in declaration or static block for `static final`.
    - Parameters/Local: Optional.
  - **Example**:
    ```java
    class Constants {
        static final int MIN_BALANCE = 100;  // Declaration
        final int ID;  // Must initialize in constructor

        Constants() {
            ID = 123;  // Constructor init
        }
    }
    ```

- **Method**: Prevents overriding; useful for security/fixed behavior.
- **Class**: No subclassing (e.g., `String` is final).

### Code/Config Blocks

For constants:

```java
public static final String APP_NAME = "MyApp";
```

### Tables

| Final Type | Restriction | Example Usage |
|------------|-------------|----------------|
| Variable   | No reassignment | `final int x = 10;` |
| Method     | No override | `final void process() {}` |
| Class      | No inheritance | `final class Utility {}` |

## Summary

### Key Takeaways
```diff
+ Constructor overloading allows flexible object creation with different parameters, matched by JVM based on argument types.
+ Constructor chaining eliminates redundant code using this() for same-class and super() for inheritance links.
+ Final keyword enforces immutability: variables become constants, methods unoverridable, classes unextendable.
- Avoid recursive this() calls or mixing this() and super() in one constructor to prevent compile errors.
! Always initialize final class-level variables before use, either inline or in static blocks.
```

### Expert Insight

**Real-world Application**: Constructor overloading enables builder patterns (e.g., `User(name)` vs `User(name, age)` for database entities), while chaining streamlines validation logic in layered architectures. Final variables secure configurations like API keys.

**Expert Path**: Master constructor chaining for clean code; study final's impact on JVM optimization (inlines constants). Advanced topics include final with generics and lambdas. Practice Javadoc for final members.

**Common Pitfalls**: Forgetting to initialize final variables causes compilation failures. Recursive constructor calls lead to stack overflow. Mixing inheritance with final classes breaks extensibility. Lesser Known: Final local variables in loops enable effective final semantics for lambda capture. Final methods cannot be overridden but can be overloaded.

## Model ID
CL-KK-Terminal

## Mistakes Notified
- "recussion" corrected to "recursion" (refers to recursive constructor calls).
- "constructoration" corrected to "constructor call" (misspelled term).
- "recussion" should be "recursion" in context of constructor calls.
