# Session 122: Multithreading 08

## Table of Contents

- [**Thread Class Methods Revision**](#thread-class-methods-revision)
  - [Overview](#overview)
  - [Key Methods Discussed](#key-methods-discussed)
- [**thread.currentThread() Method**](#threadcurrentthread-method)
  - [Overview](#overview-1)
  - [Purpose and Usage](#purpose-and-usage)
  - [Example: Retrieving Currently Running Thread Object](#example-retrieving-currently-running-thread-object)
  - [Programmatic Thread Identification](#programmatic-thread-identification)
  - [Memory Diagram Explanation](#memory-diagram-explanation)
- [**Modifying Main Thread Properties**](#modifying-main-thread-properties)
  - [Overview](#overview-2)
  - [Changing Name and Priority](#changing-name-and-priority)
  - [Static Block Execution Context](#static-block-execution-context)
- [**Thread Groups**](#thread-groups)
  - [Overview](#overview-3)
  - [Default Group: "Main"](#default-group-main)
  - [Creating Custom Thread Groups](#creating-custom-thread-groups)
  - [Has-A Relationship Between Threads and Groups](#has-a-relationship-between-threads-and-groups)
- [**Thread Constructors with Group Reference**](#thread-constructors-with-group-reference)
  - [Overview](#overview-4)
  - [Passing Group Reference to Thread Constructor](#passing-group-reference-to-thread-constructor)
- [**getThreadGroup() Method**](#getthreadgroup-method)
  - [Overview](#overview-5)
  - [Usage and Return Type](#usage-and-return-type)
  - [Method Chaining for Group Information](#method-chaining-for-group-information)
- [**Overridden toString() Method in Thread Class**](#overridden-tostring-method-in-thread-class)
  - [Overview](#overview-6)
  - [Display Format](#display-format)
- [**Priority Inheritance from Parent Thread**](#priority-inheritance-from-parent-thread)
  - [Overview](#overview-7)
  - [Inheritance Behavior](#inheritance-behavior)
- [**Upcoming Topics**](#upcoming-topics)

## Thread Class Methods Revision

### Overview

This session begins with a revision of key thread class methods previously discussed, including start, run, getState, isAlive, set/get priority, set/get name, and currentThread. The focus is on reinforcing understanding before diving into new concepts.

### Key Methods Discussed
- **`start()`**: Initiates thread execution by calling the JVM and run() method internally.
- **`run()`**: Contains the logic to be executed by the thread.
- **`getState()`**: Returns the current state of the thread (e.g., NEW, RUNNABLE, BLOCKED).
- **`isAlive()`**: Checks if the thread is alive (started but not yet terminated).
- **`setPriority(int priority)`**: Sets the thread's priority (1-10, where higher is more important).
- **`getPriority()`**: Retrieves the thread's priority.
- **`setName(String name)`**: Sets the thread's name.
- **`getName()`**: Retrieves the thread's name.
- **`currentThread()`**: Static method to retrieve the currently running thread object.

## thread.currentThread() Method

### Overview

The `thread.currentThread()` method is a static method in the Thread class used to retrieve the reference to the currently running (executing) thread object. It returns a Thread object representing the thread that invoked this method.

### Purpose and Usage

This method is essential for accessing the currently executing thread within a normal (non-thread) class method or for performing operations on the main thread object. It is particularly useful in scenarios where you need to manipulate thread properties programmatically without explicit thread references.

- **Return Type**: `Thread`
- **Usage**: `Thread t = Thread.currentThread();`
- **When to Use**: 
  - To access or modify properties of the currently running thread.
  - In normal class methods where thread operations are needed.
  - To retrieve the main thread object for name or priority changes.

### Example: Retrieving Currently Running Thread Object

Consider a simple class with a method that needs to identify which thread is executing it:

```java
class Example {
    void m1() {
        // Logic here
    }
}
```

Without explicit thread handling, `m1()` could run in either main or custom threads. To programmatically determine this, use `currentThread()`:

```java
class Example {
    void m1() {
        Thread th = Thread.currentThread();  // Retrieves current thread object
        String threadName = th.getName();
        System.out.println("M1 is executed in " + threadName);
    }
}
```

When invoked:
- From `new Example().m1()` in main method: Output: "M1 is executed in main"
- After starting a custom thread via `new MyThread().start()` where `run()` calls `new Example().m1()`: Output: "M1 is executed in Thread-0"

### Programmatic Thread Identification

In multithreaded programs, distinguishing between main and custom thread execution is crucial. The example demonstrates how to use `currentThread()` to get the thread reference, then extract details like name or priority using instance methods.

### Memory Diagram Explanation

- **JVM Areas**: Method Area, Heap, Java Stack.
- **Thread Creation**: Main thread created by JVM, custom threads via `new Thread()`.
- **Heap Storage**: Each thread has an associated Thread object storing properties like name, priority, and thread group reference.
- When `Thread.currentThread()` is called, it returns the reference to the Thread object of the executing thread from the Heap.
- Inside `main()`: `Thread.currentThread()` points to main thread object.
- Inside `run()` of a custom thread: Points to that custom thread's object.

This enables operations like modifying name or priority of the currently running thread.

## Modifying Main Thread Properties

### Overview

Since the main thread is created by the JVM, its name defaults to "main" and priority to 5. Using `currentThread()`, you can change these properties dynamically.

### Changing Name and Priority

```java
public class MainThreadMod {
    public static void main(String[] args) {
        Thread th = Thread.currentThread();
        System.out.println("Initial name: " + th.getName());  // main
        System.out.println("Initial priority: " + th.getPriority());  // 5
        
        th.setName("MyMainThread");
        th.setPriority(9);  // Max priority 10, but JVM may normalize
        
        System.out.println("Updated name: " + th.getName());  // MyMainThread
        System.out.println("Updated priority: " + th.getPriority());  // 9 (or normalized)
    }
}
```

**⚠ Note**: `currentThread()` in `main()` returns the main thread object, allowing direct modification.

### Static Block Execution Context

Static blocks execute in the main thread. Thus, `Thread.currentThread().getName()` inside a static block returns "main" (or modified name if changed earlier).

```java
static {
    System.out.println("Static block in " + Thread.currentThread().getName());  // main
}
```

## Thread Groups

### Overview

Threads in JVM are organized into groups for management. Each thread belongs to exactly one group, which helps categorize and manage threads.

### Default Group: "Main"

- Every thread by default belongs to the "main" group, created implicitly by JVM at startup.
- The main group contains both the main thread and all custom threads unless explicitly assigned to another group.
- Group information is stored as a ThreadGroup reference in each Thread object (has-a relationship).

### Creating Custom Thread Groups

To create a custom group:
```java
ThreadGroup tg = new ThreadGroup("Group A");
```
- Use `ThreadGroup(String name)` constructor.
- Multiple constructors exist: check API docs for details (assignment: explore ThreadGroup constructors).

## Has-A Relationship Between Threads and Groups

- **Relationship Type**: Has-a (Thread has a ThreadGroup reference).
- The Thread object stores the ThreadGroup reference, not vice versa.
- Similar to: Student "has-a" Address, Employee "has-a" Bike.
- Analogy: In real life, students hold group references (e.g., via ID cards), not the classroom holding student references.

## Thread Constructors with Group Reference

### Overview

Thread class provides constructors to assign threads to specific groups. Use if you want threads in custom groups (not default "main").

### Passing Group Reference to Thread Constructor

```java
ThreadGroup tg = new ThreadGroup("Group A");
Thread t = new Thread(tg, "Child 1");  // t belongs to "Group A"
```

**Key Points**:
- Passing ThreadGroup requires specifying a custom thread name (no default names allowed).
- If not passed, thread defaults to "main" group.

Example:
```java
ThreadGroup tg1 = new ThreadGroup("Group A");
Thread t1 = new Thread(tg1, "Child 1");
ThreadGroup tg2 = null;  // Default
Thread t2 = new Thread("Child 2");  // Belongs to "main"
```

Now, `t1.getName()` → "Child 1"  
`t1.getThreadGroup().getName()` → "Group A"  
`t2.getThreadGroup().getName()` → "main"

## getThreadGroup() Method

### Overview

This Thread class method retrieves the ThreadGroup reference of the invoking thread object.

### Usage and Return Type

- **Return Type**: `ThreadGroup`
- **Usage**: `Thread.t.getThreadGroup()` returns the group reference.
- **Purpose**: To identify which group a thread belongs to.

### Method Chaining for Group Information

```java
Thread t = new Thread(tg, "Child 1");
ThreadGroup group = t.getThreadGroup();
String groupName = group.getName();  // "Group A"

// Or chained:
String groupName = t.getThreadGroup().getName();
```

**Diff Note**: `getThreadGroup()` returns reference, not name. Chain with `getName()` for group name.

Differences in output:
- `t.getName()` → Thread name ("Child 1")
- `Thread.currentThread().getName()` → Currently running thread name (e.g., "main")
- `t.getThreadGroup().getName()` → Group's name ("Group A")

## Overridden toString() Method in Thread Class

### Overview

Thread class overrides `Object.toString()` to provide meaningful information instead of "class@hashcode".

### Display Format

```java
Thread t = new Thread("Example");
System.out.println(t);  // Thread[Example,5,main]
```

- **Format**: `Thread[name,priority,groupName]`
- **Logic Inside toString()**: Returns `"Thread[" + getName() + "," + getPriority() + "," + getThreadGroup().getName() + "]"`

**Example Outputs**:
- Default Thread: `Thread[Thread-0,5,main]`
- Custom: `Thread[Child 1,5,Group A]`
- Modified main: `Thread[MyMainThread,9,main]`

## Priority Inheritance from Parent Thread

### Overview

When creating new threads, child threads inherit priority from their parent (creator) thread.

### Inheritance Behavior

- **Parent Thread**: Thread that creates child threads.
- **Inheritance Rule**: Child priority = Parent priority at creation time.
- **Changing Parent**: Affects future child threads, not existing ones (separate family analogy).
- **Custom Priority**: Set after creation using `setPriority()`.

Example:
```java
Thread.currentThread().setPriority(7);  // Main now priority 7
Thread t1 = new Thread("Pre-change");  // Inherits current priority 5 (unchanged)
Thread t2 = new Thread("Post-change");  // Inherits new priority 7
System.out.println(t1.getPriority());  // 5
System.out.println(t2.getPriority());  // 7
```

## Upcoming Topics

- Types of threads (daemon vs. user)
- Sleep method (Thread.sleep())
- Join method (joining threads)
- Synchronization
- Inter-thread communication
- Miscellaneous methods
- Thread creation with Lambda expressions
- Potential start of Collections overview

---

## Summary

### Key Takeaways

```diff
+ Thread.currentThread() retrieves the currently executing thread reference for programmatic access
+ Threads belong to groups; default "main" group created by JVM, custom groups via ThreadGroup class
+ Has-a relationship: Thread holds ThreadGroup reference; pass via constructor for assignment
+ getThreadGroup() returns group reference; chain with getName() for group details
+ toString() overridden in Thread to display [name,priority,group] format
+ Child threads inherit parent thread's priority; later changes only affect new creations
+ Modifying main thread properties possible via currentThread() after JVM creation
+ Static blocks run in main thread context
```

### Expert Insight

#### Real-world Application
Thread groups are crucial in large-scale Java applications (e.g., enterprise servers) for organizing threads by functionality. For example, grouping database threads separately from UI threads allows targeted management like setting priorities or handling exceptions. In logging frameworks, thread groups help categorize logs by thread type. Production systems use custom groups with ThreadGroup's methods for bulk operations like interrupting all threads in a group during shutdown.

#### Expert Path
Master thread groups by exploring All ThreadGroup API: `getMaxPriority()`, `setMaxPriority()`, `interrupt()`, and `enumerate()`. Practice with executor services where threads are managed implicitly. Dive into daemon threads vs. user threads for lifecycle control. Combine with concurrency utilities (e.g., ThreadPoolExecutor) to simulate group-based thread pooling. Read source code of JVM thread creation for deep insight.

#### Common Pitfalls
- Confusing group reference storage (thread holds group, not group holding threads) leads to incorrect has-a modeling.
- Calling `setPriority()` on parent doesn't retrofit existing children; always check inheritance rules.
- Using `getThreadGroup().getName()` without null checks if group not set (though rare).
- Forgetting custom names when using ThreadGroup constructor (no default "Thread-<n>").
- Static blocks assuming thread context; always verify with `currentThread()`.

These pitfalls often cause subtle bugs in multithreaded apps where group-based operations fail silently.

#### Lesser Known Things About This Topic
- ThreadGroup is obsolete in modern Java; replaced by Executor frameworks for cleaner resource management.
- Changing group max priority cascades to children but doesn't increase beyond 10.
- Thread groups support hierarchical organization (parents can have subgroups).
- JVM shutdown hooks run in a special shut down thread group.
- Race conditions in priority settings; synced access needed in concurrent mods.
