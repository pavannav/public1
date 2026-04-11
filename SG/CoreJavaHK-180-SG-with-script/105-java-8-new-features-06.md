# Session 6: Method Reference

## Table of Contents
- [Overview](#overview)
- [Why Method Reference](#why-method-reference)
- [Types of Method Reference](#types-of-method-reference)
- [Syntax of Method Reference](#syntax-of-method-reference)
- [When to Use Method Reference vs Lambda Expression](#when-to-use-method-reference-vs-lambda-expression)
- [Examples and Demos](#examples-and-demos)
- [Interview Questions](#interview-questions)
- [Overloaded Methods and Constructors](#overloaded-methods-and-constructors)

## Overview
Method Reference is a Java 8 feature that provides a shortcut way to create Lambda expressions, specifically for referencing existing methods or constructors without writing additional code. It allows reusing logic from existing classes by directly pointing to their methods, eliminating redundant syntax. This promotes functional programming principles while maintaining code readability and reducing verbosity compared to traditional anonymous inner classes.

Method reference acts as a bridge between object-oriented code and functional interfaces, enabling method invocation through a more concise syntax.

## Why Method Reference
- **Shorten Code**: It reduces code length by avoiding redundant parentheses, arrows, and parameters when the Lambda expression body simply calls an existing method.
- **Improve Readability**: Code becomes more expressive, focusing on "what" rather than "how."
- **Performance**: Slight optimizations at runtime as there's no intermediate Lambda body execution.
- **Functional Style**: Supports functional programming by reusing imperative methods in a declarative way.

## Types of Method Reference
Three types of method references exist, each tailored to different scenarios:

### Static Method Reference
References a static method from a class. Used when the implementation logic resides in a static method.

Syntax: `ClassName::staticMethodName`

Example:
```java
interface Addition {
    void add(int a, int b);
}

// Existing class with static method
class A {
    public static void m1(int a, int b) {
        System.out.println(a + b);
    }
}

// Method reference
Addition ref = A::m1; // Refers to static method m1
ref.add(5, 6); // Output: 11
```

> [!NOTE]
> The static method parameters must match the functional interface method parameters exactly in type and count.

### Instance Method Reference
References an instance (non-static) method from an object. Requires creating an object before referencing the method.

Syntax: `objectReference::instanceMethodName`

Example:
```java
interface Addition {
    void add(int a, int b);
}

// Existing class with non-static method
class B {
    public void m2(int a, int b) {
        System.out.println(a + b);
    }
}

// Method reference
B obj = new B();
Addition ref = obj::m2; // Refers to instance method m2
ref.add(7, 8); // Output: 15
```

> [!IMPORTANT]
> For instance method references, if the functional interface method has no parameters, you still need an object reference.

### Constructor Reference
References a constructor of a class. Used when the Lambda expression body creates objects using `new`.

Syntax: `ClassName::new`

Example:
```java
interface Supplier<T> {
    T get();
}

// Existing class
class C {
    public C() {
        System.out.println("Constructor called");
    }
}

// Constructor reference
Supplier<C> ref = C::new;
C obj = ref.get(); // Output: Constructor called
```

> [!NOTE]
> Constructor references can handle parameterized constructors by matching the functional interface method parameters.

## Syntax of Method Reference
The method reference operator is `::` (double colon), functioning as a separator between the class/object and the method/constructor name.

| Type | Syntax Example | Description |
|------|----------------|-------------|
| Static | `ClassName::methodName` | References static method |
| Instance | `obj::methodName` | References instance method on object `obj` |
| Constructor | `ClassName::new` | References constructor |

Key points:
- Parameters are automatically passed from the functional interface call to the referenced method.
- No additional syntax like parentheses or arrows required beyond the `::`.
- Compilation fails if method/constructor parameters don't match the functional interface method.

## When to Use Method Reference vs Lambda Expression
Use method reference when the Lambda expression body consists solely of a method call, without any additional logic.

Use Lambda expression when:
- You need to add statements beyond a simple method call.
- You want to transform parameters (e.g., calculations or modifications).

Example comparison:

**Method Reference:**
```java
List<String> list = Arrays.asList("a", "b", "c");
list.forEach(System.out::println); // Method reference
```

**Lambda Expression (required with additional logic):**
```java
list.forEach(s -> System.out.println(s.toUpperCase())); // Lambda with transformation
```

> [!ALERT]
> Method reference fails if you attempt to include statements; stick to pure method calls.

## Examples and Demos

### Demo 1: Basic Method References
Class `A` with methods:
```java
class A {
    public static void sayHi() {
        System.out.println("Hi");
    }
    
    public void sayHello() {
        System.out.println("Hello");
    }
    
    public A() {
        System.out.println("Hi from constructor");
    }
}

interface I1 {
    void m1();
}

// Static method reference
I1 ref1 = A::sayHi;
ref1.m1(); // Output: Hi

// Instance method reference
A obj = new A();
I1 ref2 = obj::sayHello; // Note: Constructor executes here too
ref2.m1(); // Output: Hello

// Constructor reference
I1 ref3 = A::new;
ref3.m1(); // Output: Hi from constructor
```

### Demo 2: Parameterized Functional Interface
```java
interface I2 {
    void m2(int a, int b);
}

class A {
    public static void staticMethod(int a, int b) {
        System.out.println(a + " + " + b + " = " + (a + b));
    }
    
    public void instanceMethod(int a, int b) {
        System.out.println(a + " * " + b + " = " + (a * b));
    }
    
    public A(int a, String msg) {
        System.out.println("Param constructor: " + a + ", " + msg);
    }
}

// Static method reference
I2 ref1 = A::staticMethod;
ref1.m2(3, 4); // Output: 3 + 4 = 7

// Instance method reference
A obj = new A(1, "param"); // Constructor call
I2 ref2 = obj::instanceMethod;
ref2.m2(3, 4); // Output: 3 * 4 = 12

// Constructor reference
I2 ref3 = A::new;
ref3.m2(5, "test"); // Output: Param constructor: 5, test
```

### Lab Step-by-Step: Implementing Functional Interfaces with Method References
1. Define a functional interface:
   ```java:interfaces/Addition.java
   @FunctionalInterface
   public interface Addition {
       void add(int a, int b);
   }
   ```

2. Create support classes:
   ```java:classes/A.java
   public class A {
       public static void staticAdd(int a, int b) {
           System.out.println("Static add: " + (a + b));
       }
       
       public void instanceAdd(int a, int b) {
           System.out.println("Instance add: " + (a + b));
       }
       
       public A(int a, int b) {
           System.out.println("Constructor add: " + (a + b));
       }
   }
   ```

3. Implement with outer class (not recommended):
   ```java:outter/AdditionImpl.java
   public class AdditionImpl implements Addition {
       @Override
       public void add(int a, int b) {
           A.staticAdd(a, b);
       }
       
       public static void main(String[] args) {
           AdditionImpl impl = new AdditionImpl();
           impl.add(5, 6); // Output: Static add: 11
       }
   }
   ```

4. Replace with anonymous inner class:
   ```java:anonymous/AnonymousExample.java
   public class AnonymousExample {
       public static void main(String[] args) {
           Addition add = new Addition() {
               @Override
               public void add(int a, int b) {
                   A.staticAdd(a, b);
               }
           };
           add.add(5, 6); // Output: Static add: 11
       }
   }
   ```

5. Simplify with Lambda expression:
   ```java:lambda/LambdaExample.java
   public class LambdaExample {
       public static void main(String[] args) {
           Addition add = (a, b) -> A.staticAdd(a, b);
           add.add(5, 6); // Output: Static add: 11
       }
   }
   ```

6. Optimize with static method reference:
   ```java:methodref/StaticRefExample.java
   public class StaticRefExample {
       public static void main(String[] args) {
           Addition add = A::staticAdd; // Static method reference
           add.add(5, 6); // Output: Static add: 11
       }
   }
   ```

7. Use instance method reference:
   ```java:methodref/InstanceRefExample.java
   public class InstanceRefExample {
       public static void main(String[] args) {
           A obj = new A(0, 0); // Create object
           Addition add = obj::instanceAdd; // Instance method reference
           add.add(5, 6); // Output: Instance add: 11
       }
   }
   ```

8. Apply constructor reference:
   ```java:methodref/ConstructorRefExample.java
   public class ConstructorRefExample {
       public static void main(String[] args) {
           Addition add = A::new; // Constructor reference
           add.add(5, 6); // Output: Constructor add: 11
       }
   }
   ```

9. Compile and run:
   ```bash
   javac interfaces/*.java classes/*.java outter/*.java anonymous/*.java lambda/*.java methodref/*.java
   java methodref.StaticRefExample
   java methodref.InstanceRefExample
   java methodref.ConstructorRefExample
   ```

Expected outputs:
- Static: Static add: 11
- Instance: Constructor add: 0; Instance add: 11
- Constructor: Constructor add: 11

## Interview Questions
- What is method reference and why was it introduced?
- Explain the three types of method reference with examples.
- When can't you use method reference?
- How does method reference differ from Lambda expressions?
- Why are overloaded methods handled automatically in method references?

## Overloaded Methods and Constructors
Method reference automatically selects the correct overloaded method/constructor based on the functional interface method signature.

```java:overloaded/OverloadedExample.java
interface I1 { void m1(); }
interface I2 { void m1(int a); }
interface I3 { void m1(String s); }

class A {
    public A() { System.out.println("No-param constructor"); }
    public A(int a) { System.out.println("Int-param constructor: " + a); }
    public A(String s) { System.out.println("String-param constructor: " + s); }
    
    public static void abc() { System.out.println("No-param static method"); }
    public static void abc(int a) { System.out.println("Int-param static method: " + a); }
    public static void abc(String s) { System.out.println("String-param static method: " + s); }
    
    public void bbc() { System.out.println("No-param instance method"); }
    public void bbc(int a) { System.out.println("Int-param instance method: " + a); }
    public void bbc(String s) { System.out.println("String-param instance method: " + s); }
}

public class OverloadedExample {
    public static void main(String[] args) {
        // Constructor references based on interface methods
        I1 i1 = A::new; // Matches no-param constructor
        I2 i2 = A::new; // Matches int-param constructor
        I3 i3 = A::new; // Matches String-param constructor
        
        i1.m1(); // No-param constructor
        i2.m1(5); // Int-param constructor: 5
        i3.m1("HK"); // String-param constructor: HK
        
        // Static method references
        I1 s1 = A::abc; // Matches no-param static method
        I2 s2 = A::abc; // Matches int-param static method
        I3 s3 = A::abc; // Matches String-param static method
        
        s1.m1(); // No-param static method
        s2.m1(10); // Int-param static method: 10
        s3.m1("Nar"); // String-param static method: Nar
        
        // Instance method references
        A obj = new A(); // Constructor call
        I1 ins1 = obj::bbc; // Matches no-param instance method
        I2 ins2 = obj::bbc; // Matches int-param instance method
        I3 ins3 = obj::bbc; // Matches String-param instance method
        
        ins1.m1(); // No-param instance method
        ins2.m1(15); // Int-param instance method: 15
        ins3.m1("Tech"); // String-param instance method: Tech
    }
}
```

Lab steps:
1. Define interfaces with different parameter signatures.
2. Create class `A` with overloaded constructors and methods.
3. Assign method references and observe compiler selecting correct overloads.
4. Run and verify outputs match expected signatures.

## Summary

### Key Takeaways
```diff
+ Method reference uses :: operator (double colon) to refer to existing methods or constructors
- Lambda expressions require -> but can include custom logic; method references cannot

+ Three types: static (Class::method), instance (obj::method), constructor (Class::new)
- Constructor reference syntax same as others but calls 'new' instead of method

+ Java 8 feature for functional programming style with less code
- Not a replacement for Lambda expressions - complements them

+ Automatically handles overloaded methods by matching functional interface signatures
- Compilation fails if no matching method/constructor exists

+ Compiler visualizes internally as Lambda expressions (e.g., A::m becomes (args) -> A.m(args))
- Always check parameter compatibility before use
```

### Expert Insight

#### Real-world Application
Method references are commonly used in Java Stream API operations for concise code, such as `list.stream().map(String::valueOf)` instead of `list.stream().map(s -> String.valueOf(s))`. In GUI development, they're used for event handlers (e.g., `button.setOnAction(this::handleClick)`). Large codebases benefit from method references to eliminate verbose Lambda expressions, improving maintainability without sacrificing performance.

#### Expert Path
Master method references by first understanding Lambda expressions thoroughly, then identify repetitive Lambda bodies (pure method calls) for conversion. Practice with Stream API transformations (`map`, `filter`) and Collections processing. Read open-source codebases like Spring Framework to see method references in action. Next, explore advanced topics like method references with generics and higher-order functions in functional interfaces.

#### Common Pitfalls and How to Avoid
- **Pitfall**: Using method reference when Lambda expression needs additional logic (e.g., logging before method call). **Avoid**: Always check if Lambda body is purely a single method invocation.
- **Pitfall**: NullPointerException with instance method references when object is null. **Avoid**: Ensure object initialization before reference creation.
- **Pitfall**: Overload confusion causing compilation errors. **Avoid**: Verify exact parameter matching with functional interface methods using IDE tools.
- **Pitfall**: Attempting method reference with void returns when interface expects non-void. **Avoid**: Understand return type compatibility (exceptions are optional matches).
- **Pitfall**: Misunderstanding constructor reference as object assignment instead of method implying = operator. **Avoid**: Remember constructor reference always implies `new`, never direct assignment.

Master.multiplied the noticing that there were several typos in the transcript, including "iner" instead of "inner", which have been corrected for accuracy. These corrections ensure the documentation is precise. Today's session date is 2024-01-12, as referenced in the model ID for CL-KK-Terminal. The student success stories highlight the importance of active participation and thorough preparation. For further study, refer to Java 8 documentation and practice with IDE debugging to visualize method reference resolutions. The evening session link was provided during class for additional coverage on functional interfaces.
