# Chapter 8: Dataset Engineering

---

## Overview

> "The quality of a model depends on the quality of its training data. The best ML team in the world with infinite compute can't help you finetune a good model if you don't have data."

Dataset engineering is about creating a dataset that allows you to train the best possible model within your budget. As models demand more and better data, data handling has evolved from a side task into a dedicated discipline — complete with data labelers, dataset creators, and data quality engineers.

This chapter covers:
1. **Data curation** — what data you need, what makes it high quality, and how much you need
2. **Data synthesis** — how to generate data when you don't have enough
3. **Data processing** — how to clean, deduplicate, and format data before training

---

## A Data-Centric View of AI

Two philosophies of AI development:

| Philosophy | Focus | Goal |
|---|---|---|
| **Model-centric AI** | Improve the model | Better architectures, larger models, new training techniques |
| **Data-centric AI** | Improve the data | Better datasets that allow models to train with fewer resources |

Early AI benchmarks were model-centric — a fixed dataset (e.g., ImageNet) and competing model designs. Modern benchmarks increasingly become data-centric — a fixed model and competing dataset designs.

**DataComp (2023–2024):** Participants submit datasets; a standardized script trains a CLIP or language model on each; quality is judged by performance on downstream tasks. Similar competitions: DataPerf (MLCommons, 2023) and dcbench.

> In practice, both model and data improvements are needed. The two aren't mutually exclusive.

---

## Data Curation

Data curation determines what the model can learn. Poor data causes biases and hallucinations. Good data unlocks capabilities.

### What Data Do You Need?

The data format depends on the training phase:

| Training phase | Data format |
|---|---|
| Self-supervised finetuning (continued pre-training) | Raw sequences of text |
| Supervised finetuning (SFT) | (instruction, response) pairs |
| Preference finetuning | (instruction, winning response, losing response) triplets |
| Reward model training | ((instruction, response), score) pairs |

**Hard data types to collect:**

**Chain-of-thought (CoT) data:** Teaching models to reason step-by-step requires step-by-step responses in the training data. But writing a full multi-step solution is much harder than writing a final answer:

```
Instruction: What is the boiling point of Nitrogen?
Response (without CoT): -320.4F

CoT Instruction: Answer by reasoning step-by-step.
The cafeteria had 23 apples. If they used 20 for lunch and bought 6 more, 
how many apples do they have?
Response (with CoT): The cafeteria had 23 apples originally. They used 20 
to make lunch. So they had 23 - 20 = 3. They bought 6 more apples, 
so they have 3 + 6 = 9.
```

"Scaling Instruction-Finetuned Language Models" (Chun et al., 2024) shows incorporating CoT responses nearly **doubles accuracy** on CoT tasks. But generating such data is costly — which is why CoT datasets are rare.

**Tool use data:** Human experts describe their own processes, but their workflows may differ from what's efficient for AI. Humans use web browsers; AI agents use APIs. For this reason, many teams use simulations or AI-generated tool use data rather than human annotation.

Llama 3 authors also needed a **multi-message format** for tool use data, where each AI turn can send messages to different destinations (e.g., code interpreter vs. user display).

**Single-turn vs. multi-turn data:**
- Single-turn: simpler; model learns to respond to isolated instructions
- Multi-turn: teaches clarification, correction, and context-tracking across a conversation; harder to create but more realistic

**Data curation as unlearning:** You can remove bad training examples, not just add good ones. Example: if a chatbot adds unsolicited rewrites when asked only to fact-check, investigating training data might reveal examples with unsolicited suggestions — removing them is the fix.

---

### Data Quality

A small amount of high-quality data can outperform a large amount of noisy data:

- **Yi model:** 10K carefully crafted instructions > hundreds of thousands of noisy ones (Young et al., 2024)
- **LIMA (Less Is More for Alignment):** A 65B Llama model finetuned with 1,000 curated examples produced answers preferred over GPT-4 in 43% of cases by human judges (Zhou et al., 2023)

**Six characteristics of high-quality data:**

