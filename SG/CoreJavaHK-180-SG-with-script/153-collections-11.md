# Session 153: Collections 11

## Table of Contents

- [LinkedList Operations](#LinkedList-Operations)
  - [Overview](#overview)
  - [Key Concepts/Deep Dive](#key-concepts-deep-dive)
    - [Retrieving Elements](#retrieving-elements)
    - [Searching Algorithms](#searching-algorithms)
    - [Removing Elements](#removing-elements)
    - [Inserting Elements](#inserting-elements)
    - [Replacing Elements](#replacing-elements)
    - [Sorting Elements](#sorting-elements)
- [Set Fundamentals](#set-fundamentals)
  - [Overview and Differences from List](#overview-and-differences-from-list)
  - [HashSet](#hashset)
  - [LinkedHashSet](#linkedhashset)
- [Summary](#summary)
  - [Key Takeaways](#key-takeaways)
  - [Expert Insight](#expert-insight)

## LinkedList Operations

### Overview

LinkedList is a doubly-linked list implementation in Java's collections framework. It stores elements in nodes where each node contains the data and references to the previous and next nodes. This allows for efficient insertions and deletions but sequential access for random retrieval. LinkedList is part of the Java Collections Framework from version 1.2 and extends AbstractSequentialList while implementing List, Deque, and Cloneable interfaces.

### Key Concepts/Deep Dive

LinkedList provides dynamic storage for elements where operations like adding and removing are efficient due to node linking. Unlike arrays, elements are not stored contiguously, leading to O(1) time for head and tail operations but O(n) for random access.

#### Retrieving Elements

```java
public Object get(int index) {
    // Binary search-like algorithm (divides into halves for efficiency)
    if (index < size / 2) {
        Node node = first;
        for (int i = 0; i < index; i++) {
            node = node.next;
        }
        return node.item;
    } else {
        Node node = last;
        for (int i = size - 1; i > index; i--) {
            node = node.prev;
        }
        return node.item;
    }
}
```

Retrieval uses binary search principles to decide whether to start from the head or tail, avoiding linear traversal for all cases. For performance, it minimizes traversals compared to simple sequential search.

#### Searching Algorithms

| Aspect | Linear Search | Binary Search (in LinkedList) |
|--------|---------------|-------------------------------|
| Use Case | Finding object presence (uses equals and hashcode if overridden) | Retrieving by index |
| Time Complexity | O(n) | O(n) worst case (due to no random access) |
| Advantages | Simple, handles duplicates | Optimized for large lists by choosing direction |
| Disadvantages | Slow for large lists | Not true binary search; still depends on list size |

In code:
- Linear search for containment: Iterates through nodes, using `equals()` and `==`.
- For retrieval: Pseudocode as above, but LinkedList uses a hybrid approach, dividing the list.

#### Removing Elements

```java
public boolean remove(Object o) {
    // Linear search to find node
    Node current = first;
    while (current != null) {
        if (Objects.equals(current.item, o)) {
            unlink(current);  // Adjust prev/next references
            return true;
        }
        current = current.next;
    }
    return false;
}

private void unlink(Node node) {
    Node prev = node.prev;
    Node next = node.next;
    if (prev != null) prev.next = next;
    if (next != null) next.prev = prev;
    if (node == first) first = next;
    if (node == last) last = prev;
    size--;
}
```

Unlink handles node removal by updating references, ensuring no memory leaks.

#### Inserting Elements

```java
public void add(int index, Object element) {
    // Find node at index (binary search style)
    Node nodeAtIndex = node(index);
    Node newNode = new Node(element);
    newNode.next = nodeAtIndex;
    newNode.prev = nodeAtIndex.prev;
    if (nodeAtIndex.prev != null) {
        nodeAtIndex.prev.next = newNode;
    } else {
        first = newNode;
    }
    nodeAtIndex.prev = newNode;
}
```

Insertion shifts nodes' references efficiently.

#### Replacing Elements

```java
public Object set(int index, Object element) {
    Node node = node(index);  // Get node at index
    Object old = node.item;
    node.item = element;
    return old;
}
```

Direct replacement without changing node structure.

#### Sorting Elements

```java
Collections.sort(linkedList);
// Or from Java 8+
linkedList.sort(null);  // Natural order
```

Sorting uses Collections.sort, which dumps elements into an array, sorts, and rebuilds the list. Inefficient for large lists but works.

##### Lab Demos

1. **Adding Elements and Retrieval**:
   ```java
   LinkedList<String> list = new LinkedList<>();
   list.add("A");
   list.add("B");
   System.out.println(list.get(0));  // Output: A (sequential access)
   ```

2. **Removing Specific Object**:
   ```java
   list.add("C");
   list.remove("B");
   System.out.println(list);  // Output: [A, C]
   ```

3. **Insert at Index**:
   ```java
   list.add(1, "D");
   System.out.println(list);  // Output: [A, D, C]
   ```

4. **Sorting**:
   ```java
   LinkedList<Integer> nums = new LinkedList<>(Arrays.asList(5, 1, 3));
   nums.sort(null);
   System.out.println(nums);  // Output: [1, 3, 5]
   ```

## Set Fundamentals

### Overview and Differences from List

Sets are collections that store unique elements, rejecting duplicates. Unlike lists, they do not maintain insertion order by default (except LinkedHashSet). They inherit from Collection and are ideal for membership testing and eliminating duplicates.

**Table: Key Differences Between List and Set**

| Feature | List (e.g., LinkedList) | Set (e.g., HashSet) |
|---------|--------------------------|---------------------|
| Duplicates | Allowed | Not Allowed |
| Order | Insertion or sorted | Unordered (HashSet), Insertion (LinkedHashSet) |
| Access | Indexed, random | No index, sequential only |
| Use Case | Ordered storage with duplicates | Unique elements, fast lookup |

### HashSet

HashSet implements Set using a hash table backed by HashMap. It stores elements by hashcode, not insertion order.

```java
HashSet<Object> set = new HashSet<>();
set.add("A");  // True
set.add("A");  // False (duplicate not added)
set.add(null); // True (one null allowed)
System.out.println(set);  // Output in hashcode order, e.g., [null, A, B]
```

- Synchronization: Not synchronized; use `Collections.synchronizedSet()`.
- Time Complexity: O(1) average for add/contains (amortized).
- Common Pitfall: Depends on proper hashcode/equals override for uniqueness.

### LinkedHashSet

LinkedHashSet extends HashSet, maintaining insertion order using a doubly-linked list.

```java
LinkedHashSet<String> set = new LinkedHashSet<>();
set.add("A");
set.add("B");
set.remove("A");
System.out.println(set);  // Output: [B] (in insertion order)
```

- Advantages: Predictable iteration; otherwise same as HashSet.
- Usage: When order matters without extra overhead.

## Summary

### Key Takeaways

```diff
+ LinkedList excels at head/tail operations with O(1) complexity but struggles with random access.
- Avoid using LinkedList for frequent sorting; dump to array for efficiency.
+ Sets enforce uniqueness; always override hashcode and equals for custom objects.
- HashSet may produce unexpected order due to hashing; use LinkedHashSet for predictability.
+ Sorting in LinkedList requires conversion to array; consider TreeSet for pre-sorted sets.
```

### Expert Insight

**Real-world Application**: Use LinkedList for queues/deques in event handling systems where frequent additions/removals occur. HashSet is great for caching unique user IDs in memory-heavy applications.

**Expert Path**: Master implementation details of node linking in LinkedList for optimizing custom data structures. Study HashMap internals to grasp Set behavior, including collision handling.

**Common Pitfalls**: 
- Neglecting to override equals/hashcode leads to unwanted duplicates in Sets.
- Using LinkedList for random access instead of ArrayList causes performance hits.
- Assuming HashSet maintains order; switch to LinkedHashSet if needed.
- Null pointer exceptions in removal if elements aren't found.

**Lesser Known Things**: LinkedList uses a hybrid binary search for get operations, balancing efficiency. Sets like HashSet grow at 75% load factor to minimize rehashing, unlike Lists that double capacity. 

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>

CL-KK-Terminal
