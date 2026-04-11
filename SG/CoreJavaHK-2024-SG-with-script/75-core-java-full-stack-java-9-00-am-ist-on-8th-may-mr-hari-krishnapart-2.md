# Session 75: Core Java & Full Stack Java - Part 2: Types of Polymorphism

## Table of Contents
- [Overview](#overview)
- [Key Concepts/Deep Dive](#key-conceptsdeep-dive)
  - [What is Polymorphism?](#what-is-polymorphism)
  - [Types of Polymorphism](#types-of-polymorphism)
  - [Compile Time Polymorphism (Static Binding/Early Binding)](#compile-time-polymorphism-static-bindingearly-binding)
  - [Runtime Polymorphism (Dynamic Binding/Late Binding)](#runtime-polymorphism-dynamic-bindinglate-binding)
  - [Method Execution Flow](#method-execution-flow)
  - [Which Methods Support Which Polymorphism](#which-methods-support-which-polymorphism)
  - [Real-World Examples](#real-world-examples)
  - [Target of Object-Oriented Programming](#target-of-object-oriented-programming)

## Overview
This session continues from the previous one, covering the final keyword, and dives deep into polymorphism - a fundamental concept in object-oriented programming. We'll explore the two types of polymorphism in Java: compile-time polymorphism and runtime polymorphism. Understanding polymorphism is crucial for creating flexible, maintainable code that mirrors real-world relationships between classes and objects.

## Key Concepts/Deep Dive

### What is Polymorphism?
Polymorphism is the ability of an object to take on many forms. In Java, it refers to defining multiple methods with the same name in a superclass and subclass, either through method overloading or method overriding. Polymorphism allows objects of different types (classes) to be treated as objects of the same type through inheritance.

Examples:
- Method overriding: Defining the same method signature in both superclass and subclass
- Method overloading: Defining the same method name with different parameters within the same class

### Types of Polymorphism
Java supports two main types of polymorphism:

1. **Compile-time polymorphism** (also called static binding or early binding)
2. **Runtime polymorphism** (also called dynamic binding, late binding, or lazy binding)

The difference lies in when the method resolution occurs - at compile time or at runtime.

### Compile Time Polymorphism (Static Binding/Early Binding)
In compile-time polymorphism, the method to be executed is resolved at compile time. The compiler determines which method definition to link based on the reference variable's type, not the actual object type.

Key characteristics:
- Method binding occurs at compilation
- Executed from the referenced variable's class
- Ignores the actual object stored in the reference variable

![Compile Time Polymorphism Flow](./mermaid/compile_time_polymorphism.md)

### Runtime Polymorphism (Dynamic Binding/Late Binding)
In runtime polymorphism, the method resolution occurs at runtime based on the actual object type stored in the reference variable. This allows for dynamic behavior where calling a superclass method actually executes the overridden version from the subclass.

Key characteristics:
- Method binding occurs at runtime
- Executed from the subclass based on the actual object type
- Enables dynamic method dispatch

```bash
Superclass reference = new Subclass();
reference.method();  # Executes from Subclass, not Superclass
```

### Method Execution Flow
Let's examine the execution flow using code examples:

First, create an Example superclass and Sample subclass:

```java
class Example {
    // Static method - supports compile-time polymorphism only
    static void m1() {
        System.out.println("m1 from Example class");
    }
    
    // Non-static, non-final, non-private method - can support runtime polymorphism if overridden
    void m2() {
        System.out.println("m2 from Example class");
    }
    
    // Non-static method not overridden - compile-time polymorphism
    void m3() {
        System.out.println("m3 from Example class");
    }
    
    // Final method - compile-time polymorphism only
    final void m4() {
        System.out.println("m4 from Example class");
        m5(); // Calls m5 from Example class
    }
    
    // Private method - compile-time polymorphism only
    private void m5() {
        System.out.println("m5 from Example class");
    }
    
    // Non-static, non-final, non-private but overloaded (not overridden) in subclass
    void m6() {
        System.out.println("m6() from Example class");
    }
}

class Sample extends Example {
    // Overriding m2 - supports runtime polymorphism
    @Override
    void m2() {
        System.out.println("m2 overridden in Sample class");
    }
    
    // Overloading m6 instead of overriding - still compile-time polymorphism
    void m6(int i) {
        System.out.println("m6(int) overloaded in Sample class");
    }
    
    // Private method cannot be overridden - this creates a new method
    private void m5() {
        System.out.println("m5 in Sample class (new method, not overridden)");
    }
}
```

Now, test the execution:

```java
public class Test {
    public static void main(String[] args) {
        Example e1 = new Sample(); // Upcasting
        
        e1.m1(); // Compile-time polymorphism - executes from Example
        
        e1.m2(); // Runtime polymorphism - executes from Sample (overridden)
        
        e1.m3(); // Compile-time polymorphism - no override, executes from Example
        
        e1.m4(); // Compile-time polymorphism - final method, executes from Example
        
        // e1.m5(); // Cannot call private method
        
        e1.m6(); // Compile-time polymorphism - no parameter, executes from Example
    }
}
```

### Which Methods Support Which Polymorphism

- **Compile-time polymorphism**: Static methods, final methods, private methods, non-overridden methods
- **Runtime polymorphism**: Non-static, non-final, non-private, overridden methods

Key requirements for runtime polymorphism in superclass:
- Non-static (instance methods)
- Non-final (allows overriding)
- Non-private (allows access and overriding)
- Should be overridden in subclass

### Real-World Examples
The transcript provides excellent real-world analogies:

1. **ATM and Bank Example**: 
   - Customers learn ATM functions (superclass methods)
   - Specific bank implementations (subclasses) execute based on the account
   - Runtime polymorphism allows one ATM interface for multiple banks

2. **Mobile Phone and SIM Cards**:
   - Mobile phone software (superclass) has call() method
   - Execution depends on inserted SIM card (subclass object)
   - Compile-time polymorphism would mean phone works only with one SIM type

3. **Tube Light and Plank**:
   - Electrical components (superclass) work with different brands (subclasses)
   - Switch operation calls superclass method but executes from specific brand

4. **Old Mobile Phone Compatibility**:
   - Devices supporting only one SIM type: compile-time polymorphism
   - Modern phones supporting multiple SIMs: runtime polymorphism

### Target of Object-Oriented Programming
The ultimate goal of OOP is to create real-world objects in the programming world with:

1. **Creating Real-World Objects**: Using classes, objects, variables, methods, constructors, blocks, inner classes
2. **Data Security**: Through encapsulation (private fields, public access methods)
3. **Dynamic Binding**: Through inheritance and polymorphism (runtime polymorphism)

> [!IMPORTANT]
> To achieve runtime polymorphism, we need:
> - Inheritance (superclass-subclass relationship)
> - Method overriding in subclass
> - Upcasting (storing subclass object in superclass reference)
> - Calling non-static, non-final, non-private overridden methods through superclass reference

## Summary

### Key Takeaways
```diff
+ Polymorphism means "many forms" - methods with same name but different implementations
+ Compile-time polymorphism: Method resolved at compile time based on reference type
+ Runtime polymorphism: Method resolved at runtime based on actual object type
+ Runtime polymorphism requires: non-static, non-final, non-private, overridden methods
+ Upcasting (superclass ref = new subclass()) is essential for runtime polymorphism
+ Static, final, private, and non-overridden methods support only compile-time polymorphism
```

### Expert Insight

#### Real-world Application
Runtime polymorphism is fundamental in large-scale applications:
- **Framework Development**: Java collections, Spring framework use polymorphism extensively
- **Plugin Architecture**: Applications like Eclipse, IntelliJ IDEA use polymorphism for extensibility
- **GUI Frameworks**: Swing, JavaFX use polymorphism for event handling and component behavior
- **Microservices Communication**: Interface-based communication leverages runtime polymorphism

#### Expert Path
- Master the execution flow: Reference vs. Object type determination
- Practice upcasting and downcasting scenarios
- Understand `instanceof` operator usage with polymorphism
- Study design patterns like Factory, Strategy, Template Method (all use polymorphism)
- Learn advanced topics: Covariant return types, interface polymorphism

#### Common Pitfalls
**Issue**: Attempting to override static methods (method hiding occurs instead)
**Resolution**: Use instance methods for runtime polymorphism
**Avoidance**: Always declare superclass methods as non-static when runtime polymorphism is needed

**Issue**: Private methods cannot be overridden, creating new methods in subclass
**Resolution**: Check access modifiers when overriding
**Avoidance**: Use protected or public access for methods intended for overriding

**Issue**: Forgetting super() call in constructors when chaining
**Resolution**: Explicitly call super() in subclass constructors
**Avoidance**: Define constructor chaining properly during inheritance design

**Issue**: Calling static methods through objects instead of class reference
**Resolution**: Use ClassName.method() syntax for static methods
**Avoidance**: Understand object vs. class context for method calling

#### Lesser Known Things
- **Method Hiding**: Static methods in subclasses hide (not override) superclass static methods
- **Covariant Return Types**: Since Java 5, overridden methods can have more specific return types
- **Bridge Methods**: Compiler-generated synthetic methods for generic type erasure in overrides
- **Double Dispatch**: Advanced pattern extending visitor pattern for multi-dimensional polymorphism

> [!IMPORTANT]
> Correction Notification: Several spelling and grammar errors were corrected in this study guide based on the transcript:
> - "polymorphis" → "polymorphism"
> - "method of overriding" → "method overriding" 
> - "subass" → "subclass" (multiple instances)
> - "subasses" → "subclasses"
> - "exe" → "execute"
> - "htp" not present, "cubectl" not present, but other typos like "final not" → "final, not", "copy paste" → "copy paste" (implied action), "-Sass" → "Sass" corrected as "in super class" context
> - Grammar and phrasing improved for clarity while maintaining original meaning
