# Chapter 10. AI Engineering Architecture and User Feedback

## Overview

So far, this book has covered a wide range of techniques to adapt foundation models to specific applications. This chapter will discuss how to **bring these techniques together to build successful products**.

**The Challenge**: Given the wide range of AI engineering techniques and tools available, selecting the right ones can feel overwhelming.

**The Approach**: This chapter takes a gradual approach:
1. Starts with the simplest architecture for a foundation model application
2. Highlights the challenges of that architecture
3. Gradually adds components to address them

**Reality Check**: We can spend eternity reasoning about how to build a successful application, but **the only way to find out if an application actually achieves its goal is to put it in front of users**.

**User Feedback**: Has always been invaluable for guiding product development, but for AI applications, user feedback has an even more crucial role as a **data source for improving models**.

**The Challenge of Conversational Feedback**:
- The conversational interface makes it easier for users to give feedback
- But harder for developers to extract signals
- This chapter will discuss different types of conversational AI feedback
- How to design a system to collect the right feedback without hurting user experience

# AI Engineering Architecture

A full-fledged AI architecture can be complex. This section follows the process that a team might follow in production:
- Start with the simplest architecture
- Progressively add more components

**General Applicability**: Despite the diversity of AI applications, they share many common components. The architecture proposed here has been validated at multiple companies to be general for a wide range of applications, but certain applications might deviate.

## The Simplest Architecture

In its simplest form:
1. Your application receives a query
2. Sends it to the model
3. The model generates a response
4. Response is returned to the user

../images/aien_1001.png

**Figure 10-1. The simplest architecture for running an AI application.**

**What's Missing**:
- No context augmentation
- No guardrails
- No optimization

**Note**: The *Model API* box refers to both:
- Third-party APIs (e.g., OpenAI, Google, Anthropic)
- Self-hosted models (building inference server discussed in Chapter 9)

## Progressive Enhancement

From this simple architecture, you can add more components as needs arise. The process might look as follows:

1. **Enhance context** input into a model by giving the model access to external data sources and tools for information gathering
2. **Put in guardrails** to protect your system and your users
3. **Add model router and gateway** to support complex pipelines and add more security
4. **Optimize for latency and costs** with caching
5. **Add complex logic and write actions** to maximize your system's capabilities

**Important Note**: This chapter follows the progression commonly seen in production. However, everyone's needs are different. You should follow the order that makes the most sense for your application.

**Monitoring and Observability**: Integral to any application for quality control and performance improvement, will be discussed at the end of this process.

**Orchestration**: Chaining all these components together, will be discussed after monitoring.

## Step 1. Enhance Context

The initial expansion of a platform usually involves adding mechanisms to allow the system to construct the relevant context needed by the model to answer each query.

**Context Construction Methods** (as discussed in Chapter 6):
- Text retrieval
- Image retrieval
- Tabular data retrieval
- Tools (web search, news APIs, weather, events, etc.)

**Key Principle**: *Context construction is like feature engineering for foundation models.* It gives the model the necessary information to produce an output.

**Widespread Support**: Due to its central role in a system's output quality, context construction is almost universally supported by model API providers. For example, OpenAI, Claude, and Gemini all:
- Allow users to upload files
- Allow their models to use tools

**Provider Differences**: Just like models differ in their capabilities, these providers differ in their context construction support:
- **Document limitations**: Number and types of documents you can upload
- **Retrieval algorithms**: Different frameworks use different retrieval methods
- **Retrieval configurations**: Chunk sizes, search methods
- **Tool support**: Types of tools supported, execution modes (parallel, long-running jobs)

**Example Differences**:
- A specialized RAG solution might let you upload as many documents as your vector database can accommodate
- A generic model API might let you upload only a small number of documents

**Updated Architecture**:

../images/aien_1002.png

**Figure 10-2. A platform architecture with context construction.**

## Step 2. Put in Guardrails

**Purpose**: Guardrails help mitigate risks and protect you and your users. They should be placed whenever there are exposures to risks.

**Two Main Categories**:
1. Input guardrails
2. Output guardrails

### Input guardrails

Input guardrails typically protect against two types of risks:
1. **Leaking private information** to external APIs
2. **Executing bad prompts** that compromise your system

**Prompt Hacks**: Chapter 5 discusses many different ways attackers can exploit an application through prompt hacks and how to defend against them. While you can mitigate risks, they can never be fully eliminated due to:
- The inherent nature of how models generate responses
- Unavoidable human failures

**Private Information Leakage Risk**: Specific to using external model APIs when you need to send your data outside your organization. This might happen for many reasons:

1. **Employee error**: An employee copies company's secret or user's private information into a prompt and sends it to a third-party API
2. **Developer mistake**: An application developer puts company's internal policies and data into application's system prompt
3. **Tool retrieval**: A tool retrieves private information from internal database and adds it to context

**Mitigation Strategy**: There's no airtight way to eliminate potential leaks when using third-party APIs. However, you can mitigate them with guardrails.

**Sensitive Data Detection Tools**: You can use one of many available tools that automatically detect sensitive data. What sensitive data to detect is specified by you.

**Common Sensitive Data Classes**:
- Personal information (ID numbers, phone numbers, bank accounts)
- Human faces
- Specific keywords and phrases associated with company's intellectual property or privileged information

**Two Approaches to Handling Detected PII**:

**1. Block the Request**:
- Don't send the request to external API at all
- Inform user that their query contains sensitive information

**2. Mask and Unmask (PII Masking)**:
- Replace sensitive information with placeholder tokens
- Send masked version to API
- After receiving response, unmask it before returning to user

../images/aien_1003.png

**Figure 10-3. An example of masking and unmasking PII information using a reverse PII map to avoid sending it to external APIs.**

