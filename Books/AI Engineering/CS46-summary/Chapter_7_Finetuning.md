# Chapter 7: Finetuning

---

## Overview

Finetuning is the process of **adapting a model to a specific task by further training the whole model or part of it**. While Chapters 5 and 6 covered prompt-based methods (which adapt a model through inputs), finetuning adapts a model by **adjusting its weights** — the internal numerical values learned during training.

Finetuning can:
- Improve domain-specific capabilities (coding, medical Q&A, legal documents)
- Strengthen safety
- Make models follow specific output formats (JSON, YAML)
- Mitigate biases in the base model

However, finetuning requires more up-front investment than prompting — more data, more hardware, and ML expertise.

> This is the most technically challenging chapter in the book. If any section feels too deep for your immediate needs, feel free to skim.

---

## Finetuning Overview

### What Is Transfer Learning?

Finetuning is one form of **transfer learning** — the idea that knowledge gained from one task can accelerate learning for a related task.

**Human analogy:** Playing piano makes it easier to learn guitar. Pre-existing skills transfer.

**Early ML success:** Google's multilingual translation (2016) transferred knowledge from Portuguese→English and English→Spanish to translate Portuguese→Spanish directly, with no Portuguese-Spanish training data.

For LLMs, knowledge from pre-training on text completion (abundant data) transfers to specialized tasks like legal Q&A or SQL generation (scarce data). Transfer learning improves **sample efficiency** — the model learns the same behavior from far fewer examples.

> OpenAI's InstructGPT (2022) suggests viewing finetuning as "unlocking capabilities a model already has but that are difficult for users to access via prompting alone."

### Types of Finetuning

| Type | What it does | When to use |
|---|---|---|
| **Continued pre-training** | Self-supervised finetuning on raw domain text | Before annotation-based finetuning; cheap |
| **Supervised finetuning (SFT)** | Uses (input, output) pairs to teach the model to follow instructions | Most common finetuning type |
| **Preference finetuning** | Uses (instruction, winning response, losing response) to align with human preferences | After SFT, for alignment |
| **Long-context finetuning** | Modifies positional embeddings to handle longer sequences | When you need a larger context window |
| **Infilling finetuning** | Trains to fill in blanks rather than predict next tokens | Useful for text editing, code debugging |

### The Code Llama Example

![Diagram showing how different finetuning techniques were applied to Llama 2 to produce different Code Llama model variants](../images/aien_0701.png)
###### Figure 7-1. Different finetuning techniques used to make different Code Llama models. Image from Rozière et al. (2024).

Starting from Llama 2, long-context finetuning expanded the maximum context from 4,096 to 16,384 tokens (to handle longer code files), then supervised finetuning created instruction-following variants.

---

## When to Finetune

### Reasons to Finetune

1. **Quality improvement:** A general model good at many benchmarks might fail at your specific task.
   - Example: A model good at standard SQL might fail at your company's custom SQL dialect. Finetuning on that dialect fixes it.

2. **Bias mitigation:** If the base model has biases, carefully curated finetuning data can counteract them.
   - Example: If a model always assigns male-sounding names to CEOs, finetuning on a dataset with female CEOs can mitigate this.

3. **Smaller models for specialized tasks:** Finetuning a small model to imitate a large model is called **distillation**. Grammarly's finetuned Flan-T5 (using only 82,000 examples) outperformed GPT-3 on writing tasks despite being 60× smaller.

4. **Reduced token costs:** Instead of including many few-shot examples in every prompt (increasing token costs), finetune the model on those examples once:

![Diagram comparing a long prompt with many examples (more tokens, higher cost) versus a short prompt to a finetuned model (same quality, fewer tokens)](../images/aien_0702.png)
###### Figure 7-2. Instead of including examples in each prompt, you finetune a model on these examples.

> With **prompt caching** (Chapter 9), this cost benefit is reduced. But finetuning still removes the limit on how many examples you can use (context window limits few-shot examples).

### Reasons NOT to Finetune

**1. Finetuning for one task can hurt performance on others.**

Imagine you finetune a model specifically for "change order" queries. It may get better at that — but worse at product recommendations and general feedback. You'd then need to finetune on *all* your tasks, not just one.

