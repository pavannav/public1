---

**THIS CHAPTER COVERS THE FOLLOWING OBJECTIVES OF THE GOOGLE ASSOCIATE CLOUD ENGINEER CERTIFICATION EXAM:**

- **3.3 Deploying and implementing Cloud Run and Cloud Functions resources**

---

In this chapter, we describe the purpose of Cloud Functions as well as how to implement and deploy the functions. We will use examples of the functions written in Python. If you are unfamiliar with Python, that should not dissuade you from following along, as we will explain the important details of Python functions. You will learn how to use the Cloud Console and `gcloud` commands to create and manage Cloud Functions.

## Introduction to Cloud Functions

Cloud Functions is a serverless compute service provided by Google Cloud. Cloud Functions is similar to Cloud Run in that they are both serverless compute options. A primary difference is that Cloud Run supports both services with HTTP endpoints that can run continuously and batch jobs that run to completion and terminate, whereas Cloud Functions are relatively short-running functions (up to 60 minutes for HTTP functions and 10 minutes for event-driven functions).

Cloud Functions are well suited for event-driven processing. For example, your customers may upload files to Cloud Storage, which are analyzed for quality control checks, and if the checks are passed, a message is written to a Pub/Sub topic, a messaging service in GCP, which is read by another service that continues the processing.

At the time of writing, there are two supported versions of Cloud Functions: the original Cloud Functions and Second-Generation Cloud Functions. The Second-Generation Cloud Functions offer larger instances, improved concurrency, pre-warmed instances, and traffic management. Second-Generation Functions also support Eventarc, a GCP service that supports managing the flow of events in microservices architectures. Eventarc greatly expands the range of event sources supported by Cloud Functions. The Second-Generation functions also support CloudEvents, an open specification for describing cloud events.

### Events, Triggers, and Functions

Here are some terms you need to know before going any further into Cloud Functions:

- Events
- Triggers
- Functions

*Events* are a particular action that happens in the cloud, such as a file is uploaded to Cloud Storage, or a message that is written to a Pub/Sub message (called a *topic*) queue. There are different kinds of actions associated with each of the events. The first generation of Cloud Functions, GCP supports events in several categories:

- HTTP
- Cloud Storage
- Cloud Pub/Sub
- Cloud Firestore
- Cloud Firebase

The HTTP type of event allows developers to invoke a function by making an HTTP request using `POST`, `GET`, `PUT`, `DELETE`, and `OPTIONS` calls. Events in Cloud Storage include uploading, deleting, and archiving a file. Cloud Pub/Sub has an event for publishing a message. Cloud Firestore is a NoSQL document database, and Cloud Functions supports create, update, delete, and write events. Firebase is a database service used for mobile application development and supports database triggers, remote configuration triggers, and authentication triggers.

Second-Generation Cloud Functions use Eventarc triggers, which are configured based on a provider, such as services supported in First-Generation Cloud Functions like Cloud Pub/Sub; additional GCP services, such as Cloud Task, Cloud Dataproc, Cloud DNS, and Network Management; as well as non-GCP specific services such as OAuth 2.0. The specific event types will vary by provider. For example, OAuth 2.0 providers support `GetToken`, `GetTokenInfo`, and `RevokeToken` events. Network Management events include `CreateConnectivityTest`, `GetConnectivityTest`, `ListConnectivityTest`.

For each of the Cloud Functions–enabled events that can occur, you can define a trigger. A *trigger* is a way of responding to an event.

Triggers have an associated *function*. The function, passed arguments with data about the event, executes in response to the event.

### Runtime Environments

Functions run in their own environment. Each time a function is invoked, it is run in a separate instance from all other invocations. There is no way to share information between invocations of functions using only Cloud Functions. If you need to coordinate the updating of data, such as keeping a global count, or need to keep information about the state of functions, such as the name of the last event processed, then you should use a database like Cloud Firestore or a file in Cloud Storage.

Google currently supports several runtime environments:

- Node.js
- Python
- Go
- Java
- .NET
- Ruby
- PHP

For each of these runtimes, particular versions may be recommended over others. For example, at the time of writing, the recommended Node.js is Node.js 16 and the recommend version of Python is 3.9. See Cloud Functions documentation (`https://cloud.google.com/functions`) for the latest supported, recommended, and deprecated versions of the runtimes.

Let's walk through an example function. Say you want to record information about file uploads to a particular bucket in Cloud Storage. You can do this by writing a Python function that receives information about an event and then issues print commands to send a description of that data to a log file. Here is the Python code:

