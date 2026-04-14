### Session 89: OOP Principles - Encapsulation

[TOC]

## Overview
This session explores **Object-Oriented Programming (OOP) principles**, distinguishing between object-based and object-oriented languages, and diving deep into the first principle: **encapsulation**. You'll learn how encapsulation provides security to object data, prevents unauthorized access, ensures data integrity through validation, and promotes code reusability and centralized modifications. The session covers real-world examples (e.g., bank accounts, ATMs), code implementations in Java, and misconceptions like the differences between data hiding, abstraction, and encapsulation. It emphasizes developing classes with private fields and public accessor methods.

## Key Concepts

### Object-Based vs. Object-Oriented Languages
- **Object-Based Languages**: Support objects implicitly (e.g., JavaScript with `window`, `document` objects) but do not allow creating classes, objects, or implementing OOP features like encapsulation, inheritance, or polymorphism (e.g., JavaScript).
- **Object-Oriented Languages**: Fully support class creation, object instantiation, and OOP principles (e.g., Java).
- **Need for OOP Principles**: Classes and objects handle real-world entities, but these principles add features like security (encapsulation), subtype relations (inheritance), and multiple behaviors (polymorphism).

### Principles of OOP
Three core principles are covered:
- **Encapsulation**
- **Inheritance** (topics for future sessions)
- **Polymorphism** (topics for future sessions)

These principles do not create objects themselves but provide "suggestions" for security, reusability, and dynamic binding.

### Encapsulation in Detail
- **Definition**: The process of wrapping variables and methods into one unit using a class, while operating variables only via publicly available setter/getter methods. It hides direct access to object data (data hiding combined with controlled access).
- **Sun Microsystems Definition**: Declare all variables as private and provide access via setter/getter methods; this prevents direct access.
- **Textbook Definitions**:
  - Balagurusamy: Binding of data and methods.
  - Complete Reference: Wrapping up of variables and methods.
- **Combined Definition**: Wrapping variables and methods as one unit using a class, and providing access to variables (read/modify) via public getter/setter methods.

Encapsulation achieves security, reusability, and centralized code changes through validation in setter methods.

#### Benefits (Advantages)
By declaring fields as `private` and using setter/getter methods:
1. **Security**: Prevents unauthorized direct access by other classes/programmers.
2. **Data Validation**: Stop storing wrong values (e.g., negative balances) via `if` conditions in setters.
3. **Code Reusability/Centralized Modification**: Write validation logic once; changes apply everywhere without recompiling dependent classes.

#### Problems Without Encapsulation
Direct field access leads to:
- **No Security**: Anyone can read/modify data (e.g., thief analogy with an unguarded house).
- **Wrong Values Stored**: No built-in checks (e.g., storing negative balance as valid).
- **Code Redundancy**: Validation logic repeated across classes, causing errors and maintenance issues (e.g., small changes require full project recompilation).

#### How to Implement Encapsulation
1. **Declare all fields as `private`**: Prevents direct access; this is **data hiding**.
2. **Provide Public Setters/Getters**: Allow controlled access (e.g., `validate()` in setter).
3. **In Setter Methods**: Add logic for validation (e.g., prevent negative balances).
4. **In Getter Methods**: Simply return values (no validation needed).
```java
class BankAccount {
    private double balance;

    public void setBalance(double balance) {
        if (balance >= 0) { // Validation to prevent wrong values
            this.balance = balance;
        } else {
            throw new IllegalArgumentException("Balance must be non-negative");
        }
    }

    public double getBalance() {
        return balance;
    }
}
```

#### Code Example: Bank Account
The session demonstrates encapsulation with a `BankAccount` class, showing direct access issues and solutions.

**Initial Problematic Code (No Encapsulation)**:
```java
class BankAccount {
    double balance; // Public - direct access allowed
    // ...
}
class Main {
    public static void main(String[] args) {
        BankAccount account = new BankAccount();
        account.balance = -5000; // Direct access; no check for negative values
        System.out.println(account.balance); // Outputs -5000 (wrong value allowed)
    }
}
```
- Issues: Direct access stores invalid values; code redundancy if multiple classes (e.g., `ATM`) need validation.