**2. High up-front investment:**
- You need annotated data (slow and expensive to create)
- You need ML expertise (training knobs, optimizer settings, overfitting detection)
- You need to decide how to serve the finetuned model (host it yourself or use an API)

**3. Maintenance burden:**
- New, stronger base models are released constantly
- Deciding when to switch to a new base model is a recurring business decision

> **Practitioner war story:** Many engineers claim "prompting doesn't work, we need finetuning." Upon investigation: instructions were unclear, examples didn't represent real data, metrics were poorly defined. After fixing the prompts — no finetuning needed.

**Rule of thumb:** Only consider finetuning after exhaustive prompting experiments.

---

## Finetuning Domain-Specific Tasks

Beware the assumption that general models can't do domain-specific work. As general models become more capable, they often outperform specialized domain models.

**BloombergGPT case study:**

Bloomberg built a 50B-parameter financial LLM (BloombergGPT) in March 2023, costing $1.3–$2.6 million in compute alone. In the same month, OpenAI released GPT-4.

**Table 7-1: GPT-4 outperforms BloombergGPT on financial benchmarks**

| Model | FiQA Sentiment Analysis (F1) | ConvFinQA (Accuracy) |
|---|---|---|
| GPT-4-0314 (zero-shot) | **87.15** | **76.48** |
| BloombergGPT | 75.07 | 43.41 |

Lesson: Domain-specific finetuning is most valuable when general models are still weak or when you have privacy requirements that prevent use of commercial APIs.

---

## Finetuning and RAG

After maxing out prompt engineering, practitioners often ask: **should I do RAG or finetuning next?**

The answer depends on whether your failures are **information-based** or **behavior-based**.

| Problem type | Cause | Solution |
|---|---|---|
| **Information failures** | Model lacks facts, has outdated info, hallucinate | RAG |
| **Behavioral failures** | Output is factually fine but wrong format/style/depth | Finetuning |

> **Key principle: RAG is for facts. Finetuning is for form.**

**Research evidence (Ovadia et al., 2024):**

For a Q&A task about current events:

**Table 7-2: RAG vs. finetuning on current events Q&A**

|  | Base model | Base model + RAG | FT-reg | FT-par | FT-reg + RAG | FT-par + RAG |
|---|---|---|---|---|---|---|
| Mistral-7B | 0.481 | **0.875** | 0.504 | 0.588 | 0.810 | 0.830 |
| Llama 2-7B | 0.353 | **0.585** | 0.219 | 0.392 | 0.326 | 0.520 |
| Orca 2-7B | 0.456 | **0.876** | 0.511 | 0.566 | 0.820 | 0.826 |

Key findings:
- RAG with the base model outperforms finetuning alone for information-based tasks
- Finetuning can actually *hurt* RAG performance (compare FT-reg+RAG vs base+RAG)
- RAG+finetuning combinations boost performance only 43% of the time

**RAG and finetuning are not mutually exclusive** — for complex applications, you may eventually use both.

### Application Development Workflow

![Flowchart showing the development path from prompting → RAG → finetuning, with branches depending on failure types](../images/aien_0703.png)
###### Figure 7-3. Example application development flows. The path depends on your failure modes.

**Recommended workflow:**

1. **Prompt only** — use best practices from Chapter 5 (clear instructions, examples, output format)
2. **Add more examples** — 1 to 50 examples depending on the task
3. **Add RAG** — if model fails due to missing information; start with simple term-based retrieval (BM25)
4. **Decide next step based on remaining failures:**
   - Still information failures → try more advanced RAG (embedding-based, hybrid)
   - Behavioral failures → try finetuning
5. **Combine RAG + finetuning** for maximum performance

---

## Memory Bottlenecks

Finetuning large models is **memory-intensive**. Many finetuning techniques exist primarily to reduce memory usage.

### Key Takeaways (Read If You Skip This Section)

1. Memory is the main bottleneck for both inference and finetuning at scale
2. Finetuning needs **much more** memory than inference
3. Key contributors: number of parameters, number of *trainable* parameters, and numerical format
4. Reducing trainable parameters reduces memory → this is the motivation for **PEFT**
5. **Quantization** converts values to fewer bits, directly reducing memory footprint
6. Inference is done at low precision (16-, 8-, or 4-bit); training uses **mixed precision**

