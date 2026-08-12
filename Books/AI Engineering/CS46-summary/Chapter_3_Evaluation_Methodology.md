# Chapter 3: Evaluation Methodology

---

## Overview

AI failures are not hypothetical. A man committed suicide after being encouraged by a chatbot. Lawyers submitted hallucinated fake case citations to court. Air Canada was ordered to pay damages because its chatbot gave a passenger false information.

**Evaluation is how we prevent these failures.** For many teams, figuring out evaluation takes up the majority of development effort. Yet investment in evaluation still lags far behind investment in model development and application tooling.

This chapter covers:
- Why evaluating foundation models is harder than traditional ML models
- Language modeling metrics: entropy, cross entropy, perplexity
- **Exact evaluation:** functional correctness and similarity measurements
- **Embeddings** — what they are and why they matter
- **AI as a judge** — using AI to evaluate AI
- **Comparative evaluation** — ranking models by pitting them against each other

> **Key mindset:** Evaluation isn't just a step at the end. It must be woven through the entire development process to identify where your system fails and continuously improve it.

---

## Challenges of Evaluating Foundation Models

Foundation models are harder to evaluate than traditional ML models for four reasons:

**1. The smarter AI gets, the harder it is to evaluate.**  
Anyone can spot an error in a first-grade math solution. Very few can verify a PhD-level proof. Evaluating sophisticated outputs requires expertise, fact-checking, and reasoning — not just a quick read.

**2. Open-ended outputs undermine ground-truth comparison.**  
Traditional ML models are close-ended — a spam classifier outputs "spam" or "not spam", and you compare that against the expected label. But for a question like "How do I improve this email?", there are thousands of valid responses. You can't maintain an exhaustive list of correct answers.

**3. Foundation models are black boxes.**  
Model providers rarely disclose training data, architecture details, or post-training steps. Without that, you can only evaluate by observing outputs, not by reasoning about the model's internals.

**4. Public benchmarks get saturated quickly.**  
As models improve, they max out benchmarks:
- GLUE (2018) → saturated in 1 year → replaced by SuperGLUE (2019)
- NaturalInstructions (2021) → replaced by Super-NaturalInstructions (2022)
- MMLU (2020) → largely replaced by MMLU-Pro (2024)

Despite these challenges, the field is growing fast. Papers on LLM evaluation grew from 2 per month to almost 35 per month in the first half of 2023:

![Line graph showing the exponential growth of LLM evaluation papers over the first half of 2023](../images/aien_0301.png)
###### Figure 3-1. The trend of LLMs evaluation papers over time. Image from Chang et al. (2023).

Open source evaluation repositories among the top 1,000 AI GitHub repos also grew exponentially:

![Graph showing cumulative growth of open source evaluation repositories among the top 1,000 AI repos on GitHub](../images/aien_0302.png)
###### Figure 3-2. Number of open source evaluation repositories among the 1,000 most popular AI repositories on GitHub.

Yet evaluation still lags behind modeling, training, and orchestration tools:

![Bar chart showing evaluation tools are fewer than modeling/training and AI orchestration tools among top GitHub AI repos](../images/aien_0303.png)
###### Figure 3-3. Evaluation lags behind other aspects of AI engineering in terms of open source tools.

---

## Understanding Language Modeling Metrics

Foundation models evolved from language models. For models with a language model component, performance on language modeling metrics is a good proxy for downstream task performance.

The key metrics — **entropy**, **cross entropy**, **perplexity**, **bits-per-character (BPC)**, and **bits-per-byte (BPB)** — are all closely related. If you know one, you can calculate the others.

### Entropy

**Entropy** measures how much information, on average, a token carries. The higher the entropy, the more information each token holds — and the harder it is to predict the next token.

**Example:** Two languages that describe positions in a square:

![Diagram showing two grids — one with 2 tokens (up/down) needing 1 bit, and one with 4 tokens needing 2 bits to represent each position](../images/aien_0304.png)
###### Figure 3-4. Two languages describe positions within a square. The tokens on the right (b) carry more information but need more bits to represent them.

- Language (a): 2 tokens → 1 bit per token → entropy = 1
- Language (b): 4 tokens → 2 bits per token → entropy = 2

**Intuition:** A language where you can always perfectly predict the next word has entropy = 0. The more unpredictable a language, the higher its entropy.

### Cross Entropy

