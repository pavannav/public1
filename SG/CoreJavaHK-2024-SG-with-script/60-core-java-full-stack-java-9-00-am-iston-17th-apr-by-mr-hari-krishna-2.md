# Session 60: Core Java & Full Stack Java

## Table of Contents
- [Motivational Talk and Responsibilities](#motivational-talk-and-responsibilities)
- [Revision of Core OOP Concepts](#revision-of-core-oop-concepts)
- [Understanding Static Blocks](#understanding-static-blocks)
- [Execution Flow of Static Blocks](#execution-flow-of-static-blocks)
- [Practical Examples and Variable Initialization](#practical-examples-and-variable-initialization)
- [Dynamic Initialization in Static Blocks](#dynamic-initialization-in-static-blocks)
- [Multiple Static Blocks and Rules](#multiple-static-blocks-and-rules)

## Motivational Talk and Responsibilities
### Overview
This session begins with an extensive motivational talk emphasizing personal responsibility, faith in action rather than prayer, the importance of mutual success in teacher-student relationships, and broader life advice including career planning, marriage ages (girls 23-25, boys 28), balancing work and personal life, and environmental responsibility. It transitions into reinforcing Java concepts, specifically focusing on static blocks as a means to execute initialization logic during class loading.

### Key Concepts/Deep Dive
- **Faith in Action**: Success comes from effort, not prayer; mutual accountability builds stronger relationships.
- **Career and Life Planning**:
  - Boys: Focus on career stability by 28 years before marriage to avoid future regrets.
  - Girls: Aim for marriage by 23-25 years after securing independence.
  - Balance professional and personal life; avoid carrying job stress home.
- **Social Responsibility**: Promote water and power conservation, support water harvesting, and contribute positively to society as a responsible citizen.
- **Job Hunting Mindset**: Visualize multiple opportunities beyond software engineering; start earning through any legitimate means while aiming for Java-based roles.
- **Environmental Awareness**: Construct homes with water harvesting systems to preserve groundwater levels for future generations.

### Code/Config Blocks
No code blocks in this section; focuses on life advice and motivation.

### Lab Demos
No practical demos in this introductory talk.

## Revision of Core OOP Concepts
### Overview
The session revises fundamental OOP principles, including class design, objects, instances, blocks, and their roles in creating real-world representations in Java.

### Key Concepts/Deep Dive
- **Class as Blueprint**: A class is a user-defined data type and blueprint from which multiple objects can be created. It defines how objects look and behave.
- **Object vs. Instance**:
  - Object: A real-world entity or complete entity containing both static and non-static fields.
  - Instance: The memory allocated for non-static variables, representing a single copy from the class.
- **Class Structure** (in order):
  1. Static fields (common to all objects).
  2. Instance fields (specific to each object).
  3. Static block (initializes static variables).
  4. Instance block (initializes non-static variables; officially "instance initializer block").
  5. Constructors (default and parameterized).
  6. Setters/getters.
  7. Business logic methods.
  8. Display methods (e.g., toString).
  9. Possibly inner classes.
- **Types of Variables**:
  - Static variables: Class-level, memory allocated once in class scope.
  - Non-static variables: Instance-level, memory in instance scope.
- **Blocks**:
  - Static block: Initializes static variables at class loading.
  - Non-static block: Initialized instance variables for each object.
- **Completeness**: A full object requires both static and non-static initializations; instance refers to non-static memory only.

### Code/Config Blocks
```java
class Student {
    // Static fields (class variables)
    static String instituteName;
    
    // Instance fields (non-static variables)
    String studentName;
    
    // Static block for initializing static variables
    static {
        instituteName = "Example Institute";
        System.out.println("Static block executed");
    }
    
    // Instance initializer block (non-static block)
    {
        studentName = "Default Name";
        System.out.println("Instance block executed");
    }
    
    // Constructors
    Student() {}
    
    Student(String name) {
        this.studentName = name;
    }
    
    // Getters/Setters
    String getStudentName() {
        return studentName;
    }
    
    void setStudentName(String name) {
        this.studentName = name;
    }
    
    // Business logic and display
    void study() {
        System.out.println(studentName + " is studying in " + instituteName);
    }
    
    public String toString() {
        return "Student{name='" + studentName + "', institute='" + instituteName + "'}";
    }
}
```

### Lab Demos
**Demo: Creating a Student Object and Observing Block Execution**
1. Compile and run the class without creating any objects:
   - Expected output: "Static block executed" (static block runs at class loading).
2. Create an object:
   ```java
   Student s = new Student("John");
   ```
   - Expected output: "Instance block executed" followed by object creation.
3. Call methods: `s.study();` displays instance-specific details while referencing static fields.

This demonstrates how blocks initialize variables at the appropriate times.

> [!NOTE]  
> Static blocks run only once per class load, while instance blocks run for each object.

## Understanding Static Blocks
### Overview
Static blocks are nameless blocks placed inside a class with the `static` keyword, executed automatically by the JVM once during class loading to perform initialization tasks.

### Key Concepts/Deep Dive
- **Definition**: A static initializer block (officially) that's nameless to prevent manual invocation, ensuring it runs only at class loading.
- **Purpose**: Initialize static variables and execute one-time logic (e.g., loading config, establishing connections) without wasting memory or allowing multiple calls.
- **Why Needed?**: Static methods/variables alone don't guarantee one-time execution (methods can be called repeatedly), so a block restricts usage.
- **Rules**:
  - Can contain any valid static method code: loops, conditions, try-catch.
  - Cannot use `return` (compiler error: "return outside method").
  - Cannot use `throw` without try-catch (takes exception; "initializer must complete normally").
  - Variables declared inside are local and inaccessible outside.
- **Flow**: Class load → Static variables allocate memory (default values) → Static blocks execute top-to-bottom → Main method.

### Code/Config Blocks
```java
class Example {
    static int a;  // Default value: 0
    
    static {
        a = 50;
        System.out.println("Static block: a initialized to " + a);
    }
    
    public static void main(String[] args) {
        System.out.println("Main: a = " + a);
    }
}
```

Output:
```
Static block: a initialized to 50
Main: a = 50
```

### Lab Demos
**Demo: Static Block Execution**
1. Run the above class.
   - Observe: Static block executes before main, initializing a.
2. Add another static block after main:
   ```java
   static {
       System.out.println("Second static block");
   }
   ```
   - Run: Blocks execute in definition order, top-to-bottom.

## Execution Flow of Static Blocks
### Overview
Static blocks are part of class initialization, occurring after static variable allocation but before instance creation or main method execution.

### Key Concepts/Deep Dive
- **Sequence**:
  1. Class loaded into JVM.
  2. Static variables memory allocated (default values).
  3. Static blocks execute in top-to-bottom order.
  4. Main method can now access initialized static variables.
- **One-Time Execution**: Static blocks can't be called; JVM ensures once-per-class-load.
- **Multiple Blocks**: Allowed; each executes sequentially.

```mermaid
graph TD
    A[Class Loaded] --> B[Allocate Static Variables (defaults)]
    B --> C[Execute Static Blocks (top to bottom)]
    C --> D[Main Method]
```

### Code/Config Blocks
```java
class FlowExample {
    static int x = 10;  // Static variable initialization
    
    static {
        System.out.println("First static block: x = " + x);
        x = 20;
    }
    
    static {
        System.out.println("Second static block: x = " + x);
    }
    
    public static void main(String[] args) {
        System.out.println("Main: x = " + x);
    }
}
```

Output:
```
First static block: x = 10
Second static block: x = 20
Main: x = 20
```

### Lab Demos
**Demo: Flow with Multiple Blocks**
1. Run above code.
   - Verify top-to-bottom execution and value propagation.

## Practical Examples and Variable Initialization
### Overview
Static blocks handle static variable initialization, with special handling for variable shadowing and local vs. class-level variables.

### Key Concepts/Deep Dive
- **Basic Initialization**: Assign hard-coded values in static blocks.
- **Variable Shadowing**: Local variables in blocks can shadow class variables; use class name or `this` (not for static) to access class-level.
- **Local Variables**: Declared in block, inaccessible outside; initialize class variables via assignment (e.g., `int a; a = 50;` declares local; `a = 50;` assigns to class if exists).

### Code/Config Blocks
```java
class ShadowingExample {
    static int a = 0;
    
    static {
        int a = 50;  // Local variable shadows class 'a'
        System.out.println("Local a: " + a);
        a = ShadowingExample.a;  // Access class 'a'
        a = 60;  // Assignments affect class
    }
    
    public static void main(String[] args) {
        System.out.println("Class a: " + a);
    }
}
```

Output:
```
Local a: 50
Class a: 60
```

### Lab Demos
**Demo: Variable Shadowing**
1. Run above; note shadowing affects local scope.
2. Modify to `ShadowingExample.a = 70;` in block: Class value updates to 70.

## Dynamic Initialization in Static Blocks
### Overview
Static blocks can read dynamic input (e.g., keyboard) to initialize static variables, useful for configuration values.

### Key Concepts/Deep Dive
- **Scanner Usage**: Create Scanner in static block for user input.
- **One-Time Input**: Input tied to class load; re-run class for new inputs.
- **Applications**: Environment-specific settings, file paths, DB connections.

### Code/Config Blocks
```java
import java.util.Scanner;

class DynamicInit {
    static int value;
    
    static {
        Scanner sc = new Scanner(System.in);
        System.out.print("Enter value: ");
        value = sc.nextInt();
        System.out.println("Static block: value set to " + value);
    }
    
    public static void main(String[] args) {
        System.out.println("Main: value = " + value);
    }
}
```

Sample Run:
```
Enter value: 25
Static block: value set to 25
Main: value = 25
```

### Lab Demos
**Demo: Dynamic Input**
1. Run class multiple times with different inputs (e.g., 10, 20).
   - Each run prompts anew due to JVM restart.

## Multiple Static Blocks and Rules
### Overview
Classes can have multiple static blocks; they execute in definition order. Nesting is not allowed.

### Key Concepts/Deep Dive
- **Order**: Top-to-bottom as written in class.
- **Nesting Forbidden**: Compiler error; static contexts apply to class, not sub-blocks.
- **Rules Recap**:
  - Declaration: `static { /* code */ }`
  - Allowed: Statements from static methods.
  - Forbidden: `return`, standalone `throw`.
  - Placement: Anywhere in class; JVM finds them.

### Code/Config Blocks
```java
class MultipleBlocks {
    static {
        System.out.println("Block 1");
    }
    
    public static void main(String[] args) {
        System.out.println("Main");
    }
    
    static {
        System.out.println("Block 2");  // Executes after Block 1
    }
}
```

Output:
```
Block 1
Block 2
Main
```

| Block | Execution Order | Purpose |
|-------|-----------------|---------|
| First | 1st | Init early |
| Second | 2nd | Dependent logic |

### Lab Demos
**Demo: Multiple Blocks**
1. Run above.
   - Confirm order: Block 1 → Block 2 → Main.
2. Try nesting: `static { static { System.out.println("Nested"); } }` → Compiler error.

## Summary
### Key Takeaways
+ Static blocks initialize static variables once during class loading.
- Objects complete after instance blocks + constructors; instances refer to non-static memory.
! Static blocks execute before main, top-to-bottom.
+ Use class names to access shadowed static variables.

### Expert Insight
**Real-world Application**: Static blocks initialize DB connections, load properties files, or set environment constants (e.g., app configs) efficiently without repeating logic. In web apps, they pre-load shared resources like caches or pools.

**Expert Path**: Master variable scopes (local vs. class) and shadowing; practice combining with constructors for full object life cycles. Transition to advanced static contexts like singletons.

**Common Pitfalls**: Forgetting shadowing leads to wrong variable updates; nesting static blocks causes errors. Avoid `return` or unprotected `throw` in blocks; always test multiple runs for dynamic inputs. Issues like "variable not found" arise from local scopes—use `ClassName.variable` for class access. Lesser-known: Static blocks can't handle exceptions via `throws` (use try-catch); they don't support recursion due to nameless nature.

--- 
🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
