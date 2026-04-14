# Session 76: Ref vars, Null and NPE 2

## Table of Contents
- [Recap of Reference Variables and NPE Handling](#recap-of-reference-variables-and-npe-handling)
- [Working with the toString Method](#working-with-the-tostring-method)
- [Memory Structure: Static vs Non-Static Variables](#memory-structure-static-vs-non-static-variables)
- [Ways to Access Static and Non-Static Variables](#ways-to-access-static-and-non-static-variables)
- [Modifications to Variables and Their Effects](#modifications-to-variables-and-their-effects)

## Recap of Reference Variables and NPE Handling

### Overview
This session builds upon the previous discussion on reference variables, null pointer exceptions (NPE), and their handling. In the last session, we covered:
- Types of reference variables
- The nature and causes of null pointer exceptions
- Two primary ways to resolve NPE:
  1. Assign an object to the null-referenced variable
  2. Use `!= null` condition checks

### Key Concepts/Deep Dive
Reference variables store memory addresses (references) that point to objects on the heap. Unlike primitive variables that store values directly, reference variables contain references to objects.

Types of reference variables include:
- Object references pointing to valid objects
- Null references (initialized to `null`)
- Uninitialized references (compile-time errors if used)

Null pointer exceptions occur when attempting to access members of a null reference:
```java
Example e = null;
e.someMethod(); // Throws NullPointerException
```

### Handling NPE
Two primary solutions were introduced:
1. **Object Assignment**: Initialize the variable properly
   ```java
   Example e = new Example(); // Now safe to use
   ```
2. **Conditional Checks**: Test for null before usage
   ```java
   if (e != null) {
       e.someMethod(); // Safe call
   }
   ```

## Working with the toString Method

### Overview
The `toString()` method provides string representation of objects. When we print objects using `System.out.println()`, Java implicitly calls `toString()` to convert the object reference into a meaningful string.

### Key Concepts/Deep Dive

#### Default toString Behavior
By default, `toString()` (inherited from `Object` class) displays:
- Class name
- "@" symbol
- Hash code in hexadecimal format

```java
Example e1 = new Example();
System.out.println(e1); // Output: Example@1a2b3c (example format)
// Class name at the rate hash code in hexa string format
```

This represents **reference-wise information** rather than object data, designed to avoid confusion with numeric references.

#### Why Hexadecimal Representation?
Direct display of memory addresses could mislead developers into thinking references are primitive integers. Sun Microsystems designed this format to clearly distinguish object references from primitive values.

#### String Objects vs Custom Objects
String objects override `toString()` to display actual content:
```java
String s1 = new String("ABC");
System.out.println(s1); // Output: ABC
```

While custom objects show reference information by default.

#### Overriding toString Method
To display **object data** instead of reference information, override `toString()` in your class:

```java
public class Example {
    private int x = 10;
    private int y = 20;

    @Override
    public String toString() {
        return "x = " + x + ", y = " + y;
    }

    public static void main(String[] args) {
        Example e1 = new Example();
        System.out.println(e1); // Output: x = 10, y = 20
    }
}
```

**Custom Pattern Example:**
```java
@Override
    public String toString() {
        return "Example(" + x + ", " + y + ")";
    }
// Output: Example(10, 20)
```

#### toString and Null References
When passing null to `println()`, no `toString()` call occurs:
```java
Example e2 = null;
System.out.println(e2); // Output: null (no NPE!)
```

The `println()` method includes null checking - if the argument is null, it displays "null" directly without invoking `toString()`.

However, explicit `toString()` calls on null references throw NPE:
```java
Example e2 = null;
String result = e2.toString(); // NullPointerException!
```

#### Student Class Example
Following the toString pattern for displaying object data:

```java
public class Student {
    private int sno;
    private String sname;
    private String course;
    private double fee;

    // Constructor and setters/getters...

    @Override
    public String toString() {
        return "SNO: " + sno + ", SNAME: " + sname + ", COURSE: " + course + ", FEE: " + fee;
    }
}
```

### Lab Demo: Implementing toString
Let's create a Student class with toString override:

1. Create Student class with instance variables: sno, sname, course, fee
2. Override toString() method to return formatted object data
3. Create Student object and display using println()

```java
public class Student {
    private int sno;
    private String sname;
    private String course;
    private double fee;

    public Student(int sno, String sname, String course, double fee) {
        this.sno = sno;
        this.sname = sname;
        this.course = course;
        this.fee = fee;
    }

    @Override
    public String toString() {
        return "SNO: " + sno + "\nSNAME: " + sname + "\nCOURSE: " + course + "\nFEE: " + fee;
    }

    public static void main(String[] args) {
        Student s = new Student(101, "HK", "Java", 25000.0);
        System.out.println(s);
    }
}
```

Output:
```
SNO: 101
SNAME: HK
COURSE: Java
FEE: 25000.0
```

> [!IMPORTANT]
> Always override `toString()` in your custom classes to provide meaningful object representations, especially useful for debugging and logging.

## Memory Structure: Static vs Non-Static Variables

### Overview
Java Virtual Machine (JVM) architecture determines how static and non-static variables are stored and accessed. Static variables exist at the class level, while non-static variables (instance variables) exist per object.

### Key Concepts/Deep Dive

#### JVM Areas
```
┌─────────────────┐
│   Method Area   │ ← Static variables, class info
│   Java Stacks   │ ← Local variables, method frames
│   Heap Area     │ ← Objects (non-static variables)
└─────────────────┘
```

#### Memory Allocation Timeline

| Component | When Memory Allocated | Where Stored |
|-----------|----------------------|--------------|
| Static Variables | Class loading | Method Area |
| Non-Static Variables | Object creation (`new` keyword) | Heap Area |
| Local Variables | Method execution | Java Stack |

#### Example Visualization
```mermaid
graph TD
    A[Class Loading] --> B[Method Area: Static Variables (a, b)]
    C[Object Creation] --> D[Heap: Non-Static Variables (x, y)]
    E[Reference Variable e1 → Heap Object]
    B --> E
    D --> E
```

Static variables:
- **One copy per class** (common to all objects)
- Initialized to default values, then static blocks execute
- Stored in **Method Area** (Class Level)

Non-static variables:
- **Separate copy per object**
- Initialized during object construction
- Stored in **Heap** (Object Level)

#### Multiple Objects Scenario
```java
public class Example {
    static int a = 10;
    int x = 30;

    public static void main(String[] args) {
        Example e1 = new Example();
        Example e2 = new Example();
        // Both e1 and e2 share static 'a'
        // But have separate 'x' instances
    }
}
```

## Ways to Access Static and Non-Static Variables

### Overview
Access patterns differ significantly between static (class-level) and non-static (instance-level) variables due to their storage locations and scope.

### Key Concepts/Deep Dive

#### Static Variable Access (4 Ways)
Static variables can be accessed whenever the class is loaded:

1. **Direct Access** (within class):
   ```java
   System.out.println(a); // Direct name - valid in static context
   ```

2. **Class Name Access**:
   ```java
   System.out.println(Example.a); // ClassName.variable
   ```

3. **Object Reference Access**:
   ```java
   Example e1 = new Example();
   System.out.println(e1.a); // Object.variable - works due to type relation
   ```

4. **Null Reference Access** (⚠️ **No NPE!**):
   ```java
   Example e3 = null;
   System.out.println(e3.a); // Valid! No NullPointerException
   ```

> [!NOTE]
> Null reference can access static variables because static members belong to the class, not instances.

#### Non-Static Variable Access (1 Way Only)
Non-static variables require object context:

**INVALID Access Patterns:**
```java
System.out.println(x);          // ❌ Error: Non-static from static context
System.out.println(Example.x);  // ❌ Error: Cannot access instance from class
Example e3 = null;
System.out.println(e3.x);       // ❌ Runtime: NullPointerException
```

**VALID Access Pattern:**
```java
Example e1 = new Example();
System.out.println(e1.x); // ✅ Object reference required
```

#### Access Rules Summary

| Variable Type | Static Context | Instance Context | Null Reference |
|---------------|----------------|------------------|----------------|
| Static | ✅ Direct/Class Name | ✅ Object Reference | ✅ No NPE |
| Non-Static | ❌ Not Allowed | ✅ Object Reference | ❌ NPE |

#### Why These Differences?
- Static variables: Class-level scope, shared across instances
- Non-Static variables: Instance-level scope, unique per object

## Modifications to Variables and Their Effects

### Overview
Understanding how modifications propagate (or don't propagate) between objects is crucial for Java programming.

### Key Concepts/Deep Dive

#### Modification Propagation Rules

| Variable Type | Modification Effect | Reason |
|---------------|---------------------|---------|
| Static | Affects ALL objects | Single shared memory location |
| Non-Static | Affects ONLY that object | Separate memory per object |

#### Example Code
```java
public class Example {
    static int a = 10;    // Shared
    static int b = 20;    // Shared
    int x = 30;          // Per object
    int y = 40;          // Per object
}

public static void main(String[] args) {
    Example e1 = new Example();
    Example e2 = new Example();

    // Modify using e1
    e1.a = 15;    // Static modification
    e1.b = 16;    // Static modification
    e1.x = 7;     // Instance modification (e1 only)
    e1.y = 8;     // Instance modification (e1 only)

    // Check effects on e2
    System.out.println(e2.a); // 15 (modified - shared)
    System.out.println(e2.b); // 16 (modified - shared)
    System.out.println(e2.x); // 30 (unchanged - separate)
    System.out.println(e2.y); // 40 (unchanged - separate)
}
```

| Modification Type | Object Used | Affected Objects | Reason |
|-------------------|-------------|------------------|---------|
| Static Variable | e1 | All objects (e1, e2, etc.) | Single memory location |
| Non-Static Variable | e1 | Only e1 | Separate memory per object |

#### Real-World Analogy
- **Static Variables**: Like family property - modifications by one family member affect the whole family
- **Non-Static Variables**: Like personal belongings - modifications by one person don't affect others

## Summary

### Key Takeaways
```diff
+ Reference variables store memory addresses, not object data directly
+ Default toString() shows: className@hashCode (reference information)
+ Override toString() to display meaningful object data
+ println(null) displays "null" without calling toString()
+ Static variables: one shared copy per class (Method Area)
+ Non-static variables: separate copy per object (Heap Area)
+ Static access: 4 ways (direct, class name, object ref, even null ref)
+ Non-static access: 1 way only (object reference required)
+ Static modifications affect all objects; non-static affect only that instance
```

### Expert Insight

#### Real-world Application
In enterprise applications, proper `toString()` implementation is crucial for:
- **Logging**: Meaningful object representations in log files
- **Debugging**: Quick object state inspection during development
- **Serialization**: Consistent object string representations
- **Monitoring**: Clear object information in monitoring tools

#### Expert Path
- **Master Memory Models**: Draw JVM diagrams for complex inheritance hierarchies
- **Understand Reference Handling**: Practice with complex object graphs and null checks
- **Performance Optimization**: Know when static vs instance variables impact memory usage
- **Thread Safety**: Recognize static variable implications in multi-threaded environments

#### Common Pitfalls
- **Null Reference Access**: Attempting to access non-static members via null references
  ```java
  String name = null;
  System.out.println(name.length()); // NPE - forgot null check
  ```

- **Incorrect Variable Scope**: Using instance syntax where static is needed
  ```java
  class Utils {
      static String format(String s) { /*...*/ }

      // Inside some method:
      Utils u = new Utils();
      u.format("test"); // Works but unnecessary object creation
      Utils.format("test"); // Better: direct class access
  }
  ```

- **toString() Override Issues**:
  - Calling methods that might throw exceptions inside toString()
  - Infinite recursion if toString() calls other toString() methods inappropriately
  - Not handling null values in instance variables during toString()

#### Lesser Known Things
- `println()` has built-in null checking to prevent unnecessary NPEs
- Static variables can be accessed through null references because they're resolved at compile-time through the class type
- **Reference vs Object Size**: References are typically 4-8 bytes, while objects can be much larger
- JVM may optimize away unused empty reference declarations during compilation

#### Additional Issues and Resolution
Problems commonly encountered include memory leaks from improper static variable usage and performance bottlenecks from excessive object creation. To avoid leaks, minimize static collections and use weak references when appropriate. For performance, prefer static methods/constants over instance creation where static access suffices.
