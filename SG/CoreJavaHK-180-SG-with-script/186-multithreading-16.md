## Table of Contents
- [Overview](#overview)
- [Yield Method](#yield-method)
- [Sleep Method](#sleep-method)
- [Join Method](#join-method)
- [Synchronization](#synchronization)
- [Code Examples](#code-examples)
- [Summary](#summary)

## Overview
Session 186 introduces methods for controlling thread execution in Java, enabling pausing or sequencing thread execution to achieve specific behaviors. This includes yielding CPU time, sleeping for a period, joining threads for dependency, and synchronizing shared resources to prevent race conditions. These concepts are fundamental for multi-threaded programming where controlling execution flow is essential for data consistency and performance.

## Yield Method
### Concept
The yield method requests the JVM to pause the currently running thread and allocate resources to other ready-to-run threads. It is a static method in the `Thread` class that works on the current thread.

### Functionality
- **Prototype**: `public static void yield()`
- **Usage**: Call `Thread.yield()` to suggest JVM pause the current thread.
- **Behavior**: Moves the calling thread from running to ready-to-run state, but does not guarantee immediate switch (request, not forceful).
- **Example Scenario**: Thread requests JVM to prioritize other threads, like pausing a fast-running thread for fairness.
- **Key Point**: Yielding does not halt execution indefinitely; thread may resume based on scheduler.

> [!NOTE]
> Yield method is not commonly used in production code as it relies on JVM implementation and is non-deterministic.

## Sleep Method
### Concept
The sleep method pauses the currently running thread for a specified time, allowing other threads to execute. It is static and throws `InterruptedException`, a checked exception.

### Functionality
- **Overloaded Forms**:
  - `Thread.sleep(long milliseconds)`
  - `Thread.sleep(long milliseconds, int nanoseconds)`
- **Behavior**: Thread moves from running to timed-waiting state; resumes after duration or if interrupted.
- **Usage**: Independent pause; does not depend on other threads.
- **Example**: Pausing a thread for 5000 milliseconds (5 seconds) before resuming.

### Code Syntax
```java
try {
    Thread.sleep(5000); // Pauses for 5 seconds
} catch (InterruptedException e) {
    // Handle interruption
}
```

### Deep Dive
- Sleep ensures exact pause duration, but other threads may interrupt via `interrupt()` method.
- Throws `InterruptedException` if interrupted during sleep.

## Join Method
### Concept
The join method waits for another thread to complete execution before resuming the current thread, establishing dependencies between threads.

### Functionality
- **Overloaded Forms**:
  - `join()`: Waits indefinitely until target thread completes.
  - `join(long milliseconds)`: Waits up to specified time; resumes if target doesn't finish.
  - `join(long milliseconds, int nanoseconds)`: More precise timed wait.
- **Behavior**: Calling thread moves to blocked/non-runnable state until target thread ends or timeout.
- **Usage**: Depends on another thread's completion.
- **Key Difference from Sleep**: Sleep is independent; join waits for specific thread.

### Examples
- `thread2.join()`: Paused until `thread2` completes.
- `thread2.join(5000)`: Waits max 5 seconds for `thread2`.

### Scenarios
- **Dependency Check**: Beloved waiting for partner (indefinite join); friend waiting for certain time (timed join).
- **Output Guarantee**: `mt.join()` ensures main thread waits for `mt` completion.

## Synchronization
### Concept
Synchronization ensures sequential execution of methods on shared objects, preventing race conditions and data inconsistency.

### Functionality
- **Why Needed**: Multiple threads accessing shared resources can lead to incorrect data modifications (e.g., one thread writes 50,60; another overwrites to 70,80 mid-calculation).
- **Solution**: Use `synchronized` keyword to lock objects, allowing only one thread at a time.
- **Behavior**: Object locks for synchronized methods; non-synchronized methods can run concurrently.
- **Scope**: Applies lock to object, not method; sequential execution only for same-object access.

### How to Implement
Declare methods as `synchronized`:

```java
public synchronized void add(int x, int y) {
    // Logic; object locked during execution
}
```

- **Realtime Application**: Like database row locks for updates.

### Deep Dive
- **Problems Without Synchronization**: Concurrent modifications cause wrong results (e.g., 110 expected vs. 150 actual due to overwritten values).
- **With Synchronization**: Threads execute sequentially; first thread completes, unlocks, second proceeds.
- **Independent Objects**: Different objects allow concurrent access.

## Code Examples
### Yield Method Example
```java
class MyThread extends Thread {
    public void run() {
        System.out.println("Run executed");
    }
}

class Test14 {
    public static void main(String[] args) {
        MyThread mt = new MyThread();
        mt.start();
        Thread.yield(); // Optional; main may yield to custom thread
        System.out.println("Main start");
        System.out.println("Main end");
    }
}
// Output may vary: Could be Main start/remove, Run executed, Main end depending on scheduler.
```

> [!WARNING]  
> Yield does not guarantee switch; used for hints, not enforcement.

### Sleep Method Example
```java
class MyThread extends Thread {
    public void run() {
        for (int i = 1; i <= 50; i++) {
            System.out.print(i + "\t");
            try {
                Thread.sleep(100); // Display pauses for visibility
            } catch (InterruptedException e) {
                // Handle
            }
        }
        System.out.println();
    }
}

class Test {
    public static void main(String[] args) {
        MyThread mt = new MyThread();
        mt.start();
    }
}
// Output: Numbers 1 to 50 with 100ms pauses.
```

### Join Method Example
```java
class MyThread extends Thread {
    public void run() {
        System.out.println("Run start");
        System.out.println("Run end");
    }
}

class Test {
    public static void main(String[] args) throws InterruptedException {
        MyThread mt = new MyThread();
        mt.start();
        mt.join(); // Main waits for mt to finish
        System.out.println("Main end");
    }
    // Output: Run start, Run end, Main end(always guaranteed).
}
```

- **Timed Join**: `mt.join(5000)` waits max 5 seconds.

### Synchronization Example
```java
class Example {
    int x, y;
    public synchronized void add(int x, int y) {
        this.x = x;
        this.y = y;
        try {
            Thread.sleep(2000); // Simulate pause
        } catch (InterruptedException e) {}
        System.out.println(Thread.currentThread().getName() + " Result: " + (this.x + this.y));
    }
}

class ThreadOne extends Thread {
    Example e;
    public ThreadOne(Example e) { this.e = e; }
    public void run() { e.add(50, 60); }
}

class Test17 {
    public static void main(String[] args) {
        Example e1 = new Example();
        new ThreadOne(e1).start();
        new ThreadOne(e1).start(); // Same object, sequential
    }
}
// Output: Thread-0 Result: 110, Thread-1 Result: 110 (no overwrite).
```

Without `synchronized`, outputs could be 150 for both due to race conditions.

## Summary
### Key Takeaways
```diff
! Thread execution control involves pausing/sequencing for consistency.
+ Yield: Static method to request pause; non-deterministic for other threads.
+ Sleep: Pauses current thread independently; throws InterruptedException.
+ Join: Waits for target thread completion; dependency-based.
- Without join/sleep, threads run concurrently with potential race conditions.
+ Synchronization: Locks objects for sequential access; prevents data corruption.
! Choose join for dependencies, sleep for timed pauses, yield for hints.
```

### Expert Insight
**Real-world Application**: In concurrent systems like web servers or databases, synchronization prevents data races (e.g., bank account withdrawals); join ensures task dependencies (e.g., producer-consumer). Sleep delays retries for external services; yield optimizes CPU sharing in simulations.

**Expert Path**: Master locks with `wait()`/`notify()` for complex synchronization. Study `Executor` frameworks for thread pools. Practice `volatile` for visibility in non-synchronized shared variables. Dive into JVM thread dumps for debugging deadlocks.

**Common Pitfalls**:
- Forgetting `try-catch` for `InterruptedException` on sleep/join methods leads to compilation errors.
- Race conditions in shared objects without synchronization (e.g., incorrect ATM balances); resolve by syncing access.  
- Deadlocks: Threads waiting infinitely (e.g., A waits for B, B waits for A); avoid circular dependencies.  
- Misusing `yield` in production—ineffective for guarantees; use explicit controls.  
- Object locks apply only within same JVM; distributed systems need RMI/transactions.

Lesser known: Synchronization affects performance; overuse blocks scalability. Static synchronized methods lock class, not instance, risking bottlenecks. Threads inherit contexts (e.g., intercept handlers); interrupted threads can resume unexpectedly on `notify()`. In rare cases, JVM may not honor `yield` on single-CPU systems.
