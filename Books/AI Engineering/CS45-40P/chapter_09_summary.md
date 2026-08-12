# Chapter 9. Inference Optimization

## Overview

New models come and go, but one thing will always remain relevant: **making them better, cheaper, and faster**. Up until now, the book has discussed techniques for making models better. This chapter focuses on making them **faster and cheaper**.

**Why Inference Optimization Matters**:
- **If too slow**: Users might lose patience, or worse, predictions might become useless (imagine a next-day stock price prediction that takes two days to compute)
- **If too expensive**: Return on investment won't be worth it

**Three Levels of Optimization**:

1. **Model Level**: Reduce a trained model's size or develop more efficient architectures (e.g., without computational bottlenecks in attention mechanism)
2. **Hardware Level**: Design more powerful hardware
3. **Service Level**: Run the model on given hardware to accommodate user requests efficiently

The **inference service** runs the model on hardware to accommodate user requests. It can:
- Incorporate techniques that optimize models for specific hardware
- Consider usage and traffic patterns to efficiently allocate resources
- Reduce latency and cost

**Interdisciplinary Field**: Inference optimization often sees collaboration among:
- Model researchers
- Application developers
- System engineers
- Compiler designers
- Hardware architects
- Data center operators

**Chapter Focus**: This chapter discusses bottlenecks for AI inference and techniques to overcome them, focusing mostly on optimization at the model and service levels, with an overview of AI accelerators.

**Trade-offs**: Sometimes a technique that speeds up a model can also reduce its cost (e.g., reducing precision makes it smaller and faster). But often, optimization requires trade-offs (e.g., best hardware might make model run faster but at higher cost).

**Why This Matters Even If You Don't Build Services**: Given the growing availability of open source models, more teams are building their own inference services. However, even if you don't implement these techniques, understanding them will help you **evaluate inference services and frameworks**.

# Understanding Inference Optimization

**Two Distinct Phases in AI Model Lifecycle**:
1. **Training**: Process of building a model
2. **Inference**: Process of using a model to compute an output for a given input

Unless you train or finetune a model, you'll mostly need to care about inference.

## Inference Overview

**Inference Server**: In production, the component that runs model inference. It:
- Hosts available models
- Has access to necessary hardware
- Allocates resources to execute appropriate models based on requests
- Returns responses to users

**Inference Service**: Broader system that includes the inference server and is also responsible for:
- Receiving requests
- Routing requests
- Possibly preprocessing requests before they reach inference server

../images/aien_0901.png

**Figure 9-1. A simple inference service.**

**Model APIs**: Services like those provided by OpenAI and Google are inference services. If you use one of these services, you won't be implementing most techniques discussed in this chapter. However, if you host a model yourself, you'll be responsible for building, optimizing, and maintaining its inference service.

### Computational bottlenecks

**Key Principle**: Optimization is about identifying bottlenecks and addressing them.

**Analogy**: To optimize traffic, city planners identify congestion points and take measures to alleviate congestion. Similarly, an inference server should be designed to address the computational bottlenecks of the inference workloads it serves.

**Two Main Computational Bottlenecks**:

**1. Compute-Bound**:
- Definition: Tasks whose time-to-complete is determined by the computation needed
- Example: Password decryption is typically compute-bound due to intensive mathematical calculations required to break encryption algorithms

**2. Memory Bandwidth-Bound**:
- Definition: Tasks constrained by data transfer rate within the system (speed of data movement between memory and processors)
- Example: If you store data in CPU memory and train a model on GPUs, you have to move data from CPU to GPU, which can take a long time
- Often shortened to "bandwidth-bound"
- In literature, often referred to as "memory-bound"

# Terminology Ambiguity: Memory-Bound Versus Bandwidth-Bound

**Memory-Bound** is also used by some people to refer to tasks whose time-to-complete is constrained by **memory capacity** instead of memory bandwidth. This occurs when hardware doesn't have sufficient memory to handle the task (e.g., machine doesn't have enough memory to store entire internet). Often manifested in the error: **OOM (out-of-memory)**.

**However**, this situation can often be mitigated by splitting task into smaller pieces. For example:
- If constrained by GPU memory and cannot fit entire model into GPU
- Can split model across GPU memory and CPU memory
- This splitting will slow down computation because of time it takes to transfer data between CPU and GPU
- But if data transfer is fast enough, this becomes less of an issue
- Therefore, memory capacity limitation is actually more about memory bandwidth

**Roofline Model**: The concepts of compute-bound or memory bandwidth-bound were introduced in the paper "Roofline" (Williams et al., 2009).

**Arithmetic Intensity**: Mathematically, an operation can be classified as compute-bound or memory bandwidth-bound based on its *arithmetic intensity*, which is the number of arithmetic operations per byte of memory access.

**Roofline Chart**: Profiling tools like NVIDIA Nsight show you a roofline chart to tell you whether your workload is compute-bound or memory bandwidth-bound:

../images/aien_0902.png

**Figure 9-2. The roofline chart can help you visualize whether an operation is compute-bound or memory bandwidth-bound. This graph is on a log scale.**

**Different Bottlenecks Require Different Optimizations**:
- **Compute-bound workload**: Might be sped up by spreading to more chips or leveraging chips with more computational power (higher FLOP/s)
- **Memory bandwidth-bound workload**: Might be sped up by leveraging chips with higher bandwidth

**Different Architectures Have Different Bottlenecks**:
- **Image generators** (like Stable Diffusion): Typically compute-bound
- **Autoregressive language models**: Typically memory bandwidth-bound

**Language Model Inference Example**: Recall from Chapter 2 that inference for a transformer-based language model consists of two steps:

1. **Prefilling**: Processing input tokens
2. **Decoding**: Generating output tokens

../images/aien_0903.png

**Figure 9-3. Autoregressive language models follow two steps for inference: prefill and decode. `<eos>` denotes the end of the sequence token.**

**Prefill Phase**:
- Compute-bound
- Can process all input tokens in parallel
- More FLOPs than decoding per token

**Decode Phase**:
- Memory bandwidth-bound
- Must generate tokens sequentially (one at a time)
- Each token generation requires loading entire model from memory
- Loading model weights from memory is the bottleneck, not computation

### Online and batch inference APIs

**Two Types of Inference APIs**:

**1. Online Inference (Streaming)**:
- Returns tokens as they're generated
- User sees output in real-time
- Better user experience for long responses
- Example: ChatGPT's streaming responses

**2. Batch Inference (Non-Streaming)**:
- Returns complete response after all tokens are generated
- User waits for entire response
- Can be more efficient for backend processing
- Example: Batch processing of documents

**Warning**: Some model API providers charge differently for online vs batch inference. Batch inference is typically cheaper because it gives the provider more flexibility in scheduling and resource allocation.

**User Experience Considerations**:
- For interactive applications, streaming is preferred
- For backend processing, batch may be more cost-effective
- Choice depends on use case and latency requirements

## Inference Performance Metrics

Understanding performance metrics is crucial for evaluating and optimizing inference services.

### Latency, TTFT, and TPOT

**Latency**: Total time from sending a request to receiving the complete response.

**TTFT (Time To First Token)**:
- Time from sending request to receiving first token of response
- Critical for user experience in streaming applications
- Users perceive faster response if TTFT is low

**TPOT (Time Per Output Token)**:
- Average time to generate each subsequent token after the first
- Determines how quickly response streams to user
- Important for long responses

**Example**:
- TTFT = 200ms
- TPOT = 50ms
- For 100-token response: Total latency = 200ms + (100 × 50ms) = 5.2 seconds

**What's Considered Good**:
- TTFT: Typically want < 200-500ms for good UX
- TPOT: Typically want < 50-100ms for smooth streaming
- Varies by application and user expectations

**Trade-offs**:
- Optimizing for TTFT may hurt TPOT and vice versa
- Batching can improve throughput but increase TTFT
- Need to balance based on application requirements

### Throughput and goodput

**Throughput**: Measures the number of output tokens per second an inference service can generate across all users and requests.

**Important Note**: Some teams count both input and output tokens in throughput calculation. However, since processing input tokens (prefilling) and generating output tokens (decoding) have different computational bottlenecks and are often decoupled in modern inference servers, **input and output throughput should be counted separately**.

When throughput is used without modifier, it usually refers to **output tokens**.

**Units**:
- **TPS (Tokens Per Second)**: Most common for throughput
- **TPS/user**: Used to evaluate how system scales with more users
- **RPS (Requests Per Second)**: For completed requests
- **RPM (Requests Per Minute)**: Many use this instead of RPS since requests might take seconds to complete

**Throughput and Cost**: Throughput is directly linked to compute cost. Higher throughput typically means lower cost.

**Example Calculation**:
- System costs $2/hour in compute
- Throughput is 100 tokens/s
- Cost: $2/hour ÷ 3600 seconds = $0.000556/second
- At 100 tokens/s: $0.000556 ÷ 100 = $5.556 per 1M output tokens

**For Complete Request Cost**:
- If each request generates 200 output tokens on average
- Cost for 1K requests (decode): $1.11
- If hardware can prefill 100 requests/minute at $2/hour
- Cost for 1K requests (prefill): $0.33
- **Total cost per 1K requests**: $1.44

**What's Considered Good Throughput** depends on:
- Model size
- Hardware
- Workload

Smaller models and higher-end chips typically result in higher throughput. Workloads with consistent input/output lengths are easier to optimize than workloads with variable lengths.

**Comparison Challenges**: Even for similarly sized models, hardware, and workloads, direct throughput comparisons might be only approximate because token count depends on what constitutes a token (different models have different tokenizers). Better to compare efficiency using **cost per request**.

