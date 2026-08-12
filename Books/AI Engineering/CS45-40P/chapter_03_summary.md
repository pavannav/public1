# Chapter 3. Evaluation Methodology

## Overview

The more AI is used, the more opportunity there is for catastrophic failure. We've already seen many failures in the short time that foundation models have been around:
- A man committed suicide after being encouraged by a chatbot
- Lawyers submitted false evidence hallucinated by AI
- Air Canada was ordered to pay damages when its AI chatbot gave a passenger false information

Without a way to quality control AI outputs, the risk of AI might outweigh its benefits for many applications.

As teams rush to adopt AI, many quickly realize that **the biggest hurdle to bringing AI applications to reality is evaluation**. For some applications, figuring out evaluation can take up the majority of the development effort.

**Chapter Structure**: Due to the importance and complexity of evaluation, this book has two chapters on it:
- **This chapter (Chapter 3)**: Covers different evaluation methods used to evaluate open-ended models, how these methods work, and their limitations
- **Next chapter (Chapter 4)**: Focuses on how to use these methods to select models for your application and build an evaluation pipeline

**Important Context**: While evaluation is discussed in its own chapters, evaluation must be considered in the context of a whole system, not in isolation. Evaluation aims to mitigate risks and uncover opportunities. To mitigate risks, you first need to identify the places where your system is likely to fail and design your evaluation around them. Without a clear understanding of where your system fails, no amount of evaluation metrics or tools can make the system robust.

**Current State**: Before diving into evaluation methods, it's important to acknowledge the challenges of evaluating foundation models. Because evaluation is difficult, many people settle for **word of mouth** (e.g., someone says that model X is good) or **eyeballing the results**. This creates even more risk and slows application iteration. Instead, we need to invest in systematic evaluation to make results more reliable.

**Chapter Topics**:

Since many foundation models have a language model component, this chapter provides a quick overview of the metrics used to evaluate language models, including cross entropy and perplexity. These metrics are essential for guiding training and finetuning of language models and are frequently used in many evaluation methods.

Evaluating foundation models is especially challenging because they are open-ended. This chapter covers best practices for how to tackle this. Using human evaluators remains necessary for many applications. However, given how slow and expensive human annotations can be, the goal is to automate the process. This book focuses on **automatic evaluation**, which includes both exact and subjective evaluation.

The rising star of subjective evaluation is **AI as a judge**—the approach of using AI to evaluate AI responses. It's subjective because the score depends on what model and prompt the AI judge uses. While this approach is gaining rapid traction in the industry, it also invites intense opposition from those who believe AI isn't trustworthy enough for this important task.

# Challenges of Evaluating Foundation Models

Evaluating ML models has always been difficult. With the introduction of foundation models, evaluation has become even more so. There are multiple reasons why evaluating foundation models is more challenging than evaluating traditional ML models.

## Challenge 1: Increased Intelligence Makes Evaluation Harder

**The Paradox**: The more intelligent AI models become, the harder it is to evaluate them. 

**Examples**:
- Most people can tell if a first grader's math solution is wrong
- Few can do the same for a PhD-level math solution
- Easy to tell if a book summary is bad if it's gibberish
- Much harder if the summary is coherent—you might need to read the book first

**Corollary**: Evaluation can be so much more time-consuming for sophisticated tasks. You can no longer evaluate a response based on how it sounds. You'll also need to fact-check, reason, and even incorporate domain expertise.

## Challenge 2: Open-Ended Nature Undermines Ground Truth Evaluation

**Traditional ML Approach**: Most tasks are close-ended. For example, a classification model can only output among expected categories. To evaluate, you compare outputs against expected outputs. If expected output is category X but model outputs category Y, the model is wrong.

**Foundation Model Challenge**: For an open-ended task, for a given input, there are so many possible correct responses. It's impossible to curate a comprehensive list of correct outputs to compare against.

**Example**: For translating "Comment ça va?" from French to English:
- "How are you?"
- "How is everything?"
- "How are you doing?"
- "How is it going?"

All are correct translations, but creating an exhaustive list is impossible.

## Challenge 3: Black Box Nature

Most foundation models are treated as black boxes, either because:
- Model providers choose not to expose models' details
- Application developers lack expertise to understand them

Details such as model architecture, training data, and training process can reveal much about a model's strengths and weaknesses. Without those details, you can evaluate a model only by observing its outputs.

## Challenge 4: Inadequate Public Benchmarks

Publicly available evaluation benchmarks have proven inadequate for evaluating foundation models. Ideally, evaluation benchmarks should capture the full range of model capabilities. As AI progresses, benchmarks need to evolve to catch up.

**Benchmark Saturation**: A benchmark becomes saturated for a model once the model achieves the perfect score. With foundation models, benchmarks are becoming saturated fast:

- **GLUE** (General Language Understanding Evaluation): Came out in 2018, became saturated in just a year
- **SuperGLUE**: Introduced in 2019 to replace GLUE
- **NaturalInstructions** (2021) → replaced by **Super-NaturalInstructions** (2022)
- **MMLU** (2020) → largely replaced by **MMLU-Pro** (2024)

## Challenge 5: Expanded Scope of Evaluation

With task-specific models, evaluation involves measuring performance on the trained task. However, with general-purpose models:
- Evaluation is not only about assessing performance on known tasks
- But also about discovering new tasks the model can do
- These might include tasks extending beyond human capabilities

Evaluation takes on the added responsibility of exploring the potential and limitations of AI.

## The Good News: Rapid Innovation

The new challenges of evaluation have prompted many new methods and benchmarks. The number of published papers on LLM evaluation grew exponentially every month in the first half of 2023, from 2 papers a month to almost 35 papers a month.

../images/aien_0301.png

**Figure 3-1. The trend of LLMs evaluation papers over time.**

