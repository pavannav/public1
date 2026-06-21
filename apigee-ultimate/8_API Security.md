# Section 8: API Security

## 8.1 API Security Overview

### 🔒 Security Dimensions

**Comprehensive API Security** requires addressing multiple layers:

```mermaid
graph TD
    A[API Security] --> B[Platform Security]
    A --> C[Traffic Management]
    A --> D[Authentication & Authorization]
    A --> E[In-Transit Security]
    A --> F[Content-Based Security]
    A --> G[Data Confidentiality]
```

### 📋 Security Layers

#### 1. Platform Security

**Foundation**: APIs can only be as secure as the underlying infrastructure.

**Google Cloud & Apigee**:
- Fully managed service
- Secure by design
- Regular security updates
- Compliance certifications (SOC 2, ISO 27001, etc.)
- Physical security of data centers

#### 2. Traffic Management

**Policies Covered**:
- ✅ **Spike Arrest**: Rate limiting (Section 4)
- ✅ **Quota**: Usage limits (Section 4)
- ✅ **CORS**: Cross-origin security (Section 7)
- 🆕 **IP Filtering**: Access Control policy (this section)

#### 3. Authentication & Authorization

**Methods**:
- ✅ **SAML**: Developer Portal SSO (Section 7)
- 🆕 **Basic Authentication**: Username/password
- 🆕 **OAuth2**: Delegated authorization
- 🆕 **JWT**: JSON Web Tokens

#### 4. In-Transit Security

**TLS/SSL**:
- Transport Layer Security
- SSL certificates
- Trust certificates
- **Covered in**: Section 9 (Administration)

#### 5. Content-Based Security

**Protection Policies**:
- **JSON Threat Protection**: Prevent malicious JSON payloads
- **XML Threat Protection**: Prevent malicious XML payloads
- **RegEx Protection**: Prevent SQL injection, XSS attacks

#### 6. Data Confidentiality

**Mechanisms**:
- **RBAC**: Role-Based Access Control
- **IAM**: Identity and Access Management
- **Service Accounts**: Covered in Section 5
- **Private Variables**: Hide sensitive data in traces
- **Debug Masks**: Mask sensitive data in debug sessions

### 💡 Key Concepts

**Security is Multi-Layered**:
- No single security measure is sufficient
- Defense in depth approach
- Each layer addresses different threats
- Combination provides robust protection

**Industry-Standard Concepts**:
- OAuth2, JWT, TLS, CORS are universal
- Not limited to Apigee or APIs
- Valuable throughout IT career
- Worth investing time to understand deeply

---

## 8.2 Basic Authentication (for Proxy and Backend)

### 🔑 Basic Authentication Overview

**Basic Authentication**: Simplest HTTP authentication scheme using username and password.

**Format**:
```
Authorization: Basic <base64-encoded-credentials>
```

**Encoding**:
```
username:password → base64 → dXNlcm5hbWU6cGFzc3dvcmQ=
```

### 🔧 Implementation Scenarios

#### Scenario 1: Proxy-Level Basic Auth

**Use Case**: Protect proxy with username/password before reaching backend.

**Policy**: `BasicAuthentication`

**Configuration**:
```xml
<BasicAuthentication name="BasicAuth">
  <Operation>Decode</Operation>
  <IgnoreUnresolvedVariables>false</IgnoreUnresolvedVariables>
  <User ref="request.header.username"/>
  <Password ref="request.header.password"/>
  <Source>request.header.Authorization</Source>
</BasicAuthentication>
```

**Flow**:
```
1. Client sends: Authorization: Basic dXNlcm5hbWU6cGFzc3dvcmQ=
2. Policy decodes credentials
3. Extracts username and password
4. Validates against stored credentials
5. Allows/denies request
```

#### Scenario 2: Backend Basic Auth

**Use Case**: Backend requires basic auth, but you don't want to expose credentials to clients.

**Policy**: `BasicAuthentication` (Encode operation)

**Configuration**:
```xml
<BasicAuthentication name="EncodeBackendAuth">
  <Operation>Encode</Operation>
  <IgnoreUnresolvedVariables>false</IgnoreUnresolvedVariables>
  <User>backend-username</User>
  <Password>backend-password</Password>
</BasicAuthentication>
```

**Flow**:
```
1. Client calls proxy (with API key or other auth)
2. Proxy validates client
3. Proxy adds Basic Auth header for backend
4. Backend receives authenticated request
```

**Generated Header**:
```
Authorization: Basic YmFja2VuZC11c2VybmFtZTpiYWNrZW5kLXBhc3N3b3Jk
```

### 🔐 Credential Storage

**Key-Value Maps (KVM)**:
```xml
<KeyValueMapOperations name="GetCredentials">
  <Get assignTo="private.backend.username">
    <Key>
      <Parameter>backend_username</Parameter>
    </Key>
  </Get>
  <Get assignTo="private.backend.password">
    <Key>
      <Parameter>backend_password</Parameter>
    </Key>
  </Get>
  <MapIdentifier>backend-credentials</MapIdentifier>
</KeyValueMapOperations>
```

**Then Use in BasicAuthentication**:
```xml
<BasicAuthentication name="EncodeBackendAuth">
  <Operation>Encode</Operation>
  <User ref="private.backend.username"/>
  <Password ref="private.backend.password"/>
</BasicAuthentication>
```

### ⚠️ Limitations of Basic Auth

| Issue | Description |
|-------|-------------|
| **Not Encrypted** | Credentials in base64 (easily decoded) |
| **Sent Every Request** | No token/session concept |
| **Credential Exposure** | Credentials travel with every request |
| **No Expiration** | Credentials valid until changed |
| **Scalability** | Difficult to manage across many services |