When you train a language model, you want it to learn the statistical patterns of the training data. **Cross entropy** measures how well the model has learned those patterns — specifically, how difficult it is for the model to predict what comes next.

```
H(P, Q) = H(P) + D_KL(P || Q)

where:
  P = true distribution of training data
  Q = distribution learned by the language model
  H(P) = entropy of the training data
  D_KL(P || Q) = KL divergence (how far Q is from P)
```

- If the model learns perfectly: D_KL = 0, and cross entropy = data entropy
- The goal of training: minimize cross entropy

Cross entropy is **not symmetric**: H(P,Q) ≠ H(Q,P)

### Bits-per-Character (BPC) and Bits-per-Byte (BPB)

Since different models use different tokenization (word-level vs. character-level), bits-per-token isn't comparable across models.

- **BPC:** `bits per token / characters per token`
  - Example: 6 bits/token ÷ 2 chars/token = 3 BPC
- **BPB:** Normalizes by byte encoding
  - Example: 3 BPC ÷ (7/8 bytes/char) = 3.43 BPB

> **Practical implication:** A model with BPB of 3.43 can compress the original text to less than half its original size (3.43 bits per 8-bit byte).

### Perplexity

**Perplexity** is the exponential of cross entropy. It measures the **amount of uncertainty** the model has when predicting the next token.

```
PPL(P, Q) = 2^H(P,Q)        [using bits]
          = e^H(P,Q)        [using nats — common in PyTorch/TensorFlow]
```

> **Example:** A model with cross entropy of 2 bits on 4-position tokens has perplexity of 2² = 4. It's as if the model always picks randomly from 4 options.

**Rules for interpreting perplexity:**

| Factor | Effect on Perplexity |
|---|---|
| More structured data (e.g., HTML) | Lower — more predictable |
| Larger vocabulary | Higher — more options to predict |
| Longer context | Lower — more context = less uncertainty |
| Larger model | Lower — learns patterns better |

**Table 3-1: Larger GPT-2 models give lower perplexity across datasets**

|  | LAMBADA (PPL) | LAMBADA (ACC) | CBT-CN (ACC) | CBT-NE (ACC) | WikiText2 (PPL) | PTB (PPL) | enwiki8 (BPB) | text8 (BPC) | WikiText103 (PPL) | IBW (PPL) |
|---|---|---|---|---|---|---|---|---|---|---|
| SOTA | 99.8 | 59.23 | 85.7 | 82.3 | 39.14 | 46.54 | 0.99 | 1.08 | 18.3 | 21.8 |
| 117M | 35.13 | 45.99 | 87.65 | 83.4 | 29.41 | 65.85 | 1.16 | 1.17 | 37.50 | 75.20 |
| 345M | 15.60 | 55.48 | 92.35 | 87.1 | 22.76 | 47.33 | 1.01 | 1.06 | 26.37 | 55.72 |
| 762M | 10.87 | 60.12 | 93.45 | 88.0 | 19.93 | 40.31 | 0.97 | 1.02 | 22.05 | 44.58 |
| 1542M | 8.63 | 63.24 | 93.30 | 89.05 | 18.34 | 35.76 | 0.93 | 0.98 | 17.48 | 42.16 |

> **Warning:** After post-training (SFT, RLHF), a model's perplexity often *increases* even as its real-world usefulness improves. Post-training optimizes for task quality, not token prediction. Use perplexity with caution for post-trained models.

**Other uses of perplexity:**

