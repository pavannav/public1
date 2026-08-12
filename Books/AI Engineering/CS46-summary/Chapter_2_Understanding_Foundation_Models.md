# Chapter 2: Understanding Foundation Models

---

## Overview

To build applications with foundation models, you need to understand how they work — not at a deep implementation level, but well enough to choose the right model and adapt it intelligently. This chapter covers four key design decisions that shape every foundation model:

1. **Training data** — what the model learned from
2. **Model architecture** — how the model is structured
3. **Model size** — how big it is, and why that matters
4. **Post-training** — how the model was aligned with human preferences

It also covers **sampling** — how a model generates its output — which explains many puzzling AI behaviors like hallucinations and inconsistency.

---

## Training Data

> "An AI model is only as good as the data it was trained on."

A model that has never seen Vietnamese text will not be able to translate into Vietnamese. One that has never seen cancer screening scans will not detect cancer. Training data is the foundation of everything a model can do.

**Common Crawl** is the most widely used training dataset. It is a monthly crawl of 2–3 billion web pages. However, its quality is questionable — it contains clickbait, misinformation, propaganda, conspiracy theories, racism, and worse. Yet, because it is readily available, nearly every major foundation model uses some version of it.

> **Google's C4** (Colossal Clean Crawled Corpus) is a cleaned subset of Common Crawl. Even so, it still reflects the internet's biases.

**Simple filtering helps but isn't enough.** OpenAI filtered GPT-2's Reddit data to include only links with 3+ upvotes. This removes the most obscure content, but Reddit is still far from ideal training data.

---

### Multilingual Models

English dominates the internet — and therefore dominates most training datasets:

**Table 2-1: Most common languages in Common Crawl**

| Language | Code | Speakers (M) | % in Common Crawl | Category |
|---|---|---|---|---|
| English | en | 1,452 | 45.88% | H |
| Russian | ru | 258 | 5.97% | H |
| German | de | 134 | 5.88% | H |
| Chinese | zh | 1,118 | 4.87% | H |
| Japanese | jp | 125 | 4.79% | H |
| French | fr | 274 | 4.73% | H |
| Spanish | es | 548 | 4.47% | H |
| Italian | it | 68 | 2.57% | H |
| Dutch | nl | 30 | 2.06% | H |
| Polish | pl | 45 | 1.66% | H |
| Portuguese | pt | 257 | 1.15% | H |
| Vietnamese | vi | 85 | 1.03% | H |

Many languages with hundreds of millions of speakers are severely under-represented:

**Table 2-2: Examples of under-represented languages in Common Crawl**

| Language | Speakers (M) | % World Population | % in Common Crawl | World:Common Crawl Ratio |
|---|---|---|---|---|
| Punjabi | 113 | 1.41% | 0.0061% | 231.56 |
| Swahili | 71 | 0.89% | 0.0077% | 115.26 |
| Urdu | 231 | 2.89% | 0.0274% | 105.38 |
| Kannada | 64 | 0.80% | 0.0122% | 65.57 |
| Telugu | 95 | 1.19% | 0.0183% | 64.89 |
| Gujarati | 62 | 0.78% | 0.0126% | 61.51 |
| Marathi | 99 | 1.24% | 0.0213% | 58.10 |
| Bengali | 272 | 3.40% | 0.0930% | 36.56 |
| **English** | **1,452** | **18.15%** | **45.88%** | **0.40** |

A ratio of 1 is ideal. A ratio of 231 for Punjabi means it is massively under-represented relative to its speakers.

**Real-world impact:** On the MMLU benchmark (14,000 multiple-choice questions across 57 subjects), GPT-4 performed significantly better in English than in low-resource languages:

![Bar chart showing GPT-4 MMLU performance by language, with English scoring highest](../images/aien_0201.png)
###### Figure 2-1. On the MMLU benchmark, GPT-4 performs better in English than in any other language.

Similarly, in math problem-solving, GPT-4 succeeded in English more than **3× as often** as in Armenian or Farsi — and failed completely in Burmese and Amharic:

![Graph showing GPT-4 math pass rates by language, with Burmese and Amharic at 0%](../images/aien_0202.png)
###### Figure 2-2. GPT-4 is much better at math in English than in other languages.

**Additional problems for non-English languages:**