In an analysis of the top 1,000 AI-related repositories on GitHub (ranked by stars), over 50 repositories were dedicated to evaluation (as of May 2024). When plotting by creation date, the growth curve looks exponential.

../images/aien_0302.png

**Figure 3-2. Number of open source evaluation repositories among the 1,000 most popular AI repositories on GitHub.**

## The Bad News: Evaluation Still Lags

Despite increased interest in evaluation, it lags behind the rest of the AI engineering pipeline. Balduzzi et al. from DeepMind noted that "developing evaluations has received little systematic attention compared to developing algorithms." According to their paper, experiment results are almost exclusively used to improve algorithms and are rarely used to improve evaluation.

Recognizing the lack of investments in evaluation, Anthropic called on policymakers to increase government funding and grants both for developing new evaluation methodologies and analyzing the robustness of existing evaluations.

# Understanding Language Modeling Metrics

Foundation models evolved out of language models. Many foundation models still have language models as their main components. For these models, the performance of the language model component tends to be well correlated to the foundation model's performance on downstream applications. Therefore, a rough understanding of language modeling metrics can be quite helpful in understanding downstream performance.

As discussed in Chapter 1, language modeling has been around for decades, popularized by Claude Shannon in his 1951 paper "Prediction and Entropy of Printed English". The metrics used to guide development of language models haven't changed much since then. Most autoregressive language models are trained using **cross entropy** or its relative, **perplexity**. When reading papers and model reports, you might also come across:
- **Bits-per-character (BPC)**
- **Bits-per-byte (BPB)**

Both are variations of cross entropy.

**Relationship**: All four metrics—cross entropy, perplexity, BPC, and BPB—are closely related. If you know the value of one, you can compute the other three, given necessary information. While referred to as language modeling metrics, they can be used for any model that generates sequences of tokens, including non-text tokens.

**Core Concept**: Recall that a language model encodes statistical information (how likely a token is to appear in a given context) about languages. Statistically, given the context "I like drinking __", the next word is more likely to be "tea" than "charcoal". The more statistical information a model can capture, the better it is at predicting the next token.

In ML lingo, a language model learns the distribution of its training data. The better this model learns, the better it is at predicting what comes next in the training data, and the lower its training cross entropy. As with any ML model, you care about performance not just on training data but also on production data. In general, the closer your data is to a model's training data, the better the model can perform on your data.

**Math Note**: Compared to the rest of the book, this section is math-heavy. If you find it confusing, feel free to skip the math part and focus on the discussion of how to interpret these metrics. Even if you're not training or finetuning language models, understanding these metrics can help with evaluating which models to use for your application.

## Entropy

**Entropy** measures how much information, on average, a token carries. The higher the entropy, the more information each token carries, and the more bits are needed to represent a token.

**Example**: Imagine you want to create a language to describe positions within a square, as shown below.

../images/aien_0304.png

**Figure 3-4. Two languages describe positions within a square. Compared to the language on the left (a), the tokens on the right (b) carry more information, but they need more bits to represent them.**

**Language with 2 Tokens** (a):
- Each token tells whether position is upper or lower
- Only two tokens, so one bit is sufficient to represent them
- Entropy = 1

**Language with 4 Tokens** (b):
- Each token gives more specific position: upper-left, upper-right, lower-left, or lower-right
- Four tokens require two bits to represent
- Entropy = 2
- Higher entropy (each token carries more information), but requires more bits

**Predictability**: Intuitively, entropy measures how difficult it is to predict what comes next in a language. The lower a language's entropy (the less information a token carries), the more predictable that language. In our example, the language with only two tokens is easier to predict than the language with four (you predict among only two possible tokens compared to four).

This is similar to how, if you can perfectly predict what I will say next, what I say carries no new information.

## Cross Entropy

When you train a language model on a dataset, your goal is to get the model to learn the distribution of this training data. In other words, your goal is to get the model to predict what comes next in the training data. **A language model's cross entropy on a dataset measures how difficult it is for the language model to predict what comes next in this dataset.**

**What Determines Cross Entropy**: A model's cross entropy on training data depends on two qualities:
1. The training data's predictability, measured by the training data's entropy
2. How the distribution captured by the language model diverges from the true distribution of the training data

**Mathematical Representation**:

Entropy and cross entropy share the same mathematical notation, *H*. Let *P* be the true distribution of training data, and *Q* be the distribution learned by the language model. Accordingly:

- Training data's entropy: *H*(*P*)
- Divergence of *Q* with respect to *P*: measured using Kullback–Leibler (KL) divergence, DKL(P||Q)
- Model's cross entropy with respect to training data: H(P,Q) = H(P) + DKL(P||Q)

**Asymmetry**: Cross entropy isn't symmetric. The cross entropy of *Q* with respect to *P*—*H*(*P*, *Q*)—is different from the cross entropy of *P* with respect to *Q*—*H*(*Q*, *P*).

**Training Objective**: A language model is trained to minimize its cross entropy with respect to training data. If the language model learns perfectly from its training data, the model's cross entropy will be exactly the same as the entropy of the training data. The KL divergence of Q with respect to P will then be 0.

**Key Insight**: You can think of a model's cross entropy as its approximation of the entropy of its training data.

## Bits-per-Character and Bits-per-Byte

One unit of entropy and cross entropy is **bits**. If the cross entropy of a language model is 6 bits, this language model needs 6 bits to represent each token.

**The Comparability Problem**: Since different models have different tokenization methods—for example, one model uses words as tokens and another uses characters as tokens—the number of bits per token isn't comparable across models.

**Bits-per-Character (BPC)**: Some use the number of bits-per-character instead. If the number of bits per token is 6 and on average, each token consists of 2 characters, the BPC is 6/2 = 3.

**Character Encoding Complication**: One complication with BPC arises from different character encoding schemes. For example:
- With ASCII: each character is encoded using 7 bits
- With UTF-8: a character can be encoded using anywhere between 8 and 32 bits

