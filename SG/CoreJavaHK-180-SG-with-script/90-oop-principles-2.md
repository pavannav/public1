# Session 90: OOP Principles 2 (Inheritance)

## Table of Contents
- [Inheritance](#inheritance)
  - [Overview](#overview)
  - [Key Concepts](#key-concepts)
  - [Code Examples](#code-examples)
  - [Real-World Examples](#real-world-examples)
  - [Lab Demo](#lab-demo)
  - [Types of Inheritance](#types-of-inheritance)

## Inheritance

### Overview
Inheritance is one of the fundamental principles of Object-Oriented Programming (OOP), establishing a parent-child relationship between classes. It allows a new class (subclass) to derive properties and behaviors from an existing class (superclass), enabling the extension of functionality while maintaining type relationships. This principle facilitates polymorphism, where a subclass inherits the type of its superclass, allowing subclass objects to be stored in superclass variables. Inheritance is not merely for reusing code but primarily for extending existing functionality to new levels in a loosely coupled, runtime polymorphic manner.

### Key Concepts

#### Definition and Purpose
Inheritance is the process of creating a new class (subclass or child class) deriving from an existing class (superclass or parent class) for obtaining the type, properties, and behaviors of the existing class. The primary purpose is to extend the functionality of the existing object, not just to reuse its members.

- **Type Relation**: Classes are connected through an "is-a" relationship, where the subclass is a specialized version of the superclass.
- **Member Accessibility**: Subclass can access both inherited members from the superclass and its own members without recreation.
- **Runtime Polymorphism**: Allows for dynamic behavior based on the object's actual type at runtime.

#### Why Inheritance?
Inheritance enables:
- **Extension over Reusing**: While reusing existing functionality is a benefit, the core goal is extending it (e.g., adding new properties like student-specific attributes beyond basic person attributes).
- **Code Maintainability**: Avoids duplicating code and supports hierarchical relationships.

Common misconception: Inheritance is often mistakenly taught as primarily for reusability, but if reusability is the only goal, use composition (has-a relation) instead. Inheritance increases source code files and classes unnecessarily for pure reuse.

#### Advantages
- **Type Obtaining**: Subclass inherits the type of superclass, enabling storage of subclass objects in superclass variables.
- **Reusability**: Subclass can use superclass members directly.
- **Extensibility**: Build upon existing classes to create more specialized ones.

### Code Examples

```java
// Example 1: Basic Inheritance without Instances
class A {
    static int a = 10;
    int x = 20;
    static void m1() {
        System.out.println("M1 - Class A static method");
    }
    void m2() {
        System.out.println("M2 - Class A non-static method");
    }
}

class B extends A {
    // B inherits type from A, so B can be stored in A type variables
}

// Test class
class Test01 {
    public static void main(String[] args) {
        A a1 = new B(); // Works due to inheritance relation
        // B b1 = new A(); // Error: A cannot be converted to B
        System.out.println(B.a); // Accessing inherited static member
    }
}
```

Key Points:
- `B` becomes a subtype of `A`.
- Compile-time error occurs if incompatible types are assigned without relation.

```java
// Example 2: Accessing Members
class A {
    static int a = 10;
    int x = 20;
    static void m1() {
        System.out.println("M1 class A");
    }
    void m2() {
        System.out.println("M2 class A");
    }
}

class B extends A {
    // Inherits all from A
}

// Test class
class Test02 {
    public static void main(String[] args) {
        A a1 = new A();
        B b1 = new B();
        System.out.println("B.a: " + B.a); // Static access
        b1.m1(); // Inherited method
        b1.m2(); // Inherited method via instance
    }
}
```

Output:
```
B.a: 10
M1 class A
M2 class A
```

### Real-World Examples

#### Reliance Industries Analogy
- Dhirubhai Ambani founded Reliance Industries.
- Mukesh Ambani (son) extended the business from oil to telecom (Jio), retail (JioMart), etc.
- Inheritance equivalent: Mukesh inherits and extends Dhirubhai's business.
- Lesson: Child (subclass) extends parent's legacy while reusing resources.

#### Extension Box and Switchboard
- Switchboard: Source of power (superclass).
- Extension Box: Extends reach to other rooms (subclass).
- Reusability: Uses power but extends functionality by adding personal features.

Diagram (Mermaid):
```mermaid
graph TD
    A[Switchboard (Superclass)] -->|Inherits and Extends| B[Extension Box (Subclass)]
    B -->|Reuses Power| C[Additional Outlets]
    B -->|Extends Functionality| D[Portable Power to Corners]
```

#### Person and Student Case Study
- **Scenario**: In a college project, create classes for people and students.
- **Analysis**: A student is a specialized person (not just any person is a student).
- **Design Decision**: Use inheritance to extend Person's functionality.
- **Wrong Design**: Putting student-specific fields in Person class mixes concerns.
- **Correct Design**: Student extends Person, inheriting common attributes (name, height, weight) while adding student-specific ones (studentNumber, course, fees).

```java
// Superclass: Person
class Person {
    String name;
    int height;
    int weight;
    void eat() {
        System.out.println("Person can eat");
    }
    void sleep() {
        System.out.println("Person can sleep");
    }
}

// Subclass: Student extends Person
class Student extends Person {
    int studentNumber;
    String course;
    double fees;

    void listen() {
        System.out.println(name + " is listening " + course);
    }
    void read() {
        System.out.println(name + " is reading " + course);
    }
    void write() {
        System.out.println(name + " is writing " + course);
    }

    void display() {
        System.out.println("Name: " + name + ", Height: " + height + 
                           ", Weight: " + weight + ", Student Number: " + 
                           studentNumber + ", Course: " + course + ", Fees: " + fees);
    }
}

// Test class
class CollegeDemo {
    public static void main(String[] args) {
        Student s1 = new Student();
        // Initialize inherited properties
        s1.name = "John";
        s1.height = 170;
        s1.weight = 65;

        // Initialize student-specific properties
        s1.studentNumber = 101;
        s1.course = "Core Java";
        s1.fees = 2500.0;

        // Display all (inherited and own)
        s1.display();

        // Use as Person
        Person p = s1;
        p.eat(); // Inherited behavior

        // Cannot use Person as Student
        // Student s2 = (Student) new Person(); // Runtime error: ClassCastException
    }
}
```

Output:
```
Name: John, Height: 170, Weight: 65, Student Number: 101, Course: Core Java, Fees: 2500.0
Person can eat
```

### Lab Demo
Follow these steps to implement the Person-Student inheritance example:

1. Create a new Java project in Eclipse (or any IDE).
2. Create three classes: `Person.java`, `Student.java`, and `CollegeDemo.java`.

3. In `Person.java`:
   - Add fields: `String name; int height; int weight;`
   - Add methods: `eat()` and `sleep()` as shown in the code block above.

4. In `Student.java`:
   - Extend Person: `class Student extends Person`
   - Add fields: `int studentNumber; String course; double fees;`
   - Add methods: `listen()`, `read()`, `write()`, and `display()` as shown.

5. In `CollegeDemo.java`:
   - Create a main method.
   - Instantiate Student and initialize all properties.
   - Demonstrate accessing inherited and own members.
   - Show casting attempts (e.g., Uncomment the error line to see compilation/class cast error).

6. Run the program:
   - Compile: No errors if correctly implemented.
   - Execute: Displays combined properties and behaviors.

7. Experiment:
   - Try accessing `Student`'specific methods via `Person` reference (will fail).
   - Add static members to Person and access from Student.

### Types of Inheritance
⚠ Note: Basic inheritance (single inheritance) covered today. Types like multiple inheritance discussed tomorrow.

## Summary

### Key Takeaways
```diff
+ Inheritance creates a parent-child (is-a) relationship for extending functionality.
+ Subclass inherits type, allowing storage in superclass variables (e.g., Student in Person variable).
- Common myth: Inheritance is only for reusability; primary goal is extension while reusing.
+ Advantages: Type relation enables polymorphic code; reusability of members.
- Avoid: Using inheritance solely for code reuse when composition (has-a) suffices.
+ Real-world: Like children extending family legacy while inheriting traits.
! Inheritance is meant for extending and reusing in a loosely coupled, runtime polymorphic way.
```

### Expert Insight

#### Real-World Application
In enterprise software, inheritance is used for framework design, like database entity hierarchies in JPA (e.g., Employee extends Person for adding department/role). It enables scalable architectures, such as event-driven systems where base listeners are extended for specific events, ensuring type safety and polymorphic handling in microservices.

#### Expert Path
Master inheritance by focusing on depth over breadth: Start with single inheritance, then explore polymorphism and abstract classes. Practice design patterns (e.g., Factory, Template Method) that rely on inheritance. Progress to advanced topics like covariant return types and generics integration. Build projects simulating real domains (e.g., vehicle hierarchies: Car extends Vehicle). Contribute to open-source projects for hands-on experience.

#### Common Pitfalls
- **Overusing Inheritance for Reuse**: Leads to brittle code. Prefer composition when no "is-a" relation exists.
- **Deep Hierarchies**: Avoid too many levels (fragile base class problem); refactor to interfaces or mixins.
- **Confusing Types**: Runtime errors from invalid casts (e.g., Person to Student). Use instanceof or generics to avoid.
- **Lacking Encapsulation**: Inherited mutable state can cause issues; combine with encapsulation rules.
**Resolutions**: Design with "is-a" checks; use abstract classes for contracts; test polymorphic behavior thoroughly. Lesser-known fact: Java supports single inheritance for classes but multiple via interfaces, combining best of both worlds for flexible hierarchies.

Mistakes in transcript:
- "INCIP SULE" → Correction: capsule in context of encapsulation, but it's "Capsule" not needed in inheritance.
- Typo: "huh" appears as filler, remove in summary.
- Spelling: "bin" in transcript seems like "in", corrected to "in".