| Characteristic | What it means |
|---|---|
| **Relevant** | Examples match the actual task. A 19th-century legal dataset is irrelevant for modern legal Q&A. |
| **Aligned with task requirements** | Annotations match task expectations. If the task requires creativity, annotations should be creative — not just accurate. |
| **Consistent** | Two annotators scoring the same example should arrive at similar scores. Inconsistent annotations confuse the model. |
| **Correctly formatted** | No stray HTML tags, trailing spaces, inconsistent casing. Extraneous formatting tokens interfere with learning. |
| **Sufficiently unique** | Duplicates bias the distribution and contaminate test sets. |
| **Compliant** | No PII, no copyrighted content prohibited by policy. |

> **Note:** The Llama 3 team found that human-generated data is more prone to errors and inconsistencies, especially for nuanced safety policies. They developed AI-assisted annotation tools to improve quality.

---

### Data Coverage

A model can only solve problems it has been exposed to. Coverage = **data diversity** — making sure training data spans the range of real-world inputs.

**Examples of coverage dimensions:**

| Application | Key diversity dimensions |
|---|---|
| Chatbot | Topic, length, speaking style, question type |
| French → English translator | Topic, length, formality (not language) |
| Global customer product chatbot | Language, culture (not domain) |
| Coding assistant | Programming language, algorithm type, complexity level |

**Key lesson from Llama 3:**

Meta's Llama 3 performance gains were "primarily driven by improvements in data quality and diversity" — not architecture changes.

**Table 8-1: Llama 3 data domain mix across training phases**

| Domain | Pre-training | Supervised finetuning | Preference finetuning |
|---|---|---|---|
| General knowledge (English) | 50% | 52.66% | 81.99% |
| Math and reasoning | 25% | 21.19% | 5.89% |
| Coding | 17% | 14.89% | 6.93% |
| Multilingual | 8% | 3.01% | 5.19% |
| Exam-like | — | 8.14% | — |
| Long context | — | 0.11% | — |

> Math and code together account for **~42% of pre-training and SFT data** — far more than their representation on the internet. The Llama 3 team found that high-quality code and math data is particularly effective at boosting **reasoning capabilities**.

**Choosing the right data mix:** Start with a mix that reflects real-world usage. Run scaling law experiments at small scale to predict which mix performs best at full scale.

**Experiment by Zhou et al. (2023):** Three 7B models, each trained on 2,000 examples:

![Bar chart comparing three 7B-parameter models trained on: high-quality but not diverse data, diverse but low-quality data, and high-quality AND diverse data — the third model outperforms both others](../images/aien_0801.png)
###### Figure 8-1. Quality AND diversity together outperform either alone. Image from Zhou et al. (2023).

**Bottom line: diversity and quality are both essential — you can't trade one for the other.**

---

### Data Quantity

How much data you need depends on:

| Factor | Effect |
|---|---|
| **Finetuning technique** | Full finetuning needs orders of magnitude more data than LoRA/PEFT |
| **Task complexity** | Sentiment classification needs less data than financial Q&A |
| **Base model capability** | A stronger base model needs fewer examples to reach target performance |

**OpenAI's finetuning study:**

![Bar chart: with 100 examples, advanced models outperform smaller ones after finetuning; with 550,000 examples, all models converge to similar performance](../images/aien_0802.png)
###### Figure 8-2. Small data → use stronger models. Large data → model size matters less.

**Rule of thumb:**
- Small dataset (few hundred) → use PEFT (LoRA) on advanced models
- Large dataset (tens of thousands+) → full finetuning with smaller models

**Starting point:** Before investing in large-scale data collection, finetune with 50–100 examples. If the model doesn't improve at all, adding more data rarely fixes it. Clear improvement → more data will help.

**Performance gain curve:**

![Line graph showing model performance vs. dataset size: steep gains initially, then diminishing returns — the curve flattens as more data is added](../images/aien_0803.png)
###### Figure 8-3. Performance gains from more data typically show diminishing returns.

The first 1,000 examples might improve accuracy by 10 points; the next 1,000 might add only 5. Knowing this curve helps you decide whether investing in more data is worth it.