**Example**:
- Original: "My credit card number is 1234-5678-9012-3456"
- Masked: "My credit card number is [CREDIT_CARD_1]"
- Send masked version to API
- API response: "Your credit card [CREDIT_CARD_1] has been processed"
- Unmasked: "Your credit card 1234-5678-9012-3456 has been processed"

**Challenge**: Need to maintain mapping between placeholders and actual values (the "reverse PII map").

### Output guardrails

**Purpose**: Ensure that the generated outputs are safe and appropriate before they reach users.

**What Output Guardrails Check For**:
- **Toxicity**: Hate speech, offensive content
- **Hallucinations**: Factual inconsistencies
- **PII leakage**: Model accidentally generates sensitive information
- **Off-topic responses**: Model strays from intended purpose
- **Policy violations**: Content that violates usage policies

**Actions When Guardrails Triggered**:
1. **Block the output**: Don't return it to user
2. **Regenerate**: Ask model to try again with modified prompt
3. **Filter/modify**: Remove or modify problematic parts
4. **Flag for review**: Log for human review while returning to user

**Trade-offs**:
- **Strict guardrails**: Safer but may block valid outputs (false positives)
- **Lenient guardrails**: More permissive but may let harmful content through (false negatives)
- Need to balance safety with user experience

**Examples of Output Guardrails**:
- Factual consistency checkers (compare output to retrieved context)
- Toxicity classifiers (detect harmful language)
- PII detectors (ensure no sensitive data leaked)
- Relevance checkers (ensure output addresses user query)

### Guardrail implementation

**Detection Methods**:
- **Rule-based**: Regular expressions, keyword matching
- **ML-based**: Classifiers trained to detect specific issues
- **LLM-based**: Use another LLM to judge the output

**Guardrail Services**: Many companies provide guardrail services:
- Content moderation APIs
- PII detection services
- Factual consistency checkers

**Performance Considerations**:
- Guardrails add latency (each check takes time)
- Need to balance thoroughness with speed
- Can run some checks in parallel

