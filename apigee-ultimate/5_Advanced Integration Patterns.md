# Section 5: Advanced Integration Patterns

## 5.1 Create Cloud Run Functions

### ☁️ Introduction to Cloud Run Functions

**Cloud Run Functions**: Serverless compute service that lets you run code in response to events without managing infrastructure.

**Key Characteristics**:
- ✅ Event-driven execution
- ✅ Auto-scaling (0 to N instances)
- ✅ Pay only for execution time
- ✅ No infrastructure management
- ✅ Integrated with Cloud Run

> [!NOTE]
> **Cloud Functions → Cloud Run Functions**: Google Cloud merged Cloud Functions into Cloud Run, hence the name "Cloud Run Functions."

### 🔧 Creating a Function

#### Step 1: Navigate to Cloud Run Functions

```
Google Cloud Console → Search: "cloud function"
    ↓
Cloud Run Functions (or Cloud Run)
    ↓
Create Function
```

#### Step 2: Basic Configuration

```yaml
Function Name: demo-function
Region: asia-south1 (Mumbai) # Choose nearest region
Trigger: HTTP
Authentication: Allow unauthenticated invocations
```

**Endpoint URL**: Auto-generated
```
https://asia-south1-my-first-project-12345.cloudfunctions.net/demo-function
```

#### Step 3: Runtime Configuration

```yaml
Runtime: Python 3.x
Memory: 256 MB (default)
Timeout: 60 seconds (default: 60s, max: 540s)
Max Instances: 10
Min Instances: 0
Ingress: Allow all traffic
```

**Auto-Scaling Settings**:
- **Max instances**: 10 (limit concurrent executions)
- **Min instances**: 0 (scale to zero when idle)
- **Max parallel executions**: 10 per instance

> [!IMPORTANT]
> **Container Creation**: Google Cloud packages your code into a container and runs it using Cloud Run. This happens automatically via Cloud Build.

#### Step 4: Write Function Code

**Default Python Function**:

```python
def hello_http(request):
    """HTTP Cloud Function.
    Args:
        request (flask.Request): The request object.
    Returns:
        The response text, or any set of values that can be turned into a
        Response object using `make_response`
    """
    request_json = request.get_json(silent=True)
    request_args = request.args

    # Priority: Body > Query Parameter > Default
    if request_json and 'name' in request_json:
        name = request_json['name']
    elif request_args and 'name' in request_args:
        name = request_args.get('name')
    else:
        name = 'World'
    
    return f'Hello {name}!'
```

**Entry Point**: `hello_http` (function name to execute)

#### Step 5: Deploy

```
Create → Deployment starts
    ↓
Cloud Build API enabled (if not already)
    ↓
Building container
    ↓
Deploying to Cloud Run
    ↓
Function Ready ✅
```

### 🧪 Testing the Function

#### Browser Test

```
URL: https://asia-south1-project-id.cloudfunctions.net/demo-function
Response: Hello World!

URL: https://asia-south1-project-id.cloudfunctions.net/demo-function?name=Varun
Response: Hello Varun!
```

#### Postman Test

**GET Request**:
```http
GET https://asia-south1-project-id.cloudfunctions.net/demo-function?name=Varun

Response: Hello Varun!
```

**POST Request with Body**:
```http
POST https://asia-south1-project-id.cloudfunctions.net/demo-function
Content-Type: application/json

{
  "name": "Nitish"
}

Response: Hello Nitish!
```

> [!NOTE]
> **Priority Order**: Body parameter > Query parameter > Default value

### 🔄 Function Versioning and Revisions

#### Updating Function Code

**Version 1**:
```python
def hello_http(request):
    # ... existing code ...
    return f'Hello {name} from v1!'
```

**Version 2**:
```python
def hello_http(request):
    # ... existing code ...
    return f'Hello {name} from v2!'
```

**Deployment Process**:
```
Edit Source → Modify code
    ↓
Save and Redeploy
    ↓
New revision created
    ↓
Traffic routed to new revision
```

#### Revision Management

**View Revisions**:
```
Function → Revisions Tab
    ↓
Revision 1: 0% traffic
Revision 2: 0% traffic
Revision 3: 100% traffic ← Active
```

### 🚦 Traffic Splitting

**Use Case**: Gradual rollout, A/B testing, canary deployments

**Configuration**:
```
Revisions → Manage Traffic
    ↓
Revision 3 (v2): 50%
Revision 2 (v1): 50%
    ↓
Save
```

**Result**: Requests randomly distributed 50/50 between versions.

**Testing**:
```
Request 1: Hello Varun from v1!
Request 2: Hello Varun from v2!
Request 3: Hello Varun from v1!
Request 4: Hello Varun from v2!
```

**Gradual Rollout Strategy**:
```
Phase 1: New version 10%, Old version 90%
    ↓ Monitor for issues
Phase 2: New version 50%, Old version 50%
    ↓ Continue monitoring
Phase 3: New version 100%, Old version 0%
```

### 🔐 Authenticated Functions

**Creating Authenticated Function**:

```yaml
Function Name: function-auth
Region: asia-south1
Trigger: HTTP
Authentication: Require authentication ← KEY DIFFERENCE
```

**Deployment**: Same as unauthenticated function

