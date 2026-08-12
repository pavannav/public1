# Chapter 8. Dataset Engineering

## Overview

**Core Principle**: The quality of a model depends on the quality of its training data. The best ML team in the world with infinite compute can't help you finetune a good model if you don't have data.

**Goal of Dataset Engineering**: Create a dataset that allows you to train the best model, ideally within your allocated budget.

**Growing Importance**: As fewer companies can afford to develop models from scratch, more are turning to data to differentiate their AI performance. As models demand more data, data handling becomes more challenging and demands more investments in talent and infrastructure.

**Evolution of Data Operations**: Data operations have evolved from side tasks that people handle when they have time to dedicated roles. Many AI companies now employ:
- Data labelers
- Dataset creators  
- Data quality engineers

These roles are either integrated into or working alongside core engineering teams.

**The Data Landscape**: If the model landscape is confusing enough with numerous offerings, the data landscape is even more complex, with an ever-growing array of datasets and techniques being introduced.

**Chapter Structure**: This chapter gives an overview of the data landscape and considerations when building your own dataset:
1. **Data curation**: What data do you need? How much? What does it mean for data to be high quality?
2. **Data synthesis**: Techniques for generating data programmatically
3. **Data processing**: Cleaning, filtering, formatting

**Non-Linear Process**: Data curation, generation, and processing don't follow a linear path. You'll likely have to go back and forth between different steps.

**Focus on Post-Training**: For the same model, different training phases require datasets with different attributes. This chapter focuses on post-training data because that's more relevant to application developers. However, lessons from pre-training data are included when insightful.

**Reality Check**: There are best practices you can follow and tools to automate parts of the process. However, **data will mostly just be toil, tears, and sweat**.

# A Data-Centric View of AI

The increasing focus on data during AI development has given rise to **data-centric AI**, as opposed to **model-centric AI**:

**Model-Centric AI**:
- Tries to improve AI performance by enhancing the models themselves
- Involves designing new architectures
- Increasing model sizes
- Developing new training techniques

**Data-Centric AI**:
- Tries to improve AI performance by enhancing the data
- Involves developing new data processing techniques
- Creating high-quality datasets that allow better models to be trained with fewer resources

**Evolution of Benchmarks**:
- **Early days of deep learning**: Many AI benchmarks were model-centric
  - Given a dataset like ImageNet, people try to train the best possible model using the same dataset
- **Recent years**: More benchmarks have become data-centric
  - Given the same model, people try to develop a dataset that gives this model the best performance

**Notable Data-Centric Competitions**:

**2021 - Andrew Ng's Competition**:
- Participants improved upon the same base dataset
- Applied techniques: fixing incorrect labels, adding edge case examples, augmenting data

**2023 - DataComp**:
- Goal: Create the best dataset for training a CLIP model
- Standardized script trains a CLIP model on each submitted dataset
- Dataset quality evaluated based on resulting model's performance on 38 downstream tasks

**2024 - DataComp for Language Models**:
- Similar competition for language models
- Scales from 412M to 7B parameters

**Other Data-Centric Benchmarks**:
- DataPerf (MLCommons, 2023)
- dcbench (Eyuboglu and Karlaš, 2022)

**Reality**: The model-centric and data-centric division helps guide research. However, meaningful technological progress often requires investment in both model and data improvements.

# Data Curation

While not all issues with AI models can be solved with data, **data is often a key part of the solution**:

**What Good Data Can Do**:
- Make the model more capable
- Make the model safer
- Enable handling of longer contexts

**What Poor Data Can Do**:
- Cause the model to increase biases
- Increase hallucinations
- Harm the model
- Waste resources

**Data Curation as a Science**: Data curation requires understanding:
- How the model learns
- What resources are available to help it learn

Dataset builders should work closely with application and model developers. In small teams, they might be the same person. However, organizations with high data demands often employ specialized roles.

## What Data Do You Need?

What data you need depends on your task and what you want to teach the model:

**Self-Supervised Finetuning**:
- Need: Sequences of data
- Example: Raw legal documents for legal QA