**Diversity (number of tasks) also matters:**

![Graph showing model performance increasing as the number of finetuning tasks grows from 9 to 282 tasks, then plateauing — adding more diverse tasks significantly boosts performance up to a point](../images/aien_0804.png)
###### Figure 8-4. More task diversity in finetuning improves performance until a plateau. Image from Chung et al. (2022).

Performance improved dramatically from 9 to 282 tasks and kept improving (more slowly) up to 1,836 tasks.

**Staged finetuning approach** to reduce data needs:

| Stage | Example |
|---|---|
| Self-supervised → supervised | Pre-finetune on legal documents (free), then finetune on (question, answer) pairs |
| Less-relevant → relevant | Finetune on tweet sentiment first, then on product sentiment |
| Synthetic → real | Finetune on AI-generated data, then on real data (use with care) |

**Budget reality:** If your annotation budget is $10,000 and each example costs $2, you can have at most 5,000 examples. This directly bounds the data quality/quantity you can achieve.

---

## Data Acquisition and Annotation

**Best data source: your own application.** User-generated data matches the exact distribution of what you care about — queries from real users, in real formats, about real topics. A **data flywheel** (using user data to continuously improve the product, which attracts more users, which generates more data) is a major competitive advantage.

**Data sources (check before creating your own):**

1. **Hugging Face** and **Kaggle** — hundreds of thousands of datasets each
2. **Google Dataset Search** — underrated but powerful
3. **Data.gov** (US) and **data.gov.in** (India) — hundreds of thousands of government datasets
4. **University of Michigan ICPSR** — social studies data
5. **UCI ML Repository** and **OpenML** — thousands of classic ML datasets
6. **Open Data Network** — tens of thousands of datasets
7. **AWS Open Data** — cloud-hosted open datasets
8. **TensorFlow Datasets** — pre-built datasets loadable from the framework
9. **Eleuther AI lm-evaluation-harness** — 400+ benchmark datasets, ~2,000 examples each
10. **Stanford SNAP** — graph datasets

> Always check a dataset's **license** before using it. Even datasets with commercial licenses may contain content from sources that don't allow commercial use.

**Annotation challenges:**
- Creating annotation guidelines is harder than actually annotating
- Guidelines must answer: What counts as a good response? What separates a score of 3 from 4? Can a response be correct but unhelpful?
- LinkedIn reported that annotation guidelines were "among the most challenging parts of their AI engineering pipeline"
- Abandoning careful annotation halfway is common — and risky

**Good news:** Annotation guidelines are the same as evaluation guidelines (Chapter 4). Investing in good evaluation criteria pays dividends for training data too.

**Example dataset creation workflow (simplified):**
1. Find a public dataset with 10,000 examples
2. Remove low-quality instructions → 9,000 remain
3. Set aside instructions with low-quality responses (3,000) → 6,000 good examples
4. Manually write responses for the 3,000 flagged instructions → 9,000 high-quality examples
5. Generate 100 instruction templates for a missing topic → use AI to synthesize 2,000 more instructions
6. Manually annotate the 2,000 synthetic instructions → **11,000 total high-quality examples**

(In practice, this process involves many rounds of fixing inconsistencies, correcting factual errors, updating guidelines, and re-annotating.)

---

## Data Augmentation and Synthesis

| Term | What it means |
|---|---|
| **Data augmentation** | Create new data from *existing real* data (e.g., flip an image) |
| **Data synthesis** | Generate data that *mimics real* data without being derived from it |

In practice, both terms are often used interchangeably.

### Why Synthesize Data?

| Reason | Example |
|---|---|
| **Increase quantity** | Rare events (deep sea exploration, self-driving car accidents) can't be collected cheaply in the real world |
| **Increase coverage** | Generate adversarial examples, rare class examples, toxic examples for safety training |
| **Increase quality** | AI can generate more complex math problems than average human experts |
| **Mitigate privacy concerns** | Synthetic patient records for healthcare when real records can't be used |
| **Distill models** | Train a smaller model to mimic a larger one using the large model's outputs |

---

### Traditional Data Synthesis Techniques