### Backpropagation and Trainable Parameters

Training uses an algorithm called **backpropagation** (backprop). Each training step has two phases:

**Forward pass:** Compute output from input (same as inference)

**Backward pass:** Update model weights using these steps:
1. Compare computed output to the correct answer → compute **loss** (the error)
2. Compute how much each parameter contributed to the error → **gradient** (one gradient per trainable parameter)
3. Use an **optimizer** to adjust each parameter based on its gradient

![Diagram showing the forward pass (left to right through a network) and the backward pass (right to left, propagating gradients to update weights)](../images/aien_0704.png)
###### Figure 7-4. The forward and backward pass of a simple neural network.

**Why training uses more memory than inference:**
- Inference: only forward pass → only model weights in memory
- Training: forward + backward → weights + activations + **gradients** + **optimizer states**

**Optimizer memory per trainable parameter:**

| Optimizer | Extra memory per trainable parameter |
|---|---|
| SGD (vanilla) | 0 values |
| Momentum SGD | 1 value |
| Adam (most common for transformers) | 2 values |

**Example:** For a 13B-parameter model, full finetuning with Adam:
- Gradients + optimizer states = 13B × 3 values × 2 bytes = **78 GB** (just for gradients and states!)
- If only 1B parameters are trainable: 1B × 3 × 2 bytes = **6 GB**

**Activations are often even larger:**

![Graph showing activation memory growing to dwarf model weights memory at scale for different Megatron models](../images/aien_0705.png)
###### Figure 7-5. The memory needed for activations can dwarf the memory needed for model weights.

**Gradient checkpointing (activation recomputation):** Instead of storing activations (to reuse in the backward pass), recompute them on demand. Saves memory but increases compute time.

### Memory Math

**Inference memory:**
```
N × M × 1.2

where:
  N = number of parameters
  M = bytes per parameter
  1.2 accounts for activations and KV cache (~20% extra)
```

**Example:** 13B parameters × 2 bytes × 1.2 = **31.2 GB**

**Training memory:**
```
Training memory = weights + activations + gradients + optimizer states
```

**Full finetuning example (7B model, Adam optimizer, 16-bit):**
- Weights: 7B × 2 bytes = **14 GB**
- Gradients + optimizer states: 7B × 3 × 2 bytes = **42 GB**
- Total (without activations): **56 GB**

56 GB exceeds most consumer GPUs (12–24 GB). This is why memory reduction is so important.

### Numerical Representations

The number of bits used to represent each value directly controls memory usage.

**The FP family (IEEE standard):**

| Format | Bits | Bytes | Common name |
|---|---|---|---|
| FP64 | 64 | 8 | Double precision |
| FP32 | 32 | 4 | Single precision |
| FP16 | 16 | 2 | Half precision |
| BF16 | 16 | 2 | BFloat16 (Google, more range) |
| TF32 | 19 | — | TensorFloat-32 (NVIDIA) |

**Integer formats:** INT8 (8 bits), INT4 (4 bits)

**Range vs. Precision tradeoff:**
- More **range** bits → can represent larger numbers
- More **precision** bits → numbers are more accurate

![Diagram showing different float formats (FP32, FP16, BF16, TF32) with their bit allocations for sign, exponent (range), and mantissa (precision)](../images/aien_0706.png)
###### Figure 7-6. Different numerical formats with their range and precision.

**Table 7-3: How FP32 values convert to lower-precision formats (inaccuracies in italics)**

| FP32 | FP16 | BF16 | TF32 |
|---|---|---|---|
| 0.0123456789 | 0.01234*43603515625* | 0.0123*291* | 0.01234*43603515625* |
| 1.23456789 | 1.234*375* | 1.234*38* | 1.234*375* |
| 123.456789 | 123.4*375* | 123.*5* | 123.4*375* |
| 12345.6789 | 1234*4.0* | 123*52.0* | 1234*4.0* |
| 123456.789 | *INF* | 123*392.0* | 123456.*0* |

Key: BF16 has more range but less precision than FP16 (large values fit in BF16 but not FP16).

> **Warning:** Always load a model in the format it was designed for. Loading Llama 2 (designed for BF16) in FP16 caused many teams to find much worse performance than expected.