- **Tokenization inefficiency:** Hindi requires ~32 tokens to express what English says in 7 tokens. Burmese requires ~72 — ten times more than English. Since APIs charge per token, Burmese is ten times more expensive than English for the same content.
- **Unexpected behavior:** NewsGuard found ChatGPT-3.5 produced misinformation in Chinese all 7 out of 7 times tested, while refusing 6 out of 7 requests in English.

> **Does "translate to English first" work?** Sometimes, but translation loses nuance (e.g., Vietnamese pronouns that encode speaker relationships all become "I" and "you" in English).

Language-specific models exist to address this: ChatGLM and Llama-Chinese (Chinese), CroissantLLM (French), PhoGPT (Vietnamese), Jais (Arabic).

---

### Domain-Specific Models

General-purpose models like GPT-4, Gemini, and Llama handle a wide range of domains. The C4 dataset covers many domains:

![Distribution of domain categories in the C4 dataset](../images/aien_0203.png)
###### Figure 2-3. Distribution of domains in the C4 dataset. Reproduced from the Washington Post.

However, they fail on specialized domains that are hard to find on the public internet. For example, CLIP and Open CLIP show very different performance depending on the image category:

**Table 2-3: CLIP and Open CLIP accuracy on different image datasets**

| Dataset | CLIP (ViT-B/32, OpenAI) | Open CLIP (ViT-B/32, Cade) |
|---|---|---|
| ImageNet | 63.2 | 62.9 |
| Birdsnap | 37.8 | 46.0 |
| Country211 | 17.8 | 14.8 |
| Oxford 102 Flower | 66.7 | 66.0 |
| German Traffic Sign | 32.2 | 42.0 |
| Stanford Cars | 59.4 | 79.3 |

**Domain-specific models** tackle tasks that can't rely on public internet data:

- **DeepMind AlphaFold** — protein structure prediction, trained on ~100,000 known proteins
- **NVIDIA BioNeMo** — biomolecular data for drug discovery
- **Google Med-PaLM2** — medical question answering

> **Tip:** A model trained on architectural sketches could help architects far more than Stable Diffusion. A model trained on factory plans could outperform ChatGPT for manufacturing.

> **Important note on data quantity vs. quality:** Gunasekar et al. (2023) used only **7B tokens of high-quality coding data** to train a 1.3B-parameter model that outperformed much larger models on coding benchmarks. Bigger data is not always better.

---

## Modeling

### Model Architecture

The dominant architecture for language-based foundation models is the **transformer** (Vaswani et al., 2017). To understand why, we need to understand what it replaced.

#### The Seq2Seq Problem

Before transformers, the **seq2seq** (sequence-to-sequence) architecture was popular. Seq2seq uses **RNNs** (recurrent neural networks) for encoding inputs and decoding outputs. It had two major problems:

1. **Information bottleneck:** The decoder only saw the final hidden state of the encoder — like writing a book report using only the book's back cover.
2. **Sequential processing:** RNNs process tokens one at a time, making them slow for long sequences.

#### The Transformer Solution

The transformer addresses both problems with the **attention mechanism**:

- The decoder can attend to *any* input token, not just the final hidden state — like referencing any page in a book.
- Input tokens can be processed **in parallel**, dramatically speeding up input processing.

![Diagram comparing seq2seq architecture (top) vs transformer architecture (bottom) showing attention connections](../images/aien_0204.png)
###### Figure 2-4. Seq2seq architecture versus transformer architecture. For the transformer architecture, the arrows show the tokens that the decoder attends to when generating each output token.

**Transformer inference has two steps:**

| Step | What happens |
|---|---|
| **Prefill** | All input tokens are processed in parallel; key/value vectors are computed for each |
| **Decode** | Output tokens are generated one at a time (still sequential) |

#### The Attention Mechanism

The attention mechanism uses three vectors for each token:

- **Query (Q)** — the current state of the decoder ("what am I looking for?")
- **Key (K)** — each previous token's "label" ("here is what I represent")
- **Value (V)** — each previous token's actual content ("here is what I contain")

To decide how much attention to give token X, the model computes the **dot product** of the query with token X's key. High score = use more of that token's value.

```
K = x × W_K
V = x × W_V
Q = x × W_Q

Attention(Q, K, V) = softmax(Q × K^T / √d) × V
```

In Llama 2-7B: hidden dimension = 4096, so each K, V, Q vector has dimension 4096. With 32 attention heads, each head gets vectors of dimension 128 (= 4096 / 32).

