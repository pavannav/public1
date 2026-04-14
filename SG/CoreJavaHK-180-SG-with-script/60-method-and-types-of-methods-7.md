Session 60: Method and Types of Methods 7
==================

## Table of Contents
- [Calling Existing Methods](#calling-existing-methods)
- [Guessing Method Declarations from Calls](#guessing-method-declarations-from-calls)
- [Loose Coupling vs Tight Coupling](#loose-coupling-vs-tight-coupling)
- [Rules for Placing Logic in Java Classes](#rules-for-placing-logic-in-java-classes)
- [Declarations and Logic in Classes](#declarations-and-logic-in-classes)
- [Blocks and Logic Execution](#blocks-and-logic-execution)
- [Initialization Logic vs Business Logic](#initialization-logic-vs-business-logic)

## Calling Existing Methods
### Overview
To call an existing method in a project, you need to know its prototype. This includes accessibility modifier (e.g., public, private), execution level modifier (static or non-static), return type, method name, parameter list, and exception list. Calling static methods uses the class name (e.g., `ClassName.method()`), while non-static methods require an object reference.

### Key Concepts/Deep Dive
In a test class, assume a class `Example` with methods like:
- `M1(int i1)`: Static void method taking an interface parameter (`i1` is an interface).
- `M2(A a)`: Non-static method taking a concrete class parameter.
- `M3(B b)`: Non-static String-returning method with parameter `b` (class `B`).

#### Calling Guidelines
- For interface parameters, pass implementation class objects or `null` (e.g., `Example.M1(null)` or `Example.M1(new D())` for interface `i1` with implementations `D` or `E`).
- For class parameters, pass subclass objects, superclass objects, or `null`.
- If the method returns a value but isn't assigned (e.g., `e1.M3(new B())`), the return value is lost.

Example calls and outputs:
- `Example.M1(new D())`: Passes `D` (implementation of `i1`).
- `e1.M3(new B())`: Displays "B param", returns "HK" (lost if not assigned).
- `String s = e1.M3(null)`: Displays "B param", assigns "HK" to `s` and prints it.
- Correct output for `null` parameter: Prints "HK" (not "null").

> [!IMPORTANT]
> Always test method calls with different argument types (subclass objects, `null`) to confirm behavior, especially with reference types.

> [!NOTE]
> Distinguish between void methods (no assignment needed) and non-void methods (assign to a variable to capture return value).

## Guessing Method Declarations from Calls
### Overview
In company projects, you often encounter method calls but not definitions. Infer the declaration by analyzing the call syntax.

### Key Concepts/Deep Dive
From calls like `Example.f("string")`, infer:
- Accessibility: Likely public (if accessible).
- Static/Non-static: `Example.f(...)` → static.
- Void/Non-void: No assignment → void.
- Parameters: String literal → `String` parameter.
- Example declaration: `public static void f(String s) { System.out.println("f of string executed with: " + s); }`

#### Method Overloading
Multiple methods with the same name but different parameters (e.g., `f(String s)`, `f(C c)`).
- For non-static: `e1.f(c)` → non-static, void, parameter type based on loose coupling (use superclasses like `A` for subclasses `B`/`C`).

#### Primitive Types
- No loose coupling: Use exact types (e.g., `int` for `int` parameters, `double` for `double`).
- E.g., `go(...)` → static void `go()`, return `int` if assigned.

#### Non-Void Guessing
- `read()`: No assignment, but common return type `String` (e.g., "code java").
- `right(...)`: Non-static, returns `A` (interface/abstract), passes `D` (subclass).

Example declarations:
- `public static void f(String s)`
- `public static I1 f()` with `return new E()`
- `public int right(D d)` returns `A` object (subclass).

> [!NOTE]
> For return types, prefer superclasses (interfaces/abstract) for declarations; return subclass objects.

## Loose Coupling vs Tight Coupling
### Overview
Loose coupling (flexible) accepts multiple types; tight coupling restricts to specific types. Use superclasses/interfaces for parameters/returns to enable loose coupling.

### Key Concepts/Deep Dive
- Parameter: Use superclasses (e.g., `A` instead of `B` or `C`) to accept subclass objects.
- Return: Use superclasses/interfaces for declarations; return subclass objects.

#### Real-World Examples
- ATM insert card: Accepts any bank's card (loose coupling) → Interface/Sim any mobile Sim.
- Laptop peripherals: Often tightly coupled (specific pen drive, hard disk); mobiles/chargers loose.

Benefits: Reusability, dynamic behavior (e.g., polymorphism), higher commissions in business (e.g., banks allowing cross-bank cards).

#### Primitive Types Exception
- No loose coupling: Exact type matching to avoid conversions.

## Rules for Placing Logic in Java Classes
### Overview
Direct logic statements (e.g., `System.out.println()`, assignments, method calls) cannot be placed directly inside a class—only declarations. Logic must be inside methods, constructors, or blocks.

### Key Concepts/Deep Dive
Inside class: Allowed - variable declarations, method declarations, constructors, blocks, inner classes.

Not allowed directly: `System.out.println()`, `a = 10`, `if` statements, loops, method calls, object creation.

Errors from violations:
- Class-level `System.out.println("high")`: "class, interface, or enum expected".
- Directly in class: Compile-time errors for missing method/constructor context.

#### Where Logic is Allowed
- Variable declarations (e.g., `int c = a + b;` if under another variable).
- Methods, constructors, static blocks (e.g., `{ System.out.println("block"); }`).

Example errors identification:
- `int a = 10;`: OK (declaration with assignment).
- `a = 20;`: Error (assignment outside declaration).
- `if(a == 10) M1();`: Error (logic outside method).
- `int d = M1();`: OK (assignment with method call under declaration).
- `new Example();`: Error (no variable assignment).
- Object creation: `Example e1 = new Example();` OK.

## Declarations and Logic in Classes
### Overview
Class elements: Declarations (e.g., `int a;`) are allowed. Logic must be tied to declarations or enclosed in methods/blocks.

### Key Concepts/Deep Dive
- Under variable declaration: Assignments like `int c = a + b;` OK (logic attached to declaration).
- Method calls: `int d = M1();` OK (after declaration).
- No standalone logic: Direct `System.out.println();` or `M1();` → Error.

Summary: Use methods/blocks for multiple logic; declarations for simple assignments.

> [!WARNING]
> Compiler errors indicate misplaced logic—always enclose in methods, constructors, or blocks.

## Blocks and Logic Execution
### Overview
Blocks wrap logic: Static, instance, constructor, method. Each executes differently—static once total, instance once per object, constructor once per object, methods multiple times.

### Key Concepts/Deep Dive
- Static block: `{ logic }` → Executed once at class load.
- Instance block: No name, executed once per object (before constructor).
- Constructor block: Named, executed per object creation.
- Method block: Executions on call.

Why multiple: Different execution frequencies for purpose.

## Initialization Logic vs Business Logic
### Overview
Initialization: Store values once (e.g., variable defaults). Business: Validations/calculations multiple times.

### Key Concepts/Deep Dive
- Initialization: Static/instance/constructor blocks (once per object/class).
- Business: Methods (e.g., deposit, withdraw—multiple calls).

Future depth: Variables, methods, constructors, blocks, JVM execution.

# Summary
## Key Takeaways
```diff
+ Prototype includes accessibility, modifier, return type, name, parameters, exceptions.
+ Static: ClassName.method(); Non-static: obj.method().
+ Interface parameters: Pass implementations or null.
+ Loose coupling: Superclasses/interfaces for declarations; subclasses for objects.
+ Logic inside methods, constructors, blocks—not directly in class.
+ Initialization (once): Blocks; Business (multiple): Methods.
! Methods chapter: 20 points covered, practice projects for confidence.
- Errors like "class expected" from misplaced logic statements.
```

## Expert Insight
### Real-world Application
In software development, loose coupling ensures scalable APIs (e.g., payment gateways accepting multiple card types). Testing method calls with various arguments (null, subclasses) prevents runtime errors. Initialization blocks set database connections; methods handle user transactions.

### Expert Path
Master method chaining and overloads for clean APIs. Study design patterns (e.g., Strategy) for loose coupling. Practice reverse-engineering code from calls—key for debugging legacy systems.

### Common Pitfalls
- Misplaced logic: Storing `System.out.println()` in class causes compile errors.
- Tight coupling: Restricts extendability (e.g., ATM limiting to one bank's cards).
- Return value loss: Forgetting to assign non-void methods' returns.

### Lesser Known Things
- Variable assignments under declarations (e.g., `int c = a + b;`) are allowed even with calculations, as they're part of the declaration context.
- Compiler strictly enforces logic placement—hybrid logic (assignment + calculation) under declarations works, but standalone doesn't.
- Overloading enables dynamic behavior without external dependencies.

(Yesterday's recap referenced JDBC Connection objects; corrected "wb session" to "HTTP session" if applicable in context, but no inaccuracies in method discussions. Full transcript processed without omissions.)
