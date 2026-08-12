# Chapter 4. Evaluate AI Systems

## Overview

A model is only useful if it works for its intended purposes. You need to evaluate models in the context of your application. Chapter 3 discusses different approaches to automatic evaluation. This chapter discusses how to use these approaches to evaluate models for your applications.

**Chapter Structure**:

This chapter contains three parts:

1. **Evaluation Criteria**: Discussion of the criteria you might use to evaluate your applications and how these criteria are defined and calculated. For example, how is factual consistency detected? How are domain-specific capabilities like math, science, reasoning, and summarization measured?

2. **Model Selection**: Given an increasing number of foundation models to choose from, how do you choose the right model for your application? Can public benchmarks be trusted? How do you select what benchmarks to use? What about public leaderboards? Should you host your own models or use a model API?

3. **Evaluation Pipeline**: Developing an evaluation pipeline that can guide the development of your application over time. This part brings together techniques learned throughout the book to evaluate concrete applications.

# Evaluation Criteria

**Key Question**: Which is worse—an application that has never been deployed or an application that is deployed but no one knows whether it's working?

When this question is asked at conferences, most people say the latter. **An application that is deployed but can't be evaluated is worse.** It costs to maintain, but if you want to take it down, it might cost even more.

**Common Problem**: AI applications with questionable returns on investment are unfortunately quite common. This happens not only because the application is hard to evaluate but also because application developers don't have visibility into how their applications are being used.

**Example**: An ML engineer at a used car dealership built a model to predict car value based on owner-provided specs. A year after deployment, users seemed to like the feature, but he had no idea if the model's predictions were accurate. At the beginning of the ChatGPT fever, companies rushed to deploy customer support chatbots. Many are still unsure if these chatbots help or hurt their user experience.

# Evaluation-Driven Development

Before investing time, money, and resources into building an application, it's important to understand how this application will be evaluated. This approach is called **evaluation-driven development**. The name is inspired by *test-driven development* in software engineering, which refers to writing tests before writing code. In AI engineering, evaluation-driven development means defining evaluation criteria before building.

**Why It Works**: While some companies chase the latest hype, sensible business decisions are still made based on returns on investment, not hype. Applications should demonstrate value to be deployed. As a result, the most common enterprise applications in production are those with clear evaluation criteria:

- **Recommender systems**: Their successes can be evaluated by an increase in engagement or purchase-through rates
- **Fraud detection**: Success measured by how much money is saved from prevented frauds
- **Coding**: Common generative AI use case because, unlike other generation tasks, generated code can be evaluated using functional correctness
- **Close-ended tasks**: Even though foundation models are open-ended, many use cases are close-ended (intent classification, sentiment analysis, next-action prediction, etc.). It's much easier to evaluate classification tasks than open-ended tasks

**The Streetlight Effect**: While the evaluation-driven development approach makes sense from a business perspective, focusing only on applications whose outcomes can be measured is similar to looking for the lost key under the lamppost (at night). It's easier to do, but it doesn't mean we'll find the key. We might be missing out on many potentially game-changing applications because there is no easy way to evaluate them.

**Key Belief**: Evaluation is the biggest bottleneck to AI adoption. Being able to build reliable evaluation pipelines will unlock many new applications.

**Evaluation Buckets**: An AI application should start with a list of evaluation criteria specific to the application. In general, you can think of criteria in the following buckets:
1. Domain-specific capability
2. Generation capability
3. Instruction-following capability
4. Cost and latency

**Example**: Imagine you ask a model to summarize a legal contract:
- **Domain-specific capability metrics**: Tell you how good the model is at understanding legal contracts
- **Generation capability metrics**: Measure how coherent or faithful the summary is
- **Instruction-following capability**: Determines whether the summary is in the requested format, such as meeting length constraints
- **Cost and latency metrics**: Tell you how much this summary will cost and how long you will wait for it

The last chapter started with an evaluation approach and discussed what criteria a given approach can evaluate. This section takes a different angle: given a criterion, what approaches can you use to evaluate it?

## Domain-Specific Capability

To build a coding agent, you need a model that can write code. To build an application to translate from Latin to English, you need a model that understands both Latin and English. Coding and English–Latin understanding are domain-specific capabilities.

**Constraint**: A model's domain-specific capabilities are constrained by its configuration (such as model architecture and size) and training data. If a model never saw Latin during its training process, it won't be able to understand Latin. Models that don't have the capabilities your application requires won't work for you.

**Evaluation Approach**: To evaluate whether a model has the necessary capabilities, you can rely on domain-specific benchmarks, either public or private. Thousands of public benchmarks have been introduced to evaluate seemingly endless capabilities:
- Code generation
- Code debugging
- Grade school math
- Science knowledge
- Common sense
- Reasoning
- Legal knowledge
- Tool use
- Game playing

