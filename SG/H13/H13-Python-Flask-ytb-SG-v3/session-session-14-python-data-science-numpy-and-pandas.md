# Session 14: Python Data Science NumPy and Pandas

## Table of Contents
- [Overview](#overview)
- [Understanding Python with Anaconda](#understanding-python-with-anaconda)
- [Deep Dive into Data Structures: Lists and Tuples](#deep-dive-into-data-structures-lists-and-tuples)
- [Introduction to NumPy: Arrays and Matrices](#introduction-to-numpy-arrays-and-matrices)
- [NumPy Operations: Mathematical Functions](#numpy-operations-mathematical-functions)
- [Introduction to Pandas: DataFrames](#introduction-to-pandas-dataframes)
- [Pandas Operations: Reading CSV Files](#pandas-operations-reading-csv-files)
- [Lab Demos](#lab-demos)
- [Summary](#summary)

## Overview
This session explores Python's role in data science, beginning with setup using Anaconda, then progressing into data structures like lists, their manipulation, and extending to advanced libraries: NumPy for numerical arrays and matrices, and Pandas for data manipulation in DataFrames. The focus is on practical operations, mathematical computations, and data import from files, providing foundational skills for data science tasks.

## Understanding Python with Anaconda
Python is a versatile programming language ideal for data science due to its simplicity and extensive libraries. Anaconda is recommended for environment management, providing pre-installed packages to avoid dependency issues.

- **Qualities of Python**: Readable syntax, extensive libraries, cross-platform compatibility.
- **Why Anaconda?**: Simplifies installation of data science tools like NumPy, Pandas, and visualization libraries.

### Key Concepts
- Install Anaconda for a streamlined setup that includes Jupyter Notebook for interactive coding.
- Subscribe to channels or resources for updates on Python programming.

## Deep Dive into Data Structures: Lists and Tuples
Lists are mutable data structures for storing collections of items. They're fundamental in Python for data handling.

- **Rolplat Lists**: Practical examples show how lists enable iteration and storage of variables.
- **Challenges in Lists**: Address multi-dimensional access and conversions.

### Tables: Data Types in Lists

| Data Type | Description | Example |
|-----------|-------------|---------|
| Integers  | Whole numbers, useful for counts | `[1, 2, 3]` |
| Strings   | Text data for names or categoricals | `['name1', 'name2']` |
| Floats    | Decimal numbers for measurements | `[1.0, 2.5]` |

- **Operations**: Append, convert to strings, iterate through elements.

### Mathematical Operations on Lists
- Identify mean, min, max, sum for numerical lists.

```diff
+ Positive: Lists are flexible for data storage
- Negative: Can be inefficient for large numerical computations
```

## Introduction to NumPy: Arrays and Matrices
NumPy provides arrays and matrices for efficient numerical computing. Arrays are multi-dimensional structures optimized for speed.

- **Shape and Indexing**: Arrays have dimensions; use indexing for access.
- **Matrix Representation**: Two-dimensional arrays for tabular data.

### Key Concepts
- Convert lists to NumPy arrays for better performance.
- Unicode support for international characters.

### Tables: Array vs List Comparison

| Feature     | NumPy Array | Python List |
|-------------|-------------|-------------|
| Performance | Faster for large data | Slower for computations |
| Memory      | Lower overhead | Higher for large lists |
| Operations  | Vectorized math | Manual loops required |

## NumPy Operations: Mathematical Functions
NumPy supports vectorized operations for scaleable math on arrays.

- **Basic Operations**: Sum, mean, min, max.
- **Example**: On an array `[1,2,3]`, mean is calculated directly.

```python
import numpy as np
arr = np.array([1, 2, 3])
print(np.mean(arr))  # Output: 2.0
```

- **Y-axis Operations**: Handle multi-dimensional calculations.

```diff
+ Positive: Enable complex mathematical models
- Negative: Steeper learning curve for beginners
```

## Introduction to Pandas: DataFrames
Pandas introduces DataFrames for structured data manipulation, similar to Excel spreadsheets.

- **Column Names**: Each column represents a field; rows are records.
- **Data Types in DataFrames**: Strings, numbers, dates.

### Key Concepts
- Create DataFrames from dictionaries or lists.
- Access columns by names like 'First Name'.

```python
import pandas as pd
df = pd.DataFrame({'First Name': ['John'], 'Age': [25]})
print(df)
```

## Pandas Operations: Reading CSV Files
Pandas excels at reading external data files like CSV for analysis.

- **CSV Structure**: First line as column headers, subsequent lines as data.
- **Reading Files**: Use `pd.read_csv()` with separators.

```bash
# Example command to read CSV
python -c "import pandas as pd; df = pd.read_csv('file.csv'); print(df)"
```

### Lab Demos
- **Demo 1: Convert List to DataFrame**
  1. Create a list.
  2. Use `pd.DataFrame()` to convert.
  3. Display columns.

- **Demo 2: Mathematical Operations on Arrays**
  1. Import NumPy.
  2. Create array from list.
  3. Calculate mean and sum.

- **Demo 3: Read CSV File**
  1. Prepare CSV file with columns.
  2. Use `pd.read_csv()`.
  3. Print first few rows.

## Summary

### Key Takeaways
```diff
+ Positive: Master NumPy for numerical computations and Pandas for data manipulation
+ Positive: Use lists for basic collections, arrays for efficiency
- Negative: Avoid large lists; prefer arrays for performance
! Alert: Ensure Anaconda is installed for seamless library management
```

### Quick Reference
- **Import Libraries**: `import numpy as np`, `import pandas as pd`
- **Create Array**: `arr = np.array([1,2,3])`
- **Read CSV**: `df = pd.read_csv('file.csv')`
- **Get Mean**: `np.mean(arr)`

### Expert Insight
**Real-world Application**: Applied in data cleaning, analysis for business intelligence, and predictive modeling in industries like finance and healthcare.
**Expert Path**: Deepen skills by practicing Kaggle datasets, learning vectorization for scalability, and integrating with ML libraries like Scikit-learn.
**Common Pitfalls**: Overusing lists for large data—switch to arrays early. Avoid Unicode errors by specifying encodings in file reads. Mistaken column access in DataFrames can lead to data loss.
**Lesser-Known Facts**: NumPy arrays are contiguous in memory for speed; Pandas AutoDetect data types but can be overridden for validation.

### Advantages vs Disadvantages
- **Advantages**: Python's ecosystem enables rapid prototyping; NumPy's speed and Pandas' ease for complex queries.
- **Disadvantages**: Memory intensive for huge datasets; initial setup steeper than R or Julia for pure stats.

<summary>
Model ID: KK-CS45-V3
</summary>
