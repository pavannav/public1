# Chapter 1: Introduction to Building AI Applications with Foundation Models

---

## Overview

If you had to pick one word to describe AI after 2020, it would be **scale**. Today's AI models — the ones powering ChatGPT, Google's Gemini, and Midjourney — consume a significant portion of the world's electricity, and researchers worry we may run out of publicly available internet data to train them.

This chapter explains:
- What **foundation models** are and how they came to exist
- A wide range of **real-world AI use cases**
- How to **plan and evaluate** an AI application before building it
- The **AI engineering stack** and how it differs from traditional ML engineering

---

## The Rise of AI Engineering

### From Language Models to Large Language Models

#### Language Models

A **language model** captures statistical patterns of language — essentially, how likely a word (or token) is to appear given what came before it.

> **Simple analogy:** In Sherlock Holmes's 1905 story "The Adventure of the Dancing Men," Holmes cracked a code by knowing that the most common letter in English is *E* — the same statistical thinking that underlies language models.

The basic unit of a language model is a **token** — which can be a character, a whole word, or part of a word (like `-tion`). The process of splitting text into tokens is called **tokenization**.

**Example:** GPT-4 breaks the phrase *"I can't wait to build AI applications"* into **9 tokens**:

![Tokenization example showing GPT-4 breaking a phrase into 9 tokens](../images/aien_0101.png)
###### Figure 1-1. An example of how GPT-4 tokenizes a phrase.

> Note: "can't" becomes two tokens: *can* and *'t*. On average, 100 GPT-4 tokens ≈ 75 words.

The full set of tokens a model can work with is its **vocabulary**. For example:
- Mixtral 8x7B: vocabulary of 32,000 tokens
- GPT-4: vocabulary of 100,256 tokens

> **Why tokens instead of words or characters?**
> 1. Tokens let models break words into meaningful parts (e.g., "cooking" → "cook" + "ing").
> 2. Fewer unique tokens than words → smaller vocabulary → more efficient model.
> 3. Tokens help handle unknown words (e.g., "chatgpting" → "chatgpt" + "ing").

There are two main types of language models:

| Type | How it predicts | Example use |
|---|---|---|
| **Masked language model** | Predicts missing tokens using context from *both before and after* the gap | Sentiment analysis, text classification, code debugging (BERT is an example) |
| **Autoregressive language model** | Predicts the *next* token using only what came before | Text generation, chatbots (GPT-4 is an example) |

![Diagram comparing autoregressive and masked language models](../images/aien_0102.png)
###### Figure 1-2. Autoregressive language model and masked language model.

> **Important note:** Throughout this book, "language model" means an *autoregressive* model unless stated otherwise.

Think of a language model as a **completion machine**:

```
Prompt (from user):          "To be or not to be"
Completion (from model):     ", that is the question."
```

This simple idea of "complete what I started" is surprisingly powerful. Many tasks — translation, summarization, coding, math — can be reframed as completion:

```
Prompt:   "How are you in French is …"
Output:   "Comment ça va"
```

```
Prompt:   "Question: Is this email likely spam? Email: <email content>\nAnswer:"
Output:   "Likely spam"
```

#### Self-Supervision

Why did language models become the center of AI's scaling revolution and not other ML types?

The answer: **self-supervision**.

- **Supervised learning** requires humans to label data (expensive and slow). Example: labeling 1 million images for ImageNet at $0.05/image costs $50,000.
- **Self-supervised learning** lets the model generate its own labels from the raw text — no human labeling needed.

**How self-supervision works for language models:**

The sentence *"I love street food."* automatically produces 6 training samples:

| Input (context) | Output (next token) |
|---|---|
| `<BOS>` | `I` |
| `<BOS>, I` | `love` |
| `<BOS>, I, love` | `street` |
| `<BOS>, I, love, street` | `food` |
| `<BOS>, I, love, street, food` | `.` |
| `<BOS>, I, love, street, food, .` | `<EOS>` |

