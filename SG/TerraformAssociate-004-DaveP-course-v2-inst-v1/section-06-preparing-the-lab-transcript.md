# Section 6: Terraform with Cloud-Init and Viewing Resources

<details open>
<summary><b>Section 6: Terraform with Cloud-Init and Viewing Resources (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents

- [6.1 Preparing the Lab](#61-preparing-the-lab)
- [6.2 Analyzing the Cloud-Init Script](#62-analyzing-the-cloud-init-script)
- [6.3 Terraforming the Infrastructure](#63-terraforming-the-infrastructure)
- [6.4 Logging In to the Instance and Verifying the Website](#64-logging-in-to-the-instance-and-verifying-the-website)
- [6.5 Viewing Resources with Terraform Commands](#65-viewing-resources-with-terraform-commands)
- [6.7 Destroying the Infrastructure](#67-destroying-the-infrastructure)
- [6.8 Quiz](#68-quiz)
- [Summary](#summary)

---

## 6.1 Preparing the Lab

**Overview**: This module sets up the lab environment for Section 6, building on previous labs by preparing a project structure that will use cloud-init to automatically configure an Apache web server with a documentation site.

### Project Structure Setup

The lab workspace is pre-configured with the following structure:

```
Lab 06/
├── instances/
│   ├── main.tf
│   ├── outputs.tf
│   ├── provider.tf
│   └── version.tf
├── keys/              # Directory for SSH keys
├── scripts/           # Directory for cloud-init scripts
└── solution/          # Reference solution files
```

### Instance Configuration

The `main.tf` file creates an Ubuntu EC2 instance named "Lab 06" with configurations similar to previous labs:

- **Instance**: Ubuntu-based EC2 instance
- **Key Pair**: Deployer key pair for SSH access
- **Security Groups**: SSH, TLS, HTTP, and egress rules
- **Naming**: Tagged as "lab-06-cloud-init"

### SSH Key Generation

1. **Create keys directory**:
   ```bash
   mkdir keys
   ```

2. **Generate new SSH key pair**:
   ```bash
   ssh-keygen -t rsa -b 4096 -f keys/awskey -N ""
   ```

3. **Update main.tf with public key**:
   ```hcl
   resource "aws_key_pair" "deployer" {
     key_name   = "deployer-key"
     public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC..." # Insert your public key here
   }
   ```

> [!IMPORTANT]
> Never share or expose private keys. Only use public keys in Terraform configurations.

### Security Groups

The configuration includes the same security groups from previous labs:
- SSH access (port 22)
- TLS/HTTPS (port 443)
- HTTP (port 80)
- Egress rules for outbound traffic

### Preparation Checklist

✅ Create `scripts` directory
✅ Generate SSH key pair in `keys` directory
✅ Update public key in `main.tf`
✅ Verify all files are present
✅ Ready for cloud-init script integration

---

## 6.2 Analyzing the Cloud-Init Script

**Overview**: This module examines the cloud-init (cloud-config) script that automates the installation and configuration of an Apache web server with a Make Docs documentation site.

### Understanding Cloud-Init

Cloud-init is a Linux-based initialization system that automates server setup during instance boot. It works particularly well with Ubuntu and Debian distributions.

### Script Components

#### User and Group Creation

```yaml
#cloud-config
groups:
  - ubuntu
  - dpro42group

users:
  - name: spiderman
    shell: /bin/bash
    primary_group: dpro42group
    groups: sudo, users, admin
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC...
```

#### Automated Commands

The `run_cmd` section executes commands sequentially:

1. **Create welcome file**:
   ```bash
   touch /home/spiderman/hello.txt
   echo "Hello and welcome to this server. Destroy me when you're done." > /home/spiderman/hello.txt
   ```

2. **Update package lists**:
   ```bash
   apt-get update
   ```

3. **Install Apache web server**:
   ```bash
   apt-get install -y apache2
   ```

4. **Install Make Docs**:
   ```bash
   apt-get install -y makedocs
   mkdir -p /home/spiderman/makedocs
   cd /home/spiderman/makedocs
   makedocs new myproject
   cd myproject
   makedocs build
   ```

5. **Configure Apache**:
   ```bash
   rm /var/www/html/index.html
   cp -r /home/spiderman/makedocs/myproject/site/* /var/www/html/
   systemctl restart apache2
   ```

### Integration with Terraform

Add the cloud-init script to your instance configuration:

```hcl
resource "aws_instance" "lab06" {
  # ... other configuration ...

  user_data = file("../scripts/apache-makedocs.yaml")

  tags = {
    Name = "lab-06-cloud-init"
  }
}
```

> [!NOTE]
> The `file()` function reads the cloud-init script and passes it as user data to the instance.

### Best Practices

💡 **Always review scripts** before execution to understand what they install and configure
💡 **Use YAML format** for cloud-init scripts (`.yaml` or `.yml`)
💡 **Include SSH keys** in the cloud-init script for the specified user
💡 **Verify file paths** are exact when referencing scripts in Terraform

---

## 6.3 Terraforming the Infrastructure

**Overview**: This module walks through the Terraform workflow to initialize, validate, and apply the infrastructure configuration for Lab 6.

### Terraform Workflow

#### Step 1: Format Configuration Files

```bash
terraform fmt
```

- Automatically formats all `.tf` files
- Aligns arguments and improves readability
- Fixes formatting inconsistencies

#### Step 2: Initialize Working Directory

```bash
terraform init
```

- Downloads the AWS provider plugin
- Creates `.terraform/` directory
- Generates `.terraform.lock.hcl` file
- Prepares the working directory for infrastructure management

#### Step 3: Validate Configuration

```bash
terraform validate
```

- Checks syntax and configuration validity
- Recommended for complex configurations
- Identifies errors before applying changes

#### Step 4: Apply Infrastructure

```bash
terraform apply
```

**Resources Created** (9 total):
1. `aws_instance.lab06` - Ubuntu EC2 instance
2. `aws_key_pair.deployer` - SSH key pair
3. `aws_security_group.ssh` - SSH security group
4. `aws_security_group.tls` - TLS security group
5. `aws_security_group.http` - HTTP security group
6. `aws_security_group.egress` - Egress rules
7. Plus security group rules

**Outputs**:
- Public DNS name
- Public IP address

> [!IMPORTANT]
> In production, always review with `terraform plan` before applying changes.

### AWS Console Verification

After applying:
1. Navigate to EC2 instances
2. Verify instance status shows "2/2 checks passed"
3. Confirm security groups are attached
4. Note the instance name from tags

---

## 6.4 Logging In to the Instance and Verifying the Website

**Overview**: This module demonstrates connecting to the newly created instance and verifying the cloud-init automation worked correctly.

### SSH Connection

Connect using the custom user created by cloud-init:

```bash
ssh -i "../keys/awskey" spiderman@<public-ip-address>
```

> [!NOTE]
> Use `spiderman` as the username (not `ubuntu`) as configured in the cloud-init script.

### Verification Steps

#### 1. Check Created Files

```bash
ls -la
```

Expected files:
- `hello.txt` - Welcome message
- `makedocs/` - Documentation project directory

#### 2. Verify Hello File Contents

```bash
cat hello.txt
```

Output: "Hello and welcome to this server. Destroy me when you're done."

#### 3. Check Apache Service Status

```bash
systemctl status apache2
```

Expected output:
- Service is `active (running)`
- Enabled to start on boot

#### 4. Inspect Web Server Files

```bash
cd /var/www/html
ls -la
```

Should show Make Docs generated files instead of the default Apache index.

### Accessing the Website

1. Obtain the public IP:
   ```bash
   terraform output public_ip
   ```

2. Open browser and navigate to:
   ```
   http://<public-ip-address>
   ```

3. Expected result: "Welcome to Make Docs" documentation site

### Understanding the Automation

The cloud-init script performed these tasks automatically:
1. ✅ Created user `spiderman` with sudo privileges
2. ✅ Installed Apache web server
3. ✅ Installed Make Docs documentation tool
4. ✅ Created and built a Make Docs project
5. ✅ Configured Apache to serve the documentation site
6. ✅ Started and enabled the Apache service

> [!IMPORTANT]
> Cloud-init runs only once during instance initialization. Changes require instance recreation.

---

## 6.5 Viewing Resources with Terraform Commands

**Overview**: This module covers essential Terraform commands for inspecting deployed resources and managing state, including exam-critical information.

### Core Inspection Commands

#### Terraform State List

```bash
terraform state list
```

**Purpose**: Displays a brief list of all managed resources
**Output**: Resource addresses only (machine-readable format for filtering)

Example output:
```
aws_instance.lab06
aws_key_pair.deployer
aws_security_group.ssh
aws_security_group.tls
aws_security_group.http
...
```

#### Terraform Show

```bash
terraform show
```

**Purpose**: Shows all resources with human-readable details
**Output**: Complete configuration of all resources in formatted text

- More readable than raw state file
- Includes all attributes and values
- Useful for comprehensive review

#### Terraform State Show

```bash
terraform state show <resource_address>
```

**Purpose**: Displays details for a specific resource
**Best Practice**: Combine with `terraform state list` for resource discovery

Example:
```bash
terraform state show aws_key_pair.deployer
```

### Advanced Filtering Techniques

#### Using Grep for Specific Information

```bash
terraform state show aws_instance.lab06 | grep public_ip
```

#### Multiple Pattern Search

```bash
terraform state show aws_instance.lab06 | grep -E 'public_ip|public_dns'
```

### State Management Commands

#### Removing Resources from State

```bash
terraform state rm <resource_address>
```

**Use Cases**:
- Sync state with manual cloud changes
- Fix drift between state and actual infrastructure
- Remove orphaned resources

> [!WARNING]
> Removing a resource from state does not destroy the actual resource in the cloud.

### Exam Alert: Key Commands

📝 **Memorize these three commands**:
1. `terraform state list` - Brief list of resources
2. `terraform show` - Full human-readable details
3. `terraform state show` - Specific resource details

### Best Practices for State Management

⚠️ **Policy Recommendation**: Never modify infrastructure directly in the AWS console when using Terraform

✅ **Correct Approach** for removing resources:
1. Edit `main.tf` to remove or comment out the resource
2. Run `terraform apply` to make the change
3. State and cloud remain synchronized

❌ **Avoid**:
- Manual console modifications
- Direct state file editing
- Using console alongside Terraform for the same resources

---

## 6.7 Destroying the Infrastructure

**Overview**: This module demonstrates infrastructure destruction using Terraform plans, providing a safer approach to cleanup.

### Using Destroy Plans

#### Create a Destroy Plan

```bash
terraform plan -destroy -out=destroy-plan
```

**Benefits**:
- Preview all resources to be destroyed
- Save plan for later execution
- Review before confirming destruction
- Share with team members for approval

#### Apply Destroy Plan

```bash
terraform apply destroy-plan
```

**Advantages**:
- No interactive confirmation required
- Uses pre-approved plan
- Ensures exact resources from plan are destroyed
- More controlled than direct destroy command

### Destruction Workflow

1. **Generate plan**:
   ```bash
   terraform plan -destroy -out=destroy-plan
   ```

2. **Review the plan** (optional):
   - Check all 9 resources marked for destruction
   - Verify no unintended deletions

3. **Execute destruction**:
   ```bash
   terraform apply destroy-plan
   ```

4. **Verify cleanup**:
   ```bash
   terraform state list  # Should show no resources
   ```

### State File After Destruction

After successful destruction:
- State file shows `null` check results
- No resources remain in state
- Safe to delete working directory if needed

> [!IMPORTANT]
> Always verify infrastructure is destroyed in the AWS console to avoid unexpected charges.

### Best Practices

💡 Plan files can be used for:
- Creation plans: `terraform plan -out=build-plan`
- Modification plans: `terraform plan -out=modify-plan`
- Destruction plans: `terraform plan -destroy -out=destroy-plan`

⚠️ Destroy plans are less common than creation plans but useful for controlled cleanup.

---

## 6.8 Quiz

**Overview**: This section tests understanding of resource replacement and state inspection commands.

### Question 1: Resource Replacement

**Question**: You need to remove a particular instance and put another one in its place. What is the best way to do this?

**Options**:
- A) Terraform Taint
- B) Terraform Show
- C) Terraform Apply Replace
- D) Terraform Destroy Create

**Correct Answer**: C) Terraform Apply Replace

**Explanation**:
- ✅ **Terraform Apply Replace**: Replaces only the specified resource
- ❌ **Terraform Taint**: Deprecated command (removed in v1.6+)
- ❌ **Terraform Show**: Only displays resource information
- ❌ **Terraform Destroy Create**: Not a valid command combination

> [!NOTE]
> For Terraform v1.6 and higher, always use `terraform apply -replace=<resource>` instead of taint commands.

### Question 2: Resource Listing

**Question**: You want to display a brief list of resources that have been deployed with Terraform. Which command should you issue?

**Options**:
- A) Terraform State List
- B) Terraform Show
- C) Terraform State Show
- D) Cat terraform.tfstate

