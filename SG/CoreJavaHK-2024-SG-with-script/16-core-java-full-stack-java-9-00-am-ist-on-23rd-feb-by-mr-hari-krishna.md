# Session 16: Keywords and Edit Plus

## Table of Contents
- [Keywords and Reserved Words](#keywords-and-reserved-words)
- [Java Tokens](#java-tokens)
- [Comments](#comments)
- [Identifiers](#identifiers)
- [Edit Plus Introduction](#edit-plus-introduction)
- [Summary](#summary)

## Keywords and Reserved Words

### Overview
This session covers the evolution of Java keywords from initial versions to Java 21, explaining the differences between keywords, reserved words, contextual keywords, and special identifiers. Understanding these foundational elements is crucial for writing valid Java code and avoiding compilation errors.

### Key Concepts/Deep Dive

#### Keywords Evolution Across Versions
Java has undergone significant changes in its keyword set across versions:

- **Java 1.0**: 47 keywords were available from the initial release
- **Java 1.2**: Added `strictfp`
- **Java 1.4**: Added `assert`  
- **Java 1.5**: Added `enum`
- **Java 9**: Added 10 restricted keywords and `var` (special identifier)
  - Restricted keywords: Used only within module programs
  - Context-specific keywords that act as keywords only in module areas, not in class programs
- **Java 10**: Added `var` as special/restricted identifier
- **Java 11-13**: No major changes
- **Java 14**: Added `record`
- **Java 15**: Added `sealed`, `permits`, `non-sealed`
- **Java 21**: Keywords divided into:
  - **Reserved keywords** (51 total): Perform specific operations
  - **Contextual keywords** (60 total): Deprecated terminology; now grouped under reserved keywords

> [!IMPORTANE NOTICE]  
> ## Transcript Corrections Identified
> - "usefedfined" → "user-defined"
> - Multiple instances of "result" → "reserved"
> - "youtu're" → "you're"
> - Spelling inconsistencies with case (e.g., "Sealed" → "sealed")

#### Keyword Categories
The 73 words are classified into four main categories (prior to Java 19 grouping):

1. **Keywords**: Predefined identifiers that perform specific operations
2. **Reserved Literals**: Literal values like `null`, `true`, `false` that don't perform operations
3. **Restricted Keywords**: Act as keywords only in specific contexts (module programs)
4. **Special/Restricted Identifiers**: Can be used as user-defined identifiers but have special meaning (e.g., `var` in Java 10, `record` in Java 14)

#### Difference Between Keywords and Reserved Words
```diff
+ Keywords: Perform specific operations (e.g., if, class, void)
- Reserved Words: Reserved in language but don't perform operations by themselves (e.g., null, true, false)
```

### Code/Config Blocks
Example of restricted keyword usage:
```java
// This compiles - restricted keyword 'open' used in class area
class Example {
    // 'open' can be used as variable name here
    int open = 10;  
}

module MyModule {
    // 'open' acts as keyword here
    open module MyModule {
    }
}
```

### Tables

| Version | New Keywords | Total Keywords | Notes |
|---------|--------------|----------------|-------|
| Java 1.0 | N/A | 47 | Initial release |
| Java 1.2 | strictfp | 48 | Floating-point precision |
| Java 1.4 | assert | 49 | Debug assertion |
| Java 1.5 | enum | 50 | Enumeration support |
| Java 9 | 10 restricted + var | 61 + restricted | Module system, var identifier |
| Java 14 | record | 62 | Record classes |
| Java 15 | sealed, permits, non-sealed | 65 | Sealed classes |
| **Java 21** | **6 contextual** | **51 reserved + 60 contextual** | Reorganized categories |

## Java Tokens

### Overview
Tokens are the smallest indivisible units in Java programs that identify programming elements. Java programs consist entirely of these five token types, enabling the compiler to parse and understand code structure.

### Key Concepts/Deep Dive

#### Token Definition
- **Token**: Smallest unit in a Java program that cannot be further divided
- Used to identify large programming constructs from individual elements
- Example: `class` token identifies a whole class structure

#### Java Token Types (5 Total)
1. **Keywords**: Control program flow and structure (e.g., `class`, `int`, `if`)
2. **Identifiers**: Programmer-defined names for elements (e.g., class names, variables, methods)
3. **Operators**: Mathematical and logical operations (e.g., `+`, `==`, `<`)
4. **Literals**: Fixed values (e.g., `10`, `"hello"`, `true`)  
5. **Separators**: Symbols separating code elements (e.g., `{`, `(`, `;`)

#### Programming Elements (8 Categories)
```java
class Addition {           // 1. Class
    int a = 10;           // 2. Variable (for data storage)
    void sum() {}         // 3. Method (for functionality)
    Addition obj;         // 4. Reference variable
    interface MyInt {}    // 5. Interface
    enum Days {}          // 6. Enum
    @interface MyAnn {}   // 7. Annotation  
    public static void main(String[] args) {} // 8. Main method
}
```

### Tables

| Token Type | Examples | Purpose |
|------------|----------|---------|
| Keywords | `class`, `int`, `public`, `static` | Define program structure |
| Identifiers | `main`, `args`, `myVar` | Name program elements |
| Operators | `+`, `==`, `-`, `*` | Mathematical/logical operations |
| Literals | `10`, `"text"`, `true`, `null` | Represent fixed values |
| Separators | `{`, `}`, `(`, `)`, `;`, `,`, `.` | Separate code elements |

## Comments

### Overview
Comments are special text ignored by the compiler but provide descriptions and documentation. They improve code readability and maintainability.

### Key Concepts/Deep Dive

#### Comment Types (3 Types)
1. **Single-line Comments**: `// comment` - ignored until end of line
2. **Multi-line Comments**: `/* comment */` - spans multiple lines  
3. **Documentation Comments**: `/** comment */` - generates API docs

#### Comment Purposes
- Provide descriptions for others (and future self)
- Ignore code sections during compilation
- Improve code understanding and maintenance

```java
// Single-line comment

/*
Multi-line 
comment
*/

/**
 * Documentation comment
 * @param args command line arguments
 */
public class Main {
    public static void main(String[] args) {
        System.out.println("Hello"); // Another comment
    }
}
```

## Identifiers

### Overview
Identifiers are user-defined names for programming elements. They follow strict naming rules and serve as the bridge between programmer intent and Java language requirements.

### Key Concepts/Deep Dive

#### Identifier Definition
- Names given to programming elements (classes, methods, variables, etc.)
- Used for identification and accessing elements throughout the program

#### Identifier Rules (7 Rules)
1. **Case Sensitive**: `MyVar` ≠ `myvar` ≠ `MYVAR`
2. **Length Unlimited**: Can be any length
3. **First Character**: Must be letter (a-z), underscore (_), or dollar sign ($)
4. **Subsequent Characters**: Letters, digits (0-9), underscores, dollar signs  
5. **No Reserved Words**: Cannot use keywords as identifiers
6. **No Special Characters**: No spaces, symbols (@, #, etc.)
7. **Unicode Support**: Supports international characters

#### Valid/Invalid Examples
```java
// Valid identifiers
int myVariable = 10;
class MyClass {}
void _method() {}
String $var = "test";

// Invalid identifiers
int 123invalid;      // Cannot start with digit
void my-method();     // Hyphens not allowed  
String my var = "";   // Spaces not allowed
int for = 5;         // 'for' is reserved keyword
```

### Tables

| Element Type | Identifier Rules | Example |
|--------------|------------------|---------|
| Package | All lowercase, no hyphen | `com.example.myapp` |
| Class | PascalCase (capitalize each word) | `CustomerOrder` |
| Variable/Method | camelCase (first word lowercase) | `calculateTotal()` |
| Constant | UPPER_SNAKE_CASE | `MAX_SIZE` |

## Edit Plus Introduction

### Overview
Edit Plus is an advanced text editor software that provides significant productivity improvements over basic editors like Notepad. It includes code templates, syntax highlighting, and customization options specifically beneficial for Java development.

### Key Concepts/Deep Dive

#### Edit Plus vs Notepad Comparison
Edit Plus overcomes Notepad's limitations with advanced features:

| Limitation | Edit Plus Solution |
|------------|-------------------|
| No code templates | Automatic Java program template generation |
| Manual indentation | Auto-indenting for proper code alignment |
| Black/white text only | Syntax highlighting (keywords blue, strings pink, etc.) |
| Manual compilation/execution | Configured shortcuts (Ctrl+1 compile, Ctrl+2 execute) |
| No auto-saving | Auto-saves before compilation |
| Column selection difficult | Alt+C for column mode selection |
| No shortcuts for common operations | Case changes, duplicate lines, date/time insertion |

#### Installation and Setup
1. Download from editplus.org (free 30-day trial)
2. Run installer → follow prompts
3. After installation, pin to desktop
4. On first run: Click "Try" → "I Agree"
5. After 30 days: Hide trial expired window to continue using

#### Essential Configurations
```bash
# Compiler Configuration (Tools → Configure User Tools)
Menu Text: Compiler  
Command: C:\JDK21\bin\javac.exe  # Browse to select javac
Argument: $(FileName)  # File name with extension
Initial Directory: $(FileDir)

# JVM Configuration  
Menu Text: JVM
Command: C:\JDK21\bin\java.exe   # Browse to select java
Argument: $(FileNameNoExt)  # File name without extension
Initial Directory: $(FileDir)
```

### Code/Config Blocks
Sample Java template automatically generated:
```java
public class ClassName {
    public static void main(String[] args) {
        
    }
}
```

Custom date/time insertion:
```java
// Ctrl+D: 2024-02-23
// Ctrl+Shift+D: Friday, February 23, 2024
```

### Lab Demos

#### Creating and Compiling First Program
1. Open Edit Plus → File → New → Java
2. Type class name after template appears
3. Save file (no extension needed - auto-added)
4. Press Ctrl+1 to compile (configures JVM first)
5. Press Ctrl+2 to execute
6. View output and any error messages

#### Using Column Selection
1. Place cursor at starting position
2. Press Alt+C to enter column mode
3. Move right/left with arrow keys to select column width
4. Move up/down to extend selection height
5. Type text to replace all selected content simultaneously

#### Moving Lines with Shortcuts
1. Place cursor on line to move
2. Press Alt+Shift+Up/Down arrows
3. Line moves without needing cut/paste

### Tables

| Shortcut | Function | Description |
|----------|----------|-------------|
| Ctrl+1 | Compile | Compiles current Java file (needs configuration) |
| Ctrl+2 | Execute | Runs compiled Java program |
| Ctrl+J | Duplicate Line | Copies current line below |
| Ctrl+U | Upper Case | Converts selected text to UPPERCASE |
| Ctrl+L | Lower Case | Converts selected text to lowercase |
| Ctrl+Shift+U | Title Case | Capitalizes first letter of each word |
| Ctrl+K | Invert Case | Toggles case of each character |
| Alt+Delete | Delete Word | Removes word at cursor |
| Alt+Shift+Delete | Delete Line | Removes entire line |
| Alt+C + Arrows | Column Select | Selects rectangular text blocks |
| Alt+Shift+Arrows | Move Lines | Moves line(s) up/down |
| Ctrl+D | Insert Date | Inserts short date format |
| Ctrl+Alt+D | Insert Long Date | Inserts full date format |
| Ctrl+M | Insert Time | Inserts short time |
| Ctrl+Shift+M | Insert Long Time | Inserts full time with milliseconds |

## Summary

### Key Takeaways
```diff
+ Java has 73 total words divided into reserved keywords (51) and contextual keywords (60+)
+ Restricted keywords only function in module programs, as regular identifiers elsewhere
+ Special identifiers like 'var' can be used as regular names but serve special purposes
+ Java tokens (5 types): keywords, identifiers, operators, literals, separators enable program structure
+ Edit Plus significantly improves development productivity over basic editors
+ Proper identifier naming follows specific conventions for different Java elements
+ Edit Plus configuration enables direct compilation and execution without command line navigation
! Class and Java file names must match for Edit Plus execution shortcuts to work
```

### Expert Insight

#### Real-world Application
Understanding keyword evolution is crucial for enterprise applications targeting specific Java versions. Edit Plus streamlines rapid prototyping in professional environments, particularly useful for microservices development where quick testing of business logic is essential.

#### Expert Path  
Master the complete keyword list (especially the 11 contextual keywords) through chapter-by-chapter implementation. Practice Edit Plus shortcuts in daily coding until they become muscle memory. Focus on pattern recognition when learning token parsing.

#### Common Pitfalls
- Forgetting restricted keyword context – use `open` as identifier in module programs
- Mismatch between class name and file name prevents Edit Plus execution shortcuts  
- Not configuring JDK paths properly results in "command not found" errors
- Overlooking backup file creation consumes unnecessary disk space

#### Lesser Known Things  
Case conversion shortcuts work on multi-line selections. Column mode demonstrates Edit Plus' superior text manipulation over Notepad++ for certain refactoring tasks. Auto-template insertion distinguishes Edit Plus from other lighter editors, making it preferred for Java curriculum courses.