**Encapsulated Code**:
```java
class BankAccount {
    private double balance; // Data hiding

    public void setBalance(double balance) {
        if (balance < 0) {
            throw new IllegalArgumentException("Balance must be positive");
        }
        this.balance = balance;
    }

    public double getBalance() {
        return balance;
    }
}
class Main {
    public static void main(String[] args) {
        BankAccount account = new BankAccount();
        account.setBalance(-5000); // Rejected via exception
        account.setBalance(5000); // Accepted
        System.out.println(account.getBalance()); // Outputs 5000
    }
}
```
- Advantages: Validation in one place; security enforced.

#### Execution Flow
- Using setters/getters: Control passes through methods (e.g., `setBalance()` validates before storing).
- No direct access prevents unauthorized modifications.
- Centralized changes: Alter setter logic to apply globally.

#### Strong vs. Weak Encapsulation
- **Weak Encapsulation**: At least one non-`final` field is not `private`, or local methods are public (small "holes" allow access).
- **Strong Encapsulation**: All non-`final` variables and local methods are `private`; provides "shielding" (tight sealing) against external access.
- `final` variables can remain public as they can't be modified.
- Example: A class with one public field for direct access is weakly encapsulated; all `private` is strongly encapsulated.

### Relationship Between Encapsulation and Abstraction
- **Encapsulation**: Hides object properties (variables) from direct access; focuses on data security.
- **Abstraction**: Hides method implementation details/logic (e.g., how a setter validates); users only know the interface.
- **Interconnected**: Developing one implies the other; they work together for hiding.
- Real-World Example: ATM encapsulates cash (no direct access); abstracts swiping logic (users don't know internal processes).
- Difference: Encapsulation hides variables; abstraction hides method logic.

### Real-Time Examples
- **Bank Account/ATM**: Balance as `private`; access via card swipe (setter-like) with validation (e.g., PIN check).
- **Mobile Phone**: Screen encapsulates internal circuits; users access via buttons (methods).
- **Human Body**: Skin/bones encapsulate organs; mouth provides "setter" access, digestion is abstracted.
- **Lighter**: Case encapsulates flint/gas; pressing button is the "method" access.

All real-world objects have encapsulation (hidden internal parts) and abstraction (hidden processes).

### Assignments
Develop a `Bike` class simulating gear changes (0-5 allowed). Use encapsulation to validate input:
- `private int gear;`
- `setGear(int gear)`: Throw exception if outside 0-5.
- Test with inputs like 6 (should reject).

## Sample Program Flow
1. Class loading and `main()` execution.
2. Object creation (no initial values).
3. Caller invokes `setBalance(5000)` → Validation passes → Store.
4. Caller invokes `getBalance()` → Retrieve value.
- Differs from direct field assignment: Methods allow checks and reusability.

## Summary

### Key Takeaways
```diff
+ Encapsulation provides security by hiding data and controlling access via setters/getters with validation.
- Without encapsulation: Direct access leads to unauthorized changes, wrong values, and code redundancy.
! Always declare fields as private in real projects, even without initial validations, for future-proofing.
+ Strong encapsulation > Weak: All non-final fields/methods private.
+ Encapsulation ≠ Security alone; combine with logic (e.g., if-conditions) for data integrity.
```

### Expert Insight
**Real-World Application**: In enterprise systems (e.g., banking apps), encapsulate sensitive data like user balances. Use frameworks like Spring for automatic getters/setters with AOP for logging/access control. Example: Microservices expose APIs as "methods," abstracting internal DB queries.  
**Expert Path**: Master encapsulation by studying design patterns like Builder (for object creation) and Factory (for controlled instantiation). Practice with unit tests (e.g., Mockito for mocking encapsulated dependencies).  
**Common Pitfalls**: Forgetting to add validation in setters, leading to runtime errors; using public fields in legacy code without refactoring.  
**Lesser-Known Things**: Encapsulation aids in memory management (fewer direct references). In Java, `transient` fields bypass serialization, providing additional hiding; strong encapsulation supports immutability (e.g., `final` with private constructors).

### Feedback
- **Corrections Notified**: 
  - "Balur Swami textbook" → Likely "Balagurusamy".
  - "binder up off" → "binding up of"; "htp" → Not present here; "cubectl" → Not here (possibly from other sessions).
  - Various repetitions/typos: "Rundy" → "redundancy"; "Setra" → "setter".
  - If needed, clarify or provide source for corrections.
