# Section 2: API Fundamentals

## 2.1 Definition and Analogy

### 📝 What is an API?

**API** = **Application Programming Interface**

**Simple Definition**: A mechanism for us to interact with software programs

**Breaking Down the Term**:
- **Application**: Software built with specific functionality
- **Programming**: Code-based interaction
- **Interface**: Contract for that interaction

### 🏨 Hotel Analogy

```
Customer (You)          Front Desk (API)          Hotel Backend
    │                         │                         │
    ├─ Reserve room ─────────→│                         │
    ├─ Cancel reservation ────→│                         │
    ├─ Update reservation ────→│                         │
    ├─ Check availability ────→│                         │
    │                         │                         │
    │                         ├─ Query divisions ──────→│
    │                         ├─ Check database ────────→│
    │                         ├─ Ask supervisors ───────→│
    │                         ├─ Memory (recent queries)→│
    │                         │                         │
    │←──── Answer ────────────┤←──── Information ───────┤
```

**Mapping to API Terms**:
- **Customer** = API Client/Consumer
- **Front Desk** = API
- **Hotel** = Backend (database, another API, etc.)
- **Reservation/Availability** = Resource

> [!IMPORTANT]
> The client doesn't need to know HOW the API gets the answer, only that it gets the correct answer.

### 💼 Real-World Example: Customer Database

**Scenario**: Company has customer database that multiple applications need to access

**Without API**:
```diff
- Grant database access to all applications
- CRM, ERP, Tax, Regulatory apps all connect directly to DB
- Database team raises concerns about security
- Difficult to manage and control access
```

**With API**:
```
   CRM  ERP  Tax  Reg  Other Apps
     ↓    ↓    ↓    ↓    ↓
     └────┼────┴────┴────┘
          ↓
    Customer API
     ├─ Search customers
     ├─ Create customer
     ├─ Update customer
     └─ Delete customer
          ↓
    Customer Database
```

**Benefits**:
✅ API developer governs what's allowed/not allowed
✅ Only valid clients with authentication can access
✅ Clients don't need to know backend details (which database, etc.)
✅ Acts as mediator between applications

---

## 2.2 API vs Web Service

### 🔍 Key Differences

**API** (Broader Term):
- Collection of functions/libraries for application communication
- Can be desktop app ↔ OS
- Can be programming language APIs
- Can be web-based

**Web Service** (Subset of API):
- Applications interact **over the internet**
- Always web-based

```
                    API (Broader)
                         │
        ┌────────────────┼────────────────┐
        ↓                ↓                 ↓
    OS APIs      Programming APIs    Web Services
  (DirectX,      (Language APIs)    (REST, SOAP)
   Linux Kernel)
```

### 📚 Examples

**OS/Programming APIs**:
- Microsoft DirectX (multimedia, 3D graphics)
- Linux Kernel APIs
- Example: 3D drawing software or music player consuming multimedia APIs

**Web Services**:
- Google Maps API (navigation)
- Payment APIs
- Social media APIs

> [!NOTE]
> **Not all APIs are web services, but all web services are APIs.**
> 
> In this course, "API" and "web service" may be used interchangeably.

---

## 2.3 API Types

### 🎯 API Types by Audience

#### 1. **Private API**
- Used **only** by internal company applications
- Not exposed outside organization

```
Company Internal Apps
    ↓
Private API
    ↓
Company Backend Systems
```

#### 2. **Public API**
- Available to anyone
- Examples: Google Maps API, Slack API, Twitter API
- Thousands of public APIs available

#### 3. **Partner API**
- Exposed only to specific customers/partners
- Between private and public

**Examples**:
- Environmental/regulatory data services for customers only
- Amazon Selling Partner API (sellers access orders, shipments, payments)

#### 4. **Composite/Hybrid API**
- Combines data from various sources
- More complex to develop, potentially slower
- Use case: Transportation apps (weather + traffic + mapping data)

### 🛠 API Types by Implementation

#### 1. **REST** (Representational State Transfer)
- **Most popular** API type
- Architectural style with design principles
- Main focus of this course

#### 2. **SOAP** (Simple Object Access Protocol)
- Protocol (not just architectural style)
- XML-based messages only
- Standard SOAP envelope
- Less flexible than REST, but considered more secure
- Supports encryption and Transport Layer Protocol

```diff
! REST vs SOAP:
! REST: Flexible, lightweight, supports JSON/XML
! SOAP: Secure, encrypted, XML-only, heavier
```