> [!WARNING]
> **Basic Auth is NOT robust for production APIs**. Use OAuth2 or JWT for better security.

### 💡 Key Concepts

**Base64 is NOT Encryption**:
```
dXNlcm5hbWU6cGFzc3dvcmQ= → username:password (easily decoded)
```

**Always Use HTTPS**:
- Basic Auth over HTTP = credentials in plain text
- HTTPS encrypts the entire request
- Still not ideal, but better than nothing

**When to Use Basic Auth**:
- ✅ Internal services (behind firewall)
- ✅ Backend authentication (proxy-to-backend)
- ✅ Simple dev/test environments
- ❌ Public-facing APIs
- ❌ Production environments

---

## 8.3 Understand OAuth2 Flow

### 🎯 OAuth2 Overview

**OAuth2** = **Open Authorization 2.0**

**Purpose**: Delegated authorization framework allowing third-party apps to access resources without exposing credentials.

**Real-World Example**:
```
Spotify using Google Sign-In
    ↓
User authenticates with Google (IDP)
    ↓
Google authorizes Spotify to access user data
    ↓
Spotify never sees Google password
```

### 🆚 SAML vs. OAuth2

| Aspect | SAML | OAuth2 |
|--------|------|--------|
| **Primary Use** | Enterprise SSO | Delegated Authorization |
| **Best For** | Federated authentication | Third-party app access |
| **Token Type** | SAML Assertion (XML) | Access Token (often JWT) |
| **Complexity** | More complex | Simpler |
| **Use Case** | Company apps | Public APIs, mobile apps |

**Both**: Implement Single Sign-On (SSO), but for different scenarios.

### 🔄 OAuth2 Grant Types

#### 1. Authorization Code Flow

**Use Case**: User explicitly approves access (most secure).

**Flow**:
```mermaid
sequenceDiagram
    participant User
    participant Client
    participant AuthServer as Authorization Server
    participant Resource
    
    Client->>AuthServer: 1. Request authorization<br/>(client_id, scope)
    AuthServer->>User: 2. Login prompt
    User->>AuthServer: 3. Authenticate + approve
    AuthServer->>Client: 4. Authorization code
    Client->>AuthServer: 5. Exchange code for token<br/>(client_id, client_secret, code)
    AuthServer->>Client: 6. Access token + refresh token
    Client->>Resource: 7. Request with access token
    Resource->>Client: 8. Protected data
```

**Steps Explained**:

**Step 1**: Client requests authorization
```http
GET /authorize?
  response_type=code&
  client_id=abc123&
  redirect_uri=https://client.com/callback&
  scope=read_profile
```

**Step 2-3**: User authenticates and approves

**Step 4**: Authorization server returns code
```http
HTTP/1.1 302 Found
Location: https://client.com/callback?code=xyz789
```

**Step 5**: Client exchanges code for token
```http
POST /token
Content-Type: application/x-www-form-urlencoded

grant_type=authorization_code&
code=xyz789&
client_id=abc123&
client_secret=secret456&
redirect_uri=https://client.com/callback
```

**Step 6**: Authorization server returns tokens
```json
{
  "access_token": "eyJhbGciOiJSUzI1NiIs...",
  "refresh_token": "tGzv3JOkF0XG5Qx2TlKWIA",
  "token_type": "Bearer",
  "expires_in": 3600
}
```

**Step 7-8**: Client uses access token
```http
GET /api/profile
Authorization: Bearer eyJhbGciOiJSUzI1NiIs...
```

#### 2. Client Credentials Flow

**Use Case**: Machine-to-machine communication (no user involvement).

**Flow**:
```mermaid
sequenceDiagram
    participant Client
    participant AuthServer as Authorization Server
    participant Resource
    
    Client->>AuthServer: 1. Request token<br/>(client_id, client_secret)
    AuthServer->>Client: 2. Access token
    Client->>Resource: 3. Request with access token
    Resource->>Client: 4. Protected data
```

**Step 1**: Client requests token
```http
POST /token
Content-Type: application/x-www-form-urlencoded

grant_type=client_credentials&
client_id=abc123&
client_secret=secret456&
scope=default
```

**Step 2**: Authorization server returns token
```json
{
  "access_token": "eyJhbGciOiJSUzI1NiIs...",
  "token_type": "Bearer",
  "expires_in": 3600
}
```

**No Authorization Code**: Direct token issuance (no user approval needed).

### 🔑 OAuth2 Components

**Client ID**:
- Public identifier for the client application
- Like a username for the app
- Safe to expose

**Client Secret**:
- Confidential key for the client
- Like a password for the app
- Must be kept secret

**Scope**:
- Permissions requested by client
- Examples: `read_profile`, `write_posts`, `admin`
- User approves specific scopes

**Authorization Code**:
- Temporary code representing user's approval
- Short-lived (typically 10 minutes)
- One-time use only

**Access Token**:
- Proof of authorization
- Used to access protected resources
- Short-lived (typically 1 hour)
- Can be opaque or JWT

**Refresh Token**:
- Used to obtain new access tokens
- Long-lived (days/months)
- More secure than storing credentials

### 🎫 Access Token vs. JWT

**Access Token** (Generic):
- Can be any format
- Opaque string or structured
- Server validates against database

**JWT** (Specific Type):
- JSON Web Token
- Self-contained (includes claims)
- Cryptographically signed
- Can be validated without database lookup

**Relationship**:
```
Access Token (generic term)
    ├── Opaque Token (random string)
    └── JWT (structured, signed JSON)
```

