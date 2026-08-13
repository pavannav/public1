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

## Chapter 2: Understanding Foundation Models

### Interview Questions by Experience Level

#### Beginner Level

##### Conceptual Questions
1. **What is a foundation model and how does it differ from traditional machine learning models?**
   - Explain that foundation models are trained on vast amounts of data and can be adapted for various downstream tasks, unlike traditional models trained for specific tasks.

2. **Why is training data so important for foundation models?**
   - A model can only learn what is present in its training data. If certain languages, domains, or concepts aren't represented, the model cannot perform well on those.

3. **What is the difference between pre-training and post-training?**
   - Pre-training builds the model's basic capabilities using self-supervision. Post-training aligns the model with human preferences through SFT and preference tuning.

4. **What does the term 'parameters' refer to in the context of foundation models?**
   - Parameters are the weights in the neural network that the model learns during training. More parameters generally mean more capacity to learn.

5. **What is the transformer architecture and why is it important?**
   - The transformer architecture, introduced in 2017, uses attention mechanisms to process sequences in parallel, becoming the dominant architecture for language models.

##### Practical Questions
6. **How would you explain to a non-technical stakeholder why English performs better than other languages in most AI models?**
   - English dominates internet data (45.88% of Common Crawl), so models have more English examples to learn from compared to other languages.

7. **What are some examples of domain-specific foundation models?**
   - AlphaFold for protein structures, BioNeMo for biomolecular data, Med-PaLM2 for medical queries.

8. **Why might a company choose to finetune a general model rather than train a domain-specific model from scratch?**
   - Finetuning is more cost-effective and leverages the knowledge already learned by the general model while adding domain-specific capabilities.

#### Intermediate Level

##### Technical Questions
9. **Explain the attention mechanism in transformers. How do query, key, and value vectors work together?**
   - The attention mechanism uses dot products between query and key vectors to determine how much attention to give to each value vector, allowing the model to weigh the importance of different tokens.

10. **What is the difference between top-k and top-p sampling? When would you use each?**
    - Top-k selects from a fixed number (k) of most likely tokens. Top-p (nucleus sampling) dynamically selects tokens whose cumulative probability exceeds threshold p. Top-p is better for maintaining contextual relevance.

11. **How does temperature affect model output? Provide examples of when you would use different temperature values.**
    - Temperature redistributes probabilities - higher values increase creativity by boosting rare tokens, lower values increase consistency. Use temperature 0.7 for creative tasks, 0 for deterministic outputs.

12. **Explain the Chinchilla scaling law and its implications for training models.**
    - The Chinchilla scaling law states that for compute-optimal training, you need approximately 20 training tokens per model parameter. This guides decisions on model size vs. dataset size.

13. **What are the key differences between RLHF and DPO for preference finetuning?**
    - RLHF uses a separate reward model and PPO optimization. DPO directly optimizes the model using preference data without a separate reward model, making it simpler but less flexible.

##### Architecture Questions
14. **Compare the transformer architecture with alternative architectures like Mamba and RWKV.**
    - Transformers use attention (quadratic complexity). Mamba uses state space models with linear complexity for long sequences. RWKV combines RNN efficiency with transformer-like capabilities.

15. **How does mixture-of-experts (MoE) architecture work and what are its benefits?**
    - MoE models divide parameters into "experts" where only a subset is active for each token. This allows larger total parameters with similar computational cost to smaller dense models.

16. **Explain the difference between prefill and decode phases in transformer inference.**
    - Prefill processes input tokens in parallel to create initial key/value states. Decode generates output tokens sequentially, using previous outputs as input.

#### Advanced Level

##### Deep Technical Questions
17. **Derive the attention formula: Attention(Q,K,V) = softmax(QK^T/√d)V. Explain each component and why the scaling factor is important.**
    - The dot product computes similarity, division by √d prevents vanishing gradients for large dimensions, softmax normalizes to probabilities, and multiplication by V produces the weighted output.

18. **How would you implement constrained sampling for generating valid JSON output?**
    - Implement a grammar-based approach that filters logits at each step to only allow tokens that maintain valid JSON structure, using tools like guidance or outlines.

19. **Explain the mathematical formulation of the RLHF reward model training objective.**
    - The objective maximizes the difference between scores for winning and losing responses: -E[log(σ(rθ(x,yw) - rθ(x,yl)))], where σ is the sigmoid function.

20. **What are the computational and memory implications of increasing context length in transformers?**
    - Memory scales quadratically with sequence length due to attention matrix. KV cache also grows linearly. Solutions include sparse attention, state space models, or efficient attention variants.

##### Research-Level Questions
21. **Discuss the two hypotheses for why language models hallucinate and potential mitigation strategies.**
    - Self-delusion: models can't differentiate their generated tokens from input. Knowledge mismatch: models learn to output labeler knowledge they don't have. Mitigation includes verification systems and better reward functions.

22. **How would you design an experiment to determine if a model has developed emergent abilities?**
    - Systematically test capabilities across model sizes, control for training data and compute, use multiple random seeds, and verify that abilities truly emerge rather than gradually improve.

23. **Analyze the trade-offs between model scale, data quality, and inference cost for production deployments.**
    - Larger models perform better but cost more to run. High-quality smaller models can outperform poorly trained larger models. Consider inference demand when choosing model size (Sardana et al., 2023).

### Cumulative Questions (Building on Chapter 1)

24. **How does understanding foundation model architecture help in designing better AI applications?**
    - Architecture knowledge helps choose appropriate models, optimize performance, understand limitations, and design effective prompting and finetuning strategies.