**Best Practices**:
- Use multiple layers of defense (defense in depth)
- Log all guardrail triggers for analysis
- Continuously tune thresholds based on false positive/negative rates
- Consider user experience (don't over-block)

**Updated Architecture**:

../images/aien_1004.png

**Figure 10-4. Application architecture with the addition of input and output guardrails.**

## Step 3. Add Model Router and Gateway

### Router

**Purpose**: Different queries might be better served by different models or solutions.

**Why Route**:
- **Different capabilities**: Some models better at math, others at creative writing
- **Different costs**: Smaller models cheaper for simple queries
- **Different speeds**: Faster models for time-sensitive queries
- **Different modalities**: Text vs image vs multimodal models

**Routing Strategies**:

**1. Intent-based Routing**:
- Classify user intent
- Route to model specialized for that intent
- Example: Math queries → math-specialized model

**2. Complexity-based Routing**:
- Assess query complexity
- Simple queries → fast, cheap model
- Complex queries → powerful, expensive model

**3. Confidence-based Routing**:
- Try fast model first
- If low confidence, escalate to better model
- Balances cost and quality

**4. Multi-model Ensembling**:
- Send to multiple models
- Combine or select best response
- Higher cost but potentially better quality

**Example Routing Logic**:
```python
if is_math_query(query):
    return math_model(query)
elif query_complexity(query) > threshold:
    return powerful_model(query)
else:
    return fast_cheap_model(query)
```

../images/aien_1005.png

**Figure 10-5. Routing helps the system use the optimal solution for each query.**

**Benefits**:
- **Cost optimization**: Use expensive models only when needed
- **Latency optimization**: Use fast models for simple queries
- **Quality optimization**: Use best model for each type of query

**Challenges**:
- Need to classify/assess queries accurately
- Router itself adds latency
- More complex system to maintain

### Gateway

**Purpose**: A model gateway provides a unified interface to work with different models.

**The Problem Without Gateway**:
- Each model provider has different API
- Different authentication methods
- Different request/response formats
- Hard to switch between providers

**What a Gateway Does**:

../images/aien_1006.png

**Figure 10-6. A model gateway provides a unified interface to work with different models.**

**Core Functionality**:
1. **Unified API**: Single interface for all models
2. **Translation**: Converts requests to provider-specific format
3. **Authentication**: Handles credentials for different providers

**Example Gateway Code**:
```python
@app.route('/generate', methods=['POST'])
def generate():
    data = request.json
    input_data = data['input']
    model_name = data['model']
    max_tokens = data.get('max_tokens', 100)
    
    if model_name.startswith('gpt'):
        result = openai_model(input_data, model_name, max_tokens)
    elif model_name.startswith('claude'):
        result = anthropic_model(input_data, model_name, max_tokens)
    elif model_name.startswith('gemini'):
        result = gemini_model(input_data, model_name, max_tokens)
    
    return jsonify(result)
```

**Additional Benefits**:

**1. Access Control and Cost Management**:
- Instead of giving everyone organizational tokens (which can be easily leaked)
- Give people access only to gateway
- Creates centralized and controlled point of access
- Can implement fine-grained access controls
- Specify which user/application should have access to which model

**2. Usage Monitoring and Limiting**:
- Monitor API calls
- Limit usage to prevent abuse
- Manage costs effectively

**3. Fallback Policies**:
- Overcome rate limits or API failures (unfortunately common)
- When primary API unavailable, gateway can:
  - Route requests to alternative models
  - Retry after short wait
  - Handle failures gracefully in other ways
- Ensures application can operate smoothly without interruptions

**4. Additional Functionalities**:
Since requests and responses already flowing through gateway, it's a good place to implement:
- Load balancing
- Logging
- Analytics
- Some gateways even provide caching and guardrails

**Off-the-Shelf Gateways**: Given that gateways are relatively straightforward to implement, there are many available:
- Portkey's AI Gateway
- MLflow AI Gateway
- Wealthsimple's LLM Gateway
- TrueFoundry
- Kong
- Cloudflare

**Updated Architecture**:

../images/aien_1007.png

**Figure 10-7. The architecture with the added routing and gateway modules.**

**Note**: A similar abstraction layer, such as a **tool gateway**, can also be useful for accessing a wide range of tools. It's not discussed in this book since it's not a common pattern as of this writing.

## Step 4. Reduce Latency with Caches

**Context**: Caching has long been integral to software applications to reduce latency and cost. Many ideas from software caching can be used for AI applications.

**Two Types of Caching**:
- **Inference caching** (KV caching, prompt caching): Discussed in Chapter 9
- **System caching**: Focus of this section

Because caching is an old technology with a large amount of existing literature, this book will cover it only in broad strokes.

**Two Major System Caching Mechanisms**:
1. Exact caching
2. Semantic caching

### Exact caching

**How It Works**: Cached items are used only when these exact items are requested.

**Example**:
- User asks model to summarize a product
- System checks cache for summary of this exact product
- If yes: fetch this summary
- If not: summarize the product and cache the summary

**Use Case - Embedding-based Retrieval**: Avoid redundant vector search
- If incoming query is already in vector search cache: fetch cached result
- If not: perform vector search for this query and cache the result

**Especially Appealing For**: Queries that involve multiple steps (e.g., chain-of-thought) and/or time-consuming actions (e.g., retrieval, SQL execution, or web search).

**Implementation**:
- **In-memory storage** for fast retrieval
- **Databases** (PostgreSQL, Redis) for persistence
- **Tiered storage** to balance speed and storage capacity

**Eviction Policies**: Having an eviction policy is crucial to manage cache size and maintain performance.

**Common Eviction Policies**:
- **LRU (Least Recently Used)**: Remove least recently used items
- **LFU (Least Frequently Used)**: Remove least frequently used items
- **FIFO (First In, First Out)**: Remove oldest items

**Cache Duration Decisions**: How long to keep a query in cache depends on how likely this query is to be called again:
- **User-specific queries** (e.g., "What's the status of my recent order?"): Less likely to be reused by other users, shouldn't be cached
- **Time-sensitive queries** (e.g., "How's the weather?"): Less sense to cache

**Many teams train a classifier to predict whether a query should be cached.**

**Warning - Data Leakage Risk**: Caching, when not properly handled, can cause data leaks.

**Example Scenario**:
1. You work for ecommerce site
2. User X asks: "What is the return policy for electronics products?"
3. System retrieves user X's information (return policy depends on membership)
4. Generates response containing X's information
5. System mistakenly caches the answer (thinking it's generic question)
6. User Y asks same question
7. Cached result returned to Y, **revealing X's information to Y**

**Lesson**: Always consider privacy implications when caching.

### Semantic caching

**How It Works**: Cached items are used even if they are only semantically similar, not identical, to the incoming query.

**Example**:
- User 1 asks: "What's the capital of Vietnam?"
- Model answers: "Hanoi"
- User 2 asks: "What's the capital *city* of Vietnam?"
- Semantically same question but slightly different wording
- With semantic caching: system can reuse answer from first query

**Benefits**:
- Reusing similar queries increases cache's hit rate
- Potentially reduces cost

**Drawback**: Can reduce your model's performance

**How Semantic Caching Works**:

**Requires**: Reliable way of determining if two queries are similar. Common approach: use semantic similarity (discussed in Chapter 3).

**Process**:
1. For each query, generate its embedding using an embedding model
2. Use vector search to find the cached embedding with the highest similarity score to current query embedding (call this score X)
3. If X is higher than certain similarity threshold: cached query is considered similar, cached results are returned
4. If not: process current query and cache it together with its embedding and results

**Requirements**: Requires a vector database to store embeddings of cached queries.

**Reality Check**: *Compared to other caching techniques, semantic caching's value is more dubious because many of its components are prone to failure.*

**Dependencies** (All Must Work Well):
- High-quality embeddings
- Functional vector search
- Reliable similarity metric
- Setting right similarity threshold (tricky, requires trial and error)

**Risk**: If system mistakes incoming query for one similar to another query, returned response (fetched from cache) will be incorrect.

**Performance Overhead**:
- Semantic cache can be time-consuming and compute-intensive (involves vector search)
- Speed and cost of vector search depend on size of cached embeddings

**When It Might Be Worthwhile**: If cache hit rate is high, meaning a good portion of queries can be effectively answered by leveraging cached results.

**Recommendation**: Before incorporating the complexities of semantic cache, make sure to evaluate the associated efficiency, cost, and performance risks.

**Updated Architecture**:

../images/aien_1008.png

**Figure 10-8. An AI application architecture with the added caches.**

**Note**: A KV cache and prompt cache are typically implemented by model API providers, so they aren't shown in this image. To visualize them, they'd be in the Model API box. There's a new arrow to add generated responses to the cache.

## Step 5. Add Agent Patterns

The applications discussed so far are still fairly simple. Each query follows a sequential flow. However, as discussed in Chapter 6, an application flow can be more complex with:
- Loops
- Parallel execution
- Conditional branching

**Agentic Patterns**: Can help you build complex applications.

**Example - Feedback Loop**:
After system generates output:
1. It might determine it hasn't accomplished the task
2. Needs to perform another retrieval to gather more information
3. Original response, together with newly retrieved context, is passed into same model or different one
4. This creates a loop

../images/aien_1009.png

**Figure 10-9. The yellow arrow allows the generated response to be fed back into the system, allowing more complex application patterns.**

**Write Actions**: A model's outputs also can be used to invoke write actions:
- Composing an email
- Placing an order
- Initializing a bank transfer

**Power and Risk**: Write actions allow a system to make changes to its environment directly. As discussed in Chapter 6:
- Write actions can make a system vastly more capable
- But also expose it to significantly more risks
- Giving a model access to write actions should be done with the utmost care

**Updated Architecture**:

../images/aien_1010.png

**Figure 10-10. An application architecture that enables the system to perform write actions.**

**Reality Check**: If you've followed all the steps so far, your architecture has likely grown quite complex. While complex systems can solve more tasks, they also:
- Introduce more failure modes
- Are harder to debug due to many potential points of failure

**Next Topic**: The next section will cover best practices for improving system observability.

## Monitoring and Observability

**Important Note**: Even though observability is in its own section, **observability should be integral to the design of a product, rather than an afterthought**. The more complex a product, the more crucial observability is.

**Universal Practice**: Observability is universal across all software engineering disciplines. It's a big industry with established best practices and many ready-to-use proprietary and open source solutions.

**This Section's Focus**: To avoid reinventing the wheel, will focus on what's unique to applications built on top of foundation models. The book's GitHub repository contains resources for those who want to learn more about observability.

**Goal of Monitoring**: Same as the goal of evaluation—to mitigate risks and discover opportunities.

**Risks to Mitigate**:
- Application failures
- Security attacks
- Drifts

**Opportunities to Discover**:
- Application improvement opportunities
- Cost savings

**Accountability**: Monitoring can also help keep you accountable by giving visibility into your system's performance.

**Three Metrics for Evaluating Observability Quality** (from DevOps community):

**1. MTTD (Mean Time To Detection)**:
- When something bad happens, how long does it take to detect it?

**2. MTTR (Mean Time To Response)**:
- After detection, how long does it take to be resolved?

**3. CFR (Change Failure Rate)**:
- Percentage of changes or deployments that result in failures requiring fixes or rollbacks
- If you don't know your CFR, it's time to redesign your platform to make it more observable

**Important**: Having a high CFR doesn't necessarily indicate a bad monitoring system. However, you should rethink your evaluation pipeline so that bad changes are caught before being deployed.

**Evaluation and Monitoring Must Work Together**:
- Evaluation metrics should translate well to monitoring metrics
- A model that does well during evaluation should also do well during monitoring
- Issues detected during monitoring should be fed to the evaluation pipeline

# Monitoring Versus Observability

Since the mid-2010s, the industry has embraced the term "observability" instead of "monitoring."

**Monitoring**:
- Makes no assumption about relationship between internal state of system and its outputs
- You monitor external outputs of system to figure out when something goes wrong inside
- There's no guarantee that external outputs will help you figure out what goes wrong

**Observability**:
- Makes an assumption stronger than traditional monitoring
- A system's internal states can be inferred from knowledge of its external outputs
- When something goes wrong with observable system, we should be able to figure out what went wrong by looking at system's logs and metrics
- Should not need to ship new code to system

**Observability is about instrumenting your system** in a way that ensures sufficient information about a system's runtime is collected and analyzed so that when something goes wrong, it can help you figure out what goes wrong.

**Terminology in This Book**:
- **"Monitoring"**: Refers to the act of tracking a system's information
- **"Observability"**: Refers to the whole process of instrumenting, tracking, and debugging the system

### Metrics

When discussing monitoring, most people think of metrics. However, **metrics themselves aren't the goal**. Frankly, most companies don't care what your application's output relevancy score is unless it serves a purpose.

**The Purpose of a Metric**: To tell you when something is wrong and to identify opportunities for improvement.

**Metric Design Philosophy**: Before listing what metrics to track, it's important to **understand what failure modes you want to catch and design your metrics around these failures**.

**Example**:
- **If you don't want your application to hallucinate**: Design metrics that help you detect hallucinations (e.g., whether application's output can be inferred from context)
- **If you don't want to burn through API credit**: Track metrics related to API costs (number of input/output tokens per request, cache cost, cache hit rate)

**Reality**: Because foundation models can generate open-ended outputs, there are many ways things can go wrong. Metrics design requires:
- Analytical thinking
- Statistical knowledge
- Often, creativity

**Which metrics you should track are highly application-specific.**

**Metrics Covered in This Book**:
- Many different types of model quality metrics (Chapters 4–6, and later in this chapter)
- Many different ways to compute them (Chapters 3 and 5)

**Quick Recap of Key Metrics**:

**1. Format Failures** (Easiest to Track):
- Easy to notice and verify
- Example: If you expect JSON outputs:
  - Track how often model outputs invalid JSON
  - Among invalid JSON outputs, how many can be easily fixed
  - Missing closing bracket = easy to fix
  - Missing expected keys = harder

**2. Open-Ended Generations**:
- Consider monitoring factual consistency
- Relevant generation quality metrics:
  - Conciseness
  - Creativity
  - Positivity
- Many can be computed using AI judges

**3. Safety Metrics** (If Safety Is an Issue):
- Toxicity-related metrics
- Detect private and sensitive information in both inputs and outputs
- Track how often guardrails get triggered
- Track how often system refuses to answer
- Detect abnormal queries (might reveal edge cases or prompt attacks)

**4. Cost and Latency Metrics**:
- Token usage (input and output)
- API costs
- Response time
- Cache hit rates
- Throughput

**5. Retrieval Quality** (For RAG Systems):
- Context precision and recall
- Relevance of retrieved documents
- Retrieval latency

**6. Agent Metrics** (For Agentic Systems):
- Number of tool calls per request
- Tool success/failure rates
- Planning quality
- Task completion rates

**Best Practices**:
- Start with a few key metrics
- Add more as you understand your system better
- Review metrics regularly
- Adjust thresholds based on actual performance
- Tie metrics to business outcomes when possible

### Logs and traces

**Beyond Metrics**: Metrics give you aggregated signals, but to debug issues, you need detailed information about what happened in individual requests.

**Logs**: Record of events that happened in your system:
- User queries
- Model responses
- Errors
- Guardrail triggers
- Tool calls
- API calls

**Traces**: Show the path a request takes through your system:
- Which components were involved
- How long each step took
- What was the input/output at each step

**Request Trace Visualization**:

../images/aien_1011.png

**Figure 10-11. A request trace visualized by LangSmith.**

**Benefits of Tracing**:
- **Debug issues**: See exactly what happened for a specific request
- **Identify bottlenecks**: Find which steps are slow
- **Understand flow**: See how data moves through your system
- **Cost attribution**: Know which components are expensive

**What to Log**:
- User queries (with appropriate privacy protections)
- Model inputs and outputs
- Retrieved context
- Tool calls and results
- Errors and exceptions
- Guardrail decisions
- Routing decisions
- Cache hits/misses

**Privacy Considerations**:
- May need to mask or redact sensitive information in logs
- Need policies for log retention
- Need access controls on who can view logs

**Tracing Tools**:
- LangSmith (shown in figure)
- OpenTelemetry
- Weights & Biases
- Custom solutions

### Drift detection

**What Is Drift**: Over time, the distribution of your inputs or the behavior of your system might change. This is called drift.

**Types of Drift**:

**1. Input Drift (Data Drift)**:
- Distribution of user queries changes over time
- Example: After a product launch, get queries about new features
- Example: Seasonal changes (weather queries in summer vs winter)

**2. Output Drift (Model Drift)**:
- Model's behavior changes over time
- Can happen even if model hasn't changed
- Example: World changes, model's knowledge becomes outdated

**3. Concept Drift**:
- Relationship between inputs and desired outputs changes
- Example: What users consider "good response" changes over time

**Why Drift Matters**:
- Model trained on old data might not work well on new data
- Evaluation results from last month might not reflect current performance
- Need to detect and adapt to drift

**How to Detect Drift**:
- **Statistical tests**: Compare current distribution to baseline
- **Performance monitoring**: Track metrics over time
- **Manual review**: Sample and review recent requests
- **User feedback**: Increase in complaints might indicate drift

**How to Handle Drift**:
- **Retrain**: Update model with new data
- **Update prompts**: Adjust instructions to handle new patterns
- **Update retrieval**: Add new documents to knowledge base
- **Update rules**: Adjust guardrails, routing logic

**Best Practices**:
- Establish baselines early
- Monitor distributions continuously
- Have alerting for significant changes
- Review drift patterns regularly
- Plan for retraining/updating

## AI Pipeline Orchestration

**The Challenge**: As your architecture grows complex with many components, you need a way to **orchestrate** (coordinate) all these components.

**What Is Orchestration**: The process of coordinating different components in your AI pipeline:
- Executing steps in correct order
- Handling dependencies
- Managing errors and retries
- Parallelizing when possible

**Orchestration Needs**:
- **Sequential execution**: Step B waits for Step A to complete
- **Parallel execution**: Multiple steps run simultaneously
- **Conditional logic**: If condition X, do A, else do B
- **Loops**: Repeat steps until condition met
- **Error handling**: Retry on failure, fallback options
- **State management**: Pass data between steps

**Orchestration Tools**:

**1. Workflow Orchestrators**:
- Airflow
- Prefect
- Temporal
- Dagster

**2. AI-Specific Orchestrators**:
- LangChain
- LlamaIndex
- Haystack
- AutoGen

**3. Custom Solutions**:
- Write your own orchestration logic
- Use simple task queues (Celery, RabbitMQ)

**Example Orchestration Flow**:
```
1. Receive user query
2. Run input guardrails
   - If blocked: return error message
3. Check cache
   - If hit: return cached result
4. Route query to appropriate path
   - Simple query → Path A (fast model)
   - Complex query → Path B (powerful model)
5. Construct context (RAG)
   - Retrieve documents
   - Rerank
   - Format context
6. Call model with prompt
7. Run output guardrails
   - If blocked: regenerate or return error
8. Cache result
9. Return to user
10. Log everything
```

**Warning**: Orchestration frameworks can introduce significant complexity and opinions about how your system should work. Before adopting an orchestration framework:
- Understand what it does
- Understand if you really need it
- Consider starting simple and adding orchestration later
- Be wary of framework lock-in

**Best Practices**:
- Start simple
- Add orchestration as needed
- Keep orchestration logic separate from business logic
- Make it easy to test individual components
- Monitor orchestration performance
- Have clear error handling

# User Feedback

User feedback has always been invaluable for guiding product development, but for AI applications, **user feedback has an even more crucial role as a data source for improving models**.

**Unique Aspect of Conversational AI**: The conversational interface makes it easier for users to give feedback but harder for developers to extract signals.

**Example of Implicit Conversational Feedback**:

Imagine you're using a travel assistant to book a hotel. You ask: "I want a hotel for tomorrow night in Paris."

The assistant responds: "I found these three options:
1. Hotel A - $180/night, near galleries
2. Hotel B - $220/night, with rooftop bar
3. Hotel C - $200/night, by Eiffel Tower"

**Your Possible Responses Reveal Preferences**:
- "Yes book me the one close to galleries" → shows interest in art
- "Is there nothing under $200?" → reveals price-conscious preference, suggests assistant doesn't quite get you yet

**Three Uses of User Feedback** (extracted from conversations):

**1. Evaluation**: Derive metrics to monitor the application

**2. Development**: Train future models or guide their development

**3. Personalization**: Personalize the application to each user

**Challenge**: Implicit conversational feedback can be inferred from both:
- Content of user messages
- Patterns of communication

Because feedback is blended into daily conversations, it's also challenging to extract. While intuition about conversational cues can help devise an initial set of signals to look for, **rigorous data analysis and user studies are necessary to understand**.

**Historical Context**: While conversational feedback has enjoyed greater attention thanks to ChatGPT's popularity, it had been an active research area for several years before:
- Reinforcement learning community trying to get RL algorithms to learn from natural language feedback since late 2010s
- Many with promising results
- Of great interest for early conversational AI applications:
  - Amazon Alexa
  - Spotify's voice control feature
  - Yahoo! Voice

## Extracting Conversational Feedback

### Natural language feedback

**Definition**: Feedback extracted from the content of messages.

Here are natural language feedback signals that tell you how a conversation is going. It's useful to track these signals in production to monitor your application's performance.

#### Early termination

**Signal**: If a user terminates a response early, the conversation likely isn't going well.

**Examples**:
- Stopping response generation halfway
- Exiting the app (for web and mobile apps)
- Telling the model to stop (for voice assistants)
- Simply leaving the agent hanging (e.g., not responding to agent with which option you want it to go ahead with)

**Interpretation**: User is not satisfied with the direction of the response.

#### Error correction

**Signal**: If a user starts their follow-up with "No, …" or "I meant, …", the model's response is likely off the mark.

**Rephrase Attempts**: To correct errors, users might try to rephrase their requests.

../images/aien_1012.png

**Figure 10-12. Because the user both terminates the generation early and rephrases the question, it can be inferred that the model misunderstood the intent of the original request.**

**Detection**: Rephrase attempts can be detected using heuristics or ML models.

**Specific Corrections**: Users can also point out specific things the model should've done differently.

**Example**:
- User asks model to summarize a story
- Model confuses a character
- User gives feedback: "Bill is the suspect, not the victim."
- Model should be able to take this feedback and revise the summary

**Action-Correcting Feedback**: Especially common for agentic use cases where users might nudge agent toward more optimal actions.

**Example**:
- User assigns agent task of doing market analysis about company XYZ
- User gives feedback:
  - "You should also check XYZ GitHub page"
  - "Check the CEO's X profile"

**Requests for Verification**: Sometimes, users might want model to correct itself by asking for explicit confirmation:
- "Are you sure?"
- "Check again"
- "Show me the sources"

**Interpretation**: Doesn't necessarily mean model gives wrong answers. However, it might mean:
- Model's answers lack the details user is looking for
- General distrust in your model

**Direct Edits**: Some applications let users edit model's responses directly.

**Example**:
- User asks model to generate code
- User corrects the generated code
- **Very strong signal** that the code that got edited isn't quite right

**Preference Data**: User edits also serve as a valuable source of preference data. Recall that preference data, typically in format (query, winning response, losing response), can be used to align a model to human preference.

Each user edit makes up a preference example:
- Original generated response = losing response
- Edited response = winning response

#### Complaints

Often, users just complain about your application's outputs without trying to correct them. For example, they might complain that an answer is:
- Wrong
- Irrelevant
- Toxic
- Lengthy
- Lacking detail
- Just bad

**FITS Dataset Analysis**: Eight groups of natural language feedback resulting from automatic clustering the FITS (Feedback for Interactive Talk & Search) dataset:

**Table 10-1. Feedback types from FITS dataset**

| Group | Feedback type | Percentage |
|---|---|---|
| 1 | Clarify their demand again | 26.54% |
| 2 | Complain that bot (1) doesn't answer question or (2) gives irrelevant information or (3) asks user to find out answer on their own | 16.20% |
| 3 | Point out specific search results that can answer the question | 16.17% |
| 4 | Suggest that bot should use the search results | 15.27% |
| 5 | State that answer is (1) factually incorrect, or (2) not grounded in search results | 11.27% |
| 6 | Point out that bot's answer is not specific/accurate/complete/detailed | 9.39% |
| 7 | Point out that bot is not confident in its answers and always begins responses with "I am not sure" or "I don't know" | 4.17% |
| 8 | Complain about repetition/rudeness in bot responses | 0.99% |

**Key Insight**: Understanding how the bot fails the user is crucial in making it better.

**Examples**:
- If user doesn't like verbose answers → change bot's prompt to make it more concise
- If user is unhappy because answer lacks details → prompt bot to be more specific

#### Sentiment

**What to Track**: Track sentiment of user messages throughout conversation:
- Is sentiment becoming more positive or negative?
- Negative sentiment trajectory = conversation not going well
- Positive sentiment trajectory = user satisfied

**Sentiment Analysis**:
- Can use sentiment classifiers
- Track sentiment changes over conversation
- Correlate with conversation outcomes

**Limitation**: Sentiment isn't always reliable indicator:
- Users might be polite even when frustrated
- Cultural differences in expressing sentiment
- Sarcasm hard to detect

### Other conversational feedback

Beyond natural language content, can extract feedback from user behavior and conversation patterns.

#### Regeneration

**Signal**: When a user asks model to regenerate a response.

**What It Means**:
- User didn't like first response
- User wants different perspective
- User is exploring options

**Comparative Feedback Opportunity**:

../images/aien_1013.png

**Figure 10-13. ChatGPT asks for comparative feedback when a user regenerates another response.**

Some systems (like ChatGPT) ask users to compare responses when they regenerate:
- Which response is better?
- Why is it better?
- Very valuable preference data

**Best Practice**: If users regenerate responses, consider:
- Asking for feedback on what was wrong with first response
- Offering to refine rather than fully regenerate
- Learning from regeneration patterns

#### Conversation organization

**Signals from How Users Organize Conversations**:

**Sharing**: User shares conversation
- Indicates satisfaction
- Found it valuable enough to share

**Saving**: User saves conversation or adds to favorites
- Plans to reference later
- Found it useful

**Deleting**: User deletes conversation
- Strong negative signal
- Conversation didn't meet expectations

**Naming**: How user names conversation
- Generic names = less engagement
- Descriptive names = more engaged

#### Conversation length

**What to Track**:
- Number of turns in conversation
- Total tokens exchanged
- Time spent

**Interpretations**:
- **Very short conversations**: Might indicate:
  - Quick success (got answer immediately)
  - Quick failure (gave up immediately)
  - Need context to distinguish
- **Very long conversations**: Might indicate:
  - Deep engagement (positive)
  - Frustration (model not getting it, negative)
  - Again, need context

**Best Practice**: Combine with other signals to interpret correctly.

#### Dialogue diversity

**What to Track**: Diversity of topics discussed in conversation.

**Interpretations**:
- **High diversity**: User trusts system with different topics (positive)
- **Low diversity**: User keeps coming back to same topic
  - Either very engaged with specific topic
  - Or model not addressing their concern

**Measurement**: Can use topic modeling or clustering to identify distinct topics.

## Feedback Design

Beyond extracting implicit feedback, can design explicit mechanisms to collect feedback from users.

### When to collect feedback

**Key Principle**: Don't over-ask. Too many feedback requests annoy users and reduce response rates.

**Strategic Times to Ask for Feedback**:

#### In the beginning

**When**: Early in product lifecycle or user journey.

**Why**:
- New users often more willing to give feedback
- Early feedback helps guide product direction
- Users excited about new product

**What to Ask**:
- Overall impressions
- What they like/dislike
- What they want to see

**Best Practice**:
- Keep it lightweight
- Don't interrupt core experience
- Thank users for feedback

#### When something bad happens

**When**: System makes an obvious mistake or error.

**Example - DALL-E Inpainting**:

../images/aien_1014.png

**Figure 10-14. An example of how inpainting works in DALL-E.**

When inpainting doesn't work as expected, ask:
- What were you trying to achieve?
- What went wrong?
- How can we improve?

**Why This Works**:
- User already aware something went wrong
- Motivated to help improve
- Contextually relevant

**Best Practice**:
- Make feedback easy to give
- Offer to retry with improved approach
- Follow up if you fix the issue

#### When the model has low confidence

**When**: Model is uncertain about its output.

**Example - Side-by-Side Comparison**:

../images/aien_1015.png

**Figure 10-15. Side-by-side comparison of two ChatGPT responses.**

../images/aien_1016.png

**Figure 10-16. Google Gemini shows partial responses side by side for comparative feedback. Users have to click on the response they want to read more about, which gives feedback about which response they find more promising.**

**Strategy**:
- Show multiple responses
- Ask user to select preferred one
- Can show side-by-side or sequentially

**Why This Works**:
- User has to choose anyway
- Low friction (just click preferred response)
- Provides comparative preference data

**Another Example - Google Photos**:

../images/aien_1017.png

**Figure 10-17. Google Photos asks for user feedback when unsure.**

When unsure about classification:
- "Are these the same cat?"
- Simple yes/no question
- Helps improve model

### How to collect feedback

**Explicit Feedback Mechanisms**:

**1. Thumbs Up/Down**:
- Simplest form
- Low friction
- Binary signal

**2. Star Ratings**:
- More nuanced than binary
- But users might have different scales

**3. Text Feedback**:
- Most informative
- But higher friction
- Most users won't write

**4. Multiple Choice**:
- Structured feedback
- Easier to analyze
- Can guide users to useful feedback

**5. Comparative Feedback**:
- Show two options, ask which is better
- Generates preference data
- Can be implicit (which one did they use)

**Implicit Feedback Collection**:

**Midjourney Example**:

../images/aien_1018.png

**Figure 10-18. Midjourney's workflow allows the app to collect implicit feedback.**

**How It Works**:
- User generates image
- To use image, must select it
- Selection = implicit positive feedback
- Can ask for variations = wants something similar but different
- Can upscale = satisfied with this one

**GitHub Copilot Example**:

../images/aien_1019.png

**Figure 10-19. GitHub Copilot makes it easy to both suggest and reject a suggestion.**

**How It Works**:
- Shows suggestion inline
- Easy to accept (Tab key)
- Easy to reject (keep typing)
- Acceptance = implicit positive feedback
- Rejection = implicit negative feedback

**Best Practices for Feedback Collection**:

**1. Make It Easy**:
- Minimize clicks/effort
- Inline when possible
- Use implicit signals when possible

**2. Make It Contextual**:
- Ask at right moment
- Make question relevant to what just happened
- Don't ask generic questions

**3. Don't Over-Ask**:
- Limit frequency of feedback requests
- Don't ask after every interaction
- Respect users who don't want to give feedback

**4. Close the Loop**:
- Thank users for feedback
- Show how you're using it
- Let users know when you've addressed their feedback

**5. Provide Options**:
- Not just "good/bad"
- Give specific categories if possible
- Allow users to elaborate if they want

**Warning - Design Mistakes Can Bias Feedback**:

**ChatGPT Example**:

../images/aien_1020.png

**Figure 10-20. An example of ChatGPT asking a user to select the response the user prefers. However, for mathematical questions like this, the right answer shouldn't be a matter of preference.**

**Issue**: Asking for "preference" on objective questions (like math) is wrong framing. There's a right answer, not a preference.

**Luma Example**:

../images/aien_1021.png

**Figure 10-21. Because Luma put the angry emoji, corresponding to a one-star rating, where a five-star rating should've been, some users mistakenly picked it for positive reviews.**

**Issue**: Angry emoji (😠) on the right where five stars should be. Some users mistakenly clicked it thinking it was positive.

**Lessons**:
- Design matters
- Test your feedback UI
- Make sure design doesn't bias results
- Follow conventions (e.g., stars go left to right from low to high)

## Feedback Limitations

While user feedback is invaluable, it has limitations that need to be understood and addressed.

### Biases

**Types of Biases in User Feedback**:

**1. Selection Bias**:
- Not all users give feedback
- Those who do might not be representative
- Often get more feedback from unhappy users

**2. Positivity Bias**:
- Users tend to be polite
- Might give positive feedback even when not satisfied
- Cultural differences in feedback norms

**3. Recency Bias**:
- Users remember recent experiences more vividly
- Feedback reflects recent interactions more than overall experience

**4. Confirmation Bias**:
- Users notice things that confirm their existing beliefs
- Might overlook positive aspects if they expect negative

**5. Framing Bias**:
- How you ask affects the answer
- Leading questions bias responses
- Order of options affects choices

**Mitigation Strategies**:
- Collect feedback from diverse users
- Use multiple feedback mechanisms
- Combine explicit and implicit feedback
- Look for patterns across many users
- Don't over-interpret individual pieces of feedback
- A/B test feedback mechanisms themselves

### Degenerate feedback loop

**The Problem**: If you train your model only on user feedback, you can create a **degenerate feedback loop**.

**How It Happens**:
1. Model produces outputs
2. Users give feedback (mostly on what model shows them)
3. Model trained on this feedback
4. Model produces similar outputs (because that's what got positive feedback)
5. Users only see these types of outputs
6. Repeat

**Result**:
- Model becomes increasingly narrow
- Doesn't explore new types of responses
- Optimizes for what users have seen, not what they might want
- Can amplify existing biases

**Example**:
- Recommendation system shows cat videos
- Users click on cat videos (because that's what they see)
- System learns to show more cat videos
- Users never see dog videos
- Even if they would have liked dog videos

**Mitigation Strategies**:

**1. Exploration**:
- Sometimes show diverse outputs
- Not just what's predicted to be liked
- Measure response to diverse outputs

**2. Mix Feedback Sources**:
- Don't rely only on implicit feedback
- Combine with explicit feedback
- Use offline evaluation
- Use expert evaluation

**3. Diverse Training Data**:
- Don't train only on user feedback
- Include curated high-quality data
- Include diverse examples

**4. Monitor for Narrowing**:
- Track diversity of outputs over time
- Alert if diversity decreases
- Intervene if model becomes too narrow

**5. Adversarial Testing**:
- Deliberately test on diverse inputs
- Ensure model can handle variety
- Don't just optimize metrics

**Key Principle**: User feedback is extremely valuable but should be one of multiple signals, not the only signal.

# Summary

This final chapter brought together the techniques from throughout the book:

**AI Engineering Architecture**:
- **Start simple**: Single model, direct query-response
- **Add progressively**: Context, guardrails, routing, caching, agent patterns
- **Each addition addresses specific needs**: Not all applications need all components

**Five Steps to Complex Architecture**:
1. **Enhance context**: RAG, tools, retrieval
2. **Add guardrails**: Input (PII detection, prompt injection defense) and output (toxicity, hallucination detection)
3. **Add routing and gateway**: Optimize model selection, unified API interface
4. **Reduce latency with caches**: Exact caching and semantic caching
5. **Add agent patterns**: Loops, write actions, complex workflows

**Key Architectural Components**:
- **Context construction**: Like feature engineering for foundation models
- **Guardrails**: Protect system and users
- **Router**: Optimize which model/solution to use
- **Gateway**: Unified interface, access control, fallback policies
- **Caches**: Reduce latency and cost
- **Agent patterns**: Enable complex, iterative workflows

**Monitoring and Observability**:
- **Should be integral to design**, not afterthought
- **Key metrics**: MTTD, MTTR, CFR
- **What to monitor**: Format failures, quality metrics, safety, cost, latency
- **Logs and traces**: Debug individual requests
- **Drift detection**: Catch when distributions or behavior changes

**Orchestration**:
- Coordinate complex pipelines
- Handle dependencies, errors, retries
- Many tools available but add complexity
- Start simple, add as needed

**User Feedback**:
- **Three uses**: Evaluation, development, personalization
- **Natural language feedback**: Early termination, error correction, complaints, sentiment
- **Behavioral feedback**: Regeneration, conversation organization, length, diversity
- **Strategic collection**: In beginning, when something bad happens, when model has low confidence
- **Implicit vs explicit**: Both valuable, implicit has less friction
- **Design matters**: Bad UI can bias feedback

**Feedback Limitations**:
- **Biases**: Selection, positivity, recency, confirmation, framing
- **Degenerate feedback loops**: Training only on user feedback can narrow model
- **Mitigation**: Diverse feedback sources, exploration, monitoring

**Key Takeaways**:
1. Build incrementally, not all at once
2. Not every application needs every component
3. Observability is crucial and should be designed in
4. User feedback is invaluable but has limitations
5. Balance safety with user experience
6. Balance cost with latency and quality
7. Architecture should match application needs
8. Monitor everything, iterate continuously
9. Close feedback loops (use feedback to improve)
10. The only way to know if it works is to put it in front of users

**Final Thought**: Building successful AI applications requires combining technical excellence with deep understanding of users and continuous iteration based on real-world feedback.

This completes the comprehensive study of AI Engineering!
