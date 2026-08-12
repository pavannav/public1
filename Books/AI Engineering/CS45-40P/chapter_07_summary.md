# Chapter 7. Finetuning

## Overview

**Finetuning** is the process of adapting a model to a specific task by further training the whole model or part of the model. Chapters 5 and 6 discuss prompt-based methods, which adapt a model by giving it instructions, context, and tools. **Finetuning adapts a model by adjusting its weights.**

**What Finetuning Can Enhance**:
- Domain-specific capabilities (coding, medical question answering)
- Safety
- Instruction-following ability
- Output styles and formats (most common use)

**Trade-off**: While finetuning can help create models more customized to your needs, it also requires more up-front investment.

**Key Question**: When to finetune and when to do RAG? This chapter will discuss:
- Reasons for finetuning
- Reasons for not finetuning
- Framework for choosing between finetuning and alternate methods

**Memory Challenge**: Compared to prompt-based methods, finetuning incurs a much higher memory footprint. At the scale of today's foundation models, naive finetuning often requires more memory than what's available on a single GPU. This makes finetuning expensive and challenging to do.

**Reducing memory requirements is a primary motivation for many finetuning techniques**, which this chapter explores in detail.

**PEFT (Parameter-Efficient Finetuning)**: A memory-efficient approach that has become dominant in the finetuning space. This chapter explores PEFT and how it differs from traditional finetuning, with particular focus on adapter-based techniques.

**Prerequisites**: With prompt-based methods, knowledge about how ML models operate under the hood is recommended but not strictly necessary. However, finetuning brings you to the realm of model training, where ML knowledge is required.

**Note**: This chapter is technically challenging due to the broad scope of concepts covered. If at any point you feel like you're diving too deep into details that aren't relevant to your work, feel free to skip.

# Finetuning Overview

To finetune, you start with a **base model** that has some, but not all, of the capabilities you need. The goal of finetuning is to get this model to perform well enough for your specific task.

## Transfer Learning

Finetuning is one way to do **transfer learning**, a concept first introduced by Bozinovski and Fulgosi in 1976. Transfer learning focuses on how to transfer knowledge gained from one task to accelerate learning for a new, related task.

**Analogy**: This is conceptually similar to how humans transfer skills: for example, knowing how to play the piano can make it easier to learn another musical instrument.

**Early Success**: An early large-scale success in transfer learning was Google's multilingual translation system (Johnson et al., 2016). The model transferred its knowledge of Portuguese–English and English–Spanish translation to directly translate Portuguese to Spanish, even though there were no Portuguese–Spanish examples in the training data.

**Solution for Limited Data**: Since the early days of deep learning, transfer learning has offered a solution for tasks with limited or expensive training data. By training a base model on tasks with abundant data, you can then transfer that knowledge to a target task.

**For LLMs**: Knowledge gained from pre-training on text completion (a task with abundant data) is transferred to more specialized tasks, like legal question answering or text-to-SQL, which often have less available data. This capability for transfer learning makes foundation models particularly valuable.

## Sample Efficiency

Transfer learning improves **sample efficiency**, allowing a model to learn the same behavior with fewer examples. A *sample-efficient* model learns effectively from fewer samples.

**Example**: While training a model from scratch for legal question answering may need millions of examples, finetuning a good base model might only require a few hundred.

**Key Insight**: Ideally, much of what the model needs to learn is already present in the base model, and finetuning just refines the model's behavior. OpenAI's InstructGPT paper (2022) suggested viewing finetuning as **unlocking the capabilities a model already has** but that are difficult for users to access via prompting alone.

**Note**: Finetuning isn't the only way to do transfer learning. Another approach is *feature-based transfer*. In this approach, a model is trained to extract features from the data (usually as embedding vectors), which are then used by another model.

Feature-based transfer is very common in computer vision. For instance, many people used models trained on the ImageNet dataset to extract features from images and use these features in other computer vision tasks.

## Types of Finetuning

Finetuning is part of a model's training process. It's an extension of model pre-training. Because any training that happens after pre-training is finetuning, finetuning can take many different forms. Chapter 2 already discussed two types of finetuning:
- **Supervised finetuning**
- **Preference finetuning**

