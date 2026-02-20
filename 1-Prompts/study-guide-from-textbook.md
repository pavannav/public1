---
description: Generate study notes from textbook HTML/TXT files with original explanations preserved
---

# Study Guide Generation Workflow

## Prerequisites
- Source file: HTML or TXT file saved from textbook (e.g., O'Reilly, Pearson)
- Output location: Directory for the generated study guide

## Step 1: Provide Source File
Tell the assistant:
```
Create study notes from this file: [path/to/source-file.html or .txt]
Save to: [output/directory/]
```

## Step 2: Choose Version Type

### Option A: Condensed Version (v2 style)
```
Create a condensed study guide that:
- Keeps ALL technical details, tables, and specifications
- Uses bullet points for quick reference
- Removes filler content (intro paragraphs, transitional sentences)
- Removes quiz questions and figure references
- Preserves all subheadings and topics
```

### Option B: Original Explanations Preserved (v3 style)
```
Create a study guide that:
- Preserves original explanations and definitions as-is
- Removes ONLY: quiz questions, figure references, book cross-references
- Keeps all technical paragraphs in their original wording
- Preserves all subheadings and topics
- Formats as clean markdown
```

## Step 3: Verify Completeness
After generation, ask:
```
Cross-reference the source file to ensure ALL topics and subheadings are included
```

## Example Prompts

### Quick Version
```
Create study notes from C:\path\to\chapter.txt
Keep original explanations, remove only quiz questions and figure references
Save as chapter-notes-v3.md
```

### Detailed Version
```
From the source file C:\path\to\book-chapter.html, create comprehensive study notes that:
1. Preserve all original technical explanations verbatim
2. Keep all tables, specifications, and cheat sheets
3. Remove: quiz questions, "Do I Know This Already" section, figure/image references
4. Include ALL subheadings (verify against source)
5. Format as clean GitHub-flavored markdown
6. Save to Z:\StudyGuides\
```

## Content to REMOVE
- "Do I Know This Already?" quiz sections
- Figure/image references (e.g., "as shown in Figure 8-6")
- Book cross-references (e.g., "as discussed in Chapter 7")
- Exam prep meta-text (e.g., "For the AWS Certified exam...")
- Caution/Note boxes about self-assessment
- Answer appendix references

## Content to KEEP
- All technical definitions and explanations
- All tables with specifications
- All cheat sheet bullet points
- All numbered/bulleted lists
- All Notes that contain technical information
- All subheadings and topic structure
- Key terms sections

## Definitions and Key Terms
- **Strictly preserve original definitions**: For all glossary terms, "Components" sections, or defined concepts (e.g., "Exporters", "Service Discovery"), use the **exact** phrasing from the book's introduction or detailed sections.
- Do not paraphrase or summarize these critical definitions, as they are essential for the "beginner's mental model."
- If the book provides both a summary bullet point and a detailed section, include both if they add context.

## Output Format
- GitHub-flavored Markdown (.md)
- Clear heading hierarchy (## for main topics, ### for subtopics)
- Tables preserved in markdown format
- Blockquotes (>) for important notes
- Bullet points for lists and cheat sheets
