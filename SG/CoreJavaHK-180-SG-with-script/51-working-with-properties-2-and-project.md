# Session 51: Working With Properties 2 And Project

## Table of Contents
- [System Properties](#system-properties)
- [Accessing JVM OS Properties](#accessing-jvm-os-properties)  
- [Setting Custom Properties in System Properties Object](#setting-custom-properties-in-system-properties-object)
- [Runtime Configuration via -D Option](#runtime-configuration-via--d-option)
- [Lab Demos](#lab-demos)
- [Project Implementation](#project-implementation)

## System Properties

### Overview
System properties represent configuration values maintained by the JVM for Java applications. These include both predefined OS-level properties (like operating system details, file separators, user information) and custom properties that can be set by the application. The system properties are stored in a Properties object that is common to all classes loaded in the JVM, making them accessible from any class within the application.

### Key Concepts/Deep Dive

The system properties mechanism allows Java applications to access OS-level environment information and maintain JVM-wide configuration. Here's how it works:

1. **JVM Architecture Integration**: When JVM starts, it loads OS environment variables and system properties into an internal Properties object stored within the `System` class.

2. **System Class Role**: The `System` class acts as the primary interface for accessing JVM-level resources. For properties, it provides static methods that internally access the shared Properties object.

3. **Properties Object Structure**: Properties are stored as key-value pairs where both keys and values are String objects. The implementation uses a HashMap internally to maintain the property mappings.

```java
// Properties class methods for system properties:
public class System {
    // Static method to retrieve properties object
    public static Properties getProperties()
    
    // Static method to get individual property  
    public static String getProperty(String key)
    
    // Static method to set individual property
    public static String setProperty(String key, String value)
}
```

#### Common Predefined System Properties
The JVM automatically populates several predefined properties from the operating system:

| Property Name | Example Value | Description |
|---------------|---------------|-------------|
| `os.name` | "Windows 10" | Operating system name |
| `os.version` | "10.0.19044" | Operating system version |
| `user.name` | "hk" | Current user name |
| `user.home` | "C:\Users\hk" | User home directory |
| `java.version` | "11.0.15" | Java version |
| `java.vendor` | "Oracle Corporation" | Java vendor |
| `file.separator` | "/" or "\" | File separator character |

### Code/Config Blocks

**Basic System Property Access:**
```bash
# Command prompt - set command shows OS environment variables
set
# Displays properties like OS, PATH, USERNAME, etc.
```

**Java System Property Retrieval:**
```java
public class SystemPropertiesDemo {
    public static void main(String[] args) {
        // Accessing individual system properties
        String osName = System.getProperty("os.name");
        String userName = System.getProperty("user.name");
        
        System.out.println("OS: " + osName);
        System.out.println("User: " + userName);
    }
}
```

## Accessing JVM OS Properties

### Overview
JVM automatically loads operating system environment information when it starts. These properties become available to all Java applications running within that JVM instance, providing programmatic access to system-level configuration without requiring external dependencies.

### Key Concepts/Deep Dive

The JVM bridges the gap between Java applications and the underlying operating system by importing system properties at startup. This creates a standardized way to access OS-specific information regardless of the platform.

1. **JVM Initialization Process**: During JVM startup, before executing any user code, the JVM reads OS environment variables and converts them into Java system properties stored in the Properties object.

2. **Cross-Class Availability**: Since the Properties object is stored at JVM level within the System class, all classes loaded in that JVM can access these properties uniformly.

3. **Enumeration Access Pattern**: To retrieve all available properties, use the `propertyNames()` method which returns an Enumeration of all property keys.

```java
// Retrieving all system properties
Properties props = System.getProperties();
Enumeration<?> propertyNames = props.propertyNames();
while (propertyNames.hasMoreElements()) {
    String key = (String) propertyNames.nextElement();
    String value = props.getProperty(key);
    System.out.println(key + ": " + value);
}
```

#### Accessing Specific OS Properties
Commonly accessed OS properties include:

- **OS Detection**: Use `os.name` for operating system identification
- **User Information**: `user.name`, `user.home` for user-specific paths  
- **JVM Information**: `java.version`, `java.home` for Java runtime details
- **File System**: `file.separator`, `path.separator` for OS-specific separators

```java
// OS-specific logic example
String osName = System.getProperty("os.name").toLowerCase();
if (osName.contains("windows")) {
    System.out.println("Running on Windows");
} else if (osName.contains("linux")) {
    System.out.println("Running on Linux");
} else if (osName.contains("mac")) {
    System.out.println("Running on macOS");
}
```

## Setting Custom Properties in System Properties Object

### Overview
While JVM automatically populates predefined system properties, applications can extend this by storing custom properties. Unlike creating your own Properties object (which is limited to the current class), setting properties in the system Properties object makes them available JVM-wide across all classes.

### Key Concepts/Deep Dive

Custom properties can be added to the system Properties object using the `System.setProperty()` method. These properties persist for the lifetime of the JVM and can be accessed from any class, making them ideal for sharing configuration across multiple classes in an application.

#### Key Differences: Custom Properties Object vs System Properties Object

| Aspect | Custom Properties Object | System Properties Object |
|--------|-------------------------|---------------------------|
| Scope | Current class only | All classes in JVM |
| Lifetime | Until object is garbage collected | Until JVM shuts down |
| Storage Location | Heap memory within class instance | JVM-level System class |
| Access Method | Instance methods on Properties object | Static System class methods |

```java
// Custom Properties object (class scope)
Properties customProps = new Properties();
customProps.setProperty("app.version", "1.0");
String version = customProps.getProperty("app.version"); // Available in this class only

// System Properties object (JVM scope)
System.setProperty("app.version", "1.0");
// Available from any class via System.getProperty("app.version")
String version = System.getProperty("app.version"); // Available everywhere
```

#### Persistence and Scope
System properties set programmatically exist only for the current JVM session. Once the application terminates and JVM shuts down, these custom properties are lost. This static behavior ensures:

- Properties are shared across classes but not persistent between application runs
- No permanent changes to the system configuration
- Thread-safe access (Properties object is synchronized)
- Immediate availability to newly loaded classes

```java
public class ClassA {
    public void setGlobalProperty() {
        System.setProperty("common.value", "shared_data");
    }
}

public class ClassB {
    public void readGlobalProperty() {
        String value = System.getProperty("common.value"); // Can access from here
    }
}
```

## Runtime Configuration via -D Option

### Overview
The JVM supports runtime configuration through command-line arguments, allowing developers to inject configuration values at startup. This mechanism supports both JVM-level settings and custom application properties, providing flexibility without code changes.

### Key Concepts/Deep Dive

The `-D` option informs JVM about system properties to be stored in the System Properties object. Multiple properties can be specified and are loaded before application execution.

#### Syntax and Usage
```bash
# Single system property
java -DpropertyName=value ClassName

# Multiple properties  
java -Dproperty1=value1 -Dproperty2=value2 ClassName
```

**Property Name/Value Rules:**
- Property names are separated from values by `=` (equals sign)
- Values containing spaces must be quoted
- Multiple properties use separate `-D` flags

```bash
# Example with spaces and multiple properties
java -Duser.name="John Doe" -Dapp.version="2.0" MyApp
```

#### Internal Processing
1. JVM parses `-D` arguments at startup
2. Properties are stored in System Properties object before `main()` execution
3. Properties remain accessible throughout JVM lifetime  
4. Not available for modification within application (read-only at runtime)

```java
// Application reads properties set via -D
public class MyApp {
    public static void main(String[] args) {
        String userName = System.getProperty("user.name");
        String appVersion = System.getProperty("app.version");
        
        System.out.println("User: " + userName);
        System.out.println("Version: " + appVersion);
    }
}
```

**❗ IMPORTANT**
> Priority rules when same property is set both programmatically and via `-D`:
> - Programmatic `System.setProperty()` takes precedence over `-D` values
> - Last set value wins (either method)
> - Command-line and program settings should not conflict

## Lab Demos

### Demo 1: Accessing All System Properties
```java:Displaying_System_Properties.java
import java.util.Enumeration;
import java.util.Properties;

public class Displaying_System_Properties {
    public static void main(String[] args) {
        Properties p1 = System.getProperties();
        Enumeration<?> names = p1.propertyNames();
        
        while (names.hasMoreElements()) {
            String name = (String) names.nextElement();
            String value = p1.getProperty(name);
            System.out.println(name + ": " + value);
        }
    }
}

// Output: Displays all JVM and OS properties like os.name, java.version, etc.
```

### Demo 2: Reading Specific OS Properties
```java:Reading_OS_Properties.java
import java.util.Enumeration;
import java.util.Properties;

public class Reading_OS_Properties {
    public static void main(String[] args) {
        System.setProperty("123", "pqr"); // Custom property
        
        // Reading operating system
        String osName = System.getProperty("os.name");
        System.out.println("OS Name: " + osName);
        
        // Reading custom property
        String customValue = System.getProperty("123");
        System.out.println("Custom Property: " + customValue);
        
        // Checking all properties include the custom one
        Properties p1 = System.getProperties();
        Enumeration<?> names = p1.propertyNames();
        
        while (names.hasMoreElements()) {
            String name = (String) names.nextElement();
            if (name.equals("123")) {
                String value = p1.getProperty(name);
                System.out.println("Found custom property: " + name + " = " + value);
                break;
            }
        }
    }
}

// Output: Shows OS and custom properties
```

### Demo 3: Runtime Configuration with -D Option
```java:RuntimeConfigDemo.java
public class RuntimeConfigDemo {
    public static void main(String[] args) {
        // Properties set via -D at command line
        String firstNumber = System.getProperty("FN");
        String secondNumber = System.getProperty("SN");
        
        // Convert to integers for calculation
        int num1 = Integer.parseInt(firstNumber);
        int num2 = Integer.parseInt(secondNumber);
        
        System.out.println("Sum: " + (num1 + num2));
    }
}

// Compile: javac RuntimeConfigDemo.java
// Run with properties: java -DFN=10 -DSN=20 RuntimeConfigDemo
// Output: Sum: 30
```

### Demo 4: OS-Specific Logic Implementation
```java:OS_Specific_Logic.java
public class OS_Specific_Logic {
    public static void main(String[] args) {
        String osName = System.getProperty("os.name").toLowerCase();
        
        if (osName.contains("windows")) {
            System.out.println("************ Windows OS ************");
        } else if (osName.contains("linux")) {
            System.out.println("$$$$$$$$$$$$ Linux OS $$$$$$$$$$$$");
        } else {
            System.out.println("Unknown OS");
        }
        
        // Demonstrating JVM-level storage
        System.setProperty("123", "pqr");
    }
}
// In another class:
public class AnotherClass {
    public void accessSharedProperty() {
        String value = System.getProperty("123"); // Can access "pqr"
        System.out.println("Shared value: " + value);
    }
}
```

## Project Implementation

### Employee Management System with Mixed Input Approaches

This project demonstrates reading employee data using different runtime input approaches: command line arguments, BufferedReader, Scanner, and system properties.

```java:Employee.java
// Employee.java
public class Employee {
    private int empno;
    private String ename;
    private double salary;
    private String department;
    private long mobile;
    private String email;
    private char gender;
    private boolean workingStatus;
    
    // Constructor
    public Employee(int empno, String ename, double salary, String department, 
                   long mobile, String email, char gender, boolean workingStatus) {
        this.empno = empno;
        this.ename = ename;
        this.salary = salary;
        this.department = department;
        this.mobile = mobile;
        this.email = email;
        this.gender = gender;
        this.workingStatus = workingStatus;
    }
    
    // Display method
    public void display() {
        System.out.println("Employee Number: " + empno);
        System.out.println("Employee Name: " + ename);
        System.out.println("Salary: " + salary);
        System.out.println("Department: " + department);
        System.out.println("Mobile: " + mobile);
        System.out.println("Email: " + email);
        System.out.println("Gender: " + gender);
        System.out.println("Working Status: " + workingStatus);
    }
    
    // Getters
    public int getEmpno() { return empno; }
    public String getEname() { return ename; }
    public double getSalary() { return salary; }
    public String getDepartment() { return department; }
    public long getMobile() { return mobile; }
    public String getEmail() { return email; }
    public char getGender() { return gender; }
    public boolean isWorkingStatus() { return workingStatus; }
}
```

```java:Company.java
// Company.java
import java.io.*;
import java.util.Scanner;

public class Company {
    public static void main(String[] args) {
        try {
            // Create Employee object
            Employee emp = null;
            
            // 1. Command Line Arguments: empno, ename
            int empno = Integer.parseInt(args[0]);
            String ename = args[1];
            
            // 2. BufferedReader: salary, department
            BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
            System.out.print("Enter salary: ");
            double salary = Double.parseDouble(br.readLine());
            System.out.print("Enter department: ");
            String department = br.readLine();
            
            // 3. Scanner: mobile, email
            Scanner sc = new Scanner(System.in);
            System.out.print("Enter mobile number: ");
            long mobile = sc.nextLong();
            // Handle next line issue
            sc.nextLine();
            System.out.print("Enter email: ");
            String email = sc.nextLine();
            
            // 4. System Properties: gender, workingStatus
            char gender = System.getProperty("gender").charAt(0);
            boolean workingStatus = Boolean.parseBoolean(System.getProperty("status"));
            
            // Create Employee object
            emp = new Employee(empno, ename, salary, department, mobile, email, gender, workingStatus);
            
            // Display employee details
            emp.display();
            
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
```

**Sample Execution:**
```bash
# Compile both classes
javac Employee.java Company.java

# Run with system properties and command line arguments
java -Dgender=M -Dstatus=true Company 101 "John Doe"
# Then provide inputs:
# Enter salary: 50000
# Enter department: IT
# Enter mobile number: 9876543210
# Enter email: john.doe@example.com
```

## Summary

### Key Takeaways
```diff
+ System properties provide JVM-level configuration accessible to all classes
+ Predefined OS properties are automatically loaded at JVM startup
+ Custom properties can be set for application-wide sharing
+ -D command-line option enables runtime property configuration
+ Properties are stored as String key-value pairs in Properties object
+ System properties are static (persist during JVM lifetime only)
+ Command-line properties take precedence over programmatic settings
```

### Expert Insight

#### Real-world Application
System properties are commonly used in enterprise applications for environment-specific configuration. For instance, Spring Boot applications use `-D` options extensively to override default configurations without code changes:

```bash
java -Dspring.profiles.active=production -Dserver.port=8080 -jar app.jar
```

In distributed systems, system properties can hold cluster-specific information or temporary runtime adjustments without redeployment.

#### Expert Path
Master system properties by understanding the PropertySource hierarchy in frameworks like Spring. Advanced techniques include:
- Custom PropertySource implementations for dynamic configuration
- Property overriding strategies in multi-module applications
- Security considerations when handling sensitive properties
- Performance implications of property lookups in high-throughput systems

#### Common Pitfalls
Programs will throw `NullPointerException` when accessing undefined properties. Always check for `null` before using property values:

```java
String config = System.getProperty("my.config");
if (config == null) {
    config = "default_value"; // Provide fallback
}
```

**Property name conflicts** can occur when multiple modules set the same property name. Use prefixed naming conventions like `app.module.config` to avoid collisions.

**Thread safety** is already handled by the Properties class, but remember that property modifications affect all threads in the JVM.

**Performance considerations**: Property lookups are fast but frequent access in tight loops should use local variables to cache values.