#### 3. **RPC** (Remote Procedure Call)
- Similar to calling a function in JavaScript
- Set of functions
- Method call via URL endpoint
- Arguments in query parameters or body
- Example: gRPC

#### 4. **GraphQL**
- Borrows best from REST and RPC
- Query language for fetching data
- Single endpoint
- Specify objects and fields to fetch
- SQL-like query language

**GraphQL Example**:
```graphql
query {
  launches(limit: 3) {
    id
    details
    launch_year
  }
  rockets {
    description
    cost_per_launch
    active
  }
}
```

**Benefits**:
- ✅ Single endpoint
- ✅ Request only needed fields
- ✅ Reduces over-fetching
- ✅ SQL-like simplicity

#### 5. **OData** (Open Data Protocol)
- Microsoft-developed
- Enhanced abstraction of REST
- Framework for generic queries against service data
- Simplifies filtering without complicating server-side code

---

## 2.4 API Examples

### 🌐 Common API Examples

#### 1. **Google Maps API**
- Navigation capabilities
- **Paid** public API
- Will explore in detail later in this section

#### 2. **OpenAI API**
- AI capabilities integration
- No need to build LLM models from scratch
- **Paid** public API

#### 3. **Apigee API**
- Drives Google Cloud's API management platform
- Operations done in GUI can be done programmatically via API

#### 4. **Weather API**
- Provides weather-related data
- Common use case for many applications

### 💡 Key Takeaway

> [!IMPORTANT]
> APIs drive digital excellence in today's IT world. You can connect any apps and services with any other apps or services using APIs.

**Why APIs are Powerful**:
- ✅ Platform independent consumption and distribution
- ✅ Connected experience across applications
- ✅ Build apps in any language, consume APIs from any platform
- ✅ Don't need to worry about how API is developed

---

## 2.5 Postman Demo and API Terminology

### 🔧 HTTP Client: Postman

**Postman**: Most popular HTTP client for consuming/testing APIs

**Installation Options**:
- Desktop client (recommended): postman.com/downloads
- Web version: Sign up and use in browser

> [!NOTE]
> Recommended to sign up/sign in even on desktop version to avoid losing progress.

### 📁 Postman Workspace Setup

**Create Workspace**:
```
Workspaces → Create Workspace
    ↓
Choose: API Development Template
    ↓
Name: "API Examples"
Visibility: Private/Public/Team
```

**Collections**:
- Default collections imported with template
- Can create new collections
- Add requests to collections

### 🔑 API Terminology

#### 1. **Headers**
- Metadata included with requests/responses
- Auto-generated headers visible in Postman
- Can add custom headers

**Example Headers**:
```
Accept: */* (can accept any response type)
Authorization: Basic <credentials>
Content-Type: application/json
Custom-Header: org-code
Custom-Header: app-id
```

**Authorization Header**:
- Basic Auth: Username + Password → Authorization header generated
- JWT: Token included in Authorization header
- No Auth: No Authorization header

#### 2. **Query Parameters**
- Delineated with `?` for first parameter
- Subsequent parameters with `&`

**Example**:
```
https://api.example.com/books?id=123&category=non-fiction
```

**Breakdown**:
- Base URL: `https://api.example.com`
- Resource: `/books`
- Query Parameters: `id=123`, `category=non-fiction`

#### 3. **URI Parameters** (Path Parameters)
- Part of the URL path itself
- Represent resource hierarchy

**Example**:
```
https://api.example.com/internal/rest/books/non-fiction/sci-fi/Dune?page=21
```

**Breakdown**:
- `non-fiction` = Category (URI parameter)
- `sci-fi` = Sub-category (URI parameter)
- `Dune` = Title (URI parameter)
- `page=21` = Query parameter

#### 4. **Base URL vs Path**

```
https://api.example.com/internal/rest/books/non-fiction/sci-fi/Dune
│                          │              │                        │
└─ Host Name               └─ API Suffix  └─ Path to Resource
```

**Definitions**:
- **Host Name**: `api.example.com`
- **API Suffix**: `/internal/rest` (prefix before resource)
- **Base URL**: `https://api.example.com/internal/rest`
- **Path to Resource**: `/books/non-fiction/sci-fi/Dune`
- **Endpoint URL**: Complete URL

### 🔄 Variables in Postman

**Collection-Level Variables**:
```
Collection → Variables
    ↓
Define: base_url = https://api.example.com
```

