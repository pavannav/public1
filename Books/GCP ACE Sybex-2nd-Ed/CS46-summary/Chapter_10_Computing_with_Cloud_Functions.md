# Chapter 10: Computing with Cloud Functions

## Exam Objectives Covered

- **3.3 Deploying and implementing Cloud Run and Cloud Functions resources**

---

## Introduction to Cloud Functions

**Cloud Functions** is a serverless compute service for **event-driven, short-running functions**.

| Feature | Cloud Functions | Cloud Run |
|---|---|---|
| Type | Serverless | Serverless |
| Workload | Single-purpose, event-driven functions | Multi-function services and batch jobs |
| Max runtime | 60 min (HTTP), 10 min (event-driven) | Up to 60 min (configurable) |
| Language | Specific runtimes | Any language (container) |

**Two generations of Cloud Functions:**

| Feature | First Generation | Second Generation |
|---|---|---|
| Instance size | Smaller | **Larger** |
| Concurrency | One request per instance | **Improved concurrency** |
| Pre-warming | No | **Pre-warmed instances** |
| Traffic management | Limited | **Supported** |
| Event triggers | HTTP, Cloud Storage, Pub/Sub, Firestore, Firebase | All 1st-gen + **Eventarc** triggers (expanded sources) |
| Event specification | GCP-specific | Supports **CloudEvents** open spec |

**Eventarc** — GCP service for managing event flow in microservices architectures. Second-Generation functions use Eventarc triggers with a much wider range of event sources (Cloud Tasks, Cloud Dataproc, Cloud DNS, Network Management, OAuth 2.0, and more).

---

### Events, Triggers, and Functions

| Term | Definition |
|---|---|
| **Event** | An action that happens in the cloud (e.g., file uploaded to Cloud Storage, message written to Pub/Sub) |
| **Trigger** | A declaration that a function should execute when a specific event occurs |
| **Function** | Code that executes in response to a triggered event; receives arguments with data about the event |

**First-Generation event categories:**

| Category | Event Examples |
|---|---|
| **HTTP** | `POST`, `GET`, `PUT`, `DELETE`, `OPTIONS` requests |
| **Cloud Storage** | Upload (finalize), delete, archive, metadata update |
| **Cloud Pub/Sub** | Message published to a topic |
| **Cloud Firestore** | Create, update, delete, write |
| **Cloud Firebase** | Database triggers, remote config triggers, authentication triggers |

**Second-Generation (Eventarc) additional providers:** Cloud Tasks, Cloud Dataproc, Cloud DNS, Network Management, OAuth 2.0 (GetToken, GetTokenInfo, RevokeToken), and many more GCP and non-GCP services.

---

### Runtime Environments

Each function invocation runs in its own **isolated instance** — no shared state between invocations.

> To share state across invocations (e.g., a global counter, last event processed), use **Cloud Firestore** or a **Cloud Storage file**.

**Supported runtimes:**

- Node.js
- Python
- Go
- Java
- .NET
- Ruby
- PHP

