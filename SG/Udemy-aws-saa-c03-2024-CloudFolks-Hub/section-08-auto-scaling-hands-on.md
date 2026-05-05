# Section 8: Auto Scaling

<details open>
<summary><b>Section 8: Auto Scaling (CL-KK-Terminal)</b></summary>

## Table of Contents
- [8.1 Auto Scaling (Hands-On)](#81-auto-scaling-hands-on)
- [8.2 Auto Scaling Group & Launch Template (Hands-On)](#82-auto-scaling-group--launch-template-hands-on)
- [8.3 Scaling Option Manual Scaling (Hands-On)](#83-scaling-option-manual-scaling-hands-on)
- [8.4 Scaling Option Schedule Scaling (Hands-On)](#84-scaling-option-schedule-scaling-hands-on)
- [8.5 Scaling Option Dynamic Scaling (Hands-On)](#85-scaling-option-dynamic-scaling-hands-on)
- [8.6 Scaling Options Predictive Scaling -- Introduction & Configuration (Hands-On)](#86-scaling-options-predictive-scaling----introduction--configuration-hands-on)
- [8.7 Auto Scaling -- Instance Maintenance Policy (Hands-On)](#87-auto-scaling----instance-maintenance-policy-hands-on)
- [8.8 Auto Scaling -- Default Termination Policy (Hands-On)](#88-auto-scaling----default-termination-policy-hands-on)
- [8.9 Auto Scaling -- Built-in Termination Policies (Hands-On)](#89-auto-scaling----built-in-termination-policies-hands-on)
- [8.10 Auto Scaling -- Custom Termination Policies (Hands-On)](#810-auto-scaling----custom-termination-policies-hands-on)
- [8.11 Auto Scaling -- Types Of Timers](#811-auto-scaling----types-of-timers)
- [8.12 Difference Between AWS Auto Scaling Vs Elastic Load Balancer](#812-difference-between-aws-auto-scaling-vs-elastic-load-balancer)

## 8.1 Auto Scaling (Hands-On)

### Overview
Section 8.1 introduces AWS Auto Scaling, explaining scaling concepts, vertical vs horizontal scaling, and demonstrates how Auto Scaling maintains optimal compute capacity to handle changing demands.

### Key Concepts

**Scaling Definition:**
Scaling refers to adjusting compute capacity in AWS environment to meet changing demands.

**Vertical Scaling (Scale Up/Down):**
- Increasing/decreasing capacity on the same system
- Limited by hardware constraints (RAM, CPU, etc.)
- Not supported by AWS Auto Scaling

**Horizontal Scaling (Scale Out/In):**
- Adding/removing servers/EC2 instances
- No inherent limits
- Supported by AWS Auto Scaling
- Preferred for large-scale applications (e-commerce, etc.)

**Auto Scaling Benefits:**
- Automates capacity adjustment based on demand
- Supports scale-out (adding instances) and scale-in (removing instances)
- Uses horizontal scaling for unlimited growth potential

## 8.2 Auto Scaling Group & Launch Template (Hands-On)

### Overview
Section 8.2 covers Auto Scaling Groups and Launch Templates, demonstrating how they work together to create and manage EC2 instances dynamically.

### Key Concepts

**Auto Scaling Group:**
- Manages collection of EC2 instances as a single unit
- Enables automatic scaling based on demand
- Simplifies EC2 instance management

**Launch Template:**
- Defines configuration for EC2 instances
- Includes AMI, instance type, key pairs, security groups
- Can be reused across multiple Auto Scaling groups

**Configuration Process:**
1. Create Launch Template with instance details
2. Create Auto Scaling Group referencing the Launch Template
3. Specify network settings (VPC, subnets)
4. Configure scaling parameters (min/max/desired capacity)

**Instance Lifecycle:**
- Auto Scaling Group launches instances using Launch Template configuration
- All instances are managed collectively by the Auto Scaling Group
- Supports automated scaling based on scaling policies

### Lab Demo
- Created Launch Template with Amazon Linux 2023, T2 micro, custom security group
- Added user data script for automated web server setup
- Created Auto Scaling Group linked to Launch Template
- Configured VPC and subnet settings

## 8.3 Scaling Option Manual Scaling (Hands-On)

### Overview
Section 8.3 demonstrates manual scaling, the basic scaling option where administrators manually adjust capacity by setting desired capacity values.

### Key Concepts

**Manual Scaling:**
- Simplest scaling method
- Administrator manually adjusts desired capacity
- Suitable for predictable, infrequent events (game launches, special promotions)

**Key Settings:**
- Minimum capacity: Floor level (e.g., 1 instance)
- Maximum capacity: Ceiling level (e.g., 5 instances) 
- Desired capacity: Target number of instances

**Capabilities:**
- Scale out: Increase capacity by raising desired capacity
- Scale in: Decrease capacity by lowering desired capacity
- Fault tolerance: Auto replacement of terminated instances
- Automated web server deployment via user data

### Lab Demo
1. **Launch Template Setup:** Amazon Linux 2023, T2 micro, key pair, custom security group, Apache web server user data
2. **Auto Scaling Group Creation:** Min 1, max 5, desired 1 → automatic EC2 instance creation
3. **Scale Out:** Increased desired capacity from 1→2→3 instances
4. **Scale In:** Decreased desired capacity from 3→2→1 instances
5. **Fault Tolerance:** Manually terminated instances → auto replacement by Auto Scaling Group

### Important Notes
- Set minimum/maximum before desired capacity to avoid conflicts
- Delete Auto Scaling Group to properly terminate all associated instances
- Manual scaling provides full control but requires active monitoring

## 8.4 Scaling Option Schedule Scaling (Hands-On)

### Overview
Section 8.4 covers scheduled scaling, which automates scaling based on predictable time-based patterns like weekday/weekend traffic.

### Key Concepts

**Scheduled Scaling Use Cases:**
- Predictable recurring events (e.g., weekend sales, monthly processing)
- Known traffic patterns (weekdays vs weekends)
- Fixed-time capacity changes

**Scheduling Methods:**
- One-time schedules for temporary events
- Recurring schedules based on cron expressions
- Times in specific time zones

**Practical Example:**
- Weekday: Low traffic → minimal instances
- Weekend: High traffic → increased instances
- Holiday sales: Sudden capacity spikes

### Lab Demo
1. **Launch Template:** Amazon Linux 2023, T2 micro, web server user data
2. **Auto Scaling Group:** Min 1, max 5, desired 1
3. **Schedule Scale-Out:** Set desired capacity to 4 at specific time using Asian/Calcutta timezone
4. **Schedule Scale-In:** Set desired capacity to 1 at later time
5. **Automatic Execution:** Autoscaling triggered at scheduled times without manual intervention

### Important Notes
- Uses cron expressions for complex scheduling
- Timezone specification ensures accurate timing
- Scheduled actions disappear after execution

## 8.5 Scaling Option Dynamic Scaling (Hands-On)

### Overview
Section 8.5 demonstrates dynamic scaling with policies that automatically adjust capacity based on real-time metrics like CPU utilization.

### Key Concepts

**Dynamic Scaling:**
- Reactive scaling based on real-time metrics
- Ideal for unpredictable/unpredictable traffic patterns

**Scaling Policies:**

**Simple Scaling Policy:**
- Single threshold for scaling actions
- Example: Add 1 instance if CPU > 50-60% for X minutes

**Step Scaling Policy:**
- Multiple thresholds with graduated responses
- Example: Add 1 instance (50-60%), add 2 instances (60-70%)

**Target Tracking Scaling Policy:**
- Automatic scaling to maintain target metric value
- Self-optimizing based on ALB requests, CPU, etc.

**Key Components:**
- Dynamic scaling policies measure metrics (CPU, network, etc.)
- Instance warm-up time allows new instances to become operational
- Cooldown periods prevent scaling thrashing

### Lab Demo
1. **Launch Template:** Custom user data script for CPU load generation via Python
2. **Auto Scaling Group:** Target tracking policy maintaining CPU at 60%
3. **Scale-Out:** Automatic instance addition when CPU exceeds 60%
4. **Scale-In:** Automatic instance removal when CPU drops below 60%

### Monitoring Integration
- CloudWatch alarms trigger scaling based on defined metrics
- Policies automatically adjust desired capacity
- Real-time response to traffic changes

**Important Notes:**
- Instance warm-up prevents premature scaling decisions
- Cooldown periods maintain system stability
- Multiple scaling policies can work together

## 8.6 Scaling Options Predictive Scaling -- Introduction & Configuration (Hands-On)

### Overview
Section 8.6 introduces predictive scaling, which uses machine learning to forecast future demand and proactively adjust capacity.

### Key Concepts

**Predictive Scaling:**
- Uses ML on historical data (minimum 3 weeks) to forecast demand
- Proactive scaling vs reactive dynamic scaling
- Integrates with dynamic and scheduled scaling

**Configuration Modes:**
- **Forecast Only:** ML analysis without automatic scaling
- **Forecast + Scale:** Automatic capacity adjustment

**Supported Metrics:**
- CPU utilization, network I/O, application load balancer requests
- Custom metrics possible

**Target Utilization:**
- Desired resource usage threshold (e.g., 50%)
- Controls scaling aggressiveness

**Buffer & Pre-Launch:**
- Extra capacity above forecast (e.g., 20% buffer)
- Instance pre-launch time for proactive deployment (up to 60 minutes)

**Practical Benefits:**
- Prevents reactive scaling delays
- Better cost control with precise capacity planning
- Improved application performance

### Configuration Parameters
- **Scaling Mode:** Forecast-only or forecast+auto-scale
- **Metric:** CPU utilization (most common)
- **Target Utilization:** Target performance level (50%, 60%, etc.)
- **Buffer:** Extra capacity percentage
- **Pre-Launch Delay:** Minutes before forecast time to launch instances

## 8.7 Auto Scaling -- Instance Maintenance Policy (Hands-On)

### Overview
Section 8.7 covers instance maintenance policies, which control how Auto Scaling Groups replace instances during updates.

### Key Concepts

**Instance Maintenance Policies:**
- Define instance replacement behavior during Updates
- Handle AMI upgrades, unhealthy instances, availability zone balancing

**Available Policies:**

**Terminate and Launch:**
- Terminates instances, then creates replacement instances
- Maintains exact capacity (cost-controlled)
- Example: Min 50% maintains half capacity during updates

**Launch Before Terminate:**
- Creates new instances before terminating old ones
- Ensures availability but increases costs temporarily
- Example: Min 100% maintains full capacity during updates

**Custom Behavior:**
- Full control over minimum/maximum capacity during maintenance
- Flexible configuration for large environments

**Instance Refresh Process:**
- Updates ASG with new Launch Template versions
- Uses maintenance policy for replacement strategy
- Supports warm-up periods for new instances

### Lab Demo
1. **Launch Template Updates:** Changed from Amazon Linux to Ubuntu
2. **Terminate and Launch:** Updated instances without exceeding original capacity
3. **Launch Before Terminate:** Maintained full availability with temporary capacity increase

### Key Benefits
- Automated instance modernization
- Minimized downtime based on policy choice
- Cost vs. availability trade-off control

## 8.8 Auto Scaling -- Default Termination Policy (Hands-On)

### Overview
Section 8.8 explains the default termination policy used when scaling in, focusing on cost optimization and balanced distribution.

### Key Concepts

**Termination Policy Purpose:**
- Determines which instances to terminate during scale-in
- Applies to all scaling methods (manual, scheduled, dynamic)

**Default Termination Policy Steps:**

1. **Balance Across Availability Zones:**
   - Maintains even distribution across AZs
   - Targets over-provisioned zones first

2. **Instance Protection Status:**
   - Skips protected instances (scal-in protection enabled)
   - Applies to user-configurable instance protection

3. **Oldest Launch Template:**
   - Prioritizes instances using older launch configurations
   - Aids in phased rollout of updates

4. **Closest to Next Billing Hour:**
   - Terminates instances closest to billing cycle end
   - Optimizes costs by minimizing wasted partial hours

5. **Random Selection (Tiebreaker):**
   - Randomly selects if all other criteria equal

**Instance Protection:**
- Manually protect specific instances from termination
- Configurable via ASG instance management
- Overrides all other termination criteria

### Practical Example
- **Distribution:** AZ A: 3 instances, AZ B: 2 instances, AZ C: 1 instance
- **Termination Priority:** Balances to AZ A → checks protection → old launch template → billing hour optimization

## 8.9 Auto Scaling -- Built-in Termination Policies (Hands-On)

### Overview
Section 8.9 covers AWS-provided termination policies that address specific use cases beyond the default.

### Key Concepts

**Built-in Termination Policies:**

**Allocation Strategy:**
- Used with mixed instance types (On-Demand + Spot)
- Terminates instances to maintain allocation strategy balance
- Preserves desired instance type distribution

**Oldest Launch Template/Configuration:**
- Terminates instances using oldest configurations
- Useful for gradual rollout of updates
- Phased migration from old to new configurations

**Closest to Next Instance Hour:**
- Terminates instances closest to billing cycle end
- Cost optimization for hourly-billed instances
- Particularly effective for Amazon Linux/Windows/Ubuntu

**Newest Instance:**
- Terminates most recently launched instances
- Useful for testing new configurations
- Allows rollback without affecting established instances

**Oldest Instance:**
- Terminates longest-running instances
- Useful for instance type upgrades
- Gradual replacement of old hardware

**Instance Type Requirements & Allocation:**
- Integration with mixed instance type policies
- On-demand/Spot allocation strategy enforcement
- Capacity optimized, price-capacity, lowest price options

### Application Considerations
- **Cost Optimization:** Closet to next instance hour policy
- **Instance Modernization:** Oldest Launch Template policy
- **Testing:** Newest Instance policy
- **Hardware Upgrades:** Oldest Instance policy
- **Mixed Fleet Management:** Allocation Strategy policy

## 8.10 Auto Scaling -- Custom Termination Policies (Hands-On)

### Overview
Section 8.10 covers custom termination policies using Lambda functions for advanced, programmable termination logic.

### Key Concepts

**Custom Termination Policy:**
- Total control over termination decisions
- Uses Lambda functions with custom logic
- Supports various programming languages (Go, Java, Node.js, Python)

**Five Key Reasons for Custom Policies:**

1. **Better Control:** Select specific instances based on custom criteria
2. **Instance Tags:** Terminate based on tagging strategies
3. **Advanced Metrics:** Use performance metrics beyond standard options
4. **Graceful Shutdown:** Implement proper application shutdown sequences
5. **Data Backup:** Perform pre-termination cleanup and backups

**Advanced Features:**
- **External System Integration:** Communicate with license managers, service discovery
- **Database Interaction:** Query external systems for termination decisions
- **Flexible Logic:** Update termination criteria as application evolves

**Lambda Function Capabilities:**
- Execute complex decision logic
- Integrate with external APIs and databases
- Initiate graceful shutdowns with custom commands
- Perform data backup and cleanup operations

### Implementation
- Create Lambda function with termination logic
- Configure ASG with custom termination policy
- Lambda receives termination candidates, returns preferred instance

### Use Cases
- Applications requiring specific shutdown sequences
- Systems with external dependencies (license management, service discovery)
- Complex termination criteria based on business rules

## 8.11 Auto Scaling -- Types Of Timers

### Overview
Section 8.11 explains three critical timers in Auto Scaling Groups: warm-up time, cooldown period, and health check grace period.

### Key Concepts

**Warm-up Time:**
- Time needed for new instances to initialize and serve requests
- Metrics are not counted toward group averages during warm-up
- Prevents premature scaling decisions on non-production instances
- Default: Optional (configured per dynamic policy)
- Configurations: Step scaling, target tracking policies

**Cooldown Period:**
- Wait time between scaling activities (scale-out/in)
- Allows system stabilization post-scaling
- Prevents excessive scaling actions
- Default: 300 seconds
- Prevents scaling thrashing from temporary spikes/dips

**Health check Grace Period:**
- Time before health checks begin on new instances
- Allows applications additional startup time beyond OS boot
- Prevents premature termination of initializing instances
- Default: 300 seconds
- Starts when instance enters "In Service" state

### Real-World Scenario Example
**Requirements:**
- CPU utilization target: 50%
- Scale out: >70%, Scale in: <30%

**Calculated Times:**
- **New instance launch:** 12:00 PM
- **Instance metrics counting:** Warm-up completion at 12:05 PM (warm-up: 5 min)
- **Next scaling allowed:** After cooldown at 12:15 PM (cooldown: 10 min)
- **Health check start:** At 12:03 PM (grace period: 3 min)

## 8.12 Difference Between AWS Auto Scaling Vs Elastic Load Balancer

### Overview
Section 8.12 clarifies the complementary roles of Auto Scaling Groups and Elastic Load Balancers in AWS architectures.

### Key Concepts

**Auto Scaling Group Responsibilities:**
- **Capacity Management:** Increases/decreases EC2 instances (scale-out/in)
- **Infrastructure Scaling:** Horizontal scaling to match demand
- **Instance Lifecycle:** Launches/terminates instances based on policies

**Elastic Load Balancer Responsibilities:**
- **Traffic Distribution:** Routes requests across multiple instances
- **Single Point of Contact:** Provides consistent endpoint for clients
- **Health Monitoring:** Identifies unhealthy instances, removes from rotation

**Complementary Relationship:**

```diff
! Client Request → Load Balancer → Route to Healthy Instances → Auto Scaled Instances
```

**Integration Points:**
- ELB distributes traffic to ASG-managed instances
- ASG adds instances when ELB detects high demand signals
- ASG removes instances during low demand periods
- Seamless coordination for dynamic scaling and load distribution

**Complete AWS Ecosystem:**
- **Auto Scaling:** Provides horizontal scaling capability
- **ELB:** Ensures even traffic distribution and availability
- **Combined:** Dynamic, resilient, cost-effective infrastructure

### Architectural Example
- Auto Scaling adds/removes EC2 instances based on CPU/network metrics
- ELB automatically routes traffic to available healthy instances
- New instances automatically registered with ELB
- Failed instances automatically removed from rotation

---

## Summary

### Key Takeaways
```diff
+ Auto Scaling enables horizontal scaling of EC2 instances across availability zones
+ Launch Templates standardize instance configurations for Auto Scaling Groups
+ Scaling options include manual, scheduled, dynamic, and predictive policies
+ Termination policies determine which instances to terminate during scale-in
+ Instance maintenance policies control replacement behavior during updates
+ Critical timers (warm-up, cooldown, health check grace period) optimize scaling behavior
+ Auto Scaling Groups work with Elastic Load Balancers for complete traffic management
```

### Quick Reference

**Auto Scaling Group Creation:**
```bash
# AWS Console: EC2 → Auto Scaling Groups → Create Auto Scaling Group
# Select Launch Template, configure VPC/subnets
# Set min/max/desired capacity
```

**Scaling Policies:**
- **Manual:** Set desired capacity directly
- **Scheduled:** Cron-based time-driven scaling
- **Dynamic:** Metrics-based reactive scaling
- **Predictive:** ML-based proactive scaling

**Termination Policies:**
- **Default:** Balance → Protection → Old template → Billing hour
- **Custom:** Lambda function for advanced logic
- **Built-in:** Oldest instance, newest instance, etc.

### Expert Insight

**Real-world Application:** Auto Scaling is essential for applications with variable traffic patterns like e-commerce platforms, streaming services, and SaaS applications where demand fluctuates based on user behavior, seasonal events, or marketing campaigns.

**Expert Path:**
1. Start with scheduled scaling for predictable patterns
2. Implement dynamic scaling for reactive capacity management
3. Enable predictive scaling once you have 3+ weeks of metrics
4. Use custom termination policies for applications requiring graceful shutdowns
5. Combine with ELB for complete load balancing and scaling solution

**Common Pitfalls:**
- ❌ Setting instance warm-up times too short causes premature scaling decisions
- ❌ Not enabling instance protection on production-critical servers
- ❌ Using vertical scaling when horizontal scaling provides unlimited scalability
- ❌ Ignoring cooldown periods leading to scaling thrashing
- ❌ Not testing maintenance policies before production deployments

</details>