**Bits-per-Byte (BPB)**: A more standardized metric would be bits-per-byte, the number of bits a language model needs to represent one byte of the original training data. If the BPC is 3 and each character is 7 bits, or ⅞ of a byte, then the BPB is 3 / (⅞) = 3.43.

**Compression Interpretation**: Cross entropy tells us how efficient a language model will be at compressing text. If the BPB of a language model is 3.43, meaning it can represent each original byte (8 bits) using 3.43 bits, this language model can compress the original training text to less than half the text's original size.

## Perplexity

**Perplexity** is the exponential of entropy and cross entropy. Perplexity is often shortened to PPL.

**Mathematical Definition**:

Given a dataset with true distribution *P*, its perplexity is:
```
PPL(P) = 2^H(P)
```

The perplexity of a language model (with learned distribution *Q*) on this dataset is:
```
PPL(P,Q) = 2^H(P,Q)
```

**Interpretation**: If cross entropy measures how difficult it is for a model to predict the next token, **perplexity measures the amount of uncertainty it has when predicting the next token**. Higher uncertainty means there are more possible options for the next token.

**Example**: Consider a language model trained to encode the 4 position tokens (Figure 3-4 (b)) perfectly. The cross entropy of this language model is 2 bits. If this language model tries to predict a position in the square, it has to choose among 2² = 4 possible options. Thus, this language model has a perplexity of 4.

**Unit Considerations**: So far, we've been using *bit* as the unit for entropy and cross entropy. Each bit can represent 2 unique values, hence the base of 2 in the perplexity equation.

**Nat as Alternative Unit**: Popular ML frameworks, including TensorFlow and PyTorch, use **nat** (natural log) as the unit for entropy and cross entropy. Nat uses the base of *e*, the base of natural logarithm. If you use nat as the unit, perplexity is the exponential of *e*:

```
PPL(P,Q) = e^H(P,Q)
```

**Why Report Perplexity**: Due to the confusion around *bit* and *nat*, many people report perplexity, instead of cross entropy, when reporting their language models' performance.

## Perplexity Interpretation and Use Cases

As discussed, cross entropy, perplexity, BPC, and BPB are variations of language models' predictive accuracy measurements. The more accurately a model can predict a text, the lower these metrics are. In this book, perplexity will be used as the default language modeling metric.

**Remember**: The more uncertainty the model has in predicting what comes next in a given dataset, the higher the perplexity.

**What's a Good Perplexity Value?**

What's considered good depends on the data itself and how exactly perplexity is computed, such as how many previous tokens a model has access to. Here are some general rules:

**1. More structured data gives lower expected perplexity**:
- More structured data is more predictable
- Example: HTML code is more predictable than everyday text
- If you see an opening HTML tag like `<head>`, you can predict there should be a closing tag `</head>` nearby
- Expected perplexity of a model on HTML code should be lower than on everyday text

**2. The bigger the vocabulary, the higher the perplexity**:
- Intuitively, the more possible tokens there are, the harder it is to predict the next token
- Example: A model's perplexity on a children's book will likely be lower than the same model's perplexity on *War and Peace*
- For the same dataset (say English), character-based perplexity will be lower than word-based perplexity
- Reason: Number of possible characters is smaller than number of possible words

**3. The longer the context length, the lower the perplexity**:
- The more context a model has, the less uncertainty it will have in predicting the next token
- In 1951, Claude Shannon evaluated his model's cross entropy by predicting the next token conditioned on up to 10 previous tokens
- As of this writing, perplexity can typically be computed conditioned on between 500 and 10,000 previous tokens, possibly more, upperbounded by the model's maximum context length

**Reference Values**: It's not uncommon to see perplexity values as low as 3 or even lower. If all tokens in a hypothetical language have an equal chance of happening, a perplexity of 3 means this model has a 1 in 3 chance of predicting the next token correctly. Given that a model's vocabulary is in the order of 10,000s and 100,000s, these odds are incredible.

### Use Case 1: Proxy for Model Capabilities

Perplexity is a good proxy for a model's capabilities. If a model's bad at predicting the next token, its performance on downstream tasks will also likely be bad.

**Example**: OpenAI's GPT-2 report shows that larger models, which are also more powerful models, consistently give lower perplexity on a range of datasets:

**Table 3-1. Larger GPT-2 models consistently give lower perplexity on different datasets**

| Model | LAMBADA (PPL) | WikiText2 (PPL) | PTB (PPL) | enwiki8 (BPB) | text8 (BPC) |
|-------|---------------|-----------------|-----------|---------------|-------------|
| 117M | 35.13 | 29.41 | 65.85 | 1.16 | 1.17 |
| 345M | 15.60 | 22.76 | 47.33 | 1.01 | 1.06 |
| 762M | 10.87 | 19.93 | 40.31 | 0.97 | 1.02 |
| 1542M | 8.63 | 18.34 | 35.76 | 0.93 | 0.98 |

Sadly, following the trend of companies being increasingly secretive about their models, many have stopped reporting their models' perplexity.

**Warning**: Perplexity might not be a great proxy to evaluate models that have been post-trained using techniques like SFT and RLHF. Post-training is about teaching models how to complete tasks. As a model gets better at completing tasks, it might get worse at predicting next tokens. A language model's perplexity typically increases after post-training. Some people say that post-training *collapses* entropy. Similarly, quantization—a technique that reduces a model's numerical precision and memory footprint—can also change a model's perplexity in unexpected ways.

### Use Case 2: Data Contamination Detection

Recall that perplexity of a model with respect to a text measures how difficult it is for this model to predict this text. For a given model, perplexity is lowest for texts that the model has seen and memorized during training.

**Therefore**, perplexity can be used to detect whether a text was in a model's training data. This is useful for:
- **Detecting data contamination**: If a model's perplexity on a benchmark's data is low, this benchmark was likely included in the model's training data, making the model's performance on this benchmark less trustworthy
- **Deduplication of training data**: Add new data to existing training dataset only if the perplexity of the new data is high

