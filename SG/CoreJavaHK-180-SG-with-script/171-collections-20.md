# Session 171: Collections - Occurrence Counting

## Table of Contents
- [Overview](#overview)
- [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
- [Lab Demo: Implementing Occurrence Counting](#lab-demo-implementing-occurrence-counting)
- [Summary](#summary)

## Overview
In this session, we explore collections in Java by developing a program to count the number of occurrences of each element in an array. The focus is on using collection classes like LinkedHashMap for efficient storage and retrieval, while implementing a linear search algorithm to process the array elements. This exercise demonstrates fundamental concepts of collections, including maps for key-value storage, iteration techniques, and handling duplicates to maintain accurate counts while preserving insertion order.

## Key Concepts and Deep Dive

### Linear Search Algorithm for Element Counting
A linear search algorithm traverses a collection sequentially to find matches. In the context of occurrence counting:

- Start with the first element as the reference for comparison.
- Compare it against all subsequent elements.
- Increment the count for each match found.
- Move to the next unique element and repeat the process.

### Role of Collections: LinkedHashMap
- **LinkedHashMap**: A Map implementation that maintains insertion order, unlike regular HashMap which uses hash-based ordering.
- **Key-Value Structure**: Keys represent unique elements; values represent their occurrence counts.
- **Why LinkedHashMap?**: Ensures elements are displayed in the order they first appear in the array, from left to right.

### Handling Duplicates and Efficiency
- After processing all matches for an element, skip it in future iterations to avoid double-counting.
- Use `containsKey()` to check if an element is already in the map; if yes, skip processing it again.
- This approach ensures each unique element is counted only once per occurrence.

### Processing Steps
1. Declare a LinkedHashMap to store elements and their counts.
2. Iterate through the array using nested loops:
   - Outer loop: Pick each element as a potential unique element.
   - Inner loop: Compare the outer element with all succeeding elements to count occurrences.
3. For first occurrences, store with count 1; for subsequent matches, increment the count.
4. After counting, retrieve key-value pairs for display.

### Iterating and Displaying Map Contents
- Use `keySet()` to get all keys (elements) in insertion order.
- Iterate over the keys using an enhanced for-loop.
- For each key, retrieve its value (count) using `get()` and print it.

### Common Pitfalls
- Incorrect loop bounds in inner loop can lead to off-by-one errors or missing comparisons.
- Forgetting to check for existing keys can result in incorrect counting.
- Not preserving order (using HashMap instead of LinkedHashMap) may confuse users.

> [!NOTE]
> This implementation uses O(n^2) time complexity due to nested loops, suitable for small arrays. For larger datasets, consider using HashMap for counting without order requirements.

## Lab Demo: Implementing Occurrence Counting

In this demo, we'll implement a Java program to count occurrences of elements in an array like `[1, 2, 3, 1, 2, 3, 3, 4, 5, 3, 4, 76, 786]`. Expect output: 1: 2 times, 2: 2 times, 3: 3 times, 4: 2 times, 5: 1 time, 76: 1 time, 786: 1 time.

### Step-by-Step Implementation

1. **Import Required Classes** (if needed):
   ```java
   import java.util.LinkedHashMap;
   import java.util.Set;
   ```

2. **Declare and Initialize**:
   ```java
   public class OccurrenceCount {
       public static void main(String[] args) {
           int[] arr = {1, 2, 3, 1, 2, 3, 3, 4, 5, 3, 4, 76, 786};
           LinkedHashMap<Integer, Integer> lhm = new LinkedHashMap<>();
   ```

3. **Outer Loop for Each Element**:
   - Iterate over the array with index `i` from 0 to `arr.length - 1`.
   - For each `i`, initialize a `count = 1` for potential first occurrence.
   - Retrieve the current element: `int element = arr[i];`

4. **Check if Element Already Processed**:
   - If the element is already a key in the map (`lhm.containsKey(element)`), skip this iteration with `continue;`.
   - Otherwise, proceed to store it with `count = 1`.

5. **Inner Loop for Counting**:
   - For each `i`, start an inner loop with `j` from `i + 1` to `arr.length - 1`.
   - If `arr[i] == arr[j]`, increment `count`.
   - After inner loop, store the count: `lhm.put(element, count);`

6. **Display Results**:
   - Get the set of keys: `Set<Integer> keys = lhm.keySet();`
   - Iterate over keys and print each key-value pair.

### Full Code Example
```java
import java.util.LinkedHashMap;
import java.util.Set;

public class OccurrenceCount {
    public static void main(String[] args) {
        int[] arr = {1, 2, 3, 1, 2, 3, 3, 4, 5, 3, 4, 76, 786};
        LinkedHashMap<Integer, Integer> lhm = new LinkedHashMap<>();
        
        // Outer loop for each element
        for (int i = 0; i < arr.length; i++) {
            int element = arr[i];
            int count = 1;  // Initialize count
            
            // Check if already processed
            if (lhm.containsKey(element)) {
                continue;  // Skip if already counted
            }
            
            // Inner loop to count occurrences
            for (int j = i + 1; j < arr.length; j++) {
                if (arr[i] == arr[j]) {
                    count++;
                }
            }
            
            // Store the count
            lhm.put(element, count);
        }
        
        // Display results maintaining order
        Set<Integer> keys = lhm.keySet();
        for (Integer key : keys) {
            System.out.println(key + " = " + lhm.get(key));
        }
    }
}
```

- Run the code and verify output matches expected counts.

## Summary

### Key Takeaways
```diff
+ Use LinkedHashMap for ordered key-value storage in collections.
+ Implement nested loops for linear search: outer for selection, inner for counting.
+ Always check for existing keys to avoid reprocessing duplicates.
+ Retrieve keys via keySet() and iterate with enhanced for-loop for ordered display.
! Remember: This O(n^2) approach is inefficient for large arrays; optimize for production use.
- Avoid using HashMap if order preservation is needed.
```

### Expert Insight

#### Real-world Application
This technique is useful in data analysis for frequency distributions, log parsing, or word counting in text processing. In production, combine with streaming APIs or HashMap for efficiency in big data scenarios.

#### Expert Path
Master Java Collections API by practicing all Map implementations. Experiment with performance optimizations and compare time complexities to advance to expert level.

#### Common Pitfalls
- **Mismatch in Loop Bounds**: Ensure inner loop starts at `i + 1` to avoid self-comparison. **Resolution**: Double-check indexes; test with small arrays.
- **Forgetting Key Checks**: Leads to over-counting or incorrect updates. **Resolution**: Always add `containsKey()` and `continue;` for skips.
- **Order Loss**: Using HashMap ruins insertion order display. **Resolution**: Stick to LinkedHashMap for this requirement.
- Lesser Known Things: LinkedHashMap incurs slight overhead due to linked list, but ideal for small datasets where order matters. For concurrency, consider concurrentHashMap variants.
