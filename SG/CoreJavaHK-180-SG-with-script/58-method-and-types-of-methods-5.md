# Session 58: Method and Types of Methods 5

## Table of Contents
- [Wide Non-Wide Methods with Reference Data Types](#wide-non-wide-methods-with-reference-data-types)
- [Method Calling Ways](#method-calling-ways)
- [Program Execution and Memory Visualization](#program-execution-and-memory-visualization)
- [Non-Void Methods and Returning Objects](#non-void-methods-and-returning-objects)
- [Real-Time Examples: Student-College-University, Bike-Factory-Showroom](#real-time-examples-student-college-university-bike-factory-showroom)
- [Parameterized vs Non-Parameterized Methods](#parameterized-vs-non-parameterized-methods)
- [Method Rules and Argument Passing](#method-rules-and-argument-passing)
- [Object Passing as Arguments and Modifications](#object-passing-as-arguments-and-modifications)
- [Employee Project Example](#employee-project-example)

## Wide Non-Wide Methods with Reference Data Types

### Overview
This session extends the understanding of void and non-void methods by applying them to reference data types (objects) rather than primitive data types. The focus is on creating objects in methods, returning them, and visualizing memory and execution flow.

### Key Concepts/Deep Dive
#### Creating Objects with Reference Types
- Use class name as return type for non-void methods (e.g., `static Student M2()`).
- Inside methods, declare variables of the class type and initialize with `new ClassName()`.
- Assign values to object fields (e.g., `S2.sn = 102; S2.sname = "BK"; S2.course = "Acting"; S2.fee = 2000;`.
- For return, simply write `return S2;` where S2 holds the object reference.

#### Memory Diagram Visualization
- Object creation: JVM allocates memory for all class variables as instance fields.
- Visualization steps:
  1. Compiler checks syntax for variable declarations and constructor calls.
  2. JVM allocates memory for object.
  3. Default values are assigned (e.g., int = 0, String = null, etc.).
  4. Explicit initialization updates object fields.
- Key insight: Always read values from object memory, not from subsequent code lines (multi-threading considerations).

#### Differences Between Primitive and Reference Returns
- Primitive types: Value copy is returned.
- Reference types: Object reference copy is returned, not the object itself. Original object remains in heap and can be garbage collected later if no references remain.

```bash
# Example execution flow
Example.M1()  # Creates object, assigns values, displays (void)
Example.M2()  # Creates object, assigns values, returns reference
Student S3 = Example.M2()  # Reference stored in S3, object persists
```

### Code/Config Blocks
```java
class Student {
    int sn;
    String sname;
    String course;
    double fee;
}

class College {
    // Void method: creates and displays object
    static void M1() {
        Student S1 = new Student();
        S1.sn = 101;
        S1.sname = "HK";
        S1.course = "CJ";
        S1.fee = 1000.0;
        System.out.println(S1.sn + " " + S1.sname + " " + S1.course + " " + S1.fee);
    }
    
    // Non-void method: creates and returns object
    static Student M2() {
        Student S2 = new Student();
        S2.sn = 102;
        S2.sname = "BK";
        S2.course = "Acting";
        S2.fee = 2000.0;
        return S2;
    }
}

class Test {
    public static void main(String[] args) {
        College.M1();  // void call
        Student S3 = College.M2();  // reference return
        System.out.println(S3.sn + " " + S3.sname + " " + S3.course + " " + S3.fee);
    }
}
```

## Method Calling Ways

### Overview
Void methods can be called in one way, while non-void methods can be called in five ways to handle returned values or ignore them.

### Key Concepts/Deep Dive
- Void methods: Single call: `ClassName.methodName();`
- Non-void methods: Five ways:
  1. Assign to variable: `Student S3 = Example.M2();`
  2. Print directly: `System.out.println(Example.M2());` (prints reference)
  3. Other chains like passing as argument to another method.
- Crucial: Returned object reference is copied, not the object itself. Original object may become eligible for GC if no references remain.

## Program Execution and Memory Visualization

### Overview
Understanding JVM execution: Compilation (syntax check), runtime (memory allocation), and method flow returns.

### Key Concepts/Deep Dive
- Compilation phase: Verify declarations and constructors.
- Runtime phase: Allocate memory, initialize defaults, execute assignments.
- Method return: For references, only the address (e.g., 2010) is returned; the object stays in heap.
- Local variables/parameters destroyed after method completes, but objects are eligible for GC, not destroyed immediately.

## Non-Void Methods and Returning Objects

### Overview
Non-void methods must return values matching their declared return type, including object references.

### Key Concepts/Deep Dive
- Return statements copy primitive values or references, not objects.
- Garbage collection: Objects are marked eligible, not destroyed instantly.
- In calling method, store reference to access the object.

## Real-Time Examples: Student-College-University, Bike-Factory-Showroom

### Overview
Practical applications of methods returning objects in OOP scenarios.

### Key Concepts/Deep Dive
- **Student-College-University**: College "getStudent()" creates and returns Student object to University.
- **Bike-Factory-Showroom**: Factory manufactures bike via "getBike()", returns object; Showroom tests operations like start, move, stop.
- **Bike Class Fields/Methods**:
  - Fields: String brand, color; double price; int engineNo, chasisNo.
  - Methods: void start(), move(), stop() (void - output messages).
- Factory class creates Bike object, initializes, returns reference.
- Showroom calls Factory.getBike(), stores in Bike variable, calls methods.

### Code/Config Blocks
```java
class Bike {
    String brand, color;
    double price;
    int engineNo, chasisNo;
    
    void start() {
        System.out.println("Bike started");
    }
    
    void move() {
        System.out.println("Bike moving");
    }
    
    void stop() {
        System.out.println("Bike stopped");
    }
}

class Factory {
    static Bike getBike() {
        Bike B1 = new Bike();
        B1.brand = "Splendor";
        B1.color = "Black";
        B1.price = 50000.0;
        B1.engineNo = 12345;
        B1.chasisNo = 67890;
        return B1;
    }
}

class Showroom {
    public static void main(String[] args) {
        Factory baj = new Factory();  // Note: Create Factory instance if needed, but methods are static
        Bike bike = Factory.getBike();  // Static call
        bike.start();
        bike.move();
        bike.stop();
    }
}
```

## Parameterized vs Non-Parameterized Methods

### Overview
Parameterized methods take input from calling code via parameters; non-parameterized methods do not.

### Key Concepts/Deep Dive
- Parameterized: Accepts values via parameters (e.g., `static void add(int a, int b)`).
- Non-Parameterized: No parameters (e.g., `static void add()` with hardcoded values).
- Reusability: Parameterized methods are dynamic, reusable with different inputs.
- Rules for Parameters:
  - Format: DataType paramName, separated by commas.
  - No initialization in declaration.
  - Parameter names must be unique.

| Method Type | Parameters? | Calling Example | Reusable? |
|-------------|-------------|-----------------|-----------|
| Non-Parameterized | No | `Addition.add();` | No |
| Parameterized | Yes | `Addition.add(10, 20);` | Yes |

### Code/Config Blocks
```bash
# Bash commands for compilation (if needed)
javac Addition.java
java Addition
```

```java
class Addition {
    static void add(int a, int b) {  // Parameterized
        int c = a + b;
        System.out.println(c);
    }
}

class Calculator {
    public static void main(String[] args) {
        Addition.add(10, 20);  // Outputs 30
        Addition.add(50, 60);  // Outputs 110
    }
}
```

## Method Rules and Argument Passing

### Overview
Strict rules for defining and calling parameterized methods.

### Key Concepts/Deep Dive
- Calling Parameterized Methods:
  - Must pass arguments matching number, type, order of parameters.
  - Compatible types: Same or lesser types (e.g., int for int).
- Calling Non-Parameterized Methods: Cannot pass arguments (compiler error).
- Definition Rules: Separate by comma, no assignment (=) in parameters.

## Object Passing as Arguments and Modifications

### Overview
When objects are passed as arguments, reference copies are made; modifications inside methods affect the original object.

### Key Concepts/Deep Dive
- Reference Passing: Parameter holds copy of object address, pointing to same memory.
- Modifications: Changes to object fields via parameter persist after method ends.
- Memory: Original reference from caller can access modified object post-return.

```java
static void M1(Employee E) {
    // Modifications here affect caller's object
    E.salary *= 1.20;  // 20% increase
}
```

## Employee Project Example

### Overview
Develop three methods: display employee details, display annual salary, increase salary by 20%.

### Key Concepts/Deep Dive
- Three Methods:
  1. Receive Employee object, display values.
  2. Receive Employee object, display annual salary (salary * 12).
  3. Receive Employee object, increase salary by 20%, modification affects caller.
- Object Passing: Reference copied, modifications shared.

### Code/Config Blocks
```java
class Employee {
    int no;
    String name;
    double salary;
}

class Company {
    static void display(Employee E) {
        System.out.println(E.no + " " + E.name + " " + E.salary);
    }
    
    static void annualSalary(Employee E) {
        System.out.println(E.salary * 12);
    }
    
    static void increaseSalary(Employee E) {
        E.salary *= 1.20;  // Original object modified
    }
}

class Test {
    public static void main(String[] args) {
        Employee E1 = new Employee();
        E1.no = 1;
        E1.name = "John";
        E1.salary = 10000;
        
        Company.display(E1);
        Company.annualSalary(E1);
        Company.increaseSalary(E1);
        Company.display(E1);  // Modified salary visible
    }
}
```

## Summary

### Key Takeaways
- Void methods: Create/display objects; called once.
- Non-void methods: Return object references; called in 5 ways.
- Reference returns: Object address copied, not object itself.
- Parameterized methods: Accept inputs for reusability; strict rules.
- Object arguments: Modifications affect original object.

### Expert Insight

**Real-world Application**: Object-returning methods simulate supply chains (e.g., Factory-Showroom). Use in factories for object creation and validation in Showrooms.

**Expert Path**: Practice memory diagrams; implement custom toString() in classes for better printing. Study deep copies vs shallow copies for object cloning.

**Common Pitfalls**: 
- Forgetting null checks when accessing object fields (potential NPE).
- Misunderstanding GC: Objects eligible but not destroyed immediately.
- Parameter issues: Passing wrong type/order causes compile errors.
- Visualizing multi-threading: Reads from memory diagram prevent stale values.

**Lesser known things**: In Java, method references (added in Java 8) allow functional programming; e.g., returning methods as objects for lambdas. Always prefer immutable objects when sharing between threads to avoid race conditions.