### 💡 Key Concepts

**OAuth2 is NOT Authentication**:
- OAuth2 = Authorization (what you can do)
- OpenID Connect (OIDC) = Authentication (who you are)
- OIDC is built on top of OAuth2

**Token Lifecycle**:
```
Access Token Expires
    ↓
Client uses Refresh Token
    ↓
New Access Token + New Refresh Token
    ↓
Continue accessing resources
```

**Security Benefits**:
- ✅ Credentials never shared with third parties
- ✅ Limited scope of access
- ✅ Revocable access (revoke tokens)
- ✅ Time-limited access (token expiration)

---

## 8.4 Create and Test Proxy-based OAuth2 Server

### 🏗️ Building OAuth2 Server in Apigee

**Goal**: Create an Apigee proxy that acts as an Authorization Server.

**Policies Used**:
- `OAuthV2` - Generate and manage OAuth2 tokens
- `VerifyAPIKey` - Validate client credentials

### 🔧 Implementation Steps

#### Step 1: Create OAuth Proxy

**Proxy Configuration**:
```yaml
Name: oauth-server
Base Path: /oauth
Target: (none - no backend needed)
```

#### Step 2: Add OAuthV2 Policy (Token Generation)

**Policy: GenerateAccessToken**
```xml
<OAuthV2 name="GenerateAccessToken">
  <Operation>GenerateAccessToken</Operation>
  <ExpiresIn>3600000</ExpiresIn> <!-- 1 hour in milliseconds -->
  <RefreshTokenExpiresIn>86400000</RefreshTokenExpiresIn> <!-- 24 hours -->
  <SupportedGrantTypes>
    <GrantType>client_credentials</GrantType>
  </SupportedGrantTypes>
  <GenerateResponse enabled="true"/>
  <GrantType>request.formparam.grant_type</GrantType>
</OAuthV2>
```

**Parameters**:
- `ExpiresIn`: Access token lifetime (milliseconds)
- `RefreshTokenExpiresIn`: Refresh token lifetime
- `SupportedGrantTypes`: Allowed grant types
- `GenerateResponse`: Auto-generate JSON response

#### Step 3: Create Conditional Flow

**Flow: /token (POST)**
```xml
<Flow name="GenerateToken">
  <Condition>(proxy.pathsuffix MatchesPath "/token") and (request.verb = "POST")</Condition>
  <Request>
    <Step>
      <Name>VerifyAPIKey</Name>
    </Step>
    <Step>
      <Name>GenerateAccessToken</Name>
    </Step>
  </Request>
  <Response/>
</Flow>
```

**Flow Logic**:
```
1. Client sends POST /oauth/token with API key
2. VerifyAPIKey validates client credentials
3. GenerateAccessToken creates access token
4. Response contains access token
```

#### Step 4: Configure VerifyAPIKey

**Policy**:
```xml
<VerifyAPIKey name="VerifyAPIKey">
  <APIKey ref="request.header.apikey"/>
</VerifyAPIKey>
```

**Purpose**: Validate client before issuing token.

### 🧪 Testing OAuth2 Server

#### Test 1: Client Credentials Flow

**Request**:
```http
POST https://org-eval.apigee.net/oauth/token
Content-Type: application/x-www-form-urlencoded
apikey: <your-api-key>

grant_type=client_credentials
```

**Response**:
```json
{
  "access_token": "A1B2C3D4E5F6G7H8I9J0",
  "token_type": "Bearer",
  "expires_in": 3599,
  "refresh_token": "Z9Y8X7W6V5U4T3S2R1Q0"
}
```

**Token Storage**:
- Apigee stores tokens in internal datastore
- Associated with API key (client credentials)
- Automatically managed (expiration, revocation)

### 🔍 Token Details

**Access Token Properties**:
```
Token: A1B2C3D4E5F6G7H8I9J0
Type: Opaque (not JWT)
Lifetime: 1 hour
Scope: Default (or specified)
Associated with: API Key (client)
```

**Refresh Token**:
```
Token: Z9Y8X7W6V5U4T3S2R1Q0
Lifetime: 24 hours
Purpose: Obtain new access tokens
```

### 📊 OAuth2 Policy Operations

| Operation | Purpose |
|-----------|---------|
| `GenerateAccessToken` | Issue new access token |
| `GenerateAuthorizationCode` | Issue authorization code |
| `GenerateAccessTokenImplicit` | Implicit grant flow |
| `RefreshAccessToken` | Refresh expired token |
| `VerifyAccessToken` | Validate access token |

### 💡 Key Concepts

**Apigee as Authorization Server**:
- Apigee manages token lifecycle
- No external database needed
- Tokens stored in Apigee datastore
- Automatic expiration handling

**Client Credentials = API Key**:
- In this implementation, API key serves as client credentials
- API key validated before token issuance
- Token associated with app (API key owner)

**Opaque Tokens**:
- Random string, not JWT
- Must be validated against Apigee datastore
- Cannot be decoded/inspected
- More secure (no information leakage)

---

## 8.5 Verify Access Token on Resource Proxy

### 🔐 Protecting Resources with OAuth2

**Goal**: Validate OAuth2 access tokens on resource proxies.

**Policy**: `OAuthV2` (VerifyAccessToken operation)

### 🔧 Implementation

#### Step 1: Add VerifyAccessToken Policy

**Policy Configuration**:
```xml
<OAuthV2 name="VerifyAccessToken">
  <Operation>VerifyAccessToken</Operation>
  <AccessToken ref="request.header.Authorization"/>
</OAuthV2>
```

**Placement**: Proxy Request Flow (before target call)

