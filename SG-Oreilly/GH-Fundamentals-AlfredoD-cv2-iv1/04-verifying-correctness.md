# Section 4: Verifying Correctness

<details open>
<summary><b>Section 4: Verifying Correctness (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [Overview](#overview)
- [4.1 Preview Feature for Markdown Editing](#41-preview-feature-for-markdown-editing)
- [4.2 Verifying Markdown in Issues](#42-verifying-markdown-in-issues)
- [4.3 Common Markdown Mistakes](#43-common-markdown-mistakes)
- [4.4 Preview Across GitHub Platform](#44-preview-across-github-platform)
- [Summary](#summary)

## Overview
This section covers how to verify Markdown correctness across the GitHub platform using the built-in preview functionality. The preview feature allows you to check your formatting in real-time without saving changes, making it easy to catch syntax errors before committing them. This applies to READMEs, issues, pull requests, and nearly everywhere Markdown can be written on GitHub.

## 4.1 Preview Feature for Markdown Editing

### Starting the Edit Process
When working with Markdown on GitHub, verification is essential to ensure correct syntax rendering. The preview feature works consistently across the platform:

- Click "Edit" on any Markdown file (like a README)
- Make changes in the raw Markdown editor
- Use the Preview button to check rendering without saving

### Workflow Pattern
The verification process follows a simple edit-preview cycle:

```diff
! Edit Mode → Write Markdown → Click Preview → Check Rendering → Back to Edit → Repeat
```

### Benefits of Preview
- **No Risk**: Changes aren't saved until you explicitly save
- **Instant Feedback**: See exactly how your Markdown will render
- **Easy Fixes**: Identify and correct formatting issues immediately
- **Anchor Testing**: Verify that headers become linkable anchors

## 4.2 Verifying Markdown in Issues

### Issue Comment Editing
The preview functionality works identically in GitHub issues:

- Open an issue to add or edit comments
- Write your Markdown content
- Click "Preview" to verify formatting
- Toggle between "Write" and "Preview" as needed

### Example Workflow in Issues
1. Start writing: `This text should be **bold**`
2. Click Preview to see the rendered result
3. If incorrect, switch back to Write mode
4. Correct the syntax and preview again

## 4.3 Common Markdown Mistakes

### Link Syntax Errors
One of the most common mistakes involves link formatting:

**Correct Syntax:**
```markdown
[helpful link](https://learn.microsoft.com)
```

**Incorrect (reversed) Syntax:**
```markdown
(helpful link)[https://learn.microsoft.com]
```

> [!WARNING]
> When link syntax is reversed, the link will not render correctly and may display as plain text.

### Markdown Syntax Confusion
- Single asterisks (*) create *italics*
- Double asterisks (**) create **bold** text
- Header levels: `#` = H1, `##` = H2, `###` = H3
- Headers automatically generate linkable anchors

## 4.4 Preview Across GitHub Platform

### Universal Availability
The preview feature is available almost everywhere Markdown is supported on GitHub:

- **README files**: Direct file editing with live preview
- **Issues**: Comment writing and editing
- **Pull Requests**: Description and comment sections
- **Wiki pages**: Content creation and updates
- **Release notes**: Formatting verification

### Real-Time Verification Benefits
> [!IMPORTANT]
> Always use the preview feature before saving, especially when:
> - Adding multiple links
> - Creating complex formatting
> - Working with unfamiliar Markdown syntax

## Summary

### Key Takeaways
```diff
+ Always use Preview before saving Markdown changes
+ The Write/Preview toggle works universally across GitHub
+ Common mistakes include reversed link syntax and incorrect emphasis markers
+ Headers automatically become linkable anchors for section linking
- Never assume Markdown will render correctly without verification
```

### Quick Reference
| Action | Result |
|--------|--------|
| Click "Preview" | Shows rendered Markdown without saving |
| Click "Write" | Returns to raw Markdown editor |
| Single `*text*` | Creates italic text |
| Double `**text**` | Creates bold text |
| `# Header` | Creates H1 with linkable anchor |

### Expert Insight

**Real-world Application**: In production environments, proper Markdown formatting ensures professional documentation, clear issue descriptions, and effective pull request communications. Always preview documentation that will be visible to users or stakeholders.

**Expert Path**: Master the preview workflow to become efficient at creating flawless documentation. Learn all Markdown syntax variations and practice the edit-preview cycle until it becomes second nature.

**Common Pitfalls**:
- Reversing link syntax (parentheses before brackets)
- Forgetting to close formatting markers
- Using single asterisks when double asterisks are intended
- Not verifying that headers generate proper anchors

**Lesser-Known Facts**: The preview feature preserves all your unsaved changes, allowing unlimited toggling between modes. Additionally, every header in GitHub-flavored Markdown automatically receives a unique anchor that can be used for direct linking to specific sections.

</details>