**Correct Answer**: A) Terraform State List

**Explanation**:
- ✅ **Terraform State List**: Provides brief list of resource addresses
- ❌ **Terraform Show**: Full details, not brief
- ❌ **Terraform State Show**: Shows single resource details
- ❌ **Cat terraform.tfstate**: Displays raw JSON state file (machine-readable, not brief)

---

## Summary

### Key Takeaways

```diff
+ Cloud-init automates instance configuration during boot
+ User data in Terraform references cloud-init scripts via file() function
+ Always use spiderman user (or custom user) when defined in cloud-init
+ terraform state list shows resource addresses
+ terraform show displays all resources in human-readable format
+ terraform state show <resource> provides specific resource details
+ Use terraform apply -replace for resource recreation (v1.6+)
+ terraform plan -destroy -out=plan creates reusable destroy plans
```

### Quick Reference

| Command | Purpose |
|---------|---------|
| `terraform fmt` | Format configuration files |
| `terraform init` | Initialize working directory |
| `terraform validate` | Validate configuration |
| `terraform plan` | Preview changes |
| `terraform apply` | Apply changes |
| `terraform state list` | List all resources |
| `terraform show` | Show all resource details |
| `terraform state show <resource>` | Show specific resource |
| `terraform state rm <resource>` | Remove from state |
| `terraform plan -destroy` | Plan destruction |
| `terraform apply -replace=<resource>` | Replace specific resource |

### Expert Insight

#### Real-world Application

Cloud-init with Terraform is essential for:
- **Auto-scaling groups**: Ensuring consistent configuration across instances
- **Immutable infrastructure**: Building identical environments repeatedly
- **Documentation sites**: Automated deployment of static documentation
- **Development environments**: Quick spin-up of configured instances

#### Expert Path

1. Master cloud-init directives beyond basic user data
2. Explore user_data vs user_data_base64 encoding
3. Learn about cloud-init logging and debugging
4. Understand state management in team environments
5. Practice with remote state backends

#### Common Pitfalls

❌ Forgetting to include SSH keys in cloud-init scripts
❌ Using wrong username when connecting via SSH
❌ Not verifying cloud-init execution with `cloud-init status`
❌ Modifying state files directly instead of using commands
❌ Running manual commands on Terraform-managed resources

#### Lesser-Known Facts

💡 Cloud-init runs scripts in specific phases (init, config, final)
💡 You can check cloud-init logs at `/var/log/cloud-init-output.log`
💡 The `file()` function in Terraform reads files at plan/apply time
💡 State files can be filtered using Terraform's `-state` flag
💡 Destroy plans help with compliance requirements for change documentation

</details>