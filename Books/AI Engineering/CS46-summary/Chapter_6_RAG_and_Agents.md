# Chapter 6: RAG and Agents

---

## Overview

To solve a task, a model needs both **instructions** (how to do it) and **context** (the information needed to do it). Just like a human is more likely to give wrong answers when they lack information, AI models hallucinate more when they lack context.

Chapter 5 covered how to write good instructions. This chapter focuses on **how to construct the right context** for each query.

Two dominant patterns for context construction:

| Pattern | What it does |
|---|---|
| **RAG** (Retrieval-Augmented Generation) | Retrieves relevant information from external sources to augment the model's context |
| **Agents** | Uses tools (web search, calculators, APIs, databases) to gather information and act on the world |

RAG provides context. Agents can do RAG *and* much more — they can take actions that change the world.

---

## RAG

### What is RAG?

RAG is a technique that enhances a model's generation by **retrieving relevant information from external memory** and including it in the context before generating a response.

The **retrieve-then-generate** pattern was first introduced in 2017 (Chen et al., "Reading Wikipedia to Answer Open-Domain Questions"):

![Diagram showing the retrieve-then-generate pattern: question goes in, retriever fetches 5 Wikipedia pages, document reader generates the answer](../images/aien_0601.png)
###### Figure 6-1. The retrieve-then-generate pattern. The model was referred to as the *document reader*.

The term **"retrieval-augmented generation"** was coined in 2020 (Lewis et al., Facebook). The paper showed that having access to relevant information helps the model:
- Generate **more detailed** responses
- Reduce **hallucinations**

> **Analogy:** RAG is to context construction what feature engineering is to classical machine learning — both are about giving the model the information it needs to process an input.

**Will long context make RAG obsolete?**  
No, for two reasons:
1. Data grows faster than context windows. There will always be applications needing more context than any model supports.
2. Longer context doesn't mean better processing — models focus poorly on the middle of long contexts (see Chapter 5 NIAH tests). RAG helps models use *only the most relevant* information per query, reducing noise.

> **Anthropic's guidance:** For knowledge bases under 200,000 tokens (~500 pages), you can include the whole thing in the prompt. For larger bases, use RAG.

---

### RAG Architecture

A RAG system has two components:

1. **Retriever** — finds information from external sources relevant to a query
2. **Generator** — generates a response using the retrieved information

![Diagram of a basic RAG architecture: user query → retriever → relevant chunks from database → prompt + context → generator → response](../images/aien_0602.png)
###### Figure 6-2. A basic RAG architecture.

**How a basic RAG system works:**
1. Documents are split into **chunks** (manageable pieces)
2. Chunks are **indexed** for fast retrieval
3. For each query, the retriever fetches the most relevant chunks
4. The chunks are joined with the user prompt to form the final prompt
5. The generative model produces the response

> **Key insight:** The success of a RAG system depends on the quality of its retriever.

---

## Retrieval Algorithms

Retrieval ranks documents by relevance to a query. Two main approaches:

### Term-Based Retrieval (Lexical Retrieval)

The simplest way: find documents that **contain the same keywords** as the query.

**Problem 1:** Many documents may contain the keyword. Which ones are most relevant? → Use **term frequency (TF)**: the more times a term appears in a document, the more relevant it probably is.

**Problem 2:** Not all terms in a query are equally important. "Vietnamese" in "Easy Vietnamese recipes for home cooking" is more informative than "for" or "at". → Use **inverse document frequency (IDF)**: a term is more important if fewer documents contain it.

**TF-IDF** combines both:

```
Score(D, Q) = Σ IDF(t) × f(t, D)

where:
  D = document being scored
  Q = query
  t = each term in Q
  f(t, D) = how many times t appears in D  [term frequency]
  IDF(t) = log(N / C(t))                   [inverse document frequency]
  N = total documents
  C(t) = documents that contain t
```

**Inverted index** — a data structure that maps terms to documents, enabling fast keyword-based lookup:

**Table 6-1: A simplified inverted index**