The list goes on.

### Multiple-Choice Questions (MCQs)

Most domain-specific benchmarks rely on multiple-choice questions because they are easy to create, verify, and evaluate.

**Example from MMLU benchmark**:

Question: One of the reasons that the government discourages and regulates monopolies is that

- (A) Producer surplus is lost and consumer surplus is gained.
- (B) Monopoly prices ensure productive efficiency but cost society allocative efficiency.
- (C) Monopoly firms do not engage in significant research and development.
- (D) Consumer surplus is lost with higher prices and lower levels of output.
- Label: (D)

**Metrics**: A multiple-choice question (MCQ) might have one or more correct answers. A common metric is **accuracy**—how many questions the model gets right. Some tasks use a point system to grade performance—harder questions are worth more points. You can also use a point system when there are multiple correct options. A model gets one point for each option it gets right.

**Classification as Special Case**: Classification is a special case of multiple choice where the choices are the same for all questions. For example, for a tweet sentiment classification task, each question has the same three choices: NEGATIVE, POSITIVE, and NEUTRAL. Metrics for classification tasks, other than accuracy, include F1 scores, precision, and recall.

**Why MCQs Are Popular**:
- Easy to create, verify, and evaluate
- Can measure against random baseline
- If each question has four options and only one correct option, the random baseline accuracy would be 25%
- Scores above 25% typically (though not always) mean the model is doing better than random

**Drawback**: A model's performance on MCQs can vary with small changes in how questions and options are presented. Alzahrani et al. (2024) found that the introduction of an extra space between question and answer or addition of an instructional phrase, such as "Choices:" can cause the model to change its answers.

**Limitation for Foundation Models**: Despite the prevalence of close-ended benchmarks, it's unclear if they are a good way to evaluate foundation models. MCQs test the ability to differentiate good responses from bad responses (classification), which is different from the ability to generate good responses. MCQs are best suited for evaluating:
- **Knowledge**: "does the model know that Paris is the capital of France?"
- **Reasoning**: "can the model infer from a table of business expenses which department is spending the most?"

They aren't ideal for evaluating generation capabilities such as summarization, translation, and essay writing.

## Generation Capability

AI was used to generate open-ended outputs long before generative AI became a thing. For decades, the brightest minds in NLP (natural language processing) have been working on how to evaluate the quality of open-ended outputs. The subfield that studies open-ended text generation is called NLG (natural language generation).

**Early NLG Metrics** (2010s era):
- **Fluency**: Measures whether the text is grammatically correct and natural-sounding
- **Coherence**: Measures how well-structured the whole text is
- Task-specific metrics:
  - **Faithfulness** (translation): How faithful is the generated translation to the original sentence?
  - **Relevance** (summarization): Does the summary focus on the most important aspects of the source document?

**Evolution**: Some early NLG metrics, including *faithfulness* and *relevance*, have been repurposed, with significant modifications, to evaluate outputs of foundation models.

**Why Some Metrics Became Less Important**: As generative models improved, many issues of early NLG systems went away. In the 2010s, generated texts didn't sound natural—full of grammatical errors and awkward sentences. Fluency and coherence were important metrics then. However, as language models' generation capabilities improved, AI-generated texts became nearly indistinguishable from human-generated texts. Fluency and coherence become less important. However, these metrics can still be useful for:
- Weaker models
- Applications involving creative writing
- Low-resource languages

Fluency and coherence can be evaluated using AI as a judge or using perplexity (discussed in Chapter 3).

**New Issues with Generative Models**: Generative models, with their new capabilities and new use cases, have new issues that require new metrics to track:
- **Undesired hallucinations**: Hallucinations are desirable for creative tasks, not for tasks that depend on factuality
- **Safety**: Can the generated outputs cause harm to users and society? Safety is an umbrella term for all types of toxicity and biases

**Other Measurements**: There are many other measurements an application developer might care about:
- Controversiality
- Friendliness
- Positivity
- Creativity
- Conciseness

This section focuses on factual consistency and safety.

### Factual consistency

Due to factual inconsistency's potential for catastrophic consequences, many techniques have been and will be developed to detect and measure it.

**Two Settings for Verification**:

**1. Local Factual Consistency**: The output is evaluated against a context. The output is considered factually consistent if it's supported by the given context.
- Example: If the model outputs "the sky is blue" and the given context says the sky is purple, this output is factually inconsistent
- Conversely, given this context, if the model outputs "the sky is purple", this output is factually consistent
- **Important for**: Tasks with limited scopes such as summarization, customer support chatbots, business analysis

**2. Global Factual Consistency**: The output is evaluated against open knowledge. If the model outputs "the sky is blue" and it's a commonly accepted fact that the sky is blue, this statement is considered factually correct.
- **Important for**: Tasks with broad scopes such as general chatbots, fact-checking, market research

