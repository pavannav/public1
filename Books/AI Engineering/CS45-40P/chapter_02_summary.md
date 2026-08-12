# Chapter 2. Understanding Foundation Models

## Overview

To build applications with foundation models, you first need to understand foundation models. While you don't need to know how to build a model to use it, a high-level understanding will help you decide what model to use and how to adapt it to your needs.

Training a foundation model is incredibly complex and costly. This chapter won't tell you how to build a model to compete with ChatGPT. Instead, it focuses on design decisions with consequential impact on downstream applications.

With growing lack of transparency in training processes, it's difficult to know all design decisions that go into making a model. However, differences in foundation models can generally be traced back to decisions about:
- Training data
- Model architecture and size
- Post-training (alignment with human preferences)

**Chapter Structure**:

Since models learn from data, training data reveals much about their capabilities and limitations. This chapter begins with how model developers curate training data, focusing on distribution. Given the transformer architecture's dominance, we'll explore what makes it special, how long until another architecture takes over, and what that new architecture might look like. We'll also explore how developers determine appropriate model size.

A model's training is divided into pre-training and post-training. Pre-training makes a model capable but not necessarily safe or easy to use. Post-training aligns the model with human preferences. We'll discuss what human preference means and how it can be represented for model learning.

Finally, we cover sampling—how a model chooses an output from all possible options. Sampling is perhaps one of the most underrated concepts in AI. It explains many seemingly baffling AI behaviors, including hallucinations and inconsistencies, and choosing the right sampling strategy can significantly boost performance with relatively little effort.

# Training Data

An AI model is only as good as the data it was trained on. If there's no Vietnamese in training data, the model won't translate English to Vietnamese. If an image classification model sees only animals in training, it won't perform well on plants.

If you want a model to improve on a certain task, include more data for that task in training. However, collecting sufficient data for training a large model isn't easy and can be expensive. Model developers often rely on available data, even if it doesn't exactly meet their needs.

**Common Crawl**: A common source for training data is Common Crawl, created by a nonprofit that sporadically crawls websites on the internet. In 2022 and 2023, this organization crawled approximately 2–3 billion web pages each month. Google provides a clean subset called the Colossal Clean Crawled Corpus (C4).

**Data Quality Issues**: Common Crawl's data quality is questionable—think clickbait, misinformation, propaganda, conspiracy theories, racism, misogyny, and sketchy websites. A Washington Post study shows that the 1,000 most common websites in the dataset include several media outlets ranking low on NewsGuard's trustworthiness scale. In lay terms, Common Crawl contains plenty of fake news.

Yet, simply because Common Crawl is available, variations of it are used in most foundation models that disclose their training data sources, including OpenAI's GPT-3 and Google's Gemini. Many models that don't disclose their training data likely use it too. To avoid scrutiny from the public and competitors, many companies have stopped disclosing this information.

**Filtering Strategies**: Some teams use heuristics to filter low-quality data. For example, OpenAI used only Reddit links that received at least three upvotes to train GPT-2. While this screens out links nobody cares about, Reddit isn't exactly the pinnacle of propriety and good taste.

The "use what we have, not what we want" approach may lead to models that perform well on tasks present in training data but not necessarily on tasks you care about. To address this, it's crucial to curate datasets aligning with your specific needs. This section focuses on curating data for specific languages and domains, providing a broad yet specialized foundation for applications within those areas.

While language- and domain-specific foundation models can be trained from scratch, it's also common to finetune them on top of general-purpose models.

**Why Not Train on Everything?** Some wonder: why not train a model on all available data, both general and specialized, so it can do everything? This is what many do. However, training on more data often requires more compute resources and doesn't always lead to better performance. A model trained with smaller amounts of high-quality data might outperform a model trained with large amounts of low-quality data. Using 7B tokens of high-quality coding data, Gunasekar et al. (2023) trained a 1.3B-parameter model that outperforms much larger models on several important coding benchmarks.

## Multilingual Models

English dominates the internet. Analysis of Common Crawl shows English accounts for almost half the data (45.88%), making it eight times more prevalent than the second-most common language, Russian (5.97%) (Lai et al., 2023). Languages with limited availability as training data—typically those not in the top languages—are considered low-resource.

**Table 2-1. Languages with at least 1% presence in Common Crawl (simplified)**

| Language | Percentage |
|----------|------------|
| English | 45.88% |
| Russian | 5.97% |
| German | 4.84% |
| Japanese | 3.50% |
| Spanish | 3.42% |
| French | 3.35% |
| Chinese | 2.86% |
| Portuguese | 2.00% |

This imbalance means models perform significantly better in English than in other languages. For applications serving non-English users, this is problematic.

**Approaches to Multilingual Models**:

1. **Train from scratch on multilingual data**: Include diverse languages in training data from the beginning. The challenge is obtaining sufficient high-quality data in all target languages.

2. **Continue training a pre-trained English model**: Take an English model and continue training it on other languages. This leverages knowledge learned from English while extending to new languages. However, this can lead to "catastrophic forgetting"—the model may lose some English capabilities.

3. **Use multilingual datasets**: Datasets like mC4 (multilingual C4) cover 101 languages. However, quality and coverage vary significantly across languages.

**Performance Trade-offs**: Multilingual models face trade-offs. A model trained on 100 languages will likely perform worse on any single language compared to a model trained only on that language. The question becomes: is the convenience of a single multilingual model worth the performance drop?

