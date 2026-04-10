# Session 8: Java Programming Fundamentals: Escape Sequences and Basic I/O

- [Review of Previous Concepts](#review-of-previous-concepts)
- [Understanding Tab Space Behavior with Escape Sequences](#understanding-tab-space-behavior-with-escape-sequences)
- [Student Details Printing Program](#student-details-printing-program)
- [Course Enrollment and Payment Details](#course-enrollment-and-payment-details)
- [Escape Sequence Characters Explanation](#escape-sequence-characters-explanation)
- [Programs Demonstrating String Quotes](#programs-demonstrating-string-quotes)
- [Typing and Practice Resources](#typing-and-practice-resources)

## Review of Previous Concepts

### Overview
In this session, the instructor reviews fundamental Java programming practices established in prior sessions, emphasizing procedural accuracy, output verification, and practical coding habits. Students are reminded to physically type programs on their systems rather than copying code blindly, ensuring they understand the execution flow and verify outputs against expected results. This builds a foundation for debugging and ensures programs are not just syntactically correct but logically sound. Basic programs include displaying messages, using multiple `System.out.println` statements, printing names in specific patterns, and controlling output formatting through escape sequences.

### Key Concepts/Deep Dive
- **Basic Program Structure**:
  - Every Java program requires a class, public static void main method, and output statements.
  - File naming must match the class name with a `.java` extension.
  - Compilation (`javac ClassName.java`) produces bytecode, followed by execution (`java ClassName`).

- **Procedural Best Practices**:
  - **Class Name Conventions**: Choose descriptive names (e.g., `NamePrinter`) without spaces, using PascalCase.
  - **Compilation and Execution**:
    - Compile: `javac ClassName.java`
    - Execute: `java ClassName` (without `.class`)
    - Change directory to the folder containing the file before running commands.
  - **Output Verification**: Compare program output with expected results to detect errors early.

- **Multiple SOP Statements**: Use multiple `System.out.println` statements for line-separated outputs. Avoid unnecessary statements; aim for single statements where possible using escape sequences.

- **Printing Patterns**:
  - Use escape sequences in single `System.out.println` statements to manipulate output formatting.
  - Example: Printing a vertical name pattern using `\n` for new lines and `\t` for tabs.

### Code/Config Blocks

Example program for single `System.out.println` vertical pattern:

```java
class NamePatternPrinter {
    public static void main(String[] args) {
        System.out.println("H\n\t\t\t\tR\n\t\t\t\t\t\t\tI");
    }
}
```

Compilation: `javac NamePatternPrinter.java`
Execution: `java NamePatternPrinter`

## Understanding Tab Space Behavior with Escape Sequences

### Overview
Escape sequences manipulate output formatting in Java. The tab sequence (`\t`) inserts spaces to align text, but its behavior depends on the number of characters to the left of the tab. Unlike a fixed 8-space insertion, `\t` adds up to 8 spaces based on remaining space in the 8-character alignment field, ensuring vertical alignment of subsequent lines. This promotes readable, aligned console output for structured data like reports.

### Key Concepts/Deep Dive
- **Escape Sequences Basics**:
  - Preceded by backslash (`\`), modifying character meaning.
  - Examples: `\n` (newline), `\t` (tab space), `\s` (single space).

- **Tab Space Mechanics**:
  - Inserts up to 8 spaces per `\t`, counted from the start of the line.
  - Dependent on characters already present (left-side consideration).
  - Formula: Spaces added = min(8, 8 - (current position % 8))
  - Practical example:
    - After 1 character: Adds 7 spaces to reach next 8-space boundary.
    - After 8+ characters: Resets and adds up to 8 fresh spaces.

- **Practical Application**:
  - Align colons or labels in vertical output for user-friendly displays.
  - Combine with loops or conditional logic for dynamic formatting.

### Tables
| Scenario                  | Characters Left | Spaces Added by `\t` | Total Position |
|---------------------------|-----------------|----------------------|----------------|
| Start of line             | 0               | 8                    | 8              |
| After 2 characters        | 2               | 6                    | 8              |
| After 5 characters        | 5               | 3                    | 8              |
| After 8 characters        | 0 (reset)       | 8                    | 16             |

### Lab Demos
Develop a program to print student details with aligned colons:

1. Create a new notepad file.
2. Type the class structure:
   ```java
   class StudentDetailsPrinter {
       public static void main(String[] args) {
           System.out.println("Student Number:\t\t\t\t\t\t1");
           System.out.println("Student Name:\t\t\t\t\t\t\tHK");
           System.out.println("Course:\t\t\t\t\t\t\t\t\t\n\nCore Java");
           System.out.println("Fees:\t\t\t\t\t\t\t\t\t\t\n\n3500");
       }
   }
   ```
3. Save as `StudentDetailsPrinter.java`.
4. Open Command Prompt, navigate to file directory (`cd path\to\folder`).
5. Compile: `javac StudentDetailsPrinter.java`
6. Execute: `java StudentDetailsPrinter`
7. Verify output: Colons align vertically despite varying label lengths.

Expected output:
```
Student Number:					1
Student Name:					HK
Course:					Core Java
Fees:					3500
```

## Student Details Printing Program

### Overview
This program demonstrates aligned output using `\t` for structured display. It separates labels and values with colons, ensuring readability by aligning colons in a vertical line. This technique is common in console applications for reports or menus.

### Key Concepts/Deep Dive
- **Alignment Goals**:
  - Place colons vertically by calculating appropriate `\t` usage based on left-side character counts.
  - Example: Longer labels (e.g., "Student Name") require fewer `\t` for alignment.

- **Error Prevention**:
  - Avoid over-using `\t`; test and adjust based on output.
  - Ensure no extra spaces; rely on escape sequence precision.

### Lab Demos
1. Open notepad.
2. Input program:
   ```java
   class StudentDetailsAligned {
       public static void main(String[] args) {
           System.out.println("Student Number:\t1");
           System.out.println("Student Name:\t\tHK");
           System.out.println("Course:\t\t\t\tCore Java");
           System.out.println("Fees:\t\t\t\t\t3500");
       }
   }
   ```
3. Save as `StudentDetailsAligned.java`.
4. Compile and execute.
5. Adjust `\t` counts if alignment fails; observe character counts per line.

## Course Enrollment and Payment Details

### Overview
Discussion covers course structure, fees, duration, and enrollment for Full Stack Java or Core Java programs. Emphasizes commitment, daily practice, and resources. Notes importance of recording screenshots for future reference and adding proper details in payment remarks.

### Key Concepts/Deep Dive
- **Course Options**:
  - **Full Stack Java**: 6 months, ~3 courses, ₹107,000 (without recordings); ₹150,000+ (with recordings).
  - **Core Java**: 3 months, ₹35,000.
  - Duration: 6 months (Full Stack), 3 months (Core).
  - Schedule: 9 AM IST - 11 PM IST, 6 days/week + Sundays for catch-up.

- **Enrollment Process**:
  - Pay via provided links; include name, course, timing, faculty in remarks.
  - Admin adds to Google Classroom post-payment.
  - Save payment screenshots as proof.

- **Resources**: Books, running notes, YouTube/Instagram reels for revision.

### Tables
| Course          | Duration | Fee (Without Recordings) | Fee (With Recordings) |
|-----------------|----------|--------------------------|-----------------------|
| Core Java      | 3 months | ₹35,000                | Extra fee required    |
| Full Stack Java| 6 months | ₹107,000               | ₹150,000+            |

## Escape Sequence Characters Explanation

### Overview
Escape sequences override default character meanings, enabling advanced output formatting in Java. They consist of a backslash followed by a single character, supported across compilers and consoles for portability.

### Key Concepts/Deep Dive
- **Definition**: `\` + single character (e.g., `\n`), altering behavior from compiler/JVM/console.

- **Supported Characters (9 total)**:
  - `\n`: Newline (shifts to next line).
  - `\t`: Tab (up to 8 spaces, aligned).
  - `\s`: Single space.
  - `\r`: Carriage return.
  - `\f`: Form feed.
  - `\b`: Backspace.
  - `\"`: Double quote (print literal).
  - `\'`: Single quote (print literal).
  - `\\`: Backslash (print literal).

- **Mnemonic**: "NTR Facebook single code double code slash" (9 characters).

- **Usage Rules**:
  - Slash for suppressing meaning (e.g., `\"` in strings).
  - Direct use for literal in appropriate contexts.

### Code/Config Blocks
Example demonstrating quotes:
```java
class QuoteDemo {
    public static void main(String[] args) {
        System.out.println("\"Har Krishna\"");  // Escaped quotes
        System.out.println('\'\'');             // Escaped single quote
    }
}
```

Compile: `javac QuoteDemo.java`
Execute: `java QuoteDemo`

## Programs Demonstrating String Quotes

### Overview
Programs showcase printing names or text with included quote characters using escape sequences. Highlights differences between single quotes (one character) and double quotes (multiple characters).

### Key Concepts/Deep Dive
- **Double Quotes in Strings**: Use `\"` to include.
- **Single Quotes in Strings**: Use `\'` if needed.
- **Single Quotes for Characters**: Use `'` for one character; escape if printing literal.

### Lab Demos
Program to print name with quotes:
1. Input:
   ```java
   class NameWithQuotes {
       public static void main(String[] args) {
           System.out.println("\"Har Krishna\"");
           System.out.println('\'H\'');
       }
   }
   ```
2. Save, compile, execute.
3. Output: `"Har Krishna"` and `'H'`.

## Typing and Practice Resources

### Overview
Emphasizes typing skills as crucial for coding. Resources like typing.com improve finger positioning and speed, complementing Java practice.

### Key Concepts/Deep Dive
- **Importance**: Enhances accuracy; practice 15 minutes daily.
- **Resources**:
  - typing.com: Sign up, practice lessons (e.g., J, F).
  - hackerrank.com: Coding challenges for skills.
  - Future: LeetCode for advanced problems.

- **Routine**: Practice typing first, then Java programs.

### Lab Demos
1. Visit typing.com.
2. Sign up as student.
3. Complete beginner lessons (e.g., J, F).
4. Aim for 15 minutes daily.

## Summary

### Key Takeaways
- Master escape sequences for formatted output; focus on `\n`, `\t`, `\"`.
- Verify tab alignment by character count; align vertically for readability.
- Physically type programs and use resources like typing.com.

### Expert Insight
#### Real-world Application
Escape sequences are vital in console apps for logs or reports, ensuring clean output in production tools like debuggers or command-line utilities.

#### Expert Path
Practice daily on hackerrank; build rhythm with systematically typing complex patterns. Join communities for peer code reviews.

#### Common Pitfalls
- Forgetting backslashes: Always check for syntax errors; common in copying from books.
- Over-relying on multiple SOPs: Optimize with single statements using escapes.
- Environment issues: Ensure JDK 21; clear classpath if commands fail.

> [!NOTE]
> Physical practice reinforces concepts; avoid shortcuts for exam/interview readiness.

### Lesser Known Things
- Tab alignment depends on console width; use libraries like Apache Commons for advanced formatting.
- Escape sequences render identically across oses, but test console-specific behaviors.