#### Step 2: Extract Token from Header

**Problem**: Authorization header contains `Bearer <token>`, but policy needs only `<token>`.

**Solution**: Extract Variables policy

```xml
<ExtractVariables name="ExtractOAuthToken">
  <Source>request.header.Authorization</Source>
  <Pattern ignoreCase="true">Bearer {access_token}</Pattern>
  <VariablePrefix>oauth</VariablePrefix>
</ExtractVariables>
```

**Result**: `oauth.access_token` variable contains token only.

**Updated VerifyAccessToken**:
```xml
<OAuthV2 name="VerifyAccessToken">
  <Operation>VerifyAccessToken</Operation>
  <AccessToken ref="oauth.access_token"/>
</OAuthV2>
```

#### Step 3: Remove Authorization Header

**Policy**: AssignMessage

```xml
<AssignMessage name="RemoveAuthHeader">
  <Remove>
    <Headers>
      <Header name="Authorization"/>
    </Headers>
  </Remove>
</AssignMessage>
```

**Why**: Prevent token from reaching backend (security best practice).

### 🧪 Testing Resource Access

#### Test 1: Get Access Token

**Request**:
```http
POST https://org-eval.apigee.net/oauth/token
apikey: <your-api-key>

grant_type=client_credentials
```

**Response**:
```json
{
  "access_token": "A1B2C3D4E5F6G7H8I9J0",
  "expires_in": 3600
}
```

#### Test 2: Access Resource with Token

**Request**:
```http
GET https://org-eval.apigee.net/httpbin/v1/get
Authorization: Bearer A1B2C3D4E5F6G7H8I9J0
```

**Response**: ✅ Success (200 OK)

#### Test 3: Invalid Token

**Request**:
```http
GET https://org-eval.apigee.net/httpbin/v1/get
Authorization: Bearer INVALID_TOKEN
```

**Response**: ❌ Error (401 Unauthorized)
```json
{
  "fault": {
    "faultstring": "Invalid Access Token",
    "detail": {
      "errorcode": "oauth.v2.InvalidAccessToken"
    }
  }
}
```

#### Test 4: Expired Token

**After 1 hour**:
```http
GET https://org-eval.apigee.net/httpbin/v1/get
Authorization: Bearer A1B2C3D4E5F6G7H8I9J0
```

**Response**: ❌ Error (401 Unauthorized)
```json
{
  "fault": {
    "faultstring": "Access Token expired",
    "detail": {
      "errorcode": "oauth.v2.AccessTokenExpired"
    }
  }
}
```

### 🔄 Token Refresh Flow

**When Access Token Expires**:

**Request**:
```http
POST https://org-eval.apigee.net/oauth/token
Content-Type: application/x-www-form-urlencoded

grant_type=refresh_token&
refresh_token=Z9Y8X7W6V5U4T3S2R1Q0
```

**Response**:
```json
{
  "access_token": "K1L2M3N4O5P6Q7R8S9T0",
  "refresh_token": "U1V2W3X4Y5Z6A7B8C9D0",
  "expires_in": 3600
}
```

### 💡 Key Concepts

**Token Validation**:
- Apigee checks token against internal datastore
- Validates expiration, revocation status
- No external calls needed
- Fast validation

**Security Flow**:
```
1. Extract token from Bearer header
2. Verify token validity
3. Remove Authorization header
4. Forward request to backend
```

**Why Remove Authorization Header**:
- Backend doesn't need to see token
- Reduces information exposure
- Backend trusts Apigee validation
- Cleaner backend implementation

---

## 8.6-8.7 Okta OAuth2 Setup and VerifyJWT Policy

### 🏢 External Identity Provider Integration

**Goal**: Use Okta (or Azure AD) as OAuth2 Authorization Server instead of Apigee proxy.

**Benefits**:
- Enterprise-grade identity management
- Centralized user management
- Industry standard approach
- JWT tokens (self-contained)

### 🔧 Okta Configuration

#### Step 1: Create OAuth2 Application

**Okta Admin Console**:
```
Applications → Create App Integration
    ↓
OIDC (OpenID Connect)
    ↓
Web Application
    ↓
Name: Apigee Course OAuth2
```

**Grant Types**:
- ☑ Client Credentials
- ☑ Authorization Code

**Redirect URI**:
```
https://oauth.pstmn.io/v1/callback
```
(Postman callback URL)

**Result**:
- **Client ID**: `0oa1b2c3d4e5f6g7h8i9`
- **Client Secret**: `secret_abc123xyz789`

#### Step 2: Configure Authorization Server

**Navigate to**:
```
Security → API → Authorization Servers → default
```

**Key Information**:
- **Issuer**: `https://dev-123456.okta.com/oauth2/default`
- **Authorization Endpoint**: `https://dev-123456.okta.com/oauth2/default/v1/authorize`
- **Token Endpoint**: `https://dev-123456.okta.com/oauth2/default/v1/token`
- **JWKS URI**: `https://dev-123456.okta.com/oauth2/default/v1/keys`

**Metadata URL**:
```
https://dev-123456.okta.com/oauth2/default/.well-known/oauth-authorization-server
```

#### Step 3: Create Scopes

**Scope 1: httpbin_read**
```yaml
Name: httpbin_read
Display Phrase: Access to HTTP Bin API
Description: Read access to HTTP Bin resources
User Consent: Required
Include in Public Metadata: Yes
```

**Scope 2: default**
```yaml
Name: default
Display Phrase: Default scope
Description: Default scope for client credentials
User Consent: Implicit
Default Scope: Yes
Include in Public Metadata: Yes
```

#### Step 4: Assign Users/Groups