**Low-Resource Language Challenges**: For low-resource languages, even multilingual models struggle. Techniques to address this include:
- Transfer learning from high-resource to low-resource languages
- Data augmentation through translation
- Using language families (languages with shared characteristics)
- Synthetic data generation

## Domain-Specific Models

Just as models can specialize in languages, they can specialize in domains like medicine, law, finance, or code.

**Why Domain-Specific Models?**
- **Better Performance**: Models trained on domain-specific data outperform general models on domain tasks
- **Terminology**: Domains have specialized vocabulary and jargon
- **Context**: Domain-specific context improves understanding
- **Compliance**: Some domains require models trained only on approved, verified data

**Creating Domain-Specific Models**:

1. **Train from scratch**: Build a model entirely on domain-specific data. Expensive but provides maximum control.

2. **Continue pre-training**: Take a general model and continue pre-training on domain data. Balances general knowledge with domain expertise.

3. **Fine-tuning**: Take a pre-trained model and fine-tune on domain-specific tasks. Fastest and cheapest approach.

**Examples**:
- **Medical Models**: Models trained on medical literature, clinical notes, and research papers
- **Legal Models**: Trained on case law, contracts, and legal documents
- **Financial Models**: Trained on financial reports, market data, and economic indicators
- **Code Models**: Trained on code repositories (GitHub, Stack Overflow)

**Code Models**: Because code has clear structure and syntax, code-specific models have been particularly successful. Examples include GitHub Copilot (using Codex), CodeLlama, and StarCoder. These models excel at:
- Code completion
- Bug detection
- Code generation from descriptions
- Code translation between languages
- Documentation generation

**Considerations**: Domain-specific models require maintaining and updating domain-specific training data. As domains evolve, models need retraining. The trade-off is between specialization benefits and maintenance costs.

# Modeling

This section covers two key modeling decisions: model architecture and model size.

## Model Architecture

The architecture defines how a model processes information. While many architectures exist, the transformer dominates today's foundation models.

### The transformer architecture

The transformer architecture, introduced in 2017 by Vaswani et al. in "Attention Is All You Need," revolutionized natural language processing and beyond.

**Why Transformers Dominate**:
1. **Parallelization**: Unlike RNNs (recurrent neural networks) that process sequences one token at a time, transformers process entire sequences in parallel, dramatically speeding up training
2. **Long-range dependencies**: Attention mechanism allows models to consider relationships between distant tokens
3. **Scalability**: Architecture scales well to billions and trillions of parameters
4. **Versatility**: Works for text, images, audio, video, and multimodal tasks

#### The attention mechanism

The attention mechanism is the transformer's core innovation. It allows the model to weigh the importance of different parts of the input when processing each token.

**How Attention Works**:

Given a sequence of tokens, attention determines which tokens are most relevant to each other. For example, in the sentence "The cat sat on the mat," when processing "sat," attention helps the model understand that "cat" is the subject performing the action.

../images/aien_0201.png

**Figure 2-1. High-level visualization of the attention mechanism.**

**Technical Components**:

Attention uses three matrices for each token:
1. **Query (Q)**: What the token is looking for
2. **Key (K)**: What information the token contains
3. **Value (V)**: The actual information to retrieve

The attention mechanism computes how much each token should attend to every other token by:
1. Computing similarity between queries and keys
2. Applying softmax to get attention weights (probabilities summing to 1)
3. Using weights to compute weighted sum of values

**Mathematical Formula**:

```
Attention(Q, K, V) = softmax(QK^T / √d_k) V
```

Where d_k is the dimension of the key vectors, used for scaling.

../images/aien_0202.png

**Figure 2-2. Detailed visualization of attention computation.**

**Self-Attention**: In transformers, tokens attend to other tokens in the same sequence. This is called self-attention. Each token can look at all other tokens to understand context.

**Example**: In "The animal didn't cross the street because it was too tired":
- When processing "it," attention helps determine that "it" refers to "animal" not "street"
- Attention weights would be high between "it" and "animal"

**Multi-Head Attention**: Instead of computing attention once, transformers compute it multiple times in parallel (called "heads"). Each head can focus on different aspects:
- One head might focus on grammatical relationships
- Another on semantic meaning
- Another on positional relationships

Having multiple heads allows the model to attend to different types of information simultaneously.

../images/aien_0203.png

**Figure 2-3. Multi-head attention allows attending to different aspects.**

**Computing Attention**:

For a model with h attention heads and model dimension d_model:
1. Each head has dimension d_k = d_model / h
2. Input is split into h parts
3. Each head computes attention independently
4. Outputs are concatenated
5. A final linear transformation produces the output

The outputs of all attention heads are concatenated. An output projection matrix applies another transformation to this concatenated output before it's fed to the model's next computation step.

#### Transformer block

A transformer architecture is composed of multiple transformer blocks. The exact content varies between models, but generally, each transformer block contains:

**Attention Module**: Each attention module consists of four weight matrices:
- Query matrix
- Key matrix
- Value matrix
- Output projection matrix

**MLP Module** (Multi-Layer Perceptron): An MLP module consists of linear layers separated by nonlinear activation functions. Each linear layer is a weight matrix used for linear transformations, whereas an activation function allows the linear layers to learn nonlinear patterns. A linear layer is also called a feedforward layer.

