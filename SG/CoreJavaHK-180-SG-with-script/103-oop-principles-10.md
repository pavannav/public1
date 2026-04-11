# Session 103: OOP Principles

## Table of Contents
- [Upcasting and Downcasting Recap](#upcasting-and-downcasting-recap)
- [ClassCastException Overview](#classcastexception-overview)
- [Instanceof Operator](#instanceof-operator)
- [Rules for Using Instanceof Operator](#rules-for-using-instanceof-operator)
- [Upcasting and Downcasting with Parameters](#upcasting-and-downcasting-with-parameters)
- [Lab Demo: Class Hierarchies and Casting](#lab-demo-class-hierarchies-and-casting)
- [Real-World Applications](#real-world-applications)
- [Summary](#summary)

## Upcasting and Downcasting Recap
Upcasting involves storing a subclass object reference in a superclass reference variable. This enables loose coupling and runtime polymorphism. For example:
```java
A a1 = new B(); // Upcasting - B object stored in A reference
```

Downcasting retrieves the subclass object from a superclass reference by casting it back to the subclass type. This allows access to subclass-specific members.
```java
B b1 = (B) a1; // Downcasting - requires instanceof check in practice
```

## ClassCastException Overview
A `ClassCastException` occurs at runtime when attempting to cast an object to an incompatible type. This happens when:
- The object being cast is not an instance of the target class or its subclasses.
- The cast operator `()` is used without verifying compatibility.

For example:
```java
A a1 = new B();
C c1 = (C) a1; // Throws ClassCastException - B is not subclass of C
```

> [!IMPORTANT]
> Always verify object type before casting to prevent runtime exceptions.

## Instanceof Operator
The `instanceof` operator checks if an object is an instance of a specified class or its subclasses. It's a binary operator that returns a boolean value without throwing exceptions.

### Key Characteristics:
- **Type**: Binary operator
- **Syntax**: `object instanceof ClassName`
- **Usage**: Verifies object type before casting
- **Behavior**: Returns `true` if the object is an instance of the class (or subtype), `false` otherwise

Example usage:
```java
if (a1 instanceof C) {
    C c1 = (C) a1;
    // Safe to use c1
}
```

### Comparison with Cast Operator:
| Aspect | Cast Operator `(B) a1` | Instanceof Operator `a1 instanceof B` |
|--------|-----------------------|-------------------------|
| Throws Exception | Yes, if incompatible | No |
| Return Value | Cast object | boolean |
| Purpose | Type conversion | Type checking |

## Rules for Using Instanceof Operator
### Rule 1: Compatibility Check
The reference variable and target class must have an IS-A relationship in at least one direction.
- Compiler checks: `variable instanceof ClassName`
- JVM verifies: Object stored in variable instanceof ClassName

### Rule 2: Syntax Rules
- Left side must be a reference variable or object
- Right side must be a class name (keyword `instanceof`)

### Important Points:
- **Incompatible Types**: Compiler error if no IS-A relationship exists
- **Null Handling**: `null instanceof ClassName` returns `false`
- **Primitive Types**: Cannot use with primitives (compilation error)

### Examples:
```java
// Compatible - A and B have IS-A relationship
A a1 = new B();
boolean result = a1 instanceof B; // true

// Incompatible - Compiler error
A a2 = new A();
boolean result2 = a2 instanceof D; // Error if D unrelated to A

// Object type (universal compatibility)
Object obj = new A();
boolean result3 = obj instanceof String; // false, but compiles
```

## Upcasting and Downcasting with Parameters
Method parameters follow similar casting rules. Upcasting enables loose coupling by accepting superclass types.

```java
class Example {
    void m1(A param) { // Accepts A or its subclasses
        // Can call only A methods directly
    }
    void m2(B param) { // Accepts B or its subclasses
    }
}
```

### Access Subclass Members:
To access subclass-specific members from upcast parameters, use downcasting with `instanceof` checks:
```java
void processObject(A aObj) {
    if (aObj instanceof B) {
        B bObj = (B) aObj;
        bObj.specificMethod(); // Access B-specific methods
    }
}
```

### Possible Arguments for Methods:
- For `void m1(A param)`: A objects, B objects, C objects, or `null`
- For `void m2(B param)`: B objects, C objects, or `null`

## Lab Demo: Class Hierarchies and Casting

### Class Hierarchy Example:
```java
class A { }
class B extends A { }
class C extends B { }
class D extends A { } // D is sibling to B
```

### Testing Casting Scenarios:
1. **Upcasting Examples:**
   ```java
   A a1 = new B(); // ✓ Valid
   A a2 = new C(); // ✓ Valid
   A a3 = new D(); // ✓ Valid
   B b1 = (B) a1; // Downcasting - requires instanceof
   ```

2. **ClassCastException Scenarios:**
   ```java
   A a1 = new B();
   D d1 = (D) a1; // ✗ ClassCastException - B not instance of D
   ```

3. **Safe Casting with Instanceof:**
   ```java
   A a1 = new B();
   if (a1 instanceof C) {
       C c1 = (C) a1;
       // Safe operations with C
   }
   ```

### Method Parameter Example:
```java
class Test {
    void process(A obj) {
        if (obj instanceof B) {
            B bObj = (B) obj;
            // B-specific operations
        } else if (obj instanceof D) {
            D dObj = (D) obj;
            // D-specific operations
        }
    }
}
```

### Importance of Order in Instanceof Checks:
❌ Wrong order (superclass first):
```java
if (obj instanceof A) { // Consumes all subclasse objects
    // Will execute for all A,B,C,D objects
} else if (obj instanceof B) { // Never reached
    // Never executed
}
```

✅ Correct order (subclass first):
```java
if (obj instanceof B) { // Check specific subtypes first
    // B objects
} else if (obj instanceof A) { // Then superclass
    // A objects (not consumed by first check)
}
```

## Real-World Applications
In Java frameworks like collections, objects are stored as `Object` type due to heterogeneity. Retrieving objects requires downcasting with `instanceof` checks to access specific methods.

### Collection Example:
```java
List<Object> collection = new ArrayList<>();
collection.add(new Student()); // Upcasting to Object
collection.add(new Faculty());

// Safe retrieval with instanceof
for (Object obj : collection) {
    if (obj instanceof Student) {
        Student s = (Student) obj;
        s.study(); // Student-specific method
    }
}
```

Without proper casting, attempting to call `study()` directly on `obj` would cause a compilation error.

## Summary

### Key Takeaways
```diff
+ Upcasting enables loose coupling by allowing subclass objects to be stored in superclass references
+ ClassCastException occurs at runtime during invalid downcasting operations
+ Instanceof operator provides safe type checking without throwing exceptions
+ Always check instanceof before downcasting to prevent runtime errors
+ Order matters in multiple instanceof conditions - check subclasses before superclass
+ Method parameters use upcasting for polymorphism but require downcasting for subclass-specific access
```

### Expert Insight

#### Real-world Application
In enterprise Java applications, these principles enable flexible design patterns:
- **Collections API**: All legacy collections store objects as `Object`, requiring careful casting
- **Factory Patterns**: Method parameters accept interfaces/superclasses for polymorphic behavior  
- **Dependency Injection**: Frameworks like Spring use casting for dynamic component wiring
- **ORM Generators**: Hibernate retrieves entities that may need downcasting for specific table operations

#### Expert Path
- Master inheritance hierarchies before attempting complex casting scenarios
- Study Java Collection Framework source code to understand type-safe operations
- Practice with design patterns like Visitor and Factory that rely on these principles
- Learn advanced generics to reduce need for manual casting in modern Java code
- Understand JVM bytecode generation for instanceof operations

#### Common Pitfalls
- **Missing instanceof Checks**: Leads to `ClassCastException` in production systems
- **Wrong Order in Conditions**: Causes instanceof checks to never execute
- **Assuming Object Types**: Treating upcast references as original subtypes without verification
- **Null Pointer Exceptions**: Checking instanceof on potentially null references without null checks first

```diff
- Never cast without instanceof verification in dynamic environments
! Generic collections (> Java 5) significantly reduce manual casting needs
+ Compile-time checking can catch many issues before runtime
```

Lesser-known things: The `instanceof` operator can be optimized by JVM hotspot compiler through escape analysis, and it's more efficient than calling `getClass().equals()` for type checking. In Java 16+, pattern matching with instanceof (preview feature) combines type checking and casting in one expression.