#### Rule-Based Synthesis

Use templates + random generators to produce structured data:

```
Transaction Template:
Transaction ID: [Unique Identifier]
Date: [MM/DD/YYYY]
Time: [HH:MM:SS]
Amount: [Transaction Amount]
Merchant Name: [Merchant/Store Name]
Merchant Category: [Category Code]
Location: [City, State, Country]
Payment Method: [Credit Card/Debit Card/Cash/Online Payment]
Transaction Status: [Completed/Pending/Failed]
Description: [Transaction Description]
```

Many fraud detection models are first trained on synthetic transaction data from templates like this before being given access to real (sensitive) data.

Templates can also generate:
- Documents with fixed structures (invoices, resumes, tax forms, contracts)
- Data following grammar/syntax rules (regular expressions, math equations)
- **Example:** DeepMind trained AlphaGeometry (Olympiad-level geometry) on **100 million** synthetic examples

**Word replacement for text augmentation:**
- Replace a word with a synonym: "She's a *fantastic* nurse" → "She's a *great* nurse"
- Replace gendered words to mitigate bias:

**Table 8-2: Data augmentation for bias mitigation**

| Original data | Augmented data |
|---|---|
| She's a fantastic nurse. | **He**'s a fantastic nurse. / She's a fantastic **doctor**. |
| The CEO, Mr. Alex Wang, … | The CEO, **Ms. Alexa Wang**, … |
| Today, my mom made a casserole. | Today, my **dad** made a casserole. |
| Emily has always loved the violin. | **Mohammed** has always loved the violin. |

**Perturbation:** Add noise to existing data to improve robustness.
- "One Pixel Attack" (Su et al., 2017): changing just **1 pixel** caused misclassification of 67.97% of CIFAR-10 images
- Training on perturbed data improves robustness against adversarial attacks
- BERT authors replaced 1.5% of tokens with random words during training → small performance boost

#### Simulation

Run virtual experiments instead of real-world ones (cheaper and safer):
- **Self-driving:** CARLA, Waymo's SimulationCity, Tesla's SF simulation — test rare events (horse on highway) without danger
- **Robotics:** Simulate a robot pouring coffee across thousands of joint movement scenarios; use only successful ones
- **Self-play:** OpenAI's Dota 2 bot played ~180 years of games per day; DeepMind's AlphaGo trained on millions of simulated Go games
- **Finance:** Simulate rare events (IPOs, bankruptcies) to study market impact

---

### AI-Powered Data Synthesis

AI opens new synthesis possibilities that weren't feasible before.

**AI-simulated APIs (StableToolBench, Guo et al., 2024):** Instead of making real API calls (costly, rate-limited), AI simulates the expected output of those calls. Useful for generating tool use training data at scale.

**Paraphrasing for dataset expansion:**

Given "How to reset my password?", AI generates:
1. "I forgot my password."
2. "How can I change my password?"
3. "Steps to reset passwords."

**MetaMath (Yu et al., 2023):** Rewrote 15,000 MATH/GSM-8K examples in multiple ways → nearly **400,000 examples**. Models trained on MetaMath outperformed larger models on math benchmarks.

**Translation for low-resource languages:** Translate high-resource language data (English) into low-resource languages (Quechua, Lao). Verify quality with **back-translation**: translate back to English and compare to the original.

---

### Instruction Data Synthesis

For SFT, AI can synthesize:
- **Instructions only** (humans write responses)
- **Responses only** (humans write instructions)
- **Both** (fully automated)

**UltraChat (Ding et al., 2023):**
1. Ask ChatGPT to generate 30 broad daily life topics
2. For each topic, generate 30–50 subtopics
3. Generate multi-turn dialogues for each subtopic
→ Result: large multi-turn dialogue dataset

**Alpaca (Taori et al., 2023 — Stanford):**
1. Start with 175 seed (instruction, response) examples
2. Prompt GPT-3 (text-davinci-003) to generate 52,000 similar pairs

![Screenshot showing a seed task and an AI-generated task used to train Alpaca — the generated task follows the same format and style as the seed](../images/aien_0805.png)
###### Figure 8-5. A seed task and a generated task used to train Alpaca.