Common nonlinear functions are ReLU (Rectified Linear Unit) and GELU, which was used by GPT-2 and GPT-3. Activation functions are very simple. For example, all ReLU does is convert negative values to 0:

```
ReLU(x) = max(0, x)
```

**Model Layers**: The number of transformer blocks in a transformer model is often referred to as that model's number of layers.

A transformer-based language model is also outfitted with:

**An embedding module before the transformer blocks**: This module consists of the embedding matrix and positional embedding matrix, which convert tokens and their positions into embedding vectors. Naively, the number of position indices determines the model's maximum context length. For example, if a model keeps track of 2,048 positions, its maximum context length is 2,048. However, there are techniques that increase a model's context length without increasing the number of position indices.

**An output layer after the transformer blocks**: This module maps the model's output vectors into token probabilities used to sample model outputs (discussed in the Sampling section). This module typically consists of one matrix, also called the unembedding layer. Some people refer to the output layer as the model head, as it's the model's last layer before output generation.

../images/aien_0206.png

**Figure 2-6. A visualization of the weight composition of a transformer model.**

**Key Dimension Values**: The size of a transformer model is determined by the dimensions of its building blocks:
- The model's dimension determines the sizes of the key, query, value, and output projection matrices
- The number of transformer blocks
- The dimension of the feedforward layer
- The vocabulary size

Larger dimension values result in larger model sizes.

**Table 2-4. The dimension values of different Llama models**

| Model | # transformer blocks | Model dim | Feedforward dim | Vocab size | Context length |
|-------|---------------------|-----------|-----------------|------------|----------------|
| Llama 2-7B | 32 | 4,096 | 11,008 | 32K | 4K |
| Llama 2-13B | 40 | 5,120 | 13,824 | 32K | 4K |
| Llama 2-70B | 80 | 8,192 | 22,016 | 32K | 4K |
| Llama 3-7B | 32 | 4,096 | 14,336 | 128K | 128K |
| Llama 3-70B | 80 | 8,192 | 28,672 | 128K | 128K |
| Llama 3-405B | 126 | 16,384 | 53,248 | 128K | 128K |

Note that while increased context length impacts the model's memory footprint, it doesn't impact the model's total number of parameters.

### Other model architectures

While the transformer dominates, it's not the only architecture. Since AlexNet revived interest in deep learning in 2012, many architectures have come and gone. Seq2seq was in the limelight for four years (2014–2018). GANs (generative adversarial networks) captured collective imagination a bit longer (2014–2019). Compared to architectures that came before, the transformer is sticky—it's been around since 2017. How long until something better comes along?

Developing a new architecture to outperform transformers isn't easy. The transformer has been heavily optimized since 2017. A new architecture aiming to replace the transformer must perform at the scale that people care about, on the hardware that people care about.

However, there's hope. Several alternative architectures are gaining traction:

**RWKV**: An RNN-based model that can be parallelized for training. Due to its RNN nature, in theory it doesn't have the same context length limitation that transformer-based models have. However, in practice, having no context length limitation doesn't guarantee good performance with long context.

**State Space Models (SSMs)**: An architecture showing promise in long-range memory. Since its introduction in 2021, multiple techniques have made it more efficient, better at long sequence processing, and scalable to larger model sizes:

- **S4**: "Efficiently Modeling Long Sequences with Structured State Spaces" (Gu et al., 2021b) made SSMs more efficient

- **H3**: "Hungry Hungry Hippos: Towards Language Modeling with State Space Models" (Fu et al., 2022) incorporates a mechanism allowing the model to recall early tokens and compare tokens across sequences. This mechanism's purpose is akin to the attention mechanism in transformers, but more efficient

- **Mamba**: "Mamba: Linear-Time Sequence Modeling with Selective State Spaces" (Gu and Dao, 2023) scales SSMs to three billion parameters. On language modeling, Mamba-3B outperforms transformers of the same size and matches transformers twice its size. The authors show that Mamba's inference computation scales linearly with sequence length (compared to quadratic scaling for transformers). Performance shows improvement on real data up to million-length sequences

**Why Alternative Architectures Matter**: Different architectures offer different trade-offs:
- **Efficiency**: Some architectures are more computationally efficient
- **Context length**: Some handle longer sequences better
- **Speed**: Some are faster for inference
- **Memory**: Some use less memory

The future likely involves multiple architectures for different use cases rather than one architecture dominating all tasks.

## Model Size

Model size is typically measured by the number of parameters—the weights in the model's neural network. Larger models generally perform better but cost more to train and deploy.

**Parameter Count Examples**:
- GPT-2: 1.5 billion parameters
- GPT-3: 175 billion parameters
- GPT-4: Estimated over 1 trillion parameters (not officially disclosed)
- Llama 2: 7B, 13B, 70B parameter versions
- Llama 3: 7B, 70B, 405B parameter versions

../images/aien_0207.png

**Figure 2-7. The growth of model parameters over time.**

**Why Size Matters**:

1. **Performance**: Larger models generally perform better on benchmarks and real-world tasks. They can capture more nuanced patterns and knowledge.

2. **Emergent Capabilities**: Certain capabilities only appear at specific size thresholds. For example, models might suddenly gain arithmetic abilities or reasoning capabilities at certain scales.

3. **Few-Shot Learning**: Larger models are better at learning from just a few examples (few-shot learning) without explicit training.

**The Cost of Scale**:

