# Session 129: OOP Principles and LCRP Architecture

## Table of Contents
- [Overview](#overview)
- [Programming Elements in OOP](#programming-elements-in-oop)
- [Cohesion](#cohesion)
- [Coupling](#coupling)
- [Achieving Dynamic and Scalable Applications](#achieving-dynamic-and-scalable-applications)
- [Abstraction and Interface-Based Programming](#abstraction-and-interface-based-programming)
- [LCRP Architecture](#lcrp-architecture)
- [Reflection API for Runtime Polymorphism](#reflection-api-for-runtime-polymorphism)
- [Examples and Visualizations](#examples-and-visualizations)

## Overview
This session covers advanced Object-Oriented Programming (OOP) principles, focusing on cohesion, coupling, and the LCRP (Loose Coupling Runtime Polymorphism) architecture. The lecture emphasizes developing high-cohesion, loosely-coupled, runtime-polymorphic applications to achieve dynamic, scalable, and secure software. It explains how to design applications that can evolve easily by using interfaces for abstraction and reflection APIs for dynamic object loading.

## Programming Elements in OOP

### Key Concepts/Deep Dive
Object-Oriented Programming (OOP) is a programming style for automating business applications by creating real-world objects in code, providing data security, and enabling dynamic binding. It builds on programming elements such as classes (interface, abstract class, concrete class, final class), objects (instances), variables (primitive and reference, static/non-static, local, parameters), blocks (static, instance, local), constructors (default/no-param, param), methods (abstract/concrete, static/non-static), and inner classes/packages.

**What OOP Accomplishes:**
- Creates real-world objects using class and object.
- Provides security via encapsulation (hiding data from direct access).
- Enables dynamic binding through inheritance (creating subtypes), polymorphism (runtime execution from subtypes), and abstraction (forcing subtype implementations).

**Advantages over Structured Programming:**
- Modularity and clean separation of object operations.
- Security for object data and dynamic connectivity.

**Programming Elements Breakdown:**
- **Classes:** Interface (forces subtype implementations), abstract class (partial implementation), concrete class (full implementation), final class (stops further subclasses).
- **Variables:** Static (common to all objects, initialized via static blocks), instance (specific to objects), local (for method results), parameters (receive inputs).
- **Blocks:** Static initializer (class loading logic), instance initializer (object creation logic), local block (reduces variable scope).
- **Constructors:** No-param or param, can be default or programmer-defined.
- **Methods:** Abstract (declare operations for subtypes), concrete (implement logic; static/non-static, private/non-private, synchronized/non-synchronized, final/non-final).
- **Inner Classes:** Regular, local, anonymous (not explained yet).
- **Packages:** Parent and sub packages.

> [!NOTE]  
> **Mistakes Noted:** The transcript has "whoops" for "OOP" and repetitions like "tell me" which were corrected for clarity. No major spelling errors like "htp" or "cubectl" in this segment.

## Cohesion

### Key Concepts/Deep Dive
Cohesion refers to the process of creating one object's properties and behaviors in a single class, clearly separated from others, for modularity and readability.

**Types of Cohesion:**

| Cohesion Type | Description | Example |
|---------------|-------------|---------|
| High Cohesion | All properties and methods of an object are in its own class; no distribution to other classes. | Student class contains all student-related fields and methods (e.g., student name, course, marks, findTotal). |
| Low Cohesion | One object's fields or methods are distributed across multiple classes. | FindTotal method in Student class but marks variable in College class – bad design. |

**Importance:** Develop high-cohesion classes for easy maintenance and scalability. Avoid low cohesion to prevent confusion about object ownership.

### Code/Config Blocks
```java
// Example of High Cohesion: All Student properties in Student class
class Student {
    private String name; // Instance variable
    private int[] marks; // Instance variable

    public int findTotal(int[] marks) { // Instance method
        int total = 0;
        for (int mark : marks) total += mark;
        return total; // Returns result
    }
}
```

## Coupling

### Key Concepts/Deep Dive
Coupling is the dependency between objects when accessing each other's operations. It determines how easily objects can interact without tight bindings.

**Types of Coupling:**

| Coupling Type | Description | Example |
|---------------|-------------|---------|
| Tight Coupling | High dependency; changing one object requires modifying and recompiling another. | Using child class (e.g., `CdmaMobile`) references directly – can't switch to another subtype without code changes. |
| Loose Coupling | Low dependency; objects can be changed without recompiling user classes. | Using super class (e.g., `Mobile`) references – easy to switch subtypes via method parameters or runtime input. |

**Why Loose Coupling?** Enables passing any subtype object dynamically, preventing code modifications for changes.

### Examples and Visualizations
```mermaid
graph LR
A[User Class: Mobile] --> B[Subtypes: AEL, BSNL, VI, GOO]
A -- Calls Methods --> B
```
! User Class (Mobile) uses super reference to access any subtype without recompiling.

## Achieving Dynamic and Scalable Applications

### Key Concepts/Deep Dive
Dynamic and scalable applications adapt to changes without recompilation, achieved through high cohesion, strong encapsulation, loose coupling, and runtime polymorphism.

**Target Application Types:**
- **Strongly Encapsulated:** Hide data using private fields and public methods.
- **High Cohesion:** Separate object responsibilities.
- **Loosely Coupled:** Use super class references.
- **Runtime Polymorphic:** Methods execute from actual subtype objects.

These properties ensure security, modularity, and flexibility for business-critical apps.

**Flow:**
Linear: Object Design (Cohesion) → Encapsulation → Coupling → Polymorphism → Dynamic Binding.

## Abstraction and Interface-Based Programming

### Key Concepts/Deep Dive
Abstraction forces subtype implementations using interfaces or abstract classes. Interfaces support multiple inheritance, making them ideal for loose coupling.

**Why Interfaces?**
- Declare operations in a super class (e.g., `Sim` with `call()` and `sms()`).
- Subtypes (e.g., `AEL`, `BSNL`) implement operations separately.
- User classes (e.g., `Mobile`) use super references, achieving high cohesion, loose coupling, and runtime polymorphism.

**Compared to Abstract Classes:**
| Feature | Interface | Abstract Class |
|---------|-----------|----------------|
| Inheritance | Multiple allowed | Single only |
| Implementation | None (abstract) | Partial/Full |
| Use Case | Common for loose coupling | Partial abstractions |

> [!IMPORTANT]  
> Abstraction ensures subtypes are separated and user operations access them dynamically.

## LCRP Architecture

### Key Concepts/Deep Dive
LCRP (Loose Coupling Runtime Polymorphism) architecture integrates all OOP concepts into one diagram:
- **Super Class (Interface):** Contains operation declarations.
- **Sub Classes:** Contain implementations (overriding).
- **User Classes:** Invoke methods using super references with subtype objects.

**Benefits:** Automatic achievement of cohesion, loose coupling, polymorphism, and encapsulation.

```mermaid
graph TD
    Super[Intf: Operations Decl]=Super --> Sub[SubClasses: Implements]
    User[User Class: Ref to Super]=User --> Sub
    User --> Runtime[Runtime: SubType Obj Executes]
```

### Lab Demos
**Demo 1: Sim Interface and Mobile User**
1. Create `interface Sim { void call(); void sms(); }`.
2. Implement in `class AEL implements Sim { public void call() { System.out.println("AEL calling"); } public void sms() { System.out.println("AEL SMS"); } }`.
3. In user class `Mobile`: `void insertSim(Sim sim) { sim.call(); sim.sms(); }`.
4. Call: `Mobile m = new Mobile(); m.insertSim(new AEL());` – Executes from AEL (runtime poly).
5. To make fully dynamic, replace `new AEL()` with runtime-loaded objects via Reflection.

! This runs with any subtype without code changes.

## Reflection API for Runtime Polymorphism

### Key Concepts/Deep Dive
To achieve 100% loose coupling and runtime polymorphism, use Reflection API for dynamic class loading and instantiation at runtime.

**Components:**
- **Scanner:** Reads subclass name as string from keyboard/files.
- **Reflection API:** Converts string to Class, creates objects.

**Key Classes:**
- `Class.forName(className)` – Loads class dynamically.
- Instantiate via `Class.newInstance()` or constructors.

**Example Process:**
1. Read "AEL" as string.
2. `Class cls = Class.forName("AEL");`
3. `Object obj = cls.newInstance();`
4. Cast to interface: `Sim sim = (Sim) obj;`

### Code/Config Blocks
```java
import java.lang.reflect.*;
import java.util.Scanner;

public class Mobile {
    Sim sim; // Loose coupling: Super reference

    // Example: Dynamic loading
    public static void main(String[] args) throws Exception {
        Scanner sc = new Scanner(System.in);
        System.out.println("Enter SIM class name:");
        String className = sc.next();

        // Reflection: Load and instantiate
        Class cls = Class.forName(className);
        Sim sim = (Sim) cls.newInstance();

        Mobile m = new Mobile();
        m.insertSim(sim); // Calls subtype methods
    }

    void insertSim(Sim sim) {
        sim.call();
        sim.sms();
    }
}
```

### Lab Demos
**Demo 2: Dynamic SIM Loading**
1. Prompt user for SIM class name (e.g., "AEL").
2. Use `Scanner` to read input.
3. Use `Class.forName()` and `newInstance()` to create object.
4. Pass to `insertSim(Sim sim)`.
5. Method executes from entered subtype (e.g., AEL calls and SMS).

! Demonstrates runtime polymorphism beyond static coding.

## Examples and Visualizations
- **Cohesion Example:** Student properties in one class vs. distributed (low cohesion).
- **Coupling Example:** Mobile-Sim – Tight (direct subtype) vs. Loose (interface ref).
- **LCRP Flow:** Interface → Implementations → User invokes with subtype objects.

## Summary

### Key Takeaways
```diff
+ High cohesion separates object properties clearly.
- Low cohesion distributes properties across classes.
! Loose coupling allows runtime subtype changes.
- Tight coupling requires code recompilation for changes.
+ Interfaces enable runtime polymorphism and multiple inheritance.
- Abstract classes limit inheritance.
+ Reflection API loads classes dynamically for 100% loose coupling.
```

### Expert Insight
**Real-world Application:** In enterprise applications (e.g., banking systems), use LCRP to handle different payment processors (interfaces) via config files, allowing runtime swaps without downtime.

**Expert Path:** Master defining contracts with interfaces, then implement reflection for plugin architectures. Practice designing around abstractions first.

**Common Pitfalls:** Using concrete classes directly leads to tight coupling; avoid distributing object logic across classes for poor cohesion. Issues with reflection include ClassNotFoundException – resolve by ensuring classpath and error handling. Oversights in polymorphic design mean method calls may not execute from intended subtypes if overriding is missed. Performance hits from reflection – use sparingly and cache classes.