**Instruction Finetuning**:
- Need: Data in (instruction, response) format
- Example: (question, answer) pairs

**Preference Finetuning**:
- Need: Data in (instruction, winning response, losing response) format
- Example: Multiple responses ranked by quality

**Reward Model Training**:
- Need: Same format as preference finetuning OR
- Data with annotated scores: ((instruction, response), score) format

**Training Data Principle**: Training data should exhibit the behaviors you want your model to learn.

### Complex Behaviors Require Complex Data

Acquiring high-quality data annotations is always challenging, but it's even more challenging if you want to teach models complex behaviors such as:

**1. Chain-of-Thought (CoT) Reasoning**:

CoT prompting nudges the model to work through a problem step-by-step before producing the final answer. To teach a model to generate step-by-step responses, its training data should include CoT responses.

**Impact**: "Scaling Instruction-Finetuned Language Models" shows that incorporating step-by-step responses in finetuning data greatly enhances performance of models of various sizes on CoT tasks, with accuracy nearly doubling for certain tasks.

**Challenge**: Generating multi-step responses is tedious and time-consuming. Explaining how to solve a math problem step-by-step is much more challenging than simply giving the final answer.

**Example Comparison**:
```
Instruction: What is the boiling point of Nitrogen?
Response (without CoT): -320.4F

CoT instruction: Answer the following question by reasoning step-by-step.
What is the boiling point of Nitrogen?
Response (with CoT): 
Step 1: Identify what is being asked - the boiling point of Nitrogen
Step 2: Recall that Nitrogen is element 7 on periodic table
Step 3: Recall that Nitrogen is a gas at room temperature
Step 4: Look up or recall the boiling point: -320.4F (-195.8C)
Final Answer: -320.4F
```

**2. Tool Use**:

To teach a model to use tools, training data should include examples of tool use. This includes:
- When to call which tool
- What parameters to pass
- How to interpret results
- How to combine results from multiple tools

**Challenge**: Creating tool use examples requires:
- Understanding the tools
- Demonstrating correct usage patterns
- Including error handling
- Showing multi-step reasoning

**Reality**: These complex behaviors require more sophisticated training data, which is harder and more expensive to create.

## Data Quality

**Definition**: High-quality data is:
- **Accurate**: Factually correct
- **Relevant**: Pertinent to the task
- **Consistent**: Follows consistent patterns and standards
- **Complete**: Contains all necessary information
- **Unbiased**: Doesn't perpetuate harmful biases

**Impact of Quality**: Low-quality data can:
- Cause models to learn incorrect patterns
- Increase hallucinations
- Perpetuate biases
- Reduce model performance

**Quality > Quantity**: A small amount of high-quality data is often better than a large amount of low-quality data.