However, larger isn't always better when considering:
- **Training Cost**: Training larger models requires more compute, more time, and more money. Training GPT-3 cost approximately $4.6 million in compute alone
- **Inference Cost**: Running larger models is more expensive per query
- **Latency**: Larger models typically take longer to generate responses
- **Memory Requirements**: Larger models require more GPU/TPU memory
- **Environmental Impact**: More compute means more electricity consumption

**Scaling Laws**: As discussed in Chapter 1, research has shown that model performance scales predictably with:
- Number of parameters (N)
- Training data size (D)
- Training compute (C)

Performance follows power laws: doubling compute leads to predictable performance improvements. This predictability has driven the race to scale.

**Choosing Model Size**: When selecting or developing a model, consider:
- **Task Complexity**: Simple tasks may not benefit from massive models
- **Budget**: Training and inference costs scale with size
- **Latency Requirements**: Real-time applications may need smaller, faster models
- **Resource Availability**: Do you have the infrastructure to run large models?

**Model Families**: Many organizations release model families at different sizes:
- Small (7-13B): For edge deployment, faster inference, lower cost
- Medium (30-70B): Balanced performance and efficiency
- Large (175B+): Maximum capability, highest cost

This allows users to choose the appropriate size-performance-cost trade-off for their needs.

**Beyond Parameter Count**: Other factors also impact effective model size:
- **Model compression**: Techniques like quantization and pruning reduce model size
- **Architecture efficiency**: Some architectures achieve better performance per parameter
- **Training quality**: Well-trained smaller models can outperform poorly trained larger models

# Inverse Scaling

While larger models generally perform better, there are exceptions—tasks where larger models actually perform worse than smaller ones. This phenomenon is called inverse scaling.

**Examples of Inverse Scaling**:

1. **Repetition**: Larger models sometimes repeat themselves more in generated text

2. **Following Misleading Instructions**: Larger models may be more likely to follow instructions that lead to incorrect answers

3. **Pattern Matching Over Reasoning**: When a task requires actual reasoning but has misleading patterns, larger models may rely more on pattern matching

**Why Inverse Scaling Happens**:

- **Overconfidence**: Larger models may be more confident in incorrect patterns learned from training data
- **Spurious Correlations**: Training data contains many spurious correlations. Larger models have more capacity to memorize these
- **Instruction Following**: As models get better at following instructions, they may follow bad instructions more faithfully

**Implications**: Inverse scaling reminds us that:
- Bigger isn't always better
- Model evaluation needs to cover diverse scenarios
- Understanding model failure modes is crucial
- Post-training and alignment are critical for usability

**Addressing Inverse Scaling**: Techniques to mitigate inverse scaling include:
- Better training data curation
- Improved post-training (SFT and RLHF)
- Task-specific fine-tuning
- Prompting strategies that encourage reasoning

# Parameter Versus Hyperparameter

Understanding the distinction between parameters and hyperparameters is fundamental:

**Parameters**: Values learned during training. Examples:
- Weight matrices in transformer blocks
- Embedding values
- Bias terms

Parameters are what make up the "size" of a model. A 7B parameter model has 7 billion learned values. Parameters are optimized through backpropagation during training.

**Hyperparameters**: Values set before training that control the learning process. Examples:
- Learning rate: How quickly the model updates during training
- Batch size: How many examples to process simultaneously
- Number of training epochs: How many times to pass through training data
- Model architecture choices: Number of layers, hidden dimensions
- Optimization algorithm: Adam, SGD, etc.

Hyperparameters are not learned—they're chosen by model developers through experimentation, experience, or automated search.

**Why the Distinction Matters**:
- You can change hyperparameters without retraining from scratch (though performance may vary)
- You cannot directly modify parameters without training
- Hyperparameter tuning is a crucial part of model development
- When adapting models, you may adjust hyperparameters for fine-tuning

**Common Confusion**: Sometimes people loosely refer to "model parameters" to include both parameters and hyperparameters, but technically they're distinct concepts.

# Post-Training

Post-training starts with a pre-trained model. Due to how pre-training works today, a pre-trained model typically has two issues:

1. **Optimized for Completion, Not Conversation**: Self-supervision optimizes the model for text completion, not conversations
2. **Contains Undesirable Behaviors**: If pre-trained on indiscriminately scraped internet data, outputs can be racist, sexist, rude, or just wrong

The goal of post-training is to address both issues.

**Post-Training Steps**: In general, post-training consists of two steps:

1. **Supervised Finetuning (SFT)**: Finetune the pre-trained model on high-quality instruction data to optimize for conversations instead of completion

2. **Preference Finetuning**: Further finetune to output responses that align with human preference. Typically done with reinforcement learning (RL). Techniques include:
   - RLHF (Reinforcement Learning from Human Feedback) - used by GPT-3.5 and Llama 2
   - DPO (Direct Preference Optimization) - used by Llama 3
   - RLAIF (Reinforcement Learning from AI Feedback) - potentially used by Claude

**Pre-training vs. Post-training**: Another way to highlight the difference:
- **Pre-training**: Optimizes token-level quality—predicting the next token accurately
- **Post-training**: Optimizes response-level quality—generating responses users prefer

Some compare pre-training to reading to acquire knowledge, while post-training is learning how to use that knowledge.

As post-training consumes a small portion of resources compared to pre-training (InstructGPT used only 2% of compute for post-training and 98% for pre-training), you can think of post-training as unlocking capabilities that the pre-trained model already has but are hard for users to access via prompting alone.

