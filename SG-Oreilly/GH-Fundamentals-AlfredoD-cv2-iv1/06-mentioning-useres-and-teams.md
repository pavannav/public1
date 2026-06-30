<details open>
<summary><b>06-Mentioning-Users-And-Teams (KK-CS45-script-v2-Inst-v1)</b></summary>

# 06: Mentioning Users and Teams

## Table of Contents

- [Overview](#overview)
- [Mentioning Individual Users](#mentioning-individual-users)
- [Mentioning Organizations](#mentioning-organizations)
- [Mentioning Teams](#mentioning-teams)
- [Notification Behavior](#notification-behavior)
- [Use Cases and Best Practices](#use-cases-and-best-practices)
- [Summary](#summary)

## Overview

This session covers how to mention and notify users, organizations, and teams within GitHub using the `@` symbol in markdown. This feature is particularly useful when working with issues and pull requests to draw attention to specific people or groups for collaboration and issue resolution.

## Mentioning Individual Users

### How User Mentions Work

To mention another user, simply type the `@` symbol followed by their username. GitHub provides autocomplete functionality that suggests users as you type.

```markdown
@username
```

### Autocomplete Behavior

- GitHub automatically populates suggestions based on collaborators in the repository
- For repositories with multiple collaborators, all team members appear in the suggestion list
- The autocomplete feature makes it easy to find and select the correct user

### Visual Rendering

When previewed, mentioned usernames appear highlighted, making them stand out in the markdown rendering.

### Notification System

**Important Side Effect**: Mentioning a user triggers notifications:
- The mentioned user receives an email notification (based on their notification preferences)
- They receive in-app notifications within GitHub
- A typical notification message: "someone has mentioned you on this issue or pull request or this comment in this issue"

## Mentioning Organizations

### Organization Mention Syntax

You can mention entire organizations using the `@` symbol:

```markdown
@organization-name
```

### Organization Information Display

When hovering over an organization mention, GitHub displays:
- Organization name
- Repository count (e.g., "300 repositories")
- Member count (e.g., "10 members")

### Clickable Links

Organization mentions are clickable links that navigate to the organization's main page, allowing quick access to:
- All organization repositories
- Organization settings
- Team information

## Mentioning Teams

### Team Mention Syntax

For organizations, you can mention specific teams using this format:

```markdown
@organization/team-name
```

### Team Creation Requirements

**Note**: Team creation and management is only available for GitHub Organizations, not for personal repositories. To use team mentions:

1. Create an organization on GitHub
2. Set up teams within the organization
3. Add members to specific teams
4. Use team mentions in any comment, issue, or pull request

### Team Mention Benefits

- Notifies all team members simultaneously
- Useful for assigning tasks to specific groups
- Enables efficient collaboration within larger organizations

## Notification Behavior

### Where Mentions Work

Mentions are **pervasive** throughout GitHub and work in:
- Issue comments
- Pull request discussions
- Code review comments
- Commit messages
- Any markdown-supported text field

### Notification Delivery

Notifications are delivered based on user preferences:
- Email notifications (default behavior)
- Web notifications
- Mobile push notifications (if enabled)

## Use Cases and Best Practices

### Effective Mention Strategies

1. **Direct Assignment**: Use mentions to assign tasks or request reviews
2. **Team Escalation**: Mention teams for issues requiring specific expertise
3. **Stakeholder Updates**: Mention relevant users to keep them informed
4. **Code Review Requests**: Mention specific developers for targeted reviews

### Common Workflows

```markdown
Hey @reviewer-name, could you take a look at this PR?
@dev-team please review the authentication changes
@qa-team ready for testing on this feature
```

## Summary

### Key Takeaways

```diff
+ @username mentions notify individual users via email and in-app notifications
+ @organization mentions link to organization pages with member/repository stats
+ @organization/team mentions notify entire teams at once
+ Mentions work universally across issues, PRs, comments, and discussions
+ Only organizations support team creation and team mentions
- Personal repositories cannot use team features
```

### Quick Reference

| Mention Type | Syntax | Use Case |
|-------------|--------|----------|
| User | `@username` | Notify specific individual |
| Organization | `@org-name` | Link to organization, show stats |
| Team | `@org/team-name` | Notify entire team |

### Expert Insights

**Real-world Application**: In production environments, mentions are crucial for maintaining efficient workflows. Use team mentions for code reviews, user mentions for direct accountability, and organization mentions for cross-team collaboration.

**Expert Path**: Master the notification settings to control how you receive mentions. Create meaningful team structures that align with your organization's workflow. Use mentions strategically to avoid notification overload while ensuring critical stakeholders are informed.

**Common Pitfalls**:
- Overusing mentions can lead to notification fatigue
- Mentioning users in public repositories exposes their usernames
- Forgetting that team mentions only work in organization repositories

**Lesser-Known Facts**: Mentions can be used in commit messages, and the notification system respects users' custom notification schedules and preferences, so mentions sent outside working hours may be delivered differently.

</details>