**Quality Control Challenges**:
- Difficult to assess quality at scale
- Subjective (what's "good" can vary)
- Expensive (requires expert review)
- Time-consuming

**Best Practices**:
- Sample and manually review data
- Use multiple annotators for important examples
- Create clear annotation guidelines
- Iterate on guidelines based on feedback
- Use AI to assist but not replace human judgment

## Data Coverage

**Definition**: Data coverage, also called data diversity, refers to how well your data represents the full scope of scenarios your model will encounter.

**Why It Matters**:
- Models learn what they see
- If training data doesn't cover a scenario, model likely won't handle it well
- Edge cases are often underrepresented

**Types of Coverage**:

**1. Input Coverage**:
- Different phrasings of same question
- Different domains
- Different languages
- Different difficulty levels

**2. Output Coverage**:
- Different response styles
- Different lengths
- Different formats

**3. Demographic Coverage**:
- Different user groups
- Different perspectives
- Different cultural contexts

**Quality AND Diversity Matter**:

../images/aien_0801.png

**Figure 8-1. A 7B-parameter model, finetuned on a dataset that is both high-quality and diverse, outperforms that same model finetuned on a dataset that is either diverse or high-quality.**

**Key Finding**: Both quality and diversity are necessary. A dataset that is:
- High-quality but not diverse: Limited applicability
- Diverse but not high-quality: Poor performance
- Both high-quality AND diverse: Best performance

**Achieving Coverage**:
- Identify important scenarios
- Ensure sufficient examples for each
- Balance representation across categories
- Include edge cases
- Test on diverse evaluation set

## Data Quantity

**The Question**: How much data do you need?

**The Frustrating Answer**: It depends on:
- Task complexity
- Model size
- Base model capabilities
- Data quality
- How different your task is from pre-training

**Note**: There's no universal formula. Experimentation is necessary.

**General Patterns**:

**Pattern 1: Diminishing Returns**

More data helps, but with diminishing returns. The first 100 examples have more impact than examples 1000-1100.

**Pattern 2: Model Size Matters**

With limited data:
- More advanced models give much better performance after finetuning
- Smaller models need more data to reach same performance

../images/aien_0802.png

**Figure 8-2. With 100 examples, more advanced models give much better performance after finetuning. With 550,000 examples, all models give similar performance after finetuning.**

**With abundant data**:
- All models (even smaller ones) can achieve similar performance
- The advantage of larger models diminishes

**Implication**: If you have limited data, use a stronger base model.

**Tip**: Create a **performance gain curve** with different dataset sizes to estimate the impact of additional training examples.

../images/aien_0803.png

**Figure 8-3. The performance gain curve with different dataset sizes can help you estimate the impact of additional training examples on your model's performance.**

**How to Create**:
1. Finetune model on increasing amounts of data (100, 500, 1000, 5000, etc.)
2. Evaluate performance at each point
3. Plot the curve
4. Extrapolate to estimate how much more data you might need

**Pattern 3: Task Diversity**

For multi-task models, diversity in number of tasks can impact performance:

../images/aien_0804.png

**Figure 8-4. Diversity in finetuning number, measured by the number of tasks, can impact model performance.**

**Finding**: Including examples from more diverse tasks can improve overall model performance, even if it means fewer examples per task.

## Data Acquisition and Annotation

**Before Creating Your Own Data**: Check available datasets first. Data marketplaces are vast and offer both open source and proprietary data. If you're lucky, some might be exactly what you need.

**Reality**: It's often a mix-and-match approach. A dataset can be developed from multiple data sources via multiple acquisition channels.

**Example Process** for creating an (instruction, response) dataset:

1. Find available datasets with desirable characteristics (10,000 examples)
2. Remove low-quality instructions (9,000 examples remaining)
3. Set aside instructions with low-quality responses (3,000 such examples → 6,000 high-quality pairs remaining)
4. Manually write responses for 3,000 high-quality instructions (9,000 total)
5. Realizing not enough data for topic X, manually create 100 instruction templates about X
6. Use AI model to synthesize 2,000 instructions using these templates
7. Manually annotate these 2,000 synthetic instructions (11,000 total)

**Reality Check**: This is an oversimplification. The actual process involves:
- Multiple iterations
- Updating annotation guidelines
- Re-annotating data
- Fact-checking annotations
- Adjusting synthesis strategies
- And much more

# Resources for Publicly Available Datasets

Here are resources where you can look for publicly available datasets:

**Major Repositories**:
1. **Hugging Face** and **Kaggle**: Each host hundreds of thousands of datasets
2. **Google Dataset Search**: Wonderful and underrated
3. **Data.gov**: US government, hundreds of thousands of datasets
4. **data.gov.in**: Indian government, tens of thousands of datasets
5. **UC Irvine's Machine Learning Repository** and **OpenML**: Older repositories, several thousand each
6. **Open Data Network**: Search among tens of thousands of datasets
7. **AWS Open Data**: Cloud provider datasets
8. **TensorFlow datasets**: Pre-built datasets within framework
9. **Eleuther AI's lm-evaluation-harness**: 400+ benchmark datasets, averaging 2,000+ examples each
10. **Stanford Large Network Dataset Collection**: Great for graph datasets

**University Resources**:
- **University of Michigan's Institute for Social Research** (ICPSR): Data from tens of thousands of social studies

**Important Warnings**:
- **Never fully trust available data** - needs thorough inspection and validation
- **Always check dataset licenses** before using
- **Understand data lineage** - even if a dataset has a license allowing commercial use, part of it might come from a source that doesn't

## Annotation Guidelines

Often, you might need to annotate your own data for finetuning. Annotation is challenging not just because of the annotation process but also due to the complexity of **creating clear annotation guidelines**.

**What Guidelines Must Address**:
- What does a good response look like?
- What makes a response good?
- Can a response be correct but unhelpful?
- What's the difference between responses that deserve scores of 3 vs 4?

**Need for Guidelines**: Annotation guidelines are needed for both:
- Manual annotations (human annotators)
- AI-powered annotations (AI judges)

**Real-World Challenge**: Some teams (including LinkedIn) have reported that annotation guidelines were among the most challenging parts of their AI engineering pipeline.

**Common Pitfall**: It's alarming how often people abandon careful annotation halfway due to time and effort required, hoping instead that their models will figure out the right responses on their own. Many models are strong enough that they can occasionally succeed, but relying on models to figure that out might be too risky for many applications.

**Good News**: These guidelines are the same as those for evaluation data (discussed in Chapter 4). This is another argument for why you should invest more time in curating evaluation guidelines and data.

**Bonus**: If you're lucky, your evaluation examples can be augmented or used as seed examples to synthesize new data.

# Data Augmentation and Synthesis

Together with compute and talent, **data is the hardest challenge of AI**. It's been a long-term goal of the whole industry to be able to generate data programmatically.

**Two Processes**:

**Data Augmentation**:
- Creates new data from existing data (which is real)
- Example: Given a real image of a cat, flip it to create a new image of the same cat

**Data Synthesis**:
- Generates data to mimic properties of real data
- Example: Simulate how a mouse moves through a web page to generate data for bot movements

**Key Difference**:
- Augmented data is derived from real data
- Synthetic data isn't real

However, since the goal of both is to automate data creation, sometimes the two terms are used interchangeably.

## Why Data Synthesis

**Historical Use**: Artificially generated data has a long history in software engineering. Originally used to generate fake data for testing purposes.

**Traditional Tools**: Libraries like *Faker* and *Chance* let you generate data in simple formats:
- Names
- Addresses
- Phone numbers
- Email addresses

**Example Use Case**: You've built a program to parse shipping addresses. You can use fake data generators to generate addresses in different countries and states with different formats to make sure your program can parse all of them.

**AI-Powered Evolution**: With AI being capable of generating data indistinguishable from that generated by humans, it's possible to synthesize much more sophisticated data:
- Doctor's notes
- Contracts
- Financial statements
- Product descriptions
- Images
- Video commercials

This makes it easier to generate data and enables more synthetic data use cases.

**Reality Check**: While synthetic data promises to significantly reduce the pressure for human-generated data, **synthetic data doesn't completely replace human data**. In many use cases, mixing human- and AI-generated data often produces the best value.

## Traditional Data Synthesis Techniques

### Rule-based data synthesis

**How It Works**: Create rules or templates to generate data.

**Example - Generate Questions**:
```
Template: "What is the [attribute] of [entity]?"
Entities: ["sun", "moon", "earth"]
Attributes: ["diameter", "mass", "temperature"]

Generated:
- "What is the diameter of the sun?"
- "What is the mass of the moon?"
- "What is the temperature of the earth?"
```

**Advantages**:
- Full control over generated data
- Deterministic
- Fast
- No AI required

**Disadvantages**:
- Generated data can be repetitive
- Lacks natural variation
- Templates can be tedious to create
- Hard to scale to complex scenarios

**Best For**:
- Structured data
- Well-defined domains
- Testing purposes
- When you need guaranteed properties

### Simulation

**How It Works**: Create a simulated environment and collect data from it.

**Examples**:
- **Robotics**: Simulate robot navigation to collect training data
- **Self-driving cars**: Simulate driving scenarios
- **Gaming**: Simulate player behavior
- **Fraud detection**: Simulate bot behavior

**Advantages**:
- Can generate unlimited data
- Safe (no real-world consequences)
- Can control for specific scenarios
- Can generate rare events

**Disadvantages**:
- Simulation might not match reality
- Building simulators is expensive
- Requires domain expertise

**Best For**:
- Physical systems
- Safety-critical applications
- Scenarios that are rare or dangerous in real world

## AI-Powered Data Synthesis

AI models can now generate sophisticated synthetic data.

**How It Works**:
1. Provide AI model with seed examples or instructions
2. Model generates new examples
3. Filter/validate generated examples
4. Add to dataset

**Advantages**:
- Can generate very natural-looking data
- Can scale easily
- Can create diverse examples
- Can generate complex formats

**Challenges**:
- Quality control
- Potential for superficial imitation
- Model collapse risk
- Obscure data lineage

### Instruction data synthesis

**Goal**: Generate (instruction, response) pairs for instruction finetuning.

**Approach**: Use a strong model to generate instructions and/or responses.

**Example - Stanford's Alpaca**:
- Used GPT-3.5 to generate 52,000 instruction-following examples
- Started with 175 seed tasks written by humans
- Model generated variations and new tasks

../images/aien_0805.png

**Figure 8-5. A seed task and a generated task used to train Alpaca.**

**Process**:
1. **Seed Generation**: Create small set of high-quality seed examples
2. **Instruction Generation**: Use AI to generate variations or new instructions
3. **Response Generation**: Use AI to generate responses for instructions
4. **Validation**: Filter and verify generated data
5. **Iteration**: Refine and repeat

**Techniques**:
- **Self-Instruct**: Model generates its own training data
- **Evol-Instruct**: Progressively evolve instructions to be more complex
- **Back-translation**: Generate instruction from response

**Best Practices**:
- Start with diverse seed examples
- Generate in batches and validate
- Use strong models for generation
- Mix synthetic with human data
- Continuously monitor quality

### Data verification

**The Problem**: AI-generated data can contain errors, hallucinations, or low-quality examples.

**Verification Strategies**:

**1. Programmatic Checks**:
- Format validation
- Length checks
- Consistency checks

**2. Human Review**:
- Sample and manually review
- Use domain experts for complex domains
- Flag suspicious examples

**3. AI-Assisted Verification**:
- Use another AI model to check quality
- Can be more cost-effective than human review
- Still requires some human oversight

**4. Execution-Based Validation**:
- For code: Run it and check if it works
- For formulas: Verify calculations
- For facts: Check against knowledge bases

**Best Practice**: Use multiple verification methods in combination.

### Limitations to AI-generated data

Despite its promise, AI-generated data has significant limitations:

#### Quality control

**Challenge**: AI models can generate plausible-looking but incorrect data.

**Examples**:
- Factual errors
- Logical inconsistencies
- Subtle biases
- Format violations

**Mitigation**:
- Thorough verification process
- Mix with human-generated data
- Continuous monitoring
- Domain expert review

#### Superficial imitation

**Challenge**: AI may imitate the style of training data without capturing deeper patterns.

**Example**: Model generates responses that sound right but lack substance or accuracy.

**Result**: Model trained on such data may:
- Sound confident but be wrong
- Memorize patterns without understanding
- Fail on out-of-distribution inputs

**Mitigation**:
- Focus on quality over quantity
- Include diverse examples
- Test on challenging evaluation sets
- Mix synthetic with human data

#### Potential model collapse

**The Risk**: If a model is repeatedly trained on data generated by models, it may experience **model collapse**:
- Model outputs become less diverse
- Quality degrades over generations
- Model "forgets" rare patterns

**Why It Happens**:
- AI models generate likely outputs, not full distribution
- Rare but valid patterns get filtered out
- Errors accumulate over generations

**Mitigation**:
- Always include human-generated data in mix
- Don't train exclusively on AI-generated data
- Monitor diversity metrics
- Refresh with new human data periodically

#### Obscure data lineage

**The Problem**: With AI-generated data, it becomes harder to track data provenance:
- Where did the data come from?
- What data was used to train the generator?
- Does it contain copyrighted material?

**Legal and Ethical Concerns**:
- Copyright issues
- Privacy concerns
- Compliance challenges
- Accountability problems

**Best Practices**:
- Document generation process
- Track which models generated which data
- Keep records of seed data
- Be transparent about use of synthetic data

## Model Distillation

**Model Distillation** is a special case of data synthesis where you use a strong "teacher" model to create training data for a weaker "student" model.

**Process**:
1. Run teacher model on inputs
2. Collect teacher's outputs (or intermediate representations)
3. Train student model to mimic teacher

**Benefits**:
- Student model is typically much smaller than teacher
- Can deploy smaller, faster, cheaper model
- Student can inherit teacher's capabilities

**Example**: Use GPT-4 to generate responses, then finetune a 7B model on those responses.

**Note**: This is also a form of compression—you're compressing the knowledge from a large model into a smaller one.

**Limitations**:
- Student typically doesn't match teacher's performance
- Some capabilities don't transfer well
- Still need to pay for teacher model during data generation

# Data Processing

Once you have data (whether collected or generated), you need to process it to make it suitable for training.

**Tip**: Data processing is iterative. You'll likely go through multiple rounds of processing as you discover issues with your data.

## Inspect Data

**First Step**: Always thoroughly inspect your data before training.

**What to Look For**:
- Data quality issues
- Formatting problems
- Biases
- Outliers
- Distribution of attributes

**Inspection Techniques**:

**1. Statistical Analysis**:
- Length distributions
- Vocabulary distributions
- Label distributions

../images/aien_0806.png

**Figure 8-6. One statistic you can use is the distribution of (verb, direct object noun) in your data.**

../images/aien_0807.png

**Figure 8-7. The distribution of response length for GPT-4 and GPT-3.**

**2. Manual Sampling**:
- Random sample review
- Review edge cases
- Review longest/shortest examples
- Review examples from each category

**3. Automated Checks**:
- Format validation
- Completeness checks
- Consistency checks

**Benefits of Inspection**:
- Catch errors early
- Understand data characteristics
- Inform processing decisions
- Identify areas needing more data

## Deduplicate Data

**Why Deduplicate**: Duplicates in training data can:
- Cause overfitting
- Waste compute (training on same data multiple times)
- Skew model toward duplicated patterns
- Reduce effective dataset diversity

**Types of Duplicates**:

**1. Exact Duplicates**:
- Identical strings
- Easy to detect and remove
- Use hashing for efficiency

**2. Near Duplicates**:
- Minor differences (typos, formatting)
- Harder to detect
- Need similarity measures

**3. Semantic Duplicates**:
- Same meaning, different wording
- Hardest to detect
- May or may not want to remove

**Deduplication Techniques**:

**For Exact Duplicates**:
- Hash-based methods
- Simple and fast
- Use MD5 or SHA-256

**For Near Duplicates**:
- MinHash
- Jaccard similarity
- Edit distance

**For Semantic Duplicates**:
- Embedding-based similarity
- More computationally expensive
- May remove valid variations

**Best Practices**:
- Deduplicate across train/test/validation sets
- Be careful not to over-deduplicate (some repetition is okay)
- Keep track of what was removed
- Verify deduplication doesn't hurt diversity

## Clean and Filter Data

**Cleaning**: Fixing errors and inconsistencies in data.

**Filtering**: Removing data that doesn't meet quality standards.

**Common Cleaning Tasks**:
- Fix formatting issues
- Correct typos (when appropriate)
- Standardize formats
- Handle missing values
- Remove artifacts (HTML tags, special characters)

**Common Filtering Tasks**:
- Remove low-quality examples
- Remove toxic content
- Remove off-topic examples
- Remove examples that are too short/long
- Remove examples that violate policies

**Automated Filtering**:
- Length-based filters
- Keyword-based filters
- Regex-based filters
- Classifier-based filters (toxicity, quality)

**Human-in-the-Loop Filtering**:
- Sample and manually review
- Create allow/deny lists
- Adjudicate edge cases

**Trade-offs**:
- Aggressive filtering: Higher quality but less data
- Lenient filtering: More data but lower quality
- Find the right balance for your use case

## Format Data

**The Task**: Convert data into the format expected by your training pipeline.

**Common Formats**:

**For Language Models**:
- Text files (one example per line)
- JSON/JSONL
- Parquet
- CSV/TSV

**For Instruction Finetuning**:
```json
{
  "instruction": "What is the capital of France?",
  "response": "The capital of France is Paris."
}
```

**For Preference Finetuning**:
```json
{
  "instruction": "Explain quantum computing",
  "chosen": "Quantum computing uses quantum mechanics...",
  "rejected": "Quantum computing is just fancy regular computing..."
}
```

**For Multi-Turn Conversations**:
```json
{
  "messages": [
    {"role": "user", "content": "Hello"},
    {"role": "assistant", "content": "Hi! How can I help?"},
    {"role": "user", "content": "What's the weather?"}
  ]
}
```

**Formatting Best Practices**:
- Use consistent formatting across dataset
- Include all necessary fields
- Validate format programmatically
- Document format specification
- Make format easy to parse

**Special Tokens**: Many models use special tokens to mark different parts of input:
- `<|im_start|>`, `<|im_end|>`: Mark message boundaries
- `<|system|>`, `<|user|>`, `<|assistant|>`: Mark roles
- Check your model's documentation for required format

# Summary

This chapter covered the critical process of dataset engineering:

**Core Principles**:
- Quality of model depends on quality of training data
- Data curation requires understanding how models learn
- Data operations have evolved into dedicated roles

**Data-Centric AI**:
- Focus on enhancing data rather than just models
- Data-centric benchmarks and competitions emerging
- Both model and data improvements needed for progress

**Data Curation**:
- **Quality**: Accurate, relevant, consistent, complete, unbiased
- **Coverage/Diversity**: Represent full scope of scenarios
- **Quantity**: Depends on task, model, and quality; diminishing returns

**Key Findings**:
- Both quality AND diversity are necessary
- Stronger base models need less data
- Multiple tasks can improve overall performance
- Performance gain curves help estimate data needs

**Data Sources**:
- Many public datasets available
- Mix-and-match approach common
- Always check licenses and data lineage
- Never fully trust available data

**Annotation**:
- Clear guidelines are crucial
- Guidelines same for training and evaluation data
- Often the most challenging part
- Requires iteration and refinement

**Data Synthesis**:
- **Traditional**: Rule-based, simulation
- **AI-Powered**: Instruction synthesis, model distillation
- Promises to reduce pressure for human data
- Doesn't completely replace human data

**AI Synthesis Benefits**:
- Can generate natural-looking data
- Scales easily
- Creates diverse examples

**AI Synthesis Limitations**:
- Quality control challenges
- Superficial imitation risk
- Model collapse potential
- Obscure data lineage

**Best Practice**: Mix human and AI-generated data.

**Data Processing**:
- **Inspect**: Understand characteristics, catch errors early
- **Deduplicate**: Remove exact, near, and semantic duplicates
- **Clean and Filter**: Fix errors, remove low-quality examples
- **Format**: Convert to expected training format

**Practical Realities**:
- Data work is iterative and non-linear
- Requires going back and forth between steps
- Mostly just toil, tears, and sweat
- But absolutely essential for model success

**Key Takeaways**:
1. Data quality matters more than quantity (to a point)
2. Invest time in annotation guidelines
3. Inspect data thoroughly before training
4. Mix human and synthetic data
5. Deduplicate to prevent overfitting
6. Clean and filter to maintain quality
7. Format consistently for training
8. Document your data processes
9. Monitor data quality continuously
10. Iterate based on model performance

The next chapters will build on this foundation to cover deployment and production considerations for AI systems.
