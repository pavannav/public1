<details open>
<summary><b>Amazon Interview Tips - Sample AWS Question and Answer - STAR Method - Amazon Leadership Principles (KK-CS45-script-v2-Interview)</b></summary>

## Overview
This study guide covers Amazon interview preparation using the STAR method (Situation, Task, Action, Result) and incorporates Amazon's leadership principles. It demonstrates both bad and good answers to a common Amazon interview question about problem-solving with multiple solutions.

## Key Concepts

### STAR Method
- **Situation**: Overall objective or situation you're in - provide enough detail for interviewer to understand complexities
- **Task**: Goals you need to achieve
- **Action**: Steps taken to achieve the task with appropriate detail about your specific contribution
- **Result**: Outcome of your actions, what happened, what you accomplished, what you learned

### Common Confusions
- Situation vs Task distinction often causes confusion
- Be specific and avoid generalizations
- Use data/metrics to support statements

## Sample Question
**Question:** Tell me about a time when you were faced with a problem that had a number of possible solutions. What was the problem, how did you determine the course of action, and what was the outcome of that choice?

**Variations of this question:**
- Tell me one project that was difficult and that you achieved
- Tell me a time when you had to choose one technology amongst multiple and how did you choose it

## Amazon Leadership Principles to Incorporate
**Primary LPs for this question:**
1. **Learn and Be Curious** - When having multiple solutions, learn them and be curious about them
2. **Dive Deep** - Dive deep on each solution to determine course of action
3. **Deliver Results** - Ideally implement one solution to deliver results

**Additional related principles:**
- Bias for Action (overlap with delivering results)
- Frugality (cost-effectiveness)
- Invent and Simplify
- Ownership

## Bad Answer Analysis

**Bad Response:**
"I might've written our project to AWS serverless after considering Kubernetes and EC2. We call it the lambda, tested it, implemented DevOps, then deployed into prod and it was a huge success."

**Why this is bad:**

1. **Only covers Action** - Missing Situation and Task descriptions entirely
2. **Assumes interviewer knowledge** - Doesn't explain the project context since interviewer wasn't involved
3. **Lack of specific contribution** - Uses "we" throughout instead of stating personal actions
4. **Subjective claims without data** - "Huge success" is subjective with no supporting metrics
5. **No data/metrics** - Lacks quantifiable results

**Leadership Principles Covered:**
- **Deliver Results** - Mentioned applying to production (weakly demonstrated)

## Good Answer Example

### Situation
"We have 20 microservices running on-prem on a PCF (Pivotal Cloud Foundry). License needed to be renewed in six months. Leadership wanted the project to migrate to AWS before that to save cost and increase agility."

### Task
"As a lead architect developer/tech lead, I was tasked to find out suitable AWS solution within the timeframe given."

### Action
1. **Research phase**: "I researched possible ways to run microservices on AWS. I narrowed it down to three options: run each microservice on EC2, on Kubernetes using EKS, or serverless."

2. **POC demonstration**: "I took one of the microservices and did POC on all three: EKS, EC2, and Lambda + API Gateway."

3. **Analysis with data**:
   - **EC2 drawbacks**: "With EC2, I have to take care of making it highly available by spinning multiple EC2 in multiple AZs and there's overhead of my rehydration."
   - **Kubernetes drawbacks**: "EKS seems valid, however given traffic patterns, we'd pay more than necessary. Also overhead of training team on Kubernetes."
   - **Lambda advantages**: "Lambda + API Gateway is inherently highly available, scalable, pay-what-you-use, no server management. This simplifies day-to-day operational overhead."

4. **Additional benefits demonstrated**:
   - Cost-effectiveness thinking (Frugality LP)
   - Bias for Action through POC completion
   - Dive Deep demonstrated through pros/cons analysis

### Result
"Based on POC data - performance, cost, and time to deploy - I selected serverless solution. We converted rest of microservices to Lambda and implemented in production within three months."

**Quantifiable results:**
- "90% cost savings over EC2 and Kubernetes"
- "Delivered within three months"

**Beyond basic requirements:**
- "I shared my project learnings with other teams and showed them how to code Lambda"
- "Got recognized by CIO for this effort"

## Leadership Principles Demonstrated in Good Answer

1. **Learn and Be Curious**: Researched three different AWS solutions
2. **Dive Deep**: Conducted POC and analyzed pros/cons of each option
3. **Deliver Results**: Successfully migrated 20 microservices in 3 months with 90% cost savings
4. **Bias for Action**: Took initiative to do POC instead of just theoretical analysis
5. **Frugality**: Chose cost-effective solution based on traffic patterns
6. **Invent and Simplify**: Simplified operations by choosing serverless approach
7. **Ownership**: Went beyond day-to-day responsibilities by training other teams

## Key Takeaways

### Answer Structure Best Practices
- Always follow STAR method completely
- Be specific with data and metrics
- Focus on YOUR individual contribution ("I" vs "we")
- Take credit for your achievements
- Connect to relevant leadership principles

### Data-Driven Responses
- Replace subjective terms like "huge success" with quantifiable metrics
- Include performance numbers, cost savings, timeframes
- Provide context that allows interviewer to understand impact

### Connecting to Leadership Principles
- Identify which LPs the question is testing
- Weave relevant principles naturally into your answer
- Show overlap between related principles

</details>