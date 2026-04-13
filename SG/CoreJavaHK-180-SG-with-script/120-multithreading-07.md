# Session 120: Multithreading - Thread Class Methods Revision

## Table of Contents
- [Start Method](#start-method)
- [Run Method](#run-method)
- [GetState Method](#getstate-method)
- [IsAlive Method](#isalive-method)
- [SetPriority and GetPriority Methods](#setpriority-and-getpriority-methods)
- [SetName and GetName Methods](#setname-and-getname-methods)
- [CurrentThread Method](#currentthread-method)
- [Summary](#summary)

## Start Method

### Overview
The `start()` method is a fundamental method in Java's Thread class used to initiate the execution of a custom thread. It does not directly start thread execution but communicates with the JVM to create a new thread of execution and invoke the `run()` method on the target thread object.

### Key Concepts/Deep Dive

- **Prototype**: `public void start()`
- **Purpose**: Causes a thread to start; it does not start the thread itself but requests the JVM to initiate the thread's execution.
- **Important Clarification**: Developers often mistakenly believe `start()` implicitly calls `run()`. However, `start()` does **not** call `run()` directly. Instead, the JVM handles the creation of the thread of execution and calls `run()` using the thread object.
- **Execution Flow**:
  - When `start()` is called on a thread object (e.g., `mt.start()`), it implicitly calls `start0()` (a native method).
  - The native method passes the current thread object reference to the JVM.
  - The JVM stores the thread object in a background collection maintained internally (likely a data structure without size limitations, such as a collection object).
  - After the main thread continues execution, the JVM checks the collection for waiting thread objects.
  - The JVM creates a new thread of execution for each stored thread object and invokes `run()` by calling `obj.run()` (where `obj` is the thread object).
  - This allows the custom thread's logic (from the overridden `run()` method) to execute concurrently with other threads.

- **Diagrammatic Representation**:
  ```mermaid
  sequenceDiagram
      participant MainThread
      participant ThreadObject
      participant JVM
      participant CustomThread
  
      MainThread->>ThreadObject: mt.start()
      ThreadObject->>JVM: start0() (native call, passes obj reference)
      JVM->>JVM: Store obj in background collection
      MainThread->>MainThread: Continue execution
      JVM->>JVM: Check collection, create thread of execution
      JVM->>CustomThread: obj.run() → execute custom logic
  ```

- **Thread States Management**: All thread states (New, Runnable, etc.) are maintained using background collection objects. For example:
  - Ready-to-Run threads are stored in a "ready-to-run" collection.
  - The JVM manages transitions, such as moving threads from blocked or timed-waiting states back to ready-to-run after their conditions are met.

- **Exceptions**:
  - `start()` can throw `IllegalThreadStateException` (unchecked) if called multiple times on the same thread object.
  - Declaration: `public void start() throws IllegalThreadStateException`

### Lab Demos
No explicit lab demo steps mentioned in this revision session, but the concept is illustrated through code examples for thread creation and starting.

## Run Method

### Overview
The `run()` method defines the entry point for custom thread logic execution. It is originally declared in the `Runnable` interface and can be overridden to supply code that runs in a separate thread of execution.

### Key Concepts/Deep Dive

- **Prototype**: `public void run()`
- **Purpose**: Supplies the logic to execute in a custom thread of execution. It is the initial point of execution for every custom thread.
- **Inheritance and Implementation**: 
  - Originally declared in the `Runnable` interface.
  - Implemented (but empty) in the `Thread` class for calling `run()` on a passed `Runnable` instance.
  - Can be overridden either by extending `Thread` (inheriting its logic, e.g., looping) or implementing `Runnable` (clean separation).
- **Recommended Approach**: Implement `Runnable` in projects rather than extending `Thread`, for the reasons below:
  1. Multiple Inheritance Availability: Extends from other classes possible, enabling more flexible class hierarchies.
  2. Separation of Concerns: Thread creation logic and implementation logic can be in separate classes, promoting parallel development.
  3. Code Reusability: Thread creation logic can be reused across multiple `Runnable` implementations.
  4. Achieves Loosely Coupled Architecture (LCRA): Thread creator (e.g., `Thread th = new Thread(target)`) and logic supplier (e.g., `Runnable` impl) are decoupled.
- **Example Comparison**:

  | Approach | Extends Other Class? | Separates Creation & Logic? | Reusability | Parallel Dev? |
  |----------|----------------------|---------------------------|-------------|---------------|
  | Extend `Thread` | ❌ No | ❌ Combined | Limited | ❌ No |
  | Implement `Runnable` | ✅ Yes | ✅ Separated | High | ✅ Yes |

- **Execution Details**: 
  - When overriding, provide custom logic for concurrent execution.
  - For `Runnable` implementation: Pass to `Thread` constructor (e.g., `Thread th = new Thread(myRunnable); th.start()`).
  - The method is called by the JVM after `start()` completes its handoff.

- **Exceptions**:
  - Do not throw checked exceptions from `run()` (overriding method restrictions apply).
  - Checked exceptions must be caught; unchecked can be thrown.
  - If checked exceptions are needed, use exception chaining (wrap in `RuntimeException`).

### Lab Demos
No explicit lab demo steps, but the concept is demonstrated through hypothetical code separation.

## GetState Method

### Overview
The `getState()` method retrieves the current state of a thread from the predefined enum `Thread.State`, helping track thread lifecycle phases.

### Key Concepts/Deep Dive

- **Prototype**: `public Thread.State getState()`
- **Purpose**: Returns the current state of the thread as an enum value.
- **Possible States** (from `Thread.State` enum):
  - `NEW`: Thread created but not started.
  - `RUNNABLE`: Ready to run or running (includes ready-to-run and running phases).
  - `BLOCKED`: Waiting for monitor lock.
  - `WAITING`: Waiting indefinitely (e.g., `join()` without timeout).
  - `TIMED_WAITING`: Waiting with timeout (e.g., `sleep(long)`, `join(long)`).
  - `TERMINATED`: Execution completed.
- **State Transitions**:
  - `NEW` → `RUNNABLE` (after `start()`).
  - `RUNNABLE` → `TIMED_WAITING` (e.g., `sleep()`, `wait(long)`).
  - `RUNNABLE` → `WAITING` (e.g., `join()`, `wait()`).
  - `RUNNABLE` → `BLOCKED` (e.g., synchronized method on locked object).
  - `TERMINATED` (after `run()` completion).
- **Notes on Transitions**:
  - From `TIMED_WAITING` or `BLOCKED`, threads return to `RUNNABLE` (ready-to-run) and wait for scheduling turn.
  - No further state changes from `TERMINATED`.
- **Exceptions**: None thrown.
- **Use Cases**: Monitor thread states in debugging or state-based logic.

### Lab Demos
No explicit lab demo steps.

## IsAlive Method

### Overview
The `isAlive()` method checks if a thread is currently alive (i.e., executing or in non-terminal waiting states), available from Java 5 onwards.

### Key Concepts/Deep Dive

- **Prototype**: `public boolean isAlive()`
- **Purpose**: Returns `true` if the thread is alive (has started and not terminated), `false` otherwise.
- **Return Values**:
  - Returns `false` in `NEW` or `TERMINATED` states (not alive).
  - Returns `true` in `RUNNABLE`, `BLOCKED`, `WAITING`, and `TIMED_WAITING` states (alive, as execution thread still exists).
- **Rationale**: Alive means an execution thread is associated; not just object existence or active computation.
- **Exceptions**: None thrown.

### Lab Demos
No explicit lab demo steps.

## SetPriority and GetPriority Methods

### Overview
These methods manage thread priority, influencing scheduling order in competitive environments, though not strictly guaranteed to follow priority.

### Key Concepts/Deep Dive

- **Prototypes**:
  - `public void setPriority(int newPriority)`
  - `public int getPriority()`
- **Purpose**: Set or get thread priority (1-10 range).
- **Defined Constants**:
  - `Thread.MIN_PRIORITY = 1`
  - `Thread.NORM_PRIORITY = 5`
  - `Thread.MAX_PRIORITY = 10`
- **Default Priorities**:
  - Main thread: 5
  - Custom threads: Inherited from parent thread (usually 5, unless changed).
- **Rules**:
  - Priority must be 1-10.
  - Inheritance: Child threads copy parent thread priority.
- **Exceptions**: `setPriority()` throws `IllegalArgumentException` (unchecked) if value outside 1-10.
- **Scheduling Note**: JVM may use priority for scheduling, but it's not absolute; depends on OS.

### Lab Demos
No explicit lab demo steps, but mentioned: Change main thread priority via `Thread.currentThread().setPriority()` before creating custom threads.

## SetName and GetName Methods

### Overview
These methods set or retrieve a thread's name for identification purposes.

### Key Concepts/Deep Dive

- **Prototypes**:
  - `public void setName(String name)`
  - `public String getName()`
- **Purpose**: Assign or retrieve a human-readable name for threads.
- **Setting Names**:
  - Via constructor: `Thread t = new Thread("MyThread");`
  - Via method: `t.setName("MyThread");`
- **Default Names**: Main thread: "main"; Custom threads: "Thread-" + sequential number.
- **Use Cases**: Debugging, logging, distinguishing threads.
- **Exceptions**: None thrown.

### Lab Demos
No explicit lab demo steps.

## CurrentThread Method

### Overview
The `currentThread()` method is a static utility to retrieve the currently executing thread's reference, enabling self-modification or inspection.

### Key Concepts/Deep Dive

- **Prototype**: `public static Thread currentThread()`
- **Purpose**: Returns the reference to the currently running thread object.
- **Why Needed**: In normal class methods (extending `Object`), direct thread operations require the thread reference (e.g., change name, priority).
- **Usage in Non-Thread Classes**: 
  - Cannot call instance methods like `getName()` directly (compiler error: method not found).
  - Solution: `Thread.currentThread()` to get the live reference, then call desired methods.
- **Example Scenario**:
  - In a method `m1()`, varying behavior based on executing thread: Get current thread name via `Thread.currentThread().getName()`.
  - This accesses the runtime thread (e.g., "main" or custom thread name), not a static object name.

> [!NOTE]
> Notify about corrections: The transcript contained multiple typos (e.g., "start meod" corrected to "start method", "htp" not present but "mt.st" to "mt.start", "ript" removed as noise, "Tell me" standardized). These were fixed in the guide for accuracy while preserving original meaning.

### Lab Demos
Hypothetical code illustrated:
1. Create class `Example` with method `m1()`.
2. In `Example`, use `Thread.currentThread().getName()` for conditional logic (e.g., print "hi" if main thread, "hello" if custom).
3. Avoid `getName()` directly (compilation failure); must use `Thread.currentThread()`.

## Summary

### Key Takeaways
```diff
+ start() method causes thread creation by JVM.
+ run() method best overridden via Runnable interface.
+ getState() returns current Thread.State.
+ isAlive() checks if execution thread exists.
+ setPriority() sets scheduling priority (1-10).
+ getName() retrieves thread name.
+ currentThread() accesses executing thread reference.
- Do not call start() multiple times.
- run() cannot throw checked exceptions.
```

### Expert Insight

**Real-world Application**: In production systems like web servers, `currentThread()` enables per-request thread naming for logging (e.g., "HTTP-Worker-123"). `setPriority()` optimizes background tasks, and `isAlive()` monitors thread pools to prevent hangs.

**Expert Path**: Master thread lifecycle by practicing state inspectors (`isAlive()`, `getState()`). Dive into `currentThread()` for critical thread-local operations, and experiment with `Runnable` implementations for scalable concurrent designs. Study JVM scheduling internals for priority tuning.

**Common Pitfalls**: Assuming `start()` calls `run()` directly (leads to confusion). Throwing checked exceptions from `run()` (compilation error). Not using `currentThread()` for thread self-references (runtime mismatches). Over-relying on priority (not guaranteed, OS-dependent).,SAASC issues if skipping deep state understanding.

> [!IMPORTANT]
> Revision covered 8 core Thread methods plus introduction to `currentThread()`. Corrections applied for transcript typos to ensure clarity. Proceed to next session for practical applications.