**Key Insight**: Factual consistency is much easier to verify against explicit facts. For example, the factual consistency of the statement "there has been no proven link between vaccination and autism" is easier to verify if you're provided with reliable sources that explicitly state whether there is a link.

If no context is given, you'll have to first search for reliable sources, derive facts, and then validate the statement against these facts.

**The Challenge of Determining Facts**: Often, the hardest part of factual consistency verification is determining what the facts are. Whether any of the following statements can be considered factual depends on what sources you trust:
- "Messi is the best soccer player in the world"
- "Climate change is one of the most pressing crises of our time"
- "Breakfast is the most important meal of the day"

The internet is flooded with misinformation: false marketing claims, statistics made up to advance political agendas, and sensational, biased social media posts. It's easy to fall for the absence of evidence fallacy. One might take the statement "there's no link between *X* and *Y*" as factually correct because of a failure to find the evidence that supported the link.

**Tip**: When designing metrics to measure hallucinations, it's important to analyze the model's outputs to understand the types of queries that it is more likely to hallucinate on. Your benchmark should focus more on these queries.

Example patterns where models tend to hallucinate more:
1. Queries that involve niche knowledge (e.g., VMO vs IMO)
2. Queries asking for things that don't exist (e.g., "What did *X* say about *Y*?" when *X* has never said anything about *Y*)

#### Evaluation Approaches for Factual Consistency

Assuming you already have the context to evaluate an output against (either provided by users or retrieved by you), here are the main approaches:

**1. AI as a Judge**: The most straightforward evaluation approach. AI judges can be asked to evaluate anything, including factual consistency. Liu et al. (2023) and Luo et al. (2023) showed that GPT-3.5 and GPT-4 can outperform previous methods at measuring factual consistency.

Example prompt from Liu et al. (2023):
```
Factual Consistency: Does the summary untruthful or misleading facts 
that are not supported by the source text?
Source Text:
{{Document}}
Summary:
{{Summary}}
Does the summary contain factual inconsistency?
Answer:
```

**2. Self-Verification**: SelfCheckGPT (Manakul et al., 2023) relies on an assumption that if a model generates multiple outputs that disagree with one another, the original output is likely hallucinated.
- Given a response R to evaluate, SelfCheckGPT generates N new responses and measures how consistent R is with respect to these N new responses
- This approach works but can be prohibitively expensive, as it requires many AI queries to evaluate a response

**3. Knowledge-Augmented Verification**: SAFE (Search-Augmented Factuality Evaluator), introduced by Google DeepMind (Wei et al., 2024), works by leveraging search engine results to verify the response.

../images/aien_0401.png

**Figure 4-1. SAFE breaks an output into individual facts and then uses a search engine to verify each fact.**

SAFE works in four steps:
1. Use an AI model to decompose the response into individual statements
2. Revise each statement to make it self-contained (e.g., change "it" to the original subject)
3. For each statement, propose fact-checking queries to send to a Google Search API
4. Use AI to determine whether the statement is consistent with the research results

**4. Textual Entailment**: Verifying whether a statement is consistent with a given context can also be framed as *textual entailment*, which is a long-standing NLP task. Textual entailment is the task of determining the relationship between two statements.

Given a premise (context), it determines which category a hypothesis (the output or part of the output) falls into:
- **Entailment**: the hypothesis can be inferred from the premise
- **Contradiction**: the hypothesis contradicts the premise
- **Neutral**: the premise neither entails nor contradicts the hypothesis

Example: Given the context "Mary likes all fruits":
- Entailment: "Mary likes apples"
- Contradiction: "Mary hates oranges"
- Neutral: "Mary likes chickens"

Entailment implies factual consistency, contradiction implies factual inconsistency, and neutral implies that consistency can't be determined.

**5. Specialized Scorers**: Instead of using general-purpose AI judges, you can train scorers specialized in factual consistency prediction. These scorers take in a pair of (premise, hypothesis) as input and output one of the predefined classes. This makes factual consistency a classification task.

Example: `DeBERTa-v3-base-mnli-fever-anli` is a 184-million-parameter model trained on 764,000 annotated (hypothesis, premise) pairs to predict entailment.

**Benchmarks**: Common benchmarks to evaluate factual consistency include TruthfulQA (Lin et al., 2022) and SelfCheckGPT. TruthfulQA contains 817 questions that humans might answer incorrectly due to misconceptions or false beliefs.

### Safety

Safety in AI is a broad topic covering many aspects of how AI can cause harm to users and society. This section focuses on detecting harmful outputs.

**Types of Harmful Content**:
- Hate speech
- Violence
- Self-harm
- Sexual content
- Profanity
- Misinformation
- Political bias

