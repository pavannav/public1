# Session 92: OOP Principles 4

## Table of Contents
- [OOP Principles 4](#oop-principles-4)
  - [Overview](#overview)
  - [Key Concepts](#key-concepts)
    - [Types of Classes in Inheritance](#types-of-classes-in-inheritance)
    - [Purpose of Inheritance Programming](#purpose-of-inheritance-programming)
    - [Extends vs. Implements Keywords](#extends-vs-implements-keywords)
    - [Deriving Classes and Interfaces](#deriving-classes-and-interfaces)
    - [IS-A and HAS-A Relationships](#is-a-and-has-a-relationships)
    - [Subclass Obtaining Superclass Type](#subclass-obtaining-superclass-type)
    - [Subclass Obtaining Properties and Behaviors](#subclass-obtaining-properties-and-behaviors)
    - [Member Visibility and Access](#member-visibility-and-access)
  - [Summary](#summary)
    - [Key Takeaways](#key-takeaways)
    - [Real-world Application](#real-world-application)
    - [Expert Path](#expert-path)
    - [Common Pitfalls](#common-pitfalls)

## OOP Principles 4

### Overview

This session delves into the fourth part of Object-Oriented Programming (OOP) principles, focusing on inheritance in Java. Inheritance is a fundamental OOP concept that enables code reusability and establishes a hierarchy between classes. It allows a subclass to inherit attributes and methods from a superclass, while also supporting polymorphism and dynamic binding. The discussion covers the different types of classes involved, the mechanics of extending and implementing inheritance, member visibility, and practical examples to illustrate IS-A and HAS-A relationships. Mastery of these concepts is essential for building flexible, maintainable software systems that promote loose coupling and parallel development.

### Key Concepts

#### Types of Classes in Inheritance

In inheritance programming, three primary types of classes are developed:

- **Superclass (Parent Class/Class)**: This is the base class that contains common attributes (variables) and methods shared by its subclasses. It serves as the blueprint for generalized functionality. For example, a `Person` class could act as a superclass with common properties like `name` and methods like `displayInfo()`.
  
- **Subclass (Child Class/Derived Class)**: This extends or inherits from the superclass, adding specific attributes and methods. It represents specialized functionality. For instance, a `Student` class could be a subclass of `Person`, adding fields like `studentId` and methods like `study()`.

- **User Class**: This class interacts with the objects of the superclass and subclasses. It creates instances and invokes methods to achieve loose coupling through a superclass reference variable storing a subclass object. It avoids tight coupling by not directly instantiating subclasses like `new Student()`; instead, it uses polymorphism, such as `Person p = new Student()`.

Example code illustrating these types:

```java
// Superclass
class Person {
    String name = "John";
    void displayInfo() {
        System.out.println("Name: " + name);
    }
}

// Subclass
class Student extends Person {
    String studentId = "S123";
    void study() {
        System.out.println("Studying...");
    }
}

// User Class
public class User {
    public static void main(String[] args) {
        Person p = new Student();  // Loose coupling
        p.displayInfo();  // Accesses superclass method
    }
}
```

#### Purpose of Inheritance Programming

Inheritance serves multiple purposes:

- **Achieving Loose Coupling and Runtime Polymorphism**: By using a superclass reference to store subclass objects, the code becomes flexible. This allows runtime binding where method calls are resolved dynamically based on the actual object type (e.g., `Person p = new Student()` enables polymorphism).

- **Referring to Generalized Code**: In the superclass, developers write code applicable to all subclasses (generalized). In subclasses, code is specific (specialized). User classes use generalized code for flexibility, such as JDBC where `Connection c = DriverManager.getConnection()` works with any database implementation.

- **Enabling Parallel Development and Dynamic Binding**: Superclasses can be developed by one team (e.g., interfaces), subclasses by another, and user classes by integration teams. This supports parallel work and allows applications to switch between implementations (e.g., database drivers) without code changes.

Real-world analogy: In a hotel, the hotel accepts various persons (user class), but the person types (student, employee) inherit common traits from "Person." The user class focuses on generic interactions (e.g., providing food), not specifics.

Parallel development is critical in enterprise environments, where teams work independently on different parts of the inheritance hierarchy.

#### Extends vs. Implements Keywords

The `extends` and `implements` keywords govern inheritance in Java, differing in their purpose, rules, and applications. They determine how classes derive from other classes or interfaces.

| Feature          | `extends` (Class-to-Class or Abstract-Class Conversion) | `implements` (Interface Implementation) |
|------------------|-----------------------------------------------------------|------------------------------------------|
| **Usage**        | Derives a new class or interface from an existing one. | Derives a class from an interface, forcing method implementation. |
| **Rule**         | Provides reusability; no forced method overrides. | Provides force-ability; methods must be overridden. |
| **Keywords Position** | Class left of `extends` is subclass; right is superclass. | Interface left of `implements` is superclass; right is class. |
| **Accessibility** | Default handling; method redefinition optional. | `public` mandatory for overridden methods; compile-time error if omitted. |
| **Examples** | `class B extends A {}` - Inherits `A`'s methods. | `class C implements I { public void method() {} }` - Implements interface method. |
| **Inaccessibility** | Cannot extend `final` classes (compilation error). | Must implement all abstract methods in interfaces (errors otherwise). |
| **Multi-Association** | Supports single inheritance; cannot extend multiple classes. | Supports multiple interface implementation (e.g., `implements I1, I2`). |

Key differences explained:
- `extends`: Used for derivation providing existing functionality (e.g., `class Dog extends Animal`). It inherits concrete methods; overriding is elective. Suitable for concrete classes or abstract classes to their concrete subclasses.
- `implements`: Required for implementing interface contracts (e.g., `class MyClass implements Runnable`). Forces implementation of abstract methods; compile errors occur if omitted. Public access modifier is required for implementations.
- Syntax and validation: Invalid combinations (e.g., `interface I extends class A`) cause compiler errors. Tables and program validations confirm rules, ensuring correct mapping of superclass and subclass roles.

Derived class or interface rules:
- From a **class**/abstract class: Use `extends`; limited to subclasses only (no interface derivation).
- From an **interface**: Use `implements` for classes or `extends` for interfaces (e.g., `interface I2 extends I1`).
- From a **final class**: Impossible; `extends` fails at compile-time.
- Combining: Classes can inherit one concrete/abstract class and multiple interfaces (e.g., `class B extends A implements I1, I2`), prioritizing `extends` then `implements`.

```java
// Examples Demonstrating Extends and Implements

// Extends Example
class Animal {
    void eat() { System.out.println("Eating..."); }
}
class Dog extends Animal {
    void bark() { System.out.println("Barking..."); }
}

// Implements Example
interface Runnable {
    void run();
}
class RaceCar implements Runnable {
    public void run() { System.out.println("Racing..."); }
}

// User Class Demonstrating Usage
public class Example {
    public static void main(String[] args) {
        Animal a = new Dog();  // Extends: Reusable
        a.eat();
        
        Runnable r = new RaceCar();  // Implements: Forced implementation
        r.run();
        
        // Invalid: Cannot extend final class or implement classes
        // final class FinalClass {}
        // class Invalid extends FinalClass, Animal {}  // Error: Multiple inheritance invalid
        // class InvalidToo extends Animal implements ...
    }
}
```

Tables summarize permissible and forbidden derivations, with compilation outcomes (`true`/`error`).

| Derivation Scenario          | Possible? | Outcome/Reason |
|------------------------------|-----------|----------------|
| Class from Class            | ✅        | Use `extends` |
| Class from Interface        | ✅        | Use `implements` |
| Interface from Interface    | ✅        | Use `extends` |
| Class from Final Class      | ❌        | Compilation error |
| Interface from Class        | ❌        | Not allowed |
| Multiple Class Inheritance  | ❌        | Java restriction |

#### IS-A and HAS-A Relationships

Inheritance emphasizes two reusability models: **IS-A** (is-a) and **HAS-A** (has-a), differentiating component reuse strategies.

- **IS-A Relationship (Inheritance/Extends)**: Signifies a "is a" link, where a subclass inherits superclass traits (e.g., `Dog IS-A Animal`). Use `extends` for hierarchical extension, promoting code sharing without duplication. This enables specialized subclass logic while accessing generalized superclass functionality.

- **HAS-A Relationship (Composition)**: Represents "has a" containment, where one class holds another as an attribute (e.g., `Car HAS-A Engine`). Instantiate and manage objects via reference variables, avoiding inheritance to prevent tight coupling. Promote modularity and flexibility.

**Comparison Table:**

| Aspect          | IS-A (Inheritance) | HAS-A (Composition) |
|-----------------|-------------------|---------------------|
| **Purpose**    | Share code through hierarchy | Reuse components via ownership |
| **Keyword**    | `extends` | Association via reference |
| **Example**    | `class Dog extends Animal` | `class Car { Engine e; }` |
| **Coupling**   | Tighter (inherited dependencies) | Looser (configurable) |
| **Flexibility**| Limited to subclass scope | High; components swappable |

Code examples:

```java
// IS-A Example
class Animal {
    void breathe() { System.out.println("Breathing..."); }
}
class Dog extends Animal {  // Dog IS-A Animal
    void bark() { System.out.println("Woof!"); }
}
class ExampleISA {
    public static void main(String[] args) {
        Dog d = new Dog();
        d.breathe();  // Inherited behavior
        d.bark();     // Specialized behavior
    }
}

// HAS-A Example
class Engine {
    void start() { System.out.println("Engine starting..."); }
}
class Car {  // Car HAS-A Engine
    Engine engine = new Engine();  // Composition
    void drive() {
        engine.start();
        System.out.println("Driving...");
    }
}
class ExampleHASA {
    public static void main(String[] args) {
        Car c = new Car();
        c.drive();  // Accessing via composition
    }
}
```

> **Note**: Prefer composition (HAS-A) for modularity; use inheritance (IS-A) judiciously to avoid over-generalization.

#### Subclass Obtaining Superclass Type

A subclass inherits the "type" of its superclass, allowing polymorphic usage. This means a subclass object can be treated as an instance of the superclass type, enabling substitution in places expecting the superclass.

- **Definition**: Interchangeability allows subclasses to replace superclasses without altering code. For example, `Animal a = new Dog()` treats `Dog` as `Animal`, supporting runtime polymorphism.
- **Rule**: Inheritance relation required for type legality (e.g., `SuperClass var = new SubClass()` compiles only if subclass `extends` superclass).
- **Testing Program**:

```java
class Animal {
    void makeSound() { System.out.println("Generic sound"); }
}
class Dog extends Animal {
    void makeSound() { System.out.println("Bark"); }
}
public class TypeInheritance {
    public static void main(String[] args) {
        Animal a = new Dog();  // Legal: IS-A relation
        a.makeSound();  // Calls Dog's version (polymorphism)
    }
}
```

> **Important**: Without inheritance (`class Dog {}`), `Animal a = new Dog()` fails compilation due to type mismatch.

#### Subclass Obtaining Properties and Behaviors

Subclasses access superclass members through inheritance, though not by copying variables/methods. Instead, subclasses gain permission to use superclass attributes (properties) and methods (behaviors) as if local, while enforcing visibility rules.

- **Properties (Variables/Fields)**: Inherited accessibility depends on modifiers (private/indirectly via getters/setters).
- **Behaviors (Methods)**: Non-private methods callable via subclass objects or names, with overriding support.
- **Access Rules**: Private members inaccessible directly; defaults/protected/public based on package and class relationships.
- **Example Program**:

```java
class A {
    public int publicVar = 1;
    protected int protectedVar = 2;
    private int privateVar = 3;  // Not directly accessible
    public void publicMethod() { System.out.println("Public method"); }
    protected void protectedMethod() { System.out.println("Protected method"); }
    private void privateMethod() { System.out.println("Private"); }
}
class B extends A {
    public void accessSuper() {
        System.out.println(publicVar);   // Accessible
        System.out.println(protectedVar); // Accessible (same package or subclass)
        // privateVar not accessible directly
        publicMethod();
        protectedMethod();
        // privateMethod not accessible
    }
}
public class PropertyBehavior {
    public static void main(String[] args) {
        B b = new B();
        b.accessSuper();  // Demonstrates access
        // Compile error: b.privateMethod();
    }
}
```

💡 **Tip**: Use getters/setters for private inherited fields; avoid direct access for encapsulation.

#### Member Visibility and Access

Inheritance respects accessibility modifiers, limiting subclass access to superclass members. Not all superclass elements are inherited; only "visible" (non-private) members are accessible.

- **Private Members**: Inaccessible to subclasses; memory allocated but access via public APIs (e.g., setters/getters).

> **Alert**: Private fields remain hidden; subclasses interact through exposed methods only.

- **Visibility Hierarchy** (Most Accessible to Least):

| Modifier   | Same Class | Same Package (Subclasses) | Different Package (Subclasses) | APIs/External |
|------------|------------|---------------------------|--------------------------------|--------------|
| **Public** | ✅        | ✅                       | ✅                            | ✅           |
| **Protected**| ✅       | ✅                       | ✅ (post-super call)          | ❌           |
| **Default** | ✅       | ✅                       | ❌                            | ❌           |
| **Private**| ✅       | ❌                       | ❌                            | ❌           |

- **Program Illustration**:

```java
class A {
    private int priv = 1;      // Subclass can't access
    int def = 2;              // Accessible in same package
    protected int prot = 3;    // Accessible in subclasses
    public int pub = 4;       // Fully accessible
}
class B extends A {
    void testAccess() {
        // System.out.println(priv); // Error
        System.out.println(def);   // OK if same package
        System.out.println(prot);  // OK
        System.out.println(pub);  // OK
    }
}
public class Visibility {
    public static void main(String[] args) {
        B b = new B();
        b.testAccess();
    }
}
```

### Summary

#### Key Takeaways

```diff
+ Inheritance enables code reusability through superclass-subclass hierarchies, promoting generalized development for loose coupling and polymorphism.
+ Three class types: Superclass (common features), Subclass (specializations), User class (interaction via polymorphism).
+ Extends vs. Implements: Extends provides optional reusability from classes implementar force-ability from interfaces.
+ IS-A (inheritance via extends) vs. HAS-A (composition) for different reuse models; favor composition for modularity.
+ Subclasses obtain superclass type for polymorphic substitution, properties/behaviors via visibility rules, and access non-private members.
+ Visibility: Private members hidden; public/protected accessible; default valid within packages; enforce encapsulation with accessors.
+ Parallel development: Teams build superclasses, subclasses, user classes independently for dynamic binding.
- Avoid forcing private member access; use proper modifiers to maintain encapsulation.
! Critical: Compile-time errors arise from invalid derivations (e.g., final classes, multiple extends); test inheritance hierarchies rigorously.
! Polymorphism via superclass references enables runtime flexibility, key for JDBC-like abstractions.
```

#### Real-world Application

Inheritance is pivotal in software design for creating extensible frameworks. Consider JDBC, where interfaces like `Connection` act as superclasses, implemented by drivers for databases like MySQL or PostgreSQL. User applications remain database-agnostic, promoting seamless switching (e.g., from Oracle to MySQL without code changes). MVC architectures rely on inheritance for controllers extending base behaviors, ensuring parallel development in enterprise teams. Web frameworks (e.g., Spring) use inheritance for beans, enabling hot-swappable services at runtime.

> **Note**: In distributed systems, inheritance supports plugin architectures, where subclasses load dynamically for extensibility.

#### Expert Path

To mastery, prioritize hands-on practice: Implement inheritance hierarchies in projects (e.g., an animal kingdom simulator with polymorphic interactions). Study advanced topics like abstract factories for decoupling, and explore multi-threaded scenarios where inheritance aids in sharing state. Contribute to open-source libraries to observe real-world inheritance patterns. Certifications like Java SE highlight inheritance in exams—master visibility and polymorphism through debugging exercises.

#### Common Pitfalls

1. **Misusing Private Members**: Attempting direct access to private superclass fields in subclasses causes compilation errors. Resolution: Use public getters/setters to encapsulate; test inheritance views separately. Avoiding this ensures modularity without breaking encapsulation.

2. **Invalid Derivations**: Trying to extend final classes or derive interfaces from classes leads to syntax errors. Resolution: Verify class types (concrete/abstract/final) and use correct keywords (extends for classes, implements for interfaces); reference Java documentation for permitted hierarchies. Common misspellings in code (e.g., "cast" for "class") can mimic these errors—always compile incrementally.

3. **Tight Coupling in User Classes**: Directly instantiating subclasses (e.g., `new Student()`) creates rigidity, hindering polymorphism. Resolution: Adopt superclass references (e.g., `Person p = new Student()`) for loose coupling; simulate runtime scenarios with mocks. This prevents issues in dynamic environments like JDBC, where bindings change unexpectedly.

4. **Overriding Method Visibility**: Reducing visibility (e.g., making a public method protected) throws errors. Resolution: Maintain or increase visibility; declare intended scope with care.

5. **Memory Misunderstandings for Private Fields**: Assuming private members aren't allocated in subclass objects. Resolution: They are, but inaccessible directly—rely on inheritance runtime details from JVM documentation.

6. **Lesser-Known Details**: Inheritance doesn't copy members; it's a reference mechanism. In bytecode, `super` calls initialize hierarchies; mismatches cause stack inconsistencies. Avoid cross-package defaults for predictable behavior.
