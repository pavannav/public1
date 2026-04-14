# Session 75: Ref vars, Null and NPE

- [Reference Variables](#reference-variables)
- [Null and Null Pointer Exception](#null-and-null-pointer-exception)
- [Summary](#summary)

## Reference Variables

### Overview
Reference variables are variables that store references to objects or null. They are crucial for managing objects in Java, allowing access to instance methods and variables. Types of reference variables are classified based on declaration (static, non-static, parameter, local) and value assignment (object, null, empty).

### Key Concepts/Deep Dive
Java supports two primary classifications for reference variables:

- **Based on declaration place (4 types)**:
  - Static reference variable: Stored in class memory (method area), common to all objects. Declared with `static` keyword.
  - Non-static (instance) reference variable: Stored separately in each object in heap memory.
  - Parameter reference variable: Receives object arguments in method calls, stored in stack frame.
  - Local reference variable: Created inside methods, stored in stack frame for specific method execution.

- **Based on value assignment (3 types)**:
  - Object reference variable: Initialized with an object reference, pointing to heap memory.
  - Null reference variable: Initialized with `null`, no object reference.
  - Empty reference variable: Declared but not assigned, in local scope only.

Reference variables for user-defined classes behave identically to primitive types like `String` or `int`. Choose between static and instance based on whether data is shared (static) or unique (instance) per object.

### Code/Config Blocks

**Student and Address Class Example:**

```java
class Address {
    int streetNumber = 10;
    String city = "Hyderabad";
}

class Student {
    static Address institute = new Address(); // Static reference - common
    int sNo;
    String sName;
    Address permanentAddress; // Instance reference - per student
    
    void display() {
        System.out.println("Institute: " + institute.streetNumber + ", " + institute.city);
        if (permanentAddress != null) {
            System.out.println("Address: " + permanentAddress.streetNumber + ", " + permanentAddress.city);
        } else {
            System.out.println("Address: null");
        }
        System.out.println("Roll No: " + sNo);
        System.out.println("Name: " + sName);
    }
}

public class Test {
    public static void main(String[] args) {
        Student s1 = new Student();
        Student s2 = new Student();
        
        // Initialize common static reference (optional, defaults to null)
        Student.institute.streetNumber = 1;
        Student.institute.city = "Hyderabad";
        
        // Initialize individual addresses
        s1.permanentAddress = new Address();
        s1.permanentAddress.streetNumber = 2;
        s1.permanentAddress.city = "Delhi";
        
        s2.permanentAddress = s1.permanentAddress; // Same object reference
        
        s1.sNo = 1;
        s1.sName = "John";
        
        s1.display();
        s2.display();
    }
}
```

**Memory Diagram (Mermaid):**

```mermaid
graph TD
    A[Method Area] --> B[Student Class Memory]
    B --> C[static Address institute -> Heap @4040]
    D[Heap Area] --> E[Student s1 Object: sNo=1, sName="John", permanentAddress -> Heap @5200]
    D --> F[Student s2 Object: sNo=0, sName=null, permanentAddress -> Heap @5200]
    D --> G[Address Object @5200: streetNumber=2, city="Delhi"]
    D --> H[Address Object @4040: streetNumber=1, city="Hyderabad"]
```

### Lab Demos

#### Demo 1: Declaration and Initialization
1. Create `Address` class with `streetNumber` (int) and `city` (String) fields.
2. In `Student` class, declare `static Address institute;` and `Address permanentAddress;`.
3. Declare `void display()` method to print static and instance address details with null checks.
4. In `main`, create two `Student` objects `s1` and `s2`.
5. Assign static address: `Student.institute = new Address();` then set properties.
6. Assign instance address for `s1`: `s1.permanentAddress = new Address();` then set properties.
7. Copy `s1`'s address reference to `s2`: `s2.permanentAddress = s1.permanentAddress;`.
8. Set `s1.sNo` and `s1.sName`.
9. Call `s1.display()` and `s2.display()` to verify shared vs. separate object behavior.
   - Expected output: `s1` shows unique address, `s2` shows same address as `s1`.

#### Demo 2: Null Pointer Exception and Handling
1. Create `Student` objects without initializing `permanentAddress`.
2. Attempt to access `permanentAddress.streetNumber` in `display()`.
3. Run program to encounter `NullPointerException` at access line.
4. Add null check: `if (permanentAddress != null)` before accessing properties.
5. Run program again; output should show "Address: null" instead of exception.

**Ternary Operator Alternative Handling:**

```java
System.out.println("Address: " + (permanentAddress != null ? permanentAddress.streetNumber + ", " + permanentAddress.city : "null"));
```

> [!NOTE]
> Static variables are shared across objects; changes affect all. Instance variables create separate copies.

## Null and Null Pointer Exception

### Overview
Null is a special literal representing absence of object reference. Null pointer exception (NPE) occurs when accessing members on a null reference. Understanding null prevents runtime errors in object-oriented programming.

### Key Concepts/Deep Dive

- **What is null**: A literal of any reference type (class, interface, enum, annotation, array). Not a keyword but reserved word.
- **Type of null**: Any reference type, requiring explicit type assignment for use.
- **Assigning type to null**:
  - Via variable assignment: `String s = null;`
  - Via cast operator: `(String) null`
- **Use of null**: Initializes reference variables to satisfy compiler before object assignment.
- **Operations with null**:
  - Direct `System.out.println(null);` → Compile error (ambiguous reference).
  - Null with type: `System.out.println((String) null);` → Prints "null".
  - Accessing members: `null.member` → NPE at runtime.

Null is not an object; it creates "null reference variables" for accessing class members later.

### Code/Config Blocks

**Null Reference Types:**

```java
class Example {
    int x = 10;
    int y = 20;
}

public class Test {
    public static void main(String[] args) {
        Example e1 = new Example(); // Object reference variable
        Example e2 = null; // Null reference variable
        Example e3; // Empty reference variable (local)
        
        System.out.println(e1); // Prints object reference
        System.out.println(e2); // Prints "null"
        // System.out.println(e3); // Compile error: e3 might not be initialized
        
        // Accessing members
        System.out.println(e1.x); // 10
        // System.out.println(e2.x); // NPE: cannot read field x because "e2" is null
        // System.out.println(e3.x); // Compile error
        
        // Displaying via cast
        System.out.println((String) null); // "null"
        System.out.println((int[]) null); // "null"
        
        // Handling NPE
        if (e2 != null) {
            System.out.println(e2.x);
        } else {
            System.out.println("Null object");
        }
    }
}
```

**Ternary Operator for Null Check:**

```java
String result = (e2 != null) ? e2.x + ", " + e2.y : "null";
System.out.println(result);
```

> [!IMPORTANT]
> Null causes compile errors when ambiguous, runtime NPE when dereferencing.

### Lab Demos

#### Demo 1: Null Behaviors
1. Declare `Example e1 = new Example();`, `Example e2 = null;`, `Example e3;`.
2. Attempt to print each variable directly.
3. Attempt to access `e1.x`, `e2.x`, `e3.x`.
4. Use cast operators: `System.out.println((String) null);`.
   - Compile/run to see errors and outputs.

#### Demo 2: NPE Prevention
1. Create method with reference parameter that may be null.
2. Without check, access parameter's fields → NPE.
3. Add `if (param != null)` check before access.
4. Use ternary for compact handling.
   - Test with null/non-null args to verify prevention.

> [!NOTE]
> Empty references must contain null or object; can't use uninitialized in expressions.

## Summary

### Key Takeaways

```diff
+ Reference variables store object addresses or null, classified by declaration (static/instance/parameter/local) and value (object/null/empty)
+ Static references share objects across class instances; instance references create per-object copies
+ Null is a literal of any reference type, used to initialize references before object assignment
- Direct null usage causes compile ambiguities; dereferencing null causes runtime NPE
! Add null checks (if/ternary) to prevent NPE; use class name for static access, object for instance
+ Practice memory diagrams to visualize heap/method area interactions
```

### Expert Insight

#### Real-World Application
In enterprise apps, reference variables manage entity relationships (e.g., user address in e-commerce). Static references cache shared configs (database connections). Null guards prevent crashes in API responses or optional object graphs. Production uses Optional<T> or annotations to handle absent objects safely.

#### Expert Path
Master NPE debugging by enabling JVM stack traces (`-XX:ThrowNPEWithStackTrace`). Study Lombok's `@NonNull` for declarative checks. Advance to defensive programming: integrate design patterns like Null Object or Builder to avoid nulls. Practice profiling tools (JProfiler) for memory leak detection from uncollected references.

#### Common Pitfalls
🍂 Early pitfall: Forgetting null checks on method parameters/objects, leading to NPE in user-facing features like payments or profile updates.  
❌ Mistake: Treating null as object with `.equals()` without checks, risking `equals()` NPE.  
⚠ Hidden issue: Static references unintentionally shared across threads, causing race conditions in concurrent apps.  
Solution: Unit test with Mockito's `when().thenReturn(null)`; integrate code coverage tools to ensure null paths tested.  
Lesser known: Autoboxing `null` to primitives (e.g., `Integer val = null; int x = val;`) throws NPE unexpectedly in arithmetic. Avoid by explicit checks or using Optional.  
Avoid: Over-relying on ternary; prefer early returns for readability. Record NPE stack traces in logs for faster debugging.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
