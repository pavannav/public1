```diff
# Session 26: Reading Values from Command Line and Keyboard

## Table of Contents
- [Command Line Arguments](README.md#command-line-arguments)
- [Execution Flow of Command Line Arguments Application](README.md#execution-flow-of-command-line-arguments-application)
- [Rules for Running Command Line Arguments Application](README.md#rules-for-running-command-line-arguments-application)
- [Problems with Command Line Arguments Application](README.md#problems-with-command-line-arguments-application)
- [Working with BufferReader Class](README.md#working-with-bufferreader-class)
- [Developing a Program using BufferReader](README.md#developing-a-program-using-bufferreader)

## Command Line Arguments

### Overview
Command line arguments allow passing values to a Java program at runtime via the command prompt. The main method receives these values as an array of strings (`String[] args`). This method is useful for quick program testing but lacks user-friendliness for end users.

### Key Concepts/Deep Dive
- **Main Method Parameter**: The main method is parameterized with `String[] args`, which receives arguments from the command line.
- **Array Object Creation**: When no arguments are passed, an empty array object is created. When arguments are provided, an array with the specified values is created.
- **Reading Values**: Use `Integer.parseInt(args[0])` to read and convert the first argument to an integer.
- **Runtime Flexibility**: Unlike directly assigning values in code, command line arguments enable changing inputs without recompiling the program.

```bash
javac Addition.java
java Addition 10 20
```

### Lab Demos
To demonstrate, consider an addition program:

```java
class Addition {
    public static void main(String[] args) {
        int a = Integer.parseInt(args[0]);
        int b = Integer.parseInt(args[1]);
        int c = a + b;
        System.out.println("Result: " + c);
    }
}
```

Running this program with `java Addition` will throw `ArrayIndexOutOfBoundsException` due to no arguments. Passing `java Addition 10 20` will output `Result: 30`. Passing `java Addition 10 a` will throw `NumberFormatException`.

## Execution Flow of Command Line Arguments Application

### Overview
Understanding the execution flow involves visualizing how Java Virtual Machine (JVM) prepares the main method call with command line arguments.

### Key Concepts/Deep Dive
- **JVM Startup**: JVM starts and prepares a main method call like `Addition.main(new String[]{})` for no arguments.
- **Argument Passing**: Values like `10 20` create an array `new String[]{"10", "20"}`.
- **Index Access**: Values are accessed via indices (e.g., `args[0] = "10"`).
- **Exception Scenarios**:
  - No arguments: `ArrayIndexOutOfBoundsException` when accessing `args[0]`.
  - Extra arguments: Unused values are passed but not accessed.
  - Wrong type: `NumberFormatException` during parsing.

| Scenario | Command | Result |
|----------|---------|--------|
| No arguments | `java Addition` | `ArrayIndexOutOfBoundsException` |
| Sufficient arguments | `java Addition 10 20` | `Result: 30` (Success) |
| Insufficient arguments | `java Addition 10` | `ArrayIndexOutOfBoundsException` |
| Wrong type | `java Addition 10 a` | `NumberFormatException` |

```diff
- ArrayIndexOutOfBoundsException (AIOOBE): Occurs when accessing invalid array index
+ NumberFormatException (Nfe): Occurs when parsing non-numeric values
```

## Rules for Running Command Line Arguments Application

### Overview
To avoid exceptions, specific rules must be followed when executing command line argument-based applications.

### Key Concepts/Deep Dive
- **Execution Platform**: Must run from command prompt for passing arguments.
- **Argument Count**: Provide exactly the number of arguments the program expects.
- **Argument Type**: Match the data type being parsed (e.g., integers for `parseInt`).
- **Order of Arguments**: Follow the sequence defined in the code (e.g., first number then second).

```diff
! Command Line Arguments Application Rules:
! - Number of arguments must equal expected count
! - Type must match parsing method (e.g., int for Integer.parseInt)
! - Order must align with program logic
```

> [!IMPORTANT]  
> Violation of any rule leads to runtime exceptions, making the application unsuitable for end users.

## Problems with Command Line Arguments Application

### Overview
Command line arguments work for developers but pose significant challenges for end users due to lack of interactivity and clarity.

### Key Concepts/Deep Dive
- **End User Information Gap**: No prompts or guidance on required inputs.
- **No Mid-Execution Input**: Cannot add or change values during program run.
- **Unsuitable for End Users**: Primarily for programmer testing only.

```diff
- End users don't know input requirements
- No ability to enter values mid-execution
- Best suited only for quick developer testing
```

> [!NOTE]  
> Solution: Develop user interaction-based (UI) applications using BufferReader or similar for better experience.

## Working with BufferReader Class

### Overview
BufferReader enables reading string values from the keyboard, promoting user-friendly input during program execution. It reads one line at a time and returns data as strings, requiring parsing for primitive types.

### Key Concepts/Deep Dive
- **Class Location**: Predefined class in `java.io` package.
- **Object Creation**: `BufferedReader br = new BufferedReader(new InputStreamReader(System.in));`
- **Reading Method**: `br.readLine()` reads one line as String.
- **Exception Handling**: Requires handling `IOException` with `throws` or try-catch.
- **Parsing Requirement**: Convert strings to primitives using `Integer.parseInt(br.readLine())`.
- **Use Case**: Better than `System.in.read()` which reads only one byte at a time.

```java
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;