**Detection Approaches**:

**1. General-Purpose AI Judges**: It's possible to use general-purpose AI judges to detect these scenarios, and many people do. GPTs, Claude, and Gemini can detect many harmful outputs if prompted properly. These model providers also develop moderation tools to keep their models safe, and some expose their moderation tools for external use.

**2. Specialized Models**: Harmful behaviors aren't unique to AI outputs—they're unfortunately extremely common online. Many models developed to detect toxicity in human-generated texts can be used for AI-generated texts. These specialized models tend to be much smaller, faster, and cheaper than general-purpose AI judges.

Examples:
- Facebook's hate speech detection model
- Skolkovo Institute's toxicity classifier
- Perspective API
- Language-specific models (Danish, Vietnamese)

**Benchmarks**: Common benchmarks to measure toxicity include:
- **RealToxicityPrompts** (Gehman et al., 2020): Contains 100,000 naturally occurring prompts that are likely to get models to generate toxic outputs
- **BOLD** (bias in open-ended language generation dataset) (Dhamala et al., 2021)

## Instruction-Following Capability

Instruction-following measurement asks: **how good is this model at following the instructions you give it?**

If the model is bad at following instructions, it doesn't matter how good your instructions are, the outputs will be bad. Being able to follow instructions is a core requirement for foundation models, and most foundation models are trained to do so. InstructGPT, the predecessor of ChatGPT, was named so because it was finetuned for following instructions.

**General Principle**: More powerful models are generally better at following instructions. GPT-4 is better at following most instructions than GPT-3.5, and similarly, Claude-v2 is better than Claude-v1.

**Example Scenario**: You ask the model to detect sentiment in a tweet and output NEGATIVE, POSITIVE, or NEUTRAL. The model seems to understand the sentiment of each tweet, but generates unexpected outputs such as HAPPY and ANGRY. This means the model has the domain-specific capability to do sentiment analysis on tweets, but its instruction-following capability is poor.

**Importance**:
- Essential for applications requiring structured outputs (JSON format, matching regular expression)
- Goes beyond generating structured outputs
- Example: If you ask a model to use only words of at most four characters, outputs don't have to be structured, but should still follow the instruction

**Real-World Example**: Ello, a startup that helps kids read better, wants to build a system that automatically generates stories for a kid using only words they can understand. The model needs the ability to follow the instruction to work with a limited pool of words.

**Challenge**: Instruction-following capability isn't straightforward to define or measure, as it can be easily conflated with domain-specific capability or generation capability.

Example: If you ask a model to write a *lục bát* poem (Vietnamese verse form), and the model fails, it can either be because:
- The model doesn't know how to write *lục bát* (domain-specific capability)
- The model doesn't understand what it's supposed to do (instruction-following capability)

**Warning**: How well a model performs depends on the quality of its instructions, which makes it hard to evaluate AI models. When a model performs poorly, it can either be because the model is bad or the instruction is bad.

### Instruction-following criteria

Different benchmarks have different notions of what instruction-following capability encapsulates. Two important benchmarks:

**1. IFEval (Instruction-Following Evaluation)** - Google benchmark
- Focuses on whether the model can produce outputs following an expected format
- Zhou et al. (2023) identified 25 types of instructions that can be automatically verified
- Examples: keyword inclusion, length constraints, number of bullet points, JSON format
- Score: Fraction of instructions followed correctly out of all instructions

**Table 4-2. Automatically verifiable instructions (selected examples)**

| Instruction group | Instruction | Description |
|-------------------|-------------|-------------|
| Keywords | Include keywords | Include keywords {keyword1}, {keyword2} in your response |
| Keywords | Forbidden words | Do not include keywords {forbidden words} in the response |
| Language | Response language | Your ENTIRE response should be in {language} |
| Length constraints | Number words | Answer with at least/around/at most {N} words |
| Detectable format | Number bullets | Your answer must contain exactly {N} bullet points |
| Detectable format | JSON format | Entire output should be wrapped in JSON format |

**2. INFOBench** - Focuses on broader instruction-following aspects beyond just format

### Roleplaying

Many AI use cases involve agents or chatbots playing certain roles, such as a patient, a teacher, or a customer service representative. Evaluating how good a model is at roleplaying is an important aspect of instruction-following capability.

**Key Insight**: To understand what instructions users want models to follow, it's helpful to look at what users are asking for. LMSYS's one-million-conversations dataset shows the top 10 most common instruction types, with "roleplaying" being one of the most common.

## Cost and Latency

Beyond evaluating model capabilities, you also need to evaluate practical constraints:

**Cost Factors**:
- API costs per request
- Compute infrastructure costs (for self-hosted models)
- Data storage costs
- Engineering and maintenance costs