![Diagram showing the attention mechanism with Q, K, V vectors and its visualization from the transformer paper](../images/aien_0205.png)
###### Figure 2-5. An example of the attention mechanism in action next to its high-level visualization from "Attention Is All You Need" (Vaswani et al., 2017).

> **Why context length is hard to extend:** Every previous token needs its own K and V vectors. Longer sequences = more K/V vectors to compute and store.

#### Transformer Block

A transformer model is built from stacked **transformer blocks**, each containing:

- **Attention module** — 4 weight matrices: query, key, value, output projection
- **MLP module** — Linear layers with nonlinear activation functions (ReLU or GELU)
  - `ReLU(x) = max(0, x)`

The full transformer model also has:
- **Embedding module (before blocks):** Converts tokens and positions into vectors. Maximum context length is determined by the number of tracked positions.
- **Output layer (after blocks):** Maps output vectors to token probabilities. Also called the **unembedding layer** or model **head**.

![Diagram visualizing the weight composition of a full transformer model](../images/aien_0206.png)
###### Figure 2-6. A visualization of the weight composition of a transformer model.

**Table 2-4: Dimension values for different Llama models**

| Model | # Blocks | Model Dim | Feedforward Dim | Vocab Size | Context Length |
|---|---|---|---|---|---|
| Llama 2-7B | 32 | 4,096 | 11,008 | 32K | 4K |
| Llama 2-13B | 40 | 5,120 | 13,824 | 32K | 4K |
| Llama 2-70B | 80 | 8,192 | 22,016 | 32K | 4K |
| Llama 3-7B | 32 | 4,096 | 14,336 | 128K | 128K |
| Llama 3-70B | 80 | 8,192 | 28,672 | 128K | 128K |
| Llama 3-405B | 126 | 16,384 | 53,248 | 128K | 128K |

#### Alternative Architectures

The transformer has dominated since 2017. Alternative architectures trying to challenge it:

- **RWKV** — RNN-based but parallelizable for training; no hard context limit, but long context performance isn't guaranteed
- **State Space Models (SSMs)** — Promising for long-range memory:

| Architecture | Key Innovation |
|---|---|
| **S4** | Made SSMs more efficient |
| **H3 (Hungry Hungry Hippos)** | Added mechanism to recall early tokens and compare tokens across sequences |
| **Mamba** | Scales SSMs to 3B parameters; linear scaling with sequence length (vs. quadratic for transformers); performs up to 1M token sequences |
| **Jamba** | Hybrid Transformer + Mamba; 52B total / 12B active parameters; fits in one 80GB GPU; handles up to 256K context |

![Diagrams comparing the transformer block, Mamba block, and Jamba block structures](../images/aien_0207.png)
###### Figure 2-7. A visualization of the transformer, Mamba, and Jamba layers. Image adapted from "Jamba: A Hybrid Transformer–Mamba Language Model" (Lieber et al., 2024).

---

### Model Size

A model's size is measured by its **number of parameters** — variables updated during training. More parameters = more capacity to learn.

> **Newer generations beat older larger ones:** Llama 3-8B (2024) outperforms Llama 2-70B (2023) on MMLU.

**Memory estimation:**  
A 7B-parameter model stored in 16-bit precision requires at least `7B × 2 bytes = 14 GB` of GPU memory for inference.

#### Sparse Models and Mixture-of-Experts (MoE)

A **sparse model** has many zero-value parameters. This enables efficient computation because zero values can be skipped.

**Mixture-of-Experts (MoE):** The model is divided into groups of parameters ("experts"). Only a subset of experts is activated for each token.

**Example — Mixtral 8x7B:**
- 8 experts × 7B parameters each = 56B total (with sharing: 46.7B)
- Only 2 experts active per token = 12.9B active parameters
- Speed and cost = equivalent to a 12.9B dense model
- But capability = closer to 46.7B model

#### Measuring Dataset Size

For language models, dataset size is measured in **tokens** (not samples or words, since a book is worth far more than a sentence).

**Examples of training scale:**

| Model | # Parameters | Training Tokens |
|---|---|---|
| LaMDA | 137B | 168B |
| GPT-3 | 175B | 300B |
| Jurassic | 178B | 300B |
| Gopher | 280B | 300B |
| MT-NLG 530B | 530B | 270B |
| Chinchilla | 70B | 1.4T |

Meta's Llama models used increasingly larger datasets:
- Llama 1: 1.4 trillion tokens
- Llama 2: 2 trillion tokens
- Llama 3: **15 trillion tokens**

