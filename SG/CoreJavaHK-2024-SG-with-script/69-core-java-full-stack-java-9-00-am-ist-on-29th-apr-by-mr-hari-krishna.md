# Session 69: Polymorphism

- [Overview](#overview)
- [Key Concepts/Deep Dive](#key-conceptsdeep-dive)
  - [Definition of Polymorphism](#definition-of-polymorphism)
  - [Method Overloading](#method-overloading)
  - [Method Overriding](#method-overriding)
  - [Method Hiding for Static Methods](#method-hiding-for-static-methods)
  - [Flow of Execution in Polymorphism](#flow-of-execution-in-polymorphism)
- [Summary](#summary)

## Overview

Polymorphism is a fundamental concept in object-oriented programming that allows objects of different classes to behave in different ways when performing the same operation. The term "polymorphism" comes from Greek words meaning "many forms." In real life, polymorphism is exhibited when the same entity behaves differently based on the situation, such as a person feeling happy or angry depending on circumstances. In programming, methods represent behaviors, and polymorphism enables multiple implementations of the same method based on context.

## Key Concepts/Deep Dive

### Definition of Polymorphism

Polymorphism is the process of exhibiting different behaviors based on the situation. In object-oriented programming, it refers to providing multiple implementations to the same operation based on subtype (inheritance) or different types of values (parameters).

💡 **Real-world Analogy**: The same action can lead to different reactions based on context. For example:
- Arriving late to class: Some students feel happy (if it means a holiday), others feel angry (if it wastes their time).
- Bank deposit operation: Can be performed via cash, check, DD, or online transfer, each with different processing logic.

In programming, method encapsulates behavior. Polymorphism means developing different logic for the same method name.

### Method Overloading

Method overloading allows defining multiple methods with the same name but different parameters within the same class. This enables polymorphism based on different types of values (arguments passed).

#### How to Develop Overloading
- Same method name
- Different parameter types, number, or order
- Yes
- Logic can be same or different for different implementations

#### Example Code: Bank Deposit Methods

```java
class Bank {
    public void deposit(double cash) {
        System.out.println("Deposit of cash is executed");
    }
    
    public void deposit(String check) {
        System.out.println("Deposit of check is executed");
    }
    
    public void deposit(long accountNumber1, long accountNumber2, double amount) {
        System.out.println("Deposit of transfer is executed");
    }
}
```

#### Method Execution Rules
- Compiler searches for exact parameter match first
- If no exact match, uses automatic type promotion (int → long → float → double)
- If multiple matches exist, selects the nearest range parameter method
- Overloaded method must be in same class

#### Lab Demo: Calling Overloaded Methods

```java
class TestPoly {
    public static void main(String[] args) {
        Bank bank = new Bank();
        
        // Overloads based on parameter type
        bank.deposit(5000.0);     // Calls deposit(double)
        bank.deposit("check123"); // Calls deposit(String)
        bank.deposit(1, 2, 3000); // Calls deposit(long, long, double)
    }
}
```

⚠ **Compilation Errors**:
- `bank.deposit();` (no args) → No suitable method found
- `bank.deposit(5.000000001);` (double literal) → No suitable method if no double parameter

### Method Overriding

Method overriding provides polymorphism based on subtype. It involves redefining a superclass method in a subclass with the same signature but different logic, tailored to subclass requirements.

#### How to Develop Overriding
- Superclass method exists
- Subclass redefines same method with same signature (name, parameters)
- Return type must be same or covariant (subclass type)
- Cannot override with reduced visibility (public → private)
- Purpose: Subclass-specific logic

#### Example Code: Bank Override in HDFC Bank

```java
class Bank {
    public void deposit(double cash) {
        System.out.println("Bank deposit of cash");
    }
    
    public static void bankName() {
        System.out.println("Bank class bank name");
    }
}

class HDFCBank extends Bank {
    // Override non-static method
    public void deposit(double cash) {
        System.out.println("HDFC Bank deposit of cash");
    }
    
    // Hide static method
    public static void bankName() {
        System.out.println("HDFC class bank name");
    }
    
    public void payInterest() {
        System.out.println("Pay interest HDFC Bank");
    }
}
```

#### Lab Demo: Override Execution

```java
class TestOverride {
    public static void main(String[] args) {
        Bank hb = new HDFCBank();
        hb.deposit(5000);       // Searches in Bank, executes from HDFCBank
        hb.deposit("5000");     // Searches in Bank, executes from Bank (no override)
        // hb.payInterest();    // ERROR: not in reference type Bank
        
        Bank bank2 = new HDFCBank();
        bank2.deposit(5000);    // Executes HDFCBank deposit
        // bank2.payInterest();  // ERROR: method not found during compilation
        ((HDFCBank)bank2).payInterest(); // Explicit cast works
        
        Bank.staticMethod();   // Executes Bank static method
    }
}
```

### Method Hiding for Static Methods

Static method "hiding" is similar to overriding but applies to static methods. Unlike non-static methods, static methods are bound to the reference type (compile-time), not the object type.

- Superclass and subclass have static methods with same signature
- Searched and executed from reference type class only
- No runtime polymorphism for static methods

#### Key Differences:
- **Overriding** (non-static): Search in superclass, execute from subclass
- **Hiding** (static): Search and execute in reference type class

### Flow of Execution in Polymorphism

#### Compilation Rules
- Compiler searches method in reference variable type class
- Checks superclasses up to `java.lang.Object` if not found
- Does NOT search subclasses

#### Runtime Rules
- JVM executes from object type for non-static methods
- Static methods execute from reference type
- Non-static overridden methods: Runtime goes to subclass
- Static hidden methods: Remain in reference type

#### Three Cases
1. **Same Type Variable and Object**: Search and execute in same class
2. **Subclass Variable with Subclass Object**: Execute from subclass
3. **Superclass Variable with Subclass Object**: Search in superclass, execute from subclass for non-static (runtime polymorphism)

#### Polymorphism Types Based on Signature Analysis
- Same signature, non-static: **Overriding**
- Same signature, static: **Hiding**
- Same name, different parameters: **Overloading**

## Summary

### Key Takeaways
```diff
+ Polymorphism = Multiple behaviors for same operation
+ Based on subtype (overriding) or parameter values (overloading)
+ Method represents behavior in programming
+ Overloading: Same class, different parameters
+ Overriding: Subclass redefines superclass method
+ Hiding: Static method redefinition (no runtime polymorphism)
+ Compilation searches reference type, execution from object type (non-static)
+ Static methods bound to reference type at compile and runtime
```

### Expert Insight
**Real-world Application**: Polymorphism enables flexible design patterns like Strategy Pattern, where different algorithms implement same interface (e.g., payment processors: CreditCard, PayPal, BankTransfer all implement PaymentProcessor.pay()).

**Expert Path**: Master polymorphic design by focusing on LSP (Liskov Substitution Principle) - subclass objects should be replaceable with superclass objects. Practice with factory patterns and abstraction layers.

**Common Pitfalls**:
- Attempting to override method with different parameters (leads to overloading, not overriding)
- Calling subclass-specific methods through superclass reference without compilation check
- Confusing hiding with overriding for static methods
- Ignoring accessibility modifiers (cannot reduce visibility in override)

Lesser known things about this topic: Polymorphism resolution happens at compile-time for overloading (based on reference types) and runtime for overriding (based on object types). This enables dynamic binding, where JVM determines actual method at execution time using virtual method tables.
