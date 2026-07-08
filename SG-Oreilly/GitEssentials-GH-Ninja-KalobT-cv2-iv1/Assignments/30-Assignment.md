<details open>
<summary><b> Session 30: Git Issues</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Exercise 1.1: Understanding GitHub Issues Purpose
**Objective**: Grasp that issues are conversation starters, not just bug reports

**Tasks**:
1. Document the three primary purposes of issues mentioned:
   - Bring a problem to light
   - Make a suggestion
   - Document a bug
2. Explain the difference between issues and bugs
3. Create examples of appropriate issue topics beyond bugs
4. Document the conversational nature of issues

**Documentation**:
```markdown
# Understanding GitHub Issues

## Primary Purposes
1. Problem Identification
   - Not necessarily broken code
   - Can be improvement opportunities
   - Enhancements and feature requests

2. Suggestions
   - Documentation improvements
   - User experience enhancements
   - Workflow optimizations

3. Bug Documentation
   - Actual defects in code
   - Reproduction steps needed
   - Expected vs actual behavior

## Beyond Bugs - Appropriate Topics
- Documentation typos or clarity issues
- Feature enhancement ideas
- Questions about usage
- Discussion topics about direction
- Good first issues for newcomers

## Conversational Nature
Issues foster community discussion and collaborative problem-solving
```

**Deliverable**: Comprehensive understanding of issues as collaborative tools

## Exercise 1.2: Explore Issue Components
**Objective**: Understand all elements that make up a GitHub issue

**Tasks**:
1. Document each component visible in the issue creation interface:
   - Title field
   - Description/comment area
   - Preview option for Markdown
   - Assignees
   - Labels
   - Projects
   - Milestones
2. Explain the purpose of each component
3. Identify which are required vs optional

**Component Analysis**:
```markdown
# GitHub Issue Components

## Required Elements
- Title: Clear, descriptive summary
- Description: Detailed explanation or discussion starter

## Optional Elements
### People
- Assignees: Team members responsible
- Multiple assignees supported

### Organization
- Labels: Categorization tags
  - Types: bug, documentation, enhancement
  - Custom labels possible
- Milestones: Project phases or releases
- Projects: Kanban/project board association

### Content Features
- Markdown support in description
- Preview functionality
- File attachments capability
```

**Deliverable**: Detailed component analysis with purposes and requirements

## Exercise 1.3: Label System Exploration
**Objective**: Understand and practice using GitHub's labeling system

**Tasks**:
1. Document common default labels in GitHub repositories
2. Create examples of appropriate label usage:
   - Bug reports
   - Documentation improvements
   - Good first issues
   - Enhancements
3. Explain how labels aid in issue management
4. Research custom label creation options

**Label Documentation**:
```markdown
# GitHub Label System

## Common Default Labels
- bug: Something isn't working
- documentation: Improvements or additions to documentation
- duplicate: This issue or pull request already exists
- enhancement: New feature or request
- good first issue: Good for newcomers
- help wanted: Extra attention is needed
- invalid: This doesn't seem right
- question: Further information is requested
- wontfix: This will not be worked on

## Label Best Practices
### For Issue Creators
- Choose 1-2 most relevant labels
- Be specific but not overly granular
- Consider label combinations

### For Repository Maintainers
- Create clear label descriptions
- Use consistent color coding
- Document label usage guidelines

## Label Combinations
- documentation + good first issue
- bug + help wanted
- enhancement + discussion needed
```

**Deliverable**: Comprehensive label system guide with usage examples

## Exercise 2.1: Create Well-Structured Issue Scenarios
**Objective**: Practice creating issues for various repository improvements

**Tasks**:
1. Create detailed issue scenarios for different purposes:
   - Documentation improvement issue
   - Feature suggestion issue
   - Bug report issue (even if fictional)
   - Question/discussion issue
2. For each, include:
   - Appropriate title
   - Clear description
   - Relevant labels
   - Proper assignee selection
3. Document the creation process

