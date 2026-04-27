# Top 10 Common AWS Interview Questions _ AWS Interview Preparation

## 1. What is AWS?

**Question:** What is AWS?

**Answer:** AWS stands for Amazon Web Services and is a popular cloud computing platform. It is one of the major cloud service providers alongside Azure and GCP. AWS provides a wide range of services including storage, computing, networking, databases, and more. It offers a flexible, scalable, and reliable platform for businesses and individuals to run their applications.

**Note:** This answer is correct. AWS is indeed the market leader in cloud computing with over 200 services.

## 2. What are the different types of EC2 instances?

**Question:** What are the different types of EC2 instances?

**Answer:** EC2 (Elastic Compute Cloud) is AWS's service for launching virtual machines. EC2 provides different instance types based on CPU capacity, memory capacity, and network configuration to handle various workloads. The five main types are:
- Compute optimized
- Memory optimized
- Accelerated computing
- Storage optimized
- General purpose

**Note:** This answer is correct. EC2 offers these five main instance families. The "accelerated computing" instances are specifically designed for GPU-intensive workloads like machine learning, but the categorization is accurate.

## 3. What is S3?

**Question:** What is S3?

**Answer:** S3 stands for Simple Storage Service. It is an object-based storage solution in AWS that allows users to store and retrieve any amount of data from anywhere on the web. S3 provides unlimited storage capacity at a low cost, with high durability and availability. However, it does not support installing applications directly on the stored data.

**Note:** This answer is correct. S3 is indeed object storage, not block storage, which explains why you can't install applications on it. It's designed for data storage and retrieval scenarios.

## 4. What is auto-scaling?

**Question:** What is auto-scaling?

**Answer:** Auto-scaling is a feature of EC2 that automatically adjusts the number of EC2 instances based on application demand. It uses Auto Scaling groups to scale up (add instances) or scale down (remove instances) servers to match workload requirements, ensuring applications always have the appropriate capacity to handle user load.

**Note:** This answer is correct. Auto-scaling helps maintain application performance while optimizing costs by matching resources to actual demand.

## 5. What is a VPC?

**Question:** What is a VPC?

**Answer:** VPC stands for Virtual Private Cloud. It is AWS's networking service that allows users to create an isolated section within the AWS cloud to build their virtual network. VPC provides full control over the virtual networking environment, including IP address ranges, subnets, route tables, and network gateways.

**Note:** This answer is correct. VPC is fundamental for network isolation and security in AWS, allowing users to define their own private network topology in the cloud.

## 6. What is CloudFormation?

**Question:** What is CloudFormation?

**Answer:** CloudFormation is AWS's infrastructure-as-code service. It allows users to create and manage AWS infrastructure using declarative templates written in JSON or YAML. When a template is executed, CloudFormation provisions all specified resources automatically, enabling version control and repeatability of infrastructure deployment.

**Note:** This answer is correct. CloudFormation is AWS's native IaC tool, comparable to third-party tools like Terraform, but specific to AWS services.

## 7. What is Lambda?

**Question:** What is Lambda?

**Answer:** Lambda is AWS's serverless compute service. It allows users to run code in response to events (like S3 bucket changes) or on-demand without managing servers. Users focus solely on writing code while AWS handles all infrastructure concerns including provisioning, scaling, and maintenance.

**Note:** This answer is correct. Lambda supports multiple programming languages and integrates with many AWS services for event-driven computing.

## 8. What is DynamoDB?

**Question:** What is DynamoDB?

**Answer:** DynamoDB is AWS's fully managed NoSQL database service. It provides reliable, low-latency performance and is designed to handle large amounts of data at any scale. DynamoDB delivers high performance for queries and operations on massive datasets.

**Note:** This answer is correct. DynamoDB is a key-value and document database optimized for low-latency operations and automatic scaling.

## 9. What is CloudFront?

**Question:** What is CloudFront?

**Answer:** CloudFront is AWS's Content Delivery Network (CDN) service. It distributes web content and applications to servers worldwide using caching to reduce latency and improve data transfer speeds. CloudFront enhances content availability and performance by serving data from edge locations closest to users.

**Note:** This answer is correct. CloudFront integrates with S3 and other AWS services to create globally distributed content delivery networks.

## 10. What is the difference between RDS and DynamoDB?

**Question:** What is the difference between RDS and DynamoDB?

**Answer:** RDS (Relational Database Service) is AWS's managed relational (SQL) database service for running SQL databases in the cloud. DynamoDB, on the other hand, is a NoSQL database service that provides reliable performance with low-latency queries and is designed for handling large-scale data with high performance requirements.

**Note:** This answer is correct. The key distinction is that RDS supports traditional relational databases (like MySQL, PostgreSQL), while DynamoDB is a schemaless NoSQL database optimized for flexible data models and high-throughput applications.
