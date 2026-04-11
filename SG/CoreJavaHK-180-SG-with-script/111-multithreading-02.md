# Session 111: Multithreading 02

## Table of Contents

- [Overview](#overview)
- [Key Concepts/Deep Dive](#key-conceptsdeep-dive)
- [Summary](#summary)

## Overview

This session continues the exploration of multi-threading in Java, focusing on the internal memory diagrams and execution flows when creating custom threads. We covered extending from the Thread class and implementing from Runnable interface, understanding how the JVM manages thread creation, initialization, and concurrent execution. The discussion emphasizes visualizing the internal mechanics of thread objects, variable initialization, and the critical difference in execution flows between the two approaches.

## Key Concepts/Deep Dive

### Memory Diagram and Internal Flow - Extending Thread

#### JVM Runtime Areas
When a Java program runs (including multi-threaded ones):

- **Method Area**: Stores class-level information, static variables, static blocks
- **Heap Area**: Stores object instances and their instance variables  
- **Java Stack**: Stores method call stacks for each thread
- **PC Registers**: Program counters for each thread
- **Native Method Stack**: For native method calls

> **Main Thread**: JVM creates a main thread by default in the Java Stack area.

#### Thread Creation Process - Extending Thread

Let's trace through the creation and execution of a custom thread by extending Thread class:

```java
class Test {
    public static void main(String[] args) {
        MyThread mt = new MyThread();  // Line 1
        mt.start();                    // Line 2
        System.out.println("Main Thread"); // Line 3
    }
}

class MyThread extends Thread {
    public void run() {
        System.out.println("Child Thread");
    }
}
```

**Step 1: Class Loading**
- When JVM starts, main thread is created
- Test class is loaded into Method Area
- MyThread class (subclass of Thread) is loaded
- Thread class and Object class are already loaded
- Thread class contains variables: name, priority, demon, group, target, threadStatus

**Step 2: Object Creation**
- `new MyThread()` creates instance in Heap area
- Instance variables memory allocated with default values:
  - target: null (Runnable reference)
  - group: null  
  - demon: false
  - priority: 0 (temporary, will be overridden)
  - name: null
  - threadStatus: 0

**Step 3: Constructor Chaining**
- MyThread no-parameter constructor implicitly calls `super()`
- Thread no-parameter constructor called
- Constructor chaining: Thread() → Thread(Runnable, ThreadGroup, String, long, AccessControlContext, boolean)
- Thread constructor logic:
  - Initializes thread number (post-increment: `nextThreadNum++`)
  - Name: "Thread-" + (nextThreadNum - 1)
  - Group: Initialized from parent thread's group (main thread's group)
  - Priority: Inherited from parent thread (5 by default)
  - Demon: Inherited from parent thread (false for main)
  - Target: null (since no Runnable passed)

**Step 4: start() Method Execution**
- `mt.start()` executes in main thread
- start() method:
  - Checks thread status ≠ 0 (throws exception if already started)
  - Adds thread to thread group  
  - Calls native method to register/start thread with JVM
  - Changes thread status from 0 to non-zero value
  - Returns to calling method (main thread)
  - Custom thread is now "ready to execute" (run() method loaded in JVM)

> [!IMPORTANT]
> `start()` method does NOT call `run()` directly. JVM handles run() execution separately.

**Step 5: Concurrent Execution**
- Control returns to main thread
- Main thread continues: `System.out.println("Main Thread")`
- JVM scheduler switches between threads
- Child thread executes: `System.out.println("Child Thread")`
- Output is typically mixed due to concurrent execution

### Memory Diagram and Internal Flow - Implementing Runnable

For Runnable interface implementation:

```java
class Test {
    public static void main(String[] args) {
        MyRunnable mr = new MyRunnable();  // Line 1  
        Thread t = new Thread(mr);         // Line 2
        t.start();                         // Line 3
        System.out.println("Main Thread"); // Line 4
    }
}

class MyRunnable implements Runnable {
    public void run() {
        System.out.println("Child Thread");
    }
}
```

**Differences from Thread Extension:**

**Step 1: Runnable Object Creation**
- `MyRunnable mr = new MyRunnable()` creates object in Heap
- MyRunnable class loaded (not subclass of Thread)

**Step 2: Thread Object Creation**  
- `new Thread(mr)` calls Thread(Runnable) constructor
- Target variable initialized with mr reference
- Other variables (group, priority, demon, name) initialized same as above

**Step 3: start() and run() Execution**
- `t.start()` works identically to above
- Thread class `run()` method contains: `if (target != null) target.run()`
- This calls `mr.run()` (the Runnable implementation)
- **Two run() methods involved**: Thread.run() calls target.run()

> [!NOTE]
> Flow is nearly identical to Thread extension. Key difference: target != null, so `target.run()` executes the Runnable's logic.

### Thread Class Variables and Methods

Thread class contains several key variables and methods:

#### Important Instance Variables:
- **target**: Runnable reference (null for Thread extension, Runnable object for Runnable implementation)
- **name**: String ("Thread-0", "Thread-1", etc.)  
- **priority**: int (1-10, default 5)
- **demon**: boolean (default false)
- **group**: ThreadGroup reference (inherited from parent)
- **threadStatus**: int (0 = NEW, non-zero = started)

#### Key Methods:
- `start()`: Native method that registers thread with JVM
- `run()`: Either Thread.run() (does nothing or calls target.run()) or overridden run()

### Parent Thread Inheritance

When creating custom threads:
- **Group**: Inherited from parent thread (main thread → main group)  
- **Priority**: Inherited from parent thread (5 by default)
- **Demon Status**: Inherited from parent thread (false by default)
- **Name**: Auto-generated ("Thread-" + number)

```java
Thread custom = new MyThread();
// custom.getPriority() == 5 (from main thread)
// custom.isDaemon() == false (from main thread)  
// custom.getName() == "Thread-0" (auto-generated)
```

### Execution Flow Rules

- `start()` always executes in the calling thread (usually main)
- `start()` requests JVM to create separate execution context for custom thread
- Custom thread `run()` executes when JVM scheduler allocates time
- Main thread continues immediately after `start()` returns
- Output order is non-deterministic due to concurrent execution

```diff
+ Both approaches (Thread extension + Runnable implementation) have identical execution flows
- Key difference: target variable (null vs Runnable reference) determines run() behavior
```

## Summary

### Key Takeaways

```diff
+ Thread Creation: Always involves class loading, object instantiation, constructor chaining, and variable initialization
+ start() Method: Executes in calling thread, registers with JVM, changes thread status, but doesn't call run()
+ Concurrent Execution: JVM scheduler switches between main thread and custom threads after start() returns  
+ Memory Flow: Identical for both Thread extension and Runnable implementation - difference in target variable
+ Parent Inheritance: Priority, daemon status, and group inherited from thread that creates the custom thread
- No Direct run() Call: Never call run() directly for multi-threading - use start() to let JVM manage execution
+ Two run() Methods: In Runnable approach, Thread.run() calls target.run() from the passed Runnable object
```

### Expert Insight

**Real-world Application**: Understanding internal thread flows is crucial when debugging production issues like race conditions, deadlocks, or thread starvation. The memory diagrams help visualize why Thread extension couples inheritance (can't extend other classes) while Runnable implementation provides composition flexibility.

**Expert Path**: Master thread internals by implementing both approaches and experimenting with thread priorities, daemon threads, and thread groups. Use Java VisualVM to observe actual thread stacks and memory usage.

**Common Pitfalls**: 
- Calling `run()` directly instead of `start()` results in sequential execution, not concurrency
- Thread extension prevents class inheritance, limiting design options
- Not handling exceptions in `run()` can silently terminate threads without proper cleanup
- Thread status changes are internal - don't rely on status values for application logic

Lesser known things: Thread class has both `extends` and `has-a` relationships with Runnable - `extends` for implementing `run()`, and `has-a` for calling target Runnable's `run()`. Constructor chaining involves native method calls that are JVM platform-specific.
