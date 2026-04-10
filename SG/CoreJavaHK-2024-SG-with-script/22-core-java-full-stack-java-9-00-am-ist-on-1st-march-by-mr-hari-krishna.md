# Session 22: Class Introduction

## Table of Contents
- [Array Revision](#array-revision)
  - [Overview](#overview)
  - [Key Concepts/Deep Dive](#key-conceptsdeep-dive)
  - [Code/Code Blocks](#codecode-blocks)
  - [Tables](#tables)
  - [Lab Demos](#lab-demos)
- [Class Introduction](#class-introduction)
  - [Overview](#overview-1)
  - [Key Concepts/Deep Dive](#key-conceptsdeep-dive-1)
  - [Code/Code Blocks](#codecode-blocks-1)
  - [Tables](#tables-1)
  - [Notes](#notes)
  - [Lab Demos](#lab-demos-1)

## Array Revision

### Overview
This session begins with a comprehensive revision of arrays, covering their definition, usage, problems, and limitations. The instructor explains arrays as reference data types for storing multiple values of the same or compatible data types, with examples including integer arrays for student fees, long arrays for mobile numbers, and char arrays. Key analogies like comparing arrays to a bag containing books help illustrate memory allocation and access. The session concludes this section by highlighting array limitations and introducing classes as a solution for storing different data types.

### Key Concepts/Deep Dive

#### Array Definition and Usage
An array is a collection of variables of the same type, stored in contiguous memory locations. It serves as a reference data type, allowing storage of multiple values "as one group" with a single identifier, which enables passing and returning all values together.

> **Note**: Arrays are crucial for grouping related data efficiently in memory.

#### Data Type Compatibility in Arrays
Arrays can store values of the same type or lesser range compatible types. For example:
- A `double` array can store `int` values (automatically converted).
- A `long` array requires representation as `long` type using suffix `L` for large numbers.
- Attempting to store incompatible types (e.g., `boolean` in `int` array) results in compile-time errors.

Common range hierarchy: `byte` → `short` → `int` → `long` → `float` → `double`.

> **Important**: Data type casting rules must be strictly followed; implicit conversions occur for lesser ranges, but explicit casting is needed for higher ranges.

#### Memory Diagrams and Analogies
Using a "bag of books" analogy:
- Array declaration (e.g., `double[] fees;`) creates a reference variable.
- Array initialization with `{values}` creates the array object.
- Memory has two parts: reference variable (handle) and object memory (bag contents).
- Values are accessed via index (0 to length-1).

```mermaid
graph TD
    A[Array Variable<br>e.g., double[] fees] --> B[Points to Array Object<br>in memory]
    B --> C[Index 0<br>Value 1]
    B --> D[Index 1<br>Value 2]
    B --> E[Index ...]
```

#### Arithmetic Operations and JVM Behavior
When storing integer values in a `double` array, JVM automatically converts them to floating-point (e.g., `3500` becomes `3500.0`).

> **Diff**:
> + Correctness: Follow data type procedures precisely, as JVM acts similarly to a bank cashier requiring proper format.

#### Array Problems and Limitations
Arrays have five primary problems:
1. **Fixed Size**: Cannot resize after creation; requires static programming.
2. **No Built-in Methods**: Lacks methods for searching, sorting, removing, etc.
3. **Index Mapping Only**: Can only map by index, not custom keys.
4. **Insertion Order**: Maintains values only in insertion order; no custom ordering.
5. **Same Type Restriction**: Cannot store higher-range or incompatible types without errors.

These problems are solved in collections (covered later), but arrays focus on problem 1.

> **Warning**: Never store higher-range values in lower-type arrays; this leads to compile-time errors.

### Code/Code Blocks

#### Double Array for Fees
```java
double[] fees = {3500.0, 4500.0, 2500.0, 5000.0, 20000.0};
```

> **Note**: Uses `double` for floating-point precision, with explicit `.0` for decimal representation.

#### Long Array for Mobile Numbers
```java
long[] mobiles = {9010454584L, 850004584L, 600004584L, 70004584L};
```

> **Important**: Large integers must be suffixed with `L` for `long` representation to avoid integer overflow errors.

#### Compatible vs Incompatible Type Storage
```java
int[] arr = {5, 'a', 3};  // Allowed: char 'a' (ASCII 97) is compatible
// int[] arr2 = {5, false, 3};  // Error: boolean not compatible
```

### Tables

| Concept | Description | Example |
|---------|-------------|---------|
| Same Type Storage | Arrays store identical types | `int[] numbers = {1, 2, 3};` |
| Compatible Lesser Range | Byte/short/int in int array | `int[] mixed = {1, (byte)5, 'a'};` |
| Incompatible Types | Higher ranges or other types | `int[] error = {1, 1.5, true};` // Errors |
| Method Parameter Passing | Pass entire array | `method(byte[] arr)` |

| Data Type | Compatible Types | Examples |
|-----------|------------------|----------|
| `byte` | `byte` only | `{1, 2, 3}` |
| `short` | `byte`, `short` | `{1, (short)2, 'a'}` |
| `int` | `byte`, `short`, `int`, `char` | `{1, 2, 'c', 4}` |
| `long` | `byte`, `short`, `int`, `long`, `char` | `{1L, 2, 'c', 4L}` |
| `float` | `byte`, `short`, `int`, `long`, `float`, `char` | `{1.0f, 2, 3L}` |
| `double` | All above | `{1.0, 2.5f, 3L, 'x'}` |

### Lab Demos

#### Lab Demo 1: Storing Student Fees in Double Array
😐 **Steps:**
1. Declare a `double[]` array named `fees`.
2. Initialize with: `3500.0, 4500.0, 2500.0, 5000.0, 20000.0`.
3. Use loop to print each value.
4. Expected output: `3500.0 4500.0 2500.0 5000.0 20000.0`

> **Note**: Run-time verification ensures no floating-point loss; JVM confirms values are stored accurately.

#### Lab Demo 2: Mobile Numbers in Long Array with L Suffix
😐 **Steps:**
1. Declare `long[]` array named `mobiles`.
2. Initialize with: `9010454584L, 850004584L, 600004584L, 70004584L`.
3. Print array without `L` to see overflow error; correct with `L`.
4. Expected output after correction: `9010454584 850004584 600004584 70004584`

> **Error to Avoid**: Without `L`, compiler throws "integer number too large" error for values beyond `int` range.

#### Lab Demo 3: Type Compatibility Testing
😐 **Steps:**
1. Create an `int[]` array.
2. Attempt storing `int`, `char`, `boolean` values.
3. Compile to observe allowed (`int`, `char`) and denied (`boolean`) compilations.
4. Fix by removing incompatible types.

## Class Introduction

### Overview
Following array revision, the instructor introduces classes as a solution to array limitations. Classes are user-defined data types for storing multiple values of different types as one group. Unlike arrays, classes allow flexible combinations (e.g., `int`, `double`, `char`, arrays, `String`) in a single object, solved via `new` keyword for group memory allocation.

### Key Concepts/Deep Dive

#### Why Classes?
Classes address the primary array limitation: inability to store different types. While arrays store similar types, classes store combinations (e.g., student data: integer ID, string name, double fees). Classes are user-defined, unlike primitives or arrays, which Sun Microsystems predefined.

> **Diff**:
> + Arrays: Limited to same-type collections.
> - Classes: Enable different-type combinations for complex objects.

#### Class Definition
A class is a user-defined data type: a collection of variables (fields) of same/different types, accessed as one unit.

Definitions:
- Primary: User-defined data type for storing data.
- Alternative: Collection of variables of same/different types, group-managed with a single name.

> **Note**: Classes differ from primitives (predefined) and arrays (derived from primitives); classes are custom-built.

#### Syntax and Structure
```java
class ClassName {
    // Variables (must declare and initialize)
    int var1 = value;
    double var2 = value;
    // No direct value storage without variables
}
```

- Variables must be explicitly declared (e.g., `int i1 = 5;`).
- Classes separate data storage from execution (no main method in data classes).

> **Warning**: Avoid mixing data and execution; create separate executable classes for main methods.

#### Memory Allocation: Static vs New
Two methods provide memory:
1. `static`: Individual variable memory (not grouped).
2. `new`: Group memory for all class variables (object creation).

Use `new` for objects:
```java
Example e1 = new Example();
```

> **Important**: Objects bundle variables for passing/returning as units, overcoming array static nature.

#### Creating and Accessing Objects
- Declare: `Example e1;` (reference variable).
- Instantiate: `new Example();` (object creation).
- Access: `e1.variableName` (e.g., `e1.i1`).

Static variables accessed directly in other classes; non-static require objects.

> **Diff**:
> + Static: Individual variable access (e.g., `Example.i1` if static).
> - New/Object: Group access for all members (e.g., `e1.i1`, `e1.d1`).

### Code/Code Blocks

#### Sample Class Definition
```java
class Example {
    int i1 = 5;
    double d1 = 6.7;
    char ch = 'a';
    long[] la = {8L, 9L};
    String s1 = "Hello";
}
```

#### Accessing Variables via Object
```java
class Test {
    public static void main(String[] args) {
        Example e1 = new Example();
        System.out.println(e1.i1 + " " + e1.d1 + " " + e1.ch);
        System.out.println(e1.la[0] + " " + e1.la[1]);
        System.out.println(e1.s1);
    }
}
// Output: 5 6.7 a
// 8 9
// Hello
```

### Tables

| Concept | Features | Arrays | Classes |
|---------|----------|--------|---------|
| Data Types | Similar | ✅ | ❌ |
| Data Types | Different | ❌ | ✅ |
| Memory | Fixed Size | ✅ | ❌ |
| Memory | Dynamic | ❌ | ✅ (via objects) |

### Notes
- Classes separate data and logic for modularity.
- Advantages: Store diverse types, pass objects readily, enable dynamic programming.
- Upcoming: Memory diagrams, more examples.

### Lab Demos

#### Lab Demo 1: Creating and Accessing Simple Class
😐 **Steps:**
1. Define `class Example` with `int i1 = 5`, `double d1 = 6.7`, `char ch = 'a'`.
2. In separate `class Test`, create `Example e1 = new Example();`.
3. Print `e1.i1`, `e1.d1`, `e1.ch`.
4. Expected output: `5 6.7 a`

> **Note**: Compile and run to verify group access via object.

#### Lab Demo 2: Class with Nested Array
😐 **Steps:**
1. In `Example`, add `long[] la = {8L, 9L};` and `String s1 = "Hello";`.
2. In `Test`, print `e1.la[0]`, `e1.la[1]`, `e1.s1`.
3. Expected output: `8 9 Hello`

#### Lab Demo 3: Static vs New Memory Allocation
😐 **Steps:**
1. Add `static int si = 10;` to `Example`.
2. Access `Example.si` (static) and `e1.i1` (via object).
3. Compare: Static doesn't group; objects do.

## Summary

### Key Takeaways
> ❗ Arrays provide efficient same-type storage with fixed size and index access, while classes offer flexible different-type combinations via objects for dynamic programming.

### Expert Insight

#### Real-world Application
Classes model complex entities in applications like student management systems (combining ID, name, fees) or e-commerce (product details with prices, descriptions), enabling structured data handling unlike basic arrays.

#### Expert Path
Master class design through daily practice of varied combinations; progress to inheritance, polymorphism, and encapsulation. Study memory allocation deeply for JVM expertise and interview readiness.

#### Common Pitfalls
- Confusing static group access with individual variable handling leading to runtime access issues.
- Attempting direct execution in data classes instead of separating logic into main methods.
- Forgetting class variable declarations, resulting in no group storage.
- Solution: Always separate data and execution classes, use `new` for object creation.

#### Lesser Known Things About This Topic
Classes can encapsulate primitive types, arrays, and custom objects (e.g., nested classes), enabling hierarchical data structures. Memory technically involves heap allocation for objects, with garbage collection enabling dynamic freeing—countering array static nature. Avoid premature optimization; focus on logical class design over complex hierarchies initially. Practice analogizing classes to real-world containers (bags with diverse items) for intuitive understanding.

#### Corrections Made
- "floatingoint" corrected to "floating point".
- "inteious" corrected to "integers".
- "cubectl" corrected to "kubectl" (not present in transcript, but noted for future reference).
- "htp" corrected to "http" (not present in transcript, but noted for future reference). 

CL-KK-Terminal