**Environment Variables**:
```
Environments → Create New Environment
    ↓
Name: "Test"
Variables: custom_url, my_url, etc.
```

**Variable Precedence**:
```
Environment Variable (highest priority)
    ↓
Collection Variable (fallback)
```

**Usage**:
```
{{base_url}}/endpoint
```

### 📝 Postman Features

- **Authorization**: Set at collection or request level
- **Inherit from parent**: Request can inherit collection auth
- **Documentation**: View docs for each endpoint
- **Tests**: Add Postman test scripts
- **Settings**: Certificate verification, etc.

---

## 2.6 HTTP Methods and Idempotence

### 🔁 Idempotence Concept

**Idempotence**: Property where performing an operation multiple times consecutively yields the same result as performing it once.

**Mathematical Example**:
```
x + 0 = x
(x + 0) + 0 + 0 + ... = x
```

**Real-World Example**:
```
TV Remote: Press channel 25
    ↓
Channel changes to 25
    ↓
Press channel 25 again (multiple times)
    ↓
Still on channel 25 (no change)
```

**API Context**:
> Making a request once yields the same result as making that request 100 times. The state of the data does not change after the first request.

### 📊 Example Database: Employees

```
Table: employees
    ├─ id (Primary Key)
    ├─ name
    ├─ designation
    ├─ address
    └─ active (boolean)
```

**API Base URL**:
```
https://myhost.com/api/rest/hr/employee
```

### 🔍 HTTP Methods Explained

#### 1. **GET** - Query Records

**Purpose**: Retrieve data

**Example**:
```
GET https://myhost.com/api/rest/hr/employee?active=true
```

**Characteristics**:
- ❌ No request body allowed
- ✅ Returns filtered employee records
- ✅ **Idempotent**: Multiple calls don't change database state

> [!NOTE]
> GET is typically used to query data, but you could use POST for querying if API is designed that way. Idempotency depends on implementation, not just the method.

#### 2. **POST** - Create Records

**Purpose**: Create new resource

**Example**:
```
POST https://myhost.com/api/rest/hr/employee

Body:
{
  "id": null,
  "name": "John Doe",
  "designation": "Engineer",
  "address": "123 Main St",
  "active": true
}
```

**Characteristics**:
- ✅ Has request body
- ✅ Creates new record with auto-generated ID
- ❌ **Not Idempotent**: Multiple calls create multiple records

```diff
- POST is NOT idempotent
- Executing same request 10 times creates 10 records
- Changes state of database each time
```

#### 3. **PUT** - Update Full Record

**Purpose**: Update entire representation of resource

**Example**:
```
PUT https://myhost.com/api/rest/hr/employee/100

Body:
{
  "id": 100,
  "name": "John Doe Updated",
  "designation": "Senior Engineer",
  "address": "456 New St",
  "active": true
}
```

**Characteristics**:
- ✅ Has request body
- ✅ Updates full record
- ✅ **Idempotent**: Multiple calls with same data don't change state after first update

#### 4. **DELETE** - Remove Record

**Purpose**: Delete resource

**Example**:
```
DELETE https://myhost.com/api/rest/hr/employee/100
```

**Characteristics**:
- ❌ No request body
- ✅ Deletes employee with ID 100
- ✅ **Idempotent**: Multiple calls don't change state after first deletion
  - First call: Succeeds, deletes record
  - Subsequent calls: May fail (404), but database state unchanged

> [!IMPORTANT]
> API throwing an error is NOT a criteria for idempotency. What matters is whether the state of the data changes.

#### 5. **PATCH** - Partial Update

**Purpose**: Update record partially

**Example 1 - Simple Patch**:
```
PATCH https://myhost.com/api/rest/hr/employee/100

Body:
{
  "address": "789 Updated St"
}
```

**Characteristics**:
- ✅ Updates only specified fields
- ✅ Appears idempotent in simple case

**Example 2 - JSON Patch (Not Idempotent)**:
```
PATCH https://myhost.com/api/rest/hr/employee/100

Body:
[
  {
    "op": "add",
    "path": "/address/lines",
    "value": ["Floor 10"]
  }
]
```

**Result**:
- First call: Adds `["Floor 10"]` to address.lines
- Second call: Adds another `["Floor 10"]` → State changes!
- ❌ **Not Idempotent** with JSON Patch operations