| Term | Document count | (Document index, term frequency) |
|---|---|---|
| banana | 2 | (10, 3), (5, 2) |
| machine | 4 | (1, 5), (10, 1), (38, 9), (42, 5) |
| learning | 3 | (1, 5), (38, 7), (42, 5) |

**Popular term-based tools:**
- **Elasticsearch** — built on Lucene, uses inverted index, very widely deployed
- **BM25 (Okapi BM25)** — 25th iteration of Best Matching algorithm; improves TF-IDF by normalizing for document length; still considered a very strong baseline

**Tokenization matters:** "hot dog" split into "hot" and "dog" loses meaning. Solutions: use n-grams as terms, lowercase all text, remove stop words.

### Embedding-Based Retrieval (Semantic Retrieval)

Term-based retrieval matches *words*, not *meaning*. "Transformer architecture" might return documents about the electric device or the Transformers movie.

**Embedding-based retrieval** ranks documents by how closely their *meanings* align with the query.

**How it works:**

1. During indexing: convert all documents into **embedding vectors** and store them in a **vector database**
2. At query time:
   - Convert the query into an embedding using the **same embedding model**
   - Find the **k nearest embedding vectors** in the database

![Diagram showing embedding-based retrieval: query → embedding model → query vector → vector database → top-k most similar chunks](../images/aien_0603.png)
###### Figure 6-3. A high-level view of how an embedding-based, or semantic, retriever works.

**Vector search algorithms:**

The naive approach (k-NN) computes similarity between the query and *every* vector in the database — accurate but very slow for large datasets.

For large datasets, use **ANN (Approximate Nearest Neighbor)** algorithms:

| Algorithm | How it works |
|---|---|
| **LSH** (Locality-Sensitive Hashing) | Hashes similar vectors into the same buckets for fast lookup; trades accuracy for speed |
| **HNSW** (Hierarchical Navigable Small World) | Builds a multi-layer graph where edges connect similar vectors; traverses graph edges for search |
| **Product Quantization** | Compresses vectors by decomposing them into smaller sub-vectors; much faster distance computation |
| **IVF** (Inverted File Index) | Uses k-means clustering to group similar vectors; searches only the nearest cluster(s) |
| **Annoy** (Spotify) | Builds multiple binary trees, splits vectors randomly; fast tree traversal for search |

**Popular libraries:** FAISS (Facebook), ScaNN (Google), Annoy (Spotify), Hnswlib

**The "sparse vs. dense" divide:**
- Term-based retrieval → **sparse** vectors (mostly zeros; each dimension = one vocabulary word)
- Embedding retrieval → **dense** vectors (most dimensions have values)
- SPLADE: sparse *embeddings* — gets benefits of both (dense semantics, sparse efficiency)

### Comparing Retrieval Algorithms

**Table 6-2: Term-based vs. Embedding-based retrieval**

|  | Term-based retrieval | Embedding-based retrieval |
|---|---|---|
| **Querying speed** | Much faster | Slower — embedding generation + vector search add latency |
| **Performance** | Strong out of the box; hard to improve; can fail on term ambiguity | Can outperform with finetuning; handles natural language queries well |
| **Cost** | Much cheaper | Embedding, vector storage, and vector search can be expensive (sometimes 1/5 to 1/2 of total AI API spend) |

**Evaluating retrieval quality:**

| Metric | What it measures |
|---|---|
| **Context precision** (context relevance) | Of all retrieved documents, what % is actually relevant? |
| **Context recall** | Of all relevant documents, what % was retrieved? |
| **NDCG / MAP / MRR** | Ranking quality — are more relevant documents ranked first? |

For embedding quality specifically, the **MTEB benchmark** (Muennighoff et al., 2023) evaluates across retrieval, classification, and clustering tasks.

For vector search algorithm comparison, **ANN-Benchmarks** compares algorithms on: recall, queries per second (QPS), build time, and index size.

### Combining Retrieval Algorithms

**Hybrid search** = term-based + embedding-based used together. This is standard in production systems.

**Two patterns:**

**1. Sequential (retrieve then rerank):**
- Step 1: Cheap term-based retriever gets many candidates quickly
- Step 2: Expensive embedding-based search reranks the candidates to find the best ones