Together's RedPajama-v2: 30 trillion tokens = equivalent to 450 million books = 5,400× the size of Wikipedia.

> **Dataset tokens ≠ Training tokens:** If you train on a 1T-token dataset for 2 epochs, you've used 2T training tokens.

#### Compute (FLOPs)

**FLOPs** (Floating Point Operations) measures how much computation a task requires.

> ⚠️ **Notation alert:** FLOPs (floating point operations) ≠ FLOP/s (operations per second). Some companies use FLOP/s-day:
> `1 FLOP/s-day = 86,400 FLOPs`

**NVIDIA H100 NVL GPU:** max 60 TeraFLOP/s = `6 × 10¹³` FLOPs per second = `5.2 × 10¹⁸` FLOPs per day.

**Cost example — training GPT-3-175B (3.14 × 10²³ FLOPs):**

```
$2/H100/hour × 256 H100s × 24 hours × 256 days / 0.7 utilization
= $4,142,811.43
```

> **Three numbers to remember for model scale:**
> - **# parameters** — proxy for learning capacity
> - **# training tokens** — proxy for how much it learned
> - **# FLOPs** — proxy for training cost

#### Inverse Scaling

Bigger isn't always better. Anthropic found that more alignment training can sometimes make models *less* aligned (Perez et al., 2022). The **Inverse Scaling Prize** (2023) found that larger models are sometimes worse at memorization tasks and tasks with strong priors.

#### Scaling Law: Building Compute-Optimal Models

Given a fixed compute budget, what model size and dataset size gives the best performance?

The **Chinchilla Scaling Law** (DeepMind, 2022) answers this:

> For compute-optimal training: **training tokens ≈ 20× model parameters**
> Scale model size and dataset size equally — doubling one should double the other.

To find this, DeepMind trained 400 models ranging from 70M to 16B parameters on 5B–500B tokens.

![Graphs showing relationships between training loss, number of parameters, FLOPs, and training tokens](../images/aien_0208.png)
###### Figure 2-8. Graphs depicting the relationships between training loss, model parameters, FLOPs, and training tokens. Source: "Training Compute-Optimal Large Language Models" (DeepMind, 2022).

**Important nuance:** The scaling law optimizes quality but not usability. Meta chose smaller Llama models than the law would suggest — smaller models are cheaper to run and easier to adopt, which drove wider usage.

**The last-mile problem applies to models too:** Going from 2% to 3% error may require 10× more data, compute, and energy than going from 3% to 4%.

#### Scaling Extrapolation

Large models can only be trained once — you can't afford to try multiple hyperparameter settings. **Scaling extrapolation** (also called hyperparameter transferring) studies hyperparameters on small models, then extrapolates to large models. A 2022 paper showed hyperparameters can be transferred from a 40M model to a 6.7B model.

**Emergent abilities** make this harder: some capabilities only appear at scale and cannot be observed in small models.

#### Scaling Bottlenecks

Two major limits on how much models can keep scaling:

**1. Training data**  
The rate at which training datasets grow is outpacing the rate at which new human-generated data is created:

![Graph showing training dataset size growth vs. available data stock projections, with the two lines diverging](../images/aien_0209.png)
###### Figure 2-9. Projection of historical trend of training dataset sizes and available data stock. Source: Villalobos et al., 2024.

> ⚠️ If you have ever posted anything on the internet, assume it is or will be in some model's training data.

Consequences:
- Companies (Reddit, Stack Overflow) are restricting data scraping. By 2024, 45% of C4 is now restricted.
- OpenAI signed deals with the AP and Axel Springer for proprietary content.
- AI-generated content is flooding the internet, so future models may train partly on AI outputs — a form of "model collapse."

**2. Electricity**  
Data centers currently use 1–2% of global electricity. By 2030, this may reach 4–20%. This creates an effective ceiling on how much data centers can grow (at most ~50×, less than 2 orders of magnitude).

---

## Post-Training

Pre-training produces a capable but raw model — it completes text but doesn't know how to have a conversation or what to refuse. **Post-training** fixes this in two steps:

1. **Supervised Finetuning (SFT)** — Teach the model to respond appropriately
2. **Preference Finetuning** — Teach the model to align with human values

> **Pre-training analogy:** Reading to acquire knowledge.  
> **Post-training analogy:** Learning how to use that knowledge.

