# Session 167: Collections 18

## Table of Contents
- [Differences between Comparable and Comparator](#differences-between-comparable-and-comparator)
- [Ways to Develop Custom Comparators](#ways-to-develop-custom-comparators)
- [Using Comparators for TreeSet](#using-comparators-for-treeset)
- [Comparing Objects by Multiple Properties](#comparing-objects-by-multiple-properties)
- [Summary](#summary)

## Differences between Comparable and Comparator

### Overview
This section covers the fundamental differences between the `Comparable` and `Comparator` interfaces in Java Collections, which are essential for sorting and comparing objects. `Comparable` is used for natural ordering, while `Comparator` allows for custom sorting logic. These concepts are crucial for implementing efficient data structures like `TreeSet` and `TreeMap`.

### Key Concepts/Deep Dive
- **Natural vs. Custom Sorting**:
  - `Comparable` provides natural sorting order for objects.
  - `Comparator` enables custom sorting order, allowing flexibility beyond natural ordering.

- **Method Implementation**:
  - `Comparable` contains `compareTo(Object param)` method for comparison logic.
  - `Comparator` contains `compare(Object, Object param)` method for comparing objects.

- **Invocation During Insertion**:
  - By default, `TreeSet.add()` method invokes `compareTo()` when objects are `Comparable` types.
  - When passing a `Comparator` as an argument using `TreeSet` constructor (e.g., `TreeSet(Comparator)`), `add()` invokes `Comparator.compare()`.

- **Version Availability and Package**:
  - `Comparable` is available in `java.lang` package since Java 1.0.
  - `Comparator` is available in `java.util` package since Java 1.2 (part of Collections Framework).

- **Functional Interface Status**:
  - Both are functional interfaces (single abstract method) since Java 8.
  - `Comparable` is not explicitly annotated with `@FunctionalInterface` because it's not typically used as a method or constructor parameter directly.
  - `Comparator` is explicitly declared as `@FunctionalInterface`.

- **Method Count and Types**:
  - `Comparable` has only one method: `compareTo()` (abstract, no default/static/private methods).
  - `Comparator` has `compare()` and `equals()` (both abstract, but `equals()` is inherited from `Object`, so only `compare()` needs implementation in most cases). It also includes many default and static methods added in later Java versions (e.g., `reversed()`, `comparing()`, `naturalOrder()`, `nullsFirst()`, `nullsLast()`), which are already implemented and don't require overriding.

> [!IMPORTANT]  
> Understanding these differences is critical for choosing the right approach: use `Comparable` for default sorting and `Comparator` for flexible, custom sorting.

### Lab Demos
No specific lab demos in this section, but the concepts are demonstrated through examples in subsequent sections.

## Ways to Develop Custom Comparators

### Overview
A custom `Comparator` is needed when the default `Comparable` implementation doesn't suffice or when multiple sorting orders are required. This section demonstrates four ways to implement `Comparator` interface for sorting `B` class objects (assuming a class `B` with `x` and `y` properties).

### Key Concepts/Deep Dive
- **Four Implementation Approaches**:
  1. **Explicit Outer Class**: Create a dedicated class implementing `Comparator`.
  2. **Anonymous Inner Class**: Inline implementation without a named class.
  3. **Lambda Expression**: Concise syntax for functional interfaces.
  4. **Method Reference**: Reuse existing method implementations.

- **Assumptions**:
  - `B` class has `getX()` and `getY()` methods.
  - We assume `B` implements `Comparable` for default sorting.

### Lab Demos

#### 1. Using Explicit Outer Class for Ascending Order on `y` Property
Create a class `BYAscendingComparator` implementing `Comparator<B>`:

```java
class BYAscendingComparator implements Comparator<B> {
    @Override
    public int compare(B b1, B b2) {
        return b1.getY() - b2.getY();  // Ascending order
    }
}

// Usage in TreeSet
TreeSet<B> ts2 = new TreeSet<>(new BYAscendingComparator());
ts2.add(new B(5, 6));
ts2.add(new B(5, 7));
ts2.add(new B(5, 9));
ts2.add(new B(5, 4));
// Output: Objects sorted by y: 4, 6, 7, 9
```

#### 2. Using Anonymous Inner Class for Descending Order on `y` Property
```java
TreeSet<B> ts3 = new TreeSet<>((B b1, B b2) -> b2.getY() - b1.getY());  // Descending order

ts3.add(new B(4, 8));
ts3.add(new B(4, 1));
// ts3.add more objects...
// Output: Objects sorted by y descending: 8, 1, ...
```

> [!NOTE]  
> Anonymous inner classes allow one-time implementations without polluting the codebase with extra classes.

#### 3. Using Lambda Expression for Ascending Order on `y` Property
```java
TreeSet<B> ts4 = new TreeSet<>((b1, b2) -> b1.getY() - b2.getY());  // Ascending order

ts4.add(new B(5, 6));
ts4.add(new B(5, 4));
ts4.add(new B(9, 6));
ts4.add(new B(7, 6));
// Output: 4, 6, 6, 6 (sorted by y)
```

📝 **Lab Steps**:
1. Define the lambda: `(b1, b2) -> b1.getY() - b2.getY()`.
2. Pass to `TreeSet` constructor.
3. Add objects and verify sorting.

#### 4. Using Method Reference
Create a utility class with a compare method:

```java
class MethodReferenceComparator {
    public static int compareBY(B b1, B b2) {
        return b1.getY() - b2.getY();
    }
}

// Usage
TreeSet<B> ts5 = new TreeSet<>(MethodReferenceComparator::compareBY);

// If using existing comparator instance:
BYAscendingComparator comp = new BYAscendingComparator();
TreeSet<B> ts6 = new TreeSet<>(comp::compare);
```

For descending on `x`:

```java
class BXDescendingComparator implements Comparator<B> {
    @Override
    public int compare(B b1, B b2) {
        return b2.getX() - b1.getX();
    }
}

TreeSet<B> ts7 = new TreeSet<>(BXDescendingComparator::compare);
// Output: Sorted by x descending (e.g., 7, 6, 5)
```

✅ **Verification**: Ensure objects are sorted as expected. For ascending: small to large values, descending: large to small.

## Using Comparators for TreeSet

### Overview
`Comparator` is particularly useful with `TreeSet` for custom sorting. When `TreeSet` uses `Comparator`, it bypasses default `Comparable` and uses the provided comparison logic.

### Key Concepts/Deep Dive
- `TreeSet` and `TreeMap` are the only collections that support `Comparable`/`Comparator` for sorting.
- Pass `Comparator` in constructor for custom sorting.
- Default `Comparable` sorts by natural order (e.g., by `x` if implemented).

> [!IMPORTANT]  
> Use `Comparator` when you need multiple sorting orders or when objects don't implement `Comparable`.

### Lab Demos
Examples provided in the "Ways to Develop Custom Comparators" section demonstrate `TreeSet` usage with different `Comparator` implementations.

## Comparing Objects by Multiple Properties

### Overview
Sometimes objects need sorting where if one property is equal, a secondary property determines order. This requires chained comparison logic.

### Key Concepts/Deep Dive
- **Limitations**: Objects can only be sorted by one primary property, but logic can check secondary properties if primary values are equal.
- **Algorithm**: Compare primary property; if equal, compare secondary property.
- **Operators**: `&&` is not suitable (returns boolean); use arithmetic difference or conditional logic.

> [!WARNING]  
> Double `&&` operators don't work here because comparison methods return int, not boolean.

### Lab Demos
#### Example: Sorting by `x` then `y` (both ascending)

```java
TreeSet<B> ts8 = new TreeSet<>((b1, b2) -> {
    int xDiff = b1.getX() - b2.getX();
    if (xDiff == 0) {
        return b1.getY() - b2.getY();  // Secondary sort by y
    } else {
        return xDiff;  // Primary sort by x
    }
});

ts8.add(new B(5, 6));
ts8.add(new B(5, 4));
ts8.add(new B(4, 8));
ts8.add(new B(3, 3));
// Output: Sorted first by x (3, 4, 5, 5), then sub-sorted by y (4, 6, 8, 3)
// Note: In output sequence: (3,3), (4,8), (5,4), (5,6)
```

📝 **Lab Steps**:
1. Calculate primary difference (`xDiff`).
2. Check if primary is equal (0).
3. If equal, return secondary difference; else return primary.
4. Add objects and verify multi-level sorting.

⚠ **Common Issue**: Ensure no infinite loops; primary property variations must ensure unique ordering.

## Summary

### Key Takeaways
```diff
+ Comparable provides natural sorting; Comparator offers custom sorting flexibility.
+ Four ways to implement Comparator: explicit class, anonymous inner class, lambda, method reference.
+ Use Comparator in TreeSet constructor for custom ordering.
+ For multi-property sorting: check primary first, then secondary if equal.
- Avoid hardcoded logic in comparators; make them reusable.
! Both interfaces are functional since Java 8, enabling lambda use.
```

### Expert Insight
**Real-world Application**: In enterprise apps, use `Comparator` for dynamic sorting in data grids, e.g., sorting user lists by name, then by date. Implement as `@FunctionalInterface` for clean, testable code.

**Expert Path**: Master composition with `Comparator.comparing()` and chaining via `.thenComparing()` for multi-property sorts. Study `Collections.sort()` overloads for lists.

**Common Pitfalls**: 
- **Misspelling Corrections from Transcript**: "Treet" → TreeSet, "compar" → Comparable/Comparator, "meod" → method, "par" → param, "invo invo" → invokes, "jav util" → java.util, "pre set" → TreeSet, "curs ors" → cursors.
- **Lesser Known Things**: `Comparator` default methods like `reversed()` allow easy reverse sorting without rewriting logic. `nullsFirst()`/`nullsLast()` handle null values safely in production.
- **Potential Issues**: Arithmetic overflow in comparisons (use `Integer.compare()` for int values); resolution: Use `Long.compare()` or `Objects.compare()` for null-safe comparisons. Avoid inconsistent equals() with compare() to prevent TreeSet exceptions.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
