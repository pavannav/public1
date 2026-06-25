# Section 16: Terraform and Beyond

<details open>
<summary><b>Section 16: Terraform and Beyond (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents

- [16.1 Using Vault with Terraform CLI](#161-using-vault-with-terraform-cli)
- [16.2 Using HCP Vault with Terraform Cloud - Part 1](#162-using-hcp-vault-with-terraform-cloud---part-1)
- [16.3 Using HCP Vault with Terraform Cloud - Part 2](#163-using-hcp-vault-with-terraform-cloud---part-2)
- [16.4 Terraform Stacks](#164-terraform-stacks)
- [16.5 Advanced AWS Usage with Terraform - Part 1](#165-advanced-aws-usage-with-terraform---part-1)
- [16.6 Advanced AWS Usage with Terraform - Part 2](#166-advanced-aws-usage-with-terraform---part-2)
- [16.7 Terraform Provider Caching](#167-terraform-provider-caching)
- [16.8 Using Consul with Terraform](#168-using-consul-with-terraform)
- [16.9 Using AI Tools with Terraform - Part 1](#169-using-ai-tools-with-terraform---part-1)
- [16.10 Using AI Tools with Terraform - Part 2](#1610-using-ai-tools-with-terraform---part-2)
- [16.11 Quiz](#1611-quiz)
- [Summary Section](#summary-section)

---

## 16.1 Using Vault with Terraform CLI

### Overview
This lab demonstrates how to integrate HashiCorp Vault with Terraform CLI to securely manage and retrieve secrets. Vault is a secrets management tool used to securely store, control, and manage access to sensitive data.

### Key Concepts/Deep Dive

#### Vault Installation and Setup
- **Installation**: Use system package managers (e.g., `sudo apt install vault`)
- **Development Mode**: Start Vault with `vault server -dev -dev-root-token-id=root` for testing purposes
- **Dev Mode Characteristics**:
  - Runs entirely in memory
  - Unsealed with a single unseal key
  - Not suitable for production use
  - Designed for testing and educational purposes

#### Vault Environment Configuration
```bash
# Set Vault address
export VAULT_ADDR='http://127.0.0.1:8200'

# Check vault status
vault status

# Login with root token
vault login root
```

#### Creating and Managing Secrets
```bash
# Create secrets using KV (Key-Value) engine
vault kv put secret/db_creds username=admin password=super_secret
vault kv put secret/api-keys api_key=12345abcdef api_secret=secret_token_xyz

# Read secrets
vault kv get secret/db_creds
vault kv get secret/api-keys
```

#### Terraform Configuration for Vault Integration

**Provider Configuration (provider.tf)**
```hcl
terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
    }
    local = {
      source = "hashicorp/local"
    }
  }
}

provider "vault" {
  address = "http://127.0.0.1:8200"
  token   = "root"
}
```

**Main Configuration (main.tf)**
```hcl
# Data sources to read secrets from Vault
data "vault_generic_secret" "db_creds" {
  path = "secret/db_creds"
}

data "vault_generic_secret" "api_keys" {
  path = "secret/api-keys"
}

# Create local file using retrieved secrets
resource "local_file" "app_config" {
  filename = "app_config.txt"
  content  = <<-EOT
    Database Configuration:
    Username = ${data.vault_generic_secret.db_creds.data["username"]}

    API Configuration:
    API Key = ${data.vault_generic_secret.api_keys.data["api_key"]}
  EOT
}
```

**Outputs Configuration (outputs.tf)**
```hcl
output "db_username" {
  value     = data.vault_generic_secret.db_creds.data["username"]
  sensitive = true
}

output "api_key" {
  value     = data.vault_generic_secret.api_keys.data["api_key"]
  sensitive = true
}

output "secrets_retrieved" {
  value = "Successfully retrieved secrets from Vault"
}
```

### Lab Steps
1. Install Vault and start in dev mode
2. Configure environment variables and authenticate
3. Create sample secrets in Vault
4. Configure Terraform to use Vault provider
5. Create data sources to read secrets
6. Generate local files using retrieved secrets
7. Verify outputs and clean up

### Commands Summary
```bash
# Terraform operations
terraform init
terraform apply -auto-approve
terraform output api_key  # View sensitive output individually
terraform destroy -auto-approve

# Vault operations
vault server -dev -dev-root-token-id=root
vault status
vault login root
vault kv put secret/path key=value
vault kv get secret/path
```

---

## 16.2 Using HCP Vault with Terraform Cloud - Part 1

### Overview
This comprehensive lab demonstrates using HCP (HashiCorp Cloud Platform) Vault with Terraform Cloud to securely store AWS credentials and provision infrastructure. This represents the most secure approach for managing cloud credentials in Terraform workflows.

### Key Concepts/Deep Dive

#### HCP Vault Cluster Setup
- **Development Mode**: Most cost-effective option for testing
- **Cluster Specifications**: Extra Small (2 CPUs, 1GB RAM)
- **Cost Consideration**: $0.61/hour for development cluster
- **Trial Credits**: New accounts receive $500 in trial credits

#### Secrets Engine Configuration
1. **Enable KV Secrets Engine**:
   - Navigate to Secrets Engines → Enable new engine
   - Select KV (Key-Value) engine
   - Path: `kv` (indicates version 2 engine)

2. **Store AWS Credentials**:
   ```text
   Path: aws
   Keys:
   - access_key (AWS access key ID)
   - secret_key (AWS secret access key)
   ```

#### Terraform Cloud Workspace Setup
**Required Variables**:
```hcl
# Terraform variables (not environment variables)
vault_address  = "https://[cluster-url]"
vault_token    = "[admin-token]"  # Must be marked sensitive
vault_namespace = "admin"
```

#### Important Security Notes
- All data in Vault is implicitly sensitive
- No need to mark individual secrets as sensitive
- Credentials are encrypted at rest with AES-256
- Vault uses Shamir sealing for additional security

### Lab Steps - Part 1
1. Create HCP account and HCP Vault cluster
2. Configure KV secrets engine
3. Store AWS credentials in HCP Vault
4. Create Terraform Cloud workspace
5. Configure workspace variables for Vault connection

---

## 16.3 Using HCP Vault with Terraform Cloud - Part 2

### Overview
Continuation of the HCP Vault lab focusing on Terraform configuration, deployment, and cleanup procedures.

### Key Concepts/Deep Dive

#### Terraform Configuration Structure

**main.tf Configuration**:
```hcl
terraform {
  cloud {
    organization = "your-org"
    workspaces {
      name = "hcp-vault-demo"
    }
  }

  required_providers {
    aws   = { source = "hashicorp/aws" }
    vault = { source = "hashicorp/vault" }
  }
}

provider "vault" {
  address   = var.vault_address
  token     = var.vault_token
  namespace = var.vault_namespace
}

# Data source to retrieve AWS credentials from Vault
data "vault_kv_secret_v2" "aws_creds" {
  mount = "kv"
  name  = "aws"
}

provider "aws" {
  region     = "us-east-2"
  access_key = data.vault_kv_secret_v2.aws_creds.data["access_key"]
  secret_key = data.vault_kv_secret_v2.aws_creds.data["secret_key"]
}

resource "aws_instance" "example" {
  ami           = "ami-debian13-latest"
  instance_type = "t2.micro"
  # ... instance configuration
}
```

#### State File Security Considerations
- AWS credentials appear in Terraform state file
- State files are encrypted at rest in HCP Terraform
- Multiple security layers: Vault encryption + HCP encryption
- Consider using ephemeral credentials or avoiding state storage of secrets

#### Deployment Workflow
1. `terraform login` - Authenticate with Terraform Cloud
2. `terraform init` - Download providers
3. `terraform validate` - Validate configuration
4. `terraform plan` - Review planned changes
5. `terraform apply` - Execute deployment (remote execution)

#### Cleanup Procedures
1. Delete secrets from Vault KV engine
2. Delete Vault cluster (critical to avoid ongoing charges)
3. Delete Terraform Cloud workspace (optional)
4. Verify all resources terminated in AWS

### Lab Steps - Part 2
1. Configure Terraform files for Vault integration
2. Initialize and validate configuration
3. Execute remote plan and apply
4. Verify instance creation in AWS
5. Review state files and outputs
6. Complete cleanup of all resources

---

## 16.4 Terraform Stacks

### Overview
Terraform Stacks enable deploying the same infrastructure across multiple environments (development, production, etc.) using modules through HCP Terraform. This represents an advanced pattern for managing multi-environment deployments.

### Key Concepts/Deep Dive

#### Stack File Structure
Unlike traditional Terraform, stacks use HCL files:
- `stack.tfcomponent.hcl` - Component definitions
- `deployments.tfdeploy.hcl` - Environment deployments
- `terraform.tfstack.hcl` - Terraform version requirements

#### Component Configuration (stack.tfcomponent.hcl)
```hcl
required_providers {
  aws = {
    source  = "hashicorp/aws"
    version = "~> 5.0"
  }
}

variable "region" {
  type    = string
  default = "us-east-2"
}

variable "access_key" {
  type      = string
  sensitive = true
  ephemeral = true
}

variable "secret_key" {
  type      = string
  sensitive = true
  ephemeral = true
}

component "iam_users" {
  source = "terraform-aws-modules/iam/aws//modules/iam-user"

  providers = {
    aws = provider.aws.this
  }

  inputs = {
    usernames = var.usernames
    environment = var.environment
  }

  outputs = {
    user_arns = iam_user.users[*].arn
  }
}
```

#### Deployment Configuration (deployments.tfdeploy.hcl)
```hcl
store "varset" "aws_creds" {
  name     = "AWS Credentials"
  category = "env"
}

deployment "development" {
  inputs = {
    region      = "us-east-2"
    environment = "dev"
    usernames   = ["alice", "bob"]
    access_key  = store.varset.aws_creds.env.AWS_ACCESS_KEY_ID
    secret_key  = store.varset.aws_creds.env.AWS_SECRET_ACCESS_KEY
  }
}

deployment "production" {
  inputs = {
    region      = "us-east-2"
    environment = "prod"
    usernames   = ["alice", "bob", "charlie"]
    access_key  = store.varset.aws_creds.env.AWS_ACCESS_KEY_ID
    secret_key  = store.varset.aws_creds.env.AWS_SECRET_ACCESS_KEY
  }
}
```

#### Stack Commands
```bash
# Initialize stack
terraform stacks init

# Create stack in HCP Terraform
terraform stack create \
  --organization-name your-org \
  --project-name "lab-22-stacks" \
  --stack-name "lab-22-stacks"

# Upload configuration
terraform stack configuration upload \
  --organization-name your-org \
  --project-name "lab-22-stacks" \
  --stack-name "lab-22-stacks"

# Delete stack when done
terraform stack delete --stack-name "lab-22-stacks"
```

#### Variable Sets
- Create project-wide variable sets in HCP Terraform
- Support environment variables for AWS credentials
- Must be marked as sensitive
- Apply to entire project for stack access

#### Deployment Workflow
1. Stacks create automatically from CLI
2. Deployments require manual approval (or auto-apply)
3. Each deployment runs independently
4. Green checkmarks indicate successful deployments
5. Red X indicates configuration or approval issues

#### Destruction Pattern
- No explicit destroy command in stacks
- Modify deployments file to uncomment `destroy = true`
- Re-upload configuration to trigger destroy plans
- Delete stack and project when complete

### Lab Steps
1. Create HCP Terraform project for stacks
2. Configure component and deployment files
3. Set up AWS credentials variable set
4. Initialize and create stack via CLI
5. Upload configuration and approve deployments
6. Verify IAM users created in AWS
7. Destroy infrastructure using destroy pattern
8. Clean up stack and project

---

## 16.5 Advanced AWS Usage with Terraform - Part 1

### Overview
This lab demonstrates advanced AWS concepts including EC2 instance management, Elastic IPs, dynamic security group rules, IAM policies, S3 logging buckets, and CloudWatch monitoring - representing real-world production scenarios.

### Key Concepts/Deep Dive

#### Advanced Variable Configuration
```hcl
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "instance_state" {
  description = "Desired instance state"
  type        = string
  default     = "running"

  validation {
    condition     = contains(["running", "stopped"], var.instance_state)
    error_message = "Instance state must be running or stopped."
  }
}

variable "ingress_rules" {
  description = "Dynamic ingress rules"
  type = map(object({
    from_port = number
    to_port   = number
  }))
  default = {
    ssh   = { from_port = 22, to_port = 22 }
    http  = { from_port = 80, to_port = 80 }
    https = { from_port = 443, to_port = 443 }
  }
}
```

#### Data Sources
```hcl
# Latest Amazon Linux AMI
data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Default VPC
data "aws_vpc" "default" {
  default = true
}

# Current AWS account ID
data "aws_caller_identity" "current" {}
```

#### Dynamic Security Groups
```hcl
resource "aws_security_group" "web_server" {
  name        = "${var.environment}-web-server-sg"
  description = "Security group for web server"
  vpc_id      = data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-web-server-sg"
    Environment = var.environment
  }
}
```

#### EC2 Instance with User Data and Lifecycle
```hcl
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.web_server.id]
  monitoring             = var.enable_monitoring

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "Hello from ${var.environment} Environment" > /var/www/html/index.html
    echo "Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)" >> /var/www/html/index.html
  EOF

  lifecycle {
    ignore_changes = [user_data]
  }

  tags = {
    Name        = "${var.environment}-web-server"
    Environment = var.environment
  }
}
```

#### Instance State Management (Provisioner Pattern)
```hcl
resource "null_resource" "instance_state" {
  triggers = {
    instance_state = var.instance_state
    instance_id    = aws_instance.web_server.id
  }

  provisioner "local-exec" {
    command = var.instance_state == "stopped" ?
      "aws ec2 stop-instances --instance-ids ${aws_instance.web_server.id}" :
      "aws ec2 start-instances --instance-ids ${aws_instance.web_server.id}"
  }
}
```

#### Elastic IP Configuration
```hcl
resource "aws_eip" "web_server" {
  domain = "vpc"
  tags = {
    Name        = "${var.environment}-web-server-eip"
    Environment = var.environment
  }
}

resource "aws_eip_association" "web_server" {
  instance_id   = aws_instance.web_server.id
  allocation_id = aws_eip.web_server.id

  count = var.instance_state == "running" ? 1 : 0
}
```

#### IAM Users with Foreach
```hcl
resource "aws_iam_user" "users" {
  for_each = toset(var.iam_users)

  name = "${var.environment}-${each.value}"
  path = "/app-users/"

  tags = {
    Environment = var.environment
    CreatedBy   = "Terraform"
  }
}

resource "aws_iam_policy" "s3_access" {
  name = "${var.environment}-s3-access-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.logs.arn,
          "${aws_s3_bucket.logs.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "users" {
  for_each = aws_iam_user.users

  user       = each.value.name
  policy_arn = aws_iam_policy.s3_access.arn
}
```

### Part 1 Configuration Summary
- Variables with validation rules
- Multiple data sources for external data
- Dynamic blocks for flexible security rules
- Lifecycle management and provisioners
- Complex resource dependencies

---

## 16.6 Advanced AWS Usage with Terraform - Part 2

### Overview
Continuation focusing on S3 logging configuration, CloudWatch monitoring, Terraform execution, and advanced operational patterns.

### Key Concepts/Deep Dive

#### S3 Bucket with Lifecycle Management
```hcl
resource "aws_s3_bucket" "logs" {
  bucket = "${var.environment}-web-server-logs"

  tags = {
    Environment = var.environment
    Purpose     = "Access Logs"
  }
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket = aws_s3_bucket.logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "logs" {
  bucket = aws_s3_bucket.logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    id     = "delete_old_logs"
    status = "Enabled"

    expiration {
      days = 90
    }
  }
}
```

#### CloudWatch Monitoring
```hcl
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.environment}-web-server-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = []  # Add SNS topic ARN for notifications

  dimensions = {
    InstanceId = aws_instance.web_server.id
  }

  tags = {
    Environment = var.environment
  }
}
```

#### Dynamic Configuration Updates
```hcl
# terraform.tfvars example
aws_region      = "us-east-2"
environment     = "dev"
instance_state  = "running"
instance_type   = "t3.micro"
enable_monitoring = true

iam_users = [
  "app-deployer",
  "log-reader",
  "backup-operator"  # Added dynamically
]

ingress_rules = {
  dns      = { from_port = 53, to_port = 53 }
  pop3     = { from_port = 110, to_port = 110 }
  web_alt  = { from_port = 8080, to_port = 8080 }
}
```

#### Terraform Execution Patterns
```bash
# Variable file creation
cp terraform.tfvars.example terraform.tfvars

# Standard workflow
terraform init
terraform plan
terraform apply

# State management
terraform output web_url
terraform refresh
terraform state list

# Dynamic updates demonstrated:
# - Instance state changes (running ↔ stopped)
# - IAM user additions via foreach
# - Security group rule modifications
```

#### Key Operational Insights
1. **Instance State Management**: Uses null_resource with provisioners for start/stop
2. **Dynamic Foreach**: IAM users and security rules adapt to variable changes
3. **State File Accuracy**: `terraform apply -refresh-only` updates outputs without changes
4. **Resource Dependencies**: Users depend on instance; associations depend on state
5. **Cleanup Verification**: Always verify 17+ resources destroyed

#### EKS Additional Information
- EKS (Elastic Kubernetes Service) available in extra labs
- Managed Kubernetes service eliminating control plane management
- High availability across multiple availability zones
- Significant time and cost considerations for lab exercises

### Part 2 Lab Steps
1. Create terraform.tfvars with custom configuration
2. Initialize and plan infrastructure deployment
3. Apply configuration and verify all resources
4. Test web server accessibility via curl
5. Demonstrate instance state management
6. Show dynamic IAM user creation
7. Modify security group rules dynamically
8. Complete destruction with verification
9. Review EKS lab option for advanced Kubernetes deployment

---

## 16.7 Terraform Provider Caching

### Overview
This lab addresses the challenge of managing provider plugin downloads by implementing a caching mechanism to reduce bandwidth usage and storage requirements across multiple Terraform working directories.

### Key Concepts/Deep Dive

#### The Provider Plugin Problem
- Default behavior: Downloads plugins to each working directory
- AWS provider plugin: >500MB in size
- Multiple directories multiply storage requirements
- Significant Internet bandwidth consumption
- VM storage limitations (e.g., 30GB VMs)

#### Terraform RC Configuration
**Location**: `~/.terraformrc` (user home directory)

```hcl
plugin_cache_dir = "$HOME/.terraform.d/plugin-cache"
disable_checkpoint = true
```

#### Plugin Cache Directory Structure
```
~/.terraform.d/
├── checkpoint
├── credentials.tfrc.json
├── plugin-cache/
│   └── registry.terraform.io/
│       └── hashicorp/
│           └── aws/
│               └── 6.30.0/
│                   └── linux_amd64/
│                       └── terraform-provider-aws_v6.30.0
└── stacks-plugin/
```

#### Implementation Steps
1. Create terraformrc file in home directory
2. Configure plugin_cache_dir path
3. Create the cache directory structure
4. Verify symbolic links in working directories
5. Test across multiple projects

#### Verification Commands
```bash
# Check cache directory contents
tree ~/.terraform.d/plugin-cache

# Verify symbolic link in working directory
ls -la .terraform/providers/

# Initialize and observe caching behavior
terraform init
```

#### Important Considerations and Limitations

**Advantages**:
- Reduced Internet bandwidth usage
- Shared plugins across projects
- Faster initialization for cached versions

**Limitations**:
- **Concurrency Issues**: Multiple simultaneous Terraform runs may conflict
- **Manual Cleanup Required**: Unused/old providers not automatically removed
- **CICD Pipeline Challenges**: May not work optimally in automated pipelines
- **Version Constraints**: Greater than/tilde constraints always fetch newer versions
- **Dependency Lock File Critical**: `.terraform.lock.hcl` hashes remain essential

#### Alternative Approaches
1. **Terraform Providers Lock**: Store providers on file servers
2. **Plugin Mirrors**: Network-based provider distribution
3. **Version Pinning**: Exact version specifications for consistent caching

#### Configuration Management
```bash
# Disable caching (comment out or remove)
# plugin_cache_dir = "$HOME/.terraform.d/plugin-cache"

# Clean up cache when disabling
rm -rf ~/.terraform.d/plugin-cache
```

### Lab Steps
1. Identify storage/bandwidth issues with current setup
2. Create and configure ~/.terraformrc file
3. Establish plugin cache directory structure
4. Initialize Terraform project and verify caching
5. Demonstrate symbolic link behavior
6. Test across multiple working directories
7. Document limitations and considerations
8. Clean up configuration when complete

---

## 16.8 Using Consul with Terraform

### Overview
This lab introduces HashiCorp Consul integration with Terraform, demonstrating service networking capabilities through a simple key-value store implementation using Docker containers.

### Key Concepts/Deep Dive

#### Consul Capabilities Overview
- **Service Discovery**: Automatic service location and connection
- **Health Checking**: Continuous service health monitoring
- **Key-Value Store**: Distributed configuration storage
- **Service Mesh**: Secure service-to-service communication with TLS
- **Multi-Datacenter**: Cross-datacenter service networking

#### Real-World Use Case
Instead of hardcoding database endpoints:
1. Store configuration in Consul KV store
2. Applications automatically retrieve updated values
3. Changes propagate without redeployment
4. Centralized configuration management

#### Docker-Based Consul Setup

**Docker Compose Configuration**:
```yaml
# consul-compose.yml
version: '3'
services:
  consul:
    image: hashicorp/consul:latest
    ports:
      - "8500:8500"
      - "8300:8300"
```

**Startup Command**:
```bash
docker run -d \
  -p 8500:8500 \
  -p 8300:8300 \
  --name consul \
  hashicorp/consul:latest
```

#### Consul Verification
```bash
# Check container status
docker ps | grep consul

# Verify API endpoint
curl http://localhost:8500/v1/status/leader

# Access web UI
# http://localhost:8500
```

#### Key-Value Store Operations

**Store Configuration via curl**:
```bash
# Put key-value pair
curl -X PUT http://localhost:8500/v1/kv/app/config/welcome_message \
  -d "Welcome to Terraform and Consul integration"

# Update configuration
curl -X PUT http://localhost:8500/v1/kv/app/config/welcome_message \
  -d "Configuration updated dynamically"

# Retrieve via curl
curl http://localhost:8500/v1/kv/app/config/welcome_message
```

#### Terraform Consul Integration

**Provider Configuration**:
```hcl
terraform {
  required_providers {
    consul = {
      source = "hashicorp/consul"
    }
    local = {
      source = "hashicorp/local"
    }
  }
}

provider "consul" {
  address = "localhost:8500"
  scheme  = "http"
}
```

**Data Source and Resource Configuration**:
```hcl
# Read from Consul KV store
data "consul_keys" "app_config" {
  key {
    name    = "welcome_message"
    path    = "app/config/welcome_message"
    default = "Default welcome message"
  }
}

# Create local file with Consul data
resource "local_file" "welcome" {
  filename = "${path.module}/welcome.txt"
  content  = data.consul_keys.app_config.var.welcome_message
}

# Output retrieved value
output "message_from_consul" {
  value = data.consul_keys.app_config.var.welcome_message
}
```

#### Dynamic Configuration Workflow
1. Store initial configuration in Consul
2. Terraform reads configuration via data source
3. Create/update local resources with Consul values
4. Update configuration in Consul KV store
5. Re-run Terraform to reflect changes
6. Verify dynamic updates without code changes

#### Benefits of Consul Integration
- **Dynamic Configuration**: Update values without Terraform code changes
- **Centralized Management**: Single source of truth for configuration
- **Runtime Updates**: Changes propagate without infrastructure redeployment
- **Environment Specificity**: Different values per environment
- **State Sharing**: Consistent configuration across teams

### Lab Steps
1. Install Docker and verify connectivity
2. Add user to Docker group and restart
3. Create Docker Compose file for Consul
4. Start Consul container and verify operation
5. Configure key-value pairs via curl and web UI
6. Create Terraform configuration with Consul provider
7. Initialize and apply Terraform configuration
8. Demonstrate dynamic configuration updates
9. Verify file contents match Consul values
10. Clean up Docker container when complete

---

## 16.9 Using AI Tools with Terraform - Part 1

### Overview
This lab introduces AI tools and their application to Terraform development, covering various platforms, interaction methods, and best practices for effective prompt engineering.

### Key Concepts/Deep Dive

#### Understanding AI in Development Context
AI performs tasks upon commands through **pattern matching** rather than human-like thinking. This fundamental difference requires:
- Concise, accurate communication
- Careful prompt planning
- Clear understanding of desired outcomes

#### Popular AI Models and Platforms (2026)

**Major AI Models**:
- **Claude (Anthropic)**: Sonnet and Opus - widely considered gold standard for coding
- **Gemini (Google)**: Strong general-purpose capabilities
- **ChatGPT (OpenAI)**: GPT-4 and successors
- **Deepseek**: Open-source focused alternative

**Interaction Methods**:
- **Web Interfaces**: Direct browser access to any model
- **IDE Integration**: VS Code extensions and agents
- **Command Line**: CLI tools for terminal-based workflows

#### VS Code AI Integration Options
- **GitHub Copilot**: Paid monthly service with free trial
- **Continue.dev**: Open-source VS Code extension
- **Claude Dev**: Claude-specific extension
- **Amazon Q Developer**: AWS-focused with excellent API understanding
- **Cursor**: AI-first code editor
- **Windsurf**: AI-enhanced development environment

#### Command Line AI Tools
- **Claude Code**: Terminal-based Claude interaction
- **Warp Terminal**: AI-enhanced terminal experience
- **Open Code**: Open-source CLI options

#### AI Aggregators for Model Comparison
- poe.com
- prompts.ai
- Other multi-model platforms

#### Best Practices for Effective Prompting

**Core Principles**:
1. **Be Concise**: Speak exactly and simply
2. **Be Accurate**: Double-check work before submitting
3. **Use Preambles**: Define response expectations upfront
4. **Plan Externally**: Use note-taking apps (Joplin, Obsidian, OneNote)
5. **Define Roles**: Specify AI's function and expectations
6. **Specify Versions**: Include software and provider versions
7. **Provide Examples**: Share existing work when possible
8. **Request Validation**: Ask for configuration verification
9. **Chain of Thought**: Request step-by-step reasoning
10. **Security Defaults**: Demand secure configurations
11. **Think Logically**: Approach like Mr. Spock - no emotion, direct to the point

#### AI Preamble Example
```
Follow these rules:

1. Do not infuse any personality into your responses. Be concise and direct like the Star Trek computer.

2. Only give step-by-step answers without explaining why or how unless asked.

3. Do not add extraneous files until everything is 100% tested.

4. Don't build project files unless specifically asked for.

5. Don't assume anything about my requirements.
```

#### Token Economics
- AI responses charged by character/token count
- Personality adds unnecessary token usage
- Concise responses provide better value
- Preambles help optimize token usage

### Part 1 Summary
- AI tools require different interaction patterns
- Multiple platforms and integration methods available
- Prompt engineering skills are crucial for effectiveness
- External planning improves outcomes
- Preambles significantly improve AI responses

---

## 16.10 Using AI Tools with Terraform - Part 2

### Overview
Practical demonstration of AI tools within development workflows, comparing different models and showcasing real-world usage patterns.

### Key Concepts/Deep Dive

#### Live Demonstration Setup
**Test Configuration**:
```hcl
# test.tf - Starting configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.9.0"
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "example" {
  ami           = "ami-debian12-old"
  instance_type = "t2.micro"
}
```

#### Prompt Example for AI Agent
```
Build a new file called test-[MODEL].tf based on the currently opened test.tf:

1. Use the latest major version 6 and latest minor release of AWS provider
2. Use the latest Debian 13 AMI in us-east-2 region
3. Save file to working directory
4. Show file contents in agent chat
```

#### Model Comparison Results

**GPT-4.1 Performance**:
- ✅ Created requested file
- ❌ Did not fetch latest minor version (used 6.0 vs 6.30)
- ❌ Did not search for actual latest Debian 13 AMI
- ⚠️ Modified prompt dynamically without external verification

**Claude Sonnet 4.5 Performance**:
- ✅ Created requested file with correct naming
- ✅ Fetched latest AWS provider version (6.30) via web search
- ✅ Located correct Debian 13 "Trixie" AMI
- ✅ Verified information through external sources
- ✅ Provided accurate, up-to-date configuration

#### Key Observations from Live Testing
1. **External Verification**: Not all models search the web by default
2. **Version Accuracy**: Some models require explicit instruction to verify current versions
3. **AMI Selection**: Latest AMI identification requires external data sources
4. **Prompt Interpretation**: Models may modify prompts dynamically
5. **Token Usage**: Unnecessary phrases consume tokens without value

#### VS Code Agent Configuration
**Available Modes**:
- Agent (autonomous task execution)
- Ask (question and answer)
- Edit (direct code modification)
- Plan (project planning assistance)

**Model Selection**:
- Multiple models available within single agent interface
- Easy switching between models for comparison
- API key configuration required for each service

#### Additional Tool Categories

**Browser-Based**:
- Direct access to any AI model
- Web interface limitations vs IDE integration

**CLI-Based**:
- Claude Code for terminal workflows
- Open Code for open-source CLI options
- Integration with existing terminal workflows

**Open Source Options**:
- VS Codium with API-based extensions
- Continue.dev extension for flexibility
- Various open-source agent implementations

#### Continuous Evaluation Requirements
- AI tools change rapidly (monthly model releases)
- Regular testing needed to identify best tools
- Different tools excel at different tasks
- Personal workflow optimization requires experimentation

### Lab Steps
1. Set up test configuration file with outdated specifications
2. Configure AI agent in VS Code (GitHub Copilot example)
3. Create comparison prompts for different models
4. Execute GPT-4.1 test and analyze results
5. Execute Claude Sonnet 4.5 test with external verification
6. Compare accuracy, version selection, and AMI identification
7. Document lessons learned about model capabilities
8. Explore additional tools and integration methods
9. Establish personal AI tool evaluation process

---

## 16.11 Quiz

### Overview
Advanced quiz questions testing comprehensive understanding of Terraform beyond basic concepts, covering security, infrastructure patterns, and AI tool evaluation.

### Key Concepts/Deep Dive

#### Question 1: Multi-Region Security Strategy Analysis

**Question**: A DevOps team is building a multi-region infrastructure deployment system evaluating three approaches:
1. HashiCorp Vault for dynamic AWS credentials
2. Terraform Stacks for environment deployment
3. Provider caching for CICD optimization

**Which approach best addresses long-lived credential exposure?**

**Answer**: C - HashiCorp Vault's AWS Secrets engine generates dynamic short-lived credentials that automatically expire.

**Analysis**:
- **Correct Answer (C)**: Vault provides ephemeral credentials with automatic expiration
- **Option A**: Terraform Stacks minimize exposure through isolation but don't address credential lifecycle
- **Option B**: Provider caching has no encryption capabilities for credentials
- **Option D**: Stack components don't inherently rotate credentials

**Exam Strategy**: Complex multi-approach questions should be flagged and revisited, focusing on the core security requirement (credential lifecycle management).

#### Question 2: Production EKS Cluster Deployment Strategy

**Question**: Team needs to provision production EKS cluster with audit logging, private endpoints, and custom security policies. Which approach is most reliable?

**Options**:
- A: Generative AI for complete EKS configuration
- B: Manual Terraform using AWS EKS module
- C: Advanced workspace management
- D: AI validation against AWS best practices

**Answer**: B - Manually write Terraform using the community-maintained AWS EKS module.

**Analysis**:
- **Correct Answer (B)**: Well-tested, production-grade configurations with proper networking, IAM, and security controls
- **Option A**: AI tools lack comprehensive training on complex security policies
- **Option C**: Workspace management doesn't automatically configure EKS security
- **Option D**: AI validation insufficient for production security requirements

**Key Insight**: AI tools are valuable assistants but insufficient for critical production deployments requiring rigorous security controls.

#### Exam Preparation Insights
1. **Question Complexity**: Advanced questions may combine multiple concepts
2. **Time Management**: Flag complex questions for later review
3. **Core Focus**: Always identify the primary requirement (security, reliability, etc.)
4. **Real-World Application**: Questions reflect actual production decision-making scenarios

### Quiz Summary
- Questions test integration of multiple advanced concepts
- Focus on security best practices and production reliability
- AI tools are assistants, not replacements for human expertise
- Strategic question management improves exam performance

---

## Summary Section

### Key Takeaways

```diff
+ Vault Integration: Multiple approaches from local CLI to HCP Cloud for secure credential management
+ Terraform Stacks: Advanced multi-environment deployment using modules through HCP Terraform
+ Advanced AWS Patterns: Complex real-world infrastructure including monitoring, logging, and state management
+ Provider Caching: Optimization techniques with important limitations and considerations
+ Consul Integration: Service networking and dynamic configuration capabilities
+ AI Tools: Powerful assistants requiring careful prompt engineering and continuous evaluation
+ Security Focus: Dynamic credentials, encryption layers, and production-grade patterns
+ Exam Strategy: Complex questions require strategic time management and core requirement identification
```

### Quick Reference

#### Essential Commands
```bash
# Vault Operations
vault server -dev -dev-root-token-id=root
vault kv put secret/path key=value
export VAULT_ADDR='http://127.0.0.1:8200'

# Terraform Stacks
terraform stacks init
terraform stack create --organization-name org --project-name proj --stack-name stack
terraform stack configuration upload [parameters]

# Provider Caching
echo 'plugin_cache_dir = "$HOME/.terraform.d/plugin-cache"' >> ~/.terraformrc

# Consul Operations
docker run -d -p 8500:8500 hashicorp/consul:latest
curl -X PUT http://localhost:8500/v1/kv/path value
```

#### Key Configuration Patterns
```hcl
# Vault Provider (Local)
provider "vault" {
  address = "http://127.0.0.1:8200"
  token   = "root"
}

# Vault Provider (HCP)
provider "vault" {
  address   = var.vault_address
  token     = var.vault_token  # sensitive
  namespace = var.vault_namespace
}

# Dynamic Security Groups
dynamic "ingress" {
  for_each = var.ingress_rules
  content {
    from_port   = ingress.value.from_port
    to_port     = ingress.value.to_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Stack Component Variables
variable "access_key" {
  type      = string
  sensitive = true
  ephemeral = true
}
```

### Expert Insight

#### Real-world Application
- **Vault Integration**: Production environments should use HCP Vault or self-hosted Vault clusters with proper authentication methods (not root tokens)
- **Terraform Stacks**: Ideal for organizations with standardized infrastructure patterns across multiple environments and teams
- **Advanced AWS Patterns**: Represents typical production complexity including compliance requirements, monitoring, and automated lifecycle management
- **Provider Caching**: Most beneficial in large teams with consistent provider versions; less useful in CICD pipelines or with frequent version updates
- **Consul Integration**: Essential for microservices architectures requiring service discovery and dynamic configuration management
- **AI Tools**: Accelerate development and learning but require human oversight for production deployments, especially security configurations

#### Expert Path
1. **Start with Local Vault**: Master basic secret management concepts before cloud implementations
2. **Practice Stacks Incrementally**: Begin with simple two-environment setups before complex multi-deployment scenarios
3. **Build Advanced AWS Patterns Gradually**: Add one monitoring/logging component at a time to understand dependencies
4. **Evaluate Caching Impact**: Test in your specific environment before implementing team-wide
5. **Experiment with Consul**: Use Docker-based setups to understand KV store patterns before production service mesh
6. **Develop AI Prompt Libraries**: Create reusable preambles and prompt templates for consistent results across projects
7. **Security Integration**: Combine Vault dynamic credentials with advanced AWS patterns for production-grade security

#### Common Pitfalls
- **Root Token Usage**: Never use root tokens in production Vault setups
- **Cost Overruns**: Always destroy HCP Vault clusters immediately after lab completion ($0.61/hour adds up quickly)
- **State File Secrets**: Be aware that HCP Vault credentials may appear in Terraform state files
- **Version Drift**: Cached providers can become outdated if not manually managed
- **Over-reliance on AI**: AI-generated code requires thorough review, especially for security configurations
- **Skipping Destroy Verification**: Always verify resource cleanup in cloud consoles, not just Terraform output
- **Ignoring Validation Rules**: Variable validation prevents configuration errors in complex setups

#### Lesser-Known Facts
- **Ephemeral Variables**: Stack components support ephemeral variables that exist only during execution, enhancing security
- **Index Dependencies**: EIP associations use count-based logic (`count = var.instance_state == "running" ? 1 : 0`) for conditional resource creation
- **Symbolic Links in Caching**: Provider cache creates symbolic links rather than copies, saving significant disk space
- **Consul Port Architecture**: Single container exposes multiple ports (8500 HTTP, 8300 RPC) for different Consul functions
- **Token Economics**: AI responses are priced per token; personality and verbosity significantly impact costs
- **AMI Update Frequency**: Latest AMIs change regularly; AI tools with web access provide more current selections
- **EKS Complexity**: Production EKS clusters take 15-20 minutes to build and require careful cost management
- **Shamir Sealing**: Vault uses advanced cryptographic sealing beyond simple encryption for production security

</details>