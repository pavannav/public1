# Session 51: Java Methods - Types and Implementation

## Table of Contents
- [Overview](#overview)
- [Static vs Non-Static Methods](#static-vs-non-static-methods)
- [Private vs Non-Private Methods](#private-vs-non-private-methods)
- [Void vs Non-Void Methods](#void-vs-non-void-methods)
- [Practical Example: Bank Account Application](#practical-example-bank-account-application)
- [Summary](#summary)

## Overview

In object-oriented programming, methods are fundamental building blocks that encapsulate logic and perform operations. This session explores different types of methods in Java, their characteristics, usage patterns, and implementation considerations.

### Key Method Fundamentals
- **Method Declaration**: Prototype (signature + return type + body ends with semicolon)
- **Method Definition**: Complete implementation with method body
- **Method Invocation**: Calling/executing method logic using various approaches
- **Method Calling Context**: Distinction between calling method (invoker) and called method (invokee)

### Where Methods Can Be Created
Methods can only be created inside classes. Key restrictions include:
- Cannot create methods at the Java file level outside classes
- Cannot create methods inside other methods
- Method creation is limited to class scope only

### Method Classification Types
Java methods are classified through multiple dimensions:

1. **Declaration Style**: Abstract vs Concrete methods
2. **Accessibility**: Private, Default, Protected, Public
3. **Execution Level**: Static, Final, Abstract, Native, Synchronized, StrictFP
4. **Object Interaction**: Static vs Non-Static (Instance) methods
5. **Return Behavior**: Void vs Non-Void methods
6. **Parameter Configuration**: Parameterized vs Non-Parameterized

## Static vs Non-Static Methods

### Overview
Methods are classified based on their relationship with objects. Static methods belong to the class level, while non-static methods operate on individual object instances.

### Key Concepts

#### Static Methods
A method declared with the `static` keyword that operates on the class level rather than individual object instances.

```java
public static void staticMethod() {
    // Static method implementation
}
```

**When to Use Static Methods:**
- Execute logic common to all objects of the class
- Perform operations that don't require object-specific data
- Implement utility functions that work across all instances

**Access Rules:**
- Can be called using class name: `ClassName.methodName()`
- Can be called using object reference, though object is not utilized
- Cannot directly access non-static variables or methods

#### Non-Static Methods (Instance Methods)
A method declared without the `static` keyword that operates on individual object instances.

```java
public void nonStaticMethod() {
    // Non-static method implementation
}
```

**When to Use Non-Static Methods:**
- Execute logic specific to individual objects
- Access and modify object-specific state variables
- Implement instance-level operations

**Access Rules:**
- Must be called using object reference: `objectName.methodName()`
- Cannot be called using only class name
- Can access both static and non-static members directly

### Deep Dive

#### Static Method Execution Mechanics
```java
class Example {
    static int staticVar = 10;
    int instanceVar = 20;
    
    static void staticMethod() {
        staticVar = 15;  // Allowed - static variable access
        // instanceVar = 25;  // Error - cannot access instance variables
        System.out.println("Static method executed");
    }
    
    void instanceMethod() {
        staticVar = 15;      // Allowed
        instanceVar = 25;    // Allowed
        System.out.println("Instance method executed");
    }
}
```

**Key Points:**
- Static methods operate at class level
- Modifications affect all objects
- Memory allocation occurs once for the class

#### Non-Static Method Execution Mechanics
```java
Example obj1 = new Example();
Example obj2 = new Example();

obj1.instanceMethod();  // Affects only obj1's instanceVar
obj2.instanceMethod();  // Affects only obj2's instanceVar
```

**Key Points:**
- Instance methods operate on object level
- Modifications are object-specific
- Memory allocation per object instance

### Code Examples

#### Static Method Calling Patterns
```java
class Test {
    public static void main(String[] args) {
        // Direct call
        Example.staticMethod();  // ✅ Valid
        
        // Using class name
        Example.staticMethod();  // ✅ Valid
        
        // Using object reference
        Example obj = new Example();
        obj.staticMethod();      // ✅ Valid (but not recommended)
        
        // Using null reference
        Example nullRef = null;
        nullRef.staticMethod();  // ✅ Valid (static nature bypasses null)
        
        // Instance method calling
        obj.instanceMethod();    // ✅ Valid
        // Example.instanceMethod(); // ❌ Error: non-static method
    }
}
```

#### Memory and State Modifications
```java
class BankAccount {
    static String bankIFSC = "SBIN0001234";  // Common to all accounts
    String accountNumber;                     // Instance-specific
    double balance;                          // Instance-specific
    
    static String getIFSC() {
        return bankIFSC;  // Static method accessing static variable
    }
    
    void deposit(double amount) {
        balance += amount;  // Instance method modifying instance variable
    }
    
    void withdraw(double amount) {
        balance -= amount;
        // Instance method modifying specific object's balance
    }
}
```

## Private vs Non-Private Methods

### Overview
Methods are further classified based on accessibility levels. Private methods restrict access to within the same class, while non-private methods allow external access.

### Key Concepts

#### Private Methods
A method declared with the `private` keyword, accessible only within the same class.

```java
private void privateMethod() {
    // Private method implementation - accessible only within current class
}
```

**Access Scope:**
- **Within Same Class**: ✅ Can be called directly by other methods
- **Within Same Package**: ❌ Not accessible
- **Outside Package**: ❌ Not accessible

**Usage Pattern:**
- Implement helper/sub-operations for main class logic
- Encapsulate internal implementation details
- Prevent external direct access to sensitive operations

#### Non-Private Methods
A method declared without `private` keyword (default, protected, or public accessibility).

```java
public void publicMethod() {  // Explicitly public
    // Non-private method implementation
}

void defaultMethod() {  // Package-private (default)
    // Non-private method implementation
}
```

**Access Scope:**
- **Within Same Class**: ✅ Fully accessible
- **Within Same Package**: ✅ Accessible (default/protected/public)
- **Outside Package**: Varies (protected allows inheritance, public allows full access)

### Deep Dive

#### Encapsulation Through Private Methods
```java
class BankAccount {
    private String accountNumber;
    private double balance;
    
    // Public interface methods
    public void deposit(double amount) {
        if (amount > 0) {
            balance += amount;
            sendAlert(amount, "DEPOSIT");  // Private method call
        }
    }
    
    public void withdraw(double amount) {
        if (balance >= amount) {
            balance -= amount;
            sendAlert(amount, "WITHDRAWAL");  // Private method call
        }
    }
    
    // Private helper method
    private void sendAlert(double amount, String type) {
        System.out.println(amount + " " + type + " from/to your account");
        System.out.println("Available balance: " + balance);
    }
}
```

**Key Benefits:**
- **Security**: External code cannot directly manipulate sensitive logic
- **Maintainability**: Internal implementations can change without affecting external API
- **Complexity Hiding**: Complex operations broken into manageable private helpers

#### Access Control Demonstration
```java
class Example {
    private void privateMethod() {
        System.out.println("Private method executed");
    }
    
    public void publicMethod() {
        privateMethod();  // ✅ Valid within same class
    }
}

// Another class in same package
class TestAccess {
    public static void main(String[] args) {
        Example ex = new Example();
        
        ex.publicMethod();     // ✅ Valid - public method accessible
        // ex.privateMethod();  // ❌ Error: private method not accessible
        // Example.privateMethod();  // ❌ Error: private and static
    }
}
```

## Void vs Non-Void Methods

### Overview
Methods are classified based on their return behavior. Void methods perform operations without returning values, while non-void methods return data to the calling context.

### Key Concepts

#### Void Methods
A method declared with `void` return type that performs operations without returning values.

```java
public void voidMethod() {
    // Perform operations
    System.out.println("Operation completed");
    // No return statement required or return; (empty return)
}
```

**Characteristics:**
- Return type specified as `void`
- Cannot return values using `return value;`
- Optional `return;` statement allowed for early method termination
- Used for actions/operations rather than computations

#### Non-Void Methods
A method declared with a specific data type return type that returns values to the calling method.

```java
public int nonVoidMethod() {
    int result = 42;
    return result;  // Must return compatible type
}
```

**Characteristics:**
- Return type specified as primitive or reference data type
- Must include `return value;` statement
- Return value must match declared data type
- Used for computations and data retrieval

### Deep Dive

#### Return Statement Variants
```java
// Void method return patterns
public void processData() {
    if (data == null) {
        return;  // Early exit - valid in void methods
    }
    // Continue processing
    performOperation();
    // Implicit return at method end - no explicit return needed
}

// Non-void method return patterns
public int calculateSum(int a, int b) {
    return a + b;  // Must return int value
}

public String getMessage() {
    return "Hello World";  // Must return String value
}

public Student createStudent() {
    return new Student("John", 20);  // Must return Student object
}
```

#### Data Type Selection for Return Types
Methods return different data types based on computation requirements:

```java
public boolean isValidEmail(String email) {
    return email.contains("@") && email.contains(".");
    // Returns: true/false
}

public int[] getEvenNumbers(int[] numbers) {
    // Returns: int array
    return Arrays.stream(numbers).filter(n -> n % 2 == 0).toArray();
}

public BankAccount authenticateUser(String username, String password) {
    // Returns: BankAccount object or null
    for (BankAccount account : accounts) {
        if (account.username.equals(username) && account.password.equals(password)) {
            return account;
        }
    }
    return null;
}
```

### Method Body Requirements

#### Void Methods
```java
// ✅ Valid - Empty void method
public void doNothing() {
}

// ✅ Valid - Void method with operations but no return
public void printMessage() {
    System.out.println("Hello");
}

// ✅ Valid - Void method with early return
public void processItem(Item item) {
    if (item == null) {
        return;  // Early exit
    }
    // Continue processing
}

// ❌ Invalid - Void method trying to return value
public void invalidMethod() {
    // return 5;  // Compile error: incompatible types
}
```

#### Non-Void Methods
```java
// ✅ Valid - Non-void method with return statement
public int getNumber() {
    return 42;
}

// ✅ Valid - Non-void method with conditional returns
public String getGrade(int score) {
    if (score >= 90) return "A";
    if (score >= 80) return "B";
    return "F";
}

// ❌ Invalid - Non-void method missing return statement
public int invalidMethod() {
    int x = 5;
    // Compile error: missing return statement
}

// ❌ Invalid - Non-void method with empty return
public int anotherInvalid() {
    // return;  // Compile error: missing return value
}
```

## Practical Example: Bank Account Application

### Implementation Overview
The Bank Account application demonstrates the practical application of different method types for managing banking operations.

### Complete Implementation

```java
class BankAccount {
    // Private fields - encapsulation
    private String accountNumber;
    private String accountHolder;
    private double balance;
    
    // Constructor
    public BankAccount(String accNum, String holder) {
        this.accountNumber = accNum;
        this.accountHolder = holder;
        this.balance = 0.0;
    }
    
    // Public non-static methods - main operations
    public void deposit(double amount) {
        balance += amount;
        sendAlert(amount, "credited");  // Private method call
    }
    
    public void withdraw(double amount) {
        if (balance >= amount) {
            balance -= amount;
            sendAlert(amount, "debited");  // Private method call
        } else {
            System.out.println("Insufficient funds");
        }
    }
    
    // Public non-void method
    public double showCurrentBalance() {
        return balance;  // Returns current balance
    }
    
    // Private helper method - sub-operation
    private void sendAlert(double amount, String action) {
        System.out.println(amount + " is " + action + " to your account");
        System.out.println("Available balance: " + balance);
    }
    
    // Public method to display account details
    public void display() {
        System.out.println("Account Number: " + accountNumber);
        System.out.println("Account Holder: " + accountHolder);
        System.out.println("Balance: " + balance);
    }
}

public class BankingDemo {
    public static void main(String[] args) {
        // Create account object
        BankAccount account = new BankAccount("1234567890", "John Doe");
        
        // Display initial state
        System.out.println("Initial Account State:");
        account.display();
        
        // Perform operations
        System.out.println("\nDepositing 10000:");
        account.deposit(10000);
        
        System.out.println("\nWithdrawing 3000:");
        account.withdraw(3000);
        
        System.out.println("\nCurrent Balance: " + account.showCurrentBalance());
        
        System.out.println("\nFinal Account State:");
        account.display();
    }
}
```

### Execution Sequence Analysis

1. **Object Creation**: `BankAccount account = new BankAccount("1234567890", "John Doe");`
   - Non-static constructor called to create account instance

2. **Deposit Operation**: `account.deposit(10000);`
   - Public non-static method called with object `account`
   - Balance updated to `balance + 10000`
   - Private `sendAlert()` method invoked internally

3. **Withdraw Operation**: `account.withdraw(3000);`
   - Public non-static method called with object `account`
   - Balance updated to `balance - 3000`
   - Private `sendAlert()` method invoked internally

4. **Balance Inquiry**: `account.showCurrentBalance();`
   - Public non-void method returns current balance value
   - Return type `double` matches returned value

### Key Design Principles Demonstrated

| Operation Type | Method Type | Accessibility | Return Type | Purpose |
|----------------|-------------|---------------|-------------|---------|
| Deposit | Non-Static | Public | Void | Perform account deposit |
| Withdraw | Non-Static | Public | Void | Perform account withdrawal |
| Balance Inquiry | Non-Static | Public | Double | Retrieve current balance |
| Alert Generation | Non-Static | Private | Void | Helper method for notifications |
| Account Display | Non-Static | Public | Void | Show account information |

## Summary

### Key Takeaways
```diff
+ Static methods are called with class name and execute logic common to all objects
+ Non-static methods require object reference and operate on specific object instances
+ Private methods hide implementation details and can only be accessed within the same class
+ Non-private methods provide public APIs accessible from external classes
+ Void methods perform operations without returning values
+ Non-void methods return typed values and require return statements
- Static methods cannot directly access non-static members
- Non-void methods must include return statements matching declared data types
- Private methods cannot be accessed from external classes even with object references
```

### Expert Insights on Method Types

#### Real-world Application
In enterprise applications, method types are strategically used:
- **Static Methods**: Utility operations (database connection pools, configuration loaders)
- **Private Methods**: Internal validation, calculation helpers, and security checks
- **Public Non-void Methods**: Data retrieval operations (getAccountDetails(), calculateTotal())
- **Void Methods**: Command operations (processPayment(), updateInventory())

#### Expert Path: Method Design Best Practices
- **Single Responsibility Principle**: Each method should perform one logical operation
- **Naming Convention**: Use `getXXX()` for data retrieval, `setXXX()` for updates, `isXXX()` for boolean queries
- **Method Length**: Keep methods concise (10-20 lines), break complex logic into smaller private helpers
- **Parameter Limits**: Limit to 3-4 parameters; use parameter objects for complex configurations
- **Exception Handling**: Use checked exceptions for recoverable errors, unchecked for programming errors

#### Common Pitfalls and Their Solutions

**Common Issue: Static vs Non-Static Confusion**
- **Problem**: Attempting to access instance variables from static methods
- **Solution**: Move instance-dependent logic to non-static methods or pass required data as parameters
- **Prevention**: Static methods should work without object state requirements

**Common Issue: Missing Return Statements**
- **Problem**: Non-void methods compiled without return statements
- **Solution**: Ensure all execution paths in non-void methods include a return statement
- **Prevention**: Check for unconditional return in conditional blocks

**Common Issue: Inappropriate Method Accessibility**
- **Problem**: Public methods exposing internal implementation details
- **Solution**: Use private methods for internal operations and public methods for external API
- **Prevention**: Ask "Does this need external access?" before making methods public

**Lesser Known Points:**
- **Static Method Performance**: Slightly better performance due to no object overhead, but design considerations override micro-optimizations
- **Anonymous Objects**: Can invoke instance methods: `new Calculator().add(5, 3)` without storing object reference
- **Method Overloading**: Same method name with different signatures - can be static/non-static mix
- **Native Methods**: Declared with `native` keyword, implementation in platform-specific native code (C/C++)
- **StrictFP Methods**: Force consistent floating-point calculations across platforms

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
