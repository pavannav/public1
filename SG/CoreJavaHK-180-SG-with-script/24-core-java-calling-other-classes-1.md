# Session 24: Calling Other Classes

## Table of Contents

1. [Overview](#overview)
2. [Package Basics and Conventions](#package-basics-and-conventions)
3. [Creating and Accessing Packaged Classes](#creating-and-accessing-packaged-classes)
4. [Compiler Class Searching Algorithm](#compiler-class-searching-algorithm)
5. [Static vs Non-Static Members](#static-vs-non-static-members)
6. [Accessing Members Across Packages](#accessing-members-across-packages)
7. [Inner Classes and Member Access](#inner-classes-and-member-access)
8. [Lab Demonstration: Accessing Packaged Methods](#lab-demonstration-accessing-packaged-methods)
9. [Summary](#summary)

## Overview

📝 This session explores Java's package system and how to access classes and their members from one package to another. We'll cover package naming conventions, compiler search algorithms for class resolution, member scope rules, and practical demonstrations of cross-package access. The focus is on understanding when and how to make classes and methods available across package boundaries.

### Key Learning Objectives

- Understand package naming rules and restrictions
- Master the compiler's algorithm for finding classes
- Differentiate between static and non-static member access
- Implement cross-package class and method calls

## Package Basics and Conventions

### Package Naming Rules

> [!IMPORTANT]
> Package names must follow specific naming conventions and cannot conflict with predefined Java constructs.

```diff
+ Valid: Package names from predefined classes (e.g., com.example.util)
- Invalid: Package name matching predefined class name (e.g., java.lang.String)
! Package names can match predefined variable names (e.g., int, String)
```

### Package Creation Process

When compiling Java files with `javac *.java`, the compiler automatically creates package directory structures:

```bash
javac a.java test.java  # Creates P1 and P2 folders automatically
```

### Package Folder Structure

```
project/
├── a.java (in P1 package)
├── test.java (in P2 package)
└── packages/  # Created automatically during compilation
    ├── P1/a.class
    └── P2/test.class
```

## Creating and Accessing Packaged Classes

### Basic Package Declaration

```java:package P1;
class A {
    void m1() {
        System.out.println("M1 executed");
    }
}
```

### Cross-Package Access Foundation

!;
- Classes in different packages require explicit access mechanisms
- The `public` modifier enables cross-package accessibility (covered in future sessions)

### Key Points for Packaged Classes

> [!NOTE]
> By default, classes and methods in packages are package-private. Accessing them from different packages requires specific techniques that we'll explore in this session.

```diff
- Package-private classes cannot be accessed directly from other packages
+ Proper access requires understanding compiler resolution paths
! Members need memory allocation (static/new) before cross-package access
```

## Compiler Class Searching Algorithm

### Search Priority Order

⚠ **Critical Algorithm**: When accessing a class like `A` from package `B`, the compiler searches in this order:

1. **Current method** (as local inner class)
2. **Current class** (as member inner class)  
3. **Current Java file** (as outer class)
4. **Current package folder** (for `.class` and `.java` files)
5. **Imported or full qualified classes** (future sessions)

### Compilation Process

```bash
javac a.java     # Creates P1 folder and P1/a.class
javac test.java  # Creates P2 folder and P2/test.class
java P2.Test     # Executes from compiled class in P2
```

### Common Error

```diff
- Cannot find symbol: Class A
! Resolution: Ensure class path, package structure, and access modifiers are correct
```

```java
// Example: Compilation error
package P2;
class Test {
    public static void main(String[] args) {
        A.m1();  // Compiler error: Cannot find symbol Class A
    }
}
```

## Static vs Non-Static Members

### Memory Allocation Rules

> [!IMPORTANT] 
> Java requires explicit memory allocation for class members before access.

```diff
+ Static members: Single heap memory allocation
- Non-static members: Require object instantiation for memory
! Just declaring members doesn't create memory - allocation is mandatory
```

### Member Access Patterns

```java
// Static access - single memory copy
package P1;
class A {
    public static void m1() {
        System.out.println("Static M1 executed");
    }
}

// Access from another package
package P2;
class Test {
    public static void main(String[] args) {
        P1.A.m1();  // Direct static access
    }
}
```

```java
// Non-static access - requires object creation
package P2;
class Test {
    public static void main(String[] args) {
        P1.A obj = new P1.A();
        obj.m1();  // Non-static access via object
    }
}
```

### Key Differentiation

| Aspect | Static | Non-Static |
|--------|--------|------------|
| Memory | Single copy | Multiple copies |
| Access | ClassName.method() | object.method() |
| Declaration | `static void method()` | `void method()` |
| Heap Location | Single heap area | Separate for each object |

## Accessing Members Across Packages

### Package Scope Access

```diff
+ Same package: Direct access without qualification
- Different package: Requires full package qualification (like P1.A.m1())
! Future sessions will cover import statements for simplified access
```

### Full Qualified Name Pattern

```java:package P2;
import java.util.*;  // Simplified, but full qualification shown:

class Test {
    public static void main(String[] args) {
        // Full package path access
        java.util.ArrayList list = new java.util.ArrayList();
        list.add("Hello World");
    }
}
```

## Inner Classes and Member Access

### Inner Class Types

| Location | Type | Memory | Static Allowed |
|----------|------|--------|---------------|
| Inside method | Method-level inner class | Single copy | ❌ |
| Inside class | Class-level inner class | Multiple copies | ✅ |
| File level | Outer class | Single copy | ❌ |

### Access Scenarios

```java:package P2;
class Test {
    static class A {  // Class-level inner class (requires static)
        void m1() {
            System.out.println("Inner class method executed");
        }
    }
    
    public static void main(String[] args) {
        Test.A obj = new Test.A();  // Access inner class
        obj.m1();
        
        // Direct call with qualification
        new Test.A().m1();
    }
}
```

## Lab Demonstration: Accessing Packaged Methods

### Scenario

Given two packages `P1` and `P2`, implement method access from `Test` class in P2 to `A` class method in P1.

### Step-by-Step Implementation

1. **Create A.java in P1 package**:

```java:package P1;
class A {
    void m1() {
        System.out.println("M1 executed from package P1");
    }
}
```

2. **Create Test.java in P2 package**:

```java:package P2;

public class Test {
    public static void main(String[] args) {
        // Step 1: Create object of packaged class
        P1.A obj = new P1.A();
        
        // Step 2: Call the method
        obj.m1();
        
        // Output demonstration
        System.out.println("Main execution completed");
    }
}
```

3. **Compilation and Execution**:

```bash
# Compile both files
javac P1/A.java P2/Test.java

# Execute the Test class
java P2.Test
```

4. **Expected Output**:

```
M1 executed from package P1
Main execution completed
```

### Alternative Principal Class Pattern

In enterprise applications, often a singleton static method serves as the principal access method:

```java:package P1;
class A {
    public static void main(String[] args) {
        System.out.println("Principal execution method");
    }
}

// Access from other package
package P2;
class Test {
    public static void main(String[] args) {
        P1.A.main(null);  // Call principal method
    }
}
```

## Summary

### Key Takeaways

```diff
+ Package structure follows folder hierarchy during compilation
+ Compiler searches classes in strict priority order (method → class → file → package)
+ Static members get single heap memory, accessible via ClassName.memberName()
+ Non-static members require object instantiation using new keyword
- Direct cross-package access requires full qualification (Package1.Class1.method())
+ Inner classes have different memory allocation rules based on declaration location
! Method-level inner classes: single memory copy, no static allowed
! Class-level inner classes: multiple copies, static allowed
! Outer class: single memory copy (implicit), static not applicable
```

### Expert Insight

**Real-world Application**: Package access patterns form the foundation of large-scale Java applications where modularization is critical. Financial systems use this pattern extensively - a `TransactionProcessing` class in the `finance.core` package might be accessed by multiple other packages for transaction validation and processing.

**Expert Path**: Begin mastering Java packages by implementing a modular calculator application with separate packages for `math.operations`, `user.input`, and `result.display`. Focus on understanding when to make a method `public` vs package-private, and practice with interface implementations across packages.

**Common Pitfalls**: 
- Forgetting that mere class/method declaration doesn't allocate memory - always ensure object creation or static declaration for member access
- Confusing inner class access patterns - remember: **method-local** = single copy/single access, **class-level** = allows multiple copies, **file-level** = inheritance target only
- Not using full qualified names during initial package learning - avoid premature import usage until compilation success is verified

**Lesser Known Things**: Java's class searching algorithm actually prioritizes `.class` files over `.java` files during runtime lookup. This enables JAR file dependencies to override source files, a technique commonly used in build tools like Maven and Gradle for dependency management.

🤖 Generated with [Claude Code](https://claude.com/claude-code)  
Co-Authored-By: Claude <noreply@anthropic.com>  
Model ID: CL-KK-Terminal<|control590|># Session 24: Calling Other Classes

## Table of Contents

1. [Overview](#overview)
2. [Package Basics and Conventions](#package-basics-and-conventions)
3. [Creating and Accessing Packaged Classes](#creating-and-accessing-packaged-classes)
4. [Compiler Class Searching Algorithm](#compiler-class-searching-algorithm)
5. [Static vs Non-Static Members](#static-vs-non-static-members)
6. [Accessing Members Across Packages](#accessing-members-across-packages)
7. [Inner Classes and Member Access](#inner-classes-and-member-access)
8. [Lab Demonstration: Accessing Packaged Methods](#lab-demonstration-accessing-packaged-methods)
9. [Summary](#summary)

## Overview

📝 This session explores Java's package system and how to access classes and their members from one package to another. We'll cover package naming conventions, compiler search algorithms for class resolution, member scope rules, and practical demonstrations of cross-package access. The focus is on understanding when and how to make classes and methods available across package boundaries.

### Key Learning Objectives

- Understand package naming rules and restrictions
- Master the compiler's algorithm for finding classes
- Differentiate between static and non-static member access
- Implement cross-package class and method calls

## Package Basics and Conventions

### Package Naming Rules

> [!IMPORTANT]
> Package names must follow specific naming conventions and cannot conflict with predefined Java constructs.

```diff
+ Valid: Package names from predefined classes (e.g., com.example.util)
- Invalid: Package name matching predefined class name (e.g., java.lang.String)
! Package names can match predefined variable names (e.g., int, String)
```

### Package Creation Process

When compiling Java files with `javac *.java`, the compiler automatically creates package directory structures:

```bash
javac a.java test.java  # Creates P1 and P2 folders automatically
```

### Package Folder Structure

```
project/
├── a.java (in P1 package)
├── test.java (in P2 package)
└── packages/  # Created automatically during compilation
    ├── P1/a.class
    └── P2/test.class
```

## Creating and Accessing Packaged Classes

### Basic Package Declaration

```java
package P1;
class A {
    void m1() {
        System.out.println("M1 executed");
    }
}
```

### Cross-Package Access Foundation

>;
- Classes in different packages require explicit access mechanisms
- The `public` modifier enables cross-package accessibility (covered in future sessions)

### Key Points for Packaged Classes

> [!NOTE]
> By default, classes and methods in packages are package-private. Accessing them from different packages requires specific techniques that we'll explore in this session.

```diff
- Package-private classes cannot be accessed directly from other packages
+ Proper access requires understanding compiler resolution paths
! Members need memory allocation (static/new) before cross-package access
```

## Compiler Class Searching Algorithm

### Search Priority Order

⚠ **Critical Algorithm**: When accessing a class like `A` from package `B`, the compiler searches in this order:

1. **Current method** (as local inner class)
2. **Current class** (as member inner class)  
3. **Current Java file** (as outer class)
4. **Current package folder** (for `.class` and `.java` files)
5. **Imported or full qualified classes** (future sessions)

### Compilation Process

```bash
javac a.java     # Creates P1 folder and P1/a.class
javac test.java  # Creates P2 folder and P2/test.class
java P2.Test     # Executes from compiled class in P2
```

### Common Error

```diff
- Cannot find symbol: Class A
! Resolution: Ensure class path, package structure, and access modifiers are correct
```

```java
// Example: Compilation error
package P2;
class Test {
    public static void main(String[] args) {
        A.m1();  // Compiler error: Cannot find symbol Class A
    }
}
```

## Static vs Non-Static Members

### Memory Allocation Rules

> [!IMPORTANT] 
> Java requires explicit memory allocation for class members before access.

```diff
+ Static members: Single heap memory allocation
- Non-static members: Require object instantiation for memory
! Just declaring members doesn't create memory - allocation is mandatory
```

### Member Access Patterns

```java
// Static access - single memory copy
package P1;
class A {
    public static void m1() {
        System.out.println("Static M1 executed");
    }
}

// Access from another package
package P2;
class Test {
    public static void main(String[] args) {
        P1.A.m1();  // Direct static access
    }
}
```

```java
// Non-static access - requires object creation
package P2;
class Test {
    public static void main(String[] args) {
        P1.A obj = new P1.A();
        obj.m1();  // Non-static access via object
    }
}
```

### Key Differentiation

| Aspect | Static | Non-Static |
|--------|--------|------------|
| Memory | Single copy | Multiple copies |
| Access | ClassName.method() | object.method() |
| Declaration | `static void method()` | `void method()` |
| Heap Location | Single heap area | Separate for each object |

## Accessing Members Across Packages

### Package Scope Access

```diff
+ Same package: Direct access without qualification
- Different package: Requires full package qualification (like P1.A.m1())
! Future sessions will cover import statements for simplified access
```

### Full Qualified Name Pattern

```java
package P2;
import java.util.*;  // Simplified, but full qualification shown:

class Test {
    public static void main(String[] args) {
        // Full package path access
        java.util.ArrayList list = new java.util.ArrayList();
        list.add("Hello World");
    }
}
```

## Inner Classes and Member Access

### Inner Class Types

| Location | Type | Memory | Static Allowed |
|----------|------|--------|---------------|
| Inside method | Method-level inner class | Single copy | ❌ |
| Inside class | Class-level inner class | Multiple copies | ✅ |
| File level | Outer class | Single copy | ❌ |

### Access Scenarios

```java
package P2;
class Test {
    static class A {  // Class-level inner class (requires static)
        void m1() {
            System.out.println("Inner class method executed");
        }
    }
    
    public static void main(String[] args) {
        Test.A obj = new Test.A();  // Access inner class
        obj.m1();
        
        // Direct call with qualification
        new Test.A().m1();
    }
}
```

## Lab Demonstration: Accessing Packaged Methods

### Scenario

Given two packages `P1` and `P2`, implement method access from `Test` class in P2 to `A` class method in P1.

### Step-by-Step Implementation

1. **Create A.java in P1 package**:

```java
package P1;
class A {
    void m1() {
        System.out.println("M1 executed from package P1");
    }
}
```

2. **Create Test.java in P2 package**:

```java
package P2;

public class Test {
    public static void main(String[] args) {
        // Step 1: Create object of packaged class
        P1.A obj = new P1.A();
        
        // Step 2: Call the method
        obj.m1();
        
        // Output demonstration
        System.out.println("Main execution completed");
    }
}
```

3. **Compilation and Execution**:

```bash
# Compile both files
javac P1/A.java P2/Test.java

# Execute the Test class
java P2.Test
```

4. **Expected Output**:

```
M1 executed from package P1
Main execution completed
```

### Alternative Principal Class Pattern

In enterprise applications, often a singleton static method serves as the principal access method:

```java
package P1;
class A {
    public static void main(String[] args) {
        System.out.println("Principal execution method");
    }
}

// Access from other package
package P2;
class Test {
    public static void main(String[] args) {
        P1.A.main(null);  // Call principal method
    }
}
```

## Summary

### Key Takeaways

```diff
+ Package structure follows folder hierarchy during compilation
+ Compiler searches classes in strict priority order (method → class → file → package)
+ Static members get single heap memory, accessible via ClassName.memberName()
+ Non-static members require object instantiation using new keyword
- Direct cross-package access requires full qualification (Package1.Class1.method())
+ Inner classes have different memory allocation rules based on declaration location
! Method-level inner classes: single memory copy, no static allowed
! Class-level inner classes: multiple copies, static allowed
! Outer class: single memory copy (implicit), static not applicable
```

### Expert Insight

**Real-world Application**: Package access patterns form the foundation of large-scale Java applications where modularization is critical. Financial systems use this pattern extensively - a `TransactionProcessing` class in the `finance.core` package might be accessed by multiple other packages for transaction validation and processing.

**Expert Path**: Begin mastering Java packages by implementing a modular calculator application with separate packages for `math.operations`, `user.input`, and `result.display`. Focus on understanding when to make a method `public` vs package-private, and practice with interface implementations across packages.

**Common Pitfalls**: 
- Forgetting that mere class/method declaration doesn't allocate memory - always ensure object creation or static declaration for member access
- Confusing inner class access patterns - remember: **method-local** = single copy/single access, **class-level** = allows multiple copies, **file-level** = inheritance target only
- Not using full qualified names during initial package learning - avoid premature import usage until compilation success is verified

**Lesser Known Things**: Java's class searching algorithm actually prioritizes `.class` files over `.java` files during runtime lookup. This enables JAR file dependencies to override source files, a technique commonly used in build tools like Maven and Gradle for dependency management.

🤖 Generated with [Claude Code](https://claude.com/claude-code)  
Co-Authored-By: Claude <noreply@anthropic.com>  
Model ID: CL-KK-Terminal