**Latency Factors**:
- Model inference time
- Network latency (for API calls)
- Pre/post-processing time
- Total end-to-end response time

**Trade-offs**: Often there's a trade-off between:
- Performance vs. cost (better models cost more)
- Performance vs. latency (larger models are slower)
- Cost vs. latency (faster inference usually costs more)

**Tip**: Always measure cost and latency in your specific use case. Benchmarks might report different numbers than what you experience in production due to:
- Different batch sizes
- Different hardware
- Different optimization strategies
- Different input/output lengths

# Model Selection

Given an increasing number of foundation models to choose from, how do you select the right model for your application? This section covers the workflow for model selection and key considerations.

## Model Selection Workflow

A typical workflow for evaluating models for your application:

1. **Define Evaluation Criteria**: Based on your application requirements
2. **Gather Candidate Models**: From public sources, APIs, or custom-built
3. **Initial Filtering**: Use public benchmarks to narrow down candidates
4. **Deep Evaluation**: Test top candidates on your specific use cases
5. **Cost/Latency Analysis**: Evaluate practical constraints
6. **Final Selection**: Choose the model that best balances all factors

../images/aien_0405.png

**Figure 4-5. An overview of the evaluation workflow to evaluate models for your application.**

## Model Build Versus Buy

A fundamental question many teams face: should you host your own models or use a model API?

This question has become more nuanced with the introduction of model API services built on top of open source models.

### Open source, open weight, and model licenses

**Important Distinction**: "Open source" in AI context often means "open weights" rather than true open source:
- **Open weights**: Model weights are released, but training code/data may not be
- **True open source**: Includes code, data, and weights with permissive licenses

**License Considerations**:
- Some "open" models have restrictive licenses
- Commercial use may be limited
- Derivative works may have constraints
- Always check the specific license before using

**Note**: The term "open source model" is used throughout the book to refer to models whose weights are openly available, even if they might not technically be open source by software standards.

### Open source models versus model APIs

The decision between self-hosting open source models and using model APIs involves multiple factors:

../images/aien_0406.png

**Figure 4-6. An inference service runs the model and provides an interface for users to access the model.**

#### Data privacy

**Model API Concerns**:
- Your data is sent to the API provider
- Potential exposure of sensitive information
- Uncertain data retention policies
- Risk of data being used for training

**Open Source Advantages**:
- Complete control over data
- Can keep data on-premises
- No external data sharing
- Better for sensitive applications (healthcare, finance, legal)

**Mitigations for APIs**:
- Use providers with strong privacy guarantees
- Look for dedicated instances
- Check for data processing agreements
- Consider data anonymization

**Note**: Even with dedicated instances, there's still risk if the API provider is compromised.

#### Data lineage and copyright

**Concern**: If a model provider doesn't disclose their training data, you won't know if the model was trained on copyrighted material that you don't have rights to use.

**Implications**:
- Potential legal risks for commercial use
- Uncertainty about model capabilities and biases
- Difficulty understanding failure modes

**Open Source Advantage**: Many open source models disclose their training data, allowing you to:
- Verify copyright compliance
- Understand model capabilities better
- Assess potential biases
- Make informed decisions about commercial use

#### Performance

**Historical Gap**: There used to be a significant performance gap between proprietary and open source models. Proprietary models (GPT-4, Claude) consistently outperformed open source alternatives.

../images/aien_0407.png

**Figure 4-7. The gap between open source models and proprietary models is decreasing on the MMLU benchmark.**

**Current State**: The gap is closing:
- Llama 3, Mistral, and other open source models are competitive
- For many tasks, open source models are "good enough"
- Some specialized open source models outperform general proprietary ones

**Considerations**:
- Evaluate on your specific use case
- Proprietary models may still lead on cutting-edge capabilities
- Open source catching up rapidly

#### Functionality

**API Advantages**:
- Regular updates and improvements
- Access to latest capabilities
- Managed infrastructure
- Additional features (embeddings, fine-tuning, etc.)

**Open Source Considerations**:
- Versions are fixed (predictable but not improving)
- You control when to update
- Can customize and fine-tune
- May lack some advanced features

#### API cost versus engineering cost

**API Costs**:
- Pay per request (input/output tokens)
- Predictable pricing
- Scales with usage
- No upfront infrastructure investment

**Self-Hosting Costs**:
- Infrastructure (GPUs, servers, networking)
- Engineering time (setup, maintenance, optimization)
- Monitoring and operations
- Scaling costs

**Trade-off Considerations**:
- At low volume: APIs are cheaper
- At high volume: Self-hosting may be cheaper
- Factor in engineering complexity
- Consider total cost of ownership

**Example Calculation**:
- Small startup with 10K requests/day: API likely cheaper
- Large company with 10M requests/day: Self-hosting potentially cheaper
- Must include engineering costs in comparison

