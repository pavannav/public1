# Session 55: Method and Types of Methods 2

## Table of Contents
- [Overview](#overview)
- [Key Concepts and Definitions](#key-concepts-and-definitions)
- [Method Declaration vs. Method Definition](#method-declaration-vs-method-definition)
- [Method Invocation and Calling](#method-invocation-and-calling)
- [Method Implementation, Overriding, Hiding, and Overloading](#method-implementation-overriding-hiding-and-overloading)
- [Sample Program: Calculating Percentage](#sample-program-calculating-percentage)
- [When and Where to Create Methods](#when-and-where-to-create-methods)
- [Types of Methods](#types-of-methods)
- [Modifiers for Methods](#modifiers-for-methods)
- [Summary](#summary)

## Overview

This session continues the exploration of methods in Java, building on the previous discussion of method fundamentals. We delve into advanced terminology, creation strategies, and classification of methods. Key topics include when to use abstract versus concrete methods, how methods are invoked and managed, and the various types of methods based on their modifiers and structure. The session emphasizes practical application through sample programs and provides clear guidelines for method design to ensure reusability and proper implementation in object-oriented programming.

## Key Concepts and Definitions

### Method Terminology
Methods in Java can be described using seven key terms, which form the foundation for understanding their structure and behavior. These terms are consistently used throughout programming and should instantly come to mind when working with any method.

- **Prototype**: The head portion of a method, consisting of modifiers, return type, method name, parameters, and throws exceptions. It defines the method's interface without implementation.
- **Body**: The region enclosed by opening and closing curly braces (`{ }`), which contains the method's logic.
- **Logic**: The executable statements placed inside the method body that perform the desired operations.
- **Signature**: The combination of the method name and parameter list, used for method identification and overloading.
- **Parameters**: Variables declared in the method's parentheses to receive input values from callers; divided into parameter type and parameter name.
- **Arguments**: The actual values passed to a method's parameters when invoking it; arguments depend on parameters but are optional if no parameters exist.
- **Method Name**: An identifier representing the operation performed by the method, chosen by the programmer to be meaningful and descriptive.
- **Return Type**: The data type specifying what value (if any) the method returns after execution; `void` indicates no return value.
- **Modifiers**: Keywords specifying access level and execution behavior, including accessibility (public, private, etc.) and execution (static, final, etc.) modifiers.

Visualize a method like this:

```java
public static int calculateSum(int a, int b) {
    int result = a + b;
    return result;
}
```

- Prototype: `public static int calculateSum(int a, int b)`
- Body: `{ int result = a + b; return result; }`
- Logic: `int result = a + b; return result;`
- Signature: `calculateSum(int a, int b)`
- Parameters: `int a`, `int b` (where `int` is type, `a` and `b` are names)
- Arguments: Actual values passed during method call, e.g., `calculateSum(5, 10)`
- Method Name: `calculateSum`
- Return Type: `int`
- Modifiers: `public` (accessibility), `static` (execution)

### Abstract vs. Concrete Methods
Methods can be categorized based on whether they provide implementation:

- **Abstract Method**: Declared without a body, ending with a semicolon. Must include the `abstract` keyword. Used to force subclasses to provide specific implementations.
- **Concrete Method**: Includes a full implementation body (opening and closing braces). Shared implementations across classes.

| Aspect              | Abstract Method                          | Concrete Method                          |
|---------------------|------------------------------------------|------------------------------------------|
| Implementation Body | No (ends with `;`)                       | Yes (contains `{ }`)                     |
| Keywords            | Must include `abstract`                  | Cannot include `abstract`                |
| Allowed Modifiers   | `public`, `protected`, `default` (accessibility); No `static`, `final`, `private` | All accessibility modifiers allowed; various execution modifiers |
| Purpose             | Force subclasses to implement logic      | Provide reusable, common logic           |
| Usage               | In superclasses with varying implementations | In superclasses with common implementations |

## Method Declaration vs. Method Definition

- **Method Declaration**: Creating a method without an implementation body (abstract method). It declares the method's contract for subclasses to fulfill.
  - Example: `abstract void execute();`
  - Terminology: Also known as abstract method. Ends with semicolon, requires `abstract` modifier.

- **Method Definition**: Creating a method with a complete implementation body (concrete method). Defines the method's behavior.
  - Example: `void execute() { System.out.println("Executing"); }`
  - Note: Provides full logic; can be static or non-static.

## Method Invocation and Calling

- **Method Invocation**: Executing a method's logic by calling it. Also referred to as method calling.
- **Calling Method**: The method that invokes another method.
- **Called Method**: The method whose logic is executed upon invocation.
- **Syntax**: `methodName(arguments);` – Arguments are optional if no parameters exist.
- **Flow**: Execution halts in the calling method, transfers to the called method's body, executes logic, and returns control to the calling method.

Example:
```java
public class Example {
    static void sayHello() {
        System.out.println("Hello");
    }
    
    public static void main(String[] args) {
        sayHello(); // Invocation: sayHello is called method, main is calling method
        System.out.println("World");
    }
}
```
- Output: "Hello" then "World"

## Method Implementation, Overriding, Hiding, and Overloading

- **Method Implementation**: Providing an implementation body for an abstract method declared in a superclass, for the first time in a subclass.
- **Method Overriding**: Redefining a superclass's non-static method in a subclass to provide new or modified logic.
- **Method Hiding**: Redefining a superclass's static method in a subclass (static methods cannot be overridden; they are hidden).
- **Method Overloading**: Defining multiple methods with the same name but different parameters (type, order, or count) in the same class.

| Concept              | Description                                                                 | Example                                                                 |
|----------------------|-----------------------------------------------------------------------------|-------------------------------------------------------------------------|
| Implementation       | First-time body provision for abstract superclass method in subclass        | Superclass: `abstract void process();`<br>Subclass: `void process() { /* logic */ }` |
| Overriding           | Replacing superclass method logic in subclass (non-static)                  | Superclass: `void show() { }`<br>Subclass: `void show() { /* new logic */ }` |
| Hiding               | Same as overriding but for static methods                                   | Superclass: `static void show() { }`<br>Subclass: `static void show() { /* new logic */ }` |
| Overloading         | Multiple methods with same name, different parameters                       | `void sum(int a) {}`, `void sum(int a, int b) {}`, `void sum(double a) {}` |

> [!NOTE]
> Overloading relies on signature differences (method name + parameters must vary).

## Sample Program: Calculating Percentage

Develop a program to take one number as input, calculate 20% of it, and display the original number, the 20% value, and the increased value (original + 20%).

### Code
```java
import java.util.Scanner;

class PercentageCalculator {
    public static int percentageOfNumber(int number) {
        int result = number * 20 / 100;
        int increasedNumber = number + result;
        return result;
    }
    
    public static void displayResults(int original, int percentage, int increased) {
        System.out.println("Original number: " + original);
        System.out.println("20% of number: " + percentage);
        System.out.println("Number after 20% increase: " + increased);
    }
    
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        System.out.print("Enter a number: ");
        int number = scanner.nextInt();
        
        int percentage = percentageOfNumber(number);
        int increased = number + percentage;
        
        displayResults(number, percentage, increased);
    }
}
```

- **Execution Steps**:
  1. Define a method `percentageOfNumber` in a separate class for reusability.
  2. Calculate 20% as `number * 20 / 100`.
  3. Compute increased value incrementally.
  4. Use `displayResults` for output logic.
  5. In `main`, take user input, call calculations, and display.

- This demonstrates method creation, static methods, parameter passing, and invocation for reusable logic.

## When and Where to Create Methods

- **When**: Create methods when logic needs to be reusable across multiple locations. Avoid placing logic directly in `main` if it's used elsewhere.
- **Where**: Methods must be created inside a class, not inside another method. Nested method creation is invalid (e.g., method inside method causes compilation error).

Example illustrating invalid nested creation:
```java
public class Example {
    public static void outerMethod() {
        // Invalid: Cannot create method inside method
        public static void innerMethod() { } // Compiler error
    }
}
```

## Types of Methods

Methods are classified based on structure and modifiers:

1. **Based on Implementation**:
   - Abstract: Declarations without body.
   - Concrete: Definitions with body.

2. **Based on Modifiers**:
   - Accessibility: Private, Default, Protected, Public → Subdivided as Private/Non-Private, Public/Non-Public.
   - Execution: Static/Non-Static, Final/Non-Final, Abstract/Non-Abstract, Native/Non-Native, Synchronized/Non-Synchronized, Strictfp/Non-Strictfp.

3. **Based on Return Type**:
   - Void: Returns no value.
   - Non-Void: Returns a value of specified type.

4. **Based on Parameters**:
   - Parameterized: Accepts inputs.
   - Non-Parameterized: No inputs.

Hierarchy:
- Methods → Abstract/Concrete
- Concrete → Static/Non-Static
- Further subtypes based on combinations (e.g., Public Static Void Non-Parameterized).

## Modifiers for Methods

Java supports 13 modifiers, with 10 allowed for methods (excluding `transient`, `volatile`, `interface`).

- **For Abstract Methods**: Only `public`, `protected`, `default` (accessibility); no `static`, `final`, `private`.
- **For Concrete Methods**: All accessibility and execution modifiers allowed (except `abstract`).

Allowed: `private`, `default`, `protected`, `public`, `static`, `final`, `native`, `synchronized`, `strictfp`.

## Summary

### Key Takeaways
```diff
+ Seven key method terms: prototype, body, logic, signature, parameters, arguments, modifiers.
+ Abstract methods force subclass implementations; concrete methods provide reusable logic.
+ Overloading differentiates methods by signature; overriding changes non-static logic; hiding applies to static methods.
+ Methods enable reusability: Create in classes, invoke via calls with arguments matching parameters.
+ Modifiers control access and behavior: Abstract methods limited; concrete methods flexible.
- Never nest methods inside other methods; they must live in classes.
- Static methods are class-level; non-static are object-level.
- Return types and parameters differentiate void/non-void and parameterized/non-parameterized.
```

### Expert Insight

**Real-World Application**: In enterprise Java projects, master method types for clean architecture. Use abstract methods in design patterns like Template Method to enforce subclass contracts (e.g., payment processors implementing `processPayment()` differently for credit cards vs. wallets). Concrete methods suit utility classes for shared operations like logging or data formatting, improving maintainability and reducing code duplication.

**Expert Path**: Practice differentiating method flavors by writing inheritance hierarchies: Create a base class with abstract methods for variable behaviors (e.g., vehicles with `accelerate()`) and concrete methods for constants (e.g., `getEngineType()`). Experiment with overloading (multiple constructors or utilities) and overriding in polymorphism scenarios to solidify understanding.

**Common Pitfalls**: 
- Confusing method declaration (no body) with definition—leads to abstract modifier errors.
- Attempting to instantiate abstract classes directly—subclasses must implement all abstract methods.
- Overlooking static vs. non-static context—static methods can't access `this`, non-static need objects.
- Issues with Resolution: Compilation fails if abstract methods aren't implemented in subclasses; runtime errors occur from mismatched argument types or missing returns in non-void methods.

**Lesser-Known Things**: 
- Native methods (with `native` keyword) are implemented in other languages (e.g., C++), allowing Java to interface with low-level systems.
- The `strictfp` modifier ensures floating-point calculations follow IEEE standards across platforms, rarely used but critical in financial apps.
- Method signatures exclude return types and modifiers in overloading checks—this is why `int calculate()` and `double calculate()` aren't overloads (ambiguous resolution).

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>

### Notification on Transcript Mistakes
Several misspellings were corrected for accuracy:
- "meod" consistently changed to "method" (e.g., "method of terminology", "meod name" to "method name").
- "etion" changed to "definition" (e.g., "method etion" to "method definition").
- "superass" and "subass" corrected to "subclass" (e.g., "superass programmer", "sub class").
- "vo" corrected to "void" (e.g., "vo method" to "void method").
- "meths" to "methods" (e.g., "meths chapter" to "methods chapter").
- Gibberish phrases like "chaa cha" adjusted to "abstract method" based on context. Other minor typos (e.g., "recieved" in code comments) were standardized for clarity. No functional code was altered, only descriptive text. If these aren't the intended corrections, please specify.