**Latency/Throughput Trade-off**: Just like most other software applications, AI applications have this trade-off:
- Techniques like batching can improve throughput but increase latency
- According to LinkedIn AI team, it's not uncommon to double or triple throughput if willing to sacrifice TTFT and TPOT

**Goodput**: Due to latency/throughput trade-off, focusing on throughput and cost alone can lead to bad user experience.

**Goodput** is a metric adapted from networking for LLM applications. It measures the **number of requests per second that satisfies the SLO (Service-Level Objective)**.

**Example**:
- Application objectives: TTFT ≤ 200ms and TPOT ≤ 100ms
- Inference service can complete 100 requests per minute
- Out of these 100 requests, only 30 satisfy the SLO
- **Goodput = 30 requests per minute**

../images/aien_0904.png

**Figure 9-4. If an inference service can complete 10 RPS but only 3 satisfy the SLO, then its goodput is 3 RPS.**

### Utilization, MFU, and MBU

**Utilization Metrics**: Measure how efficiently a resource is being used. Typically quantifies the proportion of the resource actively being used compared to its total available capacity.

**GPU Utilization (Common but Misunderstood)**:
- NVIDIA's `nvidia-smi` tool shows GPU utilization
- Represents percentage of time during which GPU is actively processing tasks
- **Problem**: Actively processing doesn't mean doing so efficiently

**Example of the Problem**:
- Consider a GPU capable of 100 operations per second
- In `nvidia-smi`'s definition, this GPU can report 100% utilization even if only doing 1 operation per second
- If you pay for a machine that can do 100 operations and use it for only 1, you're wasting money
- Therefore, `nvidia-smi`'s GPU optimization metric is not very useful

**MFU (Model FLOP/s Utilization)**:
- The utilization metric you actually care about
- Ratio of observed throughput (tokens/s) relative to theoretical maximum throughput of system operating at peak FLOP/s
- **Example**: If at peak FLOP/s advertised by chip maker, chip can generate 100 tokens/s, but when used for your inference service it can generate only 20 tokens/s, your **MFU = 20%**

**MBU (Model Bandwidth Utilization)**:
- Measures percentage of achievable memory bandwidth used
- **Example**: If chip's peak bandwidth is 1 TB/s and your inference uses only 500 GB/s, your **MBU = 50%**

**Computing Memory Bandwidth for LLM Inference**:
```
parameter count × bytes/param × tokens/s
```

**MBU Formula**:
```
(parameter count × bytes/param × tokens/s) / (theoretical bandwidth)
```

**Example Calculation**:
- 7B-parameter model in FP16 (2 bytes per parameter)
- Achieving 100 tokens/s
- Bandwidth used: 7B × 2 × 100 = 700 GB/s
- On A100-80GB GPU (2 TB/s theoretical bandwidth)
- **MBU = 700 GB/s ÷ 2 TB/s = 35%**

**Importance of Quantization**: This underscores importance of quantization (Chapter 7). Fewer bytes per parameter mean model consumes less valuable bandwidth.

**Relationships**: The relationships between throughput (tokens/s) and MBU and between throughput and MFU are linear, so some people might use throughput to refer to MBU and MFU.

**What's Considered Good** depends on model, hardware, and workload:
- **Compute-bound workloads**: Typically have higher MFU and lower MBU
- **Bandwidth-bound workloads**: Often show lower MFU and higher MBU

**Training vs Inference**:
- Training can benefit from more efficient optimization (better batching) thanks to more predictable workloads
- **MFU for training typically higher than MFU for inference**
- For inference: Prefill (compute-bound) typically has higher MFU than decode (memory bandwidth-bound)
- For model training, as of this writing, **MFU above 50% is generally considered good**, but can be hard to achieve on specific hardware

**MFU Examples**:

**Table 9-1. MFU examples from "PaLM: Scaling Language Modeling with Pathways"**

| Model | Parameters | Accelerator chips | MFU |
|---|---|---|---|
| GPT-3 | 175B | V100 | 21.3% |
| Gopher | 280B | 4096 TPU v3 | 32.5% |
| Megatron-Turing NLG | 530B | 2240 A100 | 30.2% |
| PaLM | 540B | 6144 TPU v4 | 46.2% |

**MBU with Increasing Users**:

../images/aien_0905.png

**Figure 9-5. Bandwidth utilization for Llama 2-70B in FP16 across three different chips shows a decrease in MBU as the number of concurrent users increases.**

The decline is likely due to higher computational load per second with more users, shifting the workload from being bandwidth-bound to compute-bound.

**Important Note**: Utilization metrics are helpful to track system efficiency. Higher utilization rates for similar workloads on same hardware generally mean services are becoming more efficient. However, **the goal isn't to get chips with highest utilization**. What you really care about is how to get your jobs done faster and cheaper. A higher utilization rate means nothing if cost and latency both increase.

