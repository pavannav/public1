# Session 35: Event Bridge Custom Rules and Applications

## Table of Contents
- [Overview](#overview)
- [Recap of Previous Session](#recap-of-previous-session)
- [Event-Driven Architecture and Event Bridge Introduction](#event-driven-architecture-and-event-bridge-introduction)
- [Custom Event Buses](#custom-event-buses)
- [Roles in Event Bridge Implementation](#roles-in-event-bridge-implementation)
- [Event Injection and Sources](#event-injection-and-sources)
- [Creating Rules and Event Patterns](#creating-rules-and-event-patterns)
- [Targets and Integrations](#targets-and-integrations)
- [Practical Labs and Demos](#practical-labs-and-demos)
  - [Lab 1: Sending Events to Default Bus](#lab-1-sending-events-to-default-bus)
  - [Lab 2: Creating Custom Bus and Rules](#lab-2-creating-custom-bus-and-rules)
  - [Lab 3: Advanced Rule Patterns with Conditions](#lab-3-advanced-rule-patterns-with-conditions)
  - [Lab 4: ATM Use Case Simulation](#lab-4-atm-use-case-simulation)
- [Summary](#summary)

## Overview
This session builds on the previous session's introduction to AWS CloudWatch Events, transitioning to AWS EventBridge as a more advanced and scalable event management service. EventBridge enables event-driven architectures by allowing integration with custom applications, AWS services, and third-party sources. The session covers creating custom event buses, defining complex rules with JSON patterns, and triggering AWS Lambda functions based on event conditions. Practical demos demonstrate filtering events from a simulated ATM application, showcasing real-world application in service-oriented systems.

## Recap of Previous Session
- Discussed AWS CloudWatch Events integration with Lambda.
- Explored metrics, logs, and events in CloudWatch.
- Demonstrated event management using rules and event patterns.
- Focused on EC2 state change as an event source, triggering Lambda functions and CloudWatch logs.

## Event-Driven Architecture and Event Bridge Introduction
- **Concept**: Event-driven architecture uses events as triggers for scalable, reliable, and highly available systems. AWS provides frameworks like Serverless Application Model (SAM) for implementation.
- **Key Services**:
  - **Event Sources**: Custom applications, AWS services, third-party partners (e.g., Salesforce, DataDog), partner event sources for Software as a Service (SaaS) integrations.
- **Event Bridge vs. CloudWatch Events**:
  - CloudWatch Events primarily handles AWS service events; EventBridge supports custom, third-party, and partner events.
  - EventBridge offers additional features like schema discovery, archiving, and broader integration capabilities.
- **Difference in Control**:
  - Developers handle event generation (producer role) using SDKs or APIs.
  - Cloud engineers manage event reception, bus creation, rules, and targets (consumer role).

## Custom Event Buses
- **Default Bus**: Pre-created in AWS; stores events from AWS and custom sources unless specified.
- **Custom Buses**: Organize events per application, team, or use case for better security and management.
- **Creation Steps**:
  - Navigate to EventBridge console.
  - Select "Event Buses" and create a new bus (e.g., "my-demo-bus").
  - Provide bus name and optional archive/schema settings.
- **Purpose**: Separates events from different sources, preventing cross-application rule interference.

## Roles in Event Bridge Implementation
- **Developers (Application Team)**:
  - Define events and event information.
  - Implement event generation in code using AWS SDKs (e.g., Python, Java).
  - Format payloads as JSON and send to `put event API`.
- **Cloud Engineers/Architects**:
  - Create and manage event buses.
  - Design rules with patterns to match events.
  - Configure targets (e.g., Lambda, SNS).
- **Separation**: Developers produce events; engineers consume and process them for business logic.

## Event Injection and Sources
- **Put Event API**: Applications use AWS SDKs to send JSON-formatted events to EventBridge.
- **Supported Sources**: Custom apps, AWS services, partner integrations.
- **JSON Structure**: Events include custom data (e.g., `{ "name": "John", "payment_status": "success", "amount": 1500 }`) plus auto-added fields like `source`, `account`, `time`, `detail`.
- **Event Bus Storage**: Acts as temporary storage (days) for event processing.

## Creating Rules and Event Patterns
- **Rules**: Conditions matching event patterns to trigger targets.
- **Event Patterns**: JSON-based filters supporting equality, ranges, prefixes/suffixes, and complex logic.
- **Basic Pattern Example**:
  ```json
  {
    "source": ["my-app"]
  }
  ```
- **Advanced Patterns**:
  - **Numeric Comparisons**: Use `numeric` key for operators.
    ```json
    {
      "detail": {
        "status": ["pass"],
        "amount": [{"numeric": ["<=", 1000]}]
      }
    }
    ```
  - **Prefix Matching**:
    ```json
    {
      "detail": {
        "atm_id": [{"prefix": "India-Japur"}]
      }
    }
    ```
- **Rule Creation**:
  - Select bus (default or custom).
  - Choose event source type (custom, AWS, partner).
  - Define pattern in JSON or use visual builder.
  - Add targets (e.g., Lambda functions).

## Targets and Integrations
- **Supported Targets**: Lambda, SNS, CloudWatch Logs, etc.
- **Trigger Mechanism**: When pattern matches, target is invoked with full event data.
- **Permissions**: EventBridge auto-adds necessary IAM permissions.

| Target Service | Use Case |
|----------------|----------|
| AWS Lambda     | Execute custom logic, e.g., send SMS on failure |
| Amazon SNS     | Send notifications (email, SMS) |
| CloudWatch Logs| Logging and monitoring |

## Practical Labs and Demos

### Lab 1: Sending Events to Default Bus
- Navigate to EventBridge console, select default bus.
- Click "Send Events".
- Configure:
  - Source: `my-app`
  - Detail Type: `payment-status`
  - JSON Payload:
    ```json
    {
      "name": "Example Customer",
      "mobile": "1234567890",
      "payment_status": "failed"
    }
    ```
- Send event; verify in bus events.
- Result: Event stored with additional AWS metadata.

### Lab 2: Creating Custom Bus and Rules
- Create custom bus: `my-demo-bus`.
- Create rule for bus:
  - Pattern:
    ```json
    {
      "source": ["my-app"]
    }
    ```
  - Target: CloudWatch Logs group `my-rule-log`.
- Send test event; verify log creation.

### Lab 3: Advanced Rule Patterns with Conditions
- Create rules with numeric and prefix filters.
- Example Rule 1: Fail events.
  ```json
  {
    "detail": {
      "status": ["fail"]
    }
  }
  ```
  - Target: Lambda function "fail-lambda".
- Example Rule 2: Pass events with amount > 1000.
  ```json
  {
    "detail": {
      "status": ["pass"],
      "amount": [{"numeric": [">", 1000]}]
    }
  }
  ```
  - Target: Lambda function "pass-greater-lambda".
- Example Rule 3: Pass events with amount < 1000 and ATM ID prefix.
  ```json
  {
    "detail": {
      "status": ["pass"],
      "amount": [{"numeric": ["<=", 1000]}],
      "atm_id": [{"prefix": "India-Japur"}]
    }
  }
  ```
  - Target: Lambda function "pass-less-lambda".
- Send events matching patterns; check Lambda invocations via CloudWatch.

### Lab 4: ATM Use Case Simulation
- Simulate ATM application events.
- JSON Payload Example:
  ```json
  {
    "detail": {
      "atm_id": "India-Japur-001",
      "amount": 500,
      "status": "fail"
    }
  }
  ```
- Rules trigger based on:
  - Status: Pass/fail.
  - Amount: >1000, <=1000.
  - ATM ID: Prefix matching.
- Lambda functions log events and simulate actions (e.g., send notifications).
- Verify: Check CloudWatch logs for triggered functions; monitor rule invocations.

## Summary

### Key Takeaways
```diff
+ Event Bridge extends CloudWatch Events with custom and third-party integrations.
+ Event buses organize events per application for better management.
+ Rules use JSON patterns with equality, numeric, and prefix operators.
+ Event-driven architectures enable scalable, service-decoupled systems.
```

### Quick Reference
- **Create Custom Bus Command** (via Console): EventBridge > Event Buses > Create New Bus.
- **Basic Event Pattern**:
  ```json
  {"source": ["custom-app"], "detail": {"status": ["pass"]}}
  ```
- **Numeric Pattern for Amount > 1000**:
  ```json
  {"detail": {"amount": [{"numeric": [">", 1000]}]}}
  ```
- **Common SDK Usage** (Python): Use `boto3` to `put_event` with JSON payload.

### Expert Insight

**Real-World Application**: In financial systems like ATMs or e-commerce platforms, EventBridge orchestrates workflows such as fraud detection (via Lambda on high-amount transactions) or notifications (via SNS on failures), enabling microservices communication without tight coupling.

**Expert Path**: Master EventBridge by integrating with Step Functions for complex workflows. Explore event replay, schema discovery for auto-generating patterns, and archiving for compliance auditing.

**Common Pitfalls**: Mismatched JSON structures cause unmatched rules; ensure event sources specify the correct bus name. Overly broad patterns trigger unintended targets—test extensively.

**Lesser-Known Facts**: EventBridge supports cross-account event routing via resource-based policies. Archive feature saves old events for up to 90 days, aiding debugging without external storage. Running AWS EventBridge is serverless, scaling automatically like Lambda.

**Advantages**:
- Serverless scalability with pay-for-use model.
- Supports multiple sources (AWS, custom, partners).
- Rich pattern matching for complex conditions.

**Disadvantages**:
- Learning curve for complex JSON patterns.
- Limited visibility into event flow compared to dedicated message brokers like SQS.
- Integration delays in hybridget-orical setups.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
