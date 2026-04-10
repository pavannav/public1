# Session 102: Full Stack JAVA

- [String Class Methods](#string-class-methods)
- [Trim vs Strip Methods](#trim-vs-strip-methods)
- [Text Blocks](#text-blocks)
- [New String Methods by Version](#new-string-methods-by-version)

## String Class Methods

### Overview
This session concludes the comprehensive coverage of Java String class methods, focusing on standard methods like trim and replace, and introduces new methods available from Java 11 onwards such as strip, stripLeading, and stripTrailing.

### Key Concepts/Deep Dive

**Basic Trim and Replace Functionality**:
- The `trim()` method removes only leading (beginning) and trailing (end) spaces from a string.
- For removing spaces in the middle, use `replace()` with space and empty string parameters.

```java
String s1 = "  ABC  BBC  CBC  ";  // Leading and trailing spaces, plus middle spaces
System.out.println("Length of S1: " + s1.length());  // 16 characters total

String s2 = s1.trim();
System.out.println("After trim - Length of S2: " + s2.length());  // Leading/trailing removed, length 11

String s3 = s1.replace(" ", "");
System.out.println("After replace - Length of S3: " + s3.length());  // All spaces removed, length 9
```

**New Strip Methods**:
- `strip()`, `stripLeading()`, `stripTrailing()` are available from Java 11.
- These methods are Java's adaptation of Python's `strip()` functionality.
- `strip()` removes all leading and trailing whitespace.
- `stripLeading()` removes only leading spaces.
- `stripTrailing()` removes only trailing spaces.

```java
String s1 = "  ABC  BBC  CBC  ";

String s2 = s1.strip();  // Remove leading and trailing whitespace
System.out.println(s2.length());  // Should be around 11-13 depending on spaces

String s3 = s1.stripLeading();  // Remove only leading spaces
System.out.println(s3.length());  // Original length minus leading spaces

String s4 = s1.stripTrailing();  // Remove only trailing spaces
System.out.println(s4.length());  // Original length minus trailing spaces
```

### Code/Config Blocks
All examples use Java syntax highlighting with proper escape sequences where needed.

### Tables

| Method | Description | Available From |
|--------|-------------|---------------|
| `trim()` | Removes leading and trailing spaces | Java 1.0 |
| `strip()` | Removes all leading and trailing whitespace | Java 11 |
| `stripLeading()` | Removes only leading whitespace | Java 11 |
| `stripTrailing()` | Removes only trailing whitespace | Java 11 |

## Trim vs Strip Methods

### Overview
While `trim()` and `strip()` appear similar, there are critical differences in behavior, particularly regarding whitespace handling and empty characters.

### Key Concepts/Deep Dive

**Primary Differences**:
- `strip()` methods determine whitespace using `Character.isWhitespace()`, which may not remove certain Unicode characters.
- `trim()` removes all ASCII control characters (0-31), including empty characters or null characters (ASCII 0).

```java
String s1 = "\0  ABC  BBC  CBC  \0";  // Contains empty character (\0)

String s2 = s1.trim();  // Removes empty characters too
System.out.println("Length after trim: " + s2.length());

String s3 = s1.strip();  // Does NOT remove empty characters
System.out.println("Length after strip: " + s3.length());
```

In the above example, `trim()` removes the empty characters while `strip()` does not. `Character.isWhitespace()` considers fewer characters as whitespace compared to `trim()`.

**Version Support**:
- Both methods available from Java 11.
- Strip methods introduced to align Java with Python's string handling preferences.

## Text Blocks

### Overview
Text blocks were introduced to solve the readability and maintainability issues with multi-line strings in Java, replacing the need for extensive concatenation and escape sequences.

### Key Concepts/Deep Dive

**Before Text Blocks (Java 13 and earlier)**:
Traditional approach required tedious concatenation with escaped newlines and quotes.

```java
String html = "<html>\n" +
              "<body>\n" +
              "<h1>Welcome to Programming</h1>\n" +
              "<p>Enjoy learning programming.</p>\n" +
              "</body>\n" +
              "</html>";

String sql = "SELECT ename, esalary, edept " +
             "FROM employee " +
             "WHERE eempno = 1 " +
             "AND ename = 'hari'";
```

**Text Blocks (Java 15+)**:
Use triple quotes (`"""`) for readable multi-line strings. No extra escape sequences needed for most cases.

```java
String html = """
              <html>
              <body>
              <h1>Welcome to Programming</h1>
              <p>Enjoy learning programming.</p>
              </body>
              </html>
              """;

String sql = """
             SELECT ename, esalary, edept
             FROM employee
             WHERE eempno = 1
             AND ename = 'hari'
             """;
```

**Key Rules**:
- Syntax: Start and end with `"""` (triple quotes).
- Compiler automatically handles line terminators.
- Leading whitespace is preserved as written.
- Can include single/double quotes without escaping.
- Cannot nest triple quotes within text blocks.
- Must span multiple lines (use line terminator, not `\n`).

**Version History**:
- **Java 12**: Introduced as "Raw Strings" (JEP 326), but withdrawn.
- **Java 13**: First preview as Text Blocks (JEP 355).
- **Java 14**: Second preview with new escape sequences.
- **Java 15**: Permanent feature (no preview flag needed).

**Best Practices**:
- Use text blocks for SQL queries, HTML content, JSON/XML templates.
- Specify column names explicitly in queries instead of using `*`.
- Avoid text blocks in single-line scenarios.

### Code/Config Blocks
Examples above demonstrate syntax highlighting for Java strings.

### Lab Demos

**Text Block Example**:
1. Create a string variable using triple quotes.
2. Include multiple lines with proper indentation.
3. Print the string to verify content.
4. Note how line breaks are automatically handled.

```java
String demo = """
              Line 1
              Line 2
                Indented Line 3
              Final Line
              """;
System.out.println(demo);
```

Expected output preserves all indentation and multiple lines as written.

**Query Formatting Demo**:
1. Write an SQL query in text block format with proper line breaks.
2. Specify column names instead of using wildcards.
3. Include WHERE conditions for multiple columns.

```java
String query = """
               SELECT empno, ename, esalary, edept
               FROM employee
               WHERE empno = ?
               AND ename = ?
               """;
```

## New String Methods by Version

### Overview
Java updates have introduced various new methods to the String class across versions, enhancing functionality for character processing, text manipulation, and modern programming needs.

### Key Concepts/Deep Dive

**Java 9: `chars()` method**
- Returns an `IntStream` of Unicode code points.
- Useful for character-by-character processing.

```java
String s = "ABC";
s.chars().forEach(ch -> System.out.println((char)ch));  // Prints A, B, C
```

**Java 11: Key methods**
- `lines()`: Returns `Stream<String>` for processing multi-line text.
- `isBlank()`, `strip()`, `stripLeading()`, `stripTrailing()`: Whitespace handling.
- `repeat(int count)`: Repeats string specified number of times.

```java
String multiline = "Java\nProgramming\nLanguage";
multiline.lines().forEach(System.out::println);  // Prints each line

String repeat = "ABC".repeat(3);  // "ABCABCABC"
```

**Java 12: Additional methods**
- `indent(int n)`: Adds specified indentation to each line.
- `describeConstable()`, `resolveConstantDesc()`: For advanced use cases.

```java
String text = "Java\nProgramming";
String indented = text.indent(4);  // Adds 4 spaces to each line
```

**Java 15: `formatted()` method**
- Alternative to `String.format()` for string interpolation.

```java
String result = "Hello, %s!".formatted("World");
```

**Java 21: `splitWithDelimiters()`**
- Similar to `split()` but includes delimiters in result tokens.

### Tables

| Java Version | New Methods |
|--------------|-------------|
| Java 9 | `chars()` |
| Java 11 | `lines()`, `isBlank()`, `strip()`, `stripLeading()`, `stripTrailing()`, `repeat()` |
| Java 12 | `indent()`, `describeConstable()`, `resolveConstantDesc()` |
| Java 15 | `formatted()` |
| Java 21 | `splitWithDelimiters()` |

## Summary

### Key Takeaways
```diff
+ String trim() vs strip() - strip() follows Character.isWhitespace(), trim() removes more characters including empty chars
+ Text blocks use """ syntax for readable multi-line strings, available from Java 15
+ New methods like lines(), chars(), repeat() available from Java 11
+ Always specify column names in queries, never use SELECT *
+ Strip methods are Java's version of Python's strip functionality
- Avoid using SELECT * in production queries for maintainability
- Text blocks cannot be nested within each other
! Text blocks require line terminators (actual newlines), not escape sequences
```

### Expert Insight

#### Real-world Application
Text blocks revolutionized Java string handling by making embedded SQL, HTML, and JSON much more maintainable. In enterprise applications, they're extensively used for:
- Complex SQL query building with proper formatting
- HTML template generation in web applications  
- JSON/XML data structure creation
- Multi-line logging messages and configuration files

#### Expert Path
To master string handling:
1. Study all JDK 11+ String methods in the official documentation
2. Practice text blocks with real SQL queries and HTML generation
3. Understand character encoding differences between trim() and strip()
4. Learn regex patterns for advanced string manipulation
5. Explore performance implications of different string operations

#### Common Pitfalls
- **Version Compatibility**: Ensure your Java version supports desired methods (text blocks require Java 15+)
- **Empty Character Handling**: strip() won't remove `\0` characters like trim() does
- **Query Security**: Always use parameterized queries, never embed strings directly in text block queries
- **Performance**: For large strings, consider StringBuilder over repeated string operations

#### Common Issues with Resolution
- **Text Block Not Recognized**: Update to Java 15+ and remove any preview flags
- **Compilation Errors**: Ensure triple quotes span actual multiple lines (not just escaped newlines)
- **Database Dependencies**: Column order changes might break applications using SELECT *

#### Lesser Known Things
- Text blocks automatically handle platform-specific line terminators
- The `indent()` method can accept negative values to reduce indentation
- `lines()` preserves empty lines between content lines
- Strip methods handle Unicode whitespace categories more comprehensively than trim() in some cases
- `chars()` returns int stream for Unicode safety (handles supplementary characters)

Mistakes found and corrections made:
- "ript" at start - appeared to be incomplete, removed or disregarded
- "s_ub_2" -> "s2"
- "stripper" -> "strip" 
- "do.length" -> "length()"
- "Arduino" -> "leading"
- "string trip" -> "string trim"
- Various filler words (uh, okay) removed for clarity
- Code snippets reconstructed from verbal descriptions with proper syntax
- Version history clarified for text blocks (permanent in Java 15, not Java 17)

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
