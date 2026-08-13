# Assignments: AI Engineering Course

This document contains comprehensive interview questions and lab exercises for each chapter of the AI Engineering course. Questions are organized by experience level (Beginner, Intermediate, Advanced) and cumulative sections are provided for comprehensive review.

---

## Chapter 1: Introduction to Building AI Applications with Foundation Models

### Interview Questions by Experience Level

#### Beginner Level (0-2 years experience)

1. **What is a language model and how does it work?**
   - Explain the concept of tokens and vocabulary
   - Describe the difference between masked and autoregressive language models

2. **What is self-supervision and why is it important for training language models?**
   - Compare self-supervision with traditional supervised learning
   - Explain how self-supervision enables scaling of models

3. **What are foundation models and how do they differ from traditional ML models?**
   - Define foundation models
   - Explain multimodal models and their advantages

4. **What is AI engineering and how does it differ from traditional ML engineering?**
   - List the three main factors driving AI engineering growth
   - Explain the "model as a service" concept

5. **What are some common use cases for foundation models?**
   - Categorize use cases into at least 5 groups
   - Give examples of both consumer and enterprise applications

6. **What is tokenization and why do language models use tokens instead of words or characters?**
   - Explain the three main reasons for using tokens
   - Describe how GPT-4 tokenizes text

7. **What is the difference between pre-training, finetuning, and post-training?**
   - Define each term
   - Explain the resource requirements for each

8. **What are the three layers of the AI engineering stack?**
   - Name and briefly describe each layer
   - Explain which layer has seen the most growth recently

#### Intermediate Level (2-5 years experience)

1. **Explain the evolution from language models to foundation models.**
   - Trace the key technological breakthroughs
   - Discuss the role of self-supervision in enabling scale

2. **How do you evaluate whether an AI use case is worth pursuing?**
   - Discuss the risk-based framework for use case evaluation
   - Explain the concept of usefulness thresholds

3. **What factors should be considered when planning AI product development?**
   - Discuss the Crawl-Walk-Run framework
   - Explain the role of human-in-the-loop in AI systems

4. **How does prompt engineering differ from finetuning in model adaptation?**
   - Compare the resource requirements
   - Discuss when to use each approach

5. **What are the key differences between AI engineering and traditional ML engineering?**
   - Discuss the three major differences in approach
   - Explain implications for team composition and skills

6. **How do you measure the success of an AI application?**
   - List key business metrics and technical metrics
   - Explain the concept of defensibility in AI products

7. **What are the challenges in maintaining AI products over time?**
   - Discuss the fast pace of change in AI
   - Explain regulatory and compliance considerations

8. **Explain the concept of model as a service and its impact on AI development.**
   - Discuss how it lowers the barrier to entry
   - Explain implications for competitive advantage

#### Advanced Level (5+ years experience)

1. **Analyze the strategic implications of foundation models for enterprise AI adoption.**
   - Discuss the shift from task-specific to general-purpose models
   - Evaluate the buy-vs-build decision framework

2. **Design a comprehensive evaluation strategy for a customer support chatbot using foundation models.**
   - Define quality, latency, and cost metrics
   - Design a feedback collection system

3. **Evaluate the competitive landscape for AI engineering tools and platforms.**
   - Analyze GitHub star growth patterns
   - Discuss implications for technology choices

4. **Design a milestone-based development plan for an AI product from concept to production.**
   - Account for the "last mile challenge"
   - Include evaluation checkpoints and success criteria

5. **Analyze the impact of regulatory changes on AI product development and deployment.**
   - Discuss GDPR and other regulations
   - Evaluate IP and data ownership considerations

6. **Design an AI engineering team structure that balances application development and model adaptation needs.**
   - Define roles and responsibilities
   - Discuss skill requirements for different team members

7. **Evaluate the defensibility of different AI product architectures.**
   - Compare standalone products vs. embedded features
   - Analyze data moats and distribution advantages

8. **Design a framework for deciding when to use prompt engineering vs. finetuning vs. building custom models.**
   - Create decision trees with clear criteria
   - Include cost-benefit analysis considerations

### Cumulative Interview Questions (All Chapters)

#### Comprehensive Questions

1. **Design an end-to-end AI application architecture for a specific use case, from data collection to deployment and monitoring.**

2. **Compare and contrast the evaluation methodologies needed for different types of AI applications (chatbots, code generation, image generation, etc.).**

3. **Create a comprehensive training and adaptation strategy for a domain-specific AI application, including data requirements and evaluation criteria.**

4. **Design a production monitoring and feedback system that can handle the unique challenges of foundation model applications.**

5. **Evaluate the trade-offs between different model adaptation techniques (prompt engineering, RAG, finetuning) for a given use case.**

---

## Lab Exercises

### Chapter 1 Lab Exercises

#### Beginner Labs

**Lab 1.1: Tokenization Exploration**
- Use the OpenAI tokenizer to explore how different texts are tokenized
- Compare tokenization across different models (GPT-3.5, GPT-4, etc.)
- Analyze vocabulary sizes and their implications

**Lab 1.2: Foundation Model API Exploration**
- Sign up for OpenAI, Anthropic, or Google AI APIs
- Make basic API calls to different foundation models
- Compare responses to the same prompts across models

**Lab 1.3: Use Case Categorization**
- Research 10 AI applications from GitHub or app stores
- Categorize them using the framework from Table 1-3
- Identify patterns in successful applications

**Lab 1.4: Cost Analysis Exercise**
- Calculate the cost of different AI use cases using current API pricing
- Compare costs across different models and providers
- Estimate ROI for sample business scenarios

#### Intermediate Labs

**Lab 1.5: Prompt Engineering vs Finetuning Comparison**
- Implement a simple task using both prompt engineering and finetuning
- Measure performance, cost, and development time for each approach
- Document trade-offs and recommendations

**Lab 1.6: AI Product Planning Workshop**
- Choose a business problem and develop a complete AI product plan
- Include use case evaluation, success metrics, and milestone planning
- Present the plan with risk assessment and mitigation strategies

**Lab 1.7: Competitive Analysis**
- Analyze 3-5 AI startups in the same space
- Evaluate their defensibility and competitive advantages
- Identify potential moats and weaknesses

**Lab 1.8: Evaluation Framework Design**
- Design a comprehensive evaluation framework for a specific AI use case
- Include quality, latency, cost, and user satisfaction metrics
- Create measurement and monitoring procedures

#### Advanced Labs

**Lab 1.9: Enterprise AI Strategy Development**
- Develop a complete AI strategy for a fictional enterprise
- Include technology choices, team structure, and governance
- Address regulatory compliance and risk management

**Lab 1.10: AI Engineering Platform Architecture**
- Design a comprehensive AI engineering platform architecture
- Include all three layers: application, model, and infrastructure
- Address scalability, monitoring, and feedback collection

**Lab 1.11: Regulatory Impact Assessment**
- Analyze the impact of emerging AI regulations on product development
- Create compliance checklists and risk assessment frameworks
- Design processes for ongoing regulatory monitoring

**Lab 1.12: AI Team Building Simulation**
- Design an AI engineering team for a specific company size and focus
- Create job descriptions, skill matrices, and hiring plans
- Develop onboarding and continuous learning programs

---

*Note: All lab exercises should be completed with proper documentation, including code, results, analysis, and recommendations. Labs marked as "Advanced" may require access to enterprise resources or simulation environments.*