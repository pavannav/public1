# Session 31: Core Java Full Stack Java March 12th

1. [Types of Operators in Java](#types-of-operators-in-java)
2. [Assignment Operator Deep Dive](#assignment-operator-deep-dive)
3. [Arithmetic Operators](#arithmetic-operators)

## Types of Operators in Java

### Overview
Java supports operators that perform various operations. Based on functionality, Java has three main types of operators: assignment operators, validation operators, and calculation operators. Additionally, based on the number of operands, there are unary, binary, and ternary operators. The instructor clarifies that Java has approximately 40 operators, grouped into 12 major categories including assignment, arithmetic, increment/decrement, relational, and logical operators. A common interview question is "How many types of operators in Java?" but the exact categorization depends on context.

### Key Concepts/Deep Dive
- **Division by Functionality**: 
  - Assignment operator (stored value operators).
  - Validation operator.
  - Calculation operator.

- **Division by Operands**:
  - Unary operator (one operand).
  - Binary operator (two operands).
  - Ternary operator (three operands).

- **Total Operators**: Around 40, not 45. Missing ones include dot (.), square bracket ([]), double colon (::), cast operator (called separators), crooked arrow operator.

- **Group Functionality**: 12 groups including assignment operator, arithmetic operators, increment operators, relational operators, logical operators.

💡 Note: The answer depends on the context of the question. For interviewers focusing on functionality, mention the three main types based on function. For operand-based, mention three based on operands.

> [!IMPORTANT]
> Clarify categorization based on interview context to avoid confusion.

## Assignment Operator Deep Dive

### Overview
The single equal to (=) is the assignment operator used for storing values in variables. It can store literals, objects, variables, expressions, or non-void method calls on the right side, and must have a variable on the left side. Compatible types are required, with source type range ≤ destination type range. Assignment operator has low precedence (executes last) and associativity right-to-left. It returns the stored value, with result type based on the destination variable type.

### Key Concepts/Deep Dive
- **Rules**:
  - Left side must be a variable name; declaration required first.
  - Right side: literal, object reference, variable, expression, non-void method call.
  - Types must be compatible; source range ≤ destination range.
  - Cast operator required for incompatible types or larger ranges.

- **Usage in Declarations**: Can use assignment in variable declaration statements or as standalone statements.

- **Multiple Assignments**: In single expression, data type only for first variable.
  ```bash
  int i1 = i2 = i3 = 50;   # Allowed, data type only for first
  ```

- **Declaration Restrictions**: Cannot declare variables after assignment in same expression.

- **Precedence and Associativity**: Least priority (executes after other operators); right-to-left associativity.

- **Combination with Other Operators**: Default precedence applies (assignment last); use brackets to prioritize assignment.
  ```bash
  int i9 = 60 + (i8 = 20);  # Evaluates: 20 stored in i8, then 60 + 20 = 80 stored in i9
  ```

- **Result Type**: Depending on destination variable type (int for int, boolean for boolean, etc.).

- **Operand Types**: All primitive types (byte, short, int, long, float, double, char, boolean), strings, arrays, objects.

⚠ Note: Assignment operator both stores and returns the value, enabling chains like `int x = y = 10;`.

### Code/Config Blocks
```java
class AssignmentExample {
    public static void main(String[] args) {
        int i1 = 10;
        System.out.println(i1 = 20);  // Output: 20
        
        byte b = 100;
        int castInt = (int) b + 50;  // Allowed with cast
        
        double d = i1 = 20;  // i1 gets 20, d gets 20.0
    }
}
```

| Left Side | Right Side | Compatible | Returns | Example Output |
|-----------|------------|------------|---------|----------------|
| Variable  | Literal/Value | Yes (compatible types) | Value of type | 20 |
| Variable  | Expression | Yes (result compatible) | Value of type | 80 |
| Variable  | Object/Reference | Yes | Reference | Example@hashCode |
| Variable  | Method Call (non-void) | Yes | Method return | N/A |

### Lab Demos
- **Rule Check**: `int i4 = 60;` compile error if no declaration.  
  Evaluation: Direct store.

- **Cast Example**: `int a = (int) 10.5;` Output: 10 (fraction discarded).  
  `byte b = (byte) 500;` Output: -12 (overflow due to range).

- **Multiple Assignment**: `int i1 = i2 = i3 = 50;` Valid, single expression initialization.

- **Precedence Demo**: `int i = 80 + (i9 = 20);` First stores 20 in i9, then 80 + 20 = 100 in i.

- **Result Type**: Prints after assignment show returned value (e.g., 97 for int, 'a' for char).

## Arithmetic Operators

### Overview
Arithmetic operators perform mathematical calculations including addition (+), subtraction (-), multiplication (*), division (/), and modulo (%). They primarily work on numbers and characters, with results being numbers. Division and modulo return quotient and remainder respectively. Plus (+) is overloaded: for numbers/characters it adds, for strings it concatenates.

### Key Concepts/Deep Dive
- **Operators**:
  - +: Addition for numbers/characters; concatenation for strings.
  - -: Subtraction for numbers/characters.
  - *: Multiplication for numbers/characters.
  - /: Division for numbers/characters, returns quotient.
  - %: Modulo for numbers/characters, returns remainder.

- **Overloaded Plus**: 
  - If both operands numbers/characters: Addition.
  - If at least one operand is string: Concatenation (other types convert to string).
  - Example: `10 + 20` → 30; `"10" + 20` → "1020".

- **Precedence**: *, /, % higher than +, - (same level left-to-right).

- **Result Types**: Numbers for +, -, *, /, %. No string results for -, *, /, %.

### Code/Config Blocks
```java
class ArithmeticExample {
    public static void main(String[] args) {
        System.out.println(20 + 5);      // 25
        System.out.println(20 - 5);      // 15
        System.out.println(20 * 5);      // 100
        System.out.println(20 / 5);      // 4
        System.out.println(20 % 5);      // 0
        
        System.out.println("10" + 20);   // "1020" (string concatenation)
        System.out.println(10 + "20");   // "1020"
        System.out.println(10 + 20 + "30"); // "3030" (first add, then concat)
        System.out.println("10" + 20 + 30); // "102030" (concat after first string)
        
        // Precedence: + and - same priority, left-to-right
        int a = 10, b = 20;
        System.out.println(a + b);       // 30
        System.out.println(a + "-" + b); // "10-20"
        
        // Invalid: Cannot subtract strings
        // System.out.println("a" - "b"); // Compile error
    }
}
```

| Operator | Use | Operands | Result | Example (10,5) |
|----------|-----|----------|--------|-----------------|
| +        | Addition/Concatenation | Numbers/Chars/Strings | Number/String | 15 / "105" |
| -        | Subtraction | Numbers/Chars | Number | 5 |
| *        | Multiplication | Numbers/Chars | Number | 50 |
| /        | Division | Numbers/Chars | Number (quotient) | 2 |
| %        | Modulo | Numbers/Chars | Number (remainder) | 0 |

### Lab Demos
- **Basic Arithmetic**: `20 + 5` → 25, `20 % 5` → 0.
- **Concatenation**: `"A" + "B"` → "AB"; `50 + "70"` → "5070"; `70 + "50"` → "7050".
- **Evaluation Order**: `"10" + 20 + 5` → "10205" (concat after first string).
- **Bracket Priority**: `(10 + 20) + "30"` → "3030" (add first, then concat).

## Summary

### Key Takeaways
```diff
+ Assignment operator (=) stores and returns value with right-to-left associativity and least precedence.
+ Arithmetic operators (+, -, *, /, %) work on numbers/characters; + overloads for concatenation with strings.
- Avoid inconsistent operator categorization; clarify based on question context (functionality vs. operands).
! Precedence: Assignment executes last; use brackets for priority.
! Compatible types/range crucial for assignment to avoid casting errors.
! Plus behaves differently with strings; evaluation order matters for concatenation.
```

### Expert Insight

#### Real-world Application
In production Java code, assignment operators enable efficient value transfers and chaining, e.g., initializing multiple variables in frameworks like Spring for dependency injection. Arithmetic operators power calculations in financial apps, image processing (e.g., pixel multiplication), and data processing pipelines where concatenation builds dynamic strings for logging or UI.

#### Expert Path
Master operator precedence tables (e.g., concatenating strings vs. performing arithmetic) by practicing edge cases like mixed types. Study bytecode generation for operators using `javap` to understand implicit casting. Pursue OCJP/OCA certification focusing on operator evaluation in complex expressions.

#### Common Pitfalls
- **Type Mismatch in Assignment**: Forgettingcasting larger ranges(e.g., double to int)truncates values unexpectedly.
- **Concatenation Confusion**: Mistaking string presence as always triggering concat; e.g., `10 + 20 + "30"` evaluates to "3030" not "30".
- **Precedence Errors**: Assuming assignment executes first; leads to runtime errors without brackets (e.g., variable found instead of value).
- **Modulo with Negatives**: Modulo behavior with negative numbers varies by JVM; test thoroughly.
- **Least Known Things**: Assignment operator's return value enables rare patterns like `if ((x = get()) != null)`; unary ternary (!condition?val1:val2) edge cases in interviews. Arithmetic optimizations in JIT compilation depend on consistent types. Explicit var usage in Java 10+ affects implicit casting visibility. Hypercompetition: Stay ahead by daily practice; juniors catch up quickly if you lag. Avoid distractions like early relationships; focus on skill-building for stable post-job life. But accept proposals politely: "Busy with Java, check later". Notify friends' parents if they skip classes—tough love works. Tomorrow's class on increment/decrement operators is crucial; study assignment rules deeply.
