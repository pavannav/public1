# Session 34: Core Java & Full Stack Java

- [Incrementing and Decrementing Operators Review](#incrementing-and-decrementing-operators-review)
- [Literals and Number Systems](#literals-and-number-systems)
- [Operator Precedence and Associativity](#operator-precedence-and-associativity)
- [Compound Assignment Operators](#compound-assignment-operators)
- [Summary](#summary)

## Incrementing and Decrementing Operators Review

### Overview
Incrementing (`++`) and decrementing (`--`) operators are unary operators that modify the value of a variable by adding or subtracting 1. These operators are essential for loops and counters in Java programming, providing shorthand for assignment operations.

### Key Concepts/Deep Dive
- **Types of Increment/Decrement Operators**:
  - `++` (increment): Increases value by 1
  - `--` (decrement): Decreases value by 1
- **Variations**: Pre-increment (`++variable`) and post-increment (`variable++`)
  - Pre-increment: Increase value first, then use in expression
  - Post-increment: Use current value in expression, then increase

- **Allowed Operands**:
  - Only variable names permitted as operands
  - Cannot use literals, expressions, or method calls directly

- **Allowed Data Types**: All numeric types (byte, short, int, long, float, double, char)
  - Boolean, string, array, and class types not allowed

- **Result Type**: Same as the variable type (no implicit conversion except for char)

```java
// Example: Incrementing a variable
int a = 10;
a++;          // a becomes 11
System.out.println(a);  // Output: 11

// Post-increment example
int b = 5;
int result = b++;  // b is used as 5, then incremented to 6
System.out.println(result);  // Output: 5
System.out.println(b);       // Output: 6
```

> [!NOTE]
> Always draw memory diagrams to understand value changes when using increment/decrement operators.

### Pre-Increment vs Post-Increment Behavior
- Pre-increment (++variable): Increases first, uses increased value
- Post-increment (variable++): Uses current value in expression, increases after

```java
// Pre-increment
int x = 10;
int y = ++x;  // x: 11, y: 11

// Post-increment
int x = 10;
int y = x++;  // x: 11, y: 10
```

## Literals and Number Systems

### Overview
Literals in Java represent fixed values. Java supports multiple number systems: decimal (default), binary, octal, and hexadecimal. Understanding these is crucial for interviews and low-level programming.

### Key Concepts/Deep Dive
- **Integer Literals**:
  - Decimal: Starts with digit 1-9 (e.g., 10, 11)
  - Octal: Starts with 0 (e.g., 01 -> decimal 1, 010 -> decimal 8)
  - Hexadecimal: Starts with 0x or 0X (e.g., 0x10 -> decimal 16)
  - Binary: Starts with 0b or 0B (e.g., 0b10 -> decimal 2)

- **Conversion Examples**:
  | System | Literal | Decimal Value | Conversion |
  |--------|---------|---------------|------------|
  | Octal | 01 | 1 | 0*8^1 + 1*8^0 = 1 |
  | Octal | 010 | 8 | 0*8^2 + 1*8^1 + 0*8^0 = 8 |
  | Hex | 0x10 | 16 | 1*16^1 + 0*16^0 = 16 |

```java
// Octal literal example
int p = 01;   // Octal 01 -> decimal 1
int q = 010;  // Octal 010 -> decimal 8

// Decimal literal (default)
int r = 100;  // 100

// Binary to decimal conversion in usage
System.out.println(p);  // Output: 1 (converted to int)
System.out.println(q);  // Output: 8
System.out.println(r);  // Output: 100
```

### Character Literals in Arithmetic
Characters participate in arithmetic as ASCII values.

```java
char ch = 'A';      // ASCII 65
ch++;               // ch becomes 'B' (ASCII 66)
int value = ch + 1; // 67 (int promotion)
System.out.println((char)value);  // 'C'
```

## Operator Precedence and Associativity

### Overview
Operator precedence determines execution order. Increment/decrement operators have high precedence and left-to-right associativity.

### Key Concepts/Deep Dive
- **Precedence Hierarchy**:
  - Increment/Decrement: Highest precedence
  - Arithmetic (* / %)
  - Arithmetic (+ -)

- **Associativity**: Left-to-right
  - For same precedence, evaluate left to right

```java
// Precedence example
int result = ++a + a++;  // a = 5; result = 6 + 5 = 11 (a becomes 6)
```

## Compound Assignment Operators

### Overview
Compound assignment operators combine arithmetic with assignment, reducing code length and automatically handling type casting for compatible types.

### Key Concepts/Deep Dive
- **Supported Operators**: `+=`, `-=`, `*=`, `/=`, `%=`, `&=`, `|=`, `^=`, `<<=`, `>>=`, `>>>`
- **Formula**: `variable = (variableType)(variable op expression)`
- **Advantagse**:
  📝 Use variable name only once
  ✅ Implicit casting to variable type

```java
// Compound assignment with automatic casting
byte b = 10;
b += 5;  // equivalent: b = (byte)(b + 5); No explicit cast needed
System.out.println(b);  // Output: 15
```

### Expression Evaluation Steps
1. ✅ Check operand compatibility
2. 📝 Replace variables/method calls with values (left-to-right)
3. 🔄 Evaluate based on operator precedence
4. 🧮 Promote operands to highest type before calculation

```java
// Example evaluation
int a = 10;
a *= a + 5;  // Step 1: Expand to a = (int)(a * (a + 5))
// Step 2: Replace: 10 * (10 + 5) = 10 * 15 = 150
System.out.println(a);  // Output: 150
```

## Summary

### Key Takeaways
```diff
+ Incrementing/Decrementing Operators: Unary operators that modify variables by ±1
+ Pre vs Post: Pre-increments first, uses new value; Post uses current value, then increments
+ Literals: Java supports multiple number systems; converted to decimal internally
+ Precedence: Increment operators have highest precedence, evaluated left-to-right
+ Compound Assignment: Automatically handles type casting; formula = variableType(variable op expression)
- Cannot use on boolean/string/array/class types
! Draw memory diagrams for complex expressions
```

### Expert Insight

**Real-world Application**: Use increment operators in loops for counters (e.g., `for(int i=0; i<10; i++)`). Compound assignments simplify array manipulations or accumulation in big data processing.

**Expert Path**: Master by practicing expression evaluation with memory diagrams. Study precedence tables from Oracle docs and solve 50+ interviewer-assigned problems weekly.

**Common Pitfalls**:

- Forgetting implicit promotions when combining char with int.
- Misapplying formulas in compound assignments leads to type loss errors.
- Confusing operator precedence in mixed expressions; always test outputs.
- Lesser known: Increment on chars produces next ASCII character, not numeric addition.
