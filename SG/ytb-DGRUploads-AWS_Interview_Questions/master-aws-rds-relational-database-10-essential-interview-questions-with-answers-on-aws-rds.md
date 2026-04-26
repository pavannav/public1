# Master AWS RDS - Relational Database | 10 Essential Interview Questions with Answers on AWS RDS

## Introduction

This study guide summarizes the top 10 AWS RDS interview questions from the training transcript. Each question includes a structured Q&A format with explanations, along with validation notes where appropriate.

## 1. What is AWS RDS?

### Question
What is AWS RDS?

### Answer
AWS RDS (Relational Database Service) is a fully managed database service in AWS that simplifies database setup, operation, and scaling. It allows users to quickly deploy a database and integrate it with applications. RDS supports multiple database engines such as MySQL, PostgreSQL, Oracle, SQL Server, MariaDB, Aurora (Amazon's proprietary engine), and IBM DB2. When creating a database, users can choose the desired engine.

### Notes
The explanation is accurate and covers key points. No improvements needed.

## 2. How does AWS RDS handle backups?

### Question
How does AWS RDS handle backups?

### Answer
AWS RDS handles backups through two types:
- Automated backups: Enabled by default, they include daily full backups and transaction logs for point-in-time recovery. Users can set a backup window and retention period (up to 35 days).
- Manual backups: User-initiated snapshots created via the RDS console.

### Notes
Correct. The answer explains both types clearly and mentions the UI aspects.

## 3. Can you change the DB instance class of a running RDS instance?

### Question
Can you change the DB instance class of a running RDS instance?

### Answer
Yes, you can modify the DB instance class to scale vertically by changing the instance type (e.g., from t.micro to a larger size). This allows increasing CPU, memory, or storage capacity after the instance is launched, done through the RDS console options.

### Notes
Accurate description of vertical scaling in RDS.

## 4. What is Multi-AZ deployment in RDS?

### Question
What is multi-AZ deployment in RDS?

### Answer
Multi-AZ deployment enhances high availability and fault tolerance by replicating the database. It includes:
- A primary database instance.
- A standby database instance in a different Availability Zone (AZ).

In case of failure, traffic automatically switches to the standby. Options include:
- Multi-AZ DB cluster: 1 primary + 2 readable standbys.
- Multi-AZ DB instance: 1 primary + 1 standby.
- Single DB instance: No standby.

### Notes
The transcript has a minor typo ("multi-AED" instead of "multi-AZ"), but the concept is correct. Multi-AZ is specifically for failover and requires at least two AZs in the same region.

![Multi-AZ Deployment Diagram](images/multi_az_deployment.png)

## 5. How is data encrypted in AWS RDS?

### Question
How is data encrypted in AWS RDS?

### Answer
Data is encrypted using AWS Key Management Service (KMS). Encryption can be enabled when creating a new DB instance. For existing instances, create an encrypted snapshot and restore it as a new DB with encryption.

### Notes
Correct. KMS manages the encryption keys, and enabling encryption at rest requires careful planning for existing databases via snapshots.

## 6. What is the purpose of read replicas in RDS?

### Question
What is the purpose of read replicas in RDS?

### Answer
Read replicas improve read scalability by offloading read-heavy workloads from the primary database. They are read-only copies created via the RDS console after launching the primary instance, helping to reduce load and enhance performance.

### Notes
Accurate. Read replicas support scaling read operations but not writes.

## 7. How can you monitor RDS performance?

### Question
How can you monitor RDS performance?

### Answer
RDS integrates with Amazon CloudWatch for monitoring. CloudWatch provides:
- Basic monitoring (default).
- Enhanced monitoring (paid, for detailed metrics).

Additional analysis comes from database logs. Metrics include CPU, network, and load.

### Notes
Correct, with integration details mentioned. Performance Insights is an additional feature (mentioned in the transcript), which could be explicitly noted as an optional paid tool.

## 8. Can you install custom software on an RDS instance?

### Question
Can you install custom software on an RDS instance?

### Answer
No, as RDS is a fully managed service, you cannot install custom software. Only the software provided and supported by AWS for the chosen database engine can be used.

### Notes
Entirely accurate. RDS does not allow root or SSH access to install additional software, which differentiates it from EC2-hosted databases.

## 9. What is the purpose of parameter groups in RDS?

### Question
What is the purpose of parameter groups in RDS?

### Answer
Parameter groups allow customization of database settings to tune performance, enable features, or adjust behavior. They contain parameters specific to the database engine selected.

### Notes
Correct explanation. Parameter groups help override default engine configurations without directly modifying the instance.

## 10. How can you scale the storage capacity of an RDS instance?

### Question
How can you scale the storage capacity of an RDS instance?

### Answer
Storage capacity can be scaled by:
- Specifying allocated storage during DB creation.
- Modifying existing instances via the RDS console to increase storage.

### Notes
Accurate, as RDS supports elastic storage scaling without downtime.

<summary>
<model_id>CL-KK-Terminal</model_id>
<file_processed>Master AWS RDS - Relational Database _ 10 essential interview questions with answers on AWS RDS!.txt</file_processed>
<questions_processed>10</questions_processed>
<type>A</type>
<images_created>1</images_created>
<validation_notes>5</validation_notes>
</summary>
