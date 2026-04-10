# Session 67: Inheritance

## Table of Contents
- [Overview](#overview)
- [Wholes of Inheritance](#what-is-inheritance)
- [Why Inheritance](#why-inheritance)
- [Extending vs Reusing](#extending-vs-reusing)
- [Is-a Relation vs Has-a Relation](#is-a-relation-vs-has-a-relation)
- [When to Develop Inheritance](#when-to-develop-inheritance)
- [How to Develop Inheritance](#how-to-develop-inheritance)
- [Superclass and Subclass](#superclass-and-subclass)
- [Type Obtaining in Inheritance](#type-obtaining-in-inheritance)
- [Storing Objects in Inheritance](#storing-objects-in-inheritance)
- [Visibility of Members](#visibility-of-members)

## Overview
This session focuses on the fundamental OOP concept of inheritance in Java, explaining its purpose, implementation, and practical applications. The instructor uses real-life analogies, such as building houses, family relations, and business extensions, to clarify when and why inheritance is used. Key distinctions are made between extending functionality and merely reusing objects, emphasizing the is-a relationship over has-a. Concepts include superclass/subclass creation, keyword usage (extends vs implements), and rules for accessing inherited members. The lecture corrects common misconceptions and provides examples like Person/Student, Animal/Lion to illustrate subtype creation.

## What is Inheritance
Inheritance is one of the four OOP principles. It defines a parent-child relationship where the child class can access properties and behaviors of the parent class. Unlike mere reuse, inheritance is intended for extending or implementing new functionality by creating a subtype object. It's the process of deriving a new class from an existing class to obtain type, properties, and behaviors, allowing the new class to be treated as the existing type.

Key points from the discussion:
- Inheritance is not for reusing existing functionality alone but for extending it.
- Example analogy: Constructing a new house vs. adding floors to an existing one. Reuse the base and extend upwards.

> [!NOTE]
> Real-life parallel: A child as an extension of parents, obtaining traits (properties) and behaviors while adding new ones.

## Why Inheritance
Inheritance is required when you want to create a subtype object from an existing type, obtaining its properties and behaviors, and extending the functionality. The core purpose is to allow the new object to be treated as the existing type while adding specialized traits.

Key reasons:
- For extending functionality: Create new objects that build upon existing ones.
- For implementing: Fulfill abstract or interface contracts while reusing base functionality.
- To treat multiple similar objects as a common type (e.g., grouping animals under a generic "Animal" type).

Analogy: A student extending from a person—obtaining basic human properties (eyes, ears, behavior like eating) while adding new properties (student ID, behaviors like reading, writing).

> [!IMPORTANT]
> Misconception corrected: Inheritance is not just for reuse; it's for extension first, then reuse.

## Extending vs Reusing
Inheritance involves both extending and reusing, but the primary goal is extension. Reusing without extension can be done via object creation (has-a relation), but inheritance requires the is-a relation for subtype extension.

| Concept | Purpose | Relation | Keyword |
|---------|---------|----------|---------|
| Reusing | Access existing functionality via object creation | has-a | Object creation (e.g., Animal a = new Animal(); a.eat();) |
| Extending | Add new functionality while reusing | is-a | extends/implements |

Example from code:
- Without extension: Create separate Student and Person classes, reuse via objects.
- With extension: Class Student extends Person → Student inherits Person's type.

## Is-a Relation vs Has-a Relation
Two fundamental relations in OOP:
- **Is-a Relation**: Extension/derivative. Object extends another, obtaining type (e.g., Student is-a Person). Use inheritance.
- **Has-a Relation**: Composition/use. Object contains another (e.g., Computer has-a HardDisk). Use object creation.

Clarification table:

| Relation | Example | Use Inheritance? | Access Method |
|----------|---------|------------------|---------------|
| Is-a | Student is-a Person | Yes | Direct access to inherited members |
| Has-a | Car has-a Engine | No | Create object: Engine e = new Engine(); |

Transcript examples:
- Lion is-a Animal (inheritance).
- Computer has-a HardDisk (object composition).
- Faculty has-a Mic (has-a, not is-a).

> [!NOTE]
> Test: Apply "is-a" vs. "has-a" to decide: Lion is-a Animal → Inheritance. Computer has-a HardDisk → No inheritance.

## When to Develop Inheritance
Develop inheritance when:
- You want to create a subtype of an existing type for extending functionality.
- To obtain type, properties, and behaviors while adding new ones.
- For grouping multiple objects under a common type (polymorphism preparation).
- When the new class should be treated as the existing class type.

Real-world rationale: Extend an existing house (reuse base) by adding floors, rather than building anew for cost/efficiency.

## How to Develop Inheritance
Inheritance is developed using extends (class-to-class) or implements (class-to-interface).
- **extends**: For class inheritance. Right side is superclass, left side is subclass.

Example:
```java
class Student extends Person {
    // Student inherits Person's type, adds new properties/behaviors
}
```

- **implements**: For implementing interfaces (covered later).

> [!IMPORTANT]
> Odd statement check: "Class to interface" requires implements, not extends. Extends only for class-class or interface-interface.

## Superclass and Subclass
Terminology:
- **Superclass** (parent, base): Existing class being inherited from.
- **Subclass** (child, derived): New class inheriting from superclass.

| Term | Java Synonym | C++ Synonym |
|------|--------------|-------------|
| Superclass | Parent | Base |
| Subclass | Child | Derived |

In code: Person (super) → Student (sub).

## Type Obtaining in Inheritance
Subclass obtains:
1. **Type**: Subclass treated as superclass type → Store subclass object in superclass variable.
2. **Properties**: Non-private inherited properties.
3. **Behaviors**: Non-private inherited methods.

Meaning: Subclass gets permission to access superclass members directly, as if defined locally.

```java
class Person {
    String name;
    void eat() { System.out.println("Eating"); }
}

class Student extends Person {
    // Student now treated as Person type
}

// Usage
Person p = new Student(); // Allowed: Student is-a Person
p.eat(); // Direct access: extends + requirement obtained
Student s = new Person(); // Error: Person is not-a Student
```

> [!NOTE]
> Analogy: Child directly accesses parent's fridge (inherited permission) vs. friend needing permission (has-a).

## Storing Objects in Inheritance
Rule: Can store subclass object in superclass variable, but not vice versa.
- > [!IMPORTANT]
  > Right side (object) must be subtype of left side (variable type). Else, incompatible types error.

Diagrams:
```mermaid
graph TD
    A[Person (Superclass)] --> B[Student (Subclass)]
    C[Person p = new Student();] --> D[Allowed: Student is-a Person]
    E[Student s = new Person();] --> F[Error: Person is not-a Student]
```

Real-time example: Father can attend child's function; child cannot attend in father's place (directional).

## Visibility of Members
Not all superclass members are accessible in subclass:
- **Private**: Never accessible.
- **Default**: Accessible within same package.
- **Protected**: Always accessible to subclasses.
- **Public**: Always accessible.

Example correction: Can access parent's visible properties directly, but not all (e.g., parent's private accounts not accessible).

> [!WARNING]
> 🛡️ Avoid accessing private members: Inherited only if visible.

## Summary

### Key Takeaways
```diff
+ Inheritance creates parent-child relation for extending functionality.
- Do not confuse with has-a: Inheritance is is-a, not just reuse.
! Primary purpose: Obtain type, extend properties/behaviors, reuse existing.
💡 Real-world: Build on existing (house floors) vs. duplicate (new land).
+ extends for class-class; implements for classes from interfaces.
```

### Expert Insight

#### Real-world Application
In production Java apps, use inheritance for model hierarchies (e.g., Vehicle → Car, Truck). Frameworks like Spring rely on subtype polymorphism for dependency injection, allowing flexible object treatment.

#### Expert Path
Master polymorphism (via inheritance) for advanced patterns like Strategy or Factory. Practice access modifiers to control visibility; over-engineer with composition if unsure, but inherit for true "is-a".

#### Common Pitfalls
- **Assuming inheritance == reuse**: Leads to tight coupling; prefer composition for loose relations.
- **Storing superclass in subclass variables**: Compile error; violates type rules—forces superposition.
- **Misguiding by appearance**: Code saying "extends" doesn't make is-a; apply relational tests.
- **Resolution**: Always check class hierarchy and visibility rules. Test with instanceof or direct assignment to verify relations.
- **Lesser known**: Inheritance shares state via reference, not copy-paste—private fields remain super-exclusive.
``` 
Model ID: CL-KK-Terminal
```
