# Session 148: JAVA API 07

## Table of Contents
- [Object Class Methods Overview](#object-class-methods-overview)
- [toString Method Introduction](#tostring-method-introduction)
- [Overriding toString Method](#overriding-tostring-method)
- [Internal Behavior of toString](#internal-behavior-of-tostring)
- [equals, hashCode, and toString in Predefined Classes](#equals-hashcode-and-tostring-in-predefined-classes)
- [getClass Method](#getclass-method)
- [toString Method Internal Logic](#tostring-method-internal-logic)
- [Employee Class Demonstration](#employee-class-demonstration)

## Object Class Methods Overview
💡 **Overview**: This session focuses on key methods in the `java.lang.Object` class, the root of all Java classes. These methods provide fundamental functionality like object representation, comparison, and runtime information retrieval. We'll explore `toString()`, `equals()`, `hashCode()`, and `getClass()` methods, their default behaviors, and how to override them for custom object handling. Understanding these is crucial for effective Java programming, especially when working with collections where object identity and state comparison matter. Beginners will learn why these methods exist and how they enable runtime polymorphism without explicit overrides.

### Key Concepts in Object Class
The `Object` class contains methods that every Java object inherits:
- `toString()`: Returns a string representation of the object.
- `equals()`: Compares objects for equality.
- `hashCode()`: Returns a hash code for the object.
- `getClass()`: Returns the runtime class of the object.

These methods form the foundation for object behavior and can be customized via overriding.

## toString Method Introduction
📝 **Overview**: The `toString()` method in `java.lang.Object` is designed to convert an object into a string representation. By default, it returns the class name followed by '@' and the object's hash code in hexadecimal format. This method is automatically called when printing an object using `System.out.println()` or similar methods. For beginners, think of it as a way to get a readable string version of your object's state, much like converting a number to a string for display.

### Prototype and Default Behavior
- **Prototype**: `public String toString()`
- **Default Implementation**: Returns `className@hashCode` in hex string format.
- **Example Output**: For a `Student` object, it might display `Student@1c7` (where `1c7` is the hash code in hex).

> [!NOTE]
> The hash code is displayed in hexadecimal to compactly represent the integer value.

Run a simple test: Create a `Student` object and print it without overriding `toString()`. You'll see the default `className@hashCode` output.

```java
// Example code:
Student s1 = new Student(1, "HK", "CSE", 2500.0);
// System.out.println(s1); // Outputs: Student@xyz (hex hash code)
```

## Overriding toString Method
🔧 **Overview**: To display meaningful object data (like fields) instead of the default `className@hashCode`, override the `toString()` method in your class. Use Eclipse's Source > Generate toString() or write it manually. Append fields with separators (e.g., commas, tabs, newlines) to format the output as needed. This is essential for debugging and logging, allowing beginners to quickly inspect object states.

### Steps to Override toString
1. In your class (e.g., `Student`), add the `toString()` method.
2. Return a string combining fields with delimiters.
3. Example implementation:

```java
@Override
public String toString() {
    return studentNumber + "," + studentName + "," + course + "," + fee;
    // Or with colons and newlines: "Name: " + studentName + "\nCourse: " + course + "\nFee: " + fee;
}
```

> [!IMPORTANT]
> Always use `@Override` annotation for clarity and to catch errors.

After overriding, printing `s1` will now show the actual data, e.g., `1,HK,CSE,2500.0`.

- **Single Line Format**: Use `"\t"` for tabs or `","` for commas.
- **Multi-Line Format**: Use `"\n"` for newlines.
- Example with tabs: `"Student Number: " + studentNumber + "\tName: " + studentName + "\tCourse: " + course + "\tFee: " + fee`

This override enables readable output while maintaining the method's signature.

> [!NOTE]
> If you override `toString()` but not `hashCode()` or `equals()`, the default behaviors still apply for hashing and comparison.

## Internal Behavior of toString
⚙️ **Overview**: Internally, `Object.toString()` calls `getClass().getName() + "@" + Integer.toHexString(hashCode())`. Due to runtime polymorphism, if `hashCode()` is overridden in a subclass, the subclass version is used. This dynamic behavior ensures the method adapts to custom implementations without altering the super class code.

### Code Demonstration
```java
// In Object class (conceptual):
public String toString() {
    return getClass().getName() + "@" + Integer.toHexString(hashCode());
}

// When printing a Student object:
// toString() calls hashCode() - if overridden in Student, uses custom logic.
// E.g., if Student.hashCode() returns 5, output: "Student@5" (hex)
```

- **Runtime Polymorphism**: The `this.hashCode()` call executes from the object's actual class, even when called from `Object`.
- **Hash Code Conversion**: `Integer.toHexString(hashCode())` converts the integer hash code to hex.

If `hashCode()` is commented out, it falls back to default.

> [!TIP]
> Visualize this as the method building the string dynamically based on the runtime type.

## equals, hashCode, and toString in Predefined Classes
📚 **Overview**: Predefined classes in Java override these methods for state-based behavior:
- **String Class**: All three (`toString()`, `equals()`, `hashCode()`) are overridden for data-based operations.
- **Wrapper Classes** (e.g., `Integer`): Overridden to compare/return data, enabling value equality.
- **StringBuffer/StringBuilder**: Only `toString()` is overridden (returns data); `equals()` and `hashCode()` remain reference-based, focusing on mutability aspects.

### Comparisons
| Class          | hashCode() Overridden? | equals() Overridden? | toString() Overridden? | Behavior                     |
|----------------|-------------------------|----------------------|-------------------------|------------------------------|
| String        | Yes (data-based)       | Yes (data-based)    | Yes (returns data)    | Data equality & representation |
| Integer       | Yes                    | Yes                 | Yes                   | Value equality              |
| StringBuffer  | No (reference-based)   | No                  | Yes                   | Data display, ref comparison|

- **String Equality**: `"ABC".equals("ABC")` → `true`; hash codes match based on content.
- **StringBuffer Difference**: Creates `sb1` and `sb2` with `"ABC"`, `equals()` returns `false` (reference-based), but `toString()` shows data.

> [!NOTE]
> Override `hashCode()` and `equals()` together; skipping one can cause inconsistent behavior in collections.

These overrides enable efficient storage and retrieval in data structures like `HashMap`.

## getClass Method
🔍 **Overview**: The `getClass()` method returns a `Class` object representing the runtime class of the instance. Use it to inspect or instantiate the class dynamically. It's a `native` method, preventing overrides for consistency. Combined with `getName()`, it retrieves the fully qualified class name.

### Usage
- **Prototype**: `public final Class<?> getClass()`
- **Example**:
```java
Student s1 = new Student(101, "HK", "CSE", 2500.0);
Class<?> cls = s1.getClass(); // Returns Student.class
String name = cls.getName(); // Gets "com.example.Student" (fully qualified)
```

- **Purpose**: Essential for reflection, like checking object types at runtime.
- **Why Final?**: Logic is universal (same for all classes), preventing accidental overrides.

> [!TIP]
> Chain methods: `obj.getClass().getName()` directly gets the name.

Use for generic methods accepting any object type to print class names dynamically.

## toString Method Internal Logic
🧩 **Overview**: The complete default `toString()` logic is `this.getClass().getName() + "@" + Integer.toHexString(this.hashCode())`. This leverages `getClass()` for name retrieval and `hashCode()` for unique ID. It demonstrates API composition, where complex logic is built from existing methods.

### Breakdown
- `getClass().getName()`: Gets the class name (e.g., "Student").
- `"@"`: Static separator.
- `Integer.toHexString(hashCode())`: Converts hash code to hex string.
- **Polymorphic Execution**: `hashCode()` and `getClass()` run from the object's class, enabling dynamic behavior.

This design allows subclass overrides to influence output without changing the core method.

> [!IMPORTANT]
> As Java developers, we compose logic using the API instead of reimplementing from scratch, unlike C programmers.

## Employee Class Demonstration
💻 **Overview**: Here's a complete lab demo of overriding `toString()`, `equals()`, and `hashCode()` in an `Employee` class. This groups/identifies employees by department for collections. Comparison focuses on department and employee number to avoid duplicates and enable lookups.

### Lab Steps and Code
1. **Create Employee Class**:
```java
public class Employee {
    private int employeeNumber;
    private String employeeName;
    private String department;
    private double salary;

    // Constructor
    public Employee(int employeeNumber, String employeeName, String department, double salary) {
        this.employeeNumber = employeeNumber;
        this.employeeName = employeeName;
        this.department = department;
        this.salary = salary;
    }

    // Generate getters/setters via Eclipse (Shift+Alt+S > Generate Getters and Setters)
    
    // Override hashCode for department-based grouping
    @Override
    public int hashCode() {
        return department.hashCode(); // Groups by department
    }
    
    // Override equals for department and employeeNumber comparison
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Employee e = (Employee) obj; // Using instanceof pattern if Java 14+
        return department.equals(e.department) && employeeNumber == e.employeeNumber;
    }
    
    // Override toString for meaningful display
    @Override
    public String toString() {
        return "Employee Number: " + employeeNumber + ", Name: " + employeeName + ", Department: " + department + ", Salary: " + salary;
    }
}
```

2. **Run and Test**:
- Create objects: `Employee e1 = new Employee(1, "John", "CSE", 50000);`
- Print: `System.out.println(e1);` → Displays state data.
- Compare: `e1.equals(new Employee(1, "Jane", "CSE", 60000))` → `true` (same dept and number).
- Hash codes: Same department objects get same hash.
- Enable preview features in Eclipse for `instanceof` pattern matching if needed.

This setup ensures employees are stored uniquely by department and number in collections like `HashSet`.

> [!NOTE]
> Override all three for collection compatibility; defaults work but don't support data-based logic.

## Summary

### Key Takeaways
```diff
+ Understand Object class foundation: toString(), equals(), hashCode(), getClass() handle object representation, comparison, hashing, and runtime class retrieval.
+ Override for custom behavior: Subclass overrides enable data-based operations, crucial for collections and polymorphism.
+ Default toString() uses className@hashCode in hex; customize by returning state via manual or generated methods.
+ Runtime polymorphism applies: Object methods execute from subclass if overridden, aiding dynamic behavior.
+ String/Wrapper classes override all three for data equality; StringBuffer/StringBuilder only toString().
+ getClass() and method chaining retrieve runtime class info; method is final for consistency.
+ Internal toString() logic: Compose with getClass(), Integer.toHexString(), and hashCode().
+ Employee demo: Overwrite hashCode(), equals() (together), toString() for department/employeeNumber-based grouping/comparison.
```

### Expert Insight
**Real-world Application**: In production Java apps (e.g., Spring Boot), overriding `toString()` improves logging/debugging by showing meaningful object states in stack traces. `equals()` and `hashCode()` ensure correct equality in `HashMap` keys or `HashSet` uniqueness, vital for caching, user sessions, or inventory management. Use `getClass()` in reflection-based frameworks like Hibernate for dynamic ORM.

**Expert Path**: Master method overrides by studying collection implementations (e.g., how `HashMap` uses `hashCode()` for bucketing and `equals()` for probing). Practice with generics and avoid inconsistencies (per Joshua Bloch's checklist). Dive into JVM internals via tools like VisualVM to see hash code distributions.

**Common Pitfalls**:
- Overriding `equals()` without `hashCode()` breaks contracts, causing collection bugs (e.g., `HashMap` can't find keys).
- Neglecting `toString()` leads to unreadable logs; always override for domain objects.
- Using references in equals/hashCode for mutable classes (e.g., Employee) risks state changes invalidating collection integrity.
- Lesser known: `getClass()` vs. `instanceof` – `getClass()` is stricter (exact type match), avoiding bugs in inheritance hierarchies; Integer.toHexString ensures consistent hex output, preventing display issues.
- Resolution: Use IDE tools for auto-generation, test overrides thoroughly (e.g., via unit tests for symmetry/transitivity), and avoid modifying overrode methods post-production. Always compare primitives directly and call super for field-inherited classes.

**Mistake Corrections**: 
- "two string" → "toString"
- "Ash code" → "hash code" 
- "htp" not present; assumed typos corrected in context.
- "cubectl" not present; transcript has correct terms.