Let's recap these methods and how you might leverage them as an application developer.

**Pre-training**: A model's training process starts with pre-training, which is usually done with self-supervision. Self-supervision allows the model to learn from a large amount of unlabeled data. For language models, self-supervised data is typically just *sequences of text* that don't need annotations.

**Self-Supervised Finetuning (Continued Pre-training)**: Before finetuning this pre-trained model with expensive task-specific data, you can finetune it with self-supervision using cheap task-related data:
- For legal question answering: Finetune on raw legal documents before using expensive annotated (question, answer) data
- For book summarization in Vietnamese: First finetune on a large collection of Vietnamese text

**Infilling Finetuning**: Language models can be autoregressive or masked:
- **Autoregressive model**: Predicts the next token in a sequence using previous tokens as context
- **Masked model**: Fills in the blank using tokens both before and after it

With supervised finetuning, you can also finetune a model to predict the next token or fill in the blank. The latter, also known as *infilling finetuning*, is especially useful for:
- Text editing
- Code debugging

You can finetune a model for infilling even if it was pre-trained autoregressively.

**Supervised Finetuning (SFT)**: The next level of finetuning involves using annotated data with (input, expected output) pairs. The model is trained to generate the expected output for each input. This is the most common type of finetuning.

**Preference Finetuning**: After SFT, you can further finetune the model using preference data (which outputs are better than others). Techniques include:
- RLHF (Reinforcement Learning from Human Feedback)
- DPO (Direct Preference Optimization)
- RLAIF (Reinforcement Learning from AI Feedback)

../images/aien_0701.png

**Figure 7-1. Different finetuning techniques used to make different Code Llama models.**

# When to Finetune

## Reasons to Finetune

**1. Improve Instruction-Following for Specific Formats**:
- When you need the model to consistently follow a specific output format
- When you need it to adhere to particular style guidelines
- Especially important for semantic parsing tasks (converting natural language to structured formats like JSON, SQL, regex)

**2. Reduce Inference Cost and Latency**:
- Finetuning can distill complex behaviors into the model
- Instead of including many examples in each prompt (expensive), finetune the model once on those examples
- Shorter prompts = lower cost and faster inference

../images/aien_0702.png

**Figure 7-2. Instead of including examples in each prompt, which increases cost and latency, you finetune a model on these examples.**

**3. Improve Domain-Specific Capabilities**:
- When the model needs deep expertise in a specific domain
- When the domain has specialized vocabulary or concepts
- When you have domain-specific training data

**4. Enable On-Device Deployment**:
- Smaller finetuned models can run on devices
- Important for privacy-sensitive applications
- No need for API calls

**5. Custom Behavior**:
- When you need very specific behavior that's hard to prompt
- When you need consistent behavior across many queries
- When prompting doesn't achieve desired results

## Reasons Not to Finetune

**1. Up-front Investment Required**:
- Need to curate training data
- Need compute resources (GPUs)
- Need expertise in ML training
- Time-consuming process

**2. Maintenance Burden**:
- Need to host and serve finetuned models
- Need to update models as requirements change
- Need to manage multiple model versions
- More complex infrastructure

**3. Risk of Catastrophic Forgetting**:
- Finetuning can cause the model to forget previously learned capabilities
- Especially problematic with small amounts of training data
- Hard to predict what capabilities might be lost

**4. Data Quality Issues**:
- Finetuning amplifies any biases or errors in training data
- Bad data can make the model worse
- Hard to debug when things go wrong

**5. Prompting May Be Sufficient**:
- For many tasks, well-crafted prompts work well
- Easier to iterate on prompts than retrain models
- No hosting required

# Finetuning Domain-Specific Tasks

For domain-specific tasks, finetuning can significantly improve performance when:
- The domain has specialized vocabulary
- The model needs to learn domain-specific patterns
- You have sufficient high-quality domain-specific data

**Example**: Finetuning for medical question answering, legal document analysis, or code generation in a specific programming language.

**Best Practice**: Start with self-supervised finetuning on domain documents before moving to supervised finetuning with labeled data.

## Finetuning and RAG

**Common Question**: Should I use finetuning or RAG?

