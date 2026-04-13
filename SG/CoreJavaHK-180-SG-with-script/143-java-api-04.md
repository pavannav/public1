# Session 143: JAVA API 04

## Table of Contents
- [Non-Static Blocks](#non-static-blocks)
- [Object Counting](#object-counting)
- [Person Class Development](#person-class-development)
- [Student Inheritance](#student-inheritance)
- [Constructors in Inheritance](#constructors-in-inheritance)
- [Eclipse Code Generation Shortcuts](#eclipse-code-generation-shortcuts)
- [Overriding Methods](#overriding-methods)
- [Main Class with Scanner Input](#main-class-with-scanner-input)
- [Importing and Package Organization](#importing-and-package-organization)
- [Enhancing the Project with Address Class](#enhancing-the-project-with-address-class)
- [Handling Null Values in toString](#handling-null-values-in-tostring)
- [Performing Student Object Operations](#performing-student-object-operations)
- [API Documentation (Javadoc)](#api-documentation-javadoc)
- [Generating JAR Files and Project Export](#generating-jar-files-and-project-export)
- [Summary](#summary)

## Non-Static Blocks
Non-static blocks (also called instance blocks) execute each time an instance of the class is created. They are used when multiple constructors exist and they share common logic that needs to be executed regardless of which constructor is called.

### Purpose
- Common Logic Initialization: Define common code for object initialization across different constructors.
- Object Counting: Increment counters each time an object is created.

### Example Implementation
```java
public class Person {
    // Common instance block for initialization
    {
        // Common logic here
        System.out.println("Object initialization");
    }
}
```

## Object Counting
Use static fields to count the number of objects created across all instances of a class.

### Implementation
- Declare a static variable for counting.
- Increment in constructor or instance block.
- Provide a getter method to retrieve the count.

### Code Example
```java
public class Person {
    private static int count = 0;
    
    {
        count++;
    }
    
    public static int getCount() {
        return count;
    }
}
```

## Person Class Development
Develop a Person class representing real-world entities with properties and behaviors.

### Properties
- `private String name`
- `private double height`
- `private int weight`
- `private char gender`
- `private long mobile`
- `private String email`
- `private boolean living`

### Methods
- Constructors: Parameterized constructor for initialization
- Business Operations: `eat()`, `sleep()`
- Getters and Setters: For accessing and modifying properties
- `toString()`: For object representation

### Lab Demo: Creating Person Class in Eclipse
1. Create new Java project in Eclipse.
2. Create `Person` class with the above properties and methods.
3. Generate constructors, getters/setters, and `toString()` using Eclipse shortcuts.
4. Add business methods:
   ```java
   public void eat() {
       System.out.println(name + " is eating");
   }
   
   public void sleep() {
       System.out.println(name + " is sleeping");
   }
   ```

## Student Inheritance
Create a `Student` subclass that inherits from `Person` to add student-specific properties.

### Additional Properties
- `private String collegeName`
- `private static int studentNumber`
- `private String course`
- `private double fee`

### Inheritance Benefits
- Reuse parent class properties and methods
- Extend functionality with subclass-specific features
- Polymorphism support

### Lab Demo: Creating Student Class
1. Right-click package → New → Class
2. Name: `Student`
3. Superclass: `Person` (browse and select)
4. Add student properties as private fields
5. Generate constructor using `Alt+Shift+S → O` → Select superclass constructor
6. Generate getters/setters using `Alt+Shift+S → R`
7. Generate `toString()` using `Alt+Shift+S → S`

## Constructors in Inheritance
When creating subclass objects, the superclass constructor must be called explicitly or implicitly.

### Key Rules
- If superclass has a parameterized constructor, subclass constructors must call `super()` with required parameters.
- If superclass has a no-argument constructor, `super()` is called implicitly.
- Failure to call `super()` results in compilation error.

### Code Example
```java
public class Student extends Person {
    public Student(String name, double height, int weight, char gender,
                   boolean living, int studentNumber, String course, double fee) {
        super(name, height, weight, gender, living); // Call super constructor
        this.studentNumber = studentNumber;
        this.course = course;
        this.fee = fee;
    }
}
```

## Eclipse Code Generation Shortcuts
Eclipse provides shortcuts for generating boilerplate code to speed up development.

### Key Shortcuts
- **Constructor**: `Alt+Shift+S → O`
  - Generate constructor using fields
  - Select superclass constructor invocation and fields
- **Getters/Setters**: `Alt+Shift+S → R`
  - Generate getters and setters for selected fields
- **toString()**: `Alt+Shift+S → S`
  - Generate toString() method with field selection
- **Import Organization**: `Ctrl+Shift+O` (adds missing imports and organizes)

### Lab Demo: Using Code Generation
1. In Student class, use `Alt+Shift+S → O` to generate constructor
2. Use `Alt+Shift+S → R` to generate getters/setters
3. Use `Alt+Shift+S → S` to generate `toString()` (add `super.toString() + ...`)

## Overriding Methods
Override parent class methods to provide subclass-specific implementations while maintaining the same method signature.

### Rules
- Method signature must match exactly (name, parameters, return type)
- Use `@Override` annotation (automatically added by Eclipse)
- Call `super.methodName()` to execute parent functionality first

### Code Example
```java
@Override
public void eat() {
    super.eat(); // Call parent eat()
    System.out.println(getName() + " is eating chicken biryani");
}
```

## Main Class with Scanner Input
Create a main class to test the Student class by creating objects and reading input dynamically.

### Components
- `Scanner` for reading user input
- Object creation and initialization
- Input validation and processing

### Lab Demo: College Class with Scanner
1. Create `College` class with main method
2. Import `java.util.Scanner`
3. Create Scanner instance
4. Read inputs in order: student details, personal details, address details
5. Create Student object and set remaining properties
6. Display student information

```java
Scanner scn = new Scanner(System.in);
// Read inputs...
Student s1 = new Student(name, height, weight, gender, true, studentNumber, course, fee);
// Set additional properties...
System.out.println(s1);
```

## Importing and Package Organization
Eclipse automatically manages imports and package organization.

### Process
- Use `Ctrl+Shift+O` to organize imports after using external classes
- Eclipse suggests imports when encountering unknown types
- Imports appear at the top of the file

```java
import java.util.Scanner; // Added automatically
```

## Enhancing the Project with Address Class
Add an Address class as a separate entity and integrate it into Person class.

### Address Class Design
- `private int streetNumber`
- `private String city`
- Separate getters/setters and `toString()`

### Integration
- Add `Address address` field to Person
- Generate setter for Address in Person
- Initialize Address object separately and assign via setter

### Lab Demo: Adding Address
1. Create Address class (outer class, not inner)
2. Add properties and generate methods
3. In Person class, add `Address address` field
4. Generate setter using `Alt+Shift+S → R`
5. Modify `toString()` to include address
6. In College main method, create Address object and set via `setAddress()`

## Handling Null Values in toString
Handle null references in toString to avoid NullPointerException.

### Issue
- If address is not initialized, calling `address.toString()` throws NullPointerException

### Solutions
- Check for null before method call
- Use conditional in toString: `address != null ? address.toString() : null`
- Operator (+) automatically handles null by appending "null" string

## Performing Student Object Operations
Demonstrate method calls on Student objects, showing inheritance and polymorphism.

### Operations
- Call inherited methods (eat, sleep)
- Call overridden methods
- Call generated methods from subclasses

```java
s1.eat();      // Shows both parent and child eat implementations
s1.sleep();    // Shows child sleep implementation
s1.listen();   // Child-specific method
```

## API Documentation (Javadoc)
Generate professional documentation using Javadoc comments and Eclipse tools.

### Writing Comments
```java
/**
 * This class represents a real-world person in the programming world.
 * It contains all required fields, constructors, and methods to store
 * and represent each individual person by storing their values.
 * 
 * @author HK
 * @version 1.0
 * @since 1.0
 */
public class Person {
    /** Static fields to store common values */
    private static int count;
    
    /** Instance fields to store individual values */
    private String name;
    
    /**
     * Constructor to create a Person object with specified parameters.
     * @param name The person's name
     * @param height The person's height
     * @param weight The person's weight
     * @param gender The person's gender
     * @param living Living status
     */
    public Person(String name, double height, int weight, char gender, boolean living) {
        // implementation
    }
}
```

### Generating Documentation
1. Project → Generate Javadoc
2. Select JDK javadoc.exe path
3. Choose destination folder
4. Configure visibility (public + protected)
5. Set documentation title
6. Generate

## Generating JAR Files and Project Export
Package the project into distributable formats for sharing or deployment.

### JAR File Creation
1. Right-click project → Export
2. Select Java → JAR file
3. Choose export options:
   - Export generated class files and resources
   - Export Java source files (optional)
   - Select main class for executable JAR
4. Choose destination and manifest options

### Export Archive
1. Export → General → Archive File
2. Include doc folder for documentation
3. Choose format (ZIP/GZ)
4. Create directory structure

### Lab Demo: Creating JAR and Archive
1. Export project as JAR (executable with College as main class)
2. Export docs folder as ZIP archive
3. Verify generated files contain appropriate content

## Summary

### Key Takeaways
```diff
+ Eclipse IDE significantly speeds up Java development with code generation shortcuts
+ Inheritance in Java requires careful constructor design with super() calls
+ Non-static blocks enable common initialization logic across constructors
+ Static fields maintain shared state across all objects of a class
+ Scanner provides flexible input reading for dynamic program testing
+ Javadoc comments create professional API documentation
+ Overriding methods allows subclass-specific behavior while extending parent functionality
+ JAR files package applications for distribution and deployment
```

### Expert Insight

#### Real-world Application
Enterprise Java applications heavily use inheritance hierarchies and Eclipse's productivity features. Modern IDEs like Eclipse, IntelliJ, and VS Code with extensions automate much of the boilerplate code generation shown here. Companies build complex systems by creating base classes with common functionality and subclassing for specific business needs, just like extending Person to Student.

#### Expert Path
Master design patterns like Factory, Builder, and Decorator that build on inheritance concepts. Study Maven/Gradle for automated build processes replacing manual JAR creation. Focus on Spring Framework for dependency injection, which eliminates much of the manual object wiring shown here.

#### Common Pitfalls
- Forgetting super() calls in subclass constructors leads to compilation failures
- Null pointer exceptions when accessing uninitialized referenced objects in toString()
- Not organizing imports regularly leads to confusing error messages
- Incorrect method overriding signatures prevent polymorphism from working as expected

Mistakes found in transcript:
- "Con non block" should be "non-static block"
- "clips" seems to be a misrecording of "class"
- "Streetnumber" should be "streetNumber"
- "comnit" should be "com.nit" (package naming)
- "commentators" should be "comments" 
- "two string method" should be "toString method"
- "Reply to" in methods should be "replying to"
- "personal details1" should be "personal details"
- "CJ 3000 2500" contains repeated values in the example output

*Note:* No URLs or external references were used. Content based solely on transcript.
