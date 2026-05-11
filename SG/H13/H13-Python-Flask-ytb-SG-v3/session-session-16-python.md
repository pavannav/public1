# Session 16: Multi-threading and Parallel Processing

## Table of Contents
- [Overview](#overview)
- [Key Concepts / Deep Dive](#key-concepts--deep-dive)
  - [Understanding Processes and PID](#understanding-processes-and-pid)
  - [Single-threaded Limitations](#single-threaded-limitations)
  - [Multi-threading Fundamentals](#multi-threading-fundamentals)
  - [Python Threading Implementation](#python-threading-implementation)
  - [Real-world Applications](#real-world-applications)
  - [Thread State Management](#thread-state-management)
- [Lab Demos](#lab-demos)
  - [Single-threaded vs Multi-threaded Comparison](#single-threaded-vs-multi-threaded-comparison)
  - [Practical Multi-threading Code](#practical-multi-threading-code)
  - [Process Verification via /proc](#process-verification-via-proc)
- [Summary](#summary)
  - [Key Takeaways](#key-takeaways)
  - [Quick Reference](#quick-reference)
  - [Expert Insight](#expert-insight)

## Overview

This session explores multi-threading in Python as a crucial advanced concept for parallel processing. Multi-threading enables programs to perform multiple operations simultaneously within a single process, overcoming the limitations of single-threaded execution where long-running tasks would block entire applications. The session covers OS-level concepts, process management, and practical Python implementations using the threading module.

Real-world scenarios like web browsers (Firefox) running multiple tabs, chat applications handling simultaneous send/receive operations, and media players processing audio/video concurrently demonstrate why multi-threading is essential for modern software development.

## Key Concepts / Deep Dive

### Understanding Processes and PID

Every Python program execution creates a process loaded into RAM with a unique Process ID (PID) assigned by the operating system kernel. The PID serves double duty - as a number in system tables for OS tracking, but crucially as a folder/directory in the RAM that contains all program data.

```bash
# View running processes
ps aux

# Example output shows firefox process with PID 3560
firefox    3560  1.2 12.8 1456789 456789 ?  Sl   14:30   0:45 /usr/bin/firefox

# Access process details via /proc
ls /proc/3560/
```

The `/proc` filesystem provides a window into running processes. When you `cd /proc/[PID]`, you're literally entering that process's memory space to inspect its contents. Terminating a process (`kill` or `CTRL+C`) removes this folder from RAM.

### Single-threaded Limitations

By default, Python programs (and most languages) are single-threaded - the process can only execute one instruction at a time to the CPU. This creates critical bottlenecks:

```python
def infinite_function(name):
    while True:
        print(f"{name} running...")

# Single-threaded execution
infinite_function("Task A")  # This blocks forever
infinite_function("Task B")  # Never reached
```

The limitation exists because of sequential execution design:
1. Process sends first instruction to CPU
2. CPU executes instruction (may take seconds/minutes)
3. CPU completes and signals process
4. Process sends next instruction

If any instruction consumes excessive time (infinite loops, long computations, I/O waits), subsequent code starves and cannot execute.

> [!WARNING]
> Single-threaded bottlenecks cause entire programs to hang or become unresponsive when any component stalls.

### Multi-threading Fundamentals

Multi-threading allows a process to send multiple instructions simultaneously to the CPU. The CPU processes these "threads" concurrently, enabling true parallel execution:

```diff
# Conceptual difference
- Sequential: A → CPU → B → CPU → C → CPU
+ Parallel: A → CPU, B → CPU, C → CPU (simultaneously)
```

**Key Thread Concepts:**
- **Main Thread**: Always exists, created automatically
- **Child Threads**: Created programmatically for specific functions
- **Thread Pool**: Multiple threads managed together

### Python Threading Implementation

Python's `threading` module provides simple multi-threading:

```python
import threading

# Create threads for specific functions
thread_a = threading.Thread(target=infinite_function, args=("Task A",))
thread_b = threading.Thread(target=infinite_function, args=("Task B",))

# Start parallel execution
thread_a.start()
thread_b.start()
```

> [!NOTE]
> Threading is a core OS concept, not Python-specific. The same principles apply across languages and operating systems.

### Real-world Applications

**Web Browsers (Firefox Example):**
- Tab 1: Loading Google
- Tab 2: Streaming YouTube video
- Background: Downloading files, updating extensions
- Interface: Maintaining responsive UI

Firefox processes typically run 50+ threads simultaneously, enabling complex multitasking in a single application.

**Chat Applications:**
```python
def send_messages():
    while True:
        send_message_to_server()

def receive_messages():
    while True:
        handle_incoming_message()

# Both functions run in parallel
send_thread = threading.Thread(target=send_messages)
receive_thread = threading.Thread(target=receive_messages)
send_thread.start()
receive_thread.start()
```

Without multi-threading, sending a message would block receiving new ones.

**Media Players (VLC Example):**
- Audio decoding thread
- Video rendering thread
- Playlist management thread
- UI responsiveness thread

### Thread State Management

**Thread Lifecycle:**
1. **Created**: Thread object instantiated
2. **Started**: `thread.start()` sends function to CPU
3. **Running**: CPU executes thread instructions
4. **Completed**: Thread finishes execution

**Process-Thread Relationship:**
- Parent: Process (PID: 12345)
  - Child: Main Thread (always 1)
  - Child: Thread A (function a())
  - Child: Thread B (function b())

**Verification:** Check thread count via `/proc/[PID]/status`:
```
Threads: 3
```

## Lab Demos

### Single-threaded vs Multi-threaded Comparison

**Single-threaded Problem (Homework Scenario):**

```python
def task_a():
    while True:
        print("Task A working...")

def task_b():
    while True:
        print("Task B working...")

# This never reaches task_b()
task_a()
task_b()  # Never executed
```

**Output:** Infinite "Task A working..." - program hangs

**Multi-threaded Solution:**

```python
import threading

def task_a():
    while True:
        print("Task A working...")

def task_b():
    while True:
        print("Task B working...")

# Create threads
thread_a = threading.Thread(target=task_a)
thread_b = threading.Thread(target=task_b)

# Start parallel execution
thread_a.start()
thread_b.start()
```

**Output:** Interleaved execution
```
Task A working...
Task B working...
Task A working...
Task B working...
```

> [!IMPORTANT]
> Multi-threading enables true parallelism - both functions execute simultaneously rather than sequentially.

### Practical Multi-threading Code

Complete implementation demonstrating yesterday's homework solution:

```python
import threading

def function_a():
    while True:
        print("AAAAAAAAAAAAAAAAAAAAAAAAAA")

def function_b():
    while True:
        print("BBBBBBBBBBBBBBBBBBBBBBBBBB")

# Create thread objects (but don't start yet)
x1 = threading.Thread(target=function_a)
x2 = threading.Thread(target=function_b)

# Start both threads simultaneously
x1.start()
x2.start()
```

**Execution Flow:**
1. Program loads as process
2. `threading.Thread` creates Thread objects
3. `start()` method sends functions to CPU as separate threads
4. CPU processes both loops in parallel
5. Output shows alternating execution

### Process Verification via /proc

**Find Process PID:**
```bash
ps aux | grep python
# Example output:
# user  4620  0.1  0.2  45678 12345 ?  S    10:30   0:02 python3 multithread_demo.py
```

**Inspect Process Structure:**
```bash
# Enter process memory space
cd /proc/4620

# View thread count
cat status | grep Threads
# Threads: 3
```

**Files Created in /proc/[PID]:**
- `status`: Process information including thread count
- `cmdline`: Command line arguments
- `maps`: Memory mappings
- `fd`: Open file descriptors

**Firefox Comparison:**
Firefox processes typically show 50+ threads:
```bash
cd /proc/[firefox_pid]
cat status | grep Threads
# Threads: 55
```

## Summary

### Key Takeaways

```diff
+ Multi-threading enables parallel execution within a single process
+ CPU can process multiple instructions simultaneously
+ Overcomes single-threaded bottlenecks and hanging programs
+ Essential for modern applications: browsers, chat apps, media players
+ Python threading module provides simple implementation
+ Process ID serves double duty: system identifier and RAM folder
+ /proc filesystem provides direct access to process internals
+ Thread count verification through /proc/[PID]/status
+ Functions run "simultaneously" through rapid context switching
+ Both CPU power and program design enable parallelism
```

### Quick Reference

**Basic Multi-threading:**
```python
import threading

# Create threads
thread1 = threading.Thread(target=function_name, args=(param1, param2))
thread2 = threading.Thread(target=another_function)

# Start parallel execution
thread1.start()
thread2.start()
```

**Process Inspection:**
```bash
# Find process PID
ps aux | grep python

# Enter process memory
cd /proc/[PID]

# Check thread count
cat status | grep Threads
```

**Thread Methods:**
- `thread.start()`: Begin execution
- `thread.join()`: Wait for completion
- `threading.active_count()`: Current thread count

### Expert Insight

#### Real-world Application
Multi-threading powers modern software ecosystems. Streaming services like Netflix use threading for video decoding, audio processing, and UI updates simultaneously. Financial trading platforms rely on threads to process market data, execute trades, and update dashboards in real-time. Without threading, these applications would be impossible to build.

#### Expert Path
Master threading by implementing producer-consumer patterns, understanding GIL limitations in Python, and exploring concurrent.futures for high-level parallelism. Study thread synchronization primitives (locks, semaphores, condition variables) to prevent race conditions. Progress to asyncio for event-driven concurrency and multiprocessing for CPU-bound tasks.

#### Common Pitfalls
- **Race Conditions**: Threads accessing shared data simultaneously, causing corruption
- **Deadlocks**: Threads waiting for each other indefinitely
- **GIL Limitations**: Python GIL prevents true multi-core utilization for CPU-bound tasks
- **Resource Contention**: Too many threads causing overhead greater than benefits

#### Lesser-Known Facts
- Threading is lightweight compared to processes (threads share memory, processes are isolated)
- Context switching between threads is measured in microseconds
- Linux's Completely Fair Scheduler (CFS) distributes CPU time fairly across threads
- Thread priority can be adjusted using `nice` values in Linux schedulers

---

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
