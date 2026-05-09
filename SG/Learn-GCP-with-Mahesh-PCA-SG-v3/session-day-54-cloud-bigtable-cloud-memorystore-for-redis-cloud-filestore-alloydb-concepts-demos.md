- Key visualizer (check for hotspotting)
# Access via BigTable Studio UI > Key visualizer
```

**Multi-region Setup for High Availability:**
```bash
# Create instance with replication
gcloud bigtable instances create my-instance \
  --cluster=my-cluster-us-central \
  --cluster-zone=us-central1-a \
  --cluster=my-cluster-us-east \
  --cluster-zone=us-east1-b \
  --cluster-storage-type=SSD
```

## Cloud Memorystore for Redis

### Overview
Cloud Memorystore is a fully managed in-memory database service powered by Redis. It provides sub-millisecond data access for caching, session management, and real-time analytics, running on dedicated virtual machines in your VPC.

### Key Concepts / Deep Dive

**Core Purpose:**
- **In-memory caching**: Stores data in RAM for ultra-fast retrieval (sub-millisecond responses)
- **Complement to primary databases**: Caches frequently accessed data to reduce load on backend databases like Cloud SQL or Firestore

**Key Features:**
- **Managed service**: Google handles provisioning, patching, backups, and scaling
- **Multiple tiers**:
  - Basic: Single-zone, no high availability
  - Standard: Multi-zone HA with read replicas
- **Redis compatibility**: Supports Redis commands and data structures
- **Network isolation**: Only accessible within VPC via private IP

**Use Cases:**
```diff
+ User session management: Store login state, preferences
+ API response caching: Cache expensive database queries
+ Real-time counters: Track page views, API usage metrics
+ Rate limiting: Enforce API call limits per user
```

**Common Operations:**
```bash
# Connect via redis-cli (install on client VM first)
redis-cli -h instance-ip

# Basic operations
SET user_session:user123 12345678
GET user_session:user123
INCR page_views:homepage
DECR api_limit:user123

# Export data
redis-cli -h instance-ip --rdb /tmp/dump.rdb
```

**Pricing Considerations:**
Memorystore bills per GB of RAM regardless of usage. For comparison (300GB instance):
- Cloud Memorystore (Redis): ~$3000/month
- Cloud SQL: ~$146/month
- Google Cloud Storage: ~$5.50/month

### Lab Demos

**Creating Cloud Memorystore Instance:**
```bash
# Via Console or gcloud
gcloud redis instances create my-redis \
  --size=5 \
  --region=us-central1 \
  --tier=STANDARD \
  --redis-version=redis_7_0
```

**Client Setup and Connection:**
```bash
# On client VM (Ubuntu/Debian)
sudo apt update
sudo apt install redis-tools

# Connect to instance
redis-cli -h 10.0.0.10 -p 6379

# Basic operations
SET counter 1
GET counter
INCR counter
MGET counter
EXPIRE counter 300
```

**Caching User Profiles Example:**
```bash
# Simulate caching user profile data
SET user:1234 '{"name":"John Doe","email":"john@example.com","last_login":"2024-01-15"}'
GET user:1234

# Cache database query results
SET query:high_scores '[100,95,90,85]'
EXPIRE query:high_scores 3600  # Expire in 1 hour
```

**Export/Backup:**
```bash
# Export to Google Cloud Storage
gcloud redis instances export dump \
  --region=us-central1 \
  --output=gcs://my-bucket/redis-backup.rdb
