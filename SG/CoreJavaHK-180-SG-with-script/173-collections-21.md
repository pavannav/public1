# Session 173: Collections 21

**Table of Contents**
- [Cursors in Java Collections](#cursors-in-java-collections)
- [Enumeration](#enumeration)
- [Iterator](#iterator)
- [List Iterator](#list-iterator)
- [Retrieving Elements from Collections and Maps](#retrieving-elements-from-collections-and-maps)

## Cursors in Java Collections

### Overview
Cursors in Java Collections are objects used to traverse and access elements from collection objects. Java supports four types of cursors: Enumeration, Iterator, ListIterator, and Spliterator. They allow sequential retrieval of elements from collections like List, Set, and Map, with some supporting modifications during traversal. Cursors are essential for iterating over collections safely and efficiently, replacing direct index-based access.

### Key Concepts
Cursors are interfaces that define methods for checking, retrieving, and sometimes modifying elements. They differ based on direction (unidirectional or bidirectional), modification capabilities, and applicable collection types.

- **Enumeration**: Legacy cursor for retrieving elements sequentially; does not support removal.
- **Iterator**: Collections Framework cursor; supports removal with well-defined semantics.
- **ListIterator**: Sub-interface of Iterator; allows bidirectional traversal and modification for lists.
- **Spliterator**: Introduced in Java 8; supports parallel processing for advanced scenarios.

#### Comparison of Cursors
| Feature              | Enumeration          | Iterator             | ListIterator        | Spliterator         |
|----------------------|----------------------|----------------------|---------------------|---------------------|
| **Version Introduced** | Java 1.0           | Java 1.2            | Java 1.2           | Java 8             |
| **Direction**        | Forward-only        | Forward-only        | Bidirectional      | Parallel            |
| **Modification**     | No removal          | Allows removal      | Allows add/set/remove | Advanced partitioning |
| **Applicable To**    | Legacy/Collections  | All Collections     | Lists only         | All Collections    |
| **Methods**          | `hasMoreElements()`, `nextElement()` | `hasNext()`, `next()`, `remove()` | `hasNext()`, `next()`, `hasPrevious()`, `previous()`, `add()`, `set()`, `remove()` | Parallel traversal methods |

#### Memory Diagram for Cursor Movement (Enumeration Example)

```mermaid
graph TD
    A[Collection Object] --> B[Array: [a, b, c]]
    B --> C[Enumeration Cursor Points to First Element]
    C --> D[Call nextElement(): Retrieve 'a', Move Cursor]
    D --> E[Call nextElement(): Retrieve 'b', Move Cursor]
    E --> F[Call nextElement(): Retrieve 'c', Move Cursor]
    F --> G[End: Throws NoSuchElementException if called again]
```

### Lab Demos
#### Demo 1: Enumeration on ArrayList (using Collections.enumeration)
```java
import java.util.*;

public class EnumerationDemo {
    public static void main(String[] args) {
        ArrayList<String> al = new ArrayList<>();
        al.add("a");
        al.add("b");
        al.add("c");
        
        Enumeration<String> e = Collections.enumeration(al);
        while (e.hasMoreElements()) {
            System.out.println(e.nextElement());
        }
    }
}
```
**Steps**:
1. Create an ArrayList and add elements.
2. Obtain Enumeration using `Collections.enumeration(collection)`.
3. Use `hasMoreElements()` to check for elements and `nextElement()` to retrieve them.
4. Output: a, b, c.

#### Demo 2: Iterator with Removal on LinkedHashSet
```java
import java.util.*;

public class IteratorDemo {
    public static void main(String[] args) {
        LinkedHashSet<String> lhs = new LinkedHashSet<>();
        lhs.add("a");
        lhs.add("5");
        lhs.add("b");
        
        Iterator<String> it = lhs.iterator();
        while (it.hasNext()) {
            String s = it.next();
            if (s.length() > 1) {  // Remove strings longer than 1 character
                it.remove();
            }
        }
        System.out.println(lhs);  // Output: [a, b] (assuming "5" is length 1)
    }
}
```
**Steps**:
1. Create a LinkedHashSet and add strings/integers as strings.
2. Obtain Iterator.
3. Traverse with `hasNext()` and `next()`, apply condition for removal.
4. Use `it.remove()` to safely remove during iteration.

#### Demo 3: ListIterator with Add and Set on ArrayList
```java
import java.util.*;

public class ListIteratorDemo {
    public static void main(String[] args) {
        ArrayList<Object> al = new ArrayList<>();
        al.add("a");
        al.add(5);
        al.add("b");
        
        ListIterator<Object> lit = al.listIterator();
        while (lit.hasNext()) {
            Object obj = lit.next();
            if (obj instanceof String) {
                lit.set(((String) obj).toUpperCase());  // Replace with uppercase
            } else if (obj instanceof Integer) {
                lit.add(20);  // Add 20 after integer
            }
        }
        // Backward traversal
        while (lit.hasPrevious()) {
            System.out.println(lit.previous());
        }
    }
}
```
**Steps**:
1. Create ArrayList with mixed types.
2. Obtain ListIterator.
3. Forward traverse: Use `set()` for replacement, `add()` for insertion.
4. Backward traverse: Use `hasPrevious()` and `previous()` to print.

#### Retrieving Elements from Maps: KeySet, Values, EntrySet
- **KeySet**: Get all keys as Set, iterate with Iterator.
- **Values**: Get all values as Collection, iterate with Iterator.
- **EntrySet**: Get key-value pairs as Set<Map.Entry>, iterate to access key and value.

**Code Snippet**:
```java
LinkedHashMap<Object, Object> lhm = new LinkedHashMap<>();
lhm.put("a", 1);
lhm.put("b", 2);

// Via KeySet
Set<Object> keys = lhm.keySet();
Iterator<Object> kit = keys.iterator();
while (kit.hasNext()) {
    Object key = kit.next();
    Object value = lhm.get(key);
    System.out.println(key + "=" + value);
}

// Via Values
Collection<Object> values = lhm.values();
Iterator<Object> vit = values.iterator();
while (vit.hasNext()) {
    System.out.println(vit.next());
}

// Via EntrySet
Set<Map.Entry<Object, Object>> entries = lhm.entrySet();
Iterator<Map.Entry<Object, Object>> eit = entries.iterator();
while (eit.hasNext()) {
    Map.Entry<Object, Object> entry = eit.next();
    System.out.println(entry.getKey() + "=" + entry.getValue());
}
```
**Output**: Keys/Values iterate similarly; EntrySet accesses both.

> [!IMPORTANT]  
> Cursors are factory-created via methods like `Collections.enumeration()`, `collection.iterator()`, etc. Always check for elements before retrieval to avoid exceptions.

## Summary Section

### Key Takeaways
```diff
+ Cursors enable safe traversal of collections without direct index manipulation.
+ Enumeration is legacy; prefer Iterator for modern code.
+ Iterator is fail-fast; ListIterator adds bidirectional features.
+ For Maps, convert to Set/Collection views before applying cursors.
+ Rules matter: Call `next()` before `remove() set()/add()`; avoid concurrent modifications.
- Avoid Enumeration in new projects; use Iterator or ListIterator.
- Misusing `next()` on empty collections throws NoSuchElementException.
! Always use generics for type safety and avoid ClassCastException.
```

### Expert Insight

#### Real-world Application
In large-scale applications like e-commerce (e.g., inventory management), cursors iterate over product lists (stored in ArrayLists or HashMaps) for searching, filtering, or bulk updates. ListIterator is used in text editors for undo/redo features by moving bi-directionally through edit histories.

#### Expert Path
Master Collection hierarchies and Factory patterns for obtaining cursors. Study parallel processing with Spliterator in concurrent Java apps. Practice refactoring legacy code to use Iterators for better performance and safety. Explore advanced iterators in libraries like Guava.

#### Common Pitfalls
- **ConcurrentModificationException**: Modifying collection (add/remove) during iteration with Iterator. Solution: Use fail-safe alternatives or collect changes separately.
- **IllegalStateException**: Calling `remove()` without prior `next()`. Solution: Always call `next()` first.
- **ClassCastException**: Retrieving heterogeneous elements without instanceof checks. Solution: Use generics and type-safe casts.
- **NoSuchElementException**: Calling `next()` on empty or exhausted cursor. Solution: Always precede with `hasNext()`/ `hasMoreElements()`.

#### Lesser Known Things About Cursors
- Enumeration internally uses Iterator in modern implementations, making it fail-fast under Collections.enum().
- Spliterator is rarely used directly but powers Stream APIs for high-performance parallel operations.
- Cursors like ListIterator maintain "cursor position" between elements, enabling precise insertions via `add()`.
- In Java 14+, `instanceof` with pattern matching simplifies type checks in demo loops, reducing boilerplate code.