**Reverse instruction approach:**
Instead of generating a response for a given instruction, take *existing high-quality long content* (books, Wikipedia articles, stories) and use AI to generate the *instruction* that would elicit that content.

Why it's better: the response already exists and is high-quality; only the instruction is AI-generated. This avoids hallucinations in the response.

**Bootstrapping with reverse instruction (Li et al., 2023):**
1. Train a weak model on small seed data
2. Use the weak model to generate instructions for high-quality existing content
3. Finetune the weak model on this new instruction data
4. Repeat → model keeps improving without manual annotation

**Long-context finetuning via synthesis:**
- Take a long document (e.g., 100K tokens)
- Split into short chunks
- Generate (question, answer) pairs from each chunk
- Use the *full long document* as context when training the model to answer those questions
→ This teaches the model to use extended context

**Llama 3 coding data synthesis pipeline (2.7M examples):**
1. AI generates diverse programming problem descriptions
2. AI generates solutions in multiple programming languages
3. AI generates unit tests to verify solutions
4. AI fixes errors found by tests (20% self-corrected)
5. AI translates solutions into other programming languages; filter out failures
6. AI generates code explanations/documentation; filter using back-translation verification

---

### Data Verification

Synthetic data must be evaluated before use. Methods:

| Method | When to use |
|---|---|
| **Functional correctness** | Code, math, SQL — execute and check output |
| **AI verifiers / judges** | General quality scoring (1–5 scale, good/bad classification) |
| **Factual inconsistency detection** | Responses that might hallucinate facts |
| **Back-translation** | Translations — check round-trip fidelity |
| **Topic classifiers** | Filter out off-topic examples |
| **Anomaly detection** | Identify outlier examples that may be low quality |

**Heuristic filters (Self-Instruct paper, Wang et al., 2022):**
- Repetitive examples
- Instructions that are too long or too short
- Same instruction but different responses
- Responses that simply repeat the input

> The ultimate quality test for synthetic data is always **real-world model performance** — whether the model trained on it actually improves. Synthetic data has passed this test for many models.

---

### Limitations of AI-Generated Data

#### 1. Quality Control

AI-generated data can be wrong, inconsistent, or low-quality. "Garbage in, garbage out." Reliable quality evaluation is a prerequisite for synthetic data to be useful.

#### 2. Superficial Imitation

"The False Promise of Imitating Proprietary LLMs" (Gudibande et al., 2023): imitation models learn the *style* of teacher models but struggle with *factual accuracy* and *generalization*.

Worse: if the teacher generates correct math solutions, training the student on those solutions teaches it to *produce answers that look like solutions* — even when the student doesn't actually understand the math. This is a form of trained hallucination.

#### 3. Model Collapse

"The Curse of Recursion" (Shumailov et al., 2023): **recursively** training on AI-generated data causes models to degrade over time — they forget rare events and over-represent common ones.

**Model collapse:** Probable outputs become over-represented; improbable ones are forgotten.

**Mitigation:** Mixing real data with synthetic data can prevent collapse (Gerstgrasser et al., 2024). No definitive ratio has been established.

**Counter-example:** Nemotron-4-340B-Instruct used 98% synthetic data for SFT and preference finetuning — but this was tested for only one iteration, not recursive training.

#### 4. Obscure Data Lineage

AI models regurgitate their training data in ways you may not detect. If Model X was trained on copyrighted content or on benchmark Y, then:
- Your model trained on Model X's outputs might violate copyrights
- Your model's benchmark Y performance is contaminated

Without clear data lineage, it's hard to assess commercial viability or trust evaluation results.

---

### Model Distillation

**Model distillation** (Hinton et al., 2015): train a small **student** model to imitate a large **teacher** model.

**Goal:** Create a smaller, faster model with similar capabilities.

**Classic example:** DistilBERT
- Distilled from BERT
- **40% smaller**, **60% faster**
- Retains **97% of language comprehension** capabilities

