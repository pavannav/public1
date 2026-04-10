# Session 14: Comments and Java Tokens

## Table of Contents
- [Comments](#comments)
- [Identifiers](#identifiers)
- [Keywords](#keywords)
- [Summary](#summary)

## Comments

### Overview
Comments in Java are special syntax elements used for documenting code. They provide description and can be used to ignore certain parts of the code during compilation. Comments help programmers understand the purpose of classes, variables, and methods, and can span single lines or multiple lines.

### Key Concepts/Deep Dive
- **Purpose of Comments**:
  - **Ignore Compiling Part**: Comments allow specific code to be excluded from compilation.
  - **Provide Description**: Used to explain the purpose of programming elements like classes, variables, and methods.
- **Types of Comments**:
  - **Single Line Comment**: Ignores one line of code. Syntax: `// comment`.
    - Example:
      ```java
      int a = 10; // This is a variable
      ```
  - **Multi-Line Comment**: Ignores multiple lines. Syntax: `/* comment */`.
    - Example:
      ```java
      /*
      This is a multi-line comment
      Spanning multiple lines
      */
      int b = 20;
      ```
  - **Documentation Comment**: Provides detailed description for programming elements. Syntax: `/** comment */`.
- **Usage Guidelines**:
  - Single-line and multi-line comments can be used anywhere to comment out code or logic.
  - Documentation comments are typically placed outside classes, methods, etc., to describe elements like class purpose and method functionality.
- **Real-Time Example**:
  - Used in projects to document API classes, variables, and methods for better maintainability.
- **Lab Demo**:
  - Create a Java program with a class, variable, and method, using each type of comment above and below the elements. Compile and run to verify compilation ignores comments.
    ```java
    /**
     * This is a demo class to illustrate comments.
     */
    public class CommentsDemo {
        // Single-line comment
        int a = 10; /* Multi-line
        comment */
        void m1() {}
    }
    ```
    Compile with `javac CommentsDemo.java` in command prompt. Ensure no compilation errors occur due to comments.

### Code/Config Blocks
```java
public class Example {
    // Single-line comment
    int a = 10;
    /*
    Multi-line comment
    */
    void m1() {}
}
```

### Tables
| Comment Type | Syntax | Purpose |
|--------------|--------|---------|
| Single-Line | // comment | Ignores one line |
| Multi-Line | /* comment */ | Ignores multiple lines |
| Documentation | /** comment */ | Provides description for elements |

## Identifiers

### Overview
Identifiers in Java are names given to programming elements such as classes, variables, and methods. They enable identification, accessing, and executing these elements from other parts of the program. Without identifiers, elements cannot be called or referenced.

### Key Concepts/Deep Dive
- **Definition**: A name of a programming element (class, variable, method).
- **Purpose**:
  - Identification and finding elements from other programs.
  - Calling and executing logic or accessing values.
- **Compile-Time Errors Without Identifiers**:
  - Attempting to create a class, variable, or method without a name results in "Identifier expected" error.
- **Rules for Creating Identifiers** (7 rules):
  1. **Must contain only letters (a-z, A-Z), digits (0-9), and special characters ($ and _)**.
  2. **Cannot start with a digit** (can use digits from second position onward).
  3. **Cannot contain special characters except $ and _**.
  4. **Cannot have spaces in between words** (use _ as connector).
  5. **Case-sensitive** (e.g., 'a' ≠ 'A').
  6. **Cannot use keywords or reserved words** (but predefined class/variable/method names can be used).
  7. **From Java 9 onwards, single underscore (_) cannot be used as an identifier**.
- **Valid Examples**:
  - `abc`, `abc123`, `abc_123`, `abc$123`.
- **Invalid Examples**:
  - `123abc` (starts with digit), `abc#123` (invalid special char), `student one` (space).
- **Accessing Elements Using Identifiers**:
  - Use dot operator (.) for accessing inside classes/objects.
- **Length Rule**: No limit on identifier length, but readability is important (avoid overly long names).
- **Java 9 Enhancement**: Single `_` reserved; use combinations like `__` or `_abc`.

### Code/Config Blocks
```java
// Example program with identifiers
public class Example {
    int a = 10;  // Identifier 'a'
    void m1() {  // Identifier 'm1'
    }
}
// Accessing from another class
class Test {
    public static void main(String[] args) {
        Example e = new Example();
        e.m1();  // Using identifier 'm1'
    }
}
```
Compile with `javac Example.java Test.java`.

### Tables
| Rule Number | Rule Description | Example (Valid/Invalid) |
|-------------|-----------------|--------------------|
| 1 | Letters, digits, $, _ only | Valid: `abc`, `abc123`, `abc$` |
| 2 | Cannot start with digit | Invalid: `1abc`; Valid: `abc1` |
| 3 | No other special chars | Invalid: `abc#`; Valid: `abc_` |
| 4 | No spaces | Invalid: `student age`; Valid: `student_age` |
| 5 | Case-sensitive | `age` ≠ `Age` |
| 6 | No keywords | Invalid: `static` (keyword); Valid: `String` (predefined class) |
| 7 | No single _ from Java 9 | Invalid: `int _ = 1`; Valid: `int __ = 1` |

### Lab Demos
- **Demo 1**: Create a class without a name and attempt to compile (shows "Identifier expected").
  ```java
  class {
      int a;
  }
  ```
  Result: Compilation error.
- **Demo 2**: Create valid/invalid identifiers and check compilation.
  ```java
  // Valid
  int student_No_1 = 10;
  // Invalid (space)
  // int student one = 10; // Error
  ```
  Use `javac filename.java` to test.

## Keywords

### Overview
Keywords are predefined identifiers with special meanings in Java, performing unique operations. They are reserved and cannot be used as user-defined identifiers.

### Key Concepts/Deep Dive
- **Definition**: Predefined identifiers reserved in Java with special meanings, each performing a unique operation.
- **Examples**: `class`, `public`, `static`, `int`, etc. (`String` is a predefined class name, not a keyword).
- **Total Keywords**: Java has 51 keywords.
- **Comparison with Identifiers**: Keywords are specific reserved words; identifiers are user/names given to elements.
- **Usage**: Essential for core Java syntax (e.g., `class` for defining classes, `static` for memory allocation).

### Code/Config Blocks
```java
public class KeywordExample {
    static int a = 10;  // 'static' and 'int' are keywords
}
```

### Tables
| Category | Examples | Description |
|----------|----------|-------------|
| Basic Keywords | `class`, `public`, `static`, `void`, `int` | Core syntax for classes, visibility, etc. |
| Control Flow | `if`, `else`, `for`, `while`, `switch` | For program flow control |
| Modifiers | `public`, `private`, `static`, `final` | Access and behavior modifiers |

### Lab Demos
- Attempt to use a keyword as a variable name (e.g., `int static = 10;`) – results in compilation error "identifier expected".

## Summary

### Key Takeaways
```diff
+ Comments provide documentation and allow code exclusion without affecting compilation.
+ Identifiers are unique names for programming elements, following specific rules for valid formation.
- Misusing keywords as identifiers leads to compile-time errors.
+ Java 9 introduced restrictions on single underscore as an identifier.
! Identifiers ensure elements can be accessed and executed across a program.
```

### Expert Insight
- **Real-world Application**: In large-scale projects, identifiers enable modular code organization, allowing different teams to reference shared classes/variables. Comments with documentation tools like Javadoc generate API docs for production systems.
- **Expert Path**: Master all 51 Java keywords by the end of this session; practice creating identifier-heavy code in frameworks like Spring Boot. Visualize rules while coding for quick validation.
- **Common Pitfalls**: Ignoring case sensitivity leads to runtime bugs (e.g., `String` vs `string`). Using spaces or invalid characters causes compilation failures. Overly long identifiers reduce readability – balance clarity and brevity.
  - Common issues: Confusing reserved words with predefined classes (e.g., `String` is usable as identifier, unlike `static`). Resolution: Consult official Java keyword list for validation; avoid single `_` in Java 9+.
  - Lesser known things: Java allows very long identifiers, but in practice, IDEs like IntelliJ auto-suggest better naming (e.g., camelCase over underscores for better readability).

Mistakes in transcript corrected: "enm record" to "enum record"; "static void wide" to "static void main"; minor typos like "htp" not present.
