# Session 3: Multithreading 03

## Table of Contents
- [Overview](#overview)
- [Key Concepts/Deep Dive](#key-conceptsdeep-dive)
- [Lab Demos](#lab-demos)
- [Summary](#summary)

## Overview
This session delves into advanced multithreading concepts in Java, focusing on creating custom threads via extending `Thread` or implementing `Runnable`. It explores the execution flow, JVM architecture, method overriding versus overloading, recursion risks in inheritance hierarchies, null pointer exceptions in thread execution, and the mandatory/optional nature of overriding the `run()` method across different scenarios. The discussion emphasizes the importance of understanding object-oriented programming principles like polymorphism for mastering concurrent programming, through analysis of various test cases that highlight potential pitfalls and JVM behaviors.

## Key Concepts/Deep Dive

### Thread Creation Mechanisms
- **Extending Thread Class**: Creates a custom thread by subclassing `Thread` and overriding `run()` to define execution logic. When `start()` is called, JVM handles thread lifecycle.
- **Implementing Runnable**: Achieves thread creation by implementing `Runnable` interface. The class must override `run()`, and an instance is passed to a `Thread` constructor.

### Execution Flow and JVM Architecture
- **Sequential vs. Concurrent Flow**: Single-thread applications execute tasks sequentially (e.g., main thread). Multi-thread applications run tasks concurrently.
- JVM uses a stack area for thread execution:
  ```mermaid
  flowchart TD
      A[Main Thread Stack] --> B[Method Calls: main() creates objects]
      C[Thread Stack] --> D[start() creates new thread stack]
      D --> E[run() executes in separate stack]
      E --> F[Concurrent execution with main]
  ```
- Execution rules:
  - `run()` executes from the current thread object's class (the one calling `start()`).
  - If implementing `Runnable`, `Thread` class `run()` calls `target.run()` where `target` is the `Runnable` instance.
  - Direct `run()` calls execute sequentially in the calling thread, not creating concurrent flow.

### Overriding `run()` Method
- **Mandatory vs. Optional**:
  - Extending `Thread`: Optional, as `Thread` provides a default `run()` implementation.
  - Implementing `Runnable`: Mandatory, as interface methods must be implemented.
- Effects:
  - Not overriding in `Thread` extension executes empty logic; no output.
  - Overriding adds custom logic executed in new thread via `start()`.

### Overriding `start()` Method
- **Allowed but Risky**: `Thread` class `start()` is not `final`, so overriding is possible.
- **Problem**: Overriding without calling `super.start()` prevents custom thread creation; execution remains sequential.
- **Recommended Approach**: Override `start()` to run pre-execution logic, then call `super.start()` to create thread and invoke `run()`.

### Method Overloading
- **Possibilities**:
  - Overload `run()`: Stores overloaded methods in class; JVM calls no-parameter `run()` only.
  - Overload with abstract nuances: In `Runnable`, overloading isn't overriding; unimplemented `run()` causes compile error.
- Single-thread model applications execute all tasks in one thread (main). Multi-thread models use ≥2 threads with concurrent execution.

### Recursion and Target Variable Behavior
- **Recursion Risk**: Calling `super.run()` in overridden `run()` can lead to recursion if `target` points back to the same object, but JVM prevents infinite loops via null checks.
- **Target Variable**: In `Thread` class, `target` points to `Runnable` instance. If null, `target.run()` isn't called, breaking recursion.

### Null Pointer Exceptions and Edge Cases
- Assigning null to `Thread` or passing null `Runnable` doesn't cause NPE during construction but affects runtime execution silently.
- Accessing uninitialized variables (e.g., class-level without constructor) wraps null values without errors if no dereferencing occurs.

### Callable `run()` Directly
- **Allowed**: No compile/runtime errors; executes sequentially in calling thread.
- **Flow**: If called before or after `start()`, no new thread; logic runs in main thread stack.

### Multiple Start Calls
- **Exception Thrown**: `IllegalThreadStateException` on calling `start()` twice on same object—threads aren't reusable.
- First call succeeds; subsequent calls terminate main thread only; other threads run independently.

### Execution Patterns
- **run() then start()**: Sequential execution of `run()` in main, then concurrent via `start()`.
- **start() then run()**: Concurrent execution; `run()` called in both threads.
- Concurrent flow depends on timing; JVM unpredictably interleaves outputs.

## Lab Demos

### Demo 1: Extending Thread vs. Implementing Runnable
```java
class MyRunnable implements Runnable {
    public void run() {
        for (int i = 1; i <= 50; i++) {
            System.out.println("run: " + i);
        }
    }
}

class MyThread extends Thread {
    private Runnable target;

    public MyThread(Runnable r) {
        super();
        this.target = r;
    }

    public void run() {
        System.out.println("my thread run");
        if (target != null) {
            target.run();  // Executes MyRunnable's run()
        }
    }
}

// Usage
Runnable mr = new MyRunnable();
MyThread mt = new MyThread(mr);
mt.start();  // Outputs: my thread run followed by run: 1-50
```

### Demo 2: Recursion Prevention
```java
class MyThread extends Thread {
    public void run() {
        System.out.println("my thread run first");
        super.run();  // Calls Thread.run(), which calls target.run() if target != null
    }
}
```
- Output: Two lines—"my thread run first" and Thread.run() logic—denoting controlled recursion via null target check.

### Demo 3: Overloading run() without Overriding
```java
class MyRunnable implements Runnable {
    public void run() { }  // Must implement; empty
        
    public void run(String s) {   // Overloaded
        System.out.println("Overloaded run: " + s);
    }
}
// Compile error: Cannot overload abstract method. Must implement public void run().
```

### Demo 4: Direct run() Call vs. start()
```java
class MyThread extends Thread {
    public void run() {
        for (int i = 1; i <= 50; i++) {
            System.out.println("run: " + i);
        }
    }
}

// Usage
MyThread mt = new MyThread();
mt.run();    // Sequential: runs in main thread
mt.start();  // Concurrent: new thread executes run()
```

### Demo 5: Multiple start() Calls
```java
MyThread mt = new MyThread();
mt.start();   // Success
mt.start();   // Throws IllegalThreadStateException
```
- Output: Custom run() starts; second start() causes exception in main thread only.

### Demo 6: Concurrent Flow with for Loop
```java
for (int i = 0; i < 50; i++) {
    MyThread mt = new MyThread();  // New object each iteration
    mt.start();  // 50 concurrent threads
}
```
- JVM creates 50 threads; interleaves "run: 1-50" across threads unpredictably.

## Summary

### Key Takeaways
```diff
+ Extension of Thread allows overriding run() optionally, while Runnable implementation requires it mandatorily
+ Direct run() calls yield sequential execution; start() enables concurrency
+ Overriding start() without super.start() blocks thread creation; always chain super.start()
+ JVM recurses only if target is non-null; null prevents infinite loops
- Attempting multiple start() calls on one object results in IllegalThreadStateException
- Forgetting to implement run() in Runnable causes compile error
! Custom threads exist only after start(); objects alone are insufficient
```

### Expert Insight
#### Real-world Application
In enterprise Java systems (e.g., web servers like Apache Tomcat), custom threads extend `Thread` for background tasks such as log processing or socket handling. Implementing `Runnable` is preferred for pooled threads via `ExecutorService` to optimize resource usage in scalable server environments, ensuring concurrent client requests without bloating thread counts.

#### Expert Path
Master thread lifecycles by studying Java Concurrency Utilities (JSR 166) in the `java.util.concurrent` package. Implement thread pools with `Executor` interfaces to replace direct `Thread` usage, focusing on production-grade patterns like task queues and synchronization primitives (`Atomic`, locks). Practice JVM debugging with tools like JVisualVM to visualize stack traces in recursive scenarios. Pursue certifications like Java Programmer (Oracle) to formalize thread-dump analysis skills.

#### Common Pitfalls
- Mistaking direct `run()` calls for concurrent execution—always use `start()` for parallelism; direct calls starve I/O-bound tasks.
- Null `target` mishandling leading to silent failures; add log statements in `run()` for debugging empty outputs. Lesser-known issue: Thread-local variables not propagated across threads, causing unexpected shared-state bugs in recursive hierarchies (e.g., `InheritableThreadLocal` solves this).
- Overloading `run()` without overriding causing ignored methods; correct by ensuring base `run()` implementation routes to overloaded versions if needed. Avoid abstract `Runnable` subclasses without full inheritance paths, as partial implementations trigger compiler errors in strict type-checking scenarios. Finally, threads outliving main process can cause resource leaks—always join or use daemon threads for cleanup.
