# Session 53: OOPs 2

- [Overview](#overview)
- [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
  - [Completing Steps to Create Real World Objects](#completing-steps-to-create-real-world-objects)
  - [OOP Abbreviation and Definitions](#oop-abbreviation-and-definitions)
  - [What Objects Contain](#what-objects-contain)
  - [Object vs. Instance Definitions](#object-vs-instance-definitions)
  - [Variables and Types of Variables in OOP](#variables-and-types-of-variables-in-oop)
    - [Static vs. Non-Static Variables](#static-vs-non-static-variables)
    - [Project Example: Bank Account](#project-example-bank-account)
  - [Developing Real World Object Creation](#developing-real-world-object-creation)

## Overview

This session completes the foundational concepts of Object Oriented Programming (OOP), continuing from the previous session on OOP Basics. It focuses on practical implementation of creating real-world objects in Java, emphasizing the transition from theoretical concepts to code development. The session bridges OOP theory with Java programming elements, demonstrating how to structure classes, variables, and instances to represent real-world entities like bank accounts through hands-on examples.

## Key Concepts and Deep Dive

### Completing Steps to Create Real World Objects

**Theoretical Foundation:**
- OOP enables creating real-world object representations in programming by achieving security and dynamic binding
- Programs are designed around individual objects and their data, ensuring operations perform automatically in the computer environment
- Real-world objects must translate to programming constructs to perform database operations and business logic

**Programming Elements Used:**
- Eight core programming elements: class, instance variables, static variables, blocks, constructors, methods
- Focus on practicing class, variables, and methods for object creation
- C vs. Java comparison: C focuses on functions/formulas, Java focuses on objects and data

### OOP Abbreviation and Definitions

**OOP Term:**
- OOP = Object Oriented Programming
- Technique/methodology for creating real-world objects in programming with security and dynamic binding
- Paradigm providing suggestions for developing applications that perform operations automatically

**Why OOP Matters:**
- Develops real-world business applications in programming world
- Focuses on automatic operation performance through software
- Creates real-world objects by achieving data security and dynamic binding between objects

**Programming Differences:**
- C language: Program developed around one function/formula
- Java language: Program developed around one object and its data

### What Objects Contain

**Object Components:**
- **Type**: Class definition representing object category
- **Structure**: Physical arrangement and relationships
- **State**: Current values/data of the object
- **Behavior**: Operations the object can perform
- **Instances**: Individual objects representing specific real-world entities

**Programming Elements Mapping:**
- **Class** (keyword `class`): Represents type and structure
- **Variables** (data types): Represent state storage
- **Methods**: Represent behaviors and operations
- **Keyword `new`**: Creates individual instances

**Full Programming Structure:**
1. Define object type (class creation)
2. Declare individual objects within that type
3. Create variables for value representation
4. Define methods for behavior operations
5. Use `new` keyword for instance creation

**Object Hierarchy Consideration:**
- Project contains multiple objects at different levels
- Type represents object category (e.g., vehicle)
- Structure shows how objects are arranged
- Individual instances represent unique objects (e.g., bus, car, bike)

### Object vs. Instance Definitions

**Object Definition:**
- Real-world thing that is an instance of a class
- Contains complete memory with all variables (both static and non-static)
- Includes common values and individual-specific values
- Full representation of object data and behavior

**Instance Definition:**
- One copy of memory created from a class
- Represents one individual object physically
- Stores particular object values specific to that instance
- Contains only individual object data (non-static variables)

**Class Definition (4 Definitions):**
1. User-defined data type allowing multiple values of same/different types per object
2. Blueprint/design document specifying object structure and operations
3. Template/logical construct of object providing look and feel
4. Specification defining object type, properties, and operations via variables/methods

### Variables and Types of Variables in OOP

#### Static vs. Non-Static Variables

**Variable Classification:**
- Java supports 4 types: static, non-static (instance), parameter, local
- Class-level variables: static and non-static (created inside class)
- Method-level variables: parameter and local (created inside methods)

**Static Variables:**
- One copy memory common to all objects
- Store values shared across all instances
- Initialize common properties (e.g., bank name, branch name)
- Access via class name (preferred for initialization) or object reference

**Non-Static Variables:**
- Separate memory copy in each object
- Store individual object-specific values
- Initialize per-instance properties (e.g., account holder name, balance)

#### Project Example: Bank Account

**Problem Context:**
Multiple customers opening bank accounts with common and individual details:
- Common values: Bank name, Branch name, IFSC code
- Individual values: Account number, Account holder name, Balance

**Variable Declaration Strategy:**
```java
class BankAccount {
    // Static variables (common to all accounts)
    static String bankName;
    static String branchName; 
    static String ifsc;
    
    // Non-static variables (individual per account)
    long accountNumber;
    String accountHolderName;
    double balance;
}
```

### Developing Real World Object Creation

**Project Structure:**
- **Minimum 2 Classes Required:**
  1. `BankAccount` (business logic class defining object structure)
  2. `College` or `Main` (user interface class with main method)

- **Implementation Steps:**
  1. Declare variables in Business Logic class
  2. Categorize variables as static/non-static based on commonality
  3. Create instances using `new` keyword
  4. Initialize static variables with common values
  5. Initialize instance variables with individual values
  6. Perform object operations by calling methods
  7. Compile and execute main class

**Code Implementation:**
```java
// Business Logic Class - BankAccount.java
class BankAccount {
    // Static variables for common data
    static String bankName;
    static String branchName; 
    static String ifsc;
    
    // Instance variables for individual data
    long accountNumber;
    String accountHolderName;
    double balance;
}
```

```java
// User Interface/Execution Class - College.java
class College {
    public static void main(String[] args) {
        // Initialize static fields (common to all accounts)
        BankAccount.bankName = "HDFC";
        BankAccount.branchName = "Amirpet"; 
        BankAccount.ifsc = "HD123AM";
        
        // Create instances for individual customers
        BankAccount account1 = new BankAccount(); // HK account
        BankAccount account2 = new BankAccount(); // BK account
        
        // Initialize HK account details
        account1.accountNumber = 1234;
        account1.accountHolderName = "HK";
        account1.balance = 50000;
        
        // Initialize BK account details  
        account2.accountNumber = 5678;
        account2.accountHolderName = "BK";
        account2.balance = 70000;
        
        // Display account details
        System.out.println("=== Static Fields Initialized ===");
        System.out.println("Instances created for HK and BK objects");
        System.out.println("account1 instance initialized with HK object values");
        System.out.println("account2 instance initialized with BK object values");
        
        // Print passbook-style output for HK account
        System.out.println("========================================================");
        System.out.println("Bank Name: " + account1.bankName);
        System.out.println("Branch Name: " + account1.branchName);
        System.out.println("IFSC: " + account1.ifsc);
        System.out.println("Account Number: " + account1.accountNumber);
        System.out.println("Account Holder Name: " + account1.accountHolderName);
        System.out.println("Balance: " + account1.balance);
        
        // Print passbook-style output for BK account
        System.out.println("========================================================");
        System.out.println("Bank Name: " + account2.bankName);
        System.out.println("Branch Name: " + account2.branchName);
        System.out.println("IFSC: " + account2.ifsc);
        System.out.println("Account Number: " + account2.accountNumber);
        System.out.println("Account Holder Name: " + account2.accountHolderName);
        System.out.println("Balance: " + account2.balance);
    }
}
```

## Summary

### Key Takeaways
```diff
+ Object Oriented Programming creates real-world objects in programming with security and dynamic binding
+ Objects contain type, structure, state, behavior, and instances - implemented via classes and variables
+ Class is a blueprint/design template; instance is individual object memory copy
+ Static variables = one copy memory for common values; non-static variables = separate memory per object
+ Real-world objects like bank accounts must categorize variables into common (static) and individual (non-static)
+ Object creation follows: Design class → Categorize variables → Create instances → Initialize → Perform operations
```

### Expert Insight

#### Real-world Application
Static and non-static variable classification enables efficient memory usage in enterprise applications:
- **Banking Systems**: Branch details (bank name, IFSC) as static variables across all accounts
- **E-commerce Platforms**: Product categories as static, individual product details as non-static instances
- **Student Management Systems**: University details as static, individual student records as non-static
- **Performance Optimization**: Reduces memory footprint by avoiding duplicate common values across instances

#### Expert Path
> [!IMPORTANT]
> Master OOP fundamentals through memory visualization: Class as blueprint, static as shared memory region, instances as individual object copies.

**Progressive Learning Track:**
1. **Beginner**: Understand object vs. instance conceptually
2. **Intermediate**: Implement classification logic for variables in domain models
3. **Advanced**: Design scalable architectures with minimal memory duplication
4. **Expert**: Optimize enterprise applications with proper static/non-static strategies

**Required Practice:**
- Visualize memory layouts diagrammatically for each object creation
- Implement real-world examples (bank accounts, students, employees) with proper classification
- Practice variable initialization patterns (class name for static, object reference for non-static)

#### Common Pitfalls
**Misclassifying Variables as Static:**
- Symptom: All objects sharing mutable data incorrectly (e.g., all customer balances changing together)
- Cause: Marking individual-specific variables as static
- Resolution: Analyze business requirements - if value varies per object instance, use non-static
- Prevention: Draw object memory diagrams before coding to verify classification

**Incorrect Initialization Patterns:**
- Symptom: Runtime NullPointerException or uninitialized values
- Cause: Initializing static variables via object reference (gives wrong semantic meaning)
- Resolution: Always initialize static variables using class name for clarity
- Prevention: Follow convention: static access via class name, non-static via object reference

**Memory Inefficiency from Over-Static Declaration:**
- Symptom: Higher memory usage than necessary
- Cause: Declaring truly individual variables as static to avoid "duplication"
- Resolution: Identify genuinely common vs. coincidentally-same values
- Prevention: Use business analysis - static only for truly unchanging common values

**Confusion Between Object and Instance:**
- Symptom: Incorrect usage in conversations/documentation
- Cause: Not understanding the distinction between complete object (with all variables) and raw memory copy
- Resolution: Object = complete real-world entity with all data; Instance = just the allocated memory before values

**Lesser Known Things About OOP Variables:**
- Static variables belong to class loader, not class instances (persisted across object lifecycles)
- Final static variables become compile-time constants (value inlined by JVM)
- Static initialization blocks run only once when class loads, before any instances created
- Non-static variables consume memory per object instance vs. static variables once per class
- Variable classification directly affects serialization patterns in distributed systems