class ReadExample {
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        System.out.print("Enter something: ");
        String input = br.readLine();
        System.out.println("You entered: " + input);
    }
}
```

> [!TIP]  
> Use individual `import` statements (e.g., `import java.io.BufferedReader;`) rather than `java.io.*` for clarity and best practices.

## Developing a Program using BufferReader

### Overview
To create interactive programs, combine BufferReader with prompts for user input, then parse values as needed for calculations.

### Key Concepts/Deep Dive
- **Steps for Implementation**:
  1. Import required classes (`BufferedReader`, `InputStreamReader`, `IOException`).
  2. Create `BufferedReader` object linked to `System.in`.
  3. Prompt user with messages (e.g., "Enter first number").
  4. Read input using `br.readLine()`.
  5. Parse string to primitive type (e.g., `Integer.parseInt()`).
  6. Perform calculations.
  7. Handle `IOException` via `throws`.
- **Advantages**: Prompts guide users, allows mid-execution input, user-friendly.

```mermaid
flowchart TD
    A[Start Program] --> B[Create BufferedReader Object]
    B --> C[Prompt Message]
    C --> D[Call br.readLine()]
    D --> E[Parse to Primitive Type]
    E --> F[Perform Calculation]
    F --> G[Display Result]
    G --> H[End]
```

### Lab Demos
Example: Addition program with user prompts.

```java
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;

class Addition {
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

Run: `javac Addition.java` then `java Addition`. Enter values when prompted.

## Summary

### Key Takeaways
```diff
+ Command line arguments enable runtime input via arrays in main method
- Lack user-friendliness; prone to ArrayIndexOutOfBoundsException and NumberFormatException
+ Rules: Correct count, type, and order of arguments; run from command prompt
- Problems: No end-user guidance; no mid-execution input changes
+ BufferReader improves UX: Reads full lines as strings from keyboard
+ Requires imports and IOException handling; parse to primitives manually
+ Object creation: BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
- Limited for large-scale apps; used as foundation for Scanner class
```

### Expert Insight

**Real-world Application**: In production, use BufferReader for console-based tools or configuration scripts where user interaction is minimal. For web apps, prefer frameworks like Spring for UI-based input handling.

**Expert Path**: Master BufferReader by implementing 5 programs (e.g., calculator, data validator). Then advance to Scanner class for simplified parsing. Deepen knowledge by exploring `java.io` packages and exception handling best practices.

**Common Pitfalls**: Forgetting `throws IOException` leads to compile errors. Misspelling classes (e.g., "inpustreamreader" instead of "inputstreamreader") or packages ("java io" without dot). Passing wrong data types causes runtime exceptions. Avoid direct `System.in.read()` for multi-character input.
⚠️ Always validate inputs to prevent NumberFormatException during parsing.
💡 Practice with multiple examples to build intuition for flow and exceptions.