Example: Query "transformer" → term search fetches all documents mentioning "transformer" (electric device, neural net, movie) → vector search picks only the neural architecture ones.

**2. Parallel (ensemble/fusion):**
- Multiple retrievers run simultaneously
- Their rankings are combined using **Reciprocal Rank Fusion (RRF)**

**RRF formula:**

```
Score(D) = Σᵢ 1 / (k + rᵢ(D))

where:
  n = number of retrievers (ranked lists)
  rᵢ(D) = rank of document D by retriever i
  k = constant (typically 60) to smooth the influence of lower-ranked docs
```

**Intuition:** A document ranked 1st by retriever A and 2nd by retriever B gets score 1/1 + 1/2 = 1.5. High from both = high combined score.

---

## Retrieval Optimization

### Chunking Strategy

Long documents must be split into chunks before indexing. Chunk size affects everything.

**Common chunking strategies:**

| Strategy | How it works |
|---|---|
| **Fixed size** | Split into chunks of N characters, words, sentences, or paragraphs |
| **Recursive** | Split by sections → paragraphs → sentences, until each piece is small enough |
| **Domain-specific** | Code splitters by language, Q&A pairs for support docs, etc. |
| **Token-based** | Tokenize with the generative model's tokenizer, then split by token count |

**Overlapping chunks:** Without overlap, chunks may cut off in the middle of important context. "I left my wife a note" split into "I left my wife" + "a note" loses the meaning. Set a small overlap (e.g., 20 characters per 2,048-character chunk) to ensure boundary information appears in at least one chunk.

**Size tradeoffs:**

| Smaller chunks | Larger chunks |
|---|---|
| More diverse information; fit more chunks into context | Retain more context within each chunk |
| More chunks → more embeddings → higher cost and slower search | Fewer chunks → faster search |
| Risk losing information spread across a document | Risk including irrelevant information |

> There is no universal best chunk size. Experiment for your use case.

### Reranking

Initial retrieval rankings can be further refined:
- Use a more precise (but expensive) ranker to reorder the initial candidates
- Rerank by **recency** — give more weight to newer data (useful for news, emails, stock analysis)

Context reranking differs from search ranking: the exact position matters less in context (as long as the document is included), but documents near the beginning and end of context tend to be processed better.

### Query Rewriting

When users ask follow-up questions, their query may be ambiguous without context:

```
User: When was the last time John Doe bought something from us?
AI: John last bought a Fruity Fedora hat from us two weeks ago, on January 3, 2030.
User: How about Emily Doe?
```

The query "How about Emily Doe?" is meaningless on its own for retrieval. It needs to be rewritten to: "When was the last time Emily Doe bought something from us?"

AI models can do this rewriting automatically:

![Screenshot of ChatGPT receiving a conversation and rewriting the ambiguous follow-up query into a standalone question](../images/aien_0604.png)
###### Figure 6-4. You can use other generative models to rewrite queries.

**Prompt:** "Given the following conversation, rewrite the last user input to reflect what the user is actually asking."

> ⚠️ Query rewriting can fail when identity resolution is needed. "How about his wife?" requires knowing who "his wife" is — if not found in the database, the system must acknowledge the gap rather than hallucinate a name.

### Contextual Retrieval

Augment each chunk with extra context to make it easier to retrieve.

**Techniques:**
- Add metadata: tags, keywords, entity names (e.g., error code `EADDRNOTAVAIL (99)`)
- Add questions the chunk can answer (for customer support: "How to reset password?", "I can't log in")
- For split documents: add the document title and summary to each chunk

**Anthropic's approach:** Use an AI model to generate a short (50–100 token) context summary for each chunk explaining its role in the original document.

```
<document> 
{{WHOLE_DOCUMENT}} 
</document>

Here is the chunk we want to situate within the whole document: 

<chunk>
{{CHUNK_CONTENT}}
</chunk> 

Please give a short succinct context to situate this chunk within the overall 
document for the purposes of improving search retrieval of the chunk. Answer 
only with the succinct context and nothing else.
```

