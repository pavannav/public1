# Session 73: Non Static Members and Execution Flow 2

## Table of Contents
- [Overview](#overview)
- [Key Concepts and Execution Flow of Non-Static Members](#key-concepts-and-execution-flow-of-non-static-members)
- [Non-Static Variables, Methods, and Constructors](#non-static-variables-methods-and-constructors)
- [Bank Account Project Development](#bank-account-project-development)
- [Class Planning and Design Order](#class-planning-and-design-order)
- [Object Creation Syntax and Execution](#object-creation-syntax-and-execution)
- [Four Activities in Object Creation](#four-activities-in-object-creation)
- [Roles of New Keyword and Constructors](#roles-of-new-keyword-and-constructors)
- [Interview Questions and Proofs](#interview-questions-and-proofs)
- [Summary](#summary)

## Overview
This session continues the exploration of non-static members in Java, focusing on their execution flow, usage with constructors, and practical implementation in a bank account project. It explains when to use non-static variables, blocks, methods, and constructors versus static counterparts, emphasizing object-specific logic and memory allocation. The class covers designing a real-world application with non-static members and delves into the detailed process of object creation, including the four key activities involved.

## Key Concepts and Execution Flow of Non-Static Members
### Purpose of Non-Static Members
- **Non-Static Variables (Instance Variables)**: Provide separate memory copies for each object instance, storing object-specific values.
- **Non-Static Blocks (Instance Initializer Blocks - IIB)**: Execute common initialization logic for all constructors of a class.
- **Non-Static Methods (Instance Methods)**: Perform operations using object-specific values; logic executes with the current object reference.

Non-static members are created only when objects are instantiated from the class.

### Execution Flow
1. **Class Loading**: When a class is first referenced, static members are loaded and initialized.
2. **Object Creation**: Non-static members become active upon object creation using the `new` keyword.
3. **Sequence in Object Creation**:
   - Non-static variables get memory with default values.
   - Instance Initializer Blocks (IIB) execute common logic for all constructors.
   - Constructors execute for specific object initialization.

All non-static members (variables, blocks, methods) are tied to specific object instances, not shared across instances.

### Comparison of Static and Non-Static Members
| Aspect | Static Members | Non-Static Members |
|--------|----------------|-------------------|
| Memory | Shared among all objects | Separate copy per object |
| Execution | When class loads | When object is created |
| Access | Via class name (Class.var) | Via object reference (obj.var) |
| Usage | Class-level constants/data | Object-specific data/behavior |

## Non-Static Variables, Methods, and Constructors
### Non-Static Variables
- Declared at the class level without the `static` keyword.
- Example: `private int accountNumber;` - each object gets its own copy.

### Instance Initializer Block (IIB)
- Syntax:
```java
{
    // Common initialization logic for all constructors
    count++;
}
```
- Executes once per object creation, regardless of which constructor is called.
- Used for logic shared across all constructors (e.g., incrementing object count).

### Constructors
- No-parameter and parameterized constructors are defined based on initialization needs.
- No-parameter: Initializes with default values.
- Parameterized: Accepts arguments for custom initialization.
- If only parameterized constructors exist, you must define a no-parameter constructor explicitly; otherwise, the compiler provides one.

### Non-Static Methods
- Declared without `static`.
- Use to perform business logic on object-specific data.
- Example methods: `display()`, `deposit(double amount)`, `withdraw(double amount)`, `currentBalance()`.

**Key Decision**: Use non-static methods when the logic depends on or modifies instance variables.

## Bank Account Project Development
### Requirements
- Create a `BankAccount` class representing bank accounts.
- Features: Initialize account with/without values, deposit, withdraw, check balance, display details.
- Track total number of account objects created.

### Implementation Steps
1. **Define Class and Variables**:
```java
public class BankAccount {
    private static int count = 0;  // Static variable to count objects
    private int accountNumber;      // Non-static for object-specific data
    private String accountHolderName;
    private double balance;
}
```

2. **Instance Block for Common Logic**:
```java
{
    count++;  // Increment for each object
}
```

3. **Constructors**:
```java
public BankAccount() {
    // No-parameter constructor
}

public BankAccount(int acc, String name, double bal) {
    accountNumber = acc;
    accountHolderName = name;
    balance = bal;
}
```

4. **Methods**:
```java
public void display() {
    System.out.println("Account Number: " + accountNumber);
    System.out.println("Account Holder Name: " + accountHolderName);
    System.out.println("Balance: " + balance);
}

public void deposit(double amount) {
    balance += amount;
}

public void withdraw(double amount) {
    balance -= amount;
}

public double currentBalance() {
    return balance;
}
```

### Execution Flow Demonstration
- Create objects:
```java
BankAccount acc1 = new BankAccount();  // No-parameter constructor
BankAccount acc2 = new BankAccount(5678, "BK", 2000.0);  // Parameterized
```
- Each object creation triggers IIB once, incrementing `count`.
- Methods operate on instance-specific data; modifying `acc1.balance` doesn't affect `acc2`.

### Output Example
```
Account Number: 0 (default value, not initialized)
Account Holder Name: null
Balance: 0.0
```

## Class Planning and Design Order
### Recommended Class Structure for OOP Projects
Follow this order when planning and writing code:

1. **Static Fields**: Variables shared across class (e.g., `count`).
2. **Instance Fields**: Non-static variables (e.g., `accountNumber`, `balance`).
3. **Static Blocks**: Initialize static fields (execute once per class load).
4. **Instance Blocks**: Initialize instance fields common to all constructors.
5. **Constructors**: Initialize objects with default/custom values.
6. **Instance Business Logic Methods**: Deposit, withdraw, calculate.
7. **Instance Getter/Setter Methods**: For reading/modifying fields.
8. **Instance Display Methods**: Show object data.
9. **Static Business Logic/Getter/Setter Methods**: If needed.
10. **Main Method Class**: For testing object creation and operations.

This order ensures clarity and logical flow: Declare fields → Initialize → Construct → Perform logic.

### Homework: Practice Project
Develop your own simple project (e.g., electricity bill, employee records, student management) following this structure. Include:
- Non-static variables for object data.
- IIB if common logic exists.
- Multiple constructors.
- Methods for business operations and display.

## Object Creation Syntax and Execution
### Complete Syntax
```java
ClassName referenceVariable = new ConstructorCall(parameters);
```

- `ClassName referenceVariable;`: Creates only a reference variable (no memory for instance members).
- `new ConstructorCall(parameters);`: Creates the full object.

### When Non-Static Members Execute
Non-static members activate only upon object creation via `new`, not during reference variable declaration.

### Example
```java
BankAccount acc1;  // Reference variable created; no object yet
BankAccount acc2 = new BankAccount();  // Object created; instance members initialized
acc1 = acc2;  // Now acc1 points to the object
```

## Four Activities in Object Creation
When executing `Example e1 = new Example(args);`, four implicit activities occur:

1. **Reference Variable Declaration**: Memory allocated for the variable `e1`, no value assigned.
2. **Class Instantiation**: 
   - Memory allocated for non-static variables with default values.
   - New keyword initializes instance variables to defaults (e.g., `int` to 0, `String` to `null`).
3. **Object Initialization**: Constructor executes, overriding defaults with provided values.
4. **Returning Object Reference**: New keyword returns the object reference, assigned to `e1`.

### Memory Diagram
- Step 1: `e1` variable memory (empty).
- Step 2: Object memory created with defaults (e.g., 0 for ints).
- Step 3: Constructor runs, updates values (e.g., to args like 50, 60).
- Step 4: Reference assigned to `e1`.

Following this flow prevents confusion in execution order.

## Roles of New Keyword and Constructors
### New Keyword Responsibilities (4-5 Activities)
1. Load class into JVM (if not already loaded).
2. Allocate memory for instance variables and initialize with defaults.
3. Call constructor (passing implicit `this` reference).
4. Return object reference after constructor completion.

### Constructor Responsibilities (3 Activities)
1. Provide class information to new keyword for object creation.
2. Call superclass constructor (via implicit `super()`) to initialize inherited members.
3. Initialize current class instance variables with given values.

Total activities: 7-8 combine for object creation.

## Interview Questions and Proofs
### Key Questions
- **Who creates the object?** New keyword.
- **Who initializes with default values?** New keyword.
- **Who initializes with given values?** Constructor.
- **Who returns object reference?** New keyword.

Common misconception: Constructors create objects/return references.

### Proofs
1. **Constructor cannot create objects**: Relies on implicit `this` parameter; without `new`, no object.
2. **Constructor return type is void**: Confirmed by bytecode descriptors (`()V`) and compilation errors on `return <value>;`.
3. **Constructor is not a method**: Cannot return values; used only for initialization.
4. **JUnit Testing**: Create constructor without return; if returning, it's invalid.

Avoid industry controversy by following JVM/compiler evidence: `new` creates/instantiates; constructor initializes.

## Summary
### Key Takeaways
- ✅ Non-static members provide instance-specific behavior and memory.
- ✅ Instance blocks run once per object for common initialization.
- ✅ Constructors initialize with defaults or values; use non-static for object logic.
- ✅ Object creation involves 4 activities: declare variable, instantiate class, initialize via constructor, return reference.
- ✅ New keyword creates/instantiates; constructor initializes values.
- ❌ Static members for shared data; non-static for unique instances.
- ! Ensure constructors cover all initialization scenarios; overuse static can lead to thread-safety issues.
- 💡 Design classes in logical order: fields → initialization → logic → display.

### Expert Insight
#### Real-world Application
In banking systems, use non-static members for account-specific operations (deposits, withdrawals) across millions of user accounts. Instance blocks can initialize audit logs per account, while static fields track total accounts system-wide. For scalability, combine with design patterns like Factory for object creation.

#### Expert Path
Master object lifecycle: Study JVM bytecode (`javap -v`) to confirm execution flows. Practice inheritance to understand `super()` calls in constructors. Advance to threads: Ensure non-static synchronization for concurrent access. Dive into reflection to inspect object creation dynamically.

#### Common Pitfalls
- Mistakenly using static for instance data, causing shared state bugs.
- Forgetting no-parameter constructor, leading to compilation errors.
- Ignoring execution order: Instance blocks before constructors matter.
- Assuming constructors return objects: They return void; `new` returns references.
- Memory leaks from unchecked object creation in loops.

**Corrections to Transcript:**
- "Straty" corrected to "static" throughout.
- "insance" corrected to "instance".
- "Hh" corrected to "HK" (likely instructor's name).
- "Comile" corrected to "compile".
- "inir" corrected to "initializer".
- "new key word" corrected to "new keyword".
- "executed repeated L for every" corrected to "executed repeatedly for every".
- Various typos like "Straty", "inis", "hte" corrected to proper terms. Note: No occurrences of "htp/http" or "cubectl/kubectl" found in this transcript.
