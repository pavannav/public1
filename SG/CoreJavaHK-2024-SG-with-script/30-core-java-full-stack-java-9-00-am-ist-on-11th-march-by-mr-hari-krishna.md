# Session 30: Operators Overview

## Overview
Java supports 40 official operators, categorized into 12 groups. These operators include symbols like assignment, equality, logical, bitwise, arithmetic, and more. Additionally, there are unofficial operators or separators that are often confused but are not considered operators per the Java Language Specification. Separators, such as dot (.), square brackets ([]), parentheses for casting, double colon (::), and diamond (<>), are used for syntax purposes like accessing members, array indexing, type conversion (casting), method references, and generic types. This session explores the classification of operators and separators, with a deep dive into the assignment operator, including rules for usage, casting for type conversion, and memory operations.

## Key Concepts/Deep Dive

### Operators Groups
Java operators are divided into 12 groups, totaling 40 operators. Here is the breakdown:

| Group Name                  | Number of Operators | Example Operators              | Description                                                                 |
|-----------------------------|---------------------|---------------------------------|-----------------------------------------------------------------------------|
| Assignment Operator         | 1                   | = (Single equal sign)          | Used for storing values or object references in variables.                |
| Equality Operators          | 2                   | == (Equality), != (Inequality) | Compare values for equality or inequality. Space or capitalization matters. |
| Logical Operators           | 3                   | && (Logical AND), || (Logical OR), ! (Logical NOT) | Perform logical operations. && is "AND &&", || is "OR ||", ! is "NOT !". |
| Bitwise Operators           | 5                   | & (AND), | (OR), ^ (XOR), ~ (Complement), << (Left Shift) | Manipulate bits directly. Includes logical XOR.                         |
| Bitwise Shift Operators     | 3                   | << (Left), >> (Right), >>> (Unsigned Right) | Shift bits left or right.                                                                 |
| Arithmetic Operators        | 5                   | + (Addition), - (Subtraction), * (Multiplication), / (Division), % (Modulus) | Basic mathematical operations.                                           |
| Conditional/Ternary Operator| 1                   | ? : (Question Mark, Colon)     | Conditional selection.                                                   |
| Relational Operators        | 4                   | < (Less Than), > (Greater Than), <= (Less or Equal), >= (Greater or Equal) | Compare values relationally.                                             |
| Increment/Decrement         | 2                   | ++ (Increment), -- (Decrement) | Add or subtract 1 from a variable.                                        |
| Other Compound Assignments  | 9                   | +=, -=, *=, /=, %=, &=, |=, ^=, <<=, >>=, >>>= | Compound assignment operators. |
| Type Test Operator          | 1                   | instanceof                     | Checks if an object is an instance of a type.                             |
| Lambda Operator             | 1                   | -> (Arrow)                     | Used for lambda expressions.                                              |

**Note:** Operators like `new` for object creation and `instanceof` for type checking are not included in the 40, but are still considered separately.

### Separators vs. Operators
While Java has 40 operators, some symbols are often mistaken for operators but are classified as separators in the Java Language Specification (JLS 21). These are not operators and are used for syntax punctuation:

| Separator       | Symbol | Usage                                                                 | Example Code Block                                           |
|-----------------|--------|-----------------------------------------------------------------------|-------------------------------------------------------------|
| Dot Separator   | `.`    | Separates class/package names from member names (fields/methods/objects). | ```java<br>class Example {<br>    int x = 10;<br>}<br>Example e = new Example();<br>e.x = 20;  // Dot separates object from member<br>``` |
| Square Brackets | `[]`   | Separates array variable names from index numbers. Used for creation and access. | ```java<br>String[] arr = new String[5];  // Array creation<br>arr[0] = "Hello";  // Access via index<br>``` |
| Parentheses     | `(data_type)` | Surround data types for explicit type conversion (casting). Converts source value to target type. | ```java<br>int i = (int) 10.5;  // Cast double to int (loses .5)<br>``` |
| Double Colon    | `::`   | Separates class/method names in method references or constructor calls (shortcut for lambda expressions). | ```java<br>Arrays.asList(1, 2, 3).forEach(System.out::println);  // Method reference<br>``` |
| Diamond         | `<>`   | Separates class names from generic type parameters in object creation (used in collections). | ```java<br>ArrayList<String> list = new ArrayList<>();  // Diamond separates class from type<br>``` |

**Important:** These separators are not operators. Referring to them as operators (e.g., "cast operator" for `(data_type)`) is unofficial and may confuse Java specification adherence. Always check the JLS for official classifications.

### Assignment Operator (=)
The assignment operator (=) is the most basic operator. It is unary in the sense that it takes one variable on the left and stores a value from the right.

