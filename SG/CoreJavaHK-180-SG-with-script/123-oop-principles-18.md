# Session 123: OOP Principles - Types of Polymorphisms

**Table of Contents**
- [Revision of Variable and Method Access](#revision-of-variable-and-method-access)
- [Introduction to Types of Polymorphisms](#introduction-to-types-of-polymorphisms)
- [Compile-Time Polymorphism](#compile-time-polymorphism)
- [Runtime Polymorphism](#runtime-polymorphism)
- [Static Binding vs. Dynamic Binding](#static-binding-vs-dynamic-binding)
- [Early Binding vs. Lazy Binding](#early-binding-vs-lazy-binding)
- [Benefits of Runtime Polymorphism](#benefits-of-runtime-polymorphism)
- [Methods and Polymorphism Types](#methods-and-polymorphism-types)
- [Abstract Classes and Interfaces](#abstract-classes-and-interfaces)
- [Test Cases and Lab Demos](#test-cases-and-lab-demos)

## Revision of Variable and Method Access

### Overview
This section revisits fundamental concepts of variable and method access in object-oriented programming, focusing on inheritance and polymorphism. It builds on prior knowledge of static and non-static members, emphasizing how the JVM handles references, objects, and execution contexts in superclass-subclass relationships.

### Key Concepts/Deep Dive
- **Static Variables**: Searched and accessed from the referenced variable class, but values are read and modified from the current object class.
  - Example: A static variable `a` defined in superclass `A` and shadowed in subclass `B` will access the value based on the reference type, but modify the shared static instance.
- **Non-Static Variables**: Searched from the referenced variable class, values read and modified from the current object.
  - Key Point: Non-static variables do not execute "from subclass" like methods; they use the subclass value only if overridden, but access logic remains tied to the reference.
- **Static Methods**: Bound at compile-time to the referenced variable class and executed there; cannot be overridden for runtime polymorphism.
- **Non-Static Methods**: Can exhibit polymorphism based on overriding.
- **Reference and Current Object**: 
  - Referenced variable: Determines where to search for members (e.g., `A a = new B();` uses `A`'s structure).
  - Current object: Determines data values for non-static fields and execution for overridden methods.
- **Key Distinction**:
  - Static/non-static variables: Searched by reference type, values from current object.
  - Methods: Execution depends on static/non-static nature and polymorphism type.

### Code/Config Blocks
```java
class A {
    static int a = 10;
    int x = 20;

    static void m1() {
        System.out.println("Static method m1 in A");
    }

    void m2() {
        System.out.println("Non-static method m2 in A");
    }
}

class B extends A {
    static int a = 16;  // Shadowing
    int x = 60;

    static void m1() {  // Hiding
        System.out.println("Static method m1 in B");
    }

    void m2() {
        System.out.println("Non-static method m2 in B");  // Overriding
    }
}

class Test {
    public static void main(String[] args) {
        A a1 = new B();  // Upcasting

        System.out.println(a1.a);  // Output: 10 (static, searched in A)
        System.out.println(a1.x);  // Output: 20 (non-static, from A object hierarchy, values from current object B)
        a1.m1();                  // Output: "Static method m1 in A" (executed from A)
        a1.m2();                  // Output: "Non-static method m2 in B" (overridden, runtime polymorphism)
    }
}
```

### Tables
| Member Type | Searched In | Executed/Value Source | Polymorphism Type |
|-------------|-------------|-----------------------|-------------------|
| Static Variable | Referenced Variable Class | Current Object | N/A (Static) |
| Non-Static Variable | Referenced Variable Class | Current Object | N/A |
| Static Method | Referenced Variable Class | Referenced Variable Class | Compile-Time |
| Non-Static Method | Referenced Variable Class | Current Object Class (if overridden) | Runtime |

### Lab Demos
1. **Create Classes as Described**: Implement class `A` with static variable, non-static variable, static method, and non-static method. Implement class `B` extending `A` with shadowed/hidden/overridden members.
2. **Test Access from Reference**:
   - Create `A a1 = new A();` and call members: Observe compile-time binding.
   - Create `A a2 = new B();` and call members: Note differences in output for static vs. non-static.
   - Expected Outputs:
     - `a1.a`: 10, `a1.x`: 20, `a1.m1()`: Static m1 in A, `a1.m2()`: Non-static m2 in A.
     - `a2.a`: 10, `a2.x`: 20 (values from B object via current object), `a2.m1()`: Static m1 in A, `a2.m2()`: Non-static m2 in B (overriding).
3. **Modify Values and Re-test**: Change values in `B` and observe how current object affects data access.

## Introduction to Types of Polymorphisms

### Overview
Polymorphism in object-oriented programming allows methods to have multiple implementations, enabling dynamic behavior. It occurs in method definitions, where multiple methods with the same name exist, differing by parameters (overloading) or logic (overriding). Polymorphism types are categorized based on when and how method binding occurs, determining whether behavior is fixed or adaptable.

### Key Concepts/Deep Dive
- **Definition**: Multiple implementations of a single method, varying by subtype or parameters.
- **Two Types**:
  - Compile-Time Polymorphism
  - Runtime Polymorphism
- **Basis of Classification**: Determined by method invocation and execution order.
  - Compiler binds method call to definition based on referenced variable class.
  - JVM executes either the same bound method or a subclass version.

## Compile-Time Polymorphism

### Overview
Compile-time polymorphism occurs when the compiler binds the method call to a specific definition before execution, based on the referenced variable class type. The JVM adheres to this binding, resulting in fixed, predictable behavior known at development time. This is often associated with method overloading.

### Key Concepts/Deep Dive
- **Mechanism**: Compiler links method call to matched parameter method in referenced variable class. JVM executes the same method.
- **Example**: Method overloading where signatures differ (e.g., different parameters).
- **Characteristics**:
  - Static code: Behavior decided at compile-time.
  - No runtime decision-making based on object type.
- **Advantages**: Early decision-making, performance benefits, static type safety.
- **Disadvantages**: Less flexible for dynamic applications; cannot adapt to subclass objects.

## Runtime Polymorphism

### Overview
Runtime polymorphism allows method execution to adapt at runtime based on the actual object type, even if the reference is of a superclass. It enables dynamic behavior, where the JVM chooses the appropriate implementation from the subclass if overriding exists, promoting flexibility in object-oriented designs.

### Key Concepts/Deep Dive
- **Mechanism**: Compiler binds to referenced variable class, but JVM executes from current object class if overridden.
- **Example**: Method overriding in inheritance hierarchies.
- **Characteristics**:
  - Dynamic: Decisions made during execution based on object state.
  - Requires upcasting and overriding for full effect.
- **Advantages**: Enables loose coupling, dynamic applications, code reusability.
- **Disadvantages**: Slight runtime overhead due to extra checks.

## Static Binding vs. Dynamic Binding

### Overview
Binding refers to linking method calls to their definitions. Static binding is resolved at compile-time (eager), while dynamic binding occurs at runtime (lazy), offering more flexibility.

### Key Concepts/Deep Dive
- **Static Binding (Early Binding)**: Compiler determines linking; JVM follows. Equivalent to compile-time polymorphism. Code reflects fixed logic.
- **Dynamic Binding (Lazy Binding)**: Compiler plans, JVM executes based on context. Equivalent to runtime polymorphism. Adapts to objects.
- **Analogy**: Planning a trip early (static) vs. deciding on-site (dynamic).

## Early Binding vs. Lazy Binding

### Overview
Early binding involves pre-execution planning (compile-time decisions), while lazy binding defers to runtime for adaptability. These terms describe when method resolution occurs relative to execution.

### Key Concepts/Deep Dive
- **Early Binding (Eager Binding)**: Compile-time processing, like booking tickets in advance. Used in static binding.
- **Lazy Binding (Late Binding)**: Runtime postponement, like last-minute plans. Used in dynamic binding.
- **Modern Usage**: Static/dynamic binding terms are more common in discussions.

## Benefits of Runtime Polymorphism

### Overview
Runtime polymorphism is preferred for dynamic applications, allowing systems to handle varied inputs adaptively. It promotes good design principles like the Open-Closed Principle and supports real-world scenarios where behavior must vary by subtype.

### Key Concepts/Deep Dive
- **Dynamic Applications**: Adapts to changing objects without code changes.
- **Real-World Analogy**: Human digestive system as runtime polymorphic (handles varied food). Compile-time would be restrictive (e.g., only vegetarian).
- **Best Practice**: Implement runtime polymorphism for scalable, maintainable code.

## Methods and Polymorphism Types

### Overview
Polymorphism type depends on method modifiers and inheritance behavior. Only specific method types enable runtime polymorphism, while others default to compile-time.

### Key Concepts/Deep Dive
- **Default Polymorphism**: Compile-time for all methods.
- **Conditions for Runtime Polymorphism**:
  - Upcasting (superclass reference to subclass object).
  - Method overriding (non-static, non-private, non-final, non-overloaded as target).
- **Method Categorization**:
  - Static: Compile-time.
  - Non-Static Private/Final: Compile-time.
  - Non-Static Overloaded: Compile-time.
  - Non-Static Overridden (non-private, non-final): Runtime.
- **Key Rule**: Achieving runtime polymorphism requires non-static, non-private, non-final methods with overriding and upcasting.

## Abstract Classes and Interfaces

### Overview
Abstract classes and interfaces enforce certain polymorphism patterns. Interfaces guarantee runtime polymorphism for their methods, promoting loose coupling and design consistency.

### Key Concepts/Deep Dive
- **Abstract Classes**: Can contain concrete/abstract methods. Guarantee subclass objects; runtime polymorphism if abstract method overridden.
- **Interfaces**: Contain only abstract methods; force subclass implementation. Guarantee 100% runtime polymorphism, loose coupling.
- **Benefits**: Interfaces are ideal for complete abstraction and polymorphism assurance.

### Tables
| Concept | Guarantees Polymorphism Type | Key Feature |
|---------|-------------------------------|-------------|
| Concrete Methods | Compile-Time | Fixed execution |
| Abstract Methods | Runtime (if overridden) | Enforced subclass implementation |
| Interface Methods | 100% Runtime | Complete abstraction, loose coupling |

## Test Cases and Lab Demos

### Overview
Test cases illustrate polymorphism in practice, showing how reference types, object types, and method properties affect output.

### Key Concepts/Deep Dive
- Based on reference/object combinations, modifiers determine execution.

### Lab Demos
1. **Upcasting Test**:
   ```java
   Example e = new Sample();  // Upcasting
   e.m1();  // Static, Compile-Time
   e.m2();  // Non-Static Overridden, Runtime
   e.m3();  // Non-Static Not Overridden, Compile-Time
   e.m4();  // Non-Static Overloaded (no param match), Compile-Time
   ```
   - Implement `Example` superclass and `Sample` subclass with methods as described:
     - `m1`: Static in `Example`.
     - `m2`: Non-Static in `Example`, overridden in `Sample`.
     - `m3`: Non-Static in `Example`, not overridden.
     - `m4`: Non-Static in `Example`, overloaded in `Sample`.
   - Expected: Understand polymorphisms based on output.

2. **Abstract/Interface Scenario**:
   - Create interface `I` with method `abc()`.
   - Implement in subclass `Sub`.
   - Upcast: `I i = new Sub(); i.abc();` → Runtime Polymorphism.
   - Discuss guarantees.

## Summary

### Key Takeaways
```diff
+ Polymorphism: Multiple implementations for methods by subtype or parameters.
+ Compile-Time Polymorphism: Static binding, fixed at compile-time, compiler decides execution.
- Runtime Polymorphism: Dynamic binding, adapts at runtime based on current object, enables flexible applications.
+ Static/Dynamic Binding: Early/lazy alternatives; dynamic preferred for adaptability.
- Overloading vs. Overriding: Overloading is compile-time; overriding is runtime (with upcasting).
+ Loose Coupling: Achieved via interfaces for 100% runtime polymorphism.
- Tight Coupling: Results from compile-time approaches, limits dynamism.
```

### Expert Insight

#### Real-world Application
Runtime polymorphism powers frameworks like Spring (dependency injection) or collections (Iterator pattern), allowing code to work with varied implementations (e.g., lists as ArrayList or LinkedList) without changes. In microservices, it enables pluggable services adapting to runtime configurations.

#### Expert Path
Master polymorphism by designing interfaces for contracts, implementing overriding in hierarchies, and testing with upcasting scenarios. Study design patterns (e.g., Strategy, Factory) that rely on runtime polymorphism. Practice refactoring compile-time code to runtime for scalability.

#### Common Pitfalls
- Forgetting upcasting: Leads to compile-time behavior even with overriding.
- Static methods in hierarchies: Can't achieve runtime polymorphism; use instance methods.
- Incomplete overriding: Subclass must match signature exactly for runtime effect.
- Performance assumptions: Runtime polymorphism adds minimal overhead but is worth the flexibility.
- Abstract complexities: Abstract classes allow concrete methods, potentially mixing polymorphism types.

#### Lesser Known Things
- JVM optimization: While runtime polymorphism incurs JVM checks, JIT compilers often inline simple cases for performance.
- Multiple inheritance: Interfaces simulate it via polymorphism, overriding methods from multiple sources.
- Generics interaction: Polymorphism works alongside generics for type-safe dynamic behavior (e.g., `List<?>` with overridden methods).

### Corrections and Notifications
The following corrections were made to obvious transcript errors for clarity and accuracy in the study guide (typos, grammatical fixes, technical accuracies retained):
- "ript" (start) → Ignored as incomplete.
- "bb1" → Corrected to "b1" (consistent variable naming).
- "this do I have placed" → "this. do I have placed" (added missing dot).
- "compaund polymorphic stomach" → "compound polymorphic stomach".
- "loos coupling" → "loose coupling".
- "Methcalling" → "Method calling".
- "Compiler buiding" → "Compiler binding".
- "override" (various) → Corrected spellings, but technical terms like "overriding" are used accurately.
- Minor "uh", "um" filler words removed for conciseness. No functional content altered; fixes improve readability without changing meaning.
