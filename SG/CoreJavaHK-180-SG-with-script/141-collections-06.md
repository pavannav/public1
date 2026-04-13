# Session 141: Collections 06

## Table of Contents
- [Confusions from Previous Session](#confusions-from-previous-session)
- [Internal Algorithm of contains() and remove() Methods](#internal-algorithm-of-contains-and-remove-methods)
- [Overriding the equals() Method](#overriding-the-equals-method)
- [Type Safety and Casting in equals()](#type-safety-and-casting-in-equals)
- [ClassCastException Prevention](#classcastexception-prevention)
- [Null Handling in Collections](#null-handling-in-collections)
- [Viewing Internal Code](#viewing-internal-code)
- [Summary](#summary)

## Confusions from Previous Session

### Overview
This session addresses common misunderstandings from the previous discussion on collections, particularly why searching and removing operations fail for custom class objects while succeeding for primitive wrappers and built-in objects. The root cause lies in how Java collections perform object comparisons.

### Key Concepts/Deep Dive
- **Primitive Wrapper Objects**: Objects like `Integer`, `String`, etc., work correctly with `contains()` and `remove()` because they have properly implemented `equals()` methods.
- **Custom Class Objects**: Without overriding `equals()`, these operations return `false`, preventing finding or removing custom objects.
- **Comparison Mechanism**: Collections use `equals()` method for comparing objects, not reference equality (`==`).
- **Algorithm Flow**: 
  - Retrieve each object from the collection
  - Call `equals()` on the search object, passing each collection element
  - Return `true` if a match is found; continue until end of collection

### Code/Config Blocks
```java
Vector v1 = new Vector();
// Adding different types of objects
v1.add("B");
v1.add(5);
v1.add(true); 
v1.add(6.7f);
v1.add(new A(5, 6)); // Custom class object
v1.add(null);
v1.add(null);

// Attempting to search
boolean found = v1.contains(new A(5, 6)); // Returns false without overridden equals()
```

### Lab Demos
**Step 1**: Create a custom class `A` with fields `x` and `y`.
```java
class A {
    int x, y;
    A(int x, int y) {
        this.x = x;
        this.y = y;
    }
}
```

**Step 2**: Create a `Vector` and add various objects including instances of `A`.

**Step 3**: Attempt `contains()` and `remove()` without overriding `equals()` - observe `false` return.

**Step 4**: Override `equals()` method (covered in next section).

## Internal Algorithm of contains() and remove() Methods

### Overview
The `contains()` and `remove()` methods follow a systematic comparison algorithm: iterate through the collection, compare the search object with each element using `equals()`, and perform the operation (search or removal) upon finding a match.

### Key Concepts/Deep Dive
- **Search Algorithm**:
  1. Start from first element
  2. Call `equals(searchObject, currentElement)`
  3. If match found, return `true` (for contains) or remove the element (for remove)
  4. Continue until end of collection
- **Removal Algorithm**: Identical to search, but removes the matched element and returns `true` if found.
- **Comparison Fundament**: All operations depend on `equals()` method for object matching.
- **Performance**: Linear time complexity - compares each element until match or end.

### Code/Config Blocks
```java
// Conceptual algorithm inside contains/remove
for (int i = 0; i < collection.size(); i++) {
    if (searchObject.equals(collection.get(i))) {
        // Match found
        return true; // or remove element
    }
}
return false; // No match
```

### Lab Demos
**Step 1**: Implement a manual loop to simulate collection search using `equals()`.

**Step 2**: Compare with actual `Vector.contains()` behavior.

## Overriding the equals() Method

### Overview
To enable proper searching and removal of custom objects, override the `equals()` method inherited from `Object` class. The method compares two objects for equality based on their state (data fields).

### Key Concepts/Deep Dive
- **Method Prototype**: `public boolean equals(Object obj)`
- **Parameters**: `this` (current object from collection), `obj` (search/argument object)
- **Override Location**: In the custom class (e.g., class `A`)
- **Comparison Logic**: Compare field values, not references, unless reference equality is desired.
- **Default Behavior**: `Object.equals()` performs reference comparison (`==`).

### Code/Config Blocks
```java
class A {
    int x, y;
    A(int x, int y) {
        this.x = x;
        this.y = y;
    }
    
    @Override
    public boolean equals(Object obj) {
        // Implementation details covered in next sections
    }
}
```

### Lab Demos
**Step 1**: Use Eclipse code completion (`Ctrl+Space`) to generate `equals()` method override.

**Step 2**: Remove auto-generated content and implement custom logic.

**Step 3**: Test with `Vector` operations - observe change from `false` to `true`.

## Type Safety and Casting in equals()

### Overview
Within `equals()`, safely access fields of both objects by properly handling type casting and avoiding compilation errors when accessing subclass-specific members through superclass references.

### Key Concepts/Deep Dive
- **Upcasting Issue**: Using `Object` reference prevents direct field access of subclass fields.
- **Solution**: Explicit type casting to access specific fields.
- **Field Comparison**: Use `==` for primitives, `equals()` for objects (if overriding exists).
- **Complete Comparison**: Use `&&` (AND) operator to ensure all compared fields match.

### Code/Config Blocks
```java
@Override
public boolean equals(Object obj) {
    if (obj instanceof A) {
        A a = (A) obj;
        return this.x == a.x && this.y == a.y;
    }
    return false;
}
```

### Lab Demos
**Step 1**: Write comparison logic without casting - observe compilation errors.

**Step 2**: Add explicit cast to class `A`.

**Step 3**: Compile and test with `v1.contains(new A(5, 6))` - should return `true`.

## ClassCastException Prevention

### Overview
Direct type casting without verification can throw `ClassCastException` if different object types are mixed in collections. Always verify object type before casting.

### Key Concepts/Deep Dive
- **Risk**: Collections can hold heterogenous objects (e.g., `String`, `Integer`, custom objects).
- **Exception Cause**: Attempting to cast incompatible types (e.g., `String` to custom class).
- **Prevention**: Use `instanceof` operator for type checking before casting.
- **Null Safety**: `instanceof` returns `false` for `null`, avoiding `NullPointerException` during casting.

### Code/Config Blocks
```java
public boolean equals(Object obj) {
    if (obj instanceof A) {
        A a = (A) obj;
        // Compare fields
        return true/false;
    }
    return false; // Different types are unequal
}
```

### Lab Demos
**Step 1**: Remove `instanceof` check and mix objects in `Vector`.

**Step 2**: Call `contains()` or `remove()` - observe `ClassCastException`:

```
Exception in thread "main" java.lang.ClassCastException: java.lang.String cannot be cast to com.nit.hk.collections.A
```

**Step 3**: Add `instanceof` check - observe safe execution.

## Null Handling in Collections

### Overview
Collections must properly handle `null` values for search and removal operations. Internal code uses reference equality (`==`) for null checks to avoid `NullPointerException`.

### Key Concepts/Deep Dive
- **Null Search**: `null` can be searched and removed from collections.
- **Internal Logic**: Uses `==` operator instead of `equals()` for null arguments.
- **NullPointerException Prevention**: Avoid calling `null.equals()` or `null.something()`.

### Code/Config Blocks
```java
// Conceptual internal null handling
if (obj == null) {
    // Search for null using ==
} else {
    // Use equals() for non-null objects
}
```

### Lab Demos
**Step 1**: Add multiple nulls to `Vector`.

**Step 2**: Test `contains(null)'` and `remove(null)` - observe successful operations.

**Step 3**: Attempt to call `equals()` with null argument directly - observe it works if guarded properly.

## Viewing Internal Code

### Overview
Eclipse provides tools to inspect the source code of Java collections, allowing visualization of internal algorithms like the one in `Vector.contains()`.

### Key Concepts/Deep Dive
- **Navigation**: Use `Ctrl+F3` or `F3` to open source code from method calls.
- **Key Methods**: `indexOf()` (internal to `contains()`) and `size()` return internal variables.
- **Equal Operators**: `==` for null, `equals()` for objects.
- **Direct Access**: Within same class, private variables can be accessed directly without methods.

### Code/Config Blocks
```java
// Example internal Vector code structure
private Object[] elementData;
private int elementCount;

public int size() {
    return elementCount;
}

public boolean contains(Object o) {
    return indexOf(o) >= 0;
}

private int indexOf(Object o) {
    if (o == null) {
        // Search using ==
    } else {
        // Search using equals()
    }
}
```

### Lab Demos
**Step 1**: In Eclipse, hover over `Vector.contains()` and press `F3` to view source.

**Step 2**: Locate `indexOf()` internal logic.

**Step 3**: Observe conditional null vs. object handling.

## Summary

### Key Takeaways
```diff
+ Collections rely on equals() for object comparison in contains/remove operations
+ Override equals() for custom classes to enable proper search/removal
+ Always use instanceof before type casting to prevent ClassCastException
+ Internal code uses == for null arguments and equals() for object arguments
+ Failure to override equals() results in reference-only comparison
+ Type safety is crucial when collections hold heterogeneous objects
```

### Expert Insight

#### Real-world Application
In enterprise applications, proper `equals()` implementation is essential for data structures like `Set` (which uses `equals()` for uniqueness) and `Map` (for key lookups). For example, user authentication systems rely on comparing user objects by ID instead of reference to find matching accounts. Collections are heavily used in caching layers, database result processing, and UI data binding where object identity must be determined by business logic, not memory location.

#### Expert Path
Master object comparison by studying `Comparable` interface for total ordering (used in sorting) alongside `equals()`. Practice implementing `hashCode()` alongside `equals()` to maintain contract (equal objects must have equal hash codes) for efficient `HashMap`/`HashSet` performance. Experiment with Apache Commons `EqualsBuilder` for fluent comparison logic. Study collection implementations (ArrayList, LinkedList, TreeSet) to understand different comparison strategies and their impact on Big O performance.

#### Common Pitfalls
- **Missing equals() Override**: Leads to incorrect behavior in all collection operations relying on equality (Set operations, Map keys, contains/remove).
- **Incomplete Field Comparison**: Comparing only some fields can cause false matches; decide based on business equality rules.
- **Ignoring Null Safety**: Forgetting instanceof check causes runtime exceptions when collections contain mixed types.
- **Direct Casting Without Check**: Attempting `(A)obj` without `instanceof` throws ClassCastException for incompatible objects.
- **Reference vs. State Confusion**: Using == instead of equals() compares memory addresses, not object content.

#### Lesser Known Things
- `Vector` uses `==` internally only for null arguments; all other comparisons delegate to `equals()`.
- Collections framework design allows mixing types, requiring robust type-checking in user code.
- The `equals()` contract is symmetric, transitive, and reflexive; violating this causes unpredictable collection behavior.
- `removeAll()` removes all occurrences, while `remove()` removes only the first match.
- Internal element access uses raw arrays with index-based loops for optimal performance.
