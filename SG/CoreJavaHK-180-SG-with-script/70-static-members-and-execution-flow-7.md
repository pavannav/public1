# Session 70: Static Members and Execution Flow

## Table of Contents
- [Static Members Execution Flow in Single and Multiple Classes](#static-members-execution-flow-in-single-and-multiple-classes)
- [Compiler Changes to Static Members](#compiler-changes-to-static-members)
- [Executing Classes Without Main Method](#executing-classes-without-main-method)
- [Illegal Forward Reference](#illegal-forward-reference)

## Static Members Execution Flow in Single and Multiple Classes

### Overview
This section covers how static members—variables, blocks, and methods—are initialized and executed when a Java class is loaded by the JVM. The execution follows a strict order: static variables are allocated memory (initialized to default values), then initialized with assigned values, followed by static blocks, and finally the main method (if invoked).

### Key Concepts/Deep Dive
- **Class Loading Triggers**: 
  - Loading occurs when running `java Example` (loads the class, executes static members, and runs main).
  - Accessing a member (e.g., `Example.a`) loads the class without running main, but still executes static variables and blocks.
- **Execution Order**:
  1. Allocate memory for all static variables (default values).
  2. Initialize static variables from top to bottom.
  3. Execute static blocks from top to bottom.
  4. Execute main method (only if class is run directly).
- **Key Point**: Main method executes only once per run. Static variables and blocks execute once per class loading.
- **Multiple Classes**: Accessing another class's static member triggers its loading in the same order.

### Code/Config Blocks
```java
class Example {
    static int a = 10;
    static {
        System.out.println("SB");
    }
    public static void main(String[] args) {
        System.out.println("Main");
        System.out.println("a = " + a);
    }
}

class Sample {
    static int d = 50;
    static {
        System.out.println("SA SB1");
        System.out.println("a = " + Example.a);  // Class Example loads here
        System.out.println("d = " + d);
    }
    public static void main(String[] args) {
        System.out.println("SA Main");
        System.out.println("b = " + Example.b);  // Example.b is 20
    }
}
```

### Tables
| Member Type   | Execution Count | When Executed                  |
|---------------|-----------------|-------------------------------|
| Static Variable | 1 per class load | During initialization        |
| Static Block   | 1 per class load | After variable init          |
| Main Method    | 0 or 1         | Only if class run directly   |
| Static Method  | 0 or more      | Only when called             |

### Lab Demos
1. Run `java Example`:
   - Output: `SB`, `Main`.
   - Reason: Static block and main execute after loading.

2. Run `java Sample`:
   - Output: `SA SB1`, `a = 10`, `d = 50`, `SA Main`, `b = 20`.
   - Steps:
     - Load Sample class.
     - Allocate `d = 50`.
     - Execute static block: Prints SA SB1, loads Example (allocates a=10, prints SB), prints a=10, d=50.
     - Execute main: Prints SA Main, prints b=20 (which is now loaded).

3. Run `java StaticExample` (new class accessing Example.a):
   - Output: `SB`, `a = 10`.
   - Steps: Load StaticExample, access Example.a, load Example (execute static vars/blocks), retrieve a.

## Compiler Changes to Static Members

### Overview
The Java compiler optimizes static members during compilation, such as moving static variable initializations into static blocks and merging multiple static blocks.

### Key Concepts/Deep Dive
- If a static variable has initialization, the compiler creates an implicit static block.
- Multiple static blocks are merged into one.
- Implicitly adds class name prefix for static variable access.

### Code/Config Blocks
```java
class Example {
    static int a;
    static {
        a = 10;  // Compiler adds this if not present and a = 10;
    }
    static {
        System.out.println("SB1");
    }
    static {
        System.out.println("SB2");
    }
}
// Compiler merges to:
// static {
//     a = 10;
//     System.out.println("SB1");
//     System.out.println("SB2");
// }
```

### Lab Demos
- Compile above code: Merged static block executes as one.
- Output when run: `10`, `SB1`, `SB2`.

## Executing Classes Without Main Method

### Overview
From Java 6 to Java 11, there are version-specific rules for running classes without a main method using static blocks or JavaFX.

### Key Concepts/Deep Dive
- **Java 6**: Can run via static block (ignores main), but throws exception after.
- **Java 7**: Checks for main first; if absent, throws error without executing static members.
- **Java 8**: Suggests extending JavaFX Application if main absent.
- **Java 11+**: JavaFX removed; must install separately.

### Tables
| Java Version | Can Run Without Main? | Behavior |
|--------------|------------------------|----------|
| 6          | Yes (static block)    | Executes static block, then throws exception |
| 7          | No                   | Throws error directly |
| 8          | Yes (JavaFX extend)  | Executes static/FX flow |
| 9-10       | Same as 8            | -      |
| 11+        | Yes (with FX install)| Requires separate JavaFX setup |

### Code/Config Blocks
```java
class Example {
    static {
        System.out.println("SB");
        // Up to Java 6: Executes, then exception
        // Java 7+: Error without main
    }
    // For Java 8: extends javafx.application.Application
    public void start(Stage stage) {}
}
```

### Lab Demos
1. Java 6: Run `java Example` -> Output `SB`, then exception.
2. Java 7: Run `java Example` -> Error "Main method not found".
3. Java 8: Extend JavaFX -> Executes without main, with `start()`.

## Illegal Forward Reference

### Overview
Attempting to read a static variable before its declaration/initialization in a static context throws a compile-time error.

### Key Concepts/Deep Dive
- Applies only to reading; modifying is allowed.
- Solution: Use `ClassName.var` or wait until after declaration.
- Example: In static block, reading `b` before `b = 20` (if `b` declared after).

### Code/Config Blocks
```java
class Example {
    static int a = 10;
    static {
        System.out.println("a = " + a);  // OK
        // System.out.println("b = " + b);  // Error: Illegal forward reference
    }
    static int b = 20;
}
// Fix: Use Example.b
```

### Lab Demos
- Try compiling: Error on `b`.
- Fix: `Example.b = 50;` - Compiles, output shows initialization order.

## Summary

### Key Takeaways
```diff
+ Static members execute once per class load: Variables -> Blocks -> Main (if any).
+ Main method runs only when class is invoked directly.
+ Class loading triggered by access or java command.
+ Compiler merges static blocks and adds class prefixes.
+ Without main, behavior depends on Java version.
- Illegal forward reference prevents premature reads; use ClassName.var to fix.
! Forward reference applies to reads within static contexts before declaration.
```

### Expert Insight
#### Real-world Application
In enterprise apps, static blocks initialize configs (e.g., DB connections) on class load. Use this to ensure resources load once, avoiding redundant setups in multi-threaded environments.

#### Expert Path
Master by visualizing JVM (method area, heap). Practice with multiple classes (e.g., Spring beans). Study JDK changes for certification.

#### Common Pitfalls
- Assuming main always runs—wrongs for accessed classes.
- Ignoring version differences—test on target JDK.
- Forward reference errors—common in rushed code; always `ClassName.var` for early access.
- Lesser known: Static methods don't trigger class loading unless called; variables do when accessed.

Mistakes in transcript and corrections:
- "sj" corrected to "SB" (Static Block) in text.
- "m1" corrected to "M1" for methods.
