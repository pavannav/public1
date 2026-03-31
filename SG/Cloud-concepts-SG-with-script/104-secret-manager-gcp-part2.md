# Session 104: Secret Manager GCP Part 2 - Rotation and Management

## Table of Contents
- [Secret Rotation Overview](#secret-rotation-overview)
- [Adding New Secret Versions](#adding-new-secret-versions)
- [Latest Alias Usage](#latest-alias-usage)
- [Delay Destruction of Secret Versions](#delay-destruction-of-secret-versions)
- [Rotation Schedule and Automation](#rotation-schedule-and-automation)
- [Aliases for Secret Versions](#aliases-for-secret-versions)
- [Demo: Setting Up and Testing Rotation](#demo-setting-up-and-testing-rotation)
- [Delay Destruction and Expiration Overrides](#delay-destruction-and-expiration-overrides)
- [Summary](#summary)

## Secret Rotation Overview

### Overview
Secret rotation is the process of periodically updating or replacing sensitive information like passwords, API keys, or encryption keys. This minimizes the risk of unauthorized access if secrets are compromised or leaked. In Google Cloud Secret Manager, rotation involves adding new versions to an existing secret rather than creating new secrets.

### Key Concepts/Deep Dive
- **Purpose of Rotation**: Rotate secrets every month or three months to reduce risks. Compromised secrets become irrelevant after rotation.
- **Version Management**: Each rotation adds a new version to the secret. The latest version can be referenced using the "latest" alias.
- **Restriction**: Minimum rotation interval is 1 hour, even if configured for shorter periods like minutes or seconds.

> [!NOTE]
> Secret rotation helps in compliance and security best practices by ensuring sensitive data is refreshed regularly.

## Adding New Secret Versions

### Overview
To rotate a secret, create a new version of the existing secret. This keeps the secret ID the same while updating the value.

### Key Concepts/Deep Dive
- **Process**: Add a new version to an existing secret. Do not create a new secret.
- **Access**: Use the "latest" alias to always reference the most recent version. Specify version numbers for older versions.

### Demo Steps
1. Go to Secret Manager console.
2. Select an existing secret (e.g., MySQL username).
3. Click "Add new version" and provide the new value (e.g., a new password).
4. The new version becomes the "latest" by default.

```bash
# Example command to add a new version (via gcloud CLI)
gcloud secrets versions add SECRET_ID --data-file=path/to/new_secret_value.txt
```

> [!IMPORTANT]
> Ensure applications are configured to use "latest" for automatic updates during rotation.

## Latest Alias Usage

### Overview
The "latest" alias automatically points to the most recently added secret version, simplifying access for applications.

### Key Concepts/Deep Dive
- **Default Reference**: Applications can use `/latest` in the secret path for dynamic updates.
- **Alternatives**: Specify explicit version numbers (e.g., `/versions/2`) for controlled access.
- **Benefit**: Reduces manual updates in application code during rotation.

## Delay Destruction of Secret Versions

### Overview
Delay destruction allows secret versions to be marked for deletion but remain recoverable for a specified period. By default, destruction is immediate and permanent.

### Key Concepts/Deep Dive
- **Admin-Only Feature**: Requires Secret Manager Admin role.
- **Process**: When destruction is requested, the version is disabled (not immediately destroyed).
- **Timeline**: Configurable delay (e.g., 1-5 days) before permanent destruction.
- **Recovery Options**:
  - Re-enable the version before the delay expires.
  - Disable prevents immediate use but allows recovery.

```diff
+ Re-enable: Brings the version back to active state during the delay period.
- Permanent Destruction: Occurs automatically after the delay if not intervened.
```

> [!WARNING]
> ⚠ Unauthorized deletion can disrupt applications immediately. Use delay to allow recovery.

## Rotation Schedule and Automation

### Overview
Set up automated rotation using schedules, Pub/Sub notifications, and Cloud Functions to trigger updates.

### Key Concepts/Deep Dive
- **Schedule Options**: Use predefined intervals (e.g., 30 days) or custom periods (minimum 1 hour).
- **Notifications**: Publish messages to Pub/Sub topics at rotation time.
- **Automation**: Cloud Functions can receive Pub/Sub messages and rotate secrets.
- **Permissions Required**:
  - Pub/Sub Publisher role for the service account.
  - Secret Manager Admin and Cloud SQL Admin roles for updates.

### Demo Steps
1. Edit a secret in Secret Manager console.
2. Under "Rotation", set frequency (e.g., every 60 minutes) and start time.
3. Add a Pub/Sub topic for notifications.
4. Deploy a Cloud Function triggered by the Pub/Sub topic to:
   - Generate new secret values (e.g., random passwords).
   - Update the secret version.
   - Optionally update databases (e.g., Cloud SQL passwords).

```python
# Example Cloud Function code for rotation (simplified)
import os
from google.cloud import secretmanager_v1
from google.cloud import pubsub_v1

def rotate_secret(event, context):
    client = secretmanager_v1.SecretManagerServiceClient()
    name = f"projects/{project}/secrets/{secret_id}/versions/latest"
    
    # Generate new value (example for password)
    new_value = generate_random_password()
    
    # Add new version
    response = client.add_secret_version(
        request={"parent": f"projects/{project}/secrets/{secret_id}",
                 "payload": {"data": new_value.encode("UTF-8")}}
    )
    
    # Update database if needed
    update_cloud_sql_password(new_value)
```

> [!NOTE]
> Advertisement Reminder: Use AI tools like Gemini to generate code, but test thoroughly in development before production.

## Aliases for Secret Versions

### Overview
Aliases provide human-readable names for specific secret versions, allowing controlled access in applications.

### Key Concepts/Deep Dive
- **Usage**: Map alias names (e.g., "prod", "staging") to version numbers.
- **Constraints**: One alias per version; a version can have multiple aliases.
- **Example Scenarios**: Use "prod" for production-tested versions, "latest" for development.

### Demo Steps
1. Go to Secret Manager, select a secret.
2. Click "Edit secret" > "Aliases".
3. Add alias names and map to version numbers (e.g., "prod" -> version 2).
4. In applications, reference as `/aliases/prod`.

```yaml
# Example application config
apiVersion: v1
kind: Secret
metadata:
  name: mysql-secret
data:
  username: gcp-secret://projects/{project}/secrets/mysql-username/aliases/prod
  password: gcp-secret://projects/{project}/secrets/mysql-password/aliases/prod
```

> [!TIP]
> 💡 Aliases help stage rotations: test with "staging" alias before promoting to "prod".

## Demo: Setting Up and Testing Rotation

### Demo Overview
This demo covers creating secrets, enabling rotation, and verifying connectivity with a MySQL database from a VM.

### Lab Demos Steps and Code
1. **Create Secrets**:
   - Go to Secret Manager console.
   - Create secret for MySQL username (value: "root").
   - Create secret for MySQL password (initial value: current password).

   ```bash
   gcloud secrets create mysql-username --data-file=/path/to/username.txt
   gcloud secrets create mysql-password --data-file=/path/to/password.txt
   ```

2. **Connect from VM**:
   - Use a Python script to connect to Cloud SQL using secrets.
   - Script retrieves username and password from Secret Manager.

   ```python
   # mysql_connect.py (edited for clarity)
   from google.cloud import secretmanager_v1
   import mysql.connector

   def access_secret_version(project_id, secret_id, version_id):
       client = secretmanager_v1.SecretManagerServiceClient()
       name = client.secret_version_path(project_id, secret_id, version_id)
       response = client.access_secret_version(name)
       return response.payload.data.decode("UTF-8")

   project_id = "your-project-id"
   username = access_secret_version(project_id, "mysql-username", "latest")
   password = access_secret_version(project_id, "mysql-password", "latest")

   connection = mysql.connector.connect(
       host="your-cloud-sql-instance",
       user=username,
       password=password,
       database="your-db"
   )
   print("Connection successful!")

   connection.close()
   ```

3. **Enable Rotation**:
   - Edit secret > Rotation.
   - Set schedule (e.g., 60 minutes), add Pub/Sub topic.
   - Deploy Cloud Function with Pub/Sub trigger to rotate secrets and update Cloud SQL.

4. **Test Rotation**:
   - Run the Python script before and after rotation (wait for schedule).
   - Verify the new password works; previous fails if versions differ.

   ```bash
   python3 mysql_connect.py  # Should connect successfully
   # Wait for rotation, then rerun
   python3 mysql_connect.py  # Connects with new password
   ```

> [!NOTE]
> If rotation fails, check service account permissions and Cloud Function logs.

## Delay Destruction and Expiration Overrides

### Overview
Expiration permanently deletes all versions immediately, overriding any configured delay.

### Key Concepts/Deep Dive
- **Delay Configuration**: Per-secret setting (e.g., 1 day) for graceful deletion.
- **Expiration**: Overrides delay; confirmed with warning.

### Demo Steps
1. Enable delay destruction (e.g., 1 day) on a secret.
2. Destroy a version: It enters "disabled" state, scheduled for deletion.
3. Test recovery: Re-enable the version during delay.
4. Set expiration: All versions deleted immediately upon expiry.

```diff
+ Delay Allows Recovery: Maintains secrets in disabled state for re-enablement.
- Expiration Overrides: Destroys everything instantly, even delayed versions.
```

> [!WARNING]
> ⚠ Mistake Corrections: "popsup" corrected to "Pub/Sub", "IM" likely "IAM", "cme" to "CMEK". "Service agent" should be "service agent".

## Summary

### Key Takeaways
```diff
+ Automated rotation with Pub/Sub and Cloud Functions ensures secrets are refreshed without downtime.
+ Use "latest" alias for dynamic updates, aliases for controlled access.
+ Delay destruction provides a safety net against accidental deletions, but expiration prevails.
- Overly permissive roles (e.g., Secret Manager Admin) increase security risks; use custom roles.
! Test rotations in staging before production to avoid application disruptions.
```

### Expert Insight

#### Real-World Application
In production environments, integrate secret rotation with CI/CD pipelines to update application deployments automatically. For example, use Kubernetes secrets or environment variables refreshed via webhooks from Cloud Functions to minimize manual intervention.

#### Expert Path
To master secret rotation, study Google Cloud's best practices for identity and access management (IAM). Experiment with custom Cloud Functions for complex rotation logic, such as generating cryptographically secure keys or integrating with external vaults like HashiCorp Vault for hybrid setups.

#### Common Pitfalls
- **Immediate Deletion Risks**: Forgetting delay configuration leads to irrecoverable data loss.
- **Role Over-Permissioning**: Excessive IAM roles on service accounts can enable unintended rotations or deletions; conduct regular audits.
- **Version Conflicts**: Hardcoding version numbers in code breaks during rotations; always prefer "latest" or aliases.
- **Expiration Timing**: Setting short expirations disrupts delays; plan carefully and monitor with Cloud Monitoring alerts.

Verify helper text and common issues with resolution:
- **Connection Failures**: Check VM to Cloud SQL connectivity; ensure Cloud Function updates database passwords.
- **Pub/Sub Delays**: Messages may not trigger immediately; use Cloud Logging to debug.
- **Regional Restrictions**: For regional secrets, ensure all resources (e.g., Cloud Functions) are in the same region.
