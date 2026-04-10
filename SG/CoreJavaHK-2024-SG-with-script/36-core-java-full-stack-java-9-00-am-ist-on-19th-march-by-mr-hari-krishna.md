# Session 36: Core Java & Full Stack Java Operators (Logical and Bitwise)

## Table of Contents
- [Equality Operators for Primitive Types vs. Objects](#equality-operators-for-primitive-types-vs-objects)
- [Logical Operators](#logical-operators)
- [Operator Precedence](#operator-precedence)
- [Bitwise Operators Introduction](#bitwise-operators-introduction)
- [Summary](#summary)

## Equality Operators for Primitive Types vs. Objects

### Overview
This section builds on the previous class where we covered operators up to equality. The equality operator (`==`) is used to compare values, but its behavior differs significantly between primitive types and objects. For primitive types, it directly compares values. For objects, including strings, arrays, and class instances, it compares object references, not the actual data they contain.

### Key Concepts/Deep Dive
- **Primitive Types Comparison**:
  - When comparing primitive values (e.g., `int`, `char`, `boolean`), the `==` operator checks if the actual values are equal.
  - Example: `int a = 5; int b = 5;` then `a == b` returns `true` because the values are the same.
  
- **Objects Comparison**:
  - For objects (e.g., strings, arrays, class objects), `==` compares memory references, not the content.
  - Example erroneeous in transcript: Two strings with the same text `"hello"` will return `false` if they are different objects in memory, even though their data is identical.
  - This can lead to unexpected behavior, such as comparing two strings created separately.

- **Using `.equals()` Method**:
  - To compare objects by their data (content), use the predefined `.equals()` method.
  - Syntax: `object1.equals(object2)`
  - For strings, this checks the actual string content.
  - Reference: Volume 2 textbook, Java Library, Chapter 2.
  - Example: `"hello".equals("hello")` returns `true` regardless of whether they are the same object.

- **Restrictions on Equality Operators**:
  - Equality operators can be used on all types of operands, but for non-primitives, reference comparison is the default.
  - Two arrays: `==` compares references, not elements.
  - Two class objects: Same reference behavior.

> [!IMPORTANT]  
> Always use `.equals()` for content-based comparison of objects; `==` only works for primitives or reference equality.

### Code/Config Blocks
Here's an example program demonstrating equality operators:

```java
public class EqualityDemo {
    public static void main(String[] args) {
        int a = 5;
        int b = 5;
        System.out.println(a == b);  // true (primitive value comparison)

        String s1 = new String("hello");
        String s2 = new String("hello");
        System.out.println(s1 == s2);  // false (reference comparison)
        System.out.println(s1.equals(s2));  // true (content comparison)
    }
}
```

Output:
```
true
false
true
```

## Logical Operators

### Overview
Logical operators are used to combine boolean conditions and produce a final boolean result (true or false). There are three main logical operators: AND (`&&`), OR (`||`), and NOT (`!`). These concatenate two or more boolean conditions.

### Key Concepts/Deep Dive
- **AND Operator (`&&`)**:
  - Concatenates two or more boolean conditions.
  - Result is `true` only if both operands are `true`. Otherwise, `false`.
  - Truth Table:
    | Operand 1 | Operand 2 | Result |
    |-----------|-----------|--------|
    | true      | true      | true   |
    | true      | false     | false  |
    | false     | true      | false  |
    | false     | false     | false  |

  - Short-circuiting: If the first operand is `false`, the second operand is not evaluated (result is `false` anyway).
  - Example: Checking if a number is between 5 and 10: `int num = 7; System.out.println(num >= 5 && num <= 10);` → `true`.

- **OR Operator (`||`)**:
  - Result is `true` if at least one operand is `true`.
  - Short-circuiting: If the first operand is `true`, the second operand is not evaluated (result is `true` anyway).
  - Example: Checking if a number is outside 5 to 10: `System.out.println(num <= 5 || num >= 10);`.

- **NOT Operator (`!`)**:
  - Reverses the boolean value: `true` becomes `false`, `false` becomes `true`.
  - Used as a unary operator.
  - Example: `!true` → `false`.

- **Result Type**:
  - Always `boolean`.
  - Cannot apply to numbers, characters, strings, arrays, or class objects (compilation error).

### Code/Config Blocks
Find the outputs from these programs:

1. `System.out.println(5 && 6);` → Compile-time error: bad operand types.

2. Full program example with methods:

```java
public class LogicalDemo {
    static boolean m1() {
        System.out.println("from m1");
        return false;
    }
    
    static boolean m2() {
        System.out.println("from m2");
        return true;
    }
    
    public static void main(String[] args) {
        System.out.println(m1() && m2());  // from m1, false (short-circuit)
        
        System.out.println(m1() || m2());  // from m1, from m2, true
        
        boolean available = true;
        if (!available) {
            System.out.println("hi");
        }  // No output since !true is false
        
        int i = 2;
        if (i++ == 1 && i-- == 1) {
            System.out.println("hi");
        } else {
            System.out.println("hello " + i);
        }  // hello 1
    }
}
```

Output:
```
from m1
false
from m1
from m2
true
hello 1
```

- In `m1() && m2()`, "from m1" prints, returns `false`, second operand not executed → `false`.
- In `m1() || m2()`, "from m1" prints, returns `false`, second operand executed → "from m2", `true` OR `false` → `true`.
- Prefix/postfix is not covered in depth here; refer to increment/decrement operators.

## Operator Precedence

### Overview
Logical operators have different precedence levels, affecting evaluation order. Unary operators (like `!`) have higher precedence than binary operators (`&&`, `||`).

### Key Concepts/Deep Dive
- **Order of Evaluation**:
  - NOT (`!`) executed first.
  - Then AND (`&&`).
  - Then OR (`||`).
- **Using Parentheses**: To change precedence, use `()`.
- **Example Evaluation**:
  - `false || false && true` → `false || (false && true)` → `false || false` → `false`.
  - `!(true && false)` → `!false` → `true`.

### Code/Config Blocks
```java
public class PrecedenceDemo {
    public static void main(String[] args) {
        boolean result1 = false || false && true;  // false
        boolean result2 = !(true && false);       // true
        System.out.println(result1);  // false
        System.out.println(result2);  // true
    }
}
```

Output:
```
false
true
```

## Bitwise Operators Introduction

### Overview
Bitwise operators perform operations at the bit level. There are four main ones: AND (`&`), inclusive OR (`|`), exclusive OR (`^`), and bitwise complement (`~`). These will be covered in the next class in more detail (approximately 15 minutes).

### Key Concepts/Deep Dive
- `&`: Bitwise AND.
- `|`: Bitwise inclusive OR.
- `^`: Bitwise exclusive OR (XOR).
- `~`: Bitwise complement.

No deep dive or examples provided in this transcript; reserved for next session.

## Summary

### Key Takeaways
```diff
+ Equality for primitives: Direct value comparison using ==
+ Equality for objects: Reference comparison with ==; use .equals() for data
+ Logical AND (&&): True only if both operands true; short-circuits on false first operand
+ Logical OR (||): True if at least one operand true; short-circuits on true first operand
+ Logical NOT (!): Reverses boolean value; unary operator with highest precedence
+ Operator Precedence: ! > && > ||
+ Cannot apply logical operators to non-boolean types (compile error)
- Avoid using == for string content comparison; always .equals()
```

### Expert Insight
**Real-world Application**: In Java applications, logical operators are crucial for conditional logic, such as validating user inputs (e.g., age between 18-65 using `&&`) or handling fallback scenarios with `||`. For object comparisons, `.equals()` is essential in data validation, API responses, or database queries to ensure content equality.

**Expert Path**: Master short-circuit evaluation to optimize performance—avoid side-effect-heavy methods as second operands in `&&`/`||`. Practice with truth tables and precedence rules. Study bitwise operators for low-level optimizations in embedded systems or performance-critical code.

**Common Pitfalls**: 
- Misusing `==` for objects leads to bugs (e.g., string comparisons).
- Ignoring short-circuiting can cause unexpected side effects (e.g., not executing necessary code).
- Forgetting parentheses in complex expressions results in wrong evaluation order.
- Applying logical ops to non-booleans causes compile errors—always ensure boolean operands.
- Lesser known: `&&`/`||` short-circuit, but `&`/`|` do not: Use bitwise only for bits, never for logic.

**Notifications on Transcript Mistakes and Corrections**:
- "htp" corrected to "http" where mentioned in prior context, but not present here.
- "equality operator for comparison? Both are equal or not. Can I use can I say two primitive values equal or not?" → Clarified as "equality operators (== and !=)".
- "operates" → "operands".
- "boole" → "boolean".
- "citetel" → "single ampersand (&)".
- "double N comma double N is simply you have to write comma double R and not not" → "&&, ||, !".
- "but when you compare objects directly values of the object comparator reference comparator" → "compares references, not values".
- Various repetitions and typos like "boole" → "boolean", "operaten" → "operators", "predefined method called equals parenthesis equals parenthesis" corrected to `.equals()`.
- "Volume 2 textbook. Java library. Second chapter. Okay." → Consistent formatting and capitalization.
- Short-circuit explanations had redundancies; streamlined for clarity.
- "then why second operent to execute waste" → "operand".
- Truth table references had minor wording errors; corrected to standard format.
- Code examples had "boolan" → "boolean".
- Logical NOT examples like "not between" corrected for clarity.
