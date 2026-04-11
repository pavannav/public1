# Session 104: OOP Principles - Super Keyword

## Table of Contents
- [Recap: Upcasting and Downcasting](#recap-upcasting-and-downcasting)
- [Introduction to Super Keyword](#introduction-to-super-keyword)
- [What is Super Keyword?](#what-is-super-keyword)
- [Why Use Super Keyword?](#why-use-super-keyword)
- [Accessing Members: a vs. this.a vs. super.a](#accessing-members-a-vs-thisa-vs-supera)
- [Forms of Super Keyword](#forms-of-super-keyword)
- [Deep Dive: Super Constructor Call (super())](#deep-dive-super-constructor-call-super)
- [Rules for Super()](#rules-for-super)
- [Test Program and Execution](#test-program-and-execution)
- [Practical Implementation Tips](#practical-implementation-tips)
- [Summary](#summary)

## Recap: Upcasting and Downcasting
This section revisits the concepts of upcasting and downcasting from the previous class. Upcasting involves treating a subclass object as a superclass type, enabling polymorphism. Downcasting allows accessing subclass-specific members by casting back to the subclass type.

**Key Points:**
- Upcasting: Implicit conversion from subclass to superclass.
- Downcasting: Explicit casting back to subclass, requiring careful use to avoid runtime exceptions.

## Introduction to Super Keyword
Today, we transition to the super keyword, building on inheritance concepts. Ensure all doubts from upcasting/downcasting are clarified before proceeding.

## What is Super Keyword?
The super keyword is a reference variable used in Java to access superclass members. It is analogous to the `this` keyword but specifically targets the parent class.

**Key Concepts:**
- Super is a keyword, not a variable.
- It enables differentiation between superclass and subclass members.

## Why Use Super Keyword?
Super keyword is essential for invoking or calling superclass members within subclass methods or constructors. Without it, direct member access might refer to subclass members instead of superclass ones.

**Scenarios:**
- When subclass hides superclass members (e.g., variable shadowing or method overriding), super explicitly accesses the superclass version.

💡 **Tip:** Always practice daily topics for understanding and job readiness.

## Accessing Members: a vs. this.a vs. super.a
Consider this example:

```java
class A {
    int a = 10;
}

class B extends A {
    int a = 50; // Subclass variable hides superclass a

    void m1() {
        int a = 70; // Local variable
        System.out.println(a);     // Prints local a: 70
        System.out.println(this.a); // Prints current class a: 50
        System.out.println(super.a); // Prints superclass a: 10
    }
}
```

**Differences:**
- `a`: Refers to local variable or parameter first, then follows the inheritance hierarchy.
- `this.a`: Always refers to the current class instance.
- `super.a`: Always refers to the superclass instance.

## Forms of Super Keyword
Super keyword has two primary forms:
1. **super()**: For calling superclass constructors.
2. **super.dot (super.)**: For accessing superclass variables and methods.

## Deep Dive: Super Constructor Call (super())
Super() is used within subclass constructors to invoke the superclass constructor. This ensures proper initialization of inherited members.

### Example:
```java
class A {
    A() { System.out.println("A no-param constructor"); }
    A(int x) { System.out.println("A param constructor"); }
}

class B extends A {
    B() { super(); } // Explicit call to A()
    B(int x) { super(x); } // Call to A(int x)
}
```

**Execution Flow:**
- In `new B()`, super() calls `A()`, then `B()` executes.
- Ensures superclass state is initialized before subclass.

## Rules for Super()
1. **Purpose**: Used for calling superclass constructor from subclass constructor to initialize superclass non-static variables in the subclass object.
2. **Mandatory**: Calling a superclass constructor is mandatory from every subclass constructor.
3. **Compiler Behavior**: If not explicitly placed, compiler inserts `super();` (call to no-param constructor) internally during compilation.
4. **Default Call**: Compiler places `super();` in all constructors by default, which matches a no-param constructor in the superclass.
5. **Parametric Constructors**: If superclass has only parametric constructors, explicitly place `super(args);` matching an available constructor.
6. **Private Constructors**: If superclass has only private constructors, inheritance is impossible as subclass cannot access or call them.
7. **Visibility Requirement**: Superclass must have at least one accessible (non-private) constructor.

**Additional Insights:**
- If superclass lacks a no-param constructor, subclass constructors must explicitly call an available constructor.
- Modifications in subclass creations require appropriate super calls.

## Test Program and Execution
Consider this program:

```java
class A {
    A() { System.out.println("hi"); }
    A(int x) { System.out.println("hi"); }

    void display() { System.out.println("how are you"); }
}

class B extends A {
    B() { System.out.println("hello"); }
    B(int x) { System.out.println("hello"); }

    public static void main(String[] args) {
        B b = new B();
        b.display();
    }
}
```

**Issues and Solutions:**
- Without explicit `super()` in parametric constructor, compile error occurs as no matching no-param constructor exists.
- Solution: Add `super(x);` in `B(int x)` to match `A(int x)`.

**Corrected Version:**
```java
class B extends A {
    B(int x) { super(x); System.out.println("hello"); }
}
```
Output: "hi", "hello", "how are you"

## Practical Implementation Tips
- Pass constructor parameters directly (e.g., `super(x);`) for parametrized superclass constructors.
- Avoid redundant `super();` unless needed for clarity.
- Practice with multiple constructors to solidify understanding.

## Summary
### Key Takeaways
```diff
+ Super keyword is used to access superclass members in subclasses, differentiating them from subclass members.
+ super() calls superclass constructors, which is mandatory for proper inheritance.
- Without explicit super() in subclass, compiler places super() assuming a no-param constructor exists in superclass.
! If superclass lacks accessible constructors, inheritance fails with compile errors.
```

### Expert Insight
**Real-world Application**: In frameworks like Spring or Java EE, super() ensures proper bean initialization and inheritance chains, allowing layered class hierarchies in large applications for maintainable code.

**Expert Path**: To master, experiment with multi-level inheritance and override scenarios using super to access grandparent methods. Study design patterns like Decorator or Template Method that rely on super() for extensibility.

**Common Pitfalls**: Forgetting to call super() in parametric constructors leads to implicit calls failing without a no-param superclass constructor. Accessing private superclass constructors in subclasses causes access errors. Overusing super can indicate poor design; prefer method overriding with super for selective overrides.

Lesser Known Things: Super can be chained across multiple inheritance levels, and in inner classes, super refers to the outer class. Always verify accessibility of superclass members to prevent runtime viscos.
