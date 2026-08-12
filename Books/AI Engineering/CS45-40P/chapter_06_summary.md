# Chapter 6. RAG and Agents

## Overview

To solve a task, a model needs both **instructions on how to do it** and **the necessary information to do so**. Just like humans are more likely to give wrong answers when lacking information, AI models are more likely to make mistakes and hallucinate when they are missing context.

**Key Components**:
- **Instructions**: Common to all queries (covered in Chapter 5)
- **Context**: Specific to each query (focus of this chapter)

**Two Dominating Patterns for Context Construction**:

1. **RAG (Retrieval-Augmented Generation)**: Allows the model to retrieve relevant information from external data sources
2. **Agents**: Allows the model to use tools such as web search and news APIs to gather information

**Beyond Context Construction**: While RAG is chiefly used for constructing context, the agentic pattern can do much more:
- External tools help models address their shortcomings
- Expand their capabilities
- Give models the ability to directly interact with the world
- Enable automation of many aspects of our lives

Both RAG and agentic patterns are exciting because of the capabilities they bring to already powerful models. This chapter goes into detail about each pattern, how they work, and what makes them so promising.

# RAG

**Definition**: RAG is a technique that enhances a model's generation by retrieving relevant information from external memory sources. An external memory source can be:
- An internal database
- A user's previous chat sessions
- The internet

## History and Evolution

**Origins**: The *retrieve-then-generate* pattern was first introduced in "Reading Wikipedia to Answer Open-Domain Questions" (Chen et al., 2017):
- System first retrieves five Wikipedia pages most relevant to a question
- Then a model uses (or reads) the information from these pages to generate an answer

../images/aien_0601.png

**Figure 6-1. The retrieve-then-generate pattern. The model was referred to as the document reader.**

**Term Coined**: The term *retrieval-augmented generation* was coined in "Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks" (Lewis et al., 2020):
- Proposed RAG as a solution for knowledge-intensive tasks
- Where all available knowledge can't be input into the model directly
- With RAG, only information most relevant to the query is retrieved and input
- Lewis et al. found that having access to relevant information helps the model generate more detailed responses while reducing hallucinations

**Example**: Given the query "Can Acme's fancy-printer-A300 print 100pps?", the model will respond better if given the specifications of fancy-printer-A300.

**Core Concept**: You can think of RAG as a technique to construct context specific to each query, instead of using the same context for all queries. This helps with managing user data, allowing you to include data specific to a user only in queries related to this user.

**Parallel with Classical ML**: Context construction for foundation models is equivalent to feature engineering for classical ML models. They serve the same purpose: giving the model the necessary information to process an input.

## Why RAG Will Remain Important

**Common Misconception**: Many people think that a sufficiently long context will be the end of RAG. This is unlikely for two main reasons:

**Reason 1: Data Growth Outpaces Context Length**:
- No matter how long a model's context length is, there will be applications that require context longer than that
- The amount of available data only grows over time
- People generate and add new data but rarely delete data
- Context length is expanding quickly, but not fast enough for the data needs of arbitrary applications

**Reason 2: Long Context ≠ Effective Use of Context**:
- A model that can process long context doesn't necessarily use that context well
- The longer the context, the more likely the model is to focus on the wrong part
- Every extra context token incurs extra cost and has potential to add extra latency
- RAG allows a model to use only the most relevant information for each query, reducing the number of input tokens while potentially increasing performance

**Future Direction**: Efforts to expand context length are happening in parallel with efforts to make models use context more effectively. Model providers may incorporate retrieval-like or attention-like mechanisms to help models pick out the most salient parts of context to use.

**Note**: Anthropic suggested that for Claude models, if "your knowledge base is smaller than 200,000 tokens (about 500 pages of material), you can just include the entire knowledge base in the prompt, with no need for RAG or similar methods." It would be helpful if other model developers provide similar guidance.

## RAG Architecture

A RAG system has two components:
1. **Retriever**: Retrieves information from external memory sources
2. **Generator**: Generates a response based on the retrieved information

../images/aien_0602.png

**Figure 6-2. A basic RAG architecture.**

**Training Approaches**: In the original RAG paper, Lewis et al. trained the retriever and generative model together. In today's RAG systems:
- These two components are often trained separately
- Many teams build RAG systems using off-the-shelf retrievers and models
- However, finetuning the whole RAG system end-to-end can improve performance significantly

**Retriever Functions**: The success of a RAG system depends on the quality of its retriever. A retriever has two main functions:
1. **Indexing**: Processing data so it can be quickly retrieved later
2. **Querying**: Sending a query to retrieve data relevant to it

How to index data depends on how you want to retrieve it later on.

**Example Workflow**:

Let's assume the external memory is a database of documents (company memos, contracts, meeting notes). A document can be 10 tokens or 1 million tokens. Naively retrieving whole documents can cause context to be arbitrarily long.

**Solution: Chunking**:
- Split each document into more manageable chunks
- Chunking strategies will be discussed later in this chapter
- For now, assume all documents have been split into workable chunks

**Process**:
1. For each query, retrieve the data chunks most relevant to this query
2. Minor post-processing is often needed to join retrieved data chunks with user prompt to generate final prompt
3. Final prompt is fed into the generative model

## Retrieval Algorithms

**Note**: RAG's retriever uses information retrieval algorithms. Information retrieval has a long history predating generative AI. Many mature, battle-tested search solutions can be used as a retriever, including:
- Elasticsearch
- Apache Solr
- Amazon Kendra
- Algolia
- Google Cloud Search
- Microsoft Azure Cognitive Search

These solutions work well out of the box for many use cases.

# Sparse Versus Dense Retrieval

There are two main families of retrieval algorithms: **term-based** and **embedding-based**.

**Term-based retrieval** (also called sparse retrieval):
- Searches for data based on terms (words or phrases)
- Example: If query is "machine learning", search for data containing these terms

**Embedding-based retrieval** (also called dense retrieval or semantic retrieval):
- Searches based on semantic similarity
- Convert both query and data into embeddings
- Search for data whose embeddings are closest to query embedding

## Term-based retrieval

Term-based retrieval works by matching terms in the query with terms in the documents. The more terms a document shares with the query, the more relevant it is considered to be.

**Foundation: TF-IDF** (Term Frequency-Inverse Document Frequency)

**Two Components**:

1. **TF (Term Frequency)**: How often a term appears in a document
   - The more a term appears in a document, the more important it is to that document
   - Example: A document mentioning "banana" 10 times is likely more about bananas than a document mentioning it once