## AI Accelerators

How fast and cheap software can run depends on the hardware it runs on. While there are optimization techniques that work across hardware, understanding hardware allows for deeper optimization.

**Historical Context**: The development of AI models and hardware has always been intertwined:
- Lack of sufficiently powerful computers was one contributing factor to first AI winter in 1970s
- Revival of interest in deep learning in 2012 was also closely tied to compute
- AlexNet's success was partly because it was first paper to successfully use GPUs to train neural networks

**Before GPUs**: If you wanted to train a model at AlexNet's scale, you'd have to use thousands of CPUs. Compared to thousands of CPUs, a couple of GPUs were much more accessible to PhD students and researchers, setting off the deep learning research boom.

### What's an accelerator?

**Accelerator**: A chip designed to accelerate a specific type of computational workload.

**AI Accelerator**: Designed for AI workloads. The dominant type is GPUs, and the biggest economic driver during the AI boom in early 2020s is undoubtedly NVIDIA.

**Main Difference Between CPUs and GPUs**:

**CPUs**:
- Designed for general-purpose usage
- Have a few powerful cores (typically up to 64 cores for high-end consumer machines)
- Excel at tasks requiring high single-thread performance
- Good for: running OS, managing I/O operations, handling complex sequential processes

**GPUs**:
- Designed for parallel processing
- Have thousands of smaller, less powerful cores
- Optimized for tasks that can be broken down into many smaller, independent calculations
- Good for: graphics rendering and machine learning
- The operation that constitutes most ML workloads is matrix multiplication, which is highly parallelizable

**Trade-off**: While pursuit of efficient parallel processing increases computational capabilities, it imposes challenges on memory design and power consumption.

**The Accelerator Landscape**: The success of NVIDIA GPUs has inspired many accelerators designed to speed up AI workloads:
- AMD's newer generations of GPUs
- Google's TPU (Tensor Processing Unit)
- Intel's Habana Gaudi
- Graphcore's Intelligent Processing Unit (IPU)
- Groq's Language Processing Unit (LPU)
- Cerebras' Wafer-Scale Quant Processing Unit (QPU)
- Many more being introduced

**Specialized Chips for Inference**: One big theme emerging is specialized chips for inference. A survey by Desislavov et al. (2023) shares that:
- Inference can exceed the cost of training in commonly used systems
- Inference accounts for up to 90% of machine learning costs for deployed AI systems

**Why Inference-Specific Chips**: As discussed in Chapter 7:
- Training demands much more memory due to backpropagation
- Generally more difficult to perform in lower precision
- Training usually emphasizes throughput
- Inference aims to minimize latency

### Computational capabilities

**FLOP/s (Floating-Point Operations Per Second)**: Most commonly used metric for comparing computational capabilities of different chips.

**Different Precisions Have Different FLOP/s**:
- Same chip can have different FLOP/s for different precisions
- Lower precision typically allows for higher FLOP/s
- Example: A chip might have:
  - 100 TFLOP/s for FP32
  - 200 TFLOP/s for FP16
  - 400 TFLOP/s for INT8

**Why This Matters**: This is another reason why quantization is so important—lower precision models can leverage higher FLOP/s.

**Other Factors**:
- Peak FLOP/s vs sustained FLOP/s
- Different operations have different speeds
- Memory bandwidth often more important than raw compute for inference

### Memory size and bandwidth

**Memory Hierarchy**: AI accelerators have a memory hierarchy:

../images/aien_0907.png

**Figure 9-7. The memory hierarchy of an AI accelerator. The numbers are for reference only. The actual numbers vary for each chip.**

**Levels** (from fastest/smallest to slowest/largest):
1. **Registers**: Fastest, smallest, most expensive
2. **L1 Cache**: Very fast, small
3. **L2 Cache**: Fast, medium
4. **HBM (High Bandwidth Memory)**: Slower than cache but much larger
5. **DRAM**: Even larger but slower
6. **SSD/HDD**: Largest but slowest

**Key Trade-offs**:
- **Memory Size**: How much data can be stored
- **Memory Bandwidth**: How fast data can be moved
- **Latency**: How quickly data can be accessed

**For Inference**: Memory bandwidth is often the bottleneck, especially for large models during decoding phase.

**Example**:
- Model is 14GB (7B params in FP16)
- To generate 1 token, need to load entire 14GB from memory
- If memory bandwidth is 2 TB/s, loading takes ~7ms
- Actual computation might take <1ms
- **Bottleneck is memory bandwidth, not computation**

### Power consumption

**Why It Matters**:
- Data center costs include both hardware and electricity
- More powerful chips consume more power
- Power consumption generates heat requiring cooling
- Can be significant portion of total cost of ownership

**Metrics**:
- **TDP (Thermal Design Power)**: Maximum power chip will draw
- **Watts per TFLOP**: Efficiency metric
- **Performance per Watt**: Another efficiency metric