**Alpaca:** Llama-7B (7B parameters) distilled from text-davinci-003 (~175B parameters) — the student is 4% the size of the teacher but behaves similarly.

**Distillation ≠ always smaller:**  
NVIDIA Nemotron-4-340B-Instruct was distilled from Mixtral-8x7B (a 56B-parameter teacher) — the student (340B) is *larger* than the teacher. The student outperformed the teacher on many benchmarks.

> ⚠️ **Many model licenses prohibit using their outputs to train competing models.** Always check the license before attempting distillation.

**Distillation in practice:** Synthetic instruction data is commonly combined with LoRA for cost-effective finetuning:
- BuzzFeed: Flan-T5 finetuned via LoRA with synthetic data from text-davinci-003 → **80% inference cost reduction**

---

## Data Processing

After acquiring data, it must be processed before training.

> **Tip:** Always do trial runs before applying processing scripts to all data. Keep copies of original data — bugs in scripts can corrupt your dataset permanently.

### Inspect Data

Before processing, understand what you have:

**Statistics to compute:**
- Distribution of tokens (what words/tokens appear most often?)
- Distribution of input and response lengths
- Topic distribution — are topics relevant to your task?
- Language distribution
- Score distributions if data is annotated

**Creative inspection (Microsoft researchers, 2023):** Compare GPT-3 vs. GPT-4 outputs using:

![Bar chart showing the distribution of (verb, direct object, noun) pairs in GPT-3 vs GPT-4 outputs — GPT-4 has a broader, more diverse range](../images/aien_0806.png)
###### Figure 8-6. Distribution of (verb, direct object, noun) pairs helps compare data richness between models.

![Line graph showing response length distribution for GPT-3 (narrower, shorter) vs GPT-4 (broader, longer) for the same set of instructions](../images/aien_0807.png)
###### Figure 8-7. GPT-4 generates longer, more varied responses than GPT-3.

> "Manual inspection of data for just 15 minutes usually gives me some insight that could save me hours of headaches." — The author

> "Manual inspection of data has probably the highest value-to-prestige ratio of any activity in machine learning." — Greg Brockman, OpenAI co-founder

**What to look for during manual inspection:**
- Do the examples make sense?
- Can you annotate a few examples yourself and compare to the given annotations?
- Are there examples with the same query but different responses?
- Are there factual errors?
- Are there outlier annotators giving unusually short/long responses or biased scores?
- If each example has multiple annotations, compute inter-annotator disagreement and resolve conflicts.

---

### Deduplicate Data

Duplicated data skews distributions and biases the model. It also causes train/test contamination (same example in both sets).

**Table 8-3: A toy dataset — duplicated entries (highlighted) bias the model**

| | Input (Product description) | Output (Price) |
|---|---|---|
| 1 | `{item: pencil, color: red}` | `$20` |
| 2 | `{item: compass, color: green}` | `$2` |
| 3 | `{item: pencil, color: red}` | `$20` (duplicate) |
| 4 | `{item: pencil, color: red}` | `$20` (duplicate) |
| 5 | `{item: pencil, color: green}` | `$1` |

The model might wrongly learn that red items are always expensive.

**Severity of duplicates:** Anthropic study (Hernandez et al., 2022): repeating just 0.1% of data 100 times caused an **800M-parameter model to degrade to the performance of a 400M-parameter model**, despite the other 90% being unique.

**Types of duplication:**
- Whole-document duplicates
- Intra-document duplicates (same paragraph twice in one document)
- Cross-document duplicates (same popular quote in many documents)

**Deduplication methods:**

| Method | How it works |
|---|---|
| **Pairwise comparison** | Compare every pair using exact match, n-gram, fuzzy, or semantic similarity. Accurate but expensive. |
| **Hashing** (MinHash, Bloom filter) | Hash examples into buckets; compare only within-bucket pairs. Much faster. |
| **Dimensionality reduction** | Reduce to low-dimensional vectors, then compare. Combines ANN search with deduplication. |

**Tools:** dupeGuru, Dedupe, datasketch, TextDistance, TheFuzz, deduplicate-text-datasets (Google Research)

---