**Group**: Apigee Portal Users
**Members**: Imran, Wilma, etc.

### 🔐 VerifyJWT Policy

**Purpose**: Validate JWT tokens issued by Okta.

#### Policy Configuration

```xml
<VerifyJWT name="VerifyJWT">
  <Algorithm>RS256</Algorithm>
  <Source>private.jwt</Source>
  <IgnoreUnresolvedVariables>false</IgnoreUnresolvedVariables>
  <PublicKey>
    <JWKS uri="https://dev-123456.okta.com/oauth2/default/v1/keys"/>
  </PublicKey>
  <Issuer>https://dev-123456.okta.com/oauth2/default</Issuer>
  <Audience>api://default</Audience>
  <AdditionalClaims>
    <Claim name="scp" type="string">httpbin_read</Claim>
  </AdditionalClaims>
</VerifyJWT>
```

**Parameters Explained**:

**Algorithm**: `RS256`
- RSA Signature with SHA-256
- Asymmetric encryption
- Public key verifies signature

**Source**: `private.jwt`
- Variable containing JWT token
- Extracted from Authorization header

**JWKS URI**:
- JSON Web Key Set endpoint
- Contains public keys for verification
- Apigee fetches keys automatically

**Issuer**:
- Who issued the token (Okta)
- Must match `iss` claim in JWT
- Prevents token from other issuers

**Audience**:
- Intended recipient of token
- Must match `aud` claim in JWT
- Prevents token misuse

**AdditionalClaims**:
- Custom claim validation
- `scp` (scope) must contain `httpbin_read`
- Ensures proper permissions

#### Extract JWT from Bearer Header

```xml
<ExtractVariables name="ExtractJWT">
  <Source>request.header.Authorization</Source>
  <Pattern ignoreCase="true">Bearer {jwt}</Pattern>
  <VariablePrefix>private</VariablePrefix>
</ExtractVariables>
```

> [!IMPORTANT]
> **Use `private` prefix** to prevent JWT from appearing in debug traces. JWTs contain sensitive information.

#### Remove Authorization Header

```xml
<AssignMessage name="RemoveAuthHeader">
  <Remove>
    <Headers>
      <Header name="Authorization"/>
    </Headers>
  </Remove>
</AssignMessage>
```

### 🧪 Testing Okta OAuth2

#### Test 1: Client Credentials Flow

**Request**:
```http
POST https://dev-123456.okta.com/oauth2/default/v1/token
Content-Type: application/x-www-form-urlencoded
Authorization: Basic <base64(client_id:client_secret)>

grant_type=client_credentials&
scope=httpbin_read
```

**Response**:
```json
{
  "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IjEyMyJ9.eyJpc3MiOiJodHRwczovL2Rldi0xMjM0NTYub2t0YS5jb20vb2F1dGgyL2RlZmF1bHQiLCJhdWQiOiJhcGk6Ly9kZWZhdWx0Iiwic2NwIjpbImh0dHBiaW5fcmVhZCJdLCJleHAiOjE2MzAwMDAwMDAsImlhdCI6MTYyOTk5NjQwMH0.signature",
  "token_type": "Bearer",
  "expires_in": 3600,
  "scope": "httpbin_read"
}
```

**Token Type**: JWT (not opaque)

#### Test 2: Authorization Code Flow

**Step 1: Get Authorization Code**:
```http
GET https://dev-123456.okta.com/oauth2/default/v1/authorize?
  client_id=0oa1b2c3d4e5f6g7h8i9&
  response_type=code&
  scope=httpbin_read&
  redirect_uri=https://oauth.pstmn.io/v1/callback&
  state=random_state_string
```

**Step 2: User Login & Approval**
- Okta login page appears
- User authenticates
- User approves scope
- Redirected with code

**Step 3: Exchange Code for Token**:
```http
POST https://dev-123456.okta.com/oauth2/default/v1/token
Content-Type: application/x-www-form-urlencoded
Authorization: Basic <base64(client_id:client_secret)>

grant_type=authorization_code&
code=<authorization_code>&
redirect_uri=https://oauth.pstmn.io/v1/callback
```

**Response**:
```json
{
  "access_token": "eyJhbGci...",
  "id_token": "eyJhbGci...",
  "refresh_token": "tGzv3JOkF0XG5Qx2TlKWIA",
  "token_type": "Bearer",
  "expires_in": 3600,
  "scope": "httpbin_read openid"
}
```

#### Test 3: Access Resource with JWT

**Request**:
```http
GET https://org-eval.apigee.net/httpbin/v4/get
Authorization: Bearer eyJhbGciOiJSUzI1NiIs...
```

**Apigee Flow**:
```
1. ExtractJWT extracts token
2. VerifyJWT validates:
   - Signature (using JWKS)
   - Issuer (Okta)
   - Audience (api://default)
   - Expiration
   - Scope (httpbin_read)
3. RemoveAuthHeader removes header
4. Request forwarded to backend
```

**Response**: ✅ Success (200 OK)

### 🔍 Understanding JWT Structure

**JWT Format**:
```
header.payload.signature
```

**Example JWT**:
```
eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IjEyMyJ9
.
eyJpc3MiOiJodHRwczovL2Rldi0xMjM0NTYub2t0YS5jb20vb2F1dGgyL2RlZmF1bHQiLCJhdWQiOiJhcGk6Ly9kZWZhdWx0Iiwic2NwIjpbImh0dHBiaW5fcmVhZCJdLCJleHAiOjE2MzAwMDAwMDAsImlhdCI6MTYyOTk5NjQwMH0
.
<signature>
```