### Quantization

**Quantization** = converting values from a higher-precision format to a lower-precision format.

**Effect:** Halving bits per parameter halves memory. A 10B-parameter model in FP32 needs 40 GB; in FP16, it needs 20 GB.

**When to quantize:**
- **Post-training quantization (PTQ):** Quantize after training is complete. Most common; easy to do with PyTorch, TensorFlow, and Hugging Face.
- **Quantization-aware training (QAT):** Simulate low-precision during training so the model learns to perform well at low precision. Doesn't reduce training time.
- **Train directly in low precision:** Reduces training cost; harder to do correctly because backpropagation is sensitive to precision.

**How low can you go?**

| Format | Notes |
|---|---|
| FP16 / BF16 | Standard for inference today |
| INT8 | LLM.int8() (Dettmers et al., 2022) |
| INT4 | QLoRA (Dettmers et al., 2023); NVIDIA Blackwell GPUs (2024) |
| ~3.5-bit | Apple's on-device models (mix of 2-bit and 4-bit) |
| 1.58-bit | BitNet b1.58 (Ma et al., 2024) — comparable to 16-bit Llama 2 at up to 3.9B parameters |

**Table 7-4: BitNet b1.58 vs. Llama 2 (16-bit) on benchmarks**

| Model | Size | ARCe | HS | BQ | PQ | Avg. |
|---|---|---|---|---|---|---|
| Llama LLM | 700M | 54.7 | 37.0 | 60.0 | 68.9 | 45.5 |
| BitNet b1.58 | 700M | 51.8 | 35.1 | 58.2 | 68.1 | 44.3 |
| Llama LLM | 3B | 62.1 | 43.3 | 61.8 | 72.1 | 49.7 |
| BitNet b1.58 | 3B | 61.4 | 42.9 | 61.5 | 71.5 | **50.2** |

> Reduced precision not only saves memory but also speeds up computation (smaller numbers = faster arithmetic). However, it can degrade model quality if taken too far.

**Mixed precision training:** Keep a high-precision copy of weights (for stability), but compute gradients and activations in lower precision. Most ML frameworks offer this via **Automatic Mixed Precision (AMP)**.

---

## Finetuning Techniques

### Parameter-Efficient Finetuning (PEFT)

**Full finetuning** — updating all model parameters — is how it started. But for a 7B model in 16-bit with Adam:
- Weights: 14 GB
- Gradients + optimizer states: 42 GB
- **Total: 56+ GB** — exceeds most GPUs

**Partial finetuning** — freeze most layers, update only the last few — reduces trainable parameters. But it's *parameter-inefficient*: you need to update ~25% of BERT's parameters to match full finetuning performance (Houlsby et al., 2019):

![Graph showing that partial finetuning (blue line) requires many trainable parameters to approach full finetuning performance, while adapters (orange line) achieve near-full performance with far fewer parameters](../images/aien_0707.png)
###### Figure 7-7. Partial finetuning requires many trainable parameters to match full finetuning. Adapters (orange) achieve near-full performance with far fewer parameters.

**PEFT** (Houlsby et al., 2019) asks: *Can we match full finetuning performance using far fewer trainable parameters?*

**Key insight:** Insert small **adapter modules** into the model's layers. During finetuning, only the adapters are updated; the original model weights are frozen.

Result: On the GLUE benchmark, BERT with adapters achieved **within 0.4% of full finetuning using only 3% of the trainable parameters**.

![Diagram showing a BERT transformer block with two small adapter modules inserted — one after the attention layer and one after the feedforward layer](../images/aien_0708.png)
###### Figure 7-8. Adapters inserted into each transformer block. Only adapters are updated during finetuning.

> PEFT methods are not only parameter-efficient but also **sample-efficient** — they often work well with just a few thousand examples, compared to the tens of thousands needed for full finetuning.

### PEFT Techniques: Two Families

**1. Adapter-based methods (additive):**

Add extra modules to the model:

| Method | Notes |
|---|---|
| **LoRA** (Hu et al., 2021) | Most popular; no extra inference latency |
| **BitFit** (Zaken et al., 2021) | Updates only bias terms |
| **IA3** (Liu et al., 2022) | Efficient for multi-task finetuning; can outperform LoRA |
| **LongLoRA** (Chen et al., 2023) | LoRA variant for expanding context length |