This generated context is prepended to the chunk before indexing:

![Diagram showing Anthropic's contextual retrieval process: whole document + chunk → AI generates situating context → context prepended to chunk → indexing](../images/aien_0605.png)
###### Figure 6-5. Anthropic augments each chunk with a short context that situates this chunk within the original document. Image from "Introducing Contextual Retrieval" (Anthropic, 2024).

---

## RAG Beyond Texts

### Multimodal RAG

If the generator can handle multiple modalities, context can be augmented with images, video, and audio — not just text.

For image retrieval by content (not metadata), use a **multimodal embedding model** like CLIP:

1. Generate CLIP embeddings for all documents *and* images
2. Generate CLIP embedding for the query
3. Find images/texts whose embeddings are nearest to the query

Example: Query "What's the color of the house in the Pixar movie Up?" → retriever fetches both relevant text and an image of the house:

![Diagram of multimodal RAG showing text and image retrieval being combined in the context before the generator produces a response](../images/aien_0606.png)
###### Figure 6-6. Multimodal RAG can augment a query with both text and images. (*The real image from *Up* is not used, for copyright reasons.)

### RAG with Tabular Data

Many queries need information from structured data tables. Text-based RAG doesn't apply — instead, you use **Text-to-SQL**.

**Example:** Kitty Vogue ecommerce site with a Sales table:

**Table 6-3: Sales table for Kitty Vogue**

| Order ID | Timestamp | Product ID | Product | Unit price ($) | Units | Total |
|---|---|---|---|---|---|---|
| 1 | … | 2044 | Meow Mix Seasoning | 10.99 | 1 | 10.99 |
| 2 | … | 3492 | Purr & Shake | 25 | 2 | 50 |
| 3 | … | 2045 | Fruity Fedora | 18 | 1 | 18 |

**Query:** "How many units of Fruity Fedora were sold in the last 7 days?"

**Generated SQL:**
```sql
SELECT SUM(units) AS total_units_sold 
FROM Sales
WHERE product_name = 'Fruity Fedora' 
  AND timestamp >= DATE_SUB(CURDATE(), INTERVAL 7 DAY);
```

**Tabular RAG workflow:**

![Diagram showing text-to-SQL RAG: user query → AI generates SQL → SQL executor runs query → results feed back into context → AI generates final response](../images/aien_0607.png)
###### Figure 6-7. A RAG system that augments context with tabular data.

1. **Text-to-SQL:** Convert the natural language query into SQL based on the table schema
2. **SQL execution:** Run the SQL query against the database
3. **Generation:** Use the SQL result + original query to generate the final response

---

## Agents

### What Is an Agent?

An agent is anything that **perceives its environment** and **acts upon that environment**. An AI-powered agent uses a foundation model as its "brain" to plan and execute actions.

> From *Artificial Intelligence: A Modern Approach* (Russell & Norvig, 1995): AI research is "the study and design of rational agents."

Two defining properties of an agent:

1. **Environment** — the world the agent operates in (a game, a computer, the internet, a kitchen)
2. **Tool inventory** — the set of actions the agent can perform

**Examples of agents you already know:**
- **ChatGPT** — can search the web, execute Python code, generate images
- **RAG systems** — the retriever is a tool; the whole system is a simple agent
- **SWE-agent** (GPT-4 powered) — operates in a computer environment with file navigation, search, and editing tools:

![Screenshot of SWE-agent interface showing navigation, search, view, and edit actions in a terminal and file system environment](../images/aien_0608.png)
###### Figure 6-8. SWE-agent (Yang et al., 2024) is a coding agent whose environment is the computer. Adapted from an original image licensed under CC BY 4.0.

**Why agents need powerful models:**
- **Compound errors:** 95% accuracy per step × 10 steps = 60% overall accuracy. × 100 steps = 0.6%.
- **Higher stakes:** With tools, agents can do more impactful things — and failures have more severe consequences.

---

## Tools

Tools give agents the ability to interact with the world. Three categories:

### 1. Knowledge Augmentation Tools

Help the agent gather information:
- Text retriever (standard RAG)
- Image/video retriever
- SQL executor
- Web browser / search APIs
- News APIs, GitHub APIs, Slack retrieval, email reader
- Internal inventory APIs, people search

**Web browsing** prevents a model from going stale — it can access current stock prices, news, weather, flight status, and more. Without it, a model is limited to its training data cutoff.

> ⚠️ Web browsing also exposes the agent to bad content on the internet. Choose your internet APIs carefully.

### 2. Capability Extension Tools

Address inherent model limitations:
- **Calculator** — AI models are famously bad at arithmetic; a calculator trivially fixes this
- **Calendar, timezone converter, unit converter**
- **Translator** — for languages the model doesn't know well
- **Code interpreter** — execute code, return results, analyze failures (enables coding assistants, data analysts, research agents)

**Making text-only models multimodal via tools:**
- Text → image: use DALL-E (how ChatGPT generates images)
- Image → text: use an image captioning tool
- Audio → text: use a transcription tool
- PDF → text: use OCR

**Performance impact of tools:**  
Chameleon (Lu et al., 2023): a GPT-4 agent augmented with 13 tools outperformed GPT-4 alone on multiple benchmarks:
- ScienceQA: improved best published few-shot result by **+11.37%**
- TabMWP: improved accuracy by **+17%**

### 3. Write Actions

Read-only tools observe the world. **Write actions** change it:
- SQL UPDATE / DELETE
- Send emails, post messages
- Initiate bank transfers
- Merge code, update databases

Write actions unlock enormous automation possibilities (full customer outreach workflows, automated research pipelines) but introduce serious risks. Security is critical — see Chapter 5 for defensive measures.

> As important as it is to be cautious, the fact that an AI can write to the world doesn't mean it shouldn't. Just as we trust cranes to build skyscrapers, we can build AI systems with sufficient safeguards to act reliably. The key is trust built through rigorous security measures.

---

## Planning

Planning = deciding **what sequence of actions** to take to accomplish a task.

### Planning Overview

Given a task like "How many companies without revenue have raised at least $1 billion?", two approaches:

1. Find all companies without revenue → filter by $1B raised
2. Find all companies that raised $1B → filter by no revenue ← **more efficient** (far fewer $1B+ companies than zero-revenue companies)

A good planner picks option 2.

**Decouple planning from execution:**

If you let the model plan and execute all in one prompt (e.g., with chain-of-thought), a bad 1,000-step plan could run for hours before you realize it's going nowhere.

Better approach: **validate the plan before executing it**.

![Flowchart showing plan generation → plan validation (good/bad) → if good, execution → if bad, generate new plan](../images/aien_0609.png)
###### Figure 6-9. Decoupling planning and execution so that only validated plans are executed.

**Validation heuristics:**
- Remove plans with invalid actions (uses tools not in the inventory)
- Remove plans with too many steps
- Use AI judges to evaluate whether the plan is reasonable

**Human-in-the-loop:** Humans can validate plans, approve risky steps (database modifications, code merges), or provide high-level plans the agent can expand on.

**Typical agent workflow:**
1. **Plan generation** — decompose the task into manageable steps
2. **Reflection** — evaluate the plan; if bad, generate a new one
3. **Execution** — invoke the planned actions
4. **Reflection** — evaluate outcomes; correct errors; if goal not met, generate a new plan

### Can Foundation Models Plan?

Controversial topic. Meta's Yann LeCun says autoregressive LLMs **cannot** plan. Others disagree.

**The argument against:** Autoregressive models only generate forward — they can't backtrack.  
**The counter-argument:** A model that finds a path isn't working after execution can revise its plan, effectively backtracking.

**Key insight:** Planning is fundamentally a **search problem** — search among possible action sequences, predict outcomes, pick the best one. For this, a model needs to know the consequences of each action, not just the available actions. "Reasoning with Language Model is Planning with World Model" (Hao et al., 2023) argues that LLMs, containing vast world knowledge, can predict action outcomes.

> Whether LLMs can plan may also depend on how we prompt and augment them — not just on their architecture.

### Plan Generation

**Simplest approach:** Prompt engineering. Example system prompt for a Kitty Vogue shopping agent:

```
SYSTEM PROMPT:
Propose a plan to solve the task. You have access to 5 actions:          
  get_today_date()
  fetch_top_products(start_date, end_date, num_products)
  fetch_product_info(product_name)
  generate_query(task_history, tool_output)
  generate_response(query)

The plan must be a sequence of valid actions.

Examples:
Task: "Tell me about Fruity Fedora"
Plan: [fetch_product_info, generate_query, generate_response]

Task: "What was the best selling product last week?"
Plan: [fetch_top_products, generate_query, generate_response]

Task: {USER INPUT}
Plan:
```

**Given:** "What's the price of the best-selling product last week?"  
**Generated plan:**

```
1. get_time()
2. fetch_top_products()
3. fetch_product_info()
4. generate_query()
5. generate_response()
```

Parameters are inferred from previous step outputs. For example, if `get_time()` returns "2030-09-13", the next call becomes:

```
retrieve_top_products(
    start_date="2030-09-07",
    end_date="2030-09-13",
    num_products=1
)
```

> ⚠️ Both the action sequence and parameters are AI-generated — they can be hallucinated. Tip: always ask the agent to report what parameter values it uses, and inspect them.

**Improving planning:**
- Better system prompt with more examples
- Better tool descriptions (so the model understands what each tool does)
- Simpler tools (refactor complex functions into two simpler ones)
- Stronger model
- Finetune a model specifically for plan generation

### Function Calling

Most model APIs now support **function calling** (tool use). In general:

1. **Declare tools:** Each tool is described by its name, parameters, and what it does
2. **Specify tool use per query:** `required` (must use a tool), `none` (no tools), `auto` (model decides)

![Pseudocode screenshot showing function declarations and a model call that returns a tool_calls response with function name and arguments](../images/aien_0610.png)
###### Figure 6-10. An example of a model using two simple tools.

Example response for "How many kilograms are 40 pounds?":

```python
response = ModelResponse(
    finish_reason='tool_calls',
    message=chat.Message(
        content=None,
        role='assistant',
        tool_calls=[
            ToolCall(
                function=Function(
                    arguments='{"lbs": 40}',
                    name='lbs_to_kg'
                ),
                type='function'
            )
        ]
    )
)
```

You then call `lbs_to_kg(lbs=40)` and use the result to generate the final response.

### Planning Granularity

Plans can use **exact function names** (precise but brittle to tool changes) or **natural language** (more robust).

Natural language plan for "What's the price of the best-selling product last week?":

```
1. get current date
2. retrieve the best-selling product last week
3. retrieve product information
4. generate query
5. generate response
```

Using natural language makes the planner robust to API changes. A translator (weaker model) converts each step to executable commands — easier than planning, lower hallucination risk.

### Complex Plans — Control Flows

Plans aren't always sequential. Different control flows:

![Diagram showing four control flow types: sequential (A→B), parallel (A and B simultaneously), if statement (A→B or C), for loop (A repeats until condition)](../images/aien_0611.png)
###### Figure 6-11. Examples of different orders in which a plan can be executed.

| Control flow | When to use |
|---|---|
| **Sequential** | Step B depends on output from step A |
| **Parallel** | Steps A and B are independent — run simultaneously to save time |
| **If statement** | Based on a result, decide between two different next steps |
| **For loop** | Repeat an action until a condition is met |

> Parallel execution can dramatically reduce latency. Example: checking 10 websites simultaneously vs. one at a time.

### Reflection and Error Correction

Even good plans need ongoing evaluation. **Reflection** = evaluating intermediate and final results to catch and fix errors.

**When to reflect:**
- After receiving a user query (is this feasible?)
- After initial plan generation (does the plan make sense?)
- After each execution step (are we on track?)
- After the whole plan executes (was the task completed?)

**ReAct framework** (Yao et al., 2022) — interleave reasoning and action:

```
Thought 1: [planning/reflection]
Act 1: [action]
Observation 1: [result]

Thought 2: [planning/reflection]
Act 2: [action]
...

Thought N: [planning/reflection]
Act N: Finish [final response]
```

![Screenshot of a ReAct agent working through a multi-hop question with alternating Thought, Act, and Observation steps](../images/aien_0612.png)
###### Figure 6-12. A ReAct agent in action. Image from the ReAct paper (Yao et al., 2022).

**Reflexion framework** (Shinn et al., 2023) — separate evaluator + self-reflection:
1. Evaluator scores the outcome
2. Self-reflection module analyzes what went wrong
3. Agent generates a new trajectory

![Screenshot showing Reflexion agents proposing new trajectories after each evaluation + self-reflection cycle](../images/aien_0613.png)
###### Figure 6-13. Examples of how Reflexion agents work. Images from the Reflexion GitHub repo.

**Example:** Coding task where generated code fails 1/3 of test cases → agent reflects that it didn't handle arrays of all negative numbers → agent generates new code with the fix.

> **Tradeoff:** Reflection adds latency and cost. Every thought and observation takes tokens to generate. ReAct and Reflexion both use many examples in their prompts, increasing cost further.

### Tool Selection

No universal guide exists. Tools to give an agent depend on the environment, task, and the model's capabilities.

**Experiments in literature:**
- Toolformer: 5 tools
- Chameleon: 13 tools
- Gorilla: 1,645 APIs

**How to select and refine tool inventory:**
- Compare performance with different tool sets
- **Ablation study:** Remove tools one by one; if removing a tool doesn't hurt performance, remove it permanently
- Look for tools the agent frequently misuses — if extensive prompting and finetuning can't fix it, replace the tool
- **Plot tool use distribution:**

![Bar charts showing tool use patterns for GPT-4 vs ChatGPT — GPT-4 selects more diverse tools while ChatGPT favors image captioning](../images/aien_0614.png)
###### Figure 6-14. Different models and tasks express different tool use patterns. Image from Lu et al. (2023).

**Key finding (Chameleon):**
1. Different tasks need different tools (ScienceQA → knowledge retrieval; TabMWP → math tools)
2. Different models prefer different tools (GPT-4 picks wider variety; ChatGPT prefers image captioning)

**Tool composition:** Frequently co-used tools can be combined into one bigger tool. **Voyager** (Wang et al., 2023) proposes a **skill manager** — an agent that creates new tools from existing ones and stores them in a skill library for reuse:

![Diagram of a tool transition tree showing common sequences of tool calls, highlighting pairs that are frequently used together](../images/aien_0615.png)
###### Figure 6-15. A tool transition tree by Lu et al. (2023).

---

## Agent Failure Modes and Evaluation

Agents have unique failure modes beyond standard AI failures.

### Planning Failures

**Tool use failures:**

| Failure type | Example |
|---|---|
| **Invalid tool** | Plan calls `bing_search`, which isn't in the inventory |
| **Valid tool, invalid parameters** | Calls `lbs_to_kg(lbs, kg)` — but it only takes one parameter |
| **Valid tool, wrong parameter values** | Calls `lbs_to_kg(lbs=100)` when the correct value should be 120 |

**Goal failures:**
- Agent solves the wrong task (plans a trip to Ho Chi Minh City when asked for Hanoi)
- Agent solves the task but violates constraints (trip goes $2,000 over budget)
- Agent misjudges time (finishes the grant proposal after the deadline)
- **Reflection error:** Agent believes it completed the task when it hasn't (assigned 40 people when 50 were needed)

**Metrics to track:**
1. What % of generated plans are valid?
2. How many plan attempts before getting a valid plan?
3. What % of tool calls are valid?
4. How often are invalid tools called?
5. How often are valid tools called with wrong parameters?
6. How often are correct tools called with wrong values?

### Tool Failures

- Tool gives wrong output (image captioner misidentifies; SQL generator produces wrong query)
- Translation module converts a natural language plan step incorrectly
- Missing tools — agent tries to do something it has no tool for

> Always print each tool call and its output during development. Test each tool independently.

### Efficiency

- How many steps does the agent need to complete a task on average?
- What is the average cost per task?
- Which actions are slowest or most expensive?

> Compare to a human baseline — but remember that humans and AI have very different operational modes. Browsing 100 web pages is impractical for a human but trivial for a parallel AI agent.

---

## Memory

Memory allows a model to **retain and utilize information** across steps and sessions.

**Three memory mechanisms:**

| Type | What it is | Analogy |
|---|---|---|
| **Internal knowledge** | The model itself — everything it learned during training | How to breathe — you just know it |
| **Short-term memory** | The current context window — recent messages, tool outputs | The name of someone you just met |
| **Long-term memory** | External databases (like RAG) that persist across tasks | Books, notes, computers |

![Diagram showing the three memory types: internal knowledge at the core, short-term memory in the context window, and long-term memory in external databases](../images/aien_0616.png)
###### Figure 6-16. The hierarchy of information for an agent.

**When to use which:**

| Information type | Where to store |
|---|---|
| Needed for all tasks | Internal knowledge (training / finetuning) |
| Rarely needed | Long-term memory (external database) |
| Immediately relevant to this task | Short-term memory (context) |

### Benefits of External Memory

| Benefit | How it helps |
|---|---|
| **Manage context overflow** | When a task generates more info than fits in context, move excess to external storage |
| **Persist between sessions** | An AI coach that remembers your history is far more useful than one that forgets you each session |
| **Improve consistency** | If the model can reference previous answers, it gives more consistent responses |
| **Maintain data structure** | Store data in Excel, queues, or structured formats instead of unstructured text |

### Memory Management Strategies

Managing short-term memory (limited by context length) is the key challenge.

**FIFO (First In, First Out):** Remove the oldest messages when context gets full.
- Simple to implement
- Risk: early messages (which often state the task purpose) may be more important than recent ones

**Summarization:** Compress old conversation into a summary + tracked entities.
- More sophisticated
- Reduces token footprint significantly

**Reflection-based (Liu et al., 2023):** After each action, the agent:
1. Reflects on newly generated information
2. Decides whether to insert it into memory, merge it with existing memory, or replace outdated information

> When new and old information contradict each other: some systems keep the newer version; others ask an AI model to judge which is more reliable. The right approach depends on the use case.

---

## Summary

Both RAG and agents expand what AI models can do by giving them access to information and tools beyond their training data.

**RAG recap:**

| Component | Key points |
|---|---|
| **Architecture** | Retriever + Generator; success depends on retriever quality |
| **Term-based retrieval** | Fast, cheap, strong baseline; can fail on term ambiguity |
| **Embedding-based retrieval** | Semantic understanding; expensive; can outperform term-based with tuning |
| **Hybrid search** | Combine both for best results; use RRF for fusion |
| **Chunking** | Size and overlap matter; experiment to find what works |
| **Reranking** | Refine initial results for better precision |
| **Query rewriting** | Handle ambiguous follow-up questions |
| **Contextual retrieval** | Augment chunks with context so the retriever finds them better |

**Agent recap:**

| Component | Key points |
|---|---|
| **Definition** | Environment + tool inventory; AI is the planner |
| **Knowledge tools** | RAG, web search, APIs |
| **Capability tools** | Calculator, code interpreter, translator, multimodal conversion |
| **Write tools** | Can change the world; require strict security measures |
| **Planning** | Decouple planning from execution; validate before running |
| **Reflection** | ReAct (interleaved reasoning) and Reflexion (separate evaluator + self-reflection) |
| **Tool selection** | Experiment; ablation; track tool use distribution |
| **Failure modes** | Planning failures, tool failures, efficiency |

**Memory recap:**
- Internal knowledge (training) → short-term memory (context) → long-term memory (external databases)
- Choose where to store information based on how often it's needed
- Manage context overflow with FIFO, summarization, or reflection-based strategies

RAG and agents are prompt-based methods — they improve model behavior through inputs, without changing the model itself. The next chapter covers **finetuning** — modifying the model itself to open up even more possibilities.
