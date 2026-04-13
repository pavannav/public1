# Session 152: Collections 10 04

## Table of Contents
- [Searching Operations in LinkedList](#searching-operations-in-linkedlist)
- [Linear Search Algorithm](#linear-search-algorithm)
- [Contains Method Implementation](#contains-method-implementation)
- [IndexOf Method Implementation](#indexof-method-implementation)
- [Null vs Object Handling](#null-vs-object-handling)
- [Performance Optimizations](#performance-optimizations)
- [Custom Collection Implementation](#custom-collection-implementation)
- [Summary](#summary)

## Searching Operations in LinkedList

### Overview
This session focuses on search operations in LinkedList, a key component of Java Collections. Unlike ArrayList which uses indexed-based access, LinkedList relies on node-based traversal. We'll explore how search methods like `contains()` and `indexOf()` work internally, using linear search algorithms.

### Key Concepts
LinkedList maintains elements in nodes where each node contains:
- Data (item)
- Reference to next node

Searching in LinkedList requires traversing from the first node to subsequent nodes using the `next` reference.

### Lab Demo: Using Contains Method

```java
LinkedList<String> list = new LinkedList<>();
list.add("a");
list.add("five");
list.add(null);
list.add(new A(5, 6));

// Search operations
System.out.println(list.contains("a"));        // true
System.out.println(list.contains("five"));     // true  
System.out.println(list.contains(null));       // true
System.out.println(list.contains(new A(5, 6))); // true (if equals overridden)
```

## Linear Search Algorithm

### Overview
LinkedList uses linear search for finding objects, iterating through nodes sequentially until finding a match or reaching the end.

## Contains Method Implementation

### Internal Logic

The `contains(Object obj)` method searches for an object in the LinkedList collection.

**Signature:**
```java
public boolean contains(Object obj)
```

**Steps:**
1. Check if `obj` is null → use `==` for comparison
2. For non-null objects → use `.equals()`
3. Traverse from first node to last node
4. Return true if found, false otherwise

### Code Implementation
```java
// Simplified internal implementation concept
public boolean contains(Object obj) {
    Node node = first;  // Start from first node
    
    while (node != null) {
        if (obj == null) {
            if (node.item == null) {  // Reference comparison for null
                return true;
            }
        } else {
            if (obj.equals(node.item)) {  // Content comparison for objects
                return true;
            }
        }
        node = node.next;  // Move to next node
    }
    return false;
}
```

> [!NOTE]
> The implementation uses equals() method, so proper overriding is crucial for custom objects to work correctly in searches.

## IndexOf Method Implementation

### Overview
The `indexOf(Object obj)` method finds the position of an object in the LinkedList and returns its index.

**Example Usage:**
```java
System.out.println(list.indexOf("a"));        // 0
System.out.println(list.indexOf("five"));     // 1
System.out.println(list.indexOf(null));       // 2
System.out.println(list.indexOf("nonexistent")); // -1
```

### Internal Logic

```java
// Conceptual implementation
public int indexOf(Object obj) {
    int index = 0;          // Start index from 0
    Node node = first;      // Start from first node
    
    while (node != null) {
        if (obj == null) {
            if (node.item == null) {
                return index;
            }
        } else {
            if (obj.equals(node.item)) {
                return index;
            }
        }
        node = node.next;
        index++;            // Increment index for each node
    }
    return -1;              // Not found
}
```

> [!IMPORTANT]
> LinkedList gives the illusion of indexing, but internally maintains position by incrementing a counter during traversal.

## Null vs Object Handling

### Key Differentiation

**Null Objects:**
- Use `==` (reference comparison)
- Check `node.item == null`

**Regular Objects:**
- Use `.equals()` (content comparison)
- Check `obj.equals(node.item)`

### Performance Note
```java
// Inefficient: Repeated obj retrieval
if (obj == null) {  // obj accessed multiple times in loop

// Optimized: Cache object value if null
Object target = obj;
// Then compare target in loop
if (target == null) { // Faster when obj is null
```

## Performance Optimizations

### Contains vs IndexOf Relationship

The `contains()` method can leverage `indexOf()` for optimization:

```java
public boolean contains(Object obj) {
    return indexOf(obj) >= 0;  // Elegant reuse
}
```

### Traversing Nodes
```java
// Memory diagram traversal
node = first;        // Point to first node
// Loop condition
while (node != null) {
    // Compare current node.item
    node = node.next;  // Move reference to next node
}
```

## Custom Collection Implementation

### Creating Your Own Collection Class

**Step 1: Define MyArrayList**
```java
public class MyArrayList {
    private Object[] elementData;     // Internal array
    private int elementCount;         // Size counter
    private int initialCapacity;      // Capacity
    
    public MyArrayList() {
        this(10);  // Default capacity
    }
    
    public MyArrayList(int initialCapacity) {
        if (initialCapacity < 0) {
            throw new IllegalArgumentException();
        }
        elementData = new Object[initialCapacity];
        elementCount = 0;
    }
}
```

**Step 2: Define MyLinkedList**
```java
public class MyLinkedList {
    private Node first;         // First node reference
    private int size;           // Element count
    
    // Node class
    private static class Node {
        Object item;
        Node next;
        Node(Object item, Node next) {
            this.item = item;
            this.next = next;
        }
    }
}
```

> [!TIP]
> Implement all operations from scratch to gain deep understanding of collection internals.

## Summary

### Key Takeaways
+ Searching in LinkedList uses linear algorithm with node traversal
+ Contains method returns true/false, indexOf returns position (-1 if not found)
+ Null objects use reference comparison (`==`), others use `.equals()`
+ Performance can be optimized by caching values in loops
+ Contains internally reuses indexOf logic in Sun's implementation
- LinkedList provides indexed illusion but node-based internally
- Creating custom collections helps understand Sun's design decisions

### Expert Insight

#### Real-world Application
In high-performance applications, understand LinkedList search complexity O(n) vs ArrayList O(1) for random access. Choose data structure based on predominant operations - frequent searches favor ArrayList, frequent insertions/deletions favor LinkedList.

#### Expert Path
Master collection internals by implementing custom versions. Focus on:
1. Memory management in node-based vs array-based structures
2. Performance implications of different traversal algorithms
3. Transformation between data structures

#### Common Pitfalls
+ Forgetting proper `.equals()` overriding for custom object searches
+ Assuming LinkedList has true indexing (it simulates indexing)
+ Inefficient null handling in loops
+ Not reusing optimized logic (contains calling indexOf)

+ Lesser known things about this topic:
  - LinkedList implements both List and Deque interfaces, enabling stack/queue operations
  - Internal node class is often package-private and nested for encapsulation
  - Sun's implementation includes optimization hints like transient serialization markers

## Transcript Correction Notes
- "ript" → "script" (likely at beginning)
- Various speech-to-text artifacts like "rist" for "list", "meoward" for "method"
- "kubeCtl" contexts corrected to Java-related terms (no relevant kubectl references found)

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
