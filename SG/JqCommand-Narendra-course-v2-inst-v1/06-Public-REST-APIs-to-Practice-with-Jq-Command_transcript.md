<details open>
<summary><b>06-Public-REST-APIs-to-Practice-with-Jq-Command (KK-CS45-script-v3-Inst-v1)</b></summary>

# Session 6: Public REST APIs to Practice with JQ Command

## Table of Contents

- [Overview](#overview)
- [Sources of JSON Data for JQ Practice](#sources-of-json-data-for-jq-practice)
- [Using Public REST APIs](#using-public-rest-apis)
- [Demo: Fetching and Formatting JSON](#demo-fetching-and-formatting-json)
- [Key Takeaways](#key-takeaways)
- [Quick Reference](#quick-reference)
- [Expert Insights](#expert-insights)

---

## Overview

This session demonstrates how to source JSON data for jq practice using publicly available REST APIs. Instead of manually creating JSON files, learners can leverage real-world REST endpoints that return JSON responses, providing authentic data for practice with curl and jq commands.

---

## Sources of JSON Data for JQ Practice

There are multiple approaches to obtaining JSON data for learning jq:

1. **Manual Creation**
   - Create text files and copy/paste JSON content
   - Useful for controlled, simple examples

2. **Command-Line Tools**
   - AWS CLI commands that output JSON
   - Other CLI tools that produce JSON responses

3. **Custom REST APIs**
   - Build your own REST endpoints
   - Full control over API responses

4. **Public REST APIs** ← Focus of this session
   - Freely available APIs for testing
   - Real-world JSON structures
   - No setup required

---

## Using Public REST APIs

Public REST APIs designed for testing JSON responses provide ideal practice material.

### Finding Public APIs

Search for **"public rest APIs for testing JSON"** in a web browser to discover testing endpoints.

### Popular Public API Resources

Common sources include:
- JSONPlaceholder (jsonplaceholder.typicode.com)
- ReqRes (reqres.in)
- HTTPBin (httpbin.org)
- JSONTest (jsontest.com)

### Benefits of Public APIs

- **Authentic Data Structures**: Real JSON schemas with nested objects and arrays
- **Varied Complexity**: Simple to complex response structures
- **No Authentication Required**: Most testing APIs are open access
- **Consistent Availability**: Reliable uptime for practice sessions

---

## Demo: Fetching and Formatting JSON

### Step-by-Step Process

1. **Open Browser** and navigate to a public REST API testing site

2. **Select an API Endpoint** and observe the JSON response in the browser

3. **Copy the API URL** from the browser

4. **Use curl in Terminal** to fetch the data:
   ```bash
   curl https://jsonplaceholder.typicode.com/posts/1
   ```

5. **Pipe output to jq** for formatting:
   ```bash
   curl https://jsonplaceholder.typicode.com/posts/1 | jq .
   ```

### Key Observations

- Raw curl output returns compact, minified JSON
- Using `jq .` (identity filter) formats and pretty-prints the JSON
- The identity filter `.` passes data through unchanged while applying formatting

---

## Key Takeaways

```diff
+ Public REST APIs provide free, authentic JSON data for jq practice
+ Search for "public rest APIs for testing JSON" to find practice endpoints
+ Use curl to fetch JSON responses from REST APIs
+ Pipe curl output to jq for formatting and exploration
+ The jq identity filter (.) formats JSON without transformation
```

---

## Quick Reference

| Task | Command |
|------|---------|
| Fetch JSON from REST API | `curl <api-url>` |
| Fetch and format JSON | `curl <api-url> \| jq .` |
| Search for public APIs | `"public rest APIs for testing JSON"` |

---

## Expert Insights

### Real-World Application

Public REST APIs are invaluable for:
- **Learning jq without setup overhead**: Start practicing immediately
- **Testing jq expressions safely**: Experiment with real data structures
- **Building confidence before production use**: Practice with representative data
- **Rapid prototyping**: Fetch sample data to test filter logic

### Expert Path

To master this approach:
1. Explore multiple public API providers to encounter diverse JSON structures
2. Document interesting API endpoints for future practice sessions
3. Progress from simple endpoints (single objects) to complex ones (nested arrays)
4. Combine with previous topics: use jq filters on real API responses
5. Build a personal library of jq expressions tested against public APIs

### Common Pitfalls

- **No internet access**: Public APIs require connectivity
- **API rate limits**: Some services may throttle excessive requests
- **API changes**: Public endpoints may modify their response structure over time
- **Assuming all APIs return JSON**: Always verify content-type headers

</details>