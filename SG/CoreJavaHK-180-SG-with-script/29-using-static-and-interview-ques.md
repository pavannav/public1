# Session 29: Using Static and Interview Questions

## Table of Contents
- [Overview](#overview)
- [Key Concepts](#key-concepts)
  - [Packages and Non-Packaged Classes](#packages-and-non-packaged-classes)
  - [Static Members in Classes](#static-members-in-classes)
  - [Static Import Feature](#static-import-feature)
  - [Syntax and Rules for Static Import](#syntax-and-rules-for-static-import)
  - [Differences Between Normal Import and Static Import](#differences-between-normal-import-and-static-import)
  - [Using Static Import with Predefined Classes](#using-static-import-with-predefined-classes)
  - [Local Variables vs. Imported Members](#local-variables-vs-imported-members)
  - [Accessing System Time](#accessing-system-time)
- [Interview Questions](#interview-questions)
- [Lab Demos](#lab-demos)
- [Summary](#summary)


## Overview

Static import is a Java feature introduced in Java 1.5 (J2SE 5.0) that allows you to access static members (variables, methods, and inner classes) of a class directly by their name without using the class name as a prefix. This feature reduces code verbosity and improves readability, especially when frequently accessing static members. Before static import, you had to use fully qualified class names or normal import statements. Static import provides access to public static members from another packaged class without needing to specify the class name repeatedly. It differs from normal import statements, which provide access to classes themselves, not their static members.

## Key Concepts

### Packages and Non-Packaged Classes

In Java, packaged classes are those declared with a `package` statement (e.g., `package p8;`), while non-packaged classes are in the default package (no `package` statement). You cannot access a non-packaged class from a packaged class, or vice versa, without proper import statements. This rule ensures encapsulation and organization of code into packages.

- Access rules:
  - Packaged class to another packaged class: Requires `import` statement.
  - Non-packaged class to packaged class: Not allowed; throws compilation error.
  - Packaged class to non-packaged class: Not allowed; throws compilation error.
  - Non-packaged to non-packaged: Allowed without import.

```bash
# Compilation attempt from packaged class to non-packaged class
javac P2/B.java  # Errors: cannot find symbol - non-packaged class A not accessible
```

### Static Members in Classes

Static members (variables, methods, inner classes) belong to the class rather than instances. They are shared across all objects of the class and can be accessed using the class name or directly if in the same class.

- Static variables: Declared with `static` keyword, one copy shared by all instances.
- Static methods: Belong to class, can access only static members directly.
- Non-static variables/methods: Multiple copies (one per object), accessible only via object reference.

```java
public class A {
    public static int a = 10;
    public static void M1() {
        System.out.println("Static method");
    }
    public int x = 20;
    public void M2() {
        System.out.println("Non-static method");
    }
}
```

### Static Import Feature

Static import allows direct access to public static members without prefixing the class name. It reduces repetitive code when using utility classes like `Math`, `System`, or custom classes with many static members.

**Why use static import?**
- Avoids repetitive class name usage (e.g., `Math.PI` becomes `PI`).
- Improves code readability.
- Backward compatible; introduced for convenience, not necessity.

**When is static import useful?**
- Only when you don't have local variables/methods with the same names; otherwise, local takes precedence.

```java
import static p8.A.a;  // Specific member
import static p8.A.M1;  // Specific method
// Now use directly: System.out.println(a); M1();
```

### Syntax and Rules for Static Import

The syntax is: `import static packageName.className.memberName;` or `import static packageName.className.*;` for all public static members.

**Rules:**
- Works only for public static members.
- Cannot access non-static members or the class itself.
- If conflict with local members, local members take priority.
- Must use normal import for accessing the class with its name (e.g., creating objects).

**Examples:**
- `import static java.lang.System.out;` → Allows direct use of `out.println()`.
- `import static p8.A.*;` → Imports all public static members of class A.

```java
// Valid static import
import static java.lang.System.out;
import static java.lang.System.currentTimeMillis;

// Now write directly
public class Demo {
    public static void main(String[] args) {
        out.println("Hello");  // Instead of System.out.println
        long time = currentTimeMillis();  // Instead of System.currentTimeMillis
    }
}
```

### Differences Between Normal Import and Static Import

| Aspect          | Normal Import                          | Static Import                          |
|-----------------|----------------------------------------|---------------------------------------|
| Purpose        | Provides access to classes            | Provides access to static members     |
| Syntax         | `import packageName.className;`        | `import static packageName.className.member;` |
| Access         | Can access class, create objects      | Cannot access class name or non-static members |
| Example        | `import java.util.List;` → `List list = new ArrayList();` | `import static java.lang.Math.PI;` → `double area = PI * r * r;` |
| Scope          | Classes, interfaces, enums            | Public static variables, methods, inner classes |
| Conflict       | No conflict with members               | Conflicts with local members possible |

> [!NOTE]
> Static import is useful for frequently used static members, but overusing it can make code harder to read (unclear which class the member belongs to).

### Using Static Import with Predefined Classes

Static import works with any public static members, including those in predefined classes like `System`, `Math`, etc.

- `System.out` is a static variable of type `PrintStream`.
- `Math.PI`, `Math.sqrt()` are static constants/methods.

**System.time example:**
```java
import static java.lang.System.*;
import static java.sql.Timestamp.*;
import static java.lang.System.nanoTime;

public class TimeDemo {
    public static void main(String[] args) {
        long milliTime = currentTimeMillis();
        Timestamp ts1 = valueOf(new java.sql.Timestamp(milliTime));
        System.out.println(ts1);  // Date and time in milliseconds

        long nanoTimeVal = nanoTime();
        Timestamp ts2 = valueOf(new java.sql.Timestamp(nanoTimeVal));
        System.out.println(ts2);  // Note: nanoTime gives Nanoseconds (though displayed similarly)
    }
}
```

### Local Variables vs. Imported Members

When a local variable/method has the same name as an imported static member, the local one takes precedence.

- Compiler searches: local variables → class members → imported static → throws error.

```java
import static p8.A.a;  // Imports static int a = 10;

public class Demo {
    public static void main(String[] args) {
        int a = 50;  // Local variable takes priority
        System.out.println(a);  // Outputs 50, not 10
    }
}
```

If you want imported static, use fully qualified name or `this` class context.

## Interview Questions

**Q: What is a static import in Java? When should you use it?**
- A: Static import allows access to static members without class prefix. Use it for frequent static member access to reduce verbosity, but avoid if local name conflicts exist.

**Q: Can you access non-static members using static import?**
- A: No, static import works only for public static members.

**Q: Difference between `import static pkg.Class.*;` and `import static pkg.Class.member;`?**
- A: First imports all public static members; second imports only specific member.

**Q: Why is `java.lang` package not explicitly imported?**
- A: It's implicitly imported by default in all Java classes.

**Q: Valid static import syntaxes?**
- `import static java.lang.System.out;` (valid)
- `import static java.lang.*;` (invalid - not for packages)
- `import static java.lang.System.*;` (valid - imports all static members)

**Q: Can static import be used for inner classes?**
- A: Yes, for public static inner classes.

## Lab Demos

### Lab 1: Basic Static Import Usage
1. Create two classes in different packages: `p8/A.java` (with public static int a = 10 and public static void M1()) and `P9/B.java`.
2. In B.java, use `import static p8.A.a;` and `import static p8.A.M1;`.
3. Write code to print `a` and call `M1()` directly.
4. Compile and run: Should output `10` and `am1`.
5. Modify to use `*` import and verify same behavior.

### Lab 2: System.out Static Import
1. Create a class `Demo.java` with package (e.g., `p8`).
2. Use `import static java.lang.System.out;`.
3. Write `out.println("Hello World");` repeatedly without `System.out.println`.
4. Compile with `javac p8/Demo.java`.
5. Run with `java p8.Demo`.
6. Verify output: Multiple "Hello World" lines.

### Lab 3: Time Access with Static Import
1. Create `TimeDemo.java` with necessary imports.
2. Use `long milliTime = System.currentTimeMillis();`.
3. Create `Timestamp ts = new java.sql.Timestamp(milliTime);`.
4. Print `ts` to see current date/time.
5. Compile and run.
6. Observe output format: e.g., `2021-08-15 07:50:13.322`.

### Lab 4: Local Variable Precedence
1. Create class with static import for a variable.
2. Declare a local variable with same name and different value.
3. Print the variable.
4. Compile and run: Output should show local value, not imported static.

## Summary

### Key Takeaways
```diff
+ Static import started in Java 1.5 to access public static members directly.
+ Helps avoid repetitive class name usage.
+ Use with caution: Local members override imported static ones.
+ Normal import: For classes; Static import: For static members of classes.
```

### Expert Insight

**Real-world Application**: Static import is commonly used in utility classes like `Math`, `Collections`, or custom constant classes in large projects. For example, in game development, frequently accessed constants (e.g., `PI` from `Math`) benefit from static import to simplify formulas like area calculations. In enterprise code, avoid overuse as it can obscure which class a member belongs to, making debugging harder.

**Expert Path**: Master static import by practicing with Java's standard library (e.g., `import static java.util.Arrays.*;`). Understand when to use it vs. traditional access – prioritize clarity over brevity. Experiment with conflicts and learn to resolve them using qualified names. Avoid static import for rarely used members or in team codebases where standards prohibit it.

**Common Pitfalls**: 
- Name conflicts with local variables lead to unexpected behavior (e.g., imported `a` shadowed by local `a`).
- Cannot create objects of imported classes without normal import (e.g., `import static System;` doesn't allow `System s = new System();`).
- Static import doesn't apply to packages or non-public members.
- Compilation errors if imported member isn't public or static.

**Lesser known things about this topic**: Static import can access enum constants, which are implicitly public static. It doesn't affect runtime; it's a compile-time feature that inlines the access. In IDEs, static import candidates often appear in auto-complete, aiding productivity. Also, static import works across inheritance hierarchies for accessed static members.
