# Session 83: Constructor 2

## Table of Contents
- [Recap from Previous Class](#recap-from-previous-class)
- [Constructor Rules and Restrictions](#constructor-rules-and-restrictions)
- [Private Constructors and Class Design](#private-constructors-and-class-design)
- [Static vs Singleton Classes](#static-vs-singleton-classes)
- [When Constructors Are Mandatory](#when-constructors-are-mandatory)
- [Types of Constructors](#types-of-constructors)
- [Object Initialization Stages](#object-initialization-stages)
- [Constructor vs Setter Method Initialization](#constructor-vs-setter-method-initialization)
- [Constructor Overloading](#constructor-overloading)
- [Static Constructors](#static-constructors)
- [Copy Constructors and Cloning](#copy-constructors-and-cloning)

## Recap from Previous Class
Constructor is a special method in Java used for object initialization. Key points from prior discussion include:
- **Purpose**: Initialize non-static variables and call superclass constructor
- **Syntax**: Same name as class, no return type
- **Invocation**: Through `new` keyword
- **Return types**: Placing return type leads to compile-time error
- **Methods with class name**: Not recommended, as it can confuse with Constructor
- **Differentiation**: Methods differentiated by return type at definition; Constructors by `new` keyword at invocation
- **Name rule**: Constructor name must match class name to inform `new` keyword
- **Private Constructors**: Can be declared private to restrict object creation from outside classes

## Constructor Rules and Restrictions

### Placing Return Type
If you place a return type in Constructor declaration, it leads to compile-time error. Example:
```java
public String MyClass() {  // Compile error: invalid method declaration
    return "";
}
```

### Methods with Class Name
- Can define methods with same name as class, but not recommended
- Compiler allows it, but it may confuse if it's a method or Constructor
- Compiler differentiates by return type in definition; `new` keyword in calling

### Name Requirement
Constructor name must be same as class name to give information to `new` keyword.

## Private Constructors and Class Design

### Declaring Constructor as Private
You can declare Constructor as private when you don't want other programmers to create your class objects.

### When to Prevent Object Creation
In two situations:
1. **Static Class**: Class contains only static variables and static methods
2. **Singleton Design Pattern Class**: Class allows only one object creation

### Static Class Creation
- Class contains only static variables and static methods
- Cannot declare class as `static` (compile error)
- Instead, declare all variables/methods as static inside the class
- Access via class name, not objects

### Singleton Class Creation
- Class allows only one object from it
- Also known as **Singleton design pattern class**
- Every class is **multi-ton** by default (multiple objects allowed)
- To make singleton: Declare Constructor as private
- Predefined singleton classes: `Runtime` (represents JVM, one per application)
- Predefined static class: `System` (all members static; e.g., `System.out.print`)

### Singleton Implementation Ways
- Two popular ways:
  1. Lazy object creation
  2. Early object creation
- Involves static reference variable and static method
- Detailed discussion deferred to design patterns topic

## When Constructors Are Mandatory

### Mandatory in Every Class?
Yes, because Constructor is responsible for:
1. Giving class information to `new` keyword
2. Calling superclass Constructor (via `super()` call)
3. Initializing current class variables

The `super()` call is mandatory to inherit superclass properties into subclass objects.

### When Programmer Must Define Constructor?
- When initialization logic or code execution needed at object creation
- Otherwise, compiler provides default no-parameter Constructor

## Types of Constructors
Java supports **three types** of Constructors:

| Type | Definition | Purpose |
|------|------------|----------|
| Default Constructor | Compiler-generated, no logic, same accessibility as class | Default initialization |
| No-Parameter Constructor | Developer-defined, no parameters | Execution logic without external values |
| Parameterized Constructor | Developer-defined with parameters | Initialization with values from other programmers |

### Differences
- **Default**: Provided by compiler; no logic; accessibility matches class
- **No-Parameter**: Developer-defined; can have logic; accessibility customizable
- **Parameters**: Developer-defined with parameters; takes external values

### Multiple Objects with Different Constructors
- **Default Constructor**: All objects have same default values
- **No-Parameter Constructor**: Objects may have same/different values based on logic
- **Parameterized Constructor**: Objects may have same/different values based on passed arguments

### Possible Combinations in Class
- Only default Constructor (compiler-provided if no explicit Constructor)
- Only no-parameter Constructor
- Only parameterized Constructor
- Multiple parameterized Constructors (overloading)
- No-parameter + multiple parameterized
- **Not possible**: Default + no-parameter (compiler replaces default if any Constructor defined)
- **Not possible**: Default + parameterized (same reason)

## Object Initialization Stages
Can initialize objects in **two stages**:

1. **At object creation**: Use Constructor
2. **After object creation**: Use setter methods

### When to Use Each
- **Constructor**: Initialize object properties at creation time
- **Setter Method**: Initialize or modify object properties later

### Differences: Constructor vs Setter Method
- **Constructor**: One-time execution per object; cannot modify after; may require many parameters; needs local variables for keyboard input
- **Setter Method**: Executable multiple times; for both initialization/modification; one method per property; no local variables needed; more flexible

### Advantages of Setter Method Approach
- Executable any times for same object
- Perform initialization and modification
- Define separate methods per property
- No mandatory order or full property initialization
- No local variables for input reading

99% of time in projects: Use no-parameter Constructor + setter methods.

✅ **Recommendation**: Setter method approach for object initialization.

## Constructor Overloading
- Define multiple Constructors in one class with different parameter types/signatures
- Differentiated by arguments passed during invocation

### Invoking Other Overloaded Constructors
- Use `this()` call to execute other overloaded Constructors in single object creation
- Executed in inheritance/polymorphism topics

### Instance Initializer Blocks
- When multiple Constructors share common logic, use **instance initializer block** (non-static block)
- Syntax: `{ ... }` (no keyword)
- Executed before Constructor body

## Static Constructors
- **Not supported in Java** (unlike C++ or C#)
- Cannot declare Constructor as `static` (compile error)

## Copy Constructors and Cloning

### What is Copy Constructor?
- A Constructor with parameter of same class type
- Contains logic to copy argument object data into current object
- Creates new object with copied values

### Difference from Parameterized Constructor
- Parameterized: Can create brand new object with external values
- Copy Constructor: Requires existing object as argument; copies its data

### Example Program Flow
```java
class Example {
    int x, y;
    
    Example() { x=0; y=0; }
    
    Example(int x, int y) { this.x = x; this.y = y; }
    
    Example(Example e) { 
        this.x = e.x; 
        this.y = e.y; 
    }
}

Example e1 = new Example();  // x=0, y=0
Example e2 = new Example(10, 20);  // x=10, y=20
Example e3 = new Example(e2);  // copies e2's values to e3
```

### Java's Approach
- Java does NOT support implicit copy Constructor like C++
- Can manually create copy Constructor, but must call explicitly
- **Recommended alternative**: Use `clone()` method (Object's clone method)
- Assignment (`e2 = e1`) creates reference copy, not new object

## Summary

### Key Takeaways
```diff
+ Constructor initializes objects and calls superclass Constructor
+ Three types: default, no-parameter, parameterized
- Avoid return types in Constructor declarations
+ Private Constructors restrict object creation for static/singleton classes
+ Initialize objects using setter methods for flexibility, not just Constructors
+ Constructor overloading allowed, use this() for chaining
- Static Constructors not supported in Java
+ Use clone() instead of copy Constructors for object duplication
+ Mandatory super() call ensures superclass initialization
```

### Expert Insight

#### Real-world Application
In enterprise Java applications (e.g., Spring framework), Constructors are minimally used for core initialization, while dependency injection and setter methods handle most configuration. Singleton patterns (e.g., `Runtime`) ensure one instance for JVM representation, preventing resource waste.

#### Expert Path
Master JavaBean standards: Use no-argument Constructor + getters/setters. Study design patterns like Builder for complex object construction. Experiment with reflection (`Class.newInstance()`) to understand Constructor invocation dynamically.

#### Common Pitfalls
- Forgetting `super()` leads to compile errors in inheritance.
- Assuming copy Constructors work like C++; use `clone()` to avoid shallow copy issues.
- Overusing parameterized Constructors; prefer setters for optional properties, as seen with Facebook account creation example.
- Not handling exceptions in initializers; instance blocks can throw unchecked exceptions only.

#### Lesser Known Things
- Compiler's default Constructor name matches class name and accessibility.
- Instance initializer blocks execute per object instantiation, before any Constructor, making them ideal for common setup code across overloaded Constructors.
- Predefined static classes like `System` use class loading for initialization, not objects.