**2. Soft prompt-based methods:**

Add **soft prompts** — trainable, continuous vectors — to the input alongside the human-readable (hard) prompt:

![Diagram showing hard prompts (human-readable text) and soft prompts (trainable vectors) being concatenated before feeding into the model](../images/aien_0709.png)
###### Figure 7-9. Hard prompts and soft prompts can be combined to guide a model's behavior.

| Method | Where soft prompts are added |
|---|---|
| **Prefix tuning** | Prepended at every transformer layer |
| **P-Tuning** | Various locations in the input |
| **Prompt tuning** | Only at the embedded input |

**Popularity in practice (analysis of 1,000+ Hugging Face PEFT issues, Oct 2024):**

![Bar chart showing LoRA dominates PEFT technique usage on Hugging Face, followed by soft prompt techniques with growing interest](../images/aien_0710.png)
###### Figure 7-10. LoRA dominates PEFT technique usage on Hugging Face.

**LoRA is by far the most popular PEFT method.**

---

### LoRA (Low-Rank Adaptation)

Unlike the original adapter approach, LoRA avoids extra inference latency by using modules that **merge back into the original weights**.

#### How LoRA Works

Given a weight matrix **W** of dimension n × m:

1. Choose a rank **r** (a small number like 4, 8, or 16)
2. Create two smaller matrices: **A** (n × r) and **B** (r × m)
3. During finetuning, update only **A** and **B** (not **W**)
4. The effective weight used is: **W' = W + (α/r) × W_AB**

![Diagram showing a weight matrix W with LoRA: A (n×r) and B (r×m) matrices are added alongside W. During finetuning, only A and B are updated while W is frozen](../images/aien_0711.png)
###### Figure 7-11. LoRA decomposes the update into two small matrices A and B. Only A and B are updated during finetuning.

**Why this is more efficient:**

A 9×9 matrix has 81 parameters. Factorized into 9×1 and 1×9, it has only 18 parameters. Same principle — LoRA dramatically reduces trainable parameters.

**LoRA vs. full finetuning on GPT-3 (Hu et al., 2021):**
- Full finetuning: 175 billion trainable parameters
- LoRA: ~4.7 million trainable parameters (**0.0027%** of full finetuning)
- Performance: **comparable or better** on several tasks

#### Why Does LoRA Work?

LLMs have many parameters but very **low intrinsic dimension** — meaning most meaningful learning happens in a much lower-dimensional subspace. Pre-training implicitly compresses the model's intrinsic dimension, making it easy to finetune with few parameters.

Larger, better-trained models tend to have even lower intrinsic dimensions after pre-training → they are easier to finetune with fewer parameters and examples.

#### Can We Use LoRA for Pre-Training?

Active research: ReLoRA (Lialin et al., 2023) works up to 1.3B parameters; GaLore (Zhao et al., 2024) shows promise at 7B parameters. However, full-rank pre-training may still be necessary first, as it's what compresses the intrinsic dimension in the first place.

#### LoRA Configurations

**Which matrices to apply LoRA to:**

LoRA is most commonly applied to the four attention matrices: query (Wq), key (Wk), value (Wv), and output projection (Wo).

**Table 7-5: LoRA performance with 18M trainable parameters (GPT-3 175B)**

| Weight type | Wq | Wk | Wv | Wo | Wq,Wv | Wq,Wk,Wv,Wo |
|---|---|---|---|---|---|---|
| Rank r | 8 | 8 | 8 | 8 | 4 | 2 |
| WikiSQL | 70.4 | 70.0 | 73.0 | 73.2 | **73.7** | **73.7** |
| MultiNLI | 91.0 | 90.8 | 91.0 | 91.3 | 91.3 | **91.7** |

> If constrained to two matrices, applying LoRA to **Wq and Wv** gives the best results. Including feedforward layers can provide complementary improvements.

**Rank r:**
- Typical range: **4 to 64** is sufficient for most tasks
- Increasing r beyond this often doesn't improve performance (and can cause overfitting)
- r=256 was needed in some specific cases (Raschka, 2023)