#### Characteristics
- **Syntax:** `variable_name = value_or_expression;`
- **Binary Nature:** Takes two operands – left: variable (destination), right: value/expression (source).
- **Use:** Stores primitive values, object references, or results of expressions/methods in variables.
- **Operands Allowed:** Uses literals (e.g., numbers, strings), variables, non-void method calls, or expressions.

#### Rules for Usage
1. **Left Side Must Be a Variable:** Only variables can receive values. Literals (e.g., `10 = 20`) are invalid, causing "unexpected type" error.
2. **Source and Destination Types Must Be Compatible:** Types must be in the same group (e.g., numeric types). Incompatible types (e.g., boolean to int) cause "incompatible types" error.
3. **Source Range Must Be <= Destination Range:** Higher-range values (e.g., double) cannot directly store in lower-range variables (e.g., int), causing "possible lossy conversion" error. Use casting to force conversion.
4. **Casting for Incompatible Types:** Use cast operator (data_type in parentheses) for compatible types only. Cannot convert incomparable types (e.g., boolean to int).

#### Code Examples
```java
// Valid assignments
int i1 = 10;              // Literal
String s1 = "HK";         // String literal
Example e1 = new Example();  // Object reference

// Invalid: left side must be variable
// 10 = 20;  // Error: unexpected type

// Invalid: incompatible types
// int i2 = true;  // Error: incompatible types

// Invalid: range issue
// int i3 = 10.5;  // Error: possible lossy conversion

// Valid with casting (compatible types)
int i4 = (int) 10.5;      // Cast double to int (becomes 10)
```

#### Memory Operations
- Variable declaration creates memory space.
- Assignment stores value/reference in that space.
- Example: `int i = 10;` → Creates memory for `i`, stores 10.

#### Advanced Usage
- **Multiple Assignments:** Chain in one statement: `int i1, i2, i3; i1 = i2 = i3 = 50;` (water flow: 50 → i3 → i2 → i1).
- **In Expressions:** Used as sub-expressions. Performs store then substitute. Example: `int x = 20 + (y = 30);` → Stores 30 in y, substitutes 30, adds 20, stores 50 in x.
- **Method Arguments:** `someMethod(i = 10);` → Assigns 10 to i, then passes 10 as argument.

## Summary

### Key Takeaways
```diff
+ Java supports 40 official operators divided into 12 groups, with separators (dot, brackets, etc.) not considered operators per JLS 21.
+ Assignment operator (=) is binary, used for storage, with strict rules on types, ranges, and casting.
- Confusing separators (e.g., dot as "dot operator") can lead to specification inaccuracies.
+ Always verify operator classifications using Java Language Specification documentation.
```

### Expert Insight
**Real-world Application:** In production Java code (e.g., Spring Boot services), assignment operators handle configuration loading from properties files (e.g., `port = Integer.parseInt(prop.getProperty("port"))`). Casting ensures type safety when parsing user inputs or API responses, preventing runtime errors like ClassCastException.

**Expert Path:** Master operators by practicing with JRE tools like `javac` for compile-time checks and `java` for runtime behavior. Study bytecode via `javap` to understand operator implementations. Focus on compound assignments and lambda expressions for advanced functional programming.

**Common Pitfalls:**
- **Misidentifying Separators:** Calling dot/parentheses "operators" leads to confusion in interviews or peer reviews. Always reference JLS 21 Chapter 3 (Lexical Structure) for tokens.
  - Resolution: Run a quick grep in codebases for usage patterns; test in Oracle's online compiler for official errors.
- **Lossy Conversions Without Casting:** Skipping casting for range mismatches (e.g., double to int) causes silent data loss (e.g., 10.5 becomes 10).
  - Resolution: Add explicit casts `(int) doubleValue`, and validate with unit tests checking expected vs. actual values.
  - Avoidance: Use wrapper classes (e.g., `BigDecimal`) for precise numeric handling, or add pre-assignment validations.
- **Chained Assignments Order:** `a = b = c = value` flows left-to-right, but assuming equal distribution can overwrite values unexpectedly.
  - Resolution: Break into separate statements for clarity; debug with print statements showing each assignment step.
  - Avoidance: Prefer immutable assignments in functional styles to reduce side effects.
- **Casting Incompatible Types:** Attempting cast between incomparable types (e.g., `boolean` to `int`) fails at compile-time with cryptic errors.
  - Resolution: Check type groups (primitive vs. object, numeric vs. boolean). Use reflection or type guards for dynamic casting.
  - Lesser Known Thing: Lesser-known operators like bitwise XOR (^) are rarely used outside low-level coding (e.g., encryption), but understanding them elevates expertise in performance-critical code. Practice with bit-manipulation libraries like `BitSet`.
