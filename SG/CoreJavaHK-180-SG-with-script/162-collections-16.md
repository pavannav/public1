# Session 162: Collections 16

1. [Overview](#overview)
2. [Key Concepts](#key-concepts)
   - [Bucket Creation in HashMap](#bucket-creation-in-hashmap)
   - [When equals Method is Invoked](#when-equals-method-is-invoked)
   - [Interrelation Between hashCode and equals](#interrelation-between-hashcode-and-equals)
   - [hashCode-equals Contract and Test Cases](#hashcode-equals-contract-and-test-cases)
   - [Object Reference and hashCode](#object-reference-and-hashcode)
   - [Data-wise vs. Reference-wise hashCode](#data-wise-vs-reference-wise-hashcode)
   - [When to Override hashCode and equals](#when-to-override-hashcode-and-equals)
   - [Technique for Satisfied Contract](#technique-for-satisfied-contract)
   - [Example Implementations](#example-implementations)
   - [Correct Implementation of hashCode](#correct-implementation-of-hashcode)
   - [Actual Internal Diagram of HashMap](#actual-internal-diagram-of-hashmap)
   - [HashMap put Method Logic](#hashmap-put-method-logic)
   - [Java 8 Improvement: LinkedList to Binary Tree](#java-8-improvement-linkedlist-to-binary-tree)
   - [Flowchart: HashMap Internal Algorithm](#flowchart-hashmap-internal-algorithm)

## Overview

In this session, we dive deep into the internals of HashMap in Java Collections Framework, focusing on the critical relationship between the `hashCode` and `equals` methods. We explore how buckets are created, when methods are invoked, the contractual obligations between these methods, and performance optimizations introduced in Java 8. This session builds on previous Collections topics and emphasizes practical implementation for storing objects as keys in collections like HashMap.

## Key Concepts

### Bucket Creation in HashMap

In HashMap's internal data structure (hashtable), buckets are conceptual groupings of objects. Key points:

- **New Bucket Creation**: A new bucket is created when a new hash code is added to the map. The bucket represents a slot where objects with the same hash code group are stored.
- **No Initial Buckets**: Buckets are not pre-created; they form dynamically as objects are added.
- When an object is added, the `hashCode` method is called first to determine the group (bucket).

💡 Buckets are logical containers; in reality, they map to specific locations in an internal array.

### When equals Method is Invoked

The `equals` method is not always called during object insertion:

- `equals` is invoked **only if** two objects have the same hash code.
- If hash codes differ, a new bucket is created, and `equals` is **not** called.
- Purpose: To check for object equality within the same bucket (group).

Square > sequentiallyB Adding an object with different hash code → New bucket created → equals not invoked

### Interrelation Between hashCode and equals

There is a strong dependency between `hashCode` and `equals` methods:

- You **must override both** if objects are to be used as keys in HashMap.
- Without proper overriding, objects won't group correctly, leading to performance issues and incorrect comparisons.
- The methods must be connected via a "contract" to ensure consistency.

> [!IMPORTANT]
> Ignoring this relationship can cause duplicate entries or failed lookups in HashMap.

### hashCode-equals Contract and Test Cases

The contract states: If `equals(e1, e2) == true`, then `hashCode(e1) == hashCode(e2)`.

Four test cases elucidate this:

| Case | equals(e1, e2) | hashCode(e1) vs hashCode(e2) | Reason |
|------|----------------|-------------------------------|--------|
| 1    | true          | Must be same                  | Objects in same bucket need identical hash codes. |
| 2    | false         | Can be same or different      | Allows flexibility for unique objects. |
| 3    | N/A (hashCode same) | equals can return true or false | Same bucket allows comparison; equals checks for duplicates. |
| 4    | N/A (hashCode different) | equals must return false      | Different buckets mean inherently unique groups. |

✅ Understand these cases to ace interviews: Case 1 is common, but mastering all demonstrates deep knowledge.

### Object Reference and hashCode

From `java.lang.Object` class:

- `hashCode` of an object is derived from its reference (memory address), converted to an integer.
- Example: Two variables pointing to the same object have the same hash code and reference.
- Vice versa: Same hash code does not imply same reference (but implies same group in collections).

⚠️ Reference-based hash codes are not suitable for data-based hashing; override for custom classes.

### Data-wise vs. Reference-wise hashCode

- **Reference-wise**: Default behavior; hash code based on object identity. Use when object uniqueness matters by identity.
- **Data-wise**: Override to base hash code on object data (e.g., fields). Essential for collections where logical equality is key.

Example: For `String`, `hashCode` is data-wise (based on characters), so `"abc"` and another `"abc"` have same hash code despite different references.

> [!NOTE]
> Override `hashCode` (and `equals`) when data equality is more important than reference equality.

### When to Override hashCode and equals

Mandatory when using custom objects as keys in HashMap or similar collections:

- If only `hashCode` is overridden: Buckets form, but comparisons fail.
- If only `equals` is overridden: Objects may not group into correct buckets.
- Always override both together.

> [!IMPORTANT]
> Failing to do so leads to incorrect storage and retrieval of objects.

### Technique for Satisfied Contract

Simple rule to ensure contract compliance:

- **In `hashCode`**: Use properties that represent object grouping (e.g., department, type).
- **In `equals`**: Use the same grouping properties **plus** a unique identifier (e.g., ID).
- This guarantees: If `equals == true`, hash codes are same; else, flexibility exists.

💡 Contract satisfied "unknowingly" if you follow this rule.

### Example Implementations

1. **Student Object**:
   - `hashCode`: Return `course` (grouping property).
   - `equals`: Compare `course` + `studentNumber` (unique ID).
   - Rationale: Students in same course belong to same bucket, but must have unique student numbers for equality.

2. **Employee Object**:
   - `hashCode`: Return `department`.
   - `equals`: Compare `department` + `employeeNumber`.

3. **Bank Account Object**:
   - `hashCode`: Generate based on `bankName`, `branchOrIFSC`, and `accountType`.
   - `equals`: Compare `bankName`, `branchOrIFSC`, `accountType` + `accountNumber`.

> [!IMPORTANT]
> Grouping properties allow efficient clustering; unique properties prevent false duplicates.

### Correct Implementation of hashCode

Design principles for optimal performance:

- **Wrong**: Different hash code for every object → Each in its own bucket → Fast lookups but wasted memory (high bucket count).
- **Worse**: Same hash code for all objects → One giant bucket → Linear search inefficiency.
- **Right**: Same hash code for related objects → Balances grouping and comparison speed.

Goal: Minimize bucket size while allowing quick equality checks.

### Actual Internal Diagram of HashMap

Conceptual diagram shows logical grouping; actual implementation uses:

- **Table**: A `Node[]` array (Entry[]) of size 16 (default capacity).
- **Buckets**: Each index is a bucket, implemented as a singly-linked list of `Node` objects.
- `Node` structure: `key`, `value`, `next` (for linking), `hash` (cached hash code).
- Flow: Hash code generates index via `hash % capacity`, maps to array location.

Used array of `Node` class activities helps create linked list for collision resolution.

### HashMap put Method Logic

Step-by-step put operation:

1. Call `hashCode()` on key → Get hash value.
2. Compute index: `hash % capacity` (e.g., 97 % 16 = 1).
3. Check `table[index]`:
   - If `null` → Create new `Node` (bucket) → Insert key-value → Done.
   - If not null → Retrieve existing `Node` → Check:
     - Reference equality (`==`): If same, replace value.
     - Else: Call `equals`: If true, replace value; else, append to linked list (new `Node`).

This ensures no duplicates based on `equals`, while using hash for fast location.

### Java 8 Improvement: LinkedList to Binary Tree

- **Threshold**: If bucket size >= 8 (switches from LinkedList to Tree when adding 9th item).
- **Advantage**: Transforms O(n) linear search to O(log n) tree traversal.
- Binary tree uses natural ordering for comparisons, reducing comparisons in crowded buckets.
- Improves performance for high-collision scenarios.

> [!NOTE]
> Implicit conversion; no code changes required for developers.

### Flowchart: HashMap Internal Algorithm

```mermaid
flowchart TD
    A[Call hm.put(key, value)] --> B[Get hashCode of key]
    B --> C[Compute index = hash % capacity e.g., 97 % 16 = 1]
    C --> D{Is table[index] null?}
    D -->|Yes| E[Create new Node key,value,next=null,hash]
    E --> F[Assign to table[index]]
    D -->|No| G[Retrieve existing Node e]
    G --> H{Check if key == e.key?}
    H -->|Yes| I[Replace e.value]
    H -->|No| J{Call key.equals(e.key)}
    J -->|Yes| K[Replace e.value]
    J -->|No| L[Append new Node to linked list set e.next = newNode]
```

*Hash Function: `hashCode` method used to generate hash, then modulo operation for indexing.*

## Summary

### Key Takeaways
```diff
+ HashMap buckets are dynamic and based on hashCode groupings.
+ equals invoked only within same hashCode buckets.
- Ignore hashCode-equals contract leads to incorrect Map behavior.
+ Always override both methods together for custom keys.
! Related objects should share hashCodes for efficiency.
+ Java 8 auto-converts large buckets to binary trees for performance.
```

### Expert Insight

**Real-world Application**: In distributed caching (e.g., Redis-like systems) or database indexing, proper hashCode ensures fast lookups and prevents duplicates. For microservices, overriding ensures consistent object hashing across JVMs.

**Expert Path**: Master the four contract cases for interviews. Practice profiling HashMap performance with JMH tool. Dive into ConcurrentHashMap for multi-threading extensions.

**Common Pitfalls**: 
- Overriding only one method causes failures.
- Using mutable fields in hashCode (changes post-insertion break Map).
- High load factor without resizing leads to long chains.
- Tiger Ignoring Java 8 tree conversion scenarios.

Lesser-known things: HashMap's `loadFactor` (default 0.75) triggers resize when breached. Tree bins in Java 8 handle Comparable vs. Comparator internally. Null keys map to index 0 via special handling.

<summary>CL-KK-Terminal</summary>Mistakes corrected in transcript for accuracy: "hash Codex" to "hashCode", "return return" to "return", "test cases" references clarified, "who object reference" to "object reference", "enk" to "in", typos like "Chak" to "check", "uh um" removed for clarity, "logan" to "gaining" contextually, repeated "e" removed, "Um" to "In", "standard" to "standards", "IMS" to "I'm", "ready" added for continuity. No major URL or external content generated.