> [!WARNING]
> PATCH can be idempotent or not, depending on implementation. Design your system carefully!

#### 6. **HEAD** - Lightweight GET

**Purpose**: Check if endpoint is reachable without response body

**Example**:
```
HEAD https://myhost.com/api/rest/hr/employee
```

**Characteristics**:
- ❌ No request body
- ❌ No response body (only headers)
- ✅ **Idempotent**: No data changes

#### 7. **OPTIONS** - Discover Allowed Methods

**Purpose**: Find out which HTTP methods are allowed on endpoint

**Example**:
```
OPTIONS https://myhost.com/api/rest/hr/employee
```

**Response**:
```
Allowed Methods: GET, POST, PUT, DELETE
(in response body or headers)
```

**Characteristics**:
- ❌ No request body
- ✅ Returns allowed methods
- ✅ **Idempotent**: No data changes

### 📋 Idempotency Summary

```diff
+ Idempotent Methods:
+ GET, PUT, DELETE, HEAD, OPTIONS

- Non-Idempotent Methods:
- POST, PATCH (with JSON Patch operations)
```

---

## 2.7 HTTP Method Comparison

### 📊 HTTP Methods Comparison Table

| Method  | CRUD Operation | Request Body | Idempotent | Safe |
|---------|----------------|--------------|------------|------|
| GET     | Read           | ❌ No        | ✅ Yes     | ✅ Yes |
| POST    | Create         | ✅ Yes       | ❌ No      | ❌ No  |
| PUT     | Update         | ✅ Yes       | ✅ Yes     | ❌ No  |
| DELETE  | Delete         | ❌ No        | ✅ Yes     | ❌ No  |
| PATCH   | Partial Update | ✅ Yes       | ⚠ Depends | ❌ No  |
| HEAD    | Read (no body) | ❌ No        | ✅ Yes     | ✅ Yes |
| OPTIONS | Metadata       | ❌ No        | ✅ Yes     | ✅ Yes |

### 🔐 Safe Methods

**Safe Method**: Does NOT cause any update/change to data

✅ **Safe**: GET, HEAD, OPTIONS
❌ **Not Safe**: POST, PUT, DELETE, PATCH

> [!NOTE]
> Idempotency depends on how your system is designed. The table shows standard implementation behavior.

---

## 2.8 HTTP Status Codes

### 📊 Status Code Categories

```
HTTP Status Codes
    │
    ├── 1xx (100-199): Informational Response
    ├── 2xx (200-299): Successful Response
    ├── 3xx (300-399): Redirection Response
    ├── 4xx (400-499): Client Error Response
    └── 5xx (500-599): Server Error Response
```

### 1️⃣ 1xx - Informational Response

**100 Continue**: Server ready to receive large file

**Use Case**:
```
Client wants to upload large file (1-2 GB)
    ↓
Client sends request WITHOUT payload first
    ↓
Server responds: 100 Continue
    ↓
Client uploads actual large file
```

### 2️⃣ 2xx - Successful Response

**Common Codes**:
- **200 OK**: Request successful
- **201 Created**: New resource created successfully
- **204 No Content**: Success, but no response body

### 3️⃣ 3xx - Redirection Response

**Use Case**: API version moved to new location

**Example**:
```
Client calls old API version
    ↓
Server responds: 301 Moved Permanently
Location: https://api.example.com/v2/resource
```

### 4️⃣ 4xx - Client Error Response

**Common Codes**:
- **400 Bad Request**: Malformed request
- **401 Unauthorized**: Authentication required/failed
- **403 Forbidden**: Authenticated but not authorized
- **404 Not Found**: Resource doesn't exist
- **410 Gone**: Resource permanently deleted

### 5️⃣ 5xx - Server Error Response

**Common Codes**:
- **500 Internal Server Error**: Generic server error
- **502 Bad Gateway**: Invalid response from upstream server
- **503 Service Unavailable**: Server temporarily unavailable
- **504 Gateway Timeout**: Upstream server timeout

### 🐱 Fun Resource

Postman has a public collection "HTTP Cat" with cat memes for each status code!

```
Postman → API Network → Search "HTTP status codes"
    ↓
Fork "HTTP Cat" collection
```

---

## 2.9 Understanding REST

### 🎯 What is REST?

**REST** = **Representational State Transfer**

**Definition**: Architectural style for building APIs by following certain constraints and principles.

**Key Concept**: Work with **representation** of resources
- JSON representation for creating resource
- URL representation for deleting resource