Post-training uses only ~2% of total compute (pre-training uses 98%).

The overall workflow:

![Diagram showing the pre-training → SFT → RLHF workflow](../images/aien_0210.png)
###### Figure 2-10. The overall training workflow with pre-training, SFT, and RLHF.

This process resembles a well-known AI meme: a Shoggoth monster (the raw, internet-trained model) given a smiley face through SFT and preference finetuning:

![Drawing of a Shoggoth monster with a smiley face — metaphor for pre-trained model being polished by post-training](../images/aien_0211.png)
###### Figure 2-11. Shoggoth with a smiley face. Adapted from an original image shared by anthrupad.

---

### Supervised Finetuning (SFT)

A pre-trained model given the prompt "How to make pizza?" might respond:
1. "for a family of six?" (adds context)
2. "What ingredients do I need?" (adds questions)
3. "Here are the steps: …" ← this is what users actually want

To teach the model option 3, we show it **demonstration data**: examples of (prompt, response) pairs.

**Distribution of task types used for InstructGPT:**

![Pie chart showing types of prompts used for InstructGPT finetuning — generation, open QA, brainstorming, summarization, etc.](../images/aien_0212.png)
###### Figure 2-12. The distribution of prompts used to finetune InstructGPT.

**Table 2-6: Examples of demonstration data used for InstructGPT**

| Prompt | Labeler's Response |
|---|---|
| `Serendipity means the occurrence of events by chance in a happy way. Use the word in a sentence.` | `Running into Margaret and being introduced to Tom was a fortunate stroke of serendipity.` |
| `[Article about Ruth Bader Ginsburg] 3. Why will Ginsburg's death have profound consequences?` | `Ruth Bader Ginsburg was the leader of the liberal wing, and the chief justice no longer holds the controlling vote in contested cases.` |
| `ELI5: What's the cause of the "anxiety lump" in our chest?` | `The anxiety lump is caused by muscular tension keeping your glottis dilated to maximize airflow. The clenched chest feeling is caused by the vagus nerve telling organs to pump blood faster, produce adrenaline and cortisol.` |

**Data quality is critical:**
- ~90% of InstructGPT labelers had a college degree; 1/3 had master's degrees
- Each (prompt, response) pair can take up to 30 minutes to write
- $10/pair × 13,000 pairs = $130,000 for InstructGPT's SFT data alone

---

### Preference Finetuning

SFT teaches the model *how* to converse, but not *what kind* of conversations are appropriate. Should a model help with controversial topics? Write content about why one group is inferior? Plan illegal activities?

The goal of **preference finetuning** is to align the model with human preferences. The most common approach is **RLHF** (Reinforcement Learning from Human Feedback):

1. Train a **reward model** that scores model outputs
2. Further train the SFT model to generate responses that score well

Other approaches: **DPO** (Direct Preference Optimization, used by Llama 3) and **RLAIF** (Reinforcement Learning from AI Feedback, used by Claude).

#### Reward Model

Rather than asking labelers to score responses on a 1–10 scale (inconsistent), they compare two responses and choose which is better. This produces **comparison data**: `(prompt, winning_response, losing_response)`.

**Table 2-7: Example comparison data from Anthropic's HH-RLHF dataset**

| Prompt | Winning Response | Losing Response |
|---|---|---|
| `How can I get my dog high?` | `I'm not sure what you mean by that.` | `I don't know that we should get the dog high. I think it's important for a dog to experience the world in a sober state of mind.` |

> Note: One of the author's preferences differs from the labeled winner — illustrating how difficult it is to define universal human preference.

Comparing two responses takes 3–5 minutes and costs ~$3.50 per comparison (Llama 2 team). Writing responses cost $25 each.

**Labeler UI used for InstructGPT comparison data:**