### Use Case 3: Abnormal Text Detection

Perplexity is highest for unpredictable texts, such as:
- Texts expressing unusual ideas (like "my dog teaches quantum physics in his free time")
- Gibberish (like "home cat go eye")

**Therefore**, perplexity can be used to detect abnormal texts.

# Evaluation Methods

This section discusses evaluation methods commonly used for foundation models. They are grouped into two main categories: exact and subjective evaluation.

**Exact Evaluation**: Methods that don't require human judgment. Results are reproducible—you run the test multiple times and always get the same results. Examples:
- Exact match
- Lexical similarity
- Semantic similarity

**Subjective Evaluation**: Methods that require judgment calls, whether by humans or AI. Results can vary based on who's evaluating. Examples:
- Human evaluation
- AI as a judge

The boundary between exact and subjective evaluation can be blurry. For instance, semantic similarity uses embedding algorithms, and different algorithms can produce different embeddings. However, given two embeddings, the similarity score between them is computed exactly.

## Exact Evaluation

For exact evaluation, you need responses to compare against. These are called **reference responses** or **ground truths**. There are several ways to compare a generated response to reference responses:

1. Asking an evaluator to make the judgment whether two texts are the same
2. **Exact match**: whether the generated response matches one of the reference responses exactly
3. **Lexical similarity**: how similar the generated response looks to the reference responses
4. **Semantic similarity**: how close the generated response is to the reference responses in meaning (semantics)

Two responses can be compared by human evaluators or AI evaluators. AI evaluators are increasingly common and will be the focus of the next section.

This section focuses on hand-designed metrics: exact match, lexical similarity, and semantic similarity. Scores by exact matching are binary (match or not), whereas the other two scores are on a sliding scale (such as between 0 and 1 or between –1 and 1). Despite the ease of use and flexibility of the AI as a judge approach, hand-designed similarity measurements are still widely used in the industry for their exact nature.

**Note**: This section discusses how you can use similarity measurements to evaluate the quality of a generated output. However, you can also use similarity measurements for many other use cases:
- **Retrieval and search**: find items similar to a query
- **Ranking**: rank items based on how similar they are to a query
- **Clustering**: cluster items based on how similar they are to each other
- **Anomaly detection**: detect items that are the least similar to the rest
- **Data deduplication**: remove items that are too similar to other items

Techniques discussed in this section will come up again throughout the book.

### Exact match

It's considered an exact match if the generated response matches one of the reference responses exactly.

**When It Works**: Exact matching works for tasks that expect short, exact responses such as:
- Simple math problems
- Common knowledge queries
- Trivia-style questions

**Examples of inputs with short, exact responses**:
- "What's 2 + 3?"
- "Who was the first woman to win a Nobel Prize?"
- "What's my current account balance?"
- "Fill in the blank: Paris to France is like ___ to England."

**Variations**: There are variations to matching that take into account formatting issues. One variation is to accept any output that contains the reference response as a match.

**Example**: Consider the question "What's 2 + 3?" The reference response is "5". This variation accepts all outputs that contain "5", including "The answer is 5" and "2 + 3 is 5".

**Limitation of Variation**: This variation can sometimes lead to the wrong solution being accepted. Consider the question "What year was Anne Frank born?" Anne Frank was born on June 12, 1929, so the correct response is 1929. If the model outputs "September 12, 1929", the correct year is included in the output, but the output is factually wrong.

**Why It Fails for Complex Tasks**: Beyond simple tasks, exact match rarely works. Given the original French sentence "Comment ça va?", there are multiple possible English translations:
- "How are you?"
- "How is everything?"
- "How are you doing?"

If the reference data contains only these three translations and a model generates "How is it going?", the model's response will be marked as wrong. The longer and more complex the original text, the more possible translations there are. It's impossible to create an exhaustive set of possible responses for an input.

For complex tasks, lexical similarity and semantic similarity work better.

### Lexical similarity

**Lexical similarity** measures how much two texts overlap. You can do this by first breaking each text into smaller tokens.

**Simple Form**: In its simplest form, lexical similarity can be measured by counting how many tokens two texts have in common.

**Example**: Consider the reference response *"My cats scare the mice"* and two generated responses:
- Response A: "My cats eat the mice"
- Response B: "Cats and mice fight all the time"

Assume that each token is a word. If you count overlapping of individual words only:
- Response A contains 4 out of 5 words in the reference (similarity score is 80%)
- Response B contains only 3 out of 5 (similarity score is 60%)
- Response A is therefore considered more similar to the reference response

#### Fuzzy Matching (Approximate String Matching)

One way to measure lexical similarity is **approximate string matching**, known colloquially as **fuzzy matching**. It measures similarity between two texts by counting how many edits it'd need to convert from one text to another, a number called **edit distance**.

**The usual three edit operations are**:
1. **Deletion**: "b*r*ad" → "bad"
2. **Insertion**: "bad" → "ba*r*d"
3. **Substitution**: "b*a*d" → "b*e*d"

Some fuzzy matchers also treat **transposition** (swapping two letters, e.g., "ma*ts*" → "ma*st*") as an edit. However, some fuzzy matchers treat each transposition as two edit operations: one deletion and one insertion.

**Example**: "bad" is one edit to "bard" and three edits to "cash", so "bad" is considered more similar to "bard" than to "cash".

#### N-gram Similarity

Another way to measure lexical similarity is **n-gram similarity**, measured based on the overlapping of sequences of tokens, *n-grams*, instead of single tokens.

**What are N-grams?**
- A 1-gram (unigram) is a token
- A 2-gram (bigram) is a set of two tokens
- Example: "My cats scare the mice" consists of four bigrams: "my cats", "cats scare", "scare the", and "the mice"

