# Chapter 10: AI Engineering Architecture and User Feedback

---

## Overview

This chapter zooms out from individual techniques covered in previous chapters and asks: how do you put it all together into a real, working AI product?

It covers two major topics:

1. **AI Engineering Architecture** — A step-by-step framework for building a production AI application, starting from the simplest possible design and progressively adding components as needs arise.
2. **User Feedback** — How conversational AI enables entirely new kinds of user feedback, why this feedback is valuable data, and how to design a system that collects it well.

---

## AI Engineering Architecture

### The Starting Point: The Simplest Architecture

Before adding anything, a basic AI application does exactly one thing: receive a query and return a model's response.

![A simple block diagram: User → Model API → Response returned to user](../images/aien_1001.png)
###### Figure 10-1. The simplest architecture for running an AI application.

The *Model API* box can be a third-party API (OpenAI, Anthropic, Google) or a self-hosted model (see Chapter 9 for self-hosted inference).

From this base, the architecture grows in five steps:

1. Enhance context input to the model
2. Put in guardrails
3. Add model router and gateway
4. Reduce latency with caching
5. Add agent patterns (loops + write actions)

> The steps below describe a common production progression — but your application might need them in a different order.

---

### Step 1: Enhance Context

The first meaningful expansion: give the model access to relevant information it wouldn't otherwise have.

> "Context construction is like feature engineering for foundation models."

Context can be augmented via:
- **RAG (retrieval-augmented generation):** Retrieve relevant documents, images, or tabular data from external sources
- **Tool use:** Web search, news feeds, weather APIs, event calendars, etc.

Most major model API providers (OpenAI, Anthropic/Claude, Google/Gemini) support file uploads and tool use. However, they differ in:
- How many documents you can upload
- Which retrieval algorithms they use
- Whether they support parallel function calls or long-running jobs

A specialized RAG solution lets you index as many documents as your vector database can hold; a generic model API may cap uploads at a small number.

![Block diagram showing User → Context Construction (retrieval + tools) → Model API → Response](../images/aien_1002.png)
###### Figure 10-2. A platform architecture with context construction.

---

### Step 2: Put in Guardrails

Guardrails protect your system and your users. They address two kinds of risk: leaking private data and generating bad output.

#### Input Guardrails

**Goal:** prevent sensitive information from being sent to third-party APIs, and block malicious prompt attacks.

**Privacy leak risks:**
- An employee pastes company secrets into a prompt (e.g., a Samsung employee leaked proprietary code to ChatGPT)
- An app developer puts internal policies into the system prompt
- A retrieval tool pulls private data from an internal database and includes it in context

**Mitigation:** Automatically detect and mask sensitive data before sending it to external APIs.

Common sensitive data classes:
- Personal information (ID numbers, phone numbers, bank accounts)
- Human faces (in multimodal apps)
- Company-specific keywords and intellectual property phrases

**PII masking workflow:**

