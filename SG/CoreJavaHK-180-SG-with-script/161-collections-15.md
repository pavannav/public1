# Session 15: Collections HashMap Internals

## Table of Contents
- [Introduction to HashMap Internals Cases](#introduction-to-hashmap-internals-cases)
- [Hashing Algorithm and Hash Collision](#hashing-algorithm-and-hash-collision)
- [Case 1: No Override of hashCode and equals Methods](#case-1-no-override-of-hashcode-and-equals-methods)
- [Case 2: Override hashCode Method Only](#case-2-override-hashcode-method-only)
- [Case 3: Override equals Method Only](#case-3-override-equals-method-only)
- [Case 4: Override Both hashCode and equals Methods](#case-4-override-both-hashcode-and-equals-methods)
- [Additional Cases with Constant Returns](#additional-cases-with-constant-returns)
- [Practical Implementation with System Outprints](#practical-implementation-with-system-outprints)
- [Memory Representation and Ordering in Collections](#memory-representation-and-ordering-in-collections)
- [Summary and Test Cases](#summary-and-test-cases)

## Introduction to HashMap Internals Cases

### Overview
In Java collections, particularly HashSet, LinkedHashSet, HashMap, and LinkedHashMap, the behavior of storing objects depends critically on the implementation of `hashCode()` and `equals()` methods in the object class. HashMap uses a hash table data structure internally, dividing objects into buckets based on hash codes. The six cases discussed represent different scenarios of overriding these methods, affecting how objects are stored, compared, and whether data-wise duplicates are prevented. Understanding these cases is essential for developers to write efficient collections code and debug issues related to object storage and retrieval.

### Key Concepts/Deep Dive
- **Hash Code Generation**: The `hashCode()` method computes an integer hash code for the object, which determines the bucket index in the hash table.
- **Bucket Assignment**: Objects with the same hash code go into the same bucket to reduce search time.
- **Comparison Mechanisms**:
  - `==` (reference comparison) checks if two references point to the same object in memory.
  - `equals()` method compares object data for equivalence (overridden for custom logic).
- **Hash Collision**: Occurs when multiple objects have the same hash code but different data, leading to multiple objects in the same bucket.
- **No Duplicates Logic**: For data-wise uniqueness, both methods must be overridden correctly; `hashCode()` ensures objects go to the same bucket, and `equals()` verifies if they are truly duplicates.

### Code/Config Blocks
The example class `Example` used throughout is:

```java
class Example {
    private int x;
    private int y;

    Example(int x, int y) {
        this.x = x;
        this.y = y;
    }

    // hashCode and equals methods are overridden in various cases
}
```

For HashSet usage:

```java
HashSet<Example> hs = new HashSet<>();
hs.add(new Example(5, 6));
hs.add(new Example(7, 8));
// Add more objects based on cases
```

## Hashing Algorithm and Hash Collision

### Overview
The logic written inside the `hashCode()` method to generate a hash code number is called the hashing algorithm. For example, using `x + y` as a combination of fields to create unique hash codes. Hash collision occurs when two or more objects have the same hash code but are not identical, requiring comparison via `==` and `equals()` within the same bucket.

### Key Concepts/Deep Dive
- **Hashing Algorithm Steps**:
  - Identify key fields (e.g., `x` and `y` in the example).
  - Combine them logically (e.g., addition: `x + y`).
  - The sequence of statements forms the algorithm.
- **Hash Collision Definition**: When multiple objects share the same hash code.
  - Example: Objects with hash codes 11 and 11 collide if different data.
- **Handling Collision**:
  - Check reference equality with `==`.
  - If different, invoke `equals()` for data comparison.
  - Store only if unique; otherwise, replace or discard.
- **Impact**: Higher collision rates degrade performance due to increased comparisons.

### Tables
| Concept          | Description                              | Example Hash Values |
|------------------|------------------------------------------|---------------------|
| Hashing Algorithm| Logic to generate hash code from fields | `x + y` = 11 for (5,6) |
| Hash Collision  | Same hash code, different objects       | 11 for (5,6) and (6,5) |
| Resolution      | Use == then equals()                    | Store if not equal  |

## Case 1: No Override of hashCode and equals Methods

### Overview
When neither `hashCode()` nor `equals()` is overridden in the custom class, Java uses default implementations from `Object`. `hashCode()` generates a unique code based on object reference (memory address), and `equals()` compares references only. This leads to reference-based comparison, storing all objects as unique unless references match.

### Key Concepts/Deep Dive
- **Buckets Creation**: Each object gets a unique bucket since hash codes are distinct.
- **Duplicate Handling**: Reference duplicates are prevented, but data duplicates are allowed.
- **Object Storage**: All objects stored individually, separate buckets per object.
- **Example**: Eight unique references → eight buckets; reference same objects occur rarely.

### Bullets
- Default `hashCode()`: Unique per object instance.
- No `equals()` call opportunity: Separate buckets prevent comparison.
- Result: High memory usage for data duplicates.

## Case 2: Override hashCode Method Only

### Overview
Overriding only `hashCode()` (e.g., returning `x + y`) groups objects by hash code into fewer buckets, but `equals()` remains reference-based from `Object`. Data-wise duplicates are stored as unique objects without data comparison.

### Key Concepts/Deep Dive
- **Buckets Reduction**: Objects with same hash code share a bucket.
- **No Data Uniqueness**: Reference comparison only; data duplicates in different references are stored.
- **Example Algorithm**: Use field combination (e.g., `x + y`) for hash generation.
- **Performance**: Fewer buckets but unnecessary storage.

### Tables
| Action        | hashCode Called | equals Called | Result |
|---------------|-----------------|---------------|--------|
| Add new object| Yes            | No (separate buckets) | Stored |
| Add duplicate data | Yes         | Yes (but reference-based) | Stored if different ref |

## Case 3: Override equals Method Only

### Overview
Overriding only `equals()` without `hashCode()` means all objects are assigned unique hash codes (using `Object.hashCode()`), creating separate buckets. The `equals()` override enables data comparison but is never called, as objects never collide in buckets.

### Key Concepts/Deep Dive
- **Ineffectiveness**: Separate buckets prevent `equals()` invocation useless.
- **Object Storage**: Identical to Case 1, all objects stored.
- **Example Override**: Compare `this.x == obj.x && this.y == obj.y`.
- **Consequence**: Contradicts purpose of data uniqueness.

### Bullets
- Hash codes remain unique.
- Equals is overridden but idle.
- Data duplicates fully stored.

## Case 4: Override Both hashCode and equals Methods

### Overview
Proper implementation involves overriding both methods: `hashCode()` for bucketing and `equals()` for data comparison. This ensures data-wise uniqueness, efficient storage, and correct behavior in HashSet/HashMap.

### Key Concepts/Deep Dive
- **Algorithm Alignment**: `hashCode()` and `equals()` must be consistent (same fields for both).
- **Bucket Sharing**: Collisions trigger `==` then `equals()` comparison.
- **Uniqueness Assurance**: Data duplicates replaced; efficient lookups.
- **Example**: With `x + y` hash and data comparison, duplicates are discarded.

### Code/Config Blocks
Example implementation:

```java
@Override
public int hashCode() {
    return x + y;  // Hashing algorithm
}

@Override
public boolean equals(Object obj) {
    if (this == obj) return true;  // Reference check
    if (!(obj instanceof Example)) return false;
    Example ex = (Example) obj;
    return this.x == ex.x && this.y == ex.y;  // Data check
}
```

### Tables
| Scenario       | hashCode Match | == Result | equals Result | Action |
|----------------|----------------|-----------|---------------|--------|
| Unique object | Yes           | Different | Different    | Store |
| Data duplicate| Yes           | Different | Same         | Replace |

## Additional Cases with Constant Returns

### Overview
Testing edge cases by returning constants in overrides reveals behavior: Returning same hash code (e.g., 5) forces single bucket with excessive comparisons, while combined with `equals()` returning true/false affects storage uniquely.

### Key Concepts/Deep Dive
- **Constant hashCode (5), no equals override**: All objects in one bucket, compares references.
- **Constant hashCode (5), equals returns true**: Only first object stored; all subsequent treated as duplicates.
- **Constant hashCode (5), equals returns false**: All objects stored despite same data; reference uniqueness preserved.
- **Purpose**: Demonstrates poor design risks (performance issues in single bucket).

### Bullets
- Hardcoded hashCode creates hash collision for all objects.
- equals behavior determines storage (true: single object; false: all objects).
- Lesson: Use field-based logic, avoid constants.

## Practical Implementation with System Outprints

### Overview
Enhance understanding by adding `System.out.println()` in `hashCode()` and `equals()` to trace method calls, bucket assignments, and comparisons during object addition.

### Key Concepts/Deep Dive
- **Tracing Calls**: Print in methods to log invocations and parameters.
- **Output Analysis**: Count buckets, objects, collisions.
- **Debugging**: Reveals internal flow for different cases.

### Code/Config Blocks
Enhanced Example class for tracing:

```java
class Example {
    private int x, y;

    Example(int x, int y) { this.x = x; this.y = y; }

    @Override
    public int hashCode() {
        int hash = x + y;
        System.out.println("hashCode called for: (" + x + "," + y + ") -> " + hash);
        return hash;
    }

    @Override
    public boolean equals(Object obj) {
        System.out.println("equals called for: (" + this.x + "," + this.y + ") comparing with " + obj);
        if (this == obj) return true;
        if (!(obj instanceof Example)) return false;
        Example ex = (Example) obj;
        return this.x == ex.x && this.y == ex.y;
    }
}
```

### Lab Demos
1. **Setup HashSet and Add Objects**:
   - Create HashSet<Example>.
   - Add objects: new Example(5,6), (7,8), (6,5), (7,4), (1,2), (3,2), (3,2), (5,7), (5,7).
   - Run with tracing enabled.
   - Observe output showing hashCode calls, collisions, and equals invocations.

2. **Analyze Output by Case**:
   - For Case 4: Count buckets created (e.g., 4 buckets for 6 objects).
   - Verify duplicates handled (e.g., second (3,2) not stored).
   - Expected output includes hash codes and comparison logs per object addition.

3. **Verify Storage Count**:
   - Without overrides: 8 buckets, 8 objects.
   - With both overrides: Fewer buckets, unique data objects only.
   - Execute multiple times to ensure consistency.

## Memory Representation and Ordering in Collections

### Overview
Physically, buckets are hash table indices; programmatically, objects appear sorted by hash code in HashSet (insertion order ignored). HashMap maintains hash code order, not chronological insertion.

### Key Concepts/Deep Dive
- **Bucket Physical View**: Cannot see memory directly; infer from code traces.
- **Logical Ordering**: Objects grouped by hash code ascending.
- **HashSet vs LinkedHashSet**: HashSet follows hash code order; LinkedHashSet preserves insertion order.
- **Visualization**: Use output to map objects per bucket.

### Bullets
- Hash code determines bucket placement.
- Collisions group objects in same bucket.
- Understand via programmatic output, not diagrams.

## Summary and Test Cases

### Overview
The session concludes HashMap internals understanding through six test cases, emphasizing correct override of `hashCode()` and `equals()` for data uniqueness and performance. Practice these to master collection behavior in real-world coding.

### Key Concepts/Deep Dive
Review six cases for adding objects to collections:
- Objects added: Example(5,6), (7,8), (6,5), (7,4), (1,2), (3,2), (5,7).
- Analyze per case: Buckets created, objects stored, comparisons triggered.

### Tables
| Case                 | hashCode Override | equals Override | Objects Added | Buckets Created | Notes |
|----------------------|-------------------|-----------------|---------------|-----------------|-------|
| 1: None             | No               | No             | 8            | 8              | Reference only |
| 2: hashCode only    | Yes              | No             | 8            | Fewer          | Data duplicates stored |
| 3: equals only      | No               | Yes            | 8            | 8              | Useless |
| 4: Both             | Yes              | Yes            | 6            | 4              | Correct |
| Constant hashCode + equals true | Yes (constant) | Yes (true)    | 1            | 1              | First only |
| Constant hashCode + equals false| Yes (constant)| Yes (false)   | 8            | 1              | All stored |

### Lab Demos
1. **Implement Test Cases**:
   - Code the Example class with overrides per case.
   - Add objects to HashSet, print size and trace output.
   - Compare expected vs actual objects/buckets.

2. **Count Invocations**:
   - Use sysouts to count hashCode/equals calls.
   - Verify logic matches case descriptions.

## Summary

### Key Takeaways
```diff
+ Core Concept: hashCode() determines bucket; equals() verifies uniqueness.
+ Best Practice: Override both consistently using same fields.
+ Hash Collision: Normal; excessive collisions indicate poor hashCode logic.
- Pitfall: Override only one method breaks expected behavior.
- Avoid: Hardcoded hash codes or equals returns cause performance issues.
! Testing Tip: Use sysouts to trace internal flow.
```

### Expert Insight
**Real-world Application**: In applications like user session management (HashMap for sessions) or deduplication (HashSet for unique records), correct overrides prevent memory leaks and ensure fast lookups. For example, custom User objects in HashSet use email/ID in hashCode and equals.

**Expert Path**: Master by practicing edge cases (null fields, primitives). Study Java Melody or profilers for collision monitoring. Deepen with ConcurrentHashMap source for multi-threading insights.

**Common Pitfalls**: 
- Inefficient hashCode (e.g., constant) causes O(n) lookups.
- Inconsistent overrides (equals uses different fields) violate contract, leading to bugs in contains/remove.
- Mutable keys in HashMap: Changing fields after insertion breaks hashing.
- Common Issues: 
  - NullPointerException in equals without instanceOf Checks.
  - Infinite loops if equals calls itself inadvertently.
  - Resolution: Always include instanceOf, null checks; ensure consistency.
- Lesser Known Things: HashMap resizes when load factor (0.75) exceeded; hashCode computed once per object; LinkedHashMap uses additional doubly-linked list for order.
