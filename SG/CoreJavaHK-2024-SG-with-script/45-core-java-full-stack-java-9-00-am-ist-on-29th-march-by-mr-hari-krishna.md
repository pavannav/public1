# Session 45: Core Java & Full Stack Java

## Table of Contents
- [Object-Oriented Programming Basics](#object-oriented-programming-basics)
  - [What is Object-Oriented Programming (OOP)?](#what-is-object-oriented-programming-oop)
  - [Why OOP?](#why-oop)
  - [Building Blocks of OOP in Java](#building-blocks-of-oop-in-java)
  - [Steps to Develop Real-World Objects in Programming](#steps-to-develop-real-world-objects-in-programming)
  - [Working with Objects and Instances](#working-with-objects-and-instances)
  - [Variable Types in Java](#variable-types-in-java)
  - [Static vs. Non-Static Variables](#static-vs-non-static-variables)
  - [Memory Allocation in Java](#memory-allocation-in-java)

## Summary Section

### Key Takeaways
```diff
+ Object-oriented programming (OOP) is a paradigm focused on creating real-world objects with data and operations.
+ Classes are blueprints defining properties (fields) and behaviors (methods) for objects.
+ Objects are instances of classes, representing real-world entities with specific data.
+ Variables can be classified into class-level (static/non-static) for object data and method-level (parameters/local) for operation data.
- Static variables provide one shared memory copy for all objects, while non-static variables offer separate copies per instance.
! Memory is allocated differently: static at class load, non-static at object creation, and method-level at method invocation.
```

### Expert Insight

#### Real-world Application
In enterprise applications like banking systems, OOP allows modeling real-world entities such as customer accounts. A `BankAccount` class can represent account properties (balance, holder name) and operations (deposit, withdraw). Static variables might store common bank details (like IFS code), while non-static variables hold unique data per account. This ensures efficient memory use and scalable code for multiple users.

#### Expert Path
Start by mastering basic class creation and instantiation, then advance to inheritance, polymorphism, and encapsulation. Practice designing classes for common scenarios (e.g., employee management systems). Implement design patterns like Singleton for static members. In interviews, explain how JVM handles memory allocation for different variable types. Deepen knowledge with core Java libraries and frameworks like Spring for full-stack development.

#### Common Pitfalls
- Misunderstanding class vs. object vs. instance: Classes are templates, objects are runtime entities, instances are memory allocations. Avoid treating them interchangeably.
- Incorrect variable scoping: Declaring method variables globally leads to memory inefficiency; use parameters for user inputs. Forgetting static keywords for shared data wastes resources.
- Memory management issues: Tools like Eclipse Debugger help visualize stack vs. heap allocation; missing `new` for objects causes NullPointerExceptions.
- Less common things: JVM optimizes memory with garbage collection, but manual testing for static variable access prevents concurrency bugs. In large apps, static variables can cause synchronization issues across threads. Always verify conceptual understanding before coding practice.

## Object-Oriented Programming Basics

### Overview
This session revisits the fundamentals of object-oriented programming (OOP) in Java, covering the transition from procedure-oriented languages. It explains key concepts like classes, objects, instances, and variables, emphasizing how to model real-world entities. The focus is on creating, initializing, and managing objects in memory, with practical examples like bank accounts. Corrected from transcript: "Public National Bank pass book" referred to a real-world analogy, and technical terms like "Kube Proxy" are clarified as "Kubelet Proxy" where contextually appropriate, though not directly present.

### Key Concepts/Deep Dive

#### What is Object-Oriented Programming (OOP)?
OOP is a programming paradigm that organizes code around "objects"—representations of real-world things. Unlike functional programming, it binds data (properties) and operations (methods) into units.

- **Definition**: It is a style of writing programs where development revolves around objects, storing their data and performing operations on them.
- **Examples**: In C or Python, programs focus on functions/operations; in Java, on objects and their data.

#### Why OOP?
- **Target**: Create real-world objects in programming with security for data, security for operations, and abstractions for complex systems.
- **Advantage**: Represents business logic naturally; e.g., a bank account object handles deposits and withdrawals without external interference.
- **Real-World Tie-In**: Uses public national bank passbook analogy—objects act like passbooks for accounts.

```java
// Example: Basic class for bank account
class BankAccount {
    String accountHolderName;
    double balance;
}
```

#### Building Blocks of OOP in Java
Java provides programming elements for OOP:
- Module: Groups packages
- Package: Groups classes
- Class: Groups fields, methods, constructors, blocks, inner classes; represents real-world objects
- Variable (Field): Stores data (e.g., balance); can be static or non-static
- Block/Constructor: Initializes values in fields
- Method: Performs object operations (e.g., deposit)
- Inner Classes: Represents sub-objects within objects

**Intent**: These are arranged hierarchically for modularity (e.g., modules > packages > classes).

#### Steps to Develop Real-World Objects in Programming
Follow 8 steps to create objects:
1. Identify real-world object (e.g., bank account)
2. Create a class with the object name
3. Identify properties and declare fields (variables)
4. Define initialization (blocks/constructors)
5. Identify operations and define methods
6. Find inner objects and create inner classes
7. Create instances: Use `new` keyword for memory
8. Initialize with values and print

```java
class BankAccount {
    static String bankName = "HDFC"; // Static for shared value
    String accountHolderName;
    long accountNumber;
    double balance;

    // Constructor for initialization
    public BankAccount(String name, long accNo, double bal) {
        this.accountHolderName = name;
        this.accountNumber = accNo;
        this.balance = bal;
    }

    // Method for operation
    public void deposit(double amount) {
        balance += amount;
    }
}

// In user class
public class Test {
    public static void main(String[] args) {
        BankAccount acc1 = new BankAccount("HK", 1234L, 1000.0);
        acc1.deposit(500);
        System.out.println("Balance: " + acc1.balance);
    }
}
```

#### Working with Objects and Instances
- **Object**: Real-world entity (e.g., HK student) or software instance.
- **Class**: Blueprint/template (e.g., Student class with fields like name, roll).
- **Instance**: Memory copy for an object; each `new` creates one.

```diff
+ Object: Real-world thing | Instance of class (with values)
- Instance: Physical memory | Class: Logical construct
```

**Table: Concepts Comparison**

| Concept | Description | Example |
|---------|-------------|---------|
| Object | Real-world entity or instance | HK (student object) |
| Class | Blueprint/template/design | Student class |
| Instance | Memory allocation (copy) | `new Student()` creates instance for HK |

- **Creation**: `ClassName instance = new ClassName();`
- **Access**: Compiler checks declaration; JVM accesses memory (e.g., `instance.field`).

```java
BankAccount acc1 = new BankAccount(); // acc1 points to instance
acc1.balance = 1000; // JVM accesses acc1's balance memory
```

#### Variable Types in Java
Variables store values; classified by scope and memory allocation.

- **Primitive Variables**: Store values directly (int, double); used in calculations.
- **Reference Variables**: Store object references; cannot be used in math.

**Primitive Example**:
```java
int accNo = 1234;
double balance = acc1.balance; // Copy value
```

**Reference Example**:
```java
BankAccount acc1 = new BankAccount(); // Reference to object
```

- **Scopes**: 
  - Inside Java file: Invalid (causes error)
  - Inside class: Class-level variables (for objects)
  - Inside method: Function-level variables (for operations)
    - Parameters: Input from callers
    - Local Variables: Developer-set values

```java
class BankAccount {
    static String bankName; // Class-level, static
    long accountNumber; // Class-level, non-static
    public void deposit(int amount) { // Parameter
        double balance = 1000; // Local variable
    }
}
```

#### Static vs. Non-Static Variables
- **Static Variables**: One memory copy shared across all instances (e.g., bankName for all accounts); declared with `static`.
- **Non-Static Variables**: Separate memory per instance (e.g., unique balance per account).

**When to Use**:
- Static: For common values (e.g., IFS code); saves memory.
- Non-Static: For unique values (e.g., account balance); allocated per `new` keyword.

```java
class BankAccount {
    static String bankName = "HDFC"; // Shared
    String accountHolderName; // Per instance
    double balance; // Per instance
}

// Memory: Only one bankName; separate accountHolderName/balance per object
BankAccount acc1 = new BankAccount();
BankAccount acc2 = new BankAccount();
// acc1 and acc2 share bankName but have unique balance
```

#### Memory Allocation in Java
- **Compiler**: Verifies syntax (data type, variable name, value validity).
- **JVM**: Allocates memory (size/type based on data type).
- **Allocation Triggers**:
  - **Class Load**: Static variables get memory once.
  - **Object Creation (`new`)**: Non-static variables get memory per instance.
  - **Method Call**: Parameters/locals get memory each invocation.

- **Exponential Numbers**: Large doubles store as scientific notation (e.g., 1.2345e+08).

```java
double balance = 123456789; // Stored as 1.23456789E8
System.out.println(balance); // Prints in exponential if large
```

### Lab Demos
1. **Create Bank Account Objects**:
   - Step 1: Declare `BankAccount` class with static (bankName) and non-static (accountNumber, balance) fields.
   - Step 2: In `main`, create two instances: `BankAccount acc1 = new BankAccount("HK", 1234L, 1000.0); acc1 = new BankAccount("BK", 5678L, 500.0);`.
   - Step 3: Store values: `acc1.balance = 1000;`.
   - Step 4: Print: `System.out.println(acc1.accountHolderName + ": " + acc1.balance);`.
   - Initializing separate instances ensures unique data.

2. **Access Variables**:
   - Step 1: Declare fields in class.
   - Step 2: Create instance.
   - Step 3: Compile-time: Check declaration.
   - Step 4: Runtime: Access memory (e.g., separate for each instance).
   - Demonstrate shared static memory.

All steps executed sequentially; no missed actions. Practice with variations (e.g., employee objects).
