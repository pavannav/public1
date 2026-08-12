# Chapter 10: Analyzing and Defining Business Processes

---

**THE PROFESSIONAL CLOUD ARCHITECT CERTIFICATION EXAM OBJECTIVES COVERED IN THIS CHAPTER INCLUDE THE FOLLOWING:**

- **4.2 Analyzing and defining business processes**

---

Architects perform a variety of roles, many of which tap into their technical skills and experience. Others require an understanding of business processes, especially regarding working with and influencing business decision-makers. Key business processes covered in this chapter:

- Stakeholder management
- Change management
- Team assessment/skill readiness
- Decision-making processes
- Customer success management
- Cost optimization/resource optimization (capex/opex)

---

## Stakeholder Management

A **stakeholder** is someone or some group with an interest in a business initiative. Types of stakeholders include employees, contractors, consultants, project managers, program managers, business process owners, compliance officers, external partners, and vendors.

### Interests and Influence

- **Interests** describe what a stakeholder wants.
- **Influence** describes the stakeholder's ability to get it.

**Types of interests:**

| Interest Type | Description |
|---|---|
| Financial | Costs and benefits of an initiative |
| Organizational | Priority in which projects will be funded and completed |
| Personnel | Assignment of engineers to a project, career advancement opportunities |
| Functional | Specific API functions or features another team wants included |

Stakeholders have varying degrees of influence:

- **Broad, significant influence** – project funders, team managers
- **Narrow, significant influence** – information security engineer (can block releases for security vulnerabilities but not other issues)
- **Marginal influence** – related-product teams who use the service but don't fund it

> Note: Some people have significant influence even without formal authority, through both formal business channels and informal personal channels.

Interest and influence should be understood relative to a particular initiative, ranging from project to portfolio levels.

### Projects, Programs, and Portfolios

Businesses implement strategies through initiatives organized in a common three-level hierarchy:

| Level | Description |
|---|---|
| **Project** | An initiative focused on completing an organizational task; has budget, schedule, and resources |
| **Program** | Designed to achieve a business goal; may span multiple departments and include multiple projects |
| **Portfolio** | Groups of projects and programs that collectively implement a business or organization's strategy |

**Example:** A financial institution's program to increase home equity loans may include:
- A marketing project to determine an advertising plan
- A software development project to update loan origination software

**Stakeholder influence by level:**

| Role | Project | Program | Portfolio |
|---|---|---|---|
| Project Manager | Significant | Moderate | Little/none |
| Senior VP (Portfolio owner) | Full (often delegated) | Full (often delegated) | Full |

### Stages of Stakeholder Management

The four basic stages of stakeholder management:

1. **Identifying stakeholders** – both obvious (business owner, security team) and less obvious (other engineering teams with functional interest)
2. **Determining their roles and scope of interests** – use formal project documentation and work with program/project managers
3. **Developing a communications plan** – may include project site updates, regular status meetings
4. **Communicating with and influencing stakeholders** – e.g., publishing white papers, holding feedback meetings

A **communications plan** is an important element of stakeholder management and also serves as a mechanism to influence stakeholders.

---

![note](../images/note_24.png)

- Architects often must influence stakeholders not just above them in the hierarchy but across all levels.
- For more on stakeholder management, see the Association for Project Management body of knowledge documentation, especially "Stakeholder Management":
  `www.apm.org.uk/body-of-knowledge/delivery/integrative-management/stakeholder-management`

---

## Change Management

Organizations, teams, and individuals frequently experience change. Change management methods exist to help navigate these transitions. As an architect, you may encounter change at all levels—individual, team, department, and enterprise.

### Reasons for Change

| Level | Examples |
|---|---|
| **Individual** | Self-directed: switching teams, new job, career change. External: company reorg, colleague departure |
| **Team/Department** | Team member turnover, management reassignment, competitive pressure |
| **Enterprise** | Autonomous vehicles disrupting automakers, social media disrupting traditional media, new manufacturing technologies |

