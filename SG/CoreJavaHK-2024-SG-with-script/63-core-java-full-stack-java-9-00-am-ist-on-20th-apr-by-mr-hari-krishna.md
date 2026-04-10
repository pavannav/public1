# Session 63: Static Non-Static Members Execution Flow with Multiple Classes

## Table of Contents
- [Non-Static Members Execution Flow](#non-static-members-execution-flow)
- [Combination Execution Flow of Static and Non-Static Members](#combination-execution-flow-of-static-and-non-static-members)
- [Static Non-Static Members Combination Execution Flow](#static-non-static-members-combination-execution-flow)
- [Execution Flow with Multiple Classes](#execution-flow-with-multiple-classes)

## Non-Static Members Execution Flow
### Overview
This section revisits and extends the execution flow for non-static members, building on previous concepts. Non-static members (variables, blocks, methods, and constructors) are executed when objects are created. The flow follows a specific order: object instantiation via `new`, memory allocation for non-static variables with default values, non-static variable assignments, non-static blocks execution, and finally constructor invocation. Multiple constructors or initialization paths can exist, and the flow repeats for each object created.

### Key Concepts
Non-static members execution adheres to this sequence:
1. Object creation triggers JVM search for non-static variables.
2. Memory is allocated from top to bottom with default values.
3. `new` keyword calls the appropriate constructor.
4. Control enters the constructor, which may reference non-static variables or blocks.
5. Non-static variable assignments (e.g., `x = m1()`) execute methods or assign values.
6. Non-static blocks run in order.
7. Constructor logic completes, and the object reference is returned.

For multiple objects, this flow repeats entirely for each.

### Lab Demo
Example program with two objects created:
```bash
// Pseudocode based on explanation
public class Example {
    int x = m1(); // Calls m1(), assigns return value
    static int m1() { return 10; } // Static method
    // Non-static block and constructor logic here
}
// In main, create E1 and E2; flow repeats.
```

Output illustration: Flows executed twice, with variations based on constructors (no-param vs. string-param).

## Combination Execution Flow of Static and Non-Static Members
### Overview
When a class contains both static and non-static members, the JVM prioritizes static members first. Static members are executed during class loading, while non-static members execute only upon object creation. Object creation can occur anywhere—class level (via static/non-static variables), static blocks, constructors, or methods—causing non-static flow to interleave with static execution.

### Key Concepts/Deep Dive
Core Flow:
1. **Static Members Execution (Class Loading)**:
   - Top-to-bottom static variable memory allocation with default values (primitives: 0/null false; references: null).
   - Top-to-bottom static variable assignments (literals, method calls, object creations).
   - Static blocks execution.
   - Main method (if invoked via `java` command).
2. **Object Creation Interruption**:
   - If object created during static execution, non-static flow pauses static and resumes after completion.
   - Non-static: New instance created, non-static variables memory allocated, assignments/blocks executed, constructor called.
3. **Resumption**: After non-static completion, static members continue.
4. **Outcomes**: Static variables once, static blocks once, main once; non-static per object.

| Aspect | Static Members | Non-Static Members |
|--------|----------------|---------------------|
| When Executed | Class load | Object creation |
| Frequency | Once per class | Per object instance |
| Examples | Static vars, blocks, main | Instance vars, blocks, constructors |

> [!NOTE]
> Object creation can happen at class level (static/non-static vars), in static/non-static blocks, constructors, or methods.

## Static Non-Static Members Combination Execution Flow
### Overview
JVM starts with static members and ends with them, interrupting for non-static execution when objects are created. The flow is deterministic but varies by object creation location. Static: variables → assignments/blocks → main. Non-static: variables → assignments/blocks → constructors, repeated per object.

### Key Concepts
- **Mindset for Analysis**: Always start static; insert non-static at object creation points.
- **Execution Order Independence**: Depends on code structure; no fixed precedence between static/non-static types.
- **Memory Allocation**: Static vars first (class-level), then instance vars (per object).

### Lab Demo
Complex program with objects created at class level (static vars), static block, and main. Visualize with diagrams: Static execution interleaved with non-static instances.

```bash
// Example structure
public class Example {
    static Example e1 = new Example(); // Non-static executes here
    static { new Example(); } // Non-static interrupts static block
    public static void main() {
        new Example(); // Final non-static execution
    }
}
```

## Execution Flow with Multiple Classes
### Overview
Involving multiple classes, execution follows the same rules but per class loaded. Class loading occurs on first access (static var/method), resulting in static execution without main (unless via `java` command). Cross-class access requires full static initialization of referenced class.

### Key Concepts/Deep Dive
- **Class Loading Triggers**:
  1. `java` command + main.
  2. Static variable access.
  3. Static method call.
  4. Object creation (constructor via `new`).
- **Static Execution Always**: Vars, assignments, blocks; main only for `java` command.
- **Multiple Classes**: Each loaded class's statics execute on first reference.
- **Key Rule**: "Whole body" needed—full class initialization before member access.

### Lab Demo
Program with Sample and Example classes:
- Sample loads first: statics (D=50, blocks) execute.
- Cross-access like `Example.a`: Loads Example, executes statics (A=10, B=20, C=30, blocks), returns A value.
- Main: Accesses `Example.b` without re-loading.

```bash
// Sample.java
public class Sample {
    static int d = 50;
    static { System.out.println("SB1"); }
    public static void main(String[] args) {
        System.out.println(Example.a); // Loads Example, executes statics, prints 10
        System.out.println(Example.b); // Reads existing B=20
    }
}

// Example.java
public class Example {
    static int a = 10;
    static { System.out.println("SA"); }
    static int b = 20;
    static { System.out.println("SB1"); }
    static int c = 30;
    static { System.out.println("SB2"); }
}
```

Output: SB1 (Sample), SA (Example load), SB1, SB2 (Example), 10, 20.

## Summary
### Key Takeaways
```diff
+ JVM always starts with static members: vars (default values) → assignments/blocks → main.
+ Non-static executes per object: vars (default) → assignments/blocks → constructor.
+ Static executes once per class; non-static per instance.
+ Object creation anywhere interleaves non-static within static flow.
+ Multiple classes: Each loads on first access with full static execution (no main unless run).
- Incorrect assumptions lead to errors (e.g., expecting main execution on member access).
! Memorize flow: Class load → Static mem/assign/blocks → Main (only if run) → Non-static on object creation.
```

### Expert Insight
#### Real-world Application
In production systems like Spring Boot or Hibernate, understanding this flow is crucial for static initialization of configuration beans or database connections. Creating objects in static blocks (e.g., singletons) ensures thread-safe initialization, while avoiding circular dependencies.

#### Expert Path
Master by drawing execution diagrams for complex inheritance scenarios or multithreaded environments. Study JVM Specification Chapter 5 for deep internals.

#### Common Pitfalls
- Forgetting default allocations: Variables initialized to defaults before assignments.
- Shortcuts in multiple classes: Full initialization required before access.
- Losses in method calls: Unassigned return values waste computation.

Corrections: No major errors in provided transcript. Note "ript" likely "transcript" in filename.
