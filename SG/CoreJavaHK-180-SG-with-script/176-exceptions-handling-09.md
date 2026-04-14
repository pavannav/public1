# Session 9: 176 Exceptions Handling

- [Custom Exceptions](#custom-exceptions)
- [Best Practices](#best-practices)
- [Exception Chaining](#exception-chaining)
- [Finally Block Usage](#finally-block-usage)
- [Lab Demo: Implementing Custom Exceptions](#lab-demo-implementing-custom-exceptions)

## Custom Exceptions

### Overview

Custom exceptions in Java allow developers to create specialized exception types that are tailored to their application's specific error conditions. This is particularly useful in enterprise applications where different types of exceptions may need to be handled differently or where more specific error information needs to be communicated. Custom exceptions are created by extending existing exception classes, typically `Exception` or `RuntimeException`, and can include additional fields and methods to provide more detailed error information.

### Key Concepts/Deep Dive

#### Creating Custom Checked Exceptions

Custom checked exceptions extend the `Exception` class and must be declared in method signatures when they might be thrown.

```java
public class InsufficientFundsException extends Exception {
    private double requiredAmount;
    private double currentBalance;

    public InsufficientFundsException(String message, double requiredAmount, double currentBalance) {
        super(message);
        this.requiredAmount = requiredAmount;
        this.currentBalance = currentBalance;
    }

    // Getters for additional information
    public double getRequiredAmount() { return requiredAmount; }
    public double getCurrentBalance() { return currentBalance; }
    public double getShortfall() { return requiredAmount - currentBalance; }
}
```

#### Creating Custom Runtime Exceptions

Custom runtime exceptions extend `RuntimeException` and don't need to be declared in method signatures, though they can still be caught explicitly.

```java
public class InvalidAccountNumberException extends RuntimeException {
    private String invalidAccountNumber;

    public InvalidAccountNumberException(String message, String invalidAccountNumber) {
        super(message);
        this.invalidAccountNumber = invalidAccountNumber;
    }

    public String getInvalidAccountNumber() { return invalidAccountNumber; }
}
```

#### Best Practices for Custom Exceptions

- Always provide meaningful constructors that allow for message and/or cause parameters
- Include relevant business data in exception objects for better error reporting
- Use descriptive class names that clearly indicate the error condition
- Consider extending `RuntimeException` for programming errors, not business logic errors
- Provide getters for any additional data stored in the exception

### Lab Demo: Implementing Custom Exceptions

Follow these steps to implement custom exceptions in Java:

1. **Create a Custom Exception Class**

   ```java
   public class BankException extends Exception {
       private String accountNumber;
       private double amount;

       public BankException(String message, String accountNumber, double amount) {
           super(message);
           this.accountNumber = accountNumber;
           this.amount = amount;
       }

       public String getAccountNumber() { return accountNumber; }
       public double getAmount() { return amount; }
   }
   ```

2. **Create Specific Exception Subclasses**

   ```java
   public class InsufficientFundsException extends BankException {
       public InsufficientFundsException(String accountNumber, double required, double available) {
           super(String.format("Insufficient funds. Requested: %.2f, Available: %.2f", required, available),
                 accountNumber, required - available);
       }
   }

   public class InvalidAmountException extends BankException {
       public InvalidAmountException(String accountNumber, double amount) {
           super(String.format("Invalid amount: %.2f", amount), accountNumber, amount);
       }
   }
   ```

3. **Use Custom Exceptions in Business Logic**

   ```java
   public class BankAccount {
       private String accountNumber;
       private double balance;

       public void withdraw(double amount) throws InsufficientFundsException, InvalidAmountException {
           if (amount <= 0) {
               throw new InvalidAmountException(accountNumber, amount);
           }
           if (amount > balance) {
               throw new InsufficientFundsException(accountNumber, amount, balance);
           }
           balance -= amount;
       }
   }
   ```

4. **Handle Custom Exceptions**

   ```java
   public class BankService {
       public void processWithdrawal(String accountNumber, double amount) {
           try {
               BankAccount account = getAccount(accountNumber);
               account.withdraw(amount);
               System.out.println("Withdrawal successful");
           } catch (InsufficientFundsException e) {
               System.err.println("Error: " + e.getMessage());
               System.err.println("Please deposit at least " + e.getAmount());
           } catch (InvalidAmountException e) {
               System.err.println("Error: " + e.getMessage());
               System.err.println("Amount must be positive");
           }
       }
   }
   ```

## Best Practices

### Exception Handling Best Practices

#### 1. Use Checked Exceptions for Recoverable Conditions

Use checked exceptions when the caller can reasonably be expected to handle the error:

```java
public void transferMoney(Account from, Account to, double amount) throws InsufficientFundsException, AccountLockedException {
    // Implementation
}
```

#### 2. Use Runtime Exceptions for Programming Errors

Use runtime exceptions for bugs and programming mistakes:

```java
public void printBalance(Account account) {
    if (account == null) {
        throw new IllegalArgumentException("Account cannot be null");
    }
    // Continue with printing...
}
```

#### 3. Don't Ignore Exceptions

Never leave catch blocks empty:

```java
// Bad practice
try {
    riskyOperation();
} catch (Exception e) {
    // Ignoring the exception - very bad!
}

// Better practice
try {
    riskyOperation();
} catch (Exception e) {
    logger.error("Error occurred during risky operation", e);
    throw new RuntimeException("Operation failed", e);
}
```

#### 4. Provide Meaningful Error Messages

Always include context information:

```java
// Bad
throw new RuntimeException("Error");

// Good
throw new AccountNotFoundException("Account " + accountId + " not found in database");
```

#### 5. Prefer Specific Exceptions Over Generic Ones

```java
// Bad
throw new Exception("Database connection failed");

// Better
throw new DatabaseConnectionException("Failed to connect to MySQL database at " + host + ":" + port, cause);
```

## Exception Chaining

### Exception Chaining

Exception chaining allows you to preserve the original exception while adding context:

```java
public class ServiceException extends Exception {
    public ServiceException(String message, Throwable cause) {
        super(message, cause);
    }
}

try {
    databaseOperation();
} catch (SQLException e) {
    throw new ServiceException("Database operation failed", e);
}
```

## Finally Block Usage

### Finally Block Usage

The `finally` block executes regardless of whether an exception is thrown:

```java
public void processFile(String fileName) {
    FileInputStream fis = null;
    try {
        fis = new FileInputStream(fileName);
        // Process file
    } catch (IOException e) {
        logger.error("Error processing file " + fileName, e);
    } finally {
        if (fis != null) {
            try {
                fis.close(); // Always close resources
            } catch (IOException e) {
                logger.warn("Error closing file " + fileName, e);
            }
        }
    }
}
```

📝 **Note**: As of Java 7, try-with-resources is preferred for resource management.

## Summary

### Key Takeaways

```diff
+ Custom exceptions improve code readability and error handling specificity
+ Checked exceptions for recoverable errors, runtime exceptions for programming errors
+ Always handle exceptions appropriately - never ignore them
+ Use exception chaining to preserve original error information
+ Follow the principle: "Fail fast and fail loudly"
```

### Expert Insight

#### Real-world Application

In enterprise systems, custom exceptions enable:
- Better error reporting and debugging
- Specific error handling strategies per error type
- Improved API design and client integration
- Enhanced monitoring and alerting capabilities

#### Expert Path

- Study existing exception hierarchies in the JDK and popular frameworks
- Practice creating meaningful exception hierarchies
- Master exception patterns used in frameworks like Spring
- Learn about exception handling in concurrent programming

#### Common Pitfalls

1. Creating too many exception types
2. Catching `Exception` instead of specific exceptions
3. Using exceptions for normal flow control
4. Losing exception context through improper chaining
5. Not properly cleaning up resources in finally blocks

**Common issues with resolution and how to avoid them:**
1. **Too many exceptions**: Review and consolidate similar exceptions. Avoid proliferating exceptions without clear benefits.
2. **Generic catching**: Be specific in catch blocks. Use multi-catch syntax (`catch (IOException | SQLException e)`) for related exceptions.
3. **Normal flow control**: Use `if` statements for predictable conditions. Exceptions should signal unexpected errors, not control logic.
4. **Lost context**: Always use exception chaining (e.g., `initCause()` or `Throwable` constructor). Ensure the original cause is preserved.
5. **Resource cleanup**: Use try-with-resources; implement `AutoCloseable` for custom resources. Avoid manual resource management in `finally` blocks.

#### Lesser known things about this topic

- Exceptions are not expensive if not thrown frequently; the primary cost is stack trace generation
- Stack trace generation can be expensive - consider disabling for performance-critical code (use `-XX:+DisableExplicitGC` JVM flag for testing)
- Custom exceptions can implement complex business logic; they can be used to encapsulate error handling strategies
- Java 9 introduced convenience methods like `Throwable::addSuppressed` for better resource management in multi-resource scenarios
- Exception handling can affect JIT compilation; frequent throwing might lead to de-optimization of hot paths
