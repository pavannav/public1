# Session 27: Reading Runtime Values from Console

## Table of Contents
- [Overview](#overview)
- [Command Line Arguments](#command-line-arguments)
- [Buffer Reader Approach](#buffer-reader-approach)
- [Scanner Class](#scanner-class)
- [Key Differences Between BufferReader and Scanner](#key-differences-between-bufferreader-and-scanner)
- [Practical Programs with Scanner](#practical-programs-with-scanner)
- [Reading Character from Console](#reading-character-from-console)
- [Lab Demo: Scanner Programs](#lab-demo-scanner-programs)

## Overview
This session covers how to read runtime values (user input) from the console in Java. We explore three main approaches: command line arguments, BufferReader, and Scanner class. The session emphasizes understanding internal flow, memory diagrams, and handling of characters like enter keys. Beginners learn about console connections (system.in, system.out) and why Scanner is preferred in modern Java (from Java 5).

> [!NOTE]
> Console in Java refers to the command prompt window where JVM runs. Input through keyboard connects via system.in, output displays via system.out.

### Corrections Made from Transcript
- "cept" corrected to "accept"
- "inners" corrected to " dispiace" no, it seemed like typos in speech, but transcript has "system.inners" → corrected to "system.in ers" wait, actually "system.in" consistently.
- "BR" → "BufferReader"
- "S" → "Scanner"
- Random misspellings like "oted" → "noted"

## Command Line Arguments
### Overview
Command line arguments allow passing values when running a Java program (e.g., `java Addition 10 20`). These are static values passed before execution, not read during runtime from console.

### Key Concepts/Deep Dive
- **Definition**: Static input provided via command prompt arguments.
- **Steps**:
  1. Args array: `public static void main(String[] args)`
  2. Access: `args[0]` for first value, etc.
  3. Conversion: Use `Integer.parseInt(args[0])` to convert to int.
- **Initialization Flow**:
  ```
  Sequential
  User Run Command (e.g., java MyClass 10 20)
  → JVM Loads Class
  → Main Method Called with args array ["10", "20"]
  → Parse and Use
  ```
- **Limitations**:
  - No interactive input; values must be known beforehand.
  - Errors if missing arguments (ArrayIndexOutOfBoundsException).
  - No decimal/float support without parsing.

### Code Example
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

### Command to Run
```bash
javac Addition.java
java Addition 10 20
```

## Buffer Reader Approach
### Overview
BufferReader, from `java.io`, creates a buffered connection to read input line-by-line. Commonly used with `InputStreamReader` for byte to character conversion (pipe analogy: filter for clean water).

### Key Concepts/Deep Dive
- **Connection Setup**:
  ```diff
  ! Keyboard (Bytes) → System.in (Bytes) → InputStreamReader (Bytes to Chars) → BufferReader (Buffered Chars)
  ```
- **Memory Diagram Visualization**:
  ```mermaid
  flowchart LR
      A[Keyboard] --> B["System.in (Bytes)"] --> C("InputStreamReader") --> D("BufferReader")
      E[["JVM"]] --> F["System.out"]
      G["Console Window"] --> B
  ```
- **Reading Process**:
  1. Create objects: `BufferReader BR = new BufferReader(new InputStreamReader(System.in));`
  2. Call `BR.readLine()`: Pauses if no data, reads entire line until enter key (identity marker).
  3. Parse: `int a = Integer.parseInt(BR.readLine());`
- **Data Flow**:
  - User enters "50\n" (50 + enter).
  - `System.in` + ISR filters to chars "50\n".
  - `BR.readLine()` reads "50\n", returns "50" (excludes enter? No, returns full string).
  - Manual parsing needed.

### Code Example
```java
import java.io.*;
class Addition {
    public static void main(String[] args) throws IOException {
        BufferReader br = new BufferReader(new InputStreamReader(System.in));
        System.out.print("Enter first number: ");
        int a = Integer.parseInt(br.readLine());
        System.out.print("Enter second number: ");
        int b = Integer.parseInt(br.readLine());
        int c = a + b;
        System.out.println("Result: " + c);
    }
}
```

### Problems with BufferReader
- Requires `throws IOException` (still possible even if rare).
- Lengthy object creation (lengthy pipe).
- Manual parsing for primitives (no direct int/float read).
- Can't read multiple values separately; reads entire line, needs splitting.
- Identical code structure across programs.

## Scanner Class
### Overview
Introduced in Java 5, Scanner fixes BufferReader issues. From `java.util`, it handles exceptions, parses automatically, and reads primitives directly.

### Key Concepts/Deep Dive
- **Advantages Over BufferReader**:
  ```diff
  + Direct primitive reading (nextInt(), etc.)
  - No throws declaration
  + Short object creation: Scanner sn = new Scanner(System.in);
  + Handles multiple values per line (space-separated)
  ```
- **Nine Methods**:
  1. `nextByte()` - Reads byte
  2. `nextShort()` - Reads short
  3. `nextInt()` - Reads int
  4. `nextLong()` - Reads long
  5. `nextFloat()` - Reads float
  6. `nextDouble()` - Reads double
  7. `nextBoolean()` - Reads boolean
  8. `next()` - Reads next word (up to space)
  9. `nextLine()` - Reads entire line

  | Method | Type | Example |
  |--------|------|---------|
  | nextInt() | int | `int id = sn.nextInt();` |
  | nextDouble() | double | `double salary = sn.nextDouble();` |
  | next() | String (word) | `String name = sn.next();` |
  | nextLine() | String (line) | `String address = sn.nextLine();` |

- **Scanner vs. BufferReader Exceptions**:
  - Scanner throws `InputMismatchException` for wrong input type.
  - No `IOException` handling needed.

### Memory Diagram with Scanner
```mermaid
flowchart TD
    A[Console] --> B[System.in]
    B --> C["Scanner Object"]
    C --> |nextInt()| D["Reads int, leaves enter"]
    C --> |nextLine()| E["Reads line, removes enter"]
    F[JVM] --> G[System.out] --> H[Console Output]
```

## Key Differences Between BufferReader and Scanner
| Feature | BufferReader | Scanner |
|---------|--------------|---------|
| Package | java.io | java.util |
| Exception | throws IOException | No throws (self-handled) |
| Object Creation | Lengthy with ISR | Simple: new Scanner(System.in) |
| Primitive Reading | Manual parsing | Direct with nextXxx() |
| Multi-Value Reading | Needs manual splitting | Automatic space-separated |
| String Reading | readLine() for line | next() for word, nextLine() for line |
| Enter Key Handling | Includes in string | Ignores in primitives, reads in nextLine() |

## Practical Programs with Scanner
### Overview
Programs demonstrating Scanner for numbers and names. Covers mixing primitives and strings, handling enter key remnants.

### Key Concepts/Deep Dive
- **Problem with Mixing nextInt() and nextLine()**:
  - `nextInt()` reads number, leaves enter in buffer.
  - `nextLine()` sees enter, returns empty string.
  - **Solution**: Call `sn.nextLine()` twice: once to clear enter, second for actual input.
- **next() vs. nextLine()**:
  - `next()`: Reads first word (e.g., "Har Krishna" → "Har")
  - `nextLine()`: Reads full line (e.g., "Har Krishna" → "Har Krishna")

### Code Examples
#### Program 1: Read Two Numbers
```java
import java.util.*;
class Addition {
    public static void main(String[] args) {
        Scanner sn = new Scanner(System.in);
        System.out.print("Enter first number: ");
        int a = sn.nextInt();
        System.out.print("Enter second number: ");
        int b = sn.nextInt();
        int c = a + b;
        System.out.println("Result: " + c);
    }
}
```

#### Program 2: Read Name (Word)
```java
import java.util.*;
class ReadName {
    public static void main(String[] args) {
        Scanner sn = new Scanner(System.in);
        System.out.print("Enter name: ");
        String name = sn.next();
        System.out.println("You entered: " + name);
    }
}
```
- Output for "Har Krishna": "Har"

#### Program 3: Read Name (Line with Spaces)
```java
import java.util.*;
class ReadName {
    public static void main(String[] args) {
        Scanner sn = new Scanner(System.in);
        System.out.print("Enter name: ");
        String name = sn.nextLine();
        System.out.println("You entered: " + name);
    }
}
```
- Output: "Har Krishna"

#### Program 4: Read Number and Name (Fixing Enter Issue)
```java
import java.util.*;
class ReadStudent {
    public static void main(String[] args) {
        Scanner sn = new Scanner(System.in);
        System.out.print("Enter number: ");
        int number = sn.nextInt();
        sn.nextLine(); // Consume leftover enter
        System.out.print("Enter name: ");
        String name = sn.nextLine();
        System.out.println("Number: " + number + ", Name: " + name);
    }
}
```
- Without `sn.nextLine()`, name reads empty.

## Reading Character from Console
### Overview
No direct nextChar() in Scanner. Use next().charAt(0) or Character.parseChar(next()).

### Key Concepts/Deep Dive
- **Method**: `char ch = sn.next().charAt(0);`
- **Reason**: Characters are single entities; next() reads string, extract first char.
- **Example**:
  ```java
  import java.util.*;
  class ReadChar {
      public static void main(String[] args) {
          Scanner sn = new Scanner(System.in);
          System.out.print("Enter char: ");
          char ch = sn.next().charAt(0);
          System.out.println("Char: " + ch);
      }
  }
  ```

## Lab Demo: Scanner Programs
### Overview
Step-by-step demo of reading and adding two numbers, then name.

### Lab Steps
1. **Setup**: Create JDK environment, open editor (Eclipse or Notepad).
2. **Write Code**: Copy the Addition class above.
3. **Compile**: Open command prompt, cd to directory, run `javac Addition.java`.
   ```bash
   javac Addition.java
   ```
   - Verify: Checks for errors; creates `Addition.class`.
4. **Run**: Execute `java Addition`.
   ```bash
   java Addition
   ```
   - Console shows "Enter first number:".
   - Enter 10, press Enter.
   - Shows "Enter second number:".
   - Enter 20, press Enter.
   - Shows "Result: 30".
5. **Test Variants**:
   - Enter decimals → Use nextDouble().
   - Enter name → Add name reading after number.
6. **Debug Errors**:
   - InputMismatchException: Wrong type entered.
   - Restart if needed.

## Summary
### Key Takeaways
```diff
+ Runtime input via console uses System.in connection (pipe with filters)
+ BufferReader reads lines, requires parsing/parsing and throws IOException
- Scanner simplifies with direct type reading, no throws, but handle enter remnants
+ nextInt() reads int, nextLine() reads string until enter
- Mixing nextInt() and nextLine() causes empty reads; fix with extra nextLine()
+ Nine Scanner methods: primitive + two for strings (next/nextLine)
+ Common flow: Instantiate Scanner > Prompt message > Read method > Process
+ Testing crucial: Brain diagram experience for bug understanding
+ Modern Java prefer Scanner over BufferReader
```

### Expert Insight
#### Real-world Application
In web apps/e-commerce, user inputs (age, address) read via Scanner/BufferedReader. For console-based tools (e.g., banking CLI apps), Scanner handles multi-input forms efficiently. Enterprise level: Use frameworks like Spring for web forms; CLI tools in devops (e.g., Jenkins plugins) rely on console input.

#### Expert Path
Master by building CLI calculators, databases (read id/name), then advance to file input/output. Practice visual diagrams; debug InputMismatch by checking input types. Explore advanced: Scanner with File sources, regex split. Daily 15-min typing practice for code writing speed.

#### Common Pitfalls
```diff
- Forgetting import java.util.Scanner → Compilation: class not found
- Mixing nextInt() and nextLine() without clearance → Empty name reads
- Entering wrong types → InputMismatchException (no recovery; restart)
- Relying on next() for names with spaces → Gets first word only
- Not understanding enter key leftover → Causes premature exits
- Scanner vs. printf debates: Scanner for input, printf for formatted output
- Skipping visualization: Without memory diagrams, can't solve real issues
```

Common issues: Program hangs? Data not buffered—check next() calls. Solutions: Use try-catch for robustness, validate inputs.Resolution: Always call sn.nextLine() after primitives to flush enter.Remember: Input is "value + enter" (string); parse accordingly.

#### Lesser Known Things
- Scanner internally tokenizes with whitespace; next() uses delimiter.
- BufferReader buffer size default 8192; customizable.
- Scanner auto-handles locales; use `sn.useLocale(Locale.US)` for decimal points.
- Enter key (\n) vs. \r\n; Unix/Windows—Scanner handles cross-platform. INTERNAL: Scanner delegates to Matcher for parsing; study `java.util.Scanner` source on GitHub for deep understanding. HINT: For complex inputs, combine Scanner with regexplits.
