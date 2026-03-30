# Session 53: Database Migration Service: Theory, Spanner, Datastore and Firestore Concepts and Demo

## Table of Contents
- [Overview](#overview)
- [Database Migration Service Theory](#database-migration-service-theory)
- [Homogeneous vs Heterogeneous Migration](#homogeneous-vs-heterogeneous-migration)
- [Real-World Migration Examples](#real-world-migration-examples)
- [Cloud SQL Storage Limitations](#cloud-sql-storage-limitations)
- [Horizontal vs Vertical Scalability](#horizontal-vs-vertical-scalability)
- [Introduction to Spanner](#introduction-to-spanner)
- [Spanner Key Capabilities](#spanner-key-capabilities)
- [Spanner SLA and Cost](#spanner-sla-and-cost)
- [Spanner Use Cases](#spanner-use-cases)
- [Spanner Pitfalls and Limitations](#spanner-pitfalls-and-limitations)
- [Hotspotting in Horizontally Scalable Systems](#hotspotting-in-horizontally-scalable-systems)
- [Datastore Concepts](#datastore-concepts)
- [Firestore Concepts and Evolution](#firestore-concepts-and-evolution)
- [Datastore vs Firestore Comparison](#datastore-vs-firestore-comparison)
- [Lab Demo: Querying Data](#lab-demo-querying-data)

## Overview

Session 53 provides a comprehensive exploration of Google's database migration and NoSQL database offerings. We'll cover the Database Migration Service for migrating databases to Google Cloud, examine the fundamental differences between horizontally and vertically scalable databases, and deep dive into Google's native database solutions including Spanner, Datastore, and Firestore.

Key topics include migration strategies, scalability patterns, high availability databases, and practical demonstrations of different database types.

## Database Migration Service Theory

### Concepts and Capabilities
The Database Migration Service is Google's fully managed, **serverless migration tool** that enables seamless database migration from various sources to Google Cloud destinations.

**Key Features:**
- Supports both homogeneous and heterogeneous migrations
- No infrastructure management required
- Compatible with specific source and destination combinations
- Provides continuous data synchronization capabilities

**Supported Patterns:**
- **Homogeneous Migration**: Same database engine on both source and destination (e.g., MySQL → Cloud SQL for MySQL, PostgreSQL → Cloud SQL for PostgreSQL)
- **Heterogeneous Migration**: Different database engines (limited support, primarily Oracle → Cloud SQL)

> **Note:** Homogeneous migrations are generally straightforward with tools like Database Migration Service, while heterogeneous migrations require more planning and potential schema transformations.

### Migration Approaches

1. **Simple Dump and Restore**: Manual approach using database export/import
   - Export data from source database
   - Transfer dump file to Google Cloud Storage
   - Import into target Cloud SQL instance
   - Suitable for one-time migrations without continuous updates

2. **Continuous Synchronization**: Using Database Migration Service
   - Configures connection profiles for source and destination
   - Enables ongoing data replication
   - Supports cutover strategies for minimal downtime
   - Captures change data capture (CDC) for incremental updates

## Homogeneous vs Heterogeneous Migration

**Homogeneous Migration:**
```diff
+ Source: AWS RDS for PostgreSQL
+ Destination: Cloud SQL for PostgreSQL
+ Method: Direct migration with schema preservation
+ Tool: Database Migration Service (DMS)
+ Complexity: Low
+ Cost: Charged based on data transfer (ingress free, egress charged)
```

**Heterogeneous Migration:**
```diff
+ Source: Oracle Database
+ Destination: Cloud SQL for PostgreSQL or AlloyDB
+ Method: Schema transformation + data migration
+ Tool: Database Migration Service (limited support)
+ Complexity: High
+ Cost: Per GB processed ($2/GB after free 50GB/month)
```

> **Important:** Homogeneous migrations use free egress costs (ingressing data to GCP), while heterogeneous migrations incur data processing fees.

## Real-World Migration Examples

### AWS EKS + RDS to GKE + Cloud SQL Pattern

**Scenario:** Front-end application on AWS EKS with PostgreSQL backend on AWS RDS

**Migration Strategy:**
1. **Phase 1**: Dump data transfer
   - Take consistent database dump from production RDS
   - Transfer dump via EC2 instance or S3 → GCS → Cloud SQL import
   - Verify data integrity
   - Connect front-end to Cloud SQL with proper networking

2. **Phase 2**: Production migration
   - Schedule maintenance window
   - Disconnect front-end from RDS
   - Take final dump and transfer
   - Restore to Cloud SQL
   - Switch connection strings
   - Enable VPN for secure connectivity

**Networking Considerations:**
- Use external IPs during testing phases
- Establish VPN connections for production
- Implement whitelisting for Database Migration Service IPs

### Continuous Migration Pattern

**Tool**: Database Migration Service
**Steps:**
1. Create source connection profile (credentials + endpoint)
2. Create destination profile (Cloud SQL instance details)
3. Configure migration job with sync options
4. Begin continuous replication
5. Perform cutover during maintenance window

**Pricing Model:**
- Homogeneous: No additional costs
- Heterogeneous: $2 per GB after 50GB free monthly

## Cloud SQL Storage Limitations

### Storage Capacity Constraints

Cloud SQL instances have strict storage limitations that vary by edition:

| Edition | Storage Limit | Key Notes |
|---------|---------------|-----------|
| Enterprise | 64TB | Cannot decrease after increase |
| Standard | 10TB | Lower capacity |
| Enterprise Plus | 64TB | Highest performance tier |

### Critical Limitations

> **Important:** All Cloud SQL instances are capped at 64TB storage, regardless of virtual machine configuration

**Impact Examples:**
```diff
- ⚠️ 60TB migration: Feasible, maintain buffer space
- ❌ 80TB migration: Impossible with Cloud SQL
- 🚫 Exceed 64TB: Database becomes read-only
```

### Recovery Options

When storage limits are reached:
- Clean up unused tables and data
- Implement data archiving strategies
- Migrate to alternative storage solutions

## Horizontal vs Vertical Scalability

### Fundamental Differences

**Vertical Scalability (Cloud SQL):**
- Scale up single instance by increasing vCPU/memory
- Downtime required for resizing
- Limited by hardware constraints
- 64TB storage cap

**Horizontal Scalability (Spanner/Bigtable):**
- Add multiple nodes or instances
- Zero downtime scaling
- Unlimited theoretical capacity
- More complex data distribution requirements

**Comparison:**

| Aspect | Vertical (Cloud SQL) | Horizontal (Spanner) |
|--------|---------------------|----------------------|
| Scaling Method | Increase server size | Add nodes/instances |
| Downtime | Required | None |
| Maximum Size | Limited (~128 vCPU) | Virtually unlimited |
| Costs | Fixed per instance | Per node + storage |

> **Expert Insight:** Always prefer horizontal scalability for systems requiring >64TB storage or unlimited growth potential. Budget constraints drive vertical scaling selection, but technical limitations make horizontal scaling mandatory at scale.

## Introduction to Spanner

### What is Spanner?

**Spanner** (Google Cloud Spanner) is Google's native, **globally distributed, horizontally scalable relational database** that combines:

- **Traditional SQL capabilities** with strong consistency
- **NoSQL-style scalability** and high availability
- **ACID compliance** with global transactions
- **99.999% SLA** availability (5-nines)

### Comparison with Alternatives

```diff
+ Relational database: SQL queries, strict consistency, ACID compliance
+ NoSQL database: Horizontal scalability, variable schemas, eventual consistency
+ Spanner: Best of both worlds - SQL + strong consistency + horizontal scaling
```

**Analogy:** 
- Cloud SQL: Toyota (reliable, cost-effective, traffic-friendly)
- Spanner: Ferrari (high-performance but expensive, race-track ready)

## Spanner Key Capabilities

### Core Features

1. **Strong Consistency**: ACID-compliant transactions globally
2. **SQL Support**: Standard SQL queries with familiar syntax
3. **Horizontal Scalability**: Add nodes without downtime
4. **Global Distribution**: Multi-region deployments with automatic failover
5. **High Availability**: 99.999% SLA (5-nines)

### Technical Specifications

- **Schema**: Strict relational schema (fixed columns per table)
- **Indexing**: Multiple indexes with interleave capabilities  
- **Transactions**: Global distributed transactions
- **Replication**: Synchronous leader/follower across regions

### Advanced Capabilities

1. **Interleaved Tables**: Hierarchical table relationships for efficient queries
2. **Multiple Indexes**: Automatic and custom indexing
3. **Query Analysis**: Built-in query optimization tools
4. **Auto-scaling**: Compute and storage scaling based on usage
5. **Backup/Restore**: Point-in-time recovery with 7-day retention

## Spanner SLA and Cost

### Service Level Agreement

- **Regional**: 99.9% uptime (4-nines, ~26 seconds monthly downtime)
- **Multi-regional**: 99.999% uptime (5-nines, ~26 seconds annually)

> **Note:** Spanner offers the highest SLA of any Google Cloud service, comparable to specialized mission-critical systems

### Cost Structure

**Pricing Breakdown:**
```
Compute: $0.90-$3.60/hour per node (2TB base capacity)
Storage: $0.5-$1.00/GB/month
Network: Data transfer costs
Backup: Included (7-day retention)
```

**Cost Considerations:**
- Most expensive GCP database service
- Per-node charges scale with requirements
- Storage costs relatively cheap
- Use processing units (1/1000 node) for dev/test environments

## Spanner Use Cases

### Mission-Critical Applications

1. **Global Supply Chain Management**: Real-time inventory tracking across continents
2. **Financial Services**: Consistent transaction processing and reporting
3. **Global Call Centers**: Distributed workforce with shared databases
4. **Gaming Leaderboards**: Globally consistent rankings with high concurrency
5. **Telecommunications**: Subscriber data management across regions

### Industry Examples

- **Google Play Store**: Transaction processing
- **FedEx Logistics**: Package tracking and coordination
- **Multiplayer Gaming**: Real-time player rankings and game state

### Configuration Examples

**Regional Deployment** (4-nines SLA):
```
Nodes: 1-10 (manual/auto-scaling)
Regions: Single region, multiple zones
Cross-zone: Read-write replicas
Cost: Lowest starting point
```

**Multi-regional Deployment** (5-nines SLA):
```
Nodes: 1+ (highly available)
Regions: 2-4 regions (Americas, EMEA, Asia)
Inter-region: Leader/follower replication
Cost: Premium tier
```

> **Note:** Use multi-region configuration only for business-critical applications requiring RTO < seconds

## Spanner Pitfalls and Limitations

### When NOT to Use Spanner

1. **Lift and Shift Migrations**
   ```diff
   - ❌ Oracle → Spanner: Requires heterogenous migration
   - ✅ Schema Transformation: Time-consuming schema changes required
   - ⚠️ Lock-in Risk: No easy path to other clouds
   ```

2. **Stored Procedures and Triggers**
   - Limited support for SQL-based business logic
   - Require conversion to application code

3. **High-Frequency Trading (Microsecond Latency)**
   - Not optimized for ultra-low latency operations
   - Better for millisecond-range operations

### Architectural Considerations

**Rule of Thumb:**
- <2TB: Consider Cloud SQL (cost effective)
- 2-60TB: Evaluate based on budget vs requirements
- >60TB: Spanner strongly recommended

### Initial Deployment Challenges

- Schema design complexity
- Data modeling differences
- Migration effort estimation (higher for heterogenous)
- Cost predictability challenges

## Hotspotting in Horizontally Scalable Systems

### What is Hotspotting?

**Hotspotting** occurs when data access patterns concentrate load on specific nodes, causing performance degradation.

**Example Scenario:**
```
Table: Employee_Logins
Primary Key: (Last_Access_Time, Employee_ID)
Data Pattern: All employees log in simultaneously at 9:00 AM
```

**Problem:**
```diff
- ❌ All 9:00 writes route to Node 4
- ❌ Node 4 becomes overloaded ("hot")
- ❌ Decreased performance across system
- ❌ Potential node failure risk
```

### Prevention Strategies

**Key Design Principle:**
```
Rebalance load by prioritizing sequentially distributed keys
```

**Solution Example:**
```
Original: (Last_Access_Time, Employee_ID) - Causes hotspots
Fixed: (Employee_ID, Last_Access_Time) - Distributes evenly
```

**Visual Distribution:**
```
Employee_IDs: 01, 02, 03, 04... 
Node Assignment: 01→Node2, 02→Node4, 03→Node2...
→ Balanced distribution across all nodes
```

> **Common Pitfalls:** Failing to design schemas for distributed workloads can negate scalability benefits and cause critical performance issues.

## Datastore Concepts

### Fundamental Characteristics

**Datastore** is Google's original NoSQL database offering:

- **Document Store**: Stores structured data as entities/properties
- **Serverless**: Zero infrastructure management
- **Horizontally Scalable**: Automatic scaling based on demand
- **Multi-regional**: 99.9% SLA availability
- **Schema-less**: Flexible data models per entity

### Data Model Terminology

| Relational Database | Datastore Equivalent | Description |
|-------------------|---------------------|-------------|
| Table | Kind | Collection of entities |
| Row | Entity | Individual data record |
| Column | Property | Data field |
| Primary Key | Key | Unique identifier |

### Key Capabilities

1. **Atomic Transactions**: Multi-entity write operations
2. **Flexible Schema**: Varying properties per entity
3. **Built-in Indexes**: Automatic indexing of properties
4. **SQL-like Queries**: GQL (Google Query Language) syntax
5. **Real-time Sync**: With App Engine integration

### Use Cases

1. **Product Catalogs**: E-commerce inventory with varying attributes
   ```diff
   + Refrigerator: Brand, Capacity, Shelves, Inverter
   + Smartphone: Brand, Display, WiFi, Battery
   + Different property sets handled seamlessly
   ```

2. **User Profiles**: Personalized experiences based on behavior
3. **Game Sessions**: Player progress and inventory
4. **IoT Data**: Variable sensor data structures

### Integration Model

```
App Engine (Front-end) ↔ Datastore (Backend)
     └── Shared projects with tight coupling
     └── Automatic scaling correlation
     └── Zero operational overhead
```

## Firestore Concepts and Evolution

### Evolution History

```
2010: App Engine launched with Datastore
Support: Desktop applications, web apps
Limitation: No native mobile offline support

2019: Firestore released as successor
Support: Mobile-first with offline capabilities  
Modernization: Better scalability, real-time features
Result: Firebase (mobile) + Datastore (enterprise) = Firestore
```

### Firestore vs Datastore Comparison

| Aspect | Datastore | Firestore |
|--------|-----------|-----------|
| **Primary Use** | Web applications | Mobile/IoT applications |
| **Offline Support** | ❌ | ✅ Native offline synchronization |
| **Real-time Updates** | ❌ | ✅ Live data syncing |
| **Query Language** | GQL | Firestore Query API |
| **Data Model** | Kind/Entity/Property | Collection/Document/Field |
| **Mobile SDKs** | Limited | Rich library support |
| **App Engine Integration** | Coupled | Loosely coupled |

### Key Firestore Features

1. **Offline Persistence**: Local data sync for mobile apps
2. **Real-time Listeners**: Live UI updates on data changes
3. **Cloud Functions Integration**: Serverless processing triggers
4. **Security Rules**: Granular access control
5. **Cross-platform SDKs**: iOS, Android, Web, Unity support

## Datastore vs Firestore Comparison

### Migration Considerations

```diff
+ Datastore → Firestore: One-way migration supported
+ Firestore → Datastore: NOT possible
+ Mixed Mode: Supported within same project (if empty database)
+ Lock-in: Mode selection is permanent once data exists
```

### Functional Differences

| Feature | Datastore | Firestore |
|---------|-----------|-----------|
| **Write Rate** | 25K ops/sec | ~10K ops/sec |
| **Query Limits** | Basic aggregations | Advanced queries |
| **Indexing** | Manual index config | Auto + custom indexes |
| **Transaction Scope** | Entity groups | Collection groups |

### Selection Guidelines

**Choose Datastore when:**
- Using App Engine exclusively
- Simple queries with high write throughput
- Legacy datastore applications

**Choose Firestore when:**
- Mobile application requirements
- Offline data synchronization needs
- Real-time streaming features
- Modern application architectures

## Lab Demo: Querying Data

### Datastore Demo

**Creating Entities:**
```sql
-- Entity 1: Refrigerator Product
Kind: Product_Catalog
Key: Auto-generated
Properties:
- brand: "Godrej"
- capacity: 10 (Integer)
- shelves: 3 (Integer)
- inverter: false (Boolean)
```

**Querying with GQL:**
```sql
-- Simple Query: Get all products
SELECT * FROM Product_Catalog

-- Filtered Query: Products with WiFi support
SELECT * FROM Product_Catalog WHERE wifi = true
```

### Firestore Demo

**Creating Documents:**
```json
// Document 1: Refrigerator
Collection: product_catalog
Document ID: auto-generated
Fields: {
  "brand": "Samsung",
  "capacity": "10L", 
  "shelves": 3,
  "inverter": false
}
```

**Querying in Firestore:**
```javascript
// Query with filtering
db.collection('product_catalog')
  .where('wifi', '==', true)
  .get()
  .then((querySnapshot) => {
    // Process results
  });
```

### Key Observations

```diff
+ Datastore: Tabular view, consistent column display
+ Firestore: Document-oriented view, flexible field display  
+ Both: Handle variable schemas differently
+ Datastore: Older GQL syntax
+ Firestore: Modern query API with real-time capabilities
```

---

## Summary

### Key Takeaways
```diff
+ Database Migration Service is serverless and supports homogeneous migrations at no cost
+ Cloud SQL has 64TB storage limit - plan accordingly
+ Horizontal scalability (Spanner) preferred over vertical (Cloud SQL) for large scale
+ Spanner offers 5-nines SLA but at premium cost - reserve for mission-critical use cases
+ Hotspotting solved through proper schema design with distributed keys
+ Datastore: Legacy NoSQL for App Engine integration
+ Firestore: Modern successor with mobile/offline capabilities
+ Migration from Datastore to Firestore supported, but plan mode selection carefully
```

### Expert Insight
**Real-world Application**: Use Spanner for global applications requiring strict consistency (banking transactions, global gaming leaderboards). Prefer Cloud SQL for simple OLTP workloads under 64TB. Choose Firestore for mobile-first applications needing offline capability.

**Expert Path**: Master interleaved table designs and schema optimization for Spanner. Learn to design for distributed systems by understanding data sharding patterns. Practice hybrid approaches combining SQL and NoSQL for optimal architecture.

**Common Pitfalls**: Underestimating Spanner costs - always evaluate Cloud SQL first. Forgetting mode lock-in between Datastore and Firestore. Neglecting to design for even load distribution in horizontally scalable systems. Attempting heterogenous migrations without schema transformation planning.

---

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
