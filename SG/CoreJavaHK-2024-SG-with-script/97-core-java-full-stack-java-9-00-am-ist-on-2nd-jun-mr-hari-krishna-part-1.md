# Session 97: Multi-Threading Fundamentals (Part 1)

## Table of Contents
- [Deadlock](#deadlock)
- [Inter Thread Communication](#inter-thread-communication)
- [Summary](#summary)

## Deadlock

### Overview
Deadlock is a critical condition in multi-threaded programming where two or more threads are unable to proceed with their execution because each is waiting for the other to release a resource. This creates a circular dependency between threads, resulting in a permanent blockage. Understanding deadlock is essential for writing robust concurrent programs, as it directly impacts system stability and performance in production environments.

### Key Concepts/Deep Dive

Deadlock occurs when multiple threads compete for shared resources and each holds a lock that the other waits to acquire. The four necessary conditions for deadlock are:

1. **Mutual Exclusion**: Resources cannot be shared simultaneously
2. **Hold and Wait**: A thread holding one resource waits for another
3. **No Preemption**: Resources cannot be forcibly taken from threads
4. **Circular Wait**: Threads form a circular chain of waiting

Deadlock can be demonstrated using two threads where each calls methods on objects already locked by the other thread, creating a permanent waiting state.

#### Deadlock with Join Method
```java
class A extends Thread {
    B b;
    
    public void setB(B b) {
        this.b = b;
    }
    
    public void run() {
        System.out.println(Thread.currentThread().getName() + " started");
        System.out.println(Thread.currentThread().getName() + " is calling join on B thread");
        try {
            b.join();
        } catch (InterruptedException e) {
            // handle exception
        }
        System.out.println(Thread.currentThread().getName() + " resumed");
        System.out.println(Thread.currentThread().getName() + " end");
    }
}

class B extends Thread {
    A a;
    
    public void setA(A a) {
        this.a = a;
    }
    
    public void run() {
        a.start();
        System.out.println(Thread.currentThread().getName() + " started");
        this.join(); // wait for A to complete
        System.out.println(Thread.currentThread().getName() + " end");
    }
}

public class Main {
    public static void main(String[] args) {
        A a1 = new A();
        B b1 = new B();
        
        a1.setB(b1);
        b1.setA(a1);
        
        b1.start(); // deadlock occurs here
    }
}
```

**Execution Flow**:
1. Thread B starts and calls A.start()
2. Thread A starts and calls b.join() - waits for B to complete
3. Thread B calls this.join() - waits for A to complete
4. Both threads are now waiting forever → deadlock

> [!WARNING]
> Calling join() mutually between threads creates deadlock. Always design thread joining logic carefully.

#### Deadlock with Synchronized Methods
Deadlock can also occur when synchronized methods call each other in a circular manner:

```java
class FirstClass {
    SecondClass sc;
    
    synchronized void m1(SecondClass sc) {
        String name = Thread.currentThread().getName();
        System.out.println(name + " called : FirstClass.m1 start");
        try { Thread.sleep(1000); } catch (Exception e) {}
        sc.m2(this);
        System.out.println(name + " called : FirstClass.m1 end");
    }
    
    synchronized void m4() {
        System.out.println("m4 is executed");
    }
}

class SecondClass {
    synchronized void m2(FirstClass fc) {
        String name = Thread.currentThread().getName();
        System.out.println(name + " called : SecondClass.m2 start");
        fc.m4();
        System.out.println(name + " called : SecondClass.m2 end");
    }
    
    synchronized void m3(FirstClass fc) {
        String name = Thread.currentThread().getName();
        System.out.println(name + " is calling FirstClass.m3");
        fc.m4();
    }
}
```

**Deadlock Scenario**:
- Thread 1 calls `fc.m1(sc)` - locks FirstClass object
- Thread 2 calls `sc.m2(fc)` - locks SecondClass object  
- Thread 1 calls `sc.m3()` - waits for SecondClass lock (held by Thread 2)
- Thread 2 calls `fc.m4()` - waits for FirstClass lock (held by Thread 1)
- Deadlock: circular waiting between synchronized methods

### Code/Config Blocks
All code examples use `java` syntax highlighting for clarity.

- Use sleep time in join to avoid permanent deadlock:
  ```java
  b.join(5000); // wait for B to complete for 5 seconds
  ```

### Lab Demos
#### Step-by-step Deadlock Creation with Join
1. Create class A extending Thread with private B b and setB method
2. Create class B extending Thread with private A a and setA method  
3. Override A's run() method to print start message, call b.join(), print resume message
4. Override B's run() method to start A, print start message, call this.join(), print end message
5. Create instances a1 and b1, set cross-references with setter methods
6. Start b1 thread - observe deadlock in output

#### Step-by-step Deadlock Creation with Synchronization
1. Create FirstClass with synchronized m1() that takes SecondClass parameter
2. Create SecondClass with synchronized m2() taking FirstClass parameter
3. Add synchronized m3() and m4() methods in respective classes
4. Make m1() sleep then call sc.m3(), m2() call fc.m4()  
5. Create threads calling m1() and m2() concurrently
6. Declare m3() and/or m4() as synchronized to trigger deadlock

**Expected Output**:
- Without synchronization: threads execute normally
- With partial synchronization: normal execution
- With complete synchronization and circular calls: deadlock occurs

> [!NOTE]
> Practice typing the complete code without copying to understand threading concepts deeply.

## Inter Thread Communication

### Overview
Inter Thread Communication (ITC) enables threads to coordinate their execution in a sequential and alternating manner, rather than concurrent access that could lead to data corruption. It builds upon synchronization by adding communication mechanisms where threads can wait for specific conditions and notify each other when those conditions change. This is crucial for producer-consumer scenarios and ensures proper orchestration of multi-threaded workflows.

### Key Concepts/Deep Dive

ITC uses three key methods:
- `wait()`: Causes current thread to pause and release object lock
- `notify()`: Wakes up one waiting thread on the same object
- `notifyAll()`: Wakes up all waiting threads on the same object

The standard ITC pattern involves:
1. Synchronize methods accessing shared data
2. Check condition before proceeding
3. If condition not met, call wait()
4. Perform operation and update condition
5. Call notify() or notifyAll() to wake other threads

#### Producer-Consumer Example
```java
class Factory {
    private int items = 0;
    private boolean itemsAvailable = false;
    
    public synchronized void produce(int numItems) {
        if (itemsAvailable) {
            try { wait(); } catch (InterruptedException e) {}
        }
        items += numItems;
        itemsAvailable = true;
        System.out.println("Items produced: " + items);
        notify();
    }
    
    public synchronized void consume(int numItems) {
        if (!itemsAvailable) {
            try { wait(); } catch (InterruptedException e) {}
        }
        items -= numItems;
        itemsAvailable = false;
        System.out.println("Items consumed, remaining: " + items);
        notify();
    }
}

class Producer implements Runnable {
    Factory factory;
    
    Producer(Factory factory) {
        this.factory = factory;
    }
    
    public void run() {
        for (int i = 1; i <= 10; i++) {
            factory.produce(i);
            try { Thread.sleep(100); } catch (Exception e) {}
        }
    }
}

class Consumer implements Runnable {
    Factory factory;
    
    Consumer(Factory factory) {
        this.factory = factory;
    }
    
    public void run() {
        for (int i = 1; i <= 10; i++) {
            factory.consume(i);
            try { Thread.sleep(100); } catch (Exception e) {}
        }
    }
}

public class Main {
    public static void main(String[] args) {
        Factory factory = new Factory();
        new Thread(new Producer(factory)).start();
        new Thread(new Consumer(factory)).start();
    }
}
```

### Lab Demos
#### Step-by-step ITC Implementation
1. Create Factory class with private int items and boolean itemsAvailable
2. Implement synchronized produce(int numItems) method with wait/notify pattern
3. Implement synchronized consume(int numItems) method with opposite condition
4. Create Producer Runnable that calls factory.produce() in loop
5. Create Consumer Runnable that calls factory.consume() in loop  
6. Create Factory instance and start Producer and Consumer threads
7. Run and observe alternating produce/consume execution

**Expected Output**:
```
Items produced: 1
Items consumed, remaining: 0
Items produced: 2
Items consumed, remaining: 0
Items produced: 6
Items consumed, remaining: 0
...
```

> [!IMPORTANT]
> Always handle InterruptedException in ITC methods. The program template remains consistent: synchronized method → condition check → wait() → logic → notify().

## Summary

### Key Takeaways
```diff
+ Deadlock occurs when threads wait mutually for locked resources in circular dependency
+ Synchronized methods lock entire object, blocks other synchronized calls on same object  
+ Join method can create deadlock if threads wait mutually without time limit
+ Starvation occurs when threads wait for prolonged period but can eventually resume
+ Inter Thread Communication requires synchronized methods + wait() + notify() for alternating execution
- Using synchronized incorrectly creates performance bottlenecks and deadlocks
- Concurrent access to shared objects without synchronization leads to data corruption
```

### Expert Insight

#### Real-world Application
ITC is widely used in enterprise applications for task coordination. Web servers use producer-consumer patterns for handling HTTP requests where one thread produces requests in a queue and worker threads consume them sequentially. Database connection pools use similar patterns to manage concurrent access to limited resources safely.

#### Expert Path
Master synchronization by implementing thread-safe collections and understanding JMM (Java Memory Model). Study thread dumps in production using jstack to identify deadlock causes. Practice designing ITC solutions for distributed systems using messaging queues instead of in-memory waiting.

#### Common Pitfalls  
- Not checking conditions before calling wait() leads to missed signals 🚨  
- Calling notify() before wait() can cause lost signals  
- Ignoring InterruptedException breaks thread lifecycle management  
- Assuming thread order in notify() - always design for random wakeups/arunava

> [!TIP]
> Use local variables instead of class-level shared state whenever possible to avoid synchronization complexity. Practice with multiple producers/consumers to understand race conditions thoroughly.