**Testing Without Auth**:
```http
GET https://asia-south1-project-id.cloudfunctions.net/function-auth

Response: 403 Forbidden
Error: Your client does not have permission to get URL
```

> [!IMPORTANT]
> Authenticated functions require **Google ID Token** for access. This is covered in the next lecture.

### 💡 Key Concepts

**Triggers**:
- **HTTP**: Direct HTTP requests (API-like)
- **Pub/Sub**: Message queue events
- **Cloud Storage**: File upload/change events
- **Firestore**: Database changes

**Billing**:
- **Request-based**: Pay per invocation
- **Compute-based**: Pay for execution time
- **Free Tier**: 2 million invocations/month

**Container Architecture**:
```mermaid
graph LR
    A[Your Code] -->|Cloud Build| B[Container Image]
    B -->|Deploy| C[Cloud Run]
    C -->|Execute| D[Function Instance]
```

### 🎯 Best Practices

✅ **Function Design**:
- Keep functions small and focused
- Use environment variables for configuration
- Implement proper error handling
- Set appropriate timeouts

✅ **Scaling**:
- Set max instances to prevent runaway costs
- Use min instances for latency-sensitive apps (but costs more)
- Monitor cold start times

✅ **Security**:
- Use authentication for production functions
- Validate all inputs
- Use service accounts with minimal permissions

---

## 5.2 IAM, Service Accounts and Google ID Token

### 🔐 IAM and Authentication

**IAM (Identity and Access Management)**: Google Cloud's permission system for controlling who can do what on which resources.

**Service Account**: A special type of account used by applications (not humans) to authenticate with Google Cloud services.

### 👤 User Authentication

#### Granting Cloud Run Invoker Role

**Navigate to IAM**:
```
Google Cloud Console → IAM & Admin → IAM
    ↓
Find your user account
    ↓
Edit Principal
```

**Required Roles**:
```yaml
Roles to Add:
  - Cloud Run Invoker
  - Cloud Functions Invoker (legacy)
```

> [!NOTE]
> **Why Both Roles?**
> - **Cloud Functions Invoker**: For older Cloud Functions
> - **Cloud Run Invoker**: For Cloud Run Functions (current)

**IAM Structure**:
```
Principal: user@example.com
Role: Cloud Run Invoker
Scope: Project (my-first-project)
```

#### Generating ID Token

**Using Cloud Shell**:

```bash
gcloud auth print-identity-token
```

**Output**:
```
eyJhbGciOiJSUzI1NiIsImtpZCI6IjY4...  # Long JWT token
```

**Using Token in Postman**:

```http
GET https://asia-south1-project-id.cloudfunctions.net/function-auth
Authorization: Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjY4...

Response: Hello World from auth v1!
```

### 🤖 Service Accounts

**Purpose**: Allow applications to authenticate with Google Cloud services.

**When to Use**:
- App-to-app communication
- Apigee calling Cloud Functions
- Automated processes
- CI/CD pipelines

#### Creating a Service Account

```
IAM & Admin → Service Accounts → Create Service Account
```

**Configuration**:
```yaml
Name: apigee-service-account
Service Account ID: apigee-service-account@project-id.iam.gserviceaccount.com
Description: Service account used by Apigee to interact with Google Cloud services
```

#### Granting Permissions

**Required Roles**:
```yaml
Roles:
  - Cloud Run Invoker
  - Cloud Functions Invoker
```

**Why?** Service account needs permission to invoke functions.

### 🔑 Service Account Impersonation

**Impersonation**: Acting on behalf of a service account to generate tokens.

**Command**:
```bash
gcloud auth print-identity-token \
  --impersonate-service-account=apigee-service-account@project-id.iam.gserviceaccount.com
```

**Initial Error**:
```
ERROR: (gcloud.auth.print-identity-token) User [user@example.com] does not have 
permission to access service account [apigee-service-account@project-id.iam.gserviceaccount.com]
```

**Why?** Not everyone can impersonate service accounts (security measure).

### 🎭 Granting Impersonation Permissions

**Service Account as Resource**:

```
Service Accounts → apigee-service-account → Permissions
    ↓
Grant Access
```

**Required Roles**:
```yaml
Principal: user@example.com
Roles:
  - Service Account Token Creator
  - Service Account User
```

**Role Explanations**:
- **Service Account Token Creator**: Generate tokens for the service account
- **Service Account User**: Run operations as the service account

#### Testing Impersonation

**After Granting Permissions** (wait 1-2 minutes for propagation):

```bash
gcloud auth print-identity-token \
  --impersonate-service-account=apigee-service-account@project-id.iam.gserviceaccount.com
```

**Output**:
```
eyJhbGciOiJSUzI1NiIsImtpZCI6IjY4...  # Service account token
```

**Using in Postman**:

```http
GET https://asia-south1-project-id.cloudfunctions.net/function-auth
Authorization: Bearer <SERVICE_ACCOUNT_TOKEN>

Response: Hello Pankaj from auth v1!
```

### 🔄 Authentication Flow

