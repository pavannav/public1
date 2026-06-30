# Session 55: Demonstration-GitHub-Wikis

<details open>
<summary><b>Session 55: Demonstration-GitHub-Wikis (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents

- [Overview](#overview)
- [55.1 GitHub Wiki Fundamentals](#551-github-wiki-fundamentals)
- [55.2 Creating Your First Wiki Page](#552-creating-your-first-wiki-page)
- [55.3 Wiki Editing and Formatting](#553-wiki-editing-and-formatting)
- [55.4 Adding Multiple Wiki Pages](#554-adding-multiple-wiki-pages)
- [55.5 Advanced Wiki Features](#555-advanced-wiki-features)
- [Summary](#summary)

## Overview

This session demonstrates GitHub Wikis, a powerful documentation feature that provides a dedicated space within repositories for creating organized, multi-page documentation. Unlike traditional README files, GitHub Wikis offer a comprehensive knowledge base solution with markdown support, navigation features, and the ability to clone documentation as a separate git repository.

## 55.1 GitHub Wiki Fundamentals

### What is a GitHub Wiki?

A GitHub Wiki is a dedicated documentation space inside a repository that serves as a knowledge base for your project. Rather than cramming all information into a single README file, wikis allow you to create structured, multi-page documentation.

### Key Benefits

- **Organized Documentation**: Create detailed guides, tutorials, and technical specifications
- **Markdown Support**: Full markdown formatting for clean, professional documentation
- **Better than README**: More flexible and scalable than single-file documentation
- **Open Source Friendly**: Essential for project growth and welcoming new contributors
- **Team Collaboration**: Ensures everyone knows how to set up, use, and contribute

### Use Cases

- Setup and installation guides
- User manuals and tutorials
- Technical specifications
- Contribution guidelines
- API documentation
- Project roadmaps

## 55.2 Creating Your First Wiki Page

### Navigation to Wiki

1. Navigate to your repository on GitHub
2. Click on the **Wiki** tab (located in the repository navigation)
3. Click **"Create the first page"** to begin

### Creating the Initial Page

When creating your first wiki page:

1. **Page Name**: Enter "Home" as the title
2. **Content**: Add a welcome message like:
   ```
   Welcome to my first repository Vicky

   Here you will find notes and resources about this project.
   ```
3. **Commit Message**: GitHub provides a default commit message ("Initial Home page")
4. **Save**: Click "Save page" to publish

### Result

After saving, you'll see:
- The wiki page titled "Home"
- An "Edit this page" link
- Information panel on the right side
- Options to edit the page or add new pages

## 55.3 Wiki Editing and Formatting

### Editor Features

The wiki editor provides multiple formatting options:

- **Headings**: Use `#` syntax (e.g., `# Getting Started`)
- **Horizontal Lines**: Visual separators between sections
- **Images**: Embed pictures directly in documentation
- **Text Formatting**: Bold and italic options
- **Code Snippets**: Include syntax-highlighted code blocks
- **Links**: Create hyperlinks to external resources or other pages

### Editing Modes

1. **Edit Mode**: Write content using Markdown syntax
2. **Preview Mode**: Click "Preview" to see how the page will appear when published

[Image: Wiki editor showing markdown editing mode with formatting toolbar]

### Commit Process

- Every change requires a commit message
- Default messages are provided but can be customized
- Changes are tracked with git version control

## 55.4 Adding Multiple Wiki Pages

### Creating Additional Pages

To expand your documentation:

1. Navigate to the existing wiki
2. Click **"Add a new page"** from the right sidebar
3. Enter a page name (e.g., "Contribution Guidelines")
4. Add relevant content with heading:
   ```
   # Follow these steps to contribute to this project
   ```
5. Provide a commit message (e.g., "Contribution guidelines")
6. Save the page

### Navigation Structure

Once multiple pages exist:
- All pages appear in the wiki sidebar
- Easy switching between pages
- Logical organization of related content

### Example Page Structure

```
Wiki Pages:
├── Home (default landing page)
├── Contribution Guidelines
├── Installation Guide
├── API Documentation
└── Troubleshooting
```

## 55.5 Advanced Wiki Features

### Custom Navigation

GitHub Wikis support enhanced navigation options:

- **Footer**: Add extra information at the bottom of all pages
- **Custom Sidebar**: Create tailored navigation for better user experience
- **Page Organization**: Logical grouping of related documentation

### Git Repository Integration

**Important**: Each wiki is actually its own git repository!

This provides powerful capabilities:

1. **Clone Locally**: `git clone [wiki-url]`
2. **Edit in Preferred Editor**: Use any text editor or IDE
3. **Push Changes**: Maintain documentation using familiar git workflows
4. **Better for Long Documents**: Ideal for technical or lengthy content

### Inter-Page Linking

Use standard markdown syntax to link between wiki pages:

```markdown
[Contribution Guidelines](Contribution-Guidelines)
```

This creates seamless navigation between related documentation sections.

## Summary

### Key Takeaways

```diff
+ GitHub Wikis provide structured, multi-page documentation beyond README capabilities
+ Full markdown support enables professional formatting with code, images, and links
+ Wikis are separate git repositories, allowing local editing and advanced workflows
+ Easy navigation through sidebar with custom footers and sidebars available
+ Perfect for project documentation, tutorials, and contributor guidelines
```

### Quick Reference

| Action | Location/Method |
|--------|-----------------|
| Access Wiki | Repository → Wiki tab |
| Create First Page | Click "Create the first page" |
| Add New Page | Right sidebar → "Add a new page" |
| Edit Page | Click "Edit this page" |
| Clone Wiki | `git clone [wiki-url]` |
| Link Pages | Standard markdown: `[Page Name](Page-Name)` |

### Expert Insight

**Real-world Application**: Use wikis for comprehensive project documentation including setup guides, API references, troubleshooting sections, and contribution workflows. Perfect for open source projects where clear documentation attracts contributors.

**Expert Path**: Start with a simple Home page, then expand systematically with related guides. Consider cloning the wiki locally for complex documentation projects that benefit from local editing tools and version control.

**Common Pitfalls**:
- Don't treat wikis as a replacement for README - use README for quick overview, wiki for detailed documentation
- Remember wiki pages are case-sensitive in URLs
- Don't forget to update the sidebar when adding many new pages

**Lesser-Known Facts**:
- Wiki repositories can have their own access permissions separate from the main repository
- You can disable wiki access entirely if not needed for specific repositories
- Wikis support GitHub Flavored Markdown with all advanced features

</details>