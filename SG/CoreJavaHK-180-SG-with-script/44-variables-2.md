# Session 44: Variables 2

## Table of Contents

- [Review of Previous Class](#review-of-previous-class)
- [The Problem with Arrays](#the-problem-with-arrays)
- [Solution: Introduction to Classes](#solution-introduction-to-classes)
- [Primitive vs Reference Data Types](#primitive-vs-reference-data-types)
- [Creating User-Defined Data Types (Classes)](#creating-user-defined-data-types-classes)
- [Declaring Variables in Classes](#declaring-variables-in-classes)
- [Memory Allocation for Class Members](#memory-allocation-for-class-members)
- [Creating Reference Variables and Objects](#creating-reference-variables-and-objects)
- [Syntax for Class Instantiation](#syntax-for-class-instantiation)
- [Accessing Class Members](#accessing-class-members)
- [Memory Diagram for Class Objects](#memory-diagram-for-class-objects)
- [Practical Demonstration](#practical-demonstration)
- [Multiple Classes in a Single File](#multiple-classes-in-a-single-file)
- [Real-World Examples](#real-world-examples)
- [Conclusion: Object-Oriented Programming Basics](#conclusion-object-oriented-programming-basics)

## Review of Previous Class

### Overview
Previous sessions covered data types, including primitive data types for creating single variables and reference data types for creating arrays and objects. Key concepts included limitations of variables, the need for arrays to store multiple homogeneous values, array memory diagrams, and how to read/write values in arrays.

### Key Concepts/Deep Dive
- **Primitive Data Types**: Predefined types (e.g., `int`, `double`) for storing single values directly in memory.
- **Reference Data Types**: Arrays for multiple same-type values, each element accessible via index.
- **Array Creation**: Variable creation (`int[] arr = new int[size];`), object creation allocates contiguous memory blocks.
- **Array Access**: Use square brackets for reading/writing (e.g., `arr[0] = 5; int value = arr[0];`).
- Arrays provide structured storage but limit flexibility for mixed data types.

✅ **Key Insight**: Arrays group homogeneous data efficiently but cannot mix types like `int` with `boolean`.

## The Problem with Arrays

### Overview
Arrays solve storing multiple values of the same type but fail when different types need storage (e.g., name as `String` and age as `int`). This limitation requires mixing incompatible elements.

### Key Concepts/Deep Dive
- **Array Homogeneity**: Arrays enforce same data type for all elements (e.g., `int[]` only stores `int` values).
- **Incompatibility Issue**: Attempting mixed types compiles as errors.
  ```java
  int[] arr = {5, true, 3.14}; // Compilation error: incompatible types
  ```
- **Consequence**: No way to represent complex entities (e.g., a student with name, age, and fees) using arrays alone.
- Arrays are predefined and lack customization for heterogeneous data.

💡 **Real-World Analogy**: Storing apples and oranges separately works, but mixing them in one basket fails.

## Solution: Introduction to Classes

### Overview
To store multiple values of different types, use classes as user-defined data types. Classes allow custom structures similar to how Sun Microsystems provides primitives but lets developers define complex types.

### Key Concepts/Deep Dive
- **User-Defined Data Types**: Classes provide flexibility unmet by primitives and arrays.
- **Syntax Basics**: Class keyword defines a blueprint for custom data types.
  ```java
  class Example {
      // Variables for different types
  }
  ```
- **Grouping Heterogeneous Data**: Combine `int`, `double`, `String`, even arrays/objects in one structure.
- **Memory Evolution**: Classes extend primitive variables to complex object storage.

> [!NOTE]  
> Primitives are fixed-form gifts; classes are customizable blueprints.

## Primitive vs Reference Data Types

### Overview
Primitive data types (predefined) handle single values directly, while reference data types (predefined for arrays, user-defined for classes) handle complex structures with indirect memory access.

### Key Concepts/Deep Dive
- **Primitives**: Common to all, store values directly (e.g., `int` for math calculations, `char` for symbols).
- **References**: Pointer-based, create variables (references) and objects (value containers).
- **Class Distinction**: Not common to all projects; developers design based on needs (e.g., `Employee` class for company-specific attributes).
- **Simile**: Primitives are personal stationery; classes are custom-built workstations.

### Tables
| Data Type Category | Predefined? | Stores Single/Multiple? | Stores Homogeneous/Heterogeneous? |
|--------------------|-------------|--------------------------|-----------------------------------|
| Primitives         | Yes         | Single                  | Single type (implicit)           |
| Arrays             | Yes         | Multiple                | Homogeneous                       |
| Classes            | No (user)   | Multiple                | Heterogeneous                     |

> [!IMPORTANT]  
> Classes are the solution for real-world objects requiring mixed data.

## Creating User-Defined Data Types (Classes)

### Overview
Classes act as templates for creating custom data types. Define variables inside classes to represent attributes of real-world entities.

### Key Concepts/Deep Dive
- **Class Syntax**: 
  ```java
  class ClassName {
      DataType variableName;
      // Additional variables
  }
  ```
- **Class Benefits**: Path to object-oriented programming, combining related attributes.
- **Name Convention**: Class names use PascalCase (e.g., `StudentDetails`).

> [!TIP]  
> Class creation doesn't allocate memory; use `new` for runtime allocation.

## Declaring Variables in Classes

### Overview
Within classes, declare variables of any type (primitive, reference, array) to model attributes. Values are assigned during instantiation.

### Key Concepts/Deep Dive
- **Variable Declaration**: Define inside class body for the data type.
  ```java
  class Example {
      int i1;
      double d1;
      char ch;
      long[] la;
      String s1;
  }
  ```
- **Data Type Flexibility**: Mix primitives, arrays, and strings seamlessly.
- **No Values at Declaration**: Unlike arrays, initialize via object creation to avoid one-size-fits-all issues.

⚠️ **Warning**: Initiating default values in class declarations limits reusability for multiple objects.

## Memory Allocation for Class Members

### Overview
Class declarations are blueprints; memory allocates only via `new` (group allocation) or `static` (individual copies).

### Key Concepts/Deep Dive
- **Static Allocation**: Creates individual memory copies per variable.
  ```java
  static int i1;
  static double d1;
  // Creates separate memory per variable
  ```
- **New Allocation**: Groups all non-static variables into contiguous memory blocks.
- **Default Values**: Automatic initialization (e.g., 0 for numeric, null for references).

✅ **Visualization**: `new` packs variables into a "bag" for easy transport.

## Creating Reference Variables and Objects

### Overview
For access post-creation, assign objects to reference variables. This creates a handle to stored values.

### Key Concepts/Deep Dive
- **Reference Variable**: Holds a pointer to object memory.
  ```java
  Example e1;  // Reference variable creation
  ```
- **Object Creation**: Allocates actual memory using `new`.
  ```java
  e1 = new Example();  // Object instantiation
  ```
- **Single Name Access**: Groups heterogeneous values under one reference.

> [!EXAMPLE]  
> `Example e1 = new Example();` creates a "har" memory container.

## Syntax for Class Instantiation

### Overview
Object creation follows `<ClassName> <variable> = new <ClassName>();` to instantiate and reference.

### Key Concepts/Deep Dive
- **Two-Step Process**: Variable declaration, then assignment.
  ```java
  Example e1;      // Step 1: Reference declaration
  e1 = new Example(); // Step 2: Object creation
  ```
- **Method Placement**: Instantiate inside `main()` for execution.
- **Bad Practice**: Instantiation inside class might cause issues; separate executable classes preferred.

> [!SECURITY]  
> Avoid intra-class instantiation; promotes better separation.

## Accessing Class Members

### Overview
Access values via dot operator (`.`) unlike arrays' square brackets (`[]`).

### Key Concepts/Deep Dive
- **Dot Notation**: Arrow representation for object members.
  ```java
  int value = e1.i1;
  e1.d1 = 6.7;
  ```
- **Array-Member Differentiation**: Dot for class members, brackets for array elements.
  ```java
  e1.la[0] = 8;  // Access array inside class object
  String name = e1.s1;  // Direct access for strings
  ```

### Diff Usage
```diff
+ Primitive/Objects: e1.i1 - Dot separates reference from member
- Arrays: arr[0] - Brackets index elements
```

## Memory Diagram for Class Objects

### Overview
Classes create two memories: reference variable (4 bytes) and object (variable-dependent size, minimum 8 bytes + values).

### Key Concepts/Deep Dive
- **Reference Memory**: Numeric pointer (e.g., 4 bytes for `int` storage).
- **Object Memory**: Heap-allocated contiguous block for all non-static variables.
- **Size Calculation**: Base object info + variables (e.g., 26 bytes: 4 for `int` + 8 for `double` + 2 for `char` + 4 for reference + 4 for reference + 4 for object overhead).
- **Nested References**: Arrays/strings create sub-objects (e.g., long array at offset address).

```mermaid
graph TD
    A[Reference Variable: Example e1] -->|Points to| B[Object Memory]
    B --> C[int i1: 5]
    B --> D[double d1: 6.7]
    B --> E[char ch: 'a']
    B --> F[long[] la -> Sub-Object]
    F --> G[la[0]: 8]
    F --> H[la[1]: 9]
    B --> I[String s1 -> Sub-Object]
    I --> J[s1 (implicit array): 'h','a','r','i']
```

### Code/Config Blocks
Memory allocation trace:
- Compiler: Verifies classes, links definitions.
- JVM: Executes `new Example()`, allocates heap memory for all variables.

## Practical Demonstration

### Overview
Demonstration shows class creation, instantiation, and value access with console output.

### Key Concepts/Deep Dive
- **Example Class**:
  ```java
  class Example {
      int i1 = 5;
      double d1 = 6.7;
      char ch = 'a';
      long[] la = {8, 9};
      String s1 = "hari";
  }
  ```
- **Accessing Values**:
  ```java
  public class Test {
      public static void main(String[] args) {
          Example e1 = new Example();
          System.out.println(e1.i1);  // Output: 5
          System.out.println(e1.d1);  // Output: 6.7
          System.out.println(e1.ch);   // Output: a
          System.out.println(e1.la[0]); // Array access: 8
          System.out.println(e1.sa);   // Direct string: hari
      }
  }
  ```
- **Full Array Output**: Use `Arrays.toString(e1.la)` for `[8, 9]`.

⚠️ **Common Pitfall**: Accessing reference directly shows hex (e.g., `[J@1a2b3c`), not values.

## Multiple Classes in a Single File

### Overview
Single Java files can contain multiple classes; however, namespace within contexts (e.g., main in executable class).

### Key Concepts/Deep Dive
- **Flexibility**: Define multiple user-defined types in one file.
- **Execution**: One public class with `main()` triggers execution.
- **Practice Note**: Separate files for modularity, but single-file for simplicity.

## Real-World Examples

### Overview
Apply classes to real-world objects like students or employees for structured data storage.

### Key Concepts/Deep Dive
- **Student Example**:
  ```java
  class Student {
      int rollNo;
      String name;
      String course;
      double fee;
  }
  
  // In Main Class:
  Student s1 = new Student(); // Represents "Hari"
  s1.rollNo = 101;
  // ... similar assignments
  // For multiple students: s2 = new Student(); etc.
  ```
- **Business Projection**: One class per entity type (e.g., `Student`, `Employee`), multiple objects for data.
- **Dynamic Allocation**: Instantiate based on runtime data (e.g., from forms).

💡 **Pro Tip**: Class variables become object attributes; objects represent real entities.

## Conclusion: Object-Oriented Programming Basics

### Overview
Object-oriented programming centers on classes for modeling real-world entities with heterogeneous attributes via grouped memory access.

### Key Concepts/Deep Dive
- **OOP Fundamentals**: Classes create blueprints; objects instantiate specific instances.
- **Memory Visualization**: Essential for mastering Java development.
- **Evolution Path**: Primitives → Arrays → Classes → Full OOP.
- **Mindset Shift**: Think in terms of objects grouping related data, mirroring real-world interactions.

### Diff Usage
```diff
+ One Value: Primitive Variable (e.g., int a = 10;)
- One Object Type: Reference Variable (e.g., Student s = new Student();)
+ Multiple Same-Type Values: Array Object (e.g., int[] arr = new int[5];)
- Multiple Different-Type Values: Class Object (e.g., Student s = new Student();)
```

## Summary

### Key Takeaways
```diff
+ Primitive data types are predefined and store single values directly.
+ Arrays store multiple values of the same type using index access.
- Arrays cannot mix different data types, requiring classes for heterogeneous storage.
+ Classes are user-defined data types enabling custom attribute combinations.
+ Use dot notation to access class members, differing from array square brackets.
+ Reference variables store object addresses; objects contain actual data in heap memory.
+ Memory allocation happens via `new` keyword, grouping class variables contiguously.
+ Classes enable object-oriented modelling of real-world entities like students or employees.
+ Visualization of memory diagrams is critical for understanding JVM behavior.
```

### Expert Insight

#### Real-world Application
In production, classes form the backbone of Java applications—use them for entities like `User`, `Order`, or `Product` in e-commerce. Instantiate objects from user inputs (e.g., web forms) and persist via databases. Scale by creating object collections (Lists) for dynamic data handling.

#### Expert Path
Master memory visualization by sketching diagrams for every code change. Progress to inheritance (extending classes), encapsulation (access modifiers), and design patterns. Practice with frameworks like Spring Boot, where classes represent domain models.

#### Common Pitfalls
- Forgetting `new` leads to compilation errors or null pointer exceptions.
- Misusing dot vs square brackets causes syntax issues.
- Declaring values inside class limits reusability for multiple objects.
- Not visualizing memory results in debugging confusion—sketch diagrams proactively.
- Errors: Transcript corrections - "ript" removed as transcription artifact; "usen" corrected to "using"; "datatypes" standardized to "data types"; "bele" clarified as "I'll"; grammatical inconsistencies (e.g., "is's" to "he's", "is not stopping" to "doesn't stop") adjusted for clarity. No major technical misspellings noted beyond transcription noise.
