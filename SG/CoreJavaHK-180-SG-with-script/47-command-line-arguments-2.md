# Session 47: Command Line Arguments 2

## Table of Contents
- [Reading All Values with For Loop](#reading-all-values-with-for-loop)
- [Special Characters in Command Prompt](#special-characters-in-command-prompt)
- [Test Cases for Different Loop Conditions](#test-cases-for-different-loop-conditions)
- [Developing a Program to Display Only Integers](#developing-a-program-to-display-only-integers)
- [Meta Characters and Their Meanings](#meta-characters-and-their-meanings)
- [Problems with Command Line Arguments](#problems-with-command-line-arguments)

## Reading All Values with For Loop

### Overview
This session builds on reading runtime values from the command line. The instructor demonstrates how to read multiple values passed as arguments using a for loop, distinguishing it from reading individual values. Key focus is on iterating through all array elements and handling cases where no values are provided.

### Key Concepts/Deep Dive
Command line arguments are stored in the `args` array of type String[]. To read all values, use a for loop to iterate from index 0 to `args.length - 1`. The array is zero-indexed, so the first value is `args[0]`.

If no values are passed, `args.length` is 0, leading to no output. To provide user feedback, check if `args.length == 0` and display a message.

All values are passed as strings, so no type conversion occurs unless explicitly handled.

### Code/Config Blocks
Basic program to read and display all values:

```java
public class ReadAllValues {
    public static void main(String[] args) {
        if (args.length == 0) {
            System.out.println("Please pass some values");
        } else {
            for (int i = 0; i < args.length; i++) {
                System.out.println((i + 1) + " value: " + args[i]);
            }
        }
    }
}
```

Compile and run example:
- Compile: `javac ReadAllValues.java`
- Run with values: `java ReadAllValues 10 ABC 30.5`

Output:
```
1 value: 10
2 value: ABC
3 value: 30.5
```

### Lab Demos
1. Execute the program without arguments: No values are passed, displays "Please pass some values".
2. Execute with one value (e.g., `java ReadAllValues 10`): Displays only the one value.
3. Execute with multiple values (e.g., `java ReadAllValues 10 20 30 40`): Displays all values with index.

Each step requires recompilation after code changes.

## Special Characters in Command Prompt

### Overview
The command prompt treats certain characters as special "meta characters" with specific meanings. These include `&` for combining commands, `*` for file patterns, `<` and `>` for redirection, and quotes for grouping. Understanding these helps in passing arguments correctly.

### Key Concepts/Deep Dive
Special characters in the command prompt affect how arguments are interpreted:
- `&`: Allows chaining multiple commands (e.g., `java ReadAllValues 10 20 & java Addition 30 40` runs both).
- `*`: Wildcard for files (e.g., `java ReadAllValues *` passes all files in current directory as arguments).
- `<`: Input redirection (assigns file content as input).
- `>`: Output redirection (redirects console output to a file).

Quoting (e.g., "text with spaces") groups arguments containing spaces.

### Code/Config Blocks
No specific code, but command examples:
- Chain commands: `java ReadAllValues 10 20 & java Addition 30 40`
- Pass wildcard: `java ReadAllValues *`
- Redirect output: `java ReadAllValues > output.txt`

### Lab Demos
1. Run chained commands: `java ReadAllValues 10 20 & notepad output.txt` – Executes program and opens file.
2. Use wildcard: `java ReadAllValues *.java` – Passes all .java files as arguments.
3. Redirect output: `java ReadAllValues 10 20 > results.txt` – Saves output to file instead of console.

## Test Cases for Different Loop Conditions

### Overview
The session explores variations in for loop conditions when iterating `args`. Different conditions lead to different outputs, including exceptions or truncated results.

### Key Concepts/Deep Dive
Using incorrect loop bounds can cause issues:
- `for (int i = 0; i <= args.length; i++)`: Attempts to access `args[args.length]`, throws `ArrayIndexOutOfBoundsException`.
- `for (int i = 0; i < args.length - 1; i++)`: Skips the last element (e.g., with input `10 20 30`, outputs only `10 20`).
- Proper condition: `for (int i = 0; i < args.length; i++)`: Reads all elements safely.

### Code/Config Blocks
Tricky example (throws exception):

```java
for (int i = 0; i < args.length; i++) {
    System.out.println(args[i]);
}
```

With condition `i <= args.length` in test case: Results in all valid outputs followed by exception.

### Tables
| Condition | Input (`10 20 30`) | Output |
|-----------|---------------------|--------|
| `i < args.length` | 10 20 30 | 10, 20, 30 (all) |
| `i <= args.length` | 10 20 30 | 10, 20, 30 + Exception |
| `i < args.length - 1` | 10 20 30 | 10, 20 (skips last) |

## Developing a Program to Display Only Integers

### Overview
Task: Read multiple arguments, filter and display only those that are integers. Uses exception handling to determine if a value is an integer without manual checks.

### Key Concepts/Deep Dive
To check if `args[i]` is an integer:
- Use `Long.parseLong(args[i])` in a try-catch.
- If `NumberFormatException` is thrown, it's not an integer; skip.
- If no exception, display as integer.

Handles positive/negative large numbers via `long`.

Displays position and value (e.g., "1 value 10 is integer").

### Code/Config Blocks
Program implementation:

```java
public class DisplayIntegers {
    public static void main(String[] args) {
        if (args.length == 0) {
            System.out.println("Please pass some values");
        } else {
            for (int i = 0; i < args.length; i++) {
                try {
                    Long.parseLong(args[i]);
                    System.out.println((i + 1) + " value " + args[i] + " is integer");
                } catch (NumberFormatException e) {
                    // Skip non-integers
                }
            }
        }
    }
}
```

Run: `java DisplayIntegers 10 ABC 20 true B 4 10.5 30.0`

Output shows positions of integers: 10, 20, 4.

### Lab Demos
1. Compile: `javac DisplayIntegers.java`
2. Run with mixed values: As above, only integers displayed.
3. Test exception handling: Pass non-numeric; catch silently skips.

## Meta Characters and Their Meanings

### Overview
Recap of meta characters in command prompt, their purposes, and how to neutralize special meanings.

### Key Concepts/Deep Dive
List of meta characters:
- `*`: All files (e.g., `*` → current directory files, `/*.java` → root Java files).
- `\` with `*`: Specific patterns or paths.
- R: Second command execution.
- `&`: Both commands.
- `<`, `>`: Redirection (input/output).
- Quotes: Group arguments or neutralize specials (e.g., `"&"` passes `&` as literal).

Formula for quotes: (number of quotes - 1) / 2 determines literal quotes output.

Neutralize by quoting (e.g., `"*"` → literal `*`).

### Tables
| Character | Meaning | Neutralize |
|-----------|---------|------------|
| `*` | All files | `"*"` |
| `&` | Chain commands | `"&"` |
| R | Second command | `"R"` |
| `<` | Input redirect | `"<"` |
| `>` | Output redirect | `">"` |

## Problems with Command Line Arguments

### Overview
Command line arguments have limitations: all as strings, no dynamic input during runtime, issues with buffers. Leads to buffer reader, scanner alternatives.

### Key Concepts/Deep Dive
Common issues:
- Static nature: Values fixed at startup.
- Type conversion required manually.
- Buffer related: Input handling via System.in needed for real-time input.

Alternatives: BufferedReader, Scanner for better input handling.

### Tables
| Issue | Symptom | Alternative |
|-------|---------|-------------|
| Static values | Can't read new input | Use Scanner |
| Type handling | Manual conversion | Wrapper classes |
| Multi-line input | Space-separated only | Cap lock or buffer |

### Lab Demos
No specific demo; refers to previous video. Examples: Compared to buffer reader for flexible input.

## Summary

> [!IMPORTANT]
> Command line arguments are essential for passing startup parameters to Java programs, stored in `String[] args` with zero-based indexing.

### Key Takeaways
```diff
+ Use for loops with `i < args.length` to safely iterate all arguments
+ Check `args.length == 0` to prompt for input when no values are passed
+ Meta characters like `&`, `*`, `<`, `>` have special meanings in command prompts; neutralize with quotes
+ Exception handling (e.g., with `Long.parseLong`) effectively identifies integers without manual checks
+ Test loop variations to avoid ArrayIndexOutOfBoundsException
- Avoid hardcoded array access like `args[0]` without length checks for dynamic inputs
- Over-reliance on command line can limit interactive programs; consider Scanner for real-time input
! Special characters without quotes can redirect output or chain commands unexpectedly
! Incorrect loop bounds (e.g., `i <= args.length`) risk exceptions
```

### Expert Insight

#### Real-world Application
In production, command line arguments configure applications (e.g., server ports like `--port 8080`) or process files in batch scripts. Tools like Docker use args for environmental settings, allowing scripts to deploy with varying parameters without code changes.

#### Expert Path
Master by practicing parsing complex args (e.g., flags with `-c config.json`) and combining with libraries like Apache Commons CLI for validation. Study Linux command prompts for advanced patterns.

#### Common Pitfalls
- Mistaking string args for typed values; always parse (e.g., `Integer.parseInt(args[0])`) with try-catch to handle invalid inputs.
- Ignoring meta characters; quote paths/files containing specials (e.g., `"C:\Program Files\file.txt"`).
- Performance issues with large arg lists; for heavy tasks, switch to file-based or interactive input. No bulk harvesting risks here, but ethical parsing avoids exposing sensitive paths.

#### Lesser Known Things
JVM optimizes `args` array early, making it thread-safe but immutable. Double quotes parsing follows regex-like rules internally; experimenting with odd/even quotes reveals quote handling nuances. In ethical hacking demos, command lines reveal system structures via wildcards, but always document defensively for security reviews.
