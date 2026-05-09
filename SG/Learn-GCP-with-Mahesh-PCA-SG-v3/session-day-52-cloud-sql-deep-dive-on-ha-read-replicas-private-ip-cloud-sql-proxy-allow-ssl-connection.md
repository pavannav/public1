# Session 52: Cloud SQL Deep Dive

## Table of Contents
- [High Availability (HA) and Failover](#high-availability-ha-and-failover)
- [Read Replicas](#read-replicas)
- [Private IP and Internal Connections](#private-ip-and-internal-connections)
- [Cloud SQL Proxy](#cloud-sql-proxy)
- [SSL Connections and Security](#ssl-connections-and-security)
- [Additional Database Offerings](#additional-database-offerings)
- [Summary](#summary)

## High Availability (HA) and Failover
### Overview
High Availability (HA) in Cloud SQL ensures that your database remains accessible even during zone failures. When enabled, it creates a regional persistent disk that spans two zones, synchronizing data across them. If one zone fails, Cloud SQL automatically fails over to the other zone with minimal downtime (typically 30-57 seconds in demonstrations, though documentation mentions several minutes).

### Key Concepts
- **Regional Persistent Disk**: Unlike a zonal disk (used in a single zone), a regional persistent disk replicates data across two zones (e.g., Zone A and Zone B in the same region). This provides redundancy.
- **Failover Process**: When Zone A fails, Cloud SQL forcibly attaches the regional disk to a new instance in Zone B. The IP address remains the same, so applications don't need reconfiguration.
- **Automatic vs. Manual Failover**: In real-world scenarios, Google triggers automatic failover. For testing, you can perform manual failover using `gcloud sql instances failover INSTANCE_NAME` with time tracking (`time gcloud sql instances failover INSTANCE_NAME`).
  
  Example command:
  ```bash
  time gcloud sql instances failover my-instance
  ```
  
- **IP Address Stability**: Even if stopped and restarted, Cloud SQL instances with HA enabled retain the same public IP. For production, prefer private IPs.
- **HA Configuration**: Enable "High availability" during instance creation by selecting multiple zones. This costs more but ensures 99.95% uptime SLA.

### Demo: Failover Simulation
- Stop the Cloud SQL instance, then restart it (similar to a failure).
- Connect via MySQL client using `mysql -h PUBLIC_IP -u root -p`.
- Run continuous queries (e.g., `SELECT * FROM city LIMIT 10;`).
- Trigger manual failover and observe ~57 seconds downtime.
- Post-failover, check instance location; it may toggle between zones (e.g., from us-central1-c to us-central1-f).
- Verify IP remains the same and data is intact.

### Deep Dive into Implementation
Behind the scenes, Cloud SQL uses regional Persistent Disks for data storage (10 GB SSD typically). In a manual VM simulation:
- Create a regional disk attached read/write to primary VM in Zone A.
- On Zone A failure, attach the disk to a new VM in Zone B and mount it.
- This avoids formatting data each time, ensuring continuity.

Mermaid Diagram for HA Failover Process:
```mermaid
graph TD
    A[Application] --> B[Cloud SQL Primary Instance (Zone A)]
    B --> C[Regional Persistent Disk Sync]
    C --> D[Secondary Standby Instance (Zone B)]
    E[Zone A Fails] --> F[Automatic Failover]
    F --> G[Attach Disk to Zone B Instance]
    G --> H[Application Resumes with Same IP]
```

### Tables
| Feature | Description | Cost Impact |
|---------|-------------|-------------|
| Regional Persistent Disk | Spans multiple zones for redundancy | Higher than zonal disk |
| Failover Time | 30-57 seconds in testing; up to several minutes per docs | Included in HA cost |
| IP Retention | Static public IP persists across restarts | Free feature |

## Read Replicas
### Overview
Read replicas provide read scalability and disaster recovery across regions. They synchronously replicate from the master within a region but asynchronously across regions. Up to 10 replicas are supported, increasing read throughput without burdening the master.

### Key Concepts
- **Use Cases**:
  - **Read Scalability**: Handle high read loads (e.g., banking transactions for account views vs. writes).
  - **Disaster Recovery**: If a region fails, promote a replica in another region (e.g., Australia replica for US master).
- **Replication Lag**: Generally zero within a region; check the "Replication lag" metric (ideally 0 seconds).
- **Asynchronous Replication**: Across regions, introduces ~1-minute lag in tests, but sufficient for most use cases.
- **Promotion**: Convert replica to standalone instance for writes; irreversible. Creates new IP; update application connections.
  
  Command to promote:
  ```bash
  gcloud sql instances promote-replica REPLICA_NAME
  ```

### Demo: Replication Speed
- Create replica in a distant region (e.g., us-central1 to australia-southeast1).
- Insert/update data in master (e.g., `UPDATE city SET population = population + 5000;`).
- Query in replica; replication happens instantly (real-time synchronization).
- Monitor CPU/metrics in replica console.

### Tables
| Characteristic | Master | Replica |
|---------------|--------|---------|
| Read/Write | Both | Read-only |
| Data Sync | N/A | Synchronous (same region), Asynchronous (cross-region) |
| Promotion | N/A | Becomes master with new IP |
| Max Count | 1 | Up to 10 |

### Comparisons
- Cost: Replicas increase cost (e.g., +19% for another instance).
- Location: Avoid same zone as master; prefer other regions for DR.

## Private IP and Internal Connections
### Overview
Private IP uses internal networking for secure, low-latency connections within VPC. Public IPs expose databases externally, which is a security risk. Configure private IP via "Private IP" option, requiring VPC Network Peering (detailed in networking sessions).

### Key Concepts
- **Benefits**: No external exposure; internal routing.
- **Configuration**: Assign during creation or edit; irreversible for removal.
- **Direct Connection**: From VMs in same VPC/network, connect via `mysql -h PRIVATE_IP -P 3306 -u root -p`.
- **Firewall Rules**: Ensure egress allows Cloud SQL proxy port (3307) if used.

### Demo: Switching to Private IP
- Edit instance to assign private IP.
- Remove public IP for security.
- Connect from VM in same network without whitelisting.

```mermaid
graph LR
    A[VM in VPC/Network] --> B[Internal Connection via Private IP]
    B --> C[Cloud SQL Instance (Private IP)]
    D[No Public Access] --> C
```

## Cloud SQL Proxy
### Overview
Cloud SQL Proxy enables secure connections without whitelisting IPs. It runs as a client, authenticates via IAM, and establishes TLS tunnels. Ideal for local development, Cloud Shell, or secure access.

### Key Concepts
- **Security**: Uses ephemeral certificates (valid 60 minutes, auto-renewed). No static credentials shared.
- **Installation**: Download auth proxy binary; run on local machine or VM.
- **IAM Roles**: Assign `Cloud SQL Client` role (permissions: `cloudsql.instances.connect`, `cloudsql.instances.get`).
- **Command**:
  ```bash
  ./cloud_sql_proxy -instances=PROJECT_ID:REGION:INSTANCE_NAME=tcp:LOCAL_PORT
  ```
  Then connect via `mysql -u root -p -h 127.0.0.1 -P LOCAL_PORT`.
- **Features**: Supports all database types; works with private/public IPs.

### Tables
| Method | Whitelisting Needed | IAM Auth | Best For |
|--------|---------------------|----------|----------|
| Direct Private IP | No | No | Internal APPs |
| Proxy with Private IP | No | Yes (`Cloud SQL Client`) | Securing external access |
| Whitelisting Public IPs | Yes | No | Limited scenarios |

### Demo: Proxy Setup
- Assign `Cloud SQL Client` role to service account.
- Run proxy on VM/Cloud Shell.
- Connect via local loopback; no whitelist needed.
- Show role permissions prevent unauthorized access.

## SSL Connections and Security
### Overview
Enforce encrypted connections via SSL/TLS to prevent eavesdropping. Require client certificates for high security, or allow proxy-based ephemeral certs.

### Key Concepts
- **Settings**: In instance security, choose "Allow only SSL connections" (trusted client certificates required).
- **Certificates**: Download CA, client cert/key from console.
- **Connection Command**:
  ```bash
  mysql -u root -p --ssl-cert=client-cert.pem --ssl-key=client-key.pem --ssl-ca=server-ca.pem -h PRIVATE_IP -P 3306
  ```
- **Proxy Alternative**: Proxy handles TLS; no manual certs needed.
- **Organization Policies**: Enforce no public IPs via `SQL restrict public IP` policy.

### Demo: Enforcing SSL
- Enable SSL-only connections.
- Attempt connection without certs; fails.
- Use proxy or certs to succeed.
- Show security benefits over plain connections.

## Additional Database Offerings
### Overview
Cloud SQL supports MySQL, PostgreSQL, SQL Server out-of-the-box. For others (e.g., Oracle, DB2, SAP HANA), use VMs or Marketplace images. Migration tools like Database Migration Service handle homogeneous/heterogeneous moves.

### Key Concepts
- **Out-of-Box**: MySQL, PostgreSQL (cheap/open-source); SQL Server (licensed/high-cost).
- **Alternatives**:
  - Oracle: Via Marketplace (Autonomous DB/Exadata) or manual VM.
  - DB2: Manual VM installation with licensing.
  - SAP HANA: Marketplace image on VM.
- **Migration Tools**:
  - ora2pg: Free Oracle-to-PostgreSQL (manual procedures).
  - Striim/Attunity (paid).
  - Database Migration Service: Homogeneous (e.g., Oracle-to-Oracle); emerging heterogeneous support.
- **Bare Metal**: Physical hardware for custom installs.

### Tables
| DB Type | Native Cloud SQL | Alternative | Migration Ease |
|---------|------------------|-------------|----------------|
| MySQL | ✅ | N/A | Easy (built-in) |
| PostgreSQL | ✅ | AlloyDB for advanced | Good (ora2pg) |
| SQL Server | ✅ (paid) | N/A | Medium |
| Oracle | Limited (Autonomous) | VM/Bare Metal | ora2pg + DM Service |
| DB2/SAP HANA | No | VM/Marketplace | Manual |

## Summary
### Key Takeaways
```diff
+ HIGH AVAILABILITY: Enable HA for regional redundancy and automatic failover; test with manual failover.
- PUBLIC IPS: Avoid for security; use PRIVATE IPs with proxies or direct internal connections.
! REPLICATION: Read replicas scale reads and provide DR; promote for cross-region recovery.
+ PROXY: Cloud SQL Proxy ensures secure, authenticated access without whitelisting.
- ENCRYPTION: Require SSL/TLS connections for data protection in transit.
```

### Quick Reference
- **HA Command**: `gcloud sql instances failover INSTANCE_NAME`
- **Replica Promotion**: `gcloud sql instances promote-replica REPLICA_NAME`
- **Proxy Run**: `./cloud_sql_proxy -instances=PROJECT:REGION:INSTANCE=tcp:PORT`
- **SSL Connect**: `mysql -u root -p --ssl-cert=CERT --ssl-key=KEY --ssl-ca=CA -h IP`
- **Connect Internal**: `mysql -h PRIVATE_IP -u root -p`
- **Best Role**: `Cloud SQL Client` for proxy auth.

### Expert Insight
#### Real-world Application
In production, use HA-enabled Cloud SQL with private IPs and proxies for web apps (e.g., banking with read replicas for account fetches). For multi-region, replicas ensure global read performance.

#### Expert Path
Master IAM roles, network peering, and migration services. Practice failovers in dev envs. Certify with Google Cloud Professional Cloud Architect for database design.

#### Common Pitfalls
- Using public IPs leads to breaches; always enforce private/internal.
- Ignoring replication lag; monitor metrics.
- Manual certs in SSL; prefer proxy for simplicity.
- Over-relying on free tools for migrations; test with paid options for complex schemas.

#### Lesser-Known Facts
- Regional disks are automatically used in HA; no manual setup unlike VMs.
- Proxy auto-renews certs every hour, extending security.
- Organization policies can enforce private-only instances.
- Oracle migrations to PostgreSQL via DM Service is Google-native, reducing vendor lock-in.

### Advantages and Disadvantages
**Advantages:**
- Managed service handles HA/failover, reducing ops load.
- Cost-effective for MySQL/PostgreSQL; scalable via replicas.
- Built-in security (SSL, IAM) and backups.

**Disadvantages:**
- Limited core DB types; complex DBs need manual VMs.
- Failover can take minutes; not truly zero-downtime.
- Cross-region replication lags; not ideal for real-time consistency.
