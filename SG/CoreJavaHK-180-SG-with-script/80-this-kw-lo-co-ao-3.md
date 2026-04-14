# Session 80: This Keyword, Local Object, Current Object, and Argument Object 3

- [Sharing Objects Between Methods](#sharing-objects-between-methods)
- [Real-world Applications of Object Sharing](#real-world-applications-of-object-sharing)
- [Passing Primitive Values and Objects](#passing-primitive-values-and-objects)
- [Limiting Object Sharing to Same Class](#limiting-object-sharing-to-same-class)
- [Pass By Value, Pass By Reference, and Pass By Address](#pass-by-value-pass-by-reference-and-pass-by-address)
- [Java's Support for Pass By Value](#javas-support-for-pass-by-value)
- [Practical Examples and Assignments](#practical-examples-and-assignments)

## Sharing Objects Between Methods

### Overview

Object sharing refers to passing objects between methods, either as current objects (implicit for non-static methods via the `this` keyword) or as argument objects. This allows data to be transferred and modified across method calls. Primitive values can only be passed as arguments, while objects can be passed in multiple ways depending on whether they are in the same class or different classes.

### Key Concepts/Deep Dive

- **Sharing Objects Within the Same Class Non-Static Methods**:
  - Objects can be passed as current objects (using `this`, which is implicit) or as arguments.
  - To pass one object: Zero parameters for current object, one implicit `this` parameter created by the compiler.
  - To pass two objects: One explicit parameter for the argument object, plus implicit `this` for current object.

- **Sharing Objects from Static Methods**:
  - Static methods do not have `this`, so objects can only be passed as arguments.
  - To pass one object: One explicit parameter.
  - To pass two objects: Two explicit parameters.

- **Method Call Examples**:
  | Scenario | Method Type | Parameters Needed | Call Example |
  |----------|-------------|-------------------|--------------|
  | Pass one object to non-static method | Non-static | 0 (implicit this) | `e1.m1()` |
  | Pass one object to static method | Static | 1 (explicit) | `ClassName.m1(e1)` |
  | Pass two objects to non-static method | Non-static | 1 (explicit for second) | `e1.m2(e2)` |
  | Pass two objects to static method | Static | 2 (explicit) | `ClassName.m2(e1, e2)` |

- **Modification and Scope**:
  - When passing as current object: Object is implicitly available.
  - When passing as argument: Object must be explicitly passed and can be from same or different class.
  - Modifications to the object affect the calling method because it's the same reference.

### Code/Config Blocks

```java
class Example {
    int x = 10;
    int y = 2020;
    
    void m1(Example e) {  // Argument object
        this.x += 1;  // Modifies current object
        e.x += 2;     // Modifies argument object
    }
    
    static void m2(Example a, Example b) {
        // Static method: only argument objects
        // Cannot access this (no implicit current object)
    }
}
```

### Lab Demos

**Demo 1: Sharing Objects Within Same Class**
1. Create a class `Example` with variables `x` and `y`.
2. Create method `void modify(Example e)` where `this.x = 100` and `e.y = 200`.
3. In `main()`, create objects `e1` and `e2`.
4. Call `e1.modify(e2)`.
5. Print `e1.x` and `e2.y` to show modifications.
   - Expected output: e1.x = 100, e2.y = 200.

**Demo 2: Static Method Object Sharing**
1. Add static method `static void swap(Example a, Example b)` in `Example` class.
2. In `swap`, exchange the `x` values of `a` and `b`.
3. In `main()`, create `e1.x = 10`, `e2.x = 20`.
4. Call `Example.swap(e1, e2)`.
5. Print `e1.x` and `e2.x`.
   - Expected output: e1.x = 20, e2.x = 10.

**Demo 3: Primitive Value Passing (Cannot Use as Current Object)**
1. Create static method `static int increment(int num)` where `num += 5; return num;`.
2. In `main()`, int `val = 10;`.
3. Call `int result = Example.increment(val);`.
4. Print `val` and `result`.
   - Expected output: val = 10 (unchanged), result = 15.

## Real-world Applications of Object Sharing

### Overview

Object sharing in programming mirrors real-world object transfer, where modifications affect multiple parties since they reference the same entity.

### Key Concepts/Deep Dive

- **Examples**:
  - Factory → Showroom → Customer: Bike object shared, modifications (repairs) affect all.
  - Bank → Customer → Online Shopping App: Bank account modifications reflect across entities.
  - College → Student → University: Student info shared for hall ticket generation.

- **Key Insight**: Shared objects maintain state across interactions; changes are global to references.
- **Impact**: Essential for collaborative systems; improper sharing leads to data inconsistencies.

### Code/Config Blocks

```java
class Bike {
    String condition = "New";
    
    void repair() {
        this.condition = "Repaired";
    }
}

class Factory {
    // Returns shared bike object
    static Bike produceBike() {
        return new Bike();
    }
}

class Showroom {
    Bike bike = Factory.produceBike();  // Shared with factory
    void sell(Bike b) {  // b shared with customer
        b.repair();  // Modifies shared object
    }
}
```

### Lab Demos

**Demo 4: Factory-Showroom-Customer Workflow**
1. Create class `Bike` with `String condition = "New";`.
2. Create `Factory.produceBike()` returning a `Bike`.
3. Create `Showroom` with `Bike bike = Factory.produceBike();`.
4. Add `void sell(Customer c)` where `c.receiveBike(bike);`.

> [!NOTE]  
> Sharing means one object is accessed by multiple entities, unlike creating copies.

## Passing Primitive Values and Objects

### Overview

Primitive values (int, double) and objects (references) are passed differently: primitives pass by value only as arguments, objects pass by reference (value of reference) also as arguments, but objects can be current references in non-static methods.

### Key Concepts/Deep Dive

- **Primitive Values**: Passed only as arguments (by value); no current object usage. Modifications don't affect caller.
- **Objects**: Passed by value (of reference) as arguments or implicitly as current (`this`). Modifications to object fields affect caller, but reassigning the parameter doesn't (as it's local).

### Code/Config Blocks

```java
// Primitive: by value (argument only)
static void modifyPrimitive(int num) {
    num += 10;  // No effect on caller
}

// Object: by reference (can modify fields, but not reassign pointer)
static void modifyObject(Example e) {
    e.x += 10;          // Affects caller
    // e = new Example();  // Does NOT affect caller (local reassignment)
}
```

### Lab Demos

**Demo 5: Primitive vs. Object Passing**
1. Define static method `static void changePrimitive(int val)` setting `val = 50;`.
2. Define `static void changeObject(Example obj)` setting `obj.x = 50;`.
3. In `main()`, `int a = 20; Example e = new Example(30);`.
4. Call `changePrimitive(a); changeObject(e);`.
5. Print `a` and `e.x`.
   - Expected: a = 20 (unchanged), e.x = 50 (changed).

## Limiting Object Sharing to Same Class

### Overview

Objects can only be shared as current objects to methods of the same class. For other classes, they must be passed as arguments.

### Key Concepts/Deep Dive

- **Same Class**: Use `this` implicitly or explicitly as argument.
- **Different Class**: Pass only as argument; compiler errors for attempting current object sharing across classes.
- **Examples**:
  - `example1.m1(example2)`: Valid if `m1` accepts `Example`.
  - `sample.m2(exampleObj)`: Compiler error if `m2` expects different class.

### Tables

| Sharing Type | Same Class | Different Class |
|--------------|------------|-----------------|
| Current Object | Yes (this) | No (Error) |
| Argument Object | Yes | Yes |

### Code/Config Blocks

```java
class Example {
    void m1(Example e) {  // Same class argument
        this.x = e.x;    // Current object from same class
    }
}

class Sample {
    void m2(Example e) {  // Different class argument
        // Cannot use this as if it were Example
    }
}
```

### Lab Demos

**Demo 6: Cross-Class Object Sharing**
1. Create classes `Student` and `College`.
2. In `Student`, constructor and methods to set name, enroll validation.
3. In `College`, `void admit(Student s)` where `s.validateEnroll();`.
4. In `main()`, `Student stu = new Student("John"); College col = new College(); col.admit(stu);`.
5. Show that `stu` fields are modified if `validateEnroll` changes them.

> [!IMPORTANT]  
> Attempting `col.admit_as_current(stu)` where class mismatch → Compile error.

## Pass By Value, Pass By Reference, and Pass By Address

### Overview

Programming languages handle argument passing differently: C passes by value or address, C++ adds reference, Java uses pass by value exclusively, where "reference" means passing object reference values.

### Key Concepts/Deep Dive

- **Pass By Value**: Values copied to parameters; changes don't affect originals (Java for primitives and references).
- **Pass By Reference**: Modifies original directly (not in Java officially, but debated for objects).
- **Pass By Address**: Passes memory addresses (pointers; not in Java).

> [!NOTE]  
> Java officially supports only pass by value, but for objects, it's "by value of reference," leading to debate.

### Code/Config Blocks

```java
// Java: Always pass by value
static void passValue(int x) {
    x = 20;  // No change to original
}

static void passObject(Example obj) {
    obj.x = 20;           // Affects original (object field's mod)
    // obj = new Example();  // Does NOT affect original (reference reassignment)
}
```

### Tables

| Language | Pass By Value | Pass By Reference | Pass By Address |
|----------|---------------|-------------------|------------------|
| C | Yes | No | Yes |
| C++ | Yes | Yes | Yes |
| Java | Yes | No (debatable) | No |

### Lab Demos

**Demo 7: Object Modification Effects**
1. Create `Example` with `int x = 10;`.
2. Static methods: `modifyField(Example e)` sets `e.x = 50;`, `reassign(Example e)` sets `e = new Example(100);`.
3. In `main()`, `Example ex = new Example();` then call both.
4. Print `ex.x`.
   - Expected: 50 (field mod affected), not 100 (reassign ignored).

## Java's Support for Pass By Value

### Overview

Java supports pass by value only. While textbooks claim pass by reference for objects (due to field modifications), Sun Microsystems defines it as pass by value, where the reference value is passed.

### Key Concepts/Deep Dive

- **Official Stance**: Primitive arguments: by value. Object arguments: by value (reference value passed).
- **Debate**: Modifying object fields affects original (looks like reference), but reassigning parameter doesn't (proves by value).
- **Implications**: Use carefully; field changes global, reassignments local.

### Code/Config Blocks

```java
// Official Java pass by value example
public static void main(String[] args) {
    Example ex = new Example(10);
    passByValue(ex);
    System.out.println("Value after passByValue: " + ex.x);  // 10 (original unchanged if reassigned)
}

static void passByValue(Example e) {
    e.x = 50;              // Affects original
    e = new Example(100);  // Local only
}
```

### Lab Demos

**Demo 8: Interview-Style Question on Pass By Value**
1. Implement methods as above.
2. Run and observe outputs.
3. Conclusion: Java is pass by value; debate arises from terminology but practice confirms.

> [!IMPORTANT]  
> In interviews, explain practical effects: primitive mods don't transfer, object field mods do, but parameter reassignments don't.

## Practical Examples and Assignments

### Overview

Assignments focus on implementing object sharing, with progression from simple to complex examples like Factory-Showroom-Customer.

### Key Concepts/Deep Dive

- **Assignment 1: Develop Factory-Showroom-Customer**
  - Classes: Factory (create bike), Showroom (share bike), Customer (receive and modify).
  - Track modifications across sharing.

- **Assignment 2: Student-College-University**
  - Pass student object as arguments only; simulate enrollment and exam processes.
  - Return hall ticket numbers from methods.

### Code/Config Blocks

```java
// Sample Assignment Structure
class Student {
    String name;
    int hallTicket;
    
    void setDetails(String n) {
        name = n;
    }
}

class College {
    void join(Student s) {
        s.validate();  // Modify s
    }
}

class University {
    int applyExam(Student s) {
        s.hallTicket = generateNumber();
        return s.hallTicket;
    }
}
```

### Lab Demos

**Demo 9: Student Enrollment Workflow**
1-8. Create classes as above, initialize student, call `college.join(student)`, then `university.applyExam(student)`.
9. Ensure mods affect `student` object across calls.

## Summary

### Key Takeaways

```diff
+ Always use 'this' implicitly in non-static methods for current object.
+ Objects passed as arguments in static methods only.
+ Primitive values: pass by value (arguments only; no current).
+ Objects: pass by value, but field mods prove "effective reference."
- Avoid cross-class current object sharing (causes errors).
- Reassigning parameters locally doesn't affect originals.
! Object sharing brightly important; master to avoid common pitfalls.
```

### Expert Insight

#### Real-world Application
In production, object sharing enables efficient resource management, e.g., in microservices where entities like users or transactions are passed without copying. Modifications (getters/setters) ensure data consistency, as seen in banking apps where account changes reflect across services.

#### Expert Path
Master by building multi-class projects with shared objects, practicing pass-by-value scenarios. Study Java tutorials on "passing objects" and debate Sun vs. textbook views. Advanced: Explore immutable objects to prevent unintended mods.

#### Common Pitfalls
- Using primitive as current object (compile error).
- Expecting reassignments to affect callers—they don't.
- Cross-class 'this' usage (method not found errors).
- Ignoring field vs. reference mods in objects.

Mistakes in transcript and corrections noted:  
- "htp instead of http": Not found in this transcript; perhaps referring to hypothetical.  
- "cubectl instead of kubectl": Not present.  
- "rose button" corrected to "raise button" in multiple places (likely "raise" for class interaction).  
- "Prote Modeling Institute" or similar: Transcript has "computation" etc., but mainly typos fixed: e.g., "objecte" to "object", but Assuming standard. Specific: "reffe variable" to "reference variable", but transcript has "refe". Actually, transcript has "reffe variable" → corrected to "reference variable". Understanding terms like "logic we have developed" → clear. No major grammatical; transcript appears self-corrected in flow.
