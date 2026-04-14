# Session 185: Multithreading 15

## Table of Contents
- [Thread Class Constructors](#thread-class-constructors)
- [Current Thread Method](#current-thread-method)
- [ToString Method](#tostring-method)
- [Daemon Threads](#daemon-threads)

## Thread Class Constructors

### Overview
The session continues the discussion on thread class constructors and methods in Java. The `Thread` class provides multiple constructors for creating thread objects, each with different purposes. The instructor reviews previously learned methods such as `start()`, `run()`, `setPriority()`, `getPriority()`, `setName()`, and `getName()`. New focus is on understanding constructor variations, including no-parameter, string parameter, and runnable parameter constructors. The discussion includes practical examples of creating and managing thread objects, including setting custom names and handling execution of `run()` methods.

### Key Concepts/Deep Dive
Thread class contains approximately eight constructors, with the following key ones explained:

1. **No-Parameter Constructor**: `new Thread()`
   - Creates a thread object with default name like "Thread-0".
   - Run method executes from the Thread class (empty implementation).

2. **String Parameter Constructor**: `new Thread(String name)`
   - Allows assigning a custom name to the thread.
   - If no name is provided, falls back to default naming.

3. **Runnable Parameter Constructor**: `new Thread(Runnable r)`
   - Accepts a Runnable object.
   - Default thread name; run method executes from the provided Runnable instance.

4. **Runnable + String Parameters**: `new Thread(Runnable r, String name)`
   - Combines Runnable object with custom name.
   - Ensures run method is called from the Runnable class.

Additional constructors involve Thread Groups, which will be covered in future examples.

### Code/Config Blocks
```java
class MyRunnable implements Runnable {
    public void run() {
        System.out.println("Run executed");
    }

    public static void main(String[] args) {
        MyRunnable mr = new MyRunnable();

        // No-param constructor
        Thread th1 = new Thread();
        th1.start(); // Executes Thread class run (empty)

        // String param constructor
        Thread th2 = new Thread("Child2");
        th2.start(); // Executes Thread class run

        // Runnable param
        Thread th3 = new Thread(mr);
        th3.start(); // Executes MyRunnable's run

        // Runnable + String param
        Thread th4 = new Thread(mr, "Child4");
        th4.start(); // Executes MyRunnable's run with custom name

        // Setting names after creation
        th1.setName("Child1");
        th3.setName("Child3");
        System.out.println(th1.getName()); // Child1
        System.out.println(th3.getName()); // Child3
    }
}
```

### Lab Demos
Demonstrate thread creation and method execution:
1. Create `MyRunnable` implementing `Runnable` with a `run()` method printing "Run executed".
2. In `main()`, instantiate `MyRunnable mr = new MyRunnable()`.
3. Use each constructor to create thread objects (th1, th2, th3, th4).
4. Call `start()` on each thread.
5. Observe output: Default names for th1 and th3, custom names for th2 and th4.
6. Display names using `getName()`.
7. Modify names using `setName()` and redisplay.

## Current Thread Method

### Overview
This section introduces the `Thread.currentThread()` method, which retrieves the reference to the currently executing thread. This is crucial for identifying the thread in which code is running, especially in multi-threaded environments. The instructor explains that this static method returns the Thread object for the currently running thread, allowing access to its properties like name, priority, and state.

### Key Concepts/Deep Dive
- **Purpose**: `Thread.currentThread()` returns the Thread object representing the thread that is currently executing the method.
- Used to get thread information (name, priority, etc.) inside any method.
- Essential when threads share methods or when determining execution context.

In the example, a Runnable class calls `Thread.currentThread().getName()` to display the thread name. Multiple threads executing the same Runnable will show different names.

For the main thread, calling `Thread.currentThread()` in `main()` returns the main Thread object (name: "main", default priority: 5). Properties like name and priority can be modified dynamically.

Assignment: Create a class `Example` with static method `m1()` that prints "Hi" if executing in "Thread-0", "Hello" if in "Thread-1", and "Who are you?" otherwise.

Thread priorities and groups are inherited from the parent thread.

### Code/Config Blocks
```java
public void run() {
    Thread th = Thread.currentThread();
    String name = th.getName();
    if (name.equals("Thread-0")) {
        System.out.println("Hi");
    } else if (name.equals("Thread-1")) {
        System.out.println("Hello");
    } else {
        System.out.println("Who are you?");
    }
}
```

Accessing main thread in main method:
```java
public static void main(String[] args) {
    Thread th = Thread.currentThread();
    System.out.println(th.getName()); // main
    System.out.println(th.getPriority()); // 5

    // Modify main thread
    th.setName("XYZ");
    th.setPriority(9);
}
```

### Lab Demos
Implement the assignment:
1. Create class `Example` with static method `m1()` checking current thread name and printing accordingly.
2. Create a Runnable class that calls `Example.m1()` in its `run()` method.
3. In `main()`, create two threads with the Runnable and start them.
4. Observe output: If `m1()` is called directly in `main()`, prints "Who are you?"; in started threads, prints "Hi" or "Hello" based on thread name.

## ToString Method

### Overview
The `toString()` method in the Thread class is overridden to provide a formatted string representation of the Thread object, including name, priority, and thread group. This is useful for debugging and logging. By default, if not overridden, it would return ClassName@hashCode, but Thread's version displays meaningful information.

### Key Concepts/Deep Dive
- **Format**: `toString()` returns: `Thread[name, priority, group]`
- Example: `Thread[main,5,main]`
- Called implicitly when printing Thread objects.
- Child threads inherit priority and group from parent.
- Modifying main thread priority affects future child threads, but not existing ones.

### Code/Config Blocks
```java
Thread th1 = new Thread("Child1");
System.out.println(th1); // Thread[Child1,5,main]

Thread th2 = Thread.currentThread();
System.out.println(th2); // Thread[main,5,main]

th2.setPriority(7);
Thread th3 = new Thread(); // Inherits priority 7 from main
System.out.println(th3); // Thread[Thread-1,7,main]
```

### Lab Demos
Demonstrate inheritance and modification:
1. Start with main thread (priority 5).
2. Create and display multiple Thread objects.
3. Change main thread priority to 7.
4. Create new threads and observe they inherit priority 7.
5. Existing threads retain old priority 5.

## Daemon Threads

### Overview
Java supports two types of threads: daemon threads and non-daemon threads. Daemon threads run in the background to assist other threads, like the garbage collector. Non-daemon threads handle user or business logic. By default, threads are non-daemon, inheriting the type from their parent.

### Key Concepts/Deep Dive
- **Types**:
  - **Daemon Thread**: Background helper threads (e.g., garbage collector). Executed only while non-daemon threads are active.
  - **Non-Daemon Thread**: Foreground threads for user operations (e.g., main thread).
- **Inheritance**: Child threads inherit daemon status from parent.
- **Management**:
  - `setDaemon(boolean)`: Must be called before `start()`; true for daemon.
  - `isDaemon()`: Returns daemon status.
- **Lifecycle**: JVM terminates when all non-daemon threads complete, potentially stopping daemon threads mid-execution.

### Code/Config Blocks
```java
class MyThread extends Thread {
    public void run() {
        for (int i = 1; i <= 10; i++) {
            System.out.println("Run: " + i);
        }
    }
}

public class DaemonExample {
    public static void main(String[] args) {
        MyThread mt = new MyThread();
        System.out.println(mt.isDaemon()); // false (non-daemon)

        mt.setDaemon(true); // Must be before start()
        mt.start();
        System.out.println("Main end"); // Ends first, daemon may be interrupted
    }
}
```

When daemon, output may show partial run execution since JVM doesn't wait.

### Lab Demos
Test daemon behavior:
1. Create `MyThread` extending Thread with a loop printing numbers.
2. In `main()`, create `MyThread` instance, check `isDaemon()` (false), set `setDaemon(true)`, then start.
3. Observe "Main end" prints immediately, and daemon thread's loop may not complete fully.

> [!IMPORTANT]
> Daemon threads do not guarantee full execution and are terminated when all non-daemon threads finish.

## Summary

### Key Takeaways
```diff
+ Thread class has multiple constructors for creating threads with varying names, runnables, and groups.
+ Thread.currentThread() retrieves the currently executing Thread object for accessing properties.
+ Thread.toString() provides formatted output of thread details including name, priority, and group.
- Thread priorities and daemon status are inherited from parent threads.
+ Daemon threads assist non-daemon threads but may be interrupted when user threads complete.
- setDaemon() must be called before start(), or IllegalThreadStateException is thrown.
```

### Expert Insight

**Real-world Application**: In server applications, use daemon threads for background tasks like logging or monitoring that shouldn't prevent the application from shutting down. Conversely, ensure critical user-facing operations run on non-daemon threads.

**Expert Path**: Master thread lifecycle management by combining constructors with thread control methods like `join()` and `sleep()` in the next session. Practice thread pooling to avoid manual daemon management.

**Common Pitfalls**: Attempting to change a thread's daemon status after starting results in exceptions; always set properties immediately after object creation. Modifying main thread properties only affects new child threads, not existing ones. Daemon threads can lead to incomplete background processes if not designed carefully—use `isAlive()` checks in non-daemons to synchronize.

Lesser-known things: Thread groups (default "main") allow grouping related threads for bulk operations, though less common in modern Java. The thread numbering (e.g., Thread-0) increments only for no-param constructors, not custom-named ones. Main threads can be renamed and prioritized dynamically, impacting application behavior.
