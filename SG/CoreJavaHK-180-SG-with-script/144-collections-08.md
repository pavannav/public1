# Session 144: Collections - Vector Constructors and ArrayList

## Table of Contents
- [Vector Constructors](#vector-constructors)
- [Capacity and Size in Vector](#capacity-and-size-in-vector)
- [Rules for Using Vector Objects](#rules-for-using-vector-objects)
- [Introduction to ArrayList](#introduction-to-arraylist)
- [Differences Between Vector and ArrayList](#differences-between-vector-and-arraylist)
- [When to Use Vector vs. ArrayList](#when-to-use-vector-vs-arraylist)
- [ArrayList Constructors and Special Methods](#arraylist-constructors-and-special-methods)
- [Summary](#summary)

## Vector Constructors

### Overview
Vector is a legacy class in Java that stores elements in an index-based order. It provides four constructors for creating Vector objects: 

1. **No-parameter constructor**: Creates a Vector with default capacity of 10.
2. **Collection parameter constructor**: Copies elements from an existing collection.
3. **Initial capacity constructor**: Allows specifying the initial capacity.
4. **Initial capacity + incremental capacity constructor**: Specifies both initial capacity and how much to increment when capacity is exceeded.

### Key Concepts
Vector constructors enable flexible object creation for different scenarios. The no-parameter constructor uses a default capacity, while others allow customization of capacity management.

#### Constructor 1: No-Parameter Constructor
```java
Vector v = new Vector();
```
- Creates a Vector with default initial capacity of 10 and default incremental capacity of double the current size.

#### Constructor 2: Collection Parameter Constructor
```java
Vector v2 = new Vector(v1);
```
- Copies all elements from the specified collection (e.g., v1) to the new Vector (v2).
- Creates a separate collection; modifications to v1 do not affect v2.
- Prints elements of v1 and v2 to demonstrate they are independent.

```diff
+ Ensures a separate Vector object with copied elements.
- Passing null to this constructor results in NullPointerException.
+ Useful for creating backups or copies of existing collections.
```

#### Constructor 3: Initial Capacity Constructor
```java
Vector v3 = new Vector(5);
```
- Specifies initial capacity as 5.
- Size starts at 0, no elements added.
- Capacity remains 5 until more than 5 elements are added, then increases by double.

#### Constructor 4: Initial Capacity + Incremental Capacity Constructor
```java
Vector v4 = new Vector(3, 2);
```
- Initial capacity is 3; each capacity increase is by 2 (not double).
- After adding 3 elements, capacity becomes 5 (3 + 2).
- Specifying incremental capacity other than 2 requires this constructor.

### Capacity Rules in Vector
- **Default Capacity**: 10.
- **Incremental Capacity**: Doubles when exceeded, unless specified otherwise.
- **Special Cases**:
  - If initial capacity is 0 or 1, next capacity increases by 1.
  - For initial capacity >= 2, it doubles (e.g., 2 -> 4).
- **Zero Initial Capacity**: Capacity remains 0; adding first element increases it to at least 1.

### Lab Demos
1. Create Vector v1, add elements, then create v2 using Constructor 2. Add elements to one and verify independence.
2. Create v3 with initial capacity 5, add 6 elements, check capacity doubles to 10.
3. Create v4 with initial capacity 3 and increment 2, add elements, verify capacity increases by 2.
4. Create v5 with capacity 0, add element, capacity becomes 1.

> [!NOTE]
> Capacity represents allocated space; size is actual elements stored.

## Rules for Using Vector Objects

### Overview
Vector objects have strict rules to avoid runtime exceptions and ensure thread safety.

- **Null Collection Constructor**: Passing null throws NullPointerException.
- **Negative Initial Capacity**: Passing negative values (e.g., -5) throws IllegalArgumentException.
  - This is thrown by Vector class (line ~44), not JVM, to hide internal array implementation.
  - JVM would otherwise throw NegativeArraySizeException, but Java designs APIs to mask low-level details.
- **Incremental Capacity Negative/Zero**: If negative or zero, capacity increases by default (double); invalid value ignored.
- Performs implicit copy operations but does not expose internal array usage.

> [!IMPORTANT]
> Designing APIs to throw custom exceptions prevents revealing implementation details, a best practice in professional Java development.

```diff
+ Use positive capacities only to avoid IllegalArgumentException.
- Avoid passing null collections to prevent NullPointerException.
! Incremental capacity <=0 defaults to doubling; explicitly override for custom increments.
```

### Common Pitfalls
- Expecting Vector capacity to increase by 1 when initial is >1; it doubles instead.
- Passing negative increments without realizing it defaults to double.
- Assuming null collections are handled gracefully (they are not).

Emojis: ✅ Verified rules prevent exceptions. ❌ Pitfalls lead to errors.

## Introduction to ArrayList

### Overview
ArrayList is a collections framework class (Java 1.2+) implementing List, RandomAccess, Cloneable, Serializable. It stores elements sequentially without synchronization, making it faster for single-threaded applications.

```diff
+ Recommended for single-threaded or method-local operations.
- Not thread-safe; data inconsistency possible in multi-threaded environments.
+ Faster than Vector due to lack of synchronization overhead.
```

### Key Concepts
ArrayList maintains insertion order, allows duplicates/nulls, and uses a resizable array internally. Default capacity is 10, but increments by half (not double like Vector).

- Allows all four element types: homogeneous, heterogeneous, unique, duplicate.
- Supports random and sequential retrieval.
- Search/remove operations call equals() from object class or overridden methods.
- No capacity() method (unlike Vector); use special methods for capacity management.

### Differences Between Vector and ArrayList
| Feature                  | Vector                          | ArrayList                      |
|--------------------------|---------------------------------|--------------------------------|
| Synchronization          | Synchronized (thread-safe)     | Non-synchronized              |
| Availability             | Java 1.0 (legacy)               | Java 1.2 (collections framework) |
| Performance              | Slower in single-threaded apps  | Faster in single-threaded apps |
| Default Capacity         | 10                              | 10                             |
| Incremental Capacity     | Double                          | Half ( +1 for small capacities) |
| Thread Safety            | Yes                             | No                             |
| Use Case                 | Multi-threaded environments     | Single-threaded or method-local|

> [!NOTE]
> ArrayList's performance advantage comes from eliminating synchronization's locking/unlocking overhead.

### When to Use Vector vs. ArrayList
- **Use Vector**:
  - Multi-threaded applications where thread safety is critical.
  - Class-level objects accessed by multiple threads.
- **Use ArrayList**:
  - Single-threaded applications or method-local collections.
  - No shared access across threads.
  - Adding/removing elements frequently without synchronization needs.

```diff
+ Choose based on threading: Vector for multi-threaded, ArrayList for single-threaded.
- Incorrect choice leads to performance issues (Vector) or data corruption (ArrayList).
! Single-threaded apps: Prioritize ArrayList's speed.
```

### ArrayList Constructors and Special Methods

### Overview
ArrayList has three constructors (no increment control like Vector). Special methods manage capacity beyond inherited ones.

#### Constructors
1. **No-parameter**: Default capacity 10.
2. **Collection parameter**: Copies from existing collection.
3. **Initial capacity**: Custom initial capacity.

```java
ArrayList al = new ArrayList(); // Default 10
ArrayList al2 = new ArrayList(al); // Copy elements
ArrayList al3 = new ArrayList(5); // Initial capacity 5
```

### Special Methods
- **ensureCapacity(int minCapacity)**: Increases capacity if needed, avoiding reallocation during additions.
  - Use to pre-allocate, reducing resizing overhead.
- **trimToSize()**: Discards unused capacity, freeing memory for other objects.
- No **setSize()** method; inherited from List interfaces.

```diff
+ ensureCapacity() improves performance by pre-allocating space.
- trimToSize() reduces memory usage but causes reallocation.
! ArrayList has 48 methods (46 inherited + 2 special: ensureCapacity, trimToSize).
```

### Lab Demos
1. Create ArrayList objects using all constructors.
2. Add elements, check size (but no capacity method).
3. Use ensureCapacity(20), add elements without resizing.
4. After additions, call trimToSize() to optimize memory.

> [!IMPORTANT]
> Practice calling all 48 methods in ArrayList; experiment with CRUD operations (Create/Read/Update/Delete) on custom classes (override equals() for search/remove).

## Summary

### Key Takeaways
```diff
+ Vector has 4 constructors; ArrayList has 3, with no increment control.
+ Vector is synchronized (legacy), ArrayList is not (framework class).
+ Choose based on threads: Vector for multi-threaded, ArrayList for single-threaded/method-local.
+ Capacity rules: Vector doubles (+1 for 0-1), ArrayList halves (+1 for small).
+ Special ArrayList methods: ensureCapacity() for pre-allocation, trimToSize() for memory optimization.
- Avoid null collections (NullPointerException) or negative capacities (IllegalArgumentException).
! Correct API exceptions hide internal details, a professional design pattern.
```

### Expert Insight
#### Real-world Application
- In production apps, use ArrayList for fast, thread-unsafe collections (e.g., local data processing). Use Vector or synchronized wrappers (Collections.synchronizedList()) for thread-safe scenarios. For large datasets, estimate size and use ensureCapacity() to avoid reallocation pauses.

#### Expert Path
- Dive into Vector/ArrayList source code for capacity growth logic. Practice with JProfiler to measure synchronization overhead. Learn Reflection API quirks in ArrayList internals. Master thread-safe alternatives like CopyOnWriteArrayList for advanced concurrency.

#### Common Pitfalls
- "AR list" misspellings lead to compile errors (correct to ArrayList). Data corruption in unsynchronized ArrayList across threads. Overlooking capacity growth causing performance hits.
- Issues with resolution: Override equals() for custom types; use synchronized wrappers for thread-safety.
- Lesser known: ArrayList uses Object[] internally (no primitives); Vector's synchronization adds ~10-20% overhead verified in benchmarks.

### Corrections Notified
- "ript" corrected to "script" if applicable (transcript start, likely "script"). No major technical misspellings like "htp"→"http" or "cubectl"→"kubectl" present, but grammar fixes (e.g., "element elements" → "elements") applied for clarity. "ARR list" → "ArrayList", "itelist" → "list", "dist rator" → "ListIterator", "relase" → "release". No other errors.