```
      def cloud_storage_function_test(event_data, event_context):
      print('Event ID: {}'.format(event_context.event_id))
      print('Event type: {}'.format(event_context.event_type))
      print('File: {}'.format(event_data['name']))
```

The first line begins the creation of a function called `cloud_storage_function_test`. It takes two arguments, `event_data` and `event_context`. These are Python data structures with information about the object of the event and about the event itself. The next three lines print the values of the `event_id`, `event_type`, and name of the file. Since this code will be run as a function, and not interactively, the output of a print statement will go to the function's log file.

Python functions should be saved in a file called `main.py`.

---

### Real World Scenario

### Making Documents Searchable

Litigation, or lawsuits, between businesses often involve reviewing a large volume of documents. Electronic documents may be in readily searchable formats, such as Microsoft Word documents or PDF files. Others may be scanned images of paper documents. In that case, the file needs to be preprocessed using an optical character recognition (OCR) program.

Functions can be used to automate the OCR process. When a file is uploaded, a Cloud Storage trigger fires and invokes a function. The function determines whether the file is in a searchable format or needs to be preprocessed by the OCR program. If the file does require OCR processing, the function writes the location of the file into a Pub/Sub topic.

A second function is bound to a new message event. When a file location is written in a message, the function calls the OCR program to scan the document and produce a searchable version of the file. That searchable version is written to a Cloud Storage bucket, where it can be indexed by the search tool along with other searchable files.

---

## Cloud Functions Receiving Events from Cloud Storage

Cloud Storage is GCP's object storage. This service allows you to store files in containers known as *buckets*. We will go into more detail about Cloud Storage in [Chapter 11](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml), “Planning Storage in the Cloud,” but for this chapter you just need to understand that Cloud Storage uses buckets to store files. When files are created, deleted, or archived, or their metadata changes, an event can invoke a function. Let's go through an example of deploying a function for Cloud Storage Events using Cloud Console and `gcloud` commands in Cloud SDK and Cloud Shell.

### Deploying a Cloud Function for Cloud Storage Events Using Cloud Console

