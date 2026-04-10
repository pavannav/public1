# Session 05: String Handling Methods

## Table of Contents
- [Revisiting String Methods](#revisiting-string-methods)
- [String Comparison Methods](#string-comparison-methods)
- [String Searching Methods](#string-searching-methods)
- [String Retrieving Methods](#string-retrieving-methods)
- [String Conversion Methods](#string-conversion-methods)
- [Practical Scenarios and Practice Exercises](#practical-scenarios-and-practice-exercises)

## Revisiting String Methods

### Overview
This section revisits core string methods covered in previous sessions, including emptiness checks, length retrieval, object representation, and basic equality comparisons. These methods form the foundation for string manipulation in Java, enabling developers to inspect and analyze string objects effectively. Understanding these methods is crucial for handling string data in applications, as they allow conditional logic based on string content and structure.

### Key Concepts/Deep Dive

#### Emptiness Checks
- **isEmpty()**: Returns `true` if the string length is 0 (i.e., an empty string like `""`). Returns `false` for strings with any characters.
- **isBlank()**: Returns `true` if the string is empty or contains only whitespace characters. Performs the same operation as checking `isEmpty() || trim().isEmpty()`.
- Note: Both methods accept no parameters and have return type `boolean`.

#### Length Retrieval
- **length()**: Returns the number of characters in the string object. This is a method (not a property like arrays), starting from 1 for non-empty strings.
- **Rule**: Always call `length()` for strings; arrays use the `length` property.

#### Object Representation
- **toString()**: Overrides the inherited method from `Object` class to print the string object content instead of class name and hash code. All strings return their actual content when called.

#### Equality Comparison
- **Double equals operator (`==`)**: Compares string objects by reference, not content. Returns `true` only if both objects point to the same memory location.
- **equals()**: Compares string objects by content. Overrides the `Object` class method. Returns `true` if character sequences match.
- **equalsIgnoreCase()**: Compares string objects by content, ignoring case differences (e.g., "ABC" equals "abc").
- **contentEquals()**: Compares string with string buffer or string builder. Not typically used for string-to-string comparison; use `equals()` instead.

#### Code Examples
```java
String s1 = "Hello World";
String s2 = "";

System.out.println(s1.isEmpty());      // false
System.out.println(s2.isEmpty());      // true
System.out.println(s1.isBlank());      // false
System.out.println("   ".isBlank());  // true
System.out.println(s1.length());       // 11
System.out.println(s1.toString());     // Hello World

String s3 = "abc";
String s4 = "ABC";
System.out.println(s1 == s2);           // false (different objects)
System.out.println(s3.equals(s4));      // false (case sensitive)
System.out.println(s3.equalsIgnoreCase(s4)); // true
```

## String Comparison Methods

### Overview
String comparison methods allow determining the lexicographical (dictionary-order) relationship between strings, essential for sorting, ordering, and decision-making. These methods provide numeric differences rather than boolean results, enabling precise ordering logic in data structures and algorithms.

### Key Concepts/Deep Dive

#### compareTo()
- **Purpose**: Compares two strings lexicographically for equality, size, or ordering.
- **Return Values**:
  - 0: Strings are equal (same content).
  - Negative integer: First string is smaller (comes before in dictionary order).
  - Positive integer: First string is larger (comes after in dictionary order).
- **Mechanism**: Compares character by character using ASCII values (e.g., 'A' is 65, 'a' is 97).
- **Use Cases**: Sorting strings in arrays or collections (e.g., ascending alphabetical order).
- **Syntax**: Return type `int`, method name `compareTo(String)`, parameter `String`.

#### compareToIgnoreCase()
- **Purpose**: Similar to `compareTo()` but ignores case differences during comparison.
- **Return Values**: Same as `compareTo()` (0, negative, or positive int).
- **Mechanism**: Converts both strings to the same case before comparison.
- **Syntax**: Return type `int`, method name `compareToIgnoreCase(String)`, parameter `String`.

#### When to Use
- Use `compareTo()` for case-sensitive comparisons (e.g., sorting usernames).
- Use `compareToIgnoreCase()` for case-insensitive comparisons (e.g., sorting user inputs).
- Prefer `equals()` or `equalsIgnoreCase()` when checking equality only, as `compareTo()` methods may be less efficient for equality checks.

#### Code Examples
```java
String s1 = "ABC";
String s2 = "ABC";
String s3 = "BBC";
String s4 = "abc";

System.out.println(s1.compareTo(s2));         // 0 (equal)
System.out.println(s1.compareTo(s3));         // -1 (A < B)
System.out.println(s3.compareTo(s1));         // 1 (B > A)
System.out.println(s1.compareTo(s4));         // -32 (case sensitive)
System.out.println(s1.compareToIgnoreCase(s4)); // 0 (ignores case)
```

| Method | Parameter Type | Return Type | Case Sensitive | Purpose |
|--------|----------------|-------------|----------------|---------|
| compareTo | String | int | Yes | Lexicographical comparison |
| compareToIgnoreCase | String | int | No | Case-insensitive lexicographical comparison |

#### Common Pitfalls
- **Overloading Confusion**: `compareTo(int fromIndex)` or other overloads may exist, but the primary usage is `compareTo(String)`.
- **Character Encoding**: Comparisons rely on ASCII/Unicode values; ensure consistent encoding in multi-language apps.

## String Searching Methods

### Overview
String searching methods enable locating substrings within strings, either by presence alone or by retrieving specific positions. These methods are critical for text processing, file filtering, and dynamic content extraction in applications like data parsing and search functionalities.

### Key Concepts/Deep Dive

#### contains()
- **Purpose**: Checks if a substring exists anywhere in the string.
- **Return Values**: `boolean` - `true` if found, `false` otherwise.
- **Mechanism**: Searches the entire string for the given substring, considering case.
- **Syntax**: Return type `boolean`, method name `contains(String)`, parameter `String`.
- **No ignoreCase variant**: Convert both strings to lower/upper case for case-insensitive search.

#### startsWith()
- **Purpose**: Checks if the string starts with a specific substring.
- **Return Values**: `boolean` - `true` if matches, `false` otherwise.
- **Mechanism**: Verifies only the beginning of the string.
- **Syntax**: Return type `boolean`, method name `startsWith(String)`, parameter `String`.

#### endsWith()
- **Purpose**: Checks if the string ends with a specific substring.
- **Return Values**: `boolean` - `true` if matches, `false` otherwise.
- **Mechanism**: Verifies only the end of the string.
- **Syntax**: Return type `boolean`, method name `endsWith(String)`, parameter `String`.

#### indexOf()
- **Purpose**: Retrieves the first occurrence index of a character or substring.
- **Return Values**: `int` - 0-based index if found, -1 if not.
- **Mechanism**: Searches from start (index 0) or optional `fromIndex`.
- **Overloads**: Accepts `char` or `String`, optionally `fromIndex` for starting position.
- **Syntax**: Return type `int`, method name `indexOf(char/String [, int fromIndex])`.

#### lastIndexOf()
- **Purpose**: Retrieves the last occurrence index of a character or substring.
- **Return Values**: `int` - 0-based index if found, -1 if not.
- **Mechanism**: Searches from end to start, or optionally from `fromIndex` backwards.
- **Syntax**: Return type `int`, method name `lastIndexOf(char/String [, int fromIndex])`.

#### When to Use
- `contains()`, `startsWith()`, `endsWith()`: Binary checks for presence or positioning.
- `indexOf()` and `lastIndexOf()`: Retrieve exact positions for dynamic data extraction (e.g., parsing file names).

#### Code Examples
```java
String s1 = "Java Har Krishna";

System.out.println(s1.contains("Har"));       // true
System.out.println(s1.contains("har"));       // false
System.out.println(s1.startsWith("Java"));    // true
System.out.println(s1.endsWith("Krishna"));   // true
System.out.println(s1.indexOf("Krishna"));    // 8 (or actual position)
System.out.println(s1.lastIndexOf("a"));      // Last 'a' position
System.out.println(s1.indexOf("Har", 5));     // First "Har" from index 5

// Case-insensitive search using conversion
String search = "hurry";
System.out.println(s1.toLowerCase().contains(search.toLowerCase())); // hypothetical
```

#### Practical Applications
- File type validation: `fileName.endsWith(".txt")` to check for text files.
- Name filtering: `studentName.startsWith("ABC")` for grouping.
- Data extraction: Use `indexOf()` to find delimiters in CSV-like data.

## String Retrieving Methods

### Overview
Retrieval methods allow extracting characters or substrings from strings, forming the basis for dynamic content manipulation. These include accessing individual characters, substrings by position, and splitting strings into tokens, essential for parsing and transformation tasks in Java applications.

### Key Concepts/Deep Dive

#### charAt()
- **Purpose**: Retrieves a single character at a specified 0-based index.
- **Valid Indices**: 0 to `length() - 1`.
- **Exceptions**: Throws `StringIndexOutOfBoundsException` for invalid indices.
- **Syntax**: Return type `char`, method name `charAt(int)`.

#### Retrieving All Characters
- **Via Loop**: Use `for` loop with `charAt()` for individual retrieval.
  ```java
  String s1 = "Java";
  for (int i = 0; i < s1.length(); i++) {
      System.out.println(s1.charAt(i));
  }
  ```
- **Via Streams** (Java 8+): Use `chars()` method returning `IntStream`.

#### substring()
- **Purpose**: Extracts a substring from a specified start index to end.
- **Overloads**:
  - `substring(int beginIndex)`: From `beginIndex` to end.
  - `substring(int beginIndex, int endIndex)`: From `beginIndex` to `endIndex - 1` (endIndex exclusive).
- **Index Rules**: `beginIndex` must be < `endIndex`, within bounds.

#### subsequence()
- **Purpose**: Same as `substring()`, implementing `CharSequence`.
- **Syntax**: Identical to `substring()`.

#### split()
- **Purpose**: Divides the string into tokens based on a delimiter.
- **Return Type**: `String[]` array of tokens.
- **Delimiter Behavior**:
  - Delimiter can be char or string.
  - Continues delimiters result in empty strings in the array.
  - Delimiters not found return the whole string as one token.
- **Edge Cases**:
  - Delimiter at start/end may include empty tokens.
- **Syntax**: Return type `String[]`, method name `split(String)`.

#### When to Use
- `charAt()`: Access random characters.
- `substring()`: Extract known sections (e.g., file extensions, words).
- `split()`: Parse delimited data (e.g., CSV files, sentence words).

#### Code Examples
```java
String s1 = "Java Programming Language";

// charAt examples
System.out.println(s1.charAt(0));   // 'J'
System.out.println(s1.charAt(4));   // ' '

// substring examples
System.out.println(s1.substring(5));              // "Programming Language"
System.out.println(s1.substring(5, 16));          // "Programming" (5 to 15)

// split examples
String csv = "John,Doe,Jane";
String[] parts = csv.split(",");
System.out.println(Arrays.toString(parts)); // ["John", "Doe", "Jane"]

String words = "Java Har Krishna";
String[] tokens = words.split(" ");  // Split by space
System.out.println(Arrays.toString(tokens)); // ["Java", "Har", "Krishna"]
```

#### Retrieving Substrings Dynamically
- Combine `indexOf()` and `substring()` for position-based extraction:
```java
String text = "Java is a programming language";
int start = text.indexOf("programming"); // Assume 13
String sub = text.substring(start, start + "programming".length());
System.out.println(sub); // "programming"
```

| Method | Return Type | Purpose | Parameters |
|--------|-------------|---------|------------|
| charAt | char | Single character | int index |
| substring | String | Substring range | int beginIndex [, int endIndex] |
| split | String[] | Token array | String delimiter |

## String Conversion Methods

### Overview
Conversion methods transform strings to arrays or primitives/objects to strings, enabling data interchange between types. These methods support encoding, serialization, and user input processing in Java applications, bridging string and non-string data.

### Key Concepts/Deep Dive

#### toCharArray()
- **Purpose**: Converts string characters into a `char` array.
- **Return Type**: `char[]`.
- **Syntax**: Method name `toCharArray()`.

#### getBytes()
- **Purpose**: Converts string to byte array using platform charset (e.g., ASCII values).
- **Return Type**: `byte[]`.
- **Syntax**: Return type `byte[]`, method name `getBytes()`.

#### valueOf() (Static Overloading)
- **Purpose**: Converts primitives or objects to string representation.
- **Overloads**: `valueOf(boolean)`, `valueOf(char)`, `valueOf(int)`, `valueOf(long)`, `valueOf(double)`, `valueOf(float)`, `valueOf(Object)`.
- **Internals**: Calls wrapper class `toString()` methods; for objects, calls `Object.toString()`.
- **Syntax**: Return type `String`, method name `valueOf(var)`.

#### Alternative Conversions to Strings
- **Concatenation**: `"String" + primitive` (internally calls `valueOf()`).
- **Wrapper toString()**: e.g., `Integer.toString(int)` (recommended).
- **Note**: All methods ultimately route to wrapper `toString()` for primitives.

#### Converting Strings to Primitives
- **Parse Methods**: Mentioned briefly; e.g., `parseInt()` from wrapper classes for parsing digits.
- **Exceptions**: Throws `NumberFormatException` for non-digit characters.

#### Code Examples
```java
String s1 = "ABC";
char[] charArray = s1.toCharArray();
byte[] byteArray = s1.getBytes();

// Primitive to String
int num = 123;
String str = String.valueOf(num);  // "123"
String str2 = Integer.toString(num);  // "123"
String str3 = "" + num;              // "123"

// Parse String to Primitive
String digitStr = "456";
int parsed = Integer.parseInt(digitStr);  // 456
// Throws NumberFormatException for "abc"
```

| Conversion Type | Method | Example Input | Output |
|-----------------|--------|----------------|--------|
| String to char array | toCharArray() | "ABC" | {'A', 'B', 'C'} |
| String to byte array | getBytes() | "A" | {65} (ASCII) |
| Primitive to String | valueOf() | 123 | "123" |
| Object to String | valueOf() | new MyClass() | Object.toString() result |

## Practical Scenarios and Practice Exercises

### Overview
String methods are applied in real-world scenarios like file processing, data validation, and user input handling. Practice exercises reinforce concepts through scenario-based coding, preparing for development and interviews.

### Key Concepts/Deep Dive

#### Scenario-Based Applications
- **File Extension Checking**: Use `endsWith()` to filter file types (e.g., `.txt`, `.csv`).
- **CSV Parsing**: Use `split()` to read comma-separated employee data for outsourcing lists.
- **File Name Validation**: Use `startsWith()` or `endsWith()` for identity checks.
- **Case-Insensitive Searching**: Apply `toLowerCase()` with `contains()` for text search.
- **Dynamic Substring Extraction**: Combine `indexOf()` and `substring()` for content retrieval.

#### Sample Practice Exercises
1. **File Type Identification**: Write a program to check if a filename ends with `.txt` using `endsWith()`. Print "Text file" or "Not a text file".
2. **Word Splitting**: Use `split()` to divide a sentence by spaces and print each word separately.
3. **Substring Retrieval**: Find and extract "program" from any string using `indexOf()` and `substring()`.
4. **Comparing Strings for Sorting**: Sort an array of strings using `compareTo()` logic.
5. **Case Handling**: Implement case-insensitive search for a substring using conversions.

Develop home programs and solve scenarios to build proficiency. Test with console or files for reinforcement.

## Summary

### Key Takeaways
```diff
+ String emptiness: Use isEmpty() for null-length, isBlank() for whitespace-inclusive checks
+ Length and representation: length() returns characters; toString() displays content
+ Equality checks: == for references, equals() for content, equalsIgnoreCase() for case-insensitive
+ Lexicographical comparison: compareTo() returns int for sorting, compareToIgnoreCase() ignores case
+ Searching: contains() for presence, startsWith()/endsWith() for boundaries, indexOf()/lastIndexOf() for positions
+ Retrieval: charAt() for single chars, substring() for ranges, split() for tokens, toCharArray() for arrays
+ Conversion: getBytes() to byte array, valueOf() static for primitives/objects to strings; wrapper toString() preferred
- Avoid calling toString() explicitly; use valueOf() for consistency
! Combine indexOf() with substring() for dynamic extraction; handle array indices (0 to length-1) to prevent exceptions
```

### Expert Insight

#### Real-world Application
String methods power data processing in frameworks like Spring Boot and file I/O in Java. For instance, `split()` parses JSON-like structures or CSV data in ETL pipelines, while `indexOf()` extracts metadata from logs. In web apps, `contains()` validates inputs, and conversions handle API responses.

#### Expert Path
Master all overloads and edge cases via Java 22 API docs. Practice algorithms like binary search on strings for interviews. Explore Streams API (`chars()`) for modern string processing in lambda expressions.

#### Common Pitfalls
Treating `length()` as a property (it's a method); misusing `==` for content comparison; forgetting index exclusivity in `substring()` (endIndex excluded); not handling `StringIndexOutOfBoundsException` in retrieval; ignoring case sensitivity without conversions. Also, split delimiters may return empty tokens unexpectedly.

Lesser-known things include `subSequence()` being functionally identical to `substring()`, and `valueOf()` internally calling wrapper `toString()` methods in newer Java versions. `contentEquals()` is rarely used but supports character sequences beyond strings.

> [!NOTE]  
> There were several transcription errors corrected: "toString()" methods referred as "tostring" (standardized to proper case); "lexographically" corrected to "lexicographically"; "comparative" corrected to "compareTo"; "Stringer" to "String array"; "consol" assumed as "console" but not directly used; "arrays dot" to "Arrays.toString()"; "integer now it is not calling get cash method" interpreted as calling `toString()` via valueOf(); "two stringer" to "toString()". No major technical inaccuracies; interpretations followed documentation.
