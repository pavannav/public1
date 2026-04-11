# Session 96: Thread Control Methods and Synchronization

**Table of Contents**
- [Overview](#overview)
- [Yield Method](#yield-method)
- [Sleep Method](#sleep-method)
- [Interrupt and InterruptedException](#interrupt-and-interruptexception)
- [Join Method](#join-method)
- [Synchronization Concept](#synchronization-concept)
- [Object Lock vs Class Lock](#object-lock-vs-class-lock)
- [Code Examples and Demos](#code-examples-and-demos)

## Overview

This session covers advanced multi-threading concepts in Java, focusing on controlling thread execution beyond basic start and creation. We explore methods like yield, sleep, interrupt, and join to manage thread scheduling, pausing, and resuming. Additionally, we introduce synchronization to prevent data inconsistency when multiple threads access shared resources, using the synchronized keyword for thread-safe operations.

## Yield Method

### Deep Dive
The `yield` method is a static method in the Thread class (`public static void yield()`) that provides a hint to the thread scheduler to relinquish control of the currently running thread, allowing other threads to execute. It does not guarantee the thread will pause—it's a cooperative suggestion.

**Key Points:**
- Does not stop the thread execution; it's a request to the scheduler.
- Use case: When you want to give other threads a chance but don't need to force a pause.
- No exception thrown; it's a non-blocking operation.

```java
// Example: Requesting to yield control
public class MyThread extends Thread {
    public void run() {
        System.out.println("Run start");
        Thread.yield(); // Request to pass control
        System.out.println("Run end");
    }
}

public class Main {
    public static void main(String[] args) {
        MyThread mt = new MyThread();
        System.out.println("Main start");
        mt.start();
        System.out.println("Main end");
    }
}
```

**Output Expected:** Main start, Run (yield may or may not pass control), varities based on scheduler.

💡 Yield is rarely used in practice due to its unpredictability. It's more of an internal JVM hint.

### Labs
To observe yield, run the example multiple times. Yield does not guarantee output order.

## Sleep Method

### Deep Dive
The `sleep` method forces the current thread to pause execution for a specified time, ensuring it's removed from the running state. It has overloaded forms: `Thread.sleep(long milliseconds)` and `Thread.sleep(long milliseconds, int nanoseconds)`.

**Key Points:**
- Throws `InterruptedException` if another thread calls `interrupt()` during sleep.
- Absolute wait time; complete pause regardless of other activities.
- Common use: Creating delays, animations, or timed operations.

**Difference from Yield:**
- Sleep: Guaranteed pause for specified time.
- Yield: Unguaranteed request to pass control.

```java
// Example: Pausing thread for 5000 milliseconds
public class MyThread24 extends Thread {
    public void run() {
        System.out.println("Run start (sleeping for 5 seconds)");
        try {
            Thread.sleep(5000); // Pauses execution
        } catch (InterruptedException e) {
            System.out.println("i is rise");
        }
        System.out.println("Run end");
    }
}

public class Main {
    public static void main(String[] args) {
        MyThread24 mt = new MyThread24();
        System.out.println("Main start");
        Thread.sleep(1000); // Main thread sleeps briefly
        mt.start();
        // Interrupt example
        Thread.sleep(2000); // Wait before interrupting
        mt.interrupt(); // Forces early wakeup
        System.out.println("Main end");
    }
}
```

**Lab:** Increase sleep time to visualize pause. Interrupt demos early resumption.

## Interrupt and InterruptedException

### Deep Dive
The `interrupt()` method signals a thread in a blocked state (e.g., sleep, wait, join) to exit early, throwing `InterruptedException`. It's a way to forcibly resume threads before their natural completion.

**Key Points:**
- Can't interrupt active threads; only those in wait/sleep states.
- Calling thread cannot interrupt itself while sleeping.
- Resets thread's interrupted status after exception.

```java
// Complete lab from transcript
public class MyThread24 extends Thread {
    public void run() {
        try {
            System.out.println("Run start");
            Thread.sleep(5000); // Expecting 5 seconds pause
            System.out.println("Run resumed");
        } catch (InterruptedException e) {
            System.out.println("i is rise"); // Sleep interrupted
        }
    }
}

public class Main {
    public static void main(String[] args) {
        MyThread24 mt = new MyThread24();
        System.out.println("Main start");
        mt.start();
        Thread.sleep(1000); // Main sleeps briefly
        mt.interrupt(); // Interrupts MT1
        System.out.println("Interrupt is called");
    }
}
```

**Lab Steps:**
1. Run without interrupt: Wait 5 seconds.
2. Add interrupt: Observe premature wake-up.
3. Vary sleep times to test timing.

> [!IMPORTANT]
> InterruptedException indicates external interruption; always catch and handle appropriately.

## Join Method

### Deep Dive
The `join` method waits for another thread to complete before proceeding, enforcing sequential execution. It has forms: `join()`, `join(long milliseconds)`, `join(long milliseconds, int nanoseconds)`.

**Key Points:**
- Dependent wait: Pauses until joined thread finishes.
- Throws `InterruptedException` if interrupted.
- Useful for dependencies between threads.

**Workings:**
- No time specified: Wait indefinitely.
- Time specified: Wait max that time or until joined thread completes.

```java
// Example from transcript
public class Test36Join {
    public static void main(String[] args) throws InterruptedException {
        Thread th1 = new Thread(() -> { /* TH1 logic */ });
        Thread th2 = new Thread(() -> { /* TH2 logic dependent on TH1 */ });
        th1.start();
        th1.join(3000); // Main waits for TH1 (up to 3 sec)
        th2.start();
    }
}
```

**Lab Demos:**
1. Without join: Concurrent execution.
2. With join: TH1 completes first, then TH2.
3. Time-limited: Use timeouts to avoid infinite waits.

> [!NOTE]
> Prefer time-aware joins to avoid deadlocks.

## Synchronization Concept

### Deep Dive
Synchronization ensures thread-safe access to shared resources by allowing only one thread at a time to execute synchronized code on the same object, preventing data inconsistency.

**Problem Without Synchronization:**
```java
class Addition {
    int x, y;
    public void add(int a, int b) {
        x = a; y = b; // Thread T1 stores 50,60
        try { Thread.sleep(5000); } catch(InterruptedException e) {}
        System.out.println("Result: " + (x + y)); // T2 may read T1's modified values incorrectly
    }
}
// T1 and T2 on same Addition object → Wrong results e.g., 150 instead of 110.
```

**Solution:**
Use `synchronized` keyword.

**Deep Dive Concepts:**
- Locks the object: Other threads wait until unlock.
- Prevents race conditions where multiple threads modify shared data.

💡 Use for database operations, file accesses, shared collections.

## Object Lock vs Class Lock

### Deep Dive

**Object Lock:**
- Applies to instances (non-static methods/variables).
- Multiple instances: Each has its own lock.
- Used when threads share instance data.

**Class Lock:**
- Applies to static methods/variables.
- Shares across all instances of the class.
- Used when threads access static resources.

```java
class Addition {
    static int x; // Class variable
    synchronized public static void add(int a, int b) { // Class lock
        x = a;
        // Logic...
    }
}

// Without synchronized: Concurrent writes → Wrong results.
// With synchronized: Sequential writes → Correct results.
```

**Table:**

| Aspect | Object Lock | Class Lock |
|--------|-------------|------------|
| Scope | Instance-specific | Class-wide |
| Keyword on | Non-static method | Static method |
| Example Use | Shared object data | Shared static data |
| Lock Object | Current object | Class object |

**Lab:** Implement static synchronized method to demo class locking.

## Code Examples and Demos

### Complete Programs
Refer to transcript for exact code:
- Yield example output variation.
- Sleep interruption with try-catch.
- Join with timeouts preventing deadlocks.
- Synchronization demo: 110 and 150 correct results.

## Summary

### Key Takeaways
```diff
+ Threads run concurrently by default, but control methods like yield/sleep/join manage execution flow.
+ Yield is a non-guaranteed hint; sleep and join are forceful pauses.
+ Interrupt brings threads out of blocked states prematurely.
+ Synchronization locks objects/classes for sequential access to shared resources.
- Misuse of timeouts in join can cause deadlocks; prefer synchronized for data safety.
! Always handle InterruptedException to avoid ignoring interruptions.
```

### Expert Insight

**Real-world Application:** In banking systems, use synchronized blocks for deposit/withdraw operations on shared accounts to prevent overdrafts. Join ensures data processing completes before reports generate.

**Expert Path:** Master synchronized blocks (advanced than methods) for granular control. Combine survival with ExecutorService for thread pools. Benchmark apps with and without synchronization to quantify performance impacts—optimize by minimizing lock scopes.

**Common Pitfalls:** 
- Assuming yield guarantees pauses—test thoroughly.
- Ignoring InterruptedException leads to unresponsive threads; always reset status.
- Over-synchronizing causes deadlocks; use monitor locks sparingly.
- Infinite joins on unknown threads; always specify timeouts. Rare issues: Interrupted flag can be reset blindly—check status before continuing.

Lesser Known Things: Yield hints at JVM hotspots under load; synchronized uses monitor enter/exit bytecode for locks internally; class locks are global, impacting all instances.