### 📜 REST Constraints/Principles

#### 1. **Client-Server Architecture**

```
Client                    Server
    │                         │
    ├─ Not concerned ─────────┤─ Business logic
    │  with business logic    │
    │                         │
    ├─ Could be any app ──────┤─ Not concerned
       (frontend, mobile,        with client type
        another API)
```

**Benefits**:
- ✅ Both evolve independently
- ✅ Loose coupling

#### 2. **Uniform Interface**

**Principle**: Uniform way of interacting with resources, irrespective of client/device/application type

**How Achieved**:
1. Everything is a resource (defined by URI)
2. Operate on resources using standard HTTP methods

**Example - Employee API**:
```
GET    /hr/employee              → List all employees
GET    /hr/employee/123          → Get employee 123
POST   /hr/employee              → Create new employee
PUT    /hr/employee/123          → Update employee 123
DELETE /hr/employee/123          → Delete employee 123

GET    /hr/employee/123/addresses         → Get all addresses for employee 123
GET    /hr/employee/123/addresses/456     → Get specific address
POST   /hr/employee/123/addresses         → Add new address
```

**Benefits**:
- ✅ Clients can discover resources
- ✅ Understand resource hierarchy
- ✅ Simplified consumption

**Example - Create Employee**:
```
POST /hr/employee

Response:
{
  "id": 789,  ← Auto-generated
  "name": "John Doe",
  ...
}
```

Now client can use `/hr/employee/789` for future operations.

> [!WARNING]
> Avoid unnecessary nesting! Use sibling resources for unrelated data:
> - `/hr/employee` (employees)
> - `/hr/candidates` (candidates)

**Anti-Pattern**:
```diff
- Bad: /hr/employee/list-employees
- Bad: /hr/employee/search-employees
+ Good: /hr/employee?name=John&area_code=123
```

#### 3. **Statelessness**

**Principle**: Server doesn't store state information from previous requests. Client sends all necessary information in each request.

**Example - Pagination**:
```
User on page 5 → Clicks "Next"
    ↓
Frontend sends: GET /finance/accounts?page=6
    ↓
Server calculates which records to return based on page=6
```

**Bad Example** (Stateful):
```diff
- Server remembers user is on page 5
- Client sends: GET /finance/accounts?next=true
- Server has to track session state
```

**Good Example** (Stateless):
```diff
+ Client sends all info: GET /finance/accounts?page=6&limit=20&sort=date
+ Server calculates response from request parameters only
```

> [!IMPORTANT]
> Request must contain ALL necessary information for server to process it.

#### 4. **Cacheable**

**Principle**: Response must indicate if it's cacheable and for how long.

**Implementation**: `Cache-Control` response header

**Example**:
```
Response Headers:
Cache-Control: max-age=3600, public
```

**Two Sides of Caching**:
1. **Client-side**: Client caches response for specified duration
2. **Server-side**: API gateway/middleware caches to minimize backend calls

> [!NOTE]
> Dedicated lecture on caching later in this course.

#### 5. **Layered Architecture**

**Principle**: API architecture composed of multiple layers. Each layer interacts only with immediate next layer.

```
Client
    ↓
API Gateway (Layer 1)
    ↓
Business Logic (Layer 2)
    ↓
Backend Services (Layer 3)
    ↓
Database (Layer 4)
```

**Example with API Management**:
```
Client
    ↓
API Gateway (decouples client from backend)
    ↓
API Business Logic
    ↓
Other APIs (for data aggregation)
    ↓
Backend Services
```

**Benefits**:
- ✅ Separation of concerns
- ✅ Each layer has specific responsibility
- ✅ Easier to maintain and scale

---

## 2.10 Design-First Approach to API Development

### 🎨 What is Design-First?

**Design-First Approach**: Write OpenAPI specification **before** building API business logic.

```
Traditional Approach:
Code API → Document API → Share with consumers

Design-First Approach:
Design API Spec → Share with stakeholders → Code API
```

### 📋 OpenAPI Specification Contents

- All endpoints
- Authentication methods
- HTTP methods per endpoint
- Request structure
- Response structure
- Response codes
- Error codes

### ✅ Benefits of Design-First

#### 1. **Stakeholder Understanding**
- Understand API capabilities without seeing source code
- No exposure of proprietary code

#### 2. **Collaborative Environment**
- Get inputs from various stakeholders
- Improve API spec based on feedback
- Foster feature evolution