You measure what percentage of n-grams in reference responses is also in the generated response.

**Common Metrics**: Common metrics for lexical similarity are:
- BLEU
- ROUGE
- METEOR++
- TER
- CIDEr

They differ in exactly how the overlapping is calculated.

**Historical Use**: Before foundation models, BLEU, ROUGE, and their relatives were common, especially for translation tasks. Since the rise of foundation models, fewer benchmarks use lexical similarity. Examples of benchmarks that use these metrics are WMT, COCO Captions, and GEMv2.

#### Drawback 1: Requires Comprehensive Reference Set

A good response can get a low similarity score if the reference set doesn't contain any response that looks like it. On some benchmark examples, Adept found that its model Fuyu performed poorly not because the model's outputs were wrong, but because some correct answers were missing in the reference data. Figure 3-5 shows an example of an image-captioning task in which Fuyu generated a correct caption but was given a low score.

../images/aien_0305.png

**Figure 3-5. An example where Fuyu generated a correct option but was given a low score because of the limitation of reference captions.**

Not only that, but references can be wrong. For example, the organizers of the WMT 2023 Metrics shared task, which focuses on examining evaluation metrics for machine translation, reported that they found many bad reference translations in their data. Low-quality reference data is one of the reasons that reference-free metrics were strong contenders for reference-based metrics in terms of correlation to human judgment.

#### Drawback 2: Higher Scores Don't Always Mean Better

Another drawback of this measurement is that higher lexical similarity scores don't always mean better responses. For example, on HumanEval, a code generation benchmark, OpenAI found that BLEU scores for incorrect and correct solutions were similar. This indicates that optimizing for BLEU scores isn't the same as optimizing for functional correctness.

### Semantic similarity

Lexical similarity measures whether two texts look similar, not whether they have the same meaning.

**Example**: Consider the two sentences:
- "What's up?"
- "How are you?"

Lexically, they are different—there's little overlapping in the words and letters they use. However, semantically, they are close.

**Converse Example**: Similar-looking texts can mean very different things:
- "Let's eat, grandma"
- "Let's eat grandma"

These mean two completely different things.

**Semantic Similarity** aims to compute the similarity in semantics. This first requires transforming a text into a numerical representation, which is called an **embedding**.

**Example**: The sentence "the cat sits on a mat" might be represented using an embedding that looks like this: `[0.11, 0.02, 0.54]`.

Semantic similarity is therefore also called **embedding similarity**.

**Beyond Text**: While text examples are used, semantic similarity can be computed for embeddings of any data modality, including images and audio. Semantic similarity for text is sometimes called semantic textual similarity.

**Warning**: While semantic similarity is put in the exact evaluation category, it can be considered subjective, as different embedding algorithms can produce different embeddings. However, given two embeddings, the similarity score between them is computed exactly.

#### Computing Semantic Similarity

Mathematically, let A be an embedding of the generated response, and B be an embedding of a reference response. The cosine similarity between A and B is computed as:

```
cosine_similarity(A, B) = (A·B) / (||A|| × ||B||)
```

Where:
- A·B is the dot product of A and B
- ||A|| is the Euclidean norm (also known as L2 norm) of A
- If A is [0.11, 0.02, 0.54], then ||A|| = √(0.11² + 0.02² + 0.54²)

Two embeddings that are exactly the same have a similarity score of 1. Two opposite embeddings have a similarity score of –1.

**Common Metrics**: Metrics for semantic textual similarity include:
- **BERTScore**: embeddings are generated by BERT
- **MoverScore**: embeddings are generated by a mixture of algorithms

#### Advantages and Disadvantages

**Advantages**:
- Semantic textual similarity doesn't require a set of reference responses as comprehensive as lexical similarity does

**Disadvantages**:
- The reliability of semantic similarity depends on the quality of the underlying embedding algorithm
- Two texts with the same meaning can still have a low semantic similarity score if their embeddings are bad
- The underlying embedding algorithm might require nontrivial compute and time to run

Before we move on to discuss AI as a judge, let's go over a quick introduction to embedding. The concept of embedding lies at the heart of semantic similarity, and is the backbone of many topics explored throughout the book, including vector search in Chapter 6 and data deduplication in Chapter 8.

## Introduction to Embedding

Since computers work with numbers, a model needs to convert its input into numerical representations that computers can process. **An embedding is a numerical representation that aims to capture the meaning of the original data.**

**What is an Embedding?**

An embedding is a vector. For example, the sentence *"the cat sits on a mat"* might be represented using an embedding vector that looks like this: `[0.11, 0.02, 0.54]`.

Here, a small vector is used as an example. In reality, the size of an embedding vector (the number of elements in the embedding vector) is typically between 100 and 10,000.

**Embedding Models**: Models trained especially to produce embeddings include:
- Open source models: BERT, CLIP (Contrastive Language–Image Pre-training), Sentence Transformers
- Proprietary embedding models provided as APIs

**Table 3-2. Embedding sizes used by common models**

| Model | Embedding size |
|-------|----------------|
| Google's BERT | BERT base: 768, BERT large: 1024 |
| OpenAI's CLIP | Image: 512, Text: 512 |
| OpenAI Embeddings API | text-embedding-3-small: 1536, text-embedding-3-large: 3072 |
| Cohere's Embed v3 | embed-english-v3.0: 1024, embed-english-light-3.0: 384 |

**Embeddings in Foundation Models**: Because models typically require their inputs to first be transformed into vector representations, many ML models, including GPTs and Llamas, also involve a step to generate embeddings. If you have access to the intermediate layers of these models, you can use them to extract embeddings. However, the quality of these embeddings might not be as good as the embeddings generated by specialized embedding models.

### Evaluating Embedding Quality

The goal of the embedding algorithm is to produce embeddings that capture the essence of the original data. How do we verify that? The embedding vector `[0.11, 0.02, 0.54]` looks nothing like the original text "the cat sits on a mat".

