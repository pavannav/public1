# Session 188: Multithreading 18

## Table of Contents
- [Inter Thread Communication](#inter-thread-communication)
  - [Overview](#overview)
  - [Key Concepts/Deep Dive](#key-conceptsdeep-dive)
  - [Code Examples](#code-examples)
  - [Why Wait and Notify Methods are in Object Class](#why-wait-and-notify-methods-are-in-object-class)
- [Summary](#summary)
  - [Key Takeaways](#key-takeaways)
  - [Expert Insight](#expert-insight)

## Inter Thread Communication

### Overview
Inter-thread communication refers to the process of enabling multiple threads to execute sequentially and alternatively while sharing the same object. It ensures that threads communicate and coordinate their actions, such as one thread producing data and another consuming it, in a synchronized manner. This is crucial for scenarios where threads need to wait for each other to complete specific operations before proceeding, avoiding issues like deadlock or incorrect execution order.

### Key Concepts/Deep Dive
- **Sequential vs. Concurrent Execution**: Threads can run concurrently, but inter-thread communication enforces sequential execution when sharing an object. For example, one thread must complete its operation before allowing another to proceed.
- **Analogy: Hotel Dosa Preparation**:
  - The hotel owner (producer thread) prepares dosas.
  - The customer (consumer thread) eats dosas.
  - The owner prepares only after an existing dosa is eaten (communication).
  - Without communication, the owner might overproduce (waste), or customers might eat unprepared dosas.
- **Producer-Consumer Model**:
  - Producer generates items (e.g., produces dosas).
  - Consumer consumes items (e.g., eats dosas).
  - Execution alternates: Produce → Consume → Produce → Consume.
  - Both threads share the same object (e.g., a factory storing items).
- **Synchronization Alone is Not Sufficient**:
  - `synchronized` keyword locks the object to allow only one thread at a time, ensuring sequential access to methods like `modify` and `read`.
  - However, for inter-thread communication, threads must wait for signals from each other (e.g., producer waits if storage is full; consumer waits if empty).
  - Methods like `sleep` and `join` are not ideal:
    - `sleep`: Pauses for a fixed time, not tied to other thread's completion.
    - `join`: Causes deadlock if threads wait for each other indefinitely.
- **Wait and Notify Methods**:
  - `wait()`: Pauses the current thread and releases the object lock, allowing other synchronized methods to execute. Must be called within a synchronized block.
  - `notify()`: Wakes up one waiting thread.
  - `notifyAll()`: Wakes up all waiting threads (use when more than two threads participate).
  - These must be combined with `synchronized` for proper inter-thread communication.
- **Inter-Thread Communication Workflow**:
  - Inside business methods (e.g., `produce` and `consume`):
    - Use `if` conditions to check state (e.g., items available).
    - Call `wait()` if condition not met.
    - After operation, update state and call `notify()` or `notifyAll()` to wake waiting threads.
- **Handling InterruptedException**:
  - `wait()` can throw `InterruptedException`, so surround with `try-catch`.
- **Deadlock Prevention**:
  - Ensure proper `wait()` releases locks, allowing other threads to proceed.

### Code Examples
The following example demonstrates a producer-consumer scenario using inter-thread communication.

```java
class Factory {
    private int items = 0;
    private boolean itemsAvailable = false;

    public synchronized void produce(int numItems) {
        try {
            // Wait if items are already available
            if (itemsAvailable) {
                wait();
            }
            // Produce items
            items += numItems;
            System.out.println("Items produced: " + items);
            itemsAvailable = true;
            // Notify consumer
            notify();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    public synchronized void consume(int numItems) {
        try {
            // Wait if no items available
            if (!itemsAvailable) {
                wait();
            }
            // Consume items
            items -= numItems;
            System.out.println("Items consumed: " + items);
            itemsAvailable = false;
            // Notify producer
            notify();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}

class Producer implements Runnable {
    private Factory factory;

    public Producer(Factory factory) {
        this.factory = factory;
    }

    public void run() {
        for (int i = 1; i <= 10; i++) {
            factory.produce(i);
        }
    }
}

class Consumer implements Runnable {
    private Factory factory;

    public Consumer(Factory factory) {
        this.factory = factory;
    }

    public void run() {
        for (int i = 1; i <= 10; i++) {
            factory.consume(i);
        }
    }
}

public class Test {
    public static void main(String[] args) {
        Factory factory = new Factory();
        Producer p1 = new Producer(factory);
        Consumer c1 = new Consumer(factory);

        Thread t1 = new Thread(p1);
        Thread t2 = new Thread(c1);

        t1.start();
        t2.start();
    }
}
```

- **Execution Flow**:
  - Producer attempts to produce; if items available, waits.
  - Consumer attempts to consume; if no items, waits.
  - After producing, notifies consumer; after consuming, notifies producer.
  - Produces and consumes alternately: 1 produced → 1 consumed → 2 produced → 2 consumed → etc.

### Why Wait and Notify Methods are in Object Class
- `wait()`, `notify()`, and `notifyAll()` are defined in `java.lang.Object`, not `Thread`, because:
  - They operate on the object lock, not the thread itself.
  - They allow unlocking the object while pausing the thread, enabling other synchronized methods.
  - Calling them on the class object ensures access to the lock associated with that instance.
- Example: `factory.wait()` pauses the calling thread and unlocks `factory` for other threads.

## Summary

### Key Takeaways
```diff
+ Inter-thread communication ensures sequential execution of threads sharing objects, using synchronized, wait, and notify methods.
- Without proper synchronization, threads may cause deadlock or incorrect data access.
+ Producer-consumer is a classic model for understanding wait/notify mechanisms.
+ Use notifyAll() for scenarios with multiple waiting threads.
+ Always handle InterruptedException when calling wait().
```

### Expert Insight

#### Real-world Application
Inter-thread communication is essential in scenarios like thread pools, message queues, or producer-consumer systems (e.g., web servers handling requests and responses). For instance, in a web crawler, one thread crawls pages (producer) and stores URLs, while another processes them (consumer), ensuring no overrun or starvation.

#### Expert Path
To master this topic, implement various producer-consumer variants (e.g., bounded buffer). Study Java's `BlockingQueue` in the concurrent package as a higher-level abstraction built on these primitives. Practice with multithreaded unit tests to verify sequential behavior.

#### Common Pitfalls
- **Forgetting to Notify**: After updating state, always call `notify()` or `notifyAll()` to wake waiting threads; otherwise, threads remain stuck.
- **Using Sleep Instead of Wait**: Sleep pauses without releasing locks, leading to deadlock. Solution: Use `wait()` for inter-thread coordination.
- **Race Conditions**: Multiple producers/consumers without proper checks can overwrite each other. Resolution: Always combine state checks with wait/notify in synchronized blocks.
- **Incorrect Notify Usage**: Calling `notify()` when no thread is waiting wastes calls; use `notifyAll()` for safety when unsure.
- **InterruptedException Ignored**: Failing to handle it can cause silent failures. Resolution: Catch and handle appropriately (e.g., logging or re-interrupting).
- Lesser Known: `wait(long timeout)` allows timed waits; `notify()` wakes one random thread, so for fairness, consider `BlockingQueue`.

**Mistakes and Corrections in Transcript**:
- "thre" corrected to "thread".
- "do" corrected to "dosa" (assuming context about Indian food).
- "ript" at start appears to be a typo or incomplete word; likely "script" or irrelevant.
- "sing roniz" corrected to "synchronized".
- "cubectl" not present, but "htp" examples given in instruction aren't here.
- "inter thre" corrected to "inter-thread".
- Various repetitions and verbal fillers removed for clarity in the study guide. All content follows the transcript's order without skipping topics.