**Issue Creation Scenarios**:
```markdown
# Sample Issue Creations

## Issue 1: Documentation Improvement
Title: Improve installation instructions for clarity

Description:
The current installation steps in README.md skip several important prerequisites. New users are confused about:
1. Required system dependencies
2. Environment variable setup
3. Database configuration steps

Labels: documentation, good first issue
Assignee: [Yourself or appropriate maintainer]

## Issue 2: Feature Suggestion
Title: Add dark mode support to the web interface

Description:
Many users have requested dark mode functionality. This would:
- Reduce eye strain for night-time users
- Save battery on OLED displays
- Follow modern UI trends

Considerations:
- Should respect system preference
- Need theme switcher component
- Must maintain accessibility standards

Labels: enhancement, discussion
Assignee: Design team lead

## Issue 3: Bug Report (Template)
Title: Login fails intermittently on mobile Safari

Description:
## Steps to Reproduce
1. Open site on iOS Safari
2. Attempt to log in
3. Sometimes login fails with timeout error

## Expected Behavior
Login should complete within 2 seconds

## Actual Behavior
Login attempt times out after 30 seconds occasionally

Labels: bug, help wanted
Assignee: Mobile team
```

**Deliverable**: Collection of well-structured issue examples with rationale

## Exercise 2.2: Issue Management and Filtering
**Objective**: Master issue tracking and search capabilities

**Tasks**:
1. Document the filtering options in GitHub issues:
   - Status filters (open/closed/all)
   - Label filters
   - Assignee filters
   - Author filters
   - Milestone filters
2. Practice creating filter queries
3. Create saved filter views for common searches
4. Document search syntax and shortcuts

**Filter Documentation**:
```markdown
# GitHub Issues Filtering Guide

## Basic Filters
- `is:open` - Show only open issues
- `is:closed` - Show only closed issues
- `is:issue` - Ensure only issues (not PRs)

## Label Filters
- `label:bug` - Issues labeled as bugs
- `label:"good first issue"` - Good for newcomers
- `-label:question` - Exclude questions

## People Filters
- `assignee:@me` - Assigned to you
- `assignee:username` - Assigned to specific user
- `author:username` - Created by specific user
- `no:assignee` - Unassigned issues

## Combined Filters
- `is:open label:bug assignee:@me`
- `is:open label:"good first issue" no:assignee`
- `label:documentation label:"help wanted"`

## Search Syntax
- Use quotes for multi-word labels
- Combine with AND logic by default
- Use `-` to exclude terms

## Common Saved Views
1. My assigned issues: `is:open assignee:@me`
2. Unassigned bugs: `is:open label:bug no:assignee`
3. Documentation tasks: `is:open label:documentation`
```

**Deliverable**: Comprehensive filtering guide with practical examples

## Exercise 2.3: Issue Etiquette and Best Practices
**Objective**: Develop understanding of proper issue communication

**Tasks**:
1. Document the importance of politeness in open source
2. Create guidelines for:
   - Writing constructive issue descriptions
   - Responding to issue comments
   - Closing issues appropriately
3. Research and document conflict resolution approaches
4. Create templates for common issue interactions

**Etiquette Guidelines**:
```markdown
# GitHub Issues Etiquette Guide

## Writing Issue Descriptions
### Do
- Be specific and provide context
- Include reproduction steps for bugs
- Suggest solutions when possible
- Acknowledge the maintainers' efforts
- Use professional, respectful language

### Don't
- Demand immediate attention
- Use accusatory language
- Post duplicate issues without searching
- Include irrelevant information
- Spam or create noise

## Comment Best Practices
1. Stay on topic
2. Provide constructive feedback
3. Ask clarifying questions politely
4. Offer help when you can contribute
5. Respect differing viewpoints

## Closing Issues
- Provide clear reasoning
- Reference related commits/PRs
- Thank contributors appropriately
- Consider if further discussion is needed

## Acknowledgment Templates

### For Submitters
```
Thank you for taking the time to report this issue.
I've labeled it appropriately and will investigate.
```

### For Maintainers
```
I appreciate the work you've put into this project.
Here's a suggestion that might help improve...
```

### Conflict De-escalation
```
I understand this is frustrating. Let's work together
to find a solution that works for everyone.
```
```

**Deliverable**: Complete etiquette guide with communication templates

## Exercise 3.1: Cross-Referencing Issues and PRs
**Objective**: Understand the relationship between issues and pull requests

**Tasks**:
1. Document how issues and PRs can reference each other
2. Practice the syntax for creating automatic links:
   - `#issue-number` links to issues
   - Issue mentions in PR descriptions
   - PR references in issue comments