**Additional drivers of change:**
- **Regulation** – HIPAA in US healthcare, GDPR in the EU
- **Economic factors** – e.g., the Great Recession (December 2007 – June 2009)
- **External/societal factors** – COVID-19 pandemic (adopted remote/hybrid work), extreme weather events

Understanding the reason for change helps architects understand stakeholders' interests and maintain a longer-term view beyond project implementation details.

---

### Digital Transformation

**Digital transformation** is the widespread adoption of digital technology to transform how companies create products and deliver value to customers. It typically involves:

- Web technologies
- Cloud computing
- Mobile devices
- Big data technologies
- IoT
- Artificial intelligence (AI)

According to a McKinsey & Company survey, digital transformations are more difficult to manage and less likely to succeed than other types of change. Common traits of successful digital transformation efforts:

- Knowledgeable leaders
- Ability to build workforce capabilities
- Enabling new ways of working
- Good communications

*Source:* `www.mckinsey.com/business-functions/organization/our-insights/unlocking-success-in-digital-transformations`

---

### Change Management Methodologies

The **Plan-Do-Study-Act (PDSA)** methodology was developed by Walter Shewhart (engineer and statistician) and popularized by W. Edwards Deming (engineer and management consultant). It is a reframed version of the scientific method for organizational management.

| Stage | Description |
|---|---|
| **Plan** | Develop a change experiment; make predictions; outline possible results |
| **Do** | Carry out the experiment; collect results |
| **Study** | Compare results to predictions; identify other learning opportunities |
| **Act** | Decide whether to use the results, e.g., change a workflow or implement a new standard |

Practitioners must decide what to measure, how to measure impact on individuals, and what criteria determine when to act.

---

![note](../images/note_24.png) For more on change management, see The W. Edwards Deming Institute Blog, especially "Change Management—Post Change Evaluation and Action":

`blog.deming.org/2018/11/change-management-post-change-evaluation-and-action`

---

## Team Skill Management

Architects are leaders who contribute to developing the skills of engineers, system administrators, engineering managers, and others involved in software development and operations.

**Architect contributions to team skill development:**

- Defining skills needed to execute programs and projects defined by organization strategy
- Identifying skill gaps on a team or in an organization
- Working with managers to develop plans to develop skills of individual contributors
- Helping recruit and retain people with the skills needed by the team
- Mentoring engineers and other professionals

---

## Customer Success Management

The goal of **customer success management** is to advance business goals by helping customers derive value from the products and services the company provides.

**Four basic stages of customer success management:**

| Stage | Description |
|---|---|
| **Customer Acquisition** | Engaging new customers; identifying potential customers via broad tactics (social network mining) or targeted tactics (collecting contacts from white paper downloads) |
| **Marketing and Sales** | Communicating with customers to convince them to engage; architects rarely involved unless in small orgs or complex enterprise software sales |
| **Professional Services** | Consulting services to help customers integrate purchased software/services with existing systems; architects may advise on integration and infrastructure design |
| **Training and Support** | Establishing training programs for customers; setting up support teams with tools for managing support calls and tracking customer issues |

---

![note](../images/note_24.png) For more on customer success management, see The Customer Success Association website:

`www.customersuccessassociation.com/library/the-definition-of-customer-success`

---

## Cost Optimization/Resource Optimization

**Cost management** begins with planning guided by business strategies and spans across four main areas:

| Stage | Description |
|---|---|
| **Resource Planning** | Identifying projects and programs that require funding; prioritizing needs; considering time required and relative benefit |
| **Cost Estimating** | Estimating costs of top-priority initiatives |
| **Cost Budgeting** | Allocating funds; stakeholders exercise influence; goal is to maximize overall benefit |
| **Cost Control** | Expending funds per approval processes; finance teams provide spending reports to managers |

**Types of costs to consider during cost estimating:**