../images/aien_0210.png

**Figure 2-10. The overall training workflow with pre-training, SFT, and RLHF.**

**The Shoggoth Metaphor**: The workflow resembles the meme depicting the monster Shoggoth with a smiley face:

1. Self-supervised pre-training results in a rogue model—an untamed monster using indiscriminate internet data
2. This monster is supervised finetuned on higher-quality data (Stack Overflow, Quora, human annotations), making it more socially acceptable
3. This finetuned model is further polished using preference finetuning to make it customer-appropriate—giving it a smiley face

../images/aien_0211.png

**Figure 2-11. Shoggoth with a smiley face.**

Note that combining pre-training, SFT, and preference finetuning is today's popular solution for building foundation models, but it's not the only solution. You can skip any of these steps.

## Supervised Finetuning

As discussed in Chapter 1, the pre-trained model is likely optimized for completion rather than conversing. If you input "How to make pizza" into the model, it will continue completing this sentence, as the model has no concept that this is supposed to be a conversation. Any of these options can be valid completions:

1. Adding more context to the question: "for a family of six?"
2. Adding follow-up questions: "What ingredients do I need? How much time would it take?"
3. Giving instructions on how to make pizza

If the goal is to respond to users appropriately, the correct option is 3.

**Demonstration Data**: We know models mimic their training data. To encourage appropriate responses, you show examples of appropriate responses. Such examples follow the format (prompt, response) and are called demonstration data. Some people refer to this process as behavior cloning: you demonstrate how the model should behave, and the model clones this behavior.

Since different types of requests require different responses, your demonstration data should contain the range of requests you want your model to handle, such as question answering, summarization, and translation.

../images/aien_0212.png

**Figure 2-12. The distribution of prompts used to finetune InstructGPT.**

**Quality of Labelers**: Good teachers are important for humans to learn. Similarly, good labelers are important for AIs to learn how to conduct intelligent conversations. Unlike traditional data labeling, which can often be done with little domain expertise, demonstration data may contain complex prompts whose responses require critical thinking, information gathering, and judgment about request appropriateness.

**Table 2-6. Examples of demonstration data used for InstructGPT**

| Prompt | Labeler's Response |
|--------|-------------------|
| Serendipity means the occurrence and development of events by chance in a happy or beneficial way. Use the word in a sentence. | Running into Margaret and being introduced to Tom was a fortunate stroke of serendipity. |
| Read the following text and answer the three questions at the end. [Article about Justice Ruth Bader Ginsburg] ... Why will Ginsburg's death have profound consequences for the court and the country? | Ruth Bader Ginsburg was the leader of the liberal wing, and because the court is about to open a new term, the chief justice no longer holds the controlling vote in contested cases. |
| ELI5: What's the cause of the "anxiety lump" in our chest during stressful or disheartening experiences? | The anxiety lump in your throat is caused by muscular tension keeping your glottis dilated to maximize airflow. The clenched chest or heartache feeling is caused by the vagus nerve which tells the organs to pump blood faster, stop digesting, and produce adrenaline and cortisol. |

**Cost of Demonstration Data**: Companies often use highly educated labelers to generate demonstration data. Among those who labeled data for InstructGPT, ~90% have at least a college degree and more than one-third have a master's degree. If labeling objects in an image might take only seconds, generating one (prompt, response) pair can take up to 30 minutes, especially for tasks involving long contexts like summarization. If it costs $10 for one (prompt, response) pair, the 13,000 pairs OpenAI used for InstructGPT would cost $130,000. That doesn't yet include costs of designing the data, recruiting labelers, and data quality control.

**Scale Required**: How much demonstration data is needed? It varies by model size and task complexity, but typically:
- Small models: Thousands of examples
- Medium models: Tens of thousands
- Large models: Hundreds of thousands or millions

The goal is to show the model diverse examples of desired behavior across the range of tasks it should handle.

## Preference Finetuning

After supervised finetuning, models can follow instructions and converse. However, for the same prompt, multiple valid responses exist. How do we teach models to generate responses users prefer?

**The Challenge**: Consider the prompt "Write a poem about sunset." Valid responses range from:
- A haiku
- A sonnet
- Free verse
- A limerick

But which would users prefer? This depends on context, user, and subjective taste. We need a way to capture and optimize for human preferences.

**The Solution**: Preference finetuning trains models to generate outputs humans prefer. This typically involves:

1. **Collecting Preference Data**: Show humans multiple model outputs for the same prompt and ask which they prefer
2. **Training a Reward Model**: Train a model to predict which outputs humans will prefer
3. **Optimizing the Language Model**: Use the reward model to guide the language model toward preferred outputs

**RLHF (Reinforcement Learning from Human Feedback)**: The most well-known approach:

../images/aien_0213.png

**Figure 2-13. The RLHF process overview.**

**RLHF Steps**:

1. **Collect Comparison Data**: For each prompt, generate multiple outputs from the model. Show pairs to human labelers who indicate which output they prefer and why.

2. **Train Reward Model**: Train a model (the reward model) to predict human preferences. Input: a prompt and a response. Output: a score indicating how much humans would like this response.

3. **Optimize Policy with RL**: Use reinforcement learning to fine-tune the language model (the policy) to maximize the reward model's scores while staying close to the original model (to prevent degeneration).

