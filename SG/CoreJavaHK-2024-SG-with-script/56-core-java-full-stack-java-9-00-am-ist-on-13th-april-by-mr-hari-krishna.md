# Session 56: Core Java - Constructors

## Table of Contents
- [Overview](#overview)
- [Key Concepts](#key-concepts)
- [Deep Dive](#deep-dive)
- [Code Examples](#code-examples)
- [Lab Demo](#lab-demo)

## Overview
This session focuses on Java constructors, which are special methods used to initialize objects at the time of creation. Constructors serve as initializers, setting up object state before any other operations. Unlike setter methods that modify fields after object creation, constructors ensure mandatory initialization during instantiation. Key emphasis is placed on encapsulation, object lifecycle, and proper coding practices for real-world applications.

## Key Concepts
- **Constructor Definition**: A special method with the same name as the class, no return type, used to initialize objects during creation.
- **Purpose**: Initializes fields at object creation time, unlike setters which work post-creation.
- **Syntax**: Access modifier + ClassName(parameters) { initialization logic }
- **Types**: Default (implicit) and parameterized constructors.
- **Object Creation Flow**: `new ClassName()` invokes constructor via JVM for initialization.

## Deep Dive

### Setter and Getter Methods Recap
- **Setter Method**: A method whose name starts with "set" followed by field name (first letter capitalized). Used for setting or modifying private field values in the current object.
  - Syntax example: `public void setName(String name) { this.name = name; }`
  - Purpose: Encapsulate field access, allowing controlled modification.
- **Getter Method**: A method whose name starts with "get" followed by field name (first letter capitalized). Used for retrieving private field values.
  - For boolean fields, use "is" prefix (e.g., `isActive()`).
  - Purpose: Provide controlled access to read field values, enabling validation, calculation, or display.
- **Execution Flow**:
  - Setter: Passes current object reference + arguments, updates field based on logic.
  - Getter: Passes current object reference, returns field value based on logic.
- **Variable Shadowing**: Inside setter, use `this.` to modify field; compiler adds it for getters if no local variable shadows.

### Need for Constructors
- **Post-Creation vs. During Creation**: Setters initialize/modify after object creation (e.g., stretching room dimensions). Constructors initialize during creation (e.g., mandatory dimensions like student number, name, course during admission).
- **Real-World Examples**:
  1. Bank Account: Account number, holder name, balance must be set at opening; cannot open account without these.
  2. Student Admission: Course, name decided at admission, not after.
  3. Facebook/Instagram Account: Username, email, password required at registration.
- **Requirements Analysis**: Classes often have mandatory fields (initialized via constructor) and optional fields (modified via setters post-creation).

### Constructor Fundamentals
| Aspect | Description |
|--------|-------------|
| Definition | A kind of method with class name, no return type. |
| Use | Initializes object created by `new` keyword. Initializes, not constructs object. |
| Invocation | Automatic when using `new ClassName()`. |
| Implicit vs. Explicit | Compiler generates default constructor if none defined. Developer can create parameterized ones. |

- **Syntax Details**:
  - Accessibility: public/private/protected/default (default allows package access).
  - Execution Modifiers: Not allowed (execution not controllable).
  - Return Type: Not allowed (makes it a method, not constructor).
  - Parameters: Allowed for passing initialization values.
  - Throws: Allowed for exception handling during initialization.
  - Logic: Initialization code (validation, calculation, storing to fields).

### Object Creation and Construction Flow
- **Statement Breakdown**: `Room r1 = new Room();`
  - `new`: Creates empty object in heap.
  - `Room()`: Calls constructor to initialize.
  - Flow: "new Room()" creates object; constructor fills fields.
- **JVM Perspective**: Constructor receives object reference (`this`), initializes fields.
- **Implicit Constructor**: If none defined, compiler generates `public ClassName() {}` with default values (e.g., 0 for numbers, null for references).

> **NOTE**: Constructor name matches class name. Omitting constructor leads to implicit generation.

## Code Examples

### Basic Constructor Example
```java
public class Room {
    private double length;
    private double breadth;
    
    // Parameterized constructor (explicit)
    public Room(double length, double breadth) {
        this.length = length;
        this.breadth = breadth;
    }
    
    // Default constructor (implicit if not defined: public Room() {})
    
    // Setters/Getters/Business Methods
    public void setLength(double length) { this.length = length; }
    public double getLength() { return this.length; }
    public void setBreadth(double breadth) { this.breadth = breadth; }
    public double getBreadth() { return this.breadth; }
    public double findArea() { return this.length * this.breadth; }
    public void display() { System.out.println(this.length + " " + this.breadth); }
}
```

### Usage in Main Class (Building)
```java
public class Building {
    public static void main(String[] args) {
        Room r1 = new Room(700, 100);  // Constructor initializes
        r1.display();  // Output: 700.0 100.0
        double area = r1.findArea();  // Output: 70000.0
        System.out.println(area);
    }
}
```

> **IMPORTANT**: Access modifiers on constructors control instantiation (private prevents external creation).

## Lab Demo
**Objective**: Develop a `Room` class with constructors, setters, getters, business methods, and demonstrate object creation flow.

1. **Create Class Structure**:
   ```
   public class Room {
       private double L, B;
       
       // Implicit default constructor generated by compiler
       // Parameterized constructor (optional, for initialization at creation)
       public Room(double L, double B) {
           this.L = L;
           this.B = B;
       }
       
       // Setters
       public void setL(double L) { this.L = L; }
       public double getL() { return this.L; }
       public void setB(double B) { this.B = B; }
       public double getB() { return this.B; }
       
       // Business Methods
       public double findArea() { return this.L * this.B; }
       public double findPerimeter() { return 2 * (this.L + this.B); }
       
       // Display
       public void display() { System.out.println(this.L + " " + this.B); }
   }
   ```

2. **Main Class and Execution**:
   ```
   public class Building {
       public static void main(String[] args) {
           Room r1 = new Room();  // Default constructor (implicit)
           r1.display();  // Output: 0.0 0.0
           r1.setL(700); r1.setB(100);
           r1.display();  // Output: 700.0 100.0
           System.out.println(r1.findArea());  // Output: 70000.0
       }
   }
   ```

3. **Compile and Run**:
   - `javac Room.java Building.java`
   - `java Building`
   - Observe output: Demonstrates post-creation initialization via setters.

4. **Flow Explanation**:
   - `new Room()`: JVM allocates memory, calls implicit constructor.
   - Setters modify post-creation.
   - Business methods use current object state.

## Summary

### Key Takeaways
```diff
+ Constructors initialize objects at creation time (e.g., new ClassName()), unlike setters (post-creation)
+ Compiler generates implicit default constructor if none defined
+ Constructor name matches class name, no return type; used for mandatory field setup
- Avoid placing modifiable logic in constructors; keep for initialization
+ Encapsulation: Private fields, controlled access via constructors/setters/getters
! Common Pitfall: For boolean fields, getter must use "is" prefix, not "get"
```

### Expert Insight

**Real-world Application**: In enterprise apps, constructors ensure data integrity—e.g., BankAccount constructor validates minimum balance. Use parameterized constructors for required fields, default constructors for optional setups.

**Expert Path**: Master constructor chaining (`this()` for overloading) and factory patterns. Analyze bytecode with `javap` to understand implicit additions. Practice object creation flow diagrams to debug initialization issues.

**Common Pitfalls**: 
- Omitting `this.` in constructor for shadowing (value stays in parameter, not field).
- Using setters inappropriately for required initialization (leads to invalid objects).
- Resolution: Always validate parameters in constructor; use assertions/logs for debugging.
- Lesser Known: Constructors cannot be `final` or `static`; implicit constructor initializes to defaults (0/null). Use `instanceof` checks in constructors for advanced validation.