25. **Connect the concepts of model training (Chapter 1) with sampling strategies (Chapter 2). How do they together affect application performance?**
    - Training determines what the model can potentially do; sampling determines how it expresses that capability. Poor sampling can make a well-trained model perform poorly.

26. **Given the challenges with multilingual performance, how would you design a global AI application?**
    - Consider translation pipelines, language-specific fine-tuning, tokenization efficiency, cost implications for different languages, and potential biases in non-English outputs.

### Lab Exercises

#### Lab 1: Exploring Tokenization Across Languages
**Objective**: Understand how different languages require different numbers of tokens for the same content.

**Tasks**:
1. Use the tiktoken library to tokenize the same sentence in English, Hindi, Burmese, and Spanish
2. Calculate the token ratio compared to English
3. Analyze the cost and latency implications for a production API
4. Document findings in a report

**Deliverables**:
- Tokenization comparison table
- Cost analysis for processing 1M tokens in each language
- Recommendations for handling multilingual applications

#### Lab 2: Sampling Strategy Experiments
**Objective**: Experiment with different sampling parameters and observe their effects.

**Tasks**:
1. Set up a simple text generation script using Hugging Face Transformers
2. Generate text with temperatures: 0.1, 0.5, 0.7, 1.0, 1.5
3. Generate text with top-k values: 10, 50, 100, 500
4. Generate text with top-p values: 0.5, 0.9, 0.95, 0.99
5. Create a qualitative analysis of the outputs

**Deliverables**:
- 20+ generated text samples with different parameters
- Analysis of creativity vs. coherence trade-offs
- Guidelines for choosing sampling parameters for different use cases

#### Lab 3: Building a Simple Reward Model
**Objective**: Understand the mechanics of training a reward model for RLHF.

**Tasks**:
1. Create a synthetic dataset of (prompt, response_a, response_b, preference) tuples
2. Fine-tune a small model (e.g., DistilBERT) as a reward model
3. Implement the ranking loss function
4. Evaluate the model's ability to rank responses correctly
5. Visualize the learned reward distributions

**Deliverables**:
- Working reward model implementation
- Training and validation curves
- Analysis of model decisions on edge cases

#### Lab 4: Domain-Specific Model Analysis
**Objective**: Analyze how domain-specific models differ from general models.

**Tasks**:
1. Compare outputs from a general model (GPT-3.5) vs. a domain-specific model (if available) or a fine-tuned model
2. Create test cases in the target domain (e.g., medical, legal, coding)
3. Measure performance differences quantitatively and qualitatively
4. Document the fine-tuning process requirements

**Deliverables**:
- Comparative analysis report
- Performance metrics table
- Cost-benefit analysis of domain-specific vs. general models

#### Lab 5: Structured Output Implementation
**Objective**: Implement multiple approaches for generating structured outputs.

**Tasks**:
1. Implement JSON generation using:
   - Prompting with examples
   - Post-processing and validation
   - Constrained sampling with guidance library
   - Fine-tuning approach (document only)
2. Create test cases with increasing complexity
3. Measure success rates and latency for each approach
4. Handle error cases and edge conditions

**Deliverables**:
- Working implementations of 3 approaches
- Benchmark results table
- Production recommendations document

#### Lab 6: Scaling Law Visualization
**Objective**: Understand the relationship between model size, data, and compute.

**Tasks**:
1. Create visualizations of the Chinchilla scaling laws
2. Calculate optimal model size for different compute budgets
3. Analyze real model configurations against scaling law predictions
4. Create a simple calculator for estimating training costs

**Deliverables**:
- Interactive visualization or dashboard
- Cost estimation tool
- Analysis report on deviations from scaling laws

#### Lab 7: Hallucination Detection System
**Objective**: Build a system to detect and mitigate hallucinations.

**Tasks**:
1. Create a dataset of questions with known answers and potential hallucinations
2. Implement multiple detection approaches:
   - Self-consistency checking
   - Source verification
   - Confidence scoring
3. Evaluate detection accuracy
4. Implement mitigation strategies

**Deliverables**:
- Hallucination detection system
- Evaluation metrics and results
- Best practices documentation

#### Lab 8: Multilingual Performance Analysis
**Objective**: Systematically analyze model performance across languages.

**Tasks**:
1. Select a benchmark (like MMLU) and translate to 3-5 languages
2. Evaluate model performance on translated benchmarks
3. Analyze tokenization efficiency for each language
4. Calculate cost multipliers for non-English queries
5. Propose optimization strategies

**Deliverables**:
- Comprehensive multilingual analysis report
- Cost comparison across languages
- Optimization recommendations

### Capstone Project

#### Project: Foundation Model Selection and Optimization Framework

**Scenario**: You're tasked with selecting and optimizing a foundation model for a company's customer service chatbot that needs to handle:
- Multiple languages (English, Spanish, Mandarin)
- Technical support queries
- Occasional creative responses
- Strict latency requirements (< 2 seconds)
- Budget constraints

**Requirements**:
1. Research and compare at least 5 different foundation models
2. Design experiments to test each model on the target use cases
3. Implement sampling strategy optimization
4. Create a cost-performance analysis
5. Deliver a final recommendation with justification
6. Build a simple demo showing your optimizations

**Deliverables**:
- Research document with model comparisons
- Experimental results and analysis
- Working demo application
- Final recommendation presentation
- Documentation of all decisions and trade-offs

**Evaluation Criteria**:
- Thoroughness of research and experimentation
- Quality of analysis and justification
- Practical applicability of recommendations
- Code quality and documentation
- Presentation clarity

---
*Note: All lab exercises should be completed with proper documentation, including code, results, analysis, and recommendations. Labs marked as "Advanced" may require access to enterprise resources or simulation environments.*