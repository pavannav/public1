<details open>
<summary><b>AWS Lambda in 10 Minutes (KK-CS45-script-v2-Interview)</b></summary>

## What is AWS Lambda?

**Question:** What is AWS Lambda?

**Answer:** AWS Lambda is a serverless compute service that lets you run code in response to events without managing servers. It executes when something happens (an event triggers it) and is essentially a piece of code running in the background.

**Example Use Cases:**
1. **Image Compression on S3 Upload:** When a user uploads an image during signup, the image goes to Amazon S3. A trigger fires and Lambda automatically executes code to compress the image before storing, reducing S3 storage costs.
2. **Welcome Email on Signup:** When a user signs up, Lambda automatically sends a welcome email without manual intervention.

**Key Characteristics:**
- Only executes when triggered by an event
- No server management required
- Code runs independently in the background

---

## Why Not Write Lambda Code Directly in the Main Application?

**Question:** Why not just write the Lambda function code directly inside the main application instead of using a separate Lambda function?

**Answer:** While technically possible, including Lambda logic directly in the main application creates performance and design issues:

**Problems with Code in Main Application:**
- For every user request, the main application must execute the additional code (e.g., sending welcome emails)
- Main application becomes heavier and slower to respond
- Request processing time increases
- Core application logic gets mixed with peripheral tasks

**Benefits of Separate Lambda Functions:**
- Lambda runs **independently** in the background
- Main application stays **lightweight, focused, and faster**
- Only core/necessary code remains in the main application
- Tasks that can be delayed or done independently are offloaded to Lambda
- Easier to maintain and scale

---

## What Does Serverless Mean in AWS? Is It Truly Serverless?

**Question:** What exactly is serverless in AWS? Does it mean there are no servers?

**Answer:** 

**Definition:** Serverless means running code without managing servers. You pay only for how many times your Lambda function executes, not for server uptime.

**Is It Truly Serverless?**
- **No**, servers still exist — Lambda functions run on AWS servers
- **Yes**, from your perspective it is serverless because:
  - You do **not manage** the server
  - You don't set it up, maintain it, or worry about patches/updates
  - AWS handles all server infrastructure

**Advantage of Being Serverless:**
- Lambda runs on separate servers independent from your main application (which might be on EC2 or Elastic Beanstalk)
- You focus only on writing code, not infrastructure

---

## Why Decouple Logic with Lambda? (Monolith vs Microservices Context)

**Question:** What is the advantage of Lambda being independent/serverless?

**Answer:** AWS Lambda enables decoupling of logic from the main application, aligning with the industry shift from monolithic to microservices architecture.

**Monolithic Applications (Old Approach):**
- Frontend, backend, logic, HTML, Java, JavaScript — everything in one big application
- A single change requires testing the entire application
- High risk and tight coupling

**Microservices & Decoupling (Modern Approach):**
- Move toward small, independent, loosely-coupled services
- Changes in one service don't affect others
- Lambda helps achieve this by extracting independent logic (image compression, email notifications, data cleanup) into separate functions

**Logic Suitable for Lambda:**
- Image compression
- Email notifications
- Data cleanup
- Any task that runs independently

---

## Summary

| Concept | Key Point |
|---------|-----------|
| **AWS Lambda** | Serverless compute service that runs code in response to events |
| **Why separate from main app** | Keeps main app lightweight; improves performance and maintainability |
| **Serverless meaning** | No server management; servers exist but AWS handles them |
| **Payment model** | Pay per execution, not per server uptime |
| **Use cases** | Image compression, welcome emails, independent background tasks |
| **Architecture benefit** | Enables decoupling and microservices pattern |

</details>