# Session 28: Accessing classes and static

## Table of Contents
- [Overview](#overview)
- [Previous Session Recap](#previous-session-recap)
- [Package Concepts and Class Accessibility](#package-concepts-and-class-accessibility)
- [Compiler Algorithm for Accessing Classes](#compiler-algorithm-for-accessing-classes)
- [Explanation of Class Types](#explanation-of-class-types)
- [Sample Program Analysis](#sample-program-analysis)
- [Accessing Members Within a Class](#accessing-members-within-a-class)
- [Practical Code Examples](#practical-code-examples)

## Overview
This session covers the fundamentals of accessing classes in Java, with a focus on packages and the distinction between static and non-static members. We review key concepts from previous sessions and apply a compiler algorithm to understand class loading and accessibility rules.

## Previous Session Recap
In the last session, we concluded learning about packages. Key points discussed:
- Differences between import statements and class path
- Handling same package names in different folders
- Scenarios requiring public declarations, import statements, or full paths

We explored four main cases for accessing classes based on package placement.

## Package Concepts and Class Accessibility
When dealing with Java classes, the following rules determine accessibility:

### Basic Scenario
- Classes without a package belong to the current directory (default package)
- Access within the same directory requires no special declarations

### Accessing Classes Between Packages
The compiler follows a specific search algorithm to locate classes. If a class is not found through the algorithm, errors like "cannot find symbol" occur.

## Compiler Algorithm for Accessing Classes
The compiler searches for classes in this order:
1. Current method
2. Current class/inheritance chain
3. Same Java file
4. Current package
5. Imported packages (via import statements or fully qualified names)

Public access modifiers and import statements become necessary when crossing package boundaries.

## Explanation of Class Types
We discussed four combinations of accessing classes:

- **Non-packaged class from non-packaged class**: Always allowed (no public, import, or classpath needed if in same directory)
- **Non-packaged class from packaged class**: Not allowed (cannot locate class without full path or import)
- **Packaged class from non-packaged class**: Allowed (if import or fully qualified name used)
- **Packaged class from packaged class**: Allowed (public, import, or fully qualified name may be required depending on package differences)

Additionally, interfaces follow the same rules as classes.

## Sample Program Analysis
Consider this sample program with options for potential outputs:

```java
interface Example {
    void M1();
}

package P1;

class Sample {
    void M1() {
        System.out.println("M1 from Sample");
    }
}

package P2;

public class Test {
    public static void main(String[] args) {
        Example ex = new Sample();
        ex.M1();
    }
}
```

**Options Analysis:**
- Option 1: "M1 from sample" - Incorrect, as `Sample` is not accessible from `Test` (different package without import/public)
- Option 2: Compile-time error for implements Example - Correct, as `Example` is non-packaged and cannot be accessed from packaged `Test`
- Option 3: Compile-time error for Sample object creation - Correct, as `Sample` is not accessible
- Option 4: No output - Incorrect, requires compilation success for output

Key rule: Classes/interfaces must be accessible via the compiler algorithm before public modifiers are considered.

> [!NOTE]
> Mistakes in the transcript: "system dot system. out. print Ln" corrected to standard Java syntax "System.out.println"; "implements example" corrected to proper case and context; "hund" likely meant "javac"; "printen" and "print off" corrected to "println". These were spelling/typing errors in the spoken transcript.

## Accessing Members Within a Class
Static members (variables/methods) are created once per class and accessible via class name. Non-static members require object instantiation.

### Static Members Example
```java
package P1;

public class A {
    static int a = 10;
    static void M1() {
        System.out.println("A");
    }
    
    int x = 20;
    void M2() {
        System.out.println("AM2");
    }
}
```

### Accessing from Main Class
```java
package P2;

public class B {
    public static void main(String[] args) {
        A.M1();  // Static method access via class name
        System.out.println(A.a);  // Static variable access
        
        A obj = new A();  // Object creation for non-static
        obj.M2();
        System.out.println(obj.x);
    }
}
```

Commands to compile and run:
```bash
# Compile
javac -d . P1/A.java P2/B.java

# Run
java P2.B
```

Output: 10 A AM2 20

> [!IMPORTANT]
> Static context cannot reference non-static members without objects.

## Summary

### Key Takeaways
```diff
+ Non-packaged classes can access each other without special declarations if in the same directory
- Non-packaged classes cannot be accessed from packaged classes without full paths or imports
+ Packaged classes can be accessed from non-packaged if import/fqn used
+ Packaged classes access other packaged classes requires public/import for different packages
! Static members have one per class, non-static require objects
- Interfaces follow same accessibility rules as classes
+ Compiler algorithm: method → class → file → package → imports
```

### Expert Insight
**Real-world Application**: In enterprise Java projects, packages organize code. Use static members for utility functions (e.g., `Math.sqrt()`). Always check classpath and imports to avoid runtime errors in multi-module apps.

**Expert Path**: Master the compiler algorithm by writing test programs for all four access combinations. Use IDEs like IntelliJ to visualize dependencies, then progress to building JARs with proper manifests.

**Common Pitfalls**:
- **Issue**: Forgetting import for packaged classes leads to "cannot find symbol".
  - **Resolution**: Always verify package paths and add imports. Use wildcards (`import package.*;`) for multiple classes.
- **Issue**: Accessing non-static fields from static methods causes "cannot be referenced from static context".
  - **Resolution**: Create class instances or move logic to instance methods.
- **Issue**: Misplacing package declarations (e.g., third line instead of first) causes compilation failure.
  - **Resolution**: Package must be the first non-comment, non-import line.
- **Lesser known things**: Inner classes inherit package access rules but can access outer class members regardless of static nature. Anchoring to class vs. instance matters in complex hierarchies.