#### Control, access, and transparency

**Why Enterprises Care About Open Source Models**:

../images/aien_0408.png

**Figure 4-8. Why enterprises care about open source models.**

Key reasons enterprises prefer open source:
1. **Control**: Full control over model behavior and updates
2. **Transparency**: Can inspect model architecture and weights
3. **Customization**: Can fine-tune for specific needs
4. **No Vendor Lock-in**: Can switch models or approaches
5. **Reliability**: Not dependent on external service availability
6. **Compliance**: Easier to meet regulatory requirements

**API Limitations**:
- Limited control over model updates
- Provider can discontinue service
- Rate limits and usage restrictions
- Less transparency in how models work

#### On-device deployment

**Growing Trend**: Running models directly on user devices (phones, laptops, IoT devices).

**Why It Matters**:
- Extreme privacy (data never leaves device)
- Works offline
- Lower latency
- No API costs for users

**Requirements**:
- Models must be small enough for device
- Efficient inference on limited compute
- Requires open source or licensed weights

**Use Cases**:
- Mobile keyboard predictions
- Voice assistants
- Photo editing apps
- Real-time translation

**Current State**: This requires open source models, as proprietary API models can't run on-device.

## Navigate Public Benchmarks

Public benchmarks are valuable for initial model screening, but must be used carefully.

### Benchmark selection and aggregation

**Challenges**:
- Thousands of benchmarks available
- Not all benchmarks are reliable
- Different benchmarks measure different things
- Results can be cherry-picked

**Best Practices**:
- Use multiple benchmarks
- Select benchmarks relevant to your domain
- Understand what each benchmark measures
- Look for independent evaluations

#### Public leaderboards

**Popular Leaderboards**:
- Hugging Face Open LLM Leaderboard
- Chatbot Arena
- LMSYS Leaderboard
- AlpacaEval

**Advantages**:
- Easy comparison across models
- Community-driven evaluation
- Regular updates
- Broad coverage

**Limitations**:
- May not reflect your specific use case
- Can be gamed by model developers
- Aggregate scores hide nuances
- Some models optimize specifically for leaderboards

**Note**: Treat leaderboards as a starting point for model selection, not the final decision.

#### Custom leaderboards with public benchmarks

**Recommendation**: Create your own leaderboard using:
- Public benchmarks relevant to your domain
- Your own evaluation data
- Weights reflecting your priorities

**Example**: If building a customer support chatbot:
- 40% weight on instruction-following
- 30% weight on safety
- 20% weight on factual consistency
- 10% weight on latency

This gives you a customized ranking more relevant to your needs than generic leaderboards.

# Are OpenAI's Models Getting Worse?

An interesting phenomenon: some users reported that GPT-4 and GPT-3.5 seemed to get worse over time.

**Research Finding**: Chen et al. (2023) found that model performance on certain benchmarks actually did decline from March 2023 to June 2023.

../images/aien_0409.png

**Figure 4-9. Changes in the performances of GPT-3.5 and GPT-4 from March 2023 to June 2023 on certain benchmarks.**

**Possible Explanations**:
1. **Model Updates**: OpenAI regularly updates models, changes may affect performance
2. **Trade-offs**: Improvements in one area may hurt performance in another
3. **Data Contamination**: Benchmarks may become less reliable over time
4. **Alignment Changes**: Safety improvements may reduce performance on some tasks
5. **User Expectations**: As users become more sophisticated, they notice more issues

**Key Insight**: Model performance isn't monotonically improving. Updates can help and hurt different use cases differently.

### Data contamination with public benchmarks

**The Problem**: If a model's training data includes benchmark questions and answers, the model's performance on that benchmark isn't meaningful—it's essentially memorization rather than true capability.

#### How data contamination happens

**Sources of Contamination**:
- Benchmarks posted publicly on the internet
- Research papers with full datasets
- GitHub repositories with benchmark data
- Discussion forums analyzing benchmarks

**Why It's Hard to Avoid**:
- Training data is scraped from the internet
- Can't easily filter out all benchmarks
- New benchmarks quickly appear in training data
- Hard to verify what's in training data

**Extent of Problem**: Some researchers estimate significant portions of popular benchmarks are in training data of major models.

#### Handling data contamination

**Detection Methods**:
1. **Perplexity Analysis**: Models have lower perplexity on memorized data
2. **Verbatim Matching**: Check if model can reproduce benchmark examples exactly
3. **Perturbation Testing**: Slightly modify questions; contaminated models show bigger performance drops
4. **Release Practices**: Use private test sets that are never published

**Mitigation Strategies**:
1. **Clean Benchmarks**: Use only parts of benchmarks confirmed not in training data
2. **New Benchmarks**: Create fresh benchmarks after model training
3. **Dynamic Benchmarks**: Generate new questions programmatically
4. **Private Evaluation**: Keep evaluation data completely private