### Clean and Filter Data

**Remove formatting artifacts:**
- Scrape data from the web → HTML tags, Markdown artifacts, JavaScript remnants
- Databricks: removing extraneous Markdown/HTML improved accuracy by **20%** and reduced input token length by **60%**

**Remove policy-violating content:**
- PII (names, addresses, phone numbers)
- Copyrighted content
- Toxic content (using classifiers from Chapter 4)

**Remove low-quality data:**
- Use AI verifier scores
- Apply heuristics (flagged by manual inspection)
- Example finding: annotations in the **second half of an annotation session** are lower quality — likely due to annotator fatigue (Kern et al., 2024)

**Active selection (if you have more data than you can use):**
- **Active learning:** Select examples most useful for the model to learn from
- **Importance sampling:** Weight examples by importance to the target task
- Research shows discovering good data pruning metrics can "significantly reduce resource costs of modern deep learning" (Sorscher et al., 2022)

---

### Format Data

Once cleaned and deduplicated, data must match the exact format the model expects:

**Key considerations:**
- Each model has its own **tokenizer** and **chat template** (covered in Chapter 5)
- Wrong chat templates cause subtle but serious bugs in finetuning
- Instruction finetuning data: `(instruction, response)` format, where instruction = `(system prompt, user prompt)`

**Converting few-shot prompts to finetuning data:**

Before finetuning (3-shot prompt):
```
Label the following item as either edible or inedible.

Item: burger  Label: edible
Item: car     Label: inedible
Item: mushroom Label: edible

Item: {INPUT}
Label:
```

**Table 8-4: Training data for the food classification task**

| Example ID | Input | Output |
|---|---|---|
| 1 | `burger -->` | `edible` |
| 2 | `car -->` | `inedible` |
| 3 | `mushroom -->` | `edible` |
| … | … | … |

After finetuning, the prompt can be simplified to just:
```
{INPUT} -->
```

This is **much shorter** than the original 3-shot prompt, directly reducing inference cost.

> ⚠️ **Prompt format must exactly match finetuning format.** Using "burger" or "Item: burger -->" instead of "burger -->" can degrade performance.

---

## Summary

Dataset engineering is challenging, creative, and essential. The principles are surprisingly simple; the execution is intensely detailed.

**The three core data criteria:**

| Criterion | What it means |
|---|---|
| **Quality** | High accuracy, consistency, relevance, proper format, compliant |
| **Coverage (Diversity)** | Spans the full range of real-world use cases |
| **Quantity** | Enough examples for the chosen finetuning technique and task complexity |

**Key findings to remember:**
- 10K high-quality examples > 100K noisy examples (Yi model team)
- 1,000 carefully curated examples can match GPT-4 responses 43% of the time (LIMA)
- Start with 50–100 examples to validate that finetuning helps before investing more
- Quality and diversity together outperform either alone
- More task diversity improves performance significantly (up to ~282 tasks, then diminishing returns)

**Synthetic data overview:**

| Technique | Best for |
|---|---|
| Rule-based / templates | Structured data (transactions, invoices, math equations) |
| Word replacement / perturbation | Bias mitigation, adversarial robustness |
| Simulation | Robotics, self-driving, rare events, tool use |
| AI paraphrasing/translation | Dataset expansion, low-resource language adaptation |
| Reverse instruction | High-quality long-form responses with AI-generated prompts |
| AI-generated instruction data | Scaling instruction datasets (Alpaca: 175 → 52K pairs) |
| Model distillation | Smaller, faster models that mimic larger ones |

**Limitations of synthetic data:**
- Quality control is difficult
- Imitation captures style, not deep capability
- Recursive training risks model collapse
- Data lineage becomes obscure → copyright and contamination risks

**Data processing order:**
1. Inspect → understand your data before doing anything
2. Deduplicate → prevent distribution skew and test contamination
3. Clean and filter → remove noise, PII, toxic content, formatting artifacts
4. Format → match the model's expected tokenizer and chat template

> The most impactful — and most underrated — action: **manually stare at your data for 15 minutes** before writing any processing scripts.
