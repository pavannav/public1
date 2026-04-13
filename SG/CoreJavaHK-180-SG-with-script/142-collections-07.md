# Session 142: Collections 07

<strong><em>Overview:</em></strong> This session delves into the internal workings of the Vector class in Java Collections, focusing on memory diagrams, method implementations, and the growable array algorithm. We'll explore how Vector manages capacity, size, and element storage with synchronization, providing a deep understanding of thread-safe collections.

## Table of Contents

- [Introduction to Vector Operations](#introduction-to-vector-operations)
- [Memory Diagram: Vector Object Creation](#memory-diagram-vector-object-creation)
- [Instance Variables in Vector](#instance-variables-in-vector)
- [Default Capacity and Initialization](#default-capacity-and-initialization)
- [Constructor Chaining](#constructor-chaining)
- [Object Array Initialization](#object-array-initialization)
- [Synchronization in Vector Methods](#synchronization-in-vector-methods)
- [Capacity vs Size Concepts](#capacity-vs-size-concepts)
- [Add Method Implementation](#add-method-implementation)
- [Growable Array Algorithm](#growable-array-algorithm)
- [Memory Diagram: Adding Elements](#memory-diagram-adding-elements)
- [Summary](#summary)

## Introduction to Vector Operations

<strong><em>Key Concepts:</em></strong> Vector class implements the growable array algorithm, serving as a legacy thread-safe collection that dynamically resizes its internal array when capacity limits are reached.

**Removing Duplicate Occurrences:**  
To remove all instances of a specific element (e.g., the value `true`) from a collection:
- Using `remove(Object)` only removes the first occurrence.
- To remove all occurrences, use the `removeAll(Collection<?>)` method by creating a collection containing only the element to remove.

```java
Vector v1 = new Vector(); // Populate v1 with elements including duplicates of true

// Incorrect: Only removes first occurrence
v1.remove(true); // Removes only one true

// Correct: Removes all occurrences of true
Collection c = new Vector();
c.add(true);
v1.removeAll(c); // Removes all true values
```

<strong><em>Deep Dive:</em></strong> The `removeAll(Collection<?>)` method calculates the difference between the main collection and the passed collection, eliminating all matching elements. For duplicate removal, this approach ensures atomic removal without manual iteration.

| Method | Behavior | Example |
|--------|----------|---------|
| `remove(Object o)` | Removes first occurrence | `v1.remove("item")` → removes only first "item" |
| `removeAll(Collection c)` | Removes all matching elements | `v1.removeAll(singleton("item"))` → removes all "item" |

## Memory Diagram: Vector Object Creation

<strong><em>Key Concepts:</em></strong> When a `new Vector()` instance is created, the JVM allocates memory in two primary areas: the heap (for object data) and the stack (for references). The Vector object maintains an internal state with capacity markers and element storage.

<strong><em>Overview:</em></strong> Vector uses an object array as its underlying data structure. Key operations include allocating instance variables, initializing arrays, and handling dynamic growth.

<strong><em>Deep Dive:</em></strong> Upon creation, the JVM performs heap allocation for the Vector instance, creating space for its fields. The constructor initializes a default-sized object array for element storage.

```mermaid
graph TD
    A[JVM Stack] --> B[Vector reference: v1]
    B --> C[Heap: Vector Instance]
    C --> D[Instance Variables]
    D --> E[elementData: Object[] array (10 locations)]
    D --> F[elementCount: int (0)]
    D --> G[capacityIncrement: int (0)]
    C --> H[Object Array: elementData[10] - all initialized to null]
```

<strong><em>Tables:</em></strong>  
| Component | Description | Initial Value |
|-----------|-------------|--------------|
| Heap Object | Vector instance | Allocated memory |
| Stack Reference | Points to Vector object | Address of heap object |
| Instance Variables | Internal state holders | See below |
| elementData | Object array for elements | null array of size 10 |
| elementCount | Current size counter | 0 |
| capacityIncrement | Growth increment | 0 |

> [!NOTE]
> The default capacity (10) represents the initial number of slots in the internal array, all set to `null` initially.

## Instance Variables in Vector

<strong><em>Key Concepts:</em></strong> Vector's internal state is maintained through three primary instance variables, each serving specific roles in capacity management and element storage.

**Core Variables:**  
- `elementData`: Object array serving as backing storage
- `elementCount`: Tracks current number of stored elements (size)
- `capacityIncrement`: Determines growth increments (default 0 means doubling)

```java
// Simplified representation of Vector's internal variables
private Object[] elementData;    // Backing array
private int elementCount;        // Current size (0 initially)  
private int capacityIncrement;   // Growth increment (0 initially)
```

<strong><em>Deep Dive:</em></strong> These variables form the foundation of Vector's dynamic behavior. The `elementData` array expands as needed, while `elementCount` ensures proper indexing and bounds checking.

## Default Capacity and Initialization

<strong><em>Key Concepts:</em></strong> Vector's default capacity is fixed at 10 locations, established during no-argument constructor execution. This represents the minimum allocation before growth occurs.

**Capacity Logic:**  
```java
public int capacity() {
    return elementData.length;  // Returns array length: 10 initially
}
```

<strong><em>Deep Dive:</em></strong> Default capacity ensures predictable initial behavior. The actual backing array length directly influences performance characteristics for small-to-medium sized collections.

## Constructor Chaining

<strong><em>Key Concepts:</em></strong> Vector constructors demonstrate constructor chaining, where parameterless constructors delegate to parameterized ones, ensuring consistent initialization across different instantiation methods.

**Constructor Flow:**  
```java
public Vector() {
    this(10);  // Chain to parameterized constructor
}

private Vector(int initialCapacity) {
    this(initialCapacity, 0);  // Chain further
}

private Vector(int initialCapacity, int capacityIncrement) {
    super();  // Call AbstractList constructor
    // Initialize variables and array
}
```

<strong><em>Deep Dive:</em></strong> Constructor chaining prevents code duplication and ensures all Vector instances follow the same initialization protocol, regardless of how they're created.

## Object Array Initialization

<strong><em>Key Concepts:</em></strong> The constructor explicitly creates the backing `Object[]` array using `new Object[initialCapacity]`, providing the growable storage mechanism.

**Initialization Code:**  
```java
// Inside constructor:
elementData = new Object[10];  // Allocate array of 10 null references
elementCount = 0;             // Start with size 0
```

<strong><em>Deep Dive:</em></strong> Each array slot contains a `null` reference initially, representing uninitialized positions. Elements are stored by replacing these null values with object references.

## Synchronization in Vector Methods

<strong><em>Key Concepts:</em></strong> All Vector methods are declared `synchronized`, ensuring thread-safety by allowing only one thread to execute any method on a Vector instance at a time.

**Synchronization Behavior:**  
```java
// All public methods are synchronized
public synchronized boolean add(E e) { ... }
public synchronized int size() { ... }
public synchronized int capacity() { ... }
```

<strong><em>Deep Dive:</em></strong> When a method like `capacity()` is called, the Vector object becomes locked until the method completes. This prevents concurrent modifications but introduces performance overhead compared to unsynchronized collections like ArrayList.

## Capacity vs Size Concepts

<strong><em>Key Concepts:</em></strong> Capacity represents the total available storage slots, while size indicates the number of currently occupied positions. These concepts are fundamental to understanding collection efficiency.

**Method Implementations:**  
```java
public synchronized int capacity() {
    return elementData.length;  // Total allocated slots
}

public synchronized int size() {
    return elementCount;  // Elements currently stored
}
```

<strong><em>Deep Dive:</em></strong> As elements are added, size increases until it reaches capacity, triggering growth. Capacity always equals or exceeds size, with the difference representing unused slots.

| Concept | Definition | Method | Example |
|---------|-----------|--------|---------|
| Capacity | Total allocated slots | `capacity()` | 10 (initial) |
| Size | Elements stored | `size()` | 7 (after 7 adds) |

## Add Method Implementation

<strong><em>Key Concepts:</em></strong> The `add(E)` method performs capacity checking before storing elements, growing the array if necessary. It returns `true` to indicate successful addition.

**Algorithm Overview:**  
```java
public synchronized boolean add(E e) {
    if (size() >= capacity()) {  // Check if growth needed
        grow();                  // Double capacity
    }
    elementData[elementCount++] = e;  // Store and increment
    return true;               // Always succeeds for List
}
```

<strong><em>Deep Dive:</em></strong> The method first verifies available capacity. If full, it triggers growth before storing the new element at the next available index (tracked by `elementCount`).

## Growable Array Algorithm

<strong><em>Key Concepts:</em></strong> When capacity is exceeded, Vector creates a new array (typically double-sized) and copies all existing elements, then discards the old array for garbage collection.

**Growth Implementation:**  
```java
private void grow() {
    // Step 1: Create new array with double capacity
    Object[] nextArray = new Object[elementData.length * 2];
    
    // Step 2: Copy all existing elements
    for (int i = 0; i < elementData.length; i++) {
        nextArray[i] = elementData[i];
    }
    
    // Step 3: Replace reference, making old array GC-eligible
    elementData = nextArray;
}
```

<strong><em>Deep Dive:</em></strong> This three-step process ensures continuous expansion without data loss. The algorithm doubles capacity by default, though capacity increment can modify this behavior.

> [!NOTE]
> Growth occurs when `size() == capacity()`, preventing IndexOutOfBoundsException and maintaining amortized O(1) insertion time.

## Memory Diagram: Adding Elements

<strong><em>Key Concepts:</em></strong> Each `add()` operation stores object references in the backing array. String and wrapper objects often come from object pools, potentially sharing references across elements.

**Element Storage Flow:**  

```mermaid
graph LR
    A["v1.add(\"a\")"] --> B[String object "a" created in heap<br/>Reference: 111]
    B --> C[elementData[0] = 111<br/>elementCount = 1]
    A2["v1.add(\"b\")"] --> D[String object "b" created<br/>Reference: 222]  
    D --> E[elementData[1] = 222<br/>elementCount = 2]
    A3["v1.add(\"a\")"] --> F[Reuse existing reference 111<br/>from string pool]
    F --> G[elementData[2] = 111<br/>Same object, different position]
```

<strong><em>Deep Dive:</em></strong> The diagram shows how object pooling affects memory usage. Identical strings share references, reducing heap consumption, while primitives undergo autoboxing for storage.

**Example with Pooling:**  
```java
Vector<Object> v1 = new Vector<>();
v1.add("a");    // String pool reference 111
v1.add("b");    // String pool reference 222  
v1.add("a");    // Reuses reference 111
v1.add(5);      // Integer pool reference 333 (autoboxed)
v1.add(5);      // Reuses reference 333
v1.add(6.7);    // New Double object 777 (no pooling)
```

**Notes on Pooling:**  
- String literals and common wrapper objects (-128 to 127) share references from pools
- `double` and `float` values create new objects each time
- Pooling reduces memory usage for repeated values

## Summary

### Key Takeaways
```diff
! Vector is a thread-safe, growable array implementation for List collection type
+ Capacity: Total allocated slots in backing Object[] array (default: 10)
- Size: Current number of stored elements (tracked by elementCount)
+ Growth: Occurs when size reaches capacity, typically doubling array size
+ Thread-safety: All methods synchronized for concurrent access protection
+ Memory: Elements stored as references; pooling reduces heap usage
- Performance: Synchronization overhead compared to ArrayList/Legacy collections
```

### Expert Insight

**Real-world Application:** Vector remains relevant for multi-threaded environments requiring simple list operations where synchronization overhead is acceptable. Use cases include legacy codebases, educational examples, and scenarios demanding thread-safety over raw performance.

**Expert Path:** Master collection internals by implementing custom growable arrays. Study synchronization patterns and consider Vector's role in the Collections framework evolution toward ArrayList and CopyOnWriteArrayList.

**Common Pitfalls:**  
- Assuming capacity equals size - track both independently  
- Performance issues in tight loops - Vector synchronizes every operation  
- Misunderstanding growth - array copying is O(n) operation  
- Memory inefficiencies with primitives - avoid wrapper objects when possible  
- Thread contention - profile before choosing Vector over ArrayList  

**Lesser Known Things:** Vector's capacity increment parameter (rarely used) determines fixed growth amounts instead of doubling; default 0 means doubling. Historical artifact from JDK 1.0 with implications for predictable memory allocation in embedded systems.