**The Reward Model**: A crucial component of RLHF is the reward model—a model trained to score outputs based on human preferences.

Training the reward model:
- Collect data where humans rank or compare model outputs
- Train a model to predict these rankings
- The reward model learns what constitutes a "good" response

Using the reward model:
- During RL training, the language model generates responses
- The reward model scores each response
- The language model adjusts to generate higher-scoring responses

**Challenges with RLHF**:
- **Expensive**: Collecting human feedback is costly and time-consuming
- **Scalability**: Human evaluation doesn't scale well
- **Consistency**: Different humans may have different preferences
- **Complexity**: RL training can be unstable and difficult to tune

**Alternative: DPO (Direct Preference Optimization)**: A newer technique that achieves similar goals without RL:
- Directly optimizes the model using preference data
- Simpler and more stable than RLHF
- Used by Llama 3 and other recent models
- Eliminates the need for a separate reward model and RL training

**RLAIF (Reinforcement Learning from AI Feedback)**: Uses AI models instead of humans to provide feedback:
- An AI model (often a larger or different model) evaluates outputs
- Scales better than human feedback
- Can be combined with human feedback
- Used in some form by Claude and other models

**Best of N**: A simple but effective technique:
- Generate N responses for each prompt
- Use the reward model to score all responses
- Select and show the user the highest-scoring response

This doesn't require RL training but uses more compute during inference.

**Impact of Preference Finetuning**: Preference finetuning dramatically improves model usability:
- Responses become more helpful and relevant
- Toxic or harmful outputs are reduced
- Models better understand implicit user intentions
- Conversational quality improves

However, it's not perfect:
- Models can still make mistakes
- Preferences are subjective and context-dependent
- Alignment is an ongoing challenge
- Models may refuse benign requests (overalignment)

# Sampling

Sampling is how a model chooses an output from all possible options. It's perhaps one of the most underrated concepts in AI. Sampling explains many seemingly baffling AI behaviors, including hallucinations and inconsistencies, and choosing the right sampling strategy can significantly boost performance with relatively little effort.

## Sampling Fundamentals

When a language model generates text, it doesn't simply pick the single "best" token at each step. Instead, it computes a probability distribution over all possible next tokens and samples from this distribution.

**The Process**:

1. **Model Computation**: The model processes input and computes logits (raw scores) for each token in the vocabulary

2. **Softmax**: Logits are converted to probabilities using the softmax function, ensuring they sum to 1

3. **Sampling**: A token is selected based on these probabilities

**Why Sample Instead of Picking the Best?**: Always picking the highest probability token (called greedy decoding) leads to:
- Repetitive outputs
- Lack of creativity
- Getting stuck in loops
- Generic, boring text

Sampling introduces randomness, leading to more diverse and interesting outputs.

**Temperature**: A key parameter controlling sampling randomness:

```
probability_i = exp(logit_i / temperature) / sum(exp(logit_j / temperature))
```

- **Temperature = 1.0**: Standard softmax (default)
- **Temperature < 1.0**: Makes the distribution more peaked (more deterministic)
  - At temperature = 0.1: Model strongly favors high-probability tokens
  - At temperature = 0.0: Equivalent to greedy decoding
- **Temperature > 1.0**: Makes the distribution more uniform (more random)
  - At temperature = 2.0: More diverse, creative outputs
  - At very high temperatures: Nearly random selection

../images/aien_0214.png

**Figure 2-14. Effect of temperature on probability distribution.**

**Choosing Temperature**:
- **Low temperature (0.1-0.7)**: For factual tasks, code generation, precise instructions
- **Medium temperature (0.7-1.0)**: For general conversation, balanced creativity
- **High temperature (1.0-1.5)**: For creative writing, brainstorming, diversity

**Determinism**: To get deterministic (reproducible) outputs, set:
- Temperature = 0.0 (greedy decoding)
- Or use a fixed random seed with temperature > 0

## Sampling Strategies

Beyond temperature, several strategies control how models sample tokens.

### Top-k sampling

Top-k sampling restricts the model to choosing from only the k most likely tokens at each step.

**How It Works**:
1. Compute probabilities for all tokens
2. Select the k tokens with highest probabilities
3. Renormalize these k probabilities to sum to 1
4. Sample from this reduced set

**Example**: With k=5, the model only considers the top 5 most likely tokens, ignoring all others.

../images/aien_0215.png

**Figure 2-15. Top-k sampling filters to the top k tokens.**

**Benefits**:
- Reduces chance of selecting very unlikely tokens
- Faster computation (smaller softmax)
- Prevents nonsensical outputs

**Challenges**:
- Fixed k doesn't adapt to context
- When the distribution is very peaked, k=5 may include very unlikely tokens
- When the distribution is very flat, k=5 may exclude reasonable options

**Typical Values**: k = 10 to 50

### Top-p sampling (nucleus sampling)

Top-p sampling dynamically adjusts the number of tokens considered based on cumulative probability.

**How It Works**:
1. Sort tokens by probability (highest to lowest)
2. Select the smallest set of tokens whose cumulative probability ≥ p
3. Renormalize and sample from this set

**Example**: With p=0.9 (90%):
- If the top 3 tokens have cumulative probability 91%, consider only those 3
- If the top 10 tokens have cumulative probability 89%, consider all 10