- Human resources costs (salary and benefits)
- Infrastructure costs (cloud computing and storage)
- Operational costs (supplies)
- Capital costs (new equipment)

---

![note](../images/note_24.png) For more on project management and cost controls, see the Project Management Institute:

`www.pmi.org`

---

## Summary

Architects should have knowledge of business processes that affect their work, including:

- **Stakeholder management** – understanding interests and influence across project, program, and portfolio levels
- **Change management** – managing change at individual, team, department, and enterprise levels using methodologies like Plan-Do-Study-Act
- **Team skill development** – defining needed skills, identifying gaps, training, and recruiting
- **Customer success management** – from acquisition through professional services and support
- **Cost management** – resource planning, estimating, budgeting, and control

Successful organizations operate within a rational strategy that maps to a portfolio of programs and projects. Architects use their knowledge and influence to shape technical decisions and help manage organizational complexity.

---

## Exam Essentials

- **Know that stakeholder management involves the interests and influence of individuals and groups who are affected by a project or program.** There are different kinds of stakeholders with varying levels of influence. Know how to identify stakeholders, discover their interests, and understand how to communicate with them.

- **Understand that change management is particularly challenging.** Change can occur at individual, team, department, and enterprise levels. Change may be initiated internally or prompted by external factors. One methodology is Plan-Do-Study-Act.

- **Know that team skills are a resource that can be managed.** Architects understand skills needed to execute projects in the corporate portfolio and can identify gaps between needed skills and employees' skills. Use this knowledge to develop training and recruit additional team members.

- **Understand that customer success management is a key business process that may require some architecture consultations.** Early stages (acquisition, marketing, sales) rarely need architecture skills; later stages (professional services, technical support) may benefit from architect input.

- **Know the various aspects of cost management.** Main steps: resource planning, cost estimating, cost budgeting, and cost control. Architects are especially helpful with resource planning and cost estimating. Architects can use their influence to shape cost budgeting decisions.

---

## Review Questions

1. You have been asked to help with a new project kickoff. The project manager has invited engineers and managers from teams directly working on the project. They have also invited members of teams that might use the service to be built by the project. What is the motivation of the project manager for inviting these various participants?
   - A. To communicate with stakeholders
   - B. To meet compliance requirements
   - C. To practice good cost control measures
   - D. To solicit advice on building team skills

   **Answer: A**

2. A junior engineer asks you to explain some terms often used in meetings. In particular, the engineer wants to know the difference between a project and a program. How would you explain the difference?
   - A. There is no difference; the two terms are used interchangeably.
   - B. A project is part of a program, and programs span multiple departments; both exist to execute organizational strategy.
   - C. A program is part of a project, and projects span multiple departments; both exist to execute organizational strategy.
   - D. A project is used only to describe software development efforts, while a program can refer to any company initiative.

   **Answer: B**

3. An architect writes a post for an internal blog describing the pros and cons of two approaches to improving the reliability of a widely used service. This is an example of what stage of stakeholder management?
   - A. Identifying stakeholders
   - B. Determining their roles and scope of interests
   - C. Developing a communications plan
   - D. Communicating with and influencing stakeholders

   **Answer: D**

4. Your company provides a SaaS product used by mobile app developers to capture and analyze log messages from mobile devices in real time. Another company begins to offer a similar service but includes alerting based on metrics as well as log messages. This prompts the executives to change strategy from developing additional log analysis features to developing alerting features. This is an example of a change prompted by which one of the following?
   - A. Individual choice
   - B. Competition
   - C. Skills gap
   - D. Unexpected economic factors

   **Answer: B**

5. In May 2018, the EU began enforcement of a new privacy regulation known as the GDPR. This required many companies to change how they manage personal information about citizens of the EU. This is an example of what kind of change?
   - A. Individual choice
   - B. Competition
   - C. Skills gap
   - D. Regulation

   **Answer: D**

