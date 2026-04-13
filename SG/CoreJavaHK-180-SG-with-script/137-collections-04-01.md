# Session 4: Collections - Vector Class and Collection Interface Methods

## Table of Contents
- [What is Vector Class?](#what-is-vector-class)
- [Collection Interface Overview](#collection-interface-overview)
- [Key Methods in Collection Interface](#key-methods-in-collection-interface)
  - [Add Methods](#add-methods)
  - [Search and Retrieval Methods](#search-and-retrieval-methods)
  - [Remove Methods](#remove-methods)
- [Generics in Collections](#generics-in-collections)
- [Lab Demos](#lab-demos)

## What is Vector Class?

### Overview
💡 **Vector** is a legacy collection class in Java introduced to provide a dynamic array-like data structure that can grow or shrink in size automatically. It is thread-safe, meaning it is synchronized for multi-threaded access, making it suitable for scenarios where multiple threads share the collection. However, its synchronization overhead can impact performance in single-threaded environments compared to ArrayList.

### Key Concepts/Deep Dive
Vector implements the **List** interface and extends AbstractList, providing ordered storage of elements. Key points to verify about Vector include:

- **Thread Safety**: Vector is synchronized, preventing data inconsistencies in multi-threaded scenarios.
- **Ordering**: Stores elements in order (using 0-based indexing).
- **Data Structure**: Implements a growable array (resizable array).
- **Default Capacity**: Starts with a default capacity of 10 elements.
- **Incremental Capacity**: Grows by doubling the current size when full (e.g., from 10 to 20).
- **Element Types**: Allows heterogeneous elements if no generics are specified; homogeneous with generics.
- **Duplicates and Nulls**: Allows duplicates and null values.
- **Insertion Order**: Maintains insertion order for storage and retrieval.
- **Retrieval Order**: Elements can be accessed randomly (like arrays).

Vector is part of the Collection framework since Java 1.0 but is considered legacy. Use alternatives like ArrayList for better performance unless thread safety is required.

### Key Concepts Summary
- **When to use Vector**: In multi-threaded environments needing synchronization; alternatives preferred otherwise.
- **Comparison**: Unlike arrays, Vector grows dynamically; unlike non-thread-safe lists, it handles concurrency.

## Collection Interface Overview

### Overview
📝 **Collection** is the root interface in the Java Collection framework, defining common methods for storing, retrieving, and manipulating groups of objects. It acts as a contract for all collection classes, ensuring runtime polymorphism for operations across different implementations like Vector, ArrayList, and LinkedList.

### Key Concepts/Deep Dive
The Collection interface ensures uniformity across implementations. Key characteristics:
- **Version Availability**: Available from Java 1.2 onward.
- **Purpose**: Stores objects in array-like format without mappings (e.g., key-value pairs).
- **Sub-interfaces**: Extends to Set (unique elements), List (ordered with duplicates), and Queue (FIFO/LIFO).
- **Data Structure**: Not directly implemented; relies on sub-interfaces.
- **Synchronization**: Interface itself does not enforce synchronization; depends on implementations.
- **Ordering**: Some collections are ordered (e.g., indexed), others unordered; does not specify data structure.
- **Generics Support**: Allows type-safe collections since Java 5.0.

Collection provides a foundation for polymorphism, enabling code that works with different collection types without changes.

### Key Concepts Summary
- **Root Role**: Defines standard methods for all collections, enabling consistent operations.
- **Subtypes**: Divided into Set, List, and Queue based on storage rules (unique, ordered, or sequential).

## Key Methods in Collection Interface

### Overview
⚠️ Collection interface defines core methods for common operations: adding, searching, retrieving, and removing elements. These methods promote code reusability across collection types.

### Add Methods
#### Overview
Adding elements to a collection using `add()` and `addAll()` methods.

#### Key Concepts/Deep Dive
- **add(E element)**: Returns boolean indicating if the element was added (e.g., fails in Sets if duplicate).
- **addAll(Collection<? extends E> c)**: Adds all elements from another collection; ensures type safety with generics.
- Supports both single and bulk additions.

```java
import java.util.Vector;

// Example with Vector
Vector<Integer> v1 = new Vector<>();
v1.add(5); // Adds 5
v1.add(7); // Adds 7

Vector<Integer> v2 = new Vector<>();
v2.addAll(v1); // Copies all from v1 to v2
```

#### Tables
| Method | Purpose | Return Type | Usage |
|--------|---------|-------------|-------|
| `add(E element)` | Adds a single element | boolean | e.g., `collection.add(item)` |
| `addAll(Collection<? extends E> c)` | Adds multiple elements from another collection | boolean | e.g., `collection.addAll(anotherCollection)` |

### Search and Retrieval Methods
#### Overview
Searching and retrieving elements using `contains()`, `containsAll()`, and `iterator()`.

#### Key Concepts/Deep Dive
- **contains(Object o)**: Checks if an element exists in the collection.
- **containsAll(Collection<?> c)**: Verifies if all elements of a given collection are present.
- **iterator()**: Returns an Iterator for sequential retrieval.
- Iterator provides methods like `hasNext()` and `next()` for traversal.

```java
import java.util.Vector;

Vector<Integer> v1 = new Vector<>();
v1.add(5);
v1.add(7);

// Search
boolean hasFive = v1.contains(5); // true
boolean hasNine = v1.contains(9); // false

Vector<Integer> v2 = new Vector<>();
v2.add(5);
v2.add(7);
boolean containsAll = v2.containsAll(v1); // true if v2 has all from v1
```

#### Tables
| Method | Purpose | Return Type | Usage |
|--------|---------|-------------|-------|
| `contains(Object o)` | Searches for a single element | boolean | e.g., `collection.contains(item)` |
| `containsAll(Collection<?> c)` | Searches for multiple elements | boolean | e.g., `collection.containsAll(list)` |
| `iterator()` | Provides sequential access | Iterator<E> | Used for looping: `while(it.hasNext()) { item = it.next(); }` |

### Remove Methods
#### Overview
Removing elements using `remove()` and `removeAll()`.

#### Key Concepts/Deep Dive
- **remove(Object o)**: Removes the first occurrence of the element.
- **removeAll(Collection<?> c)**: Removes all matching elements from the given collection, including duplicates.
- Returns boolean indicating success.

```java
import java.util.Vector;

Vector<Integer> v1 = new Vector<>();
v1.add(5);
v1.add(7);
v1.add(5);

boolean removed = v1.remove(Integer.valueOf(5)); // Removes first 5

Vector<Integer> v2 = new Vector<>();
v2.add(5);
v1.removeAll(v2); // Removes all 5s from v1
```

#### Tables
| Method | Purpose | Return Type | Usage |
|--------|---------|-------------|-------|
| `remove(Object o)` | Removes one occurrence | boolean | e.g., `collection.remove(item)` |
| `removeAll(Collection<?> c)` | Removes all matching elements | boolean | e.g., `collection.removeAll(list)` |

## Generics in Collections

### Overview
🔧 Generics, introduced in Java 5.0, enable type-safe collections, reducing casting and runtime errors.

### Key Concepts/Deep Dive
- **Syntax**: `<E>` where E is the element type.
- **Benefits**: Prevents heterogeneous storage, enforces compile-time type checking.
- **Wildcards**: `?` for any type, `? extends E` for subtypes.
- **Default**: Without generics, defaults to Object (raw types).

```java
Vector<Integer> vInt = new Vector<>(); // Only Integers
vInt.add(5); // OK
// vInt.add("hello"); // Compile error

Vector<String> vStr = new Vector<>();
// Error if adding Integer to vStr
```

## Lab Demos

### Lab 1: Testing Vector Basics and Collection Methods
1. Create a package `com.nit.hk.collections`.
2. Create class `VectorTest01.java`.
3. Declare Vector as: `Vector<Integer> v1 = new Vector<>();`.
4. Add elements: `v1.add(5); v1.add(7); v1.add(9);`.
5. Print size using Frequency Check: `System.out.println(v1);`.
6. Test addAll: Create `Vector<Integer> v2 = new Vector<>(); v2.addAll(v1);`.
7. Verify contents: `System.out.println(v2);`.
8. Test remove: `v1.remove(Integer.valueOf(5)); System.out.println(v1);`.
9. Test removeAll: Create a collection with duplicates & remove: `Vector<Integer> v3 = new Vector<>(); v3.add(7); v1.removeAll(v3);`.
10. Output results to confirm behavior.

> [!NOTE]
> Ensure Vector shows ordered storage and removal operations.

### Lab 2: Generics Demo
1. Create `GenericTest.java`.
2. Declare generic Vector: `Vector<String> v = new Vector<>();`.
3. Add strings: `v.add("Hello"); v.add("World");`.
4. Attempt adding int: `v.add(5);` – observe compile error.
5. Use wildcard: `Vector<?> v2 = new Vector<Integer>(); v2.addAll(v);` – show error.
6. Correct with compatible types.
7. Run and verify type safety.

> [!IMPORTANT]
> This lab demonstrates generics preventing runtime type mismatches.

## Summary

### Key Takeaways
```diff
+ Vector is a thread-safe, ordered collection using a growable array.
+ Collection interface unifies operations across sub-types (Set, List, Queue).
- Avoid Vector in single-threaded apps due to performance overhead; prefer ArrayList.
+ Generics enforce type safety, reducing casting needs.
```
- **Overview Flow**: Objects → Collection → Specific Method Calls.

### Expert Insight

#### Real-world Application
In multi-threaded systems like web servers, Vector ensures safe access to shared lists (e.g., user session data). For high-performance needs, use synchronized wrappers on ArrayList.

#### Expert Path
Master collection frameworks by comparing List vs. Set vs. Queue. Dive into concurrency utilities (e.g., CopyOnWriteArrayList) for advanced thread safety. Practice with 18 collection classes to choose optimally.

#### Common Pitfalls
```diff
- Forgetting thread-safety: Vector synchronizes every operation, slowing performance.
- Generic mistakes: Using `Vector v = new Vector();` leads to unchecked warnings and runtime errors.
```
**Resolution**: Always specify generics (`Vector<Integer>`). To avoid synchronization overhead, use `Collections.synchronizedList(new ArrayList<>());`.

**Lesser Known**: Vector's capacity increment can be customized via constructors, impacting memory. Collections from Java 9+ support immutable methods (e.g., `List.of()`).

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