`<BOS>` = Beginning of Sequence. `<EOS>` = End of Sequence.

Since text is everywhere — books, blogs, Reddit, Wikipedia — self-supervision lets researchers build massive training datasets and scale models up to become **Large Language Models (LLMs)**.

> **What is "large"?** Model size is measured in **parameters** (variables adjusted during training). In 2018, GPT-1 had 117 million parameters and was called "large." By the time this book was written, "large" means over 100 billion parameters.

> **Why do larger models need more data?** Larger models have more capacity to learn, so they need more data to fully use that capacity. Training a large model on too little data wastes the model's potential.

---

### From Large Language Models to Foundation Models

Language models only handle text. But humans experience the world through vision, hearing, and more. Extending models to handle **multiple data modalities** (text + images + video + audio) creates **foundation models**.

![Diagram showing a multimodal model generating tokens from both text and image inputs](../images/aien_0103.png)
###### Figure 1-3. A multimodal model can generate the next token using information from both text and visual tokens.

**Key example:** OpenAI's **CLIP** (2021) was trained on 400 million (image, text) pairs found naturally on the internet — 400× the size of ImageNet — with no manual labeling cost. This is called **natural language supervision**, a variant of self-supervision.

> **This book uses "foundation models"** to refer to both large language models (LLMs) and large multimodal models (LMMs).

Foundation models also mark a shift from **task-specific** models to **general-purpose** models:

- Old approach: one model for translation, a different model for spam detection
- New approach: one foundation model that can do both — and much more

The benchmark **Super-NaturalInstructions** gives a sense of how broad these capabilities are:

![Colorful diagram showing the wide range of tasks covered by the Super-NaturalInstructions benchmark](../images/aien_0104.png)
###### Figure 1-4. The range of tasks in the Super-NaturalInstructions benchmark (Wang et al., 2022).

**Three key techniques to adapt a foundation model to your needs:**

| Technique | What it does |
|---|---|
| **Prompt Engineering** | Give the model carefully crafted instructions/examples — no model changes |
| **RAG (Retrieval-Augmented Generation)** | Connect the model to a database so it can look up relevant information |
| **Finetuning** | Further train the model on your own dataset to specialize its behavior |

These three techniques are central themes of this book.

---

### From Foundation Models to AI Engineering

**AI engineering** = building applications on top of foundation models (rather than building the models themselves).

Three factors drove AI engineering's explosive growth:

**Factor 1: General-purpose AI capabilities**
Foundation models can write, code, draw, analyze data, and more — automating tasks across nearly every field.

**Factor 2: Increased AI investments**
ChatGPT's success triggered a flood of investment. Goldman Sachs estimated global AI investment could reach $200 billion by 2025. The number of S&P 500 companies mentioning AI in earnings calls tripled in one year:

![Line graph showing the number of S&P 500 companies mentioning AI in earnings calls reaching a record high in 2023](../images/aien_0105.png)
###### Figure 1-5. The number of S&P 500 companies that mention AI in their earnings calls reached a record high in 2023. Data from FactSet.

**Factor 3: Low entrance barrier**
Model-as-a-service (APIs from OpenAI, Anthropic, etc.) means anyone can call a powerful AI with a single API call — no infrastructure required. AI also writes code for you, so even non-programmers can build apps.

Open source AI tools like AutoGPT, LangChain, and Stable Diffusion grew faster on GitHub than any previous software tools:

![Line graph showing AI engineering tools growing faster in GitHub stars than Bitcoin, Vue, and React](../images/aien_0106.png)
###### Figure 1-6. Open source AI engineering tools are growing faster than any other software engineering tools, according to their GitHub star counts.

> **Why "AI engineering" and not "ML engineering" or "LLMOps"?**
> - "ML engineering" doesn't capture the shift from building models to *using* them.
> - "Ops" terms (MLOps, LLMOps) focus on operations, not the engineering and adaptation work.
> - In a survey of 20 practitioners, most preferred the term *AI engineering*.

