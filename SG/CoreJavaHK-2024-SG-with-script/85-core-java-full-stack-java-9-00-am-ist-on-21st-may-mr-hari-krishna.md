# Session 85: Exception Types and Custom Exceptions

## Types of Exceptions

### Overview
In Java programming, exceptions represent abnormal conditions that occur during program execution. When developing business logic to handle user input, if wrong values are provided, developers should throw exceptions and handle them appropriately. This allows for stopping abnormal program termination and continuing execution with user-understandable messages or alternative logic. Exceptions are divided into types based on their source and handling requirements, helping developers recover from errors like wrong inputs, wrong logic, or missing resources.

### Key Concepts/Deep Dive

#### Throwable Class Hierarchy
- **Throwable as the Root Class**: 
  - The `Throwable` class is the superclass of all exception classes in Java, inherited from `Object`.
  - It represents runtime errors, which can originate from the JVM or the program itself.
  - Two main subclasses:
    - **Error**: Contains exceptions coming from JVM internal problems (e.g., memory issues).
    - **Exception**: Contains exceptions coming from program-level problems (e.g., wrong input or logic).

- **Error Subclasses**:
  - Represent JVM-level issues.
  - Examples: `OutOfMemoryError`, `StackOverflowError`, `NoClassDefFoundError`.
  - **Unrecoverable**: Catching error exceptions does not allow program continuation, as JVM internal problems require terminating the program and fixing the logic (e.g., destroying unreferenced objects for garbage collection).

- **Exception Subclasses**:
  - Represent program-level issues, further divided into:
    - **Runtime Exception and Its Subclasses**: Unchecked exceptions.
    - **Direct Subclasses of Exception**: Checked exceptions.

#### Error vs. Exception Differentiation

| Aspect | Error | Exception |
|--------|-------|-----------|
| Source | JVM internal problems | Program-level problems (wrong values, wrong logic, missing resources) |
| Handling | Unchecked (no compulsion to catch) | Varied (checked or unchecked) |
| Recovery | Unrecoverable; program must terminate | Recoverable via alternative logic or user messages |

- **Interviews Tip**: Error exceptions represent JVM problems, while Exceptions handle program issues. We catch Exceptions to recover (e.g., via alternative logic), but not Errors, as they're unrecoverable.

#### Checked Exceptions vs. Unchecked Exceptions
- **Checked Exceptions**:
  - **Definition**: Exceptions where the compiler checks if they are handled. Failure to handle results in compile-time errors.
  - **Classes Involved**: `Throwable`, `Exception`, and their direct subclasses (except `RuntimeException`).
  - **Purpose**: Represent missing resources (e.g., file not available, database connection issues). Force developers to handle them during development to avoid runtime failures.
  - **Handling**: Either by using `try-catch` or declaring with `throws` keyword.
  - **Examples**: `ClassNotFoundException`, `FileNotFoundException`, `SQLException`.
  - **Real-World Analogy**: Like a mandatory "road damaged" board on a highway (high-speed road where ignoring could cause life-threatening issues). Developers check resources at compilation time.

- **Unchecked Exceptions**:
  - **Definition**: Exceptions where the compiler does not force handling. No compile-time errors if unhandled, but runtime exceptions may occur.
  - **Classes Involved**: `Error`, `RuntimeException`, and their subclasses.
  - **Purpose**: Represent wrong values or logic. Lesser impact when unhandled (e.g., program terminates abnormally but data may not be critically lost).
  - **Handling**: Optional.
  - **Examples**: `ArithmeticException`, `NullPointerException`, `ArrayIndexOutOfBoundsException`, `IllegalArgumentException`.
  - **Real-World Analogy**: Like up-and-downs on a colony road (low-speed, walking pace) without a board; people can observe and avoid them, but if not, minimal harm like minor injuries.

- **Compiler Verification Mechanism**:
  - Internally uses `instanceof` operator:
    - If exception is `instanceof Error` or `instanceof RuntimeException` → Unchecked (no enforcement).
    - Else → Checked (enforced by compiler).
  - Justification for Categories:
    - High probability of issues (e.g., missing files) → Checked (mandatory handling).
    - Low probability or recoverable issues (e.g., wrong user input) → Unchecked (optional).

#### Custom Exceptions (User-Defined Exceptions)
- **Why Create Custom Exceptions?**
  - Predefined exceptions exist, but for project-specific runtime errors (e.g., negative amount in bank deposit), no matching predefined class.
  - Developers create their own to fit business logic.

- **Steps to Create Custom Exceptions**:
  1. Create a class extending `Exception` for checked exceptions (recommended) or `RuntimeException` for unchecked (less common).
  2. Define two constructors:
     - No-parameter constructor.
     - Parameterized constructor accepting a `String` message.
  3. In both constructors, call `super(message)` to pass the message to the parent class for storage.
     ```java
     public class NegativeNumberException extends Exception {
         public NegativeNumberException() {
             super();
         }
         public NegativeNumberException(String message) {
             super(message);
         }
     }
     ```
  4. In business logic, check conditions and throw the custom exception with a message (e.g., `throw new NegativeNumberException("Don't pass negative values");`).
  5. Report the exception using `throws` or handle with `try-catch` in calling methods.
  6. In user-facing code, catch and handle appropriately (e.g., print user-friendly messages or execute alternatives).

- **Recommendation**: 99% of custom exceptions should extend `Exception` (checked), forcing mandatory handling. Only 1% as unchecked if handling is truly optional. Checked exceptions ensure "supervision" from database layer to UI (like water pipeline checks from source to destination).