```mermaid
sequenceDiagram
    participant User
    participant CloudShell
    participant IAM
    participant SA as Service Account
    participant Function
    
    User->>CloudShell: gcloud auth print-identity-token --impersonate-service-account
    CloudShell->>IAM: Request impersonation
    IAM->>IAM: Check permissions
    IAM->>SA: Generate token for SA
    SA->>CloudShell: Return ID token
    CloudShell->>User: Display token
    User->>Function: Call with Bearer token
    Function->>IAM: Validate token
    IAM->>Function: Token valid
    Function->>User: Return response
```

### 💡 Key Concepts

**Identity Types**:
```
User Accounts:
├─ For humans
├─ Email-based (user@example.com)
└─ Interactive login

Service Accounts:
├─ For applications
├─ Email format (sa-name@project-id.iam.gserviceaccount.com)
└─ Programmatic access
```

**Token Types**:
- **ID Token**: For authenticating with Google services (what we use)
- **Access Token**: For calling Google Cloud APIs
- **Refresh Token**: For obtaining new access tokens

**Permission Hierarchy**:
```
Organization
    ↓
Folder
    ↓
Project ← We grant permissions here
    ↓
Resource (Function)
```

### 🎯 Why This Matters for Apigee

**Scenario**: Apigee proxy needs to call authenticated Cloud Function

**Solution**:
1. Create service account for Apigee
2. Grant Cloud Run Invoker role
3. Configure Apigee to use service account
4. Apigee generates ID token automatically
5. Apigee calls function with token

> [!IMPORTANT]
> This setup enables **secure, automated** communication between Apigee and Cloud Functions without manual token management.

---

## 5.3 Import IAM-secured Cloud Function in Apigee

### 🔗 Connecting Apigee to Authenticated Functions

**Goal**: Create an Apigee proxy that calls an IAM-secured Cloud Function.

**Challenge**: Function requires Google ID token for authentication.

**Solution**: Configure Apigee to automatically generate and use ID tokens.

### 📋 Creating the Proxy

#### Step 1: Create Reverse Proxy

```
Apigee → API Proxies → Create New
    ↓
Template: Reverse proxy (default)
```

**Configuration**:
```yaml
Name: function-auth
Base Path: /gcp/function-auth
Target URL: https://asia-south1-project-id.cloudfunctions.net/function-auth
Description: Proxy showcasing authentication with Google Cloud services using Google ID token
```

#### Step 2: Deploy

```
Environment: eval
    ↓
Deploy
```

#### Step 3: Test (Will Fail)

**Request**:
```http
GET https://org-name-eval.apigee.net/gcp/function-auth?name=Test
```

**Response**:
```json
{
  "fault": {
    "faultstring": "Your client does not have permission to get URL",
    "detail": {
      "errorcode": "steps.httpclient.Error"
    }
  }
}
```

**Why?** Proxy is calling function without authentication.

### 🔐 Adding Google Authentication

#### Authentication Element

