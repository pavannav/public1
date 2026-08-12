# Chapter 9: Inference Optimization

---

## Overview

No matter how good your model is, if it's **too slow** or **too expensive**, it won't work in production. A next-day stock price prediction that takes two days to compute is useless. A model with a negative return on investment won't survive.

Inference optimization makes models **faster** and **cheaper** — and this chapter is about how.

Optimization happens at three levels:

| Level | What it optimizes | Who does it |
|---|---|---|
| **Model** | Reduce model size, improve architecture | Model researchers, AI engineers |
| **Hardware** | Design more powerful chips | Hardware architects |
| **Service** | Efficiently allocate hardware resources to requests | System engineers, application developers |

Even if you use a commercial API and never implement these techniques yourself, understanding them helps you evaluate inference services and diagnose latency/cost problems.

---

## Understanding Inference Optimization

### Inference Overview

**Inference** = using a trained model to compute an output for a given input.

In production, this is handled by an **inference server** — a component that hosts models and executes them on request. The broader **inference service** handles receiving, routing, and preprocessing requests before they reach the inference server.

![Diagram showing an inference service: user sends a request → load balancer/router → inference server (with GPU/model) → response back to user](../images/aien_0901.png)
###### Figure 9-1. A simple inference service.

If you use a commercial API (OpenAI, Anthropic, Google), they run the inference service. If you **self-host** models, you build and maintain it yourself.

### Computational Bottlenecks

Before optimizing, identify *what* is slowing you down. Two fundamental bottlenecks:

| Bottleneck | What limits speed | Example |
|---|---|---|
| **Compute-bound** | Number of arithmetic operations the chip can execute | Password decryption; matrix multiplication with large matrices |
| **Memory bandwidth-bound** | Rate at which data moves between memory and processors | Loading large model weights from memory into compute units |

**Roofline chart** — a tool to identify which bottleneck you're hitting:

![Log-scale graph showing the roofline model: a flat ceiling (memory bandwidth) and a sloped ceiling (peak compute). Points below the memory bandwidth ceiling are bandwidth-bound; points below the compute ceiling are compute-bound](../images/aien_0902.png)
###### Figure 9-2. The roofline chart visualizes whether an operation is compute-bound or memory bandwidth-bound.

**For language models (transformer-based), inference has two distinct phases:**

| Phase | What happens | Bottleneck |
|---|---|---|
| **Prefill** | All input tokens are processed simultaneously | Compute-bound (parallel operations fill the chip) |
| **Decode** | One output token is generated at a time | Memory bandwidth-bound (loads huge model weights per token) |

![Diagram showing LLM inference: prefill stage processes all input tokens in parallel; decode stage generates one output token at a time, feeding each new token back in for the next](../images/aien_0903.png)
###### Figure 9-3. Autoregressive language models follow two steps: prefill and decode.

Because prefill and decode have different profiles, modern production systems often run them on **separate machines** (discussed later).

### Online and Batch Inference APIs

| Type | Optimizes for | Best for |
|---|---|---|
| **Online API** | Low latency — processes requests immediately | Chatbots, code completion, real-time decisions |
| **Batch API** | Low cost — groups requests for efficient processing | Data pipelines, document indexing, report generation |

**Batch API examples (as of writing):** Google Gemini and OpenAI both offer 50% cost reduction with batch APIs in exchange for hours of turnaround instead of seconds.

**Batch use cases:**
- Synthetic data generation
- Summarizing Slack messages or customer support tickets
- Processing newly uploaded documents at customer onboarding
- Reindexing a knowledge base after a model upgrade
- Generating personalized newsletters

**Streaming mode:** Instead of waiting for the full response, online APIs can stream tokens as they're generated. This reduces the perceived wait time (users see the first token faster) but means you can't pre-screen the response before it's shown.

> ⚠️ **Foundation model batch APIs differ from traditional ML batch inference.** In traditional ML, batch inference means *precomputing* predictions before requests arrive. With foundation models, user prompts are open-ended and can't be predicted in advance — batch mode just means *scheduling* requests for efficient processing during off-peak hours.

---

## Inference Performance Metrics

### Latency, TTFT, and TPOT

For autoregressive generation (streaming mode), overall latency breaks down into:

| Metric | What it measures | Notes |
|---|---|---|
| **TTFT** (Time to First Token) | Time from sending query to receiving first token | Determined by prefill duration; depends on input length |
| **TPOT** (Time Per Output Token) | Time between each subsequent output token | Determined by decode speed |
| **TBT / ITL** (Time Between Tokens / Inter-Token Latency) | Variation of TPOT | Used by LinkedIn (TBT) and NVIDIA (ITL) |

**Total latency formula:**
```
Total latency = TTFT + TPOT × (number of output tokens)
```

**What counts as "fast enough" for TPOT?**  
A fast human reader processes about 120 ms/token (6–8 tokens/second). Streaming at that speed feels natural. Much faster is wasted; much slower feels choppy.

> **CoT and agents complicate TTFT:** If a model generates a hidden plan or intermediate reasoning steps before producing the user-visible response, the model's internal TTFT is much earlier than the user-perceived TTFT. Some teams track **"time to publish"** — the time to the first *visible* token.

**Percentile reporting (don't use averages):**

Imagine 10 requests with TTFT values: 100, 102, 100, 100, 99, 104, 110, 90, 3000, 95 ms.  
Average = **390 ms** — misleadingly high due to one outlier.

Report latency as **p50, p90, p95, p99** to understand normal behavior and catch outliers separately.

### Throughput and Goodput

**Throughput** = number of output tokens generated per second across all users.

Common units:
- **TPS** (tokens/second) — total output throughput
- **TPS/user** — scales with concurrent users
- **RPS** (requests/second) or **RPM** (requests/minute) — request-level throughput

**Throughput = cost.** Example calculation:
- Hardware cost: $2/hour
- Throughput: 100 tokens/s = 360,000 tokens/hour
- Cost per 1M output tokens: `$2 / 0.36 ≈ $5.56`
- If each request generates 200 tokens: 1,000 requests cost `$1.11`

There is always a **latency/throughput tradeoff**: techniques like batching improve throughput but increase latency. LinkedIn found it's common to 2–3× throughput by accepting higher TTFT and TPOT.

**Goodput** (adapted from networking): The number of requests per second that satisfies your **SLO (Service Level Objective)**.

Example SLO: TTFT ≤ 200 ms AND TPOT ≤ 100 ms.

![Bar chart showing throughput (10 RPS processed) vs goodput (3 RPS actually meeting SLO requirements, shown with different color)](../images/aien_0904.png)
###### Figure 9-4. If 10 RPS are completed but only 3 meet the SLO, goodput is 3 RPS.

Goodput is the metric that truly matters for user experience — raw throughput is meaningless if most responses are too slow.

### Utilization: MFU and MBU

**NVIDIA `nvidia-smi` GPU utilization** = % of time the GPU is doing *any* work.  
This is **misleading** — a GPU doing one operation per second can report 100% utilization even if it's capable of 100 operations per second.

**MFU (Model FLOP/s Utilization)** = actual throughput / theoretical peak throughput  

> If a chip can theoretically generate 100 tokens/s at peak FLOP/s but achieves only 20 tokens/s → MFU = 20%

**MBU (Model Bandwidth Utilization)** = memory bandwidth actually used / theoretical peak bandwidth

**MBU formula:**
```
MBU = (parameter count × bytes/param × tokens/s) / theoretical bandwidth
```

**Example:** 7B-parameter model in FP16 (2 bytes/param), 100 tokens/s on an A100 (2 TB/s peak):
```
Bandwidth used = 7B × 2 × 100 = 700 GB/s
MBU = 700 GB/s / 2 TB/s = 35%
```

**Table 9-1: MFU examples from PaLM paper (Chowdhery et al., 2022)**

| Model | Parameters | Accelerator | MFU |
|---|---|---|---|
| GPT-3 | 175B | V100 | 21.3% |
| Gopher | 280B | 4096 TPU v3 | 32.5% |
| Megatron-Turing NLG | 530B | 2240 A100 | 30.2% |
| PaLM | 540B | 6144 TPU v4 | 46.2% |

> MFU above 50% is considered good for training. For inference, decode is typically low MFU (bandwidth-bound) while prefill has higher MFU (compute-bound).

![Graph showing MBU for Llama 2-70B across three chips: MBU decreases as the number of concurrent users increases, reflecting the shift from bandwidth-bound to compute-bound](../images/aien_0905.png)
###### Figure 9-5. MBU for Llama 2-70B decreases as more users are served concurrently (workload shifts from bandwidth-bound to compute-bound).

> **Goal is not highest utilization** — it's lowest cost and latency. High utilization on slow hardware beats low utilization on fast hardware only if the end result is faster and cheaper.

---

## AI Accelerators

### What Is an Accelerator?

An **accelerator** is a chip designed to speed up a specific type of computation. An **AI accelerator** is designed for AI workloads.

**CPU vs. GPU:**

| CPU | GPU |
|---|---|
| Few powerful cores (up to ~64) | Thousands of smaller cores |
| Great for sequential, complex tasks | Great for highly parallel tasks |
| Runs operating system, I/O, logic | Runs matrix multiplication, ML training/inference |

The GPU's dominance in AI traces back to **AlexNet (2012)** — the first paper to successfully train a neural network on GPUs. Before that, the same job required thousands of CPUs.

**Other AI accelerators:**
- **TPU** (Tensor Processing Unit) — Google's custom chip, designed for tensor operations
- **Intel Habana Gaudi** — inference/training chip
- **AWS Inferentia** — inference-specialized chip
- **Groq LPU** (Language Processing Unit) — very fast inference
- **Cerebras** — wafer-scale chip
- **Apple Neural Engine** — on-device inference
- **NVIDIA Jetson Xavier** — edge inference

### Computational Capabilities

Measured in **FLOP/s** (floating-point operations per second). Higher = more powerful.

**Table 9-2: NVIDIA H100 SXM FLOP/s specs**

| Format | teraFLOP/s (with sparsity) |
|---|---|
| TF32 Tensor Core | 989 |
| BF16 Tensor Core | 1,979 |
| FP16 Tensor Core | 1,979 |
| FP8 Tensor Core | 3,958 |

Lower precision → more operations per second → lower latency (when accuracy is acceptable).

### Memory Size and Bandwidth

GPUs need to move huge amounts of data quickly between memory and compute units. This requires specialized, fast memory.

**Three memory levels for a GPU:**

![Pyramid diagram showing three memory tiers: GPU SRAM at the top (fastest, smallest), GPU HBM in the middle, CPU DRAM at the bottom (slowest, largest)](../images/aien_0907.png)
###### Figure 9-7. The memory hierarchy of an AI accelerator.

| Memory | Location | Bandwidth | Size | Notes |
|---|---|---|---|---|
| **CPU DRAM** | System RAM | 25–50 GB/s | 16 GB – 1+ TB | Cheap, large, slow |
| **GPU HBM** (High-Bandwidth Memory) | On GPU | 256 GB/s – 1.5+ TB/s | 24–80 GB (consumer) | Fast; holds model weights during inference |
| **GPU SRAM** (on-chip cache) | Inside chip | 10+ TB/s | ~40 MB | Extremely fast; used for KV vectors and active computations |

> Most GPU optimization is about efficiently moving data through these three levels. Fine-grained control requires GPU programming languages: **CUDA** (NVIDIA), **Triton** (OpenAI), **ROCm** (AMD).

Different compute units are optimized for different data structures:

![Diagram showing scalar, vector, and tensor compute primitives alongside the type of operations each handles](../images/aien_0906.png)
###### Figure 9-6. Different compute primitives: scalar, vector, and tensor.

Modern GPUs include **tensor cores** optimized for matrix operations. TPUs are designed with tensor operations as their primary compute primitive.

### Power Consumption

Chips are power-hungry. An **NVIDIA H100** running at peak for a year consumes **~7,000 kWh** — equivalent to 70% of an average US household's annual electricity use.

**Key metrics:**
- **Maximum power draw** — peak power under full load
- **TDP (Thermal Design Power)** — heat the cooling system must dissipate; ~67–91% of max power draw

Energy consumption has become a major environmental concern and a bottleneck for scaling AI infrastructure. Electricity supply limits where large data centers can be built.

---

## Inference Optimization Techniques

> Different inference providers use different optimization techniques, causing the same model to produce slightly different outputs on different services:

![Bar chart comparing Llama model benchmark scores across different inference providers — slight quality differences emerge from different optimization choices](../images/aien_0908.png)
###### Figure 9-8. Optimization techniques can slightly alter a model's behavior. Different providers serving the same model may produce different quality results.

---

## Model Optimization

### Model Compression

Smaller models are faster and cheaper. Three approaches:

| Technique | What it does | Where covered |
|---|---|---|
| **Quantization** | Reduce bits per value (FP32 → INT8 → INT4) | Chapter 7 |
| **Distillation** | Train small model to mimic large model | Chapter 8 |
| **Pruning** | Remove or zero out less important parameters | This chapter |

**Pruning:**
- **Structural pruning:** Remove entire nodes/layers → smaller architecture, fewer parameters
- **Weight pruning:** Set least-important weights to zero → sparse model (doesn't reduce parameter count, but saves storage and speeds up sparse computation)

Pruning can reduce non-zero parameter counts by over 90% without accuracy loss (Frankle & Carlin, 2019). However, in practice:
- Requires deep knowledge of the model's architecture
- Not all hardware can exploit sparsity efficiently
- Quantization is much easier and often more impactful

> **Most impactful compression:** Weight-only quantization — easy, widely supported, cuts memory in half by going from FP32 to FP16.

---

### Overcoming the Autoregressive Decoding Bottleneck

Autoregressive decoding generates one token at a time. If each token takes 100 ms, 100 tokens = 10 seconds. Output tokens cost 2–4× more than input tokens.

Three approaches to speed this up:

#### Speculative Decoding

Use a **fast, small draft model** to generate a batch of tokens, then have the **target (large) model verify them in parallel**.

**Steps:**
1. Draft model generates K tokens quickly
2. Target model verifies all K tokens *simultaneously* (parallel = fast)
3. Target model accepts the longest consistent prefix from the draft
4. Target model generates one extra token
5. Repeat

![Diagram showing draft model generating 4 tokens, target model accepting the first 3, rejecting the 4th, and generating a corrected token](../images/aien_0909.png)
###### Figure 9-9. A draft model proposes tokens; the target model accepts the longest agreeable subsequence. Image from Stern et al. (2018).

**Why this works:**
1. Verifying is faster than generating (parallel vs. sequential)
2. Some tokens are easy to predict — a weak draft model gets them right
3. Decoding is memory bandwidth-bound, leaving idle compute for free verification

**Result (DeepMind, Chinchilla-70B):** A 4B draft model that generates tokens 8× faster → overall response latency **cut in half**, with no quality change.

**Acceptance rate** is domain-dependent — code (structured text) has higher acceptance rates than open-ended prose.

#### Inference With Reference

Instead of using a draft *model*, copy tokens directly from the **input context** when the output overlaps.

**Example use cases:**
- RAG responses that quote source documents verbatim
- Bug fixing that returns mostly unchanged code
- Multi-turn conversations that repeat earlier content

No extra model needed — just an algorithm to find matching text spans. Can achieve **2× speedup** in such scenarios (Yang et al., 2023).

![Screenshot showing two examples: a document retrieval response where large chunks are copied from the source (highlighted in red/green), and a code debugging response where most code is reused](../images/aien_0910.png)
###### Figure 9-10. Inference with reference copies matching text spans from the input. Image from Yang et al. (2023).

#### Parallel Decoding

Instead of making speculation faster, **break the sequential dependency** entirely — generate multiple future tokens simultaneously.

**Lookahead decoding (Fu et al., 2024):** Generates K future tokens in parallel from the same decoder, then uses the Jacobi iterative method to verify they're consistent.

**Medusa (Cai et al., 2024):** Adds multiple **extra decoding "heads"** to the model:
- Head 1 predicts token t+2
- Head 2 predicts token t+3
- Head k predicts token t+k+1

All heads run in parallel. Outputs are organized into a tree, and the most consistent path is selected:

![Diagram showing the original decoder plus 4 Medusa heads generating multiple options at each future position. The options form a tree; the most likely consistent sequence is selected via tree-based attention](../images/aien_0911.png)
###### Figure 9-11. Medusa predicts multiple future token positions simultaneously, selects the best path. Image from Cai et al. (2024).

**NVIDIA result:** Medusa boosted Llama 3.1 token generation by up to **1.9×** on H200 GPUs.

---

### Attention Mechanism Optimization

Recall from Chapter 2: generating token x_t+1 requires key-value vectors for *all* previous tokens x_1, x_2, ..., x_t. This creates two problems:
1. Attention computation grows **quadratically** with sequence length: O(n²)
2. Key-value storage grows **linearly** with sequence length

#### The KV Cache

Instead of recomputing key-value vectors for previous tokens at every step, **store them** and reuse them:

![Diagram showing the KV cache growing with each new token: old key-value pairs are retained; only the newest token's vectors need to be computed](../images/aien_0912.png)
###### Figure 9-12. The KV cache stores key-value vectors to avoid recomputation at each decode step.

**KV cache size formula:**
```
2 × B × S × L × H × M

where:
  B = batch size
  S = sequence length
  L = number of transformer layers
  H = model dimension
  M = bytes per value (e.g., 2 for FP16)
```

**Example (Llama 2-13B, batch=32, seq=2048, FP16):**
```
2 × 32 × 2,048 × 40 × 5,120 × 2 = 54 GB
```

That's 54 GB just for the KV cache — more than the model's weights themselves for large batches.

A Google paper found: for a 500B+ model with batch size 512 and context 2048, the KV cache was **3 TB — three times the model's weight size**.

#### Redesigning the Attention Mechanism

These changes require modifying the model during training:

| Technique | How it works | Effect |
|---|---|---|
| **Local windowed attention** | Attend only to nearby tokens (e.g., last 1,000 of 10,000) | Reduces KV cache linearly with window ratio |
| **Multi-query attention** (Shazeer, 2019) | Share one set of K-V vectors across all attention heads | Reduces KV cache by number of heads |
| **Cross-layer attention** (Brandon et al., 2024) | Share K-V vectors across adjacent layers | Reduces KV cache proportionally to sharing groups |
| **Grouped-query attention** (Ainslie et al., 2023) | Share K-V vectors within groups of query heads | Flexible balance between multi-head and multi-query |

**Character.AI result:** Average conversation is 180 messages (very long context). Using multi-query attention + local/global interleaving + cross-layer attention → **KV cache reduced by 20×** → memory no longer a bottleneck for large batch sizes.

#### Optimizing KV Cache Management

**PagedAttention (vLLM):** Divides the KV cache into non-contiguous memory blocks (like OS virtual memory paging). Reduces fragmentation, enables flexible memory sharing across requests, and allows larger effective batch sizes. vLLM is one of the most popular open source LLM inference frameworks, gaining traction largely because of this innovation.

Other techniques: KV cache quantization, adaptive compression, selective KV cache (only retain the most important K-V pairs).

#### FlashAttention — Kernel for Attention Computation

FlashAttention (Dao et al., 2022) is a hand-optimized GPU kernel that **fuses** multiple attention operations together to avoid repeatedly reading/writing to slow GPU HBM:

![Graph showing FlashAttention kernel combining multiple attention operations into one pass, compared to the standard approach that does separate read/write operations for each step](../images/aien_0913.png)
###### Figure 9-13. FlashAttention fuses multiple attention operators into a single efficient kernel.

FlashAttention-3 was introduced for H100 GPUs. FlashAttention is now standard in most production inference frameworks.

---

### Kernels and Compilers

**Kernels** are low-level code written for specific hardware to maximize performance. Common AI operations (matrix multiplication, attention, convolution) all have specialized kernels.

Kernel writing requires knowledge of:
- The hardware's memory hierarchy
- Thread management and data movement patterns
- Lower-level languages (CUDA, Triton, ROCm)

**Four core kernel optimization techniques:**

| Technique | What it does |
|---|---|
| **Vectorization** | Process multiple contiguous data elements simultaneously instead of one at a time |
| **Parallelization** | Split input into independent chunks processed simultaneously on different cores |
| **Loop tiling** | Reorder data access patterns to match the hardware's cache layout |
| **Operator fusion** | Combine multiple operations into one pass to reduce memory reads/writes |

**Compilers** automatically convert model code into hardware-compatible kernels during a process called **lowering**:

| Compiler | Notes |
|---|---|
| `torch.compile` | Built into PyTorch |
| **Apache TVM** | Open source, supports many hardware targets |
| **XLA / OpenXLA** | Originally from TensorFlow; Google's approach |
| **TensorRT** | NVIDIA GPU-specific; highly optimized |

#### Case Study: PyTorch Inference Optimization for Llama-7B

![Bar chart showing Llama-7B throughput increasing step by step: baseline → torch.compile → INT8 quantization → INT4 quantization → speculative decoding, each step increasing tokens/s significantly](../images/aien_0914.png)
###### Figure 9-14. Throughput improvement on Llama-7B through progressive optimization. Image from PyTorch (2023).

Steps applied on A100 (80 GB):
1. `torch.compile` → model compiled into efficient kernels
2. Quantize weights to INT8
3. Quantize weights to INT4
4. Add speculative decoding

Each step adds meaningful throughput improvement. Note: quality impact was not measured in this experiment.

---

## Inference Service Optimization

Service-level techniques manage **resources** (compute and memory) dynamically to serve concurrent users efficiently. Unlike model-level techniques, these **do not modify the model** and don't change output quality.

### Batching

Running multiple requests together in one forward pass is far more efficient than running them one by one.

> **Analogy:** Individual processing = everyone drives their own car. Batching = a bus. A bus moves more people per unit of energy — but a bus might make each person wait a little longer.

**Three batching strategies:**

**Static batching:** Wait until exactly N requests arrive, then process them all together.
- Pro: Simple to implement
- Con: Early requests must wait for the last one to arrive — can cause unnecessary latency

**Dynamic batching:** Process when N requests arrive OR when a time window (e.g., 100 ms) expires — whichever comes first.
- Pro: Limits latency (requests aren't held indefinitely)
- Con: Batches may not always be full → wasted compute

![Two diagrams comparing static batching (waits for batch to fill) vs dynamic batching (processes at a time limit even if batch isn't full)](../images/aien_0915.png)
###### Figure 9-15. Dynamic batching keeps latency manageable but may not always fill the batch.

**Continuous batching (in-flight batching):** Responses are returned as soon as they complete — the server doesn't wait for the longest response to finish before returning shorter ones. As each completed request leaves the batch, a new request takes its place.

![Diagram showing a batch with four slots: as each request completes, it exits the batch and a new request enters — the batch is always full](../images/aien_0916.png)
###### Figure 9-16. Continuous batching returns completed responses immediately and fills the slot with a new request.

> Without continuous batching: if one request generates 1,000 tokens and another generates 10 tokens, the 10-token response waits until the 1,000-token response finishes. With continuous batching, the short response returns immediately.

Continuous batching (introduced by the Orca paper, Yu et al., 2022) is standard in modern production LLM serving.

---

### Decoupling Prefill and Decode

Because prefill is **compute-bound** and decode is **memory bandwidth-bound**, running both on the same GPU causes them to compete for different resources inefficiently.

Adding a new query to a GPU already handling many decode jobs forces a prefill phase, which drains compute resources from the ongoing decodes → **TPOT gets worse for all ongoing requests**.

**Solution (DistServe, Hu et al., 2024):** Route prefill and decode to **separate machines**.
- **Prefill instances** → compute-optimized GPUs
- **Decode instances** → memory-bandwidth-optimized GPUs
- Intermediate states (KV vectors) transferred between instances over NVLink (high-bandwidth GPU-to-GPU interconnect within a node)

**Typical prefill:decode instance ratios:**

| Workload | Priority | Ratio (P:D) |
|---|---|---|
| Long input sequences | Lower TTFT | 2:1 to 4:1 |
| Short inputs, fast decoding | Lower TPOT | 1:2 to 1:1 |

---

### Prompt Caching

Many applications send the same long text repeatedly in every prompt — especially the **system prompt**.

**Without caching:** Every request reprocesses the system prompt.  
**With caching:** System prompt is processed once; subsequent requests reuse cached intermediate states (KV vectors).

![Diagram showing two requests with the same long system prompt: the system prompt is processed once, cached, and reused for the second request; only the unique part is newly processed](../images/aien_0917.png)
###### Figure 9-17. Prompt caching reuses overlapping segments across requests.

**When prompt caching helps most:**
- Long system prompts (e.g., instructions for a legal assistant or customer service bot)
- Many queries about the same long document (book, codebase)
- Multi-turn conversations (previous turns cached and reused)

**Savings example:** 1,000-token system prompt × 1 million daily API calls = **1 billion redundant input tokens per day** saved.

**Table 9-3: Prompt caching impact (Anthropic, 2024)**

| Use case | TTFT without cache | TTFT with cache | Cost reduction |
|---|---|---|---|
| Chat with a 100K-token book | 11.5 s | 2.4 s (−79%) | −90% |
| Many-shot prompting (10K prompt) | 1.6 s | 1.1 s (−31%) | −86% |
| 10-turn conversation with long system prompt | ~10 s | ~2.5 s (−75%) | −53% |

**Provider offerings:**
- **Google Gemini:** Cached tokens at 75% discount; cache storage costs $1.00/1M tokens/hour
- **Anthropic:** Up to 90% cost savings + up to 75% latency reduction for long cached contexts

---

### Parallelism

When a single machine isn't enough — either because the model is too large to fit, or because you need more throughput — you scale across multiple machines.

**Replica parallelism:** Create multiple identical copies of the model, each serving a subset of requests. Simplest approach; directly increases throughput. More replicas = more hardware cost, but each replica handles fewer requests → lower latency per user.

**Model parallelism:** Split a model that's too large for one machine across multiple machines.

**Tensor parallelism (intra-operator parallelism):** Split individual matrix operations across multiple chips — each chip handles part of a matrix multiplication simultaneously:

![Diagram showing a matrix split column-wise across two GPUs, with each GPU computing its portion of the matrix multiplication independently then combining results](../images/aien_0918.png)
###### Figure 9-18. Tensor parallelism splits matrix operations across multiple devices.

Benefits: enables serving models too large for a single chip; reduces latency. Drawback: communication overhead between chips.

**Pipeline parallelism:** Assign different *layers* of the model to different machines. As data flows through, each machine processes its layers while others handle subsequent layers in parallel:

![Diagram showing a 4-layer model split across 4 GPUs. Micro-batch 1 flows through GPU1 → GPU2 → GPU3 → GPU4 while GPU1 is already processing micro-batch 2](../images/aien_0919.png)
###### Figure 9-19. Pipeline parallelism assigns different layers to different machines, processed in overlapping stages.

Pipeline parallelism increases throughput but adds inter-stage communication latency. Preferred for training; less common for latency-sensitive inference.

**Context parallelism:** The input sequence itself is split across machines — machine 1 handles the first half of the input, machine 2 handles the second half. Useful for very long sequences.

**Sequence parallelism:** Different operations on the full sequence (attention vs. feedforward) are split across machines.

---

## Summary

Inference optimization is about making AI models **faster** and **cheaper** without necessarily making them smarter.

**Key metrics and what they tell you:**

| Metric | Tells you |
|---|---|
| **TTFT** | How quickly the first token appears — driven by prefill speed |
| **TPOT** | How fast tokens stream — driven by decode speed |
| **Throughput (TPS)** | How much compute you're getting — directly linked to cost |
| **Goodput** | How many requests actually meet your SLO |
| **MFU** | How efficiently you're using your chip's compute |
| **MBU** | How efficiently you're using your chip's memory bandwidth |

**Most impactful techniques across use cases:**

| Technique | Impact | Level |
|---|---|---|
| **Quantization** | Halves memory per bit reduction; works on most models | Model |
| **Tensor parallelism** | Enables large models; reduces latency | Service |
| **Replica parallelism** | Easy throughput scaling | Service |
| **Attention mechanism optimization** (KV cache, FlashAttention) | Critical for transformer models, especially long context | Model |
| **Continuous batching** | Maximizes GPU utilization without hurting latency | Service |
| **Prompt caching** | Massive savings for apps with overlapping prompts | Service |
| **Speculative decoding** | Reduces autoregressive decoding latency without quality loss | Model |

**Choosing techniques by workload:**

| If your bottleneck is… | Try… |
|---|---|
| Long contexts filling GPU memory | KV cache optimization, grouped-query attention, PagedAttention |
| Repeated long system prompts | Prompt caching |
| Slow decode speed | Speculative decoding, parallel decoding |
| Large model not fitting on one GPU | Tensor parallelism, pipeline parallelism |
| High cost, flexible latency | Batch API, dynamic batching, quantization |
| High traffic, need lower latency | Replica parallelism, continuous batching, prefill/decode decoupling |

The next chapter covers how to integrate all these components — models, prompting, RAG, finetuning, and inference — into a cohesive production system.