**α (scaling factor):** Determines how much the LoRA update contributes. Ratio α:r typically between 1:8 and 8:1. Experiment to find the best combination.

#### Serving LoRA Adapters

**Option 1 — Merge before serving:** Merge A and B back into W before deployment. No extra latency. Best when serving one model.

**Option 2 — Keep separate:** Merge happens at inference time. Adds small latency. Best for **multi-LoRA serving** — when many customers share the same base model:

![Diagram showing one base model W serving multiple customers, each with their own small LoRA adapter (A, B) loaded on demand](../images/aien_0712.png)
###### Figure 7-12. Multi-LoRA serving: one base model, multiple small LoRA adapters for different customers.

**Storage comparison for 100 customers (W is 4096×4096, rank=8):**

| Option | Storage |
|---|---|
| Option 1 (100 merged full matrices) | 100 × 16.8M = **1.68 billion parameters** |
| Option 2 (1 full matrix + 100 adapters) | 16.8M + (65,536 × 100) = **23.3 million parameters** |

Option 2 requires **72× less storage** and makes switching between customers much faster (only load the small adapter, not the full matrix).

> **Apple (2024):** Used multiple LoRA adapters on top of a single 3B base model to serve different iPhone features — all on-device, using quantization to fit everything in memory.

Publicly available LoRA adapters can be found on Hugging Face (search by "adapter", "peft", or "LoRA") and AdapterHub.

#### Quantized LoRA (QLoRA)

The LoRA adapter itself is tiny compared to the model's weights:

**Table 7-6: LoRA adapter memory vs. model weights memory**

| Model | Weights (16-bit) | LoRA params (r=2, Wq & Wk) | LoRA memory (16-bit) |
|---|---|---|---|
| Llama 2 (13B) | 26 GB | 3.28M | **6.55 MB** |
| GPT-3 (175B) | 350 GB | 18.87M | **37.7 MB** |

The real memory savings come from quantizing the **model's weights**, not the LoRA parameters.

**QLoRA (Dettmers et al., 2023):**
- Stores model weights in **4-bit NF4** (NormalFloat-4 — designed for normally distributed weights)
- Dequantizes to BF16 only for forward/backward pass computation
- Uses **paged optimizers** — automatically moves data between GPU and CPU when GPU memory runs out
- Allows a **65B-parameter model** to be finetuned on a **single 48 GB GPU**

**QLoRA result — Guanaco model family:**

**Table 7-7: Elo ratings of Guanaco models vs. commercial models (GPT-4 as judge, May 2023)**

| Model | Size | Elo |
|---|---|---|
| GPT-4 | — | 1348 ± 1 |
| **Guanaco 65B** | 41 GB | **1022 ± 1** |
| Guanaco 33B | 21 GB | 992 ± 1 |
| ChatGPT | — | 966 ± 1 |
| Guanaco 13B | 10 GB | 916 ± 1 |
| Bard | — | 902 ± 1 |

Guanaco 65B didn't beat GPT-4, but it was preferred over ChatGPT — from a single 48 GB GPU.

**Trade-off:** NF4 quantization is computationally expensive — QLoRA can reduce memory but may increase training time.

---

## Model Merging and Multi-Task Finetuning

Model merging creates a new model by **combining parameters from multiple models**. Unlike ensembling (which combines *outputs*), model merging combines *weights* into a single model.

**Why merge?**

| Goal | Benefit |
|---|---|
| Better performance | Two models that answer different 60% of questions combined might answer 80% |
| Reduced memory | Combine two specialized models into one multi-task model |
| Multi-task learning | Train separately to avoid catastrophic forgetting, merge to get both skills |
| On-device deployment | One merged model uses less device memory than multiple separate models |
| Federated learning | Multiple on-device models trained on private data merged into one shared model |

**Ensemble vs. Model Merging:**

![Diagram comparing ensembling (multiple models generate outputs, outputs are combined) versus model merging (parameters are combined into one model which generates one output)](../images/aien_0713.png)
###### Figure 7-13. Ensembling combines outputs; model merging combines parameters.

Ensembling: higher quality, higher cost (multiple inference calls per query)
Model merging: single inference call; can be done without GPUs (making it accessible to indie developers)