6. A program manager asks for your advice on managing change in projects. The program manager is concerned that there are multiple changes underway simultaneously, and it is difficult to understand the impact of these changes. What would you suggest as an approach to managing this change?
   - A. Stop making changes until the program manager can understand their potential impacts.
   - B. Communicate more frequently with stakeholders.
   - C. Implement a Plan-Do-Study-Act methodology.
   - D. Implement cost control measures to limit the impact of simultaneous changes.

   **Answer: C**

7. A company for whom you consult is concerned about the potential for startups to disrupt its industry. The company has asked for your help implementing new services using IoT, cloud computing, and AI. There is a high risk that this initiative will fail. This is an example of which one of the following?
   - A. Typical change management issues
   - B. A digital transformation initiative
   - C. A project in response to a competitor's product
   - D. A cost management initiative

   **Answer: B**

8. You and another architect in your company are evaluating the skills possessed by members of several software development teams. This exercise was prompted by a new program to expand the ways that customers can interact with the company. This will require a significant amount of mobile development. This kind of evaluation is an example of which part of team skill management?
   - A. Defining skills needed to execute programs and projects defined by organizational strategy
   - B. Identifying skill gaps on a team or in an organization
   - C. Working with managers to develop plans to develop skills of individual contributors
   - D. Helping recruit and retain people with the skills needed by the team

   **Answer: B**

9. You and an engineering manager in your company are creating a schedule of training courses for engineers to learn mobile development skills. This kind of planning is an example of which part of team skill management?
   - A. Defining skills needed to execute programs and projects defined by organizational strategy
   - B. Identifying skill gaps on a team or in an organization
   - C. Working with managers to develop plans to develop skills of individual contributors
   - D. Helping recruit and retain people with the skills needed by the team

   **Answer: C**

10. After training engineers on the latest mobile development tools and techniques, managers determine that the teams do not have a sufficient number of engineers to complete software development projects in the time planned. The managers ask for your assistance in writing job advertisements reaching out to your social network. These activities are an example of which part of team skill management?
    - A. Defining skills needed to execute programs and projects defined by organization strategy
    - B. Identifying skill gaps on a team or in an organization
    - C. Working with managers to develop plans to develop skills of individual contributors
    - D. Helping recruit and retain people with the skills needed by the team

    **Answer: D**

11. A team of consultants from your company is working with a customer to deploy a new offering that uses several services that your company provides. They are making design decisions about how to implement authentication and authorization and want to discuss options with an architect. This is an example of which aspect of customer success management?
    - A. Customer acquisition
    - B. Marketing and sales
    - C. Professional services
    - D. Training and support

    **Answer: C**

12. Customers are noticing delays in receiving messages from an alerting service that your company provides. They call your company and provide details that are logged into a central database and reviewed by engineers who are troubleshooting the problem. This is an example of which aspect of customer success management?
    - A. Customer acquisition
    - B. Marketing and sales
    - C. Professional services
    - D. Training and support

    **Answer: D**

13. As an architect, you have been invited to attend a trade conference in your field of expertise. In addition to presenting at the conference, you will spend time at your company's booth in the exhibit hall, where you will discuss your company's products with conference attendees. This is an example of what aspect of customer success management?
    - A. Customer acquisition
    - B. Marketing and sales
    - C. Professional services
    - D. Training and support

    **Answer: B**

14. A group of executives has invited you to a meeting to represent architects in a discussion about identifying projects and programs that require funding and prioritizing those efforts based on the company's strategy and needs. This is an example of what aspect of cost management?
    - A. Resource planning
    - B. Cost estimating
    - C. Cost budgeting
    - D. Cost control

    **Answer: A**

15. An engineer has been tasked with creating reports to help managers track spending. This is an example of what aspect of cost management?
    - A. Resource planning
    - B. Cost estimating
    - C. Cost budgeting
    - D. Cost control

    **Answer: D**
