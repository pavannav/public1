# Session 14: OOP Principles - Method Overloading

## Table of Contents

- [Overview of Method Overloading](#overview-of-method-overloading)
- [Method Linking and Execution Based on Arguments](#method-linking-and-execution-based-on-arguments)
- [Passing Different Types of Arguments](#passing-different-types-of-arguments)
- [Primitives: Argument Types and Overloaded Method Execution](#primitives-argument-types-and-overloaded-method-execution)
- [References: Argument Types and Overloaded Method Execution](#references-argument-types-and-overloaded-method-execution)
- [Widening for Primitives in Overloading](#widening-for-primitives-in-overloading)
- [Widening for References in Overloading](#widening-for-references-in-overloading)
- [Compiler vs JVM Roles in Overloading](#compiler-vs-jvm-roles-in-overloading)
- [Type Casting and Overloading](#type-casting-and-overloading)
- [Narrowing and Implicit Conversions](#narrowing-and-implicit-conversions)
- [Practical Test Cases](#practical-test-cases)
- [Importance of Practice and Mindset](#importance-of-practice-and-mindset)

## Overview of Method Overloading

Method Overloading is a key Object-Oriented Programming (OOP) principle in Java that allows a class to have multiple methods with the same name but different parameters. This enables polymorphic behavior based on the arguments passed at method invocation. The Java compiler selects the appropriate overloaded method based on the argument's type, ensuring compile-time method resolution.

In Java, method overloading follows specific rules for method signature differentiation. The return type alone does not distinguish overloaded methods, but parameter types, order, and count do. Overloading enhances code readability and reusability by providing context-specific implementations of similar operations.

```java
public class Example {
    static void M1(int i) {
        System.out.println("int param");
    }
    
    static void M1(char c) {
        System.out.println("char param");
    }
}
```

## Method Linking and Execution Based on Arguments

When an overloaded method is called, Java's compiler performs method linking based on the argument's type. This linking determines which overloaded method definition will be executed at runtime. The JVM then executes the linked method without further searching.

Key points:
- Method linking is done at compile-time by the compiler.
- The JVM follows the compiler's linking blindly.
- If no matching method is found, a compile-time error occurs (no such method found).
- The argument type (not its value) drives method resolution.

```diff
+ Compiler links M1(int i) when passing an int argument
- JVM does not perform runtime method search; it executes the linked method
! Value vs Type: Linking uses variable type, execution uses actual value
```

## Passing Different Types of Arguments

There are five main ways to pass arguments to overloaded methods:

1. **Literal**: Direct values like `99`, `'a'`.
2. **Variable**: `M1(variable)`.
3. **Expression**: `M1(a + b)`.
4. **Non-wide method call**: `M1(M2())`.
5. **Cast operator**: `(int)someValue`.

Each approach influences method resolution based on the resulting type.

**Code Example**:
```java
public static void main(String[] args) {
    M1(99);         // Literal int
    int i1 = 97;
    M1(i1);         // Variable (type: int)
    M1(i1 + i2);    // Expression (int + int = int)
    M1(M2());       // Method call (return type: int)
    M1((char)97);   // Cast operator (char type)
}
```

## Primitives: Argument Types and Overloaded Method Execution

For primitive data types, the method resolution depends on the exact argument type. If an exact match isn't available, Java doesn't automatically choose a "nearby" type—it will result in a compile error unless the argument can be implicitly converted.

- Literal types: `99` is int, `'a'` is char, `5.0` is double.
- Variable types: The declared type of the variable (e.g., `int i1` resolves to int parameter).
- Wideening doesn't occur automatically; you must cast for narrowing.

**Table: Primitive Argument Resolution**

| Argument Type | Passed As | Method Executed | Notes |
|--------------|-----------|-----------------|---------|
| int literal | M1(99) | M1(int) | Exact match |
| char literal | M1('a') | M1(char) | Exact match |
| float literal | M1(5.0f) | M1(float) | Requires 'f' suffix |
| long literal | M1(50L) | M1(long) | Requires 'L' suffix |
| Variable int | M1(i1) | M1(int) | Uses variable type |
| Variable char | M1(ch) | M1(char) | Uses variable type |

> [!NOTE]  
> Compiler changes source code representations (e.g., `'a'` to 97) in bytecode for JVM execution.

## References: Argument Types and Overloaded Method Execution

For reference types, method resolution follows upcasting rules. You can pass subclasses or compatible types.

- Object literals: Must be compatible with parameter type.
- Null: Always allowed.
- Variable types: The declared reference type (not the actual object type inside).

**Table: Reference Argument Resolution**

| Argument | Passed As | Method Executed | Notes |
|----------|-----------|-----------------|---------|
| new Object() | M1(obj) | M1(Object) | Direct match |
| new String() | M1(str) | M1(String) | Direct match |
| new Integer(10) | M1(intObj) | M1(Integer) | Direct match |
| null | M1(null) | M1(Object) | Null compatible |
| Subclass object | M1(sample) | M1(Example) | If sample extends Example |

> [!IMPORTANT]  
> Internal object type (e.g., String in Object variable) doesn't affect resolution; only variable type does.

## Widening for Primitives in Overloading

Widening allows implicit conversion to larger primitive types. However, the compiler only applies widening if no exact match exists in overloaded methods.

- Widening hierarchy: byte → short → int → long → float → double.
- For char: char → int → long → float → double.

**Example**:
```java
static void M1(int i) { System.out.println("int param"); }
static void M1(float f) { System.out.println("float param"); }

// M1(5);     // int param (exact)
// M1(5.0);   // float param (widening from double to float? No: compile error
// M1(5.0f);  // float param (exact)
```

```diff
+ Widening applies only if exact match absent
- Never narrows implicitly; use casting
! Compiler searches exact → widening; JVM executes matched method
```

## Widening for References in Overloading

Reference widening follows inheritance: subclasses can widen to superclasses.

- Search order: Exact type → Immediate superclass → Object (top).
- Null always matches.

**Code Example**:
```java
static void M1(Object o) { System.out.println("Object param"); }
static void M1(String s) { System.out.println("String param"); }

M1("Hello");    // String param
M1(new Object()); // Object param
M1(null);       // Object param (first match)
```

## Compiler vs JVM Roles in Overloading

The compiler binds method calls to definitions at compile-time, using argument types to match signatures. The JVM executes the bound methods without re-evaluation.

- **Compiler**: Searches for matched method (exact/widening), generates bytecode with binding.
- **JVM**: Follows bytecode instructions; throws NoSuchMethodError if method absent.

**Bytecode Insight**:
Compiler translates `M1('a')` in bytecode to invoke M1 with int (97), so JVM calls int parameter method even if char method added later without recompilation.

```mermaid
flowchart TD
    A[Call M1(arg)] --> B{Compiler: Exact Match?}
    B -->|Yes| C[Link to Exact Method]
    B -->|No| D{Compiler: Widening?}
    D -->|Yes| E[Link to Widening Method]
    D -->|No| F[Compile Error]
    C --> G[JVM Executes Linked Method]
    E --> G
```

## Type Casting and Overloading

Type casting forces a specific method execution but requires compatibility.

- Primitive: `(char)97` calls char parameter method.
- Reference: `(sample)obj` calls sample parameter if compatible; runtime exception otherwise.

**Example**:
```java
// Primitive
M1((char)97);  // Calls M1(char)

// Reference
Object ob1 = new String("test");
M1((String)ob1);  // Calls M1(String) if original is String
// ClassCastException if not
```

> [!WARNING]  
> Reference casting succeeds compile-time if variable types compatible, but runtime fails if internal object isn't.

## Narrowing and Implicit Conversions

Narrowing (larger to smaller) isn't implicit in overloading. Use casting for short/byte parameters.

- `M1((byte)5)` calls byte parameter method.
- Literals fit into larger types, but reverse requires cast.

## Practical Test Cases

**Lab Demo 1: Primitive Overloading Resolution**

```java
class Example {
    static void M1(int i) { System.out.println("int param"); }
    static void M1(char c) { System.out.println("char param"); }
}

class Test {
    public static void main(String[] args) {
        Example.M1(97);      // int param
        Example.M1('a');     // Outputs: char param (converted implicitly)
        int i1 = 97;
        Example.M1(i1);      // int param (variable type)
        char ch = 'a';
        Example.M1(ch);      // char param
        
        // Expression
        int a = 10, b = 20;
        Example.M1(a + b);   // int param
        
        // Cast
        Example.M1((int)'a'); // int param
    }
}
```

**Expected Output**:
```
int param
char param
int param
char param
int param
int param
```

**Lab Demo 2: Reference Overloading**

```java
class Example {
    static void f(Object ob) { System.out.println("Object param"); }
    static void f(String str) { System.out.println("String param"); }
}

class Test {
    public static void main(String[] args) {
        Object ob1 = new Object();
        Object ob2 = new String("test");
        
        Example.f(ob1);      // Object param
        Example.f(ob2);      // Object param (variable is Object)
        Example.f("direct"); // String param
        Example.f((String)ob2); // String param
    }
}
```

**Expected Output**:
```
Object param
Object param
String param
String param
```

## Importance of Practice and Mindset

Successful learning requires prioritizing important tasks when not urgent. Overloading mastery comes from practice, not theory alone.

> [!IMPORTANT]  
> Procrastination leads to failure; early habit formation ensures success.

**Table: Urgency/Importance Matrix**

| Important | Urgent | Action |
|-----------|--------|--------|
| Do these first | Do these now | Core Java practice |
| Unimportant | Urgent | Avoid piling | Chats, videos (last priority) |

> [!NOTE]  
> Studying Java is like fifth class—part of life, not an exam stress.

## Summary

### Key Takeaways

```diff
+ Method overloading resolves at compile-time based on argument type
- JVM executes only the compiler-linked method; no fallback search
! Primitives: Exact type or cast; References: Upcast or cast with care
! Think like compiler: Link by type; Like JVM: Execute without search
- Avoid procrastination; practice over 5 years for mastery
+ Variables trump values: Resolution by declared type, execution by value
```

### Expert Insight

**Real-world Application**: Overloading enables flexible APIs, like Java's `println()` accepting int, String, etc., for seamless output handling in enterprise logging systems. In frameworks like Spring, overloaded constructors and methods allow configuration flexibility without breaking compatibility.

**Expert Path**: Master bytecode with `javap -c ClassName` to see compiler bindings. Practice daily with IDE debugging, tracing variable types over values. Join open-source projects using overloaded APIs to build real confidence. Aim for "compiler-JVM mindset" in design reviews.

**Common Pitfalls**:
- Assuming values determine resolution—remember variable types.
- Forgetting recompilation: Changing a method doesn't affect already-compiled callers; recompile all classes.
- Runtime exceptions from reference casting: Always verify `instanceof` before casting.

**Common Issues and Resolutions**:
- **Compilation Error**: Method not found—check exact/widening match; resolution order: exact → widening → error.
- **Runtime NoSuchMethodError**: Class not recompiled; rebuild entire project.
- **ClassCastException**: Reference cast failure—verify with `instanceof`.
- **Unexpected Widening**: Primitives narrow only with cast; references upcast, no downcast without check.

**Lesser Known Things**: Compiler inlines implicit conversions (e.g., `char` to `int`) in bytecode for JVM efficiency. Widening for references only climbs hierarchy; siblings (no inheritance) don't widen. Auto-boxing (Java 5+) interacts with overloading—primitives can match wrapper types, a topic for next session. Java's JIT compiler may inline overloaded calls for performance in hot paths. Overloading doesn't apply to method overrides; that's separate polymorphism.
