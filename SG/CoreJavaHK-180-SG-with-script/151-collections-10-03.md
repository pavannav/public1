# Session 151: Collections 10 03

## Table of Contents
- [Retrieving Elements from Collections](#retrieving-elements-from-collections)
- [Removing Elements from Collections](#removing-elements-from-collections)
- [Comparing ArrayList and LinkedList](#comparing-arraylist-and-linkedlist)
- [LinkedList Constructors and Methods](#linkedlist-constructors-and-methods)
- [Memory Diagram for LinkedList](#memory-diagram-for-linkedlist)
- [Programming with LinkedList](#programming-with-linkedlist)

## Retrieving Elements from Collections

### Overview
Retrieving elements is a fundamental operation in Java Collections. Collections provide multiple ways to access stored objects, including index-based retrieval, iterators for sequential access, and streams for functional-style operations. The choice of retrieval method depends on whether you need random access (any index) or sequential traversal.

### Key Concepts
Collections support various retrieval mechanisms:
- **Index-based retrieval**: Use `get(index)` for direct access to an element at a specific position.
- **Iterator interfaces**: `Iterator`, `ListIterator`, `Spliterator` for traversing collections.
- **Enhancements from Java 8+**: Functional-style retrieval with `forEach()`, `stream()`, and `parallelStream()`.
- **Return Types**: Methods like `contains()` return `boolean`, while `indexOf()` and `lastIndexOf()` return integers (index or -1 if not found).

#### Code Examples
```java
ArrayList<String> al = new ArrayList<>();
al.add("Apple");
al.add("Banana");

// Retrieving by index
String fruit = al.get(0); // Returns "Apple"

// Using iterator for sequential access
Iterator<String> iter = al.iterator();
while (iter.hasNext()) {
    System.out.println(iter.next());
}

// ListIterator for bidirectional traversal
ListIterator<String> listIter = al.listIterator();
while (listIter.hasNext()) {
    System.out.println(listIter.next());
}
while (listIter.hasPrevious()) {
    System.out.println(listIter.previous());
}

// ForEach with Consumer
al.forEach(item -> System.out.println(item));

// Streams for functional operations
long count = al.stream().filter(s -> s.startsWith("A")).count();
al.parallelStream().forEach(System.out::println);

// Spliterator for advanced splitting
Spliterator<String> spliter = al.spliterator();
spliter.tryAdvance(System.out::println);
```

> [!NOTE]
> `parallelStream()` is useful for large datasets on multi-core systems, but adds overhead for small collections.

## Removing Elements from Collections

### Overview
Removing elements involves deleting objects based on index, value, condition, or clearing the entire collection. Collections provide multiple `remove` methods to handle different scenarios, ensuring flexibility for single or bulk removals.

### Key Concepts
- **Single Element Removal**: `remove(index)` for index-based, `remove(Object)` for value-based.
- **Bulk Removal**: `removeAll(Collection)` removes matching elements, `removeIf(Predicate)` removes based on condition.
- **Complete Clearing**: `clear()` empties the collection.
- **Return Behavior**: `remove(Object)` returns `boolean` (true if removed), index-based returns the removed object.

#### Code Examples
```java
ArrayList<String> al = new ArrayList<>();
al.add("Apple");
al.add("Banana");
al.add("Cherry");

// Remove by index
String removed = al.remove(1); // Removes "Banana", returns it

// Remove by object
boolean result = al.remove("Apple"); // Removes "Apple", returns true

// Remove all from another collection
ArrayList<String> toRemove = new ArrayList<>();
toRemove.add("Banana");
al.removeAll(toRemove);

// Remove with condition
al.removeIf(s -> s.equals("Cherry"));

// Clear entire collection
al.clear();
```

> [!IMPORTANT]
> For collections with duplicates, `remove(Object)` removes the first occurrence, while `removeAll()` removes all matching instances.

## Comparing ArrayList and LinkedList

### Overview
ArrayList and LinkedList are both implementations of the `List` interface but differ in underlying data structures, performance, and use cases. ArrayList uses a resizable array for fast random access, while LinkedList uses a doubly linked list for efficient insertions/deletions.

### Key Concepts
| Aspect | ArrayList | LinkedList |
|--------|-----------|------------|
| Data Structure | Resizable array | Doubly linked list |
| Random Access | Fast (O(1)) | Slow (O(n)) |
| Insert/Remove | Slow (shift elements) | Fast (O(1) at ends, O(n) in middle) |
| Memory Usage | Less overhead | More (node objects) |
| Thread Safety | Not synchronized | Not synchronized |
| Version Introduced | Java 1.2 | Java 1.2 |
| Null Handling | Allows multiple nulls | Allows multiple nulls |
| Iteration | Supports all access patterns | Sequential preferred |
| Best For | Frequent random access, read-heavy operations | Frequent inserts/deletes, especially at ends or middle |

> [!NOTE]
> Use ArrayList for general-purpose lists; choose LinkedList when operations are insert/remove-heavy and sequential access dominates.

## LinkedList Constructors and Methods

### Overview
LinkedList constructors allow creating empty lists or initializing from other collections. It does not support capacity specification (unlike ArrayList), as it uses a node-based structure with default zero capacity. LinkedList implements `List`, `Deque` (since Java 5), and inherits common collection methods.

### Key Concepts
- **Constructors**:
  - `LinkedList()`: Empty list.
  - `LinkedList(Collection<? extends E> c)`: Copies elements from another collection.
- **Inheritance**: Extends `AbstractSequentialList`, implements `List`, `Deque`, `Cloneable`, `Serializable`.
- **Additional Methods** (from Deque since Java 5): `offerFirst()`, `offerLast()`, `pollFirst()`, `pollLast()`, etc.
- **No Extra Methods**: Unlike ArrayList, no `ensureCapacity()` or `trimToSize()`.
- **Size and Capacity**: `size()` method returns current element count; capacity is dynamic and not configurable.

#### Code Examples
```java
// Empty LinkedList
LinkedList<String> ll = new LinkedList<>();

// LinkedList from Collection
ArrayList<String> al = new ArrayList<>();
al.add("A");
LinkedList<String> ll2 = new LinkedList<>(al);

// Common operations
ll.add("Apple");        // Append
ll.addFirst("Banana");  // Add to front
ll.addLast("Cherry");   // Add to end
System.out.println(ll.getFirst()); // Retrieve first
ll.removeLast();        // Remove end
```

## Memory Diagram for LinkedList

### Overview
LinkedList stores elements in a doubly linked list of nodes, each containing references to the previous node, the element, and the next node. The LinkedList object holds references to the first and last nodes, plus a size counter.

### Key Concepts
- **Node Structure**: Each node has `item` (element), `next` (next node), `prev` (previous node).
- **LinkedList Structure**: `first` (points to first node), `last` (points to last node), `size` (element count).
- **Default Values**: `first` and `last` are null initially; size is 0.
- **Adding Element**: Creates new node, links it to existing nodes, updates `first`/`last` as needed.
- **Example Diagram** (simplified; for full visualization, see code execution in IDE):

```mermaid
graph LR
    A[LinkedList Object] --> B[first = Node1]
    A --> C[last = Node3]
    B --> D[Node1: prev=null, item="A", next=Node2]
    D --> E[Node2: prev=Node1, item="B", next=Node3]
    E --> F[Node3: prev=Node2, item=null, next=null]
```

- **Internal Flow**: When calling `add(Object o)`:
  - Create new node with `prev` = current `last`, `item` = o, `next` = null.
  - If `last == null` (first add), set `first = newNode`.
  - Else, set `last.next = newNode`.
  - Set `last = newNode`.
  - Increment `size`.

> [!NOTE]
> Null elements are stored directly in the node without creating additional objects.

## Programming with LinkedList

### Overview
Programming with LinkedList follows the same collection methods as ArrayList, but performance and behavior align with its doubly linked structure. Focus on sequential operations and avoid random access.

### Key Concepts
- **Initialization**: Store heterogeneous objects, maintain insertion order.
- **Operations**: Add, retrieve, search, remove using standard methods.
- **Memory Visualization**: Build mental models of nodes linking when adding/removing.
- **Typical Program Flow**: Create list, add elements (allowing duplicates/nulls), perform operations, iterate.

#### Code Examples
```java
import java.util.*;

public class LinkedListDemo {
    public static void main(String[] args) {
        LinkedList<Object> ll = new LinkedList<>();
        
        // Check empty
        System.out.println(ll.isEmpty()); // true
        
        // Add heterogeneous elements
        ll.add("Apple");
        ll.add(10);
        ll.add("Apple"); // Duplicate allowed
        ll.add(null);    // Null allowed
        ll.add(new LinkedListDemo()); // Custom object
        
        System.out.println(ll.isEmpty()); // false
        System.out.println(ll.size());    // 5
        
        // Retrieve
        System.out.println(ll.get(0));     // Apple
        System.out.println(ll.getFirst()); // Apple
        System.out.println(ll.getLast());  // LinkedListDemo
        
        // Iterate
        for (Object obj : ll) {
            System.out.println(obj);
        }
        
        // Search
        System.out.println(ll.contains("Apple"));        // true
        System.out.println(ll.indexOf("Apple"));         // 0
        System.out.println(ll.lastIndexOf("Apple"));     // 2
        
        // Remove
        ll.remove(1);                    // Remove by index
        ll.remove("Apple");              // Remove first occurrence
        ll.removeIf(obj -> obj == null); // Remove null
        ll.clear();                      // Clear all
    }
}
```

> [!IMPORTANT]
> LinkedList maintains insertion order without indexes internally. For interviews, explain node creation and linking in `add()` methods.

## Summary

### Key Takeaways
```diff
+ Collections provide multiple retrieval methods: index-based with get(), iterators, and streams.
+ Removing elements supports single, bulk, and conditional operations via remove() variants and clear().
+ ArrayList excels in random access with array structure; LinkedList optimizes inserts/removes with linked nodes.
+ LinkedList uses doubly linked nodes for bidirectional traversal since Java 5 (Deque implementation).
+ Memory diagrams help visualize node references and linking for custom implementations.
- Avoid random access in LinkedList; prefer ArrayList for read-heavy scenarios.
! Thread-unsafety: Both ArrayList and LinkedList require synchronization (e.g., Collections.synchronizedList()) for multithreading.
```

### Expert Insight

#### Real-world Application
In production systems like e-commerce (shopping carts) or logging frameworks, use LinkedList for frequent additions/removals (e.g., undo/redo in editors) to avoid array shifting. ArrayList fits static datasets like configuration lists. For concurrent access, wrap with synchronized decorators.

#### Expert Path
Master implementation details: Study internal add/remove logic via source code (Ctrl+Shift+T in Eclipse). Practice custom linked structures to deepen understanding. Focus on Big O complexities (ArrayList O(1) access, LinkedList O(n)); benchmark with JMH for real performance insights.

#### Common Pitfalls
- Misusing LinkedList for random access: Increases time complexity unexpectedly; use profiling to detect.
- Ignoring capacity growth in ArrayList: Can cause O(n) resizes; preallocate if size known.
- Forgetting thread safety: Concurrent modifications throw exceptions; synchronize externally.
- Null handling oversights: Removing null with objects.equals() fails; override equals/hashCode properly.
- Iterator invalidation: Structural changes post-iteration cause ConcurrentModificationException; use fail-safe iterators or concurrent collections.

Lesser-known facts: LinkedList's node objects are internal; since Java 6, it's optimized for small Lists via array-like behavior, but still node-based. Parallel streams on LinkedList may not outperform ArrayList due to traversal overhead. Reflection (e.g., via Field API) can expose internal first/last references for advanced debugging.