Let's say probabilities are:
- "yes": 60%
- "maybe": 30%
- "no": 8%
- "perhaps": 1.5%
- Others: 0.5%

With top-p = 90%, only "yes" and "maybe" are considered (90% cumulative).
With top-p = 99%, "yes", "maybe", and "no" are considered (98% cumulative).

../images/aien_0218.png

**Figure 2-18. Example token probabilities.**

**Benefits**:
- Adapts to context (more tokens when distribution is flat, fewer when peaked)
- More contextually appropriate outputs
- Works well in practice

**Typical Values**: p = 0.9 to 0.95

**Top-k vs. Top-p**: In practice, top-p (nucleus sampling) has become more popular as it adapts better to different contexts.

**Min-p**: A related strategy where you set the minimum probability a token must reach to be considered during sampling.

### Stopping condition

An autoregressive language model generates sequences token by token. A long output sequence takes more time, costs more compute (money), and can sometimes annoy users. We might want to set a condition for the model to stop the sequence.

**Methods**:

1. **Fixed Token Limit**: Stop after generating N tokens
   - Simple but may cut off mid-sentence
   - Good for cost/latency control

2. **Stop Tokens**: Stop when encountering specific tokens
   - End-of-sequence token (EOS)
   - Custom stop words or phrases
   - More natural endings

3. **Stop Words**: Stop when generating specific words or phrases
   - Example: Stop at "User:", "Q:", or "Answer:"
   - Useful for conversational formats

**Challenges**:
- Early stopping can cause malformatted outputs
- For example, if asking model to generate JSON, early stopping can cause missing closing brackets
- Need to balance latency/cost vs. output quality

**Best Practices**:
- Use stop tokens for natural endings
- Set reasonable token limits as backup
- For structured outputs, ensure format completion before stopping

## Test Time Compute

The previous section discussed how a model samples the next token. This section discusses how a model samples the whole output.

**Definition**: Test time compute refers to generating multiple responses per query to increase the chance of good responses, instead of generating just one.

**Simple Approach**: Best of N technique—randomly generate multiple outputs and pick one that works best.

**Strategic Approaches**: Instead of generating all outputs independently (which might include many less promising candidates), you can use beam search to generate a fixed number of most promising candidates (the beam) at each step.

**Increasing Diversity**: A simple strategy to increase effectiveness is to increase output diversity, because a more diverse set of options is more likely to yield better candidates. If using the same model to generate different options, vary the model's sampling variables (temperature, top-p, etc.) to diversify outputs.

**Cost**: Although you can expect some performance improvement by sampling multiple outputs, it's expensive. On average, generating two outputs costs approximately twice as much as generating one.

**Selecting the Best Output**: Methods to pick the best output:

1. **User Selection**: Show users multiple outputs and let them choose
   - Most accurate but requires user effort
   - Good for creative tasks

2. **Highest Probability**: Pick the output with highest average log probability
   - The probability of an output is the product of all token probabilities
   - Use average logprob to avoid biasing toward short sequences
   - Used by OpenAI API as of this writing

**Example**: For sequence ["I", "love", "food"]:
- p(I) = 0.2
- p(love | I) = 0.1  
- p(food | I, love) = 0.3
- Sequence probability: 0.2 × 0.1 × 0.3 = 0.006

```
logprob(I love food) = logprob(I) + logprob(love | I) + logprob(food | I, love)
```

Average logprob = total logprob / sequence length

3. **Reward Model**: Use a trained reward model to score each output
   - More sophisticated than probability
   - Accounts for human preferences
   - Used by Stitch Fix, Grab, Nextdoor

**Impact of Verifiers**: OpenAI trained verifiers to help models pick the best solutions to math problems. They found that using a verifier significantly boosted model performance. In fact, verifiers resulted in approximately the same performance boost as a 30× model size increase. This means a 100-million-parameter model with a verifier can perform on par with a 3-billion-parameter model without one.

**Scaling Test Time Compute**: DeepMind research shows that scaling test time compute (allocating more compute to generate more outputs during inference) can be more efficient than scaling model parameters.

../images/aien_0219.png

**Figure 2-19. OpenAI (2021) found sampling more outputs led to better performance, but only up to 400 outputs.**

**Practical Limits**: In OpenAI's experiment, sampling more outputs improved performance up to 400 outputs, then decreased. They hypothesized that as the number of sampled outputs increases, the chance of finding adversarial outputs that fool the verifier also increases. However, a Stanford experiment ("Monkey Business") found that problems solved often increases log-linearly as samples increase from 1 to 10,000.

While theoretically interesting, nobody in production samples 400 or 10,000 different outputs for each input—the cost would be astronomical.

**Application-Specific Heuristics**: You can also use heuristics to select the best response:
- If your application benefits from shorter responses, pick the shortest candidate
- If converting natural language to SQL queries, keep generating until you get a valid SQL query
- For chain-of-thought queries with high latency, generate multiple responses in parallel and show the user the first one that's completed and valid

## Structured Outputs

A common challenge in AI engineering is getting models to generate outputs in specific formats: JSON, XML, markdown, code, or custom formats.

**The Problem**: Language models naturally generate free-form text. When asked to generate structured data, they might:
- Include explanatory text before or after the structure
- Make formatting errors (missing brackets, wrong syntax)
- Generate valid-looking but semantically incorrect structures

**Why Structured Outputs Matter**: Many applications need structured data:
- APIs expect JSON responses
- Databases require specific schemas
- Code must follow syntax rules
- Forms have required fields