**Decoded Header**:
```json
{
  "alg": "RS256",
  "typ": "JWT",
  "kid": "123"
}
```

**Decoded Payload**:
```json
{
  "iss": "https://dev-123456.okta.com/oauth2/default",
  "aud": "api://default",
  "scp": ["httpbin_read"],
  "exp": 1630000000,
  "iat": 1629996400,
  "sub": "user@example.com",
  "cid": "0oa1b2c3d4e5f6g7h8i9"
}
```

**Claims Explained**:
- `iss`: Issuer (Okta)
- `aud`: Audience (intended recipient)
- `scp`: Scopes (permissions)
- `exp`: Expiration timestamp
- `iat`: Issued at timestamp
- `sub`: Subject (user identifier)
- `cid`: Client ID

**Signature**:
- Created using private key (Okta)
- Verified using public key (JWKS)
- Ensures token integrity
- Prevents tampering

### 💡 Key Concepts

**JWT vs. Opaque Token**:

| Aspect | JWT | Opaque Token |
|--------|-----|--------------|
| **Format** | JSON (base64-encoded) | Random string |
| **Self-contained** | Yes (contains claims) | No (database lookup) |
| **Validation** | Signature verification | Database query |
| **Size** | Larger (~1KB) | Smaller (~32 bytes) |
| **Information** | Readable (base64 decode) | No information |

**JWKS (JSON Web Key Set)**:
- Public keys for JWT verification
- Hosted by authorization server
- Apigee fetches automatically
- Cached for performance

**Why Use External IDP**:
- ✅ Enterprise user management
- ✅ Centralized authentication
- ✅ Advanced security features
- ✅ Compliance requirements
- ✅ Industry standard

---

## 8.8 IP Filtering and RegEx Security

### 🌐 IP Filtering with Access Control Policy

**Purpose**: Allow/deny requests based on client IP address.

**Policy**: `AccessControl`

#### Allow Specific IPs

```xml
<AccessControl name="IPWhitelist">
  <IPRules noRuleMatchAction="DENY">
    <MatchRule action="ALLOW">
      <SourceAddress mask="32">203.0.113.10</SourceAddress>
    </MatchRule>
    <MatchRule action="ALLOW">
      <SourceAddress mask="24">198.51.100.0</SourceAddress>
    </MatchRule>
  </IPRules>
</AccessControl>
```

**Behavior**:
- Allow `203.0.113.10` (single IP)
- Allow `198.51.100.0/24` (256 IPs: 198.51.100.0 - 198.51.100.255)
- Deny all others (`noRuleMatchAction="DENY"`)

#### Block Specific IPs

```xml
<AccessControl name="IPBlacklist">
  <IPRules noRuleMatchAction="ALLOW">
    <MatchRule action="DENY">
      <SourceAddress mask="32">192.0.2.50</SourceAddress>
    </MatchRule>
  </IPRules>
</AccessControl>
```

**Behavior**:
- Deny `192.0.2.50`
- Allow all others (`noRuleMatchAction="ALLOW"`)

#### CIDR Notation

**Mask Values**:
- `32`: Single IP (255.255.255.255)
- `24`: 256 IPs (255.255.255.0)
- `16`: 65,536 IPs (255.255.0.0)
- `8`: 16,777,216 IPs (255.0.0.0)

**Examples**:
```
10.0.0.1/32   → 10.0.0.1 only
10.0.0.0/24   → 10.0.0.0 - 10.0.0.255
10.0.0.0/16   → 10.0.0.0 - 10.0.255.255
```

### 🛡️ RegEx Threat Protection

**Purpose**: Prevent SQL injection, XSS, and other pattern-based attacks.

**Policy**: `RegularExpressionProtection`

#### Configuration

```xml
<RegularExpressionProtection name="RegexProtection">
  <Source>request.content</Source>
  <Pattern>[\s]*((delete)|(exec)|(drop\s*table)|(insert)|(shutdown)|(update)|(\bor\b))</Pattern>
  <IgnoreCase>true</IgnoreCase>
</RegularExpressionProtection>
```

**Detects**:
- SQL keywords: `DELETE`, `DROP TABLE`, `INSERT`, `UPDATE`
- SQL injection: `OR 1=1`, `EXEC`, `SHUTDOWN`

**Example Attack**:
```http
POST /api/users
Content-Type: application/json

{
  "username": "admin' OR '1'='1",
  "password": "anything"
}
```

**Result**: ❌ Request blocked (regex match detected)

#### Multiple Patterns

```xml
<RegularExpressionProtection name="AdvancedRegexProtection">
  <Source>request.content</Source>
  <Pattern>[\s]*((delete)|(exec)|(drop\s*table)|(insert)|(shutdown)|(update)|(\bor\b))</Pattern>
  <Pattern>\u003cscript\u003e.*\u003c/script\u003e</Pattern>
  <Pattern>javascript:</Pattern>
  <IgnoreCase>true</IgnoreCase>
</RegularExpressionProtection>
```

**Additional Protection**:
- XSS: `<script>alert('XSS')</script>`
- JavaScript injection: `javascript:alert('XSS')`

#### Check Headers and Query Params

```xml
<RegularExpressionProtection name="HeaderRegexProtection">
  <Source>request.header.User-Agent</Source>
  <Pattern>(bot|crawler|spider)</Pattern>
  <IgnoreCase>true</IgnoreCase>
</RegularExpressionProtection>
```

```xml
<RegularExpressionProtection name="QueryParamRegexProtection">
  <Source>request.queryparam.search</Source>
  <Pattern>[\s]*((delete)|(drop)|(insert))</Pattern>
  <IgnoreCase>true</IgnoreCase>
</RegularExpressionProtection>
```