#### 3. **Agile Practices**
- Supports parallel development
- Consumers can start building while API is being developed
- All key information available in spec

#### 4. **Tool Support**
- Modern tools support OpenAPI spec import
- Generate boilerplate code
- Easier implementation for consumers

### 📜 Swagger vs OpenAPI History

```
2010: Swagger founded
    ↓
2014: Swagger 2.0 released (proprietary)
    ↓
2015: OpenAPI Initiative founded (open source)
      Swagger donated spec → OpenAPI 2.0
    ↓
2017: OpenAPI 3.0.0 released
    ↓
2024: OpenAPI 3.1.1 (latest as of course recording)
```

> [!NOTE]
> **Swagger** and **OpenAPI** are now the same. Swagger donated their spec to the OpenAPI Initiative in 2015.

---

## 2.11 Explore OpenAPI Specification Format

### 📄 OpenAPI Specification Structure

**Format**: JSON or YAML (YAML is more human-readable)

**Access Example Spec**:
- Petstore Swagger: `https://petstore3.swagger.io`
- JSON: `https://petstore3.swagger.io/api/v3/openapi.json`
- YAML: `https://petstore3.swagger.io/api/v3/openapi.yaml`

> [!WARNING]
> Many tools don't support OpenAPI 3.0.4 yet. Use 3.0.3 or 3.0.1 for compatibility with Apigee X and Azure API Management.

### 🏗 OpenAPI Spec Elements

#### 1. **Info** (Metadata)
```yaml
info:
  title: Petstore API
  description: This is a sample Pet Store Server
  version: 1.0.1
  contact:
    email: support@example.com
  license:
    name: Apache 2.0
    url: https://www.apache.org/licenses/LICENSE-2.0.html
  termsOfService: https://example.com/terms
```

#### 2. **Servers** (Base URLs)
```yaml
servers:
  - url: https://petstore3.swagger.io/api/v3
```

#### 3. **Paths** (Endpoints)
```yaml
paths:
  /pet:
    put:
      summary: Update an existing pet
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/Pet'
      responses:
        '200':
          description: Successful operation
    post:
      summary: Add a new pet
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/Pet'
  
  /pet/{petId}:
    get:
      summary: Find pet by ID
      parameters:
        - name: petId
          in: path
          required: true
          schema:
            type: integer
    delete:
      summary: Deletes a pet
      parameters:
        - name: petId
          in: path
          required: true
          schema:
            type: integer
  
  /pet/findByStatus:
    get:
      summary: Finds pets by status
      parameters:
        - name: status
          in: query
          required: true
          schema:
            type: string
            enum:
              - available
              - pending
              - sold
```

**Path Characteristics**:
- Paths are relative to server URL
- Multiple HTTP methods per path
- Parameters can be in path or query

#### 4. **Components** (Reusable Objects)

**Schemas**:
```yaml
components:
  schemas:
    Pet:
      type: object
      required:
        - name
        - photoUrls
      properties:
        id:
          type: integer
          format: int64
        name:
          type: string
          example: doggie
        category:
          $ref: '#/components/schemas/Category'
        photoUrls:
          type: array
          items:
            type: string
        tags:
          type: array
          items:
            $ref: '#/components/schemas/Tag'
        status:
          type: string
          enum:
            - available
            - pending
            - sold
```

**Security Schemes**:
```yaml
components:
  securitySchemes:
    api_key:
      type: apiKey
      name: api_key
      in: header
    consumer_api_key:
      type: apiKey
      name: consumer_api_key
      in: query
```

**Using Security**:
```yaml
paths:
  /pet:
    post:
      security:
        - api_key: []
```

### 📐 YAML Syntax Notes

**Indentation**:
- Use 2 spaces (standard, but 3-4 also work)
- Must be consistent throughout file

**Arrays**:
```yaml
tags:
  - pet
  - store
  - user
```

**Objects**:
```yaml
info:
  title: My API
  version: 1.0.0
```

### 📚 Official Documentation

**OpenAPI Specification Docs**: `https://spec.openapis.org`

**Available Versions**:
- 3.1.1 (latest as of Oct 2024)
- 3.0.3
- 3.0.1
- 2.0 (legacy)

**Documentation Includes**:
- Document structure
- Data types
- Schema definitions
- Individual element definitions (server object, path object, etc.)

### 🎯 RESTful API Design Best Practices

