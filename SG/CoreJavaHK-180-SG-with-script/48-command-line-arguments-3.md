# Session 48: Command Line Arguments 3

- [Revision and Context](#revision-and-context)
- [Problems with Command Line Arguments Application](#problems-with-command-line-arguments-application)
- [BufferedReader Approach](#bufferedreader-approach)
- [How BufferedReader Works](#how-bufferedreader-works)
- [Comparison: Command Line vs BufferedReader](#comparison-command-line-vs-bufferedreader)
- [Problems with BufferedReader](#problems-with-bufferedreader)
- [Introduction to Scanner](#introduction-to-scanner)
- [Scanner Class Overview](#scanner-class-overview)
- [Scanner Methods](#scanner-methods)
- [Program Examples with Scanner](#program-examples-with-scanner)
- [Understanding the 'Next' Logic](#understanding-the-next-logic)
- [Summary](#summary)

## Revision and Context

### Overview
This session revisits command line arguments and introduces BufferedReader for runtime input, then transitions to Scanner as an improved approach for reading keyboard input in Java applications. The teacher emphasizes understanding concepts over just writing program logic, stressing that strong conceptual knowledge enables automatic program writing.

### Key Concepts
- **Command Line Arguments**: Values passed before program execution start
- **BufferedReader**: Enables reading input during program execution with user prompts
- **Scanner**: Simplifies input reading with automatic parsing and no exception handling requirements
- **Memory Flow**: Understanding how objects (System.in, InputStreamReader, BufferedReader) connect to facilitate input

> [!NOTE]
> Revision from previous sessions shows that while command line arguments work, they provide poor user experience. BufferedReader and Scanner offer solutions for runtime input with proper messaging.

## Problems with Command Line Arguments Application

### Overview
Command line arguments, while functional, create user experience issues in production applications. End users cannot provide input naturally during program execution and lack information about required data types and order.

### Key Problems
✅ **No User Guidance**: End users see no prompts indicating what type and how many values to enter
✅ **No Runtime Input**: All values must be provided before program execution begins
✅ **Order Confusion**: Must remember exact order of arguments (e.g., Java Edition 10 20)
✅ **Type Obfuscation**: No indication if values should be int, float, etc.

### Deep Dive
```java
public class Addition {
    public static void main(String[] args) {
        int a = Integer.parseInt(args[0]);
        int b = Integer.parseInt(args[1]);
        int c = a + b;
        System.out.println("Result: " + c);
    }
}
// Problems: No prompts, must know to run as "java Addition 10 20"
```

As a developer, you cannot comfortably ask users to run commands like `java Edition 1020` - the interface lacks friendliness and clarity for non-technical users.

## BufferedReader Approach

### Overview
BufferedReader was introduced to solve command line argument limitations by enabling runtime input with user prompts. It allows reading values during program execution, providing proper information to users about required inputs.

### Key Concepts
✅ **Runtime Input Reading**: Values entered while program runs
✅ **User Prompts**: Displays messages before each input request
✅ **Flexible Positioning**: Can read input anywhere in program execution
✅ **Order Clarity**: User sees step-by-step instructions

### BufferedReader Setup (7 Steps)
1. Import java.io.*;
2. Create BufferedReader object: `BufferedReader br = new BufferedReader(new InputStreamReader(System.in));`
3. Display message for first value
4. Call `br.readLine()` → returns String
5. Convert to primitive type using wrapper class parse methods
6. Use converted value in program
7. Handle IOException (though rarely thrown in practice)

### Code Implementation
```java
import java.io.*;
public class Addition {
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));

        System.out.print("Enter first number: ");
        int a = Integer.parseInt(br.readLine());

        System.out.print("Enter second number: ");
        int b = Integer.parseInt(br.readLine());

        int c = a + b;
        System.out.println("Result: " + c);
    }
}
```

## How BufferedReader Works

### Overview
BufferedReader works through a three-object chain: System.in → InputStreamReader → BufferedReader. This architecture handles the incompatibility between System.in (byte stream) and BufferedReader (character stream).

### Memory Flow Diagram
```mermaid
graph TD
    A[Console Input] --> B[System.in]
    B --> C[InputStreamReader<br/>Converts bytes to chars]
    C --> D[BufferedReader<br/>Buffers and reads lines]
    D --> E[br.readLine()]
    E --> F[Integer.parseInt()]
    F --> G[Program Variable]
```

### Execution Flow
1. **System.in**: Pre-created object connected to console, reads 1 byte at a time
2. **InputStreamReader**: Bridge between byte and character streams, adds padding zeros to convert bytes to 16-bit characters
3. **BufferedReader**: Character stream object created by programmer, reads full lines

> [!IMPORTANT]
> Program execution pauses at `br.readLine()` until user presses Enter. Empty string ("") returned if Enter pressed without input.

### Example Execution
```
Enter first number: 10
Enter second number: 20
Result: 30
```

## Comparison: Command Line vs BufferedReader

### Key Differences

| Aspect | Command Line Arguments | BufferedReader |
|--------|------------------------|---------------|
| Input Timing | Before execution | During execution |
| User Interface | Command prompt | Console with prompts |
| Value Passing | Through String[] args | Through BufferedReader object |
| Object Creation | Automatic by JVM | Programmer creates |
| Exception Handling | No exceptions | Must handle IOException |
| Value Reading | args[0], args[1] | br.readLine() |
| Runtime Reading | No | Yes |
| Conversion Needed | Yes (parseInt, etc.) | Yes (parseInt, etc.) |

### Conclusion
> [!IMPORTANT]
> For production applications, always choose BufferedReader over command line arguments for better user experience.

## Problems with BufferedReader

### Overview
While BufferedReader solves command line limitations, it introduces new complexity issues that make it cumbersome for everyday programming.

### Key Problems
✅ **Import Statement Required**: Must add `import java.io.*;`
✅ **IOException Declaration**: Main method must declare `throws IOException`
✅ **Complex Object Creation**: Lengthy instantiation: `new BufferedReader(new InputStreamReader(System.in))`
✅ **Manual Type Conversion**: Every input requires parseInt(), parseFloat(), etc.
✅ **Single Value Limitation**: Cannot easily read multiple values from one input line

### Example Problem Code
```java
// Problematic: Reading multiple values at once
System.out.print("Enter three numbers: ");
String input = br.readLine(); // Reads "10 20 30" as one string
// Must manually split and parse
String[] parts = input.split(" ");
int a = Integer.parseInt(parts[0]);
int b = Integer.parseInt(parts[1]);
int c = Integer.parseInt(parts[2]);
```

## Introduction to Scanner

### Overview
Scanner class was introduced in Java 5 as a solution to BufferedReader's complexity, providing a simpler, more intuitive approach to reading keyboard input that's familiar to C programmers.

### Key Advantages
✅ **No Import Issues**: Simple import
✅ **No Exception Handling**: Never throws IOException in practice
✅ **Simple Object Creation**: `Scanner sc = new Scanner(System.in)`
✅ **Automatic Type Conversion**: Reads directly as primitive types
✅ **Flexible Input Reading**: Handles both individual and multiple values seamlessly

### Why "Scanner"?
The name comes from the C language's `scanf` function. Java designers wanted to provide C-style input functionality to make Java more approachable for C programmers transitioning to Java.

## Scanner Class Overview

### Class Details
- **Package**: java.util.Scanner
- **Introduced**: Java 5
- **Purpose**: Simplifies keyboard input with C-style scanf functionality
- **Object Creation**: `Scanner sc = new Scanner(System.in);`

### Basic Usage
```java
import java.util.Scanner;

public class Addition {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        System.out.print("Enter first number: ");
        int a = sc.nextInt();

        System.out.print("Enter second number: ");
        int b = sc.nextInt();

        int c = a + b;
        System.out.println("Result: " + c);
    }
}
```

> [!NOTE]
> Scanner methods are named with "next" prefix because they read current token and move cursor to next token in the input stream.

## Scanner Methods

### Primitive Type Methods
Scanner provides seven methods for reading primitive types:
- `nextByte()`
- `nextShort()`
- `nextInt()`
- `nextLong()`
- `nextFloat()`
- `nextDouble()`
- `nextBoolean()`

### String Reading Methods
- `next()`: Reads one token up to whitespace
- `nextLine()`: Reads entire line including whitespace

> [!IMPORTANT]
> No `nextChar()` method - read String then use `charAt(0)` for characters.

### Complete Method Signatures
```java
public byte nextByte() throws InputMismatchException
public short nextShort() throws InputMismatchException
public int nextInt() throws InputMismatchException
public long nextLong() throws InputMismatchException
public float nextFloat() throws InputMismatchException
public double nextDouble() throws InputMismatchException
public boolean nextBoolean() throws InputMismatchException
```

> [!NOTE]
> Scanner throws `InputMismatchException` (not `NumberFormatException` like `parseInt()`) when input type doesn't match method called.

## Program Examples with Scanner

### Basic Addition Program
```java
import java.util.Scanner;

public class Addition {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        System.out.print("Enter first number: ");
        int a = sc.nextInt();

        System.out.print("Enter second number: ");
        int b = sc.nextInt();

        int c = a + b;
        System.out.println("Result: " + c);
    }
}
```

### Reading Different Types
```java
Scanner sc = new Scanner(System.in);

System.out.print("Enter int: ");
int num = sc.nextInt();

System.out.print("Enter double: ");
double dec = sc.nextDouble();

System.out.print("Enter string: ");
String text = sc.next();
```

### Student Data Collection
```java
Scanner sc = new Scanner(System.in);

System.out.print("Enter student name: ");
String name = sc.next();

System.out.print("Enter age: ");
int age = sc.nextInt();

System.out.print("Enter marks: ");
double marks = sc.nextDouble();
```

## Understanding the 'Next' Logic

### Overview
Scanner methods named "next" perform two operations: reading current value and advancing cursor to next token. Tokens are separated by whitespace (spaces) or newlines.

### Execution Scenarios

**Scenario 1: Individual Input Entry**
```
Enter first number: 50
Enter second number: 60
Enter third number: 70
```
- Each entry creates separate token
- No program pause after first input
- Cursor advances with each next() call

**Scenario 2: Multiple Values on One Line**
```
Enter three numbers: 50 60 70
```
- One input creates three tokens: "50", "60", "70"
- All next() calls complete without console pause
- Ideal for command-line style input

**Scenario 3: Mixed Approach**
```
Enter first number: 50 60
Enter third number: 70
```
- First nextInt() reads "50", advances cursor
- Second nextInt() reads "60", advances cursor
- Third nextInt() pauses (no more tokens), waits for "70"

### Visual Flow Diagram
```
Scanner Object: ["50", "60", "70", "\n"]
                ↑
                cursor

nextInt() → reads "50", cursor moves →
                ["50", "60", "70", "\n"]
                       ↑

nextInt() → reads "60", cursor moves →
                ["50", "60", "70", "\n"]
                             ↑

nextInt() → reads "70", cursor moves →
                ["50", "60", "70", "\n"]
                                   ↑
```

> [!NOTE]
> Scanner's "next" naming emphasizes cursor advancement after reading, enabling token-by-token processing of input streams.

## Summary

### Key Takeaways
```diff
+ Command line arguments lack user-friendly interface for production applications
+ BufferedReader enables runtime input with proper user prompts
+ System.in → InputStreamReader → BufferedReader creates necessary conversion chain
+ BufferedReader solves user experience but introduces complexity (imports, throws, parsing)
+ Scanner class simplified Java 5 addition that eliminates BufferedReader's complexity
+ Scanner methods named "next" because they read current token AND advance cursor to next
+ Scanner handles both individual inputs and multiple space-separated inputs seamlessly
- Command line arguments should not be used for customer-facing applications
- BufferedReader's lengthy syntax and IOException requirements make it cumbersome
- Scanner InputMismatchException thrown when input type doesn't match method
- Never use command line arguments when user needs clear input prompts
- Forgetting Scanner has no nextChar() method - use next().charAt(0)
- Mixing nextLine() after nextInt() without consuming newline character
- Not handling InputMismatchException (unlike BufferedReader, this exception actually occurs)
- Attempting to reassign System.in - it cannot be redirected in most environments
- Misunderstanding that Scanner methods "next" perform read AND advance operations
```

### Expert Insight

#### Real-world Application
In enterprise applications, you'll most commonly encounter Scanner for console-based utilities and BufferedReader for file I/O operations. Scanner is the go-to choice for all user input scenarios in command-line tools, configuration utilities, and administrative scripts. Web applications typically don't use these (HTTP request/response handling), but they're essential for desktop applications and server-side utilities that require occasional user interaction.

#### Expert Path
Master input handling by practicing all approaches, then focus on Scanner as your primary tool. Study the InputMismatchException vs NumberFormatException differences. Learn to handle file input with BufferedReader (files aren't auto-closed). Implement your own input validation wrappers around Scanner methods. Explore java.util.Formatter for output formatting (Scanner's sibling class).

#### Common Pitfalls
```diff
- Forgetting Scanner has no nextChar() method - use next().charAt(0)
- Mixing nextLine() after nextInt() without consuming newline character
- Not handling InputMismatchException (unlike BufferedReader, this exception actually occurs)
- Attempting to reassign System.in - it cannot be redirected in most environments
- Misunderstanding that Scanner methods "next" perform read AND advance operations
- Assuming program pause behavior without understanding token cursor movement
```