../images/aien_0410.png

**Figure 4-10. Relative difference in GPT-3's performance when evaluating using only the clean sample compared to evaluating using the whole benchmark.**

**Best Practice**: Always be suspicious of benchmark results. Use multiple benchmarks and ideally include your own evaluation data.

# Design Your Evaluation Pipeline

An evaluation pipeline is a systematic process for continuously evaluating your AI application as it evolves. This section covers how to build one.

## Step 1. Evaluate All Components in a System

An AI application typically consists of multiple components working together. Don't just evaluate the model—evaluate the entire system.

**Components to Evaluate**:
1. **Data Pipeline**: Quality of input data, preprocessing, cleaning
2. **Model(s)**: Core AI models and their outputs
3. **Retrieval System**: If using RAG, evaluate context retrieval
4. **Post-Processing**: Any logic applied to model outputs
5. **User Interface**: How results are presented to users
6. **Integration Points**: APIs, databases, external services

**Example Chatbot System Components**:
- User input processing
- Intent classification
- Context retrieval from knowledge base
- Response generation (LLM)
- Response validation
- Output formatting

**Why This Matters**: A failure in any component can break the entire system. You need visibility into each part to diagnose issues and improve systematically.

**Approach**:
- Create evaluation metrics for each component
- Track metrics separately
- Understand dependencies between components
- Identify bottlenecks and weak points

## Step 2. Create an Evaluation Guideline

An evaluation guideline documents how your application should be evaluated. It serves as:
- Reference for the team
- Basis for consistency
- Communication tool for stakeholders
- Historical record of evaluation decisions

### Define evaluation criteria

**Process**:
1. List all criteria that matter for your application
2. Define what each criterion means specifically for your use case
3. Prioritize criteria (not all are equally important)
4. Document how each will be measured

**Example for Customer Support Chatbot**:

| Criterion | Definition | Priority | Measurement |
|-----------|------------|----------|-------------|
| Accuracy | Provides correct information from knowledge base | High | Factual consistency check |
| Helpfulness | Actually solves user's problem | High | User satisfaction survey |
| Tone | Maintains professional, friendly tone | Medium | AI judge evaluation |
| Latency | Responds within 3 seconds | High | Direct measurement |
| Cost | Under $0.01 per conversation | Medium | Direct measurement |

### Create scoring rubrics with examples

**What is a Rubric**: A detailed scoring guide that explains what different quality levels look like.

**Why Rubrics Matter**:
- Ensure consistency across evaluators
- Make evaluation reproducible
- Help identify specific improvement areas
- Facilitate communication about quality

**Example Rubric for Helpfulness** (1-5 scale):

**Score 5 (Excellent)**:
- Directly answers the user's question
- Provides additional helpful context
- Anticipates follow-up questions
- Example: [specific example]

**Score 4 (Good)**:
- Answers the user's question completely
- Information is accurate and relevant
- Example: [specific example]

**Score 3 (Acceptable)**:
- Answers the question but misses some details
- May require follow-up for completeness
- Example: [specific example]

**Score 2 (Poor)**:
- Partially answers but significant gaps
- May contain minor inaccuracies
- Example: [specific example]

**Score 1 (Unacceptable)**:
- Does not answer the question
- Contains significant errors
- Example: [specific example]

**Best Practice**: Include actual examples from your application for each score level.

### Tie evaluation metrics to business metrics

**The Connection**: Evaluation metrics should ultimately tie back to business outcomes.

**Examples**:
- Accuracy → Customer satisfaction → Retention
- Latency → User experience → Engagement
- Safety → Trust → Brand reputation
- Cost → Profitability → Business viability

**Why It Matters**:
- Justifies evaluation investment
- Helps prioritize improvements
- Communicates value to stakeholders
- Guides decision-making

**Approach**:
1. Identify key business metrics (revenue, retention, satisfaction, etc.)
2. Map evaluation metrics to business metrics
3. Quantify the relationship where possible
4. Track both sets of metrics over time

**Example**: 
- Evaluation metric: Factual accuracy improves from 85% to 95%
- Business metric: Customer support ticket volume decreases by 20%
- Result: Operational cost savings of $X per month

## Step 3. Define Evaluation Methods and Data

Once you know what to evaluate and how to score it, decide on methods and data.

### Select evaluation methods

Choose from methods discussed in Chapter 3:
- Exact match
- Lexical similarity
- Semantic similarity
- AI as a judge
- Human evaluation
- Hybrid approaches

**Considerations**:
- What's most appropriate for each criterion?
- What resources do you have (time, budget, people)?
- What's the required speed of evaluation?
- How much precision do you need?