### 💡 Key Concepts

**IP Filtering Use Cases**:
- ✅ Internal APIs (allow corporate IPs only)
- ✅ Partner APIs (allow partner IPs)
- ✅ Block malicious IPs
- ✅ Geo-restriction (combined with other policies)

**RegEx Protection Use Cases**:
- ✅ SQL injection prevention
- ✅ XSS attack prevention
- ✅ Command injection prevention
- ✅ Input validation

**Performance Considerations**:
- IP filtering is fast (simple comparison)
- RegEx can be slow (complex patterns)
- Test regex patterns for performance
- Use specific patterns (avoid `.*`)

---

## 8.9 JSON and XML Threat Protection Policies

### 🛡️ JSON Threat Protection

**Purpose**: Prevent attacks via malicious JSON payloads.

**Policy**: `JSONThreatProtection`

#### Configuration

```xml
<JSONThreatProtection name="JSONThreatProtection">
  <ArrayElementCount>100</ArrayElementCount>
  <ContainerDepth>10</ContainerDepth>
  <ObjectEntryCount>50</ObjectEntryCount>
  <ObjectEntryNameLength>100</ObjectEntryNameLength>
  <Source>request</Source>
  <StringValueLength>500</StringValueLength>
</JSONThreatProtection>
```

**Parameters Explained**:

**ArrayElementCount**: `100`
```json
// Allowed (50 elements)
{"items": [1, 2, 3, ..., 50]}

// Blocked (150 elements)
{"items": [1, 2, 3, ..., 150]}
```

**ContainerDepth**: `10`
```json
// Allowed (depth = 3)
{"a": {"b": {"c": "value"}}}

// Blocked (depth = 12)
{"a": {"b": {"c": {"d": {"e": {"f": {"g": {"h": {"i": {"j": {"k": {"l": "value"}}}}}}}}}}}
```

**ObjectEntryCount**: `50`
```json
// Allowed (30 properties)
{"prop1": "val1", "prop2": "val2", ..., "prop30": "val30"}

// Blocked (60 properties)
{"prop1": "val1", "prop2": "val2", ..., "prop60": "val60"}
```

**ObjectEntryNameLength**: `100`
```json
// Allowed
{"username": "john"}

// Blocked
{"this_is_a_very_long_property_name_that_exceeds_one_hundred_characters_and_should_be_blocked": "value"}
```

**StringValueLength**: `500`
```json
// Allowed
{"description": "Short description"}

// Blocked
{"description": "Very long description that exceeds 500 characters..."}
```

#### Attack Scenarios

**Scenario 1: Billion Laughs Attack**
```json
{
  "data": [
    [[[[[[[[[["value"]]]]]]]]]]
  ]
}
```
**Protection**: `ContainerDepth` limit

**Scenario 2: Large Array Attack**
```json
{
  "items": [1, 2, 3, ..., 1000000]
}
```
**Protection**: `ArrayElementCount` limit

**Scenario 3: Memory Exhaustion**
```json
{
  "prop1": "A".repeat(1000000),
  "prop2": "B".repeat(1000000),
  ...
}
```
**Protection**: `StringValueLength` + `ObjectEntryCount` limits

### 🛡️ XML Threat Protection

**Purpose**: Prevent attacks via malicious XML payloads.

**Policy**: `XMLThreatProtection`

#### Configuration

```xml
<XMLThreatProtection name="XMLThreatProtection">
  <NameLimits>
    <Element>100</Element>
    <Attribute>50</Attribute>
    <NamespacePrefix>10</NamespacePrefix>
    <ProcessingInstructionTarget>50</ProcessingInstructionTarget>
  </NameLimits>
  <Source>request</Source>
  <StructureLimits>
    <NodeDepth>10</NodeDepth>
    <AttributeCountPerElement>10</AttributeCountPerElement>
    <NamespaceCountPerElement>5</NamespaceCountPerElement>
    <ChildCount includeComment="true" includeElement="true" includeProcessingInstruction="true" includeText="true">100</ChildCount>
  </StructureLimits>
  <ValueLimits>
    <Text>1000</Text>
    <Attribute>100</Attribute>
    <NamespaceURI>100</NamespaceURI>
    <Comment>500</Comment>
    <ProcessingInstructionData>500</ProcessingInstructionData>
  </ValueLimits>
</XMLThreatProtection>
```

**Parameters Explained**:

**NodeDepth**: `10`
```xml
<!-- Allowed (depth = 3) -->
<root>
  <level1>
    <level2>value</level2>
  </level1>
</root>

<!-- Blocked (depth = 12) -->
<root><l1><l2><l3><l4><l5><l6><l7><l8><l9><l10><l11>value</l11></l10></l9></l8></l7></l6></l5></l4></l3></l2></l1></root>
```

**AttributeCountPerElement**: `10`
```xml
<!-- Allowed -->
<user id="1" name="John" email="john@example.com"/>

<!-- Blocked (15 attributes) -->
<user attr1="val1" attr2="val2" ... attr15="val15"/>
```

**ChildCount**: `100`
```xml
<!-- Allowed (50 children) -->
<items>
  <item>1</item>
  <item>2</item>
  ...
  <item>50</item>
</items>

<!-- Blocked (150 children) -->
<items>
  <item>1</item>
  ...
  <item>150</item>
</items>
```

#### Attack Scenarios

