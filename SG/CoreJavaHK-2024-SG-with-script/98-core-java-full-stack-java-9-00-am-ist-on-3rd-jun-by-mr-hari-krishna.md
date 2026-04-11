# Session 98: String Handling

## Table of Contents

- [String Literals](#string-literals)
- [Creating String Objects](#creating-string-objects)
- [String Pooling](#string-pooling)
- [String Immutability](#string-immutability)
- [Printing String Objects](#printing-string-objects)

## String Literals

### Overview

String literals are fundamental constructs in Java, representing sequences of characters enclosed in double quotation marks. They serve as constant values that can be directly typed into source code and are handled as objects rather than primitive values, unlike integer or boolean literals.

### Key Concepts/Deep Dive

- **Definition**: A string literal is a sequence of characters placed in double quotation marks (e.g., `"Hari"`).
- **Object Nature**: Unlike primitive literals (e.g., `10`, `true`), string literals are objects, specifically instances of the `java.lang.String` class.
- **Memory Creation**: When a string literal is encountered in code, the JVM creates a String object in memory, even if no reference variable is explicitly used for storage.
- **Supported Literal Types in Java**:
  - Integer literals: `10`, `10L` (long)
  - Floating-point literals: `10.5`, `10.5F` (float), `10.0` (double)
  - Character literal: `'a'`
  - Boolean literals: `true`, `false`
  - String literals: `"Hari Krishnapart-2"`
  - Null literal: `null`
  - Class literal: Example, `String.class` - represents the `java.lang.Class` object for the String type.

```java
// Examples of various literals
int intLit = 10;
long longLit = 10L;
float floatLit = 10.5F;
double doubleLit = 10.0;
char charLit = 'a';
boolean boolLit = true;
String stringLit = "Hari Krishna";  // Object created
Class<String> classLit = String.class;  // Reference to Class object
```

### Code/Config Blocks

- **Direct Usage**:
  ```java
  System.out.print("Hari Krishna");  // Prints the string data
  ```

- **Storage in Variable**:
  ```java
  String s1 = "Hari Krishna";  // Creates String object and stores reference
  System.out.println(s1);  // Outputs: Hari Krishna
  ```

> [!NOTE]
> String literals are constants and are resolved at compile-time. They differ from expressions like `new String()`.

### Tables

| Literal Type     | Example      | Memory Allocation | Nature    |
|------------------|--------------|--------------------|-----------|
| Primitive (int)  | `10`         | No object created  | Value     |
| Primitive (long) | `10L`        | No object created  | Value     |
| Primitive (float)| `10.5F`      | No object created  | Value     |
| String           | `"Hari"`     | String object      | Object    |
| Null             | `null`       | --                 | Value     |
| Class            | `String.class`| Class object       | Object    |

### Lab Demos

**Demo 1: Printing String Literals**

- Step 1: Create a new class `Test01`.
- Step 2: Write code to directly print a string literal without storing it.

```java
public class Test01 {
    public static void main(String[] args) {
        System.out.print("Hari Krishna");  // Direct string literal usage
    }
}
```

- Step 3: Compile and run. Output: Hari Krishna.

**Demo 2: Storing and Printing String Literals**

- Step 1: Create a new class `Test02`.
- Step 2: Declare a String variable and assign a string literal.

```java
public class Test02 {
    public static void main(String[] args) {
        String s1 = "Hari Krishna";  // Stores reference to String object
        System.out.println(s1);  // Outputs: Hari Krishna
    }
}
```

- Step 3: Compile and run. Output: Hari Krishna.

## Creating String Objects

### Overview

Java provides two primary methods for creating String objects: using string literals (double quotes) and employing the `new` keyword with a constructor. Understanding the differences in object creation and memory implications is crucial for efficient programming.

### Key Concepts/Deep Dive

- **Two Approaches**:
  - **Literal Approach**: Using double quotes, e.g., `String s1 = "Hari Krishna";`.
  - **New Keyword Approach**: Using the `new` keyword and constructor, e.g., `String s2 = new String("Hari Krishna");`.
- **String Constructor Behavior**: The String constructor `new String(String str)` acts as a copy constructor, creating a deep copy of the provided String object's characters into a new object.

```java
String s1 = "Hari Krishna";  // Literal: 1 object
String s2 = new String("Hari Krishna");  // New keyword: 2 objects (literal + new)
```

### Code/Config Blocks

- **Literal Creation**:
  ```java
  String s1 = "Hari Krishna";  // Creates one String object in String Constant Pool
  ```

- **New Keyword Creation**:
  ```java
  String s2 = new String("NIT");  // Creates two objects: pool object and heap object
  ```

> [!IMPORTANT]
> The `new String(String)` constructor copies the characters from the argument string to the new object, ensuring they are distinct despite identical content.

### Tables

| Approach          | Objects Created | Memory Location(s) | Pooling Applied? | Example Code                      |
|-------------------|-----------------|---------------------|------------------|-----------------------------------|
| Literal          | 1              | String Constant Pool| Yes              | `String s = "Hari";`             |
| New Keyword      | 2 (literal + new)| Pool + Heap         | No               | `String s = new String("Hari");` |

### Lab Demos

**Demo 3: Comparing Object Creation Approaches**

- Step 1: Create a class to demonstrate object counts.
- Step 2: Use literal approach for one string, new keyword for another.

```java
public class ObjectDemo {
    public static void main(String[] args) {
        String s1 = "Hari";    // 1 object
        String s2 = new String("Hari");  // 2 objects
        System.out.println(s1 == s2);  // Outputs: false (different references)
    }
}
```

- Step 3: Compile and run. Output: false.

**Demo 4: Verifying Reference Equality**

- Step 1: Use repeated literals.
- Step 2: Compare references with `==`.

```java
public class ReferenceDemo {
    public static void main(String[] args) {
        String s1 = "NIT";
        String s2 = "NIT";  // Reuses pool object
        String s3 = new String("NIT");  // New heap object
        String s4 = new String("NIT");  // Another heap object
        System.out.println(s1 == s2);  // true: same pool reference
        System.out.println(s1 == s3);  // false: pool vs heap
        System.out.println(s3 == s4);  // false: different heap objects
    }
}
```

- Step 3: Compile and run. Outputs: true, false, false.

## String Pooling

### Overview

String pooling is a memory optimization technique in Java where String literals are interned in a special cache called the String Constant Pool Area. This prevents the creation of duplicate String objects for identical literals, promoting efficiency by reusing existing references.

### Key Concepts/Deep Dive

- **Definition**: When Java encounters a string literal, it checks if an identical string already exists in the String Constant Pool. If found, it reuses that object instead of creating a new one.
- **Scope**: Only string literals benefit from pooling. Objects created with `new` are not pooled and reside in the heap.
- **Memory Layout**: The pool is a collection within the heap area, holding string literals as they are encountered during runtime.
- **Benefits and Drawbacks**: Reduces memory usage by avoiding duplicates but prevents garbage collection of pooled objects, potentially causing memory bloat in applications creating many unique literals.

```java
String s1 = "TG";   // Creates pool object
String s2 = new String("TG");  // Copies from pool, no pooling for new object
String s3 = "TG";   // Reuses pool object
```

### Code/Config Blocks

- **Pooling Demonstration**:
  ```java
  String s1 = "Hyderabad";
  String s2 = "Hyderabad";  // Same reference as s1
  String s3 = new String("Hyderabad");  // Different object
  System.out.println(s1 == s2);  // true
  System.out.println(s1 == s3);  // false
  ```

### Tables

| Scenario                      | Pooling Applied? | Objects Created | Reference Reused? | Example Outcome |
|-------------------------------|------------------|------------------|-------------------|-----------------|
| First literal `"TG"`         | Yes              | 1 (pool)        | N/A               | Pool object created |
| Repeated literal `"TG"`      | Yes              | 0 (reuse)       | Yes               | Same reference returned |
| `new String("TG")`           | No               | 2 (pool + heap) | No                | New heap object |

### Lab Demos

**Demo 5: Visualizing Pooling**

- Step 1: Declare pool objects and new objects.
- Step 2: Demonstrate reference sharing.

```java
public class PoolingDemo {
    public static void main(String[] args) {
        String pool1 = "TS";      // Pool object created
        String pool2 = "TS";      // Reuses pool1
        String heap1 = new String("TS");  // New heap object
        String heap2 = new String("TS");  // Another heap object
        System.out.println(pool1 == pool2);  // true
        System.out.println(heap1 == heap2);  // false
        // Pooled objects are not GC-eligible after nulling references
    }
}
```

- Step 3: Compile and run. Outputs: true, false.

## String Immutability

### Overview

String objects in Java are immutable, meaning their internal state (character sequence) cannot be altered once created. Operations like concatenation return new String objects rather than modifying the original, ensuring thread-safety and predictability.

### Key Concepts/Deep Dive

- **Immutability Definition**: A String object's content is fixed post-creation. Methods that appear to modify it actually create and return new objects.
- **Variable vs. Object**: String variables are mutable (can be reassigned), but objects are immutable. Use `final` to make variables immutable.
- **Implications**: Enhances security (e.g., string constants in APIs) but may require careful management in performance-critical code.

```java
String s1 = "HK";
String s2 = s1.concat(" NIT");  // New object: "HK NIT"
System.out.println(s1);  // Still: "HK"
System.out.println(s2);  // "HK NIT"
```

### Code/Config Blocks

- **Concatenation Example**:
  ```java
  String original = "HK";
  String modified = original.concat(" NIT");  // Creates new String object
  // original remains "HK"
  ```

- **Making Variables Immutable**:
  ```java
  final String immutableVar = "NIT";
  // immutableVar = "Other";  // Compile error
  ```

### Tables

| Operation     | Modifies Original? | Returns New Object? | Example Result |
|---------------|---------------------|---------------------|----------------|
| `concat()`   | No                  | Yes                 | New string     |
| Reassignment | No (object unchanged)| No (reference change)| Variable points to new object |

### Lab Demos

**Demo 6: Demonstrating Immutability**

- Step 1: Perform concatenation and observe original object.
- Step 2: Show reassignment behavior.

```java
public class ImmutabilityDemo {
    public static void main(String[] args) {
        String s1 = "HK";
        String s2 = s1.concat(" NIT");
        System.out.println(s1);  // HK (unchanged)
        System.out.println(s2);  // HK NIT (new object)
        
        final String s3 = "Hyderabad";
        // s3 = "TS";  // Error: variable is immutable
    }
}
```

- Step 3: Compile and run. Outputs: HK, HK NIT.

## Printing String Objects

### Overview

When printing String objects using `System.out.println()`, Java implicitly invokes the `toString()` method, which returns the String's data rather than class name and hash code, due to method overriding in String class.

### Key Concepts/Deep Dive

- **toString() Override**: String class overrides `Object.toString()` to return the string content, enabling readable output.
- **Comparison with Custom Classes**: Non-overridden classes show `ClassName@HashCode`.
- **Benefits**: Facilitates debugging and logging by displaying meaningful data.

```java
String str = "Hari Krishna";
System.out.println(str);  // Outputs: Hari Krishna (data)
```

### Code/Config Blocks

- **Printing Override Comparison**:
  ```java
  public class Example {
      private int x = 15;
      // No toString() override
  }
  
  class Sample {
      private int x = 15;
      @Override
      public String toString() {
          return "" + x;
      }
  }
  
  public static void main(String[] args) {
      Example e = new Example();
      Sample s = new Sample();
      System.out.println(e);  // ClassName@hash
      System.out.println(s);  // 15
  }
  ```

### Tables

| Class Type    | toString() Overridden? | Output Example              |
|---------------|------------------------|----------------------------|
| String       | Yes                    | "Hari Krishna"             |
| Custom (no override) | No              | Example@1a2b3c             |
| Custom (override)    | Yes                    | "15"                       |

### Lab Demos

**Demo 7: Printing Behavior**

- Step 1: Create classes with and without `toString()` override.
- Step 2: Print objects.

```java
public class PrintDemo {
    public static void main(String[] args) {
        String str = "Session 98";
        Example ex = new Example();  // As defined above
        Sample sam = new Sample();   // As defined above
        System.out.println(str);     // Outputs: Session 98
        System.out.println(ex);      // Outputs: Example@hash
        System.out.println(sam);     // Outputs: 15
    }
}
```

- Step 3: Compile and run. Outputs as described.

## Summary

### Key Takeaways

```diff
+ String literals are objects of java.lang.String class, created implicitly in the String Constant Pool.
- New keyword creates additional heap objects, may lead to memory duplication without benefits.
+ String pooling reuses literal objects, reducing memory but preventing garbage collection.
- Immutability ensures data integrity but requires new object creation for modifications.
+ Printing leverages overridden toString() for readable data output.
+ Literal approach: Prefer for efficiency; new keyword: For explicit copying or overriding pooling.
```

### Expert Insight

#### Real-world Application
In production, use string literals for constants to enable pooling and reduce heap usage. For dynamic strings (e.g., user input concatenation), consider StringBuilder for mutable operations to avoid excessive object creation. In enterprise apps with thousands of unique strings, monitor pool size to prevent OutOfMemoryError due to non-GC eligible pooled objects.

#### Expert Path
Master interning with `String.intern()` for controlled pooling. Explore java.lang.invoke.StringConcatFactory for optimized concatenation. Deepen understanding by profiling memory usage in JVM tools like VisualVM, focusing on heap vs. pool allocation in high-throughput systems.

#### Common Pitfalls
- Assuming `==` compares content; use `equals()` for value comparison.
- Over-relying on literals without awareness of pool bloat in loop-generated strings.
- Confusion between variable reassignment (allowed) and object modification (immutable).
- Forgetting that `new String("literal")` bypasses pooling, creating unnecessary objects.
- Common Issues: Memory leaks from pooled strings in sessions; resolution: Use string deduplication JVM flags or batch process.
- Avoid: Excessive concatenation in loops; mitigation: Switch to StringBuilder early.

#### Lesser Known Things about This Topic
String literals are evaluated once per class load, making them efficient for shared constants. The String Constant Pool is per JVM and can be influenced by classloader isolation in web applications. Rarely used is `String.join()` for efficient multi-string concatenation compared to manual loops. Internally, strings use byte arrays (e.g., Latin-1 or UTF-16), compressible in dos Java 9+ for small strings, impacting memory footprint. Wi Corner cases: Empty string `""` is pooled; null handling differs from empty strings in comparisons.
