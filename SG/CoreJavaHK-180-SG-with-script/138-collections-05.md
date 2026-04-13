# Session 05: Collections - List Interface and Vector Implementation

## Table of Contents

- [Collections Review](#collections-review)
- [List Interface](#list-interface)
- [Vector Class](#vector-class)
- [Summary](#summary)

## Collections Review

### Overview

Collections represent a framework for storing and manipulating groups of objects in Java. The `Collection` interface is the root of the Collection hierarchy, introduced in Java 1.2, providing common methods for all collections such as `List`, `Set`, and `Queue`. It handles operations like adding, removing, and iterating over elements. The `Iterable` interface, added in Java 1.5, provides iteration capabilities and is implemented by all collections but is not the root interface for collection-specific operations.

### Key Concepts/Deep Dive

- **Collection Hierarchy**: Rooted at `Collection`, which provides 21 methods (15 initial from Java 1.2, 5 from Java 8, 1 from Java 11). Subinterfaces include `List` and `Set`.
- **Interfaces Involved**: `Iterable` (superinterface from Java 1.5) for iteration; not the root for collection operations.
- **Common Operations**: 
  - Addition: `add(Object)`, `addAll(Collection)`
  - Removal: `remove(Object)`, `removeAll(Collection)`, `retainAll(Collection)`, `clear()`
  - Retrieval: `contains(Object)`, `containsAll(Collection)`, `isEmpty()`, `size()`
  - Iteration: `iterator()`, `forEach(Consumer)`, `stream()`
  - Array Conversion: `toArray()`, `toArray(T[])`
- **Versions**: Java 1.2 introduced `Collection` and basic methods; Java 8 added functional methods like `forEach`, `stream`; Java 11 added `toArray(IntFunction)`.

| Feature | Collection Interface |
|---------|----------------------|
| Available Since | Java 1.2 |
| Methods | 21 |
| Purpose | Root for group operations |
| Key Subinterfaces | List, Set |

## List Interface

### Overview

The `List` interface is a subinterface of `Collection`, introduced in Java 1.2. It represents an ordered collection (sequence) of elements, allowing access by integer index and supporting duplicates. It provides precise control over element insertion and position, enabling indexed-based operations beyond the general collection methods.

### Key Concepts/Deep Dive

- **Characteristics**:
  - Ordered collection maintaining insertion order with index.
  - Allows duplicates and null values.
  - Used for sequence-based data storage with random access.
- **Inherited Methods**: 21 from `Collection`.
- **Additional Methods for Index-Based Operations**:
  - **Insertion**: `add(int, E)` - inserts element at specified index; `addAll(int, Collection)` - inserts collection at index.
  - **Retrieval**: `get(int)` - retrieves element at index.
  - **Update**: `set(int, E)` - replaces element at index, returns old value.
  - **Removal**: `remove(int)` - removes and returns element at index; `remove(Object)` behavior depends on type but uses `equals`.
  - **Searching**: `indexOf(Object)` - first occurrence index (-1 if not found); `lastIndexOf(Object)` - last occurrence index.
  - **Sublist**: `subList(int, int)` - returns view of portion (from start inclusive to end exclusive).
  - **Iteration**: `listIterator()` - bidirectional iterator from start; `listIterator(int)` - from specific index.

Additional methods from Java versions:
- Java 8: `replaceAll(UnaryOperator)`, `sort(Comparator)`
- Java 9: Factory methods `of`, `of(E...)`, `copyOf`
- Java 10: `copyOf(Collection)`

| Method Type | Example | Description |
|-------------|---------|-------------|
| Insertion | `add(1, "item")` | Inserts at index 1, shifts elements. |
| Retrieval | `get(2)` | Gets element at index 2. |
| Removal | `remove(0)` | Removes and returns first element. |

### Code/Config Blocks

#### Creating and Using a List
```java
import java.util.*;

public class ListExample {
    public static void main(String[] args) {
        List<String> list = new ArrayList<>(); // Can be LinkedList, Vector, etc.
        list.add("A");
        list.add(1, "B"); // Insert at index 1
        list.set(1, "C"); // Update at index 1
        System.out.println(list); // [A, C]
        list.remove(1); // Remove at index 1
        System.out.println(list); // [A]
    }
}
```

## Vector Class

### Overview

`Vector` is a Legacy collection class from Java 1.0, retrofitted into the Collections framework in Java 1.2 as an implementation of `List`. It uses a growable array to store elements, providing thread-safe operations via synchronization. Implements `Serializable`, `Cloneable`, and `RandomAccess` for additional capabilities.

### Key Concepts/Deep Dive

- **Constructor Hierarchy**: 
  - `Vector()`: Default capacity 10, grows by double.
  - `Vector(int initialCapacity)`
  - `Vector(int initialCapacity, int capacityIncrement)`
  - `Vector(Collection)`
- **Implementation Details**: Growable array (resizable array). Default capacity: 10; incremental strategy: doubles capacity when exceeded (e.g., 11th element → capacity 20).
- **Thread Safety**: All methods synchronized, suitable for multi-threaded environments.
- **Order and Access**: Ordered sequence, begins at index 0. Supports random and sequential access.
- **Element Handling**: Allows all types (homogeneous, heterogeneous, unique, duplicate, including nulls).
- **Searching and Removal**: Uses `equals` for object-based operations; index-based operations direct without `equals`.

#### Lab Demo: Creating Vector and Adding Elements

```java
import java.util.Vector;

public class VectorDemo {
    public static void main(String[] args) {
        Vector v = new Vector(); // No generics for demo
        System.out.println("Capacity: " + v.capacity()); // 10
        System.out.println("Size: " + v.size()); // 0
        
        v.add("A");
        v.add(new Integer(5));
        v.addElement("B"); // Legacy method
        v.add(null);
        v.add("A"); // Duplicate
        
        System.out.println("Vector: " + v); // [A, 5, B, null, A]
        System.out.println("Contains 'A': " + v.contains("A")); // true (1st index)
        System.out.println("Index of 'A': " + v.indexOf("A")); // 0
        System.out.println("Last index of 'A': " + v.lastIndexOf("A")); // 4
        
        // Removal
        v.remove(2); // Removes "B" at index 2
        System.out.println("After remove(2): " + v); // [A, 5, null, A]
        
        // Grow capacity
        v.add(5.5);
        v.add(6); // 6th element, but wait, after capacity: when size > capacity, grows to 20
        // Demo growth, but not shown in full for brevity
    }
}
```

- **Capacity Behavior**: When size reaches capacity (10), adding 11th doubles to 20. No incremental step beyond initial.
- **Random Access**: Use `get(int)` for quick access.
- **Multi-threading**: Suitable for shared data in multi-threaded apps.

| Aspect | Vector |
|--------|-------|
| Thread Safety | Synchronized |
| Capacity | 10 default, grows by double |
| Access | Random (O(1)) |
| Allows | Nulls, duplicates |

### Lab Demos

1. **Creating Vector and Adding Elements Steps**:
   - Create `Vector v = new Vector();`
   - Add elements: `v.add("A"); v.add(5);` (heterogeneous)
   - Check capacity and size.
   - Demonstrate duplicates: Add "A" again.
   - Result: Stores all, maintains order.

2. **Retrieval and Update Steps**:
   - Retrieve: `v.get(0);`
   - Update: `v.set(1, "New")` → Returns old value.
   - Subset: `v.subList(1, 3)` → View from index 1 to 2 (3 exclusive).

3. **Searching Steps**:
   - `v.indexOf("A")` → Returns 0 (first match).
   - `v.lastIndexOf("A")` → Returns last index.
   - `v.contains("B")` → True if exists.

## Summary

### Key Takeaways

```diff
! Collection is root of collection hierarchy, Iterable provides iteration, not collection ops.
+ List adds index-based ops for ordered, duplicate-supporting sequences.
- Itable (Iterable) is not the root; collection methods (add, remove) not in Iterable.
+ Vector: Legacy, thread-safe growable array; use for multi-threaded indexed storage.
+ Index ops (add(int), get(int)) differ from object-based (add(Object), remove(Object)).
- Avoid mixing index and object remove; object removes use equals for linear search.
```

### Expert Insight

#### Real-world Application
Use `Vector` in legacy systems or multi-threaded apps needing thread-safe lists (e.g., shared configuration lists in servers). For new apps, prefer `ArrayList` for performance, securing with external locks.

#### Expert Path
Master generics for type safety, learn internal resizing algoritrs, and explore alternatives like `CopyOnWriteArrayList` for concurrent reads. Practice overriding `equals` and `hashCode` for custom objects in searches.

#### Common Pitfalls
- Mistaking `remove(int)` vs. `remove(Object)`: Uses index without `equals`; object with `equals`.
- Index bounds errors in `subList(end)`: End is exclusive; verify size.
- Performance: Vector's synchronization overhead; use `ArrayList` if no threading.
- Lesser Known Things: `Vector` enumerates elements; use `Enumeration` for legacy iteration. Factory methods (`of()`) create immutable lists.

**Notes on Transcript Corrections**:
- "erable" → "iterable"
- "sub as" → "subclass"
- "up classes" → "subclasses" 
- "threat safety" → "thread safety"
- "ilable" → "iterable"
- Method counts: Collection methods detailed as 21, but historical are accurate. 
- CDocumentation confirms collection root.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
