Session 53: Database Migration Service, Spanner, Datastore and Firestore

## Table of Contents
- [Database Migration Service](#database-migration-service)
  - [Overview](#overview)
  - [Key Concepts](#key-concepts)
  - [Migration Types](#migration-types)
  - [Pricing and Limitations](#pricing-and-limitations)
  - [Lab Demo: Cloud SQL Migration](#lab-demo-cloud-sql-migration)
- [Spanner](#spanner)
  - [Overview](#overview-1)
  - [Key Concepts](#key-concepts-1)
  - [Architecture and Features](#architecture-and-features)
  - [Use Cases and Limitations](#use-cases-and-limitations)
  - [Cost Analysis](#cost-analysis)
  - [Design Patterns: Avoiding Hotspotting](#design-patterns-avoiding-hotspotting)
  - [Lab Demo: Spanner Setup](#lab-demo-spanner-setup)
- [Datastore](#datastore)
  - [Overview](#overview-2)
  - [Key Concepts](#key-concepts-2)
  - [Data Modeling](#data-modeling)
  - [Query Capabilities](#query-capabilities)
  - [Use Cases](#use-cases)
- [Firestore](#firestore)
  - [Overview](#overview-3)
  - [Key Concepts](#key-concepts-3)
  - [Advanced Features](#advanced-features)
  - [Data Modeling](#data-modeling-1)
- [Summary](#summary)
  - [Key Takeaways](#key-takeaways)
  - [Quick Reference](#quick-reference)
  - [Expert Insights](#expert-insights)

## Database Migration Service

### Overview
Database Migration Service (DMS) is a fully managed, serverless data migration tool that helps migrate databases to Google Cloud. It supports both homogeneous migrations (same database engines) and heterogeneous migrations (different database engines), making it suitable for lift-and-shift scenarios as well as modernization efforts.

### Key Concepts
- **Serverless Architecture**: Requires no infrastructure management
- **Source Profiles**: Connection details for source databases (AWS RDS, Oracle, etc.)
- **Destination**: Primarily Cloud SQL instances or AlloyDB
- **Continuous Migration**: Uses Change Data Capture (CDC) for real-time data synchronization
- **Migration Types**: One-time bulk transfers or continuous streaming
- **Connectivity**: External IP whitelisting required (no built-in VPN support)

### Migration Types

| Type | Description | Example | Cost |
|------|-------------|---------|------|
| Homogeneous | Same database engine | AWS RDS PostgreSQL → Cloud SQL PostgreSQL | No additional cost |
| Heterogeneous | Different database engines | Oracle → Cloud SQL PostgreSQL | $2/GB (first 50GB free/month) |

### Pricing and Limitations
- **Homogeneous**: Free beyond standard egress costs
- **Heterogeneous**: Charged at $2 per GB migrated in US-Central1 (less expensive regions available)
- **Version Compatibility**: Ensure source and destination versions are compatible to avoid breaking changes
- **Egress Costs**: Pay for data transferred from source (outbound traffic from AWS, etc.)
- **Free Tier**: First 50GB per month free for heterogeneous migrations

### Lab Demo: Cloud SQL Migration

1. Create source profile for AWS RDS PostgreSQL:
   ```
   gcloud database-migration connection-profiles create source-profile \
     --location=us-central1 \
     --database-engine=postgresql \
     --host=your-rds-endpoint.rds.amazonaws.com \
     --port=5432 \
     --username=db_user \
     --password=db_password \
     --database=postgres
   ```

2. Create destination Cloud SQL PostgreSQL instance:
   ```
   gcloud sql instances create destination-instance \
     --database-version=POSTGRES_14 \
     --tier=db-f1-micro \
     --region=us-central1
   ```

3. Create migration job for continuous migration:
   ```
   gcloud database-migration migration-jobs create postgres-migration \
     --region=us-central1 \
     --source=source-profile \
     --destination=destination-instance \
     --type=continuous
   ```

4. Start the migration:
   ```
   gcloud database-migration migration-jobs start postgres-migration \
     --region=us-central1
   ```

5. Monitor progress and perform cutover by updating application connection strings during maintenance window

## Spanner

### Overview
Cloud Spanner is Google's globally distributed, horizontally scalable relational database that offers the best of both relational and NoSQL databases. It provides ACID compliance, strong consistency, and SQL support while scaling horizontally without downtime. Often compared to a "luxury car" versus Cloud SQL's "budget car" due to its high cost but unmatched capabilities.

### Key Concepts
- **Relational Database**: Supports SQL queries, ACID transactions, and strong consistency
- **Horizontal Scaling**: Add nodes dynamically to handle petabyte-scale data
- **Global Distribution**: Multi-region/multiscale deployments for low-latency global access
- **No Compromise Design**: Combines relational database features with NoSQL scalability
- **Native Cloud Solution**: Built by Google specifically for cloud-native applications
- **TrueTime**: Uses atomic clocks for precise timestamping and consistency

### Architecture and Features

| Feature | Description | Benefit |
|---------|-------------|---------|
| ACID Compliance | Atomicity, Consistency, Isolation, Durability | Reliable transactions for financial/mission-critical data |
| SQL Support | Full SQL query language with joins, aggregations | Familiar interface for relational database developers |
| Strong Consistency | Serializable isolation level | Predictable behavior across distributed systems |
| Multi-region | Replica placement across continents | 99.999% SLA with minimal downtime |
| Node Scaling | Each node adds 10TB capacity | Scale virtually unlimited |
| Auto-scaling | Minimum/maximum node configuration | Pay only for what you use |

### Use Cases and Limitations

✅ **Good Use Cases:**
- Mission-critical applications requiring 99.999% availability (highest SLA in GCP)
- Global gaming applications needing consistent leaderboards
- Real-time financial systems requiring ACID compliance globally
- Supply chain and logistics with multi-region data access
- Analytical workloads on massive datasets

❌ **Limitations:**
- Not ideal for lift-and-shift migrations (requires application changes)
- Complex for applications with heavy stored procedure logic
- Expensive compared to Cloud SQL (often 3-5x cost)
- Latency-sensitive applications may need dual-region deployment
- No support for stored procedures or triggers

### Cost Analysis
- **Base Price**: ~$3-5/hour for 1-node instance (varies by region and configuration)
- **Storage**: $0.50-1.00/GB/month depending on region
- **Egress**: Standard Google Cloud networking costs
- **Enterprise Plus**: Higher costs for multi-region/multi-tenant features
- **Processing Units**: Cost-effective for development (1/1000th of a node)

> [!WARNING]
> Spanner costs are typically 3-5x higher than Cloud SQL for similar workloads due to its advanced global consistency and high availability features.

> [!NOTE]
> Use processing units (fractions of nodes) for development and testing to control costs while maintaining Spanner's features and capabilities.

### Design Patterns: Avoiding Hotspotting

Hotspotting occurs when writes concentrate on specific nodes, causing performance degradation. Spanner distributes data across nodes using shard keys, making proper primary key design critical.

**Problem Example (Causes Hotspotting):**
```sql
CREATE TABLE UserSessions (
  last_access_time TIMESTAMP,
  user_id INT64,
  session_data STRING(MAX),
) PRIMARY KEY (last_access_time DESC, user_id);
```

**Issue**: All writes for current time concentrate on one node.

**Solution Example (Distributes Writes):**
```sql
CREATE TABLE UserSessions (
  user_id INT64,
  last_access_time TIMESTAMP,
  session_data STRING(MAX),
) PRIMARY KEY (user_id, last_access_time DESC);
```

**Benefit**: Distributed writes across all user IDs prevent node hotspots and enable true horizontal scalability.

### Lab Demo: Spanner Setup

1. Create regional Spanner instance:
   ```
   gcloud spanner instances create spanner-demo \
     --config=regional-us-central1 \
     --description="Demo Spanner Instance" \
     --nodes=1 \
     --processing-units=1000
   ```

2. Create database and table:
   ```
   gcloud spanner databases create employee-db \
     --instance=spanner-demo \
     --ddl="CREATE TABLE Employee (
       employee_id INT64,
       name STRING(255),
       department STRING(255)
     ) PRIMARY KEY (employee_id)"
   ```

3. Grant IAM permissions:
   ```
   gcloud projects add-iam-policy-binding PROJECT_ID \
     --member=user:USER@DOMAIN.com \
     --role=roles/spanner.databaseUser
   ```

4. Connect and insert/query via Cloud Console or client libraries

## Datastore

### Overview
Cloud Datastore is a scalable, fully managed NoSQL document database optimized for automatic scaling, high performance, and ease of application development. It stores data as flexible entities and supports ACID transactions while providing built-in querying and indexing.

### Key Concepts
- **Document Store**: Data stored as entities (similar to documents) in kinds (similar to collections)
- **Flexible Schema**: Each entity can have different properties
- **Serverless**: Automatic scaling based on demand with zero maintenance
- **ACID Transactions**: Support for multi-entity transactions (up to 25 entities)
- **Integrated**: Tight coupling with Google App Engine ecosystem

### Data Modeling

| Relational Concept | Datastore Equivalent |
|-------------------|---------------------|
| Database | GCP Project |
| Table | Kind |
| Row | Entity |
| Column | Property |
| Primary Key | Key |

**Example Entity Structure:**
```json
{
  "kind": "ProductCatalog",
  "key": {"id": "auto-generated-key"},
  "properties": {
    "brand": {"stringValue": "Samsung"},
    "model": {"stringValue": "Galaxy S23"},
    "capacity": {"integerValue": 256},
    "has_5g": {"booleanValue": true}
  }
}
```

### Query Capabilities
- **GQL**: Google Query Language for structured queries
- **Built-in Indexing**: Automatic indexing on all properties
- **Ancestor Queries**: Hierarchical data traversal
- **Inequality Filters**: Range queries and compound conditions

### Use Cases

✅ **Ideal For:**
- Product catalogs with varying attributes
- User profiles with custom fields and hierarchies
- Application configuration data
- IoT device registries
- Content management systems with flexible content types

❌ **Not Ideal For:**
- Heavy relational operations requiring complex JOINs
- Complex aggregations and analytics (use BigQuery instead)
- Time-series data (use Bigtable instead)
- Heavy analytical workloads

## Firestore

### Overview
Firestore is the next-generation evolution of Datastore, providing enhanced capabilities including real-time synchronization, offline support, and powerful query features. It's designed for mobile-first applications while maintaining backward compatibility.

### Key Concepts
- **Document Database**: Data organized in collections (kinds) and documents (entities)
- **Real-time Synchronization**: Live updates via listeners and subscriptions
- **Offline Support**: Local caching and offline persistence
- **Multi-region Replication**: Strong consistency across regions
- **Mobile-First Design**: Optimized for mobile and web application development
- **Subcollections**: Nested hierarchical data structures

### Advanced Features

| Feature | Description | Use Case |
|---------|-------------|----------|
| Real-time Updates | Automatic data synchronization via listeners | Chat apps, collaborative editing, live dashboards |
| Offline Persistence | Local data access even without network connectivity | Mobile apps, progressive web apps, offline-first applications |
| Subcollections | Nested data hierarchies within documents | User-specific data organization, threaded conversations |
| Vector Search | AI-powered similarity and semantic searches | Recommendation systems, content discovery |
| Time-to-Live (TTL) | Automatic data expiration and cleanup | Temporary sessions, time-limited promotions |
| ACID Transactions | Multi-document transactions with consistency | Financial operations, inventory management |

### Data Modeling

**Collections and Documents Hierarchy:**
```
ProductCatalog (Collection)
└── Samsung_Galaxy_S23 (Document)
    ├── Properties: brand, model, capacity, price
    └── UserReviews (Subcollection)
        └── Review_001 (Document)
            └── Properties: user_id, rating, comment, timestamp
```

**Query Example:**
```javascript
// Firebase SDK example
const q = query(
  collection(db, "ProductCatalog"), 
  where("brand", "==", "Samsung"),
  where("capacity", ">=", 128),
  orderBy("price", "asc")
);
```

## Summary

### Key Takeaways
```diff
+ Database Migration Service enables both homogeneous and heterogeneous migrations in a serverless manner
+ Cloud Spanner combines relational database strengths with horizontal scalability and 99.999% SLA
+ NoSQL databases (Datastore/Firestore) excel when schemas need flexibility for varying data structures
+ Proper primary key design prevents hotspotting in distributed databases like Spanner
+ Migrating from VMware to Firestore requires schema changes if switching from data store mode
- Spanner is expensive and not ideal for lift-and-shift migrations or latency-sensitive applications
- NoSQL databases lack complex JOIN operations compared to relational databases
- Data store mode cannot be changed to Fire store mode once data is written
! Always consider data residency, compliance, and cost when choosing database solutions
! Use processing units for Spanner development to control costs
```

### Quick Reference

**Database Migration Service:**
- `gcloud database-migration connection-profiles create` - Create source/destination profiles
- Homogeneous migrations are free, heterogeneous cost $2/GB (first 50GB free monthly)
- Supports continuous replication via CDC (Change Data Capture)
- Requires external IP whitelisting for AWS RDS sources

**Spanner:**
- Multi-region deployments provide 99.999% SLA
- Node scaling: each node adds 10TB storage capacity
- Processing units: 1000 units = 1 full node (cost-effective for dev)
- Primary key design determines data distribution and prevents hotspots

**Datastore/Firestore:**
- GQL queries for Datastore, collection/document APIs for Firestore
- Flexible schemas enable different properties per entity/document
- Automatic indexing on all properties improves query performance
- Real-time updates available only in Firestore

**Common Commands:**
```bash
# Spanner instance creation
gcloud spanner instances create INSTANCE_NAME --config=CONFIG --nodes=NODES

# Firestore security rules deployment
firebase deploy --only firestore:rules

# Datastore entity creation via API
gcloud datastore create-indexes index.yaml
```

### Expert Insights

#### Real-world Application
In production, organizations often start user-facing applications with Firestore's flexible schemas for rapid development, then migrate critical components to Spanner when global consistency requirements emerge. DMS proves invaluable for cloud migrations, enabling zero-downtime transfers through continuous replication that syncs ongoing changes.

#### Expert Path
Focus on mastering trade-offs between consistency models (CAP theorem) across GCP databases. Study advanced Spanner features like interleaved tables for hierarchical data and commit timestamps for time-travel queries. Learn Firebase integration patterns for mobile applications leveraging Firestore's offline capabilities.

#### Common Pitfalls
Avoid vendor lock-in by not using Spanner for applications requiring multi-cloud deployments. Don't over-provision Spanner nodes during development - use processing units instead. Remember migration from Datastore to Firestore requires empty databases. Always implement proper IAM roles with principle of least privilege for database access.

#### Lesser-Known Facts
Spanner employs TrueTime (Google's atomic clock technology) for precise timestamping, enabling serializable consistency without traditional row-level locking. Firestore supports ACID transactions across up to 500 documents in a single operation, making it viable for complex financial workflows. DMS supports change data capture from Oracle databases using XStream technology for real-time replication.

MODEL ID: KK-CS45-V3

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