2. **IDF (Inverse Document Frequency)**: How rare a term is across all documents
   - The rarer a term is, the more informative it is
   - Example: "the" appears in many documents (not informative), "EADDRNOTAVAIL" appears rarely (very informative)

**TF-IDF Score**: Multiplies TF by IDF
- High score = term appears frequently in this document but rarely in other documents
- This document is likely highly relevant to this term

**Example Inverted Index**:

| Term | # docs containing this term | (doc ID, term frequency) |
|------|----------------------------|--------------------------|
| banana | 2 | (10, 3), (5, 2) |
| machine | 4 | (1, 5), (10, 1), (38, 9), (42, 5) |
| learning | 3 | (1, 5), (38, 7), (42, 5) |

**BM25** (Okapi BM25):
- 25th generation of the Best Matching algorithm
- Developed by Robertson et al. in the 1980s
- Scorer is a modification of TF-IDF
- Compared to naive TF-IDF, BM25 normalizes term frequency scores by document length
- Longer documents are more likely to contain a given term and have higher term frequency values

BM25 and its variances (BM25+, BM25F) are still widely used in the industry and serve as formidable baselines to compare against modern, more sophisticated retrieval algorithms.

**Tokenization**: The process of breaking a query into individual terms:
- Simplest method: Split query into words, treating each word as a separate term
- Challenge: Multi-word terms being broken up (e.g., "hot dog" → "hot" and "dog")
- Solution: Treat most common n-grams as terms

**Preprocessing Steps**:
- Convert all characters to lowercase
- Remove punctuation
- Eliminate stop words (like "the", "and", "is", etc.)

