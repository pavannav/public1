# Session 146: JAVA API 06

## Table of Contents
- [JDK 15 Setup with Eclipse](#jdk-15-setup-with-eclipse)
- [Code Commenting Shortcuts](#code-commenting-shortcuts)
- [The equals() Method](#the-equals-method)
- [Overriding the equals() Method](#overriding-the-equals-method)
- [Differences Between == Operator and equals() Method](#differences-between--operator-and-equals-method)
- [Summary](#summary)

## JDK 15 Setup with Eclipse

### Overview
This session demonstrates how to configure Eclipse IDE to support JDK 15, including downloading, installation, and plugin integration.

### Key Concepts

#### Installation Steps

1. **Download and Install JDK 15**
   ```bash
   # Download from oracle.com or adoptopenjdk.net
   # Install JDK 15 and set environment variables
   ```

2. **Set Path to JDK 15 in System Environment**
   - Add JDK 15 bin directory to PATH
   - Set JAVA_HOME environment variable to JDK 15 installation path

3. **Download and Install Latest Eclipse Version**
   - Download Eclipse 2020-12 or later from eclipse.org
   - Install and launch the Eclipse IDE

4. **Upgrade Eclipse with JDK 15 Plugin**
   - Go to Help → Eclipse Marketplace
   - Search for "Java 15 support for Eclipse"
   - Install the plugin from the search results
   - Restart Eclipse after installation

#### Project Creation with JDK 15

- Create new Java project
- Select "Java Project" from File → New menu
- In project wizard:
  - Enter project name (e.g., "JavaAPI06")
  - Select execution environment
  - If JavaSE-15 is not shown in JRE dropdown, the plugin installation may need verification

> [!NOTE]
> Eclipse versions prior to 2020-12 only support up to JDK 14. The JDK 15 plugin is essential for full compatibility.

## Code Commenting Shortcuts

### Overview
Eclipse provides keyboard shortcuts for efficiently commenting and uncommenting code blocks.

### Key Shortcuts

#### Single Line Comments
- Add single line comment: `Ctrl + /`
- Remove single line comment: `Ctrl + /` (toggle)

#### Multi-Line Comments
- Add block comment: `Ctrl + Shift + /`
- Remove block comment: `Ctrl + Shift + \` (backslash)

#### Code Formatting After Uncommenting
- Format code: `Ctrl + Shift + F`

> [!TIP]
> Use `Ctrl + A` to select all code before applying comment shortcuts. Always format code after uncommenting to restore proper indentation.

**Example Workflow:**
```java
// Select all lines (Ctrl + A)
// Comment: Ctrl + Shift + /
// Uncomment: Ctrl + Shift + \
// Format: Ctrl + Shift + F
```

## The equals() Method

### Overview
The `equals()` method is a fundamental method in Java's `Object` class used to compare two objects for equality. By default, it compares objects by reference, but can be overridden to compare by content/state.

### Key Concepts

#### Method Prototype
```java
public boolean equals(Object obj)
```

#### Default Behavior
- Compares objects using reference equality (same as `==` operator)
- Returns `true` only if both references point to the same object instance
- Does not compare object content/data by default

#### Object Comparison Types
1. **Reference Comparison**: Using `==` operator or default `equals()`
2. **Content Comparison**: Using overridden `equals()` method

#### Student Class Example
```java
class Student {
    int sno;
    String sname;
    String course;
    
    // Constructor and methods...
}
```

**Default equals() behavior:**
```java
Student s1 = new Student(101, "Alice", "Java");
Student s2 = new Student(101, "Alice", "Java");

System.out.println(s1.equals(s2)); // false (different references)
System.out.println(s1 == s2);       // false (different references)
```

#### String Class equals() Override
```java
String str1 = new String("hello");
String str2 = new String("hello");

System.out.println(str1.equals(str2)); // true (content comparison)
System.out.println(str1 == str2);       // false (different references)
```

#### Integer Class Pooling
```java
Integer i1 = 5;
Integer i2 = 5;
System.out.println(i1.equals(i2)); // true (content comparison)
System.out.println(i1 == i2);       // true (same object due to pooling)

Integer i3 = 150;
Integer i4 = 150;
System.out.println(i3.equals(i4)); // true (content comparison)
System.out.println(i3 == i4);       // false (different objects, outside byte range)
```

> [!NOTE]
> Integer pooling applies to values between -128 and 127. Values outside this range create separate objects.

## Overriding the equals() Method

### Overview
Override the `equals()` method to compare objects based on their content rather than reference.

### Implementation Steps

#### Basic Override Structure
```java
@Override
public boolean equals(Object obj) {
    // 1. Check if obj is instance of current class
    if (!(obj instanceof Student)) {
        return false;
    }
    
    // 2. Type cast obj to current class
    Student s = (Student) obj;
    
    // 3. Compare required properties
    return this.sno == s.sno && 
           this.sname.equals(s.sname) && 
           this.course.equals(s.course);
}
```

#### Incorrect Implementation Example
```java
// WRONG: Comparing only one property
@Override
public boolean equals(Object obj) {
    if (!(obj instanceof Student)) {
        return false;
    }
    
    Student s = (Student) obj;
    return this.sno == s.sno; // Only compares student number
}
```

#### Correct Implementation Example
```java
// CORRECT: Compare all relevant properties
@Override
public boolean equals(Object obj) {
    if (!(obj instanceof Student)) {
        return false;
    }
    
    Student s = (Student) obj;
    
    // Compare student number (unique identifier)
    if (this.sno != s.sno) {
        return false;
    }
    
    // Compare course (grouping property)
    if (!this.course.equals(s.course)) {
        return false;
    }
    
    // Compare name (additional property)
    if (!this.sname.equals(s.sname)) {
        return false;
    }
    
    return true;
}
```

#### Properties to Compare
1. **Grouping Property**: Properties that categorize objects (e.g., `course`)
2. **Unique Property**: Properties that uniquely identify objects (e.g., `sno`, `sname`)

> [!IMPORTANT]
> Always compare at least two properties: one grouping property and one unique property to ensure meaningful equality comparison.

**Example with Different Courses:**
```java
Student s1 = new Student(101, "Alice", "Core Java");
Student s2 = new Student(101, "Alice", "Adv Java");

System.out.println(s1.equals(s2)); // false (different courses)
```

## Differences Between == Operator and equals() Method

### Overview
Understanding the fundamental differences between reference comparison (`==`) and content comparison (`equals()`) is crucial for correct object comparison in Java.

### Key Differences

#### 1. Usage Scope
```java
// == can compare both primitives and objects
int x = 5;
int y = 5;
System.out.println(x == y); // true

Student s1 = new Student(1, "A", "Java");
Student s2 = new Student(1, "A", "Java");
System.out.println(s1 == s2); // false

// equals() can only compare objects
System.out.println(s1.equals(s2)); // depends on implementation

// equals() with primitives - COMPILER ERROR
// int a = 10;
// int b = 20;
// System.out.println(a.equals(b)); // ERROR: cannot invoke equals on primitive
```

#### 2. Comparison Type
```java
// == always compares references (for objects)
Student s1 = new Student(1, "A", "Java");
Student s2 = new Student(1, "A", "Java");
System.out.println(s1 == s2); // false - different object references

// equals() compares based on implementation
// Default: reference comparison
System.out.println(s1.equals(s2)); // false - same as == by default

// Overridden: content comparison
// After overriding equals() method
System.out.println(s1.equals(s2)); // Could be true - compares content
```

#### 3. Incompatible Types
```java
Student s = new Student(1, "A", "Java");
Integer i = 10;

// == cannot compare incompatible types - COMPILER ERROR
// System.out.println(s == i); // ERROR

// equals() can compare any objects, returns false
System.out.println(s.equals(i)); // false (no ClassCastException)
```

#### 4. Null Comparison
```java
Student s1 = new Student(1, "A", "Java");
Student s2 = null;

// == can compare with null
System.out.println(s1 == null); // false
System.out.println(null == s2); // true

// equals() with null reference variable - works
System.out.println(s1.equals(null)); // false

// equals() with null as current object - COMPILER ERROR
// System.out.println(null.equals(s1)); // ERROR: null cannot be dereferenced

// equals() with null comparison internally - works
```

#### 5. Reference Variables and null
```java
Student s1 = new Student(1, "A", "Java");
Student s2 = null;

// == comparison with null
System.out.println(s1 == null);    // false
System.out.println(s2 == null);    // true

// equals() comparison with null
System.out.println(s1.equals(null)); // false (handled in equals method)
System.out.println(s2.equals(null)); // NullPointerException

// Null reference variable as argument
Student s3 = null;
System.out.println(s1.equals(s3));   // false
```

#### 6. Object Reference vs null
```java
Object obj = new Student(1, "A", "Java");
Student s = null;

// == comparison
System.out.println(obj == null);     // false
System.out.println(null == obj);     // false

// equals() comparison
System.out.println(obj.equals(null));  // false
// System.out.println(null.equals(obj)); // COMPILER ERROR
```

### Summary Table

| Aspect | `==` Operator | `equals()` Method |
|--------|---------------|-------------------|
| **Usage** | Primitives and Objects | Objects only |
| **Comparison** | Always reference | Reference (default) or content (overridden) |
| **Incompatible types** | Compiler error | Returns false |
| **Null comparison** | Allowed (`null == obj`) | Compile/runtime error with null current object |
| **Null arguments** | Not applicable | Allowed, returns false |
| **Method signature** | N/A (operator) | `boolean equals(Object obj)` |

> [!WARNING]
> Using `==` for object comparison when content equality is needed leads to incorrect program behavior. Always use `equals()` for meaningful object comparison.

## Summary

### Key Takeaways
```diff
+ equals() method is inherited from Object class and can be overridden
+ By default, equals() compares objects by reference (same as == operator)
+ Override equals() to compare objects by content/data
+ Always check instanceof before type casting in equals() implementation
+ Compare both grouping and unique properties for meaningful equality
+ == operator cannot compare incompatible types, equals() can and returns false
+ == can compare with null, equals() can handle null arguments but not null current object
! Avoid using == for object content comparison - use equals() instead
```

### Expert Insight

#### Real-world Application
In enterprise applications, proper `equals()` implementation is crucial for:
- **Collection operations**: HashSet, HashMap use equals() for duplicate detection
- **Database entity comparison**: ORM frameworks rely on equals() for object identity
- **Caching mechanisms**: Cache keys depend on equals() for hit/miss detection
- **Business logic validation**: Comparing domain objects for equality

#### Expert Path
- **Contract Compliance**: Always override `hashCode()` when overriding `equals()`
- **Performance Considerations**: Keep equals() implementation efficient for large object graphs
- **Thread Safety**: Ensure equals() is thread-safe if objects are shared across threads
- **Symmetric Property**: equals() must be symmetric: `a.equals(b)` should return same as `b.equals(a)`

#### Common Pitfalls
- **Type casting without instanceof check**: Leads to ClassCastException
- **Null pointer exceptions**: Not handling null arguments properly in equals()
- **Incomplete property comparison**: Missing key properties in comparison logic
- **Reference comparison instead of content**: Using == where equals() is needed
- **Inconsistent equals()/hashCode()**: Breaking hash-based collection contracts

**Lab Demo**: Create a Student class with proper equals() override, then test with various scenarios including null comparisons and incompatible object types. Practice the six key differences between == and equals() method.

**Correction Notice**: The transcript contains no significant spelling errors requiring correction. The content appears accurate for the Java programming concepts discussed.

### Model ID
<model-summary>CL-KK-Terminal</model-summary>
