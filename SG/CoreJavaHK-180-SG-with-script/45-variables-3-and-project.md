# Session 45: Variables 3 and Project

- [Overview of the Session](#overview-of-the-session)
- [Understanding Classes, Objects, and Instances](#understanding-classes-objects-and-instances)
- [Creating Projects with Data Types](#creating-projects-with-data-types)
- [Developing a Student Management Project](#developing-a-student-management-project)
- [Developing an Employee Management Project](#developing-an-employee-management-project)
- [Using Packages in Projects](#using-packages-in-projects)
- [Compiling and Running Packaged Projects](#compiling-and-running-packaged-projects)
- [Transition to Runtime Values](#transition-to-runtime-values)
- [Summary](#summary)

## Overview of the Session

This session builds on previous knowledge of data types by focusing on how to use data types in real-time project development. It emphasizes creating classes to represent real-world objects, instantiating objects, initializing them with values, and displaying those values. The session includes project-based case studies, demonstrating the creation of mini-projects for student and employee management systems. Key concepts include differentiating between classes, instances, and objects, using packages for organizing code, and the limitations of hardcoded values leading into dynamic input.

## Understanding Classes, Objects, and Instances

### Overview
Understanding the relationships between classes, objects, and instances is foundational to object-oriented programming in Java. A class acts as a blueprint for creating objects, which represent real-world entities. An instance is a specific memory allocation for an object.

### Key Concepts/Deep Dive
- **Class**: A user-defined data type that can store multiple values of different types for representing groups of objects. It is also termed a blueprint, specification, template, design document, or logical construct. Properties and operations of objects are defined in a class.
- **Instance**: A single copy of memory created from a class. It starts as uninitialized memory and becomes an object when populated with specific values.
- **Object**: A real-world entity (e.g., "HK" or "BK") that exists as an instance in programming. An object is an instance of a class, combining the blueprint with actual data.
- **Initialization**: Storing values into an instance memory to transform it into a specific object. Before initialization, it is just an instance; after, it represents a particular object.
- **Visualization**: Real-world objects (left side) are mirrored in the programming world (right side) as instances. Diagrams should show memory allocation for clarity.

| Term | Definition |
|------|------------|
| Class | User-defined data type; blueprint for objects. |
| Instance | Memory copy from a class; not yet an object. |
| Object | Initialized instance representing a real-world entity. |

Code Example: Basic Instance Creation

```java
class Student {
    int sn;
    String sName;
    String course;
    double fee;
}

// In main class
Student s1 = new Student();  // Instance created, but still memory
s1.sn = 101;
s1.sName = "HK";
s1.course = "Core Java";
s1.fee = 2500.0;  // Now it's an object representing HK
```

Pre-initialization, `s1` is an instance. Post-initialization, it is an object for "HK".

### Lab Demo: Illustrating Instances and Objects
1. Create a class `Student` with variables: `int sn`, `String sName`, `String course`, `double fee`.
2. In a main class (e.g., `Test`), create two instances: `Student s1 = new Student(); Student s2 = new Student();`
3. Display messages: "Instance one is created for HK object", "Instance two is created for BK object".
4. Initialize `s1` with HK values and `s2` with BK values.
5. Use `System.out.println` to display each object's details, e.g., `S1 object values: " + s1.sn + " " + s1.sName + ...`
6. Run the program: Output shows initialized values, confirming object creation.
7. Expected Output: Messages indicating instances, then specific object values like `S1 object: 101 HK Core Java 2500.0`

## Creating Projects with Data Types

### Overview
This section transitions data type knowledge into practical project development, focusing on creating classes that use data types to store multiple real-world object values.

### Key Concepts/Deep Dive
- **Project Structure**: Identify objects (e.g., students, employees), create a class per object type with variables matching data types, then instantiate and initialize objects in a main class.
- **Real-Time Usage**: Data types enable storing varied values (e.g., ints for IDs, Strings for names, doubles for fees/salaries). Projects involve one class for data (POJO/beans) and one for execution (main method class).
- **Separating Concerns**: Data classes are reusable and avoid hardcoding; execution classes handle object creation and display.
- **Non-Hardcoded Approach**: Objects should be initialized dynamically, not with fixed values, to allow flexibility.

Tables are not directly applicable here, as the focus is on conceptual development.

### Lab Demo: Basic Student Object Creation
1. Create class `Student` with variables: `int sn; String sName; String course; double fee;`
2. Create main class `Test` with `main` method.
3. In `Test`, create instances `Student s1 = new Student(); Student s2 = new Student();`
4. Initialize with example values (e.g., HK and BK details).
5. Display values using `System.out.println`.
6. Compile and run: Verify values are stored and printed correctly.
7. Output: HK's details followed by BK's details, demonstrating data type usage in objects.

## Developing a Student Management Project

### Overview
The session introduces a student management project using folders for organization. It reinforces creating data classes, instances, and objects.

### Key Concepts/Deep Dive
- **Project Organization**: Use separate folders (e.g., `Project01`) for related classes to keep code modular.
- **Class Creation**: Define a student class with relevant variables; create a college/main class for object handling.
- **Instance vs. Object**: Emphasize that `new Student()` creates an instance, not an object, until initialized.
- **Display**: Use `System.out.println` to show object values, akin to generating an "ID card".

```bash
# Create project folder structure
mkdir Project01
cd Project01
```

### Lab Demo: Student College Project
1. Create folder `Project01`.
2. In `Project01`, create `Student.java`: 
   ```java
   class Student {
       int sn;
       String sName;
       String course;
       double fee;
   }
   ```
3. Create `College.java` with main method: `public class College { public static void main(String[] args) { ... } }`
4. Inside `main`: Create instances `Student s1 = new Student(); Student s2 = new Student();`
5. Initialize `s1` with HK values, `s2` with BK values.
6. Display: `System.out.println("S1 object values: " + s1.sn + " " + s1.sName + " " + s1.course + " " + s1.fee);`
7. Similarly for `s2`.
8. Compile: `javac *.java`
9. Run: `java College`
10. Expected Output: Values for HK and BK objects.
11. Notes: Values are hardcoded here; will transition to dynamic input later.

## Developing an Employee Management Project

### Overview
This extends project development to employee management, including package usage and initial exposure to Amir vs. Hightech City styles.

### Key Concepts/Deep Dive
- **Similar Structure**: Employee class mirrors Student, with variables like `int eno; String eName; double salary; String department;`
- **Package Styles**: Amir style (manual compilation without automation) vs. Hightech City style (IDE automation).
- **Copy-Paste Development**: Code patterns repeat across projects; focus on changing names and values.
- **Life Cycle Analogy**: Objects as entities transitioning through states (e.g., student to employee).

### Lab Demo: Employee Project with Packages
1. Create classes similar to Student, but for `Employee` with variables: `int eno; String eName; double salary; String department;`
2. Use packages: `package com.nit.hk.pojo;` for Employee, `package com.nit.hk.user;` for Company.
3. Create `Employee.java` in pojo package, `Company.java` in user package.
4. In `Company.java`, create instances `Employee e1 = new Employee(); Employee e2 = new Employee();`
5. Initialize with example employee values (e.g., HK and BK).
6. Display values.
7. Add import: `import com.nit.hk.pojo.Employee;`
8. This sets foundation for packaged projects.

## Using Packages in Projects

### Overview
Packages organize code, preventing naming conflicts and enabling modular development. Public methods/properties allow access across packages.

### Key Concepts/Deep Dive
- **Package Declaration**: Use `package` keyword at top of files to categorize classes.
- **Access Modifiers**: Classes and properties must be `public` for inter-package use; add imports.
- **Benefits**: Reusability and structure in real projects.
- **Compilation**: Create package folders (e.g., `com/nit/hk/pojo/`) and compile each class separately.

### Code/Config Blocks
```java
package com.nit.hk.pojo;
public class Employee {
    public int eno;
    public String eName;
    public double salary;
    public String department;
}
```

```java
package com.nit.hk.user;
import com.nit.hk.pojo.Employee;
public class Company {
    public static void main(String[] args) {
        Employee e1 = new Employee();
        // Initialization and display
    }
}
```

## Compiling and Running Packaged Projects

### Overview
Packaging requires manual compilation of each class, creating package directories, and using fully qualified names for execution.

### Key Concepts/Deep Dive
- **Compilation Steps**: Compile from project root; use fully qualified names initially.
- **Class Path**: Ensure classes are in correct package folders.
- **Execution**: Run with package-qualified class name.
- **Executable Jars**: For deployment, create JARs using `jar` command.

### Lab Demo: Compiling and Running Employee Project
1. Structure folders: `Project02/com/nit/hk/pojo/Employee.java` and `Project02/com/nit/hk/user/Company.java`
2. Compile: `javac com/nit/hk/pojo/Employee.java` then `javac -cp . com/nit/hk/user/Company.java`
3. Execute: `java com.nit.hk.user.Company`
4. Expected Output: Employee details displayed.
5. Alternative: Use `CLASSPATH` or create bat files for repetitive tasks.

## Transition to Runtime Values

### Overview
The session ends by contrasting hardcoded (static) values with runtime (dynamic) values, setting up the next chapter on reading input from users.

### Key Concepts/Deep Dive
- **Hardcoded Applications**: Values fixed in code; program always uses same data, requiring recompilation for changes.
- **Runtime Applications**: Values read at execution time; more flexible and secure.
- **Benefits of Runtime**: No need to modify code; values are per-user and discarded after execution.
- **Limitations Addressed**: Hardcoded apps risk values persisting across runs; runtime prevents data mixing.

Tables: Comparison

| Aspect | Hardcoded | Runtime |
|--------|-----------|---------|
| Flexibility | None; fixed values | High; user input |
| Recompilation | Required for changes | Not required |
| Security | Poor; values may persist | Good; values destroyed |

### Code Contrast
Hardcoded:
```java
int a = 10;
int b = 20;
System.out.println(a + b);
```

Runtime (preview): Use Scanner for input.

> The next chapter will cover full implementation.

## Summary

```diff
+ Real-world objects are created via instances from classes, initialized with data.
+ Classes serve as blueprints with variables for data storage.
+ Projects involve POJO classes (data) and user classes (main logic).
+ Packaging organizes code but requires public access and imports.
+ Compilation: javac for individual classes; execution with full package names.
+ Avoid hardcoded values for scalability; prefer runtime input.
+ Instances become objects only after initialization with specific values.
```

### Real-World Application
In enterprise software (e.g., HR systems), classes like `Employee` model database entities. Objects represent individual records (e.g., an employee's profile), instantiated and populated with user-entered data via forms. Packaging ensures modular maintenance, while runtime input via APIs allows dynamic updates without code changes.

### Expert Path
Master OOP by building layered architectures: Separate data (models), business logic (services), and UI (controllers). Practice dependency injection and design patterns like Singleton for object management. Transition to frameworks like Spring for real-time data handling.

### Common Pitfalls
- Confusing instances with objects: Initialize immediately after `new`.
- Forgetting public modifiers in packaged classes: Leads to access errors.
- Hardcoding values: Makes apps inflexible; always aim for user input. Resolution: Implement reading from console early.
- Compilation errors in packages: Use correct paths and classpath. Resolution: Verify directory structure.
### Lesser Known Things
Objects in Java can be serialized for persistence; understanding memory allocation via `new` reveals heap vs. stack usage. Packages mirror package-private access, useful for internal APIs. OOP life cycles mirror real-world processes (e.g., student to employee), aiding problem modeling. Dynamic values prevent stateful bugs, a key in multi-threaded apps.