**Key Principle**: **Finetuning is for form, and RAG is for facts.**

**RAG**:
- Gives your model external knowledge
- Constructs more accurate and informative answers
- Helps mitigate hallucinations
- Good for information-based failures

**Finetuning**:
- Helps model understand and follow syntaxes and styles
- Good for behavioral issues
- Can potentially reduce hallucinations with enough high-quality data
- Can worsen hallucinations if data quality is low

**Decision Framework**:

**Use RAG when**:
- Model frequently fails due to missing information
- You need access to current/changing information
- You want to cite sources
- You don't have resources for finetuning

**Use Finetuning when**:
- Model has behavioral issues (generates irrelevant, malformatted, or unsafe responses)
- You need consistent output formats
- You want to reduce inference cost/latency
- Model needs to follow specific syntaxes

**Experimental Results**: Ovadia et al. (2024) showed that RAG outperforms finetuning on a question-answering task about current events:

**Table 7-2. RAG outperforms finetuning on current events QA**

| | Base model | Base model + RAG | FT-reg | FT-par | FT-reg + RAG | FT-par + RAG |
|---|---|---|---|---|---|---|
| Mistral-7B | 0.481 | 0.875 | 0.504 | 0.588 | 0.810 | 0.830 |
| Llama 2-7B | 0.353 | 0.585 | 0.219 | 0.392 | 0.326 | 0.520 |
| Orca 2-7B | 0.456 | 0.876 | 0.511 | 0.566 | 0.820 | 0.826 |

**Can They Be Combined?**: RAG and finetuning aren't mutually exclusive. They can sometimes be used together to maximize performance:
- Ovadia et al. (2024) showed that incorporating RAG on top of a finetuned model can boost its performance on MMLU benchmark 43% of the time
- Important note: Using RAG with finetuned models doesn't improve performance 57% of the time compared to using RAG alone

**Recommended Workflow**:

../images/aien_0703.png

**Figure 7-3. Example application development flows.**

**If your model has both information and behavior issues, start with RAG**:
1. RAG is typically easier (no need to curate training data or host finetuned models)
2. Start with simple term-based solutions (BM25) instead of jumping to vector databases
3. RAG can introduce more significant performance boost than finetuning

**Step-by-Step Workflow** (evaluation should be present during every step):

1. **Try prompting alone**: Use prompt engineering best practices, systematically version your prompts
2. **Add examples to prompt**: Depending on use case, might need 1-50 examples
3. **Add RAG if missing information**: Start with basic retrieval (term-based search). Adding relevant and accurate knowledge should lead to improvement
4. **Depending on failure modes, explore next steps**:
   - If model continues having information-based failures: Try advanced RAG methods (embedding-based retrieval)
   - If model continues having behavioral issues: Opt for finetuning (increases model development complexity but leaves inference unchanged)
5. **Combine both**: Use RAG and finetuning together for even more performance boost

# Memory Bottlenecks

Because finetuning is memory-intensive, many finetuning techniques aim to minimize their memory footprint. Understanding what causes this memory bottleneck is necessary to understand why and how these techniques work.

# Key Takeaways for Understanding Memory Bottlenecks

**Memory is the primary constraint** for finetuning large models:
- Modern GPUs have limited memory (even A100 has only 80GB)
- Large models require enormous amounts of memory
- Understanding memory requirements helps select appropriate finetuning methods

**Three main contributors to memory usage**:
1. **Model parameters** (the weights themselves)
2. **Gradients** (used during backpropagation)
3. **Activations** (intermediate values during forward pass)

## Backpropagation and Trainable Parameters

**Backpropagation** is the algorithm used to train neural networks:
- **Forward pass**: Input flows through network to produce output
- **Backward pass**: Error flows backward through network to update weights
- Only weights that are updated during training require gradient storage

../images/aien_0704.png

**Figure 7-4. The forward and backward pass of a simple neural network.**

**Trainable Parameters**:
- Parameters that are updated during training
- Only trainable parameters need gradients stored
- Reducing number of trainable parameters reduces memory requirements

**Key Insight**: Many finetuning techniques work by reducing the number of trainable parameters.

