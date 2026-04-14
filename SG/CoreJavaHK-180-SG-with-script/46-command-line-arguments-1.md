# Session 46: Command Line Arguments 1

## Table of Contents

- [Introduction to Runtime Values and Command Line Arguments](#introduction-to-runtime-values-and-command-line-arguments)
- [Definitions](#definitions)
- [How Command Line Arguments Are Passed](#how-command-line-arguments-are-passed)
- [Why Values Are Received as Strings and Need Parsing](#why-values-are-received-as-strings-and-need-parsing)
- [Wrapper Classes and Parse Methods](#wrapper-classes-and-parse-methods)
- [Converting Command Line Arguments to Primitive Types](#converting-command-line-arguments-to-primitive-types)
- [Example Program: Addition from Command Line](#example-program-addition-from-command-line)
- [Test Cases for Command Line Arguments](#test-cases-for-command-line-arguments)
- [Rules for Using Command Line Arguments](#rules-for-using-command-line-arguments)
- [Running Command Line Arguments Application from an IDE](#running-command-line-arguments-application-from-an-ide)
- [Project: Reading Student Object Values from Command Line](#project-reading-student-object-values-from-command-line)

## Introduction to Runtime Values and Command Line Arguments

Command line arguments allow reading values at runtime from outside the program, enabling dynamic behavior. This contrasts with hardcoded values, which make programs static and require recompilation for changes.

**Key Concepts:**
- **Runtime Values:** Values passed to a program during execution time, not at compile time.
- **Static vs. Dynamic Programs:**
  - Static: Values hardcoded (e.g., `int a = 70; int b = 80;`), outputs are fixed.
  - Dynamic: Reads values from external sources like keyboard or command line, allowing value changes without code modification.

**Approaches to Read Runtime Values:**
Java provides seven ways to read values from the keyboard, but this session focuses on command line arguments as one approach.

## Definitions

Define the core terms related to command line arguments.

**Key Concepts:**
- **Command Line:** The line in the console window where commands are entered to compile and execute Java programs.
- **Command Line Arguments:** Input values passed from the command line to the program, used to execute logic.
- **Command Line Arguments Application:** A program that reads runtime values from the command line to perform operations.

**Example Diagram:**
```
Command Prompt Window
Line: java Addition 10 20

- Command Line: "java Addition 10 20"
- Command Line Arguments: 10, 20
- Application: Reads 10 and 20, adds them, outputs sum.
```

! IMPORTANT
Command line arguments enable programs to accept external input without user interaction during runtime.

## How Command Line Arguments Are Passed

When running a Java program with arguments (e.g., `java Addition 10 20`), the JVM handles passing these values internally.

**Deep Dive:**
- The JVM reads the arguments (10, 20) entered after the class name.
- Creates a String array object with elements equal to the number of arguments.
- Stores arguments as String values in the array.
- Passes the array object's reference to the main method parameter `args` (a String array).
- The main method receives this reference and can access values via `args[0]`, `args[1]`, etc.
- Internal statement executed by JVM: `Addition.main(new String[]{"10", "20"})`.

**Memory Diagram:**
>xai:function_call name="MermaidSyntax">
<parameter name="diagram">graph TD
    A[User runs: java Addition 10 20] --> B[JVM reads arguments 10, 20]
    B --> C[JVM creates String array: {"10", "20"}]
    C --> D[JVM passes array reference to main(args)]
    D --> E[args[0] = "10", args[1] = "20"]
    E --> F[Program reads and parses values]</parameter>
</xai:function_call>

```diff
- Client Input: User provides 10, 20 via command line
- JVM Processing: Converts inputs to String array, invokes main
+ Program Execution: Retrieves from args[0] and args[1]
```

! NOTE
All inputs from command line are received as Strings in the array, regardless of type. Parsing is required for numeric operations.

**Transcription Corrections:**
- "itted" → "added" (when describing adding instance variables)

## Why Values Are Received as Strings and Need Parsing

Command line arguments arrive as Strings due to JVM and OS behavior.

**Deep Dive:**
- **OS and JVM Behavior:** Operating systems send all input to programs as Strings. Java maintains this as a string array in `main`.
- **Type Incompatibility:** Direct assignment (e.g., `int a = args[0];`) fails because `args[0]` is a String, not an int. Compiler throws "incompatible types" error.
- **Solution:** Use parsing (conversion logic) instead of casting. Casting converts between compatible types (e.g., double to int); parsing converts Strings to primitives.
- **Parse vs. Cast:**
  - Parse: Removes quotes and converts (e.g., `"10"` → 10).
  - Cast: For range adjustments (e.g., double to int for truncation).

```diff
+ Parsing Required: Converts String "10" to int 10 using methods
- Casting Inadequate: "10" as String cannot be cast to int directly
```

! IMPORTANT
Always parse Strings to target types; never rely on casting for String-to-primitive conversions.

## Wrapper Classes and Parse Methods

Wrapper classes provide methods to convert Strings to primitives.

**Deep Dive:**
- **Wrapper Classes:** Eight classes (one per primitive) for primitive handling. They are subclasses of Number (except Character and Boolean).
- **Hierarchy:**
  | Primitive Type | Wrapper Class |
  |----------------|--------------|
  | byte           | Byte        |
  | short          | Short       |
  | int            | Integer     |
  | long           | Long        |
  | float          | Float       |
  | double         | Double      |
  | char           | Character   |
  | boolean        | Boolean     |
- **Parse Methods:** Static methods `parseXXX(String value)` throw `NumberFormatException` on invalid input. Used to convert Strings to primitives.
  - Prototype: `public static primitiveType parsePrimitiveType(String value) throws NumberFormatException`
  - Example: `Integer.parseInt("10")` → 10

**Transcription Corrections:**
- "meod" → "method" (multiple instances)
- "cubectl" → "kubectl" (not in this transcript, but noting for consistency; actually none here, but similar errors)
- "Edition" → "Addition" (class name in examples)

! NOTE
Wrapper classes are part of `java.lang` package; no imports needed. Use them for safe String-to-primitive conversions.

## Converting Command Line Arguments to Primitive Types

Convert `args` elements using wrapper class methods.

**Deep Dive:**
- **General Pattern:** `WrapperClass.parseXXX(args[index])`
- **For Each Type:**
  | Type    | Conversion Code                     | Notes |
  |---------|-------------------------------------|-------|
  | byte    | `byte b = Byte.parseByte(args[0])` | Value must be in byte range (-128 to 127) |
  | short   | `short s = Short.parseShort(args[0])` | Value in short range |
  | int     | `int i = Integer.parseInt(args[0])` | Most common |
  | long    | `long l = Long.parseLong(args[0])` | For large numbers |
  | float   | `float f = Float.parseFloat(args[0])` | Supports decimals |
  | double  | `double d = Double.parseDouble(args[0])` | Supports doubles |
  | char    | `char ch = args[0].charAt(0)`       | No parseChar; use String's charAt |
  | boolean | `boolean b = Boolean.parseBoolean(args[0])` | Accepts "true"/"false" |

**Char Handling:** Since no `parseChar`, convert String to char via `charAt(0)` (extracts first character).

> [!WARNING]
> `parseXXX` throws `NumberFormatException` if input is out of range or invalid (e.g., "har" for int). Ensure inputs match expected types.

**Code Example:**
```java
int a = Integer.parseInt(args[0]);
int b = Integer.parseInt(args[1]);
int sum = a + b;
System.out.println(sum);
```

## Example Program: Addition from Command Line

Build and execute a program reading two ints from command line.

**Lab Demo Steps:**
1. Create class `Addition.java` with hardcoded values for comparison.
2. Modify to read from command line:
   - Use `Integer.parseInt(args[0])` and `Integer.parseInt(args[1])`.
   - Compute sum and print.
3. Compile: `javac Addition.java`.
4. Execute with args: `java Addition 10 20`.
   - Expected Output: 30
5. Test with new args: `java Addition 30 40`.
   - Expected Output: 70

**Code (Dynamic Version):**
```java
class Addition {
    public static void main(String[] args) {
        int a = Integer.parseInt(args[0]);
        int b = Integer.parseInt(args[1]);
        int c = a + b;
        System.out.println(c);
    }
}
```

**Verification:**
- Hardcoded version: Fixed output (e.g., 150).
- Dynamic version: Varies with arguments, no recompilation needed.

```diff
+ Dynamic Behavior: Pass values externally without code changes
- Static Limitation: Requires recompilation for new values
```

! NOTE
Program expects exactly matching number and type of arguments; mismatches cause exceptions.

## Test Cases for Command Line Arguments

Test edge cases to ensure robustness.

**Key Test Cases:**
- **No Arguments:** `java Addition` → ArrayIndexOutOfBoundsException (empty array, args[0] fails).
- **One Argument:** `java Addition 10` → Works for args[0], exception on args[1].
- **Two Arguments:** `java Addition 10 20` → Success, output 30.
- **Three Arguments:** `java Addition 10 20 30` → Ignores extra args, output 30 (reads only first two).
- **Invalid Types:** `java Addition a b` → NumberFormatException (cannot parse "a" to int).
- **Out-of-Range:** `java Addition 10.5 20` → NumberFormatException ("10.5" not int-range).

**Execution Flow Summary:**
- JVM creates array with given args.
- Array length matches arg count.
- Program reads via indices; access beyond length causes exception.
- Extra args passed but not read.

> [!IMPORTANT]
> Rule: Pass exactly the number of args your program reads. Fewer = IndexOutOfBounds; More = Ignored; Wrong types = FormatException.

## Rules for Using Command Line Arguments

Essential guidelines for reliable programs.

**Deep Dive:**
- **Argument Count:** Provide as many args as values your program reads. Mismatch leads to exceptions.
- **Type Matching:** Ensure arg types match parsing methods (e.g., ints for parseInt).
- **Exception Handling:** Expect `ArrayIndexOutOfBoundsException` for missing args, `NumberFormatException` for invalid parses.
- **No Casting:** Use parse methods, not casting, for String to primitive.
- **Import Requirement:** Wrapper classes in `java.lang`; no imports needed.

**Example Diagram:**
>xai:function_call name="MermaidSyntax">
<parameter name="diagram">flowchart LR
    A[Run: java Addition x y] --> B[Check args count]
    B --> C{Fewer than required?} --> D[ArrayIndexOutOfBounds]
    B --> E{Types match?} --> F[NumberFormatException]
    B --> G{Success} --> H[Parse and execute]</parameter>
</xai:function_call>

## Running Command Line Arguments Application from an IDE

Configure IDE to prompt for args during execution.

**Lab Demo Steps:**
1. In EditPlus (or similar IDE):
   - Go to Tools > Configure User Tools.
   - Add JVM tool with `$FileNameWithoutExtension$` followed by `$Prompt$`.
2. Set File Name: `$FileNameWithoutExtension$ $Prompt$`.
3. Save configuration.
4. Compile normally (Ctrl+1).
5. Run (Ctrl+2): IDE prompts for args.
6. Enter args (e.g., `10 20`).
7. Program executes with args, outputs 30.

**Screenshot Note:** Capture configuration screen for reference.

! IMPORTANT
Without $Prompt$, direct runs fail when args are needed.

## Project: Reading Student Object Values from Command Line

Develop a program creating student objects from command line inputs.

**Lab Demo Steps:**
1. Create two classes: `Student.java` and `College.java`.
2. In `Student.java`:
   - Properties: `int sno`, `String sname`, `String course`, `double fee`, `String email`, `long mobile`, `char gender`, `boolean studying`.
3. In `College.java`:
   - Main method reads args in order: sno, sname, course, fee, email, mobile, gender, studying.
   - Parse accordingly:
     ```java
     int sno = Integer.parseInt(args[0]);
     String sname = args[1];
     String course = args[2];
     double fee = Double.parseDouble(args[3]);
     String email = args[4];
     long mobile = Long.parseLong(args[5]);
     char gender = args[6].charAt(0);
     boolean studying = Boolean.parseBoolean(args[7]);
     ```
   - Create Student object: `Student s = new Student();` (set properties).
   - Display object values.
4. Compile: `javac Student.java College.java`.
5. Execute: `java College 101 "John Doe" "Java" 2500.0 "john@example.com" 9876543210 "M" true`.
6. Output: Display all student details.

**Example Command:**
```
java College 101 "Harry Krishna" "Core Java" 2500.0 "harry@gmail.com" 8877665544 "M" true
```

**Expected Output:** Printed student details in a row.

! NOTE
Order of args must match parsing sequence to avoid exceptions.

## Summary

### Key Takeaways

```diff
+ Key Takeaway: Command line arguments enable dynamic programs by passing Strings to main(String[] args), requiring parsing for non-String types.
+ Understanding JVM: Internal array creation and reference passing is crucial for memory management.
+ Parsing Methods: Use wrapper class parseXXX for safe conversions, throwing exceptions on errors.
+ Test Cases Essential: Validate no args, extra args, and invalid types to ensure robustness.
+ IDE Configuration: Add $Prompt$ for arg prompting in development environments.
+ Project Application: Builds toward object-oriented designs reading complex inputs.
```

### Expert Insight

**Real-world Application:**
Command line arguments are foundational in scripting, automation, and CLI tools (e.g., Maven, Gradle for build parameters). In production, they configure servers (e.g., port, host), pass database credentials, or set debug modes without code changes. Useful in Docker containers and CI/CD pipelines where args customize runtime behavior.

**Expert Path:**
Master by practicing all primitives parsing. Dive into exception handling with try-catch for user-friendly errors. Learn frameworks like Apache Commons CLI for advanced arg parsing. Study JVM internals via open-source JDK code. Experiment with varied arg counts and integrate with file I/O. Join coding communities to review arg-heavy projects.

**Common Pitfalls and Resolutions:**
- **Pitfall:** Forgetting to handle exceptions; resolution: Wrap parse calls in try-catch, log errors, prompt re-entry.
- **Pitfall:** Misordering args; resolution: Document arg order in comments/code docs, use named parameters if advanced tools.
- **Lesser Known:** Wrapper classes cache small values (e.g., Integer -128 to 127), improving performance. Avoid `new Integer()` in loops; use valueOf() for caching benefits.
- **Resolution Tips:** For char multichar strings, use full String; for complex parsing, consider regex before simple charAt. Debug with args.length checks.