**Common Strategy**: Use multiple methods:
- Fast automated checks for quick feedback
- Deeper evaluation for important decisions
- Human evaluation for ambiguous cases
- Regular audits of automated evaluations

### Annotate evaluation data

**Evaluation Data**: A set of (input, expected output) pairs or (input, criteria) pairs used to test your system.

**Sources of Evaluation Data**:
1. **Real user data**: Actual queries and interactions from production
2. **Synthetic data**: Generated examples covering edge cases
3. **Curated examples**: Hand-picked cases representing important scenarios
4. **Adversarial examples**: Designed to test specific failure modes

**How Much Data**: Depends on:
- Application complexity
- Evaluation method
- Available resources
- Required confidence level

**Typical Sizes**:
- Quick check: 50-100 examples
- Standard evaluation: 500-1000 examples
- Comprehensive evaluation: 5000+ examples

**Annotation Process**:
1. **Sample Selection**: Choose diverse, representative examples
2. **Labeling**: Have experts create expected outputs or scores
3. **Review**: Multiple annotators for important cases
4. **Documentation**: Record rationale for decisions
5. **Version Control**: Track changes to evaluation set

**Tip**: Start small and expand your evaluation set over time. A small, high-quality set is better than a large, noisy set.

**Common Mistake**: Using only "easy" examples. Make sure to include:
- Edge cases
- Failure modes
- Ambiguous scenarios
- Adversarial examples

### Evaluate your evaluation pipeline

**Meta-Evaluation**: Your evaluation pipeline itself needs evaluation!

**Questions to Ask**:
- Are metrics consistent and reproducible?
- Do automated evaluations correlate with human judgment?
- Are we measuring what we think we're measuring?
- Are we missing important failure modes?
- Do metrics align with business outcomes?

**Approaches**:
1. **Inter-rater Reliability**: Multiple evaluators score same examples
2. **Correlation Analysis**: Compare automated vs human evaluation
3. **Retrospective Analysis**: Check if evaluation predicted real-world performance
4. **Failure Analysis**: When system fails, did evaluation catch it?

**Warning Signs**:
- High variance in scores
- Automated and human evaluations disagree
- Evaluation looks good but users complain
- Can't reproduce evaluation results
- Metrics don't correlate with business outcomes

### Iterate

**Evaluation is Ongoing**: Don't create your evaluation pipeline once and forget it.

**Reasons to Update**:
- Application evolves
- New failure modes discovered
- User needs change
- Better evaluation methods available
- Business priorities shift

**Regular Activities**:
1. **Review Metrics**: Are they still relevant?
2. **Update Data**: Add new examples, remove outdated ones
3. **Refine Rubrics**: Improve scoring guidelines based on experience
4. **Audit Results**: Check if evaluation is accurate
5. **Incorporate Feedback**: Learn from production issues

**Cadence**:
- Continuous: Automated evaluation on every change
- Weekly: Review metrics and trends
- Monthly: Deep dive into specific issues
- Quarterly: Comprehensive evaluation pipeline review

# Summary

This chapter covered how to evaluate AI systems in the context of your application:

**Evaluation-Driven Development**:
- Define evaluation criteria before building
- Focus on applications with measurable outcomes
- Evaluation is the biggest bottleneck to AI adoption
- Building reliable evaluation pipelines unlocks new applications

**Evaluation Criteria**:
- **Domain-Specific Capability**: Does the model have necessary skills?
- **Generation Capability**: Quality of open-ended outputs (factual consistency, safety)
- **Instruction-Following**: Can the model follow your instructions?
- **Cost and Latency**: Practical constraints

**Model Selection**:
- Use systematic workflow for evaluation
- Consider build vs buy trade-offs
- Factors: privacy, performance, cost, control
- Open source vs proprietary is nuanced decision
- Use public benchmarks cautiously

**Benchmark Considerations**:
- Thousands available, not all reliable
- Data contamination is a real problem
- Use multiple benchmarks
- Create custom evaluation relevant to your use case
- Don't rely solely on leaderboards

**Evaluation Pipeline**:
- Evaluate all system components, not just the model
- Create clear evaluation guidelines with rubrics
- Tie evaluation metrics to business metrics
- Choose appropriate evaluation methods
- Build high-quality evaluation datasets
- Continuously iterate and improve

**Key Takeaways**:
1. Evaluation should drive development, not follow it
2. Multiple evaluation methods provide better coverage
3. Context matters—evaluate in your specific use case
4. Balance automated and human evaluation
5. Public benchmarks are useful but insufficient
6. Build evaluation pipelines that evolve with your application
7. Connect evaluation metrics to business outcomes
8. Meta-evaluate your evaluation approach

The next chapter will explore prompt engineering—how to effectively communicate with AI models to get the best results.
