# Session 28: Core Java - Scanner Class and Reading Runtime Values

## Table of Contents
- [Overview](#overview)
- [Key Concepts](#key-concepts)
- [Lab Demo](#lab-demo)
- [Summary](#summary)

## Overview

This session focuses on the Scanner class in Java, which is used to read input from various sources, primarily the keyboard (standard input). We recap the previous session's programs and dive deeper into how the `nextXXX` methods handle input data, enter key characters, and the importance of choosing the correct method for different data types. The session demonstrates building a complete program to read student details dynamically from the keyboard and store them in custom objects, covering all primitive and string data types.

## Key Concepts

### Recap of Scanner Programs

- **First Program**: Reading integers or numbers using `nextInt()`.
- **Second Program**: Reading strings using `nextLine()` for complete lines or `next()` for single words.
- **Third Program**: Combining number and string reading, handling input order carefully.

### Understanding Scanner Object and Enter Key Behavior

- **Scanner Object Creation**:
  ```java
  import java.util.Scanner;
  Scanner sn = new Scanner(System.in);
  ```

- **How `nextXXX` Methods Work**:
  - All `nextXXX` methods (e.g., `nextInt()`, `nextDouble()`, `next()`) read data up to either a space or newline character (enter key).
  - After reading, the enter key character remains in the scanner buffer unless consumed.

- **Enter Key Characters in Scanner Buffer**:
  > [!IMPORTANT]
  > When you press Enter after typing input, the newline character (`\n`) is also sent to the scanner object. This can interfere with subsequent readings if not handled properly.

- **Example Flow**:
  - Call `sn.nextInt()` → reads "10" from "10\n", leaves `\n`.
  - Call `sn.nextInt()` again → ignores `\n`, pauses for new input.

- **`next()` Method** (String reading):
  - Reads complete words up to space or newline.
  - Ignores leading newline characters.
  - Example: Input "hello world\n" → reads "hello".

- **`nextLine()` Method** (Full line reading):
  - Reads the entire line including spaces, until newline.
  - Useful for inputs with spaces (e.g., full names).
  - Leaves the newline character in the buffer? No, it consumes it.

### Reading Different Data Types

- **Primitives**:
  - `int`: `sn.nextInt()` - Reads integer values.
  - `double`: `sn.nextDouble()` - Reads floating-point numbers.
  - `long`: `sn.nextLong()` - Reads long integers.
  - `boolean`: `sn.nextBoolean()` - Reads true/false.

- **Characters**:
  - No direct `nextChar()`. Read as string and extract:
    ```java
    String s = sn.next(); // Or sn.nextLine()
    char ch = s.charAt(0); // Get first character
    ```

- **Strings**:
  - Use `next()` for words without spaces.
  - Use `nextLine()` for complete lines with spaces.

### Method Call Chaining

```diff
+ Recommended: char ch = sn.next().charAt(0);
- Avoid: String temp = sn.next(); char ch = temp.charAt(0);
```

This reads a string and immediately extracts the first character, avoiding unnecessary variables.

### Handling Input After Different Methods

> [!NOTE]
> After calling `nextXXX` (except `nextLine()`), a newline remains in the buffer. If the next input needs `nextLine()`, you'll need to consume it first.

Example sequence:
```java
int num = sn.nextInt(); // Leaves \n
sn.nextLine(); // Consume \n (optional if not storing)
String name = sn.nextLine(); // Now reads the full string
```

## Lab Demo

### Project Structure: Student Data Reading

Develop two classes: `Student.java` (data model) and `College.java` (logic for reading and displaying).

#### Step 1: Create Student Class
```java
public class Student {
    int sno;
    String sname;
    String course;
    double fee;
    String email;
    long mobile;
    char gender;
    boolean studying; // true/false
}
```

#### Step 2: Create College Class with Main Method
```java
import java.util.Scanner;

public class College {
    public static void main(String[] args) {
        Scanner sn = new Scanner(System.in);
        
        // Create Student object
        Student s1 = new Student();
        
        // Read student number
        System.out.print("Enter student number: ");
        s1.sno = sn.nextInt();
        sn.nextLine(); // Consume newline
        
        // Read student name
        System.out.print("Enter student name: ");
        s1.sname = sn.nextLine();
        
        // Read course
        System.out.print("Enter course: ");
        s1.course = sn.nextLine();
        
        // Read fee
        System.out.print("Enter fee: ");
        s1.fee = sn.nextDouble();
        
        // Read email (use nextLine if spaces possible, but next() for no spaces)
        System.out.print("Enter email: ");
        s1.email = sn.next();
        
        // Read mobile
        System.out.print("Enter mobile: ");
        s1.mobile = sn.nextLong();
        
        // Read gender (as character)
        System.out.print("Enter gender (M/F): ");
        s1.gender = sn.next().charAt(0);
        
        // Read studying status
        System.out.print("Enter studying (true/false): ");
        s1.studying = sn.nextBoolean();
        sn.nextLine(); // Consume any remaining newline
        
        // Display values
        System.out.println("Student Number: " + s1.sno);
        System.out.println("Student Name: " + s1.sname);
        System.out.println("Course: " + s1.course);
        System.out.println("Fee: " + s1.fee);
        System.out.println("Email: " + s1.email);
        System.out.println("Mobile: " + s1.mobile);
        System.out.println("Gender: " + s1.gender);
        System.out.println("Studying: " + s1.studying);
    }
}
```

#### Step 3: Compile and Run
- Save files as `Student.java` and `College.java`.
- Compile: `javac *.java`
- Run: `java College`
- Input sample:
  ```
  101
  Hari Krishna
  Core Java
  20000
  hari@gmail.com
  9010454584
  M
  true
  ```

#### Expected Output
```
Student Number: 101
Student Name: Hari Krishna
Course: Core Java
Fee: 20000.0
Email: hari@gmail.com
Mobile: 9010454584
Gender: M
Studying: true
```

## Summary

### Key Takeaways
```diff
+ Scanner class simplifies keyboard input reading with specific methods for each data type.
+ Always handle newline characters left in the buffer to avoid input mismatch exceptions.
+ Use nextLine() for strings with spaces, next() for single words.
+ No direct nextChar() - read as string and use charAt(0).
+ Method chaining (e.g., sn.next().charAt(0)) is efficient and recommended.
```

### Expert Insight

**Real-world Application**: In applications like student management systems, registration forms, or any user input-driven program, Scanner is essential for reading and validating user inputs before processing or storing in databases.

**Expert Path**: Master input validation (e.g., handle exceptions for invalid data types). Explore alternatives like BufferedReader (more manual parsing) or java.io classes for file input. Practice regular expressions with Scanner for pattern-based reading.

**Common Pitfalls**:
- Forgetting to consume newline after primitives before nextLine() → program skips input.
- Using nextLine() after next() can read leftover newline as empty string.
- Attempting to read char directly without string wrapper → compilation errors.
- Mobile numbers exceeding long range (e.g., very large values) → InputMismatchException.
- Not trimming whitespaces in strings before processing.

**Lesser-Known Things**:
- Scanner can read from files: `Scanner sn = new Scanner(new File("data.txt"));`
- Octal numbers start with 0 (e.g., 010 = 8 decimal), hexadecimal with 0x.
- When entering long values from keyboard, no need to suffix 'L' (Scanner handles parsing).
- comments in code should use single quotes for Java syntax highlighting.