To create a function using Cloud Console, select the Cloud Function options from the vertical menu in the console, as shown in [Figure 10.1](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c10.xhtml#c10-fig-0001).

![Snapshot of opening the Cloud Functions console](../images/c10f001.png)


[**FIGURE 10.1**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c10.xhtml#R_c10-fig-0001) Opening the Cloud Functions console

In the Cloud Functions console, you may be prompted to enable the Cloud Functions API if it is not already enabled. After the API is enabled, you will have the option to create a new function, as shown in [Figure 10.2](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c10.xhtml#c10-fig-0002).

![Snapshot of the Create Function button in Cloud Console](../images/c10f002.png)


[**FIGURE 10.2**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c10.xhtml#R_c10-fig-0002) The Create Function button in Cloud Console

When you create a new function in the console, a form such as the one in [Figure 10.3](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c10.xhtml#c10-fig-0003) appears. In [Figure 10.3](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c10.xhtml#c10-fig-0003), the options, which have been filled in, include:

- Function name
- Region
- Trigger type
- Event type
- Bucket

In the following example, we are uploading a file containing the function code. The contents of that file are as follows:

```
  def cloud_storage_function_test(event_data, event_context):
  print('Event ID: {}'.format(event_context.event_id))
  print('Event type: {}'.format(event_context.event_type))
  print('File: {}'.format(event_data['name']))
```

The function name is what Google Cloud will use to refer to this function. Memory Allocated is the amount of memory that will be available to the function. Memory options range from 128 MB to 8 GB for original Cloud Functions and 16 GB with Second-Generation Cloud Functions. Trigger is one of the defined triggers, such as HTTP, Cloud Pub/Sub, and Cloud Storage. There are several options for specifying where to find the source code, including uploading it, getting it from Cloud Storage or a Cloud Source repository, or entering the code in an editor. Runtime indicates which runtime to use to execute the code. The editor is where you can enter function code. Finally, the function to execute is the name of the function in the code that should run when the event occurs.

![Snapshot of creating a function in the console](../images/c10f003.png)


[**FIGURE 10.3**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c10.xhtml#R_c10-fig-0003) Creating a function in the console

After a function is created, you will see a list of functions in the Cloud Functions console, as shown in [Figure 10.4](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c10.xhtml#c10-fig-0004).

![Snapshot of list of functions in the console](../images/c10f004.png)


[**FIGURE 10.4**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c10.xhtml#R_c10-fig-0004) List of functions in the console

### Deploying a Cloud Function for Cloud Storage Events Using *gcloud* Commands

The first step to using `gcloud` commands for Cloud Functions is to make sure you have the latest version of the commands installed. You can update standard `gcloud` commands using this:

```
gcloud components update
```

If any of the commands for the environment you choose are in beta, you can ensure that they are installed with the following command:

```
gcloud components install beta
```

Let's assume you have created a Cloud Storage bucket called `gcp-ace-exam-test-bucket`. You can deploy a function using the `gcloud functions deploy` command. This command takes the name of a function as its argument. There are also three parameters you will need to pass in:

- `runtime`
- `trigger-resource`
- `trigger-event`

`runtime` indicates whether you are using Python 3.7, Node.js 6, or Node.js 8. `trigger-resource` indicates the bucket name associated with the trigger. `trigger-event` is the kind of event that will trigger the execution of the function. The possible options are as follows:

- `google.storage.object.finalize`
- `google.storage.object.delete`
- `google.storage.object.archive`
- `google.storage.object.metadataUpdate`

`finalize` is the term used to describe when a file is fully uploaded.

Whenever a new file is uploaded to the bucket called `gcp-ace-exam-test-bucket`, we want to execute the `cloud_storage_function_test`. We accomplish this by issuing the following command:

```
gcloud functions deploy cloud_storage_function_test \
         --runtime python39 \
         --trigger-resource gcp-ace-exam-test-bucket \
         --trigger-event google.storage.object.finalize
```

When you upload a file to the bucket, the function will execute and create a log message. When you are done with the function and want to delete it, you can use the `gcloud` function's `delete` command, like so:

```
gcloud functions delete cloud_storage_function_test
```

## Cloud Functions Receiving Events from Pub/Sub

A function can be executed each time a message is written to a Pub/Sub topic. You can use Cloud Console or `gcloud` commands to deploy functions triggered by a Cloud Pub/Sub event.

### Deploying a Cloud Function for Cloud Pub/Sub Events Using Cloud Console

Assume you are using a function similar to one used in the previous Cloud Storage example. This time we'll call the function `pub_sub_function_test`.

To create a function using Cloud Console, select the Cloud Function options from the vertical menu in the console. In the Cloud Functions console, you may be prompted to enable the Cloud Functions API if it is not already enabled. After the API is enabled, you will have the option to create a new function. When creating a function, you will need to specify several parameters, including the cloud function name, memory allocated, event type, and source code. Here is the source code for `pub_sub_function_test`:

```
def pub_sub_function_test(event_data, event_context):
    import base64 print('Event ID: {}'.format(event_context.event_id))
      print('Event type: {}'.format(event_context.event_type))
      if 'name' in event_data:
      name = base64.b64decode(event_data['name']).decode('utf-8')
      print('Message name: {}'.format(event_data['name']))
```

This function prints the event ID and event type associated with the message. If the event data has a key-value pair with the key of `name`, then the function will also print the name in the message. Note that this function has an import statement and uses a function called `base64.b64decode`. This is because messages in Pub/Sub are encoded to allow for binary data in a place where text data is expected, and the `base64.b64decode` function is used to convert it to a more common text encoding called UTF-8.

The code is deployed in the same way as the previous Cloud Storage example with two exceptions. Instead of selecting a Cloud Storage trigger, choose Cloud Pub/Sub from the list of triggers, as shown in [Figure 10.5](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c10.xhtml#c10-fig-0005).

![Snapshot of selecting a trigger from options in Cloud Console](../images/c10f005.png)


[**FIGURE 10.5**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c10.xhtml#R_c10-fig-0005) Selecting a trigger from options in Cloud Console

You can also specify the name of the Cloud Pub/Sub topic after specifying this is a Cloud Pub/Sub trigger. If the topic does not exist, it can be created, as shown in [Figure 10.6](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c10.xhtml#c10-fig-0006).

### Deploying a Cloud Function for Cloud Pub/Sub Events Using *gcloud* Commands

To deploy this function, you use the `gcloud functions deploy` command. When deploying a Cloud Pub/Sub function, you specify the name of the topic that will contain messages that will trigger the function. Like deploying for Cloud Storage, you have to specify the runtime environment you want to use. Here's an example:

```
gcloud functions deploy pub_sub_function_test --runtime python39 --trigger-topic gcp-ace-exam-test-topic
```

![Snapshot of creating a Pub/Sub topic while creating a Cloud Function](../images/c10f006.png)


[**FIGURE 10.6**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c10.xhtml#R_c10-fig-0006) Creating a Pub/Sub topic while creating a Cloud Function

You can delete this function using the `gcloud functions delete` command. Here's an example:

```
gcloud functions delete pub_sub_function_test
```

## Summary

In this chapter, we worked with Cloud Functions and saw how to implement and deploy functions. We used examples of functions written in Python, but they could have been written in Node.js or one of several other supported languages as well. Functions can be created using either the Google Cloud Console or the command line. To use Cloud Functions, it is important to understand the relationship between events, triggers, and functions. Events are actions that happen in the cloud. Different services have different types of events. Triggers are how you indicate you want to execute a function when an event occurs. Functions refer to the code that is executed when an event occurs that has a trigger defined for it.

## Exam Essentials

- **Know the relationship between events, triggers, and functions.**   Events are actions that happen, such as when a file is uploaded to Cloud Storage or a message is written to a Cloud Pub/Sub topic. Triggers are declarations that an action should be taken when an event occurs. Functions associated with triggers define what actions are taken when an event occurs.
- **Know when to use Cloud Functions.**   Cloud Functions is a service that supports single-purpose functions that respond to events in the cloud. Cloud Run is also a serverless computing option, but it is used to deploy multifunction applications, including those that users interact with directly.
- **Know the runtimes and generations supported in Cloud Functions.**   Cloud Functions support the following runtimes: Node.js, Python, Go, Java, .NET, Ruby, and PHP. There are two generations of Cloud Functions, the original is known as First Generation and the other Second Generation. Second-Generation Cloud Functions have fewer constraints and more functionality.
- **Know the parameters for defining a cloud function on a Cloud Storage event.**   Parameters for Cloud Storage include the following:
  - Cloud function name
  - Memory allocated for the function
  - Trigger
  - Event type
  - Source of the function code
  - Runtime
  - Source code
  - Name of the function to execute
- **Know the parameters for defining a Cloud Function on a Cloud Pub/Sub event.**  Parameters for Pub/Sub include the following:
  - Cloud function name
  - Memory allocated for the function
  - Trigger
  - Topic
  - Source of the function code
  - Runtime
  - Source code
  - Name of the function to execute
- **Know the `gcloud` commands for working with Cloud Functions.**  These include the following:
  - `gcloud functions deploy`
  - `gcloud functions delete`

## Review Questions

You can find the answers in the Appendix.

1. A product manager is proposing a new application that will require several back-end services and three business logic services. Each service will provide a single function, and it will require several of these services to complete a business task. Service execution time is dependent on the size of input and is expected to take up to 90 minutes in some cases. Which GCP product is a good serverless option for running this related service?
   1. Cloud Functions
   2. Compute Engine
   3. Cloud Run
   4. Cloud Storage
2. You have been asked to deploy a cloud function to reformat image files as soon as they are uploaded to Cloud Storage. You notice after a few hours that about 10 percent of the files are not processed correctly. After reviewing the files that failed, you realize they are all substantially larger than average. What could be the cause of the failures?
   1. There is a syntax error in the function code.
   2. The wrong runtime was selected.
   3. The timeout is too low to allow enough time to process large files.
   4. There is a permissions error on the Cloud Storage bucket containing the files.
3. When an action occurs in GCP, such as a file being written to Cloud Storage or a message being added to a Cloud Pub/Sub topic, what is that action called?
   1. An incident
   2. An event
   3. A trigger
   4. A log entry
4. All of the following generate events that can be triggered using Cloud Functions, except which one?
   1. Cloud Storage
   2. Cloud Pub/Sub
   3. SSL
   4. Firebase
5. Which runtimes are supported in Cloud Functions?
   1. Node.js and Python only
   2. Node.js, Python, and Ruby only
   3. Node.js, Python, .NET, and Go only
   4. Node.js, Python, Go, Java, .NET, Ruby, and PHP only
6. An HTTP trigger can be invoked by making a request using which of the following?
   1. `GET` only
   2. `POST` and `GET` only
   3. `DELETE`, `POST`, and `GET`
   4. `DELETE`, `POST`, `REVISE`, and `GET`
7. What types of events are available to Cloud Functions working with Cloud Storage?
   1. Upload or finalize and delete only
   2. Upload or finalize, delete, and list only
   3. Upload or finalize, delete, and metadata update only
   4. Upload or finalize, delete, archive, and metadata update
8. You are tasked with designing a function to execute in Cloud Functions. The function will need more than the default amount of memory and should be applied only when a finalize event occurs after a file is uploaded to Cloud Storage. The function should only apply its logic to files with a standard image file type. Which of the following required features cannot be specified in a parameter and must be implemented in the function code?
   1. Cloud function name
   2. Memory allocated for the function
   3. File type to apply the function to
   4. Event type
9. How much memory can be allocated to a Cloud Function when using Second-Generation functions?
   1. 128 MB to 256 MB
   2. 128 MB to 512 MB
   3. 128 MB to 1 GB
   4. 128 MB to 16 GB
10. How long can a Second-Generation event type Cloud Function run by default before timing out?
    1. 30 seconds
    2. 1 minute
    3. 10 minutes
    4. 20 minutes
11. You want to use the command line to manage Cloud Functions that will be written in Python. What command should you run to ensure your command-line SDK is up to date?
    1. `gcloud components install`
    2. `gcloud install components functions`
    3. `gcloud functions install components`
    4. `gcloud functions install`
12. You want to create a cloud function to transform audio files into different formats. The audio files will be uploaded into Cloud Storage. You want to start transformations as soon as the files finish uploading. Which trigger would you specify in the Cloud Function to cause it to execute after the file is uploaded?
    1. `google.storage.object.finalize`
    2. `google.storage.object.upload`
    3. `google.storage.object.archive`
    4. `google.storage.object.metadataUpdate`
13. You are defining a Cloud Function to write a record to a database when a file in Cloud Storage is archived. What parameters will you have to set when creating that function?
    1. `runtime` only
    2. `trigger-resource` only
    3. `runtime`, `trigger-resource`, `trigger-event` only
    4. `runtime`, `trigger-resource`, `trigger-event`, `file-type`
14. You'd like to stop using a Cloud Function and delete it from your project. Which command would you use from the command line to delete a Cloud Function?
    1. `gcloud functions delete`
    2. `gcloud components function delete`
    3. `gcloud components delete`
    4. `gcloud delete functions`
15. You have been asked to deploy a Cloud Function to work with Cloud Pub/Sub. As you review the Python code, you notice a reference to a Python function called `base64.b64decode`. Why would a decode function be required in a Pub/Sub cloud function?
    1. It's not required and should not be there.
    2. Messages in Pub/Sub topics are encoded to allow binary data to be used in places where text data is expected. Messages need to be decoded to access the data in the message.
    3. It is required to add padding characters to the end of the message to make all messages the same length.
    4. The decode function maps data from a dictionary data structure to a list data structure.
16. Which of these commands will deploy a Python Cloud Function called `pub_sub_function_test`?
    1. `gcloud functions deploy pub_sub_function_test`
    2. `gcloud functions deploy pub_sub_function_test --runtime python37`
    3. `gcloud functions deploy pub_sub_function_test --runtime python37 --trigger-topic gcp-ace-exam-test-topic`
    4. `gcloud functions deploy pub_sub_function_test --runtime python --trigger-topic gcp-ace-exam-test-topic`
17. When specifying a Cloud Storage Cloud Function, you have to specify an event type, such as `finalize`, `delete`, or `archive`. When specifying a Cloud Pub/Sub Cloud Function, you do not have to specify an event type. Why is this the case?
    1. Cloud Pub/Sub does not have triggers for event types.
    2. Cloud Pub/Sub has triggers on only one event type, when a message is published.
    3. Cloud Pub/Sub determines the correct event type by analyzing the function code.
    4. The statement in the question is incorrect; you do have to specify an event type with Cloud Pub/Sub functions.
18. Your company has a web application that allows job seekers to upload résumé files. Some files are in Microsoft Word, some are PDFs, and others are text files. You would like to store all résumés as PDFs. How could you do this in a way that minimizes the time between upload and conversion and with minimal amounts of coding?
    1. Write a Cloud Run application with multiple services to convert all documents to PDF.
    2. Implement a Cloud Function on Cloud Storage to execute on a finalize event. The function checks the file type, and if it is not PDF, the function calls a PDF converter function and writes the PDF version to the bucket that has the original.
    3. Add the names of all files to a Cloud Pub/Sub topic and have a batch job run at regular intervals to convert the original files to PDF.
    4. Implement a Cloud Function on Cloud Pub/Sub to execute on a finalize event. The function checks the file type, and if it is not PDF, the function calls a PDF converter function and writes the PDF version to the bucket that has the original.
19. What are options for uploading code to a cloud function?
    1. Inline editor
    2. Zip upload
    3. Cloud source repository
    4. All of the above
20. What type of trigger allows developers to use HTTP `POST`, `GET`, and `PUT` calls to invoke a Cloud Function?
    1. HTTP
    2. Webhook
    3. Cloud HTTP
    4. None of the above