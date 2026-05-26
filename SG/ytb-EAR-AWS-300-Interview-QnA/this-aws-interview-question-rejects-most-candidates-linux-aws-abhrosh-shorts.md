<details open>
<summary><b>This AWS Interview Question Rejects Most Candidates (KK-CS45-script-v2-Interview)</b></summary>

# AWS EC2 Instance: Stop vs Terminate - Study Guide

## Question
**What is the difference between stopping and terminating an EC2 instance?**

---

## Common Incorrect Answer ❌
"Stopping means pausing an instance and terminating means deleting an instance."

**Result:** Instant rejection in interviews

---

## Correct Answer ✅

### Stopping an EC2 Instance
| Aspect | Behavior |
|--------|----------|
| **State** | Instance shuts down gracefully |
| **EBS Volume** | Preserved - all data remains intact |
| **Public IP** | Released (new IP assigned on restart for non-Elastic IPs) |
| **Billing** | Only EBS storage charges apply |
| **Restart** | Can be restarted later |
| **Use Case** | Dev/Test servers, cost optimization during off-hours |

### Terminating an EC2 Instance
| Aspect | Behavior |
|--------|----------|
| **State** | Instance is permanently deleted |
| **EBS Volume** | Deleted by default (unless termination protection enabled) |
| **Public IP** | Released permanently |
| **Billing** | All charges stop |
| **Restart** | Cannot be restarted |
| **Use Case** | Production decommission, permanent removal |

---

## Key Points to Mention in Interview

1. **EBS Volume Behavior** - Critical differentiator
2. **Cost Implications** - Stopping saves compute costs
3. **IP Address Changes** - Non-Elastic IPs change on restart
4. **Real-world Usage Patterns**:
   - Dev servers: Stopped at night to save costs
   - Production servers: Terminated only during decommissioning

---

## Additional Technical Details

### What Happens When You Stop an Instance:
- Instance performs graceful shutdown
- EBS root volume persists with all data
- Any attached EBS volumes remain attached
- Instance can be started again with same configuration

### What Happens When You Terminate an Instance:
- Instance is marked for deletion
- EBS volumes deleted unless `DeleteOnTermination` is set to `false`
- Instance cannot be recovered
- All data is permanently lost

---

## Best Practices

| Scenario | Recommended Action |
|----------|-------------------|
| Nightly cost savings for non-prod | Stop instances |
| Temporary maintenance window | Stop instances |
| Permanent decommissioning | Terminate instances |
| Testing instance lifecycle | Stop first, then terminate |

---

## Interview Tip
Mentioning **EBS behavior, cost implications, and IP address changes** will help you stand out from other candidates who only provide surface-level answers.

</details>