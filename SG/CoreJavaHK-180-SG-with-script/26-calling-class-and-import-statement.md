# Session 26: Calling Classes and Import Statements

## Table of Contents
- [Overview](#overview)
- [Package Review](#package-review)
- [Import Statement Basics](#import-statement-basics)
- [Fully Qualified Names vs Import Statements](#fully-qualified-names-vs-import-statements)
- [Class Loading Algorithm](#class-loading-algorithm)
- [Import Differentiation: \* vs Specific Class](#import-differentiation--vs-specific-class)
- [Auto Compilation Feature](#auto-compilation-feature)
- [Conflict Scenarios](#conflict-scenarios)
- [Best Practices](#best-practices)
- [Summary](#summary)

## Overview

This session builds on previous discussions of packages by diving deep into how classes are called and accessed across packages using import statements. We explore the JVM's class loading algorithms, the differences between import strategies, and practical examples to understand how Java resolves class references at compile-time and runtime.

## Package Review

Building on last class, packages are namespaces that prevent naming conflicts and organize code. We categories packages (built-in, user-defined, API) and saw how to create, compile, and run classes within hierarchical package structures.

📝 **Key Reminder**: Always prefix package names in source files using the `package` keyword.

## Import Statement Basics

Import statements eliminate the need to use fully qualified class names repeatedly, making code more readable and maintainable.

### Why Import?
```bash
# Without import - verbose
java.util.ArrayList list = new java.util.ArrayList();
```

```bash
# With import - clean
import java.util.ArrayList;
ArrayList list = new ArrayList();
```

## Fully Qualified Names vs Import Statements

- **Fully Qualified Name Approach**: Use complete package.classname. Proven, avoids ambiguity but verbose for frequent use.
- **Import Statement Approach**: Brings class into current namespace. Convenient but can create naming conflicts.

===diff
+ Pros of Import: Cleaner code, faster development
- Cons of Import: Potential naming collisions, impacts class loading priority
===

## Class Loading Algorithm

The JVM and Java compiler follow a strict algorithm to locate classes. When referencing a class (e.g., `ClassA obj = new ClassA();`), the search occurs in this order:

1. **Current Method**: Method-local inner classes
2. **Current Class**: Class-level inner classes  
3. **Current Java File**: Outer classes in same .java file
4. **Current Package**: .class files in current package folder
5. **Imported Packages**: .class/.java files in imported packages
6. **Throw Error**: If not found anywhere

> [!IMPORTANT]
> This algorithm is fixed and determines which class version gets executed.

## Import Differentiation: \* vs Specific Class

Import statements come in two forms with significant behavioral differences:

| Aspect | `import p1.*;` | `import p1.A;` |
|--------|---------------|----------------|
| Access Scope | All public classes from p1 | Only class A from p1 |
| Priority | Lower - prefers current package | Higher - ignores current package |
| Conflict Handling | Allows local class overrides | Prevents local conflicts |
| Performance | Slightly slower (scans all) | Faster (targeted import) |

### Priority Behavior
- `import p1.*;`: Search current package first, then `p1`
- `import p1.A;`: Force load from `p1`, never check current package

### Code Comparison
```java
// With import p1.*;
import p1.*;
public class Test {
    public static void main(String[] args) {
        A obj = new A(); // Loads A from current package P2 if it exists
    }
}
```

```java
// With import p1.A;
import p1.A;
public class Test {
    public static void main(String[] args) {
        A obj = new A(); // Always loads A from p1, never from current package
    }
}
```

## Auto Compilation Feature

🔔 **Key Feature**: Compiler automatically recompiles changed source files.

When both `.class` and `.java` files exist, compiler compares timestamps. If `.java` is newer → recompile and regenerate `.class`.

**Algorithm**:
```
if (.java timestamp > .class timestamp)
    compile .java to fresh .class
else
    use existing .class
```

## Conflict Scenarios

### Scenario 1: Import \* with Local Class
```java
import p1.*;
class A { } // Local outer class
A obj = new A(); // Uses local A → p1.A ignored
```

### Scenario 2: Specific Import with Local Class  
```java
import p1.A; // Specific import
class A { } // Local outer class - CONFLICT!
```
💥 **Compiler Error**: "A is already defined in this compilation unit"

> [!WARNING]
> Specific imports cannot coexist with same-named outer classes in current file.

## Best Practices

✅ **Recommendation**: Use `import package.ClassName;` for:
- Clear visibility of dependencies
- Prevent unexpected class loading from current package
- Avoid naming conflicts in large projects

> [!NOTE]
> `import package.*;` useful for quick prototyping or utility packages with many classes.

## Summary

### Key Takeaways
```diff
+ Import statements make code cleaner by avoiding fully qualified names
+ JVM follows strict priority: method → class → file → package → import → error
+ import package.* prefers current package; import package.A ignores it
+ Auto-compilation ensures latest code runs when timestamps change
+ Specific imports prevent conflicts but forbid same-named outer classes
- Generic imports can hide dependencies and cause unexpected behavior
! Always clean .class files before testing to avoid caching issues
```

### Expert Insight

**Real-world Application**: In enterprise Java projects (Spring Boot, microservices), packages organize large codebases. Import strategies ensure correct component loading - use specific imports in shared libraries to prevent version conflicts between team modules.

**Expert Path**: Master class path mechanics (tomorrow's topic) alongside imports. Practice debugging `NoClassDefFoundError` by tracing this algorithm. Study JAR file internals to understand packaged deployments.

**Common Pitfalls**:
- Relying on auto-import in IDEs hides understanding of JVM resolution
- Assuming `import .*` works identically to specific imports
- Forgetting timestamp-based recompilation leads to debugging confusion
- Nested class naming can confuse inner vs outer class precedence

Less known fact: Java 9+ modules (JPMS) largely replace manual import management, but understanding traditional imports is crucial for legacy codebases and framework internals. Package-private classes cannot be imported - only public ones are accessible across packages.
