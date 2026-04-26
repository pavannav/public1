# Master AWS Messaging Services _ 10 essential interview questions with answers on AWS SNS and SQS.

## AWS SNS Interview Questions

### 1. What is AWS SNS?

**Answer:** AWS SNS (Simple Notification Service) is a fully managed messaging service in AWS that enables sending notifications and decoupling microservice, distributed system, or serverless applications. It helps remove dependencies between multiple components by allowing you to send messages, such as email or text notifications, to a distributed set of subscribers (end users). The service handles message delivery to various protocols including email, SMS, HTTP/HTTPS, and more.

**Note:** This explanation is accurate. SNS is indeed a push-based service ideal for fan-out scenarios where a message needs to reach multiple recipients simultaneously.

### 2. How does SNS differ from SQS?

**Answer:** SNS follows a push mechanism, where messages are pushed to subscribers (end users), while SQS follows a pull mechanism, requiring consumers to pull messages from the queue. Additionally, SNS supports multiple protocols (HTTP/HTTPS, email, SMS, etc.), making it suitable for notifications to users or endpoints. SQS does not support these protocols; consumers must poll (pull) messages from the queue.

![SNS vs SQS Comparison](images/sns-vs-sqs.png)

**Note:** The explanation is correct. SNS is pub/sub model for notifications/events, while SQS is a queueing service for decoupling and buffering messages.

### 3. What are topics in SNS?

**Answer:** Topics in SNS are user-defined communication channels (groups of subscribers) that receive notifications. You create a topic with a name (e.g., "SupportTeam"), add subscribers (endpoints like emails or HTTP URLs), and publish messages to it. Subscribers need to confirm subscriptions (e.g., via email confirmation) to receive messages.

![SNS Topic Structure](images/sns-topic-structure.png)

**Note:** Accurate description. Topics are logical channels for grouping subscribers interested in the same type of notifications.

### 4. How does SNS handle message delivery to multiple subscribers?

**Answer:** SNS follows a publish/subscribe model (push mechanism). When you publish a message to a topic, SNS delivers a copy of that message to all subscribers subscribed to that topic simultaneously. Each subscriber receives their own copy of the message for processing.

**Note:** This is correct. SNS ensures fan-out messaging where one published message reaches multiple subscribers asynchronously.

### 5. What is the significance of message attributes in SNS?

**Answer:** Message attributes are optional metadata added to messages during publishing. They allow filtering of messages based on attributes at the subscription level, ensuring only interested subscribers receive specific messages. This helps avoid spam and delivers targeted notifications.

![SNS Message Attributes](images/sns-message-attributes.png)

**Note:** Accurate. Message attributes enable conditional delivery, which is key for scenarios requiring message routing/filtering in pub/sub patterns.

## AWS SQS Interview Questions

### 1. What is AWS SQS?

**Answer:** AWS SQS (Simple Queue Service) is a fully managed message queuing service in AWS that enables decoupling of applications by allowing messages to be sent between different parts of a distributed system. It follows a pull mechanism: producers send messages to a queue, and consumers pull messages to process them, removing dependencies between components.

**Note:** This explanation is correct. SQS is designed for reliable, scalable message queuing without the need for managing server infrastructure.

### 2. What are the different types of queues in SQS?

**Answer:** SQS offers two types of queues: Standard Queues (default) and FIFO (First-In-First-Out) Queues. Standard Queues provide best-effort ordering (no guarantee that messages are processed in the sent order), while FIFO Queues guarantee exact ordering (processing matches the sent order). FIFO Queues also support deduplication.

![SQS Queue Types](images/sqs-queue-types.png)

**Note:** Accurate. Choose Standard for high-throughput, at-least-once delivery scenarios, and FIFO for order-critical applications like financial transactions.

### 3. How does SQS handle message visibility?

**Answer:** SQS uses a visibility timeout to hide messages from other consumers once a message is picked up. When a consumer receives a message, it becomes invisible for the specified visibility timeout duration (0 seconds to 12 hours). If the message is processed within this time, it gets deleted; otherwise, it becomes visible again for redelivery. This prevents message loss in case of processing failures.

**Note:** Correct mechanism. Visibility timeout is crucial for handling distributed processing and retries in queue-based systems.

### 4. What is long polling in SQS?

**Answer:** Long polling is a mechanism where consumers wait for messages to arrive in an empty queue instead of immediately returning with no messages. Consumers connect to the queue and hold the connection open until a message arrives or a timeout occurs, reducing API calls and costs compared to short polling.

**Note:** This answer is accurate. Long polling optimizes for efficiency in low-traffic scenarios by minimizing empty responses.

### 5. How can you scale SQS to handle increased message throughput?

**Answer:** To scale SQS, increase the number of queues, use AWS SDKs to parallelize sending and receiving messages, or combine with SNS to fan out messages to multiple SQS queues. This distributes load and prevents message bottlenecks.

![SQS Scaling Strategies](images/sqs-scaling.png)

**Note:** The answer is correct. These methods leverage SQS's distributed nature to handle volume increases in production environments.

<summary>CL-KK-Terminal</summary>
