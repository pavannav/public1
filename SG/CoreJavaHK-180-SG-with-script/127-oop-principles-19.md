# Session 127: OOP Principles - Abstraction

## Table of Contents
- [Overview](#overview)
- [Key Concepts](#key-concepts)
- [Lab Demos](#lab-demos)
- [Summary](#summary)

## Overview
In this session, we explore the fundamental OOP principle of **abstraction** - the process of hiding implementation details of an object and providing only necessary information to access its operations. Abstraction is the backbone of object-oriented programming that guarantees inheritance, polymorphism, and encapsulation, ensuring loose coupling and runtime polymorphism.

## Key Concepts

### Abstraction

**Definition**: Abstraction is the process of hiding implementation details of an object (method) from the user/class programmer and providing only necessary information to invoke those operations.

**Why Abstraction?**
- Provides security by hiding complex implementation details
- Simplifies object usage by showing only essential operations
- Ensures loose coupling and runtime polymorphism

**Real-Time Examples:**
1. **Mobile Phone/UI**: Users see only necessary screens, buttons, and links; all internal operations and components are hidden.
2. **Human Digestion**: Food enters the body, but the complex digestive processes are abstracted away - users just eat and trust the internal mechanisms.
3. **Keyboard/Mouse**: Users know key mappings (A for character 'A') but don't understand the electronic signal conversions or wire connections.

> [!IMPORTANT]
> Interview Tip: Always explain abstraction with real-world examples like interview rooms (hiding job details until offer), ATMs, or search engines (Google search interface hides backend algorithms).

**Advantages of Abstraction:**
- **Security**: Object data and implementation details remain hidden
- **Simplification**: Big picture of object operations are abstracted away
- **Loose Coupling & Runtime Polymorphism**: Abstract methods are implemented uniformly across subclasses with same signatures
- **100% Inheritance Guarantee**: Abstract classes ensure subclass relationships

> [!NOTE]
> Every project starts with abstraction, which guarantees all four OOP pillars work together: inheritance, polymorphism, encapsulation, and abstraction itself.

### Developing Abstraction

**Two Ways to Develop Abstraction:**
1. **Abstract Classes**: For partial abstraction (concrete + abstract members)
2. **Interfaces**: For complete abstraction (only abstract methods) and multiple inheritance

**When to Choose:**
- **Abstract Class**: When you need both concrete and abstract members (partial abstraction)
- **Interface**: When you need only abstract methods (full abstraction) and multiple inheritance

**Rules for Abstract Methods:**
1. Method must end with semicolons (no body)
2. Must be declared with `abstract` keyword
3. Class containing abstract methods must be declared `abstract`
4. Subclasses MUST implement all abstract methods, or declare themselves `abstract`

**Flow of Execution:**
- User creates reference variable of abstract class type
- Assigns concrete subclass object to reference
- Method calls use runtime polymorphism via overridden implementations

**Modifiers Allowed for Abstract Methods:**
- Access modifiers: `public`, `protected`, `default` (NOT `private`)
- Cannot use: `static`, `final`, `native`, `synchronized`, `transient`, `volatile`, `strictfp`

**Modifiers Allowed for Abstract Classes:**
- `public`, `default`, `abstract`, `strictfp` (NOT `protected`, `private`, `final`)

**Members Allowed in Abstract Classes:**
- Abstract methods
- Concrete methods
- Static/non-static fields
- Constructors (for initializing subclass object variables)
- Static blocks, instance blocks, etc.

## Lab Demos

### Demo 1: Basic Abstraction Setup

**Code Structure:**
```java
abstract class Example {
    abstract void m1();
    abstract void m2();
}

class Sample extends Example {
    void m1() {
        System.out.println("M1 executed from Sample");
    }
    
    void m2() {
        System.out.println("M2 executed from Sample"); 
    }
}

public class Test {
    public static void main(String[] args) {
        Example e1 = new Sample(); // Cannot instantiate Example directly
        e1.m1(); // Executes from Sample
        e1.m2(); // Executes from Sample
    }
}
```

**Key Points:**
- `Example` class declared abstract due to abstract methods
- Cannot instantiate abstract classes: `new Example()` fails
- Subclass `Sample` implements all abstract methods
- Runtime polymorphism via super class reference

### Demo 2: Multiple Abstract Methods & Partial Implementation

**Code Structure:**
```java
abstract class Example {
    abstract void m1();
    abstract void m2();
}

abstract class Sample extends Example {
    void m1() {
        System.out.println("M1 executed from Sample");
    }
    // m2 not implemented - Sample declared abstract
}

class XYZ extends Sample {
    void m2() {
        System.out.println("M2 executed from XYZ");
    }
}

class PQR extends Sample {
    void m2() {
        System.out.println("M2 executed from PQR");
    }
}

public class Test {
    public static void main(String[] args) {
        Example e1 = new XYZ();
        e1.m1(); // From Sample
        e1.m2(); // From XYZ (runtime polymorphism)
        
        e1 = new PQR();
        e1.m1(); // From Sample  
        e1.m2(); // From PQR
    }
}
```

**Key Points:**
- `Sample` declares abstract method `m2()` 
- Subclasses implement method variations
- Runtime polymorphism based on object type

### Demo 3: Abstract Concrete Classes

**Code Structure:**
```java
abstract class Example { // Concrete class declared abstract
    int x = 10; // Variable for subclass use
    
    void m1() { // Concrete method
        System.out.println("M1 executed for object: " + this.getClass().getName());
    }
}

class Sample extends Example {
    // Inherits concrete method and variable
}

public class Test {
    public static void main(String[] args) {
        // Cannot: Example e1 = new Example(); // Error!
        Example e1 = new Sample(); // OK
        e1.m1(); // Executes concrete method for Sample object
    }
}
```

**Key Points:**
- Abstract concrete classes prevent direct instantiation
- Members exist solely for subclass usage (like parents working for children)
- Predefined examples: `java.awt.Component`, servlet classes

## Summary

### Key Takeaways
```diff
+ Abstraction hides complexity and provides security
+ Guarantees inheritance, polymorphism, and encapsulation
+ Abstract classes: partial abstraction with concrete members
+ Interfaces: complete abstraction with multiple inheritance
+ Methods and classes follow strict modifier rules
- Abstract classes cannot be instantiated directly
- Subclasses must implement all abstract methods
! Runtime polymorphism ensures correct method execution
```

### Expert Insight

**Real-world Application**: In enterprise applications, abstraction enables clean architecture where service layers hide database operations, allowing UI developers to focus only on interface contracts without worrying about data persistence details.

**Expert Path**: Master abstraction by designing interfaces first, then concrete implementations. Practice creating abstract factories and template methods for flexible, extensible systems.

**Common Pitfalls**:
- Forgetting to implement abstract methods in subclasses (compiler errors)
- Trying to instantiate abstract classes directly
- Using restricted modifiers like `private` or `static` on abstract methods
- Confusing partial abstraction (abstract classes) with complete abstraction (interfaces)

**Common Issues & Resolutions**:
- **Compilation Error - Abstract method in concrete class**: Declare class as `abstract` or implement all methods
- **Runtime Issues**: Ensure proper inheritance hierarchy and method signatures match
- **Modifier Conflicts**: Use only allowed modifiers (abstract methods: public/protected/default; abstract classes: public/default/abstract/strictfp)

**Lesser Known Things**: Abstract classes can have constructors (for subclass initialization), main methods, and even be declared without abstract members (to prevent direct instantiation). Interfaces historically couldn't have concrete methods until Java 8+ introduced default methods.
