# Session 109: Core Java & Full Stack Java - Part 3

## Table of Contents

- [Array Problems and Solutions](#array-problems-and-solutions)
- [Implementing Growable Array Algorithm (NidCollection)](#implementing-growable-array-algorithm-nidcollection)
- [Core Methods: Add and Increase Capacity](#core-methods-add-and-increase-capacity)
- [Memory Diagrams and Flow](#memory-diagrams-and-flow)
- [Data Storage Formats: Array vs. Key-Value](#data-storage-formats-array-vs-key-value)
- [NidTable for Key-Value Pair Format](#nidtable-for-key-value-pair-format)
- [Storing and Retrieving Orders](#storing-and-retrieving-orders)
- [Introduction to Java Collections Framework 1.0](#introduction-to-java-collections-framework-10)
- [From Custom Collections to Built-in Classes](#from-custom-collections-to-built-in-classes)

## Array Problems and Solutions

### Overview
Arrays in Java have five fundamental problems that limit their flexibility in real-world applications. Sun Microsystems designed the Collections API specifically to address these issues, providing classes that solve type constraints, size limitations, and format requirements. This session explores these problems and demonstrates how to solve them through custom implementations before revealing the built-in solutions.

### Key Concepts/Deep Dive
Arrays suffer from five core limitations:

1. **Type Homogeneity**: Arrays can only store homogeneous data types. Attempting to store heterogeneous objects (e.g., mixing Integer and String) leads to compilation errors or runtime issues unless using Object arrays.

2. **Fixed Size**: Arrays have immutable lengths. Once created with a specific capacity (e.g., 5 elements), you cannot increase or decrease the size dynamically.

3. **Single Format Limitation**: Arrays store data only in indexed format without key-value mappings.

4. **Deletion Complexity**: Removing elements requires manual algorithm implementation to shift remaining elements.

5. **Search and Sort Operations**: No built-in methods for searching or sorting; custom algorithms must be written.

To solve the **type problem**, use Object arrays instead of primitive-type arrays. Object arrays can store any object type through polymorphism, leveraging inheritance hierarchies where a superclass (Object) can hold any subclass instances.

> [!IMPORTANT]
> Understanding inheritance is crucial here. A Person array can store Student, Faculty, and Admin objects because they all extend Person. Ultimately, Object arrays serve as the foundation for heterogeneous storage.

### Code/Config Blocks
```java
// Solving type problem with Object array
Object[] arr = new Object[5]; // Can store any object type
arr[0] = "String object";
arr[1] = new Integer(10); // Autoboxing
arr[2] = new Student();   // Custom object
```

## Implementing Growable Array Algorithm (NidCollection)

### Overview
The growable array algorithm dynamically increases array capacity when needed, solving the fixed-size problem of arrays. This algorithm forms the core of list-based collections like ArrayList and demonstrates encapsulation principles through private fields and public methods.

### Key Concepts/Deep Dive
The algorithm uses four steps:

1. **Create New Array**: Allocate a larger array (typically double the current capacity).
2. **Copy Elements**: Transfer references from the old array to the new array.
3. **Point to New Array**: Update the reference variable to point to the expanded array.
4. **Store New Element**: Add the new element to the available position.

The implementation uses two variables:
- `obj`: Reference to the Object array (private for encapsulation).
- `index`: Tracks both array position for insertion and count of stored elements.

### Code/Config Blocks
```java
class NidCollection {
    private Object[] obj; // Private: encapsulates array access
    private int index = 0;  // Tracks position and element count
    
    NidCollection() {
        obj = new Object[10]; // Initial capacity: 10
    }
    
    void add(Object element) {
        // Step logic here (detailed below)
    }
    
    void increaseCapacity() {
        // Growable array logic
    }
}
```

### Lab Demos
Express explicit lab demo steps for implementing NidCollection:

1. Create the NidCollection class with private Object[] obj and int index.
2. In the constructor, initialize obj as new Object[10] and index as 0.
3. Implement add(Object element):
   - Check if index == obj.length (if full, call increaseCapacity).
   - Store element in obj[index].
   - Increment index.
4. Implement increaseCapacity():
   - Create new array with double capacity: Object[] tempObj = new Object[obj.length * 2].
   - Copy elements: for(int i = 0; i < obj.length; i++) { tempObj[i] = obj[i]; }
   - Assign new array: obj = tempObj.

## Core Methods: Add and Increase Capacity

### Overview
The add method encapsulates array access, verifying capacity before insertion. The increaseCapacity method implements the growable logic, ensuring dynamic resizing without user intervention.

### Key Concepts/Deep Dive
The add method follows encapsulation:
- **Verification**: Check if array is full (size == capacity).
- **Storage**: Use index as array position.
- **Counter Management**: Increment index as both position and size tracker.

increaseCapacity doubles capacity dynamically:
- Current capacity = obj.length
- New capacity = obj.length * 2 for exponential growth
- Old array becomes eligible for garbage collection after copying

### Code/Config Blocks
```java
void add(Object element) {
    if (index == obj.length) { // Size equals capacity
        increaseCapacity();   // Grow the array
    }
    obj[index] = element; // Store element
    index++;               // Increment counter/position
}

void increaseCapacity() {
    Object[] tempObj = new Object[obj.length * 2]; // Double capacity
    for (int i = 0; i < obj.length; i++) {        // Copy references
        tempObj[i] = obj[i];
    }
    obj = tempObj; // Point to new array (old array GC eligible)
}
```

### Tables

| Method | Purpose | Key Logic |
|--------|---------|-----------|
| add() | Inserts element into collection | Verify size, store at index, increment index |
| increaseCapacity() | Doubles array capacity | Create new array, copy elements, reassign reference |

## Memory Diagrams and Flow

### Overview
Visualizing memory allocation demonstrates how growable arrays manage dynamic expansion, copy operations, and garbage collection.

### Key Concepts/Deep Dive
When increasing capacity:
- Old array (e.g., 10 elements) becomes unreachable.
- New array (e.g., 20 elements) holds copied references.
- Objects themselves are not copied; only references are transferred.

### Diagrams
```mermaid
sequenceDiagram
    participant Main
    participant NidCollection
    participant Array
    
    Main->>NidCollection: new NidCollection()
    NidCollection->>Array: obj = new Object[10]
    Main->>NidCollection: add("String")
    NidCollection->>Array: obj[0] = "String"; index=1
    Main->>NidCollection: add Integer(11) // When full
    NidCollection->>NidCollection: increaseCapacity()
    NidCollection->>Array: tempObj = new Object[20]
    NidCollection->>Array: Copy obj[0..9] to tempObj
    NidCollection->>NidCollection: obj = tempObj
    NidCollection->>Array: obj[10] = Integer(11)
```

```diff
+ Phase 1: Initial array (10 slots)
+ Phase 2: Full - Trigger grow
- Phase 3: Copy to 20-slot array (10 elements copied)
+ Phase 4: Store new element in slot 10
```

> [!NOTE]
> String literals use string pooling, so identical strings share the same heap object across array positions.

## Data Storage Formats: Array vs. Key-Value

### Overview
Data organization falls into two primary formats: indexed arrays (no keys) and key-value pairs. Choose based on whether data needs meaningful associations or simple sequence storage.

### Key Concepts/Deep Dive
- **Array Format**: Elements stored by index (0, 1, 2). No intrinsic meaning to index values.
- **Key-Value Format**: Associates keys with values (e.g., employee ID → employee object). Keys provide semantic meaning.

## NidTable for Key-Value Pair Format

### Overview
Extending NidCollection principles, NidTable uses parallel arrays to implement key-value mappings, requiring simultaneous capacity management for both key and value arrays.

### Key Concepts/Deep Dive
- Two arrays: key[] and value[].
- Same index links key to value.
- Capacity increase affects both arrays simultaneously.
- Add method takes two parameters: key and value.

### Code/Config Blocks
```java
class NidTable {
    private Object[] key;
    private Object[] value;
    private int index = 0;
    
    void put(Object k, Object v) {
        if (index == key.length) {
            increaseCapacity();
        }
        key[index] = k;
        value[index] = v;
        index++;
    }
}
```

## Storing and Retrieving Orders

### Overview
Data can be organized by storing order (how added) and retrieving order (how accessed). Custom collections can implement different orders like insertion, hash code, or sorting.

### Key Concepts/Deep Dive
- **Storing Orders**: Insertion order, hash code order, sorting order.
- **Retrieving Orders**: Sequential (0 to n), random access, Last-In-First-Out (LIFO), First-In-First-Out (FIFO).
- Multiple classes needed per combination (e.g., NidCollection for insertion/random; NidSortedList for sorting/sequential).

> [!INITIAL]
> Real collections frameworks provide 7 orders (3 storing + 4 retrieving), requiring multiple class implementations.

## Introduction to Java Collections Framework 1.0

### Overview
Java 1.0 provided two format-based classes: Vector (array format) and Hashtable (key-value format). These match NidCollection and NidTable structures with built-in growable behavior.

### Key Concepts/Deep Dive
- **Vector**: Internally uses Object[]. Stores homogeneous/heterogeneous objects without keys. Equivalent to NidCollection.
- **Hashtable**: Stores key-value pairs with hashing for fast lookups.

## From Custom Collections to Built-in Classes

### Overview
Understanding custom implementation reveals how built-in classes work underneath. Vector matches NidCollection; later ArrayList improves Vector with better performance.

### Key Concepts/Deep Dive
- A vector internally creates Object[10] and applies growable algorithm.
- Vector.add() methods increment index after verification.
- Capacity doubling occurs automatically when storing the 11th element.

### Code/Config Blocks
```java
// Equivalent to custom NidCollection
Vector v = new Vector(); // Creates Object[10] internally
v.add(student1);        // Stores in index 0
v.add(student2);        // Stores in index 1
// When 11th object: capacity increases to 20
```

## Summary

### Key Takeaways
```diff
+ Arrays limit type (homogeneous only) and size (fixed capacity)
+ Collections solve via Object arrays and growable algorithms
+ NidCollection Node (ArrayList-like) uses Object[] with dynamic growth
+ NidTable (HashMap-like) uses paired arrays for key-value storage
+ Vector and Hashtable provide the same as built-in classes
+ Encapsulation hides array access behind methods like add()
- Direct array access invites IndexOutOfBoundsException
```

### Expert Insight

#### Real-world Application
In production systems, custom collection-like classes appear as DAO objects:
- **Growable Lists**: Order processing stores items dynamically without size pre-knowledge
- **Mapped Storage**: User sessions use key-value pairs (sessionID → userData)
- Typical pattern: `List<Order> orders = new ArrayList<>();` grows automatically during load

#### Expert Path
- **Build Core Collections**: Implement ArrayList and HashMap from scratch to master algorithms
- **Performance Profiling**: Use memory analyzers to observe growable behavior and GC impact
- **Multithreading**: Study thread-safe variants (Vector vs. ArrayList) for concurrent applications

#### Common Pitfalls
- **Index vs. Size Confusion**: Remember index tracks both position and count (size = index)
- **Reference Copying**: Growable arrays copy references, not objects; use cloning for deep copies
- **Capacity Miscalculation**: Premature growth wastes memory; delayed growth causes frequent expansion

#### Lesser Known Things
- **String Pooling Impact**: Identical strings share heap objects, affecting reference copying diagrams
- **Autoboxing in Collections**: Primitives convert to wrapper objects, impacting memory (e.g., int → Integer)
- **Collection Evolution**: Java evolved from 2 classes (Vector, Hashtable) to 18+ classes across versions, each solving specific order/concurrency needs
- **Garbage Collection Timing**: Old arrays remain in memory until method completion when reassigned
- **Format Choice Philosophy**: Array format for data with existing structure (e.g., arrays of objects); key-value for associative data (e.g., configurations)