3. Create examples of proper cross-referencing
4. Document the benefits of linking related work

**Cross-Reference Documentation**:
```markdown
# Issues and Pull Requests Relationship

## Automatic Linking Syntax
- `#123` - Links to issue or PR #123
- `GH-123` - Alternative syntax for linking
- Full URLs also create links automatically

## Common Reference Patterns

### Issue Referencing PR
```
This issue will be resolved by #45
Related to pull request #67
```

### PR Referencing Issue
```
Fixes #123
Closes #456
Resolves #789
```

### Keyword Effects
- `Fixes/ Closes/ Resolves`: Auto-closes issue when merged
- `Related/ References`: Creates link without closing

## Benefits of Cross-Referencing
1. Traceability of work
2. Context for reviewers
3. Automatic status updates
4. Better project tracking
5. Reduced duplicate effort

## Example Workflow
1. Issue created: "Add user profile page (#100)"
2. Developer creates branch from issue
3. PR created referencing issue: "Implement user profiles (Fixes #100)"
4. Issue automatically links to PR
5. PR merged, issue auto-closed with reference
```

**Deliverable**: Comprehensive guide to issue-PR relationships with examples

## Exercise 3.2: Create Personal Issue Management System
**Objective**: Develop a systematic approach to using issues for personal projects

**Tasks**:
1. Create a personal project or use an existing one
2. Implement an issue-based project management system:
   - Create issues for all planned work
   - Use labels for prioritization
   - Assign milestones for releases
   - Track progress through issue status
3. Document your system and workflow
4. Create templates for common issue types in your project

**Personal System Documentation**:
```markdown
# Personal Issue Management System

## Project: [Your Project Name]

## Label Categories

### Priority Labels
- P0: Critical/Breaking
- P1: High Priority
- P2: Normal Priority
- P3: Low Priority/Backlog

### Type Labels
- feature: New functionality
- bug: Defect fix
- refactor: Code improvement
- docs: Documentation
- chore: Maintenance tasks

### Status Labels
- needs-triage: New, unclassified
- in-progress: Currently working
- blocked: Cannot proceed
- ready-for-review: Awaiting feedback

## Milestone Planning
- v1.0: MVP features
- v1.1: Enhancements
- v2.0: Major rewrite/refactor

## Workflow
1. Create issue for new task/idea
2. Apply appropriate labels
3. Assign to milestone
4. Move to in-progress when starting
5. Create PR referencing issue
6. Close issue on completion

## Templates

### Feature Request Template
```
## Feature Description
[What should this feature do?]

## Use Case
[Why is this needed?]

## Proposed Solution
[How should this be implemented?]

## Alternatives Considered
[Other approaches considered]
```

### Bug Report Template
```
## Bug Summary
[Brief description]

## Steps to Reproduce
1.
2.
3.

## Expected Behavior
[What should happen]

## Actual Behavior
[What actually happens]

## Environment
- OS:
- Browser:
- Version:
```
```

**Deliverable**: Complete personal issue management system with templates

## Exercise 3.3: GitHub Issues Across Platforms
**Objective**: Understand issues in the broader Git ecosystem

**Tasks**:
1. Research how issues work on different platforms:
   - GitHub Issues
   - GitLab Issues
   - Bitbucket Issues
2. Document similarities and differences
3. Identify common patterns across platforms
4. Create a compatibility guide for developers

**Platform Comparison**:
```markdown
# Git Ecosystem Issues Comparison

## GitHub Issues
- Integrated issue tracking
- Labels, milestones, projects
- Issue templates support
- Cross-references with PRs
- Mobile app support

## GitLab Issues
- Similar core functionality
- Epics for larger initiatives
- Issue boards (like Kanban)
- Time tracking features
- Confidential issues

## Bitbucket Issues
- Simpler interface
- Basic labeling
- Milestone support
- Less feature-rich than GitHub/GitLab

## Common Patterns
1. All support basic CRUD operations
2. Labeling systems are standard
3. Assignment to team members
4. Status tracking (open/closed)
5. Comments/discussion threads

## Portability Considerations
- Export/import capabilities
- API compatibility
- Migration tools available
- Data format standards

## Best Practice
Design issues to be platform-agnostic in content while leveraging platform-specific features
```

**Deliverable**: Cross-platform issues guide for ecosystem awareness

</details>
</details>