# Session 71: Static Members and Execution Flow

- [Illegal Forward Reference](#illegal-forward-reference)
- [Static Members Execution Flow](#static-members-execution-flow)
- [Variable Shadowing](#variable-shadowing)
- [Self-Reference in Initializer](#self-reference-in-initializer)
- [Common Test Cases](#common-test-cases)
- [Summary](#summary)

## Illegal Forward Reference

### Overview
Illegal forward reference is a compile-time error that occurs when attempting to read a static variable before its declaration statement in a static context. This error prevents potential issues where the variable might not have its intended value, ensuring predictable initialization order.

### Key Concepts/Deep Dive
The compiler enforces initialization sequencing for static variables. When accessing a static variable for reading purposes before its complete declaration (including the semicolon), a compile-time error "illegal forward reference" is thrown. This applies in static blocks and static variable initializations.

**Exception Cases:**
- Modifying a static variable (assignment) before declaration is allowed in static blocks
- Accessing static variables from static methods doesn't trigger this error; execution order determines the value

**Resolution Approaches:**
- Use class name (e.g., `Example.a`) to access the static variable explicitly
- Ensure access occurs after the declaration completes
- From static methods, no restriction; value depends on calling context

### Code/Config Blocks
```java
class Example {
    static {
        System.out.println(a); // Illegal forward reference error
    }
    static int a = 10;
}
```

```java
class Example {
    static {
        a = 20; // Modification allowed, no error
    }
    static int a = 10;
}
```

### Tables
| Context | Reading Access | Modification | Error |
|---------|---------------|-------------|--------|
| Static Block | Before declaration: Illegal forward reference | Allowed anytime | Compile-time |
| Static Variable Assignment | Before semicolon: Illegal forward reference | Not applicable | Compile-time |
| Static Method | Always allowed, depends on execution flow | Always allowed | None |

### Lab Demos
**Demo 1: Basic Illegal Forward Reference**
1. Create a Java class with a static variable and a static block
2. In the static block, attempt to print the static variable before its declaration
3. Compile the code - observe "illegal forward reference" error
4. Replace direct access with class name dot (e.g., `Example.a`)

```java
public class IllegalForwardRefDemo {
    static {
        // Line: System.out.println(a); // Error: illegal forward reference
        System.out.println(IllegalForwardRefDemo.a); // Works with class name
    }
    static int a = 10;
    
    public static void main(String[] args) {
        // Test execution
    }
}
```

**Demo 2: Modification Before Declaration**
1. Create a class with static block attempting modification before declaration
2. Verify compilation succeeds (no error for modification)
3. Add a read operation after modification - requires class name for subsequent reads

```java
public class ModificationDemo {
    static {
        a = 50; // Allowed - modification before declaration
        System.out.println(ModificationDemo.a); // Requires class name for reading
    }
    static int a = 10;
    
    public static void main(String[] args) {
        System.out.println(a); // Outputs: 50
    }
}
```

## Static Members Execution Flow

### Overview
Static members follow a four-step execution sequence during class loading. This ensures static variables are properly initialized before any static methods or blocks execute, maintaining consistent state across class instances.

### Key Concepts/Deep Dive
JVM class loader handles static member execution in distinct phases:
1. Memory allocation for static variables with default values
2. Static variable initialization and static block execution in declaration order
3. Priority differences between static blocks and variable assignments
4. Static methods execute on-demand without fixed priority to variables

Accessing static variables from different contexts (blocks vs methods) affects the value read due to execution timing.

### Code/Config Blocks
```java
class ExecutionFlowDemo {
    // Step 1: Memory allocation with default values (a=0, b=0)
    static int a;
    
    static {
        a = 10; // Step 2: Static block executes
        System.out.println("Static block: " + a);
    }
    
    static int b = a + 5; // Step 2: Variable assignment
    
    static int getValue() {
        return b; // Executed only when called
    }
}
```

### Tables
| Execution Phase | Action | Details |
|----------------|--------|---------|
| Loading | Memory allocation | Static variables get default values |
| Linking (Preparation) | Static initialization | Variables and blocks execute top-to-bottom |
| Resolution | Optional phase | Skips for simple initializations |
| Initialization | Static members ready | Class loading complete |

### Lab Demos
**Demo 1: Four-Step Execution Order**
1. Create a class with static variables, blocks, and methods
2. Add debug prints to track execution
3. Load the class via different methods to observe flow changes

```java
public class FlowDemo {
    static int a;
    static int b;
    
    static {
        System.out.println("Step 2: Static block 1 - a=" + a + ", b=" + b);
        a = 50;
    }
    
    static {
        System.out.println("Step 2: Static block 2 - a=" + a + ", b=" + b);
        b = 20;
    }
    
    static int c = a + b; // Step 2: Assignment after blocks
    
    public static void main(String[] args) {
        System.out.println("Step 3: Main - a=" + a + ", b=" + b + ", c=" + c);
        // Call static method to see its behavior
        getValues();
    }
    
    static void getValues() {
        System.out.println("Static method: a=" + a + ", b=" + b + ", c=" + c);
    }
}
/*
Output:
Step 2: Static block 1 - a=50, b=0
Step 2: Static block 2 - a=50, b=20
Step 3: Main - a=50, b=20, c=70
Static method: a=50, b=20, c=70
*/
```

## Variable Shadowing

### Overview
Variable shadowing occurs when a local variable has the same name as a static variable. In such cases, local variables take precedence, potentially leading to unexpected behavior if not handled carefully.

### Key Concepts/Deep Dive
Java resolves variable names by checking local scope first, then class/global scope. When a static variable name is reused in a local context (static block, method), the local variable shadows the static one. Access the static variable explicitly using the class name to avoid shadowing effects.

### Code/Config Blocks
```java
class ShadowingDemo {
    static int value = 100;
    
    static {
        int value = 200; // Local variable shadows static
        System.out.println(value);     // Prints 200 (local)
        System.out.println(ShadowingDemo.value); // Prints 100 (static)
    }
}
```

### Tables
| Variable Type | Resolution Priority | Access Method |
|--------------|-------------------|----------------|
| Local Variable | Highest (first checked) | Direct name |
| Static Variable | Lower (class scope) | Class name prefix |

### Lab Demos
**Demo 1: Static Block Shadowing**
1. Declare a static variable in class
2. In static block, declare local variable with same name
3. Demonstrate different access methods

```java
public class ShadowingLab {
    static int count = 10;
    
    static {
        int count = 50; // Shadows static variable
        System.out.println("Local count: " + count);
        System.out.println("Static count: " + ShadowingLab.count);
    }
    
    static void modifyCount() {
        int count = 20; // Another shadow
        count++; // Modifies local, not static
        System.out.println("Modified local: " + count);
        ShadowingLab.count++; // Modifies static
        System.out.println("Modified static: " + ShadowingLab.count);
    }
    
    public static void main(String[] args) {
        modifyCount();
    }
}
/*
Output:
Local count: 50
Static count: 10
Modified local: 21
Modified static: 11
*/
```

## Self-Reference in Initializer

### Overview
Self-reference in initializer occurs when a static variable attempts to use itself during its own initialization. This creates a compile-time error as the variable hasn't completed initialization yet.

### Key Concepts/Deep Dive
Attempting `static int a = a;` creates a cycle where the variable initializes itself. From Java 7+, this generates "self-reference in initializer" error. Local variables with self-reference get "variable might not have been initialized" error.

### Code/Config Blocks
```java
class SelfRefDemo {
    // Error: self-reference in initializer
    // static int a = a;
    
    static int b = 10; // First initialize properly
    
    static {
        int local = local; // Error: variable might not have been initialized
    }
}
```

### Tables
| Version | Error Message | Context |
|---------|--------------|----------|
| Java 6 and earlier | illegal forward reference | Static variable self-init |
| Java 7+ | self-reference in initializer | Static variable self-init |
| Local variables | variable might not have been initialized | Method/block scope |

### Lab Demos
**Demo 1: Static Variable Self-Reference**
1. Attempt static variable self-initialization
2. Observe compile error
3. Verify different error messages across Java versions

```java
public class SelfRefLab {
    // Uncomment to test: static int value = value; // Compile error
    
    static int properValue = 42; // Correct initialization
    
    static int derivedValue = properValue + 10; // Using other variables is fine
    
    static void testLocalSelfRef() {
        // Would error: int x = x;
        
        // Correct alternative:
        int y = 0;
        y = y + 1; // After initialization
        System.out.println("y: " + y); // Prints 1
    }
    
    public static void main(String[] args) {
        System.out.println("derivedValue: " + derivedValue);
        testLocalSelfRef();
    }
}
```

## Common Test Cases

### Overview
This section covers practical combinations of the concepts above, demonstrating how illegal forward reference, execution flow, and variable shadowing interact in complex scenarios.

### Key Concepts/Deep Dive
Real-world code often combines multiple static member concepts. Understanding execution order and access rules is crucial for writing correct initialization logic. The examples below show typical exam questions and interview scenarios.

### Code/Config Blocks
```java
public class CombinedTest {
    static int a;
    static int b;
    
    static {
        // Execution order: First this block
        System.out.println("Static block 1: a=" + CombinedTest.a);
        a = 10;
    }
    
    static int c = CombinedTest.a + 5; // Uses class name to avoid forward ref
    
    static {
        System.out.println("Static block 2: c=" + c);
        int a = 20; // Shadows static a
        b = a + c; // Uses local a (20) and static c
    }
    
    public static void main(String[] args) {
        System.out.println("Main: a=" + a + ", b=" + b + ", c=" + c);
        System.out.println("Method call: " + getValue());
    }
    
    static int getValue() {
        return b; // No priority issues with static methods
    }
}
/*
Output:
Static block 1: a=0
Static block 2: c=15
Main: a=10, b=35, c=15
Method call: 35
*/
```

### Tables
| Test Case Type | Characteristics | Key Learning |
|----------------|-----------------|-------------|
| Forward Reference with Methods | Static method accessing variable | Value depends on call location |
| Variable Shadowing in Blocks | Local variables in static blocks | Class name required for static access |
| Execution Order Variations | Accessing from different contexts | Default values vs. assigned values |

### Lab Demos
**Demo 1: Combined Concept Test Case**
1. Create a complex class with multiple static members
2. Predict execution flow step-by-step
3. Add debug prints to verify predictions
4. Experiment with call order modifications

```java
public class ComprehensiveDemo {
    static int staticVar;
    static int anotherVar;
    
    static {
        System.out.println("Block 1 start");
        staticVar = 50; // Modification allowed
        System.out.println("staticVar set to: " + staticVar);
    }
    
    static int derivedVar = staticVar + 10; // After block execution
    
    static int methodResult = calculate(); // Static method call during init
    
    static {
        System.out.println("Block 2 start");
        int staticVar = 200; // Shadowing
        anotherVar = staticVar + 5; // Uses local shadow
        System.out.println("anotherVar: " + anotherVar);
    }
    
    static int calculate() {
        System.out.println("Method called during init");
        return derivedVar + 1; // Uses current derivedVar value
    }
    
    public static void main(String[] args) {
        System.out.println("Main execution:");
        System.out.println("staticVar: " + staticVar);
        System.out.println("derivedVar: " + derivedVar);
        System.out.println("anotherVar: " + anotherVar);
        System.out.println("methodResult: " + methodResult);
        
        // Method call affects nothing now
        System.out.println("Method call in main: " + calculate());
    }
}
/*
Output demonstrates complete execution flow
*/
```

## Summary

### Key Takeaways
```diff
+ Static members execute in four phases: memory allocation, initialization, static block execution, and method calls
+ Illegal forward reference errors occur when reading static variables before complete declaration
- Avoid direct access in static blocks before variable declaration without class name qualification
+ Variable shadowing gives priority to local variables over static ones in the same scope
+ Self-reference in initializers causes compilation errors when variables reference themselves
+ Static methods have no precedence relationship with static variables, values depend on call timing
+ Use class name dot (ClassName.variable) to explicitly access static variables and avoid shadowing issues
```

### Expert Insight

#### Real-world Application
Static members initialization sequences are crucial in:
production systems for database connection pools, configuration loading, singleton patterns, logging frameworks. For example, a web application's static block might initialize a connection pool that other static methods use to serve database requests. Incorrect initialization order can lead to null pointer exceptions or incorrect configurations in production environments.

#### Expert Path
To master static member concepts:
1. Practice JVM class loading visualization techniques with memory diagrams
2. Study bytecode generation to understand compiler optimizations
3. Implement complex singleton patterns and factory methods using static blocks
4. Analyze open-source frameworks (like Spring) for static member usage patterns
5. Debug class loading issues in enterprise applications using JVM diagnostic tools

#### Common Pitfalls
**Initialization Order Dependency**:  
Issue: Assuming static methods execute before variable initialization季度 can cause runtime null pointer exceptions when accessing uninitialized variables.  
Resolution: Always initialize static variables before using them in methods.  
How to avoid: Use class name qualification and test with different loading scenarios.

**Variable Shadowing Confusion**:  
Issue: Local variables in static blocks shadowing static fields lead to unexpected values being used.  
Resolution: Explicitly use class name to access static fields in ambiguous scopes.  
How to avoid: Code review checks for variable naming conflicts and clear documentation.

**Self-Reference in Complex Initialization**:  
Issue: Attempting complex self-references like `static int a = a + 1;` results in compilation failures.  
Resolution: Break initialization into multiple steps with clear dependencies.  
How to avoid: Design initialization logic to avoid circular references and use static blocks when needed.

**Lesser Known Things about This Topic**:
- Static blocks can throw checked exceptions, requiring them to be caught or declared
- Static initialization happens lazily (only when class is first used), not during program start
- Static final variables get inline optimization by the compiler, replacing references with constants
- Changing static variable values affects all instances without object creation
- JVM spec allows implementation-specific static initialization ordering optimizations with thread safety guarantees

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