**Scenario 1: XML Bomb (Billion Laughs)**
```xml
<?xml version="1.0"?>
<!DOCTYPE lolz [
  <!ENTITY lol "lol">
  <!ENTITY lol2 "&lol;&lol;&lol;&lol;&lol;&lol;&lol;&lol;&lol;&lol;">
  <!ENTITY lol3 "&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;">
]>
<lolz>&lol3;</lolz>
```
**Protection**: `NodeDepth` + `ChildCount` limits

**Scenario 2: External Entity Injection (XXE)**
```xml
<?xml version="1.0"?>
<!DOCTYPE foo [
  <!ENTITY xxe SYSTEM "file:///etc/passwd">
]>
<data>&xxe;</data>
```
**Protection**: Apigee disables external entities by default

### 💡 Key Concepts

**Why Threat Protection**:
- Prevent DoS attacks (resource exhaustion)
- Prevent memory exhaustion
- Prevent CPU exhaustion
- Validate input structure

**Performance Impact**:
- Minimal (simple checks)
- Applied early in flow
- Fails fast on violation
- Protects backend from malicious payloads

**Best Practices**:
- ✅ Apply on all public-facing APIs
- ✅ Set limits based on legitimate use cases
- ✅ Test with realistic payloads
- ✅ Monitor for false positives
- ✅ Adjust limits as needed

---

## 8.10 Debug Masks

### 🎭 Debug Masks Overview

**Purpose**: Hide sensitive data in debug sessions and trace logs.

**Problem**: Debug sessions expose all data (passwords, tokens, PII).

**Solution**: Configure debug masks to redact sensitive information.

### 🔧 Configuration

**Navigate to**:
```
Apigee → Admin → Environments → eval → Debug Masks
```

#### Mask Types

**1. Request/Response Headers**
```xml
<DebugMask>
  <Namespaces/>
  <FaultJSONPaths/>
  <FaultXMLPaths/>
  <RequestJSONPaths/>
  <RequestXMLPaths/>
  <ResponseJSONPaths/>
  <ResponseXMLPaths/>
  <Variables>
    <Variable>request.header.Authorization</Variable>
    <Variable>request.header.apikey</Variable>
  </Variables>
</DebugMask>
```

**Result**: Authorization and apikey headers show as `*****` in traces.

**2. JSON Paths**
```xml
<ResponseJSONPaths>
  <JSONPath>$.password</JSONPath>
  <JSONPath>$.creditCard</JSONPath>
  <JSONPath>$.ssn</JSONPath>
</ResponseJSONPaths>
```

**Example Response**:
```json
{
  "username": "john",
  "password": "*****",
  "creditCard": "*****"
}
```

**3. XML Paths**
```xml
<ResponseXMLPaths>
  <XPath>/user/password</XPath>
  <XPath>/user/ssn</XPath>
</ResponseXMLPaths>
```

**Example Response**:
```xml
<user>
  <username>john</username>
  <password>*****</password>
  <ssn>*****</ssn>
</user>
```

**4. Flow Variables**
```xml
<Variables>
  <Variable>private.backend.password</Variable>
  <Variable>oauth.access_token</Variable>
  <Variable>jwt.token</Variable>
</Variables>
```

### 🔍 Debug Mask vs. Private Variables

| Feature | Debug Mask | Private Variables |
|---------|------------|-------------------|
| **Scope** | Environment-wide | Proxy-specific |
| **Configuration** | Admin → Environments | Variable naming (`private.*`) |
| **Applies To** | All proxies in environment | Specific variables |
| **Granularity** | Headers, JSON/XML paths, variables | Variables only |
| **Use Case** | Org-wide sensitive data | Proxy-specific secrets |

**Private Variables**:
```xml
<AssignMessage name="SetPrivateVar">
  <AssignVariable>
    <Name>private.api.secret</Name>
    <Value>secret123</Value>
  </AssignVariable>
</AssignMessage>
```
**Result**: `private.api.secret` automatically masked in traces.

### 💡 Key Concepts

**What to Mask**:
- ✅ Passwords
- ✅ API keys
- ✅ OAuth tokens
- ✅ JWT tokens
- ✅ Credit card numbers
- ✅ SSN, PII
- ✅ Any sensitive data

**When to Configure**:
- Before deploying to production
- During development (for sensitive APIs)
- After security audit
- When handling PII/PHI

**Compliance**:
- PCI-DSS: Mask credit card data
- HIPAA: Mask health information
- GDPR: Mask personal data
- SOC 2: Mask authentication credentials

---

## Summary

Section 8 covered comprehensive API Security:

### ✅ Authentication & Authorization
- **Basic Authentication**: Username/password (proxy and backend)
- **OAuth2**: Authorization Code and Client Credentials flows
- **Apigee as OAuth Server**: Token generation and validation
- **External IDP Integration**: Okta OAuth2 with JWT
- **VerifyJWT Policy**: JWT signature and claims validation

### ✅ Threat Protection
- **IP Filtering**: Access Control policy for IP whitelisting/blacklisting
- **RegEx Protection**: Prevent SQL injection, XSS attacks
- **JSON Threat Protection**: Limit array size, depth, string length
- **XML Threat Protection**: Prevent XML bombs, XXE attacks

### ✅ Data Confidentiality
- **Debug Masks**: Hide sensitive data in traces
- **Private Variables**: Automatic masking for `private.*` variables
- **Environment-wide Configuration**: Centralized security policies

### ✅ Key Takeaways
- Security is multi-layered (defense in depth)
- OAuth2 and JWT are industry standards
- Always use HTTPS for sensitive data
- Mask sensitive information in logs and traces
- External IDPs provide enterprise-grade security
- Threat protection prevents DoS and injection attacks

These security measures enable organizations to build robust, compliant, and secure API platforms that protect both the infrastructure and end-user data.