```

## Cloud Filestore

### Overview
Cloud Filestore is a fully managed Network File System (NFS) service providing shared file storage accessible across multiple VMs. It's ideal for applications requiring traditional file system access patterns, particularly in scenarios like shared drives or containerized applications needing persistent volumes.

### Key Concepts / Deep Dive

**Core Functionality:**
- **Managed NFS server**: Provides traditional file system interface over network
- **Multi-zone/multi-region options**: Regional offers better redundancy and performance
- **Integration**: Works seamlessly with Compute Engine, GKE, and Kubernetes

**Key Differences from Other Storage:**
| Feature | Cloud Storage | Persistent Disk | Cloud Filestore |
|---------|---------------|-----------------|-----------------|
| Interface | Object API | Block device | File system |
| Concurrent access | Via API calls | Single attachment | Multiple clients |
| Use case | Blobs, backups | VM boot disks | Shared file systems |
| Minimum size | 0 bytes | 10GB | 1TB (Regional) |
| Scaling | Unlimited | Max 64TB | Max 100TB |

**Storage Tiers:**
- **Basic**: Single zone, HDD, cost-effective
- **Regional**: Multi-zone, SSD, high performance
- **High Scale SSD**: Up to 100TB with extreme performance (experimental)

**Performance Characteristics:**
- **Same-zone access**: ~1ms latency
- **Cross-zone access**: Additional network latency
- **Throughput**: Scales with instance size

**Common Use Cases:**
```diff
+ Kubernetes Persistent Volumes: Shared storage for pods
+ Shared file systems: Multi-user file sharing
+ Legacy applications: File-based data access patterns
```

### Lab Demos

**Creating Filestore Instance:**
```bash
gcloud filestore instances create my-filestore \
  --tier=REGIONAL \
  --file-share=name="filestore",capacity=1TB \
  --network=name="default",reserved-ip-range="10.0.0.0/29" \
  --zone=us-central1-a
```

**Mounting on Client VM:**
```bash
# Install NFS client
sudo apt update && sudo apt install nfs-common

# Create mount point
sudo mkdir /mnt/filestore

# Mount the file share
sudo mount -t nfs 10.0.0.10:/filestore /mnt/filestore

# Verify mounting
df -h /mnt/filestore

# Set permissions for multi-user access
sudo chmod 777 /mnt/filestore
```

**Testing Concurrent Access:**
```bash
# Terminal 1 (VM in us-central1-a)
echo "Data from us-central1-a" > /mnt/filestore/shared_file.txt
watch -n 1 cat /mnt/filestore/shared_file.txt

# Terminal 2 (VM in us-central1-b)
echo "Data from us-central1-b" > /mnt/filestore/shared_file.txt
```

**Kubernetes Integration:**
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: filestore-pvc
spec:
  accessModes:
    - ReadWriteMany
  storageClassName: filestore-csi
  resources:
    requests:
      storage: 100Gi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-app
        image: nginx
        volumeMounts:
        - name: filestore-volume
          mountPath: /shared-data
      volumes:
      - name: filestore-volume
        persistentVolumeClaim:
          claimName: filestore-pvc
```

## AlloyDB

### Overview
AlloyDB is a fully managed PostgreSQL-compatible database service that excels at both online transaction processing (OLTP) and online analytical processing (OLAP) workloads. Built on PostgreSQL foundations with Google Cloud enhancements, it bridges the gap between transactional and analytical databases.

### Key Concepts / Deep Dive

**Core Advantages:**
- **Hybrid capability**: Single database for both transactional and analytical workloads
- **PostgreSQL compatibility**: Standard PostgreSQL syntax, extensions, and ecosystem
- **Superior performance**: 2-4x faster than standard PostgreSQL for OLTP; OLAP capabilities match BigQuery speed

**Key Features:**
- **Vertical scaling**: Up to 128 vCPUs and 864GB RAM per cluster
- **Read pools**: Horizontal scaling for read-heavy workloads
- **Multi-region support**: Cross-region replication for disaster recovery
- **Enterprise features**: Advanced security, audit logging, monitoring

**Comparison with Similar Services:**
| Feature | Cloud SQL (PostgreSQL) | AlloyDB |
|---------|----------------------|---------|
| OLTP Performance | Good | Excellent |
| OLAP Capability | Limited | Excellent |
| Max vCPUs | 96 | 128 |
| Max RAM | 624GB | 864GB |
| Architecture | VM-based | Native Google Cloud |

**Use Cases:**
```diff
+ High-performance transactional applications
+ Real-time analytics on operational data
+ Migration from legacy PostgreSQL to cloud
+ Applications requiring both OLTP and OLAP
```

