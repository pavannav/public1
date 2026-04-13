# Session 121: OOP Principles 17

- **[Non-Static Members Execution Flow with Inheritance and Overriding](#non-static-members-execution-flow-with-inheritance-and-overriding)**
- **[Static Members Execution Flow with Inheritance](#static-members-execution-flow-with-inheritance)**
- **[Combining Variable Hiding and Method Overriding](#combining-variable-hiding-and-method-overriding)**
- **[Static vs Non-Static Method Execution Rules](#static-vs-non-static-method-execution-rules)**
- **[Summary](#summary)**

## Non-Static Members Execution Flow with Inheritance and Overriding

### Overview
This session focuses on understanding the execution flow when creating objects in Java with inheritance and method overriding. When an object is created, Java follows a specific sequence: class loading, variable initialization, constructor execution, and method calls. Non-static methods are resolved based on the object's actual type (dynamic binding), while static methods use compile-time type (static binding). The instructor emphasizes drawing memory diagrams to visualize object state.

### Key Concepts/Deep Dive
> **Note:** Understanding memory layout is crucial for predicting program behavior. When accessing variables or methods, draw the JVM architecture showing class level (static) and object level (instance) memory.

**Object Creation Sequence (Step-by-Step):**
1. **Class Loading**: Superclass loads first, then subclass.
2. **Static Variable Initialization**: Static variables get default or explicit initialization values.
3. **Non-Static Variable Initialization**: Instance variables initialized with defaults (e.g., 0 for int).
4. **Constructor Execution**: Superclass constructor runs first, then subclass, executing any initialization blocks or assignments.
5. **Method Calls**: Non-static methods resolve to the overridden version in the subclass; static methods to the declared type.

**Variable Access Rules:**
- When reading `obj.x`, always check the object's memory for the variable. Never jump to class declarations prematurely.
- Instance variables belong to objects; static variables to classes.

**Example Program Analysis:**

Consider this class structure:
```java
class A {
    int x = 0;  // Instance variable
    
    A() {
        x = M1();  // Calls M1(), stores result in instance x
    }
    
    int M1() {
        System.out.println("A M1");
        return 50;
    }
}

class B extends A {
    int y = 0;  // Instance variable
    
    B() {
        // Constructor body
    }
    
    int M1() {  // Overrides A.M1()
        System.out.println("B M1");
        return 60;
    }
}
```

Test code:
```java
B b = new B();  // Object creation
System.out.println(b.x);  // Access instance x
System.out.println(b.y);  // Access instance y
```

**Execution Flow:**
```mermaid
flowchart TD
    A[Class Loading: A then B] --> B[Static Variables: None in example]
    B --> C[Instance Variables: A.x = 0, B.y = 0]
    C --> D[Constructor: A() calls x = M1() → B.M1() returns 60 → A.x = 60, B.y = 60 assigned later or via constructor]
    D --> E[Object Reference: b points to B instance]
    E --> F[b.x → Reads A.x (60), b.y → Reads B.y (60)]
```

Step numbers from transcript:
1. `new B()` → Class A loads, Class B loads.
2. Memory for static variables (none here).
3. Memory for instance variables: A.x = 0, B.y = 0.
4. Constructor execution: A() → `x = M1()` → B.M1() (overridden) prints "B M1", returns 60 → A.x = 60, then B.y gets memory.
5. Reference storage: b points to B instance.

Output Explanation:
- First `M1()` call: Prints "B M1", returns 60 to initialize A.x → A.x = 60.
- Second `M1()` call in B.y assignment (if applicable): Another "B M1" print, return 60 to B.y → B.y = 60.
- Result: "B M1" appears twice, b.x = 60, b.y = 60.

Common Mistake Alert:
```diff
- Mistake: Thinking b.x reads from class declaration or "goes to M1 definition" prematurely.
+ Correct: b.x reads pre-initialized instance variable in object memory.
```

## Static Members Execution Flow with Inheritance

### Overview
Static members belong to classes, not objects. Their execution ignores object types and uses reference variable types. The flow differs from non-static: static blocks and variables initialize once per class load, and static methods execute from the declared class type.

### Key Concepts/Deep Dive
**Static Initialization Sequence:**
1. Class loading in inheritance order.
2. Static variable allocation and initialization.
3. Static blocks execution (from super to sub).
4. Runtime static method calls use reference type, not object type.

**Key Difference from Non-Static:**
- **Non-Static**: Method call `subObj.method()` → Executes subclass version (polymorphism).
- **Static**: Method call `subObj.method()` → Executes declared class version (hiding, not overriding).

**Example Comparison:**

Using same A and B classes, with M1 as static in A and B.

Program:
```java
class A {
    static int x = 0;
    
    A() {
        // Constructor
    }
    
    static int M1() {
        System.out.println("A M1");
        return 50;
    }
}

class B extends A {
    static int y = 0;
    
    static int M1() {  // Hides A.M1()
        System.out.println("B M1");
        return 60;
    }
}
```

Test code:
```java
B b = new B();
A a = new A();
System.out.println(b.x);  // Static x from A
System.out.println(a.x);  // Static x from A
```

**Output Reasoning:**
- Static M1 calls resolve to reference type: `b.M1()` → Mistakes often occur by assuming object type resolution.
- No inheritance in static calls; hiding applies, not overidding.

Table: Static vs Non-Static Behavior

| Aspect          | Static Members                          | Non-Static Members                     |
|-----------------|-----------------------------------------|---------------------------------------|
| Execution From | Reference variable's class             | Object's actual class                |
| Binding        | Compile-time (static)                  | Runtime (dynamic)                   |
| Initialization | Class load time, once per class        | Object creation time, per instance  |
| Example        | `subRef.staticMethod()` → Super class   | `subRef.instanceMethod()` → Subclass|

No code syntax highlighting needed beyond standard Java blocks shown.

## Combining Variable Hiding and Method Overriding

### Overview
Variable hiding occurs when subclass declares a variable with the same name as superclass. Methods can override (instance methods) or hide (static methods). The session combines these with execution flow, requiring careful tracking of memory locations.

### Key Concepts/Deep Dive
**Variable Hiding:**
- Subclass variables hide superclass ones but are distinct.
- Access via `super.x` or reference casting.

**Combined Example:**

```java
class A {
    int x = 10;
    
    int M1() {
        System.out.println("A M1");
        return 50;
    }
}

class B extends A {
    int x = 20;  // Hides A.x
    int y;
    
    B() {
        y = M1();  // Calls overridden M1?
    }
    
    int M1() {
        System.out.println("B M1");
        return 60;
    }
}
```

Test:
```java
B b = new B();
A a = new A();
System.out.println(b.x);  // B.x (20)
System.out.println(a.x);  // A.x (10)
```

**Execution Notes:**
- Object creation triggers constructor chain.
- Variable assignments happen post-constructor.
- Memory: Separate slots for A.x and B.x in the same object.

Alert for Complex Coupling:
> **Important:** When constructors call methods, they use the subclass version if overridden, but variables are from the current class scope. Drawing diagrams prevents confusion.

No lab demos explicitly, but step-by-step analysis serves as practical exercise.

## Static vs Non-Static Method Execution Rules

### Overview
Lecturer differentiates method binding: static ignores object state and uses reference type; non-static depends on object type via polymorphism.

### Key Concepts/Deep Dive
**Fundamental Rules:**
- **Non-Static Methods**: Called on object reference → Execute from object's class (e.g., `subObj.method()` → Subclass if overridden).
- **Static Methods**: Called via reference → Execute from reference's declared class (e.g., `subObj.method()` → Declared class, ignoring object type).
- **This/Super Keywords**: `this` refers to current instance; `super` to superclass (effective for instance access).

**When to Use:**
- Static for class-level utilities.
- Non-Static for object-specific behavior.

Diff Emphasis:
```diff
+ Key: Static calls are "from reference class," non-static "from object class."
- Common Pitfall: Treating static methods like polymorphic ones leads to errors.
```

No diagrams needed here; concepts are verbal with examples.

## Summary

### Key Takeaways
```diff
+ Master non-static execution: Object creation (class load → vars init → constructors → assigns) with overriding resolution.
+ Static execution: Class-scoped, no polymorphism—reference type dictates behavior.
- Avoid reading undeclared variables; always draw memory diagrams (classes at top, objects below).
+ Variable hiding: Subclass vars mask super vars but coexist in object memory.
- Common error: Confusing static/non-static binding leads to reverse execution expectations.
! Practice flow diagrams: Essential for exams; visualize JVM architecture.
+ Overriding: Instance methods use runtime type; hiding for static methods/use declarations.
- Pitfall: Skipping constructor chains or ignoring initialization sequences causes output surprises.
```

### Expert Insight

**Real-world Application**:  
In enterprise Java apps (e.g., Spring Boot), understanding static vs instance execution prevents bugs in singleton patterns, DAO factories, or mock injection. Variable hiding helps with layered configs, ensuring correct data isolation in multi-tier systems.

**Expert Path**:  
- Study JVM spec on class loading phases.  
- Experiment with `@Override` annotations to catch hiding mistakes.  
- Explore bytecode via `javap` to see static bindings.  
Master these by rewriting session examples, then Java wrappers for OOP transitions.

**Common Pitfalls**:  
- Accessing variables before object memory exists (e.g., `b.x` before `new B()`).  
- Assuming all methods "override"—static ones hide.  
- Ignoring superclass constructor runs, causing field overwrites.  
Common issues: Constructor exceptions if overridden methods fail; fix by defensive super calls.

**Lesser Known Things**:  
- Static blocks run once, even in inheritance, regardless of object count.  
- Variable hiding doesn't apply to methods—separate concepts.  
- Anonymous inner classes can complicate bindings; rarely taught.  

Model ID: CL-KK-Terminal

Corrections Made in Study Guide:  
- "overring" corrected to "overriding".  
- "meod" corrected to "method".  
- "non-staic" corrected to "non-static".  
- "hiding me hiding me overriding me overloading" corrected to "hiding, method hiding, method overriding, overloading".  
- No instances of "htp" or "cubectl" found; transcript appears typo-free for common errors.  

End of Study Guide.