**Trade-offs**:
- More powerful chips = more power consumption
- But also more work done per unit time
- Need to consider both performance and power efficiency

# Selecting Accelerators

**Key Factors to Consider**:

1. **Performance**: FLOP/s, memory bandwidth, memory size
2. **Cost**: Hardware cost, electricity cost, operational costs
3. **Availability**: Can you actually get the chips?
4. **Software Support**: Drivers, libraries, frameworks
5. **Workload Fit**: Does the chip match your workload characteristics?

**No Universal Best**: The best accelerator depends on your specific use case, workload, and constraints.

# Inference Optimization

Ideally, optimizing a model for speed and cost shouldn't change the model's quality. However, many techniques might cause model degradation.

../images/aien_0908.png

**Figure 9-8. An inference service provider might use optimization techniques that can alter a model's behavior, causing different providers to have slight model quality variations.**

Since hardware design is outside the scope of this book, we'll discuss techniques at the model and service levels. While the techniques are discussed separately, keep in mind that in production, optimization typically involves techniques at more than one level.

## Model Optimization

Model-level optimization aims to make the model more efficient, often by modifying the model itself, which can alter its behavior.

**Three Characteristics That Make Inference Resource-Intensive**:
1. Model size
2. Autoregressive decoding
3. Attention mechanism

Let's discuss approaches to address these challenges.

### Model compression

**Model Compression**: Techniques that reduce a model's size. Making a model smaller can also make it faster.

**Two Techniques Already Discussed**:
1. **Quantization** (Chapter 7): Reducing precision to reduce memory footprint and increase throughput
2. **Model Distillation** (Chapter 8): Training a small model to mimic behavior of large model

**Pruning**: Model distillation suggests it's possible to capture a large model's behaviors using fewer parameters. Could there be a subset of parameters within the large model capable of capturing entire model's behavior? This is the core concept behind pruning.

**Two Meanings of Pruning**:

1. **Architecture Pruning**: Remove entire nodes of neural network
   - Changes architecture
   - Reduces number of parameters

2. **Weight Pruning**: Find parameters least useful to predictions and set them to zero
   - Doesn't reduce total number of parameters
   - Only reduces number of non-zero parameters
   - Makes model more sparse
   - Reduces storage space and speeds up computation

**Post-Pruning**: Pruned models can be:
- Used as-is
- Further finetuned to adjust remaining parameters and restore any performance degradation

**Benefits**:
- Can help discover promising model architectures
- Pruned architectures can be trained from scratch
- Can reduce non-zero parameter counts by over 90% in some cases
- Decreases memory footprints and improves speed without compromising accuracy

