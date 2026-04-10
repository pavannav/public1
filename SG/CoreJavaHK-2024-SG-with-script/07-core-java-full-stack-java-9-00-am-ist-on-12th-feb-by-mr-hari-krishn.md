# Session 07: Core Java Programming Fundamentals

## Table of Contents
- [Overview](#overview)
- [Key Concepts/Deep Dive](#key-conceptsdeep-dive)
  - [Revision of Previous Concepts](#revision-of-previous-concepts)
  - [Applications Developed Using Java vs. Python](#applications-developed-using-java-vs-python)
  - [Developing Java Programs: Software Required](#developing-java-programs-software-required)
  - [Essential Statements in Java](#essential-statements-in-java)
  - [Steps to Develop, Compile, and Execute a Java Program](#steps-to-develop-compile-and-execute-a-java-program)
  - [Print Statements in Java](#print-statements-in-java)
  - [Java Development Workflow](#java-development-workflow)
  - [Sample Programs and Labs](#sample-programs-and-labs)

## Overview
This session focuses on the fundamental aspects of developing Java programs, including early revisions, software setup, essential syntax, and step-by-step processes for creating, compiling, and executing simple Java applications. It introduces basic programming concepts, differences between Java and Python applications, and the importance of a professional software engineering mindset. The session concludes with an introduction to escape sequence characters, emphasizing hands-on practice and self-testing.

## Key Concepts/Deep Dive
### Revision of Previous Concepts
- **Java History and Language Overview**: Java is a platform-independent, multi-threaded programming language invented by Sun Microsystems in 1991, with beta version released in 1995 and stable version in 1996. Its creation aimed to achieve platform independence and develop internet applications.
- **Types of Applications**: Java supports enterprise applications (business logic) and can be used for internet applications. Compared to Python, which excels in data science and machine learning, Java is preferred for large-scale enterprise systems due to its security features, libraries, and frameworks like Spring and Spring Boot.
- **Java vs. Python Comparison**:
  - Java is for developing enterprise applications (e.g., banking, e-commerce).
  - Python is for data science, machine learning, and data analysis (e.g., healthcare software predicting diseases via blood pressure data).
  - Both languages can develop full-stack applications, but Python's framework (Django) lacks Java's advanced security for enterprise use.

| Aspect | Enterprise Application (Java) | Data Science Application (Python) |
|--------|-------------------------------|------------------------------------|
| Primary Use | Business operations, transactions, security | Data analysis, prediction, automation |
| Examples | Banking software, inventory systems | Health diagnostics, data visualizations |
| Frameworks | Spring, Hibernate | Django, TensorFlow |

### Applications Developed Using Java vs. Python
- **Enterprise Applications**: Implement business operations; require high security and multiple libraries. Java dominates here via advanced frameworks.
- **Data Science Applications**: Focus on data analysis and predictions; data processing drives Python's adoption.
- **Real-World Example**: Google devices analyzing health data (e.g., heart attack/cancer risk) use Python for data processing, with Java supporting backend security.
- **Recommendation**: Learn both Java and Python; master Java for full-stack, use Python for data scripting. Python is becoming essential for data processing in enterprises.

### Developing Java Programs: Software Required
- **Required Software**:
  - **Editor**: Notepad (or Notepad++, EditPlus for advanced editing).
  - **Compiler and Runtime**: JDK (Java Development Kit).
  - **Command Prompt**: For compilation and execution.
- **JDK Download**: Download from oracle.com or search "JDK download" on Google. Install to `C:\Program Files\Java\JDK` (avoid spaces in path for compatibility with tools like EditPlus).

### Essential Statements in Java
- **Core Elements for a Java Program**:
  - `class` declaration: Every Java program starts with a class (e.g., `class ClassName {}`).
  - `public static void main(String[] args)`: Entry point for execution.
  - `System.out.println()` or `System.out.print()`: For outputting messages to the console.
- **Class Definition**: Defines a blueprint; starts with `class`, followed by class name (e.g., `class FirstProgram {}`), no spaces in name.
- **Main Method**: Mandatory for execution; without it, the program can compile but not run. JVM searches for `main` method to start executing logic.
- **System.out.print**: Prints output; without it, no visible results even if the program runs.

### Steps to Develop, Compile, and Execute a Java Program
- **Seven Steps to Full Development Process**:
  1. Create project directory structure (e.g., `D:\FSJD\01_CJ\01_JB`).
  2. Open editor (Notepad).
  3. Type Java code.
  4. Save file with `.java` extension (same as class name).
  5. Open command prompt.
  6. Change directory to project folder (`cd D:\FSJD\01_CJ\01_JB`).
  7. Compile using `javac ClassName.java`.
- **Alternative Grouping**:
  - **Development (3 steps)**: Open Notepad, type code, save file.
  - **Compilation (3 steps)**: Open command prompt, change directory (`cd`), compile (`javac`).
- **Execution (1 step)**: Run with `java ClassName` (no `.class` extension).
- **File Naming**: Java file name should ideally match class name for clarity (e.g., save `FirstProgram.java`).

### Print Statements in Java
- Java has three print statements:
  - `System.out.print()`: Prints text without moving to a new line.
  - `System.out.println()`: Prints text and moves to a new line.
  - `System.out.printf()`: Prints formatted text (for structured output).

**Comparison Table of Print Statements:**

| Statement | Function | New Line After Print? | Example Usage |
|-----------|----------|----------------------|---------------|
| `print()` | Prints text without line break | No | `System.out.print("Hello"); System.out.print(" World");` → Output: "Hello World" |
| `println()` | Prints text with line break | Yes | `System.out.println("Hello");` → Output: "Hello" followed by newline |
| `printf()` | Formats and prints text | No (unless formatted) | `System.out.printf("Value: %d", 10);` → Output: "Value: 10" |

### Java Development Workflow
- **Bytecode and JVM Role**:
  - **Compiler (`javac`)**: Reads source code, converts it to bytecode (instruction set for JVM), saves in `.class` file.
  - **JVM (`java`)**: Executes bytecode; reads `.class` file, starts from `main` method, interprets instructions character-by-character.
  - Bytecode (`.class` file) acts as an "instruction set" for JVM; JVM understands only bytecode.
  - Example: `javac Example.java` generates `Example.class`; `java Example` runs the program.
- **Testing Programs**: Developers must test programs by comparing output to requirements (e.g., client-specified patterns).
- **Professional Mindset**: Emphasizes thinking like a software engineer (independent problem-solving) rather than a student (asking for help at every step). Use notes for manual practice before systems.

### Sample Programs and Labs
#### Program 1: Display "Hello World Programming World" (Revision Example)
- **Objective**: Basic program setup and execution.
- **Steps to Develop**:
  1. Open Notepad.
  2. Type the following code:
     ```java
     class FirstProgram {
         public static void main(String[] args) {
             System.out.println("HK Programming World");
         }
     }
     ```
  3. Save as `FirstProgram.java` in the project directory (e.g., `D:\FSJD\01_CJ\01_JB\FirstProgram.java`).
- **Compilation**:
  1. Open command prompt.
  2. Navigate to directory: `cd D:\FSJD\01_CJ\01_JB`.
  3. Run: `javac FirstProgram.java`.
  4. Expected output: `FirstProgram.class` file generated (bytecode).
- **Execution**:
  1. In the same directory, run: `java FirstProgram`.
  2. Expected output: `HK Programming World`.
- **Lab Notes**: `main` method is required for execution (compile works without it). Without `System.out.println`, no output appears even if code runs.

#### Program 2: Display Your Name (e.g., "Har Krishna")
- **Objective**: Print user name, emphasizing class naming (noun-based, title case, no spaces).
- **Steps to Develop**:
  1. Open Notepad.
  2. Type the following code:
     ```java
     class NamePrinter {
         public static void main(String[] args) {
             System.out.println("Har Krishna");
         }
     }
     ```
  3. Save as `NamePrinter.java` in the project directory.
- **Compilation**:
  1. Navigate via command prompt: `cd D:\FSJD\01_CJ\01_JB`.
  2. Run: `javac NamePrinter.java`.
  3. Expected output: `NamePrinter.class` file generated.
- **Execution**:
  1. Run: `java NamePrinter`.
  2. Expected output: `Har Krishna`.
- **Lab Notes**: Class name reflects operation (`NamePrinter`). Java file name can differ from class name, but consistency is best. Program syntax same as previous; only message changes—treat as "one program, multiple test cases."

#### Program 3: Display Name in Star Pattern
- **Objective**: Print name surrounded by stars, teaching multiple lines and space handling.
- **Steps to Develop**:
  1. Open Notepad.
  2. Type the following code:
     ```java
     class NamePrinterWithStars {
         public static void main(String[] args) {
             System.out.println("*   Har Krishna   *");
             System.out.println("****             ****");
             System.out.println("*                  *");
             System.out.println("**    Har Krishna  **");
         }
     }
     ```
  3. Save as `NamePrinterWithStars.java` in the project directory.
- **Compilation**:
  1. Navigate via command prompt: `cd D:\FSJD\01_CJ\01_JB`.
  2. Run: `javac NamePrinterWithStars.java`.
  3. Expected output: `NamePrinterWithStars.class` file generated.
- **Execution**:
  1. Run: `java NamePrinterWithStars`.
  2. Expected output:
     ```
     *   Har Krishna   *
     ****             ****
     *                  *
     **    Har Krishna  **
     ```
- **Lab Notes**: Use multiple `System.out.println()` for multiple lines. Manually count spaces for alignment. Test output against requirements; adjust spaces if needed (e.g., add extra spaces for centering).

#### Program 4: Display Name in Two Lines Using Escape Sequences
- **Objective**: Use `\n` for newlines in a single print statement.
- **Steps to Develop**:
  1. Open Notepad.
  2. Type the following code:
     ```java
     class NameInTwoLines {
         public static void main(String[] args) {
             System.out.println("Har\nKrishna");
         }
     }
     ```
  3. Save as `NameInTwoLines.java` in the project directory.
- **Compilation**:
  1. Navigate via command prompt: `cd D:\FSJD\01_CJ\01_JB`.
  2. Run: `javac NameInTwoLines.java`.
  3. Expected output: `NameInTwoLines.class` file generated.
- **Execution**:
  1. Run: `java NameInTwoLines`.
  2. Expected output:
     ```
     Har
     Krishna
     ```
- **Lab Notes**: `\n` inserts a newline within text. Only one `System.out.println()` needed for two-line output.

#### Program 5: Display Name in Stepped Pattern Using Tabs
- **Objective**: Use `\t` for tab spaces to create stepped output.
- **Steps to Develop**:
  1. Open Notepad.
  2. Type the following code:
     ```java
     class NamePattern {
         public static void main(String[] args) {
             System.out.println("H");
             System.out.println("\tA");
             System.out.println("\t\tR");
             System.out.println("\t\t\tI");
         }
     }
     ```
  3. Save as `NamePattern.java` in the project directory.
- **Compilation**:
  1. Navigate via command prompt: `cd D:\FSJD\01_CJ\01_JB`.
  2. Run: `javac NamePattern.java`.
  3. Expected output: `NamePattern.class` file generated.
- **Execution**:
  1. Run: `java NamePattern`.
  2. Expected output:
     ```
     H
     	A
     		R
     			I
     ```
- **Lab Notes**: `\t` inserts tab space (8 spaces); multiple `\t` create cumulative indentation. Contrast with space keys for precise alignment.

## Summary
### Key Takeaways
- ✅ Java programs require three essential statements: `class`, `public static void main(String[] args)`, and `System.out.println()`.
- ✅ Compilation converts source code to bytecode; execution runs bytecode via JVM, starting from `main` method.
- ✅ Follow 7-step workflow: Create directory → Write code → Save → Compile → Execute.
- ✅ Use noun-based class names (e.g., `NamePrinter`) without spaces.
- ✅ Multiple `System.out.println()` statements create multi-line output.
- ❌ Avoid vague names or spaces in class/file names.
- ⚠ When using escape sequences (\n for newline, \t for tab), enclose text in double quotes.
- 💡 Adopt a software engineer mindset: Practice manually, test programs against requirements, solve problems independently.
- 📝 Escape sequence characters: `\n` (newline), `\t` (tab space)—part of 17 total escape sequences (8 character-based, 8 number-based).

### Expert Insight
**Real-World Application**: In enterprise Java development (e.g., banking apps), you build complex systems using these fundamentals. Compile and test workflows ensure production code works reliably; escape sequences format logs or user interfaces for better readability.

**Expert Path**: Master manual coding before tools—write bytecode mentally for interviews. Focus on JUnit for unit testing (beyond manual checks). Next: Explore 17 escape sequences, then advance to variables and data types.

**Common Pitfalls**:
- Missing `main` method leads to runtime errors ("Main method not found").
- Incorrect spaces in paths (e.g., `Program Files`) crash command prompt; rename subdirectories.
- Over-reliance on IDEs skips workflow understanding—practice command-line first.
- Untested programs fail user acceptance; always simulate client outputs.
- Confusing `\s` (single space) with UI spaces—use `\t` for gaps.
- Lesser-Known Details: Bytecode (`cls` files) enables Java's portability; JVM optimizes execution. Practice 10+ simple programs weekly to build intuition, mirroring real project evolution.
