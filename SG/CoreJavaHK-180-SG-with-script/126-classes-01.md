# Session 126: Inner Classes 01

## Table of Contents
- [Overview](#overview)
- [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
  - [What is an Inner Class?](#what-is-an-inner-class)
  - [Purpose of Inner Classes](#purpose-of-inner-classes)
  - [Types of Inner Classes](#types-of-inner-classes)
  - [Advantages of Inner Classes](#advantages-of-inner-classes)
  - [Creating Members in Inner Classes](#creating-members-in-inner-classes)
  - [Accessing Members in Inner Classes](#accessing-members-in-inner-classes)
- [Code Examples and Demos](#code-examples-and-demos)
- [Summary](#summary)

## Overview
Inner classes, also known as nested classes, are a fundamental concept in Java introduced in Java 1.1. They allow defining a class within another class, enabling better encapsulation, logical grouping, and direct access to outer class members without complex wiring code. This session covers the definition, types, advantages, and practical usage of inner classes, drawing direct parallels to object-oriented principles like the "has-a" relationship.

## Key Concepts and Deep Dive

### What is an Inner Class?
An inner class (or nested class) is a class defined inside another class, interface, enum, or annotation. Unlike a regular class, an inner class can access the outer class's private members, mimicking real-world relationships (e.g., an engine as part of a car).

**Definition**:  
A class or interface created inside another class, interface, enum, or annotation is called an inner class or nested class.

- **Examples**:
  - Class inside a class: `class Outer { class Inner {} }`
  - Interface inside a class: `class A { interface I {} }`
  - Enum inside a class: `class A { enum E {} }`
  - Annotation inside a class: `class A { @interface An {} }`

Each inner class compiles into a separate `.class` file with a naming convention (e.g., `Outer$Inner.class`). There is one `.class` file per class, including inner ones.

### Purpose of Inner Classes
Inner classes serve to create inner objects (parts of an outer object) without separately defining classes and connecting them via reference variables, which leads to "wiring code."  

- **Before Inner Classes (Java 1.0)**: Required extensive wiring code to link objects (e.g., Car and Engine), including passing references and creating getter/setter methods. Private members were inaccessible, violating encapsulation.
- **After Inner Classes (Java 1.1+)**: Direct embedding allows access to private members without wiring, improving code maintainability and true encapsulation.

Inner classes are primarily used for modeling "has-a" relationships in object-oriented design.

### Types of Inner Classes
There are four main types of inner classes, analogous to variables and methods:

1. **Static Inner Class (Nested Class)**:  
   Behaves like a static member. Created using the outer class name and accessible without an outer class instance, common to all instances.

2. **Non-Static Inner Class (Member Inner Class)**:  
   Behaves like a non-static member. Tied to a specific outer instance and created via `outerInstance.new Inner()`.

3. **Local Inner Class**:  
   Defined inside a method/block. Accessible only within that scope, used for one-time operations.

4. **Anonymous Inner Class**:  
   No explicit name, provides a subtype of a class or interface inline. Shortcut for creating implementations without a separate class.

### Advantages of Inner Classes
- **No Wiring Code**: Objects are embedded directly, eliminating boilerplate for references.
- **Access to Private Members**: Bidirectional access between inner and outer class private parts.
- **Encapsulation**: Hides inner classes from external access, improving grouping and readability.
- **Reusable Code**: Inner classes are tightly coupled; choose inner class for single-class use, instance variables for multi-class use.
- **Code Maintainability**: Changes are localized within one file.

### Creating Members in Inner Classes
Inner classes support members like regular classes, but restrictions apply:

- **Static Inner Class**: Allows all members (static/non-static, variables, methods, blocks, even abstract and inner classes).
- **Non-Static Inner Class**: Only non-static members (variables, methods, blocks, constructors, abstract methods). Static members prohibited except final constants.
- **Local Inner Class**: Same as non-static inner class; static not allowed.
- **Anonymous Inner Class**: Non-static members only; no constructors, abstract methods, or named types.

### Accessing Members in Inner Classes
- **Inside Inner Class**: Direct access to outer class private members (vice versa).
- **In Same Class**: Use outer class name with dot (e.g., `Outer.Inner`).
- **Outside Outer Class**: Create instances accordingly (e.g., `new Outer().new Inner()` for non-static).

## Code Examples and Demos

### Demo 1: Basic Inner Class Creation
```java
class Test01 {
    class A {}
    interface I {}
    enum E {}
    @interface An {}
}
```
- Compile with `javac Test01.java`.
- Output: Creates `.class` files: `Test01.class`, `Test01$A.class`, `Test01$I.class`, `Test01$E.class`, `Test01$An.class`.

### Demo 2: Wiring Code Without Inner Classes (Java 1.0 Style)
```java
class Car {  // Old style without inner classes
    private String petrol = "unleaded";
    private String brakes = "disc";
    private String cables = "copper";
}

class Engine {
    private Car car;  // Wiring code
    Engine(Car car) {
        this.car = car;
    }
    void run() {
        System.out.println("Petrol: " + car.petrol);  // No direct access; needs getters
    }
}
```
- Issues: Lots of wiring code, no direct private access.

### Demo 3: Inner Classes Solution
```java
class Car {
    private String petrol = "unleaded";
    private String brakes = "disc";
    private String cables = "copper";

    class Engine {
        void run() {
            System.out.println("Petrol: " + petrol);  // Direct access
        }
    }
}
```
- Key: **Compile with inner class access to outer private members**.

### Demo 4: Static Inner Class
```java
class Example {
    static class A {}  // Static nested class
    // Access from another class: Example.A a = new Example.A();
}
```

### Demo 5: Non-Static Inner Class
```java
class Example {
    class B {}  // Non-static inner class
    // Access: Example e = new Example(); B b1 = e.new B();
}
```

### Demo 6: Local Inner Class
```java
class Example {
    void m() {
        class C {}  // Local inner class
    }
}
```

### Demo 7: Anonymous Inner Class
```java
new Runnable() {  // Anonymous inner class for Runnable
    public void run() {
        System.out.println("Running...");
    }
};
```

### Demo 8: Member Creation Examples
- **Static Inner Class**: Allows `static int x = 10;`, `static void m1() {}`, even nested classes.
- **Non-Static Inner Class**: `int x = 10;`, `void m() {}`, but `static int x` throws error.
- **Anonymous Inner Class**: `int x = 10;`, but no `abstract void m() {}` (class not abstract).

## Summary

### Key Takeaways
1. Inner classes are for modeling "has-a" relationships without wiring.
2. Four types: Static (common access), Non-Static (instance-specific), Local (method-scoped), Anonymous (subtypes only).
3. Access private members directly; improves encapsulation.
4. Available from Java 1.1; compiles to `$`-separated `.class` files.
5. Use static for shared logic, anonymous for temporary implementations.

### Expert Insight

**Real-world Application**: In frameworks like collections or GUI libraries (e.g., Android), inner classes define handlers or adapters specific to an outer component, reducing code sprawl and enabling direct outer class access for UI state.

**Expert Path**: Master syntax by practicing all types; focus on when to use each for scalable code. Study JVM bytecode rolls for inner classes to understand compilation impacts.

**Common Pitfalls**:
- Confusing static vs. non-static: Static needs no instance, but can't access outer non-static; non-static requires `outer.new Inner()`.
- Anonymous classes lack constructors: Use instance blocks for initialization.
- Misusing for reuse: Prefer outer classes for multi-use; inner for single-class ties.
- Compilation errors: Ensure semicolon after anonymous class blocks; check for abstract overrides.

**Lesser Known Facts**: Anonymous classes can access outer local variables only if final (before Java 8). Inner class shadowing (same names) prioritizes local scope. Static nested classes are technically not "inner", per Oracle docs, but colloquially called so. Scale projects avoid deep nesting (e.g., inner-inside-inner) for readability.