**Reality Check**: In practice, as of this writing, pruning is less common:
- Harder to do (requires understanding of original model's architecture)
- Performance boost often much less than other approaches
- Results in sparse models, and not all hardware architectures designed to take advantage of resulting sparsity

**Most Popular Approach**: *Weight-only quantization is by far the most popular approach* since it's:
- Easy to use
- Works out of the box for many models
- Extremely effective

Reducing model's precision from 32 bits to 16 bits reduces memory footprint by half. However, we're close to the limit of quantization—we can't go lower than 1 bit per value.

**Distillation**: Also common because it can result in a smaller model whose behavior is comparative to that of a much larger one for your needs.

### Overcoming the autoregressive decoding bottleneck

As discussed in Chapter 2, autoregressive language models generate one token after another.

**The Problem**:
- If it takes 100ms to generate one token
- A response of 100 tokens will take 10 seconds
- This process is not just slow, it's also expensive

**Cost Reality**: Across model API providers:
- An output token costs approximately 2-4× an input token
- Anyscale found that a single output token can have the same impact on latency as 100 input tokens

**Impact**: Improving the autoregressive generation process by a small percentage can significantly improve user experience.

**Note**: The space is rapidly evolving, and new techniques are being developed to overcome this seemingly impossible bottleneck. Perhaps one day, there will be architectures that don't have this bottleneck. The techniques covered here are to illustrate what the solution might look like.

#### Speculative decoding

**Speculative Decoding** (also called speculative sampling) uses a faster but less powerful model to generate a sequence of tokens, which are then verified by the target model.

**Terminology**:
- **Target model**: The model you want to use
- **Draft/proposal model**: The faster model that proposes draft output

**How It Works**:

Given input tokens x₁, x₂, …, xₜ:

1. **Draft model generates** a sequence of K tokens: xₜ₊₁, xₜ₊₂, …, xₜ₊ₖ
2. **Target model verifies** these K generated tokens in parallel
3. **Target model accepts** the longest subsequence of draft tokens, from left to right, which the target model agrees to use
4. Let's say target model accepts j draft tokens: xₜ₊₁, xₜ₊₂, …, xₜ₊ⱼ. The target model then generates one extra token: xₜ₊ⱼ₊₁

The process returns to step 1, with draft model generating K tokens conditioned on x₁, x₂, …, xₜ, xₜ₊₁, xₜ₊₂, …, xₜ₊ⱼ.

../images/aien_0909.png

**Figure 9-9. A draft model generates a sequence of K tokens, and the main model accepts the longest subsequence that it agrees with.**

**Outcomes**:
- If no draft token is accepted: Loop produces only 1 token (generated by target model)
- If all draft tokens are accepted: Loop produces K + 1 tokens (K by draft model, 1 by target model)

**Why This Works** (Three Key Insights):

1. **Verification is Faster Than Generation**:
   - Time for target model to verify a sequence < time to generate it
   - Verification is parallelizable, while generation is sequential
   - Speculative decoding effectively turns computation profile of decoding into that of prefilling

2. **Some Tokens Are Easier to Predict**:
   - In an output token sequence, some tokens are easier to predict than others
   - Possible to find a weaker draft model capable of getting easier-to-predict tokens right
   - Leads to high acceptance rate of draft tokens

3. **Free Verification**:
   - Decoding is memory bandwidth-bound
   - During the decoding process, there are typically idle FLOPs
   - These can be used for free verification

**Potential Issue**: If all draft sequences are rejected, target model must generate entire response in addition to verifying it, potentially leading to increased latency. However, this can be avoided due to the three insights above.

#### Inference with reference

**Concept**: For some tasks, parts of the output can be directly copied from the input or from a provided reference document.

**Examples**:
- Summarization: Copy key phrases from original
- Translation: Some proper nouns don't need translation
- Question answering: Extract relevant spans from document
- Code editing: Copy unchanged parts of code

../images/aien_0910.png

**Figure 9-10. Two examples of inference with reference. The text spans that are successfully copied from the input are in red and green.**

**How It Helps**:
- Don't need to generate tokens that can be copied
- Can dramatically speed up inference for applicable tasks
- Maintains quality by using exact text from source

**Limitations**:
- Only works for tasks where copying is appropriate
- Need mechanism to identify what can be copied
- Not applicable to all generation tasks

#### Parallel decoding

**Concept**: Instead of generating one token at a time, try to generate multiple tokens in parallel.

**Challenge**: Autoregressive models by definition generate tokens sequentially (each token depends on previous tokens). How can we generate in parallel?

**Solution - Multiple Decoding Heads**: Add multiple prediction heads to the model, each predicting a different position in the future sequence.

**Example - Medusa**:

../images/aien_0911.png

**Figure 9-11. In Medusa, each head predicts several options for a token position. The most promising sequence from these options is selected.**

**How It Works**:
- Each head predicts several options for a token position
- Generate tree of possible sequences
- Select most promising sequence from these options
- Verify selected sequence with main model

**Benefits**:
- Can generate multiple tokens per step
- Reduces number of sequential steps needed
- Can significantly improve throughput

**Challenges**:
- Need to train additional prediction heads
- Selecting best sequence adds complexity
- Not all tokens can be predicted in parallel

### Attention mechanism optimization

**The Problem**: The attention mechanism, while powerful, is computationally expensive, especially for long sequences.

**Key Issue**: For each generated token, need to compute attention over all previous tokens. As sequence grows, this becomes increasingly expensive.

#### KV Cache

**Solution**: To avoid recomputing the key and value vectors at each decoding step, use a **KV cache** to store these vectors to reuse.

../images/aien_0912.png

**Figure 9-12. To avoid recomputing the key and value vectors at each decoding step, use a KV cache to store these vectors to reuse.**

**How It Works**:
- During prefill: Compute key and value for all input tokens, store in cache
- During decode: For each new token:
  - Only compute key and value for new token
  - Retrieve stored keys and values from cache
  - Compute attention using new and cached KV

**Benefits**:
- Dramatically reduces computation
- Essential for efficient autoregressive generation
- Standard practice in modern inference systems

**Trade-off**:
- Requires additional memory to store cache
- Memory requirements grow with sequence length
- Can become bottleneck for very long sequences

**Note**: KV cache is so fundamental that it's essentially required for practical autoregressive inference.

# Calculating the KV Cache Size

**Formula**:
```
KV cache size = 2 × num_layers × hidden_size × sequence_length × batch_size × bytes_per_param
```

**Example**:
- 7B parameter model
- 32 layers
- Hidden size of 4096
- Sequence length of 2048
- Batch size of 8
- FP16 (2 bytes)

```
KV cache = 2 × 32 × 4096 × 2048 × 8 × 2
         = 4,294,967,296 bytes
         = 4 GB
```

**For Large Batches and Long Sequences**: KV cache can become very large, sometimes exceeding the model size itself!

#### Redesigning the attention mechanism

**Problem**: Standard attention has O(n²) complexity with respect to sequence length. For long sequences, this becomes prohibitively expensive.

**Solutions**: Various attention mechanisms designed to reduce complexity:
- **Sparse attention**: Only attend to subset of tokens
- **Linear attention**: Reduce complexity to O(n)
- **Sliding window attention**: Only attend to nearby tokens
- **Global + local attention**: Combine global and local attention patterns

**Trade-offs**:
- Reduced computational cost
- But may sacrifice some model quality
- Effectiveness depends on task

#### Optimizing the KV cache size

**Problem**: KV cache can consume significant memory, limiting batch size or sequence length.

**Solutions**:

**1. Quantize KV Cache**:
- Store KV in lower precision (INT8 instead of FP16)
- Can reduce memory by 2-4×
- Usually minimal quality loss

**2. Multi-Query Attention (MQA)**:
- Share key and value across all attention heads
- Only query is different for each head
- Dramatically reduces KV cache size

**3. Grouped-Query Attention (GQA)**:
- Middle ground between standard and MQA
- Group attention heads, share KV within groups
- Balance between cache size and model quality

**Impact**: These optimizations can reduce KV cache size by 4-8× with minimal quality loss.

#### Writing kernels for attention computation

**Kernel**: A kernel is a function that runs on an accelerator (like a GPU). Writing efficient kernels is crucial for performance.

**Problem**: Standard attention implementation involves many separate operations (matrix multiplications, softmax, etc.). Each operation:
- Reads from memory
- Computes
- Writes back to memory

Multiple memory accesses are slow and inefficient.

**Solution - Kernel Fusion**: Combine multiple operations into a single kernel that:
- Reads from memory once
- Performs all operations
- Writes back once

**FlashAttention**: A famous example of kernel fusion for attention:

../images/aien_0913.png

**Figure 9-13. FlashAttention is a kernel that fuses together several common operators.**

**Benefits**:
- Dramatically reduces memory accesses
- Can be 2-4× faster than standard attention
- Enables longer sequences
- Works without changing model architecture

**Challenge**: Writing efficient kernels requires deep understanding of hardware and low-level programming.

### Kernels and compilers

**Kernels**: Low-level functions that run on accelerators. Writing efficient kernels is crucial but challenging.

**Compilers**: Translate high-level code (Python, PyTorch) into low-level kernels. Modern compilers can automatically optimize many operations.

**Examples**:
- **TorchScript**: Compiles PyTorch code
- **TensorRT**: NVIDIA's compiler for inference
- **XLA**: Google's compiler (used by JAX and TensorFlow)
- **MLIR**: Framework for building compilers

**Benefits of Compilation**:
- Automatic optimization
- Operator fusion
- Memory optimization
- Hardware-specific optimization

**Trade-offs**:
- Compilation takes time
- Some operations hard to optimize automatically
- May need to write custom kernels for best performance

# Inference Optimization Case Study from PyTorch

PyTorch team shared their optimization journey, showing dramatic improvements:

../images/aien_0914.png

**Figure 9-14. Throughput improvement by different optimization techniques in PyTorch.**

**Techniques Applied** (each building on previous):
1. Baseline PyTorch
2. Compile with TorchScript
3. Quantization (INT8)
4. Better kernels (custom implementations)
5. Operator fusion
6. Memory optimization

**Result**: Combined optimizations resulted in 10-20× throughput improvement over baseline!

**Key Takeaway**: Multiple optimization techniques applied together can have multiplicative effects.

## Inference Service Optimization

Beyond optimizing the model itself, can optimize how the service runs the model.

### Batching

**Batching**: Process multiple requests together to improve throughput.

**Why It Works**:
- GPUs are parallel processors
- Processing 1 request doesn't fully utilize GPU
- Processing multiple requests together increases utilization
- Better amortizes cost of loading model from memory

**Static Batching**: Wait for N requests, then process them together.
- **Problem**: Have to wait for batch to fill
- Increases latency for early requests

**Dynamic Batching**: As requests come in, add them to current batch up to size limit.

../images/aien_0915.png

**Figure 9-15. Dynamic batching keeps the latency manageable but might be less compute-efficient.**

**Benefits**:
- Better latency than static batching
- Still improves throughput over no batching

**Challenge**: Variable sequence lengths make batching less efficient (need to pad to max length).

**Continuous Batching**: More advanced batching that handles variable-length sequences better.

../images/aien_0916.png

**Figure 9-16. With continuous batching, completed responses can be returned immediately to users, and new requests can be processed in their place.**

**How It Works**:
- As responses complete, remove them from batch
- Add new requests to fill slots
- Don't wait for entire batch to complete

**Benefits**:
- Better utilization than dynamic batching
- Lower latency
- More efficient with variable-length sequences

### Decoupling prefill and decode

**Problem**: Prefill (compute-bound) and decode (memory bandwidth-bound) have different computational characteristics. Running them together on same hardware is inefficient.

**Solution**: Run prefill and decode on separate hardware:
- **Prefill**: Use compute-optimized chips
- **Decode**: Use bandwidth-optimized chips

**Benefits**:
- Better hardware utilization
- Can optimize each stage independently
- Can scale prefill and decode independently

**Challenges**:
- More complex system architecture
- Need to transfer state between stages
- Coordination overhead

### Prompt caching

**Observation**: Many requests share common prefixes (system prompts, context, etc.).

**Problem**: Recomputing same prefill for every request is wasteful.

**Solution - Prompt Caching**: Cache the KV states from commonly used prefixes.

../images/aien_0917.png

**Figure 9-17. With a prompt cache, overlapping segments in different prompts can be cached and reused.**

**How It Works**:
1. When processing a request, check if prefix is in cache
2. If yes, load cached KV states
3. Only compute from where cache ends
4. Dramatically reduces prefill time for cached prefixes

**Benefits**:
- Can reduce prefill cost by 90%+ for common prefixes
- Lower latency for cached requests
- Significant cost savings

**Example Use Cases**:
- System prompts (same for all requests)
- Few-shot examples (same for category of requests)
- RAG context (same document accessed multiple times)

**Trade-offs**:
- Requires memory to store cache
- Cache management complexity
- Cache invalidation strategy needed

### Parallelism

For very large models that don't fit on a single chip, need to split across multiple chips.

**Types of Parallelism**:

**1. Data Parallelism**:
- Replicate model across chips
- Each chip processes different batch
- Simple but doesn't help with large models

**2. Tensor Parallelism**:
- Split individual layers across chips
- Each chip computes part of the layer

../images/aien_0918.png

**Figure 9-18. Tensor parallelism for matrix multiplication.**

**How It Works**:
- Split weight matrix across chips
- Each chip computes its portion
- Combine results

**Benefits**:
- Can fit larger models
- Good for very wide layers

**Trade-offs**:
- Requires fast inter-chip communication
- Synchronization overhead

**3. Pipeline Parallelism**:
- Split model into stages
- Each chip handles different stages
- Pipeline execution of batches

../images/aien_0919.png

**Figure 9-19. Pipeline parallelism enables model splits to be executed in parallel.**

**How It Works**:
- Chip 1 processes batch 1
- When done, sends to Chip 2 and starts batch 2
- Chip 2 processes batch 1 while Chip 1 processes batch 2
- Creates a pipeline

**Benefits**:
- Can handle very large models
- Less inter-chip communication than tensor parallelism

**Trade-offs**:
- Pipeline bubbles (idle time)
- More complex to implement
- Requires careful batch scheduling

**In Practice**: Often use combination of parallelism strategies (tensor + pipeline, or tensor + data) to handle very large models efficiently.

# Summary

This chapter covered inference optimization—making models faster and cheaper:

**Core Concepts**:
- **Optimization happens at three levels**: Model, hardware, and service
- **Two main bottlenecks**: Compute-bound and memory bandwidth-bound
- **Language model inference**: Prefill (compute-bound) and decode (bandwidth-bound)

**Performance Metrics**:
- **Latency**: Total time from request to response
- **TTFT**: Time to first token (critical for UX)
- **TPOT**: Time per output token
- **Throughput**: Tokens/s across all requests
- **Goodput**: Requests satisfying SLO per second
- **MFU**: Model FLOP/s utilization
- **MBU**: Model bandwidth utilization

**AI Accelerators**:
- **CPUs**: General-purpose, few powerful cores
- **GPUs**: Parallel processing, thousands of cores
- **Specialized accelerators**: TPUs, Gaudi, IPU, LPU, etc.
- **Key specs**: FLOP/s, memory bandwidth, memory size, power consumption

**Model Optimization**:
- **Compression**: Quantization (most popular), distillation, pruning
- **Overcoming autoregressive bottleneck**:
  - Speculative decoding
  - Inference with reference
  - Parallel decoding
- **Attention optimization**:
  - KV cache (essential)
  - Redesigned attention (sparse, linear)
  - Cache optimization (quantization, MQA, GQA)
  - Kernel fusion (FlashAttention)

**Service Optimization**:
- **Batching**: Dynamic, continuous
- **Decoupling prefill and decode**: Optimize each stage
- **Prompt caching**: Reuse common prefixes
- **Parallelism**: Tensor, pipeline, data

**Key Takeaways**:
1. Inference optimization is about identifying and addressing bottlenecks
2. Different workloads have different bottlenecks (compute vs bandwidth)
3. Metrics must align with actual goals (not just utilization)
4. Multiple optimization techniques have multiplicative effects
5. Quantization is by far the most practical compression technique
6. KV cache is essential for autoregressive inference
7. Memory bandwidth often more important than compute for inference
8. Batching crucial for throughput but affects latency
9. Prompt caching can dramatically reduce costs
10. Evaluation of optimization requires measuring actual performance

Understanding these techniques helps whether building your own inference service or evaluating external providers.