**Approaches to Structured Outputs**:

1. **Prompting**: Ask the model to generate specific formats
   - Simple but unreliable
   - Model may not follow instructions perfectly
   - Example: "Generate a JSON object with fields name, age, and email"

2. **Post-Processing**: Parse and fix model outputs
   - Extract structured data from text
   - Fix common formatting errors
   - Validate and retry if invalid

3. **Constrained Decoding**: Restrict the model's token selection to ensure valid structure
   - During generation, only allow tokens that maintain valid format
   - Guarantees syntactically correct output
   - More complex to implement

4. **Logit Bias**: Adjust token probabilities to favor structural elements
   - Increase probability of brackets, colons, quotes
   - Decrease probability of narrative text
   - Helps but doesn't guarantee correctness

5. **Fine-Tuning**: Train models specifically on structured output tasks
   - Models learn to generate clean structured data
   - Best long-term solution for high-volume applications

**JSON Generation Example**: To get reliable JSON:
- Prompt clearly with schema and examples
- Use constrained decoding to ensure valid JSON
- Parse and validate the output
- Retry with error messages if invalid

**OpenAI's Structured Outputs**: Recent API providers offer built-in structured output features:
- You provide a JSON schema
- The API guarantees output matching that schema
- Uses constrained decoding internally

**Best Practices**:
- Provide clear examples in prompts
- Validate outputs programmatically
- Have fallback handling for invalid outputs
- Consider fine-tuning for critical applications
- Use provider features when available (e.g., OpenAI structured outputs)

## The Probabilistic Nature of AI

Language models are fundamentally probabilistic—they don't produce one fixed output for a given input. This has important implications for AI engineering.

**Nondeterminism**: Even with the same prompt, you can get different responses each time:
- Temperature > 0 introduces randomness
- Sampling methods add variability
- This is a feature, not a bug (for most applications)

**Implications for Testing**: Traditional software testing assumes deterministic behavior—same input always produces same output. With AI:
- Outputs vary between runs
- Need statistical evaluation methods
- Must test across multiple samples
- Focus on output quality distributions, not single outputs

**Implications for Reliability**: Users expect consistent behavior. How do you ensure reliability with probabilistic outputs?
- Set temperature = 0 for deterministic needs (though this reduces quality)
- Test extensively with multiple samples
- Define acceptable output ranges
- Use validation and guardrails
- Have fallback strategies

**Hallucinations**: A consequence of probabilistic generation is hallucinations—the model generating plausible but incorrect information:
- Model samples based on learned patterns
- Sometimes low-probability but plausible-sounding tokens are selected
- No inherent "truth" mechanism

**Reducing Hallucinations**:
- Lower temperature for factual tasks
- Use retrieval-augmented generation (RAG) to ground in real data
- Fine-tune on high-quality, accurate data
- Add verification steps
- Prompt for citations and sources

**Managing Expectations**: Help users understand AI's probabilistic nature:
- Outputs are suggestions, not absolute truth
- Multiple runs may yield different results
- Models can be confident and wrong
- Always verify critical information

**The Trade-off**: Probabilistic sampling enables:
- Creativity and diversity in outputs
- Multiple solution approaches
- Varied communication styles

But requires:
- Careful prompt engineering
- Output validation
- User education
- Appropriate application design

Understanding and working with this probabilistic nature, rather than fighting it, is key to successful AI engineering.

# Summary

This chapter covered the fundamental concepts behind foundation models:

**Training Data**: Models learn from data, making data selection crucial. Key considerations include:
- Common Crawl and other internet-scale datasets dominate
- Data quality significantly impacts model capabilities
- Multilingual models require balanced language representation
- Domain-specific models need specialized data
- High-quality data can outperform larger amounts of low-quality data

**Modeling**: The transformer architecture dominates due to parallelization, long-range dependencies, and scalability. Key concepts:
- Attention mechanism allows models to weigh importance of different inputs
- Multi-head attention enables attending to multiple aspects simultaneously
- Model size (parameters) impacts performance but also cost
- Alternative architectures (SSMs, Mamba) show promise for specific use cases
- Inverse scaling reminds us bigger isn't always better

**Post-Training**: Transforms pre-trained models into usable, safe systems:
- Supervised fine-tuning (SFT) teaches models to converse rather than complete
- Preference fine-tuning (RLHF, DPO, RLAIF) aligns models with human preferences
- Post-training is relatively cheap but dramatically improves usability
- The Shoggoth metaphor: raw model → refined model → user-friendly model

**Sampling**: How models choose outputs from possibilities:
- Temperature controls randomness (low = deterministic, high = creative)
- Top-k and top-p strategies filter less likely tokens
- Stop conditions control output length
- Test time compute improves quality by generating multiple candidates
- Structured outputs require special handling
- Models are fundamentally probabilistic, not deterministic

**Key Takeaways**:
1. Foundation models are complex systems with many design decisions
2. Understanding these decisions helps you select and adapt models effectively
3. No single model is best for all use cases
4. Trade-offs exist between size, cost, performance, and specialization
5. Sampling strategies significantly impact output quality
6. Post-training is essential for making models useful and safe
7. The probabilistic nature of models requires different engineering approaches than traditional software

With this foundation, you're ready to explore how to effectively use and adapt these models for specific applications, which we'll cover in subsequent chapters.