## Memory Math

Understanding how much memory is needed for different operations:

**Note**: Memory requirements depend on:
- Model size (number of parameters)
- Numerical precision (fp32, fp16, int8)
- Batch size
- Sequence length

### Memory needed for inference

**For Inference** (just running the model, not training):

**Basic Formula**: Memory ≈ Model Parameters × Bytes per Parameter

**Example**:
- Model with 7B parameters
- Using fp16 (2 bytes per parameter)
- Memory needed: 7B × 2 bytes = 14GB

**Additional Memory**:
- Activations (intermediate values)
- KV cache (for attention mechanism)
- Input/output data

**Rule of Thumb**: Expect to need 1.5-2× the basic calculation for safe inference.

### Memory needed for training

**For Training**, memory requirements are much higher:

**Components**:
1. **Model parameters**: Same as inference
2. **Gradients**: One gradient per trainable parameter (same size as parameters)
3. **Optimizer states**: Adam optimizer stores 2 states per parameter
4. **Activations**: All intermediate values from forward pass

**Formula for Full Training**:
Memory ≈ Parameters × (1 + 1 + 2) × Bytes per Parameter + Activations

**Example**:
- Model with 7B parameters
- Using fp16 (2 bytes)
- Memory needed: 7B × 4 × 2 bytes = 56GB (just for parameters, gradients, optimizer states)
- Plus activations (can be very large)

**Tip**: For models with billions of parameters, the memory needed for activations can dwarf the memory needed for model weights, especially with large batch sizes and long sequences.

../images/aien_0705.png

**Figure 7-5. The memory needed for activations can dwarf the memory needed for the model's weights.**

**Gradient Checkpointing**: A technique to reduce activation memory:
- Don't store all activations during forward pass
- Recompute them as needed during backward pass
- Trades compute for memory

## Numerical Representations

**Precision vs Memory Trade-off**: Different numerical formats use different amounts of memory and provide different precision:

**Common Formats**:
- **fp32** (float32): 32 bits, high precision, large memory
- **fp16** (float16): 16 bits, medium precision, half the memory
- **bf16** (bfloat16): 16 bits, different precision characteristics than fp16
- **int8**: 8 bits, low precision, quarter the memory
- **int4**: 4 bits, very low precision, eighth the memory

../images/aien_0706.png

**Figure 7-6. Different numerical formats with their range and precision.**

**Key Differences**:
- **fp32**: Standard precision, most accurate but memory-intensive
- **fp16**: Half precision, good trade-off for most use cases
- **bf16**: Better for training than fp16 (wider range, less precision)
- **int8/int4**: Quantized formats, much smaller but can lose accuracy

**Mixed Precision Training**: Using different precisions for different operations:
- Store weights in fp16/bf16
- Compute in fp32 where needed
- Can significantly reduce memory while maintaining accuracy

**Warning**: Lower precision can lead to:
- Numerical instability
- Training failures
- Loss of model accuracy
- Need to test carefully

## Quantization

**Quantization** is the process of reducing the numerical precision of model weights and/or activations.

# Quantization Versus Reduced Precision

**Reduced Precision**: Training/storing model in lower precision from the start (e.g., train in fp16 instead of fp32)

**Quantization**: Converting a trained model from higher to lower precision (e.g., convert trained fp32 model to int8)

**Key Difference**: Quantization typically happens after training and can involve more sophisticated techniques than just changing the data type.

### Inference quantization

**Post-Training Quantization** (PTQ): Quantize a trained model for more efficient inference:
- No retraining required
- Fast to apply
- Can reduce model size by 2-4×
- May have some accuracy loss

**Quantization-Aware Training** (QAT): Train the model while simulating quantization:
- Model learns to be robust to quantization
- Better accuracy than PTQ
- Requires retraining

**Benefits**:
- Smaller model size (easier to deploy)
- Faster inference
- Lower memory requirements
- Can run on devices without GPUs

**Popular Tools**:
- GGUF/llama.cpp
- GPTQ
- AWQ
- bitsandbytes

**Typical Results**:
- int8: ~2× reduction, minimal accuracy loss
- int4: ~4× reduction, some accuracy loss
- int2: ~8× reduction, significant accuracy loss possible