---

## Foundation Model Use Cases

The number of possible AI applications is essentially unlimited. Researchers at OpenAI found that occupations with 100% exposure to AI (meaning AI can cut their task time by ≥50%) include:

| Group | Occupations with highest exposure | % Exposure |
|---|---|---|
| Human α | Interpreters and translators, Survey researchers, Poets/lyricists/writers, Animal scientists, PR specialists | 76.5, 75.0, 68.8, 66.7, 66.7 |
| Human β | Survey researchers, Writers and authors, Interpreters and translators, PR specialists, Animal scientists | 84.4, 82.5, 82.4, 80.6, 77.8 |
| Human ζ | Mathematicians, Tax preparers, Financial quantitative analysts, Writers and authors, Web/digital interface designers | 100.0, 100.0, 100.0, 100.0, 100.0 |

The author analyzed 205 open source AI applications (500+ GitHub stars) and 50+ enterprise AI strategies, organizing use cases into 8 categories:

| Category | Consumer Examples | Enterprise Examples |
|---|---|---|
| **Coding** | Coding assistance | Coding assistance |
| **Image & Video** | Photo/video editing, Design | Ad generation, Presentations |
| **Writing** | Email, Social media posts | Copywriting, SEO, Reports |
| **Education** | Tutoring, Essay grading | Employee onboarding, Upskilling |
| **Conversational Bots** | General chatbot, AI companion | Customer support, Product copilots |
| **Information Aggregation** | Summarization, Talk-to-your-docs | Market research, Meeting summaries |
| **Data Organization** | Image search, Personal memory | Knowledge management, Doc processing |
| **Workflow Automation** | Travel planning, Event planning | Data entry, Lead generation |

Distribution of the 205 open source applications:

![Pie chart showing distribution of use cases across 205 open source GitHub repositories](../images/aien_0107.png)
###### Figure 1-7. Distribution of use cases in the 205 open source repositories on GitHub.

Enterprises tend to start with **internal-facing** applications (knowledge management) before moving to **external-facing** ones (customer support chatbots) to manage risk:

![Bar chart showing companies deploying internal AI applications more readily than external ones](../images/aien_0108.png)
###### Figure 1-8. Companies are more willing to deploy internal-facing applications.

### Coding

The most popular AI use case in every survey. GitHub Copilot crossed $100M in annual recurring revenue just 2 years after launch.

Specific coding tasks AI excels at:
- Web scraping and PDF data extraction
- English-to-SQL / English-to-code (DB-GPT, PandasAI)
- Screenshot or design to code (screenshot-to-code)
- Code translation between languages (GPT-Migrate)
- Writing documentation (Autodoc)
- Generating tests (PentestGPT)
- Generating commit messages (AI Commits)

McKinsey found AI makes developers **2× more productive** for documentation and **25–50% more productive** for code generation/refactoring, but delivers minimal improvement on highly complex tasks:

![Bar chart comparing developer productivity gains with AI for different task types](../images/aien_0109.png)
###### Figure 1-9. AI can help developers be significantly more productive, especially for simple tasks, but this applies less for highly complex tasks. Data by McKinsey.

### Image and Video Production

Some of the most successful AI startups are creative tools:
- **Midjourney** — $200M ARR at 1.5 years old (image generation)
- **Adobe Firefly** — AI photo editing
- **Runway, Pika Labs, Sora** — AI video generation

Enterprise use: generating ads, creating seasonal variations, brainstorming visual concepts.

### Writing

An MIT study assigned writing tasks to 453 professionals and gave half access to ChatGPT:
- Time to complete tasks dropped by **40%**
- Output quality rose by **18%**
- Workers 2× more likely to use ChatGPT in their real job afterward

Consumer uses: email polishing, blog posts, story writing.  
Enterprise uses: sales outreach, SEO content, product descriptions, performance reports.

> ⚠️ **Caution:** AI has also enabled content farms that generate 1,200 SEO-optimized junk articles per day.

