# Section 44: Viewing Your Website

<details open>
<summary><b>44: Viewing Your Website (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [44.1 Accessing Your Published GitHub Pages Site](#441-accessing-your-published-github-pages-site)
- [44.2 Troubleshooting Common Issues](#442-troubleshooting-common-issues)
- [44.3 What's Next](#443-whats-next)

---

## 44.1 Accessing Your Published GitHub Pages Site

### Overview
Once your GitHub repository has been configured for GitHub Pages, GitHub automatically builds and deploys your website. This section demonstrates how to locate your published site URL and verify that your content is live.

### Key Concepts

#### Finding Your Published Site URL
After completing the GitHub Pages setup:

1. **Navigate to Settings**: Go to your repository settings page
2. **Scroll to GitHub Pages Section**: Located in the settings configuration area
3. **Locate the URL**: Look for the green success box that displays your published site URL in the format:
   ```
   https://[username].github.io
   ```
   > [!IMPORTANT]
   > The URL format is **always** `[username].github.io` (with `.github.io`), never `.com`

#### Verifying Your Content is Live

Once you click the published URL, you should see:

```diff
+ "Hello World" title displayed (matching your index.html)
+ Your HTML content rendered as a live website
+ Proof that your code was successfully deployed
```

**Success Indicators**:
- ✅ The page title matches "Hello World" (or your custom title)
- ✅ Your HTML content is visible and styled
- ✅ The site loads without errors

### Lab Demo: Accessing Your Published Site

**Step 1**: Navigate to repository settings
```
Repository → Settings → Scroll down to GitHub Pages section
```

**Step 2**: Click your published URL
```
https://[your-username].github.io
```

**Step 3**: Verify content matches your local files
- Compare the displayed title with your `index.html` `<title>` tag
- Confirm styling and content match expectations

---

## 44.2 Troubleshooting Common Issues

### Overview
If your GitHub Pages site doesn't load correctly, there are typically two primary causes: incorrect repository naming or deployment delays during the build process.

### Common Problems and Solutions

#### Problem 1: 404 Error Page Displayed

If navigating to your site shows a 404 error page, check for these issues:

| Issue | Description | Solution |
|-------|-------------|----------|
| **Typo in Repository Name** | Repository name doesn't exactly match `[username].github.io` | Rename repository in settings |
| **Site Still Building** | GitHub is processing your deployment behind the scenes | Wait a few minutes for CDN propagation |

#### Problem 2: Settings Show "Building from master" Message

The GitHub Pages settings may display:

```
"Your GitHub page is currently being built from master"
```

**This means**:
- Your site is in the deployment queue
- GitHub is configuring servers, CDNs, and DNS settings
- No action required from your end

> [!NOTE]
> GitHub handles all backend infrastructure automatically, including content delivery networks and server configurations.

#### Verification Checklist

Before reporting issues:

```diff
! Repository name exactly matches: [your-username].github.io
! Using .github.io (not .com) in the URL
! Waited at least 5-10 minutes after initial setup
! Checked both HTTP and HTTPS versions
```

### Deployment Timeline Expectations

| Phase | Duration | What Happens |
|-------|----------|--------------|
| Initial Build | 1-5 minutes | GitHub processes your repository |
| CDN Propagation | 2-10 minutes | Content distributed globally |
| DNS Resolution | Variable | Domain name resolves to your site |

---

## 44.3 What's Next

### Overview
After successfully viewing your basic GitHub Pages site, the next step involves enhancing its appearance using free themes.

### Upcoming Topics
- **Theme Selection**: Finding and applying free themes to improve visual design
- **Portfolio Development**: Creating a professional portfolio with multiple projects
- **Project Uploads**: Adding additional projects to your GitHub Pages site

---

## Summary

### Key Takeaways

```diff
+ GitHub automatically builds and deploys your site after Pages configuration
+ Your live URL format is always: https://[username].github.io
+ 404 errors typically indicate naming typos or deployment delays
+ The build process handles all server/CDN infrastructure automatically
+ Wait several minutes for initial deployment to complete
```

### Quick Reference

| Command/Action | Purpose |
|----------------|---------|
| Repository Settings → GitHub Pages | Locate your published site URL |
| `[username].github.io` | Correct repository naming convention |
| Wait 5-10 minutes | Allow initial deployment to complete |

### Expert Insight

**Real-world Application**:
- **Live Demonstrations**: Immediately share working prototypes with stakeholders
- **Portfolio Hosting**: Free, reliable hosting for professional portfolios
- **Project Documentation**: Host README files and project documentation as websites

**Expert Path**:
- Master GitHub Pages for quick deployment of static websites
- Learn to integrate CI/CD pipelines for automated deployments
- Explore custom domain configuration for professional branding

**Common Pitfalls**:
- ❌ Naming the repository `[username].github.com` instead of `.github.io`
- ❌ Not waiting for the initial build to complete before troubleshooting
- ❌ Forgetting that GitHub Pages requires the exact repository naming convention

**Lesser-Known Facts**:
- GitHub Pages includes automatic HTTPS certificates
- The service uses global CDNs for fast worldwide loading
- Build processes handle Jekyll automatically for static site generation
- Even simple HTML files trigger the full GitHub Pages infrastructure

</details>