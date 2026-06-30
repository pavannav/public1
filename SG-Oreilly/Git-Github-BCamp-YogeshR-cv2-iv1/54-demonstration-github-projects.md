# Demonstration: GitHub Projects

<details open>
<summary><b>Demonstration: GitHub Projects (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents

- [Overview](#overview)
- [Introduction to GitHub Projects](#introduction-to-github-projects)
- [Why Use GitHub Projects](#why-use-github-projects)
- [Creating a GitHub Project](#creating-a-github-project)
- [Project Templates and Layouts](#project-templates-and-layouts)
- [Adding Tasks and Issues](#adding-tasks-and-issues)
- [Managing Workflow Columns](#managing-workflow-columns)
- [Using Automation Features](#using-automation-features)
- [Summary](#summary)

## Overview

This demonstration introduces GitHub Projects, a built-in project management tool that integrates directly with GitHub repositories. The session covers creating projects, understanding different layouts, adding tasks as issues or draft cards, customizing workflow columns, and leveraging automation features to keep project boards synchronized with repository changes.

## Introduction to GitHub Projects

GitHub Projects serves as a customizable board for managing tasks, tracking progress, and organizing work directly alongside your repository. This feature provides a seamless project management experience without leaving the GitHub ecosystem.

### What Are GitHub Projects?

- Customizable boards for task management and progress tracking
- Direct integration with GitHub issues and pull requests
- Similar to external tools like Trello or JIRA but built into GitHub
- Enables planning sprints, tracking bugs, and organizing features in one place

### Integration Benefits

- Issues automatically appear as cards in project boards
- Pull requests can be linked and tracked within projects
- Changes in repository status can trigger automated board updates
- Eliminates context switching between different project management tools

## Why Use GitHub Projects

### Real-World Project Management Needs

In real-world development projects, teams typically need to:

- Organize tasks based on their status (To Do, In Progress, Done)
- Provide visibility into pending, active, and completed work
- Enable project managers and team leads to coordinate tasks effectively
- Track progress without leaving the development environment

### Visual Workflow Management

GitHub Projects provides:

- Kanban-style boards for intuitive task movement
- Clear visualization of work stages
- Drag-and-drop interface for status updates
- Customizable columns to match team workflows

## Creating a GitHub Project

### Accessing the Projects Tab

1. Navigate to your repository on GitHub
2. Click on the **Projects** tab at the repository header
3. GitHub provides a welcome interface with quick project creation options

### Project Creation Process

1. Click **New Project** button
2. Select from available templates or start from scratch
3. Choose your preferred layout (Board, Table, or Roadmap)
4. Specify a project name
5. Click **Create Project**

### Demo Example: Website Roadmap Project

In the demonstration, a project named "Website Roadmap" was created to manage website development tasks.

## Project Templates and Layouts

### Available Templates

GitHub provides several predefined templates:

- Team planning
- Kanban board
- Bug tracking
- Iterative development
- Product roadmaps
- Release tracking
- Custom templates for specific workflows

### Layout Options

#### Board View
- Functions like a Kanban board
- Tasks move across columns (To Do → In Progress → Review → Done)
- Visual representation of workflow stages
- Ideal for teams following agile methodologies

#### Table View
- Works like a spreadsheet interface
- Rows and columns for detailed tracking
- Supports custom fields and data organization
- Best for complex project tracking needs

#### Roadmap View
- High-level visualization of project timeline
- Shows milestones and deadlines
- Useful for product planning and release scheduling

## Adding Tasks and Issues

### Creating Issues from Projects

When adding new items to a project board:

1. Click **Add Item** or the **+** icon
2. Enter a title for the task
3. Choose between:
   - **Create as issue**: Creates a proper GitHub issue linked to the repository
   - **Create as draft**: Creates a placeholder card for future development

### Issue Configuration Options

When creating issues, you can:

- Add detailed descriptions
- Assign to team members
- Add labels (enhancement, bug, documentation)
- Link to milestones
- Set priorities and due dates

### Draft Cards

Draft cards are useful when:

- You want to capture ideas without creating formal issues
- Requirements are not yet fully defined
- Planning future work that may change
- Brainstorming features before implementation

### Demo Tasks Added

In the demonstration, three tasks were added to the "Website Roadmap" project:

1. "About page" - Created as a proper issue
2. "Deploy to production" - Created as a draft card
3. "Create contact us page" - Created as a draft card

## Managing Workflow Columns

### Default Columns

New projects start with three standard columns:

- **To Do**: Tasks that haven't been started
- **In Progress**: Tasks currently being worked on
- **Done**: Completed tasks

### Customizing Columns

You can enhance your workflow by:

1. Clicking the **+** icon to add new columns
2. Naming columns appropriately (e.g., "Review", "Testing", "Deployed")
3. Selecting colors for visual organization
4. Dragging columns to reorder them

### Drag-and-Drop Workflow

The demonstration showed practical task management:

1. Created "Review" column between "In Progress" and "Done"
2. Dragged "Contact us page" task from "To Do" to "In Progress"
3. Demonstrated moving tasks through workflow stages
4. Final workflow: To Do → In Progress → Review → Done

## Using Automation Features

### Automated Status Updates

GitHub Projects supports powerful automation that syncs with repository activities:

- New issues automatically appear in the "To Do" column
- Pull requests marked as "In Progress" move automatically
- Merged pull requests transition cards to "Done"
- Reduces manual updates and maintains board accuracy

### Benefits of Automation

- Keeps project boards synchronized with actual development work
- Eliminates the need for manual status updates
- Ensures team members see real-time progress
- Reduces administrative overhead for project management

## Summary

### Key Takeaways

```diff
+ GitHub Projects integrates project management directly into GitHub workflow
+ Multiple layout options support different project management styles
+ Issues and drafts can be created directly from project boards
+ Custom columns enable flexible workflow configurations
+ Automation features keep boards synchronized with repository changes
- Manual updates become unnecessary with proper automation setup
```

### Quick Reference

| Action | Steps |
|--------|-------|
| Create Project | Repository → Projects tab → New Project → Select template/layout |
| Add Task | Add Item → Enter title → Choose issue or draft → Configure details |
| Add Column | Click + icon → Name column → Select color → Save |
| Move Task | Drag card between columns |
| Automate | Configure automation rules in project settings |

### Expert Insight

#### Real-world Application
GitHub Projects excels in software development teams where issues, pull requests, and project planning need to coexist. It's particularly valuable for open-source projects, agile development teams, and organizations already invested in the GitHub ecosystem.

#### Expert Path
To master GitHub Projects:
- Explore automation rules for different workflow triggers
- Customize fields and views for team-specific needs
- Integrate with GitHub Actions for advanced automation
- Use project templates to standardize workflows across teams
- Leverage the GitHub API for custom integrations

#### Common Pitfalls
- Creating too many columns, which can complicate simple workflows
- Not utilizing automation features, leading to manual overhead
- Mixing draft cards and issues without clear governance
- Forgetting to configure automation rules when setting up new projects

#### Lesser-Known Facts
- GitHub Projects can be linked to multiple repositories simultaneously
- Custom fields support various data types including dates, numbers, and text
- Project views can be saved and shared with specific team members
- The API allows for programmatic project management and reporting

</details>