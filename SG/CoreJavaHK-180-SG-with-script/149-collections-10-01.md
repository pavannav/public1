# Session 149: Collections 10 - Retrieving and Searching Elements

- [Retrieving All Elements](#retrieving-all-elements)
- [Rules for the get Method](#rules-for-the-get-method)
- [Loop Conditions and Exceptions](#loop-conditions-and-exceptions)
- [Operations on Collections](#operations-on-collections)
- [Finding Capacity](#finding-capacity)
- [Finding Size](#finding-size)
- [Searching Elements](#searching-elements)
- [contains Method](#contains-method)
- [indexOf Method](#indexOf-method)
- [lastIndexOf Method](#lastindexof-method)

## Retrieving All Elements

To retrieve all elements from a collection, you need to use a loop. For a List (e.g., ArrayList), you can iterate through each element using an index-based loop with the `get` method.

Consider the following code example:

```java
ArrayList<Object> a1 = new ArrayList<>();
// Assume a1 has elements: "A", "B", "C", etc.

for (int i = 0; i < a1.size(); i++) {
    System.out.println(a1.get(i));
}
```

This outputs all elements sequentially: first element, second element, etc., without any exception.

The key is using the correct condition in the loop to avoid issues.

## Rules for the get Method

The `get(int index)` method retrieves a single object from the collection at the specified index. Here are the important rules:

1. **Index Must Be an Integer**: The parameter must be an integer type (primitive `int` or `Integer`).
2. **Valid Index Range**: The index must be >= 0 and < size. Passing an invalid index (negative or >= size) throws `IndexOutOfBoundsException`.
3. **Return Type Handling**: The method returns `Object`. If the collection uses generics (e.g., `ArrayList<String>`), assign to the generic type. Otherwise, assign to `Object`. For non-generic collections, calling methods on the returned object requires type casting, which may cause `ClassCastException`.
4. **Type Casting with Instanceof**: Always use `instanceof` before casting to avoid `ClassCastException`. In Java 14+, you can use pattern matching (preview feature - not for production use): `if (obj instanceof String str) { ... }`

Example with generics:

```java
ArrayList<String> list = new ArrayList<>();
String str = list.get(0);  // Direct assignment if generic
```

Without generics:

```java
ArrayList a1 = new ArrayList();
Object obj = a1.get(0);
if (obj instanceof String str) {
    System.out.println(str);  // Use str directly
}
```

> [!WARNING]
> Avoid using preview features like pattern matching in production code. They may change or be removed in future versions.

## Loop Conditions and Exceptions

When retrieving all elements in a loop, the condition is critical. Common mistakes can lead to exceptions or incomplete output.

- **Correct Condition**: `i < a1.size()` 
  - Outputs all elements from index 0 to size-1, no exception.

- **Incorrect Condition: `i <= a1.size()`**
  - Outputs all elements, but on the last iteration, `a1.get(a1.size())` throws `IndexOutOfBoundsException`.
  - Output: Elements 0 to size-1, then exception.

- **Avoiding Exception but Losing Element: `i < a1.size() - 1`**
  - Outputs elements 0 to size-2, misses the last element.

- **Wrong Index Usage**: Passing 0 instead of `i` in `get(0)` repeatedly outputs only the first element `size` times.

Example of correct usage:

```java
for (int i = 0; i < a1.size(); i++) {
    System.out.println(a1.get(i));
}
```

> [!IMPORTANT]
> Always use `i < size`, not `i <= size - 1` or `size - 1` in the loop header. Incorrect operators lead to bugs in exams and production.

## Operations on Collections

You can perform nine key operations on collections:

1. Finding capacity (using reflection APIs, as capacity methods are not standard in List interfaces)
2. Finding size (number of elements currently stored)
3. Displaying/printing elements
4. Adding elements (using `add` method with resizable array/growable array algorithms)
5. Retrieving elements (as discussed)

## Finding Capacity

Capacity is the number of elements a collection can store before resizing. Lists like ArrayList don't expose this directly; use reflection APIs.

Example using reflection:

```java
import java.lang.reflect.*;

ArrayList<String> list = new ArrayList<>();
try {
    Field field = list.getClass().getDeclaredField("elementData");
    field.setAccessible(true);
    Object[] elementData = (Object[]) field.get(list);
    System.out.println("Capacity: " + elementData.length);
} catch (Exception e) {
    e.printStackTrace();
}
```

This accesses the internal `elementData` array to get its length.

> [!NOTE]
> Reflection breaks encapsulation and is not recommended for regular use. Use it only when necessary.

## Finding Size

Size is the current number of elements. Use the `size()` method:

```java
int size = a1.size();
System.out.println("Size: " + size);
```

This returns the number of elements stored, not the capacity.

## Searching Elements

Searching involves checking if an element exists or finding its position. There are two types:

- **Availability Check**: Use `contains` to check if an element exists (returns boolean).
- **Index Finding**: Use `indexOf` or `lastIndexOf` to find the first or last index (returns int, -1 if not found).

Search operations rely on `equals()` for objects and `==` for null.

## contains Method

The `contains(Object obj)` method checks if the object is present in the collection.

- For objects: Uses `equals()` method.
- For null: Uses `==` operator.
- Returns `true` if found, `false` otherwise.
- No exception if the element is not found.

Example:

```java
ArrayList<Object> a1 = new ArrayList<>();
a1.add("A");
a1.add(5);
a1.add(null);

System.out.println(a1.contains("A"));    // true (via equals)
System.out.println(a1.contains(5));      // true (boxed Integer equals)
System.out.println(a1.contains(null));   // true (via ==)
System.out.println(a1.contains("Z"));    // false
```

In the example, searching for a new `Integer(5)` matches because `Integer` overrides `equals`.

> [!TIP]
> Custom classes must override `equals` and `hashCode` for proper searching.

## indexOf Method

`indexOf(Object obj)` returns the **first** index of the matching element, searching from index 0 onwards. Uses `equals()` for objects and `==` for null. Returns -1 if not found.

Linear search example (conceptual):

```java
public int indexOf(Object obj) {
    for (int i = 0; i < size; i++) {
        if ((obj == null && get(i) == null) || (obj != null && obj.equals(get(i)))) {
            return i;
        }
    }
    return -1;
}
```

Real usage:

```java
ArrayList<Object> a1 = new ArrayList<>();
// Assume elements: "A", 5, 7, null, 5

System.out.println(a1.indexOf("A"));    // 0
System.out.println(a1.indexOf(5));      // 1 (first occurrence)
System.out.println(a1.indexOf(null));   // 3
System.out.println(a1.indexOf("Z"));    // -1
```

It starts from index 0, compares each element until a match.

## lastIndexOf Method

`lastIndexOf(Object obj)` returns the **last** index of the matching element, searching from `size-1` downwards.

Example usage:

```java
ArrayList<Object> a1 = new ArrayList<>();
// Assume elements: "A", 5, 7, null, 5

System.out.println(a1.lastIndexOf(5));      // 4 (last occurrence)
System.out.println(a1.lastIndexOf(null));   // 3
System.out.println(a1.lastIndexOf("Z"));    // -1
```

It traverses from `size-1` to 0, returning the first match encountered (which is the last position).

> [!CAUTION]
> Both `indexOf` and `lastIndexOf` return -1 if the element is not found, without throwing exceptions.

## Summary

### Key Takeaways

```diff
! Rule 1: Use i < size for loop conditions to retrieve all elements without exception
! Rule 2: get method requires index >= 0 and < size; invalid indices cause IndexOutOfBoundsException
! Rule 3: contains returns boolean; indexOf/lastIndexOf return int (-1 if not found)
! Rule 4: Searching uses equals() for objects and == for null
+ For production: Always check instanceof before casting to avoid ClassCastException
- Avoid preview features like instanceof pattern matching in production code
+ Use generics to eliminate casting issues and potential exceptions
```

### Expert Insight

- **Real-world Application**: In microservices architectures (e.g., using Spring Boot), collections like `ArrayList` are used for in-memory data, but for large datasets, switch to databases. Searching with `contains` or `indexOf` is inefficient for big lists; consider `HashSet` for fast lookups if order doesn't matter.
- **Expert Path**: Master reflection for debugging (e.g., capacity analysis), implement custom `equals` for domain objects, and optimize searches by using `contains` first for existence checks before `indexOf`.
- **Common Pitfalls**: Mismatched types in generics lead to compile-time errors. Incorrect loop conditions cause runtime exceptions. Null comparisons fail unexpectedly if classes override `equals` incorrectly. Capacity and size are confused; size is what you query regularly.
- **Common Issues and Resolution**: 
  - **IndexOutOfBoundsException in Retrieval**: Check loop to use `< size`. To avoid: Always verify index bounds manually if needed.
  - **ClassCastException**: Use `instanceof` before cast. Avoidance: Use generics everywhere possible.
  - **Missing Last Element in Loop**: From using `i <= size - 1`. Resolution: Use `< size`.
  - **Incorrect Search Results**: Due to faulty `equals`. Resolution: Test and debug `equals` implementation first.
- **Lesser Known Things**: The `List` interface doesn't guarantee capacity methods; rely on vendor-specific ones (e.g., `ArrayList` has `ensureCapacity`). Index-based retrieval is O(1) but searching is O(n). `lastIndexOf` is useful for undo operations in stacks.

### Transcript Corrections Note
- Original transcript had numerous typos: "ript" should be "script", "al1" consistently as "a1" (ArrayList variable), "Al dot size" as "a1.size()", "out al1 do get of I" as "out.println(a1.get(i))", "rule number four here the rule is uh same index the condition operator must be less than not less than or equals to" as explaining loop operators correctly, various capitalization and punctuation issues corrected for clarity. Direct speech fragments were restructured into coherent paragraphs. Non-educational content (scheduling announcements, meeting IDs) was excluded from the study guide.<Event>
<summary>CL-KK-Terminal</summary>
</Event>
