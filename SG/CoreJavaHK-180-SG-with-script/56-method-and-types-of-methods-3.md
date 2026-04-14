# Session 56: Method and Types of Methods 3

- [Method and Types of Methods 3](#method-and-types-of-methods-3)
  - [Overview](#overview)
  - [Key Concepts: Static vs Non-Static Methods](#key-concepts-static-vs-non-static-methods)
    - [Recap of Abstract Methods](#recap-of-abstract-methods)
    - [Definitions: Static and Non-Static Methods](#definitions-static-and-non-static-methods)
    - [Why and When to Use Static Methods](#why-and-when-to-use-static-methods)
    - [Why and When to Use Non-Static Methods](#why-and-when-to-use-non-static-methods)
    - [Access Rules: Variables in Static Methods](#access-rules-variables-in-static-methods)
    - [Access Rules: Variables in Non-Static Methods](#access-rules-variables-in-non-static-methods)
    - [Calling and Executing Methods](#calling-and-executing-methods)
    - [Recommendations and Rules](#recommendations-and-rules)
  - [Lab Demo: Bank Account Application](#lab-demo-bank-account-application)
- [Summary](#summary)
  - [Key Takeaways](#key-takeaways)
  - [Expert Insight](#expert-insight)

## Method and Types of Methods 3

### Overview
In this session, you will learn about static and non-static methods in Java, including their definitions, purposes, rules for variable access, method calling conventions, and practical implementation through a Bank Account application. This builds on your understanding of methods from previous sessions, focusing on how static methods execute common logic for all objects while non-static methods handle object-specific operations. The session covers memory allocation, access rules, and design recommendations to avoid common pitfalls like unnecessary object creation.

### Key Concepts: Static vs Non-Static Methods
Java methods are categorized based on the `static` keyword: static methods operate at the class level, while non-static methods operate at the object level. Understanding when to use each type is crucial for efficient code design, memory management, and logical separation of concerns.

#### Recap of Abstract Methods
- **Abstract Methods**: When a method's implementation logic varies between subtypes, declare it as abstract in the superclass to force subclasses to provide concrete implementations.
- **Concrete Methods**: When a method's implementation is identical for all subclasses, provide a concrete implementation in the superclass for reuse.
- **Example**: In a `Shape` class, the `findArea` method is abstract because area calculation differs for circles vs. rectangles. In a `Bus` class, a `brakes` method is concrete as it applies similarly to all bus types.

#### Definitions: Static and Non-Static Methods
- **Static Method**: A method declared with the `static` keyword, independent of object instances, used for class-level operations common to all objects.
- **Non-Static Method**: A method declared without the `static` keyword, invoked via an object, used for operations specific to individual objects.

#### Why and When to Use Static Methods
Static methods execute logic common to all objects without requiring an object instantiation. They are ideal for utilities, factory methods, or operations that don't depend on instance variables. Key scenarios:
- Performing calculations or computations that don't vary by object.
- Initializing class-level data.
- Providing helper functions accessible without object creation.

```java
class MathUtils {
    static int add(int a, int b) {
        return a + b;
    }
}
```

> [!NOTE]
> Static methods cannot access non-static variables directly; you must create an object to reference them, consuming unnecessary memory if not needed.

#### Why and When to Use Non-Static Methods
Non-static methods execute logic specific to an object, allowing instance variables to be accessed directly. They are mandatory when operations involve per-object data. Key scenarios:
- Modifying or reading instance variables.
- Performing actions like depositing into a specific bank account.
- Any logic where the result depends on the object's state.

```java
class Account {
    int balance;
    
    void deposit(int amount) {
        balance += amount;  // Accesses this object's balance
    }
}
```

> [!IMPORTANT]
> Non-static methods require an object to invoke, even if they don't access non-static variables, due to potential oversight in design.

#### Access Rules: Variables in Static Methods
Inside static methods, you can access:
- Static variables directly by name.
- Parameter and local variables.
- Non-static variables only via explicit object references.

```diff
- Non-static variables cannot be accessed directly; this will cause a compiler error.
+ Static variables and locals/parameters are fully accessible.
```

Example of valid static method access:
```java
class Example {
    static int staticVar = 10;
    int instanceVar = 20;
    
    static void staticMethod() {
        System.out.println(staticVar);  // Allowed
        Example obj = new Example();
        System.out.println(obj.instanceVar);  // Allowed via object
    }
}
```

#### Access Rules: Variables in Non-Static Methods
Inside non-static methods, you can access:
- Static variables directly.
- Non-static variables directly (implicitly from the calling object).
- Parameter and local variables.

```diff
+ All variable types are accessible, with non-static variables tied to the current object.
- No restrictions, but static variables are shared across all instances.
```

Example:
```java
class Example {
    static int staticVar = 10;
    int instanceVar = 20;
    
    void nonStaticMethod() {
        System.out.println(staticVar);      // Allowed
        System.out.println(instanceVar);    // Allowed
    }
}
```

#### Calling and Executing Methods
- **Static Methods**: Invoke via class name or object (e.g., `MathUtils.add(5, 3)` or `obj.add(5, 3)`). Object reference is ignored if passed.
- **Non-Static Methods**: Invoke via object only (e.g., `obj.deposit(1000)`). Calling via class name causes a compiler error.

Key behavior:
- Static methods do not receive the implicit `this` reference.
- Non-static methods receive `this`, pointing to the calling object, enabling access to instance variables.

```diff
+ Static methods: No object context; efficient for shared logic.
- Non-Static methods: Require object; object-specific execution.
```

#### Recommendations and Rules
| Scenario | Variable Types Accessed | Recommended Method Type | Reason |
|----------|-------------------------|-------------------------|---------|
| Static variables only + locals/parameters | Static, local, parameter | Static (recommended) | No object needed; saves memory/time |
| Non-static variables involved | Non-static, possibly static | Non-static (mandatory) | Logic depends on specific object |
| Mix of all variable types | Static, non-static, local, parameter | Non-static (mandatory) | Must access object-specific data |
| Empty method or no variables | None | Static (recommended) | Avoids unnecessary object creation |

- **Rule**: Static method creation is recommended when no non-static variables are accessed; it's mandatory to use non-static if they are.
- **Rule**: Non-static methods must be called via objects; static methods can be called via class or object.

> [!WARNING]
> Creating non-static methods when static suffices wastes memory (object overhead) and time. Conversely, forcing non-static access in static contexts fails compilation.

### Lab Demo: Bank Account Application
This lab demonstrates static and non-static methods in a real-world Bank Account application. Static variables store bank-wide data (e.g., bank name), while non-static variables hold account-specific data. Static methods initialize bank details, non-static methods handle account operations.

**Steps:**

1. **Create the BankAccount Class**:
   ```java
   class BankAccount {
       // Static variables (common to all accounts)
       static String bankName;
       static String branchName;
       static String ifsc;
       
       // Non-static variables (per account)
       long accountNumber;
       String accountHolderName;
       double balance;
       
       // Static method to set bank details
       static void setBankDetails(String bName, String bBranch, String bIfsc) {
           bankName = bName;
           branchName = bBranch;
           ifsc = bIfsc;
       }
       
       // Static methods to display bank details
       static void displayBankName() {
           System.out.println("Bank Name: " + bankName);
       }
       
       static void displayBranchName() {
           System.out.println("Branch Name: " + branchName);
       }
       
       static void displayIfsc() {
           System.out.println("IFSC: " + ifsc);
       }
       
       // Non-static method to set account details
       void setAccountDetails(long accNum, String holder, double bal) {
           accountNumber = accNum;
           accountHolderName = holder;
           balance = bal;
       }
       
       // Non-static method to display full account details
       void display() {
           System.out.println("Bank Name: " + bankName);
           System.out.println("Branch Name: " + branchName);
           System.out.println("IFSC: " + ifsc);
           System.out.println("Account Number: " + accountNumber);
           System.out.println("Account Holder: " + accountHolderName);
           System.out.println("Balance: " + balance);
       }
       
       // Non-static business methods
       void deposit(double amount) {
           balance += amount;
       }
       
       void withdraw(double amount) {
           if (balance >= amount) {
               balance -= amount;
           } else {
               System.out.println("Insufficient funds");
           }
       }
       
       void showBalance() {
           System.out.println("Current Balance: " + balance);
       }
   }
   ```

2. **Create a Test Class**:
   ```java
   class BankTest {
       public static void main(String[] args) {
           // Set bank details (static method)
           BankAccount.setBankDetails("HDFC", "Amritsar", "HD123AM");
           
           // Create account objects
           BankAccount acc1 = new BankAccount();
           BankAccount acc2 = new BankAccount();
           
           // Set account details (non-static methods)
           acc1.setAccountDetails(1234, "HK", 25000);
           acc2.setAccountDetails(5678, "BK", 27000);
           
           // Perform operations
           acc1.deposit(7000);
           acc2.withdraw(5000);
           
           // Display details
           acc1.display();
           acc2.display();
       }
   }
   ```

3. **Run and Observe**:
   - Static methods affect all objects (e.g., bank details shared).
   - Non-static operations affect only the specific account.
   - Compile and execute to see object-specific vs. class-level behavior.

> [!TIP]
> Avoid hardcoding values in methods; use parameters for flexibility across different banks/customers.

## Summary

### Key Takeaways
```diff
+ Static methods execute logic common to all objects; access static variables directly, non-static only via objects.
+ Non-static methods execute logic specific to an object; access all variables directly.
+ Use static methods when no non-static variables are needed; mandatory non-static otherwise.
+ Call static methods via class name; non-static via object to avoid compilation errors.
- Forgetting object context in non-static methods leads to runtime errors; static misdesign wastes memory.
! Static variables are shared across objects; non-static are per-instance – design accordingly.
```

### Expert Insight

**Real-world Application**: In enterprise Java applications, static methods are often used in utility classes (e.g., `Math` or custom helpers like `StringUtils`) to perform operations without object overhead. Non-static methods dominate model classes (e.g., in Spring Boot entities) for business logic tied to specific data. For example, a `UserService` class might have static helper methods for password hashing and non-static methods for updating user profiles.

**Expert Path**: Master method types by analyzing memory diagrams – visualize static variables in method area vs. instance variables in heap. Practice with tools like VisualVM to observe memory usage. Dive into JVM internals via bytecode (use `javap`) to see how the `invokestatic` and `invokevirtual` instructions differ. This builds toward advanced topics like singleton patterns (static factories) and dependency injection (non-static services).

**Common Pitfalls**: 
- Missed corrections: "I created a variable as a static then what happened what compiler do what jvm will do" – clarified that static variables get one copy of memory per class.
- Mistake: Assuming static methods receive implicit object references – they don't, preventing non-static access.
- Avoidance: Always create objects for non-static methods; hardcode only for single-purpose (avoid shared projects). Common error: "non-static variable balance cannot be referenced from a static context" – fix by making the method non-static.
- Lesser known: Static blocks can initialize static variables before main execution; non-static inner classes can access outer instance variables, blending scopes.
- Resolution: Use IDEs like IntelliJ to detect access violations; refactor by checking method signatures against variable usage. Avoid overusing static – it leads to thread-unsafe code in concurrent environments. Practice refactoring: Convert static to non-static only when per-object logic emerges.
