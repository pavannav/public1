# Section 03: Basic Formatting

<details open>
<summary><b>Section 03: Basic Formatting (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [Basic Formatting in Markdown](#basic-formatting-in-markdown)
- [Level Headings](#level-headings)
- [Text Styling](#text-styling)
- [Quoting Text](#quoting-text)
- [Code Blocks](#code-blocks)
- [Links](#links)

## Basic Formatting in Markdown

### Overview
This module covers fundamental Markdown formatting techniques essential for creating well-structured documentation and README files on GitHub. The instructor demonstrates basic text formatting, structural elements, and hyperlink creation using standard Markdown syntax.

### Level Headings

Markdown supports six levels of headings using hash/pound symbols:

- **H1 (First level)**: Single `#` - Primary document title
- **H2 (Second level)**: Double `##` - Major section headers
- **H3 (Third level)**: Triple `###` - Subsection headers
- **H4-H6**: Additional heading levels (`####`, `#####`, `######`)

```
# First Level Heading (H1)
## Second Level Heading (H2)
### Third Level Heading (H3)
```

### Text Styling

#### Basic Text Formatting
- **Bold**: Double asterisks `**text**` or double underscores `__text__`
- **Italic**: Single asterisk `*text*` or single underscore `_text_`
- **Strikethrough**: Double tildes `~~text~~`

#### Nested Formatting
- **Bold with nested italic**: `**bold *italic* text**`
- **Subscript**: Not natively supported in standard Markdown
- **Superscript**: Not natively supported in standard Markdown

### Quoting Text

Block quotes are created using the greater-than symbol `>`:

```
> This is a quote block
> Useful for notes and references
```

### Code Blocks

Code blocks use triple backticks with optional language specification for syntax highlighting:

```markdown
```bash
# This is bash code
ls -la
```

```python
# This is Python code
print("Hello World")
```
```

### Links

Hyperlinks use square brackets for display text and parentheses for the URL:

```markdown
[Link Text](https://example.com)
```

- **Display text**: Content within square brackets `[]`
- **Destination URL**: Content within parentheses `()`

## Summary Section

### Key Takeaways
```diff
+ Markdown uses simple text-based syntax for rich formatting
+ Headings use # symbols (1-6 hashes for H1-H6)
+ Bold: ** or __ | Italic: * or _ | Strikethrough: ~~
+ Code blocks: triple backticks with optional language
+ Links: [text](url) format
```

### Quick Reference
| Format | Syntax | Example |
|--------|--------|---------|
| H1 | `# Heading` | Primary Title |
| H2 | `## Heading` | Section Header |
| Bold | `**text**` or `__text__` | **Bold text** |
| Italic | `*text*` or `_text_` | *Italic text* |
| Strikethrough | `~~text~~` | ~~Crossed out~~ |
| Code block | ` ```bash ` | Syntax highlighted |
| Link | `[text](url)` | [GitHub](https://github.com) |

### Expert Insight

**Real-world Application**: Markdown formatting is essential for GitHub README files, documentation, issues, and pull requests. Proper formatting improves readability and professionalism of GitHub repositories.

**Expert Path**: Master these basics before exploring advanced Markdown features like tables, task lists, and emoji support. Practice consistent formatting across all documentation.

**Common Pitfalls**:
- Inconsistent heading hierarchy
- Missing language specification in code blocks
- Broken links due to incorrect URL formatting
- Overusing complex nested formatting

**Lesser-Known Facts**: While headings go up to H6, most style guides recommend using only H1-H3 for better document structure. GitHub-flavored Markdown extends standard Markdown with additional features like task lists and emoji support.

</details>