### Three Merging Approaches

![Diagram showing three merging strategies: summing (add parameter values together), layer stacking (stack layers from different models), concatenation (concatenate parameter vectors)](../images/aien_0714.png)
###### Figure 7-14. Three main approaches to model merging: summing, layer stacking, and concatenation.

### 1. Summing

Add parameter values from constituent models.

#### Linear Combination

Take a weighted average: `Merge(A,B) = (wA × A + wB × B) / (wA + wB)`

Simple case (equal weights): average the values:

![Diagram showing two sets of parameter values being averaged element-wise to produce merged parameter values](../images/aien_0715.png)
###### Figure 7-15. Merging parameters by averaging them.

Linear combination works best for models finetuned from the **same base model**, viewed through the lens of **task vectors**:

- **Task vector** = finetuned model − base model (captures what the finetuning added)
- If you finetune using LoRA, the task vector = the LoRA weights

**Task arithmetic (Ilharco et al., 2022):**
- **Add task vectors** → combine capabilities ("coding + French = French coding assistant")
- **Subtract task vectors** → reduce capabilities ("remove facial recognition capability")

#### Spherical Linear Interpolation (SLERP)

Think of each model's parameters as a point on a sphere. SLERP finds a new point along the shortest surface path between two models. The interpolation factor (0–1) controls how much each model contributes:

![Diagram of a sphere with two vectors (t1 and t2) and a red path along the sphere's surface between them. The blue merged vector is midway along the path at factor 0.5](../images/aien_0716.png)
###### Figure 7-16. SLERP: the merged vector (blue) lies along the shortest surface path between two models.

SLERP is limited to merging two models at a time (can chain: merge A with B, then result with C).

#### Pruning Redundant Parameters Before Merging

During finetuning, most parameter changes are minor and don't meaningfully improve task performance. These **redundant parameters** can interfere when merging models.

**TIES-Merging (Yadav et al., 2023):** Shows that resetting the bottom 80% of task vector changes (the least significant ones) causes minimal performance loss:

![Graph showing that keeping only the top 20% of task vector parameters gives performance comparable to keeping 100%](../images/aien_0717.png)
###### Figure 7-17. Keeping the top 20% of task vector parameters gives comparable performance to keeping 100%.

**Techniques:** TIES (TrIm, Elect Sign, and merge) and DARE (Drop And REscale) prune redundant parameters before merging → significantly improves merged model quality, especially when merging many models.

### 2. Layer Stacking (Frankenmerging)

Take different layers from one or more models and stack them. This can create models with unique architectures.

**Goliath-120B (2023):** Merged from two finetuned Llama 2-70B models (Xwin and Euryale), taking 72 of 80 layers from each → 120B parameter model.

**Creating MoE (Mixture-of-Experts) from dense models (Komatsuzaki et al., 2022):**

1. Take a pre-trained model
2. Make multiple copies of certain layers
3. Add a **router** to direct each input to the most suitable copy
4. Continue training the combined model + router

![Diagram showing a dense pre-trained model having its FFN layers replicated to create expert versions, with a router added to select between them](../images/aien_0718.png)
###### Figure 7-18. Creating an MoE model from a pre-trained dense model. Adapted from Komatsuzaki et al. (2022).

**Together AI** mixed six weaker open source models to create Mixture-of-Agents, achieving GPT-4o-comparable performance on some benchmarks.

**Model upscaling (depthwise scaling):**

Create a larger model without training from scratch:

SOLAR 10.7B (Kim et al., 2023) from a 7B/32-layer model:
1. Copy the model
2. Merge two copies (sum 16 layers + stack the rest)
3. Result: 48-layer model (32×2 − 16 = 48)
4. Further train the upscaled model

![Diagram showing two 32-layer models combined by summing 16 layers and stacking the remaining layers, resulting in a 48-layer model](../images/aien_0719.png)
###### Figure 7-19. Depthwise scaling creates a 48-layer model from a 32-layer model.

### 3. Concatenation

Simply append parameters from one model onto another. The merged model's parameters = sum of both models' parameters:

![Diagram showing two LoRA adapters with ranks r1 and r2 being concatenated into a combined adapter of rank r1+r2](../images/aien_0720.png)
###### Figure 7-20. Concatenating two LoRA adapters creates one of rank r1 + r2.

> **Not recommended** as a primary strategy — doesn't reduce memory compared to serving models separately. The performance gain rarely justifies the extra parameters.

---

## Finetuning Tactics

### Base Model Selection

**Two development paths:**

**Progression path (optimize progressively):**
1. Test finetuning code on the cheapest, fastest model
2. Validate data by training a mid-size model — if training loss doesn't decrease, the data is the problem
3. Run experiments with the best model to find the performance ceiling
4. Map the price/performance frontier across all model sizes

**Distillation path (start strong, compress):**
1. Start with a small dataset + the strongest model you can afford → get the best possible model
2. Use this finetuned model to **generate more training data**
3. Use the synthetic data to train a cheaper, smaller model

### Finetuning Methods

| Situation | Recommendation |
|---|---|
| Just starting finetuning | Try LoRA first; attempt full finetuning later |
| Small dataset (hundreds of examples) | LoRA / PEFT — full finetuning may not win |
| Need to serve many customers on same base | Adapter-based (LoRA) — efficient multi-model serving |
| Best possible quality, plenty of data/compute | Full finetuning |

### Finetuning Frameworks

| Type | Options | Best for |
|---|---|---|
| **APIs** | OpenAI, Anthropic, cloud providers | Quick start, no infra management |
| **PEFT frameworks** | LLaMA-Factory, unsloth, Hugging Face PEFT, Axolotl, LitGPT | Adapter-based methods with flexibility |
| **Full finetuning** | Model's own GitHub training code | Full control |
| **Distributed training** | DeepSpeed, PyTorch Distributed, ColossalAI | Multi-machine training |

### Key Hyperparameters

#### Learning Rate

Controls how much weights change per step. Like a step size when walking toward a goal.

- Too small → too slow to converge
- Too large → overshoots, never settles
- Typical range: **1e-7 to 1e-3**
- Common starting point: end of pre-training learning rate × 0.1 to 1.0

**Reading the loss curve:**
- Loss fluctuating wildly → learning rate too high
- Loss stable but decreasing very slowly → learning rate too low

Use **learning rate schedules** to vary the rate during training (higher early, lower near the end).

#### Batch Size

How many examples the model learns from per weight update step.

- Too small (< 8) → unstable updates
- Too large → requires more memory
- **Gradient accumulation:** When memory is limited, accumulate gradients across several mini-batches before updating weights — simulates a larger batch size without the memory cost.

#### Number of Epochs

One epoch = one pass through all training data.

| Dataset size | Typical epochs |
|---|---|
| Millions of examples | 1–2 epochs |
| Thousands of examples | 4–10+ epochs |

**Signals:**
- Training loss AND validation loss both decreasing → more epochs (and more data) would help
- Training loss decreasing but validation loss increasing → **overfitting** → reduce epochs

#### Prompt Loss Weight

For instruction finetuning, each example = prompt + response. During inference, the model only generates responses.

- Weight = **100%**: model learns equally from prompt and response tokens
- Weight = **0%**: model learns only from response tokens
- **Default: ~10%** — the model learns mostly from responses but a little from prompts too

---

## Summary

Finetuning adapts a model by changing its weights, unlike prompting (which adapts it through inputs). It's the most complex chapter, covering both old concepts (transfer learning) and new ones (PEFT, model merging).

**Key decision framework:**

| Question | Answer |
|---|---|
| Should I finetune? | Only after exhaustive prompting experiments; finetuning has high up-front cost |
| RAG or finetuning? | RAG for facts (outdated info, missing knowledge); finetuning for form (wrong format, wrong style) |
| Full finetuning or PEFT? | Start with LoRA; full finetuning needs more data and memory |
| One model or multiple? | Model merging can combine multiple finetuned models into one |

**Memory reduction hierarchy:**
1. Reduce trainable parameters (PEFT → LoRA)
2. Reduce bits per parameter (quantization → QLoRA)
3. Reduce activation memory (gradient checkpointing)
4. Offload to CPU (DeepSpeed CPU offloading)

**The next challenge:** Getting high-quality annotated data for finetuning. Chapter 8 covers dataset engineering.
