# Session 50: Working With Properties

## Table of Contents
- [Overview](#overview)
- [Reading Passwords Securely with Console Class](#reading-passwords-securely-with-console-class)
- [Limitations of Console Class](#limitations-of-console-class)
- [Understanding Properties](#understanding-properties)
- [Properties Class for In-Program Storage](#properties-class-for-in-program-storage)
- [Enumeration for Dynamic Property Retrieval](#enumeration-for-dynamic-property-retrieval)
- [Creating Properties Files](#creating-properties-files)
- [Properties File vs. In-Program Storage](#properties-file-vs-in-program-storage)

## Overview
This session covers secure input handling, specifically password reading using the Console class, and introduces the concept of properties in Java. You'll learn how to work with properties both in-memory using the Properties class and persistently in files, along with enumeration for dynamic property retrieval. The session emphasizes security best practices for password input and demonstrates practical approaches for storing and accessing configuration data.

## Reading Passwords Securely with Console Class
### Deep Dive into Secure Password Input
> **Key Concept**: When reading sensitive data like passwords, visibility to the console is a critical security vulnerability. Traditional approaches expose clear text, while the Console class provides cryptographic-grade masking.

**Approach Comparison**:

| Approach | Visibility | Security Level | Recommended Use |
|----------|------------|----------------|-----------------|
| Scanner | Password visible | ❌ Critical Vulnerability | Never for passwords |
| BufferReader | Password visible | ❌ Critical Vulnerability | Never for passwords |
| Command Line Arguments | Password visible | ❌ Critical Vulnerability | Never for passwords |
| Console Class | Password hidden | ✅ Secure | Recommended for passwords |

**Console Class Key Features**:
- **Constructor Privacy**: Console class cannot be instantiated with `new Console()` because the constructor is private
- **Singleton Pattern**: Use `System.console()` to get the existing console object
- **Available Methods**:
  - `readLine()`: For non-sensitive data (username)
  - `readPassword()`: For confidential data (password, PIN)
- **Type Safety**: `readPassword()` returns `char[]` instead of `String` for immediate destruction after use

```java
import java.util.Scanner;
import java.io.Console;

// INCORRECT APPROACH - Password visible
public class InsecurePasswordReader {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        System.out.print("Enter password: ");
        String password = scanner.nextLine(); // Password visible
    }
}

// CORRECT APPROACH - Secure password input
public class SecurePasswordReader {
    public static void main(String[] args) {
        Console console = System.console();
        if (console != null) {
            char[] password = console.readPassword("Enter password: ");
            // Process password immediately
            // Convert to string if needed: String pwd = new String(password);
            // Clear sensitive data: Arrays.fill(password, ' ');
        }
    }
}
```

> **Expert Insight**: The `char[]` return type prevents JVM string pooling where sensitive data might persist in memory, enabling immediate cleanup of credentials.

## Limitations of Console Class
### Runtime Environment Constraints

> **Critical Limitation**: Console class only works within native command prompt/console windows, not within IDE consoles or redirected streams.

**Rule**:
> [!IMPORTANT]
> Classes using Console class **must** execute within command prompt window. Direct execution or Control+2 in IDE returns `null`, causing `NullPointerException`.

**Configuration Example for EditPlus**:
1. Go to Tools → Configure User Tool → Select JVM option → Check "Capture Output"
2. Apply configuration
3. Run with Control+2 for command prompt execution

**Memory Diagram**:

```mermaid
graph TD
    A[Command Prompt Window] --> B(System.console() returns Console Object)
    C[IDE Console/Eclipse Console] --> D(System.console() returns null)
    D --> E[NullPointerException on method calls]
```

> **Expert Insight**: `System.console()` verifies the console environment, returning null for IDE-integrated consoles. This prevents security vulnerabilities in development environments while enforcing secure execution contexts.

## Understanding Properties
### Properties Fundamentals

> **Key Definition**: A property is a name-value pair where both name and value are strings. Properties represent configurable data that can persist across program executions.

**Property Syntax**:
- Name and value separated by `=`, `:`, or in some cases `: =`
- Each property on separate line
- No required data types (all stored as strings)

**Example Properties File** (`student.properties`):
```
SN=101
SName=HK
Course=Core Java
Fee=2500
```

**Memory Representation**:
- Properties `SN=101` represents configuration data
- Unlike variables (temporary), properties can be persisted to file system
- Enables external configuration without code changes

> **Diff Blocks Example**:
> 
> + Positive: Properties enable external configuration
> - Negative: All values are strings, requiring type conversion
> ! Alert: Properties files support only text data

## Properties Class for In-Program Storage
### In-Memory Property Management

> **Core Concept**: Properties class (from `java.util` package) provides thread-safe, in-memory storage for name-value pairs. Internal implementation uses private variables for encapsulation.

**Essential Methods**:
- `setProperty(String name, String value)` - Store property
- `getProperty(String name)` - Retrieve specific property
- `propertyNames()` - Get enumeration of all property names

**Complete Code Example**:

```java
import java.util.Properties;
import java.util.Enumeration;

public class PropertiesExample {
    public static void main(String[] args) {
        Properties p1 = new Properties(); // Empty properties object
        
        // Store properties
        p1.setProperty("SN", "101");
        p1.setProperty("SName", "HK");
        p1.setProperty("Course", "Core Java");
        p1.setProperty("Fee", "2500");
        
        // Retrieve specific property (when name is known)
        String sn = p1.getProperty("SN");
        String sname = p1.getProperty("SName");
        String course = p1.getProperty("Course");
        String fee = p1.getProperty("Fee");
        
        System.out.println("SN: " + sn);
        System.out.println("SName: " + sname);
        System.out.println("Course: " + course);
        System.out.println("Fee: " + fee);
    }
}
```

**Limitations of Direct Retrieval**:
- Requires knowledge of property names
- Repetitive code for multiple properties
- Cannot enumerate unknown properties

> **Expert Insight**: Properties class encapsulates storage logic, preventing direct manipulation while providing controlled access through methods. This prevents data corruption and enforces type safety.

## Enumeration for Dynamic Property Retrieval
### Handling Unknown Properties

> **Key Use Case**: When property names are unknown or dynamically loaded from files/databases, enumeration provides a mechanism to iterate through all properties without prior knowledge.

**Enumeration Interface Methods**:
- `hasMoreElements()` - Verify if more elements exist
- `nextElement()` - Retrieve current element and advance cursor

**Enumeration Workflow**:
1. Get enumeration from `propertyNames()`
2. Use `hasMoreElements()` to check availability
3. Call `nextElement()` to get property name (as Object)
4. Use name to retrieve value via `getProperty()`

```java
import java.util.Properties;
import java.util.Enumeration;

public class PropertiesEnumerationExample {
    public static void main(String[] args) {
        Properties p1 = new Properties();
        
        p1.setProperty("SN", "101");
        p1.setProperty("SName", "HK");
        p1.setProperty("Course", "Core Java");
        p1.setProperty("Fee", "2500");
        
        // Dynamic retrieval without knowing property names
        Enumeration<String> e = (Enumeration<String>) p1.propertyNames();
        
        while (e.hasMoreElements()) {
            String name = e.nextElement();
            String value = p1.getProperty(name);
            System.out.println(name + ": " + value);
        }
    }
}
```

**Memory Flow Diagram**:

```mermaid
graph TD
    A[Properties Object p1] --> B[propertyNames() returns Enumeration e]
    B --> C[e.hasMoreElements() checks first property]
    C --> D[true: e.nextElement() gets 'SN', cursor moves]
    D --> E[p1.getProperty('SN') returns '101']
    E --> F[Display 'SN: 101']
    F --> G[e.hasMoreElements() checks next property]
    G --> H[Repeat until false]
```

> **Expert Insight**: Enumeration implements cursor-based iteration, similar to scanner but for collections. Always check `hasMoreElements()` before `nextElement()` to prevent `NoSuchElementException`.

## Creating Properties Files
### Persistent Storage

> **Key Concept**: Properties objects exist only during program execution. Files provide permanent storage with `.properties` extension indicating text-only data.

**File-Based Properties Storage**:
- Extension: `.properties`
- Format: Text file with `[property_name]=[value]` syntax
- Location: Can reside anywhere in file system
- Loading: Program can read from file at startup

**Example Properties File Creation** (`student.properties`):
```
SN=101
SName=HK
Course=Core Java
Fee=2500
```

> **Development vs. Production**: In development, edit properties via text editors; in production, generate dynamically through code.

## Properties File vs. In-Program Storage
### Storage Strategy Comparison

**Dual Storage Approaches**:

| Aspect | Properties File | Properties Class (In-Memory) |
|--------|-----------------|------------------------------|
| Persistence | ✅ Permanent storage | ❌ Ephemeral |
| Data Types | 📝 Text only | 📝 Text only |
| Accessibility | 🔧 External modification | 🔧 Program control only |
| Performance | ⚡ File I/O overhead | ⚡ Instant access |
| Security | 🔒 External file exposure | ✅ Memory isolation |

**Loading from File** (Advanced concept for next sessions):
```java
Properties config = new Properties();
FileInputStream fis = new FileInputStream("config.properties");
config.load(fis);
// Properties now loaded from file
```

> **Expert Insight**: Choose file storage for configuration that changes independently of code (database URLs, API keys); use in-memory for runtime-generated data or temporary configurations.

## Summary

### Key Takeaways
```diff
+ Properties class enables secure, in-memory configuration management with encapsulation
+ Enumeration provides dynamic retrieval without knowing property names upfront
+ Console class ensures password security but requires command prompt execution
+ Properties files offer persistence but are text-only and require careful type handling
- Never use Scanner/BufferReader for passwords due to visibility vulnerabilities  
- Avoid calling Enumeration.nextElement() without hasMoreElements() check
! Properties must be strings; convert numeric types before storage/storage
```

### Expert Insight

#### Real-world Application
In enterprise applications, Properties classes manage database connections, API endpoints, and email configurations. For example, a web crawler uses properties files for dynamically configurable rate limits and user-agent strings, while encryption keys remain in-memory Properties objects.

#### Expert Path
Master properties by implementing configuration managers with environment-specific overrides. Learn Java Preferences API for user-specific settings, and explore Apache Commons Configuration for advanced features like property validation and hot-reloading.

#### Common Pitfalls
Data type confusion: Remember all property values are strings - convert integers/doubles explicitly:
```java
// AVOID: Direct numeric conversion without parsing
int fee = (Integer) p.getProperty("Fee"); // ClassCastException

// CORRECT: Parse string to appropriate type  
int fee = Integer.parseInt(p.getProperty("Fee"));

Another pitfall: Properties are not thread-safe by default. Use `Collections.synchronizedMap()` or external synchronization for concurrent access. For properties files, implement atomic write operations using temporary files to prevent corruption during concurrent reads/writes.

#### Lesser Known Things
Properties class extends Hashtable, making it thread-safe for single operations but not compound operations. The system properties (via `System.getProperties()`) expire with JVM termination, perfect for JVM-wide configuration like time zones or system paths. Enumeration objects are stateful iterators - create fresh ones for multiple traversals. Properties files support Unicode escaping (e.g., `\u00E9` for é), enabling internationalization without encoding issues.