#### Exception Handling Flow
- **Business Logic Method**: Take input, validate, throw exception if invalid, report with `throws`.
- **User Logic Method**: Call business method, catch exceptions with `try-catch`, print user-understandable messages or execute alternative logic.
- **External Resource Handling**: For databases/files, handle potential exceptions (e.g., `SQLException`, `FileNotFoundException`) as checked, verifying them at development time.

### Lab Demos

#### Program Demonstrating Checked vs. Unchecked Exceptions
- **Code Example 1: Unchecked Exception (RuntimeException Subclass)**:
  ```java
  class Test {
      public static void m1() throws ArithmeticException {
          throw new ArithmeticException();  // Unchecked, no compile error even if unhandled
      }
      public static void main(String[] args) {
          m1();  // May cause runtime termination
      }
  }
  ```

- **Code Example 2: Checked Exception (Direct Subclass of Exception)**:
  ```java
  class Test {
      public static void m1() throws ClassNotFoundException {
          throw new ClassNotFoundException();  // Checked, compile error if unhandled
      }
      public static void main(String[] args) throws ClassNotFoundException {
          m1();  // Fixed by declaring throws
      }
      // Or handle with try-catch:
      // public static void main(String[] args) {
      //     try {
      //         m1();
      //     } catch (ClassNotFoundException e) {
      //         System.out.println(e.getMessage());
      //     }
      // }
  }
  ```

#### Small Project: Addition with Custom Exception for Negative Numbers
- **Project Structure**:
  - Three classes: `NegativeNumberException.java` (custom exception), `Addition.java` (business logic), `Test.java` (main class for user interaction).
  - **Step 1**: Create `NegativeNumberException.java`.
    ```java
    public class NegativeNumberException extends Exception {
        public NegativeNumberException() {
            super();
        }
        public NegativeNumberException(String message) {
            super(message);
        }
    }
    ```
  - **Step 2**: Create `Addition.java` (business logic class).
    ```java
    public class Addition {
        public static int add(int a, int b) throws NegativeNumberException {
            if (a < 0 || b < 0) {
                throw new NegativeNumberException("Don't pass negative values");
            }
            return a + b;
        }
    }
    ```
  - **Step 3**: Create `Test.java` (user interaction class).
    ```java
    import java.util.Scanner;
    public class Test {
        public static void main(String[] args) {
            Scanner sc = new Scanner(System.in);
            System.out.println("Enter first number:");
            int a = sc.nextInt();
            System.out.println("Enter second number:");
            int b = sc.nextInt();
            try {
                int result = Addition.add(a, b);
                System.out.println("Result: " + result);
            } catch (NegativeNumberException e) {
                System.out.println(e.getMessage());
            }
        }
    }
    ```
- **Execution Steps**:
  1. Compile all files: `javac NegativeNumberException.java Addition.java Test.java`.
  2. Run `Test`: Inputs like 10 and 20 output "Result: 30". Inputs like -10 and 20 output "Don't pass negative values".
- **Why Mandatory Handling?**: `NegativeNumberException` is checked; compiler enforces handling in `Test.java` via `throws` or `try-catch`.

## Summary

### Key Takeaways
```diff
+ Throwable is the root class for all exceptions, with Error for JVM issues and Exception for program issues.
+ Checked exceptions (e.g., ClassNotFoundException) are mandatory to handle, representing critical resources like files/DBs; unchecked (e.g., ArithmeticException) are optional for minor issues.
+ Custom exceptions enable project-specific error handling; extend Exception for checked, RuntimeException for unchecked, with recommended checked usage.
+ Handling flow: Throw in business logic, report with throws, catch in user logic for messages/alternatives.
- Avoid using custom exceptions as Error subclasses, as they create unnecessary hierarchies.
- Never rely solely on unchecked exceptions in production if data loss is possible, as they allow silent failures.
! Remember: Exceptions are for abnormal conditions, not normal flow control; overusing them makes code lengthy.
```

### Expert Insight

#### Real-World Application
In enterprise Java applications (e.g., JDBC for database ops), `SQLException` (checked) forces developers to handle potential DB failures during development, ensuring connections are verified before deployment. This prevents runtime crashes in production banking apps where unhandled exceptions could lead to data corruption or customer blackouts. Custom exceptions like "InsufficientFundsException" in banking APIs enforce conditional checks (e.g., balance > 0) and provide localized error messages to end-users, improving UX and security.

#### Expert Path
Master exception hierarchies by reading JDK docs for standard exceptions. Practice projects with layered handling: business layer throws, service layer catches, UI layer displays messages. In Spring Boot, combine with AOP for global exception handling. Advance to Java 17's sealed classes for more controlled custom exceptions, limiting inheritance to prevent misuse.

#### Common Pitfalls
- **Resolutions and Avoidance**:
  - **Using `Throwable` Class for Custom Exceptions**: Causes compilation successes but wrong design, creating extra hierarchies. Avoid by extending `Exception` or `RuntimeException`; test early with compiler checks.
  - **Unhandled Unchecked Exceptions**: Lead to abrupt termination without messages, losing data in loops/DB transactions. Always add `try-catch` with logging, even if optional, and use tools like SLF4J for tracing.
  - **Misprinting Exceptions ("execption" vs. "Exception")**: Causes typos in code/comments, leading to debugging issues. Correct immediately via IDE spell-check or peer reviews.
  - **Overusing Checked Exceptions**: Makes code bulky with excessive `throws`; resolve by grouping in wrapper exceptions (e.g., `BusinessException`); refactor logics with early validations to reduce throws.

- **Lesser-Known Aspects**: `RuntimeException` extends `Exception` but is unchecked due to compiler rules; Sun Microsystems categorized exceptions to balance strict handling (checked) vs. concise code (unchecked), improving readability for non-critical cases. In microservices, unchecked custom exceptions can propagate across services if not handled globally, unlike checked ones that enforce local containment.
