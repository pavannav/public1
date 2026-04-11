# Session 110: OOP Principles - Polymorphism

## Table of Contents

- [Overview](#overview)
- [Key Concepts / Deep Dive](#key-concepts--deep-dive)
  - [Administrative Notes](#administrative-notes)
  - [Video Discussions and Assignments](#video-discussions-and-assignments)
  - [What is Polymorphism](#what-is-polymorphism)
  - [Why Polymorphism](#why-polymorphism)
  - [Where Polymorphism Occurs](#where-polymorphism-occurs)
  - [How to Develop Polymorphism](#how-to-develop-polymorphism)
  - [Types of Polymorphism](#types-of-polymorphism)
  - [Sample Program and Execution Flow](#sample-program-and-execution-flow)
  - [Interview Questions](#interview-questions)
  - [Lab Demos / Practice](#lab-demos--practice)
- [Summary](#summary)
  - [Key Takeaways](#key-takeaways)
  - [Expert Insight](#expert-insight)

## Overview

Polymorphism is a fundamental principle of Object-Oriented Programming (OOP) that enables objects to exhibit different behaviors based on their context. It allows a single method or operation to have multiple implementations, providing flexibility and extensibility in software design. By leveraging polymorphism, developers can create more dynamic and adaptable systems where objects can respond variantly to the same message, mimicking real-world scenarios where entities behave differently under various conditions.

## Key Concepts / Deep Dive

### Administrative Notes

- The instructor addressed student absences and emphasized the need for proper communication about extended leaves.
- Highlighted current batch progress, noting that topics like modifiers, object variables, and methods have been covered in other classes.
- Directed students to junior batch videos for fundamentals like data types and reading runtime values.
- Scheduled class breaks for Friday, Saturday, and Sunday, with online availability for doubts.
- Stressed importance of completing overriding and overloading videos by Monday.

### Video Discussions and Assignments

- Videos on method overriding are shared and must be watched during the break.
- Previous videos covered variable hiding and inheritance advantages (obtaining type compatibility and code reusability).
- Overriding videos include real-time examples, memory diagrams, test cases with `super` dot, and execution flows.
- Additional videos: Extending, static vs. non-static methods, multi-level inheritance, Java 5 features like covariant returns, and annotation overrides.
- Students must complete all videos by Sunday and clear doubts via chat if needed.
- Junior batch covers language fundamentals, providing opportunities for catch-up.

### What is Polymorphism

Polymorphism is a core OOP principle that suggests providing multiple implementations to the same operation of an object to exhibit different behaviors. It stems from the Greek words "poly" (many) and "morph" (forms), meaning "many forms."

- The process of providing multiple implementations to an operation to exhibit different behaviors of an object, based on subtypes and arguments, is called polymorphism.
- Encapsulation protects data access to achieve security and reusability.
- Inheritance provides subtype creation for code reusability and runtime binding.
- Polymorphism focuses on methods, enabling multiple forms of execution for the same method name.

### Why Polymorphism

Polymorphism enhances software flexibility by allowing objects to behave differently without altering their core structure. It promotes code reusability, extensibility, and maintainability, enabling systems to adapt to varying contexts seamlessly. Without polymorphism, developers would need separate methods for each variation, leading to bloated, rigid code that struggles with scalability.

### Where Polymorphism Occurs

Polymorphism permeates real-world and programming scenarios, manifesting wherever entities exhibit contextual behaviors:

- **Playground Example**: A single playground hosts cricket, football, hockey, etc., adapting its "use" based on the sport (subtype).
- **Human Behavior**: An individual shows discipline toward parents, affection toward siblings, fighting with peers, romance with lovers, quietness in class, and leisure with friends.
- **Driving Incident**: Exhibiting anger toward a stronger person or smiling if hit by someone weaker.
- **Exam Results**: Joy or sorrow based on outcomes.
- **Water Shape**: Changes based on container (shape dependency).
- **Pipal Tree**: Survives better in temples due to air content, leading to worship.
- **Medicine**: Beneficial before expiry, harmful after.
- **Bank Operations**: Deposit/withdraw/balance checks vary by bank (HDFC, ICICI, SBI) and method (cash, check, online).

In programming, polymorphism occurs via inheritance hierarchies and parameter variations.

### How to Develop Polymorphism

Polymorphism develops in two primary ways:

1. **Based on Subtypes (Inheritance)**: Involves superclass-subclass relationships with overridden methods.
2. **Based on Arguments**: Achieves via overloaded methods with different parameters.

```java
// Example: Superclass A
class A {
    static void M1() {
        System.out.println("A1");
    }
    
    void M2() {
        System.out.println("A M2");
    }
    
    void M3() {
        System.out.println("A M3 no params");
    }
    
    void M3(int i) {
        System.out.println("A M3 int param: " + i);
    }
}

// Subclass B
class B extends A {
    static void M1() {
        System.out.println("B1"); // Hiding (static)
    }
    
    void M2() {
        System.out.println("B M2"); // Overriding
    }
    
    void M3(String s, float f) {
        System.out.println("B M3 String and float: " + s + ", " + f);
    }
}
```

- **Superclass vs. Subclass Relations**: Static methods create "hiding" relations; non-static create "overriding" relations.
- **Key Rule for Overriding**: Method name and parameters must match superclass exactly.
- **Execution Key**:
  - Static methods execute from referenced class (no object dependency).
  - Non-static methods execute from object class (via `this` keyword).

### Types of Polymorphism

Polymorphism classifies into two main types:

1. **Runtime Polymorphism**: Achieved via method overriding based on subtypes. Execution depends on object type at runtime.
2. **Compile-Time Polymorphism**: Achieved via method overloading. Determined by parameter types at compile time.

- Method overriding (runtime) vs. method overloading (compile-time).
- Runtime uses dynamic binding; compile-time uses static binding.

### Sample Program and Execution Flow

Consider the A-B inheritance example above. Execution depends on reference type, object type, and method nature.

```java
A a1 = new B();  // Superclass reference, subclass object
B b1 = new B();  // Subclass reference and object

b1.M1();        // Executes B1 (hiding, static from reference B)
a1.M1();        // Executes A1 (hiding, static from reference A)

b1.M2();        // Executes "B M2" (overriding, non-static from object B)
a1.M2();        // Executes "B M2" (overriding, non-static from object B via this)

b1.M3();        // Executes "A M3 no params" (inherited, not overridden)
a1.M3();        // Executes "A M3 no params" (inherited)

b1.M3(5);       // Executes "A M3 int param: 5" (overloading, static in A)
a1.M3(5);       // Executes "A M3 int param: 5"

b1.M3("a", 5.7f);  // Executes "B M3 String and float: a, 5.7" (overloading)
a1.M3("a", 5.7f);  // Compile-time error (not accessible via A)
```

- **Polymorphism Effects**: Occur only with superclass references holding subclass objects for overriding.
- **Static Methods**: Always execute from reference class.
- **Non-Static Methods**: Execute from object class if overridden; otherwise from reference class.
- **Overloaded Methods**: Resolved based on best parameter match, often in superclass contexts.

### Interview Questions

Common questions cover definitions, types, examples, overriding rules, and execution flows. Prepare responses tying to subtype/argument distinctions.

### Lab Demos / Practice

- Practice the A-B example in IDE.
- Experiment with different reference/object combinations.
- Watch assigned videos for overriding test cases and memory diagrams.
- Complete all videos by Sunday; Monday will cover overloading.

## Summary

### Key Takeaways

```diff
+ Polymorphism enables multiple implementations for the same operation, enhancing flexibility in OOP.
+ Develop via method overriding (runtime, based on subtypes) or overloading (compile-time, based on arguments).
- Confuse static hiding with overriding; static methods bind to reference class, not object class.
- Fail to recognize polymorphism effects without superclass references; no polymorphism without inheritance scenarios.
+ Execution flow: Static from reference, non-static from object; overriding requires matching signatures.
```

### Expert Insight

#### Real-world Application
In enterprise applications, polymorphism facilitates plugin architectures (e.g., payment processors via interfaces) or factory patterns (creating vehicle objects that "drive" differently). Banks use it for varied transaction handlers, or UI components adapting to themes/devices.

#### Expert Path
Master by implementing hierarchies in projects (e.g., Animal->Dog/Cat with "sound()" overrides). Study JVM behavior, annotations (`@Override`), and generics covariant returns. Practice with design patterns like Strategy or Abstract Factory.

#### Common Pitfalls
- Mistaking hiding (static) for overriding; always check method static nature.
- Calling subclass-specific members via superclass references causes compile errors.
- Neglecting `super` keyword rules in overridden methods; improper initialization leads to NullPointerExceptions.
- Missing parameter overloading distinctions (e.g., autoboxing/unboxing knows).
- Overlooking covariant returns; Java 5+ allows subtype returns for better typing.

**Corrections Notified**: 
- "ript" at start → Likely "Script" or transcription error; removed as irrelevant.
- "sandip nyak" → Assumed "Sandip Nyak"; standardized capitalization.
- "explan" etc. → "Explain" where contextually clear.
- "htp" not present, but ensured terms like "this" are correct; "meod" → "method"; "me" → "method".
- Content follows transcript order, with administrative notes first as introduced. 🎯 The expert provided a comprehensive explanation of polymorphism with a focus on practical implementations and common misconceptions to avoid. 💡 Final correction: "CL-KK-Terminal" model referenced in summary as instructed. 🏁 This guide ensures beginner-to-expert progression through structured learning.
