# Session 13: HashMap Internals and Duplicate Key Handling

## Table of Contents

- [HashMap put() Method Behavior](#hashmap-put-method-behavior)
- [HashMap Storage Display](#hashmap-storage-display)
- [HashCode Ordering vs Insertion Order](#hashcode-ordering-vs-insertion-order)
- [Reference vs Data Comparison](#reference-vs-data-comparison)
- [Implementing Data-wise Comparison](#implementing-data-wise-comparison)
- [HashMap Algorithm Flow](#hashmap-algorithm-flow)
- [Bucket Concept](#bucket-concept)
- [Performance Benefits over List](#performance-benefits-over-list)

## HashMap put() Method Behavior

### Overview
The `put(key, value)` method in HashMap serves two primary operations:
- **Storing** new key-value pairs when the key doesn't exist
- **Replacing** existing values when the key is already present
- Always returns the previous value associated with the key, or `null` if the key was new

### Key Points
- `put()` method return type is `Object`
- **New key**: Stores the key-value pair and returns `null`
- **Existing key**: Replaces the old value with new value and returns the old value
- Keys cannot be duplicate - only values can be duplicated

### Code Example
```java
HashMap<String, Integer> hm = new HashMap<>();
System.out.println(hm.put("a", 1));  // Returns: null (new key)
System.out.println(hm.put("a", 2));  // Returns: 1 (existing key, old value replaced)
```

## HashMap Storage Display

### Overview
HashMap displays elements differently from other collection types, using curly bracket notation to show key-value pairs.

### Key Display Format
```diff
+ HashMap Display: {key1=value1, key2=value2, key3=value3}
+ List Display: [element1, element2, element3]
```

### Code Example
```java
HashMap<Object, Object> hm = new HashMap<>();
hm.put("a", 1);
hm.put(5, 2);
System.out.println(hm);  // Output: {a=1, 5=2}
```

## HashCode Ordering vs Insertion Order

### Overview
HashMap maintains objects in hash code order, not insertion order, which can appear misleading in output.

### Key Characteristics
- Elements are stored based on hash code calculation
- Order appears random compared to insertion sequence
- **Not insertion order**, **not ascending order** - it's hash code order

### Example Demonstration
```java
HashMap<Object, Object> hm = new HashMap<>();
hm.put("a", 1);      // hash code: 97
hm.put("b", 2);      // hash code: 98
hm.put('C', 3);      // hash code: 99 (if stored as Character)
hm.put(6, 4);        // hash code: 6
hm.put(7.5, 5);      // hash code: various
System.out.println(hm);  // May appear: {a=1, 7.5=5, 6=4, C=3, b=2}
```

## Reference vs Data Comparison

### Overview
By default, HashMap prevents only reference-wise duplicate objects, not data-wise duplicates.

### Understanding the Behavior
```java
class A {
    int x, y;
    A(int x, int y) { this.x = x; this.y = y; }
}

HashMap<A, Integer> hm = new HashMap<>();
A a1 = new A(5, 6);
A a2 = new A(5, 6);

// These are stored as separate entries (reference-wise different)
hm.put(a1, 1);  // Stored
hm.put(a2, 2);  // Also stored (different reference)
System.out.println(hm.size());  // Output: 2
```

### Impact
- **Without overriding**: HashMap treats `new A(5,6)` and another `new A(5,6)` as different keys
- Only exact same object reference is considered duplicate
- Data-wise duplicates are allowed unless `hashCode()` and `equals()` are overridden

## Implementing Data-wise Comparison

### Overview
To enable data-wise duplicate detection, both `hashCode()` and `equals()` methods must be overridden in the custom class.

### Required Implementation
```java
class A {
    int x, y;

    A(int x, int y) {
        this.x = x;
        this.y = y;
    }

    // Override hashCode for consistent hashing
    @Override
    public int hashCode() {
        return Objects.hash(x, y);  // Generate hash based on data
    }

    // Override equals for data comparison
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        A a = (A) obj;
        return x == a.x && y == a.y;
    }
}
```

### Result
```java
HashMap<A, Integer> hm = new HashMap<>();
A a1 = new A(5, 6);
A a2 = new A(5, 6);

hm.put(a1, 1);  // Stored
hm.put(a2, 2);  // Data-wise duplicate - value replaced
System.out.println(hm.size());  // Output: 1
System.out.println(hm.get(a1)); // Output: 2
```

## HashMap Algorithm Flow

### Algorithm Overview
HashMap uses a three-step algorithm to determine if an object should be stored:
1. **hashCode()** - For grouping/sorting objects into buckets
2. **== operator** - For reference comparison within same hash bucket
3. **equals()** - For data comparison when references differ but hash codes match

### Complete Flow Diagram
```mermaid
flowchart TD
    A[put(key, value)] --> B{Key already exists?}
    B -->|Yes| C[Replace old value, return old value]
    B -->|No| D[Call key.hashCode()]
    D --> E[Find/Create bucket for hash code]
    E --> F{Objects in bucket?}
    F -->|No| G[Store new entry in bucket]
    F -->|Yes| H[Compare with bucket objects]
    H --> I{key == existingKey?}
    I -->|Yes| J[Reference matches - replace value]
    I -->|No| K{key.equals(existingKey)?}
    K -->|Yes| L[Data matches - replace value]
    K -->|No| M[Store as new entry in same bucket]
```

### When Methods Are Called
- **hashCode()**: Always called on every key object during put/get operations
- **== operator**: Called only when hash codes match and reference check is needed
- **equals()**: Called only when hash codes match and references differ

## Bucket Concept

### Overview
HashMap internally uses a bucket-based data structure where related objects (same hash code) are grouped together for efficient storage and retrieval.

### Bucket Mechanics
```diff
+ Bucket: A collection within HashMap containing objects with same hash code
+ Purpose: Reduces comparison operations by grouping similar objects
+ Storage: Related objects stored in same bucket, unrelated in different buckets
```

### Example Structure
```
HashMap Buckets:
Bucket 97: ["a" -> 1, "A" -> 10, ...]  (String objects with hash code 97)
Bucket 98: ["b" -> 2, "B" -> 20, ...]  (String objects with hash code 98)
Bucket 6:  [6 -> 4, ...]               (Integer objects with hash code 6)
```

### Key Behavior
```java
HashMap<Object, Object> hm = new HashMap<>();
hm.put("a", 1);      // Creates bucket for hash code 97
hm.put("A", 10);     // Different reference, same hash code -> same bucket
hm.put("b", 2);      // Different hash code -> different bucket
```

## Performance Benefits over List

### Overview
HashMap provides superior performance for search operations compared to List implementations through algorithmic efficiency.

### Linear vs Hash-based Searching
- **List Implementation**: Sequential search - O(n) complexity
- **HashMap Implementation**: Bucket-based search - O(1) average complexity

### Comparison Visualization
```diff
- List Search: New object compared with ALL existing objects
+ HashMap Search: New object compared only with objects in same hash bucket

List: [obj1, obj2, obj3, obj4, obj5] <- new_obj compared with each
HashMap:
  Bucket A: [obj1, obj2]
  Bucket B: [obj3, obj4]
  Bucket C: [obj5]        <- new_obj compared only with Bucket A objects
```

### Real-world Impact
```java
// Inefficient for large datasets
ArrayList<String> list = new ArrayList<>(Arrays.asList("a", "b", "c", "d", "e"));
// Checking 1000 elements requires up to 1000 comparisons

// Efficient for large datasets
HashMap<String, Integer> map = new HashMap<>();
// Checking with hash code grouping requires minimal comparisons
```

## Summary

### Key Takeaways
```diff
+ HashMap uses hashCode + equals algorithm for duplicate detection
+ put() returns null for new keys, old value for existing keys
+ Keys cannot be duplicate, values can be duplicate
+ Override hashCode() and equals() for data-wise comparison
+ Bucket system groups objects by hash code for performance
+ HashMap provides O(1) average search complexity vs List's O(n)
! If hashCode() and equals() not overridden, comparison is reference-based only
```

### Expert Insight

#### Real-world Application
HashMap is essential for:
- **Caching systems** where fast lookup by key is critical
- **Database indexing** concepts (primary keys map to records)
- **Configuration management** (property keys map to values)
- **Session management** (session IDs map to user data)

#### Expert Path
- Master hash code implementation for consistent bucketing
- Understand collision resolution strategies
- Study ConcurrentHashMap for thread-safe scenarios
- Analyze HashMap load factor and resizing behavior
- Implement custom equals() methods carefully avoiding infinite loops

#### Common Pitfalls
- **Incomplete overridden methods**: Always override both hashCode() and equals() together
- **Inconsistent hash codes**: equals() returning true but hashCode() different causes failures
- **Null handling**: HashMap allows one null key but multiple null values - know the implications
- **Concurrent modification**: Avoid structural changes during iteration

#### Lesser Known Aspects
- HashMap doesn't guarantee iteration order (use LinkedHashMap for ordered iteration)
- Initial capacity and load factor significantly impact performance
- String class has highly optimized hashCode() implementation
- HashMap rehashes all entries during resizing operations
- hashCode() should be fast and return evenly distributed values to minimize collisions

### Test Case Program Flow
```java
// Tomorrow's session covers:
// 1. Override hashCode() and equals() procedure
// 2. Complete algorithm implementation
// 3. Memory diagram explanation
// 4. Interview questions and solutions
// 5. Performance comparison programs
```

---

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