### Training quantization

**Quantized Training**: Train the model using lower precision throughout:
- Can significantly reduce memory requirements
- Enables training larger models on same hardware
- Requires careful tuning

**QLoRA** (Quantized LoRA): Combines quantization with LoRA (discussed next):
- Quantize base model to 4-bit
- Add LoRA adapters trained in higher precision
- Dramatic memory savings
- Can finetune 65B model on single 48GB GPU

# Finetuning Techniques

Now that we understand memory bottlenecks, let's explore techniques to make finetuning more efficient.

## Parameter-Efficient Finetuning

**PEFT (Parameter-Efficient Finetuning)** refers to techniques that update only a small fraction of a model's parameters during finetuning.

**Key Idea**: Instead of updating all billions of parameters, update only millions of parameters.

**Benefits**:
- Dramatically reduced memory requirements
- Faster training
- Easier to train multiple task-specific models
- Can switch between tasks by swapping small adapter modules

**Note**: The term "parameter-efficient" is somewhat misleading. The base model still needs to be loaded into memory during both training and inference. What's efficient is the number of *trainable* parameters, not necessarily the total parameters.

**Partial Finetuning**: An early approach was to finetune only some layers of the model (e.g., just the last few layers). However, this typically requires many trainable parameters to achieve performance comparable to full finetuning.

../images/aien_0707.png

**Figure 7-7. Partial finetuning requires many trainable parameters to achieve performance comparable to full finetuning.**

**Adapter Modules**: A better approach is to insert small adapter modules into the model:

../images/aien_0708.png

**Figure 7-8. By inserting adapter modules into each transformer layer and updating only the adapters, Houlsby et al. (2019) achieved strong finetuning performance using a small number of trainable parameters.**

**How Adapters Work**:
- Insert small neural network modules into existing layers
- Keep original model frozen
- Train only the adapters
- Adapters learn to modify the model's behavior

### PEFT techniques

**Popular PEFT Techniques**:

**1. Prompt Tuning / Soft Prompts**:
- Add trainable "soft prompt" tokens to input
- These aren't real words but learned embeddings
- Model learns optimal prompts for the task

../images/aien_0709.png

**Figure 7-9. Hard prompts and soft prompts can be combined to change a model's behaviors.**

**2. Prefix Tuning**:
- Similar to prompt tuning but adds trainable parameters to each layer
- More parameters than prompt tuning, potentially better performance

**3. LoRA (Low-Rank Adaptation)**:
- Most popular PEFT technique
- Will discuss in detail next

**4. (IA)³ (Infused Adapter by Inhibiting and Amplifying Inner Activations)**:
- Learns scaling vectors for activations
- Very parameter-efficient

**5. AdaLoRA**:
- Adaptive LoRA that allocates rank dynamically
- More parameters to important layers, fewer to less important ones

**Popularity of Different Techniques**:

../images/aien_0710.png

**Figure 7-10. The number of issues corresponding to different finetuning techniques from the GitHub repository huggingface/peft. This is a proxy to estimate the popularity of each technique.**

**LoRA is by far the most popular** PEFT technique in practice.

### LoRA

**LoRA (Low-Rank Adaptation)** by Hu et al. (2021) is the most widely used PEFT technique.

**Key Idea**: Instead of updating the entire weight matrix, decompose the update into two smaller matrices.

**How LoRA Works**:

For a weight matrix **W** of size d×d:
1. Keep **W** frozen (don't update it)
2. Add two small matrices **A** (d×r) and **B** (r×d) where r << d
3. The update is **ΔW = BA**
4. During inference: **W' = W + BA**

../images/aien_0711.png

**Figure 7-11. To apply LoRA to a weight matrix W, decompose it into the product of two matrices A and B. During finetuning, only A and B are updated. W is kept intact.**

**Memory Savings**:
- Original matrix W: d² parameters
- LoRA matrices: 2×d×r parameters
- If r << d, this is much smaller

**Example**:
- W is 4096×4096 = 16.8M parameters
- With r=8: A is 4096×8 and B is 8×4096 = 65.5K parameters
- **256× fewer parameters to train!**

**Note**: In practice, LoRA is typically applied only to the attention matrices (Q, K, V projections), not all weight matrices in the model. This further reduces the number of trainable parameters.

#### Why does LoRA work?

**Hypothesis**: The update to weight matrices during finetuning is **low-rank**:
- Many dimensions don't change much
- Changes can be captured in lower-dimensional space
- Don't need full-rank matrices to capture the update

**Theoretical Foundation**: This is based on the observation that:
- Pre-trained models contain rich representations
- Finetuning makes small, focused adjustments
- These adjustments don't require changing everything

**Empirical Evidence**: LoRA has been shown to achieve performance comparable to full finetuning on many tasks while using dramatically fewer trainable parameters.

#### LoRA configurations

**Key Hyperparameters**:

**1. Rank (r)**:
- How many dimensions to use in decomposition
- Typical values: 4, 8, 16, 32, 64
- Higher rank = more capacity but more parameters
- Trade-off between efficiency and performance

**2. Alpha (α)**:
- Scaling factor for LoRA update
- Controls how much LoRA affects the model
- Typical values: 16, 32
- Often set to 2×r

**3. Target Modules**:
- Which weight matrices to apply LoRA to
- Common: attention projection matrices (Q, K, V)
- Can also apply to feed-forward layers
- More modules = more parameters but potentially better performance

**4. Dropout**:
- Regularization for LoRA layers
- Helps prevent overfitting
- Typical values: 0.05, 0.1

**Choosing Configurations**:
- Start with standard values (r=8, α=16, target Q/K/V)
- Increase rank if model underperforms
- Decrease rank if overfitting
- Experiment to find optimal balance

**Note**: The optimal configuration depends on:
- Task complexity
- Amount of training data
- Base model size
- Computational budget

#### Serving LoRA adapters

**Beautiful Property of LoRA**: You can train multiple LoRA adapters for different tasks and swap them easily.

**Multi-LoRA Serving**:
1. Load base model once
2. Keep multiple LoRA adapters in memory
3. For each request, add appropriate LoRA adapter to base model
4. Serve different tasks without reloading model

../images/aien_0712.png

**Figure 7-12. Keeping LoRA adapters separate allows reuse of the same full-rank matrix W in multi-LoRA serving.**

**Benefits**:
- Serve many tasks with one base model
- Switch between tasks instantly
- Much more memory-efficient than loading separate models
- LoRA adapters are typically 1-5% size of base model

**Use Cases**:
- Multi-tenant systems (different customers)
- Multi-task systems (different capabilities)
- A/B testing different versions

**Challenges**:
- Need efficient adapter swapping
- Batch requests may need different adapters
- Need system to route requests to correct adapters

#### Quantized LoRA

**QLoRA** (Quantized LoRA) combines quantization with LoRA for even more memory savings.

**Key Idea**:
1. Quantize base model to 4-bit (drastically reduces memory)
2. Add LoRA adapters in higher precision (fp16/bf16)
3. Train only the LoRA adapters
4. Base model stays frozen in 4-bit

**Memory Savings**:
- Base model: 4× smaller (4-bit vs fp16)
- Only train small LoRA adapters
- Can finetune 65B model on single 48GB GPU!

**Practical Impact**:
- Makes large model finetuning accessible
- Can finetune on consumer hardware
- Dramatically reduces cloud costs

**Trade-offs**:
- Some quality loss from quantization
- Training slightly slower (need to dequantize on-the-fly)
- Inference can use either 4-bit or full precision

**Popular Implementation**: bitsandbytes library makes QLoRA easy to use.

## Model Merging and Multi-Task Finetuning

**Scenario**: You've finetuned multiple models for different tasks. Can you combine them into one model that can do all tasks?

**Two Approaches**:
1. **Multi-Task Finetuning**: Train one model on all tasks simultaneously
2. **Model Merging**: Combine already-finetuned models

### Ensembling vs Model Merging

**Ensembling**:
- Run multiple models on same input
- Combine their outputs (voting, averaging)
- Better performance but higher cost

**Model Merging**:
- Combine model weights into single model
- Run only one model
- Similar cost to running one model

../images/aien_0713.png

**Figure 7-13. How ensembling and model merging work.**

### Model Merging Approaches

../images/aien_0714.png

**Figure 7-14. Three main approaches to model merging: summing, layer stacking, and concatenation.**

**1. Summing**:
- Add or average weights from different models
- Simple but can be effective

**2. Layer Stacking**:
- Use different models for different layers
- More complex, preserves model specialization

**3. Concatenation**:
- Combine models side by side
- Increases model size

### Summing

#### Linear combination

**Simple Average**:
```
W_merged = (W_1 + W_2 + ... + W_n) / n
```

**Weighted Average**:
```
W_merged = α₁W_1 + α₂W_2 + ... + αₙWₙ
```
Where α₁ + α₂ + ... + αₙ = 1

**When It Works**:
- Models are finetuned from same base
- Tasks are related
- Simple tasks

**Limitations**:
- Can lose task-specific capabilities
- May perform worse than individual models
- Hard to predict results

**SLERP (Spherical Linear Interpolation)**:
- More sophisticated averaging
- Preserves magnitude of weights better
- Can give better results than simple averaging

**Task Arithmetic**:
- Add/subtract task vectors
- Task vector = finetuned model - base model
- Can combine or remove capabilities

**Applications**:
- Combine coding + math capabilities
- Remove unwanted behaviors
- Create multi-task models

**Challenges**:
- Not all merging works well
- Need experimentation
- Some task combinations don't merge well

# Summary

This chapter covered finetuning, a powerful technique for adapting foundation models to specific tasks:

**Core Concepts**:
- **Finetuning** adapts models by adjusting weights
- It's a form of **transfer learning**
- Improves **sample efficiency**

**When to Finetune**:
- Improve instruction-following for specific formats
- Reduce inference cost and latency
- Improve domain-specific capabilities
- Enable on-device deployment
- Achieve custom behavior

**When Not to Finetune**:
- Up-front investment required
- Maintenance burden
- Risk of catastrophic forgetting
- Data quality issues
- Prompting may be sufficient

**Finetuning vs RAG**:
- **Finetuning is for form** (style, format, behavior)
- **RAG is for facts** (knowledge, information)
- They can be combined for best results
- Start with RAG if model has both issues

**Memory Bottlenecks**:
- Memory is the primary constraint
- Three contributors: parameters, gradients, activations
- Understanding memory crucial for selecting techniques

**Memory Requirements**:
- **Inference**: ~2× model size
- **Training**: ~4× model size plus activations
- Different precisions have different memory/accuracy trade-offs

**Quantization**:
- **Inference quantization**: Reduce model size for deployment
- **Training quantization**: Reduce memory during training
- int8: ~2× reduction, minimal loss
- int4: ~4× reduction, some loss

**PEFT Techniques**:
- **Parameter-efficient** by training only small fraction of parameters
- **LoRA**: Most popular, uses low-rank decomposition
- **QLoRA**: Combines quantization with LoRA
- **Adapters**: Small modules inserted into model

**LoRA Details**:
- Decomposes weight updates into smaller matrices
- Dramatically fewer trainable parameters
- Can achieve comparable performance to full finetuning
- Key hyperparameters: rank, alpha, target modules

**LoRA Benefits**:
- Can train multiple adapters for different tasks
- Easy to swap adapters
- Memory-efficient multi-task serving
- LoRA adapters ~1-5% size of base model

**Model Merging**:
- Combine multiple finetuned models
- Approaches: summing, layer stacking, concatenation
- Linear combination (averaging weights)
- Task arithmetic (add/subtract capabilities)

**Key Takeaways**:
1. Finetuning powerful but resource-intensive
2. Memory is the main bottleneck
3. PEFT techniques make finetuning accessible
4. LoRA is the most practical PEFT technique
5. QLoRA enables large model finetuning on consumer hardware
6. Start with prompting and RAG before finetuning
7. Finetuning and RAG are complementary
8. Choose techniques based on constraints and goals
9. Experiment to find optimal configuration
10. Model merging enables multi-task models

The next chapter will cover dataset engineering—the crucial process of curating high-quality training data for finetuning.
