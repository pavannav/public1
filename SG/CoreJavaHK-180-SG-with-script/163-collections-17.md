# Session 163: Collections 17

## Table of Contents
- [Developing HashMap Operations Test Program](#developing-hashmap-operations-test-program)
- [Introducing TreeSet and TreeMap](#introducing-treeset-and-treemap)
- [Working with TreeSet](#working-with-treeset)
- [Comparable Interface Implementation](#comparable-interface-implementation)
- [Comparator Interface for Custom Sorting](#comparator-interface-for-custom-sorting)
- [Requirements for Storing Custom Objects in Collections](#requirements-for-storing-custom-objects-in-collections)
- [Summary](#summary)

## Developing HashMap Operations Test Program

### Overview
In this lecture, we concluded our exploration of HashMap internals by developing a comprehensive program to perform all essential operations on a LinkedHashMap. This hands-on example builds upon prior understanding of LinkedList and ArrayList operations, now applied to the Map interface. HashMap allows storing key-value pairs, unlike earlier collections that only held values. The goal is to master operations such as checking emptiness, retrieving size, displaying elements, adding entries, searching, retrieving values, removing entries, and replacing values.

### Key Concepts/Deep Dive
#### HashMap Operations Overview
HashMap implements the Map interface and uses hashing for efficient storage and retrieval. Unlike List implementations, HashMap stores entries as key-value pairs, enabling fast lookups based on keys rather than indices.

- **Empty Check (`isEmpty()`)**: Verifies if the HashMap contains no entries. Used in methods like `Map<String, String> processMap(Map<String, String> map)` to conditionally handle emptiness.
- **Size Retrieval (`size()`)**: Returns the number of entries. Essential for operations that depend on the map's population, such as iterating or applying logic based on map size.
- **Displaying Entries**: LinkedHashMap displays entries in insertion order using the `toString()` method, which implicitly calls `key.toString()` and `value.toString()` on each entry.
- **Adding Entries (`put()`)**: Inserts key-value pairs. If the key exists, it replaces the old value and returns it; otherwise, returns null. Supports heterogeneous keys and values.
- **Searching Keys (`containsKey()`)**: Checks for key presence using hash code and equality comparisons.
- **Searching Values (`containsValue()`)**: Verifies value presence by iterating through all entries (linear search), unlike `containsKey()` which is hash-based.
- **Retrieving Values (`get()`)**: Fetches the value for a given key. Returns null if the key is not found. Includes `getOrDefault()` for custom null-handling.
- **Removing Entries (`remove()`)**: Removes key-value pairs. Single-argument version removes by key; two-argument version removes only if both key and value match.
- **Replacing Values (`replace()`)**: Updates values for existing keys. Includes overloaded methods for conditional replacement.

#### Hash-Based Algorithm Mechanics
The internal algorithm for key-based operations (e.g., `put`, `containsKey`, `get`, `remove`) involves:
1. Compute hash code from the key.
2. Generate bucket index using `(hash ^ (hash >>> 16)) & (capacity - 1)`.
3. If bucket exists and matches via `==` or `equals()`, proceed with operation.
4. Linking nodes in buckets forms a mini-LinkedList due to potential collisions.

### Code/Config Blocks

#### Class Definition for HashMap Operations Test
```java
public class HashMapOperationsTest {
    public static void main(String[] args) {
        LinkedHashMap<Object, Object> lhm = new LinkedHashMap<>();
        
        // Operation 1: Check if empty
        System.out.println(lhm.isEmpty());  // true
        
        // Operation 2: Get size
        System.out.println(lhm.size());  // 0
        
        // Operation 3: Display map
        System.out.println(lhm);  // {}
        
        // Operation 4-6: Add entries (put method)
        lhm.put("key1", 1);  // Returns null, stores entry
        
        // Search key (containsKey)
        System.out.println(lhm.containsKey("key1"));  // true
        
        // Search value (containsValue)
        System.out.println(lhm.containsValue(1));  // true
        
        // Retrieve value (get)
        System.out.println(lhm.get("key1"));  // 1
        
        // Remove entry
        lhm.remove("key1");  // Removes and returns 1
        
        // Replace value (replace)
        lhm.put("key2", 2);  // Add first
        lhm.replace("key2", 3);  // Replace with 3
    }
}
```

#### Custom Class with Override (hashCode and equals)
To store custom objects as keys, override hashCode and equals methods. In this example, a `B` class with x and y properties:
```java
class B {
    private int x, y;
    public B(int x, int y) {
        this.x = x;
        this.y = y;
    }
    
    @Override
    public int hashCode() {
        return x + y;  // Example implementation
    }
    
    @Override
    public boolean equals(Object obj) {
        if (obj instanceof B other) {
            return this.x == other.x && this.y == other.y;
        }
        return false;
    }
    
    @Override
    public String toString() {
        return "B{x=" + x + ", y=" + y + "}";
    }
}
```

### Tables
| Operation | Method | Parameters | Return Value | Duplicates Handling |
|-----------|--------|------------|--------------|-------------------|
| Add/Replace | put(key, value) | Object key, Object value | Old value or null | Stores new; replaces if key exists |
| Search Key | containsKey(key) | Object key | boolean | N/A |
| Search Value | containsValue(value) | Object value | boolean | N/A |
| Retrieve | get(key)<br>getOrDefault(key, defaultValue) | Object key<br>Object key, Object default | Value or null<br>Value or default | N/A |
| Remove | remove(key)<br>remove(key, value) | Object key<br>Object key, Object value | Removed value or null | Removes if exists |
| Replace | replace(key, value)<br>replace(key, oldValue, newValue) | Object key, Object value<br>Object key, Object oldValue, Object newValue | Old value or null<br>boolean (true if replaced) | Replaces only if matches |

### Lab Demos
1. **Create LinkedHashMap and Add Entries**: Declare `LinkedHashMap<Object, Object> lhm = new LinkedHashMap<>();` and use `lhm.put("a", 1);` for heterogeneous data.
2. **Perform All Operations in Sequence**: Run `isEmpty()`, `size()`, display via `println(lhm)`, add entries, search with `containsKey("a")` and `containsValue(1)`, retrieve with `get("a")`, remove with `remove("a")`, replace with `replace("b", newValue)`.
3. **Override Methods for Custom Class**: In class B, override `hashCode()` returning `this.x + this.y`, `equals()` checking `obj instanceof B && this.x == ((B)obj).x && this.y == ((B)obj).y`.
4. **Test Duplicates**: Attempt `lhm.put(new B(5,6), 1); lhm.put(new B(5,6), 2);` and verify hashCode equals prevent duplicates.
5. **Predicates for Removal/Replace**: Use `remove("key", "exactlyThisValue")` to remove only if value matches; `replace("key", "oldValue", "newValue")` for conditional replacement.
6. **Display at Each Step**: Print the map after each operation using `System.out.println(lhm);` to visualize changes.

## Introducing TreeSet and TreeMap
### Overview
Transitioning from HashMap, we introduce TreeSet and TreeMap as sorted collections in the Java Collections Framework. Both are implementations of NavigableSet and NavigableMap, respectively, using red-black tree algorithms for balanced binary search trees. Unlike HashMap, TreeMap and TreeSet automatically sort elements upon insertion, ensuring ordered storage. TreeSet stores unique elements, while TreeMap stores key-value pairs with sorted keys. These are ideal for scenarios requiring natural or custom sorting orders.

### Key Concepts
- **Natural Sorting**: Driven by Comparable interface implemented in the stored object class.
- **Custom Sorting**: Handled via Comparator interface with separate comparator class.
- **Homogeneous Elements**: Required for comparison; heterogeneous elements cause ClassCastException.
- **Null Handling**: Neither TreeSet nor TreeMap allows null keys or values, leading to NullPointerException if attempted.
- **Duplicate Handling**: Controlled by natural/custom order logic; returns 0 from compareTo() to prevent duplicates.

### Code/Config Blocks
```java
TreeSet<String> ts = new TreeSet<>();  // Defaults to String's natural ascending order
ts.add("a"); ts.add("c"); ts.add("b");  // {"a","b","c"}
TreeMap<Integer, String> tm = new TreeMap<>();  // Keys: Integers (ascending)
tm.put(3, "three"); tm.put(1, "one");  // {1="one", 3="three"}
```

## Working with TreeSet
### Overview
TreeSet is a navigable set implementation based on a tree structure, ensuring elements are stored in sorted order. It does not allow duplicates and uses Comparable or Comparator for sorting.

### Key Concepts/Deep Dive
- Store elements using natural ordering by implementing Comparable.
- For custom order, pass Comparator instance to constructor.
- Operations like add, remove, search use tree traversal for O(log n) performance.
- Heterogeneous or non-comparable objects trigger ClassCastException.
- Null operations cause NullPointerException.

### Lab Demos
1. Create TreeSet: `TreeSet<String> ts = new TreeSet<>(); ts.add("a"); ts.add("b"); System.out.println(ts);` outputs `["a","b"]`.
2. Add Elements: Continue adding "c", "b" (duplicate ignored), display balance.
3. Remove: `ts.remove("b");` removes and rebalances tree.

## Comparable Interface Implementation
### Overview
To store custom objects (e.g., class B with x, y) in TreeSet/TreeMap, implement Comparable for natural sorting.

### Key Concepts/Deep Dive
- Implement Comparable\<T> in class B.
- Override compareTo while comparing selected property (e.g., x).
- Return negative (current < other), zero (equal), positive (current > other).
- Affects TreeSet add/remove/search operations.

### Code/Config Blocks
```java
class B implements Comparable<B> {
    private int x, y;
    public B(int x, int y) { this.x = x; this.y = y; }
    public int compareTo(B other) { return this.x - other.x; }  // Sort by x ascending
}
TreeSet<B> ts = new TreeSet<>();
ts.add(new B(5,1)); ts.add(new B(3,2));  // Sorted by x
```

## Comparator Interface for Custom Sorting
### Overview
Comparator enables multiple sorting orders for the same class without modifying it, ideal for flexible sorting in Tree-based collections.

### Key Concepts/Deep Dive
- Create separate comparator classes implementing Comparator.
- Logic: return negative/left, zero/duplicate, positive/right.
- Pass comparator to TreeSet/TreeMap constructor.
- Supports multiple comparators for different orders (e.g., x descending, y ascending).

### Code/Config Blocks
```java
class BXDescendingComparator implements Comparator<B> {
    public int compare(B b1, B b2) { return b2.getX() - b1.getX(); }  // Descending x
}
TreeSet<B> ts = new TreeSet<>(new BXDescendingComparator());
```

### Lab Demos
1. Create Comparator: Implement Comparator for B class x descending.
2. Instantiate TreeSet: `TreeSet<B> ts = new TreeSet<>(new BXDescendingComparator());`
3. Add Objects: Add B(5,1), B(7,2); display sorted descending by x.

### Tables
| Interface | Inheritance | Method | Purpose |
|-----------|-------------|--------|---------|
| Comparable | Implements in class | int compareTo(T other) | Natural order |
| Comparator | Separate class | int compare(T o1, T o2) | Custom order |

## Requirements for Storing Custom Objects in Collections
### Overview
To prevent duplicates, ensure findability, and enable sorting, custom classes must properly implement interfaces and override methods.

### Key Concepts
- Always override hashCode and equals for maps/sets.
- Implement Comparable for natural sorting in TreeSet/TreeMap.
- Use Comparator for diverse sorting logics.

## Summary
### Key Takeaways
```diff
+ HashMap stores key-value pairs with hash-based operations for O(1) average performance.
+ TreeSet and TreeMap require Comparable or Comparator for sorting and duplicate prevention.
+ Custom classes need hashCode, equals, and compareTo overrides for proper collections behavior.
+ LinkedHashMap preserves insertion order, HashMap does not guarantee order.
- Avoid null keys/values in Tree-based collections to prevent NullPointerException.
- Misspelled "hashm" should be "HashMap" throughout transcript; corrected here.
```

### Expert Insight
**Real-world Application**: TreeMap excels in financial apps for sorted transaction logs; Comparator allows custom sorting like prioritizing high-priority tasks.  
**Expert Path**: Master Comparable for defaults, Comparator for flexibility; benchmark HashMap vs TreeMap for data size trade-offs.  
**Common Pitfalls**: Forgetting hashCode/equals leads to data-wise duplicates; non-Comparable objects cause runtime failures; null attempts in Tree structures crash gracefully but halt execution. No common lesser-known facts here.应用程序.
