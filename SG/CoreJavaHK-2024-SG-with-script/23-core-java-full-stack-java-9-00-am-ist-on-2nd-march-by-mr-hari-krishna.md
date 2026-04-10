# Session 23: Storing Data Using Classes

## Table of Contents
- [Overview](#overview)
- [Key Concepts](#key-concepts)
- [Lab Demos](#lab-demos)
- [Summary](#summary)

## Overview
> [!NOTE]
> This session focuses on how to store multiple values of different types by creating objects in Java. We'll explore the memory allocation process during object creation, understand the difference between static and non-static variables, and see how objects can contain other objects. The session includes memory visualization diagrams and practical real-world project examples.

In Java, when you need to store multiple related values of different data types, you can create a class to define the structure and then create objects (instances) of that class to store the actual data. This approach allows you to organize complex data and reuse it across your program.

## Key Concepts

### Memory Allocation in Object Creation

When you execute code like `Student s1 = new Student()`, three levels of execution occur:

1. **Variable Creation**: `Student s1` creates a reference variable in memory
2. **Object Instantiation**: `new Student()` allocates memory for all non-static variables defined in the Student class
3. **Reference Assignment**: The object reference is stored in the variable

```diff
! Example e1 = new Example(); // Three-level execution process:
+ Level 1: Example e1       // Variable creation (reference)
+ Level 2: new Example()    // Object memory allocation
+ Level 3: Assignment       // Reference stored in variable
```

### Static vs Non-Static Variables

| Aspect | Static Variables | Non-Static Variables |
|--------|------------------|----------------------|
| Memory Location | Class area | Object heap |
| Access | ClassName.variable | objectName.variable |
| Quantity | One per class | One per object instance |
| Initialization | During class loading | During object creation |

```java
class Example {
    static int staticVar = 100;    // One memory location per class
    int nonStaticVar = 200;       // Separate memory per object
}

public class Test {
    public static void main(String[] args) {
        Example e1 = new Example();  // Creates nonStaticVar memory for e1
        Example e2 = new Example();  // Creates another nonStaticVar memory for e2
    }
}
```

### Primitive vs Reference Variables

| Variable Type | Memory Storage | Example |
|---------------|----------------|---------|
| Primitive | Direct value | `int age = 25;` |
| Reference | Object reference | `String name = "John";` |

**Object Composition**: Objects can contain other objects, creating complex memory structures:

```diff
+ Example Object (Base: 10)
  + Primitive Variables: int, double, char, long
  + Reference Variables:
    - Array reference pointing to separate array object
    - String reference pointing to String object
    - String object internally contains char[] array
```

```diff
! Memory Hierarchy Example:
+ E1 (Reference Variable) → 10 (Base Address)
  + 10 Object Contents:
    - int i1 = 5
    - String s1 → 30 (String Object)
      + 30 Object Contents:
        - char[] value → 40 (Char Array)
          + ['H', 'a', 'r', 'i']
```

### Data Storage Methods in Java

Java provides three fundamental ways to store data:

#### 1. Variables
- Store single values
- Primitive types store values directly
- Reference types store object references

**Memory Pattern**: Variable → Value/Reference

#### 2. Arrays
- Store multiple values of same type
- Continuously allocated memory locations
- Reference-based access

**Memory Pattern**: Variable → Array Object → Multiple Values

#### 3. Class Objects
- Store multiple values of different types
- Group related data together
- Support unlimited object instances

**Memory Pattern**: Variable → Object → Multiple Variables → Values/Objects

### Real-World Project Development

In real applications, you create classes to represent business objects and manage their data:

**Student Management System**:
- **Class Design**: Define Student class with required fields
- **Object Creation**: Instantiate objects when users submit forms
- **Data Storage**: Store object data in instances
- **Multiple Objects**: Create one object per student record

**Architecture Layers**:
1. **UI Layer**: Forms, buttons (main method class)
2. **Logic Layer**: Object creation, data processing
3. **Storage Layer**: Database persistence

## Lab Demos

### Demo 1: Basic Object Creation and Memory Visualization

```java
class Student {
    // Instance variables
    int studentId;
    String studentName;
    String courseName;
    int courseFee;
    String email;
    String mobile;
}

public class CollegeManagement {
    public static void main(String[] args) {
        // Create first student object
        Student s1 = new Student();

        // Store first student data
        s1.studentId = 1;
        s1.studentName = "John Doe";
        s1.courseName = "Java Full Stack";
        s1.courseFee = 45000;
        s1.email = "john@example.com";
        s1.mobile = "9876543210";

        // Create second student object
        Student s2 = new Student();

        // Store second student data
        s2.studentId = 2;
        s2.studentName = "Jane Smith";
        s2.courseName = "Python Development";
        s2.courseFee = 35000;
        s2.email = "jane@example.com";
        s2.mobile = "9876543211";

        // Display student information
        System.out.println("Student 1: " + s1.studentName + " - " + s1.courseName);
        System.out.println("Student 2: " + s2.studentName + " - " + s2.courseName);
    }
}
```

This demo shows:
- Class declaration with multiple variable types
- Object instantiation for each student
- Separate memory allocation per object
- Data access using dot notation

### Demo 2: Complex Object Composition

```java
class Employee {
    int empId;
    String empName;
    String[] skills;  // Array reference
    String address;   // String reference
    long[] salaries;  // Another array reference
}

public class Organization {
    public static void main(String[] args) {
        // Create employee object with nested objects
        Employee emp = new Employee();

        emp.empId = 101;
        emp.empName = "Rajesh Kumar";
        emp.skills = new String[]{"Java", "Spring", "Microservices"};
        emp.address = "Hyderabad, Telangana";
        emp.salaries = new long[]{450000, 500000, 550000};

        // Access nested object data
        System.out.println("Employee: " + emp.empName);
        System.out.println("Skills: " + emp.skills[0] + ", " + emp.skills[1]);
        System.out.println("Latest Salary: ₹" + emp.salaries[2]);
    }
}
```

This demo illustrates:
- How objects can contain other objects (arrays, strings)
- Multiple levels of indirection
- Complex memory structures
- Accessing data through multiple reference levels

## Summary

### Key Takeaways

```diff
+ Three ways to store data in Java:
  - Variables: Single primitive/reference values
  - Arrays: Multiple values of same type
  - Class Objects: Multiple values of different types

+ Object creation has three execution levels:
  - Variable declaration
  - Memory allocation (new keyword)
  - Reference assignment

+ Static vs Non-Static:
  - Static: Class-level memory (shared)
  - Non-Static: Instance-level memory (per object)

+ Objects can contain other objects:
  - Primitive variables store values directly
  - Reference variables store object references
  - Arrays and Strings are also objects with internal structures
```

### Expert Insight

**Real-world Application**: Object-oriented data storage is fundamental to all enterprise applications. For example, an e-commerce application creates Product objects to store item details, User objects for customer information, and Order objects that combine both. This approach enables complex relationships and data integrity.

**Expert Path**: Focus on understanding the JVM visualization of memory allocation. Practice creating class hierarchies and object relationships. Master garbage collection concepts by understanding reference relationships. Study design patterns that leverage object composition for scalable applications.

**Common Pitfalls**:

```diff
- Don't confuse class declaration with object creation
- Avoid calling non-static variables/methods from static context
- Understand that new keyword creates instances, not objects
- Primitive arrays (int[], char[]) vs object arrays (String[], custom objects)
- Memory leaks from unnecessary object references
- Confusion between instance variables and class variables
```

**Lesser Known Facts**:
- String objects in Java are immutable by default, creating new objects on modification
- Arrays are objects themselves with length property automatically created by JVM
- The 'new' keyword not only allocates memory but also calls default constructors
- Static members exist before any object creation and persist throughout program execution
- Object references are 64-bit on most modern JVMs, regardless of system architecture

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
