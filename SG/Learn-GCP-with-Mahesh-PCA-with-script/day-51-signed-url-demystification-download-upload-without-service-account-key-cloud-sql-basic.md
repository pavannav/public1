# Session 51: Signed URL Demystification

## Table of Contents

- [Overview](#overview)
- [Signed URL Basics](#signed-url-basics)
- [Setting Up for Signed URLs](#setting-up-for-signed-urls)
- [Download Demonstration](#download-demonstration)
- [Upload with Signed URLs](#upload-with-signed-urls)
- [Signed Policy Documents](#signed-policy-documents)
- [Cloud SQL Introduction](#cloud-sql-introduction)
- [Cloud SQL High Availability](#cloud-sql-high-availability)
- [Migration to Cloud SQL](#migration-to-cloud-sql)

## Overview

This session explores Signed URLs in Google Cloud Storage (GCS), providing a mechanism for temporary, secure access to objects without long-term credentials. It covers generating signed URLs for download and upload operations, compares GSutil and gcloud commands, and introduces signed policy documents for more control. The session demonstrates practical use cases, such as granting access to external auditors, and includes a bonus on Cloud SQL basics, including setup, high availability, and simple migration workflows.

## Signed URL Basics

### Key Concepts

Signed URLs allow external entities to access GCS objects temporarily without Google identity. They work by impersonation: a service account with necessary IAM roles generates a URL containing credentials, enabling access behind the scenes.

- **Use Case Scenario**: External auditors without Google accounts need file access. Options include creating IDs, using Microsoft identities, or signed URLs—signed URLs are ideal for non-Google users due to simplicity and security.
- **Conceptual Flow**: Service account → Generates signed URL → External user accesses URL → Impersonation grants access → Logs reflect service account activity.
- **Service Account Best Practices**: Use minimal roles (e.g., Storage Object Viewer). Avoid key generation where possible due to risks; signed URLs are a rare valid case for keys.
- **Commands**: Use `gsutil signurl` or `gcloud storage sign-url`. For uploads, add `-M` flag (PUT method). Exam note: `-M` is for method, not multi-threading.
- **CLI vs. UI**: UI lacks signed URL generation; must use CLI.
- **Long-Term Security**: URLs expire based on set duration (up to 7 days). No deletion option; mitigate via removing IAM roles, deleting keys, or objects.

### Deep Dive

- **Impersonation Mechanism**: External access translates to service account access. Enable Data Access audit logs to verify (log entries show service account, not user IP).
- **Duration Limits**: Short URLs (e.g., seconds/minutes) for demos; up to 7 days for production. Format: `10m`, `2h`, `7d`.
- **Key Handling**: Generate keys for long-term URLs; use service account token creator role for short-term (up to 12 hours) without keys. Without keys improves security.
- **IAM Granularity**: Grant roles at bucket level (not project) for least privilege—e.g., object viewer for downloads.
- **Comparison Table**

  | Aspect          | GSutil              | Gcloud Storage     |
  |-----------------|---------------------|--------------------|
  | Syntax         | `gsutil signurl`   | `gcloud storage sign-url` |
  | Key Requirement| Required           | Optional with impersonation |
  | Method Support | `-M` flag          | `-M` flag          |

## Setting Up for Signed URLs

### Key Concepts

Prepare GCS and service accounts for signed URL generation. Enable audit logs for tracking.

- **Audit Logs Setup**: Enable Data Read/Write in Monitoring > Admin Audit Logs for access visibility.
- **Bucket Creation**: Use regional buckets for data residency (avoid multi-region unless global).
- **Service Account Creation**: Dedicated account for signed URLs with minimal IAM.
- **Object Upload**: Use `gcloud storage cp` or `gsutil cp`.

### Lab Demos

- Create bucket: `gcloud storage buckets create gs://signed-url-concepts --location=us-central1`.
- Upload object: `gcloud storage cp flower.jpeg gs://signed-url-concepts`.
- Enable audit logs via UI.
- Create service account: `gcloud iam service-accounts create signed_url_sa`.

## Download Demonstration

### Key Concepts

Generate download URLs using service accounts. Access URLs to verify functionality and log service account activity.

- **Command Flow**: Generate key → Grant IAM → Sign URL → Share and access.
- **Log Analysis**: URLs show service account log entries, enabling audit trails (e.g., deny compromised auditors).
- **Expiration Behavior**: URLs return 403 errors post-expiry.
- **Tools**: Use incognito mode for testing to avoid cache.

### Lab Demos

- Grant IAM: `gcloud storage buckets add-iam-policy-binding gs://signed-url-concepts --member=serviceAccount:signed_url_sa@project.iam.gserviceaccount.com --role=roles/storage.objectViewer`.
- Generate key: `gcloud iam service-accounts keys create key.json --iam-account=signed_url_sa@project.iam.gserviceaccount.com`.
- Sign URL: `gsutil signurl -d 20s key.json gs://signed-url-concepts/flower.jpeg` or `gcloud storage sign-url --impersonate-service-account=signed_url_sa@project.iam.gserviceaccount.com --duration=7d gs://signed-url-concepts/flower.jpeg`.
- Access URL and check logs: Filter for service account in Log Explorer.

## Upload with Signed URLs

### Key Concepts

Use PUT method for uploads. Content type restrictions apply. Compare to signed policy documents for more control (size/content limits, UI-friendly).

- **Method Differences**: GET for downloads, PUT for uploads.
- **Content Type Specification**: e.g., `text/plain` to restrict file types.
- **Tools**: Use Postman or curl for uploads (not browser-friendly for tech users).
- **Without Key**: Max 12 hours, use impersonation.

### Deep Dive

- **Content Type Enforcement**: Mismatched types return errors.
- **Curl Example**: `curl -X PUT -H "Content-Type: text/plain" --data-binary @file.txt "signed-url"`.

### Lab Demos

- Generate upload URL: Add storage object user role, specify PUT and content type, use Postman to upload file and verify in GCS.

## Signed Policy Documents

### Key Concepts

Enhance signed URLs with policies for uploads: specify file size limits, content types, and provide basic HTML forms for user-friendly interfaces.

- **Advantages**: Size limits, multiple content types, HTML form upload (no deep technical knowledge needed).
- **HTML Form Creation**: Generate policy with base64 signature, upload as static site in GCS.

### Deep Dive

- **Policy Structure**: Include conditions (e.g., content-length-range), base64 policy, signature.
- **Security Gains**: Prevents large file uploads or unauthorized types.
- **Example Fields**: Service account, bucket, action, conditions.

### Common Issues and Resolutions

- **Large Files**: Use policy max size.
- **Type Mismatches**: Define allowed content types.
- **UI Limitations**: Build HTML forms; may require server-side processing.

## Cloud SQL Introduction

### Key Concepts

Fully managed relational databases (MySQL, PostgreSQL, SQL Server). Supports vertical scaling (up to 128 vCPUs), backups, patching, high availability within zone or region.

- **Managed Benefits**: Automated backup/patching; no OS management.
- **Scaling**: Vertical via instance restart; horizontal via read replicas.
- **Limits**: Max 64 TB storage; SSD required.

### Deep Dive

- **Pricing**: Lower than self-managed; compare VM + manual ops.
- **High Availability Options**: Multi-zone for failover within region.
- **Read Replicas**: Horizontal scaling; up to 10 global replicas.

## Cloud SQL High Availability

### Key Concepts

Failover within zone via automatic switches. Regional protection via replicas.

- **Upgrade Path**: Enterprise → Enterprise Plus for 4nines SLA.
- **Downtime Cases**: Vertical scaling requires restarts.

## Migration to Cloud SQL

### Key Concepts

Lift-and-shift via dumps to GCS as staging. Import via gcloud/bucket access.

- **Process**: Dump → Upload to GCS → Import to Cloud SQL.
- **Security**: Grant Cloud SQL service account object viewer on bucket.
- **Automation**: Scripts for bucket creation, grants, imports.

### Lab Demos

- Create Cloud SQL: Use gcloud with Enterprise tier, multi-zone.
- Enable private IP for security.
- Import dump: UI auto-grants IAM; CLI requires manual grants.
- Query: Connect via `mysql --host=<ip> --user=root -p`.

### Common Pitfalls

- **Unnecessary Keys**: Use impersonation for short durations; avoid long-term keys.
- **Broad IAM Grants**: Bucket-level not project-level.
- **Public IPs**: Use private IPs; whitelist specific ranges.
- **Virus Precautions**: GCS stores anything; use Cloud Run + ClamAV for scans.
- **Query Limitations**: Not for analytics; use BigQuery for structured queries.
- **Scaling Downtime**: Plan vertical scaling windows.
- **Migration Complexity**: Best for simple DBs; complex schemas need planning.

## Summary

### Key Takeaways

```diff
+ Signed URLs enable secure, temporary GCS access without long-term keys.
+ Use impersonation for keyless short-term URLs (up to 12 hours).
+ Signed policies add upload controls (size, types) with user-friendly forms.
+ Cloud SQL simplifies DB management with auto-scaling and HA.
- Avoid public IPs; prefer private for Cloud SQL.
! Test URLs in incognito to verify expiration and audit logs.
```

### Expert Insight

**Real-world Application**: In audits/external partnerships, signed URLs share reports securely without account provisioning. For uploads, signed policies streamline forms for non-tech users.

**Expert Path**: Master GCS IAM granularity, Cloud SQL failover scenarios, and migration scripts. Explore BigQuery for query-heavy needs over raw GCS.

**Common Pitfalls**: Expose credentials in URLs; mitigate via short expirations and log monitoring. GCS doesn't scan viruses—integrate post-upload validations. Cloud SQL vertical scaling causes downtime; plan accordingly. Lesser known: Combine signed URLs with Cloud Load Balancer for object serving; use read replicas for global read-heavy workloads.
