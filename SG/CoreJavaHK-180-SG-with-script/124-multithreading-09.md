# Session 124: Multithreading 09 - Daemon Threads

## Table of Contents
- [Daemon Threads Overview](#daemon-threads-overview)
- [Types of Threads](#types-of-threads)
- [JVM Behavior with Threads](#jvm-behavior-with-threads)
- [Creating Custom Daemon Threads](#creating-custom-daemon-threads)
- [Thread States and Method Restrictions](#thread-states-and-method-restrictions)
- [Implementation with Runnable Interface](#implementation-with-runnable-interface)
- [Dynamic Thread Logic](#dynamic-thread-logic)

## Daemon Threads Overview
In Java, threads are classified into two types based on their execution purpose. Daemon threads run background processes to support user-facing (foreground) threads, while user (non-daemon) threads execute main application logic. Understanding daemon threads is crucial for efficient application design, as they help manage system tasks without waiting for complete execution during shutdown.

## Types of Threads
Java supports two types of threads:
- **Daemon threads**: Threads that provide support services to user threads by handling background tasks.
- **Non-daemon (user) threads**: Threads that execute the main business logic of an application.

### Definitions
- A **daemon thread** executes background tasks and helps other threads complete their work.
- A **non-daemon thread** executes foreground tasks for running business logic and user-facing operations.

### Examples
- **User thread**: Main thread in applications, responsible for core execution.
- **Daemon thread**: Garbage collector thread, which cleans up unreferenced objects from the heap to free memory for other threads.

> [!TIP]
> Daemon threads are essential for system-level support but should never be relied upon for critical operations.

## JVM Behavior with Threads
The Java Virtual Machine (JVM) handles thread lifecycles differently based on thread type:

### JVM Runtime
JVM continues running until all non-daemon threads complete execution. Daemon threads are not waited for during shutdown.

### Key Points
```diff
+ JVM waits for all non-daemon threads to complete execution.
- JVM does not wait for daemon threads to complete; they terminate automatically during shutdown.
```

#### Example Scenario
- If a program has only daemon threads running and no non-daemon threads, JVM shuts down immediately.
- Dependency: The existence of at least one non-daemon thread keeps the JVM alive; daemon threads are secondary and can be terminated prematurely.

```diff
+ Primary threads (non-daemon): Define the application's lifetime.
- Supporting threads (daemon): May be killed without completing full execution.
```

### Real-World Analogy
- **Non-daemon thread** (customer): Drives business activities.
- **Daemon thread** (employee): Supports the customer but operates only while customers are present.
- Example: A bus (daemon) only runs with passengers (non-daemon); businesses shut down without customers.

## Creating Custom Daemon Threads
By default, all custom threads inherit the daemon property from their parent thread.
- If the parent thread (typically main) is non-daemon, child threads are also non-daemon.

### Using setDaemon() Method
To create a daemon thread:
- Call `setDaemon(true)` on the Thread object **before starting** the thread.
- If called after `start()`, an `IllegalThreadStateException` is thrown.

#### Syntax
```java
MyThread mt = new MyThread();  // mt is initially non-daemon (inherits from parent)
mt.setDaemon(true);            // Change to daemon
mt.start();                    // Thread starts as daemon
```

> [!IMPORTANT]
> - `setDaemon()` must be called when the thread is in the **New** state.
> - Default property: Non-daemon (same as parent thread).
> - Check daemon status: `isDaemon()` returns true/false.

#### Code Example
```java
class MyThread extends Thread {
    public void run() {
        // Background logic
    }
}

public class Main {
    public static void main(String[] args) {
        MyThread mt = new MyThread();
        mt.setDaemon(true);  // Mark as daemon
        mt.start();
        // Rest of main logic
    }
}
```

## Thread States and Method Restrictions
The `setDaemon()` method can only be invoked when the thread is in the New state (before `start()`).

### Exception Handling
- If `setDaemon()` is called after `start()`, JVM throws `IllegalThreadStateException`.
- This restriction ensures thread properties are set at creation time, similar to deciding a train route before departure.

| State | setDaemon() Allowed | Behavior |
|-------|---------------------|----------|
| New   | Yes                | Sets daemon property |
| Runnable | No            | Throws IllegalThreadStateException |
| Running | No              | Throws IllegalThreadStateException |
| Waiting | No               | Throws IllegalThreadStateException |

## Implementation with Runnable Interface
Daemon threads can also be implemented using the `Runnable` interface, which supports multiple inheritance.

### Basic Implementation
```java
class DaemonDemo implements Runnable {
    public void run() {
        Thread current = Thread.currentThread();
        for (int i = 0; i < 100; i++) {
            System.out.println(current.getName() + ": " + i);
        }
    }
}

public class Main {
    public static void main(String[] args) {
        DaemonDemo dd = new DaemonDemo();
        Thread th = new Thread(dd);
        th.setDaemon(true);
        th.start();
        System.out.println("Main start");
        // Main logic
        System.out.println("Main end");
    }
}
```

### Constructor-Based Thread Creation
To automate thread creation in the constructor (common pattern for reusability):

```java
class DaemonDemo implements Runnable {
    public DaemonDemo() {
        Thread t = new Thread(this);  // Pass 'this' as target
        t.setDaemon(true);            // Optional: set as daemon
        t.start();                    // Start thread in constructor
    }
    
    public void run() {
        // Implementation
    }
}
```

This creates a new thread for each object instance, with `this` passed as the Runnable target.

### Dynamic Configuration
Pass parameters to constructors for flexible daemon/non-daemon creation:

```java
class DaemonDemo implements Runnable {
    private int iterations;
    private boolean daemon;

    public DaemonDemo(int iterations, boolean daemon) {
        this.iterations = iterations;
        this.daemon = daemon;
        Thread t = new Thread(this);
        t.setDaemon(daemon);
        t.start();
    }

    public void run() {
        Thread current = Thread.currentThread();
        for (int i = 0; i < iterations; i++) {
            System.out.println(current.getName() + ": " + i);
        }
    }
}
```

## Dynamic Thread Logic
Enhance classes for variable behavior based on parameters:

### Example with Dynamic Iterations
```java
class MyDaemonDemo implements Runnable {
    private int max;
    private boolean daemonFlag;

    public MyDaemonDemo(int max, boolean daemonFlag) {
        this.max = max;
        this.daemonFlag = daemonFlag;
        Thread t = new Thread(this);
        t.setDaemon(daemonFlag);
        t.start();
    }

    public void run() {
        Thread current = Thread.currentThread();
        for (int i = 0; i < max; i++) {
            System.out.println(current.getName() + ": " + i);
        }
    }
}
```

In this setup, iterations vary based on constructor arguments, and daemon property is configurable.

## Summary: Key Takeaways
```diff
+ Daemon threads assist non-daemon threads in background tasks like garbage collection.
- Daemon threads do not prevent JVM shutdown; JVM waits only for non-daemon threads.
! Always set daemon status before calling start() to avoid IllegalThreadStateException.
+ Use Thread.currentThread() in Runnable implementations to access thread properties.
+ Implement constructor logic for automated thread creation in utility classes.
```

## Expert Insight

**Real-world Application**: In web servers, daemon threads handle tasks like connection pooling or cleanup operations alongside main request-handling threads. They ensure system stability by freeing resources without blocking shutdown, ideal for long-running services.

**Expert Path**: Master daemon threads by:
- Designing systems where non-daemon threads manage critical logic (e.g., I/O operations) and daemon threads handle auxiliary tasks (e.g., logging, monitoring).
- Using ThreadFactory in executors to create daemon threads for thread pools.
- Running experiments in IDEs to observe JVM behavior with mixed thread types.

**Common Pitfalls**:
- Calling `setDaemon()` after `start()`: Throws IllegalThreadStateException; fix by calling it immediately after object creation.
- Assuming daemon threads complete execution: They may be terminated abruptly; avoid using them for tasks requiring full completion (e.g., data saving); relocate such logic to non-daemon threads.
- Misunderstanding inheritance: Child threads inherit daemon property from parent; explicitly set if needed.
- Handling InterruptedException: Though rare, wrap sleep calls in try-catch for robustness in production code.

**Lesser-Known Aspects**: Daemon threads maintain lower CPU priority, starting as non-daemon by default. In server applications, they minimize resource leaks by not tying up JVM life, but caution is needed with finalizer threads (implicitly daemon) to prevent data loss.
