# Session 49: Command Line Arguments

## Table of Contents
- [Scanner Class Usage](#scanner-class-usage)
- [Difference Between next() and nextLine()](#difference-between-next-and-nextline)
- [Reading Multiple Values with next() and nextLine()](#reading-multiple-values-with-next-and-nextline)
- [Input Mismatch Exception](#input-mismatch-exception)
- [Reading Numbers and Strings with Scanner](#reading-numbers-and-strings-with-scanner)
- [Console Class for Secure Input](#console-class-for-secure-input)
- [Implementing Login Form with Console](#implementing-login-form-with-console)

## Scanner Class Usage
### Overview
The Scanner class is a powerful tool in Java for reading input from the console (System.in). It supports various data types and methods for parsing input. This session builds on previous discussions about scanner methods, emphasizing input validation and secure reading.

### Key Concepts/Deep Dive
Scanner methods are designed to read different data types with specific validations:
- **nextByte()**: Reads a byte value (range -128 to 127). Throws InputMismatchException if input is invalid.
- **nextShort()**: Reads a short value (range -32,768 to 32,767). Throws InputMismatchException for invalid input.
- **nextInt()**: Reads an integer. Throws InputMismatchException if input is not an integer.
- **nextLong()**: Reads a long integer. Throws InputMismatchException for invalid input.
- **nextFloat()**: Reads a float. Accepts integers or floats.
- **nextDouble()**: Reads a double. Accepts integers, floats, or doubles.
- **nextBoolean()**: Reads boolean values. Returns false for non-boolean inputs (e.g., numbers, strings).
- **next()**: Reads a single word (up to space or newline).
- **nextLine()**: Reads the entire line (up to newline, including spaces).

> [!NOTE]
> Always import `java.util.Scanner` before using the Scanner class.

### Code/Config Blocks
#### Basic Scanner Usage Example
```java
import java.util.Scanner;

public class ScannerExample {
    public static void main(String[] args) {
        Scanner scn = new Scanner(System.in);
        
        System.out.print("Enter number: ");
        int number = scn.nextInt();
        
        System.out.print("Enter name: ");
        String name = scn.nextLine(); // Note: May cause issues after nextInt()
        
        System.out.println("Entered: " + number + " and " + name);
        scn.close();
    }
}
```
This example demonstrates creating a Scanner object and reading different types of input.

## Difference Between next() and nextLine()
### Overview
The `next()` and `nextLine()` methods differ in how they tokenize input: `next()` reads word by word, while `nextLine()` reads the entire line.

### Key Concepts/Deep Dive
- **next()**: Reads input up to the first space or newline, leaving remaining characters in the Scanner's buffer.
- **nextLine()**: Reads the entire line, including spaces, up to the newline character.

Example in memory diagram:
- Input: "Har Krishna\n"
- `next()`: Reads "Har", leaves " Krishna\n" in buffer.
- `nextLine()`: Reads "Har Krishna\n" completely.

> [!IMPORTANT]
> Mixing `next()` and `nextLine()` requires careful handling to avoid buffer issues.

## Reading Multiple Values with next() and nextLine()
### Overview
Reading multiple values involves understanding buffer behavior. Input is buffered, and newline characters persist in the stream.

### Key Concepts/Deep Dive
- After calling numeric methods (e.g., `nextInt()`), the newline character remains in the buffer.
- Calling `nextLine()` after these methods reads the leftover newline, resulting in an empty string.
- **Solution**: Call `nextLine()` twice: once to consume the newline, then to read actual input.

#### Example Problem
```java
Scanner scn = new Scanner(System.in);

System.out.print("Enter number: ");
int num = scn.nextInt(); // Leaves newline in buffer

System.out.print("Enter name: ");
String name = scn.nextLine(); // Reads newline, returns empty string

// Solution
String nameFixed = scn.nextLine(); // First call consumes newline
nameFixed = scn.nextLine(); // Second call reads actual input
```
Always read one value at a time to avoid confusion.

## Input Mismatch Exception
### Overview
InputMismatchException occurs when input does not match the expected data type for Scanner methods.

### Key Concepts/Deep Dive
- Triggered when reading incompatible data types (e.g., calling `nextInt()` on a string).
- Prevention: Validate input or handle exceptions with try-catch.

```java
Scanner scn = new Scanner(System.in);
System.out.print("Enter number: ");
try {
    int num = scn.nextInt();
    System.out.println("Number: " + num);
} catch (InputMismatchException e) {
    System.out.println("Invalid input. Please enter a number.");
    scn.next(); // Consume invalid input
}
```

## Reading Numbers and Strings with Scanner
### Overview
Scanner automatically handles type conversion for numeric types but requires awareness of buffer management for strings.

### Key Concepts/Deep Dive
- Numeric methods parse input directly.
- For strings with spaces, use `nextLine()` and avoid mixing with numeric inputs without buffer management.
- In projects, read values one at a time to prevent issues.

#### Lab Demo: Reading Student Details
```java
import java.util.Scanner;

public class StudentReader {
    public static void main(String[] args) {
        Scanner scn = new Scanner(System.in);
        
        System.out.print("Enter student number: ");
        int studentNumber = scn.nextInt();
        
        // Consume newline
        scn.nextLine();
        
        System.out.print("Enter student name: ");
        String studentName = scn.nextLine();
        
        System.out.print("Enter course: ");
        String course = scn.nextLine();
        
        System.out.print("Enter fee: ");
        double fee = scn.nextDouble();
        
        System.out.print("Enter email: ");
        String email = scn.next();
        
        System.out.print("Enter mobile: ");
        long mobile = scn.nextLong();
        
        System.out.print("Enter gender: ");
        char gender = scn.next().charAt(0);
        
        System.out.print("Are you in course completed? ");
        boolean courseCompleted = scn.nextBoolean();
        
        // Display values
        System.out.println("Student number: " + studentNumber);
        System.out.println("Student name: " + studentName);
        System.out.println("Course: " + course);
        System.out.println("Fee: " + fee);
        System.out.println("Email: " + email);
        System.out.println("Mobile: " + mobile);
        System.out.println("Gender: " + gender);
        System.out.println("Course completed: " + courseCompleted);
        
        scn.close();
    }
}
```
**Steps to run:**
1. Compile: `javac StudentReader.java`
2. Run: `java StudentReader`
3. Enter values as prompted.
4. Observe buffer management to avoid empty string issues.

If `next()` is used after numeric methods, call `nextLine()` twice as a workaround.

#### Engaging Students in Development
Instruct students to rewrite the program to read user input dynamically, reinforcing one-value-at-a-time reading.

Constructing multi-word names via concatenation (e.g., `name = next() + " " + next()`) is a workaround but not recommended for projects.

## Console Class for Secure Input
### Overview
Console class (introduced in Java 6) enables secure reading of confidential data like passwords by hiding input on the screen.

### Key Concepts/Deep Dive
- Unlike Scanner, Console hides password input (no echoes, cursor doesn't move).
- Methods: `readLine()` for normal input, `readPassword()` for secure input (returns char[]).
- Constructor is private to prevent multiple instances; access via `System.console()`.

#### Why Console Constructor is Private
Console represents the current command prompt. Creating new instances would reference a non-existent console. `System.console()` returns the existing console object linked to JVM.

```mermaid
flowchart TD
    A[User Opens Command Prompt] --> B[JVM Loads with Console Association]
    B --> C[System Class Holds Console Reference]
    C --> D[System.console() Returns Existing Console Object]
```

`readPassword()` returns char[] for security (allows wiping from memory post-use).

## Implementing Login Form with Console
### Overview
Combine Console for password reading with validation against database concepts.

### Key Concepts/Deep Dive
- Use Console for username (normal) and password (secure).
- Validation is against a database, not just Console.
- System properties approach follows in next session.

#### Lab Demo: Login Validator with Console
```java
import java.io.Console;

public class LoginValidator {
    public static void main(String[] args) {
        Console console = System.console();
        
        if (console == null) {
            System.err.println("Console not available");
            return;
        }
        
        String username = console.readLine("Enter username: ");
        char[] passwordChars = console.readPassword("Enter password: ");
        String password = new String(passwordChars);
        
        // Wipe password from memory
        java.util.Arrays.fill(passwordChars, ' ');
        
        // Display (in real app, validate against DB)
        System.out.println("Username: " + username);
        System.out.println("Password entered securely");
        
        // Add validation logic here
    }
}
```
**Steps:**
1. Compile and run in command prompt (not IDE console).
2. Enter username (visible).
3. Enter password (hidden, cursor blinks in place).
4. Convert char[] to String for validation.
5. Wipe char[] for security.

Rewrite existing programs using Scanner to use Console for enhanced security.

## Summary

### Key Takeaways
```diff
+ Scanner is best for CUI applications due to buffer management and type safety.
+ next() reads single words; nextLine() reads entire lines.
+ Call nextLine() twice after numeric methods to handle newline buffers.
+ Console class provides secure password reading with hidden input.
+ InputMismatchException requires try-catch or input validation.
+ Read one value at a time in projects to avoid buffer issues.
- Avoid mixing next() and nextLine() without buffer management.
- Do not store passwords as String; use char[] and wipe memory.
- Facilities may skip buffer explanations; analyze independently for clarity.
```

### Expert Insight

**Real-world Application**: In enterprise applications, use Console for login forms in CLI tools (e.g., deployment scripts). For web apps, combine with secure protocols; for desktop, integrate with UI frameworks. At scale, externalize data reading to avoid threading issues.

**Expert Path**: Master all five input approaches (command line args, System.in, DataInputStream, BufferedReader, Scanner/Console). Practice memory diagrams for buffer visualization. Study Java source code for input handling internals. Contribute to open-source CLI tools using Scanner/Console.

**Common Pitfalls**: 
- Forgetting to consume newline after numeric inputs leads to skipped inputs.
- Using String for passwords exposes data in memory dumps.
- Calling nextLine() multiple times unnecessarily slows execution.
- Assuming Console always available (null in IDEs); add null checks.
- Misspelling method names (e.g., "nextShot" instead of "nextShort()").

**Lesser Known Things**: Console maps to operating system console, enabling native-level input hiding. ReadPassword uses platform-specific APIs for security. Scanner's buffer can be problematic in multithreaded environments—use synchronized blocks. Java 9+ offers unbuffered Console alternatives for ultra-sensitive data. Internally, System.console() bridges JVM to OS console via native calls.