![Screenshot of the interface OpenAI labelers used to rank responses for InstructGPT's reward model](../images/aien_0213.png)
###### Figure 2-13. The interface labelers used to generate comparison data for OpenAI's InstructGPT.

Inter-labeler agreement is ~73% — meaning 7 out of 10 people agree on which response is better.

**The reward model loss function (InstructGPT):**

```
Loss = -E_x [ log( σ( r_θ(x, y_w) - r_θ(x, y_l) ) ) ]

where:
  r_θ     = reward model
  x       = prompt
  y_w     = winning response
  y_l     = losing response
  σ       = sigmoid function
```

Goal: maximize the score difference between winning and losing responses.

#### Finetuning Using the Reward Model

The SFT model is then trained with **PPO** (Proximal Policy Optimization, a reinforcement learning algorithm) to generate responses that maximize the reward model's scores.

> **Best of N alternative:** Some companies (Stitch Fix, Grab) skip full RLHF and instead use the reward model to pick the best from N generated outputs. Nextdoor found that using a reward model was the key factor in improving their application's performance.

---

## Sampling

Sampling is **how a model generates its output**. It is one of the most underrated topics in AI engineering — understanding it explains hallucinations, inconsistency, and many other puzzling behaviors.

### Sampling Fundamentals

For each position in the output, a language model:
1. Computes a **logit** value for every token in its vocabulary
2. Converts logits to **probabilities** via softmax
3. **Samples** the next token according to those probabilities

```
probability of token i:
p_i = softmax(x_i) = e^(x_i) / Σ_j e^(x_j)
```

![Diagram showing a language model computing a probability distribution over all vocabulary tokens to select the next one](../images/aien_0214.png)
###### Figure 2-14. To generate the next token, the language model first computes the probability distribution over all tokens in the vocabulary.

The model produces a **logit vector** — one value per vocabulary token:

![Diagram showing the logit vector output from a language model, with one logit per vocabulary token](../images/aien_0215.png)
###### Figure 2-15. For each input, a language model produces a logit vector. Each logit corresponds to a token in the vocabulary.

**Greedy sampling** (always pick the highest-probability token) creates boring, repetitive outputs. Instead, models sample **according to the distribution**.

---

### Sampling Strategies

#### Temperature

**Temperature** controls how creative/random the model's output is. Logits are divided by the temperature value before softmax is applied.

| Temperature | Effect | Use case |
|---|---|---|
| Low (→0) | Higher probability for top tokens; more predictable | Consistent, factual answers |
| = 1 | Default distribution | Balanced |
| High (>1) | More equal probabilities; more creative/random | Brainstorming, creative writing |

**Example:** Given logits [1, 2] for tokens A and B:
- Temperature 1.0 → probabilities [0.27, 0.73] (B picked 73%)
- Temperature 0.5 → probabilities [0.12, 0.88] (B picked 88%)

![Graph showing the softmax probabilities for tokens A and B at different temperature values from 0 to 2](../images/aien_0216.png)
###### Figure 2-16. The softmax probabilities for tokens A and B at different temperatures, given their logits being [1, 2].

> Recommended temperature for creative tasks: **0.7** (balances creativity and predictability).  
> Temperature = 0 means "always pick the highest-logit token" (deterministic).

**Logprobs:** Model providers sometimes expose **log probabilities** (probabilities in log scale) — useful for building classification apps and evaluating models. Log scale avoids underflow when dealing with very small probabilities.

![Diagram showing how logits → probabilities → logprobs are computed through softmax and log transformations](../images/aien_0217.png)
###### Figure 2-17. How logits, probabilities, and logprobs are computed.

#### Top-k

Instead of computing softmax over the entire vocabulary (expensive for large vocabularies), compute it over only the **top k** highest-logit tokens. Typical values: k = 50–500.

- Smaller k → more predictable outputs
- Larger k → more diverse outputs

#### Top-p (Nucleus Sampling)

Instead of a fixed k, sum probabilities of top tokens in descending order and stop when the sum reaches **p**. This makes k dynamic based on context.

**Example:** If top-p = 90%:

![Table showing cumulative token probabilities: "yes" (70%), "maybe" (25%) = 95% → only yes and maybe considered](../images/aien_0218.png)
###### Figure 2-18. Example token probabilities — with top-p = 90%, only "yes" and "maybe" are considered.

Typical top-p values: 0.9–0.95.

**Min-p:** Sets a minimum probability threshold for a token to be considered.

#### Stopping Condition

Autoregressive models generate indefinitely without a stopping rule. Options:
- **Fixed token limit** — fast but may cut off mid-sentence
- **Stop tokens/stop words** — model stops when it generates a special token (e.g., `<EOS>`)

> ⚠️ Early stopping can break structured outputs (e.g., missing closing brackets in JSON).

---

### Test Time Compute

**Test time compute** = generating multiple outputs per query to increase the chance of a good response.

**Why it works:** A more diverse pool of candidates is more likely to contain a good answer.

**Best of N strategy:** Generate N outputs, pick the best one using:
1. **Highest average logprob** — pick the output where the average token probability is highest

```
logprob(sequence) = logprob(token_1) + logprob(token_2) + ... + logprob(token_n)
average_logprob = logprob(sequence) / length
```

2. **Reward model scoring** — pick the output with the highest reward model score
3. **Application-specific heuristics** — e.g., pick the shortest valid response, or the first valid SQL query generated

**Key findings:**

- OpenAI found a verifier boosted math performance as much as a **30× model size increase** (a 100M model with a verifier ≈ a 3B model without one)
- DeepMind argues scaling test time compute can be more efficient than scaling model parameters (Snell et al., 2024)
- OpenAI found performance improved up to **400 outputs**, then degraded (adversarial outputs start fooling the verifier)

![Graph showing model performance on math problems as number of sampled outputs increases from 1 to 400, then declines](../images/aien_0219.png)
###### Figure 2-19. OpenAI (2021) found that sampling more outputs led to better performance, but only up to 400 outputs.

> **Parallel generation trick:** Generate multiple responses in parallel, show the user the first valid/complete one to reduce perceived latency.

> **Self-consistency:** For tasks with exact answers (math, multiple choice), pick the **most common answer** across N outputs. This is how Google sampled 32 outputs per MMLU question for Gemini.

---

### Structured Outputs

In production, AI outputs often need to follow a specific format (JSON, SQL, YAML, regex). There are two scenarios:

1. **Task requires structure** — e.g., text-to-SQL must produce valid SQL queries
2. **Downstream system requires structure** — e.g., an AI email writer must output `{"title": ..., "body": ...}` for a downstream app to parse

**Example — text-to-regex with GPT-4o:**

```
System prompt: Given an item, create a regex that represents all the ways 
               the item can be written. Return only the regex.

Example: US phone number -> \+?1?\s?(\()?(\d{3})(?(1)\))[-.\s]?(\d{3})[-.\s]?(\d{4})

User: Email address ->
GPT-4o: [a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}

User: Dates ->
GPT-4o: (?:\d{1,2}[\/\-\.])(?:\d{1,2}[\/\-\.])?\d{2,4}
```

Five approaches to get structured outputs, from lightest to heaviest:

| Approach | How it works | When to use |
|---|---|---|
| **Prompting** | Instruct the model to use a specific format | Quick; works when model is already close |
| **Post-processing** | Write scripts to fix common mistakes (e.g., add missing `}`) | Works when errors are small and predictable |
| **Test time compute** | Keep generating until a valid output appears | Works when failures are rare |
| **Constrained sampling** | Filter logit vector to only valid next tokens based on grammar rules | Reliable; requires grammar support for your format |
| **Finetuning** | Train the model on examples of the desired format | Most reliable; works for any format |

**Constrained sampling example:**

![Diagram showing how logits are filtered to remove invalid tokens before sampling, ensuring the output follows required constraints](../images/aien_0221.png)
###### Figure 2-21. Filter out logits that don't meet the constraints in order to sample only among valid outputs.

**Adding a classifier head (for classification tasks):**

![Diagram showing a base model with a classifier head appended to restrict outputs to predefined classes](../images/aien_0222.png)
###### Figure 2-22. Adding a classifier head to your base model to turn it into a classifier with three classes.

**Structured output tools:** `guidance`, `outlines`, `instructor`, `llama.cpp`, OpenAI's JSON mode.

> **LinkedIn's YAML parser** increased correct outputs from 90% to 99.99% with post-processing.

> **JSON vs. YAML:** YAML is less verbose than JSON, requiring fewer tokens — a meaningful cost savings.

---

### The Probabilistic Nature of AI

AI's sampling process makes it **probabilistic** — the same input can produce different outputs on different runs. This is fundamentally different from how traditional software works.

**Example:** If a model thinks Vietnamese cuisine has a 70% chance of being best in the world and Italian has a 30% chance, it answers "Vietnamese" 70% of the time and "Italian" 30% of the time.

This probabilistic nature has two main failure modes:

#### Inconsistency

**Two forms:**
1. Same input → different outputs (e.g., two runs of "Score this essay" return 3/5 and 5/5)
2. Slightly different input → drastically different outputs (a capitalized letter changes the answer)

![Screenshot showing the same essay-scoring prompt returning two different scores (3/5 and 5/5) in consecutive runs](../images/aien_0223.png)
###### Figure 2-23. The same input can produce different outputs in the same model.

**Mitigations:**
- Cache answers for repeated identical queries
- Fix sampling variables (temperature, top-p, top-k)
- Set the **seed** (starting point for the random number generator)
- Use careful prompt engineering and memory systems

> Even fixing all variables doesn't guarantee consistency — hardware differences (different machines computing float operations slightly differently) can still cause variation.

#### Hallucination

Hallucination = the model generates content not grounded in facts.

> "In June 2023, a law firm was fined for submitting fictitious legal research to court — they had used ChatGPT to prepare their case."

**Two hypotheses explain why hallucinations happen:**

**Hypothesis 1: Self-delusion (DeepMind, 2021)**  
A model can't distinguish between *given* text (the prompt) and *generated* text (its own output). Once the model generates a slightly wrong sentence, it treats that as fact and continues building on it.

Example: Ask "Who's Chip Huyen?" The model starts with "Chip Huyen is an architect." → then the next tokens are conditioned on that wrong claim → it builds a fictional biography.

A real multimodal example — LLaVA-v1.5-7B was shown a bottle of shampoo and asked to list the ingredients. The model decided it was a bottle of milk and listed milk as an ingredient:

![Image of a shampoo bottle with LLaVA's hallucinated response listing milk as an ingredient](../images/aien_0224.png)
###### Figure 2-24. An example of self-delusion by LLaVA-v1.5-7B.

This is called **snowballing hallucination** — an initial wrong assumption causes the model to make further mistakes it would otherwise avoid:

![Screenshot showing a model claiming 9677 is divisible by 13 due to a prior incorrect assumption in the conversation](../images/aien_0225.png)
###### Figure 2-25. An initial incorrect assumption can cause the model to claim that 9677 is divisible by 13, even if it knows this isn't true.

**Hypothesis 2: Mismatched internal knowledge (OpenAI)**  
During SFT, labelers write responses using knowledge *they* have but the model doesn't. The model learns to produce confident-sounding responses even when it doesn't actually "know" the answer. If the model knows what it knows, giving it prompts like "Answer truthfully, and if unsure, say 'I don't know'" can help.

**RLHF and hallucination:** RLHF generally helps reduce hallucinations, but the InstructGPT paper showed it actually made hallucinations slightly worse for that specific model — even though overall human evaluators preferred the RLHF model:

![Graph from InstructGPT paper showing RLHF slightly increases hallucination rate vs. SFT-only model](../images/aien_0226.png)
###### Figure 2-26. Hallucination is worse for the model that uses both RLHF and SFT (InstructGPT) compared to SFT alone (Ouyang et al., 2022).

**Practical mitigations for hallucinations:**
- Add "Answer as truthfully as possible; if unsure, say 'I don't know'" to prompts
- Ask for concise responses (fewer tokens = fewer chances to make things up)
- Use RAG (retrieval-augmented generation) to ground answers in real sources
- Use reinforcement learning to differentiate model-generated text from user-provided text

---

## Summary

This chapter covered the core design decisions behind foundation models:

| Topic | Key Takeaway |
|---|---|
| **Training data** | Models reflect their training data — English-dominant internet = English-biased models; domain-specific tasks need domain-specific data |
| **Multilingual** | Non-English languages are under-represented → worse performance, more expensive tokenization |
| **Architecture** | Transformers dominate because of the attention mechanism (parallel input processing, access to all previous tokens); alternatives like Mamba are promising |
| **Model size** | Measured in parameters, training tokens, and FLOPs; the Chinchilla law says training tokens ≈ 20× parameters for compute-optimality |
| **MoE** | Sparse mixture-of-experts models have large total parameters but only activate a fraction per token — big capability, lower cost |
| **Scaling limits** | Running out of human-generated data; electricity consumption is a growing constraint |
| **Post-training** | SFT teaches models to converse; preference finetuning (RLHF/DPO) aligns them with human values; uses only 2% of total compute |
| **Sampling** | Models are probabilistic — temperature controls creativity, top-k/top-p limit the candidate pool, test time compute improves quality by generating multiple outputs |
| **Structured outputs** | Five approaches from prompting to finetuning; constrained sampling is most reliable without finetuning |
| **Hallucination** | Caused by self-delusion (model can't distinguish what it generated vs. what was given) and mismatched knowledge (SFT teaches confident responses the model doesn't truly "know") |

The next two chapters focus on **evaluation** — arguably the most important and underrated aspect of AI engineering — starting with evaluation methodology.
