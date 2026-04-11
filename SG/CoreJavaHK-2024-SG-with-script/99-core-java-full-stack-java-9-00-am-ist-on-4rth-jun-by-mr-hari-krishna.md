# Session 99: String Operations in Core Java

## Table of Contents
- [String Immutability](#user-content-string-immutability)
- [Types of Immutable Objects](#user-content-types-of-immutable-objects)
- [String Operations Overview](#user-content-string-operations-overview)
- [Detailed String Methods](#user-content-detailed-string-methods)
- [String Comparisons](#user-content-string-comparisons)
- [Advanced String Comparisons](#user-content-advanced-string-comparisons)
- [Text Blocks and Enhancements](#user-content-text-blocks-and-enhancements)
- [Lab Demos and Exercises](#user-content-lab-demos-and-exercises)
- [Summary](#user-content-summary)

## String Immutability

### Overview
Strings in Java are immutable objects, meaning their content cannot be changed after creation. When modifications are performed, new string objects are created instead of modifying the original. This design choice enhances security, thread-safety, and performance by allowing string literals to be cached and reused (string pooling). The session recaps previous discussion on string literals, objects, and creation methods.

### Key Concepts/Deep Dive
- **Immutability Benefits**: Prevents accidental modifications, enables string pooling for memory efficiency, and ensures thread-safety without synchronization.
- **String Pooling**: Literal strings (e.g., `"Hurry"`) are stored in a shared pool. If the same literal is used again, the same reference is returned, saving memory.
- **vs. Mutability**: Contrast with mutable classes like StringBuffer and StringBuilder, which allow in-place modifications.
- **Assignment Question**: Why is String designed as immutable? Reasons include security (no tampering with strings like passwords), caching performance, and simplification of concurrent programming.
- **Internal Storage**: Strings store characters in a char array (older versions) or byte array (newer versions for efficiency), but data is never modified directly.

**Code/Example Block**:
```java
String s1 = "Hurry";  // Immutable literal
String s2 = new String("Hurry");  // Immutable new object
// s1.concat("!") creates a new string, s1 remains unchanged
String s3 = s1.concat(" Java");  // s1 is still "Hurry", s3 is "Hurry Java"
```

> [!NOTE]
> Immutability ensures strings can be safely shared across threads without locks.

## Types of Immutable Objects

### Overview
Java has two types of immutable objects: those that don't accept modifications (e.g., Integer) and those that accept changes but return results in new objects (e.g., String).

### Key Concepts/Deep Dive
| Aspect | Immutable (No Modification) | Immutable (New Object) | Example |
|--------|-----------------------------|--------------------------|---------|
| Modification Acceptance | Does not accept changes | Accepts changes but stores result in new object | Integer class doesn't have methods to change value; String has concat but returns new string |
| Memory Behavior | Reuses pool if possible | Always new object for changes | Wrapper classes like Integer; method-based operations like concat |
| Use Case | Read-only data that never changes | Read-write like data with transformations | Password verification; String manipulations |

- **Wrapper Classes**: Classes like Integer, Double have no setter methods, only getters. Data is final.
- **String Example**: Methods like concat, replace create new strings; original remains unchanged.
- **JDBC Objects**: JDBC interfaces (Connection, Statement, PreparedStatement, etc.) are not immutable; they maintain state and allow modifications. They are mutable as they hold data (e.g., connection strings, query parameters) that can be updated.

**Code/Example Block**:
```java
Integer i1 = 15;  // Immutable - no way to change to 20
String s1 = "AB";
String s2 = s1.concat("CD");  // s1 still "AB", s2 is "ABCD"
// Integer wrapper: all methods return new values
```

🔧 **Expert Insight**: JDBC objects like PreparedStatement allow setting parameters multiple times, making them mutable. This contrasts with Strings, enabling dynamic query building.

## String Operations Overview

### Overview
Strings support 30+ operations, categorized into finding/checking, comparing, retrieving, modifying, and converting. These operations handle string manipulation efficiently without mutating the original object.

### Key Concepts/Deep Dive
Operations include:
1. **Finding Operations**:
   - Empty/blank status
   - Length
   - Printing (implicit toString)

2. **Comparing Operations**:
   - Equality with/without case
   - Lexicographical (alphabetical order)
   - Reference-based (==)

3. **Checking Operations**:
   - Start/end with substrings

4. **Retrieving Operations**:
   - Characters/substrings/subsequences
   - Splitting strings

5. **Modifying Operations** (result in new objects):
   - Concatenation/joining
   - Case changing
   - Replacing
   - Trimming spaces

6. **Converting Operations**:
   - To char arrays, byte arrays

- **Return Types**: Most modifying methods return String; checking/comparing return boolean/int.
- **Version Availability**: Methods like isBlank from Java 11; older projects use length() and trim() for blank checks.

> [!IMPORTANT]
> Always use isEmpty() or isBlank() instead of length() == 0 for readability and performance.

## Detailed String Methods

### Overview
Focus on critical methods for finding, comparing, and retrieving. These build the foundation for string handling in applications.

### Key Concepts/Deep Dive
- **isEmpty()**: public boolean isEmpty(). Returns true if no characters. Available from Java 6.
- **isBlank()**: public boolean isBlank(). Returns true if empty or only spaces. Available from Java 11.
- **length()**: public int length(). Returns character count via value.length (internal array).
- **toString()**: Implicit method for printing; overridden in String class.
- **equals(Object)**: Compares content with case sensitivity.
- **equalsIgnoreCase(String)**: Compares content ignoring case.
- **startsWith(String)** / **endsWith(String)**: Check prefixes/suffixes.
- **charAt(int)**: Retrieve single character.
- **substring(int start)** / **subsequence(int start, int end)**: Retrieve parts (substring more common).
- **split(String regex)**: Split into arrays of words/substrings.
- **concat(String)**: Append string; returns new string.
- **join(CharSequence delimiter, String...)**: Join multiple strings with delimiter.
- **toUpperCase()** / **toLowerCase()**: Change case.
- **replace(CharSequence target, CharSequence)**: Replace characters/strings.
- **trim()**: Remove leading/trailing spaces.
- **getBytes()** / **toCharArray()**: Convert to arrays.
- **contentEquals(CharSequence)**: Compare with StringBuffer/StringBuilder.
- **compareTo(String)**: Lexicographical comparison with case.
- **compareToIgnoreCase(String)**: Lexicographical without case.

**Code/Example Block**:
```java
String s1 = "";         // Empty
String s2 = " ";        // Blank space
System.out.println(s1.isEmpty());       // true
System.out.println(s2.isBlank());       // true
System.out.println("Hurry".length());   // 5
System.out.println("Java".equals("java"));    // false
System.out.println("Java".equalsIgnoreCase("java"));  // true
System.out.println("Hello".startsWith("He")); // true
System.out.println("Hurry".substring(1, 4)); // "urr"
```

| Method | Return Type | Purpose | Example |
|--------|-------------|---------|---------|
| isEmpty() | boolean | Check zero characters | `"".isEmpty()` → true |
| isBlank() | boolean | Check zero or whitespace | `" ".isBlank()` → true |
| length() | int | Count characters | `"Hello".length()` → 5 |
| concat(String) | String | Append strings | `"Hi".concat("!")` → "Hi!" |

💡 **Expert Insight**: For blank checks in projects before Java 11, simulate `isBlank()` with `trim().isEmpty()`.

## String Comparisons

### Overview
Comparisons determine equality or order, crucial for validation and sorting.

### Key Concepts/Deep Dive
- **== Operator**: Compares references, not content. Same for pooled literals (e.g., `"Hi" == "Hi"` is true).
- **equals(Object)**: Compares state (content) with case.
- **equalsIgnoreCase(String)**: Compares content ignoring case.
- **Lexographical Order**: Use compareTo() for sorting (returns int: negative if less, positive if greater).
- **Behavior**: == for objects, equals for data. Overrides needed for custom comparisons.

**Code/Example Block**:
```java
String s1 = "Hi";
String s2 = new String("Hi");
System.out.println(s1 == "Hi");          // true (pooling)
System.out.println(s1 == s2);            // false
System.out.println(s1.equals(s2));       // true
System.out.println("Hi".equalsIgnoreCase("HI"));  // true
System.out.println("Apple".compareTo("Banana"));  // Negative (A before B)
System.out.println("apple".compareToIgnoreCase("BANANA"));  // Negative
```

## Advanced String Comparisons

### Overview
Handling comparisons with mutable objects (StringBuffer/StringBuilder) requires specialized methods to ignore type differences.

### Key Concepts/Deep Dive
- **contentEquals(CharSequence)**: Compares String content with CharSequence (StringBuffer, StringBuilder, String).
- **Overloads**: One for StringBuffer, one for CharSequence.
- **Availability**: From Java 1.4 (limited), full in Java 1.5+.
- **Legacy Approach**: Before 1.4, convert buffer to string: `equals(buffer.toString())`.

**Code/Example Block**:
```java
String s = "Hyderabad";
StringBuffer sb = new StringBuffer("Hyderabad");
StringBuilder sbd = new StringBuilder("Hyderabad");
System.out.println(s.equals(sb));               // false (type mismatch)
System.out.println(s.contentEquals(sb));        // true
System.out.println(s.contentEquals(sbd));       // true
System.out.println(s.contentEquals("Hyderabad"));  // true
```

## Text Blocks and Enhancements

### Overview
Java 13+ introduced text blocks for multi-line strings, with additional methods for handling.

### Key Concepts/Deep Dive
- **Text Blocks**: Use """ for multi-line strings, preserving formatting.
- **Methods**: StripIndent(), translateEscapes(), etc., for advanced formatting.
- **Enhancements**: 25+ additional methods beyond base 24 for modern string handling.

**Code/Example Block** (Java 13+):
```java
String textBlock = """
    Hello
    World
    """;
System.out.println(textBlock.stripIndent());  // Normalized indent
```

## Lab Demos and Exercises

### 1. Program for isEmpty(), isBlank(), length()
**Steps**:
1. Declare strings: empty, single character, space, content.
2. Print results of isEmpty(), isBlank(), length().

**Code/Example Block**:
```java
String s1 = "";     // Empty
String s2 = " ";    // Blank (space)
String s3 = "A";    // Content
System.out.println("Empty: " + s1.isEmpty() + ", " + s1.isBlank());
System.out.println("Blank: " + s2.isEmpty() + ", " + s2.isBlank());
System.out.println("Length: " + s3.length());
```

### 2. Username Validation (Blank Check)
**Steps**:
1. Use Scanner to read username.
2. Check isBlank() or simulate with trim().isEmpty().
3. Print validation result.

**Code/Example Block**:
```java
import java.util.Scanner;
Scanner sc = new Scanner(System.in);
String username = sc.nextLine();  // next() for no spaces
if (username.isBlank()) {
    System.out.println("Enter username");
} else {
    System.out.println("Username: " + username);
}
```

### 3. Mobile Number Validation (Length)
**Steps**:
1. Read mobile number as String.
2. Check length() == 10.
3. Print validation.

**Code/Example Block**:
```java
String mobile = sc.nextLine();
if (mobile.length() == 10) {
    System.out.println("Valid mobile");
} else {
    System.out.println("Invalid length");
}
```

### 4. Password Validation (Length 8-16)
**Steps**:
1. Read password.
2. Check 8 <= length() <= 16.
3. Print result.

### 5. Login Screen (Username and Password)
**Steps**:
1. Read username and password via Scanner.
2. Use equalsIgnoreCase() for username, equals() for password (case-sensitive).
3. Print success/failure.

**Code/Example Block**:
```java
String username = sc.nextLine();
String password = sc.nextLine();
if (username.equalsIgnoreCase("hurry") && password.equals("nit@123")) {
    System.out.println("Login successful");
} else {
    System.out.println("Invalid credentials");
}
```

## Summary

### Key Takeaways
```diff
+ String immutability ensures thread-safety, caching, and security by preventing in-place changes.
+ Use isEmpty() for zero characters, isBlank() for zero or spaces.
+ Prefer equals() for content comparison, == for reference checks.
+ Lexographical sorting uses compareTo() methods.
+ contentEquals() bridges String with mutable types like StringBuffer.
- Avoid mutating Strings directly; opt for StringBuffer/StringBuilder for frequent changes.
! Remember: Immutability leads to new objects for every operation, impacting performance with heavy loops.
```

### Expert Insight
**Real-world Application**: In web apps like Amazon, isBlank() validates inputs (e.g., username fields) to prevent errors. Strings handle user data securely, with pooling optimizing memory in high-traffic sites.

**Expert Path**: Master String methods for interviews; progress to StringBuilder for mutable needs, understanding internal char/byte arrays for depth. Practice 10-15 sessions on regex with split() and replace().

**Common Pitfalls**: Confusing == with equals() leads to bugs in object comparisons. Using trim().length() == 0 instead of isBlank() misses middle spaces. Not handling null strings (use StringUtils or check first) causes NullPointerException.

**Lesser Known**: Strings use byte arrays internally since Java 9 for reduced footprint (avg. 2 bytes/car vs. 1 byte/byte). compareTo() uses Unicode order, not ASCII, affecting internationalization. Text blocks (Java 13+) auto-manage indentation for cleaner multi-line code.