| Use | How it works |
|---|---|
| **Data contamination detection** | Low perplexity on a benchmark = model may have seen that benchmark during training → results less trustworthy |
| **Training data deduplication** | Only add new data if its perplexity is high (model hasn't already seen it) |
| **Anomaly detection** | High perplexity = unusual or gibberish text |

**How to compute perplexity:**

```
PPL = ( P(x1, x2, ..., xn) )^(-1/n)
    = ( ∏ᵢ 1/P(xᵢ | x₁,...,xᵢ₋₁) )^(1/n)
```

You need access to the model's token probabilities (logprobs). Not all commercial models expose these.

---

## Exact Evaluation

**Exact evaluation** produces unambiguous scores — there is no interpretation involved. This section covers two types:

1. **Functional correctness** — did the system do what it was supposed to do?
2. **Similarity measurements** — how close is the output to a reference answer?

### Functional Correctness

Functional correctness asks: **Does the application actually work?**

This is the gold standard of evaluation, but it's not always automatable.

**Code generation** is a case where it CAN be automated. You give the model a coding problem, it writes code, and you run the code against unit tests.

**Example from OpenAI's HumanEval benchmark:**

```python
# Problem
from typing import List

def has_close_elements(numbers: List[float], threshold: float) -> bool:
    """ Check if in given list of numbers, are any two numbers 
    closer to each other than given threshold.
    >>> has_close_elements([1.0, 2.0, 3.0], 0.5)
    False
    >>> has_close_elements([1.0, 2.8, 3.0, 4.0, 5.0, 2.0], 0.3)
    True """

# Test cases
def check(candidate):
    assert candidate([1.0, 2.0, 3.9, 4.0, 5.0, 2.2], 0.3) == True
    assert candidate([1.0, 2.0, 3.9, 4.0, 5.0, 2.2], 0.05) == False
    assert candidate([1.0, 2.0, 5.9, 4.0, 5.0], 0.95) == True
    assert candidate([1.0, 2.0, 5.9, 4.0, 5.0], 0.8) == False
    assert candidate([1.0, 2.0, 3.0, 4.0, 5.0, 2.0], 0.1) == True
    assert candidate([1.1, 2.2, 3.1, 4.1, 5.1], 1.0) == True
    assert candidate([1.1, 2.2, 3.1, 4.1, 5.1], 0.5) == False
```

**The pass@k metric:**  
For each problem, generate k code samples. A problem is "solved" if any of the k samples pass all test cases.

```
pass@k = (problems solved) / (total problems)
```

- pass@1: each problem gets 1 attempt (hardest)
- pass@3: each problem gets 3 attempts
- pass@10: each problem gets 10 attempts (easiest)

As k increases, pass@k increases — more attempts = more chances of success.

**Benchmarks using functional correctness:**
- Code: HumanEval (OpenAI), MBPP (Google)
- SQL: Spider, BIRD-SQL, WikiSQL
- Games: score achieved by game-playing bots
- Optimization: energy saved by a scheduling agent

### Similarity Measurements Against Reference Data

When functional correctness can't be automated, compare AI outputs to **reference responses** (also called ground truths or canonical responses).

Format: `(input, [reference_response_1, reference_response_2, ...])`

There are four ways to compare a generated response to reference responses:

1. Ask a human/AI to judge if they match
2. Exact match
3. Lexical similarity
4. Semantic similarity

#### Exact Match

Accept the generated response only if it **exactly matches** one of the reference responses.

Works for:
- "What's 2 + 3?" → "5"
- "Who was the first woman to win a Nobel Prize?" → "Marie Curie"
- "Fill in the blank: Paris is to France as ___ is to England." → "London"

A relaxed variant: accept any response that **contains** the reference response.

> ⚠️ Relaxed match can fail: "What year was Anne Frank born?" — reference: "1929". A response of "September 12, 1929" contains the year but is factually wrong.

Exact match breaks down for complex tasks — "How are you doing?" and "How is it going?" mean the same thing but won't match.

#### Lexical Similarity

Measures how much two texts **look alike** (overlapping words/characters), not whether they mean the same thing.

**Fuzzy matching (approximate string matching):** Count how many character edits are needed to convert one text to another.

Three edit operations:
1. Deletion: "br**a**d" → "bad"
2. Insertion: "bad" → "ba**r**d"
3. Substitution: "b**a**d" → "b**e**d"

Example: "bad" is 1 edit from "bard", but 3 edits from "cash" → "bad" is more similar to "bard".

**N-gram similarity:** Count overlapping sequences of n tokens.

- A 1-gram (unigram) = a single token
- A 2-gram (bigram) = two consecutive tokens
- "My cats scare the mice" has bigrams: "my cats", "cats scare", "scare the", "the mice"

**Common lexical similarity metrics:**

| Metric | Used for |
|---|---|
| **BLEU** | Machine translation |
| **ROUGE** | Summarization |
| **METEOR++** | Translation with synonym handling |
| **TER** | Translation error rate |
| **CIDEr** | Image captioning |

**Drawbacks of lexical similarity:**
- A correct but differently-worded answer gets a low score if it's not in the reference set
- Example: Adept's Fuyu model was marked wrong on an image-captioning task because it wrote a correct but unlisted caption:

![Screenshot showing Fuyu's correct image caption being scored poorly because it wasn't in the reference set](../images/aien_0305.png)
###### Figure 3-5. An example where Fuyu generated a correct option but was given a low score because of the limitation of reference captions.

- Reference data can itself be wrong (WMT 2023 organizers found many bad reference translations)
- High BLEU ≠ good code: OpenAI found that on HumanEval, correct and incorrect code can have similar BLEU scores

#### Semantic Similarity

Measures whether two texts **mean the same thing**, regardless of how they look.

> "What's up?" and "How are you?" are lexically different but semantically close.  
> "Let's eat, grandma" and "Let's eat grandma" are lexically nearly identical but mean completely different things.

Semantic similarity requires converting text to **embeddings** first. See the next section.

**Common semantic similarity metrics:**
- **BERTScore** — embeddings from BERT
- **MoverScore** — mixture of embedding algorithms

**Cosine similarity formula:**

```
cosine_similarity(A, B) = (A · B) / (||A|| × ||B||)

where:
  A · B  = dot product
  ||A||  = Euclidean norm (L2 norm) of A

Range: -1 (opposite) to 1 (identical)
```

---

## Introduction to Embedding

**An embedding is a numerical vector that captures the meaning of the original data.**

Example: "the cat sits on a mat" → `[0.11, 0.02, 0.54]`

(In practice, embedding vectors have 100–10,000 dimensions.)

**The key property:** Similar data → similar (close) embeddings; different data → different (distant) embeddings.

**Common embedding models:**

**Table 3-2: Embedding sizes used by common models**

| Model | Embedding Size |
|---|---|
| Google's BERT base | 768 |
| Google's BERT large | 1,024 |
| OpenAI's CLIP (image + text) | 512 each |
| OpenAI text-embedding-3-small | 1,536 |
| OpenAI text-embedding-3-large | 3,072 |
| Cohere Embed v3 (English) | 1,024 |
| Cohere Embed v3 (light) | 384 |

**Embeddings apply far beyond text:**
- Products (Criteo, Coveo)
- Images (Pinterest)
- Users (Pinterest)
- Audio, 3D point clouds, graphs

**Multimodal embeddings:**  
CLIP maps images and text into the **same** vector space. This enables text-based image search: given a text query like "a fisherman", you find images whose embeddings are closest to that text embedding.

**CLIP's architecture:**

![Diagram of CLIP's architecture showing a text encoder and image encoder both projecting into a shared embedding space](../images/aien_0306.png)
###### Figure 3-6. CLIP's architecture (Radford et al., 2021).

**Other multimodal embedding models:**
- **ULIP** — text, images, and 3D point clouds
- **ImageBind** — text, images, audio, and 3 more modalities

**Other uses of embeddings (beyond evaluation):**
- **Retrieval/search:** Find items similar to a query (used in RAG, Chapter 6)
- **Ranking:** Sort results by relevance
- **Clustering:** Group similar items
- **Anomaly detection:** Find outliers
- **Data deduplication:** Remove near-duplicates (Chapter 8)

**Evaluating embedding quality:**  
MTEB (Massive Text Embedding Benchmark) measures embedding quality across many downstream tasks.

---

## AI as a Judge

When human evaluation is too slow or expensive, and exact metrics don't fit, the next option is **AI as a judge** — using an AI model to evaluate other AI models.

As of this writing, AI as a judge is the **most common** method for evaluating AI models in production. 58% of evaluations on LangChain's platform were done by AI judges (2023).

### Why AI as a Judge?

- **Fast:** No waiting for human annotators
- **Cheap:** Much less expensive than humans
- **Flexible:** Can evaluate any criteria you name
- **Works without reference data:** Can evaluate in production settings
- **Explains its reasoning:** Useful for auditing

**Agreement with humans:**
- MT-Bench: GPT-4 agreed with humans **85%** of the time (humans only agree with each other **81%**)
- AlpacaEval: AI judges had **0.98 correlation** with human-evaluated LMSYS Chatbot Arena leaderboard

**Example of GPT-4 explaining its judgment:**

![Screenshot showing GPT-4's evaluation output with both a score and a detailed written explanation of its reasoning](../images/aien_0307.png)
###### Figure 3-7. Not only can AI judges score, they also can explain their decisions.

### How to Use AI as a Judge

Three main patterns:

**1. Pointwise evaluation (standalone quality scoring):**

```
"Given the following question and answer, evaluate how good the 
answer is for the question. Use a score from 1 to 5.
- 1 means very bad.
- 5 means very good.
Question: [QUESTION]
Answer: [ANSWER]
Score:"
```

**2. Reference comparison (vs. ground truth):**

```
"Given the following question, reference answer, and generated 
answer, evaluate whether the generated answer is the same as the 
reference answer. Output True or False.
Question: [QUESTION]
Reference answer: [REFERENCE ANSWER]
Generated answer: [GENERATED ANSWER]"
```

**3. Pairwise comparison (pick the better of two):**

```
"Given the following question and two answers, evaluate which 
answer is better. Output A or B.
Question: [QUESTION]
A: [FIRST ANSWER]
B: [SECOND ANSWER]
The better answer is:"
```

**Table 3-3: Built-in AI judge criteria in common tools (as of September 2024)**

| AI Tool | Built-in Criteria |
|---|---|
| Azure AI Studio | Groundedness, relevance, coherence, fluency, similarity |
| MLflow.metrics | Faithfulness, relevance |
| LangChain Criteria Evaluation | Conciseness, relevance, correctness, coherence, harmfulness, maliciousness, helpfulness, controversiality, misogyny, insensitivity, criminality |
| Ragas | Faithfulness, answer relevance |

> ⚠️ These criteria are **not standardized** across tools. Azure's "relevance" score ≠ MLflow's "relevance" score.

**Best practices for prompting an AI judge:**

1. **Clearly state the task** — what the judge is evaluating
2. **Define the criteria in detail** — the more specific, the better
3. **Specify the scoring system:**
   - Classification: good/bad, relevant/irrelevant
   - Discrete numbers: 1–5 (works better than continuous 0.0–1.0)
   - Continuous: 0.0–1.0 for degree of similarity

> **Tip:** AI judges work better with classification than with number scoring. For number scoring, discrete (1–5) works better than continuous (0.0–1.0). Wider ranges (1–10) tend to work worse.

**Example judge prompt from Azure AI Studio (relevance):**

```
Your task is to score the relevance between a generated answer 
and the question based on the ground truth answer in the range 
between 1 and 5, and please also provide the scoring reason.

Your primary focus should be on determining whether the generated 
answer contains sufficient information to address the given question 
according to the ground truth answer...

If the generated answer contradicts the ground truth answer, it 
will receive a low score of 1-2.

For example, for the question "Is the sky blue?" the ground truth 
answer is "Yes, the sky is blue." and the generated answer is 
"No, the sky is not blue."

This inconsistency would result in a low score of 1-2...
```

**Example AI judge in action:**

![Diagram showing an AI judge receiving a question-answer pair and returning a score with explanation](../images/aien_0308.png)
###### Figure 3-8. An example of an AI judge that evaluates the quality of an answer given a question.

> **Important:** An AI judge is not just a model — it's a system of **model + prompt + sampling parameters**. Any change to any of these three things creates a different judge.

### Limitations of AI as a Judge

#### Inconsistency

AI judges are probabilistic. The same judge may give different scores to the same input on different runs.

- Including evaluation examples in the prompt can increase consistency from 65% to 77.5% (Zheng et al., 2023)
- However, more examples = longer prompts = 4× higher inference costs in that experiment
- High consistency doesn't mean high accuracy — the judge might consistently make the same mistakes

#### Criteria Ambiguity

Different tools define the "same" criterion very differently:

**Table 3-4: Different tools' prompts for "faithfulness"**

| Tool | Prompt Summary | Scoring |
|---|---|---|
| **MLflow** | "Faithfulness assesses how much of the provided output is factually consistent with the provided context. Score 1: none can be inferred. Score 5: all claims are supported." | 1–5 |
| **Ragas** | "Judge each statement: return 1 if it can be verified from context, 0 if it cannot." | 0 or 1 |
| **LlamaIndex** | "Tell if a given piece of information is supported by the context. Answer YES or NO." | YES/NO |

These scores are not comparable. If MLflow gives 3, Ragas gives 1, and LlamaIndex gives NO, which one do you trust?

> **Tip:** Never trust an AI judge if you can't see the model and the exact prompt used.

#### Increased Costs and Latency

- Using GPT-4 for both generation and evaluation doubles your API calls
- Adding 3 evaluation criteria means 4× the original API calls
- Evaluating before returning responses adds latency — unacceptable for low-latency apps

**Mitigation:** Use weaker models as judges, or **spot-check** (evaluate only a random subset of responses).

#### Biases of AI Judges

| Bias | Description | Example |
|---|---|---|
| **Self-bias** | A model favors its own outputs | GPT-4 gives itself a 10% higher win rate; Claude-v1 gives itself 25% higher |
| **First-position bias** | Favors the first option in a list | AI judges tend to pick option A over B regardless of quality |
| **Verbosity bias** | Favors longer responses regardless of quality | GPT-4 and Claude-1 prefer ~100-word responses with errors over ~50-word correct ones |
| **Recency bias** | (Humans only) Humans tend to favor the *last* response seen — opposite of AI |

> GPT-4 is less prone to verbosity bias than GPT-3.5, suggesting these biases may diminish as models improve.

### What Models Can Act as Judges?

| Scenario | Pros | Cons |
|---|---|---|
| **Stronger model judges weaker** | Better accuracy; can guide the weaker model | Expensive; the strongest model has no eligible judge |
| **Same model judges itself (self-critique)** | Good for sanity checks; can prompt self-revision | Self-bias; seems circular |
| **Weaker model judges stronger** | Cheaper; anyone can have an opinion on quality | May miss subtle errors |

**Self-evaluation example:**

```
Prompt:         What's 10 + 3?
First response: 30
Self-critique:  Is this answer correct?
Final response: No it's not. The correct answer is 13.
```

**Specialized judges (small, focused models):**

| Judge Type | Description | Example |
|---|---|---|
| **Reward model** | Scores (prompt, response) pairs on quality | Cappy (Google, 360M params): outputs 0–1 score |
| **Reference-based judge** | Evaluates generated response vs. reference responses | BLEURT: outputs similarity score; Prometheus: outputs 1–5 quality score |
| **Preference model** | Given (prompt, A, B), predicts which response users prefer | PandaLM, JudgeLM: outputs winner + rationale |

**PandaLM example output:**

![Diagram showing PandaLM receiving a human prompt and two AI responses, then outputting which response is better along with a rationale](../images/aien_0309.png)
###### Figure 3-9. An example output of PandaLM, given a human prompt and two generated responses. (Wang et al., 2023)

---

## Ranking Models with Comparative Evaluation

Often, you don't need absolute scores — you just need to know **which model is best for you**. Comparative evaluation ranks models by pitting them against each other.

| Approach | How it works |
|---|---|
| **Pointwise** | Evaluate each model independently, give a score, rank by score |
| **Comparative** | Show two responses at once, pick the better one; compute rankings from win/loss records |

> **Why comparative is often easier:** It's easier to say "this song is better than that one" than to give each song a score from 1 to 100.

Comparative evaluation was first used in AI by Anthropic (2021). LMSYS Chatbot Arena is the most famous public comparative leaderboard.

**ChatGPT uses it internally too:**

![Screenshot of ChatGPT showing two responses side-by-side and asking the user to pick which one they prefer](../images/aien_0310.png)
###### Figure 3-10. ChatGPT occasionally asks users to compare two outputs side by side.

### How Comparative Evaluation Works

For each request, two or more models generate responses. An evaluator (human or AI) picks the winner. Ties are allowed.

**Table 3-5: Example pairwise comparison history**

| Match # | Model A | Model B | Winner |
|---|---|---|---|
| 1 | Model 1 | Model 2 | Model 1 |
| 2 | Model 3 | Model 10 | Model 10 |
| 3 | Model 7 | Model 4 | Model 4 |

The **win rate** of A over B = % of A vs. B matches that A won.

**Table 3-6: Example win rates for 5 models**

| Model Pair | Model A | Model B | # Matches | A wins |
|---|---|---|---|---|
| 1 | Model 1 | Model 2 | 1,000 | 90% |
| 2 | Model 1 | Model 3 | 1,000 | 40% |
| 3 | Model 1 | Model 4 | 1,000 | 15% |
| 4 | Model 1 | Model 5 | 1,000 | 10% |
| 5 | Model 2 | Model 3 | 1,000 | 60% |
| 6 | Model 2 | Model 4 | 1,000 | 80% |
| 7 | Model 2 | Model 5 | 1,000 | 80% |
| 8 | Model 3 | Model 4 | 1,000 | 70% |
| 9 | Model 3 | Model 5 | 1,000 | 10% |
| 10 | Model 4 | Model 5 | 1,000 | 20% |

From this table, it's not obvious which model is best. A **rating algorithm** converts these pairwise signals into a ranking.

**Rating algorithms used in practice:**
- **Elo** — originally from chess; sensitive to the order of comparisons
- **Bradley–Terry** — used by LMSYS Chatbot Arena (switched from Elo because Elo was sensitive to comparison ordering)
- **TrueSkill** — used in video games

> **A ranking is correct if:** For any pair of models, the higher-ranked one wins more than 50% of the time against the lower-ranked one.

> **A/B testing vs. comparative evaluation:** In A/B testing, a user sees one model at a time. In comparative evaluation, a user sees both models at the same time.

### Challenges of Comparative Evaluation

#### Scalability Bottlenecks

The number of model pairs grows quadratically with the number of models:
- 57 models = 1,596 model pairs
- In January 2024, LMSYS used 244,000 comparisons = only ~153 per pair

**Transitivity assumption:** If A > B and B > C, then A > C — you don't need to compare A vs. C directly. But human preference is not always transitive.

Evaluating new models is expensive — they must be compared against all existing models.

#### Lack of Standardization and Quality Control

**LMSYS Chatbot Arena's community approach:**
- Anyone can submit any prompt
- 180 entries were just "hello" or "hi"
- Some users pick toxic responses, polluting rankings
- Testers don't use RAG or sophisticated prompting, so results don't reflect real-world workflows

**Mitigations:**
- LMSYS internally filters for "hard prompts" and ranks using only those
- Scale uses trained human evaluators for their private leaderboard (expensive)
- Some products embed comparative evaluation into the user's actual workflow (e.g., show two code snippets inside a code editor)

> Some teams prefer AI evaluators over random internet users — AI may not be as good as trained experts but may be more reliable than untrained volunteers.

#### From Comparative to Absolute Performance

Comparative evaluation tells you which model is better — not whether it's good enough.

Example: Model B wins against Model A 51% of the time. But:
- Scenario 1: B is good, A is bad
- Scenario 2: Both are bad
- Scenario 3: Both are good

A 1% win rate can mean a huge performance boost in one application and almost nothing in another. Without knowing absolute performance, you can't do a cost–benefit analysis for whether the more expensive Model B is worth it over Model A.

### The Future of Comparative Evaluation

Despite its challenges, comparative evaluation has unique strengths:

| Strength | Why it matters |
|---|---|
| **Never saturates** | There's always a next model to compare against; no benchmark ceiling |
| **Captures what matters** | Measures human preference directly, not a proxy |
| **Hard to game** | No reference data to train on; LMSYS's crowd voting is relatively robust |
| **Works for superhuman AI** | Even if you can't score a response, you can tell which of two responses you prefer |

> The Llama 2 paper noted that when models write better than the best human annotators, humans can still detect which model response is better — comparative evaluation may be the last evaluation method standing as AI surpasses humans.

---

## Summary

This chapter covered the four major approaches to evaluating foundation models:

| Approach | Type | When to use | Limitations |
|---|---|---|---|
| **Functional correctness** | Exact | Code, SQL, game bots, tasks with measurable objectives | Hard to automate for most tasks |
| **Similarity measurements** (exact match, lexical, semantic) | Exact | Tasks with reference data | Exact match is too strict; lexical misses meaning; all depend on reference quality |
| **AI as a judge** | Subjective | Any task; works without reference data; explains reasoning | Inconsistent, biased, criteria ambiguous, adds cost/latency |
| **Comparative evaluation** | Subjective | Ranking models; capturing human preference | Quadratic scaling; no absolute scores; hard to standardize |

**Key language modeling metrics:**

| Metric | What it measures |
|---|---|
| **Entropy** | Inherent unpredictability of the language/data |
| **Cross entropy** | How well the model learned the data distribution |
| **BPC / BPB** | Cross entropy normalized per character or byte |
| **Perplexity** | Exponential of cross entropy; model's uncertainty per token |

**Key takeaways:**
- Evaluation is the hardest part of AI engineering — more investment is needed
- No single evaluation method is sufficient; use multiple in combination
- Always know the model and prompt behind any AI judge you trust
- Comparative evaluation never saturates and captures real human preference
- As AI surpasses humans, comparative evaluation may be the only evaluation method that scales

The next chapter covers how to build a systematic **evaluation pipeline** using these methods to select models and continuously improve AI applications in production.
