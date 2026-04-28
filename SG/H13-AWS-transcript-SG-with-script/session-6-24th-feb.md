# Session 6: AWS CloudWatch, IAM, and CLI Introduction

## Table of Contents
- [Overview](#overview)
- [CloudWatch Introduction](#cloudwatch-introduction)
- [IAM (Identity and Access Management)](#iam-identity-and-access-management)
- [AWS CLI (Command Line Interface)](#aws-cli-command-line-interface)
- [Summary](#summary)

## Overview
Session 6 introduces three fundamental AWS services: **CloudWatch** for monitoring resources, **IAM** for managing access and security, and **AWS CLI** for programmatic access to AWS services. These services provide the foundation for operational management, security governance, and automation in AWS environments.

## CloudWatch Introduction

### Key Concepts

#### What is CloudWatch?
CloudWatch is AWS's monitoring and observability service that tracks AWS resources and applications in real-time. It provides comprehensive insights into system performance, resource utilization, and operational health.

#### Resource Monitoring
CloudWatch monitors various AWS resources including:
- **EC2 instances**: CPU utilization, memory, network traffic, disk I/O
- **EBS volumes**: Read/write operations, latency
- **Auto Scaling groups**: Instance scaling events
- **Load Balancers**: Request patterns, response times

#### Metrics Collection
```diff
+ CPU Utilization: Percentage of CPU in use
+ Network In: Inbound network traffic (bytes)
+ Network Out: Outbound network traffic (bytes)
+ Disk Read Ops: Number of disk read operations
+ Disk Write Ops: Number of disk write operations
+ Memory Utilization: Amount of RAM in use
```

#### Monitoring Integration
CloudWatch integrates with various AWS services:
- **EC2 Console**: Monitoring tab displays CloudWatch metrics
- **S3**: Bucket operations and storage metrics
- **RDS**: Database performance metrics
- **Lambda**: Function invocation metrics

### Practical Demonstration
The session demonstrates launching an EC2 instance in the Sydney region to show how CloudWatch automatically begins collecting metrics immediately after resource creation.

## IAM (Identity and Access Management)

### Key Concepts

#### IAM Purpose
IAM is AWS's identity and access management service that controls who can access what resources in your AWS account. It provides centralized access control and security management.

#### Account Types
```diff
! Root Account: Main account with full access (email-based authentication)
- IAM Users: Sub-accounts with limited permissions
- Roles: Temporary access control for AWS services
- Groups: Collections of IAM users with shared permissions
```

#### Access Control
IAM implements security best practices:
- **Principle of Least Privilege**: Users get minimum required permissions
- **Policy-Based Access**: Permissions defined through policies
- **Role-Based Access Control**: Different roles for different responsibilities

#### Practical Setup
The session demonstrates:
- Creating IAM users (Tom and Eric) with different access levels
- Assigning permissions using AWS managed policies
- Accessing console using hashed URLs containing account ID
- Dynamic permission management (add/remove permissions)

### Access Levels Demonstrated
| User | Console Access | EC2 Permissions | S3 Permissions |
|------|----------------|------------------|----------------|
| Tom | Yes | Read-only | None |
| Eric | Yes | Full access | Variable (added/removed) |

## AWS CLI (Command Line Interface)

### Key Concepts

#### Access Methods Comparison
AWS provides three ways to interact with services:

| Method | Authentication | Primary Use |
|--------|----------------|-------------|
| **Management Console** | Username/Password | Human operators, beginners |
| **CLI** | Access Key/Secret Key | Automation, scripting, power users |
| **API/SDK** | Access Key/Secret Key | Application development |

#### CLI Benefits
```diff
+ Automation: Scriptable operations
+ Efficiency: Faster than GUI for repetitive tasks
+ Advanced Features: Access to features not available in console
+ Error Handling: Detailed error messages for troubleshooting
+ Platform Agnostic: Works on Windows, macOS, Linux
```

#### CLI Installation and Setup
The session covers:
- Downloading AWS CLI software
- Installing the CLI tool
- Configuring credentials using `aws configure`
- Specifying region and keys for authentication

### Practical CLI Operations

#### Instance Management
```bash
# List EC2 instances
aws ec2 describe-instances

# Stop an EC2 instance
aws ec2 stop-instances --instance-ids i-xxxxxxxxxxxxxxxxx

# Start an EC2 instance
aws ec2 start-instances --instance-ids i-xxxxxxxxxxxxxxxxx
```

#### CLI Help System
AWS CLI provides built-in help:
```bash
# General help
aws help

# Service-specific help
aws ec2 help

# Sub-command help
aws ec2 describe-instances help
```

## Summary

### Key Takeaways
```diff
+ CloudWatch enables comprehensive monitoring of AWS resources
+ IAM provides fine-grained access control and security governance
+ CLI offers automation capabilities and advanced AWS feature access
+ Services can be accessed via Console, CLI, or API
+ Keys replace passwords for programmatic access
+ Scripts enable infrastructure automation
```

### Quick Reference
**Common EC2 CLI Commands:**
- `aws ec2 describe-instances`: List all instances
- `aws ec2 stop-instances --instance-ids <id>`: Stop instance
- `aws ec2 start-instances --instance-ids <id>`: Start instance

**IAM Concepts:**
- Root account: Full admin access
- IAM users: Limited permission sub-accounts
- Policies: Permission definitions
- Groups: User collections with shared access

**CLI Configuration:**
- Download from AWS website
- Run `aws configure`
- Enter access key, secret key, region

### Expert Insight

**Real-world Application:**
In enterprise environments, CLI is essential for DevOps pipelines where infrastructure provisioning, scaling, and configuration management must be automated. CloudWatch alerts drive auto-scaling decisions, while IAM policies enforce compliance and security standards across distributed teams.

**Expert Path:**
- Master JSON policy creation for custom IAM permissions
- Learn AWS SDKs for programming language integration
- Study advanced CloudWatch features like custom metrics and logs
- Explore Infrastructure as Code tools like CloudFormation with CLI integration

**Common Pitfalls:**
- Over-privileged IAM users can lead to security breaches
- Forgotten access keys should be rotated immediately
- CLI commands without error handling can halt automation scripts
- Region mismatches in CLI configuration cause authentication failures

**Lesser-Known Facts:**
- CloudWatch can monitor custom application metrics beyond AWS services
- IAM supports temporary credentials via STS for enhanced security
- CLI can generate human-readable reports with `--output table` flag
- AWS CLI supports shell completion for faster command entry

---

*🤖 Generated with [Claude Code](https://claude.com/claude-code)*

*Co-Authored-By: Claude <noreply@anthropic.com>*</parameter>
<parameter name="file_path">00_Course_Summary_Tracker.md</parameter>
<parameter name="content"># AWS Cloud Training Course Summary and Tracker

This document tracks the progress of the AWS Cloud training course, including session summaries and overall completion status.

## Course Information
- **Last Updated**: 2026-04-27
- **Total Sessions Completed**: 1
- **Total Sessions Planned**: TBD

## Session Progress

### [X] Session 6: AWS CloudWatch, IAM, and CLI Introduction
**Topics Covered**: CloudWatch fundamentals and resource monitoring, IAM user management and security, AWS CLI setup and basic operations
**Key Concepts**: Metrics collection, access control policies, programmatic access methods
**Notable Commands**: `aws ec2 describe-instances`, `aws ec2 stop-instances`, `aws configure`

---

## Quick Navigation
- [Table of Contents](#table-of-contents)
- [Course Information](#course-information)
- [Session Progress](#session-progress)

---

*🤖 Generated with [Claude Code](https://claude.com/claude-code)*</parameter>
</xai:function_call>