**High-Level Evaluation**: An embedding algorithm is considered good if more-similar texts have closer embeddings, measured by cosine similarity or related metrics. The embedding of the sentence "the cat sits on a mat" should be closer to the embedding of "the dog plays on the grass" than the embedding of "AI research is super fun".

**Task-Based Evaluation**: You can also evaluate the quality of embeddings based on their utility for your task. Embeddings are used in many tasks:
- Classification
- Topic modeling
- Recommender systems
- RAG (Retrieval-Augmented Generation)

An example of benchmarks that measure embedding quality on multiple tasks is MTEB (Massive Text Embedding Benchmark).

### Beyond Text Embeddings

Text examples are used, but any data can have embedding representations. For example:
- Ecommerce solutions like Criteo and Coveo have embeddings for products
- Pinterest has embeddings for images, graphs, queries, and even users

**Joint Embeddings**: A new frontier is to create joint embeddings for data of different modalities:
- **CLIP**: One of the first major models that could map data of different modalities (text and images) into a joint embedding space
- **ULIP** (unified representation of language, images, and point clouds): Aims to create unified representations of text, images, and 3D point clouds
- **ImageBind**: Learns a joint embedding across six different modalities, including text, images, and audio

#### CLIP Architecture

Figure 3-6 visualizes CLIP's architecture:

../images/aien_0306.png

**Figure 3-6. CLIP's architecture. CLIP is trained to map text and images into a joint embedding space.**

**How CLIP Works**:
- CLIP is trained using (image, text) pairs
- The text corresponding to an image can be the caption or a comment associated with this image
- For each (image, text) pair:
  - CLIP uses a text encoder to convert the text to a text embedding
  - An image encoder to convert the image to an image embedding
  - It then projects both embeddings into a joint embedding space
- Training goal: Get the embedding of an image close to the embedding of the corresponding text in this joint space

**Applications**: Joint embeddings enable cross-modal tasks like:
- Finding images based on text descriptions
- Finding text descriptions based on images
- Image-text retrieval
- Zero-shot classification

## AI as a Judge

Using AI to evaluate AI responses is increasingly popular and is referred to as **AI as a judge**. This approach leverages AI models themselves to assess the quality of AI-generated content.

**How It Works**: You prompt an AI model (the "judge") to evaluate another AI model's response based on specific criteria. The judge outputs a score or judgment about the quality of the response.

**Why It's Subjective**: It's called subjective evaluation because the score depends on:
- What model is used as the judge
- What prompt is given to the judge
- The judge's sampling parameters

Different judges can give different scores for the same response.

### Advantages of AI as a Judge

**1. Speed and Scalability**: AI judges can evaluate responses much faster than human evaluators. You can evaluate thousands of responses in minutes.

**2. Cost-Effective**: While not free, AI judges are significantly cheaper than hiring human evaluators, especially at scale.

**3. Consistency**: AI judges can apply the same evaluation criteria consistently across all responses (though not perfectly, as discussed in limitations).

**4. Availability**: AI judges are available 24/7, don't need breaks, and can scale to handle any volume of evaluations.

**5. Flexibility**: You can easily adjust evaluation criteria by changing the judge's prompt without retraining or rehiring evaluators.

**6. Complex Criteria**: AI judges can evaluate complex, nuanced criteria that would be difficult to define mathematically (e.g., "coherence", "helpfulness", "tone").

### Common Evaluation Criteria

AI judges can evaluate many different aspects of generated responses. Common criteria include:

**Table 3-3. Common evaluation criteria used by different AI judge frameworks**

| Framework | Common Criteria |
|-----------|----------------|
| Azure AI Studio | Groundedness, relevance, coherence, fluency, similarity |
| LlamaIndex | Faithfulness, relevance |
| MLflow | Relevance, faithfulness, toxicity |
| Ragas | Faithfulness, answer relevance |

**Important Note**: AI as a judge criteria aren't standardized. Azure AI Studio's relevance scores might be very different from MLflow's relevance scores. These scores depend on the judge's underlying model and prompt.

### Prompting an AI Judge

How to prompt an AI judge is similar to how to prompt any AI application. In general, a judge's prompt should clearly explain:

**1. The Task**: The task the model is to perform, such as to evaluate the relevance between a generated answer and the question.

**2. The Criteria**: The criteria the model should follow to evaluate, such as "Your primary focus should be on determining whether the generated answer contains sufficient information to address the given question according to the ground truth answer". The more detailed the instruction, the better.

**3. The Scoring System**: Which can be one of these:
- **Classification**: such as good/bad or relevant/irrelevant/neutral
- **Discrete numerical values**: such as 1 to 5. Discrete numerical values can be considered a special case of classification, where each class has a numerical interpretation instead of a semantic interpretation
- **Continuous numerical values**: such as between 0 and 1, e.g., when you want to evaluate the degree of similarity

**Tip**: Language models are generally better with text than with numbers. It's been reported that AI judges work better with classification than with numerical scoring systems.

For numerical scoring systems, discrete scoring seems to work better than continuous scoring. Empirically, the wider the range for discrete scoring, the worse the model seems to get. Typical discrete scoring systems are between 1 and 5.

Prompts with examples have been shown to perform better. If you use a scoring system between 1 and 5, include examples of what a response with a score of 1, 2, 3, 4, or 5 looks like, and if possible, why a response receives a certain score.

### Example Judge Prompt

Here's part of the prompt used for the criteria *relevance* by Azure AI Studio. It explains the task, the criteria, the scoring system, an example of an input with a low score, and a justification for why this input has a low score:

