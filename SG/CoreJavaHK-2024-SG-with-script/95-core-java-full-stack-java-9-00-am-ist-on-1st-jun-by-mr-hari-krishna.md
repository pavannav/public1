# Session 95: Types of Threads (Daemon and Non-Daemon) in Java

> [!NOTE]   
> Corrections from transcript: "demon" corrected to "daemon", "nondemon" to "non-daemon".

## Table of Contents

- [Types of Threads](#types-of-threads)
- [Daemon Thread Characteristics](#daemon-thread-characteristics)
- [Non-Daemon Thread Characteristics](#non-daemon-thread-characteristics)
- [Setting Daemon Property](#setting-daemon-property)
- [Thread State and Daemon Setting](#thread-state-and-daemon-setting)
- [Daemon Thread Lifecycle](#daemon-thread-lifecycle)
- [Thread Properties](#thread-properties)
- [Stages of Multi-threading](#stages-of-multi-threading)
- [Controlling Thread Execution Methods](#controlling-thread-execution-methods)
- [Summary](#summary)

## Types of Threads

### Overview
In Java multi-threading, threads are categorized into two main types based on their purpose and JVM behavior:
- **Daemon threads**: Provide background services to other threads.
- **Non-daemon (user) threads**: Execute main business logic.

The main thread is a non-daemon thread by default. Custom threads inherit the daemon property from their parent thread. If the parent is daemon, the child is also daemon; if parent is non-daemon, child is also non-daemon.

### Daemon Thread Characteristics
A daemon thread provides services to other threads and does not prevent the JVM from shutting down. Key points:
- Executes background tasks
- JVM does not wait for daemon threads to complete
- Suitable for supporting infrastructure like garbage collection
- Example: Java's garbage collector thread is a daemon thread

### Non-Daemon Thread Characteristics
Non-daemon threads execute business logic and force the JVM to wait until they complete. Key points:
- Executes user/business logic
- JVM waits for all non-daemon threads to finish before shutting down
- Main thread is non-daemon by default

## Setting Daemon Property

### Overview
Use the `setDaemon(boolean)` method to set a thread as daemon before starting it. By default, custom threads become daemon if created from a daemon parent thread.

### Code Example
```java
class MyThread extends Thread {
    public void run() {
        for (int i = 1; i < 20; i++) {
            System.out.println("run: " + i);
        }
        System.out.println("run end");
    }
}

public class Main {
    public static void main(String[] args) {
        MyThread t = new MyThread();
        t.setDaemon(true);  // Set as daemon before starting
        t.start();
        System.out.println("main end");
    }
}
```

### Key Concepts/Deep Dive
- **Default behavior**: Custom threads created from main thread are non-daemon
- **Inheritance**: Child threads inherit daemon status from parent
- **Purpose**: Use daemon for background services, non-daemon for critical business logic

## Thread State and Daemon Setting

### Overview
The `setDaemon(boolean)` method can only be called when the thread is in NEW state (before `start()` is called).

### Invalid Operations
```java
Thread t = new Thread();
// Valid: setDaemon before start
t.setDaemon(true);
t.start();

// Invalid: setDaemon after start - throws IllegalThreadStateException
// t.setDaemon(true);  // This will throw exception if called here
```

- **Exception**: `IllegalThreadStateException` if called after `start()`
- **Reason**: JVM has already categorized the thread based on daemon status

## Daemon Thread Lifecycle

### Daemon Thread Collections
- **Demon Threads Collection**: Stores daemon threads
- **Non-Demon Threads Collection**: Stores non-daemon threads
- JVM decides thread type by calling `isDaemon()` and assigns to appropriate collection during `start()`
- JVM runs until non-daemon threads complete; daemon threads terminate when no non-daemon threads remain

### Behavior
- **Non-daemon thread completion**: JVM continues until all non-daemon threads finish
- **Daemon-only remaining**: JVM shuts down, terminating daemon threads even if incomplete
- **Exception handling**: Exceptions in daemon threads may not be fully handled, but JVM shutdown occurs based on non-daemon threads

## Thread Properties

### Overview
Each thread object contains several properties managed internally:

| Property | Type | Default Value | Description |
|----------|------|---------------|-------------|
| target | Runnable | null | Reference to Runnable object (for run method) |
| name | String | Thread-0, Thread-1, etc. | Thread name |
| priority | int | 5 | Priority level (1-10) |
| daemon | boolean | false | Daemon status |
| group | ThreadGroup | main | Thread group reference |
| id | long | incremental | Unique thread ID |
| status | int | 0 (new) | Thread state |

### Methods for Properties
- **Getter methods**: `isDaemon()`, `getName()`, `getPriority()`, etc.
- **Setter methods**: `setDaemon(boolean)`, `setName(String)`, `setPriority(int)`, etc.
- Properties can be set/get using appropriate methods

## Stages of Multi-threading

### Overview
Multi-threading programming involves three main stages:

1. **Stage 1: Create, Start, and Run**
   - Create thread object (extends Thread or implements Runnable)
   - Call `start()` to begin execution
   - Implement `run()` method for thread logic

2. **Stage 2: Get/Set Thread Properties**
   - Access and modify thread attributes (name, priority, daemon, etc.)
   - Use getter/setter methods to control thread behavior

3. **Stage 3: Control Thread Execution**
   - Manually control thread execution flow (pause, resume, join)
   - Use static and instance methods for thread synchronization

## Controlling Thread Execution Methods

### Overview
JVM-only control is default; these methods allow manual control.

| Method | Type | Purpose |
|--------|------|---------|
| `yield()` | static | Pass current thread's execution to scheduler |
| `sleep(long)` | static | Pause execution for specified milliseconds |
| `sleep(long, int)` | static | Pause with millisecond and nanosecond precision |
| `interrupt()` | instance | Interrupt sleeping threads |
| `join()` | instance | Wait for thread to complete |
| `join(long)` | instance | Wait with timeout |
| `join(long, int)` | instance | Wait with timeout in nanoseconds |
| `wait()` | instance | Pause in synchronized block until notify |
| `notify()` | instance | Wake one waiting thread |
| `notifyAll()` | instance | Wake all waiting threads |

### Key Notes
- `sleep()`, `join()`, `wait()` throw `InterruptedException` if interrupted
- Use `interrupt()` to wake sleeping threads

## Summary

### Key Takeaways
```diff
+ There are two types of threads: daemon (background services) and non-daemon (business logic)
+ Daemon threads do not prevent JVM shutdown; non-daemon threads do
+ setDaemon(boolean) must be called before start() to avoid IllegalThreadStateException
+ Threads inherit daemon status from parent
+ JVM maintains separate collections for daemon and non-daemon threads
+ Daemon threads terminate when no non-daemon threads remain
+ Thread objects have properties: name, priority, daemon, group, id, status
+ Multi-threading has three stages: create/start/run, property management, execution control
+ Methods like yield(), sleep(), join(), wait() enable manual thread execution control
```

### Expert Insight

**Real-world Application**: Daemon threads are crucial for server applications running background tasks like logging, monitoring, or cleanup processes without blocking application shutdown. Non-daemon threads ensure critical operations like data processing complete before application termination.

**Expert Path**: Study thread priorities (1-10), thread groups for organization, and synchronization mechanisms. Practice implementing thread-safe data structures and understand thread-local variables for advanced multi-threading.

**Common Pitfalls**: Calling setDaemon() after start() causes runtime exceptions; not handling InterruptedException properly leads to thread leaks; overusing daemon threads can result in incomplete cleanup operations on JVM shutdown.

**Issues and Resolutions**: 
- **IllegalThreadStateException**: Ensure setDaemon() is called before start(); resolve by rearranging method calls
- **Thread not terminating expected**: Verify daemon vs non-daemon status; daemon threads may not guarantee completion
- **InterruptedException handling**: Always wrap sleep/join/wait in try-catch to properly handle interruptions

**Lesser Known Things**: Calling setDaemon() multiple times is valid (last call wins); JVM internally uses daemon threads for garbage collection; thread properties are set atomically but not synchronized.
