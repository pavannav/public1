# Session 1: Deploy WordPress on Cloud Run

## Table of Contents

- [Introduction](#introduction)
- [VPC Setup](#vpc-setup)
- [Cloud SQL Instance Configuration](#cloud-sql-instance-configuration)
- [Service Account Creation](#service-account-creation)
- [WordPress Cloud Run Deployment](#wordpress-cloud-run-deployment)
- [PHPMyAdmin Cloud Run Deployment](#phpmyadmin-cloud-run-deployment)
- [Database Setup and WordPress Configuration](#database-setup-and-wordpress-configuration)
- [Summary](#summary)

## Introduction

> [!NOTE]
> This session covers deploying WordPress on Google Cloud Run with best practices, focusing on security, serverless architecture, and production-ready configurations.

### Overview

Google Cloud Run is a serverless container platform that automatically scales your containerized applications. This guide demonstrates how to deploy WordPress using Cloud Run with private networking to Cloud SQL, implementing security best practices along the way.

## VPC Setup

### Why VPC is Required

A VPC (Virtual Private Cloud) is essential for:
- Creating Cloud SQL instances with internal IP addresses
- Enabling secure communication between Cloud Run and Cloud SQL
- Maintaining network isolation

### VPC Creation Steps

1. Navigate to VPC Network section in Google Cloud Console
2. Create a new VPC named `custom-vpc`
3. Configure subnet details:
   - **Region**: US Central1
   - **IP Range**: 192.168.100.0/24
   - **Standard**: RFC 1918

4. **Enable Private Google Access**: Always recommended for secure connectivity

5. **Firewall Rules**: No custom rules needed - VPC comes with implicit rules:
   - Deny all incoming traffic
   - Allow all outgoing traffic

```bash
# VPC Configuration Summary
VPC Name: custom-vpc
Subnet: us-central1
IP Range: 192.168.100.0/24
Private Google Access: Enabled
```

⚠️ **Best Practice**: Wait for subnet provisioning before proceeding, though it may take some time.

## Cloud SQL Instance Configuration

### Key Configuration Decisions

- **Instance Type**: MySQL with Enterprise edition (can use smaller version for demos)
- **Instance ID**: `my-sql-instance`
- **Password**: `demogcp` (develop a strong password policy for production)

### Network Security Features

```yaml
# Cloud SQL Configuration
root_password: "demogcp"
region: "us-central1-a"
enable_private_ip: true
private_service_access: true
allocated_ip_range: automatic
no_external_ip: true
```

**Important Security Notes**:
- ✅ Use internal IP only (no external IP)
- ✅ Enable private service access
- ✅ Use automatic IP allocation

### Provisioning Time

Cloud SQL instances typically take 3-7 minutes to provision completely.

## Service Account Creation

### Purpose of Service Account

Service accounts provide identity for Cloud Run services, especially important when:
- WordPress plugins need access to Google Cloud Storage
- Fine-grained access control is required

### Creation Steps

1. Navigate to IAM & Admin > Service Accounts
2. Create service account named `sa-wordpress-phpmyadmin`
3. **Don't assign permissions** initially - follow principle of least privilege
4. Later assignments may include:
   - `Storage Object Viewer` (for WordPress plugins using GCS)

```yaml
# Service Account Configuration
name: sa-wordpress-phpmyadmin
display_name: WordPress and PHPMyAdmin Service Account
# Intentionally no roles assigned initially
```

> [!IMPORTANT]
> Never use Compute Engine default service account for production applications.

## WordPress Cloud Run Deployment

### Container Image Setup

```yaml
# WordPress Deployment Configuration
image: "wordpress:6.6.1"
region: "us-central1"
allow_unauthenticated_invocations: true
port: 80
```

### Security Configuration

1. **Service Account**: Use dedicated `sa-wordpress-phpmyadmin`
2. **Authentication**: Allow unauthenticated for public access (WordPress is public-facing)

### Network Configuration

**Key Innovation**: Direct VPC connectivity without VPC Connector

```yaml
# Network Settings
vpc_connector: none
route_traffic_to_vpc: private_ip_only
subnet: custom-subnet-us-central1
```

### Environment Variables

WordPress requires specific MySQL connection parameters. Ensure no whitespace in values:

```yaml
# WordPress Environment Variables
WORDPRESS_DB_HOST: "REPLACE_WITH_CLOUD_SQL_IP"
WORDPRESS_DB_USER: "root"
WORDPRESS_DB_PASSWORD: "demogcp"
WORDPRESS_DB_NAME: "wordpress_db"
```

> [!IMPORTANT]
> Environment variables must be exact with no trailing spaces.

## PHPMyAdmin Cloud Run Deployment

### Optional but Recommended

PHPMyAdmin provides a web interface for MySQL management, useful for:
- Database administration
- Schema verification
- Troubleshooting

### Configuration

```yaml
# PHPMyAdmin Deployment
image: "phpmyadmin/phpmyadmin:latest"
region: "us-central1"
allow_unauthenticated_invocations: true
port: 80
```

### Environment Variables

```yaml
# PHPMyAdmin Environment Variables
PMA_HOST: "REPLACE_WITH_CLOUD_SQL_IP"
PMA_PASSWORD: "demogcp"
PMA_ARBITRARY: 1

# Optional settings (can be omitted)
PMA_THEME: ""
PMA_CONFIG_ABSOLUTE_URI: ""
```

### Required PHPMyAdmin Setting

When using external MySQL instances, set the PMA_ABSOLUTE_URI environment variable:

```yaml
PMA_ABSOLUTE_URI: "https://your-pma-service-url"
```

## Database Setup and WordPress Configuration

### Database Creation

Manually create the WordPress database in Cloud SQL:

```sql
-- Create WordPress database
CREATE DATABASE wordpress_db;
```

✅ **Important**: Wait for Cloud SQL instance to be fully provisioned before creating databases.

### WordPress Initial Setup

1. Access WordPress URL (provided by Cloud Run)
2. Select language (English)
3. Configure site details:
   - **Site Title**: "WordPress on Cloud Run"
   - **Username**: `admin`
   - **Password**: `gcp2024CloudRun`
   - **Email**: Your email address

4. **Install WordPress** - triggers automatic schema creation

### Schema Verification

After installation, verify database schema includes:
- `wp_options` table (core settings)
- Other standard WordPress tables

### Login Process

1. Navigate to `/wp-admin`
2. Use configured credentials to access admin panel

## Summary

### Key Takeaways

```diff
+ Custom VPC with subnet enables private Cloud SQL connectivity
+ MySQL instances use internal IPs for security (no external IP)
+ Dedicated service accounts follow least privilege principle
- Avoid using default Compute Engine service account
+ Direct VPC routing eliminates need for VPC connectors
+ WordPress environment variables must be whitespace-free
! Cloud SQL provisioning can take 3-7 minutes
+ PHPMyAdmin optional but valuable for database management
```

### Expert Insights

#### Real-world Application
This setup is production-ready for:
- Small to medium WordPress sites
- Microservices architectures needing database isolation
- Serverless applications requiring secure database connections

#### Expert Path
- **Secrets Management**: Replace plaintext passwords with Cloud Secret Manager
- **Monitoring**: Set up Cloud Logging and Monitoring for performance insights
- **CI/CD**: Implement Cloud Build triggers for WordPress updates
- **Scalability**: Configure minimum/maximum instances based on traffic patterns

#### Common Pitfalls
- **Password Whitespace**: Extra spaces in environment variables cause connection failures
- **Premature Operations**: Attempting database creation before Cloud SQL fully provisions
- **Default Service Accounts**: Using shared defaults instead of dedicated service accounts
- **Firewall Exposure**: Not carefully configuring traffic routing to VPC

#### Common Issues with Resolution
- **Cloud SQL Connection Timeout**: Verify subnet exists and VPC networking is configured
- **Database Creation Failure**: Wait for Cloud SQL instance to show "Ready" status
- **WordPress Install Hanging**: Check environment variables for typos, especially host IP
- **PHPMyAdmin Access Issues**: Ensure PMA_ABSOLUTE_URI is properly configured

#### Lesser Known Things
- **VPC Network Peering**: Cloud SQL with internal IP creates automatic peering with tenant project
- **Traffic Segmentation**: Route only private IP traffic to VPC (not all traffic) for better security
- **Container Versioning**: Use specific WordPress versions (like 6.6.1) for reproducible deployments
- **Zero-trust Security**: Internal-only database access forces all connections through Cloud Run

> <summary>CL-KK-Terminal</summary>
> This deployment demonstrates modern cloud-native WordPress hosting combining serverless computation with managed databases, emphasizing security through private networking and minimal IAM permissions.