```
Your task is to score the relevance between a generated answer and the 
question based on the ground truth answer in the range between 1 and 5, 
and please also provide the scoring reason.

Your primary focus should be on determining whether the generated answer 
contains sufficient information to address the given question according 
to the ground truth answer. …

If the generated answer contradicts the ground truth answer, it will 
receive a low score of 1-2.

For example, for the question "Is the sky blue?" the ground truth answer 
is "Yes, the sky is blue." and the generated answer is "No, the sky is 
not blue."

In this example, the generated answer contradicts the ground truth answer 
by stating that the sky is not blue, when in fact it is blue.

This inconsistency would result in a low score of 1–2, and the reason for 
the low score would reflect the contradiction between the generated answer 
and the ground truth answer.
```

../images/aien_0308.png

**Figure 3-8. An example of an AI judge that evaluates the quality of an answer given a question.**

**Key Insight**: An AI judge is not just a model—it's a system that includes both a model and a prompt. Altering the model, the prompt, or the model's sampling parameters results in a different judge.

## Limitations of AI as a Judge

Despite the many advantages of AI as a judge, many teams are hesitant to adopt this approach. Using AI to evaluate AI seems tautological. The probabilistic nature of AI makes it seem too unreliable to act as an evaluator. AI judges can potentially introduce nontrivial costs and latency to an application.

Given these limitations, some teams see AI as a judge as a fallback option when they don't have any other way of evaluating their systems, especially in production.

### Limitation 1: Inconsistency

For an evaluation method to be trustworthy, its results should be consistent. Yet AI judges, like all AI applications, are probabilistic.

**The Problem**:
- The same judge, on the same input, can output different scores if prompted differently
- Even the same judge, prompted with the same instruction, can output different scores if run twice
- This inconsistency makes it hard to reproduce or trust evaluation results

**Mitigation Strategies**: It's possible to get an AI judge to be more consistent:
- Chapter 2 discusses how to do so with sampling variables
- Zheng et al. (2023) showed that including evaluation examples in the prompt can increase the consistency of GPT-4 from 65% to 77.5%

**Trade-offs**:
- High consistency may not imply high accuracy—the judge might consistently make the same mistakes
- Including more examples makes prompts longer, meaning higher inference costs
- In Zheng et al.'s experiment, including more examples in their prompts caused their GPT-4 spending to quadruple

### Limitation 2: Criteria Ambiguity

Unlike many human-designed metrics, AI as a judge metrics aren't standardized, making it easy to misinterpret and misuse them.

**Example**: As of this writing, the open source tools MLflow, Ragas, and LlamaIndex all have the built-in criterion *faithfulness* to measure how faithful a generated output is to the given context, but their instructions and scoring systems are all different.

**Table 3-4. Different tools can have very different default prompts for the same criteria**

| Tool | Prompt (partially omitted) | Scoring system |
|------|---------------------------|----------------|
| MLflow | "Faithfulness is only evaluated with the provided output and provided context... Score 1: None of the claims in the output can be inferred from the provided context. Score 2: ..." | 1–5 |
| Ragas | "Your task is to judge the faithfulness of a series of statements... return verdict as 1 if the statement can be verified based on the context or 0 if the statement can not be verified..." | 0 and 1 |
| LlamaIndex | "Please tell if a given piece of information is supported by the context. You need to answer with either YES or NO..." | YES and NO |

**The Problem**: The faithfulness scores outputted by these three tools won't be comparable. If, given a (context, answer) pair:
- MLflow gives a faithfulness score of 3
- Ragas outputs 1
- LlamaIndex outputs NO

Which score would you use?

**Evolution Over Time**: An application evolves over time, but the way it's evaluated ideally should be fixed. This way, evaluation metrics can be used to monitor the application's changes. However, AI judges are also AI applications, which means they can also change over time.

**Monitoring Challenge**: Imagine that last month, your application's coherence score was 90%, and this month, this score is 92%. Does this mean that your application's coherence has improved?

It's hard to answer this question unless you know for sure that the AI judges used in both cases are exactly the same. What if the judge's prompt this month is different from the one last month? Maybe you switched to a slightly better-performing prompt or a coworker fixed a typo in last month's prompt, and the judge this month is more lenient.

This can become especially confusing if the application and the AI judge are managed by different teams. The AI judge team might change the judges without informing the application team. As a result, the application team might mistakenly attribute the changes in the evaluation results to changes in the application, rather than the changes in the judges.

**Tip**: Do not trust any AI judge if you can't see the model and the prompt used for the judge.

Evaluation methods take time to standardize. As the field evolves and more guardrails are introduced, future AI judges will hopefully become a lot more standardized and reliable.

### Limitation 3: Increased Costs and Latency

You can use AI judges to evaluate applications both during experimentation and in production. Many teams use AI judges as guardrails in production to reduce risks, showing users only generated responses deemed good by the AI judge.

**Cost Implications**: Using powerful models to evaluate responses can be expensive:
- If you use GPT-4 to both generate and evaluate responses, you'll do twice as many GPT-4 calls, approximately doubling your API costs
- If you have three evaluation prompts (to evaluate three criteria—say, overall response quality, factual consistency, and toxicity), you'll increase your number of API calls four times

**Cost Reduction Strategies**:
1. **Use weaker models as judges**: You can reduce costs by using weaker models as the judges (see "What Models Can Act as Judges?" section)
2. **Spot-checking**: Evaluating only a subset of responses

**Spot-Checking Trade-offs**:
- Spot-checking means you might fail to catch some failures
- The larger the percentage of samples you evaluate, the more confidence you will have in your evaluation results, but also the higher the costs
- Finding the right balance between cost and confidence might take trial and error
- This process is discussed further in Chapter 4

All things considered, AI judges are much cheaper than human evaluators.

**Latency Implications**: Implementing AI judges in your production pipeline can add latency:
- If you evaluate responses before returning them to users, you face a trade-off: reduced risk but increased latency
- The added latency might make this option a nonstarter for applications with strict latency requirements

### Limitation 4: Biases of AI as a Judge

Human evaluators have biases, and so do AI judges. Different AI judges have different biases. Being aware of your AI judges' biases helps you interpret their scores correctly and even mitigate these biases.

