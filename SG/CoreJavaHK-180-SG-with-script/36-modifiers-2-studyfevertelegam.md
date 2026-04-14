# Session 36: Modifiers

## Table of Contents
- [Why Accessibility Modifiers?](#why-accessibility-modifiers)
- [What is an Accessibility Modifier?](#what-is-an-accessibility-modifier)
- [How Many Accessibility Modifiers in Java?](#how-many-accessibility-modifiers-in-java)
- [Different Access Scopes in a Project](#different-access-scopes-in-a-project)
- [Which Modifier Represents Which Scope?](#which-modifier-represents-which-scope)
- [Least Access Scope Modifier](#least-access-scope-modifier)
- [Highest Access Scope Modifier](#highest-access-scope-modifier)
- [Least Restriction Modifier](#least-restriction-modifier)
- [Highest Restriction Modifier](#highest-restriction-modifier)
- [Programming Without Packages](#programming-without-packages)
- [Accessing Members from Another Class in the Same Package](#accessing-members-from-another-class-in-the-same-package)
- [Introducing Packages](#introducing-packages)
- [Analogies for Modifiers](#analogies-for-modifiers)
- [Programming With Packages](#programming-with-packages)
- [Subclasses and Modifier Access](#subclasses-and-modifier-access)
- [Test Cases and Rules Recap](#test-cases-and-rules-recap)
- [Class Execution and Project Notes](#class-execution-and-project-notes)

## Why Accessibility Modifiers?

In a project, a class and its members are by default accessible to all other programmers from other classes. This is a default statement. Next, if you need to stop or allow access, okay, if you need to stop, let's say if you need to stop other programmers from accessing your class and its members from other classes, and other classes by other programmers, we must use accessibility modifiers.

## What is an Accessibility Modifier?

Accessibility modifier is nothing but a keyword. Every keyword is an accessibility modifier? No, a keyword that is used to set access scope. Access scope. A keyword that is used to set scope to access to access it from other programs is called accessibility modifier.

Same statement: Accessibility modifier is used for restricting restricting accessing a class and its members from other classes.

By using accessibility modifiers, we can set different levels of access permissions.

## How Many Accessibility Modifiers in Java?

Java supports four accessibility modifiers.

Descending to ascending: private, (default), protected, public.

"Why I'm writing default in angular bracket": Because it is not a keyword, excellent.

## Different Access Scopes in a Project

In a project, in Java, we have four different access scopes.

Number one: within the class.

Number two: within the package, from other classes within the same package.

Third one: from outside the package, from outside the package only from subcl-- second that two by using this same subclass reference. Observe if you don't accept the statement you will commit mistake. Repeating again: within the same class, within the package from other classes: within the same package: means I created this class in P1 package, I want to access that class within the same P1 package but from other class. Fourth restriction: anywhere in the project: you access anywhere in the project, no objection, either in the same class or in different class, your wish, anywhere you can access.

## Which Modifier Represents Which Scope?

Private: used for declaring a variable or a method or a Constructor to access within the same class in which it is declared.

Private represents class scope.

Default: if you declare a variable or method or Constructor as default, we are allowed to access them within the same class or within the same package from other classes.

Protected: if you declare a variable or method or a Constructor as protected, we are allowed to access them within the same class or within the same package from other classes (directly, by using their enclosing class) or from outside package but only in subclass that two by using subclass reference.

Public: if you declare a variable or method or a Constructor as public, we are allowed to access them within the same class or within the same package from other classes or from outside package (either in subclass or in normal class, either in normal class by using by using its own enclosing class reference or by using subclass reference).

## Programming Without Packages

Create class Example.java with non-static variables:

```java
int a = 10;
private int a = 10;
int b = 20;
protected int c = 30;
int d = 40;
public int d = 40;
```

Main method:

```java
public static void main(String[] args) {
    Example e1 = new Example();
    System.out.println(e1.a);
    System.out.println(e1.b);
    System.out.println(e1.c);
    System.out.println(e1.d);
}
```

Compiler output: 10 20 30 40.

Create another class Sample.java:

```java
class Sample {
    public static void main(String[] args) {
        System.out.println(Example.a); // Error: non-static
        Example e1 = new Example();
        // System.out.println(e1.a); // Comment: private access error
        System.out.println("B: " + e1.b);
        System.out.println("C: " + e1.c);
        System.out.println("D: " + e1.d);
    }
}
```

Compiler output: B: 20, C: 30, D: 40.

## Accessing Members from Another Class in the Same Package

Within same package: default and protected act as default, no difference. Private: not allowed. Public: allowed.

## Introducing Packages

Packages: P1 and P2.

In P1: Class A with private a, default b, protected c, public d.

In P2: Class C extends A.

```bash
# Create directories
mkdir P1
mkdir P2
```

Class A in P1:

```java
package P1;
public class A {
    private int a = 10;
    int b = 20;
    protected int c = 30;
    public int d = 40;
}
```

Class B in P1:

```java
package P1;
public class B {
    public static void main(String[] args) {
        A a1 = new A();
        // System.out.println(a1.a); // Comment: private
        System.out.println("B: " + a1.b);
        System.out.println("C: " + a1.c);
        System.out.println("D: " + a1.d);
    }
}
```

Run: javac P1/B.java, java P1.B -> outputs B, C, D.

## Least Access Scope Modifier

Private

## Highest Access Scope Modifier

Public

## Least Restriction Modifier

Public

## Highest Restriction Modifier

Private

## Analogies for Modifiers

First example: Father bringing money.

- Private: locked in locker (only father).

- Default: outside racks in home (family).

- Protected: plate in hall (family + relatives).

- Public: on road (anyone).

Second example: Similar.

## Programming With Packages

Class C in P2 (extends A):

```java
package P2;
import P1.A;
public class C extends A {
    public static void main(String[] args) {
        A a1 = new A();
        // System.out.println(a1.a); // Error
        // System.out.println(a1.b); // Error
        // System.out.println(a1.c); // Error: not subclass ref
        System.out.println("D: " + a1.d);

        C c1 = new C();
        // System.out.println(c1.a); // Error
        // System.out.println(c1.b); // Error
        System.out.println("C: " + c1.c);
        System.out.println("D: " + c1.d);
    }
}
```

Run: javac P2/C.java, java P2.C -> D:40, C:30, D:40.

## Subclasses and Modifier Access

In subclass, using superclass reference: protected not allowed. Must use subclass reference.

## Test Cases and Rules Recap

Various test cases with classes in different packages, subclasses, accessing via different references.

Rules:

- Private: only same class.

- Default: same package.

- Protected: same class, same package, or outside package in subclass using subclass reference.

- Public: anywhere.

## Class Execution and Project Notes

Commands for compilation and execution in IDE or command prompt.

Run.bat with pause for Windows: add `pause` at end.

In transcript, some issues: "cript" corrected to "Transcript", "modif" to "modifiers", various typos like "htp" if present but not here, "accessor" misspelled "accessors", etc. Notified: Transcript has several typo's like "cript" at start (likely "Transcript"), "modif er" (modifiers), "defauly" (defaultly), "ubic" (public?), and repetitive sentences.

## Summary

### Key Takeaways
```diff
+ Private modifier provides the least access scope.
- Private modifier provides the highest restriction.
+ Protected modifier allows access in subclasses from outside packages only using subclass reference.
- Within the same package, protected acts as default.
! Public modifier provides least restriction (highest access).
! Java has four accessibility modifiers: private, default, protected, public.
```

### Expert Insight
**Real-world Application**: Accessibility modifiers are crucial for encapsulation in real-world Java applications. For example, in a banking system, private fields for sensitive data like account balances ensure security within the class, while public methods allow controlled access from other parts of the application.

**Expert Path**: Master modifier usage by practicing with multi-package projects. Study the classpath for compilation and execution. Read advanced topics on reflection and how modifiers affect serialization and inheritance.

**Common Pitfalls**: 
- Confusing protected with default within same package.
- Trying to access protected members with superclass reference in subclasses.
- Misunderstanding scope leading to compile-time errors.
- Forgetting import statements for cross-package access.

To avoid these, always compile incrementally after adding modifiers or references, and use IDE tools for visibility checks. Practice test cases with at least 4 classes across packages. If using Java 14, ensure classpath includes JDK bin directory in PATH.󅬅
