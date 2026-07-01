# Section 46: Adding Your Custom Projects

<details open>
<summary><b>46: Adding Your Custom Projects (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents

- [46.1 Overview](#461-overview)
- [46.2 Adding Local Projects to Portfolio](#462-adding-local-projects-to-portfolio)
- [46.3 Understanding Relative Paths](#463-understanding-relative-paths)
- [46.4 Creating Project Folders](#464-creating-project-folders)
- [46.5 Pushing Projects to GitHub](#465-pushing-projects-to-github)
- [46.6 Viewing Projects on GitHub Pages](#466-viewing-projects-on-github-pages)
- [46.7 Demonstrating Skills to Employers](#467-demonstrating-skills-to-employers)
- [46.8 Summary](#468-summary)

## 46.1 Overview

This session demonstrates how to add custom projects to a GitHub Pages portfolio, showing how to create a multi-page experience with separate project folders and link them together using relative paths. The process involves modifying the main portfolio's HTML, creating project directories with index.html files, and pushing everything to GitHub.

## 46.2 Adding Local Projects to Portfolio

The process begins with modifying the local `index.html` file to accommodate multiple projects:

**Modifying Portfolio Text:**
- Update the portfolio title if needed (e.g., "Caleb's Portfolio")
- Modify the descriptive text to reflect multiple projects (e.g., "View the things I've created")
- The changes are made in a local editor before pushing to GitHub

**Creating Multiple Navigation Buttons:**
- Replace single button with two buttons for different projects
- Remove JavaScript scroll triggers from buttons
- Add proper `href` attributes to make buttons functional links

Example button structure:
```html
<a href="modal/" class="btn">View My Modal</a>
<a href="calculator/" class="btn">View My Calculator</a>
```

## 46.3 Understanding Relative Paths

Relative paths are crucial for linking projects properly:

**Path Structure:**
- `./` or no prefix: Current directory
- `modal/`: Subfolder named "modal" in current directory
- Links should point to folders, not specific files
- GitHub Pages automatically looks for `index.html` in folders

**Path Display in Browsers:**
- Firefox: Shows directory listing or prompts for file selection
- GitHub Pages: Automatically loads `index.html` without showing directory

## 46.4 Creating Project Folders

**Local File System Setup:**

1. Create project folders in the same directory as `index.html`
   - Create folder named "modal"
   - Create folder named "calculator"

2. Each project folder must contain an `index.html` file
   - This ensures the project loads correctly when accessed

3. Copy project source code into respective folders
   - Include all HTML, CSS, and JavaScript files
   - Maintain proper file structure within each project

## 46.5 Pushing Projects to GitHub

**Git Commands Sequence:**
```bash
# Check status to see new files
git status

# Add all project files (excluding unnecessary files like .DS_Store)
git add index.html modal/ calculator/

# Commit with descriptive message
git commit -m "added projects"

# Push to remote repository
git push origin master
```

**Important Notes:**
- Hidden system files (like `.DS_Store` on Mac) may appear
- These files should not be added to the repository
- Git will show all new files in green when properly staged

## 46.6 Viewing Projects on GitHub Pages

**Verification Process:**
1. After pushing, wait for GitHub Pages to rebuild
2. Navigate to your GitHub Pages URL (username.github.io)
3. Refresh the page to see updated buttons
4. Click project buttons to verify they load correctly

**Project Accessibility:**
- Each project folder becomes accessible via the browser
- Projects maintain their own styling and functionality
- Source code remains visible in the repository

## 46.7 Demonstrating Skills to Employers

**Portfolio Advantages:**
- Repository structure shows organization skills
- Source code visibility demonstrates coding ability
- Multiple projects showcase versatility

**Specific Examples of What Employers Look For:**
- Modern JavaScript usage indicates current skill level
- CSS techniques like gradients and box shadows show design knowledge
- Complete, working projects prove practical application skills

**Source Code Visibility Example:**
- HTML structure shows semantic markup understanding
- Any JavaScript reveals coding practices
- CSS demonstrates styling capabilities

## 46.8 Summary

This session covered the complete workflow for adding custom projects to a GitHub Pages portfolio. Key steps include modifying the main index.html with proper relative links, creating project folders with index.html files, avoiding common pitfalls with hidden files, and pushing everything to GitHub. The result is a professional portfolio that showcases multiple projects with accessible source code for potential employers to review.

> [!IMPORTANT]
> Always ensure each project folder contains an `index.html` file for GitHub Pages to serve correctly.

</details>