See [https://cloud.google.com/functions](https://cloud.google.com/functions) for the latest supported, recommended, and deprecated versions.

**Example Python function — log Cloud Storage events:**

```python
def cloud_storage_function_test(event_data, event_context):
    print('Event ID: {}'.format(event_context.event_id))
    print('Event type: {}'.format(event_context.event_type))
    print('File: {}'.format(event_data['name']))
```

- `event_data` — data about the object (e.g., file name)
- `event_context` — metadata about the event (event ID, event type)
- `print()` output in a function goes to the **function's log file**
- Python function files must be saved as **`main.py`**

---

> ### Real World Scenario: Making Documents Searchable
>
> Litigation document review often involves both searchable electronic files and scanned images requiring OCR (Optical Character Recognition) preprocessing. Cloud Functions can automate this:
>
> 1. A file is uploaded to Cloud Storage → **Cloud Storage trigger** fires → a function checks whether the file needs OCR.
> 2. If OCR is needed, the function writes the file location to a **Pub/Sub topic**.
> 3. A second function bound to the **Pub/Sub new-message event** calls the OCR program, produces a searchable version, and writes it to a Cloud Storage bucket for indexing.

---

## Cloud Functions Receiving Events from Cloud Storage

Cloud Storage events that can trigger a function:

| Trigger Event | When It Fires |
|---|---|
| `google.storage.object.finalize` | File fully uploaded (created) |
| `google.storage.object.delete` | File deleted |
| `google.storage.object.archive` | File archived |
| `google.storage.object.metadataUpdate` | File metadata changed |

> **`finalize`** = file fully uploaded. This is the most commonly used trigger.

---

### Deploying a Cloud Function for Cloud Storage Events Using Cloud Console

Navigate to **Cloud Functions** from the Cloud Console menu. Enable the Cloud Functions API if prompted.

![Opening the Cloud Functions console](../images/c10f001.png)

**Figure 10.1** Opening the Cloud Functions console

![The Create Function button in Cloud Console](../images/c10f002.png)

**Figure 10.2** The Create Function button in Cloud Console

When creating a new function, fill in:

| Parameter | Description |
|---|---|
| **Function name** | Name GCP uses to reference the function |
| **Region** | GCP region to deploy the function |
| **Memory allocated** | 128 MB to 8 GB (1st gen), up to 16 GB (2nd gen) |
| **Trigger type** | HTTP, Cloud Pub/Sub, Cloud Storage, etc. |
| **Event type** | The specific event within the trigger category |
| **Bucket** | The Cloud Storage bucket to monitor (for Storage triggers) |
| **Source code** | Upload file, Cloud Storage path, Cloud Source Repository, or inline editor |
| **Runtime** | Language runtime (e.g., Python 3.9, Node.js 16) |
| **Function to execute** | Name of the function in the code that runs on the event |

![Creating a function in the console](../images/c10f003.png)

**Figure 10.3** Creating a function in the console

After creation, the function appears in the Cloud Functions list:

![List of functions in the console](../images/c10f004.png)

**Figure 10.4** List of functions in the console

---

### Deploying a Cloud Function for Cloud Storage Events Using gcloud Commands

**Ensure gcloud SDK is up to date:**

```bash
gcloud components update
```

**Install beta components if needed:**

```bash
gcloud components install beta
```

**Deploy a Cloud Storage-triggered function:**

```bash
gcloud functions deploy cloud_storage_function_test \
    --runtime python39 \
    --trigger-resource gcp-ace-exam-test-bucket \
    --trigger-event google.storage.object.finalize
```

| Parameter | Description |
|---|---|
| `cloud_storage_function_test` | Name of the function to deploy (must match function name in `main.py`) |
| `--runtime python39` | Runtime environment (e.g., `python39`, `nodejs16`) |
| `--trigger-resource` | Name of the Cloud Storage bucket to monitor |
| `--trigger-event` | Event type that triggers the function |

**Delete the function when no longer needed:**

```bash
gcloud functions delete cloud_storage_function_test
```

---

## Cloud Functions Receiving Events from Pub/Sub

A function can execute each time a message is published to a **Pub/Sub topic**.

**Example Python function — log Pub/Sub events:**

```python
def pub_sub_function_test(event_data, event_context):
    import base64
    print('Event ID: {}'.format(event_context.event_id))
    print('Event type: {}'.format(event_context.event_type))
    if 'name' in event_data:
        name = base64.b64decode(event_data['name']).decode('utf-8')
        print('Message name: {}'.format(event_data['name']))
```

> **Why `base64.b64decode`?** Pub/Sub messages are **Base64-encoded** to allow binary data in places where text is expected. The decode converts to standard **UTF-8** text.

---

### Deploying a Cloud Function for Cloud Pub/Sub Events Using Cloud Console

The setup is similar to Cloud Storage. When selecting the trigger type, choose **Cloud Pub/Sub** instead.

![Selecting a trigger from options in Cloud Console](../images/c10f005.png)

**Figure 10.5** Selecting a trigger from options in Cloud Console

Specify the Pub/Sub topic name. If the topic does not exist, it can be created from this form.

![Creating a Pub/Sub topic while creating a Cloud Function](../images/c10f006.png)

**Figure 10.6** Creating a Pub/Sub topic while creating a Cloud Function

---

### Deploying a Cloud Function for Cloud Pub/Sub Events Using gcloud Commands

**Deploy a Pub/Sub-triggered function:**

```bash
gcloud functions deploy pub_sub_function_test \
    --runtime python39 \
    --trigger-topic gcp-ace-exam-test-topic
```

| Parameter | Description |
|---|---|
| `pub_sub_function_test` | Function name |
| `--runtime python39` | Runtime environment |
| `--trigger-topic` | Name of the Pub/Sub topic that triggers the function |

> No `--trigger-event` is needed for Pub/Sub — there is only **one event type**: a message is published.

**Delete the function:**

```bash
gcloud functions delete pub_sub_function_test
```

---

## Summary

| Aspect | Cloud Storage Trigger | Cloud Pub/Sub Trigger |
|---|---|---|
| **Trigger parameter** | `--trigger-resource <bucket>` | `--trigger-topic <topic>` |
| **Event parameter** | `--trigger-event <event-type>` | Not required (one event type) |
| **Event types** | finalize, delete, archive, metadataUpdate | Message published |
| **Example use case** | Process uploaded files | React to messages in a pipeline |

**Key `gcloud` commands:**

```bash
gcloud components update                          # Update SDK
gcloud components install beta                    # Install beta components
gcloud functions deploy FUNCTION_NAME [OPTIONS]   # Deploy a function
gcloud functions delete FUNCTION_NAME             # Delete a function
```

---

## Exam Essentials

- **Know the relationship between events, triggers, and functions.** Events are actions (file uploaded, message written). Triggers declare that a function should run when an event occurs. Functions are the code that executes.

- **Know when to use Cloud Functions.** Use for single-purpose, event-driven functions with short execution times. Use Cloud Run for multi-function applications or longer-running workloads.

- **Know the runtimes and generations.** Runtimes: Node.js, Python, Go, Java, .NET, Ruby, PHP. Two generations: First Generation and Second Generation (larger instances, better concurrency, pre-warming, Eventarc support).

- **Know the parameters for a Cloud Storage–triggered function:**
  - Function name, memory allocated, trigger, event type, source code location, runtime, function to execute

- **Know the parameters for a Cloud Pub/Sub–triggered function:**
  - Function name, memory allocated, trigger, topic name, source code location, runtime, function to execute

- **Know the `gcloud` commands:**
  - `gcloud functions deploy` — deploy a function
  - `gcloud functions delete` — delete a function

---

## Review Questions

1. A product manager proposes an application requiring several back-end services, each providing a single function. Execution time can be up to 90 minutes. Which GCP product is a good serverless option?
   - A. Cloud Functions
   - B. Compute Engine
   - **C. Cloud Run**
   - D. Cloud Storage

2. A Cloud Function reformatting image files sometimes fails on large files. What could be the cause?
   - A. There is a syntax error in the function code.
   - B. The wrong runtime was selected.
   - **C. The timeout is too low to allow enough time to process large files.**
   - D. There is a permissions error on the Cloud Storage bucket.

3. When an action occurs in GCP, such as a file being written to Cloud Storage or a message being added to Pub/Sub, what is that action called?
   - A. An incident
   - **B. An event**
   - C. A trigger
   - D. A log entry

4. All of the following generate events that can be triggered using Cloud Functions, except which one?
   - A. Cloud Storage
   - B. Cloud Pub/Sub
   - **C. SSL**
   - D. Firebase

5. Which runtimes are supported in Cloud Functions?
   - A. Node.js and Python only
   - B. Node.js, Python, and Ruby only
   - C. Node.js, Python, .NET, and Go only
   - **D. Node.js, Python, Go, Java, .NET, Ruby, and PHP only**

6. An HTTP trigger can be invoked by making a request using which of the following?
   - A. `GET` only
   - B. `POST` and `GET` only
   - C. `DELETE`, `POST`, and `GET`
   - **D. `DELETE`, `POST`, `REVISE`, and `GET`**

   > **Note:** The book answer is D, but the actual HTTP trigger methods listed in the chapter are `POST`, `GET`, `PUT`, `DELETE`, and `OPTIONS` — not `REVISE`. Among the options given, D is the most inclusive and the book's intended answer.

7. What types of events are available to Cloud Functions working with Cloud Storage?
   - A. Upload or finalize and delete only
   - B. Upload or finalize, delete, and list only
   - C. Upload or finalize, delete, and metadata update only
   - **D. Upload or finalize, delete, archive, and metadata update**

8. You are designing a function that needs more memory than the default and should only apply logic to image file types on a finalize event. Which required feature cannot be specified as a parameter and must be implemented in the function code?
   - A. Cloud function name
   - B. Memory allocated for the function
   - **C. File type to apply the function to**
   - D. Event type

9. How much memory can be allocated to a Cloud Function when using Second-Generation functions?
   - A. 128 MB to 256 MB
   - B. 128 MB to 512 MB
   - C. 128 MB to 1 GB
   - **D. 128 MB to 16 GB**

10. How long can a Second-Generation event-type Cloud Function run by default before timing out?
    - A. 30 seconds
    - B. 1 minute
    - **C. 10 minutes**
    - D. 20 minutes

11. You want to use the command line to manage Cloud Functions written in Python. What command should you run to ensure your command-line SDK is up to date?
    - **A. `gcloud components update`**

    > *Note:* None of the other options (`gcloud components install`, `gcloud install components functions`, `gcloud functions install components`, `gcloud functions install`) are the correct update command. **A** is correct.

    - B. `gcloud install components functions`
    - C. `gcloud functions install components`
    - D. `gcloud functions install`

12. You want to start transforming audio files as soon as they finish uploading to Cloud Storage. Which trigger would you specify?
    - **A. `google.storage.object.finalize`**
    - B. `google.storage.object.upload`
    - C. `google.storage.object.archive`
    - D. `google.storage.object.metadataUpdate`

13. You are defining a Cloud Function to write a database record when a file in Cloud Storage is archived. What parameters will you have to set?
    - A. `runtime` only
    - B. `trigger-resource` only
    - C. `runtime`, `trigger-resource`, `trigger-event` only
    - **D. `runtime`, `trigger-resource`, `trigger-event`** *(answer C is actually correct — `file-type` is not a parameter)*

    > **Note:** The book marks **C** as correct. `file-type` is not a valid `gcloud functions deploy` parameter.

14. Which command deletes a Cloud Function from the command line?
    - **A. `gcloud functions delete`**
    - B. `gcloud components function delete`
    - C. `gcloud components delete`
    - D. `gcloud delete functions`

15. A Cloud Pub/Sub function references `base64.b64decode`. Why is a decode function required?
    - A. It's not required and should not be there.
    - **B. Messages in Pub/Sub topics are encoded to allow binary data to be used in places where text data is expected. Messages need to be decoded to access the data.**
    - C. It is required to add padding characters to make all messages the same length.
    - D. The decode function maps data from a dictionary to a list.

16. Which of these commands will deploy a Python Cloud Function called `pub_sub_function_test`?
    - A. `gcloud functions deploy pub_sub_function_test`
    - B. `gcloud functions deploy pub_sub_function_test --runtime python37`
    - **C. `gcloud functions deploy pub_sub_function_test --runtime python37 --trigger-topic gcp-ace-exam-test-topic`**
    - D. `gcloud functions deploy pub_sub_function_test --runtime python --trigger-topic gcp-ace-exam-test-topic`

17. When specifying a Cloud Storage function you must specify an event type, but for Cloud Pub/Sub you do not. Why?
    - A. Cloud Pub/Sub does not have triggers for event types.
    - **B. Cloud Pub/Sub has triggers on only one event type: when a message is published.**
    - C. Cloud Pub/Sub determines the correct event type by analyzing the function code.
    - D. The statement is incorrect; you do have to specify an event type with Cloud Pub/Sub functions.

18. Your web app allows job seekers to upload résumés in Word, PDF, or text format. You want to convert all to PDF with minimal coding and minimal delay. How would you do this?
    - A. Write a Cloud Run application with multiple services to convert all documents to PDF.
    - **B. Implement a Cloud Function on Cloud Storage to execute on a finalize event. The function checks the file type, and if it is not PDF, calls a PDF converter function and writes the PDF version to the bucket.**
    - C. Add the names of all files to a Pub/Sub topic and have a batch job run at regular intervals.
    - D. Implement a Cloud Function on Cloud Pub/Sub to execute on a finalize event.

19. What are options for uploading code to a Cloud Function?
    - A. Inline editor
    - B. Zip upload
    - C. Cloud source repository
    - **D. All of the above**

20. What type of trigger allows developers to use HTTP `POST`, `GET`, and `PUT` calls to invoke a Cloud Function?
    - **A. HTTP**
    - B. Webhook
    - C. Cloud HTTP
    - D. None of the above
