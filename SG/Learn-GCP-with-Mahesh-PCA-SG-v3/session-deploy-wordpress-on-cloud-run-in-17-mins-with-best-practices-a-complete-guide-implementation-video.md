# Session 1: Deploy WordPress on Cloud Run

## Table of Contents
- [Overview](#overview)
- [Creating a Custom VPC](#creating-a-custom-vpc)
- [Creating a Cloud SQL Instance](#creating-a-cloud-sql-instance)
- [Service Account Creation](#service-account-creation)
- [Deploying WordPress on Cloud Run](#deploying-wordpress-on-cloud-run)
- [Environment Variables Setup](#environment-variables-setup)
- [Deploying PHPMyAdmin on Cloud Run](#deploying-phpmyadmin-on-cloud-run)
- [Database Configuration and Testing](#database-configuration-and-testing)
- [Login and Verification](#login-and-verification)
- [Summary](#summary)

## Overview
This session demonstrates how to deploy a WordPress application on Google Cloud Run, a serverless container platform, while incorporating best practices for security and networking. It covers the setup of a Virtual Private Cloud (VPC), Cloud SQL database instance, service accounts, and the deployment of both WordPress and PHPMyAdmin containers. The deployment ensures secure communication between Cloud Run and a private Cloud SQL instance using internal IP addresses, with no external exposure.

## Creating a Custom VPC
A VPC Network is essential for enabling private communication between Cloud Run and Cloud SQL with internal IP addresses.

### Key Concepts / Deep Dive
- **Why VPC?** Used for private service access to Cloud SQL and direct traffic routing from Cloud Run to VPC.
- **Subnet Creation:** Configure a custom subnet with private Google access enabled for best practices.
- **Firewall Rules:** Rely on implicit rules (deny all incoming, allow all outgoing traffic) instead of custom rules for simplicity and security.

### Lab Demo: Steps to Create VPC and Subnet
1. Navigate to GCP Console → VPC Networks.
2. Click "Create VPC Network".
3. Name: `customvpc`.
4. Subnet Name: `subnet-us-central`.
5. Region: `us-central1`.
6. IP Address Range: `192.168.100.0/24`.
7. Enable Private Google Access.
8. No custom firewall rules.
9. Click "Create".

```bash
# Equivalent gcloud command (if using CLI)
gcloud compute networks create customvpc --subnet-mode=custom
gcloud compute networks subnets create subnet-us-central --network=customvpc --range=192.168.100.0/24 --region=us-central1 --enable-private-ip-google-access
```

> [!NOTE]
> The subnet creation may take a minute. Cloud SQL will use this for private service access peering.

## Creating a Cloud SQL Instance
Cloud SQL provides a managed MySQL database with enterprise-grade features, configured for private IP access.

### Key Concepts / Deep Dive
- **Instance Type:** Use a smaller enterprise edition for demonstration; scale as needed.
- **Private IP:** Mandatory for security; enables private service access.
- **Zones:** High availability across multiple zones in us-central1.
- **Private Service Access:** Auto-allocates IP ranges for peering.

### Lab Demo: Steps to Create Cloud SQL Instance
1. Navigate to GCP Console → Cloud SQL.
2. Click "Create Instance".
3. Choose "MySQL" version (latest supported).
4. Instance ID: `mysqlinstance`.
5. Root Password: `demogcp`.
6. Region: `us-central1`.
7. Uncheck "Public IP".
8. Enable Private IP.
9. Select VPC: `customvpc`.
10. Auto-allocate IP ranges for private services.
11. Click "Create" (may take a few minutes).

```bash
# Equivalent gcloud command
gcloud sql instances create mysqlinstance --database-version=MYSQL_8_0 --tier=db-f1-micro --region=us-central1 --network=customvpc --no-assign-ip
```

> [!IMPORTANT]
> Private service access creates VPC peering, allowing secure communication without public IPs.

## Service Account Creation
Service accounts provide secure, least-privilege access for Cloud Run services to GCP resources.

### Key Concepts / Deep Dive
- **Best Practice:** Avoid using Compute Engine default service account; create project-specific accounts.
- **Permissions:** Grant only necessary roles (e.g., Storage Object Viewer for future plugins) to minimize risks.
- **Naming:** Use descriptive names for organization.

### Lab Demo: Steps to Create Service Account
1. Navigate to GCP Console → IAM & Admin → Service Accounts.
2. Click "Create Service Account".
3. Name: `sa-wordpress-phpmyadmin`.
4. Description: `Service account for WordPress and PHPMyAdmin on Cloud Run`.
5. No permissions (grant later as needed).
6. Click "Create and Continue" → "Done".

```bash
# Equivalent gcloud command
gcloud iam service-accounts create sa-wordpress-phpmyadmin --description="Service account for WordPress and PHPMyAdmin" --display-name="WordPress PHPMYAdmin SA"
```

## Deploying WordPress on Cloud Run
Cloud Run hosts the WordPress container image, configured for stateless operation and secure connectivity.

### Key Concepts / Deep Dive
- **Container Image:** Use official Docker Hub WordPress image (latest version 6.6.1).
- **Networking:** Route traffic to VPC for Cloud SQL access; avoid routing all traffic for efficiency.
- **Security:** Allow unauthenticated invocation for public access; use custom service account.
- **Scaling:** CPU/memory allocation based on workload; min/max instances for cost control.

### Lab Demo: Steps to Deploy WordPress
1. Navigate to GCP Console → Cloud Run.
2. Click "Create Service".
3. Container Image: `wordpress:6.6.1`.
4. Service Name: `wordpress-service`.
5. Authentication: Allow unauthenticated invocations.
6. Port: `80`.
7. CPU: Default; Memory: Adjust as needed.
8. Service Account: `sa-wordpress-phpmyadmin`.
9. Networking: Route to customvpc (only private IPs).
10. Environment Variables: (See next section).
11. Click "Create" (deployment takes ~7 minutes).

```bash
# Equivalent gcloud command
gcloud run deploy wordpress-service \
  --image=wordpress:6.6.1 \
  --platform=managed \
  --region=us-central1 \
  --allow-unauthenticated \
  --port=80 \
  --service-account=sa-wordpress-phpmyadmin \
  --vpc-connector=customvpc \
  --set-env-vars=WORDPRESS_DB_HOST=internal-ip,WORDPRESS_DB_USER=root,WORDPRESS_DB_PASSWORD=demogcp,WORDPRESS_DB_NAME=wordpressdb
```

> [!WARNING]
> Storing database credentials in plain text is not a best practice; use Cloud Secret Manager for production.

## Environment Variables Setup
Environment variables configure WordPress to connect to the Cloud SQL database.

### Key Concepts / Deep Dive
- **Required Variables:** Database host (internal IP), user, password, name.
- **Database Creation:** Manually create database in Cloud SQL after instance provisioning.
- **Best Practice:** Avoid hardcoded secrets; use external secret management.

### Lab Demo: Environment Variables for WordPress
1. In Cloud SQL Console: Navigate to instance `mysqlinstance`.
2. Click "Databases" → "Create Database".
3. Name: `wordpressdb`.
4. Save.

Set environment variables in Cloud Run deployment:
- `WORDPRESS_DB_HOST`: [Cloud SQL internal IP] (e.g., `10.0.0.2`)
- `WORDPRESS_DB_USER`: `root`
- `WORDPRESS_DB_PASSWORD`: `demogcp`
- `WORDPRESS_DB_NAME`: `wordpressdb`

> [!NOTE]
> Internal IP appears after Cloud SQL provisioning. Ensure no whitespace in values.

## Deploying PHPMyAdmin on Cloud Run
PHPMyAdmin provides a web interface for database management, deployed alongside WordPress.

### Key Concepts / Deep Dive
- **Purpose:** Optional but useful for database administration in development.
- **Configuration:** Requires database connection details and PMA settings.
- **Security:** Same service account and VPC routing; allow unauthenticated for access.

### Lab Demo: Steps to Deploy PHPMyAdmin
1. Create new Cloud Run service.
2. Container Image: `phpmyadmin/phpmyadmin:latest`.
3. Service Name: `phpmyadmin-service`.
4. Authentication: Allow unauthenticated invocations.
5. Port: `80`.
6. Service Account: `sa-wordpress-phpmyadmin`.
7. Networking: Route to customvpc (only private IPs).
8. Environment Variables:
   - `PMA_HOST`: [Cloud SQL internal IP]
   - `PMA_USER`: `root`
   - `PMA_PASSWORD`: `demogcp`
   - `PMA_PMADB`: `wordpressdb`
9. Click "Create".

```bash
# Equivalent gcloud command
gcloud run deploy phpmyadmin-service \
  --image=phpmyadmin/phpmyadmin:latest \
  --platform=managed \
  --region=us-central1 \
  --allow-unauthenticated \
  --port=80 \
  --service-account=sa-wordpress-phpmyadmin \
  --vpc-connector=customvpc \
  --set-env-vars=PMA_HOST=internal-ip,PMA_USER=root,PMA_PASSWORD=demogcp,PMA_PMADB=wordpressdb
```

## Database Configuration and Testing
Verify database connectivity and schema creation upon WordPress installation.

### Key Concepts / Deep Dive
- **Schema Auto-Creation:** WordPress creates tables (e.g., wp_options) automatically after installation.
- **Connection:** Uses internal IP via VPC; no public exposure.

### Lab Demo: Login and Configure
1. Access PHPMyAdmin URL (from Cloud Run service).
2. Login: Username: `root`, Password: `demogcp`.
3. Verify `wordpressdb` exists and schemas are created after WordPress setup.

## Login and Verification
Final verification of WordPress installation and functionality.

### Lab Demo: Complete WordPress Setup
1. Access WordPress URL (from Cloud Run service).
2. Select Language: English.
3. Site Title: `WordPress on Cloud Run`.
4. Username: `admin`.
5. Password: `demo@gcp2024`.
6. Email: [your email].
7. Click "Install WordPress".
8. Login to Admin Dashboard: Use credentials above.
9. Verify Database: Check PHPMyAdmin for created tables (e.g., wp_options).

> [!NOTE]
> Schemas appear only after WordPress installation click.

## Summary
### Key Takeaways
```diff
+ Custom VPC enables secure private communication between Cloud Run and Cloud SQL.
+ Private IP Cloud SQL prevents external attacks and reduces costs.
- Avoid default service accounts; use custom ones for least privilege.
+ Direct VPC routing is more efficient than full traffic redirection.
! Best practice: Use Secret Manager for sensitive environment variables in production.
- Hardcoded passwords in demos; not recommended for real deployments.
```

### Quick Reference
- VPC Creation: `customvpc` with subnet `192.168.100.0/24` in `us-central1`, private Google access.
- Cloud SQL: `mysqlinstance`, MySQL 8.0, private IP, password: `demogcp`.
- Service Account: `sa-wordpress-phpmyadmin` (no roles initially).
- WordPress Cloud Run: Image `wordpress:6.6.1`, port 80, env vars for DB connection.
- PHPMyAdmin Cloud Run: Image `phpmyadmin/phpmyadmin:latest`, same networking, PMA env vars.
- Post-Deployment: Create `wordpressdb` manually in Cloud SQL.

### Expert Insight
#### Real-world Application
This setup is ideal for serverless WordPress deployments in production environments requiring high availability, auto-scaling, and security. Use Cloud Load Balancing for global distribution and Cloud Monitoring for observability. For enterprises, integrate with GCP IAM for access controls and Cloud Audit Logs for compliance.

#### Expert Path
Master VPC networking (e.g., VPC peering, private service access), Cloud SQL performance tuning (e.g., replicas, backups), and Cloud Run secrets integration. Explore custom WordPress containers with pre-configured plugins and automated CI/CD pipelines using Cloud Build.

#### Common Pitfalls
- Forgetting to enable private service access, leading to public IP exposure.
- Using default service accounts, which have broad permissions and increase attack surfaces.
- Not creating the database manually; WordPress cannot auto-create it.
- Routing all traffic to VPC, which increases latency for public dependencies.
- Ignoring port configurations, causing container startup failures.

#### Lesser-Known Facts
Cloud Run's direct-to-VPC feature eliminates the need for serverless VPC access connectors in modern setups, reducing cost and complexity. WordPress plugins can trigger Cloud Storage access, necessitating service account role adjustments post-deployment. Implicit VPC firewall rules provide baseline security without manual configuration.
```
<summary>KK-CS45-V3</summary> 
```
