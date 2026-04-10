# Session 111: Core Java Collections Framework Methods and Implementations

## Table of Contents
- [Introduction and Overview of 9 Collection Operations](#introduction-and-overview-of-9-collection-operations)
- [Collection Interface Methods](#collection-interface-methods)
- [List Interface Additional Methods](#list-interface-additional-methods)
- [Java API Documentation Guide](#java-api-documentation-guide)
- [Collection Implementations Overview](#collection-implementations-overview)
- [Vector Class Deep Dive](#vector-class-deep-dive)
- [ArrayList Comparison with Vector](#arraylist-comparison-with-vector)

## Introduction and Overview of 9 Collection Operations

The Java Collections Framework provides a comprehensive set of operations for managing groups of objects. This session builds upon previous classes discussing various collection classes (like HashSet, LinkedHashSet, TreeSet) and focuses on the core methods available across the collections framework.

The nine fundamental operations you can perform on collections are:
1. **Adding objects** - Single object addition and bulk addition
2. **Counting objects** - Determining collection size
3. **Printing objects** - String representation of collections
4. **Searching objects** - Finding objects within collections
5. **Retrieving objects** - Accessing stored objects
6. **Removing objects** - Individual and bulk removal
7. **Inserting objects** - Position-specific addition (index-based)
8. **Replacing objects** - Substituting existing objects
9. **Sorting objects** - Ordering collection elements

These operations are categorized into two types:
- **Single object operations**: Actions performed on individual elements (e.g., `add(object)`, `remove(object)`)
- **Bulk object operations**: Actions performed on collections of elements (e.g., `addAll(collection)`, `removeAll(collection)`)

## Collection Interface Methods

The `Collection` interface serves as the root interface in Java's collections hierarchy, providing common functionality inherited by both `Set` and `List` interfaces. It defines methods for core collection operations while remaining index-agnostic since `Set` implementations don't support indexing.

### Core Collection Operations

**Adding Objects:**
- `boolean add(E e)` - Adds a single object, returns `true` if added
- `boolean addAll(Collection<? extends E> c)` - Adds all elements from specified collection, returns `true` if collection changed

**Counting Objects:**
- `int size()` - Returns the number of elements in the collection

**Printing Objects:**
- `String toString()` - Returns string representation of all objects (implicitly called when printing collection)

**Searching Objects:**
- `boolean contains(Object o)` - Checks if collection contains specified object
- `boolean containsAll(Collection<?> c)` - Checks if collection contains all objects from specified collection

<!--- NOTE: "toString" was misspelled as "two string" multiple times in the transcript. Method name corrected here. Other corrections noted below. -->

**Retrieving Objects:**
Multiple approaches available for retrieving stored elements:
- `Iterator<E> iterator()` - Returns iterator for traversing elements
- `ListIterator<E> listIterator()` - Enhanced iterator with bidirectional traversal (for `List` implementations)
- Enhanced `for-each` loop using `Iterable` interface
- `forEach(Consumer<? super T> action)` method accepting lambda expressions
- `Stream<E> stream()` - Returns sequential stream for functional operations
- `Stream<E> parallelStream()` - Returns parallel stream for concurrent processing
- `Spliterator<T> spliterator()` - Returns spliterator for efficient parallel iteration

**Removing Objects:**
- `boolean remove(Object o)` - Removes specified object, returns `true` if found and removed
- `boolean removeAll(Collection<?> c)` - Removes all elements from specified collection
- `boolean retainAll(Collection<?> c)` - Retains only elements present in specified collection (removes others)
- `boolean removeIf(Predicate<? super E> filter)` - Removes elements matching predicate condition
- `void clear()` - Removes all elements from collection

> **Note**: Search and remove operations internally call `equals()` method from the search argument's class, allowing for data-wise comparison when `equals()` is properly overridden.

### Operations Not Supported by Collection Interface

The `Collection` interface does **not** support three operations that require indexing:
- **Inserting**: `add(int index, E element)` - Not supported (index required)
- **Replacing**: `set(int index, E element)` - Not supported (index required)  
- **Sorting**: `sort(Comparator<? super E> c)` - Not supported (requires duplicate handling logic)

## List Interface Additional Methods

The `List` interface extends `Collection` and provides index-based operations, establishing precise control over element positioning. Unlike `Set` implementations, `List` maintains insertion order and supports duplicate elements.

### Additional List Operations

**Inserting Objects (Index-Based):**
- `void add(int index, E element)` - Inserts element at specified index
- `boolean addAll(int index, Collection<? extends E> c)` - Inserts all collection elements at specified index

**Retrieving Objects (Enhanced):**
- `E get(int index)` - Returns element at specified index
- `ListIterator<E> listIterator()` - Returns bidirectional iterator
- `List<E> subList(int fromIndex, int toIndex)` - Returns view of portion between specified indices

**Replacing Objects:**
- `E set(int index, E element)` - Replaces element at index, returns previous element

**Removing Objects (Index-Based):**
- `E remove(int index)` - Removes and returns element at specified index

**Searching Objects:**
- `int indexOf(Object o)` - Returns first occurrence index of element
- `int lastIndexOf(Object o)` - Returns last occurrence index of element

**Sorting Objects:**
- `void sort(Comparator<? super E> c)` - Sorts list using specified comparator

### CRUD Operations on Lists

Lists support full CRUD operations (Create, Read, Update, Delete):
- **Create**: `add(int index, E element)`, `addAll(int index, Collection<? extends E> c)`
- **Read**: `get(int index)`, `subList(int fromIndex, int toIndex)`  
- **Update**: `set(int index, E element)`
- **Delete**: `remove(int index)`

### Java 22 Additions to List Interface

Recent Java versions added default methods to `List` interface:
- `void addFirst(E e)`, `void addLast(E e)` - Add to beginning/end
- `E getFirst()`, `E getLast()` - Retrieve first/last element
- `E removeFirst()`, `E removeLast()` - Remove and return first/last element
- `void replaceAll(UnaryOperator<E> operator)` - Replace elements using operator
- `List<E> reversed()` - Return reversed view

## Java API Documentation Guide

<!--- NOTE: Transcript contains references to "Java 22 API documentation" and various method signatures that align with Java API docs. The navigation described matches Java API documentation structure. -->

The Java API documentation is your primary reference for collections framework methods. To access it:

1. Search for "Java 22 API documentation" in your browser
2. Navigate to the main documentation page
3. Search for `java.util.Collection` or `java.util.List` interfaces
4. Explore method signatures with detailed descriptions

### Key Methods to Reference

**Collection Interface Methods:**
```java
// Core addition methods
boolean add(E e)
boolean addAll(Collection<? extends E> c)

// Size and emptiness
int size()
boolean isEmpty()

// Search operations  
boolean contains(Object o)
boolean containsAll(Collection<?> c)

// Retrieval methods
Iterator<E> iterator()
Stream<E> stream()
Spliterator<E> spliterator()

// Removal methods
boolean remove(Object o)
boolean removeAll(Collection<?> c)
boolean retainAll(Collection<?> c)
void clear()

// Array conversion
Object[] toArray()
<T> T[] toArray(T[] a)
```

**List Interface Additional Methods:**
```java
// Indexed operations
void add(int index, E element)
E get(int index)
E set(int index, E element)
E remove(int index)

// Bulk indexed operations
boolean addAll(int index, Collection<? extends E> c)

// Search by index
int indexOf(Object o)
int lastIndexOf(Object o)

// Sublist operations
List<E> subList(int fromIndex, int toIndex)

// Sorting
void sort(Comparator<? super E> c)
```

## Collection Implementations Overview

All `List` implementations inherit identical method signatures due to runtime polymorphism, making them interchangeable in terms of API usage. The key difference lies in internal implementation and thread safety characteristics.

### Runtime Polymorphism Benefits

Regardless of implementation choice (`ArrayList`, `Vector`, `LinkedList`), the method calls remain consistent:

```java
Vector<String> v1 = new Vector<>();
v1.add("element");        // Same syntax
System.out.println(v1.size());          // Same syntax

ArrayList<String> a1 = new ArrayList<>();
a1.add("element");        // Same syntax  
System.out.println(a1.size());          // Same syntax
```

All collections support:
- Identical method signatures for core operations
- Four types of objects (homogeneous, heterogeneous, unique, duplicate)
- Storage in insertion order
- Random and sequential retrieval
- Null values and duplicates
- `equals()` method invocation in search/remove operations

### Implementation Choice Factors

The decision between implementations depends on:
- **Thread Safety Requirements**: Single-threaded vs. multi-threaded
- **Performance Characteristics**: Memory allocation strategy
- **Growth Patterns**: Incremental capacity behavior

## Vector Class Deep Dive

`Vector` is Java's legacy collection class, predating the formal Collections Framework while serving as its foundation. It represents a thread-safe, growable array implementation of the `List` interface.

<!--- NOTE: Transcript contains multiple instances of "to string" instead of "toString", "adder" instead of "add", "ToStart" instead of "toString", and coding examples with incorrect variable names like "b1.add" instead of "v1.add". All method names and syntax corrected in examples below. -->

### Vector Characteristics (12 Key Points)

1. **Legacy Status**: Available since Java 1.0 version
2. **Usage Context**: Multi-threaded applications requiring thread safety
3. **Synchronization**: All methods are synchronized (thread-safe)
4. **Ordering**: Maintains insertion order (ordered collection)
5. **Data Structure**: Implements growable/resizable array
6. **Capacity Management**: 
   - Default initial capacity: 10 elements
   - Incremental capacity: Doubles when full (e.g., 10 → 20 → 40)
7. **Supported Object Types**: All four types (homogeneous, heterogeneous, unique, duplicate)
8. **Null Handling**: Allows both single and multiple null values
9. **Element Storage**: Objects stored in insertion order
10. **Access Patterns**: Supports both random and sequential retrieval
11. **Search Operations**: Uses `equals()` method from search argument's class
12. **Java Evolution**: Retrofitted into Collections Framework in Java 1.2

### Vector Constructors

```java
// Empty vector with default capacity (10)
Vector<E> v1 = new Vector<>();

// Vector with custom initial capacity  
Vector<E> v2 = new Vector<>(initialCapacity);

// Vector with custom capacity and incremental value
Vector<E> v3 = new Vector<>(initialCapacity, capacityIncrement);

// Vector initialized with elements from collection
Vector<E> v4 = new Vector<>(collection);
```

### Vector Usage Examples

```java
Vector<Object> v1 = new Vector<>();

// Adding elements (supports all object types)
v1.add("String element");      // String
v1.add(42);                    // Integer (autoboxed)
v1.add('P');                   // Character (autoboxed)
v1.add(true);                  // Boolean (autoboxed)
v1.add(null);                  // Null value
v1.add(new ExClass(5, 6));     // Custom object

// Capacity management
System.out.println("Capacity: " + v1.capacity()); // Vector-specific method
System.out.println("Size: " + v1.size());

// Random access retrieval
Object element = v1.get(4);    // Retrieve by index

// Sequential access patterns
// Traditional for loop
for (int i = 0; i < v1.size(); i++) {
    System.out.print(v1.get(i) + " ");
}
System.out.println();

// Enhanced for-each loop
for (Object obj : v1) {
    System.out.print(obj + " ");
}
System.out.println();

// forEach method with lambda
v1.forEach(obj -> System.out.print(obj + " "));
System.out.println();

// Stream API sequential processing
v1.stream().forEach(System.out::println);

// Vector output example:
// Capacity: 10, Size: 6
// Random access: null
// Sequential: String element 42 P true null ExClass@hashcode
```

### Vector Memory Characteristics

- **Initial State**: Creates Object[] array with 10 slots
- **Growth Behavior**: Creates new Object[] array when capacity exceeded
- **Synchronization Overhead**: Each method invocation includes lock/unlock operations
- **Object Pooling**: Wrapper classes follow autoboxing rules (e.g., Integers 0-127 share objects)

## ArrayList Comparison with Vector

`ArrayList` is the modern Collections Framework implementation preferred for single-threaded applications, providing unsynchronized performance benefits compared to `Vector`'s legacy threading model.

### ArrayList Characteristics

1. **Framework Status**: Part of Collections Framework since Java 1.2
2. **Usage Context**: Single-threaded applications (better performance)
3. **Synchronization**: Non-synchronized (faster but not thread-safe)
4. **Ordering**: Maintains insertion order (ordered collection)
5. **Data Structure**: Resizable array (growable array)
6. **Capacity Management**: 
   - Default initial capacity: 10 elements
   - Incremental capacity: Increases by approximately 50% when full
7. **Supported Object Types**: All four types (identical to Vector)
8. **Null Handling**: Same as Vector (allows nulls)
9. **Element Storage**: Same as Vector (insertion order)
10. **Access Patterns**: Same as Vector (random and sequential)
11. **Search Operations**: Same as Vector (`equals()` method usage)
12. **Capacity Control**: Cannot specify or retrieve capacity directly

### Key Differences: Vector vs ArrayList

| Aspect | Vector | ArrayList |
|--------|--------|-----------|
| Version | Java 1.0 (Legacy) | Java 1.2 (Modern Framework) |
| Synchronization | Synchronized (Thread-safe) | Unsynchronized (Not thread-safe) |
| Performance | Slower (due to locking) | Faster (no overhead) |
| Capacity Increment | Doubles (10→20→40) | ~50% increase (10→15→22→33) |
| Capacity Access | `capacity()` method available | No direct capacity access |
| Use Case | Multi-threaded apps | Single-threaded apps |
| Memory Overhead | Higher (synchronization) | Lower (no synchronization) |

### ArrayList Constructors (Subset of Vector)

```java
// Empty ArrayList with default capacity
ArrayList<E> al1 = new ArrayList<>();

// ArrayList with custom initial capacity  
ArrayList<E> al2 = new ArrayList<>(initialCapacity);

// ArrayList initialized with elements from collection
ArrayList<E> al3 = new ArrayList<>(collection);
```

### ArrayList Usage (Identical API to Vector)

```java
ArrayList<Object> al = new ArrayList<>();

// Same method calls as Vector
al.add("String element");
al.add(42);
al.add(null);

System.out.println("Size: " + al.size());  // No capacity() method available

// Same retrieval patterns
al.get(0);              // Random access
al.forEach(System.out::println);  // Sequential via forEach
al.stream().forEach(System.out::println); // Stream processing
```

### Memory Comparison: Vector vs ArrayList

**Vector Memory Diagram:**
- Internal variables: `elementData` (Object[]), `elementCount` (int)
- Growth: 10 → 20 → 40 (doubles)
- Each method: Lock → Execute → Unlock (thread-safe)

**ArrayList Memory Diagram:**
- Internal variables: Similar structure (different names)
- Growth: 10 → 15 → 22 → 33 (~50% increase)  
- Each method: Direct execution (no locking/unlocking)

## Summary

### Key Takeaways
```diff
+ Collection supports 6 core operations: add, size, toString, contains, iterator-based retrieval, and various removal methods
+ List extends Collection with index-based operations: get(index), set(index), remove(index), add(index), indexOf(), lastIndexOf(), subList(), sort()
+ Vector provides thread-safe operations with synchronized methods and doubling capacity growth
+ ArrayList offers better single-threaded performance with unsynchronized methods and ~50% capacity growth
+ Runtime polymorphism allows identical API usage across all List implementations
+ Search/remove operations internally call equals() from the search argument's class
```

### Expert Insight

**Real-world Application**
In production environments, prefer `ArrayList` for single-threaded applications handling web requests, data processing, or UI event handling where performance is critical. Reserve `Vector` for legacy multi-threaded server applications requiring thread safety, though `Collections.synchronizedList(new ArrayList<>())` often provides better efficiency. The immutable `List.of()` method (Java 9+) is ideal for read-only collections that prevent unexpected modifications.

**Expert Path**
Master collection internals by studying source code changes across Java versions, focusing on how `ArrayList` and `Vector` implement capacity growth algorithms. Deepen understanding through memory profiling tools, analyzing synchronization overhead impact on concurrent applications. Study comparable/comparator interfaces for custom sorting, and explore Spliterator implementation for advanced parallel processing.

**Common Pitfalls**
- Misusing `Vector` in single-threaded contexts due to unnecessary synchronization overhead (10-100x slower)
- Forgetting `equals()` method overriding impacts search/remove operations unexpectedly
- Attempting index-based operations on `Collection` interface methods (throws `UnsupportedOperationException` on Sets)
- Using `subList()` without understanding it's a view - modifications affect original list
- Assuming capacity is accessible across all `List` implementations (only `Vector` exposes `capacity()`)

**Lesser-known Things**
- `Vector` capacity increment is customizable via constructor, unlike unpredictable JVM-managed `ArrayList` growth
- `Spliterator` provides fail-fast iterators preventing concurrent modification exceptions during parallel processing
- `List.of()` creates memory-efficient fixed-size lists that throw exceptions on modification attempts
- Method overloading differences: `ArrayList.add(E)` vs `List.add(int, E)` for positional insertion

---
*Transcript corrections noted: "two string" → "toString", "adder" → "add", "ToStart" → "toString", "error list" → "ArrayList", "b1.add" → "v1.add", various method signature inconsistencies corrected for accuracy.* 

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
