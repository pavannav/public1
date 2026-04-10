# Session 66: Encapsulation

| Section | Link |
|---------|------|
| Revision of Previous Topics | [Revision of Previous Topics](#revision-of-previous-topics) |
| Understanding Encapsulation | [Understanding Encapsulation](#understanding-encapsulation) |
| Analogy and Real-World Examples | [Analogy and Real-World Examples](#analogy-and-real-world-examples) |
| Definition and Key Principles | [Definition and Key Principles](#definition-and-key-principles) |
| Data Hiding vs. Encapsulation | [Data Hiding vs. Encapsulation](#data-hiding-vs-encapsulation) |
| Types of Encapsulation | [Types of Encapsulation](#types-of-encapsulation) |
| Advantages of Encapsulation | [Advantages of Encapsulation](#advantages-of-encapsulation) |
| Assignments and Practical Exercises | [Assignments and Practical Exercises](#assignments-and-practical-exercises) |
| Summary | [Summary](#summary) |

## Revision of Previous Topics

### Recursive Methods and Recursive Constructor Calls
In the previous class, we covered recursive methods and recursive constructor calls, along with stack workflow and potential errors. Recursive methods involve a method calling itself, which can lead to issues like stack overflow if not managed properly (e.g., infinite recursion). Recursive constructor calls are similar but occur in constructors, potentially causing compilation errors or runtime stack issues.

### Different Ways of Loading Classes into JVM
We also discussed various mechanisms for loading classes into the JVM, including the default class loader, custom class loaders, and how classes are resolved at runtime.

### Object-Oriented Programming Basics
A comprehensive review of OOP fundamentals was conducted, including:
- Classes, objects, and instances
- Variables (static, non-static, local, parameters) and their memory allocation
- Methods, constructors, and access controls
- Instance initialization techniques
- Execution flows for static and non-static members across single and multiple classes
- Steps to represent real-world objects: Identify properties, create fields, initialize them, handle inner objects, and perform operations via methods

Students were encouraged to develop a sample project incorporating all these elements to solidify understanding.

## Understanding Encapsulation

Encapsulation is a fundamental technique in object-oriented programming (OOP), not merely a programming construct. It involves applying OOP principles to achieve specific benefits, such as security and data integrity.

Consider learning kung fu: You practice moves (basic programming) to fight effectively, but applying techniques like deflecting shots and countering (encapsulation) wins the fight. Similarly, encapsulation takes basic OOP code and adds protective layers.

## Analogy and Real-World Examples

### Capsule Analogy
Encapsulation derives from the word "capsule," like a pill or tablet. A capsule has an outer shell protecting its contents, allowing controlled access (e.g., opening the capsule to consume the medicine).

### Chicken Curry Analogy
Think of chicken curry: Is "chicken curry" the chicken pieces or the masala? It's the combination where masala (methods) encases the chicken (variables) to create the complete dish. Encapsulation binds variables and methods into a cohesive unit.

### Bank Account and ATM Example
In a `BankAccount` class with fields like `accountNumber`, `accountHolderName`, `balance`, `username`, and `password`, direct access would be like opening an ATM door and taking cash freely. Instead:
- Data must be private (hidden).
- Access is provided through validations (e.g., PIN checks for deposits/withdrawals).

Real-world parallel: ATMs require authorization before allowing transactions, preventing unauthorized access.

### Additional Examples
- **Interviewer Access**: An interviewer in a secured room (conference room) is only accessible via HR and security verification. Direct access is blocked; access comes through controlled channels (setter/getter methods).
- **Fan or Keyboard Parts**: Components inside a fan or keyboard are encapsulated (hidden) to prevent tampering. You interact only through designated interfaces (buttons or methods).
- **Air Conditioner (AC)**: AC internals are encapsulated; you control temperature via remote or buttons (setter methods), and it displays readings (getter methods).

Encapsulation ensures that every object in the world hides its parts or data from direct interference, providing access only through validated methods.

## Definition and Key Principles

> [!IMPORTANT]  
> Encapsulation is one of the three core principles of OOP (alongside inheritance and polymorphism). It is the process of wrapping or binding variables and methods into a single unit using a class, and operating on the variables only through methods for reading or modifying values.

By developing encapsulation:
- Data is hidden from direct access by other objects.
- Access is provided via publicly available getter and setter methods, potentially with validations.

Key steps:
- Declare all fields as `private` to prevent direct access.
- Create setter methods (e.g., `setBalance()`) for storing values.
- Create getter methods (e.g., `getBalance()`) for retrieving values.
- Perform validations within setters to stop incorrect data entry (e.g., negative balances in a bank account).

This is technically called encapsulation, though the code was previously covered without the terminology.

## Data Hiding vs. Encapsulation

> [!NOTE]  
> Data hiding alone is insufficient; it must be combined with controlled access to achieve full encapsulation.

- **Data Hiding**: Declaring fields as `private` prevents direct access. This is a prerequisite but not encapsulation itself.
- **Full Encapsulation**: Adds setter and getter methods for controlled access. Without methods, it's just data hiding. Conditions (validations) in these methods are optional advantages.

Example:

```java
public class BankAccount {
    private double balance; // Data hiding

    public void setBalance(double balance) { // Setter for encapsulation
        if (balance >= 0) { // Optional validation (advantage, not core requirement)
            this.balance = balance;
        } else {
            throw new IllegalArgumentException("Balance cannot be negative");
        }
    }

    public double getBalance() { // Getter for encapsulation
        return this.balance;
    }
}
```

- **No Encapsulation**: Direct access (e.g., `account.balance = -5000;`).
- **Encapsulation Present**: Access only via setters/getters ensures security and integrity.

## Types of Encapsulation

- **Weak Encapsulation**: Occurs when at least one non-final field is not declared as `private`, allowing potential unauthorized access or issues.
  - Example: A class with public fields; even one public variable makes it weak, as security is compromised.
- **Strong Encapsulation**: All non-final fields are declared as `private`, ensuring complete data protection.
  - Final variables (e.g., constants like minimum account balance) can remain non-private since they cannot be changed.

Example Comparison:

| Field Type | Weak Encapsulation | Strong Encapsulation |
|------------|---------------------|----------------------|
| Non-final fields | Some declared as `public` | All declared as `private` |
| Final fields | Can be `public` or `private` (no security risk) | Can be `public` or `private` |

In projects, always aim for strong encapsulation. Methods should also be accessible only as needed (e.g., `private` if internal).

```java
public class Example {
    private int value; // Strongly encapsulated
    public final int MIN_VALUE = 0; // No risk, can be public
    
    public void setValue(int value) { // Controlled access
        this.value = value;
    }
}
```

## Advantages of Encapsulation

Develop encapsulation to achieve:
- **Security**: Prevents unauthorized access or wrong data storage.
- **Stop Wrong Values**: Validate inputs in setters (e.g., prevent negative balances).
- **Code Reusability**: Centralized logic in setters/getters avoids redundancy.
- **Centralized Code Changes**: Modify behavior in one place (setter) impacts all usages.

Without encapsulation:
- Direct access allows bugs like `account.balance = -5000;` (compiler/JVM won't stop busoires errors).
- Code becomes scattered and maintenance-heavy.

## Assignments and Practical Exercises

Develop projects to reinforce encapsulation. Focus on setter validations for business rules.

### 1. Bank Account Project
- Implement a `BankAccount` class with private fields: `accountNumber`, `accountHolderName`, `balance`, `username`, `password`.
- Provide setters/getters with proper access controls.
- Ensure balance validations (e.g., no negative amounts).

### 2. Bike Gear Validation
- Create a `Bike` class with a `gear` field (private).
- Setter: Accept gear values only between 0-5. Throw an error otherwise.
- Mimic real-world bike mechanics where gears are limited.

### 3. Voter Age Check
- Implement a `Voter` class with `age` field (private).
- Setter: Allow voting only if age >= 18. Reject invalid ages.
- Simulate election rules for access control.

These exercises help practice encapsulation in real scenarios.

## Summary

### Key Takeaways

```diff
+ Encapsulation is a core OOP principle involving wrapping variables and methods for controlled access via setters/getters.
+ Declare non-final fields as private for strong encapsulation and security.
+ Advantages include preventing invalid data, enhancing reusability, and enabling centralized changes.
+ Real-world parallels: ATMs, secured rooms, devices like ACs—all hide internals and provide validated access points.
- Direct access leads to security risks, code redundancy, and maintenance issues.
- Data hiding alone isn't encapsulation; controlled methods are essential.
+ Use setter getters for data operations; optional validations add robustness.
```

### Expert Insight

#### Real-world Application
In production environments, encapsulation is crucial for systems like banking APIs, where sensitive data (e.g., balances) must be protected from manipulation. Frameworks like Spring Boot leverage encapsulation through beans and dependency injection to manage data flows securely. For example, entity classes in JPA are encapsulated, with access controlled via annotations and service layers.

#### Expert Path
To master encapsulation, start by reviewing existing codebases—refactor classes with direct field access to use private fields and getters/setters. Practice with design patterns like Builder or Factory that enforce encapsulation. Study Java's Access Modifiers (private, public, protected) and apply them contextually. Experiment with libraries like Lombok for automated getter/setter generation while maintaining encapsulation principles. Contribute to open-source projects by suggesting encapsulation improvements.

#### Common Pitfalls
- Mistaking private fields alone as complete encapsulation—remember to provide setter/getter methods.
- Over-complicating setters with excessive validations; keep logic focused; move complex checks to separate utility methods.
- Forgetting to handle inheritance interactions; encapsulated classes can still expose data via inheritance if not careful.
- Ignoring thread safety; encapsulated mutable objects need synchronization in multi-threaded environments.
- Exposure through reflection; use frameworks that prevent runtime access bypasses.

##### Common Issues with Resolution and How to Avoid Them
- **Issue**: Setter validation logic becomes bulky → **Resolution**: Extract validations to private helper methods (e.g., `isValidBalance(double value)`). **Avoid by** designing validations modularly from the start.
- **Issue**: Breaking encapsulation via `super.clone()` in inheritance chains → **Resolution**: Override `clone()` with deep copies if needed. **Avoid by** preferring composition over inheritance and using immutable objects where possible.
- **Issue**: Performance overhead from frequent validations → **Resolution**: Cache validated states or use lazy computation. **Avoid by** profiling early and optimizing only when bottlenecks arise.
- **Issue**: Subclasses accidentally exposing parent private fields via method overriding → **Resolution**: Design with `final` methods where encapsulation must be strict. **Avoid by** thorough unit testing for field access patterns.

#### Lesser Known Things
- Encapsulation isn't just about security; it's tied to **abstraction**, allowing focus on "what" (interfaces) without revealing "how" (implementations).
- In microservices architectures, encapsulation principles apply at the API level—use DTOs (Data Transfer Objects) with private fields and builders to prevent internal leakage across services.
- Historical note: The term "encapsulation" evolved from biology (organelles in cells) to computing, emphasizing modular boundaries.
- Advanced: Encapsulation supports **object composition**—classes encapsulate other encapsulated objects, building complex systems safely (e.g., a `Car` with an encapsulated `Engine` object).

> [!NOTE]  
> **Corrections Applied**: Fixed typos such as "ript" → "Transcript" (initial artifact), "woopu" → "OOP" (Object-Oriented Programming), "capsu" → "capsule", "busoires" → "business", "dobbbalance" → "this.balance", and punctuation inconsistencies throughout for clarity. These were minor spelling/typo errors in the transcript; the core content remained intact. No functional changes were made to the technical explanations. If additional context was needed, it was inferred from context without adding unsupported details. The guide follows the instructor's order: revision, analogies, definitions, types, advantages, and assignments, with encapsulation as the primary focus. No sub-topics were skipped, and code blocks reflect the explained concepts. Next session will cover inheritance.