#### Self-Bias

AI judges tend to have **self-bias**, where a model favors its own responses over responses generated by other models. The same mechanism that helps a model compute the most likely response to generate will also give this response a high score.

**Example**: In Zheng et al.'s 2023 experiment:
- GPT-4 favors itself with a 10% higher win rate
- Claude-v1 favors itself with a 25% higher win rate

#### Position Bias

Many AI models have **first-position bias**. An AI judge may favor the first answer in a pairwise comparison or the first in a list of options.

**Mitigation**: This can be mitigated by:
- Repeating the same test multiple times with different orderings
- Using carefully crafted prompts

**Interesting Note**: The position bias of AI is the opposite of that of humans. Humans tend to favor the answer they see last, which is called **recency bias**.

#### Verbosity Bias

Some AI judges have **verbosity bias**, favoring lengthier answers, regardless of their quality.

**Research Findings**:
- Wu and Aji (2023) found that both GPT-4 and Claude-1 prefer longer responses (~100 words) with factual errors over shorter, correct responses (~50 words)
- Saito et al. (2023) studied this bias for creative tasks and found that when the length difference is large enough (e.g., one response is twice as long as the other), the judge almost always prefers the longer one

**Good News**: Both Zheng et al. (2023) and Saito et al. (2023) discovered that GPT-4 is less prone to this bias than GPT-3.5, suggesting that this bias might go away as models become stronger.

#### Other Limitations

On top of all these biases, AI judges have the same limitations as all AI applications:
- **Privacy**: If you use a proprietary model as your judge, you'd need to send your data to this model
- **IP concerns**: If the model provider doesn't disclose their training data, you won't know for sure if the judge is commercially safe to use

Despite the limitations of the AI as a judge approach, its many advantages make it likely that its adoption will continue to grow. However, AI judges should be supplemented with exact evaluation methods and/or human evaluation.

## What Models Can Act as Judges?

Not all models are equally good as judges. This section explores what makes a good judge model and what options are available.

**Key Insight**: Generally, stronger models make better judges. A model that performs better on language understanding tasks will typically provide better evaluations.

**Model Options**:

1. **Proprietary Models**:
   - GPT-4 and variants
   - Claude (various versions)
   - Gemini
   - Advantages: Typically strongest performance, regularly updated
   - Disadvantages: Cost, privacy concerns, dependency on external provider

2. **Open Source Models**:
   - Llama 2, Llama 3
   - Mistral models
   - Fine-tuned variants
   - Advantages: Control, privacy, can be self-hosted, no ongoing API costs
   - Disadvantages: May be weaker than proprietary models, requires infrastructure

3. **Specialized Judge Models**:
   - Models specifically fine-tuned for evaluation tasks
   - Examples: Models trained on human preference data for specific criteria
   - Can outperform general models on specific evaluation tasks

**Using Weaker Models**: You don't always need the most powerful model as a judge:
- For simple criteria (toxicity, profanity), smaller models can work well
- For complex reasoning tasks, stronger models are necessary
- Trade-off between cost/speed and accuracy

**Multiple Judges**: Some systems use multiple judges:
- Different models evaluate different criteria
- Ensemble approach: multiple judges evaluate the same criterion, scores are aggregated
- Can improve robustness but increases cost

**Self-Evaluation**: A model can even judge its own outputs (called self-critique or self-ask). This can be useful for:
- Iterative improvement (model critiques and regenerates)
- Confidence estimation
- Identifying potential errors

However, self-evaluation has limitations:
- A model may not be good at identifying its own mistakes
- Self-bias can affect judgments

# Summary

This chapter covered the fundamental concepts and methods for evaluating foundation models:

**Challenges of Evaluation**:
- Increased intelligence makes evaluation harder
- Open-ended nature undermines ground truth evaluation
- Black box nature limits understanding
- Public benchmarks become saturated quickly
- Expanded scope beyond just task performance

**Language Modeling Metrics**:
- **Entropy**: Measures information content per token
- **Cross Entropy**: Measures prediction difficulty
- **Perplexity**: Exponential of cross entropy, measures uncertainty
- **BPC/BPB**: Normalized versions for comparison across models
- Use cases: Proxy for capabilities, data contamination detection, abnormal text detection

**Exact Evaluation Methods**:
- **Exact Match**: Binary comparison for short, exact responses
- **Lexical Similarity**: Measures text overlap (BLEU, ROUGE)
- **Semantic Similarity**: Measures meaning similarity using embeddings
- Each has trade-offs between precision and applicability

**Embeddings**:
- Numerical representations capturing meaning
- Essential for semantic similarity, RAG, search, clustering
- Can be specialized (BERT, CLIP) or extracted from foundation models
- Joint embeddings enable cross-modal tasks

**AI as a Judge**:
- Uses AI to evaluate AI responses
- Advantages: Speed, scalability, cost-effectiveness, flexibility
- Common criteria: Relevance, faithfulness, coherence, fluency
- Requires careful prompting with task, criteria, and scoring system

**Limitations of AI as a Judge**:
- Inconsistency: Probabilistic nature leads to varying results
- Criteria ambiguity: Not standardized across frameworks
- Cost and latency: Can significantly increase operational overhead
- Biases: Self-bias, position bias, verbosity bias

**Key Takeaways**:
1. Evaluation is crucial for AI application success
2. No single evaluation method is perfect—use multiple approaches
3. Language modeling metrics provide useful proxies for model capability
4. Exact evaluation methods work for constrained tasks
5. AI as a judge enables evaluating open-ended tasks at scale
6. Understanding limitations helps interpret results correctly
7. Evaluation should be designed around where systems likely fail
8. Standardization of evaluation methods is still evolving

The next chapter will discuss how to use these evaluation methods to select models and build comprehensive evaluation pipelines for your applications.