Classical NLP packages (NLTK, spaCy, Stanford's CoreNLP) offer tokenization functionalities.

**N-gram Overlap**: Can we retrieve documents based on extent of their n-gram overlap with the query?
- Yes, we can
- Works best when query and documents are of similar lengths
- If documents are much longer than query, many documents will have similarly high overlap scores
- Makes it difficult to distinguish truly relevant documents from less relevant ones

## Embedding-based retrieval

**Limitation of Term-based Retrieval**: Computes relevance at a lexical level rather than a semantic level. As mentioned in Chapter 3, the appearance of a text doesn't necessarily capture its meaning.

**Example Problem**: Querying "transformer architecture" might return documents about the electric device or the movie *Transformers*.

**Solution: Semantic Retrieval**: Embedding-based retrievers aim to rank documents based on how closely their meanings align with the query.

**Workflow**:

../images/aien_0603.png

**Figure 6-3. A high-level view of how an embedding-based, or semantic, retriever works.**

**Indexing**: Has an extra function compared to term-based retrieval:
- Converting original data chunks into embeddings
- Database where generated embeddings are stored is called a **vector database**

**Querying** consists of two steps:
1. **Embedding model**: Convert the query into an embedding using the same embedding model used during indexing
2. **Retriever**: Fetch *k* data chunks whose embeddings are closest to the query embedding

The number of data chunks to fetch, *k*, depends on the use case, the generative model, and the query.

**Note**: The workflow shown is simplified. Real-world semantic retrieval systems might contain other components:
- Reranker to rerank all retrieved candidates
- Caches to reduce latency

**Embeddings Recap**: An embedding is typically a vector that aims to preserve the important properties of the original data. An embedding-based retriever doesn't work if the embedding model is bad.

**Vector Databases**: A vector database stores vectors. However:
- **Storing is the easy part**
- **Hard part is vector search**: Given a query embedding, finding vectors in the database close to the query and returning them
- Vectors have to be indexed and stored in a way that makes vector search fast and efficient

**Vector Search is Not Unique to Generative AI**: Vector search is common in any application that uses embeddings:
- Search
- Recommendation
- Data organization
- Information retrieval
- Clustering
- Fraud detection

### Vector Search Algorithms

**Problem Framing**: Vector search is typically framed as a nearest-neighbor search problem. For example, given a query, find the *k* nearest vectors.

**Naive Solution: k-Nearest Neighbors (k-NN)**:
1. Compute similarity scores between query embedding and all vectors in database (using metrics like cosine similarity)
2. Rank all vectors by similarity scores
3. Return *k* vectors with highest similarity scores

**Limitations**: Ensures results are precise, but it's computationally heavy and slow. Should be used only for small datasets.

**Solution: Approximate Nearest Neighbor (ANN)**: For large datasets, vector search is typically done using ANN algorithms. Due to the importance of vector search, many algorithms and libraries have been developed:
- **FAISS** (Facebook AI Similarity Search)
- **ScaNN** (Scalable Nearest Neighbors) by Google
- **Annoy** by Spotify
- **Hnswlib** (Hierarchical Navigable Small World)

**General Approach**: Vector databases organize vectors into:
- Buckets
- Trees
- Graphs

Vector search algorithms differ based on the heuristics they use to increase the likelihood that similar vectors are close to each other.

**Optimization**: Vectors can also be:
- **Quantized** (reduced precision)
- Made **sparse**
- Idea: Quantized and sparse vectors are less computationally intensive to work with

**Major Vector Search Algorithms**:

**LSH (Locality-Sensitive Hashing)** (Indyk and Motwani, 1999):
- Powerful and versatile algorithm that works with more than just vectors
- Involves hashing similar vectors into the same buckets to speed up similarity search
- Trading some accuracy for efficiency
- Implemented in FAISS and Annoy

**HNSW (Hierarchical Navigable Small World)** (Malkov and Yashunin, 2016):
- Constructs a multi-layer graph where nodes represent vectors
- Edges connect similar vectors
- Allows nearest-neighbor searches by traversing graph edges
- Implementation is open source
- Also implemented in FAISS and Milvus

**Product Quantization** (Jégou et al., 2011):
- Works by reducing each vector into a much simpler, lower-dimensional representation
- Decomposing each vector into multiple subvectors
- Distances are computed using lower-dimensional representations (much faster to work with)
- Key component of FAISS
- Supported by almost all popular vector search libraries

**IVF (Inverted File Index)** (Sivic and Zisserman, 2003):
- Uses K-means clustering to organize similar vectors into the same cluster
- Typical to set number of clusters so that, on average, there are 100 to 10,000 vectors in each cluster
- During querying, IVF finds cluster centroids closest to query embedding
- Vectors in these clusters become candidate neighbors
- Together with product quantization, IVF forms the backbone of FAISS

**Annoy (Approximate Nearest Neighbors Oh Yeah)** (Bernhardsson, 2013):
- Tree-based approach
- Builds multiple binary trees
- Each tree splits vectors into clusters using random criteria
- During search, traverses these trees to gather candidate neighbors
- Spotify has open sourced its implementation

**Other Algorithms**:
- Microsoft's SPTAG (Space Partition Tree And Graph)
- FLANN (Fast Library for Approximate Nearest Neighbors)

**Important Note**: Even though vector databases emerged as their own category with the rise of RAG, any database that can store vectors can be called a vector database. Many traditional databases have extended or will extend to support vector storage and vector search.

## Comparing retrieval algorithms

Due to the long history of retrieval, its many mature solutions make both term-based and embedding-based retrieval relatively easy to start. Each approach has its pros and cons.

### Speed

**Term-based retrieval**: Generally much faster than embedding-based retrieval during both indexing and query
- Term extraction is faster than embedding generation
- Mapping from a term to documents that contain it can be less computationally expensive than nearest-neighbor search

### Performance

**Term-based retrieval**:
- Works well out of the box
- Solutions like Elasticsearch and BM25 have successfully powered many applications
- However, its simplicity means fewer components you can tweak to improve performance

**Embedding-based retrieval**:
- Can be significantly improved over time to outperform term-based retrieval
- You can finetune the embedding model and the retriever (separately, together, or in conjunction with the generative model)
- **Limitation**: Converting data into embeddings can obscure keywords (specific error codes like EADDRNOTAVAIL (99), or product names), making them harder to search later on
- This limitation can be addressed by combining embedding-based retrieval with term-based retrieval

### Evaluation Metrics

The quality of a retriever can be evaluated based on the quality of the data it retrieves. Two metrics often used by RAG evaluation frameworks:

**Context Precision** (also called *context relevance*):
- Out of all the documents retrieved, what percentage is relevant to the query?

**Context Recall**:
- Out of all the documents that are relevant to the query, what percentage is retrieved?

**Computing These Metrics**:
1. Curate an evaluation set with a list of test queries and a set of documents
2. For each test query, annotate each test document to be relevant or not relevant
3. Annotation can be done either by humans or AI judges
4. Compute the precision and recall score of the retriever on this evaluation set

**Production Considerations**: In production, some RAG frameworks only support context precision, not context recall:
- To compute context recall for a given query, you need to annotate the relevance of all documents in your database to that query
- Context precision is simpler to compute—you only need to compare retrieved documents to the query (can be done by an AI judge)

**Ranking Metrics**: If you care about the ranking of retrieved documents (more relevant documents should be ranked first), you can use metrics such as:
- **NDCG** (Normalized Discounted Cumulative Gain)
- **MAP** (Mean Average Precision)
- **MRR** (Mean Reciprocal Rank)

**Embedding Quality**: For semantic retrieval, you need to also evaluate the quality of your embeddings:
- Embeddings can be evaluated independently—they are considered good if more-similar documents have closer embeddings
- Embeddings can also be evaluated by how well they work for specific tasks
- The MTEB benchmark evaluates embeddings for a broad range of tasks including retrievals, classification, and clustering

**System-Level Evaluation**: The quality of a retriever should also be evaluated in the context of the whole RAG system. Ultimately, a retriever is good if it helps the system generate high-quality answers.

### Cost and Latency Considerations

**Is the Performance Promise Worth It?** Whether the performance promise of a semantic retrieval system is worth pursuing depends on how much you prioritize cost and latency, particularly during the querying phase.

**Latency**: Since much of RAG latency comes from output generation (especially for long outputs), the added latency by query embedding generation and vector search might be minimal compared to the total RAG latency. Even so, the added latency can still impact user experience.

**Cost**: Generating embeddings costs money. This is especially an issue if your data changes frequently and requires frequent embedding regeneration. Imagine having to generate embeddings for 100 million documents every day!

Depending on what vector databases you use, vector storage and vector search queries can be expensive too. **It's not uncommon to see a company's vector database spending be one-fifth or even half of their spending on model APIs.**

### Comparison Table

**Table 6-2. Term-based retrieval and semantic retrieval by speed, performance, and cost**

| | Term-based retrieval | Embedding-based retrieval |
|---|---|---|
| **Querying speed** | Much faster than embedding-based retrieval | Query embedding generation and vector search can be slow |
| **Performance** | Typically strong performance out of the box, but hard to improve. Can retrieve wrong documents due to term ambiguity | Can outperform term-based retrieval with finetuning. Allows for use of more natural queries, as it focuses on semantics instead of terms |
| **Cost** | Much cheaper than embedding-based retrieval | Embedding, vector storage, and vector search solutions can be expensive |

### Indexing vs Querying Trade-offs

With retrieval systems, you can make certain trade-offs between indexing and querying:
- The more detailed the index is, the more accurate the retrieval process will be
- But the indexing process will be slower and more memory-consuming

**Example**: Imagine building an index of potential customers. Adding more details (name, company, email, phone, interests) makes it easier to find relevant people but takes longer to build and requires more storage.

**General Rule**:
- A detailed index like HNSW provides high accuracy and fast query times but requires significant time and memory to build
- A simpler index like LSH is quicker and less memory-intensive to create, but results in slower and less accurate queries

**Benchmark**: The ANN-Benchmarks website compares different ANN algorithms on multiple datasets using four main metrics, taking into account the trade-offs between indexing and querying:
- Query latency
- Index build time
- Queries per second
- Recall

## Combining retrieval algorithms

Given the trade-offs between term-based and embedding-based retrieval, many systems use both approaches together. This is called **hybrid search** or **hybrid retrieval**.

**How Hybrid Search Works**:
1. Run both term-based retrieval and embedding-based retrieval on the same query
2. Each retrieval method returns its own ranked list of documents
3. Combine the two lists using a ranking algorithm

**Benefits**:
- Leverages strengths of both approaches
- Term-based retrieval good for exact matches (product codes, error messages)
- Embedding-based retrieval good for semantic understanding
- More robust overall system

**Combining Strategies**:
- Linear combination of scores
- Reciprocal rank fusion
- Weighted voting
- Reranking (discussed next)

## Retrieval Optimization

Beyond choosing the right retrieval algorithm, there are several techniques to optimize retrieval performance.

### Chunking strategy

When documents are split into chunks, the chunking strategy significantly impacts retrieval quality.

**Key Considerations**:

**Chunk Size**: How big should each chunk be?
- Too small: May lack context
- Too large: May dilute relevance signal
- Typical sizes: 100-500 tokens

**Overlap**: Should chunks overlap?
- Overlapping chunks can help preserve context across boundaries
- Example: If chunk boundary splits a paragraph, overlap ensures the paragraph context is preserved
- Typical overlap: 10-20% of chunk size

**Semantic Boundaries**: Should chunks respect semantic boundaries?
- Chunking at paragraph boundaries often works better than arbitrary token limits
- Preserves natural information units
- Can use NLP to identify sentence/paragraph boundaries

**Dynamic Chunking**: Should chunk size vary by content type?
- Technical documentation might need smaller chunks
- Narrative content might work with larger chunks
- Can adapt based on document structure

**Chunking is an Active Research Area**: No one-size-fits-all solution. Best approach depends on:
- Document types
- Query types
- Downstream task
- Model capabilities

### Reranking

After initial retrieval, you can use a more sophisticated model to **rerank** the retrieved documents before passing them to the generator.

**Why Reranking Works**:
- Initial retrieval (especially fast methods like BM25) prioritizes speed over perfect ranking
- Reranker can use more compute to get better ranking
- Only need to rerank small set of candidates (e.g., top 20-100), not entire database

**Reranking Models**:
- Cross-encoders that jointly encode query and document
- More accurate than initial retrieval but slower
- Examples: BERT-based rerankers, specialized reranking models

**Time-based Reranking**: Documents can also be reranked based on time, giving higher weight to more recent data. This is useful for:
- Time-sensitive applications
- News aggregation
- Chat with your emails
- Stock market analysis

**Context Reranking vs Search Reranking**: Context reranking differs from traditional search reranking in that the exact position of items is less critical:
- In search, the rank (first or fifth) is crucial
- In context reranking, order of documents still matters (models better understand documents at beginning and end of context)
- However, as long as a document is included, the impact of its order is less significant compared to search ranking

### Query rewriting

**Query rewriting** (also known as query reformulation, query normalization, or query expansion) helps handle ambiguous or context-dependent queries.

**Example Scenario**:
```
User: When was the last time John Doe bought something from us?
AI: John last bought a Fruity Fedora hat from us two weeks ago, 
on January 3, 2030.
User: How about Emily Doe?
```

The last question, "How about Emily Doe?", is ambiguous without context. If you use this query verbatim to retrieve documents, you'll likely get irrelevant results.

**Solution**: Rewrite the query to reflect what the user is actually asking. The new query should make sense on its own. In this case, the query should be rewritten to "When was the last time Emily Doe bought something from us?"

**Implementation**: Query rewriting can be done using other AI models, using a prompt similar to "Given the following conversation, rewrite the last user input to reflect what the user is actually asking".

../images/aien_0604.png

**Figure 6-4. You can use other generative models to rewrite queries.**

**Complexity**: Query rewriting can get complicated, especially if you need to do identity resolution or incorporate other knowledge. For example, if the user asks "How about his wife?" you will first need to query your database to find out who his wife is. If you don't have this information, the rewriting model should acknowledge that this query isn't solvable instead of hallucinating a name.

**Note**: Query rewriting isn't unique to RAG. In traditional search engines, query rewriting is often done using heuristics.

### Contextual retrieval

The idea behind contextual retrieval is to **augment each chunk with relevant context** to make it easier to retrieve the relevant chunks.

**Simple Technique**: Augment a chunk with metadata like tags and keywords:
- For ecommerce, a product can be augmented by its description and reviews
- Images and videos can be queried by their titles or captions

**Entity Extraction**: The metadata may also include entities automatically extracted from the chunk:
- If your document contains specific terms like the error code EADDRNOTAVAIL (99), adding them to the document's metadata allows the system to retrieve it by that keyword, even after the document has been converted into embeddings

**Question Augmentation**: You can augment each chunk with the questions it can answer:
- For customer support, augment each article with related questions
- Example: The article on how to reset password can be augmented with queries like:
  - "How to reset password?"
  - "I forgot my password"
  - "I can't log in"
  - "Help, I can't find my account"

**Document Context**: If a document is split into multiple chunks, some chunks might lack necessary context to help the retriever understand what the chunk is about. To avoid this, you can augment each chunk with context from the original document:
- Original document's title and summary
- Anthropic used AI models to generate a short context (usually 50-100 tokens) that explains the chunk and its relationship to the original document

**Anthropic's Prompt for Contextual Retrieval**:
```
<document> 
{{WHOLE_DOCUMENT}} 
</document>

Here is the chunk we want to situate within the whole document: 

<chunk>
{{CHUNK_CONTENT}}
</chunk> 

Please give a short succinct context to situate this chunk within 
the overall document for the purposes of improving search retrieval 
of the chunk. Answer only with the succinct context and nothing else.
```

The generated context for each chunk is prepended to each chunk, and the augmented chunk is then indexed by the retrieval algorithm.

../images/aien_0605.png

**Figure 6-5. Anthropic augments each chunk with a short context that situates this chunk within the original document, making it easier for the retriever to find the relevant chunks given a query.**

# Evaluating Retrieval Solutions

Here are some key factors to keep in mind when evaluating a retrieval solution:

**Retrieval Mechanisms**:
- What retrieval mechanisms does it support?
- Does it support hybrid search?

**Vector Database Specifics**:
- What embedding models does it support?
- What vector search algorithms does it support?

**Scalability**:
- How scalable is it, both in terms of data storage and query traffic?
- Does it work for your traffic patterns?

**Performance**:
- What is the query latency?
- What is the indexing time?
- What is the recall/precision?

**Cost**:
- Storage costs
- Query costs
- Embedding generation costs

**Ease of Use**:
- How easy is it to set up?
- How easy is it to maintain?
- What is the learning curve?

**Integration**:
- Does it integrate with your existing stack?
- What APIs does it provide?

**Reliability**:
- What is the uptime?
- What are the failure modes?
- How does it handle errors?

## RAG Beyond Texts

While most RAG systems work with text, RAG can be extended to other modalities.

### Multimodal RAG

Multimodal RAG can augment a query with both text and images.

**Example Use Case**: Imagine you want to know what movie a scene is from. You can upload an image of the scene along with the text query "What movie is this from?"

../images/aien_0606.png

**Figure 6-6. Multimodal RAG can augment a query with both text and images.**

**How It Works**:
1. Query can include both text and images
2. Retrieval can work with multimodal embeddings (like CLIP)
3. Retrieved context can include both text and images
4. Multimodal model generates response based on multimodal context

**Applications**:
- Visual question answering
- Product recommendations based on images
- Medical diagnosis with medical images
- Document understanding with diagrams

### RAG with tabular data

Many applications need to work with tabular data (databases, spreadsheets, data warehouses).

**Example**: For Kitty Vogue's recommendation system, you might want to answer queries like:
- "What was our best-selling product last month?"
- "Which customers bought Fruity Fedora?"
- "Project the sales revenue for Fruity Fedora over the next three months"

**Challenge**: You can't just retrieve entire tables—they might be too large or contain sensitive information.

**Solution**: Use a three-step process:

../images/aien_0607.png

**Figure 6-7. A RAG system that augments context with tabular data.**

**Step 1: Text-to-SQL**:
- Based on user query and provided table schemas, determine what SQL query is needed
- Text-to-SQL is an example of semantic parsing (discussed in Chapter 2)

**Step 2: SQL Execution**:
- Execute the SQL query

**Step 3: Generation**:
- Generate a response based on SQL result and original user query

**Additional Consideration**: If there are many available tables whose schemas can't all fit into the model context, you might need an intermediate step to predict what tables to use for each query.

**Model Choice**: Text-to-SQL can be done by:
- The same generator that generates the final response
- A specialized text-to-SQL model

**Transition to Agents**: In this section, we've discussed how tools such as retrievers and SQL executors can enable models to handle more queries and generate higher-quality responses. Would giving a model access to more tools improve its capabilities even more? Tool use is a core characteristic of the agentic pattern, which we'll discuss in the next section.

# Agents

Intelligent agents are considered by many to be the ultimate goal of AI. The classic book by Stuart Russell and Peter Norvig, *Artificial Intelligence: A Modern Approach*, defines the field of *artificial intelligence research* as "the study and design of rational agents."

**Why Agents are Exciting Now**: The unprecedented capabilities of foundation models have opened the door to agentic applications that were previously unimaginable. These new capabilities make it finally possible to develop autonomous, intelligent agents to act as:
- Our assistants
- Coworkers
- Coaches

**Potential Applications**: They can help us:
- Create a website
- Gather data
- Plan a trip
- Do market research
- Manage a customer account
- Automate data entry
- Prepare us for interviews
- Interview our candidates
- Negotiate a deal
- And much more

The possibilities seem endless, and the potential economic value of these agents is enormous.

**Warning**: AI-powered agents are an emerging field, with no established theoretical frameworks for defining, developing, and evaluating them. This section is a best-effort attempt to build a framework from the existing literature, but it will evolve as the field does. Compared to the rest of the book, this section is more experimental.

**Section Structure**: This section will:
1. Start with an overview of agents
2. Continue with two aspects that determine agent capabilities: tools and planning
3. End with discussion on how to evaluate agents to catch failures

**Foundation**: Even though agents are novel, they are built upon concepts that have already appeared in this book:
- Self-critique
- Chain-of-thought
- Structured outputs

## Agent Overview

The term *agent* has been used in many different engineering contexts:
- Software agent
- Intelligent agent
- User agent
- Conversational agent
- Reinforcement learning agent

**Definition**: An agent is anything that can perceive its environment and act upon that environment. This means that an agent is characterized by:
1. **The environment** it operates in
2. **The set of actions** it can perform

### Environment

The *environment* an agent can operate in is defined by its use case:
- If an agent is developed to play a game (*Minecraft*, Go, *Dota*), that game is its environment
- If you want an agent to scrape documents from the internet, the environment is the internet
- If your agent is a cooking robot, the kitchen is its environment
- A self-driving car agent's environment is the road system and its adjacent areas

### Actions and Tools

The *set of actions* an AI agent can perform is augmented by the *tools* it has access to.

**Examples of Agents with Tools**:
- ChatGPT is an agent that can search the web, execute Python code, and generate images
- RAG systems are agents, and text retrievers, image retrievers, and SQL executors are their tools

**Dependency Between Environment and Tools**:
- The environment determines what tools an agent can potentially use
  - Example: If environment is a chess game, only possible actions are valid chess moves
- An agent's tool inventory restricts the environment it can operate in
  - Example: If a robot's only action is swimming, it'll be confined to a water environment

**Example: SWE-agent**:

../images/aien_0608.png

**Figure 6-8. SWE-agent is a coding agent whose environment is the computer and whose actions include navigation, search, and editing.**

SWE-agent (Yang et al., 2024) is an agent built on top of GPT-4:
- Environment: The computer with the terminal and the file system
- Set of actions: Navigate repo, search files, view files, edit lines

### AI as the Brain

An AI agent is meant to accomplish tasks typically provided by the users in the inputs. In an AI agent:
- **AI is the brain** that processes information it receives
- Including the task and feedback from the environment
- Plans a sequence of actions to achieve this task
- Determines whether the task has been accomplished

**Example: RAG System with Tabular Data**

This is a simple agent with three actions:
1. Response generation
2. SQL query generation
3. SQL query execution

Given the query "Project the sales revenue for Fruity Fedora over the next three months", the agent might perform the following sequence:

1. **Reason**: To predict future sales, first need sales numbers from last five years
2. **Invoke**: SQL query generation to generate query for last five years' sales
3. **Invoke**: SQL query execution to execute query
4. **Reason**: Numbers are insufficient (missing values). Also need information about past marketing campaigns
5. **Invoke**: SQL query generation for past marketing campaigns
6. **Invoke**: SQL query execution
7. **Reason**: New information is sufficient to predict future sales. Generate projection
8. **Reason**: Task has been successfully completed

### Model Requirements for Agents

Compared to non-agent use cases, agents typically require more powerful models for two reasons:

**Reason 1: Complex Tasks**:
- Agents typically work on complex tasks that require multiple steps
- Need strong reasoning and planning capabilities
- Need ability to break down problems

**Reason 2: Multiple Tool Interactions**:
- Agents need to decide which tool to use when
- Need to understand tool outputs
- Need to correct mistakes
- Need to track progress toward goal

## Tools

Tools are what give agents the ability to act upon the environment. We can categorize tools by their purpose.

### Knowledge augmentation

These tools help agents access information they don't have in their training data or that's changed since training.

**Examples**:
- **Web search**: Access current information from the internet
- **Database query**: Retrieve specific data from databases
- **Document retrieval**: Access company documents, manuals, policies
- **API calls**: Get real-time data (weather, stock prices, news)

**Why Important**:
- Models have knowledge cutoffs
- Need access to private/proprietary data
- Need real-time information
- Need domain-specific knowledge

### Capability extension

These tools help agents do things they can't do with language generation alone.

**Examples**:
- **Code execution**: Run Python/JavaScript code
  - Enables precise calculations
  - Data analysis
  - Visualization
- **Image generation**: Create images using DALL-E, Stable Diffusion
- **Image analysis**: Analyze images using computer vision models
- **Audio processing**: Transcribe, synthesize, or analyze audio
- **External APIs**: Access specialized services (translation, sentiment analysis, etc.)

**Why Important**:
- Language models alone can't execute code reliably
- Can't create images from scratch
- Can't perform precise mathematical computations
- Need specialized capabilities

### Write actions

These tools allow agents to make changes to the world, not just observe it.

**Examples**:
- **Database modifications**: INSERT, UPDATE, DELETE operations
- **File operations**: Create, modify, delete files
- **Email/messaging**: Send emails, Slack messages
- **API calls with side effects**: Purchase items, book appointments, transfer money
- **Code commits**: Make changes to codebases

**Why Risky**:
- Can cause irreversible damage
- Can affect other users/systems
- Errors can be costly
- Security and privacy concerns

**Best Practices**:
- Require human approval for risky operations
- Implement safeguards and validation
- Use read-only modes when possible
- Log all write operations
- Have rollback mechanisms

## Planning

Planning is the process of determining what sequence of actions to take to accomplish a goal.

### Planning overview

**Core Problem**: Given a task, what steps should the agent take to accomplish it?

**Example Task**: "Research competitors and write a report"

**Possible Plan**:
1. Identify who the main competitors are
2. For each competitor, gather information about:
   - Products/services
   - Pricing
   - Market share
   - Strengths/weaknesses
3. Analyze the competitive landscape
4. Identify opportunities and threats
5. Write the report

**Why Planning Matters**:
- Complex tasks require multiple steps
- Steps may need to be performed in order
- Some steps depend on results of previous steps
- Need to handle failures and revise plans

**Decoupling Planning and Execution**: One approach is to separate plan generation from execution:

../images/aien_0609.png

**Figure 6-9. Decoupling planning and execution so that only validated plans are executed.**

**Components**:
1. **Planner**: Generates plans
2. **Validator**: Evaluates plans before execution
3. **Executor**: Carries out validated plans

This is now a multi-agent system—each component can be considered an agent.

**Benefits of Validation**:
- Catch bad plans before execution
- Reduce risk of harmful actions
- Opportunity for human review
- Can improve plans iteratively

**Parallel Generation**: To speed up the process:
- Generate several plans in parallel
- Ask evaluator to pick the most promising one
- This is a latency/cost trade-off (generating multiple plans simultaneously incurs extra costs)

**Intent Classification**: Planning requires understanding the intention behind a task: what's the user trying to do with this query?

An **intent classifier** is often used to help agents plan. Intent classification can be done using:
- Another prompt
- A classification model trained for this task

The intent classification mechanism can be considered another agent in your multi-agent system.

**Benefits of Intent Classification**:
- Helps agent pick the right tools
- Example: For customer support, if query is about billing, agent might need access to payment retrieval tool
- But if query is about resetting password, agent might need to access documentation retrieval

**Tip**: Some queries might be out of scope of the agent. The intent classifier should be able to classify requests as IRRELEVANT so that the agent can politely reject those instead of wasting FLOPs coming up with impossible solutions.

**Human in the Loop**: So far, we've assumed the agent automates all three stages: generating plans, validating plans, and executing plans. In reality, humans can be involved at any of those stages:
- **Human expert can provide a plan**: For complex tasks where agent has trouble generating the whole plan
- **Human can validate a plan**: If a plan involves risky operations (updating database, merging code change)
- **Human can execute parts of a plan**: For operations requiring judgment or that are too risky to automate

To make this possible, you need to clearly define the level of automation an agent can have for each action.

**Summary of Planning Process**: Solving a task typically involves:

1. **Plan generation**: Come up with a plan for accomplishing this task (sequence of manageable actions). Also called task decomposition
2. **Reflection and error correction**: Evaluate the generated plan. If it's a bad plan, generate a new one (optional but significantly boosts performance)
3. **Execution**: Take the actions outlined in the generated plan (often involves calling specific functions)
4. **Reflection and error correction**: Upon receiving action outcomes, evaluate these outcomes and determine whether goal has been accomplished. Identify and correct mistakes. If goal not completed, generate a new plan

**Familiar Techniques**: You've already seen some techniques for plan generation and reflection in this book:
- When you ask a model to "think step by step", you're asking it to decompose a task
- When you ask a model to "verify if your answer is correct", you're asking it to reflect

### Foundation models as planners

**Open Question**: How well can foundation models plan?

**Skepticism**: Many researchers believe that foundation models, at least those built on top of autoregressive language models, cannot:
- Meta's Chief AI Scientist Yann LeCun states unequivocally that autoregressive LLMs can't plan
- Kambhampati argues that LLMs are great at extracting knowledge but not planning
- Suggests papers claiming planning abilities of LLMs confuse general planning knowledge extracted from LLMs with executable plans
- "The plans that come out of LLMs may look reasonable to the lay user, and yet lead to execution time interactions and errors"

**Uncertainty**: While there's a lot of anecdotal evidence that LLMs are poor planners, it's unclear whether:
- We don't know how to use LLMs the right way
- OR LLMs, fundamentally, can't plan

**Planning as Search**: Planning, at its core, is a search problem:
- You search among different paths to the goal
- Predict the outcome (reward) of each path
- Pick the path with the most promising outcome
- Often determine that no path exists that can take you to the goal

**Backtracking**: Search often requires backtracking:
- Example: At a step where there are two possible actions: A and B
- After taking action A, you enter a state that's not promising
- Need to backtrack to previous state to take action B

**Argument Against Autoregressive Models**: Some argue that an autoregressive model can only generate forward actions:
- Can't backtrack to generate alternate actions
- Therefore, autoregressive models can't plan

**Counter-Argument**: However, this isn't necessarily true:
- After executing a path with action A, if the model determines this path doesn't make sense, it can revise the path using action B instead, effectively backtracking
- The model can also always start over and choose another path

**Missing Tooling**: It's also possible that LLMs are poor planners because they aren't given the toolings needed to plan. To plan, it's necessary to know:
- Not only the available actions
- But also **the potential outcome of each action**

**Example**: If you want to walk up a mountain:
- Potential actions: turn right, turn left, turn around, go straight ahead
- However, if turning right will cause you to fall off the cliff, you might not want to consider this action
- In technical terms, an action takes you from one state to another
- It's necessary to know the outcome state to determine whether to take an action

**Implication**: It's not sufficient to prompt a model to generate only a sequence of actions like what the popular chain-of-thought prompting technique does.

**World Model Approach**: The paper "Reasoning with Language Model is Planning with World Model" (Hao et al., 2023) argues:
- An LLM, by containing so much information about the world, is capable of predicting the outcome of each action
- This LLM can incorporate this outcome prediction to generate coherent plans

**Hybrid Approach**: Even if AI can't plan, it can still be a part of a planner:
- It might be possible to augment an LLM with a search tool and state tracking system to help it plan

## Foundation Model (FM) Versus Reinforcement Learning (RL) Planners

The *agent* is a core concept in RL, which is defined in Wikipedia as a field "concerned with how an intelligent agent ought to take actions in a dynamic environment in order to maximize the cumulative reward."

**Similarities**: RL agents and FM agents are similar in many ways:
- Both characterized by their environments and possible actions

**Main Difference**: How their planners work:
- **RL agent**: Planner is trained by an RL algorithm (can require a lot of time and resources)
- **FM agent**: Model is the planner (can be prompted or finetuned to improve planning capabilities, generally requires less time and fewer resources)

**Future Direction**: However, there's nothing to prevent an FM agent from incorporating RL algorithms to improve its performance. In the long run, FM agents and RL agents will likely merge.

### Plan generation

The simplest way to turn a model into a plan generator is with **prompt engineering**.

**Example**: Imagine you want to create an agent to help customers learn about products at Kitty Vogue. You give this agent access to three external tools:
- Retrieve products by price
- Retrieve top products
- Retrieve product information

**Example Prompt** (for illustration purposes only; production prompts are likely more complex):

```
You are a helpful shopping assistant for Kitty Vogue. You have access 
to the following tools:
- retrieve_products_by_price(min_price, max_price)
- retrieve_top_products(category, limit)
- retrieve_product_info(product_id)

When a customer asks a question, create a step-by-step plan to answer 
it using these tools. Output your plan in the following format:

Step 1: [Action to take]
Step 2: [Next action]
...
Final: [Generate response based on gathered information]
```

**More Advanced Techniques**: Beyond simple prompting, there are more sophisticated approaches to plan generation that we'll explore.

#### Function calling

**Function calling** (also called tool calling) is a feature provided by many model APIs that makes it easier for models to use tools.

**How It Works**:
1. You provide the model with descriptions of available functions/tools
2. Model decides when to call a function
3. Model generates structured output specifying which function to call and with what parameters
4. You execute the function
5. You provide the result back to the model
6. Model continues with next steps or generates final response

**Example**:

../images/aien_0610.png

**Figure 6-10. An example of a model using two simple tools.**

**Benefits**:
- Structured way to use tools
- Model knows what tools are available
- Reduces errors in tool usage
- Makes it easier to validate tool calls

**Tip**: When designing tools, make them as simple and focused as possible. Instead of one complex tool that does many things, prefer multiple simple tools that each do one thing well.

#### Planning granularity

**Question**: How detailed should a plan be?

**Options**:
- **High-level plan**: "Research competitors" → "Analyze findings" → "Write report"
- **Low-level plan**: "Search for Company A" → "Read their website" → "Extract key features" → "Search for Company B" → ...

**Trade-offs**:
- **High-level plans**:
  - Faster to generate
  - Give executor more flexibility
  - But may be too vague to execute
- **Low-level plans**:
  - More specific and actionable
  - Easier to execute correctly
  - But slower to generate
  - Less flexible

**Adaptive Granularity**: Best approach often depends on:
- Task complexity
- Agent capabilities
- Risk tolerance
- Some systems start with high-level plans and recursively decompose each step as needed

#### Complex plans

Plans don't have to be linear sequences. They can have more complex structures:

../images/aien_0611.png

**Figure 6-11. Examples of different orders in which a plan can be executed.**

**Types of Plan Structures**:
- **Sequential**: Step 1 → Step 2 → Step 3
- **Parallel**: Multiple steps executed simultaneously
- **Conditional**: If X then do A, else do B
- **Iterative**: Repeat steps until condition met
- **Tree/Graph**: Complex dependencies between steps

**Considerations**:
- More complex plans are harder to generate and execute
- But can be more efficient
- Need to handle dependencies correctly
- May require sophisticated execution engines

### Reflection and error correction

**Reflection** is the process of evaluating an agent's actions and outputs to determine if they're correct and if the goal has been achieved.

**Why Reflection Matters**:
- Agents make mistakes
- Tools can fail
- Plans can be incomplete
- Outputs can be wrong
- Need mechanism to detect and correct errors

**ReAct Framework** (Reasoning + Acting):

../images/aien_0612.png

**Figure 6-12. A ReAct agent in action. Image from the ReAct paper (Yao et al., 2022).**

**ReAct Pattern**:
1. **Thought**: Agent reasons about what to do next
2. **Action**: Agent takes an action (uses a tool)
3. **Observation**: Agent observes the result
4. **Thought**: Agent reflects on the observation
5. Repeat until goal achieved

**Benefits**:
- Explicit reasoning traces
- Can detect mistakes in reasoning
- Can self-correct
- More interpretable

**Reflexion Framework**:

../images/aien_0613.png

**Figure 6-13. Examples of how Reflexion agents work.**

**Reflexion Approach**:
- After completing a task, agent reflects on its performance
- Generates feedback for itself
- Uses feedback to improve on next attempt
- Learns from mistakes without updating weights

**Forms of Reflection**:
- **Self-verification**: Check if output is correct
- **Self-critique**: Identify problems with output
- **Self-refinement**: Improve output based on critique
- **External validation**: Use external tools to verify correctness (e.g., running generated code)

### Tool selection

As agents have access to more tools, deciding which tool to use becomes more challenging.

**Challenge**: With many available tools:
- How does agent know which tool to use?
- In what order should tools be used?
- How to combine results from multiple tools?

**Tool Use Patterns**: Different models and tasks express different tool use patterns:

../images/aien_0614.png

**Figure 6-14. Different models and tasks express different tool use patterns.**

**Patterns Observed**:
- Some models prefer certain tools
- Some tasks naturally require specific tool sequences
- Usage patterns can vary widely

**Tip**: Track tool usage patterns in your application:
- Which tools are used together?
- In what order?
- For what types of queries?
- Can help optimize tool selection and plan generation

**Tool Transition Tree**:

../images/aien_0615.png

**Figure 6-15. A tool transition tree showing common tool usage sequences.**

**Using Transition Patterns**:
- Can learn common tool sequences from data
- Use to bias agent toward effective patterns
- Help validate generated plans
- Improve efficiency

## Agent Failure Modes and Evaluation

Agents, with their new modes of operations, have new modes of failures.

### Planning failures

**Types of Planning Failures**:

**1. Incomplete Plans**:
- Agent doesn't generate all necessary steps
- Skips important subtasks
- Plan doesn't actually achieve the goal

**2. Incorrect Ordering**:
- Steps are in wrong order
- Dependencies not respected
- Later steps depend on earlier steps that haven't been done

**3. Impossible Plans**:
- Plans actions that can't be executed
- Uses tools that don't exist
- Makes assumptions that aren't true

**4. Inefficient Plans**:
- Takes too many steps
- Redundant actions
- Could achieve goal more directly

**5. Stuck in Loops**:
- Agent repeats same failed action
- Doesn't learn from failures
- Can't recover from errors

**Evaluation Approaches**:
- **Success rate**: What percentage of tasks are completed successfully?
- **Plan quality**: How good are the generated plans?
- **Efficiency**: How many steps does it take?
- **Human evaluation**: Do plans make sense to humans?

### Tool failures

**Types of Tool Failures**:

**1. Wrong Tool Selection**:
- Agent uses wrong tool for the task
- Misunderstands what tools do
- Ignores better alternatives

**2. Incorrect Tool Usage**:
- Wrong parameters passed to tool
- Parameters in wrong format
- Missing required parameters

**3. Not Handling Tool Errors**:
- Tool execution fails
- Agent doesn't handle error appropriately
- Doesn't try alternative approaches

**4. Misinterpreting Tool Outputs**:
- Agent misunderstands what tool returned
- Draws wrong conclusions from results
- Doesn't validate outputs

**Evaluation Approaches**:
- **Tool call accuracy**: Are right tools called with right parameters?
- **Error handling**: How well does agent handle tool failures?
- **Output interpretation**: Does agent correctly understand tool outputs?

### Efficiency

**Efficiency Concerns**:

**1. Cost**:
- Each model call costs money
- Tool executions cost money
- More steps = higher cost
- Need to balance quality with cost

**2. Latency**:
- Users have to wait for agent to complete
- Each tool call adds latency
- Parallel execution can help but has limits
- Need to balance thoroughness with speed

**3. Resource Usage**:
- Agents can consume significant compute
- May need rate limiting
- Need to prevent runaway agents

**Metrics to Track**:
- **Average steps per task**: How many steps does agent typically take?
- **Average cost per task**: How much does each task cost?
- **Average latency**: How long does each task take?
- **Success rate vs cost/latency**: What's the trade-off?

**Optimization Strategies**:
- Cache tool results when possible
- Parallelize independent steps
- Use cheaper models for simpler subtasks
- Implement timeouts and step limits
- Monitor and optimize tool usage patterns

# Summary

This chapter covered two powerful patterns for enhancing AI models with external information and capabilities:

## RAG (Retrieval-Augmented Generation)

**Core Concept**:
- Enhances model generation by retrieving relevant information from external sources
- Allows models to access information beyond their training data
- Constructs query-specific context

**Why RAG Remains Important**:
- Data growth outpaces context length expansion
- Long context doesn't guarantee effective use
- RAG enables efficient, targeted information access
- Reduces cost and latency compared to very long contexts

**Architecture**:
- **Retriever**: Fetches relevant information
- **Generator**: Produces response using retrieved information

**Retrieval Algorithms**:
- **Term-based retrieval** (BM25, TF-IDF): Fast, cheap, works well out of box
- **Embedding-based retrieval**: Semantic understanding, can be finetuned, higher cost
- **Hybrid search**: Combines both approaches for best results

**Retrieval Optimization**:
- **Chunking**: How to split documents
- **Reranking**: Improve ranking of retrieved documents
- **Query rewriting**: Handle ambiguous queries
- **Contextual retrieval**: Augment chunks with context

**Evaluation Metrics**:
- Context precision/recall
- Embedding quality (MTEB)
- End-to-end system quality

**Beyond Text**:
- Multimodal RAG (text + images)
- RAG with tabular data (Text-to-SQL)

## Agents

**Core Concept**:
- Agents can perceive environment and act upon it
- Characterized by environment and available actions
- Use tools to extend capabilities

**Components**:
- **Environment**: Where agent operates
- **Actions/Tools**: What agent can do
- **Planning**: How agent decides what to do
- **Execution**: Actually performing actions

**Tools Enable**:
- **Knowledge augmentation**: Web search, database queries
- **Capability extension**: Code execution, image generation
- **Write actions**: Making changes to the world

**Planning**:
- Generate plan (task decomposition)
- Validate plan
- Execute plan
- Reflect and correct errors

**Techniques**:
- **Function calling**: Structured tool usage
- **ReAct**: Reasoning + Acting pattern
- **Reflexion**: Learning from mistakes
- **Multi-agent systems**: Specialized agents working together

**Open Questions**:
- Can foundation models really plan?
- How to balance autonomy with safety?
- How to evaluate agent performance?

**Failure Modes**:
- Planning failures (incomplete, incorrect, inefficient plans)
- Tool failures (wrong selection, incorrect usage, misinterpretation)
- Efficiency issues (cost, latency, resource usage)

**Key Takeaways**:
1. RAG and agents are complementary patterns
2. Both extend model capabilities beyond training data
3. RAG focuses on information retrieval
4. Agents enable interaction and action
5. Hybrid approaches often work best
6. Evaluation is crucial but challenging
7. Balance performance with cost and latency
8. Start simple and add complexity as needed
9. Human oversight important for risky operations
10. Field is rapidly evolving—expect new techniques

The next chapters will build on these foundations to cover deployment, monitoring, and production considerations for AI systems.
