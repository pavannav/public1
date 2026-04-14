# Session 57: Method and Types of Methods 4

## Table of Contents
- [Private and Non-Private Methods](#private-and-non-private-methods)
- [Void and Non-Void Methods](#void-and-non-void-methods)
- [Homework Assignment](#homework-assignment)

## Private and Non-Private Methods

### Overview
This session explores the concepts of private and non-private (public) methods in Java, building on previous discussions. Private methods are access-restricted members intended for internal use within a class, often as helper methods performing auxiliary operations. Non-private methods (typically public) are designed for external access, allowing other classes or programmers to invoke primary functionality. The distinction aids in encapsulation, controlling access to class operations, and preventing direct execution of auxiliary logic.

### Key Concepts

#### 1. Definition of Private and Non-Private Methods
A method is declared private using the `private` keyword, making it inaccessible from outside the class. Any method without `private` (e.g., default, protected, public) is non-private. Examples:
- Private method: `private void myMethod() { ... }`
- Non-private method: `public void myMethod() { ... }` or just `void myMethod() { ... }` (default access)

Private methods can be static or non-static, just like non-private methods. The rules based on `private` focus on access control, not internal logic.

#### 2. Why Use Private and Non-Private Methods?
- **Non-Private Methods**: These represent the primary operations of a class that external programmers or systems should access directly. For example, in a bank account class, `deposit()`, `withdraw()`, and `displayBalance()` are non-private to allow ATM or bank programmers to invoke them.
- **Private Methods**: These perform auxiliary or supporting operations that should not be executed individually. They are invoked internally by non-private methods. For instance, an `alert()` method for sending notifications is private because it supports `deposit()` and `withdraw()`, not as a standalone feature.

This separation avoids code redundancy and enforces controlled access. In real-world applications, private methods enhance maintainability by allowing modular helper functions.

#### 3. Access Rules for Private Methods
- Within the same class, private methods are accessible everywhere, including from other methods.
- From other classes, private methods are inaccessible, triggering a compile-time error: "private access" or similar.
- Private access prevents external misuse. For example:
  - If `alert()` is private, calling `account.alert()` from outside the class fails.
  - Only non-private methods can invoke private ones internally.

#### 4. Statements Allowed Inside Private Methods
No special rules; all statements permissible in non-private methods are allowed here. The `private` keyword affects access, not logic.

#### 5. Rules for Defining and Invoking Private Methods
- **Defining**: No restrictions beyond standard Java method rules.
- **Invoking**: Cannot be called from other classes. Must be invoked by the class developer within non-private methods.
- **Purpose**: Declare private when a method performs part of another operation, not a main individual action.

#### 6. Real-Time Examples
Using a bank account application:
- **Non-Private Operations** (main features):
  - `deposit(amount)`: Allows direct deposits.
  - `withdraw(amount)`: Allows direct withdrawals.
  - `getCurrentBalance()`: Returns balance.
- **Private Operation** (helper):
  - `alert(message, amount)`: Sends SMS/email notifications after transactions. Called internally by `deposit()` and `withdraw()`, not directly accessible.

This prevents unauthorized alert calls (e.g., by a hacker) while ensuring alerts trigger automatically with valid operations.

**BankAccount.java Example Enhancements**:
```java
class BankAccount {
    // Fields declared private for encapsulation
    private String accountNumber;
    private String bankName;
    private String branchName;
    private String ifsc;
    private double balance;

    // Constructor (assume default)
    BankAccount(String accNum, String bank, String branch, String ifscCode) {
        this.accountNumber = accNum;
        this.bankName = bank;
        this.branchName = branch;
        this.ifsc = ifscCode;
        this.balance = 0.0;
    }

    // Public non-private methods (main operations)
    public void deposit(double amount) {
        balance += amount;
        alert("credited to", amount);  // Internal call to private method
    }

    public void withdraw(double amount) {
        if (balance >= amount) {
            balance -= amount;
            alert("debited from", amount);  // Internal call to private method
        }
    }

    public double getCurrentBalance() {
        return balance;  // Returns, but does not print
    }

    public void display() {
        System.out.println("Account: " + accountNumber + ", Bank: " + bankName + ", Balance: " + balance);
    }

    // Private helper method
    private void alert(String message, double amount) {
        System.out.println(amount + " is " + message + " your account " + accountNumber + ". Available balance: " + balance);
    }
}
```

All variables are private to prevent direct access. Methods are public for package access (adjust with `public` if needed for different packages).

#### 7. When to Declare Methods as Private?
When performing operations as part of another operation, not standalone. Avoids direct calls that could misuse functionality.

#### 8. Developing Bank Account with Private and Non-Private Methods
Integrated as above. Private `alert()` ensures consistent notifications. Full implementation prevents unauthorized access.

> [!NOTE]
> Access modifiers like `public` ensure cross-package visibility if classes are in different packages.

## Void and Non-Void Methods

### Overview
Void methods do not return values, performing actions without producing output data. Non-void methods return values (primitive or reference types), allowing computation results to be used elsewhere. This distinction determines method purpose, return type declaration, and invocation rules. Void for actions, non-void for computations.

### Key Concepts

#### 1. Definition of Void and Non-Void Methods
- **Void Method**: Return type is `void`. Examples: `void display() { System.out.println("Hello"); }`
- **Non-Void Method**: Return type is any valid type (primitive: int, double; reference: class, array). Examples: `int add(int a, int b) { return a + b; }`

| Aspect                  | Void Method                  | Non-Void Method               |
|-------------------------|------------------------------|-------------------------------|
| Return Type            | void                        | Primitive/Reference type     |
| Does It Return Value?  | No                          | Yes                          |
| Usage                  | Actions (print, update)     | Computations (calculate)     |
| Required Statements    | Optional return;            | Must have return statement   |
| Call Styles            | 1 way (direct)              | 5 ways (direct, assign, arg, expr, return) |

#### 2. When to Use Void vs. Non-Void
- Use **void** when no value needs return (e.g., printing messages, updating state).
- Use **non-void** when returning results (e.g., adding numbers, fetching data).
- Decision based on logic: Deposit is void (modifies state, gives alert implicitly). Withdraw could be void or non-void (returns withdrawn amount in real apps), but typically void here. Current balance returns value, so non-void.

#### 3. Determining Return Type
- Primitive: `int` for integers, `double` for decimals, `boolean` for true/false, etc.
- Reference: Class name (e.g., `Employee` returning object), `String`, arrays (`int[]`), collections.
- Lesser range values (e.g., char) implicitly convert to higher (int), but return type must match or be compatible.

#### 4. Returning Values in Non-Void Methods
- Use the `return` keyword: `return value` (e.g., `return 5;`).
- Execution terminates, control back to caller.
- Must return a value; compiler enforces.

#### 5. Forms of Return Statement
- `return;` (void methods): Terminates, optional.
- `return value;` (non-void): Terminates and returns.

Rules:
- After `return;`, no statements allowed (compile error "unreachable statement").
- `return;` only in void; `return value;` only in non-void.
- Compiler implicitly adds `return;` at method end in void methods.

#### 6. Method Invocation Styles
Based on return type:
- **Void Methods**: Only 1 way – direct call: `myVoidMethod();`
- **Non-Void Methods**: 5 ways:
  1. Direct: `myNonVoidMethod();` (value returned to void).
  2. Assign to variable: `int x = myNonVoidMethod();`
  3. As argument: `anotherMethod(myNonVoidMethod());`
  4. In expression: `int y = 10 + myNonVoidMethod();`
  5. As return value: `return myNonVoidMethod();`

Void methods in other 4 styles cause compile errors ("void cannot be used in...").

**Example Code**:
```java
class MethodDemo {
    static void m1() { System.out.println("M1 executed"); }  // Void
    static int m2() {
        System.out.println("M2 executed");
        return 5;
    }
    static void m3(int x) {
        System.out.println("M3: x = " + x);
    }

    public static void main(String[] args) {
        // Void method call
        m1();  // Only direct call

        // Non-void method calls
        m2();  // Direct (value discarded)
        int val = m2();  // Assign (val = 5)
        m3(m2());  // Argument (passes 5)
        int calc = 10 + m2();  // Expression (10 + 5 = 15)
        System.out.println(calc);  // Output: M2 executed, then M3: x=5, then 15 with outputs
    }
}
```

Output explanation: Non-direct calls execute method, use return value. Direct void executes and completes.

#### 7. Rules for Void Methods
- Empty allowed.
- Optional `return;`.
- No return value constraints.

#### 8. Rules for Non-Void Methods
- Not empty; must have `return value;`.
- Return value must match type (same or higher range).

#### 9. Developing Program with Void and Non-Void
Enhanced BankAccount with void/non-void:
- `deposit(double)`: Void.
- `withdraw(double)`: Void.
- `getCurrentBalance()`: Non-void (returns double).
- `alert()`: Private void.

**Full Example Execution**:
Running the enhanced BankAccount:
```
1000 is credited to your account 12345. Available balance: 1000
2000 is debited from your account 12345. Available balance: 800
Balance: 800
```

Private `alert` enforces internal use.

### Code/Config Blocks
All code in Java, using syntax highlighting.

### Lab Demos
1. Implement BankAccount with private alert: Follow code above; use public for cross-package if needed.
2. Void/Non-Void Demo: Run example code; observe outputs for each call style.

## Homework Assignment

Implement a program with:
- `Student` class: Fields like `name`, `rollNo`, `marks` (private).
- `College` class: 
  - Void method: Create Student object (e.g., HK), display values.
  - Non-Void method: Create Student object (e.g., BK), return it.
- `Test` class: Call College methods, display returned object.

Example Structure:
```java
class Student { /* fields, constructor, getters */ }

class College {
    public static void createAndDisplayStudent() {
        Student s = new Student("HK", 1, 95.0);
        System.out.println("Void: " + s.getName() + ", Marks: " + s.getMarks());
    }

    public static Student createAndReturnStudent() {
        Student s = new Student("BK", 2, 85.0);
        return s;
    }
}

class Test {
    public static void main(String[] args) {
        College.createAndDisplayStudent();
        Student s = College.createAndReturnStudent();
        System.out.println("Returned: " + s.getName() + ", Marks: " + s.getMarks());
    }
}
```

Share code in the group for verification.

## Summary

### Key Takeaways
+ Private methods: Internal helpers, inaccessible externally, enforced encapsulation.
- Non-private methods: Public interfaces for main operations.
+ Void methods: For actions, called directly only.
- Non-void methods: For computations, 5 call styles; must return values.

### Expert Insight
- **Real-world Application**: In banking apps, private methods handle secure conversions or validations (e.g., checksums), called by public APIs without exposing internal logic.
- **Expert Path**: Master encapsulation by defaulting to private, exposing only necessary APIs. Practice inheritance where access modifiers interact (e.g., protected for subclasses).
- **Common Pitfalls**: Forgetting `return;` in non-void methods (compile error: "missing return statement"). Mismatching return types (e.g., int method returning double without cast). Calling voids in expressions (error nightmare). Direct external private calls (security risk).
- **Resolution**: Always check for return in non-void. Unit test all call styles. Use IDEs for access warnings.
- **Lethal Known Things**: Compiler implicit `return;` adds in void. Void methods terminate but don't pass data, causing data loss if not handled right. Returning char promotes to int seamlessly.
