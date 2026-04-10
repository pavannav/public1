# Session 49: Core Java Variables

| Section | Description |
|---------|-------------|
| [Static Variables](#static-variables) | Understanding memory allocation, access methods, and shared memory concepts |
| [Non-Static Variables](#non-static-variables) | Instance variables, memory allocation, and object-specific storage |
| [Parameters](#parameters) | Method parameters, lifetime, scope, and value passing mechanisms |
| [Local Variables](#local-variables) | Method-level variables, scope limitations, and declaration rules |
| [Types of Variables](#types-of-variables) | Complete classification and comparison of Java variable types |
| [Local Blocks](#local-blocks) | Nameless blocks, scope control, and variable lifecycle |
| [Local Variable Type Inference (var)](#local-variable-type-inference-var) | Java 10+ feature for type inference in local variables |

## Static Variables

### Overview
Static variables represent class-level attributes shared across all instances of a class. These variables are allocated memory during class loading into the JVM and maintain a single copy that can be accessed through multiple methods without object creation.

### Key Concepts/Deep Dive
Static variables exhibit unique memory management and access characteristics that distinguish them from instance-based storage:

- **Memory Allocation**: Static variable memory is created when the class is loaded into the JVM. The declaration and assignment phases occur sequentially:
  - First, all static variable declarations are processed
  - Default values are assigned based on data types
  - User-specified values replace the defaults

- **Access Methods**: Static variables support four distinct access mechanisms:
  - **Direct Access**: Using the variable name without qualification (within same class)
  - **Class Name Access**: Using `ClassName.variableName`
  - **Object Reference Access**: Using `objectReference.variableName`
  - **Null Reference Access**: Using `nullReference.variableName` (compiles successfully but throws runtime exception)

- **Memory Structure**: Static variables occupy a shared memory space that persists throughout the class lifecycle:
  ```java
  class Example {
      static int count = 0; // Single memory location shared by all
      // All methods can access this memory location
  }
  ```

### Code Examples
```java
public class Example {
    static int sharedValue = 10;

    public static void method1() {
        sharedValue = 15;  // Modifies shared memory
    }

    public static void method2() {
        System.out.println(sharedValue); // Prints: 15
    }
}
```

| Static Variable | Non-Static Variable |
|----------------|---------------------|
| One copy shared by all objects | Separate copy per object |
| Memory allocated at class load time | Memory allocated at object creation |
| Accessible before object creation | Requires object instantiation |

## Non-Static Variables

### Overview
Non-static variables, also known as instance variables, provide individual storage for each object of a class. Memory allocation occurs during object instantiation, ensuring that each object maintains separate copies of its instance data.

### Key Concepts/Deep Dive
Non-static variables enable class-level data persistence with object-specific isolation:

- **Memory Allocation**: Unlike static variables, non-static variables receive memory only when objects are instantiated using the `new` keyword
- **Access Methods**: Non-static variables require object context for access:
  - **Object Reference Required**: Direct access by name is prohibited
  - **Syntax**: `objectReference.variableName`
  - **Null Reference**: Compiles but throws `NullPointerException` at runtime

- **Memory Characteristics**: Each object maintains distinct copies of non-static variables:
  ```java
  public class Account {
      int accountNumber; // Separate copy per account object
  }

  Account acc1 = new Account();
  Account acc2 = new Account();
  // acc1.accountNumber and acc2.accountNumber are independent
  ```

### Code Examples
```java
public class Example {
    int x = 10; // Non-static variable

    public static void main(String[] args) {
        Example e1 = new Example(); // x memory allocated
        Example e2 = new Example(); // x memory allocated (separate copy)

        e1.x = 20; // Affects only e1's copy
        e2.x = 30; // Affects only e2's copy
    }
}
```

### Access Restrictions
```java
public class Example {
    int value; // Non-static variable

    public static void main(String[] args) {
        Example obj = new Example();

        // Invalid: value cannot be referenced from static context
        // System.out.println(value);

        // Valid: obj.value
        System.out.println(obj.value);

        // Invalid at runtime: NullPointerException
        obj = null;
        // obj.value; // Throws exception
    }
}
```

## Parameters

### Overview
Parameters serve as input conduits for method execution, enabling controlled data flow from caller to method. They represent local variables specifically designed for receiving arguments during method invocation.

### Key Concepts/Deep Dive
Parameters facilitate dynamic method behavior through value transmission mechanisms:

- **Declaration Location**: Declared within method parentheses `methodName(type param1, type param2)`
- **Purpose**: Primary function is receiving input values for method logic execution
- **Memory Lifecycle**: Parameter memory is allocated only during method execution and destroyed upon method completion

- **Scope Rules**: Limited exclusively to the containing method body

### Code Examples
```java
public class Calculator {
    // Parameter declaration in method signature
    public static int add(int a, int b) {
        // a and b are parameters, accessible within this method
        return a + b;
    }

    public static void main(String[] args) {
        int result = add(5, 6); // Arguments 5 and 6 passed to parameters
        System.out.println(result); // Output: 11
    }
}
```

| Aspect | Static Variable | Non-Static Variable | Parameter | Local Variable |
|--------|----------------|---------------------|-----------|----------------|
| Memory Allocation | Class loading | Object creation | Method call | Declaration execution |
| Lifetime | Available until program ends | Available until object destroyed | Until method completion | Until enclosing block |
| Access Scope | Class-wide | Class-wide (via object) | Within method only | Within block only |

## Local Variables

### Overview
Local variables represent temporary storage scoped to method execution blocks. They enable computation and data manipulation within defined boundaries, ensuring controlled memory utilization.

### Key Concepts/Deep Dive
Local variables provide method-specific data handling with strict scoping rules:

- **Declaration Contexts**: Can be declared anywhere within method or block bodies
- **Memory Allocation**: Conditional - occurs only when declaration statement executes
- **Scope Limitations**: Accessible only within declaration block and child blocks

- **Declaration Flexibility**: Can occur within:
  - Method body (scope: method duration)
  - Loop blocks (scope: loop duration)  
  - Conditional blocks (scope: block duration)
  - Switch blocks (scope: case duration)

### Code Examples
```java
public class Example {
    public static void main(String[] args) {
        { // Local block
            int localVar = 10; // Access: within block only
            System.out.println(localVar);
        }
        // localVar not accessible here - scope ended
    }
}
```

| Declaration Context | Scope Limitation |
|---------------------|------------------|
| Method body | Until method end |
| Conditional block | Until condition end |
| Loop block | Until loop end |
| Switch case | Until case end |

## Types of Variables

### Overview
Java categorizes variables into four fundamental types based on declaration location and memory management principles. This classification system provides developers with precise control over data persistence and accessibility.

### Key Concepts/Deep Dive
Variable types are distinguished by their declaration context and behavioral characteristics:

**Class-Level Variables:**
- **Static Variables**: Shared across all class instances with single memory allocation
- **Non-Static Variables**: Instance-specific data with separate memory per object

**Method-Level Variables:**
- **Parameters**: Input receptors for method execution with temporary lifetime
- **Local Variables**: Block-scoped temporary storage for computations

### Complete Classification Table
| Variable Type | Primitive | Location | Memory Allocation | Lifetime | Access Method | Default Values |
|----------------|-----------|----------|-------------------|----------|---------------|----------------|
| Static | Yes/No | Class | Class load | Until class unload | 4 ways | Yes |
| Non-Static | Yes/No | Class | Object creation | Until object destroyed | 1 way (object reference) | Yes |
| Parameter | Yes/No | Method parens | Method call | Method completion | Within method | No |
| Local | Yes/No | Method body | Declaration | Block completion | Within block | No |

### Reference vs Primitive Variables
- **Primitive Variables**: Store actual values directly in memory
- **Reference Variables**: Store memory addresses pointing to complex objects

### Purpose-Based Classification
- **Static Variables**: Storing class-wide constants and shared data
- **Non-Static Variables**: Maintaining individual object state
- **Parameters**: Receiving method inputs from callers
- **Local Variables**: Temporary computation storage within method blocks

## Local Blocks

### Overview
Local blocks represent nameless code segments created within method bodies to enhance variable scoping control. They enable precise memory management by allowing developers to limit variable lifetimes to specific execution contexts.

### Key Concepts/Deep Dive
Local blocks provide granular control over variable accessibility and resource management:

- **Syntax**: Nameless constructs using braces `{ ... }` within method bodies
- **Purpose**: Controlling variable scope to optimize memory usage
- **Execution**: Always executed during method calls - no conditional barriers

- **Allowed Statements**: All method-permitted operations:
  - Variable declarations and assignments
  - Conditional statements and loops
  - Method calls and object creation

### Code Examples
```java
public class BlockDemo {
    public static void demonstrateBlocks() {
        int methodVar = 10;

        { // Local block begins
            int blockVar = 20;
            methodVar = blockVar; // Valid - accessing method level variable
        } // Local block ends

        // blockVar not accessible here
        // System.out.println(blockVar); // Compilation error
    }
}
```

| Block Feature | Purpose | Accessibility |
|---------------|---------|---------------|
| Variable Scope Control | Limit variable lifetime | Block-boundaries |
| Break/Continue Control | Exit nested loops/blocks | Label-based navigation |
| Memory Optimization | Destroy variables early | Prevent memory leaks |

### Block Labeling
```java
public class LabelDemo {
    public static void main(String[] args) {
        lb1: { // Labelled local block
            lb2: {
                for (int i = 0; i < 10; i++) {
                    if (i == 5) {
                        break lb2; // Breaks to end of lb2 block
                    }
                }
            } // Control jumps here after break lb2
        } // Control reaches here after lb2 completion
    }
}
```

### Variable Scope Rules in Blocks
1. **Access After Block**: Local variables cannot be accessed after block termination
2. **Recreation After Block**: Local block variables can be recreated outside their defining block
3. **Recreation Within Block**: Method-level variables cannot be recreated within child blocks
4. **Modification in Block**: Method-level variables can be modified within blocks
5. **Read After Block**: Modified values persist beyond block boundaries

## Local Variable Type Inference (var)

### Overview
Introduced in Java 10, local variable type inference enables the compiler to automatically determine primitive and reference variable types from initialization expressions, reducing verbose type declarations.

### Key Concepts/Deep Dive
The `var` keyword represents a special identifier enabling type deduction for local variable declarations:

- **Keyword Status**: `var` is not a reserved keyword but a special identifier
- **Applicability**: Restricted to local variables only
- **Requirements**: Must include explicit initialization with a type-determinable value

### Code Examples
```java
public class VarDemo {
    public static void main(String[] args) {
        // Valid var declarations with type inference
        var primitiveInt = 10;          // Inferred as int
        var primitiveDouble = 10.5;     // Inferred as double
        var primitiveChar = 'A';        // Inferred as char
        var primitiveBool = true;       // Inferred as boolean

        var referenceString = "Java";   // Inferred as String
        var referenceArray = new int[]{1, 2, 3}; // Inferred as int[]
        var referenceObject = new Object(); // Inferred as Object
    }
}
```

### Usage Restrictions
```java
public class VarRestrictions {
    // Invalid: Not applicable to fields
    // static var staticField;        // Compilation error

    // Invalid: Parameters cannot use var
    // public static void method(var param) { } // Compilation error

    // Invalid: No initialization
    // var uninitializedVar;          // Compilation error

    // Invalid: Null has no specific type
    // var nullVar = null;            // Compilation error

    // Valid: Assignment must be present
    public static void method() {
        var valid = 10;               // Inferred as int
        valid = 20;                   // Valid - same type

        // valid = 20.5;              // Invalid - type mismatch
    }
}
```

### Benefits and Applications
- **Reduced Verbosity**: Eliminates explicit type declarations for obvious cases
- **Enhanced Readability**: Focuses on variable purpose rather than implementation details  
- **Method Return Value Assignment**: Particularly useful when method return types are complex

### Code Examples for Benefits
```java
public class MethodAssignment {
    public static void main(String[] args) {
        // Without var - verbose
        Map<String, List<String>> map1 = getMapData();

        // With var - cleaner
        var map2 = getMapData();
    }

    private static Map<String, List<String>> getMapData() {
        return new HashMap<>();
    }
}
```

### Key Restrictions Summary
| Restriction | Reason | Example |
|-------------|---------|---------|
| Not for fields | Static/instance variables initialized at different times | `static var field = 10; // Error` |
| Not for parameters | No initialization in parameter context | `void method(var p) // Error` |
| Requires initialization | Type inference needs source value | `var x; // Error` |
| Null assignments | Null has no concrete type | `var x = null; // Error` |

### Lab Demo: Variable Memory Management

**Step 1: Create a Java class showing variable interactions**
```java
public class VariableLab {
    static int staticVar = 5;         // Class level static
    int instanceVar = 10;             // Instance level non-static

    public void demonstrateParameters(int param) { // Parameter local to method
        int localVar = 15;            // Local to method body

        { // Local block
            int blockLocal = 20;      // Local to block
            param = param + blockLocal; // Parameter can be modified
            localVar = instanceVar + staticVar; // Access instance and static

            System.out.println("Block Local: " + blockLocal);
        }
        // blockLocal not accessible here

        System.out.println("Parameter modified: " + param);
        System.out.println("Local modified: " + localVar);
        System.out.println("Instance: " + instanceVar);
        System.out.println("Static: " + staticVar);
    }

    public static void main(String[] args) {
        VariableLab obj = new VariableLab();
        obj.demonstrateParameters(25);

        // Demonstrate var usage
        var inferredString = "Type inferred";
        var inferredNumber = staticVar + obj.instanceVar;

        System.out.println("Inferred string: " + inferredString);
        System.out.println("Inferred number: " + inferredNumber);
    }
}
```

**Step 2: Compile and run the program**
```bash
javac VariableLab.java
java VariableLab
```

**Expected Output:**
```
Block Local: 20
Parameter modified: 45
Local modified: 15
Instance: 10
Static: 5
Inferred string: Type inferred
Inferred number: 15
```

**Step 3: Memory diagram tracing**
- Class loading: `staticVar` allocated memory with value 5
- Object creation: `instanceVar` allocated separate memory with value 10  
- Method call: Parameter memory created, local variables allocated
- Block execution: Block-specific local variables created
- Block exit: Block locals destroyed while others persist
- Method completion: Parameter and method locals destroyed

## Summary

### Key Takeaways
```diff
+ Four fundamental variable types in Java: static, non-static, parameter, and local
+ Static variables: One copy per class, allocated at class loading, shared across all instances  
+ Non-static variables: Separate copy per object, allocated at instantiation, accessed via object reference
+ Parameters: Created at method call, destroyed at method completion, scoped to method only
+ Local variables: Allocated at declaration execution, scoped to enclosing block, used for temporary computations
+ Local blocks control variable scope to optimize memory utilization
+ Java 10 introduced var for type inference in local variable declarations
+ Variable lifetime and scope determine accessibility patterns throughout program execution
+ Object reference access required for non-static members, static can use multiple access methods
+ Primitive variables store values directly, reference variables store memory addresses
```
### Expert Insight

#### Real-world Application
Variable management principles directly influence enterprise application architecture. Static variables excel in implementing global configuration caches and database connection pools where shared state across multiple users is crucial. Non-static variables enable individual user session management in web applications, maintaining separate shopping carts or preferences per user. Parameter passing supports modular service designs where complex business logic receives structured inputs. Local blocks provide memory optimization in high-concurrency scenarios like stream processing, where temporary variables can be scoped appropriately to prevent memory leaks.

#### Expert Path
Master variable types by implementing multi-threaded Java applications with proper synchronization patterns. Practice memory profiling using tools like VisualVM to understand heap allocation. Study JVM garbage collection mechanisms and their interaction with variable lifecycles. Explore advanced type inference scenarios and functional programming concepts where `var` enhances code readability. Focus on composition over inheritance by mastering instance variable usage patterns.

#### Common Pitfalls
- **Static Context Access**: Attempting to access non-static variables from static methods without object references leads to "non-static variable cannot be referenced from static context" errors
- **Null Pointer Exceptions**: Using null references to access non-static variables allows compilation but throws runtime exceptions  
- **Variable Shadowing**: Recreating parameter names in method bodies hides parameter values and can cause unexpected behavior
- **Memory Leaks**: Failing to understand scope rules leads to variables holding references longer than needed, causing unnecessary memory consumption
- **Type Inference Limitations**: Expecting `var` to work for dynamic types or uninitialized variables results in compilation failures
- **Block Scope Confusion**: Accessing block-local variables after block termination causes "cannot find symbol" compilation errors