### Education

AI can personalize learning for every student. Research from Duolingo shows AI is most helpful in the **lesson personalization** stage of course creation:

![White paper showing Duolingo's four stages of course creation with AI's benefit at each stage](../images/aien_0110.png)
###### Figure 1-10. AI can be used throughout all four stages of course creation at Duolingo, but it's most helpful in the personalization stage. Image from Pajak and Bicknell (Duolingo, 2022).

Khan Academy offers AI-powered teaching assistants for students and course assistants for teachers.

### Conversational Bots

From general chatbots to AI companions and customer support agents. AI bots can also be **3D characters** in games (smart NPCs — non-player characters) that respond intelligently instead of following scripted dialogues.

### Information Aggregation

74% of generative AI users use it to summarize information (Salesforce 2023 survey). The most popular internal AI tool at Instacart is a "Fast Breakdown" template that summarizes meetings, emails, and Slack threads with facts, open questions, and action items.

### Data Organization

AI can auto-describe photos and videos, match text queries to images (Google Photos), extract structured data from unstructured documents (contracts, receipts, driver's licenses). The intelligent document processing (IDP) industry is projected to reach **$12.81 billion by 2030**, growing 32.9% per year.

### Workflow Automation

AI **agents** can plan and use external tools (search engine, calendar, phone) to complete multi-step tasks automatically. Agents are covered in depth in Chapter 6.

---

## Planning AI Applications

### Use Case Evaluation

Ask yourself *why* you want to build this. Common motivations, from highest to lowest urgency:

1. **Existential threat** — AI competitors will make your business obsolete if you don't act. (7% of executives in a 2023 Gartner study cited this.)
2. **Growth opportunity** — AI can boost profits, reduce costs, or improve productivity.
3. **Staying informed** — You don't want to be the next Kodak or Blockbuster.

#### The Role of AI vs. Humans in the Application

| Dimension | Options |
|---|---|
| **Critical or Complementary** | Face ID can't work without AI (critical). Gmail Smart Compose is optional (complementary). The more critical AI is, the higher accuracy it needs. |
| **Reactive or Proactive** | Reactive = triggered by user action (chatbot). Proactive = shown opportunistically (traffic alerts). Proactive features need higher quality bars since users didn't ask for them. |
| **Dynamic or Static** | Dynamic = continually updated per user (Face ID). Static = updated periodically for all users (Google Photos object detection). |

**Human-in-the-loop** means involving humans in AI decisions. Microsoft's **Crawl-Walk-Run** framework describes gradual automation:

1. **Crawl** — Human involvement is mandatory
2. **Walk** — AI can interact with internal employees
3. **Run** — AI interacts directly with external users

#### AI Product Defensibility

Building on foundation models means building a layer on top of models that others also use. Three types of competitive moats:

| Advantage | Who has it |
|---|---|
| **Technology** | Similar across most companies using the same foundation models |
| **Distribution** | Large established companies have the edge |
| **Data** | Startups that ship early and accumulate usage data can build a sustainable moat |

> Reminder: Calendly could have been a Google Calendar feature. Mailchimp could have been a Gmail feature. Many successful companies started as "features."

---

### Setting Expectations

Define success with clear metrics before building. For a customer support chatbot, example metrics include:

- **Business metrics:** % of messages automated, response speed improvement, labor saved
- **Quality metrics:** accuracy, helpfulness of responses
- **Latency metrics:** TTFT (time to first token), TPOT (time per output token), total latency
- **Cost metrics:** cost per inference request
- **Other:** fairness, interpretability

> **Usefulness threshold:** How good does it have to be before it's worth deploying to users?

---

### Milestone Planning

Evaluate off-the-shelf models first to understand your starting point. Beware the **last mile problem**:

> "The journey from 0 to 60 is easy, whereas progressing from 60 to 100 becomes exceedingly challenging." — UltraChat (Ding et al., 2023)

LinkedIn reported it took **1 month** to reach 80% of the experience they wanted, then **4 more months** to surpass 95%.

---

### Maintenance

AI moves fast. Things to watch:

- **Good changes:** longer context windows, better quality, cheaper inference

The cost of AI inference and model performance on the MMLU benchmark have both improved dramatically between 2022 and 2024:

![Graph showing AI reasoning cost dropping rapidly over time while benchmark performance improves](../images/aien_0111.png)
###### Figure 1-11. The cost of AI reasoning rapidly drops over time. Image from Katrina Nguyen (2024).

- **Tricky changes:** model API convergence makes swapping models easier, but each model has unique quirks requiring prompt/data adjustments
- **Hard changes:** regulations (GDPR compliance cost businesses an estimated $9 billion), compute availability restrictions (US Executive Order 2023)
- **Potentially fatal changes:** evolving intellectual property laws around AI-generated content

---

## The AI Engineering Stack

### Three Layers of the AI Stack

![Diagram showing three layers of the AI engineering stack: Application Development, Model Development, and Infrastructure](../images/aien_0114.png)
###### Figure 1-14. Three layers of the AI engineering stack.

| Layer | What it covers |
|---|---|
| **Application Development** | Prompts, context, evaluation, user interfaces |
| **Model Development** | Modeling, training, finetuning, dataset engineering, inference optimization |
| **Infrastructure** | Model serving, compute/data management, monitoring |

After the introduction of Stable Diffusion and ChatGPT in 2022–2023, the biggest growth was in **applications** and **application development** tooling:

![Line graph showing cumulative count of AI repositories per category over time, with a big jump in 2023](../images/aien_0115.png)
###### Figure 1-15. Cumulative count of repositories by category over time.

---

### AI Engineering vs. ML Engineering

Three key differences:

| Aspect | Traditional ML Engineering | AI Engineering |
|---|---|---|
| **Model development** | Build models from scratch | Use pre-built foundation models |
| **Scale** | Smaller models, lower compute | Larger models, more compute, more GPU clusters |
| **Outputs** | Close-ended (predefined values) | Open-ended (any text/image) — harder to evaluate |

**Model adaptation techniques:**

| Type | Approach | Pros | Cons |
|---|---|---|---|
| **Prompt-based** (prompt engineering) | Give instructions and context — no weight changes | Easy to start, flexible, low data needs | May not work for complex or strict-quality tasks |
| **Finetuning** | Update model weights on your own data | Higher quality, better latency/cost, handles novel tasks | More complex, needs more data |

#### Model Development Sub-layers

**Modeling and Training:**  
Coming up with model architecture and training it. Tools: TensorFlow, PyTorch, Hugging Face Transformers.

> ML knowledge is now a *nice-to-have*, not a *must-have* for AI application builders.

**Training Terminology Explained:**

| Term | What it means |
|---|---|
| **Pre-training** | Training from scratch (random weights). Most resource-intensive — up to 98% of total compute for models like InstructGPT. |
| **Finetuning** | Continuing to train a previously trained model. Requires less data and compute. |
| **Post-training** | Training after pre-training to improve instruction-following or safety. Done by model developers (e.g., OpenAI before releasing a model). Conceptually the same as finetuning. |

> ⚠️ Prompting a model is **not** training. If you feed your journal entries into ChatGPT and teach it your writing style, that's *prompt engineering*, not finetuning.

**Dataset Engineering:**  
Curating, generating, and annotating data for model training.

- Traditional ML: mostly tabular data, feature engineering
- AI engineering: unstructured text, focus on deduplication, tokenization, context retrieval, quality control, removing toxic/sensitive content

**Inference Optimization:**  
Making models faster and cheaper. Since foundation models generate tokens *one at a time* (autoregressive), a model taking 10ms per token takes 1 second for 100 tokens — too slow for many apps. Covered in Chapters 7–9.

**Summary table — Model Development:**

| Category | Traditional ML | With Foundation Models |
|---|---|---|
| Modeling and training | ML knowledge required | ML knowledge is a nice-to-have |
| Dataset engineering | Feature engineering, tabular data focus | Deduplication, tokenization, quality control |
| Inference optimization | Important | Even more important |

#### Application Development Sub-layers

**Evaluation:**  
Choosing models, measuring progress, deciding when to deploy, detecting production issues. Harder with foundation models because outputs are open-ended (no single "correct" answer to compare against).

**Example — Gemini vs. GPT-4 MMLU benchmark (December 2023):**

| | Gemini Ultra | Gemini Pro | GPT-4 | GPT-3.5 | PaLM 2-L | Claude 2 | Inflection-2 | Grok 1 | Llama-2 |
|---|---|---|---|---|---|---|---|---|---|
| MMLU (CoT@32 / CoT@8) | 90.04% CoT@32 | 79.13% CoT@8 | 87.29% CoT@32 (API) | 70% 5-shot | 78.4% 5-shot | 78.5% 5-shot CoT | 79.6% 5-shot | 73.0% 5-shot | 68.0% |
| MMLU (5-shot) | 83.7% | 71.8% | 86.4% (reported) | — | — | — | — | — | — |

Gemini Ultra appeared to beat GPT-4 — but only because it was shown 32 examples while GPT-4 was shown 5. With equal conditions, GPT-4 scored higher.

**Prompt Engineering & Context Construction:**  
Getting AI to behave the way you want through instructions alone. Covered in Chapter 5 (prompt engineering) and Chapter 6 (context construction / RAG).

**AI Interface:**  
Creating user interfaces for AI apps. With foundation models, anyone can build standalone AI products or embed them into existing tools.

Interface types:
- Standalone web/desktop/mobile apps (Streamlit, Gradio, Plotly Dash)
- Browser extensions (Grammarly)
- Chat app integrations (Slack, Discord, WhatsApp bots)
- IDE plug-ins (GitHub Copilot in VSCode)
- Voice-based (Siri, Alexa)
- 3D/AR/VR embodied interfaces

**Summary table — Application Development:**

| Category | Traditional ML | With Foundation Models |
|---|---|---|
| AI interface | Less important | Important |
| Prompt engineering | Not applicable | Important |
| Evaluation | Important | Even more important |

---

### AI Engineering vs. Full-Stack Engineering

AI engineering increasingly overlaps with **full-stack development** due to the emphasis on interfaces. The tooling is shifting from Python-only to also supporting JavaScript:
- LangChain.js, Transformers.js, OpenAI's Node library, Vercel's AI SDK

**The new workflow:** Instead of starting with data collection and model training (as in traditional ML), AI engineers can **build the product first**, then invest in data/models once the product shows promise:

![Diagram showing the shift in AI engineering workflow — product first, then models and data](../images/aien_0116.png)
###### Figure 1-16. The new AI engineering workflow rewards those who can iterate fast. Image recreated from "The Rise of the AI Engineer" (Shawn Wang, 2023).

---

## Summary

This chapter traced the path from simple language models → large language models → foundation models → AI engineering.

**Key takeaways:**

1. **Self-supervision** is what allowed language models to scale up into LLMs — no expensive human labeling needed.
2. **Foundation models** are general-purpose, multimodal, and powerful enough to handle a wide range of tasks out of the box.
3. **AI engineering** is about adapting and building on top of foundation models — it's faster and cheaper than building models from scratch.
4. **Use cases** span coding, writing, image/video, education, conversational bots, information aggregation, data organization, and workflow automation.
5. **Planning matters** — evaluate use cases, set clear success metrics, plan milestones, and account for maintenance.
6. **The AI engineering stack** has three layers: application development, model development, and infrastructure.
7. **Key differences from traditional ML engineering:** less model building, more adaptation; open-ended outputs make evaluation harder; inference optimization is critical.
8. **The development workflow has flipped:** build the product first with existing models, then invest in data and model customization as needed.

The next chapter dives deeper into how foundation models work under the hood.