**Requirement**: Design API to list, get, create, update, delete customers

**Anti-Pattern**:
```diff
- GET  /api/rest/customers/list-customers
- GET  /api/rest/customers/search-customers
- POST /api/rest/customers/create-customer
- PUT  /api/rest/customers/update-customer
```

**RESTful Pattern**:
```diff
+ GET    /api/rest/customers                  → List all customers
+ GET    /api/rest/customers?name=John        → Search customers
+ GET    /api/rest/customers/12345            → Get customer 12345
+ POST   /api/rest/customers                  → Create new customer
+ PUT    /api/rest/customers/12345            → Update customer 12345
+ DELETE /api/rest/customers/12345            → Delete customer 12345
```

**With Filters**:
```
GET /api/rest/customers?name=John&area_code=123
```

**Request/Response in Spec**:
- Define request structure (especially for POST/PUT)
- Define response structure
- Define error codes
- Define authentication

### 🤖 AI-Assisted Spec Generation

> [!TIP]
> Use AI tools (Gemini Code Assist, Copilot) to generate OpenAPI specs. The more detailed your prompt, the more accurate the spec.

---

## 2.12 Generate Google Maps API Key

**Note**: This lecture covers generating a Google Maps API key for hands-on exploration.

**Steps**:
1. Go to Google Cloud Console
2. Enable Google Maps APIs
3. Create credentials (API Key)
4. Restrict API key (optional but recommended)
5. Use API key in subsequent demos

> [!IMPORTANT]
> Google Maps API is a **paid API**, but Google provides monthly free quota sufficient for learning purposes.

---

## 2.13 Exploring Google Maps API

### 🗺 Google Maps API in Postman

**Access Public Collection**:
```
Postman → API Network → Search "Google Maps"
    ↓
Find: Google Maps Platform collection
    ↓
Fork into your workspace
```

### 🔐 Authentication

**Method**: API Key

**Configuration**:
```
Collection → Authorization
    ↓
Type: API Key
Add to: Query Params
Key: key
Value: YOUR_API_KEY
```

### 📍 Common Use Cases

#### 1. **Text Search** (Find Places)

**Endpoint**: Places API → Text Search

**Example**:
```
GET https://maps.googleapis.com/maps/api/place/textsearch/json?query=Maharaja+Restaurant&key=YOUR_API_KEY
```

**With Location Preference**:
```
GET https://maps.googleapis.com/maps/api/place/textsearch/json?query=Maharaja+Restaurant&location=40.7128,-74.0060&key=YOUR_API_KEY
```

**Response**:
```json
{
  "results": [
    {
      "name": "Maharaja Restaurant",
      "formatted_address": "123 Main St, New York, NY",
      "place_id": "ChIJ...",
      "geometry": {
        "location": {
          "lat": 40.7128,
          "lng": -74.0060
        }
      }
    }
  ]
}
```

#### 2. **Autocomplete** (Suggestions)

**Use Case**: Show suggestions as user types

**Endpoint**: Places API → Autocomplete

#### 3. **Find Place from Text** (Get Place ID)

**Endpoint**: Places API → Find Place from Text

**Example**:
```
GET https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=Eiffel+Tower+Paris&inputtype=textquery&fields=place_id&key=YOUR_API_KEY
```

**Response**:
```json
{
  "candidates": [
    {
      "place_id": "ChIJLU7jZClu5kcR4PcOOO6p3I0"
    }
  ]
}
```

#### 4. **Directions** (Navigation)

**Endpoint**: Directions API

**Example**:
```
GET https://maps.googleapis.com/maps/api/directions/json?origin=place_id:ChIJ...&destination=place_id:ChIJ...&key=YOUR_API_KEY
```

**Response Structure**:
```json
{
  "routes": [
    {
      "legs": [
        {
          "steps": [
            {
              "html_instructions": "Head northeast on Avenue Anatole France toward Pont d'Iéna",
              "distance": { "text": "0.2 km", "value": 200 },
              "duration": { "text": "1 min", "value": 60 },
              "travel_mode": "DRIVING"
            }
          ]
        }
      ]
    }
  ]
}
```

**Steps** = Turn-by-turn instructions (what Siri/Google Assistant reads)

### 🌐 Additional Parameters

**Language**:
```
&language=fr  → Get directions in French
```

**Avoid**:
```
&avoid=tolls,highways
```

**Departure Time**:
```
&departure_time=1609459200
```

