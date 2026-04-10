# Session 105: Java 8 New Features - Interface Enhancements

**Session 105: Java 8 New Features - Interface Enhancements**

## Table of Contents
- [Default Methods](#default-methods)
- [Static Methods in Interface](#static-methods-in-interface)
- [Summary](#summary)

## Default Methods

### Overview
In Java 8, interfaces were enhanced to include default methods, which are public methods with implementation bodies prefixed by the `default` keyword. This allows adding new functionality to interfaces without breaking existing implementations. Default methods are designed to provide common default behavior to all implementing classes while allowing optional overriding. They highlight how interfaces evolved from purely abstract contracts to including concrete implementations, addressing real-world scenarios like mobile SIM specifications where new features like internet connectivity needed to be added without forcing all providers to implement them immediately.

### Key Concepts

#### Interface Members in Java 7 vs Java 8
Up to Java 7, interfaces could contain:
- Public static final fields
- Public abstract methods
- Public static inner classes

From Java 8 onward, interfaces can additionally include:
- Public default implemented methods (concrete methods with `default` keyword)
- Public static implemented methods
- From Java 9: Private static implemented methods and private non-static implemented methods

Total: 7 types of members.

Example interface structure:
- Abstract method: `void m1();` (mandatory for implementations)
- Default method: `default void m2() { System.out.println("Default behavior"); }` (optional for implementations)

The `default` keyword indicates default implementation, not the default access modifier. Syntax:
```java
public default ReturnType methodName(Parameters) throws Exceptions {
    // Implementation body (optional in presence but typically included)
}
```

#### Purpose of Default Methods
- Add new methods to interfaces without forcing existing implementations to rewrite code
- Provide backward compatibility when evolving interfaces (e.g., collection API enhancements)
- Solve the diamond problem in multiple inheritance by allowing interfaces to have concrete methods

Real-world analogy: Mobile SIM evolution (1G → 2G → 3G → 4G → 5G)
- Adding internet connectivity (2G) as a default method allows companies like BSNL to adopt gradually without immediate forced implementation.

#### Creating and Overriding Default Methods
- **Creation**: Use `public default` for implementation body. If body present without `default`, compilation fails.
- **Override in Implementation Class**: Optional but possible. If overridden, uses subclass implementation. Access via `Interface.super.method()` to call interface default.
- **Extending Default Methods**: Call interface default and add subclass logic:
  ```java
  default void m2() {
      // Interface logic here
  }

  // In implementing class:
  @Override
  public void m2() {
      // Call super interface
      InterfaceName.super.m2();
      // Additional subclass logic
  }
  ```

Example code:
```java
interface P {
    void m1();  // Abstract, mandatory
    default void m2() { System.out.println("Default from P"); }
}

class Q implements P {
    @Override
    public void m1() { System.out.println("Abstract from Q"); }
    // m2 is optional; if not overridden, uses default
}

class R extends Q {
    // Can override m2 if needed
}
```

#### Default Methods and Multiple Inheritance
- Interfaces still support multiple inheritance even with default methods
- Ambiguous error occurs if two interfaces have same default method signature and are implemented without override
- Solution: Override the conflicting method in the implementing class

Example with ambiguity:
```java
interface I1 {
    default void m2() { System.out.println("From I1"); }
}

interface I2 {
    default void m2() { System.out.println("From I2"); }
}

class Example implements I1, I2 {
    @Override
    public void m2() {
        // Choose implementation, e.g., I1.super.m2();
    }
}
```

If not overridden, compilation error: "Duplicate default methods named m2".

#### Invocation and Runtime Polymorphism
- Call via interface reference or subclass object
- Runtime polymorphism: Method resolution based on object type
- Abstract methods: Always executed from implementing class
- Default methods: From interface unless overridden

Example:
```java
P p1 = new R();
p1.m1(); // From R
p1.m2(); // From P if not overridden
```

#### Differences Between Abstract Classes and Java 8 Interfaces
No fundamental changes despite default methods:
- Interfaces cannot have constructors or be instantiated directly
- Interfaces support multiple inheritance (including with default methods)
- Abstract classes support single inheritance
- Default methods cannot be `private`, `static`, `final`, `native`, `synchronized` (only `public` and `strictfp`)

> [!NOTE]  
> Default methods are also called "defender methods" as they defend the interface contract by providing backward compatibility.

> [!IMPORTANT]  
> Cannot create default implementations for Object class methods (e.g., `equals`, `hashCode`) due to ambiguity with Object class implementations.

## Static Methods in Interface

### Overview
From Java 8, interfaces can have `static` implemented methods for utility functions. Unlike default methods, static methods are not inherited to implementations and cannot be overridden. They are designed for reusable common logic accessible via the interface name. This supports modular utility code without instantiating interface objects.

### Key Concepts

#### Inheritance and Accessibility
- **Not Inherited**: Static methods are not inherited to implementing classes
- **Access**: Call via `InterfaceName.staticMethod()`, not via subclass reference or `this`/`super`
- Invalid accesses in implementing class:
  ```java
  class Impl implements Interface {
      void test() {
          // ERROR: Cannot access via reference
          // this.staticMethod();
          // super.staticMethod();
          
          // OK: Only via interface name
          Interface.staticMethod();
      }
  }
  ```

#### Use Case
- Utility methods for all implementing classes and users (e.g., factory methods, validation logic)

Example:
```java
interface ABC {
    void m1();  // Abstract
    default void m2() {}  // Optional
    static void m3() { System.out.println("Static utility"); }
}

class ABC1 implements ABC {
    public void m1() {}
    // m2 optional
    // Cannot access m3 via super, this, or ABC1.m3() - only ABC.m3()
}
```

> [!NOTE]  
> Static methods in interfaces do not promote multiple inheritance issues since they can't be conflicted in the same way as default methods.

## Summary

### Key Takeaways
```diff
+ Default methods add implementation to interfaces without breaking existing code
+ Static methods provide utility functions accessible via interface name only
+ Interfaces still support multiple inheritance and cannot be instantiated
+ Ambiguous default methods require overriding in implementing classes
+ Real-world example: SIM evolution shows backward compatibility benefits
- Default methods can cause ambiguity in multiple inheritance
- Static methods are not inherited or overridable in subclasses
- Cannot create default versions of Object class methods due to conflicts
```

### Expert Insight

#### Real-world Application
In enterprise Java, default methods enable API evolution without forcing clients to update immediately. For example, adding default sorting behavior in `List` interface allows collections to gain features without mandatory reimplementation. Use static methods for common validations or factory patterns, keeping utility code centralized. In frameworks like Spring or Hibernate, interfaces often include static utilities for configuration builders.

#### Expert Path
Master interface design by:
- Utilizing functional interfaces (`@FunctionalInterface`) from `java.util.function` package for lambda expressions
- Exploring stream API with `Collectors` for data processing
- Benchmarking default method performance in high-throughput systems - they are instance methods, so monitor object overhead
- Studying Java 9 private methods in interfaces for encapsulation

#### Common Pitfalls
- **Ambiguous Errors**: Always override conflicting default methods to avoid compilation failures in multiple inheritance scenarios.
- **Access Violations**: Attempting `this.interfaceStaticMethod()` throws compilation errors; use `InterfaceName.staticMethod()`.
- **Object Method Conflicts**: Implementing `toString()` as default leads to ambiguity with Object class methods - avoid it.
- **Performance Overhead**: Default methods add v-table entries; in performance-critical code, consider abstract class alternatives for single inheritance.
- **Evolution Risks**: Adding defaults to widely used interfaces (e.g., in shared libraries) can introduce unexpected behavior if clients have matching methods.

Lesser known facts:
- Default methods cannot be `synchronized`, `native`, or `final`, unlike regular methods - design for optional override.
- In Java 23, `super` call restrictions ease, allowing `super.defaultMethod()` in non-first statements.
- Defender methods (alternate name) protect API stability, as seen in Collection API enhancements.
- Interfaces cannot have `protected` members, even for defaults - all must be `public`.
