# Session 87: Object Design Model and Classes

## Table of Contents
- [Overview](#overview)
- [Key Concepts/Deep Dive](#key-conceptsdeep-dive)
  - [Object Design Models](#object-design-models)
  - [Relations and Inheritance](#relations-and-inheritance)
  - [Class Types](#class-types)
- [Summary](#summary)

## Overview
This session explores the foundational concepts of object design models and the various types of classes in object-oriented programming (OOP). Building on previous coverage of basic OOP elements like variables, methods, constructors, and blocks, we transition to understanding how to design and relate classes to represent real-world objects effectively. The focus is on two primary design models for creating objects: single class with multiple instances and single class with multiple subclasses and instances. This leads into relationships, particularly inheritance, and a detailed examination of Java's six class types—interface, abstract class, concrete class, final class, enum, and annotation—to choose the right tool for different programming scenarios.

## Key Concepts/Deep Dive

### Object Design Models
To create real-world objects in the programming world, we follow structured design models. These models ensure efficient, reusable code without redundancy. There are two main models:

#### Single Class, Multiple Instances
- **Description**: When multiple objects share the same type with identical properties and behaviors, we define one class that acts as a blueprint. Each object gets its own instance to store unique values.
- **When to Use**: Applicable when objects have common properties (e.g., name, height, weight) and behaviors, but individual values differ. This avoids code duplication.
- **Example**: Creating multiple "Person" objects like Balakrishna Babu, Pavan Kalyan Babu, and Mahesh Babu. The "Person" class declares common variables (e.g., ears, hands, legs—declared as static final) and methods. Each instance stores object-specific values.
  ```java
  class Person {
      static final int ears = 2;
      static final int hands = 2;
      static final int legs = 2;
      String name;
      double height;
      double weight;
      // methods for behaviors
  }
  // Creating instances
  Person balakrishna = new Person();
  balakrishna.name = "Balakrishna Babu";
  // Similarly for others
  ```
- **Key Point**: Use static final fields for shared values to prevent modification and save memory. This model promotes dynamic instance creation.

#### Single Class, Multiple Classes, Multiple Instances
- **Description**: For objects of the same type but with varying implementations (e.g., different subclasses), we create a superclass (parent) and multiple subclasses (children). Each subclass provides its own implementation, while the superclass defines common protocols.
- **When to Use**: When objects share a type and properties but have different behavior implementations. This enforces standardization (e.g., common interfaces) while allowing customization.
- **Example**: Sheer manufacturing (e.g., Shape with subclasses Rectangle, Square, Circle). The "Shape" superclass declares common methods like `area()` and `perimeter()` as abstract. Subclasses implement them differently.
  ```java
  abstract class Shape {
      abstract double area();
      abstract double perimeter();
  }
  class Rectangle extends Shape {
      double length, width;
      double area() { return length * width; }
      double perimeter() { return 2 * (length + width); }
  }
  // Similar for Square and Circle
  ```
- **Key Point**: This model is hierarchical, supporting inheritance. Every real-world product has subtypes; no single class fits all varying implementations.

Real-world analogy: Bikes from different manufacturers (Honda, Bajaj) must follow standard designs (e.g., clutch on left, brakes on right) for usability, even with varying implementations. Violating this leads to unusable products.

> 💡 **Insight**: Homework/find objects around you (e.g., laptops, pens) and classify them under these models. Most fall under the second model due to subtypes.

### Relations and Inheritance
The "single class, multiple classes, multiple instances" model establishes a **parent-child relationship**, known as **inheritance**. This allows subclasses to inherit properties and methods from a superclass, promoting code reuse and polymorphism.

- **Inheritance Types in Java**:
  - **Extends**: For class-to-class inheritance (single inheritance).
  - **Implements**: For interface implementation (multiple inheritance allowed).
- **Example of Syntax**:
  ```java
  class Rectangle extends Shape implements Comparable {
      // Inherits methods from Shape, implements Comparable
  }
  ```
- **Is-A Relationship**: Expresses hierarchy, e.g., "Rectangle is a Shape." Use extends for this.
- **Key Rules**:
  - Subclasses can override superclass methods for specialization.
  - Constructors are not inherited but can call super via `super()`.
  - Supports abstraction and dynamic method dispatch.

### Class Types
Java provides six class types for different abstraction needs. Selection depends on whether you're declaring operations, implementing some/all, or restricting changes.

#### Interface
- **Definition**: A reference data type (not a class) for creating the main type of an object by declaring operations and forcing subclasses to implement them. It achieves full abstraction.
- **When to Use**: When all operations need declaration but no implementation (to allow varying logic in subclasses). Chosen over abstract class for pure contracts.
- **Syntax**:
  ```java
  public interface Shape {
      public static final double PI = 3.14159;  // Constants
      public abstract double area();             // Abstract methods
      public static void staticMethod() {}      // Java 8+
      public default void defaultMethod() {}    // Java 8+
      // Private methods from Java 9+
  }
  ```
- **Members Allowed**:
  - Public static final fields (constants).
  - Public abstract methods (until Java 7).
  - Public static inner classes.
  - Default methods and static methods (Java 8+).
  - Private static/non-static methods (Java 9+).
- **Derivation**: Extends multiple interfaces but implements none.

#### Abstract Class
- **Definition**: A reference data type for creating subtypes by declaring some operations and implementing others common to all subclasses. It provides partial abstraction.
- **When to Use**: When some operations are common across subclasses (implement them here) and others vary (declare as abstract). Used when concrete classes already exist but need a partially defined superclass.
- **Syntax**:
  ```java
  abstract public class Shape {
      public static final double PI = 3.14159;
      public abstract double area();  // Abstract method
      public double commonMethod() { return PI; }  // Implemented method
  }
  ```
- **Members Allowed**: All from concrete classes plus abstract methods (minimum 1 abstract method required).
- **Derivation**: Extends one class, implements multiple interfaces.

#### Other Class Types (Brief Overview)
- **Concrete Class**: Fully implemented classes with all methods defined. Used for direct object creation.
- **Final Class**: Cannot be extended. Used to prevent inheritance and ensure immutability.
- **Enum**: For constants with behavior. Enforces single instances.
- **Annotation**: For metadata; defines custom annotations.

## Summary

### Key Takeaways
```diff
+ Object design models ensure efficient real-world object representation in code, avoiding redundancy through single class blueprints or hierarchical inheritance.
+ Inheritance (via extends/implements) establishes "is-a" relationships, enabling code reuse and polymorphism.
+ Interfaces provide full abstraction for operation contracts, while abstract classes offer partial implementation.
+ Choose interface for pure declarations, abstract class for mixed verbosity, and examine real-world hierarchies for correct model application.
- Avoid forcing varying implementations into a single class, leading to static, unusable code.
- Misapplying class types can violate abstraction principles, causing runtime errors or tight coupling.
```

### Expert Insight
**Real-world Application**: In enterprise systems, use interfaces for payment gateways (declaring methods like `processPayment()` that banks implement differently) and abstract classes for vehicle hierarchies (e.g., a base "Vehicle" with shared logic for fuel efficiency). This mirrors product standards (e.g., USB ports) while allowing vendor-specific variations.

**Expert Path**: Master UML diagrams for modeling inheritance hierarchies. Practice with Java design patterns like Factory and Strategy to combine interfaces/abstract classes dynamically. Aim for high cohesion and low coupling.

**Common Pitfalls**: Overusing concrete classes in hierarchies ignores varying behaviors; failing to mark shared values as final risks unintended modifications. Forgetting Java 8+ features (e.g., default methods) can lead to redundant code. Less-known fact: Interfaces can now hold implemented methods, blurring lines with abstract classes—always check JDK version compatibility.