**Alternatives**:
```
&alternatives=true  → Get alternative routes
```

### 💡 API vs UI Mapping

```
Google Maps App UI          API Equivalent
    │                            │
    ├─ Search place ─────────────┤─ Text Search / Find Place
    ├─ Autocomplete ─────────────┤─ Autocomplete API
    ├─ Get directions ───────────┤─ Directions API
    ├─ Choose language ──────────┤─ language parameter
    ├─ Avoid tolls ──────────────┤─ avoid parameter
    └─ Alternative routes ───────┤─ alternatives parameter
```

> [!NOTE]
> What you see in Google Maps UI is powered by these APIs. The API provides programmatic access to the same features.

### 🔮 Preview: API Management

**Later in Course**:
- Import Google Maps API into Apigee
- Consumers call API Gateway (not maps.googleapis.com directly)
- API Gateway routes requests to Google Maps backend

```
Consumer → API Gateway (Apigee) → Google Maps API
```

---

## 2.14 API Lifecycle and Benefits

### 🔄 API Lifecycle

```
1. Define & Design
    ↓
2. Develop & Test
    ↓
3. Secure
    ↓
4. Deploy to Production
    ↓
5. Enhance & Iterate
    ↓
6. Market & Monetize (if public/paid)
```

#### 1. **Define & Design**
- Interact with business stakeholders
- Understand requirements and functionalities
- Design API that suits business needs

#### 2. **Develop & Test**
- Build API business logic
- Test endpoints, methods, responses
- Validate against spec

#### 3. **Secure**
- Implement authentication (API Key, OAuth2, JWT)
- Add authorization
- Implement threat protection

#### 4. **Deploy**
- Deploy initial version to production
- Make available to consumers

#### 5. **Enhance & Iterate**
- Add new features
- Add new endpoints
- Version management

#### 6. **Market & Monetize**
- For public/paid APIs
- Developer portal
- Pricing tiers
- Usage tracking

> [!NOTE]
> Going live is NOT the end! Continuous enhancement and monitoring are crucial.

### ✅ Benefits of APIs

#### 1. **Real-Time Seamless Integration**
- Connect applications and systems in real-time
- No batch processing delays

#### 2. **Improved Efficiency**
- Reusable components
- Any team/application can consume
- Avoid rebuilding same functionality

#### 3. **Lightweight & Loosely Coupled**
- Minimal overhead
- Independent evolution of client and server

#### 4. **Platform Independent**
- Develop in any language/platform
- Consume from any language/platform
- Java app can consume Python API, and vice versa

#### 5. **Easy to Deploy & Manage**
- Simple deployment processes
- Centralized management

#### 6. **Microservices Friendly**
- Complement microservices architecture
- Lightweight and loosely coupled nature
- Deploy as containerized applications
- Kubernetes orchestration

#### 7. **Scalable & Flexible**
- Scale horizontally
- Add/remove instances as needed
- Flexible to changing requirements

---

## 2.15 Section Summary

### 🎯 Key Takeaways

✅ **API Definition**: Mechanism for applications to interact, with interface as contract
✅ **API vs Web Service**: All web services are APIs, but not all APIs are web services
✅ **API Types by Audience**: Private, Public, Partner, Composite
✅ **API Types by Implementation**: REST, SOAP, RPC, GraphQL, OData
✅ **HTTP Methods**: GET, POST, PUT, DELETE, PATCH, HEAD, OPTIONS
✅ **Idempotence**: GET, PUT, DELETE, HEAD, OPTIONS are idempotent; POST is not
✅ **HTTP Status Codes**: 1xx (Info), 2xx (Success), 3xx (Redirect), 4xx (Client Error), 5xx (Server Error)
✅ **REST Principles**: Client-Server, Uniform Interface, Stateless, Cacheable, Layered
✅ **Design-First**: Write OpenAPI spec before coding
✅ **OpenAPI Spec**: JSON/YAML format with paths, schemas, security schemes
✅ **Google Maps API**: Real-world example of public paid API
✅ **API Lifecycle**: Define → Develop → Secure → Deploy → Enhance → Monetize
✅ **API Benefits**: Real-time integration, efficiency, platform independence, scalability

### 🚀 Next Steps

Section 3 will cover **Apigee Basics** including:
- Apigee introduction and provisioning
- API management concepts
- Flows, policies, and variables
- Proxy creation and configuration
- Debugging and tracing
- Target servers and load balancing