**Documentation**: [API Proxy Configuration for Authentication](https://cloud.google.com/apigee/docs/api-platform/reference/proxy-configuration-reference#authentication)

**XML Structure**:
```xml
<HTTPTargetConnection>
  <URL>https://target-url</URL>
  <Authentication>
    <GoogleIDToken>
      <Audience>https://target-url</Audience>
    </GoogleIDToken>
  </Authentication>
</HTTPTargetConnection>
```

#### Step 4: Configure Target Endpoint

**Edit Target Endpoint XML**:

```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<TargetEndpoint name="default">
  <PreFlow name="PreFlow">
    <Request/>
    <Response/>
  </PreFlow>
  <Flows/>
  <PostFlow name="PostFlow">
    <Request/>
    <Response/>
  </PostFlow>
  <HTTPTargetConnection>
    <URL>https://asia-south1-project-id.cloudfunctions.net/function-auth</URL>
    <Authentication>
      <GoogleIDToken>
        <Audience>https://asia-south1-project-id.cloudfunctions.net/function-auth</Audience>
      </GoogleIDToken>
    </Authentication>
  </HTTPTargetConnection>
</TargetEndpoint>
```

**Key Elements**:
- `<GoogleIDToken>`: Tells Apigee to generate Google ID token
- `<Audience>`: Target URL (must match function URL)

#### Step 5: Deploy with Service Account

**Deployment Error**:
```
Error: Deployment requires a service account when using GoogleIDToken authentication
```

**Solution**: Provide service account during deployment

**Deploy Dialog**:
```yaml
Environment: eval
Service Account: apigee-service-account@project-id.iam.gserviceaccount.com
```

**Deploy** → Success! ✅

### 🧪 Testing

**Request**:
```http
GET https://org-name-eval.apigee.net/gcp/function-auth?name=Nitish
```

**Response**:
```
Hello Nitish from auth v1!
```

✅ **Success!** Apigee automatically:
1. Generated Google ID token using service account
2. Added token to Authorization header
3. Called function successfully

### 🔍 How It Works

```mermaid
sequenceDiagram
    participant Client
    participant Apigee
    participant IAM
    participant Function
    
    Client->>Apigee: GET /gcp/function-auth
    Apigee->>Apigee: Check target endpoint config
    Apigee->>IAM: Request ID token (as service account)
    IAM->>Apigee: Return ID token
    Apigee->>Function: Call with Bearer token
    Function->>IAM: Validate token
    IAM->>Function: Token valid
    Function->>Apigee: Response
    Apigee->>Client: Response
```

### 🔧 Behind the Scenes

**Apigee Automatically**:
1. Detects `<GoogleIDToken>` element
2. Uses configured service account
3. Calls Google OAuth endpoints
4. Obtains ID token
5. Adds `Authorization: Bearer <token>` header
6. Makes request to target

**Token Lifecycle**:
- Tokens cached for performance
- Auto-refreshed when expired
- No manual token management needed

### 🎯 Alternative: Google Access Token

**For Google Cloud APIs** (not Cloud Functions):

```xml
<Authentication>
  <GoogleAccessToken>
    <Scopes>
      <Scope>https://www.googleapis.com/auth/cloud-platform</Scope>
    </Scopes>
  </GoogleAccessToken>
</Authentication>
```

**Example Use Cases**:
- Secret Manager API
- Cloud Storage API
- Compute Engine API
- Any Google Cloud API

**Difference**:
- **ID Token**: For authenticating with services (Cloud Functions, Cloud Run)
- **Access Token**: For calling Google Cloud APIs
- **Scope**: Defines permissions for access token

### 💡 Key Concepts

**Service Account at Proxy Level**:
```
Proxy Deployment:
├─ Environment: eval
├─ Service Account: apigee-sa@project.iam.gserviceaccount.com
└─ Scope: This proxy only
```

**Benefits**:
- Different proxies can use different service accounts
- Principle of least privilege
- Better security isolation
- Easier auditing

**Configuration Comparison**:

| Element | Purpose | Use For |
|---------|---------|---------|
| `<GoogleIDToken>` | Authenticate with services | Cloud Functions, Cloud Run |
| `<GoogleAccessToken>` | Call Google APIs | Secret Manager, Storage, etc. |
| `<Audience>` | Target URL | Required for ID tokens |
| `<Scopes>` | API permissions | Required for access tokens |

### 🎯 Best Practices

✅ **Service Account Management**:
- Create dedicated service accounts per proxy/purpose
- Grant minimum required permissions
- Use descriptive names
- Document service account usage

✅ **Security**:
- Never hardcode credentials
- Use service accounts, not user accounts
- Rotate service account keys regularly (if using keys)
- Monitor service account usage

✅ **Configuration**:
- Always specify audience for ID tokens
- Use appropriate scopes for access tokens
- Test authentication in non-production first
- Document authentication requirements

---

## 5.4 Persistency and Response Cache Design

### 💾 Data Persistence in Apigee

**Three Persistence Features**:

```mermaid
graph TD
    A[Apigee Persistence] --> B[Response Cache]
    A --> C[Property Sets]
    A --> D[Key Value Maps KVM]
    
    B --> B1[General caching]
    B --> B2[Avoid backend calls]
    B --> B3[Improve performance]
    
    C --> C1[Configuration files]
    C --> C2[Key-value properties]
    C --> C3[Runtime config]
    
    D --> D1[Encrypted storage]
    D --> D2[Credentials/secrets]
    D --> D3[Sensitive data]
```

### 📦 Feature Comparison

| Feature | Purpose | Storage | Use Case |
|---------|---------|---------|----------|
| **Response Cache** | Cache API responses | In-memory | Reduce backend calls, improve performance |
| **Property Sets** | Store configuration | File-based | Config parameters, environment settings |
| **Key Value Maps (KVM)** | Store secrets | Encrypted NoSQL | API keys, passwords, credentials |

### 🎯 Response Cache Use Case

**Scenario**: Employee API with High Traffic

```mermaid
graph LR
    A[Client Requests] -->|High Volume| B[Apigee Proxy]
    B -->|Every Request| C[Employee API]
    C -->|Queries| D[Employee Database]
    D -->|Updates Hourly| D
```

**Problem**:
- ❌ Database updates only hourly
- ❌ Same data returned for many requests
- ❌ Unnecessary backend load
- ❌ Wasted resources

**Solution**: Response Caching

```mermaid
graph LR
    A[Client Requests] -->|High Volume| B[Apigee Proxy]
    B -->|Cache Miss| C[Employee API]
    B -->|Cache Hit| E[Return from Cache]
    C -->|Response| D[Cache Storage]
    D -->|Cached Response| E
```

### 🔧 Cache Mechanism

#### Cache Write (Response Flow)

```
Client Request
    ↓
Proxy → Target API
    ↓
Target Response
    ↓
Response Flow: Cache Policy (WRITE)
    ├─ Key: employee-id-123
    ├─ Value: {"id": 123, "name": "John", ...}
    └─ TTL: 1 hour
    ↓
Return to Client
```

#### Cache Read (Request Flow)

```
Client Request
    ↓
Request Flow: Cache Policy (LOOKUP)
    ├─ Key: employee-id-123
    ├─ Found? YES
    └─ Return cached value
    ↓
Skip Target Call
    ↓
Return to Client (from cache)
```

### 🔑 Cache Key Design

**Critical Consideration**: Cache key must be **consistent** between read and write operations.

**Example - Correct**:

```xml
<!-- Request Flow - Lookup -->
<ResponseCache>
  <CacheKey>
    <KeyFragment ref="request.queryparam.employee_id"/>
  </CacheKey>
</ResponseCache>

<!-- Response Flow - Populate -->
<ResponseCache>
  <CacheKey>
    <KeyFragment ref="request.queryparam.employee_id"/>
  </CacheKey>
</ResponseCache>
```

**Example - Incorrect**:

```xml
<!-- Request Flow - Uses request.uri -->
<ResponseCache>
  <CacheKey>
    <KeyFragment ref="request.uri"/>  <!-- /employees?id=123 -->
  </CacheKey>
</ResponseCache>

<!-- Response Flow - Uses modified URI -->
<ResponseCache>
  <CacheKey>
    <KeyFragment ref="request.uri"/>  <!-- /api/v1/employees?id=123 (changed!) -->
  </CacheKey>
</ResponseCache>
```

❌ **Problem**: If URI is modified between request and response flows, keys won't match!

### ⚠️ Common Mistakes

#### Mistake 1: URI Modification

**Scenario**:
```
Original URI: /employees?id=123
    ↓
Proxy modifies to: /api/v1/employees?id=123
    ↓
Cache key changes!
    ↓
Cache miss every time
```

**Solution**: Use stable key (query param, header, etc.)

#### Mistake 2: Inconsistent Key Fragments

```xml
<!-- Lookup uses query param -->
<CacheKey>
  <KeyFragment ref="request.queryparam.id"/>
</CacheKey>

<!-- Populate uses header -->
<CacheKey>
  <KeyFragment ref="request.header.employee-id"/>
</CacheKey>
```

❌ **Problem**: Different keys = cache never hits

#### Mistake 3: Wrong Flow Placement

```xml
<!-- ❌ WRONG: Both in request flow -->
<PreFlow name="PreFlow">
  <Request>
    <Step><Name>LookupCache</Name></Step>
    <Step><Name>PopulateCache</Name></Step>  <!-- Wrong place! -->
  </Request>
</PreFlow>

<!-- ✅ CORRECT: Lookup in request, populate in response -->
<PreFlow name="PreFlow">
  <Request>
    <Step><Name>LookupCache</Name></Step>
  </Request>
  <Response>
    <Step><Name>PopulateCache</Name></Step>
  </Response>
</PreFlow>
```

### 📊 Cache Flow Diagram

```mermaid
sequenceDiagram
    participant Client
    participant Request as Request Flow
    participant Cache
    participant Target
    participant Response as Response Flow
    
    Client->>Request: GET /employee?id=123
    Request->>Cache: Lookup (key: 123)
    
    alt Cache Hit
        Cache->>Request: Return cached data
        Request->>Client: Response (from cache)
    else Cache Miss
        Request->>Target: Forward request
        Target->>Response: Return data
        Response->>Cache: Store (key: 123, value: data, TTL: 1h)
        Response->>Client: Response (from target)
    end
```

### ⏱️ Time to Live (TTL)

**Purpose**: Control how long cached data remains valid

**Configuration**:
```xml
<ResponseCache>
  <ExpirySettings>
    <TimeoutInSeconds>3600</TimeoutInSeconds>  <!-- 1 hour -->
  </ExpirySettings>
</ResponseCache>
```

**Considerations**:
- ✅ **Short TTL**: More accurate data, more backend calls
- ✅ **Long TTL**: Better performance, potentially stale data
- ✅ **Match data update frequency**: If DB updates hourly, cache for ~1 hour

### 💡 Key Takeaways

**Cache Policy Characteristics**:
- ✅ Single policy used in both request and response flows
- ✅ Automatically handles lookup and populate
- ✅ Key must be identical in both flows
- ✅ TTL controls cache lifetime

**When to Use Response Cache**:
- ✅ Data doesn't change frequently
- ✅ Same requests made repeatedly
- ✅ Backend is slow or expensive
- ✅ Can tolerate slightly stale data

**When NOT to Use**:
- ❌ Real-time data requirements
- ❌ User-specific/personalized data
- ❌ Frequently changing data
- ❌ POST/PUT/DELETE operations (usually)

---

## 5.5 Response Cache Implementation

### 🛠️ Implementing Response Cache

**Target**: Unauthenticated Cloud Function with traffic split

**Function Details**:
```
URL: https://asia-south1-project-id.cloudfunctions.net/function-noauth
Traffic Split:
  - Revision 2 (v1): 50%
  - Revision 3 (v2): 50%
```

**Problem**: Same user gets different responses due to traffic split

```
Request 1: Hello Mohan from v1
Request 2: Hello Mohan from v2
Request 3: Hello Mohan from v1
```

**Solution**: Cache the response so users get consistent results

### 📋 Creating the Proxy

#### Step 1: Create Proxy

```
Apigee → API Proxies → Create New
```

**Configuration**:
```yaml
Name: functions-noauth
Base Path: /gcp/function-noauth
Target URL: https://asia-south1-project-id.cloudfunctions.net/function-noauth
```

#### Step 2: Test Without Cache

**Request**:
```http
GET https://org-eval.apigee.net/gcp/function-noauth?name=Mohan
```

**Responses** (random due to traffic split):
```
Response 1: Hello Mohan from v2
Response 2: Hello Mohan from v1
Response 3: Hello Mohan from v2
Response 4: Hello Mohan from v1
```

### 🔧 Adding Response Cache Policy

#### Step 3: Create Policy

```
Proxy → Develop → Policies → Add
    ↓
Type: Response Cache
Name: ResponseCache
```

**Policy Configuration**:

```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<ResponseCache name="ResponseCache">
  <CacheKey>
    <KeyFragment ref="request.queryparam.name"/>
  </CacheKey>
  <Scope>Exclusive</Scope>
  <ExpirySettings>
    <TimeoutInSeconds>600</TimeoutInSeconds>  <!-- 10 minutes -->
  </ExpirySettings>
  <SkipCacheLookup>request.verb != "GET"</SkipCacheLookup>
  <SkipCachePopulation>request.verb != "GET"</SkipCachePopulation>
</ResponseCache>
```

### 📋 Policy Elements Explained

#### CacheKey

**Purpose**: Unique identifier for cached entry

```xml
<CacheKey>
  <KeyFragment ref="request.queryparam.name"/>
</CacheKey>
```

**Result**: Cache key = value of `name` query parameter

**Examples**:
```
name=Mohan → Cache key: Mohan
name=Nitish → Cache key: Nitish
```

#### Scope

**Purpose**: Determines cache key prefix

```xml
<Scope>Exclusive</Scope>
```

**Scope Types**:

| Scope | Prefix | Use Case |
|-------|--------|----------|
| `Exclusive` | `orgId__envName__proxyName__endpointName__keyFragment` | Default, most specific |
| `Application` | `orgId__envName__proxyName__keyFragment` | Share across proxy endpoints |
| `Global` | `orgId__envName__keyFragment` | Share across all proxies |

**Exclusive Scope Example**:
```
Full Key: my-org__eval__functions-noauth__default__Mohan
          └─────┘  └──┘  └──────────────┘  └─────┘  └───┘
           Org    Env      Proxy Name     Endpoint  Key
```

> [!NOTE]
> **Prefix vs. Scope**: If you specify `<Prefix>`, it overrides scope. Without prefix, scope determines the prefix automatically.

#### ExpirySettings

**Purpose**: Control cache lifetime

```xml
<ExpirySettings>
  <TimeoutInSeconds>600</TimeoutInSeconds>  <!-- 10 minutes -->
</ExpirySettings>
```

**Alternative - Expiry Date**:
```xml
<ExpirySettings>
  <ExpiryDate>01-01-2025</ExpiryDate>
</ExpirySettings>
```

**Alternative - Time of Day**:
```xml
<ExpirySettings>
  <TimeOfDay>23:59:59</TimeOfDay>
</ExpirySettings>
```

#### SkipCacheLookup

**Purpose**: Conditionally skip cache lookup

```xml
<SkipCacheLookup>request.verb != "GET"</SkipCacheLookup>
```

**Meaning**: Only use cache for GET requests

**Why?** POST/PUT/DELETE shouldn't use cached responses

#### SkipCachePopulation

**Purpose**: Conditionally skip cache write

```xml
<SkipCachePopulation>request.verb != "GET"</SkipCachePopulation>
```

**Meaning**: Only cache GET responses

#### UseResponseCacheHeaders

**Purpose**: Use HTTP cache headers from target response

```xml
<UseResponseCacheHeaders>false</UseResponseCacheHeaders>  <!-- Default -->
```

**When true**: Apigee respects `Cache-Control`, `Expires` headers from target

**When false**: Apigee uses configured TTL only

### 📍 Attaching the Policy

#### Step 4: Attach to Flows

**Request Flow** (Proxy Endpoint → PreFlow → Request):
```xml
<PreFlow>
  <Request>
    <Step><Name>ResponseCache</Name></Step>
  </Request>
</PreFlow>
```

**Response Flow** (Target Endpoint → PostFlow → Response):
```xml
<PostFlow>
  <Response>
    <Step><Name>ResponseCache</Name></Step>
  </Response>
</PostFlow>
```

**Why These Locations?**
- **Request PreFlow**: Check cache as early as possible
- **Target Response PostFlow**: Store response after receiving from target

### 🧪 Testing

#### Step 5: Deploy and Test

**First Request** (Cache Miss):
```http
GET /gcp/function-noauth?name=Mohan

Response: Hello Mohan from v2
Time: 450ms
```

**Debug Trace**:
```
Flow Variables:
├─ responsecache.ResponseCache.cachehit: false
├─ responsecache.ResponseCache.cachekey: my-org__eval__functions-noauth__default__Mohan
└─ Target called: ✅ Yes
```

**Second Request** (Cache Hit):
```http
GET /gcp/function-noauth?name=Mohan

Response: Hello Mohan from v2  (same as first!)
Time: 150ms (3x faster!)
```

**Debug Trace**:
```
Flow Variables:
├─ responsecache.ResponseCache.cachehit: true
├─ responsecache.ResponseCache.cachekey: my-org__eval__functions-noauth__default__Mohan
└─ Target called: ❌ No (skipped!)
```

**Different Name** (New Cache Entry):
```http
GET /gcp/function-noauth?name=Vineyard

Response: Hello Vineyard from v1
Time: 430ms
```

**Debug Trace**:
```
Flow Variables:
├─ responsecache.ResponseCache.cachehit: false
├─ responsecache.ResponseCache.cachekey: my-org__eval__functions-noauth__default__Vineyard
└─ Target called: ✅ Yes (new key)
```

### 📊 Cache Behavior

```mermaid
graph TD
    A[Request: name=Mohan] --> B{Cache Lookup}
    B -->|Hit| C[Return from Cache]
    B -->|Miss| D[Call Target]
    D --> E[Store in Cache]
    E --> F[Return Response]
    
    G[Request: name=Mohan again] --> H{Cache Lookup}
    H -->|Hit| I[Return from Cache - Same Response!]
    
    J[Request: name=Vineyard] --> K{Cache Lookup}
    K -->|Miss| L[Call Target]
    L --> M[Store in Cache]
    M --> N[Return Response]
```

### 🔍 Debug Trace Analysis

**Cache Miss Flow**:
```
1. Proxy Request Flow
2. ResponseCache Policy (Lookup) → Miss
3. Target Request Flow
4. Target Call → Backend
5. Target Response Flow
6. ResponseCache Policy (Populate) → Store
7. Proxy Response Flow
8. Return to Client
```

**Cache Hit Flow**:
```
1. Proxy Request Flow
2. ResponseCache Policy (Lookup) → Hit!
3. Skip to Proxy Response Flow (no target call)
4. Return to Client
```

### ⚠️ Cache Limits

> [!WARNING]
> **Eval Org Cache Limit**: Limited cache size (exact limit varies)
> 
> **Production**: Configure cache resources with appropriate sizes

**Monitoring**:
- Watch for cache evictions
- Monitor cache hit ratio
- Adjust TTL based on usage patterns

### 💡 Best Practices

✅ **Cache Key Design**:
- Use stable, predictable values
- Include all parameters that affect response
- Keep keys simple and consistent

✅ **TTL Selection**:
- Match data update frequency
- Consider business requirements
- Balance freshness vs. performance

✅ **Conditional Caching**:
- Only cache GET requests
- Don't cache errors (add conditions)
- Consider user-specific data carefully

✅ **Testing**:
- Test cache miss scenario
- Test cache hit scenario
- Test different cache keys
- Verify TTL expiration

---

## 5.6 Cache Resource, Scopes and Prefix Concepts

### 🎯 Understanding Cache Scopes

**Scope**: Determines the automatic prefix added to cache keys, affecting cache entry uniqueness and sharing.

### 📊 Scope Types

#### 1. Exclusive Scope (Default)

**Configuration**:
```xml
<ResponseCache name="ResponseCache">
  <Scope>Exclusive</Scope>
  <CacheKey>
    <KeyFragment ref="request.queryparam.name"/>
  </CacheKey>
</ResponseCache>
```

**Prefix Pattern**:
```
orgId__envName__proxyName__endpointName__keyFragment
```

**Example**:
```
Input: name=JC
Full Key: my-org__eval__functions-noauth__default__JC
```

**Characteristics**:
- ✅ Most specific scope
- ✅ Isolated per proxy endpoint
- ✅ Different endpoints can have same key without conflict
- ✅ Recommended for most use cases

#### 2. Application Scope

**Configuration**:
```xml
<ResponseCache name="ResponseCache">
  <Scope>Application</Scope>
  <CacheKey>
    <KeyFragment ref="request.queryparam.name"/>
  </CacheKey>
</ResponseCache>
```

**Prefix Pattern**:
```
orgId__envName__proxyName__keyFragment
```

**Example**:
```
Input: name=JC
Full Key: my-org__eval__functions-noauth__JC
```

**Characteristics**:
- ✅ Shared across all endpoints in the proxy
- ✅ Proxy endpoint and target endpoint share cache
- ⚠️ Be careful with endpoint-specific data

#### 3. Global Scope

**Configuration**:
```xml
<ResponseCache name="ResponseCache">
  <Scope>Global</Scope>
  <CacheKey>
    <KeyFragment ref="request.queryparam.name"/>
  </CacheKey>
</ResponseCache>
```

**Prefix Pattern**:
```
orgId__envName__keyFragment
```

**Example**:
```
Input: name=JC
Full Key: my-org__eval__JC
```

**Characteristics**:
- ✅ Shared across ALL proxies in the environment
- ✅ Useful for common data (e.g., reference data)
- ⚠️ Risk of key collisions between proxies
- ⚠️ One proxy can invalidate another's cache

### 🔑 Custom Prefix

**Override Scope with Prefix**:

```xml
<ResponseCache name="ResponseCache">
  <Prefix>my-function</Prefix>
  <CacheKey>
    <KeyFragment ref="request.queryparam.name"/>
  </CacheKey>
</ResponseCache>
```

**Result**:
```
Input: name=Jesse
Full Key: my-function__Jesse
```

**When Prefix is Specified**:
- ❌ Scope is **ignored**
- ✅ Only prefix + key fragment used
- ✅ Full control over key structure

### 💾 Cache Resources

**Cache Resource**: Named cache storage with configurable size and properties.

#### Default: Shared Cache

**When No CacheResource Specified**:

```xml
<ResponseCache name="ResponseCache">
  <!-- No CacheResource element -->
  <Scope>Exclusive</Scope>
</ResponseCache>
```

**Uses**: Shared cache named `orgId__envName`

**Example**: `my-org__eval`

#### Custom Cache Resource

**Configuration**:

```xml
<ResponseCache name="ResponseCache">
  <CacheResource>my-custom-cache</CacheResource>
  <Scope>Exclusive</Scope>
</ResponseCache>
```

**Full Cache Name**: `orgId__envName__my-custom-cache`

**Example**: `my-org__eval__my-custom-cache`

**Benefits**:
- ✅ Dedicated cache for specific use case
- ✅ Separate size limits
- ✅ Independent eviction policies
- ✅ Better cache management

### 🎯 Scope Impact on Cache Operations

#### Scenario: Invalidate Cache

**With Exclusive Scope**:
```xml
<InvalidateCache>
  <Scope>Exclusive</Scope>
  <CacheKey>
    <KeyFragment ref="request.queryparam.name"/>
  </CacheKey>
</InvalidateCache>
```

**Effect**: Invalidates cache for this proxy/endpoint only

**With Global Scope**:
```xml
<InvalidateCache>
  <Scope>Global</Scope>
  <CacheKey>
    <KeyFragment ref="request.queryparam.name"/>
  </CacheKey>
</InvalidateCache>
```

**Effect**: Invalidates cache across ALL proxies in environment!

> [!WARNING]
> **Global Scope Risk**: Invalidating a global cache entry affects all proxies using that key. Use with caution!

### 📋 Scope Comparison Table

| Scope | Prefix | Isolation Level | Use Case |
|-------|--------|-----------------|----------|
| **Exclusive** | `org__env__proxy__endpoint__key` | Per endpoint | Default, most isolated |
| **Application** | `org__env__proxy__key` | Per proxy | Share across endpoints |
| **Global** | `org__env__key` | Per environment | Share across proxies |
| **Custom Prefix** | `prefix__key` | Custom | Full control |

### 🔄 Cache Sharing Examples

#### Example 1: Exclusive Scope

```
Proxy A, Endpoint 1: org__eval__proxyA__ep1__user123
Proxy A, Endpoint 2: org__eval__proxyA__ep2__user123
Proxy B, Endpoint 1: org__eval__proxyB__ep1__user123
```

**Result**: 3 separate cache entries (fully isolated)

#### Example 2: Application Scope

```
Proxy A, Endpoint 1: org__eval__proxyA__user123
Proxy A, Endpoint 2: org__eval__proxyA__user123  ← Same!
Proxy B, Endpoint 1: org__eval__proxyB__user123
```

**Result**: Proxy A endpoints share cache, Proxy B separate

#### Example 3: Global Scope

```
Proxy A, Endpoint 1: org__eval__user123
Proxy A, Endpoint 2: org__eval__user123  ← Same!
Proxy B, Endpoint 1: org__eval__user123  ← Same!
```

**Result**: All proxies share the same cache entry

### 💡 Best Practices

✅ **Scope Selection**:
- **Default to Exclusive**: Safest, prevents conflicts
- **Use Application**: When endpoints should share cache
- **Use Global**: Only for truly shared reference data
- **Use Prefix**: When you need custom key structure

✅ **Cache Resource**:
- Create dedicated cache resources for high-volume APIs
- Use shared cache for low-volume or testing
- Monitor cache size and eviction rates
- Set appropriate expiration times

✅ **Key Design**:
- Keep keys simple and predictable
- Document scope and prefix choices
- Consider future cache invalidation needs
- Test cache behavior across scopes

### 🎯 Practical Recommendations

**For Most APIs**:
```xml
<ResponseCache name="ResponseCache">
  <Scope>Exclusive</Scope>  <!-- Isolated -->
  <CacheKey>
    <KeyFragment ref="request.queryparam.id"/>
  </CacheKey>
</ResponseCache>
```

**For Shared Reference Data**:
```xml
<ResponseCache name="ResponseCache">
  <Scope>Global</Scope>  <!-- Shared -->
  <CacheResource>reference-data-cache</CacheResource>
  <CacheKey>
    <KeyFragment ref="request.queryparam.country_code"/>
  </CacheKey>
</ResponseCache>
```

**For Custom Control**:
```xml
<ResponseCache name="ResponseCache">
  <Prefix>user-profiles</Prefix>  <!-- Custom -->
  <CacheKey>
    <KeyFragment ref="request.header.user-id"/>
  </CacheKey>
</ResponseCache>
```

---

*[Content continues with sections 5.7-5.18 covering Apigee API, KVM, Property Sets, Service Callouts, Advanced Caching, and JavaScript...]*

---

## Summary

This section covered advanced integration patterns in Apigee:

✅ **Cloud Integration**: Cloud Run Functions, IAM, service accounts
✅ **Caching**: Response cache, PopulateCache, LookupCache, InvalidateCache
✅ **Data Storage**: KVM for secrets, Property Sets for configuration
✅ **Service Integration**: HTTP callouts, path chaining, proxy chaining
✅ **Extensibility**: JavaScript policies for custom logic

These patterns enable building sophisticated, performant, and secure API solutions on Apigee.
