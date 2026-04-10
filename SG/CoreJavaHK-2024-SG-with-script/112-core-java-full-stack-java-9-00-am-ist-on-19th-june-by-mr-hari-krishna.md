# Session 112: Core Java Collections - LinkedList, Stack, and Sets

## Table of Contents

- [LinkedList vs. ArrayList](#LinkedList-vs-ArrayList)
- [LinkedList Internals](#LinkedList-Internals)
- [Stack Concept and Implementation](#Stack-Concept-and-Implementation)
- [Set Interfaces Introduction](#Set-Interfaces-Introduction)
- [HashSet](#HashSet)
- [LinkedHashSet](#LinkedHashSet)
- [TreeSet and Sorting](#TreeSet-and-Sorting)
- [Comparable and Comparator Interfaces](#Comparable-and-Comparator-Interfaces)

## LinkedList vs. ArrayList

### Overview
LinkedList is a collection in Java available from version 1.2, implementing the List interface. It is chosen for storing multiple objects in a single-threaded model without thread safety, in insertion order, with index access for performance-critical insert and remove operations at the beginning or middle of the collection.

### Key Concepts/Deep Dive
- **Key Differences**: ArrayList excels at add and retrieve operations due to its array-based structure. LinkedList is superior for insert and remove operations, especially at the beginning and middle.
- **Implementation Details**:
  - ArrayList: Resizable array, synchronized via Vector (though inefficient).
  - LinkedList: Synchronized, maintains insertion order, allows random or sequential retrieval, but random access is implicitly sequential from the start.
- **Performance**: LinkedList uses node objects internally, allowing dynamic capacity without capacity parameters. Default capacity is zero, expanding as elements are added (1:1 ratio).

### Lab Demo: LinkedList vs. ArrayList Code Comparison
To demonstrate no change in code structure:

1. **Create LinkedList Object**:
   ```java
   import java.util.LinkedList;

   public class LinkedListExample {
       public static void main(String[] args) {
           LinkedList<String> ll = new LinkedList<>();
           // Add elements in insertion order
           ll.add("Zero");
           ll.add("One");
           ll.add("Two");
           // Print size and elements
           System.out.println("Size: " + ll.size());
           for (String element : ll) {
               System.out.println(element);
           }
       }
   }
   ```
   - **Expected Output**: Size and elements like ArrayList (insertion order).

2. **Run the Program**: Compile and execute.
   - `javac LinkedListExample.java`
   - `java LinkedListExample`

This shows identical behavior to ArrayList despite internal differences.

## LinkedList Internals

### Overview
LinkedList internally uses Node objects to create a doubly linked list structure (from Java 5 onwards), enabling the deque (DQ) implementation. Unlike arrays, it grows incrementally without predefined capacity.

### Key Concepts/Deep Dive
- **Data Structure**: Collection of node objects, each linking to previous and next (double linking). Up to Java 1.4: single link list; from Java 5: doubly linked for DQ support.
- **Node Structure**: Each node has three references:
  - `previous`: Link to previous node.
  - `item`: Holds the object.
  - `next`: Link to next node.
- **Memory Diagram**:
  ```
  First Node: previous -> null, item -> Object1, next -> Second Node
  Second Node: previous -> First Node, item -> Object2, next -> Third Node
  Last Node: previous -> Second Node, item -> Object3, next -> null
  ```
- **Constructors**: Two (like Vector's four vs. ArrayList's one): No capacity specification.
- **Add Method Logic**:
  1. Create new Node and initialize with item.
  2. Link new Node's `next` to `last.next`.
  3. Set `last` reference to new Node.
  4. Update size.

### Code/Config Blocks
```java
// Sample add method scenario
LinkedList ll = new LinkedList();
ll.add("A");  // Creates first node: first -> node1, last -> node1
ll.add("B");  // Links node1.next to node2, node2.previous to node1, last -> node2
```

### Lab Demo: LinkedList Add and Get Operations
1. **Create LinkedList and Add Elements**:
   ```java
   LinkedList<String> ll = new LinkedList<>();
   ll.add("A");
   ll.add("B");
   ll.add("C");
   System.out.println("Size: " + ll.size());  // Output: 3
   ```

2. **Retrieve Elements**:
   ```java
   System.out.println(ll.get(0));  // Output: A
   System.out.println(ll.get(1));  // Output: B
   // Loop through elements
   for (int i = 0; i < ll.size(); i++) {
       System.out.println(ll.get(i));
   }
   ```

3. **Why No Index in LinkedList**: Get method traverses sequentially from first node, even for random access indices.

### Lab Demo: Memory Internals Walkthrough
Visualize the node chaining:
- Start with empty LinkedList: `first = null`, `last = null`, size = 3 variables.
- After `add("A")`: First node created, `first -> nodeA`, `last -> nodeA`, size = 3.
- After `add("B")`: New nodeB, nodeA.next -> nodeB, nodeB.previous -> nodeA, `last -> nodeB`.

> [!NOTE]
> Draw the memory diagram manually to understand linking.

## Stack Concept and Implementation

### Overview
Stack is a last-in, first-out (LIFO) data structure for storing and retrieving objects one on top of another. In Java, it's a subclass of Vector, using arrays internally but enforcing LIFO access.

### Key Concepts/Deep Dive
- **Real-World Analogy**: Like stacking rice bags, where you add to the top and remove from the top.
- **Operations**:
  - **Push**: Add to top.
  - **Pop**: Remove and return top (retrieve, remove, return).
  - **Peek**: Retrieve top without removal.
- **Implementation**: Extends Vector, so synchronized. Push calls `addElement`, Pop retrieves size-1 index and removes.
- **Terminology**: LIFO in retrieving order, but insertion order in storage.

> [!IMPORTANT]
> > Conceptual "stack" vs. actual array storage: Push/pop manipulate the end index.

### Code/Config Blocks
```java
import java.util.Stack;

Stack<String> stack = new Stack<>();
stack.push("F");
stack.push("E");
// Pop twice
System.out.println(stack.pop());  // E
System.out.println(stack.pop());  // F
```

### Lab Demo: Stack Operations
1. **Create Stack and Push Elements**:
   ```java
   Stack<String> s = new Stack<>();
   s.push("A");
   s.push("B");
   s.push("C");
   System.out.println(s);  // [A, B, C]
   ```

2. **Pop Elements**:
   ```java
   System.out.println(s.pop());  // C
   System.out.println(s.pop());  // B
   ```

3. **Peek**:
   ```java
   System.out.println(s.peek());  // A (still top)
   ```

4. **Loop Pop**:
   ```java
   while (!s.isEmpty()) {
       System.out.println(s.pop());
   }
   ```

Expected Behavior: LIFO retrieval.

### Diagrams
```mermaid
graph TD
    A[Empty Stack] --> B[Push A]
    B --> C[Push B on A]
    C --> D[Pop B (returns B, removes)]
    D --> E[Pop A (returns A)]
```

## Set Interfaces Introduction

### Overview
Sets store unique objects, inheriting from Collection. Implements List but focuses on uniqueness over order/index.

### Key Concepts/Deep Dive
- **Types**: HashSet, LinkedHashSet, TreeSet. All prevent duplicates.
- **No Index**: Sets do not maintain order or index; retrieval via for-each or iterators.

## HashSet

### Overview
HashSet stores unique objects in hash code order, available from Java 1.2.

### Key Concepts/Deep Dive
- **Duplicates Prevention**: Uses `hashCode()` and `equals()` methods.
- **Capacity**: Default 16, load factor 0.75.
- **Heterogeneous Objects**: Allowed.

### Lab Demo: HashSet Operations
1. **Create HashSet**:
   ```java
   import java.util.HashSet;

   HashSet<String> hs = new HashSet<>();
   hs.add("A");
   hs.add("B");
   hs.add("A");  // Duplicate, not added
   System.out.println(hs);  // [A, B] in hash order
   ```

2. **Add More Elements**:
   ```java
   hs.add("5");
   hs.add(6.7);
   hs.add(true);
   hs.add(null);
   hs.add(98);
   System.out.println(hs);  // Hash order
   ```

3. **Duplicate Check**: Adding same object reference twice is ignored.

## LinkedHashSet

### Overview
LinkedHashSet stores unique objects in insertion order, maintains order unlike HashSet.

### Key Concepts/Deep Dive
- **Order**: Insertion order preserved for iteration.
- **Internals**: Combines HashSet and LinkedList features.

### Lab Demo: LinkedHashSet Operations
1. **Create LinkedHashSet**:
   ```java
   import java.util.LinkedHashSet;

   LinkedHashSet<String> lhs = new LinkedHashSet<>();
   lhs.add("A");
   lhs.add("B");
   lhs.add("5");
   System.out.println(lhs);  // [A, B, 5] insertion order
   ```

2. **Duplicates**: Add "B" again; size remains same.

## TreeSet and Sorting

### Overview
TreeSet stores unique objects in sorting (ascending/descending) order. Requires comparable objects.

### Key Concepts/Deep Dive
- **Sorting**: Ascending by default; homogeneous objects only.
- **Exceptions**: ClassCastException for heterogeneous, NullPointerException for nulls, unless comparator provided.

### Lab Demo: TreeSet Operations
1. **Create TreeSet with Strings**:
   ```java
   import java.util.TreeSet;

   TreeSet<String> ts = new TreeSet<>();
   ts.add("B");
   ts.add("A");
   ts.add("C");
   System.out.println(ts);  // [A, B, C] sorted
   ```

2. **With Integers**:
   ```java
   TreeSet<Integer> tsInt = new TreeSet<>();
   tsInt.add(7);
   tsInt.add(6);
   tsInt.add(5);
   System.out.println(tsInt);  // [5, 6, 7]
   ```

3. **Custom Objects**: Throws exception unless Comparable.

### Tables
| Feature          | HashSet                   | LinkedHashSet             | TreeSet                   |
|------------------|---------------------------|---------------------------|---------------------------|
| Order            | Hash code order           | Insertion order           | Sorting order             |
| Duplicates       | Not allowed               | Not allowed               | Not allowed               |
| Null             | Allowed                   | Allowed                   | Not allowed (NPE)         |
| Heterogeneous    | Allowed                   | Allowed                   | Not allowed (CCE)         |

## Comparable and Comparator Interfaces

### Overview
To sort custom objects, implement Comparable for natural order or use Comparator for custom order.

### Key Concepts/Deep Dive
- **Comparable**: Interface with `compareTo(Object o) int`. Returns negative/zero/positive for sorting.
- **Comparator**: Functional interface for external comparison logic (e.g., via lambda).

### Code/Config Blocks
```java
class Example implements Comparable<Example> {
    int x;
    
    @Override
    public int compareTo(Example e) {
        return this.x - e.x;  // Ascending on x
    }
}
```

```java
TreeSet<Example> ts = new TreeSet<>((e1, e2) -> e2.x - e1.x);  // Descending
```

### Lab Demo: TreeSet with Comparable and Comparator
1. **Implement Comparable**:
   ```java
   class Example implements Comparable<Example> {
       int x, y;
       
       public Example(int x, int y) { this.x = x; this.y = y; }
       
       @Override
       public int compareTo(Example e) {
           return this.x - e.x;
       }
       
       public String toString() { return "Ex(" + x + "," + y + ")"; }
   }
   ```

2. **Use Default Sorting**:
   ```java
   TreeSet<Example> ts = new TreeSet<>();
   ts.add(new Example(5, 3));
   ts.add(new Example(7, 2));
   System.out.println(ts);  // [Ex(5,3), Ex(7,2)]
   ```

3. **With Comparator**:
   ```java
   TreeSet<Example> tsDesc = new TreeSet<>((e1, e2) -> e2.x - e1.x);
   tsDesc.add(new Example(5, 3));
   tsDesc.add(new Example(7, 2));
   System.out.println(tsDesc);  // [Ex(7,2), Ex(5,3)]
   ```

## Summary

### Key Takeaways
```diff
+ ArrayList: Best for add/retrieve, array-based.
- LinkedList: Sequential access, slower than ArrayList for retrieval.
+ LinkedList: Better for insert/remove at start/middle, node-based.
+ Stack: LIFO using Vector internally, push/pop/peek operations.
+ Sets: Unique elements; HashSet (hash order), LinkedHashSet (insertion), TreeSet (sorted).
+ TreeSet: Requires Comparable or Comparator; no nulls/heterogenics without custom logic.
- Common Pitfalls: TreeSet throws exceptions for non-comparable objects or heterogeneous types.
```

### Expert Insight

**Real-world Application**: Use LinkedList for frequent insertions/deletions (e.g., queues), Stack for undo/redo (e.g., browser back button), TreeSet/HashSet for unique collections (e.g., user IDs without duplicates). LinkedHashSet preserves order for caches.

**Expert Path**: Master memory diagrams by drawing internals; learn hash codes for custom classes (override `hashCode` and `equals`). Practice Comparator lambdas for flexible sorting. Explore HashMap (up next) for key-value mappings relying on HashSet principles.

**Common Pitfalls**: 
- Assuming LinkedList has random access (it's sequential internally).
- Storing non-comparable in TreeSet without Comparator (leads to ClassCastException).
- Nulls in TreeSet (NullPointerException unless handled).
- Duplicate prevention in custom classes requires proper `equals`/`hashCode` overrides.
- Lesser known: LinkedList implements Deque; TreeSet uses red-black trees internally; Stack is thread-safe but inefficient.

Corrections made: "array list" corrected to "ArrayList", "link list" to "LinkedList", "has set" to "HashSet", "et set" implied "TreeSet", "hashbord order" to "hash code order", "comparative" to "Comparator", "et reset" to "TreeSet". No other obvious misspellings like "htp" or "cubectl".
