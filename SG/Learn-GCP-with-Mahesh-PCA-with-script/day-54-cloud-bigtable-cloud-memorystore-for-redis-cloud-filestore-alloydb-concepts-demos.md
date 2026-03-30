# Session 54: Cloud BigTable, Cloud Memorystore for Redis, Cloud Filestore, and AlloyDB - Concepts & Demos

## Table of Contents
- [Cloud BigTable](#cloud-bigtable)
- [Cloud Memorystore for Redis](#cloud-memorystore-for-redis)
- [Cloud Filestore](#cloud-filestore)
- [AlloyDB](#alloydb)
- [Product Comparison and Pricing](#product-comparison-and-pricing)

## Cloud BigTable

### Overview
Cloud BigTable is a fully managed NoSQL database service designed for petabyte-scale analytics with ultra-low latency capabilities. It leverages Google's extensive experience powering YouTube, Gmail, and Google Search, making it a battlefield-tested product. Unlike traditional relational databases, it operates as a wide-column database service with sparse tables, optimized for massive data volumes where response times in single-digit milliseconds are critical.

### Key Concepts/Deep Dive
BigTable serves as the NoSQL equivalent to DynamoDB (AWS) or Azure Table Storage (Azure). It excels in scenarios requiring petabyte-scale storage with sub-millisecond retrieval times. Key characteristics include:

- **Schema-less with sparse tables**: Tables don't consume storage space for null values, making it efficient for datasets with many empty columns
- **Wide-column database**: Designed for analytics by denormalizing data into fewer, wider tables with multiple columns per row
- **Row key importance**: Acts as the primary access key; proper design prevents "hotspotting"
- **Column families**: Logical groupings of columns within tables for better organization

#### Use Cases and Applied Scenarios
BigTable is ideal for:
- **Time Series Data**: Weather reports, stock market prices, IoT sensor data
- **Caching and Recommendation Engines**: Powers YouTube recommendations and metadata
- **Graph Databases**: Supports complex relationships between entities
- **Graph DB Implementation**: Enables traversal of connected data points

#### Architecture and Key Differentiators
```diff
+ Fully managed infrastructure with SSD/HDD storage options
+ Appliance mode deployment (requires instance provisioning unlike Cloud Storage's serverless approach)
+ Zonal resource requiring specific zone selection and replication configuration
+ Built on Apache HBase whitepaper adapted from Google's internal systems
```

#### Provisioning Considerations
- **Instance Creation**: Requires cluster creation with specified machine types and storage
- **Storage Options**: SSD (low latency, higher cost) vs HDD (higher latency, lower cost)
- **Zonal Resource**: Single zone per instance; replication adds instances in same region
- **Scaling**: Up to 10x initial node count; no service account required for connections

### Code/Config Blocks

#### CBT Instance Configuration Example
- Create instance with SSD storage: `cbt createtable <table_name>`
- Row key design: Use composite keys (e.g., timestamp + entity ID) to ensure even data distribution
- Column families: Define families like `personal_info` and `album_details` for logical grouping

#### Data Insertion Example
```
cbt set singer:rkey1 personal_info:first_name 'John'
cbt set singer:rkey1 album_info:album_name 'Twinkle'
cbt set singer:rkey1 album_info:release_year '2025'
```

#### Query Commands
```
cbt read singer:rkey1                    # Read specific row
cbt scan singer                          # Full table scan
cbt deletetable singer                   # Delete table
```

#### Instance Creation Parameters
- Basic/Standard tier selection
- Regional replication for high availability
- Auto-scaling configuration (up to 10x initial node count)
- Maintenance window scheduling

### Lab Demos

#### BigTable Instance Setup
1. Navigate to BigTable > Instances > Create Instance
2. Configure cluster with SSD storage in desired zone (e.g., us-central1-a)
3. Enable replication for disaster recovery
4. Set up auto-scaling parameters with minimum/maximum node counts

#### Table Creation and Data Operations
1. Create table with column families:
   ```
   cbt createtable singer
   cbt createfamily singer personal
   cbt createfamily singer albums
   ```

2. Insert data with proper row key design (avoid sequential numbers):
   ```
   cbt set singer:hash_key_001 personal:first_name 'John'
   cbt set singer:hash_key_001 albums:title 'Greatest Hits'
   cbt set singer:hash_key_001 albums:year '2023'
   ```

3. Query data using read/scan operations
4. Configure garbage collection policies for version management
5. Monitor performance using key visualizer to detect hotspots

#### Hotspot Detection
1. Generate load with poorly designed row keys (sequential timestamps)
2. Use Key Visualizer to identify data distribution issues
3. Redesign with composite keys (user_id + reverse_timestamp)
4. Re-test with improved row key strategy

### Tables

| Feature | Cloud BigTable | Cloud Data Store/Firebase |
|---------|----------------|---------------------------|
| Storage Mechanism | Wide-column | Document-based |
| Latency | Single-digit milliseconds | Variable (depends on indexing) |
| Scale | Petabytes | Terabytes max |
| Query Language | CBT commands/HBase | GQL/Query-by-example |
| Indexing | Row key only by default | All columns indexable |
| Optimized For | Low-latency analytics | Fast scanning of non-sequential keys |
| Infrastructure | Fully managed server (infrastructure required) | Serverless |

| Storage Type | Use Case | Latency | Cost |
|-------------|-----------|----------|------|
| SSD | Real-time analytics, IoT data, recommendations | 6-9ms | Higher |
| HDD/ML | Machine learning datasets, batch processing | ~300ms | Lower |
| Replication | Cross-zone/region data durability | Additional latency | Added cost |

## Cloud Memorystore for Redis

### Overview
Cloud Memorystore is a fully managed in-memory Redis database service providing sub-millisecond response times for caching scenarios. It runs on virtual machine infrastructure with Google-managed maintenance, scaling, and high availability features. Unlike traditional disk-based databases, it stores data in RAM for ultra-fast retrieval, making it ideal for dynamic content caching.

### Key Concepts/Deep Dive
Memorystore serves Redis as a managed service with built-in clustering capabilities, backups, and monitoring. Key features include:

- **In-memory storage**: Data resides in RAM for sub-millisecond access
- **Clustered implementation**: Multiple nodes for high availability and scaling
- **VPC-native**: Requires network configuration for connectivity
- **Redis compatibility**: Supports all Redis operations (5.0, 6.0, 7.x versions available)

#### Applied Use Cases
- **Session caching**: Store user profile information during active sessions
- **Page caching**: Cache dynamic content to reduce backend load
- **Leaderboards/Counters**: Implement atomic increment/decrement operations
- **Rate limiting**: Track API call frequencies in real-time

#### Architecture Considerations
```diff
+ VPC connectivity requirement (internal IP only)
- No external IP exposure for security
+ Service account-based authentication for management operations
+ Partitioning and replication across zones/regions
```

### Code/Config Blocks

#### Memorystore Instance Creation
- Regional deployment with SSD-backed virtual machines
- Basic tier (single zone) vs Standard tier (with replicas)
- Version selection (Redis 5.0, 6.0, 7.0+) based on feature requirements

#### Client Connection Commands
```bash
# Install Redis CLI tools
sudo apt install redis-tools

# Connect to instance
redis-cli -h <internal-ip> -p 6379
```

#### Redis Operations Examples
```redis
# Set cache value
SET user:profile:1234 "{\"name\":\"John\",\"email\":\"john@example.com\"}"

# Get cached value
GET user:profile:1234

# Increment counter
INCR visits:homepage

# Set expiration
EXPIRE user:profile:1234 3600

# List all keys (development only)
KEYS *

# Flush cache (nuclear option)
FLUSHALL
```

### Lab Demos

#### Memorystore Instance Setup
1. Navigate to Memorystore > Redis > Create Instance
2. Configure basic/standard tier with regional deployment
3. Select Redis version and memory capacity (1-300GB)
4. Enable authorized VPC network and set maintenance window
5. Create service account for programmatic access

#### Basic Caching Operations
1. Launch Compute Engine VM in same VPC network
2. Install Redis tools: `sudo apt install redis-tools`
3. Connect to Memorystore instance: `redis-cli -h <internal-ip> -p 6379`
4. Implement session caching:
   ```redis
   SET session:user123:profile '{"username":"john","preferences":{"theme":"dark"}}'
   EXPIRE session:user123:profile 1800
   GET session:user123:profile
   ```

5. Demonstrate counter functionality for API rate limiting:
   ```redis
   INCR api:calls:user123:minute
   EXPIRE api:calls:user123:minute 60
   ```

#### Backup and Restore
1. Enable automated backups in instance configuration
2. Perform manual backup: Navigate to instance > Export
3. Specify GCS bucket destination for RDB backup file
4. Import backup: Create new instance with backup as source
5. Verify data integrity post-restore

### Tables

| Configuration | Basic Tier | Standard Tier |
|---------------|------------|---------------|
| Availability Zones | Single zone | Cross-zone (with replicas) |
| SLA | 99.9% | 99.9% |
| Scaling | Auto-scaling (up to 10x) | Auto-scaling (up to 10x) |
| Replication | None | Synchronous replication |
| Cost | Lower | Higher (replica overhead) |

| Redis Version | Key Features | Use Case |
|---------------|---------------|----------|
| 5.0 | Streams, probabilistic data structures | Legacy compatibility |
| 6.0 | ACLs, RESP3 protocol, cluster improvements | Enhanced security |
| 7.0-7.x (Marketplace) | Advanced clustering, JSON support | Enterprise features |

## Cloud Filestore

### Overview
Cloud Filestore is a fully managed NFS (Network File System) service providing shared file storage accessible by multiple VMs simultaneously. It serves as Google Cloud's equivalent to traditional network-attached storage (NAS), optimized for read-write workloads requiring file-like access patterns. Unlike Cloud Storage's object-based approach, Filestore provides hierarchical file system semantics.

### Key Concepts/Deep Dive
Filestore enables file sharing across multiple compute instances with POSIX-compliant file operations. Key characteristics include:

- **Shared file systems**: Multiple readers/writers simultaneously
- **POSIX compliance**: Standard file system operations (chmod, chown, etc.)
- **Performance tiers**: Basic, Standard, Premium, and Enterprise options
- **Network-attached**: Mounted via NFS client tools

#### Applied Scenarios
- **Application configuration**: Shared config files across multiple instances
- **Content repositories**: Centralized file storage with file locking
- **Development environments**: Shared development file systems
- **Web serving**: File-based content management systems

```diff
+ Simultaneous read-write access from multiple instances
+ Hierarchical file organization (vs. Cloud Storage objects)
- Minimum 1TB storage allocation regardless of usage
```

### Code/Config Blocks

#### Filestore Instance Creation
- Zonal deployment (e.g., us-central1-a) with storage class selection
- Basic (HDD) vs Standard/Premium/Enterprise (SSD) performance tiers
- Capacity allocation (1TB minimum to 63.9TB maximum)

#### Client Mounting Commands
```bash
# Install NFS client tools
sudo apt install nfs-common

# Create mount directory
sudo mkdir -p /mnt/filestore

# Mount filestore share
sudo mount <filestore-ip>:/vol1 /mnt/filestore
```

#### File Operations Examples
```bash
# Change ownership and permissions
sudo chown www-data:www-data /mnt/filestore/shared/
sudo chmod 755 /mnt/filestore/shared/

# Create and manipulate files
echo "Configuration data" > /mnt/filestore/config.txt
cp -r /local/data/* /mnt/filestore/backup/

# File system commands
ls -la /mnt/filestore/
df -h /mnt/filestore/
find /mnt/filestore/ -name "*.log"
```

### Lab Demos

#### Filestore Instance Provisioning
1. Navigate to Filestore > Instances > Create Instance
2. Select regional tier (recommended) and SSD storage type
3. Allocate minimum 1TB capacity (paid regardless of utilization)
4. Configure VPC network and authorized IP ranges if needed

#### File Sharing Across Multiple VMs
1. Create two Compute Engine instances in same region/VPC
2. Install NFS client on both instances: `sudo apt install nfs-common`
3. Create mount directories on both VMs
4. Mount Filestore share on primary VM and create test files
5. Mount on secondary VM and demonstrate read-write access
6. Show concurrent file operations and file locking behavior

#### Performance Monitoring
1. Generate file I/O load using benchmarks (dd, fio tools)
2. Monitor latency differences between regional and zonal deployments
3. Compare performance with Cloud Storage mounting (FUSE)
4. Demonstrate NFS vs object storage access patterns

### Tables

| Storage Class | Performance | Minimum Capacity | Use Case |
|---------------|-------------|------------------|----------|
| Basic HDD | Moderate throughput/low IOPS | 1TB | Archive/general file sharing |
| Standard SSD | Balanced performance | 2.5TB | Standard applications |
| Premium SSD | High IOPS/throughput | 2.5TB | Performance-critical workloads |
| Enterprise SSD | Highest performance | 2.5TB | Database workloads, analytics |

| Deployment Type | High Availability | Latency Impact | Cost |
|-----------------|-------------------|----------------|------|
| Zonal | Single zone | Lowest | Base price |
| Regional | Cross-zone redundancy | Moderate (synchronous replication) | 2-3x base price |

## AlloyDB

### Overview
AlloyDB is a fully managed PostgreSQL-compatible database service combining relational database features with analytical processing capabilities (OLTP + OLAP). It provides PostgreSQL compatibility while delivering horizontal scalability and advanced analytics features not available in standard Cloud SQL PostgreSQL instances. Designed for enterprise workloads requiring both transactional consistency and analytical performance.

### Key Concepts/Deep Dive
AlloyDB bridges the gap between transactional databases (like Cloud SQL) and analytical databases (like BigQuery) by supporting both workloads in a single service. Key differentiators include:

- **PostgreSQL compatibility**: Direct migration path from on-premises PostgreSQL
- **Analytical processing**: In-database analytics without ETL processes  
- **Vertical and horizontal scaling**: Node scaling combined with read pool expansion
- **Regional deployment**: Cross-zone high availability

#### Applied Use Cases
- **Unified data platform**: Replace separate OLTP/OLAP systems
- **Real-time analytics**: Process both transactions and analytics in real-time
- **PostgreSQL migrations**: Direct lift-and-shift from on-premises PostgreSQL
- **Enterprise applications**: Application requiring advanced optimizations

```diff
+ Built-in analytical functions avoiding separate ETL pipelines
+ Intelligent query optimization with ML-driven performance
- Fully managed columnar storage optimizations
+ Multi-region read replicas for global applications
```

### Code/Config Blocks

#### AlloyDB Cluster Creation
- Cluster-based architecture with primary and read pool instances
- PostgreSQL version selection (15, 14, 13, etc.)
- Capacity tiers: 2-128 vCPU, proportional memory allocation
- Regional deployment with automatic zone selection

#### Database Operations Examples
```sql
-- Standard PostgreSQL commands work natively
CREATE TABLE employees (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  department VARCHAR(50),
  salary DECIMAL(10,2)
);

INSERT INTO employees (name, department, salary) 
VALUES ('John Doe', 'Engineering', 95000);

-- Analytical queries execute in-database
SELECT department, AVG(salary) as avg_salary,
       COUNT(*) as employee_count
FROM employees
GROUP BY department;

-- Advanced analytics features
-- Query historical data versions
-- Machine learning capability integration
-- Vector search and similarity matching
```

#### AlloyDB-Specific Optimizations
```sql
-- Intelligent query optimization hints
EXPLAIN ANALYZE SELECT * FROM large_table WHERE condition;

-- Built-in analytical functions
SELECT date_trunc('month', created_at) as month,
       COUNT(*) as transactions,
       SUM(amount) as total_amount
FROM transactions
WHERE created_at >= '2024-01-01'
GROUP BY month;
```

### Lab Demos

#### AlloyDB Cluster Setup
1. Navigate to AlloyDB > Clusters > Create Cluster
2. Select PostgreSQL version and compute capacity
3. Configure network settings (VPC, authorized networks)
4. Enable automated backups and maintenance windows
5. Create primary instance and optional read pools

#### Query Execution and Analytics
1. Connect using AlloyDB Studio web interface
2. Create sample tables and insert test data
3. Execute transactional queries (OLTP operations)
4. Perform analytical queries without external processing:
   - Aggregation functions
   - Window functions
   - Advanced grouping and filtering
5. Compare performance with traditional Cloud SQL PostgreSQL

#### Read Pool Scaling Demonstration
1. Create cluster with read pool instances in different zones
2. Simulate read-heavy workload distribution
3. Monitor query performance across instances
4. Demonstrate automatic scaling of read pools based on load
5. Test cross-region read replica access for global applications

### Tables

| Feature | AlloyDB | Cloud SQL PostgreSQL | Spanner |
|---------|---------|----------------------|---------|
| Query Language | PostgreSQL SQL | PostgreSQL SQL | GoogleSQL (subset) |
| Analytics Built-in | Yes (columnar optimizations) | Limited | No (separate BigQuery integration) |
| PostgreSQL Compatibility | Full PostgreSQL | Full PostgreSQL | Limited (no stored procedures, UDFs) |
| Scaling | Vertical + Read Pools | Vertical | Horizontal (nodes) |
| Migration Path | Easy (PostgreSQL native) | Easy (PostgreSQL native) | Complex (schema conversion required) |
| Cost Structure | Higher for analytics | Standard DB costs | Premium global scalability |

| Instance Type | vCPU Range | Memory | Storage | Use Case |
|---------------|------------|--------|---------|----------|
| Primary Instance | 2-128 | Proportional to vCPU | Up to 128TB | OLTP + Analytics |
| Read Pool Instance | 1-96 | Proportional to vCPU | Read-only access | Read scaling |

## Product Comparison and Pricing

### Overview
When evaluating storage and database solutions, consider data structure, latency requirements, scale needs, and operational complexity. Cost is typically proportional to performance and management level (serverless < fully managed infrastructure). Key decision factors include:

- **Data Type**: Structured (relational) vs Unstructured (object storage) vs Document-based (NoSQL)
- **Access Pattern**: Sequential (file shares) vs Random (block storage) vs Object (universal) vs Key-value (caches)
- **Performance Requirements**: Sub-millisecond (cache/memory) vs Milliseconds (SSD) vs Seconds (HDD/object)
- **Scale Needs**: Terabytes (most services) vs Petabytes (BigTable, object storage)

### Key Concepts/Deep Dive
```diff
+ Google Cloud Storage: Lowest cost, unlimited scale, object storage
- Memorystore: Highest cost per GB, lowest latency, RAM-based
+ BigTable: Balanced cost for scale, HDD option available
- FileStore: Premium pricing for shared file systems
```

#### Cost Comparison (300GB Example)

| Service | Monthly Cost | Cost/GB | Notes |
|---------|-------------|----------|--------|
| Google Cloud Storage | $5.50 | $0.018/GB | Serverless, unlimited scale |
| BigQuery Storage | $5 | Free tier | Analytical processing additional |
| Persistent Disk (Regional HDD) | $22 | $0.073/GB | Block storage, zones/region |
| Persistent Disk (Regional SSD) | $94 | $0.313/GB | High-performance block storage |
| Cloud SQL | $146 | $0.487/GB | Full database management |
| BigTable | $200+ | $0.667+/GB | Dedicated hardware required |
| FireStore | $163 | $0.543/GB | File sharing capabilities |
| Spanner | $740 | $2.467/GB | Global scalability overhead |
| Memorystore Redis | $3,000+ | $10+/GB | Premium in-memory pricing |
| FileStore | $460 (1TB min) | $0.46/GB | Shared file storage |

#### Decision Tree Guidelines
```diff
+ Unstructured data → Google Cloud Storage
+ Time series/IoT → BigTable or Cloud Storage (with analytics)
+ Caching/dynamic content → Memorystore Redis
+ Shared files/simultaneous access → FileStore
+ Relational data (non-mission critical) → Cloud SQL
+ Relational data (global/distributed) → Spanner
+ Unified OLTP + OLAP → AlloyDB
```

### Tables

| Requirement | Recommended Service | Alternatives |
|-------------|---------------------|--------------|
| Lowest cost unlimited storage | Google Cloud Storage | BigQuery (with processing cost) |
| Lowest latency caching | Memorystore Redis | BigTable (disk-based) |
| Mission-critical relational | Spanner | AlloyDB, Cloud SQL |
| File sharing/analytics | AlloyDB | Spanner + BigQuery |
| Attached storage/compute | Persistent Disk | FileStore |
| Object storage + processing | Google Cloud Storage + BigQuery | FileStore + custom compute |

## Summary

### Key Takeaways
```diff
+ Cloud BigTable: Petabyte-scale NoSQL with single-digit millisecond latency, designed for time series and recommendation engines
- Avoid BigTable for volumes under 1TB - performance/cost inefficiency
+ Cloud Memorystore: Sub-millisecond in-memory Redis with VPC connectivity, ideal for session caching and real-time counters
- No external IP connectivity - requires VPC-based client access
+ Cloud FileStore: NFS-compatible shared storage for simultaneous read-write operations, 1TB minimum allocation
- Requires NFS client installation and network proximity for optimal performance
+ AlloyDB: PostgreSQL-compatible service uniting OLTP and OLAP capabilities in single platform
- Higher cost justified for unified analytics/transaction processing needs
+ Cost hierarchy: Google Cloud Storage <$1/TB, BigTable/Spanner $0.50-2.50/GB, Memorystore $10+/GB
- Always validate against use case: latency, scale, data structure, and operational complexity requirements
```

### Expert Insight

#### Real-world Application
In enterprise environments, storage selection follows a tiered approach: Cloud Storage handles bulk archival, FileStore manages shared configurations, Memorystore caches frequently accessed data, BigTable supports analytical workloads at petabyte scale, and AlloyDB unifies transactional and analytical processing for complex applications. Production implementations often combine multiple services - for example, using Memorystore as a Redis cache fronting AlloyDB with BigTable handling historical analytics data.

#### Expert Path
Master these products by understanding their architectural foundations: BigTable's roots in Google File System infrastructure, Memorystore's Redis implementations, FileStore's NFS compliance, and AlloyDB's PostgreSQL extensions. Focus on performance optimization through proper row key design, efficient caching strategies, and network proximity. Advanced expertise comes from mastering migration scenarios, particularly BigTable's Apache HBase compatibility and AlloyDB's PostgreSQL compatibility.

#### Common Pitfalls
- **BigTable row key misdesign**: Leads to hotspotting and poor performance
- **Memorystore network isolation**: Forgetting VPC requirements blocks connectivity  
- **FileStore minimum capacity waste**: Allocated 1TB minimum even for minimal usage
- **Service tier confusion**: Mixing serverless (Cloud Storage) vs infrastructure-managed services
- **Cost underestimation**: Memorystore's $3000+/month for 300GB vs Cloud Storage's $5.50
- **Migration complexity**: Underestimating BigTable HBase migration or AlloyDB PostgreSQL conversions

#### Lesser Known Things About This Topic
- BigTable's whitepaper source code became Apache HBase, enabling hybrid Cloud/on-premises architectures
- Memorystore can serve as vector database for AI/ML similarity searches beyond traditional caching
- FileStore performance degrades significantly with cross-region client connections (Singapore client + US Filestore = high latency)
- AlloyDB leverages machine learning for query plan optimization, improving performance over time
- Google Cloud Storage powers secondary storage for BigTable backups and staging areas
- Spanner pricing scales exponentially due to global synchronization overhead, often making AlloyDB more cost-effective for regional workloads

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