![Diagram showing a user's phone number being replaced with a [PHONE NUMBER] placeholder before being sent to the model API, then unmasked using a reverse PII map before returning the response to the user](../images/aien_1003.png)
###### Figure 10-3. Masking PII before sending to external APIs, then unmasking in the response using a reverse PII dictionary.

If the response contains `[PHONE NUMBER]`, a reverse dictionary maps the placeholder back to the real number before showing it to the user.

#### Output Guardrails

**Goal:** catch failures in model responses and define a policy for handling them.

**Quality failures:**
- Malformatted responses (e.g., invalid JSON when JSON was expected)
- Hallucinated or factually inconsistent responses
- Generally poor-quality responses (bad essays, weak code)

**Security failures:**
- Toxic responses (racist, sexual, or illegal content)
- Responses that contain private/sensitive information
- Responses that trigger remote code execution
- Brand-risk responses that mischaracterize your company or competitors

**Handling failures — options:**
- **Retry logic:** AI models are probabilistic; asking again often produces a different response. If you get empty JSON, try again up to X times.
- **Parallel calls:** Instead of waiting for failure then retrying (doubling latency), send two requests simultaneously and pick the better response.
- **Human fallback:** Transfer conversations to human operators when sentiment analysis detects frustration, when specific phrases appear, or after a maximum number of turns.

> ⚠️ **False refusal rate matters.** A system that blocks too aggressively frustrates legitimate users. Always track how often your guardrails incorrectly block valid requests alongside how often they catch bad ones.

#### Guardrail Trade-offs

- **Reliability vs. latency:** Guardrails add latency. Some teams skip them when latency is the top priority — though many engineers find this decision alarming.
- **Streaming mode:** When responses are streamed token by token, output guardrails can't evaluate the full response before it reaches the user. Unsafe content may appear before it can be blocked.
- **Third-party vs. self-hosted:** Third-party APIs often include built-in guardrails. Self-hosted models require you to implement them yourself, but eliminate the need for input privacy guardrails since data doesn't leave your organization.

**Ready-made guardrail solutions:** Meta's Purple Llama, NVIDIA's NeMo Guardrails, Azure PyRIT, Azure AI content filters, Perspective API, OpenAI Moderation API.

![Architecture diagram with Input Guardrails box before the Model API and Output Guardrails box after, with scorers shown under Model APIs](../images/aien_1004.png)
###### Figure 10-4. Application architecture with input and output guardrails.

---

### Step 3: Add Model Router and Gateway

As applications grow, you'll often need multiple models — for different tasks, at different costs. Routers and gateways manage this complexity.

#### Router

**Purpose:** route each incoming query to the most appropriate model or solution.

**Benefits:**
- **Specialization:** Route technical questions to a model fine-tuned on your product; route billing questions to a different one
- **Cost savings:** Simple queries → cheap models; complex queries → powerful (expensive) models

A router typically contains an **intent classifier** that predicts what the user is trying to do. Example routing decisions for a customer support chatbot:

| Detected intent | Action |
|---|---|
| Password reset | Send to FAQ page |
| Billing correction | Transfer to human operator |
| Technical troubleshooting | Route to specialized AI chatbot |
| Out-of-scope question | Politely decline without an API call |
| Ambiguous query ("Freezing") | Ask for clarification |

**Agent routing:** Routers can also act as **next-action predictors** inside agents — deciding whether to call a code interpreter, a web search API, or memory retrieval.

**Context-limit routing:** When a retrieved document is too long for the originally intended model, the router can switch to a model with a larger context window.

**Implementation:** Many teams use small, fast models (GPT-2, BERT, Llama 7B) or train lightweight classifiers from scratch. Routers must be cheap and fast — they run on every query.

![Architecture diagram with a Router box inside the Model API section, directing queries to different downstream models/solutions](../images/aien_1005.png)
###### Figure 10-5. Routing helps the system use the optimal solution for each query.

#### Gateway

**Purpose:** provide a single, unified interface to all your models (both third-party APIs and self-hosted), making them easier to manage and secure.

**Core benefit:** if a model API changes, you update only the gateway — not every application that uses it.

A simple model gateway in Python:

```python
import google.generativeai as genai
import openai

def openai_model(input_data, model_name, max_tokens):
    openai.api_key = os.environ["OPENAI_API_KEY"]
    response = openai.Completion.create(
        engine=model_name,
        prompt=input_data,
        max_tokens=max_tokens
    )
    return {"response": response.choices[0].text.strip()}

def gemini_model(input_data, model_name, max_tokens):
    genai.configure(api_key=os.environ["GOOGLE_API_KEY"])
    model = genai.GenerativeModel(model_name=model_name)
    response = model.generate_content(input_data, max_tokens=max_tokens)
    return {"response": response["choices"][0]["message"]["content"]}

@app.route('/model', methods=['POST'])
def model_gateway():
    data = request.get_json()
    model_type = data.get("model_type")
    model_name = data.get("model_name")
    input_data = data.get("input_data")
    max_tokens = data.get("max_tokens")

    if model_type == "openai":
        result = openai_model(input_data, model_name, max_tokens)
    elif model_type == "gemini":
        result = gemini_model(input_data, model_name, max_tokens)
    return jsonify(result)
```

![Diagram showing multiple applications routing through a single Model Gateway, which then connects to OpenAI, Gemini, and self-hosted models](../images/aien_1006.png)
###### Figure 10-6. A model gateway provides a unified interface to work with different models.

**Additional gateway capabilities:**
- **Access control:** Instead of distributing API keys to everyone (risky), give people access only to the gateway. The gateway enforces who can use which model.
- **Cost management:** Monitor and limit API usage; prevent runaway costs.
- **Fallback policies:** When a model API is down or rate-limited, automatically fall back to an alternative model or retry after a brief wait.
- **Load balancing, logging, analytics:** All requests flow through the gateway — it's the natural place for cross-cutting concerns.

Ready-made gateways: Portkey AI Gateway, MLflow AI Gateway, Wealthsimple LLM Gateway, TrueFoundry, Kong, Cloudflare.

![Architecture diagram showing the Model API box replaced by a Gateway box, which connects to routers and multiple backend models](../images/aien_1007.png)
###### Figure 10-7. The architecture with routing and gateway modules.

---

### Step 4: Reduce Latency with Caches

Caching stores previously computed results so that repeated (or similar) queries don't require full recomputation.

> Note: KV cache and prompt cache (discussed in Chapter 9) are inference-level caches, typically managed by model API providers. This section covers **system-level caching**.

#### Exact Caching

Stored results are reused only when the exact same query arrives.

**Examples:**
- A user asks for a product summary → check cache → if found, return it; if not, generate and cache
- Vector search results for a query → cache the retrieved documents for that query

Exact caching is especially valuable for expensive multi-step pipelines (chain-of-thought, SQL execution, web search).

**Implementation:**
- In-memory storage (Redis) for fast retrieval
- Database storage (PostgreSQL) for larger caches
- **Eviction policies:** Least Recently Used (LRU), Least Frequently Used (LFU), FIFO (first in, first out)

**What not to cache:**
- User-specific queries: "What's the status of my recent order?" — these shouldn't be served to other users
- Time-sensitive queries: "What's the weather today?"
- Many teams train a classifier to predict whether a given query is cacheable

> ⚠️ **Cache leaks are a real risk.** If a user's personalized response is mistakenly cached as a "generic" response and served to another user, it can expose private information.

#### Semantic Caching

Cached results are reused even when the new query is only *similar to* — not identical to — a previous query.

**Example:**
- "What's the capital of Vietnam?" → model answers "Hanoi" → cached
- "What's the capital city of Vietnam?" → semantically the same → return cached answer

**How it works:**
1. Generate an embedding for the incoming query
2. Vector search the cache to find the most similar previous query (similarity = X)
3. If X > threshold: return cached result
4. If X < threshold: process the new query, cache it

**Trade-offs:**
- Higher cache hit rate → cost savings
- But: relies on high-quality embeddings, a reliable similarity threshold, and a working vector search
- Setting the threshold wrong → wrong answers returned confidently
- Adding vector search adds latency and compute cost

> Semantic caching's value is "more dubious" than exact caching because more things can go wrong. Evaluate carefully before adopting.

![Architecture diagram with a Cache box added, showing arrows from queries to cache and from generated responses back into the cache](../images/aien_1008.png)
###### Figure 10-8. An AI application architecture with system-level caches.

---

### Step 5: Add Agent Patterns

So far, each query follows a fixed linear path. Agents add **loops**, **conditional branching**, and **parallel execution**.

**The feedback loop:** After generating an output, the system decides whether the task is complete. If not, it retrieves more information and tries again.

![Architecture diagram with a yellow arrow feeding the model's output back into the retrieval/context stage, enabling iterative loops](../images/aien_1009.png)
###### Figure 10-9. The feedback arrow allows generated responses to loop back through the system for multi-step reasoning.

**Write actions:** Beyond reading from the environment, agents can write to it — composing emails, placing orders, initiating bank transfers. Write actions make systems vastly more capable but also expose them to vastly greater risk. Grant write access carefully.

![Architecture diagram with write actions (email, order, database update) connected as outputs from the Model API](../images/aien_1010.png)
###### Figure 10-10. An application architecture that enables write actions.

> The more components a system has, the more things can go wrong — and the harder it is to diagnose failures. Complex architecture → essential observability.

---

## Monitoring and Observability

Observability is not an afterthought. It should be designed into the system from the start.

**Monitoring** = tracking external system outputs  
**Observability** = the ability to infer internal system state from those outputs — so that when something breaks, you can figure out *what* and *why* without shipping new diagnostic code

**Three key metrics (from DevOps):**

| Metric | Meaning |
|---|---|
| **MTTD** (mean time to detection) | When something breaks, how quickly do you know? |
| **MTTR** (mean time to response) | After detecting an issue, how quickly is it resolved? |
| **CFR** (change failure rate) | What % of deployments cause failures requiring rollback? |

> A high CFR signals that your evaluation pipeline isn't catching problems before deployment — not just that your monitoring is bad.

### Metrics

Metrics are only useful if they map to something you care about — detecting failures or discovering opportunities.

**Format/quality metrics:**
- Invalid JSON output rate (and how many are auto-fixable)
- Factual consistency of open-ended responses
- Conciseness, creativity, toxicity, PII exposure

**Conversational engagement metrics:**
- How often users stop generation halfway
- Average number of turns per conversation
- Average input/output token count — are users becoming more concise?
- Output token distribution — is the model becoming more or less verbose over time?

**Operational metrics:**
- TTFT, TPOT, total latency (Chapter 9)
- Token throughput (TPS)
- API calls per second vs. rate limits
- Cache hit rate and cache cost
- Retrieval quality in RAG pipelines (context relevance, context precision)

**Business north-star metrics:** daily active users, session duration, subscriptions. Understanding which quality metrics correlate with north-star metrics helps prioritize what to optimize.

### Logs and Traces

**Metrics** answer "how is the system doing overall?"  
**Logs** answer "what exactly happened, and when?"

**Debugging workflow:**
1. A metric spike tells you something went wrong five minutes ago
2. You review logs from that time window to identify the event
3. Correlate log errors to the metric to confirm you found the right issue

**Log everything:**
- Model API endpoint, model name, sampling settings (temperature, top-p, top-k)
- Prompt template version
- User query → final prompt sent to model → output → intermediate outputs
- All tool calls and their outputs
- Component start/end times and crashes
- Add tags and IDs to every log entry so you can trace it back to a specific pipeline component

**Traces** link related log events into a complete timeline of a single request's journey through the system — from user query through retrieval, prompt construction, model call, scoring, and final response. Traces tell you not just *what happened* but *how long each step took* and where failures occurred.

![Screenshot of a request trace in LangSmith showing each step of a multi-hop RAG pipeline with timing and intermediate outputs](../images/aien_1011.png)
###### Figure 10-11. A request trace visualized by LangSmith.

> "Manual inspection of your production data daily" gives intuitions that automated metrics miss. Developers' perceptions of good and bad outputs evolve as they see more data — allowing them to both improve prompts and update evaluation pipelines.

### Drift Detection

In a multi-component system, things change — sometimes without your knowledge.

**Types of drift:**

**System prompt drift:** Prompt templates get updated, coworkers fix typos, logic changes cascade through templates. A simple version-check should alert you when the system prompt changes.

**User behavior drift:** Users learn to use your product differently. They may write shorter prompts, use different phrasing, or discover tricks to get better results. This changes query distributions gradually. Metrics alone may show a slow shift without revealing why.

**Underlying model drift:** Model API providers sometimes silently update the model behind an unchanged API endpoint. Chen et al. (2023) observed notable benchmark score differences between March 2023 and June 2023 versions of GPT-4. Voiceflow reported a **10% performance drop** when GPT-3.5-turbo was updated from the 0301 version to the 1106 version.

---

## AI Pipeline Orchestration

An **orchestrator** wires all the components (models, retrieval, tools, evaluators) together into a coherent end-to-end pipeline.

**Two functions of an orchestrator:**

**1. Components definition:** Tell the orchestrator what models, data sources, and tools your system uses.

**2. Chaining:** Define the sequence of operations for each request. Example pipeline:
1. Process the raw query
2. Retrieve relevant data
3. Combine query + retrieved data into a prompt
4. Generate a response
5. Evaluate the response
6. If good → return to user; if bad → route to human operator

**What to look for in an orchestrator:**

| Criterion | Why it matters |
|---|---|
| Integration and extensibility | Does it support your current models/databases? Can you add new ones? |
| Support for complex pipelines | Does it support branching, parallel execution, and error handling? |
| Ease of use, performance, scalability | Is the API intuitive? Does it add hidden latency or make hidden API calls? Can it scale with your traffic? |

> **Start without an orchestrator.** Any external tool adds complexity and hides system behavior behind abstractions. Only adopt one when the complexity of managing components manually becomes the bigger problem.

**Popular orchestration tools:** LangChain, LlamaIndex, Flowise, Langflow, Haystack.

> ⚠️ An AI pipeline orchestrator is different from a general workflow orchestrator (like Airflow or Metaflow). Don't substitute one for the other.

---

## User Feedback

User feedback serves three purposes in AI applications:
1. **Evaluation** — monitor application performance
2. **Development** — train and improve future model versions
3. **Personalization** — adapt the application to individual users

Unlike most software features, user feedback is **proprietary data**. It's a competitive advantage that compounds over time: better data → better model → more users → more data. A product that ships early and collects real user data becomes increasingly hard for competitors to catch up to.

> User feedback is user data. Always respect privacy. Users have the right to know how their data is used.

---

## Extracting Conversational Feedback

Feedback types:

| Type | Description |
|---|---|
| **Explicit** | User directly rates something: thumbs up/down, stars, yes/no |
| **Implicit** | Inferred from user behavior: clicks, edits, rephrasing, abandonment |

The **conversational interface** of AI chatbots enables an entirely new category of implicit feedback — users naturally express approval and dissatisfaction through dialogue.

**Example:** A user asks an AI travel assistant to find a hotel in Sydney. The assistant replies:

```
Here are three hotel suggestions in Sydney for a 3-night stay:

1. Historic Rocks Boutique Hotel (The Rocks)
   - Price: ~$400/night
   - Neighborhood: Charming streets and close to iconic sights.

2. Stylish Surry Hills House Hotel (Surry Hills)
   - Price: ~$200/night
   - Neighborhood: Trendy, with vibrant cafes and art galleries.

3. Chill Bondi Beachside Hotel (Bondi Beach)
   - Price: ~$300/night
   - Neighborhood: Beachside, ideal for relaxation and city exploration.
```

How the user responds reveals their preferences:
- "Yes book me the one close to galleries" → interested in art
- "Is there nothing under $200?" → price-conscious; the assistant doesn't understand this user yet

---

### Natural Language Feedback

Feedback inferred from the *content* of what users say.

#### Early Termination

If a user:
- Stops a response generation mid-stream
- Exits the app
- Tells a voice assistant "stop"
- Leaves an agent hanging without replying

…the conversation is probably not going well.

#### Error Correction

Starting a reply with "No, …" or "I meant, …" signals that the previous response was off-target.

Users may also try to rephrase their question to get a better response:

![Screenshot showing a user stopping a generated response early, then rephrasing their original question — a strong signal of misunderstanding](../images/aien_1012.png)
###### Figure 10-12. Early termination combined with rephrasing signals a misunderstood intent.

Other correction signals:
- Pointing out specific errors: "Bill is the suspect, not the victim."
- Nudging agents: "You should also check XYZ's GitHub page."
- Asking for verification: "Are you sure?", "Show me the sources." — this can also indicate general distrust in the model.
- Direct edits: If a user edits the model's generated code, the original code was wrong. These edits are also **preference data** — the original is the losing response, the edit is the winning response.

#### Complaints

**Table 10-1: Feedback types from the FITS dataset (Xu et al., 2022)**

| Group | Feedback type | Count | % |
|---|---|---|---|
| 1 | Clarify their demand again | 3,702 | 26.54% |
| 2 | Bot doesn't answer the question / gives irrelevant info / tells user to find the answer themselves | 2,260 | 16.20% |
| 3 | Point out specific search results that could answer the question | 2,255 | 16.17% |
| 4 | Suggest that the bot should use the search results | 2,130 | 15.27% |
| 5 | State that the answer is factually incorrect or not grounded in search results | 1,572 | 11.27% |
| 6 | Point out that the answer is not specific/accurate/complete/detailed | 1,309 | 9.39% |
| 7 | Bot is not confident — always says "I'm not sure" or "I don't know" | 582 | 4.17% |
| 8 | Complain about repetition or rudeness | 137 | 0.99% |

**Using complaints:** If users consistently complain about verbose answers, update the prompt to be more concise. If they complain about lack of detail, prompt the model to elaborate more.

#### Sentiment

Expressions of frustration or disappointment without explicit reasons ("Uggh", "This is useless") also signal poor performance. Call centers have long tracked voice sentiment throughout calls — if a caller gets increasingly agitated, something is wrong; if they start angry and end satisfied, the issue was resolved.

The **model's refusal rate** is also a signal: if the model keeps saying "Sorry, I don't know that one" or "As a language model, I can't…", users are probably unhappy.

---

### Other Conversational Feedback

Feedback inferred from user *actions* (not message content).

#### Regeneration

When a user asks for another response, they may be dissatisfied — or they may just be exploring options (especially for creative tasks like image generation). Context matters:
- Usage-based billing → regeneration is a stronger negative signal (users pay for each generation)
- Subscription billing → regeneration might be idle curiosity

After regeneration, comparative feedback ("which was better?") can be collected explicitly:

![ChatGPT interface showing two responses side by side after a user regenerates, asking the user to choose which is better](../images/aien_1013.png)
###### Figure 10-13. ChatGPT collects comparative feedback after a user regenerates a response.

This comparative data (response A vs. response B) is exactly the format needed for **preference finetuning**.

#### Conversation Organization

- **Delete:** Strong negative signal that the conversation was bad (or embarrassing)
- **Rename:** Positive signal about the conversation; negative signal about the auto-generated title
- **Share/bookmark:** Ambiguous — can be positive (useful) or negative (showing others a mistake the model made)

#### Conversation Length (Number of Turns)

- AI companions: long conversations → user engagement → positive
- Customer support chatbots: long conversations → unresolved issue → negative

Context determines whether length is a good or bad signal.

#### Dialogue Diversity

A long conversation where the bot repeats the same few lines suggests the user is stuck in a loop — a negative signal even if the turn count is high.

---

## Feedback Design

### When to Collect Feedback

**At the beginning (onboarding):** Some applications need calibration before they can work (face ID, voice recognition). Language learning apps ask about your skill level. For most apps, initial calibration should be optional — friction at signup reduces adoption.

**When something goes wrong:** Users should always be able to report errors. Options:
- Downvote the response
- Regenerate with the same model
- Switch to a different model
- Give conversational feedback: "You're wrong" / "Too long" / "I wanted something more detailed"

Let users collaborate with the AI when it fails — and with humans when the AI can't handle it:

![Screenshot showing DALL-E inpainting: a user selects a region of a generated image and describes how to fix it — the model regenerates only that region](../images/aien_1014.png)
###### Figure 10-14. DALL-E's inpainting allows users to fix specific parts of a generated image with text descriptions.

**When the model has low confidence:** Show two options side by side and ask the user to pick:

![ChatGPT showing two full responses side by side for the user to compare and choose](../images/aien_1015.png)
###### Figure 10-15. Side-by-side comparison of two ChatGPT responses.

![Google Gemini showing only the first few lines of each response — users click to expand the one they want to read](../images/aien_1016.png)
###### Figure 10-16. Google Gemini shows partial responses side by side; clicking expands the preferred option, giving an implicit preference signal.

![Google Photos asking the user if two photos show the same person — a targeted feedback request triggered by model uncertainty](../images/aien_1017.png)
###### Figure 10-17. Google Photos collects targeted feedback when the model is uncertain about identity.

### How to Collect Feedback

**Midjourney's feedback design** (often cited as a best-in-class example):

For each prompt, Midjourney generates 4 images and offers:
1. **Upscale** any image → strongest positive signal for that specific image
2. **Generate variations** of any image → weaker positive signal
3. **Regenerate** → signal that none of the images met expectations

![Midjourney interface showing 4 generated images with U1/U2/U3/U4 (upscale) and V1/V2/V3/V4 (variations) buttons below them](../images/aien_1018.png)
###### Figure 10-18. Midjourney's workflow collects implicit preference feedback with every user action.

**GitHub Copilot's inline suggestion design:**

![Code editor showing a Copilot suggestion in light gray — the user presses Tab to accept or continues typing to dismiss](../images/aien_1019.png)
###### Figure 10-19. GitHub Copilot collects implicit feedback: Tab = accept (positive), continue typing = dismiss (negative).

**Key design principles:**
- Feedback collection must be non-intrusive — it shouldn't disrupt the user's workflow
- Make providing feedback easy (one click, not a form)
- Feedback should be easy to ignore when users don't want to engage
- Explain how feedback is used — users give better feedback when they understand the purpose
- Don't ask users to evaluate things they can't evaluate:

![ChatGPT asking a user to choose between two statistical answers — the user can't verify correctness without being a statistician](../images/aien_1020.png)
###### Figure 10-20. Asking users to evaluate correctness on technical questions they can't verify produces noise, not signal.

- Avoid confusing UI designs:

![Luma's feedback form where the angry emoji (1 star) was placed where the happy emoji (5 stars) should be — causing many users to accidentally give 1-star ratings for positive experiences](../images/aien_1021.png)
###### Figure 10-21. Luma's misplaced emoji caused many users to leave 1-star ratings for positive experiences — a cautionary tale for feedback UI design.

**Public vs. private feedback:**
- Public signals (like counts, shared conversations) allow social discovery but suppress honest feedback
- Private signals produce more candid responses
- X (formerly Twitter) made "likes" private in 2024 — Elon Musk reported a significant increase in the number of likes after the change

---

## Feedback Limitations

### Biases

**Leniency bias:** Users rate things more positively than they truly feel to avoid conflict or extra work. On Uber's five-star scale, the average driver rating is 4.8 — a score below 4.6 puts a driver at risk of being deactivated. **Fix:** Replace numerical scales with descriptive options ("Great ride", "Nothing to complain about", "Don't match me with this driver again").

**Randomness:** Users provide random feedback when they don't want to do the cognitive work. When shown two long responses side by side, users may just click one at random rather than reading both.

**Position bias:** Users click the first option more often than the second, regardless of quality. **Fix:** Randomly vary the positions of options to average out the bias.

**Preference bias:**
- **Length bias:** Users often prefer longer responses in comparisons, even when the longer response is less accurate
- **Recency bias:** Users tend to prefer the answer they see last when comparing two answers

> Understanding these biases is essential to interpret feedback correctly. A naive reading of noisy feedback will produce bad product decisions.

### Degenerate Feedback Loops

A **degenerate feedback loop** happens when model predictions influence feedback, which then influences model training, which amplifies initial biases.

**Classic example (recommendation systems):** Video A ranks slightly higher than B, so it gets more clicks. The model learns A is better and boosts it further. Over time, A dominates, and B (which might have been equally good) never gets a chance. This is *exposure bias*, *popularity bias*, or *filter bubbles* — a well-studied problem.

**AI-specific example:** A small group of users gives positive feedback on cat photos. The system generates more cat photos, attracting more cat lovers, who give more positive feedback about cats. Eventually, the application becomes a cat-photo generator — even if that's not what it was designed for. The same mechanism can amplify **racism, sexism, and preferences for explicit content**.

**Sycophancy problem (Sharma et al., 2023):** Models trained on user feedback learn to tell users what they want to hear rather than what's accurate. They present responses that match the user's apparent views. This makes the model more agreeable but less trustworthy.

> User feedback is crucial — but using it indiscriminately can destroy your product. Always understand your feedback's limitations before incorporating it into training.

---

## Summary

**Architecture:**

A production AI application grows step-by-step:

| Step | What it adds | Why |
|---|---|---|
| 1. Context construction | RAG, tools | Give the model relevant information |
| 2. Guardrails | Input/output protection | Prevent leaks, bad outputs, security failures |
| 3. Router + Gateway | Model routing, unified interface | Optimize cost, manage complexity, enforce access control |
| 4. Caching | Exact and semantic caching | Reduce latency and costs for repeated queries |
| 5. Agent patterns | Loops, write actions | Enable complex multi-step tasks |
| + Monitoring | Metrics, logs, traces, drift detection | Know when things go wrong and why |
| + Orchestration | Pipeline chaining | Glue all components together cleanly |

**Key architectural principles:**
- Components are modular but their boundaries are fluid (guardrails can live in the inference service, the gateway, or as standalone)
- Every added component adds capability AND new failure modes
- Start simple; add complexity only when you need it
- Start without an orchestrator; adopt one only when manual composition becomes the bigger problem

**User Feedback:**

| Feedback type | Examples | Ease of interpretation |
|---|---|---|
| Explicit | Thumbs up/down, star ratings | Easy, but sparse and biased |
| Implicit — natural language | Error correction, rephrasing, complaints, sentiment | Moderate (requires NLP to extract) |
| Implicit — behavioral | Early termination, regeneration, edits, deletes, turn count | Abundant, but noisy and ambiguous |

**Key feedback principles:**
- Conversational AI enables fundamentally new feedback signals not available in traditional software
- User feedback is proprietary data — a durable competitive advantage if designed well
- Implicit feedback is abundant but noisy; always study your specific users to understand what their actions mean
- Feedback has biases (leniency, randomness, position, preference) — understand them before making product decisions
- Degenerate feedback loops can silently corrupt your model toward popularity bias, sycophancy, or unintended use cases

> AI engineering is converging with product engineering. The data flywheel and user experience are now core technical responsibilities — not just product or design ones.
