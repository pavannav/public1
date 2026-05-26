<details open>
<summary><b>This AWS Interview Question Saves Production Servers (KK-CS45-script-v2-Interview)</b></summary>

## Question
**How would you recover a failed EC2 instance automatically?**

**Common Wrong Answer:** Restart the instance → Instant rejection in interviews

## Correct Answer: Use CloudWatch Auto Recovery

### Implementation Steps

1. **Navigate to Status and Monitoring**
   - Go to the EC2 instance detail page
   - Click on "Status and monitoring" tab
   - Click "Create an alarm"

2. **Configure the Alarm**
   - Select metric: **Status check failed: System**
   - Action: Select **Recover** (this moves the instance to healthy hardware)
   - Datapoints: **Maximum**
   - Condition: **System**
   - Threshold: **2 consecutive** failures
   - Period: **1 minute**

3. **Verify Configuration**
   - Go to Status and Alarms section
   - Confirm the alarm "system check failed_system" is created and active

### How CloudWatch Auto Recovery Works

When AWS hardware fails:
- CloudWatch detects the system status check failure
- Automatically moves the EC2 instance to healthy hardware
- **No IP address change**
- **No downtime** - recovery in minutes
- The instance retains all data, configurations, and network settings

### Real-World Impact

| Scenario | Without Auto Recovery | With Auto Recovery |
|----------|---------------------|-------------------|
| Banking server hardware failure | Hours of downtime | Minutes to recover |
| Production system crash | Manual intervention required | Automatic recovery |
| Hardware issues | Instance remains down | Seamless hardware migration |

### Key Points for Interviews

- This demonstrates **production-grade thinking**
- Shows understanding of AWS resilience features
- Highlights knowledge of CloudWatch monitoring capabilities
- Emphasizes business continuity importance
- Listed as Question #3 in AWS 300 Real-time Scenario-based Q&A

### Note
This question tests whether candidates understand the difference between:
- Simple restart (beginner level)
- Automated recovery using AWS managed services (production engineer level)

Companies expect cloud engineers to implement proactive monitoring and automated recovery mechanisms rather than reactive manual interventions.

</details>