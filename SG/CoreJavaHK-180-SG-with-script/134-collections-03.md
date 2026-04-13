# Session 134: Collections 03

## Table of Contents
- [Introduction to Collections](#introduction-to-collections)
- [Array Problems and Alternatives](#array-problems-and-alternatives)
- [Storing Objects in Array Format Without Mappings](#storing-objects-in-array-format-without-mappings)
- [Storing Objects in Table Format with Mappings](#storing-objects-in-table-format-with-mappings)
- [Subtypes of Collections for Unique Objects, Duplicates, and Retrieval Orders](#subtypes-of-collections-for-unique-objects-duplicates-and-retrieval-orders)
- [Possible Orders for Storing Unique Objects in Sets](#possible-orders-for-storing-unique-objects-in-sets)
- [Set Implementation Classes](#set-implementation-classes)
- [Overview of Collection Hierarchy](#overview-of-collection-hierarchy)
- [List Subtypes for Duplicates with Different Orders](#list-subtypes-for-duplicates-with-different-orders)
- [Queue and Deque Subtypes](#queue-and-deque-subtypes)
- [Map Hierarchy for Table Format](#map-hierarchy-for-table-format)
- [Map Implementation Classes](#map-implementation-classes)
- [Collections Framework Hierarchy Explanation](#collections-framework-hierarchy-explanation)
- [Summary](#summary)

## Introduction to Collections

Collections in Java serve as an alternative to object arrays for storing multiple objects as a group. Sun Microsystems introduced the Collections API to address limitations of arrays while maintaining the underlying object array structure. Collections handle common operations without requiring developers to remember specific class names or manually implement methods for each project.

## Array Problems and Alternatives

Arrays have five primary problems that Collections aim to solve:

1. **Type Problem**: Arrays require specifying object types, limiting flexibility for heterogeneous storage.
2. **Size Problem**: Arrays have fixed sizes, requiring manual resizing logic.
3. **Inbuilt Operations Problem**: Arrays lack built-in methods for common operations like insertion or deletion.
4. **Format Problem**: Arrays store data in a single linear format.
5. **Order Problem**: Arrays don't provide easy ways to maintain different ordering (insertion, sorting, retrieval).

While Collections primarily address the last four problems (size, operations, format, order), using object arrays can solve the type problem independently. Collections came to provide reusable solutions for the common four problems across projects, eliminating the need for custom class creation and method memorization.

## Storing Objects in Array Format Without Mappings

To store objects in array format without index-based mappings (i.e., without explicit key-value associations), use **Collections**. This allows storing objects in a linear structure similar to arrays but with enhanced flexibility.

Example: Storing student information like ID (7279), name ("Har"), institute ("NIT"), and course ("Java") without mappings makes interpretation ambiguous to external users.

## Storing Objects in Table Format with Mappings

To store objects in table format with mappings (key-value pairs), use **Maps**. Keys act as meaningful identifiers (e.g., employee variables like "eno", "ename", "institute"), while values represent the actual data.

Example: Using keys like "Employee Number" (7279), "Employee Name" ("Har"), "Institute" ("NIT") provides clear, interpretable data.

## Subtypes of Collections for Unique Objects, Duplicates, and Retrieval Orders

Collections divide into three main subtypes based on storage and retrieval requirements for array format:

1. **Set**: For storing only unique objects.
2. **List**: For storing objects including duplicates, with index-based access.
3. **Queue**: For storing and retrieving objects in FIFO (First In, First Out) or LIFO (Last In, First Out) order.

Additionally:
- **SortedSet** and **NavigableSet** extend Set for sorting orders.
- **Deque** extends Queue for bidirectional access (both ends).

## Possible Orders for Storing Unique Objects in Sets

Sets support various orders for unique objects:
- Without worrying about insertion order (faster execution).
- Maintaining insertion order.
- Sorting order.
- Only enum named constants.

## Set Implementation Classes

To represent different orders in Sets, use these classes:
- **HashSet**: Stores unique objects without maintaining insertion order.
- **LinkedHashSet**: Stores unique objects while maintaining insertion order.
- **TreeSet**: Stores unique objects in sorted order.
- **EnumSet**: Stores unique enum named constants.

## Overview of Collection Hierarchy

Collections framework follows a hierarchical structure starting from **Collection<E>** (generic interface), divided into:

1. **Set<E>**: For unique objects.
   - Subtypes: SortedSet<E>, NavigableSet<E>.
2. **List<E>**: For objects with duplicates.
3. **Queue<E>**: For ordered retrieval.
   - Subtype: Deque<E> (bidirectional).

All above are interfaces, with concrete implementations providing the actual functionality.

## List Subtypes for Duplicates with Different Orders

For storing objects including duplicates (addressing real-world scenarios like bulk storage):

- **Vector**: Thread-safe storage.
- **ArrayList**: Non-thread-safe storage.
- **LinkedList**: Must retrieve sequentially.
- **Stack**: Must retrieve in LIFO (Last In, First Out) order.

## Queue and Deque Subtypes

Queues support storage and retrieval from specific ends:

- **Queue**: Single-ended (one direction).
  - **PriorityQueue**: Stores based on priority (e.g., FIFO from beginning).
- **Deque**: Double-ended (both directions).
  - **ArrayDeque**: Allows FIFO or LIFO from both ends.

> [!NOTE]
> Queues initially supported two-way access, evolving to three-way with Deque.

## Map Hierarchy for Table Format

Maps store data in key-value pairs (entries), similar to disciplined arrays:

- **SortedMap** and **NavigableMap** for sorted entries.
- Stores entries in orders like hash code, insertion, sorting, enum constants, weak references, identity hash code, thread safety, or permanently (e.g., properties files).

## Map Implementation Classes

Map implementations include:
- **HashMap**: Stores entries in hash code order.
- **LinkedHashMap**: Maintains insertion order.
- **TreeMap**: Sorts entries.
- **EnumMap**: For enum constants.
- **WeakHashMap**: Uses weak references.
- **IdentityHashMap**: Uses identity hash code.
- **Hashtable**: Thread-safe (note: lowercase 't').
- **Properties**: For permanent storage in files.

## Collections Framework Hierarchy Explanation

Collections framework uses two main hierarchies:

1. **Collection Hierarchy**:
   - Interfaces: Collection<E> → Set<E> (SortedSet<E>, NavigableSet<E>) → List<E> → Queue<E> (Deque<E>).
   - Abstract classes: AbstractCollection<E>, AbstractSet<E>, AbstractList<E>, AbstractSequentialList<E>, AbstractQueue<E>.
   - Concrete classes inherit common implementations from abstract classes (e.g., HashSet extends AbstractSet; ArrayList extends AbstractList; LinkedList implements List and Deque).

2. **Map Hierarchy**: Separate hierarchy for key-value entries (details for tomorrow).

This hierarchy exemplifies OOP concepts: inheritance, polymorphism, and abstraction. Common operations are centralized in abstract classes to avoid code duplication.

> [!IMPORTANT]
> Learn class names and purposes: Without memorizing HashSet, LinkedHashSet, TreeSet, EnumSet, Vector, ArrayList, LinkedList, Stack, PriorityQueue, ArrayDeque, HashMap, LinkedHashMap, TreeMap, EnumMap, WeakHashMap, IdentityHashMap, Hashtable, Properties — you cannot write effective code.

## Summary

### Key Takeaways
```diff
+ Collections solve array limitations in size, inbuilt operations, format, and order for storing multiple objects efficiently.
+ Objects store in array format (without mappings) via Collection or table format (with mappings) via Map.
+ Set: Unique objects; List: Duplicates with indices; Queue/Deque: Ordered retrieval.
+ Set classes: HashSet, LinkedHashSet, TreeSet, EnumSet.
+ List classes: Vector (thread-safe), ArrayList (non-thread-safe), LinkedList (sequential), Stack (LIFO).
+ Queue classes: PriorityQueue, ArrayDeque.
+ Map classes: HashMap, LinkedHashMap, TreeMap, EnumMap, WeakHashMap, IdentityHashMap, Hashtable, Properties.
+ Hierarchy prevents code duplication by centralizing operations in abstract classes.
```

### Expert Insight
**Real-world Application**: Use HashMap for fast lookups in caching systems, LinkedHashMap for LRU caches, TreeMap for ordered key access in databases, and ArrayList for dynamic lists in applications like e-commerce item lists. In production, prefer ArrayList over Vector for performance unless thread safety is critical, and use Deque (e.g., ArrayDeque) for task scheduling queues in concurrent systems.

**Expert Path**: Master the hierarchy by implementing custom collections (as taught in sessions 12-15). Focus on choosing the right class based on thread safety, ordering, and performance needs. Profile with JMH to understand real-world overhead differences between HashSet and TreeSet for large datasets.

**Common Pitfalls**: 
- Mistaking HashSet for insertion order preservation — use LinkedHashSet if order matters.
- Using Vector Instead of ArrayList for single-threaded apps, incurring unnecessary synchronization overhead.
- Forgetting that Queue supports both FIFO/LIFO but Deque allows bidirectional access.
- Misusing HashMap keys without proper hashCode()/equals() overrides, leading to unexpected behavior.
- Ignoring Collections.unmodifiableList() for read-only views to prevent accidental mutations.

**Lesser Known Things**: Collections implement via object arrays internally; Java 8+ Streams vastly improve operations on collections; EnumSet is highly efficient for enum-based flags; WeakHashMap helps in memory-sensitive cache with automatic cleanup when keys are no longer referenced elsewhere.