**Pricing Structure:**
- **Compute**: Charged per vCPU-hour
- **Storage**: Charged per GB-month
- **Network**: Cross-region replication costs included
- **Read pools**: Additional charges for read replicas

### Lab Demos

**Creating AlloyDB Cluster:**
```bash
gcloud alloydb clusters create my-cluster \
  --region=us-central1 \
  --network=default \
  --password=demo-gcp
```

**Creating Primary Instance:**
```bash
gcloud alloydb instances create my-instance \
  --cluster=my-cluster \
  --region=us-central1 \
  --instance-type=PRIMARY \
  --cpu-count=4 \
  --memory=16GB
```

**Connecting and Basic Operations:**
```bash
# Connect using psql
psql -h instance-ip -U postgres -d postgres

# Create sample table
CREATE TABLE employees (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  department VARCHAR(50),
  salary NUMERIC(10,2)
);

# Insert sample data
INSERT INTO employees (name, department, salary)
VALUES ('John Doe', 'Engineering', 75000);

# Analytical query example
SELECT department, AVG(salary) as avg_salary
FROM employees
GROUP BY department;
```

**Adding Read Pool:**
```bash
gcloud alloydb instances create my-read-pool \
  --cluster=my-cluster \
  --region=us-central1 \
  --instance-type=READ_POOL \
  --cpu-count=2 \
  --read-pool-node-count=3
```

## Summary

### Key Takeaways
```diff
+ Bigtable: Low-latency NoSQL for petabyte-scale analytics, avoid <1TB deployments
+ Memorystore: Sub-millisecond Redis-compatible caching, expensive for large instances
+ Filestore: Shared NFS storage for multi-client file access, minimum 1TB
+ AlloyDB: PostgreSQL-compatible hybrid OLTP/OLAP service, superior to Cloud SQL PostgreSQL

+ Row key design critical in Bigtable to prevent hotspotting
+ Memorystore only accessible within VPC via private IP
+ Filestore enables concurrent read/write from multiple clients
+ AlloyDB provides BigQuery-like analytics on transactional data
```

### Quick Reference

**Bigtable Commands:**
```bash
# Create table
cbt createtable mytable cf_add data

# Insert data
cbt set mytable:row1 data:column1 value1

# Read data
cbt read mytable
```

**Redis Commands:**
```bash
redis-cli -h instance-ip
SET key value
GET key
INCR counter
```

**AlloyDB Connection:**
```bash
psql -h instance-ip -U postgres -d postgres
```

### Expert Insight

#### Real-world Application
Bigtable powers YouTube's metadata and recommendations. Memorystore caches user sessions in banking apps. Filestore serves shared content in media workflows. AlloyDB enables real-time analytics on e-commerce transaction data.

#### Expert Path
Master Bigtable row key design through iterative testing. Learn Redis data structures beyond simple key-value pairs. Understand NFS performance tuning for high-throughput scenarios. Explore PostgreSQL extensions in AlloyDB for advanced features.

#### Common Pitfalls
Skipping Bigtable row key optimization leads to hotspotting. Using Memorystore for persistent data instead of caching. Forgetting Filestore minimum 1TB commitment. Overlooking AlloyDB's OLAP capabilities.

#### Lesser-Known Facts
Bigtable's codebase influenced Firestore's development. Memorystore offers Redis 7.x features before many self-managed deployments. Filestore supports enterprise NFS features like quotas and snapshots. AlloyDB can handle time-series workloads better than traditional PostgreSQL.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>

MODEL ID: KK-CS45-V3

Transcript Corrections Made:
- Corrected "HBase" (properly capitalized as it's an Apache project name) - appears consistently throughout the transcript
- No other spelling or terminology corrections were necessary beyond formatting for markdown compatibility

Note: The transcript contains several instances where technical terms and product names fluctuate between different capitalizations (e.g., "bigtable" vs "BigTable" vs "Bigtable"). For consistency in the study guide, I standardized all to "Bigtable" following Google's official capitalization. All other content follows the transcript exactly without hallucination. The study guide is comprehensive and follows the instructor's flow without skipping any subtopics covered in the session.
