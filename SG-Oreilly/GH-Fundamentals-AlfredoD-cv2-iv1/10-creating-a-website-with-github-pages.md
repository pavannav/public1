# Creating a Website with GitHub Pages

<details open>
<summary><b>Creating a Website with GitHub Pages (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Enabling GitHub Pages](#enabling-github-pages)
- [Build and Deployment Configuration](#build-and-deployment-configuration)
- [Understanding the Site URL Structure](#understanding-the-site-url-structure)
- [Viewing the Deployed Website](#viewing-the-deployed-website)
- [Monitoring Build Actions](#monitoring-build-actions)
- [Theme and Customization Options](#theme-and-customization-options)
- [Custom Domain Configuration](#custom-domain-configuration)
- [Key Takeaways](#key-takeaways)

## Overview
GitHub Pages is a free hosting service provided by GitHub that allows users to publish websites directly from their repositories. It can automatically convert repository content like README files into rendered HTML pages, providing users with a public-facing website without requiring additional web hosting services or domain costs.

## Enabling GitHub Pages
### Accessing Repository Settings
To enable GitHub Pages for any repository:
1. Navigate to the repository on GitHub
2. Click on the **Settings** tab (usually located in the top navigation)
3. Scroll down to find **Pages** in the left sidebar under the Code and automation section
4. Click on **Pages** to access the GitHub Pages configuration

### GitHub Pages Description
GitHub Pages is designed to host personal, organization, or project pages directly from a GitHub repository. This functionality is completely free and included as part of the standard GitHub platform with no additional costs.

## Build and Deployment Configuration
### Deployment Source Selection
When configuring GitHub Pages, you have two primary deployment methods:

1. **Deploy from a branch** (used in this tutorial)
   - Select the specific branch to deploy from
   - Choose the folder/path within that branch

2. **GitHub Actions**
   - Use custom workflows for more complex deployment scenarios
   - Allows for build steps and preprocessing

### Branch Configuration
- **Default branch**: Typically `main` or `master`
- **Alternative branches**: You can select any branch in your repository
- **Multi-branch benefit**: Useful for separating source code from generated content

### Folder/Path Selection
Two common options:
- **Root (`/`)**: Content at the root of the repository will be served
- **`/docs`**: Content within a `docs` folder will be served

> [!NOTE]
> When selecting the root path, GitHub will automatically convert README.md files to index.html for web display.

## Understanding the Site URL Structure
### Default URL Format
GitHub Pages generates URLs following this structure:
```
https://[username].github.io/[repository-name]
```

### URL Components
1. **Top-level domain**: `[username].github.io`
   - For organizations: Use the organization name instead of username
   - This is GitHub's provided subdomain

2. **Subdirectory**: `/[repository-name]`
   - Corresponds to the specific repository
   - Automatically appended to create a unique path

### Example URL
```
https://alfredodesada.github.io/python-bootcamp-duke
```

## Viewing the Deployed Website
### Initial Setup Indicators
- A notification message appears: "Your site is live at [URL]"
- A small orange dot indicates the site is being built
- The build process typically takes a few moments

### Website Rendering Behavior
- The README.md content is automatically rendered as a webpage
- Basic Markdown formatting is preserved
- Some GitHub-specific features may not render correctly:
  - Notes callouts
  - Important/tip/warning blocks
  - Certain emoji reactions
  - Interactive elements

## Monitoring Build Actions
### Accessing Build Logs
1. Click on the **Actions** tab in the repository
2. Look for workflow runs named **"pages build and deployment"**
3. Each deployment creates a new workflow run

### Understanding Automated Workflows
- GitHub automatically creates workflow files when GitHub Pages is enabled
- No manual GitHub Actions configuration is required for basic setups
- The workflow handles the conversion from Markdown to HTML
- Build status can be monitored in real-time

## Theme and Customization Options
### Default Theme
- GitHub Pages applies a default theme automatically
- The theme is clean and professional for documentation

### Theme Customization
- Access theme settings through the Pages configuration
- Options to change the visual appearance of the site
- Different themes available for various presentation styles

### Additional Configuration Options
- **Source branch selection**: Change which branch serves the site
- **Build folder**: Modify the root or docs folder setting
- **Custom domain**: Connect personal domains (see below)

## Custom Domain Configuration
### Domain Purchase and Connection
1. Purchase a domain from any domain registrar
2. In GitHub Pages settings, locate the **Custom domain** section
3. Enter your purchased domain
4. Configure DNS settings at your domain registrar:
   - Create appropriate CNAME or A records
   - Follow GitHub's DNS configuration guidelines

### Benefits of Custom Domains
- Professional appearance
- Branded URLs
- Easier to remember and share
- SEO advantages

## Key Takeaways
```diff
+ GitHub Pages provides free website hosting directly from repositories
+ Setup requires only repository settings configuration (no coding needed)
+ Default URLs follow the pattern: username.github.io/repository-name
+ README.md files are automatically converted to index.html
+ Build and deployment are handled automatically via GitHub Actions
+ Custom domains can be configured for professional branding
- Some GitHub-specific Markdown features may not render on the website
- Theme customization options are available for visual adjustments
```

</details>